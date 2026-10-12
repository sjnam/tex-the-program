# TeX: 한글 GWEB 판

도널드 크누스(Donald E. Knuth)의 조판 프로그램 TeX의 문학적 프로그램 `tex.web`(판 3.141592653)을
한글과 Go로 옮긴 것이다. 원본은 영어 설명과 Pascal 코드로 되어 있는데, 이 번역은 설명을 한글로,
코드를 Go로 바꾸어 GWEB(Go로 쓰는 WEB)의 `.w` 파일 하나(`tex.w`)에 담았다.

옮긴 목적은 TeX을 온전히 이해하는 것, 특히 그 안에 담긴 알고리즘들을 깊이 읽는 것이다.
그래서 원본에 될 수 있는 대로 충실하게 옮겼다.

- 원본의 절, 절 이름, 프로시저와 변수 이름, 프로그램의 짜임새를 그대로 따른다.
  크누스의 책 *TeX: The Program*(Computers & Typesetting, Volume B)과 나란히 놓고 읽을 수 있다.
- 문서는 크누스가 처음부터 GWEB과 Go로 쓴 것처럼 서술했다. Pascal에만 해당하는 설명은 걷어 내고,
  Go로 옮기면서 달라진 점은 따로 떼지 않고 해당하는 절의 설명에 녹여 넣었다. TeX의 역사와
  크누스의 농담은 그대로 두었다.
- 같은 `tex.w`에서 사람이 읽을 문서(`tex.pdf`, 약 820쪽)와 실제로 돌아가는 프로그램(`build/tex`)이
  함께 나온다. 이 프로그램은 실제 TeX처럼 작동하고, 크누스의 TRIP 테스트도 통과한다(아래 참조).

## 파일

| 파일 | 내용 |
| --- | --- |
| `tex.w` | 번역 본문. 모든 것이 여기서 나온다 |
| `texlion.pdf` | `tex.pdf` 1쪽의 왼쪽 아래에 넣는 사자 그림 |
| `Makefile` | 빌드, 조판, 테스트 |
| `go.mod` | Go 모듈 정의 |
| `tests/trip.sh` | TRIP 테스트 |
| `tests/compare.sh` | 문서 하나를 진짜 TeX과 함께 조판해 DVI를 비교한다 |
| `tests/typeset-check.py` | `tex.pdf`에서 오류 없이 조용히 깨진 조판(악센트가 된 따옴표, 잘못 끊긴 수 따위)을 찾는다 |
| `orig/tex.web` | 옮긴 원본(CTAN의 3.141592653) |
| `orig/names.tsv` | 원본의 영어 절 이름과 한글 절 이름의 대응표 |

## 읽기 안내

### 문서의 모양

`make pdf`로 만든 `tex.pdf`를 읽으면 된다. 원본처럼 55부(part)로 되어 있고, 각 부는 번호 붙은
절(section)로 이루어진다. 절마다 설명(TeX 부분)과 코드(Go 부분)가 함께 있다. 코드 안의
`⟨…⟩`는 다른 절에 정의된 코드 조각을 그 자리에 끼워 넣는다는 뜻이고, 그 정의가 있는 절 번호가
함께 찍힌다.

이 번역은 쪽 넘김을 깔끔하게 하려고 긴 절을 몇 개로 나누기도 하고, 정의와 코드를 따로 두려고 절을
보태기도 했다. 그래서 절 번호가 원본과 어긋난다(원본 1380절, 번역 1484절). 원본이나
*TeX: The Program*과 맞추어 볼 때는 절 이름(`orig/names.tsv`)과 찾아보기를 쓰면 된다. 마지막 부인
찾아보기에서는 식별자와 오류 메시지가 쓰인 모든 절을 찾을 수 있다.

본문에서 다른 절을 가리킬 때는 절 번호를 직접 적지 않고, 그 절의 설명 첫머리에 `\seclabel{이름}`을
두고 가리키는 곳에 `\secref{이름}`이라고 쓴다. 그러면 절을 나누거나 보태어 번호가 바뀌어도 참조가
저절로 따라간다(조판을 두 번 해야 한다).

### 어디서부터 읽을까

크누스는 처음부터 차례로 읽기를 권한다. 앞부분에서 만든 도구를 뒤에서 쓰기 때문이다. 처음 읽는다면
다음 순서가 무난하다.

1. **기초 (1–8부)**: 문자 집합, 입출력, 문자열 풀, 오류 처리, `scaled`(2^-16 pt 단위) 고정 소수점
   산술. 7부의 `badness` 계산은 줄 나누기와 쪽 나누기의 바탕이다.
2. **자료 구조 (9–23부)**: 거대한 배열 `mem` 하나에서 노드를 할당하는 방식(9부), 상자·글루·커닝 노드의
   모양(10부), 의미 둥지(16부), 등가물 표 `eqtb`와 그룹 단위의 저장과 복원(17–19부), 해시 표(18부).
3. **입력과 매크로 (20–29부)**: 토큰과 토큰 목록, 훑개 `getNext`(24부), 매크로 펼치기(25부),
   수와 치수 읽기(26부), 조건문(28부).
4. **글꼴과 출력 (30–33부)**: TFM 파일 읽기(30부), DVI 형식(31부)과 쪽 내보내기(32부),
   상자를 꾸리는 `hpack`과 `vpack`(33부).
5. **TeX의 핵심 알고리즘들**
   - 수식 조판 (34–36부): 수식 목록을 가로 목록으로 바꾸는 `mlistToHlist`.
   - 정렬 (37부): `\halign`과 `\valign`. 크누스 자신이 "기적"이라고 부른다.
   - **줄 나누기 (38–39부)**: 문단 전체를 보고 가장 좋은 나눔점들을 찾는 크누스–플래스 알고리즘.
     `tryBreak`와 델타 노드가 핵심이다.
   - 하이픈 넣기 (40–43부): 리앙(Liang)의 패턴과 트라이(trie).
   - 쪽 나누기 (44–45부): `vertBreak`와 쪽 조립기 `buildPage`, 삽입물 처리.
6. **전체를 묶는 곳 (46–51부)**: 주 제어 루틴 `mainControl`(46부), 상자와 목록 만들기(47–48부),
   정의와 대입(49부), 포맷 파일의 덤프(50부), 주 프로그램(51부).

### Pascal에서 Go로

옮기면서 정한 관례는 문서의 첫 부분(3절)과 해당 절의 설명에 적혀 있다. 대표적인 것만 들면 다음과 같다.

- 식별자는 Go의 관례대로 낙타 표기로 썼다(원본의 `get_next`는 `getNext`, `end_of_TEX`는 `endOfTEX`).
  원본과 맞추어 볼 때는 밑줄을 빼고 그 다음 글자를 대문자로 바꾸면 된다. 예약어와 겹치는
  `type`은 `typ`가, 내장 이름을 가리던 `print`와 `error`는 `printStr`와 `reportError`가 되었다.
- TeX의 정수형(`halfword`, `scaled`, `pointer` 따위)은 모두 `int32`의 별칭이다.
- 원본의 필드 매크로 `link(p)`는 함수 `link(p)`와 `setLink(p, v)`의 짝이 된다.
- 변형 레코드 `memoryWord`는 필드가 따로따로인 구조체가 된다.
- `init…tini`는 `if iniVersion {…}`, `stat…tats`는 `if stat {…}`, `debug…gubed`는 `if debug {…}`이다.
- 프로시저 바깥으로 가는 `goto endOfTEX`나 `goto finalEnd`는 `panic`이 되고, 주 프로그램이
  `recover`로 받는다.
- 원본의 문자열 풀 파일(`TEX.POOL`)은 없다. 메시지는 Go의 문자열 상수로 남아 그대로 찍히고,
  원본에서 문자열 번호로 쓰이던 상수 몇 개(`".tex"` 따위)만 INITEX가 풀에 넣는다.

## 빌드

필요한 것은 다음과 같다.

- [Go](https://go.dev/) 1.27.2 이상(`go.mod`)
- GWEB 도구 `gtangle`, `gweave`와 그 매크로(`kotexgweb.tex`, `gwebmac.tex`)
- LuaTeX와 TeX Live: 문서를 조판할 때, 그리고 프로그램이 TFM 파일과 `plain.tex` 같은 입력 파일을
  `kpsewhich`로 찾을 때 쓴다
- 테스트에는 `pltotf`, `dvitype`(TeX Live에 들어 있다), `curl`, `perl`도 쓴다
- `make check`에는 `python3`를 쓰고, 있으면 `pdftotext`(poppler)도 쓴다

```sh
make            # build/tex와 tex.pdf를 만든다
make build      # 프로그램만: tex.w → tex.go(gtangle) → build/tex(go build)
make pdf        # 문서만: tex.w → tex.tex(gweave) → tex.pdf(luatex 두 번)
make check      # 조판 경고(Overfull, Underfull 따위)와 조용히 깨진 조판의 수를 센다. 둘 다 0이어야 한다
make test       # make story와 make trip(아래 테스트)을 함께 돌린다
make clean
```

## 실행

실행 파일 하나가 원본의 두 판, 곧 INITEX와 VIRTEX 노릇을 함께 한다. 명령줄의 첫 인자가 `-ini`이면
INITEX로 작동한다. 그 밖의 인자들은 원본에서 터미널의 첫 줄(`**` 뒤)로 입력하던 것이 된다.

먼저 plain 포맷을 만든다(`make fmt`와 같다).

```sh
cd build
./tex -ini plain '\dump'          # plain.tex를 읽어 plain.fmt를 만든다
```

그 다음 그 포맷으로 문서를 조판한다.

```sh
./tex '&plain' story '\end'       # story.dvi가 나온다
```

파일은 다음과 같이 찾는다.

- **입력 파일**: 먼저 현재 디렉터리에서 찾는다. 없으면 환경 변수 `TEXINPUTS`의 디렉터리들에서 찾고,
  그래도 없으면 `kpsewhich`에게 묻는다.
- **TFM 파일**: `TEXFONTS`의 디렉터리들에서 찾는다. 없으면 처음 한 번 `kpsewhich -show-path=tfm`이
  알려 주는 글꼴 디렉터리들(맨 앞이 현재 디렉터리)을 훑어 만든 표에서 찾는다. 글꼴마다 `kpsewhich`를
  부르면 한 번에 0.1초쯤 들어 plain 포맷을 만드는 데만 4초가 넘게 걸리던 것이 0.4초로 줄었다.
  표에도 없으면 `kpsewhich`에게 묻고, 그래도 없으면 현재 디렉터리에서 찾는다.
- **포맷 파일**: `&plain`은 먼저 현재 디렉터리의 `plain.fmt`를 찾고, 없으면 `TEXFORMATS`의 디렉터리들에서 찾는다.
- **경로**: 원본은 `>`와 `:`로만 디렉터리를 가르지만, 이 번역은 `/`도 디렉터리 구분자로 알아본다.
  그래서 `./tex '&plain' ../doc/paper`라고 하면 `../doc/paper.tex`를 읽고, 출력은 현재 디렉터리의
  `paper.dvi`와 `paper.log`가 된다. 디렉터리가 붙은 이름은 `TEXINPUTS`나 `kpsewhich`로 찾지 않는다.

오류가 나면 원본처럼 터미널에서 다음 동작을 묻는다. 표준 입력이 터미널이 아니면 "End of file on the
terminal"로 멈추니, 대화가 필요 없을 때는 문서에 `\batchmode`나 `\nonstopmode`를 쓴다.
실행 중에 Ctrl-C를 누르면 원본의 `interrupt`처럼 안전한 곳에서 멈추고 다음 동작을 묻는다.

출력의 날짜는 원본의 `fixDateAndTime`처럼 늘 1776년 7월 4일 정오다.

## 테스트

### 진짜 TeX과 비교하기

```sh
make story                  # tests/compare.sh story
tests/compare.sh 문서이름    # kpsewhich로 찾을 수 있는 plain TeX 문서
```

이 번역과 TeX Live의 `tex`가 각자 plain 포맷을 만든다. 그 포맷으로 같은 문서를 조판한 다음,
두 DVI를 `dvitype`으로 풀어 비교한다. 날짜가 들어 있는 DVI 머리의 주석은 빼고 비교한다.
`story.tex`의 DVI는 진짜 TeX의 것과 같다.

### TRIP 테스트

```sh
make trip                   # 요약만
tests/trip.sh -v            # 차이를 모두 보인다
```

TRIP은 크누스가 TeX의 구현을 검증하려고 만든 "고문 테스트"다. TeX의 거의 모든 기능을 극단적인
경우까지 몰아붙인다. `tests/trip.sh`는 *tripman.tex* 부록 A의 절차를 그대로 따른다.

1. 처음 한 번, 크누스가 배포한 테스트 파일(`trip.tex`, `trip.pl`, 그리고 결과 원본인 `tripin.log`,
   `trip.log`, `trip.typ` 따위)을 CTAN에서 `tests/trip/`로 받는다.
2. `trip.pl`을 `pltotf`로 `trip.tfm`으로 바꾼다.
3. tripman이 요구하는 상수로 테스트용 INITEX를 만든다. `memMin=memBot=1`, `memTop=memMax=3000`,
   `errorLine=64`, `halfErrorLine=32`, `maxPrintLine=72`이다. `tex.w`에서 뽑은 `tex.go`의 상수만 바꾸므로
   `tex.w`는 건드리지 않는다.
4. 첫 실행(`\input trip`)으로 `tripin.log`를 만들고, 둘째 실행(` &trip  trip `)으로 `trip.log`,
   `trip.dvi`, `tripos.tex`를 만든다.
5. `trip.dvi`를 `dvitype`으로 `trip.typ`로 바꾸고, 결과들을 원본과 비교한다.

결과는 `build/trip/`에 남는다. 지금 남는 차이는 모두 tripman이 허용하는 것들이다.

| 파일 | 차이 | 까닭 |
| --- | --- | --- |
| 모든 로그 | 첫 줄 | 배너에 `(GWEB)`이 붙는다 |
| `tripin.log`, `trip.log` | 문자열 수와 용량 | 원본은 프로그램의 모든 문자열을 풀에 넣는다(tripman 5(f), 5(d)) |
| `trip.log` | `glue set` 값 몇 개 | 부동 소수점 반올림(5(b)) |
| `trip.typ` | 좌표 세 개 | 위의 글루 반올림 때문(6단계) |
| `*.fot` | `**` 뒤의 입력 | 원본은 터미널이 친 글자를 되비추지만, 여기서는 파이프로 입력한다 |

원본 `tex.web`에서 찾은 버그는 아직 없다.

## 저작권과 이름

원본 `tex.web`의 저작권은 크누스에게 있다(1982). 원본 머리말은 원본을 고치는 것을 허락하되,
고친 파일의 이름이 `tex.web`이 아니어야 한다고 정해 두었다. 이 번역은 `tex.w`라는 별개의 파일이다.

원본 §2는 프로그램을 고치면 문제가 생겼을 때 어느 판인지 알 수 있도록 배너를 바꾸라고 하고,
고친 시스템은 그냥 ‘TeX’이라고 부르지 말라고 한다. 그 이름은 TRIP 테스트로 호환성을 확인한
구현을 위한 것이다. 그래서 이 번역의 배너는 `This is TeX, Version 3.141592653 (GWEB)`이다.
