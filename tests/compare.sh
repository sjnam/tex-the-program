#!/bin/sh
# plain TeX 문서 하나를 이 번역의 TeX과 진짜 TeX(TeX Live의 tex)으로 조판해서
# 두 DVI를 DVItype으로 비교한다. DVI 머리의 날짜 주석은 빼고 비교한다.
#
#   tests/compare.sh story          (kpsewhich로 찾을 수 있는 문서 이름)
#
# 필요한 것: build/tex (make build), TeX Live의 tex, dvitype
set -e

DOC=${1:-story}
TOP=$(cd "$(dirname "$0")/.." && pwd)
OURS=$TOP/build/compare/ours
REAL=$TOP/build/compare/real
rm -rf "$OURS" "$REAL"; mkdir -p "$OURS" "$REAL"

# 각자 plain 포맷을 만든다
(cd "$OURS" && "$TOP/build/tex" -ini plain '\dump' </dev/null >/dev/null 2>&1)
(cd "$REAL" && tex -ini plain '\dump' </dev/null >/dev/null 2>&1)

# 같은 문서를 조판한다
(cd "$OURS" && "$TOP/build/tex" '&plain' "$DOC" '\end' </dev/null >/dev/null 2>&1) || true
(cd "$REAL" && tex '&./plain' "$DOC" '\end' </dev/null >/dev/null 2>&1) || true

dvitype "$OURS/$DOC.dvi" | grep -v "TeX output" | sed 1d > "$OURS/$DOC.typ"
dvitype "$REAL/$DOC.dvi" | grep -v "TeX output" | sed 1d > "$REAL/$DOC.typ"

if diff "$REAL/$DOC.typ" "$OURS/$DOC.typ" >/dev/null; then
  echo "$DOC: DVI가 같다 (날짜 주석 빼고)"
else
  echo "$DOC: DVI가 다르다"
  diff "$REAL/$DOC.typ" "$OURS/$DOC.typ" | head -40
  exit 1
fi
