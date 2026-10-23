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
#   make deco       테두리에 액자를 두른 문서(tex-deco.pdf)를 만든다
#   make twill      쪽마다 미니 색인을 붙인 문서(tex-twill.pdf)를 gtwill로 만든다
#   make twill-deco 미니 색인과 액자를 함께 붙인 문서(tex-twill-deco.pdf)를 만든다

BUILD = build

.PHONY: all build pdf check fmt story trip test clean deco twill twill-deco

all: build pdf

tex.go: tex.w
	gtangle tex.w

$(BUILD)/tex: tex.go go.mod
	@mkdir -p $(BUILD)
	go build -o $(BUILD)/tex .

build: $(BUILD)/tex

# 절 번호 참조(\secref)를 맞추려면 luatex를 두 번 돌려야 한다.
# gweave는 차례를 맨 끝에 두므로, qpdf로 차례를 맨 앞으로 옮긴다. 차례가 몇 쪽인지는
# tex.w의 \topofcontents가 로그에 적어 둔 "TOC begins after page B"로 안다:
# B+1쪽부터 끝까지가 차례다.
# $(1)은 조판할 .tex 파일의 이름(곧 \jobname), $(2)는 바꿈 파일이다.
define weave
	$(if $(2),mkdir -p $(BUILD) && gweave -o $(BUILD) tex.w $(2) && mv $(BUILD)/tex.tex $(1).tex,gweave tex.w)
	luatex --interaction=nonstopmode $(1).tex >/dev/null
	luatex --interaction=nonstopmode $(1).tex >/dev/null
	$(call movetoc,$(1))
endef

# $(1).pdf의 맨 끝에 있는 차례를 맨 앞으로 옮긴다.
define movetoc
	@b=$$(sed -n 's/^TOC begins after page \([0-9][0-9]*\)$$/\1/p' $(1).log); \
	test -n "$$b" || { echo "$(1).log에 차례의 시작 쪽이 없다" >&2; exit 1; }; \
	echo "qpdf $(1).pdf --pages $(1).pdf $$((b+1))-z,1-$$b -- $(1)-toc.pdf"; \
	qpdf $(1).pdf --pages $(1).pdf $$((b+1))-z,1-$$b -- $(1)-toc.pdf
	mv $(1)-toc.pdf $(1).pdf
endef

tex.pdf: tex.w texlion.pdf
	$(call weave,tex)

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

# 액자를 두른 판은 tex-deco.pdf로 따로 만들어 tex.pdf를 건드리지 않는다
tex-deco.pdf: tex.w tex-deco.ch texlion.pdf decoframe.pdf
	$(call weave,tex-deco,tex-deco.ch)

deco: tex-deco.pdf

# 미니 색인을 붙인 판은 크누스가 TWILL로 TeX: The Program을 찍은 방식을 따른다. 도구는
# gtwill(https://github.com/sjnam/gtwill)이고, 미니 색인을 정렬하는 gtwill-refsort와
# 매크로 gtwimac.tex가 함께 깔려 있어야 한다(gtwill 저장소에서 make install).
# 도구 gtwill이 gweave 자리에 들어가고, luatex는 세 번 돈다. 첫 번째는 \secref가 쓰는
# .ref 파일을 얻으려고, 두 번째는 맞는 \secref로 쪽을 나누어 정렬하지 않은 미니 색인을
# .mref 파일에 쓰려고 돈다. 그것을 gtwill-refsort로 정렬한 .smref 파일을 세 번째가 읽는다.
# 지난번의 .smref 파일이 남아 있으면 앞의 두 번이 그것을 읽어 버리므로 먼저 지운다.
# 쪽 나누기가 바뀌므로 판을 고칠 때마다 처음부터 다시 만들어야 한다.
GTWILL ?= gtwill
GTWILL_REFSORT ?= gtwill-refsort

define twill
	mkdir -p $(BUILD) && $(GTWILL) -o $(BUILD) tex.w $(2) && mv $(BUILD)/tex.tex $(1).tex
	rm -f $(1).smref
	luatex --interaction=nonstopmode $(1).tex >/dev/null
	luatex --interaction=nonstopmode $(1).tex >/dev/null
	$(GTWILL_REFSORT) < $(1).mref > $(1).smref
	luatex --interaction=nonstopmode $(1).tex >/dev/null
	@echo "$(1).pdf: 조판 경고 $$(grep -ac 'Overfull\|Underfull\|Error\|Missing\|Undefined' $(1).log)"
	$(call movetoc,$(1))
endef

tex-twill.pdf: tex.w tex.bux texlion.pdf
	$(call twill,tex-twill)

twill: tex-twill.pdf

# 액자도 두르려면 tex-deco.ch를 그대로 쓴다. 거기서 \twillbackground를 \FrameBG로 둔다.
tex-twill-deco.pdf: tex.w tex.bux tex-deco.ch texlion.pdf decoframe.pdf
	$(call twill,tex-twill-deco,tex-deco.ch)

twill-deco: tex-twill-deco.pdf

clean:
	rm -rf $(BUILD) tex.go tex.tex tex.log tex.pdf tex.toc tex.ref tex.idx tex.scn\
	  tex-deco.tex tex-deco.log tex-deco.pdf tex-deco.toc tex-deco.ref\
	  tex-twill.tex tex-twill.log tex-twill.pdf tex-twill.toc tex-twill.ref tex-twill.mref tex-twill.smref\
	  tex-twill-deco.tex tex-twill-deco.log tex-twill-deco.pdf tex-twill-deco.toc tex-twill-deco.ref\
	  tex-twill-deco.mref tex-twill-deco.smref
