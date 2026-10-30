#!/bin/sh
# Go 컴파일러의 프로파일 기반 최적화(PGO)에 쓸 default.pgo를 만든다.
# INITEX로 plain 포맷을 만들 때와, tex.web을 weave한 본문을 여덟 번 되풀이한 3911쪽
# 문서를 조판할 때의 CPU 프로파일을 합친다. 꾸러미 디렉터리에 default.pgo가 있으면
# go build가 저절로 그것을 쓴다.
#
#   tests/pgo.sh
#
# macOS에서는 Go의 CPU 프로파일러가 표본을 마지막 시스템 호출의 스택에 잘못 붙이므로
# 쓸 만한 프로파일이 나오지 않는다. 그래서 리눅스가 아니면 리눅스용으로 빌드해서
# 도커 컨테이너 안에서 돌린다. 프로파일은 함수 이름으로 맞추므로 어느 시스템에서
# 뜬 것이든 다른 시스템의 빌드에 쓸 수 있다.
#
# 필요한 것: go, weave, kpsewhich, 리눅스가 아니면 docker
set -e

TOP=$(cd "$(dirname "$0")/.." && pwd)
W=$TOP/build/pgo
rm -rf "$W"; mkdir -p "$W/texmf/inputs" "$W/texmf/fonts"
cd "$W"

# 조판할 문서와, 그것이 읽는 파일들을 한곳에 모은다(컨테이너는 배포판을 못 보므로)
cp "$TOP/orig/tex.web" . && weave tex.web >/dev/null 2>&1
n=$(grep -n '^\\inx' tex.tex | cut -d: -f1)
{ echo '\input webmac'; for i in 1 2 3 4 5 6 7 8; do sed -n "2,$((n-1))p" tex.tex; done
  sed -n "$n,\$p" tex.tex; } > big.tex
cp $(kpsewhich plain.tex hyphen.tex webmac.tex) texmf/inputs/
cp "$(dirname "$(kpsewhich cmr10.tfm)")"/*.tfm "$(dirname "$(kpsewhich logo10.tfm)")"/*.tfm texmf/fonts/

run='TEXCPUPROFILE=ini.pprof ./tex -ini plain "\\dump" </dev/null >/dev/null 2>&1
TEXCPUPROFILE=big.pprof ./tex "&plain" big "\\end" </dev/null >/dev/null 2>&1 || true'
if [ "$(uname)" = Linux ]; then
  (cd "$TOP" && go build -o "$W/tex" .)
  TEXINPUTS=.:$W/texmf/inputs TEXFONTS=$W/texmf/fonts sh -c "$run"
else
  (cd "$TOP" && CGO_ENABLED=0 GOOS=linux go build -o "$W/tex" .)
  docker run --rm -v "$W":/w -w /w -e TEXINPUTS=.:/w/texmf/inputs -e TEXFONTS=/w/texmf/fonts \
    alpine:3.20 sh -c "$run"
fi
test -s ini.pprof && test -s big.pprof
go tool pprof -proto ini.pprof big.pprof > "$TOP/default.pgo" 2>/dev/null
echo "default.pgo를 만들었다 ($(wc -c < "$TOP/default.pgo") 바이트)"
