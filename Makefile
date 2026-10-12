# 한글 GWEB으로 옮긴 TeX (tex.w)
#
#   make            프로그램(build/tex)과 문서(tex.pdf)를 만든다
#   make build      tex.w에서 Go 소스를 뽑아(gtangle) build/tex를 만든다
#   make pdf        tex.w를 조판해(gweave, luatex 두 번) tex.pdf를 만든다
#   make check      tex.pdf의 조판 경고와 조용히 깨진 조판을 센다(둘 다 0이어야 한다)
#   make fmt        build/plain.fmt를 만든다(INITEX로 plain.tex를 읽고 \dump)
#   make story      story.tex를 조판해 진짜 TeX의 DVI와 비교한다
#   make trip       크누스의 TRIP 테스트를 돌린다
#   make test       story와 trip을 모두 돌린다
#   make clean      만든 것을 모두 지운다

BUILD = build

.PHONY: all build pdf check fmt story trip test clean

all: build pdf

tex.go: tex.w
	gtangle tex.w

$(BUILD)/tex: tex.go go.mod
	@mkdir -p $(BUILD)
	go build -o $(BUILD)/tex .

build: $(BUILD)/tex

# 절 번호 참조(\secref)를 맞추려면 luatex를 두 번 돌려야 한다
tex.pdf: tex.w texlion.pdf
	gweave tex.w
	luatex --interaction=nonstopmode tex.tex >/dev/null
	luatex --interaction=nonstopmode tex.tex >/dev/null

pdf: tex.pdf

check: tex.pdf
	@n=$$(grep -ac 'Overfull\|Underfull\|Error\|Missing\|Undefined' tex.log); \
	echo "조판 경고: $$n"; test $$n -eq 0
	@python3 tests/typeset-check.py

$(BUILD)/plain.fmt: $(BUILD)/tex
	cd $(BUILD) && ./tex -ini plain '\dump' </dev/null

fmt: $(BUILD)/plain.fmt

story: $(BUILD)/tex
	tests/compare.sh story

trip:
	tests/trip.sh

test: story trip

clean:
	rm -rf $(BUILD) tex.go tex.tex tex.log tex.pdf tex.toc tex.ref tex.idx tex.scn
