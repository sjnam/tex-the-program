#!/bin/sh
# TRIP 테스트를 돌린다. 커누스의 tripman.tex 부록 A의 절차를 따른다.
#
#   tests/trip.sh            요약만 찍는다
#   tests/trip.sh -v         원본 결과와의 차이를 모두 찍는다
#
# 필요한 것: go, gtangle, pltotf, dvitype, curl, perl
# 테스트 파일(trip.tex 따위)은 처음 한 번 CTAN에서 tests/trip/ 아래로 받아 둔다.
set -e

TOP=$(cd "$(dirname "$0")/.." && pwd)
DIST=$TOP/tests/trip                 # 커누스가 배포한 원본 파일들
WORK=$TOP/build/trip                 # 테스트를 돌리는 곳
CTAN=https://mirrors.ctan.org/systems/knuth/dist/tex
FILES="trip.tex trip.pl tripin.log tripin.fot trip.log trip.fot trip.typ tripos.tex tripman.tex"

# 0. 원본 파일을 받는다
mkdir -p "$DIST"
for f in $FILES; do
  [ -f "$DIST/$f" ] || curl -sSfL -o "$DIST/$f" "$CTAN/$f"
done

# 1. trip.pl을 trip.tfm으로 바꾼다
rm -rf "$WORK"; mkdir -p "$WORK"; cd "$WORK"
pltotf "$DIST/trip.pl" trip.tfm >/dev/null
cp "$DIST/trip.tex" .

# 2. 테스트용 INITEX를 만든다. tripman의 지시대로 상수 몇 개를 바꾸고, 키워 둔
#    bufSize와 dviBufSize는 tex.web의 처음 값으로 되돌린다.
cp "$TOP/tex.w" "$TOP/go.mod" .
gtangle tex.w >/dev/null 2>&1
perl -0pi -e '
  s/(\n\tmemMax\s*=\s*)30000/${1}3000/        or die "memMax";
  s/(\n\tmemMin\s*=\s*)0 /${1}1 /             or die "memMin";
  s/(\n\tmemBot\s*=\s*)0 /${1}1 /             or die "memBot";
  s/(\n\tmemTop\s*=\s*)30000/${1}3000/        or die "memTop";
  s/(\n\terrorLine\s*=\s*)72/${1}64/          or die "errorLine";
  s/(\n\thalfErrorLine\s*=\s*)42/${1}32/      or die "halfErrorLine";
  s/(\n\tmaxPrintLine\s*=\s*)79/${1}72/       or die "maxPrintLine";
  s/(\n\tbufSize\s*=\s*)20000/${1}500/        or die "bufSize";
  s/(\n\tdviBufSize\s*=\s*)16384/${1}800/     or die "dviBufSize";
' tex.go
go build -o triptex .

# 무엇이 잘못되면 기록 파일이 끝없이 커질 수 있으므로 파일 크기를 제한한다
ulimit -f 100000
export TEXFONTS=. TEXINPUTS=.

# 3. 첫 실행: `**'에 빈 줄을 주고, 다시 `**'에 \input trip을 준다
printf '\n\\input trip\n' | ./triptex -ini > tripin.fot 2>&1 || true
mv trip.log tripin.log

# 4. 둘째 실행: ` &trip  trip '을 준다
printf ' &trip  trip \n' | ./triptex -ini > trip.fot 2>&1 || true

# 6. DVItype으로 trip.dvi를 trip.typ로 바꾼다
dvitype -output-level=2 -dpi=72.27 -page-start='*.*.*.*.*.*.*.*.*.*' \
  trip.dvi > trip.typ 2>&1 || true

# 5. 원본 결과와 비교한다
echo "TRIP 결과 ($WORK)"
for f in tripin.log tripin.fot trip.log trip.fot trip.typ tripos.tex; do
  n=$(diff "$DIST/$f" "$f" | grep -c '^[!=]' || true)
  printf '  %-11s 다른 줄 %s\n' "$f" "$n"
  if [ "$1" = "-v" ] && [ "$n" != 0 ]; then
    diff "$DIST/$f" "$f" | sed 's/^/      /' || true
  fi
done
