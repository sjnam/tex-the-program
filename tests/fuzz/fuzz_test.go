// 차등 퍼징: 같은 입력을 기준 TeX(main 가지의 tex.w로 만든 것)과 이 가지의 TeX으로
// 조판해, 남긴 파일(DVI, 로그, \openout으로 쓴 파일)과 터미널 출력이 바이트까지 같은지 본다.
// 쪽 내보내기를 비동기식으로 못 박은 실행(TEXDVI=async)도 함께 견주되, 이때는 메모리 통계가
// 달라질 수 있으므로 DVI와 \write로 쓴 파일만 견준다.
//
//	go test ./tests/fuzz                       씨앗 입력만 돌린다
//	go test ./tests/fuzz -fuzz=FuzzSame -fuzztime=10m
//
// 실행 파일은 환경 변수 TEXOURS와 TEXREF로 줄 수 있다. 기본값은 build/tex와 build/ref/tex다
// (make fuzz가 둘 다 만든다). TeX은 전역 상태 때문에 한 프로세스에서 되풀이해 돌릴 수 없으므로
// 입력마다 실행 파일을 띄운다. macOS에서는 sandbox-exec로 가두어 임시 디렉터리 밖에 쓰지 못하게 한다.
package fuzz

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"sync"
	"syscall"
	"testing"
	"time"
)

var seeds = []string{
	`\shipout\hbox{Hello}`,
	`Hello world. This is a paragraph long enough to be broken into a few lines of text by \TeX.\par\bye`,
	`\hsize=100pt \noindent\leaders\hrule\hfill\par
\leaders\hbox{.}\hskip 50pt plus 1fil x\par
\cleaders\hbox{ab}\hskip 40pt\par
\xleaders\hbox to 7pt{\hss.\hss}\hfil\par\bye`,
	`\special{abc}\write-1{w\the\count0}\shipout\vbox{\special{in box}\hbox{\vrule height 2pt\kern1pt x}}\bye`,
	`$a^2+\sqrt{b\over c}$ $$\int_0^1 f(x)\,dx\eqno(1)$$\bye`,
	`\halign{#\hfil&\hfil#\cr a&b\cr ccc&d\cr\noalign{\hrule}}\bye`,
	`\tracingstats=2 A\par\vfill\eject\tracingstats=0 B\par\vfill\eject\tracingstats=1 C\bye`,
	`\tracingonline1\tracingoutput1\showboxdepth9\showboxbreadth99
\shipout\hbox{x\raise2pt\hbox{y}}\bye`,
	`\font\big=cmr10 at 20pt {\big Large} \font\x=cmbx12 \x bold\bye`,
	`\undefined \hbox{\vrule\par} $x\bye`,
	`\vbox to 50pt{\leaders\vbox{\hrule width 10pt\vskip2pt}\vfil}
\vbox to 30pt{\xleaders\vbox to 7pt{\vss\hrule\vss}\vfill}\bye`,
	`\shipout\hbox{\hbox{\hbox{\hbox{a}b}c}\kern-3pt\lower4pt\hbox{d}}\bye`,
	`\shipout\vbox to 20000pt{}\bye`,
	`\shipout\hbox to 100pt{\leaders\hbox{\write-1{L}x}\hfil}\bye`,
	`\char200 \char'177 \accent'177 a\bye`,
	`\count1=5 \count9=-3 \shipout\hbox{a}\count0=7 \shipout\vbox{\hbox{b}}\deadcycles=0 \bye`,
	`\mag=2000 \hoffset=-1in \voffset=10pt \shipout\hbox{m}\bye`,
	`\hbox{\special{\the\hsize}\vrule width 1pt height 1pt depth 1pt}\showlists\bye`,
	`\loop\ifnum\count255<30 \advance\count255 by 1 \hbox{\number\count255}\repeat\bye`,
	`\vsize=50pt \input story `,
}

// 무한 루프에 빠지는 입력도 흔하므로 한 번 돌리는 시간을 짧게 잡는다. 세 번을 동시에 돌리므로
// 입력 하나에 드는 시간도 이 정도다. 퍼징 엔진은 오래 답이 없는 작업 프로세스를 죽여 버린다.
const runTimeout = 2 * time.Second

var (
	setupOnce       sync.Once
	setupErr        error
	oursBin, refBin string
	oursFmt, refFmt string
	sandbox         string
)

// 실행 파일을 찾고, 저마다 plain 포맷을 한 번만 만든다.
func setup() {
	root, _ := filepath.Abs("../..")
	oursBin = envOr("TEXOURS", filepath.Join(root, "build", "tex"))
	refBin = envOr("TEXREF", filepath.Join(root, "build", "ref", "tex"))
	for _, b := range []string{oursBin, refBin} {
		if _, err := os.Stat(b); err != nil {
			setupErr = fmt.Errorf("%s가 없다 (make fuzz가 만든다): %v", b, err)
			return
		}
	}
	dir, err := os.MkdirTemp("", "texfuzz-fmt")
	if err != nil {
		setupErr = err
		return
	}
	if p, err := exec.LookPath("sandbox-exec"); err == nil {
		sandbox = p
	}
	for i, b := range []string{oursBin, refBin} {
		d := filepath.Join(dir, fmt.Sprint(i))
		os.Mkdir(d, 0o755)
		cmd := exec.Command(b, "-ini", "plain", `\dump`)
		cmd.Dir = d
		if out, err := cmd.CombinedOutput(); err != nil {
			setupErr = fmt.Errorf("%s -ini plain: %v\n%s", b, err, out)
			return
		}
		if i == 0 {
			oursFmt = filepath.Join(d, "plain.fmt")
		} else {
			refFmt = filepath.Join(d, "plain.fmt")
		}
	}
}

func envOr(k, v string) string {
	if s := os.Getenv(k); s != "" {
		return s
	}
	return v
}

// 실행 결과: 터미널 출력과, 작업 디렉터리에 새로 생긴 파일들
type result struct {
	timedOut bool
	files    map[string][]byte
}

func run(t *testing.T, bin, fmtFile, doc string, env ...string) result {
	return runFor(t, runTimeout, bin, fmtFile, doc, env...)
}

func runFor(t *testing.T, timeout time.Duration, bin, fmtFile, doc string, env ...string) result {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "t.tex"), []byte(doc), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(fmtFile, filepath.Join(dir, "plain.fmt")); err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	args := []string{bin, "&plain", "t"}
	if sandbox != "" {
		real, _ := filepath.EvalSymlinks(dir)
		profile := fmt.Sprintf(`(version 1)(allow default)(deny file-write*)
(allow file-write* (subpath %q) (subpath "/dev"))`, real)
		args = append([]string{sandbox, "-p", profile}, args...)
	}
	cmd := exec.CommandContext(ctx, args[0], args[1:]...)
	// 시간이 다 되면 프로세스 그룹째 죽인다(TeX이 띄운 kpsewhich까지)
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	cmd.Cancel = func() error { return syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL) }
	cmd.WaitDelay = time.Second
	cmd.Dir = dir
	cmd.Env = append(os.Environ(), env...)
	var out bytes.Buffer
	cmd.Stdout, cmd.Stderr = &out, &out
	cmd.Run()
	r := result{timedOut: ctx.Err() != nil, files: map[string][]byte{"(terminal)": out.Bytes()}}
	ents, _ := os.ReadDir(dir)
	for _, e := range ents {
		if n := e.Name(); n != "t.tex" && n != "plain.fmt" && !e.IsDir() {
			r.files[n], _ = os.ReadFile(filepath.Join(dir, n))
		}
	}
	return r
}

// a와 b에서 이름이 keep을 만족하는 파일들이 같은지 본다.
func compare(t *testing.T, what string, a, b result, keep func(string) bool) {
	var names []string
	for n := range a.files {
		names = append(names, n)
	}
	for n := range b.files {
		if _, ok := a.files[n]; !ok {
			names = append(names, n)
		}
	}
	slices.Sort(names)
	for _, n := range names {
		if !keep(n) {
			continue
		}
		x, okx := a.files[n]
		y, oky := b.files[n]
		if okx != oky {
			t.Errorf("%s: %s가 한쪽에만 있다 (기준 %v, 이쪽 %v)", what, n, okx, oky)
		} else if !bytes.Equal(x, y) {
			t.Errorf("%s: %s가 다르다\n%s", what, n, firstDiff(x, y))
		}
	}
}

func firstDiff(x, y []byte) string {
	xl, yl := strings.Split(string(x), "\n"), strings.Split(string(y), "\n")
	for i := 0; i < max(len(xl), len(yl)); i++ {
		var a, b string
		if i < len(xl) {
			a = xl[i]
		}
		if i < len(yl) {
			b = yl[i]
		}
		if a != b {
			return fmt.Sprintf("  %d번째 줄\n  기준: %.200q\n  이쪽: %.200q", i+1, a, b)
		}
	}
	return "  (줄은 같고 바이트가 다르다)"
}

func FuzzSame(f *testing.F) {
	for _, s := range seeds {
		f.Add(s)
	}
	f.Fuzz(func(t *testing.T, body string) {
		setupOnce.Do(setup)
		if setupErr != nil {
			t.Skip(setupErr)
		}
		if sandbox == "" && strings.Contains(body, "openout") {
			t.Skip("샌드박스가 없으면 \\openout이 든 입력은 돌리지 않는다")
		}
		doc := "\\batchmode\n" + body + "\n\\end\n"
		var ref, ours, async result
		var wg sync.WaitGroup
		wg.Go(func() { ref = run(t, refBin, refFmt, doc) })
		wg.Go(func() { ours = run(t, oursBin, oursFmt, doc) })
		wg.Go(func() { async = run(t, oursBin, oursFmt, doc, "TEXDVI=async") })
		wg.Wait()
		// 보통은 수십 ms면 끝나므로, 모두 시간을 넘기면 무한 루프로 보고 건너뛰고,
		// 일부만 넘기면 수상한 일로 본다.
		if ref.timedOut && ours.timedOut && async.timedOut {
			t.Skip("모두 시간 안에 끝나지 않았다")
		}
		// 일부만 넘겼으면 퍼징 부하 때문일 수 있으니 넘긴 쪽을 넉넉한 시간으로 한 번 더 돌린다
		if ref.timedOut {
			ref = runFor(t, 5*runTimeout, refBin, refFmt, doc)
		}
		if ours.timedOut {
			ours = runFor(t, 5*runTimeout, oursBin, oursFmt, doc)
		}
		if async.timedOut {
			async = runFor(t, 5*runTimeout, oursBin, oursFmt, doc, "TEXDVI=async")
		}
		if ref.timedOut || ours.timedOut || async.timedOut {
			t.Fatalf("일부만 시간 안에 끝났다 (기준 %v, 이 가지 %v, 비동기식 %v)",
				!ref.timedOut, !ours.timedOut, !async.timedOut)
		}
		compare(t, "기준과 이 가지", ref, ours, func(string) bool { return true })
		compare(t, "기준과 비동기식", ref, async, func(n string) bool {
			return n != "(terminal)" && n != "t.log"
		})
	})
}

// 하네스가 제대로 도는지 본다: 두 TeX 모두 쪽 하나짜리 DVI를 남겨야 한다.
func TestHarness(t *testing.T) {
	setupOnce.Do(setup)
	if setupErr != nil {
		t.Skip(setupErr)
	}
	doc := "\\batchmode\nHello\\bye\n"
	for _, r := range []result{run(t, refBin, refFmt, doc), run(t, oursBin, oursFmt, doc)} {
		if len(r.files["t.dvi"]) == 0 || !bytes.Contains(r.files["t.log"], []byte("(1 page")) {
			t.Fatalf("DVI가 생기지 않았다:\n%s", r.files["(terminal)"])
		}
	}
}
