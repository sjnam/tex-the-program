#!/bin/sh
# 이 가지의 TeX(build/tex)이 기준 가지(기본값 main)의 TeX과 똑같은 결과를 내는지 본다.
# go-native 실험에서는 무엇을 고치든 출력이 한 바이트도 달라져서는 안 되므로,
# TeX Live의 tex가 아니라 고치기 전의 이 프로그램과 견준다.
#
#   tests/regress.sh            요약만 찍는다
#   tests/regress.sh -t         같은 문서를 여러 번 조판해 걸린 시간도 견준다
#
# 견주는 것:
#   - TRIP 테스트가 남기는 파일 일곱 개 (tests/trip.sh가 만든 build/trip과)
#   - 같은 TRIP 테스트를 쪽 내보내기를 비동기식으로 못 박고(TEXDVI=async) 돌린 결과
#   - INITEX로 plain 포맷을 만들 때의 로그(시간을 잴 때는 ini로 적는다)
#   - story.tex(배포판에서 찾는다), tex.web을 weave한 문서(536쪽), 그 본문을 여덟 번 되풀이한 문서(3911쪽),
#     쪽을 내보내는 도중에 \write에서 치명적인 오류가 나는 문서(fatal),
#     536쪽 문서를 추적을 모두 켜고 조판해 기록 파일이 65MB쯤 되는 문서(trace),
#     2만 자가 넘는 줄로 입력 버퍼를 넘치게 하는 문서(longline)의
#     DVI(dvitype으로 풀어서, 날짜 주석은 빼고)와 로그(날짜가 든 첫 줄은 빼고)와 터미널 출력
#   - 536쪽 문서를 쪽 내보내기를 동기식으로 못 박고(TEXDVI=sync) 조판한 결과
#
# 필요한 것: build/tex (make build), make trip을 이미 돌린 build/trip, gtangle, go, weave, dvitype
set -e

TOP=$(cd "$(dirname "$0")/.." && pwd)
timing=0; [ "$1" = "-t" ] && timing=1
BASE=${BASE:-main}
W=$TOP/build/regress
OURS=$TOP/build/tex
REF=$W/ref/tex

# 1. 기준 가지의 tex.w로 기준 TeX과 기준 TRIP 결과를 만든다
rm -rf "$W"; mkdir -p "$W/ref/tests"
git -C "$TOP" show "$BASE:tex.w" > "$W/ref/tex.w"
git -C "$TOP" show "$BASE:tests/trip.sh" > "$W/ref/tests/trip.sh"; chmod +x "$W/ref/tests/trip.sh"
cp "$TOP/go.mod" "$W/ref/"
cp -r "$TOP/tests/trip" "$W/ref/tests/"
(cd "$W/ref" && gtangle tex.w >/dev/null 2>&1 && go build -o tex . && tests/trip.sh >/dev/null 2>&1)

bad=0
same() { # $1: 이름, $2 $3: 견줄 두 파일
  if cmp -s "$2" "$3"; then printf '  %-28s 같다\n' "$1"
  else printf '  %-28s 다르다\n' "$1"; bad=1; diff "$2" "$3" | head -10 | sed 's/^/      /'; fi
}

echo "$BASE 가지의 TeX과 견준다"
for f in tripin.log tripin.fot trip.log trip.fot trip.typ tripos.tex 8terminal.tex; do
  same "TRIP $f" "$W/ref/build/trip/$f" "$TOP/build/trip/$f"
done
TEXDVI=async "$TOP/tests/trip.sh" >/dev/null 2>&1
for f in tripin.log tripin.fot trip.log trip.fot trip.typ tripos.tex 8terminal.tex; do
  same "TRIP(async) $f" "$W/ref/build/trip/$f" "$TOP/build/trip/$f"
done

# 2. 견줄 문서들을 마련한다
mkdir -p "$W/doc"
cd "$W/doc"
cp "$TOP/orig/tex.web" . && weave tex.web >/dev/null 2>&1
n=$(grep -n '^\\inx' tex.tex | cut -d: -f1)
{ echo '\input webmac'; for i in 1 2 3 4 5 6 7 8; do sed -n "2,$((n-1))p" tex.tex; done
  sed -n "$n,\$p" tex.tex; } > big.tex
# sh의 echo는 \b 따위를 제어 문자로 바꾸므로 printf '%s'로 쓴다
{ printf '%s\n' '\batchmode' '\shipout\vbox{\hbox{First page}}'
  printf '%s' '\shipout\vbox{\hbox{AB\special{hello}\kern3pt\vrule width 2pt C}\hbox{D\write-1{'
  for i in $(seq 120); do printf '%s' '\undefined'; done
  printf '%s\n' '}E}\hbox{F}}' '\end'; } > fatal.tex
printf '%s\n' '\tracingcommands=2 \tracingmacros=2 \tracingparagraphs=1 \tracingpages=1' \
  '\tracingoutput=1 \showboxdepth=3 \showboxbreadth=20 \input tex ' > trace.tex
{ printf '%s\n' '\batchmode' 'Short line.'
  for i in $(seq 3000); do printf '%s' 'abcdefgh '; done; printf '\n%s\n' '\end'; } > longline.tex

# 3. 저마다 plain 포맷을 만들고 문서들을 조판한다
for who in ref ours; do
  tex=$REF; [ $who = ours ] && tex=$OURS
  mkdir -p "$W/$who/run"; cd "$W/$who/run"
  cp "$W/doc/tex.tex" "$W/doc/big.tex" "$W/doc/fatal.tex" "$W/doc/trace.tex" "$W/doc/longline.tex" . # story.tex는 배포판에서 찾게 둔다
  "$tex" -ini plain '\dump' </dev/null >plain.fot 2>&1
  sed 1d plain.log > plain.log1
  for d in story tex big fatal trace longline; do
    "$tex" '&plain' "$d" '\end' </dev/null >"$d.fot" 2>&1 || true
    if [ -f "$d.dvi" ]; then dvitype "$d.dvi" | grep -v 'TeX output' | sed 1d > "$d.typ"; else : > "$d.typ"; fi
    sed 1d "$d.log" > "$d.log1"
  done
done
same "INITEX plain.fot" "$W/ref/run/plain.fot" "$W/ours/run/plain.fot"
same "INITEX plain.log" "$W/ref/run/plain.log1" "$W/ours/run/plain.log1"
for d in story tex big fatal trace longline; do
  for x in typ log1 fot; do same "$d.$x" "$W/ref/run/$d.$x" "$W/ours/run/$d.$x"; done
done
cd "$W/ours/run"
TEXDVI=sync "$OURS" '&plain' tex '\end' </dev/null >tex.fot 2>&1 || true
dvitype tex.dvi | grep -v 'TeX output' | sed 1d > tex.typ
sed 1d tex.log > tex.log1
for x in typ log1 fot; do same "tex.$x (sync)" "$W/ref/run/tex.$x" "$W/ours/run/tex.$x"; done

# 4. 원하면 걸린 시간을 견준다(다섯 번 가운데 가장 짧은 것)
if [ "$timing" = 1 ]; then
  echo "걸린 시간(초, 다섯 번 가운데 가장 짧은 것): 기준 / 이 가지"
  for d in ini story tex big; do
    for who in ref ours; do
      tex=$REF; [ $who = ours ] && tex=$OURS
      cd "$W/$who/run"
      set -- '&plain' "$d" '\end'; [ $d = ini ] && set -- -ini plain '\dump'
      t=$(for i in 1 2 3 4 5; do /usr/bin/time -p "$tex" "$@" </dev/null 2>&1 >/dev/null |
        awk '/^real/{print $2}'; done | sort -n | head -1)
      eval "t_$who=$t"
    done
    printf '  %-28s %s / %s\n' "$d" "$t_ref" "$t_ours"
  done
fi

[ $bad = 0 ] && echo "모두 같다" || { echo "다른 것이 있다"; exit 1; }
