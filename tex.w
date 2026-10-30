% 이 파일은 커누스의 tex.web(Version 3.141592653, 2021)을 한글 GWEB(Go)로
% 옮긴 것이다. 원본 tex.web (C) 1982 Donald E. Knuth.
% 원본의 조건(``고친 파일은 tex.web이라는 이름을 달아서는 안 된다'')에 따라
% 이 파일은 tex.web이 아니며, 커누스의 TeX 꾸러미의 일부가 아니다.
% 손대지 않은 원본은 CTAN의 systems/knuth/dist/tex/tex.web에 있다.

\input kotexgweb

% 조판에 쓰는 매크로들
\def\hang{\hangindent 3em\noindent\ignorespaces}
\def\hangg#1 {\hang\hbox{#1 }}
\def\textindent#1{\hangindent2.5em\noindent\hbox to2.5em{\hss#1 }\ignorespaces}
\def\pct!{{\char`\%}} % 본문의 퍼센트 기호
\font\logo=logo10 % METAFONT 로고에 쓰는 글꼴
\def\MF{{\logo META}\-{\logo FONT}}
\def\<#1>{$\langle#1\rangle$}
\def\section{\mathhexbox278}
\def\(#1){} % 절 이름이 잘 정렬되도록 쓴다
\def\yskip{\vskip3pt plus1pt}
% 절 번호 참조. 절의 TeX 파트 첫머리에 \seclabel{이름}을 두면, 다른 곳의
% \secref{이름}이 `\S번호'로 바뀌어 그 절에 연결된다. 이름과 번호의 대응은
% \jobname.ref에 적어 두었다가 다음 조판에서 읽으므로 조판을 두 번 해야 한다.
% 절을 쪼개거나 끼워 넣어 번호가 바뀌어도 참조는 저절로 따라간다.
\def\secmap#1#2{\expandafter\gdef\csname sec:#1\endcsname{#2}}
\openin1=\jobname.ref
\ifeof1 \else \closein1 \input \jobname.ref \fi
\newwrite\secrefout
\immediate\openout\secrefout=\jobname.ref
\def\seclabel#1{\immediate\write\secrefout{\string\secmap{#1}{\cursec}}\ignorespaces}
\def\secref#1{\expandafter\ifx\csname sec:#1\endcsname\relax
    \S??\else\S\SN{\csname sec:#1\endcsname}\fi}
\let\GWEBM=\M
\def\M#1{\GWEBM{#1}\def\cursec{#1}}
\let\GWEBN=\N
\def\N#1#2#3{\GWEBN{#1}{#2}{#3}\def\cursec{#2}}

% 그림은 luamplib으로 조판 중에 그린다. 그림들이 함께 쓰는 도우미는 여기서 한 번 정의한다.
\input luamplib.sty
\font\eighttt=cmtt8 % 그림 라벨의 제어 시퀀스 이름
\def\cs#1{{\eighttt\char92 #1}}
\mplibcodeinherit{enable}
\mplibcode
bboxmargin := 3pt;
% 그림 pic을 중심이 c에 오도록 옮긴다
vardef placed(expr pic, c) = pic shifted (c - center pic) enddef;
% 상자에 든 글을 그리고 그 그림을 돌려준다
vardef boxed(expr pic, c) =
  save q; picture q; q := placed(pic, c); draw q; draw bbox q; q
enddef;
vardef westof(expr q) = (xpart llcorner bbox q, ypart center q) enddef;
vardef eastof(expr q) = (xpart lrcorner bbox q, ypart center q) enddef;
vardef northof(expr q) = (xpart center q, ypart ulcorner bbox q) enddef;
vardef southof(expr q) = (xpart center q, ypart llcorner bbox q) enddef;
\endmplibcode

\def\title{\TeX82}
% 차례는 문서 맨 끝에 찍히는데, Makefile이 qpdf로 그것을 맨 앞으로 옮긴다.
% 차례가 몇 쪽이 되든 옮길 수 있도록, 차례 앞에 이미 내보낸 쪽 수를 로그에 적어 둔다.
\def\topofcontents{\immediate\write-1{TOC begins after page
    \directlua{tex.sprint(status.total_pages)}}%
  \null\vfill
  \centerline{\titlefont \TeX: The Program}
  \vskip 15pt
  \centerline{도널드 커누스의 \TeX\ 프로그램을 한글 \.{GWEB}으로 옮김}
  \vfill}
\def\botofcontents{\vfill
  \ninepoint\baselineskip12pt
  \noindent 원본 \copyright\ 1982 Donald E. Knuth
  \bigskip\noindent
  커누스의 원본 파일 \.{tex.web}은 고치지 않는 한 얼마든지 복사하고 배포할 수 있다.
  고친 파일은 이름이 \.{tex.web}이 아닐 때에만 허용된다.
  \bigskip\noindent
  이 문서는 그 조건에 따라 원본을 한글과 \GO/로 옮긴 것이며,
  커누스의 \TeX\ 꾸러미의 일부가 아니다. 손대지 않은 원본은
  {\tt https://mirrors.ctan.org/systems/knuth/dist/tex/tex.web}에서
  받을 수 있다. 번역에 잘못이 있다면 그것은 옮긴이의
  탓이지 커누스의 탓이 아니다.}

% gweave가 형으로 알아보지 못하는 이름들.
@s bufio.Reader int
@s bufio.Writer int
@s os.File int
@s sync.WaitGroup int

@* 들어가며.
\TeX은 품질 높은 조판을 만들어 내려고 만든 문서 컴파일러다. 여기 실린 \GO/ 프로그램은
\TeX82를 정의한다. \TeX82는 \TeX의 표준판으로, 이식성을 무엇보다 앞세워 설계했기 때문에
@^TeX82@>
어떤 컴퓨터에서 돌리든 똑같은 출력을 얻을 수 있다.

이 프로그램이 바라는 것은 두 가지다. 하나는 \TeX의 알고리즘을 될 수 있는 대로 또렷하게
보여 주는 일이고, 다른 하나는 \GO/에서 될 수 있는 대로 빠르게 도는 일이다. 두 번째를 위해
아래 프로그램은 \GO/에만 있는 별난 기능을 아낌없이 쓴다. 고루틴과 통로로 일을 나누어 동시에
하고, 맵과 메서드는 물론 \.{unsafe} 꾸러미도 마다하지 않는다. 그러니 이 프로그램을 다른 언어로
옮기기는 쉽지 않을 것이다. 그래도 알고리즘이 흐려지지는 않는다. 이 문서를 \.{GWEB}으로 썼기
때문이다. 빠르게 하려고 덧댄 장치는 \.{GWEB}의 이름 있는 절에 따로 담아 그 자리에서 설명할 수
있으므로, 알고리즘의 줄기는 그대로 드러난다. 무엇을 덧대든 출력은 한 바이트도 달라지지 않는다.

\TeX\ 같은 큰 소프트웨어는 아무리 애써도 어느 수준 아래로는 줄일 수 없는 복잡함을 안고
있다. 조각 하나하나는 꽤 단순하더라도 그렇다. \.{GWEB}은 프로그램의 조각들이 어떻게
맞물리는지 드러내고 서로 관련된 부분을 상호 참조로 이어 주어서, 알고리즘을 될 수 있는
대로 읽기 쉽게 만들려는 도구다. 프로그램 곳곳에는 지금 무슨 일이 벌어지는지, 또 왜 하필
그런 방식으로 했는지를 자세히 풀어 놓았다. 다만 이 설명은 구현의 속사정을 밝히는 것이지
\TeX\ 언어 자체를 가르치려는 것은 아니다. 독자가 {\sl The \TeX book}을 이미 읽었다고
여기고 쓴 글이다.
@.GWEB@>
@^TeXbook@>
\par\vfill\noindent
\saveimageresource height 1.5in {texlion.pdf}\useimageresource\lastsavedimageresourceindex

@ \seclabel{go-native}이 판은 실험이다. 원본 \.{tex.web}은 이식성을 무엇보다 앞세워, 어느 언어로든
쉽게 옮길 수 있도록 웬만한 고급 언어에 다 있는 기능만 썼다. 이 번역도 처음에는 그 뜻을 따랐다.
나는 \.{go-native}라는 가지에서 그 반대를 해 보기로 했다(2026년 10월 31일). 고루틴과
통로, 맵, 메서드, \.{unsafe} 꾸러미까지, \GO/가 주는 것은 무엇이든 써서 이 프로그램을 될 수 있는
대로 빠르게 만드는 것이다. 조건은 딱 하나, 결과가 한 바이트도 달라지지 않는 것이다. DVI 파일과
기록 파일과 터미널 출력이 고치기 전의 프로그램이 내놓던 것과 똑같아야 하고, \.{TRIP} 시험의
결과도 그래야 한다. 포맷 파일만은 예외다. 포맷 파일의 형식은 원래 구현마다 다르니 얼마든지
바꿔도 된다.

해 보니 \TeX의 본체에는 동시에 돌릴 틈이 거의 없다. 토큰 하나가 뒤따르는 모든 것의 뜻을 바꿀
수 있고(\.{\\catcode}나 \.{\\def}를 생각해 보라), 메모리를 어떤 순서로 쓰는지가 기록 파일의
통계에 그대로 드러나며, \.{\\write}는 쪽을 내보내는 바로 그 순간에 전개되기 때문이다. 그래서
고루틴은 본체의 가장자리에서 일한다. 지금까지 고친 곳은 다음과 같다.
\smallskip
\item{$\bullet$} 배포판에서 파일을 찾는 색인을 고루틴들이 만든다(\secref{external-name}). 그
덕분에 plain 포맷을 만드는 데 0.38초 걸리던 것이 0.02초로, 짧은 문서 \.{story.tex}는 0.09초에서
0.01초로, \.{tex.web}을 조판한 536쪽짜리 문서는 0.54초에서 0.27초로 줄었다.
\smallskip\noindent
결과가 정말 같은지는 \.{tests/regress.sh}로 확인한다. 이 스크립트는 \.{main} 가지의 \.{tex.w}로
기준 프로그램을 따로 만들어, 두 프로그램의 출력을 바이트 단위로 견준다.

@ 지금의 구현에는 꽤 긴 역사가 있다. 시작은 1977년 여름이었다. 그해 5월에 저자가 쓴
명세를 바탕으로 마이클~F. 플래스와 프랭크~M. 리앙이 원형을 설계하고 짰다.
@^Plass, Michael Frederick@>
@^Liang, Franklin Mark@>
@^Knuth, Donald Ervin@>
이 첫 원형에는 매크로 정의와, 상자와 글루를 다루는 기본 조작이 들어 있었다. 그러나 줄
나누기, 쪽 나누기, 수식, 정렬 루틴, 오류 복구, 그리고 지금의 의미 둥지(semantic nest)는
아직 없었다. 게다가 토큰 목록 대신 문자 목록을 썼으므로, \.{\\halign} 같은 제어 시퀀스도
일곱 글자짜리 목록으로 나타냈다. 온전한 \TeX은 1977년 말에서 1978년 초 사이에 저자가
설계하고 짰다. 이 프로그램도 원형처럼 {\mc SAIL} 언어로 썼는데, 이 언어에는 훌륭한 디버깅
시스템이 딸려 있었다. {\mc SAIL} 코드를 지금의 ``웹''과 얼추 비슷한 꼴로 바꾸어 보자는
첫 계획은 1979년 초에 루이스 트랍 파르도와
@^Trabb Pardo, Luis Isidoro@>
저자가 세웠고, 이그나시오~A. 사발라가 1979년과 1980년에 걸쳐 그것을 온전히 구현해 냈다.
@^Zabala Salelles, Ignacio Andr\'es@>
\TeX82 프로그램은 저자가 1981년 후반과 1982년 초반에 썼다. 여기에는 레오니다스
@^Guibas, Leonidas Ioannis@>
@^Sedgewick, Robert@>
@^Wyatt, Douglas Kirk@>
기바스, 로버트 세지윅, 더글러스 와이엇이 1979년에 제록스 팰로앨토 연구소에서 {\mc MESA}로
쓴 \TeX\ 구현의 착상도 녹아 있다. 앞선 구현들에서 얻은 경험 덕분에 \TeX82에서는 수백
군데를 고칠 수 있었고, 그래서 시스템의 거의 모든 부분이 눈에 띄게 나아졌다. 1982년
9월에 ``Version 0''을 내놓은 뒤로는 많은 사람의 의견에서 큰 도움을 받았는데, 특히
데이비드~R. 퍽스와 하워드~W. 트리키의 도움이 컸다. 1989년 9월의 마지막 큰 개정에서는
입력 문자 집합을 8비트 코드로 넓혔고, 마이클~J. 퍼거슨의 착상을 바탕으로 여러 언어의
낱말에 하이픈을 넣을 수 있게 했다.
@^Fuchs, David Raymond@>
@^Trickey, Howard Wellington@>
@^Ferguson, Michael John@>

더 고칠 데가 아직 많으리라는 것은 의심할 여지가 없다. 그래도 저자는 이제부터 \TeX82를
``얼려'' 두기로 굳게 마음먹었다. 앞으로 이 프로그램의 가장 큰 미덕은 안정성과 신뢰성이
될 것이다.

그렇다고 손을 댈 수 없는 것은 아니다. \TeX82의 핵심은 그대로 둔 채 \.{GWEB} 서술을
덧붙여 \TeX을 확장할 수 있고, 이 프로그램은 그런 확장이 그리 어렵지 않도록 짜여 있다.
다만 \TeX을 조금이라도 고쳤다면 여기서 정의하는 문자열 |banner|도 반드시 바꾸어야 한다.
그래야 무슨 문제가 생겼을 때 어느 판의 \TeX이 범인인지 바로 알 수 있다.
@^extensions to \TeX@>
@^system dependencies@>

이 프로그램을 고쳐서 만든 시스템을 `\TeX'이라고 불러서는 안 된다. `\TeX'이라는 공식
이름은 서로 완전히 호환되는 소프트웨어에만 쓰도록 남겨 두었다. 어떤 구현이 `\TeX'이라고
불릴 만한지 가리는 데 쓰라고 ``\.{TRIP} 시험''이라는 특별한 시험 묶음도 마련해 두었다[스탠퍼드
대학교 전산학과 보고서 CS1027, 1984년 11월 참조].

@<정의@>=
const banner = "This is TeX, Version 3.141592653 (GWEB)" // \TeX이 시작할 때 찍는다

@ \seclabel{conventions}이 프로그램은 \GO/로 썼다. \GO/에는 공식 명세가 하나뿐이고 그 명세를 따르는
컴파일러를 거의 모든 시스템에서 쓸 수 있으므로, 컴파일러마다 다른 관례에 맞추느라 애쓸
일은 별로 없다. 그래도 운영체제와 주고받는 부분, 이를테면 파일을 찾아 열거나 터미널과
대화하는 부분은 시스템마다 다를 수밖에 없다. 시스템에 따라 고쳐야 할지도 모르는 곳은
찾아보기의 `system dependencies' 항목에 그 절 번호를 모두 모아 두었다.
@^system dependencies@>

아래의 \TeX\ 프로그램은 \GO/의 기능을 가리지 않고 쓴다. 다만 처음부터 그렇게 짠 것은 아니다.
뼈대는 원본처럼 웬만한 고급 언어에 다 있는 기능으로 짰고, 거기에 \GO/의 기능을 하나씩 덧대어
가는 중이다(\secref{go-native}). 그래서 지금은 코드의 대부분이 아직 그 뼈대의 모습이다. 따로 도는
고루틴은 사용자가 보내는 끼어들기 신호를 받는 곳과 파일 색인을 만드는 곳에 있다. 자료 구조는
모두 크기가 정해진 배열 몇 개에 들어 있고,
포인터라고 부르는 것도 실은 그 배열의 첨자일 뿐이다. 이 밖에 프로그램 전체에 걸친 관례를
몇 가지 적어 둔다.
\smallskip
\item{$\bullet$} 식별자는 \GO/의 관례대로 낙타 등 표기(|getNext|)로 쓴다. 여러 낱말로 된
이름은 둘째 낱말부터 첫 글자를 대문자로 쓰고, |endOfTEX|의 \TeX처럼 머리글자로 된 말은
대문자 그대로 둔다. 이름이 \GO/의 예약어와 겹치면 다른 이름을 붙인다. 이를테면 노드의
\ID{type} 필드를 읽는 함수는 |typ|이다.
\item{$\bullet$} 전역 변수는 꾸러미 수준의 변수로, 프로시저와 함수는 모두 \GO/의 함수로
쓴다. 한 곳에서만 부르는 프로시저라도 프로그램의 짜임새를 드러내려고 따로 떼어 둔 것이
많다.
\item{$\bullet$} 메모리의 필드를 가리키는 이름, 이를테면 |link(p)|는 그 값을 읽는
함수다. 값을 바꿀 때는 짝이 되는 함수 |setLink(p,q)|를 부른다.
\item{$\bullet$} \.{GWEB}의 \.{@@d}는 코드를 만들지 않으므로, 상수와 작은 함수의 정의는
이름 있는 절 |@<정의@>|에 모은다. 어떤 함수의 몸통을 이루는 절에 정의가 딸려 나와야 하면,
그 정의는 바로 다음 절에 따로 둔다.
\item{$\bullet$} 문장 |goto|는 \GO/가 허락하는 한 그대로 쓴다. 함수 바깥으로 뛰어야 할 때는
|panic|과 |recover|로 흉내 낸다.
\smallskip\noindent
자료형이나 문자열을 다루는 방식 같은 나머지 관례는 처음 나오는 곳에서 그때그때 설명한다.

@ 프로그램은 여느 \GO/ 꾸러미처럼 |package| 선언과 |import| 목록으로 시작한다. 나머지
구성 요소는 \.{GWEB}의 관례에 따라 뒤에서 하나씩 채워 넣는다.
@.GWEB@>
이를테면 아래에서 `|@<전역 변수@>|'라고 적은 자리에는 변수 선언들이 줄줄이 들어가는데, 그
첫 선언은 이 문서의 \secref{globals}에 나온다. 덕분에 전역 변수를 한꺼번에 다 정의할 필요
없이, 저마다 무엇을 뜻하는지 이해할 준비가 되었을 때 하나씩 정의할 수 있다. 전역 변수를
모두 한눈에 보고 싶다면, \secref{globals}의 끝에 붙은 ``이 코드는 \dots절에도 정의되어
있다''라는 상호 참조를 따라가면 된다. 프로그램 머리의 다른 부분들도 마찬가지다.

\GO/에서는 꾸러미 수준의 선언을 어떤 순서로 적어도 되므로, 쓰기 전에 먼저 선언해 둘 필요가
없다. 그래서 프로시저와 함수는 모두 이름 있는 절 |@<함수들@>|에 모아 이 자리에 한꺼번에
끼워 넣는다. 주 프로그램은 \GO/의 |main| 함수다(\secref{main}).

@c
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"io/fs"
	"math"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
)

@<전역 레이블@>
@<전역 상수@>
@<전역 형@>
@<전역 변수@>
@<정의@>

func initialize() { // 이 프로시저는 일이 제대로 시작되게 한다
	@<초기화를 위한 지역 변수@>
	@<\TeX이 건드릴 만한 것은 무엇이든 초기화한다@>
}

@<기본 인쇄 프로시저@>
@<오류 처리 프로시저@>
@<함수들@>

@ 그러니까 \TeX\ 프로그램 전체는 방금 본 머리로 시작하고, 그 뒤에 프로시저와 함수 선언이
한 무더기 이어진다. 그리고 맨 끝에 가서야 `|startHere|'라는 주석으로 시작하는 주 프로그램이
나온다. 당장 주 프로그램부터 보고 싶다면 찾아보기에서 `|startHere|'를 찾으면 된다. 그러나
저자는 이 문서에 실린 순서를 대체로 따라 읽기를 권한다. 이 프로그램을 이해하는 데는 그
편이 가장 낫다. 꽤 복잡한 시스템을 이해하려 할 때 ``아래에서 위로'' 쌓아 올리는 방법과
``위에서 아래로'' 풀어 내려가는 방법이 저마다 장점이 있는데, 지금의 순서는 그 둘의 장점을
함께 살리려고 짠 것이다.

@ 처음 읽는 이를 위해 지도를 한 장 그려 두자. {\sl The \TeX book}의 7장은 \TeX을 눈과 입,
식도, 위, 창자를 가진 짐승에 빗대는데, 이 프로그램의 큰 덩어리들도 그 기관들과 꼭
@^eyes and mouth@>
@^stomach@>
@^bowels@>
들어맞는다. 눈은 입력 파일을 한 줄씩 읽고, 입은 그 문자들을 씹어 토큰으로 만든다
(|getNext|, 24부). 식도에서는 매크로나 조건문처럼 펼칠 수 있는 토큰이 펼쳐진다
(|expand|와 |getXToken|, 25--28부). 펼친 결과는 새 토큰 목록이 되어 입력 스택에 쌓이므로,
입이 그것을 다시 씹게 된다. 위는 더는 펼칠 수 없는 원시 명령만 받아서 실행하고, 그 결과로
가로 목록과 세로 목록과 수식 목록을 만든다(|mainControl|, 46--49부). 문단이 끝나면 가로
목록은 줄 나누기(38--43부)를 거쳐 세로 목록에 들어갈 줄들이 되고, 세로 목록은 쪽
조립기(44--45부)에서 한 쪽 분량씩 잘린다. 다 된 쪽은 창자가 \.{DVI} 파일로 내보낸다
(|shipOut|, 32부).
$$\mplibcode
beginfig(1);
save inp, gn, ex, mc, lb, bp, so, dvi; picture inp, gn, ex, mc, lb, bp, so, dvi;
inp := boxed(btex \vbox{\halign{\hfil#\hfil\cr 입력 파일\cr}} etex, (0,0));
gn := boxed(btex \vbox{\halign{\hfil#\hfil\cr 눈과 입\cr \ID{getNext}\cr 24부\cr}} etex, (110pt,0));
ex := boxed(btex \vbox{\halign{\hfil#\hfil\cr 식도\cr \ID{expand}\cr 25--28부\cr}} etex, (220pt,0));
mc := boxed(btex \vbox{\halign{\hfil#\hfil\cr 위\cr \ID{mainControl}\cr 46--49부\cr}} etex, (340pt,0));
lb := boxed(btex \vbox{\halign{\hfil#\hfil\cr 줄 나누기\cr \ID{lineBreak}\cr 38--43부\cr}} etex, (340pt,-85pt));
bp := boxed(btex \vbox{\halign{\hfil#\hfil\cr 쪽 조립기\cr \ID{buildPage}\cr 44--45부\cr}} etex, (220pt,-85pt));
so := boxed(btex \vbox{\halign{\hfil#\hfil\cr 창자\cr \ID{shipOut}\cr 32부\cr}} etex, (110pt,-85pt));
dvi := boxed(btex \vbox{\halign{\hfil#\hfil\cr \.{DVI} 파일\cr}} etex, (0,-85pt));
drawarrow eastof(inp) -- westof(gn);
drawarrow eastof(gn) -- westof(ex);
drawarrow eastof(ex) -- westof(mc);
drawarrow (xpart northof(ex), ypart northof(ex)){up} .. {down}(xpart northof(gn), ypart northof(gn))
  dashed evenly;
label.top(btex \ninepoint 펼친 토큰 목록 etex, 1/2[northof(gn),northof(ex)] + (0,16pt));
drawarrow southof(mc) -- northof(lb);
label.rt(btex \ninepoint 문단(가로 목록) etex, 1/2[southof(mc),northof(lb)]);
drawarrow westof(lb) -- eastof(bp);
drawarrow southof(mc) + (-20pt,0) -- northof(bp) + (20pt,0);
label.ulft(btex \ninepoint 세로 목록 etex, 1/2[southof(mc) + (-20pt,0), northof(bp) + (20pt,0)]);
drawarrow westof(bp) -- eastof(so);
label.bot(btex \ninepoint 한 쪽 etex, 1/2[westof(bp),eastof(so)]);
drawarrow westof(so) -- eastof(dvi);
endfig;
\endmplibcode$$
위가 일하면서 부르는 도우미들도 있다. 글꼴 계량 파일을 읽는 부분(30부), 상자를 꾸리는
|hpack|과 |vpack|(33부), 수식 목록을 가로 목록으로 바꾸는 |mlistToHlist|(36부), 그리고
정렬(37부)이 그렇다. 이 모든 것 밑에는 메모리, 문자열, 해시 표, 등가물 표처럼 모든 부분이
함께 쓰는 자료 구조가 깔려 있다(4--19부). 처음에는 이 바닥부터 차근차근 쌓아 올리게 된다.

@ \seclabel{outer-labels}주 프로그램에는 레이블이 세 개 있다. 그 가운데 |endOfTEX|와 |finalEnd|로는 다른
프로시저 안에서도 뛰어든다(\secref{first-line}, \secref{jump-out}). 그런데 \GO/의 |goto|는 함수
바깥으로 뛸 수 없다. 그래서 그런 곳에서는 가고 싶은 레이블을 값으로 삼아 |panic|을 일으키고,
주 프로그램이 그 값을 |recover|로 받아서 해당하는 곳으로 간다. 이 값의 형이 |outerLabel|이다.
\GO/에서는 레이블 이름과 보통 식별자의 이름 공간이 따로 있으므로, 주 프로그램 안의 레이블
|endOfTEX|와 상수 |endOfTEX|가 같은 이름이어도 부딪치지 않는다.

@<전역 레이블@>=
type outerLabel int32 // 주 프로그램의 레이블로 가는 |panic|의 값

const (
	startOfTEX outerLabel = 1    // \TeX의 변수들이 초기화되면 여기로 간다
	endOfTEX   outerLabel = 9998 // 파일을 닫고 우아하게 끝낼 때 여기로 간다
	finalEnd    outerLabel = 9999 // 이 레이블은 프로그램의 끝을 표시한다
)

@ 아래 코드 가운데 일부는 \TeX을 설치하다가 이따금 생기는 이상한 증상을 진단하거나, 시스템
마법사들이 자기가 무엇을 하는지도 잘 모르면서 \TeX을 만지작거릴 때에만 쓰라고 넣은
것이다. 그런 코드는 `|if debug {|$\,\ldots\,$|}|'로 둘러싸 두었다. 불 상수 |debug|는 보통
거짓이고, \GO/ 컴파일러는 조건이 상수인 |if| 문을 아예 지워 버리므로, 이런 코드는 컴파일하지
않은 것과 다를 바 없다.

`|if stat {|$\,\ldots\,$|}|'로 둘러싼 코드도 있다. 이쪽은 \TeX이 메모리를 얼마나 쓰는지
통계를 모으려고 넣은 것이다. 그런데 이 코드는 \.{\\tracingparagraphs},
\.{\\tracingpages}, \.{\\tracingrestores}가 찍는 진단 정보까지 맡고 있으므로 보통은
넣어서 컴파일한다. 그래서 상수 |stat|은 참으로 둔다.
@^debugging@>

@<정의@>=
const (
	debug = false // 디버깅할 때 |true|로 바꾼다
	stat  = true  // 사용 통계를 모으지 않으려면 |false|로 바꾼다
)

@ \seclabel{initex}이 프로그램에는 중요한 변형이 둘 있다. (1)~\.{INITEX}라고 부르는 길고 느린 판은 \TeX의
@.INITEX@>
내부 표를 처음부터 채우는 데 필요한 계산을 더 한다. 하이픈 넣기 패턴을 읽어 표로 만들거나
원시 명령의 이름을 해시 표에 넣는 일이 그런 것이고, 그렇게 채운 표는 포맷 파일로 내보낸다.
(2)~짧고 빠른 실무용 판은 그 포맷 파일을 읽어 들이기만 하므로 초기화가 아주 적다. 여기서는
프로그램 하나가 두 노릇을 다 한다. 불 변수 |iniVersion|이 참이면 (1)이다. (1)에는 필요하지만
(2)에는 필요 없는 부분은 `|if iniVersion {|$\,\ldots\,$|}|'로 둘러싼다. 이 변수의 값은 주
프로그램이 명령줄을 보고 정한다(\secref{main}).

@<\TeX이 건드릴...@>=
@<핵심 변수들의 초깃값을 정한다@>
if iniVersion {
	@<표의 항목들을 초기화한다(\.{INITEX}만 한다)@>
}

@ @<정의@>=
var iniVersion bool // 이것이 \.{INITEX}인가?

@ 이 프로그램은 디버깅할 때와 실무에 쓸 때 컴파일하는 방법을 달리할 필요가 없다. \GO/는
배열 첨자가 범위 안에 있는지 늘 검사하고, 정수 산술이 넘치는 것은 결코 잡지 않는다(넘친 값은
소리 없이 한 바퀴 돌아간다). 범위 검사는 디버깅할 때 큰 도움이 되고, 실무에서도 그리 비싸지
않다. 넘침을 잡지 못하는 것도 크게 걱정할 일은 아니다. 넘칠 만한 곳에서는 \TeX\ 자신이 미리
검사하기 때문이다.
@^system dependencies@>
@^overflow in arithmetic@>

@ 이 \TeX\ 구현은 \GO/ 언어 명세의 규칙을 따른다. 쓸모 있는 시스템 프로그램을 만들려면
어쩔 수 없이 들어가는 시스템 의존 코드만 예외다.
@^system dependencies@>
\TeX의 |switch| 문에는 맞는 레이블이 없을 때 실행하는 기본 경우 |default|가 자주 나온다.
\GO/의 |switch|는 맞는 경우 하나만 실행하고 끝나며(다음 경우로 저절로 넘어가지 않는다), 맞는
레이블도 |default|도 없으면 아무것도 하지 않고 지나간다. 기본 경우라는 장치가 없는 언어로 이
프로그램을 옮긴다면, |switch| 문마다 나머지 경우를 모두 늘어놓느라 고생해야 할 것이다.
그런 언어에 갇힌 사람들이 실제로 그 일을 해냈다. 성공은 했지만 즐겁지는 않았다!

@ 다음 매개변수들은 \TeX의 용량을 늘리거나 줄이고 싶을 때 컴파일하기 전에 바꿀 수 있다.
\.{INITEX}와 실무용 \TeX에서 값이 서로 달라도 된다.
@.INITEX@>
@^system dependencies@>

다만 여기서는 프로그램 하나가 \.{INITEX}와 실무용 판을 겸하므로(\secref{initex}), 아래 주석에
적은 조건 가운데 \.{INITEX} 쪽의 것을 늘 지켜야 한다. 곧 |memMax|는 |memTop|과 같아야 하고,
|memMin|은 |memBot|과 같아야 한다.

줄 버퍼의 크기 |bufSize|와 출력 버퍼의 크기 |dviBufSize|는 원래 500과 800이었는데 여기서는
늘려 잡았다. 요즘 문서에는 500자가 넘는 줄이 드물지 않다. 또 출력 버퍼가 크면
\secref{yz-matches}의 최적화가 앞에서 쓴 |y|와 |z|를 다시 쓸 기회를 더 멀리까지 찾아볼 수
있다. 16384는 오늘날 널리 쓰는 \TeX\ 구현과 같은 값이어서, \.{DVI} 파일도 바이트 하나까지
똑같이 나온다. 다만 \.{TRIP} 시험은 원래 값을 요구하므로, 시험용 \.{INITEX}를 만들 때는 원래
값으로 되돌린다.

@<전역 상수@>=
const (
	@!memMax = 30000 // \TeX의 내부 배열 |mem|의 가장 큰 첨자;
	@t\qquad@>// |maxHalfword|보다 엄격히 작아야 한다;
	@t\qquad@>// \.{INITEX}에서는 |memTop|과 같아야 하고, 그 밖에는 |>=memTop|
	@!memMin = 0 // \TeX의 내부 배열 |mem|의 가장 작은 첨자;
	@t\qquad@>// |minHalfword| 이상이어야 한다;
	@t\qquad@>// \.{INITEX}에서는 |memBot|과 같아야 하고, 그 밖에는 |<=memBot|
	@!bufSize = 20000 // 열린 파일들의 현재 줄과 \.{\\csname}과 \.{\\endcsname} 사이의
	@t\qquad@>// 제어 시퀀스에 동시에 들어 있는 문자 수의 최댓값; |maxHalfword|를 넘으면 안 된다
	@!errorLine = 72 // 터미널 오류 메시지의 문맥 줄의 너비
	@!halfErrorLine = 42 // 터미널 오류 메시지에서 문맥 첫 줄의 너비;
	@t\qquad@>// 30과 |errorLine-15| 사이여야 한다
	@!maxPrintLine = 79 // 출력하는 텍스트 줄의 가장 긴 너비; 적어도 60이어야 한다
	@!stackSize = 200 // 동시에 열려 있는 입력원의 최대 개수
	@!maxInOpen = 6 // 동시에 진행할 수 있는 입력 파일과 오류 삽입의 최대 개수
	@!fontMax = 75 // 내부 글꼴 번호의 최댓값; |maxQuarterword|를 넘으면 안 되고
	@t\qquad@>// 많아야 |fontBase+256|이어야 한다
	@!fontMemSize = 20000 // 모든 글꼴을 위한 |fontInfo|의 낱말 수
	@!paramSize = 60 // 동시에 쓰이는 매크로 매개변수의 최대 개수
	@!nestSize = 40 // 동시에 활성인 의미 수준의 최대 개수
	@!maxStrings = 3000 // 문자열의 최대 개수; |maxHalfword|를 넘으면 안 된다
	@!stringVacancies = 8000 // \TeX\ 자신의 오류 메시지를 저장한 뒤에 사용자의
	@t\qquad@>// 제어 시퀀스와 글꼴 이름을 위해 남아 있어야 할 문자 수의 최솟값
	@!poolSize = 32000 // 문자열들에 든 문자 수의 최댓값; 모든 오류 메시지와 도움말,
	@t\qquad@>// 모든 글꼴과 제어 시퀀스의 이름을 포함한다; |stringVacancies|보다
	@t\qquad@>// \TeX\ 자신의 문자열들의 전체 길이(지금 약 23000)만큼 커야 한다
	@!saveSize = 600 // 현재 그룹 바깥의 값들을 저장하는 공간; 많아야 |maxHalfword|
	@!trieSize = 8000 // 하이픈 넣기 패턴을 위한 공간; 실무용 \TeX보다
	@t\qquad@>// \.{INITEX}에서 더 커야 한다
	@!trieOpSize = 500 // 하이픈 넣기 패턴의 ``연산 코드''를 위한 공간
	@!dviBufSize = 16384 // 출력 버퍼의 크기; 8의 배수여야 한다
	@!fileNameSize = 1024 // 파일 이름은 이보다 길면 안 된다
)

@ 다음 값들도 앞의 매개변수들처럼 \TeX의 용량을 조절하려고 컴파일하기 전에 바꿀 수 있다.
그러나 이것들을 바꾸었다면 초기화 프로그램 \.{INITEX}를 다시 돌려서 실무용 \TeX이 쓸 표를
@.INITEX@>
새로 만들어야 한다. 꽤 복잡한 초깃값 몇몇을 이 상수들로부터 계산하기 때문에, 함부로
이리저리 바꿀 수는 없다. 이 차이를 분명히 하려고, 이것들은 |@<전역 상수@>|에 넣지 않고
|@<정의@>|에 따로 둔다.

@<정의@>=
const (
	@!memBot = 0 // \.{INITEX}가 내보내는 |mem| 배열의 가장 작은 첨자;
	@t\qquad@>// |memMin|보다 작으면 안 된다
	@!memTop = 30000 // \.{INITEX}가 내보내는 |mem| 배열의 가장 큰 첨자;
	@t\qquad@>// |memBot|보다 상당히 커야 하고 |memMax|보다 크면 안 된다
	@!fontBase = 0 // 가장 작은 내부 글꼴 번호; |minQuarterword|보다 작으면 안 된다
	@!hashSize = 2100 // 제어 시퀀스의 최대 개수; 많아야 대략
	@t\qquad@>// |(memMax-memMin)/10|이어야 한다
	@!hashPrime = 1777 // |hashSize|의 약 85\pct!에 해당하는 소수
	@!hyphSize = 307 // 또 하나의 소수; \.{\\hyphenation} 예외의 개수
)
@^system dependencies@>

@ \seclabel{globals}누군가 실수로 ``상수''를 잘못 정해 두었을 수도 있다. \TeX은 그런 경우에 대비해
|bad|라는 전역 변수를 두고 상수들을 검사한다. 검사에 걸리면 |bad|에 0이 아닌 번호가 들어가고,
\TeX은 그 번호를 알리면서 일을 시작하지 않는다.

\TeX에는 전역 변수를 정의하는 절이 아주 많은데, 이것이 그 첫 번째다.

@<전역 변수@>=
var @!bad int32 // 어떤 ``상수''가 잘못되었나?

@ 나중에 가면 `|if memMax>=maxHalfword {bad=14}|' 같은 검사도 하게 된다. 지금은 아직
|maxHalfword|를 정의하지 않았으므로 할 수 없다. 여기서는 지금까지 나온 상수들끼리 서로 맞는지만
본다. 검사마다 번호가 달라서, |bad|의 값을 보면 어느 조건이 어긋났는지 알 수 있다.

@<``상수'' 값들이 서로 맞는지 검사한다@>=
bad = 0
if halfErrorLine < 30 || halfErrorLine > errorLine-15 {
	bad = 1
}
if maxPrintLine < 60 {
	bad = 2
}
if dviBufSize%8 != 0 {
	bad = 3
}
if memBot+1100 > memTop {
	bad = 4
}
if hashPrime > hashSize {
	bad = 5
}
if maxInOpen >= 128 {
	bad = 6
}
if memTop < 256+11 {
	bad = 7 // 우리는 |nullList>255|이기를 바랄 것이다
}

@ \seclabel{labels}가끔 나오는 |goto| 문이 무슨 뜻인지 잘 드러나도록, 레이블에는 하는 일을 짐작할 수
있는 이름을 붙인다. 레이블 `|restart|'는 프로시저의 맨 앞에, 레이블 `|reswitch|'는 |switch|
문 바로 앞에 이따금 나온다. 어떤 경우를 처리하다가 조건을 바꾸어 다른 경우로 넘어가야 할 때
쓰는 것이다. 루프에서 빠져나올 때는 흔히 `|done|'이나 `|found|'나 `|notFound|'로 가고, 처음부터
되풀이할 때는 `|again|'으로 간다. 서브루틴의 여러 부분이 시작은 서로 다르지만 끝은 같다면, 그
공통 코드를 `|commonEnding|'에 모아 둔다. 프로시저를 끝낼 때는 대개 그냥 |return|하지만,
|macroCall|이나 |tryBreak|처럼 끝나기 전에 할 일이 남아 있는 프로시저에서는 그 일 바로 앞에
레이블 `|exit|'를 두고 그리로 간다.

덧붙이자면 이 프로그램은 쓰지 않는 레이블을 결코 선언하지 않는다. \GO/ 컴파일러가 쓰지 않는
레이블을 오류로 다루기 때문이다.

@ 흔히 쓰는 프로그래밍 관용구는 \GO/에 다 있다. 변수를 1 늘리고 줄이는 것은 |x++|와 |x--|,
부호를 바꾸는 것은 |x=-x|, |goto|로 빠져나갈 때까지 끝없이 되풀이하는 것은
`|for {|$\,\ldots\,$|}|', 프로시저를 끝내고 돌아가는 것은 |return|이다. 다만 널 상수에는
따로 기호 이름을 붙여 둔다.

@<정의@>=
const empty = 0 // 널 상수의 기호 이름

@ 정수의 절댓값을 구하는 함수 |abs|와 홀수인지 가리는 함수 |odd|는 \GO/에 없으므로 여기서
만든다. 실수를 가장 가까운 정수로 바꾸는 함수 |round|도 만든다. 이 함수는 \GO/의 |math.Round|처럼
딱 한가운데에 있는 값은 0에서 먼 쪽으로 반올림한다. 이를테면 $2.5$는 3이 되고 $-2.5$는 $-3$이
된다. 결과가 정수 범위를 벗어나면 $\pm(2^{31}-1)$로 자른다. \GO/에서는 범위를 벗어나는
|float64|를 |int32|로 바꾸면 결과가 어떻게 될지 정해져 있지 않기 때문이다.

@<정의@>=
func abs(x int32) int32 {
	if x < 0 {
		return -x
	}
	return x
}

func odd(x int32) bool { return x%2 != 0 }

func round(r float64) int32 {
	if r > 2147483647.0 {
		return 2147483647
	}
	if r < -2147483647.0 {
		return -2147483647
	}
	return int32(math.Round(r))
}

@* 문자 집합.
\TeX을 온갖 컴퓨터로 쉽게 옮겨 갈 수 있도록, 입력 텍스트는 모두 내부 8비트 코드로
바꾸어 다룬다. 이 내부 코드는 표준 {\mc ASCII}(``American Standard Code for Information
Interchange'')를 그대로 품고 있다. 문자는 읽어 들이는 즉시 내부 코드로 바뀌고, 거꾸로
텍스트 파일에 쓰기 직전에 {\mc ASCII}에서 사용자 쪽의 외부 표현으로 되돌아간다. 그러니
\TeX의 안쪽에서는 컴퓨터가 원래 어떤 문자 코드를 쓰든 신경 쓸 필요가 없다.

\TeX\ 사용자에게 이 내부 코드가 중요한 까닭은 주로 그것이 글꼴 안의 문자 위치를 정하기
때문이다. 이를테면 문자 `\.A'의 {\mc ASCII} 코드는 $65=\.{'101}$이므로, \TeX은 이 글자를
조판할 때 현재 글꼴의 65번 문자를 고른다. 그 글꼴이 실제로는 `\.A'를 다른 자리에 두었더라도
\TeX은 진짜 자리가 어디인지 알 길이 없다. {\mc ASCII}를 특정 글꼴의 인코딩으로 바꾸는 일은
\TeX이 만든 장치 독립 파일을 받아 실제로 인쇄하는 프로그램이 맡는다.
@^ASCII code@>

\TeX의 내부 코드는 역따옴표로 시작하는 상수의 값도 정한다(이를테면 \.{`A}는 65다). 또
\.{\\catcode}, \.{\\mathcode}, \.{\\uccode}, \.{\\lccode}, \.{\\delcode} 같은 표에서도 이
코드가 첨자로 쓰인다.

@ \seclabel{ascii-code}\TeX의 내부 형태로 바꾼 텍스트 문자의 형을 |asciiCode|라고 부른다. 값은 0부터
255까지의 정수다.

이 프로그램에서는 \TeX이 쓰는 정수 형을 거의 다 |int32|의 별칭으로 둔다. 한 바이트짜리
형(|uint8|)을 쓰면 메모리는 아낄 수 있지만, 그러면 정수 형끼리 섞어 쓰는 곳마다 형 변환을
넣어야 한다. 별칭(|type asciiCode = int32|)은 새로운 형이 아니라 같은 형에 붙인 또 하나의
이름일 뿐이어서, 다른 정수와 아무 거리낌 없이 섞어 쓸 수 있다. 그 대신 값이 0과 255 사이에
있는지는 형이 지켜 주지 않으므로 프로그램이 스스로 지켜야 한다.

@<전역 형@>=
type @!asciiCode = int32 // 8비트 수

@ 이 \TeX\ 명세는 텍스트 파일이 64가지보다 많은 문자를 구별할 수 있다고 보고 쓴 것이다.
좀 더 정확히 말하면, 적어도 {\mc ASCII} 코드 \.{'40}부터 \.{'176}까지에 해당하는 글자와
기호는 문자 집합에 있다고 가정한다. 요즘은 거의 모든 컴퓨터 터미널에서 이 문자들을 쓸 수
있다. 조판 프로그램이라면 대문자와 소문자를 둘 다 편하게 다룰 수 있어야 하는 것도 물론이다.

입력할 때 |asciiCode|로 바꾸고 출력할 때 |asciiCode|에서 되돌리는 외부 문자의 자료형을
|textChar|라고 부르기로 하자. \GO/에서 텍스트 파일의 문자는 바이트이므로 |textChar|는 |byte|의
별칭이고, 그 원소의 서수는 |firstTextChar|부터 |lastTextChar|까지다. 시스템에 따라서는 다음
정의를 고쳐야 할 수도 있다.
@^system dependencies@>

@<정의@>=
type textChar = byte // 텍스트 파일의 문자의 자료형

const (
	firstTextChar = 0   // |textChar|의 가장 작은 원소의 서수
	lastTextChar  = 255 // |textChar|의 가장 큰 원소의 서수
)

@ 초기화 함수 |initialize|에는 여러 곳에서 돌려쓰는 지역 변수 |i|가 하나 있다. 주로 표를
채우는 루프의 첨자로 쓴다.

@<초기화를 위한 지역 변수@>=
var @!i int32

@ \TeX은 두 배열 |xord|와 |xchr|로 {\mc ASCII} 코드와 사용자의 외부 문자 집합 사이를
오간다. 외부 문자 |c|를 읽으면 |xord[c]|가 그 내부 코드이고, 내부 코드 |k|를 찍을 때는
|xchr[k]|를 내보낸다.

@<전역 변수@>=
var @!xord [256]asciiCode // 입력 문자의 변환을 지정한다
var @!xchr [256]textChar  // 출력 문자의 변환을 지정한다

@ 여기서는 시스템이 표준 {\mc ASCII}의 보이는 문자를 모두 읽고 쓸 수 있다고 가정한다.
그 문자들을 꼭 {\mc ASCII} 코드로 나타내지는 않더라도 말이다. 그렇다면 다음 대입문들은
시스템에 따라 고칠 필요 없이 배열 |xchr|의 표준 부분을 제대로 채워 준다. 다만 문자 집합이
이보다 빈약한 시스템에 \TeX을 구현한다면 여기서 무언가를 바꾸어야 할 것이다.
@^system dependencies@>

@<핵심 변수들의...@>=
xchr[0o40] = ' '; xchr[0o41] = '!'; xchr[0o42] = '"'; xchr[0o43] = '#'
xchr[0o44] = '$'; xchr[0o45] = '%'; xchr[0o46] = '&'; xchr[0o47] = '\''
xchr[0o50] = '('; xchr[0o51] = ')'; xchr[0o52] = '*'; xchr[0o53] = '+'
xchr[0o54] = ','; xchr[0o55] = '-'; xchr[0o56] = '.'; xchr[0o57] = '/'
xchr[0o60] = '0'; xchr[0o61] = '1'; xchr[0o62] = '2'; xchr[0o63] = '3'
xchr[0o64] = '4'; xchr[0o65] = '5'; xchr[0o66] = '6'; xchr[0o67] = '7'
xchr[0o70] = '8'; xchr[0o71] = '9'; xchr[0o72] = ':'; xchr[0o73] = ';'
xchr[0o74] = '<'; xchr[0o75] = '='; xchr[0o76] = '>'; xchr[0o77] = '?'
xchr[0o100] = '@@'; xchr[0o101] = 'A'; xchr[0o102] = 'B'; xchr[0o103] = 'C'
xchr[0o104] = 'D'; xchr[0o105] = 'E'; xchr[0o106] = 'F'; xchr[0o107] = 'G'
xchr[0o110] = 'H'; xchr[0o111] = 'I'; xchr[0o112] = 'J'; xchr[0o113] = 'K'
xchr[0o114] = 'L'; xchr[0o115] = 'M'; xchr[0o116] = 'N'; xchr[0o117] = 'O'
xchr[0o120] = 'P'; xchr[0o121] = 'Q'; xchr[0o122] = 'R'; xchr[0o123] = 'S'
xchr[0o124] = 'T'; xchr[0o125] = 'U'; xchr[0o126] = 'V'; xchr[0o127] = 'W'
xchr[0o130] = 'X'; xchr[0o131] = 'Y'; xchr[0o132] = 'Z'; xchr[0o133] = '['
xchr[0o134] = '\\'; xchr[0o135] = ']'; xchr[0o136] = '^'; xchr[0o137] = '_'
xchr[0o140] = '`'; xchr[0o141] = 'a'; xchr[0o142] = 'b'; xchr[0o143] = 'c'
xchr[0o144] = 'd'; xchr[0o145] = 'e'; xchr[0o146] = 'f'; xchr[0o147] = 'g'
xchr[0o150] = 'h'; xchr[0o151] = 'i'; xchr[0o152] = 'j'; xchr[0o153] = 'k'
xchr[0o154] = 'l'; xchr[0o155] = 'm'; xchr[0o156] = 'n'; xchr[0o157] = 'o'
xchr[0o160] = 'p'; xchr[0o161] = 'q'; xchr[0o162] = 'r'; xchr[0o163] = 's'
xchr[0o164] = 't'; xchr[0o165] = 'u'; xchr[0o166] = 'v'; xchr[0o167] = 'w'
xchr[0o170] = 'x'; xchr[0o171] = 'y'; xchr[0o172] = 'z'; xchr[0o173] = '{'
xchr[0o174] = '|'; xchr[0o175] = '}'; xchr[0o176] = '~'

@ 보이는 모양이 없는 {\mc ASCII} 코드 가운데 몇 개는 이 프로그램에서 특별한 뜻으로 쓰므로
기호 이름을 붙여 둔다.

@<정의@>=
const (
	@!nullCode       = 0o0   // 사라질지도 모르는 {\mc ASCII} 코드
	@!carriageReturn = 0o15  // 줄 끝에 쓰는 {\mc ASCII} 코드
	@!invalidCode    = 0o177 // 많은 시스템이 텍스트 파일에서 금지하는 {\mc ASCII} 코드
)

@ {\mc ASCII} 코드는 어느 정도까지만 ``표준''이다. 94개보다 많은 인쇄 문자를 쉽게 쓸 수
있는 편이 낫다고 여긴 컴퓨터 설치처가 많았기 때문이다. 문자들과 \TeX\ 내부 표현 사이를
어떻게 대응시키려 했는지는 {\sl The \TeX book}의 부록~C에 모두 나와 있다.
@^TeXbook@>

입출력 파일에 표준 {\mc ASCII} 코드만 나오는 시스템이라면 |xchr[0 .. @'37]|에 무엇을
넣든 별 상관이 없다. 그래도 가장 안전한 것은 아래 코드처럼 모두 공백으로 두는 것이다.

그러나 |xchr|를 다르게 정하면, 문자 집합이 더 넓은 컴퓨터에서 \TeX을 한결 편하게 쓸 수
있다. 이를테면 사용자가 `\.{\\ne}' 대신 `\.^^Z' 같은 글자 하나를 칠 수 있게 된다. 그런
컴퓨터를 가진 사람은 \TeX\ 사용자가 입력 파일에 쓸 수 있는 문자마다 마음대로 코드를 정해
|xchr|에 넣으면 된다. 될 수 있으면 부록~C에 보인 대응을 따르는 것이 가장 좋지만 꼭 그래야
하는 것은 아니다. 이를테면 알파벳이 26글자보다 많은 나라라면 늘어난 글자들을 \.{'40}보다
작은 코드에 대응시키는 편이 대개 가장 낫다. 가장 ``너그러운'' 문자 집합을 원한다면 이
대입문들의 오른쪽에 있는 |' '|를 |textChar(i)|로 바꾸면 된다. 그러면 256개의 코드가 모두
제 모습 그대로 드나든다.
@^character set dependencies@>
@^system dependencies@>

@<핵심 변수들의...@>=
for i = 0; i <= 0o37; i++ {
	xchr[i] = ' '
}
for i = 0o177; i <= 0o377; i++ {
	xchr[i] = ' '
}

@ 다음 코드는 시스템과 상관없이 배열 |xord|에 |xchr|의 역을 알맞게 채운다. 먼저 모든
외부 문자를 |invalidCode|로 두고, 그다음 |xchr|를 거꾸로 따라가며 내부 코드를 적는다.
두 코드 |i<j<@'177|에 대해 |xchr[i]=xchr[j]|이면 |xord[xchr[i]]|에는 |j| 이상인 값이
남는다는 데 눈여겨보자. 나중에 적은 것이 앞의 것을 덮어쓰기 때문이다. 그래서 두 코드가
우연히 같은 외부 문자에 대응하면, \.{'40}보다 작은 코드보다 표준 {\mc ASCII} 코드가
이긴다. 이를테면 위의 기본 설정에서는 |xchr[0 .. @'37]|이 모두 공백이지만, 공백을 읽으면
|xord|는 어김없이 \.{'40}을 내준다.

@<핵심 변수들의...@>=
for i = firstTextChar; i <= lastTextChar; i++ {
	xord[textChar(i)] = invalidCode
}
for i = 0o200; i <= 0o377; i++ {
	xord[xchr[i]] = i
}
for i = 0; i <= 0o176; i++ {
	xord[xchr[i]] = i
}

@* 입력과 출력.
이식성을 해치는 골칫거리 가운데 하나는 운영체제마다 입력과 출력을 다루는 방식이 아주
다르다는 것이다. 아마 전산학자들이 이 문제에 그리 마음을 쓰지 않았기 때문일 것이다.
사람들은 어쩐지 입출력이 ``진짜'' 프로그래밍은 아니라고 느껴 왔다. 하기야 어떤
프로그래밍이 다른 것보다 더 재미있는 것은 사실이다. 지금의 입출력 관례는 이렇게나
가지가지이고 이렇게나 지저분하니, 코드의 이런 부분에서 기쁨을 맛볼 길은 드물다.
프로그램을 조금이나마 덜 나쁘게 만드는 방법을 찾아냈을 때가 고작이다. 우리 앞에는 두
갈래 길이 있다. 지금 입출력에 덤벼들어 해치워 버리든지, 끝 무렵까지 미루든지. 어느 쪽도
그리 내키지 않으니, 해치워 버리기로 하자.

해야 할 기본 연산은 다음과 같다. (1)~파일이나 사용자의 터미널에서 텍스트를 읽고,
그곳으로 텍스트를 쓴다. (2)~파일에서 8비트 바이트를 읽고, 파일로 8비트 바이트를 쓴다.
(3)~운영체제에게 어떤 파일의 입력이나 출력을 시작하라(``열라''), 또는 끝내라(``닫으라'')고
지시한다. (4)~입력 파일의 끝에 이르렀는지 검사한다.

\TeX이 다루는 파일은 두 종류다. 텍스트 자료를 담은 파일을 |alphaFile|이라 부르고, 8비트 이진
정보를 담은 파일을 |byteFile|이라 부르기로 하자. 두 형이 같은 컴퓨터도 많지만 때로는 중요한
차이가 있으므로, 여기서는 둘을 꼼꼼히 가른다. 텍스트 파일은 줄 단위로 읽고 쓰며 문자 코드를
바꾸어야 하지만, 이진 파일은 바이트를 손대지 않고 그대로 옮겨야 하기 때문이다. 요즘은 이런
파일을 고속 망으로 이 컴퓨터에서 저 컴퓨터로 옮기는 표준 규약을 쓸 수 있는 사용자 집단도
점점 늘고 있다.

사실 이 프로그램은 세 번째 종류의 파일도 쓴다. 낱말 파일 |wordFile|이라고 부르는 이 파일은
프로그램이 자기 초기화에 쓸 기본 정보, 곧 포맷 파일을 내보냈다가 다시 읽어 들이는 데 쓴다.
낱말 파일의 정체는 나중에 정의하지만, 그 전에도 낱말 파일을 다루는 간단한 연산들은 정해 둘
수 있다.

\GO/에서는 운영체제의 파일 |os.File|에 버퍼를 둔 읽기 객체와 쓰기 객체를 함께 묶은 구조체로
파일을 나타낸다. 이진 파일에는 필드를 둘 더 둔다. 필드 |buf|에는 파일의 현재 원소가 들어
있고, 필드 |atEOF|는 파일 끝에 이르렀는지 알려 준다. 이렇게 하면 다음 원소를 읽어 오기 전에
현재 원소를 언제든 들여다볼 수 있다. 파일을 인자로 받는 프로시저에는 파일을 가리키는 포인터를
넘긴다.

@<전역 형@>=
type @!eightBits = int32 // 부호 없는 한 바이트짜리 양
type @!alphaFile struct { // 텍스트 자료를 담은 파일
	f *os.File
	r *bufio.Reader
	w *bufio.Writer
}
type @!byteFile struct { // 이진 자료를 담은 파일
	f      *os.File
	r      *bufio.Reader
	w      *bufio.Writer
	buf    eightBits // 파일의 현재 원소
	atEOF bool       // 파일의 끝에 이르렀는가?
}

@ 입출력에 관한 일은 대부분 \GO/의 표준 꾸러미 |os|와 |bufio|로 처리할 수 있다. 여기서 꼭
필요한 것은, 실행하는 도중에 정해지는 파일 이름에 파일 변수를 연결할 수 있어야 한다는
점이다. 사용자가 \.{\\input paper}라고 쳐야 비로소 어떤 파일을 열지 알게 되기 때문이다.
그래서 외부 이름을 |nameOfFile|에 넣어 주면 실행 시스템이 그 파일을 열 수 있다고 가정한다.
이 배열도 다른 문자 배열처럼 첨자 1부터 쓴다.
@^system dependencies@>

@<전역 변수@>=
var @!nameOfFile [fileNameSize + 1]textChar // 첨자는 |1 .. fileNameSize|
var @!nameLength int32 // |nameOfFile|에서 실제로 뜻이 있는 문자의 수(나머지는 공백)

@ \GO/의 |os.Open|과 |os.Create|는 파일을 열다가 무언가 잘못되더라도 운영체제의 오류
메시지를 내지 않고 오류 값만 돌려준다. 그런 이름의 파일이 없거나 다른 까닭으로 열 수
없으면(이를테면 누군가 같은 파일에 쓰고 있을 수도 있다) 그 값이 |nil|이 아니므로, \TeX은
그것을 보고 알맞게 대처할 수 있다. 이를테면 사용자에게 다른 파일 이름을 물어볼 수 있다.
@^system dependencies@>

\TeX의 파일 여는 프로시저들은 |nameOfFile|에 적힌 파일을 열 수 없으면 |false|를 돌려준다.
파일의 외부 이름은 바로 뒤에서 정의하는 함수 |externalName|이 |nameOfFile|을 보고 만든다.
이진 파일을 입력용으로 열 때는 첫 원소를 미리 읽어 |buf|에 넣어 둔다. 낱말 파일의 형
|wordFile|은 \secref{memory-word}에서 정의한다.

@<함수들@>=
func aOpenIn(f *alphaFile) bool { // 텍스트 파일을 입력용으로 연다
	file, err := os.Open(externalName())
	if err != nil { return false }
	*f = alphaFile{f: file, r: bufio.NewReader(file)}
	return true
}

func aOpenOut(f *alphaFile) bool { // 텍스트 파일을 출력용으로 연다
	file, err := os.Create(externalName())
	if err != nil { return false }
	*f = alphaFile{f: file, w: bufio.NewWriter(file)}
	return true
}

func bOpenIn(f *byteFile) bool { // 이진 파일을 입력용으로 연다
	file, err := os.Open(externalName())
	if err != nil { return false }
	*f = byteFile{f: file, r: bufio.NewReader(file)}
	bGet(f) // 첫 원소를 |f.buf|에 읽어 둔다
	return true
}

func bOpenOut(f *byteFile) bool { // 이진 파일을 출력용으로 연다
	file, err := os.Create(externalName())
	if err != nil { return false }
	*f = byteFile{f: file, w: bufio.NewWriter(file)}
	return true
}

@ 낱말 파일을 여는 함수도 같은 모양이다. 입력용으로 열 때는 이진 파일처럼 첫 원소를 미리
읽어 둔다.

@<함수들@>=
func wOpenIn(f *wordFile) bool { // 낱말 파일을 입력용으로 연다
	file, err := os.Open(externalName())
	if err != nil { return false }
	*f = wordFile{f: file, r: bufio.NewReader(file)}
	wGet(f) // 첫 원소를 |f.buf|에 읽어 둔다
	return true
}

func wOpenOut(f *wordFile) bool { // 낱말 파일을 출력용으로 연다
	file, err := os.Create(externalName())
	if err != nil { return false }
	*f = wordFile{f: file, w: bufio.NewWriter(file)}
	return true
}

@ \seclabel{external-name}\TeX은 입력 파일을 찾지 못하면 그 이름 앞에 `\.{TeXinputs:}'를 붙여 다시 찾는다. 글꼴
파일이면 `\.{TeXfonts:}'를, 포맷 파일이면 `\.{TeXformats:}'를 붙인다(\secref{tex-area},
\secref{format-default}). 이것들은 \TeX82를 개발한 시스템에서 표준 파일들이 있는 곳을 가리키던
이름이다. 요즘 시스템에서는 이런 이름이 아무 뜻이 없으므로, 함수 |externalName|이 이 머리말을
알아보고 해당하는 파일을 대신 찾아 준다. 먼저 환경 변수 \.{TEXINPUTS}, \.{TEXFONTS},
\.{TEXFORMATS}에 쌍점으로 나누어 적은 디렉터리들을 차례로 뒤진다. 거기서 찾지 못하면 \TeX\
배포판이 쓰는 방식대로 찾는다. 다만 포맷 파일은 구현마다 형식이 달라 다른 \TeX의 것을 읽을
수 없으므로 배포판에서 찾지 않는다. 끝내 찾지 못하면 머리말을 뗀 이름을 돌려주므로, 그런
파일이 현재 디렉터리에 있으면 그것이 열린다.

배포판에서 파일을 찾는 것은 원래 \.{kpsewhich} 명령이 하는 일이다. 그런데 \.{kpsewhich}는
부를 때마다 배포판의 파일 목록 데이터베이스(\.{ls-R}, 26만 항목)를 처음부터 읽으므로 한 번에
0.1초쯤 걸린다. \.{story.tex} 같은 짧은 문서라면 \TeX이 실제로 조판하는 데 드는 시간의 스무
배다. 그래서 나는 이 일을 \GO/답게 나누어 하기로 했다(2026년 10월 31일). 주 프로그램은
시작하자마자 고루틴 하나를 띄워 파일 색인을 만들게 하고(\secref{texmf-index}), 자기는 그동안
포맷 파일을 읽고 조판을 시작한다. 배포판의 파일을 처음 찾을 때에야 색인이 다 됐는지
기다린다.

색인이 답을 하나로 정하지 못할 때만 \.{kpsewhich}에게 직접 묻는다. 같은 이름이 검색 경로의
한 원소 안에 여럿 있을 때, 그리고 이름을 아예 찾지 못했을 때가 그렇다. \.{kpsewhich}는
여럿 가운데 하나를 고르는 나름의 순서가 있고, 찾지 못하면 대소문자를 가리지 않고 한 번 더
찾아 본다. 이런 판단은 흉내 내기보다 그에게 맡기는 편이 안전하다. 그러면 어떤 이름에 대해서든
\.{kpsewhich}와 똑같은 파일을 고르게 된다.
@^system dependencies@>

@<함수들@>=
func externalName() string {
	nm := string(nameOfFile[1 : nameLength+1])
	for _, a := range [...]struct{ area, env, kind string }{
		{"TeXinputs:", "TEXINPUTS", "tex"}, {"TeXfonts:", "TEXFONTS", "tfm"},
		{"TeXformats:", "TEXFORMATS", ""}} {
		if rest, ok := strings.CutPrefix(nm, a.area); ok {
			nm = rest
			for _, dir := range filepath.SplitList(os.Getenv(a.env)) {
				if dir != "" {
					if _, err := os.Stat(filepath.Join(dir, nm)); err == nil {
						return filepath.Join(dir, nm)
					}
				}
			}
			if a.kind != "" {
				@<색인에서 |nm|을 찾아 하나로 정해지면 그 경로를 돌려준다@>
				if out, err := exec.Command("kpsewhich", nm).Output(); err == nil {
					if p := strings.TrimSpace(string(out)); p != "" {
						return p
					}
				}
			}
			break
		}
	}
	return nm
}

@ \seclabel{texmf-index}배포판이 파일을 찾는 길은 파일 종류마다 정해진 {\it 검색 경로\/}다.
검색 경로는 디렉터리 이름을 쌍점으로 이어 놓은 것이고, \.{kpsewhich -show-path=tfm}처럼 물으면
알려 준다. 경로의 원소 하나하나가 형 |texmfElt|의 값이 된다. 끝이 `\.{//}'인 원소는 그 아래를
모두 뒤지라는 뜻이고, 앞에 `\.{!!}'가 붙은 원소는 디스크를 뒤지지 말고 파일 목록 데이터베이스만
믿으라는 뜻이다. 데이터베이스는 디렉터리 트리의 뿌리에 놓인 \.{ls-R} 파일로, 그 트리 안의
디렉터리마다 거기 든 파일 이름을 적어 둔 것이다. 원소 가운데 어떤 데이터베이스의 트리 안에
드는 것은 그 데이터베이스를 보고, 그렇지 않은 것은 디스크를 직접 본다.

데이터베이스 하나는 형 |lsR|의 값이다. 파일 이름에서 그 이름을 담은 디렉터리들로 가는 표를
한 장이 아니라 여러 장 둔다. \.{ls-R}을 여러 조각으로 잘라 고루틴들이 동시에 읽고, 조각마다
표를 한 장씩 만들기 때문이다. 표들을 하나로 합치면 그만큼 시간이 더 드니 그대로 둔다. 찾을 때는
표들을 조각의 순서대로 보면 된다.

@<전역 형@>=
type @!texmfElt struct { // 검색 경로의 원소 하나
	dir    string // 디렉터리
	deep   bool   // 그 아래 디렉터리까지 모두 뒤지는가?
	onlyDB bool   // 데이터베이스만 믿는가?
	db     *lsR   // 이 원소를 덮는 데이터베이스, 없으면 |nil|
	sub    string // 데이터베이스의 뿌리에서 본 |dir|, `\.{./fonts/tfm}' 꼴
	files  map[string][]string // 디스크를 훑어 얻은 표, 이름에서 경로들로
}
type @!lsR struct { // 파일 목록 데이터베이스 하나
	root  string                // \.{ls-R}이 있는 디렉터리
	parts []map[string][]string // 조각마다 이름에서 디렉터리들로 가는 표
}

@ 색인을 만드는 고루틴은 일을 마치면 통로 |texmfReady|를 닫는다. 닫힌 통로에서 받기는 언제나
곧바로 끝나므로, 파일을 찾는 쪽은 찾을 때마다 이 통로에서 받기만 하면 된다. 처음에는 색인이
다 될 때까지 기다리고, 그 뒤로는 기다리지 않는다. 고루틴이 |texmfPath|에 써 둔 것은 통로를
닫기 전의 일이므로, 받기를 마친 쪽에서는 안전하게 읽을 수 있다.

@<전역 변수@>=
var @!texmfPath map[string][]texmfElt // 파일 종류(\.{tex}, \.{tfm})마다 검색 경로
var @!texmfReady = make(chan struct{}) // 색인이 다 되면 닫힌다

@ 주 프로그램은 시작하자마자 이 고루틴을 띄운다(\secref{main}). 이 고루틴의 일은 둘이다.
검색 경로를 받는 일과, 데이터베이스를 읽는 일이다.

@<파일 색인을 만들 고루틴을 띄운다@>=
go func() {
	defer close(texmfReady)
	@<\.{kpsewhich}에게서 검색 경로를 받아 |texmfPath|를 채운다@>
	@<데이터베이스와 디스크를 동시에 읽어 색인을 채운다@>
}()

@ \.{kpsewhich}에게 검색 경로를 물을 때도 데이터베이스를 다 읽는 0.1초가 든다. 그런데 경로를
알려 주는 데에는 데이터베이스가 필요 없다. 그래서 데이터베이스 목록을 담은 변수
\.{TEXMFDBS}를 없는 곳으로 돌려 놓고 묻는다. 그러면 거의 곧바로 답한다. \.{kpsewhich}는
한 번에 검색 경로 하나만 알려 주므로, 고루틴 둘이 \.{tex}와 \.{tfm}의 경로를 동시에 묻는다.
\.{kpsewhich}가 없으면 경로가 비므로, 그때는 모든 파일을 \.{kpsewhich}에게 직접 묻게
된다(그리고 못 찾는다).

이 고루틴은 데이터베이스가 어디 있는지도 스스로 알아내야 한다. `\.{!!}'가 붙은 원소에서
위로 올라가며 \.{ls-R}이 있는 디렉터리를 찾으면, 그것이 그 원소를 덮는 데이터베이스다.
\TeX\ 배포판의 기본 설정에서는 \.{TEXMFDBS}가 바로 이런 트리들의 목록이다.

@<\.{kpsewhich}에게서 검색 경로를...@>=
kinds, paths := [...]string{"tex", "tfm"}, [2]string{}
var pw sync.WaitGroup
for i, kind := range kinds {
	pw.Go(func() {
		cmd := exec.Command("kpsewhich", "-show-path="+kind)
		cmd.Env = append(os.Environ(), "TEXMFDBS="+os.DevNull)
		out, _ := cmd.Output()
		paths[i] = strings.TrimSpace(string(out))
	})
}
pw.Wait()
texmfPath = map[string][]texmfElt{}
dbs := map[string]*lsR{} // 뿌리 디렉터리에서 데이터베이스로
for i, kind := range kinds {
	for _, s := range filepath.SplitList(paths[i]) {
		var e texmfElt
		s, e.onlyDB = strings.CutPrefix(s, "!!")
		e.deep = strings.HasSuffix(s, "//")
		if e.dir = strings.TrimRight(s, "/"); e.dir == "" {
			continue
		}
		if e.onlyDB {
			@<|e.dir|에서 위로 올라가며 \.{ls-R}을 찾아 |dbs|에 올린다@>
		}
		texmfPath[kind] = append(texmfPath[kind], e)
	}
}

@ @<|e.dir|에서 위로...@>=
for d := e.dir; d != filepath.Dir(d); d = filepath.Dir(d) {
	if dbs[d] != nil {
		break
	}
	if _, err := os.Stat(filepath.Join(d, "ls-R")); err == nil {
		dbs[d] = &lsR{root: d}
		break
	}
}

@ 이제 원소마다 그것을 덮는 데이터베이스가 있는지 본다. 뿌리가 원소의 디렉터리이거나 그
조상인 데이터베이스가 덮는다. 데이터베이스마다 그것이 덮는 원소들을 |want|에 모아 두면,
\.{ls-R}을 읽을 때 쓸모없는 디렉터리를 건너뛸 수 있다. 데이터베이스가 덮지 않는 원소 가운데
`\.{//}'로 끝나는 것은 디스크를 훑어서 표를 만든다. 데이터베이스마다, 그리고 훑을 원소마다
고루틴을 하나씩 띄우고, 모두 끝나기를 |wg.Wait|로 기다린다.

@<데이터베이스와 디스크를...@>=
var wg sync.WaitGroup
want := map[*lsR][]texmfElt{}
for _, elts := range texmfPath {
	for i := range elts {
		e := &elts[i]
		for root, db := range dbs {
			if (e.dir == root || strings.HasPrefix(e.dir, root+"/")) &&
				(e.db == nil || len(root) > len(e.db.root)) {
				e.db, e.sub = db, "."+e.dir[len(root):]
			}
		}
		if e.db != nil {
			want[e.db] = append(want[e.db], *e)
		} else if e.deep && !e.onlyDB {
			e.files = map[string][]string{}
			wg.Go(func() { @<디스크에서 |e.dir| 아래를 모두 훑어 |e.files|를 채운다@> })
		}
	}
}
for db, es := range want {
	wg.Go(func() { @<\.{ls-R}을 조각내 고루틴마다 한 조각씩 읽게 한다@> })
}
wg.Wait()

@ @<디스크에서 |e.dir| 아래를...@>=
filepath.WalkDir(e.dir, func(p string, d fs.DirEntry, err error) error {
	if err == nil && !d.IsDir() {
		e.files[d.Name()] = append(e.files[d.Name()], p)
	}
	return nil
})

@ \.{ls-R}은 디렉터리마다 `\.{./tex/plain/base:}'처럼 쌍점으로 끝나는 머리 줄을 두고, 그
아래에 파일 이름을 한 줄에 하나씩 적는다. 디렉터리와 디렉터리 사이에는 빈 줄이 있다. 그래서
파일을 CPU 수만큼의 비슷한 크기로 자르되, 자르는 곳을 빈 줄 바로 다음의 머리 줄 앞으로 맞추면
조각마다 따로 읽을 수 있다. 조각의 표는 고루틴을 띄우기 전에 |db.parts|에 차례로 달아 두므로,
고루틴들이 어떤 순서로 끝나든 표의 순서는 파일 안의 순서와 같다.

@<\.{ls-R}을 조각내...@>=
data, err := os.ReadFile(filepath.Join(db.root, "ls-R"))
if err != nil {
	return
}
for k := runtime.NumCPU(); k > 0 && len(data) > 0; k-- {
	cut := len(data)
	if k > 1 {
		if j := bytes.Index(data[cut/k:], []byte("\n\n.")); j >= 0 {
			cut = cut/k + j + 2
		}
	}
	chunk, part := data[:cut], map[string][]string{}
	data = data[cut:]
	db.parts = append(db.parts, part)
	wg.Go(func() { @<조각 |chunk|를 읽어 표 |part|를 채운다@> })
}

@ 조각을 한 줄씩 읽는다. 머리 줄을 만나면 그 디렉터리가 |es|의 어느 원소에 드는지 보고,
들지 않으면 그 아래의 파일 이름들은 건너뛴다. \.{kpsewhich}처럼 이름이 점으로 시작하는 숨은
디렉터리도 건너뛴다. 절대 경로로 적힌 머리 줄은 드물지만, 그런 디렉터리도 건너뛰어 두면 거기
든 파일은 \.{kpsewhich}에게 물어서 찾게 된다.

@<조각 |chunk|를...@>=
dir, keep := "", false
for line := range bytes.Lines(chunk) {
	line = bytes.TrimSuffix(line, []byte("\n"))
	switch {
	case len(line) == 0 || line[0] == '%':
	case line[len(line)-1] == ':' && (line[0] == '.' || line[0] == '/'):
		dir, keep = string(line[:len(line)-1]), false
		for _, e := range es {
			if dir == e.sub || e.deep && strings.HasPrefix(dir, e.sub+"/") {
				keep = !strings.Contains(dir, "/.")
				break
			}
		}
	case keep:
		part[string(line)] = append(part[string(line)], dir)
	}
}

@ 찾는 쪽은 색인이 다 되기를 기다렸다가, 검색 경로의 원소를 차례로 본다. 데이터베이스가 덮는
원소는 데이터베이스의 표들에서, 디스크를 훑어 둔 원소는 그 표에서 찾고, 나머지 원소(현재
디렉터리 `\.{.}' 같은 것)는 그 디렉터리에 파일이 있는지 직접 본다. `\.{!!}'가 붙었는데
데이터베이스를 찾지 못한 원소는 건너뛴다. 처음으로 무언가 나온 원소에서
답이 하나뿐이면 그것이 답이다. 여럿이면 고르는 일을 \.{kpsewhich}에게 맡긴다. 데이터베이스가
덮는데 `\.{!!}'가 없는 원소에서 못 찾았을 때도 그렇다. \.{kpsewhich}라면 이어서 디스크를
뒤질 테니까.

@<색인에서 |nm|을...@>=
<-texmfReady
for _, e := range texmfPath[a.kind] {
	var found []string
	switch {
	case e.db != nil:
		for _, part := range e.db.parts {
			for _, d := range part[nm] {
				if d == e.sub || e.deep && strings.HasPrefix(d, e.sub+"/") {
					found = append(found, e.db.root+d[1:]+"/"+nm)
				}
			}
		}
	case e.onlyDB: // 데이터베이스를 못 찾았으니 이 원소에는 아무것도 없다
	case e.deep:
		found = e.files[nm]
	default:
		if _, err := os.Stat(filepath.Join(e.dir, nm)); err == nil {
			found = []string{filepath.Join(e.dir, nm)}
		}
	}
	if len(found) == 1 {
		return found[0]
	}
	if len(found) > 1 || e.db != nil && !e.onlyDB {
		break
	}
}

@ 파일은 루틴 |aClose|, |bClose|, |wClose|로 닫는다. 파일 |f|의 입력이나 출력을 다 마쳤을 때
@^system dependencies@>
부르면 된다. 닫은 파일은 원한다면 다시 열 수 있다. 또 |f|를 출력에 썼다면, 닫아야 비로소 그
외부 파일이 사용자의 디렉터리에 온전히 나타나 읽을 수 있게 된다. 여기서는 쓰기 버퍼를 먼저
비우고 나서 파일을 닫는다. 버퍼를 비우지 않고 닫으면 마지막 몇 바이트가 사라져 버린다.

이 프로시저들은 제대로 열리지도 않은 파일을 닫으려 할 때에도 오류 메시지를 내서는 안 된다.
그래서 열린 적이 없는 파일이면 아무 일도 하지 않는다.

@<함수들@>=
func aClose(f *alphaFile) { // 텍스트 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = alphaFile{}
}

func bClose(f *byteFile) { // 이진 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = byteFile{}
}

func wClose(f *wordFile) { // 낱말 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = wordFile{}
}

@ 이진 입력과 출력, 그리고 텍스트 출력은 간단한 루틴 몇 개로 해결되므로 특별히 준비할 것이
없다. 그러나 텍스트 입력은 읽은 문자를 |asciiCode| 값으로 바꾸어야 하므로 조금 더 까다롭다.
게다가 \TeX의 관례는 효율적이어야 하고, 사용자의 운영 환경과도 잘 어울려야 한다.

@ 텍스트 출력에는 프로시저 |write(f,@t$\ldots$@>)|와 |writeLn(f,@t$\ldots$@>)|를 쓴다. 두
프로시저는 인자들을 차례로 텍스트 파일 |f|에 쓰고, |writeLn|은 끝에 줄바꿈을 하나 덧붙인다.
인자로는 문자열, 문자(|byte|), 정수를 줄 수 있다. 정수는 앞에 공백을 채우지 않고 꼭 필요한
만큼의 너비로 찍는다. 이진 파일에서는 |bGet(f)|가 다음 원소를 |f.buf|에 읽어 오고,
|bPut(f,c)|가 바이트 |c|를 파일에 쓴다.

조심할 점이 하나 있다. \GO/에서 작은따옴표로 쓴 상수 |' '|는 문자가 아니라 정수(|rune|)다.
그래서 |write|에 넘기면 공백이 아니라 수 32가 찍힌다. 이를 피하려고 |write|에 넘기는 문자열
상수는 모두 큰따옴표로 쓴다.

@<함수들@>=
func write(f *alphaFile, xs ...any) {
	for _, x := range xs {
		switch x := x.(type) {
		case string:
			f.w.WriteString(x)
		case byte:
			f.w.WriteByte(x)
		case int:
			fmt.Fprint(f.w, x)
		case int32:
			fmt.Fprint(f.w, x)
		default:
			panic(fmt.Sprintf("write: %T", x))
		}
	}
}

func writeLn(f *alphaFile, xs ...any) {
	write(f, xs...)
	f.w.WriteByte('\n')
}

func bGet(f *byteFile) { // 다음 원소를 |f.buf|에 읽어 온다
	c, err := f.r.ReadByte()
	if err != nil {
		f.atEOF = true
		f.buf = 0
		return
	}
	f.buf = eightBits(c)
}

func bPut(f *byteFile, c eightBits) { // 바이트 하나를 쓴다
	f.w.WriteByte(byte(c))
}

@ 텍스트 파일은 |inputLn|이라는 루틴으로 한 번에 한 줄씩 읽는다. 이 함수는 전역 변수
|buffer|, |first|, |last|를 써서 정의하는데, 이 변수들은 나중에 자세히 설명한다. 지금은
|buffer|가 |asciiCode| 값의 배열이고, |first|와 |last|가 그 배열에서 텍스트 한 줄이 시작하고
끝나는 곳을 가리키는 첨자라는 것만 알아 두면 된다.

@<전역 변수@>=
var @!buffer [bufSize + 1]asciiCode // 읽고 있는 문자들의 줄
var @!first int32 // |buffer|에서 쓰이지 않는 첫 위치
var @!last int32 // |buffer|에 방금 입력한 줄의 끝
var @!maxBufStack int32 // |buffer|에서 쓰인 가장 큰 첨자

@ 함수 |inputLn|은 지정한 파일의 다음 줄을 버퍼 배열의 빈자리로 가져오고 |true|를 돌려준다.
파일을 이미 다 읽었다면 |false|를 돌려주고 |last=first|로 놓는다. 다시 말해 파일의 다음
줄을 나타내는 |asciiCode| 수들은 |buffer[first]|, |buffer[first+1]|, \dots, |buffer[last-1]|에
들어가고, 전역 변수 |last|는 |first|에 그 줄의 길이를 더한 값이 된다. 줄 끝의 공백은
지운다. 그러므로 |last=first|이거나(그 줄이 완전히 비어 있었다는 뜻이다)
|buffer[last-1]!=" "|이다.

줄이 너무 길어서 이대로 읽다가는 |last>=bufSize|가 될 것 같으면 |inputLn|은 넘침 오류를
낸다. 그렇게 해 두면 \TeX의 다른 부분은 배열 |buffer|의 경계를 넘을까 걱정하지 않고
|buffer[last+1]|을 마음 놓고 들여다볼 수 있다. 또 |inputLn|에 들어올 때는 언제나
|first<bufSize|이므로, ``빈'' 줄을 넣을 자리는 늘 있다.

변수 |maxBufStack|은 지금 하는 일을 해내려면 매개변수 |bufSize|가 얼마나 커야 하는지 재는
데 쓴다. 이 값도 |inputLn|이 그때그때 고쳐 둔다.

매개변수 |bypassEoln|이 |true|이면, 원래 |inputLn|은 줄의 첫 문자를 보기 전에 앞 줄의 끝
표시를 건너뛰어야 한다. 그러나 \GO/의 |bufio.Reader|로 읽을 때는 줄 끝 문자를 그 줄을 읽으면서
함께 읽어 버리는 편이 자연스럽다. 그러면 다음 줄을 읽기 전에 건너뛸 것이 남지 않으므로, 이
프로그램에서는 이 매개변수를 쓰지 않는다. 이 프로시저는 줄 끝에 이르면 그 너머를 읽지
않는다. 그래서 보통의 텍스트 파일뿐 아니라 사용자의 터미널에서 입력을 받을 때에도 쓸 수
있다. 터미널에서 다음 줄을 미리 읽으려 들면 사용자가 아직 치지도 않은 줄을 기다리느라
멈추어 버릴 것이다.

파일의 마지막 줄은 줄바꿈 문자로 끝나지 않을 수도 있는데, 그런 줄도 보통 줄처럼 읽는다.
함수 |inputLn|이 |false|를 돌려주는 것은 파일 끝에 이르러 첫 바이트조차 읽지 못했을 때뿐이다.

입력되는 문자는 모두 |inputLn|의 안쪽 루프를 지나므로, 이 루프는 \TeX의 ``안쪽 루프''의
일부다. 그러니 문자 배열을 한꺼번에 읽어 들이는 특별한 루틴이 있다면 그것을 써서 시스템의
부담을 덜어 주는 것이 현명하다. 다음 코드는 해야 할 일을 보여 주려고 한 번에 한 바이트씩
읽지만, 시스템에 따라 대개는 더 손볼 여지가 있다.
@^inner loop@>

@<함수들@>=
func inputLn(f *alphaFile, bypassEoln bool) bool { // 다음 줄을 입력하거나 |false|를 돌려준다
	last = first // 마태복음 19:30 참조
	c, err := f.r.ReadByte()
	if err != nil {
		return false
	}
	lastNonblank := first // 줄 끝의 공백을 지운 |last|
	for err == nil && c != '\n' {
		@<문자 |c|를 |buffer|에 넣고 다음 문자를 읽는다@>
	}
	last = lastNonblank
	return true
}

@ 앞 절의 안쪽 루프 몸통이다. 문자 하나를 내부 코드로 바꾸어 버퍼에 넣고, 그것이 공백이
아니면 ``마지막으로 본 공백 아닌 문자 다음 자리'' |lastNonblank|를 앞으로 옮긴다. 줄을 다
읽은 뒤 |last|를 이 값으로 되돌리면 줄 끝의 공백이 저절로 떨어져 나간다. 그사이에 버퍼가 가장
멀리까지 쓰인 자리 |maxBufStack|도 고쳐 두고, 버퍼가 꽉 차면 넘침을 알린다.
@^system dependencies@>

@<문자 |c|를 |buffer|에...@>=
if last >= maxBufStack {
	maxBufStack = last + 1
	if maxBufStack == bufSize {
		@<입력 버퍼의 넘침을 알리고 그만둔다@>
	}
}
buffer[last] = xord[c]
c, err = f.r.ReadByte()
last++
if buffer[last-1] != ' ' {
	lastNonblank = last
}

@ 사용자의 터미널도 다른 텍스트 파일과 똑같이 다룬다. 다른 점은 입력과 출력에 모두
쓰인다는 것뿐이다. 터미널을 입력 파일로 볼 때는 파일 변수 |termIn|으로, 출력 파일로 볼
때는 |termOut|으로 부른다.
@^system dependencies@>

@<전역 변수@>=
var @!termIn alphaFile // 입력 파일로서의 터미널
var @!termOut alphaFile // 출력 파일로서의 터미널

@ 터미널 파일들은 \GO/의 표준 입력과 표준 출력에 연결해 연다.
@^system dependencies@>

@<정의@>=
func tOpenIn()  { termIn.r = bufio.NewReader(os.Stdin) }  // 터미널을 텍스트 입력용으로 연다
func tOpenOut() { termOut.w = bufio.NewWriter(os.Stdout) } // 터미널을 텍스트 출력용으로 연다

@ 사용자의 터미널에서는 입력과 출력이 뒤섞이므로 둘의 박자를 맞추어야 할 때가 있다. 그럴
때 쓰라고 시스템에 따라 달라지는 프로시저 셋을 둔다. 첫째 |updateTerminal|은 지금까지 터미널에
쓴 것이 정말로 컴퓨터 안의 버퍼를 떠나 화면에 나갔는지 확인하고 싶을 때 부른다. 이를테면
재촉 기호를 찍고 사용자의 대답을 기다리기 전에 불러야, 사용자가 재촉 기호를 보지도 못한 채
기다리는 일이 없다. 둘째 |clearTerminal|은 사용자가 미리 쳐 둔 입력을 모두 없애고 싶을 때
부른다. 곧 뜻밖의 오류 메시지를 낼 참이기 때문이다. 셋째 |wakeUpTerminal|은 사용자가
운영체제에 무슨 지시를 해서 터미널 출력을 꺼 두었다면 그것을 되살린다. 첫째는 터미널의 출력
버퍼를 비우기만 하면 된다. 그러나 미리 쳐 둔 입력을 없애거나 꺼 둔 터미널을 되살리는
방법은 이식성 있게 할 길이 없으므로, 여기서는 나머지 둘이 아무 일도 하지 않는다.
@^system dependencies@>

@<정의@>=
func updateTerminal()  { termOut.w.Flush() } // 터미널 출력 버퍼를 비운다
func clearTerminal()   {}                     // 터미널 입력 버퍼를 비운다
func wakeUpTerminal() {}                     // 사용자가 출력을 막아 둔 것을 푼다

@ \seclabel{first-line}\TeX\ 입력의 첫 줄을 사용자의 터미널에서 읽으려면 특별한 루틴이 있어야 한다. 이 줄이
다른 줄과 다른 것은 기록 파일을 열기도 전에 읽기 때문이다. 일종의 ``닭이 먼저냐 달걀이
먼저냐'' 문제다. 사용자가 첫 줄에 `\.{\\input paper}'를 치거나, 첫 줄에서 부른 어떤 매크로가
그런 \.{\\input}을 하면 기록 파일의 이름은 `\.{paper.log}'가 된다. 그러나 터미널 입력의 첫
줄을 처리하는 동안 \.{\\input} 명령이 한 번도 실행되지 않으면, 기록 파일에는 기본 이름
`\.{texput.log}'가 붙는다. 그러니 첫 줄을 다 보기 전에는 기록 파일의 이름을 정할 수 없다.
(첫 \.{\\input} 명령이 나오기 전에 첫 줄이 낸 오류 메시지는 기록 파일에 들어가지 않는다.)
@.texput@>

첫 줄은 명령줄에서 올 수도 있다는 점에서도 특별하다. 사용자가 `\.{tex paper}' 같은
명령줄을 쳐서 곧바로 \TeX\ 작업을 시작할 수 있으면 편하다. 그럴 때 \TeX은 입력의 첫 줄이
`\.{paper}'인 것처럼, 곧 명령줄에서 \TeX을 부른 부분을 뺀 나머지가 첫 줄인 것처럼 움직인다.

또 첫 줄은 \TeX이 포맷 파일을 읽어 들이기 전에 읽을 수도 있다는 점에서 특별하다. 그때는 아직
보통의 오류 메시지를 낼 수 없다. 오류를 처리하는 데 필요한 표들이 아직 채워지지 않았기
때문이다. 다음 코드에는 나중에 설명할 개념들이 나온다. 그런 상황에서 버퍼가 넘치면
터미널에 짧게 알리고 |panic(finalEnd)|로 조용히 끝낸다(\secref{outer-labels}).
@^system dependencies@>

@<입력 버퍼의 넘침을 알리고 그만둔다@>=
if formatIdent == 0 {
	writeLn(&termOut, "Buffer size exceeded!")
	panic(finalEnd)
@.Buffer size exceeded@>
} else {
	loc = first
	limit = last - 1
	overflow("buffer size", bufSize)
@:TeX capacity exceeded buffer size}{\quad buffer size@>
}

@ 시스템마다 \TeX을 시작하는 방법은 다르다. 그러나 어떤 관례를 따르든, 터미널을 초기화하는
루틴은 다음 조건을 채워야 한다.

\yskip\textindent{1)}파일 |termIn|을 터미널에서 입력받도록 연다. (파일 |termOut|은 이미
터미널로 출력하도록 열려 있을 것이다.)

\textindent{2)}사용자가 명령줄을 주었다면 그 줄을 터미널 입력의 첫 줄로 삼는다. 그렇지
않으면 `\.{**}'를 찍어 사용자에게 입력을 재촉하고, 그에 대한 대답으로 친 것을 입력의 첫 줄로
삼는다.

\textindent{3)}입력의 첫 줄은 명령줄에서 왔든 아니든 배열 |buffer|의 |first|부터 |last-1|까지에
들어 있어야 한다.

\textindent{4)}전역 변수 |loc|은 \TeX이 다음에 읽을 문자가 |buffer[loc]|에 있도록 정해야 한다.
이 문자는 공백이 아니어야 하고, |loc<last|여야 한다.

\yskip\noindent(공백이 아닌 줄이 들어올 때까지 사용자를 여러 번 재촉해야 할 수도 있다.
처음의 재촉 기호가 나중의 `\.*'와 달리 `\.{**}'인 것은 뜻이 조금 다르기 때문이다. `\.{**}'
바로 뒤에는 `\.{\\input}'을 치지 않아도 된다. 파일 이름만 치면 \TeX이 알아서 그 파일을
입력한다.)


@ \seclabel{init-terminal}다음 프로그램이 필요한 초기화를 한다. 명령줄의 인자는 |os.Args|에서 얻는다. 인자가
있으면 그것들을 공백으로 이어 붙여 첫 줄로 삼는다. 다만 첫 인자가 `\.{-ini}'이면 \.{INITEX}로
돌라는 뜻이므로(\secref{main}) 첫 줄에 넣지 않는다. 이를테면 `\.{tex -ini plain \\dump}'라고
치면 첫 줄은 `\.{plain \\dump}'가 된다. 첫 줄이 버퍼에 다 들어가지 않으면 명령줄이 없었던
것처럼 터미널에서 새로 받는다.
@^system dependencies@>

@<함수들@>=
func initTerminal() bool { // 터미널 입력을 시작한다
	tOpenIn()
	@<명령줄이 있으면 그것을 첫 줄로 삼고 |return true|@>
	for {
		wakeUpTerminal()
		write(&termOut, "**")
		updateTerminal()
@.**@>
		if !inputLn(&termIn, true) { // 이런 일은 일어나지 않아야 한다
			writeLn(&termOut)
			write(&termOut, "! End of file on the terminal... why?")
@.End of file on the terminal@>
			return false
		}
		loc = first
		for loc < last && buffer[loc] == ' ' {
			loc++
		}
		if loc < last {
			return true // 줄이 온통 공백이 아니면 돌아간다
		}
		writeLn(&termOut, "Please type the name of your input file.")
	}
}

@ 명령줄의 인자들을 공백으로 이어 붙여 버퍼의 |first|부터 넣는다. 그 줄에 공백 말고 무언가가
있으면, 터미널에서 첫 줄을 받았을 때와 똑같이 |loc|을 정하고 |true|를 돌려준다. 온통
공백이면 그냥 지나가므로, 앞 절의 루프가 터미널에서 첫 줄을 받는다.

@<명령줄이 있으면...@>=
args := os.Args[1:]
if len(args) > 0 && args[0] == "-ini" {
	args = args[1:]
}
if cmd := strings.Join(args, " "); len(cmd) > 0 && first+int32(len(cmd)) < bufSize {
	last = first
	for k := 0; k < len(cmd); k++ {
		buffer[last] = xord[cmd[k]]
		last++
	}
	for last > first && buffer[last-1] == ' ' { // |inputLn|처럼 줄 끝의 공백을 지운다
		last--
	}
	loc = first
	for loc < last && buffer[loc] == ' ' {
		loc++
	}
	if loc < last {
		return true
	}
}

@* 문자열 다루기.
제어 시퀀스의 이름이나 진단 메시지는 8비트 문자로 된, 길이가 제각각인 문자열이다. \TeX은
프로그래밍 언어가 주는 문자열 기능에 기대지 않고, 문자열을 모두 손수 만든 방법으로 다룬다.

정교한 동적 문자열 기능까지는 필요 없으므로, 필요한 연산은 간단한 자료 구조 하나로 모두
처리할 수 있다. 배열 |strPool|에는 모든 문자열의 (8비트) {\mc ASCII} 코드가 빈틈없이 이어져
들어 있고, 배열 |strStart|에는 문자열마다 그 시작 위치가 들어 있다. 문자열은 정수 번호로
가리킨다. 문자열 번호 |s|는 |strStart[s]<=j<strStart[s+1]|인 문자 |strPool[j]|들로 이루어진다.
다시 말해 문자열 |s|는 자기 시작 위치에서 다음 문자열의 시작 위치 바로 앞까지다. 정수 변수
|poolPtr|과 |strPtr|은 각각 |strPool|과 |strStart|에서 지금까지 쓴 항목의 수다. 그러므로
|strPool[poolPtr]|와 |strStart[strPtr]|가 다음 문자열을 받을 자리다.

문자열 번호 0부터 255까지는 {\mc ASCII} 문자 하나로 된 문자열에 남겨 둔다. 그래서 한
글자짜리 문자열의 번호는 그 문자의 {\mc ASCII} 코드와 같다. 이를테면 문자열 46번은 아마 문자
`\..' 하나일 것이다. 그런데 어떤 {\mc ASCII} 코드에는 표준적인 보이는 모양이 없다. \TeX은
때로 아무 {\mc ASCII} 문자나 찍을 수 있어야 하므로, 처음 256개의 문자열로 256가지 문자 저마다
무엇을 찍어야 하는지 정확히 정해 둔다. 이를테면 보이지 않는 문자 1번을 찍으라고 하면 문자열
1번에 든 세 글자 `\.{\^\^A}'가 찍힌다.

배열 |strPool|에 든 문자는 실제로 찍을 수 있는 {\mc ASCII} 코드여야 한다. 곧 그 지역의 문자
집합에 |xchr| 등가물이 있어야 한다. (이 제약은 미리 실어 둔 문자열에만 해당하고, 사용자가
실행 중에 만든 문자열에는 해당하지 않는다.)

배열 |strPool|의 원소는 바이트(|packedASCIICode|)이고 |asciiCode|는 |int32|이므로, 둘
사이를 오갈 때는 언제나 함수 |si|와 |so|를 거친다. 바이트를 부호 있는 수로만 다룰 수 있는
시스템에서도 이 두 함수만 고치면 되게 하려는 것이다. 덤으로 \GO/의 형 검사가 두 함수를
빠뜨리지 않고 썼는지 하나하나 확인해 준다.
@^system dependencies@>

@<전역 형@>=
type @!poolPointer = int32 // |strPool|을 가리키는 변수를 위해; |0 .. poolSize|
type @!strNumber = int32 // |strStart|를 가리키는 변수를 위해; |0 .. maxStrings|
type @!packedASCIICode = uint8 // 배열 |strPool|의 원소

func si(c asciiCode) packedASCIICode { return packedASCIICode(c) } // |asciiCode|를 |packedASCIICode|로 바꾼다
func so(c packedASCIICode) asciiCode { return asciiCode(c) } // |packedASCIICode|를 |asciiCode|로 바꾼다

@ @<전역 변수@>=
var @!strPool [poolSize + 1]packedASCIICode // 문자들
var @!strStart [maxStrings + 1]poolPointer // 시작 포인터들
var @!poolPtr poolPointer // |strPool|에서 쓰이지 않는 첫 위치
var @!strPtr strNumber // 지금 만들고 있는 문자열의 번호
var @!initPoolPtr poolPointer // |poolPtr|의 처음 값
var @!initStrPtr strNumber // |strPtr|의 처음 값

@ 기본적인 문자열 연산 가운데 몇몇은 아주 자주 쓰므로 아주 짧은 함수로 만든다. \GO/
컴파일러는 이런 작은 함수를 부르는 자리에 펼쳐 넣으므로 프로시저를 부르는 비용이 들지 않는다.
이를테면 다음은 문자열의 길이를 구하는 간단한 함수다. 앞 절의 약속대로 다음 문자열의 시작
위치에서 제 시작 위치를 빼면 된다.

@<정의@>=
func length(s strNumber) int32 { return strStart[s+1] - strStart[s] } // 문자열 |s|의 문자 수

@ 지금 만들고 있는 문자열의 길이는 |curLength|라고 부른다. 이 문자열은 아직 |strStart|에
끝이 적히지 않았으므로, 끝 대신 |poolPtr|을 쓴다.

@<정의@>=
func curLength() int32 { return poolPtr - strStart[strPtr] }

@ 문자열은 문자 코드를 |strPool|에 하나씩 덧붙여서 만든다. 여기서 정의하는 함수
|appendChar|는 |poolPtr|이 너무 커졌는지 검사하지 않는다. 그 검사는 |appendChar|를 부르기
전에 미리 해 두어야 한다. 마지막에 덧붙인 문자를 지우는 함수 |flushChar|도 있다.

배열 |strPool|에 문자를 |l|개 더 덧붙일 자리가 있는지 알아보려면 |strRoom(l)|이라고 쓴다.
자리가 없으면 이 함수는 미안하다는 오류 메시지를 내고 \TeX을 그만두게 한다. 그러니
문자열을 만드는 쪽에서는 먼저 |strRoom|으로 넉넉한 자리를 확인하고, 그다음에는 마음 놓고
|appendChar|를 되풀이하면 된다.

@<정의@>=
func appendChar(c asciiCode) { // |asciiCode| |c|를 |strPool|의 끝에 넣는다
	strPool[poolPtr] = si(c)
	poolPtr++
}

func flushChar() { poolPtr-- } // 풀의 마지막 문자를 잊는다

func strRoom(l int32) { // 풀이 넘치지 않았는지 확인한다
	if poolPtr+l > poolSize {
		overflow("pool size", poolSize-initPoolPtr)
@:TeX capacity exceeded pool size}{\quad pool size@>
	}
}

@ 문자들을 |strPool|에 덧붙이고 나서 함수 |makeString|을 부르면, 그 문자들이 비로소 정식
문자열이 된다. 이 함수는 새 문자열의 번호를 돌려준다. 하는 일은 |strStart|에 새 문자열의
끝(곧 다음 문자열의 시작)을 적는 것이 전부다.

@<함수들@>=
func makeString() strNumber { // 현재 문자열이 풀에 들어간다
	if strPtr == maxStrings {
		overflow("number of strings", maxStrings-initStrPtr)
@:TeX capacity exceeded number of strings}{\quad number of strings@>
	}
	strPtr++
	strStart[strPtr] = poolPtr
	return strPtr - 1
}

@ 가장 최근에 만든 문자열을 없애려면 |flushString|이라고 한다. 문자열 번호를 하나 물리고,
|poolPtr|도 그 문자열이 시작하던 곳으로 되돌린다. 그러면 그 문자열이 차지하던 자리가 다음
문자열을 위해 비워진다.

@<정의@>=
func flushString() {
	strPtr--
	poolPtr = strStart[strPtr]
}

@ 다음 서브루틴은 문자열 |s|를, |buffer|의 위치 |k|에서 시작하는 같은 길이의 문자열과
비교한다. 두 문자열이 같을 때, 그리고 오직 그때에만 결과는 |true|다. 해시 표에서 제어
시퀀스의 이름을 찾을 때 이 함수를 쓰는데, 실험해 보니 |strEqBuf|는 대개 80퍼센트쯤 |true|를
돌려주는 방식으로 쓰였다. 해시 값까지 같은 이름을 견주는 것이므로 맞을 때가 많은 것이다.

@<함수들@>=
func strEqBuf(s strNumber, k int32) bool { // 문자열이 같은지 검사한다
	var j poolPointer // 차례로 도는 첨자
	var result bool // 비교의 결과
	j = strStart[s]
	for j < strStart[s+1] {
		if so(strPool[j]) != buffer[k] {
			result = false
			goto notFound
		}
		j++
		k++
	}
	result = true
notFound:
	return result
}

@ 다음도 비슷한 루틴인데, 문자열 풀 안에 든 두 문자열을 비교한다. 이번에는 두 문자열의
길이가 같다고 가정하지 않으므로, 먼저 길이부터 견주어 본다.

@<함수들@>=
func strEqStr(s, t strNumber) bool { // 문자열이 같은지 검사한다
	var j, k poolPointer // 차례로 도는 첨자들
	var result bool // 비교의 결과
	result = false
	if length(s) != length(t) {
		goto notFound
	}
	j = strStart[s]
	k = strStart[t]
	for j < strStart[s+1] {
		if strPool[j] != strPool[k] {
			goto notFound
		}
		j++
		k++
	}
	result = true
notFound:
	return result
}

@ 변수 |strPool|, |strStart|, |poolPtr|, |strPtr|의 처음 값은 \.{INITEX} 프로그램이 계산한다.
그 일부는 프로그램 안에 적어 둔 문자열 상수의 목록을 바탕으로 한다(\secref{pool-literals}).
이 함수는 \.{INITEX}에서만 쓴다. 실무용 \TeX은 이 값들을 포맷 파일에서 읽어 온다.
@.INITEX@>
@^string pool@>

@<함수들@>=
func getStringsStarted() bool { // 문자열 풀을 초기화한다.
	@t\qquad@>// 무언가 잘못되면 |false|를 돌려준다
	var k, l int32 // 작은 첨자나 계수기
	poolPtr = 0
	strPtr = 0
	strStart[0] = 0
	@<처음 256개의 문자열을 만든다@>
	@<나머지 문자열을 |poolLiterals|에서 넣고 |true|나 |false|를 돌려준다@>
}

@ 처음 256개의 문자열을 만든다. 찍을 수 있는 문자는 그 문자 하나로 된 문자열이 되고, 찍을
수 없는 문자는 `\.{\^\^}'로 시작하는 꼴이 된다. 코드가 \.{'100}보다 작으면 \.{'100}을
더한 글자를(이를테면 1번은 \.{\^\^A}), \.{'100}부터 \.{'177}까지는 \.{'100}을 뺀 글자를(이를테면
\.{'177}은 \.{\^\^?}), 그보다 크면 소문자 16진 숫자 둘을(이를테면 \.{\^\^e9}) 붙인다. 소문자
16진 숫자 하나를 덧붙이는 작은 함수 |appLcHex|는 이 절에서만 쓰므로 코드 안의 함수 리터럴로
둔다.

@<처음 256개...@>=
appLcHex := func(x int32) {
	l = x
	if l < 10 {
		appendChar(l + '0')
	} else {
		appendChar(l - 10 + 'a')
	}
}
for k = 0; k <= 255; k++ {
	if @<문자 |k|를 찍을 수 없다@> {
		appendChar('^')
		appendChar('^')
		if k < 0o100 {
			appendChar(k + 0o100)
		} else if k < 0o200 {
			appendChar(k - 0o100)
		} else {
			appLcHex(k / 16)
			appLcHex(k % 16)
		}
	} else {
		appendChar(k)
	}
	makeString() // 만든 문자열의 번호는 버린다
}

@ 처음 128개의 문자열에는 표준 {\mc ASCII} 문자 95개가 들어간다. 나머지 33개의 문자는 여기서
시스템에 맞게 고치지 않는 한 `\.{\^\^A}' 같은 세 글자짜리 꼴로 찍힌다. 문자 집합이 더 넓은
설치처, 이를테면 |xchr[@'32]=@t\.{\char'47\^\^Z\char'47}@>|인 곳에서는 문자열 \.{'32}가 세 문자
\.{'136}, \.{'136}, \.{'132}(\.{\^\^Z})가 아니라 문자 하나 \.{'32}이기를 바랄 것이다. 그래도
그런 사람들조차 문자열 \.{'15}는 \.{\^\^M}으로 나타내고 싶을 것이다. \.{'15}는
|carriageReturn|이기 때문이다. 요컨대 탭, 줄 먹임, 캐리지 리턴, 벨 소리처럼 텍스트 파일에서
엉뚱하게 다루어지는 문자들은 눈에 보이는 문자열로 바꾸어 찍자는 것이다.

코드 128--255의 찍을 수 없는 문자들도 같은 방법으로 \.{\^\^80}--\.{\^\^ff}로 나타낸다.

여기서 정의하는 불 식은, \TeX\ 내부 코드 번호~|k|가 그 지역의 문자 집합에서 말썽 없이 찍히는
보이는 기호가 아니면 |true|여야 한다. 이를테면 {\sl The \TeX book}이 권하는 확장 문자
집합이라면 알맞은 식은 `$k\in\{0,\.{'10}\ldots\.{'12},\.{'14},\.{'15},\.{'33},\.{'177}\ldots\.{'377}\}$'일
것이다. 지켜야 할 조건도 있다. 문자 |k|를 찍을 수 없고 |k<@'200|이면, 문자 |k+@'100|이나
|k-@'100|은 찍을 수 있어야 한다. 또 {\mc ASCII} 코드 \.{'41}--\.{'46}, \.{'60}--\.{'71},
\.{'136}, \.{'141}--\.{'146}, \.{'160}--\.{'171}은 찍을 수 있어야 한다. `\.{\^\^}' 꼴을
만드는 데 이 문자들이 쓰이기 때문이다. 그래서 찍을 수 있는 문자가 적어도 80개는 있어야 한다.
@^TeXbook@>
@^character set dependencies@>
@^system dependencies@>

@<문자 |k|를 찍을 수 없다@>=
(k < ' ' || k > '~')

@ \seclabel{pool-literals}\TeX\ 자신의 메시지들은 \GO/의 문자열 상수로 프로그램 안에 들어 있고, |printStr|
같은 프로시저가 그것을 바로 찍는다(\secref{print}). 그런데 문자열 상수 가운데 몇몇은 찍히기만
하는 것이 아니라 문자열 번호로 변수에 들어가거나 다른 문자열 번호와 비교된다.
`|curExt=str(".tex")|'나 `|if curExt==str("")|' 같은 것이 그렇다. 이런 문자열은 풀 안에
있어야 하므로 목록 |poolLiterals|에 모아 두고, \.{INITEX}가 처음 256개의 문자열 바로 다음에
@.INITEX@>
차례로 풀에 넣는다. 그러면 목록의 $i$번째 문자열(0번째부터 센다)의 번호는 언제나 $256+i$가
된다. 이를테면 \.{".tex"}는 257번이다. 포맷 파일에는 풀 전체가 들어가므로, 실무용 판에서도
번호는 똑같다. 문자열 상수의 번호는 함수 |str|이 알려 준다.

@<전역 변수@>=
var @!poolLiterals = [...]string{ // 번호로 쓰이는 문자열 상수들
	"", ".tex", ".log", ".dvi", ".fmt", ".tfm", "texput", "notexpanded:",
	"endgroup", "relax", "fi", "TeXinputs:", "TeXfonts:", "nullfont",
	"0234000122*4000133**3**344*0400400*000000234000111*1111112341011", "cr",
	"endtemplate", "right", "inaccessible", "FONT", " (INITEX)", "endwrite",
}

@ 문자열 상수들을 차례로 풀에 넣다가 자리가 모자라면 |getStringsStarted|는 |false|를
돌려준다.

@<나머지 문자열을...@>=
for _, lit := range poolLiterals {
	@<문자열 하나를 넣되, 자리가 빠듯하면 |false|를 돌려준다@>
}
return true

@ 문자열 상수 |lit|의 길이를 |l|이라고 하자. 상수를 다 넣은 뒤에도 문자열 공간에는 사용자의
제어 시퀀스와 글꼴 이름을 담을 자리가 적어도 |stringVacancies|만큼 남아 있어야 한다. 그만큼
남지 않으면 |poolSize|를 늘려야 한다고 알린다.

@<문자열 하나를 넣되...@>=
l = int32(len(lit)) // 길이를 계산한다
if poolPtr+l+stringVacancies > poolSize {
	wakeUpTerminal()
	writeLn(&termOut, "! You have to increase POOLSIZE.")
@.You have to increase POOLSIZE@>
	return false
}
for k = 0; k < l; k++ {
	appendChar(xord[lit[k]])
}
makeString()

@ \seclabel{pool-check}문자열 상수의 목록이 바뀌면 문자열의 번호도 바뀐다. 그러니 옛 목록을 가진 \TeX이
만든 포맷 파일을 새 \TeX이 읽어 들여서는 안 된다. 번호가 어긋나서 엉뚱한 문자열을 가리키게
되기 때문이다. 이를 막으려고 포맷 파일의 첫 낱말에 목록의 검사합 |poolCheckSum|을 적어
두고(\secref{dump-constants}), 포맷 파일을 읽을 때 그 값을 맞추어 본다.
@^check sum@>

@ 함수 |str|은 \GO/ 문자열 상수 |s|에 해당하는 풀 문자열의 번호를 돌려준다. 한 글자짜리
문자열은 처음 256개 가운데 하나이므로 그 문자의 코드를 그대로 돌려준다. 그 밖의 문자열은
목록 |poolLiterals|에 있어야 하므로 목록을 처음부터 찾는다. 목록에 없는 문자열을 물었다면
프로그램을 잘못 짠 것이므로 |panic|을 일으킨다.

@<함수들@>=
func str(s string) strNumber {
	if len(s) == 1 {
		return strNumber(s[0])
	}
	for i, lit := range poolLiterals {
		if lit == s {
			return 256 + strNumber(i)
		}
	}
	panic("str: " + s + " is not in poolLiterals")
}

@* 화면과 기록 파일에 찍기.
사용자의 터미널과 기록 파일로 가는 메시지는 `|printStr|'와 그 친척 프로시저들이 만든다.
이 프로시저들은 전역 변수 |selector|의 값을 보고 출력을 어디로 보낼지 정한다. 값은 다음
가운데 하나다.

\yskip
\hang |termAndLog|는 보통의 설정으로, 터미널과 기록 파일 양쪽에 찍는다.

\hang |logOnly|는 기록 파일에만 찍는다.

\hang |termOnly|는 터미널에만 찍는다.

\hang |noPrint|는 아무 데도 찍지 않는다. 기록 파일을 열기 전의 드문 경우에만 쓴다.

\hang |pseudo|는 출력을 순환 버퍼에 넣는다. 이 버퍼는 루틴 |showContext|가 쓴다. 이런 별난
방식을 쓰는 까닭은 그 루틴에 이르렀을 때 이야기하겠다.

\hang |newString|은 출력을 문자열 풀의 현재 문자열에 덧붙인다. 명령 \.{\\string}이나
\.{\\jobname}처럼 찍을 것을 문자열로 받아 두어야 할 때 쓴다.

\hang 0부터 15까지는 \.{\\write}의 출력에 쓰는 열여섯 파일 가운데 하나에 찍는다.

\yskip
\noindent 기호 이름 `|termAndLog|' 따위의 수 코드는 |noPrint+1=termOnly|,
|noPrint+2=logOnly|, |termOnly+2=logOnly+1=termAndLog|라는 편리한 관계가 성립하도록 골랐다.
그래서 이를테면 |selector|가 홀수인지만 보면 터미널에 찍는지 알 수 있고, 2를 빼면 기록 파일
쪽을 떼어 낼 수 있다.

전역 변수 |tally|, |termOffset|, |fileOffset|은 가장 최근에 0으로 되돌린 뒤로 찍은 문자의
수를 센다. 변수 |tally|는 (아주 길 수도 있는) 찍은 구간 전체의 길이를 잰다. 한편
|termOffset|과 |fileOffset|은 각각 터미널과 기록 파일에 지금 찍고 있는 줄에 문자가 몇 개
나왔는지 센다. 줄이 너무 길어지기 전에 끊으려면 이 값이 있어야 한다.

@<전역 변수@>=
const (
	@!noPrint = 16 // 자료가 사라지게 하는 |selector| 설정
	@!termOnly = 17 // 터미널에만 찍는다
	@!logOnly = 18 // 기록 파일에만 찍는다
	@!termAndLog = 19 // 보통의 |selector| 설정
	@!pseudo = 20 // |showContext|를 위한 특별한 |selector| 설정
	@!newString = 21 // 찍는 것을 문자열 풀로 돌린다
	@!maxSelector = 21 // 가장 큰 |selector| 설정
)

var @!logFile alphaFile // \TeX\ 작업의 기록
var @!selector int32 // 메시지를 찍을 곳; |0 .. maxSelector|
var @!dig [23]int32 // 출력하고 있는 수의 숫자들; 저마다 |0..15|
var @!tally int32 // 최근에 찍은 문자의 수
var @!termOffset int32 // 현재 터미널 줄의 문자 수; |0 .. maxPrintLine|
var @!fileOffset int32 // 현재 파일 줄의 문자 수; |0 .. maxPrintLine|
var @!trickBuf [errorLine + 1]asciiCode // 흉내 찍기를 위한 순환 버퍼
var @!trickCount int32 // 흉내 찍기의 문턱값; 나중에 설명한다
var @!firstCount int32 // 흉내 찍기를 위한 또 하나의 변수

@ @<출력 루틴들을 초기화한다@>=
selector = termOnly
tally = 0
termOffset = 0
fileOffset = 0

@ 터미널과 기록 파일에 쓰는 일을 편하게 하려고 짧은 이름의 함수들을 여기서 정의한다.
터미널 출력에 특별한 관례가 필요한 시스템이라면 이 절의 |wterm|, |wtermLn|, |wtermCr|만
고쳐서 그 관례를 따르면 된다.
@^system dependencies@>

@<정의@>=
func wterm(xs ...any)    { write(&termOut, xs...) }
func wtermLn(xs ...any) { writeLn(&termOut, xs...) }
func wtermCr()          { writeLn(&termOut) }
func wlog(xs ...any)     { write(&logFile, xs...) }
func wlogLn(xs ...any)  { writeLn(&logFile, xs...) }
func wlogCr()           { writeLn(&logFile) }

@ 출력하는 텍스트의 한 줄을 끝내려면 |printLn|을 부른다. 줄을 끝내면 그 출력 장소의 줄 위치
계수기도 0으로 돌아간다.

@<기본 인쇄...@>=
func printLn() { // 줄의 끝을 찍는다
	switch selector {
	case termAndLog:
		wtermCr()
		wlogCr()
		termOffset = 0
		fileOffset = 0
	case logOnly:
		wlogCr()
		fileOffset = 0
	case termOnly:
		wtermCr()
		termOffset = 0
	case noPrint, pseudo, newString:
		// 아무것도 하지 않는다
	default:
		writeLn(&writeFile[selector])
	}
} // |tally|는 영향을 받지 않는다

@ \seclabel{print-char}프로시저 |printChar|는 문자 하나를 원하는 곳으로 보낸다. 이때 배열 |xchr|로 그 문자를
|inputLn|과 짝이 맞는 외부 문자로 바꾼다. \TeX이 찍는 것은 모두 결국 |printLn|이나
|printChar|를 거친다. 그리고 찍으려는 문자가 사용자가 정한 줄바꿈 문자(\.{\\newlinechar})이면,
그 문자를 찍는 대신 줄을 바꾼다.

아래 코드의 `@<문자 |s|가 현재의 줄바꿈 문자다@>'처럼 불 식 노릇을 하는 이름 있는 절은
|if| 문의 조건 자리에 곧바로 쓸 수 없다. \.{gtangle}은 이름 있는 절을 펼칠 때 그 앞뒤에서 줄을
바꾸는데, \GO/는 줄 끝의 `\.)' 뒤에 쌍반점을 저절로 넣어 버리기 때문이다. 그래서 이
프로그램에서는 그런 절의 값을 먼저 지역 변수(여기서는 |isNl|)에 받아 두고 그 변수를 검사한다.

@<기본 인쇄...@>=
func printChar(s asciiCode) { // 문자 하나를 찍는다
	if @<문자 |s|가 현재의 줄바꿈 문자다@> {
		if selector < pseudo {
			printLn()
			return
		}
	}
	@<|selector|에 따라 문자 |s|를 보낸다@>
	tally++
}

@ 앞 절의 |switch| 문이다. 출력 장소마다 문자를 쓰고 줄 위치를 하나 늘리며, 줄이
|maxPrintLine|만큼 차면 줄을 바꾼다. 흉내 찍기(|pseudo|)에서는 순환 버퍼에 넣기만 하고,
문자열을 만드는 중(|newString|)이면 풀에 덧붙인다.

@<|selector|에 따라...@>=
switch selector {
case termAndLog:
	wterm(xchr[s])
	wlog(xchr[s])
	termOffset++
	fileOffset++
	if termOffset == maxPrintLine {
		wtermCr()
		termOffset = 0
	}
	if fileOffset == maxPrintLine {
		wlogCr()
		fileOffset = 0
	}
case logOnly:
	wlog(xchr[s])
	fileOffset++
	if fileOffset == maxPrintLine {
		printLn()
	}
case termOnly:
	wterm(xchr[s])
	termOffset++
	if termOffset == maxPrintLine {
		printLn()
	}
case noPrint:
	// 아무것도 하지 않는다
case pseudo:
	if tally < trickCount {
		trickBuf[tally%errorLine] = s
	}
case newString:
	if poolPtr < poolSize {
		appendChar(s)
	} // 문자열 공간이 가득 차면 문자들을 버린다
default:
	write(&writeFile[selector], xchr[s])
}

@ \seclabel{print}문자열 전체는 |printStr|를 불러서 찍는다. 표준 {\mc ASCII} 문자 하나 \.c를 찍을 때
|printStr("c")|를 불러도 된다는 데 눈여겨보자. 앞에서 말했듯이 |"c"=99|가 바로 그 한 글자짜리
문자열의 번호이기 때문이다. 그러나 |printChar("c")|가 더 빠르므로, \TeX은 그래도 안전하다는 것을
알 때에는 곧바로 |printChar|를 부른다. (지금의 구현은 보이는 {\mc ASCII} 문자를 찍는 것은
언제나 안전하다고 가정한다.)
@^system dependencies@>

함수 |printStr|의 인자 |x|는 문자열 번호(정수)일 수도 있고 \GO/의 문자열 상수일 수도 있으므로
(\secref{pool-literals}) 형이 |any|다. 길이가 1이 아닌 \GO/ 문자열이 오면, 번호가 255보다 큰
풀 문자열을 찍을 때처럼 그 문자들을 하나씩 |printChar|로 찍는다. 길이가 1인 \GO/ 문자열은
그 문자의 코드, 곧 한 글자짜리 문자열의 번호로 바꾸어 다룬다. 그래서 이를테면
|printStr(".")|는 |printStr(46)|과 똑같고, \.{\\newlinechar}가 마침표이면 줄을 바꾼다.
인자를 문자열 번호로 바꾸는 일은 함수 |strnum|이 맡는다.

@<기본 인쇄...@>=
func printStr(x any) { // 문자열 |s|를 찍는다
	var j poolPointer // 현재 문자 코드의 위치
	var nl int32 // 되돌려 놓을 줄바꿈 문자
	if t, ok := x.(string); ok && len(t) != 1 {
		for k := 0; k < len(t); k++ {
			printChar(xord[t[k]])
		}
		return
	}
	s := strnum(x)
	if s >= strPtr {
		printStr("???") // 이런 일은 일어날 수 없다
		return
@.???@>
	} else if s < 256 {
		if s < 0 {
			printStr("???") // 일어날 수 없다
			return
		}
		@<한 문자짜리 문자열 |s|를 찍고 |return|한다@>
	}
	j = strStart[s]
	for j < strStart[s+1] {
		printChar(so(strPool[j]))
		j++
	}
}

@ 앞 절에서 번호가 256보다 작은 문자열을 찍는 부분이다. 내부 문자열을 만들고 있을 때는 문자를
그대로 넣는다. 그렇지 않을 때, 현재의 줄바꿈 문자는 줄바꿈으로 찍는다. 다른 문자는 그
문자열에 든 글자들(이를테면 \.{\^\^M})을 찍는데, 그동안에는 줄바꿈 문자를 잠시 꺼 둔다. 그러지
않으면 \.{\^\^M}의 `\.{M}'이 우연히 줄바꿈 문자일 때 엉뚱하게 줄이 바뀔 것이다.

@<한 문자짜리 문자열 |s|를...@>=
if selector > pseudo {
	printChar(s)
	return // 내부 문자열은 펼치지 않는다
}
if @<문자 |s|가 현재의 줄바꿈 문자다@> {
	if selector < pseudo {
		printLn()
		return
	}
}
nl = newLineChar()
setNewLineChar(-1) // 줄바꿈 문자를 잠시 끈다
j = strStart[s]
for j < strStart[s+1] {
	printChar(so(strPool[j]))
	j++
}
setNewLineChar(nl)
return

@ 함수 |strnum|은 |printStr|와 그 친척들이 받은 인자를 문자열 번호로 바꾼다. 인자는 정수이거나
길이가 1인 \GO/ 문자열이어야 한다. \GO/의 작은따옴표 상수(|rune|)는 |int32|의 별칭이므로 그대로
문자 코드가 된다. 그 밖의 형이 오면 프로그램을 잘못 짠 것이므로 |panic|을 일으킨다.

@<기본 인쇄...@>=
func strnum(x any) strNumber {
	switch x := x.(type) {
	case int32:
		return x
	case int:
		return strNumber(x)
	case string:
		return str(x)
	}
	panic(fmt.Sprintf("strnum: %T", x))
}

@ 제어 시퀀스의 이름, 파일 이름, \.{\\string}으로 만든 문자열에는 |printChar|로 곧장 찍으면
안 되는 |asciiCode| 값이 들어 있을 수 있다. 그래서 그런 것을 찍을 때는 |slowPrint|를 쓴다. 이
함수는 문자 하나하나를 |printStr|에 넘기므로, 찍을 수 없는 문자는 \.{\^\^} 꼴로 바뀌어 나온다.

\GO/ 문자열 상수가 인자로 와도 마찬가지로 그 문자들을 하나씩 |printStr|로 찍는다.

@<기본 인쇄...@>=
func slowPrint(x any) { // 문자열 |s|를 찍는다
	var j poolPointer // 현재 문자 코드의 위치
	if t, ok := x.(string); ok && len(t) != 1 {
		for k := 0; k < len(t); k++ {
			printStr(xord[t[k]])
		}
		return
	}
	s := strnum(x)
	if s >= strPtr || s < 256 {
		printStr(s)
	} else {
		j = strStart[s]
		for j < strStart[s+1] {
			printStr(so(strPool[j]))
			j++
		}
	}
}

@ 다음은 \TeX이 맨 처음 찍는 것, 곧 판 번호와 미리 실은 포맷을 밝히는 머리줄이다. 여기서는
|wterm|으로 곧장 쓰므로 변수 |termOffset|이 잠시 틀린 값을 갖게 된다. 그러나 이 부분은 어차피
시스템마다 다르다고 보므로 그 어긋남이 큰 문제가 되지는 않는다.
@^system dependencies@>

@<출력 루틴들을...@>=
wterm(banner)
if formatIdent == 0 {
	wtermLn(" (no format preloaded)")
} else {
	slowPrint(formatIdent)
	printLn()
}
updateTerminal()

@ 프로시저 |printNl|은 |printStr|와 같지만, 문자열이 반드시 새 줄의 처음에 나오도록 한다. 지금
줄에 이미 무언가 찍혀 있으면 먼저 줄을 바꾸고, 줄의 처음이면 그냥 찍는다. 오류 메시지의
`\.{!}'처럼 줄 첫머리에 와야 하는 것을 찍을 때 쓴다.

@<기본 인쇄...@>=
func printNl(s any) { // 문자열 |s|를 줄의 처음에 찍는다
	if (termOffset > 0 && odd(selector)) ||
		(fileOffset > 0 && selector >= logOnly) {
		printLn()
	}
	printStr(s)
}

@ 프로시저 |printEsc|는 사용자의 탈출 문자(대개 역빗금)를 앞에 붙여 문자열을 찍는다. 탈출
문자는 \.{\\escapechar}로 바꿀 수 있으므로, 제어 시퀀스의 이름을 찍을 때 역빗금을 그냥 찍지
않고 이 프로시저를 쓴다. 매개변수 \.{\\escapechar}가 음수이거나 255보다 크면 탈출 문자를 찍지 않는다.

@<기본 인쇄...@>=
func printEsc(s any) { // 탈출 문자를 찍고 나서 |s|를 찍는다
	@<변수 |c|를 현재의 탈출 문자로 놓는다@>
	if c >= 0 {
		if c < 256 {
			printStr(c)
		}
	}
	slowPrint(s)
}

@ 범위 |0..15|의 숫자들로 된 배열은 |printTheDigs|로 찍는다. 배열에는 낮은 자리부터 들어
있으므로 뒤에서부터 찍고, 10 이상인 숫자는 \.A부터 \.F까지의 글자로 찍는다.

@<기본 인쇄...@>=
func printTheDigs(k eightBits) { // |dig[k-1]|$\,\ldots\,$|dig[0]|을 찍는다
	for k > 0 {
		k--
		if dig[k] < 10 {
			printChar('0' + dig[k])
		} else {
			printChar('A' - 10 + dig[k])
		}
	}
}

@ 정수 |n|의 십진 표현을 찍는 다음 프로시저는 |n=0|일 때나 |(-n)|이 넘칠 때에도 제대로
돌도록 조심해서 썼다. 이 프로시저는 음수 인자에 나머지 연산이나 나눗셈을 쓰지 않는다. 그런
연산의 결과는 언어나 컴퓨터마다 다를 수 있기 때문이다. 그래서 절댓값이 큰 음수는 부호를 바로
뒤집지 않고, |-1-n|을 써서 맨 아래 자리를 먼저 떼어 낸 다음 나머지를 양수로 다룬다.

@<기본 인쇄...@>=
func printInt(n int32) { // 정수를 십진 꼴로 찍는다
	var k int32 // 현재 숫자의 첨자; $\vert n\vert<10^{23}$이라고 가정한다
	var m int32 // 위험할 수도 있는 경우에 |n|의 부호를 바꾸는 데 쓴다
	k = 0
	if n < 0 {
		printChar('-')
		if n > -100000000 {
			n = -n
		} else {
			m = -1 - n
			n = m / 10
			m = (m % 10) + 1
			k = 1
			if m < 10 {
				dig[0] = m
			} else {
				dig[0] = 0
				n++
			}
		}
	}
	for {
		dig[k] = n % 10
		n /= 10
		k++
		if n == 0 {
			break
		}
	}
	printTheDigs(k)
}

@ 다음은 숫자 두 개를 찍는 하찮은 프로시저다. 대개 |0<=n<=99| 범위의 인자로 부른다. 시각이나
날짜를 `\.{09:05}'처럼 두 자리로 맞추어 찍을 때 쓴다.

@<함수들@>=
func printTwo(n int32) { // 가장 낮은 두 자리 숫자를 찍는다
	n = abs(n) % 100
	printChar('0' + (n / 10))
	printChar('0' + (n % 10))
}

@ 음이 아닌 정수를 십육진으로 찍는 일은 |printHex|가 한다. \TeX의 관례대로 앞에 큰따옴표를
붙여 \.{"1F}처럼 찍는다.

@<함수들@>=
func printHex(n int32) { // 양의 정수를 십육진 꼴로 찍는다
	var k int32 // 현재 숫자의 첨자; $0\le n<16^{22}$이라고 가정한다
	k = 0
	printChar('"')
	for {
		dig[k] = n % 16
		n /= 16
		k++
		if n == 0 {
			break
		}
	}
	printTheDigs(k)
}

@ 옛 판의 \TeX에는 |printASCII|라는 프로시저가 따로 있어야 했는데, 지금은 그 기능이 |printStr|에
들어 있다. 앞날의 소프트웨어 고고학자들에게 도움이 될지도 모르므로 옛 이름을 여기 남겨 둔다.

@<정의@>=
var printASCII = printStr

@ 로마 숫자는 루틴 |printRomanInt|가 만든다. 수수께끼를 좋아하는 독자라면 이 교묘한 코드가
어떻게 도는지 스스로 알아내며 즐거워할 것이다. 그러니 설명은 하지 않겠다. 다만 1990이
\.{mxm}이 아니라 \.{mcmxc}가 된다는 것은 눈여겨보아 두자.


@<함수들@>=
func printRomanInt(n int32) {
	const roman = "m2d5c2l5x2v5i"
	var j, k poolPointer // |roman|에 대한 수수께끼 같은 첨자들
	var u, v int32 // 수수께끼 같은 수들
	j = 0
	v = 1000
	for {
		for n >= v {
			printChar(asciiCode(roman[j]))
			n -= v
		}
		if n <= 0 {
			return // 양이 아닌 입력은 아무것도 출력하지 않는다
		}
		k = j + 2
		u = v / (asciiCode(roman[k-1]) - '0')
		if roman[k-1] == '2' {
			k += 2
			u /= (asciiCode(roman[k-1]) - '0')
		}
		if n+u >= v {
			printChar(asciiCode(roman[k]))
			n += u
		} else {
			j += 2
			v /= (asciiCode(roman[j-1]) - '0')
		}
	}
}

@ 서브루틴 |printStr|는 아직 만드는 중인 문자열은 찍지 못한다. 그런 문자열은 |strStart|에 끝이
아직 적히지 않았기 때문이다. 다음 프로시저가 그것을 찍는다.

@<함수들@>=
func printCurrentString() { // 아직 만들지 않은 문자열을 찍는다
	j := strStart[strPtr] // 현재 문자 코드를 가리킨다
	for j < poolPtr {
		printChar(so(strPool[j]))
		j++
	}
}

@ 다음은 사용자에게 입력 한 줄을 치라고 하는 프로시저다. 이 프로시저는 |selector|가 |termOnly|나
|termAndLog|라고 가정한다. 입력은 배열 |buffer|의 |first|부터 |last-1|까지에 들어가고, 알맞으면
기록 파일에도 메아리친다. 메아리칠 때는 |selector|를 하나 줄여 |noPrint|나 |logOnly|로 바꾸므로,
사용자가 친 줄이 터미널에는 두 번 나오지 않고 기록 파일에만 한 번 적힌다.

이 프로시저는 |interaction<scrollMode|일 때는 결코 부르지 않는다. 사용자와 대화하지 않는
모드에서 입력을 기다리면 안 되기 때문이다.

@<함수들@>=
func promptInput(s any) { // 문자열을 찍고 입력 한 줄을 얻는다
	wakeUpTerminal()
	printStr(s)
	termInput()
}

func termInput() { // 터미널에서 한 줄을 얻는다
	var k int32 // |buffer|의 첨자
	updateTerminal() // 이제 사용자는 틀림없이 재촉 기호를 본다
	if !inputLn(&termIn, true) {
		fatalError("End of file on the terminal!")
@.End of file on the terminal@>
	}
	termOffset = 0 // 사용자의 줄은 \<\rm return>으로 끝났다
	selector-- // 입력을 메아리칠 준비를 한다
	if last != first {
		for k = first; k <= last-1; k++ {
			printStr(buffer[k])
		}
	}
	printLn()
	selector++ // 앞의 상태로 되돌린다
}

@* 오류 알리기.
무언가 이상한 것을 찾아내면 \TeX은 대개 이런 일을 한다.
$$\vbox{\halign{#\hfil\cr
|printErr("Something anomalous has been detected")|\cr
|help3("This is the first line of my offer to help.",|\cr
|"This is the second line. I'm trying to",|\cr
|"explain the best way for you to proceed.")|\cr
|reportError()|\cr}}$$
도움말이 두 줄이면 |help2|를 쓰는 식이다. 이런 비공식 도움말은 공식 오류 메시지가 미처
다 하지 못한 말을 쉬운 낱말로 채워 주어야 한다. (미국 바깥이라면 도움말을 그 지역의 말로
옮기는 것도 좋겠다. 지금의 구현에서 도움말 한 줄은 많아야 60글자이므로 |maxPrintLine|을
넘지 않는다.)

프로시저 |printErr|는 공식 메시지 앞에 `\.!'를 붙이고, 혹시 멈추어 사용자의 대답을 기다리게
될 때를 대비해 터미널을 깨워 둔다. 프로시저 |reportError|는 공식 메시지 뒤에 `\..'를 붙이고,
입력의 어디에서 오류가 났는지 보여 준다. 또 |interaction=errorStopMode|이면 사용자와 대화를
시작하는데, 그러다가 도움말을 찍어 줄 수도 있다. 그러니 오류 하나를 알리는 일은 늘 이렇게
세 단계로 이루어진다. 공식 메시지를 찍고, 도움말을 준비해 두고, |reportError|로 마무리한다.
@^system dependencies@>


@ 전역 변수 |interaction|은 네 가지 값을 가질 수 있는데, 뒤로 갈수록 사용자와 더 많이 주고받는다.
이 값들은 \.{\\batchmode}, \.{\\nonstopmode}, \.{\\scrollmode}, \.{\\errorstopmode}로 바꿀 수 있다.

@<전역 변수@>=
const (
	@!batchMode = iota // 멈추지 않고 터미널 출력도 하지 않는다
	@!nonstopMode // 멈추지 않는다
	@!scrollMode // 오류에서 멈추지 않는다
	@!errorStopMode // 기회가 있을 때마다 멈추어 사용자와 대화한다
)

func printErr(s any) {
	if interaction == errorStopMode {
		wakeUpTerminal()
	}
	printNl("! ")
	printStr(s)
}

var @!interaction int32 // 사용자와 주고받는 현재 수준; |batchMode..errorStopMode|

@ @<핵심 변수들의...@>=
interaction = errorStopMode

@ \TeX은 |selector|가 보통과 다른 값일 수도 있을 때에는 |reportError|를 부르지 않도록 조심한다.
오류 메시지를 낼 때 |selector|가 가질 수 있는 값은 다음 넷뿐이다.

\yskip\hang|noPrint| (|interaction=batchMode|이고 |logFile|을 아직 열지 않았을 때);

\hang|termOnly| (|interaction>batchMode|이고 |logFile|을 아직 열지 않았을 때);

\hang|logOnly| (|interaction=batchMode|이고 |logFile|이 열려 있을 때);

\hang|termAndLog| (|interaction>batchMode|이고 |logFile|이 열려 있을 때).

\yskip\noindent 곧 일괄 처리 모드에서는 터미널에 아무것도 찍지 않고, 기록 파일은 열려 있으면
언제나 쓴다. 아래 코드는 기록 파일을 열기 전의 처음 값을 이 규칙대로 정한다.

@<|interaction|에 따라 찍기 |selector|를 초기화한다@>=
if interaction == batchMode {
	selector = noPrint
} else {
	selector = termOnly
}

@ 프로시저 |reportError|를 부를 때 |getNext| 루틴이 돌고 있는 중이면 전역 변수
|deletionsAllowed|를 |false|로 놓는다. 사용자가 오류 메시지를 보고 토큰을 지우라고 하면
|reportError|는 |getToken|을 부르는데, |getNext|가 도는 도중에 그렇게 하면 |getNext|와
|getToken| 같은 루틴이 자기 자신을 다시 부르게 된다. 이 변수는 그런 재귀를 막아 준다. 비슷한
잠금 장치로 |setBoxAllowed|가 있다.
@^recursion@>

전역 변수 |history|에는 지금까지 나온 오류 가운데 가장 나쁜 것의 수준이 들어 있다. 값은
|spotless|, |warningIssued|, |errorMessageIssued|, |fatalErrorStop| 가운데 하나다. \TeX이 끝날
때 이 값을 보면 작업이 얼마나 순조로웠는지 알 수 있다.

전역 변수 |errorCount|는 사용자와 대화하지 않고 |reportError|가 지나갈 때마다 1씩 늘고, 문단이
끝날 때마다 0으로 돌아간다. 이 값이 100에 이르면 \TeX은 더 해 봐야 소용없다고 보고 그만둔다.
한 문단에서 오류가 백 개나 난다면 무언가 근본적으로 잘못되었을 테니까.

@<전역 변수@>=
const (
	@!spotless = iota // 아직 아무 잘못도 없을 때의 |history| 값
	@!warningIssued // |beginDiagnostic|을 불렀을 때의 |history| 값
	@!errorMessageIssued // |reportError|를 불렀을 때의 |history| 값
	@!fatalErrorStop // 너무 일찍 끝났을 때의 |history| 값
)

var @!deletionsAllowed bool // |reportError|가 |getToken|을 불러도 안전한가?
var @!setBoxAllowed bool // \.{\\setbox} 대입을 해도 안전한가?
var @!history int32 // 지금까지 입력이 깨끗했나? |spotless..fatalErrorStop|
var @!errorCount int32 // 지난 문단이 끝난 뒤로 대화 없이 지나간 오류의 수; |-1..100|

@ 변수 |history|의 처음 값은 |fatalErrorStop|이다. \TeX이 초기화를 무사히 마치면 그때
|spotless|로 바뀐다. 그러니 초기화 도중에 죽으면 |history|는 치명적인 오류를 알린다.

@<핵심 변수들의...@>=
deletionsAllowed = true
setBoxAllowed = true
errorCount = 0 // |history|는 다른 곳에서 초기화한다

@ 오류는 \TeX의 거의 어디에서나 나올 수 있으므로, 오류 프로시저들은 프로그램의 앞쪽에서
정의해 두고 싶다. 그런데 오류 프로시저들은 다른 프로시저, 이를테면 |normalizeSelector|,
|getToken|, |termInput|, |showContext|, |beginFileReading|, |openLogFile|,
|closeFilesAndTerminate|, |clearForErrorPrompt|, |giveErrHelp|를 부르고, 디버깅할 때는
|debugHelp|도 부른다. 다행히 \GO/에서는 함수를 쓰기 전에 선언할 필요가 없으므로, 이것들은
저마다 제자리에서 정의하면 된다.

프로시저 |getToken|으로 토큰 하나를 지우다가 오류가 나거나, 치명적이지 않은 오류를 수습하는
도중에 치명적인 오류가 나면 |reportError|가 자기 자신을 다시 부를 수 있다. 그러나 그런 재귀는
결코 두 단계보다 깊어지지 않는다.
@^recursion@>

@ 도움말은 한 줄씩 배열 |helpLine|에 적어 둔다. 이 배열의 |0 .. (helpPtr-1)|에 항목들이 들어
있는데, 찍을 때는 거꾸로, 곧 |helpLine[0]|이 맨 마지막에 나오도록 찍어야 한다.

이를테면 함수 호출 |help3("a","b","c")|는 |helpPtr=3|, |helpLine[2]="a"|, |helpLine[1]="b"|,
|helpLine[0]="c"|로 놓는다. 이렇게 거꾸로 넣어 두면 찍는 쪽에서 |helpPtr|를 하나씩 줄여 가며
찍기만 하면 되고, 다 찍고 나면 |helpPtr|가 저절로 0이 된다. 도움말은 언제나 문자열 상수이므로
|helpLine|은 \GO/ 문자열의 배열이다.

@<전역 변수@>=
func help0() { helpPtr = 0 } // 이따금 도움말이 없을 수도 있다
func help1(a string) { // 도움말이 한 줄일 때 쓴다
	helpPtr = 1
	helpLine[0] = a
}
func help2(a, b string) { // 도움말이 두 줄일 때 쓴다
	helpPtr = 2
	helpLine[1], helpLine[0] = a, b
}
func help3(a, b, c string) { // 도움말이 세 줄일 때 쓴다
	helpPtr = 3
	helpLine[2], helpLine[1], helpLine[0] = a, b, c
}
func help4(a, b, c, d string) { // 도움말이 네 줄일 때 쓴다
	helpPtr = 4
	helpLine[3], helpLine[2], helpLine[1], helpLine[0] = a, b, c, d
}
func help5(a, b, c, d, e string) { // 도움말이 다섯 줄일 때 쓴다
	helpPtr = 5
	helpLine[4], helpLine[3], helpLine[2], helpLine[1], helpLine[0] = a, b, c, d, e
}
func help6(a, b, c, d, e, f string) { // 도움말이 여섯 줄일 때 쓴다
	helpPtr = 6
	helpLine[5], helpLine[4], helpLine[3] = a, b, c
	helpLine[2], helpLine[1], helpLine[0] = d, e, f
}

var @!helpLine [6]string // 다음 |reportError|를 위한 도움말
var @!helpPtr int32 // 들어 있는 도움말 줄의 수; |0..6|
var @!useErrHelp bool // |errHelp| 목록을 보여 주어야 하나?

@ @<핵심 변수들의...@>=
helpPtr = 0
useErrHelp = false

@ \seclabel{jump-out}프로시저 |jumpOut|은 돌고 있는 프로시저들을 모두 한꺼번에 건너뛰어 |endOfTEX|로 간다.
프로그램 전체에서 함수 바깥으로 뛰는 뻔하지 않은 이동은 이것 하나뿐이다. 어떤 오류에서 도저히
회복할 길이 없을 때 이것을 쓴다. \GO/에서는 |panic|으로 모든 함수를 빠져나가고, 주 프로그램이
그것을 받아서 레이블 |endOfTEX|로 간다(\secref{outer-labels}, \secref{main}).
@^system dependencies@>

@<오류 처리...@>=
func jumpOut() {
	panic(endOfTEX)
}

@ 이제 오류 알리기를 마무리하는 |reportError| 루틴이다. 마침표를 찍고, 문맥을 보여 주고,
사용자와 대화할 수 있으면 대화한다. 대화할 수 없으면 오류의 수를 세고 도움말을 기록 파일에만
적는다.

이 루틴에 가장 어울리는 이름은 그냥 `error'겠지만, \GO/에서 그것은 내장 인터페이스 형의
이름이다. 내장 이름을 가리지 않으려고 |reportError|라고 부른다. 같은 까닭으로 문자열을 찍는
기본 프로시저도 내장 함수 \.{print}를 가리지 않도록 |printStr|라고 부른다(\secref{print}).

@<오류 처리...@>=
func reportError() { // 오류 보고의 일을 마친다
	var c asciiCode // 사용자가 친 것
	var s1, s2, s3, s4 int32 // 토큰을 지울 때 전역 변수들을 저장하는 데 쓴다
	history = max(history, errorMessageIssued)
	printChar('.')
	showContext()
	if interaction == errorStopMode {
		@<사용자의 조언을 얻고 |return|한다@>
	}
	errorCount++
	if errorCount == 100 {
		printNl("(That makes 100 errors; please try again.)")
@.That makes 100 errors...@>
		history = fatalErrorStop
		jumpOut()
	}
	@<도움말을 기록 파일에 넣는다@>
}

@ 사용자가 친 줄의 첫 글자를 보고 무엇을 할지 정한다. 다시 물어봐야 할 때는 |continue| 문으로
루프 몸통의 맨 처음으로 돌아간다. \GO/의 |continue|는 |switch| 문 안에서 써도 그것을 둘러싼
|for| 루프에 작용한다. 사용자가 그냥 \<return>만 치면(빈 줄이면) 그대로 이어서 처리한다.

@<사용자의 조언을...@>=
for {
	if interaction != errorStopMode {
		return
	}
	clearForErrorPrompt()
	promptInput("? ")
@.?\relax@>
	if last == first {
		return
	}
	c = buffer[first]
	if c >= 'a' {
		c = c + 'A' - 'a' // 대문자로 바꾼다
	}
	@<코드 |c|를 해석하고, 끝났으면 |return|한다@>
}

@ 사용자가 \TeX에서 시스템 편집기로 곧장 넘어가 문제의 줄을 바로 고칠 수 있게 해 주는 `\.E'
선택지가 있으면 좋을 것이다. 그러나 그렇게 하려면 시스템 마법이 좀 필요하므로, 지금의
구현은 고쳐야 할 파일의 이름과 줄 번호를 찍어 주고 끝낸다.
@^system dependencies@>

디버깅 루틴을 넣어 컴파일했을 때만 쓸 수 있는 비밀 선택지 `\.D'도 있다.
@^debugging@>

@<코드 |c|를 해석하고...@>=
switch c {
case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
	if deletionsAllowed {
		@<토큰 |c-"0"|개를 지우고 |continue|@>
	}
case 'D':
	if debug {
		debugHelp()
		continue
	}
case 'E':
	if basePtr > 0 {
		if inputStack[basePtr].nameField >= 256 {
			printNl("You want to edit file ")
@.You want to edit file x@>
			slowPrint(inputStack[basePtr].nameField)
			printStr(" at line ")
			printInt(line)
			interaction = scrollMode
			jumpOut()
		}
	}
case 'H':
	@<도움말 정보를 찍고 |continue|@>
case 'I':
	@<터미널에서 새 재료를 끼워 넣고 |return|한다@>
case 'Q', 'R', 'S':
	@<대화 수준을 바꾸고 |return|한다@>
case 'X':
	interaction = scrollMode
	jumpOut()
default:
	// 아무것도 하지 않는다
}
@<쓸 수 있는 선택지들의 차림표를 찍는다@>

@ @<쓸 수 있는 선택지들의...@>=
printStr("Type <return> to proceed, S to scroll future error messages,")
@.Type <return> to proceed...@>
printNl("R to run without stopping, Q to run quietly,")
printNl("I to insert something, ")
if basePtr > 0 {
	if inputStack[basePtr].nameField >= 256 {
		printStr("E to edit your file,")
	}
}
if deletionsAllowed {
	printNl("1 or ... or 9 to ignore the next 1 to 9 tokens of input,")
}
printNl("H for help, X to quit.")

@ 여기서 \TeX의 저자는 |"Q"|, |"R"|, |"S"|와 그에 해당하는 대화 설정 |batchMode|, |nonstopMode|,
|scrollMode| 사이의 수치 관계를 슬쩍 써먹은 것을 사과한다. 세 글자와 세 설정이 똑같은 차례로
하나씩 떨어져 있으므로 |batchMode+c-"Q"|가 원하는 설정이 된다.
@^Knuth, Donald Ervin@>

@<대화 수준을...@>=
errorCount = 0
interaction = batchMode + c - 'Q'
printStr("OK, entering ")
switch c {
case 'Q':
	printEsc("batchmode")
	selector--
case 'R':
	printEsc("nonstopmode")
case 'S':
	printEsc("scrollmode")
} // 다른 경우는 없다
printStr("...")
printLn()
updateTerminal()
return

@ 사용자가 `\.I'를 쳤을 때다. 이 코드를 실행할 때 |buffer[(first+1)..(last-1)]|에는 사용자가
`\.I' 바로 뒤에 쳐 넣은 재료가 들어 있을 수 있다. 아무것도 없으면 다시 재촉해서 받는다. 받은
재료는 터미널에서 읽는 새 입력 수준으로 끼워 넣으므로, \TeX은 그것을 다 읽은 뒤에 원래 읽던
곳으로 돌아간다. 프로그램의 이 부분을 온전히 이해하려면 \TeX의 입력 스택을 알아야 한다.

@<터미널에서 새 재료를...@>=
beginFileReading() // 터미널 입력을 위해 새 구문 수준에 들어간다
@t\qquad@>// 이제 |state=midLine|이므로, 처음의 공백은 공백으로 친다
if last > first+1 {
	loc = first + 1
	buffer[first] = ' '
} else {
	promptInput("insert>")
	loc = first
@.insert>@>
}
first = last
limit = last - 1 // 이 줄은 |endLineChar|로 끝나지 않는다
return

@ 사용자가 숫자를 쳤을 때다. 한 번에 토큰을 99개까지 지울 수 있다. 토큰을 지우려면 실제로
|getToken|으로 읽어서 버려야 하는데, 그러다 보면 |curTok|, |curCmd|, |curChr|, |alignState|가
바뀌어 버리므로 미리 저장해 두었다가 되돌린다. 지우는 동안에는 끼어들기도 받지 않는다.

@<토큰 |c-"0"|개를...@>=
s1 = curTok
s2 = curCmd
s3 = curChr
s4 = alignState
alignState = 1000000
okToInterrupt = false
if last > first+1 && buffer[first+1] >= '0' && buffer[first+1] <= '9' {
	c = c*10 + buffer[first+1] - '0'*11
} else {
	c -= '0'
}
for c > 0 {
	getToken() // |reportError|의 한 단계 재귀 호출이 일어날 수 있다
	c--
}
curTok = s1
curCmd = s2
curChr = s3
alignState = s4
okToInterrupt = true
help2("I have just deleted some text, as you asked.",
	"You can now delete more, or insert, or whatever.")
showContext()
continue

@ 사용자가 `\.H'를 쳤을 때다. 도움말을 찍고 나면 도움말을 ``이미 다 드렸다''는 내용으로 바꾸어
둔다. 그래서 `\.H'를 두 번 치면 두 번째에는 사과의 말이 나온다.
@<도움말 정보를...@>=
if useErrHelp {
	giveErrHelp()
	useErrHelp = false
} else {
	if helpPtr == 0 {
		help2("Sorry, I don't know how to help in this situation.",
			"Maybe you should try asking a human?")
	}
	for {
		helpPtr--
		printStr(helpLine[helpPtr])
		printLn()
		if helpPtr == 0 {
			break
		}
	}
}
help4("Sorry, I already gave what help I could...",
	"Maybe you should try asking a human?",
	"An error might have occurred before I noticed any problems.",
	"``If all else fails, read the instructions.''")
continue

@ 사용자와 대화하지 않을 때는 도움말을 터미널에는 찍지 않고 기록 파일에만 적는다. 그래서
|selector|를 잠시 하나 줄여 터미널 쪽을 끈다.
@<도움말을 기록 파일에...@>=
if interaction > batchMode {
	selector-- // 터미널 출력을 피한다
}
if useErrHelp {
	printLn()
	giveErrHelp()
} else {
	for helpPtr > 0 {
		helpPtr--
		printNl(helpLine[helpPtr])
	}
}
printLn()
if interaction > batchMode {
	selector++ // 터미널 출력을 다시 살린다
}
printLn()

@ 오류 메시지 열두어 개가 괄호에 싼 정수로 끝나므로, 다음 프로시저를 따로 만들어 프로그램
공간을 아주 조금 아낀다.

@<함수들@>=
func intError(n int32) {
	printStr(" (")
	printInt(n)
	printChar(')')
	reportError()
}

@ 이상한 경우에는 찍기 선택자가 알 수 없는 상태에 빠져 있을 수도 있다. 다음 서브루틴은 \TeX이
조금 더 버틸 수 있을 만큼만 상황을 바로잡는다. 기록 파일이 아직 열리지 않았으면 이참에 연다.

@<함수들@>=
func normalizeSelector() {
	if logOpened {
		selector = termAndLog
	} else {
		selector = termOnly
	}
	if jobName == 0 {
		openLogFile()
	}
	if interaction == batchMode {
		selector--
	}
}

@ 다음 프로시저는 \TeX이 죽기 전에 남기는 마지막 말을 찍는다. 사용자와 대화할 수 있었더라도
이제는 대화하지 않는다. 그리고 |jumpOut|으로 모든 것을 버리고 끝으로 간다. 치명적인 오류를
알리는 |fatalError|도 이것을 쓴다.

@<오류 처리...@>=
func succumb() {
	if interaction == errorStopMode {
		interaction = scrollMode // 더는 대화하지 않는다
	}
	if logOpened {
		reportError()
	}
	if debug {
		if interaction > batchMode {
			debugHelp()
		}
	}
	history = fatalErrorStop
	jumpOut() // 회복할 수 없는 오류
}

func fatalError(s string) { // |s|를 찍고, 그것으로 끝이다
	normalizeSelector()
	printErr("Emergency stop")
	help1(s)
	succumb()
@.Emergency stop@>
}

@ 다음은 가장 무서운 오류 메시지다. \TeX의 어떤 표가 꽉 찼다는 뜻이고, 이 오류가 나면 일을
계속할 수 없다. 메시지의 대괄호 안에는 어느 표가 넘쳤는지와 그 크기가 찍힌다.

@<오류 처리...@>=
func overflow(s string, n int32) { // 유한성 때문에 멈춘다
	normalizeSelector()
	printErr("TeX capacity exceeded, sorry [")
@.TeX capacity exceeded ...@>
	printStr(s)
	printChar('=')
	printInt(n)
	printChar(']')
	help2("If you really absolutely need more capacity,",
		"you can ask a wizard to enlarge me.")
	succumb()
}

@ 프로그램이 언젠가 완전히 미쳐 날뛸 수도 있다. 그러면 멈추는 수밖에 없다. 그 전에 아무 오류도
없었다면 이것은 나쁜 소식이다. 프로그램 자체에 버그가 있다는 뜻이기 때문이다. 그래서 그때는
사용자보다는 \TeX\ 관리자에게 하는 말을 찍는다(사용자가 유달리 악랄하지 않았다면 말이다).
찾아보기의 `this can't happen' 항목들을 보면 문제가 어디인지 정확히 짚어 낼 수 있을 것이다. 앞서
오류가 있었다면 그 오류의 여파일 가능성이 크므로, 그때는 사용자에게 먼저 그것을 고치라고 한다.
@^dry rot@>


@<오류 처리...@>=
func confusion(s string) { // 일관성 검사가 어긋났다; |s|가 그곳을 알려 준다
	normalizeSelector()
	if history < errorMessageIssued {
		printErr("This can't happen (")
		printStr(s)
		printChar(')')
@.This can't happen@>
		help1("I'm broken. Please show this to someone who can fix can fix")
	} else {
		printErr("I can't go on meeting you like this")
@.I can't go on...@>
		help2("One of your faux pas seems to have wounded me deeply...",
			"in fact, I'm barely conscious. Please fix it and try again.")
	}
	succumb()
}

@ 사용자는 이따금 \TeX이 돌고 있는 도중에 끼어들고 싶어 한다. 실행 시스템이 허락한다면,
끼어들기 신호가 올 때 전역 변수 |interrupt|를 0이 아닌 값으로 놓는 루틴을 만들 수 있다. \GO/에서는
|os/signal| 꾸러미로 끼어들기 신호를 받을 수 있으므로 바로 그렇게 한다(다음 절). 그럴 수 없는
시스템이라도 적어도 디버거로 |interrupt|를 0이 아니게 바꿀 방법은 있을 것이다.
@^system dependencies@>
@^debugging@>

@<전역 변수@>=
func checkInterrupt() {
	if interrupt != 0 {
		pauseForInstructions()
	}
}

var @!interrupt int32 // \TeX이 멈추고 지시를 기다려야 하나?
var @!okToInterrupt bool // 끼어들기를 받아들여야 하나?
var @!interruptSignal = make(chan os.Signal, 1) // 끼어들기 신호가 들어오는 통로

@ @<핵심 변수들의...@>=
interrupt = 0
okToInterrupt = true

@ 주 프로그램은 시작하자마자 다음 일을 해 둔다(\secref{main}). 사용자가 끼어들기 신호(대개
\.{Ctrl-C})를 보내면 따로 도는 고루틴이 그것을 받아서 |interrupt|를 1로 놓는다. \TeX은
|checkInterrupt|를 부를 때에만 이 변수를 살피므로, 신호는 그때에야 처리된다. 그래서 자료 구조가
어중간한 상태일 때 끼어드는 일은 생기지 않는다.

@<끼어들기 신호를 받으면 |interrupt|를 놓게 한다@>=
signal.Notify(interruptSignal, os.Interrupt)
go func() {
	for range interruptSignal {
		interrupt = 1
	}
}()

@ 끼어들기를 알아채면 프로그램은 가장 높은 대화 수준으로 들어가서, 사용자가 |reportError|
루틴이 주는 거의 모든 선택지를 쓸 수 있게 한다. 이를테면 `\.{I\\showlists}'를 쳐서 지금
목록의 상태를 볼 수도 있다. 다만 토큰 지우기는 허락하지 않는다. \TeX은 그렇게 해도 안전할
때에만 끼어들기를 살핀다.

@<함수들@>=
func pauseForInstructions() {
	if okToInterrupt {
		interaction = errorStopMode
		if selector == logOnly || selector == noPrint {
			selector++
		}
		printErr("Interruption")
@.Interruption@>
		help3("You rang?",
			"Try to insert an instruction for me (e.g., `I\\showlists'),",
			"unless you just want to quit by typing `X'.")
		deletionsAllowed = false
		reportError()
		deletionsAllowed = true
		interrupt = 0
	}
}

@* 눈금 단위 치수의 산술.
\TeX이 하는 주요 계산은 모두 절댓값이 $2^{31}$보다 작은 정수만으로 이루어지고, 나눗셈은
피제수와 제수가 둘 다 음이 아닐 때에만 한다. 그래서 이 프로그램이 정한 산술은 꽤 작은
컴퓨터까지 포함해 온갖 컴퓨터에서 꼭 같은 방식으로 해낼 수 있다. 왜 그래야 할까? 서로 다른
기계에서 \TeX이 같은 출력을 낸다고 보장하려면 산술 계산을 하나하나 정확하게 정해 두어야 하기
때문이다. 어떤 양이 구현마다 조금씩 다르게 반올림된다면 줄이 나뉘는 곳, 심지어 쪽이 나뉘는
곳까지 달라질 수 있다. 그래서 \TeX의 산술은 아주 조심스럽게 설계했고, \TeX82의 구현이라고
@^TeX82@>
자처하는 시스템은 이 프로그램에 나온 계산을 그대로 따라야 한다. 이런 까닭에 \TeX은 치수를
다룰 때 부동 소수점 수를 쓰지 않는다. 부동 소수점 연산은 기계마다 결과가 미묘하게 다를 수
있기 때문이다.

(사실 \TeX이 음수일 수도 있는 피제수로 나눗셈을 하는 곳이 세 군데 있다. 그러나 해는 없다.
찾아보기의 `negative dividends'를 보라. 또 사용자가 \.{\\time}이나 \.{\\year}를 음수로 정하면,
어떤 진단 정보를 찍을 때 음의 피제수 나눗셈이 일어난다. 나눗셈 |/|뿐 아니라 나머지 연산 |%|에
대해서도 마찬가지다.) \GO/의 정수 나눗셈은 0 쪽으로 자르고 나머지의 부호는 피제수를 따른다.
그러나 피제수와 제수가 음이 아니면 어느 쪽 관례를 따르든 결과는 같다.

@ 다음은 정수의 절반을 구하는 루틴이다. 홀수일 때 어느 쪽으로 반올림할지 모호하지 않도록,
늘 $(x+1)/2$로 계산한다. 이를테면 |half(3)=2|이고 |half(-3)=-1|이다.

@<함수들@>=
func half(x int32) int32 {
	if odd(x) {
		return (x + 1) / 2
	} else {
		return x / 2
@^negative dividends@>
	}
}

@ 고정 소수점 산술은 $2^{-16}$의 배수인 {\sl 눈금 정수\/}(scaled integer)로 한다. 다시 말해
이진 소수점이 이진 컴퓨터 낱말의 오른쪽 끝에서 열여섯 비트째 자리에 있다고 본다. 그러니
정수 |unity|$=2^{16}=65536$이 1.0을 나타내고, 이를테면 32768은 0.5를, $-98304$는 $-1.5$를
나타낸다.

@<전역 형@>=
const (
	unity = 0o200000 // $2^{16}$, 1.00000을 나타낸다
	two = 0o400000 // $2^{17}$, 2.00000을 나타낸다
)

type @!scaled = int32 // 이 형은 눈금 정수에 쓴다
type @!nonnegativeInteger = int32 // $0\le x<2^{31}$
type @!smallNumber = int32 // 이 형은 이름이 다 말해 준다; |0..63|

@ 다음 함수는 십진 소수 $(.d_0d_1\ldots d_{k-1})$을 눈금 정수로 바꾼다. 여기서 |0<=k<=17|이다.
숫자 $d_i$는 |dig[i]|에 들어 있고, 결과는 올바르게 반올림한 값이다. 맨 아래 자리부터 거꾸로
올라오면서 $a\leftarrow(a+d_i\cdot2^{17})/10$을 되풀이하면, 끝에 $a$는 그 소수의 $2^{17}$배에
가까운 값이 된다. 이것을 반올림하며 2로 나누면 원하는 $2^{16}$배를 얻는다. 한 비트를 더 들고
다니는 것은 반올림을 정확히 하기 위해서다.

@<함수들@>=
func roundDecimals(k smallNumber) scaled { // 십진 소수를 바꾼다
	var a int32 // 누산기
	a = 0
	for k > 0 {
		k--
		a = (a + dig[k]*two) / 10
	}
	return (a + 1) / 2
}

@ 이번에는 거꾸로, |printInt|와 비슷한 프로시저다. 이 프로시저가 찍은 것을 나중에 \TeX이 다시
읽어서 앞의 |roundDecimals|로 바꾸면 원래의 값이 정확히 되살아난다. 그런 십진수 가운데
``가장 간단한'' 것을 찍되, 소수점 뒤에는 언제나 숫자를 적어도 하나 찍는다. 이를테면 1.0은
\.{1.0}으로, 눈금 정수 21845(곧 $21845/65536$)는 \.{0.33333}으로 찍는다. 더 짧게 \.{0.3333}으로
찍으면 다시 읽었을 때 21843이 되어 버리기 때문이다.

루프의 불변 관계는 이렇다. 앞으로 찍을 십진 숫자들이 이루는 분수를~$f$라 하면, $f$가
범위 $s-\delta\le10\cdot2^{16}f<s$에 들어갈 때, 그리고 오직 그때에만 원래의 수가 되살아난다.
여기서 $\delta$는 허용되는 오차의 폭이다. 값 $f=0$이 이 조건을 만족할 때, 그리고 오직
그때에만 멈출 수 있다. 루프는 $s$가 0이 되기 전에 끝난다.

@<함수들@>=
func printScaled(s scaled) { // 다섯 자리로 반올림한 눈금 실수를 찍는다
	var delta scaled // 허용되는 부정확함의 양
	if s < 0 {
		printChar('-')
		s = -s // 음수면 부호를 찍는다
	}
	printInt(s / unity) // 정수 부분을 찍는다
	printChar('.')
	s = 10*(s%unity) + 5
	delta = 10
	for {
		if delta > unity {
			s = s + 0o100000 - 50000 // 마지막 숫자를 반올림한다
		}
		printChar('0' + (s / unity))
		s = 10 * (s % unity)
		delta *= 10
		if s <= delta {
			break
		}
	}
}

@ \TeX\ 사용자가 문서의 여러 부분에 정해 주는 물리적 크기는 내부에서 눈금 포인트로 나타낸다.
`sp'(scaled point, 눈금 포인트)를 인쇄업자가 쓰는 포인트의 $2^{-16}$로 정의하면, \TeX\ 안의
@^sp@>
치수는 모두 sp의 정수 배다. 1인치는 정확히 4,736,286.72\,sp다. 사용자는 $2^{30}-1$\,sp보다 큰
치수를 지정할 수 없는데, 이것은 약 18.892피트(5.7583미터)나 되는 거리다. 이 한계 안의 양은 둘을
더해도 32비트 컴퓨터에서 넘치지 않는다.

지금의 \TeX\ 구현은 치수를 더하거나 뺄 때 넘침을 검사하지 않는다. 검사하려면 `\ignorespaces|if
@^overflow in arithmetic@>
x>=@'10000000000 {reportOverflow()}|' 꼴의 검사를 수십 군데 넣으면 되겠지만, 넘칠 가능성이
너무나 낮아서 그럴 만한 가치가 없어 보인다.

\TeX은 눈금 양을 가지고 덧셈과 뺄셈 말고는 몇 가지 산술 연산만 하면 되고, 그 일의 대부분은
다음 서브루틴들이 한다. 계산 하나가 이 서브루틴들을 여러 번 부를 수도 있는데, 산술이 넘쳤을
때 같은 오류 메시지를 여러 번 내는 것은 바람직하지 않다. 그래서 이 루틴들은 넘침을 사용자에게
바로 알리지 않고 전역 변수 |arithError|를 |true|로 놓기만 한다. 부른 쪽이 계산을 다 마친 뒤에
이 변수를 한 번 보고 알리면 된다. 또 하나의 전역 변수 |remainder|에는 나눗셈의 나머지가 남는다.

@<전역 변수@>=
var @!arithError bool // 최근에 산술 넘침이 일어났나?
var @!remainder scaled // 정확한 나눗셈을 얻으려고 뺀 양

@ 처음으로 필요한 산술 서브루틴은 $nx+y$를 계산한다. 여기서 |x|와~|y|는 |scaled|이고 |n|은
정수다. 이것을 써서 정수끼리 곱하기도 한다. 결과가 치수라면 $2^{30}$보다 작아야 하고, 그냥
정수라면 $2^{31}$보다 작아야 하므로, 두 경우의 한계를 |maxAnswer|로 넘겨 준다. 곱하기 전에
결과가 한계를 넘을지 나눗셈으로 미리 따져 보므로, 정말로 넘치는 계산은 하지 않는다.

@<함수들@>=
func nxPlusY(n int32, x, y scaled) scaled { return multAndAdd(n, x, y, 0o7777777777) }
func multIntegers(n int32, x scaled) scaled { return multAndAdd(n, x, 0, 0o17777777777) }

func multAndAdd(n int32, x, y, maxAnswer scaled) scaled {
	if n < 0 {
		x = -x
		n = -n
	}
	if n == 0 {
		return y
	} else if x <= (maxAnswer-y)/n && -x <= (maxAnswer+y)/n {
		return n*x + y
	} else {
		arithError = true
		return 0
	}
}

@ 눈금 치수를 정수로 나누는 것도 필요하다. 음수를 직접 나누지 않도록 부호를 먼저 떼어 내고
양수로 나눈 다음 부호를 되돌린다. 앞에서 말했듯이 음수의 나눗셈은 언어마다 결과가 다를 수
있기 때문이다. 몫은 0 쪽으로 잘리고,
나머지 |remainder|는 |x=n*xOverN+remainder|가 되도록 정한다. 0으로 나누면 |arithError|를 놓는다.

@<함수들@>=
func xOverN(x scaled, n int32) (xOverN scaled) {
	var negative bool // |remainder|의 부호를 바꾸어야 하나?
	negative = false
	if n == 0 {
		arithError = true
		xOverN = 0
		remainder = x
	} else {
		if n < 0 {
			x = -x
			n = -n
			negative = true
		}
		if x >= 0 {
			xOverN = x / n
			remainder = x % n
		} else {
			xOverN = -((-x) / n)
			remainder = -((-x) % n)
		}
	}
	if negative {
		remainder = -remainder
	}
	return
}

@ 다음은 눈금 수에 분수 |n/d|를 곱한다. 여기서 |n|과 |d|는 |<=@t$2^{16}$@>|인 음이 아닌 정수이고,
|d|는 양수다. 먼저 |n|을 곱하고 그다음 |d|로 나누면 중간에 넘치기 쉬워서 너무 위험하고, 먼저 |d|로
나누고 그다음 |n|을 곱하면 너무 부정확하다. 그래서 이 서브루틴은 1.5배 정밀도 산술을 흉내 낸다.
곧 |x|를 $2^{15}$ 단위의 윗부분과 아랫부분으로 쪼개어 따로 |n|을 곱한 다음, 받아올림을 맞추어 가며
|d|로 나누는 것이다. 다만 여기에는 숨은 전제가 하나 있다. \TeX이 넘기는 |x|는 언제나 치수여서
절댓값이 $2^{30}$보다 작으므로, 중간값 |t|와 |u|는 둘 다 $2^{15}n\le2^{31}$보다 작아 32비트
정수를 넘치지 않는다. 이 함수를 다른 데 쓰려면 이 전제를 지켜야 한다.

앞 절과 이 절의 함수는 결과 변수에 함수와 같은 이름(이를테면 |xnOverD|)을 붙이고, 그 이름에
값을 넣은 다음 빈 |return|으로 끝낸다. \GO/에서는 결과 변수에 이름을 붙일 수 있으므로 이렇게
쓸 수 있다.

@<함수들@>=
func xnOverD(x scaled, n, d int32) (xnOverD scaled) {
	var positive bool // |x>=0|이었나?
	var t, u, v nonnegativeInteger // 중간 양들
	if x >= 0 {
		positive = true
	} else {
		x = -x
		positive = false
	}
	t = (x % 0o100000) * n
	u = (x/0o100000)*n + (t / 0o100000)
	v = (u%d)*0o100000 + (t % 0o100000)
	if u/d >= 0o100000 {
		arithError = true
	} else {
		u = 0o100000*(u/d) + (v / d)
	}
	if positive {
		xnOverD = u
		remainder = v % d
	} else {
		xnOverD = -u
		remainder = -(v % d)
	}
	return
}

@ 다음 서브루틴은 글루의 ``나쁨''(badness)을 계산한다. 늘이거나 줄일 수 있는 양을 다 합하면~|s|인데,
그것으로 전체~|t|만큼을 늘이거나 줄여야 하는 상황이다. {\sl The \TeX book}에 따르면 이때의 나쁨은
@^TeXbook@>
$100(t/s)^3$이다. 그러나 나쁨은 어디까지나 어림셈이므로, 계산할 때 정확도를 마지막 한 방울까지
짜낼 필요는 없다. 우리가 정말로 바라는 것은 비슷한 성질을 지닌 근삿값이다.

나쁨을 실제로 계산하는 방법은 말로 설명하기보다 프로그램을 읽는 편이 쉽다. 결과는
$100(t/s)^3$에 꽤 가까운 정수이며, \TeX의 구현은 모두 바로 이 방법을 써야 한다. 나쁨이 $2^{13}$
이상이면 무한히 나쁜 것으로 보고 10000으로 나타낸다.
$$\hbox{|badness(t+1,s)>=badness(t,s)>=badness(t,s+1)|}$$임은 어렵지 않게 증명할 수 있다. 곧
더 많이 늘여야 할수록, 또 늘일 여지가 적을수록 나쁨은 커진다(적어도 작아지지는 않는다). 여기서
정의한 나쁨 함수가 내놓는 값은 많아야 1095가지뿐이지만, 그것으로 충분하다.

근사가 무슨 뜻인지 풀어 보자. 원하는 값은 $100(t/s)^3$인데, $297^3=26198073\approx
99.94\times2^{18}$이므로 $r=297t/s$로 두면 $r^3/2^{18}\approx100(t/s)^3$이다. 마지막 줄의
$(r^3+2^{17})/2^{18}$은 $r^3/2^{18}$을 가장 가까운 정수로 반올림한 것이다. 곱 |t*297|이 넘치지
않도록 $t\le7230584$일 때에만 먼저 곱하고, 그렇지 않으면 $s$를 먼저 297로 나눈다. 다만 $s<1663497$이면
그냥 $r=t$로 두어 결과가 |infBad|가 되게 한다. 이때는 $t/s>4.34$이므로 참값도 이미 8200을 넘는다.
정확도를 조금 버리는 대신 계산을 단순하게 한 것이다. 이를테면 $t=s$, 곧 늘일 수 있는 만큼
꼭 다 늘였다면 $r=297$이고 나쁨은 $(297^3+2^{17})/2^{18}=100$이 된다. 늘인 양 $t$가 $s$의 절반이면
나쁨은 12다.

@<함수들@>=
const infBad = 10000 // 무한히 나쁜 값

func badness(t, s scaled) halfword { // |t>=0|일 때 나쁨을 계산한다
	var r int32 // $\alpha t/s$의 근삿값, 여기서 $\alpha^3\approx100\cdot2^{18}$
	if t == 0 {
		return 0
	} else if s <= 0 {
		return infBad
	} else {
		if t <= 7230584 {
			r = (t * 297) / s // $297^3=99.94\times2^{18}$
		} else if s >= 1663497 {
			r = t / (s / 297)
		} else {
			r = t
		}
		if r > 1290 {
			return infBad // $1290^3<2^{31}<1291^3$
		} else {
			return (r*r*r + 0o400000) / 0o1000000
		} // 이것은 $r^3/2^{18}$을 가장 가까운 정수로 반올림한 것이다
	}
}

@ \TeX이 목록을 상자로 ``꾸릴'' 때는 상자 안의 글루를 어떤 비율로 늘이거나 줄여야 하는지
계산해야 한다. 이 비율은 \TeX이 무엇을 할지 판단하는 데에는 쓰이지 않는다. 그러니 글루 계산의
반올림 같은 세부가 컴퓨터마다 조금 달라도, \TeX이 내리는 판단, 곧 줄이나 쪽을 어디서 나눌지는
달라지지 않는다. 달라지는 것은 기껏해야 글자 위치의 아주 작은 차이뿐이다.

이 비율에는 형 |glueRatio|를 쓴다. 글루 비율이 \TeX의 다른 자료 구조와 매끄럽게 어울리려면 정수와
같은 크기의 메모리(대개 32비트)를 차지하는 것이 좋다. 그래서 어떤 구현에서는 |glueRatio|가
32비트 실수여야 할 것이다. 아니면 고정 소수점 산술만으로 글루 비율을 다룰 수도 있다.
{\sl TUGboat \bf3},1 (1982년 3월), 10--27쪽을 보라. (다만 거기 실린 루틴들은 음의 글루 비율도
받아들이도록 고쳐야 한다.)
@^system dependencies@>

여기서는 |glueRatio|를 \GO/의 |float64|로 둔다. 함수 |float|와 |unfloat|는 |glueRatio|와 보통의
실수 사이를 바꾸는데, 둘 다 |float64|이므로 실제로는 아무 일도 하지 않는다. 함수 |floatConstant|는
정수 상수를 실수로 바꾼다. 글루 비율 필드를 0.0이나 1.0으로 놓을 때는 |setGlueSet(p,0.0)|처럼
그 필드에 쓰는 함수를 부른다.

@<전역 형@>=
type @!glueRatio = float64 // 글루 늘이기 비율의 한 낱말짜리 표현

func float(x glueRatio) float64 { return x } // |glueRatio|를 |float64|로 바꾼다
func unfloat(x float64) glueRatio { return x } // |float64|를 |glueRatio|로 바꾼다
func floatConstant(n int32) float64 { return float64(n) } // 정수 상수를 |float64|로 바꾼다

@* 꾸린 자료.
메모리를 아껴 쓰려고, \TeX은 주요 자료 구조를 모두 |memoryWord|라는 낱말 위에 쌓는다. 낱말
|memoryWord| 하나에는 (부호 있는) 정수(눈금 정수일 수도 있다)나 (부호 있는) |glueRatio|가
들어가거나, 정수 크기의 절반이나 4분의 1인 필드가 몇 개 들어간다.

변수 |x|의 형이 |memoryWord|라면, |x|에는 다음과 같은 이름으로 가리킬 수 있는 필드가 넷까지 있다.
$$\vbox{\halign{\hfil#&#\hfil&#\hfil\cr
|x|&.|sc|\qquad&(정수 하나, 또는 |scaled| 정수 하나)\cr
|x|&.|gr|&(|glueRatio| 하나)\cr
|x.hh.lh|, |x.hh|&.|rh|&(하프워드 필드 둘)\cr
|x.hh.b0|, |x.hh.b1|, |x.hh|&.|rh|&(쿼터워드 필드 둘, 하프워드 필드 하나)\cr
|x.qqqq.b0|, |x.qqqq.b1|, |x.qqqq|&.|b2|, |x.qqqq.b3|\hskip-100pt
  &\qquad\qquad\qquad(쿼터워드 필드 넷)\cr}}$$
이렇게 쓰면 쓰기도 번거롭고 읽기도 그리 좋지 않다. 그래서 필드를 읽고 쓰는 짧은 함수들을
만들어 표기를 더 짧고 알아보기 쉽게 할 것이다. 아래의 \GO/ 코드는 |memoryWord|와 그 하위 형들을
형식적으로 정의한다. \TeX은 낱말 안에서 필드들이 서로 어떤 자리에 놓이는지에 대해서는 아무것도
가정하지 않는다.

정수를 32비트로 가정하므로 하프워드에는 적어도 16비트, 쿼터워드에는 적어도 8비트가 들어가야
@^system dependencies@>
한다. 비트가 더 있다고 해서 해로울 것은 없다. 이를테면 36비트 낱말을 넉넉하게 쓸 수 있다면
|memMax|를 262142까지 키울 수 있을지도 모른다. 이것은 \TeX이 세상에 나온 첫 4년 동안 누가 가졌던
메모리보다도 여덟 배나 많다.

주의할 점이 있다. 낱말 |memoryWord|의 변형들을 모두 정수 하나의 공간에 겹쳐 꾸려 넣지 않으면 메모리가
낭비된다. 이를테면 |glueRatio|가 정수보다 크면 안 된다. 그런데 \GO/에는 변형들을 한 공간에
겹쳐 놓는 가변 레코드가 없으므로, 여기서는 |memoryWord|를 변형마다 따로 자리를 둔 구조체로
정의한다(\secref{memory-word}). 그래서 낱말 하나가 차지하는 메모리가 몇 배로 늘어나지만, 요즘
컴퓨터에서는 견딜 만하다.

지금의 구현은 가정을 거의 하지 않는다. 범위가 `|minQuarterword..maxQuarterword|'인 정수를
쿼터워드에, 범위가 `|minHalfword..maxHalfword|'인 정수를 하프워드에 넣을 수 있기만 하면 모든
것이 제대로 돌아간다.

대개는 |minQuarterword=minHalfword=0|으로 하는 것이 가장 효율적이므로, 큰 문제가 없는 한 그렇게
하는 것이 좋다. 여기서 정의한 값은 대부분의 32비트 컴퓨터에 권하는 값이다.

@<정의@>=
const (
	@!minQuarterword = 0 // |quarterword|에 허용되는 가장 작은 값
	@!maxQuarterword = 255 // |quarterword|에 허용되는 가장 큰 값
	@!minHalfword = 0 // |halfword|에 허용되는 가장 작은 값
	@!maxHalfword = 65535 // |halfword|에 허용되는 가장 큰 값
)

@ 쿼터워드와 하프워드의 값이 지켜야 할 부등식은 다음과 같다(정확히는 이 코드가 검사하는,
성립하면 안 되는 부등식들이다). 이를테면 |memMax|는 |maxHalfword|보다 작아야 한다. 메모리의
첨자, 곧 포인터를 하프워드 하나에 담아야 하기 때문이다.

@<``상수'' 값들이...@>=
if iniVersion {
	if memMin != memBot || memMax != memTop {
		bad = 10
	}
}
if memMin > memBot || memMax < memTop {
	bad = 10
}
if minQuarterword > 0 || maxQuarterword < 127 {
	bad = 11
}
if minHalfword > 0 || maxHalfword < 32767 {
	bad = 12
}
if minQuarterword < minHalfword ||
	maxQuarterword > maxHalfword {
	bad = 13
}
if memMin < minHalfword || memMax >= maxHalfword ||
	memBot-memMin > maxHalfword+1 {
	bad = 14
}
if fontBase < minQuarterword || fontMax > maxQuarterword {
	bad = 15
}
if fontMax > fontBase+256 {
	bad = 16
}
if saveSize > maxHalfword || maxStrings > maxHalfword {
	bad = 17
}
if bufSize > maxHalfword {
	bad = 18
}
if maxQuarterword-minQuarterword < 255 {
	bad = 19
}

@ \TeX에서는 |minQuarterword|를 더하거나 빼는 연산이 꽤 자주 일어난다. 그래서 값을 쿼터워드 꼴로
넣고 꺼내는 이 연산을 함수 |qi|와 |qo|로 줄여 쓴다. 하프워드에는 |hi|와 |ho|를 쓴다.

`|x+0|'과 `|x-0|' 같은 식을 최적화하지 못하는 컴파일러라면, |minQuarterword=0|일 때 이 함수들을
뻔한 방식으로 줄여 두어야 \TeX의 안쪽 루프가 더 빨리 돈다.
@^inner loop@>@^system dependencies@>

@<정의@>=
func qi(x int32) quarterword { return x + minQuarterword } // |eightBits| 항목을 쿼터워드에 넣는다
func qo(x quarterword) int32 { return x - minQuarterword } // |eightBits| 항목을 쿼터워드에서 꺼낸다
func hi(x int32) halfword { return x + minHalfword } // 16비트 항목을 하프워드에 넣는다
func ho(x halfword) int32 { return x - minHalfword } // 16비트 항목을 하프워드에서 꺼낸다

@ \seclabel{memory-word}독자는 다음 정의를 꼼꼼히 공부해 두어야 한다. 앞으로 나오는 자료 구조는 거의 모두 이
낱말들로 짜여 있다.
@^system dependencies@>

정수 자료와 |scaled| 자료는 같은 필드 |sc|에 들어간다. \GO/에는 가변 레코드(C의 공용체)가 없으므로
|memoryWord|는 변형을 모두 따로 담는 구조체이고, 하프워드 필드 |lh|와 쿼터워드 필드 |b0|, |b1|도
따로 있다. 그래도 \TeX은 한 낱말에 어떤 변형으로 쓴 값을 다른 변형으로 읽는 일이 없으므로, 필드가
겹치든 겹치지 않든 동작은 똑같다. 쿼터워드와 하프워드는 |asciiCode|처럼 |int32|의
별칭이다(\secref{ascii-code}).

이진 파일과 마찬가지로 낱말 파일에도 현재 원소를 담는 필드 |buf|를 둔다.

@<전역 형@>=
type @!quarterword = int32 // 낱말의 1/4; |minQuarterword..maxQuarterword|
type @!halfword = int32 // 낱말의 1/2; |minHalfword..maxHalfword|
type @!twoHalves struct {
	@!rh halfword
	@!lh halfword // 이 필드와 다음 두 필드는 겹쳐 놓아도 된다
	@!b0 quarterword
	@!b1 quarterword
}
type @!fourQuarters struct {
	b0 quarterword
	b1 quarterword
	@!b2 quarterword
	@!b3 quarterword
}
type @!memoryWord struct {
	@!sc int32 // 정수나 |scaled| 값
	@!gr glueRatio
	@!hh twoHalves
	@!qqqq fourQuarters
}
type @!wordFile struct {
	f      *os.File
	r      *bufio.Reader
	w      *bufio.Writer
	buf    memoryWord // 파일의 현재 원소
	atEOF bool        // 파일의 끝에 이르렀는가?
}

@ 디버깅할 때에는 |memoryWord|가 어떤 형인지 모르는 채로 찍어 보고 싶을 때가 있다. 그래서 가능한
방식으로 모두 찍는다. 정수로, 눈금 정수로, 글루 비율로, 그리고 하프워드와 쿼터워드로.
@^debugging@>
이 프로시저는 디버깅 코드에서만 부른다.

@<함수들@>=
func printWord(w memoryWord) { // |w|를 모든 방식으로 찍는다
	printInt(w.sc)
	printChar(' ')
	printScaled(w.sc)
	printChar(' ')
	printScaled(round(unity * float(w.gr)))
	printLn()
@^real multiplication@>
	printInt(w.hh.lh)
	printChar('=')
	printInt(w.hh.b0)
	printChar(':')
	printInt(w.hh.b1)
	printChar(';')
	printInt(w.hh.rh)
	printChar(' ')
	printInt(w.qqqq.b0)
	printChar(':')
	printInt(w.qqqq.b1)
	printChar(':')
	printInt(w.qqqq.b2)
	printChar(':')
	printInt(w.qqqq.b3)
}

@* 동적 메모리 할당.
\TeX\ 시스템은 메모리 할당을 거의 다 스스로 한다. 그래서 문자열이나 쓰레기 수집 같은 자동 기능이
없는 환경으로도 쉽게 옮겨 갈 수 있고, 메모리가 모자랄 때 사용자가 받는 오류 메시지도 \TeX이 직접
정할 수 있다. \TeX은 큰 배열 |mem| 하나를 마련해 동적으로 필요한 저장 공간을 모두 거기서 얻는다.
\TeX의 루틴들은 이 배열 안에서 잇닿은 낱말 몇 개를 한 덩어리로 묶어 노드로 쓴다.

포인터 변수는 이 배열의 첨자이거나, 나중에 설명할 |eqtb|라는 다른 배열의 첨자다. 포인터 변수에는
|mem|의 경계 바깥에 있는 특별한 표시가 들어갈 수도 있으므로, 포인터는 어떤 |halfword| 값이든 가질 수
있게 한다. 가장 작은 하프워드 값은 널 포인터를 나타낸다. \TeX은 |mem[null]|이 있다고 가정하지 않는다.

@<전역 변수@>=
type @!pointer = halfword // 표시이거나 |mem|이나 |eqtb|의 위치

const @!null = minHalfword // 널 포인터

var @!tempPtr pointer // 이따금 급할 때 쓰는 포인터 변수

@ 배열 |mem|은 따로 할당하는 두 영역으로 나뉘지만, 두 영역 사이의 경계는 고정되어 있지 않다. 두
영역은 함께 자라다가 작업마다 저마다 ``알맞은'' 크기에 이른다. 위치 |loMemMax| 이하에는 낱말이 둘
이상인 가변 길이 레코드를 둔다. 이 영역은 {\sl The Art of Computer Programming}의 연습 문제 2.5--19에
나오는 것과 비슷한 알고리즘으로 관리한다. 다만 할당한 노드에는 크기 필드가 없다. 노드를 해제할 때 그
크기를 알려 주는 것은 프로그램의 몫이다. 위치 |hiMemMin| 이상에는 한 낱말짜리 레코드를 둔다. 이 영역을
할당할 때는 흔히 쓰는 \.{AVAIL} 스택을 쓴다.

배열 |mem|에서 |memBot|부터 |memTop|까지는 \.{INITEX} 전처리기가 포맷 파일에 담아 내보낼 수 있는
@.INITEX@>
부분이다. 실무용 \TeX은 공간이 더 필요하면 메모리를 양쪽 끝으로 늘릴 수 있다. 아래쪽 끝의 |memMin|과
|memBot| 사이는 언제나 가변 크기 노드에 쓰고, 위쪽 끝의 |memTop|과 |memMax| 사이는 언제나 한
낱말짜리 노드에 쓴다.

배열 |mem|의 할당을 다스리는 핵심 포인터들 사이에는 늘 다음과 같은 순서가 성립한다.
$$\advance\thickmuskip-2mu
\hbox{|null<=memMin<=memBot<loMemMax<
  hiMemMin<memTop<=memEnd<=memMax|.}$$
그림으로 그리면 다음과 같다. 회색 부분이 노드들이 사는 곳이고, 위쪽의 화살표는 두 영역이 자라는
방향이다. 가운데의 빈 틈이 바닥나야 비로소 메모리가 모자란 것이다.
$$\mplibcode
beginfig(2);
save w, h, xb, xl, xh, xt, xe; numeric w, h, xb, xl, xh, xt, xe;
w := 420pt; h := 16pt;
xb := 14pt; xl := 160pt; xh := 250pt; xt := 300pt; xe := 345pt;
fill (0,0)--(xl,0)--(xl,h)--(0,h)--cycle withcolor .85white;
fill (xh,0)--(xe,0)--(xe,h)--(xh,h)--cycle withcolor .85white;
draw (0,0)--(w,0)--(w,h)--(0,h)--cycle;
for x = xl, xh, xe: draw (x,0)--(x,h); endfor
label(btex \ninepoint 가변 크기 노드 etex, (xl/2, h/2));
label(btex \ninepoint 빈 틈 etex, ((xl+xh)/2, h/2));
label(btex \ninepoint 한 낱말 노드 etex, ((xh+xe)/2, h/2));
drawarrow (xl-20pt, h+5pt)--(xl+10pt, h+5pt);
drawarrow (xh+20pt, h+5pt)--(xh-10pt, h+5pt);
for x = 0, xl, xh, xe, w: draw (x,0)--(x,-4pt); endfor
label.bot(btex \ID{memMin} etex, (0,-4pt));
label.bot(btex \ID{loMemMax} etex, (xl,-4pt));
label.bot(btex \ID{hiMemMin} etex, (xh,-4pt));
label.bot(btex \ID{memEnd} etex, (xe,-4pt));
label.bot(btex \ID{memMax} etex, (w,-4pt));
for x = xb, xt: draw (x,h)--(x,h+4pt); endfor
label.top(btex \ID{memBot} etex, (xb,h+4pt));
label.top(btex \ID{memTop} etex, (xt,h+4pt));
endfig;
\endmplibcode$$

실험해 보니 지금의 \TeX\ 구현은 실행 시간의 9\pct!쯤을 노드를 할당하는 데, 6\pct!쯤을 다 쓴 노드를
해제하는 데 쓰는 것 같다.

간추리면 이것이 \TeX의 메모리 관리 알고리즘의 전부다. 크기가 제각각인 노드(상자, 글루 명세 따위)는
아래쪽 영역에서 첫맞춤(first fit) 방식으로 얻고, 한 낱말짜리 노드(문자, 토큰 따위)는 위쪽 영역의
스택에서 얻는다. 두 영역이 마주 보고 자라므로 어느 한쪽의 크기를 미리 정해 둘 필요가 없다.

배열 |mem|에서 실제로 쓰는 첨자는 |memMin..memMax|다. \GO/의 배열은 첨자가 0부터 시작하므로
여기서는 0부터 |memMax|까지 잡는다. 위의 부등식에서 |null<=memMin|이고 |null=minHalfword=0|이므로,
이렇게 해도 첨자를 그대로 쓸 수 있다. 첨자가 |memMin|보다 작은 낱말은 쓰지 않는다.

@<전역 변수@>=
var @!mem [memMax + 1]memoryWord // 큰 동적 저장 영역
var @!loMemMax pointer // 쓰고 있는 가변 크기 메모리의 가장 큰 위치
var @!hiMemMin pointer // 쓰고 있는 한 낱말짜리 메모리의 가장 작은 위치

@ 어떤 응용이 메모리를 얼마나 쓰는지 연구하려면, 지금 쓰고 있는 메모리와 가장 많이 썼던 메모리를
추적하는 \TeX을 만들 수도 있다. 상수 |@!stat|이 참이면 `|if stat {|$\,\ldots\,$|}|' 안의 코드가 함께
컴파일되어 \TeX이 조금 느려지는 대신, |tracingStats|가 충분히 클 때 이런 통계를 알려 준다. 두
변수 |varUsed|와 |dynUsed|에는 각각 가변 크기 영역과 한 낱말짜리 영역에서 지금 쓰고 있는 낱말의
수가 들어 있다.

@<전역 변수@>=
var @!varUsed, @!dynUsed int32 // 메모리를 얼마나 쓰고 있나

@ 먼저 한 낱말짜리 메모리 영역을 살펴보자. 이쪽이 가장 간단하다. 포인터 변수 |memEnd|에는 지금까지
한 번이라도 쓴 적이 있는 |mem|의 가장 큰 위치가 들어 있다. 위치 |hiMemMin|과 |memEnd| 사이(양 끝
포함)의 빈 위치들은 형이 |twoHalves|이고, |mem[p]|가 이 형일 때 그 |lh| 필드와 |rh| 필드를
|info(p)|와 |link(p)|라고 쓴다. 한 낱말짜리 빈 위치들은 |null|로 끝나는 연결 목록
$$|avail|,\;\hbox{|link(avail)|},\;\hbox{|link(link(avail))|},\;\ldots$$
을 이룬다. 곧 빈 노드들을 |link|로 줄줄이 엮어 스택처럼 쓰는 것이다. 노드가 필요하면 맨 위의
것을 꺼내 쓰고, 다 쓴 노드는 맨 위에 다시 얹는다.

함수 |link(p)|와 |info(p)|는 |mem[p].hh.rh|와 |mem[p].hh.lh|를 읽는다. 이 필드들을 바꿀 때는
|setLink(p,q)|와 |setInfo(p,q)|를 부른다(\secref{conventions}). 앞으로 나오는 필드들도 모두
이렇게 다룬다.

@<전역 변수@>=
func link(p pointer) halfword       { return mem[p].hh.rh } // 메모리 낱말의 |link| 필드
func setLink(p pointer, v halfword) { mem[p].hh.rh = v }
func info(p pointer) halfword       { return mem[p].hh.lh } // 메모리 낱말의 |info| 필드
func setInfo(p pointer, v halfword) { mem[p].hh.lh = v }

var @!avail pointer // 쓸 수 있는 한 낱말짜리 노드 목록의 머리
var @!memEnd pointer // |mem|에서 쓰인 마지막 한 낱말짜리 노드

@ 메모리가 바닥났다면 사용자가 오른쪽 중괄호를 빠뜨렸다는 뜻일지도 모른다. 이를테면 매크로의
인자가 끝나지 않아 \TeX이 문서의 나머지를 몽땅 인자로 삼키고 있을 수 있다. 그럴 때 문제를 정확히
짚어 내도록 돕는 프로시저들을 나중에 정의한다.

@<함수들@>=
@<|showTokenList|라는 프로시저를 선언한다@>
@<|runaway|라는 프로시저를 선언한다@>

@ 함수 |getAvail|은 |link| 필드가 널인 새 한 낱말짜리 노드를 가리키는 포인터를 돌려준다. 남은
자리가 없으면 \TeX은 멈춘다.
@^inner loop@>

빈 노드의 목록이 비어 있으면, 곧 |avail=null|이면 먼저 |memEnd|를 늘려 본다. 그렇게 할 수 없으면,
곧 |memEnd=memMax|이면 |hiMemMin|을 줄여 본다. 그것도 안 되면, 곧 |hiMemMin=loMemMax+1|이면 두
영역이 맞닿은 것이므로 그만두어야 한다.

@<함수들@>=
func getAvail() pointer { // 한 낱말짜리 노드 할당
	var p pointer // 얻는 새 노드
	p = avail // |avail| 스택의 맨 위 위치를 얻는다
	if p != null {
		avail = link(avail) // 그리고 그것을 꺼낸다
	} else if memEnd < memMax { // 아니면 처녀지로 들어간다
		memEnd++
		p = memEnd
	} else {
		hiMemMin--
		p = hiMemMin
		if hiMemMin <= loMemMax {
			runaway() // 메모리가 바닥나면 폭주했을지 모르는 텍스트를 보인다
			overflow("main memory size", memMax+1-memMin)
			// 그만둔다; 한 낱말짜리 노드가 모두 쓰이고 있다
@:TeX capacity exceeded main memory size}{\quad main memory size@>
		}
	}
	setLink(p, null) // 새 노드에 흔히 원하는 초기화를 해 준다
	if stat {
		dynUsed++ // 통계를 유지한다
	}
	return p
}

@ 거꾸로, 다 쓴 한 낱말짜리 노드는 |freeAvail|을 불러 다시 쓸 수 있게 한다. 노드를 |avail| 스택의
맨 위에 얹기만 하면 된다. 이 루틴은 \TeX의 ``안쪽 루프''의 일부이므로 빨라야 한다.
@^inner loop@>

@<정의@>=
func freeAvail(p pointer) { // 한 낱말짜리 노드의 해방
	setLink(p, avail)
	avail = p
	if stat {
		dynUsed--
	}
}

@ 함수 |getAvail|을 가장 자주 부르는 곳에서는 그 대신 |fastGetAvail|을 쓴다. 이 함수는 프로그램을
조금 더 차지하는 대신, 빈 노드가 있으면 |getAvail|을 부르지 않고 바로 떼어 온다. \GO/ 컴파일러는
이 작은 함수를 대개 부르는 곳에 펼쳐 넣으므로 프로시저를 부르는 비용도 아낀다. 새 노드는 함숫값으로
돌려준다.
@^inner loop@>

@<정의@>=
func fastGetAvail() (p pointer) {
	p = avail // 될 수 있으면 시간을 아끼려고 |getAvail|을 피한다
	if p == null {
		p = getAvail()
	} else {
		avail = link(p)
		setLink(p, null)
		if stat {
			dynUsed++
		}
	}
	return
}

@ 프로시저 |flushList(p)|는 위치 |p|에서 시작하는 한 낱말짜리 노드들의 연결 목록을 통째로 해제한다.
목록의 끝까지 따라가서 마지막 노드를 찾은 다음, 목록 전체를 한꺼번에 |avail| 스택 위에 얹는다.
노드를 하나씩 |freeAvail|로 돌려주는 것보다 빠르다.
@^inner loop@>

@<함수들@>=
func flushList(p pointer) { // 한 낱말짜리 노드들의 목록을 쓸 수 있게 한다
	var q, r pointer // 목록을 훑는 것들
	if p != null {
		r = p
		for {
			q = r
			r = link(r)
			if stat {
				dynUsed--
			}
			if r == null {
				break
			}
		} // 이제 |q|는 목록의 마지막 노드다
		setLink(q, avail)
		avail = p
	}
}

@ 배열 |mem|의 가변 크기 영역에서 쓸 수 있는 공간은, 빈 노드들을 이중으로 연결한 순환 목록으로
관리한다. 이 목록은 결코 비지 않는다. 떠돌이 포인터 |rover|가 이 목록의 어느 한 노드를 가리킨다.

빈 노드는 크기가 모두 2 이상이다. 첫 낱말의 |link| 필드에는 특별한 값 |maxHalfword|가, |info|
필드에는 노드의 크기가 들어 있다. 둘째 낱말에는 이중 연결을 위한 포인터 둘이 들어 있다.

비어 있지 않은 노드도 크기가 모두 2 이상이다. 그 첫 낱말은 형이 |twoHalves|\kern-1pt이고, 그
|link| 필드는 결코 |maxHalfword|가 아니다. 그 밖의 필드와 나머지 낱말에는 무엇을 넣든 자유다.
그러니 노드의 첫 낱말의 |link| 필드만 보면 그 노드가 비었는지 알 수 있다.

(조건 |memMax<maxHalfword|를 요구하는 것은, 비어 있지 않은 노드의 |link| 필드에 |maxHalfword|가
나타나면 끔찍한 일이 벌어질 수 있기 때문이다. 쓰고 있는 노드를 빈 노드로 잘못 알고 합쳐 버릴
것이다.)

@<정의@>=
const @!emptyFlag = maxHalfword // 빈 가변 크기 노드의 |link|

func isEmpty(p pointer) bool { return link(p) == emptyFlag } // 빈 노드인지 검사한다
func nodeSize(p pointer) halfword { return info(p) } // 빈 가변 크기 노드의 크기 필드
func setNodeSize(p pointer, v halfword) { setInfo(p, v) }
func llink(p pointer) halfword { return info(p + 1) } // 빈 노드들의 이중 연결 목록에서 왼쪽 연결
func setLlink(p pointer, v halfword) { setInfo(p+1, v) }
func rlink(p pointer) halfword { return link(p + 1) } // 빈 노드들의 이중 연결 목록에서 오른쪽 연결
func setRlink(p pointer, v halfword) { setLink(p+1, v) }

@ @<전역 변수@>=
var @!rover pointer // 빈 노드 목록의 어떤 노드를 가리킨다

@ 가변 크기 영역은 대략 다음 그림과 같은 모습이다. 회색은 쓰고 있는 노드이고 흰 것은 빈 노드다.
빈 노드들은 메모리 안의 위치와 상관없이 |rlink|와 |llink|로 이어져 고리를 이루고, |rover|는 그 고리의
어느 한 노드를 가리킨다. 그림에는 |rlink| 연결만 그렸다. 빈 노드의 처음 두 낱말은 오른쪽 그림처럼
쓰인다.
$$\mplibcode
beginfig(3);
save u, h, cell; numeric u, h; u := 18pt; h := 14pt;
def cell(expr a, b, used) =
  if used: fill (a*u,0)--(b*u,0)--(b*u,h)--(a*u,h)--cycle withcolor .8white; fi
  for i = a+1 upto b-1: draw (i*u,0)--(i*u,h) withpen pencircle scaled .2pt; endfor
  draw (a*u,0)--(b*u,0)--(b*u,h)--(a*u,h)--cycle;
enddef;
cell(0,2,true); cell(2,5,false); cell(5,8,true); cell(8,10,false); cell(10,12,true); cell(12,16,false);
label(btex \ninepoint $p$ etex, (12.5u, h/2));
drawarrow (3.5u, h){up} .. (6u, h+16pt) .. {down}(8.5u, h);
drawarrow (9.5u, h){up} .. (11u, h+12pt) .. {down}(12.5u, h);
drawarrow (13.5u, h){up} .. {left}(12.5u, h+28pt) -- (3.5u, h+28pt){left} .. {down}(2.5u, h);
label.top(btex \ninepoint \ID{rlink} etex, (8u, h+28pt));
drawarrow (2.5u, -18pt)--(2.5u, -2pt);
label.bot(btex \ID{rover} etex, (2.5u, -18pt));
fill (14u,0)--(16u,0)--(16u,h)--(14u,h)--cycle withcolor .55white;
draw (14u,0)--(14u,h);
label.bot(btex \ninepoint $r=q-s$ etex, (14u, -2pt));
draw (14u,-2pt)--(14u,0);
label.bot(btex \ninepoint $q$ etex, (16u, -2pt));
save x; numeric x; x := 17.8u;
draw (x,0)--(x+120pt,0)--(x+120pt,2h)--(x,2h)--cycle;
draw (x,h)--(x+120pt,h); draw (x+60pt,0)--(x+60pt,2h);
label(btex \ninepoint \ID{nodeSize} etex, (x+30pt, 1.5h));
label(btex \ninepoint \ID{emptyFlag} etex, (x+90pt, 1.5h));
label(btex \ninepoint \ID{llink} etex, (x+30pt, .5h));
label(btex \ninepoint \ID{rlink} etex, (x+90pt, .5h));
label.top(btex \ninepoint \ID{info} etex, (x+30pt, 2h));
label.top(btex \ninepoint \ID{link} etex, (x+90pt, 2h));
label.lft(btex \ninepoint $p$ etex, (x, 1.5h));
label.lft(btex \ninepoint $p+1$ etex, (x, .5h));
endfig;
\endmplibcode$$
함수 |getNode(s)|가 하는 일은 단순하다. 포인터 |rover|에서 출발해 고리를 돌면서 빈 노드 |p|를 만날
때마다 다음을 한다. 먼저 물리적으로 바로 뒤에 붙은 노드 |q=p+nodeSize(p)|가 비어 있으면 그것을
고리에서 빼고 |p|에 합친다. 이웃한 빈 노드들은 해제할 때가 아니라 이렇게 할당할 때 느긋하게
합쳐진다. 그런 다음 |p|가 충분히 크면 노드의 {\sl 꼭대기}에서 |s|낱말, 곧 |r=q-s|부터 |q-1|까지를
떼어 준다(그림에서 짙은 회색). 꼭대기에서 떼어 주므로 |p|의 남은 부분은 크기만 줄어든 채 고리에
그대로 남고, 연결은 하나도 고칠 필요가 없다. 크기가 꼭 맞을 때에만 |p|를 고리에서 빼낸다. 남는
부분이 한 낱말뿐이라면 그것은 빈 노드가 될 수 없으므로 |p|를 건너뛴다. 해제하는 |freeNode|는 노드를
|rover| 바로 앞에 끼워 넣기만 하므로 더욱 단순하다.

@ 함수 |getNode|를 인자 |s|로 부르면 크기가~|s|인 새 노드를 가리키는 포인터를 돌려준다. 크기 |s|는
2~이상이어야 한다. 새 노드의 첫 낱말의 |link| 필드는 널로 놓는다. 그래야 이 노드가 비어 있지
않다는 표시가 된다. 고리를 한 바퀴 다 돌아도 알맞은 공간이 없으면 가변 크기 영역을 늘려 보고,
그것도 안 되면 넘침으로 멈춘다.

함수 |getNode|를 $s=2^{30}$으로 부르면, 그렇게 큰 노드는 결코 찾을 수 없으므로 고리를 한 바퀴 돌며
이웃한 빈 영역들을 합치기만 하고 값 |maxHalfword|를 돌려준다. 이 요령은 \secref{sort-avail}에서 쓴다.

@<함수들@>=
func getNode(s int32) pointer { // 가변 크기 노드 할당
	var p pointer // 지금 살피고 있는 노드
	var q pointer // 물리적으로 |p| 다음에 있는 노드
	var r int32 // 새로 할당한 노드, 또는 그 영예의 후보
	var t int32 // 임시 레지스터
restart:
	p = rover // 루프의 어떤 빈 노드에서 시작한다
	for {
		@<노드 |p|와 그 뒤의 빈 노드들에서 할당해 보고 |goto found|@>
@^inner loop@>
		p = rlink(p) // 루프의 다음 노드로 옮겨 간다
		if p == rover {
			break
		} // 목록 전체를 훑을 때까지 되풀이한다
	}
	if s == 0o10000000000 {
		return maxHalfword
	}
	if loMemMax+2 < hiMemMin {
		if loMemMax+2 <= memBot+maxHalfword {
			@<가변 크기 메모리를 늘리고 |goto restart|@>
		}
	}
	overflow("main memory size", memMax+1-memMin)
	// 미안하지만 쓸 만한 것이 남아 있지 않다
@:TeX capacity exceeded main memory size}{\quad main memory size@>
found:
	setLink(r, null) // 이 노드는 이제 비어 있지 않다
	if stat {
		varUsed += s // 사용 통계를 유지한다
	}
	return r
}

@ 메모리의 아래쪽 영역은 한 번에 1000낱말씩 자란다. 다만 바닥나기 직전이면 그보다 적게, 남은
틈의 절반씩 자란다. 자랄 때는 늘어난 부분을 새 빈 노드 하나로 만들어 빈 노드의 고리에 이어 붙이기만
하면 된다. 이렇게 조금씩 자라게 하면, \TeX을 ``가상 기억 장치'' 시스템에서 돌릴 때 |mem|에서 실제로
쓰는 부분이 한데 모여 있게 되어 도움이 된다.
@^virtual memory@>

@<가변 크기 메모리를 늘리고 |goto restart|@>=
if hiMemMin-loMemMax >= 1998 {
	t = loMemMax + 1000
} else {
	t = loMemMax + 1 + (hiMemMin-loMemMax)/2
} // |loMemMax+2<=t<hiMemMin|
p = llink(rover)
q = loMemMax
setRlink(p, q)
setLlink(rover, q)
if t > memBot+maxHalfword {
	t = memBot + maxHalfword
}
setRlink(q, rover)
setLlink(q, p)
setLink(q, emptyFlag)
setNodeSize(q, t-loMemMax)
loMemMax = t
setLink(loMemMax, null)
setInfo(loMemMax, null)
rover = q
goto restart

@ 노드 |p|에서 할당해 본다. 먼저 바로 뒤에 붙은 빈 노드들을 모두 |p|에 합친다. 그다음 |p|의
꼭대기에서 |s|낱말을 떼어 줄 수 있는지 본다. 실험해 보니 이 절의 루틴은 할당 한 번에 평균 0.75번쯤
노드를 합치고, 그 뒤 95\pct!쯤은 |r>p+1|이어서 꼭대기에서 떼어 주는 쉬운 경우였다.

@<노드 |p|와 그 뒤의...@>=
q = p + nodeSize(p) // 물리적 후계자를 찾는다
@^inner loop@>
for isEmpty(q) { // 노드 |p|와 노드 |q|를 합친다
	t = rlink(q)
	if q == rover {
		rover = t
	}
	setLlink(t, llink(q))
	setRlink(llink(q), t)
	q += nodeSize(q)
}
r = q - s
if r > p+1 {
	@<노드 |p|의 꼭대기에서 할당하고 |goto found|@>
}
if r == p {
	if rlink(p) != p {
		@<노드 |p| 전체를 할당하고 |goto found|@>
	}
}
setNodeSize(p, q-p) // 크기가 커졌을 경우에 대비해 크기를 다시 놓는다

@ 노드 |p|의 꼭대기에서 떼어 주는 경우다. 노드 |p|는 크기만 줄어든 채 고리에 남는다. 다음 할당은
여기서 찾기 시작하는 것이 좋으므로 |rover|를 |p|로 옮긴다.
@<노드 |p|의 꼭대기에서...@>=
setNodeSize(p, r-p) // 남은 크기를 저장한다
@^inner loop@>
rover = p // 다음에는 여기서 찾기 시작한다
goto found

@ 여기서는 노드 |p|를 고리에서 빼내고, |rover|는 그다음 노드로 옮긴다. 이 경우는 노드 |p|가 고리의
유일한 노드가 아닐 때만 일어난다. 고리는 결코 비면 안 되기 때문이다.

@<노드 |p| 전체를...@>=
rover = rlink(p)
t = llink(p)
setLlink(rover, t)
setRlink(t, rover)
goto found

@ 거꾸로, 어떤 가변 크기 노드 |p|가 더는 필요 없을 때 연산 |freeNode(p,s)|는 그 낱말들을 다시 쓸 수
있게 한다. 노드 |p|를 새 빈 노드로 만들어 지금 |rover|가 가리키는 노드 바로 앞에 끼워 넣는 것이다.
앞에서 말했듯이 이웃한 빈 노드와 합치는 일은 여기서 하지 않고 다음 |getNode|에 미룬다.
@^inner loop@>

@<함수들@>=
func freeNode(p pointer, s halfword) { // 가변 크기 노드의 해방
	setNodeSize(p, s)
	setLink(p, emptyFlag)
	q := llink(rover) // |llink(rover)|
	setLlink(p, q)
	setRlink(p, rover) // 두 연결을 다 놓는다
	setLlink(rover, p)
	setRlink(q, p) // |p|를 루프에 끼워 넣는다
	if stat {
		varUsed -= s // 통계를 유지한다
	}
}

@ \seclabel{sort-avail}\.{INITEX}는 메모리를 내보내기 바로 전에, 이중으로 연결된 빈 노드의 목록을 정렬한다.
그때는 이 목록이 아마 아주 짧을 것이므로 간단한 삽입 정렬을 쓴다. 정렬하고 나면 가장 작은 빈 위치는
|rover|가, 그다음으로 작은 것은 |rlink(rover)|가 가리키는 식이 된다.

@<함수들@>=
func sortAvail() { // 쓸 수 있는 가변 크기 노드들을 위치 순으로 정렬한다
	var q, r pointer // |mem|의 첨자들
	p := getNode(0o10000000000) // 이웃한 빈 영역들을 합친다
	p = rlink(rover)
	setRlink(rover, maxHalfword)
	oldRover := rover // |rover|의 처음 설정
	for p != oldRover {
		@<|p|를 |rover|의 목록에 정렬해 넣고 |p|를 나아가게 한다@>
	}
	p = rover
	for rlink(p) != maxHalfword {
		setLlink(rlink(p), p)
		p = rlink(p)
	}
	setRlink(p, rover)
	setLlink(rover, p)
}

@ 정렬하는 동안에는 |rover|에서 시작하는 목록이 |maxHalfword|로 끝난다. 그래서 다음 루프는 반드시
끝난다. 새 노드 |p|가 |rover|보다 앞이면 목록의 맨 앞에 넣고, 아니면 들어갈 자리를 찾을 때까지
목록을 따라간다.

@<|p|를 |rover|의 목록에...@>=
if p < rover {
	q = p
	p = rlink(q)
	setRlink(q, rover)
	rover = q
} else {
	q = rover
	for rlink(q) < p {
		q = rlink(q)
	}
	r = rlink(p)
	setRlink(p, rlink(q))
	setRlink(q, p)
	p = r
}

@* 상자와 그 친구들의 자료 구조.
컴퓨터의 눈으로 보면 \TeX이 하는 일의 핵심은 가로 목록과 세로 목록을 만드는 것이다. 이제 이 목록들의
원소가 동적 메모리 안에서 어떤 노드로 나타나는지 살펴보자.

가로 목록이나 세로 목록의 노드들은 저마다 첫 낱말에 있는 |link| 필드로 다음 노드와 이어진다. 노드
하나하나는 상자, 글루, 벌점, 또는 선택적 하이픈 같은 특별한 것을 나타낸다. 이렇게 종류가 여러 가지이므로
어떤 노드는 다른 노드보다 길고, 지금 보는 노드가 어떤 종류인지 가려낼 수 있어야 한다. 그래서 첫 낱말에
연결과 함께 `\ID{type}' 필드를 두고, 필요하면 `|subtype|' 필드도 둔다. 곧 모든 노드의 첫 낱말은
|link|, \ID{type}, |subtype|을 담은 |twoHalves| 꼴이다.

필드 이름 \ID{type}은 \GO/의 예약어이므로 이 필드를 읽는 함수의 이름은 |typ|이다. 쓰는 함수는 다른
필드와 같은 규칙에 따라 |setType|이다.

@<정의@>=
func typ(p pointer) quarterword       { return mem[p].hh.b0 } // 이것이 어떤 종류의 노드인지 밝힌다
func setType(p pointer, v quarterword) { mem[p].hh.b0 = v }
func subtype(p pointer) quarterword     { return mem[p].hh.b1 } // 어떤 경우의 두 번째 식별
func setSubtype(p pointer, v quarterword) { mem[p].hh.b1 = v }

@ 문자 노드 |@!charNode|는 문자 하나를 나타낸다. 상자에 든 노드의 압도적 다수가 문자 노드이므로 가장
중요한 노드다. 그래서 |charNode|가 메모리를 많이 차지하지 않도록 특별히 신경 쓴다. 이 노드는 모두 한 낱말
길이이고, 사실 이 성질로 문자 노드를 알아본다. 다른 종류의 노드는 적어도 두 낱말이어서 |mem|에서
|hiMemMin|보다 아래에만 있기 때문이다. 그러니 |charNode|에는 \ID{type} 필드가 필요 없고, 그 자리에
글꼴 |font|와 그 글꼴 안의 문자 |character|를 밝히는 두 바이트를 둘 수 있다. 결국 문자 노드 하나는
|link| 하나와 두 바이트, 곧 한 낱말로 끝난다.

문자 노드의 형식으로는 글꼴을 256개까지, 글꼴마다 문자를 256개까지 쓸 수 있다는 데 눈여겨보자. 그러나
아마 대부분의 구현은 작업 하나에 쓰는 글꼴의 수를 75개보다 적게 제한할 것이고, 대부분의 글꼴은 코드가
128보다 작은 문자만 쓸 것이다(더 높은 코드는 대부분의 자판에서 치기가 더 어렵기 때문이다).

동양 언어를 위해 \TeX을 확장한다면, 활자의 크기와 모양까지 따지면 $256\times256$보다 훨씬 많은 문자가
@^oriental characters@>@^Chinese characters@>@^Japanese characters@>
필요할 것이다. 중국어와 일본어 글꼴이라면 그런 문자를 잇닿은 |charNode| 두 개로 나타내기를 권한다. 첫째
노드는 |font=fontBase|이고 그 |link|가 둘째를 가리킨다. 둘째 노드는 글꼴과 문자의 치수를 밝힌다. 동양
문자는 다행히 대부분 상자 치수가 같다. 첫째 |charNode|의 |character| 필드에는 치수가 같은 그림 기호들을
조판할 때 서로 구별해 주는 ``\ID{charext}''를 넣는다. (\MF\ 설명서를 보라.) \TeX을 그렇게 확장하는 것은
어렵지 않을 것이다. 자세한 것은 독자에게 맡긴다.

문자 코드 |character|가 쿼터워드에 들어가도록, \TeX은 실제 코드에 |minQuarterword|를 더해서 넣는다.

문자 노드는 가로 목록에만 나오고, 세로 목록에는 결코 나오지 않는다.

필드 |font|에 쓰는 함수의 이름은 규칙대로라면 |setFont|여야 하지만, 그 이름은 이미 명령 코드가
쓰고 있다(\secref{set-font}). 그래서 이 함수만은 |setFontField|라고 부른다.

@<정의@>=
func isCharNode(p pointer) bool { return p >= hiMemMin } // 인자가 |charNode|를 가리키나?

func font(p pointer) quarterword            { return typ(p) } // |charNode|의 글꼴 코드
func setFontField(p pointer, v quarterword) { setType(p, v) }
func character(p pointer) quarterword       { return subtype(p) } // |charNode|의 문자 코드
func setCharacter(p pointer, v quarterword) { setSubtype(p, v) }

@ 노드 |hlistNode|는 가로 목록으로 만든 상자를 나타낸다. 이 노드는 일곱 낱말 길이이고 다음 필드들을
담는다(누구에게나 있는 \ID{type}과 |link|는 빼고 말한다. 다른 노드를 이야기할 때에도 이 둘은 따로 말하지
않겠다). 필드 |height|, |width|, |depth|는 상자의 치수를 나타내는 눈금 정수다. 필드 |shiftAmount|도 눈금
정수인데, 이 상자를 얼마나 내려야 하는지(가로 목록에 있을 때) 또는 오른쪽으로 얼마나 옮겨야 하는지(세로
목록에 있을 때)를 나타낸다. 명령 \.{\\raise}나 \.{\\moveright}가 바꾸는 것이 이 값이다. 필드 |listPtr|는 이
상자를 이루는 목록의 처음을 가리킨다. 이 필드가 |null|이면 빈 상자다. 마지막으로 글루를 어떻게
늘였는지 나타내는 필드가 셋 있다. 필드 |glueSet(p)|는 글루를 늘이거나 줄인 비율을 담은 |glueRatio|
낱말이다. 필드 |glueSign(p)|는 글루를 늘였는지, 줄였는지, 그대로 두었는지에 따라 |stretching|,
|shrinking|, |normal| 가운데 하나다. 필드 |glueOrder(p)|는 그 비율이 어느 차수의 무한대(|normal|, |fil|,
|fill|, |filll|)에 적용되는지 말해 준다. 이를테면 \.{\\hbox to 100pt\{\\hfil x\}}를 만들면
|glueOrder|가 |fil|이 되고, 보통의 늘이기는 무시된다. 필드 |subtype|은 쓰지 않는다.

그림의 왼쪽은 상자의 세 치수가 뜻하는 바를, 오른쪽은 이 일곱 낱말이 |mem|에 놓인 모습을 보여 준다.
상자의 기준점은 왼쪽 끝의 기준선 위에 있다. 높이는 기준선에서 위로, 깊이는 아래로 잰다.
$$\mplibcode
beginfig(4);
save w, h, d; numeric w, h, d; w := 90pt; h := 40pt; d := 14pt;
fill (0,-d)--(w,-d)--(w,h)--(0,h)--cycle withcolor .9white;
draw (0,-d)--(w,-d)--(w,h)--(0,h)--cycle;
draw (-12pt,0)--(w+12pt,0) dashed evenly;
label.lft(btex \ninepoint 기준선 etex, (-12pt,0));
fill fullcircle scaled 3pt shifted (0,0);
drawarrow (-30pt,-d-8pt)--(-2pt,-2pt);
label.lft(btex \ninepoint 기준점 etex, (-30pt,-d-8pt));
drawdblarrow (0,h+8pt)--(w,h+8pt); label.top(btex \ID{width} etex, (w/2,h+8pt));
drawdblarrow (w+8pt,0)--(w+8pt,h); label.rt(btex \ID{height} etex, (w+8pt,h/2));
drawdblarrow (w+8pt,-d)--(w+8pt,0); label.rt(btex \ID{depth} etex, (w+8pt,-d/2));
save x, r; numeric x, r; x := 180pt; r := 12pt;
for i = 0 upto 6: draw (x,-i*r)--(x+186pt,-i*r)--(x+186pt,-(i+1)*r)--(x,-(i+1)*r)--cycle; endfor
for i = 0, 5: draw (x+48pt,-i*r)--(x+48pt,-(i+1)*r); draw (x+96pt,-i*r)--(x+96pt,-(i+1)*r); endfor
def fld(expr a, b, i)(text t) = label(t, ((a+b)/2, -(i+.5)*r)) enddef;
fld(x, x+48pt, 0)(btex \eightpoint \ID{type} etex);
fld(x+48pt, x+96pt, 0)(btex \eightpoint \ID{subtype} etex);
fld(x+96pt, x+186pt, 0)(btex \eightpoint \ID{link} etex);
fld(x, x+186pt, 1)(btex \eightpoint \ID{width} etex);
fld(x, x+186pt, 2)(btex \eightpoint \ID{depth} etex);
fld(x, x+186pt, 3)(btex \eightpoint \ID{height} etex);
fld(x, x+186pt, 4)(btex \eightpoint \ID{shiftAmount} etex);
fld(x, x+48pt, 5)(btex \eightpoint \ID{glueSign} etex);
fld(x+48pt, x+96pt, 5)(btex \eightpoint \ID{glueOrder} etex);
fld(x+96pt, x+186pt, 5)(btex \eightpoint \ID{listPtr} etex);
fld(x, x+186pt, 6)(btex \eightpoint \ID{glueSet} etex);
label.lft(btex \eightpoint $p$ etex, (x, -.5r));
for i = 1 upto 6: label.lft(textext("\eightpoint $p+" & decimal i & "$"), (x,-(i+.5)*r)); endfor
endfig;
\endmplibcode$$

@<정의@>=
const (
	@!hlistNode = 0 // 가로 목록 노드의 \ID{type}
	@!boxNodeSize = 7 // 상자 노드에 할당할 낱말 수
	@!widthOffset = 1 // 상자 노드에서 |width| 필드의 위치
	@!depthOffset = 2 // 상자 노드에서 |depth| 필드의 위치
	@!heightOffset = 3 // 상자 노드에서 |height| 필드의 위치
	@!listOffset = 5 // 상자 노드에서 |listPtr| 필드의 위치
	@!normal = 0 // 여러 경우에 이름을 붙일 때 가장 흔한 경우
	@!stretching = 1 // 글루 설정이 늘이기 성분에 적용된다
	@!shrinking = 2 // 글루 설정이 줄이기 성분에 적용된다
	@!glueOffset = 6 // 상자 노드에서 |glueSet|의 위치
)

func width(p pointer) scaled              { return mem[p+widthOffset].sc } // 상자의 너비, sp 단위
func setWidth(p pointer, v scaled)       { mem[p+widthOffset].sc = v }
func depth(p pointer) scaled              { return mem[p+depthOffset].sc } // 상자의 깊이, sp 단위
func setDepth(p pointer, v scaled)       { mem[p+depthOffset].sc = v }
func height(p pointer) scaled             { return mem[p+heightOffset].sc } // 상자의 높이, sp 단위
func setHeight(p pointer, v scaled)      { mem[p+heightOffset].sc = v }
func shiftAmount(p pointer) scaled       { return mem[p+4].sc } // 자리 옮김 거리, sp 단위
func setShiftAmount(p pointer, v scaled) { mem[p+4].sc = v }
func listPtr(p pointer) pointer          { return link(p + listOffset) } // 상자 안 목록의 처음
func setListPtr(p pointer, v pointer)   { setLink(p+listOffset, v) }
func glueOrder(p pointer) quarterword    { return subtype(p + listOffset) } // 적용되는 무한대의 차수
func setGlueOrder(p pointer, v quarterword) { setSubtype(p+listOffset, v) }
func glueSign(p pointer) quarterword     { return typ(p + listOffset) } // 늘이나 줄이나
func setGlueSign(p pointer, v quarterword) { setType(p+listOffset, v) }
func glueSet(p pointer) glueRatio       { return mem[p+glueOffset].gr } // 글루 설정을 위한 형 |glueRatio|의 낱말
func setGlueSet(p pointer, v glueRatio) { mem[p+glueOffset].gr = v }

@ 함수 |newNullBox|는 모든 필드가 `\.{\\hbox\{\}}'에 해당하는 값으로 채워진 |hlistNode|를 만들어 그
포인터를 돌려준다. 곧 치수가 모두 0이고 목록이 비었으며 글루를 늘이지 않은 상자다. (|subtype| 필드는
|minQuarterword|로 놓는데, 지금은 상관없어진 옛 까닭 때문이다.)

@<함수들@>=
func newNullBox() pointer { // 새 상자 노드를 만든다
	p := getNode(boxNodeSize) // 새 노드
	setType(p, hlistNode)
	setSubtype(p, minQuarterword)
	setWidth(p, 0)
	setDepth(p, 0)
	setHeight(p, 0)
	setShiftAmount(p, 0)
	setListPtr(p, null)
	setGlueSign(p, normal)
	setGlueOrder(p, normal)
	setGlueSet(p, 0.0)
	return p
}

@ 노드 |vlistNode|는 세로 목록을 담는다는 것만 빼면 모든 점에서 |hlistNode|와 같다. 그래서 두 노드는
같은 필드 함수를 함께 쓴다.

@<정의@>=
const @!vlistNode = 1 // 세로 목록 노드의 \ID{type}

@ 노드 |ruleNode|는 속이 꽉 찬 검은 직사각형, 곧 괘선을 나타낸다. 이 노드에도 |hlistNode|처럼 |width|,
|depth|, |height| 필드가 있다. 그런데 이 치수 가운데 어느 것이 $-2^{30}$이면, 그 치수의 실제 값은 괘선을
둘러싼 가장 안쪽 상자의 경계까지 늘여서 정한다. 이것을 ``흐르는 치수''(running dimension)라고 한다.
이를테면 세로 목록에 \.{\\hrule}만 쓰면 너비가 흐르므로, 괘선은 그것을 담은 상자의 너비만큼 뻗는다.
가로 목록에서 |width|는 결코 흐르지 않고, 세로 목록에서 |height|와 |depth|는 결코 흐르지 않는다.

@<정의@>=
const (
	@!ruleNode = 2 // 괘선 노드의 \ID{type}
	@!ruleNodeSize = 4 // 괘선 노드에 할당할 낱말 수
	@!nullFlag = -0o10000000000 // $-2^{30}$, 빠진 항목을 뜻한다
)

func isRunning(d scaled) bool { return d == nullFlag } // 흐르는 치수인지 검사한다

@ 새 괘선 노드는 함수 |newRule|이 만들어 준다. 이 함수는 치수를 모두 ``흐르게'' 해 두므로, 흐르면 안
되는 치수는 부른 쪽에서 바꾸어야 한다.

@<함수들@>=
func newRule() pointer {
	p := getNode(ruleNodeSize) // 새 노드
	setType(p, ruleNode)
	setSubtype(p, 0) // |subtype|은 쓰이지 않는다
	setWidth(p, nullFlag)
	setDepth(p, nullFlag)
	setHeight(p, nullFlag)
	return p
}

@ 삽입은 |insNode| 레코드로 나타내는데, 그 |subtype|이 삽입의 상자 번호다. 이를테면
`\.{\\insert 250}'은 |subtype|이 |250+minQuarterword|인 |insNode|를 만든다. 노드 |insNode|의 |height|
필드는 이름이 좀 잘못 붙었다. 실제로는 끼워 넣을 세로 목록의 자연 높이에 깊이를 더한 값이 들어 있다.
필드 |depth|에는 이 삽입을 쪼개야 할 때 쓸 |splitMaxDepth|가 들어 있고, |splitTopPtr|는 그때 쓸
|splitTopSkip|을 가리킨다. 필드 |floatCost|에는 |floatingPenalty|가 들어 있는데, 같은 종류의 삽입이
앞서 쪼개져 있어서 이 삽입이 다음 쪽으로 떠내려갈 때 매기는 벌점이다. 필드가 하나 더 있다. 끼워 넣을
세로 목록의 처음을 가리키는 |insPtr|다. 이 값들은 모두 삽입을 만드는 순간의 매개변수에서 가져온다.
쪽 조립기가 나중에 이 삽입을 다룰 때에는 그 매개변수들이 이미 바뀌어 있을지도 모르기 때문이다.

@<정의@>=
const (
	@!insNode = 3 // 삽입 노드의 \ID{type}
	@!insNodeSize = 5 // 삽입에 할당할 낱말 수
)

func floatCost(p pointer) int32           { return mem[p+1].sc } // 쓰일 |floatingPenalty|
func setFloatCost(p pointer, v int32)    { mem[p+1].sc = v }
func insPtr(p pointer) pointer            { return info(p + 4) } // 끼워 넣을 세로 목록
func setInsPtr(p pointer, v pointer)     { setInfo(p+4, v) }
func splitTopPtr(p pointer) pointer      { return link(p + 4) } // 쓰일 |splitTopSkip|
func setSplitTopPtr(p pointer, v pointer) { setLink(p+4, v) }

@ 노드 |markNode|에는 사용자의 \.{\\mark} 텍스트를 담은 토큰 목록을 가리키는 필드 |markPtr|가 있다.
정확히는 그 목록의 참조 횟수 낱말을 가리킨다. 이 필드는 하프워드가 아니라 온 낱말을 차지한다. 다른
반쪽에 넣을 것이 없기 때문이다. 쓰지 않는 반쪽에 쓰레기가 남을 위험을 무릅쓰기보다 온 낱말을 쓰는 편이
쉽다.

@<정의@>=
const (
	@!markNode = 4 // 표시 노드의 \ID{type}
	@!smallNodeSize = 2 // 대부분의 노드 형에 할당할 낱말 수
)

func markPtr(p pointer) int32        { return mem[p+1].sc } // 표시의 토큰 목록의 머리
func setMarkPtr(p pointer, v int32) { mem[p+1].sc = v }

@ 노드 |adjustNode|는 가로 목록에만 나오는데, 바깥의 세로 목록으로 옮겨 낼 재료를 담는다. 곧 \TeX의
`\.{\\vadjust}' 연산을 구현하는 데 쓴다. 필드 |adjustPtr|는 그 재료를 담은 세로 목록을 가리킨다. 문단이
줄로 나뉘고 나면, 이 재료는 이 노드가 들어 있던 줄 바로 뒤에 놓인다.

@<정의@>=
const @!adjustNode = 5 // 조정 노드의 \ID{type}

func adjustPtr(p pointer) int32        { return markPtr(p) } // 가로 목록에서 옮겨 낼 세로 목록
func setAdjustPtr(p pointer, v int32) { setMarkPtr(p, v) }

@ 노드 |ligatureNode|는 가로 목록에만 나오는데, 실제 문자 둘 이상이 어울려 만들어 낸 문자 하나를
나타낸다. 이를테면 `\.f'와 `\.i'가 만나 `fi' 합자가 된 경우다. 노드의 둘째 낱말은 |ligChar| 낱말이라고
부르며, |charNode|처럼 |font|와 |character| 필드를 담는다. 합자를 이룬 원래 문자들도 버리지 않는다.
진단 메시지와 하이픈 넣기에 필요하기 때문이다. 필드 |ligPtr|는 그렇게 사라진 원래 문자들의 문자 노드를
엮은 연결 목록을 가리킨다. (합자를 이룬 문자들이 다른 노드에 남아 있다면 이 목록은 비어 있을 수도
있다.)

필드 |subtype|은 0이다. 다만 합자의 원래 재료에 보이지 않는 왼쪽 경계나 오른쪽 경계가 들어 있었다면
각각 2나 1을 더한다.

@<정의@>=
const @!ligatureNode = 6 // 합자 노드의 \ID{type}

func ligChar(p pointer) pointer      { return p + 1 } // 합자가 들어 있는 낱말
func ligPtr(p pointer) pointer       { return link(ligChar(p)) } // 문자들의 목록
func setLigPtr(p pointer, v pointer) { setLink(ligChar(p), v) }

@ 함수 |newLigature|는 |font|, |character|, |ligPtr| 필드를 주어진 값으로 채운 합자 노드를 만든다.
함수 |newLigItem|도 있는데, 이것은 |character| 필드만 주어진 값으로 채운 두 낱말짜리 노드를 돌려준다.
이런 노드는 합자를 만드는 도중에 잠시 쓰는 재료다.

@<함수들@>=
func newLigature(f, c quarterword, q pointer) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, ligatureNode)
	setFontField(ligChar(p), f)
	setCharacter(ligChar(p), c)
	setLigPtr(p, q)
	setSubtype(p, 0)
	return p
}

func newLigItem(c quarterword) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setCharacter(p, c)
	setLigPtr(p, null)
	return p
}

@ 노드 |discNode|는 가로 목록에만 나오는데, ``선택적''(discretionary) 줄 나눔을 나타낸다. 노드 |p|에서
줄을 나누기로 하면, |preBreak(p)|에서 시작하는 텍스트가 나눔 앞에, |postBreak(p)|에서 시작하는 텍스트가
나눔 뒤에 오고, 뒤따르는 |replaceCount(p)|개의 노드에 든 텍스트는 버린다. 나누지 않으면 거꾸로 앞의 두
텍스트를 버리고 뒤따르는 노드들을 그대로 쓴다. 이를테면 `\.{\\-}'로 넣는 보통의 선택적 하이픈은
|preBreak|가 하이픈을 담은 |charNode|를 가리키고 |postBreak=null|이며 |replaceCount=0|인 |discNode|가
된다. 독일어의 `\.{ck}'처럼 나눌 때 글자가 바뀌는 경우에는 |replaceCount|가 쓸모 있다. 세 가지 선택적
텍스트는 모두 문자, 커닝, 상자, 괘선, 합자 노드로만 이루어진 목록이어야 한다.

나눔 앞 텍스트가 없으면(|preBreak(p)=null|) 여기서 나눌 때 |exHyphenPenalty|를, 그렇지 않으면
|hyphenPenalty|를 매긴다. 줄 나누기 알고리즘이 여기서 나누기로 정하면 그 텍스트들이 실제로 목록에
들어가고, 선택적 나눔 노드 자체는 사라진다. 그러므로 출력 루틴에 이르는 선택적 나눔 노드는 모두 나누지
않기로 한 것들뿐이다.

@<정의@>=
const @!discNode = 7 // 선택적 나눔 노드의 \ID{type}

func replaceCount(p pointer) quarterword       { return subtype(p) } // 뒤따르는 노드 가운데 몇 개를 바꿀지
func setReplaceCount(p pointer, v quarterword) { setSubtype(p, v) }
func preBreak(p pointer) pointer               { return llink(p) } // 선택적 나눔 앞에 오는 텍스트
func setPreBreak(p pointer, v pointer)        { setLlink(p, v) }
func postBreak(p pointer) pointer              { return rlink(p) } // 선택적 나눔 뒤에 오는 텍스트
func setPostBreak(p pointer, v pointer)       { setRlink(p, v) }

@ 함수 |newDisc|는 빈 선택적 나눔 노드를 만든다. 세 텍스트가 모두 비어 있으므로, 이 노드에서 나누어도
아무것도 끼어들지 않는다.

@<함수들@>=
func newDisc() pointer { // 빈 |discNode|를 만든다
	p := getNode(smallNodeSize) // 새 노드
	setType(p, discNode)
	setReplaceCount(p, 0)
	setPreBreak(p, null)
	setPostBreak(p, null)
	return p
}

@ 노드 |whatsitNode|는 \TeX을 확장하려는 사람을 위해 남겨 둔 만능 패다. 첫 낱말의 |subtype| 필드가 이
노드가 어떤 `\ID{whatsit}'인지 말해 주고, 그에 따라 노드의 크기(2 이상이어야 한다)와 나머지 낱말의
형식이 정해진다. 목록에서 |whatsitNode|를 만나면 그 종류에 맞는 특별한 일을 한다. \TeX의 나머지 부분을
망가뜨리지 않도록 조심할 줄 아는 사람이라면 프로그램의 끝에 코드를 덧붙여 \TeX이 새로운 일을 하게 만들 수
있다. 이를테면 잉크 색을 바꾸는 `\TeX nicolor' 확장을 만든다면, 원하는 색을 whatsit 노드에 매개변수로
@^extensions to \TeX@>
담아 두면 될 것이다.

지금의 \TeX\ 구현은 그런 루틴을 어떻게 짜는지 보여 주려고, `\.{\\write}'와 `\.{\\special}'에 관련된
기능을 마치 확장인 것처럼 다룬다. 확장 이야기는 이 프로그램의 끝으로 미룬다.

@<정의@>=
const @!whatsitNode = 8 // 특별한 확장 노드의 \ID{type}

@ 노드 |mathNode|는 가로 목록에만 나오는데, 문단 안의 수식 앞과 뒤에 하나씩 놓인다. 필드 |subtype|은
수식 앞에서는 |before|이고 수식 뒤에서는 |after|다. 필드 |width|에는 \.{\\mathsurround}가 넣은, 수식
둘레의 간격이 들어 있다. 줄 나누기 알고리즘은 이 노드를 보고 수식의 시작과 끝을 안다.

@<정의@>=
const (
	@!mathNode = 9 // 수식 노드의 \ID{type}
	@!before = 0 // 수식을 여는 수식 노드의 |subtype|
	@!after = 1 // 수식을 닫는 수식 노드의 |subtype|
)

@ 함수 |newMath|는 너비가 |w|이고 |subtype|이 |s|인 수식 노드를 만든다.

@<함수들@>=
func newMath(w scaled, s smallNumber) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, mathNode)
	setSubtype(p, s)
	setWidth(p, w)
	return p
}

@ 지금까지 나온 |hlistNode|, |vlistNode|, |ruleNode|, |insNode|, |markNode|, |adjustNode|,
|ligatureNode|, |discNode|, |whatsitNode|, |mathNode|는 형 코드의 아래쪽 끝을 차지한다. \TeX은 이
사실을 써먹는다. 글루에서는, 목록에서 그 바로 앞 노드의 \ID{type}이 |mathNode|보다 작을 때, 그리고
오직 그때에만 나눌 수 있다. 또 나눔 바로 뒤에서는 형이 |mathNode| 이상인 노드(글루, 커닝, 벌점 따위)를
버린다. 그래서 줄의 처음에는 글루가 남지 않는다. 형 코드의 차례는 이렇게 일부러 정한 것이다.

@<정의@>=
func precedesBreak(p pointer) bool  { return typ(p) < mathNode }
func nonDiscardable(p pointer) bool { return typ(p) < mathNode }

@ 노드 |glueNode|는 목록 안의 글루를 나타낸다. 그러나 이 노드는 실은 따로 있는 글루 명세를 가리키는
포인터일 뿐이다. 본질적으로 똑같은 글루 노드가 여럿 있는 일이 흔하므로 \TeX은 명세 하나를 함께 쓰게
한다. 이를테면 문단의 낱말 사이 공백은 모두 같은 글루 명세를 가리킨다. 포인터 |p|가 |glueNode|를
가리키면 |gluePtr(p)|는 늘이기와 줄이기 성분 따위를 담은 다른 낱말 묶음을 가리킨다.

글루 노드는 리더(leaders)를 나타내는 데에도 쓴다. 필드 |subtype|으로 보통의 글루(|normal|이라고
부른다)와 세 가지 리더(|aLeaders|, |cLeaders|, |xLeaders|라고 부른다)를 구별한다. 필드 |leaderPtr|는
리더로 되풀이할 괘선 노드나 상자 노드를 가리킨다. 보통의 글루 노드에서는 |null|이다.

글루는 \TeX의 ``skip'' 매개변수에서 나오는 것이 많은데, 어떤 글루 노드가 어느 매개변수에서 왔는지
알면 쓸모가 있다. 이를테면 \.{\\showbox}가 \.{\\glue(\\baselineskip)}처럼 출처를 밝혀 찍을 수 있다.
그래서 글루가 매개변수에서 왔으면 |subtype|에 그 출처를 적어 둔다. 매개변수 번호의 기호 이름은 나중에
정의한다(이를테면 |lineSkipCode=0|, |baselineSkipCode=1| 따위). 지금은 매개변수 글루의 |subtype|이
매개변수 번호에 1을 더한 값이라고만 알아 두면 충분하다.

수식에서는 글루 노드의 |subtype|이 두 가지 더 있다. 그 가운데 |muGlue|는 \.{\\mskip}을 나타내고(이때
단위는 눈금 \.{pt}가 아니라 눈금 \.{mu}다), |condMathGlue|는 `\.{\\nonscript}' 기능, 곧 첨자 크기의
수식에서 바로 다음 글루 노드를 없애는 기능을 나타낸다.

@<정의@>=
const (
	@!glueNode = 10 // 글루 명세를 가리키는 노드의 \ID{type}
	@!condMathGlue = 98 // 다음 노드의 글루를 억누르는 특별한 |subtype|
	@!muGlue = 99 // 수식 글루의 |subtype|
	@!aLeaders = 100 // 정렬된 리더의 |subtype|
	@!cLeaders = 101 // 가운데 맞춘 리더의 |subtype|
	@!xLeaders = 102 // 펼친 리더의 |subtype|
)

func gluePtr(p pointer) pointer         { return llink(p) } // 글루 명세를 가리키는 포인터
func setGluePtr(p pointer, v pointer)  { setLlink(p, v) }
func leaderPtr(p pointer) pointer       { return rlink(p) } // 리더를 위한 상자나 괘선 노드를 가리키는 포인터
func setLeaderPtr(p pointer, v pointer) { setRlink(p, v) }

@ 글루 명세의 첫 낱말에는 하프워드 참조 횟수가 있다. 이 값은 |null|에 그 명세를 가리키는 글루 노드의
@^reference counts@>
수에서 하나를 뺀 것을 더한 값이다. 그러니 참조가 하나뿐이면 |null|이다. 참조 횟수가 목록 노드의 |link|
필드와 같은 자리에 있다는 데 눈여겨보자. 이 자리는 노드를 할당할 때 |null|로 채워지는 필드이고, 빈 노드에
|emptyFlag|를 적어 두는 필드이기도 하다. 그래서 새로 할당한 명세는 참조가 하나인 명세가 된다.

글루 명세에는 |width|, |stretch|, |shrink| 치수를 담는 |scaled| 필드도 셋 있다. 마지막으로 한 바이트짜리
필드 |stretchOrder|와 |shrinkOrder|가 있는데, 늘이기와 줄이기 값이 어느 차수의 무한대(|normal|, |fil|,
|fill|, |filll|)인지 담는다. 이를테면 \.{\\hskip 3pt plus 1fil minus 2pt}는 |width|가 3\,pt,
|stretch|가 |unity|, |stretchOrder|가 |fil|, |shrink|가 2\,pt, |shrinkOrder|가 |normal|인 명세가 된다.

@<전역 형@>=
const (
	@!glueSpecSize = 4 // 글루 명세에 할당할 낱말 수
	@!fil = 1 // 1차 무한대
	@!fill = 2 // 2차 무한대
	@!filll = 3 // 3차 무한대
)

func glueRefCount(p pointer) halfword         { return link(p) } // 글루 명세의 참조 횟수
func setGlueRefCount(p pointer, v halfword)  { setLink(p, v) }
func stretch(p pointer) scaled                  { return mem[p+2].sc } // 이 글루 덩어리의 늘어남
func setStretch(p pointer, v scaled)           { mem[p+2].sc = v }
func shrink(p pointer) scaled                   { return mem[p+3].sc } // 이 글루 덩어리의 줄어듦
func setShrink(p pointer, v scaled)            { mem[p+3].sc = v }
func stretchOrder(p pointer) quarterword       { return typ(p) } // 늘이기의 무한대 차수
func setStretchOrder(p pointer, v quarterword) { setType(p, v) }
func shrinkOrder(p pointer) quarterword        { return subtype(p) } // 줄이기의 무한대 차수
func setShrinkOrder(p pointer, v quarterword) { setSubtype(p, v) }

type @!glueOrd = int32 // 무한대의 0, 1, 2, 3제곱; |normal..filll|

@ 다음은 글루 명세를 복제하고 그 사본을 가리키는 포인터를 돌려주는 함수다. 사본의 참조 횟수는 |null|이다.
새 명세를 가리키는 곳은 꼭 하나뿐이라고 보기 때문이다. 글루 명세는 여럿이 함께 쓰므로, 명세를 고치려면
이렇게 먼저 복제해서 자기만의 사본을 만들어야 한다.

@<함수들@>=
func newSpec(p pointer) pointer { // 글루 명세를 복제한다
	q := getNode(glueSpecSize) // 새 명세
	mem[q] = mem[p]
	setGlueRefCount(q, null)
	setWidth(q, width(p))
	setStretch(q, stretch(p))
	setShrink(q, shrink(p))
	return q
}

@ 다음은 번호로 지정한 매개변수의 글루 노드를 만드는 함수다. 이를테면 지금의 \.{\\lineskip}을 나타내는
글루 노드는 |newParamGlue(lineSkipCode)|로 얻는다. 명세는 매개변수가 가리키는 것을 그대로 함께 쓰고,
참조 횟수만 하나 늘린다.

@<함수들@>=
func newParamGlue(n smallNumber) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, glueNode)
	setSubtype(p, n+1)
	setLeaderPtr(p, null)
	q := @<글루 매개변수 번호 |n|의 현재 |mem| 등가물@> // 글루 명세
	setGluePtr(p, q)
	setGlueRefCount(q, glueRefCount(q)+1)
	return p
}

@ 이름이 딱히 없는(매개변수에서 오지 않은) 글루 노드는 함수 |newGlue|가 만든다. 그 인자는 글루 명세를
가리킨다. 이 함수도 명세의 참조 횟수를 하나 늘린다.

@<함수들@>=
func newGlue(q pointer) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, glueNode)
	setSubtype(p, normal)
	setLeaderPtr(p, null)
	setGluePtr(p, q)
	setGlueRefCount(q, glueRefCount(q)+1)
	return p
}

@ 서브루틴이 하나 더 필요하다. 함수 |newParamGlue|와 |newGlue|를 섞어 놓은 셈이다. 현재의 글루 매개변수 하나로
글루 노드를 만들되, 글루 명세는 새로 복제한다. 매개변수에서 왔다는 표시는 남기지만, 명세는 곧 고쳐 쓸
것이기 때문이다. 이를테면 줄 사이 간격을 계산할 때 \.{\\baselineskip}의 너비에서 실제 높이와 깊이를
빼야 한다. 전역 변수 |tempPtr|에는 새 명세의 주소가 남는다.

여기서도 이름 있는 절의 값을 |newSpec|의 인자 자리에 바로 쓰지 않고, 먼저 |tempPtr|에
받는다(\secref{print-char}).

@<함수들@>=
func newSkipParam(n smallNumber) pointer {
	tempPtr = newSpec(@<글루 매개변수 번호 |n|의...@>)
	p := newGlue(tempPtr) // 새 노드
	setGlueRefCount(tempPtr, null)
	setSubtype(p, n+1)
	return p
}

@ 노드 |kernNode|에는 (대개 음수인) 간격의 양을 담는 |width| 필드가 있다. 글꼴 설계자가 A와 V 같은 글자
사이를 더 좁히거나 더 띄우는 편이 보기 좋다고 정해 두었을 때, 가로 목록의 글자 사이에 이 노드가 들어간다.
커닝 노드는 세로 목록에도 나올 수 있는데, 그때 `|width|'는 세로 방향으로 더 띄울 간격이다. 커닝은
글루와 달리 늘거나 줄지 않는다. 커닝의 |subtype|은 |normal|(글꼴 정보나 수식 계산에서 넣은 커닝),
|explicit|(\.{\\kern}과 \.{\\/} 명령으로 넣은 커닝), |accKern|(수식이 아닌 악센트에서 넣은 커닝),
|muGlue|(수식의 \.{\\mkern}으로 넣은 커닝) 가운데 하나다.

@<정의@>=
const (
	@!kernNode = 11 // 커닝 노드의 \ID{type}
	@!explicit = 1 // \.{\\kern}과 \.{\\/}에서 온 커닝 노드의 |subtype|
	@!accKern = 2 // 악센트에서 온 커닝 노드의 |subtype|
)

@ 함수 |newKern|은 너비가 주어진 커닝 노드를 만든다.

@<함수들@>=
func newKern(w scaled) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, kernNode)
	setSubtype(p, normal)
	setWidth(p, w)
	return p
}

@ 노드 |penaltyNode|는 줄 나누기나 쪽 나누기에 매기는 벌점을 |penalty| 필드에 담는다. 이 필드는 온 낱말
정수이지만 정수 값의 범위를 다 쓰지는 않는다. 값이 |>=10000|인 벌점은 무한대로 보아서 그런 곳에서는
결코 나누지 않는다. 마찬가지로 |<=-10000|인 벌점은 음의 무한대로 보아서 반드시 나눈다. 이를테면
\.{\\penalty10000}은 줄을 나누지 못하게 막고, \.{\\penalty-10000}은 거기서 억지로 줄을 나눈다.

@<정의@>=
const (
	@!penaltyNode = 12 // 벌점 노드의 \ID{type}
	@!infPenalty = infBad // ``무한한'' 벌점 값
	@!ejectPenalty = -infPenalty // ``음으로 무한한'' 벌점 값
)

func penalty(p pointer) int32        { return mem[p+1].sc } // 여기서 목록을 나누는 데 드는 추가 비용
func setPenalty(p pointer, v int32) { mem[p+1].sc = v }

@ 앞의 몇 절을 읽었다면 다음에 무엇이 올지 짐작할 수 있을 것이다.

@<함수들@>=
func newPenalty(m int32) pointer {
	p := getNode(smallNodeSize) // 새 노드
	setType(p, penaltyNode)
	setSubtype(p, 0) // |subtype|은 쓰이지 않는다
	setPenalty(p, m)
	return p
}

@ 이제 노드의 종류는 다 나왔다고 생각할지도 모르겠다. 글쎄, 거의 다 나왔지만 하나가 더 있다. 노드
|unsetNode|는 형식이 |hlistNode|나 |vlistNode|와 거의 같다. 이 노드는 \.{\\halign}이나 \.{\\valign}의 항목
가운데 아직 마지막 꼴이 정해지지 않은 것에 쓴다. 열의 너비가 다 정해지기 전에는 상자의 치수가 글루를
늘이거나 줄이기 전의 ``자연'' 크기일 뿐이기 때문이다. 낱말 |glueSet| 대신 |glueStretch| 필드가 있는데,
상자로 만들 가로 목록이나 세로 목록에서 차수가 |glueOrder|인 늘어남을 모두 더한 값이 들어 있다.
마찬가지로 |shiftAmount| 필드 대신 |glueShrink| 필드가 있는데, 차수가 |glueSign|인 줄어듦의 합계가
들어 있다. 필드 |subtype|은 |spanCount|라고 부른다. 미정 상자는 대개 열 |qo(spanCount)+1|개에 걸친
자료를 담는다. 정렬이 끝나면 미정 노드는 상자 노드로 바뀐다.

필드 |glueStretch(p)|와 |glueSet(p)|는 같은 낱말을 서로 다른 변형으로 쓰는 것이다. 미정 노드가 상자 노드로
바뀔 때 |glueSet|이 새로 정해지고, 그 뒤로는 |glueStretch|를 읽는 일이 없으므로 낱말을 이렇게 함께
써도 된다(\secref{memory-word}).

@<정의@>=
const @!unsetNode = 13 // 미정 노드의 \ID{type}

func glueStretch(p pointer) scaled              { return mem[p+glueOffset].sc } // 미정 노드의 늘어남 합계
func setGlueStretch(p pointer, v scaled)       { mem[p+glueOffset].sc = v }
func glueShrink(p pointer) scaled               { return shiftAmount(p) } // 미정 노드의 줄어듦 합계
func setGlueShrink(p pointer, v scaled)        { setShiftAmount(p, v) }
func spanCount(p pointer) quarterword           { return subtype(p) } // 걸친 열의 수를 나타낸다
func setSpanCount(p pointer, v quarterword)    { setSubtype(p, v) }

@ 사실 노드의 형은 더 있다. 수식 처리에 이르면 |styleNode|의 \ID{type}이 14라는 것을 보게 된다. 그리고
수식 모드에서만 쓰는, 더 큰 형 코드도 여럿 정의할 것이다.

@ 경고: 이 자료 구조의 배치를 조금이라도 바꾸면, 이를테면 노드의 크기를 바꾸거나 노드 안의 낱말 순서만
바꾸어도, 프로시저 |copyNodeList|와 뒤에 나오는 메모리 초기화 코드를 고쳐야 할 수 있다. 이렇게 위험할
수 있는 곳들은 찾아보기의 `data structure assumptions' 항목에 모아 두었다.
@!@^data structure assumptions@>
그 밖의 곳에서는 노드를 모두 위에서 정의한 필드 함수의 이름으로만 다루므로, 형식을 바꾸어도 \TeX의
다른 알고리즘들은 끄떡없다.
@^system dependencies@>

@* 메모리의 배치.
배열 |mem|의 몇몇 자리는 처음부터 용도를 정해 둔다. 그래도 되는 것이라면 정적으로 할당하는 편이 동적으로
할당하는 것보다 효율적이기 때문이다. 이를테면 |memBot|부터 |memBot+3|까지의 네 낱말에는 언제나
`\.{0pt plus 0pt minus 0pt}'인 글루의 명세가 들어 있다. 이런 글루는 아주 자주 쓰므로, 필요할 때마다
새로 만들지 않고 이 명세를 함께 쓰면 된다. 다음 상수 정의들은 이렇게 정해 둔 자리에 기호 이름을 붙여
정적 할당을 해낸다. 정적인 가변 크기 노드는 |memBot|부터 |loMemStatMax|까지에, 정적인 한 낱말짜리
노드는 |hiMemStatMin|부터 |memTop|까지(양 끝 포함)에 있다. 두 위치 |ligTrick|과 |garbage|는 |mem|의
같은 자리를 함께 써도 해가 없다. 둘 다 잠깐 쓰고 버리는 자리이고, 동시에 쓰이는 일이 없기 때문이다.

@<정의@>=
const (
	@!zeroGlue = memBot // \.{0pt plus 0pt minus 0pt}의 명세
	@!filGlue = zeroGlue + glueSpecSize // \.{0pt plus 1fil minus 0pt}
	@!fillGlue = filGlue + glueSpecSize // \.{0pt plus 1fill minus 0pt}
	@!ssGlue = fillGlue + glueSpecSize // \.{0pt plus 1fil minus 1fil}
	@!filNegGlue = ssGlue + glueSpecSize // \.{0pt plus -1fil minus 0pt}
	@!loMemStatMax = filNegGlue + glueSpecSize - 1 // 가변 크기 |mem|에서
	@t\qquad@>// 정적으로 할당된 가장 큰 낱말
	@#
	@!pageInsHead = memTop // 현재 쪽의 삽입 자료 목록
	@!contribHead = memTop - 1 // 아직 현재 쪽에 들어가지 않은 항목들의 세로 목록
	@!pageHead = memTop - 2 // 현재 쪽의 세로 목록
	@!tempHead = memTop - 3 // 어떤 종류의 임시 목록의 머리
	@!holdHead = memTop - 4 // 다른 종류의 임시 목록의 머리
	@!adjustHead = memTop - 5 // |hpack|이 돌려주는 조정 목록의 머리
	@!active = memTop - 7 // |lineBreak|의 활성 목록의 머리; 두 낱말이 필요하다
	@!alignHead = memTop - 8 // 정렬의 서문 목록의 머리
	@!endSpan = memTop - 9 // 걸친 너비 목록들의 꼬리
	@!omitTemplate = memTop - 10 // 상수 토큰 목록
	@!nullList = memTop - 11 // 영원히 빈 목록
	@!ligTrick = memTop - 12 // |charNode|로 가장한 합자
	@!garbage = memTop - 12 // 쓰레기 정보에 쓴다
	@!backupHead = memTop - 13 // |scanKeyword|가 만든 토큰 목록의 머리
	@!hiMemStatMin = memTop - 13 // 한 낱말짜리 |mem|에서
	@t\qquad@>// 정적으로 할당된 가장 작은 낱말
	@!hiMemStatUsage = 14 // 언제나 있는 한 낱말짜리 노드의 수
)

@ 다음 코드는 \TeX이 느린~방법으로(곧 \.{INITEX}로서) 스스로를 초기화할 때 |mem|을 쓸 만한 상태로
만들어 둔다. 여기서 쓰는 첨자 변수 |k|는 다른 표를 초기화할 때에도 쓴다.

@<초기화를 위한 지역 변수@>=
var @!k int32 // |mem|, |eqtb| 따위의 첨자

@ 먼저 아래쪽의 정적 영역에 글루 명세 다섯 개를 채운다. 참조 횟수는 |null+1|로 둔다. 어디에서도
가리키지 않을 때조차 이 명세들이 해제되지 않게 하려는 것이다. 그 바로 위에는 1000낱말짜리 빈 노드
하나를 두어 가변 크기 영역의 고리를 만든다. 위쪽에서는 목록 머리들을 비우고, 한 낱말짜리 영역은
아직 빈 노드가 하나도 없는 상태에서 시작한다. 마지막으로 통계를 초기화한다.
@<표의 항목들을 초기화한다...@>=
for k = memBot + 1; k <= loMemStatMax; k++ {
	mem[k].sc = 0
} // 글루 치수는 모두 0으로 놓는다
@^data structure assumptions@>
k = memBot
for k <= loMemStatMax { // 글루 명세들의 첫 낱말을 놓는다
	setGlueRefCount(k, null+1)
	setStretchOrder(k, normal)
	setShrinkOrder(k, normal)
	k += glueSpecSize
}
setStretch(filGlue, unity)
setStretchOrder(filGlue, fil)
setStretch(fillGlue, unity)
setStretchOrder(fillGlue, fill)
setStretch(ssGlue, unity)
setStretchOrder(ssGlue, fil)
setShrink(ssGlue, unity)
setShrinkOrder(ssGlue, fil)
setStretch(filNegGlue, -unity)
setStretchOrder(filNegGlue, fil)
rover = loMemStatMax + 1
setLink(rover, emptyFlag) // 이제 동적 메모리를 초기화한다
setNodeSize(rover, 1000) // 그것은 1000낱말짜리 빈 노드다
setLlink(rover, rover)
setRlink(rover, rover)
loMemMax = rover + 1000
setLink(loMemMax, null)
setInfo(loMemMax, null)
for k = hiMemStatMin; k <= memTop; k++ {
	mem[k] = mem[loMemMax]
} // 목록의 머리들을 비운다
@<특별한 목록 머리와 상수 노드들을 초기화한다@>
avail = null
memEnd = memTop
hiMemMin = hiMemStatMin // 한 낱말짜리 메모리를 초기화한다
varUsed = loMemStatMax + 1 - memBot
dynUsed = hiMemStatUsage // 통계를 초기화한다

@ \TeX을 잘못 확장하면 배열 |mem|이 엉망이 될 수도 있다. 이를테면 어떤 포인터가 틀렸거나, ``죽은''
노드가 마지막 참조가 사라졌는데도 해제되지 않았을 수도 있다. 그런 문제를 진단하는 데 쓰라고 프로시저
|checkMem|과 |searchMem|을 마련해 둔다. 이 프로시저들은 |free|와 |wasFree|라는 두 배열을 쓰는데, 이
배열들은 \TeX의 디버깅 루틴들만 쓴다. (디버깅하는 동안에는 |mem|의 크기를 줄여 두는 편이 나을 수도
있다.)
@^debugging@>

@<전역 변수@>=
var @!free [memMax + 1]bool // 빈 칸들
var @!wasFree [memMax + 1]bool // 앞서 비어 있던 칸들
var @!wasMemEnd, @!wasLoMax, @!wasHiMin pointer
	// 앞서의 |memEnd|, |loMemMax|, |hiMemMin|
var @!panicking bool // 메모리를 끊임없이 검사하고 싶은가?

@ 처음에는 모든 것이 비어 있었던 것으로 해 둔다. 그래야 처음 |checkMem|을 부를 때 쓰고 있는 위치가 모두
``새로 바빠진'' 위치로 찍힌다.
@<핵심 변수들의...@>=
if debug {
	wasMemEnd = memMin // 모든 것이 앞서 비어 있었다고 표시한다
	wasLoMax = memMin
	wasHiMin = memMax
	panicking = false
}

@ 프로시저 |checkMem|은 |mem|의 빈 공간 목록들이 올바른 꼴인지 확인한다. 원하면, 지난번에 이 프로시저를
불렀을 때는 비어 있었지만 지금은 쓰고 있는 위치들을 모두 찍어 준다. 메모리가 새는 곳을 찾을 때 쓸모
있다. 일하는 방식은 단순하다. 먼저 배열 |free|를 모두 거짓으로 놓고, 두 빈 공간 목록을 따라가면서
지나가는 위치마다 참으로 표시한다. 그러다 이미 표시한 곳을 다시 만나거나 범위를 벗어나면 목록이 망가진
것이다.

@<함수들@>=
func checkMem(printLocs bool) {
	var p, q pointer // |mem|에서 지금 관심 있는 위치들
	var clobbered bool // 무언가 잘못되었나?
	for p = memMin; p <= loMemMax; p++ {
		free[p] = false
	} // 아마 이것을 더 빨리 할 수 있을 것이다
	for p = hiMemMin; p <= memEnd; p++ {
		free[p] = false
	} // 마찬가지
	@<한 낱말짜리 |avail| 목록을 검사한다@>
	@<가변 크기 |avail| 목록을 검사한다@>
	@<쓸 수 없는 노드들의 표시를 검사한다@>
	if printLocs {
		@<새로 바빠진 위치들을 찍는다@>
	}
	for p = memMin; p <= loMemMax; p++ {
		wasFree[p] = free[p]
	}
	for p = hiMemMin; p <= memEnd; p++ {
		wasFree[p] = free[p]
	} // |wasFree=free|가 더 빠를 수도 있다
	wasMemEnd = memEnd
	wasLoMax = loMemMax
	wasHiMin = hiMemMin
}

@ 한 낱말짜리 빈 노드의 목록을 따라간다. 노드가 한 낱말짜리 영역 바깥에 있거나 한 번 지나간 곳을 다시
지나가면, 그 직전의 노드 |q|에서 목록이 망가진 것이다.
@<한 낱말짜리...@>=
p = avail
q = null
clobbered = false
for p != null {
	if p > memEnd || p < hiMemMin {
		clobbered = true
	} else if free[p] {
		clobbered = true
	}
	if clobbered {
		printNl("AVAIL list clobbered at ")
@.AVAIL list clobbered...@>
		printInt(q)
		goto done1
	}
	free[p] = true
	q = p
	p = link(q)
}
done1:

@ 가변 크기 빈 노드의 고리를 따라간다. 노드마다 빈 노드 표시가 있는지, 크기가 알맞은지, 이중 연결이 서로
맞는지 보고, 그 노드가 차지하는 위치를 모두 비었다고 표시한다. 두 빈 노드가 겹치면 같은 위치를 두 번
표시하게 되므로 그것도 알아낼 수 있다.
@<가변 크기 |avail| 목록을 검사한다@>=
p = rover
q = null
clobbered = false
for {
	if p >= loMemMax || p < memMin {
		clobbered = true
	} else if rlink(p) >= loMemMax || rlink(p) < memMin {
		clobbered = true
	} else if !isEmpty(p) || nodeSize(p) < 2 ||
		p+nodeSize(p) > loMemMax || llink(rlink(p)) != p {
		clobbered = true
	}
	if clobbered {
		printNl("Double-AVAIL list clobbered at ")
		printInt(q)
		goto done2
	}
	for q = p; q <= p+nodeSize(p)-1; q++ { // 모든 위치를 비었다고 표시한다
		if free[q] {
			printNl("Doubly free location at ")
@.Doubly free location...@>
			printInt(q)
			goto done2
		}
		free[q] = true
	}
	q = p
	p = rlink(p)
	if p == rover {
		break
	}
}
done2:

@ 이번에는 가변 크기 영역을 처음부터 끝까지 훑으며, 쓰고 있는 노드의 첫 낱말에 빈 노드 표시
|emptyFlag|가 잘못 들어 있지 않은지 본다. 쓰고 있는 덩어리와 빈 덩어리를 번갈아 건너뛰므로, 쓰고 있는
덩어리의 맨 앞 낱말만 검사하게 된다.
@<쓸 수 없는 노드들의...@>=
p = memMin
for p <= loMemMax { // 노드 |p|는 비어 있으면 안 된다
	if isEmpty(p) {
		printNl("Bad flag at ")
		printInt(p)
@.Bad flag...@>
	}
	for p <= loMemMax && !free[p] {
		p++
	}
	for p <= loMemMax && free[p] {
		p++
	}
}

@ 지금은 쓰고 있지만 지난번에는 비어 있었거나 아직 영역 밖이던 위치를 모두 찍는다.
@<새로 바빠진...@>=
printNl("New busy locs:")
for p = memMin; p <= loMemMax; p++ {
	if !free[p] && (p > wasLoMax || wasFree[p]) {
		printChar(' ')
		printInt(p)
	}
}
for p = hiMemMin; p <= memEnd; p++ {
	if !free[p] &&
		(p < wasHiMin || p > wasMemEnd || wasFree[p]) {
		printChar(' ')
		printInt(p)
	}
}

@ 프로시저 |searchMem|은 ``누가 노드~|p|를 가리키나?''라는 물음에 답하려 한다. 그러려고 |mem|의 모든
낱말의 |link|와 |info| 필드를 읽는데, 그 가운데에는 형이 |twoHalves|가 아닌 낱말도 있다. 그런 낱말의
|hh| 필드에는 아무 뜻 없는 값이 들어 있을 수 있으므로 ``헛걸림''(순전히 우연히 |p|를 가리키는 것처럼
보이는 낱말)이 생길 수 있다. 그러나 디버깅할 때 정말 알고 싶은 것은 |p|를 가리키지 {\sl 않는\/} 곳이므로,
헛걸림이 조금 섞여 나와도 참을 만하다. 그 밖에 |eqtb|와 저장 스택과 하이픈 예외 목록에서도 |p|를
가리키는 곳을 찾는다.

@<함수들@>=
func searchMem(p pointer) { // |p|를 가리키는 포인터들을 찾는다
	var q int32 // 지금 찾고 있는 위치
	for q = memMin; q <= loMemMax; q++ {
		if link(q) == p {
			printNl("LINK(")
			printInt(q)
			printChar(')')
		}
		if info(q) == p {
			printNl("INFO(")
			printInt(q)
			printChar(')')
		}
	}
	for q = hiMemMin; q <= memEnd; q++ {
		if link(q) == p {
			printNl("LINK(")
			printInt(q)
			printChar(')')
		}
		if info(q) == p {
			printNl("INFO(")
			printInt(q)
			printChar(')')
		}
	}
	@<|eqtb|에서 |p|와 같은 등가물을 찾는다@>
	@<|saveStack|에서 |p|를 가리키는 등가물을 찾는다@>
	@<|hyphList|에서 |p|를 가리키는 포인터를 찾는다@>
}

@* 상자 보이기.
방금 들여온 자료 구조를 머릿속에 단단히 새기려면, 목록을 기호로 찍어 보이는 두 프로시저를 살펴보는 것이
좋다. 첫째 |shortDisplay|는 ``꽉 찬 상자''(overfull box) 같은 메시지에서 목록의 맨 위 수준을 대강
보여 줄 때 쓴다. 둘째 |showNodeList|는 자료 구조에 무엇이 들어 있는지 하나하나 자세히 찍는다.
명령 \.{\\showbox}나 \.{\\showlists}를 쓰면 보게 되는 것이 바로 이 프로시저의 출력이다.

프로시저 |shortDisplay|의 방침은 상자 안에 정확히 무엇이 들었는지 같은 세세한 것은 무시하되, 합자와
선택적 나눔만은 펼쳐 보이는 것이다. 그래서 |shortDisplay|는 재귀 프로시저이지만, 재귀는 결코 한 단계보다
깊어지지 않는다. 합자나 선택적 나눔 안에는 다시 합자나 선택적 나눔이 들어 있지 않기 때문이다.
@^recursion@>

전역 변수 |fontInShortDisplay|에는 |shortDisplay|가 시작할 때의 글꼴 코드가 들어 있다. 문자를 찍다가
글꼴이 이것과 달라지면 그 글꼴의 이름을 찍는다. 그래서 출력은 `\.{\\tenrm Hello \\tenit world}'처럼
글꼴이 바뀌는 곳에만 글꼴 이름이 끼어든다.

@<전역 변수@>=
var @!fontInShortDisplay int32 // 내부 글꼴 번호

@ 상자, 괘선, 삽입, whatsit, 표시, 그리고 대체로 ``복잡한'' 것들은 `\.{[]}'를 찍어서 나타내기만 한다.
문자는 글자 그대로 찍는다. 이 프로시저는 망가진 포인터를 만나도 무너지지 않도록, |memEnd|보다 큰
문자 노드는 그냥 건너뛴다.

@<함수들@>=
func shortDisplay(p int32) { // 목록 |p|의 두드러진 점을 찍는다
	var n int32 // 바꿈 횟수를 위해
	for p > memMin {
		if isCharNode(p) {
			if p <= memEnd {
				if font(p) != fontInShortDisplay {
					if font(p) < fontBase || font(p) > fontMax {
						printChar('*')
@.*\relax@>
					} else {
						@<|font(p)|의 글꼴 식별자를 찍는다@>
					}
					printChar(' ')
					fontInShortDisplay = font(p)
				}
				printASCII(qo(character(p)))
			}
		} else {
			@<노드 |p|의 내용을 짧게 나타내어 찍는다@>
		}
		p = link(p)
	}
}

@ 그 밖의 노드는 이렇게 짧게 나타낸다. 괘선은 `\.{\char'174}', 수식의 시작과 끝은 `\.\$', 크기가 0이
아닌 글루는 공백 하나로 찍는다. 합자는 그것을 이룬 원래 문자들을 찍고, 선택적 나눔은 나눔 앞과
뒤의 텍스트를 찍은 다음, 나누지 않을 때의 텍스트 |replaceCount|개는 건너뛴다. 그래야 줄이 실제로 나뉜
모습과 비슷해진다. 커닝이나 벌점은 아무것도 찍지 않는다.
@<노드 |p|의 내용을 짧게...@>=
switch typ(p) {
case hlistNode, vlistNode, insNode, whatsitNode, markNode, adjustNode,
	unsetNode:
	printStr("[]")
case ruleNode:
	printChar('|')
case glueNode:
	if gluePtr(p) != zeroGlue {
		printChar(' ')
	}
case mathNode:
	printChar('$')
case ligatureNode:
	shortDisplay(ligPtr(p))
case discNode:
	shortDisplay(preBreak(p))
	shortDisplay(postBreak(p))
	n = replaceCount(p)
	for n > 0 {
		if link(p) != null {
			p = link(p)
		}
		n--
	}
default:
	// 아무것도 하지 않는다
}

@ 루틴 |showNodeList|에는 보조 서브루틴이 몇 개 필요하다. 글꼴과 문자의 짝을 찍는 것, 토큰 목록을
참조 횟수 없이 찍는 것, 괘선의 치수를 찍는 것이다. 흐르는 치수는 `\.*'로 찍는다. 이 서브루틴들도
포인터가 이상하면 `\.{\\CLOBBERED.}'를 찍고 지나간다.

@<함수들@>=
func printFontAndChar(p int32) { // |charNode|의 자료를 찍는다
	if p > memEnd {
		printEsc("CLOBBERED.")
	} else {
		if font(p) < fontBase || font(p) > fontMax {
			printChar('*')
@.*\relax@>
		} else {
			@<|font(p)|의 글꼴 식별자를...@>
		}
		printChar(' ')
		printASCII(qo(character(p)))
	}
}

func printMark(p int32) { // 토큰 목록의 자료를 중괄호 안에 찍는다
	printChar('{')
	if p < hiMemMin || p > memEnd {
		printEsc("CLOBBERED.")
	} else {
		showTokenList(link(p), null, maxPrintLine-10)
	}
	printChar('}')
}

func printRuleDimen(d scaled) { // 괘선 노드의 치수를 찍는다
	if isRunning(d) {
		printChar('*')
	} else {
		printScaled(d)
	}
@.*\relax@>
}

@ 그다음은 글루의 늘어남이나 줄어듦을 찍는 서브루틴이다. 무한대 차수가 있으면 `\.{fil}', `\.{fill}',
`\.{filll}'을 붙이고, 유한한 값이면 단위의 이름을 붙일 수도 있다. 차수가 이상한 값이면 `\.{foul}'을
찍는다.

단위의 이름 |s|는 \GO/ 문자열 상수이고, 빈 문자열이면 단위 이름을 찍지 않는다는 뜻이다. 다음 절의
|printSpec|도 마찬가지다.

@<함수들@>=
func printGlue(d scaled, order int32, s string) { // 글루 성분 하나를 찍는다
	printScaled(d)
	if order < normal || order > filll {
		printStr("foul")
	} else if order > normal {
		printStr("fil")
		for order > fil {
			printChar('l')
			order--
		}
	} else if s != "" {
		printStr(s)
	}
}

@ 다음 서브루틴은 글루 명세 전체를 `\.{3.0pt plus 1.0fil minus 2.0pt}' 같은 꼴로 찍는다. 늘어남이나
줄어듦이 0이면 그 부분은 찍지 않는다.

@<함수들@>=
func printSpec(p int32, s string) { // 글루 명세를 찍는다
	if p < memMin || p >= loMemMax {
		printChar('*')
@.*\relax@>
	} else {
		printScaled(width(p))
		if s != "" {
			printStr(s)
		}
		if stretch(p) != 0 {
			printStr(" plus ")
			printGlue(stretch(p), stretchOrder(p), s)
		}
		if shrink(p) != 0 {
			printStr(" minus ")
			printGlue(shrink(p), shrinkOrder(p), s)
		}
	}
}

@ 이 문서의 뒤에 가서야 나오는 프로시저도 몇 개 선언해 두어야 한다.

@<함수들@>=
@<수식 목록의 원소들을 보이는 데 필요한 프로시저들을 선언한다@>
@<|printSkipParam|이라는 프로시저를 선언한다@>

@ 상자 안에 상자가 들어 있을 수 있으므로 |showNodeList|는 본래 재귀적이다. 다만 정해 둔 깊이까지만
@^recursion@>
내려간다. 지금 얼마나 깊이 들어와 있는지는 현재 문자열(아직 만드는 중인 문자열)에 적어 두고, 그것을
줄마다 맨 앞에 찍는다. 이 문자열의 길이, 곧 |curLength|가 중첩의 깊이다. 이를테면 상자 안의 상자에 든
문자는 다음처럼 마침표 두 개를 앞세워 찍힌다.
$$\vbox{\halign{\.{#}\hfil\cr
{}\\hbox(6.94444+0.0)x20.0\cr
.\\hbox(6.94444+0.0)x10.0\cr
..\\tenrm A\cr}}$$
그러므로 |showNodeList|를 재귀로 부를 때는 다음과 같은 꼴을 쓴다. 마침표를 하나 덧붙이고 부른 다음,
돌아오면 그 마침표를 지운다.

@<함수들@>=
func nodeListDisplay(p int32) {
	appendChar('.')
	showNodeList(p)
	flushChar()
} // |strRoom|은 검사하지 않아도 된다; 아래의 |showBox|를 보라

@ 전역 변수 |depthThreshold|에는 |showNodeList|가 정보를 보여 줄 중첩 깊이의 최댓값이 들어 있다. 이를테면
|depthThreshold=0|이면 맨 위 수준만 보여 주고 그 아래 목록은 하나도 훑지 않는다. 또 하나의 전역 변수
|breadthMax|는 수준마다 보여 줄 항목의 최대 개수다. 이 값은 양수여야 한다. 그렇지 않으면 아무것도
볼 수 없을 것이다. 두 값은 사용자가 \.{\\showboxdepth}와 \.{\\showboxbreadth}로 정한다.

@<전역 변수@>=
var @!depthThreshold int32 // 상자 보이기에서 중첩 깊이의 최댓값
var @!breadthMax int32 // 같은 목록 수준에서 보여 줄 항목의 최대 개수

@ 이제 |showNodeList| 자체를 볼 차례다. 이 프로시저는 ``아주 튼튼하게'' 짰다. 프로그램의 다른 곳에 있는
버그 때문에 자료 구조가 엉망이 되었더라도 무너지거나 끝없는 루프에 빠지지 않는다는 뜻이다. 그래서
\TeX을 디버깅할 때에는 그 부모 루틴 |showBox(p)|를 |p|의 아무 값으로나 안심하고 부를 수 있다. 다만
자료가 망가져 있으면 이 프로시저는 저장할 때와 다른 변형으로 |memoryWord|를 읽을 수도 있다. 이를테면
@^debugging@>
|p|가 망가진 포인터이거나 아무렇게나 고른 값이라면, |mem[p]|에는 눈금 정수가 들어 있는데 |mem[p].hh|를
읽으려 들 수도 있다. 범위를 벗어난 포인터를 만나면 `\.{Bad link, display aborted.}'를 찍고 그만두고,
한 수준에서 |breadthMax|개를 넘게 찍었으면 `\.{etc.}'를 찍고 그만둔다.

@<함수들@>=
func showNodeList(p int32) { // 노드 목록을 기호로 찍는다
	var n int32 // 이 수준에서 이미 찍은 항목의 수
	var g float64 // 부동 소수점 수로 나타낸 글루 비율
	if curLength() > depthThreshold {
		if p > null {
			printStr(" []")
		} // 잘라 냈음을 나타낸다
		return
	}
	n = 0
	for p > memMin {
		printLn()
		printCurrentString() // 중첩의 내력을 보인다
		if p > memEnd { // 범위를 벗어난 포인터
			printStr("Bad link, display aborted.")
			return
@.Bad link...@>
		}
		n++
		if n > breadthMax { // 멈출 때다
			printStr("etc.")
			return
@.etc@>
		}
		@<노드 |p|를 보인다@>
		p = link(p)
	}
}

@ 노드의 종류에 따라 찍는 방식이 다르다. 문자 노드는 글꼴과 문자를 찍고, 나머지는 \ID{type}을 보고 저마다
알맞은 절로 간다.
@<노드 |p|를 보인다@>=
if isCharNode(p) {
	printFontAndChar(p)
} else {
	switch typ(p) {
	case hlistNode, vlistNode, unsetNode:
		@<상자 |p|를 보인다@>
	case ruleNode:
		@<괘선 |p|를 보인다@>
	case insNode:
		@<삽입 |p|를 보인다@>
	case whatsitNode:
		@<whatsit 노드 |p|를 보인다@>
	case glueNode:
		@<글루 |p|를 보인다@>
	case kernNode:
		@<커닝 |p|를 보인다@>
	case mathNode:
		@<수식 노드 |p|를 보인다@>
	case ligatureNode:
		@<합자 |p|를 보인다@>
	case penaltyNode:
		@<벌점 |p|를 보인다@>
	case discNode:
		@<선택적 나눔 노드 |p|를 보인다@>
	case markNode:
		@<표시 |p|를 보인다@>
	case adjustNode:
		@<조정 |p|를 보인다@>
	@<수식 목록에서만 생기는 |showNodeList|의 경우들@>
	default:
		printStr("Unknown node type!")
	}
}

@ 상자는 `\.{\\hbox(6.94444+1.94444)x50.0, glue set 2.5}'처럼 높이와 깊이와 너비를 찍고, 글루를 늘이거나
줄였으면 그 비율을, 자리를 옮겼으면 그 거리를 덧붙인다. 그다음 상자 안의 목록을 한 단계 깊이 찍는다.
@<상자 |p|를 보인다@>=
if typ(p) == hlistNode {
	printEsc("h")
} else if typ(p) == vlistNode {
	printEsc("v")
} else {
	printEsc("unset")
}
printStr("box(")
printScaled(height(p))
printChar('+')
printScaled(depth(p))
printStr(")x")
printScaled(width(p))
if typ(p) == unsetNode {
	@<미정 노드 |p|의 특별한 필드들을 보인다@>
} else {
	@<|glueSet(p)|의 값을 보인다@>
	if shiftAmount(p) != 0 {
		printStr(", shifted ")
		printScaled(shiftAmount(p))
	}
}
nodeListDisplay(listPtr(p)) // 재귀 호출

@ 미정 노드에서는 글루 비율 대신, 걸친 열의 수와 늘어남과 줄어듦의 합계를 찍는다.
@<미정 노드 |p|의 특별한...@>=
if spanCount(p) != minQuarterword {
	printStr(" (")
	printInt(qo(spanCount(p)) + 1)
	printStr(" columns)")
}
if glueStretch(p) != 0 {
	printStr(", stretch ")
	printGlue(glueStretch(p), glueOrder(p), "")
}
if glueShrink(p) != 0 {
	printStr(", shrink ")
	printGlue(glueShrink(p), glueSign(p), "")
}

@ 형 |glueRatio|가 보통의 실수가 아니라 구조체라면 여기의 코드를 바꾸어야 할 것이다. 이 루틴은
|glueSet| 필드에 엉뚱한 값이 들어 있더라도 산술 오류를 일으키지 않아야 한다는 데 눈여겨보자. 같은 낱말을
실수로도 정수로도 읽을 수 있는 구현이라면, 제대로 된 0 아닌 실수를 정수로 읽었을 때 절댓값이 $2^{20}$
이상이라고 가정하고, 그보다 작으면 `\.{?.?}'를 찍으면 된다. 저자의 컴퓨터에서는 이 정도 예방책으로
부동 소수점 아래넘침을 충분히 막을 수 있었다. 그러나 \GO/의 부동 소수점 연산은 아래넘침이나 넘침이
일어나도 멈추지 않으므로, 여기서는 값이 수가 아닐 때(NaN)에만 `\.{?.?}'를 찍는다. 비율이 너무 크면
`\.{>20000.0}'처럼 줄여 찍는다.
@^system dependencies@>

@<|glueSet(p)|의 값을...@>=
g = float(glueSet(p))
if g != floatConstant(0) && glueSign(p) != normal {
	printStr(", glue set ")
	if glueSign(p) == shrinking {
		printStr("- ")
	}
	if math.IsNaN(g) {
		printStr("?.?")
	} else if math.Abs(g) > floatConstant(20000) {
		if g > floatConstant(0) {
			printChar('>')
		} else {
			printStr("< -")
		}
		printGlue(20000*unity, glueOrder(p), "")
	} else {
		printGlue(round(unity*g), glueOrder(p), "")
	}
@^real multiplication@>
}

@ 괘선은 `\.{\\rule(0.4+0.0)x*}'처럼 찍는다. 흐르는 치수는 `\.*'로 나타난다.
@<괘선 |p|를...@>=
printEsc("rule(")
printRuleDimen(height(p))
printChar('+')
printRuleDimen(depth(p))
printStr(")x")
printRuleDimen(width(p))

@ 삽입은 상자 번호와 자연 크기, 쪼갤 때 쓸 글루와 최대 깊이, 떠내려갈 때의 벌점을 찍고, 끼워 넣을 세로
목록을 한 단계 깊이 찍는다.
@<삽입 |p|를...@>=
printEsc("insert")
printInt(qo(subtype(p)))
printStr(", natural size ")
printScaled(height(p))
printStr("; split(")
printSpec(splitTopPtr(p), "")
printChar(',')
printScaled(depth(p))
printStr("); float cost ")
printInt(floatCost(p))
nodeListDisplay(insPtr(p)) // 재귀 호출

@ 글루는 `\.{\\glue(\\baselineskip) 2.5}'처럼 찍는다. 매개변수에서 온 글루라면 괄호 안에 그 매개변수의
이름을 밝히고, 그다음에 글루 명세를 찍는다. 수식의 \.{\\mskip}은 단위를 `\.{mu}'로 찍는다.
@<글루 |p|를...@>=
if subtype(p) >= aLeaders {
	@<리더 |p|를 보인다@>
} else {
	printEsc("glue")
	if subtype(p) != normal {
		printChar('(')
		if subtype(p) < condMathGlue {
			printSkipParam(subtype(p) - 1)
		} else if subtype(p) == condMathGlue {
			printEsc("nonscript")
		} else {
			printEsc("mskip")
		}
		printChar(')')
	}
	if subtype(p) != condMathGlue {
		printChar(' ')
		if subtype(p) < condMathGlue {
			printSpec(gluePtr(p), "")
		} else {
			printSpec(gluePtr(p), "mu")
		}
	}
}

@ 리더는 `\.{\\leaders}', `\.{\\cleaders}', `\.{\\xleaders}' 가운데 하나와 글루 명세를 찍고, 되풀이할 상자나
괘선을 한 단계 깊이 찍는다.
@<리더 |p|를...@>=
printEsc("")
if subtype(p) == cLeaders {
	printChar('c')
} else if subtype(p) == xLeaders {
	printChar('x')
}
printStr("leaders ")
printSpec(gluePtr(p), "")
nodeListDisplay(leaderPtr(p)) // 재귀 호출

@ 커닝은 `\.{\\kern}' 뒤에 너비를 찍는다. 그 사이에 공백이 하나 있으면 ``명시적'' 커닝이라는 뜻이다.
곧 \.{\\kern 2.0}은 \.{\\kern}이나 \.{\\/}로 넣은 커닝이고, 공백 없는 \.{\\kern-0.27779}는 글꼴이 넣은
커닝이다. 이렇게 공백 하나로 둘을 슬쩍 구별한다.

@<커닝 |p|를...@>=
if subtype(p) != muGlue {
	printEsc("kern")
	if subtype(p) != normal {
		printChar(' ')
	}
	printScaled(width(p))
	if subtype(p) == accKern {
		printStr(" (for accent)")
	}
@.for accent@>
} else {
	printEsc("mkern")
	printScaled(width(p))
	printStr("mu")
}

@ 수식 노드는 `\.{\\mathon}'이나 `\.{\\mathoff}'로 찍고, \.{\\mathsurround}가 있으면 그 너비를 덧붙인다.
@<수식 노드 |p|를...@>=
printEsc("math")
if subtype(p) == before {
	printStr("on")
} else {
	printStr("off")
}
if width(p) != 0 {
	printStr(", surrounded ")
	printScaled(width(p))
}

@ 합자는 `\.{\\tenrm \^\^L (ligature fi)}'처럼, 합자 문자를 먼저 찍고 괄호 안에 원래 문자들을 찍는다.
보이지 않는 왼쪽 경계나 오른쪽 경계가 합자에 끼어 있었으면, 괄호 안의 앞이나 뒤에 `\.{\char'174}'를 찍어
알린다.
@<합자 |p|를...@>=
printFontAndChar(ligChar(p))
printStr(" (ligature ")
if subtype(p) > 1 {
	printChar('|')
}
fontInShortDisplay = font(ligChar(p))
shortDisplay(ligPtr(p))
if odd(subtype(p)) {
	printChar('|')
}
printChar(')')

@ 벌점은 `\.{\\penalty 10000}'처럼 찍는다.
@<벌점 |p|를...@>=
printEsc("penalty ")
printInt(penalty(p))

@ 선택적 나눔 노드의 |postBreak| 목록은 |preBreak| 목록처럼 `\..'를 앞에 붙이지 않고 `\.{\char'174}'를
앞에 붙여 찍는다. 그래서 두 목록을 한눈에 구별할 수 있다.

@<선택적 나눔 노드 |p|를...@>=
printEsc("discretionary")
if replaceCount(p) > 0 {
	printStr(" replacing ")
	printInt(replaceCount(p))
}
nodeListDisplay(preBreak(p)) // 재귀 호출
appendChar('|')
showNodeList(postBreak(p))
flushChar() // 재귀 호출

@ 표시는 `\.{\\mark}' 뒤에 그 토큰 목록을 중괄호에 싸서 찍는다.
@<표시 |p|를...@>=
printEsc("mark")
printMark(markPtr(p))

@ 조정은 `\.{\\vadjust}' 뒤에 옮겨 낼 세로 목록을 한 단계 깊이 찍는다.
@<조정 |p|를...@>=
printEsc("vadjust")
nodeListDisplay(adjustPtr(p)) // 재귀 호출

@ 재귀 장치는 |showBox|를 불러서 시동한다. 사용자가 정한 깊이와 너비의 한계를 가져오고, 너비가
양수가 아니면 5로 둔다. 또 중첩을 적어 둘 현재 문자열이 문자열 풀을 넘치지 않도록 깊이의 한계를 줄여
둔다. 그래서 |nodeListDisplay|는 |strRoom|으로 검사하지 않고 마침표를 덧붙여도 된다.
@^recursion@>

@<함수들@>=
func showBox(p pointer) {
	@<|depthThreshold|와 |breadthMax|의 값을 정한다@>
	if breadthMax <= 0 {
		breadthMax = 5
	}
	if poolPtr+depthThreshold >= poolSize {
		depthThreshold = poolSize - poolPtr - 1
	} // 이제 접두 문자열을 위한 자리가 넉넉하다
	showNodeList(p) // 보이기는 |p|에서 시작한다
	printLn()
}

@* 상자 없애기.
노드 목록을 다 쓰고 나면, 그 안에 든 하위 목록까지 모두 빈 저장 공간으로 돌려주어야 한다. 이 일은 재귀
프로시저 |flushNodeList|가 맡는다. 상자 안에는 다시 목록이 있고, 그 목록 안에 또 상자가 있을 수 있으므로
재귀로 하는 것이 자연스럽다.

@ 그러나 그 전에, 더 간단한 일을 하는 비재귀 프로시저 둘을 살펴보자. 첫째 |deleteTokenRef|는 토큰 목록을
가리키던 참조 하나가 없어질 때 부른다. 참조 횟수가 |null|이었다면 그것이 마지막 참조였으므로 토큰 목록을
통째로 없애고, 그렇지 않으면 횟수를 하나 줄인다. 참조 횟수는 토큰 목록의 맨 앞 노드에 들어 있다.
@^reference counts@>

@<함수들@>=
func tokenRefCount(p pointer) halfword        { return info(p) } // 토큰 목록 앞의 참조 횟수
func setTokenRefCount(p pointer, v halfword) { setInfo(p, v) }

func deleteTokenRef(p pointer) { // |p|는 참조 하나를 잃는 토큰 목록의 참조 횟수를 가리킨다
	if tokenRefCount(p) == null {
		flushList(p)
	} else {
		setTokenRefCount(p, tokenRefCount(p)-1)
	}
}

@ 마찬가지로 |deleteGlueRef|는 글루 명세를 가리키던 포인터 하나를 거두어들일 때 부른다. 그 몸통인
|fastDeleteGlueRef|는 \TeX의 안쪽 루프에서 바로 부르기도 한다.
@^reference counts@>

@<함수들@>=
func fastDeleteGlueRef(p pointer) {
	if glueRefCount(p) == null {
		freeNode(p, glueSpecSize)
	} else {
		setGlueRefCount(p, glueRefCount(p)-1)
	}
}

func deleteGlueRef(p pointer) { // |p|는 글루 명세를 가리킨다
	fastDeleteGlueRef(p)
}

@ 이제 어떤 노드 목록이든 재귀로 지울 준비가 되었다. 실제로 지우는 노드는 대개 문자 노드이고(3분의 2쯤),
나머지의 절반쯤은 글루 노드다. 그래서 문자 노드를 가장 먼저 검사하고, 크기가 |smallNodeSize|인 흔한
노드는 맨 끝에서 한꺼번에 해제한다.
@^recursion@>

@<함수들@>=
func flushNodeList(p pointer) { // |p|에서 시작하는 노드 목록을 지운다
	var q pointer // 노드 |p|의 후계자
	for p != null {
@^inner loop@>
		q = link(p)
		if isCharNode(p) {
			freeAvail(p)
		} else {
			@<노드 형에 따라 하위 목록을 지우거나, 노드를 해제하고 |goto done|@>
			freeNode(p, smallNodeSize)
		done:
		}
		p = q
	}
}

@ 앞 절의 |switch| 문이다. 노드마다 먼저 그 노드가 가리키는 하위 목록이나 토큰 목록이나 글루 명세를
놓아준다. 크기가 |smallNodeSize|가 아닌 노드는 여기서 해제하고 |done|으로 간다. 나머지는 앞 절에서
|freeNode(p,smallNodeSize)|로 해제한다.

@<노드 형에 따라 하위 목록을...@>=
switch typ(p) {
case hlistNode, vlistNode, unsetNode:
	flushNodeList(listPtr(p))
	freeNode(p, boxNodeSize)
	goto done
case ruleNode:
	freeNode(p, ruleNodeSize)
	goto done
case insNode:
	flushNodeList(insPtr(p))
	deleteGlueRef(splitTopPtr(p))
	freeNode(p, insNodeSize)
	goto done
case whatsitNode:
	@<whatsit 노드 |p|를 지우고 |goto done|@>
case glueNode:
	fastDeleteGlueRef(gluePtr(p))
	if leaderPtr(p) != null {
		flushNodeList(leaderPtr(p))
	}
case kernNode, mathNode, penaltyNode:
	// 아무것도 하지 않는다
case ligatureNode:
	flushNodeList(ligPtr(p))
case markNode:
	deleteTokenRef(markPtr(p))
case discNode:
	flushNodeList(preBreak(p))
	flushNodeList(postBreak(p))
case adjustNode:
	flushNodeList(adjustPtr(p))
@<수식 목록에서만 생기는 |flushNodeList|의 경우들@>
default:
	confusion("flushing")
@:this can't happen flushing}{\quad flushing@>
}

@* 상자 베끼기.
상자를 다루는 재귀 연산이 하나 더 필요할 때가 있다. 프로시저 |copyNodeList|는 원래 목록과 짜임새도 뜻도
똑같은 새 노드 목록을 만들어 그 포인터를 돌려준다. 이를테면 \.{\\copy}가 이 연산을 쓴다. 글루 명세와
토큰 목록에는 참조 횟수가 있으므로 그것들은 베낄 필요 없이 참조 횟수만 늘리면 된다는 데 눈여겨보자.
참조 횟수가 하프워드에 담지 못할 만큼 커질 걱정도 없다. 노드를 가리키는 포인터는 저마다 다른 메모리
주소에 들어 있고, 메모리 주소의 총수는 하프워드에 들어가기 때문이다.
@^recursion@>
@^reference counts@>

(글쎄, 사실은 |mem| 바깥에서 오는 참조도 있다. 스택 |saveStack|을 터무니없이 크게 만들면 이론상 참조 횟수를
넘치게 해서 \TeX을 망가뜨릴 수도 있을 것이다. 그러나 누가 그러고 싶겠는가?)

@<함수들@>=
func addTokenRef(p pointer) { setTokenRefCount(p, tokenRefCount(p)+1) } // 토큰 목록에 대한 새 참조
func addGlueRef(p pointer)  { setGlueRefCount(p, glueRefCount(p)+1) } // 글루 명세에 대한 새 참조

@ 베끼는 프로시저는 낱말들을 필드 하나하나 들여다보지 않고 통째로 베낀다. 그러니 노드의 형식이 바뀌면,
이를테면 크기가 달라지거나 어떤 연결 필드의 자리가 옮겨지면 이 코드도 고쳐야 할 수 있다. 새 목록은 임시
머리 노드 |h| 뒤에 하나씩 이어 붙이고, 다 만들면 머리 노드를 버린다. 머리 노드를 두면 첫 노드를 따로
다루지 않아도 된다.
@^data structure assumptions@>

@<함수들@>=
func copyNodeList(p pointer) pointer { // |p|에서 시작하는 노드 목록의 복제를 만들고
	@t\qquad@>// 새 목록을 가리키는 포인터를 돌려준다
	var r pointer // 새 목록을 위해 지금 만들고 있는 노드
	var words int32 // 아직 베낄 낱말의 수; |0..5|
	h := getAvail() // 베낀 목록의 임시 머리
	q := h // 새 목록에서 앞의 위치
	for p != null {
		@<노드 |p|의 사본을 노드 |r|에 만든다@>
		setLink(q, r)
		q = r
		p = link(p)
	}
	setLink(q, null)
	q = link(h)
	freeAvail(h)
	return q
}

@ 노드 |p|를 베낀다. 먼저 노드 형에 따라 새 노드 |r|를 얻고, 하위 목록처럼 따로 베껴야 하는 것을
처리한다. 그다음 남은 낱말 |words|개를 앞에서부터 통째로 베낀다. 첫 낱말에는 |link|와 \ID{type}과
|subtype|이 들어 있는데, |link|는 나중에 고쳐 쓰므로 함께 베껴도 상관없다.
@<노드 |p|의 사본을...@>=
words = 1 // 이 설정이 다른 어느 것보다 많은 갈래에서 쓰인다
if isCharNode(p) {
	r = getAvail()
} else {
	@<형에 따라 베끼고 |words|를 정하는 |case| 문@>
}
for words > 0 {
	words--
	mem[r+words] = mem[p+words]
}

@ 형에 따라 새 노드를 얻고, 따로 베껴야 할 부분을 처리한다. 상자라면 안의 목록을 재귀로 베끼고, 글루라면
명세를 함께 쓰도록 참조 횟수를 늘리며, 리더가 있으면 그것도 베낀다. 남은 낱말 수 |words|는 이렇게 따로
처리하지 않은 앞쪽 낱말들의 수다.

이 프로그램에는 짧은 문장 몇 개를 쌍반점으로 이어 한 줄에 쓴 곳이 많다. 이 절도 그렇다. \.{gtangle}이
만든 \.{.go} 파일에 \.{gofmt}를 돌리면 이것들은 한 줄에 하나씩으로 풀린다.

@<형에 따라 베끼고...@>=
switch typ(p) {
case hlistNode, vlistNode, unsetNode:
	r = getNode(boxNodeSize)
	mem[r+6] = mem[p+6]; mem[r+5] = mem[p+5] // 마지막 두 낱말을 베낀다
	setListPtr(r, copyNodeList(listPtr(p))) // 이것은 |mem[r+5]|에 영향을 준다
	words = 5
case ruleNode:
	r = getNode(ruleNodeSize); words = ruleNodeSize
case insNode:
	r = getNode(insNodeSize); mem[r+4] = mem[p+4]
	addGlueRef(splitTopPtr(p))
	setInsPtr(r, copyNodeList(insPtr(p))) // 이것은 |mem[r+4]|에 영향을 준다
	words = insNodeSize - 1
case whatsitNode:
	@<whatsit 노드 |p|의 부분 사본 |r|를 만들고 |words|를 정한다@>
case glueNode:
	r = getNode(smallNodeSize); addGlueRef(gluePtr(p))
	setGluePtr(r, gluePtr(p))
	setLeaderPtr(r, copyNodeList(leaderPtr(p)))
case kernNode, mathNode, penaltyNode:
	r = getNode(smallNodeSize); words = smallNodeSize
case ligatureNode:
	r = getNode(smallNodeSize)
	mem[ligChar(r)] = mem[ligChar(p)] // |font|와 |character|를 베낀다
	setLigPtr(r, copyNodeList(ligPtr(p)))
case discNode:
	r = getNode(smallNodeSize)
	setPreBreak(r, copyNodeList(preBreak(p)))
	setPostBreak(r, copyNodeList(postBreak(p)))
case markNode:
	r = getNode(smallNodeSize); addTokenRef(markPtr(p)); words = smallNodeSize
case adjustNode:
	r = getNode(smallNodeSize)
	setAdjustPtr(r, copyNodeList(adjustPtr(p)))
	// |words=1=smallNodeSize-1|
default:
	confusion("copying")
@:this can't happen copying}{\quad copying@>
}

@* 명령 코드.
더 나아가기 전에, \TeX이 따르는 여러 명령을 나타내는 내부 코드 번호에 기호 이름을 붙여 두어야 한다. 이
번호들은 어느 정도는 마음대로 정했지만 다 그런 것은 아니다. 이를테면 문자의 종류를 나타내는 명령 코드는
\TeX\ 언어가 정해 둔 것이다. 사용자가 `\.{\\catcode \char'140\\\${} = 3}'이라고 해서 \.{\char'44}를 수식
전환 문자로 만들 수 있는 것은 명령 코드 |mathShift|가 3이기 때문이다. 또 몇몇 코드는 일부러 서로 이웃하게
두었다. 그러면 프로그램의 |switch| 문이 멀리 떨어진 경우들까지 따지지 않아도 되고, 때로는 |switch| 문을
`|if curCmd<=x|' 같은 |if| 문으로 바꿀 수도 있다.

어쨌든 나중에 찾아볼 수 있도록 목록을 여기 모두 보인다. 먼저 ``catcode'' 명령들이 온다. 이 가운데 몇몇
번호는, \TeX의 훑기 루틴이 그 catcode를 결코 내놓지 않는 상황에서 보통 명령에도 함께 쓴다. 이를테면
catcode 0인 탈출 문자는 훑개를 지나면 사라지므로, 번호 0을 \.{\\relax}에도 쓸 수 있다.

@<정의@>=
const (
	@!escape = 0 // 탈출 구분자({\sl The \TeX book}에서는 \.\\라고 부른다)
@^TeXbook@>
	@!relax = 0 // 아무것도 하지 않는다( \.{\\relax} )
	@!leftBrace = 1 // 그룹의 시작( \.\{ )
	@!rightBrace = 2 // 그룹의 끝( \.\} )
	@!mathShift = 3 // 수식 전환 문자( \.\$ )
	@!tabMark = 4 // 정렬 구분자( \.\&, \.{\\span} )
	@!carRet = 5 // 줄의 끝( |carriageReturn|, \.{\\cr}, \.{\\crcr} )
	@!outParam = 5 // 매크로 매개변수를 출력한다
	@!macParam = 6 // 매크로 매개변수 기호( \.\# )
	@!supMark = 7 // 위첨자( \.{\char'136} )
	@!subMark = 8 // 아래첨자( \.{\char'137} )
	@!ignore = 9 // 무시할 문자( \.{\^\^@@} )
	@!endv = 9 // 정렬 틀에서 \<v_j> 목록의 끝
	@!spacer = 10 // 공백과 같은 문자( \.{\ } )
	@!letter = 11 // 글자로 여기는 문자( \.{A..Z}, \.{a..z} )
	@!otherChar = 12 // 특별한 문자 형이 아닌 것
	@!activeChar = 13 // 매크로를 부르는 문자( \.{\char`\~} )
	@!parEnd = 13 // 문단의 끝( \.{\\par} )
	@!match = 13 // 매크로 매개변수에 맞춘다
	@!comment = 14 // 주석을 시작하는 문자( \.\% )
	@!endMatch = 14 // 매크로 매개변수들의 끝
	@!stop = 14 // 작업의 끝( \.{\\end}, \.{\\dump} )
	@!invalidChar = 15 // 나타나면 안 되는 문자( \.{\^\^?} )
	@!delimNum = 15 // 구분자를 수로 지정한다( \.{\\delimiter} )
	@!maxCharCode = 15 // 낱낱의 문자를 위한 가장 큰 catcode
)

@ 다음은 여느 명령 코드들이다. 이 장의 명령 코드는 모두 같은 규칙을 따른다. 주석에는 그 코드를 쓰는 대표
명령을 괄호 안에 적어 두었다. 같은 명령 코드를 나누어 쓰는 명령들은 나중에 정할 수정자 값 |chrCode|로
가린다. 이를테면 \.{\\hskip}과 \.{\\hfil}은 둘 다 명령 코드가 |hskip|이다. 값이 |minInternal| 이상인
코드는 `\.{\\the}'로 펼칠 수 있는 내부 양을 나타낸다.

@<정의@>=
const (
	@!charNum = 16 // 수로 지정한 문자( \.{\\char} )
	@!mathCharNum = 17 // 명시적 수식 코드( \.{\\mathchar} )
	@!mark = 18 // 표시 정의( \.{\\mark} )
	@!xray = 19 // \TeX\ 속을 들여다본다( \.{\\show}, \.{\\showbox} 따위 )
	@!makeBox = 20 // 상자를 만든다( \.{\\box}, \.{\\copy}, \.{\\hbox} 따위 )
	@!hmove = 21 // 가로 이동( \.{\\moveleft}, \.{\\moveright} )
	@!vmove = 22 // 세로 이동( \.{\\raise}, \.{\\lower} )
	@!unHbox = 23 // 상자를 푼다( \.{\\unhbox}, \.{\\unhcopy} )
	@!unVbox = 24 // 상자를 푼다( \.{\\unvbox}, \.{\\unvcopy} )
	@!removeItem = 25 // 마지막 항목을 없앤다( \.{\\unpenalty}, \.{\\unkern}, \.{\\unskip} )
	@!hskip = 26 // 가로 글루( \.{\\hskip}, \.{\\hfil} 따위 )
	@!vskip = 27 // 세로 글루( \.{\\vskip}, \.{\\vfil} 따위 )
	@!mskip = 28 // 수식 글루( \.{\\mskip} )
	@!kern = 29 // 고정된 간격( \.{\\kern} )
	@!mkern = 30 // 수식 커닝( \.{\\mkern} )
	@!leaderShip = 31 // 상자를 쓴다( \.{\\shipout}, \.{\\leaders} 따위 )
	@!halign = 32 // 가로 표 정렬( \.{\\halign} )
	@!valign = 33 // 세로 표 정렬( \.{\\valign} )
	@!noAlign = 34 // 정렬에서 잠시 벗어난다( \.{\\noalign} )
	@!vrule = 35 // 세로 괘선( \.{\\vrule} )
	@!hrule = 36 // 가로 괘선( \.{\\hrule} )
	@!insert = 37 // 상자에 끼워 넣는 세로 목록( \.{\\insert} )
	@!vadjust = 38 // 둘러싼 문단에 끼워 넣는 세로 목록( \.{\\vadjust} )
	@!ignoreSpaces = 39 // |spacer| 토큰들을 삼킨다( \.{\\ignorespaces} )
	@!afterAssignment = 40 // 대입이 끝날 때까지 남겨 둔다( \.{\\afterassignment} )
	@!afterGroup = 41 // 그룹이 끝날 때까지 남겨 둔다( \.{\\aftergroup} )
	@!breakPenalty = 42 // 추가 나쁨( \.{\\penalty} )
)

@ 앞 절에 이어 여느 명령 코드를 정의한다. 이 목록의 마지막 |maxNonPrefixedCommand|까지는 앞에
\.{\\global} 같은 한정어를 붙일 수 없는 명령들이다.

@<정의@>=
const (
	@!startPar = 43 // 문단을 시작한다( \.{\\indent}, \.{\\noindent} )
	@!italCorr = 44 // 기울임 보정( \.{\\/} )
	@!accent = 45 // 본문의 악센트를 붙인다( \.{\\accent} )
	@!mathAccent = 46 // 수식의 악센트를 붙인다( \.{\\mathaccent} )
	@!discretionary = 47 // 선택적 텍스트( \.{\\-}, \.{\\discretionary} )
	@!eqNo = 48 // 수식 번호( \.{\\eqno}, \.{\\leqno} )
	@!leftRight = 49 // 크기가 변하는 구분자( \.{\\left}, \.{\\right} )
	@!mathComp = 50 // 수식의 구성 요소( \.{\\mathbin} 따위 )
	@!limitSwitch = 51 // 극한 관례를 바꾼다( \.{\\displaylimits} 따위 )
	@!above = 52 // 일반화된 분수( \.{\\above}, \.{\\atop} 따위 )
	@!mathStyle = 53 // 모양 지정( \.{\\displaystyle} 따위 )
	@!mathChoice = 54 // 선택 지정( \.{\\mathchoice} )
	@!nonScript = 55 // 조건부 수식 글루( \.{\\nonscript} )
	@!vcenter = 56 // 세로 상자를 세로로 가운데 맞춘다( \.{\\vcenter} )
	@!caseShift = 57 // 대소문자를 강제한다( \.{\\lowercase}, \.{\\uppercase}~)
	@!message = 58 // 사용자에게 보낸다( \.{\\message}, \.{\\errmessage} )
	@!extension = 59 // \TeX의 확장( \.{\\write}, \.{\\special} 따위 )
	@!inStream = 60 // 읽을 파일( \.{\\openin}, \.{\\closein} )
	@!beginGroup = 61 // 지역 그룹을 시작한다( \.{\\begingroup} )
	@!endGroup = 62 // 지역 그룹을 끝낸다( \.{\\endgroup} )
	@!omit = 63 // 정렬 틀을 빼먹는다( \.{\\omit} )
	@!exSpace = 64 // 명시적 공백( \.{\\\ } )
	@!noBoundary = 65 // 경계 합자를 억누른다( \.{\\noboundary} )
	@!radical = 66 // 제곱근과 비슷한 기호( \.{\\radical} )
	@!endCsName = 67 // 제어 시퀀스를 끝낸다( \.{\\endcsname} )
	@!minInternal = 68 // \.{\\the} 뒤에 올 수 있는 가장 작은 코드
	@!charGiven = 68 // \.{\\chardef}로 정의한 문자 코드
	@!mathGiven = 69 // \.{\\mathchardef}로 정의한 수식 코드
	@!lastItem = 70 // 가장 최근 항목( \.{\\lastpenalty}, \.{\\lastkern}, \.{\\lastskip} )
	@!maxNonPrefixedCommand = 70 // \.{\\global}일 수 없는 가장 큰 명령 코드
)

@ \seclabel{set-font}다음 코드들은 특별하다. 모두 \TeX의 내부 레지스터나 표에 값을 대입하는 일과 관계가 있고,
어느 모드에서든 똑같이 처리한다. 그래서 \.{\\global}을 붙일 수 있다. 값이 |maxInternal| 이하인 코드는
`\.{\\the}'로 펼칠 수 있는 내부 양을 나타낸다.

@<정의@>=
const (
	@!toksRegister = 71 // 토큰 목록 레지스터( \.{\\toks} )
	@!assignToks = 72 // 특별한 토큰 목록( \.{\\output}, \.{\\everypar} 따위 )
	@!assignInt = 73 // 사용자가 정의한 정수( \.{\\tolerance}, \.{\\day} 따위 )
	@!assignDimen = 74 // 사용자가 정의한 길이( \.{\\hsize} 따위 )
	@!assignGlue = 75 // 사용자가 정의한 글루( \.{\\baselineskip} 따위 )
	@!assignMuGlue = 76 // 사용자가 정의한 수식 글루( \.{\\thinmuskip} 따위 )
	@!assignFontDimen = 77 // 사용자가 정의한 글꼴 치수( \.{\\fontdimen} )
	@!assignFontInt = 78 // 사용자가 정의한 글꼴 정수( \.{\\hyphenchar}, \.{\\skewchar} )
	@!setAux = 79 // 상태 정보를 지정한다( \.{\\spacefactor}, \.{\\prevdepth} )
	@!setPrevGraf = 80 // 상태 정보를 지정한다( \.{\\prevgraf} )
	@!setPageDimen = 81 // 상태 정보를 지정한다( \.{\\pagegoal} 따위 )
	@!setPageInt = 82 // 상태 정보를 지정한다( \.{\\deadcycles}, \.{\\insertpenalties} )
	@!setBoxDimen = 83 // 상자의 치수를 바꾼다( \.{\\wd}, \.{\\ht}, \.{\\dp} )
	@!setShape = 84 // 멋진 문단 모양을 지정한다( \.{\\parshape} )
	@!defCode = 85 // 문자 코드를 정의한다( \.{\\catcode} 따위 )
	@!defFamily = 86 // 수식 글꼴을 선언한다( \.{\\textfont} 따위 )
	@!setFont = 87 // 현재 글꼴을 정한다( 글꼴 식별자 )
	@!defFont = 88 // 글꼴 파일을 정의한다( \.{\\font} )
	@!register = 89 // 내부 레지스터( \.{\\count}, \.{\\dimen} 따위 )
	@!maxInternal = 89 // \.{\\the} 뒤에 올 수 있는 가장 큰 코드
	@!advance = 90 // 레지스터나 매개변수를 늘린다( \.{\\advance} )
	@!multiply = 91 // 레지스터나 매개변수를 곱한다( \.{\\multiply} )
	@!divide = 92 // 레지스터나 매개변수를 나눈다( \.{\\divide} )
	@!prefix = 93 // 정의에 한정어를 붙인다( \.{\\global}, \.{\\long}, \.{\\outer} )
	@!let = 94 // 명령 코드를 대입한다( \.{\\let}, \.{\\futurelet} )
	@!shorthandDef = 95 // 코드 정의( \.{\\chardef}, \.{\\countdef} 따위 )
	@!readToCs = 96 // 제어 시퀀스로 읽어 들인다( \.{\\read} )
	@!def = 97 // 매크로 정의( \.{\\def}, \.{\\gdef}, \.{\\xdef}, \.{\\edef} )
	@!setBox = 98 // 상자를 정한다( \.{\\setbox} )
	@!hyphData = 99 // 하이픈 넣기 자료( \.{\\hyphenation}, \.{\\patterns} )
	@!setInteraction = 100 // 대화 수준을 정한다( \.{\\batchmode} 따위 )
	@!maxCommand = 100 // |bigSwitch|에서 보는 가장 큰 명령 코드
)

@ 나머지 명령 코드들은 더욱 특별하다. \TeX의 훑개를 지나 주 제어 루틴까지 가는 일이 결코 없기 때문이다.
이 명령들은 훑개가 미리 펼쳐 버리거나 다른 것으로 바꾸어 놓는다. 그 특별한 성질을 쉽게 알아볼 수 있도록
|maxCommand|보다 큰 값을 주었다. ``펼칠 수 있는'' 명령들이 먼저 온다. 그 뒤의 |glueRef|부터는 명령이
아니라, 등가물 표의 항목이 무엇을 담고 있는지 나타내는 표시다.

@<정의@>=
const (
	@!undefinedCs = maxCommand + 1 // 대부분의 |eqType| 필드의 처음 상태
	@!expandAfter = maxCommand + 2 // 특별한 펼치기( \.{\\expandafter} )
	@!noExpand = maxCommand + 3 // 특별한 펼치지 않기( \.{\\noexpand} )
	@!input = maxCommand + 4 // 원본 파일을 입력한다( \.{\\input}, \.{\\endinput} )
	@!ifTest = maxCommand + 5 // 조건부 텍스트( \.{\\if}, \.{\\ifcase} 따위 )
	@!fiOrElse = maxCommand + 6 // 조건문의 구분자( \.{\\else} 따위 )
	@!csName = maxCommand + 7 // 토큰들로 제어 시퀀스를 만든다( \.{\\csname} )
	@!convert = maxCommand + 8 // 텍스트로 바꾼다( \.{\\number}, \.{\\string} 따위 )
	@!the = maxCommand + 9 // 내부 양을 펼친다( \.{\\the} )
	@!topBotMark = maxCommand + 10 // 끼워 넣은 표시( \.{\\topmark} 따위 )
	@!call = maxCommand + 11 // long도 outer도 아닌 제어 시퀀스
	@!longCall = maxCommand + 12 // long이면서 outer가 아닌 제어 시퀀스
	@!outerCall = maxCommand + 13 // long이 아니면서 outer인 제어 시퀀스
	@!longOuterCall = maxCommand + 14 // long이면서 outer인 제어 시퀀스
	@!endTemplate = maxCommand + 15 // 정렬 틀의 끝
	@!dontExpand = maxCommand + 16 // 다음 토큰은 \.{\\noexpand}로 표시되었다
	@!glueRef = maxCommand + 17 // 등가물이 글루 명세를 가리킨다
	@!shapeRef = maxCommand + 18 // 등가물이 문단 모양 명세를 가리킨다
	@!boxRef = maxCommand + 19 // 등가물이 상자 노드를 가리키거나 |null|이다
	@!data = maxCommand + 20 // 등가물이 그저 하프워드 수다
)

@* 의미 둥지.
\TeX은 대개 여러 목록을 동시에 만드는 중이다. 이를테면 수식을 처리할 때 \TeX은 수식 모드에서 수식
목록(mlist)을 만들고 있다. 그 수식은 \TeX이 가로 모드에서 문단의 가로 목록을 만들던 일을 잠시 멈추게 했고,
그 문단은 다시 \TeX이 세로 모드에서 문서의 다음 쪽에 들어갈 세로 목록을 만들던 일을 잠시 멈추게 했다.
마찬가지로 \.{\\hbox} 안에서 \.{\\vbox}가 나오면 \TeX은 제한된 가로 모드에서 하던 일을 멈추고 내부 세로
모드로 들어간다. ``의미 둥지''(semantic nest)는 지금 어떤 목록들이 어떤 모드에서 만들다 만 채 기다리고
있는지 기억해 두는 스택이다. 안쪽 일을 마치면 둥지에서 바깥 수준을 꺼내 하던 일을 마저 한다.

처리하는 수준마다 우리는 여섯 모드 가운데 하나에 있다.

\yskip\hang|vmode|는 세로 모드(쪽 조립기)를 나타낸다.

\hang|hmode|는 가로 모드(문단 조립기)를 나타낸다.

\hang|mmode|는 따로 세운 수식 모드를 나타낸다.

\hang|-vmode|는 내부 세로 모드를 나타낸다(이를테면 \.{\\vbox} 안).

\hang|-hmode|는 제한된 가로 모드를 나타낸다(이를테면 \.{\\hbox} 안).

\hang|-mmode|는 (따로 세우지 않은) 수식 모드를 나타낸다.

\yskip\noindent \.{\\write}의 텍스트를 처리하는 동안에는 모드를 잠시 0으로 놓는다.

모드 |vmode|, |hmode|, |mmode|에는 일부러 |maxCommand+1|씩 떨어진 수를 주었다. 그러면 \TeX의 ``큰 의미
전환기''가 |abs(mode)+curCmd|라는 값 하나로 할 일을 고를 수 있다. 여기서 |mode|는 현재 모드이고 |curCmd|는
현재 명령 코드다. 모드와 명령의 짝마다 서로 다른 수가 나오므로 |switch| 문 하나로 모두 가를 수 있는 것이다.

@<함수들@>=
const (
	@!vmode = 1 // 세로 모드
	@!hmode = vmode + maxCommand + 1 // 가로 모드
	@!mmode = hmode + maxCommand + 1 // 수식 모드
)

@ 다음 프로시저는 모드 |m|을 `\.{horizontal mode}'처럼 찍는다. 모드를 |maxCommand+1|로 나눈 몫이
0, 1, 2이면 각각 세로, 가로, 수식 모드다.

@<함수들@>=
func printMode(m int32) { // |m|이 나타내는 모드를 찍는다
	if m > 0 {
		switch m / (maxCommand + 1) {
		case 0:
			printStr("vertical")
		case 1:
			printStr("horizontal")
		case 2:
			printStr("display math")
		}
	} else if m == 0 {
		printStr("no")
	} else {
		switch (-m) / (maxCommand + 1) {
		case 0:
			printStr("internal vertical")
		case 1:
			printStr("restricted horizontal")
		case 2:
			printStr("math")
		}
	}
	printStr(" mode")
}

@ 의미 수준마다 그 사정은 다섯 값으로 나타낼 수 있다.

\yskip\hang|mode|는 방금 설명한 대로 의미 모드를 나타내는 수다.

\yskip\hang|head|는 만들고 있는 목록의 머리 노드를 가리키는 |pointer|다. 그러므로 |link(head)|는 목록의 첫
원소를 가리키거나, 목록이 비어 있으면 |null|이다.

\yskip\hang|tail|은 만들고 있는 목록의 마지막 노드를 가리키는 |pointer|다. 그러므로 목록이 비어 있을 때,
그리고 오직 그때에만 |tail=head|다. 꼬리를 늘 알고 있으므로 목록 끝에 노드를 붙이는 데 시간이 들지 않는다.

\yskip\hang|prevGraf|는 현재 문단에서 이미 지금의 세로 목록에 들어간 줄의 수다.

\yskip\hang|aux|는 사정을 더 자세히 알려 주는 보조 |memoryWord|다.

\yskip\noindent
세로 모드에서 |aux|는 |prevDepth|라고도 부른다. 기준선 간격을 계산하는 데 쓰는 앞 상자의 깊이를 담은 눈금
값이고, 세로 목록의 다음 상자에는 기준선 계산을 하지 말아야 하면 |<=-1000|pt다. 가로 모드에서 |aux|는
|spaceFactor|와 |clang|이라고도 부르는데, 공백 간격을 계산하는 데 쓰는 현재의 공백 인자와 하이픈 넣기에
쓰는 현재의 언어를 담는다. (제한된 가로 모드에서는 |clang|의 값이 정해져 있지 않다.) 수식 모드에서
|aux|는 |incompleatNoad|라고도 부른다. 이 값이 |null|이 아니면 일반화된 분수를 나타내는 레코드를 가리키는데,
그 분수의 분자는 이미 다 만들었고 분모는 지금 현재 목록으로 만들고 있는 중이다. 이를테면 \.{\{a \\over b\}}에서
\.{\\over}를 만난 뒤가 그런 상황이다.

여섯째 값 |modeLine|도 있다. 이것은 의미 둥지를 사용자의 입력과 이어 준다. 현재의 중첩 수준이 시작된 원본
파일의 줄 번호가 이 값이다. 사용자의 출력 루틴 수준에서는 그 줄 번호의 음수를 |modeLine|에 넣어 둔다.
오류 메시지나 \.{\\showlists}가 ``어디에서 시작한 상자인지'' 알려 줄 수 있는 것은 이 값 덕분이다.

가로 모드에서 |prevGraf| 필드에는 처음의 언어 정보를 담아 둔다.

의미 둥지는 |nest|라는 배열이다. 이 배열에는 현재 수준 아래의 의미 수준마다 |mode|, |head|, |tail|,
|prevGraf|, |aux|, |modeLine| 값이 레코드 |listStateRecord|로 묶여 쌓인다. 현재 수준의 정보는 전역 변수
|mode|, |head|, |tail|, |prevGraf|, |aux|, |modeLine|에 들어 있다.

@<전역 형@>=
const @!ignoreDepth = -65536000 // 무시하는 |prevDepth| 값

type @!listStateRecord struct {
	@!modeField int32 // |-mmode..mmode|
	@!headField, @!tailField pointer
	@!pgField, @!mlField int32
	@!auxField memoryWord
}

@ \seclabel{nest}현재 수준의 여섯 값은 아주 자주 쓰므로 저마다 전역 변수로 둔다. 그것들을 통째로 |nest|에
쌓거나 거기서 꺼낼 때는, 이 변수들을 레코드 하나로 묶는 함수 |curList()|와 레코드를 풀어 변수들에 넣는 함수
|setCurList(r)|를 쓴다.

변수 |aux|의 다른 이름인 |prevDepth|, |spaceFactor|, |clang|, |incompleatNoad|도 다른 필드처럼 읽는 함수와
쓰는 함수의 짝으로 만든다. 저마다 |aux.sc|, |aux.hh.lh|, |aux.hh.rh|, |aux.sc|를 가리킨다.

@<전역 변수@>=
var @!mode int32 // 현재 모드
var @!head pointer // 현재 목록의 머리 노드
var @!tail pointer // 현재 목록의 마지막 노드
var @!prevGraf int32 // 쌓인 문단 줄의 수
var @!aux memoryWord // 현재 목록에 관한 보조 자료
var @!modeLine int32 // 목록이 시작된 원본 파일 줄 번호

func prevDepth() scaled                { return aux.sc } // 세로 모드에서 |aux|의 이름
func setPrevDepth(v scaled)           { aux.sc = v }
func spaceFactor() halfword            { return aux.hh.lh } // 가로 모드에서 |aux|의 한 부분
func setSpaceFactor(v halfword)       { aux.hh.lh = v }
func clang() halfword                   { return aux.hh.rh } // 가로 모드에서 |aux|의 다른 부분
func setClang(v halfword)              { aux.hh.rh = v }
func incompleatNoad() int32            { return aux.sc } // 수식 모드에서 |aux|의 이름
func setIncompleatNoad(v int32)       { aux.sc = v }

func curList() listStateRecord { // ``맨 위'' 의미 상태
	return listStateRecord{mode, head, tail, prevGraf, modeLine, aux}
}

func setCurList(r listStateRecord) {
	mode, head, tail = r.modeField, r.headField, r.tailField
	prevGraf, modeLine, aux = r.pgField, r.mlField, r.auxField
}

var @!nest [nestSize + 1]listStateRecord
var @!nestPtr int32 // |nest|에서 쓰이지 않는 첫 위치; |0 .. nestSize|
var @!maxNestStack int32 // 쌓을 때 |nestPtr|의 최댓값
var @!shownMode int32 // \.{\\tracingcommands}가 가장 최근에 보인 모드

@ 현재 목록을 늘리는 흔한 방법은 다음과 같다. 꼬리에 새 노드를 잇고 꼬리를 그 노드로 옮긴다.

@<정의@>=
func tailAppend(p pointer) {
	setLink(tail, p)
	tail = link(tail)
}

@ 나중에 보겠지만 맨 아래 의미 수준의 세로 목록은 두 부분으로 나뉜다. ``현재 쪽''은 |pageHead|부터
|pageTail|까지이고, ``기여 목록''은 |contribHead|부터 의미 수준 0의 |tail|까지다. 세로 모드에서 만든 것들이
먼저 기여 목록에 쌓였다가 현재 쪽으로 ``기여''되고, 그러면서 쪽을 어디서 나눌지 정해진다는 생각이다.
지금은 쪽을 조립하는 과정에 대해 더 알 필요가 없다. 처음에는 세로 모드의 빈 목록 하나로 시작한다.

@<핵심 변수들의...@>=
nestPtr = 0
maxNestStack = 0
mode = vmode
head = contribHead
tail = contribHead
setPrevDepth(ignoreDepth)
modeLine = 0
prevGraf = 0
shownMode = 0
@<새 현재 쪽을 시작한다@>

@ \TeX이 어떤 수준에서 하던 일을 잠시 멈추어야 할 때는 |pushNest|를 불러서 상태를 저장한다. 이 루틴은
새 (빈) 목록을 시작하도록 |head|와 |tail|을 바꾼다. 그러나 |mode|와 |aux|는 바꾸지 않는다. 새 수준의 모드와
보조 값은 부른 쪽에서 곧바로 정해 준다.

@<함수들@>=
func pushNest() { // 새 의미 수준에 들어가고, 옛것을 저장한다
	if nestPtr > maxNestStack {
		maxNestStack = nestPtr
		if nestPtr == nestSize {
			overflow("semantic nest size", nestSize)
		}
@:TeX capacity exceeded semantic nest size}{\quad semantic nest size@>
	}
	nest[nestPtr] = curList() // 레코드를 쌓는다
	nestPtr++
	head = getAvail()
	tail = head
	prevGraf = 0
	modeLine = line
}

@ 거꾸로, \TeX이 현재 수준의 일을 마치면 |popNest|를 불러서 앞의 상태를 되살린다. 이 루틴은 가장 낮은 의미
수준에서는 결코 부르지 않는다. 또 |head|가 빈 메모리로 돌려주어도 되는 노드일 때에만 부른다. 머리 노드는
|pushNest|가 |getAvail|로 얻은 것이기 때문이다.

@<함수들@>=
func popNest() { // 의미 수준을 떠나 옛 수준에 다시 들어간다
	freeAvail(head)
	nestPtr--
	setCurList(nest[nestPtr])
}

@ 다음은 \TeX이 모든 수준에서 무엇을 하고 있는지 보여 주는 프로시저다. 명령 \.{\\showlists}를 쓰면 이
프로시저가 불린다. 가장 안쪽 수준부터 차례로 `\.{\#\#\# horizontal mode entered at line 5}' 같은 머리줄과 그 수준의
목록을 찍는다. 맨 아래 수준에서는 현재 쪽의 상태와 기여 목록도 보여 준다.

@<함수들@>=
func showActivities() {
	var p int32 // |nest|의 첨자; |0 .. nestSize|
	var m int32 // 모드; |-mmode..mmode|
	var a memoryWord // 보조
	var q, r pointer // 현재 쪽을 보이기 위해
	var t int32 // 마찬가지
	nest[nestPtr] = curList() // 맨 위 수준을 배열에 넣는다
	printNl("")
	printLn()
	for p = nestPtr; p >= 0; p-- {
		m = nest[p].modeField
		a = nest[p].auxField
		printNl("### ")
		printMode(m)
		printStr(" entered at line ")
		printInt(abs(nest[p].mlField))
		if m == hmode {
			if nest[p].pgField != 0o40600000 {
				printStr(" (language")
				printInt(nest[p].pgField % 0o200000)
				printStr(":hyphenmin")
				printInt(nest[p].pgField / 0o20000000)
				printChar(',')
				printInt((nest[p].pgField / 0o200000) % 0o100)
				printChar(')')
			}
		}
		if nest[p].mlField < 0 {
			printStr(" (\\output routine)")
		}
		if p == 0 {
			@<현재 쪽의 상태를 보인다@>
			if link(contribHead) != null {
				printNl("### recent contributions:")
			}
		}
		showBox(link(nest[p].headField))
		@<보조 필드 |a|를 보인다@>
	}
}

@ 가로 모드에서 |prevGraf| 필드에 담아 둔 처음 언어 정보는 세 수를 하나로 묶은 것이다. 이 값은
\secref{norm-min}에서 $|normMin(leftHyphenMin)|\cdot2^{22}+|normMin(rightHyphenMin)|\cdot2^{16}
+|curLang|$으로 만든다. 그래서 위에서는 이것을 $2^{16}$(\.{'200000})과 $2^{22}$(\.{'20000000})으로 나누어 다시
풀어낸다. 값 \.{'40600000}은 언어가 0이고 두 hyphenmin이 각각 2와 3인 기본값이므로, 그때는 찍지 않는다.

보조 필드는 모드에 따라 다르게 찍는다. 세로 모드에서는 |prevDepth|와 |prevGraf|를, 가로 모드에서는 공백
인자와 언어를, 수식 모드에서는 만들다 만 분수가 있으면 그것을 보여 준다.

@<보조 필드...@>=
switch abs(m) / (maxCommand + 1) {
case 0:
	printNl("prevdepth ")
	if a.sc <= ignoreDepth {
		printStr("ignored")
	} else {
		printScaled(a.sc)
	}
	if nest[p].pgField != 0 {
		printStr(", prevgraf ")
		printInt(nest[p].pgField)
		printStr(" line")
		if nest[p].pgField != 1 {
			printChar('s')
		}
	}
case 1:
	printNl("spacefactor ")
	printInt(a.hh.lh)
	if m > 0 {
		if a.hh.rh > 0 {
			printStr(", current language ")
			printInt(a.hh.rh)
		}
	}
case 2:
	if a.sc != null {
		printStr("this will begin denominator of:")
		showBox(a.sc)
	}
} // 다른 경우는 없다

@* 등가물 표.
\TeX의 의미 루틴들이 쓰는 자료 구조를 공부했으니, 이제 구문 루틴들이 쓰는 자료 구조를 살펴볼 차례다.
다시 말해 사용자가 쓴 것을 \TeX이 훑으면서 들여다보는 표들이 다음 관심사다.

그런 표 가운데 가장 크고 중요한 것이 |eqtb|다. 이 표에는 \TeX의 그룹이 만드는 중첩 구조를 따르는 모든
양의 현재 ``등가물''(equivalent)이 들어 있다. 곧 그 양이 지금 무엇을 뜻하는지, 지금 값이 무엇인지 알려
준다. \TeX에서 \.{\{}와 \.{\}} 안에서 한 정의가 그룹이 끝나면 사라지는 것은, 바로 이 표의 항목들을 그룹이
끝날 때 되돌려 놓기 때문이다. 표 |eqtb|는 여섯 영역으로 나뉜다.

\yskip\hangg 1) |eqtb[activeBase..(hashBase-1)]|에는 한 글자짜리 제어 시퀀스의 현재 등가물이 들어 있다.

\yskip\hangg 2) |eqtb[hashBase..(glueBase-1)]|에는 여러 글자짜리 제어 시퀀스의 현재 등가물이 들어 있다.

\yskip\hangg 3) |eqtb[glueBase..(localBase-1)]|에는 현재의 baselineskip 같은 글루 매개변수의 현재 등가물이
들어 있다.

\yskip\hangg 4) |eqtb[localBase..(intBase-1)]|에는 현재의 상자 레지스터, 현재의 ``catcode'', 현재 글꼴, 현재
문단 모양을 가리키는 포인터처럼 하프워드 크기인 지역 양의 현재 등가물이 들어 있다.

\yskip\hangg 5) |eqtb[intBase..(dimenBase-1)]|에는 현재의 하이픈 벌점처럼 온 낱말을 차지하는 정수 매개변수의
현재 등가물이 들어 있다.

\yskip\hangg 6) |eqtb[dimenBase..eqtbSize]|에는 현재의 hsize나 매달린 들여쓰기의 양처럼 온 낱말을 차지하는
치수 매개변수의 현재 등가물이 들어 있다.

\yskip\noindent 이를테면 현재 baselineskip 글루의 양은 |eqtb|의 영역~3에 있는 어떤 자리의 값으로 정해진다.
그러나 제어 시퀀스 `\.{\\baselineskip}'이 지금 무엇을 뜻하는지(\.{\\def}나 \.{\\let}으로 뜻이 바뀌었을 수도
있다)는 영역~2에 들어 있다는 데 눈여겨보자. 값을 담는 자리와 이름의 뜻을 담는 자리는 다르다.

이 구현의 상수로 계산한 실제 주소를 써서 표 |eqtb|를 그리면 다음과 같다. 가운데 기둥의 수가 영역의 번호다.
영역~1과~2는 제어 시퀀스의 뜻을, 영역~3부터~6은 매개변수와 레지스터의 값을 담는다는 점에서 성격이 갈린다.
영역~5와~6의 낱말에는 |eqLevel|을 넣을 자리가 없으므로 그 수준은 따로 배열 |xeqLevel|에
둔다(\secref{xeq-level}).
$$\mplibcode
beginfig(5);
save r, w, n, q; numeric r, w, n; picture q; r := 11pt; w := 22pt; n := 18;
fill (0,-0*r)--(w,-0*r)--(w,-3*r)--(0,-3*r)--cycle withcolor .88white;
fill (0,-3*r)--(w,-3*r)--(w,-6*r)--(0,-6*r)--cycle withcolor .75white;
fill (0,-6*r)--(w,-6*r)--(w,-9*r)--(0,-9*r)--cycle withcolor .88white;
fill (0,-9*r)--(w,-9*r)--(w,-13*r)--(0,-13*r)--cycle withcolor .75white;
fill (0,-13*r)--(w,-13*r)--(w,-16*r)--(0,-16*r)--cycle withcolor .88white;
fill (0,-16*r)--(w,-16*r)--(w,-18*r)--(0,-18*r)--cycle withcolor .75white;
for i = 0 upto n-1: draw (0,-i*r)--(w,-i*r) withpen pencircle scaled .2pt; endfor
label.lft(btex \eightpoint \ID{activeBase}${}=1$ etex, (-4pt,-0*r));
label.rt(btex \ninepoint 능동 문자 256개 etex, (w+4pt,-(0+.5)*r));
label.lft(btex \eightpoint \ID{singleBase}${}=257$ etex, (-4pt,-1*r));
label.rt(btex \ninepoint 한 문자짜리 제어 시퀀스 256개 etex, (w+4pt,-(1+.5)*r));
label.lft(btex \eightpoint \ID{nullCs}${}=513$ etex, (-4pt,-2*r));
label.rt(btex \ninepoint \cs{csname}\cs{endcsname} etex, (w+4pt,-(2+.5)*r));
label.lft(btex \eightpoint \ID{hashBase}${}=514$ etex, (-4pt,-3*r));
label.rt(btex \ninepoint 여러 글자짜리 제어 시퀀스(해시 표) etex, (w+4pt,-(3+.5)*r));
label.lft(btex \eightpoint \ID{frozenControlSequence}${}=2614$ etex, (-4pt,-4*r));
label.rt(btex \ninepoint 오류 복구에 쓰는 얼린 제어 시퀀스 etex, (w+4pt,-(4+.5)*r));
label.lft(btex \eightpoint \ID{undefinedControlSequence}${}=2881$ etex, (-4pt,-5*r));
label.rt(btex \ninepoint 정의되지 않은 제어 시퀀스 etex, (w+4pt,-(5+.5)*r));
label.lft(btex \eightpoint \ID{glueBase}${}=2882$ etex, (-4pt,-6*r));
label.rt(btex \ninepoint \cs{baselineskip} 같은 글루 매개변수 etex, (w+4pt,-(6+.5)*r));
label.lft(btex \eightpoint \ID{skipBase}${}=2900$ etex, (-4pt,-7*r));
label.rt(btex \ninepoint \cs{skip} 레지스터 256개 etex, (w+4pt,-(7+.5)*r));
label.lft(btex \eightpoint \ID{muSkipBase}${}=3156$ etex, (-4pt,-8*r));
label.rt(btex \ninepoint \cs{muskip} 레지스터 256개 etex, (w+4pt,-(8+.5)*r));
label.lft(btex \eightpoint \ID{localBase}${}=3412$ etex, (-4pt,-9*r));
label.rt(btex \ninepoint \cs{parshape}, \cs{output}, \cs{everypar} 따위 etex, (w+4pt,-(9+.5)*r));
label.lft(btex \eightpoint \ID{boxBase}${}=3678$ etex, (-4pt,-10*r));
label.rt(btex \ninepoint \cs{box} 레지스터 256개 etex, (w+4pt,-(10+.5)*r));
label.lft(btex \eightpoint \ID{curFontLoc}${}=3934$ etex, (-4pt,-11*r));
label.rt(btex \ninepoint 현재 글꼴과 수식 글꼴 48개 etex, (w+4pt,-(11+.5)*r));
label.lft(btex \eightpoint \ID{catCodeBase}${}=3983$ etex, (-4pt,-12*r));
label.rt(btex \ninepoint \cs{catcode} \cs{lccode} \cs{uccode} \cs{sfcode} \cs{mathcode} etex, (w+4pt,-(12+.5)*r));
label.lft(btex \eightpoint \ID{intBase}${}=5263$ etex, (-4pt,-13*r));
label.rt(btex \ninepoint \cs{tolerance} 같은 정수 매개변수 etex, (w+4pt,-(13+.5)*r));
label.lft(btex \eightpoint \ID{countBase}${}=5318$ etex, (-4pt,-14*r));
label.rt(btex \ninepoint \cs{count} 레지스터 256개 etex, (w+4pt,-(14+.5)*r));
label.lft(btex \eightpoint \ID{delCodeBase}${}=5574$ etex, (-4pt,-15*r));
label.rt(btex \ninepoint \cs{delcode} 256개 etex, (w+4pt,-(15+.5)*r));
label.lft(btex \eightpoint \ID{dimenBase}${}=5830$ etex, (-4pt,-16*r));
label.rt(btex \ninepoint \cs{hsize} 같은 치수 매개변수 etex, (w+4pt,-(16+.5)*r));
label.lft(btex \eightpoint \ID{scaledBase}${}=5851$ etex, (-4pt,-17*r));
label.rt(btex \ninepoint \cs{dimen} 레지스터 256개 etex, (w+4pt,-(17+.5)*r));
label.lft(btex \eightpoint \ID{eqtbSize}${}=6106$ etex, (-4pt,-n*r));
draw (0,0)--(w,0)--(w,-n*r)--(0,-n*r)--cycle;
draw (0,-0*r)--(w,-0*r);
q := thelabel(btex \ninepoint 1 etex, (w/2, -1.5*r)); unfill bbox q; draw q;
draw (0,-3*r)--(w,-3*r);
q := thelabel(btex \ninepoint 2 etex, (w/2, -4.5*r)); unfill bbox q; draw q;
draw (0,-6*r)--(w,-6*r);
q := thelabel(btex \ninepoint 3 etex, (w/2, -7.5*r)); unfill bbox q; draw q;
draw (0,-9*r)--(w,-9*r);
q := thelabel(btex \ninepoint 4 etex, (w/2, -11*r)); unfill bbox q; draw q;
draw (0,-13*r)--(w,-13*r);
q := thelabel(btex \ninepoint 5 etex, (w/2, -14.5*r)); unfill bbox q; draw q;
draw (0,-16*r)--(w,-16*r);
q := thelabel(btex \ninepoint 6 etex, (w/2, -17*r)); unfill bbox q; draw q;
for i = 0 upto n-1: draw (0,-i*r)--(-3pt,-i*r); endfor
draw (0,0)--(w,0)--(w,-n*r)--(0,-n*r)--cycle;
endfig;
\endmplibcode$$

@ 표 |eqtb|의 항목은 저마다 |memoryWord| 하나다. 이 낱말들은 대부분 형이 |twoHalves|이고, 세 필드로 나뉜다.

\yskip\hangg 1) |eqLevel|(쿼터워드)은 이 등가물을 정의한 그룹 수준이다. 수준이 |levelZero|이면 그 등가물은
한 번도 정의된 적이 없다. 수준 |levelOne|은 맨 바깥 수준(어떤 그룹에도 들지 않은 곳)을 가리키며, 결코 사라지지
않는 전역 정의에도 이 수준을 쓴다. 그보다 높은 수준은 그 그룹이 끝날 때 사라질 등가물에 쓴다. 이를테면
그룹 두 개 안에서 \.{\\def}로 정의한 매크로의 수준은 3이다. @^global definitions@>

\yskip\hangg 2) |eqType|(또 하나의 쿼터워드)은 이 항목이 어떤 종류인지 알려 준다. 종류는 아주 많다.
명령 \.{\\hbox}, \.{\\def} 같은 \TeX의 원시 명령마다 저만의 코드가 있기 때문이다. 앞에서 본 명령 코드의 목록이 곧
|eqType| 필드에 들어갈 수 있는 값의 목록이다.

\yskip\hangg 3) |equiv|(하프워드)는 현재의 등가 값이다. 글꼴 번호일 수도 있고, |mem|을 가리키는 포인터일 수도
있으며, 그 밖의 여러 가지일 수 있다. 이를테면 매크로라면 그 정의를 담은 토큰 목록을 가리키고, \.{\\hbox}
같은 원시 명령이라면 같은 명령 코드를 쓰는 명령들을 서로 구별하는 수다.

@<정의@>=
func eqLevelField(w memoryWord) quarterword { return w.hh.b1 }
func eqTypeField(w memoryWord) quarterword  { return w.hh.b0 }
func equivField(w memoryWord) halfword       { return w.hh.rh }

func eqLevel(p pointer) quarterword        { return eqLevelField(eqtb[p]) } // 정의의 수준
func setEqLevel(p pointer, v quarterword) { eqtb[p].hh.b1 = v }
func eqType(p pointer) quarterword         { return eqTypeField(eqtb[p]) } // 등가물의 명령 코드
func setEqType(p pointer, v quarterword)  { eqtb[p].hh.b0 = v }
func equiv(p pointer) halfword              { return equivField(eqtb[p]) } // 등가 값
func setEquiv(p pointer, v halfword)       { eqtb[p].hh.rh = v }

const (
	@!levelZero = minQuarterword // 정의되지 않은 양의 수준
	@!levelOne = levelZero + 1 // 정의된 양의 가장 바깥 수준
)

@ 표 |eqtb|의 많은 자리에는 기호 이름이 붙어 있다. 다음 몇 문단에서 그 이름들을 정의하고 등가물의 처음
값을 정한다.

첫째 영역에는 제어 시퀀스처럼 행동하는 ``능동 문자''(catcode가 13인 문자, 이를테면 plain \TeX의
\.{\char'176})를 위한 등가물 256개가 있고, 그 뒤에 한 글자짜리 제어 시퀀스(\.{\\!}이나 \.{\\a} 같은 것)를
위한 등가물 256개가 온다.

그다음은 나중에 정의할 해시 표에 해당하는 영역~2다. 이 영역의 가장 큰 주소는 영원히 정의되지 않는 가짜
제어 시퀀스에 쓴다. 또 오류를 수습할 때 쓰려고, 영원히 정의되어 있는 제어 시퀀스를 위한 자리도 몇 개
둔다. 처음에는 영역 1과 2의 모든 항목을 ``정의되지 않음''으로 채운다.

@<표의 항목들을 초기화한다...@>=
setEqType(undefinedControlSequence, undefinedCs)
setEquiv(undefinedControlSequence, null)
setEqLevel(undefinedControlSequence, levelZero)
for k = activeBase; k <= undefinedControlSequence-1; k++ {
	eqtb[k] = eqtb[undefinedControlSequence]
}

@ 영역 1과 2의 주소들이다. 해시 표에 들어가는 보통의 제어 시퀀스 뒤에 ``얼린'' 제어 시퀀스들을 둔다.
이를테면 |frozenFi|는 사용자가 \.{\\fi}를 다시 정의해 버렸더라도 오류를 수습할 때 끼워 넣을 수 있는 진짜
\.{\\fi}다. 사용자는 이 자리를 이름으로 가리킬 길이 없으므로 결코 뜻을 바꿀 수 없다.
@<정의@>=
const (
	@!activeBase = 1 // 영역 1의 시작, 능동 문자 등가물을 위해
	@!singleBase = activeBase + 256 // 한 문자짜리 제어 시퀀스의 등가물
	@!nullCs = singleBase + 256 // \.{\\csname\\endcsname}의 등가물
	@!hashBase = nullCs + 1 // 영역 2의 시작, 해시 표를 위해
	@!frozenControlSequence = hashBase + hashSize // 오류 복구를 위해
	@!frozenProtection = frozenControlSequence // 접근할 수 없지만 정의할 수 있다
	@!frozenCr = frozenControlSequence + 1 // 영구적인 `\.{\\cr}'
	@!frozenEndGroup = frozenControlSequence + 2 // 영구적인 `\.{\\endgroup}'
	@!frozenRight = frozenControlSequence + 3 // 영구적인 `\.{\\right}'
	@!frozenFi = frozenControlSequence + 4 // 영구적인 `\.{\\fi}'
	@!frozenEndTemplate = frozenControlSequence + 5 // 영구적인 `\.{\\endtemplate}'
	@!frozenEndv = frozenControlSequence + 6 // 두 번째 영구적인 `\.{\\endtemplate}'
	@!frozenRelax = frozenControlSequence + 7 // 영구적인 `\.{\\relax}'
	@!endWrite = frozenControlSequence + 8 // 영구적인 `\.{\\endwrite}'
	@!frozenDontExpand = frozenControlSequence + 9 // 영구적인 `\.{\\notexpanded:}'
	@!frozenNullFont = frozenControlSequence + 10 // 영구적인 `\.{\\nullfont}'
	@!fontIDBase = frozenNullFont - fontBase // 영구적인 글꼴 식별자 257개의 표가 시작한다
	@!undefinedControlSequence = frozenNullFont + 257 // 가짜 위치
	@!glueBase = undefinedControlSequence + 1 // 영역 3의 시작
)

@ 다음은 영역 1이나~2에 있는 |eqtb| 항목의 현재 뜻을 보여 주는 루틴이다. 매크로라면 그 정의도 32글자까지
보여 준다. (다른 영역을 위한 비슷한 루틴들은 아래에 나온다.)

@<등가물 |n|을 보인다, 영역 1이나 2@>=
sprintCs(n)
printChar('=')
printCmdChr(eqType(n), equiv(n))
if eqType(n) >= call {
	printChar(':')
	showTokenList(link(equiv(n)), null, 32)
}

@ 표 |eqtb|의 영역 3에는 256개의 \.{\\skip} 레지스터와 여기서 정의하는 글루 매개변수들이 들어 있다.
``muskip'' 매개변수들의 번호가 다른 것들보다 큰 것이 중요하다. 그래야 번호 하나만 보고 단위를 \.{pt}로
찍을지 \.{mu}로 찍을지 정할 수 있다.

@<글루 매개변수 번호 |n|의 현재 |mem| 등가물@>=
gluePar(n)

@ 글루 매개변수의 번호들이다. 주석에 각 매개변수가 하는 일을 짧게 적었다. 자세한 뜻은 {\sl The \TeX book}에
있다.
@<정의@>=
const (
	@!lineSkipCode = 0 // |baselineSkip|을 쓸 수 없을 때의 줄 사이 글루
	@!baselineSkipCode = 1 // 기준선 사이의 바라는 글루
	@!parSkipCode = 2 // 문단 바로 위의 추가 글루
	@!aboveDisplaySkipCode = 3 // 따로 세운 수식 바로 위의 추가 글루
	@!belowDisplaySkipCode = 4 // 따로 세운 수식 바로 아래의 추가 글루
	@!aboveDisplayShortSkipCode = 5 // 짧은 줄 뒤의 따로 세운 수식 위의 글루
	@!belowDisplayShortSkipCode = 6 // 짧은 줄 뒤의 따로 세운 수식 아래의 글루
	@!leftSkipCode = 7 // 양쪽 맞춘 줄의 왼쪽 글루
	@!rightSkipCode = 8 // 양쪽 맞춘 줄의 오른쪽 글루
	@!topSkipCode = 9 // 본문 쪽 맨 위의 글루
	@!splitTopSkipCode = 10 // 쪼갠 쪽 맨 위의 글루
	@!tabSkipCode = 11 // 정렬된 항목 사이의 글루
	@!spaceSkipCode = 12 // 낱말 사이의 글루(|zeroGlue|가 아니면)
	@!xspaceSkipCode = 13 // 문장 뒤의 글루(|zeroGlue|가 아니면)
	@!parFillSkipCode = 14 // 문단 마지막 줄의 글루
	@!thinMuSkipCode = 15 // 수식의 가는 공백
	@!medMuSkipCode = 16 // 수식의 중간 공백
	@!thickMuSkipCode = 17 // 수식의 굵은 공백
	@!gluePars = 18 // 글루 매개변수의 총수
	@!skipBase = glueBase + gluePars // 256개의 ``skip'' 레지스터의 표
	@!muSkipBase = skipBase + 256 // 256개의 ``muskip'' 레지스터의 표
	@!localBase = muSkipBase + 256 // 영역 4의 시작
)

@ 영역 3의 글루 명세를 가리키는 포인터들을 읽는 함수들이다. 이를테면 |baselineSkip()|은 지금의
\.{\\baselineskip}의 글루 명세를 가리킨다.

@<정의@>=
func skip(n int32) pointer     { return equiv(skipBase + n) } // 글루 명세의 |mem| 위치
func muSkip(n int32) pointer  { return equiv(muSkipBase + n) } // 수식 글루 명세의 |mem| 위치
func gluePar(n int32) pointer { return equiv(glueBase + n) } // 글루 명세의 |mem| 위치

func lineSkip() pointer                { return gluePar(lineSkipCode) }
func baselineSkip() pointer            { return gluePar(baselineSkipCode) }
func parSkip() pointer                 { return gluePar(parSkipCode) }
func aboveDisplaySkip() pointer       { return gluePar(aboveDisplaySkipCode) }
func belowDisplaySkip() pointer       { return gluePar(belowDisplaySkipCode) }
func aboveDisplayShortSkip() pointer { return gluePar(aboveDisplayShortSkipCode) }
func belowDisplayShortSkip() pointer { return gluePar(belowDisplayShortSkipCode) }
func leftSkip() pointer                { return gluePar(leftSkipCode) }
func rightSkip() pointer               { return gluePar(rightSkipCode) }
func topSkip() pointer                 { return gluePar(topSkipCode) }
func splitTopSkip() pointer           { return gluePar(splitTopSkipCode) }
func setSplitTopSkip(v pointer)      { setEquiv(glueBase+splitTopSkipCode, v) }
func tabSkip() pointer                 { return gluePar(tabSkipCode) }
func spaceSkip() pointer               { return gluePar(spaceSkipCode) }
func xspaceSkip() pointer              { return gluePar(xspaceSkipCode) }
func parFillSkip() pointer            { return gluePar(parFillSkipCode) }
func thinMuSkip() pointer             { return gluePar(thinMuSkipCode) }
func medMuSkip() pointer              { return gluePar(medMuSkipCode) }
func thickMuSkip() pointer            { return gluePar(thickMuSkipCode) }

@ 때로는 \TeX의 내부 코드 번호를 기호 꼴로 바꾸어야 한다. 루틴 |printSkipParam|은 글루 매개변수의 번호를
받아 그 기호 이름을 찍는다.

@<|printSkipParam|이라는...@>=
func printSkipParam(n int32) {
	switch n {
	case lineSkipCode: printEsc("lineskip")
	case baselineSkipCode: printEsc("baselineskip")
	case parSkipCode: printEsc("parskip")
	case aboveDisplaySkipCode: printEsc("abovedisplayskip")
	case belowDisplaySkipCode: printEsc("belowdisplayskip")
	case aboveDisplayShortSkipCode: printEsc("abovedisplayshortskip")
	case belowDisplayShortSkipCode: printEsc("belowdisplayshortskip")
	case leftSkipCode: printEsc("leftskip")
	case rightSkipCode: printEsc("rightskip")
	case topSkipCode: printEsc("topskip")
	case splitTopSkipCode: printEsc("splittopskip")
	case tabSkipCode: printEsc("tabskip")
	case spaceSkipCode: printEsc("spaceskip")
	case xspaceSkipCode: printEsc("xspaceskip")
	case parFillSkipCode: printEsc("parfillskip")
	case thinMuSkipCode: printEsc("thinmuskip")
	case medMuSkipCode: printEsc("medmuskip")
	case thickMuSkipCode: printEsc("thickmuskip")
	default: printStr("[unknown glue parameter!]")
	}
}

@ 글루 매개변수의 기호 이름은 나중에 정의할 루틴 |primitive|로 \TeX의 해시 표에 넣는다. 매개변수 이름들을 다른
데서 또 늘어놓지 않도록 여기서 넣어 두자. 이 장의 다른 매개변수들도 이렇게 정의하는 자리에서 곧바로
해시 표에 넣는다.

@<\TeX의 원시 명령을 저마다 해시 표에 넣는다@>=
primitive("lineskip", assignGlue, glueBase+lineSkipCode)
@!@:line_skip_}{\.{\\lineskip} primitive@>
primitive("baselineskip", assignGlue, glueBase+baselineSkipCode)
@!@:baseline_skip_}{\.{\\baselineskip} primitive@>
primitive("parskip", assignGlue, glueBase+parSkipCode)
@!@:par_skip_}{\.{\\parskip} primitive@>
primitive("abovedisplayskip", assignGlue, glueBase+aboveDisplaySkipCode)
@!@:above_display_skip_}{\.{\\abovedisplayskip} primitive@>
primitive("belowdisplayskip", assignGlue, glueBase+belowDisplaySkipCode)
@!@:below_display_skip_}{\.{\\belowdisplayskip} primitive@>
primitive("abovedisplayshortskip",
	assignGlue, glueBase+aboveDisplayShortSkipCode)
@!@:above_display_short_skip_}{\.{\\abovedisplayshortskip} primitive@>
primitive("belowdisplayshortskip",
	assignGlue, glueBase+belowDisplayShortSkipCode)
@!@:below_display_short_skip_}{\.{\\belowdisplayshortskip} primitive@>
primitive("leftskip", assignGlue, glueBase+leftSkipCode)
@!@:left_skip_}{\.{\\leftskip} primitive@>
primitive("rightskip", assignGlue, glueBase+rightSkipCode)
@!@:right_skip_}{\.{\\rightskip} primitive@>
primitive("topskip", assignGlue, glueBase+topSkipCode)
@!@:top_skip_}{\.{\\topskip} primitive@>
primitive("splittopskip", assignGlue, glueBase+splitTopSkipCode)
@!@:split_top_skip_}{\.{\\splittopskip} primitive@>
primitive("tabskip", assignGlue, glueBase+tabSkipCode)
@!@:tab_skip_}{\.{\\tabskip} primitive@>
primitive("spaceskip", assignGlue, glueBase+spaceSkipCode)
@!@:space_skip_}{\.{\\spaceskip} primitive@>
primitive("xspaceskip", assignGlue, glueBase+xspaceSkipCode)
@!@:xspace_skip_}{\.{\\xspaceskip} primitive@>
primitive("parfillskip", assignGlue, glueBase+parFillSkipCode)
@!@:par_fill_skip_}{\.{\\parfillskip} primitive@>
primitive("thinmuskip", assignMuGlue, glueBase+thinMuSkipCode)
@!@:thin_mu_skip_}{\.{\\thinmuskip} primitive@>
primitive("medmuskip", assignMuGlue, glueBase+medMuSkipCode)
@!@:med_mu_skip_}{\.{\\medmuskip} primitive@>
primitive("thickmuskip", assignMuGlue, glueBase+thickMuSkipCode)
@!@:thick_mu_skip_}{\.{\\thickmuskip} primitive@>

@ 앞에서 넣은 원시 명령들이 명령 코드와 수정자 값을 받아 그 이름을 거꾸로 찍는 부분이다. 수정자 값을 보면
매개변수인지, \.{\\skip} 레지스터인지, \.{\\muskip} 레지스터인지 알 수 있다.
@<원시 명령의 이름을 찍는 |printCmdChr|의 경우들@>=
case assignGlue, assignMuGlue:
	if chrCode < skipBase {
		printSkipParam(chrCode - glueBase)
	} else if chrCode < muSkipBase {
		printEsc("skip")
		printInt(chrCode - skipBase)
	} else {
		printEsc("muskip")
		printInt(chrCode - muSkipBase)
	}

@ 모든 글루 매개변수와 레지스터의 처음 값은 `\.{0pt plus0pt minus0pt}'이다. 모두 같은 명세 |zeroGlue|를
가리키므로, 그 참조 횟수를 가리키는 항목의 수만큼 늘려 둔다.

@<표의 항목들을 초기화한다...@>=
setEquiv(glueBase, zeroGlue)
setEqLevel(glueBase, levelOne)
setEqType(glueBase, glueRef)
for k = glueBase + 1; k <= localBase-1; k++ {
	eqtb[k] = eqtb[glueBase]
}
setGlueRefCount(zeroGlue, glueRefCount(zeroGlue)+localBase-glueBase)

@ 영역 3의 항목은 `\.{\\parskip=0.0pt plus 1.0pt}'처럼 이름과 글루 명세를 찍는다. 수식 글루의
단위는 \.{mu}다.
@<등가물 |n|을 보인다, 영역 3@>=
if n < skipBase {
	printSkipParam(n - glueBase)
	printChar('=')
	if n < glueBase+thinMuSkipCode {
		printSpec(equiv(n), "pt")
	} else {
		printSpec(equiv(n), "mu")
	}
} else if n < muSkipBase {
	printEsc("skip")
	printInt(n - skipBase)
	printChar('=')
	printSpec(equiv(n), "pt")
} else {
	printEsc("muskip")
	printInt(n - muSkipBase)
	printChar('=')
	printSpec(equiv(n), "mu")
}

@ 표 |eqtb|의 영역 4에는 여기서 정의하는 지역 양들이 들어 있다. 이 영역의 대부분은 8비트 문자를 첨자로 쓰는 표
다섯 개(\.{\\catcode}, \.{\\lccode}, \.{\\uccode}, \.{\\sfcode}, \.{\\mathcode})가 차지하는데, 이 표들은 \TeX의
구문 부분과 의미 부분 모두에 중요하다. 그 밖에 글꼴과 토큰 매개변수처럼 특별한 것들이 한 무더기 있고,
\.{\\toks}와 \.{\\box} 레지스터의 표도 있다.

@<\TeX의 원시 명령을...@>=
primitive("output", assignToks, outputRoutineLoc)
@!@:output_}{\.{\\output} primitive@>
primitive("everypar", assignToks, everyParLoc)
@!@:every_par_}{\.{\\everypar} primitive@>
primitive("everymath", assignToks, everyMathLoc)
@!@:every_math_}{\.{\\everymath} primitive@>
primitive("everydisplay", assignToks, everyDisplayLoc)
@!@:every_display_}{\.{\\everydisplay} primitive@>
primitive("everyhbox", assignToks, everyHboxLoc)
@!@:every_hbox_}{\.{\\everyhbox} primitive@>
primitive("everyvbox", assignToks, everyVboxLoc)
@!@:every_vbox_}{\.{\\everyvbox} primitive@>
primitive("everyjob", assignToks, everyJobLoc)
@!@:every_job_}{\.{\\everyjob} primitive@>
primitive("everycr", assignToks, everyCrLoc)
@!@:every_cr_}{\.{\\everycr} primitive@>
primitive("errhelp", assignToks, errHelpLoc)
@!@:err_help_}{\.{\\errhelp} primitive@>

@ 영역 4의 주소들이다. 상자 레지스터 |box(n)|를 바꾸는 함수는 규칙대로라면 |setBox|여야 하지만, 그 이름은 이미
명령 코드가 쓰고 있으므로(\secref{set-font}) |setBoxReg|라고 부른다.

@<정의@>=
const (
	@!parShapeLoc = localBase // 문단 모양을 지정한다
	@!outputRoutineLoc = localBase + 1 // \.{\\output}의 토큰 목록을 가리킨다
	@!everyParLoc = localBase + 2 // \.{\\everypar}의 토큰 목록을 가리킨다
	@!everyMathLoc = localBase + 3 // \.{\\everymath}의 토큰 목록을 가리킨다
	@!everyDisplayLoc = localBase + 4 // \.{\\everydisplay}의 토큰 목록을 가리킨다
	@!everyHboxLoc = localBase + 5 // \.{\\everyhbox}의 토큰 목록을 가리킨다
	@!everyVboxLoc = localBase + 6 // \.{\\everyvbox}의 토큰 목록을 가리킨다
	@!everyJobLoc = localBase + 7 // \.{\\everyjob}의 토큰 목록을 가리킨다
	@!everyCrLoc = localBase + 8 // \.{\\everycr}의 토큰 목록을 가리킨다
	@!errHelpLoc = localBase + 9 // \.{\\errhelp}의 토큰 목록을 가리킨다
	@!toksBase = localBase + 10 // 256개의 토큰 목록 레지스터의 표
	@!boxBase = toksBase + 256 // 256개의 상자 레지스터의 표
	@!curFontLoc = boxBase + 256 // 수식 모드 바깥의 내부 글꼴 번호
	@!mathFontBase = curFontLoc + 1 // 48개의 수식 글꼴 번호의 표
	@!catCodeBase = mathFontBase + 48 // 256개의 명령 코드(``catcode'')의 표
	@!lcCodeBase = catCodeBase + 256 // 256개의 소문자 대응의 표
	@!ucCodeBase = lcCodeBase + 256 // 256개의 대문자 대응의 표
	@!sfCodeBase = ucCodeBase + 256 // 256개의 공백 인자 대응의 표
	@!mathCodeBase = sfCodeBase + 256 // 256개의 수식 모드 대응의 표
	@!intBase = mathCodeBase + 256 // 영역 5의 시작
)

@ 영역 4의 등가물을 읽고 쓰는 함수들이다. 이를테면 |catCode(c)|는 문자 |c|의 지금 catcode다.

@<정의@>=
func parShapePtr() pointer   { return equiv(parShapeLoc) }
func outputRoutine() pointer  { return equiv(outputRoutineLoc) }
func everyPar() pointer       { return equiv(everyParLoc) }
func everyMath() pointer      { return equiv(everyMathLoc) }
func everyDisplay() pointer   { return equiv(everyDisplayLoc) }
func everyHbox() pointer      { return equiv(everyHboxLoc) }
func everyVbox() pointer      { return equiv(everyVboxLoc) }
func everyJob() pointer       { return equiv(everyJobLoc) }
func everyCr() pointer        { return equiv(everyCrLoc) }
func errHelp() pointer        { return equiv(errHelpLoc) }
func toks(n int32) pointer     { return equiv(toksBase + n) }
func box(n int32) pointer      { return equiv(boxBase + n) }
func setBoxReg(n int32, v pointer) { setEquiv(boxBase+n, v) }
func curFont() halfword       { return equiv(curFontLoc) }
func famFnt(n int32) halfword { return equiv(mathFontBase + n) }
func catCode(n int32) halfword { return equiv(catCodeBase + n) }
func setCatCode(n int32, v halfword) { setEquiv(catCodeBase+n, v) }
func lcCode(n int32) halfword  { return equiv(lcCodeBase + n) }
func setLcCode(n int32, v halfword) { setEquiv(lcCodeBase+n, v) }
func ucCode(n int32) halfword  { return equiv(ucCodeBase + n) }
func setUcCode(n int32, v halfword) { setEquiv(ucCodeBase+n, v) }
func sfCode(n int32) halfword  { return equiv(sfCodeBase + n) }
func setSfCode(n int32, v halfword) { setEquiv(sfCodeBase+n, v) }
func mathCode(n int32) halfword { return equiv(mathCodeBase + n) }
	// 주의: |mathCode(c)|는 참 수식 코드에 |minHalfword|를 더한 것이다
func setMathCode(n int32, v halfword) { setEquiv(mathCodeBase+n, v) }

@ 토큰 목록 매개변수와 \.{\\toks} 레지스터의 이름을 찍는 부분이다.
@<원시 명령의 이름을 찍는...@>=
case assignToks:
	if chrCode >= toksBase {
		printEsc("toks")
		printInt(chrCode - toksBase)
	} else {
		switch chrCode {
		case outputRoutineLoc:
			printEsc("output")
		case everyParLoc:
			printEsc("everypar")
		case everyMathLoc:
			printEsc("everymath")
		case everyDisplayLoc:
			printEsc("everydisplay")
		case everyHboxLoc:
			printEsc("everyhbox")
		case everyVboxLoc:
			printEsc("everyvbox")
		case everyJobLoc:
			printEsc("everyjob")
		case everyCrLoc:
			printEsc("everycr")
		default:
			printEsc("errhelp")
		}
	}

@ 대부분의 항목은 널 값이나 정의되지 않은 값으로 초기화한다. 정의되지 않은 글꼴은 내부 코드 |fontBase|로
나타낸다.

그러나 문자 코드 표들에는 {\mc ASCII} 코드의 관례적인 해석을 바탕으로 처음 값을 준다. 이를테면 글자의
catcode는 11, 역빗금은 0, 공백은 10, 퍼센트 기호는 14이고, \.{\\lccode}와 \.{\\uccode}는 영어 알파벳의 대소문자를
잇는다. 이 처음 값은 \TeX을 영어가 아닌 언어에 맞출 때에도 바꾸어서는 안 된다. 초기화 관례는 \TeX\ 자체가 아니라
포맷 꾸러미에서 바꾸어야 한다. 그래야 세계 곳곳에서 포맷을 서로 주고받을 수 있다.

@<표의 항목들을 초기화한다...@>=
setEquiv(parShapeLoc, null) // |parShapePtr=null|
setEqType(parShapeLoc, shapeRef); setEqLevel(parShapeLoc, levelOne)
for k = outputRoutineLoc; k <= toksBase+255; k++ {
	eqtb[k] = eqtb[undefinedControlSequence]
}
setBoxReg(0, null)
setEqType(boxBase, boxRef); setEqLevel(boxBase, levelOne)
for k = boxBase + 1; k <= boxBase+255; k++ {
	eqtb[k] = eqtb[boxBase]
}
setEquiv(curFontLoc, nullFont) // |curFont=nullFont|
setEqType(curFontLoc, data); setEqLevel(curFontLoc, levelOne)
for k = mathFontBase; k <= mathFontBase+47; k++ {
	eqtb[k] = eqtb[curFontLoc]
}
setEquiv(catCodeBase, 0)
setEqType(catCodeBase, data); setEqLevel(catCodeBase, levelOne)
for k = catCodeBase + 1; k <= intBase-1; k++ {
	eqtb[k] = eqtb[catCodeBase]
}
for k = 0; k <= 255; k++ {
	setCatCode(k, otherChar); setMathCode(k, hi(k)); setSfCode(k, 1000)
}
setCatCode(carriageReturn, carRet); setCatCode(' ', spacer)
setCatCode('\\', escape); setCatCode('%', comment)
setCatCode(invalidCode, invalidChar); setCatCode(nullCode, ignore)
for k = '0'; k <= '9'; k++ {
	setMathCode(k, hi(k+varCode))
}
for k = 'A'; k <= 'Z'; k++ {
	setCatCode(k, letter); setCatCode(k+'a'-'A', letter)
	setMathCode(k, hi(k+varCode+0x100))
	setMathCode(k+'a'-'A', hi(k+'a'-'A'+varCode+0x100))
	setLcCode(k, k+'a'-'A'); setLcCode(k+'a'-'A', k+'a'-'A')
	setUcCode(k, k); setUcCode(k+'a'-'A', k)
	setSfCode(k, 999)
}

@ 글꼴이 정해지지 않았음을 나타내는 |nullFont|와, ``현재 가족을 쓰라''는 뜻의 특별한 수식 코드 |varCode|다.
수식 코드가 |varCode| 이상이면, \.{\\fam}이 알맞은 값일 때 그 가족의 글꼴을 쓴다.
@<정의@>=
const (
	@!nullFont = fontBase
	@!varCode = 0o70000 // ``현재 가족을 쓰라''는 뜻의 수식 코드
)

@ 영역 4의 항목을 보여 준다. 문단 모양은 줄 수만, 토큰 목록은 그 내용을 32글자까지, 상자 레지스터는 상자의
내용을 찍는다.
@<등가물 |n|을 보인다, 영역 4@>=
if n == parShapeLoc {
	printEsc("parshape")
	printChar('=')
	if parShapePtr() == null {
		printChar('0')
	} else {
		printInt(info(parShapePtr()))
	}
} else if n < toksBase {
	printCmdChr(assignToks, n)
	printChar('=')
	if equiv(n) != null {
		showTokenList(link(equiv(n)), null, 32)
	}
} else if n < boxBase {
	printEsc("toks")
	printInt(n - toksBase)
	printChar('=')
	if equiv(n) != null {
		showTokenList(link(equiv(n)), null, 32)
	}
} else if n < curFontLoc {
	printEsc("box")
	printInt(n - boxBase)
	printChar('=')
	if equiv(n) == null {
		printStr("void")
	} else {
		depthThreshold = 0
		breadthMax = 1
		showNodeList(equiv(n))
	}
} else if n < catCodeBase {
	@<|eqtb[n]|의 글꼴 식별자를 보인다@>
} else {
	@<|eqtb[n]|의 하프워드 코드를 보인다@>
}

@ 글꼴 항목은 `\.{\\textfont1=\\teni}'처럼 글꼴 식별자를 찍는다.
@<|eqtb[n]|의 글꼴 식별자를...@>=
if n == curFontLoc {
	printStr("current font")
} else if n < mathFontBase+16 {
	printEsc("textfont")
	printInt(n - mathFontBase)
} else if n < mathFontBase+32 {
	printEsc("scriptfont")
	printInt(n - mathFontBase - 16)
} else {
	printEsc("scriptscriptfont")
	printInt(n - mathFontBase - 32)
}
printChar('=')
printEsc(hash[fontIDBase+equiv(n)].rh) // 이것은 |fontIDText(equiv(n))|이다

@ 문자 코드 표의 항목은 `\.{\\catcode92=0}'처럼 찍는다.
@<|eqtb[n]|의 하프워드...@>=
if n < mathCodeBase {
	if n < lcCodeBase {
		printEsc("catcode")
		printInt(n - catCodeBase)
	} else if n < ucCodeBase {
		printEsc("lccode")
		printInt(n - lcCodeBase)
	} else if n < sfCodeBase {
		printEsc("uccode")
		printInt(n - ucCodeBase)
	} else {
		printEsc("sfcode")
		printInt(n - sfCodeBase)
	}
	printChar('=')
	printInt(equiv(n))
} else {
	printEsc("mathcode")
	printInt(n - mathCodeBase)
	printChar('=')
	printInt(ho(equiv(n)))
}

@ 표 |eqtb|의 영역 5에는 여기서 정의하는 정수 매개변수와 레지스터, 그리고 표 |delCode|가 들어 있다. 이 표는
앞에 나온 |catCode..mathCode| 표들과 다르다. 구분자 코드는 온 낱말 정수인데, 다른 문자 코드들은 많아야
하프워드를 차지하기 때문이다. 영역~5를 영역~4와 따로 둔 까닭이 이것이다. 이 영역의 등가물에는 |eqLevel|을
넣을 자리가 없으므로, 그 정보는 나중에 정의할 쿼터워드 보조 배열에 저장한다.

이 절의 코드는 앞에서 본 |showBox|에서 쓴다. 상자를 보여 줄 깊이와 너비의 한계는 정수 매개변수
\.{\\showboxdepth}와 \.{\\showboxbreadth}에서 가져온다.

@<|depthThreshold|와 |breadthMax|의...@>=
depthThreshold = showBoxDepth()
breadthMax = showBoxBreadth()

@ 정수 매개변수의 코드들이다. 프로그램이 정수 매개변수에 직접 값을 넣는 곳은 몇 군데뿐이므로, 쓰는 함수는
그런 매개변수에만 둔다.

@<정의@>=
const (
	@!pretoleranceCode = 0 // 하이픈 넣기 전의 나쁨 허용치
	@!toleranceCode = 1 // 하이픈 넣은 뒤의 나쁨 허용치
	@!linePenaltyCode = 2 // 모든 줄의 나쁨에 더한다
	@!hyphenPenaltyCode = 3 // 선택적 하이픈 뒤에서 나누는 벌점
	@!exHyphenPenaltyCode = 4 // 명시적 하이픈 뒤에서 나누는 벌점
	@!clubPenaltyCode = 5 // 클럽 줄을 만드는 벌점
	@!widowPenaltyCode = 6 // 과부 줄을 만드는 벌점
	@!displayWidowPenaltyCode = 7 // 마찬가지, 따로 세운 수식 바로 앞에서
	@!brokenPenaltyCode = 8 // 나뉜 줄에서 쪽을 나누는 벌점
	@!binOpPenaltyCode = 9 // 이항 연산 뒤에서 나누는 벌점
	@!relPenaltyCode = 10 // 관계 기호 뒤에서 나누는 벌점
	@!preDisplayPenaltyCode = 11 // 따로 세운 수식 바로 앞에서 나누는 벌점
	@!postDisplayPenaltyCode = 12 // 따로 세운 수식 바로 뒤에서 나누는 벌점
	@!interLinePenaltyCode = 13 // 줄 사이의 추가 벌점
	@!doubleHyphenDemeritsCode = 14 // 하이픈 나눔이 겹칠 때의 감점
	@!finalHyphenDemeritsCode = 15 // 마지막 하이픈 나눔의 감점
	@!adjDemeritsCode = 16 // 서로 맞지 않는 이웃 줄의 감점
	@!magCode = 17 // 확대 비율
	@!delimiterFactorCode = 18 // 크기가 변하는 구분자의 비율
	@!loosenessCode = 19 // 문단의 줄 수를 바꾼다
	@!timeCode = 20 // 현재 시각
	@!dayCode = 21 // 현재 날짜
	@!monthCode = 22 // 현재 달
	@!yearCode = 23 // 현재 연도(서기)
	@!showBoxBreadthCode = 24 // |showBox|에서 수준마다 보일 노드 수
	@!showBoxDepthCode = 25 // |showBox|에서 보일 최대 수준
	@!hbadnessCode = 26 // 나쁨이 이것을 넘는 가로 상자는 |hpack|이 보여 준다
	@!vbadnessCode = 27 // 나쁨이 이것을 넘는 세로 상자는 |vpack|이 보여 준다
)

@ 앞 절에 이어 정수 매개변수의 코드를 정의한다.

@<정의@>=
const (
	@!pausingCode = 28 // 파일에서 줄을 하나 읽을 때마다 멈춘다
	@!tracingOnlineCode = 29 // 진단 출력을 터미널에 보인다
	@!tracingMacrosCode = 30 // 매크로를 펼칠 때 보인다
	@!tracingStatsCode = 31 // \TeX이 안다면 메모리 사용량을 보인다
	@!tracingParagraphsCode = 32 // 줄 나누기 계산을 보인다
	@!tracingPagesCode = 33 // 쪽 나누기 계산을 보인다
	@!tracingOutputCode = 34 // 상자를 내보낼 때 보인다
	@!tracingLostCharsCode = 35 // 글꼴에 없는 문자를 보인다
	@!tracingCommandsCode = 36 // |bigSwitch|에서 명령 코드를 보인다
	@!tracingRestoresCode = 37 // 등가물을 되살릴 때 보인다
	@!ucHyphCode = 38 // 대문자로 시작하는 낱말에도 하이픈을 넣는다
	@!outputPenaltyCode = 39 // 현재 쪽 나눔에서 찾은 벌점
	@!maxDeadCyclesCode = 40 // 출력의 헛돈 주기가 잇달아 일어날 수 있는 한계
	@!hangAfterCode = 41 // 매달린 들여쓰기가 이만큼의 줄 뒤에 바뀐다
	@!floatingPenaltyCode = 42 // 쪼갠 뒤에 남겨진 삽입의 벌점
	@!globalDefsCode = 43 // \.{\\global} 지정을 무시한다
	@!curFamCode = 44 // 현재 가족
	@!escapeCharCode = 45 // 토큰을 출력할 때의 탈출 문자
	@!defaultHyphenCharCode = 46 // 글꼴을 실을 때 \.{\\hyphenchar}의 값
	@!defaultSkewCharCode = 47 // 글꼴을 실을 때 \.{\\skewchar}의 값
	@!endLineCharCode = 48 // 버퍼의 오른쪽 끝에 놓는 문자
	@!newLineCharCode = 49 // |printLn|으로 찍히는 문자
	@!languageCode = 50 // 현재의 하이픈 넣기 표
	@!leftHyphenMinCode = 51 // 하이픈 왼쪽 조각의 최소 크기
	@!rightHyphenMinCode = 52 // 하이픈 오른쪽 조각의 최소 크기
	@!holdingInsertsCode = 53 // \.{\\box255}에서 삽입 노드를 없애지 않는다
	@!errorContextLinesCode = 54 // 보여 줄 중간 줄 쌍의 최대 개수
	@!intPars = 55 // 정수 매개변수의 총수
	@!countBase = intBase + intPars // 사용자의 \.{\\count} 레지스터 256개
	@!delCodeBase = countBase + 256 // 256개의 구분자 코드 대응
	@!dimenBase = delCodeBase + 256 // 영역 6의 시작
)

@ 영역 5의 정수들을 읽는 함수들이다. 이를테면 |tolerance()|는 지금의 \.{\\tolerance} 값이다.

@<정의@>=
func delCode(n int32) int32          { return eqtb[delCodeBase+n].sc }
func setDelCode(n int32, v int32)   { eqtb[delCodeBase+n].sc = v }
func count(n int32) int32             { return eqtb[countBase+n].sc }
func intPar(n int32) int32           { return eqtb[intBase+n].sc } // 정수 매개변수
func setIntPar(n int32, v int32)    { eqtb[intBase+n].sc = v }
func pretolerance() int32 { return intPar(pretoleranceCode) }
func tolerance() int32 { return intPar(toleranceCode) }
func linePenalty() int32 { return intPar(linePenaltyCode) }
func hyphenPenalty() int32 { return intPar(hyphenPenaltyCode) }
func exHyphenPenalty() int32 { return intPar(exHyphenPenaltyCode) }
func clubPenalty() int32 { return intPar(clubPenaltyCode) }
func widowPenalty() int32 { return intPar(widowPenaltyCode) }
func displayWidowPenalty() int32 { return intPar(displayWidowPenaltyCode) }
func brokenPenalty() int32 { return intPar(brokenPenaltyCode) }
func binOpPenalty() int32 { return intPar(binOpPenaltyCode) }
func relPenalty() int32 { return intPar(relPenaltyCode) }
func preDisplayPenalty() int32 { return intPar(preDisplayPenaltyCode) }
func postDisplayPenalty() int32 { return intPar(postDisplayPenaltyCode) }
func interLinePenalty() int32 { return intPar(interLinePenaltyCode) }
func doubleHyphenDemerits() int32 { return intPar(doubleHyphenDemeritsCode) }
func finalHyphenDemerits() int32 { return intPar(finalHyphenDemeritsCode) }
func adjDemerits() int32 { return intPar(adjDemeritsCode) }
func mag() int32 { return intPar(magCode) }
func delimiterFactor() int32 { return intPar(delimiterFactorCode) }
func looseness() int32 { return intPar(loosenessCode) }
func time() int32 { return intPar(timeCode) }
func day() int32 { return intPar(dayCode) }
func month() int32 { return intPar(monthCode) }
func year() int32 { return intPar(yearCode) }
func showBoxBreadth() int32 { return intPar(showBoxBreadthCode) }
func showBoxDepth() int32 { return intPar(showBoxDepthCode) }
func hbadness() int32 { return intPar(hbadnessCode) }
func vbadness() int32 { return intPar(vbadnessCode) }
func pausing() int32 { return intPar(pausingCode) }

@ 앞 절에 이어 정수 매개변수를 읽고 쓰는 함수들이다.

@<정의@>=
func tracingOnline() int32 { return intPar(tracingOnlineCode) }
func tracingMacros() int32 { return intPar(tracingMacrosCode) }
func tracingStats() int32 { return intPar(tracingStatsCode) }
func tracingParagraphs() int32 { return intPar(tracingParagraphsCode) }
func tracingPages() int32 { return intPar(tracingPagesCode) }
func tracingOutput() int32 { return intPar(tracingOutputCode) }
func tracingLostChars() int32 { return intPar(tracingLostCharsCode) }
func tracingCommands() int32 { return intPar(tracingCommandsCode) }
func tracingRestores() int32 { return intPar(tracingRestoresCode) }
func ucHyph() int32 { return intPar(ucHyphCode) }
func outputPenalty() int32 { return intPar(outputPenaltyCode) }
func maxDeadCycles() int32 { return intPar(maxDeadCyclesCode) }
func hangAfter() int32 { return intPar(hangAfterCode) }
func floatingPenalty() int32 { return intPar(floatingPenaltyCode) }
func globalDefs() int32 { return intPar(globalDefsCode) }
func curFam() int32 { return intPar(curFamCode) }
func escapeChar() int32 { return intPar(escapeCharCode) }
func defaultHyphenChar() int32 { return intPar(defaultHyphenCharCode) }
func defaultSkewChar() int32 { return intPar(defaultSkewCharCode) }
func endLineChar() int32 { return intPar(endLineCharCode) }
func newLineChar() int32 { return intPar(newLineCharCode) }
func language() int32 { return intPar(languageCode) }
func leftHyphenMin() int32 { return intPar(leftHyphenMinCode) }
func rightHyphenMin() int32 { return intPar(rightHyphenMinCode) }
func holdingInserts() int32 { return intPar(holdingInsertsCode) }
func errorContextLines() int32 { return intPar(errorContextLinesCode) }
func setMag(v int32)               { setIntPar(magCode, v) }
func setTolerance(v int32)         { setIntPar(toleranceCode, v) }
func setTime(v int32)              { setIntPar(timeCode, v) }
func setDay(v int32)               { setIntPar(dayCode, v) }
func setMonth(v int32)             { setIntPar(monthCode, v) }
func setYear(v int32)              { setIntPar(yearCode, v) }
func setVbadness(v int32)          { setIntPar(vbadnessCode, v) }
func setTracingStats(v int32)     { setIntPar(tracingStatsCode, v) }
func setMaxDeadCycles(v int32)   { setIntPar(maxDeadCyclesCode, v) }
func setHangAfter(v int32)        { setIntPar(hangAfterCode, v) }
func setEscapeChar(v int32)       { setIntPar(escapeCharCode, v) }
func setEndLineChar(v int32)     { setIntPar(endLineCharCode, v) }
func setNewLineChar(v int32)     { setIntPar(newLineCharCode, v) }

@ 정수 매개변수의 기호 이름은 다음과 같이 찍는다.

@<함수들@>=
func printParam(n int32) {
	switch n {
	case pretoleranceCode: printEsc("pretolerance")
	case toleranceCode: printEsc("tolerance")
	case linePenaltyCode: printEsc("linepenalty")
	case hyphenPenaltyCode: printEsc("hyphenpenalty")
	case exHyphenPenaltyCode: printEsc("exhyphenpenalty")
	case clubPenaltyCode: printEsc("clubpenalty")
	case widowPenaltyCode: printEsc("widowpenalty")
	case displayWidowPenaltyCode: printEsc("displaywidowpenalty")
	case brokenPenaltyCode: printEsc("brokenpenalty")
	case binOpPenaltyCode: printEsc("binoppenalty")
	case relPenaltyCode: printEsc("relpenalty")
	case preDisplayPenaltyCode: printEsc("predisplaypenalty")
	case postDisplayPenaltyCode: printEsc("postdisplaypenalty")
	case interLinePenaltyCode: printEsc("interlinepenalty")
	case doubleHyphenDemeritsCode: printEsc("doublehyphendemerits")
	case finalHyphenDemeritsCode: printEsc("finalhyphendemerits")
	case adjDemeritsCode: printEsc("adjdemerits")
	case magCode: printEsc("mag")
	case delimiterFactorCode: printEsc("delimiterfactor")
	case loosenessCode: printEsc("looseness")
	case timeCode: printEsc("time")
	case dayCode: printEsc("day")
	case monthCode: printEsc("month")
	case yearCode: printEsc("year")
	case showBoxBreadthCode: printEsc("showboxbreadth")
	case showBoxDepthCode: printEsc("showboxdepth")
	case hbadnessCode: printEsc("hbadness")
	case vbadnessCode: printEsc("vbadness")
	case pausingCode: printEsc("pausing")
	@<|printParam|의 나머지 경우들@>
	default: printStr("[unknown integer parameter!]")
	}
}

@ 앞 절에 이어지는 경우들이다.

@<|printParam|의 나머지...@>=
case tracingOnlineCode: printEsc("tracingonline")
case tracingMacrosCode: printEsc("tracingmacros")
case tracingStatsCode: printEsc("tracingstats")
case tracingParagraphsCode: printEsc("tracingparagraphs")
case tracingPagesCode: printEsc("tracingpages")
case tracingOutputCode: printEsc("tracingoutput")
case tracingLostCharsCode: printEsc("tracinglostchars")
case tracingCommandsCode: printEsc("tracingcommands")
case tracingRestoresCode: printEsc("tracingrestores")
case ucHyphCode: printEsc("uchyph")
case outputPenaltyCode: printEsc("outputpenalty")
case maxDeadCyclesCode: printEsc("maxdeadcycles")
case hangAfterCode: printEsc("hangafter")
case floatingPenaltyCode: printEsc("floatingpenalty")
case globalDefsCode: printEsc("globaldefs")
case curFamCode: printEsc("fam")
case escapeCharCode: printEsc("escapechar")
case defaultHyphenCharCode: printEsc("defaulthyphenchar")
case defaultSkewCharCode: printEsc("defaultskewchar")
case endLineCharCode: printEsc("endlinechar")
case newLineCharCode: printEsc("newlinechar")
case languageCode: printEsc("language")
case leftHyphenMinCode: printEsc("lefthyphenmin")
case rightHyphenMinCode: printEsc("righthyphenmin")
case holdingInsertsCode: printEsc("holdinginserts")
case errorContextLinesCode: printEsc("errorcontextlines")

@ 정수 매개변수의 이름들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("pretolerance", assignInt, intBase+pretoleranceCode)
@!@:pretolerance_}{\.{\\pretolerance} primitive@>
primitive("tolerance", assignInt, intBase+toleranceCode)
@!@:tolerance_}{\.{\\tolerance} primitive@>
primitive("linepenalty", assignInt, intBase+linePenaltyCode)
@!@:line_penalty_}{\.{\\linepenalty} primitive@>
primitive("hyphenpenalty", assignInt, intBase+hyphenPenaltyCode)
@!@:hyphen_penalty_}{\.{\\hyphenpenalty} primitive@>
primitive("exhyphenpenalty", assignInt, intBase+exHyphenPenaltyCode)
@!@:ex_hyphen_penalty_}{\.{\\exhyphenpenalty} primitive@>
primitive("clubpenalty", assignInt, intBase+clubPenaltyCode)
@!@:club_penalty_}{\.{\\clubpenalty} primitive@>
primitive("widowpenalty", assignInt, intBase+widowPenaltyCode)
@!@:widow_penalty_}{\.{\\widowpenalty} primitive@>
primitive("displaywidowpenalty", assignInt, intBase+displayWidowPenaltyCode)
@!@:display_widow_penalty_}{\.{\\displaywidowpenalty} primitive@>
primitive("brokenpenalty", assignInt, intBase+brokenPenaltyCode)
@!@:broken_penalty_}{\.{\\brokenpenalty} primitive@>
primitive("binoppenalty", assignInt, intBase+binOpPenaltyCode)
@!@:bin_op_penalty_}{\.{\\binoppenalty} primitive@>
primitive("relpenalty", assignInt, intBase+relPenaltyCode)
@!@:rel_penalty_}{\.{\\relpenalty} primitive@>
primitive("predisplaypenalty", assignInt, intBase+preDisplayPenaltyCode)
@!@:pre_display_penalty_}{\.{\\predisplaypenalty} primitive@>
primitive("postdisplaypenalty", assignInt, intBase+postDisplayPenaltyCode)
@!@:post_display_penalty_}{\.{\\postdisplaypenalty} primitive@>
primitive("interlinepenalty", assignInt, intBase+interLinePenaltyCode)
@!@:inter_line_penalty_}{\.{\\interlinepenalty} primitive@>
primitive("doublehyphendemerits", assignInt, intBase+doubleHyphenDemeritsCode)
@!@:double_hyphen_demerits_}{\.{\\doublehyphendemerits} primitive@>
primitive("finalhyphendemerits", assignInt, intBase+finalHyphenDemeritsCode)
@!@:final_hyphen_demerits_}{\.{\\finalhyphendemerits} primitive@>
primitive("adjdemerits", assignInt, intBase+adjDemeritsCode)
@!@:adj_demerits_}{\.{\\adjdemerits} primitive@>
primitive("mag", assignInt, intBase+magCode)
@!@:mag_}{\.{\\mag} primitive@>
primitive("delimiterfactor", assignInt, intBase+delimiterFactorCode)
@!@:delimiter_factor_}{\.{\\delimiterfactor} primitive@>
primitive("looseness", assignInt, intBase+loosenessCode)
@!@:looseness_}{\.{\\looseness} primitive@>
primitive("time", assignInt, intBase+timeCode)
@!@:time_}{\.{\\time} primitive@>
primitive("day", assignInt, intBase+dayCode)
@!@:day_}{\.{\\day} primitive@>
primitive("month", assignInt, intBase+monthCode)
@!@:month_}{\.{\\month} primitive@>
primitive("year", assignInt, intBase+yearCode)
@!@:year_}{\.{\\year} primitive@>
primitive("showboxbreadth", assignInt, intBase+showBoxBreadthCode)
@!@:show_box_breadth_}{\.{\\showboxbreadth} primitive@>
primitive("showboxdepth", assignInt, intBase+showBoxDepthCode)
@!@:show_box_depth_}{\.{\\showboxdepth} primitive@>
primitive("hbadness", assignInt, intBase+hbadnessCode)
@!@:hbadness_}{\.{\\hbadness} primitive@>
primitive("vbadness", assignInt, intBase+vbadnessCode)
@!@:vbadness_}{\.{\\vbadness} primitive@>
primitive("pausing", assignInt, intBase+pausingCode)
@!@:pausing_}{\.{\\pausing} primitive@>

@ 앞 절에 이어 나머지 정수 매개변수의 이름들을 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("tracingonline", assignInt, intBase+tracingOnlineCode)
@!@:tracing_online_}{\.{\\tracingonline} primitive@>
primitive("tracingmacros", assignInt, intBase+tracingMacrosCode)
@!@:tracing_macros_}{\.{\\tracingmacros} primitive@>
primitive("tracingstats", assignInt, intBase+tracingStatsCode)
@!@:tracing_stats_}{\.{\\tracingstats} primitive@>
primitive("tracingparagraphs", assignInt, intBase+tracingParagraphsCode)
@!@:tracing_paragraphs_}{\.{\\tracingparagraphs} primitive@>
primitive("tracingpages", assignInt, intBase+tracingPagesCode)
@!@:tracing_pages_}{\.{\\tracingpages} primitive@>
primitive("tracingoutput", assignInt, intBase+tracingOutputCode)
@!@:tracing_output_}{\.{\\tracingoutput} primitive@>
primitive("tracinglostchars", assignInt, intBase+tracingLostCharsCode)
@!@:tracing_lost_chars_}{\.{\\tracinglostchars} primitive@>
primitive("tracingcommands", assignInt, intBase+tracingCommandsCode)
@!@:tracing_commands_}{\.{\\tracingcommands} primitive@>
primitive("tracingrestores", assignInt, intBase+tracingRestoresCode)
@!@:tracing_restores_}{\.{\\tracingrestores} primitive@>
primitive("uchyph", assignInt, intBase+ucHyphCode)
@!@:uc_hyph_}{\.{\\uchyph} primitive@>
primitive("outputpenalty", assignInt, intBase+outputPenaltyCode)
@!@:output_penalty_}{\.{\\outputpenalty} primitive@>
primitive("maxdeadcycles", assignInt, intBase+maxDeadCyclesCode)
@!@:max_dead_cycles_}{\.{\\maxdeadcycles} primitive@>
primitive("hangafter", assignInt, intBase+hangAfterCode)
@!@:hang_after_}{\.{\\hangafter} primitive@>
primitive("floatingpenalty", assignInt, intBase+floatingPenaltyCode)
@!@:floating_penalty_}{\.{\\floatingpenalty} primitive@>
primitive("globaldefs", assignInt, intBase+globalDefsCode)
@!@:global_defs_}{\.{\\globaldefs} primitive@>
primitive("fam", assignInt, intBase+curFamCode)
@!@:fam_}{\.{\\fam} primitive@>
primitive("escapechar", assignInt, intBase+escapeCharCode)
@!@:escape_char_}{\.{\\escapechar} primitive@>
primitive("defaulthyphenchar", assignInt, intBase+defaultHyphenCharCode)
@!@:default_hyphen_char_}{\.{\\defaulthyphenchar} primitive@>
primitive("defaultskewchar", assignInt, intBase+defaultSkewCharCode)
@!@:default_skew_char_}{\.{\\defaultskewchar} primitive@>
primitive("endlinechar", assignInt, intBase+endLineCharCode)
@!@:end_line_char_}{\.{\\endlinechar} primitive@>
primitive("newlinechar", assignInt, intBase+newLineCharCode)
@!@:new_line_char_}{\.{\\newlinechar} primitive@>
primitive("language", assignInt, intBase+languageCode)
@!@:language_}{\.{\\language} primitive@>
primitive("lefthyphenmin", assignInt, intBase+leftHyphenMinCode)
@!@:left_hyphen_min_}{\.{\\lefthyphenmin} primitive@>
primitive("righthyphenmin", assignInt, intBase+rightHyphenMinCode)
@!@:right_hyphen_min_}{\.{\\righthyphenmin} primitive@>
primitive("holdinginserts", assignInt, intBase+holdingInsertsCode)
@!@:holding_inserts_}{\.{\\holdinginserts} primitive@>
primitive("errorcontextlines", assignInt, intBase+errorContextLinesCode)
@!@:error_context_lines_}{\.{\\errorcontextlines} primitive@>

@ 정수 매개변수와 \.{\\count} 레지스터의 이름을 찍는 부분이다.
@<원시 명령의 이름을 찍는...@>=
case assignInt:
	if chrCode < countBase {
		printParam(chrCode - intBase)
	} else {
		printEsc("count")
		printInt(chrCode - countBase)
	}

@ 정수 매개변수의 처음 값은 원래 매크로 꾸러미가 정해야 한다. 다음 초기화는 \TeX이 완전히 헛돌지 않을 만큼만
한다. 이를테면 \.{\\mag}는 확대하지 않는다는 뜻의 1000으로, \.{\\tolerance}는 어떤 문단이든 받아들이는
10000으로, \.{\\escapechar}는 역빗금으로, \.{\\endlinechar}는 줄 끝마다 덧붙일 캐리지 리턴으로 둔다. 구분자 코드 \.{\\delcode}는 모두 $-1$로 두되, 마침표만은 0으로 두어 \.{\\left.}처럼 쓰는
``널 구분자''가 되게 한다.
@^null delimiter@>

@<표의 항목들을 초기화한다...@>=
for k = intBase; k <= delCodeBase-1; k++ {
	eqtb[k].sc = 0
}
setMag(1000)
setTolerance(10000)
setHangAfter(1)
setMaxDeadCycles(25)
setEscapeChar('\\')
setEndLineChar(carriageReturn)
for k = 0; k <= 255; k++ {
	setDelCode(k, -1)
}
setDelCode('.', 0) // 이 널 구분자는 오류 복구에 쓰인다

@ 다음 프로시저는 \TeX이 입력과 출력을 초기화하기 바로 전에 불려서 날짜와 시각의 처음 값을 정한다.
@^system dependencies@>
날짜와 시각을 얻는 방법은 시스템마다 다르므로 무언가 특별한 것이 필요하다. 여기서는 그저 알맞은 값이 전역
변수 |sysTime|, |sysDay|, |sysMonth|, |sysYear|에 들어온다고 가정한다(구현하는 사람이 깜빡할 경우에 대비해
1776년 7월 4일 정오로 초기화해 둔다). \GO/라면 |time| 꾸러미로 현재 날짜와 시각을 쉽게 얻을 수 있겠지만, 이
``자명한 진리''를 그대로 두면 같은 입력에서 언제나 같은 출력이 나오므로 결과를 견주어 보기에 좋다.

@<함수들@>=
func fixDateAndTime() {
	sysTime = 12 * 60
	sysDay = 4
	sysMonth = 7
	sysYear = 1776 // 자명한 진리들
	setTime(sysTime) // 자정부터 센 분
	setDay(sysDay) // 그 달의 날
	setMonth(sysMonth) // 그 해의 달
	setYear(sysYear) // 서기
}

@ @<등가물 |n|을 보인다, 영역 5@>=
if n < countBase {
	printParam(n - intBase)
} else if n < delCodeBase {
	printEsc("count")
	printInt(n - countBase)
} else {
	printEsc("delcode")
	printInt(n - delCodeBase)
}
printChar('=')
printInt(eqtb[n].sc)

@ @<변수 |c|를 현재의...@>=
c := escapeChar() // 탈출 문자의 코드

@ @<문자 |s|가 현재의...@>=
s == newLineChar()

@ \TeX은 이따금 진단 정보를 찍어야 하는데, |tracingOnline|이 양수가 아니면 그것은 기록 파일에만 들어간다. 다음은
찍는 곳을 그렇게 조정하는 두 루틴이다. 루틴 |beginDiagnostic|은 지금의 |selector|를 |oldSetting|에 저장하고
필요하면 터미널 출력을 끄며, |endDiagnostic|은 그것을 되돌린다. 진단 정보를 찍었다는 것도 |history|에 경고로
남긴다.

@<함수들@>=
func beginDiagnostic() { // 추적할 준비를 한다
	oldSetting = selector
	if tracingOnline() <= 0 && selector == termAndLog {
		selector--
		if history == spotless {
			history = warningIssued
		}
	}
}

func endDiagnostic(blankLine bool) { // 추적한 뒤에 알맞은 상태를 되살린다
	printNl("")
	if blankLine {
		printLn()
	}
	selector = oldSetting
}

@ 물론 앞의 루틴들이 돌아가려면 전역 변수를 몇 개 더 선언해야 한다.

@<전역 변수@>=
var @!oldSetting int32 // |0 .. maxSelector|
var @!sysTime, @!sysDay, @!sysMonth, @!sysYear int32 // 바깥 시스템이 주는 날짜와 시각

@ 표 |eqtb|의 마지막 영역에는 여기서 정의하는 치수 매개변수와 256개의 \.{\\dimen} 레지스터가 들어 있다.

@<함수들@>=
const (
	@!parIndentCode = 0 // 문단의 들여쓰기
	@!mathSurroundCode = 1 // 본문 속 수식 둘레의 간격
	@!lineSkipLimitCode = 2 // |baselineSkip| 대신 |lineSkip|을 쓰는 문턱값
	@!hsizeCode = 3 // 가로 모드의 줄 너비
	@!vsizeCode = 4 // 세로 모드의 쪽 높이
	@!maxDepthCode = 5 // 본문 쪽에서 상자 깊이의 최댓값
	@!splitMaxDepthCode = 6 // 쪼갠 쪽에서 상자 깊이의 최댓값
	@!boxMaxDepthCode = 7 // 명시적 세로 상자의 최대 깊이
	@!hfuzzCode = 8 // 꽉 찬 가로 상자 메시지의 허용치
	@!vfuzzCode = 9 // 꽉 찬 세로 상자 메시지의 허용치
	@!delimiterShortfallCode = 10 // 크기가 변하는 구분자가 덮지 못해도 되는 최대량
	@!nullDelimiterSpaceCode = 11 // 널 구분자의 빈 간격
	@!scriptSpaceCode = 12 // 아래첨자나 위첨자 뒤의 추가 간격
	@!preDisplaySizeCode = 13 // 따로 세운 수식 앞 텍스트의 길이
	@!displayWidthCode = 14 // 따로 세운 수식의 줄 길이
	@!displayIndentCode = 15 // 따로 세운 수식의 줄 들여쓰기
	@!overfullRuleCode = 16 // 꽉 찬 가로 상자를 알리는 괘선의 너비
	@!hangIndentCode = 17 // 매달린 들여쓰기의 양
	@!hOffsetCode = 18 // 쪽을 내보낼 때 가로 어긋남의 양
	@!vOffsetCode = 19 // 쪽을 내보낼 때 세로 어긋남의 양
	@!emergencyStretchCode = 20 // 줄 나누기의 마지막 단계에서 나쁨을 줄인다
	@!dimenPars = 21 // 치수 매개변수의 총수
	@!scaledBase = dimenBase + dimenPars // 사용자가 정의하는 \.{\\dimen} 레지스터 256개의 표
	@!eqtbSize = scaledBase + 255 // |eqtb|의 가장 큰 첨자
)

@ 영역 6의 치수들을 읽고 쓰는 함수들이다. 이를테면 |hsize()|는 지금의 \.{\\hsize}다.

@<함수들@>=
func dimen(n int32) scaled         { return eqtb[scaledBase+n].sc }
func dimenPar(n int32) scaled     { return eqtb[dimenBase+n].sc } // 눈금 양
func setDimenPar(n int32, v scaled) { eqtb[dimenBase+n].sc = v }
func parIndent() scaled { return dimenPar(parIndentCode) }
func mathSurround() scaled { return dimenPar(mathSurroundCode) }
func lineSkipLimit() scaled { return dimenPar(lineSkipLimitCode) }
func hsize() scaled { return dimenPar(hsizeCode) }
func vsize() scaled { return dimenPar(vsizeCode) }
func maxDepth() scaled { return dimenPar(maxDepthCode) }
func splitMaxDepth() scaled { return dimenPar(splitMaxDepthCode) }
func boxMaxDepth() scaled { return dimenPar(boxMaxDepthCode) }
func hfuzz() scaled { return dimenPar(hfuzzCode) }
func vfuzz() scaled { return dimenPar(vfuzzCode) }
func delimiterShortfall() scaled { return dimenPar(delimiterShortfallCode) }
func nullDelimiterSpace() scaled { return dimenPar(nullDelimiterSpaceCode) }
func scriptSpace() scaled { return dimenPar(scriptSpaceCode) }
func preDisplaySize() scaled { return dimenPar(preDisplaySizeCode) }
func displayWidth() scaled { return dimenPar(displayWidthCode) }
func displayIndent() scaled { return dimenPar(displayIndentCode) }
func overfullRule() scaled { return dimenPar(overfullRuleCode) }
func hangIndent() scaled { return dimenPar(hangIndentCode) }
func hOffset() scaled { return dimenPar(hOffsetCode) }
func vOffset() scaled { return dimenPar(vOffsetCode) }
func emergencyStretch() scaled { return dimenPar(emergencyStretchCode) }
func setVfuzz(v scaled)         { setDimenPar(vfuzzCode, v) }
func setOverfullRule(v scaled) { setDimenPar(overfullRuleCode, v) }

@ 다음 프로시저는 치수 매개변수의 기호 이름을 찍는다.

@<함수들@>=
func printLengthParam(n int32) {
	switch n {
	case parIndentCode: printEsc("parindent")
	case mathSurroundCode: printEsc("mathsurround")
	case lineSkipLimitCode: printEsc("lineskiplimit")
	case hsizeCode: printEsc("hsize")
	case vsizeCode: printEsc("vsize")
	case maxDepthCode: printEsc("maxdepth")
	case splitMaxDepthCode: printEsc("splitmaxdepth")
	case boxMaxDepthCode: printEsc("boxmaxdepth")
	case hfuzzCode: printEsc("hfuzz")
	case vfuzzCode: printEsc("vfuzz")
	case delimiterShortfallCode: printEsc("delimitershortfall")
	case nullDelimiterSpaceCode: printEsc("nulldelimiterspace")
	case scriptSpaceCode: printEsc("scriptspace")
	case preDisplaySizeCode: printEsc("predisplaysize")
	case displayWidthCode: printEsc("displaywidth")
	case displayIndentCode: printEsc("displayindent")
	case overfullRuleCode: printEsc("overfullrule")
	case hangIndentCode: printEsc("hangindent")
	case hOffsetCode: printEsc("hoffset")
	case vOffsetCode: printEsc("voffset")
	case emergencyStretchCode: printEsc("emergencystretch")
	default: printStr("[unknown dimen parameter!]")
	}
}

@ @<\TeX의 원시 명령을...@>=
primitive("parindent", assignDimen, dimenBase+parIndentCode)
@!@:par_indent_}{\.{\\parindent} primitive@>
primitive("mathsurround", assignDimen, dimenBase+mathSurroundCode)
@!@:math_surround_}{\.{\\mathsurround} primitive@>
primitive("lineskiplimit", assignDimen, dimenBase+lineSkipLimitCode)
@!@:line_skip_limit_}{\.{\\lineskiplimit} primitive@>
primitive("hsize", assignDimen, dimenBase+hsizeCode)
@!@:hsize_}{\.{\\hsize} primitive@>
primitive("vsize", assignDimen, dimenBase+vsizeCode)
@!@:vsize_}{\.{\\vsize} primitive@>
primitive("maxdepth", assignDimen, dimenBase+maxDepthCode)
@!@:max_depth_}{\.{\\maxdepth} primitive@>
primitive("splitmaxdepth", assignDimen, dimenBase+splitMaxDepthCode)
@!@:split_max_depth_}{\.{\\splitmaxdepth} primitive@>
primitive("boxmaxdepth", assignDimen, dimenBase+boxMaxDepthCode)
@!@:box_max_depth_}{\.{\\boxmaxdepth} primitive@>
primitive("hfuzz", assignDimen, dimenBase+hfuzzCode)
@!@:hfuzz_}{\.{\\hfuzz} primitive@>
primitive("vfuzz", assignDimen, dimenBase+vfuzzCode)
@!@:vfuzz_}{\.{\\vfuzz} primitive@>
primitive("delimitershortfall", assignDimen, dimenBase+delimiterShortfallCode)
@!@:delimiter_shortfall_}{\.{\\delimitershortfall} primitive@>
primitive("nulldelimiterspace", assignDimen, dimenBase+nullDelimiterSpaceCode)
@!@:null_delimiter_space_}{\.{\\nulldelimiterspace} primitive@>
primitive("scriptspace", assignDimen, dimenBase+scriptSpaceCode)
@!@:script_space_}{\.{\\scriptspace} primitive@>
primitive("predisplaysize", assignDimen, dimenBase+preDisplaySizeCode)
@!@:pre_display_size_}{\.{\\predisplaysize} primitive@>
primitive("displaywidth", assignDimen, dimenBase+displayWidthCode)
@!@:display_width_}{\.{\\displaywidth} primitive@>
primitive("displayindent", assignDimen, dimenBase+displayIndentCode)
@!@:display_indent_}{\.{\\displayindent} primitive@>
primitive("overfullrule", assignDimen, dimenBase+overfullRuleCode)
@!@:overfull_rule_}{\.{\\overfullrule} primitive@>
primitive("hangindent", assignDimen, dimenBase+hangIndentCode)
@!@:hang_indent_}{\.{\\hangindent} primitive@>
primitive("hoffset", assignDimen, dimenBase+hOffsetCode)
@!@:h_offset_}{\.{\\hoffset} primitive@>
primitive("voffset", assignDimen, dimenBase+vOffsetCode)
@!@:v_offset_}{\.{\\voffset} primitive@>
primitive("emergencystretch", assignDimen, dimenBase+emergencyStretchCode)
@!@:emergency_stretch_}{\.{\\emergencystretch} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case assignDimen:
	if chrCode < scaledBase {
		printLengthParam(chrCode - dimenBase)
	} else {
		printEsc("dimen")
		printInt(chrCode - scaledBase)
	}

@ 치수 매개변수와 \.{\\dimen} 레지스터는 모두 0pt로 시작한다.
@<표의 항목들을 초기화한다...@>=
for k = dimenBase; k <= eqtbSize; k++ {
	eqtb[k].sc = 0
}

@ 치수 항목은 `\.{\\hsize=469.75499pt}'처럼 찍는다.
@<등가물 |n|을 보인다, 영역 6@>=
if n < scaledBase {
	printLengthParam(n - dimenBase)
} else {
	printEsc("dimen")
	printInt(n - scaledBase)
}
printChar('=')
printScaled(eqtb[n].sc)
printStr("pt")

@ 다음은 |eqtb[n]|의 내용을 기호로 보여 주는 프로시저다. 첨자 |n|이 어느 영역에 있는지 보고 앞에서 마련한 절들
가운데 하나로 간다. 매개변수 \.{\\tracingrestores}가 양수일 때 그룹이 끝나며 되살린 값을 보여 주는 것이 이
프로시저다.

@<함수들@>=
@<|printCmdChr|라는 프로시저를 선언한다@>
func showEqtb(n pointer) {
	if n < activeBase {
		printChar('?') // 이런 일은 일어날 수 없다
	} else if n < glueBase {
		@<등가물 |n|을 보인다, 영역 1이나 2@>
	} else if n < localBase {
		@<등가물 |n|을 보인다, 영역 3@>
	} else if n < intBase {
		@<등가물 |n|을 보인다, 영역 4@>
	} else if n < dimenBase {
		@<등가물 |n|을 보인다, 영역 5@>
	} else if n <= eqtbSize {
		@<등가물 |n|을 보인다, 영역 6@>
	} else {
		printChar('?') // 이것도 일어날 수 없다
	}
}

@ \seclabel{xeq-level}표 |eqtb|의 마지막 두 영역에는 세 필드 |eqLevel|, |eqType|, |equiv| 대신 온 낱말 값이
들어 있다. 이 영역에는 |eqType|이 필요 없다. 항목이 무엇인지는 주소만 보면 알 수 있기 때문이다. 그러나
|eqLevel| 정보는 있어야 하므로 \TeX은 그것을 |xeqLevel|이라는 다른 배열에 저장한다.

배열 |xeqLevel|의 첨자는 |intBase|에서 시작하면 되지만, \GO/의 배열은 첨자가 0에서 시작하므로 |eqtbSize+1|개를
잡고 |intBase|보다 작은 칸은 쓰지 않는다. 표 |eqtb|도 마찬가지로 칸 0을 쓰지 않는다.

@<전역 변수@>=
var @!eqtb [eqtbSize + 1]memoryWord
var @!xeqLevel [eqtbSize + 1]quarterword

@ 처음에는 영역 5와 6의 항목이 모두 바깥 수준에서 정의된 것으로 둔다.
@<핵심 변수들의...@>=
for k = intBase; k <= eqtbSize; k++ {
	xeqLevel[k] = levelOne
}

@ 디버깅 루틴 |searchMem|이 주어진 값을 가진 포인터를 찾을 때, |eqtb|에서는 영역 1부터~3까지와 영역~4의 앞부분만
보면 된다. 포인터를 담는 항목은 거기에만 있기 때문이다.

@<|eqtb|에서 |p|와 같은...@>=
for q = activeBase; q <= boxBase+255; q++ {
	if equiv(q) == p {
		printNl("EQUIV(")
		printInt(q)
		printChar(')')
	}
}

@* 해시 표.
제어 시퀀스는 ``합쳐지는 목록''(coalescing lists)이라는 꽤 표준적인 해시 표 알고리즘으로 넣고
꺼낸다({\sl The Art of Computer Programming}의 알고리즘 6.4C 참조). 제어 시퀀스는 한번 표에 들어가면 결코
지워지지 않는다. 그룹이 끝날 때 제어 시퀀스를 지우면 \.{\\gdef}가 얽힌 복잡한 상황에서 실수가 생길 수
있고, 그것을 막으려면 복잡한 참조 횟수 장치를 따로 들여와야 하기 때문이다. 이름 하나가 차지하는 공간은
작으니 지우지 않는 편이 훨씬 간단하다.

제어 시퀀스 이름을 이루는 실제 글자들은 다른 문자열과 함께 배열 |strPool|에 들어 있다. 보조 배열 |hash|의
항목은 하프워드 필드 둘로 된 낱말이다. 첫째 |next(p)|는 위치 |p|의 이름과 같은 합쳐진 목록에 속하는 다음
이름을 가리키고, 둘째 |text(p)|는 위치 |p|의 이름이 든 문자열의 번호다. 해시 표의 위치~|p|가 비어 있으면
|text(p)=0|이다. 위치 |p|가 비어 있거나 합쳐진 목록의 끝이면 |next(p)=0|이다. 보조 포인터 변수 |hashUsed|는
|p>=hashUsed|인 위치가 모두 비어 있지 않도록 유지한다. 새 항목을 넣을 빈칸은 이 포인터를 아래로 옮겨 가며
찾는다. 전역 변수 |csCount|는 통계를 모을 때 여러 글자짜리 제어 시퀀스가 몇 개 정의되었는지 알려 준다.

전역 불 변수 |noNewControlSequence|가 |true|인 동안에는 해시 표에 새 항목을 넣을 수 없다. 그래서 보통의 텍스트를
읽다가 정의되지 않은 이름을 만나도 해시 표에 넣지 않는다. 새 이름은 |getToken|으로 읽을 때(이를테면 \.{\\def}
바로 뒤의 이름)와 \.{\\csname}에서만 들어간다(\secref{get-token}).

배열 |hash|의 첨자는 |hashBase|에서 시작하면 되지만, 여기서는 0부터 잡고 앞쪽 칸은 쓰지 않는다.

@<전역 변수@>=
func next(p pointer) halfword       { return hash[p].lh } // 합쳐진 목록의 연결
func setNext(p pointer, v halfword) { hash[p].lh = v }
func text(p pointer) strNumber      { return hash[p].rh } // 제어 시퀀스 이름의 문자열 번호
func setText(p pointer, v strNumber) { hash[p].rh = v }
func hashIsFull() bool             { return hashUsed == hashBase } // 모든 위치가 찼는지 검사한다
func fontIDText(f int32) strNumber { return text(fontIDBase + f) } // 얼어 있는 글꼴 식별자의 이름
func setFontIDText(f int32, v strNumber) { setText(fontIDBase+f, v) }

var @!hash [undefinedControlSequence]twoHalves // 해시 표
var @!hashUsed pointer // |hash|의 할당 포인터
var @!noNewControlSequence bool // 새 식별자가 허용되나?
var @!csCount int32 // 알려진 식별자의 총수

@ 처음에는 해시 표가 모두 비어 있고, 새 이름을 넣는 것은 금지되어 있다.
@<핵심 변수들의...@>=
noNewControlSequence = true // 새 식별자는 보통 금지된다
setNext(hashBase, 0)
setText(hashBase, 0)
for k = hashBase + 1; k <= undefinedControlSequence-1; k++ {
	hash[k] = hash[hashBase]
}

@ \.{INITEX}는 해시 표를 쓰기 시작하기 전에 빈칸 찾기 포인터 |hashUsed|를 표의 맨 위로 놓는다. 또 얼린 제어 시퀀스
|frozenDontExpand|에 이름 `\.{notexpanded:}'를 붙여 둔다. 명령 \.{\\noexpand}로 펼치지 않기로 한 토큰은 잠시 이것으로
바뀌는데, 오류 메시지에 그 이름이 나올 수 있기 때문이다.
@<표의 항목들을 초기화한다...@>=
hashUsed = frozenControlSequence // 아무것도 쓰이지 않았다
csCount = 0
setEqType(frozenDontExpand, dontExpand)
setText(frozenDontExpand, str("notexpanded:"))
@.notexpanded:@>

@ 다음은 |buffer[j..(j+l-1)]|에 있는 길이 |l>1|인 문자열과 같은 이름을 해시 표에서 찾는 서브루틴이다. 이름을
찾으면 그 해시 표 주소를 돌려준다. 찾지 못했을 때는, 전역 변수 |noNewControlSequence|가 |true|이면 가짜 주소
|undefinedControlSequence|를 돌려주고, 그렇지 않으면 이름을 해시 표에 넣고 그 위치를 돌려준다.

합쳐지는 목록 방법의 요점은 이렇다. 해시 값 $h$에 해당하는 위치에서 찾기 시작해서 |next| 연결을
따라간다. 찾지 못하면 표의 높은 쪽 끝에서부터 아래로 빈칸을 찾아(|hashUsed|를 줄여 가며) 거기에 새 항목을
넣고, 목록의 끝에 이어 붙인다. 이렇게 하다 보면 서로 다른 해시 값의 목록들이 한데 합쳐질 수 있으므로
``합쳐지는'' 목록이라고 한다. 넘친 항목을 위한 영역을 따로 두지 않고 표 하나로 해결하는 점이 좋다.

@<함수들@>=
func idLookup(j, l int32) pointer { // 해시 표를 찾는다
	var h int32 // 해시 코드
	var d int32 // 아직 덜 만든 현재 문자열의 문자 수
	var p pointer // 배열 |hash|의 첨자
	var k pointer // 배열 |buffer|의 첨자
	@<해시 코드 |h|를 계산한다@>
	p = h + hashBase // 여기서 찾기 시작한다; |0<=h<hashPrime|임에 주목하라
	for {
		if text(p) > 0 {
			if length(text(p)) == l {
				if strEqBuf(text(p), j) {
					goto found
				}
			}
		}
		if next(p) == 0 {
			if noNewControlSequence {
				p = undefinedControlSequence
			} else {
				@<|p| 뒤에 새 제어 시퀀스를 넣고 |p|가 그것을 가리키게 한다@>
			}
			goto found
		}
		p = next(p)
	}
found:
	return p
}

@ 이름을 찾지 못해 새로 넣는 경우다. 해시 값의 위치 |p|가 이미 차 있으면 위에서부터 빈칸을 찾아 |p|의
목록 끝에 잇고, 그 칸을 새 이름의 자리로 삼는다. 그다음 이름의 글자들을 문자열 풀에 옮겨 새 문자열을
만든다. 지금 만들다 만 문자열이 있으면 그것을 |l|칸 위로 밀어 올려 자리를 비우고, 그 아래에 새
이름을 넣는다.
@<|p| 뒤에 새 제어...@>=
if text(p) > 0 {
	for {
		if hashIsFull() {
			overflow("hash size", hashSize)
		}
@:TeX capacity exceeded hash size}{\quad hash size@>
		hashUsed--
		if text(hashUsed) == 0 {
			break
		}
	} // |hash|에서 빈 위치를 찾는다
	setNext(p, hashUsed)
	p = hashUsed
}
strRoom(l)
d = curLength()
for poolPtr > strStart[strPtr] {
	poolPtr--
	strPool[poolPtr+l] = strPool[poolPtr]
} // 다른 문자열을 위한 자리를 만들려고 현재 문자열을 위로 옮긴다
for k = j; k <= j+l-1; k++ {
	appendChar(buffer[k])
}
setText(p, makeString())
poolPtr += d
if stat {
	csCount++
}

@ 상수 |hashPrime|은 |hashSize|의 85\pct!쯤 되는 소수여야 한다. 해싱 이론에 따르면 그러면 찾기에 성공할 때
표를 평균 두 번도 들여다보지 않으리라 기대할 수 있다. [J.~S. Vitter, {\sl Journal of the ACM\/ \bf30} (1983),
231--258쪽을 보라.] 해시 값은 이름의 글자들을 앞에서부터 차례로 읽으며 $h\leftarrow2h+c$를 |hashPrime|으로
나눈 나머지로 계산한다.
@^Vitter, Jeffrey Scott@>

@<해시 코드 |h|를...@>=
h = buffer[j]
for k = j + 1; k <= j+l-1; k++ {
	h = h + h + buffer[k]
	for h >= hashPrime {
		h -= hashPrime
	}
}

@ 한 글자짜리 제어 시퀀스는 해시 표에서 찾을 필요가 없다. 문자 코드 자체를 곧바로 주소로 쓸 수 있기
때문이다. 프로시저 |printCs|는 |eqtb| 안의 주소를 받아서 그 제어 시퀀스의 이름을 찍는다. 이름 뒤에는 공백을
하나 찍는다. 다만 이름이 글자가 아닌 문자 하나이거나 능동 문자이면 공백을 찍지 않는다. 이렇게 하면 찍은
것을 \TeX이 다시 읽었을 때 똑같이 읽힌다. 이를테면 \.{\\a}\.{b}와 \.{\\ab}는 다르다. 이 프로시저는 엉뚱한
자료로 불릴 수도 있으므로 ``아주 튼튼하다.'' 이름의 글자들은 찍을 수 없는 것일 수도 있으므로
|printStr|로 하나씩 찍어야 한다.

@<기본 인쇄...@>=
func printCs(p int32) { // 제어 시퀀스라고 여겨지는 것을 찍는다
	if p < hashBase { // 한 문자
		if p >= singleBase {
			if p == nullCs {
				printEsc("csname")
				printEsc("endcsname")
				printChar(' ')
			} else {
				printEsc(p - singleBase)
				if catCode(p-singleBase) == letter {
					printChar(' ')
				}
			}
		} else if p < activeBase {
			printEsc("IMPOSSIBLE.")
@.IMPOSSIBLE@>
		} else {
			printStr(p - activeBase)
		}
	} else if p >= undefinedControlSequence {
		printEsc("IMPOSSIBLE.")
	} else if text(p) < 0 || text(p) >= strPtr {
		printEsc("NONEXISTENT.")
@.NONEXISTENT@>
	} else {
		printEsc(text(p))
		printChar(' ')
	}
}

@ 다음은 비슷한 프로시저다. 오류 검사를 하지 않고, 제어 시퀀스 뒤에 공백을 결코 찍지 않는다. 명령 \.{\\string}이나
\.{\\show}처럼 이름만 깔끔하게 찍어야 할 때 쓴다.

@<기본 인쇄...@>=
func sprintCs(p pointer) { // 제어 시퀀스를 찍는다
	if p < hashBase {
		if p < singleBase {
			printStr(p - activeBase)
		} else if p < nullCs {
			printEsc(p - singleBase)
		} else {
			printEsc("csname")
			printEsc("endcsname")
		}
	} else {
		printEsc(text(p))
	}
}

@ \TeX의 ``원시'' 제어 시퀀스들은 그 명령 코드(|eqType|이 된다)와 피연산자(|equiv|가 된다)와 함께 해시 표에
넣어야 한다. 이 일은 프로시저 |primitive|가 하는데, 이것은 \TeX\ 사용자로서는 결코 흉내 낼 수 없는 방식이다.
프로시저 |primitive|가 일을 마치면 전역 값 |curVal|에 새 |eqtb| 포인터가 들어 있다. 이를테면
|primitive("hbox",makeBox,vtopCode+hmode)|는 \.{\\hbox}라는 이름을 명령 코드 |makeBox|와 수정자
|vtopCode+hmode|로 정의한다.

원시 명령의 이름 |s|는 \GO/ 문자열 상수다. 이름이 한 글자가 아니면 그것을 버퍼로 옮겨 |idLookup|을 부른다.
그러면 |idLookup|이 같은 문자열을 풀에 새로 만들어 |text(curVal)|에 넣어 준다.

@<함수들@>=
func primitive(s string, c quarterword, o halfword) {
	var j smallNumber // |buffer|의 첨자
	var l smallNumber // 문자열의 길이
	if len(s) == 1 {
		curVal = asciiCode(s[0]) + singleBase
	} else {
		l = int32(len(s)) // |s|를 (비어 있는) |buffer|로 옮길 것이다
		for j = 0; j <= l-1; j++ {
			buffer[j] = xord[s[j]]
		}
		curVal = idLookup(0, l) // |noNewControlSequence|는 |false|다
	}
	setEqLevel(curVal, levelOne)
	setEqType(curVal, c)
	setEquiv(curVal, o)
}

@ \TeX의 원시 명령 가운데 많은 것은 |equiv|가 필요 없다. 명령 코드 |eqType|만으로 알아볼 수 있기 때문이다. 이런 원시
명령들은 다음과 같이 해시 표에 싣는다. 수정자는 0이다.

@<\TeX의 원시 명령을...@>=
primitive(" ", exSpace, 0)
@!@:Single-character primitives /}{\quad\.{\\\ }@>
primitive("/", italCorr, 0)
@!@:Single-character primitives /}{\quad\.{\\/}@>
primitive("accent", accent, 0)
@!@:accent_}{\.{\\accent} primitive@>
primitive("advance", advance, 0)
@!@:advance_}{\.{\\advance} primitive@>
primitive("afterassignment", afterAssignment, 0)
@!@:after_assignment_}{\.{\\afterassignment} primitive@>
primitive("aftergroup", afterGroup, 0)
@!@:after_group_}{\.{\\aftergroup} primitive@>
primitive("begingroup", beginGroup, 0)
@!@:begin_group_}{\.{\\begingroup} primitive@>
primitive("char", charNum, 0)
@!@:char_}{\.{\\char} primitive@>
primitive("csname", csName, 0)
@!@:cs_name_}{\.{\\csname} primitive@>
primitive("delimiter", delimNum, 0)
@!@:delimiter_}{\.{\\delimiter} primitive@>
primitive("divide", divide, 0)
@!@:divide_}{\.{\\divide} primitive@>
primitive("endcsname", endCsName, 0)
@!@:end_cs_name_}{\.{\\endcsname} primitive@>
primitive("endgroup", endGroup, 0)
@!@:end_group_}{\.{\\endgroup} primitive@>
setText(frozenEndGroup, str("endgroup"))
eqtb[frozenEndGroup] = eqtb[curVal]
primitive("expandafter", expandAfter, 0)
@!@:expand_after_}{\.{\\expandafter} primitive@>
primitive("font", defFont, 0)
@!@:font_}{\.{\\font} primitive@>
primitive("fontdimen", assignFontDimen, 0)
@!@:font_dimen_}{\.{\\fontdimen} primitive@>
primitive("halign", halign, 0)
@!@:halign_}{\.{\\halign} primitive@>
primitive("hrule", hrule, 0)
@!@:hrule_}{\.{\\hrule} primitive@>
primitive("ignorespaces", ignoreSpaces, 0)
@!@:ignore_spaces_}{\.{\\ignorespaces} primitive@>
primitive("insert", insert, 0)
@!@:insert_}{\.{\\insert} primitive@>
primitive("mark", mark, 0)
@!@:mark_}{\.{\\mark} primitive@>
primitive("mathaccent", mathAccent, 0)
@!@:math_accent_}{\.{\\mathaccent} primitive@>
primitive("mathchar", mathCharNum, 0)
@!@:math_char_}{\.{\\mathchar} primitive@>
primitive("mathchoice", mathChoice, 0)
@!@:math_choice_}{\.{\\mathchoice} primitive@>
primitive("multiply", multiply, 0)
@!@:multiply_}{\.{\\multiply} primitive@>

@ 앞 절에 이어 수정자가 필요 없는 원시 명령들을 싣는다.

@<\TeX의 원시 명령을...@>=
primitive("noalign", noAlign, 0)
@!@:no_align_}{\.{\\noalign} primitive@>
primitive("noboundary", noBoundary, 0)
@!@:no_boundary_}{\.{\\noboundary} primitive@>
primitive("noexpand", noExpand, 0)
@!@:no_expand_}{\.{\\noexpand} primitive@>
primitive("nonscript", nonScript, 0)
@!@:non_script_}{\.{\\nonscript} primitive@>
primitive("omit", omit, 0)
@!@:omit_}{\.{\\omit} primitive@>
primitive("parshape", setShape, 0)
@!@:par_shape_}{\.{\\parshape} primitive@>
primitive("penalty", breakPenalty, 0)
@!@:penalty_}{\.{\\penalty} primitive@>
primitive("prevgraf", setPrevGraf, 0)
@!@:prev_graf_}{\.{\\prevgraf} primitive@>
primitive("radical", radical, 0)
@!@:radical_}{\.{\\radical} primitive@>
primitive("read", readToCs, 0)
@!@:read_}{\.{\\read} primitive@>
primitive("relax", relax, 256) // |scanFileName| 참조
@!@:relax_}{\.{\\relax} primitive@>
setText(frozenRelax, str("relax"))
eqtb[frozenRelax] = eqtb[curVal]
primitive("setbox", setBox, 0)
@!@:set_box_}{\.{\\setbox} primitive@>
primitive("the", the, 0)
@!@:the_}{\.{\\the} primitive@>
primitive("toks", toksRegister, 0)
@!@:toks_}{\.{\\toks} primitive@>
primitive("vadjust", vadjust, 0)
@!@:vadjust_}{\.{\\vadjust} primitive@>
primitive("valign", valign, 0)
@!@:valign_}{\.{\\valign} primitive@>
primitive("vcenter", vcenter, 0)
@!@:vcenter_}{\.{\\vcenter} primitive@>
primitive("vrule", vrule, 0)
@!@:vrule_}{\.{\\vrule} primitive@>

@ 원시 명령마다 그 역에 해당하는 코드가 있어서, |eqtb|에 담긴 알쏭달쏭한 수를 기호 꼴로 보여 줄 수 있다. 그래서
이 프로그램에서 |primitive|를 부르는 곳에는 언제나, 뒤에 나오는 루틴 |printCmdChr|의 일부가 될 간단한 코드가
따라온다. 이를테면 \.{\\show\\accent}가 `\.{\\accent=\\accent}'를 찍을 수 있는 것은 이 코드 덕분이다.

@<원시 명령의 이름을 찍는...@>=
case accent: printEsc("accent")
case advance: printEsc("advance")
case afterAssignment: printEsc("afterassignment")
case afterGroup: printEsc("aftergroup")
case assignFontDimen: printEsc("fontdimen")
case beginGroup: printEsc("begingroup")
case breakPenalty: printEsc("penalty")
case charNum: printEsc("char")
case csName: printEsc("csname")
case defFont: printEsc("font")
case delimNum: printEsc("delimiter")
case divide: printEsc("divide")
case endCsName: printEsc("endcsname")
case endGroup: printEsc("endgroup")
case exSpace: printEsc(" ")
case expandAfter: printEsc("expandafter")
case halign: printEsc("halign")
case hrule: printEsc("hrule")
case ignoreSpaces: printEsc("ignorespaces")
case insert: printEsc("insert")
case italCorr: printEsc("/")
case mark: printEsc("mark")
case mathAccent: printEsc("mathaccent")
case mathCharNum: printEsc("mathchar")
case mathChoice: printEsc("mathchoice")
case multiply: printEsc("multiply")

@ 앞 절에 이어지는 경우들이다.

@<원시 명령의 이름을 찍는...@>=
case noAlign: printEsc("noalign")
case noBoundary: printEsc("noboundary")
case noExpand: printEsc("noexpand")
case nonScript: printEsc("nonscript")
case omit: printEsc("omit")
case radical: printEsc("radical")
case readToCs: printEsc("read")
case relax: printEsc("relax")
case setBox: printEsc("setbox")
case setPrevGraf: printEsc("prevgraf")
case setShape: printEsc("parshape")
case the: printEsc("the")
case toksRegister: printEsc("toks")
case vadjust: printEsc("vadjust")
case valign: printEsc("valign")
case vcenter: printEsc("vcenter")
case vrule: printEsc("vrule")

@ 나머지 원시 명령들은 나중에 그 |eqType|과 |equiv| 값이 더 뜻있게 되는 자리에서 다룬다. 이를테면 수식 모드의 원시
명령들은 수식을 다루는 루틴들을 살펴볼 때 싣는다. 원시 명령마다 어디서 다루었는지는 끝의 찾아보기를 보면 쉽게
알 수 있다. 이를테면 |"radical"|을 |eqtb|에 넣은 절은 `\.{\\radical} primitive' 항목에 적혀 있다.
(`\.{\\/}'처럼 알파벳이 아닌 문자 하나로 된 원시 명령은 `Single-character primitives' 항목에 적혀 있다.)
@!@^Single-character primitives@>

그런데 해시 표를 정의하기 전에는 할 수 없었던 일이 하나 있으니, 여기서 마저 해 두자. 글꼴 번호를 받아 그
글꼴의 식별자 이름(\.{\\tenrm} 같은 것)을 찍는 일이다. 글꼴 식별자의 이름은 해시 표의 얼린 영역에 들어 있다.

@<|font(p)|의 글꼴 식별자를...@>=
printEsc(fontIDText(font(p)))

@* 등가물 저장과 복원.
\TeX의 `$\.{\char'173}\ldots\.{\char'175}$' 그룹은 중첩 구조를 이룬다. 그래서 바깥 그룹에서 유효한 |eqtb|
항목을 중괄호 안에서 덮어쓰면, 옛 값을 저장해 두었다가 나중에 되살려야 한다. 그래서 |eqtb|에 새 값을 넣을 때
프로그램은 지금 있는 항목이 바깥 수준에 속하는지 검사한다. 그렇다면 새 값이 |eqtb|에 들어가기 바로 전에 옛 값을
|saveStack|에 쌓는다. 그룹이 끝날 때, 곧 오른쪽 중괄호를 알아챌 때에는 |saveStack|을 써서 바깥 값들을 되살리고
안쪽 값들은 버린다.

스택 |saveStack|의 항목은 형이 |memoryWord|다. 이 스택의 맨 위 항목은 |saveStack[p]|이고 여기서
|p=savePtr-1|이다. 항목에는 |saveType|, |saveLevel|, |saveIndex|라는 세 필드가 있고, 다음 네 가지 가운데 한
가지로 해석한다.

\yskip\hangg 1) |saveType(p)=restoreOldValue|이면 |saveIndex(p)|는 |eqtb|의 위치다. 그 위치의 현재 값은 현재
그룹이 끝날 때 버리고 |saveStack[p-1]|로 바꾸어야 한다. 또 |saveIndex(p)>=intBase|이면 |saveLevel(p)|로
|xeqLevel|의 해당 항목도 바꾸어야 한다.

\yskip\hangg 2) |saveType(p)=restoreZero|이면 |saveIndex(p)|는 |eqtb|의 위치다. 그 위치의 현재 값은 현재 그룹이
끝날 때 버리고 |eqtb[undefinedControlSequence]|의 값, 곧 ``정의되지 않음''으로 바꾸어야 한다. 그룹 안에서
처음 정의한 매크로가 그룹 밖에서 사라지는 것이 이 경우다.

\yskip\hangg 3) |saveType(p)=insertToken|이면 |saveIndex(p)|는 현재 그룹이 끝날 때 \TeX의 입력에 끼워 넣어야 할
토큰이다. 이 항목은 \.{\\aftergroup}이 만든다.

\yskip\hangg 4) |saveType(p)=levelBoundary|이면 |saveLevel(p)|은 그 앞에 어떤 종류의 그룹 안에 있었는지 말해 주는
코드이고, |saveIndex(p)|는 그 바깥 그룹의 수준 경계 낱말을 가리킨다.

\yskip\noindent
보기를 들어 보자. 바깥 수준에서 \.{\\count1=5}로 한 뒤에 `\.{\char'173\\count1=7 \\def\\a\char'173x\char'175
\char'173\\count1=9 }'까지 읽었고, \.{\\a}는 그 전에 정의된 적이 없다고 하자. 그러면 |saveStack|은 다음 그림과
같다. 바깥쪽 `\.{\char'173}'가 0번 칸에, 안쪽 `\.{\char'173}'가 4번 칸에 수준 경계를 쌓았고, |curBoundary|는 맨
안쪽 그룹의 경계를 가리킨다. 4번 칸의 |saveIndex|는 바깥 그룹의 경계, 곧 0번 칸을 가리키므로 경계들은 스택
안에서 사슬을 이룬다. 레지스터 \.{\\count1}은 그룹마다 처음 바뀔 때 한 번씩만 옛 값이 저장된다. 같은 그룹 안에서
다시 바꿀 때는 수준이 이미 |curLevel|이므로 아무것도 쌓지 않는다. 안쪽 `\.{\char'175}'를 만나면 |unsave|가
위에서부터 4번 칸까지 항목을 하나씩 꺼내 \.{\\count1}을 7로 되돌리고, |curBoundary|를 0으로 돌려놓는다.
$$\mplibcode
beginfig(11);
save r, w; numeric r, w; r := 13pt; w := 230pt;
def slot(expr i)(text t) =
  draw (0,i*r)--(w,i*r)--(w,(i+1)*r)--(0,(i+1)*r)--cycle;
  label(t, (w/2,(i+.5)*r));
  label.lft(textext("\eightpoint " & decimal i), (-4pt,(i+.5)*r));
enddef;
slot(0)(btex \eightpoint \ID{levelBoundary}, 그룹 코드 \ID{bottomLevel}, 경계 0 etex);
slot(1)(btex \eightpoint \cs{count1}의 옛 값 5 etex);
slot(2)(btex \eightpoint \ID{restoreOldValue}, 수준 1, \cs{count1}의 위치 etex);
slot(3)(btex \eightpoint \ID{restoreZero}, \cs{a}의 위치 etex);
slot(4)(btex \eightpoint \ID{levelBoundary}, 그룹 코드 \ID{simpleGroup}, 경계 0 etex);
slot(5)(btex \eightpoint \cs{count1}의 옛 값 7 etex);
slot(6)(btex \eightpoint \ID{restoreOldValue}, 수준 2, \cs{count1}의 위치 etex);
draw (0,7r)--(0,8r) dashed evenly; draw (w,7r)--(w,8r) dashed evenly;
drawarrow (w+40pt,7.5r)--(w+4pt,7.5r); label.rt(btex \eightpoint \ID{savePtr} etex, (w+40pt,7.5r));
drawarrow (w+40pt,4.5r)--(w+4pt,4.5r); label.rt(btex \eightpoint \ID{curBoundary} etex, (w+40pt,4.5r));
drawarrow (w+2pt,4.3r){right} .. (w+24pt,2.4r) .. {left}(w+2pt,.5r);
label.rt(btex \eightpoint \ID{saveIndex} etex, (w+24pt,2.4r));
endfig;
\endmplibcode$$

@<정의@>=
func saveType(p int32) quarterword        { return saveStack[p].hh.b0 } // |saveStack| 항목을 분류한다
func setSaveType(p int32, v quarterword) { saveStack[p].hh.b0 = v }
func saveLevel(p int32) quarterword       { return saveStack[p].hh.b1 } // 영역 5와 6을 위해 저장한 수준, 또는 그룹 코드
func setSaveLevel(p int32, v quarterword) { saveStack[p].hh.b1 = v }
func saveIndex(p int32) halfword          { return saveStack[p].hh.rh } // |eqtb| 위치나 토큰이나 |saveStack| 위치
func setSaveIndex(p int32, v halfword)   { saveStack[p].hh.rh = v }

const (
	@!restoreOldValue = iota // 값을 나중에 되살려야 할 때의 |saveType|
	@!restoreZero // 정의되지 않은 항목을 되살려야 할 때의 |saveType|
	@!insertToken // 토큰을 나중에 쓰려고 저장할 때의 |saveType|
	@!levelBoundary // 그룹의 시작에 해당하는 |saveType|
)

@ 다음은 그룹의 종류를 가리는 그룹 코드들이다. 이 코드가 있어야 \TeX은 그룹이 끝날 때 어떤 특별한 일을 해야
하는지(해야 한다면) 정할 수 있다. 이를테면 \.{\\hbox}의 그룹이 끝나면 그 안의 목록을 상자로 꾸려야 하고,
그냥 중괄호 그룹이 끝나면 값만 되살리면 된다.
\def\grp{\.{\char'173...\char'175}}

어떤 그룹은 오른쪽 중괄호로 끝나서는 안 된다. 이를테면 수식을 시작하는 `\.\$'는 |mathShiftGroup|을 시작하는데,
이 그룹은 짝이 맞는 `\.\$'로 끝나야 한다. 마찬가지로 \.{\\left}로 시작한 그룹은 \.{\\right}로, \.{\\begingroup}으로
시작한 그룹은 \.{\\endgroup}으로 끝나야 한다. 짝이 맞지 않으면 \TeX은 그룹 코드를 보고 알맞은 오류 메시지를 낸다.

@<전역 형@>=
const (
	@!bottomLevel = 0 // 바깥 세계의 그룹 코드
	@!simpleGroup = 1 // 지역 구조만을 위한 그룹 코드
	@!hboxGroup = 2 // `\.{\\hbox}\grp'의 코드
	@!adjustedHboxGroup = 3 // 세로 모드에서 `\.{\\hbox}\grp'의 코드
	@!vboxGroup = 4 // `\.{\\vbox}\grp'의 코드
	@!vtopGroup = 5 // `\.{\\vtop}\grp'의 코드
	@!alignGroup = 6 // `\.{\\halign}\grp', `\.{\\valign}\grp'의 코드
	@!noAlignGroup = 7 // `\.{\\noalign}\grp'의 코드
	@!outputGroup = 8 // 출력 루틴의 코드
	@!mathGroup = 9 // 이를테면 `\.{\char'136}\grp'의 코드
	@!discGroup = 10 // `\.{\\discretionary}\grp\grp\grp'의 코드
	@!insertGroup = 11 // `\.{\\insert}\grp', `\.{\\vadjust}\grp'의 코드
	@!vcenterGroup = 12 // `\.{\\vcenter}\grp'의 코드
	@!mathChoiceGroup = 13 // `\.{\\mathchoice}\grp\grp\grp\grp'의 코드
	@!semiSimpleGroup = 14 // `\.{\\begingroup...\\endgroup}'의 코드
	@!mathShiftGroup = 15 // `\.{\$...\$}'의 코드
	@!mathLeftGroup = 16 // `\.{\\left...\\right}'의 코드
	@!maxGroupCode = 16
)

type @!groupCode = int32 // 수준 경계의 |saveLevel|; |0 .. maxGroupCode|

@ 전역 변수 |curGroup|은 지금 어떤 종류의 그룹 안에 있는지 기억한다. 또 하나의 전역 변수 |curBoundary|는 맨 위의
|levelBoundary| 낱말을 가리키고, |curLevel|은 지금 그룹이 몇 겹으로 중첩되어 있는지 나타낸다. 루틴들은
|saveStack|과 |eqtb|의 어떤 항목도 수준이 |curLevel|보다 높지 않도록 짜여 있다.

@ @<전역 변수@>=
var @!saveStack [saveSize + 1]memoryWord
var @!savePtr int32 // |saveStack|에서 쓰이지 않는 첫 항목; |0 .. saveSize|
var @!maxSaveStack int32 // 저장 스택의 최대 사용량
var @!curLevel quarterword // 그룹의 현재 중첩 수준
var @!curGroup groupCode // 현재 그룹의 종류
var @!curBoundary int32 // 현재 수준이 시작하는 곳; |0 .. saveSize|

@ 이쯤에서 매개변수 이름의 긴 목록 바로 앞에서 했던 |eqtb|의 소개를 다시 한번 훑어보는 것이 좋겠다. 프로그램의
``바깥 수준''은 |levelOne|이라는 것을 떠올리자. 정의되지 않은 제어 시퀀스는 |levelZero|에서 ``정의되었다''고 보기
때문이다. 처음에는 저장 스택이 비어 있고, 바깥 수준에 있으며, 그룹 바깥(|bottomLevel|)에 있다.

@<핵심 변수들의...@>=
savePtr = 0
curLevel = levelOne
curGroup = bottomLevel
curBoundary = 0
maxSaveStack = 0

@ 다음 함수는 |saveStack|에 항목을 여섯 개까지 더 넣을 자리가 있는지 검사한다. 이렇게 넉넉하게 검사해 두면
넘침 검사를 몇 군데에서만 해도 된다. 검사하는 김에 저장 스택을 가장 많이 썼던 양 |maxSaveStack|도 고쳐 둔다.

@<정의@>=
func checkFullSaveStack() {
	if savePtr > maxSaveStack {
		maxSaveStack = savePtr
		if maxSaveStack > saveSize-6 {
			overflow("save size", saveSize)
		}
@:TeX capacity exceeded save size}{\quad save size@>
	}
}

@ 프로시저 |newSaveLevel|은 그룹이 시작할 때 부른다. 인자는 `|hboxGroup|' 같은 그룹 코드다. 이 프로시저는
지금 그룹의 종류와 바깥 경계의 위치를 담은 수준 경계 낱말을 쌓고, |curLevel|을 하나 올린다. 이 루틴을 부른
뒤에는 |saveStack|에 항목을 다섯 개 더 넣어도 안전하다.

어떤 경우에는 |levelBoundary| 낱말 바로 아래에 정수 값 항목들을 넣어 둔다. 그룹이 끝났을 때 ``튀어나와야'' 할
정보를 두기에 편한 곳이기 때문이다. 이를테면 `\.{\\hbox to 100pt}\grp'를 처리할 때는 100pt라는 치수를
|newSaveLevel|을 부르기 바로 전에 |saveStack|에 저장해 둔다. 그룹이 끝나면 그 값을 꺼내 상자를 그 너비로
꾸린다.

표기 |saved(k)|는 저장 스택의 위치 |savePtr+k|에 있는 정수 항목을 가리킨다. 그룹이 끝난 뒤에는
|saved(0)|, |saved(1)|처럼 경계 낱말 바로 아래에 둔 값들을 읽는다.

@<함수들@>=
func saved(k int32) int32        { return saveStack[savePtr+k].sc }
func setSaved(k int32, v int32) { saveStack[savePtr+k].sc = v }

func newSaveLevel(c groupCode) { // 새 그룹 수준을 시작한다
	checkFullSaveStack()
	setSaveType(savePtr, levelBoundary)
	setSaveLevel(savePtr, curGroup)
	setSaveIndex(savePtr, curBoundary)
	if curLevel == maxQuarterword {
		overflow("grouping levels",
@:TeX capacity exceeded grouping levels}{\quad grouping levels@>
			maxQuarterword-minQuarterword)
	} // |(curLevel+1)|이 너무 커서 |eqtb|에 저장할 수 없으면 그만둔다
	curBoundary = savePtr
	curLevel++
	savePtr++
	curGroup = c
}

@ 표 |eqtb|의 항목을 바꾸기 바로 전에는 다음 프로시저를 불러서 옛 값이 가리키던 자료 구조를 알맞게 정리해야
한다. 매크로라면 토큰 목록의 참조를 하나 줄이고, 글루라면 명세의 참조를 하나 줄이며, 상자 레지스터라면 상자를
지운다. 배열 |mem|의 참조 횟수에는 |saveStack| 안에서 오는 참조도 들어 있으므로 이 횟수들을 조심해서 다루어야
한다는 것을 명심하자.
@^reference counts@>

@<함수들@>=
func eqDestroy(w memoryWord) { // |w|를 잊을 준비를 한다
	var q pointer // |w|의 |equiv| 필드
	switch eqTypeField(w) {
	case call, longCall, outerCall, longOuterCall:
		deleteTokenRef(equivField(w))
	case glueRef:
		deleteGlueRef(equivField(w))
	case shapeRef:
		q = equivField(w) // \.{\\parshape} 덩어리를 해제해야 한다
		if q != null {
			freeNode(q, info(q)+info(q)+1)
		} // 그런 덩어리는 |n=info(q)|일 때 $2n+1$낱말 길이다
	case boxRef:
		flushNodeList(equivField(w))
	default:
		// 아무것도 하지 않는다
	}
}

@ 수준 |l|에서 정한 |eqtb[p]|의 값을 저장하려면 다음 서브루틴을 쓴다. 수준이 |levelZero|, 곧 정의된 적이 없는
값이면 |restoreZero| 항목 하나만 쌓으면 된다. 그렇지 않으면 옛 값 낱말 전체를 먼저 쌓고 그 위에
|restoreOldValue| 항목을 쌓는다.

@<함수들@>=
func eqSave(p pointer, l quarterword) { // |eqtb[p]|를 저장한다
	checkFullSaveStack()
	if l == levelZero {
		setSaveType(savePtr, restoreZero)
	} else {
		saveStack[savePtr] = eqtb[p]
		savePtr++
		setSaveType(savePtr, restoreOldValue)
	}
	setSaveLevel(savePtr, l)
	setSaveIndex(savePtr, p)
	savePtr++
}

@ 프로시저 |eqDefine|은 |eqtb|의 한 항목에 |eqType|과 |equiv|를 새로 정하고, 필요하면 옛 값을 저장한다. 이
프로시저는 |eqtb|의 처음 네 영역, 곧 |eqType|과 |equiv| 필드가 있는 항목에만 쓴다. 항목의 수준이 지금 수준과
같으면 이 그룹 안에서 이미 한 번 저장했으므로 옛 값을 그냥 버리면 되고, 바깥 수준이면 저장해 둔다. 부르기
전에 |saveStack|에 항목 네 개를 더 넣을 자리가 있었다면, 이 루틴을 부른 뒤에도 네 개를 더 넣어도 안전하다.
프로시저 |eqSave|가 필요한 검사를 하기 때문이다.

@<함수들@>=
func eqDefine(p pointer, t quarterword, e halfword) { // |eqtb|의 새 자료
	if eqLevel(p) == curLevel {
		eqDestroy(eqtb[p])
	} else if curLevel > levelOne {
		eqSave(p, eqLevel(p))
	}
	setEqLevel(p, curLevel)
	setEqType(p, t)
	setEquiv(p, e)
}

@ 표 |eqtb|의 나머지 (온 낱말) 위치를 위한 |eqDefine|의 짝을 |eqWordDefine|이라고 부른다. 이 영역의 항목은 모두
|xeqLevel[p]>=levelOne|이므로, 여기서는 `|restoreZero|'가 결코 쓰이지 않는다. 값은 포인터가 아니므로 옛 값을
정리할 것도 없다.

@<함수들@>=
func eqWordDefine(p pointer, w int32) {
	if xeqLevel[p] != curLevel {
		eqSave(p, xeqLevel[p])
		xeqLevel[p] = curLevel
	}
	eqtb[p].sc = w
}

@ 루틴 |eqDefine|과 |eqWordDefine|은 지역 정의를 처리한다. 전역 정의도 거의 같은 방법으로 하지만, 옛 값을 저장할
@^global definitions@>
필요가 없고 새 값의 수준을 |levelOne|으로 한다. 저장 스택에 바깥 그룹의 옛 값이 남아 있더라도, 그룹이 끝날 때
|unsave|가 수준이 |levelOne|인 것을 보고 그 옛 값을 버린다(\secref{unsave-global}).

@<함수들@>=
func geqDefine(p pointer, t quarterword, e halfword) { // 전역 |eqDefine|
	eqDestroy(eqtb[p])
	setEqLevel(p, levelOne)
	setEqType(p, t)
	setEquiv(p, e)
}

func geqWordDefine(p pointer, w int32) { // 전역 |eqWordDefine|
	eqtb[p].sc = w
	xeqLevel[p] = levelOne
}

@ 서브루틴 |saveForAfter|는 \.{\\aftergroup}으로 보관할 토큰 하나를 스택에 넣는다. 바깥 수준에서는 끝날 그룹이
없으므로 아무것도 하지 않는다.

@<함수들@>=
func saveForAfter(t halfword) {
	if curLevel > levelOne {
		checkFullSaveStack()
		setSaveType(savePtr, insertToken)
		setSaveLevel(savePtr, levelZero)
		setSaveIndex(savePtr, t)
		savePtr++
	}
}

@ 루틴 |unsave|는 거꾸로 |saveStack|에서 항목들을 꺼낸다. 한 수준이 끝날 때 값을 되살리는 일을 맡는다. 맨 위
그룹에 속하는 것은 모두 저장 스택에서 치워진다.

@<함수들@>=
@<|restoreTrace|라는 프로시저를 선언한다@>
func unsave() { // 저장 스택의 맨 위 수준을 꺼낸다
	var p pointer // 되살릴 위치
	var l quarterword // |eqtb|의 온 낱말 영역에 있다면 저장된 수준
	var t halfword // 저장된 |curTok|의 값
	if curLevel > levelOne {
		curLevel--
		@<|saveStack|에서 맨 위 수준을 치운다@>
	} else {
		confusion("curlevel") // |curGroup=bottomLevel|일 때는 |unsave|를 쓰지 않는다
	}
@:this can't happen curlevel}{\quad curlevel@>
}

@ 저장 스택을 위에서부터 수준 경계를 만날 때까지 꺼내면서, 항목의 종류에 따라 토큰을 입력에 끼워 넣거나
|eqtb|의 값을 되살린다. 수준 경계에 이르면 그 낱말에서 바깥 그룹의 종류와 경계를 되찾는다.
@<|saveStack|에서 맨 위...@>=
for {
	savePtr--
	if saveType(savePtr) == levelBoundary {
		goto done
	}
	p = saveIndex(savePtr)
	if saveType(savePtr) == insertToken {
		@<토큰 |p|를 \TeX의 입력에 끼워 넣는다@>
	} else {
		if saveType(savePtr) == restoreOldValue {
			l = saveLevel(savePtr)
			savePtr--
		} else {
			saveStack[savePtr] = eqtb[undefinedControlSequence]
		}
		@<|eqtb[p]|가 전역 값이 아니면 |saveStack[savePtr]|를 거기 넣는다@>
	}
}
done:
curGroup = saveLevel(savePtr)
curBoundary = saveIndex(savePtr)

@ \seclabel{unsave-global}전역 정의는 수준을 |levelOne|으로 놓으므로 |unsave|가 되돌리지 않는다. 방금 끝난
@^global definitions@>
그룹 안에서 |eqtb[p]|를 전역으로 정의한 적이 한 번이라도 있다면, 그 가운데 마지막 정의가 살아남는다. 이때는
되살리는 대신 저장해 둔 옛 값을 버린다. 매개변수 \.{\\tracingrestores}가 양수이면 되살린 것은 `\.{restoring}'으로, 전역
값을 그대로 둔 것은 `\.{retaining}'으로 찍는다.

@<|eqtb[p]|가 전역 값이...@>=
if p < intBase {
	if eqLevel(p) == levelOne {
		eqDestroy(saveStack[savePtr]) // 저장된 값을 없앤다
		if stat {
			if tracingRestores() > 0 {
				restoreTrace(p, "retaining")
			}
		}
	} else {
		eqDestroy(eqtb[p]) // 현재 값을 없앤다
		eqtb[p] = saveStack[savePtr] // 저장된 값을 되살린다
		if stat {
			if tracingRestores() > 0 {
				restoreTrace(p, "restoring")
			}
		}
	}
} else if xeqLevel[p] != levelOne {
	eqtb[p] = saveStack[savePtr]
	xeqLevel[p] = l
	if stat {
		if tracingRestores() > 0 {
			restoreTrace(p, "restoring")
		}
	}
} else if stat {
	if tracingRestores() > 0 {
		restoreTrace(p, "retaining")
	}
}

@ 되살린 값을 `\.{\char'173restoring \\count1=7\char'175}'처럼 찍는 프로시저다.
@<|restoreTrace|라는...@>=
func restoreTrace(p pointer, s string) { // |eqtb[p]|를 방금 되살렸거나 그대로 두었다
	beginDiagnostic()
	printChar('{')
	printStr(s)
	printChar(' ')
	showEqtb(p)
	printChar('}')
	endDiagnostic(false)
}

@ 메모리의 어떤 위치를 가리킬 만한 포인터를 찾을 때에는, 저장 스택에서 되살아나기를 기다리는 |eqtb|의 옛 값들도
찾아보면 도움이 된다. 물론 엉뚱한 포인터가 걸릴지도 모른다. 그러나 이 루틴은 디버깅을 도우려는 것일 뿐이고,
디버깅할 때는 나중에 상관없는 것으로 드러나더라도 정보 부스러기 하나하나가 고마운 법이다.

@<|saveStack|에서 |p|를...@>=
if savePtr > 0 {
	for q = 0; q <= savePtr-1; q++ {
		if equivField(saveStack[q]) == p {
			printNl("SAVE(")
			printInt(q)
			printChar(')')
		}
	}
}

@ 표 |eqtb|의 매개변수는 대부분 마음대로 바꿀 수 있지만, 예외가 하나 있다. 확대 배율은 한 \TeX\ 작업에서 서로 다른
두 값으로 쓰면 안 된다. \.{DVI} 파일의 머리에 적힌 확대 배율 하나가 실행 전체에 적용되기 때문이다. 확대 배율을
어떤 값으로 ``얼려야'' 할 때마다, 이를테면 처음 쪽을 내보내거나 \.{true} 단위의 치수를 읽을 때마다 전역 변수
|magSet|을 현재의 확대 배율로 놓는다.

@<전역 변수@>=
var @!magSet int32 // 0이 아니면 앞으로 이 확대 배율을 써야 한다

@ @<핵심 변수들의...@>=
magSet = 0

@ 서브루틴 |prepareMag|는 \TeX이 확대에 |mag|를 쓰려 할 때마다 부른다. 얼려 둔 값과 다르면 오류를 알리고 옛 값으로
되돌리며, 값이 0 이하이거나 32768보다 크면 1000으로 바꾼다. 그다음 지금 값을 얼린다.

@<함수들@>=
func prepareMag() {
	if magSet > 0 && mag() != magSet {
		printErr("Incompatible magnification (")
		printInt(mag())
@.Incompatible magnification@>
		printStr(");")
		printNl(" the previous value will be retained")
		help2("I can handle only one magnification ratio per job. So I've",
			"reverted to the magnification you used earlier on this run.")
		intError(magSet)
		geqWordDefine(intBase+magCode, magSet) // |mag=magSet|
	}
	if mag() <= 0 || mag() > 32768 {
		printErr("Illegal magnification has been changed to 1000")
@.Illegal magnification...@>
		help1("The magnification ratio must be between 1 and 32768.")
		intError(mag())
		geqWordDefine(intBase+magCode, 1000)
	}
	magSet = mag()
}

@* 토큰 목록.
\seclabel{tokens}\TeX의 토큰은 문자이거나 제어 시퀀스이고, 안에서는 두 방법 가운데 하나로 나타낸다.
@^token@>
(1)~{\mc ASCII} 코드가 |c|이고 명령 코드가 |m|인 문자는 수 $2^8m+c$로 나타낸다. 명령 코드는 범위
|1<=m<=14|에 있다. (2)~|eqtb| 주소가 |p|인 제어 시퀀스는 수 |csTokenFlag+p|로 나타낸다. 여기서
|csTokenFlag=@t$2^{12}-1$@>|은 어떤 $2^8m+c$보다도 크지만, |csTokenFlag+p< maxHalfword|일 만큼은 작다.
그러므로 토큰 하나는 하프워드에 넉넉히 들어간다. 이를테면 글자 `\.A'(catcode 11)는 $2^8\cdot11+65=2881$이고,
같은 글자라도 catcode가 12이면 $2^8\cdot12+65=3137$이라는 다른 토큰이 된다. 토큰에는 문자 코드와 함께
그 문자를 읽을 때의 catcode가 묻어 있는 것이다.

토큰 |t|는 |t<leftBraceLimit|일 때, 그리고 오직 그때에만 |leftBrace| 명령을 나타낸다. 또
|leftBraceLimit<=t<rightBraceLimit|일 때, 그리고 오직 그때에만 |rightBrace| 명령을 나타내고,
|matchToken<=t<=endMatchToken|일 때, 그리고 오직 그때에만 |match|나 |endMatch| 명령을 나타낸다. 그래서
토큰을 하나하나 풀어 보지 않고 수의 크기만 견주어 중괄호의 짝을 셀 수 있다. 다음 정의들은 이런 토큰 관련
상수들과 그 밖의 몇 가지를 다룬다.

@<정의@>=
const (
	@!csTokenFlag = 0o7777 // 제어 시퀀스를 나타내는 토큰에서 |eqtb| 위치에 더하는 양;
	@t\qquad@>// 256의 배수에서 1을 뺀 것
	@!leftBraceToken = 0o0400 // $2^8\cdot|leftBrace|$
	@!leftBraceLimit = 0o1000 // $2^8\cdot(|leftBrace|+1)$
	@!rightBraceToken = 0o1000 // $2^8\cdot|rightBrace|$
	@!rightBraceLimit = 0o1400 // $2^8\cdot(|rightBrace|+1)$
	@!mathShiftToken = 0o1400 // $2^8\cdot|mathShift|$
	@!tabToken = 0o2000 // $2^8\cdot|tabMark|$
	@!outParamToken = 0o2400 // $2^8\cdot|outParam|$
	@!spaceToken = 0o5040 // $2^8\cdot|spacer|+|" "|$
	@!letterToken = 0o5400 // $2^8\cdot|letter|$
	@!otherToken = 0o6000 // $2^8\cdot|otherChar|$
	@!matchToken = 0o6400 // $2^8\cdot|match|$
	@!endMatchToken = 0o7000 // $2^8\cdot|endMatch|$
)

@ 가장 큰 제어 시퀀스 토큰도 하프워드에 들어가야 한다.
@<``상수'' 값들이...@>=
if csTokenFlag+undefinedControlSequence > maxHalfword {
	bad = 21
}

@ 토큰 목록은 |mem| 안의 한 낱말짜리 노드들을 하나로 엮은 연결 목록이다. 낱말마다 토큰 하나와 연결 하나가
들어 있다. \TeX은 매크로 정의, 출력 루틴 정의, 표시, \.{\\write}의 텍스트 같은 몇 가지를 토큰 목록의 꼴로
기억하는데, 대개 그 맨 앞에 |tokenRefCount| 필드에 참조 횟수를 담은 노드가 하나 더 온다. 위치 |p|에 저장된
토큰은 |info(p)|라고 부른다.

매크로 정의의 토큰 목록에는 특별한 명령이 셋 나온다. 명령 |m=match|는 \TeX이 지금 매크로의 매개변수를 하나
훑어야 한다는 뜻이다. 명령 |m=endMatch|는 매개변수 맞추기를 끝내고 매크로의 본문을 읽기 시작해야 한다는
뜻이다. 명령 |m=outParam|은 \TeX이 이 자리에 매개변수 |c|번을 끼워 넣어야 한다는 뜻이다.

매크로 정의를 둘러싼 \.{\char'173}와 \.{\char'175}는 토큰 목록에 넣지 않지만, 출력 루틴은 중괄호로 둘러싸서
저장한다. 출력 루틴은 그룹 안에서 돌아야 하기 때문이다.

다음은 이 관례들을 보여 주는 매크로 정의의 예다. \TeX이 텍스트
$$\.{\\def\\mac a\#1\#2 \\b \{\#1\\-a \#\#1\#2 \#2\}}$$
를 처리하고 나면 \.{\\mac}의 정의는 다음과 같은 토큰 목록이 된다.
$$\def\,{\hskip2pt}
\vbox{\halign{\hfil#\hfil\cr
(참조 횟수), |letter|\,\.a, |match|\,\#, |match|\,\#, |spacer|\,\.\ ,
\.{\\b}, |endMatch|,\cr
|outParam|\,1, \.{\\-}, |letter|\,\.a, |spacer|\,\.\ , |macParam|\,\#,
|otherChar|\,\.1,\cr
|outParam|\,2, |spacer|\,\.\ , |outParam|\,2.\cr}}$$
매개변수 부분의 \.{\#1}과 \.{\#2}는 번호 없이 |match|가 되고, 본문의 \.{\#1}과 \.{\#2}는 번호를 단
|outParam|이 된다. 본문의 \.{\#\#}은 \.\# 하나짜리 |macParam| 토큰이 되므로, 이 매크로를 펼치면 그 자리에
\.{\#1}이 그대로 나타난다. 이런 토큰 목록은 프로시저 |scanToks|가 만들고, 매개변수 맞추기는 |macroCall|이
한다.
@^reference counts@>

$$\.{\\def\\m\{\\def\\m\{a\}\ b\}}$$
같은 예를 보면, \TeX에 \.{\\let} 연산이 없더라도 참조 횟수가 필요한 까닭을 알 수 있다. 매크로 \.{\\m}의 토큰
목록을 읽는 도중에 \.{\\m}을 다시 정의하면, 토큰 목록을 다 읽기도 전에 |eqtb| 항목이 바뀐다. 그러니 제어
시퀀스를 다시 정의했다고 해서 옛 토큰 목록을 곧바로 없애 버릴 수는 없다. 아직 읽고 있는 쪽이 그 목록을
가리키는 참조를 하나 쥐고 있기 때문이다.

정의의 매개변수 부분이 `\.{\#\{}'로 끝나면, 그 토큰 목록에는 `|endMatch|' 바로 앞과 맨 끝에 `\.\{'가 하나씩
들어간다. 첫째 `\.\{'는 마지막 매개변수의 끝을 가리는 구분자로 쓰이고, 둘째 것은 그 구분자가 사라지지 않게
해 준다. 매크로를 펼치면 본문 끝에 `\.\{'가 다시 나타나는 것이다.

@ 프로시저 |showTokenList|는 주어진 노드 |p|에서 시작하는 토큰 목록을 기호 꼴로 찍는다. 이 프로시저를 보면 위의
관례들이 잘 드러난다. 보여 줄 토큰 목록은 참조 횟수로 시작하면 안 된다. 그러나 이 프로시저는 튼튼하게
만들었으므로, 메모리의 연결이 엉망이거나 |p|가 실제로 토큰 목록을 가리키지 않더라도 큰일은 나지 않는다.

매개변수 |q|도 주어진다. 이 값은 널이거나, 나중에 설명할 어떤 마법 같은 계산을 해야 할 토큰 목록의 노드를
가리킨다. (간단히 말하면, 오류 메시지에서 두 줄짜리 문맥 정보를 찍을 때 |q|가 널이 아니다. 포인터 |q|는
둘째 줄이 시작해야 할 자리를 표시한다.)

이를테면 |p|가 위의 토큰 목록에서 첫째 \.a를 담은 노드를 가리키면, |showTokenList|는 문자열
$$\hbox{`\.{a\#1\#2\ \\b\ ->\#1\\-a\ \#\#1\#2\ \#2}'}$$
을 찍는다. 그리고 |q|가 둘째 \.a를 담은 노드를 가리키면, 둘째 \.a를 찍기 바로 전에 마법 같은 계산을 한다.

찍은 길이가 주어진 한계~|l|을 넘으면 찍기를 멈추고 `\.{\\ETC.}'를 찍는다. 이상한 항목은 뒤에 공백이 없는
제어 시퀀스 꼴, 이를테면 `\.{\\BAD.}'로 찍는다. 이것은 진짜 제어 시퀀스와 헷갈릴 수 없다. 이름이 \.{BAD}인
진짜 제어 시퀀스라면 `\.{\\BAD\ }'로 찍힐 것이기 때문이다.

@<|showTokenList|라는...@>=
func showTokenList(p, q int32, l int32) {
	var m, c int32 // 토큰의 조각들
	var matchChr asciiCode // `|match|'에 쓰인 문자
	var n asciiCode // 가장 큰 매개변수 번호, {\mc ASCII} 숫자로
	matchChr = '#'
	n = '0'
	tally = 0
	for p != null && tally < l {
		if p == q {
			@<마법 같은 계산을 한다@>
		}
		@<토큰 |p|를 보이되, 문제가 있으면 |return|한다@>
		p = link(p)
	}
	if p != null {
		printEsc("ETC.")
	}
@.ETC@>
}

@ 토큰 하나를 보여 준다. 포인터가 범위를 벗어나면 `\.{\\CLOBBERED.}'를 찍고 그만둔다. 제어 시퀀스 토큰은 그
이름을 찍고, 문자 토큰은 명령 코드 |m|과 문자 코드 |c|로 나누어 다음 절에서 찍는다.
@<토큰 |p|를 보이되...@>=
if p < hiMemMin || p > memEnd {
	printEsc("CLOBBERED.")
	return
@.CLOBBERED@>
}
if info(p) >= csTokenFlag {
	printCs(info(p) - csTokenFlag)
} else {
	m = info(p) / 0o400
	c = info(p) % 0o400
	if info(p) < 0 {
		printEsc("BAD.")
@.BAD@>
	} else {
		@<토큰 $(|m|,|c|)$를 보인다@>
	}
}

@ 이 프로시저는 대개 |outParam| 명령을 만나기 전에 |match| 명령을 보고, 매크로 매개변수에 쓰인 문자가 무엇인지
``배운다.'' 매개변수 문자를 \.\# 말고 다른 것으로 정해 두었을 수도 있기 때문이다. 그래서 |outParam|은 그렇게
배운 문자 뒤에 번호를 붙여 찍는다. 매개변수 기호 자체를 나타내는 |macParam| 토큰은 \.{\#\#}처럼 두 번 찍고,
|endMatch|는 `\.{->}'로 찍는다.

@<토큰 $(|m|,|c|)$를...@>=
switch m {
case leftBrace, rightBrace, mathShift, tabMark, supMark, subMark, spacer,
	letter, otherChar:
	printStr(c)
case macParam:
	printStr(c)
	printStr(c)
case outParam:
	printStr(matchChr)
	if c <= 9 {
		printChar(c + '0')
	} else {
		printChar('!')
		return
	}
case match:
	matchChr = c
	printStr(c)
	n++
	printChar(n)
	if n > '9' {
		return
	}
case endMatch:
	printStr("->")
@.->@>
default:
	printEsc("BAD.")
@.BAD@>
}

@ 참조 횟수를 가리키는 포인터가 주어졌을 때 토큰 목록을 보여 주려면 이따금 다음 방법을 쓴다. 참조 횟수 노드를
건너뛰고 그다음부터 찍는다. 포인터는 널일 수도 있다.

@<함수들@>=
func tokenShow(p pointer) {
	if p != null {
		showTokenList(link(p), null, 10000000)
	}
}

@ 서브루틴 |printMeaning|은 |curCmd|와 |curChr|를 기호 꼴로 보여 준다. 매크로라면 그 정의를, 표시라면 그 내용을
함께 보여 준다. 명령 \.{\\show}와 \.{\\meaning}이 이것을 쓴다. 이를테면 `\.{macro:->\#1}' 같은 것이 찍힌다.

@<함수들@>=
func printMeaning() {
	printCmdChr(curCmd, curChr)
	if curCmd >= call {
		printChar(':')
		printLn()
		tokenShow(curChr)
	} else if curCmd == topBotMark {
		printChar(':')
		printLn()
		tokenShow(curMark[curChr])
	}
}

@* 구문 루틴 들어가기.
여기서 잠깐 걸음을 멈추고 큰 그림을 보자. \TeX\ 프로그램은 크게 세 부분, 곧 구문 루틴, 의미 루틴, 출력
루틴으로 이루어져 있다. 구문 루틴은 사용자의 입력을 한 번에 토큰 하나씩 의미 루틴에 건네주는 일을 한다. 의미
루틴은 이 토큰들을 명령으로 보고 거기에 반응하는 해석기 노릇을 한다. 그리고 출력 루틴은 이따금 불려 나와서
상자와 글루의 목록을 조판기에 보낼 간결한 명령들로 바꾼다. \TeX의 기본 자료 구조와 유틸리티 루틴은 다
살펴보았으니, 이제 구문 루틴을 공부하면서 실제 활동에 뛰어들 준비가 되었다.

지금의 목표는 \TeX의 입력 장치를 떠받치는 쐐기돌인 프로시저 |getNext|를 붙잡는 것이다. 이 프로시저를 부를
때마다 다음 입력 토큰을 나타내는 세 변수 |curCmd|, |curChr|, |curCs|의 값이 정해진다.
$$\vbox{\halign{#\hfil\cr
  \hbox{|curCmd|는 위에 보인 긴 코드 목록의 명령 코드를 나타낸다;}\cr
  \hbox{|curChr|는 문자 코드나 명령 코드의 다른 수식어를 나타낸다;}\cr
  \hbox{|curCs|는 현재 토큰이 제어 시퀀스였다면 현재 제어 시퀀스의 |eqtb| 위치이고,}\cr
  \hbox{\qquad 그렇지 않으면 0이다.}\cr}}$$
이를테면 catcode가 11인 글자 \.x를 읽으면 |curCmd=letter|, |curChr="x"|, |curCs=0|이 되고,
\.{\\hbox}를 읽으면 |curCmd=makeBox|, |curChr=vtopCode+hmode|, |curCs|는 \.{\\hbox}의 |eqtb| 위치가 된다.

이렇게 겉으로는 단순해 보이지만, 프로시저 |getNext| 밑에는 문자 파일을 토큰으로 바꾸는 데 필요한 장치가 모두
깔려 있다. 어느 순간이든 우리는 여러 파일(\.{\\input}으로 지정한 것들)을 읽다 만 상태일 수 있고, 사용자가
정의한 매크로나 매크로 매개변수를 펼치다 만 상태일 수 있으며, \.{\\halign}의 틀 안의 어떤 텍스트를 만들다 만
상태일 수도 있고, 그 밖에도 여러 가지가 겹쳐 있을 수 있다. 문자 파일을 읽을 때는 특별한 문자를 수식 전환
문자 따위로 분류해야 하고, 주석과 여분의 공백을 없애야 하며, 문단의 끝을 알아보아야 하고, 제어 시퀀스를
해시 표에서 찾아야 한다. 게다가 훑기 루틴들이 `\.{plus}' 같은 낱말이 오는지 미리 내다보았는데 그 낱말의
일부만 맞는 경우도 있다. 그러면 읽은 문자 몇 개를 입력에 되돌려 놓고 다시 훑어야 한다.

이런 상황들이 모두 한꺼번에 일어날 수도 있다. \TeX은 이것들을 다루려고 끝나지 않은 일에 관한 정보를 담은
여러 스택을 쓰고, 입력 장치의 수준마다 유한 상태 기계를 둔다. 이 스택들은 사실상 재귀적인 과정의 현재 상태를
기록하지만, 프로시저 |getNext| 자체는 재귀적이지 않다. 그러므로 이 알고리즘들은 재귀를 지원하지 않는 저수준
언어로 옮기기도 어렵지 않을 것이다.

@<전역 변수@>=
var @!curCmd eightBits // |getNext|가 정한 현재 명령
var @!curChr halfword // 현재 명령의 피연산자
var @!curCs pointer // 여기서 찾은 제어 시퀀스; 찾지 못하면 0
var @!curTok halfword // |curCmd|와 |curChr|를 꾸려 넣은 대표값

@ 루틴 |printCmdChr|는 명령 코드와 그 수식어를 기호로 풀어서 찍는다. 어떤 `\.{You can\char'47t}' 오류 메시지와
\.{\\show} 같은 진단 루틴을 구현하는 데 쓴다.

프로시저 |printCmdChr|의 몸통은 찍기 명령을 꽤 지루하게 늘어놓은 것이고, 그 대부분은 \TeX의 원시 명령을 |eqtb|에
넣는 루틴 |primitive|를 거꾸로 한 것이나 다름없다. 그래서 이 프로시저의 많은 부분은 프로그램 곳곳에서 해당하는
|primitive| 호출과 나란히 나온다. 여기서는 문자 토큰처럼 원시 명령이 아닌 경우만 다룬다. 이를테면 catcode 1인
문자는 `\.{begin-group character \{}'로 찍는다.

찍기에 흔히 쓰는 작은 함수 |chrCmd|는 |printCmdChr|의 매개변수 |chrCode|를 쓰므로, |printCmdChr| 안의 함수
리터럴로 둔다.

@<|printCmdChr|라는...@>=
func printCmdChr(cmd quarterword, chrCode halfword) {
	chrCmd := func(s string) {
		printStr(s)
		printASCII(chrCode)
	}
	switch cmd {
	case leftBrace:
		chrCmd("begin-group character ")
	case rightBrace:
		chrCmd("end-group character ")
	case mathShift:
		chrCmd("math shift character ")
	case macParam:
		chrCmd("macro parameter character ")
	case supMark:
		chrCmd("superscript character ")
	case subMark:
		chrCmd("subscript character ")
	case endv:
		printStr("end of alignment template")
	case spacer:
		chrCmd("blank space ")
	case letter:
		chrCmd("the letter ")
	case otherChar:
		chrCmd("the character ")
	@<원시 명령의 이름을 찍는...@>
	default:
		printStr("[unknown command code!]")
	}
}

@ 다음은 현재 명령을 보여 주는 프로시저다. 매개변수 \.{\\tracingcommands}가 양수일 때 명령마다 `\.{\{vertical
mode: \\hbox\}}'처럼 찍는다. 모드는 바뀌었을 때만 찍는다.

@<함수들@>=
func showCurCmdChr() {
	beginDiagnostic()
	printNl("{")
	if mode != shownMode {
		printMode(mode)
		printStr(": ")
		shownMode = mode
	}
	printCmdChr(curCmd, curChr)
	printChar('}')
	endDiagnostic(false)
}

@* 입력 스택과 상태.
이 \TeX\ 구현은 스택을 나타내는 데 두 가지 관례를 쓴다.
@^stack conventions@>@^conventions for representing stacks@>

\yskip\hangg 1) 맨 위 항목을 자주 쓰고 스택이 사실상 결코 비지 않는다면, 맨 위 항목은 전역 변수(기계 레지스터라면
더 좋을 것이다)에 두고 나머지 항목들은 배열 $\ID{stack}[0\to(\ID{ptr}-1)]$에 둔다. 앞에서 본 의미 스택이 이렇고,
이제 공부할 입력 스택도 그렇다.

\yskip\hangg 2) 맨 위 항목을 드물게 쓴다면 스택의 내용 전체를 배열 $\ID{stack}[0\to(\ID{ptr}-1)]$에 둔다. 앞에서
본 |saveStack|이 이렇다.

\yskip\noindent
\TeX의 입력 장치의 상태는 입력 스택에 들어 있다. 그 항목들은 |state|, |index|, |start|, |loc|, |limit|, |name|이라는
여섯 필드를 가진 레코드다. 이 스택은 관례~(1)로 관리하므로 다음과 같이 선언한다.

@<전역 형@>=
type @!inStateRecord struct {
	@!stateField, @!indexField quarterword
	@!startField, @!locField, @!limitField, @!nameField halfword
}

@ @<전역 변수@>=
var @!inputStack [stackSize + 1]inStateRecord
var @!inputPtr int32 // |inputStack|에서 쓰이지 않는 첫 위치; |0 .. stackSize|
var @!maxInStack int32 // 쌓을 때 |inputPtr|의 가장 큰 값; |0 .. stackSize|

@ 기본 입출력 루틴을 이야기할 때 이미 특별한 변수 |loc|을 썼다. ``맨 위'' 입력 상태의 다른 구성 요소들도 |loc|처럼
저마다 전역 변수다. 의미 둥지(\secref{nest})와 마찬가지로, 이것들을 통째로 다룰 때는 함수 |curInput()|과
|setCurInput(r)|을 쓴다.

@<전역 변수@>=
var @!state quarterword // 현재 훑개의 상태
var @!index quarterword // 버퍼 정보를 가리키는 참조
var @!start halfword // |buffer|에서 시작 위치
var @!loc halfword // |buffer|에서 읽지 않은 첫 문자의 위치
var @!limit halfword // |buffer|에서 현재 줄의 끝
var @!name halfword // 현재 파일의 이름

func curInput() inStateRecord { // 관례 (1)에 따른 ``맨 위'' 입력 상태
	return inStateRecord{state, index, start, loc, limit, name}
}

func setCurInput(r inStateRecord) {
	state, index, start = r.stateField, r.indexField, r.startField
	loc, limit, name = r.locField, r.limitField, r.nameField
}

@ 이제 \TeX이 어떤 파일이나 사용자의 터미널에서 문자 줄을 읽고 있다고 하고, 제어 변수들
(|state|,~|index|,~|start|,~|loc|,~|limit|,~|name|)을 더 자세히 살펴보자. 배열 |buffer|는 지금 파일에서 읽고 있는
모든 문자 줄의 스택 노릇을 한다. 입력 스택의 아래 수준에서 아직 다 읽지 않은 줄들도 모두 여기 들어 있다. \TeX은
지금의 입력 파일을 다 읽으면 그 줄들로 돌아간다.

(덧붙이자면, 바이트 단위로 주소를 매기는 기계에서는 |buffer|를 배열 |strPool|과 합쳐서, 버퍼 항목들이 문자열 풀의
꼭대기에서 아래로 자라게 하고 두 표가 부딪치지 않는지 검사하는 편이 나을 수도 있다.)

지금 다루는 줄은 버퍼의 위치 |start|에서 시작한다. 다음에 읽을 문자는 |buffer[loc]|이고, |limit|는 마지막 문자의
위치다. 조건 |loc>limit|이 성립하면 그 줄은 다 읽은 것이다. 대개 |buffer[limit]|는 줄의 끝을 나타내는
|endLineChar|이지만, 현재 줄이 오류 메시지에 대한 대답으로 사용자가 터미널에서 쳐 넣은 삽입이라면 그렇지 않다.

변수 |name|은 텍스트 파일을 읽고 있으면 그 파일의 이름을 담은 문자열 번호다. 터미널에서 읽고 있으면 0이다.
입력 스트림 |n|번에서 읽고 있으면 |n+1|이다. 여기서 |0<=n<=16|이다. (입력 스트림 16번은 잘못된 스트림 번호를
나타낸다. 그때 입력은 실제로는 프로시저 |readToks|의 지휘 아래 터미널에서 온다.)

그런 파일을 훑을 때 변수 |state|는 세 값 가운데 하나다.
$$\baselineskip 15pt\vbox{\halign{#\hfil\cr
1) |state=midLine|은 보통 상태다.\cr
2) |state=skipBlanks|는 |midLine|과 같지만, 공백을 무시한다.\cr
3) |state=newLine|은 줄의 처음에서의 상태다.\cr}}$$
이 상태 값들은 상태 코드를 다음 문자의 명령 코드에 더해도 서로 겹치지 않도록 골랐다. 그래서 둘을 더한 값
하나로 |switch|할 수 있다. 이를테면 `|midLine+spacer|'는 무시하지 않는 공백 문자가 줄 한가운데 나온 경우를
나타낸다. 이 경우를 처리하고 나면 |state|의 다음 값은 |skipBlanks|가 된다. 공백이 여러 개 이어져도 공백 하나로
치는 것은 이 때문이다.

상태가 바뀌는 규칙은 {\sl The \TeX book}의 8장에 나오는 것과 같고, 그림으로 그리면 다음과 같다. 원 안의 글자는
상태이고(N은 |newLine|, M은 |midLine|, S는 |skipBlanks|), 화살표 옆에는 그 전이를 일으키는 입력을 적었다. 줄의
끝에 이르면, 곧 catcode가~5인 문자를 만나면 그 줄의 나머지를 버리고 다음 줄을 상태~N에서 시작한다. 그때 상태가
N이었으면 \.{\\par} 토큰을 내보내고, M이었으면 공백 토큰을 내보내며, S였으면 아무것도 내보내지 않는다. 그래서
빈 줄은 문단을 끝내고, 줄 끝은 낱말 사이의 공백 하나가 되며, 제어 낱말 뒤의 공백과 줄 끝은 사라진다. 줄
첫머리의 공백이 무시되는 것도 같은 까닭이다.
$$\mplibcode
beginfig(6);
save n, m, s, r; pair n, m, s; numeric r;
r := 11pt; n := (0,0); m := (230pt,0); s := (115pt,-95pt);
for c = n, m, s: draw fullcircle scaled 2r shifted c; endfor
label(btex N etex, n); label(btex M etex, m); label(btex S etex, s);
drawarrow (n + r*dir(8)) -- (m + r*dir(172));
label.top(btex \ninepoint 공백이 아닌 문자, 제어 기호 etex, 1/2[n,m] + (0,3pt));
drawarrow (n + r*dir(-55)) -- (s + r*dir(145));
label.llft(btex \ninepoint 제어 낱말, 제어 공백 etex, 1/2[n,s] + (-2pt,0));
drawarrow (s + r*dir(10)) -- (m + r*dir(-95));
label.lrt(btex \ninepoint 공백이 아닌 문자, 제어 기호 etex, 1/2[s,m] + (4pt,-2pt));
drawarrow (m + r*dir(-160)) -- (s + r*dir(70));
label.lft(btex \vbox{\ninepoint\halign{\hfil#\hfil\cr 공백(공백 토큰을 내보낸다),\cr 제어 낱말, 제어 공백\cr}} etex,
  .35[m + r*dir(-160), s + r*dir(70)] - (1pt,0));
drawarrow (n + r*dir(115)) .. (n + (0,2.8r)) .. (n + r*dir(65));
label.top(btex \ninepoint 공백 etex, n + (0,2.8r));
drawarrow (m + r*dir(115)) .. (m + (0,2.8r)) .. (m + r*dir(65));
label.top(btex \ninepoint 공백이 아닌 문자, 제어 기호 etex, m + (0,2.8r));
drawarrow (s + r*dir(-65)) .. (s + (0,-2.8r)) .. (s + r*dir(-115));
label.bot(btex \ninepoint 공백 etex, s + (0,-2.8r));
endfig;
\endmplibcode$$

@<정의@>=
const (
	@!midLine = 1 // 문자 줄을 훑을 때의 |state| 코드
	@!skipBlanks = 2 + maxCharCode // 공백을 무시할 때의 |state| 코드
	@!newLine = 3 + maxCharCode + maxCharCode // 줄의 처음에서의 |state| 코드
)

@ 보기를 들어 입력 스택의 모습을 그려 보자. 사용자가 터미널에서 `\.{\\input story}'라고 쳤고, \TeX이 파일
\.{story.tex}의 줄 `\.{\\centerline\char'173\\bf A SHORT STORY\char'175}'에서 매크로 \.{\\centerline}을 펼치다가, 그
몸통 `\.{\\line\char'173\\hss\#1\\hss\char'175}' 안의 매개변수 \.{\#1}을 읽고 있다고 하자. 그러면 입력 수준은
넷이다. 맨 위 수준은 전역 변수 |state|, |index|, |start|, |loc|, |limit|, |name|에 있고, 그 아래 수준들은 배열
|inputStack|에 쌓여 있다. 파일이나 터미널에서 읽는 두 수준의 줄은 둘 다 |buffer|에 남아 있는데, 아래 수준의 줄이
먼저 들어가고 위 수준의 줄이 그 뒤에 들어간다. 토큰 목록 수준의 |loc|은 |buffer|가 아니라 |mem| 안의 토큰 목록을
가리킨다.
$$\mplibcode
beginfig(13);
save w, r, lv, bf; numeric w, r; w := 150pt; r := 24pt; picture lv[];
def level(expr i)(text t)(expr dashedq) =
  if dashedq: draw (0,i*r)--(w,i*r)--(w,(i+1)*r-3pt)--(0,(i+1)*r-3pt)--cycle dashed evenly;
  else: draw (0,i*r)--(w,i*r)--(w,(i+1)*r-3pt)--(0,(i+1)*r-3pt)--cycle; fi
  label(t, (w/2,(i+.5)*r-1.5pt));
enddef;
level(0)(btex \vbox{\eightpoint\halign{\hfil#\hfil\cr 터미널의 줄, \ID{index}${}=0$\cr}} etex)(false);
level(1)(btex \vbox{\eightpoint\halign{\hfil#\hfil\cr 파일 {\eighttt story.tex}의 줄, \ID{index}${}=1$\cr}} etex)(false);
level(2)(btex \vbox{\eightpoint\halign{\hfil#\hfil\cr 매크로 \cs{centerline}의 몸체(토큰 목록)\cr}} etex)(false);
level(3)(btex \vbox{\eightpoint\halign{\hfil#\hfil\cr 매개변수 \#1(토큰 목록)\cr}} etex)(true);
label.lft(btex \eightpoint \ID{inputStack}[0] etex, (-4pt,.5r)); label.lft(btex \eightpoint \ID{inputStack}[1] etex, (-4pt,1.5r));
label.lft(btex \eightpoint \ID{inputStack}[2] etex, (-4pt,2.5r)); label.lft(btex \eightpoint 전역 변수들 etex, (-4pt,3.5r));
label.lft(btex \eightpoint \ID{inputPtr}${}=3$ etex, (-4pt,4.2r));
save bx, bu; numeric bx, bu; bx := w+60pt; bu := 9pt;
for i = 0 upto 20: draw (bx+i*bu,10pt)--(bx+i*bu,22pt); endfor
draw (bx,10pt)--(bx+20bu,10pt); draw (bx,22pt)--(bx+20bu,22pt);
fill (bx,10pt)--(bx+7bu,10pt)--(bx+7bu,22pt)--(bx,22pt)--cycle withcolor .85white;
fill (bx+7bu,10pt)--(bx+18bu,10pt)--(bx+18bu,22pt)--(bx+7bu,22pt)--cycle withcolor .7white;
for i = 0 upto 20: draw (bx+i*bu,10pt)--(bx+i*bu,22pt) withpen pencircle scaled .2pt; endfor
label.top(btex \eightpoint \ID{buffer} etex, (bx+10bu, 24pt));
label.bot(btex \eightpoint 터미널 줄 etex, (bx+3.5bu, 8pt));
label.bot(btex \eightpoint 파일 줄 etex, (bx+12.5bu, 8pt));
endfig;
\endmplibcode$$

@ 현재 줄에 관한 정보는 변수 |index|로도 얻을 수 있다. 이 변수는 현재 수준 아래에서 버퍼에 들어 있는 문자 줄의
수를 센다. 터미널에서 읽으면서 줄마다 사용자를 재촉할 때는 |index=0|이다. 그러다가 사용자가 이를테면
`\.{\\input paper}'를 치면, 파일 \.{paper.tex}를 읽는 동안에는 |index=1|이 된다. 그러나 |index|가 입력 스택 포인터와
같은 것은 아니다. 입력 스택의 많은 수준이 토큰 목록에서 올 수 있기 때문이다. 이를테면 명령 `\.{\\input paper}'가
어떤 매크로의 토큰 목록 안에 들어 있을 수도 있다.

전역 변수 |inOpen|은 토큰 목록이 아닌 가장 높은 수준의 |index| 값과 같다. 그러므로 버퍼에 들어 있는 다 읽지 않은
줄의 수는 |inOpen+1|이고, 토큰 목록을 읽고 있지 않을 때는 |inOpen=index|다.

지금 터미널이나 입력 스트림에서 읽고 있지 않다면 파일 변수 |inputFile[index]|에서 읽고 있는 것이다. 조건
|name=0|을 짧게 |terminalInput|이라고 쓰고, |inputFile[index]|를 짧게 |curFile|이라고 쓴다. 둘 다 함수이고,
|curFile()|은 그 파일을 가리키는 포인터를 돌려준다.

전역 변수 |line|에는 오류 메시지에 쓰려고 맨 위에 열린 파일의 줄 번호가 들어 있다. 터미널에서 읽고 있지 않으면
|lineStack[index]|에 바깥 수준의 줄 번호를 담아 두었다가, 현재 파일을 다 읽었을 때 |line|을 되살린다. 줄 번호는
결코 음수가 되면 안 된다. 의미 둥지 항목의 |modeLine| 필드에서는 줄 번호의 음수로 사용자의 출력 루틴을 알아보기
때문이다.

입력 상태에 관한 정보가 더 필요하면 여기 보인 것 같은 작은 배열에 넣으면 된다. 이를테면 입력 파일의 현재 쪽이나
구획 번호를 변수 |@!page|에 넣고, 바깥 수준들의 값은 |lineStack|처럼
`\ignorespaces|var @!pageStack [maxInOpen+1]int32|\unskip'에 쌓아 둘 수 있을 것이다.
@^system dependencies@>

@<전역 변수@>=
func terminalInput() bool    { return name == 0 } // 터미널에서 읽고 있나?
func curFile() *alphaFile   { return &inputFile[index] } // 현재의 |alphaFile| 변수

var @!inOpen int32 // 버퍼에 든 줄의 수에서 하나를 뺀 것; |0 .. maxInOpen|
var @!openParens int32 // 열린 텍스트 파일의 수; |0 .. maxInOpen|
var @!inputFile [maxInOpen + 1]alphaFile
var @!line int32 // 현재 원본 파일의 현재 줄 번호
var @!lineStack [maxInOpen + 1]int32

@ \TeX\ 사용자는 이따금 왼쪽과 오른쪽 중괄호의 짝을 맞추는 것을 잊는다. \TeX이 그런 실수를 찾아내는 방법 가운데
하나는 \.{\\outer}로 선언한 제어 시퀀스를 경계로 입력 파일을 여러 하위 파일로 나누어 보는 것이다. 이를테면
plain \TeX의 \.{\\bye}나 \.{\\newcount}는 \.{\\outer}이므로 매크로 인자 안에 나오면 안 된다. 그런데도 나왔다면
어딘가 중괄호가 닫히지 않은 것이다.

변수 |scannerStatus|는 하위 파일이 끝날 때 \TeX이 불평해야 하는지 알려 준다. 값은 다음 여섯 가지다.

\yskip\hang|normal|은 하위 파일이 여기서 아무 일 없이 끝나도 안전하다는 뜻이다.

\yskip\hang|skipping|은 하위 파일은 여기서 끝나도 안전하지만 파일은 그렇지 않다는 뜻이다. 선택되지 않은 조건부
텍스트를 건너뛰며 읽고 있기 때문이다.

\yskip\hang|defining|은 매크로를 정의하고 있으므로 하위 파일이 지금 끝나면 안 된다는 뜻이다.

\yskip\hang|matching|은 매크로를 쓰면서 그 인자의 끝을 찾고 있으므로 하위 파일이 지금 끝나면 안 된다는 뜻이다.

\yskip\hang|aligning|은 \.{\\halign}이나 \.{\\valign}의 서문을 다 읽지 않았으므로 하위 파일이 지금 끝나면 안
된다는 뜻이다.

\yskip\hang|absorbing|은 \.{\\message}나 \.{\\write} 따위에 쓸 균형 잡힌 토큰 목록을 읽고 있으므로 하위 파일이 지금
끝나면 안 된다는 뜻이다.

\yskip\noindent
이 변수가 |normal|이 아니면, 변수 |warningIndex|는 오류 메시지에 찍을 관련 제어 시퀀스의 |eqtb| 위치를 가리킨다.
이를테면 \.{\\def\\foo}를 읽다가 문제가 생기면 \.{\\foo}를 가리킨다.

@<전역 변수@>=
const (
	@!skipping = iota + 1 // 조건부 텍스트를 지나갈 때의 |scannerStatus|
	@!defining // 매크로 정의를 읽을 때의 |scannerStatus|
	@!matching // 매크로 인자를 읽을 때의 |scannerStatus|
	@!aligning // 정렬 서문을 읽을 때의 |scannerStatus|
	@!absorbing // 균형 잡힌 텍스트를 읽을 때의 |scannerStatus|
)

var @!scannerStatus int32 // 하위 파일이 지금 끝나도 되나? |normal..absorbing|
var @!warningIndex pointer // |normal|이 아닌 훑개 상태에 관련된 식별자
var @!defRef pointer // 정의하고 있는 토큰 목록의 참조 횟수

@ 다음은 하위 파일이 끝났을 때나 그 밖의 결정적인 순간에 |scannerStatus|를 보고 경고 메시지를 찍는 프로시저다.
`\.{Runaway definition?}'처럼 무엇이 폭주했는지 알리고, 그때까지 모은 토큰 목록의 앞부분을 보여 준다.

@<|runaway|라는...@>=
func runaway() {
	var p pointer // 폭주 목록의 머리
	if scannerStatus > skipping {
		printNl("Runaway ")
@.Runaway...@>
		switch scannerStatus {
		case defining:
			printStr("definition")
			p = defRef
		case matching:
			printStr("argument")
			p = tempHead
		case aligning:
			printStr("preamble")
			p = holdHead
		case absorbing:
			printStr("text")
			p = defRef
		} // 다른 경우는 없다
		printChar('?')
		printLn()
		showTokenList(link(p), null, errorLine-10)
	}
}

@ 그러나 지금까지 한 입력 상태 이야기는 사실 파일에서 입력하는 경우에만 들어맞는다. 또 하나의 중요한 경우, 곧
토큰 목록에서 입력을 얻는 경우가 있다. 이때는 |state=tokenList|이고, 다른 상태 변수들도 다르게 쓴다.

\yskip\hang|loc|은 토큰 목록의 현재 노드, 곧 다음에 읽을 노드를 가리킨다. 포인터가 |loc=null|이면 토큰 목록을 다 읽은
것이다.

\yskip\hang|start|는 토큰 목록의 첫 노드를 가리킨다. 이 노드에는 토큰 목록의 종류에 따라 참조 횟수가 들어 있을
수도 있고 없을 수도 있다.

\yskip\hang|tokenType|은 위에서 말한 |index| 자리에 대신 들어가는 것으로, 어떤 종류의 토큰 목록을 훑고 있는지
나타내는 코드다.

\yskip\hang|name|은 현재 토큰 목록이 매크로라면 펼치고 있는 제어 시퀀스의 |eqtb| 주소를 가리킨다.

\yskip\hang|paramStart|는 |limit| 자리에 대신 들어가는 것으로, 현재 토큰 목록이 매크로라면 그 매크로의
매개변수들이 |paramStack|의 어디에서 시작하는지 알려 준다.

\yskip\noindent 코드 |tokenType|은 현재 토큰 목록이 어디서 왔는지에 따라 다음 값 가운데 하나다.

\yskip\hang|parameter|는 매개변수를 훑고 있을 때다.

\hang|uTemplate|은 정렬 틀의 \<u_j> 부분을 훑고 있을 때다.

\hang|vTemplate|은 정렬 틀의 \<v_j> 부분을 훑고 있을 때다.

\hang|backedUp|은 훑고 있는 토큰 목록이 `다시 읽을 것'으로 되돌려졌을 때다.

\hang|inserted|는 훑고 있는 토큰 목록이 \.{\\count} 같은 변수의 텍스트를 펼쳐 끼워 넣은 것일 때다.

\hang|macro|는 사용자가 정의한 제어 시퀀스를 훑고 있을 때다.

\hang|outputText|는 \.{\\output} 루틴을 훑고 있을 때다.

\hang|everyParText|는 \.{\\everypar}의 텍스트를 훑고 있을 때다.

\hang|everyMathText|는 \.{\\everymath}의 텍스트를 훑고 있을 때다.

\hang|everyDisplayText|는 \.{\\everydisplay}의 텍스트를 훑고 있을 때다.

\hang|everyHboxText|는 \.{\\everyhbox}의 텍스트를 훑고 있을 때다.

\hang|everyVboxText|는 \.{\\everyvbox}의 텍스트를 훑고 있을 때다.

\hang|everyJobText|는 \.{\\everyjob}의 텍스트를 훑고 있을 때다.

\hang|everyCrText|는 \.{\\everycr}의 텍스트를 훑고 있을 때다.

\hang|markText|는 \.{\\mark}의 텍스트를 훑고 있을 때다.

\hang|writeText|는 \.{\\write}의 텍스트를 훑고 있을 때다.

\yskip\noindent
코드 |outputText|, |everyParText| 따위는 어떤 상수에 토큰 목록 매개변수 |outputRoutineLoc|, |everyParLoc| 따위의
코드를 더한 값과 같다. 그래서 두 코드 사이를 쉽게 오갈 수 있다. 토큰 목록은 |tokenType>=macro|일 때, 그리고 오직
그때에만 참조 횟수로 시작한다.
@^reference counts@>

@ 토큰 목록을 읽는 동안에는 변수 |index|와 |limit|를 다른 이름 |tokenType|과 |paramStart|로 부른다. 이것들도
|prevDepth|처럼(\secref{nest}) 읽는 함수와 쓰는 함수의 짝이다.

@<정의@>=
const (
	@!tokenList = 0 // 토큰 목록을 훑을 때의 |state| 코드
	@!parameter = 0 // 매개변수의 |tokenType| 코드
	@!uTemplate = 1 // \<u_j> 틀의 |tokenType| 코드
	@!vTemplate = 2 // \<v_j> 틀의 |tokenType| 코드
	@!backedUp = 3 // 다시 읽을 텍스트의 |tokenType| 코드
	@!inserted = 4 // 끼워 넣은 텍스트의 |tokenType| 코드
	@!macro = 5 // 정의된 제어 시퀀스의 |tokenType| 코드
	@!outputText = 6 // 출력 루틴의 |tokenType| 코드
	@!everyParText = 7 // \.{\\everypar}의 |tokenType| 코드
	@!everyMathText = 8 // \.{\\everymath}의 |tokenType| 코드
	@!everyDisplayText = 9 // \.{\\everydisplay}의 |tokenType| 코드
	@!everyHboxText = 10 // \.{\\everyhbox}의 |tokenType| 코드
	@!everyVboxText = 11 // \.{\\everyvbox}의 |tokenType| 코드
	@!everyJobText = 12 // \.{\\everyjob}의 |tokenType| 코드
	@!everyCrText = 13 // \.{\\everycr}의 |tokenType| 코드
	@!markText = 14 // \.{\\topmark} 따위의 |tokenType| 코드
	@!writeText = 15 // \.{\\write}의 |tokenType| 코드
)

func tokenType() quarterword        { return index } // 현재 토큰 목록의 종류
func setTokenType(v quarterword)   { index = v }
func paramStart() halfword          { return limit } // |paramStack|에서 매크로 매개변수의 바닥
func setParamStart(v halfword)     { limit = v }

@ 스택 |paramStack|은 현재 입력 수준과 그 아래 수준들의 매개변수 토큰 목록을 가리키는 포인터들을 담는 보조
배열이다. 이를테면 매크로를 펼칠 때 그 인자 \.{\#1}, \.{\#2}, \dots의 토큰 목록이 여기 쌓인다. 이 스택은 관례
(2)로 관리하며, 다른 스택들과는 다른 속도로 자란다.

@<전역 변수@>=
var @!paramStack [paramSize + 1]pointer // 매개변수의 토큰 목록 포인터
var @!paramPtr int32 // |paramStack|에서 쓰이지 않는 첫 항목; |0 .. paramSize|
var @!maxParamStack int32 // |paramPtr|의 가장 큰 값, |<=paramSize+9|일 것이다

@ 입력 루틴들은 \.{\\halign}과 \.{\\valign}의 처리와도 맞물려 돌아가야 한다. 어떤 자리에 탭 표시나 \.{\\cr}이
나오면 훑개 안에서 특별한 \<v_j> 틀 텍스트를 시작해야 하기 때문이다. 이 마법은 |alignState|라는 변수로 부린다.
이 변수는 `\.{\char'173}'를 훑으면 1 늘고 `\.{\char'175}'를 훑으면 1 준다. 정렬의 항목을 읽기 시작할 때 이 값을
0으로 놓으므로, |alignState=0|인 곳에서 나온 탭 표시나 \.{\\cr}은 중괄호 안에 숨어 있지 않은, 진짜 항목의
끝이다. 이 변수는 \<u_j> 틀 동안에는 0이 아니고, 그 뒤에 0으로 놓인다. \<v_j> 틀은 |alignState=0|일 때 탭
표시나 \.{\\cr}이 나오면 시작한다.

@<전역 변수@>=
var @!alignState int32 // 현재 정렬에 대한 그룹 수준

@ 이렇듯 ``현재 입력 상태''는 정말이지 아주 복잡할 수 있다. 수준이 많을 수 있고, 수준마다 여러 방법으로 생길 수
있다. 프로시저 |showContext|는 \TeX의 오류 보고 루틴이 쓰는 것으로, 입력 파일의 가장 최근 문자 줄에 이르기까지
모든 수준의 현재 입력 상태를 찍는다. 이 프로시저를 보면 이 관례들이 대부분 드러난다. 전역 변수 |basePtr|에는
이 프로시저가 보여 준 가장 낮은 수준이 들어 있다.

@<전역 변수@>=
var @!basePtr int32 // |showContext|가 보여 준 가장 얕은 수준; |0 .. stackSize|

@ 수준마다 두 줄을 찍어서 상태를 보여 준다. 첫째 줄은 지금까지 읽은 것을, 둘째 줄은 앞으로 읽을 것을 보여 준다.
이를테면 다음과 같다.
$$\vbox{\halign{#\hfil\cr
\.{l.12 Here is a mis\\take}\cr
\hphantom{\.{l.12 Here is a mis\\take!}}\.{of mine.}\cr}}$$
첫째 줄에 문자가 많아야 |halfErrorLine|개, 둘째 줄에 많아야 |errorLine|개 들어가도록 필요하면 문맥을 잘라 낸다.
현재가 아닌 입력 수준 가운데 |tokenType|이 `|backedUp|'인 것은 아직 다 읽지 않았을 때에만 보여 준다.

@<함수들@>=
func showContext() { // 훑개가 어디 있는지 찍는다
	var oldSetting int32 // 저장한 |selector| 설정; |0 .. maxSelector|
	var nn int32 // 지금까지 보여 준 문맥의 수에서 하나를 뺀 것
	var bottomLine bool // 보여 줄 마지막 문맥에 이르렀나?
	@<서식 계산을 위한 지역 변수@>
	basePtr = inputPtr
	inputStack[basePtr] = curInput() // 현재 상태를 저장한다
	nn = -1
	bottomLine = false
	for {
		setCurInput(inputStack[basePtr]) // 문맥 안으로 들어간다
		if state != tokenList {
			if name > 17 || basePtr == 0 {
				bottomLine = true
			}
		}
		if basePtr == inputPtr || bottomLine || nn < errorContextLines() {
			@<현재 문맥을 보인다@>
		} else if nn == errorContextLines() {
			printNl("...")
			nn++ // |errorContextLines<0|이면 빠진다
		}
		if bottomLine {
			goto done
		}
		basePtr--
	}
done:
	setCurInput(inputStack[inputPtr]) // 원래 상태를 되살린다
}

@ 한 수준의 문맥을 보여 준다. 먼저 이 수준이 어디서 왔는지 밝히는 머리말을 찍고, 그다음 내용을 흉내 찍기로
모은 뒤에 두 줄로 나누어 찍는다. 이미 다 읽은 되돌린 토큰 목록은 보여 줄 것이 없으므로 건너뛴다.
@<현재 문맥을...@>=
if basePtr == inputPtr || state != tokenList ||
	tokenType() != backedUp || loc != null {
	// 이미 읽은 되돌린 토큰 목록은 빠뜨린다
	tally = 0 // 문자를 셀 준비를 한다
	oldSetting = selector
	if state != tokenList {
		@<현재 줄의 위치를 찍는다@>
		@<줄을 흉내 찍는다@>
	} else {
		@<토큰 목록의 종류를 찍는다@>
		@<토큰 목록을 흉내 찍는다@>
	}
	selector = oldSetting // 흉내 찍기를 멈춘다
	@<흉내 찍은 교묘한 정보로 두 줄을 찍는다@>
	nn++
}

@ 현재 줄이 입력 파일의 어디에 있는지 알려 주는 머리말이다. 파일이면 `\.{l.12}'처럼 줄 번호를, 터미널이면
`\.{<*>}'나 `\.{<insert>}'를, \.{\\read}로 읽는 중이면 `\.{<read 3>}'처럼 스트림 번호를 찍는다. 이 루틴은 필요하면
바꾸어서, 현재 줄이 입력 파일의 어디에 있는지 될 수 있는 대로 잘 알려 주어야 한다. 이를테면 쪽 번호와 줄 번호를
둘 다 찍는 것이 가장 좋은 시스템도 있다.
@^system dependencies@>

@<현재 줄의 위치를...@>=
if name <= 17 {
	if terminalInput() {
		if basePtr == 0 {
			printNl("<*>")
		} else {
			printNl("<insert> ")
		}
	} else {
		printNl("<read ")
		if name == 17 {
			printChar('*')
		} else {
			printInt(name - 1)
		}
@.*\relax@>
		printChar('>')
	}
} else {
	printNl("l.")
	printInt(line)
}
printChar(' ')

@ 토큰 목록이면 그 종류를 `\.{<argument>}', `\.{<template>}', `\.{<to be read again>}'처럼 찍는다. 매크로라면
그 이름을 찍는다.
@<토큰 목록의 종류를...@>=
switch tokenType() {
case parameter:
	printNl("<argument> ")
case uTemplate, vTemplate:
	printNl("<template> ")
case backedUp:
	if loc == null {
		printNl("<recently read> ")
	} else {
		printNl("<to be read again> ")
	}
case inserted:
	printNl("<inserted text> ")
case macro:
	printLn()
	printCs(name)
case outputText:
	printNl("<output> ")
case everyParText:
	printNl("<everypar> ")
case everyMathText:
	printNl("<everymath> ")
case everyDisplayText:
	printNl("<everydisplay> ")
case everyHboxText:
	printNl("<everyhbox> ")
case everyVboxText:
	printNl("<everyvbox> ")
case everyJobText:
	printNl("<everyjob> ")
case everyCrText:
	printNl("<everycr> ")
case markText:
	printNl("<mark> ")
case writeText:
	printNl("<write> ")
default:
	printNl("?") // 이런 일은 결코 일어나지 않아야 한다
}

@ 여기서 작은 요령 하나를 설명해야 한다. 토큰 목록을 찍은 긴 문자열을 통째로 저장하고 싶지는 않다. 그 문자열이
메모리를 많이 차지할 수도 있고, 지금은 오류 메시지를 내는 중이므로 \TeX의 표를 하나라도 넘치게 할지 모르는 일은
감히 할 수 없기 때문이다. 그래서 `흉내 찍기'(pseudoprinting)로 해결한다. 길이가 |errorLine|인 버퍼에 문자를 모으는
찍기 방식으로 바꾸는 것이다. 여기서 문자 $k+1$은 |k<trickCount|이면 \hbox{|trickBuf[k%errorLine]|}에 들어가고,
그렇지 않으면 문자 |k|는 버려진다. 처음에는 |tally=0|, |trickCount=1000000|으로 놓는다. 그러다가 1행에서 2행으로
넘어가야 할 곳에 이르면 |firstCount=tally|, |trickCount=@tmax@>(errorLine, tally+1+errorLine-halfErrorLine)|로
놓는다. 흉내 찍기가 끝나면 |firstCount|, |tally|, |trickCount|의 값이 두 줄을 찍는 데 필요한 정보를 모두 알려 주고,
필요한 텍스트는 모두 |trickBuf|에 들어 있다. 순환 버퍼이므로 1행의 앞부분이 너무 길었다면 이미 덮어써졌겠지만,
어차피 그 부분은 잘라 낼 것이므로 상관없다.

곧, 첫째 줄의 머리말 길이를 |l|이라고 하자. 그 줄을 위해 모은 문맥 정보의 길이는 |k=firstCount|이고, 2행을 위해
모은 문맥 정보의 길이는 $m=\min(|tally|, |trickCount|)-k$다. 또 |h=halfErrorLine|이라고 하자. 만일 |l+k<=h|이면
1행의 머리말 뒤에 |trickBuf[0 .. k-1]|을 찍고 |n=l+k|로 놓는다. 여기서 |n|은 1행의 길이다. 반대로 $l+k>h$이면
잘라 내야 하므로 |n=h|로 놓고 `\.{...}' 다음에
$$\hbox{|trickBuf[(l+k-h+3)..k-1]|}$$
을 찍는다. 여기서 |trickBuf|의 첨자는 |errorLine|을 법으로 돈다. 둘째 줄은 공백 |n|개 다음에
|trickBuf[k..(k+m-1)]|이 오는 것인데, |n+m>errorLine|이면 거기서 더 잘라 낸다. 말로 설명하기보다 프로그램으로
짜는 편이 더 쉽다.

@<서식 계산을...@>=
var @!i int32 // |buffer|의 첨자; |0 .. bufSize|
var @!j int32 // |buffer|에서 현재 줄의 끝; |0 .. bufSize|
var @!l int32 // 1행의 설명 정보의 길이; |0 .. halfErrorLine|
var @!m int32 // 2행을 위해 모은 문맥 정보
var @!n int32 // 1행의 길이; |0 .. errorLine|
var @!p int32 // |trickBuf|에서 시작이나 끝 위치
var @!q int32 // 임시 첨자

@ 다음 코드는 찍기 루틴들이 원하는 정보를 모으도록 준비한다. 지금까지 찍은 머리말의 길이를 |l|에 기억하고, 흉내
찍기 방식으로 바꾼다.

흉내 찍기를 시작하는 작은 함수 |beginPseudoprint|는 |showContext|의 지역 변수 |l|을 쓰므로 |showContext| 안의 함수
리터럴로 두어 지역 변수들 곁에 둔다. 한편 함수 |setTrickCount|는 |showTokenList|에서도 쓰이므로 다음 절에서 보통의
함수로 둔다.

@<서식 계산을...@>=
beginPseudoprint := func() {
	l = tally
	tally = 0
	selector = pseudo
	trickCount = 1000000
}

@ 함수 |setTrickCount|는 흉내 찍기가 1행에서 2행으로 넘어가야 할 곳, 곧 |loc|이 가리키는 자리에 이르렀을 때 부른다.

@<정의@>=
func setTrickCount() {
	firstCount = tally
	trickCount = max(tally+1+errorLine-halfErrorLine, errorLine)
}

@ 그리고 다음 코드는 정보를 다 모은 뒤에 그것을 써서 두 줄을 찍는다. 앞 절에서 설명한 계산을 그대로 옮긴 것이다.

@<흉내 찍은 교묘한...@>=
if trickCount == 1000000 {
	setTrickCount()
} // |setTrickCount|를 반드시 해야 한다
if tally < trickCount {
	m = tally - firstCount
} else {
	m = trickCount - firstCount
} // 2행의 문맥
if l+firstCount <= halfErrorLine {
	p = 0
	n = l + firstCount
} else {
	printStr("...")
	p = l + firstCount - halfErrorLine + 3
	n = halfErrorLine
}
for q = p; q <= firstCount-1; q++ {
	printChar(trickBuf[q%errorLine])
}
printLn()
for q = 1; q <= n; q++ {
	printChar(' ')
} // 2행을 시작하는 공백 |n|개를 찍는다
if m+n <= errorLine {
	p = firstCount + m
} else {
	p = firstCount + (errorLine - n - 3)
}
for q = firstCount; q <= p-1; q++ {
	printChar(trickBuf[q%errorLine])
}
if m+n > errorLine {
	printStr("...")
}

@ 그러나 이 요령에 너무 정신을 팔면 지금의 목표, 곧 입력 상태를 이해하는 일에서 멀어진다. 그러니 |showContext|
프로시저를 마무리하면서 흉내 찍히는 자료 구조 쪽으로 다시 눈을 돌리자. 문자 줄은 |start|부터 줄의 끝까지 찍되,
|loc|에 이르면 2행으로 넘어간다. 줄 끝에 덧붙인 |endLineChar|는 찍지 않는다.

@<줄을 흉내...@>=
beginPseudoprint()
if buffer[limit] == endLineChar() {
	j = limit
} else {
	j = limit + 1
} // 줄의 실제 끝을 정한다
if j > 0 {
	for i = start; i <= j-1; i++ {
		if i == loc {
			setTrickCount()
		}
		printStr(buffer[i])
	}
}

@ 토큰 목록은 |showTokenList|로 찍고, |loc|에서 2행으로 넘어가게 한다. 참조 횟수가 있는 목록이면 그 노드는
건너뛴다.
@<토큰 목록을 흉내...@>=
beginPseudoprint()
if tokenType() < macro {
	showTokenList(start, loc, 100000)
} else {
	showTokenList(link(start), loc, 100000) // 참조 횟수를 피한다
}

@ 다음은 2행을 시작하는 토큰을 막 보여 주려 할 때 실행하는 |showTokenList|의 빠진 조각이다.

@<마법 같은...@>=
setTrickCount()

@* 입력 스택 관리하기.
다음 서브루틴들은 흔히 쓰는 방식으로 입력 상태를 바꾼다.

먼저 |pushInput|이다. 이 함수는 지금 상태를 스택에 저장하고 새 수준을 만든다. 새 수준은 처음에는 옛 수준과
성질이 똑같다. 부른 쪽에서 곧바로 새 수준에 맞게 필드를 고친다.

@<정의@>=
func pushInput() { // 새 입력 수준에 들어가고, 옛것을 저장한다
	if inputPtr > maxInStack {
		maxInStack = inputPtr
		if inputPtr == stackSize {
			overflow("input stack size", stackSize)
		}
@:TeX capacity exceeded input stack size}{\quad input stack size@>
	}
	inputStack[inputPtr] = curInput() // 레코드를 쌓는다
	inputPtr++
}

@ 그리고 물론 올라간 것은 내려와야 한다. 함수 |popInput|은 스택에서 바로 아래 수준을 꺼내 되살린다.

@<정의@>=
func popInput() { // 입력 수준을 떠나 옛 수준에 다시 들어간다
	inputPtr--
	setCurInput(inputStack[inputPtr])
}

@ 다음은 토큰 목록 |p|와 그 종류 |t|가 주어졌을 때 토큰 목록에서 읽는 새 입력 수준을 시작하는 프로시저다. 종류
|t|가 |macro|이면 |name|과 |loc|은 부른 쪽에서 정해 주어야 한다. 참조 횟수가 있는 목록이면 읽는 동안 사라지지
않도록 참조를 하나 늘린다. 매개변수 \.{\\tracingmacros}가 1보다 크면 \.{\\everypar}나 \.{\\output} 같은 토큰 목록을
읽기 시작할 때 그 내용을 기록 파일에 보여 준다. 짧은 함수 |backList|와 |insList|는 참조 횟수가 없는 간단한 토큰
목록을 되돌리거나 끼워 넣을 때 쓴다.

@<함수들@>=
func backList(p pointer) { beginTokenList(p, backedUp) } // 간단한 토큰 목록을 되돌린다
func insList(p pointer)  { beginTokenList(p, inserted) } // 간단한 토큰 목록을 끼워 넣는다

func beginTokenList(p pointer, t quarterword) {
	pushInput()
	state = tokenList
	start = p
	setTokenType(t)
	if t >= macro { // 토큰 목록이 참조 횟수로 시작한다
		addTokenRef(p)
		if t == macro {
			setParamStart(paramPtr)
		} else {
			loc = link(p)
			if tracingMacros() > 1 {
				beginDiagnostic()
				printNl("")
				switch t {
				case markText:
					printEsc("mark")
				case writeText:
					printEsc("write")
				default:
					printCmdChr(assignToks, t-outputText+outputRoutineLoc)
				}
				printStr("->")
				tokenShow(p)
				endDiagnostic(false)
			}
		}
	} else {
		loc = p
	}
}

@ 토큰 목록을 다 훑었으면 다음 계산을 하면서 그 입력 수준을 떠난다. 되돌리거나 끼워 넣은 목록은 이제 쓸모가
없으므로 지우고, 참조 횟수가 있는 목록은 참조를 하나 줄이며, 매크로라면 그 매개변수들도 지운다. 토큰 목록의
종류 |tokenType|은 3분의 2쯤은 |backedUp|이나 |inserted|다.
@^inner loop@>

@<함수들@>=
func endTokenList() { // 토큰 목록 입력 수준을 떠난다
	if tokenType() >= backedUp { // 지울 토큰 목록
		if tokenType() <= inserted {
			flushList(start)
		} else {
			deleteTokenRef(start) // 참조 횟수를 갱신한다
			if tokenType() == macro { // 매개변수들을 지워야 한다
				for paramPtr > paramStart() {
					paramPtr--
					flushList(paramStack[paramPtr])
				}
			}
		}
	} else if tokenType() == uTemplate {
		if alignState > 500000 {
			alignState = 0
		} else {
			fatalError("(interwoven alignment preambles are not allowed)")
		}
	}
@.interwoven alignment preambles...@>
	popInput()
	checkInterrupt()
}

@ 때로 \TeX은 너무 많이 읽어 버려서 본 것을 ``되돌려 놓고''(unscan) 싶어 한다. 이를테면 \.{\\hskip 3pt}를 읽은
뒤에 `\.{plus}'가 오는지 보려고 다음 토큰을 읽었는데 그것이 아니었다면, 그 토큰은 다른 누군가가 다시 읽어야
한다. 프로시저 |backInput|은 방금 훑은 토큰을 입력 흐름에 되돌려 놓아 다시 읽을 수 있게 한다. 이 프로시저는
|curTok|이 되돌릴 토큰을 나타낼 때에만 쓸 수 있다. \TeX을 어떻게 쓰느냐에 따라 이 프로시저를 아주 많이 부르기도
하므로, 속도를 위해 조금 손을 보았다. 이를테면 다 읽은 토큰 목록 수준이 맨 위에 쌓여 있으면 먼저 치워서 스택
공간을 아낀다. 되돌리는 토큰이 중괄호이면 |alignState|도 되돌려 둔다.
@^inner loop@>

@<함수들@>=
func backInput() { // 입력 토큰 하나를 되돌린다
	for state == tokenList && loc == null && tokenType() != vTemplate {
		endTokenList() // 스택 공간을 아낀다
	}
	p := getAvail() // 길이가 1인 토큰 목록
	setInfo(p, curTok)
	if curTok < rightBraceLimit {
		if curTok < leftBraceLimit {
			alignState--
		} else {
			alignState++
		}
	}
	pushInput()
	state = tokenList
	start = p
	setTokenType(backedUp)
	loc = p // 이것은 프로시저 부담 없이 한 |backList(p)|다
}

@ 명령 \.{\\aftergroup}으로 저장해 둔 토큰을 입력에 끼워 넣는다. 토큰을 잠시 |curTok|에 넣고 |backInput|을 부른다.
@<토큰 |p|를 \TeX의...@>=
t = curTok
curTok = p
backInput()
curTok = t

@ 루틴 |backError|는 잘못된 토큰을 되돌려 놓은 다음 오류 메시지를 낼 때 쓴다. 이 루틴도 |backInput|처럼 |curTok|이
정해져 있어야 한다. 도움말을 잃지 않도록 |backInput|을 부르는 동안에는 끼어들기를 막는다. 짝이 되는 |insError|는
되돌린 토큰을 ``끼워 넣은'' 것으로 표시하므로, 문맥을 보여 줄 때 `\.{<inserted text>}'로 나온다. \TeX이 빠진
것을 짐작해 끼워 넣을 때 쓴다.

@<함수들@>=
func backError() { // 토큰 하나를 되돌리고 |reportError|를 부른다
	okToInterrupt = false
	backInput()
	okToInterrupt = true
	reportError()
}

func insError() { // 끼워 넣은 토큰 하나를 되돌리고 |reportError|를 부른다
	okToInterrupt = false
	backInput()
	setTokenType(inserted)
	okToInterrupt = true
	reportError()
}

@ 프로시저 |beginFileReading|은 파일의 문자 줄이나 터미널에서 끼워 넣는 것을 읽을 새 입력 수준을 시작한다.
파일을 여는 일은 하지 않으며, |loc|이나 |limit|이나 |line|도 정하지 않는다. 그런 것은 부른 쪽이 할 일이다.
새 줄은 버퍼의 |first|부터 들어간다.
@^system dependencies@>

@<함수들@>=
func beginFileReading() {
	if inOpen == maxInOpen {
		overflow("text input levels", maxInOpen)
	}
@:TeX capacity exceeded text input levels}{\quad text input levels@>
	if first == bufSize {
		overflow("buffer size", bufSize)
	}
@:TeX capacity exceeded buffer size}{\quad buffer size@>
	inOpen++
	pushInput()
	index = inOpen
	lineStack[index] = line
	start = first
	state = midLine
	name = 0 // 이제 |terminalInput|은 |true|다
}

@ 거꾸로, 그런 입력 수준이 끝나면 변수들을 되돌려 놓아야 한다. 버퍼의 자리를 돌려주고, 바깥 파일의 줄 번호를
되살리며, 파일을 읽던 중이었다면 그 파일을 닫는다.

@<함수들@>=
func endFileReading() {
	first = start
	line = lineStack[index]
	if name > 17 {
		aClose(curFile()) // 그것을 잊는다
	}
	popInput()
	inOpen--
}

@ 오류가 날 때마다 끼워 넣은 `\.{\\show}' 명령이 길게 이어지면 입력 스택이 넘칠 수 있다. 이를 막으려고, 다음
루틴은 오류 때 끼워 넣은 줄 가운데 다 읽은 것들을 메모리에서 치운다.

@<함수들@>=
func clearForErrorPrompt() {
	for state != tokenList && terminalInput() &&
		inputPtr > 0 && loc > limit {
		endFileReading()
	}
	printLn()
	clearTerminal()
}

@ 이제 \TeX의 입력 장치 전체를 움직이게 하는 동작들이다. 스택들을 비우고, 버퍼를 0으로 채우고, 터미널에서 첫
줄을 읽는다. 첫 줄을 얻지 못하면 끝낸다.

여기서 `|goto finalEnd|'는 주 프로그램 안의 레이블로 가는 보통의 |goto|다. 이 절은 주 프로그램 안에
펼쳐지기 때문이다(\secref{startup}).

@<입력 루틴들을 초기화한다@>=
inputPtr = 0
maxInStack = 0
inOpen = 0
openParens = 0
maxBufStack = 0
paramPtr = 0
maxParamStack = 0
first = bufSize
for {
	buffer[first] = 0
	first--
	if first == 0 {
		break
	}
}
scannerStatus = normal
warningIndex = null
first = 1
state = newLine
start = 1
index = 0
line = 0
name = 0
forceEOF = false
alignState = 1000000
if !initTerminal() {
	goto finalEnd
}
limit = last
first = last + 1 // |initTerminal|이 |loc|과 |last|를 정했다

@* 다음 토큰 얻기.
\TeX의 입력 장치의 심장은 프로시저 |getNext|다. 앞으로 몇 절에 걸쳐 이것을 짜 나가겠다. 그런데 이것을 ``심장''이라고
부르면 안 될지도 모르겠다. 실은 원본 파일을 읽어 삼키는 \TeX의 눈과 입 노릇을 하기 때문이다. 또 저장해 둔 토큰 목록을
다시 처리해야 할 때 \TeX이 그것을 되새김질하는 것도 돕는다.
@^eyes and mouth@>

프로시저 |getNext|가 하는 일은 한마디로 토큰 하나를 읽어서 |curCmd|와 |curChr|를 그 토큰의 명령 코드와 수식어로
놓는 것이다. 읽은 토큰이 제어 시퀀스이면 그 |eqtb| 위치를 |curCs|에 넣고, 그렇지 않으면 |curCs|를 0으로 놓는다.
이 프로시저는 매크로를 펼치지 않는다. 펼치는 것은 그 위의 |expand|가 맡는다.

이렇게 간단히 말할 수 있지만, 그 밑에는 다루어야 할 온갖 경우 때문에 꽤 복잡한 것이 깔려 있다. 그래도 |getNext|의
안쪽 루프는 꽤 짧고 빠르다.

명령 \.{\\read}가 읽는 줄의 다음 토큰을 달라고 했는데 그 줄에 토큰이 더 없으면, |getNext|는
|curCmd=curChr=curCs=0|으로 놓는다. (줄 끝 문자 |endLineChar|의 catcode가 |ignore|라면 줄에 토큰이 아예 없을 수도
있다.)

@ 변수 |parLoc|의 값은 `\.{\\par}'의 |eqtb| 주소다. 입력의 빈 줄은 \.{\\par}가 나타난 것과 정확히 같아야 하므로 이
값이 필요하다. 빈 줄을 알아채면 |curCs=parLoc|으로 놓는다. 그래서 사용자가 \.{\\par}를 다시 정의하면 빈 줄의 뜻도
함께 바뀐다.

@<전역 변수@>=
var @!parLoc pointer // |eqtb|에서 `\.{\\par}'의 위치
var @!parToken halfword // `\.{\\par}'를 나타내는 토큰

@ 원시 명령 \.{\\par}를 넣으면서 그 위치와 토큰을 기억해 둔다. 수정자 256은 |scanFileName|에서 쓴다.
@<\TeX의 원시 명령을...@>=
primitive("par", parEnd, 256) // |scanFileName| 참조
@!@:par_}{\.{\\par} primitive@>
parLoc = curVal
parToken = csTokenFlag + parLoc

@ @<원시 명령의 이름을 찍는...@>=
case parEnd:
	printEsc("par")

@ 프로시저 |getNext|로 들어가기 전에, `\.{\\outer}' 제어 시퀀스를 훑었을 때나 파일 끝에 이르렀을 때 부르는 서브루틴을
살펴보자. 두 경우는 |curCs|로 가린다. 파일 끝에서는 |curCs|가 0이다. 훑개가 정상 상태(|scannerStatus=normal|)이면
아무 문제도 없다. 그렇지 않으면 매크로를 정의하거나 인자를 읽는 도중에, 또는 조건문의 건너뛰는 텍스트 도중에
\.{\\outer} 명령이나 파일 끝이 나온 것이므로 오류다. 조건문을 건너뛰는 중이었다면 `\.{Incomplete \\if...}'를
알리고 \.{\\fi}를 끼워 넣는다.

@<함수들@>=
func checkOuterValidity() {
	var p pointer // 끼워 넣은 토큰 목록을 가리킨다
	var q pointer // 보조 포인터
	if scannerStatus != normal {
		deletionsAllowed = false
		@<바깥 제어 시퀀스를 다시 읽을 수 있도록 되돌린다@>
		if scannerStatus > skipping {
			@<무엇이 폭주했는지 사용자에게 알리고 회복해 본다@>
		} else {
			printErr("Incomplete ")
			printCmdChr(ifTest, curIf)
@.Incomplete \\if...@>
			printStr("; all text was ignored after line ")
			printInt(skipLine)
			help3("A forbidden control sequence occurred in skipped text.",
				"This kind of error happens when you say `\\if...' and forget",
				"the matching `\\fi'. I've inserted a `\\fi'; this might work.")
			if curCs != 0 {
				curCs = 0
			} else {
				helpLine[2] = "The file ended while I was skipping conditional text."
			}
			curTok = csTokenFlag + frozenFi
			insError()
		}
		deletionsAllowed = true
	}
}

@ 바깥 제어 시퀀스는 오류를 알린 뒤에 다시 읽을 수 있도록 되돌려 놓고, 지금 토큰은 공백으로 바꾼다. 다만
명령 \.{\\read}로 읽는 줄에 나온 바깥 제어 시퀀스는 다시 읽지 않는다. 그 명령의 오류 복구는 그리 튼튼하지 않기
때문이다.

@<바깥 제어 시퀀스를 다시...@>=
if curCs != 0 {
	if state == tokenList || name < 1 || name > 17 {
		p = getAvail()
		setInfo(p, csTokenFlag+curCs)
		backList(p) // 제어 시퀀스를 다시 읽을 준비를 한다
	}
	curCmd = spacer
	curChr = ' ' // 그것을 공백으로 바꾼다
}

@ 무엇이 폭주했는지 알리고 수습해 본다. 메시지는 `\.{! File ended while scanning use of \\foo.}'나
`\.{! Forbidden control sequence found while scanning definition of \\foo.}' 같은 꼴이 된다.
@<무엇이 폭주했는지...@>=
runaway() // 정의나 인자나 서문을 찍는다
if curCs == 0 {
	printErr("File ended")
@.File ended while scanning...@>
} else {
	curCs = 0
	printErr("Forbidden control sequence found")
@.Forbidden control sequence...@>
}
printStr(" while scanning ")
@<`\.{definition}'이나 `\.{use}'나 `\.{preamble}'이나 `\.{text}'를 찍고,
  회복으로 이끌 토큰들을 끼워 넣는다@>
printStr(" of ")
sprintCs(warningIndex)
help4("I suspect you have forgotten a `}', causing me",
	"to read past where you wanted me to stop.",
	"I'll try to recover; but if the error is serious,",
	"you'd better type `E' or `X' now and fix your file.")
reportError()

@ 수습하는 절차는 그만두어야 할 \TeX\ 루틴들을 더 알아야 온전히 이해할 수 있지만, 그 생각을 여기서 대강 그려
볼 수는 있다. 폭주한 정의나 폭주한 균형 텍스트에는 오른쪽 중괄호를 끼워 넣는다. 폭주한 서문에는 특별한 \.{\\cr}
토큰과 오른쪽 중괄호를 끼워 넣는다. 폭주한 인자에는 |longState|를 |outerCall|로 놓고 \.{\\par}를 끼워 넣는다.
그러면 인자를 읽던 루틴이 \.{\\par}를 보고 인자를 끝낸다.

@<`\.{definition}'이나...@>=
p = getAvail()
switch scannerStatus {
case defining:
	printStr("definition")
	setInfo(p, rightBraceToken+'}')
case matching:
	printStr("use")
	setInfo(p, parToken)
	longState = outerCall
case aligning:
	printStr("preamble")
	setInfo(p, rightBraceToken+'}')
	q = p
	p = getAvail()
	setLink(p, q)
	setInfo(p, csTokenFlag+frozenCr)
	alignState = -1000000
case absorbing:
	printStr("text")
	setInfo(p, rightBraceToken+'}')
} // 다른 경우는 없다
insList(p)

@ 여기서 프로시저 |getNext|가 부를 수도 있는 프로시저 하나를 짚어 두자. 바로 |firmUpTheLine|인데,
\secref{firm-up}에서 정의한다.

@ 이제 |getNext| 자체로 뛰어들 차례다. 이 루틴의 몇몇 부분은 \TeX의 다른 어떤 명령보다 자주 실행된다. 짜임새는
단순하다. 파일에서 읽는 중이면 문자를 하나 읽어 catcode에 따라 처리하고, 토큰 목록에서 읽는 중이면 다음 토큰을
꺼낸다. 어느 쪽이든 정렬의 항목이 끝나는 곳이면 그에 맞는 일을 한다.
@^mastication@>@^inner loop@>

@<함수들@>=
func getNext() { // |curCmd|, |curChr|, |curCs|를 다음 토큰으로 놓는다
	var k int32 // |buffer|의 첨자; |0 .. bufSize|
	var t halfword // 토큰
	var cat int32 // 대개 |catCode(curChr)|; |0 .. maxCharCode|
	var c, cc asciiCode // 펼쳐질 수 있는 코드의 구성 요소
	var d int32 // 펼쳐진 코드에서 남는 문자의 수; |2..3|
restart: // 다음 입력 토큰을 얻으려면 여기로 간다
	curCs = 0
	if state != tokenList {
		@<바깥 파일에서 입력하고, 입력이 없으면 |goto restart|@>
	} else {
		@<토큰 목록에서 입력하고, 목록이 끝났거나 매개변수를 펼쳐야 하면 |goto restart|@>
	}
	@<정렬 항목이 방금 끝났으면 알맞은 조치를 한다@>
}

@ 정렬 항목은 탭이나 \.{\\cr}이 나타났을 때 끝난다. 다만 그때의 중괄호 수준이 그 정렬 항목이 시작할 때와 같아야
한다. 곧 |alignState|가 그 항목의 \<u_j> 틀을 읽은 뒤의 값으로 돌아와 있어야 한다. 그래서
`\.{\{a\&b\}}'처럼 중괄호 안에 숨은 \.\&는 항목을 끝내지 않는다.
@^inner loop@>

@<정렬 항목이 방금...@>=
if curCmd <= carRet {
	if curCmd >= tabMark {
		if alignState == 0 {
			@<\<v_j> 틀을 끼워 넣고 |goto restart|@>
		}
	}
}

@ 파일에서 읽는 경우다. 현재 줄에 문자가 남아 있으면 하나를 꺼내 그 catcode를 보고, 줄을 다 읽었으면 다음 줄을
읽는다. 레이블 |scanNext|로 가면 파일에서 다음 문자를 먹고, |reswitch|로 가면 지금 문자를 다시 소화한다. \GO/의
|goto|는 블록 안으로는 뛸 수 없지만 둘러싼 블록의 레이블로는 앞으로든 뒤로든 뛸 수 있다. 여기의 |goto|는 모두
그런 경우다.

@<바깥 파일에서 입력하고...@>=
@^inner loop@>
scanNext: // 파일에서 다음 문자를 먹으려면 여기로 간다
if loc <= limit { // 현재 줄을 아직 다 읽지 않았다
	curChr = buffer[loc]
	loc++
reswitch: // 그것을 다시 소화하려면 여기로 간다
	curCmd = catCode(curChr)
	@<필요하면 상태를 바꾸고, 무시할 문자면 |goto scanNext|, 다른 문자로
	  바뀌면 |goto reswitch|@>
} else {
	state = newLine
	@<파일의 다음 줄로 옮겨 가거나, 다음 줄이 없으면 |goto restart|,
	  \.{\\read} 줄이 끝났으면 |return|@>
	checkInterrupt()
	goto scanNext
}

@ 다음의 48갈래 전환은, 컴파일러가 그것을 점프 표로 옮긴다고 하면, 훑기를 빠르게 해 준다. 상태 |midLine|,
|skipBlanks|, |newLine|의 수 값이 서로 |maxCharCode+1|만큼씩 떨어져 있으므로, 문자의 명령 코드를 상태에 더하면 두
정보를 함께 담은 수 하나를 얻는다는 데 눈여겨보자. 같은 명령 코드 |c|에 대한 세 상태의 경우 |midLine+c|,
|skipBlanks+c|, |newLine+c|는 흔히 한 |case|에 나란히 늘어놓는다. 보통의 글자나 기타 문자는 어느 갈래에도 걸리지
않고 |default|로 빠져나가므로, 가장 흔한 경우가 가장 빠르다.

@<필요하면 상태를 바꾸고...@>=
switch state + curCmd {
@<문자를 무시하는 경우들@>
case midLine + escape, skipBlanks + escape, newLine + escape:
	@<제어 시퀀스를 훑고 |state=skipBlanks|나 |midLine|으로 놓는다@>
case midLine + activeChar, skipBlanks + activeChar, newLine + activeChar:
	@<능동 문자 제어 시퀀스를 처리하고 |state=midLine|으로 놓는다@>
case midLine + supMark, skipBlanks + supMark, newLine + supMark:
	@<이 |supMark|가 \.{\^\^A}나 \.{\^\^df} 같은 펼친 문자를 시작하면
	  |goto reswitch|, 아니면 |state=midLine|@>
case midLine + invalidChar, skipBlanks + invalidChar, newLine + invalidChar:
	@<잘못된 문자를 꾸짖고 |goto restart|@>
@<공백, 중괄호, 상태 변화가 얽힌 상황을 다룬다@>
default:
	// 아무것도 하지 않는다
}

@ 이 절은 문자를 무시하는 경우들의 |case| 절 전체를 담는다. 무시할 문자(catcode 9)는 언제나, 공백은 줄의 처음이나
공백 건너뛰기 상태에서 무시한다. \.{gtangle}은 이름 있는 절의 앞뒤에서 줄을 바꾸므로(\secref{print-char}) |case|
레이블의 목록만 따로 끼워 넣을 수는 없기 때문이다.

@<문자를 무시하는...@>=
case midLine + ignore, skipBlanks + ignore, newLine + ignore,
	skipBlanks + spacer, newLine + spacer:
	goto scanNext

@ 잘못된 문자(catcode 15)를 만나면 꾸짖고 그 문자를 버린다. 오류를 처리하고 나면 |state|가 |tokenList|일 수도
있으므로(|clearForErrorPrompt|를 보라) |scanNext|가 아니라 |restart|로 간다.

@<잘못된 문자를...@>=
printErr("Text line contains an invalid character")
@.Text line contains...@>
help2("A funny symbol that I can't read has just been input.",
	"Continue, and I'll forget that it ever happened.")
deletionsAllowed = false
reportError()
deletionsAllowed = true
goto restart

@ 공백, 줄 끝, 주석, 중괄호처럼 상태를 바꾸는 문자들이다. 중괄호는 |alignState|를 고치고 상태를 |midLine|으로
바꾼다. 마지막 |case|에는 명령 코드 |mathShift|, |tabMark|, |macParam|, |subMark|, |letter|, |otherChar|에 세 상태를
저마다 더한 열여덟 경우가 늘어선다. 이런 문자를 읽으면 상태는 |midLine|이 된다.

@<공백, 중괄호, 상태 변화가...@>=
case midLine + spacer:
	@<|skipBlanks| 상태에 들어가고 공백을 내보낸다@>
case midLine + carRet:
	@<줄을 끝내고 공백을 내보낸다@>
case skipBlanks + carRet, midLine + comment, skipBlanks + comment, newLine + comment:
	@<줄을 끝내고 |goto scanNext|@>
case newLine + carRet:
	@<줄을 끝내고 \.{\\par}를 내보낸다@>
case midLine + leftBrace:
	alignState++
case skipBlanks + leftBrace, newLine + leftBrace:
	state = midLine
	alignState++
case midLine + rightBrace:
	alignState--
case skipBlanks + rightBrace, newLine + rightBrace:
	state = midLine
	alignState--
case skipBlanks + mathShift, skipBlanks + tabMark, skipBlanks + macParam,
	skipBlanks + subMark, skipBlanks + letter, skipBlanks + otherChar,
	newLine + mathShift, newLine + tabMark, newLine + macParam,
	newLine + subMark, newLine + letter, newLine + otherChar:
	state = midLine

@ 줄 한가운데에서 줄 끝을 만나면 그 줄의 나머지를 버리고 공백을 내보낸다. 형이 |spacer|인 문자는 무엇이든 그 문자
코드를 $\.{"\ "}=@'40$으로 바꾸어 내보낸다. 그래서 탭이든 공백이든 줄 끝에 끼워 넣은 공백이든, 매크로 매개변수를
맞출 때에는 똑같이 다루어진다. 대부분의 컴퓨터 터미널 화면에서는 이런 문자들을 눈으로 구별할 수 없기 때문이다.

@<줄을 끝내고 공백을...@>=
loc = limit + 1
curCmd = spacer
curChr = ' '

@ 줄 한가운데의 공백이다. 다음 코드는 |curCmd=spacer|일 때에만 실행된다. 공백을 하나 내보내고, 그 뒤로 이어지는
공백은 무시하도록 |skipBlanks| 상태로 들어간다.

@<|skipBlanks| 상태에...@>=
state = skipBlanks
curChr = ' '

@ 주석 문자를 만났거나, 공백을 건너뛰는 중에 줄 끝을 만났다. 줄의 나머지를 버리고 다음 문자로 간다.
@<줄을 끝내고 |goto scanNext|@>=
loc = limit + 1
goto scanNext

@ 줄의 처음에서 줄 끝을 만났다. 곧 빈 줄이다. 줄의 나머지를 버리고 \.{\\par}를 내보낸다. 명령 \.{\\par}가 \.{\\outer}로
다시 정의되어 있을 수도 있으므로 그것도 검사한다.
@<줄을 끝내고 \.{\\par}를...@>=
loc = limit + 1
curCs = parLoc
curCmd = eqType(curCs)
curChr = equiv(curCs)
if curCmd >= outerCall {
	checkOuterValidity()
}

@ 위첨자 문자 둘이 잇달아 나오면 펼친 문자일 수 있다. `\.{\^\^}' 다음에 소문자 16진 숫자가 둘 오면 그 두 숫자가
나타내는 코드가 되고, 그렇지 않으면 그 다음 문자의 코드에 64를 더하거나 뺀 것이 된다. 이를테면 \.{\^\^M}은
캐리지 리턴, \.{\^\^e9}는 코드 233이다. \.{\^\^8} 같은 것은 뒤에 16진 숫자가 하나 더 오지 않으면 \.x가 된다는 데
눈여겨보자(\.8의 코드 56에 64를 더하면 120, 곧 \.x다). 펼친 문자는 원래 거기 있던 문자처럼 다시 소화한다.

@<이 |supMark|가...@>=
if curChr == buffer[loc] {
	if loc < limit {
		c = buffer[loc+1]
		if c < 0o200 { // 그렇다, 펼친 문자가 있다
			loc += 2
			if isHex(c) {
				if loc <= limit {
					cc = buffer[loc]
					if isHex(cc) {
						loc++
						hexToCurChr(c, cc)
						goto reswitch
					}
				}
			}
			if c < 0o100 {
				curChr = c + 0o100
			} else {
				curChr = c - 0o100
			}
			goto reswitch
		}
	}
}
state = midLine

@ 함수 |hexToCurChr|는 16진 숫자 두 개 |c|와 |cc|가 나타내는 코드를 |curChr|에 넣는다. 16진 숫자로는 \.0--\.9와
소문자 \.a--\.f만 받아들인다.

@<정의@>=
func isHex(c asciiCode) bool {
	return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')
}

func hexToCurChr(c, cc asciiCode) {
	if c <= '9' {
		curChr = c - '0'
	} else {
		curChr = c - 'a' + 10
	}
	if cc <= '9' {
		curChr = 16*curChr + cc - '0'
	} else {
		curChr = 16*curChr + cc - 'a' + 10
	}
}

@ 능동 문자는 제어 시퀀스처럼 그 |eqtb| 항목을 찾아 뜻을 얻는다. 능동 문자 뒤의 공백은 건너뛰지 않으므로 상태는
|midLine|이 된다.
@<능동 문자 제어...@>=
curCs = curChr + activeBase
curCmd = eqType(curCs)
curChr = equiv(curCs)
state = midLine
if curCmd >= outerCall {
	checkOuterValidity()
}

@ 제어 시퀀스 이름은 어떤 파일의 줄에 나타날 때에만 훑는다. 한번 훑고 나면 그 |eqtb| 위치가 유일한 식별자 노릇을
하므로, \TeX은 그 등가물을 기호로 찍을 때 말고는 원래 이름을 다시 볼 필요가 없다.

제어 시퀀스를 훑는 프로그램은, 악의적인 사용자가 `\.{\\catcode\char'47 15=0}' 같은 것을 시도할 때 일어날 수 있는
폭발을 피하도록 조심해서 썼다. 이 알고리즘은 |buffer[limit+1]|은 들여다볼 수 있지만 |buffer[limit+2]|는 결코
들여다보지 않는다.

제어 시퀀스 이름은 이렇게 정한다. 탈출 문자 바로 뒤의 문자가 글자가 아니면 그 문자 하나가 이름이다(제어 기호). 글자이면
글자가 아닌 문자가 나올 때까지 이어지는 글자들이 이름이다(제어 낱말). 제어 낱말이나 제어 공백 뒤에서는 공백을
건너뛰도록 상태를 |skipBlanks|로 놓는다. 탈출 문자가 줄의 마지막 문자이면 이름이 빈 제어 시퀀스, 곧
\.{\\csname\\endcsname}이 된다.

`\.{\^\^A}'나 `\.{\^\^df}' 같은 펼친 문자가 제어 시퀀스 이름 안이나 바로 뒤에 나타나면, 그것을 버퍼 안의 한 문자로
바꾸고 과정을 처음부터 되풀이한다. 느리지만 확실하게.

@<제어 시퀀스를 훑고...@>=
if loc > limit {
	curCs = nullCs // 이 경우에 |state|는 상관없다
} else {
startCs: // 제어 시퀀스를 찾기 시작하려면 여기로 간다
	k = loc
	curChr = buffer[k]
	cat = catCode(curChr)
	k++
	if cat == letter {
		state = skipBlanks
	} else if cat == spacer {
		state = skipBlanks
	} else {
		state = midLine
	}
	if cat == letter && k <= limit {
		@<버퍼에서 글자가 아닌 것을 찾을 때까지 앞서 훑는다@>
	} else {
		@<펼친 코드가 있으면 줄이고 |goto startCs|@>
	}
	curCs = singleBase + buffer[loc]
	loc++
}
found: // 제어 시퀀스를 찾았으면 여기로 간다
curCmd = eqType(curCs)
curChr = equiv(curCs)
if curCmd >= outerCall {
	checkOuterValidity()
}

@ 다음 코드에 이를 때면 언제나 |curChr=buffer[k-1]|이고 |k<=limit+1|이며 |cat=catCode(curChr)|다. \.{\^\^A}나 \.{\^\^df}
같은 펼친 코드가 |buffer[(k-1)..(k+1)]|이나 |buffer[(k-1)..(k+2)]|에 있으면, 그 코드를 |buffer[k-1]|에 넣고 버퍼의 나머지를
왼쪽으로 두세 자리 당긴다. 그런 다음 제어 시퀀스를 처음부터 다시 훑는다.

@<펼친 코드가 있으면...@>=
if buffer[k] == curChr {
	if cat == supMark {
		if k < limit {
			c = buffer[k+1]
			if c < 0o200 { // 그렇다, 정말로 하나 있다
				d = 2
				if isHex(c) {
					if k+2 <= limit {
						cc = buffer[k+2]
						if isHex(cc) {
							d++
						}
					}
				}
				if d > 2 {
					hexToCurChr(c, cc)
					buffer[k-1] = curChr
				} else if c < 0o100 {
					buffer[k-1] = c + 0o100
				} else {
					buffer[k-1] = c - 0o100
				}
				limit -= d
				first -= d
				for k <= limit {
					buffer[k] = buffer[k+d]
					k++
				}
				goto startCs
			}
		}
	}
}

@ 다음 코드는 버퍼에서 글자가 아닌 것이 나올 때까지 앞으로 훑는다. 펼친 코드를 만나면 그것을 줄이고 |goto startCs|하고,
여러 글자짜리 제어 시퀀스를 찾으면 |curCs|와 |loc|을 고치고 |goto found|한다.

@<버퍼에서 글자가 아닌...@>=
for {
	curChr = buffer[k]
	cat = catCode(curChr)
	k++
	if cat != letter || k > limit {
		break
	}
}
@<펼친 코드가 있으면...@>
if cat != letter {
	k--
} // 이제 |k|는 글자가 아닌 첫 문자를 가리킨다
if k > loc+1 { // 여러 글자짜리 제어 시퀀스를 훑었다
	curCs = idLookup(loc, k-loc)
	loc = k
	goto found
}

@ 이제 |getNext|가 토큰 목록을 읽을 때 무슨 일이 일어나는지 살펴보자. 토큰을 하나 꺼내 제어 시퀀스이면 그 뜻을
찾아 |curCmd|와 |curChr|에 넣고, 문자이면 토큰을 명령 코드와 문자 코드로 나눈다. 중괄호이면 |alignState|를 고친다.
매크로 매개변수를 나타내는 |outParam| 토큰이면 그 매개변수의 토큰 목록을 새 입력 수준으로 시작한다. 목록을 다
읽었으면 그 수준을 떠나 처음부터 다시 한다.

@<토큰 목록에서 입력하고...@>=
if loc != null { // 목록을 다 쓰지 않았다
@^inner loop@>
	t = info(loc)
	loc = link(loc) // 다음으로 옮겨 간다
	if t >= csTokenFlag { // 제어 시퀀스 토큰
		curCs = t - csTokenFlag
		curCmd = eqType(curCs)
		curChr = equiv(curCs)
		if curCmd >= outerCall {
			if curCmd == dontExpand {
				@<펼치기를 억누르고 다음 토큰을 얻는다@>
			} else {
				checkOuterValidity()
			}
		}
	} else {
		curCmd = t / 0o400
		curChr = t % 0o400
		switch curCmd {
		case leftBrace:
			alignState++
		case rightBrace:
			alignState--
		case outParam:
			@<매크로 매개변수를 끼워 넣고 |goto restart|@>
		default:
			// 아무것도 하지 않는다
		}
	}
} else { // 이 토큰 목록은 다 썼다
	endTokenList()
	goto restart // 앞 수준으로 돌아간다
}

@ \seclabel{get-next-noexpand}프로그램이 이 지점에 이르는 것은 루틴 |expand|가 \.{\\noexpand} 때문에 입력에 특별한 표시를 끼워 넣었을 때뿐이다.
이 특별한 경우에는 |info(loc)|이 제어 시퀀스 토큰이고 |link(loc)=null|임이 보장되어 있다. 그 제어 시퀀스가 펼칠
수 있는 것이면, 이번 한 번만은 펼치지 않도록 \.{\\relax}의 특별한 변종으로 바꾸어 내보낸다.

@<펼치기를 억누르고...@>=
curCs = info(loc) - csTokenFlag
loc = null
curCmd = eqType(curCs)
curChr = equiv(curCs)
if curCmd > maxCommand {
	curCmd = relax
	curChr = noExpandFlag
}

@ 펼치지 않기로 한 토큰은 수정자가 |noExpandFlag|인 |relax| 명령이 된다. 실행하면 \.{\\relax}와 같지만, \.{\\edef}
안에서는 원래의 제어 시퀀스 토큰이 그대로 저장된다.
@<정의@>=
const @!noExpandFlag = 257 // |relax|의 특별한 변종을 나타낸다

@ 매크로 매개변수 \.{\#}$n$을 만나면, 저장해 둔 그 인자의 토큰 목록을 새 입력 수준으로 읽기 시작한다.
@<매크로 매개변수를...@>=
beginTokenList(paramStack[paramStart()+curChr-1], parameter)
goto restart

@ 이제 |getNext|의 쉬운 갈래들은 다 다루었다. 줄을 다 읽었을 때의 갈래가 하나 남았다. 파일이면 다음 줄을 읽고,
\.{\\read}의 줄이면 빈 토큰을, 오류 때 끼워 넣은 줄이면 앞 수준으로 돌아간다. 맨 바깥의 터미널이면 `\.*'로
재촉해 새 줄을 받되, 대화하지 않는 모드라면 기다릴 수 없으므로 치명적인 오류로 끝낸다.

@<파일의 다음 줄로...@>=
if name > 17 {
	@<파일의 다음 줄을 |buffer|에 읽거나, 파일이 끝났으면 |goto restart|@>
} else {
	if !terminalInput() { // \.{\\read} 줄이 끝났다
		curCmd = 0
		curChr = 0
		return
	}
	if inputPtr > 0 { // 오류 복구 중에 끼워 넣은 텍스트
		endFileReading()
		goto restart // 앞 수준으로 돌아간다
	}
	if selector < logOnly {
		openLogFile()
	}
	if interaction > nonstopMode {
		if endLineCharInactive() {
			limit++
		}
		if limit == start { // 앞 줄이 비어 있었다
			printNl("(Please type a command or say `\\end')")
		}
@.Please type...@>
		printLn()
		first = start
		promptInput("*") // 화면에서 |buffer|로 입력한다
@.*\relax@>
		limit = last
		if endLineCharInactive() {
			limit--
		} else {
			buffer[limit] = endLineChar()
		}
		first = limit + 1
		loc = start
	} else {
		fatalError("*** (job aborted, no legal \\end found)")
@.job aborted@>
		// 밤새 일괄 처리하려는 비멈춤 모드에서는 화면 입력을 결코 기다리지 않는다
	}
}

@ 줄 끝 문자 \.{\\endlinechar}가 0부터 255까지의 범위 밖이면 줄 끝에 아무것도 덧붙이지 않는다.
@<정의@>=
func endLineCharInactive() bool { return endLineChar() < 0 || endLineChar() > 255 }

@ 전역 변수 |forceEOF|는 보통 |false|이고, \.{\\endinput} 명령이 |true|로 놓는다. 그러면 지금 줄을 다 읽은 뒤에
그 파일을 끝난 것으로 본다.

@<전역 변수@>=
var @!forceEOF bool // 다음 \.{\\input}을 일찍 그만두어야 하나?

@ 파일의 다음 줄을 읽는다. 파일이 끝났거나 \.{\\endinput}을 만났으면 `\.)'를 찍어 그 파일을 다 읽었음을 알리고
앞 수준으로 돌아간다. 줄을 읽었으면 그 끝에 |endLineChar|를 덧붙인다.
@<파일의 다음 줄을...@>=
line++
first = start
if !forceEOF {
	if inputLn(curFile(), true) { // 파일의 끝이 아니다
		firmUpTheLine() // 이것이 |limit|를 정한다
	} else {
		forceEOF = true
	}
}
if forceEOF {
	printChar(')')
	openParens--
	updateTerminal() // 파일을 다 읽었음을 사용자에게 보인다
	forceEOF = false
	endFileReading() // 앞 수준으로 돌아간다
	checkOuterValidity()
	goto restart
}
if endLineCharInactive() {
	limit--
} else {
	buffer[limit] = endLineChar()
}
first = limit + 1
loc = start // 읽을 준비가 되었다

@ \seclabel{firm-up}사용자가 매개변수 \.{\\pausing}을 양수로 정했고 |nonstopMode|보다 높은 대화 모드에 있다면, 입력의 줄마다
터미널과 기록 파일에 보이고 그 뒤에 `\.{=>}'를 찍는다. 그리고 \TeX은 대답을 기다린다. 대답이 그냥 |carriageReturn|이면
그 줄을 그대로 받아들이고, 그렇지 않으면 파일의 줄 대신 사용자가 친 줄을 쓴다. 입력 파일을 한 줄씩 살펴보며
고쳐 보고 싶을 때 쓸모 있다.

@<함수들@>=
func firmUpTheLine() {
	var k int32 // |buffer|의 첨자; |0 .. bufSize|
	limit = last
	if pausing() > 0 {
		if interaction > nonstopMode {
			wakeUpTerminal()
			printLn()
			if start < limit {
				for k = start; k <= limit-1; k++ {
					printStr(buffer[k])
				}
			}
			first = limit
			promptInput("=>") // 사용자의 대답을 기다린다
@.=>@>
			if last > first {
				for k = first; k <= last-1; k++ { // 줄을 버퍼 아래로 옮긴다
					buffer[k+start-first] = buffer[k]
				}
				limit = start + last - first
			}
		}
	}
}

@ 프로시저 |getNext|는 \TeX에서 아주 자주 쓰이므로, 그보다 조금 더 많은 일을 하는 관련 프로시저 셋을 정의해 두면
편하다.

\yskip\hang|getToken|은 |curCmd|와 |curChr|만이 아니라, 현재 토큰을 하프워드 하나로 꾸린 |curTok|도 정한다.

\yskip\hang|getXToken|은 ``펼친 토큰을 얻는다''는 뜻이다. 프로시저 |getToken|과 같지만, 현재 토큰이 사용자가 정의한 제어
시퀀스(곧 매크로 호출)나 조건문, 또는 \.{\\topmark}, \.{\\expandafter}, \.{\\csname} 같은 것으로 드러나면 매크로를
펼치거나 조건문을 계산해서 그것을 입력에서 없앤다. 그래서 |getXToken|이 돌려주는 토큰은 언제나 더는 펼칠 수 없는
것이다.

\yskip\hang|xToken|은 |getXToken|과 같지만, |getNext|를 이미 불렀다고 가정한다.

\yskip\noindent
사실 |getNext|를 쓰는 곳은 거의 모두 이 세 프로시저를 거친다.

@ \seclabel{get-token}프로시저 |getToken|을 부르는 동안과 \.{\\csname}이 토큰 목록을 압축할 때 말고는 새 제어 시퀀스가 정의되지
않는다. 다른 때에는 |noNewControlSequence|가 언제나 |true|이기 때문이다. 토큰은 제어 시퀀스이면 |csTokenFlag+curCs|로,
문자이면 $2^8\cdot|curCmd|+|curChr|$로 꾸린다(\secref{tokens}).

@<함수들@>=
func getToken() { // |curCmd|, |curChr|, |curTok|를 정한다
	noNewControlSequence = false
	getNext()
	noNewControlSequence = true
@^inner loop@>
	if curCs == 0 {
		curTok = (curCmd * 0o400) + curChr
	} else {
		curTok = csTokenFlag + curCs
	}
}

@* 다음 토큰 펼치기.
프로시저 |getNext|가 돌려줄 수 있는 명령 코드 가운데 |>maxCommand|인 것은 열두어 개뿐이다. 작은 것부터 차례로
|undefinedCs|, |expandAfter|, |noExpand|, |input|, |ifTest|, |fiOrElse|, |csName|, |convert|, |the|,
|topBotMark|, |call|, |longCall|, |outerCall|, |longOuterCall|, |endTemplate|이다. 이것들이 바로 ``펼칠 수 있는''
명령이다.

서브루틴 |expand|는 |curCmd>maxCommand|일 때 부른다. 이 서브루틴은 매크로 ``호출''이나 조건문이나 방금 늘어놓은
다른 특별한 연산 가운데 하나를 처리해서 없앤다. 그러다 보면 |expand|가 자기 자신을 다시 부를 수도 있다. 어떤
경우든 |expand|는 현재 토큰을 없애고, 다음 |getNext|가 알맞은 다음 토큰을 내주도록 준비해 둔다. 이를테면 매크로를
펼치면 그 본문이 입력 스택에 올라가므로, 다음 |getNext|는 본문의 첫 토큰을 내준다. 프로시저 |expand|를 부를 때
|curTok|의 값은 상관없다.

기본 훑기 루틴 몇몇은 전역 변수로 서로 정보를 주고받으므로, 재귀 호출이 그 값을 망가뜨리지 않도록 |expand|의
지역 변수에 저장해 둔다.
@^recursion@>


@<함수들@>=
@<|macroCall|이라는 프로시저를 선언한다@>
@<|insertRelax|라는 프로시저를 선언한다@>
func expand() {
	var t halfword // ``뒤에 펼쳐지는'' 토큰
	var p, q, r pointer // 목록을 다루기 위해
	var j int32 // |buffer|의 첨자; |0 .. bufSize|
	var saveScannerStatus smallNumber // |scannerStatus|를 잠시 저장한다
	cvBackup := curVal // 전역 양 |curVal|을 저장한다
	cvlBackup := curValLevel // |curValLevel| 따위를 저장한다
	radixBackup := radix
	coBackup := curOrder
	backupBackup := link(backupHead) // |link(backupHead)|를 저장한다
	if curCmd < call {
		@<매크로가 아닌 것을 펼친다@>
	} else if curCmd < endTemplate {
		macroCall()
	} else {
		@<|frozenEndv|를 담은 토큰을 끼워 넣는다@>
	}
	curVal = cvBackup
	curValLevel = cvlBackup
	radix = radixBackup
	curOrder = coBackup
	setLink(backupHead, backupBackup)
}

@ 매크로가 아닌 펼칠 수 있는 명령들이다. 매개변수 \.{\\tracingcommands}가 1보다 크면 이런 명령도 펼칠 때마다 보여 준다.
정의되지 않은 제어 시퀀스를 만나면 오류를 알린다.
@<매크로가 아닌 것을...@>=
if tracingCommands() > 1 {
	showCurCmdChr()
}
switch curCmd {
case topBotMark:
	@<알맞은 표시 텍스트를 훑개에 끼워 넣는다@>
case expandAfter:
	@<다음 토큰 뒤의 토큰을 펼친다@>
case noExpand:
	@<다음 토큰의 펼치기를 억누른다@>
case csName:
	@<제어 시퀀스 이름을 만들어 낸다@>
case convert:
	convToks() // 이 프로시저는 아래 27부에서 다룬다
case the:
	insTheToks() // 이 프로시저는 아래 27부에서 다룬다
case ifTest:
	conditional() // 이 프로시저는 아래 28부에서 다룬다
case fiOrElse:
	@<현재 조건문을 끝내고 \.{\\fi}까지 건너뛴다@>
case input:
	@<파일에서 입력을 시작하거나 끝낸다@>
default:
	@<정의되지 않은 매크로를 불평한다@>
}

@ \TeX이 \.{\\expandafter}라고 부르는 일은 토큰을 조금 뒤섞기만 하면 된다. 다음 토큰 |t|를 하나 읽어 두고, 그 다음
토큰을 한 번 펼친 다음, |t|를 그 앞에 되돌려 놓는다. 이를테면 `\.{\\expandafter\\a\\b}'는 \.{\\b}를 먼저 한 단계
펼치고 그 결과 앞에 \.{\\a}를 둔다.

@<다음 토큰 뒤의...@>=
getToken()
t = curTok
getToken()
if curCmd > maxCommand {
	expand()
} else {
	backInput()
}
curTok = t
backInput()

@ 명령 \.{\\noexpand}의 구현은 조금 더 까다롭다. \TeX의 읽기 장치에 특별한 `|dontExpand|' 표시를 끼워 넣어야 하기
때문이다. 다음 토큰을 되돌려 놓고, 그것이 제어 시퀀스이면 그 앞에 표시를 붙인다. 이 특별한 표시는 |getNext|가
처리하지만(\secref{get-next-noexpand}), 안쪽 루프를 느리게 하지는 않는다.

다음 토큰이 \.{\\outer} 매크로일 수도 있으므로, 읽는 동안에는 |scannerStatus|를 잠시 지워 두어야 한다.

@<다음 토큰의 펼치기를...@>=
saveScannerStatus = scannerStatus
scannerStatus = normal
getToken()
scannerStatus = saveScannerStatus
t = curTok
backInput() // 이제 |start|와 |loc|은 되돌린 토큰 |t|를 가리킨다
if t >= csTokenFlag {
	p = getAvail()
	setInfo(p, csTokenFlag+frozenDontExpand)
	setLink(p, loc)
	start = p
	loc = p
}

@ 정의되지 않은 제어 시퀀스를 만났을 때 내는 오류다. 사용자들이 가장 자주 보는 오류 메시지일 것이다.
@<정의되지 않은 매크로를...@>=
printErr("Undefined control sequence")
@.Undefined control sequence@>
help5("The control sequence at the end of the top line",
	"of your error message was never \\def'ed. If you have",
	"misspelled it (e.g., `\\hobx'), type `I' and the correct",
	"spelling (e.g., `I\\hbox'). Otherwise just continue,",
	"and I'll forget about whatever was undefined.")
reportError()

@ 프로시저 |expand|와 토큰 목록을 만드는 몇몇 루틴은 다음 함수들을 쓰면 편리하다. 토큰 |t|를 새 노드에 담아 |p|가
가리키는 목록 끝에 붙이고, |p|를 그 새 노드로 옮긴다. 이 함수들은 부르는 쪽의 변수 |p|와 |q|를 토큰 목록을 만드는
데만 쓸 때에만 알맞다. 부르는 쪽의 지역 변수를 바꾸어야 하므로, 이를테면 |storeNewToken(&p,&q,curTok)|처럼 그
변수들을 가리키는 포인터를 넘긴다.

@<정의@>=
func storeNewToken(p, q *pointer, t halfword) {
	*q = getAvail()
	setLink(*p, *q)
	setInfo(*q, t)
	*p = *q // |link(p)|는 |null|이다
}

func fastStoreNewToken(p, q *pointer, t halfword) {
	*q = fastGetAvail()
	setLink(*p, *q)
	setInfo(*q, t)
	*p = *q // |link(p)|는 |null|이다
}

@ 명령 \.{\\csname}을 만나면 \.{\\endcsname}이 나올 때까지 펼친 토큰을 읽어 문자 토큰들을 목록 |r|에 모으고, 그 문자들로
된 이름의 제어 시퀀스를 찾는다. 그 제어 시퀀스가 아직 정의되지 않았으면 \.{\\relax}와 같은 뜻으로 정의해 둔다. 그리고
그 제어 시퀀스의 토큰을 입력에 되돌려 놓는다.
@<제어 시퀀스 이름을...@>=
r = getAvail()
p = r // 문자 목록의 머리
for {
	getXToken()
	if curCs == 0 {
		storeNewToken(&p, &q, curTok)
	}
	if curCs != 0 {
		break
	}
}
if curCmd != endCsName {
	@<\.{\\endcsname}이 빠졌다고 불평한다@>
}
@<목록 |r|의 문자들을 해시 표에서 찾아 |curCs|를 정한다@>
flushList(r)
if eqType(curCs) == undefinedCs {
	eqDefine(curCs, relax, 256) // 주의: |saveStack|이 바뀔 수도 있다
} // 이제 그 제어 시퀀스는 `\.{\\relax}'와 맞는다
curTok = curCs + csTokenFlag
backInput()

@ 명령 \.{\\csname}과 \.{\\endcsname} 사이에 펼칠 수 없는 제어 시퀀스가 나오면 \.{\\endcsname}이 빠진 것으로 보고 알린다.
@<\.{\\endcsname}이 빠졌다고...@>=
printErr("Missing ")
printEsc("endcsname")
printStr(" inserted")
@.Missing \\endcsname...@>
help2("The control sequence marked <to be read again> should",
	"not appear between \\csname and \\endcsname.")
backError()

@ 목록의 문자들을 버퍼로 옮겨서 해시 표에서 찾는다. 이때는 새 이름을 넣는 것을 허락한다. 이름이 한 글자이거나
비어 있으면 해시 표를 쓰지 않고 곧바로 주소를 계산한다.
@<목록 |r|의 문자들을...@>=
j = first
p = link(r)
for p != null {
	if j >= maxBufStack {
		maxBufStack = j + 1
		if maxBufStack == bufSize {
			overflow("buffer size", bufSize)
		}
@:TeX capacity exceeded buffer size}{\quad buffer size@>
	}
	buffer[j] = info(p) % 0o400
	j++
	p = link(p)
}
if j > first+1 {
	noNewControlSequence = false
	curCs = idLookup(first, j-first)
	noNewControlSequence = true
} else if j == first {
	curCs = nullCs // 목록이 비어 있다
} else {
	curCs = singleBase + buffer[first] // 목록의 길이가 1이다
}

@ 명령 |endTemplate|은 다음 코드로 사실상 |endv| 명령으로 바뀐다. (그 까닭은 나중에 이야기한다. 틀의 끝에 있는
|frozenEndTemplate|은 이미 |checkOuterValidity| 검사를 거쳤으므로 오류를 찾아내는 몫은 다 했다.)

@<|frozenEndv|를 담은...@>=
curTok = csTokenFlag + frozenEndv
backInput()

@ 명령 \.{\\input}은 나중에 선언할 서브루틴 |startInput|으로 처리한다. 그리고 \.{\\endinput}의 처리는 하찮다. 수정자가
0이면 \.{\\input}, 1이면 \.{\\endinput}이다.

@<\TeX의 원시 명령을...@>=
primitive("input", input, 0)
@!@:input_}{\.{\\input} primitive@>
primitive("endinput", input, 1)
@!@:end_input_}{\.{\\endinput} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case input:
	if chrCode == 0 {
		printEsc("input")
	} else {
		printEsc("endinput")
	}

@ 명령 \.{\\endinput}은 |forceEOF|만 놓는다. 그러면 지금 줄을 다 읽은 뒤에 파일이 끝난다. 파일 이름을 읽는 도중에
\.{\\input}이 나오면 이름이 엉킬 수 있으므로 \.{\\relax}를 끼워 넣어 이름을 먼저 끝낸다.
@<파일에서 입력을 시작하거나...@>=
if curChr > 0 {
	forceEOF = true
} else if nameInProgress {
	insertRelax()
} else {
	startInput()
}

@ 때로는 펼치기가 너무 앞을 내다본다. 그럴 때는 사용자의 입력에 해가 없는 \.{\\relax}를 끼워 넣고 싶다. 지금 토큰을
되돌리고 그 앞에 얼린 \.{\\relax}를 끼워 넣는다.

@<|insertRelax|라는...@>=
func insertRelax() {
	curTok = csTokenFlag + curCs
	backInput()
	curTok = csTokenFlag + frozenRelax
	backInput()
	setTokenType(inserted)
}

@ 다음은 \TeX이 입력의 다음 토큰을 얻는 보통의 방법인 재귀 프로시저다. 펼칠 수 있는 토큰이면 펼친 다음 다시 읽고, 펼칠
수 없는 토큰이 나올 때까지 되풀이한다. 흔한 경우를 생각해서 조금 최적화했다. 매크로라면 |expand|를 거치지 않고
곧바로 |macroCall|을 부른다.

@<함수들@>=
func getXToken() { // |curCmd|, |curChr|, |curTok|를 정하고 매크로를 펼친다
restart:
	getNext()
@^inner loop@>
	if curCmd <= maxCommand {
		goto done
	}
	if curCmd >= call {
		if curCmd < endTemplate {
			macroCall()
		} else {
			curCs = frozenEndv
			curCmd = endv
			goto done // |curChr=nullList|
		}
	} else {
		expand()
	}
	goto restart
done:
	if curCs == 0 {
		curTok = (curCmd * 0o400) + curChr
	} else {
		curTok = csTokenFlag + curCs
	}
}

@ 프로시저 |getXToken|은 본질적으로 프로시저 호출 두 번, 곧 |getNext; xToken|과 같다.

@<함수들@>=
func xToken() { // 처음의 |getNext|가 없는 |getXToken|
	for curCmd > maxCommand {
		expand()
		getNext()
	}
	if curCs == 0 {
		curTok = (curCmd * 0o400) + curChr
	} else {
		curTok = csTokenFlag + curCs
	}
}

@ 사용자가 \.{\\def}로 정의한 제어 시퀀스는 \TeX의 프로시저 |macroCall|이 펼친다.

그러나 |macroCall|의 자세한 내용에 들어가기 전에 \.{\\topmark} 같은 원시 명령의 처리를 살펴보자. 이것들은 본질적으로
매개변수 없는 매크로이기 때문이다. 이런 표시의 토큰 목록은 포인터 다섯 개짜리 전역 배열에 둔다. 이 배열의 항목은
|topMark| 따위의 기호 이름으로 가리킨다. 항목 |topMark|의 값은 |null|이거나 토큰 목록의 참조 횟수를 가리키는 포인터다.
쪽을 내보낼 때마다 쪽 조립기가 이 값들을 고친다.

이름 |topMark| 따위는 배열 원소의 다른 이름이므로, 다른 필드처럼 읽는 함수와 쓰는 함수의 짝(이를테면 |topMark()|와
|setTopMark(v)|)으로 만든다. 원소를 첨자로 훑는 곳에서는 |curMark[c]|를 바로 쓴다.

@<전역 변수@>=
const (
	@!topMarkCode = iota // 앞 쪽 나눔에서 효력이 있는 표시
	@!firstMarkCode // |topMark|와 |botMark| 사이의 첫 표시
	@!botMarkCode // 현재 쪽 나눔에서 효력이 있는 표시
	@!splitFirstMarkCode // \.{\\vsplit}이 찾은 첫 표시
	@!splitBotMarkCode // \.{\\vsplit}이 찾은 마지막 표시
)

func topMark() pointer         { return curMark[topMarkCode] }
func firstMark() pointer       { return curMark[firstMarkCode] }
func botMark() pointer         { return curMark[botMarkCode] }
func splitFirstMark() pointer { return curMark[splitFirstMarkCode] }
func splitBotMark() pointer   { return curMark[splitBotMarkCode] }
func setTopMark(v pointer)         { curMark[topMarkCode] = v }
func setFirstMark(v pointer)       { curMark[firstMarkCode] = v }
func setBotMark(v pointer)         { curMark[botMarkCode] = v }
func setSplitFirstMark(v pointer) { curMark[splitFirstMarkCode] = v }
func setSplitBotMark(v pointer)   { curMark[splitBotMarkCode] = v }

var @!curMark [splitBotMarkCode + 1]pointer // 표시들의 토큰 목록

@ 처음에는 표시가 하나도 없다.
@<핵심 변수들의...@>=
curMark[topMarkCode] = null
curMark[firstMarkCode] = null
curMark[botMarkCode] = null
curMark[splitFirstMarkCode] = null
curMark[splitBotMarkCode] = null

@ @<\TeX의 원시 명령을...@>=
primitive("topmark", topBotMark, topMarkCode)
@!@:top_mark_}{\.{\\topmark} primitive@>
primitive("firstmark", topBotMark, firstMarkCode)
@!@:first_mark_}{\.{\\firstmark} primitive@>
primitive("botmark", topBotMark, botMarkCode)
@!@:bot_mark_}{\.{\\botmark} primitive@>
primitive("splitfirstmark", topBotMark, splitFirstMarkCode)
@!@:split_first_mark_}{\.{\\splitfirstmark} primitive@>
primitive("splitbotmark", topBotMark, splitBotMarkCode)
@!@:split_bot_mark_}{\.{\\splitbotmark} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case topBotMark:
	switch chrCode {
	case firstMarkCode: printEsc("firstmark")
	case botMarkCode: printEsc("botmark")
	case splitFirstMarkCode: printEsc("splitfirstmark")
	case splitBotMarkCode: printEsc("splitbotmark")
	default: printEsc("topmark")
	}

@ 다음 코드는 |curCmd=topBotMark|이고 |curChr|가 |topMarkCode| 같은 코드일 때 실행한다. 해당하는 표시가 있으면 그 토큰
목록을 입력으로 읽기 시작한다. 없으면 아무것도 끼워 넣지 않으므로, 빈 표시는 아무 흔적도 남기지 않는다.

@<알맞은 표시 텍스트를...@>=
if curMark[curChr] != null {
	beginTokenList(curMark[curChr], markText)
}

@ 이제 |macroCall| 자체를 살펴보자. 이 프로시저는 \TeX이 |curCmd|가 |call|, |longCall|, |outerCall|, |longOuterCall|
가운데 하나인 제어 시퀀스를 훑었을 때 부른다. 그 제어 시퀀스의 정의는 |mem|의 위치 |curChr|에 참조 횟수가 있는 토큰
목록에 들어 있다.

전역 변수 |longState|는 그 제어 시퀀스가 매개변수 안에 \.{\\par}를 허락하지 않는지 허락하는지에 따라 |call|이나
|longCall|로 놓는다. 루틴 |getNext|는 인자를 읽는 도중에 파일이 끝나거나 \.{\\outer} 제어 시퀀스가 나오면
|longState|를 |outerCall|로 놓고 \.{\\par}를 내보낸다.

@<전역 변수@>=
var @!longState int32 // \.{\\par}를 받아들일지 다스린다; |call..longOuterCall|

@ 매개변수가 있으면 매크로를 펼치기 전에 그것들부터 훑어야 한다. 매개변수는 참조 횟수가 없는 토큰 목록이다. 훑는
동안에는 |pstack|이라는 보조 스택에 둔다. 맞추는 동안 |paramStack|이 항목을 잃을 수도 있기 때문이다. 인자를 읽다가
앞서 펼친 매크로의 본문이 끝나면 그 매개변수들이 |paramStack|에서 치워진다. (스택 |paramStack|에 항목이 늘어날 수는
없다는 데 눈여겨보자. 이 스택에 무언가를 넣는 루틴은 |macroCall|뿐이고, |macroCall|은 재귀적이지 않기 때문이다.)
매개변수는 많아야 아홉 개다.

@<전역 변수@>=
var @!pstack [9]pointer // 매크로에 주어진 인자들

@ 매개변수를 다 훑으면 그것들을 |paramStack|으로 옮기고, 매크로 본문을 훑개에 먹인다. 다시 말해 |macroCall|은 제어
시퀀스에 정의된 텍스트를 \TeX의 입력 스택 맨 위에 올려서 |getNext|가 다음에 그것을 읽게 한다.

전역 변수 |curCs|에는 |macroCall|이 시작할 때 펼치고 있는 제어 시퀀스의 |eqtb| 주소가 들어 있다. 이 제어 시퀀스가
\.{\\long}으로 선언되지 않았다면, 곧 |eqType| 필드의 명령 코드가 |longCall|이나 |longOuterCall|이 아니라면, 그
매개변수에는 제어 시퀀스 \.{\\par}가 들어 있으면 안 된다. 허락되지 않은 \.{\\par}가 나타나면 매크로 호출을 그만두고
\.{\\par}를 다시 훑는다.

이 프로시저에서는 레이블 |exit| 뒤에 저장해 둔 값을 되살리는 문장이 있으므로, 끝낼 때 |return| 대신 |goto exit|를
쓴다(\secref{labels}).

@<|macroCall|이라는...@>=
func macroCall() { // 사용자가 정의한 제어 시퀀스를 부른다
	var r pointer // 매크로의 토큰 목록에서 현재 노드
	var p pointer // 만들고 있는 매개변수 토큰 목록의 현재 노드
	var q pointer // 토큰 목록에 넣을 새 노드
	var s pointer // 매개변수 맞추기를 위한 되돌림 포인터
	var t pointer // 되돌림 복구를 위한 순환 포인터
	var u, v pointer // 되돌림 복구를 위한 보조 포인터
	var rbracePtr pointer // 마지막 |rightBrace| 토큰의 한 걸음 앞
	var n smallNumber // 훑은 매개변수의 수
	var unbalance halfword // 현재 매개변수에서 짝이 맞지 않는 왼쪽 중괄호
	var m halfword // 토큰이나 그룹의 수(대개)
	var refCount pointer // 토큰 목록의 시작
	var saveScannerStatus smallNumber // 들어올 때의 |scannerStatus|
	var saveWarningIndex pointer // 들어올 때의 |warningIndex|
	var matchChr asciiCode // 매개변수에 쓰인 문자
	saveScannerStatus = scannerStatus
	saveWarningIndex = warningIndex
	warningIndex = curCs
	refCount = curChr
	r = link(refCount)
	n = 0
	if tracingMacros() > 0 {
		@<펼치는 매크로의 텍스트를 보인다@>
	}
	if info(r) != endMatchToken {
		@<매개변수들을 훑고 |link(r)|이 매크로 몸체를 가리키게 한다@>
	}
	@<매크로 몸체와 그 매개변수들을 훑개에 먹인다@>
exit:
	scannerStatus = saveScannerStatus
	warningIndex = saveWarningIndex
}

@ 입력 스택에 새 토큰 목록을 올리기 전에, 방금 다 읽은 토큰 목록들을 모두 치우는 것이 현명하다. 그러면 마지막에 자기
자신을 부르는 사용자 매크로, 이를테면 `\.{\\def\\loop\{...\\loop\}}' 같은 꼬리 재귀가 스택 공간을 끝없이
요구하지 않는다. 그다음 본문을 읽기 시작하고, |pstack|에 모은 인자들을 |paramStack|으로 옮긴다.

@<매크로 몸체와 그...@>=
for state == tokenList && loc == null && tokenType() != vTemplate {
	endTokenList() // 스택 공간을 아낀다
}
beginTokenList(refCount, macro)
name = warningIndex
loc = link(r)
if n > 0 {
	if paramPtr+n > maxParamStack {
		maxParamStack = paramPtr + n
		if maxParamStack > paramSize {
			overflow("parameter stack size", paramSize)
		}
@:TeX capacity exceeded parameter stack size}{\quad parameter stack size@>
	}
	for m = 0; m <= n-1; m++ {
		paramStack[paramPtr+m] = pstack[m]
	}
	paramPtr += n
}

@ 여기서 앞에서 보인 토큰 목록 형식의 설명을 다시 훑어보는 것이 좋겠다. 그 형식의 많은 부분은 주로 |macroCall|
루틴에서 중요하기 때문이다.

토큰 목록은 첫 |match|나 |endMatch| 앞에 반드시 와야 할 토큰들로 시작할 수도 있다. 그러면 매크로 이름 뒤에는
그 토큰들이 그대로 와야 한다. 다음 프로그램은 이 제약을 나타내려고 |s=null|로 놓는다. 그렇지 않으면 포인터 |s|는
다음 매개변수의 끝을 가리는 구분 문자열의 첫 토큰을 가리킨다.

다음 코드는 매개변수들을 훑고 |link(r)|이 매크로 본문을 가리키게 한다. 그러나 허락되지 않은 \.{\\par}를 찾으면
그만두고 돌아간다.

@<매개변수들을 훑고...@>=
scannerStatus = matching
unbalance = 0
longState = eqType(curCs)
if longState >= outerCall {
	longState -= 2
}
for {
	setLink(tempHead, null)
	if info(r) > matchToken+255 || info(r) < matchToken {
		s = null
	} else {
		matchChr = info(r) - matchToken
		s = link(r)
		r = s
		p = tempHead
		m = 0
	}
	@<구분 문자열을 찾을 때까지 매개변수 하나를 훑는다@>
	// 이제 |info(r)|은 명령 코드가 |match|나 |endMatch|인 토큰이다
	if info(r) == endMatchToken {
		break
	}
}

@ 토큰 |info(r)|이 |match|나 |endMatch| 명령이면, 그것은 |getToken|이 읽은 어떤 토큰과도 같을 수 없다. 그러므로
구분자 없는 매개변수, 곧 |match| 바로 뒤에 |match|나 |endMatch|가 오는 것은 다음 알고리즘에서 언제나 `|curTok=info(r)|'
검사에 실패한다.

다음 코드는 구분 문자열을 찾을 때까지 매개변수 하나를 훑는다. 포인터 |s|가 |null|이면 구분 문자열만 훑는다.

@<구분 문자열을 찾을 때까지...@>=
again:
getToken() // |curTok|을 입력의 다음 토큰으로 놓는다
if curTok == info(r) {
	@<|r|을 나아가게 하고, 구분자가 다 맞았으면 |goto found|, 아니면 |goto again|@>
}
@<최근에 맞춘 토큰들을 현재 매개변수에 보태고, 부분적으로 맞은 상태면 |goto again|@>
if curTok == parToken {
	if longState != longCall {
		@<폭주한 인자를 알리고 그만둔다@>
	}
}
if curTok < rightBraceLimit {
	if curTok < leftBraceLimit {
		@<그룹 전체를 현재 매개변수에 보탠다@>
	} else {
		@<남는 오른쪽 중괄호를 알리고 |goto again|@>
	}
} else {
	@<현재 토큰을 저장하되, 구분되지 않는 매개변수가 될 공백이면 |goto again|@>
}
m++
if info(r) > endMatchToken {
	goto again
}
if info(r) < matchToken {
	goto again
}
found:
if s != null {
	@<방금 훑은 매개변수를 정리해서 넣어 둔다@>
}

@ 구분자 없는 매개변수 앞의 공백은 건너뛴다. 그래서 `\.{\\def\\a\#1\#2\{...\}}'로 정의한 \.{\\a}에
`\.{\\a\{x\} y}'를 주면 \.{\#2}는 공백이 아니라 \.y가 된다. 그 밖의 토큰은
현재 매개변수에 넣는다.
@<현재 토큰을 저장하되...@>=
if curTok == spaceToken {
	if info(r) <= endMatchToken {
		if info(r) >= matchToken {
			goto again
		}
	}
}
storeNewToken(&p, &q, curTok)

@ 여기서 조금 미묘한 점이 생긴다. 매개변수 구분자가 `\.{\#\{}'로 끝나면 토큰 목록에서 |endMatch|\kern-.4pt의 앞뒤에
모두 왼쪽 중괄호가 있다. 그 가운데 하나만 |alignState|에 영향을 주어야 하는데 둘 다 훑게 되므로, 여기서 하나를
빼서 바로잡는다.

@<|r|을 나아가게 하고...@>=
r = link(r)
if info(r) >= matchToken && info(r) <= endMatchToken {
	if curTok < leftBraceLimit {
		alignState--
	}
	goto found
}
goto again

@ 인자를 읽다가 짝이 없는 오른쪽 중괄호를 만났다. 그 중괄호를 되돌리고, 폭주한 인자로 다루도록 \.{\\par}를 끼워
넣는다.
@<남는 오른쪽 중괄호를...@>=
backInput()
printErr("Argument of ")
sprintCs(warningIndex)
@.Argument of \\x has...@>
printStr(" has an extra }")
help6("I've run across a `}' that doesn't seem to match anything.",
	"For example, `\\def\\a#1{...}' and `\\a}' would produce",
	"this error. If you simply proceed now, the `\\par' that",
	"I've just inserted will cause me to report a runaway",
	"argument that might be the root of the problem. But if",
	"your `}' was spurious, just type `2' and it will go away.")
alignState++
longState = call
curTok = parToken
insError()
goto again // 선의의 거짓말; \.{\\par}가 언제나 폭주를 일으키지는 않는다

@ 허락되지 않은 \.{\\par}를 만났다. 상태가 |longState=outerCall|이면 폭주한 인자는 이미 알렸으므로 다시 알리지 않는다.
지금까지 모은 인자들을 모두 버리고 매크로 호출을 그만둔다.

@<폭주한 인자를 알리고...@>=
if longState == call {
	runaway()
	printErr("Paragraph ended before ")
@.Paragraph ended before...@>
	sprintCs(warningIndex)
	printStr(" was complete")
	help3("I suspect you've forgotten a `}', causing me to apply this",
		"control sequence to too much text. How can we recover?",
		"My plan is to forget the whole thing and hope for the best.")
	backError()
}
pstack[n] = link(tempHead)
alignState -= unbalance
for m = 0; m <= n; m++ {
	flushList(pstack[m])
}
goto exit

@ 다음 코드에 이르렀다면 |s|부터 |r|의 앞 노드까지의 토큰들은 맞추었고 |curTok!=info(r)|인 것이다. 이제 흥미로운
상황이 생긴다. 매개변수를 `\.{ab}' 같은 문자열로 끝내야 하는데 `\.{aa}'를 훑었다면, `\.a' 하나를 현재 매개변수에
보태고 `\.b'를 다시 찾아야 한다. 프로그램은 이런 부분적 맞춤과, 아주 복잡할 수도 있는 다른 경우들을 따져야 한다.
그러나 대개는 |s=r|이어서 아무것도 할 필요가 없다.

보기를 들자. 매크로가 `\.{\\def\\a\#1ab\char'173...\char'175}'로 정의되었고 입력이 `\.{\\a xaab}'라면, 구분 문자열은
`\.{ab}'이고 |s|는 그 첫 토큰 `\.a'를 가리킨다. 토큰을 하나씩 읽을 때마다 일은 다음과 같이 진행된다.
$$\vbox{\halign{\hfil#\hfil\quad&\hfil#\hfil\quad&\hfil#\hfil\quad&#\hfil\cr
읽은 토큰&|r|이 가리키는 것&\.{\#1}에 모인 것&\cr
\noalign{\smallskip\hrule\smallskip}
\.x&\.a&\.x&맞지 않으므로 매개변수에 넣는다\cr
\.a&\.b&\.x&구분 문자열의 첫 토큰과 맞았다\cr
\.a&\.b&\.{xa}&어긋났다. 앞서 맞춘 \.a를 매개변수로 넘기고\cr
&&&지금의 \.a로 처음부터 다시 맞춘다\cr
\.b&|endMatch|&\.{xa}&구분 문자열을 다 맞추었다\cr}}$$
그래서 \.{\#1}은 `\.{xa}'가 된다. 셋째 줄에서 일어나는 일이 이 절의 일이다. 앞서 맞춘 토큰들, 곧 |s|부터 |r| 바로
앞까지의 토큰들을 하나씩 매개변수로 넘길 때마다, 남은 꼬리에 현재 토큰을 붙인 것이 구분 문자열의 앞부분과 맞는지
다시 본다. 맞으면 |r|을 거기에 맞추고 계속하며, 끝내 맞지 않으면 |r=s|로 돌아가서 현재 토큰을 보통의 토큰처럼
다룬다. 구분 문자열이 길고 이상하게 생겼으면 같은 토큰을 여러 번 비교할 수도 있지만, 구분 문자열은 대개 아주
짧으므로 문제가 되지 않는다.

덧붙이자면, \.{\\long}이 아닌 매크로의 매개변수에도 \.{\\par} 토큰이 몰래 끼어들 수 있다. 이를테면
`\.{\\def\\a\#1\\par!\{...\}}'에서 첫 \.{\\par} 뒤에 느낌표가 오지 않는 경우를 생각해 보라. 그런 상황에서
\.{\\par}를 금지하는 것은 알맞아 보이지 않으므로, \TeX은 이 규칙 위반을 눈감아 준다.

다음 코드는 최근에 맞춘 토큰들을 현재 매개변수에 보태고, 부분적으로 맞은 상태가 아직 살아 있으면 |goto again|한다.
그러나 |s=null|이면 그만둔다.

@<최근에 맞춘 토큰들을...@>=
if s != r {
	if s == null {
		@<매크로를 잘못 썼다고 알리고 그만둔다@>
	} else {
		t = s
		for {
			storeNewToken(&p, &q, info(t))
			m++
			u = link(t)
			v = s
			for {
				if u == r {
					if curTok != info(v) {
						goto done
					}
					r = link(v)
					goto again
				}
				if info(u) != info(v) {
					goto done
				}
				u = link(u)
				v = link(v)
			}
		done:
			t = link(t)
			if t == r {
				break
			}
		}
		r = s // 이 시점에서 최근에 맞춘 토큰은 없다
	}
}

@ 매크로 이름 바로 뒤에 와야 할 토큰들이 오지 않았다. 이를테면 `\.{\\def\\a1\{...\}}'로 정의한 \.{\\a} 뒤에 \.1이
오지 않은 경우다. 이 매크로 호출을 무시한다.
@<매크로를 잘못 썼다고...@>=
printErr("Use of ")
sprintCs(warningIndex)
@.Use of x doesn't match...@>
printStr(" doesn't match its definition")
help4("If you say, e.g., `\\def\\a1{...}', then you must always",
	"put `1' after `\\a', since control sequence names are",
	"made up of letters only. The macro here has not been",
	"followed by the required stuff, so I'm ignoring it.")
reportError()
goto exit

@ 왼쪽 중괄호로 시작하는 그룹을 통째로 현재 매개변수에 넣는다. 짝이 맞는 오른쪽 중괄호가 나올 때까지 |unbalance|로
중괄호의 깊이를 센다. 그 사이에도 허락되지 않은 \.{\\par}를 검사한다.
@<그룹 전체를 현재...@>=
unbalance = 1
@^inner loop@>
for {
	fastStoreNewToken(&p, &q, curTok)
	getToken()
	if curTok == parToken {
		if longState != longCall {
			@<폭주한 인자를 알리고...@>
		}
	}
	if curTok < rightBraceLimit {
		if curTok < leftBraceLimit {
			unbalance++
		} else {
			unbalance--
			if unbalance == 0 {
				goto done1
			}
		}
	}
}
done1:
rbracePtr = p
storeNewToken(&p, &q, curTok)

@ 매개변수 하나를 다 훑었다. 매개변수가 중괄호로 둘러싼 그룹 하나로만 이루어져 있으면 바깥 중괄호를 떼어 내야 한다.
변수 |rbracePtr|를 둔 것은 이 때문이다. 그래서 `\.{\\a\{xy\}}'의 인자는 \.{xy}가 된다. 그러나 `\.{\\def\\a\#1.\{...\}}'로 정의한 \.{\\a}에
`\.{\\a\{x\}\{y\}.}'를 주면 그룹이 둘이므로 \.{\#1}은 중괄호까지 그대로 `\.{\{x\}\{y\}}'가 된다. 매개변수 \.{\\tracingmacros}가 양수이면
`\.{\#1<-xy}'처럼 매개변수의 값을 보여 준다.

@<방금 훑은 매개변수를...@>=
if m == 1 && info(p) < rightBraceLimit {
	setLink(rbracePtr, null)
	freeAvail(p)
	p = link(tempHead)
	pstack[n] = link(p)
	freeAvail(p)
} else {
	pstack[n] = link(tempHead)
}
n++
if tracingMacros() > 0 {
	beginDiagnostic()
	printNl(matchChr)
	printInt(n)
	printStr("<-")
	showTokenList(pstack[n-1], null, 1000)
	endDiagnostic(false)
}

@ 매개변수 \.{\\tracingmacros}가 양수이면 펼치는 매크로의 이름과 정의를 `\.{\\a \#1->\#1\#1}'처럼 보여 준다.
@<펼치는 매크로의...@>=
beginDiagnostic()
printLn()
printCs(warningIndex)
tokenShow(refCount)
endDiagnostic(false)

@* 기본 훑기 서브루틴.
이제 \TeX이 입력에서 어떤 꼴의 패턴을 소화하려고 자주 부르는 프로시저들로 넘어가자. 수, 치수, 글루, 키워드,
중괄호 같은 것을 읽는 루틴들이다. 대부분은 아주 간단하지만 몇몇은 꽤 정교하다. 거의 모든 루틴이 |getXToken|을
부르는데, 그 때문에 이 루틴들은 재귀적으로 불릴 수 있다. 수를 읽다가 매크로를 펼쳤는데 그 매크로 안에서 또 수를
읽어야 할 수도 있기 때문이다.
@^stomach@>
@^recursion@>

@ 루틴 |scanLeftBrace|는 공백이 아닌 다음 토큰이 왼쪽 중괄호여야 할 때 부른다. (``왼쪽 중괄호''란 정확히는 catcode가
|leftBrace|인 문자를 말한다.) \TeX은 |leftBrace| 앞에 \.{\\relax}가 있어도 괜찮다고 본다. 왼쪽 중괄호가 없으면
오류를 알리고 하나 있는 것처럼 하고 넘어간다.

@<함수들@>=
func scanLeftBrace() { // 반드시 와야 할 |leftBrace|를 읽는다
	@<공백도 relax도 호출도 아닌 다음 토큰을 얻는다@>
	if curCmd != leftBrace {
		printErr("Missing { inserted")
@.Missing \{ inserted@>
		help4("A left brace was mandatory here, so I've put one in.",
			"You might want to delete and/or insert some corrections",
			"so that I will find a matching right brace soon.",
			"(If you're confused by all this, try typing `I}' now.)")
		backError()
		curTok = leftBraceToken + '{'
		curCmd = leftBrace
		curChr = '{'
		alignState++
	}
}

@ 공백과 \.{\\relax}를 건너뛰며 펼친 토큰을 읽는다.
@<공백도 relax도 호출도...@>=
for {
	getXToken()
	if curCmd != spacer && curCmd != relax {
		break
	}
}

@ 루틴 |scanOptionalEquals|는 공백 몇 개에 이어 나올 수도 있는 `\.=' 기호를 찾는다. 이를테면 \.{\\count1=5}와 \.{\\count1 5}를
똑같이 받아들이려는 것이다. 여기서는 `\.{\\relax}'를 무시하지 않는다. `\.='가 아닌 토큰을 읽었으면 되돌려 놓는다.

@<함수들@>=
func scanOptionalEquals() {
	@<공백도 호출도 아닌 다음 토큰을 얻는다@>
	if curTok != otherToken+'=' {
		backInput()
	}
}

@ 공백을 건너뛰며 펼친 토큰을 읽는다.
@<공백도 호출도 아닌...@>=
for {
	getXToken()
	if curCmd != spacer {
		break
	}
}

@ 지루해지기 시작했다면, 여기 조금 덜 하찮은 루틴이 있다. 루틴 |scanKeyword|는 `\.{pt}'나 `\.{plus}'나 `\.{width}'
같은 소문자 문자열을 받아서, 입력의 다음 토큰들이 이 문자열과 맞는지 검사한다. 정확히 맞아야 하지만, 대문자는
그에 해당하는 소문자와 맞는 것으로 친다. 그래서 `\.{PT}'나 `\.{Plus}'도 된다. 대문자 짝은 |ucCode| 표를 보지 않고
|"a"-"A"|를 빼서 얻는다. \TeX은 이 루틴을 자기 자신의 정해진 키워드에만 쓰기 때문이다.

맞으면 그 문자들은 사실상 입력에서 지워지고 |true|를 돌려준다. 맞지 않으면 |false|를 돌려주고, 입력은 본질적으로
그대로 남는다(도중에 어떤 매크로가 펼쳐졌을 수 있다는 것 따위를 빼면). 이렇게 하려고 읽은 토큰들을 |backupHead|
뒤의 목록에 모아 두었다가, 맞지 않으면 통째로 되돌려 놓는다. 이를테면 `\.{\\hskip 3pt pluto}'에서는 `\.{plu}'까지
맞다가 `\.t'에서 어긋나므로 네 글자가 모두 입력으로 돌아간다.
@^inner loop@>

키워드는 언제나 문자열 상수이므로 |s|는 \GO/ 문자열이고, |k|는 그 문자열의 첨자다.

@<함수들@>=
func scanKeyword(s string) bool { // 주어진 문자열을 찾는다
	var p pointer // 되돌림 목록의 꼬리
	var q pointer // |storeNewToken|으로 토큰 목록에 보탤 새 노드
	var k int // |s|의 첨자
	p = backupHead
	setLink(p, null)
	k = 0
	for k < len(s) {
		getXToken() // 여기서 재귀가 일어날 수 있다
@^recursion@>
		if curCs == 0 &&
			(curChr == asciiCode(s[k]) || curChr == asciiCode(s[k])-'a'+'A') {
			storeNewToken(&p, &q, curTok)
			k++
		} else if curCmd != spacer || p != backupHead {
			backInput()
			if p != backupHead {
				backList(link(backupHead))
			}
			return false
		}
	}
	flushList(link(backupHead))
	return true
}

@ 다음은 mu 단위와 mu가 아닌 단위가 섞였을 때 경보를 울리는 프로시저다. 이를테면 \.{\\mskip}에 pt로 된 글루를 주면 이
오류가 난다. \TeX은 1mu를 1pt로 보고 넘어간다.

@<함수들@>=
func muError() {
	printErr("Incompatible glue units")
@.Incompatible glue units@>
	help1("I'm going to assume that 1mu=1pt when they're mixed.")
	reportError()
}

@ 다음 루틴 `|scanSomethingInternal|'은 `\.{\\hsize}' 같은 내부 양의 값을 가져오는 데 쓰고, `\.{\\the\\toks0}'나
`\.{\\the\\baselineskip}' 같은 것을 펼칠 때 `\.{\\the}'를 처리하는 데에도 쓴다. 곧 |scanInt| 프로시저를 살펴볼 텐데,
|scanInt|는 |scanSomethingInternal|을 부른다. 거꾸로 |scanSomethingInternal|도 `\.{\\catcode\char'140\\\$}'나
`\.{\\fontdimen} \.3 \.{\\ff}' 같은 것을 읽으려고 |scanInt|를 부른다. 두 프로시저가 서로를 부르지만, \GO/에서는 함수를
쓰기 전에 선언할 필요가 없으므로 문제가 되지 않는다. 다른 프로시저 몇 개는 여기서 선언해 둔다.

@<함수들@>=
@<제한된 종류의 정수를 훑는 프로시저들을 선언한다@>
@<글꼴에 관련된 것을 훑는 프로시저들을 선언한다@>

@ \TeX은 |scanSomethingInternal|을 시작할 때 무엇이 올지 정확히 모른다. 이를테면 `\.{\\hskip}' 바로 뒤에는 정수나
치수나 글루 값이 올 수 있다. 또 `\.{\\xdef\\o\{\\the\\output\}}' 같은 곳에서는 토큰 목록에 대해서도 \.{\\the}를 쓸 수
있다. 한편 `\.{\\count}' 같은 것 뒤에는 정수만 올 수 있다. 이렇게 여러 가능성을 다루려고 |scanSomethingInternal|에는
매개변수 |level|이 있다. 이 값은 |scanSomethingInternal|이 내놓을 수 있는 가장 ``높은'' 종류의 양을 알려 준다.
수준은 |intVal|, |dimenVal|, |glueVal|, |muVal|, |identVal|, |tokVal|의 여섯 가지다. 수준이 높을수록 더 많은 정보를
담고 있어서, 높은 수준의 값은 낮은 수준으로 바꿀 수 있다. 이를테면 글루는 그 너비만 떼어 치수로, 치수는 sp 단위의
정수로 바꿀 수 있다.

프로시저 |scanSomethingInternal|의 결과는 (그리고 아래의 다른 루틴 |scanInt|, |scanDimen|, |scanGlue|의 결과도) 전역
변수 |curVal|에 들어가고, 그 수준은 |curValLevel|에 들어간다. 변수 |curValLevel|의 가장 높은 값들은 특별하다. 수준
|muVal|은 |curVal|이 ``muskip'' 레지스터의 값이나 세 매개변수 \.{\\thinmuskip}, \.{\\medmuskip}, \.{\\thickmuskip}
가운데 하나를 가리킬 때에만 쓴다. 수준 |identVal|은 |curVal|이 글꼴 식별자를 가리킬 때에만 쓴다. 수준 |tokVal|은
|curVal|이 |null|이나 토큰 목록의 참조 횟수를 가리킬 때에만 쓴다. 마지막 두 경우는 |scanSomethingInternal|을
|level=tokVal|로 불렀을 때에만, 곧 \.{\\the}를 처리할 때에만 허락된다.

결과가 글루라면 |curVal|은 글루 명세를 가리키고, 그 글루의 참조 횟수는 이 참조까지 셈에 넣어 고쳐져 있다. 결과가
비어 있지 않은 토큰 목록이면 |curVal|은 그 참조 횟수를 가리키지만, 이때는 횟수를 고치지 않는다. 그 밖에는
|curVal|에 정수 값이나 눈금 값이 들어 있다.

@<전역 변수@>=
const (
	@!intVal = iota // 정수 값
	@!dimenVal // 치수 값
	@!glueVal // 글루 명세
	@!muVal // 수식 글루 명세
	@!identVal // 글꼴 식별자
	@!tokVal // 토큰 목록
)

var @!curVal int32 // 수 훑기 루틴이 돌려주는 값
var @!curValLevel int32 // 이 값의 ``수준''; |intVal..tokVal|

@ 해시 표에서 `\.{\\count}', `\.{\\dimen}', `\.{\\skip}', `\.{\\muskip}'은 모두 명령 코드가 |register|다. 이것들은
|chrCode|로 가리는데, |chrCode|는 |intVal|, |dimenVal|, |glueVal|, |muVal| 가운데 하나다. 그래서 수정자가 곧
레지스터 값의 수준이 된다.

@<\TeX의 원시 명령을...@>=
primitive("count", register, intVal)
@!@:count_}{\.{\\count} primitive@>
primitive("dimen", register, dimenVal)
@!@:dimen_}{\.{\\dimen} primitive@>
primitive("skip", register, glueVal)
@!@:skip_}{\.{\\skip} primitive@>
primitive("muskip", register, muVal)
@!@:mu_skip_}{\.{\\muskip} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case register:
	if chrCode == intVal {
		printEsc("count")
	} else if chrCode == dimenVal {
		printEsc("dimen")
	} else if chrCode == glueVal {
		printEsc("skip")
	} else {
		printEsc("muskip")
	}

@ 이제 |scanSomethingInternal| 자체를 볼 차례다. 둘째 매개변수 |negative|는 찾은 값의 부호를 바꾸어야 하면
|true|다. 변수 |curCmd|와 |curChr|는 훑을 내부 양의 첫 토큰을 나타낸다고 가정한다. 명령 코드가
|curCmd<minInternal|이거나 |curCmd>maxInternal|이면 오류를 알린다. 명령 코드마다 값을 가져오는 방법이 다르므로
|switch|로 가른다. 값을 가져온 뒤에는, 요청한 |level|보다 높은 수준이면 낮추고, 부호를 바꾸고, 글루라면 참조
횟수를 고친다.

결과를 정할 때는 작은 함수 |scannedResult(v,l)|을 부르는데, 이 함수는 |curVal=v|, |curValLevel=l|로 놓는다.

@<함수들@>=
func scanSomethingInternal(level smallNumber, negative bool) { // 내부 매개변수를 가져온다
	var p int32 // |nest|의 첨자; |0 .. nestSize|
	m := curChr // 피연산자 토큰의 |chrCode| 부분
	switch curCmd {
	case defCode: @<어떤 표에서 문자 코드를 가져온다@>
	case toksRegister, assignToks, defFamily, setFont, defFont:
		@<|level=tokVal|이면 토큰 목록이나 글꼴 식별자를 가져온다@>
	case assignInt: scannedResult(eqtb[m].sc, intVal)
	case assignDimen: scannedResult(eqtb[m].sc, dimenVal)
	case assignGlue: scannedResult(equiv(m), glueVal)
	case assignMuGlue: scannedResult(equiv(m), muVal)
	case setAux: @<|spaceFactor|나 |prevDepth|를 가져온다@>
	case setPrevGraf:
		@<|prevGraf|를 가져온다@>
	case setPageInt: @<|deadCycles|나 |insertPenalties|를 가져온다@>
	case setPageDimen:
		@<|pageSoFar|의 무언가를 가져온다@>
	case setShape: @<|parShape|의 크기를 가져온다@>
	case setBoxDimen:
		@<상자의 치수를 가져온다@>
	case charGiven, mathGiven: scannedResult(curChr, intVal)
	case assignFontDimen: @<글꼴 치수를 가져온다@>
	case assignFontInt:
		@<글꼴 정수를 가져온다@>
	case register: @<레지스터를 가져온다@>
	case lastItem:
		@<알맞으면 현재 노드의 항목을 가져온다@>
	default:
		@<\.{\\the}가 이것을 할 수 없다고 불평하고 0을 결과로 준다@>
	}
	for curValLevel > level {
		@<|curVal|을 낮은 수준으로 바꾼다@>
	}
	@<참조 횟수가 있으면 고치고, |negative|면 |curVal|의 부호를 바꾼다@>
}

@ @<정의@>=
func scannedResult(v int32, l int32) {
	curVal = v
	curValLevel = l
}

@ 명령 \.{\\catcode}나 \.{\\mathcode} 같은 문자 코드 표에서 값을 가져온다. 문자 번호를 읽고, 표에 따라 하프워드 항목이나
온 낱말 항목을 읽는다.
@<어떤 표에서 문자...@>=
scanCharNum()
if m == mathCodeBase {
	scannedResult(ho(mathCode(curVal)), intVal)
} else if m < mathCodeBase {
	scannedResult(equiv(m+curVal), intVal)
} else {
	scannedResult(eqtb[m+curVal].sc, intVal)
}

@ 토큰 목록이나 글꼴 식별자는 \.{\\the}일 때만 값이 될 수 있다. 수가 와야 할 곳에 이런 것이 오면 `\.{Missing number}'
오류를 알리고 0을 쓴다.
@<|level=tokVal|이면...@>=
if level != tokVal {
	printErr("Missing number, treated as zero")
@.Missing number...@>
	help3("A number should have been here; I inserted `0'.",
		"(If you can't figure out why I needed to see a number,",
		"look up `weird error' in the index to The TeXbook.)")
@^TeXbook@>
	backError()
	scannedResult(0, dimenVal)
} else if curCmd <= assignToks {
	if curCmd < assignToks { // |curCmd=toksRegister|
		scanEightBitInt()
		m = toksBase + curVal
	}
	scannedResult(equiv(m), tokVal)
} else {
	backInput()
	scanFontIdent()
	scannedResult(fontIDBase+curVal, identVal)
}

@ 사용자는 `\.{\\the\\spacefactor}'를 가로 모드에서만, `\.{\\the\\prevdepth}'를 세로 모드에서만 쓸 수 있다. 그래서 명령
|setAux|의 수식어에는 해당하는 모드를 넣어 둔다. 명령 |setPageInt|의 수식어는 0이나 1인데, 저마다 `\.{\\deadcycles}'와
`\.{\\insertpenalties}'를 뜻한다. 명령 |setBoxDimen|의 수식어는 |widthOffset|, |heightOffset|, |depthOffset| 가운데
하나다. 그래서 상자 노드에 이 수를 더하기만 하면 해당하는 치수를 얻는다. 그리고 명령 |lastItem|의 수식어는 |intVal|,
|dimenVal|, |glueVal|, |inputLineNoCode|, |badnessCode| 가운데 하나다.

@<\TeX의 원시 명령을...@>=
primitive("spacefactor", setAux, hmode)
@!@:space_factor_}{\.{\\spacefactor} primitive@>
primitive("prevdepth", setAux, vmode)
@!@:prev_depth_}{\.{\\prevdepth} primitive@>
primitive("deadcycles", setPageInt, 0)
@!@:dead_cycles_}{\.{\\deadcycles} primitive@>
primitive("insertpenalties", setPageInt, 1)
@!@:insert_penalties_}{\.{\\insertpenalties} primitive@>
primitive("wd", setBoxDimen, widthOffset)
@!@:wd_}{\.{\\wd} primitive@>
primitive("ht", setBoxDimen, heightOffset)
@!@:ht_}{\.{\\ht} primitive@>
primitive("dp", setBoxDimen, depthOffset)
@!@:dp_}{\.{\\dp} primitive@>
primitive("lastpenalty", lastItem, intVal)
@!@:last_penalty_}{\.{\\lastpenalty} primitive@>
primitive("lastkern", lastItem, dimenVal)
@!@:last_kern_}{\.{\\lastkern} primitive@>
primitive("lastskip", lastItem, glueVal)
@!@:last_skip_}{\.{\\lastskip} primitive@>
primitive("inputlineno", lastItem, inputLineNoCode)
@!@:input_line_no_}{\.{\\inputlineno} primitive@>
primitive("badness", lastItem, badnessCode)
@!@:badness_}{\.{\\badness} primitive@>

@ @<정의@>=
const (
	@!inputLineNoCode = glueVal + 1 // \.{\\inputlineno}의 코드
	@!badnessCode = glueVal + 2 // \.{\\badness}의 코드
)

@ @<원시 명령의 이름을 찍는...@>=
case setAux:
	if chrCode == vmode {
		printEsc("prevdepth")
	} else {
		printEsc("spacefactor")
	}
case setPageInt:
	if chrCode == 0 {
		printEsc("deadcycles")
	} else {
		printEsc("insertpenalties")
	}
case setBoxDimen:
	if chrCode == widthOffset {
		printEsc("wd")
	} else if chrCode == heightOffset {
		printEsc("ht")
	} else {
		printEsc("dp")
	}
case lastItem:
	switch chrCode {
	case intVal: printEsc("lastpenalty")
	case dimenVal: printEsc("lastkern")
	case glueVal: printEsc("lastskip")
	case inputLineNoCode: printEsc("inputlineno")
	default: printEsc("badness")
	}

@ 모드가 맞지 않을 때 \.{\\spacefactor}나 \.{\\prevdepth}를 쓰면 오류를 알리고 0을 쓴다.
@<|spaceFactor|나 |prevDepth|를...@>=
if abs(mode) != m {
	printErr("Improper ")
	printCmdChr(setAux, m)
@.Improper \\spacefactor@>
@.Improper \\prevdepth@>
	help4("You can refer to \\spacefactor only in horizontal mode;",
		"you can refer to \\prevdepth only in vertical mode; and",
		"neither of these is meaningful inside \\write. So",
		"I'm forgetting what you said and using zero instead.")
	reportError()
	if level != tokVal {
		scannedResult(0, dimenVal)
	} else {
		scannedResult(0, intVal)
	}
} else if m == vmode {
	scannedResult(prevDepth(), dimenVal)
} else {
	scannedResult(spaceFactor(), intVal)
}

@ @<|deadCycles|나 |insertPenalties|를...@>=
if m == 0 {
	curVal = deadCycles
} else {
	curVal = insertPenalties
}
curValLevel = intVal

@ 명령 \.{\\wd}, \.{\\ht}, \.{\\dp}는 상자 레지스터의 치수를 준다. 레지스터가 비어 있으면 0이다.
@<상자의 치수를 가져온다@>=
scanEightBitInt()
if box(curVal) == null {
	curVal = 0
} else {
	curVal = mem[box(curVal)+m].sc
}
curValLevel = dimenVal

@ 쪽 합계 \.{\\pagegoal} 따위를 가져온다. 출력 루틴 \.{\\output} 안에서는 출력이 시작된 순간의 쪽 합계를 보고 싶을 수도
있으므로, 출력 중에는 쪽이 비어 있더라도 남아 있는 값을 준다. 쪽이 비어 있고 출력 중도 아니면 \.{\\pagegoal}은
|maxDimen|, 나머지는 0이다.

@<|pageSoFar|의 무언가를...@>=
if pageContents == empty && !outputActive {
	if m == 0 {
		curVal = maxDimen
	} else {
		curVal = 0
	}
} else {
	curVal = pageSoFar[m]
}
curValLevel = dimenVal

@ 사용자가 다룰 수 있는 가장 큰 치수 $2^{30}-1$\,sp, 곧 16383.99998pt다.
@<정의@>=
const @!maxDimen = 0o7777777777 // $2^{30}-1$

@ 명령 \.{\\prevgraf}의 값은 가장 가까운 바깥의 세로 모드 수준에 저장된 값이다. 그래서 의미 둥지를 거슬러 올라가며 찾는다.
@<|prevGraf|를...@>=
if mode == 0 {
	scannedResult(0, intVal) // \.{\\write} 안에서는 |prevGraf=0|
} else {
	nest[nestPtr] = curList()
	p = nestPtr
	for abs(nest[p].modeField) != vmode {
		p--
	}
	scannedResult(nest[p].pgField, intVal)
}

@ 명령 \.{\\parshape}의 값은 문단 모양의 줄 수다.
@<|parShape|의 크기를...@>=
if parShapePtr() == null {
	curVal = 0
} else {
	curVal = info(parShapePtr())
}
curValLevel = intVal

@ 다음은 \.{\\lastpenalty}, \.{\\lastkern}, \.{\\lastskip}을 구현하는 곳이다. 현재 목록의 마지막 노드가 벌점, 커닝, 글루이면
그 값을 주고, 아니면 0을 준다. 이때 \.{\\lastskip}의 참조 횟수는 나중에 고친다.

명령 \.{\\inputlineno}와 \.{\\badness}도 여기서 다룬다. 이것들도 비슷한 문맥에서 쓰기 때문이다.

@<알맞으면 현재 노드의...@>=
if curChr > glueVal {
	if curChr == inputLineNoCode {
		curVal = line
	} else {
		curVal = lastBadness // |curChr=badnessCode|
	}
	curValLevel = intVal
} else {
	if curChr == glueVal {
		curVal = zeroGlue
	} else {
		curVal = 0
	}
	curValLevel = curChr
	if !isCharNode(tail) && mode != 0 {
		switch curChr {
		case intVal: if typ(tail) == penaltyNode { curVal = penalty(tail) }
		case dimenVal: if typ(tail) == kernNode { curVal = width(tail) }
		case glueVal:
			if typ(tail) == glueNode {
				curVal = gluePtr(tail)
				if subtype(tail) == muGlue {
					curValLevel = muVal
				}
			}
		} // 다른 경우는 없다
	} else if mode == vmode && tail == head {
		switch curChr {
		case intVal: curVal = lastPenalty
		case dimenVal: curVal = lastKern
		case glueVal: if lastGlue != maxHalfword { curVal = lastGlue }
		} // 다른 경우는 없다
	}
}

@ 명령 \.{\\fontdimen}의 값을 가져온다. 글꼴 매개변수의 자리는 |findFontDimen|이 찾아 준다.
@<글꼴 치수를...@>=
findFontDimen(false)
fontInfo[fmemPtr].sc = 0
scannedResult(fontInfo[curVal].sc, dimenVal)

@ 명령 \.{\\hyphenchar}와 \.{\\skewchar}의 값을 가져온다.
@<글꼴 정수를...@>=
scanFontIdent()
if m == 0 {
	scannedResult(hyphenChar[curVal], intVal)
} else {
	scannedResult(skewChar[curVal], intVal)
}

@ 명령 \.{\\count}, \.{\\dimen}, \.{\\skip}, \.{\\muskip} 레지스터의 값을 가져온다. 수준은 레지스터의 종류 그대로다.
@<레지스터를...@>=
scanEightBitInt()
switch m {
case intVal: curVal = count(curVal)
case dimenVal: curVal = dimen(curVal)
case glueVal: curVal = skip(curVal)
case muVal: curVal = muSkip(curVal)
} // 다른 경우는 없다
curValLevel = m

@ 명령 \.{\\the} 뒤에 올 수 없는 것이 왔다. 이를테면 `\.{\\the\\hbox}'가 그렇다. 오류를 알리고 0을 쓴다.
@<\.{\\the}가 이것을...@>=
printErr("You can't use `")
printCmdChr(curCmd, curChr)
@.You can't use x after ...@>
printStr("' after ")
printEsc("the")
help1("I'm forgetting what you said and using zero instead.")
reportError()
if level != tokVal {
	scannedResult(0, dimenVal)
} else {
	scannedResult(0, intVal)
}

@ 수준을 한 단계 낮춘다. 수준이 |glueVal|에서 |dimenVal|로 바뀔 때는 글루의 너비 성분을 쓴다. 참조 횟수는 아직 늘리지
않았으므로 줄일 필요가 없다. 수준이 |dimenVal|에서 |intVal|로 바뀔 때는 눈금 포인트를 그대로 쓰므로 값이 실제로
바뀌지 않는다. 그래서 \.{\\count1=\\hsize}는 \.{\\hsize}를 sp 단위로 센 정수를 넣는다. 그리고 |muVal|에서 |glueVal|로
바뀔 때도 값은 바뀌지 않지만, mu 단위가 섞인 것이므로 경고한다.

@<|curVal|을 낮은 수준으로...@>=
if curValLevel == glueVal {
	curVal = width(curVal)
} else if curValLevel == muVal {
	muError()
}
curValLevel--

@ 이 시점에서 |curVal|이 글루 명세를 가리키면, 그 글루의 참조 횟수에는 아직 |curVal|로부터의 참조가 들어 있지 않다.
매개변수 |negative|가 |true|이면 |curValLevel|은 |<=muVal|임이 보장되어 있다. 글루의 부호를 바꿀 때는 명세를 새로
복제해서 바꾼다. 다른 곳이 함께 쓰는 명세를 고치면 안 되기 때문이다.

@<참조 횟수가 있으면 고치고...@>=
if negative {
	if curValLevel >= glueVal {
		curVal = newSpec(curVal)
		@<|curVal|의 글루 성분 셋의 부호를 모두 바꾼다@>
	} else {
		curVal = -curVal
	}
} else if curValLevel >= glueVal && curValLevel <= muVal {
	addGlueRef(curVal)
}

@ 글루의 너비, 늘어남, 줄어듦을 모두 음수로 바꾼다.
@<|curVal|의 글루 성분 셋의...@>=
setWidth(curVal, -width(curVal))
setStretch(curVal, -stretch(curVal))
setShrink(curVal, -shrink(curVal))

@ 다음 목표는 \TeX이 정수로 다루는 것은 무엇이든 훑는 프로시저 |scanInt|를 짜는 것이다. 그러나 그 전에 |scanSomethingInternal|
안에서 이미 쓴, |scanInt|의 간단한 응용 몇 가지를 먼저 살펴보자.

@ 레지스터 번호처럼 0부터 255까지여야 하는 정수를 읽는다. 범위를 벗어나면 오류를 알리고 0으로 바꾼다.
@<제한된 종류의 정수를...@>=
func scanEightBitInt() {
	scanInt()
	if curVal < 0 || curVal > 255 {
		printErr("Bad register code")
@.Bad register code@>
		help2("A register number must be between 0 and 255.",
			"I changed this one to zero.")
		intError(curVal)
		curVal = 0
	}
}

@ 문자 코드도 0부터 255까지여야 한다.
@<제한된 종류의 정수를...@>=
func scanCharNum() {
	scanInt()
	if curVal < 0 || curVal > 255 {
		printErr("Bad character code")
@.Bad character code@>
		help2("A character number must be between 0 and 255.",
			"I changed this one to zero.")
		intError(curVal)
		curVal = 0
	}
}

@ 하는 김에 나중에 필요할 비슷한 루틴들도 다루어 두자. 이것은 수식 가족 번호처럼 0부터 15까지여야 하는 정수를
읽는다.

@<제한된 종류의 정수를...@>=
func scanFourBitInt() {
	scanInt()
	if curVal < 0 || curVal > 15 {
		printErr("Bad number")
@.Bad number@>
		help2("Since I expected to read a number between 0 and 15,",
			"I changed this one to zero.")
		intError(curVal)
		curVal = 0
	}
}

@ 수식 문자 코드 \.{\\mathchar}는 15비트, 곧 0부터 32767까지다.
@<제한된 종류의 정수를...@>=
func scanFifteenBitInt() {
	scanInt()
	if curVal < 0 || curVal > 0o77777 {
		printErr("Bad mathchar")
@.Bad mathchar@>
		help2("A mathchar number must be between 0 and 32767.",
			"I changed this one to zero.")
		intError(curVal)
		curVal = 0
	}
}

@ 구분자 코드 \.{\\delimiter}는 27비트다.
@<제한된 종류의 정수를...@>=
func scanTwentySevenBitInt() {
	scanInt()
	if curVal < 0 || curVal > 0o777777777 {
		printErr("Bad delimiter code")
@.Bad delimiter code@>
		help2("A numeric delimiter code must be between 0 and 2^{27}-1.",
			"I changed this one to zero.")
		intError(curVal)
		curVal = 0
	}
}

@ 정수 앞에는 공백과 `\.+'나 `\.-' 부호가 몇 개든 올 수 있다. `\.-'가 홀수 개면 음수다. 그다음에는 십진 상수(곧
기수 10), 팔진 상수(곧 기수 8, 앞에~\.{\char'47}가 붙는다), 십육진 상수(기수 16, 앞에~\."가 붙는다), 알파벳 상수(앞에~\.{\char'140}가
붙는다), 또는 내부 변수가 온다. 이를테면 \.{\char'47777}, \.{"1FF}, \.{511}은 모두 같은 수이고, \.{\char'140A}는 65다. 훑기가
끝나면 |curVal|에 답이 들어 있는데, 그 절댓값은 많아야 $2^{31}-1=2147483647$이어야 한다. 변수 |radix|는 십진, 팔진,
십육진 상수이면 10, 8, 16으로, 그 밖에는 0으로 놓는다. 상수 뒤에는 공백이 하나 올 수 있고, 그 공백은 상수의
일부로 삼켜진다.

@<전역 변수@>=
const (
	@!octalToken = otherToken + '\'' // 작은따옴표, 팔진 상수를 나타낸다
	@!hexToken = otherToken + '"' // 큰따옴표, 십육진 상수를 나타낸다
	@!alphaToken = otherToken + '`' // 역따옴표, 알파벳 상수 앞에 온다
	@!pointToken = otherToken + '.' // 소수점
	@!continentalPointToken = otherToken + ',' // 소수점, 유럽식
)

var @!radix smallNumber // |scanInt|가 이것을 8, 10, 16, 0 가운데 하나로 놓는다

@ 기본 훑기 루틴 가운데 어느 것이 값을 넣기도 전에 |expand|가 저장해 둘 수도 있으므로, 다음 전역 변수들을 미리
초기화해 둔다.

@<핵심 변수들의...@>=
curVal = 0
curValLevel = intVal
radix = 0
curOrder = normal

@ 루틴 |scanInt|는 소수의 정수 부분을 훑는 데에도 쓴다. 이를테면 `\.{3.14159}'의 `\.3'은 |scanInt|가 찾는다. 루틴
|scanDimen|은 |scanInt|가 정수 부분을 훑고 나면 |curTok=pointToken|이고, 소수점은 다시 읽도록 되돌려져 있다고
가정한다.

@<함수들@>=
func scanInt() { // |curVal|을 정수로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	var m int32 // 위험의 문턱값, 곧 $2^{31}$을 |radix|로 나눈 몫
	var d smallNumber // 방금 훑은 숫자
	var vacuous bool // 숫자가 하나도 나타나지 않았나?
	var okSoFar bool // 오류 메시지를 냈나?
	radix = 0
	okSoFar = true
	@<공백도 부호도 아닌 다음 토큰을 얻고 |negative|를 알맞게 놓는다@>
	if curTok == alphaToken {
		@<알파벳 문자 코드를 |curVal|에 훑어 넣는다@>
	} else if curCmd >= minInternal && curCmd <= maxInternal {
		scanSomethingInternal(intVal, false)
	} else {
		@<수 상수를 훑는다@>
	}
	if negative {
		curVal = -curVal
	}
}

@ 공백과 부호를 건너뛴다. `\.-'를 만날 때마다 부호를 뒤집는다.
@<공백도 부호도 아닌...@>=
negative = false
for {
	@<공백도 호출도 아닌...@>
	if curTok == otherToken+'-' {
		negative = !negative
		curTok = otherToken + '+'
	}
	if curTok != otherToken+'+' {
		break
	}
}

@ 알파벳 상수 `\.{\char'140}' 뒤에는 문자 하나나 한 글자짜리 제어 시퀀스가 온다. 이를테면 \.{\char'140\\a}도 \.a의
코드인 97이다. 매크로가 펼쳐지지 않도록 |getToken|으로 읽는다. 알파벳 문자 상수 뒤의 공백 하나도 무시한다. 그래야
이런 상수가 수 상수처럼 행동한다.

@<알파벳 문자 코드를...@>=
getToken() // 매크로 펼치기를 억누른다
if curTok < csTokenFlag {
	curVal = curChr
	if curCmd <= rightBrace {
		if curCmd == rightBrace {
			alignState++
		} else {
			alignState--
		}
	}
} else if curTok < csTokenFlag+singleBase {
	curVal = curTok - csTokenFlag - activeBase
} else {
	curVal = curTok - csTokenFlag - singleBase
}
if curVal > 255 {
	printErr("Improper alphabetic constant")
@.Improper alphabetic constant@>
	help2("A one-character control sequence belongs after a ` mark.",
		"So I'm essentially inserting \\0 here.")
	curVal = '0'
	backError()
} else {
	@<선택적인 공백 하나를 훑는다@>
}

@ 공백 토큰이 하나 있으면 삼키고, 아니면 읽은 토큰을 되돌린다.
@<선택적인 공백 하나를...@>=
getXToken()
if curCmd != spacer {
	backInput()
}

@ 수 상수를 훑는다. 기수에 따라 넘침의 문턱값 |m|을 정한다.
@<수 상수를...@>=
radix = 10
m = 214748364
if curTok == octalToken {
	radix = 8
	m = 0o2000000000
	getXToken()
} else if curTok == hexToken {
	radix = 16
	m = 0o1000000000
	getXToken()
}
vacuous = true
curVal = 0
@<|curTok|이 알맞은 숫자가 아닐 때까지 상수를 쌓는다@>
if vacuous {
	@<수가 없다는 데 놀라움을 나타낸다@>
} else if curCmd != spacer {
	backInput()
}

@ 숫자를 하나씩 읽어 $|curVal|\leftarrow|radix|\cdot|curVal|+d$를 되풀이한다. 십육진에서는 대문자 \.A--\.F를 글자로든
기타 문자로든 숫자로 받아들인다. 넘침 검사가 미묘하다. 십진 상수에서 |m|은 $\lfloor(2^{31}-1)/10\rfloor=214748364$이다.
지금까지의 값이 |m|보다 크거나, |m|과 같은데 다음 숫자가 7보다 크면 $2^{31}-1$을 넘게 된다. 팔진과 십육진에서는
$|m|=2^{31}/8$과 $2^{31}/16$이므로, 값이 |m|에 이르기만 하면 다음 숫자가 무엇이든 넘친다. 넘치면 오류를 한 번만
알리고 값을 |infinity|로 둔다.

@<|curTok|이 알맞은...@>=
for {
	if curTok < zeroToken+radix && curTok >= zeroToken &&
		curTok <= zeroToken+9 {
		d = curTok - zeroToken
	} else if radix == 16 {
		if curTok <= aToken+5 && curTok >= aToken {
			d = curTok - aToken + 10
		} else if curTok <= otherAToken+5 && curTok >= otherAToken {
			d = curTok - otherAToken + 10
		} else {
			goto done
		}
	} else {
		goto done
	}
	vacuous = false
	if curVal >= m && (curVal > m || d > 7 || radix != 10) {
		if okSoFar {
			printErr("Number too big")
@.Number too big@>
			help2("I can only go up to 2147483647='17777777777=\"7FFFFFFF,",
				"so I'm using that number instead of yours.")
			reportError()
			curVal = infinity
			okSoFar = false
		}
	} else {
		curVal = curVal*radix + d
	}
	getXToken()
}
done:

@ @<정의@>=
const (
	@!infinity = 0o17777777777 // \TeX이 아는 가장 큰 양수 값
	@!zeroToken = otherToken + '0' // 가장 작은 숫자 0
	@!aToken = letterToken + 'A' // 가장 작은 특별한 십육진 숫자
	@!otherAToken = otherToken + 'A' // 형이 |otherChar|인 특별한 십육진 숫자
)

@ 수가 와야 할 곳에 숫자가 하나도 없다. 오류를 알리고 0을 쓴다. 도움말의 ``weird error''는 {\sl The \TeX book}의
찾아보기에 정말로 있는 항목이다.
@<수가 없다는 데...@>=
printErr("Missing number, treated as zero")
@.Missing number...@>
help3("A number should have been here; I inserted `0'.",
	"(If you can't figure out why I needed to see a number,",
	"look up `weird error' in the index to The TeXbook.)")
@^TeXbook@>
backError()

@ 루틴 |scanDimen|은 |scanInt|와 비슷하지만, |curVal|을 |scaled| 값, 곧 sp의 정수 배로 놓는다. 그러니 이 루틴이 하는 주된
일 가운데 하나는 여러 단위의 약어를 알아보고 측정값을 눈금 포인트로 바꾸는 것이다.

매개변수가 셋 있다. 매개변수 |mu|가 |true|이면 유한 단위는 `\.{mu}'여야 하고, |false|이면 `\.{mu}' 단위를 쓸 수 없다.
매개변수 |inf|가 |true|이면 무한 단위 `\.{fil}', `\.{fill}', `\.{filll}'을 쓸 수 있다. 글루의 늘어남과 줄어듦을 읽을 때가
그렇다. 그리고 |shortcut|이 |true|이면 |curVal|에 이미 정수가 들어 있으므로 단위만 읽으면 된다.

무한 글루일 때는 찾은 무한대의 차수를 전역 변수 |curOrder|로 돌려준다.

@<전역 변수@>=
var @!curOrder glueOrd // |scanDimen|이 찾은 무한대의 차수

@ `\.{-\char'47 77 pt}' 같은 것도 올바른 치수이므로 |scanDimen|은 |scanInt|로 시작해도 된다. 소수의 정수 부분에도
|scanInt|를 쓰면 편한 까닭이 이것이다.

루틴 |scanDimen|의 여러 갈래에서는 |curVal|을 정수로 다루면서 보조 분수 |f|를 함께 다루므로, 실제로 관심 있는 양은
$|curVal|+|f|/2^{16}$이다. 이를테면 \.{2.5pt}를 읽으면 |curVal=2|, |f=32768|이다. 루틴이 끝날 때 이 ``풀어 놓은''
표현을 낱말 하나 |curVal|에 담는데, 이때 |curVal|의 뜻은 갑자기 정수에서 |scaled|로 바뀐다. 함수 |scanNormalDimen|은
|scanDimen(false,false,false)|를 줄인 것이다.

@<함수들@>=
func scanNormalDimen() { scanDimen(false, false, false) }

func scanDimen(mu, inf, shortcut bool) { // |curVal|을 치수로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	var f int32 // 분모가 $2^{16}$인 분수의 분자
	@<치수 계산을 위한 지역 변수@>
	f = 0
	arithError = false
	curOrder = normal
	negative = false
	if !shortcut {
		@<부호와 정수 부분과 소수 부분을 훑는다@>
	}
	if curVal < 0 { // 이 경우에는 |f=0|이다
		negative = !negative
		curVal = -curVal
	}
	@<단위를 훑고 |curVal|을 $x\cdot(|curVal|+f/2^{16})$으로 놓는다@>
	@<선택적인 공백 하나를...@>
attachSign: // |curVal|이 부호 말고는 맞을 때 여기로 간다
	if arithError || abs(curVal) >= 0o10000000000 {
		@<이 치수가 범위를 벗어났다고 알린다@>
	}
	if negative {
		curVal = -curVal
	}
}

@ 루틴 |scanDimen|의 앞부분이다. 매개변수 |shortcut|이 |false|일 때 실행한다. 부호를 읽고, 내부 치수가 오면 그
값을 쓰고, 아니면 정수 부분과 소수 부분을 읽는다. 쉼표도 소수점으로 받아들인다. 유럽에서는 쉼표를 소수점으로 쓰기
때문이다.

@<부호와 정수 부분과...@>=
@<공백도 부호도 아닌...@>
if curCmd >= minInternal && curCmd <= maxInternal {
	@<내부 치수를 가져와 |goto attachSign|, 아니면 내부 정수를 가져온다@>
} else {
	backInput()
	if curTok == continentalPointToken {
		curTok = pointToken
	}
	if curTok != pointToken {
		scanInt()
	} else {
		radix = 10
		curVal = 0
	}
	if curTok == continentalPointToken {
		curTok = pointToken
	}
	if radix == 10 && curTok == pointToken {
		@<소수 부분을 훑는다@>
	}
}

@ 수 대신 내부 양이 왔다. 치수(mu 모드에서는 mu 치수)이면 그 값이 곧 답이므로 부호만 붙인다. 정수이면 그 정수 뒤에
단위가 와야 한다. 이를테면 \.{\\count1pt}처럼 쓸 수 있다.
@<내부 치수를 가져와...@>=
if mu {
	scanSomethingInternal(muVal, false)
	@<글루를 치수로 바꾼다@>
	if curValLevel == muVal {
		goto attachSign
	}
	if curValLevel != intVal {
		muError()
	}
} else {
	scanSomethingInternal(dimenVal, false)
	if curValLevel == dimenVal {
		goto attachSign
	}
}

@ @<치수 계산을 위한...@>=
var @!num, @!denom int32 // 훑은 단위의 변환 비율; |1..65536|
var @!k, @!kk smallNumber // 소수 부분의 숫자 수
var @!p, @!q pointer // 십진 숫자 스택의 맨 위
var @!v scaled // 내부 치수
var @!saveCurVal int32 // |curVal|을 잠시 저장한다

@ 다음 코드는 |scanSomethingInternal|을 |muVal|을 요구하며 불렀는데 실제로 원한 것이 ``mu 글루''가 아니라 ``mu 치수''였을
때 실행한다. 글루의 너비만 남기고 글루는 놓아준다.

@<글루를 치수로...@>=
if curValLevel >= glueVal {
	v = width(curVal)
	deleteGlueRef(curVal)
	curVal = v
}

@ 소수 부분을 읽는다. 다음 코드를 실행할 때는 |curTok=pointToken|이지만, 이 토큰은 |backInput|으로 되돌려져 있다. 먼저
그것을 버려야 한다. 소수점 뒤의 숫자들은 스택에 쌓아 두었다가, 다 읽은 뒤에 |roundDecimals|로 $f$를 계산한다. 숫자는
17개까지만 쓴다. 그보다 뒤의 숫자는 결과에 영향을 줄 수 없기 때문이다.

소수점 하나만 있으면 `\.{0.0}'과 같다는 것이 드러난다. 사람들이 이 사실을 쓰지 않기를 바라자.

@<소수 부분을...@>=
k = 0
p = null
getToken() // |pointToken|을 다시 훑는다
for {
	getXToken()
	if curTok > zeroToken+9 || curTok < zeroToken {
		goto done1
	}
	if k < 17 { // |k>=17|인 숫자는 결과에 영향을 줄 수 없다
		q = getAvail()
		setLink(q, p)
		setInfo(q, curTok-zeroToken)
		p = q
		k++
	}
}
done1:
for kk = k; kk >= 1; kk-- {
	dig[kk-1] = info(p)
	q = p
	p = link(p)
	freeAvail(q)
}
f = roundDecimals(k)
if curCmd != spacer {
	backInput()
}

@ 이제 더 어려운 부분이 온다. 프로그램의 이 지점에서 |curVal|은 음이 아닌 정수이고 $f/2^{16}$은 1보다 작은 음이 아닌
분수다. 이 두 양의 합에 단위에 따른 알맞은 인자를 곱해 |scaled| 결과를 얻고 싶은데, 그 계산을 넘침 없는 고정 소수점
산술로 하고 싶다.

다음 코드는 단위를 훑고 |curVal|을 $x\cdot(|curVal|+f/2^{16})$으로 놓는다. 여기서 |x|는 단위당 sp의 수다. 단위가 내부
치수이면(이를테면 \.{2\\hsize}) |goto attachSign|한다. 단위를 읽는 차례는 이렇다. 무한 단위, 내부 치수, mu, 그리고
\.{true}가 붙었으면 확대 배율 보정, 마지막으로 pt를 비롯한 여느 단위.

@<단위를 훑고...@>=
if inf {
	@<\.{fil} 단위를 훑고, 찾았으면 |goto attachFraction|@>
}
@<내부 치수인 단위를 훑고, 찾았으면 |curVal|을 정해 |goto attachSign|@>
if mu {
	@<\.{mu} 단위를 훑고 |goto attachFraction|@>
}
if scanKeyword("true") {
	@<확대 배율에 맞추어 조정한다@>
}
@.true@>
if scanKeyword("pt") {
	goto attachFraction // 쉬운 경우
}
@.pt@>
@<다른 모든 단위를 훑어 |curVal|과 |f|를 조정하고, 눈금 포인트면 |goto done|@>
attachFraction: // |curVal|과 |f|를 |curVal|에 꾸려 넣으려면 여기로 간다
if curVal >= 0o40000 {
	arithError = true
} else {
	curVal = curVal*unity + f
}
done:

@ 무한 단위를 읽는다. `\.{fil}' 뒤의 `\.l'은 따로 떨어진 키워드로 하나씩 읽으므로 `\.{fil l}'도 `\.{fill}'과 같다.
`\.{filllll}'이나 `\.{fill L L L}' 같은 지정은 오류 메시지를 두 개 낳는다(넘치는 키워드 \.{"l"}마다 하나씩).

@<\.{fil} 단위를...@>=
if scanKeyword("fil") {
@.fil@>
	curOrder = fil
	for scanKeyword("l") {
		if curOrder == filll {
			printErr("Illegal unit of measure (")
@.Illegal unit of measure@>
			printStr("replaced by filll)")
			help1("I dddon't go any higher than filll.")
			reportError()
		} else {
			curOrder++
		}
	}
	goto attachFraction
}

@ 단위 자리에 내부 치수가 올 수 있다. \.{2\\hsize}는 \.{\\hsize}의 두 배이고, \.{1.5em}의 \.{em}도 사실상 현재 글꼴의
치수다. 내부 치수가 단위이면 앞의 수에 그 값을 곱한다. 곱할 때 넘치지 않도록 |nxPlusY|와 |xnOverD|를 쓴다.
@<내부 치수인 단위를...@>=
saveCurVal = curVal
@<공백도 호출도 아닌...@>
if curCmd < minInternal || curCmd > maxInternal {
	backInput()
} else {
	if mu {
		scanSomethingInternal(muVal, false)
		@<글루를 치수로...@>
		if curValLevel != muVal {
			muError()
		}
	} else {
		scanSomethingInternal(dimenVal, false)
	}
	v = curVal
	goto found
}
if mu {
	goto notFound
}
if scanKeyword("em") {
	v = @<|curFont|의 em 너비@>
@.em@>
} else if scanKeyword("ex") {
	v = @<|curFont|의 x 높이@>
@.ex@>
} else {
	goto notFound
}
@<선택적인 공백 하나를...@>
found:
curVal = nxPlusY(saveCurVal, v, xnOverD(v, f, 0o200000))
goto attachSign
notFound:

@ 수식 글루에서는 단위가 `\.{mu}'여야 한다. 아니면 오류를 알리고 \.{mu}가 있는 것처럼 한다.
@<\.{mu} 단위를...@>=
if scanKeyword("mu") {
	goto attachFraction
} else {
@.mu@>
	printErr("Illegal unit of measure (")
	printStr("mu inserted)")
@.Illegal unit of measure@>
	help4("The unit of measurement in math glue must be mu.",
		"To recover gracefully from this error, it's best to",
		"delete the erroneous units; e.g., type `2' to delete",
		"two letters. (See Chapter 27 of The TeXbook.)")
@^TeXbook@>
	reportError()
	goto attachFraction
}

@ 단위 앞에 `\.{true}'가 붙으면 확대 배율 \.{\\mag}를 거꾸로 적용해 둔다. 그러면 나중에 문서 전체를 \.{\\mag}만큼
확대해도 이 치수는 정해진 실제 크기가 된다. 이를테면 \.{\\mag=2000}일 때 \.{1truein}은 \.{0.5in}으로 기억된다.
@<확대 배율에 맞추어...@>=
prepareMag()
if mag() != 1000 {
	curVal = xnOverD(curVal, 1000, mag())
	f = (1000*f + 0o200000*remainder) / mag()
	curVal += (f / 0o200000)
	f %= 0o200000
}

@ 여느 단위들이다. 필요한 변환 인자는 모두 분자와 분모의 합이 32768 이하인 분수로 정확히 나타낼 수 있다. 이를테면
1in은 72.27pt이므로 $7227/100$이다. 여기의 정의에 따르면 $\rm2660\,dd\approx1000.33297\,mm$인데, 이 값은 보스하르트가
{\sl Technische Grundlagen zur Satzherstellung\/}
@^Bosshard, Hans Rudolf@>
(Bern, 1980)에서 인용한 값 $\rm1000.333\,mm$와 잘 맞는다.

변환 인자는 다중 대입 `|num, denom = a, b|'로 정한다.

@<다른 모든 단위를...@>=
if scanKeyword("in") {
	num, denom = 7227, 100
@.in@>
} else if scanKeyword("pc") {
	num, denom = 12, 1
@.pc@>
} else if scanKeyword("cm") {
	num, denom = 7227, 254
@.cm@>
} else if scanKeyword("mm") {
	num, denom = 7227, 2540
@.mm@>
} else if scanKeyword("bp") {
	num, denom = 7227, 7200
@.bp@>
} else if scanKeyword("dd") {
	num, denom = 1238, 1157
@.dd@>
} else if scanKeyword("cc") {
	num, denom = 14856, 1157
@.cc@>
} else if scanKeyword("sp") {
	goto done
@.sp@>
} else {
	@<모르는 단위를 불평하고 |goto done2|@>
}
curVal = xnOverD(curVal, num, denom)
f = (num*f + 0o200000*remainder) / denom
curVal += (f / 0o200000)
f %= 0o200000
done2:

@ 모르는 단위다. 오류를 알리고 pt로 본다.
@<모르는 단위를...@>=
printErr("Illegal unit of measure (")
printStr("pt inserted)")
@.Illegal unit of measure@>
help6("Dimensions can be in units of em, ex, in, pt, pc,",
	"cm, mm, dd, cc, bp, or sp; but yours is a new one!",
	"I'll assume that you meant to say pt, for printer's points.",
	"To recover gracefully from this error, it's best to",
	"delete the erroneous units; e.g., type `2' to delete",
	"two letters. (See Chapter 27 of The TeXbook.)")
@^TeXbook@>
reportError()
goto done2

@ 결과가 $2^{30}$\,sp를 넘었다. 오류를 알리고 가장 큰 치수 |maxDimen|을 쓴다.
@<이 치수가 범위를...@>=
printErr("Dimension too large")
@.Dimension too large@>
help2("I can't work with sizes bigger than about 19 feet.",
	"Continue and I'll use the largest value I can.")
reportError()
curVal = maxDimen
arithError = false

@ \TeX의 값 훑기 삼총사의 마지막은 |scanGlue|다. 이 루틴은 |curVal|이 글루 명세를 가리키게 한다. 그 글루 명세의 참조
횟수는 |curVal|이 가리키는 것까지 셈에 넣은 값이 된다.

매개변수 |level|은 |glueVal|이나 |muVal|이어야 한다.

루틴 |scanDimen|이 |scanInt|보다 훨씬 복잡했으니 |scanGlue|는 더 고약하리라고 예상할지도 모르겠다. 그러나 다행히도
아주 간단하다. 일의 대부분이 이미 끝났기 때문이다. 너비를 |scanDimen|으로 읽고, `\.{plus}'와 `\.{minus}' 뒤의 값을
무한 단위도 받아들이는 |scanDimen|으로 읽으면 된다. 내부 글루가 오면 그 값을 그대로 쓴다.

@<함수들@>=
func scanGlue(level smallNumber) { // |curVal|을 글루 명세 포인터로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	mu := (level == muVal) // |level=muVal|인가?
	@<공백도 부호도 아닌...@>
	if curCmd >= minInternal && curCmd <= maxInternal {
		scanSomethingInternal(level, negative)
		if curValLevel >= glueVal {
			if curValLevel != level {
				muError()
			}
			return
		}
		if curValLevel == intVal {
			scanDimen(mu, false, true)
		} else if level == muVal {
			muError()
		}
	} else {
		backInput()
		scanDimen(mu, false, false)
		if negative {
			curVal = -curVal
		}
	}
	@<너비가 |curVal|인 새 글루 명세를 만들고 늘어남과 줄어듦 성분을 훑는다@>
}

@ 너비가 |curVal|인 새 글루 명세를 만들고, 늘어남과 줄어듦이 있으면 읽어 넣는다.
@<너비가 |curVal|인...@>=
q := newSpec(zeroGlue) // 새 글루 명세
setWidth(q, curVal)
if scanKeyword("plus") {
@.plus@>
	scanDimen(mu, true, false)
	setStretch(q, curVal)
	setStretchOrder(q, curOrder)
}
if scanKeyword("minus") {
@.minus@>
	scanDimen(mu, true, false)
	setShrink(q, curVal)
	setShrinkOrder(q, curOrder)
}
curVal = q

@ 다음은 괘선 노드를 가리키는 포인터를 돌려주는 비슷한 프로시저다. 이 루틴은 \TeX이 \.{\\hrule}이나 \.{\\vrule}을 본
바로 뒤에 부른다. 그러므로 |curCmd|는 |hrule|이나 |vrule|이다. 생각은 이렇다. 기본 괘선 치수를 노드에 넣어 두었다가,
`\.{height}'나 `\.{width}'나 `\.{depth}' 지정을 찾으면(순서는 상관없고, 같은 것이 여러 번 나오면 마지막 것이 이긴다)
그것으로 덮어쓴다. 기본값은 세로 괘선이면 너비 0.4pt에 높이와 깊이가 흐르는 치수이고, 가로 괘선이면 높이 0.4pt,
깊이 0pt에 너비가 흐르는 치수다.

@<함수들@>=
const @!defaultRule = 26214 // 0.4\thinspace pt

func scanRuleSpec() pointer {
	var q pointer // 만들고 있는 괘선 노드
	q = newRule() // 이제 |width|, |depth|, |height|는 모두 |nullFlag|다
	if curCmd == vrule {
		setWidth(q, defaultRule)
	} else {
		setHeight(q, defaultRule)
		setDepth(q, 0)
	}
reswitch:
	if scanKeyword("width") {
@.width@>
		scanNormalDimen()
		setWidth(q, curVal)
		goto reswitch
	}
	if scanKeyword("height") {
@.height@>
		scanNormalDimen()
		setHeight(q, curVal)
		goto reswitch
	}
	if scanKeyword("depth") {
@.depth@>
		scanNormalDimen()
		setDepth(q, curVal)
		goto reswitch
	}
	return q
}

@* 토큰 목록 만들기.
매크로나 \.{\\mark}, \.{\\output}, \.{\\write} 같은 것의 토큰 목록은 |scanToks|라는 프로시저가 만든다.

그러나 |scanToks|의 자세한 내용에 들어가기 전에 훨씬 간단한 일부터 살펴보자. 현재 문자열을 토큰 목록으로 바꾸는
일이다. 이 일은 함수 |strToks|가 한다. 이 함수는 공백을 형 |spacer|로, 나머지 문자는 모두 형 |otherChar|로
분류한다. 그래서 이를테면 \.{\\jobname}이 내놓는 글자들은 글자(catcode 11)가 아니라 기타 문자(catcode 12)다.

함수 |strToks|가 만든 토큰 목록은 |link(tempHead)|에서 시작해서 돌려주는 값 |p|에서 끝난다. (|p=tempHead|이면
목록은 비어 있다.) 다 만든 뒤에는 문자열을 지워 풀 공간을 돌려준다.

@<함수들@>=
func strToks(b poolPointer) pointer { // |strPool[b..poolPtr-1]|을 토큰 목록으로 바꾼다
	var p pointer // 토큰 목록의 꼬리
	var q pointer // |storeNewToken|으로 토큰 목록에 보탤 새 노드
	var t halfword // 덧붙일 토큰
	strRoom(1)
	p = tempHead
	setLink(p, null)
	k := b // |strPool|의 첨자
	for k < poolPtr {
		t = so(strPool[k])
		if t == ' ' {
			t = spaceToken
		} else {
			t = otherToken + t
		}
		fastStoreNewToken(&p, &q, t)
		k++
	}
	poolPtr = b
	return p
}

@ 함수 |strToks|가 필요한 가장 큰 까닭은 다음 함수 |theToks|다. 이 함수도 입력과 출력의 성질이 비슷하다.

이 함수는 `\.{\\skip\\count12}'처럼 `\.{\\the}' 뒤에 올 수 있는 것을 무엇이든 훑어서 `\.{-3.0pt minus 0.5fill}'
같은 것을 담은 토큰 목록을 만든다. 값을 찍는 루틴으로 문자열을 만든 다음 |strToks|로 토큰 목록으로 바꾸는 것이다.
토큰 목록 레지스터나 글꼴 식별자처럼 이미 토큰인 것은 문자열을 거치지 않고 그대로 베낀다.

@<함수들@>=
func theToks() (theToks pointer) {
	var oldSetting int32 // |selector| 설정을 담는다; |0 .. maxSelector|
	var p, q, r pointer // 토큰 목록을 베끼는 데 쓴다
	var b poolPointer // 임시 문자열의 바닥
	getXToken()
	scanSomethingInternal(tokVal, false)
	if curValLevel >= identVal {
		@<토큰 목록을 베낀다@>
	} else {
		oldSetting = selector
		selector = newString
		b = poolPtr
		switch curValLevel {
		case intVal:
			printInt(curVal)
		case dimenVal:
			printScaled(curVal)
			printStr("pt")
		case glueVal:
			printSpec(curVal, "pt")
			deleteGlueRef(curVal)
		case muVal:
			printSpec(curVal, "mu")
			deleteGlueRef(curVal)
		} // 다른 경우는 없다
		selector = oldSetting
		theToks = strToks(b)
	}
	return
}

@ 토큰 목록 레지스터는 참조 횟수 노드를 빼고 토큰들을 베낀다. 글꼴 식별자는 그 제어 시퀀스 토큰 하나가 된다.
@<토큰 목록을 베낀다@>=
p = tempHead
setLink(p, null)
if curValLevel == identVal {
	storeNewToken(&p, &q, csTokenFlag+curVal)
} else if curVal != null {
	r = link(curVal) // 참조 횟수는 베끼지 않는다
	for r != null {
		fastStoreNewToken(&p, &q, info(r))
		r = link(r)
	}
}
theToks = p

@ 다음은 |expand| 서브루틴에서 \.{\\the}를 처리하는 부분이다. 이제 완성할 준비가 되었다. 함수 |theToks|가 만든 목록을
끼워 넣은 텍스트로 입력에 넣는다.

@<함수들@>=
func insTheToks() {
	setLink(garbage, theToks())
	insList(link(tempHead))
}

@ 원시 명령 \.{\\number}, \.{\\romannumeral}, \.{\\string}, \.{\\meaning}, \.{\\fontname}, \.{\\jobname}은 다음과 같이
정의한다. 모두 명령 코드가 |convert|이고, 무언가를 문자열로 찍은 결과를 토큰으로 바꾸어 내놓는다.

@<\TeX의 원시 명령을...@>=
primitive("number", convert, numberCode)
@!@:number_}{\.{\\number} primitive@>
primitive("romannumeral", convert, romanNumeralCode)
@!@:roman_numeral_}{\.{\\romannumeral} primitive@>
primitive("string", convert, stringCode)
@!@:string_}{\.{\\string} primitive@>
primitive("meaning", convert, meaningCode)
@!@:meaning_}{\.{\\meaning} primitive@>
primitive("fontname", convert, fontNameCode)
@!@:font_name_}{\.{\\fontname} primitive@>
primitive("jobname", convert, jobNameCode)
@!@:job_name_}{\.{\\jobname} primitive@>

@ @<정의@>=
const (
	@!numberCode = iota // \.{\\number}의 명령 코드
	@!romanNumeralCode // \.{\\romannumeral}의 명령 코드
	@!stringCode // \.{\\string}의 명령 코드
	@!meaningCode // \.{\\meaning}의 명령 코드
	@!fontNameCode // \.{\\fontname}의 명령 코드
	@!jobNameCode // \.{\\jobname}의 명령 코드
)

@ @<원시 명령의 이름을 찍는...@>=
case convert:
	switch chrCode {
	case numberCode: printEsc("number")
	case romanNumeralCode: printEsc("romannumeral")
	case stringCode: printEsc("string")
	case meaningCode: printEsc("meaning")
	case fontNameCode: printEsc("fontname")
	default: printEsc("jobname")
	}

@ 프로시저 |convToks|는 |strToks|를 써서 |convert| 명령들이 만든 토큰 목록을 훑개에 끼워 넣는다. 먼저 명령에 따라
인자를 읽고, 그 결과를 문자열로 찍은 다음, 그것을 토큰 목록으로 바꾼다. `\.{\\string}'과 `\.{\\meaning}' 뒤에는
`\.{\\outer}' 제어 시퀀스가 와도 된다.

@<함수들@>=
func convToks() {
	var saveScannerStatus smallNumber // 들어올 때의 |scannerStatus|
	c := curChr // 원하는 변환의 종류; |numberCode..jobNameCode|
	@<명령 |c|의 인자를 훑는다@>
	oldSetting := selector // |selector| 설정을 담는다; |0 .. maxSelector|
	selector = newString
	b := poolPtr // 임시 문자열의 바닥
	@<명령 |c|의 결과를 찍는다@>
	selector = oldSetting
	setLink(garbage, strToks(b))
	insList(link(tempHead))
}

@ 명령에 따라 인자를 읽는다. 명령 \.{\\number}와 \.{\\romannumeral}은 정수를, \.{\\string}과 \.{\\meaning}은 펼치지 않은
토큰 하나를, \.{\\fontname}은 글꼴 식별자를 읽는다. 명령 \.{\\jobname}은 인자가 없지만, 작업 이름이 아직 정해지지 않았으면
이참에 기록 파일을 열어 이름을 정한다.
@<명령 |c|의 인자를...@>=
switch c {
case numberCode, romanNumeralCode:
	scanInt()
case stringCode, meaningCode:
	saveScannerStatus = scannerStatus
	scannerStatus = normal
	getToken()
	scannerStatus = saveScannerStatus
case fontNameCode:
	scanFontIdent()
case jobNameCode:
	if jobName == 0 {
		openLogFile()
	}
} // 다른 경우는 없다

@ 명령에 따라 결과를 찍는다. 이를테면 \.{\\string\\foo}는 탈출 문자까지 붙여 \.{\\foo}를 찍고, \.{\\fontname\\tenrm}은
글꼴 파일 이름 \.{cmr10}을, 크기가 설계 크기와 다르면 `\.{cmr10 at 12.0pt}'를 찍는다.
@<명령 |c|의 결과를...@>=
switch c {
case numberCode:
	printInt(curVal)
case romanNumeralCode:
	printRomanInt(curVal)
case stringCode:
	if curCs != 0 {
		sprintCs(curCs)
	} else {
		printChar(curChr)
	}
case meaningCode:
	printMeaning()
case fontNameCode:
	printStr(fontName[curVal])
	if fontSize[curVal] != fontDsize[curVal] {
		printStr(" at ")
		printScaled(fontSize[curVal])
		printStr("pt")
	}
case jobNameCode:
	printStr(jobName)
} // 다른 경우는 없다

@ 이제 더는 어려운 일을 미룰 수 없다. 용감하게 |scanToks|에 덤벼들자. 이 함수는 새 토큰 목록의 꼬리를 가리키는
포인터를 돌려주고, |defRef|가 그 목록 머리의 참조 횟수를 가리키게 한다.

불 매개변수 |macroDef|와 |xpand|가 있다. 매개변수 |macroDef|가 참이면 매크로 정의의 토큰 목록을 만든다.
그렇지 않으면 다른 \TeX\ 원시 명령, 곧 \.{\\mark}, \.{\\output}, \.{\\everypar}, \.{\\lowercase}, \.{\\uppercase},
\.{\\message}, \.{\\errmessage}, \.{\\write}, \.{\\special} 가운데 하나의 토큰 목록을 만든다. 뒤의 경우들에서는
다음에 왼쪽 중괄호를 훑어야 한다. 이 왼쪽 중괄호는 토큰 목록에 들어가지 않으며, 끝의 짝이 맞는 오른쪽 중괄호도
마찬가지다. 매개변수 |xpand|가 거짓이면 |getToken|으로 입력을 그대로 베낀다. 참이면 펼칠 수 있는 토큰들을 펼칠
수 없는 토큰만 남을 때까지 모두 펼친다. 다만 `\.{\\the}'를 펼친 결과는 더 펼치지 않는다. 두 매개변수가 둘 다 참이면,
곧 \.{\\edef}이면, 펼치기는 매크로 본문(곧 첫 |leftBrace| 문자 뒤의 재료)에만 한다.

함수 |scanToks|가 시작할 때 |curCs|는 ``폭주'' 오류 메시지에 보여 줄 제어 시퀀스의 |eqtb| 주소여야 한다.

@<함수들@>=
func scanToks(macroDef, xpand bool) pointer {
	var t halfword // 가장 큰 매개변수 번호를 나타내는 토큰
	var s halfword // 저장한 토큰
	var p pointer // 만들고 있는 토큰 목록의 꼬리
	var q pointer // |storeNewToken|으로 토큰 목록에 보탤 새 노드
	var unbalance halfword // 짝이 맞지 않는 왼쪽 중괄호의 수
	var hashBrace halfword // `\.{\#\{}' 토큰일 수도 있는 것
	if macroDef {
		scannerStatus = defining
	} else {
		scannerStatus = absorbing
	}
	warningIndex = curCs
	defRef = getAvail()
	setTokenRefCount(defRef, null)
	p = defRef
	hashBrace = 0
	t = zeroToken
	if macroDef {
		@<매크로 정의의 매개변수 부분을 훑어 만든다@>
	} else {
		scanLeftBrace() // 반드시 있어야 할 왼쪽 중괄호를 없앤다
	}
	@<토큰 목록의 몸체를 훑어 만들고, 끝나면 |goto found|@>
found:
	scannerStatus = normal
	if hashBrace != 0 {
		storeNewToken(&p, &q, hashBrace)
	}
	return p
}

@ 매크로 정의의 매개변수 부분을 읽는다. 왼쪽 중괄호가 나올 때까지 토큰을 모으고, \.\#을 만나면 |match| 토큰을
만든다. 끝에 |endMatch|를 붙인다. 오른쪽 중괄호가 먼저 나오면 왼쪽 중괄호가 빠졌다고 알린다.
@<매크로 정의의 매개변수...@>=
for {
again:
	getToken() // |curCmd|, |curChr|, |curTok|를 정한다
	if curTok < rightBraceLimit {
		goto done1
	}
	if curCmd == macParam {
		@<|match| 토큰을 만들거나, \.{\#\{}면 |goto done|@>
	}
	storeNewToken(&p, &q, curTok)
}
done1:
storeNewToken(&p, &q, endMatchToken)
if curCmd == rightBrace {
	@<왼쪽 중괄호가 빠졌다고 놀라고 |goto found|@>
}
done:

@ 이를테면 `\.{\\def\\a\}}'처럼 매개변수 부분에서 오른쪽 중괄호가 나왔다. `\.{\\def\\a\{\}}'로 보고 넘어간다.
@<왼쪽 중괄호가 빠졌다고...@>=
printErr("Missing { inserted")
alignState++
@.Missing \{ inserted@>
help2("Where was the left brace? You said something like `\\def\\a}',",
	"which I'm going to interpret as `\\def\\a{}'.")
reportError()
goto found

@ 다음 코드는 \.\# 다음 문자가 매개변수 번호이면 |curTok|을 |match| 토큰으로 만든다. 번호는 1부터 차례로 와야 하고,
아홉 개를 넘을 수 없다. 그러나 \.\# 다음이 왼쪽 중괄호이면 `|leftBrace|, |endMatch|'를 저장하고 |hashBrace|를 정한 뒤
|goto done|한다(\secref{tokens}의 `\.{\#\{}' 이야기를 보라).

@<|match| 토큰을 만들거나...@>=
s = matchToken + curChr
getToken()
if curTok < leftBraceLimit {
	hashBrace = curTok
	storeNewToken(&p, &q, curTok)
	storeNewToken(&p, &q, endMatchToken)
	goto done
}
if t == zeroToken+9 {
	printErr("You already have nine parameters")
@.You already have nine...@>
	help2("I'm going to ignore the # sign you just used,",
		"as well as the token that followed it.")
	reportError()
	goto again
} else {
	t++
	if curTok != t {
		printErr("Parameters must be numbered consecutively")
@.Parameters...consecutively@>
		help2("I've inserted the digit you should have used after the #.",
			"Type `1' to delete what you did use.")
		backError()
	}
	curTok = s
}

@ 토큰 목록의 본문을 읽는다. 중괄호의 짝을 세다가 짝이 맞는 오른쪽 중괄호에서 멈춘다. 매크로 본문에서 \.\#을
만나면 매개변수 번호를 읽어 |outParam| 토큰으로 바꾼다.
@<토큰 목록의 몸체를...@>=
unbalance = 1
for {
	if xpand {
		@<입력의 다음 부분을 펼친다@>
	} else {
		getToken()
	}
	if curTok < rightBraceLimit {
		if curCmd < rightBrace {
			unbalance++
		} else {
			unbalance--
			if unbalance == 0 {
				goto found
			}
		}
	} else if curCmd == macParam {
		if macroDef {
			@<매개변수 번호나 \.{\#\#}를 찾는다@>
		}
	}
	storeNewToken(&p, &q, curTok)
}

@ 명령 \.{\\edef}나 \.{\\xdef}처럼 펼치며 읽을 때다. 여기서는 |theToks|가 만든 토큰 목록 전체를 더 펼치지 않고 끼워 넣는다.
그래서 `\.{\\edef\\a\{\\the\\toks0\}}'에서 \.{\\toks0} 안의 매크로는 펼쳐지지 않는다.

@<입력의 다음 부분을...@>=
for {
	getNext()
	if curCmd <= maxCommand {
		goto done2
	}
	if curCmd != the {
		expand()
	} else {
		q = theToks()
		if link(tempHead) != null {
			setLink(p, link(tempHead))
			p = q
		}
	}
}
done2:
xToken()

@ 본문의 \.\# 다음 토큰을 본다. \.{\#\#}이면 \.\# 하나를 나타내는 토큰을 넣는다. 숫자이면 그 번호가 정의된 매개변수
수를 넘지 않는지 검사하고 |outParam| 토큰을 넣는다. 아니면 \.{\#\#}의 실수로 보고 알린다.
@<매개변수 번호나...@>=
s = curTok
if xpand {
	getXToken()
} else {
	getToken()
}
if curCmd != macParam {
	if curTok <= zeroToken || curTok > t {
		printErr("Illegal parameter number in definition of ")
@.Illegal parameter number...@>
		sprintCs(warningIndex)
		help3("You meant to type ## instead of #, right?",
			"Or maybe a } was forgotten somewhere earlier, and things",
			"are all screwed up? I'm going to assume that you meant ##.")
		backError()
		curTok = s
	} else {
		curTok = outParamToken - '0' + curChr
	}
}

@ 토큰 목록을 만드는 또 하나의 방법은 \.{\\read} 명령이다. 읽는 데 쓸 수 있는 파일 열여섯 개는 다음 전역 변수들에
있다. 스트림 |n|번을 열지 않았거나 다 읽었으면 |readOpen[n]|은 |closed|다. 명령 \.{\\openin}은 했지만 아직 \.{\\read}는
하지 않았으면 |justOpen|이고, 열려 있어서 다음 줄을 읽을 준비가 되어 있으면 |normal|이다. 첨자 16은 터미널을
나타낸다.

@<전역 변수@>=
const (
	@!closed = 2 // 열려 있지 않거나 파일 끝에 있다
	@!justOpen = 1 // 새로 열렸고, 첫 줄을 아직 읽지 않았다
)

var @!readFile [16]alphaFile // \.{\\read}에 쓰인다
var @!readOpen [17]int32 // |readFile[n]|의 상태; |normal..closed|

@ 처음에는 모든 스트림이 닫혀 있다.
@<핵심 변수들의...@>=
for k = 0; k <= 16; k++ {
	readOpen[k] = closed
}

@ 프로시저 |readToks|는 \.{\\read}로 읽은 줄을 매개변수 없는 매크로 정의와 같은 꼴의 토큰 목록으로 만들고, |curVal|이
그것을 가리키게 한다. 매개변수 |r|은 이 토큰 목록을 받을 제어 시퀀스를 가리킨다. 읽은 줄의 중괄호가 짝이 맞지
않으면 짝이 맞을 때까지 여러 줄을 읽는다. 스트림 번호가 0부터 15까지가 아니면 터미널에서 읽는다.

@<함수들@>=
func readToks(n int32, r pointer) {
	var p pointer // 토큰 목록의 꼬리
	var q pointer // |storeNewToken|으로 토큰 목록에 보탤 새 노드
	var s int32 // 저장한 |alignState|의 값
	var m smallNumber // 흐름 번호
	scannerStatus = defining
	warningIndex = r
	defRef = getAvail()
	setTokenRefCount(defRef, null)
	p = defRef // 참조 횟수
	storeNewToken(&p, &q, endMatchToken)
	if n < 0 || n > 15 {
		m = 16
	} else {
		m = n
	}
	s = alignState
	alignState = 1000000 // 탭 표시 따위를 끈다
	for {
		@<파일의 다음 줄에서 토큰들을 입력해서 저장한다@>
		if alignState == 1000000 {
			break
		}
	}
	curVal = defRef
	scannerStatus = normal
	alignState = s
}

@ 파일의 다음 줄을 읽어 토큰 목록에 덧붙인다. 그 줄을 새 입력 수준으로 삼아 |getToken|으로 토큰을 하나씩 읽는다.
@<파일의 다음 줄에서...@>=
beginFileReading()
name = m + 1
if readOpen[m] == closed {
	@<터미널에서 \.{\\read}를 위한 입력을 한다@>
} else if readOpen[m] == justOpen {
	@<|readFile[m]|의 첫 줄을 입력한다@>
} else {
	@<|readFile[m]|의 다음 줄을 입력한다@>
}
limit = last
if endLineCharInactive() {
	limit--
} else {
	buffer[limit] = endLineChar()
}
first = limit + 1
loc = start
state = newLine
for {
	getToken()
	if curTok == 0 {
		goto done
	} // 줄의 끝에서는 |curCmd=curChr=0|이 된다
	if alignState < 1000000 { // 짝이 맞지 않는 `\.\}'는 그 줄을 그만두게 한다
		for {
			getToken()
			if curTok == 0 {
				break
			}
		}
		alignState = 1000000
		goto done
	}
	storeNewToken(&p, &q, curTok)
}
done:
endFileReading()

@ 여기서는 화면에서 배열 |buffer|로 입력받는다. 스트림 번호가 |n>=0|이면 사용자에게 `\.{\\a=}'처럼 받을 제어 시퀀스의 이름을 찍어
명시적으로 재촉한다. 여러 줄을 받아야 할 때 다시 재촉하지 않도록 |n|을 음수로 바꾸어 둔다. 사용자와 대화하지
않는 모드에서는 터미널에서 읽을 수 없으므로 치명적인 오류다.

@<터미널에서 \.{\\read}를...@>=
if interaction > nonstopMode {
	if n < 0 {
		promptInput("")
	} else {
		wakeUpTerminal()
		printLn()
		sprintCs(r)
		promptInput("=")
		n = -1
	}
} else {
	fatalError("*** (cannot \\read from terminal in nonstop modes)")
}
@.cannot \\read@>

@ 파일의 첫 줄은 따로 다룬다. 첫 줄을 읽을 때는 앞 줄의 끝을 건너뛸 것이 없으므로 |inputLn|의 |bypassEoln|을
|false|로 준다(이 구현에서는 어차피 그 매개변수를 쓰지 않는다). 파일이 비어 있으면 곧바로 닫는다.
@^system dependencies@>

@<|readFile[m]|의 첫 줄을...@>=
if inputLn(&readFile[m], false) {
	readOpen[m] = normal
} else {
	aClose(&readFile[m])
	readOpen[m] = closed
}

@ 파일을 다 읽으면 스트림을 닫는다. 그런데 이때 \.{\\read}가 읽던 줄의 중괄호 짝이 아직 맞지 않았다면 오류를 알린다.
결과적으로 파일 |readFile|의 끝에는 빈 줄이 하나 덧붙는 것과 같다.
@^empty line at end of file@>

@<|readFile[m]|의 다음 줄을...@>=
if !inputLn(&readFile[m], true) {
	aClose(&readFile[m])
	readOpen[m] = closed
	if alignState != 1000000 {
		runaway()
		printErr("File ended within ")
		printEsc("read")
@.File ended within \\read@>
		help1("This \\read has unbalanced braces.")
		alignState = 1000000
		limit = 0
		reportError()
	}
}

@* 조건문 처리.
이제 \TeX이 여러 가지 \.{\\if} 명령을 어떻게 다루는지 살펴보자. 조건문은 펼치기의 일부다. 명령 \.{\\if...}를 만나면
조건을 계산하고, 참이면 그대로 읽어 나가다가 \.{\\else}에서 \.{\\fi}까지를 건너뛰고, 거짓이면 \.{\\else}나 \.{\\fi}까지를
건너뛴 다음 읽어 나간다. 건너뛰는 텍스트는 펼치지 않고 훑기만 한다.

@<\TeX의 원시 명령을...@>=
primitive("if", ifTest, ifCharCode)
@!@:if_char_}{\.{\\if} primitive@>
primitive("ifcat", ifTest, ifCatCode)
@!@:if_cat_code_}{\.{\\ifcat} primitive@>
primitive("ifnum", ifTest, ifIntCode)
@!@:if_int_}{\.{\\ifnum} primitive@>
primitive("ifdim", ifTest, ifDimCode)
@!@:if_dim_}{\.{\\ifdim} primitive@>
primitive("ifodd", ifTest, ifOddCode)
@!@:if_odd_}{\.{\\ifodd} primitive@>
primitive("ifvmode", ifTest, ifVmodeCode)
@!@:if_vmode_}{\.{\\ifvmode} primitive@>
primitive("ifhmode", ifTest, ifHmodeCode)
@!@:if_hmode_}{\.{\\ifhmode} primitive@>
primitive("ifmmode", ifTest, ifMmodeCode)
@!@:if_mmode_}{\.{\\ifmmode} primitive@>
primitive("ifinner", ifTest, ifInnerCode)
@!@:if_inner_}{\.{\\ifinner} primitive@>
primitive("ifvoid", ifTest, ifVoidCode)
@!@:if_void_}{\.{\\ifvoid} primitive@>
primitive("ifhbox", ifTest, ifHboxCode)
@!@:if_hbox_}{\.{\\ifhbox} primitive@>
primitive("ifvbox", ifTest, ifVboxCode)
@!@:if_vbox_}{\.{\\ifvbox} primitive@>
primitive("ifx", ifTest, ifxCode)
@!@:ifx_}{\.{\\ifx} primitive@>
primitive("ifeof", ifTest, ifEOFCode)
@!@:if_eof_}{\.{\\ifeof} primitive@>
primitive("iftrue", ifTest, ifTrueCode)
@!@:if_true_}{\.{\\iftrue} primitive@>
primitive("iffalse", ifTest, ifFalseCode)
@!@:if_false_}{\.{\\iffalse} primitive@>
primitive("ifcase", ifTest, ifCaseCode)
@!@:if_case_}{\.{\\ifcase} primitive@>

@ @<정의@>=
const (
	@!ifCharCode = iota // `\.{\\if}'
	@!ifCatCode // `\.{\\ifcat}'
	@!ifIntCode // `\.{\\ifnum}'
	@!ifDimCode // `\.{\\ifdim}'
	@!ifOddCode // `\.{\\ifodd}'
	@!ifVmodeCode // `\.{\\ifvmode}'
	@!ifHmodeCode // `\.{\\ifhmode}'
	@!ifMmodeCode // `\.{\\ifmmode}'
	@!ifInnerCode // `\.{\\ifinner}'
	@!ifVoidCode // `\.{\\ifvoid}'
	@!ifHboxCode // `\.{\\ifhbox}'
	@!ifVboxCode // `\.{\\ifvbox}'
	@!ifxCode // `\.{\\ifx}'
	@!ifEOFCode // `\.{\\ifeof}'
	@!ifTrueCode // `\.{\\iftrue}'
	@!ifFalseCode // `\.{\\iffalse}'
	@!ifCaseCode // `\.{\\ifcase}'
)

@ @<원시 명령의 이름을 찍는...@>=
case ifTest:
	switch chrCode {
	case ifCatCode: printEsc("ifcat")
	case ifIntCode: printEsc("ifnum")
	case ifDimCode: printEsc("ifdim")
	case ifOddCode: printEsc("ifodd")
	case ifVmodeCode: printEsc("ifvmode")
	case ifHmodeCode: printEsc("ifhmode")
	case ifMmodeCode: printEsc("ifmmode")
	case ifInnerCode: printEsc("ifinner")
	case ifVoidCode: printEsc("ifvoid")
	case ifHboxCode: printEsc("ifhbox")
	case ifVboxCode: printEsc("ifvbox")
	case ifxCode: printEsc("ifx")
	case ifEOFCode: printEsc("ifeof")
	case ifTrueCode: printEsc("iftrue")
	case ifFalseCode: printEsc("iffalse")
	case ifCaseCode: printEsc("ifcase")
	default: printEsc("if")
	}

@ 조건문 안에 조건문이 들어 있을 수 있으므로, 이 중첩을 기억하는 스택이 |saveStack|과는 따로 있다.

조건 스택의 맨 위는 전역 변수 넷이 나타낸다. 포인터 |condPtr|는 아래로 밀려 내려간 항목들이 있으면 그것을
가리킨다. 변수 |ifLimit|는 지금 문법상 나올 수 있는 |fiOrElse| 명령의 가장 큰 코드다. 이를테면 \.{\\else}를 이미
지났으면 |ifLimit=fiCode|여서 또 \.{\\else}가 나오면 오류다. 변수 |curIf|는 현재 조건문의 종류이고, |ifLine|은 그것이
시작한 줄 번호다.

진행 중인 조건문이 없으면 조건 스택은 특별한 상태 |condPtr=null|, |ifLimit=normal|, |curIf=0|, |ifLine=0|에 있다.
그렇지 않으면 |condPtr|는 두 낱말짜리 노드를 가리킨다. 그 첫 낱말의 \ID{type}, |subtype|, |link| 필드에는 바깥
수준의 |ifLimit|, |curIf|, |condPtr|가 들어 있고, 둘째 낱말에는 그 |ifLine|이 들어 있다.

@<전역 변수@>=
const (
	@!ifNodeSize = 2 // 조건문을 위한 스택 항목의 낱말 수
	@!ifCode = 1 // 계산하고 있는 \.{\\if...}의 코드
	@!fiCode = 2 // \.{\\fi}의 코드
	@!elseCode = 3 // \.{\\else}의 코드
	@!orCode = 4 // \.{\\or}의 코드
)

func ifLineField(p pointer) int32        { return mem[p+1].sc }
func setIfLineField(p pointer, v int32) { mem[p+1].sc = v }

var @!condPtr pointer // 조건 스택의 맨 위
var @!ifLimit int32 // |fiOrElse| 코드의 상한; |normal..orCode|
var @!curIf smallNumber // 처리하고 있는 조건문의 종류
var @!ifLine int32 // 그 조건문이 시작한 줄

@ @<핵심 변수들의...@>=
condPtr = null
ifLimit = normal
curIf = 0
ifLine = 0

@ 명령 \.{\\fi}, \.{\\or}, \.{\\else}를 넣는다. 오류를 수습할 때 끼워 넣을 수 있도록 얼린 \.{\\fi}도 만들어 둔다.
@<\TeX의 원시 명령을...@>=
primitive("fi", fiOrElse, fiCode)
@!@:fi_}{\.{\\fi} primitive@>
setText(frozenFi, str("fi"))
eqtb[frozenFi] = eqtb[curVal]
primitive("or", fiOrElse, orCode)
@!@:or_}{\.{\\or} primitive@>
primitive("else", fiOrElse, elseCode)
@!@:else_}{\.{\\else} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case fiOrElse:
	if chrCode == fiCode {
		printEsc("fi")
	} else if chrCode == orCode {
		printEsc("or")
	} else {
		printEsc("else")
	}

@ 조건부 텍스트를 건너뛸 때는, 오류 메시지에 쓰려고 건너뛰기를 시작한 줄 번호를 기억해 둔다.

@<전역 변수@>=
var @!skipLine int32 // 여기서 건너뛰기를 시작했다

@ 다음은 $\.{\\if}\ldots\.{\\fi}$ 중첩의 현재 수준에서 \.{\\or}나 \.{\\else}나 \.{\\fi}에 이를 때까지 텍스트를 무시하는
프로시저다. 안쪽에 \.{\\if...}가 나오면 수준 |l|을 하나 올리고, \.{\\fi}가 나오면 하나 내린다. 그래서 안쪽 조건문의
\.{\\else}에 속지 않는다. 이 프로시저가 일을 마치면 |curChr|는 찾은 토큰을 나타내지만, |curTok|은 정하지 않는다(그래야
프로시저가 더 빨리 돈다). 펼치지 않고 |getNext|로만 읽는다는 데 눈여겨보자.

@<함수들@>=
func passText() {
	var l int32 // $\.{\\if}\ldots\.{\\fi}$ 중첩의 수준
	var saveScannerStatus smallNumber // 들어올 때의 |scannerStatus|
	saveScannerStatus = scannerStatus
	scannerStatus = skipping
	l = 0
	skipLine = line
	for {
		getNext()
		if curCmd == fiOrElse {
			if l == 0 {
				goto done
			}
			if curChr == fiCode {
				l--
			}
		} else if curCmd == ifTest {
			l++
		}
	}
done:
	scannerStatus = saveScannerStatus
}

@ 새 \.{\\if}를 처리하기 시작할 때 |ifLimit=ifCode|로 놓는다. 그러면 현재 \.{\\if}의 조건을 다 계산하기 전에 \.{\\or}나
\.{\\else}나 \.{\\fi}가 나올 경우 \.{\\relax}가 끼워 넣어진다. 이를테면 `\.{\\ifvoid1\\else...\\fi}' 같은 것은, 그러지
않으면 `\.1' 뒤에 무언가가 더 와야 할 것이다. 수를 읽던 |scanInt|가 \.{\\else}를 펼쳐 버리기 때문이다.

@<조건 스택에 쌓는다@>=
p = getNode(ifNodeSize)
setLink(p, condPtr)
setType(p, ifLimit)
setSubtype(p, curIf)
setIfLineField(p, ifLine)
condPtr = p
curIf = curChr
ifLimit = ifCode
ifLine = line

@ 조건문이 끝나면 바깥 수준의 상태를 되살린다.
@<조건 스택에서 꺼낸다@>=
p = condPtr
ifLine = ifLineField(p)
curIf = subtype(p)
ifLimit = typ(p)
condPtr = link(p)
freeNode(p, ifNodeSize)

@ 다음은 |condPtr|의 주어진 값에 해당하는 수준의 |ifLimit| 코드를 바꾸는 프로시저다. 조건을 계산하는 동안 안쪽에서
다른 조건문이 시작했다면, 바꾸어야 할 수준이 스택의 맨 위가 아닐 수도 있다. 그때는 스택을 거슬러 올라가며 찾는다.

@<함수들@>=
func changeIfLimit(l smallNumber, p pointer) {
	var q pointer
	if p == condPtr {
		ifLimit = l // 쉬운 경우다
	} else {
		q = condPtr
		for {
			if q == null {
				confusion("if")
			}
@:this can't happen if}{\quad if@>
			if link(q) == p {
				setType(q, l)
				return
			}
			q = link(q)
		}
	}
}

@ 프로시저 |expand|가 |ifTest| 명령을 만나면 조건문이 시작된다. 그때 |expand|가 하는 일은 재귀 프로시저 |conditional|을
부르는 것뿐이다. 이 프로시저는 조건 스택에 새 수준을 쌓고, 조건을 계산하고, 참이면 그대로 돌아가고, 거짓이면
\.{\\else}나 \.{\\fi}까지 건너뛴다.
@^recursion@>

@<함수들@>=
func conditional() {
	var b bool // 조건이 참인가?
	var r int32 // 계산할 관계; |"<"..">"|
	var m, n int32 // 둘째 피연산자와 견줄 것
	var p, q pointer // \.{\\ifx} 검사에서 토큰 목록을 훑기 위해
	var saveScannerStatus smallNumber // 들어올 때의 |scannerStatus|
	var saveCondPtr pointer // 이 조건문에 해당하는 |condPtr|
	var thisIf smallNumber // 이 조건문의 종류
	@<조건 스택에 쌓는다@>
	saveCondPtr = condPtr
	thisIf = curChr
	@<\.{\\ifcase}를 처리하거나 |b|를 불 조건의 값으로 놓는다@>
	if tracingCommands() > 1 {
		@<|b|의 값을 보인다@>
	}
	if b {
		changeIfLimit(elseCode, saveCondPtr)
		return // \.{\\else}나 \.{\\fi}를 기다린다
	}
	@<\.{\\else}나 \.{\\fi}까지 건너뛰고 |goto commonEnding|@>
commonEnding:
	if curChr == fiCode {
		@<조건 스택에서...@>
	} else {
		ifLimit = fiCode // \.{\\fi}를 기다린다
	}
}

@ `\.{\\if\\iftrue abc\\else d\\fi}' 같은 것을 보자. 명령 \.{\\if}는 \.{\\iftrue}를 펼친 뒤 \.a와 \.b를 견주므로 거짓이다. 그런데
그 뒤에 처음 만나는 \.{\\else}는 \.{\\iftrue}의 것이지, 우리가 찾는 \.{\\if}의 \.{\\else}가 아니다. 그래서 다음의 기묘한
논리가 필요하다. 건너뛰다가 만난 \.{\\else}나 \.{\\fi}가 우리 조건문의 것인지는 |condPtr|가 처음 값으로 돌아와 있는지
보고 가린다.

@ 우리 조건문의 \.{\\else}나 \.{\\fi}에 이를 때까지 건너뛴다. 안쪽 수준의 \.{\\fi}이면 그 수준을 꺼내고 계속한다.
@<\.{\\else}나 \.{\\fi}까지...@>=
for {
	passText()
	if condPtr == saveCondPtr {
		if curChr != orCode {
			goto commonEnding
		}
		printErr("Extra ")
		printEsc("or")
@.Extra \\or@>
		help1("I'm ignoring this; it doesn't match any \\if.")
		reportError()
	} else if curChr == fiCode {
		@<조건 스택에서...@>
	}
}

@ 조건의 종류에 따라 |b|를 계산한다. 명령 \.{\\ifcase}는 따로 처리한다.
@<\.{\\ifcase}를 처리하거나...@>=
switch thisIf {
case ifCharCode, ifCatCode: @<두 문자가 맞는지 검사한다@>
case ifIntCode, ifDimCode: @<정수나 치수 사이의 관계를 검사한다@>
case ifOddCode: @<정수가 홀수인지 검사한다@>
case ifVmodeCode: b = (abs(mode) == vmode)
case ifHmodeCode: b = (abs(mode) == hmode)
case ifMmodeCode: b = (abs(mode) == mmode)
case ifInnerCode: b = (mode < 0)
case ifVoidCode, ifHboxCode, ifVboxCode: @<상자 레지스터의 상태를 검사한다@>
case ifxCode: @<두 토큰이 맞는지 검사한다@>
case ifEOFCode:
	scanFourBitInt()
	b = (readOpen[curVal] == closed)
case ifTrueCode: b = true
case ifFalseCode: b = false
case ifCaseCode: @<알맞은 경우를 고르고 |return|하거나 |goto commonEnding|@>
} // 다른 경우는 없다

@ 매개변수 \.{\\tracingcommands}가 1보다 크면 조건의 결과를 `\.{\{true\}}'나 `\.{\{false\}}'로 보여 준다.
@<|b|의 값을...@>=
beginDiagnostic()
if b {
	printStr("{true}")
} else {
	printStr("{false}")
}
endDiagnostic(false)

@ 명령 \.{\\ifnum}과 \.{\\ifdim}은 수 하나, 관계 기호 하나, 수 하나를 읽어 견준다. 관계 기호가 없으면 `\.='가 있는 것으로 본다.
여기서는 |"<"|, |"="|, |">"|가 잇달아 있는 {\mc ASCII} 코드라는 사실을 써먹는다.
@^ASCII code@>

@<정수나 치수 사이의...@>=
if thisIf == ifIntCode {
	scanInt()
} else {
	scanNormalDimen()
}
n = curVal
@<공백도 호출도 아닌...@>
if curTok >= otherToken+'<' && curTok <= otherToken+'>' {
	r = curTok - otherToken
} else {
	printErr("Missing = inserted for ")
@.Missing = inserted@>
	printCmdChr(ifTest, thisIf)
	help1("I was expecting to see `<', `=', or `>'. Didn't.")
	backError()
	r = '='
}
if thisIf == ifIntCode {
	scanInt()
} else {
	scanNormalDimen()
}
switch r {
case '<': b = (n < curVal)
case '=': b = (n == curVal)
case '>': b = (n > curVal)
}

@ @<정수가 홀수인지...@>=
scanInt()
b = odd(curVal)

@ 명령 \.{\\ifvoid}, \.{\\ifhbox}, \.{\\ifvbox}는 상자 레지스터를 살핀다. 빈 레지스터는 \.{\\ifhbox}에도 \.{\\ifvbox}에도 거짓이다.
@<상자 레지스터의 상태를...@>=
scanEightBitInt()
p = box(curVal)
if thisIf == ifVoidCode {
	b = (p == null)
} else if p == null {
	b = false
} else if thisIf == ifHboxCode {
	b = (typ(p) == hlistNode)
} else {
	b = (typ(p) == vlistNode)
}

@ 명령 \.{\\if}와 \.{\\ifcat}은 펼친 토큰 둘을 읽어 문자 코드나 catcode를 견준다. 문자가 아닌 토큰은 문자 코드 256, 범주
|relax|인 것으로 본다. 명령 \.{\\if\\noexpand}나 \.{\\ifcat\\noexpand} 뒤에서 능동 문자는 범주 13으로 다룬다. 여기서는
모든 제어 시퀀스 가운데 능동 문자의 토큰이 가장 작다는 사실을 써먹는다.

@<두 문자가 맞는지...@>=
getXTokenOrActiveChar()
if curCmd > activeChar || curChr > 255 { // 문자가 아니다
	m = relax
	n = 256
} else {
	m = curCmd
	n = curChr
}
getXTokenOrActiveChar()
if curCmd > activeChar || curChr > 255 {
	curCmd = relax
	curChr = 256
}
if thisIf == ifCharCode {
	b = (n == curChr)
} else {
	b = (m == curCmd)
}

@ 펼친 토큰을 하나 읽되, \.{\\noexpand}로 펼치지 않기로 한 능동 문자이면 그 능동 문자 자체로 되돌린다.
@<정의@>=
func getXTokenOrActiveChar() {
	getXToken()
	if curCmd == relax {
		if curChr == noExpandFlag {
			curCmd = activeChar
			curChr = curTok - csTokenFlag - activeBase
		}
	}
}

@ 명령 `\.{\\ifx}'는 펼치지 않은 토큰 둘을 견준다. 둘 다 매크로이면 그 정의의 텍스트까지 견주고, 아니면 명령 코드와
수정자를 견준다. 그러니 두 매크로의 텍스트가 같더라도 하나는 \ID{long}이나 \ID{outer}이고 다른 하나는 그렇지 않으면
다르다고 판정한다는 데 눈여겨보자. 명령 코드가 다르기 때문이다.

여기서는 \.{\\outer} 제어 시퀀스가 와도 되지만, 매크로 정의나 서문을 훑는 중일 수도 있으므로 나중에 |scannerStatus|를
되돌려 놓아야 한다.

@<두 토큰이 맞는지...@>=
saveScannerStatus = scannerStatus
scannerStatus = normal
getNext()
n = curCs
p = curCmd
q = curChr
getNext()
if curCmd != p {
	b = false
} else if curCmd < call {
	b = (curChr == q)
} else {
	@<두 매크로 텍스트가 맞는지 검사한다@>
}
scannerStatus = saveScannerStatus

@ 또 `\.{\\ifx}'는 다음과 같은 예에서 매크로 \.{\\a}와 \.{\\b}가 다르다고 판정한다는 데 눈여겨보자. 텍스트를 토큰 단위로
견줄 뿐, 그 안의 매크로를 펼쳐 보지는 않기 때문이다.
$$\vbox{\halign{\.{#}\hfil&\qquad\.{#}\hfil\cr
  {}\\def\\a\{\\c\}&
  {}\\def\\c\{\}\cr
  {}\\def\\b\{\\d\}&
  {}\\def\\d\{\}\cr}}$$

@<두 매크로 텍스트가...@>=
p = link(curChr)
q = link(equiv(n)) // 참조 횟수는 빼고
if p == q {
	b = true
} else {
	for p != null && q != null {
		if info(p) != info(q) {
			p = null
		} else {
			p = link(p)
			q = link(q)
		}
	}
	b = (p == null && q == null)
}

@ 명령 \.{\\ifcase}는 정수 $n$을 읽고 \.{\\or}를 $n$개 건너뛴다. 그보다 먼저 \.{\\else}나 \.{\\fi}를 만나면 거기서 멈춘다. 그래서
`\.{\\ifcase2 a\\or b\\or c\\else d\\fi}'는 \.c가 된다.
@<알맞은 경우를 고르고...@>=
scanInt()
n = curVal // |n|은 지나갈 경우의 수다
if tracingCommands() > 1 {
	beginDiagnostic()
	printStr("{case ")
	printInt(n)
	printChar('}')
	endDiagnostic(false)
}
for n != 0 {
	passText()
	if condPtr == saveCondPtr {
		if curChr == orCode {
			n--
		} else {
			goto commonEnding
		}
	} else if curChr == fiCode {
		@<조건 스택에서...@>
	}
}
changeIfLimit(orCode, saveCondPtr)
return // \.{\\or}나 \.{\\else}나 \.{\\fi}를 기다린다

@ 조건문의 처리는 다음 코드를 빼면 끝났다. 이 코드는 실은 |expand|의 일부인데, \.{\\or}나 \.{\\else}나 \.{\\fi}를 훑었을
때 실행한다. 이 명령을 펼칠 수 있다는 것은 조건이 참이었던 갈래를 다 읽었다는 뜻이다. 그러니 \.{\\fi}이면 그 수준을
끝내고, \.{\\else}나 \.{\\or}이면 \.{\\fi}까지 건너뛴다. 조건을 아직 계산하는 중이었으면 \.{\\relax}를 끼워 넣는다.

@<현재 조건문을 끝내고...@>=
if curChr > ifLimit {
	if ifLimit == ifCode {
		insertRelax() // 조건을 아직 계산하지 않았다
	} else {
		printErr("Extra ")
		printCmdChr(fiOrElse, curChr)
@.Extra \\or@>
@.Extra \\else@>
@.Extra \\fi@>
		help1("I'm ignoring this; it doesn't match any \\if.")
		reportError()
	}
} else {
	for curChr != fiCode {
		passText() // \.{\\fi}까지 건너뛴다
	}
	@<조건 스택에서...@>
}

@* 파일 이름.
이제 파일 이름 때문에 골치를 앓을 차례다. 운영체제마다 파일을 다르게 다룬다는 것만으로도 모자라, 사람들의
무리마다 전혀 다른 이름 짓기 관례를 쓴다는 것까지 감당해야 한다. 다음 프로그램들은 어느 한 운영체제에서
필요한 것을 보여 준다. 다른 시스템에 맞는 비슷한 루틴을 만드는 것은 어렵지 않다.
@^fingers@>
@^system dependencies@>

\TeX은 파일 이름이 세 부분, 곧 본이름과 ``확장자''와 바깥 파일 시스템에서 그 파일을 찾을 ``파일 영역''으로
이루어진다고 가정한다. 이를테면 \.{/home/knuth/paper.tex}이라면 영역은 \.{/home/knuth/}, 본이름은 \.{paper},
확장자는 \.{.tex}이다. 입력 파일이나 \.{\\write} 파일의 확장자는 따로 주지 않으면 `\.{.tex}'로 본다. \TeX이 실행될
때마다 남기는 기록 파일은 `\.{.log}', \TeX이 쓰는 글꼴의 문자들을 기술하는 글꼴 계량 파일은 `\.{.tfm}', 조판
결과를 담은 출력 파일은 `\.{.dvi}', \.{INITEX}가 \TeX을 초기화하려고 쓰는 포맷 파일은 `\.{.fmt}'다. 입력 파일의
영역은 무엇이든 될 수 있지만, 출력 파일은 대개 사용자의 현재 영역에 쓴다. 입력 파일을 지정한 영역에서 찾을 수
없으면 \TeX은 특별한 시스템 영역에서 찾는다. 이 특별한 영역은 \.{webmac.tex}처럼 흔히 쓰는 입력 파일을 두는
곳이다.

\TeX을 간단하게 쓸 때는 확장자나 영역을 밝히지 않은 파일 이름만 쓴다. 이를테면 사람들은 대개
`\.{\\input} \.{paper.new}'나 `\.{\\font\\tenrm} \.= \.{<csd.knuth>test}' 대신 `\.{\\input} \.{paper}'나
`\.{\\font\\tenrm} \.= \.{helvetica}'라고 한다. 간단한 파일 이름이 가장 좋다. 그래야 \TeX\ 원본 파일을 다른
시스템으로 옮겨 갈 수 있다. 파일 이름이 글자와 숫자로만 이루어져 있으면 \TeX의 모든 구현이 그것을 똑같이
다루어야 한다. 그러나 사용자는 자기 환경의 다른 파일들도 가리킬 수 있어야 한다. 특히 열 수 없는 파일에 관한 오류
메시지에 대답할 때 그렇다. 그래서 사용자가 익숙한 운영체제의 문법을 그대로 쓸 수 있게 해 주고 싶다.

다음 프로시저들은 공백이 파일 이름의 일부가 되는 것을 허락하지 않는다. 공백은 파일 이름의 끝을 나타낸다.
그러나 어떤 사용자들은 띄어 쓴 이름을 좋아하는 것 같다. 그런 것을 허락하도록 시스템에 맞게 고친다면 마지못해서만,
그리고 공백이 든 파일 이름 전체를 어떤 식으로든 ``따옴표로 묶을'' 때에만 그렇게 해야 할 것이다.

@ 파일 이름에서 시스템에 따라 달라지는 면을 따로 떼어 내려고, \TeX의 시스템 독립 부분은 |beginName|, |moreName|,
@^system dependencies@>
|endName|이라는 시스템 의존 프로시저 셋만으로 파일 이름을 다룬다. 요컨대 사용자가 준 파일 이름의 문자들이
$c_1\ldots c_n$이면, 시스템 독립 쪽은 다음 연산들을 차례로 한다.
$$|beginName|;\,|moreName|(c_1);\,\ldots\,;\,|moreName|(c_n);\,|endName|.$$
이 세 프로시저는 전역 변수로 정보를 주고받는다. 이 일이 끝나면 파일 이름은 문자열 풀에
|curName|\penalty10000\hskip-.05em, |curArea|, |curExt|라는 세 문자열로 들어 있다. 뒤의 둘은 사용자가 명시적으로 주지
않는 한 널(곧 |""|)이다.

실제 상황은 이보다 조금 더 복잡하다. \TeX은 파일 이름이 어디서 끝나는지도 알아야 하기 때문이다. 루틴
|moreName|은 (부수 효과가 있는) 함수로, 호출 |moreName|$(c_1)$, \dots, |moreName|$(c_{n-1})$에서는 |true|를 돌려준다.
마지막 호출 |moreName|$(c_n)$은 |false|를 돌려주거나, |true|를 돌려주되 $c_n$ 다음 토큰이 `\.{\\hbox}' 같은 것(곧
문자가 아닌 것)이다. 다시 말해 |moreName|은 파일 이름을 다 읽었다고 확신하지 않는 한 |true|를 돌려주어야 하고,
|endName|은 $|moreName|(c_n)$이 무엇을 돌려주었든 |curName|, |curArea|, |curExt|를 다 조립할 수 있어야 한다.

@<전역 변수@>=
var @!curName strNumber // 방금 훑은 파일의 이름
var @!curArea strNumber // 방금 훑은 파일 영역, 또는 \.{""}
var @!curExt strNumber // 방금 훑은 파일 확장자, 또는 \.{""}

@ 여기서 예로 다루는 파일 이름은 다음과 같이 생겼다. 이름에 `\.>'나 `\.:'가 들어 있으면, 그런 문자 가운데 마지막 것까지(그
문자도 포함해서)가 파일 영역이다. 그렇지 않으면 파일 영역은 널이다. 나머지 부분에 `\..'가 들어 있으면 남은 부분의 첫
`\..'부터 끝까지가 파일 확장자이고, 그렇지 않으면 확장자는 널이다.
@^system dependencies@>

영역 구분자와 확장자 구분자가 어디에 나왔는지 기억해 두는 전역 변수 둘을 쓰면 이런 파일 이름을 쉽게 훑을 수 있다.

유닉스 계열의 시스템에서는 `\./'가 디렉터리를 가르므로, |moreName|은 `\.>'와 `\.:'에 더해 `\./'도 영역 구분자로
알아본다. 이를테면 `\.{\\input ../d.v2/paper}'에서 영역은 `\.{../d.v2/}', 이름은 `\.{paper}', 확장자는 널이 되므로
`\.{.tex}'가 붙고, 작업 이름은 `\.{paper}'가 된다. `\./'를 보통 문자로 다룬다면 이름 첫머리의 `\..'이 확장자의
시작으로 읽혀서, 이름은 비고 확장자가 `\.{../d.v2/paper}' 전체가 될 것이다. 그러면 이것이 첫 \.{\\input}일 때 작업
이름이 비어서 기록 파일 이름이 `\.{.log}'가 되고 만다.

@<전역 변수@>=
var @!areaDelimiter poolPointer // 가장 최근의 `\.>'나 `\.:'나 `\./', 있다면
var @!extDelimiter poolPointer // 관련된 `\..', 있다면

@ \seclabel{tex-area}사용자의 영역에서 찾을 수 없는 입력 파일은 |texArea|라는 표준 시스템 영역에 있을 수 있다. 영역을
밝히지 않은 글꼴 계량 파일은 |texFontArea|라는 표준 시스템 영역에 있다고 본다. 물론 이런 시스템 영역의 이름은
설치처마다 다를 것이다.
@^system dependencies@>

이 둘은 풀 문자열의 번호를 담은 꾸러미 변수다. \GO/는 꾸러미 변수를 초기화할 때 |poolLiterals|를 먼저 초기화하므로
여기서 |str|을 불러도 된다. 이 영역 이름들이 실제로 어디를 가리키는지는 함수 |externalName|이 정한다(\secref{external-name}).

@<전역 변수@>=
var texArea = str("TeXinputs:")
@.TeXinputs@>
var texFontArea = str("TeXfonts:")
@.TeXfonts@>

@ 다음은 파일 이름 훑기를 위한 시스템 의존 루틴 가운데 첫째다. 구분자의 위치를 지운다.
@^system dependencies@>

@<함수들@>=
func beginName() {
	areaDelimiter = 0
	extDelimiter = 0
}

@ 그리고 다음은 둘째다. 문자를 현재 문자열에 덧붙이면서 구분자의 위치를 기억한다. 공백을 만나면 이름이 끝난
것이다. 파일 이름을 훑는 동안 새 \.{\\csname}이 들어올 수도 있으므로 문자열 풀이 바뀔 수 있다. 그래서
|areaDelimiter|와 |extDelimiter|에는 |poolPtr| 같은 절대 주소를 넣지 않고, 현재 문자열의 처음에서 잰 상대 위치를
넣는다.
@^system dependencies@>

@<함수들@>=
func moreName(c asciiCode) bool {
	if c == ' ' {
		return false
	}
	strRoom(1)
	appendChar(c) // |c|를 현재 문자열에 보탠다
	if c == '>' || c == ':' || c == '/' {
		areaDelimiter = curLength()
		extDelimiter = 0
	} else if c == '.' && extDelimiter == 0 {
		extDelimiter = curLength()
	}
	return true
}

@ 셋째다. 현재 문자열을 구분자 위치에서 잘라 영역, 이름, 확장자의 세 문자열로 만든다. 문자열을 따로 복사하지 않고
|strStart|에 경계만 적어 넣는다는 데 눈여겨보자.
@^system dependencies@>

@<함수들@>=
func endName() {
	if strPtr+3 > maxStrings {
		overflow("number of strings", maxStrings-initStrPtr)
	}
@:TeX capacity exceeded number of strings}{\quad number of strings@>
	if areaDelimiter == 0 {
		curArea = str("")
	} else {
		curArea = strPtr
		strStart[strPtr+1] = strStart[strPtr] + areaDelimiter
		strPtr++
	}
	if extDelimiter == 0 {
		curExt = str("")
		curName = makeString()
	} else {
		curName = strPtr
		strStart[strPtr+1] = strStart[strPtr] + extDelimiter - areaDelimiter - 1
		strPtr++
		curExt = makeString()
	}
}

@ 거꾸로, 다음은 세 문자열을 받아서 그것들을 만들어 냈을 법한 파일 이름을 찍는 루틴이다. (어떤 운영체제는 파일
영역을 앞이 아니라 뒤에 두므로 이 루틴은 시스템에 따라 다르다.)
@^system dependencies@>

@<기본 인쇄...@>=
func printFileName(n, a, e int32) {
	slowPrint(a)
	slowPrint(n)
	slowPrint(e)
}

@ \TeX의 내부 문자열 셋을 파일을 열 때 쓰는 |nameOfFile| 값으로 바꾸는 시스템 의존 루틴도 하나 필요하다. 지금의
코드는 파일 이름에 소문자와 대문자를 모두 받아들인다. 영역, 이름, 확장자를 차례로 잇고, |fileNameSize|를 넘는
부분은 버린다.
@^system dependencies@>

작은 함수 |appendToName|은 부르는 쪽의 계수기 |k|를 하나 늘리고 문자 |c|를 |nameOfFile[k]|에 넣는다. 다음 절의
|packBufferedName|에서도 쓰므로 계수기는 포인터로 받는다.

@<함수들@>=
func appendToName(k *int32, c asciiCode) {
	*k++
	if *k <= fileNameSize {
		nameOfFile[*k] = xchr[c]
	}
}

func packFileName(n, a, e strNumber) {
	var k int32 // |nameOfFile|에서 채운 위치의 수
	var j poolPointer // |strPool|의 첨자
	k = 0
	for j = strStart[a]; j <= strStart[a+1]-1; j++ {
		appendToName(&k, so(strPool[j]))
	}
	for j = strStart[n]; j <= strStart[n+1]-1; j++ {
		appendToName(&k, so(strPool[j]))
	}
	for j = strStart[e]; j <= strStart[e+1]-1; j++ {
		appendToName(&k, so(strPool[j]))
	}
	nameLength = min(k, fileNameSize)
	for k = nameLength + 1; k <= fileNameSize; k++ {
		nameOfFile[k] = ' '
	}
}

@ 더 지저분한 루틴도 필요하다. 포맷 파일의 이름은 \TeX의 문자열 장치가 준비되기 전에 읽어야 하기 때문이다. 포맷
파일의 기본 시스템 영역과 확장자는 전역 변수 |texFormatDefault|의 텍스트로 준다.
@^system dependencies@>

@<전역 변수@>=
const (
	@!formatDefaultLength = 20 // 문자열 |texFormatDefault|의 길이
	@!formatAreaLength = 11 // 그 영역 부분의 길이
	@!formatExtLength = 4 // 그 `\.{.fmt}' 부분의 길이
)

var formatExtension = str(".fmt") // 확장자, 풀 문자열로서

var @!texFormatDefault [formatDefaultLength + 1]textChar

@ 기본 포맷 파일은 `\.{TeXformats:plain.fmt}'다. 앞의 11글자가 영역이고 마지막 4글자가 확장자다.
@<핵심 변수들의...@>=
copy(texFormatDefault[1:], "TeXformats:plain.fmt")
@.TeXformats@>
@.plain@>
@^system dependencies@>

@ @<``상수'' 값들이 서로 맞는지 검사한다@>=
if formatDefaultLength > fileNameSize {
	bad = 31
}

@ 다음은 방금 말한 지저분한 루틴이다. 이 루틴은 |nameOfFile|을 |texFormatDefault|의 처음 |n|글자, |buffer[a..b]|,
|texFormatDefault|의 마지막 |formatExtLength|글자를 차례로 이은 것으로 놓는다. 이를테면 사용자가 `\.{\&plain}'을 쳤고
|n=11|이면 `\.{TeXformats:plain.fmt}'가 된다.

\TeX은 |reportError| 루틴이 움직일 준비가 되기 전에 이 루틴을 부르므로, 여기서는 감히 오류 메시지를 낼 수 없다. 그
대신 넘치는 문자들은 그냥 버린다. 그 때문에 이상한 파일 이름이 되어 파일을 찾지 못한다면, 오류는 다른 방법으로
드러날 것이다.
@^system dependencies@>

@<함수들@>=
func packBufferedName(n smallNumber, a, b int32) {
	var k int32 // |nameOfFile|에서 채운 위치의 수
	var j int32 // |buffer|나 |texFormatDefault|의 첨자
	if n+b-a+1+formatExtLength > fileNameSize {
		b = a + fileNameSize - n - 1 - formatExtLength
	}
	k = 0
	for j = 1; j <= n; j++ {
		appendToName(&k, xord[texFormatDefault[j]])
	}
	for j = a; j <= b; j++ {
		appendToName(&k, buffer[j])
	}
	for j = formatDefaultLength - formatExtLength + 1; j <= formatDefaultLength; j++ {
		appendToName(&k, xord[texFormatDefault[j]])
	}
	nameLength = min(k, fileNameSize)
	for k = nameLength + 1; k <= fileNameSize; k++ {
		nameOfFile[k] = ' '
	}
}

@ \seclabel{format-default}다음은 |packBufferedName|을 쓰는 유일한 곳이다. 프로그램의 이 부분은 ``처녀'' \TeX이 예비
초기화를 막 마치고 움직이기 시작하려 할 때 실행한다. 사용자가 처음의 `\.{**}' 재촉 기호 뒤에 `\.\&'로 시작하는 이름을
쳐서 다른 포맷 파일을 고를 수 있다. 이를테면 `\.{\&plain story}'는 포맷 \.{plain}을 읽은 뒤 \.{story}를 입력한다. 버퍼의
|buffer[loc..(last-1)]|에는 입력의 첫 줄이 들어 있고, |loc<last|이며 |buffer[loc]!=" "|다. 포맷 이름은 먼저 영역 없이
찾아보고, 없으면 시스템 영역에서 찾는다. `\.\&'가 없으면 기본 포맷 파일을 연다.

@<|openFmtFile|이라는 함수를 선언한다@>=
func openFmtFile() bool {
	var j int32 // 포맷 파일 이름 뒤의 첫 공백; |0 .. bufSize|
	j = loc
	if buffer[loc] == '&' {
		loc++
		j = loc
		buffer[last] = ' '
		for buffer[j] != ' ' {
			j++
		}
		packBufferedName(0, loc, j-1) // 먼저 시스템 파일 영역 없이 해 본다
		if wOpenIn(&fmtFile) {
			goto found
		}
		packBufferedName(formatAreaLength, loc, j-1)
		// 이제 시스템 포맷 파일 영역을 해 본다
		if wOpenIn(&fmtFile) {
			goto found
		}
		wakeUpTerminal()
		wtermLn("Sorry, I can't find that format;", " will try PLAIN.")
@.Sorry, I can't find...@>
		updateTerminal()
	}
	// 이제 모든 수단을 써 본다: 시스템의 \.{plain} 파일을 찾는다
	packBufferedName(formatDefaultLength-formatExtLength, 1, 0)
	if !wOpenIn(&fmtFile) {
		wakeUpTerminal()
		wtermLn("I can't find the PLAIN format file!")
@.I can't find PLAIN...@>
@.plain@>
		return false
	}
found:
	loc = j
	return true
}

@ 운영체제는 흔히 열린 파일의 정확한 이름(과 판 번호)을 알려 줄 수 있다. 다음 루틴은 그저 |nameOfFile|의 값으로
\TeX\ 문자열을 만들지만, 될 수 있으면 가장 최근에 연 파일~|f|의 온전한 이름을 알아내는 것이 좋다. 이 이름은 오류
메시지에서 파일을 가리킬 때나 \.{DVI} 파일의 이름을 알릴 때 쓴다.
@^system dependencies@>

이 루틴은 문자열 메모리가 넘친 뒤에 불릴 수도 있으므로 감히 `|strRoom|'을 쓸 수 없다. 자리가 없으면 그냥
`\.?'를 돌려준다.

\GO/에서는 열린 파일의 실제 경로를 |f.f.Name()|으로 알 수 있다. 그래서 다음 절의 |aMakeNameString| 따위는 그 경로를
|nameOfFile|에 넣은 뒤 |makeNameString|을 부른다. 이를테면 \TeX이 `\.{TeXinputs:}' 영역에서 찾은 파일의 이름은 그 파일의
실제 경로로 찍힌다.

@<함수들@>=
func makeNameString() strNumber {
	var k int32 // |nameOfFile|의 첨자; |1 .. fileNameSize|
	if poolPtr+nameLength > poolSize || strPtr == maxStrings ||
		curLength() > 0 {
		return '?'
	} else {
		for k = 1; k <= nameLength; k++ {
			appendChar(xord[nameOfFile[k]])
		}
		return makeString()
	}
}

@ 열린 파일의 실제 경로로 이름 문자열을 만드는 함수들이다. 경로가 너무 길면 |nameOfFile|을 그대로 둔다.

@<함수들@>=
func setNameOfFile(nm string) { // 열린 파일의 실제 경로를 |nameOfFile|에 넣는다
	if len(nm) > fileNameSize {
		return
	}
	nameLength = int32(copy(nameOfFile[1:], nm))
}

func aMakeNameString(f *alphaFile) strNumber {
	if f.f != nil {
		setNameOfFile(f.f.Name())
	}
	return makeNameString()
}

func bMakeNameString(f *byteFile) strNumber {
	if f.f != nil {
		setNameOfFile(f.f.Name())
	}
	return makeNameString()
}

func wMakeNameString(f *wordFile) strNumber {
	if f.f != nil {
		setNameOfFile(f.f.Name())
	}
	return makeNameString()
}

@ 이제 \TeX이 시스템과 상관없는 방식으로 파일 이름을 다루는 ``구동'' 루틴들을 살펴보자. 먼저 |getXToken|으로 토큰을
읽으면서 입력에서 파일 이름을 찾는 프로시저가 온다. 앞의 공백은 건너뛰고, 문자가 아닌 토큰이나 공백이 나오면
이름이 끝난다. 펼치며 읽으므로 \.{\\input\\jobname.aux} 같은 것도 된다.

@<함수들@>=
func scanFileName() {
	nameInProgress = true
	beginName()
	@<공백도 호출도 아닌...@>
	for {
		if curCmd > otherChar || curChr > 255 { // 문자가 아니다
			backInput()
			goto done
		}
		if !moreName(curChr) {
			goto done
		}
		getXToken()
	}
done:
	endName()
	nameInProgress = false
}

@ 전역 변수 |nameInProgress|는 |scanFileName|을 재귀적으로 쓰지 못하게 막는다. 프로시저 |beginName|과 그 짝들이 전역
변수로 정보를 주고받기 때문이다. 재귀는 `\.{\\input\\input f}' 같은 엉큼한 술수로만 일어날 텐데, 그런 방해 공작은
막아야 한다. 게다가 |nameInProgress|는 글꼴 크기 지정을 훑는 동안 \.{\\input}이 시작되지 못하게도 한다.
@^recursion@>

또 하나의 전역 변수 |jobName|에는 사용자가 처음 \.{\\input}한 파일의 이름이 들어 있다. \TeX의 출력 파일 이름은 이
이름에 `\.{.log}', `\.{.dvi}', `\.{.fmt}'를 붙여 만든다.

@<전역 변수@>=
var @!nameInProgress bool // 파일 이름을 훑고 있나?
var @!jobName strNumber // 주 파일 이름
var @!logOpened bool // 기록 파일을 열었나?

@ 처음에는 |jobName=0|이다. 작업 이름을 알게 되는 즉시 0이 아니게 된다. `\.{log}' 파일을 아직 열지 않았을 때, 그리고
오직 그때에만 |jobName=0|이다. 물론 |jobName|이 0이 아니게 된 직후의 짧은 순간은 빼고 말이다.

@<출력 루틴들을...@>=
jobName = 0
nameInProgress = false
logOpened = false

@ 다음은 |jobName!=0|이라고 가정하고 출력 파일 이름을 만드는 루틴이다. 이 루틴은 |curArea|와 |curExt|의 현재 값을
무시하고 바꾸어 버린다.

@<함수들@>=
func packCurName() { packFileName(curName, curArea, curExt) }

func packJobName(s strNumber) { // |s = ".log"|, |".dvi"|, 또는 |formatExtension|
	curArea = str("")
	curExt = s
	curName = jobName
	packCurName()
}

@ \TeX이 파일을 열려다가 무언가 말썽이 생기면, 다음 루틴이 사용자에게 다른 파일 이름을 대라고 청한다. 매개변수~|s|는
오류 메시지에서 파일의 종류를 밝히는 데 쓰고, 매개변수~|e|는 확장자를 주지 않았을 때의 기본 확장자다. 이 루틴에서
나올 때 변수 |curName|, |curArea|, |curExt|, |nameOfFile|은 파일 열기를 다시 시도할 준비가 되어 있다. 사용자와
대화할 수 없는 모드라면 물어볼 수 없으므로 치명적인 오류로 끝낸다.

매개변수 |s|와 |e|는 언제나 문자열 상수이므로 \GO/ 문자열로 받는다. 그리고 |e|를 |curExt|에 넣을 때에만 |str|로 풀
문자열의 번호를 얻는다.

@<함수들@>=
func promptFileName(s, e string) {
	var k int32 // |buffer|의 첨자; |0 .. bufSize|
	if interaction == scrollMode {
		wakeUpTerminal()
	}
	if s == "input file name" {
		printErr("I can't find file `")
@.I can't find file x@>
	} else {
		printErr("I can't write on file `")
	}
@.I can't write on file x@>
	printFileName(curName, curArea, curExt)
	printStr("'.")
	if e == ".tex" {
		showContext()
	}
	printNl("Please type another ")
	printStr(s)
@.Please type...@>
	if interaction < scrollMode {
		fatalError("*** (job aborted, file error in nonstop mode)")
	}
@.job aborted, file error...@>
	clearTerminal()
	promptInput(": ")
	@<버퍼에서 파일 이름을 훑는다@>
	if curExt == str("") {
		curExt = str(e)
	}
	packCurName()
}

@ 사용자가 친 줄에서 파일 이름을 읽는다. 앞의 공백은 건너뛰고, 공백이 나오면 이름이 끝난다. 확장자가 없으면 기본
확장자를 붙인다.
@<버퍼에서 파일 이름을...@>=
beginName()
k = first
for buffer[k] == ' ' && k < last {
	k++
}
for {
	if k == last {
		goto done
	}
	if !moreName(buffer[k]) {
		goto done
	}
	k++
}
done:
endName()

@ 다음은 이 관례들을 쓰는 한 예다. 상자를 내보낼 때마다 함수 |ensureDVIOpen|을 부른다. \.{DVI} 파일이 아직 열리지
않았으면 작업 이름에 `\.{.dvi}'를 붙여 열고, 열 수 없으면 사용자에게 다른 이름을 묻는다. 그러니 \.{DVI} 파일은 첫
쪽을 내보낼 때에야 생긴다.

@<전역 변수@>=
func ensureDVIOpen() {
	if outputFileName == 0 {
		if jobName == 0 {
			openLogFile()
		}
		packJobName(str(".dvi"))
		for !bOpenOut(&dviFile) {
			promptFileName("file name for output", ".dvi")
		}
		outputFileName = bMakeNameString(&dviFile)
	}
}

var @!dviFile byteFile // 장치 독립 출력이 여기로 간다
var @!outputFileName strNumber // 출력 파일의 온전한 이름
var @!logName strNumber // 기록 파일의 온전한 이름

@ @<출력 루틴들을...@>=
outputFileName = 0

@ 루틴 |openLogFile|은 기록 파일을 열고, 그동안 터미널에만 찍힌 것을 기록 파일이 따라잡게 한다. 작업 이름이 아직
없으면 `\.{texput}'으로 한다. 기록 파일의 첫 줄에는 판 번호와 포맷, 날짜와 시각을 적고, 둘째 줄에는 입력의 첫 줄을
적는다.

@<함수들@>=
func openLogFile() {
	var k int32 // |months|와 |buffer|의 첨자; |0 .. bufSize|
	var l int32 // 첫 입력 줄의 끝; |0 .. bufSize|
	var months string // 달 이름의 약어들
	oldSetting := selector // 앞의 |selector| 설정; |0 .. maxSelector|
	if jobName == 0 {
		jobName = str("texput")
	}
@.texput@>
	packJobName(str(".log"))
	for !aOpenOut(&logFile) {
		@<다른 기록 파일 이름을 얻어 본다@>
	}
	logName = aMakeNameString(&logFile)
	selector = logOnly
	logOpened = true
	@<날짜와 시각을 포함해서 머리줄을 찍는다@>
	inputStack[inputPtr] = curInput() // 맨 아래 수준이 메모리에 있도록 한다
	printNl("**")
@.**@>
	l = inputStack[0].limitField // 첫 줄의 마지막 위치
	if buffer[l] == endLineChar() {
		l--
	}
	for k = 1; k <= l; k++ {
		printStr(buffer[k])
	}
	printLn() // 이제 기록 파일에 입력의 첫 줄이 들어 있다
	selector = oldSetting + 2 // |logOnly|나 |termAndLog|
}

@ 루틴 |openLogFile|은 \TeX이 오류 메시지를 찍을 수 없거나 |showContext|조차 할 수 없는 곤란한 때에 불리기도 한다. 루틴
|promptFileName|이 |fatalError|를 일으킬 수는 있지만, 그때 |logOpened|가 거짓이므로 |reportError| 루틴은 불리지 않는다.

모드 |batchMode|의 기본 취지는 터미널에 아무것도 쓰지 않는 것이다. 그러나 기록 파일을 하나도 열 수 없는 드문
경우에는 예외로 설명 메시지가 보이게 한다.

덧붙이자면, 이 프로그램은 기록 파일을 언제나 `\.{transcript file}'이라고 부른다. 어떤 시스템에서는 이 파일에 확장자
`\.{.log}'를 쓸 수 없기 때문이다.

@<다른 기록 파일 이름을...@>=
selector = termOnly
promptFileName("transcript file name", ".log")

@ 기록 파일의 첫 줄은 `\.{This is TeX, ... (preloaded format=plain 1776.7.4)  4 JUL 1776 12:00}' 같은 꼴이다. 달
이름은 문자열 |months|에서 세 글자씩 꺼낸다. 이 문자열의 첨자는 0부터 세므로 1을 뺀다.

@<날짜와 시각을 포함해서...@>=
wlog(banner)
slowPrint(formatIdent)
printStr("  ")
printInt(sysDay)
printChar(' ')
months = "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
for k = 3*sysMonth - 2; k <= 3*sysMonth; k++ {
	wlog(months[k-1])
}
printChar(' ')
printInt(sysYear)
printChar(' ')
printTwo(sysTime / 60)
printChar(':')
printTwo(sysTime % 60)

@ 이제 `\.{\\input}' 명령을 처리할 때 파일 읽기를 시작하는 프로시저로 넘어가자. 파일 이름을 읽고, 확장자가 없으면
`\.{.tex}'를 붙여 파일을 연다. 이것이 첫 \.{\\input}이면 작업 이름이 정해지고 기록 파일이 열린다. 터미널에는
`\.{(paper.tex}'처럼 왼쪽 괄호와 파일 이름을 찍고, 파일을 다 읽으면 오른쪽 괄호를 찍는다. 조심하라. 역사적인 까닭으로
이 코드는 어리석게도 문자열 풀 공간을 아주 조금 아끼는데, 그것이 대화식 `\.E' 선택지를 헷갈리게 할 수 있다.
@^system dependencies@>

@<함수들@>=
func startInput() { // \TeX이 무언가를 \.{\\input}할 것이다
	scanFileName() // |curName|을 원하는 파일 이름으로 놓는다
	if curExt == str("") {
		curExt = str(".tex")
	}
	packCurName()
	@<입력 파일을 열 수 있을 때까지 해 보고 |goto done|@>
done:
	name = aMakeNameString(curFile())
	if jobName == 0 {
		jobName = curName
		openLogFile()
	} // |openLogFile|은 |showContext|를 하지 않으므로 |limit|와 |loc|은
	@t\qquad@>// 아직 뜻 있는 값으로 정하지 않아도 된다
	if termOffset+length(name) > maxPrintLine-2 {
		printLn()
	} else if termOffset > 0 || fileOffset > 0 {
		printChar(' ')
	}
	printChar('(')
	openParens++
	slowPrint(name)
	updateTerminal()
	state = newLine
	if name == strPtr-1 { // 문자열 풀 공간을 아낀다(그러나 위의 주의를 보라)
		flushString()
		name = curName
	}
	@<새 파일의 첫 줄을 읽는다@>
}

@ 앞 절에서 파일을 여는 루프다. 지정한 영역에서 열지 못하고 영역을 따로 주지 않았으면 시스템 영역 |texArea|에서
찾아본다. 그래도 열지 못하면 사용자에게 다른 이름을 묻는다.

@<입력 파일을 열 수 있을 때까지...@>=
for {
	beginFileReading() // |curFile|과 입력의 새 수준을 마련한다
	if aOpenIn(curFile()) {
		goto done
	}
	if curArea == str("") {
		packFileName(curName, texArea, curExt)
		if aOpenIn(curFile()) {
			goto done
		}
	}
	endFileReading() // 쓸모없었던 수준을 없앤다
	promptFileName("input file name", ".tex")
}

@ 새 파일의 첫 줄을 읽는다. 첫 줄이므로 |inputLn|의 |bypassEoln|을 |false|로 준다. 파일이 비어 있으면 빈 줄 하나가 들어
있는 것으로 본다.
@^system dependencies@>
@^empty line at end of file@>

@<새 파일의 첫 줄을...@>=
line = 1
if inputLn(curFile(), false) {
	// 아무것도 하지 않는다
}
firmUpTheLine()
if endLineCharInactive() {
	limit--
} else {
	buffer[limit] = endLineChar()
}
first = limit + 1
loc = start

@* 글꼴 계량 자료.
\TeX은 글꼴에 관한 지식을 글꼴 계량 파일, 곧 \.{TFM} 파일에서 얻는다. `\.{TFM}'의 `\.T'는 \TeX을 뜻하지만, 이 파일을
@^TFM files@>
@^font metric files@>
아는 프로그램은 \TeX 말고도 여럿 있다. \TeX은 글자의 모양은 전혀 모른다. 글자마다 너비, 높이, 깊이, 기울임 보정,
그리고 어떤 글자 쌍이 합자나 커닝을 이루는지만 알면 조판할 수 있고, 그 정보가 \.{TFM} 파일에 들어 있다. 실제
모양은 나중에 \.{DVI} 파일을 인쇄하는 프로그램이 따로 가져온다.

\.{TFM} 파일의 정보는 8비트 바이트의 나열이다. 바이트 수는 언제나 4의 배수이므로 파일을 32비트 낱말의 나열로 볼 수도
있지만, \TeX은 바이트 단위로 읽는다. \.{TFM} 파일의 형식은 라일 램쇼가 1980년에 설계했다. 여러 가지 정보를 간결하면서도
@^Ramshaw, Lyle Harold@>
쓰기 좋은 꼴로 담으려는 것이었다.

@<전역 변수@>=
var @!tfmFile byteFile

@ \seclabel{tfm-sizes}\.{TFM} 파일의 처음 24바이트(6낱말)에는 뒤따르는 여러 부분의 길이를 알려 주는 16비트 정수 열두 개가 들어 있다. 이
열두 정수는 차례로 다음과 같다.
$$\vbox{\halign{\hfil#&$\null=\null$#\hfil\cr
|lf|&파일 전체의 길이, 낱말 단위;\cr
|lh|&머리 자료의 길이, 낱말 단위;\cr
|bc|&글꼴에서 가장 작은 문자 코드;\cr
|ec|&글꼴에서 가장 큰 문자 코드;\cr
|nw|&너비 표의 낱말 수;\cr
|nh|&높이 표의 낱말 수;\cr
|nd|&깊이 표의 낱말 수;\cr
|ni|&기울임 보정 표의 낱말 수;\cr
|nl|&합자/커닝 표의 낱말 수;\cr
|nk|&커닝 표의 낱말 수;\cr
|ne|&늘일 수 있는 문자 표의 낱말 수;\cr
|np|&글꼴 매개변수 낱말의 수.\cr}}$$
이 값들은 모두 음이 아니고 $2^{15}$보다 작다. 또 |bc-1<=ec<=255|여야 하고
$$\hbox{|lf=6+lh+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+np|}$$
여야 한다. 글꼴에는 문자가 256개까지(|bc=0|이고 |ec=255|이면) 들어 있을 수도 있고, 하나도(|bc=ec+1|이면) 없을 수도
있다는 데 눈여겨보자.

덧붙이자면, 8비트 바이트 둘 이상을 합쳐 16비트 이상의 정수를 만들 때는 가장 높은 자리의 바이트가 파일에서 먼저 나온다.
이것을 빅엔디언(BigEndian) 순서라고 한다.
@!@^BigEndian order@>

@ \.{TFM} 파일의 나머지는 대강 다음과 같은 자료 배열 열 개를 차례로 이어 놓은 것이다.
$$\vbox{\halign{\hfil#&$\,:\,$#\hfil\cr
\ID{header}$[0\to\ID{lh}-1]$&\ID{stuff}\cr
\ID{charInfo}$[\ID{bc}\to\ID{ec}]$&|charInfoWord|\cr
\ID{width}$[0\to\ID{nw}-1]$&|fixWord|\cr
\ID{height}$[0\to\ID{nh}-1]$&|fixWord|\cr
\ID{depth}$[0\to\ID{nd}-1]$&|fixWord|\cr
\ID{italic}$[0\to\ID{ni}-1]$&|fixWord|\cr
\ID{ligKern}$[0\to\ID{nl}-1]$&|ligKernCommand|\cr
\ID{kern}$[0\to\ID{nk}-1]$&|fixWord|\cr
\ID{exten}$[0\to\ID{ne}-1]$&|extensibleRecipe|\cr
\ID{param}$[1\to\ID{np}]$&|fixWord|\cr}}$$
여기서 가장 중요한 자료형은 |@!fixWord|다. 이것은 이진 분수를 32비트로 나타낸 것으로, 부호가 있는 양이며 음수는
낱말 전체의 2의 보수로 나타낸다. 32비트 가운데 정확히 12비트가 이진 소수점의 왼쪽에 있다. 그러므로 가장 큰
|fixWord| 값은 $2048-2^{-20}$이고 가장 작은 값은 $-2048$이다. 그러나 아래에서 보겠지만, 두 가지를 빼면 |fixWord| 값은
모두 $-16$과 $+16$ 사이에 있어야 한다.

@ 첫 자료 배열은 글꼴에 관한 일반적인 사실을 담은 머리 정보 덩어리다. 머리에는 적어도 두 낱말 |header[0]|과
|header[1]|이 있어야 하는데, 그 뜻은 아래에서 설명한다. 다른 소프트웨어에 쓸모 있는 머리 정보가 더 들어 있을 수도
있지만, \TeX82는 그런 것까지 알 필요가 없다. 이를테면 제록스 팰로앨토 연구소에서는 머리 정보를 16낱말 더 쓴다. 처음
열 낱말에는 문자 코드 체계(이를테면 `\.{XEROX text}'나 `\.{TeX math symbols}')를, 다음 다섯 낱말에는 글꼴
식별자(이를테면 `\.{HELVETICA}'나 `\.{CMSY}')를, 마지막 낱말에는 ``얼굴 바이트''를 적는다. \.{DVI} 파일을 제록스
인쇄 형식으로 바꾸는 프로그램은 이 정보를 \.{TFM} 파일에서 얻는다. 그 프로그램은 \.{DVI}~형식에 따로 적혀 있지
않은 다른 정보 때문에 어차피 그 파일을 읽어야 한다.

\yskip\hang|header[0]|은 32비트 검사합으로, \TeX은 이것을 \.{DVI} 출력 파일에 베껴 넣는다. 나중에 \.{DVI} 파일을 (어쩌면
다른 컴퓨터에서) 인쇄할 때 실제로 쓰는 글꼴의 검사합은 \TeX이 읽은 \.{TFM} 파일의 검사합과 같아야 한다. 그래서
글꼴이 서로 맞지 않을 수도 있으면 사용자가 경고를 받는다. (그러나 글꼴 파일이나 \.{TFM} 파일 가운데 어느 한쪽의
검사합이 0이면 검사하지 않는다.) 이 검사합이 \.{TFM} 파일의 나머지 내용과 어떤 관계인지는 중요하지 않다.
검사합은 맞지 않는 글꼴끼리는 거의 언제나 값이 다르다는 성질을 지닌 식별 번호일 뿐이다.
@^check sum@>

\yskip\hang|header[1]|은 글꼴의 설계 크기를 \TeX\ 포인트 단위로 담은 |fixWord|다. 이 수는 1.0 이상이어야 한다. 꽤
임의적이지만, 대개 ``10포인트'' 글꼴, 곧 10포인트 크기에서 가장 보기 좋도록 설계한 글꼴(그것이 정말 무슨 뜻이든)의
설계 크기는 10.0이다. \TeX\ 사용자가 글꼴을 `\.{at} $\delta$ \.{pt}'로 요구하면, 설계 크기를 $\delta$로 바꾸고
글꼴 이미지의 모든 점의 $x$와~$y$ 좌표에 $\delta$를 설계 크기로 나눈 비율을 곱하는 것과 같은 효과가 난다.
{\sl \.{TFM} 파일의 다른 모든 치수는 설계 크기를 단위로 한 |fixWord|\kern-1pt\ 수다.} 다만 |param[1]|(기울기 비율이다)은
예외다. 그래서 이를테면 \.{em} 단위를 정의하는 |param[6]|의 값은 흔히 |fixWord| 값 $2^{20}=1.0$이다. 많은 글꼴에서
설계 크기가 1\,em과 같기 때문이다. 다른 치수들은 절댓값이 설계 크기 단위로 16보다 작아야 한다. 그러므로 |header[1]|과
|param[1]|은 \.{TFM} 파일 전체에서 첫 바이트가 0이나 255가 아닐 수 있는 유일한 |fixWord| 항목이다.

@ 그다음에는 배열 |charInfo|가 오는데, 여기에는 문자마다 |@!charInfoWord| 하나가 들어 있다. 파일의 이 부분의 낱말마다
여섯 필드가 다음과 같이 네 바이트에 꾸려져 있다.

\yskip\hang 첫 바이트: |@!widthIndex| (8비트)\par
\hang 둘째 바이트: |@!heightIndex| (4비트) 곱하기 16, 더하기 |@!depthIndex| (4~비트)\par
\hang 셋째 바이트: |@!italicIndex| (6비트) 곱하기 4, 더하기 |@!tag| (2~비트)\par
\hang 넷째 바이트: |@!remainder| (8비트)\par
\yskip\noindent
문자의 실제 너비는 설계 크기 단위로 \ID{width}|[widthIndex]|다. 너비를 직접 적지 않고 표의 첨자를 적는 것은 정보를
줄이려는 장치다. 너비가 같은 문자가 많기 때문이다. 높이나 깊이나 기울임 보정이 같은 문자도 흔하므로, \.{TFM}
형식은 서로 다른 높이를 16개, 서로 다른 깊이를 16개, 서로 다른 기울임 보정을 64개까지만 허락한다.

@!@^italic correction@>
문자의 기울임 보정은 두 가지로 쓰인다. (a)~보통의 텍스트에서 기울임 보정은 \TeX\ 사용자가 문자 뒤에 `\.{\\/}'를 썼을
때에만 너비에 더해진다. (b)~수식에서 기울임 보정은 아래첨자의 자리를 정할 때를 빼면 언제나 너비에 더해진다.

덧붙이자면, $\ID{width}[0]=\ID{height}[0]=\ID{depth}[0]=\ID{italic}[0]=0$이 언제나 성립해야 한다. 그래야 첨자 0이 값
0을 뜻하게 된다. 첨자 |widthIndex|는 그 문자가 글꼴에 없을 때 말고는 결코 0이면 안 된다. 문자는 코드가 |bc|와 |ec|
사이에 있고 |widthIndex|가 0이 아닐 때, 그리고 오직 그때에만 글꼴에 있는 것이기 때문이다.

@ 낱말 |charInfoWord|의 |tag| 필드는 |remainder| 필드를 어떻게 해석할지 알려 주며, 값은 넷 가운데 하나다.

\yskip\hangg|tag=0| (|noTag|)은 |remainder|를 쓰지 않는다는 뜻이다.\par
\hangg|tag=1| (|ligTag|)은 이 문자에 배열 |ligKern|의 위치 |remainder|에서 시작하는 합자/커닝 프로그램이 있다는
뜻이다.\par
\hangg|tag=2| (|listTag|)은 이 문자가 크기가 점점 커지는 문자들의 사슬에 속하고, 그 사슬에서 가장 큰 것은 아니라는
뜻이다. 이때 |remainder| 필드는 다음으로 큰 문자의 문자 코드다.\par
\hangg|tag=3| (|extTag|)은 이 문자 코드가 늘일 수 있는 문자, 곧 작은 조각들을 쌓아 올려 얼마든지 크게 만들 수 있는
문자를 나타낸다는 뜻이다. 그 조각들은 |@!exten[remainder]|에 적혀 있다.\par
\yskip\noindent
태그가 |tag=2|나 |tag=3|인 문자도 수식의 특별한 상황이 아니면 |tag=0|인 문자처럼 다룬다. 이를테면 \.{\\sum} 연산은
|listTag|를 찾아 따라가고(본문 크기의 $\sum$에서 큰 $\sum$으로), \.{\\left} 연산은 |listTag|와 |extTag|를 둘 다 찾는다.

@<정의@>=
const (
	@!noTag = 0 // 평범한 문자
	@!ligTag = 1 // 합자/커닝 프로그램이 있는 문자
	@!listTag = 2 // 문자 목록에 후계자가 있는 문자
	@!extTag = 3 // 늘일 수 있는 문자
)

@ \seclabel{tfm-ligkern}배열 |ligKern|에는 특별한 글자 쌍을 만났을 때 무엇을 할지 적은, 간단한 프로그래밍 언어의 명령들이 들어 있다. 이
배열의 낱말은 저마다 네 바이트짜리 |@!ligKernCommand|다.

\yskip\hang 첫 바이트: |skipByte|. 이 바이트가 128 이상이면 이것이 프로그램의 마지막 단계다. 그렇지 않으면 그 수만큼의
단계를 건너뛰어 다음 단계로 간다.\par
\hang 둘째 바이트: |nextChar|. ``|nextChar|가 현재 문자 다음에 오면 연산을 하고 멈추어라. 그렇지 않으면
계속하라.''\par
\hang 셋째 바이트: |opByte|. 128보다 작으면 합자 단계를, 그렇지 않으면 커닝 단계를 나타낸다.\par
\hang 넷째 바이트: |remainder|.\par
\yskip\noindent
커닝 단계에서는 현재 문자와 |nextChar| 사이에 |kern[256*(opByte-128)+remainder]|만큼의 간격을 더 넣는다. 이 양은 흔히
음수여서 문자들이 커닝 덕분에 더 가까워지지만, 양수일 수도 있다.

합자 단계는 여덟 가지가 있는데, |opByte| 코드는 $4a+2b+c$이고 $0\le a\le b+c$이며 $0\le b,c\le1$이다. 코드가
|remainder|인 문자를 현재 문자와 |nextChar| 사이에 끼워 넣고, $b=0$이면 현재 문자를, $c=0$이면 |nextChar|를 지운다.
그런 다음 $a$~개의 문자를 지나 다음 현재 문자(이것에도 자기 합자/커닝 프로그램이 있을 수 있다)로 간다. 이를테면 보통의
`fi' 합자는 $a=b=c=0$인 경우다. 두 글자를 모두 지우고 합자 문자 하나를 넣는다.

배열 |ligKern|의 맨 처음 명령의 |skipByte|가 255이면, 그 |nextChar| 바이트가 이 글꼴의 이른바 경계 문자다. 그 값은
|bc|와~|ec| 사이에 있지 않아도 된다. 배열 |ligKern|의 맨 마지막 명령의 |skipByte|가 255이면, 왼쪽 경계 문자를 위한
특별한 합자/커닝 프로그램이 위치 |256*opByte+remainder|에서 시작한다. 이것은 \TeX이 같은 글꼴의 문자가 잇달아 나오는
곳마다 그 앞과 뒤에 보이지 않는 경계 문자를 놓는다는 뜻이다. 이 보이지 않는 문자들은 출력에 나타나지 않지만, 낱말의
첫 글자나 끝 글자에만 쓰는 특별한 합자처럼 합자와 커닝에 영향을 줄 수 있다.

문자의 |ligKern| 프로그램의 맨 처음 명령의 |skipByte|가 128보다 크면, 그 프로그램은 실은 위치 |256*opByte+remainder|에서
시작한다. 이 기능 덕분에 큰 |ligKern| 배열도 쓸 수 있다. 그렇지 않으면 첫 명령은 |<=255|인 위치에 있어야 하기 때문이다.

배열 |ligKern|에서 |skipByte>128|인 명령은 모두
$$\hbox{|256*opByte+remainder<nl|}$$
라는 조건을 지켜야 한다. 보통의 프로그램 실행 중에 그런 명령을 만나면 무조건 멈추라는 뜻이다. 합자나 커닝 명령은
실행하지 않는다.

@<정의@>=
const (
	@!stopFlag = 128 + minQuarterword // 합자/커닝 프로그램에서 `\.{STOP}'을 나타내는 값
	@!kernFlag = 128 + minQuarterword // 커닝 단계의 연산 코드
)

func skipByte(q fourQuarters) quarterword { return q.b0 }
func nextChar(q fourQuarters) quarterword { return q.b1 }
func opByte(q fourQuarters) quarterword   { return q.b2 }
func remByte(q fourQuarters) quarterword  { return q.b3 }

@ 늘일 수 있는 문자는 |@!extensibleRecipe|로 정한다. 이것은 |@!top|, |@!mid|, |@!bot|, |@!rep|라는 네 바이트로(이 순서로)
이루어진다. 이 바이트들은 큰 기호를 쌓아 올리는 데 쓰는 조각들의 문자 코드다. 조각 |top|이나 |mid|나 |bot|이 0이면 그
조각은 쌓아 올린 결과에 나타나지 않는다. 이를테면 늘일 수 있는 세로 줄은 늘일 수 있는 대괄호에서 위와 아래 조각을 뺀
것이다.

기호 $T$, $M$, $B$, $R$로 저마다의 조각(조각이 없으면 빈 상자)을 나타내자. 그러면 늘일 수 있는 문자는 위에서 아래로
어떤 |k>=0|에 대해 $TR^kMR^kB$의 꼴이다. 다만 $M$이 없으면 |k|가 짝수든 홀수든 $TR^kB$일 수 있다. 이를테면 아주 큰
중괄호는 위 갈고리 $T$, 가운데 뾰족한 부분 $M$, 아래 갈고리 $B$ 사이사이에 곧은 막대 $R$을 필요한 만큼 되풀이해
만든다. 늘일 수 있는 문자의 너비는 $R$의 너비이고, 높이 더하기 깊이는 쓰인 조각들의 높이 더하기 깊이를 모두 더한
값이다. 조각들을 세로 목록 안에서 맞붙여 쌓기 때문이다.

@<정의@>=
func extTop(q fourQuarters) quarterword { return q.b0 } // 조립법의 |top| 조각
func extMid(q fourQuarters) quarterword { return q.b1 } // 조립법의 |mid| 조각
func extBot(q fourQuarters) quarterword { return q.b2 } // 조립법의 |bot| 조각
func extRep(q fourQuarters) quarterword { return q.b3 } // 조립법의 |rep| 조각

@ \.{TFM} 파일의 마지막 부분은 배열 |param|인데, 이것도 |fixWord| 값들이다.

\yskip\hang|param[1]=slant|는 기울기의 양으로, 악센트의 자리를 정하는 데 쓴다. 이를테면 |slant=.25|는 한 단위 위로
올라가면 오른쪽으로 .25단위 간다는 뜻이다. 이 값은 순수한 수다. 설계 크기 자체를 빼면, 설계 크기를 단위로 하지 않는
유일한 |fixWord|다.

\hang|param[2]=space|는 텍스트에서 낱말 사이의 보통 간격이다. 글꼴의 문자 |" "|는 공백과 아무 관계가 없어도 된다는 데
눈여겨보자. 이를테면 cmr10의 문자 32는 폴란드어 글자 \.L에 긋는 빗금이다.

\hang|param[3]=spaceStretch|는 낱말 사이 글루가 늘어나는 양이다.

\hang|param[4]=spaceShrink|는 낱말 사이 글루가 줄어드는 양이다.

\hang|param[5]=xHeight|는 그 글꼴의 1\,ex의 크기다. 악센트를 올리거나 내리지 않아도 되는 글자들의 높이이기도 하다.

\hang|param[6]=quad|는 그 글꼴의 1\,em의 크기다.

\hang|param[7]=extraSpace|는 문장 끝에서 |param[2]|에 더하는 양이다.

\yskip\noindent
매개변수가 일곱 개보다 적으면 \TeX은 빠진 매개변수를 0으로 놓는다. 수식 기호에 쓰는 글꼴에는 매개변수가 더 필요한데,
그것은 나중에 설명한다.

@<정의@>=
const (
	@!slantCode = 1
	@!spaceCode = 2
	@!spaceStretchCode = 3
	@!spaceShrinkCode = 4
	@!xHeightCode = 5
	@!quadCode = 6
	@!extraSpaceCode = 7
)

@ \.{TFM} 파일에 담긴 것은 이와 같다. \TeX은 많은 글꼴의 정보를 흡수해야 하므로 자료의 대부분을 |fontInfo|라는 큰 배열
하나에 저장한다. 이 배열의 항목은 저마다 |memoryWord|다. 형이 |fixWord|인 자료는 실제 크기에 맞춘 |scaled| 항목으로
바꾸어 넣고, 나머지는 모두 형이 |fourQuarters|인 낱말에 그대로 넣는다.

사용자가 이를테면 \.{\\font\\f}를 정의하면, \TeX은 사용자의 글꼴~\.{\\f}에 내부 번호를 붙인다. 이 번호에 |fontIDBase|를
더하면, 언제나 그 글꼴을 고르는 ``얼린'' 제어 시퀀스의 |eqtb| 위치가 된다. 사용자가 \.{\\f}를 다시 정의하더라도 이
얼린 제어 시퀀스는 그대로 남으므로, 진단 메시지에서 글꼴 이름을 찍을 때 쓸 수 있다.

@<전역 형@>=
type @!internalFontNumber = int32 // |charNode|의 |font|; |fontBase..fontMax|
type @!fontIndex = int32 // |fontInfo|의 첨자; |0 .. fontMemSize|

@ 이제 (꽤 만만찮은) 글꼴 배열들이 줄줄이 나온다. 모두 내부 글꼴 번호를 첨자로 쓴다. 글꼴의 이름과 크기, 검사합, 문자
코드의 범위, 하이픈 문자와 비뚤림 문자(\.{\\hyphenchar}, \.{\\skewchar}), 경계 문자에 관한 정보 따위가 들어 있다.

@<전역 변수@>=
const (
	@!nonChar = 256 + minQuarterword // 진짜 문자와 맞을 수 없는 |halfword| 코드
	@!nonAddress = 0 // 가짜 |bcharLabel|
)

var @!fontInfo [fontMemSize + 1]memoryWord // 글꼴 자료의 큰 모음
var @!fmemPtr fontIndex // |fontInfo|에서 쓰이지 않는 첫 낱말
var @!fontPtr internalFontNumber // 쓰이고 있는 가장 큰 내부 글꼴 번호
var @!fontCheck [fontMax + 1]fourQuarters // 검사합
var @!fontSize [fontMax + 1]scaled // ``at'' 크기
var @!fontDsize [fontMax + 1]scaled // ``설계'' 크기
var @!fontParams [fontMax + 1]fontIndex // 글꼴 매개변수가 몇 개 있나
var @!fontName [fontMax + 1]strNumber // 글꼴의 이름
var @!fontArea [fontMax + 1]strNumber // 글꼴의 영역
var @!fontBc [fontMax + 1]eightBits // 처음(가장 작은) 문자 코드
var @!fontEc [fontMax + 1]eightBits // 끝(가장 큰) 문자 코드
var @!fontGlue [fontMax + 1]pointer // 낱말 사이 공백의 글루 명세, 할당하지 않았으면 |null|
var @!fontUsed [fontMax + 1]bool // 이 글꼴의 문자가 실제로 출력에 나타났나?
var @!hyphenChar [fontMax + 1]int32 // 현재의 \.{\\hyphenchar} 값
var @!skewChar [fontMax + 1]int32 // 현재의 \.{\\skewchar} 값
var @!bcharLabel [fontMax + 1]fontIndex // 왼쪽 경계 문자의 |ligKern| 프로그램의 시작,
	@t\qquad@>// 없으면 |nonAddress|
var @!fontBchar [fontMax + 1]int32 // 경계 문자, 없으면 |nonChar|; |minQuarterword..nonChar|
var @!fontFalseBchar [fontMax + 1]int32 // 글꼴에 없으면 |fontBchar|, 있으면 |nonChar|

@ 방금 늘어놓은 배열 말고도, |fontInfo|의 항목을 쉽게 찾아가게 해 주는 디렉터리 배열들이 있다. 이를테면 글꼴 |f|의 문자
|c|에 대한 |charInfo| 자료는 |fontInfo[charBase[f]+c].qqqq|에 있다. 그리고 |w|가 이 낱말의 |widthIndex| 부분(|b0| 필드)이면
그 문자의 너비는 |fontInfo[widthBase[f]+w].sc|다. (이 공식들은 |c|와 |w|에 이미 |minQuarterword|가 더해져 있다고 가정한다.
\TeX은 쿼터워드를 그렇게 저장하기 때문이다.) 이렇게 글꼴마다 표의 시작 위치만 기억해 두면, 문자 하나의 너비를
배열 두 번 읽기로 얻을 수 있다.

@<전역 변수@>=
var @!charBase [fontMax + 1]int32 // |charInfo|의 바닥 주소
var @!widthBase [fontMax + 1]int32 // 너비의 바닥 주소
var @!heightBase [fontMax + 1]int32 // 높이의 바닥 주소
var @!depthBase [fontMax + 1]int32 // 깊이의 바닥 주소
var @!italicBase [fontMax + 1]int32 // 기울임 보정의 바닥 주소
var @!ligKernBase [fontMax + 1]int32 // 합자/커닝 프로그램의 바닥 주소
var @!kernBase [fontMax + 1]int32 // 커닝의 바닥 주소
var @!extenBase [fontMax + 1]int32 // 늘일 수 있는 문자 조립법의 바닥 주소
var @!paramBase [fontMax + 1]int32 // 글꼴 매개변수의 바닥 주소

@ 처음에는 어떤 글꼴도 쓴 적이 없다.
@<핵심 변수들의...@>=
for k = fontBase; k <= fontMax; k++ {
	fontUsed[k] = false
}

@ \TeX은 글꼴을 적어도 하나, 곧 널 글꼴은 언제나 안다. 널 글꼴에는 문자가 없고, 일곱 매개변수는 모두 0이다. 글꼴을 고르지
않은 채 문자를 조판하려 하면 이 글꼴이 쓰이므로, 문자는 사라진다(\.{\\tracinglostchars}가 양수이면 기록 파일에 알린다).

@<표의 항목들을 초기화한다...@>=
fontPtr = nullFont
fmemPtr = 7
fontName[nullFont] = str("nullfont")
fontArea[nullFont] = str("")
hyphenChar[nullFont] = '-'
skewChar[nullFont] = -1
bcharLabel[nullFont] = nonAddress
fontBchar[nullFont] = nonChar
fontFalseBchar[nullFont] = nonChar
fontBc[nullFont] = 1
fontEc[nullFont] = 0
fontSize[nullFont] = 0
fontDsize[nullFont] = 0
charBase[nullFont] = 0; widthBase[nullFont] = 0
heightBase[nullFont] = 0; depthBase[nullFont] = 0
italicBase[nullFont] = 0; ligKernBase[nullFont] = 0
kernBase[nullFont] = 0; extenBase[nullFont] = 0
fontGlue[nullFont] = null
fontParams[nullFont] = 7
paramBase[nullFont] = -1
for k = 0; k <= 6; k++ {
	fontInfo[k].sc = 0
}

@ 명령 \.{\\nullfont}을 넣고, 오류 수습에 쓸 얼린 사본도 만들어 둔다.
@<\TeX의 원시 명령을...@>=
primitive("nullfont", setFont, nullFont)
@!@:null_font_}{\.{\\nullfont} primitive@>
setText(frozenNullFont, str("nullfont"))
eqtb[frozenNullFont] = eqtb[curVal]

@ 물론 글꼴 정보가 실제로 어떻게 꾸려져 있는지 세세한 것을 감추는 함수들을 만들어 두고 싶다. 그래야
$$\hbox{|fontInfo[widthBase[f]+fontInfo[charBase[f]+c].qqqq.b0].sc|}$$
같은 것을 너무 자주 쓰지 않아도 된다. 여기의 정의들에서 |charInfo(f,c)|는 글꼴 |f|의 문자 |c|에 해당하는 |fourQuarters|
낱말이다. 그런 낱말을 |q|라고 하면 |charWidth(f,q)|가 그 문자의 너비다. 그래서 위의 긴 공식은 적어도
$$\hbox{|charWidth(f,charInfo(f,c))|}$$
로 줄어든다. 물론 대개는 |q|를 먼저 가져와서 그 필드 여럿을 한꺼번에 본다.

문자의 기울임 보정은 |charItalic(f,q)|로 얻으므로 |charWidth|와 비슷하다. 그러나 높이와 깊이는 조금 다른 방법으로 얻는다.
둘 가운데 하나가 필요하면 대개 둘 다 필요하기 때문이다. 함수 |heightDepth(q)|의 값은 8비트 양
$$b=|heightIndex|\times16+|depthIndex|$$
이고, |b|가 그런 바이트이면 |q=charInfo(f,c)|인 문자 |c|의 높이와 깊이를 |charHeight(f,b)|와 |charDepth(f,b)|로 쓴다.
알겠는가?

태그 필드는 |charTag(q)|라고 부르고, 나머지 바이트는 위에서 이미 정의한 함수로 |remByte(q)|라고 부른다.

문자의 |width|, |height|, |depth|, |tag| 필드를 읽는 것은 \TeX의 안쪽 루프의 일부이므로, 이 함수들은 될 수 있는 대로
빠른 코드가 되기를 바란다.
@^inner loop@>

@<정의@>=
func charInfo(f internalFontNumber, c quarterword) fourQuarters {
	return fontInfo[charBase[f]+c].qqqq
}
func charWidth(f internalFontNumber, q fourQuarters) scaled {
	return fontInfo[widthBase[f]+q.b0].sc
}
func charExists(q fourQuarters) bool { return q.b0 > minQuarterword }
func charItalic(f internalFontNumber, q fourQuarters) scaled {
	return fontInfo[italicBase[f]+(qo(q.b2))/4].sc
}
func heightDepth(q fourQuarters) int32 { return qo(q.b1) }
func charHeight(f internalFontNumber, hd int32) scaled {
	return fontInfo[heightBase[f]+(hd)/16].sc
}
func charDepth(f internalFontNumber, hd int32) scaled {
	return fontInfo[depthBase[f]+(hd)%16].sc
}
func charTag(q fourQuarters) int32 { return (qo(q.b2)) % 4 }

@ 전역 변수 |nullCharacter|는 글꼴에 없는 문자의 |charInfo| 낱말이다. 이 낱말은 모든 바이트가 0이어서 너비 첨자도
0이므로, |charExists|가 거짓이 된다. 잘못된 상황을 다룰 때 편리하다.

@<전역 변수@>=
var @!nullCharacter fourQuarters // 글꼴에 없는 문자의 정보

@ @<핵심 변수들의...@>=
nullCharacter.b0 = minQuarterword
nullCharacter.b1 = minQuarterword
nullCharacter.b2 = minQuarterword
nullCharacter.b3 = minQuarterword

@ 다음은 합자와 커닝을 처리하는 데 도움을 주는 함수들이다. 글꼴~|f|에서 커닝 명령~|j|가 지정하는 커닝의 양을 찾으려면
|charKern(f,j)|라고 쓴다. 낱말 |j|가 합자/커닝 프로그램이 있는 문자의 |charInfo|이면, 그 프로그램의 첫 명령은
|i=fontInfo[ligKernStart(f,j)]|이다. 다만 그 명령의 |skipByte(i)|가 |stopFlag|보다 크면 프로그램이 다른 곳에서
시작한다는 뜻이므로, 첫 명령은 |fontInfo[ligKernRestart(f,i)]|다.

국지 최적화를 하지 않는 컴파일러라면 상수 |kernBaseOffset|이 들어간 식을 미리 줄여 두어야 한다.
@^system dependencies@>

@<정의@>=
const @!kernBaseOffset = 256 * (128 + minQuarterword)

func charKern(f internalFontNumber, q fourQuarters) scaled {
	return fontInfo[kernBase[f]+256*opByte(q)+remByte(q)].sc
}
func ligKernStart(f internalFontNumber, q fourQuarters) int32 { // 합자/커닝 프로그램의 시작
	return ligKernBase[f] + remByte(q)
}
func ligKernRestart(f internalFontNumber, q fourQuarters) int32 {
	return ligKernBase[f] + 256*opByte(q) + remByte(q) + 32768 - kernBaseOffset
}

@ 글꼴 매개변수는 |slant(f)|, |space(f)| 따위로 가리킨다. 이를테면 단위 \.{em}은 현재 글꼴의 |quad|다.

@<|curFont|의 em 너비@>=
quad(curFont())

@ 글꼴 매개변수를 읽는 함수들이다. 매개변수 |n|은 |fontInfo[paramBase[f]+n]|에 들어 있다.
@<정의@>=
func param(n int32, f internalFontNumber) scaled {
	return fontInfo[n+paramBase[f]].sc
}
func slant(f internalFontNumber) scaled { // 위로 단위 거리마다 오른쪽 기울기
	return param(slantCode, f)
}
func space(f internalFontNumber) scaled { // 낱말 사이의 보통 간격
	return param(spaceCode, f)
}
func spaceStretch(f internalFontNumber) scaled { // 낱말 사이의 늘어남
	return param(spaceStretchCode, f)
}
func spaceShrink(f internalFontNumber) scaled { // 낱말 사이의 줄어듦
	return param(spaceShrinkCode, f)
}
func xHeight(f internalFontNumber) scaled { // 1\,ex
	return param(xHeightCode, f)
}
func quad(f internalFontNumber) scaled { // 1\,em
	return param(quadCode, f)
}
func extraSpace(f internalFontNumber) scaled { // 문장 끝의 추가 간격
	return param(extraSpaceCode, f)
}

@ 단위 \.{ex}는 현재 글꼴의 |xHeight|다.
@<|curFont|의 x 높이@>=
xHeight(curFont())

@ \TeX은 \.{TFM} 파일의 정보를 읽어 들이면서 올바른지 검사하므로, 조판하는 동안에는 더 검사할 필요가 없다. 이 일을 하는
좀 지루한 서브루틴을 |readFontInfo|라고 부른다. 매개변수는 넷이다. 사용자의 글꼴 식별자~|u|, 파일 이름과 영역 문자열
|nom|과 |aire|, 그리고 ``at'' 크기~|s|다. 크기 |s|가 음수이면 그것은 설계 크기에 곱할 배율에 마이너스를 붙인 것이다.
보통은 |s=-1000|이다. 이를테면 `\.{scaled 1200}'이면 |s=-1200|이다. 그렇지 않으면 |s|가 설계 크기를 대신한다. 이때 |s|는
양수이고 $2048\rm\,pt$보다 작아야 한다(곧 정수로 보아 $2^{27}$보다 작아야 한다).

이 서브루틴은 |tfmFile|이라는 전역 파일 변수를 열고 닫는다. 그리고 방금 실은 글꼴의 내부 번호를 돌려준다. 오류를
찾으면 오류 메시지를 내고 글꼴 정보는 하나도 저장하지 않는다. 그때는 |nullFont|를 돌려준다.

\.{TFM} 자료를 읽는 작은 함수들은 |readFontInfo|의 지역 변수를 쓰므로 |readFontInfo| 안의 함수 리터럴로
둔다(|@<\.{TFM} 파일을 읽는 함수들@>|). 자료가 잘못되었으면 레이블 |badTFM|으로 가서 그만두어야 하는데, 이것을
|abort|라고 부르자. 그러나 \GO/의 |goto|는 함수 리터럴 바깥으로 뛸 수 없으므로, 그런 함수 리터럴은 자료가 잘못되었으면
|false|를 돌려주고, 부르는 쪽에서 `|if !readSixteen(&lf) { goto badTFM }|'처럼 |abort|한다.

@<함수들@>=
func readFontInfo(u pointer, nom, aire strNumber,
	s scaled) internalFontNumber { // \.{TFM} 파일을 입력한다
	var k fontIndex // |fontInfo|의 첨자
	var fileOpened bool // |tfmFile|을 잘 열었나?
	var lf, lh, bc, ec, nw, nh, nd, ni, nl, nk, ne, np halfword // 하위 파일들의 크기
	var f internalFontNumber // 새 글꼴의 번호
	var g internalFontNumber // 돌려줄 번호
	var a, b, c, d eightBits // 바이트 변수들
	var qw fourQuarters
	var sw scaled // 누산기들
	var bchLabel int32 // 왼쪽 경계의 시작 위치, 또는 무한대
	var bchar int32 // 경계 문자, 또는 256; |0..256|
	var z scaled // 설계 크기나 ``at'' 크기
	var alpha int32
	var beta int32 // 고정 소수점 곱셈에 쓰는 보조 양들; |1..16|
	@<\.{TFM} 파일을 읽는 함수들@>
	g = nullFont
	@<글꼴 자료를 읽고 검사한다@>
badTFM:
	@<글꼴을 싣지 않겠다고 알린다@>
done:
	if fileOpened {
		bClose(&tfmFile)
	}
	return g
}

@ \.{TFtoPL}과 \.{PLtoTF}라는 프로그램이 \.{TFM} 형식과, 사람이 읽고 고치기 쉬운 속성 목록 형식 사이를 바꾸어 준다. 이
프로그램들은 자세한 진단 정보를 많이 주므로, \TeX은 어떤 \.{TFM} 파일을 왜 거부하는지 시시콜콜 알려 줄 필요가 없다.
글꼴을 실을 수 없으면 파일을 찾지 못했는지, 파일이 잘못되었는지만 알린다.
@.TFtoPL@> @.PLtoTF@>

@<글꼴을 싣지 않겠다고...@>=
startFontErrorMessage()
@.Font x=xx not loadable...@>
if fileOpened {
	printStr(" not loadable: Bad metric (TFM) file")
} else {
	printStr(" not loadable: Metric (TFM) file not found")
}
help5("I wasn't able to read the size data for this font,",
	"so I will ignore the font specification.",
	"[Wizards can fix TFM files using TFtoPL/PLtoTF.]",
	"You might try inserting a different font spec;",
	"e.g., type `I\\font<same font id>=<substitute font name>'.")
reportError()

@ 함수 |startFontErrorMessage|는 오류 메시지를 `\.{! Font \\tenrm=cmr10 at 12.0pt}'처럼 시작한다. 이 함수는
|readFontInfo|의 매개변수들을 쓰므로 함수 리터럴이다.

@<\.{TFM} 파일을 읽는 함수들@>=
startFontErrorMessage := func() {
	printErr("Font ")
	sprintCs(u)
	printChar('=')
	printFileName(nom, aire, str(""))
	if s >= 0 {
		printStr(" at ")
		printScaled(s)
		printStr("pt")
	} else if s != -1000 {
		printStr(" scaled ")
		printInt(-s)
	}
}

@ 다음 코드는 글꼴 자료를 읽고 검사한다. \.{TFM} 파일이 잘못 만들어졌으면 |abort|하고, 이 글꼴을 넣을 자리가 없으면
그렇다고 알리고 |goto done|하며, 그렇지 않으면 |fontPtr|를 하나 늘리고 |goto done|한다. 파일의 각 부분을 차례로 읽는
절들로 나누어 두었다.

@<글꼴 자료를 읽고...@>=
@<|tfmFile|을 입력용으로 연다@>
@<\.{TFM}의 크기 필드들을 읽는다@>
@<크기 필드들로 글꼴 정보를 할당한다@>
@<\.{TFM}의 머리를 읽는다@>
@<문자 자료를 읽는다@>
@<상자 치수들을 읽는다@>
@<합자/커닝 프로그램을 읽는다@>
@<늘일 수 있는 문자의 조립법을 읽는다@>
@<글꼴 매개변수들을 읽는다@>
@<마지막 조정을 하고 |goto done|@>

@ \.{TFM} 파일을 연다. 영역을 밝히지 않았으면 시스템 글꼴 영역 |texFontArea|에서 찾는다.
@<|tfmFile|을 입력용으로...@>=
fileOpened = false
if aire == str("") {
	packFileName(nom, texFontArea, str(".tfm"))
} else {
	packFileName(nom, aire, str(".tfm"))
}
if !bOpenIn(&tfmFile) {
	goto badTFM
}
fileOpened = true

@ 주의할 점이 있다. 잘못 만든 \.{TFM} 파일은 자기가 주장하는 것보다 짧을 수도 있다. 그러니 |readFontInfo|가 파일의 현재
원소 |tfmFile.buf|를 보거나 |fget|을 부를 때 이미 파일 끝에 이르렀을 수도 있다. 그런 상황에서 시스템 오류 메시지가
난다면 어떻게든 막아야 한다. 여기서는 함수 |bGet|이 파일 끝에서 오류를 내지 않고 |buf|를 0으로 놓으므로 그런 걱정이
없다. 짧은 파일은 결국 다른 검사에 걸려 거부된다.

다음은 \.{TFM} 파일을 읽는 작은 함수들이다. 함수 |fget|은 다음 바이트로 넘어가고, |fbyte|는 현재 바이트를 준다. 함수
|readSixteen|은 16비트 정수 하나를 읽는데, 첫 바이트가 127보다 크면(곧 음수이면) 잘못된 파일이다. 함수
|storeFourQuarters|는 네 바이트를 |a|, |b|, |c|, |d|에 읽고 |fourQuarters| 낱말로 저장한다.
@^system dependencies@>

@<\.{TFM} 파일을 읽는 함수들@>=
fget := func() { bGet(&tfmFile) }
fbyte := func() eightBits { return tfmFile.buf }
readSixteen := func(x *halfword) bool { // |false|면 |abort|해야 한다
	*x = fbyte()
	if *x > 127 {
		return false
	}
	fget()
	*x = *x*0o400 + fbyte()
	return true
}
storeFourQuarters := func(x *fourQuarters) {
	fget(); a = fbyte(); qw.b0 = qi(a)
	fget(); b = fbyte(); qw.b1 = qi(b)
	fget(); c = fbyte(); qw.b2 = qi(c)
	fget(); d = fbyte(); qw.b3 = qi(d)
	*x = qw
}

@ 처음 열두 개의 16비트 정수를 읽고 서로 맞는지 검사한다(\secref{tfm-sizes}의 식들).
@<\.{TFM}의 크기 필드들을...@>=
if !readSixteen(&lf) { goto badTFM }
fget(); if !readSixteen(&lh) { goto badTFM }
fget(); if !readSixteen(&bc) { goto badTFM }
fget(); if !readSixteen(&ec) { goto badTFM }
if bc > ec+1 || ec > 255 {
	goto badTFM
}
if bc > 255 { // |bc=256|이고 |ec=255|
	bc = 1
	ec = 0
}
fget(); if !readSixteen(&nw) { goto badTFM }
fget(); if !readSixteen(&nh) { goto badTFM }
fget(); if !readSixteen(&nd) { goto badTFM }
fget(); if !readSixteen(&ni) { goto badTFM }
fget(); if !readSixteen(&nl) { goto badTFM }
fget(); if !readSixteen(&nk) { goto badTFM }
fget(); if !readSixteen(&ne) { goto badTFM }
fget(); if !readSixteen(&np) { goto badTFM }
if lf != 6+lh+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+np {
	goto badTFM
}
if nw == 0 || nh == 0 || nd == 0 || ni == 0 {
	goto badTFM
}

@ 크기를 알았으니 |fontInfo|에 자리를 잡고, 글꼴의 표마다 시작 위치를 정한다. 첨자 오프셋 변수 |charBase|, |widthBase|,
|ligKernBase|, |kernBase|, |extenBase|의 예비 설정은 나중에 |minQuarterword|를 빼서 바로잡는다. 그리고 |paramBase|에서도
1을 뺀다. 그런 변칙은 나중까지 잊어버리는 것이 가장 좋다.

@<크기 필드들로...@>=
lf = lf - 6 - lh // |fontInfo|에 실어야 할 낱말이 |lf|개다
if np < 7 {
	lf = lf + 7 - np
} // 매개변수가 적어도 일곱 개 나타날 것이다
if fontPtr == fontMax || fmemPtr+lf > fontMemSize {
	@<글꼴을 싣지 못한다고 사과하고 |goto done|@>
}
f = fontPtr + 1
charBase[f] = fmemPtr - bc
widthBase[f] = charBase[f] + ec + 1
heightBase[f] = widthBase[f] + nw
depthBase[f] = heightBase[f] + nh
italicBase[f] = depthBase[f] + nd
ligKernBase[f] = italicBase[f] + ni
kernBase[f] = ligKernBase[f] + nl - kernBaseOffset
extenBase[f] = kernBase[f] + kernBaseOffset + nk
paramBase[f] = extenBase[f] + ne

@ 글꼴 정보를 넣을 자리가 모자라면 사과하고 이 글꼴을 싣지 않는다.
@<글꼴을 싣지 못한다고...@>=
startFontErrorMessage()
printStr(" not loaded: Not enough room left")
@.Font x=xx not loaded...@>
help4("I'm afraid I won't be able to make use of this font,",
	"because my memory for character-size data is too small.",
	"If you're really stuck, ask a wizard to enlarge me.",
	"Or maybe try `I\\font<same font id>=<name of loaded font>'.")
reportError()
goto done

@ \TeX82에 필요한 것은 머리의 처음 두 낱말, 곧 검사합과 설계 크기뿐이다. 설계 크기는 |fixWord|에서 |scaled|로 바꾼다.
``at'' 크기 |s|가 주어지지 않았으면 설계 크기에 배율을 곱해 실제 크기 |z|를 정한다.

@<\.{TFM}의 머리를...@>=
if lh < 2 {
	goto badTFM
}
storeFourQuarters(&fontCheck[f])
fget()
if !readSixteen(&z) { // 이것은 음의 설계 크기를 거부한다
	goto badTFM
}
fget(); z = z*0o400 + fbyte(); fget(); z = (z * 0o20) + (fbyte() / 0o20)
if z < unity {
	goto badTFM
}
for lh > 2 {
	fget(); fget(); fget(); fget(); lh-- // 머리의 나머지는 무시한다
}
fontDsize[f] = z
if s != -1000 {
	if s >= 0 {
		z = s
	} else {
		z = xnOverD(z, -s, 1000)
	}
}
fontSize[f] = z

@ 문자마다 |charInfo| 낱말을 읽고, 그 안의 첨자들이 각 표의 크기를 넘지 않는지 검사한다.
@<문자 자료를...@>=
for k = fmemPtr; k <= widthBase[f]-1; k++ {
	storeFourQuarters(&fontInfo[k].qqqq)
	if a >= nw || b/0o20 >= nh || b%0o20 >= nd || c/4 >= ni {
		goto badTFM
	}
	switch c % 4 {
	case ligTag: if d >= nl { goto badTFM }
	case extTag: if d >= ne { goto badTFM }
	case listTag: @<문자 목록의 순환을 검사한다@>
	default: // |noTag|
	}
}

@ 태그가 |listTag|인 항목들로 이어진 문자들 사이에 순환이 없는지 확인하고 싶다. 순환이 있으면 \TeX이 끝없는 루프에 빠질
것이기 때문이다. 순환이 있다면, 여기의 루틴은 그 순환에서 가장 큰 문자 코드를 처리할 때 그것을 찾아낸다. 사슬을
따라가다가 지금 문자보다 작은 코드만 보고 다니다 지금 문자로 돌아오면 순환이다.

@<문자 목록의 순환을...@>=
if !checkByteRange(d) {
	goto badTFM
}
for d < currentCharacterBeingWorkedOn() {
	qw = charInfo(f, d)
	// 주의: |qi(d)|가 아니다. |charBase[f]|를 아직 조정하지 않았기 때문이다
	if charTag(qw) != listTag {
		goto notFound
	}
	d = qo(remByte(qw)) // 목록의 다음 문자
}
if d == currentCharacterBeingWorkedOn() {
	goto badTFM // 그렇다, 순환이 있다
}
notFound: ;

@ 문자 코드가 |bc|와 |ec| 사이인지 검사하는 함수와, 지금 처리하는 문자의 코드를 계산하는 함수다.
@<\.{TFM} 파일을 읽는 함수들@>=
checkByteRange := func(c eightBits) bool { return !(c < bc || c > ec) } // |false|면 |abort|
currentCharacterBeingWorkedOn := func() int32 { return k + bc - fmemPtr }

@ 네 바이트가 왼쪽부터 $(a,b,c,d)$인 |fixWord|는 수
$$x=\left\{\vcenter{\halign{$#$,\hfil\qquad&$#$일 때\hfil\cr
b\cdot2^{-4}+c\cdot2^{-12}+d\cdot2^{-20}&a=0\cr
-16+b\cdot2^{-4}+c\cdot2^{-12}+d\cdot2^{-20}&a=255\cr}}\right.$$
를 나타낸다. (설계 크기 단위로 나타낸 수의 크기는 16보다 작아야 하므로 |a|의 다른 값은 허락되지 않는다.) 이 양에
정수~|z|를 곱하고 싶은데, |z|는 $2^{27}$보다 작다고 보장되어 있다. 만일 $|z|<2^{23}$이면 곱셈 $b\cdot z$, $c\cdot z$,
$d\cdot z$는 넘칠 수 없다. 그렇지 않으면 |z|를 2, 4, 8, 16으로 나누어 $2^{23}$보다 작은 곱수를 얻고, 나중에 그만큼
보정한다. 그래서 |z|가 $|z|^\prime=|z|/2^e$로 바뀌었다면 $\beta=2^{4-e}$로 두고, $a=0$이면
$$\lfloor(b+c\cdot2^{-8}+d\cdot2^{-16})\,z^\prime/\beta\rfloor$$
를 계산하고, $a=255$이면 같은 양에서 $\alpha=2^{4+e}z^\prime$을 뺀 것을 계산한다. \TeX을 다른 컴퓨터로 옮겨도 같은 결과가
나오려면 이 계산을 꼭 이대로 해야 한다.

상자 치수들, 곧 너비, 높이, 깊이, 기울임 보정, 커닝의 표를 모두 이 방법으로 읽는다. 각 표의 첫 항목은 0이어야 한다.

@<상자 치수들을...@>=
@<|z|를 $|z|^\prime$으로 바꾸고 $\alpha$와 $\beta$를 계산한다@>
for k = widthBase[f]; k <= ligKernBase[f]-1; k++ {
	if !storeScaled(&fontInfo[k].sc) {
		goto badTFM
	}
}
if fontInfo[widthBase[f]].sc != 0 {
	goto badTFM // \ID{width}[0]은 0이어야 한다
}
if fontInfo[heightBase[f]].sc != 0 {
	goto badTFM // \ID{height}[0]은 0이어야 한다
}
if fontInfo[depthBase[f]].sc != 0 {
	goto badTFM // \ID{depth}[0]은 0이어야 한다
}
if fontInfo[italicBase[f]].sc != 0 {
	goto badTFM // \ID{italic}[0]은 0이어야 한다
}

@ 함수 |storeScaled|는 |fixWord| 하나를 읽어 |z|를 곱한 |scaled| 값으로 바꾼다. 위의 식을 그대로 옮긴 것이다. 첫 바이트가
0이나 255가 아니면 잘못된 파일이다.
@<\.{TFM} 파일을 읽는 함수들@>=
storeScaled := func(x *scaled) bool { // |false|면 |abort|해야 한다
	fget(); a = fbyte(); fget(); b = fbyte()
	fget(); c = fbyte(); fget(); d = fbyte()
	sw = (((((d * z) / 0o400) + (c * z)) / 0o400) + (b * z)) / beta
	if a == 0 {
		*x = sw
	} else if a == 255 {
		*x = sw - alpha
	} else {
		return false
	}
	return true
}

@ 크기 |z|가 $2^{23}$ 이상이면 반으로 줄이기를 되풀이하며 $\alpha$를 두 배씩 늘리고, 마지막에 $\beta$와 $\alpha$를 계산한다.
@<|z|를 $|z|^\prime$으로...@>=
alpha = 16
for z >= 0o40000000 {
	z /= 2
	alpha += alpha
}
beta = 256 / alpha
alpha *= z

@ 합자/커닝 프로그램을 읽는다. 명령마다 다음 문자와 결과 문자가 글꼴에 있는지, 커닝 첨자가 커닝 표 안에 있는지 검사한다.
맨 처음 명령과 맨 마지막 명령에서는 경계 문자와 왼쪽 경계의 프로그램 위치를 알아낸다(\secref{tfm-ligkern}).
@<합자/커닝 프로그램을...@>=
bchLabel = 0o77777
bchar = 256
if nl > 0 {
	for k = ligKernBase[f]; k <= kernBase[f]+kernBaseOffset-1; k++ {
		storeFourQuarters(&fontInfo[k].qqqq)
		if a > 128 {
			if 256*c+d >= nl {
				goto badTFM
			}
			if a == 255 {
				if k == ligKernBase[f] {
					bchar = b
				}
			}
		} else {
			@<합자/커닝 명령 하나를 검사한다@>
		}
	}
	if a == 255 {
		bchLabel = 256*c + d
	}
}
for k = kernBase[f] + kernBaseOffset; k <= extenBase[f]-1; k++ {
	if !storeScaled(&fontInfo[k].sc) {
		goto badTFM
	}
}

@ 문자 |c|가 글꼴에 있는지 검사하는 |checkExistence|도 함수 리터럴이다.

@<\.{TFM} 파일을 읽는 함수들@>=
checkExistence := func(c eightBits) bool { // |false|면 |abort|해야 한다
	if !checkByteRange(c) {
		return false
	}
	qw = charInfo(f, c) // 주의: |qi(c)|가 아니다
	return charExists(qw)
}

@ 앞 절에서 합자/커닝 명령 하나를 검사하는 부분을 떼어 낸 것이다.

@<합자/커닝 명령 하나를...@>=
if b != bchar {
	if !checkExistence(b) {
		goto badTFM
	}
}
if c < 128 { // 합자를 검사한다
	if !checkExistence(d) {
		goto badTFM
	}
} else if 256*(c-128)+d >= nk {
	goto badTFM // 커닝을 검사한다
}
if a < 128 {
	if k-ligKernBase[f]+a+1 >= nl {
		goto badTFM
	}
}

@ 늘일 수 있는 문자의 조립법을 읽는다. 조각으로 쓰는 문자는 모두 글꼴에 있어야 한다. 반복 조각 |rep|은 없어서는 안 된다.
@<늘일 수 있는 문자의...@>=
for k = extenBase[f]; k <= paramBase[f]-1; k++ {
	storeFourQuarters(&fontInfo[k].qqqq)
	if a != 0 && !checkExistence(a) { goto badTFM }
	if b != 0 && !checkExistence(b) { goto badTFM }
	if c != 0 && !checkExistence(c) { goto badTFM }
	if !checkExistence(d) { goto badTFM }
}

@ 글꼴 매개변수를 읽는다. 첫 매개변수 |slant|는 순수한 수이므로 |z|를 곱하지 않는다. 그다음 \.{TFM} 파일이 너무 일찍
끝나지 않았는지 검사한다. 그러나 낱말이 |lf|개보다 많은 파일에 대해서는 오류 메시지를 내지 않는다. 매개변수가 일곱
개보다 적으면 나머지를 0으로 채운다.

@<글꼴 매개변수들을...@>=
for k = 1; k <= np; k++ {
	if k == 1 { // 매개변수 |slant|는 순수한 수다
		fget(); sw = fbyte()
		if sw > 127 {
			sw -= 256
		}
		fget(); sw = sw*0o400 + fbyte(); fget(); sw = sw*0o400 + fbyte()
		fget(); fontInfo[paramBase[f]].sc = (sw * 0o20) + (fbyte() / 0o20)
	} else if !storeScaled(&fontInfo[paramBase[f]+k-1].sc) {
		goto badTFM
	}
}
if tfmFile.atEOF {
	goto badTFM
}
for k = np + 1; k <= 7; k++ {
	fontInfo[paramBase[f]+k-1].sc = 0
}

@ 이제 마무리하자. \.{TFM} 파일에 관해 필요한 것은 모두 검사했고, 남은 일은 새 글꼴의 자료를 다듬는 것뿐이다. 하이픈 문자와
비뚤림 문자는 \.{\\defaulthyphenchar}와 \.{\\defaultskewchar}의 지금 값으로 정하고, 경계 문자 정보도 정리한다.

끝에서는 다섯 기준 배열의 원소 |x[f]|를 저마다 |qo(x[f])|로 바꾼다.

@<마지막 조정을...@>=
fontParams[f] = max(np, 7)
hyphenChar[f] = defaultHyphenChar()
skewChar[f] = defaultSkewChar()
if bchLabel < nl {
	bcharLabel[f] = bchLabel + ligKernBase[f]
} else {
	bcharLabel[f] = nonAddress
}
fontBchar[f] = qi(bchar)
fontFalseBchar[f] = qi(bchar)
if bchar <= ec {
	if bchar >= bc {
		qw = charInfo(f, bchar) // 주의: |qi(bchar)|가 아니다
		if charExists(qw) {
			fontFalseBchar[f] = nonChar
		}
	}
}
fontName[f] = nom
fontArea[f] = aire
fontBc[f] = bc; fontEc[f] = ec; fontGlue[f] = null
charBase[f] = qo(charBase[f]) // |minQuarterword|만큼 넘친 것을 바로잡는다
widthBase[f] = qo(widthBase[f])
ligKernBase[f] = qo(ligKernBase[f])
kernBase[f] = qo(kernBase[f])
extenBase[f] = qo(extenBase[f])
paramBase[f]--
fmemPtr += lf
fontPtr = f
g = f
goto done

@ 이 표들의 형식을 잊어버리기 전에, 글꼴 정보에 관련된 \TeX의 기본 훑기 루틴 둘을 다루자. 첫째 |scanFontIdent|는 글꼴을
가리키는 것을 읽어 그 내부 번호를 |curVal|에 넣는다. 명령 \.{\\font}(현재 글꼴), \.{\\tenrm} 같은 글꼴 식별자, \.{\\textfont2}
같은 수식 글꼴 지정을 받아들인다.

@<글꼴에 관련된 것을...@>=
func scanFontIdent() {
	var f internalFontNumber
	var m halfword
	@<공백도 호출도 아닌...@>
	if curCmd == defFont {
		f = curFont()
	} else if curCmd == setFont {
		f = curChr
	} else if curCmd == defFamily {
		m = curChr
		scanFourBitInt()
		f = equiv(m + curVal)
	} else {
		printErr("Missing font identifier")
@.Missing font identifier@>
		help2("I was looking for a control sequence whose",
			"current meaning has been defined by \\font.")
		backError()
		f = nullFont
	}
	curVal = f
}

@ 다음 루틴은 `\.{\\fontdimen} |n| |f|'를 구현하는 데 쓴다. 매개변수 값을 바꿀 생각이면 부르는 쪽에서 불 매개변수 |writing|을
|true|로 준다. 그러면 공백 매개변수가 바뀌는 경우에 대비해 그 글꼴의 낱말 사이 글루를 버려 둔다. 매개변수 번호가 지금
있는 수보다 크면, 그 글꼴이 가장 최근에 실은 글꼴일 때에 한해 매개변수 공간을 늘릴 수 있다. 그래서 수식 기호 글꼴에
매개변수를 더 붙이려면 그 글꼴을 싣자마자 \.{\\fontdimen}을 써야 한다.

@<글꼴에 관련된 것을...@>=
func findFontDimen(writing bool) { // |curVal|을 |fontInfo|의 위치로 놓는다
	scanInt()
	n := curVal // 매개변수 번호
	scanFontIdent()
	f := curVal // 관련된 글꼴
	if n <= 0 {
		curVal = fmemPtr
	} else {
		if writing && n <= spaceShrinkCode &&
			n >= spaceCode && fontGlue[f] != null {
			deleteGlueRef(fontGlue[f])
			fontGlue[f] = null
		}
		if n > fontParams[f] {
			if f < fontPtr {
				curVal = fmemPtr
			} else {
				@<마지막 글꼴의 매개변수 수를 늘린다@>
			}
		} else {
			curVal = n + paramBase[f]
		}
	}
	@<|curVal=fmemPtr|면 오류 메시지를 낸다@>
}

@ 매개변수 번호가 범위를 벗어났으면 오류를 알린다.
@<|curVal=fmemPtr|면...@>=
if curVal == fmemPtr {
	printErr("Font ")
	printEsc(fontIDText(f))
	printStr(" has only ")
	printInt(fontParams[f])
	printStr(" fontdimen parameters")
@.Font x has only...@>
	help2("To increase the number of font parameters, you must",
		"use \\fontdimen immediately after the \\font is loaded.")
	reportError()
}

@ 가장 최근에 실은 글꼴이면 |fontInfo|의 끝에 0인 매개변수를 덧붙여 |n|번째 매개변수까지 만든다.
@<마지막 글꼴의 매개변수...@>=
for {
	if fmemPtr == fontMemSize {
		overflow("font memory", fontMemSize)
	}
@:TeX capacity exceeded font memory}{\quad font memory@>
	fontInfo[fmemPtr].sc = 0
	fmemPtr++
	fontParams[f]++
	if n == fontParams[f] {
		break
	}
}
curVal = fmemPtr - 1 // 이것은 |paramBase[f]+fontParams[f]|와 같다

@ \TeX은 글꼴에 없는 문자를 조판하려 하면 문자 노드를 만들지 않는다. 그러므로 출력 루틴은 문자 노드를 보면 그 문자가 글꼴에
있다고 믿어도 된다. 다음 프로시저는 사용자가 막지 않았다면, 곧 \.{\\tracinglostchars}가 양수이면 경고 메시지를 찍는다.

@<함수들@>=
func charWarning(f internalFontNumber, c eightBits) {
	if tracingLostChars() > 0 {
		beginDiagnostic()
		printNl("Missing character: There is no ")
@.Missing character@>
		printASCII(c)
		printStr(" in font ")
		slowPrint(fontName[f])
		printChar('!')
		endDiagnostic(false)
	}
}

@ 다음은 주어진 글꼴의 주어진 문자로 문자 노드를 만들어 그 포인터를 돌려주는 함수다. 그 문자가 글꼴에 없으면 경고를
찍고 |null|을 돌려준다.

@<함수들@>=
func newCharacter(f internalFontNumber, c eightBits) pointer {
	var p pointer // 새로 할당한 노드
	if fontBc[f] <= c {
		if fontEc[f] >= c {
			if charExists(charInfo(f, qi(c))) {
				p = getAvail()
				setFontField(p, f)
				setCharacter(p, qi(c))
				return p
			}
		}
	}
	charWarning(f, c)
	return null
}

@* 장치 독립 파일 형식.
\TeX\ 실행이 내놓는 가장 중요한 결과물은 ``장치 독립''(\.{DVI}) 파일이다. 이 파일은 문자와 괘선이 인쇄된 쪽의 어디에
놓여야 하는지 알려 준다. 형식은 데이비드 R. 퍽스가 1979년에 설계했다. \.{DVI} 파일을 읽는 프로그램으로 거의 모든 쓸 만한
@^Fuchs, David Raymond@>
@^DVI files@>
조판 장치를 몰 수 있으며, 그런 ``\.{DVI}를 무엇으로든 바꾸는'' 프로그램이 이미 수십 개나 만들어졌다. 그래서 \TeX을 장치에
얽매이지 않는 ``앞단''으로 쓰면, 그 출력을 온갖 장비로 인쇄할 수 있다.

\.{DVI} 파일은 8비트 바이트의 흐름이고, 기계어 같은 언어의 명령들이 줄지어 있는 것으로 볼 수 있다. 각 명령의 첫 바이트는
연산 코드이고, 그 뒤에 명령의 매개변수를 이루는 바이트가 0개 이상 온다. 매개변수 하나가 바이트 여럿을 차지할 수도 있다.
이를테면 `|setRule|' 명령에는 매개변수가 둘 있고, 저마다 네 바이트 길이다. 매개변수는 대개 음이 아닌 정수로 보지만, 네
바이트짜리 매개변수와 거리를 나타내는 더 짧은 매개변수는 양수일 수도 음수일 수도 있다. 그런 매개변수는 2의 보수로
나타낸다. 이를테면 두 바이트짜리 거리 매개변수의 값은 $-2^{15}$와 $2^{15}-1$ 사이에 있다. \.{TFM} 파일에서처럼, 바이트 여럿을
차지하는 수는 빅엔디언 순서로 적는다.

\.{DVI} 파일은 ``서문''(preamble), 그 뒤의 ``쪽'' 하나 이상, 그리고 마지막의 ``후문''(postamble)으로 이루어진다. 서문은
파일에 쓰인 치수의 단위를 정하는 매개변수들을 가진 |pre| 명령 하나다. 이것이 맨 처음에 와야 한다. ``쪽''은 저마다 |bop|
명령으로 시작해서, 물리적인 쪽의 어디에 문자들을 놓을지 알려 주는 다른 명령들(몇 개든)이 오고, |eop| 명령으로 끝난다. 쪽들은
\TeX이 만든 순서대로 나온다. 명령 |nop|과 \ID{fntDef}(이것들은 파일의 어느 두 명령 사이에도 올 수 있다)를 빼고 보면, |eop|
명령 바로 뒤에는 언제나 |bop|이나 |post|가 온다. 명령 |post|가 오면 더는 쪽이 없고, 남은 바이트들이 후문을 이룬다. 후문은
나중에 자세히 설명한다.

\.{DVI} 명령의 어떤 매개변수는 ``포인터''다. 포인터는 파일 안의 다른 바이트의 위치 번호를 주는 네 바이트짜리 양이다. 첫
바이트가 0번, 그다음이 1번이다. 이를테면 |bop| 명령의 매개변수 하나는 앞 |bop|을 가리킨다. 그래서 출력을 앞면이 위로
오게 쌓는 장치라면 쪽을 거꾸로 읽어 나갈 수 있다. \.{DVI} 파일의 서문이 바이트 0부터 99까지 차지한다고 하자. 첫 쪽이
바이트 100부터 999까지, 둘째 쪽이 바이트 1000부터 1999까지 차지한다면, 바이트 1000에서 시작하는 |bop|은 100을 가리키고
바이트 2000에서 시작하는 |bop|은 1000을 가리킨다. (맨 처음 |bop|, 곧 바이트 100에서 시작하는 것의 포인터는~$-1$이다.)

@ \.{DVI} 형식은 간결하면서도 기계가 쉽게 해석할 수 있도록 만든 것이다. 간결함은 정보의 대부분을 드러내 적지 않고 함축하는
방법으로 얻는다. \.{DVI}를 읽는 프로그램은 한 쪽의 명령들을 읽으면서 몇 가지 양을 기억한다. (a)~현재 글꼴 |f|는
정수다. 이 값은 \ID{fnt}와 \ID{fntNum} 명령으로만 바뀐다. (b)~쪽 위의 현재 위치는 가로 좌표와 세로 좌표라고 부르는 두 수
|h|와 |v|다. 두 좌표는 쪽의 왼쪽 위 모서리에서 0이다. 오른쪽으로 가면 가로 좌표가 커지고, 아래로 가면 세로 좌표가 커진다.
그러니 세로 방향이 뒤집힌 것만 빼면 데카르트 좌표와 같다. 좌표 |(h,v)|를 데카르트 좌표로 쓰면 |(h,-v)|다. (c)~현재의 간격
양은 네 수 |w|, |x|, |y|, |z|다. 그 가운데 |w|와~|x|는 가로 간격에, |y|와~|z|는 세로 간격에 쓴다. 같은 간격이 되풀이되면 매번
값을 적지 않고 이 변수를 다시 쓰라고만 하면 되므로 파일이 짧아진다. (d)~|(h,v,w,x,y,z)| 값을 쌓는 스택이 있다. \.{DVI}
명령 |push|와 |pop|으로 이 값들을 저장하고 되살린다. 상자 안으로 들어갈 때 |push|하고 나올 때 |pop|하는 식이다. 현재 글꼴~|f|는
스택에 쌓지 않는다는 데 눈여겨보자. 스택에는 위치에 관한 정보만 들어간다.

양 |h|, |v|, |w|, |x|, |y|, |z|의 값은 부호를 포함해 32비트까지의 부호 있는 정수다. 이것들은 물리적 거리를 나타내므로, |h|를~1
늘리면 오른쪽으로 아주 작은 거리를 움직인다는 뜻이 되도록 작은 측정 단위가 정해져 있다. 실제 측정 단위는 아래에서 설명하듯이
바꿀 수 있다. \TeX은 \.{DVI} 출력의 단위를 sp, 곧 눈금 포인트로 해서, \TeX의 자료 구조에 있는 모든 |scaled| 치수와 맞도록
한다.

@ 다음은 \.{DVI} 파일에 나타날 수 있는 모든 명령의 목록이다. 각 명령은 기호 이름(이를테면 |bop|), 연산 코드
바이트(이를테면 139), 그리고 (있다면) 매개변수로 지정된다. 매개변수 뒤에는 몇 바이트를 차지하는지 알려 주는
대괄호 속의 수가 온다. 이를테면 `|p[4]|'는 매개변수 |p|가 네 바이트 길이라는 뜻이다.

\yskip\hang|setChar0| 0. 글꼴~|f|의 문자 번호~0을 그 문자의 기준점이 |(h,v)|에 오도록 조판한다. 그런 다음 |h|를
그 문자의 너비만큼 늘린다. 문자의 너비가 0이거나 음수일 수 있으므로 이 명령 뒤에 |h|가 커진다고 확신할 수는
없지만, 대개 |h|는 커진다.

\yskip\hang\ID{setChar1}부터 \ID{setChar127}까지(연산 코드 1부터 127까지). 명령 |setChar0|의 연산을 하되, 문자~0
대신 번호가 연산 코드와 맞는 문자를 쓴다.

\yskip\hang|set1| 128 |c[1]|. 명령 |setChar0|과 같지만, 문자 번호~|c|를 조판한다. \TeX82는 범위 |128<=c<256|의 문자에
이 명령을 쓴다.

\yskip\hang|@!set2| 129 |c[2]|. 명령 |set1|과 같지만, |c|가~두 바이트 길이여서 범위 |0<=c<65536|에 있다. \TeX82는 이
명령을 결코 쓰지 않지만, 동양 언어를 다루는 \TeX의 확장에는 쓸모가 있을 것이다.
@^oriental characters@>@^Chinese characters@>@^Japanese characters@>

\yskip\hang|@!set3| 130 |c[3]|. 명령 |set1|과 같지만, |c|가~세 바이트 길이여서 $2^{24}-1$만큼 클 수 있다. 중국어조차 이렇게
많은 문자를 갖고 있지는 않지만, 이 명령은 아직 내다보지 못한 어떤 확장에 쓸모 있을지도 모른다.

\yskip\hang|@!set4| 131 |c[4]|. 명령 |set1|과 같지만, |c|가~네 바이트 길이다. 상상해 보라.

\yskip\hang|setRule| 132 |a[4]| |b[4]|. 높이가~|a|이고 너비가~|b|인 꽉 찬 검은 직사각형을 그 왼쪽 아래 모서리가
|(h,v)|에 오도록 조판한다. 그런 다음 |h=h+b|로 놓는다. 다만 |a<=0|이거나 |b<=0|이면 아무것도 조판하지 않아야 한다.
또 |b<0|이면 다른 아무 일도 일어나지 않더라도 |h|의 값은 줄어든다는 데 주목하라. \MF와의 일관성이 보장되도록 괘선을
조판하는 방법에 관한 자세한 것은 아래를 보라.

\yskip\hang|@!put1| 133 |c[1]|. 글꼴~|f|의 문자 번호~|c|를 그 문자의 기준점이 |(h,v)|에 오도록 조판한다. (`put'
명령들은 `set' 명령들과 똑같지만, 문자나 괘선을 내보내기만 하고 그 뒤에 기준점을 옮기지 않는다.)

\yskip\hang|@!put2| 134 |c[2]|. 명령 |set2|와 같지만, |h|를 바꾸지 않는다.

\yskip\hang|@!put3| 135 |c[3]|. 명령 |set3|과 같지만, |h|를 바꾸지 않는다.

\yskip\hang|@!put4| 136 |c[4]|. 명령 |set4|와 같지만, |h|를 바꾸지 않는다.

\yskip\hang|putRule| 137 |a[4]| |b[4]|. 명령 |setRule|과 같지만, |h|를 바꾸지 않는다.

\yskip\hang|nop| 138. 아무 연산도 하지 않는다. \.{DVI} 명령 사이에는 |nop|이 몇 개든 올 수 있지만, 명령과 그
매개변수 사이나 두 매개변수 사이에는 끼워 넣을 수 없다.

\yskip\hang|bop| 139 $c_0[4]$ $c_1[4]$ $\ldots$ $c_9[4]$ $p[4]$. 쪽의 시작: |(h,v,w,x,y,z)=(0,0,0,0,0,0)|으로 놓고
스택을 비운다. 현재 글꼴 |f|를 정의되지 않은 값으로 놓는다. 열 개의 $c_i$ 매개변수는 이 쪽에 대해 \.{\\shipout}을
불렀을 때 \TeX에 있던 \.{\\count0} $\ldots$ \.{\\count9}의 값을 담는다. 사용자가 \.{DVI} 파일의 일부만 인쇄하고
싶을 때 쪽을 알아보는 데 쓸 수 있다. 매개변수 |p|는 파일에서 앞 |bop|을 가리킨다. 첫 |bop|에서는 $p=-1$이다.

\yskip\hang|eop| 140. 쪽의 끝: 앞 |bop| 뒤로 읽은 것을 인쇄한다. 이 시점에 스택은 비어 있어야 한다. (대부분의
출력 장치를 모는 \.{DVI}를 읽는 프로그램은 방금 끝난 쪽에 나타나는 재료를 버퍼에 담아 두었을 것이다. 이 재료는
대부분 |v| 좌표 순서로, 그리고 (|v|가 같으면) |h|~좌표 순서로 되어 있지만 완전히 그렇지는 않다. 그래서 대개 해당
장치에 알맞은 어떤 순서로 정렬해야 한다.)

\yskip\hang|push| 141. 현재 값 |(h,v,w,x,y,z)|를 스택의 맨 위에 쌓는다. 이 값들은 하나도 바꾸지 않는다. 글꼴 |f|는 쌓지
않는다는 데 주목하라.

\yskip\hang|pop| 142. 스택의 맨 위 값 여섯 개를 꺼내 차례로 |(h,v,w,x,y,z)|에 대입한다. 명령 |pop|의 수는 결코
|push|의 수를 넘어서는 안 된다. 명령 |pop|을 만났을 때 스택이 비어 있으면 아주 난처할 것이기 때문이다.

\yskip\hang|right1| 143 |b[1]|. 오른쪽으로 |b|단위 움직인다. 곧 |h=h+b|로 놓는다. 매개변수는 2의 보수 표기의 부호
있는 수로서 |-128<=b<128|이다. 매개변수가 음수면 기준점은 왼쪽으로 움직인다.

\yskip\hang|@!right2| 144 |b[2]|. 명령 |right1|과 같지만, |b|는 범위 |-32768<=b<32768|의 두 바이트짜리 양이다.

\yskip\hang|@!right3| 145 |b[3]|. 명령 |right1|과 같지만, |b|는 범위 |@t$-2^{23}$@><=b<@t$2^{23}$@>|의 세 바이트짜리
양이다.

\yskip\hang|@!right4| 146 |b[4]|. 명령 |right1|과 같지만, |b|는 범위 |@t$-2^{31}$@><=b<@t$2^{31}$@>|의 네 바이트짜리
양이다.

\yskip\hang|w0| 147. 오른쪽으로 |w|단위 움직인다. 곧 |h=h+w|로 놓는다. 운이 좋으면 이 매개변수 없는 명령으로 대개 충분할
것이다. 같은 종류의 움직임이 잇달아 여러 번 일어나기 때문이다. 다음 명령들은 |w|가 어떻게 특정한 값을 얻는지
설명한다.

\yskip\hang|w1| 148 |b[1]|. 두 값을 |w=b|와 |h=h+b|로 놓는다. 매개변수 |b|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=b<128|이다. 이 명령은 현재의 |w|~간격을 바꾸고 오른쪽으로 |b|만큼 움직인다.

\yskip\hang|@!w2| 149 |b[2]|. 명령 |w1|과 같지만, |b|는 두 바이트 길이로 |-32768<=b<32768|이다.

\yskip\hang|@!w3| 150 |b[3]|. 명령 |w1|과 같지만, |b|는 세 바이트 길이로 |@t$-2^{23}$@><=b<@t$2^{23}$@>|이다.

\yskip\hang|@!w4| 151 |b[4]|. 명령 |w1|과 같지만, |b|는 네 바이트 길이로 |@t$-2^{31}$@><=b<@t$2^{31}$@>|이다.

\yskip\hang|x0| 152. 오른쪽으로 |x|단위 움직인다. 곧 |h=h+x|로 놓는다. 이 `|x|' 명령들은 `|w|' 명령들과 같지만, |w| 대신
|x|에 관계한다.

\yskip\hang|x1| 153 |b[1]|. 두 값을 |x=b|와 |h=h+b|로 놓는다. 매개변수 |b|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=b<128|이다. 이 명령은 현재의 |x|~간격을 바꾸고 오른쪽으로 |b|만큼 움직인다.

\yskip\hang|@!x2| 154 |b[2]|. 명령 |x1|과 같지만, |b|는 두 바이트 길이로 |-32768<=b<32768|이다.

\yskip\hang|@!x3| 155 |b[3]|. 명령 |x1|과 같지만, |b|는 세 바이트 길이로 |@t$-2^{23}$@><=b<@t$2^{23}$@>|이다.

\yskip\hang|@!x4| 156 |b[4]|. 명령 |x1|과 같지만, |b|는 네 바이트 길이로 |@t$-2^{31}$@><=b<@t$2^{31}$@>|이다.

\yskip\hang|down1| 157 |a[1]|. 아래로 |a|단위 움직인다. 곧 |v=v+a|로 놓는다. 매개변수는 2의 보수 표기의 부호 있는
수로서 |-128<=a<128|이다. 매개변수가 음수면 기준점은 위로 움직인다.

\yskip\hang|@!down2| 158 |a[2]|. 명령 |down1|과 같지만, |a|는 범위 |-32768<=a<32768|의 두 바이트짜리 양이다.

\yskip\hang|@!down3| 159 |a[3]|. 명령 |down1|과 같지만, |a|는 범위 |@t$-2^{23}$@><=a<@t$2^{23}$@>|의 세 바이트짜리
양이다.

\yskip\hang|@!down4| 160 |a[4]|. 명령 |down1|과 같지만, |a|는 범위 |@t$-2^{31}$@><=a<@t$2^{31}$@>|의 네 바이트짜리
양이다.

\yskip\hang|y0| 161. 아래로 |y|단위 움직인다. 곧 |v=v+y|로 놓는다. 운이 좋으면 이 매개변수 없는 명령으로 대개 충분할
것이다. 같은 종류의 움직임이 잇달아 여러 번 일어나기 때문이다. 다음 명령들은 |y|가 어떻게 특정한 값을 얻는지
설명한다.

\yskip\hang|y1| 162 |a[1]|. 두 값을 |y=a|와 |v=v+a|로 놓는다. 매개변수 |a|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=a<128|이다. 이 명령은 현재의 |y|~간격을 바꾸고 아래로 |a|만큼 움직인다.

\yskip\hang|@!y2| 163 |a[2]|. 명령 |y1|과 같지만, |a|는 두 바이트 길이로 |-32768<=a<32768|이다.

\yskip\hang|@!y3| 164 |a[3]|. 명령 |y1|과 같지만, |a|는 세 바이트 길이로 |@t$-2^{23}$@><=a<@t$2^{23}$@>|이다.

\yskip\hang|@!y4| 165 |a[4]|. 명령 |y1|과 같지만, |a|는 네 바이트 길이로 |@t$-2^{31}$@><=a<@t$2^{31}$@>|이다.

\yskip\hang|z0| 166. 아래로 |z|단위 움직인다. 곧 |v=v+z|로 놓는다. 이 `|z|' 명령들은 `|y|' 명령들과 같지만, |y| 대신 |z|에
관계한다.

\yskip\hang|z1| 167 |a[1]|. 두 값을 |z=a|와 |v=v+a|로 놓는다. 매개변수 |a|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=a<128|이다. 이 명령은 현재의 |z|~간격을 바꾸고 아래로 |a|만큼 움직인다.

\yskip\hang|@!z2| 168 |a[2]|. 명령 |z1|과 같지만, |a|는 두 바이트 길이로 |-32768<=a<32768|이다.

\yskip\hang|@!z3| 169 |a[3]|. 명령 |z1|과 같지만, |a|는 세 바이트 길이로 |@t$-2^{23}$@><=a<@t$2^{23}$@>|이다.

\yskip\hang|@!z4| 170 |a[4]|. 명령 |z1|과 같지만, |a|는 네 바이트 길이로 |@t$-2^{31}$@><=a<@t$2^{31}$@>|이다.

\yskip\hang|fntNum0| 171. 현재 글꼴을 |f=0|으로 놓는다. 글꼴 0은 아래에서 설명하듯이 \ID{fntDef} 명령으로 미리 정의되어
있어야 한다.

\yskip\hang\ID{fntNum1}부터 \ID{fntNum63}까지(연산 코드 172부터 234까지). 저마다 |f=1|, \dots,
\hbox{|f=63|}으로 놓는다.

\yskip\hang|fnt1| 235 |k[1]|. 현재 글꼴을 |f=k|로 놓는다. \TeX82는 범위 |64<=k<256|의 글꼴 번호에 이 명령을 쓴다.

\yskip\hang|@!fnt2| 236 |k[2]|. 명령 |fnt1|과 같지만, |k|가~두 바이트 길이여서 범위 |0<=k<65536|에 있다. \TeX82는 이
명령을 결코 만들지 않지만, 큰 글꼴 번호는 색이나 질감을 지정하는 데 쓸모 있을지도 모르고, 어떤 외부 코드 체계에서
번호가 정해진 특별한 글꼴에 쓰일 수도 있다.

\yskip\hang|@!fnt3| 237 |k[3]|. 명령 |fnt1|과 같지만, |k|가~세 바이트 길이여서 $2^{24}-1$만큼 클 수 있다.

\yskip\hang|@!fnt4| 238 |k[4]|. 명령 |fnt1|과 같지만, |k|가~네 바이트 길이다. 이것은 정말 큰 글꼴 번호(그리고 음의
번호)를 위한 것이다.

\yskip\hang|xxx1| 239 |k[1]| |x[k]|. 이 명령은 일반적으로는 정의되어 있지 않다. 특별한 \.{DVI}를 읽는 프로그램을
쓰지 않는 한 $(k+2)$바이트짜리 |nop|으로 작동한다. \TeX82는 충분히 짧은 \.{\\special}이 나타나면 |xxx1|을 만들고,
|k|를 보내는 바이트의 수로 놓는다. 문자열 |x|는 키워드 다음에 그 키워드에 관련된 매개변수가 올 수 있는 꼴이 되기를
권한다.

\yskip\hang|@!xxx2| 240 |k[2]| |x[k]|. 명령 |xxx1|과 같지만, |0<=k<65536|이다.

\yskip\hang|@!xxx3| 241 |k[3]| |x[k]|. 명령 |xxx1|과 같지만, |0<=k<@t$2^{24}$@>|이다.

\yskip\hang|xxx4| 242 |k[4]| |x[k]|. 명령 |xxx1|과 같지만, |k|는 터무니없이 클 수 있다. \TeX82는 길이가 256 이상인
문자열을 보낼 때 |xxx4|를 쓴다.

\yskip\hang|fntDef1| 243 |k[1]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<256|이다. 글꼴 정의는 곧 설명하겠다.

\yskip\hang|@!fntDef2| 244 |k[2]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<65536|이다.

\yskip\hang|@!fntDef3| 245 |k[3]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<@t$2^{24}$@>|이다.

\yskip\hang|@!fntDef4| 246 |k[4]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|@t$-2^{31}$@><=k<@t$2^{31}$@>|이다.

\yskip\hang|pre| 247 |i[1]| |num[4]| |den[4]| |mag[4]| |k[1]| |x[k]|. 서문의 시작. 이것은 파일의 맨 처음에 와야
한다. 매개변수 |i|, |num|, |den|, |mag|, |k|, |x|는 아래에서 설명한다.

\yskip\hang|post| 248. 후문의 시작. 아래를 보라.

\yskip\hang|postPost| 249. 후문의 끝. 아래를 보라.

\yskip\noindent 명령 250--255는 지금은 정의되어 있지 않다.

@ @<정의@>=
const (
	@!setChar0 = 0 // 문자 0을 조판하고 오른쪽으로 움직인다
	@!set1 = 128 // 문자를 조판하고 오른쪽으로 움직인다
	@!setRule = 132 // 괘선을 조판하고 오른쪽으로 움직인다
	@!putRule = 137 // 괘선을 조판한다
	@!nop = 138 // 아무 연산도 하지 않는다
	@!bop = 139 // 쪽의 시작
	@!eop = 140 // 쪽의 끝
	@!push = 141 // 현재 위치들을 저장한다
	@!pop = 142 // 앞 위치들을 되살린다
	@!right1 = 143 // 오른쪽으로 움직인다
	@!w0 = 147 // |w|만큼 오른쪽으로 움직인다
	@!w1 = 148 // 오른쪽으로 움직이고 |w|를 정한다
	@!x0 = 152 // |x|만큼 오른쪽으로 움직인다
	@!x1 = 153 // 오른쪽으로 움직이고 |x|를 정한다
	@!down1 = 157 // 아래로 움직인다
	@!y0 = 161 // |y|만큼 아래로 움직인다
	@!y1 = 162 // 아래로 움직이고 |y|를 정한다
	@!z0 = 166 // |z|만큼 아래로 움직인다
	@!z1 = 167 // 아래로 움직이고 |z|를 정한다
	@!fntNum0 = 171 // 현재 글꼴을 0으로 놓는다
	@!fnt1 = 235 // 현재 글꼴을 정한다
	@!xxx1 = 239 // \.{DVI} 원시 명령의 확장
	@!xxx4 = 242 // 길어질 수 있는 \.{DVI} 원시 명령의 확장
	@!fntDef1 = 243 // 글꼴 번호의 뜻을 정의한다
	@!pre = 247 // 서문
	@!post = 248 // 후문의 시작
	@!postPost = 249 // 후문의 끝
)

@ 서문에는 파일 전체에 관한 기본 정보가 들어 있다. 앞에서 말했듯이 매개변수가 여섯 개 있다.
$$\hbox{|@!i[1]| |@!num[4]| |@!den[4]| |@!mag[4]| |@!k[1]| |@!x[k]|.}$$
바이트 |i|는 \.{DVI} 형식의 판을 밝힌다. 지금은 언제나~2다. (값 |i=3|은 오른쪽에서 왼쪽으로 쓰는 조판과 왼쪽에서 오른쪽으로
쓰는 조판을 섞을 수 있는 확장 형식에 쓰고 있다. 언젠가 \.{DVI} 형식이 또 한 번 호환되지 않게 바뀌면, 아마 2048년쯤에, |i=4|로
놓을 것이다.)

다음 두 매개변수 |num|과 |den|은 측정 단위를 정하는 양의 정수다. 이것들은 \.{DVI} 파일의 모든 치수에 곱해서 $10^{-7}$미터 단위의
길이를 얻는 분수의 분자와 분모다. 길이 $\rm 7227{pt} = 254{cm}$이고 \TeX은 1포인트가 $2^{16}$\,sp인 눈금 포인트로 일하므로,
\TeX은 $|num|/|den|=(254\cdot10^5)/(7227\cdot2^{16})=25400000/473628672$로 놓는다.
@^sp@>

매개변수 |mag|는 \TeX이 \.{\\mag}라고 부르는 것, 곧 원하는 확대 배율의 1000배다. 그러므로 치수에 실제로 곱하는 분수는
$|mag|\cdot|num|/1000|den|$이다. \TeX\ 원본 문서가 `\.{true}' 치수를 하나도 쓰지 않는다면, 그 문서에서 \.{\\mag} 값만 바꾸어
조판해도 \TeX이 만드는 \.{DVI} 파일은 서문과 후문의 |mag| 값 말고는 전혀 달라지지 않는다는 데 눈여겨보자. (좋은 \.{DVI}
프로그램은 인쇄할 때 사용자가 |mag|~값을 무시할 수 있게 해 준다.)

마지막으로 |k|와 |x|는 \.{DVI} 파일을 쓰는 쪽이 주석을 넣을 수 있게 해 준다. 주석은 아무도 해석하지 않는다. 주석 |x|의 길이는
|k|이고, |0<=k<256|이다. \TeX은 여기에 작업 날짜를 적는다.

@<정의@>=
const @!idByte = 2 // 여기서 설명하는 종류의 \.{DVI} 파일을 밝힌다

@ 글꼴 번호 |k|를 정의하는 명령에는 매개변수
$$\hbox{|c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|}$$
이 더 들어 있다. 네 바이트짜리 값 |c|는 \TeX이 이 글꼴의 \.{TFM} 파일에서 찾은 검사합이다. 이 값은 이 \.{DVI} 파일을 읽는
프로그램들이 찾은 글꼴의 검사합과 같아야 한다.
@^check sum@>

매개변수 |s|는 글꼴 |k|의 문자 너비에 곱하는 고정 소수점 배율이다. \.{TFM} 파일이나 다른 글꼴 파일에 적힌 글꼴 치수들은 이
양에 대한 상대값인데, 이 양을 이 문서의 다른 곳에서는 ``at 크기''라고 부른다. 그 값은 언제나 양수이고 $2^{27}$보다 작다. 이
값은 다른 \.{DVI} 치수와 같은 단위로, 곧 \TeX82가 만든 파일이라면 sp 단위로 적는다. 매개변수 |d|도 |s|와 비슷하다. 이것은
``설계 크기''이고, (|s|처럼) \.{DVI} 단위로 적는다. 그러므로 글꼴 |k|는 원래 크기의 $|mag|\cdot s/1000d$배로 쓰인다.
이를테면 cmr10을 \.{at 12pt}로 쓰면 $s/d=1.2$다.

글꼴 정의의 나머지 부분은 글꼴의 외부 이름으로, 길이가 |a+l|인 {\mc ASCII} 문자열이다. 수 |a|는 ``영역''이나 디렉터리의
길이이고, |l|은 글꼴 이름 자체의 길이다. 길이 |a|가 0이면 그 지역의 표준 시스템 글꼴 영역을 쓰라는 뜻이다. 필드 |n|의
처음 |a|바이트에 영역이 들어 있다.

글꼴 정의는 그 글꼴 번호를 처음 쓰기 전에 나와야 한다. 글꼴 |k|를 한번 정의하면 다시 정의해서는 안 된다. 그러나 아래에서
보겠지만 글꼴 정의는 쪽들 안에도 나오고 후문에도 나오므로, 이런 뜻에서 글꼴 번호는 정의된다면 정확히 두 번 정의된다. 명령
|nop|처럼 글꼴 정의는 첫 |bop| 앞에도, |eop|와 |bop| 사이에도 나올 수 있다.

@ 때로는 가로 괘선이나 세로 괘선을 글꼴 문자의 어떤 부분과 정확히 맞추고 싶을 때가 있다. 다음 원칙들을 지키면 \.{DVI}
출력과 \MF가 만든 문자들이 정확히 맞도록 보장할 수 있다. (1)~\MF\ 문자에서 괘선과 맞추어야 할 아래쪽 가장자리나 왼쪽
가장자리는 기준점에, 곧 \MF\ 래스터의 0행과 0열에 오도록 그려야 한다. 그러면 화소 크기가 \.{DVI} 파일의 측정 단위의 정확한
배수가 아니더라도 괘선의 위치가 다르게 반올림되지 않는다. (2)~높이가 $a>0$이고 너비가 $b>0$인 괘선은, \MF\ 좌표가
|0<=x<@t$\alpha$@>b|와 |0<=y<@t$\alpha$@>a|를 만족하는 래스터 위치에만 꼭 맞게 검은 화소가 있는 \MF\ 문자와 같아야 한다.
여기서 $\alpha$는 \.{DVI} 단위당 화소 수다.
@^METAFONT@>
@^alignment of rules with characters@>
@^rules aligning with characters@>

@ \.{DVI} 파일의 마지막 쪽 뒤에는 `|post|'가 온다. 이 명령은 후문을 시작하는데, 후문에는 \TeX이 파일에 관해 모은 중요한 사실들이
간추려져 있어서 자료의 일부만 꽤 효율적으로 인쇄할 수 있게 해 준다. 후문의 꼴은 다음과 같다.
$$\vbox{\halign{\hbox{#\hfil}\cr
  |post| |p[4]| |num[4]| |den[4]| |mag[4]| |l[4]| |u[4]| |s[2]| |t[2]|\cr
  $\langle\,$글꼴 정의들$\,\rangle$\cr
  |postPost| |q[4]| |i[1]| 223들$[\ge4]$\cr}}$$
여기서 |p|는 파일의 마지막 |bop|을 가리키는 포인터다. 다음 세 매개변수 |num|, |den|, |mag|는 서문에 있던 값을 그대로 베낀
것이다.

매개변수 |l|과 |u|는 각각 가장 높은 쪽의 높이 더하기 깊이와 가장 넓은 쪽의 너비를, 파일의 다른 치수와 같은 단위로 준다.
\.{DVI}를 읽는 프로그램은 이 수들을 써서 쪽들을 큰 필름이나 종이 위에 배치할 수 있다. 그러나 보통 크기의 종이에 출력할 때의
표준 관례는 쪽마다 왼쪽 위 모서리를 종이의 왼쪽과 위에서 정확히 1인치 떨어지게 놓는 것이다. 경험에 비추어 보면, 출력을
영리하게 가운데 맞추려 드는 \.{DVI}-프린터 소프트웨어를 만드는 것은 현명하지 못하다. 왼쪽 위 모서리의 위치를 고정해 두는
편이 사용자가 이해하고 다루기에 가장 쉽다. 그래서 |l|과~|u|는 흔히 무시된다.

매개변수 |s|는 이 파일을 처리하는 데 필요한 스택의 최대 깊이(곧 |push| 명령이 |pop| 명령보다 가장 많이 앞선 수)다. 그다음은
파일에 든 쪽(|bop| 명령)의 총수 |t|다.

그 뒤에 글꼴 정의들이 온다. 앞에서 설명한 \ID{fntDef} 명령이 몇 개든 오고, 그 사이사이에 |nop| 명령이 낄 수 있다. \.{DVI}
파일에 쓰인 글꼴 번호는 저마다 정확히 두 번 정의되어야 한다. 한 번은 \ID{fnt} 명령으로 처음 골라지기 전에, 또 한 번은
후문에서.

@ 글꼴 정의의 끝을 알리는 |postPost| 바이트 다음, 후문의 마지막 부분에는 후문을 시작한 |post| 명령을 가리키는 포인터 |q|가
들어 있다. 그다음에는 식별 바이트 |i|가 오는데, 지금은 서문에서처럼~2다.

바이트 |i| 뒤에는 십진수 223(곧 팔진수 \.{'337})인 바이트가 넷 이상 온다. \TeX은 파일 전체의 길이가 4바이트의 배수가 될 때까지
이 꼬리 바이트를 넷에서 일곱 개 내보낸다. 낱말 하나에 네 바이트를 꾸려 넣는 기계에서는 그것이 가장 잘 맞기 때문이다.
그러나 넷 이상이기만 하면 223이 몇 개든 괜찮다. 223은 사실상 맨 끝에 덧붙이는 일종의 서명이다.
@^Fuchs, David Raymond@>

\.{DVI} 파일을 이렇게 신기한 방법으로 끝맺으면, \TeX은 후문을 마지막에 쓰는데도 \.{DVI}를 읽는 프로그램은 대부분의
컴퓨터에서 후문을 먼저 찾을 수 있다. 대부분의 운영체제는 파일의 낱말이나 바이트를 아무 데나 골라 읽게 해 주므로, \.{DVI}를
읽는 쪽은 파일 끝에서 시작해서 식별 바이트가 나올 때까지 223들을 거슬러 건너뛸 수 있다. 그다음 네 바이트를 되돌아가 |q|를
읽고, 파일의 바이트 |q|로 옮겨 간다. 물론 그 바이트는 248(|post|)이어야 한다. 이제 후문을 읽을 수 있으므로, \.{DVI}를 읽는
쪽은 쪽들을 조판하는 데 필요한 모든 정보를 알아낼 수 있다. 또 |bop|의 포인터를 따라 \.{DVI} 파일을 꽤 빠르게 건너뛰며
특정한 쪽을 찾을 수도 있다는 데 눈여겨보자. 실제로 쓰는 \.{DVI} 파일은 큰 편이어서, 그렇게 하면 시간이 많이 절약된다.

그러나 불행히도 파일의 아무 위치나 읽는 능력이 없고, 파일의 길이를 알아내는 능력조차 없는 시스템도 있다. 요즘은 거의 모든
@^system dependencies@>
시스템이 그런 능력을 주므로, \.{DVI} 형식은 현대 운영체제에서 가장 효율적으로 돌아가도록 설계되었다. 그래도 그런 제약
아래에서 \.{DVI} 파일을 처리해야 한다면 그냥 앞에서 뒤로 읽으면 된다. 필요한 머리 정보는 서문과 글꼴 정의에 다 들어 있기
때문이다. (후문에만 나오는 매개변수 |l|, |u|, |s|, |t|는 편리하지만 꼭 필요하지는 않은 ``장식''이다.)

@* 쪽 내보내기.
\TeX의 눈과 위를 살펴보았으니, 이제 창자에 이르렀다.
@^bowels@>

프로시저 |shipOut|은 상자를 가리키는 포인터를 받아서, 그 상자를 \.{DVI} 꼴로 기술한 ``쪽'' 하나를 |dviFile|에 쓴다.
\.{DVI} 좌표 $(h,v)=(0,0)$은 내보내는 상자의 왼쪽 위 모서리에 해당해야 한다.

상자 안에 상자가 있고 그 안에 또 상자가 있을 수 있으므로, |shipOut|의 주된 일은 서로를 부르는 두 루틴 |hlistOut|과
|vlistOut|이 맡는다. 이 루틴들은 가로 상자와 세로 상자 안의 가로 목록과 세로 목록을 훑으며, 문자와 괘선을 만날 때마다
알맞은 \.{DVI} 명령을 내보낸다.

쪽을 하나씩 처리하면서 쪽 전체에 관한 정보도 모아 두어야 한다. 그런 통계는 후문에 적어야 하기 때문이다. 전역 변수
|totalPages|, |maxV|, |maxH|, |maxPush|, |lastBop|에 이 정보를 기록한다.

변수 |doingLeaders|는 리더를 출력하는 동안 |true|다. 변수 |deadCycles|에는 마지막 |shipOut| 뒤로 출력 루틴이 몇 번 시작했는지가
들어 있다. 출력 루틴이 아무것도 내보내지 않고 계속 돌면 끝없는 루프일 수 있으므로 이 수를 센다.

루틴 |vlistOut|과 |hlistOut|에서 쓰는 전역 변수 몇 개도 여기서 정의한다. 지역 변수로 둘 수도 있었지만, 그러면 상자가 깊이
중첩될 때 스택 공간이 낭비된다. 이 변수들의 값은 재귀 호출을 넘어 살아 있을 필요가 없기 때문이다.
@^recursion@>

@<전역 변수@>=
var @!totalPages int32 // 내보낸 쪽의 수
var @!maxV scaled // 지금까지 내보낸 쪽의 높이 더하기 깊이의 최댓값
var @!maxH scaled // 지금까지 내보낸 쪽의 너비의 최댓값
var @!maxPush int32 // 지금까지 만난 |push| 명령의 가장 깊은 중첩
var @!lastBop int32 // \.{DVI} 출력에서 앞 |bop|의 위치
var @!deadCycles int32 // 아무것도 내보내지 않은 최근 출력의 수
var @!doingLeaders bool // 리더 상자 안에 있나?
@#
var @!c, @!f quarterword // 현재 |charNode|의 문자와 글꼴
var @!ruleHt, @!ruleDp, @!ruleWd scaled // 지금 출력하는 괘선의 크기
var @!g pointer // 현재 글루 명세
var @!lq, @!lr int32 // 리더 계산에 쓰는 양들

@ 처음에는 아무 쪽도 내보내지 않았다. 출력 중첩의 깊이 |curS|는 $-1$로 시작한다.
@<핵심 변수들의...@>=
totalPages = 0
maxV = 0
maxH = 0
maxPush = 0
lastBop = -1
doingLeaders = false
deadCycles = 0
curS = -1

@ \.{DVI} 바이트는 출력 파일에 곧바로 쓰지 않고 버퍼에 모은다. 그러면 서브루틴을 부르는 비용을 줄일 수 있어 계산이 눈에
띄게 빨라진다. \.{DVI} 바이트를 내보내는 일은 \TeX의 안쪽 루프의 일부이기 때문이다. 이점이 하나 더 있다. 버퍼에 아직 남아
있는 명령을 고쳐서 출력을 더 간결하게 만들 수 있다. 이를테면 `|down2|' 명령을 `|y2|'로 바꾸면 그 뒤의 같은 움직임에 한
바이트짜리 `|y0|' 명령을 쓸 수 있게 되어 두 바이트를 아낀다.

출력 버퍼는 크기가 같은 두 부분으로 나뉜다. 앞쪽 절반은 구간 |dviBuf[0 .. halfBuf-1]|이고, 뒤쪽 절반은 구간
|dviBuf[halfBuf..dviBufSize-1]|이다. 전역 변수 |dviPtr|는 다음 출력 바이트를 넣을 자리를 가리킨다. 이 포인터가 |dviLimit|에 이르면, 이제 덮어쓰게 될
반쪽 버퍼를 파일로 내보내고 |dviLimit|를 다른 값으로 바꾼다. 한계 |dviLimit|는 언제나 |halfBuf|나 |dviBufSize| 가운데
하나다. 그러므로 작업의 맨 처음을 빼면 버퍼에는 언제나 적어도 반쪽 버퍼만큼의 최근 출력이 남아 있다. 앞에서 말한 명령
고치기가 가능한 것은 이 때문이다.

\.{DVI} 파일의 바이트에는 0부터 차례로 번호를 매긴다. 다음에 만들 바이트의 번호는 |dviOffset+dviPtr|다. 번호가 |>=dviGone|인
바이트만 아직 버퍼에 있다.

@<전역 형@>=
type @!dviIndex = int32 // 출력 버퍼의 첨자; |0 .. dviBufSize|

@ 어떤 시스템에서는 |dviBuf|를 바이트 배열로 꾸려 두는 편이 더 효율적일 수 있다. 네 바이트를 한꺼번에 내보내기가 더 쉬울
수 있기 때문이다.
@^system dependencies@>

@<전역 변수@>=
var @!dviBuf [dviBufSize + 1]eightBits // \.{DVI} 출력을 위한 버퍼
var @!halfBuf dviIndex // |dviBufSize|의 절반
var @!dviLimit dviIndex // 현재 반쪽 버퍼의 끝
var @!dviPtr dviIndex // 쓸 수 있는 다음 버퍼 주소
var @!dviOffset int32 // |dviBufSize|에 출력 버퍼를 완전히 비운 횟수를 곱한 것
var @!dviGone int32 // 이미 |dviFile|에 출력한 바이트 수

@ 처음에는 버퍼 전체가 한 덩어리다. 처음으로 가득 찬 뒤에야 그 절반을 내보낸다.

@<핵심 변수들의...@>=
halfBuf = dviBufSize / 2
dviLimit = dviBufSize
dviPtr = 0
dviOffset = 0
dviGone = 0

@ 버퍼 구간 |dviBuf[a..b]|를 |dviFile|에 실제로 쓰는 일은 |writeDVI(a,b)|를 불러서 한다. 이 프로시저는 \TeX의 안쪽 루프의
일부이므로, 가장 좋은 결과를 얻으려면 시스템마다 될 수 있는 대로 빨리 돌도록 손보아야 한다. 프로시저 |writeDVI(a,b)|를 부를 때 |a|와
|b+1|은 둘 다 4의 배수라고 가정해도 안전하다. 그러니 많은 기계에서는 낱말 하나에 네 바이트를 꾸려 넣고 낱말의 배열을
시스템 호출 한 번으로 내보내는 효율적인 방법을 쓸 수 있다.
@^system dependencies@>
@^inner loop@>
@^defecation@>

@<함수들@>=
func writeDVI(a, b dviIndex) {
	var k dviIndex
	for k = a; k <= b; k++ {
		bPut(&dviFile, dviBuf[k])
	}
}

@ 바이트를 버퍼에 넣는 일은 작은 함수 |dviOut|이 한다. \GO/ 컴파일러는 이 함수를 부르는 곳에 펼쳐 넣으므로, 바이트마다
프로시저를 부르는 비용을 치르지 않는다. 버퍼의 한계에 이르면 |dviSwap|이 반쪽을 내보내고 한계를 다른 반쪽 끝으로 옮긴다.

@<함수들@>=
func dviOut(x int32) {
	dviBuf[dviPtr] = x
	dviPtr++
	if dviPtr == dviLimit {
		dviSwap()
	}
}

func dviSwap() { // 버퍼의 절반을 출력한다
	if dviLimit == dviBufSize {
		writeDVI(0, halfBuf-1)
		dviLimit = halfBuf
		dviOffset += dviBufSize
		dviPtr = 0
	} else {
		writeDVI(halfBuf, dviBufSize-1)
		dviLimit = dviBufSize
	}
	dviGone += halfBuf
}

@ 다음은 \TeX이 일을 다 마쳤을 때 버퍼를 비우는 방법이다. 그때 포인터 |dviPtr|는 4의 배수일 것이다. 앞쪽 절반이 나중에
쓰였을 수도 있으므로, 뒤쪽 절반이 남아 있으면 그것부터 내보낸다.

@<|dviBuf|의 마지막 바이트들을 비운다@>=
if dviLimit == halfBuf {
	writeDVI(halfBuf, dviBufSize-1)
}
if dviPtr > 0 {
	writeDVI(0, dviPtr-1)
}

@ 프로시저 |dviFour|는 산술 넘침의 위험 없이 네 바이트를 2의 보수 표기로 내보낸다.

인자 |x|가 음수이면 $2^{30}$을 두 번 더해 $x+2^{31}$을 만든다. 이 값은 넘치지 않고 음이 아니다. 그 첫 바이트에 128을 더하면
2의 보수 표현의 첫 바이트가 된다. 나머지 세 바이트는 그대로다.

@<함수들@>=
func dviFour(x int32) {
	if x >= 0 {
		dviOut(x / 0o100000000)
	} else {
		x += 0o10000000000
		x += 0o10000000000
		dviOut((x / 0o100000000) + 128)
	}
	x %= 0o100000000
	dviOut(x / 0o200000)
	x %= 0o200000
	dviOut(x / 0o400)
	dviOut(x % 0o400)
}

@ 루틴 |dviPop|은 출력을 조금 최적화한다. `|push|' 바로 뒤에 `|pop|'이 오면 둘 다 아무 일도 안 하는 것과 같으므로, 그런 짝은
지우고 그럴 수 없을 때에만 |pop|을 낸다. 이 루틴의 매개변수는 짝이 되는 옛 |push| 바로 다음 바이트의 주소다. 그 주소가
지금 출력 위치와 같으면 그 사이에 아무것도 나가지 않은 것이므로 |push|를 지운다.

@<함수들@>=
func dviPop(l int32) {
	if l == dviOffset+dviPtr && dviPtr > 0 {
		dviPtr--
	} else {
		dviOut(pop)
	}
}

@ 다음은 글꼴 정의를 내보내는 프로시저다. \TeX82는 작업 하나에 서로 다른 글꼴을 많아야 256개만 쓰므로 명령 코드로는 언제나
|fntDef1|을 쓴다.

@<함수들@>=
func dviFontDef(f internalFontNumber) {
	var k poolPointer // |strPool|의 첨자
	dviOut(fntDef1)
	dviOut(f - fontBase - 1)
	dviOut(qo(fontCheck[f].b0))
	dviOut(qo(fontCheck[f].b1))
	dviOut(qo(fontCheck[f].b2))
	dviOut(qo(fontCheck[f].b3))
	dviFour(fontSize[f])
	dviFour(fontDsize[f])
	dviOut(length(fontArea[f]))
	dviOut(length(fontName[f]))
	@<내부 번호가 |f|인 글꼴의 이름을 출력한다@>
}

@ 글꼴 이름은 영역과 이름을 차례로 내보낸다.
@<내부 번호가 |f|인...@>=
for k = strStart[fontArea[f]]; k <= strStart[fontArea[f]+1]-1; k++ {
	dviOut(so(strPool[k]))
}
for k = strStart[fontName[f]]; k <= strStart[fontName[f]+1]-1; k++ {
	dviOut(so(strPool[k]))
}

@ \seclabel{yz-matches}작은 컴퓨터에 쓸 \TeX이라면 이 프로그램의 다음 몇 부분에 나오는 착상은 빼도 좋다. 명령 |w0|, |x0|,
|y0|, |z0|로 \.{DVI} 코드를 최적화하는 것이 꼭 필요하지는 않기 때문이다. 게다가 이제 설명할 알고리즘이 \.{DVI} 코드의 길이를
최적으로 줄인다고 내세우지도 않는다. 결국 간결함보다는 속도가 더 중요하다. 그래도 이 방법은 놀랍도록 효과적이고, 시간도
비교적 적게 든다.

기본 생각을 가장 잘 이해하려면 본질은 같으면서 더 간단한 문제를 먼저 살펴보면 된다. 숫자들의 나열, 이를테면
$3\,1\,4\,1\,5\,9\,2\,6\,5\,3\,5\,8\,9$가 주어졌을 때, 숫자마다 첨자 $d$, $y$, $z$ 가운데 하나를 붙여서 ``$y$-맞음''과
``$z$-맞음''의 수를 최대로 하고 싶다. 여기서 $y$-맞음이란 첨자가 $y$인 같은 숫자가 두 번 나오는데 그 사이에 다른 $y$가 끼지
않은 경우를 말하고, $z$-맞음도 비슷하게 정의한다. 이를테면 위의 나열에는 다음과 같이 첨자를 붙일 수 있다.
$$3_z\,1_y\,4_d\,1_y\,5_y\,9_d\,2_d\,6_d\,5_y\,3_z\,5_y\,8_d\,9_d.$$
여기에는 $y$-맞음이 셋($1_y\ldots1_y$와 $5_y\ldots5_y\ldots5_y$), $z$-맞음이 하나($3_z\ldots3_z$) 있다. 숫자 $9_d$가 두 번 나오는
사이에 $d$들이 있으므로 $d$-맞음은 없지만, $d$-맞음은 세지 않으므로 상관없다. 이 첨자들은 \ID{down}, $y$, $z$라는 \.{DVI}
명령에 해당하고, 숫자들은 서로 다른 세로 움직임의 양에 해당한다. 그리고 $y$-맞음이나 $z$-맞음은 \.{DVI} 파일에서 한
바이트짜리 명령 |y0|이나 |z0|을 쓸 기회에 해당한다. 두 줄 사이의 간격처럼 같은 움직임이 되풀이되는 일이 많으므로 이것이
효과가 크다.

\TeX이 첨자를 붙이는 방법은 다음과 같다. 나열의 오른쪽에 새 숫자, 이를테면 $\delta$를 덧붙인다. 그리고 다음 가운데 하나가
일어날 때까지 나열을 거슬러 훑는다. (a)~$\delta_y$나 $\delta_z$를 보았고, 그것이 각각 $y$나 $z$ 첨자를 처음 만난 것이다. 그러면
새 $\delta$에 $y$나 $z$를 붙인다. 맞음을 하나 얻었다. (b)~$\delta_d$를 보았고, 이번 찾기에서 아직 $y$ 첨자를 하나도 만나지
않았다. 그러면 앞의 $\delta_d$를 $\delta_y$로 바꾸고(이것은 출력 버퍼의 명령을 고치는 것에 해당한다) 새 $\delta$에 $y$를
붙인다. 또 하나의 맞음이다. (c)~$\delta_d$를 보았고, $y$ 첨자는 보았지만 $z$는 보지 않았다. 앞의 $\delta_d$를 $\delta_z$로
바꾸고 새 $\delta$에 $z$를 붙인다. (d)~알맞은 $\delta$를 만나기 전에 $y$와 $z$ 첨자를 둘 다 만났거나, 나열의 맨 앞까지 다
훑었다. 새 $\delta$에 $d$를 붙인다. 이 첨자는 나중에 바뀔 수도 있다.

위의 예의 첨자 $3_z\,1_y\,4_d\ldots\,$는 사실 이 절차로 만든 것이다. 독자는 확인해 볼 수 있다. (어서 해 보라.)

확인한 결과를 그림으로 그리면 다음과 같다. 위의 호들은 $y$-맞음이고 아래의 호는 $z$-맞음이다. 호의 왼쪽 끝에서는
매개변수가 있는 명령(|y1|이나 |z1| 따위)이 $y$나 $z$의 값을 정하고, 오른쪽 끝마다 \.{DVI} 파일에서 매개변수 없는 한
바이트짜리 명령 |y0|이나 |z0|을 쓸 수 있다. 이 보기에서는 움직임 열세 번 가운데 네 번이 한 바이트로 줄어든다.
$$\mplibcode
beginfig(14);
save u, dg, sb; numeric u; u := 26pt; string dg[], sb[];
dg0:="3"; dg1:="1"; dg2:="4"; dg3:="1"; dg4:="5"; dg5:="9"; dg6:="2";
dg7:="6"; dg8:="5"; dg9:="3"; dg10:="5"; dg11:="8"; dg12:="9";
sb0:="z"; sb1:="y"; sb2:="d"; sb3:="y"; sb4:="y"; sb5:="d"; sb6:="d";
sb7:="d"; sb8:="y"; sb9:="z"; sb10:="y"; sb11:="d"; sb12:="d";
for i = 0 upto 12: label(textext("$" & dg[i] & "_" & sb[i] & "$"), (i*u, 0)); endfor
def yarc(expr a, b) = drawarrow (a*u,8pt){dir 50} .. {dir -50}(b*u,8pt) enddef;
def zarc(expr a, b) = drawarrow (a*u,-8pt){dir -40} .. {dir 40}(b*u,-8pt) enddef;
yarc(1,3); yarc(4,8); yarc(8,10); zarc(0,9);
label.top(btex \eightpoint $y$-맞음 etex, (6u, 40pt));
label.bot(btex \eightpoint $z$-맞음 etex, (4.5u, -50pt));
endfig;
\endmplibcode$$

@ 이 생각을 구현하려고 \TeX은 현재 쪽에서 만든 \ID{down}, $y$, $z$ 명령을 가리키는 포인터들의 스택을 둔다. \ID{right},
|w|, |x| 명령에도 비슷한 스택이 있다. 이 둘을 아래 스택과 오른쪽 스택이라고 부르고, 그 맨 위 원소는 변수 |downPtr|와
|rightPtr|에 둔다. 앞 절의 숫자 나열이 바로 이 스택이다. 다만 맨 위가 나열의 오른쪽 끝이다.

스택의 항목에는 필드가 넷 있다. 필드 |width|는 아래나 오른쪽으로 움직이는 양이다. 필드 |location|은 해당 \.{DVI} 명령의
바이트 번호다(|dviOffset|까지 포함한 번호다). 필드 |link|는 스택에서 바로 아래 항목을 가리킨다. 필드 |info|는 그
\.{DVI} 명령을 무엇으로 바꿀 수 있는지를 나타낸다.

@<전역 변수@>=
const @!movementNodeSize = 3 // 아래 스택과 오른쪽 스택의 항목마다의 낱말 수

func location(p pointer) int32        { return mem[p+2].sc } // 움직임 명령의 \.{DVI} 바이트 번호
func setLocation(p pointer, v int32) { mem[p+2].sc = v }

var @!downPtr, @!rightPtr pointer // 아래 스택과 오른쪽 스택의 머리

@ 처음에는 두 스택이 비어 있다.
@<핵심 변수들의...@>=
downPtr = null
rightPtr = null

@ 다음은 아래쪽이나 오른쪽 움직임 하나에 대한 \.{DVI} 명령을 만드는 서브루틴이다. 매개변수는 둘이다. 첫째 |w|는 움직임의 양이고,
|o|는 |down1|이나 |right1|이다. 명령 코드들이 |y1-down1=w1-right1|과 |z1-down1=x1-right1|이라는 편리한 산술 성질을 지닌다는
것을 써먹으므로, 한 루틴으로 세로와 가로 움직임을 모두 처리할 수 있다. 먼저 새 항목을 스택에 쌓고, 같은 양의 움직임을
앞에서 찾아 맞음을 얻을 수 있는지 본다. 맞음을 얻으면 한 바이트짜리 명령을, 얻지 못하면 양의 크기에 맞는 가장 짧은
\ID{down}이나 \ID{right} 명령을 내보낸다.

레이블 \ID{lastTwoBytes}와 \ID{lastByte}로 가면 움직임의 양 가운데 마지막 두 바이트나 마지막 한 바이트를
내보낸다(\secref{movement}).

@<함수들@>=
func movement(w scaled, o eightBits) {
	var mstate smallNumber // |y|나 |z|를 보았나?
	var p, q pointer // 스택의 현재 노드와 맨 위 노드
	var k int32 // |dviBuf|의 첨자, |dviBufSize|를 법으로
	q = getNode(movementNodeSize) // 스택의 맨 위를 위한 새 노드
	setWidth(q, w)
	setLocation(q, dviOffset+dviPtr)
	if o == down1 {
		setLink(q, downPtr)
		downPtr = q
	} else {
		setLink(q, rightPtr)
		rightPtr = q
	}
	@<다른 스택 항목들을 보고, 노드 |p|가 ``맞음''이면 |goto found|@>
	@<|w|에 대한 |down|이나 |right| 명령을 만들고 |return|@>
found:
	@<앞에 나타난~|w|를 다시 쓰도록 |y0|이나 |z0| 명령을 만든다@>
}

@ 아래 스택이나 오른쪽 스택 항목의 |info| 필드는 여섯 가지 값을 가질 수 있다. 값 |yHere|나 |zHere|는 그 \.{DVI} 명령이 각각
|y|나 |z|(가로 움직임이라면 |w|나 |x|)를 쓴다는 뜻이다. 값 |yzOK|는 그 명령이 \ID{down}(또는 \ID{right})이지만 |y|로도
|z|로도(또는 |w|나 |x|로) 바꿀 수 있다는 뜻이다. 값 |yOK|는 그것이 \ID{down}이고 |y|로는 바꿀 수 있지만 |z|로는 바꿀 수
없다는 뜻이다. 값 |zOK|도 비슷하다. 값 |dFixed|는 그것이 \ID{down}으로 남아야 한다는 뜻이다.

앞에서 말한 숫자에 첨자 붙이기 문제를 풀기만 한다면 네 값 |yzOK|, |yOK|, |zOK|, |dFixed|를 서로 구별할 필요가 없을 것이다.
그러나 \TeX에서는 |push|와 |pop| 명령의 중첩 구조 때문에 일이 복잡해진다. 명령 |pop|을 하면 |y|와 |z|가 |push| 이전 값으로 되돌아가기
때문이다. 그래서 숫자에 첨자 붙이기 문제에 괄호를 더하고, $\delta_y\ldots \delta_y$를 맞음이라고 하려면 사이에 있는 모든 $y$가
제대로 중첩된 괄호 안에 있고 오른쪽 $\delta_y$의 괄호 수준이 왼쪽 것과 같거나 더 깊어야 한다고 다시 정의하자. `('와 `)'는
`|push|'와 `|pop|'에 해당한다. 이제 나열
$$2_y\,7_d\,1_d\,(\,8_z\,2_y\,8_z\,)\,1$$
의 마지막 1에 첨자를 붙이고 싶다면, 앞의 $1_d$를 $1_y$로 바꿀 수는 없다. 그러면 $2_y\ldots2_y$ 맞음이 깨지기 때문이다. 그러나
$1_z$로는 바꿀 수 있다. 사이에 있는 $8_z$들은 괄호 안에 있으므로 맞음이 깨지지 않는다.

아래의 프로그램은 |push| 뒤에 들어온 움직임 노드들을, 그에 해당하는 |pop|을 내보내기 전에 지운다.

@<정의@>=
const (
	@!yHere = iota + 1 // 움직임 항목이 |y| 명령을 가리킬 때의 |info|
	@!zHere // 움직임 항목이 |z| 명령을 가리킬 때의 |info|
	@!yzOK // 제약 없는 \ID{down} 명령에 해당하는 |info|
	@!yOK // |z|가 될 수 없는 \ID{down}에 해당하는 |info|
	@!zOK // |y|가 될 수 없는 \ID{down}에 해당하는 |info|
	@!dFixed // 바뀔 수 없는 \ID{down}에 해당하는 |info|
)

@ 프로시저 |movement|가 레이블 |found|에 이르면 |info(p)|는 |yHere|나 |zHere|다. 이를테면 그것이 |yHere|이면 이 프로시저는
|y0| 명령(또는 |w0| 명령)을 내보내고, |q|와 |p| 사이의 모든 |info| 필드에 그 범위에서는 이제 |y|를 쓰면 안 된다고 표시한다.
그 사이의 명령을 |y|로 바꾸면 방금 얻은 맞음이 깨지기 때문이다.

@<앞에 나타난~|w|를 다시...@>=
setInfo(q, info(p))
if info(q) == yHere {
	dviOut(o + y0 - down1) // |y0|이나 |w0|
	for link(q) != p {
		q = link(q)
		switch info(q) {
		case yzOK: setInfo(q, zOK)
		case yOK: setInfo(q, dFixed)
		default: // 아무것도 하지 않는다
		}
	}
} else {
	dviOut(o + z0 - down1) // |z0|이나 |x0|
	for link(q) != p {
		q = link(q)
		switch info(q) {
		case yzOK: setInfo(q, yOK)
		case zOK: setInfo(q, dFixed)
		default: // 아무것도 하지 않는다
		}
	}
}

@ \seclabel{movement}맞음을 얻지 못하면 \ID{down}이나 \ID{right} 명령을 내보낸다. 양의 크기에 따라 매개변수의 바이트 수를
1부터 4까지 고르고, 음수는 2의 보수로 바꾼다.

@<|w|에 대한 |down|이나...@>=
setInfo(q, yzOK)
if abs(w) >= 0o40000000 {
	dviOut(o + 3) // |down4|나 |right4|
	dviFour(w)
	return
}
if abs(w) >= 0o100000 {
	dviOut(o + 2) // |down3|나 |right3|
	if w < 0 {
		w += 0o100000000
	}
	dviOut(w / 0o200000)
	w %= 0o200000
	goto lastTwoBytes
}
if abs(w) >= 0o200 {
	dviOut(o + 1) // |down2|나 |right2|
	if w < 0 {
		w += 0o200000
	}
	goto lastTwoBytes
}
dviOut(o) // |down1|나 |right1|
if w < 0 {
	w += 0o400
}
goto lastByte
lastTwoBytes:
dviOut(w / 0o400)
lastByte:
dviOut(w % 0o400)
return

@ 스택을 훑어 나가는 동안 우리는 |yHere|나 |zHere| 노드를 만났는지에 따라 |ySeen|, |zSeen|, |noneSeen| 가운데 한 상태에 있다.
빨리 결정할 수 있도록 이 상태들은 6의 배수로 나타내어 |info| 필드에 더할 수 있게 했다. 그러면 상태와 |info|의 짝 하나를
|switch| 하나로 가를 수 있다.
@^inner loop@>

@<다른 스택 항목들을 보고...@>=
p = link(q)
mstate = noneSeen
for p != null {
	if width(p) == w {
		@<너비가 맞는 노드를 살피고, 맞음이면 |goto found|@>
	} else {
		switch mstate + info(p) {
		case noneSeen + yHere: mstate = ySeen
		case noneSeen + zHere: mstate = zSeen
		case ySeen + zHere, zSeen + yHere: goto notFound
		default: // 아무것도 하지 않는다
		}
	}
	p = link(p)
}
notFound:

@ @<정의@>=
const (
	@!noneSeen = 0 // 아직 |yHere|나 |zHere| 노드를 만나지 않았다
	@!ySeen = 6 // |yHere|는 보았지만 |zHere|는 보지 않았다
	@!zSeen = 12 // |zHere|는 보았지만 |yHere|는 보지 않았다
)

@ 너비가 같은 항목을 찾았다. 상태와 그 항목의 |info|를 보고, 앞 절의 규칙 (a)--(d)에 따라 맞음을 얻을 수 있는지 정한다.
버퍼에서 이미 나가 버린 |y|나 |z| 바이트에서 올바른 맞음을 찾을 수도 있다. 그러나 영원히 나가 버린 바이트는 바꿀 수 없다.
``움직이는 손가락은 쓰고, $\ldots\,\,$.''

@<너비가 맞는 노드를...@>=
switch mstate + info(p) {
case noneSeen + yzOK, noneSeen + yOK, zSeen + yzOK, zSeen + yOK:
	if location(p) < dviGone {
		goto notFound
	}
	@<버퍼의 명령을 |y|나 |w|로 바꾸고 |goto found|@>
case noneSeen + zOK, ySeen + yzOK, ySeen + zOK:
	if location(p) < dviGone {
		goto notFound
	}
	@<버퍼의 명령을 |z|나 |x|로 바꾸고 |goto found|@>
case noneSeen + yHere, noneSeen + zHere, ySeen + zHere, zSeen + yHere:
	goto found
default: // 아무것도 하지 않는다
}

@ 버퍼에 남아 있는 \ID{down} 명령을 |y| 명령으로(또는 \ID{right}를 |w|로) 고친다. 버퍼는 순환하므로 위치를 |dviBufSize|로
나눈 나머지로 계산한다.
@<버퍼의 명령을 |y|나 |w|로...@>=
k = location(p) - dviOffset
if k < 0 {
	k += dviBufSize
}
dviBuf[k] = dviBuf[k] + y1 - down1
setInfo(p, yHere)
goto found

@ 마찬가지로 |z| 명령으로(또는 |x|로) 고친다.
@<버퍼의 명령을 |z|나 |x|로...@>=
k = location(p) - dviOffset
if k < 0 {
	k += dviBufSize
}
dviBuf[k] = dviBuf[k] + z1 - down1
setInfo(p, zHere)
goto found

@ 움직임 노드들이 언제 \TeX의 메모리에서 없어지는지 궁금하다면, 답은 이렇다. 루틴 |hlistOut|과 |vlistOut|이 상자 하나를 다
내보내기 바로 전에 그것들을 재활용한다. 그러면 아래 스택과 오른쪽 스택은 그 상자를 내보내기 전의 상태로 돌아간다. 다만
어떤 |info|는 더 엄격해져 있을 수 있다. 상자를 내보낸 뒤에는 |pop|으로 |w|, |x|, |y|, |z|가 상자 이전 값으로 돌아가므로, 상자
안에서 만든 항목은 더는 맞음에 쓸 수 없다.

@<함수들@>=
func pruneMovements(l int32) { // |location>=l|인 움직임 노드들을 지운다
	var p pointer // 지우는 노드
	for downPtr != null {
		if location(downPtr) < l {
			goto done
		}
		p = downPtr
		downPtr = link(p)
		freeNode(p, movementNodeSize)
	}
done:
	for rightPtr != null {
		if location(rightPtr) < l {
			return
		}
		p = rightPtr
		rightPtr = link(p)
		freeNode(p, movementNodeSize)
	}
}

@ 실제로 움직이고 싶은 거리는 따로따로인 움직임 여럿을 더한 것일 때가 많다. 이를테면 글루 노드 여럿이 잇달아 있을 수도
있고, 상자의 너비에 글루의 양을 더한 만큼 오른쪽으로 움직이고 싶을 수도 있다. 더 중요한 경우로, 기준선 간격은 글루와 이웃
상자들의 깊이와 높이로 계산되는데, \.{DVI} 파일에서는 이 세 양을 움직임 하나로 뭉뚱그리고 싶다.

그래서 \TeX은 전역 변수 두 쌍을 둔다. 한 쌍 |dviH|와 |dviV|는 실제로 \.{DVI} 파일에 내보낸 명령들이 가리키는 |h|와 |v| 좌표이고,
다른 한 쌍 |curH|와 |curV|는 출력 루틴들이 생각하는 현재 위치다. 위치가 바뀌면 |curH|와 |curV|에만 쌓아 두고 출력에는 바로
반영하지 않는다. 그러다가 정말 필요해지면, 이를테면 문자를 하나 놓기 직전에 |dviH=curH|나 |dviV=curV|가 되도록 프로시저
|movement|를 부른다. 이 일은 |synchH|와 |synchV|가 한다.

\.{DVI} 출력에 반영된 현재 글꼴은 |dviF|라고 부른다. `\ID{curF}' 변수는 필요 없다.

루틴 |hlistOut|과 |vlistOut|의 중첩 깊이는 |curS|라고 부른다. 이것은 본질적으로 \.{DVI} 출력에서 |push| 명령의 깊이다.

@<전역 변수@>=
func synchH() {
	if curH != dviH {
		movement(curH-dviH, right1)
		dviH = curH
	}
}

func synchV() {
	if curV != dviV {
		movement(curV-dviV, down1)
		dviV = curV
	}
}

var @!dviH, @!dviV scaled // \.{DVI}를 읽는 프로그램은 우리가 여기 있다고 생각한다
var @!curH, @!curV scaled // \TeX은 우리가 여기 있다고 생각한다
var @!dviF internalFontNumber // 현재 글꼴
var @!curS int32 // 출력 상자 중첩의 현재 깊이, 처음에는 $-1$

@ 쪽을 내보내기 시작할 때 변수들을 초기화한다. \.{DVI} 파일을 아직 열지 않았으면 열고, 첫 쪽이면 서문을 내보낸다. 서문에는
단위를 정하는 수와 \.{\\mag}, 그리고 `\.{ TeX output 1776.07.04:1200}' 같은 주석이 들어간다.
@<|shipOut|을 시작할 때 변수들을 초기화한다@>=
dviH = 0
dviV = 0
curH = hOffset()
dviF = nullFont
ensureDVIOpen()
if totalPages == 0 {
	dviOut(pre)
	dviOut(idByte) // 서문을 출력한다
@^preamble of \.{DVI} file@>
	dviFour(25400000)
	dviFour(473628672) // sp를 위한 변환 비율
	prepareMag()
	dviFour(mag()) // 확대 배율이 얼어붙는다
	oldSetting = selector
	selector = newString
	printStr(" TeX output ")
	printInt(year())
	printChar('.')
	printTwo(month())
	printChar('.')
	printTwo(day())
	printChar(':')
	printTwo(time() / 60)
	printTwo(time() % 60)
	selector = oldSetting
	dviOut(curLength())
	for s = strStart[strPtr]; s <= poolPtr-1; s++ {
		dviOut(so(strPool[s]))
	}
	poolPtr = strStart[strPtr] // 현재 문자열을 비운다
}

@ 프로시저 |hlistOut|이 불리면, |tempPtr|가 가리키는 |hlistNode|가 나타내는 상자를 내보내야 한다. 그 상자의 기준점의 좌표는
|(curH,curV)|다.

마찬가지로 |vlistOut|이 불리면, |tempPtr|가 가리키는 |vlistNode|가 나타내는 상자를 내보내야 한다. 그 상자의 기준점의 좌표도
|(curH,curV)|다.
@^recursion@>

두 프로시저는 서로를 부른다. 가로 목록 안의 세로 상자는 |vlistOut|으로, 세로 목록 안의 가로 상자는 |hlistOut|으로 내보낸다.

@ 재귀 프로시저 |hlistOut|과 |vlistOut|에는 저마다 지역 변수 |saveH|와 |saveV|가 있어서, 새 재귀 수준에 들어가기 바로 전의
|dviH|와 |dviV| 값을 담아 둔다. 사실상 \TeX의 실행 시간 스택에 쌓인 |saveH|와 |saveV|의 값들은, \.{DVI}를 읽는 프로그램이
|push|로 좌표 스택에 쌓을 |h|와 |v|의 값들에 해당한다.


@<함수들@>=
@<|hlistOut|과 |vlistOut|에 필요한 프로시저들을 선언한다@>
func hlistOut() { // |hlistNode| 상자를 출력한다
	var baseLine scaled // 이 상자의 기준선 좌표
	var leftEdge scaled // 이 상자의 왼쪽 좌표
	var saveH, saveV scaled // |dviH|와 |dviV|가 꺼내져 돌아갈 값
	var thisBox pointer // 둘러싼 상자를 가리키는 포인터
	var gOrder glueOrd // 글루에 적용되는 무한대의 차수
	var gSign int32 // 글루의 종류를 고른다; |normal..shrinking|
	var p pointer // 가로 목록의 현재 위치
	var saveLoc int32 // 들어올 때의 \.{DVI} 바이트 위치
	var leaderBox pointer // 되풀이하는 리더 상자
	var leaderWd scaled // 되풀이하는 리더 상자의 너비
	var lx scaled // 리더 상자 사이의 추가 간격
	var outerDoingLeaders bool // 리더를 하고 있었나?
	var edge scaled // 하위 상자의 왼쪽 가장자리, 또는 리더 공간의 오른쪽 가장자리
	var glueTemp float64 // 반올림하기 전의 글루 값
	var curGlue float64 // 지금까지 본 글루
	var curG scaled // |curGlue| 곱하기 글루 비율을 반올림한 값
	curG = 0; curGlue = floatConstant(0)
	thisBox = tempPtr; gOrder = glueOrder(thisBox)
	gSign = glueSign(thisBox); p = listPtr(thisBox)
	curS++
	if curS > 0 {
		dviOut(push)
	}
	if curS > maxPush {
		maxPush = curS
	}
	saveLoc = dviOffset + dviPtr; baseLine = curV; leftEdge = curH
	for p != null {
		@<|hlistOut|에서 노드 |p|를 출력하고 다음 노드로 옮겨 간다@>
	}
	pruneMovements(saveLoc)
	if curS > 0 {
		dviPop(saveLoc)
	}
	curS--
}

@ 프로시저 |hlistOut|의 이 부분은 \TeX의 안쪽 루프에 속하므로 효율에 특별히 마음을 써야 한다. 문자 노드 |charNode|를 만나면
|charNode|가 아닌 것에 이를 때까지 잇달아 처리해서 시간을 조금 아낀다. 코드가 128보다 작은 문자는 |setChar0=0|이라는 사실을
써서 문자 코드 자체를 명령 바이트로 내보낸다.
@^inner loop@>

다음 코드는 |hlistOut|에서 노드 |p|를 내보내고 다음 노드로 옮겨 가되, 조건 |curV=baseLine|을 지킨다.

@<|hlistOut|에서 노드 |p|를...@>=
reswitch:
if isCharNode(p) {
	synchH()
	synchV()
	for {
		f = font(p)
		c = character(p)
		if f != dviF {
			@<글꼴 |dviF|를 |f|로 바꾼다@>
		}
		if c >= qi(128) {
			dviOut(set1)
		}
		dviOut(qo(c))
		curH += charWidth(f, charInfo(f, c))
		p = link(p)
		if !isCharNode(p) {
			break
		}
	}
	dviH = curH
} else {
	@<|hlistOut|에서 |charNode|가 아닌 |p|를 출력하고 다음 노드로 옮겨 간다@>
}

@ 글꼴을 바꾸는 명령을 내보낸다. 이 글꼴을 처음 쓰는 것이면 먼저 글꼴 정의를 내보낸다. 글꼴 번호가 64 이하이면 한
바이트짜리 \ID{fntNum} 명령을 쓴다.
@<글꼴 |dviF|를 |f|로...@>=
if !fontUsed[f] {
	dviFontDef(f)
	fontUsed[f] = true
}
if f <= 64+fontBase {
	dviOut(f - fontBase - 1 + fntNum0)
} else {
	dviOut(fnt1)
	dviOut(f - fontBase - 1)
}
dviF = f

@ 문자가 아닌 노드를 종류에 따라 처리한다. 커닝과 수식 노드는 그 너비만큼 오른쪽으로 옮기기만 한다. 합자는 그 합자 문자를
문자 노드처럼 다룬다. 레이블 |finRule|, |movePast|, |nextP|는 이 절의 블록 안에 있고, 그리로 가는 |goto|는 모두 이 블록 안의
더 깊은 곳에 있다. \GO/는 이런 |goto|를 허용한다.

@<|hlistOut|에서 |charNode|가 아닌...@>=
switch typ(p) {
case hlistNode, vlistNode: @<가로 목록에서 상자를 출력한다@>
case ruleNode:
	ruleHt = height(p); ruleDp = depth(p); ruleWd = width(p)
	goto finRule
case whatsitNode: @<가로 목록에서 whatsit 노드 |p|를 출력한다@>
case glueNode: @<오른쪽으로 움직이거나 리더를 출력한다@>
case kernNode, mathNode: curH = curH + width(p)
case ligatureNode: @<노드 |p|를 |charNode|처럼 보이게 하고 |goto reswitch|@>
default: // 아무것도 하지 않는다
}
goto nextP
finRule: // 괘선의 처리를 마치려면 여기로 간다
@<가로 목록에서 괘선을 출력한다@>
movePast: // 글루나 괘선을 지나 나아갈 때 여기로 간다
curH += ruleWd
nextP: // 노드 |p|를 다 처리했으면 여기로 간다
p = link(p)

@ 가로 목록 안의 상자를 내보낸다. 빈 상자이면 너비만큼 지나가기만 한다. 그렇지 않으면 상자를 |shiftAmount|만큼 내려 재귀로
내보내고, 돌아오면 |dviH|와 |dviV|를 되살린 다음 상자의 너비만큼 오른쪽으로 간다.
@<가로 목록에서 상자를...@>=
if listPtr(p) == null {
	curH += width(p)
} else {
	saveH = dviH
	saveV = dviV
	curV = baseLine + shiftAmount(p) // 상자를 아래로 옮긴다
	tempPtr = p
	edge = curH
	if typ(p) == vlistNode {
		vlistOut()
	} else {
		hlistOut()
	}
	dviH = saveH
	dviV = saveV
	curH = edge + width(p)
	curV = baseLine
}

@ 가로 목록 안의 괘선을 내보낸다. 높이와 깊이가 흐르는 치수이면 둘러싼 상자의 것을 쓴다. \.{DVI}의 괘선은 왼쪽 아래 모서리를
기준으로 그리므로, 세로 위치를 기준선에서 깊이만큼 내린 다음 |setRule|을 내보낸다.
@<가로 목록에서 괘선을...@>=
if isRunning(ruleHt) {
	ruleHt = height(thisBox)
}
if isRunning(ruleDp) {
	ruleDp = depth(thisBox)
}
ruleHt += ruleDp // 이것이 괘선의 두께다
if ruleHt > 0 && ruleWd > 0 { // 빈 괘선은 출력하지 않는다
	synchH()
	curV = baseLine + ruleDp
	synchV()
	dviOut(setRule)
	dviFour(ruleHt)
	dviFour(ruleWd)
	curV = baseLine
	dviH += ruleWd
}

@ 글루만큼 오른쪽으로 움직인다. 글루를 늘이거나 줄였다면 지금까지의 늘어남이나 줄어듦을 |curGlue|에 쌓아 두고, 상자의 글루
비율을 곱해 지금까지의 글루 누계 |curG|를 다시 계산한다. 글루 노드 하나하나를 따로 반올림하지 않고 누계를 반올림하므로,
반올림 오차가 쌓이지 않는다. 글루의 값은 함수 |vetGlue|를 거쳐 |glueTemp|에 넣는다. 이 함수는 값이 $\pm10^9$을 넘으면 잘라
낸다. 지나치게 큰 글루 값은 |round|가 정수로 바꿀 수 없기 때문이다.

@<오른쪽으로 움직이거나...@>=
g = gluePtr(p)
ruleWd = width(g) - curG
if gSign != normal {
	if gSign == stretching {
		if stretchOrder(g) == gOrder {
			curGlue += float64(stretch(g))
			glueTemp = vetGlue(float(glueSet(thisBox)) * curGlue)
@^real multiplication@>
			curG = round(glueTemp)
		}
	} else if shrinkOrder(g) == gOrder {
		curGlue -= float64(shrink(g))
		glueTemp = vetGlue(float(glueSet(thisBox)) * curGlue)
		curG = round(glueTemp)
	}
}
ruleWd += curG
if subtype(p) >= aLeaders {
	@<가로 목록에서 리더를 출력하고, 괘선이면 |goto finRule|, 다 했으면 |goto nextP|@>
}
goto movePast

@ @<정의@>=
const @!billion = 1000000000.0 // |floatConstant(1000000000)|

func vetGlue(g float64) float64 {
	if g > billion {
		return billion
	} else if g < -billion {
		return -billion
	}
	return g
}

@ 가로 리더를 내보낸다. 괘선 리더이면 그냥 괘선 하나를 그린다. 상자 리더이면 상자를 되풀이해 놓는다. 너비에 10\,sp를 더하는
것은 글루를 부동 소수점으로 계산할 때의 작은 반올림 오차 때문에 상자가 하나 덜 들어가는 일을 막으려는 것이다.
@<가로 목록에서 리더를...@>=
leaderBox = leaderPtr(p)
if typ(leaderBox) == ruleNode {
	ruleHt = height(leaderBox)
	ruleDp = depth(leaderBox)
	goto finRule
}
leaderWd = width(leaderBox)
if leaderWd > 0 && ruleWd > 0 {
	ruleWd += 10 // 부동 소수점 반올림을 보정한다
	edge = curH + ruleWd
	lx = 0
	@<|curH|를 첫 상자의 위치로 놓고, |leaderWd+lx|를 상자 사이의 간격으로 놓는다@>
	for curH+leaderWd <= edge {
		@<|curH|에 리더 상자 하나를 출력하고 |curH|를 |leaderWd+lx|만큼 나아가게 한다@>
	}
	curH = edge - 10
	goto nextP
}

@ 리더에 관련된 계산은 조금 조심해야 한다. 먼저 |aLeaders|(정렬된 리더)라면, |curH|를 |leftEdge|에 |leaderWd|의 배수를 더한
자리로 옮기되, 그 결과가 |curH|의 현재 값보다 작지 않은 가장 작은 것으로 하고 싶다. 곧 |curH|는
$|leftEdge|+|leaderWd|\times\lceil(|curH|-|leftEdge|)/|leaderWd|\rceil$이 되어야 한다. 변수 |curH|가 |leftEdge|보다 작으면
피제수가 음수인 나눗셈이 일어나는데, 그 결과를 어느 쪽으로 자르든 여기의 프로그램은 제대로 돈다.

가운데 맞춘 리더 |cLeaders|라면 리더가 차지하지 않은 남는 공간의 절반만큼 |curH|를 늘린다. 그리고 펼친 리더 |xLeaders|라면
남는 공간의 $1/(q+1)$만큼 |curH|를 늘린다. 여기서 $q$는 리더 상자를 되풀이할 횟수다. 나눗셈의 작은 부정확함이 쌓일 수 있는데,
그 반올림 오차의 절반은 리더의 양 끝에 둔다.

다음 그림은 너비가 230인 글루에 너비가 40인 리더 상자를 채우는 세 가지 방법을 보인다. 글루는 |leftEdge|에서 37만큼 떨어진
곳에서 시작한다. 정렬된 리더는 |leftEdge|에서 잰 40의 배수 자리에만 상자를 놓으므로, 여러 줄에 걸친 리더의 점들이 세로로
가지런히 선다. 가운데 맞춘 리더는 상자 다섯 개를 붙여 놓고 남는 30을 양 끝에 반씩 나눈다. 펼친 리더는 남는 30을 여섯 몫으로
나누어 상자 사이와 양 끝에 고르게 뿌린다.
$$\mplibcode
beginfig(9);
save k, xa, xb, lw, h, dy; numeric k, xa, xb, lw, h, dy;
k := 1.45pt; xa := 37k; xb := 267k; lw := 40k; h := 10pt; dy := 26pt;
def leadrow(expr y) =
  draw (xa,y)--(xb,y)--(xb,y+h)--(xa,y+h)--cycle dashed withdots scaled .5;
enddef;
def lbox(expr x, y) =
  fill (x,y)--(x+lw,y)--(x+lw,y+h)--(x,y+h)--cycle withcolor .8white;
  draw (x,y)--(x+lw,y)--(x+lw,y+h)--(x,y+h)--cycle;
  fill fullcircle scaled 2pt shifted (x+lw/2, y+h/2);
enddef;
for i = 0 upto 6: draw (i*lw, 2dy-4pt)--(i*lw, 2dy+h+4pt) withpen pencircle scaled .2pt dashed evenly; endfor
leadrow(2dy); for i = 1 upto 5: lbox(i*lw, 2dy); endfor
leadrow(dy); for i = 0 upto 4: lbox(52k + i*lw, dy); endfor
leadrow(0); for i = 0 upto 4: lbox(42k + i*45k, 0); endfor
label.lft(btex \ninepoint \ID{aLeaders} etex, (-6pt, 2dy+h/2));
label.lft(btex \ninepoint \ID{cLeaders} etex, (-6pt, dy+h/2));
label.lft(btex \ninepoint \ID{xLeaders} etex, (-6pt, h/2));
label.top(btex \eightpoint \ID{leftEdge} etex, (0, 2dy+h+4pt));
drawdblarrow (xa, -8pt)--(xb, -8pt);
label.bot(btex \eightpoint 글루의 너비 230 etex, (1/2[xa,xb], -8pt));
endfig;
\endmplibcode$$

@<|curH|를 첫 상자의...@>=
if subtype(p) == aLeaders {
	saveH = curH
	curH = leftEdge + leaderWd*((curH-leftEdge)/leaderWd)
@^negative dividends@>
	if curH < saveH {
		curH += leaderWd
	}
} else {
	lq = ruleWd / leaderWd // 상자 사본의 수
	lr = ruleWd % leaderWd // 남는 공간
	if subtype(p) == cLeaders {
		curH += (lr / 2)
	} else {
		lx = lr / (lq + 1)
		curH += ((lr - (lq-1)*lx) / 2)
	}
}

@ 리더 상자 하나를 지금 자리에 내보내고 다음 자리로 간다. 여기의 `\ID{synch}' 연산들은 \.{DVI} 출력에서 가로와 세로 움직임을
지정하는 데 드는 바이트 수를 줄이려는 것이다.

@<|curH|에 리더 상자...@>=
curV = baseLine + shiftAmount(leaderBox)
synchV()
saveV = dviV
synchH()
saveH = dviH
tempPtr = leaderBox
outerDoingLeaders = doingLeaders
doingLeaders = true
if typ(leaderBox) == vlistNode {
	vlistOut()
} else {
	hlistOut()
}
doingLeaders = outerDoingLeaders
dviV = saveV
dviH = saveH
curV = baseLine
curH = saveH + leaderWd + lx

@ 루틴 |vlistOut|은 |hlistOut|과 비슷하지만 조금 더 간단하다. 세로 목록에는 문자 노드가 없기 때문이다.

@<함수들@>=
func vlistOut() { // |vlistNode| 상자를 출력한다
	var leftEdge scaled // 이 상자의 왼쪽 좌표
	var topEdge scaled // 이 상자의 위쪽 좌표
	var saveH, saveV scaled // |dviH|와 |dviV|가 꺼내져 돌아갈 값
	var thisBox pointer // 둘러싼 상자를 가리키는 포인터
	var gOrder glueOrd // 글루에 적용되는 무한대의 차수
	var gSign int32 // 글루의 종류를 고른다; |normal..shrinking|
	var p pointer // 세로 목록의 현재 위치
	var saveLoc int32 // 들어올 때의 \.{DVI} 바이트 위치
	var leaderBox pointer // 되풀이하는 리더 상자
	var leaderHt scaled // 되풀이하는 리더 상자의 높이
	var lx scaled // 리더 상자 사이의 추가 간격
	var outerDoingLeaders bool // 리더를 하고 있었나?
	var edge scaled // 리더 공간의 아래 경계
	var glueTemp float64 // 반올림하기 전의 글루 값
	var curGlue float64 // 지금까지 본 글루
	var curG scaled // |curGlue| 곱하기 글루 비율을 반올림한 값
	curG = 0; curGlue = floatConstant(0)
	thisBox = tempPtr; gOrder = glueOrder(thisBox)
	gSign = glueSign(thisBox); p = listPtr(thisBox)
	curS++
	if curS > 0 {
		dviOut(push)
	}
	if curS > maxPush {
		maxPush = curS
	}
	saveLoc = dviOffset + dviPtr; leftEdge = curH; curV -= height(thisBox)
	topEdge = curV
	for p != null {
		@<|vlistOut|에서 노드 |p|를 출력하고 다음 노드로 옮겨 간다@>
	}
	pruneMovements(saveLoc)
	if curS > 0 {
		dviPop(saveLoc)
	}
	curS--
}

@ 다음 코드는 |vlistOut|에서 노드 |p|를 내보내고 다음 노드로 옮겨 가되, 조건 |curH=leftEdge|를 지킨다.

@<|vlistOut|에서 노드 |p|를...@>=
if isCharNode(p) {
	confusion("vlistout")
@:this can't happen vlistout}{\quad vlistout@>
} else {
	@<|vlistOut|에서 |charNode|가 아닌 |p|를 출력한다@>
}
nextP:
p = link(p)

@ 세로 목록의 노드를 종류에 따라 처리한다. 커닝은 그만큼 아래로 옮기기만 한다.
@<|vlistOut|에서 |charNode|가...@>=
switch typ(p) {
case hlistNode, vlistNode: @<세로 목록에서 상자를 출력한다@>
case ruleNode:
	ruleHt = height(p); ruleDp = depth(p); ruleWd = width(p)
	goto finRule
case whatsitNode: @<세로 목록에서 whatsit 노드 |p|를 출력한다@>
case glueNode: @<아래로 움직이거나 리더를 출력한다@>
case kernNode: curV = curV + width(p)
default: // 아무것도 하지 않는다
}
goto nextP
finRule:
@<세로 목록에서 괘선을 출력하고 |goto nextP|@>
movePast:
curV += ruleHt

@ 세로 목록 안의 상자를 내보낸다. 상자의 기준선까지 내려가서 재귀로 내보내고, 돌아오면 깊이만큼 더 내려간다. 여기의
|synchV| 덕분에 \.{DVI} 출력은 대개 |v|를 조정하는 데 한 바이트짜리 명령을 쓸 수 있다. 줄 사이의 기준선 간격은 대개 일정하기
때문이다.

@<세로 목록에서 상자를...@>=
if listPtr(p) == null {
	curV = curV + height(p) + depth(p)
} else {
	curV += height(p)
	synchV()
	saveH = dviH
	saveV = dviV
	curH = leftEdge + shiftAmount(p) // 상자를 오른쪽으로 옮긴다
	tempPtr = p
	if typ(p) == vlistNode {
		vlistOut()
	} else {
		hlistOut()
	}
	dviH = saveH
	dviV = saveV
	curV = saveV + depth(p)
	curH = leftEdge
}

@ 세로 목록 안의 괘선을 내보낸다. 너비가 흐르는 치수이면 둘러싼 상자의 너비를 쓴다. 괘선의 아래쪽까지 내려간 뒤에
|putRule|로 그린다.
@<세로 목록에서 괘선을...@>=
if isRunning(ruleWd) {
	ruleWd = width(thisBox)
}
ruleHt += ruleDp // 이것이 괘선의 두께다
curV += ruleHt
if ruleHt > 0 && ruleWd > 0 { // 빈 괘선은 출력하지 않는다
	synchH()
	synchV()
	dviOut(putRule)
	dviFour(ruleHt)
	dviFour(ruleWd)
}
goto nextP

@ 글루만큼 아래로 움직인다. 가로 목록일 때와 똑같이 글루 누계를 써서 반올림 오차가 쌓이지 않게 한다.
@<아래로 움직이거나...@>=
g = gluePtr(p)
ruleHt = width(g) - curG
if gSign != normal {
	if gSign == stretching {
		if stretchOrder(g) == gOrder {
			curGlue += float64(stretch(g))
			glueTemp = vetGlue(float(glueSet(thisBox)) * curGlue)
@^real multiplication@>
			curG = round(glueTemp)
		}
	} else if shrinkOrder(g) == gOrder {
		curGlue -= float64(shrink(g))
		glueTemp = vetGlue(float(glueSet(thisBox)) * curGlue)
		curG = round(glueTemp)
	}
}
ruleHt += curG
if subtype(p) >= aLeaders {
	@<세로 목록에서 리더를 출력하고, 괘선이면 |goto finRule|, 다 했으면 |goto nextP|@>
}
goto movePast

@ 세로 리더를 내보낸다. 괘선 리더이면 괘선 하나를 그리고, 상자 리더이면 상자를 되풀이해 놓는다.
@<세로 목록에서 리더를...@>=
leaderBox = leaderPtr(p)
if typ(leaderBox) == ruleNode {
	ruleWd = width(leaderBox)
	ruleDp = 0
	goto finRule
}
leaderHt = height(leaderBox) + depth(leaderBox)
if leaderHt > 0 && ruleHt > 0 {
	ruleHt += 10 // 부동 소수점 반올림을 보정한다
	edge = curV + ruleHt
	lx = 0
	@<|curV|를 첫 상자의 위치로 놓고, |leaderHt+lx|를 상자 사이의 간격으로 놓는다@>
	for curV+leaderHt <= edge {
		@<|curV|에 리더 상자 하나를 출력하고 |curV|를 |leaderHt+lx|만큼 나아가게 한다@>
	}
	curV = edge - 10
	goto nextP
}

@ 세로 리더의 첫 상자 자리를 정한다. 가로 리더와 똑같은 계산을 세로 방향으로 한다.
@<|curV|를 첫 상자의...@>=
if subtype(p) == aLeaders {
	saveV = curV
	curV = topEdge + leaderHt*((curV-topEdge)/leaderHt)
@^negative dividends@>
	if curV < saveV {
		curV += leaderHt
	}
} else {
	lq = ruleHt / leaderHt // 상자 사본의 수
	lr = ruleHt % leaderHt // 남는 공간
	if subtype(p) == cLeaders {
		curV += (lr / 2)
	} else {
		lx = lr / (lq + 1)
		curV += ((lr - (lq-1)*lx) / 2)
	}
}

@ 리더 상자 하나를 지금 자리에 내보낸다. 프로그램의 이 부분에 이르면 |curV|는 리더 상자의 기준선이 아니라 위쪽을 가리킨다.

@<|curV|에 리더 상자...@>=
curH = leftEdge + shiftAmount(leaderBox)
synchH()
saveH = dviH
curV += height(leaderBox)
synchV()
saveV = dviV
tempPtr = leaderBox
outerDoingLeaders = doingLeaders
doingLeaders = true
if typ(leaderBox) == vlistNode {
	vlistOut()
} else {
	hlistOut()
}
doingLeaders = outerDoingLeaders
dviV = saveV
dviH = saveH
curH = leftEdge
curV = saveV - height(leaderBox) + leaderHt + lx

@ 이제 |hlistOut|과 |vlistOut| 프로시저가 완성되었으니, 맨 처음에 이것들을 시동하는 |shipOut| 루틴을 볼 차례다.

@<함수들@>=
func shipOut(p pointer) { // 상자 |p|를 출력한다
	var pageLoc int32 // 현재 |bop|의 위치
	var j, k int32 // 처음 열 개의 \.{\\count} 레지스터의 첨자; |0..9|
	var s poolPointer // |strPool|의 첨자
	var oldSetting int32 // 저장한 |selector| 설정; |0 .. maxSelector|
	if tracingOutput() > 0 {
		printNl("")
		printLn()
		printStr("Completed box being shipped out")
@.Completed box...@>
	}
	if termOffset > maxPrintLine-9 {
		printLn()
	} else if termOffset > 0 || fileOffset > 0 {
		printChar(' ')
	}
	printChar('[')
	j = 9
	for count(j) == 0 && j > 0 {
		j--
	}
	for k = 0; k <= j; k++ {
		printInt(count(k))
		if k < j {
			printChar('.')
		}
	}
	updateTerminal()
	if tracingOutput() > 0 {
		printChar(']')
		beginDiagnostic()
		showBox(p)
		endDiagnostic(true)
	}
	@<상자 |p|를 내보낸다@>
	if tracingOutput() <= 0 {
		printChar(']')
	}
	deadCycles = 0
	updateTerminal() // 진행 보고
	@<상자를 메모리에서 지우고, 요청이 있으면 통계를 보인다@>
}

@ 쪽을 내보낸 뒤에는 상자를 메모리에서 지운다. 매개변수 \.{\\tracingstats}가 1보다 크면 지우기 전후의 메모리 사용량을 보여 준다.
@<상자를 메모리에서...@>=
if stat {
	if tracingStats() > 1 {
		printNl("Memory usage before: ")
@.Memory usage...@>
		printInt(varUsed)
		printChar('&')
		printInt(dynUsed)
		printChar(';')
	}
}
flushNodeList(p)
if stat {
	if tracingStats() > 1 {
		printStr(" after: ")
		printInt(varUsed)
		printChar('&')
		printInt(dynUsed)
		printStr("; still untouched: ")
		printInt(hiMemMin - loMemMax - 1)
		printLn()
	}
}

@ 상자 |p|를 쪽 하나로 내보낸다. 명령 |bop|에는 \.{\\count0}부터 \.{\\count9}까지와 앞 |bop|의 위치를 적고, 기준점을
\.{\\hoffset}과 \.{\\voffset}만큼 옮긴 자리에서 상자를 내보낸 다음 |eop|를 적는다.
@<상자 |p|를 내보낸다@>=
@<|maxH|와 |maxV|의 값을 갱신하되, 쪽이 너무 크면 |goto done|@>
@<|shipOut|을 시작할 때...@>
pageLoc = dviOffset + dviPtr
dviOut(bop)
for k = 0; k <= 9; k++ {
	dviFour(count(k))
}
dviFour(lastBop)
lastBop = pageLoc
curV = height(p) + vOffset()
tempPtr = p
if typ(p) == vlistNode {
	vlistOut()
} else {
	hlistOut()
}
dviOut(eop)
totalPages++
curS = -1
done:

@ 사용자가 다른 오류 메시지들을 무시하다가 거대한 쪽을 만들 때가 있다. 그런 쪽은 인쇄 소프트웨어를 헷갈리게 할 수 있으므로
\.{dvi} 파일에 내보내지 않는다. 쪽의 크기가 \.{DVI}의 한계 안이면 |maxH|와 |maxV|를 고친다.

@<|maxH|와 |maxV|의...@>=
if height(p) > maxDimen || depth(p) > maxDimen ||
	height(p)+depth(p)+vOffset() > maxDimen ||
	width(p)+hOffset() > maxDimen {
	printErr("Huge page cannot be shipped out")
@.Huge page...@>
	help2("The page just created is more than 18 feet tall or",
		"more than 18 feet wide, so I suspect something went wrong.")
	reportError()
	if tracingOutput() <= 0 {
		beginDiagnostic()
		printNl("The following box has been deleted:")
@.The following...deleted@>
		showBox(p)
		endDiagnostic(true)
	}
	goto done
}
if height(p)+depth(p)+vOffset() > maxV {
	maxV = height(p) + depth(p) + vOffset()
}
if width(p)+hOffset() > maxH {
	maxH = width(p) + hOffset()
}

@ 프로그램이 끝날 때는 후문을 써서 일을 마무리해야 한다. 쪽 수 |totalPages|가 0이면 \.{DVI} 파일은 한 번도 열리지 않았다. 그 값이
65536 이상이면 \.{DVI} 파일은 거짓말을 할 것이다. 그리고 |maxPush>=65536|이면 사용자는 무슨 혼돈이 뒤따르든 받아 마땅하다.
출력 루틴이 도중에 중단되었다면 아직 닫지 않은 |push|와 쪽을 먼저 닫는다.

이 루틴에 쓸 정수 변수 |k|는 나중에 선언한다.

@<\.{DVI} 파일을 마무리한다@>=
for curS > -1 {
	if curS > 0 {
		dviOut(pop)
	} else {
		dviOut(eop)
		totalPages++
	}
	curS--
}
if totalPages == 0 {
	printNl("No pages of output.")
@.No pages of output@>
} else {
	@<후문을 출력하고 \.{DVI} 파일을 닫는다@>
}

@ 앞 절의 |else| 부분이다. 후문과 글꼴 정의들, 그리고 꼬리 바이트 223을 내보낸다.

@<후문을 출력하고...@>=
dviOut(post) // 후문의 시작
dviFour(lastBop)
lastBop = dviOffset + dviPtr - 5 // |post|의 위치
dviFour(25400000)
dviFour(473628672) // sp를 위한 변환 비율
prepareMag()
dviFour(mag()) // 확대 배율
dviFour(maxV)
dviFour(maxH)
dviOut(maxPush / 256); dviOut(maxPush % 256)
dviOut((totalPages / 256) % 256); dviOut(totalPages % 256)
@<쓰인 모든 글꼴의 정의를 출력한다@>
dviOut(postPost)
dviFour(lastBop)
dviOut(idByte)
k = 4 + ((dviBufSize - dviPtr) % 4) // 223의 수
for k > 0 {
	dviOut(223)
	k--
}
@<|dviBuf|의 마지막 바이트들을...@>
printNl("Output written on ")
slowPrint(outputFileName)
@.Output written on x@>
printStr(" (")
printInt(totalPages)
printStr(" page")
if totalPages != 1 {
	printChar('s')
}
printStr(", ")
printInt(dviOffset + dviPtr)
printStr(" bytes).")
bClose(&dviFile)

@ 후문에 쓰인 글꼴의 정의를 모두 다시 적는다.
@<쓰인 모든 글꼴의...@>=
for fontPtr > fontBase {
	if fontUsed[fontPtr] {
		dviFontDef(fontPtr)
	}
	fontPtr--
}

@* 꾸리기.
이로써 \TeX에서 입력(|getNext|)과 출력(|shipOut|)을 맡은 부분은 사실상 다 보았다. 이제 조판의 진짜 일을 하는 나머지
부분에 본격적으로 들어갈 차례다.

\TeX은 목록을 다 만들면 그것을 싸서 상자에 넣는다. 이 일은 두 주요 서브루틴이 맡는다. 서브루틴 |hpack|은 가로 목록을, |vpack|은
세로 목록을 꾸린다. 두 서브루틴이 하는 일은 만들어지는 상자의 치수를 계산하고, 치수 가운데 하나가 미리 정해져 있으면 그에
맞추어 글루를 늘이거나 줄이는 것이다. 계산한 크기는 보통 새 상자 안의 재료를 모두 둘러싼다. 그러나 음의 글루를 썼거나,
상자가 꽉 찼거나, \.{\\vbox}에 왼쪽으로 옮긴 상자가 들어 있으면 어떤 항목은 상자 밖으로 삐져나올 수도 있다.

서브루틴 호출 |hpack(p,w,m)|은 |p|에서 시작하는 가로 목록을 담은 상자의 |hlistNode|를 만들어 그 포인터를 돌려준다.
매개변수 |w|는 너비를 정하고, 매개변수 |m|은 `|exactly|'나 `|additional|'이다. 그러니 |hpack(p,w,exactly)|는 너비가 정확히
|w|인 상자를 만들고, |hpack(p,w,additional)|은 너비가 자연 너비 더하기 |w|인 상자를 만든다. 앞의 것은 \.{\\hbox to}, 뒤의
것은 \.{\\hbox spread}에 해당한다. 가장 흔한 경우를 위해 `|natural|'이라는 상수를 정의해 두면 편하다. 그러면
|hpack(p,natural,additional)|이라고 써서 목록 |p|의 자연 너비를 가진 상자를 얻는다.

마찬가지로 |vpack(p,w,m)|은 |p|에서 시작하는 세로 목록을 담은 상자의 |vlistNode|를 가리키는 포인터를 돌려준다. 이때 |w|는
너비가 아니라 높이다. 매개변수 |m|은 |hpack|에서와 같이 해석한다.


@<정의@>=
const (
	@!exactly = 0 // 상자의 치수가 미리 지정되어 있다
	@!additional = 1 // 상자의 치수를 자연 치수에서 늘린다
	@!natural = 0 // |hpack|과 |vpack|의 매개변수를 위한 약칭(의 앞쪽 절반)
)

@ 서브루틴 |hpack|과 |vpack|의 매개변수들은 `\.{\\hbox} \.{to} \.{300pt}', `\.{\\hbox} \.{spread} \.{10pt}' 같은 \TeX의 원시
명령에 대응한다. 뒤에 치수가 없는 `\.{\\hbox}'는 `\.{\\hbox} \.{spread} \.{0pt}'와 같다는 데 눈여겨보자. 서브루틴
|scanSpec|은 사용자의 입력에서 그런 지정을 그 뒤에 반드시 오는 왼쪽 중괄호까지 읽고, 그 지정을 |saveStack|에 넣는다. 그러면
나중에, 곧 그룹이 끝날 때 다음 코드로 원하는 상자를 얻을 수 있다.
$$\vbox{\halign{#\hfil\cr
|savePtr=savePtr-2|\cr
|hpack(p,saved(1),saved(0))|\cr}}$$
특별한 |saveStack| 코드들이 새 그룹 코드 바로 아래에 오도록 특별히 조심해야 한다. 치수를 읽는 도중에 \.{\\csname}이 나오면
|saveStack|이 바뀔 수 있기 때문이다. 그래서 지정을 다 읽은 뒤에 저장하고, 곧바로 새 그룹을 연다.

@<함수들@>=
func scanSpec(c groupCode, threeCodes bool) { // 상자 지정과 왼쪽 중괄호를 훑는다
	var s int32 // 잠시 저장한 값
	var specCode int32 // |exactly..additional|
	if threeCodes {
		s = saved(0)
	}
	if scanKeyword("to") {
		specCode = exactly
@.to@>
	} else if scanKeyword("spread") {
		specCode = additional
@.spread@>
	} else {
		specCode = additional
		curVal = 0
		goto found
	}
	scanNormalDimen()
found:
	if threeCodes {
		setSaved(0, s)
		savePtr++
	}
	setSaved(0, specCode)
	setSaved(1, curVal)
	savePtr += 2
	newSaveLevel(c)
	scanLeftBrace()
}

@ 글루를 어떻게 늘일지 정하려고, |hpack|과 |vpack|은 무한대의 네 차수마다 늘어남과 줄어듦의 합계를 따로 구한다. 그런 다음
합계가 0이 아닌 가장 높은 무한대 차수를, 다른 차수는 없는 것처럼 쓴다.

이를테면 주어진 목록에 늘어남이 저마다 3pt, 8fill, 5fil, 6pt, $-3$fil, $-8$fill인 글루 노드 여섯 개가 있다고 하자. 그러면
합계는 본질적으로 2fil이다. fill끼리는 서로 지워지기 때문이다. 늘여서 모두 6pt를 더 채워야 한다면 `fil' 글루만 셈에 넣으므로,
실제로 늘어나는 양은 0pt, 0pt, 15pt, 0pt, $-9$pt, 0pt가 된다. (그러므로 `fill' 글루는 실은 `fil'보다 무한히 더 늘어나는 것이
아니다. 정말로 그런 일이 일어나기를 바라는 사람은 없을 것이다.)

배열 |totalStretch|와 |totalShrink|에 종류별 글루의 합계를 모은다. 전역 변수 |lastBadness|는 \.{\\badness}를 구현하는 데 쓴다.

@<전역 변수@>=
var @!totalStretch, @!totalShrink [filll + 1]scaled // |hpack|이나 |vpack|이 찾은 글루
var @!lastBadness int32 // 가장 최근에 꾸린 상자의 나쁨

@ 전역 변수 |adjustTail|이 널이 아니면, |hpack| 루틴은 |insNode|, |markNode|, |adjustNode| 항목들을 목록에서 모두 빼내고,
그것들을 위치 |adjustTail|에서 끝나는 목록에 덧붙인다. 문단의 줄을 꾸릴 때 이렇게 해서 \.{\\vadjust}와 \.{\\insert},
\.{\\mark}의 재료를 그 줄 다음의 세로 목록으로 옮긴다.

@<전역 변수@>=
var @!adjustTail pointer // 조정 목록의 꼬리

@ @<핵심 변수들의...@>=
adjustTail = null
lastBadness = 0

@ 이제 놀랄 것이 거의 없는 |hpack|이다. 목록을 훑으며 너비를 더하고 높이와 깊이의 최댓값을 구한 다음, 목표 너비에 맞추어
글루 비율을 정한다. 결과가 마음에 들지 않으면 `\.{Underfull}'이나 `\.{Overfull}' 같은 경고를 낸다.


@<함수들@>=
func hpack(p pointer, w scaled, m smallNumber) pointer {
	var r pointer // 돌려줄 상자 노드
	var q pointer // |p| 뒤를 따른다
	var h, d, x scaled // 높이, 깊이, 자연 너비
	var s scaled // 옮김의 양
	var g pointer // 글루 명세를 가리킨다
	var o glueOrd // 무한대의 차수
	var f internalFontNumber // |charNode|의 글꼴
	var i fourQuarters // |charNode|에 관한 글꼴 정보
	var hd eightBits // 문자의 높이와 깊이 첨자
	lastBadness = 0
	r = getNode(boxNodeSize)
	setType(r, hlistNode)
	setSubtype(r, minQuarterword)
	setShiftAmount(r, 0)
	q = r + listOffset
	setLink(q, p)
	h = 0
	@<치수들을 0으로 지운다@>
	for p != null {
		@<가로 목록의 노드 |p|를 살펴 반영하고 다음으로 나아간다@>
	}
	if adjustTail != null {
		setLink(adjustTail, null)
	}
	setHeight(r, h)
	setDepth(r, d)
	@<|width(r)|의 값과 알맞은 글루 설정을 정하고, |return|하거나 |goto commonEnding|@>
commonEnding:
	@<꽉 차거나 덜 찬 가로 상자에 관한 진단 메시지를 마저 낸다@>
	return r
}

@ 치수와 글루 합계를 0으로 놓는다.
@<치수들을 0으로...@>=
d = 0
x = 0
totalStretch[normal] = 0; totalShrink[normal] = 0
totalStretch[fil] = 0; totalShrink[fil] = 0
totalStretch[fill] = 0; totalShrink[fill] = 0
totalStretch[filll] = 0; totalShrink[filll] = 0

@ 가로 목록의 노드를 하나씩 보며 치수를 반영한다. 문자가 가장 흔하므로 먼저 처리한다.
@<가로 목록의 노드 |p|를...@>=
@^inner loop@>
reswitch:
for isCharNode(p) {
	@<문자의 치수를 그것을 담을 가로 상자의 치수에 반영하고 다음 노드로 옮겨 간다@>
}
if p != null {
	switch typ(p) {
	case hlistNode, vlistNode, ruleNode, unsetNode:
		@<상자의 치수를 그것을 담을 가로 상자의 치수에 반영한다@>
	case insNode, markNode, adjustNode:
		if adjustTail != null {
			@<노드 |p|를 조정 목록으로 옮긴다@>
		}
	case whatsitNode: @<whatsit 노드를 가로 상자에 반영한다@>
	case glueNode: @<글루를 가로 합계에 반영한다@>
	case kernNode, mathNode: x = x + width(p)
	case ligatureNode: @<노드 |p|를 |charNode|처럼...@>
	default: // 아무것도 하지 않는다
	}
	p = link(p)
}

@ 합자는 잠시 문자 노드로 가장해서 다룬다. 고정된 자리 |ligTrick|에 합자 문자를 담은 가짜 문자 노드를 만들고, 그 다음 노드를
합자의 다음 노드로 이어 둔다.
@<노드 |p|를 |charNode|처럼...@>=
mem[ligTrick] = mem[ligChar(p)]
setLink(ligTrick, link(p))
p = ligTrick
goto reswitch

@ 상자나 괘선의 치수를 반영한다. 너비는 더하고, 높이와 깊이는 자리 옮김을 고려해 최댓값을 구한다. 여기의 코드는 흐르는 치수가
|nullFlag|로 나타난다는 사실을 슬쩍 써먹는다. 그 값은 아주 큰 음수이므로 최댓값 계산에서 저절로 무시된다.

@<상자의 치수를 그것을 담을 가로...@>=
x += width(p)
if typ(p) >= ruleNode {
	s = 0
} else {
	s = shiftAmount(p)
}
if height(p)-s > h {
	h = height(p) - s
}
if depth(p)+s > d {
	d = depth(p) + s
}

@ 다음 코드는 \TeX의 안쪽 루프의 일부다. 곧 사용자가 입력에 텍스트 문자를 하나 더 보태면 이 명령들이 저마다 한 번씩 더
실행된다.
@^inner loop@>

@<문자의 치수를...@>=
f = font(p)
i = charInfo(f, character(p))
hd = heightDepth(i)
x += charWidth(f, i)
s = charHeight(f, hd)
if s > h {
	h = s
}
s = charDepth(f, hd)
if s > d {
	d = s
}
p = link(p)

@ 노드 |q|가 꼭 노드 |p|의 바로 앞 노드인 것은 아니지만, 언제나 |p| 앞의 목록에 있는 어떤 노드를 가리킨다. 그래서 필요할 때
|q|를 앞으로 옮겨 가서 노드를 빼낼 수 있다. 이 알고리즘은 선형 시간이 걸리며, 빼낼 노드가 없는 한 그 추가 계산이 안쪽 루프에
끼어들지 않는다.
@^inner loop@>

@<노드 |p|를 조정 목록으로...@>=
for link(q) != p {
	q = link(q)
}
if typ(p) == adjustNode {
	setLink(adjustTail, adjustPtr(p))
	for link(adjustTail) != null {
		adjustTail = link(adjustTail)
	}
	p = link(p)
	freeNode(link(q), smallNodeSize)
} else {
	setLink(adjustTail, p)
	adjustTail = p
	p = link(p)
}
setLink(q, p)
p = q

@ 글루의 너비를 더하고, 늘어남과 줄어듦을 차수별로 더한다. 리더라면 리더 상자의 높이와 깊이도 반영한다.
@<글루를 가로 합계에...@>=
g = gluePtr(p)
x += width(g)
o = stretchOrder(g)
totalStretch[o] += stretch(g)
o = shrinkOrder(g)
totalShrink[o] += shrink(g)
if subtype(p) >= aLeaders {
	g = leaderPtr(p)
	if height(g) > h {
		h = height(g)
	}
	if depth(g) > d {
		d = depth(g)
	}
}

@ 프로그램의 이 부분에 이르면 |x|는 꾸리고 있는 상자의 자연 너비다. 목표 너비와의 차이를 구해서, 0이면 글루를 그대로 두고,
양수이면 늘이고, 음수이면 줄인다.

@<|width(r)|의 값과...@>=
if m == additional {
	w = x + w
}
setWidth(r, w)
x = w - x // 이제 |x|는 메워야 할 초과분이다
if x == 0 {
	setGlueSign(r, normal)
	setGlueOrder(r, normal)
	setGlueSet(r, 0.0)
	return r
} else if x > 0 {
	@<가로 글루의 늘이기 설정을 정하고, |return|하거나 |goto commonEnding|@>
} else {
	@<가로 글루의 줄이기 설정을 정하고, |return|하거나 |goto commonEnding|@>
}

@ 글루를 늘인다. 늘어남이 있는 가장 높은 차수를 고르고, 모자란 양을 그 차수의 늘어남 합계로 나눈 것이 글루 비율이다.
보통 글루(차수 |normal|)로 늘였다면 나쁨을 계산해서 \.{\\hbadness}보다 나쁘면 알린다.
@<가로 글루의 늘이기...@>=
@<늘이기 차수를 정한다@>
setGlueOrder(r, o)
setGlueSign(r, stretching)
if totalStretch[o] != 0 {
	setGlueSet(r, unfloat(float64(x)/float64(totalStretch[o])))
@^real division@>
} else {
	setGlueSign(r, normal)
	setGlueSet(r, 0.0) // 늘일 것이 없다
}
if o == normal {
	if listPtr(r) != null {
		@<덜 찬 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
	}
}
return r

@ @<늘이기 차수를...@>=
if totalStretch[filll] != 0 {
	o = filll
} else if totalStretch[fill] != 0 {
	o = fill
} else if totalStretch[fil] != 0 {
	o = fil
} else {
	o = normal
}

@ 나쁨이 100보다 크면 `\.{Underfull}', 아니면 `\.{Loose}'라고 알린다. 상자가 \.{\\hbadness}만큼 나쁘지 않으면 아무 말도 하지
않는다.
@<덜 찬 가로 상자를...@>=
lastBadness = badness(x, totalStretch[normal])
if lastBadness > hbadness() {
	printLn()
	if lastBadness > 100 {
		printNl("Underfull")
	} else {
		printNl("Loose")
	}
	printStr(" \\hbox (badness ")
	printInt(lastBadness)
@.Underfull \\hbox...@>
@.Loose \\hbox...@>
	goto commonEnding
}

@ 꽉 찬 상자나 덜 찬 상자가 입력의 어디에서 생겼는지 알려 주려고 전역 변수 |packBeginLine|을 쓴다. 이 변수는 |hpack|을 문단
조립기나 정렬 마무리 루틴이 부를 때에만 0이 아닌 값이 된다. 그러면 `\.{in paragraph at lines 12--15}'처럼 줄 번호의 범위를
알릴 수 있다.

@<전역 변수@>=
var @!packBeginLine int32 // 현재 문단이나 정렬이 시작한 원본 파일 줄; 음수는 정렬을 뜻한다

@ @<핵심 변수들의...@>=
packBeginLine = 0

@ 경고 메시지를 마무리한다. 어디에서 생긴 상자인지 밝히고, 상자의 내용을 짧게 보여 준 다음 \.{\\showbox} 식으로도 보여 준다.
@<꽉 차거나 덜 찬 가로 상자에...@>=
if outputActive {
	printStr(") has occurred while \\output is active")
} else {
	if packBeginLine != 0 {
		if packBeginLine > 0 {
			printStr(") in paragraph at lines ")
		} else {
			printStr(") in alignment at lines ")
		}
		printInt(abs(packBeginLine))
		printStr("--")
	} else {
		printStr(") detected at line ")
	}
	printInt(line)
}
printLn()
fontInShortDisplay = nullFont
shortDisplay(listPtr(r))
printLn()
beginDiagnostic()
showBox(r)
endDiagnostic(true)

@ 글루를 줄인다. 줄어듦이 있는 가장 높은 차수를 고르고, 넘치는 양을 그 차수의 줄어듦 합계로 나눈 것이 글루 비율이다. 글루는
줄어듦 합계 이상으로는 줄지 않는다. 그래도 넘치면 상자가 꽉 찬 것이다.
@<가로 글루의 줄이기...@>=
@<줄이기 차수를 정한다@>
setGlueOrder(r, o)
setGlueSign(r, shrinking)
if totalShrink[o] != 0 {
	setGlueSet(r, unfloat(float64(-x)/float64(totalShrink[o])))
@^real division@>
} else {
	setGlueSign(r, normal)
	setGlueSet(r, 0.0) // 줄일 것이 없다
}
if totalShrink[o] < -x && o == normal && listPtr(r) != null {
	lastBadness = 1000000
	setGlueSet(r, 1.0) // 최대로 줄인다
	@<꽉 찬 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
} else if o == normal {
	if listPtr(r) != null {
		@<빡빡한 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
	}
}
return r

@ @<줄이기 차수를...@>=
if totalShrink[filll] != 0 {
	o = filll
} else if totalShrink[fill] != 0 {
	o = fill
} else if totalShrink[fil] != 0 {
	o = fil
} else {
	o = normal
}

@ 상자가 꽉 찼다. 넘친 양이 \.{\\hfuzz}보다 크거나 \.{\\hbadness}가 100보다 작으면 알린다. 매개변수 \.{\\overfullrule}이 양수이면
줄 끝에 그 너비의 검은 괘선을 덧붙여, 인쇄한 쪽에서도 넘친 줄을 쉽게 찾을 수 있게 한다.
@<꽉 찬 가로 상자를...@>=
if -x-totalShrink[normal] > hfuzz() || hbadness() < 100 {
	if overfullRule() > 0 && -x-totalShrink[normal] > hfuzz() {
		for link(q) != null {
			q = link(q)
		}
		setLink(q, newRule())
		setWidth(link(q), overfullRule())
	}
	printLn()
	printNl("Overfull \\hbox (")
@.Overfull \\hbox...@>
	printScaled(-x - totalShrink[normal])
	printStr("pt too wide")
	goto commonEnding
}

@ 줄여서 맞추기는 했지만 많이 줄였다면 `\.{Tight}'라고 알린다.
@<빡빡한 가로 상자를...@>=
lastBadness = badness(-x, totalShrink[normal])
if lastBadness > hbadness() {
	printLn()
	printNl("Tight \\hbox (badness ")
	printInt(lastBadness)
@.Tight \\hbox...@>
	goto commonEnding
}

@ 서브루틴 |vpack|은 실은 |vpackage|라는 조금 더 일반적인 루틴의 특별한 경우다. 루틴 |vpackage|에는 매개변수가 넷 있다. 넷째
매개변수는 만들어지는 상자의 깊이의 최댓값이고, |vpack|은 |maxDimen|을 준다. 깊이는 먼저 보통의 규칙으로 계산한다. 그것이 이
한계를 넘으면 한계 깊이가 될 때까지 기준점을 그냥 아래로 옮긴다. 매개변수 \.{\\boxmaxdepth}와 쪽 조립기의 \.{\\maxdepth}가 이렇게
작동한다.

@<함수들@>=
func vpack(p pointer, h scaled, m smallNumber) pointer { // 깊이에 제약이 없는 특별한 경우
	return vpackage(p, h, m, maxDimen)
}

func vpackage(p pointer, h scaled, m smallNumber, l scaled) pointer {
	var r pointer // 돌려줄 상자 노드
	var w, d, x scaled // 너비, 깊이, 자연 높이
	var s scaled // 옮김의 양
	var g pointer // 글루 명세를 가리킨다
	var o glueOrd // 무한대의 차수
	lastBadness = 0
	r = getNode(boxNodeSize)
	setType(r, vlistNode)
	setSubtype(r, minQuarterword)
	setShiftAmount(r, 0)
	setListPtr(r, p)
	w = 0
	@<치수들을 0으로...@>
	for p != null {
		@<세로 목록의 노드 |p|를 살펴 반영하고 다음으로 나아간다@>
	}
	setWidth(r, w)
	if d > l {
		x = x + d - l
		setDepth(r, l)
	} else {
		setDepth(r, d)
	}
	@<|height(r)|의 값과 알맞은 글루 설정을 정하고, |return|하거나 |goto commonEnding|@>
commonEnding:
	@<꽉 차거나 덜 찬 세로 상자에 관한 진단 메시지를 마저 낸다@>
	return r
}

@ 세로 목록의 노드를 하나씩 보며 치수를 반영한다. 세로 목록에 문자 노드가 있으면 무언가 잘못된 것이다. 커닝은 높이에 더한다.
@<세로 목록의 노드 |p|를...@>=
if isCharNode(p) {
	confusion("vpack")
@:this can't happen vpack}{\quad vpack@>
} else {
	switch typ(p) {
	case hlistNode, vlistNode, ruleNode, unsetNode:
		@<상자의 치수를 그것을 담을 세로 상자의 치수에 반영한다@>
	case whatsitNode: @<whatsit 노드를 세로 상자에 반영한다@>
	case glueNode: @<글루를 세로 합계에 반영한다@>
	case kernNode:
		x = x + d + width(p)
		d = 0
	default: // 아무것도 하지 않는다
	}
}
p = link(p)

@ 상자나 괘선의 치수를 반영한다. 앞 항목의 깊이와 이 항목의 높이를 높이 합계에 더하고, 이 항목의 깊이를 새 깊이로 삼는다.
너비는 자리 옮김을 고려한 최댓값이다.
@<상자의 치수를 그것을 담을 세로...@>=
x = x + d + height(p)
d = depth(p)
if typ(p) >= ruleNode {
	s = 0
} else {
	s = shiftAmount(p)
}
if width(p)+s > w {
	w = width(p) + s
}

@ 글루의 너비를 높이 합계에 더한다. 글루 앞의 깊이도 이제 높이의 일부가 된다. 늘어남과 줄어듦은 차수별로 더한다.
@<글루를 세로 합계에...@>=
x += d
d = 0
g = gluePtr(p)
x += width(g)
o = stretchOrder(g)
totalStretch[o] += stretch(g)
o = shrinkOrder(g)
totalShrink[o] += shrink(g)
if subtype(p) >= aLeaders {
	g = leaderPtr(p)
	if width(g) > w {
		w = width(g)
	}
}

@ 프로그램의 이 부분에 이르면 |x|는 꾸리고 있는 상자의 자연 높이다. 가로 상자 때와 같이 목표 높이와의 차이로 글루를 정한다.

@<|height(r)|의 값과...@>=
if m == additional {
	h = x + h
}
setHeight(r, h)
x = h - x // 이제 |x|는 메워야 할 초과분이다
if x == 0 {
	setGlueSign(r, normal)
	setGlueOrder(r, normal)
	setGlueSet(r, 0.0)
	return r
} else if x > 0 {
	@<세로 글루의 늘이기 설정을 정하고, |return|하거나 |goto commonEnding|@>
} else {
	@<세로 글루의 줄이기 설정을 정하고, |return|하거나 |goto commonEnding|@>
}

@ 세로 글루를 늘인다. 가로 상자 때와 똑같다.
@<세로 글루의 늘이기...@>=
@<늘이기 차수를...@>
setGlueOrder(r, o)
setGlueSign(r, stretching)
if totalStretch[o] != 0 {
	setGlueSet(r, unfloat(float64(x)/float64(totalStretch[o])))
@^real division@>
} else {
	setGlueSign(r, normal)
	setGlueSet(r, 0.0) // 늘일 것이 없다
}
if o == normal {
	if listPtr(r) != null {
		@<덜 찬 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
	}
}
return r

@ 덜 찬 세로 상자를 \.{\\vbadness}와 견주어 알린다.
@<덜 찬 세로 상자를...@>=
lastBadness = badness(x, totalStretch[normal])
if lastBadness > vbadness() {
	printLn()
	if lastBadness > 100 {
		printNl("Underfull")
	} else {
		printNl("Loose")
	}
	printStr(" \\vbox (badness ")
	printInt(lastBadness)
@.Underfull \\vbox...@>
@.Loose \\vbox...@>
	goto commonEnding
}

@ 세로 상자의 경고 메시지를 마무리한다. 세로 상자가 문단에서 생길 수는 없으므로 정렬이 아니면 현재 줄 번호만 알린다.
@<꽉 차거나 덜 찬 세로 상자에...@>=
if outputActive {
	printStr(") has occurred while \\output is active")
} else {
	if packBeginLine != 0 { // 실은 음수다
		printStr(") in alignment at lines ")
		printInt(abs(packBeginLine))
		printStr("--")
	} else {
		printStr(") detected at line ")
	}
	printInt(line)
	printLn()
}
beginDiagnostic()
showBox(r)
endDiagnostic(true)

@ 세로 글루를 줄인다. 가로 상자 때와 똑같다.
@<세로 글루의 줄이기...@>=
@<줄이기 차수를...@>
setGlueOrder(r, o)
setGlueSign(r, shrinking)
if totalShrink[o] != 0 {
	setGlueSet(r, unfloat(float64(-x)/float64(totalShrink[o])))
@^real division@>
} else {
	setGlueSign(r, normal)
	setGlueSet(r, 0.0) // 줄일 것이 없다
}
if totalShrink[o] < -x && o == normal && listPtr(r) != null {
	lastBadness = 1000000
	setGlueSet(r, 1.0) // 최대로 줄인다
	@<꽉 찬 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
} else if o == normal {
	if listPtr(r) != null {
		@<빡빡한 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto commonEnding|@>
	}
}
return r

@ 꽉 찬 세로 상자를 \.{\\vfuzz}와 \.{\\vbadness}에 따라 알린다. 세로 상자에는 넘침 괘선을 붙이지 않는다.
@<꽉 찬 세로 상자를...@>=
if -x-totalShrink[normal] > vfuzz() || vbadness() < 100 {
	printLn()
	printNl("Overfull \\vbox (")
@.Overfull \\vbox...@>
	printScaled(-x - totalShrink[normal])
	printStr("pt too high")
	goto commonEnding
}

@ 빡빡한 세로 상자를 알린다.
@<빡빡한 세로 상자를...@>=
lastBadness = badness(-x, totalShrink[normal])
if lastBadness > vbadness() {
	printLn()
	printNl("Tight \\vbox (badness ")
	printInt(lastBadness)
@.Tight \\vbox...@>
	goto commonEnding
}

@ 상자를 현재의 세로 목록에 덧붙일 때 줄 사이 간격을 계산하는 일은 루틴 |appendToVlist|가 맡는다. 앞 상자의 깊이
|prevDepth|와 새 상자의 높이를 \.{\\baselineskip}에서 빼서, 두 기준선 사이가 \.{\\baselineskip}이 되도록 글루를 넣는다.
그 간격이 \.{\\lineskiplimit}보다 작아지면 대신 \.{\\lineskip}을 넣는다. 그러고 나서 새 상자의 깊이를 |prevDepth|로 삼는다.

@<함수들@>=
func appendToVlist(b pointer) {
	var d scaled // 기준선 사이 간격의 모자람
	var p pointer // 새 글루 노드
	if prevDepth() > ignoreDepth {
		d = width(baselineSkip()) - prevDepth() - height(b)
		if d < lineSkipLimit() {
			p = newParamGlue(lineSkipCode)
		} else {
			p = newSkipParam(baselineSkipCode)
			setWidth(tempPtr, d) // |tempPtr=gluePtr(p)|
		}
		setLink(tail, p)
		tail = p
	}
	setLink(tail, b)
	tail = b
	setPrevDepth(depth(b))
}

@* 수식 모드의 자료 구조.
\TeX은 \.\$로 둘러싼 수식을 읽으면 {\sl 수식 목록}(mlist)을 만든다. 수식 목록은 본질적으로 그 수식을 나타내는 나무
구조다. 겉으로는 항목들이 한 줄로 늘어선 목록이지만, 수식 목록 안에 다시 수식 목록이 들어갈 수 있으므로 나무로 볼 수
있다. 이를테면 많은 항목에 아래첨자나 위첨자가 붙을 수 있는데, 그런 ``첨자''는 그 자체로 수식 목록이다.

실제로 조판하기 전에 수식 전체를 먼저 이런 나무로 분석한다. 수식을 끝까지 읽기 전에는 지금의 활자 모양을 알 수 없는
때가 많기 때문이다. 이를테면 수식 `\.{\$a+b \\over c+d\$}'를 읽을 때, `\.{\\over}'가 나오기 전에는 `\.{a+b}'가 분자가 되어
더 작은 크기로 찍힐지 알 길이 없다.

읽어 들이면서 만드는 수식 목록의 원소는 저마다 관계 기호, 이항 연산자, 여는 괄호 따위로, 또는 쌓아 올려야 하는
`\.{\\sqrt}' 같은 구성으로 분류된다. 이 분류가 수식 목록 자료 구조에 그대로 나타난다. 분류는 나중에 원소 사이의 간격을 정할
때 쓰인다.

수식을 다 읽고 나면 수식 목록을 가로 목록으로 바꾸어서 둘레의 텍스트에 넣을 수 있게 한다. 이 변환은 재귀 프로시저가 맡는데,
이 프로시저는 가장 바깥 수준에서 시작해 하위 수식들로 내려가며 ``위에서 아래로'' 알맞은 모양을 정한다. 결국 수식은 가로
상자와 세로 상자를 조합하고, 필요한 곳에 글루와 벌점 노드를 끼워 넣어 짜 맞춘 것이 된다.

수식 목록은 안에서 주로 ``노드''(noad, `노-애드'라고 읽는다)로 이루어진 연결 목록으로 나타낸다. 이 이름은 가로 목록과 세로
목록의 조금 비슷한 ``노드''(node)와 구별하려는 것이다. 어떤 종류의 보통 노드(node)는 노드(noad)와 함께 수식 목록에 나올 수
있다. \TeX은 둘을 \ID{type} 필드로 구별한다. 노드(noad)의 \ID{type}은 언제나 노드(node)의 것보다 크기 때문이다. 수식 목록에는
문자 노드, 가로 목록 노드, 세로 목록 노드, 수식 노드, 합자 노드, 미정 노드가 들어가지 않는다. 특히 수식 목록의 항목은 모두
|mem|의 가변 크기 영역에 있으므로 언제나 \ID{type} 필드가 있다.

이 문서에서는 둘을 다 그냥 노드라고 부르되, 헷갈릴 만한 곳에서는 노드(noad)와 노드(node)처럼 원어를 덧붙인다.

@ 노드(noad)는 모두 네 낱말 이상이다. 첫 낱말에는 이미 아주 익숙한 \ID{type}과 |subtype|과 |link| 필드가 들어 있다. 둘째,
셋째, 넷째 낱말을 노드의 |nucleus|, |subscr|, |supscr| 필드라고 부른다. 곧 핵과 아래첨자와 위첨자다.

이를테면 간단한 수식 `\.{\$x\^2\$}'를 생각해 보자. 이 수식은 |ordNoad| 하나를 담은 수식 목록으로 분석된다. 이 노드의
|nucleus|는 `\.x'를 나타내고, |subscr|는 비어 있으며, |supscr|는 `\.2'를 나타낸다.

필드 |nucleus|, |subscr|, |supscr|는 다시 하위 필드로 나뉜다. 포인터 |p|가 노드를 가리키고 |q|가 그 주요 필드 가운데
하나라면(이를테면 |q=subscr(p)|), |q|의 |mathType|에 따라 여러 경우가 있다.

\yskip\hang|mathType(q)=mathChar|는 |fam(q)|가 열여섯 글꼴 가족 가운데 하나를 가리키고, |character(q)|가 문자 노드에서처럼
그 가족 글꼴 안의 문자 번호라는 뜻이다.

\yskip\hang|mathType(q)=mathTextChar|도 비슷하지만, 그 문자에는 아래첨자도 위첨자도 붙지 않았고 바로 뒤에 같은 글꼴의 다른
문자가 온다는 뜻이다. (이 |mathType|은 처리하는 도중에 잠깐만 나타난다. 원하지 않는 기울임 보정을 막는 데 쓴다.)

\yskip\hang|mathType(q)=empty|는 값이 없는 필드를 나타낸다(노드 |p|에 그 속성이 없다).

\yskip\hang|mathType(q)=subBox|는 |info(q)|가 상자 노드(|hlistNode|나 |vlistNode|)를 가리키고, 그것을 이 필드의 값으로 써야
한다는 뜻이다. 하위 상자 노드의 |shiftAmount|는 그 상자를 아래로 옮길 양이다.

\yskip\hang|mathType(q)=subMlist|는 |info(q)|가 수식 목록을 가리킨다는 뜻이다. 이 필드의 값을 얻으려면 그 수식 목록을 가로
목록으로 바꾸어야 한다.

\yskip\noindent 마지막 경우에는 |info(q)=null|일 수도 있다. 이것은 |mathType(q)=empty|와 같지 않다. 이를테면
`\.{\$P\_\{\}\$}'와 `\.{\$P\$}'는 결과가 다르다(앞의 것에서는 |P|의 너비에 ``기울임 보정''이 더해지지 않고, 대신
``첨자 뒤 간격''이 더해진다).

여기서 정한 하위 필드는 분명히 공간을 낭비한다. 필드 |mathType|에는 세 비트면 되는데 하프워드를 쓰기 때문이다. 그러나
노드(noad)가 한꺼번에 많이 있는 일은 거의 없다. 노드(noad)는 곧 더 많은 공간을 차지하는 노드(node)로 바뀌므로, 프로그램을
가장 단순하게 하는 방식으로 나타낼 여유가 있다.

@<정의@>=
const (
	@!noadSize = 4 // 보통 노드의 낱말 수
	@!mathChar = 1 // 속성이 단순할 때의 |mathType|
	@!subBox = 2 // 속성이 상자일 때의 |mathType|
	@!subMlist = 3 // 속성이 수식일 때의 |mathType|
	@!mathTextChar = 4 // 기울임 보정이 미심쩍을 때의 |mathType|
)

func nucleus(p pointer) pointer { return p + 1 } // 노드의 |nucleus| 필드
func supscr(p pointer) pointer  { return p + 2 } // 노드의 |supscr| 필드
func subscr(p pointer) pointer  { return p + 3 } // 노드의 |subscr| 필드
func mathType(p pointer) halfword { return link(p) } // |mem|의 |halfword|
func setMathType(p pointer, v halfword) { setLink(p, v) }
func fam(p pointer) quarterword { return font(p) } // |mem|의 |quarterword|
func setFam(p pointer, v quarterword) { setFontField(p, v) }

@ 수식의 각 부분은 간격과 줄 나누기를 위해 Ord, Op, Bin, Rel, Open, Close, Punct, Inner 가운데 하나로 분류된다. 이 여덟 종류를
|ordNoad|, |opNoad|, |binNoad|, |relNoad|, |openNoad|, |closeNoad|, |punctNoad|, |innerNoad|로 나타낸다. 이를테면 수식 안의
`\.=' 기호는 |nucleus| 필드가 등호를 나타내는(대개 |fam=0|, |character=@'75|) |relNoad|가 된다. 명령 \.{\\mathrel}을 앞에
붙인 수식도 |relNoad|가 된다. 노드 |relNoad| 뒤에 이를테면 |opNoad|가 오면(그 사이에 보통 노드가 하나 이상 끼어 있을 수도
있다), \TeX은 |relNoad|에 해당하는 수식 바로 뒤에 (현재의 |relPenalty|를 가진) 벌점 노드를 끼워 넣는다. 다만 바로 뒤에 이미
벌점이 있으면 넣지 않는다. 그리고 |opNoad|에 해당하는 수식 바로 앞에는 ``굵은 공백''을 끼워 넣는다. 그래서 `$x=\sum y$'에서
등호 뒤에서는 줄을 나눌 수 있고, 등호와 $\sum$ 사이는 넓게 띄워진다.

형이 |ordNoad|, |opNoad|, \dots, |innerNoad|인 노드는 대개 |subtype=normal|이다. 단 하나의 예외는 |opNoad|다. 사용자가
\.{\\limits}나 \.{\\nolimits}로 극한의 보통 위치를 바꾸었으면 |subtype|이 |limits|나 |noLimits|가 된다.

@<정의@>=
const (
	@!ordNoad = unsetNode + 3 // Ord로 분류된 노드의 \ID{type}
	@!opNoad = ordNoad + 1 // Op로 분류된 노드의 \ID{type}
	@!binNoad = ordNoad + 2 // Bin으로 분류된 노드의 \ID{type}
	@!relNoad = ordNoad + 3 // Rel로 분류된 노드의 \ID{type}
	@!openNoad = ordNoad + 4 // Open으로 분류된 노드의 \ID{type}
	@!closeNoad = ordNoad + 5 // Close로 분류된 노드의 \ID{type}
	@!punctNoad = ordNoad + 6 // Punct로 분류된 노드의 \ID{type}
	@!innerNoad = ordNoad + 7 // Inner로 분류된 노드의 \ID{type}
	@!limits = 1 // 첨자가 위아래에 오는 |opNoad|의 |subtype|
	@!noLimits = 2 // 첨자가 보통 자리에 오는 |opNoad|의 |subtype|
)

@ 노드 |radicalNoad|는 다섯 낱말 길이다. 다섯째 낱말은 |leftDelimiter| 필드인데, 대개 제곱근 기호를 나타낸다.

노드 |fractionNoad|는 여섯 낱말 길이다. 이 노드에는 |leftDelimiter|만이 아니라 |rightDelimiter| 필드도 있다.

구분자 필드는 형이 |fourQuarters|이고, |smallFam|, |smallChar|, |largeFam|, |largeChar|라는 하위 필드가 넷 있다. 이 하위
필드들은 {\sl The \TeX book}의 17장에서 설명하듯이 ``작은'' 시작 문자와 ``큰'' 시작 문자를 주어 크기가 변하는 구분자를
@^TeXbook@>
나타낸다. 작은 쪽은 보통 본문 글꼴에서, 큰 쪽은 수식 확장 글꼴에서 찾기 시작한다.

노드 |fractionNoad|는 사실 다른 노드들과 아주 다르다. 여섯 낱말이라는 것만이 아니라, |nucleus|, |subscr|, |supscr| 대신
|thickness|, |denominator|, |numerator| 필드가 있다. 필드 |thickness|는 분수 괘선의 두께를 담은 눈금 값이다. 다만 특별한 값
|defaultCode|는 현재 크기의 |defaultRuleThickness|를 쓰라는 뜻이다. 필드 |numerator|와 |denominator|는 분수를 이루는 수식
목록을 가리킨다. 언제나 $$\hbox{|mathType(numerator)=mathType(denominator)=subMlist|}$$이다. 필드 |leftDelimiter|와
|rightDelimiter|는 분수의 왼쪽과 오른쪽에 놓을 구분자를 지정한다. 이렇게 해서 |fractionNoad| 하나로 \TeX의 연산자 \.{\\over},
\.{\\atop}, \.{\\above}, \.{\\overwithdelims}, \.{\\atopwithdelims}, \.{\\abovewithdelims}를 모두 나타낼 수 있다. 이를테면
\.{\\atop}은 두께가 0인 분수이고, \.{\\choose}는 괄호를 구분자로 단 \.{\\atop}이다.

@<정의@>=
const (
	@!radicalNoad = innerNoad + 1 // 제곱근을 위한 노드의 \ID{type}
	@!radicalNoadSize = 5 // 근호 노드의 |mem| 낱말 수
	@!fractionNoad = radicalNoad + 1 // 일반화된 분수를 위한 노드의 \ID{type}
	@!fractionNoadSize = 6 // 분수 노드의 |mem| 낱말 수
	@!defaultCode = 0o10000000000 // |defaultRuleThickness|를 나타낸다
)

func leftDelimiter(p pointer) pointer  { return p + 4 } // 노드의 첫 구분자 필드
func rightDelimiter(p pointer) pointer { return p + 5 } // 분수 노드의 둘째 구분자 필드
func smallFam(p pointer) quarterword  { return mem[p].qqqq.b0 } // ``작은'' 구분자의 |fam|
func setSmallFam(p pointer, v quarterword)  { mem[p].qqqq.b0 = v }
func smallChar(p pointer) quarterword { return mem[p].qqqq.b1 } // ``작은'' 구분자의 |character|
func setSmallChar(p pointer, v quarterword) { mem[p].qqqq.b1 = v }
func largeFam(p pointer) quarterword  { return mem[p].qqqq.b2 } // ``큰'' 구분자의 |fam|
func setLargeFam(p pointer, v quarterword)  { mem[p].qqqq.b2 = v }
func largeChar(p pointer) quarterword { return mem[p].qqqq.b3 } // ``큰'' 구분자의 |character|
func setLargeChar(p pointer, v quarterword) { mem[p].qqqq.b3 = v }
func thickness(p pointer) scaled { return width(p) } // 분수 노드의 |thickness| 필드
func setThickness(p pointer, v scaled) { setWidth(p, v) }
func numerator(p pointer) pointer   { return supscr(p) } // 분수 노드의 |numerator| 필드
func denominator(p pointer) pointer { return subscr(p) } // 분수 노드의 |denominator| 필드

@ 전역 변수 |emptyField|는 새 노드의 빈 필드를 초기화하는 데 쓰려고 마련해 둔 것이다. 마찬가지로 |nullDelimiter|는 구분자
필드를 초기화하는 데 쓴다.

@<전역 변수@>=
var @!emptyField twoHalves
var @!nullDelimiter fourQuarters

@ 빈 필드는 |mathType|이 |empty|이고 정보가 |null|인 필드다. 널 구분자는 작은 쪽과 큰 쪽이 모두 가족 0의 문자 0이다.
@<핵심 변수들의...@>=
emptyField.rh = empty
emptyField.lh = null
nullDelimiter.b0 = 0
nullDelimiter.b1 = minQuarterword
nullDelimiter.b2 = 0
nullDelimiter.b3 = minQuarterword

@ 함수 |newNoad|는 완전히 빈 |ordNoad|를 만든다. 세 필드가 모두 비어 있다.

@<함수들@>=
func newNoad() pointer {
	p := getNode(noadSize)
	setType(p, ordNoad)
	setSubtype(p, normal)
	mem[nucleus(p)].hh = emptyField
	mem[subscr(p)].hh = emptyField
	mem[supscr(p)].hh = emptyField
	return p
}

@ 노드 몇 종류가 더 있으면 한 벌이 다 갖추어진다. 노드 |underNoad|는 핵에 밑줄을 긋고, |overNoad|는 윗줄을 긋는다. 노드
|accentNoad|는 핵 위에 악센트를 얹는다. 악센트 문자는 |fam(accentChr(p))|와 |character(accentChr(p))|로 나타낸다. 노드
|vcenterNoad|는 핵을 수식의 축에 맞추어 세로로 가운데 놓는다. 이 노드에서는 언제나 |mathType(nucleus(p))=subBox|다.

그리고 마지막으로 \TeX의 \.{\\left}와 \.{\\right}를 구현하는 |leftNoad|와 |rightNoad|가 있다. 이 노드에서는 |nucleus| 자리를
|delimiter| 필드로 쓴다. 그래서 이를테면 `\.{\\left(}'는 |delimiter(p)|에 왼쪽 괄호의 가족과 문자 코드를 담은 |leftNoad|가
된다. 노드 |leftNoad|는 수식 목록의 첫 원소로만 나오고, |rightNoad|는 마지막 원소로만 나온다. 게다가 |leftNoad|와 |rightNoad|는
둘 다 있거나 둘 다 없다. 명령 \.{\\left}와 \.{\\right} 사이가 그 자체로 하위 수식 목록이 되기 때문이다. 이 두 노드의 |subscr|와
|supscr| 필드는 언제나 |empty|다.

@<정의@>=
const (
	@!underNoad = fractionNoad + 1 // 밑줄을 위한 노드의 \ID{type}
	@!overNoad = underNoad + 1 // 윗줄을 위한 노드의 \ID{type}
	@!accentNoad = overNoad + 1 // 악센트 붙은 하위 수식을 위한 노드의 \ID{type}
	@!accentNoadSize = 5 // 악센트 노드의 |mem| 낱말 수
	@!vcenterNoad = accentNoad + 1 // \.{\\vcenter}를 위한 노드의 \ID{type}
	@!leftNoad = vcenterNoad + 1 // \.{\\left}를 위한 노드의 \ID{type}
	@!rightNoad = leftNoad + 1 // \.{\\right}를 위한 노드의 \ID{type}
)

func accentChr(p pointer) pointer { return p + 4 } // 악센트 노드의 |accentChr| 필드
func delimiter(p pointer) pointer  { return nucleus(p) } // 왼쪽과 오른쪽 노드의 |delimiter| 필드
func scriptsAllowed(p pointer) bool { return typ(p) >= ordNoad && typ(p) < leftNoad }

@ 수식에는 \.{\\textstyle}처럼 \TeX의 보통 모양 규칙을 무시하라는 명령도 들어 있을 수 있다. 그런 명령을 기억하려고 자료 구조에
|styleNode|를 끼워 넣는다. 이 노드는 세 낱말 길이이므로 노드(noad)가 아니라 노드(node)로 친다. 그 |subtype|은 |displayStyle|,
|textStyle|, |scriptStyle|, |scriptScriptStyle| 가운데 하나다. 노드 |styleNode|의 둘째와 셋째 낱말은 쓰지 않지만, |choiceNode|가
|styleNode|로 바뀌므로 자리를 맞추어 둔 것이다.

\TeX은 기본 모양 |displayStyle|, \dots, |scriptScriptStyle|을 짝수 0, 2, 4, 6으로 나타내고, 1을 더해서 그 모양의 ``조인''(cramped)
판을 얻는다. 조인 모양에서는 위첨자를 덜 올린다. 이렇게 하면 수의 순서가 {\sl The \TeX book}의 부록~G의 관례와 거꾸로가
@^TeXbook@>
된다. 곧 더 작은 모양일수록 수가 크다.

@<함수들@>=
const (
	@!styleNode = unsetNode + 1 // 모양 노드의 \ID{type}
	@!styleNodeSize = 3 // 모양 노드의 낱말 수
	@!displayStyle = 0 // \.{\\displaystyle}의 |subtype|
	@!textStyle = 2 // \.{\\textstyle}의 |subtype|
	@!scriptStyle = 4 // \.{\\scriptstyle}의 |subtype|
	@!scriptScriptStyle = 6 // \.{\\scriptscriptstyle}의 |subtype|
	@!cramped = 1 // 조이지 않은 모양을 조이려면 이것을 더한다
)

func newStyle(s smallNumber) pointer { // 모양 노드를 만든다
	p := getNode(styleNodeSize) // 새 노드
	setType(p, styleNode)
	setSubtype(p, s)
	setWidth(p, 0)
	setDepth(p, 0) // |width|와 |depth|는 쓰이지 않는다
	return p
}

@ 마지막으로 원시 명령 \.{\\mathchoice}는 |choiceNode|를 만든다. 이 노드에는 모양마다 쓸 수식 목록을 가리키는 특별한 하위
필드 |displayMlist|, |textMlist|, |scriptMlist|, |scriptScriptMlist|가 있다. 실제로 어느 모양으로 조판할지는 수식 목록을
가로 목록으로 바꿀 때에야 알 수 있으므로 네 가지를 모두 들고 다닌다.

@<함수들@>=
const @!choiceNode = unsetNode + 2 // 선택 노드의 \ID{type}

func displayMlist(p pointer) pointer       { return info(p + 1) } // 따로 세운 모양에 쓸 수식 목록
func setDisplayMlist(p pointer, v pointer) { setInfo(p+1, v) }
func textMlist(p pointer) pointer          { return link(p + 1) } // 본문 모양에 쓸 수식 목록
func setTextMlist(p pointer, v pointer)   { setLink(p+1, v) }
func scriptMlist(p pointer) pointer        { return info(p + 2) } // 첨자 모양에 쓸 수식 목록
func setScriptMlist(p pointer, v pointer) { setInfo(p+2, v) }
func scriptScriptMlist(p pointer) pointer { return link(p + 2) } // 첨자의 첨자 모양에 쓸 수식 목록
func setScriptScriptMlist(p pointer, v pointer) { setLink(p+2, v) }

func newChoice() pointer { // 선택 노드를 만든다
	p := getNode(styleNodeSize) // 새 노드
	setType(p, choiceNode)
	setSubtype(p, 0) // |subtype|은 쓰이지 않는다
	setDisplayMlist(p, null)
	setTextMlist(p, null)
	setScriptMlist(p, null)
	setScriptScriptMlist(p, null)
	return p
}

@ 이제 |showNodeList|에서 아직 남겨 둔 부분, 곧 수식 목록에만 있을 수 있는 것들을 보여 주는 부분을 살펴보자. 이 프로그램을
보면 방금 정의한 자료 구조를 어떻게 다루는지 알 수 있다.

다음 프로그램의 문맥에서 |p|는 보여 줄 노드를 가리키고, 현재 문자열에는 이 지점에 이르는 ``재귀 내력''이 들어 있다. 재귀
내력은 |p|가 어떤 노드에 속하거나 어떤 노드의 |nucleus| 필드에 속하는 바깥 수준마다 점 하나씩으로 이루어진다. 포인터 |p|가
노드의 |subscr|나 |supscr|나 |denominator|나 |numerator| 필드에서 내려온 것이면 점 대신 `\.\_'나 `\.\^'나 `\./'나 `\.\\'가 된다.
이를테면 |p|가 (터무니없는) 수식 `\.{\$\\sqrt\{a\^\{\\mathinner\{b\_\{c\\over x+y\}\}\}\}\$}'에서 |x|의 |ordNoad|를 가리키면
현재 문자열은 `\.{.\^.\_/}'일 것이다.

@<수식 목록에서만 생기는 |showNodeList|의 경우들@>=
case styleNode: printStyle(subtype(p))
case choiceNode: @<선택 노드 |p|를 보인다@>
case ordNoad, opNoad, binNoad, relNoad, openNoad, closeNoad, punctNoad, innerNoad,
	radicalNoad, overNoad, underNoad, vcenterNoad, accentNoad,
	leftNoad, rightNoad: @<보통 노드 |p|를 보인다@>
case fractionNoad: @<분수 노드 |p|를 보인다@>

@ 다음은 노드를 보여 주는 데 쓰는 간단한 루틴 몇 개다. 수식 문자는 `\.{\\fam1 x}'처럼, 구분자는 24비트 16진 값으로 찍는다.

@<수식 목록의 원소들을 보이는...@>=
func printFamAndChar(p pointer) { // 가족과 문자를 찍는다
	printEsc("fam")
	printInt(fam(p))
	printChar(' ')
	printASCII(qo(character(p)))
}

func printDelimiter(p pointer) { // 구분자를 24비트 십육진 값으로 찍는다
	a := smallFam(p)*256 + qo(smallChar(p)) // 누산기
	a = a*0x1000 + largeFam(p)*256 + qo(largeChar(p))
	if a < 0 {
		printInt(a) // 이런 일은 결코 일어나지 않아야 한다
	} else {
		printHex(a)
	}
}

@ 다음 서브루틴은 하위 수식 목록을 보여야 할 때 재귀의 다음 수준으로 내려간다. 매개변수 |c|는 재귀 내력에 덧붙일 문자다.
빈 수식 목록은 |mathType(p)=empty|인 필드와 구별해서 보여 준다. 앞에서 설명했듯이 이 둘은 같지 않기 때문이다.
@^recursion@>


@<수식 목록의 원소들을 보이는...@>=
func printSubsidiaryData(p pointer, c asciiCode) { // 노드의 필드를 보인다
	if curLength() >= depthThreshold {
		if mathType(p) != empty {
			printStr(" []")
		}
	} else {
		appendChar(c) // |c|를 재귀 내력에 넣는다
		tempPtr = p // 재귀가 필요하면 |showInfo|를 위해 준비한다
		switch mathType(p) {
		case mathChar:
			printLn()
			printCurrentString()
			printFamAndChar(p)
		case subBox:
			showInfo() // 재귀 호출
		case subMlist:
			if info(p) == null {
				printLn()
				printCurrentString()
				printStr("{}")
			} else {
				showInfo() // 재귀 호출
			}
		default: // |empty|
		}
		flushChar() // |c|를 재귀 내력에서 없앤다
	}
}

@ 위의 코드에 |showInfo|를 꼴사납게 끌어들이고 전역 변수 |tempPtr|로 매개변수를 넘긴 것은, 이 프로그램을 다른 언어로 옮길 때
매개변수가 있는 프로시저를 미리 선언하는 이상한 관례에 시달리지 않게 하려는 것이다. 앞선 선언에서는 프로시저의 매개변수를
빼야 한다는 어떤 언어의 관례는, 솔직히 말해 \TeX의 저자에게 너무도 참을 수 없는 것이어서, 그는 차라리 전역 임시 변수로
소통하는 데까지 몸을 낮추겠다. (비슷한 어리석음이 앞에서 |hlistOut|과 |vlistOut|에 있었고, 아래에서 |mlistToHlist|에도 있을
것이다.)
@^Knuth, Donald Ervin@>

@<함수들@>=
func showInfo() { // 독자는 이것을 너그러이 용서해 주시라
	showNodeList(info(tempPtr))
}

@ 모양 노드는 `\.{\\displaystyle}'처럼 그 모양의 이름으로 찍는다. 조인 모양도 같은 이름으로 찍는다.
@<수식 목록의 원소들을 보이는...@>=
func printStyle(c int32) {
	switch c / 2 {
	case 0: printEsc("displaystyle") // |displayStyle=0|
	case 1: printEsc("textstyle") // |textStyle=2|
	case 2: printEsc("scriptstyle") // |scriptStyle=4|
	case 3: printEsc("scriptscriptstyle") // |scriptScriptStyle=6|
	default: printStr("Unknown style!")
	}
}

@ 선택 노드는 네 수식 목록을 재귀 내력 문자 \.D, \.T, \.S, \.s를 붙여 차례로 보여 준다.
@<선택 노드 |p|를...@>=
printEsc("mathchoice")
appendChar('D'); showNodeList(displayMlist(p)); flushChar()
appendChar('T'); showNodeList(textMlist(p)); flushChar()
appendChar('S'); showNodeList(scriptMlist(p)); flushChar()
appendChar('s'); showNodeList(scriptScriptMlist(p)); flushChar()

@ 보통 노드는 종류를 밝히는 `\.{\\mathord}' 같은 이름을 찍고, 극한 지정이 있으면 덧붙인 다음, 핵과 첨자들을 차례로 보여 준다.
@<보통 노드 |p|를...@>=
switch typ(p) {
case ordNoad: printEsc("mathord")
case opNoad: printEsc("mathop")
case binNoad: printEsc("mathbin")
case relNoad: printEsc("mathrel")
case openNoad: printEsc("mathopen")
case closeNoad: printEsc("mathclose")
case punctNoad: printEsc("mathpunct")
case innerNoad: printEsc("mathinner")
case overNoad: printEsc("overline")
case underNoad: printEsc("underline")
case vcenterNoad: printEsc("vcenter")
case radicalNoad: printEsc("radical"); printDelimiter(leftDelimiter(p))
case accentNoad: printEsc("accent"); printFamAndChar(accentChr(p))
case leftNoad: printEsc("left"); printDelimiter(delimiter(p))
case rightNoad: printEsc("right"); printDelimiter(delimiter(p))
}
if subtype(p) != normal {
	if subtype(p) == limits {
		printEsc("limits")
	} else {
		printEsc("nolimits")
	}
}
if typ(p) < leftNoad {
	printSubsidiaryData(nucleus(p), '.')
}
printSubsidiaryData(supscr(p), '^')
printSubsidiaryData(subscr(p), '_')

@ 분수 노드는 괘선의 두께와 구분자를 찍고, 분자와 분모를 보여 준다.
@<분수 노드 |p|를...@>=
printEsc("fraction, thickness ")
if thickness(p) == defaultCode {
	printStr("= default")
} else {
	printScaled(thickness(p))
}
if smallFam(leftDelimiter(p)) != 0 ||
	smallChar(leftDelimiter(p)) != minQuarterword ||
	largeFam(leftDelimiter(p)) != 0 ||
	largeChar(leftDelimiter(p)) != minQuarterword {
	printStr(", left-delimiter ")
	printDelimiter(leftDelimiter(p))
}
if smallFam(rightDelimiter(p)) != 0 ||
	smallChar(rightDelimiter(p)) != minQuarterword ||
	largeFam(rightDelimiter(p)) != 0 ||
	largeChar(rightDelimiter(p)) != minQuarterword {
	printStr(", right-delimiter ")
	printDelimiter(rightDelimiter(p))
}
printSubsidiaryData(numerator(p), '\\')
printSubsidiaryData(denominator(p), '/')

@ 보일 수 있는 것은 없앨 수도 있다. 수식 목록의 노드를 지울 때는 하위 수식 목록도 함께 지운다.

@<수식 목록에서만 생기는 |flushNodeList|의 경우들@>=
case styleNode:
	freeNode(p, styleNodeSize)
	goto done
case choiceNode:
	flushNodeList(displayMlist(p))
	flushNodeList(textMlist(p))
	flushNodeList(scriptMlist(p))
	flushNodeList(scriptScriptMlist(p))
	freeNode(p, styleNodeSize)
	goto done
case ordNoad, opNoad, binNoad, relNoad, openNoad, closeNoad, punctNoad, innerNoad,
	radicalNoad, overNoad, underNoad, vcenterNoad, accentNoad:
	if mathType(nucleus(p)) >= subBox {
		flushNodeList(info(nucleus(p)))
	}
	if mathType(supscr(p)) >= subBox {
		flushNodeList(info(supscr(p)))
	}
	if mathType(subscr(p)) >= subBox {
		flushNodeList(info(subscr(p)))
	}
	if typ(p) == radicalNoad {
		freeNode(p, radicalNoadSize)
	} else if typ(p) == accentNoad {
		freeNode(p, accentNoadSize)
	} else {
		freeNode(p, noadSize)
	}
	goto done
case leftNoad, rightNoad:
	freeNode(p, noadSize)
	goto done
case fractionNoad:
	flushNodeList(info(numerator(p)))
	flushNodeList(info(denominator(p)))
	freeNode(p, fractionNoadSize)
	goto done

@* 수식 모드의 서브루틴.
수식 목록을 가로 목록으로, 곧 노드(noad)를 노드(node)로 바꾸려면 서브루틴이 여럿 필요한데, 지금 다루어 두는 것이 편하다.

먼저 글꼴 매개변수와 그 밖의 글꼴 정보를 쉽게 꺼내는 함수들을 소개하자. 16의 배수인 크기 코드를 가족 번호에 더하면, 가족과
크기의 짝마다 내부 글꼴 번호를 담은 표의 첨자를 얻는다. 이를테면 가족 1의 첨자 크기 글꼴은 |famFnt(1+scriptSize)|다.
(조심하라. 크기 코드는 활자가 작아질수록 커진다.)

@<기본 인쇄...@>=
const (
	@!textSize = 0 // 한 가족에서 가장 큰 크기의 크기 코드
	@!scriptSize = 16 // 한 가족에서 중간 크기의 크기 코드
	@!scriptScriptSize = 32 // 한 가족에서 가장 작은 크기의 크기 코드
)

func printSize(s int32) {
	if s == textSize {
		printEsc("textfont")
	} else if s == scriptSize {
		printEsc("scriptfont")
	} else {
		printEsc("scriptscriptfont")
	}
}

@ 수식 목록을 가로 목록으로 바꾸기 전에 \TeX은 가족~2의 글꼴들이 수식 기호 글꼴로 쓰일 만큼 매개변수를 넉넉히 가졌는지,
가족~3의 글꼴들이 수식 확장 글꼴로 쓰일 만큼 매개변수를 가졌는지 확인한다. 수식 조판에 필요한 치수는 대부분 이 두 글꼴의
매개변수에서 온다. 수식 기호 매개변수는 다음 함수들로 가리킨다. 이 함수들은 크기 코드를 인자로 받는다. 이를테면 |num1(curSize)|는
현재 크기에서 |num1| 매개변수의 값이다.
@^parameters for symbols@>
@^font parameters@>

@<정의@>=
func mathsy(k, s int32) scaled { return fontInfo[k+paramBase[famFnt(2+s)]].sc }

func mathXHeight(s int32) scaled { return mathsy(5, s) } // `\.x'의 높이
func mathQuad(s int32) scaled { return mathsy(6, s) } // \.{18mu}
func num1(s int32) scaled { return mathsy(8, s) } // 따로 세운 모양에서 분자를 올리는 양
func num2(s int32) scaled { return mathsy(9, s) } // 따로 세우지 않은 \.{\\atop} 아닌 분자를 올리는 양
func num3(s int32) scaled { return mathsy(10, s) } // 따로 세우지 않은 \.{\\atop}의 분자를 올리는 양
func denom1(s int32) scaled { return mathsy(11, s) } // 따로 세운 모양에서 분모를 내리는 양
func denom2(s int32) scaled { return mathsy(12, s) } // 따로 세우지 않은 모양에서 분모를 내리는 양
func sup1(s int32) scaled { return mathsy(13, s) } // 조이지 않은 따로 세운 모양에서 위첨자를 올리는 양
func sup2(s int32) scaled { return mathsy(14, s) } // 조이지 않은 다른 모양에서 위첨자를 올리는 양
func sup3(s int32) scaled { return mathsy(15, s) } // 조인 모양에서 위첨자를 올리는 양
func sub1(s int32) scaled { return mathsy(16, s) } // 위첨자가 없을 때 아래첨자를 내리는 양
func sub2(s int32) scaled { return mathsy(17, s) } // 위첨자가 있을 때 아래첨자를 내리는 양
func supDrop(s int32) scaled { return mathsy(18, s) } // 큰 상자의 위 끝에서 위첨자 기준선까지
func subDrop(s int32) scaled { return mathsy(19, s) } // 큰 상자의 아래 끝에서 아래첨자 기준선까지
func delim1(s int32) scaled { return mathsy(20, s) } // 따로 세운 모양에서 \.{\\atopwithdelims} 구분자의 크기
func delim2(s int32) scaled { return mathsy(21, s) } // 다른 모양에서 \.{\\atopwithdelims} 구분자의 크기
func axisHeight(s int32) scaled { return mathsy(22, s) } // 기준선 위로 분수 괘선까지의 높이

const @!totalMathsyParams = 22

@ 수식 확장 매개변수에도 비슷한 함수들이 있지만 크기 코드는 받지 않는다. 그런 매개변수를 쓸 때는 언제나 |curSize|이기 때문이다.
@^parameters for symbols@>
@^font parameters@>

@<정의@>=
func mathex(k int32) scaled { return fontInfo[k+paramBase[famFnt(3+curSize)]].sc }

func defaultRuleThickness() scaled { return mathex(8) } // \.{\\over} 괘선의 두께
func bigOpSpacing1() scaled { return mathex(9) } // 따로 세운 연산자 위의 최소 틈
func bigOpSpacing2() scaled { return mathex(10) } // 따로 세운 연산자 아래의 최소 틈
func bigOpSpacing3() scaled { return mathex(11) } // 따로 세운 연산자 위의 최소 기준선 간격
func bigOpSpacing4() scaled { return mathex(12) } // 따로 세운 연산자 아래의 최소 기준선 간격
func bigOpSpacing5() scaled { return mathex(13) } // 따로 세운 극한의 위와 아래에 덧대는 양

const @!totalMathexParams = 13

@ 수식 목록과 그 하위 수식 목록 사이의 모양 변화도 계산해야 한다. 다음 함수들은 윗줄 그은 핵(|crampedStyle|), 아래첨자나
위첨자(|subStyle|나 |supStyle|), 분자나 분모(|numStyle|이나 |denomStyle|)의 모양을 바깥 모양으로부터 정한다. 이를테면 본문
모양 $T$의 위첨자는 $S$, 아래첨자는 조인 $S'$이고, 첨자의 첨자는 $SS$다.

@<정의@>=
func crampedStyle(c int32) int32 { return 2*(c/2) + cramped } // 모양을 조인다
func subStyle(c int32) int32 { return 2*(c/4) + scriptStyle + cramped } // 더 작게, 조여서
func supStyle(c int32) int32 { return 2*(c/4) + scriptStyle + (c % 2) } // 더 작게
func numStyle(c int32) int32 { return c + 2 - 2*(c/6) } // 이미 첨자의 첨자가 아니면 더 작게
func denomStyle(c int32) int32 { return 2*(c/2) + cramped + 2 - 2*(c/6) } // 더 작게, 조여서

@ 모양이 바뀌면 다음 코드로 그에 딸린 정보를 계산한다. 크기 코드와, \.{mu} 단위의 크기 |curMu|, 곧 현재 크기 가족~2 글꼴의
1\,em을 18로 나눈 값이다.

@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>=
if curStyle < scriptStyle {
	curSize = textSize
} else {
	curSize = 16 * ((curStyle - textStyle) / 2)
}
curMu = xOverN(mathQuad(curSize), 18)

@ 다음은 두께 |t|의 괘선 노드를 만드는 함수다. 너비는 흐르는 치수로 두므로, 이 괘선은 결국 자신을 담을 세로 목록의 경계까지
가로로 뻗는다.

@<함수들@>=
func fractionRule(t scaled) pointer { // 분수 괘선을 만든다
	p := newRule() // 새 노드
	setHeight(p, t)
	setDepth(p, 0)
	return p
}

@ 함수 |overbar|는 세로 목록 상자를 돌려준다. 이 상자는 주어진 상자 |b|와, 그 위에 높이 |k|의 커닝, 그 위에 두께 |t|의 괘선,
다시 그 위에 높이 |t|의 빈 공간으로 이루어진다. 명령 \.{\\overline}과 제곱근 기호의 윗줄이 이렇게 만들어진다.

@<함수들@>=
func overbar(b pointer, k, t scaled) pointer {
	p := newKern(k) // 만들고 있는 노드들
	setLink(p, b)
	q := fractionRule(t); setLink(q, p)
	p = newKern(t); setLink(p, q)
	return vpack(p, natural, additional)
}

@ 넉넉히 큰 구분자를 찾거나 만드는 함수 |varDelimiter|는 지금 다루는 보조 함수 가운데 가장 흥미롭다. 어떤 노드의 구분자 필드를
가리키는 포인터 |d|와 크기 코드 |s|와 세로 거리 |v|가 주어지면, 이 함수는 높이와 깊이의 합이 |v| 이상인 |d|의 변형 가운데
가장 작은 것을 담은 상자를 돌려준다. (넉넉히 큰 변형이 없으면 가장 큰 변형을 돌려준다.) 특히 |d|가 늘일 수 있는 문자로
이어지면, 이 루틴은 그 조각들로 얼마든지 큰 구분자를 조립한다. 찾는 차례는 이렇다. 먼저 작은 쪽 문자를 현재 크기와 그보다
작은 크기의 글꼴에서 찾고, |listTag|의 사슬을 따라 점점 큰 변형을 본다. 그래도 모자라면 큰 쪽 문자로 같은 일을 한다.

돌려주는 값은 상자인데, 그 |shiftAmount|는 상자가 주어진 크기의 축에 대해 세로로 가운데 놓이도록 정해져 있다. 조립한 기호를
돌려줄 때 옮기기 전 상자의 높이는 가장 위 조각의 높이다.

@<함수들@>=
@<|varDelimiter|의 하위 프로시저들@>@;
func varDelimiter(d pointer, s smallNumber, v scaled) pointer {
	var b pointer // 만들 상자
	var f, g internalFontNumber // 지금까지 가장 좋은 글꼴 코드와 시험 중인 글꼴 코드
	var c, x, y quarterword // 지금까지 가장 좋은 문자 코드와 시험 중인 문자 코드들
	var m, n int32 // 조각의 개수
	var u scaled // 시험 중인 문자의 높이와 깊이의 합
	var w scaled // 지금까지 가장 큰 높이와 깊이의 합
	var q fourQuarters // 문자 정보
	var hd eightBits // 높이-깊이 바이트
	var r fourQuarters // 늘일 수 있는 문자의 조각
	var z smallNumber // 글꼴 가족의 원소들을 훑는다
	var largeAttempt bool // ``큰'' 변형을 시도하고 있는가?
	f = nullFont; w = 0; largeAttempt = false
	z = smallFam(d); x = smallChar(d)
	for {
		@<|(z,x)|의 변형들을 살핀다@>
		if largeAttempt {
			goto found // 넉넉히 큰 것이 없었다
		}
		largeAttempt = true; z = largeFam(d); x = largeChar(d)
	}
found:
	if f != nullFont {
		@<변수 |b|가 |(f,c)|를 담은 상자를 가리키게 한다@>
	} else {
		b = newNullBox()
		setWidth(b, nullDelimiterSpace()) // 구분자를 찾지 못하면 이 너비를 쓴다
	}
	setShiftAmount(b, half(height(b)-depth(b))-axisHeight(s))
	return b
}

@ 어떤 문자는 어떤 글꼴에 없을 수도 있고, 문자들을 높이가 커지는 차례로 살피지 않을 수도 있어서 찾는 과정이 조금 복잡하다.
더 좋은 문자를 찾을 때마다 |f|와 |c|를 정하고, 넉넉히 큰 변형을 만나자마자 |goto found|한다. 크기는 지금 크기부터 시작해서
더 작은 크기 쪽으로 차례로 본다.

@<|(z,x)|의 변형들을 살핀다@>=
if z != 0 || x != minQuarterword {
	z = z + s + 16
	for {
		z -= 16; g = famFnt(z)
		if g != nullFont {
			@<글꼴 |g|에서 |x|로 시작하는 문자 목록을 살핀다@>
		}
		if z < 16 {
			break
		}
	}
}

@ 글꼴 |g| 안에서 문자 |x|부터 |listTag|의 사슬을 따라간다. 여기서도 더 좋은 문자를 찾을 때마다 |f|와 |c|를 정하고, 넉넉히
큰 변형이나 늘일 수 있는 문자를 만나자마자 |goto found|한다.

@<글꼴 |g|에서 |x|로 시작하는 문자 목록을 살핀다@>=
y = x
if qo(y) >= fontBc[g] && qo(y) <= fontEc[g] {
again:
	q = charInfo(g, y)
	if charExists(q) {
		if charTag(q) == extTag {
			f = g; c = y; goto found
		}
		hd = heightDepth(q)
		u = charHeight(g, hd) + charDepth(g, hd)
		if u > w {
			f = g; c = y; w = u
			if u >= v {
				goto found
			}
		}
		if charTag(q) == listTag {
			y = remByte(q); goto again
		}
	}
}

@ 다음 서브루틴은 문자 하나만 담은 새 상자를 만드는데, 그 너비에는 그 문자의 기울임 보정까지 들어간다. 문자의 높이나 깊이가
음수이면 상자의 높이나 깊이도 음수가 된다. 그래서 이 루틴의 결과는 |hpack|이 내놓을 결과와 조금 다를 수도 있다.

@<|varDelimiter|의 하위...@>=
func charBox(f internalFontNumber, c quarterword) pointer {
	q := charInfo(f, c); hd := heightDepth(q) // |heightDepth| 바이트
	b := newNullBox() // 새 상자
	setWidth(b, charWidth(f, q)+charItalic(f, q))
	setHeight(b, charHeight(f, hd)); setDepth(b, charDepth(f, hd))
	p := getAvail(); setCharacter(p, c); setFontField(p, f); setListPtr(b, p) // 그 문자 노드
	return b
}

@ 다음 코드가 실행될 때, 조립한 기호를 돌려주어야 하는 경우에, 그리고 오직 그때에만 |charTag(q)|가 |extTag|다.

@<변수 |b|가 |(f,c)|를 담은 상자를...@>=
if charTag(q) == extTag {
	@<조립법 |remByte(q)|와 글꼴 |f|로 새 상자 |b|에 늘일 수 있는 문자를 만든다@>
} else {
	b = charBox(f, c)
}

@ 늘일 수 있는 문자를 만들 때는 다음 서브루틴이 있으면 편하다. 주어진 문자를 상자 |b|에 이미 있는 문자들 위에 얹는다. 아래
조각부터 쌓아 올리므로 상자의 높이는 늘 맨 위 조각의 높이다.

@<|varDelimiter|의 하위...@>=
func stackIntoBox(b pointer, f internalFontNumber, c quarterword) {
	p := charBox(f, c) // |b|에 넣을 새 노드
	setLink(p, listPtr(b)); setListPtr(b, p)
	setHeight(b, height(p))
}

@ 또 하나의 편리한 서브루틴은 주어진 문자의 높이와 깊이의 합을 계산한다.

@<|varDelimiter|의 하위...@>=
func heightPlusDepth(f internalFontNumber, c quarterword) scaled {
	q := charInfo(f, c); hd := heightDepth(q) // |heightDepth| 바이트
	return charHeight(f, hd) + charDepth(f, hd)
}

@ 늘일 수 있는 문자를 조립한다. 필요한 높이에 이를 만큼의 반복 조각 수를 먼저 정하고, 아래 조각, 반복 조각들, 가운데 조각,
반복 조각들, 위 조각의 차례로 쌓는다.
@<조립법 |remByte(q)|와 글꼴 |f|로...@>=
b = newNullBox()
setType(b, vlistNode)
r = fontInfo[extenBase[f]+remByte(q)].qqqq
@<알맞은 최소 높이 |w|와 확장 단계 수 |n|을 계산하고 |width(b)|도 정한다@>
c = extBot(r)
if c != minQuarterword {
	stackIntoBox(b, f, c)
}
c = extRep(r)
for m = 1; m <= n; m++ {
	stackIntoBox(b, f, c)
}
c = extMid(r)
if c != minQuarterword {
	stackIntoBox(b, f, c); c = extRep(r)
	for m = 1; m <= n; m++ {
		stackIntoBox(b, f, c)
	}
}
c = extTop(r)
if c != minQuarterword {
	stackIntoBox(b, f, c)
}
setDepth(b, w-height(b))

@ 늘일 수 있는 문자의 너비는 반복 조각의 너비다. 이 조각의 높이와 깊이의 합이 양수가 아니면 반복 조각을 하나도 쓰지 않는다.
그렇지 않으면 높이가 |v| 이상이 될 때까지 될 수 있는 대로 적게 쓴다(가운데 조각이 있으면 위아래가 대칭이 되도록 둘씩 묶어서
쓴다).

@<알맞은 최소 높이 |w|와...@>=
c = extRep(r); u = heightPlusDepth(f, c)
w = 0; q = charInfo(f, c); setWidth(b, charWidth(f, q)+charItalic(f, q))
c = extBot(r); if c != minQuarterword { w = w + heightPlusDepth(f, c) }
c = extMid(r); if c != minQuarterword { w = w + heightPlusDepth(f, c) }
c = extTop(r); if c != minQuarterword { w = w + heightPlusDepth(f, c) }
n = 0
if u > 0 {
	for w < v {
		w += u; n++
		if extMid(r) != minQuarterword {
			w += u
		}
	}
}

@ 다음 서브루틴은 훨씬 간단하다. 분수의 분자와 분모, 그리고 따로 세운 연산자와 그 위아래의 극한에 쓴다. 주어진 상자~|b|를
받아서 너비~|w|인 상자의 가운데에 놓이도록 바꾼다. 가운데 맞춤은 |b| 안의 목록 왼쪽과 오른쪽에 \.{\\hss} 글루를 넣고 새 상자로
묶어서 한다. 그러니 그 상자가 이미 무한 글루를 담고 있으면 실제로는 가운데에 놓이지 않을 수도 있다.

주어진 상자에 문자 하나만 들어 있고 그 문자의 기울임 보정이 상자 너비에 더해져 있을 수도 있다. 그때는 그것을 상쇄하는 커닝을
끼워 넣는다.

@<함수들@>=
func rebox(b pointer, w scaled) pointer {
	var p pointer // 목록을 다루는 임시 레지스터
	var f internalFontNumber // 문자 하나짜리 상자의 글꼴
	var v scaled // 기울임 보정을 뺀 문자의 너비
	if width(b) != w && listPtr(b) != null {
		if typ(b) == vlistNode {
			b = hpack(b, natural, additional)
		}
		p = listPtr(b)
		if isCharNode(p) && link(p) == null {
			f = font(p); v = charWidth(f, charInfo(f, character(p)))
			if v != width(b) {
				setLink(p, newKern(width(b)-v))
			}
		}
		freeNode(b, boxNodeSize)
		b = newGlue(ssGlue); setLink(b, p)
		for link(p) != null {
			p = link(p)
		}
		setLink(p, newGlue(ssGlue))
		return hpack(b, w, exactly)
	}
	setWidth(b, w); return b
}

@ 다음은 `\.{mu}'로 나타낸 글루 명세와 수식 단위의 크기 |m|이 주어졌을 때, 실제 크기의 새 글루 명세를 만드는 서브루틴이다.
글루의 성분마다 |m|을 곱한다. 무한 차수의 늘어남과 줄어듦은 곱하지 않는다.

곱셈을 하는 작은 함수 |muMult|는 두 함수에서 쓰므로, 부르는 쪽의 지역 변수 |n|과 |f|를 인자로 받는다.

@<함수들@>=
func muMult(n int32, f scaled, x scaled) scaled { return nxPlusY(n, x, xnOverD(x, f, 0o200000)) }

func mathGlue(g pointer, m scaled) pointer {
	n := xOverN(m, 0o200000) // |m|의 정수 부분
	f := remainder // |m|의 소수 부분
	if f < 0 {
		n--; f += 0o200000
	}
	p := getNode(glueSpecSize) // 새 글루 명세
	setWidth(p, muMult(n, f, width(g))) // \.{mu}를 \.{pt}로 바꾼다
	setStretchOrder(p, stretchOrder(g))
	if stretchOrder(p) == normal {
		setStretch(p, muMult(n, f, stretch(g)))
	} else {
		setStretch(p, stretch(g))
	}
	setShrinkOrder(p, shrinkOrder(g))
	if shrinkOrder(p) == normal {
		setShrink(p, muMult(n, f, shrink(g)))
	} else {
		setShrink(p, shrink(g))
	}
	return p
}

@ 서브루틴 |mathKern|은 수식 단위의 크기가 주어지면 커닝 노드의 \.{mu} 단위를 실제 크기로 바꾼다. 바꾼 커닝은 \.{\\kern}으로
넣은 것과 같은 |explicit| 커닝이 된다.

@<함수들@>=
func mathKern(p pointer, m scaled) {
	var n int32 // |m|의 정수 부분
	var f scaled // |m|의 소수 부분
	if subtype(p) == muGlue {
		n = xOverN(m, 0o200000); f = remainder
		if f < 0 {
			n--; f += 0o200000
		}
		setWidth(p, muMult(n, f, width(p))); setSubtype(p, explicit)
	}
}

@ 때로는 수식 목록을 통째로 버려야 한다. 다음 서브루틴은 |abs(mode)=mmode|라고 가정하고 현재 목록과 만들다 만 분수를 비운다.

@<함수들@>=
func flushMath() {
	flushNodeList(link(head)); flushNodeList(incompleatNoad())
	setLink(head, null); tail = head; setIncompleatNoad(null)
}

@* 수식 조판.
수식을 다루는 \TeX의 루틴 가운데 가장 중요한 것은 |mlistToHlist|다. 수식을 읽어 수식 목록으로 나타내고 나면, 이 루틴이 그것을
상자에 넣거나 문단 텍스트에 끼울 수 있는 가로 목록으로 바꾼다. 전역 변수로 넘기는 숨은 매개변수가 셋 있다. 첫째 |curMlist|는 주어진
수식 목록의 첫 노드(node)나 노드(noad)를 가리키고(|null|일 수도 있다), |curStyle|은 모양 코드이며, |mlistPenalties|는 결과 가로
목록에 줄 나누기 후보가 될 벌점 노드를 넣어야 하면 |true|다. 본문 속 수식에는 벌점을 넣고, 상자 안의 수식이나 따로 세운 수식에는
넣지 않는다. 이 루틴이 일을 마치면 |link(tempHead)|가 번역한 가로 목록을 가리킨다.

수식 목록 안에 수식 목록이 있을 수 있으므로 이 프로시저는 재귀적이다. 그리고 \TeX의 안쪽 루프에 속하지 않으므로, 효율보다는
간결함에 무게를 두어 짰다.
@^recursion@>

@<전역 변수@>=
var @!curMlist pointer // 번역할 수식 목록의 시작
var @!curStyle smallNumber // 목록의 현재 자리의 모양 코드
var @!curSize smallNumber // |curStyle|에 대응하는 크기 코드
var @!curMu scaled // |curSize|에 대응하는 수식 단위 너비
var @!mlistPenalties bool // |mlistToHlist|가 벌점을 넣어야 하는가?

@ 프로시저 |mlistToHlist|의 재귀는 주로 |cleanBox|라는 서브루틴에서 일어난다. 이 서브루틴은 주어진 노드 필드를 주어진 수식
모양으로 조판해 상자에 넣는다. 곧 |mlistToHlist|는 |cleanBox|를 부를 수 있고, |cleanBox|는 다시 |mlistToHlist|를 부를 수 있다.
@^recursion@>

서브루틴 |cleanBox|가 돌려주는 상자는 |shiftAmount|가 0이라는 뜻에서 ``깨끗하다''. 필드가 이미 옮겨 둔 상자이면 그것을 다시
꾸려서 깨끗한 상자로 만든다.


@<함수들@>=
func cleanBox(p pointer, s smallNumber) pointer {
	var q pointer // 상자에 넣을 목록의 시작
	var saveStyle smallNumber // 되돌릴 |curStyle|
	var x pointer // 돌려줄 상자
	var r pointer // 임시 포인터
	switch mathType(p) {
	case mathChar: curMlist = newNoad(); mem[nucleus(curMlist)] = mem[p]
	case subBox: q = info(p); goto found
	case subMlist: curMlist = info(p)
	default: q = newNullBox(); goto found
	}
	saveStyle = curStyle; curStyle = s; mlistPenalties = false
	mlistToHlist(); q = link(tempHead) // 재귀 호출
	curStyle = saveStyle // 모양을 되돌린다
	@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
found:
	if isCharNode(q) || q == null {
		x = hpack(q, natural, additional)
	} else if link(q) == null && typ(q) <= vlistNode && shiftAmount(q) == 0 {
		x = q // 이미 깨끗하다
	} else {
		x = hpack(q, natural, additional)
	}
	@<자명한 상자를 단순하게 한다@>
	return x
}

@ 흔한 경우에 메모리를 아낀다. 상자에 문자 하나와 기울임 보정 커닝 하나만 들어 있으면 그 커닝은 필요 없으므로 지운다.

@<자명한 상자를...@>=
q = listPtr(x)
if isCharNode(q) {
	r = link(q)
	if r != null && link(r) == null && !isCharNode(r) && typ(r) == kernNode {
		// 필요 없는 기울임 보정
		freeNode(r, smallNodeSize); setLink(q, null)
	}
}

@ 형이 |mathChar|인 필드를 ``풀어 놓은'' 꼴로 바꾸는 프로시저가 있으면 편하다. 루틴 |fetch|는 주어진 노드 필드의 글꼴 코드,
문자 코드, 문자 정보 낱말을 |curF|, |curC|, |curI|에 넣는다. 글꼴은 그 필드의 가족과 현재 크기로 정한다. 또 없는 문자를 쓰면
오류 메시지를 낸다. 그런 경우 |fetch|가 일을 마치면 |charExists(curI)|가 |false|이고, 그 필드도 |empty|로 바뀌어 있다.

@<함수들@>=
func fetch(a pointer) { // |mathChar| 필드 |a|를 푼다
	curC = character(a); curF = famFnt(fam(a) + curSize)
	if curF == nullFont {
		@<정의되지 않은 가족에 대해 불평하고 |curI|를 널로 한다@>
	} else {
		if qo(curC) >= fontBc[curF] && qo(curC) <= fontEc[curF] {
			curI = charInfo(curF, curC)
		} else {
			curI = nullCharacter
		}
		if !charExists(curI) {
			charWarning(curF, qo(curC))
			setMathType(a, empty); curI = nullCharacter
		}
	}
}

@ 가족에 글꼴이 정해지지 않았으면 `\.{! \\textfont 1 is undefined (character a)}' 같은 오류를 낸다.
@<정의되지 않은 가족에 대해...@>=
printErr(""); printSize(curSize); printChar(' ')
printInt(fam(a)); printStr(" is undefined (character ")
printASCII(qo(curC)); printChar(')')
help4("Somewhere in the math formula just ended, you used the",
	"stated character from an undefined font family. For example,",
	"plain TeX doesn't allow \\it or \\sl in subscripts. Proceed,",
	"and I'll try to forget that I needed that character.")
reportError(); curI = nullCharacter; setMathType(a, empty)

@ 루틴 |fetch|의 결과는 전역 변수에 놓인다.

@<전역 변수@>=
var @!curF internalFontNumber // |mathChar|의 |font| 필드
var @!curC quarterword // |mathChar|의 |character| 필드
var @!curI fourQuarters // |mathChar|의 |charInfo|, 또는 합자/커닝 명령

@ 할 일이 많고 갖가지이므로, |mlistToHlist|는 주어진 수식 목록을 두 번 훑는다.

첫째 훑기가 처리의 대부분을 한다. 글루의 ``mu'' 단위를 실제 크기로 바꾸고, 모든 하위 수식 목록을 재귀로 계산해서 맨 위 수준의
수식 목록만 다루면 되게 하고, 분수와 제곱근 따위를 상자에 넣고, 아래첨자와 위첨자를 붙이고, 맨 위 수준 수식 목록의 전체 높이와
깊이를 계산해서 |leftNoad|와 |rightNoad|의 구분자 크기를 정할 수 있게 한다. 노드(noad)마다 그 번역인 가로 목록은 그 노드의
|newHlist| 필드에 적어 둔다. 이 필드는 |nucleus|나 |thickness| 자리를 대신 쓰는 정수 필드다.
@^recursion@>

둘째 훑기는 노드(noad)를 모두 없애고, 노드(node)들 사이에 알맞은 글루와 벌점을 끼워 넣는다. 원소 사이의 간격은 이웃한 두
원소의 종류를 보아야 정할 수 있으므로, 첫째 훑기에서 종류를 모두 확정한 뒤에야 할 수 있다.

@<정의@>=
func newHlist(p pointer) int32 { return mem[nucleus(p)].sc } // 수식 목록의 번역
func setNewHlist(p pointer, v int32) { mem[nucleus(p)].sc = v }

@ 다음은 |mlistToHlist|의 전체 계획과 그 지역 변수들이다.

여기에 나오는 레이블은 넷이다. 노드(noad)를 다 번역하면 |doneWithNoad|로, 노드(node)를 다 바꾸면 |doneWithNode|로, |maxH|와
|maxD|를 고치려면 |checkDimensions|로, |q|를 지우고 다음 노드로 가려면 |deleteQ|로 간다.

@<함수들@>=
@<수식 구성 프로시저들@>@;
func mlistToHlist() {
	var mlist pointer // 주어진 목록의 시작
	var penalties bool // 벌점 노드를 넣어야 하는가?
	var style smallNumber // 주어진 모양
	var saveStyle smallNumber // 재귀하는 동안 |curStyle|을 담아 둔다
	var q pointer // 수식 목록을 훑는다
	var r pointer // |q| 앞의 가장 최근 노드
	var rType smallNumber // 노드 |r|의 \ID{type}, |r=null|이면 |opNoad|
	var t smallNumber // 둘째 훑기에서 노드 |q|의 실질적인 \ID{type}
	var p, x, y, z pointer // 목록을 만드는 임시 레지스터들
	var pen int32 // 넣을 벌점
	var s smallNumber // 지울 노드의 크기
	var maxH, maxD scaled // 지금까지 번역한 목록의 최대 높이와 깊이
	var delta scaled // 아래첨자와 위첨자 사이의 어긋남
	mlist = curMlist; penalties = mlistPenalties
	style = curStyle // 전역 매개변수를 지역 변수로 챙겨 둔다
	q = mlist; r = null; rType = opNoad; maxH = 0; maxD = 0
	@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
	for q != null {
		@<노드 |q|를 첫째 훑기에서 할 수 있는 만큼 처리하고 다음으로 간다@>
	}
	@<마지막 |binNoad|를 |ordNoad|로 바꾼다@>
	@<수식 목록을 다시 훑어 노드를 없애고 간격과 벌점을 넣는다@>
}

@ 첫째 훑기에서 노드 하나를 처리한다. 수식 목록에는 문자 노드가 나오지 않는다는 사실을 써먹는다. 그래서 필드 |typ(q)|는 언제나
있다. 번역이 끝나면 그 가로 목록의 높이와 깊이로 |maxH|와 |maxD|를 고친다.

@<노드 |q|를 첫째 훑기에서...@>=
@<|typ(q)|에 따라 첫째 훑기 처리를 한다@>
checkDimensions:
	z = hpack(newHlist(q), natural, additional)
	if height(z) > maxH {
		maxH = height(z)
	}
	if depth(z) > maxD {
		maxD = depth(z)
	}
	freeNode(z, boxNodeSize)
doneWithNoad:
	r = q; rType = typ(r)
doneWithNode:
	q = link(q)

@ 첫째 훑기에서 할 일 가운데 하나는, 이항 연산자로 쓰일 수 없는 자리의 |binNoad|를 |ordNoad|로 바꾸는 것이다. 이를테면 `$-x$'의
빼기 기호나 `$(-1)$'의 빼기 기호는 앞에 피연산자가 없으므로 보통 기호가 된다. 변수 |r|과 |rType|에 바로 앞 노드가 있으므로 이
일이 꽤 쉽다.

이 절은 노드(noad)를 다 처리했으면 레이블 |doneWithNoad|로, 번역을 |newHlist(q)|에 넣었으면 |checkDimensions|로, 노드(node)를 다
처리했으면 |doneWithNode|로 간다.

@<|typ(q)|에 따라 첫째 훑기...@>=
reswitch:
	delta = 0
	switch typ(q) {
	case binNoad:
		switch rType {
		case binNoad, opNoad, relNoad, openNoad, punctNoad, leftNoad:
			setType(q, ordNoad); goto reswitch
		}
	case relNoad, closeNoad, punctNoad, rightNoad:
		@<마지막 |binNoad|를 |ordNoad|로 바꾼다@>
		if typ(q) == rightNoad {
			goto doneWithNoad
		}
	@<|binNoad| 뒤에 올 수 있는 노드의 경우들@>
	@<수식 목록에 나타날 수 있는 노드(node)의 경우들@>
	default: confusion("mlist1")
@:this can't happen mlist1}{\quad mlist1@>
	}
	@<|nucleus(q)|를 가로 목록으로 바꾸고 첨자를 붙인다@>

@ 관계 기호나 닫는 괄호나 문장 부호 앞의 |binNoad|도 이항 연산자가 될 수 없다. 뒤에 피연산자가 없기 때문이다.
@<마지막 |binNoad|를...@>=
if rType == binNoad {
	setType(r, ordNoad)
}

@ 수식 목록에 나오는 노드(node)들이다. 모양 노드는 현재 모양을 바꾸고, 선택 노드는 알맞은 선택으로 바꾼다. 괘선과 글루와 커닝은
그대로 두되 치수를 반영하거나 mu 단위를 바꾼다. 이 경우들은 처리를 마치면 |goto doneWithNode|한다.

@<수식 목록에 나타날 수 있는 노드(node)의 경우들@>=
case styleNode:
	curStyle = subtype(q)
	@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
	goto doneWithNode
case choiceNode: @<이 노드를 모양 노드와 알맞은 선택으로 바꾼다@>
case insNode, markNode, adjustNode, whatsitNode, penaltyNode, discNode:
	goto doneWithNode
case ruleNode:
	if height(q) > maxH {
		maxH = height(q)
	}
	if depth(q) > maxD {
		maxD = depth(q)
	}
	goto doneWithNode
case glueNode:
	@<수식 글루를 보통 글루로 바꾼다@>
	goto doneWithNode
case kernNode: mathKern(q, curMu); goto doneWithNode

@ 선택 노드를 모양 노드로 바꾸고, 현재 모양에 맞는 선택을 그 뒤에 이은 다음 |goto doneWithNode|한다. 나머지 세 선택은 버린다.

선택 노드의 네 목록 가운데 고른 것은 |p|로 꺼내고, 그 필드는 |null|로 놓는다.

@<이 노드를 모양 노드와...@>=
switch curStyle / 2 {
case 0: p = displayMlist(q); setDisplayMlist(q, null) // |displayStyle=0|
case 1: p = textMlist(q); setTextMlist(q, null) // |textStyle=2|
case 2: p = scriptMlist(q); setScriptMlist(q, null) // |scriptStyle=4|
case 3: p = scriptScriptMlist(q); setScriptScriptMlist(q, null) // |scriptScriptStyle=6|
} // 다른 경우는 없다
flushNodeList(displayMlist(q))
flushNodeList(textMlist(q))
flushNodeList(scriptMlist(q))
flushNodeList(scriptScriptMlist(q))
setType(q, styleNode); setSubtype(q, curStyle); setWidth(q, 0); setDepth(q, 0)
if p != null {
	z = link(q); setLink(q, p)
	for link(p) != null {
		p = link(p)
	}
	setLink(p, z)
}
goto doneWithNode

@ 조건부 수식 글루(`\.{\\nonscript}')는 |zeroGlue|를 가리키고 |subtype(q)=condMathGlue|인 |glueNode|가 된다. 현재 크기가 |textSize|가
아니면, 곧 첨자 크기이면, 뒤따르는 노드가 글루나 커닝일 때 그것을 없앤다. 조건 없는 수식 글루(`\.{\\mskip}')는 치수에 |curMu|를
곱해서 보통 글루로 바꾼다.
@!@:non_script_}{\.{\\nonscript} primitive@>

@<수식 글루를 보통 글루로...@>=
if subtype(q) == muGlue {
	x = gluePtr(q)
	y = mathGlue(x, curMu); deleteGlueRef(x); setGluePtr(q, y)
	setSubtype(q, normal)
} else if curSize != textSize && subtype(q) == condMathGlue {
	p = link(q)
	if p != null && (typ(p) == glueNode || typ(p) == kernNode) {
		setLink(q, link(p)); setLink(p, null); flushNodeList(p)
	}
}

@ 노드의 종류에 따라 조립 프로시저를 부른다. 분수는 번역을 곧바로 |newHlist|에 넣는다. 극한을 위아래에 단 연산자도 그렇다.
@<|binNoad| 뒤에 올 수 있는 노드의 경우들@>=
case leftNoad: goto doneWithNoad
case fractionNoad: makeFraction(q); goto checkDimensions
case opNoad:
	delta = makeOp(q)
	if subtype(q) == limits {
		goto checkDimensions
	}
case ordNoad: makeOrd(q)
case openNoad, innerNoad: // 아무것도 하지 않는다
case radicalNoad: makeRadical(q)
case overNoad: makeOver(q)
case underNoad: makeUnder(q)
case accentNoad: makeMathAccent(q)
case vcenterNoad: makeVcenter(q)

@ 프로시저 |mlistToHlist|의 실제 조립 작업은 대부분 |makeFraction|, |makeRadical| 따위의 이름을 가진 프로시저들이 한다. 그런
프로시저들의 일반적인 짜임새를 보여 주려고 간단한 것 두어 개부터 시작하자. 프로시저 |makeOver|는 핵을 조인 모양으로 조판하고, 그 위에
괘선 두께의 세 배만큼 띄워 윗줄을 긋는다.

@<수식 구성 프로시저들@>=
func makeOver(q pointer) {
	setInfo(nucleus(q),
		overbar(cleanBox(nucleus(q), crampedStyle(curStyle)),
			3*defaultRuleThickness(), defaultRuleThickness()))
	setMathType(nucleus(q), subBox)
}

@ 밑줄은 핵 아래로 괘선 두께의 세 배만큼 띄워 긋는다. 상자의 높이는 핵의 높이 그대로이고, 밑줄은 깊이에 들어간다.
@<수식 구성 프로시저들@>=
func makeUnder(q pointer) {
	x := cleanBox(nucleus(q), curStyle) // 상자를 만드는 임시 레지스터들
	p := newKern(3 * defaultRuleThickness()); setLink(x, p)
	setLink(p, fractionRule(defaultRuleThickness()))
	y := vpack(x, natural, additional)
	delta := height(y) + depth(y) + defaultRuleThickness() // 전체 높이와 깊이의 합
	setHeight(y, height(x)); setDepth(y, delta-height(y))
	setInfo(nucleus(q), y); setMathType(nucleus(q), subBox)
}

@ 명령 \.{\\vcenter}는 세로 상자를 수식의 축에 맞추어 가운데에 놓는다. 높이와 깊이의 합은 그대로 두고, 높이를 축의 높이에 그 합의
절반을 더한 값으로 바꾼다.
@<수식 구성 프로시저들@>=
func makeVcenter(q pointer) {
	v := info(nucleus(q)) // 세로로 가운데 맞출 상자
	if typ(v) != vlistNode {
		confusion("vcenter")
	}
@:this can't happen vcenter}{\quad vcenter@>
	delta := height(v) + depth(v) // 그 높이와 깊이의 합
	setHeight(v, axisHeight(curSize)+half(delta))
	setDepth(v, delta-height(v))
}

@ \.{DVI} 파일 명세의 규칙에 따라, 근호 기호의 기준선이 괘선의 아래 끝과 같다고 보고 근호 기호와 핵 위의 괘선을 가지런히
@^square roots@>
맞춘다. 근호 기호의 높이는 괘선의 두께가 되고, 깊이는 핵의 높이와 깊이의 합에 어떤 최소 틈~|clr|을 더한 값 이상이어야 한다.
그런 기호를 |varDelimiter|로 고른 다음, 실제 틈이 |clr|에 남는 양의 절반을 더한 것이 되도록 놓는다. 그래서 근호가 핵보다 많이
크면 핵이 근호 안의 가운데쯤에 놓인다.

@<수식 구성 프로시저들@>=
func makeRadical(q pointer) {
	var clr scaled // 계산에 쓰는 치수들
	x := cleanBox(nucleus(q), crampedStyle(curStyle)) // 상자를 만드는 임시 레지스터들
	if curStyle < textStyle { // 따로 세운 모양
		clr = defaultRuleThickness() + (abs(mathXHeight(curSize)) / 4)
	} else {
		clr = defaultRuleThickness(); clr += (abs(clr) / 4)
	}
	y := varDelimiter(leftDelimiter(q), curSize, height(x)+depth(x)+clr+
		defaultRuleThickness())
	delta := depth(y) - (height(x) + depth(x) + clr)
	if delta > 0 {
		clr += half(delta) // 실제 틈을 늘린다
	}
	setShiftAmount(y, -(height(x) + clr))
	setLink(y, overbar(x, clr, height(y)))
	setInfo(nucleus(q), hpack(y, natural, additional)); setMathType(nucleus(q), subBox)
}

@ 수식 모드에서 악센트를 놓을 때는 기울기를 따로 고려하지 않는다. 악센트는 받는 것 위의 가운데에 놓이고, 악센트의 너비는
마지막 상자의 크기에 아무 영향도 주지 않는다.

@<수식 구성 프로시저들@>=
func makeMathAccent(q pointer) {
	var p, x, y pointer // 상자를 만드는 임시 레지스터들
	var a int32 // 합자/커닝 명령의 주소
	var c quarterword // 악센트 문자
	var f internalFontNumber // 그 글꼴
	var i fourQuarters // 그 |charInfo|
	var s scaled // 악센트를 오른쪽으로 비낄 양
	var h scaled // 악센트를 받는 문자의 높이
	var delta scaled // 악센트와 악센트를 받는 것 사이에서 뺄 공간
	var w scaled // 첨자를 뺀, 악센트를 받는 것의 너비
	fetch(accentChr(q))
	if charExists(curI) {
		i = curI; c = curC; f = curF
		@<비낌의 양을 계산한다@>
		x = cleanBox(nucleus(q), crampedStyle(curStyle)); w = width(x); h = height(x)
		@<알맞으면 더 큰 악센트로 바꾼다@>
		if h < xHeight(f) { delta = h } else { delta = xHeight(f) }
		if mathType(supscr(q)) != empty || mathType(subscr(q)) != empty {
			if mathType(nucleus(q)) == mathChar {
				@<아래첨자와 위첨자를 상자 |x|로 옮긴다@>
			}
		}
		y = charBox(f, c)
		setShiftAmount(y, s+half(w-width(y)))
		setWidth(y, 0); p = newKern(-delta); setLink(p, x); setLink(y, p)
		y = vpack(y, natural, additional); setWidth(y, width(x))
		if height(y) < h {
			@<상자 |y|의 높이를 |h|와 같게 한다@>
		}
		setInfo(nucleus(q), y)
		setMathType(nucleus(q), subBox)
	}
}

@ 악센트를 받는 문자의 높이 |h|가 상자 |y|의 높이보다 크면, 그 차이만큼 커닝을 넣어 상자의 높이를 |h|로 맞춘다.
@<상자 |y|의 높이를...@>=
p = newKern(h - height(y)); setLink(p, listPtr(y)); setListPtr(y, p)
setHeight(y, h)

@ 악센트 문자에 더 넓은 변형이 있으면, 악센트를 받는 것의 너비 |w|를 넘지 않는 한 더 넓은 것으로 바꾼다. 명령 \.{\\widehat}이
넓은 핵 위에서 넓어지는 것이 이 덕분이다.
@<알맞으면 더 큰 악센트로...@>=
for {
	if charTag(i) != listTag {
		goto done
	}
	y = remByte(i)
	i = charInfo(f, y)
	if !charExists(i) {
		goto done
	}
	if charWidth(f, i) > w {
		goto done
	}
	c = y
}
done:

@ 악센트를 오른쪽으로 비낄 양 |s|를 정한다. 핵이 문자 하나이면 그 문자와 비뚤림 문자 \.{\\skewchar} 사이의 커닝을 찾아 그
값을 쓴다. 기울어진 글자 위의 악센트가 글자 모양에 맞게 오른쪽으로 옮겨지는 것이 이 덕분이다.
@<비낌의 양을...@>=
s = 0
if mathType(nucleus(q)) == mathChar {
	fetch(nucleus(q))
	if charTag(curI) == ligTag {
		a = ligKernStart(curF, curI)
		curI = fontInfo[a].qqqq
		if skipByte(curI) > stopFlag {
			a = ligKernRestart(curF, curI)
			curI = fontInfo[a].qqqq
		}
		for {
			if qo(nextChar(curI)) == skewChar[curF] {
				if opByte(curI) >= kernFlag && skipByte(curI) <= stopFlag {
					s = charKern(curF, curI)
				}
				goto done1
			}
			if skipByte(curI) >= stopFlag {
				goto done1
			}
			a = a + qo(skipByte(curI)) + 1
			curI = fontInfo[a].qqqq
		}
	}
}
done1:

@ 핵이 문자 하나이고 첨자가 있으면, 악센트를 핵에만 붙여야 한다. 그래서 핵과 첨자를 새 노드 |x|로 옮기고, 원래 노드의 핵은 그
노드를 담은 수식 목록으로 바꾼다. 그러면 악센트 뒤에 첨자가 붙는다.
@<아래첨자와 위첨자를 상자 |x|로...@>=
flushNodeList(x); x = newNoad()
mem[nucleus(x)] = mem[nucleus(q)]
mem[supscr(x)] = mem[supscr(q)]
mem[subscr(x)] = mem[subscr(q)]
mem[supscr(q)].hh = emptyField
mem[subscr(q)].hh = emptyField
setMathType(nucleus(q), subMlist); setInfo(nucleus(q), x)
x = cleanBox(nucleus(q), curStyle); delta = delta + height(x) - h; h = height(x)

@ 프로시저 |makeFraction|은 조금 다르다. 하위 상자를 만드는 대신 |newHlist(q)|를 곧바로 정하기 때문이다. 분자와 분모를 상자에
넣고, 괘선이 있는지에 따라 위아래로 옮길 양을 정한 다음, 세로 상자로 쌓고 양옆에 구분자를 붙인다.

@<수식 구성 프로시저들@>=
func makeFraction(q pointer) {
	var p, y pointer // 상자를 만드는 임시 레지스터들
	var delta, delta1, delta2, shiftUp, shiftDown, clr scaled // 상자 계산에 쓰는 치수들
	if thickness(q) == defaultCode {
		setThickness(q, defaultRuleThickness())
	}
	@<분자와 분모를 너비가 같은 상자 |x|와 |z|에 넣는다@>
	if thickness(q) == 0 {
		@<분수 괘선이 없을 때 |shiftUp|과 |shiftDown|을 맞춘다@>
	} else {
		@<분수 괘선이 있을 때 |shiftUp|과 |shiftDown|을 맞춘다@>
	}
	@<|shiftUp|과 |shiftDown|에 따라 분수의 세로 목록 상자를 만든다@>
	@<분수를 구분자와 함께 상자에 넣고 |newHlist(q)|가 가리키게 한다@>
}

@ 분자와 분모를 너비가 같은 상자 |x|와 |z|에 넣고, 기준선에서 이들을 옮길 기본 양 |shiftUp|과 |shiftDown|을 글꼴 매개변수로
정한다.

@<분자와 분모를 너비가...@>=
x := cleanBox(numerator(q), numStyle(curStyle))
z := cleanBox(denominator(q), denomStyle(curStyle))
if width(x) < width(z) {
	x = rebox(x, width(z))
} else {
	z = rebox(z, width(x))
}
if curStyle < textStyle { // 따로 세운 모양
	shiftUp = num1(curSize); shiftDown = denom1(curSize)
} else {
	shiftDown = denom2(curSize)
	if thickness(q) != 0 {
		shiftUp = num2(curSize)
	} else {
		shiftUp = num3(curSize)
	}
}

@ 분수 괘선이 없을 때(\.{\\atop}) 분자와 분모는 어떤 최소 틈만큼 떨어져 있어야 한다. 다음 프로그램에서 이것을 |clr|이라고 부른다.
틈이 모자라면 그 차이의 절반 |delta|만큼 분자를 올리고 분모를 내린다.

@<분수 괘선이 없을 때...@>=
if curStyle < textStyle {
	clr = 7 * defaultRuleThickness()
} else {
	clr = 3 * defaultRuleThickness()
}
delta = half(clr - ((shiftUp - depth(x)) - (height(z) - shiftDown)))
if delta > 0 {
	shiftUp += delta
	shiftDown += delta
}

@ 분수 괘선이 있을 때 최소 틈은 괘선의 실제 두께에 따라 달라진다.

그림으로 보면 이렇다. 분수 괘선은 수식의 축, 곧 기준선에서 |axisHeight|만큼 위의 수평선에 가운데를 맞춘다. 분자는 그 기준선이
수식의 기준선보다 |shiftUp|만큼 위에 오도록 올리고, 분모는 |shiftDown|만큼 내린다. 이 두 양은 처음에 글꼴 매개변수 |num1|, |num2|,
|denom1|, |denom2| 따위로 정하지만, 분자의 아래 끝과 괘선 사이, 그리고 괘선과 분모의 위 끝 사이가 적어도 |clr|이 되지 않으면
모자라는 만큼(|delta1|과 |delta2|) 더 벌린다. 분자와 분모를 따로 벌리므로 분수는 축에 대해 대칭이 아닐 수도 있다.
$$\mplibcode
beginfig(10);
save k, w, a, t, u, hx, dx, v, hz, dz; numeric k, w, a, t, u, hx, dx, v, hz, dz;
k := 2.5pt; w := 120pt; a := 8k; t := 2k;
u := 26k; hx := 12k; dx := 6k; v := 16k; hz := 10k; dz := 4k;
fill (0,u-dx)--(w,u-dx)--(w,u+hx)--(0,u+hx)--cycle withcolor .88white;
draw (0,u-dx)--(w,u-dx)--(w,u+hx)--(0,u+hx)--cycle;
fill (0,-v-dz)--(w,-v-dz)--(w,-v+hz)--(0,-v+hz)--cycle withcolor .88white;
draw (0,-v-dz)--(w,-v-dz)--(w,-v+hz)--(0,-v+hz)--cycle;
draw (0,u)--(w,u) dashed withdots scaled .5; draw (0,-v)--(w,-v) dashed withdots scaled .5;
label(btex \ninepoint 분자 etex, (w/2, u+hx/2)); label(btex \ninepoint 분모 etex, (w/2, -v+hz/2-2pt));
fill (0,a-t/2)--(w,a-t/2)--(w,a+t/2)--(0,a+t/2)--cycle;
label.rt(btex \eightpoint 분수 괘선 etex, (w+56pt,a));
draw (w+4pt,a)--(w+54pt,a) withpen pencircle scaled .2pt;
draw (-90pt,0)--(w+4pt,0) dashed evenly; label.lft(btex \ninepoint 기준선 etex, (-90pt,0));
draw (-90pt,a)--(0,a) dashed evenly;
label.lft(btex \ninepoint 축(기준선에서 \ID{axisHeight}만큼 위) etex, (-90pt,a));
drawdblarrow (-12pt,0)--(-12pt,u); label.lft(btex \eightpoint \ID{shiftUp} etex, (-12pt,(a+u)/2+4pt));
drawdblarrow (-12pt,0)--(-12pt,-v); label.lft(btex \eightpoint \ID{shiftDown} etex, (-12pt,-v/2));
drawdblarrow (w+10pt,a+t/2)--(w+10pt,u-dx); label.rt(btex \eightpoint ${}\ge\ID{clr}$ etex, (w+10pt,(a+t/2+u-dx)/2));
drawdblarrow (w+10pt,-v+hz)--(w+10pt,a-t/2); label.rt(btex \eightpoint ${}\ge\ID{clr}$ etex, (w+10pt,(a-t/2-v+hz)/2));
endfig;
\endmplibcode$$

@<분수 괘선이 있을 때...@>=
if curStyle < textStyle {
	clr = 3 * thickness(q)
} else {
	clr = thickness(q)
}
delta = half(thickness(q))
delta1 = clr - ((shiftUp - depth(x)) - (axisHeight(curSize) + delta))
delta2 = clr - ((axisHeight(curSize) - delta) - (height(z) - shiftDown))
if delta1 > 0 {
	shiftUp += delta1
}
if delta2 > 0 {
	shiftDown += delta2
}

@ 분자, 괘선(있으면), 분모를 커닝으로 띄워 세로 상자 |v|에 쌓는다.
@<|shiftUp|과 |shiftDown|에 따라 분수의...@>=
v := newNullBox(); setType(v, vlistNode)
setHeight(v, shiftUp+height(x)); setDepth(v, depth(z)+shiftDown)
setWidth(v, width(x)) // 이것은 |width(z)|와도 같다
if thickness(q) == 0 {
	p = newKern((shiftUp - depth(x)) - (height(z) - shiftDown))
	setLink(p, z)
} else {
	y = fractionRule(thickness(q))
	p = newKern((axisHeight(curSize) - delta) - (height(z) - shiftDown))
	setLink(y, p); setLink(p, z)
	p = newKern((shiftUp - depth(x)) - (axisHeight(curSize) + delta))
	setLink(p, y)
}
setLink(x, p); setListPtr(v, x)

@ 분수의 양옆에 구분자를 붙인다. 구분자의 크기는 모양에 따라 글꼴 매개변수 |delim1|이나 |delim2|로 정한다. 명령 \.{\\over}처럼
구분자가 없는 분수에서는 널 구분자가 \.{\\nulldelimiterspace}만큼의 빈 공간이 된다.
@<분수를 구분자와 함께...@>=
if curStyle < textStyle {
	delta = delim1(curSize)
} else {
	delta = delim2(curSize)
}
x = varDelimiter(leftDelimiter(q), curSize, delta); setLink(x, v)
z = varDelimiter(rightDelimiter(q), curSize, delta); setLink(v, z)
setNewHlist(q, hpack(x, natural, additional))

@ 노드 |opNoad|의 핵이 문자 하나이면, 따로 세운 모양에서는 먼저 (글꼴의 문자 목록을 따라) 더 큰 것으로 바꾼 다음 축에 맞추어 세로로
가운데에 놓는다. 따로 세운 모양에서는 극한을 연산자의 위와 아래에 놓는 것이 보통 관례다.

아래첨자가 있고 극한을 위아래에 놓지 않으면 문자에서 기울임 보정을 뺀다. 루틴 |makeOp|는 아래첨자와 위첨자 사이의 어긋남으로
쓸 값을 돌려준다.

루틴 |makeOp|가 일을 마치면, 극한을 연산자의 위와 아래에 놓았을 때, 그리고 오직 그때에만 |subtype(q)|가 |limits|다. 그 경우에는
|newHlist(q)|에 원하는 마지막 상자가 이미 들어 있다.

@<수식 구성 프로시저들@>=
func makeOp(q pointer) scaled {
	var delta scaled // 아래첨자와 위첨자 사이의 어긋남
	var p, v, x, y, z pointer // 상자를 만드는 임시 레지스터들
	var c quarterword; var i fourQuarters // 문자를 살피는 레지스터들
	var shiftUp, shiftDown scaled // 상자 계산에 쓰는 치수들
	if subtype(q) == normal && curStyle < textStyle {
		setSubtype(q, limits)
	}
	if mathType(nucleus(q)) == mathChar {
		fetch(nucleus(q))
		if curStyle < textStyle && charTag(curI) == listTag { // 키운다
			c = remByte(curI); i = charInfo(curF, c)
			if charExists(i) {
				curC = c; curI = i; setCharacter(nucleus(q), c)
			}
		}
		delta = charItalic(curF, curI); x = cleanBox(nucleus(q), curStyle)
		if mathType(subscr(q)) != empty && subtype(q) != limits {
			setWidth(x, width(x)-delta) // 기울임 보정을 뺀다
		}
		setShiftAmount(x, half(height(x)-depth(x))-axisHeight(curSize)) // 세로로 가운데 맞춘다
		setMathType(nucleus(q), subBox); setInfo(nucleus(q), x)
	} else {
		delta = 0
	}
	if subtype(q) == limits {
		@<위아래에 극한이 붙고 |delta|만큼 비낀 상자를 만든다@>
	}
	return delta
}

@ 다음 프로그램은 따로 세운 극한을 위한 세로 목록 상자 |v|를 만든다. 위 극한과 연산자와 아래 극한을 가장 넓은 것의 너비에 맞추어
가운데에 놓는다. 극한이 비껴 있어도 상자의 너비는 영향을 받지 않는다.

@<위아래에 극한이 붙고...@>=
x = cleanBox(supscr(q), supStyle(curStyle))
y = cleanBox(nucleus(q), curStyle)
z = cleanBox(subscr(q), subStyle(curStyle))
v = newNullBox(); setType(v, vlistNode); setWidth(v, width(y))
if width(x) > width(v) {
	setWidth(v, width(x))
}
if width(z) > width(v) {
	setWidth(v, width(z))
}
x = rebox(x, width(v)); y = rebox(y, width(v)); z = rebox(z, width(v))
setShiftAmount(x, half(delta)); setShiftAmount(z, -shiftAmount(x))
setHeight(v, height(y)); setDepth(v, depth(y))
@<극한을 |y|에 붙이고 |height(v)|와 |depth(v)|를 맞춘다@>
setNewHlist(q, v)

@ 다음 프로그램에서 |shiftUp|과 |shiftDown|은 따로 세운 연산자 |y|와 그 극한 |x|와 |z| 사이의 간격으로 쓴다. 상자 |v| 안의 세로
목록은 |x| 다음에 |y|, 그다음에 |z|이고, 그 사이와 둘레의 공간을 위한 커닝 노드가 들어간다. 간격은 글꼴 매개변수
|bigOpSpacing1|부터 |bigOpSpacing5|까지로 정한다.

@<극한을 |y|에 붙이고...@>=
if mathType(supscr(q)) == empty {
	freeNode(x, boxNodeSize); setListPtr(v, y)
} else {
	shiftUp = bigOpSpacing3() - depth(x)
	shiftUp = max(shiftUp, bigOpSpacing1())
	p = newKern(shiftUp); setLink(p, y); setLink(x, p)
	p = newKern(bigOpSpacing5()); setLink(p, x); setListPtr(v, p)
	setHeight(v, height(v)+bigOpSpacing5()+height(x)+depth(x)+shiftUp)
}
if mathType(subscr(q)) == empty {
	freeNode(z, boxNodeSize)
} else {
	shiftDown = bigOpSpacing4() - height(z)
	shiftDown = max(shiftDown, bigOpSpacing2())
	p = newKern(shiftDown); setLink(y, p); setLink(p, z)
	p = newKern(bigOpSpacing5()); setLink(z, p)
	setDepth(v, depth(v)+bigOpSpacing5()+height(z)+depth(z)+shiftDown)
}

@ 수식에서 찾은 합자는 |ligatureNode|를 만들지 않는다. 나중에 하이픈을 넣을 일이 없기 때문이다. 합자는 |ordNoad|에 머물러 있다가
그냥 보통 |charNode|가 된다.

현재 문자가 수식 글꼴(곧 |space=0|인 글꼴)에 속할 때에만 기울임 보정을 하고 싶은 경우에는, 여기서 |mathType|을 |mathTextChar|로
바꾼다.

이런 합자에는 경계 문자가 끼어들지 않는다.

@<수식 구성 프로시저들@>=
func makeOrd(q pointer) {
	var a int32 // 합자/커닝 명령의 주소
	var p, r pointer // 목록을 다루는 임시 레지스터들
restart:
	if mathType(subscr(q)) == empty && mathType(supscr(q)) == empty &&
		mathType(nucleus(q)) == mathChar {
		p = link(q)
		if p != null && typ(p) >= ordNoad && typ(p) <= punctNoad &&
			mathType(nucleus(p)) == mathChar && fam(nucleus(p)) == fam(nucleus(q)) {
			setMathType(nucleus(q), mathTextChar)
			fetch(nucleus(q))
			if charTag(curI) == ligTag {
				a = ligKernStart(curF, curI)
				curC = character(nucleus(p))
				curI = fontInfo[a].qqqq
				if skipByte(curI) > stopFlag {
					a = ligKernRestart(curF, curI)
					curI = fontInfo[a].qqqq
				}
				for {
					@<|curI|가 |curC|와의 커닝이나 합자이면 |q|와 |p|를 처리한다@>
					if skipByte(curI) >= stopFlag {
						return
					}
					a = a + qo(skipByte(curI)) + 1
					curI = fontInfo[a].qqqq
				}
			}
		}
	}
}

@ 노드 |ordNoad|와 다른 종류의 노드가 합자로 하나가 되면 결과는 |ordNoad|가 된다는 데 주의하자. 그래도 이를테면 괄호가 어떤
글자 뒤에 올 때 모양이 바뀌게 할 수는 있다. 아마 글꼴 디자이너는 이 관례가 말이 될 때에만 그런 합자를 정의할 것이다.

명령 |curI|가 |curC|와의 커닝이면 그 커닝을 |q| 뒤에 붙이고, |curC|와의 합자이면 노드 |q|와 |p|를 알맞게 합친다. 그런 다음 커서가
노드를 지나쳐 갔으면 |return|하고, 그렇지 않으면 |goto restart|한다.

\chardef\?='174 % 문자를 남김을 나타내는 세로 막대

@<|curI|가 |curC|와의...@>=
if nextChar(curI) == curC && skipByte(curI) <= stopFlag {
	if opByte(curI) >= kernFlag {
		p = newKern(charKern(curF, curI))
		setLink(p, link(q)); setLink(q, p); return
	}
	checkInterrupt() // 끝없는 합자 루프에서 빠져나갈 길을 둔다
	switch opByte(curI) {
	case qi(1), qi(5): setCharacter(nucleus(q), remByte(curI)) // \.{=:\?}, \.{=:\?>}
	case qi(2), qi(6): setCharacter(nucleus(p), remByte(curI)) // \.{\?=:}, \.{\?=:>}
	case qi(3), qi(7), qi(11): @<새 노드 |r|을 |q|와 |p| 사이에 넣는다@>
	default:
		setLink(q, link(p))
		setCharacter(nucleus(q), remByte(curI)) // \.{=:}
		mem[subscr(q)] = mem[subscr(p)]; mem[supscr(q)] = mem[supscr(p)]
		freeNode(p, noadSize)
	}
	if opByte(curI) > qi(3) {
		return
	}
	setMathType(nucleus(q), mathChar); goto restart
}

@ 앞 절의 합자 가운데 \.{\?=:\?}, \.{\?=:\?>}, \.{\?=:\?>>}를 처리한다. 이때는 두 문자를 모두 남기고 그 사이에 새 문자를 넣는다.

@<새 노드 |r|을...@>=
r = newNoad()
setCharacter(nucleus(r), remByte(curI))
setFam(nucleus(r), fam(nucleus(q)))
setLink(q, r); setLink(r, p)
if opByte(curI) < qi(11) {
	setMathType(nucleus(r), mathChar)
} else {
	setMathType(nucleus(r), mathTextChar) // 결합을 막는다
}

@ 다음 부분에 이르렀다면 |checkDimensions|나 |doneWithNoad|나 |doneWithNode|로 가지 않은 경우들에서 ``흘러 내려온'' 것이다. 그러니
|q|~는 핵을 가로 목록으로 바꾸어야 하고, 아래첨자와 위첨자가 있으면 그것들도 붙여야 하는 노드를 가리킨다.

핵 |nucleus(q)|가 |mathChar|가 아니면, 변수 |delta|는 첨자가 둘 다 있을 때 위첨자를 아래첨자보다 오른쪽으로 옮길 양이다.
@^subscripts@>
@^superscripts@>

@<|nucleus(q)|를 가로 목록으로...@>=
switch mathType(nucleus(q)) {
case mathChar, mathTextChar:
	@<|nucleus(q)|의 문자 노드 |p|를 만든다@>
case empty: p = null
case subBox: p = info(nucleus(q))
case subMlist:
	curMlist = info(nucleus(q)); saveStyle = curStyle
	mlistPenalties = false; mlistToHlist() // 재귀 호출
@^recursion@>
	curStyle = saveStyle; @<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
	p = hpack(link(tempHead), natural, additional)
default: confusion("mlist2")
@:this can't happen mlist2}{\quad mlist2@>
}
setNewHlist(q, p)
if mathType(subscr(q)) == empty && mathType(supscr(q)) == empty {
	goto checkDimensions
}
makeScripts(q, delta)

@ 핵 |nucleus(q)|의 문자 노드 |p|를 만든다. 그 뒤에 기울임 보정을 위한 커닝 노드가 올 수도 있다. 아래첨자가 있으면 기울임 보정을
넣지 않고 |delta|로 남겨, 위첨자만 그만큼 오른쪽으로 옮긴다. 그래서 $f_1^2$에서 아래첨자는 $f$에 바짝 붙고 위첨자는 기울어진 끝을
따라 오른쪽에 놓인다.

@<|nucleus(q)|의 문자 노드...@>=
fetch(nucleus(q))
if charExists(curI) {
	delta = charItalic(curF, curI); p = newCharacter(curF, qo(curC))
	if mathType(nucleus(q)) == mathTextChar && space(curF) != 0 {
		delta = 0 // 본문 글꼴의 낱말 가운데에서는 기울임 보정을 하지 않는다
	}
	if mathType(subscr(q)) == empty && delta != 0 {
		setLink(p, newKern(delta)); delta = 0
	}
} else {
	p = null
}

@ 프로시저 |makeScripts(q,delta)|는 노드 |q|의 아래첨자와 위첨자(적어도 하나는 비어 있지 않다)를 |newHlist(q)|에서 시작하는 목록에
덧붙인다. 위첨자는 아래첨자보다 주어진 거리 |delta|만큼 오른쪽에 놓인다.

변수 |shiftDown|과 |shiftUp|은 핵에 따라 아래첨자와 위첨자의 기준선을 옮길 최소량으로 정한다.

@<수식 구성 프로시저들@>=
func makeScripts(q pointer, delta scaled) {
	var x, y, z pointer // 상자를 만드는 임시 레지스터들
	var shiftUp, shiftDown, clr scaled // 계산에 쓰는 치수들
	var t smallNumber // 하위 크기 코드
	p := newHlist(q)
	if isCharNode(p) {
		shiftUp = 0; shiftDown = 0
	} else {
		z = hpack(p, natural, additional)
		if curStyle < scriptStyle { t = scriptSize } else { t = scriptScriptSize }
		shiftUp = height(z) - supDrop(t)
		shiftDown = depth(z) + subDrop(t)
		freeNode(z, boxNodeSize)
	}
	if mathType(supscr(q)) == empty {
		@<위첨자가 없을 때 아래첨자 상자 |x|를 만든다@>
	} else {
		@<위첨자 상자 |x|를 만든다@>
		if mathType(subscr(q)) == empty {
			setShiftAmount(x, -shiftUp)
		} else {
			@<위첨자를 |delta|만큼 비낀 첨자 조합 상자 |x|를 만든다@>
		}
	}
	if newHlist(q) == null {
		setNewHlist(q, x)
	} else {
		p = newHlist(q)
		for link(p) != null {
			p = link(p)
		}
		setLink(p, x)
	}
}

@ 위첨자 없이 아래첨자만 있으면, 아래첨자의 위 끝이 기준선에 x 높이의 5분의 4를 더한 높이를 넘어서는 안 된다. 그보다 높으면 더
내린다.

@<위첨자가 없을 때...@>=
x = cleanBox(subscr(q), subStyle(curStyle))
setWidth(x, width(x)+scriptSpace())
shiftDown = max(shiftDown, sub1(curSize))
clr = height(x) - (abs(mathXHeight(curSize)*4) / 5)
shiftDown = max(shiftDown, clr)
setShiftAmount(x, shiftDown)

@ 위첨자의 아래 끝은 결코 기준선에 x 높이의 4분의 1을 더한 높이보다 내려가서는 안 된다. 위첨자를 올리는 기본 양은 모양에 따라
|sup1|, |sup2|, |sup3| 가운데 하나다.

@<위첨자 상자 |x|를...@>=
x = cleanBox(supscr(q), supStyle(curStyle))
setWidth(x, width(x)+scriptSpace())
if odd(curStyle) {
	clr = sup3(curSize)
} else if curStyle < textStyle {
	clr = sup1(curSize)
} else {
	clr = sup2(curSize)
}
shiftUp = max(shiftUp, clr)
clr = depth(x) + (abs(mathXHeight(curSize)) / 4)
shiftUp = max(shiftUp, clr)

@ 아래첨자와 위첨자가 둘 다 있으면, 아래첨자는 위첨자와 적어도 |defaultRuleThickness|의 네 배만큼 떨어져 있어야 한다. 이 조건이
깨질 것 같으면 아래첨자를 내리고, 그다음 위첨자의 아래 끝이 적어도 기준선에 x 높이의 5분의 4를 더한 높이가 되도록 아래첨자와
위첨자를 함께 올린다.

@<위첨자를 |delta|만큼...@>=
y = cleanBox(subscr(q), subStyle(curStyle))
setWidth(y, width(y)+scriptSpace())
shiftDown = max(shiftDown, sub2(curSize))
clr = 4*defaultRuleThickness() - ((shiftUp - depth(x)) - (height(y) - shiftDown))
if clr > 0 {
	shiftDown += clr
	clr = (abs(mathXHeight(curSize)*4) / 5) - (shiftUp - depth(x))
	if clr > 0 {
		shiftUp += clr
		shiftDown -= clr
	}
}
setShiftAmount(x, delta) // 위첨자는 아래첨자보다 |delta|만큼 오른쪽에 있다
p = newKern((shiftUp - depth(x)) - (height(y) - shiftDown)); setLink(x, p); setLink(p, y)
x = vpack(x, natural, additional); setShiftAmount(x, shiftDown)

@ 이제 |mlistToHlist|의 첫째 훑기에서 할 일을 모두 마쳤다. 둘째 훑기는 그저 목록을 따라가며 알맞은 글루와 벌점으로 모든 것을
이어 붙인다. 이제 |maxH|와 |maxD|를 알므로 |leftNoad|와 |rightNoad|도 이때 처리한다. 변수 |p|는 만들고 있는 가로 목록의 현재 끝
노드를 가리킨다.

@<수식 목록을 다시 훑어...@>=
p = tempHead; setLink(p, null); q = mlist; rType = 0; curStyle = style
@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
for q != null {
	@<노드 |q|의 종류에 따라 |t|와 |s|와 |pen|을 정한다@>
	@<|rType|과 |t|에 따라 원소 사이 간격을 덧붙인다@>
	@<|q|의 |newHlist| 항목과 알맞은 벌점을 덧붙인다@>
	rType = t
deleteQ:
	r = q; q = link(q); freeNode(r, s)
done: ;
}

@ 둘째 훑기에서 큰 |switch|로 들어가기 바로 앞에서 기본값을 정해 두면 갈래 대부분이 짧아진다.

노드 |q|가 모양 노드이면 모양을 바꾸고 |goto deleteQ|한다. 노드(noad)가 아니면 가로 목록에 그대로 넣고 |q|를 다음으로 옮긴 다음
|goto done|한다. 그렇지 않으면 |s|를 노드 |q|의 크기로, |t|를 간격 계산에 쓸 종류(|ordNoad..innerNoad|)로, |pen|을 뒤에 넣을
벌점으로 정한다. 이항 연산자 뒤에는 \.{\\binoppenalty}, 관계 기호 뒤에는 \.{\\relpenalty}를 넣는다.

@<노드 |q|의 종류에 따라...@>=
t = ordNoad; s = noadSize; pen = infPenalty
switch typ(q) {
case opNoad, openNoad, closeNoad, punctNoad, innerNoad: t = typ(q)
case binNoad: t = binNoad; pen = binOpPenalty()
case relNoad: t = relNoad; pen = relPenalty()
case ordNoad, vcenterNoad, overNoad, underNoad: // 아무것도 하지 않는다
case radicalNoad: s = radicalNoadSize
case accentNoad: s = accentNoadSize
case fractionNoad: s = fractionNoadSize
case leftNoad, rightNoad: t = makeLeftRight(q, style, maxD, maxH)
case styleNode: @<현재 모양을 바꾸고 |goto deleteQ|한다@>
case whatsitNode, penaltyNode, ruleNode, discNode, adjustNode, insNode, markNode,
	glueNode, kernNode:
	setLink(p, q); p = q; q = link(q); setLink(p, null); goto done
default: confusion("mlist3")
@:this can't happen mlist3}{\quad mlist3@>
}

@ 함수 |makeLeftRight|는 필요한 크기의 왼쪽이나 오른쪽 구분자를 만들고 |openNoad|나 |closeNoad|를 돌려준다. 구분자는 수식의 축에서
위아래로 가장 먼 거리를 덮어야 한다. 정확히는 그 거리의 두 배에 \.{\\delimiterfactor}/1000을 곱한 것과, 그 거리의 두 배에서
\.{\\delimitershortfall}을 뺀 것 가운데 큰 쪽 이상이어야 한다. 노드 |rightNoad|와 |leftNoad|는 둘 다 원래의 |style|에 바탕을 두므로
크기가 서로 어울린다.

여기서는 |rightNoad-leftNoad=closeNoad-openNoad|라는 사실을 이용한다.

@<수식 구성 프로시저들@>=
func makeLeftRight(q pointer, style smallNumber, maxD, maxH scaled) smallNumber {
	if style < scriptStyle {
		curSize = textSize
	} else {
		curSize = 16 * ((style - textStyle) / 2)
	}
	delta2 := maxD + axisHeight(curSize) // 계산에 쓰는 치수들
	delta1 := maxH + maxD - delta2
	delta1 = max(delta1, delta2) // |delta1|은 축으로부터의 최대 거리다
	delta := (delta1 / 500) * delimiterFactor()
	delta2 = delta1 + delta1 - delimiterShortfall()
	delta = max(delta, delta2)
	setNewHlist(q, varDelimiter(delimiter(q), curSize, delta))
	return typ(q) - (leftNoad - openNoad) // |openNoad|나 |closeNoad|
}

@ 모양 노드를 만나면 현재 모양을 바꾸고 그 노드를 지운다.
@<현재 모양을 바꾸고...@>=
curStyle = subtype(q); s = styleNodeSize
@<|curStyle|에 따라 |curSize|와 |curMu|의 값을 정한다@>
goto deleteQ

@ 수식의 원소 사이 간격은 \TeX이 64자리 문자열로 미리 실어 두는 $8\times8$ 표로 정한다. 행은 앞 원소의 종류, 열은 뒤 원소의 종류다.
이 문자열의 글자는 다음과 같은 뜻을 지닌다.
$$\vbox{\halign{#\hfil\cr
\.0은 공백이 없다는 뜻이다.\cr
\.1은 조건부 가는 공백(\.{\\nonscript\\mskip\\thinmuskip})이라는 뜻이다.\cr
\.2는 가는 공백(\.{\\mskip\\thinmuskip})이라는 뜻이다.\cr
\.3은 조건부 중간 공백(\.{\\nonscript\\mskip\\medmuskip})이라는 뜻이다.\cr
\.4는 조건부 굵은 공백(\.{\\nonscript\\mskip\\thickmuskip})이라는 뜻이다.\cr
\.*는 있을 수 없는 경우라는 뜻이다.\cr}}$$
이 문자열은 꽤 알쏭달쏭하지만, 무슨 일이 일어나야 하는지는 {\sl The \TeX book}이 설명하고, 이 문자열이 바로 그 일을 해낸다.
@:TeXbook}{\sl The \TeX book@>
이를테면 첫 여덟 글자 \.{02340001}이 첫 행이다. Ord 뒤에 Ord가 오면 간격이 없고(\.0), Op가 오면 가는 공백(\.2), Bin이면 중간
공백(\.3), Rel이면 굵은 공백(\.4), Open, Close, Punct이면 간격이 없고, Inner이면 조건부 가는 공백(\.1)이라는 뜻이다.

전역 변수 |magicOffset|은 |a|와 |b|가 |ordNoad..innerNoad| 범위에 있을 때 |strPool[a*8+b+magicOffset]|이 노드 형 |a|와 |b| 사이의
간격을 나타내는 글자가 되도록 계산해 둔다.


@<전역 변수@>=
const @!mathSpacing = "0234000122*4000133**3**344*0400400*000000234000111*1111112341011"

var @!magicOffset int32 // 원소 사이 간격을 찾는 데 쓴다

@ @<마법의 오프셋을 계산한다@>=
magicOffset = strStart[str(mathSpacing)] - 9*ordNoad

@ 앞 원소의 종류 |rType|과 이 원소의 종류 |t|로 표를 찾아 간격 글루를 넣는다. 조건부 공백은 첨자 크기에서는 넣지 않는다.
@<|rType|과 |t|에 따라 원소 사이...@>=
if rType > 0 { // 첫 노드가 아니다
	switch so(strPool[rType*8+t+magicOffset]) {
	case '0': x = 0
	case '1': if curStyle < scriptStyle { x = thinMuSkipCode } else { x = 0 }
	case '2': x = thinMuSkipCode
	case '3': if curStyle < scriptStyle { x = medMuSkipCode } else { x = 0 }
	case '4': if curStyle < scriptStyle { x = thickMuSkipCode } else { x = 0 }
	default: confusion("mlist4")
@:this can't happen mlist4}{\quad mlist4@>
	}
	if x != 0 {
		y = mathGlue(gluePar(x), curMu)
		z = newGlue(y); setGlueRefCount(y, null); setLink(p, z); p = z
		setSubtype(z, x+1) // 기호적인 |subtype|을 저장한다
	}
}

@ 노드 |q|의 가로 목록 항목 뒤에는 벌점 노드를 넣는다. 다만 |pen|이 ``무한'' 벌점이거나, |q| 바로 뒤의 노드가 벌점 노드나 |relNoad|이거나,
|q| 뒤에 노드가 아예 없으면 넣지 않는다. 그래서 `$x:=1$'처럼 관계 기호가 잇달아 오면 그 사이에서는 줄이 나뉘지 않는다.

@<|q|의 |newHlist| 항목과...@>=
if newHlist(q) != null {
	setLink(p, newHlist(q))
	for {
		p = link(p)
		if link(p) == null {
			break
		}
	}
}
if penalties && link(q) != null && pen < infPenalty {
	rType = typ(link(q))
	if rType != penaltyNode && rType != relNoad {
		z = newPenalty(pen); setLink(p, z); p = z
	}
}

@* 정렬.
원시 명령 \.{\\halign}과 \.{\\valign}이 제대로 돌아간다면 그것은 일종의 기적이다. 이 명령들은 \TeX의 아주 많은 제어 구조를
가로지르기 때문이다. 정렬을 처리하는 동안에는 훑개와 매크로 펼치기와 의미 둥지와 상자 꾸리기가 모두 얽혀 돌아간다.

그러니 이 대목은 처음 읽는 이가 이 프로그램을 읽기 시작하기에 좋은 곳은 아니다. 다른 것을 모두 먼저 익히는 편이 낫다.

정렬의 기적이 어떻게 일어나는지 감을 잡으려고, 입력이 어떤 모양일 수 있는지 보기 하나를 들어 생각해 보자. 이 보기는 쓸모 있는
일은 하지 않지만, 다루어야 할 특수한 경우를 모두 보여 줄 만큼 일반적이다. 겉보기에 복잡하고 뜻이 없어 보여도 당황하지 말기
바란다.
$$\vbox{\halign{\.{#}\hfil\cr
{}\\tabskip 2pt plus 3pt\cr
{}\\halign to 300pt\{u1\#v1\&\cr
\hskip 50pt\\tabskip 1pt plus 1fil u2\#v2\&\cr
\hskip 50pt u3\#v3\\cr\cr
\hskip 25pt a1\&\\omit a2\&\\vrule\\cr\cr
\hskip 25pt \\noalign\{\\vskip 3pt\}\cr
\hskip 25pt b1\\span b2\\cr\cr
\hskip 25pt \\omit\&c2\\span\\omit\\cr\}\cr}}$$
일어나는 일은 이렇다.

\yskip
(0) `\.{\\halign to 300pt\{}'를 읽으면 루틴 |scanSpec|이 300pt라는 치수를 |saveStack|에 넣고, 그 위에 |alignGroup| 코드를 넣는다.
그래야 짝이 맞는 `\.\}'를 찾았을 때 정렬을 마무리할 수 있다.

(1) 다음으로 서문을 읽는다. 서문 안의 매크로는 tabskip 지정의 일부가 아니면 펼치지 않는다. 이를테면 위의 서문에서 \.{u2}가
@^preamble@>
매크로였다면 펼쳐졌을 것이다. \TeX이 tabskip 글루의 일부로 `\.{minus...}'가 오는지 내다보아야 하기 때문이다. 사용자의 서문을
바탕으로 ``서문 목록''을 만든다. 우리 보기에서 이 목록에는 다음 일곱 항목이 들어간다.
$$\vbox{\halign{\.{#}\hfil\qquad&(#)\hfil\cr
{}\\glue 2pt plus 3pt&1열 앞의 tabskip\cr
{}\\alignrecord, width $-\infty$&1열의 서문 정보\cr
{}\\glue 2pt plus 3pt&1열과 2열 사이의 tabskip\cr
{}\\alignrecord, width $-\infty$&2열의 서문 정보\cr
{}\\glue 1pt plus 1fil&2열과 3열 사이의 tabskip\cr
{}\\alignrecord, width $-\infty$&3열의 서문 정보\cr
{}\\glue 1pt plus 1fil&3열 뒤의 tabskip\cr}}$$
이 ``alignrecord''(정렬 기록) 항목들은 |unsetNode|와 크기가 같다. 나중에 그런 노드로 바뀌기 때문이다. 그러나 지금은 \ID{type}이나
|subtype| 필드가 없다. 대신 |info| 필드가 있고, 아래에서 설명할 까닭으로 이 필드의 처음 값은 |endSpan|이다. 또 정렬 기록 노드에는
|height|나 |depth| 필드가 없다. 그 자리는 |uPart|와 |vPart|라는 이름으로 정렬의 틀을 담은 토큰 목록을 가리킨다. 이를테면 첫 정렬
기록의 |uPart| 필드는 토큰 목록 `\.{u1}', 곧 1열의 `\.\#' 앞에 있는 틀을 가리킨다.

(2) 이제 \TeX은 서문을 끝낸 \.{\\cr} 뒤에 무엇이 오는지 본다. `\.{\\noalign}'도 `\.{\\omit}'도 아니므로, 읽은 것을 다시 읽도록 되돌려
놓고 틀 `\.{u1}'을 훑개에 먹인다. 이 틀을 읽기 바로 전에 \TeX은 제한된 가로 모드로 들어간다. 틀을 다 읽으면 \TeX은 `\.{a1}'을 읽고,
그다음 ({\.\&}를 알아채면) `\.{v1}'을 읽는다. 그리고 열의 끝을 나타내는 |endv| 토큰을 읽는다. 이 시점에서 현재 가로 목록의 내용(곧
`\.{u1a1v1}')을 담은 |unsetNode|를 만든다. 이 미정 노드의 자연 너비가 1열 정렬 기록의 |width| 필드에 들어간다. 일반적으로 정렬
기록에는 그 열에서 지금까지 나온 자연 너비의 최댓값이 들어 있다.

(3) `\.\&' 뒤에 `\.{\\omit}'이 오므로 이번에는 2열의 틀을 건너뛴다. \TeX은 다시 제한된 가로 모드로 들어가고, 그 결과 가로 목록으로
|unsetNode|를 만든다. 그러나 이번에는 가로 목록에 `\.{a2}'만 들어 있다. 새 미정 상자의 자연 너비는 2열 정렬 기록의 |width| 필드에
기억된다.

(4) 3열을 위한 세 번째 |unsetNode|는 1열 때와 본질적으로 같은 방식으로 만든다. 이 미정 상자에는 `\.{u3\\vrule v3}'이 들어 있다. 이
세로 괘선의 높이와 깊이는 흐르는 치수이므로, 나중에 첫 행 전체의 높이와 깊이까지 늘어난다. 한 행의 |unsetNode|들은 결국 저마다
자신을 둘러싼 상자의 높이와 깊이를 물려받기 때문이다.

(5) 이제 첫 행이 끝났다. 이 행은 다음 일곱 항목으로 이루어진 미정 상자 하나가 된다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: u1a1v1\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: a2\cr
{}\\glue 1pt plus 1fil\cr
{}\\unsetbox for 1 column: u3\\vrule v3\cr
{}\\glue 1pt plus 1fil\cr}}$$
이 미정 행의 너비는 아직 뜻이 없지만, 높이와 깊이는 올바르다. 그래서 이 행을 세로 목록에 넣을 때 올바른 baselineskip 글루가
계산된다.

(6) 현재 \.{\\cr} 뒤에 `\.{\\noalign}'이 오므로, \TeX은 덧붙일 재료(이 경우 \.{\\vskip 3pt})를 세로 목록에 덧붙인다. 이 재료를
처리하는 동안 \TeX은 내부 세로 모드에 있고, |saveStack|에는 |noAlignGroup|이 있다.

(7) 다음 행은 이런 모양의 미정 상자가 된다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 2 columns: u1b1v1u2b2v2\cr
{}\\glue 1pt plus 1fil\cr
{}\\unsetbox for 1 column: {\rm(empty)}\cr
{}\\glue 1pt plus 1fil\cr}}$$
1열과 2열에 걸친 미정 상자의 자연 너비는 ``걸침 노드''(span node)에 저장한다. 걸침 노드는 나중에 설명한다. 1열 정렬 기록의 |info|
필드는 이제 새 걸침 노드를 가리키고, 걸침 노드의 |info|는 |endSpan|을 가리킨다.

(8) 마지막 행은 다음 미정 상자가 된다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: {\rm(empty)}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 2 columns: u2c2v2\cr
{}\\glue 1pt plus 1fil\cr}}$$
2열의 정렬 기록에 새 걸침 노드가 붙는다.

(9) 마지막 단계에서는 참된 열 너비를 계산하고, 미정 상자를 모두 가로 상자로 바꾸고, 그 전부를 \.{\\halign}을 둘러싼 세로 목록에
덧붙인다. 미정 열 상자마다 마지막 너비를 정하는 규칙은 아래에서 설명한다.

그 결과를 그림으로 보이면 다음과 같다(치수는 대강 정했다). 2열만 보면 그 너비는 \.{a2}의 너비면 충분하지만, 둘째 행에서 1열과
2열에 걸친 상자가 1열의 너비와 그 사이의 tabskip을 넘는 만큼 2열이 넓어진다. 걸친 상자의 자연 너비는 걸침 노드에 기록되어 있다가
이때 쓰인다. 셋째 행의 걸친 상자는 2열과 3열과 그 사이의 tabskip을 합친 너비로 맞추어진다. 마지막으로 정렬 전체를 \.{to 300pt}에
맞추려고 tabskip 글루가 늘어나는데, 늘어날 수 있는 것은 fil 차수의 늘어남을 가진 마지막 두 tabskip뿐이다. 회색 부분이 tabskip
글루다.
$$\mplibcode
beginfig(15);
save k, c, h, cell; numeric k, h; numeric c[]; k := 1.3pt; h := 14pt;
c0 := 0; c1 := 8k; c2 := 68k; c3 := 76k; c4 := 128k; c5 := 184k; c6 := 244k; c7 := 300k;
for y = 0, -h-10pt, -2h-12pt:
  fill (c0,y)--(c1,y)--(c1,y-h)--(c0,y-h)--cycle withcolor .88white;
  fill (c2,y)--(c3,y)--(c3,y-h)--(c2,y-h)--cycle withcolor .88white;
  fill (c4,y)--(c5,y)--(c5,y-h)--(c4,y-h)--cycle withcolor .88white;
  fill (c6,y)--(c7,y)--(c7,y-h)--(c6,y-h)--cycle withcolor .88white;
endfor
def cell(expr a, b, y)(text t) =
  unfill (a,y)--(b,y)--(b,y-h)--(a,y-h)--cycle;
  draw (a,y)--(b,y)--(b,y-h)--(a,y-h)--cycle; label(t, (1/2[a,b], y-h/2));
enddef;
cell(c1, c2, 0)(btex \eightpoint\tt u1a1v1 etex);
cell(c3, c4, 0)(btex \eightpoint\tt a2 etex);
cell(c5, c6, 0)(btex \eightpoint u3{\vrule height 7pt depth 2pt}v3 etex);
draw (c0,-h-5pt)--(c7,-h-5pt) dashed evenly;
label.rt(btex \eightpoint \cs{noalign}의 \cs{vskip} etex, (c7+4pt,-h-5pt));
cell(c1, c4, -h-10pt)(btex \eightpoint\tt u1b1v1u2b2v2 etex);
cell(c5, c6, -h-10pt)(btex \eightpoint (비었음) etex);
cell(c1, c2, -2h-12pt)(btex \eightpoint (비었음) etex);
cell(c3, c6, -2h-12pt)(btex \eightpoint\tt u2c2v2 etex);
drawdblarrow (c1,12pt)--(c2,12pt); label.top(btex \eightpoint $w_1$ etex, (1/2[c1,c2],12pt));
drawdblarrow (c3,12pt)--(c4,12pt); label.top(btex \eightpoint $w_2$ etex, (1/2[c3,c4],12pt));
drawdblarrow (c5,12pt)--(c6,12pt); label.top(btex \eightpoint $w_3$ etex, (1/2[c5,c6],12pt));
drawdblarrow (c0,-3h-22pt)--(c7,-3h-22pt); label.bot(btex \eightpoint \.{300pt} etex, (1/2[c0,c7],-3h-22pt));
endfig;
\endmplibcode$$

\yskip\noindent
명령 \.{\\halign}을 처리하는 동안 우리는 아무 두려움 없이 제어를 \TeX의 나머지 부분에 넘겨준다는 데 눈여겨보자. 결정적인 고비마다
정렬 루틴이 불려 나와 작은 일을 하지만, 대부분의 시간 동안 이 루틴들은 그저 뒤에 숨어 있다. 최면 후 암시 같은 것이다.

@ 정렬 기록에는 |height|나 |depth| 필드가 없다고 말했다. 그 |glueSign|과 |glueOrder| 자리도 다른 용도로 쓴다. 틀이 끝날 때 무엇을
할지에 관한 정보를 저장해야 하기 때문이다. 이 정보를 |extraInfo| 필드라고 부른다.

@<정의@>=
func uPart(p pointer) int32 { return mem[p+heightOffset].sc } // \<u_j> 토큰 목록을 가리키는 포인터
func setUPart(p pointer, v int32) { mem[p+heightOffset].sc = v }
func vPart(p pointer) int32 { return mem[p+depthOffset].sc } // \<v_j> 토큰 목록을 가리키는 포인터
func setVPart(p pointer, v int32) { mem[p+depthOffset].sc = v }
func extraInfo(p pointer) halfword { return info(p + listOffset) } // 틀을 처리하는 동안 기억할 정보
func setExtraInfo(p pointer, v halfword) { setInfo(p+listOffset, v) }

@ 정렬 안에 정렬이 있을 수 있으므로, 작은 스택을 써서 정렬 기록 정보를 다룬다. 수준마다 다음 값들이 있다. 서문 목록의 시작을
가리키는 |preamble| 포인터, 서문 목록의 현재 위치를 가리키는 |curAlign| 포인터, 걸친 열들이 시작할 때의 |curAlign| 값을 가리키는
|curSpan| 포인터, 서문을 주기적으로 늘일 때 다음에 베낄 정렬 기록 앞의 tabskip 글루를 가리키는 |curLoop| 포인터, 그리고 중괄호의
중첩을 세어 \.{\\cr}과 \.{\\span}과 탭 표시를 제대로 가로챌 수 있게 해 주는 변수 |alignState|다. 또 가로 모드에서 세로 모드로
옮겨 내는 조정 목록의 머리와 꼬리를 가리키는 포인터 |curHead|와 |curTail|도 있다.

이 일곱 값의 현재 값은 전역 변수에 있다. 안쪽 정렬이 시작해서 이것들을 밀어 내려야 할 때는 다섯 낱말짜리 노드에 저장하고,
|alignPtr|가 그런 노드 가운데 맨 위의 것을 가리킨다.

@<전역 변수@>=
func preamble() pointer { return link(alignHead) } // 현재 서문 목록
func setPreamble(v pointer) { setLink(alignHead, v) }

const @!alignStackNodeSize = 5 // 정렬 상태를 저장하는 |mem| 낱말의 수

var @!curAlign pointer // 서문 목록의 현재 위치
var @!curSpan pointer // 서문 목록에서 현재 걸친 열들의 시작
var @!curLoop pointer // 주기적인 서문을 늘일 때 베낄 곳
var @!alignPtr pointer // 가장 최근에 밀어 내린 정렬 스택 노드
var @!curHead, @!curTail pointer // 조정 목록 포인터들

@ 변수 |alignState|와 |preamble|은 다른 곳에서 초기화한다.

@<핵심 변수들의...@>=
alignPtr = null; curAlign = null; curSpan = null; curLoop = null
curHead = null; curTail = null

@ 정렬 스택은 |pushAlignment|와 |popAlignment|라는 하찮은 루틴 한 쌍이 다룬다.

@<함수들@>=
func pushAlignment() {
	p := getNode(alignStackNodeSize) // 새 정렬 스택 노드
	setLink(p, alignPtr); setInfo(p, curAlign)
	setLlink(p, preamble()); setRlink(p, curSpan)
	mem[p+2].sc = curLoop; mem[p+3].sc = alignState
	setInfo(p+4, curHead); setLink(p+4, curTail)
	alignPtr = p
	curHead = getAvail()
}

func popAlignment() {
	freeAvail(curHead)
	p := alignPtr // 맨 위의 정렬 스택 노드
	curTail = link(p + 4); curHead = info(p + 4)
	alignState = mem[p+3].sc; curLoop = mem[p+2].sc
	curSpan = rlink(p); setPreamble(llink(p))
	curAlign = info(p); alignPtr = link(p)
	freeNode(p, alignStackNodeSize)
}

@ \TeX에는 정렬을 다스리는 프로시저가 여덟 있다. 그 가운데 |initAlign|과 |finAlign|은 맨 처음과 맨 끝에, |initRow|와 |finRow|는
행마다 처음과 끝에 쓴다. 또 |initSpan|은 걸친 열들(열 하나뿐일 수도 있다)의 처음에, |initCol|과 |finCol|은 열마다 처음과 끝에
쓴다. 그리고 |alignPeek|은 \.{\\cr} 뒤에서 다음 항목이 \.{\\noalign}인지 보는 데 쓴다.

이 루틴들을 \.{\\halign} 하나를 처리하는 동안 처음 쓰이는 차례대로, 곧 |initAlign|, |alignPeek|, |initRow|, |initSpan|, |initCol|,
|finCol|, |finRow|, |finAlign| 차례로 살펴보자.

@ 알맞은 모드에서 \.{\\halign}이나 \.{\\valign}을 읽으면 \TeX은 |initAlign|을 부른다. 이 루틴이 할 일은 모든 것을 좋게 출발시키는
것이고, 그 일은 주로 서문을 읽어 그 정보를 서문 목록에 넣는 것이다.
@^preamble@>


@<함수들@>=
@<|getPreambleToken|이라는 프로시저를 선언한다@>@;
func initAlign() {
	var saveCsPtr pointer // 오류 메시지를 위한 |warningIndex| 값
	var p pointer // 잠깐 쓰는 임시 변수
	saveCsPtr = curCs // 대개 \.{\\halign}이나 \.{\\valign}
	pushAlignment(); alignState = -1000000 // 새 정렬 수준에 들어간다
	@<따로 세운 수식 안의 부적절한 정렬을 검사한다@>
	pushNest() // 새 의미 수준에 들어간다
	@<현재 모드를 \.{\\halign}이면 |-vmode|로, \.{\\valign}이면 |-hmode|로 바꾼다@>
	scanSpec(alignGroup, false)
	@<서문을 훑어 |preamble| 목록에 기록한다@>
	newSaveLevel(alignGroup)
	if everyCr() != null {
		beginTokenList(everyCr(), everyCrText)
	}
	alignPeek() // \.{\\noalign}이나 \.{\\omit}을 찾는다
}

@ 세로 모드에서는 |prevDepth|가 이미 올바른 값을 가지고 있다. 그러나 |mmode|(따로 세운 수식 모드)에 있으면, 올바른 기준선 계산을
낳는 |prevDepth| 값을 얻으려고 바깥의 세로 모드까지 손을 뻗는다.

@<현재 모드를...@>=
if mode == mmode {
	mode = -vmode; setPrevDepth(nest[nestPtr-2].auxField.sc)
} else if mode > 0 {
	mode = -mode
}

@ 명령 \.{\\halign}을 따로 세운 수식으로 쓸 때는 다른 수식 목록 조각이 없어야 한다. 이를테면 \.{\$\$x\\halign\{...\}\$\$}는 안 된다.

@<따로 세운 수식 안의 부적절한 정렬을 검사한다@>=
if mode == mmode && (tail != head || incompleatNoad() != null) {
	printErr("Improper "); printEsc("halign"); printStr(" inside $$'s")
@.Improper \\halign...@>
	help3("Displays can use special alignments (like \\eqalignno)",
		"only if nothing but the alignment itself is between $$'s.",
		"So I've deleted the formulas that preceded this alignment.")
	reportError(); flushMath()
}

@ 서문을 읽는다. tabskip 글루와 정렬 기록을 번갈아 서문 목록에 덧붙이다가 \.{\\cr}에서 멈춘다.
@<서문을 훑어...@>=
setPreamble(null); curAlign = alignHead; curLoop = null; scannerStatus = aligning
warningIndex = saveCsPtr; alignState = -1000000 // 이 시점에서 |curCmd=leftBrace|
for {
	@<현재 tabskip 글루를 서문 목록에 덧붙인다@>
	if curCmd == carRet {
		goto done // \.{\\cr}이 서문을 끝낸다
	}
	@<|curCmd|가 |tabMark|나 |carRet|일 때까지 서문 텍스트를 훑는다@>
}
done:
	scannerStatus = normal

@ 현재의 \.{\\tabskip} 값으로 글루 노드를 만들어 서문 목록에 덧붙인다.
@<현재 tabskip 글루를...@>=
setLink(curAlign, newParamGlue(tabSkipCode))
curAlign = link(curAlign)

@ 명령 코드 |curCmd|가 |tabMark|나 |carRet|가 될 때까지 서문 텍스트를 읽으면서 tabskip 글루가 바뀌는지 살피고, 정렬 기록을 서문 목록에
덧붙인다. 틀은 \.\# 앞의 \<u_j>와 뒤의 \<v_j>로 나누어 저장한다.

@<|curCmd|가 |tabMark|나...@>=
@<틀 \<u_j>를 훑어 그 토큰 목록을 |holdHead|에 둔다@>
setLink(curAlign, newNullBox()); curAlign = link(curAlign) // 새 정렬 기록
setInfo(curAlign, endSpan); setWidth(curAlign, nullFlag)
setUPart(curAlign, link(holdHead))
@<틀 \<v_j>를 훑어 그 토큰 목록을 |holdHead|에 둔다@>
setVPart(curAlign, link(holdHead))

@ 명령 `\.{\\span}'은 |tabMark|를 명령 코드로, |spanCode|를 수정자로 해서 |eqtb|에 넣는다. 그러면 \TeX은 이것을 `\.\&' 같은 정렬
구분자와 거의 똑같이 다루면서도, 보통 구분자와 구별해야 할 때는 가려낼 수 있다. 또 `\.{\\cr}'에는 특별한 |crCode|를, `\.{\\crcr}'에는
그보다 큰 |crCrCode|를 주면 쓸모가 있다.

틀의 끝은 \.{\\endtemplate}이라는 ``얼린'' 제어 시퀀스 둘로 나타낸다. 첫째 것의 명령 코드는 |endTemplate|인데, 이것은 |>outerCall|이어서
오류가 있어도 쉽게 사라지지 않는다. 루틴 |getXToken|은 첫째 것을 둘째 것으로 바꾸는데, 둘째 것의 명령 코드는 |endv|다.

@<정의@>=
const (
	@!spanCode = 256 // 어떤 문자와도 다르다
	@!crCode = 257 // |spanCode|와도, 어떤 문자와도 다르다
	@!crCrCode = crCode + 1 // 이것으로 \.{\\crcr}을 \.{\\cr}과 구별한다
	@!endTemplateToken = csTokenFlag + frozenEndTemplate
)

@ 앞 절의 원시 명령들을 해시 표에 넣고, 얼린 \.{\\cr}과 두 \.{\\endtemplate}도 만들어 둔다.

@<\TeX의 원시 명령을...@>=
primitive("span", tabMark, spanCode)
@!@:span_}{\.{\\span} primitive@>
primitive("cr", carRet, crCode)
@!@:cr_}{\.{\\cr} primitive@>
setText(frozenCr, str("cr")); eqtb[frozenCr] = eqtb[curVal]
primitive("crcr", carRet, crCrCode)
@!@:cr_cr_}{\.{\\crcr} primitive@>
setText(frozenEndTemplate, str("endtemplate")); setText(frozenEndv, str("endtemplate"))
@.endtemplate@>
setEqType(frozenEndv, endv); setEquiv(frozenEndv, nullList)
setEqLevel(frozenEndv, levelOne)
eqtb[frozenEndTemplate] = eqtb[frozenEndv]
setEqType(frozenEndTemplate, endTemplate)

@ @<원시 명령의 이름을 찍는...@>=
case tabMark:
	if chrCode == spanCode {
		printEsc("span")
	} else {
		chrCmd("alignment tab character ")
	}
case carRet:
	if chrCode == crCode {
		printEsc("cr")
	} else {
		printEsc("crcr")
	}

@ 서문은 그대로 베낀다. 다만 \.{\\tabskip}은 tabskip 글루를 바꾸므로 그 값을 읽으면서 바로 뒤의 매크로를 펼칠 수도 있다. 명령
\.{\\span}이 나와도 그 뒤의 토큰이 한 번 펼쳐진다.

서문에 `\.{\\global\\tabskip}'이 들어 있으면, `\.{\\global}' 토큰은 서문에 남고 `\.{\\tabskip}'은 새 tabskip 글루를 (지역적으로)
정의한다는 데 주의하자.

@<|getPreambleToken|이라는...@>=
func getPreambleToken() {
restart:
	getToken()
	for curChr == spanCode && curCmd == tabMark {
		getToken() // 이 토큰은 한 번 펼쳐진다
		if curCmd > maxCommand {
			expand(); getToken()
		}
	}
	if curCmd == endv {
		fatalError("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	if curCmd == assignGlue && curChr == glueBase+tabSkipCode {
		scanOptionalEquals(); scanGlue(glueVal)
		if globalDefs() > 0 {
			geqDefine(glueBase+tabSkipCode, glueRef, curVal)
		} else {
			eqDefine(glueBase+tabSkipCode, glueRef, curVal)
		}
		goto restart
	}
}

@ 틀 \<u_j>를 \.\#이 나올 때까지 읽는다. 틀의 처음에 있는 공백은 없앤다. 틀이 시작하자마자 \.\&이 오면, 곧 서문에 `\.{\&\&}'이 있으면
거기서부터 서문이 주기적으로 되풀이된다는 표시로 |curLoop|를 정한다. \.\#이 없이 열이 끝나면 오류다.

@<틀 \<u_j>를 훑어...@>=
p = holdHead; setLink(p, null)
for {
	getPreambleToken()
	if curCmd == macParam {
		goto done1
	}
	if curCmd <= carRet && curCmd >= tabMark && alignState == -1000000 {
		if p == holdHead && curLoop == null && curCmd == tabMark {
			curLoop = curAlign
		} else {
			printErr("Missing # inserted in alignment preamble")
@.Missing \# inserted...@>
			help3("There should be exactly one # between &'s, when an",
				"\\halign or \\valign is being set up. In this case you had",
				"none, so I've put one in; maybe that will work.")
			backError(); goto done1
		}
	} else if curCmd != spacer || p != holdHead {
		setLink(p, getAvail()); p = link(p); setInfo(p, curTok)
	}
}
done1:

@ 틀 \<v_j>를 열의 끝이 나올 때까지 읽는다. 틀 하나에 \.\#이 두 번 나오면 오류다. 끝에 \.{\\endtemplate} 토큰을 붙인다.
@<틀 \<v_j>를 훑어...@>=
p = holdHead; setLink(p, null)
for {
again:
	getPreambleToken()
	if curCmd <= carRet && curCmd >= tabMark && alignState == -1000000 {
		goto done2
	}
	if curCmd == macParam {
		printErr("Only one # is allowed per tab")
@.Only one \# is allowed...@>
		help3("There should be exactly one # between &'s, when an",
			"\\halign or \\valign is being set up. In this case you had",
			"more than one, so I'm ignoring all but the first.")
		reportError(); goto again
	}
	setLink(p, getAvail()); p = link(p); setInfo(p, curTok)
}
done2:
	setLink(p, getAvail()); p = link(p)
	setInfo(p, endTemplateToken) // 끝에 \.{\\endtemplate}을 둔다

@ 정렬에서 까다로운 부분은 틀을 알맞은 때에 훑개에 먹이는 것, 그리고 행이나 열이 끝났을 때 제어를 되찾는 것이다.

대개 \.{\\cr}을 알아챌 때마다 새 행을 시작한다. 다만 그 \.{\\cr} 뒤에 \.{\\noalign}이나 정렬을 끝내는 오른쪽 중괄호가 오면 그렇지
않다. 루틴 |alignPeek|은 앞을 내다보고 올바른 일을 한다. 새 행을 시작하거나, \.{\\noalign}을 시작하거나, 정렬을 마무리한다.
명령 \.{\\crcr}은 바로 앞이 \.{\\cr}이었으면 아무 일도 하지 않으므로 여기서 건너뛴다.

@<|alignPeek|이라는 프로시저를 선언한다@>=
func alignPeek() {
restart:
	alignState = 1000000; @<공백도 호출도 아닌...@>
	if curCmd == noAlign {
		scanLeftBrace(); newSaveLevel(noAlignGroup)
		if mode == -vmode {
			normalParagraph()
		}
	} else if curCmd == rightBrace {
		finAlign()
	} else if curCmd == carRet && curChr == crCrCode {
		goto restart // \.{\\crcr}은 무시한다
	} else {
		initRow() // 새 행을 시작한다
		initCol() // 새 열을 시작하고, 엿본 것을 되돌린다
	}
}

@ 행을 시작하려면 새 의미 수준에 들어가서 첫 tabskip 글루를 베끼고, 내부 세로 모드에서 제한된 가로 모드로, 또는 그 반대로 바꾼다.
이 의미 수준에서는 |spaceFactor|와 |prevDepth|를 쓰지 않지만, 깔끔하게 하려고 0으로 해 둔다.

@<함수들@>=
@<|initSpan|이라는 프로시저를 선언한다@>@;
func initRow() {
	pushNest(); mode = (-hmode - vmode) - mode
	if mode == -hmode { setSpaceFactor(0) } else { setPrevDepth(0) }
	tailAppend(newGlue(gluePtr(preamble())))
	setSubtype(tail, tabSkipCode+1)
	curAlign = link(preamble()); curTail = curHead; initSpan(curAlign)
}

@ 프로시저 |initSpan|의 매개변수는 다음 열이나 걸친 열 무리가 시작하는 정렬 기록을 가리킨다. 새 의미 수준에 들어가서, 그 열들이
나중에 상자로 묶을 목록을 만들게 한다.

@<|initSpan|이라는...@>=
func initSpan(p pointer) {
	pushNest()
	if mode == -hmode {
		setSpaceFactor(1000)
	} else {
		setPrevDepth(ignoreDepth); normalParagraph()
	}
	curSpan = p
}

@ 열이 시작할 때는 |curCmd|가 |omit|이거나, 아니면 현재 토큰을 \<u_j> 틀 뒤에 다시 읽도록 입력에 되돌려 두어야 한다고 가정한다.
(|curCmd|가 |tabMark|나 |carRet|일 수도 있다는 데 주의하자.) 또 이때 |alignState|가 대략 1000000이라고 가정한다. 같은 모드에
머물러 있으면서, 필요하면 틀을 시작한다.

@<함수들@>=
func initCol() {
	setExtraInfo(curAlign, curCmd)
	if curCmd == omit {
		alignState = 0
	} else {
		backInput(); beginTokenList(uPart(curAlign), uTemplate)
	} // 이제 |alignState=1000000|
}

@ \<u_j> 틀이 끝나면 훑개가 |alignState|를 0으로 놓는다. 그 뒤에 \.{\\cr}이나 \.{\\span}이나 탭 표시가 |alignState=0|일 때 나타나면
훑개는 다음 코드를 실행하고, 이 코드가 \<v_j> 틀을 시작한다. 이때 |curChr|를 기억해 두어야 한다. 이 값은 열의 텍스트가 어떻게
끝났는지에 따라 |crCrCode|, |crCode|, |spanCode|, 또는 문자 코드다.

다른 정렬의 서문을 읽는 도중이거나 진행 중인 정렬이 없을 때는 프로그램의 이 부분이 실행되어서는 안 된다. 두 정렬의 서문이
엉키면 치명적인 오류로 끝낸다.

@<\<v_j> 틀을 끼워...@>=
if scannerStatus == aligning || curAlign == null {
	fatalError("(interwoven alignment preambles are not allowed)")
}
@.interwoven alignment preambles...@>
curCmd = extraInfo(curAlign); setExtraInfo(curAlign, curChr)
if curCmd == omit {
	beginTokenList(omitTemplate, vTemplate)
} else {
	beginTokenList(vPart(curAlign), vTemplate)
}
alignState = 1000000; goto restart

@ 방금 말한 토큰 목록 |omitTemplate|은 특별한 제어 시퀀스 \.{\\endtemplate} 하나만 담은 상수 토큰 목록이다. 명령 \.{\\omit}한 열은
이것을 \<v_j> 대신 읽는다.

@<특별한 목록 머리와...@>=
setInfo(omitTemplate, endTemplateToken) // |link(omitTemplate)=null|

@ \<v_j> 틀의 끝에 있는 |endv| 명령이 훑개를 지나오면 비로소 진짜 일이 시작된다. 그 일은 루틴 |finCol|이 한다. 이 루틴은 열만이
아니라 행까지 끝났으면 |true|를 돌려준다. 열을 끝낸 것이 \.{\\span}이면 다음 열을 이 열에 이어 붙이고, 탭 표시이면 다음 열을
시작한다.

@<함수들@>=
func finCol() bool {
	var r pointer // 목록을 다루는 임시 포인터들
	var s pointer // 새 걸침 노드
	var u pointer // 새 미정 상자
	var w scaled // 자연 너비
	var o glueOrd // 무한의 차수
	var n halfword // 걸침 계수기
	if curAlign == null {
		confusion("endv")
	}
	q := link(curAlign); if q == null { confusion("endv") }
@:this can't happen endv}{\quad endv@>
	if alignState < 500000 {
		fatalError("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	p := link(q) // 현재 정렬 기록 다음의 정렬 기록
	@<서문 목록을 다 지나왔으면 행이 끝났는지 검사한다@>
	if extraInfo(curAlign) != spanCode {
		unsave(); newSaveLevel(alignGroup)
		@<현재 열의 미정 상자를 묶고 그 너비를 기록한다@>
		@<열 사이의 tabskip 글루를 베낀다@>
		if extraInfo(curAlign) >= crCode {
			return true
		}
		initSpan(p)
	}
	alignState = 1000000; @<공백도 호출도 아닌...@>
	curAlign = p
	initCol(); return false
}

@ 서문 목록의 열을 다 쓰고도 열이 더 나오면, 서문이 주기적이면 서문을 늘이고, 아니면 남는 탭 표시를 \.{\\cr}로 바꾸었다고 알린다.
@<서문 목록을 다 지나왔으면...@>=
if p == null && extraInfo(curAlign) < crCode {
	if curLoop != null {
		@<서문을 주기적으로 늘인다@>
	} else {
		printErr("Extra alignment tab has been changed to ")
@.Extra alignment tab...@>
		printEsc("cr")
		help3("You have given more \\span or & marks than there were",
			"in the preamble to the \\halign or \\valign now in progress.",
			"So I'll assume that you meant to type \\cr instead.")
		setExtraInfo(curAlign, crCode); reportError()
	}
}

@ 서문을 주기적으로 늘인다. 포인터 |curLoop|가 가리키는 정렬 기록의 틀과 tabskip을 베껴 새 열을 만든다.
@<서문을 주기적으로...@>=
setLink(q, newNullBox()); p = link(q) // 새 정렬 기록
setInfo(p, endSpan); setWidth(p, nullFlag); curLoop = link(curLoop)
@<노드 |curLoop|의 틀을 노드 |p|로 베낀다@>
curLoop = link(curLoop)
setLink(p, newGlue(gluePtr(curLoop)))
setSubtype(link(p), tabSkipCode+1)

@ 틀의 토큰 목록 두 개를 베낀다.
@<노드 |curLoop|의 틀을...@>=
q = holdHead; r = uPart(curLoop)
for r != null {
	setLink(q, getAvail()); q = link(q); setInfo(q, info(r)); r = link(r)
}
setLink(q, null); setUPart(p, link(holdHead))
q = holdHead; r = vPart(curLoop)
for r != null {
	setLink(q, getAvail()); q = link(q); setInfo(q, info(r)); r = link(r)
}
setLink(q, null); setVPart(p, link(holdHead))

@ 열 사이에 tabskip 글루를 덧붙인다.
@<열 사이의 tabskip...@>=
tailAppend(newGlue(gluePtr(link(curAlign))))
setSubtype(tail, tabSkipCode+1)

@ 현재 열의 내용을 미정 상자로 꾸린다. 가로 정렬이면 자연 너비를, 세로 정렬이면 자연 높이를 잰다. 열 하나이면 그 정렬 기록의 너비를,
여러 열에 걸쳤으면 걸침 노드의 너비를 최댓값으로 고친다.
@<현재 열의 미정 상자를...@>=
if mode == -hmode {
	adjustTail = curTail; u = hpack(link(head), natural, additional); w = width(u)
	curTail = adjustTail; adjustTail = null
} else {
	u = vpackage(link(head), natural, additional, 0); w = height(u)
}
n = minQuarterword // 이것은 걸침 계수 1을 나타낸다
if curSpan != curAlign {
	@<걸친 열들의 너비 항목을 갱신한다@>
} else if w > width(curAlign) {
	setWidth(curAlign, w)
}
setType(u, unsetNode); setSpanCount(u, n)
@<늘이기 차수를 정한다@>
setGlueOrder(u, o); setGlueStretch(u, totalStretch[o])
@<줄이기 차수를 정한다@>
setGlueSign(u, o); setGlueShrink(u, totalShrink[o])
popNest(); setLink(tail, u); tail = u

@ 걸침 노드는 |width|, |info|, |link| 필드를 가진 두 낱말짜리 레코드다. 필드 |link|는 사실 연결이 아니라 걸친 열의 수를 나타낸다.
필드 |info|는 같은 열에서 시작하면서 더 넓게 걸친 걸침 노드를 가리키거나, 가능한 가장 큰 |link| 값을 가진 |endSpan|을 가리킨다.
필드 |width|에는 그 열들에 걸친 항목들의 자연 너비 가운데 가장 큰 값이 들어 있다.

어떤 열에서 시작하는 걸친 열들에 대한 지금까지의 최대 너비 목록은, 그 열의 정렬 기록의 |info| 필드에서 시작한다. 걸친 열의 수가
작은 것부터 차례로 이어져 있다.

@<정의@>=
const @!spanNodeSize = 2 // 걸침 노드의 |mem| 낱말 수

@ 앞 절의 |endSpan|을 초기화한다. 이 노드의 |link|는 어떤 걸침 노드보다 크므로 목록을 훑다가 반드시 멈춘다.

@<특별한 목록 머리와...@>=
setLink(endSpan, maxQuarterword+1); setInfo(endSpan, null)

@ 걸친 열의 수 |n|을 세고, 그 수에 해당하는 걸침 노드를 찾아 너비를 고친다. 없으면 새 걸침 노드를 알맞은 자리에 끼워 넣는다.
@<걸친 열들의 너비...@>=
q = curSpan
for {
	n++; q = link(link(q))
	if q == curAlign {
		break
	}
}
if n > maxQuarterword {
	confusion("256 spans") // 이런 일이 일어날 수는 있지만, 일어나지 않을 것이다
}
@^system dependencies@>
@:this can't happen 256 spans}{\quad 256 spans@>
q = curSpan
for link(info(q)) < n {
	q = info(q)
}
if link(info(q)) > n {
	s = getNode(spanNodeSize); setInfo(s, info(q)); setLink(s, n)
	setInfo(q, s); setWidth(s, w)
} else if width(info(q)) < w {
	setWidth(info(q), w)
}

@ 행이 끝나면 미정 상자 하나를 현재 세로 목록(\.{\\halign}일 때)이나 현재 가로 목록(\.{\\valign}일 때)에 덧붙인다. 이 미정 상자에는
tabskip 글루로 나뉜 열들의 미정 상자가 들어 있다. 모든 것은 나중에 정해진다. 행을 덧붙인 뒤 \.{\\everycr}을 끼워 넣고 다음을
내다본다.

@<함수들@>=
func finRow() {
	var p pointer // 새 미정 상자
	if mode == -hmode {
		p = hpack(link(head), natural, additional)
		popNest(); appendToVlist(p)
		if curHead != curTail {
			setLink(tail, link(curHead)); tail = curTail
		}
	} else {
		p = vpack(link(head), natural, additional); popNest()
		setLink(tail, p); tail = p; setSpaceFactor(1000)
	}
	setType(p, unsetNode); setGlueStretch(p, 0)
	if everyCr() != null {
		beginTokenList(everyCr(), everyCrText)
	}
	alignPeek()
} // |glueShrink==shiftAmount|이므로 |glueShrink(p)=0|임에 주의하라

@ 마침내 정렬의 끝에 이르렀다. 메모리가 넘치지 않았다는 데 안도의 한숨을 쉬어도 좋다. 이제 모든 미정 상자의 크기를 정해서, 걸친
열들까지 알맞게 고려하며 열들이 가지런히 서게 한다.


@<함수들@>=
func finAlign() {
	var p, r, s, u, v pointer // 목록 연산을 위한 레지스터들
	var t, w scaled // 열의 너비
	var o scaled // 미정 상자를 옮길 양
	var n halfword // 맞추어 볼 걸침의 양
	var ruleSave scaled // |overfullRule|을 잠시 담아 둔다
	if curGroup != alignGroup {
		confusion("align1")
	}
@:this can't happen align}{\quad align@>
	unsave() // 그 |alignGroup|은 각 항목을 위한 것이었다
	if curGroup != alignGroup {
		confusion("align0")
	}
	unsave() // 그 |alignGroup|은 정렬 전체를 위한 것이었다
	if nest[nestPtr-1].modeField == mmode {
		o = displayIndent()
	} else {
		o = 0
	}
	@<서문 목록을 지나가며 열 너비를 정하고 정렬 기록을 바꾼다@>
	@<서문 목록을 묶어 |p|가 그 견본 상자를 가리키게 한다@>
	@<현재 목록의 모든 미정 상자의 글루를 정한다@>
	flushNodeList(p); popAlignment()
	@<현재 목록을 그 환경에 넣는다@>
}

@<|alignPeek|이라는...@>

@ 이제 서문 목록을 해체하고 열 너비를 계산할 때다. 값 $w_{ij}$를 $i$열부터 $j$열까지(양 끝 포함) 걸친 모든 항목의 자연 너비의
최댓값이라고 하자. 그러면 $i$열의 정렬 기록은 |width| 필드에 $w_{ii}$를 담고, |info| 필드에서 시작하는 연결 목록에 $j$가 커지는
차례로 0이 아닌 $w_{ij}$를 담는다. 이 걸침 노드들의 |link| 필드에는 $j-i+|minQuarterword|$ 값이 들어 있다. 값 $w_{ii}$는 |nullFlag|로
초기화했는데, 이것을 $-\infty$로 여긴다.

마지막 열 너비는 다음 식으로 정의한다.
$$w_j=\max_{1\le i\le j}\biggl( w_{ij}-\sum_{i\le k<j}(t_k+w_k)\biggr)$$
여기서 $t_k$는 $k$열과 $k+1$열 사이 tabskip 글루의 자연 너비다. 다만 |1<=i<=j| 범위의 모든 |i|에 대해 $w_{ij}=-\infty$이면(곧
|j|열에 관련된 모든 항목이 |j+1|열에도 걸쳐 있으면), $w_j=0$으로 하고 |j|열 뒤의 tabskip 글루도 0으로 만든다.

\TeX은 이 값들을 다음 방식으로 계산한다. 먼저 $w_1=w_{11}$이다. 그런 다음 모든 $j>1$에 대해 $w_{2j}$를 $\max(w_{2j},
w_{1j}-t_1-w_1)$로 바꾼다. 그러면 $w_2=w_{22}$다. 그런 다음 모든 $j>2$에 대해 $w_{3j}$를 $\max(w_{3j},w_{2j}-t_2-w_2)$로 바꾼다.
이렇게 계속한다. 곧 왼쪽 열이 이미 차지한 너비를 빼고 남은 걸침을 한 열씩 오른쪽으로 넘겨준다. 어떤 $w_j$가 $-\infty$로 드러나면 그
값을 0으로 바꾸고, 다음 tabskip도 0으로 바꾼다.

정렬 기록들은 여기서 가짜 미정 상자로 바뀐다.

@<서문 목록을 지나가며...@>=
q := link(preamble())
for {
	flushList(uPart(q)); flushList(vPart(q))
	p = link(link(q))
	if width(q) == nullFlag {
		@<|width(q)|와 이 열 뒤의 tabskip 글루를 없앤다@>
	}
	if info(q) != endSpan {
		@<|q|의 걸침 노드 너비를 |p|의 것과 합치고 |q|의 걸침 노드를 없앤다@>
	}
	setType(q, unsetNode); setSpanCount(q, minQuarterword); setHeight(q, 0)
	setDepth(q, 0); setGlueOrder(q, normal); setGlueSign(q, normal)
	setGlueStretch(q, 0); setGlueShrink(q, 0); q = p
	if q == null {
		break
	}
}

@ 어느 항목도 이 열에서 끝나지 않으면 열 너비와 그 뒤의 tabskip을 0으로 한다.
@<|width(q)|와 이 열 뒤의...@>=
setWidth(q, 0); r = link(q); s = gluePtr(r)
if s != zeroGlue {
	addGlueRef(zeroGlue); deleteGlueRef(s)
	setGluePtr(r, zeroGlue)
}

@ 두 걸침 노드 목록을 합치는 것은 선형 연결 자료 구조를 다루는 전형적인 연습 문제다. 다음 루프의 본질적인 불변식은 이렇다. 우리는
|q|의 목록에 있는 노드 |r|을 처리하려 하고, |u|는 그 다음 노드다. 그리고 |p|의 목록에서 |s|까지(|s| 포함)의 모든 노드는 처리했고,
|s|의 다음 노드는 |link(r)=n|이냐 |link(r)>n|이냐 |link(r)<n|이냐에 따라 |r|과 맞거나, |r|보다 앞서거나, |r|보다 뒤에 온다.

@<|q|의 걸침 노드 너비를...@>=
t = width(q) + width(gluePtr(link(q)))
r = info(q); s = endSpan; setInfo(s, p); n = minQuarterword + 1
for {
	setWidth(r, width(r)-t); u = info(r)
	for link(r) > n {
		s = info(s); n = link(info(s)) + 1
	}
	if link(r) < n {
		setInfo(r, info(s)); setInfo(s, r); setLink(r, link(r)-1); s = r
	} else {
		if width(r) > width(info(s)) {
			setWidth(info(s), width(r))
		}
		freeNode(r, spanNodeSize)
	}
	r = u
	if r == endSpan {
		break
	}
}

@ 이제 서문 목록은 미정 상자와 tabskip 글루가 번갈아 나오는 목록으로 바뀌었고, 상자 너비는 마지막 열 너비와 같다. 이것을 정렬의
목표 너비로 꾸려 tabskip 글루의 비율을 정한다. 명령 \.{\\valign}이면 너비를 높이로 바꾸어서, 정렬이 넘치거나 덜 찰 때 올바른 오류
메시지가 나오게 한다.

@<서문 목록을 묶어...@>=
savePtr -= 2; packBeginLine = -modeLine
if mode == -vmode {
	ruleSave = overfullRule()
	setOverfullRule(0) // 괘선이 묶이지 않게 한다
	p = hpack(preamble(), saved(1), saved(0)); setOverfullRule(ruleSave)
} else {
	q = link(preamble())
	for {
		setHeight(q, width(q)); setWidth(q, 0); q = link(link(q))
		if q == null {
			break
		}
	}
	p = vpack(preamble(), saved(1), saved(0))
	q = link(preamble())
	for {
		setWidth(q, height(q)); setHeight(q, 0); q = link(link(q))
		if q == null {
			break
		}
	}
}
packBeginLine = 0

@ 현재 목록의 행들을 차례로 보며 미정 상자를 정하고, \.{\\noalign}으로 넣은 괘선은 정렬의 경계까지 늘인다.
@<현재 목록의 모든 미정 상자의...@>=
q = link(head); s = head
for q != null {
	if !isCharNode(q) {
		if typ(q) == unsetNode {
			@<미정 상자 |q|와 그 안의 미정 상자들을 정한다@>
		} else if typ(q) == ruleNode {
			@<괘선 |q|의 흐르는 치수를 정렬의 경계까지 늘인다@>
		}
	}
	s = q; q = link(q)
}

@ 괘선의 흐르는 치수를 정렬 상자의 치수로 바꾼다. 그래서 \.{\\noalign\{\\hrule\}}은 정렬 전체의 너비만큼 뻗는다.
@<괘선 |q|의 흐르는...@>=
if isRunning(width(q)) {
	setWidth(q, width(p))
}
if isRunning(height(q)) {
	setHeight(q, height(p))
}
if isRunning(depth(q)) {
	setDepth(q, depth(p))
}
if o != 0 {
	r = link(q); setLink(q, null); q = hpack(q, natural, additional)
	setShiftAmount(q, o); setLink(q, r); setLink(s, q)
}

@ 미정 상자 |q|는 미정 상자를 하나 이상 담은 행을 나타낸다. 몇 개를 담았는지는 그 행에서 \.{\\cr}이 얼마나 일찍 나왔는지에 달려 있다.
행 상자는 서문 목록을 꾸린 상자 |p|의 글루 설정을 그대로 물려받는다.

@<미정 상자 |q|와 그 안의...@>=
if mode == -vmode {
	setType(q, hlistNode); setWidth(q, width(p))
} else {
	setType(q, vlistNode); setHeight(q, height(p))
}
setGlueOrder(q, glueOrder(p)); setGlueSign(q, glueSign(p))
setGlueSet(q, glueSet(p)); setShiftAmount(q, o)
r = link(listPtr(q)); s = link(listPtr(p))
for {
	@<노드 |r|의 글루를 정하고 미정 노드에서 바꾼다@>
	r = link(link(r)); s = link(link(s))
	if r == null {
		break
	}
}

@ 걸친 열들로 만든 상자 뒤에는, 걸침이 없었던 것처럼 tabskip 글루 노드와 빈 상자를 덧붙인다. 그러면 뒤따르는 항목들을 완벽하게
가지런히 맞출 수 있고, 부동 소수점 산술에 따라 달라지는 값이 어떤 상자의 치수에도 들어가지 않는다.

@<노드 |r|의 글루를...@>=
n = spanCount(r); t = width(s); w = t; u = holdHead
for n > minQuarterword {
	n--
	@<목록 |u|에 tabskip 글루와 빈 상자를 덧붙이고 |s|와 |t|를 갱신한다@>
}
if mode == -vmode {
	@<미정 노드 |r|을 너비 |w|인 |hlistNode|로 바꾼다@>
} else {
	@<미정 노드 |r|을 높이 |w|인 |vlistNode|로 바꾼다@>
}
setShiftAmount(r, 0)
if u != holdHead { // 걸친 노드들 몫의 빈 상자를 덧붙인다
	setLink(u, link(r)); setLink(r, link(holdHead)); r = u
}

@ 견본 노드들을 지나가며 |s|와 |t|를 고친다. 값 |t|는 걸친 열들과 그 사이 tabskip의 실제 너비를 더한 값이다.

@<목록 |u|에 tabskip 글루와...@>=
s = link(s); v = gluePtr(s); setLink(u, newGlue(v)); u = link(u)
setSubtype(u, tabSkipCode+1); t += width(v)
if glueSign(p) == stretching {
	if stretchOrder(v) == glueOrder(p) {
		t += round(float(glueSet(p))*float64(stretch(v)))
	}
@^real multiplication@>
} else if glueSign(p) == shrinking {
	if shrinkOrder(v) == glueOrder(p) {
		t -= round(float(glueSet(p))*float64(shrink(v)))
	}
}
s = link(s); setLink(u, newNullBox()); u = link(u); t += width(s)
if mode == -vmode {
	setWidth(u, width(s))
} else {
	setType(u, vlistNode); setHeight(u, width(s))
}

@ 미정 노드를 가로 상자로 바꾼다. 글루는 너비가 |t|인 것처럼 정한다.

@<미정 노드 |r|을 너비 |w|인...@>=
setHeight(r, height(q)); setDepth(r, depth(q))
if t == width(r) {
	setGlueSign(r, normal); setGlueOrder(r, normal)
	setGlueSet(r, 0.0)
} else if t > width(r) {
	setGlueSign(r, stretching)
	if glueStretch(r) == 0 {
		setGlueSet(r, 0.0)
	} else {
		setGlueSet(r, unfloat(float64(t-width(r))/float64(glueStretch(r))))
	}
@^real division@>
} else {
	setGlueOrder(r, glueSign(r)); setGlueSign(r, shrinking)
	if glueShrink(r) == 0 {
		setGlueSet(r, 0.0)
	} else if glueOrder(r) == normal && width(r)-t > glueShrink(r) {
		setGlueSet(r, 1.0)
	} else {
		setGlueSet(r, unfloat(float64(width(r)-t)/float64(glueShrink(r))))
	}
}
setWidth(r, w); setType(r, hlistNode)

@ 미정 노드를 세로 상자로 바꾼다. 글루는 높이가 |t|인 것처럼 정한다.

@<미정 노드 |r|을 높이 |w|인...@>=
setWidth(r, width(q))
if t == height(r) {
	setGlueSign(r, normal); setGlueOrder(r, normal)
	setGlueSet(r, 0.0)
} else if t > height(r) {
	setGlueSign(r, stretching)
	if glueStretch(r) == 0 {
		setGlueSet(r, 0.0)
	} else {
		setGlueSet(r, unfloat(float64(t-height(r))/float64(glueStretch(r))))
	}
@^real division@>
} else {
	setGlueOrder(r, glueSign(r)); setGlueSign(r, shrinking)
	if glueShrink(r) == 0 {
		setGlueSet(r, 0.0)
	} else if glueOrder(r) == normal && height(r)-t > glueShrink(r) {
		setGlueSet(r, 1.0)
	} else {
		setGlueSet(r, unfloat(float64(height(r)-t)/float64(glueShrink(r))))
	}
}
setHeight(r, w); setType(r, vlistNode)

@ 이제 |head|에서 시작해 |tail|에서 끝나는 목록에 완성된 정렬이 있다. 이것을 바깥 목록에 합친다. (바깥 모드가 따로 세운 수식을
위한 |mmode|라면 수식 앞뒤에 글루를 넣어야 한다. 프로그램의 그 부분은 그런 연산에 더 익숙해질 때까지 미루어 둔다.)

제한된 가로 모드에서는 |aux|의 |clang| 부분이 정해져 있지 않지만, 그것을 통째로 베껴 두었다가 되돌려도 해가 없다.

@<현재 목록을 그 환경에...@>=
auxSave := aux // |aux|를 잠시 담아 둔다
p = link(head); q = tail; popNest()
if mode == mmode {
	@<따로 세운 수식 안의 정렬을 마무리한다@>
} else {
	aux = auxSave; setLink(tail, p)
	if p != null {
		tail = q
	}
	if mode == vmode {
		buildPage()
	}
}

@* 문단을 줄로 나누기.
이제 아마도 \TeX에서 가장 흥미로운 알고리즘에 이르렀다. 문단의 줄마다 ``가장 좋은'' 나눔점을 고르는 방법이다. \TeX의 줄 나누기
알고리즘은 주어진 가로 목록을 받아서, 현재 세로 목록에 덧붙일 상자들의 나열로 바꾼다. 이 일을 하는 동안 \TeX의 다른 곳에서는
쓰지 않는 세 종류의 레코드로 특별한 자료 구조를 만든다. 그런 노드는 문단을 처리하는 동안만 있다가 사라진다. 그래서 \TeX의 다른
부분은 줄 나누기를 어떻게 하는지 전혀 알 필요가 없다.

여기서 쓰는 방법은 마이클~F. 플래스(Michael F. Plass)와 저자가 1977년에 고안한 접근법을 바탕으로, 1980년에 같은 두 사람이
@^Plass, Michael Frederick@>
@^Knuth, Donald Ervin@>
일반화하고 다듬은 것이다. 자세한 논의는 {\sl Software---Practice and Experience \bf11} (1981), 1119--1184에 있다. 그 논문은 줄
나누기 문제를 비순환 그물에서 최단 경로를 찾는 문제의 특수한 경우로 볼 수 있음을 보였다. 거기에는 보기도 많고, 인쇄공들이 오랜
세월 해 온 줄 나누기의 역사도 실려 있다. 지금의 구현은 1980년의 알고리즘에 새 생각 두 가지를 더했다. 비활성 노드를 활성 노드보다
작은 레코드로 나타내어 메모리를 크게 아꼈고, 문단의 처음부터 현재 지점까지의 전체 거리를 기록하는 대신 ``델타 거리''를 써서
산술 넘침을 피했다.

@ \seclabel{demerits-formula}자세한 데로 들어가기 전에 큰 그림부터 보자. 문단의 합법적인 나눔점들을 차례로 늘어놓고, 나눔점
$a$에서 나눔점 $b$까지를 한 줄로 만들 수 있으면, 곧 그 줄의 나쁨이 문턱값을 넘지 않으면, $a$에서
$b$로 화살표를 긋는다. 그 화살표에는 그 줄의 {\sl 감점}(demerits)을 무게로 준다. 감점은 줄의
나쁨~$b$와 나눔점의 벌점~$p$와 \.{\\linepenalty}의 값~$\ell$로부터
$$d=\cases{(\ell+b)^2+p^2,&$0\le p<10000$\cr
(\ell+b)^2-p^2,&$-10000<p<0$\cr
(\ell+b)^2,&$p\le-10000$\cr}$$
로 계산하고, 하이픈으로 끝나는 줄이 잇달아 나오면 \.{\\doublehyphendemerits}를, 끝에서 둘째 줄이
하이픈으로 끝나면 \.{\\finalhyphendemerits}를, 맞음새 분류가 둘 이상 차이 나는 줄이 이웃하면
\.{\\adjdemerits}를 더한다. 그러면 가장 좋은 줄 나눔은 문단의 처음에서 끝까지 가는 경로 가운데
감점의 합이 가장 작은 것, 곧 최단 경로다.
@^demerits@>

화살표는 언제나 앞에서 뒤로만 가므로 이 그물에는 순환이 없다. 그러므로 나눔점을 왼쪽부터 한 번만
훑으면서 각 나눔점에 이르는 가장 좋은 경로를 차례로 정하면 된다. 나눔점~$b$에 이르는 가장 좋은
경로를 정할 때 살펴야 할 것은 $b$로 화살표를 그을 수 있는 앞쪽 나눔점들뿐인데, 그것들이 바로 아래에서
말하는 {\sl 활성 노드}다. 훑는 위치가 어떤 활성 노드에서 너무 멀어져서 그 노드에서 시작하는 줄을
아무리 줄여도 모자라게 되면, 그 노드는 앞으로도 쓸모가 없으므로 비활성화한다. 그래서 활성 목록은
늘 짧고, 알고리즘 전체는 문단의 길이에 거의 비례하는 시간에 끝난다. 끝에 이르면 가장 좋은 경로를
거꾸로 따라가며 실제로 줄을 나눈다.

다음 그림은 나눔점이 아홉 개인 가상의 문단이다. 굵은 경로 $0\to3\to5\to8$이 가장 좋은 나눔이라고
하자. 나눔점~1에서는 어떤 줄도 끝날 수 없으므로 화살표가 하나도 없다. 훑는 위치가 나눔점~6에
이르렀을 때, 나눔점 2와 3에서 시작하는 줄은 6 너머까지 갈 수 없으므로 이미 비활성이고, 회색으로
칠한 4, 5, 6만 활성이다.
$$\mplibcode
beginfig(7);
save u, bp; numeric u; u := 46pt; pair bp[];
for i = 0 upto 8: bp[i] := (i*u, 0); endfor
draw bp[0]--bp[8] withcolor .6white;
def arc(expr a, b, thick) =
  pickup pencircle scaled (if thick: 1.6pt else: .4pt fi);
  drawarrow (bp[a]{dir 60} .. {dir -60}bp[b])
    cutbefore (fullcircle scaled 9pt shifted bp[a]) cutafter (fullcircle scaled 9pt shifted bp[b]);
  pickup defaultpen;
enddef;
arc(0,2,false); arc(2,4,false); arc(2,5,false); arc(3,6,false);
arc(4,6,false); arc(4,7,false); arc(6,8,false); arc(5,7,false); arc(7,8,false);
arc(0,3,true); arc(3,5,true); arc(5,8,true);
draw (6u+0.5u, -12pt)--(6u+0.5u, 70pt) dashed evenly;
label.top(btex \ninepoint 훑는 위치 etex, (6.5u, 70pt));
for i = 0 upto 8:
  if (i>=4) and (i<=6): fill fullcircle scaled 9pt shifted bp[i] withcolor .7white; fi
  draw fullcircle scaled 9pt shifted bp[i];
  label.bot(textext("\ninepoint " & decimal i), bp[i] - (0,4pt));
endfor
label.lft(btex \ninepoint 처음 etex, bp[0] - (6pt,0));
label.rt(btex \ninepoint 끝 etex, bp[8] + (6pt,0));
endfig;
\endmplibcode$$

@ 프로시저 |lineBreak|는 가로 모드에서만 불러야 한다. 이 프로시저는 가로 모드를 떠나서, 바깥의 세로 모드(또는 내부 세로 모드)의
현재 세로 목록에 결과를 놓는다. 드러난 매개변수는 |finalWidowPenalty| 하나인데, 문단의 마지막 줄 앞에 넣을 추가 벌점의 양이다.
보통은 \.{\\widowpenalty}이고, 문단 뒤에 따로 세운 수식이 오면 \.{\\displaywidowpenalty}다.

숨은 매개변수도 여럿 있다. 나눌 가로 목록은 |link(head)|에서 시작하고, 비어 있지 않다. 바깥 의미 수준의 |prevGraf| 값은 매달린
들여쓰기나 \.{\\parshape}가 있을 때 이 문단이 줄 번호의 몇 번째부터 시작하는지 알려 준다. 이 값은 이 문단이 따로 세운 수식 뒤에
이어지는 것이 아니면 0이다. 포인터 |parShapePtr|와 하이픈 넣기에 쓸 여러 벌점 같은 나머지 숨은 매개변수는 |eqtb|에 있다.

프로시저 |lineBreak|가 일을 마치면 현재 세로 목록과 |prevGraf|의 값이 고쳐져 있다. 또 전역 변수 |justBox|가 |lineBreak|가 만든
마지막 상자를 가리키므로, 따로 세운 수식 앞에 |aboveDisplaySkip|을 쓸지 |aboveDisplayShortSkip|을 쓸지 정해야 할 때 이 줄의
너비를 알아낼 수 있다.

@<전역 변수@>=
var @!justBox pointer // 새 문단의 마지막 줄을 위한 |hlistNode|

@ 프로시저 |lineBreak|는 꽤 길므로---그 자체로 작은 세계다---\TeX의 더 단순한 프로시저들을 다룰 때보다 좀 더 조심스럽게
조금씩 쌓아 올려야 한다. 다음은 전체 윤곽이다. 준비하고, 가장 좋은 나눔점들을 찾고, 그 나눔점에서 실제로 줄을 나누어
세로 목록에 넣고, 쓰고 난 노드들을 치운다.

@<함수들@>=
@<|lineBreak|의 하위 프로시저들@>@;
func lineBreak(finalWidowPenalty int32) {
	@<줄 나누기의 지역 변수@>@;
	packBeginLine = modeLine // 넘치거나 덜 찬 상자 메시지를 위한 것이다
	@<줄 나누기를 시작할 준비를 한다@>
	@<최적의 나눔점들을 찾는다@>
	@<고른 나눔점들에서 문단을 나누어 줄을 맞추고 세로 목록에 덧붙인다@>
	@<나눔 노드들을 없애 메모리를 청소한다@>
	packBeginLine = 0
}

@ 첫 할 일은 목록을 |head|에서 |tempHead|로 옮기고 바깥 의미 수준으로 들어가는 것이다. 또 문단 끝에 \.{\\parfillskip} 글루를
덧붙이는데, 끝에 공백(이나 다른 글루 노드)이 있었으면 그것을 없앤다. 빈 줄이나 `\.{\$\$}' 앞에는 대개 공백이 있기 때문이다. 글루
|parFillSkip| 앞에는 무한 벌점을 두므로, 이 글루에서는 결코 나누지 않는다. 그래서 마지막 줄은 \.{\\parfillskip}이 남는 공간을
채운다.

이 코드는 |glueNode|와 |penaltyNode|가 같은 수의 |mem|~낱말을 차지한다고 가정한다.
@^data structure assumptions@>

@<줄 나누기를 시작할...@>=
setLink(tempHead, link(head))
if isCharNode(tail) {
	tailAppend(newPenalty(infPenalty))
} else if typ(tail) != glueNode {
	tailAppend(newPenalty(infPenalty))
} else {
	setType(tail, penaltyNode); deleteGlueRef(gluePtr(tail))
	flushNodeList(leaderPtr(tail)); setPenalty(tail, infPenalty)
}
setLink(tail, newParamGlue(parFillSkipCode))
initCurLang = prevGraf % 0o200000
initLHyf = prevGraf / 0o20000000
initRHyf = (prevGraf / 0o200000) % 0o100
popNest()

@ 최적의 줄 나눔을 찾을 때 \TeX은 {\sl 실행 가능한}(feasible) 나눔마다 ``나눔 노드''를 만든다. 실행 가능하다는 것은 어떤 줄도 주어진
허용치보다 더 늘이지 않고 그 자리에서 줄을 끝낼 길이 있다는 뜻이다. 나눔 노드는 세 가지로 특징지어진다. 나눔의 위치(|glueNode|,
|mathNode|, |penaltyNode|, |discNode|를 가리키는 포인터), 이 나눔점 뒤에 올 줄의 번호, 그리고 방금 끝난 줄의 맞음새 분류, 곧
|tightFit|, |decentFit|, |looseFit|, |veryLooseFit|이다. 맞음새 분류는 이웃한 줄의 간격이 너무 다르지 않게 하는 데 쓴다.

@<정의@>=
const (
	@!tightFit = 3 // 줄일 수 있는 양의 0.5에서 1.0만큼 줄이는 줄의 맞음새 분류
	@!looseFit = 1 // 늘일 수 있는 양의 0.5에서 1.0만큼 늘이는 줄의 맞음새 분류
	@!veryLooseFit = 0 // 늘일 수 있는 양보다 더 늘이는 줄의 맞음새 분류
	@!decentFit = 2 // 그 밖의 모든 줄의 맞음새 분류
)

@ 이 알고리즘은 본질적으로 위치, 줄 번호, 맞음새의 실행 가능한 조합마다 그 조합에 이르는 가장 좋은 길을 정한다. 그래서 ``넷째 줄이
이러저러한 곳에서 끝나는 빡빡한 줄이 되도록 문단의 앞부분을 나누는 가장 좋은 방법은 무엇인가?'' 같은 물음에 답한다. 그러나 어떤
지점부터는 모든 줄의 길이가 같다는 사실 덕분에, looseness 매개변수가 0일 때는 넉넉히 큰 줄 번호들을 모두 같은 것으로 볼 수 있다.
덕분에 알고리즘은 공간과 시간을 아낄 수 있다.

고려해야 할 실행 가능한 나눔점마다 |mem|에 ``활성 노드''와 ``수동 노드''를 만든다. 활성 노드는 세 낱말 길이고 수동 노드는 두 낱말
길이다. 활성 노드는 문단에서 지금 살피는 곳 가까이의 나눔점에만 필요하므로, 만들어진 뒤 비교적 짧은 시간 안에 재활용된다. 수동
노드는 마지막에 가장 좋은 경로를 거꾸로 따라가는 데 필요하므로 문단이 끝날 때까지 남는다.

@ 나눔점의 활성 노드에는 필드가 여섯 있다.

\yskip\hang|link|는 활성 노드 목록의 다음 노드를 가리킨다. 마지막 활성 노드는 |link=lastActive|다.

\yskip\hang|breakNode|는 이 나눔점에 딸린 수동 노드를 가리킨다.

\yskip\hang|lineNumber|는 이 나눔점 뒤에 오는 줄의 번호다.

\yskip\hang|fitness|는 이 나눔점에서 끝나는 줄의 맞음새 분류다.

\yskip\hang\ID{type}은 이 나눔점이 |discNode|인지에 따라 |hyphenated|나 |unhyphenated|다.

\yskip\hang|totalDemerits|는 문단의 처음부터 이 나눔점까지 이르는 모든 줄의 감점(demerit)을 더한 값의 최솟값이다.

\yskip\noindent
포인터 |link(active)|는 지금 활성인 모든 노드의 연결 목록에서 첫 활성 노드를 가리킨다. 이 목록은 |lineNumber| 차례로 놓여 있다.
다만 |lineNumber>easyLine|인 노드들끼리는 아무 차례로나 놓일 수 있다.

@<정의@>=
const @!activeNodeSize = 3 // 활성 노드의 낱말 수

func fitness(p pointer) quarterword { return subtype(p) } // 이 나눔의 마지막 줄의 |veryLooseFit..tightFit|
func setFitness(p pointer, v quarterword) { setSubtype(p, v) }
func breakNode(p pointer) pointer { return rlink(p) } // 대응하는 수동 노드를 가리키는 포인터
func setBreakNode(p pointer, v pointer) { setRlink(p, v) }
func lineNumber(p pointer) halfword { return llink(p) } // 이 나눔점에서 시작하는 줄
func setLineNumber(p pointer, v halfword) { setLlink(p, v) }
func totalDemerits(p pointer) int32 { return mem[p+2].sc } // \TeX이 최소로 만드는 양
func setTotalDemerits(p pointer, v int32) { mem[p+2].sc = v }

const (
	@!unhyphenated = 0 // 보통 활성 나눔 노드의 \ID{type}
	@!hyphenated = 1 // |discNode|에서 나누는 활성 노드의 \ID{type}
	@!lastActive = active // 활성 목록은 시작한 곳에서 끝난다
)

@ 목록의 끝 표시 |lastActive|에는 가장 큰 줄 번호를 넣어 두어, 활성 목록을 훑다가 반드시 멈추게 한다.
@<특별한 목록 머리와...@>=
setType(lastActive, hyphenated); setLineNumber(lastActive, maxHalfword)
setSubtype(lastActive, 0) // 알고리즘은 |subtype|을 결코 살피지 않는다

@ 나눔점의 수동 노드에는 필드가 넷뿐이다.

\yskip\hang|link|는 이것 바로 앞에 만든 수동 노드가 있으면 그것을 가리키고, 없으면 |null|이다.

\yskip\hang|curBreak|는 나누고 있는 문단의 가로 목록에서 이 나눔점의 위치를 가리킨다.

\yskip\hang|prevBreak|는 이 나눔점에 이르는 최적 경로에서 바로 앞의 나눔점에 해당하는 수동 노드를 가리킨다.

\yskip\hang|serial|은 이 수동 노드가 이번 훑기에서 |n|번째로 만든 것이면 |n|이다. (이 필드는 줄 나누기 계산에 관한 자세한 통계를
찍을 때만 쓴다.)

\yskip\noindent
전역 변수 |passive|는 가장 최근에 만든 수동 노드를 가리킨다. 또 다른 전역 변수 |printedNode|는 줄 나누기 계산을 자세히 보여 줄 때
문단을 이어서 찍는 데 쓴다.

@<전역 변수@>=
const @!passiveNodeSize = 2 // 수동 노드의 낱말 수

func curBreak(p pointer) pointer { return rlink(p) } // 수동 노드에서 이 나눔점의 위치를 가리킨다
func setCurBreak(p pointer, v pointer) { setRlink(p, v) }
func prevBreak(p pointer) pointer { return llink(p) } // 이것 앞에 와야 할 수동 노드를 가리킨다
func setPrevBreak(p pointer, v pointer) { setLlink(p, v) }
func serial(p pointer) halfword { return info(p) } // 기호적 식별을 위한 일련번호
func setSerial(p pointer, v halfword) { setInfo(p, v) }

var @!passive pointer // 수동 목록의 가장 최근 노드
var @!printedNode pointer // 가장 최근에 찍은 노드
var @!passNumber halfword // 이번 훑기에서 할당한 수동 노드의 수

@ 활성 목록에는 알고리즘이 줄마다 나쁨을 계산하는 것을 돕는 ``델타'' 노드도 들어 있다. 델타 노드는 두 활성 노드 사이에만 나오고
\ID{type}${}={}$|deltaNode|다. 두 활성 노드 |p|와 |r| 사이에 델타 노드 |q|가 있어서 |link(p)=q|이고 |link(q)=r|이면, |q|는 가로
목록에서 나눔점 |p| 뒤에 시작하는 줄과 나눔점 |r| 뒤에 시작하는 줄의 길이 차이를 알려 준다. 다시 말해 |p| 뒤에 시작해서 현재
위치에서 끝나는 줄의 길이를 알면, |r| 뒤에 시작하는 줄의 길이는 노드~|q|의 양들을 더해서 얻는다. 델타 노드에는 눈금 수 여섯 개가
들어 있다. 글루의 늘어남은 무한의 차수마다 따로 기록해야 하기 때문이다. 자연 너비의 차이는 |mem[q+1].sc|에, pt, fil, fill, filll
단위의 늘어남 차이는 |mem[q+2 .. q+5].sc|에, 줄어듦 차이는 |mem[q+6].sc|에 있다. 델타 노드의 |subtype| 필드는 쓰지 않는다.

@<정의@>=
const (
	@!deltaNodeSize = 7 // 델타 노드의 낱말 수
	@!deltaNode = 2 // 델타 노드의 \ID{type} 필드
)

@ 알고리즘이 돌아가는 동안, 첫 활성 나눔점 뒤에서 시작해 가로 목록의 현재 위치까지 이르는 줄의 길이를 위해 델타 같은 레지스터
여섯 개 한 묶음을 둔다. 활성 목록을 훑을 때는 지금 보고 있는 활성 나눔점 뒤의 길이를 위해서도 비슷한 묶음을 하나 더 둔다. 셋째
묶음에는 빈 줄의 길이(곧 \.{\\leftskip}과 \.{\\rightskip}의 합)를 담고, 넷째 묶음은 새 델타 노드를 만드는 데 쓴다.

델타 노드를 지날 때는 $$\hbox{|curActiveWidth[k]=curActiveWidth[k]+mem[q+k].sc|,\qquad $1\le k\le6$}$$ 같은 연산을 한다. 이런 여섯 짝
연산은 여기저기 나오는데, 그때마다 |k|가 1부터 6까지 도는 |for| 루프로 쓰고 연산의 이름(이를테면 |copyToCurActive|)을 주석으로
붙여 둔다. 이런 배열들은 첨자 1부터 6까지를 쓰므로 길이를 7로 잡고 첨자 0은 쓰지 않는다.

@<전역 변수@>=
var @!activeWidth [7]scaled // 첫 활성 노드에서 |curP|까지의 거리
var @!curActiveWidth [7]scaled // 현재 활성 노드에서부터의 거리
var @!background [7]scaled // ``빈'' 줄의 길이
var @!breakWidth [7]scaled // 현재 나눔 뒤에 계산하고 있는 길이

@ 뒤따르는 프로그램이 덜 알쏭달쏭하도록 델타 노드의 원리를 더 정확하고 간결하게 말해 보자. 문단의 합법적인 나눔점~|p|마다,
나눔점~|p|에서 나눔점~|q|까지 한 줄에 든 내용의 길이가 어떤 고정된 $\gamma$에 대해 $\gamma+\beta(q)-\alpha(p)$가 되도록 두
양 $\alpha(p)$와 $\beta(p)$를 정의한다. 직관적으로 $\alpha(p)$와 $\beta(q)$는 문단의 처음부터 각각 |p|에서 나눈 ``뒤''의
지점까지, 그리고 |q|에서 나누기 ``앞''의 지점까지 내용의 전체 길이이고, $\gamma$는 빈 줄의 너비, 곧 \.{\\leftskip}과
\.{\\rightskip}이 보태는 길이다.

이를테면 문단이 전부 상자와 글루 건너뛰기가 번갈아 놓인 것으로 이루어졌다고 하자. 상자의 너비를 $x_1\ldots x_n$, 건너뛰기의
너비를 $y_1\ldots y_n$이라 하면 문단은 $x_1y_1\ldots x_ny_n$으로 나타낼 수 있다. 그리고 $p_i$를 $y_i$에 있는 합법적인 나눔점이라고
하자. 그러면 $\alpha(p_i)=x_1+y_1+\cdots+x_i+y_i$이고 $\beta(p_i)=x_1+y_1+\cdots+x_i$다. 이것을 확인하려면, 이를테면
$p_2$에서 $p_5$까지 내용의 길이가 $\gamma+x_3+y_3+x_4+y_4+x_5=\gamma+\beta(p_5)-\alpha(p_2)$임에 주목하라.

양 $\alpha$, $\beta$, $\gamma$에는 자연 너비만이 아니라 글루의 늘일 수 있는 양과 줄일 수 있는 양도 들어 있다. 모든 |p|에
대해 $\alpha(p)$와 $\beta(p)$를 계산한다면 다중 정밀도 산술이 필요할 것이고, 그 다중 정밀도 수들을 활성 노드에 담아 두어야
할 것이다. \TeX은 상대적인 차이, 곧 ``델타''만으로 일해서 이 문제를 피한다. 이를테면 활성 목록에 $a_1\,\delta_1\,a_2\,
\delta_2\,a_3$이 들어 있다고 하자. 여기서 |a|들은 활성 나눔점이고 $\delta$들은 델타 노드다. 그러면 $\delta_1=\alpha(a_1)-
\alpha(a_2)$이고 $\delta_2=\alpha(a_2)-\alpha(a_3)$이다. 줄 나누기 알고리즘이 지금 어떤 다른 나눔점 |p|에 있다면 배열
|activeWidth|에는 $\gamma+\beta(p)-\alpha(a_1)$ 값이 들어 있다. 활성 노드 목록을 훑으며 이를테면 $a_2$에서 |p|까지 가는
시험 줄을 고려하고 있다면, 배열 |curActiveWidth|에는 $\gamma+\beta(p)-\alpha(a_2)$ 값이 들어 있다. 그러므로 $a_2$에서
$a_3$으로 옮겨 갈 때는 |curActiveWidth|에 $\alpha(a_2)-\alpha(a_3)$을 더하면 된다. 이것이 바로 활성 목록에서 $a_2$와
$a_3$ 사이에 있는 $\delta_2$다. 배열 |background|에는 $\gamma$가 들어 있다. 배열 |breakWidth|는 활성 목록을 갱신할 때 새
델타 노드의 값을 계산하는 데 쓰인다.

활성 목록과 수동 노드들이 어떻게 얽혀 있는지 그림으로 보이면 다음과 같다. 위 줄은 |link|로 이어진 활성
목록이고, 활성 노드마다 |breakNode|가 아래 줄의 수동 노드를 가리킨다. 수동 노드들은 |prevBreak|로
저마다 최적 경로의 바로 앞 나눔점을 가리키므로, 문단이 끝났을 때 가장 좋은 마지막 활성 노드에서 이
사슬을 거꾸로 따라가면 가장 좋은 나눔점들이 모두 나온다. 그림에서는 $a_3$이 가장 좋다고 보고 그
사슬 $q_6\to q_5\to q_3\to q_1$을 굵게 그렸다. 활성 노드는 훑기가 진행되면서 곧
사라지지만, 수동 노드는 문단이 끝날 때까지 남아 있어야 한다.
$$\mplibcode
beginfig(8);
save a, d, pp, hd, la; picture a[], d[], pp[], hd, la;
hd := boxed(btex \ninepoint \ID{active} etex, (70pt,0));
a1 := boxed(btex \ninepoint $a_1$ etex, (150pt,0));
d1 := boxed(btex \ninepoint $\delta_1$ etex, (200pt,0));
a2 := boxed(btex \ninepoint $a_2$ etex, (250pt,0));
d2 := boxed(btex \ninepoint $\delta_2$ etex, (300pt,0));
a3 := boxed(btex \ninepoint $a_3$ etex, (350pt,0));
la := boxed(btex \ninepoint \ID{lastActive} etex, (420pt,0));
drawarrow eastof(hd)--westof(a1); drawarrow eastof(a1)--westof(d1); drawarrow eastof(d1)--westof(a2);
drawarrow eastof(a2)--westof(d2); drawarrow eastof(d2)--westof(a3); drawarrow eastof(a3)--westof(la);
label.top(btex \eightpoint \ID{link} etex, 1/2[eastof(hd),westof(a1)]);
pp1 := boxed(btex \ninepoint $q_1$ etex, (0,-60pt));
pp2 := boxed(btex \ninepoint $q_2$ etex, (50pt,-60pt));
pp3 := boxed(btex \ninepoint $q_3$ etex, (100pt,-60pt));
pp4 := boxed(btex \ninepoint $q_4$ etex, (150pt,-60pt));
pp5 := boxed(btex \ninepoint $q_5$ etex, (250pt,-60pt));
pp6 := boxed(btex \ninepoint $q_6$ etex, (350pt,-60pt));
drawarrow southof(a1) -- northof(pp4);
drawarrow southof(a2) -- northof(pp5);
drawarrow southof(a3) -- northof(pp6);
label.rt(btex \eightpoint \ID{breakNode} etex, 1/2[southof(a3),northof(pp6)]);
def under(expr i, j) = (southof(pp[i]){dir 240} .. {dir 120}southof(pp[j])) enddef;
pickup pencircle scaled 1.2pt;
drawarrow westof(pp6) -- eastof(pp5);
drawarrow under(5,3); drawarrow under(3,1);
pickup defaultpen;
drawarrow (northof(pp4){dir 120} .. {dir 240}northof(pp2));
drawarrow (northof(pp2){dir 120} .. {dir 240}northof(pp1));
label.bot(btex \eightpoint \ID{prevBreak} etex, (175pt, -95pt));
endfig;
\endmplibcode$$

@ 문단으로 만들 가로 목록의 글루 노드에는 ``무한'' 줄어듦이 없어야 한다. 무한 줄어듦이 있으면 어떤 줄이든 얼마든지 줄일 수 있어서
나쁨이 뜻을 잃기 때문이다. 그래서 알고리즘은 늘이기를 위한 레지스터 넷과 줄이기를 위한 레지스터 하나만 둔다. 사용자가 무한 줄어듦을
넣으면 줄어듦을 유한하게 바꾸고 오류 메시지를 낸다. 불 변수 |noShrinkErrorYet|은 이 오류 메시지가 문단마다 한 번보다 많이 나오지
않게 한다.

줄어듦을 검사하는 일, 곧 |g|의 줄어듦의 차수가 |normal|이 아니고 줄어듦이 0이 아니면 |g|를 |finiteShrink(g)|로 바꾸는 일은, 그 대상이
\.{\\leftskip}과 \.{\\rightskip}의 |eqtb| 항목이거나 |gluePtr(curP)|여서 바꾸어 넣을 곳이 저마다 다르므로, 쓰는 자리마다 펼쳐 쓴다.

@<전역 변수@>=
var @!noShrinkErrorYet bool // 무한 줄어듦에 대해 불평했는가?

@ 함수 |finiteShrink|는 무한 줄어듦을 유한한 줄어듦으로 바꾼 새 글루 명세를 돌려준다. 처음 한 번만 오류를 알린다.
@<|lineBreak|의 하위...@>=
func finiteShrink(p pointer) pointer { // 무한 줄어듦에서 회복한다
	if noShrinkErrorYet {
		noShrinkErrorYet = false
		if stat && tracingParagraphs() > 0 {
			endDiagnostic(true)
		}
		printErr("Infinite glue shrinkage found in a paragraph")
@.Infinite glue shrinkage...@>
		help5("The paragraph just ended includes some glue that has",
			"infinite shrinkability, e.g., `\\hskip 0pt minus 1fil'.",
			"Such glue doesn't belong there---it allows a paragraph",
			"of any length to fit on one line. But it's safe to proceed,",
			"since the offensive shrinkability has been made finite.")
		reportError()
		if stat && tracingParagraphs() > 0 {
			beginDiagnostic()
		}
	}
	q := newSpec(p) // 새 글루 명세
	setShrinkOrder(q, normal)
	deleteGlueRef(p); return q
}

@ 매개변수 \.{\\leftskip}과 \.{\\rightskip}의 줄어듦을 검사하고, 빈 줄의 길이 |background|를 두 글루의 합으로 정한다.
@<줄 나누기를 시작할...@>=
noShrinkErrorYet = true
if shrinkOrder(leftSkip()) != normal && shrink(leftSkip()) != 0 {
	setEquiv(glueBase+leftSkipCode, finiteShrink(leftSkip()))
}
if shrinkOrder(rightSkip()) != normal && shrink(rightSkip()) != 0 {
	setEquiv(glueBase+rightSkipCode, finiteShrink(rightSkip()))
}
q = leftSkip(); r = rightSkip(); background[1] = width(q) + width(r)
background[2] = 0; background[3] = 0; background[4] = 0; background[5] = 0
background[2+stretchOrder(q)] = stretch(q)
background[2+stretchOrder(r)] = background[2+stretchOrder(r)] + stretch(r)
background[6] = shrink(q) + shrink(r)

@ 나눔점을 찾는 동안 포인터 변수 |curP|가 주어진 가로 목록을 훑는다. 이 변수는 |lineBreak|와 그 하위 프로시저 |tryBreak|가 함께 쓰므로
전역 변수다.

또 다른 전역 변수 |threshold|는 줄마다 실행 가능한지 정하는 데 쓴다. 나쁨이 |threshold|를 넘는 줄을 만들지 않고 이를 수 있으면 그
나눔점은 실행 가능하다. (나쁨은 벌점을 더하기 전에 |threshold|와 견주므로, 벌점이 10000 이상이면 나눌 수 없다는 것 말고는 벌점
값이 나눔점의 실행 가능성에 영향을 주지 않는다.) 문턱값 |threshold|가 10000 이상이면 모든 합법적인 나눔이 실행 가능한 것으로
여겨진다. 앞에서 정한 함수 |badness|는 결코 10000보다 큰 값을 돌려주지 않기 때문이다.

실행 가능한 나눔점 집합을 적어도 하나 찾으려고 문단을 세 번까지 훑을 수 있다. 첫째 훑기에서는 |threshold=pretolerance|이고
|secondPass=finalPass=false|다. 하이픈을 넣지 않고도 잘 나뉘는 문단이 많으므로, 이 훑기는 하이픈 넣기를 하지 않아 빠르다. 이
훑기가 실행 가능한 해를 찾지 못하면 |threshold|를 |tolerance|로 하고, |secondPass|를 |true|로 하고, 될 수 있는 대로 많은 낱말에
하이픈을 넣어 본다. 그것도 실패하면 바탕의 늘일 수 있는 양에 |emergencyStretch|를 더하고 |finalPass=true|로 한다.

@<전역 변수@>=
var @!curP pointer // 지금 고려하고 있는 나눔점
var @!secondPass bool // 이것이 이 문단을 나누는 둘째 시도인가?
var @!finalPass bool // 이것이 이 문단을 나누는 마지막 시도인가?
var @!threshold int32 // 실행 가능한 줄의 최대 나쁨

@ 줄 나누기 프로시저의 심장은 `|tryBreak|'다. 이 서브루틴은 활성 목록을 훑으며, 각 활성 노드에서 |curP|까지 어떤 줄을 만들 수 있는지
보아서 현재 나눔점 |curP|가 실행 가능한지 검사한다. 실행 가능한 나눔이 있으면 새 나눔 노드를 만든다. 그리고 |curP|가 어떤 활성
노드에서 너무 멀어졌으면 그 노드를 비활성화한다.

서브루틴 |tryBreak|의 매개변수 |pi|는 |curP|에서 나누는 데 매기는 벌점이다. 나눔이 강제되면 |pi=ejectPenalty|이고, 나눔이 허락되지
않으면 |pi=infPenalty|다.

다른 매개변수 |breakType|은 현재 나눔이 |discNode|에서 일어나는지에 따라 |hyphenated|나 |unhyphenated|다. 문단의 끝도
`|hyphenated|'로 여기는데, 이 경우는 조건 |curP=null|로 가릴 수 있다.

이 함수에서는 레이블 |exit| 뒤에 통계 코드가 있으므로, 끝낼 때 |return| 대신 |goto exit|를 쓴다(\secref{labels}).

@<|lineBreak|의 하위...@>=
func tryBreak(pi int32, breakType smallNumber) {
	var r pointer // 활성 목록을 훑는다
	var prevR pointer // |r|보다 한 걸음 뒤에 머문다
	var oldL halfword // 현재 줄 동치류의 최대 줄 번호
	var noBreakYet bool // |curP|에서 실행 가능한 나눔을 찾았는가?
	@<|tryBreak|의 다른 지역 변수@>@;
	@<|pi|가 알맞은 범위에 있게 한다@>
	noBreakYet = true; prevR = active; oldL = 0
	for k := int32(1); k <= 6; k++ {
		curActiveWidth[k] = activeWidth[k] // |copyToCurActive|
	}
	for {
	again:
		r = link(prevR)
		@<노드 |r|이 델타 노드이면 너비를 갱신하고 |goto again|@>
		@<줄 번호 부류가 끝났으면 새 활성 노드들을 만든다@>
		@<|r|에서 |curP|까지의 줄의 감점을 고려한다@>
	}
exit:
	if stat {
		@<|printedNode|의 값을 갱신한다@>
	}
}

@ @<|tryBreak|의 다른 지역 변수@>=
var prevPrevR pointer // |typ(prevR)=deltaNode|이면 |prevR|보다 한 걸음 뒤
var s pointer // |curP| 앞쪽의 노드들을 훑는다
var q pointer // 새로 만드는 노드를 가리킨다
var v pointer // 글루 명세나 |curP| 앞쪽의 노드를 가리킨다
var t int32 // |curP|가 선택적 나눔 노드일 때의 노드 개수
var f internalFontNumber // 문자 너비 계산에 쓴다
var l halfword // 현재 활성 노드의 줄 번호
var nodeRStaysActive bool // 노드 |r|이 활성 목록에 남아야 하는가?
var lineWidth scaled // 현재 줄은 이 너비로 맞추어진다
var fitClass int32 // 시험 줄의 가능한 맞음새 분류, |veryLooseFit..tightFit|
var b halfword // 시험 줄의 나쁨
var d int32 // 시험 줄의 감점
var artificialDemerits bool // |d|를 억지로 0으로 했는가?
var saveLink pointer // |link(curP)|의 값을 잠시 담아 둔다
var shortfall scaled // 나쁨 계산에 쓴다

@ 무한 벌점이면 여기서 나눌 수 없으므로 곧바로 끝내고, 음의 무한 벌점이면 강제 나눔으로 다룬다.
@<|pi|가 알맞은 범위에...@>=
if abs(pi) >= infPenalty {
	if pi > 0 {
		goto exit // 이 나눔점은 무한 벌점으로 막혀 있다
	}
	pi = ejectPenalty // 이 나눔점은 강제된다
}

@ 델타 노드를 지나가며 |curActiveWidth|를 고친다. 다음 코드는 |typ(lastActive)!=deltaNode|라는 사실을 이용한다.

@<노드 |r|이 델타 노드이면...@>=
@^inner loop@>
if typ(r) == deltaNode {
	for k := int32(1); k <= 6; k++ {
		curActiveWidth[k] += mem[r+k].sc // |updateWidth|
	}
	prevPrevR = prevR; prevR = r; goto again
}

@ 같은 줄 번호 부류 안에서 |curP|에서 줄을 끝내는 여러 방법을 견주는 동안, 맞음새 분류마다 지금까지 알려진 가장 좋은 전체 감점을
배열에 기록해 둔다. 이를테면 |minimalDemerits[tightFit]|에는 |tightFit| 줄로 |curP|에서 끝나는 실행 가능한 줄 나눔들의 가장 적은
전체 감점이 들어 있다. 또 |bestPlace[tightFit]|는 그 최적을 이루는, |curP| 앞 나눔의 수동 노드를 가리키고, |bestPlLine[tightFit]|은
|bestPlace[tightFit]|에 대응하는 활성 노드의 |lineNumber| 필드다. 실행 가능한 나눔 나열이 알려지지 않았을 때는 |minimalDemerits|
항목이 $2^{30}-1$인 |awfulBad|다. 또 다른 변수 |minimumDemerits|에는 배열 |minimalDemerits|의 가장 작은 값이 들어 있다.

@<전역 변수@>=
const @!awfulBad = 0o7777777777 // 십억이 넘는 감점

var @!minimalDemerits [tightFit + 1]int32 // 맞음새별로 현재 줄 부류와 위치에 대해 알려진 가장 좋은 전체 감점
var @!minimumDemerits int32 // 현재 줄 부류와 위치에 대해 알려진 가장 좋은 전체 감점
var @!bestPlace [tightFit + 1]pointer // |minimalDemerits|를 이루는 방법
var @!bestPlLine [tightFit + 1]halfword // 대응하는 줄 번호

@ 처음에는 실행 가능한 나눔이 하나도 알려져 있지 않다.
@<줄 나누기를 시작할...@>=
minimumDemerits = awfulBad
minimalDemerits[tightFit] = awfulBad
minimalDemerits[decentFit] = awfulBad
minimalDemerits[looseFit] = awfulBad
minimalDemerits[veryLooseFit] = awfulBad

@ 다음 코드의 앞부분은 \TeX의 안쪽 루프의 일부이므로 시간을 조금도 낭비하고 싶지 않다. 현재 활성 노드, 곧 노드 |r|에는 다음에
고려할 줄 번호가 들어 있다. 목록의 끝에서는 |r=lastActive|이고 |lineNumber(lastActive)>oldL|이 되도록 자료 구조를 마련해 두었다.
@^inner loop@>

줄 번호 부류가 끝났으면 그 부류에서 찾은 가장 좋은 실행 가능한 나눔들을 위해 새 활성 노드를 만든다. 그런 다음 |r=lastActive|이면
|goto exit|하고, 그렇지 않으면 새 |lineWidth|를 계산한다.

@<줄 번호 부류가 끝났으면...@>=
l = lineNumber(r)
if l > oldL { // 이제 안쪽 루프를 벗어났다
	if minimumDemerits < awfulBad && (oldL != easyLine || r == lastActive) {
		@<방금 찾은 가장 좋은 실행 가능한 나눔들을 위해 새 활성 노드를 만든다@>
	}
	if r == lastActive {
		goto exit
	}
	@<새 줄 너비를 계산한다@>
}

@ 감점 |minimalDemerits|가 |minimumDemerits+abs(adjDemerits)|보다 큰 새 활성 노드는 만들 필요가 없다. 그런 활성 노드는 마지막 문단
나눔에서 결코 뽑히지 않을 것이기 때문이다. 맞음새가 맞지 않아 받는 벌인 \.{\\adjdemerits}를 더해도 가장 좋은 것을 이길 수 없다는
뜻이다. 이 관찰 덕분에 실행 가능한 나눔점 가운데 상당수를 더 고려하지 않아도 된다.

@<방금 찾은 가장 좋은...@>=
if noBreakYet {
	@<|breakWidth|의 값들을 계산한다@>
}
@<|curP|에서의 나눔을 준비하는 델타 노드를 넣는다@>
if abs(adjDemerits()) >= awfulBad-minimumDemerits {
	minimumDemerits = awfulBad - 1
} else {
	minimumDemerits += abs(adjDemerits())
}
for fitClass = veryLooseFit; fitClass <= tightFit; fitClass++ {
	if minimalDemerits[fitClass] <= minimumDemerits {
		@<|bestPlace[fitClass]|에서 |curP|까지 새 활성 노드를 넣는다@>
	}
	minimalDemerits[fitClass] = awfulBad
}
minimumDemerits = awfulBad
@<다음 활성 노드를 준비하는 델타 노드를 넣는다@>

@ 노드 |curP|에서의 나눔을 위해 새 활성 노드를 넣을 때, 이 새 노드가 활성 노드 |a| 바로 앞에 놓인다고 하자. 그러면 본질적으로
`$\delta\,|curP|\,\delta^\prime$'을 |a| 앞에 넣고 싶은 것이다. 여기서 앞의 표기로 $\delta=\alpha(a)-\alpha(|curP|)$이고
$\delta^\prime=\alpha(|curP|)-\alpha(a)$다. 배열 |curActiveWidth|에는 지금 $\gamma+\beta(|curP|)-\alpha(a)$가 들어 있다. 그러므로
$\delta$는 양 $\gamma+\beta(|curP|)-\alpha(|curP|)$에서 |curActiveWidth|를 빼서 얻을 수 있다. 뒤의 양은 ``|curP|에서 |curP|까지''
줄의 길이로 볼 수 있다. 이것을 |curP|에서의 |breakWidth|라고 부른다.

이 값 |breakWidth|는 대개 음수다. 바탕(대개 0)에서, 나눈 뒤에 사라지는 |curP| 다음 노드들의 너비를 뺀 것이기 때문이다. 이를테면
노드 |curP|가 글루 노드이면 이 글루의 너비를 바탕에서 빼고, 앞을 내다보며 뒤따르는 글루, 벌점, 커닝, 수식 노드를 모두 지나가면서
그 너비도 뺀다. 이것들은 줄의 처음에서 모두 버려지기 때문이다.

커닝 노드는 |explicit|이 아니면 줄 나눔에서 사라지지 않는다.

@<|breakWidth|의 값들을...@>=
noBreakYet = false
for k := int32(1); k <= 6; k++ {
	breakWidth[k] = background[k] // |setBreakWidthToBackground|
}
s = curP
if breakType > unhyphenated && curP != null {
	@<선택적 나눔의 |breakWidth| 값들을 계산한다@>
}
for s != null {
	if isCharNode(s) {
		goto done
	}
	switch typ(s) {
	case glueNode: @<|breakWidth|에서 글루를 뺀다@>
	case penaltyNode: // 아무것도 하지 않는다
	case mathNode: breakWidth[1] = breakWidth[1] - width(s)
	case kernNode:
		if subtype(s) != explicit {
			goto done
		}
		breakWidth[1] -= width(s)
	default: goto done
	}
	s = link(s)
}
done: ;

@ 글루의 너비와 늘어남과 줄어듦을 |breakWidth|에서 뺀다.
@<|breakWidth|에서 글루를...@>=
v = gluePtr(s); breakWidth[1] -= width(v)
breakWidth[2+stretchOrder(v)] = breakWidth[2+stretchOrder(v)] - stretch(v)
breakWidth[6] -= shrink(v)

@ 노드 |curP|가 선택적 나눔이면, 다른 계산들이 맞아떨어지도록 ``|curP|에서 |curP|까지'' 줄의 길이를 제대로 정의해야 한다. 노드 |curP|의
나눔 앞 텍스트의 길이가 $l_0$, 나눔 뒤 텍스트의 길이가 $l_1$, 대체 텍스트의 길이가 |l|이라고 하자. 또 |q|가 대체 텍스트 다음의
노드라고 하자. 그러면 |curP|에서 |q|까지 줄의 길이는 $\gamma+\beta(q)-\alpha(|curP|)$로 계산되는데, 여기서
$\beta(q)=\beta(|curP|)-l_0+l$이다. 실제 길이는 바탕에 $l_1$을 더한 것이어야 하므로, |curP|에서 |curP|까지의 길이는
$\gamma+l_0+l_1-l$이어야 한다. 선택적 나눔의 나눔 뒤 텍스트가 비어 있으면 나눔이 |q|를 버릴 수도 있다. 그런 드문 경우에는 |q|의
길이와, 선택적 나눔 뒤에 버려질 다른 노드들의 길이도 뺀다.

길이 $l_0$은 따로 계산할 필요가 없다. 프로시저 |lineBreak|가 |tryBreak|를 부르기 전에 그것을 전역 변수 |discWidth|에 넣어 두기
때문이다.

@<전역 변수@>=
var @!discWidth scaled // 나눔 앞에 있는 선택적 나눔 내용의 길이

@ 대체 텍스트의 너비를 빼고 나눔 뒤 텍스트의 너비를 더한다. 나눔 뒤 텍스트가 비어 있으면 그 뒤에 버려질 노드들도 본다.
@<선택적 나눔의 |breakWidth|...@>=
t = replaceCount(curP); v = curP; s = postBreak(curP)
for t > 0 {
	t--; v = link(v)
	@<|breakWidth|에서 노드 |v|의 너비를 뺀다@>
}
for s != null {
	@<|breakWidth|에 노드 |s|의 너비를 더한다@>
	s = link(s)
}
breakWidth[1] += discWidth
if postBreak(curP) == null {
	s = link(v) // 나눔 뒤에 버릴 수 있는 노드들이 있을 수 있다
}

@ 대체 텍스트와 선택적 나눔 텍스트에는 문자 노드, 커닝 노드, 합자 노드, 상자나 괘선 노드만 들어 있어야 한다. 다른 것이 있으면
무언가 잘못된 것이다.

@<|breakWidth|에서 노드 |v|의...@>=
if isCharNode(v) {
	f = font(v)
	breakWidth[1] -= charWidth(f, charInfo(f, character(v)))
} else {
	switch typ(v) {
	case ligatureNode:
		f = font(ligChar(v))
		breakWidth[1] -= charWidth(f, charInfo(f, character(ligChar(v))))
	case hlistNode, vlistNode, ruleNode, kernNode:
		breakWidth[1] -= width(v)
	default: confusion("disc1")
@:this can't happen disc1}{\quad disc1@>
	}
}

@ 노드 |s|의 너비를 |breakWidth|에 더한다. 앞 절과 같은 종류의 노드만 올 수 있다.
@<|breakWidth|에 노드 |s|의...@>=
if isCharNode(s) {
	f = font(s)
	breakWidth[1] += charWidth(f, charInfo(f, character(s)))
} else {
	switch typ(s) {
	case ligatureNode:
		f = font(ligChar(s))
		breakWidth[1] += charWidth(f, charInfo(f, character(ligChar(s))))
	case hlistNode, vlistNode, ruleNode, kernNode:
		breakWidth[1] += width(s)
	default: confusion("disc2")
@:this can't happen disc2}{\quad disc2@>
	}
}

@ 노드 |curP|에서 나누기 위해 델타 노드를 준비한다. 바로 앞이 델타 노드이면 그것을 고쳐 쓰고, 활성 목록의 맨 앞이면 델타 노드 대신
|activeWidth|를 고친다. 여기서는 |typ(active)!=deltaNode|라는 사실을 이용한다.

@<|curP|에서의 나눔을 준비하는...@>=
if typ(prevR) == deltaNode { // 기존의 델타 노드를 고친다
	for k := int32(1); k <= 6; k++ { // |convertToBreakWidth|
		mem[prevR+k].sc = mem[prevR+k].sc - curActiveWidth[k] + breakWidth[k]
	}
} else if prevR == active { // 처음에는 델타 노드가 필요 없다
	for k := int32(1); k <= 6; k++ {
		activeWidth[k] = breakWidth[k] // |storeBreakWidth|
	}
} else {
	q = getNode(deltaNodeSize); setLink(q, r); setType(q, deltaNode)
	setSubtype(q, 0) // |subtype|은 쓰이지 않는다
	for k := int32(1); k <= 6; k++ {
		mem[q+k].sc = breakWidth[k] - curActiveWidth[k] // |newDeltaToBreakWidth|
	}
	setLink(prevR, q); prevPrevR = prevR; prevR = q
}

@ 새 활성 노드 뒤에 다음 활성 노드를 위한 델타 노드를 넣는다. 다음 코드를 실행할 때는 |r| 앞에 활성 노드를 적어도 하나 방금
넣었으므로 |typ(prevR)!=deltaNode|다.

@<다음 활성 노드를 준비하는...@>=
if r != lastActive {
	q = getNode(deltaNodeSize); setLink(q, r); setType(q, deltaNode)
	setSubtype(q, 0) // |subtype|은 쓰이지 않는다
	for k := int32(1); k <= 6; k++ {
		mem[q+k].sc = curActiveWidth[k] - breakWidth[k] // |newDeltaFromBreakWidth|
	}
	setLink(prevR, q); prevPrevR = prevR; prevR = q
}

@ 활성 노드를 만들 때는 짝이 되는 수동 노드도 만든다. 수동 노드의 |prevBreak|는 이 줄이 시작하는 나눔점, 곧 |bestPlace[fitClass]|를
가리킨다.

@<|bestPlace[fitClass]|에서 |curP|까지...@>=
q = getNode(passiveNodeSize)
setLink(q, passive); passive = q; setCurBreak(q, curP)
if stat {
	passNumber++; setSerial(q, passNumber)
}
setPrevBreak(q, bestPlace[fitClass])
q = getNode(activeNodeSize); setBreakNode(q, passive)
setLineNumber(q, bestPlLine[fitClass]+1)
setFitness(q, fitClass); setType(q, breakType)
setTotalDemerits(q, minimalDemerits[fitClass])
setLink(q, r); setLink(prevR, q); prevR = q
if stat && tracingParagraphs() > 0 {
	@<새 나눔 노드를 기호로 설명해 찍는다@>
}

@ 매개변수 \.{\\tracingparagraphs}가 양수이면 새 나눔 노드를 `\.{@@@@3: line 2.1- t=5432 -> @@@@1}'처럼 찍는다. 수동 노드의 번호, 줄 번호와
맞음새 분류, 하이픈 여부, 전체 감점, 그리고 바로 앞 나눔점의 번호다.
@<새 나눔 노드를 기호로...@>=
printNl("@@@@"); printInt(serial(passive))
@.\AT!\AT!@>
printStr(": line "); printInt(lineNumber(q) - 1)
printChar('.'); printInt(fitClass)
if breakType == hyphenated {
	printChar('-')
}
printStr(" t="); printInt(totalDemerits(q))
printStr(" -> @@@@")
if prevBreak(passive) == null {
	printChar('0')
} else {
	printInt(serial(prevBreak(passive)))
}

@ 줄의 길이는 사용자가 \.{\\parshape}나 \.{\\hangindent}를 지정했는지에 따라 달라진다. 포인터 |parShapePtr|가 널이 아니면 그것은
|mem|의 $(2n+1)$낱말짜리 레코드를 가리키는데, 첫 낱말의 |info|에는 |n|의 값이 들어 있고, 나머지 $2n$ 낱말에는 문단의 처음 |n|줄의
왼쪽 여백과 줄 길이가 들어 있다. 그리고 |n|번째 줄의 지정은 그 뒤의 모든 줄에 적용된다. 그 포인터가 널이면 문단의 모양은
|n=hangAfter|의 값에 따라 정해진다. 이 값이 |n>=0|이면 매달린 들여쓰기가 |n+1|, |n+2|, \dots\ 줄에서 일어나고, 그렇지 않으면 1, \dots,
$\vert n\vert$ 줄에서 일어난다. 매달린 들여쓰기가 작동할 때 왼쪽 여백은 |hangIndent>=0|이면 |hangIndent|이고 그렇지 않으면 0이다.
줄 길이는 $|hsize|-\vert|hangIndent|\vert$이다. 보통 설정은 |parShapePtr=null|, |hangAfter=1|, |hangIndent=0|이다. 들여쓰기가
|hangIndent=0|이면 |hangAfter|의 값은 상관없다는 데 주의하자.
@^length of lines@> @^hanging indentation@>

@<전역 변수@>=
var @!easyLine halfword // 나눔 노드에서 |>easyLine|인 줄 번호는 모두 같은 것으로 본다
var @!lastSpecialLine halfword // |>lastSpecialLine|인 줄 번호는 모두 너비가 같다
var @!firstWidth scaled // \.{\\parshape}가 지정되지 않았을 때 |<=lastSpecialLine|인 모든 줄의 너비
var @!secondWidth scaled // |>lastSpecialLine|인 모든 줄의 너비
var @!firstIndent scaled // |firstWidth|와 함께 갈 왼쪽 여백
var @!secondIndent scaled // |secondWidth|와 함께 갈 왼쪽 여백

@ 변수 |easyLine|의 값과 줄 길이에 관련된 다른 변수들은 프로시저 |lineBreak|가 준비하면서 계산한다. 줄 번호가 |lastSpecialLine|보다
크면 모든 줄의 너비가 같으므로, looseness가 0이면 그런 줄 번호는 모두 하나로 볼 수 있다. 그 경계가 |easyLine|이다.

@<줄 나누기를 시작할...@>=
if parShapePtr() == null {
	if hangIndent() == 0 {
		lastSpecialLine = 0; secondWidth = hsize()
		secondIndent = 0
	} else {
		@<매달린 들여쓰기에 대비해 줄 길이 매개변수를 정한다@>
	}
} else {
	lastSpecialLine = info(parShapePtr()) - 1
	secondWidth = mem[parShapePtr()+2*(lastSpecialLine+1)].sc
	secondIndent = mem[parShapePtr()+2*lastSpecialLine+1].sc
}
if looseness() == 0 {
	easyLine = lastSpecialLine
} else {
	easyLine = maxHalfword
}

@ 매달린 들여쓰기가 있으면 처음 $\vert n\vert$줄과 나머지 줄의 너비와 여백을 정한다.
@<매달린 들여쓰기에 대비해...@>=
lastSpecialLine = abs(hangAfter())
if hangAfter() < 0 {
	firstWidth = hsize() - abs(hangIndent())
	if hangIndent() >= 0 {
		firstIndent = hangIndent()
	} else {
		firstIndent = 0
	}
	secondWidth = hsize(); secondIndent = 0
} else {
	firstWidth = hsize(); firstIndent = 0
	secondWidth = hsize() - abs(hangIndent())
	if hangIndent() >= 0 {
		secondIndent = hangIndent()
	} else {
		secondIndent = 0
	}
}

@ 다음 코드에 이르렀다면 |lineNumber| 필드가 |l|인 첫 활성 노드~|r|을 방금 만난 것이다. 그래서 현재 문단의 $l\mskip1mu$번째 줄의
길이를 계산하고 싶다. 또 |oldL|을 |l|과 동치인 줄 번호 부류의 마지막 번호로 정하고 싶다.

@<새 줄 너비를...@>=
if l > easyLine {
	lineWidth = secondWidth; oldL = maxHalfword - 1
} else {
	oldL = l
	if l > lastSpecialLine {
		lineWidth = secondWidth
	} else if parShapePtr() == null {
		lineWidth = firstWidth
	} else {
		lineWidth = mem[parShapePtr()+2*l].sc
	}
}

@ 서브루틴 |tryBreak|의 나머지 부분은 |r|에서 |curP|까지 나누는 데 드는 감점의 계산을 다룬다.

먼저 할 일은 나쁨 |b|를 계산하는 것이다. 이 값은 언제나 0과 |infBad+1| 사이에 있다. 뒤의 값은 |r|에서 |curP|까지의 줄을 필요한 너비에
맞을 만큼 줄일 수 없을 때에만 나온다. 그런 경우 노드 |r|은 비활성화한다. 훑는 위치가 더 나아가면 줄이 더 길어질 뿐이니, |r|에서
시작하는 줄은 앞으로도 맞출 수 없기 때문이다. 또 |curP|에서 나누는 것이 강제될 때도 노드~|r|을 비활성화한다. 앞으로의 나눔은
강제된 나눔을 반드시 지나야 하기 때문이다.

노드 |r|이 더는 활성이지 않아야 하면 비활성화하고, |r|에서 |curP|까지의 줄이 실행 불가능하면 |goto again|하고, 그렇지 않으면 새
실행 가능한 나눔을 기록한다.

@<|r|에서 |curP|까지의 줄의 감점을...@>=
artificialDemerits = false
@^inner loop@>
shortfall = lineWidth - curActiveWidth[1] // 이만큼 너무 짧다
if shortfall > 0 {
	@<줄을 늘일 때의 나쁨을 |b|에, 그에 맞는 |fitClass|를 정한다@>
} else {
	@<줄을 줄일 때의 나쁨을 |b|에, 그에 맞는 |fitClass|를 정한다@>
}
if b > infBad || pi == ejectPenalty {
	@<노드~|r|의 비활성화를 준비하고, 까닭이 없으면 |goto deactivate|@>
} else {
	prevR = r
	if b > threshold {
		goto again
	}
	nodeRStaysActive = true
}
@<새 실행 가능한 나눔을 기록한다@>
if nodeRStaysActive {
	goto again // |prevR|는 |r|로 정해져 있다
}
deactivate:
	@<노드 |r|을 비활성화한다@>

@ 줄을 늘여야 할 때, 쓸 수 있는 늘일 수 있는 양은 부분 배열 |curActiveWidth[2..5]|에 pt, fil, fill, filll 단위로 있다. 무한 늘어남이
있으면 나쁨은 0이다.

이 절은 \TeX의 안쪽 루프의 일부이고, 나쁨이 무한일 때 가장 자주 실행된다. 그래서 서브루틴 |badness|를 부르기 전에 모자란 양이 크고
늘일 수 있는 양이 작은지 재빨리 검사해 볼 만하다. 나쁨에 따라 맞음새 분류도 정한다. 나쁨이 99보다 크면 |veryLooseFit|, 12보다
크면 |looseFit|, 아니면 |decentFit|이다.
@^inner loop@>

@<줄을 늘일 때의...@>=
if curActiveWidth[3] != 0 || curActiveWidth[4] != 0 || curActiveWidth[5] != 0 {
	b = 0; fitClass = decentFit // 무한 늘어남
} else {
	if shortfall > 7230584 && curActiveWidth[2] < 1663497 {
		b = infBad; fitClass = veryLooseFit; goto done1
	}
	b = badness(shortfall, curActiveWidth[2])
	if b > 12 {
		if b > 99 {
			fitClass = veryLooseFit
		} else {
			fitClass = looseFit
		}
	} else {
		fitClass = decentFit
	}
done1: ;
}

@ 문단 안에서 줄어듦은 결코 무한이 아니다. 그래서 |r|에서 |curP|까지의 줄은 많아야 |curActiveWidth[6]|만큼만 줄일 수 있다. 그보다
더 줄여야 하면 나쁨은 |infBad+1|이다.

@<줄을 줄일 때의...@>=
if -shortfall > curActiveWidth[6] {
	b = infBad + 1
} else {
	b = badness(-shortfall, curActiveWidth[6])
}
if b > 12 { fitClass = tightFit } else { fitClass = decentFit }

@ 마지막 훑기에서는 활성 노드를 모두 잃는 모험을 해서는 안 된다. 그러면 이미 찾은 줄 나눔들과의 끈이 끊기기 때문이다. 여기 보인
코드는 마지막 수단으로 넘치는 상자를 허락해서 그런 파국이 일어나지 않게 한다. \TeX의 이 부분은 올바른 프로그램 논리를 마침내
찾아내기 전까지 여러 미묘한 버그의 근원이었다. 그러니 \TeX을 ``개선''하려는 독자는 여기서 무엇이든 감히 바꾸기 전에 세 번
생각해야 한다.
@^overfull boxes@>

@<노드~|r|의 비활성화를 준비하고...@>=
if finalPass && minimumDemerits == awfulBad && link(r) == lastActive && prevR == active {
	artificialDemerits = true // 감점을 0으로 한다. 이 나눔은 강제된다
} else if b > threshold {
	goto deactivate
}
nodeRStaysActive = false

@ 코드의 이 부분에 이르면 |r|에서 |curP|까지의 줄은 실행 가능하고, 그 나쁨은~|b|이며, 맞음새 분류는 |fitClass|다. 이 나눔을 위한
활성 노드를 아직 만들지는 않지만, 전체 감점을 계산해서, 이 나눔이 주어진 줄 번호 부류와 맞음새 분류에서 |curP|에 이르는 모든 길
가운데 지금의 챔피언이면 배열 |minimalDemerits|에 기록한다.

@<새 실행 가능한 나눔을...@>=
if artificialDemerits {
	d = 0
} else {
	@<|r|에서 |curP|까지의 감점 |d|를 계산한다@>
}
if stat && tracingParagraphs() > 0 {
	@<이 실행 가능한 나눔을 기호로 설명해 찍는다@>
}
d += totalDemerits(r) // 이것은 처음부터 |r|을 거쳐 |curP|까지의 최소 전체 감점이다
if d <= minimalDemerits[fitClass] {
	minimalDemerits[fitClass] = d
	bestPlace[fitClass] = breakNode(r); bestPlLine[fitClass] = l
	if d < minimumDemerits {
		minimumDemerits = d
	}
}

@ 매개변수 \.{\\tracingparagraphs}가 양수이면 실행 가능한 나눔마다 `\.{@@ via @@@@2 b=13 p=0 d=529}'처럼 어디서 나누는지, 어느 나눔점에서
시작한 줄인지, 나쁨, 벌점, 감점을 찍는다. 그 앞에는 지난번에 찍은 곳부터 이 나눔점까지의 문단 텍스트를 짧게 찍는다.
@<이 실행 가능한 나눔을 기호로...@>=
if printedNode != curP {
	@<|printedNode|와 |curP| 사이의 목록을 찍고 |printedNode=curP|로 한다@>
}
printNl("@@")
@.\AT!@>
if curP == null {
	printEsc("par")
} else if typ(curP) != glueNode {
	if typ(curP) == penaltyNode {
		printEsc("penalty")
	} else if typ(curP) == discNode {
		printEsc("discretionary")
	} else if typ(curP) == kernNode {
		printEsc("kern")
	} else {
		printEsc("math")
	}
}
printStr(" via @@@@")
if breakNode(r) == null { printChar('0') } else { printInt(serial(breakNode(r))) }
printStr(" b=")
if b > infBad { printChar('*') } else { printInt(b) }
@.*\relax@>
printStr(" p="); printInt(pi); printStr(" d=")
if artificialDemerits { printChar('*') } else { printInt(d) }

@ 지난번에 찍은 곳부터 |curP|까지의 텍스트를 짧게 찍는다.
@<|printedNode|와 |curP| 사이의...@>=
printNl("")
if curP == null {
	shortDisplay(link(printedNode))
} else {
	saveLink = link(curP)
	setLink(curP, null); printNl(""); shortDisplay(link(printedNode))
	setLink(curP, saveLink)
}
printedNode = curP

@ 선택적 나눔의 자료를 보여 줄 때는 |preBreak|와 |postBreak| 목록을 이미 찍었을 것이다. 셋째 목록은 건너뛰어서 선택적 나눔 자료가 두
번 나타나지 않게 하고 싶다. 다음 코드는 |tryBreak|의 맨 끝에서 실행한다.

@<|printedNode|의 값을...@>=
if curP == printedNode && curP != null && typ(curP) == discNode {
	t = replaceCount(curP)
	for t > 0 {
		t--; printedNode = link(printedNode)
	}
}

@ 감점을 \secref{demerits-formula}의 식대로 계산한다. 그다음 하이픈으로 끝난 줄이 잇달아 나오면 \.{\\doublehyphendemerits}를,
끝에서 둘째 줄이 하이픈으로 끝나면 \.{\\finalhyphendemerits}를, 맞음새 분류가 둘 이상 차이 나면 \.{\\adjdemerits}를 더한다.
@<|r|에서 |curP|까지의 감점...@>=
d = linePenalty() + b
if abs(d) >= 10000 { d = 100000000 } else { d = d * d }
if pi != 0 {
	if pi > 0 {
		d += pi*pi
	} else if pi > ejectPenalty {
		d -= pi*pi
	}
}
if breakType == hyphenated && typ(r) == hyphenated {
	if curP != null {
		d += doubleHyphenDemerits()
	} else {
		d += finalHyphenDemerits()
	}
}
if abs(fitClass-fitness(r)) > 1 {
	d += adjDemerits()
}

@ 활성 노드가 사라질 때, 그 노드가 활성 목록의 처음이나 끝에 있었거나 델타 노드들 사이에 있었으면 이웃한 델타 노드를 지우거나 합쳐야
한다. 또 |curActiveWidth|가 |link(prevR)|에서 |curP|까지 내용의 길이라는 성질도 지켜야 한다.

@<노드 |r|을 비활성화한다@>=
setLink(prevR, link(r)); freeNode(r, activeNodeSize)
if prevR == active {
	@<첫 활성 노드가 지워졌으므로 활성 너비들을 갱신한다@>
} else if typ(prevR) == deltaNode {
	r = link(prevR)
	if r == lastActive {
		for k := int32(1); k <= 6; k++ {
			curActiveWidth[k] -= mem[prevR+k].sc // |downdateWidth|
		}
		setLink(prevPrevR, lastActive)
		freeNode(prevR, deltaNodeSize); prevR = prevPrevR
	} else if typ(r) == deltaNode {
		for k := int32(1); k <= 6; k++ {
			curActiveWidth[k] += mem[r+k].sc // |updateWidth|
		}
		for k := int32(1); k <= 6; k++ {
			mem[prevR+k].sc = mem[prevR+k].sc + mem[r+k].sc // |combineTwoDeltas|
		}
		setLink(prevR, link(r)); freeNode(r, deltaNodeSize)
	}
}

@ 첫 활성 노드가 지워졌으면, 그다음이 델타 노드일 때 그것을 |activeWidth|에 반영하고 지운다. 다음 코드는 |typ(lastActive)!=deltaNode|라는
사실을 이용한다. 활성 목록이 방금 비었으면 배열 |activeWidth|를 고칠 필요가 없다. 다음에 활성 노드를 넣을 때 초기화될 것이기
때문이다.

@<첫 활성 노드가 지워졌으므로...@>=
r = link(active)
if typ(r) == deltaNode {
	for k := int32(1); k <= 6; k++ {
		activeWidth[k] += mem[r+k].sc // |updateActive|
	}
	for k := int32(1); k <= 6; k++ {
		curActiveWidth[k] = activeWidth[k] // |copyToCurActive|
	}
	setLink(active, link(r)); freeNode(r, deltaNodeSize)
}

@* 문단을 줄로 나누기, 계속.
지금까지 |lineBreak| 루틴에 조금 들어가서 그 중요한 서브루틴 |tryBreak|를 다루었다. 이제 나머지 과정을 살펴보자.

프로시저 |lineBreak|의 주 루프는 |link(tempHead)|에서 시작하는 가로 목록을 따라가며 합법적인 나눔점마다 |tryBreak|를 부른다. 변수
|autoBreaking|은 수식 바깥에서만 참이다. 수식 안의 글루 노드는 합법적인 나눔점이 아니기 때문이다. 수식 안에서는 벌점이 있는 곳에서만
줄을 나눌 수 있다.

가로 목록에서 지금 보는 노드는 |curP|가 가리킨다. 또 다른 변수 |prevP|는 대개 |curP|보다 한 걸음 뒤에 있지만, 정확한 뜻은 이렇다.
노드 |curP|가 글루 노드이면(|typ(curP)=glueNode|), |autoBreaking|이 참이고 |prevP|가 글루 노드, 벌점 노드, 명시적 커닝 노드, 수식
노드를 가리키지 않을 때, 그리고 오직 그때에만 |curP|가 합법적인 나눔점이다. 곧 글루 바로 앞이 글자나 상자처럼 버려지지 않는
것이어야 한다.

다음 선언은 특별한 계산에 쓰는 몇몇 지역 변수를 마련한다.

@<줄 나누기의 지역 변수@>=
var autoBreaking bool // 노드 |curP|가 수식 바깥에 있는가?
var prevP pointer // 글루 노드가 언제 나눔점인지 정하는 것을 돕는다
var q, r, s, prevS pointer // 잠깐 관심 있는 여러 노드
var f internalFontNumber // 문자 너비를 계산할 때 쓴다

@ 다음 코드의 `\ignorespaces|for|\unskip' 루프는 |lineBreak|를 한 번 부를 때마다 많아야 세 번 돈다. 한 번 돌 때마다 문단 전체를 한 번
훑는다. 매개변수 \.{\\pretolerance}가 음수이면 첫째 훑기를 건너뛰고 곧바로 하이픈을 넣는 둘째 훑기부터 한다. 훑기마다 활성 목록을 새로
시작하고, 가로 목록을 끝까지 따라간 다음, 문단 끝에서 강제로 나눈다. 실행 가능한 나눔을 찾았으면 루프를 빠져나가고, 아니면 지금까지
만든 노드들을 치우고 다음 훑기를 준비한다.

@<최적의 나눔점들을...@>=
threshold = pretolerance()
if threshold >= 0 {
	if stat && tracingParagraphs() > 0 {
		beginDiagnostic(); printNl("@@firstpass")
	}
	secondPass = false; finalPass = false
} else {
	threshold = tolerance(); secondPass = true
	finalPass = emergencyStretch() <= 0
	if stat && tracingParagraphs() > 0 {
		beginDiagnostic()
	}
}
for {
	threshold = min(threshold, infBad)
	if secondPass {
		@<문단에 하이픈을 넣을 준비를 한다@>
	}
	@<문단의 처음을 나타내는 활성 나눔점을 만든다@>
	curP = link(tempHead); autoBreaking = true
	prevP = curP // 처음의 글루는 합법적인 나눔점이 아니다
	for curP != null && link(active) != lastActive {
		@<|curP|가 합법적인 나눔점이면 |tryBreak|를 부르고 다음으로 나아간다@>
	}
	if curP == null {
		@<문단 끝에서 마지막 줄 나눔을 시도하고, 원하는 나눔점들을 찾았으면 |goto done|@>
	}
	@<나눔 노드들을 없애 메모리를...@>
	@<다음 훑기를 준비한다@>
}
done:
	if stat && tracingParagraphs() > 0 {
		endDiagnostic(true); normalizeSelector()
	}

@ 앞 절에 이어서, 첫째 훑기가 실패했으면 둘째 훑기를, 둘째 훑기도 실패했으면 비상 훑기를 준비한다. 비상 훑기에서는 바탕의
늘어남에 \.{\\emergencystretch}를 더한다.

@<다음 훑기를...@>=
if !secondPass {
	if stat && tracingParagraphs() > 0 {
		printNl("@@secondpass")
	}
	threshold = tolerance(); secondPass = true; finalPass = emergencyStretch() <= 0
} else { // 처음에 성공하지 못하면, \dots
	if stat && tracingParagraphs() > 0 {
		printNl("@@emergencypass")
	}
	background[2] += emergencyStretch(); finalPass = true
}

@ 문단의 처음을 나타내는 활성 노드를 만든다. 시작점에는 앞 나눔점이 없으므로 대응하는 수동 노드가 필요 없다. 줄 번호는
|prevGraf+1|에서 시작한다.

@<문단의 처음을 나타내는...@>=
q = getNode(activeNodeSize)
setType(q, unhyphenated); setFitness(q, decentFit)
setLink(q, lastActive); setBreakNode(q, null)
setLineNumber(q, prevGraf+1); setTotalDemerits(q, 0); setLink(active, q)
for k := int32(1); k <= 6; k++ {
	activeWidth[k] = background[k] // |storeBackground|
}
passive = null; printedNode = tempHead; passNumber = 0
fontInShortDisplay = nullFont

@ 문단을 다 나누었으면 활성 노드와 델타 노드와 수동 노드를 모두 치운다.
@<나눔 노드들을 없애...@>=
q = link(active)
for q != lastActive {
	curP = link(q)
	if typ(q) == deltaNode {
		freeNode(q, deltaNodeSize)
	} else {
		freeNode(q, activeNodeSize)
	}
	q = curP
}
q = passive
for q != null {
	curP = link(q)
	freeNode(q, passiveNodeSize)
	q = curP
}

@ 다음은 |lineBreak| 루틴의 주 갈래로, 여기서 합법적인 나눔점이 정해진다. 가로 목록을 따라가면서 배열 |activeWidth|를 늘 최신으로
유지해야 |tryBreak|가 줄마다 나쁨을 쉽게 계산할 수 있다. 활성 너비 가운데 글루가 아닌 실제 너비는 성분 |activeWidth[1]|이다.

노드 |curP|가 합법적인 나눔점이면 |tryBreak|를 부르고, 둘째 훑기에서 |curP|가 글루 노드이면 다음 낱말에 하이픈을 넣어 본다. 그런
다음 |curP|를 문단에서 합법적인 나눔점일 수 있는 다음 노드로 옮긴다. 벌점 노드에서는 그 벌점으로, 선택적 나눔에서는 하이픈 벌점으로
|tryBreak|를 부른다.

커닝이나 수식 노드에서 나눔을 시도하는 일은 두 곳에서 쓰이므로 이름 있는 절로 둔다(다음 절).

@<|curP|가 합법적인 나눔점이면 |tryBreak|를 부르고 다음으로 나아간다@>=
if isCharNode(curP) {
	@<|curP|를 지금 문자열 다음의 노드로 옮긴다@>
}
switch typ(curP) {
case hlistNode, vlistNode, ruleNode: activeWidth[1] = activeWidth[1] + width(curP)
case whatsitNode: @<|lineBreak| 루프에서 whatsit 노드를 지나간다@>
case glueNode:
	@<|curP|가 합법적인 나눔점이면 |tryBreak|를 부르고 글루를 활성 너비에 넣는다@>
	if secondPass && autoBreaking {
		@<다음 낱말에 하이픈을 넣어 본다@>
	}
case kernNode:
	if subtype(curP) == explicit {
		@<|kernBreak|를 한다@>
	} else {
		activeWidth[1] += width(curP)
	}
case ligatureNode:
	f = font(ligChar(curP))
	activeWidth[1] += charWidth(f, charInfo(f, character(ligChar(curP))))
case discNode: @<선택적 나눔 조각 뒤에서 나누어 보고 |goto done5|@>
case mathNode: autoBreaking = subtype(curP) == after; @<|kernBreak|를 한다@>
case penaltyNode: tryBreak(penalty(curP), unhyphenated)
case markNode, insNode, adjustNode: // 아무것도 하지 않는다
default: confusion("paragraph")
@:this can't happen paragraph}{\quad paragraph@>
}
prevP = curP; curP = link(curP)
done5: ;

@ 커닝이나 수식 노드 바로 뒤에 글루가 오면 그 자리에서 나누어 보고, 그 노드의 너비를 더한다.

@<|kernBreak|를 한다@>=
if !isCharNode(link(curP)) && autoBreaking {
	if typ(link(curP)) == glueNode {
		tryBreak(0, unhyphenated)
	}
}
activeWidth[1] += width(curP)

@ 문단의 낱말 문자들을 지나가는 코드는 \TeX의 안쪽 루프의 일부이므로 속도를 위해 다듬어 두었다. 문단마다 끝에 `\.{\\parfillskip}'
글루가 있다는 사실을 써먹는다. 그래서 |curP|가 문자 노드일 때 |link(curP)=null|인지 검사할 필요가 없다.
@^inner loop@>

@<|curP|를 지금 문자열...@>=
prevP = curP
for {
	f = font(curP)
	activeWidth[1] += charWidth(f, charInfo(f, character(curP)))
	curP = link(curP)
	if !isCharNode(curP) {
		break
	}
}

@ 노드 |curP|가 글루 노드이면, 앞에서 설명한 대로 |prevP|를 보고 |curP|에서 나누는 것이 합법적인지 알아본다. 그런 다음
|gluePtr(curP)|의 글루를 활성 너비에 더한다. 이때 무한 줄어듦도 검사한다.

@<|curP|가 합법적인 나눔점이면 |tryBreak|를 부르고 글루를...@>=
if autoBreaking {
	if isCharNode(prevP) {
		tryBreak(0, unhyphenated)
	} else if precedesBreak(prevP) {
		tryBreak(0, unhyphenated)
	} else if typ(prevP) == kernNode && subtype(prevP) != explicit {
		tryBreak(0, unhyphenated)
	}
}
if shrinkOrder(gluePtr(curP)) != normal && shrink(gluePtr(curP)) != 0 {
	setGluePtr(curP, finiteShrink(gluePtr(curP))) // |checkShrinkage|
}
q = gluePtr(curP)
activeWidth[1] += width(q)
activeWidth[2+stretchOrder(q)] = activeWidth[2+stretchOrder(q)] + stretch(q)
activeWidth[6] += shrink(q)

@ 선택적 나눔에서 나누어 본다. 나눔 앞 텍스트가 비어 있으면 \.{\\exhyphenpenalty}를, 아니면 \.{\\hyphenpenalty}를 매기고, 그 너비를
|discWidth|에 넣어 |tryBreak|에 알린다. 그다음 나누지 않을 때의 텍스트를 지나간다. 다음 코드는 선택적 나눔 텍스트에 문자 노드, 커닝
노드, 상자 노드, 괘선 노드, 합자 노드만 들어 있다는 것을 안다.

@<선택적 나눔 조각 뒤에서...@>=
s = preBreak(curP); discWidth = 0
if s == null {
	tryBreak(exHyphenPenalty(), hyphenated)
} else {
	for {
		@<|discWidth|에 노드 |s|의 너비를 더한다@>
		s = link(s)
		if s == null {
			break
		}
	}
	activeWidth[1] += discWidth
	tryBreak(hyphenPenalty(), hyphenated)
	activeWidth[1] -= discWidth
}
r = replaceCount(curP); s = link(curP)
for r > 0 {
	@<|actWidth|에 노드 |s|의 너비를 더한다@>
	r--; s = link(s)
}
prevP = curP; curP = s; goto done5

@ 노드 |s|의 너비를 |discWidth|에 더한다.
@<|discWidth|에 노드 |s|의...@>=
if isCharNode(s) {
	f = font(s)
	discWidth += charWidth(f, charInfo(f, character(s)))
} else {
	switch typ(s) {
	case ligatureNode:
		f = font(ligChar(s))
		discWidth += charWidth(f, charInfo(f, character(ligChar(s))))
	case hlistNode, vlistNode, ruleNode, kernNode:
		discWidth += width(s)
	default: confusion("disc3")
@:this can't happen disc3}{\quad disc3@>
	}
}

@ 노드 |s|의 너비를 |activeWidth[1]|에 더한다.
@<|actWidth|에 노드 |s|의...@>=
if isCharNode(s) {
	f = font(s)
	activeWidth[1] += charWidth(f, charInfo(f, character(s)))
} else {
	switch typ(s) {
	case ligatureNode:
		f = font(ligChar(s))
		activeWidth[1] += charWidth(f, charInfo(f, character(ligChar(s))))
	case hlistNode, vlistNode, ruleNode, kernNode:
		activeWidth[1] += width(s)
	default: confusion("disc4")
@:this can't happen disc4}{\quad disc4@>
	}
}

@ 문단 끝의 강제 줄 나눔은 나눔점 목록을 줄여서, 모든 활성 노드가 |curP=null|에서의 나눔을 나타내게 한다. 첫째 훑기에서는 올바른
``느슨함''(looseness)을 가진 활성 노드를 찾아야만 성공이다. 마지막 훑기에서는 활성 노드가 적어도 하나 있을 것이고, 원하는 느슨함에
될 수 있는 대로 가깝게 맞춘다. 매개변수 \.{\\looseness}는 문단을 가장 좋은 나눔보다 몇 줄 더 길게(양수) 또는 짧게(음수) 하라는 요청이다.

전역 변수 |bestBet|은 문단을 나누는 가장 좋은 방법을 나타내는 활성 노드다. 몇몇 다른 변수가 무엇이 가장 좋은지 정하는 것을 돕는다.

@<전역 변수@>=
var @!bestBet pointer // 이 수동 노드와 그 앞의 것들을 쓴다
var @!fewestDemerits int32 // |bestBet|에 딸린 감점
var @!bestLine halfword // 새 문단의 마지막 줄 다음의 줄 번호
var @!actualLooseness int32 // |lineNumber(bestBet)|와 최적의 |bestLine|의 차이
var @!lineDiff int32 // 현재 줄 번호와 최적의 |bestLine|의 차이

@ 문단 끝에서 강제로 나눈 뒤, 감점이 가장 적은 활성 노드를 찾는다. 매개변수 \.{\\looseness}가 0이 아니면 원하는 줄 수에 가장 가까운 것을 다시
찾는다.
@<문단 끝에서 마지막 줄 나눔을...@>=
tryBreak(ejectPenalty, hyphenated)
if link(active) != lastActive {
	@<감점이 가장 적은 활성 노드를 찾는다@>
	if looseness() == 0 {
		goto done
	}
	@<원하는 느슨함에 가장 좋은 활성 노드를 찾는다@>
	if actualLooseness == looseness() || finalPass {
		goto done
	}
}

@ 활성 목록을 훑어 전체 감점이 가장 적은 노드를 |bestBet|으로 삼는다.
@<감점이 가장 적은...@>=
r = link(active); fewestDemerits = awfulBad
for {
	if typ(r) != deltaNode && totalDemerits(r) < fewestDemerits {
		fewestDemerits = totalDemerits(r); bestBet = r
	}
	r = link(r)
	if r == lastActive {
		break
	}
}
bestLine = lineNumber(bestBet)

@ 원하는 느슨함에 맞추는 조정은 방금 본 루프를 조금 더 복잡하게 한 것이다. 줄 수의 차이가 \.{\\looseness}에 더 가까운 것을 고르고,
같으면 감점이 적은 것을 고른다. 문단이 따로 세운 수식으로 여러 토막으로 나뉘면, 토막마다 다른 토막과 상관없이 느슨함을 따로
계산한다는 데 주의하자.

@<원하는 느슨함에 가장 좋은...@>=
r = link(active); actualLooseness = 0
for {
	if typ(r) != deltaNode {
		lineDiff = lineNumber(r) - bestLine
		if (lineDiff < actualLooseness && looseness() <= lineDiff) ||
			(lineDiff > actualLooseness && looseness() >= lineDiff) {
			bestBet = r; actualLooseness = lineDiff
			fewestDemerits = totalDemerits(r)
		} else if lineDiff == actualLooseness && totalDemerits(r) < fewestDemerits {
			bestBet = r; fewestDemerits = totalDemerits(r)
		}
	}
	r = link(r)
	if r == lastActive {
		break
	}
}
bestLine = lineNumber(bestBet)

@ 가장 좋은 나눔점 나열을 찾았으면(만세!) 프로시저 |postLineBreak|를 불러 나머지 일을 마무리한다. (이 하위 프로시저를 따로 둔 덕분에
|lineBreak|가 지나치게 길어지지 않는다.)

@<고른 나눔점들에서...@>=
postLineBreak(finalWidowPenalty)

@ 프로시저 |postLineBreak|가 조판할 줄은 모두 |bestLine-prevGraf-1|개다. 마지막 나눔점은 |breakNode(bestBet)|이고, 이 수동 노드는
|prevBreak| 연결을 거쳐 다른 나눔점들을 가리킨다. 마무리는 먼저 관련된 수동 노드들을 앞으로 가는 차례로 잇는 것으로 시작한다. 곧
|prevBreak|를 |nextBreak|로 뒤집는 것이다. (필드 |nextBreak|는 실제로 |prevBreak| 필드와 같은 메모리 자리에 있지만, 뜻이 새로우므로
새 이름을 붙인다.) 그런 다음 줄들을 하나씩 맞춘다.

@<|lineBreak|의 하위...@>=
func nextBreak(p pointer) pointer { return prevBreak(p) } // 링크를 뒤집은 뒤 |prevBreak|의 새 이름
func setNextBreak(p pointer, v pointer) { setPrevBreak(p, v) }

func postLineBreak(finalWidowPenalty int32) {
	var q, r, s pointer // 목록을 다루는 임시 레지스터들
	var discBreak bool // 현재 나눔이 선택적 나눔 노드에서 일어났는가?
	var postDiscBreak bool // 그리고 그 나눔 뒤 부분이 비어 있지 않았는가?
	var curWidth scaled // 줄 번호 |curLine|의 너비
	var curIndent scaled // 줄 번호 |curLine|의 왼쪽 여백
	var t quarterword // 선택적 나눔 노드의 대체 개수에 쓴다
	var pen int32 // 줄 사이 벌점을 계산할 때 쓴다
	var curLine halfword // 지금 맞추고 있는 줄 번호
	@<관련된 수동 노드들의 링크를 뒤집고 |curP|를 첫 나눔점으로 한다@>
	curLine = prevGraf + 1
	for {
		@<나눔점 |curP|에서 끝나는 줄을 맞추어 현재 세로 목록에 덧붙인다@>
		curLine++; curP = nextBreak(curP)
		if curP != null && !postDiscBreak {
			@<다음 줄의 처음에서 원하지 않는 노드들을 쳐낸다@>
		}
		if curP == null {
			break
		}
	}
	if curLine != bestLine || link(tempHead) != null {
		confusion("line breaking")
	}
@:this can't happen line breaking}{\quad line breaking@>
	prevGraf = bestLine - 1
}

@ 목록의 연결을 뒤집는 일은 한 스택에서 항목을 꺼내 다른 스택에 넣는 일로 보면 편하다. 여기서는 |q|가 가리키고 |prevBreak| 필드로
이어진 스택에서 꺼내서, |curP|가 가리키고 |nextBreak| 필드로 이어진 스택에 넣는다. 노드 |r|은 한 스택에서 다른 스택으로 옮기는
수동 노드다.

@<관련된 수동 노드들의...@>=
q = breakNode(bestBet); curP = null
for {
	r = q; q = prevBreak(q); setNextBreak(r, curP); curP = r
	if q == null {
		break
	}
}

@ 줄의 처음에서는 글루, 벌점, 커닝, 수식 노드를 지운다. 다만 지울 노드가 실은 고른 나눔점 가운데 하나인 변칙적인 경우는 예외다. 여기서
하는 쳐내기는 |tryBreak|의 내다보기 계산, 곧 선택적 나눔이 아닌 나눔점의 |breakWidth|를 계산하는 방식과 맞도록 짜여 있다.

@<다음 줄의 처음에서...@>=
r = tempHead
for {
	q = link(r)
	if q == curBreak(curP) {
		goto done1 // |curBreak(curP)|는 다음 나눔점이다
	}
	// 이제 |q|는 |null|일 수 없다
	if isCharNode(q) {
		goto done1
	}
	if nonDiscardable(q) {
		goto done1
	}
	if typ(q) == kernNode && subtype(q) != explicit {
		goto done1
	}
	r = q // 이제 |typ(q)=glueNode|, |kernNode|, |mathNode|, |penaltyNode|
}
done1:
	if r != tempHead {
		setLink(r, null); flushNodeList(link(tempHead))
		setLink(tempHead, q)
	}

@ 맞출 현재 줄은 |link(tempHead)|에서 시작해 |curBreak(curP)|에서 끝나는 가로 목록에 있다. 끝 노드 |curBreak(curP)|가 글루 노드이면 그
글루를 |rightSkip| 글루로 바꾼다. 그렇지 않으면 오른쪽에 |rightSkip| 글루를 덧붙인다. 끝 노드가 선택적 나눔 노드이면 그 나눔이 실제로
일어나도록 목록을 고치고 |discBreak|를 |true|로 한다. 그리고 줄의 왼쪽에는 |leftSkip| 글루가 0이 아니면 덧붙인다.

나눔점 |curP|에서 끝나는 줄을 맞추어 현재 세로 목록에 덧붙이면서, 거기 딸린 벌점과 다른 삽입물도 함께 덧붙인다.

@<나눔점 |curP|에서 끝나는 줄을...@>=
@<나눔의 성질을 반영해 줄 끝을 고치고 \.{\\rightskip}을 넣는다@>
@<\.{\\leftskip} 글루를 왼쪽에 놓고 이 줄을 떼어 낸다@>
@<묶기 서브루틴을 불러 |justBox|를 맞춘 상자로 한다@>
@<새 상자를 현재 세로 목록에 덧붙이고, 묶개가 꺼낸 특별한 노드들을 잇는다@>
@<알맞으면 0이 아닌 벌점 노드를 덧붙인다@>

@ 다음 코드가 끝날 때 |q|는 맞출 목록의 마지막 노드를 가리킨다. 이 코드는 |discBreak|의 알맞은 값도 정한다. 커닝이나 수식 노드에서
나누었으면 그 노드의 너비를 0으로 한다. 줄 끝에서는 그 간격이 필요 없기 때문이다.

@<나눔의 성질을 반영해...@>=
q = curBreak(curP); discBreak = false; postDiscBreak = false
if q != null { // |q|는 |charNode|일 수 없다
	if typ(q) == glueNode {
		deleteGlueRef(gluePtr(q))
		setGluePtr(q, rightSkip())
		setSubtype(q, rightSkipCode+1); addGlueRef(rightSkip())
		goto done
	} else if typ(q) == discNode {
		@<선택적 나눔을 강제 나눔으로 바꾸고 |discBreak=true|로 한다@>
	} else if typ(q) == mathNode || typ(q) == kernNode {
		setWidth(q, 0)
	}
} else {
	q = tempHead
	for link(q) != null {
		q = link(q)
	}
}
@<노드 |q| 뒤에 \.{\\rightskip} 글루를 놓는다@>
done:

@ 선택적 나눔을 실제 나눔으로 바꾼다. 나누지 않을 때의 텍스트 |t|개를 버리고, 나눔 뒤 텍스트를 다음 줄의 처음으로, 나눔 앞 텍스트를
이 줄의 끝으로 옮겨 심는다.
@<선택적 나눔을 강제 나눔으로...@>=
t = replaceCount(q)
@<|q| 뒤의 노드 |t|개를 없애고 |r|이 그 다음 노드를 가리키게 한다@>
if postBreak(q) != null {
	@<나눔 뒤 목록을 옮겨 심는다@>
}
if preBreak(q) != null {
	@<나눔 앞 목록을 옮겨 심는다@>
}
setLink(q, r); discBreak = true

@ 노드 |q| 뒤의 대체 텍스트 |t|개를 목록에서 떼어 내 지운다.
@<|q| 뒤의 노드 |t|개를...@>=
if t == 0 {
	r = link(q)
} else {
	r = q
	for t > 1 {
		r = link(r); t--
	}
	s = link(r)
	r = link(s); setLink(s, null)
	flushNodeList(link(q)); setReplaceCount(q, 0)
}

@ 나눔 뒤 목록을 노드 |q| 안에서 꺼내 주 목록의 지금 노드 |r| 바로 앞에 붙이고, |r|을 그 목록의 처음으로 다시 정한다.

@<나눔 뒤 목록을...@>=
s = postBreak(q)
for link(s) != null {
	s = link(s)
}
setLink(s, r); r = postBreak(q); setPostBreak(q, null); postDiscBreak = true

@ 나눔 앞 목록을 노드 |q| 안에서 꺼내 주 목록의 노드 |q| 바로 뒤에 붙이고, |q|를 그 목록의 끝으로 다시 정한다.

@<나눔 앞 목록을...@>=
s = preBreak(q); setLink(q, s)
for link(s) != null {
	s = link(s)
}
setPreBreak(q, null); q = s

@ 줄 끝에 \.{\\rightskip} 글루를 덧붙인다.
@<노드 |q| 뒤에 \.{\\rightskip}...@>=
r = newParamGlue(rightSkipCode); setLink(r, link(q)); setLink(q, r); q = r

@ 다음 코드는 |q|가 맞출 목록의 끝에 있는 채로 시작한다. 끝날 때는 |q|가 그 목록의 처음에 있고, |link(tempHead)|는 문단의 나머지가
있으면 그것을 가리킨다.

@<\.{\\leftskip} 글루를 왼쪽에...@>=
r = link(q); setLink(q, null); q = link(tempHead); setLink(tempHead, r)
if leftSkip() != zeroGlue {
	r = newParamGlue(leftSkipCode)
	setLink(r, q); q = r
}

@ 줄 상자를 세로 목록에 덧붙이고, 줄을 꾸릴 때 빼낸 \.{\\vadjust}, \.{\\insert}, \.{\\mark}의 재료를 그 뒤에 잇는다.
@<새 상자를 현재 세로 목록에...@>=
appendToVlist(justBox)
if adjustHead != adjustTail {
	setLink(tail, link(adjustHead)); tail = adjustTail
}
adjustTail = null

@ 이제 |q|는 문단의 현재 줄을 나타내는 가로 목록을 가리킨다. 알맞은 줄 너비를 계산하고, 줄을 그 크기의 상자로 꾸리고, 상자를 알맞은
들여쓰기 양만큼 옮겨야 한다.

@<묶기 서브루틴을 불러...@>=
if curLine > lastSpecialLine {
	curWidth = secondWidth; curIndent = secondIndent
} else if parShapePtr() == null {
	curWidth = firstWidth; curIndent = firstIndent
} else {
	curWidth = mem[parShapePtr()+2*curLine].sc
	curIndent = mem[parShapePtr()+2*curLine-1].sc
}
adjustTail = adjustHead; justBox = hpack(q, curWidth, exactly)
setShiftAmount(justBox, curIndent)

@ 문단의 줄 사이 벌점은 클럽 줄과 과부 줄(club and widow lines)에서, 매개변수 |interLinePenalty|에서, 그리고 선택적 나눔에서 끝나는
줄에서 온다. 클럽 줄은 쪽의 맨 아래에 홀로 남는 문단의 첫 줄이고, 과부 줄은 쪽의 맨 위에 홀로 넘어가는 문단의 마지막 줄이다. 두
줄짜리 문단의 줄 사이에서 나누면 두 벌점을 다 받는다. 지역 변수 |pen|은 현재 줄 뒤에서 나눌 때의 모든 벌점을 더한 값이다. 다만
마지막 줄 뒤에는 결코 벌점을 넣지 않는다. 하이픈으로 끝나는 줄 뒤에는 \.{\\brokenpenalty}를 더한다.

@<알맞으면 0이 아닌 벌점...@>=
if curLine+1 != bestLine {
	pen = interLinePenalty()
	if curLine == prevGraf+1 {
		pen += clubPenalty()
	}
	if curLine+2 == bestLine {
		pen += finalWidowPenalty
	}
	if discBreak {
		pen += brokenPenalty()
	}
	if pen != 0 {
		r = newPenalty(pen)
		setLink(tail, r); tail = r
	}
}

@* 하이픈 넣기 전처리.
줄 나누기 루틴이 실행 가능한 나눔점 나열을 찾지 못하면, 문단을 두 번째로 훑으면서 하이픈을 넣을 수 있는 낱말에 하이픈을 넣어 본다.
하이픈 넣기는 문단에 선택적 나눔을 끼워 넣어 나눌 수 있는 후보 자리를 늘리는 일이다.

하이픈 넣기의 일반 규칙은 조금 복잡하고 기술적이다. 문장 부호가 앞뒤에 붙은 낱말에도 하이픈을 넣을 수 있어야 하고, 영어가 아닌
언어에서도 규칙이 통해야 하기 때문이다. 또 하이픈이 낱말의 합자와 커닝 구조를 근본적으로 바꿀 수도 있다는 사실과도 씨름해야 한다.

문자 나열은 현재 문단의 ``하이픈을 넣을 수 있을지도 모르는 부분''에 속할 때에만 하이픈 넣기 대상이 된다. 이 부분은 노드 나열
$p_0p_1\ldots p_m$인데, $p_0$은 글루 노드이고, $p_1\ldots p_{m-1}$은 문자나 합자나 whatsit이나 암묵적 커닝 노드이고, $p_m$은 글루나
벌점이나 삽입이나 조정이나 표시나 whatsit이나 명시적 커닝 노드다. (그러므로 상자, 수식, 사용자가 이미 넣은 선택적 나눔 노드가 있으면
하이픈을 넣지 않는다.) 노드 $p_1\ldots p_{m-1}$ 가운데 합자 노드는 사실상 원래의 합자 아닌 문자들로 펼쳐 보고, 커닝 노드와 whatsit은
무시한다. 이제 각 문자 |c|를 비문자(|lcCode(c)=0|이면), 소문자(|lcCode(c)=c|이면), 대문자(그 밖의 경우) 가운데 하나로 분류한다.
대문자는 하이픈 넣기에서 |lcCode(c)|인 것처럼 다룬다. 노드 $p_1\ldots p_{m-1}$이 만들어 내는 문자들은 비문자로 시작할 수도 있다. 이를테면
여는 따옴표 같은 것이다. 합자의 한가운데에 있지 않은 첫 글자를 $c_1$이라고 하자. 글자 $c_1$ 앞의 whatsit 노드는 무시하고, $c_1$ 뒤에서
찾은 whatsit은 끝내는 노드 $p_m$이 된다. 그리고 $c_1$과 글꼴이 다른 문자는 모두 비문자로 다룬다. 그 글꼴의 |hyphenChar|는 0과 255
사이여야 하고, 그렇지 않으면 하이픈을 넣지 않는다. \TeX은 될 수 있는 대로 많은 연속 글자 $c_1\ldots c_n$을 내다본다. 다만 |n|은
64보다 작아야 하므로, 그렇지 않았으면 $c_{64}$가 될 문자는 사실상 글자가 아니다. 게다가 $c_n$은 합자의 한가운데에 있어서는 안 된다.
이렇게 해서 노드 $p_a\ldots p_b$가 만들어 내는 글자 문자열 $c_1\ldots c_n$을 얻는다. 여기서 |1<=a<=b+1<=m|이다. 길이가
|n>=lHyf+rHyf|이면 이 문자열은 하이픈 넣기 대상이 된다. 다만 $c_1$이 대문자이면 |ucHyph|가 양수여야 한다.

하이픈 넣기는 세 단계로 이루어진다. 먼저 후보 나열 $c_1\ldots c_n$을 찾는다. 그다음 하이픈 넣기 표를 보고 하이픈이 들어갈 수 있는 자리를
정한다. 마지막으로 노드 $p_a\ldots p_b$를, 찾아낸 선택적 나눔을 담은 새 노드 나열로 바꾼다.

다행히 이 계산을 모두 아주 자주 할 필요는 없다. \TeX의 안쪽 루프에서 빼내 두었기 때문이다. 이를테면 저자의 700쪽짜리 책
{\sl Seminumerical Algorithms} 제2판을 \TeX으로 조판했을 때, 줄 나누기 알고리즘이 두 번 훑어야 했던 문단은 5퍼센트쯤뿐이었고,
@^Knuth, Donald Ervin@>
문단마다 시도해야 했던 하이픈 넣기는 1.2번쯤이었다.

@<문단에 하이픈을 넣을...@>=
if iniVersion && trieNotReady {
	initTrie()
}
curLang = initCurLang; lHyf = initLHyf; rHyf = initRHyf

@ 하이픈 넣기 후보인 글자 $c_1\ldots c_n$은 배열 |hc|에, 수 |n|은 |hn|에 들어간다. 위 설명의 노드 $p_{a-1}$과~$p_b$를 가리키는 포인터는
변수 |ha|와 |hb|에, 글꼴 번호는 |hf|에 들어간다. 배열 |hu|에는 소문자로 바꾸기 전의 원래 문자가 들어 있어, 나중에 낱말을 다시 짤 때
쓴다.

@<전역 변수@>=
var @!hc [66]halfword // 하이픈을 넣을 낱말; |0..256|
var @!hn smallNumber // |hc|에서 차지한 자리의 수; |0..64|, 늘 |smallNumber|인 것은 아니다
var @!ha, @!hb pointer // 노드 |ha..hb|를 하이픈 넣은 결과로 바꾸어야 한다
var @!hf internalFontNumber // |hc|에 있는 글자들의 글꼴 번호
var @!hu [64]halfword // 소문자로 바꾸기 전의 |hc|와 같은 것; |0..256|
var @!hyfChar int32 // 관련된 글꼴의 하이픈 문자
var @!curLang, @!initCurLang asciiCode // 지금 관심 있는 하이픈 넣기 표
var @!lHyf, @!rHyf, @!initLHyf, @!initRHyf int32 // 조각 크기의 한계
var @!hyfBchar halfword // $c_n$ 뒤의 경계 문자

@ 하이픈 넣기 루틴에는 지역 변수가 몇 개 더 필요하다.

@<줄 나누기의 지역 변수@>=
var j smallNumber // |hc|나 |hu|의 첨자
var c int32 // 하이픈 넣기를 고려하고 있는 문자; |0..255|

@ 다음 코드가 실행될 때 프로시저 |lineBreak|는 둘째 훑기에 있고, |curP|는 글루 노드를 가리킨다. 그 다음 낱말을 찾아 하이픈을 넣어
본다.

@<다음 낱말에 하이픈을...@>=
prevS = curP; s = link(prevS)
if s != null {
	@<노드 |ha|까지 건너뛴다. 하이픈을 넣지 말아야 하면 |goto done1|@>
	if lHyf+rHyf > 63 {
		goto done1
	}
	@<글자들을 |hu|와 |hc|에 넣으며 노드 |hb|까지 건너뛴다@>
	@<|hb| 뒤의 노드들이 하이픈 넣기를 허락하는지 검사한다@>
	hyphenate()
}
done1: ;

@ 프로시저 |hyphenate|는 세 단계로 이루어진다. 하이픈 자리를 찾고, 하나도 없으면 돌아가고, 있으면 노드들을 선택적 나눔을 담은 나열로
바꾼다.
@<|lineBreak|의 하위...@>=
@<|reconstitute|라는 함수를 선언한다@>@;
func hyphenate() {
	@<하이픈 넣기의 지역 변수@>@;
	@<|hc|에 있는 낱말의 하이픈 자리를 찾거나 |return|한다@>
	@<하이픈을 하나도 찾지 못했으면 |return|한다@>
	@<노드 |ha..hb|를 선택적 하이픈을 담은 노드 나열로 바꾼다@>
}

@ 먼저 할 일은 첫 글자 바로 앞의 노드 |ha|를 찾는 것이다. 글자가 아닌 문자(\.{\\lccode}가 0인 것)나 암묵적 커닝은 건너뛰고, 하이픈을
넣을 수 없는 노드를 만나면 그만둔다. 이때 언어와 \.{\\lefthyphenmin}, \.{\\righthyphenmin}을 바꾸는 whatsit도 처리한다.

@<노드 |ha|까지 건너뛴다...@>=
for {
	if isCharNode(s) {
		c = qo(character(s)); hf = font(s)
	} else if typ(s) == ligatureNode {
		if ligPtr(s) == null {
			goto again
		}
		q = ligPtr(s); c = qo(character(q)); hf = font(q)
	} else if typ(s) == kernNode && subtype(s) == normal {
		goto again
	} else if typ(s) == whatsitNode {
		@<하이픈 넣기 전처리 루프에서 whatsit 노드를 지나간다@>
		goto again
	} else {
		goto done1
	}
	if lcCode(c) != 0 {
		if lcCode(c) == c || ucHyph() > 0 {
			goto done2
		}
		goto done1
	}
again:
	prevS = s; s = link(prevS)
}
done2:
	hyfChar = hyphenChar[hf]
	if hyfChar < 0 {
		goto done1
	}
	if hyfChar > 255 {
		goto done1
	}
	ha = prevS

@ 하이픈을 넣을 낱말을 이제 배열 |hu|와 |hc|로 옮긴다. 글꼴이 다르거나 글자가 아닌 문자가 나오면 낱말이 끝난 것이다.

@<글자들을 |hu|와 |hc|에 넣으며...@>=
hn = 0
for {
	if isCharNode(s) {
		if font(s) != hf {
			goto done3
		}
		hyfBchar = character(s); c = qo(hyfBchar)
		if lcCode(c) == 0 {
			goto done3
		}
		if hn == 63 {
			goto done3
		}
		hb = s; hn++; hu[hn] = c; hc[hn] = lcCode(c); hyfBchar = nonChar
	} else if typ(s) == ligatureNode {
		@<합자 노드의 문자들을 |hu|와 |hc|로 옮긴다@>
	} else if typ(s) == kernNode && subtype(s) == normal {
		hb = s
		hyfBchar = fontBchar[hf]
	} else {
		goto done3
	}
	s = link(s)
}
done3:

@ 합자 노드를 펼칠 때는 저장하고 있는 문자의 첨자를 |j|로 한다. 합자 전체가 글자로 이루어졌다는 것을 확인하기 전에는 |hn|을 늘리고
싶지 않기 때문이다. 글자가 아닌 것이 있으면 |goto done3|한다. 또 |hn=0|이고 |hb|가 아무 값으로도 정해지지 않은 채 |done3|에 이를
수도 있다는 데 주의하자.

@<합자 노드의 문자들을...@>=
if font(ligChar(s)) != hf {
	goto done3
}
j = hn; q = ligPtr(s)
if q > null {
	hyfBchar = character(q)
}
for q > null {
	c = qo(character(q))
	if lcCode(c) == 0 {
		goto done3
	}
	if j == 63 {
		goto done3
	}
	j++; hu[j] = c; hc[j] = lcCode(c)
	q = link(q)
}
hb = s; hn = j
if odd(subtype(s)) { hyfBchar = fontBchar[hf] } else { hyfBchar = nonChar }

@ 적어도 |lHyf+rHyf|개의 글자를 찾았는지 검사한다. 그렇지 않으면 |goto done1|한다. 또 낱말 뒤의 노드들이 하이픈 넣기를 허락하는
것들인지 본다. 낱말 바로 뒤에 상자나 수식이 붙어 있으면 하이픈을 넣지 않는다.

@<|hb| 뒤의 노드들이...@>=
if hn < lHyf+rHyf {
	goto done1 // |lHyf|와 |rHyf|는 |>=1|이다
}
for {
	if !isCharNode(s) {
		switch typ(s) {
		case ligatureNode: // 아무것도 하지 않는다
		case kernNode:
			if subtype(s) != normal {
				goto done4
			}
		case whatsitNode, glueNode, penaltyNode, insNode, adjustNode, markNode:
			goto done4
		default: goto done1
		}
	}
	s = link(s)
}
done4:

@* 하이픈 넣기 후처리.
글자 |hc[j]|와 |hc[j+1]| 사이에 하이픈을 넣을 수 있으면, 하이픈 넣기 프로시저는 |hyf[j]|를 어떤 작은 홀수로 정한다. 그러나 줄 나누기
알고리즘의 나머지와는 독립인 \TeX의 하이픈 넣기 프로시저를 보기 전에, 찾아낸 하이픈을 가지고 무엇을 할지 먼저 생각해 보자. 변수
|ha|와 |hb| 따위가 무엇이었는지 잊기 전에 프로그램의 이 부분을 다루는 편이 낫기 때문이다. 할 일은 낱말의 노드들을, 하이픈 자리마다
선택적 나눔이 들어간 새 노드 나열로 바꾸는 것이다.

@<전역 변수@>=
var @!hyf [65]int32 // 홀수 값은 선택적 하이픈을 나타낸다; |0..9|
var @!initList pointer // 낱말 앞의 문장 부호 문자들의 목록
var @!initLig bool // |initList|가 합자를 나타내는가?
var @!initLft bool // 그렇다면, 그 합자에 왼쪽 경계가 끼어 있었는가?

@ 하이픈을 넣는 동안 쓰는 지역 변수들이다.
@<하이픈 넣기의 지역 변수@>=
var i, j, l int32 // |hc|나 |hu|의 첨자; |0..65|
var q, r, s pointer // 목록을 다루는 임시 레지스터들
var bchar halfword // 하이픈 넣은 낱말의 경계 문자, 또는 |nonChar|

@ \TeX은 앞에 \.{\\lefthyphenmin}보다 적은 글자가 있거나 뒤에 \.{\\righthyphenmin}보다 적은 글자가 있는 하이픈은 결코 넣지 않는다. 그래서
짧은 낱말은 하이픈이 들어갈 가능성이 비교적 적다. 이를테면 plain \TeX의 기본값 2와 3에서는 다섯 글자보다 짧은 낱말에는 하이픈이
들어가지 않는다. 하이픈을 하나도 찾지 못했으면 문단을 하나도 바꾸지 않아도 되므로 시간을 아낄 수 있다.

@<하이픈을 하나도 찾지 못했으면...@>=
for j = lHyf; j <= hn-rHyf; j++ {
	if odd(hyf[j]) {
		goto found1
	}
}
return
found1:

@ 하이픈을 정말로 넣을 것이라면, \TeX은 먼저 |ha|와~|hb| 사이의 노드 부분 나열을 떼어 낸다. 보이지 않는 경계 문자와 앞의 문장 부호가
하이픈 넣은 낱말 안의 합자에 미친 효과를 지키려고, 왼쪽 경계나 앞 문자를 |hu[0]|에, 오른쪽 경계가 있으면 그것을 |bchar|에 저장한다.
글자 |hu[0]|이 재구성의 일부가 되어야 하면 |j=0|으로 하고, 그렇지 않으면 |j=1|로 한다. 변수 |s|는 현재 가로 목록의 꼬리를 가리키고,
|q|는 |hb| 다음의 노드를 가리킨다. 그래야 하이픈 넣은 낱말을 다시 짠 뒤에 이어 붙일 수 있다.

@<노드 |ha..hb|를 선택적 하이픈을...@>=
q = link(hb); setLink(hb, null); r = link(ha); setLink(ha, null); bchar = hyfBchar
if isCharNode(ha) {
	if font(ha) != hf {
		goto found2
	}
	initList = ha; initLig = false; hu[0] = qo(character(ha))
} else if typ(ha) == ligatureNode {
	@<|ha|가 합자 노드일 때 |initList|를 정한다@>
} else { // 문장 부호를 찾지 못했다. 왼쪽 경계를 찾아본다
	if !isCharNode(r) && typ(r) == ligatureNode && subtype(r) > 1 {
		goto found2
	}
	j = 1; s = ha; initList = null; goto commonEnding
}
s = curP // |typ(curP)=glueNode|이므로 |curP!=ha|다
for link(s) != ha {
	s = link(s)
}
j = 0; goto commonEnding
found2:
	s = ha; j = 0; hu[0] = 256; initLig = false; initList = null
commonEnding:
	flushNodeList(r)
	@<하이픈 넣은 낱말의 노드들을 재구성하고 선택적 하이픈을 끼워 넣는다@>
	flushList(initList)

@ 앞 절에서 |ha|가 합자 노드인 경우다. 그 합자를 이룬 문자들을 |initList|로 삼는다.

@<|ha|가 합자 노드일 때...@>=
if font(ligChar(ha)) != hf {
	goto found2
}
initList = ligPtr(ha); initLig = true; initLft = subtype(ha) > 1
hu[0] = qo(character(ligChar(ha)))
if initList == null && initLft {
	hu[0] = 256; initLig = false
} // 이 경우에는 합자를 처음부터 재구성한다
freeNode(ha, smallNodeSize)

@ 하이픈을 찾았다고 해서 싸움이 끝난 것은 아니라는 사실을 이제 마주해야 한다. 낱말을 다시 짜는 과정은 간단하지 않을 수
{\def\!{\kern-1pt}%
있다. 하이픈이 있으면 합자가 바뀔 수도 있기 때문이다. {\sl The \TeX book}은 낱말 ``difficult''의 어려움을 이야기하는데, 하이픈을 둘러싼
선택적 나눔의 내용은 그보다 훨씬 더 복잡할 수 있다. 합자로 \.{b\!c}, \.{c\!d}, \.{d\!e}, \.{e\!f}만 있는 글꼴에서 낱말 \.{abcdef}를
생각해 보자. 이 낱말이 \.b와 \.c 사이에 하이픈을 허락하면, 하이픈이 있을 때와 없을 때의 두 모양은 $\.a\,\.b\,\.-\,\.{c\!d}\,\.{e\!f}$와
$\.a\,\.{b\!c}\,\.{d\!e}\,\.f$다. 그러니 하이픈 하나를 넣으면 그 효과가 낱말의 나머지로 얼마든지 멀리 물결처럼 퍼질 수 있다. 그런
물결 속에 하이픈이 더 있으면 문제가 더 복잡해진다. 이를테면 방금 든 보기의 낱말에 \.c와 \.d 사이에도 하이픈을 넣을 수 있다면
그렇다. \TeX은 그런 기묘한 경우에 추가 하이픈을 그냥 무시해서 이 문제를 피한다.}

원래 문자들을 지우지 않는 합자가 있으면 문제가 더욱 복잡해진다. 하이픈을 넣을 낱말 앞에 문장 부호가 있으면 \TeX의 방법은 모든 가능한
경우에 완벽하지는 않다. 문장 부호와 글자가 정보를 앞뒤로 퍼뜨릴 수 있기 때문이다. 이를테면 하이픈 넣기 전의 원래 쌍 \.{*a}가 \.{\?=:}
합자로 \.{*y}로 바뀌고, 그것이 다시 \.{=:\?} 합자로 \.{xy}로 바뀐다고 하자. 그리고 $p_{a-1}=\.x$이고 $p_a=\.y$이면 재구성
프로시저는 \.{xy}를 다시 얻을 만큼 영리하지 못하다. 그런 경우 글꼴 디자이너는 \.{xa}에서 \.{xy}로 가는 합자를 넣어 두어야 한다.

@ 처리는 |reconstitute|라는 서브루틴이 수월하게 해 준다. 문자열 $x_j\ldots x_n$이 주어지면, 합자와 커닝으로 번역한 $x_j\ldots x_n$이
$y_1\ldots y_t$ 다음에 $x_{m+1}\ldots x_n$의 번역이 오는 꼴이 되는 가장 작은 첨자 $m\ge j$가 있다. 여기서 $y_1\ldots y_t$는 문자,
합자, 커닝 노드의 비어 있지 않은 나열이다. 앞부분 $x_j\ldots x_m$을 $x_j\ldots x_n$의 ``잘린 머리''(cut prefix)라고 부른다. 이를테면
$x_1x_2x_3=\.{fly}$이고 글꼴에 `fl' 합자와 `fl'과 `y' 사이의 커닝이 있으면, $m=2$, $t=2$이고, $y_1$은 `fl'의 합자 노드, 그다음은
알맞은 커닝 노드~$y_2$다. 가장 흔한 경우에는 $x_j$가 $x_{j+1}$과 합자를 이루지 않고, 그냥 $m=j$, $y_1=x_j$다. 그리고 $m<n$이면
$x_{m+1}\ldots x_n$에 이 과정을 되풀이해서 번역 전체를 얻을 수 있다.

함수 |reconstitute|는 정수 $m$을 돌려주고, 노드 $y_1\ldots y_t$를 |link(holdHead)|에서 시작하는 연결 목록에 넣는다. 입력 $x_j\ldots x_n$은
배열 |hu|에서 얻는다. 그리고 $x_j=256$이면 $x_j$를 보이지 않는 왼쪽 경계 문자로 여긴다. 이때 |j|는 |n|보다 반드시 작아야 한다. 매개변수
|bchar|는 256이거나, $x_n$ 바로 뒤에 있다고 보는 보이지 않는 오른쪽 경계 문자다. (|hu[n+1]|의 값은 결코 실제로 읽지 않지만, 알고리즘은
거기에 |bchar|가 있다고 상상한다.)

범위 $j\le k\le m$에서 |hyf[k]|가 홀수이고, $x_{k+1}$이 |hchar|였다면 |reconstitute|의 결과가 달라졌을 첨자 |k|가 있으면, |reconstitute|는
|hyphenPassed|를 그런 |k| 가운데 가장 작은 것으로 정한다. 곧 하이픈이 합자 안으로 끼어드는 자리다. 그렇지 않으면 |hyphenPassed|를 0으로
한다.

첨자가 |j=0|인 경우에는 특별한 관례를 쓴다. 그때는 |hu[0]|의 번역이 |initList|에서 시작하는 특별한 문자 노드 목록에 있다고 가정한다.
게다가 |initLig|가 |true|이면 |hu[0]|은 합자 문자이고, |initLft|가 |true|이면 그 합자에 왼쪽 경계가 끼어 있다. 이 기능은 하이픈을 넣을
낱말 앞에, 낱말 처음의 번역에 영향을 줄 수 있는 문장 부호(이를테면 작은따옴표나 큰따옴표)가 있는 경우를 위한 것이다.

@<전역 변수@>=
var @!hyphenPassed smallNumber // 합자 안의 첫 하이픈, 있으면

@ 함수 |reconstitute| 안에서 쓰는 작은 함수 |appendCharnodeToT|, |setCurR|, |wrapLig|, |popLigStack|은 |reconstitute|의 지역 변수를
쓰므로 그 안의 함수 리터럴로 둔다. 이 함수들은 아래 여러 절에서 정의한다.

@<|reconstitute|라는...@>=
func reconstitute(j, n smallNumber, bchar, hchar halfword) smallNumber {
	var p pointer // 목록을 다루는 임시 레지스터
	var t pointer // 덧붙여 나가는 노드
	var q fourQuarters // 문자 정보나 합자/커닝 명령
	var curRh halfword // 합자 검사를 위한 하이픈 문자
	var testChar halfword // 합자 검사를 위한 하이픈이나 다른 문자
	var w scaled // 커닝의 양
	var k fontIndex // 현재 합자/커닝 명령의 자리
	@<|reconstitute| 안의 작은 함수들@>@;
	hyphenPassed = 0; t = holdHead; w = 0; setLink(holdHead, null)
	// 이 시점에서 |ligaturePresent=lftHit=rtHit=false|
	@<커서가 자리 |j| 뒤에 오도록 자료 구조를 마련한다@>
again:
	@<커서 자리에 합자나 커닝이 있으면 자료 구조를 갱신한다@>
	@<번역에 합자나 커닝을 덧붙이고, 합자 스택이 비어 있지 않으면 |goto again|@>
	return j
}

@ 재구성 프로시저는 \TeX이 하이픈을 넣기 전에 낱말을 처리할 때 쓴 전역 자료 구조 여럿을 함께 쓴다. 문자 |curL|과 |curR| 사이에 보이지
않는 ``커서''가 있다. 이 두 문자 사이에 합자가 일어날 수 있는지 검사한다. 그리고 |ligaturePresent|이면 |curL|은 현재 번역 목록에서
|curQ| 다음의 원래 문자들로 만든 합자 문자다. 커서와 문자 |j+1| 사이에는 ``합자 스택''이 있는데, 이것은 |link| 필드로 이어진 가짜
합자 노드들이다. 합자 명령이 나중에 처리해야 할 새 문자를 만들지 않았으면 이 스택은 대개 비어 있다. 가짜 합자는 잠재적 합자를
나타내는 |character| 필드와, |charNode|를 가리키거나 |null|인 |ligPtr| 필드를 가진 특별한 노드다. 문자 |curR|은 다음과 같이 정해진다.
스택이 |ligStack>null|이면 |curR=character(ligStack)|이고, |ligStack=null|이고 |j<n|이면 |curR=qi(hu[j+1])|이며, |ligStack=null|이고
|j=n|이면 |curR=bchar|다.

@<전역 변수@>=
var @!curL, @!curR halfword // 커서 앞뒤의 문자
var @!curQ pointer // 합자를 떼어 낼 곳
var @!ligStack pointer // 커서 오른쪽에 남은 일
var @!ligaturePresent bool // |curL|을 위한 합자 노드를 만들어야 하는가?
var @!lftHit, @!rtHit bool // 경계 문자와의 합자를 만났는가?

@ 번역 목록의 끝 |t|에 문자 노드를 덧붙이는 함수와, 커서 오른쪽 문자 |curR|과 하이픈 문자 |curRh|를 정하는 함수다.
@<|reconstitute| 안의 작은 함수들@>=
appendCharnodeToT := func(c quarterword) {
	setLink(t, getAvail()); t = link(t)
	setFontField(t, hf); setCharacter(t, c)
}
setCurR := func() {
	if j < n { curR = qi(hu[j+1]) } else { curR = bchar }
	if odd(hyf[j]) { curRh = hchar } else { curRh = nonChar }
}

@ 커서를 자리 |j| 뒤에 둔다. 자리가 |j=0|이면 앞의 문장 부호 목록 |initList|를 번역 목록에 먼저 옮겨 둔다.
@<커서가 자리 |j| 뒤에...@>=
curL = qi(hu[j]); curQ = t
if j == 0 {
	ligaturePresent = initLig; p = initList
	if ligaturePresent {
		lftHit = initLft
	}
	for p > null {
		appendCharnodeToT(character(p)); p = link(p)
	}
} else if curL < nonChar {
	appendCharnodeToT(curL)
}
ligStack = null; setCurR()

@ 합자/커닝 프로그램을 두 번, 곧 하이픈에 대해 한 번, 보통 글자에 대해 한 번 보아야 할 수도 있다. (프로그램에서 하이픈이 그 글자보다
뒤에 나올 수도 있으므로, 둘을 한꺼번에 찾으려 하지 않는 편이 낫다.) 처리는 커서가 움직일 때까지 이어지는데, 그동안 |j|가 늘 수도 있다.

@<커서 자리에 합자나 커닝이...@>=
if curL == nonChar {
	k = bcharLabel[hf]
	if k == nonAddress { goto done } else { q = fontInfo[k].qqqq }
} else {
	q = charInfo(hf, curL)
	if charTag(q) != ligTag {
		goto done
	}
	k = ligKernStart(hf, q); q = fontInfo[k].qqqq
	if skipByte(q) > stopFlag {
		k = ligKernRestart(hf, q); q = fontInfo[k].qqqq
	}
} // 이제 |k|는 합자/커닝 프로그램의 시작 주소다
if curRh < nonChar { testChar = curRh } else { testChar = curR }
for {
	@<합자/커닝 명령 |q|가 |testChar|와 맞으면 처리한다@>
	if skipByte(q) >= stopFlag {
		if curRh == nonChar {
			goto done
		}
		curRh = nonChar; goto again
	}
	k = k + qo(skipByte(q)) + 1; q = fontInfo[k].qqqq
}
done:

@ 앞 절의 루프 몸통이다. 하이픈과 맞으면 |hyphenPassed|를 정하고, 보통 문자와 맞으면 합자로 바꾸거나 커닝을 기억해 둔다.

@<합자/커닝 명령 |q|가...@>=
if nextChar(q) == testChar && skipByte(q) <= stopFlag {
	if curRh < nonChar {
		hyphenPassed = j; hchar = nonChar; curRh = nonChar
		goto again
	}
	if hchar < nonChar && odd(hyf[j]) {
		hyphenPassed = j; hchar = nonChar
	}
	if opByte(q) < kernFlag {
		@<합자 대체를 수행하고 커서 구조를 갱신한다@>
	}
	w = charKern(hf, q); goto done // 이 커닝은 아래에서 넣는다
}

@ 커서 왼쪽의 문자를, 합자이면 합자 노드로 감싸 번역 목록에 덧붙인다. 경계 문자와의 합자였으면 |subtype|에 표시한다. 합자 스택에서
하나를 꺼내는 함수도 여기 둔다.
@<|reconstitute| 안의 작은 함수들@>=
wrapLig := func(b bool) {
	if ligaturePresent {
		p = newLigature(hf, curL, link(curQ))
		if lftHit {
			setSubtype(p, 2); lftHit = false
		}
		if b && ligStack == null {
			setSubtype(p, subtype(p)+1); rtHit = false
		}
		setLink(curQ, p); t = p; ligaturePresent = false
	}
}
popLigStack := func() {
	if ligPtr(ligStack) > null {
		setLink(t, ligPtr(ligStack)) // 이것은 |hu[j+1]|의 문자 노드다
		t = link(t); j++
	}
	p = ligStack; ligStack = link(p); freeNode(p, smallNodeSize)
	if ligStack == null { setCurR() } else { curR = character(ligStack) }
} // |ligStack|이 |null|이 아니면 |curRh=nonChar|다

@ 번역에 합자나 커닝을 덧붙인다. 합자 스택이 비지 않았으면 그 맨 위를 새 |curL|로 삼아 계속한다.
@<번역에 합자나 커닝을...@>=
wrapLig(rtHit)
if w != 0 {
	setLink(t, newKern(w)); t = link(t); w = 0
}
if ligStack > null {
	curQ = t; curL = character(ligStack); ligaturePresent = true
	popLigStack(); goto again
}

@ 합자 대체를 하고 커서 구조를 고친다. 그러면서 |j|가 늘 수도 있다. 커서가 나아가지 않으면 |goto again|하고, 나아가면 |goto done|한다.
합자의 여덟 가지(\secref{tfm-ligkern})를 저마다 처리한다.

@<합자 대체를 수행하고...@>=
if curL == nonChar {
	lftHit = true
}
if j == n && ligStack == null {
	rtHit = true
}
checkInterrupt() // 끝없는 합자 루프가 있을 때 빠져나갈 길을 둔다
switch opByte(q) {
case qi(1), qi(5): curL = remByte(q); ligaturePresent = true // \.{=:\?}, \.{=:\?>}
case qi(2), qi(6): @<|curR|을 바꾸고 합자 스택을 마련한다@> // \.{\?=:}, \.{\?=:>}
case qi(3): // \.{\?=:\?}
	curR = remByte(q)
	p = ligStack; ligStack = newLigItem(curR); setLink(ligStack, p)
case qi(7), qi(11): // \.{\?=:\?>}, \.{\?=:\?>>}
	wrapLig(false)
	curQ = t; curL = remByte(q); ligaturePresent = true
default: // \.{=:}
	curL = remByte(q); ligaturePresent = true
	if ligStack > null {
		popLigStack()
	} else if j == n {
		goto done
	} else {
		appendCharnodeToT(curR); j++; setCurR()
	}
}
if opByte(q) > qi(4) && opByte(q) != qi(7) {
	goto done
}
goto again

@ 앞 절의 코드에서 떼어 낸 부분이다. 새 문자를 커서 오른쪽에 넣는다. 합자 스택이 비어 있으면 새 가짜 합자 노드를 만든다.

@<|curR|을 바꾸고 합자 스택을...@>=
curR = remByte(q)
if ligStack > null {
	setCharacter(ligStack, curR)
} else {
	ligStack = newLigItem(curR)
	if j == n {
		bchar = nonChar
	} else {
		p = getAvail(); setLigPtr(ligStack, p)
		setCharacter(p, qi(hu[j+1])); setFontField(p, hf)
	}
}

@ 이제 찾아낸 잠재적 하이픈들을 넣을 차례다. 다음 프로그램이 실행될 때 우리는 낱말 |hu[1 .. hn]|을 노드 |ha| 뒤에 덧붙이고, 그 결과에
노드 |q|를 덧붙이고 싶다. 이 과정에서 변수 |i|는 |hu|의 임시 첨자이고, 변수 |j|는 |hu|에서 현재 위치의 첨자이며, 변수 |l|은 선택적
나눔 갈래에서 |j|에 대응하는 것이다. 변수 |r|은 새로 만드는 노드를 가리킨다. 그리고 새 지역 변수가 몇 개 필요하다.

@<하이픈 넣기의 지역...@>=
var majorTail, minorTail pointer // 재구성하고 있는 주 갈래와 선택적 나눔 갈래의 목록 끝
var c asciiCode // 하이픈으로 잠시 바꾼 문자
var cLoc int32 // 그 문자가 있던 곳; |0..63|
var rCount int32 // 선택적 나눔의 대체 개수
var hyfNode pointer // 하이픈, 있으면

@ 낱말의 처음부터 잘린 머리를 하나씩 다시 짜서 목록에 잇는다. 잘린 머리 안이나 바로 뒤에 하이픈 자리가 있으면 선택적 나눔을 만든다.
다음 코드가 실행될 때 |hyf[0]|과 |hyf[hn]|은 0이다.

@<하이픈 넣은 낱말의 노드들을...@>=
for {
	l = j; j = reconstitute(j, hn, bchar, qi(hyfChar)) + 1
	if hyphenPassed == 0 {
		setLink(s, link(holdHead))
		for link(s) > null {
			s = link(s)
		}
		if odd(hyf[j-1]) {
			l = j; hyphenPassed = j - 1; setLink(holdHead, null)
		}
	}
	if hyphenPassed > 0 {
		@<하이픈 없는 낱말의 대안으로 선택적 나눔 노드를 만들어 덧붙인다@>
	}
	if j > hn {
		break
	}
}
setLink(s, q)

@ 이 반복 루프에서는 앞 선택적 나눔의 두 갈래가 모두 자리 |j-1|에서 끝날 때 |hyf[j-1]|이 홀수이면 선택적 나눔을 하나 더 넣는다. 엄밀히
말하면 이렇게 하는 것은 정당하지 않다. 자리 |j-1| 뒤의 하이픈이 그 갈래들과 정말로 독립인지 모르기 때문이다. 그러나 거의 모든
응용에서 잠재적으로 값진 하이픈 자리를 잃지 않는 쪽을 택할 것이다. (`difficult'라는 낱말을 생각해 보라. 여기서 글자 `c'가 자리 |j|에
있다.)

나누는 경우의 텍스트(나눔 앞과 뒤)와 나누지 않는 경우의 텍스트가 같은 자리에서 끝날 때까지 두 갈래를 계속 키워 나간다.

꼬리를 한 칸 옮기는 일, 곧 `|majorTail=link(majorTail); rCount++|'는 두 곳에서 펼쳐 쓴다.

@<하이픈 없는 낱말의 대안으로...@>=
for {
	r = getNode(smallNodeSize)
	setLink(r, link(holdHead)); setType(r, discNode)
	majorTail = r; rCount = 0
	for link(majorTail) > null {
		majorTail = link(majorTail); rCount++ // |advanceMajorTail|
	}
	i = hyphenPassed; hyf[i] = 0
	@<문자 |hu[l..i]|와 하이픈을 |preBreak(r)|에 넣는다@>
	@<문자 |hu[i+1 ..]|를 |postBreak(r)|에 넣고 두 갈래를 맞춘다@>
	@<포인터 |s|를 현재 목록의 끝으로 옮기고 |replaceCount(r)|를 정한다@>
	hyphenPassed = j - 1; setLink(holdHead, null)
	if !odd(hyf[j-1]) {
		break
	}
}

@ 나눔 앞 텍스트를 만든다. 하이픈 문자를 낱말의 그 자리에 잠시 넣고 다시 짜므로, 새 하이픈은 앞 문자와 합자나 커닝을 이룰 수도 있다.
이 시점에서 |l-1<=i<j|이고 |i<hn|이다.

@<문자 |hu[l..i]|와 하이픈을...@>=
minorTail = null; setPreBreak(r, null); hyfNode = newCharacter(hf, hyfChar)
if hyfNode != null {
	i++; c = hu[i]; hu[i] = hyfChar; freeAvail(hyfNode)
}
for l <= i {
	l = reconstitute(l, i, fontBchar[hf], nonChar) + 1
	if link(holdHead) > null {
		if minorTail == null {
			setPreBreak(r, link(holdHead))
		} else {
			setLink(minorTail, link(holdHead))
		}
		minorTail = link(holdHead)
		for link(minorTail) > null {
			minorTail = link(minorTail)
		}
	}
}
if hyfNode != null {
	hu[i] = c // 하이픈 자리의 문자를 되돌린다
	l = i; i--
}

@ 나눔 뒤 텍스트를 만든다. 맞추기 알고리즘은 |l=i+1<=j|로 시작한다. 문자들을 |postBreak(r)|에 넣으면서, 두 갈래가 맞추어질 때까지 이
목록과 |majorTail|에 덧붙여 나간다. 새 줄의 처음에는 왼쪽 경계 문자를 둔다.

@<문자 |hu[i+1 ..]|를...@>=
minorTail = null; setPostBreak(r, null); cLoc = 0
if bcharLabel[hf] != nonAddress { // 새 줄의 처음에 왼쪽 경계를 둔다
	l--; c = hu[l]; cLoc = l; hu[l] = 256
}
for l < j {
	for {
		l = reconstitute(l, hn, bchar, nonChar) + 1
		if cLoc > 0 {
			hu[cLoc] = c; cLoc = 0
		}
		if link(holdHead) > null {
			if minorTail == null {
				setPostBreak(r, link(holdHead))
			} else {
				setLink(minorTail, link(holdHead))
			}
			minorTail = link(holdHead)
			for link(minorTail) > null {
				minorTail = link(minorTail)
			}
		}
		if l >= j {
			break
		}
	}
	for l > j {
		@<|hu[j..]|의 문자들을 |majorTail|에 덧붙이며 |j|를 늘린다@>
	}
}

@ 나누지 않는 경우의 텍스트도 같은 자리까지 다시 짜서 |majorTail| 뒤에 잇는다.
@<|hu[j..]|의 문자들을...@>=
j = reconstitute(j, hn, bchar, nonChar) + 1
setLink(majorTail, link(holdHead))
for link(majorTail) > null {
	majorTail = link(majorTail); rCount++ // |advanceMajorTail|
}

@ 합자를 끼워 넣으면 낱말의 크기가 지수적으로 커질 수 있다. 그래서 하이픈을 넣은 텍스트가 많아야 63자였어도 여기서 |rCount|의 크기를
검사해야 한다. 대체 개수는 쿼터워드에 들어가야 하기 때문이다.

@<포인터 |s|를 현재 목록의...@>=
if rCount > 127 { // 선택적 하이픈을 잊어야 한다
	setLink(s, link(r)); setLink(r, null); flushNodeList(r)
} else {
	setLink(s, r); setReplaceCount(r, rCount)
}
s = majorTail

@* 하이픈 넣기.
낱말 |hc[1 .. hn]|이 하이픈 넣기 후보를 담도록 마련되면, \TeX은 먼저 그 낱말이 사용자의 예외 사전에 있는지 본다. 없으면 주어진
낱말 안에 나타나는 패턴에 바탕을 두고 하이픈을 넣는데, 이때 프랭크~M. 리앙(Frank M. Liang)의 알고리즘을 쓴다.
@^Liang, Franklin Mark@>

예외 찾기 루틴보다 훨씬 흥미로우므로 리앙의 방법부터 살펴보자. 알고리즘은 모든 |j|에 대해 |hyf[j]|를 0으로 하고, 구분자 구실을
하도록 |hc[0]|과 |hc[hn+1]|에 무효한 문자를 넣는 것으로 시작한다. 그런 다음 주어진 패턴 집합 가운데 어느 것이 낱말
|hc[0 .. (hn+1)]| 안에 나타나는지 꽤 빠른 방법으로 알아본다. 길이 |k|인 각 패턴 $p_1\ldots p_k$에는 |k+1|개의 수 $n_0\ldots n_k$로
된 나열이 딸려 있다. 패턴이 |hc[(j+1)..(j+k)]|에 나타나면 \TeX은 |0<=i<=k|에 대해 |hyf[j+i]=@tmax@>(hyf[j+i],@t$n_i$@>)|로
한다. 나타나는 패턴마다 이 일을 하고 나면, 이미 보았듯이 |hyf[j]|가 홀수일 때 |hc[j]|와 |hc[j+1]| 사이에 선택적 하이픈이 들어간다.

보기를 하나 들자. plain \TeX의 패턴들 가운데 낱말 `\.{hyphenation}'에 나타나는 것은 다음 아홉 개다.
패턴 안의 수는 그 자리의 값이고, 수가 없는 자리의 값은 0이다. 낱말의 글자 사이마다 모든 패턴의 값
가운데 가장 큰 것을 취하면 맨 아래 줄을 얻는다.
$$\vbox{\tabskip=1.5pt\halign{\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil&\hfil#\hfil\cr
&\.{h}&&\.{y}&&\.{p}&&\.{h}&&\.{e}&&\.{n}&&\.{a}&&\.{t}&&\.{i}&&\.{o}&&\.{n}&\cr
\noalign{\smallskip\hrule\smallskip}
&\.{h}&&\.{y}&{\sevenrm 3}&\.{p}&&\.{h}&&&&&&&&&&&&&&&\cr
&&&&&&&\.{h}&&\.{e}&{\sevenrm 2}&\.{n}&&&&&&&&&&&\cr
&&&&&&&\.{h}&&\.{e}&&\.{n}&&\.{a}&{\sevenrm 4}&&&&&&&&\cr
&&&&&&&\.{h}&&\.{e}&&\.{n}&{\sevenrm 5}&\.{a}&&\.{t}&&&&&&&\cr
&&&&&&&&&&{\sevenrm 1}&\.{n}&&\.{a}&&&&&&&&&\cr
&&&&&&&&&&&\.{n}&{\sevenrm 2}&\.{a}&&\.{t}&&&&&&&\cr
&&&&&&&&&&&&&&{\sevenrm 1}&\.{t}&&\.{i}&&\.{o}&&&\cr
&&&&&&&&&&&&&&&&{\sevenrm 2}&\.{i}&&\.{o}&&&\cr
&&&&&&&&&&&&&&&&&&&\.{o}&{\sevenrm 2}&\.{n}&\cr
\noalign{\smallskip\hrule\smallskip}
&\.{h}&{\sevenrm 0}&\.{y}&{\sevenrm 3}&\.{p}&{\sevenrm 0}&\.{h}&{\sevenrm 0}&\.{e}&{\sevenrm 2}&\.{n}&{\sevenrm 5}&\.{a}&{\sevenrm 4}&\.{t}&{\sevenrm 2}&\.{i}&{\sevenrm 0}&\.{o}&{\sevenrm 2}&\.{n}&\cr
}}$$
홀수는 나눌 수 있는 곳이고 짝수는 나누면 안 되는 곳이므로, 낱말은 `\.{hy-phen-ation}'으로 나뉜다.
패턴들이 홀짝을 번갈아 가며 서로의 판정을 뒤집는 모습에 주목하라. 이를테면 \.{1na}는
`\.{hyphe-nation}'을 허락하지만 \.{he2n}이 그것을 막고, \.{n2at}는 `\.{hyphen-ation}'을 막지만 더 긴
패턴 \.{hen5at}가 더 큰 수로 그것을 다시 허락한다. 마찬가지로 \.{1tio}가 허락하는 `\.{hyphena-tion}'은
\.{hena4}가 막는다. 수가 클수록 더 특수한 예외를 나타내는 것이다.

패턴 $p_1\ldots p_k$와 딸린 수 $n_0\ldots n_k$의 집합은 물론 하이픈을 넣을 낱말의 언어와, 원하는 하이픈 넣기의 정도에 따라
달라진다. 주어진 낱말 사전과 받아들일 수 있는 하이픈 넣기로부터 알맞은 |p|와 |n|을 찾는 방법은 리앙의 박사 학위 논문(Stanford
University, 1983)에서 논의한다. \TeX은 그저 패턴에서 출발해서 일한다.

@ 패턴은 조밀하면서도 꺼내 쓰기에 효율적인 표에 저장한다. ``트라이(trie) 메모리''[{\sl The Art of Computer Programming \bf3} (1973),
481--505 참조]를 조금 바꾼 것이다. 관련된 언어 번호보다 하나 큰 수를 $z_0$으로 하고, |1<=i<=k|에 대해 |@t$z_i$@>=trieLink@t$(z_{i-1})+p_i$@>|로
하면 패턴 $p_1\ldots p_k$를 찾아갈 수 있다. 패턴은 수 $z_k$로 식별된다. 모든 패턴 정보가 하나의 |trieLink| 배열에 함께 채워져 있으므로,
서로 다른 패턴의 자료가 뒤섞이지 않게 해야 한다. 그래서 모든 |i|에 대해 |trieChar@t$(z_i)=p_i$@>|인 표를 하나 더 두어, 찾아간 자리가
정말로 그 글자의 것인지 확인한다. 또 $p_1\ldots p_k$에 딸린 수 $n_0\ldots n_k$를 식별하는 표 |trieOp|$(z_k)$도 있다.

실제로 나타나는 수 나열 $n_0\ldots n_k$는 몇 가지 안 된다. 대부분의 |n|은 0이기 때문이다. 그래서 수 나열은 |trieOp|$(z_k)$가 한 바이트가
되도록 부호화한다. 언어 |t|에서 $p_1\ldots p_k$가 |hc[(l-k+1)..l@,]|의 글자들과 맞았고 |trieOp(@t$z_k$@>)!=minQuarterword|이면, 다음 작은
프로그램을 실행해서 이 패턴에 필요한 연산을 모두 한다. 먼저 |v=trieOp(@t$z_k$@>)|로 한다. 그런 다음 |v=v+opStart[t]|,
|hyf[l-hyfDistance[v]]=@tmax@>(hyf[l-hyfDistance[v]], hyfNum[v])|, |v=hyfNext[v]|로 한다. 필요하면 |v=minQuarterword|가 될 때까지
되풀이한다. 곧 0이 아닌 $n_i$마다 그 자리와 값을 담은 연산 하나가 있고, 연산들이 사슬로 이어져 있다.

@<전역 형@>=
type @!triePointer = int32 // |trie|의 첨자; |0 .. trieSize|

@ @<정의@>=
func trieLink(p triePointer) halfword { return trie[p].rh } // 트라이의 ``아래로'' 가는 링크
func setTrieLink(p triePointer, v halfword) { trie[p].rh = v }
func trieChar(p triePointer) quarterword { return trie[p].b1 } // 이 트라이 자리에서 맞춘 문자
func setTrieChar(p triePointer, v quarterword) { trie[p].b1 = v }
func trieOp(p triePointer) quarterword { return trie[p].b0 } // 이 트라이 자리의 하이픈 넣기 프로그램
func setTrieOp(p triePointer, v quarterword) { trie[p].b0 = v }

@ 다음 배열들의 첨자는 1부터 |trieOpSize|까지이므로, 길이를 |trieOpSize+1|로 잡고 첨자 0은 쓰지 않는다. 배열 |opStart|는 언어마다
연산 번호가 시작하는 곳을 알려 준다.

@<전역 변수@>=
var @!trie [trieSize + 1]twoHalves // |trieLink|, |trieChar|, |trieOp|
var @!hyfDistance [trieOpSize + 1]smallNumber // $n_j$의 자리 |k-j|
var @!hyfNum [trieOpSize + 1]smallNumber // $n_j$의 값
var @!hyfNext [trieOpSize + 1]quarterword // 이어지는 코드
var @!opStart [256]int32 // 현재 언어의 오프셋; |0 .. trieOpSize|

@ @<하이픈 넣기의 지역...@>=
var z triePointer // |trie|의 첨자
var v int32 // |hyfDistance| 따위의 첨자

@ 이런 보조 표들이 제대로 마련되어 있다고 하면 하이픈 넣기 알고리즘은 꽤 짧다. 먼저 예외 표를 보고, 거기 없으면 낱말의 모든
시작 위치 |j|에서 트라이를 따라 내려가며 맞는 패턴을 모두 찾는다. 다음 코드에서는 |hc[hn+3]|을 결코 꺼내지 않도록 |hc[hn+2]|를
불가능한 값 256으로 한다. 끝으로 \.{\\lefthyphenmin}과 \.{\\righthyphenmin}에 걸리는 자리의 값을 지운다.

@<|hc|에 있는 낱말의 하이픈 자리를...@>=
for j = 0; j <= hn; j++ {
	hyf[j] = 0
}
@<낱말 |hc[1 .. hn]|을 예외 표에서 찾고, 있으면 |goto found|@>
if trieChar(triePointer(curLang)+1) != qi(curLang) {
	return // |curLang|의 패턴이 없다
}
hc[0] = 0; hc[hn+1] = 0; hc[hn+2] = 256 // 구분자를 넣는다
for j = 0; j <= hn-rHyf+1; j++ {
	z = trieLink(triePointer(curLang)+1) + hc[j]; l = j
	for hc[l] == qo(trieChar(z)) {
		if trieOp(z) != minQuarterword {
			@<|hyf| 표에 최댓값들을 저장한다@>
		}
		l++; z = trieLink(z) + hc[l]
	}
}
found:
	for j = 0; j <= lHyf-1; j++ {
		hyf[j] = 0
	}
	for j = 0; j <= rHyf-1; j++ {
		hyf[hn-j] = 0
	}

@ 맞은 패턴의 연산 사슬을 따라가며 |hyf|의 값을 최댓값으로 고친다.
@<|hyf| 표에 최댓값들을...@>=
v = trieOp(z)
for {
	v += opStart[curLang]; i = l - hyfDistance[v]
	if hyfNum[v] > hyf[i] {
		hyf[i] = hyfNum[v]
	}
	v = hyfNext[v]
	if v == minQuarterword {
		break
	}
}

@ \TeX의 원시 명령 \.{\\hyphenation}이 만드는 예외 표는 선형 탐사를 쓰는 순서 해시 표[Amble and Knuth, {\sl The Computer
@^Amble, Ole@> @^Knuth, Donald Ervin@>
Journal \bf17} (1974), 135--142 참조]로 짜여 있다. 낱말 $\alpha$와 $\beta$에 대해, $\vert\alpha\vert<\vert\beta\vert$이거나,
$\vert\alpha\vert=\vert\beta\vert$이고 $\alpha$가 사전 순으로 $\beta$보다 앞서면 $\alpha<\beta$라고 하자. (표기 $\vert\alpha\vert$는
$\alpha$의 길이다.) 순서 해싱의 생각은, 표를 잘 배치해서 낱말 $\alpha$를 찾을 때 해시 주소 $h=h(\alpha)$를 계산한 다음 표의 자리 |h|,
|h-1|, \dots를 차례로 보다가 $\le\alpha$인 첫 낱말을 만나면 멈출 수 있게 하는 것이다. 그 낱말이 $\alpha$와 다르면 $\alpha$가 표에 없다고
결론지을 수 있다. 찾지 못하는 경우에도 빈칸까지 갈 필요 없이 일찍 멈출 수 있다는 것이 장점이다.

표의 낱말마다 |info| 필드에 하이픈 자리를 담은 |mem|의 목록을 가리킨다. 낱말 $c_1\ldots c_n$에 $c_k$와 $c_{k+1}$ 사이의 선택적
하이픈이 있으면 그 목록에 수 |k|가 들어 있다.

@<전역 형@>=
type @!hyphPointer = int32 // 순서 해시 표의 첨자; |0 .. hyphSize|

@ @<전역 변수@>=
var @!hyphWord [hyphSize + 1]strNumber // 예외 낱말
var @!hyphList [hyphSize + 1]pointer // 하이픈 자리 목록
var @!hyphCount hyphPointer // 예외 사전의 낱말 수

@ @<초기화를 위한 지역 변수@>=
var @!z hyphPointer // 예외 사전을 훑는다

@ 처음에는 예외 사전이 비어 있다.
@<핵심 변수들의...@>=
for z = 0; z <= hyphSize; z++ {
	hyphWord[z] = 0; hyphList[z] = null
}
hyphCount = 0

@ 지역 변수가 몇 개 더 있으면 예외 찾기 알고리즘은 꽤 간단하다.

@<하이픈 넣기의 지역...@>=
var h hyphPointer // |hyphWord|와 |hyphList|의 첨자
var k strNumber // |strStart|의 첨자
var u poolPointer // |strPool|의 첨자

@ 먼저 해시 코드 |h|를 계산하고, 낱말을 찾거나 찾지 못할 때까지 찾는다. 서로 다른 언어의 낱말은 문자열 끝에 언어 코드를 덧붙여서
구별한다. 그래서 같은 철자라도 언어마다 하이픈 자리를 달리 정할 수 있다. 낱말을 찾으면 |hyf|에 하이픈이 담긴 채로 |goto found|한다.

@<낱말 |hc[1 .. hn]|을 예외 표에서...@>=
h = hc[1]; hn++; hc[hn] = curLang
for j = 2; j <= hn; j++ {
	h = (h + h + hc[j]) % hyphSize
}
for {
	@<문자열 |hyphWord[h]|를 |hc[1 .. hn]|과 견준다@>
	if h > 0 { h-- } else { h = hyphSize }
}
notFound:
	hn--

@ 문자열 |hyphWord[h]|가 |hc[1 .. hn]|보다 작으면 |goto notFound|한다. 순서 해시 표에서는 더 작은 낱말을 만나면 찾는 낱말이 없다는
뜻이기 때문이다. 두 문자열이 같으면 |hyf|를 하이픈 자리로 정하고 |goto found|한다.

@<문자열 |hyphWord[h]|를 |hc[1 .. hn]|과...@>=
k = hyphWord[h]
if k == 0 {
	goto notFound
}
if length(k) < hn {
	goto notFound
}
if length(k) == hn {
	j = 1; u = strStart[k]
	for {
		if so(strPool[u]) < hc[j] {
			goto notFound
		}
		if so(strPool[u]) > hc[j] {
			goto done
		}
		j++; u++
		if j > hn {
			break
		}
	}
	@<|hyphList[h]|에 지정된 대로 하이픈을 넣는다@>
	hn--; goto found
}
done:

@ 예외 목록에 적힌 자리마다 |hyf|를 1로 한다.
@<|hyphList[h]|에 지정된...@>=
s = hyphList[h]
for s != null {
	hyf[info(s)] = 1; s = link(s)
}

@ 디버깅 루틴 |searchMem|을 위해 예외 표에서도 포인터를 찾는다.
@<|hyphList|에서 |p|를 가리키는...@>=
for q = 0; q <= hyphSize; q++ {
	if hyphList[q] == p {
		printNl("HYPH("); printInt(q); printChar(')')
	}
}

@ 이제 하이픈 넣기 루틴을 마쳤으므로, 프로시저 |lineBreak|도 마침내 끝났다. 하이픈 넣기 예외 표가 머릿속에 생생하니, 그 표에 새
항목을 더하는 루틴을 다루기에 좋은 때다.

\TeX이 `\.{\\hyphenation}'을 읽으면 |newHyphExceptions|라는 프로시저를 불러 알맞은 일을 한다. 이를테면
\.{\\hyphenation\{man-u-script man-u-scripts\}}는 두 낱말과 그 하이픈 자리를 예외 표에 넣는다.

현재 언어를 정하는 작은 함수 |setCurLang|은 네 곳에서 쓴다. 매개변수 \.{\\language}가 0부터 255까지의 범위 밖이면 언어 0으로 본다.

@<함수들@>=
func setCurLang() {
	if language() <= 0 {
		curLang = 0
	} else if language() > 255 {
		curLang = 0
	} else {
		curLang = language()
	}
}

func newHyphExceptions() { // 새 예외를 넣는다
	var n int32 // 현재 낱말의 길이; |0..64|, 늘 |smallNumber|인 것은 아니다
	var j int32 // |hc|의 첨자; |0..64|
	var h hyphPointer // |hyphWord|와 |hyphList|의 첨자
	var k strNumber // |strStart|의 첨자
	var p pointer // 하이픈 자리 목록의 머리
	var q pointer // 목록 |p|의 새 노드를 만들 때 쓴다
	var s, t strNumber // 비교하거나 저장하는 문자열
	var u, v poolPointer // |strPool|의 첨자
	scanLeftBrace() // \.{\\hyphenation} 뒤에는 왼쪽 중괄호가 와야 한다
	setCurLang()
	@<오른쪽 중괄호에 이를 때까지 나열된 하이픈 넣기 예외를 모두 넣고 |return|한다@>
}

@ 오른쪽 중괄호가 나올 때까지 낱말들을 읽는다. 글자는 소문자로 바꾸어 모으고, `\.-'를 만나면 그 자리를 기억하고, 공백이나 오른쪽
중괄호를 만나면 낱말 하나를 표에 넣는다.
@<오른쪽 중괄호에 이를 때까지 나열된 하이픈 넣기 예외를 모두 넣고 |return|한다@>=
n = 0; p = null
for {
	getXToken()
reswitch:
	switch curCmd {
	case letter, otherChar, charGiven: @<새 글자나 하이픈을 덧붙인다@>
	case charNum:
		scanCharNum(); curChr = curVal; curCmd = charGiven
		goto reswitch
	case spacer, rightBrace:
		if n > 1 {
			@<하이픈 넣기 예외 하나를 넣는다@>
		}
		if curCmd == rightBrace {
			return
		}
		n = 0; p = null
	default: @<부적절한 \.{\\hyphenation} 오류를 낸다@>
	}
}

@ 글자, 하이픈, 공백 말고 다른 것이 오면 오류를 알린다.
@<부적절한 \.{\\hyph...@>=
printErr("Improper "); printEsc("hyphenation")
@.Improper \\hyphenation...@>
printStr(" will be flushed")
help2("Hyphenation exceptions must contain only letters",
	"and hyphens. But continue; I'll forgive and forget.")
reportError()

@ 하이픈이면 지금까지의 글자 수를 목록 |p|에 넣고, 글자이면 소문자로 바꾸어 |hc|에 덧붙인다. 명령 \.{\\lccode}가 0인 문자는 글자가 아니다.
@<새 글자나 하이픈을...@>=
if curChr == '-' {
	@<목록 |p|에 값 |n|을 덧붙인다@>
} else {
	if lcCode(curChr) == 0 {
		printErr("Not a letter")
@.Not a letter@>
		help2("Letters in \\hyphenation words must have \\lccode>0.",
			"Proceed; I'll ignore the character I just read.")
		reportError()
	} else if n < 63 {
		n++; hc[n] = lcCode(curChr)
	}
}

@ 하이픈 자리 |n|을 목록 |p|에 덧붙인다.
@<목록 |p|에 값 |n|을...@>=
if n < 63 {
	q = getAvail(); setLink(q, p); setInfo(q, n); p = q
}

@ 낱말 하나를 예외 표에 넣는다. 끝에 언어 코드를 붙인 문자열을 만들고 해시 코드를 계산한다.
@<하이픈 넣기 예외 하나를...@>=
n++; hc[n] = curLang; strRoom(n); h = 0
for j = 1; j <= n; j++ {
	h = (h + h + hc[j]) % hyphSize
	appendChar(hc[j])
}
s = makeString()
@<쌍 |(s,p)|를 예외 표에 넣는다@>

@ 순서 해시 표에 넣는다. 자리 |h|부터 거꾸로 가면서, 넣을 쌍보다 작은 낱말을 만나면 둘을 맞바꾸어 큰 쪽을 그 자리에 두고 작은
쪽을 들고 계속 간다. 빈칸에 이르면 들고 있는 쌍을 거기 넣는다. 이렇게 하면 순서 해시 표의 성질이 지켜진다.
@<쌍 |(s,p)|를...@>=
if hyphCount == hyphSize {
	overflow("exception dictionary", hyphSize)
}
@:TeX capacity exceeded exception dictionary}{\quad exception dictionary@>
hyphCount++
for hyphWord[h] != 0 {
	@<문자열 |hyphWord[h]|가 |s| 이하이면 두 쌍을 맞바꾼다@>
	if h > 0 { h-- } else { h = hyphSize }
}
hyphWord[h] = s; hyphList[h] = p

@ 문자열 |hyphWord[h]|가 |s| 이하이면 |(hyphWord[h],hyphList[h])|와 |(s,p)|를 맞바꾼다.

@<문자열 |hyphWord[h]|가 |s| 이하이면...@>=
k = hyphWord[h]
if length(k) < length(s) {
	goto found
}
if length(k) > length(s) {
	goto notFound
}
u = strStart[k]; v = strStart[s]
for {
	if strPool[u] < strPool[v] {
		goto found
	}
	if strPool[u] > strPool[v] {
		goto notFound
	}
	u++; v++
	if u == strStart[k+1] {
		break
	}
}
found:
	q = hyphList[h]; hyphList[h] = p; p = q
	t = hyphWord[h]; hyphWord[h] = s; s = t
notFound: ;

@* 하이픈 넣기 표의 초기화.
\TeX의 하이픈 넣기 알고리즘이 쓰는 트라이는 \.{\\patterns} 지정 뒤에 오는 패턴들로 만든다. 그런 지정은 \.{INITEX}에서만 할 수 있다.
보조 표를 위한 추가 메모리와 초기화 프로그램 자체가 실무용 \TeX에서는 쓸데없는 군더더기일 뿐이기 때문이다. 실무용 \TeX은 포맷
파일에서 완성된 트라이를 읽어 오기만 한다.

첫 단계에서는 차례로 놓인 저장소에 바로 채워 넣지 않고, 연결로 이어진 트라이를 만든다. 그래야 패턴을 끼워 넣기 쉽다. 모든 패턴을
처리하고 나면 \.{INITEX}는 똑같은 부분 트라이들을 찾아내서 연결 트라이를 압축한다. 마지막으로 트라이를 하이픈 넣기 알고리즘이
실제로 쓰는 효율적인 순차 꼴로 채워 넣는다.

이 프로시저들은 \.{INITEX}에서만, 곧 |iniVersion|이 참일 때만 부른다.

@<|lineBreak|의 하위...@>=
@<하이픈 넣기 패턴을 전처리하는 프로시저들@>@;

@ 트라이 만들기를 자세히 이야기하기 전에, 배열 |hyfDistance|, |hyfNum|, |hyfNext|를 만드는 더 단순한 문제부터 생각해 보자.

이를테면 \TeX이 패턴 `\.{ab2cde1}'을 읽는다고 하자. 이것은 길이 5인 패턴이고, 앞의 표기로 $n_0\ldots n_5=0\,0\,2\,0\,0\,1$이다. 이에
대응하는 |trieOp| 코드 |v|는 |hyfDistance[v]=3|, |hyfNum[v]=2|, |hyfNext[v]=@t$v^\prime$@>|이어야 한다. 여기서 보조 |trieOp| 코드
$v^\prime$은 |hyfDistance[@t$v^\prime$@>]=0|, |hyfNum[@t$v^\prime$@>]=1|, |hyfNext[@t$v^\prime$@>]=minQuarterword|다. 곧 패턴 끝에서
3만큼 앞 자리에 2를, 끝 자리에 1을 적으라는 연산 둘이 사슬로 이어진 것이다.

\TeX은 아래의 서브루틴 |newTrieOp|로 알맞은 값 |v|를 계산한다. 곧
$$\hbox{|@t$v^\prime$@>=newTrieOp(0,1,minQuarterword)|,\qquad |v=newTrieOp(3,2,@t$v^\prime$@>)|}$$
로 한다. 이 서브루틴은 세 매개변수를 특별한 해시 표에서 찾아보고, 현재 언어에서 이 셋이 전에 나온 적이 없을 때에만 새 값을
배정한다. 그래서 같은 연산 사슬은 여러 패턴이 함께 쓴다.

이 해시 표를 |trieOpHash|라고 부르고, 거기 든 항목의 수는 |trieOpPtr|이다.

배열 |trieOpHash|의 첨자 범위는 |-trieOpSize..trieOpSize|다. \GO/의 배열은 첨자가 0부터 시작하므로, 첨자 |h|에 |trieOpSize|를 더해
쓴다.

@<전역 변수@>=
var @!trieOpHash [2*trieOpSize + 1]int32 // 네 짝의 트라이 연산 코드; |0 .. trieOpSize|
var @!trieUsed [256]quarterword // 이 언어에서 지금까지 쓴 가장 큰 연산 코드
var @!trieOpLang [trieOpSize + 1]asciiCode // 해시한 네 짝의 언어 부분
var @!trieOpVal [trieOpSize + 1]quarterword // 해시한 네 짝에 대응하는 연산 코드
var @!trieOpPtr int32 // 지금까지 저장한 연산의 수; |0 .. trieOpSize|

@ 다음 프로시저에서 |overflow| 정지를 없애고 싶은 유혹이 든다. 함수 |newTrieOp|가 작업을 중단하는 대신 |minQuarterword|를 돌려줄 수도
있을 것이다(그러면 하이픈 넣기 패턴의 일부를 그냥 무시하게 된다). 그러나 그러면 같은 패턴을 쓰는 서로 다른 \TeX 설치에서 하이픈 넣기
결과가 달라질 것이다. 그러니 |overflow| 정지는 패턴의 이식성을 위해 꼭 필요하다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func newTrieOp(d, n smallNumber, v quarterword) quarterword {
	var u quarterword // 시험 연산 코드
	var l int32 // 저장된 자료를 가리킨다; |0 .. trieOpSize|
	h := abs(n+313*d+361*v+1009*curLang)%(trieOpSize+trieOpSize) - trieOpSize // 시험 해시 자리; |-trieOpSize..trieOpSize|
	for {
		l = trieOpHash[trieOpSize+h]
		if l == 0 { // 새 연산을 위한 빈 자리를 찾았다
			if trieOpPtr == trieOpSize {
				overflow("pattern memory ops", trieOpSize)
			}
			u = trieUsed[curLang]
			if u == maxQuarterword {
				overflow("pattern memory ops per language", maxQuarterword-minQuarterword)
			}
			trieOpPtr++; u++; trieUsed[curLang] = u
			hyfDistance[trieOpPtr] = d
			hyfNum[trieOpPtr] = n; hyfNext[trieOpPtr] = v
			trieOpLang[trieOpPtr] = curLang; trieOpHash[trieOpSize+h] = trieOpPtr
			trieOpVal[trieOpPtr] = u; return u
		}
		if hyfDistance[l] == d && hyfNum[l] == n && hyfNext[l] == v && trieOpLang[l] == curLang {
			return trieOpVal[l]
		}
		if h > -trieOpSize { h-- } else { h = trieOpSize }
	}
}

@ 함수 |newTrieOp|가 연산 코드 정보를 다 모으고 나면, 하이픈 넣기 알고리즘에 필요한 최종 꼴로 자료를 풀어 놓을 만한 정보가 갖추어진다.
언어마다 연산 번호를 이어 붙이고(|opStart|), 해시 표에 흩어져 있던 연산들을 그 번호 차례로 옮긴다.

@<하이픈 넣기 연산 표를 올바른 차례로 정렬한다@>=
opStart[0] = -minQuarterword
for j = 1; j <= 255; j++ {
	opStart[j] = opStart[j-1] + qo(trieUsed[j-1])
}
for j = 1; j <= trieOpPtr; j++ {
	trieOpHash[trieOpSize+j] = opStart[trieOpLang[j]] + trieOpVal[j] // 목적지
}
for j = 1; j <= trieOpPtr; j++ {
	for trieOpHash[trieOpSize+j] > j {
		k = trieOpHash[trieOpSize+j]
		t = hyfDistance[k]; hyfDistance[k] = hyfDistance[j]; hyfDistance[j] = t
		t = hyfNum[k]; hyfNum[k] = hyfNum[j]; hyfNum[j] = t
		t = hyfNext[k]; hyfNext[k] = hyfNext[j]; hyfNext[j] = t
		trieOpHash[trieOpSize+j] = trieOpHash[trieOpSize+k]; trieOpHash[trieOpSize+k] = k
	}
}

@ 지금까지 말한 자료 구조를 어떻게 초기화하는지 잊기 전에, 그것들을 출발시키는 코드를 적어 두자.

@<표의 항목들을 초기화한다...@>=
for k = -trieOpSize; k <= trieOpSize; k++ {
	trieOpHash[trieOpSize+k] = 0
}
for k = 0; k <= 255; k++ {
	trieUsed[k] = minQuarterword
}
trieOpPtr = 0

@ 하이픈 넣기 패턴을 전처리하는 데 쓰는 연결 트라이는 여러 전역 배열에 들어 있다. 노드마다 ``문자 |c|를 보면 연산 |o|를 하고, 다음
문자로 옮겨 가서 노드 |l|로 가라. 그렇지 않으면 노드 |r|로 가라'' 꼴의 명령을 나타낸다. 곧 |l|은 첫 자식, |r|은 다음 형제다. 네 값
|c|, |o|, |l|, |r|은 네 배열 |trieC|, |trieO|, |trieL|, |trieR|에 저장한다. 트라이의 뿌리는 |trieL[0]|이고, 노드의 수는 |triePtr|다.
널 트라이 포인터는 0으로 나타낸다. 트라이를 초기화하려면 그냥 |trieL[0]|과 |triePtr|를 0으로 하면 된다. 알고리즘이 |trieC[0]|을 읽을
수도 있으므로 거기에도 아무 값이나 넣어 둔다.

알고리즘은 $$\hbox{|z!=0|이고 |trieR[z]!=0|일 때마다 |trieC[trieR[z]]>trieC[z]|}$$라는 조건을 지킨다. 다시 말해 형제 노드들은 |c| 필드의
차례로 놓인다.

@<전역 변수@>=
func trieRoot() triePointer { return trieL[0] } // 연결 트라이의 뿌리
func setTrieRoot(v triePointer) { trieL[0] = v }

var @!trieC [trieSize + 1]packedASCIICode // 맞출 문자
var @!trieO [trieSize + 1]quarterword // 수행할 연산
var @!trieL [trieSize + 1]triePointer // 왼쪽 부분 트라이 링크
var @!trieR [trieSize + 1]triePointer // 오른쪽 부분 트라이 링크
var @!triePtr triePointer // 트라이의 노드 수
var @!trieHash [trieSize + 1]triePointer // 동치인 부분 트라이를 찾아내는 데 쓴다

@ 연결 트라이가 이미 만들어져 있다고 하자. 경험에 따르면 똑같은 부분 트라이를 알아보면 크기를 줄일 수 있는 일이 많다. 이를테면
`\.{tion}'으로 끝나는 패턴이 많으면 그 끝부분은 한 벌만 있으면 된다. 그래서 이 목적으로 |trieOpHash|와 조금 비슷한 해시 표를 하나 더
들여온다. 새 해시 표는 0으로 초기화한다.

함수 |trieNode(p)|는 |p|가 지금까지 본 다른 노드들과 다르면 |p|를 돌려주고, 같은 것이 있으면 처음 본 그 노드의 번호를 돌려준다.

서로 다른 언어의 패턴에서 온 부분 트라이들도, 트라이 연산의 뜻이 아주 다를 수 있는데도 동치로 합쳐질 수 있다는 데 눈여겨보자. 그래도
전혀 문제없다. 연산 번호가 같으면 실제로 하는 일도 같기 때문이다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func trieNode(p triePointer) triePointer { // 표준 꼴로 바꾼다
	var q triePointer // 시험 트라이 노드
	h := abs(int32(trieC[p])+1009*trieO[p]+2718*trieL[p]+3142*trieR[p]) % trieSize // 시험 해시 자리
	for {
		q = trieHash[h]
		if q == 0 {
			trieHash[h] = p; return p
		}
		if trieC[q] == trieC[p] && trieO[q] == trieO[p] && trieL[q] == trieL[p] && trieR[q] == trieR[p] {
			return q
		}
		if h > 0 { h-- } else { h = trieSize }
	}
}

@ 이제 깔끔한 재귀 프로시저가 트라이를 따라가며 노드마다 ``아래에서 위로'' |trieNode|를 적용해서 트라이를 압축할 수 있다. 배열
|trieHash|를 0으로 지운 다음 `|trieRoot=compressTrie(trieRoot)|'라고 하면 트라이 전체가 압축된다. 자식과 형제를 먼저 압축해야 노드를
견줄 때 그 연결이 이미 표준 꼴이 되어 있다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func compressTrie(p triePointer) triePointer {
	if p == 0 {
		return 0
	}
	trieL[p] = compressTrie(trieL[p])
	trieR[p] = compressTrie(trieR[p])
	return trieNode(p)
}

@ 압축한 트라이는 ``위에서 아래로 처음 맞는 곳''(top-down first-fit) 절차로 배열 |trie|에 채워 넣는다. 이 부분은 조금 까다로우므로
독자는 주의를 기울여야 한다. 기본 생각은 이렇다. 한 노드의 자식들, 곧 한 가족은 기준 위치 $z$를 하나 정해서 문자 $c$마다 자리 $z+c$에
놓는다. 그러면 트라이를 따라갈 때 |trieLink|에 문자 코드를 더하기만 하면 다음 자리가 나온다. 서로 다른 가족들은 빈자리를 메우며
뒤섞여 놓이고, 맞는 자리인지는 |trieChar|로 확인한다.

이 단계에서 배열 |trieHash|는 다시 0으로 지워지고 |trieRef|라는 이름으로 바뀐다. 나중에 |trieRef[p]|는 연결 트라이 노드 |p|가 한
가족에서 가장 작은 문자이고, 그 가족의 문자 |c|들이 배열 |trie|의 자리 |trieRef[p]+c|에 배정되었을 때에만 0이 아니다. 배열 |trie|에서
쓰고 있는 자리는 |trieLink=0|이고, |trie|에서 쓰지 않는 구멍들은 이중으로 이어져서 |trieLink|는 다음으로 큰 빈자리를, |trieBack|은
다음으로 작은 빈자리를 가리킨다. 이 이중 연결은 |trieMax|까지만 되어 있는데, |trieMax|는 필요할 |trie|의 가장 큰 첨자다. 트라이의
낮은 쪽에서 시간을 아끼려고 배열 항목 |trieMin[c]|가 |c|보다 큰 가장 작은 구멍을 가리키게 한다. 또 하나의 배열 |trieTaken|은 주어진
자리가 어떤 |p|의 |trieRef[p]|와 같은지 알려 준다. 이 배열 덕분에 압축한 트라이의 서로 다른 노드들이 서로 다른 |trieRef| 값을 갖게 된다.

배열 |trieRef|는 |trieHash|와 같은 배열의 다른 이름이므로, 같은 배열을 가리키는 포인터로 둔다. \GO/에서는 배열 포인터에도 첨자를 쓸
수 있다.

@<전역 변수@>=
var @!trieRef = &trieHash // 연결 트라이 가족이 |trie|에 들어가는 곳

func trieBack(p triePointer) halfword { return trie[p].lh } // |trie| 구멍의 뒤로 가는 링크
func setTrieBack(p triePointer, v halfword) { trie[p].lh = v }

var @!trieTaken [trieSize + 1]bool // 여기서 가족이 시작하는가? 첨자 |1 .. trieSize|
var @!trieMin [256]triePointer // 문자마다 가능한 첫 자리
var @!trieMax triePointer // |trie|에서 쓴 가장 큰 자리
var @!trieNotReady bool // 트라이가 아직 연결된 꼴인가?

@ 명령 \.{\\patterns}가 나올 때마다 앞으로 만들 트라이에 패턴을 더 보탠다. 트라이는 하이픈을 처음 넣어 보거나 포맷 파일을 덤프할
때에야 완성된다. 불 변수 |trieNotReady|는 트라이를 압축할 때 |false|가 되고, 그 뒤로는 패턴을 더 보탤 수 없다.

@<표의 항목들을 초기화한다...@>=
trieNotReady = true; setTrieRoot(0); trieC[0] = si(0); triePtr = 0

@ 다음은 트라이를 압축하기 전에 자료 구조를 준비하는 방법이다. 저장 공간이 빠듯하면 |trieOpHash|, |trieOpLang|, |trieOpVal|을 |trie|,
|trieHash|, |trieTaken|과 겹쳐 쓸 수도 있을 것이다. 앞의 것들을 다 쓰고 나서야 뒤의 것들이 필요하기 때문이다.

@<트라이를 압축할 준비를 한다@>=
@<하이픈 넣기 연산 표를...@>
for p = 0; p <= trieSize; p++ {
	trieHash[p] = 0
}
setTrieRoot(compressTrie(trieRoot())) // 동치인 부분 트라이를 찾아낸다
for p = 0; p <= triePtr; p++ {
	trieRef[p] = 0
}
for p = 0; p <= 255; p++ {
	trieMin[p] = p + 1
}
setTrieLink(0, 1); trieMax = 0

@ 프로시저 |firstFit|는 노드 |p|에서 시작하는 트라이 가족이 |z|에서 시작하는 빈자리들에 들어맞는, |trie|의 가장 작은 구멍 |z|를 찾는다.
가족의 첫 문자를 |c=trieC[p]|라고 하면, 자리 |z-c|를 다른 가족이 기준 위치로 이미 차지하지 않았어야 하고, 가족의 모든 문자 $c^\prime$에 대해
|z-c+@t$c^\prime$@>|가 비어 있어야 한다는 뜻이다. 이 프로시저는 처음 맞는 곳을 찾으면 |trieRef[p]|를 |z-c|로 한다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func firstFit(p triePointer) { // 가족 하나를 |trie|에 채워 넣는다
	var h triePointer // |trieRef[p]|의 후보
	var z triePointer // 구멍들을 훑는다
	var q triePointer // |p|에서 시작하는 가족을 훑는다
	var c asciiCode // 가족에서 가장 작은 문자
	var l, r triePointer // 왼쪽과 오른쪽 이웃
	var ll int32 // |trieMin|을 갱신할 위 한계; |1..256|
	c = so(trieC[p])
	z = trieMin[c] // 처음으로 그럴듯한 구멍을 얻는다
	for {
		h = z - c
		@<|trieMax>=h+256|이 되게 한다@>
		if trieTaken[h] {
			goto notFound
		}
		@<가족의 모든 문자가 |h|에 대해 들어맞으면 |goto found|, 아니면 |goto notFound|@>
	notFound:
		z = trieLink(z) // 다음 구멍으로 옮긴다
	}
found:
	@<가족을 |h|에 대해 |trie|에 채워 넣는다@>
}

@ 한계 |trieMax|가 적어도 |h+256|이 되게 하면 |h=z-c|이므로 |trieMax>z|임을 확신할 수 있다. 따라서 자리 |trieMax|는 |trie|에서 결코
차지되지 않을 것이고, |trieMax>=trieLink(z)|일 것이다. 모자라면 빈자리 사슬을 늘인다.

@<|trieMax>=h+256|이...@>=
if trieMax < h+256 {
	if trieSize <= h+256 {
		overflow("pattern memory", trieSize)
	}
@:TeX capacity exceeded pattern memory}{\quad pattern memory@>
	for {
		trieMax++; trieTaken[trieMax] = false
		setTrieLink(trieMax, trieMax+1); setTrieBack(trieMax, trieMax-1)
		if trieMax == h+256 {
			break
		}
	}
}

@ 가족의 나머지 문자들의 자리가 모두 비어 있는지 본다.
@<가족의 모든 문자가...@>=
q = trieR[p]
for q > 0 {
	if trieLink(h+so(trieC[q])) == 0 {
		goto notFound
	}
	q = trieR[q]
}
goto found

@ 가족을 기준 위치 |h|에 놓는다. 쓰게 된 자리들을 빈자리 사슬에서 빼고, 필요하면 |trieMin|도 고친다.
@<가족을 |h|에 대해...@>=
trieTaken[h] = true; trieRef[p] = h; q = p
for {
	z = h + so(trieC[q]); l = trieBack(z); r = trieLink(z)
	setTrieBack(r, l); setTrieLink(l, r); setTrieLink(z, 0)
	if l < 256 {
		ll = min(z, 256)
		for {
			trieMin[l] = r; l++
			if l == ll {
				break
			}
		}
	}
	q = trieR[q]
	if q == 0 {
		break
	}
}

@ 연결 트라이 전체를 채워 넣으려면 다음 재귀 프로시저를 쓴다. 형제들을 차례로 보며, 자식 가족이 아직 놓이지 않았으면 먼저 그 가족을
놓고 재귀로 그 아래를 채운다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func triePack(p triePointer) { // 한 가족의 부분 트라이들을 채워 넣는다
	var q triePointer // 재귀 호출에서 저장할 필요가 없는 지역 변수
	for {
		q = trieL[p]
		if q > 0 && trieRef[q] == 0 {
			firstFit(q); triePack(q)
		}
		p = trieR[p]
		if p == 0 {
			break
		}
	}
}

@ 트라이 전체를 순차 표에 배정하고 나면, |trie|가 올바른 정보를 담도록 한 번 더 지나가야 한다. 연결 트라이의 널 포인터는 값~0으로
나타내는데, 이것으로 ``빈'' 가족이 저절로 제대로 나타난다. 쓰지 않은 구멍은 모두 0으로 지운다.

@<자료를 |trie|로 옮긴다@>=
h.rh = 0; h.b0 = minQuarterword; h.b1 = minQuarterword // |trieLink=0|, |trieOp=minQuarterword|, |trieChar=qi(0)|
if trieRoot() == 0 { // 패턴이 하나도 주어지지 않았다
	for r = 0; r <= 256; r++ {
		trie[r] = h
	}
	trieMax = 256
} else {
	trieFix(trieRoot()) // 이것이 |trie|의 구멍 아닌 곳을 바로잡는다
	r = 0 // 이제 구멍을 모두 0으로 지운다
	for {
		s = trieLink(r); trie[r] = h; r = s
		if r > trieMax {
			break
		}
	}
}
setTrieChar(0, qi('?')) // 모든 |c|에 대해 |trieChar(c)!=c|가 되게 한다

@ 바로잡는 프로시저는 물론 재귀적이다. 압축한 트라이에는 대개 함께 쓰는 부분 트라이가 있으므로 같은 자료를 여러 번 옮길 수도 있다.
그래도 해가 없고, 많아야 압축하지 않은 트라이를 만드는 데 든 만큼의 일만 한다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func trieFix(p triePointer) { // |p|와 그 형제들을 |trie|로 옮긴다
	var q triePointer // 재귀 호출에서 저장할 필요가 없는 지역 변수
	var c asciiCode // 저장할 필요가 없는 또 하나
	z := trieRef[p] // |trie| 참조; 이 지역 변수는 저장해야 한다
	for {
		q = trieL[p]; c = so(trieC[p])
		setTrieLink(z+c, trieRef[q]); setTrieChar(z+c, qi(c)); setTrieOp(z+c, trieO[p])
		if q > 0 {
			trieFix(q)
		}
		p = trieR[p]
		if p == 0 {
			break
		}
	}
}

@ 이제 더 쉬운 문제, 곧 연결 트라이를 만드는 문제로 돌아가자. \.{INITEX}가 제어 시퀀스 `\.{\\patterns}'를 읽으면 |newPatterns|를
불러 알맞은 일을 한다. 트라이가 이미 완성되었으면 더는 패턴을 보탤 수 없다고 알린다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func newPatterns() { // 하이픈 넣기 패턴 자료를 초기화한다
	var k, l int32 // |hc|와 |hyf|의 첨자; |0..64|, 늘 |smallNumber| 범위인 것은 아니다
	var digitSensed bool // 다음 숫자를 글자로 다루어야 하는가?
	var v quarterword // 트라이 연산 코드
	var p, q triePointer // 끼워 넣는 동안 지나가는 트라이 노드
	var firstChild bool // |p=trieL[q]|인가?
	var c asciiCode // 끼워 넣는 문자
	if trieNotReady {
		setCurLang(); scanLeftBrace() // \.{\\patterns} 뒤에는 왼쪽 중괄호가 와야 한다
		@<오른쪽 중괄호에 이를 때까지 모든 패턴을 연결 트라이에 넣는다@>
	} else {
		printErr("Too late for "); printEsc("patterns")
		help1("All patterns must be given before typesetting begins.")
		reportError(); setLink(garbage, scanToks(false, false)); flushList(defRef)
	}
}

@ 처음 쓰는 사람이 \.{\\patterns}를 쓸 일은 없다고 보므로 오류 메시지가 짧다. (\.{INITEX}에서만 쓰더라도 오류 메시지는 모두 \TeX의
문자열 풀에 들어간다는 데 주의하자.) 패턴은 공백으로 나뉜 낱말들이고, 오른쪽 중괄호에서 끝난다.

@<오른쪽 중괄호에 이를 때까지 모든 패턴을...@>=
k = 0; hyf[0] = 0; digitSensed = false
for {
	getXToken()
	switch curCmd {
	case letter, otherChar: @<새 글자나 하이픈 수준을 덧붙인다@>
	case spacer, rightBrace:
		if k > 0 {
			@<연결 트라이에 새 패턴을 넣는다@>
		}
		if curCmd == rightBrace {
			goto done
		}
		k = 0; hyf[0] = 0; digitSensed = false
	default:
		printErr("Bad "); printEsc("patterns")
@.Bad \\patterns@>
		help1("(See Appendix H.)"); reportError()
	}
}
done:

@ 글자는 소문자로 바꾸어 모으고, 숫자는 바로 앞 글자 사이의 하이픈 수준으로 기억한다. 마침표는 낱말의 가장자리를 나타내는 문자 0이다.
이를테면 `\.{.ach4}'는 낱말이 \.{ach}로 시작하면 \.h 뒤에 수준 4를 준다는 패턴이다.
@<새 글자나 하이픈 수준을...@>=
if digitSensed || curChr < '0' || curChr > '9' {
	if curChr == '.' {
		curChr = 0 // 낱말 가장자리 구분자
	} else {
		curChr = lcCode(curChr)
		if curChr == 0 {
			printErr("Nonletter")
@.Nonletter@>
			help1("(See Appendix H.)"); reportError()
		}
	}
	if k < 63 {
		k++; hc[k] = curChr; hyf[k] = 0; digitSensed = false
	}
} else if k < 63 {
	hyf[k] = curChr - '0'; digitSensed = true
}

@ 다음 코드가 실행될 때 패턴 $p_1\ldots p_k$는 |hc[1 .. k]|에, 대응하는 수 나열 $n_0\ldots n_k$는 |hyf[0 .. k]|에 있다. 언어 코드를 첫
글자로 삼아 트라이를 따라 내려가며, 없는 노드는 새로 만든다. 마지막 노드에 연산 코드를 적는다. 같은 패턴이 두 번 나오면 오류다.

@<연결 트라이에 새 패턴을...@>=
@<트라이 연산 코드 |v|를 계산하고 |l=0|으로 한다@>
q = 0; hc[0] = curLang
for l <= k {
	c = hc[l]; l++; p = trieL[q]; firstChild = true
	for p > 0 && c > so(trieC[p]) {
		q = p; p = trieR[q]; firstChild = false
	}
	if p == 0 || c < so(trieC[p]) {
		@<|q|와 |p| 사이에 새 트라이 노드를 넣고 |p|가 그것을 가리키게 한다@>
	}
	q = p // 이제 노드 |q|는 $p_1\ldots p_{l-1}$을 나타낸다
}
if trieO[q] != minQuarterword {
	printErr("Duplicate pattern")
@.Duplicate pattern@>
	help1("(See Appendix H.)"); reportError()
}
trieO[q] = v

@ 형제 사이의 알맞은 자리에 새 트라이 노드를 넣는다. 형제들이 문자 차례로 놓이게 한다.
@<|q|와 |p| 사이에 새 트라이 노드를...@>=
if triePtr == trieSize {
	overflow("pattern memory", trieSize)
}
@:TeX capacity exceeded pattern memory}{\quad pattern memory@>
triePtr++; trieR[triePtr] = p; p = triePtr; trieL[p] = 0
if firstChild { trieL[q] = p } else { trieR[q] = p }
trieC[p] = si(c); trieO[p] = minQuarterword

@ 수 나열을 뒤에서부터 연산 사슬로 바꾼다. 0이 아닌 수마다 |newTrieOp|를 부른다. 낱말 가장자리 바깥의 수는 뜻이 없으므로 0으로 둔다.
@<트라이 연산 코드 |v|를...@>=
if hc[1] == 0 {
	hyf[0] = 0
}
if hc[k] == 0 {
	hyf[k] = 0
}
l = k; v = minQuarterword
for {
	if hyf[l] != 0 {
		v = newTrieOp(k-l, hyf[l], v)
	}
	if l > 0 { l-- } else { goto done1 }
}
done1:

@ 마침내 모든 것을 한데 모은다. 트라이가 최종의 효율적인 꼴에 이르는 방법은 이렇다. 압축하고, 채워 넣고, 바로잡는다. 다음 채워 넣기
루틴은 하이픈 넣기 알고리즘이 요구하는 대로 연결 트라이의 뿌리가 |trie|의 자리 1로 가도록 짜여 있다. 프로시저 |firstFit|의 첫 호출이
자리~1을 ``차지''하기 때문이다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func initTrie() {
	var p triePointer // 초기화를 위한 포인터
	var j, k, t int32 // 초기화를 위한 만능 레지스터들
	var r, s triePointer // 채워 넣은 |trie|를 청소하는 데 쓴다
	var h twoHalves // |trie|의 구멍을 0으로 지우는 데 쓰는 틀
	@<트라이를 압축할 준비를 한다@>
	if trieRoot() != 0 {
		firstFit(trieRoot()); triePack(trieRoot())
	}
	@<자료를 |trie|로 옮긴다@>
	trieNotReady = false
}

@* 세로 목록을 쪽으로 나누기.
\TeX의 \.{\\vsplit} 연산을 구현하는 프로시저 |vsplit|는 |lineBreak|보다 훨씬 단순하다. 하이픈 넣기를 걱정하지 않아도 되고, 나눔점의
최적 나열이 아니라 나눔 하나만 찾으면 되기 때문이다. 세로 목록에서는 각 나눔이 그 자리까지의 쪽만 보고 정해지므로, 이른바 ``욕심쟁이''
방식으로 충분하다. 그러나 |vsplit|의 세부로 들어가기 전에 좀 더 기본적인 것 몇 가지를 생각해야 한다.

@ 서브루틴 |prunePageTop|은 세로 목록을 받아서, 첫 상자나 괘선 노드 앞의 글루, 커닝, 벌점 노드를 모두 지운 목록을 돌려준다. 다만 첫
상자나 괘선 앞에는 새 글루 노드를 넣는데, 이 글루는 될 수 있으면 맨 위 기준선이 위 끝에서 |splitTopSkip|만큼 떨어지도록 정한다. 상자가
그보다 높으면 글루는 0이 된다. 뒤로 물러서는 음의 글루는 넣지 않는다.

이 루틴과 뒤따르는 루틴들에서는 세로 목록에 문자 노드가 없다는 사실, 그래서 목록의 모든 노드에 \ID{type} 필드가 있다는 사실을
이용한다.
@^data structure assumptions@>

@<함수들@>=
func prunePageTop(p pointer) pointer { // 쪽 나눔 뒤에 위 끝을 맞춘다
	var prevP pointer // |p|보다 한 걸음 뒤처진다
	var q pointer // 목록을 다루는 임시 변수
	prevP = tempHead; setLink(tempHead, p)
	for p != null {
		switch typ(p) {
		case hlistNode, vlistNode, ruleNode:
			@<|splitTopSkip|을 위한 글루를 넣고 |p=null|로 한다@>
		case whatsitNode, markNode, insNode:
			prevP = p; p = link(prevP)
		case glueNode, kernNode, penaltyNode:
			q = p; p = link(q); setLink(q, null)
			setLink(prevP, p); flushNodeList(q)
		default: confusion("pruning")
@:this can't happen pruning}{\quad pruning@>
		}
	}
	return link(tempHead)
}

@ 첫 상자의 높이를 뺀 \.{\\splittopskip} 글루를 넣는다.
@<|splitTopSkip|을 위한 글루를...@>=
q = newSkipParam(splitTopSkipCode); setLink(prevP, q); setLink(q, p)
// 이제 |tempPtr=gluePtr(q)|
if width(tempPtr) > height(p) {
	setWidth(tempPtr, width(tempPtr)-height(p))
} else {
	setWidth(tempPtr, 0)
}
p = null

@ 다음 서브루틴은 주어진 세로 목록을 나누어 높이~|h|, 최대 깊이~|d|인 상자를 얻을 가장 좋은 자리를 찾는다. 세로 목록의 시작을 받아서
최적 나눔점을 가리키는 포인터를 돌려준다. 목록 뒤에는 사실상 강제 나눔, 곧 |ejectPenalty|를 가진 벌점 노드가 있다고 본다. 가장 좋은
나눔이 이 가상의 노드에서 일어나면 |null|을 돌려준다.

프로시저 |lineBreak|에서처럼 |scaled| 거리 여섯 개의 배열을 써서 목록의 처음부터 현재 자리까지의 높이를 기록한다. 사실 같은 배열을
쓰되, 새 뜻에 맞게 이름만 바꾼다.

이름 |activeHeight|는 배열 |activeWidth|를 가리키는 포인터이고, 현재 높이는 그 첫 성분 |activeHeight[1]|이다.

@<전역 변수@>=
var @!activeHeight = &activeWidth // 거리 변수 여섯 개의 새 이름

@ 이제 |vertBreak| 자체를 보자. 목록을 따라가며 합법적인 나눔점마다 나쁨과 벌점을 더한 비용을 계산하고, 그 비용이 지금까지의 최소
이하이면 그 자리를 기억한다. 목록이 너무 길어져 비용이 |awfulBad|가 되거나 강제 나눔을 만나면 멈춘다.

@<함수들@>=
func vertBreak(p pointer, h, d scaled) pointer { // 최적 쪽 나눔을 찾는다
	var prevP pointer // |p|가 글루 노드이면 |typ(prevP)|가 |p|가 합법적인 나눔점인지 정한다
	var q, r pointer // 글루 명세
	var pi int32 // 벌점 값
	var b int32 // 시험 나눔점의 나쁨
	var leastCost int32 // 지금까지 찾은 가장 작은 나쁨과 벌점의 합
	var bestPlace pointer // |leastCost|에 이르는 가장 최근의 나눔
	var prevDp scaled // 목록에서 앞 상자의 깊이
	var t smallNumber // 커닝 다음 노드의 \ID{type}
	prevP = p // 처음의 글루 노드는 합법적인 나눔점이 아니다
	leastCost = awfulBad
	for k := int32(1); k <= 6; k++ {
		activeHeight[k] = 0 // |setHeightZero|
	}
	prevDp = 0
	for {
		@<노드 |p|가 합법적인 나눔점이면 가장 좋은지 검사한다@>
		prevP = p; p = link(prevP)
	}
done:
	return bestPlace
}

@ 전역 변수 |bestHeightPlusDepth|에는 |vertBreak|가 찾은 최적 나눔점까지의 상자의 자연 크기가 들어간다. (이 값은 쪽 조립기의 삽입물
나누기 알고리즘이 쓴다.)

@<전역 변수@>=
var @!bestHeightPlusDepth scaled // 늘이거나 줄이지 않은 가장 좋은 상자의 높이

@ 여기서 눈여겨볼 미묘한 점은 최대 깊이~|d|가 음수일 수도 있다는 것이다. 그래서 글루나 커닝 노드 뒤에서도 |curHeight|와 |prevDp|를
바로잡아야 할 수 있다. 상자의 깊이가 |d|를 넘으면 넘는 만큼을 높이로 옮긴다.

노드 |p|가 합법적인 나눔점이면 이 나눔이 알려진 것 가운데 가장 좋은지 검사하고, |p|가 널이거나 지금까지의 쪽이 이미 너무 차서 더 받을
수 없으면 |goto done|한다.

@<노드 |p|가 합법적인 나눔점이면...@>=
if p == null {
	pi = ejectPenalty
} else {
	@<노드 |p|로 현재 높이와 깊이 측정값을 갱신한다@>
}
@<노드 |p|가 새 챔피언 나눔점인지 검사한다@>
if typ(p) < glueNode || typ(p) > kernNode {
	goto notFound
}
updateHeights:
	@<글루나 커닝 노드~|p|에 대해 현재 높이와 깊이 측정값을 갱신한다@>
notFound:
	if prevDp > d {
		activeHeight[1] = activeHeight[1] + prevDp - d
		prevDp = d
	}

@ 이 노드가 합법적인 나눔점이 아니면 |goto notFound|나 |goto updateHeights|하고, 그렇지 않으면 |pi|를 그 나눔에 딸린 벌점으로 정한다.
세로 목록에서도 글루는 앞이 상자 같은 것일 때만, 커닝은 뒤에 글루가 올 때만 나눔점이 된다.

@<노드 |p|로 현재 높이와...@>=
switch typ(p) {
case hlistNode, vlistNode, ruleNode:
	activeHeight[1] = activeHeight[1] + prevDp + height(p); prevDp = depth(p)
	goto notFound
case whatsitNode: @<|vertBreak| 루프에서 whatsit |p|를 처리하고 |goto notFound|@>
case glueNode:
	if precedesBreak(prevP) {
		pi = 0
	} else {
		goto updateHeights
	}
case kernNode:
	if link(p) == null {
		t = penaltyNode
	} else {
		t = typ(link(p))
	}
	if t == glueNode { pi = 0 } else { goto updateHeights }
case penaltyNode: pi = penalty(p)
case markNode, insNode: goto notFound
default: confusion("vertbreak")
@:this can't happen vertbreak}{\quad vertbreak@>
}

@ 나쁨에 벌점을 더해 비용 |b|를 구한다. 나쁨이 무한하면 |deplorable|로 친다. 비용이 지금까지의 최소 이하이면 이 자리를 새 챔피언으로
삼는다. 같으면 뒤의 것을 택한다는 데 눈여겨보자. 노드 |p|가 강제 나눔이거나 지금까지의 쪽이 이미 너무 찼으면 |goto done|한다.

@<노드 |p|가 새 챔피언...@>=
if pi < infPenalty {
	@<나쁨 |b|를 계산하되, 상자가 너무 차면 |awfulBad|로 한다@>
	if b < awfulBad {
		if pi <= ejectPenalty {
			b = pi
		} else if b < infBad {
			b += pi
		} else {
			b = deplorable
		}
	}
	if b <= leastCost {
		bestPlace = p; leastCost = b
		bestHeightPlusDepth = activeHeight[1] + prevDp
	}
	if b == awfulBad || pi <= ejectPenalty {
		goto done
	}
}

@ 늘일 수 있는 양이 모자라 무한히 나쁜 나눔에는 |deplorable|이라는 비용을 매긴다. 그러면 무한히 나쁜 나눔끼리는 벌점과 상관없이 같게
취급되면서도, 너무 차서 받을 수 없는 경우(|awfulBad|)와는 구별된다.
@<정의@>=
const @!deplorable = 100000 // |infBad|보다 크지만 |awfulBad|보다 작다

@ 현재 높이가 목표보다 작으면 늘이기의 나쁨을, 크면 줄이기의 나쁨을 계산한다. 줄일 수 있는 양보다 더 넘치면 |awfulBad|다.
@<나쁨 |b|를 계산하되...@>=
if activeHeight[1] < h {
	if activeHeight[3] != 0 || activeHeight[4] != 0 || activeHeight[5] != 0 {
		b = 0
	} else {
		b = badness(h-activeHeight[1], activeHeight[2])
	}
} else if activeHeight[1]-h > activeHeight[6] {
	b = awfulBad
} else {
	b = badness(activeHeight[1]-h, activeHeight[6])
}

@ 프로시저 |vertBreak|가 다룰 세로 목록에는 무한 줄어듦이 없어야 한다. 그런 것이 있으면 아무리 많은 재료라도 한 쪽에 ``들어맞을''
것이기 때문이다. 있으면 오류를 알리고 유한하게 바꾼다.

@<글루나 커닝 노드~|p|에 대해...@>=
if typ(p) == kernNode {
	q = p
} else {
	q = gluePtr(p)
	activeHeight[2+stretchOrder(q)] = activeHeight[2+stretchOrder(q)] + stretch(q)
	activeHeight[6] += shrink(q)
	if shrinkOrder(q) != normal && shrink(q) != 0 {
		printErr("Infinite glue shrinkage found in box being split")
@.Infinite glue shrinkage...@>
		help4("The box you are \\vsplitting contains some infinitely",
			"shrinkable glue, e.g., `\\vss' or `\\vskip 0pt minus 1fil'.",
			"Such glue doesn't belong there; but you can safely proceed,",
			"since the offensive shrinkability has been made finite.")
		reportError(); r = newSpec(q); setShrinkOrder(r, normal); deleteGlueRef(q)
		setGluePtr(p, r); q = r
	}
}
activeHeight[1] = activeHeight[1] + prevDp + width(q); prevDp = 0

@ 이제 |vsplit| 자체를 살펴볼 차례다. 일의 대부분은 방금 본 두 서브루틴이 해낸다.

세로 목록 상자의 번호 |n|과 원하는 쪽 높이 |h|가 주어지면, 함수 |vsplit|는 그 세로 목록의 가장 좋은 첫 토막을 찾아서 높이~|h|인 상자로
만들어 돌려준다. 세로 목록의 나머지가 있으면, 앞의 글루와 벌점을 없애고 |splitTopSkip|에 맞추어 조정한 뒤 원래 상자 자리에 남긴다.
떼어 낸 토막 안의 표시 노드로 |splitFirstMark|와 |splitBotMark|의 값을 정한다. 여기서는 |splitBotMark=null|일 때, 그리고 오직 그때에만
|splitFirstMark=null|이라는 사실을 이용한다.

원래 상자는 전부 떼어 냈을 때, 그리고 오직 그때에만 ``빈'' 상자가 된다. 떼어 낸 상자는 원래 상자가 비어 있었을 때(또는 잘못해서 가로
목록 상자였을 때), 그리고 오직 그때에만 ``빈'' 상자가 된다.

@<함수들@>=
func vsplit(n eightBits, h scaled) pointer { // 상자 |n|에서 높이 |h|인 쪽을 떼어 낸다
	var v pointer // 나눌 상자
	var p pointer // 세로 목록을 훑는다
	var q pointer // 나눔이 일어나는 곳을 가리킨다
	v = box(n)
	if splitFirstMark() != null {
		deleteTokenRef(splitFirstMark()); setSplitFirstMark(null)
		deleteTokenRef(splitBotMark()); setSplitBotMark(null)
	}
	@<비었거나 잘못된 상자의 자명한 경우를 처리한다@>
	q = vertBreak(listPtr(v), h, splitMaxDepth())
	@<나눔 앞 노드들의 표시를 모두 살피고, 나눔에서 마지막 링크를 |null|로 한다@>
	q = prunePageTop(q); p = listPtr(v); freeNode(v, boxNodeSize)
	if q == null {
		setBoxReg(n, null) // 상자의 |eqLevel|은 그대로다
	} else {
		setBoxReg(n, vpack(q, natural, additional))
	}
	return vpackage(p, h, exactly, splitMaxDepth())
}

@ 상자가 비어 있으면 빈 상자를 돌려준다. 가로 상자이면 나눌 수 없다고 알린다.
@<비었거나 잘못된 상자의...@>=
if v == null {
	return null
}
if typ(v) != vlistNode {
	printErr(""); printEsc("vsplit"); printStr(" needs a ")
	printEsc("vbox")
@:vsplit_}{\.{\\vsplit needs a \\vbox}@>
	help2("The box you are trying to split is an \\hbox.",
		"I can't split such a box, so I'll leave it alone.")
	reportError(); return null
}

@ 나눔점 앞의 노드들에서 표시를 찾아 |splitFirstMark|와 |splitBotMark|를 정하고, 나눔점에서 목록을 자른다. 상자가 ``가장 좋은'' 나눔인
벌점 노드로 시작할 수도 있으므로, 이 특별한 경우를 조심해서 다루어야 한다.

@<나눔 앞 노드들의 표시를...@>=
p = listPtr(v)
if p == q {
	setListPtr(v, null)
} else {
	for {
		if typ(p) == markNode {
			if splitFirstMark() == null {
				setSplitFirstMark(markPtr(p))
				setSplitBotMark(splitFirstMark())
				setTokenRefCount(splitFirstMark(), tokenRefCount(splitFirstMark())+2)
			} else {
				deleteTokenRef(splitBotMark())
				setSplitBotMark(markPtr(p))
				addTokenRef(splitBotMark())
			}
		}
		if link(p) == q {
			setLink(p, null); goto done
		}
		p = link(p)
	}
}
done:

@* 쪽 조립기.
\TeX이 세로 모드에서 주 세로 목록에 새 내용을 덧붙일 때는 |vsplit|와 비슷한 방법으로 쪽이 어디서 끝나는지 정한다. 다만 새 항목이
들어올 때마다 ``그때그때'' 계산한다는 점이 다르다. 이 과정의 주된 복잡함은 삽입물들을 어느 정도 최적인 방식으로 그 상자에 넣고
세로 목록에서 없애야 한다는 것이다.

주 세로 목록 가운데 떼어 내어 사용자의 출력 루틴으로 보낼 후보로 고려하고 있는 부분을 ``현재 쪽''이라고 부르겠다. 현재 쪽은
|link(pageHead)|에서 시작해서 |pageTail|에서 끝난다. 이 목록이 비어 있으면 |pageHead=pageTail|이다.
@^current page@>

쪽을 만드는 동안 사용자가 쪽 지정을 자꾸 바꾸면 완전한 혼돈이 일어날 것이다. 그래서 쪽 조립기는 쪽이 첫 상자나 삽입물을 받자마자
관련 지정을 얼려 둔다. 전역 변수 |pageContents|는 현재 쪽에 표시 노드와 내용 없는 whatsit 노드만 있으면 |empty|이고, 표시와
whatsit 말고 삽입 노드만 있으면 |insertsOnly|다. 글루 노드, 커닝 노드, 벌점 노드는 상자나 괘선 노드가 나타날 때까지 버려지고,
그런 노드가 나타나면 |pageContents|는 |boxThere|로 바뀐다. 그리고 이 변수가 |empty|가 아니게 되자마자 현재의 |vsize|와
|maxDepth|를 |pageGoal|과 |pageMaxDepth|에 챙겨 둔다. 쪽이 사용자의 출력 루틴으로 넘어갈 때까지 뒤의 값들이 쓰인다.
글루 \.{\\topskip}의 조정은 |pageContents|가 |boxThere|로 바뀔 때 한다.

목표 |pageGoal|은 |vsize|와 같게 출발하지만, 지금까지 고려한 삽입물의 눈금 매긴 자연 높이와 깊이의 합만큼, 그리고 그 삽입물들의
\.{\\skip} 보정만큼 줄어든다. 그러므로 현재 쪽의 모든 삽입물을 넣었다고 할 때 삽입물 아닌 내용이 들어가야 할 크기를 나타낸다.

전역 변수 |bestPageBreak|와 |leastPageCost|는 이미 공부한 |vertBreak| 루틴의 지역 변수 |bestPlace|와 |leastCost|에 각각
대응한다. 곧 현재 쪽을 나눌 곳으로 현재 알려진 가장 좋은 곳의 위치와 값을 기록한다. 가장 좋은 나눔 때의 |pageGoal| 값은
|bestSize|에 저장된다.

\seclabel{page-cost}쪽 조립기가 하는 일을 한 장의 그림으로 보자. 주 세로 목록은 두 토막으로 되어 있다. 하나는 현재 쪽이고,
다른 하나는 아직 쪽에 들어가지 않은 기여 목록이다. 프로시저 |buildPage|는 기여 목록의 맨 앞 항목을
하나씩 현재 쪽의 끝으로 옮기면서, 그것이 합법적인 나눔점(글루, 커닝, 벌점)이면 거기서 쪽을 끝낼 때의
비용~$c$를 계산한다. 현재 쪽을 |pageGoal|에 맞출 때의 나쁨을~$b$, 나눔점의 벌점을~$p$, 삽입물을
쪼개면서 쌓인 벌점 |insertPenalties|를~$q$라고 하면
$$c=\cases{p,&$p\le-10000$이고 쪽이 넘치지 않을 때\cr
b+p+q,&$b<10000$일 때\cr
100000,&$b=10000$일 때\cr
\infty,&쪽이 넘치거나 $q\ge10000$일 때\cr}$$
이다. 비용이 지금까지 본 것 가운데 가장 작으면 그 나눔점을 |bestPageBreak|에 기록해 둔다. 그러다가
쪽이 넘쳐서 비용이 무한대가 되거나 강제 나눔($p\le-10000$)을 만나면, 기록해 둔 가장 좋은 나눔점에서
쪽을 끊어 출력 루틴에 넘기고, 그 뒤의 항목들은 기여 목록의 앞으로 되돌려 놓는다. 문단 전체를 보고
나눔점을 고르는 줄 나누기와 달리, 쪽 나누기는 지나온 나눔점들만 보고 판단하는 ``욕심쟁이'' 방법이다.
\TeX이 쪽을 앞질러 내다보지 않는 덕분에 출력 루틴이 쪽마다 바로 돌 수 있다.
$$\mplibcode
beginfig(12);
save w, item; numeric w; w := 80pt;
def item(expr yy, hh)(text t)(expr shade) =
  if shade: fill (0,yy-hh)--(w,yy-hh)--(w,yy)--(0,yy)--cycle withcolor .85white; fi
  draw (0,yy-hh)--(w,yy-hh)--(w,yy)--(0,yy)--cycle;
  label(t, (w/2, yy-hh/2));
enddef;
item(0, 18pt)(btex \eightpoint 상자 etex)(true);
item(-18pt, 12pt)(btex \eightpoint 글루 etex)(false);
item(-30pt, 18pt)(btex \eightpoint 상자 etex)(true);
item(-48pt, 12pt)(btex \eightpoint 벌점 etex)(false);
item(-60pt, 12pt)(btex \eightpoint 글루 etex)(false);
item(-72pt, 18pt)(btex \eightpoint 상자 etex)(true);
item(-90pt, 12pt)(btex \eightpoint 글루 etex)(false);
item(-102pt, 12pt)(btex \eightpoint 벌점 etex)(false);
item(-114pt, 18pt)(btex \eightpoint 상자 etex)(true);
item(-132pt, 12pt)(btex \eightpoint 글루 etex)(false);
item(-144pt, 18pt)(btex \eightpoint 상자 etex)(true);
draw (-20pt,-102pt)--(w+20pt,-102pt) withpen pencircle scaled 1.4pt;
drawarrow (w+8pt,-66pt)--(w+2pt,-66pt); label.rt(btex \eightpoint \ID{bestPageBreak} etex, (w+8pt,-66pt));
drawarrow (w+8pt,-96pt)--(w+2pt,-96pt); label.rt(btex \eightpoint \ID{pageTail} etex, (w+8pt,-96pt));
drawarrow (w+30pt,-108pt)--(w+30pt,-122pt);
label.rt(btex \eightpoint 경계가 한 항목씩 내려간다 etex, (w+32pt,-115pt));
drawdblarrow (-12pt,0)--(-12pt,-102pt); label.lft(btex \eightpoint \ID{pageTotal} etex, (-12pt,-51pt));
drawdblarrow (-70pt,0)--(-70pt,-126pt); label.lft(btex \eightpoint \ID{pageGoal} etex, (-70pt,-63pt));
draw (-74pt,-126pt)--(-4pt,-126pt) dashed evenly;
draw (w+150pt,0)--(w+156pt,0)--(w+156pt,-102pt)--(w+150pt,-102pt);
label.rt(btex \ninepoint 현재 쪽 etex, (w+158pt,-51pt));
draw (w+150pt,-104pt)--(w+156pt,-104pt)--(w+156pt,-162pt)--(w+150pt,-162pt);
label.rt(btex \ninepoint 기여 목록 etex, (w+158pt,-133pt));
endfig;
\endmplibcode$$

@<정의@>=
const (
	@!insertsOnly = 1 // 삽입 노드는 들어왔지만 상자는 없을 때의 |pageContents|
	@!boxThere = 2 // 상자나 괘선이 들어왔을 때의 |pageContents|
)

@ @<전역 변수@>=
var @!pageTail pointer // 현재 쪽의 마지막 노드
var @!pageContents smallNumber // 지금까지 현재 쪽에 무엇이 있는가? |empty..boxThere|
var @!pageMaxDepth scaled // 만들고 있는 쪽의 최대 상자 깊이
var @!bestPageBreak pointer // 여기서 나누면 지금까지 알려진 가장 좋은 쪽을 얻는다
var @!leastPageCost int32 // 지금 가장 좋은 이 쪽의 점수
var @!bestSize scaled // 그 |pageGoal|

@ 쪽 조립기에는 삽입물을 기록하는 자료 구조가 하나 더 있다. 머리 |pageInsHead|에서 시작해서 |pageInsHead|에서 끝나는, 네 낱말짜리
노드들의 순환 목록이다. 곧 목록의 첫 원소는 노드 |r@t$_1$@>=link(pageInsHead)|이고, 노드 $r_j$ 다음에는 |r@t$_{j+1}$@>=link(r@t$_j$@>)|가
오며, 항목이 |n|개이면 |r@t$_{n+1}$@>=pageInsHead|이다. 각 노드의 |subtype| 필드는 삽입 번호다. 이를테면 `\.{\\insert 250}'은 |subtype|이
|qi(250)|인 노드에 대응한다(그 |insNode|의 |subtype| 필드와 같다). 이 |subtype| 필드들은 커지는 차례로 놓이고,
|subtype(pageInsHead)=qi(255)|이므로 |pageInsHead|가 목록 끝의 편리한 보초 노릇을 한다. 현재 쪽에 나오는 삽입 번호마다 레코드가 하나
있다. 이를테면 plain \TeX에서 각주와 떠다니는 그림이 같은 쪽에 있으면 레코드가 둘이다.

이 노드들의 \ID{type} 필드는 최적 쪽 나눔을 정하기 전에 앞을 내다볼 때 생길 수 있는 두 가지 경우를 구별한다. 형이 |typ(r)=inserting|이면
|height(r)|에는 상자의 지금 내용과 지금까지 본 이 부류의 모든 삽입물의 높이 더하기 깊이를 더한 값이 들어 있다. 형이 |typ(r)=splitUp|이면 이
상자에는 더 삽입하지 않는다. 앞선 삽입물 가운데 적어도 하나가 너무 커서 현재 쪽에 다 들어가지 않았기 때문이다. 그때 |brokenPtr(r)|는
\TeX이 그 삽입물을 나누기로 정하면 나눌 노드를 가리키고, |brokenIns(r)|는 시험 삼아 나눈 삽입 노드를 가리키며, |height(r)|에는 떼어 낼
부분의 자연 높이 더하기 깊이까지 들어 있다.

두 경우 모두 |lastInsPtr(r)|는 상자 |qo(subtype(r))|를 위해 만난 |insNode| 가운데 적어도 일부가 다음 쪽에 들어갈 마지막 것을 가리킨다.
그리고 |bestInsPtr(r)|는 지금까지 고려한 쪽 나눔 가운데 가장 좋은 것을 얻으려면 실제로 삽입해야 할 마지막 |insNode|를 가리킨다. 이
최적 쪽을 만들려면 이 상자에 아무것도 넣지 말아야 할 때, 그리고 오직 그때에만 |bestInsPtr(r)=null|이다.

여기서 자료 구조를 정의할 때는 |@!height| 필드가 상자 노드의 넷째 낱말에 있다는 사실을 이용한다.
@^data structure assumptions@>

@<정의@>=
const (
	@!pageInsNodeSize = 4 // 쪽 삽입 노드의 낱말 수
	@!inserting = 0 // 아직 넘치지 않은 삽입 부류
	@!splitUp = 1 // 넘친 삽입 부류
)

func brokenPtr(p pointer) pointer { return link(p + 1) } // 이 부류의 삽입물이 나뉜다면 여기서 나뉜다
func setBrokenPtr(p pointer, v pointer) { setLink(p+1, v) }
func brokenIns(p pointer) pointer { return info(p + 1) } // 이 삽입물이 |brokenPtr|에서 나뉠 수 있다
func setBrokenIns(p pointer, v pointer) { setInfo(p+1, v) }
func lastInsPtr(p pointer) pointer { return link(p + 2) } // 이 |subtype|의 가장 최근 삽입물
func setLastInsPtr(p pointer, v pointer) { setLink(p+2, v) }
func bestInsPtr(p pointer) pointer { return info(p + 2) } // 최적인 가장 최근 삽입물
func setBestInsPtr(p pointer, v pointer) { setInfo(p+2, v) }

@ 특별한 목록 머리 |pageInsHead|는 처음에 자기 자신을 가리키는 빈 목록이다.

@<특별한 목록 머리와...@>=
setSubtype(pageInsHead, qi(255))
setType(pageInsHead, splitUp); setLink(pageInsHead, pageInsHead)

@ 배열 |pageSoFar|는 현재 쪽에 있는 모든 것의 높이와 깊이를 기록한다. 이 배열에는 |lineBreak|와 |vertBreak|에서 본 비슷한 배열들처럼
|scaled| 수 여섯 개가 들어 있고, |pageGoal|과 |pageDepth|도 함께 들어 있다. 이 값들은 모두 사용자가 \.{\\pagegoal}, \.{\\pagetotal} 같은
|setPageDimen| 명령으로 읽고 쓸 수 있기 때문이다. 원소 |pageSoFar[1]|은 |pageTotal|이라고도 부른다. 삽입물마다 그 \.{\\skip} 보정의
늘어남과 줄어듦 성분은 |pageSoFar|에 들어가지만, 자연 너비 성분은 들어가지 않는다. 그것은 |pageGoal|에서 이미 뺐기 때문이다.

변수 |pageDepth|는 현재 쪽의 깊이다. 이 값은 많아야 |pageMaxDepth|가 되도록 조정되어 있다. 변수 |lastGlue|는 기여 목록에서 가장 최근에
들어온 노드가 글루 노드였으면 그 글루 명세를 가리키고, 그렇지 않으면 |lastGlue=maxHalfword|이다. (그러나 기여 목록이 비어 있지 않으면
|lastGlue|의 값이 꼭 정확하지는 않다.) 변수 |lastPenalty|와 |lastKern|도 비슷하다. 이 값들은 세로 모드의 \.{\\lastskip} 따위가 쓴다.
그리고 마지막으로 |insertPenalties|는 나뉜 삽입물과 떠다니는 삽입물에 딸린 벌점의 합이다.

@<전역 변수@>=
func pageGoal() scaled { return pageSoFar[0] } // 만들고 있는 쪽에 들어갈 정보의 원하는 높이
func setPageGoal(v scaled) { pageSoFar[0] = v }
func pageTotal() scaled { return pageSoFar[1] } // 현재 쪽의 높이
func setPageTotal(v scaled) { pageSoFar[1] = v }
func pageShrink() scaled { return pageSoFar[6] } // 현재 쪽의 줄일 수 있는 양
func setPageShrink(v scaled) { pageSoFar[6] = v }
func pageDepth() scaled { return pageSoFar[7] } // 현재 쪽의 깊이
func setPageDepth(v scaled) { pageSoFar[7] = v }

var @!pageSoFar [8]scaled // 현재 쪽의 높이와 글루
var @!lastGlue pointer // \.{\\lastskip}을 구현하는 데 쓴다
var @!lastPenalty int32 // \.{\\lastpenalty}를 구현하는 데 쓴다
var @!lastKern scaled // \.{\\lastkern}을 구현하는 데 쓴다
var @!insertPenalties int32 // 미루어 둔 삽입물에 대한 벌점의 합

@ 명령 \.{\\pagegoal}부터 \.{\\pagedepth}까지를 넣는다. 수정자는 |pageSoFar|의 첨자다.
@<\TeX의 원시 명령을...@>=
primitive("pagegoal", setPageDimen, 0)
@!@:page_goal_}{\.{\\pagegoal} primitive@>
primitive("pagetotal", setPageDimen, 1)
@!@:page_total_}{\.{\\pagetotal} primitive@>
primitive("pagestretch", setPageDimen, 2)
@!@:page_stretch_}{\.{\\pagestretch} primitive@>
primitive("pagefilstretch", setPageDimen, 3)
@!@:page_fil_stretch_}{\.{\\pagefilstretch} primitive@>
primitive("pagefillstretch", setPageDimen, 4)
@!@:page_fill_stretch_}{\.{\\pagefillstretch} primitive@>
primitive("pagefilllstretch", setPageDimen, 5)
@!@:page_filll_stretch_}{\.{\\pagefilllstretch} primitive@>
primitive("pageshrink", setPageDimen, 6)
@!@:page_shrink_}{\.{\\pageshrink} primitive@>
primitive("pagedepth", setPageDimen, 7)
@!@:page_depth_}{\.{\\pagedepth} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case setPageDimen:
	switch chrCode {
	case 0: printEsc("pagegoal")
	case 1: printEsc("pagetotal")
	case 2: printEsc("pagestretch")
	case 3: printEsc("pagefilstretch")
	case 4: printEsc("pagefillstretch")
	case 5: printEsc("pagefilllstretch")
	case 6: printEsc("pageshrink")
	default: printEsc("pagedepth")
	}

@ 쪽 합계를 `\.{100.0 plus 10.0 plus 1.0fil minus 3.0}'처럼 찍는다. 늘어남의 합계는 차수마다 0이 아니면 `\.{ plus }'와 그 값과 단위를
찍는다. 네 차수에 같은 일을 하므로 루프로 쓴다.

@<함수들@>=
func printTotals() {
	printScaled(pageTotal())
	for i, unit := range [...]string{"", "fil", "fill", "filll"} { // |printPlus(2..5)|
		if pageSoFar[2+i] != 0 {
			printStr(" plus "); printScaled(pageSoFar[2+i]); printStr(unit)
		}
	}
	if pageShrink() != 0 {
		printStr(" minus "); printScaled(pageShrink())
	}
}

@ 명령 \.{\\showlists}가 현재 쪽의 상태를 보여 준다. 쪽의 내용과 합계, 목표, 그리고 삽입물마다 지금까지 더해진 양을 찍는다.
@<현재 쪽의 상태를 보인다@>=
if pageHead != pageTail {
	printNl("### current page:")
	if outputActive {
		printStr(" (held over for next output)")
	}
@.held over for next output@>
	showBox(link(pageHead))
	if pageContents > empty {
		printNl("total height "); printTotals()
@:total_height}{\.{total height}@>
		printNl(" goal height "); printScaled(pageGoal())
@.goal height@>
		r = link(pageInsHead)
		for r != pageInsHead {
			@<쪽 삽입 노드 |r|의 상태를 보인다@>
			r = link(r)
		}
	}
}

@ 앞 절의 루프 몸통이다. 삽입물 부류마다 `\.{\\insert100 adds 20.0pt, \#2 might split}'처럼 찍는다.

@<쪽 삽입 노드 |r|의 상태를...@>=
printLn(); printEsc("insert"); t = qo(subtype(r))
printInt(t); printStr(" adds ")
if count(t) == 1000 {
	t = height(r)
} else {
	t = xOverN(height(r), 1000) * count(t)
}
printScaled(t)
if typ(r) == splitUp {
	q = pageHead; t = 0
	for {
		q = link(q)
		if typ(q) == insNode && subtype(q) == subtype(r) {
			t++
		}
		if q == brokenIns(r) {
			break
		}
	}
	printStr(", #"); printInt(t); printStr(" might split")
}

@ 다음은 |pageContents|가 |empty|에서 |insertsOnly|나 |boxThere|로 바뀔 때 부르는 프로시저다. 지금의 \.{\\vsize}와 \.{\\maxdepth}를
얼려 두고 합계를 0으로 놓는다. 매개변수 \.{\\tracingpages}가 양수이면 `\.{\%\% goal height=643.20255, max depth=4.0}'처럼 알린다.

@<함수들@>=
func freezePageSpecs(s smallNumber) {
	pageContents = s
	setPageGoal(vsize()); pageMaxDepth = maxDepth()
	setPageDepth(0)
	for k := 1; k <= 6; k++ {
		pageSoFar[k] = 0 // |setPageSoFarZero|
	}
	leastPageCost = awfulBad
	if stat && tracingPages() > 0 {
		beginDiagnostic()
		printNl("%% goal height="); printScaled(pageGoal())
@.goal height@>
		printStr(", max depth="); printScaled(pageMaxDepth)
		endDiagnostic(false)
	}
}

@ 쪽은 \TeX의 세로 모드에서 현재 목록에 노드를 덧붙이는 방법으로 만든다. 이 세로 모드는 의미 둥지의 가장 바깥 수준에 있다. 이 세로 목록은
두 부분으로 나뉜다. 이미 많이 이야기한 ``현재 쪽''과, 새 노드가 만들어지는 대로 받아 두는 ``기여 목록''이다. 현재 쪽에는 앞에서
설명한 대로 쪽 조립기가 그 자료 구조에 셈해 넣은 모든 것이 들어 있고, 기여 목록에는 \TeX의 다른 부분이 만들었지만 쪽 조립기가 아직 보지
않은 것들이 들어 있다. 기여 목록은 |link(contribHead)|에서 시작해서 \TeX의 세로 모드의 현재 노드에서 끝난다.

\TeX이 세로 모드에서 새 내용을 덧붙이면 프로시저 |buildPage|를 부른다. 이 프로시저는 기여 목록의 노드를 현재 쪽으로 옮겨서 따라잡으려
한다. 쪽 나눔을 찾지 않는 한, 곧 현재 쪽이 다음 최적 쪽 나눔을 정할 만큼 자라지 않는 한, 이 프로시저는 기여 목록을 다 비운다. 쪽 나눔을
찾으면 최적 나눔 뒤의 노드들은 기여 목록으로 돌아가고, 제어는 사실상 사용자의 출력 루틴으로 넘어간다.

현재 쪽의 처음에 있는 글루 노드가 올바른 나눔점으로 여겨지지 않도록 |typ(pageHead)=glueNode|로 한다. 그러면 바로 뒤의 글루는 앞이
글루이므로 나눔점이 아니다.

@<특별한 목록 머리와...@>=
setType(pageHead, glueNode); setSubtype(pageHead, normal)

@ 전역 변수 |outputActive|는 사용자의 출력 루틴이 \TeX을 몰고 있는 동안 참이다. 그동안에는 쪽 조립기가 일하지 않는다.

@<전역 변수@>=
var @!outputActive bool // 출력 루틴 한가운데에 있는가?

@ @<핵심 변수들의...@>=
outputActive = false; insertPenalties = 0

@ 다음 상태 변수들을 초기화하면 쪽 조립기는 새 쪽을 시작할 준비가 된다. (쪽 삽입 목록은 다른 곳에서 초기화한다.)

@<새 현재 쪽을 시작한다@>=
pageContents = empty; pageTail = pageHead; setLink(pageHead, null)
lastGlue = maxHalfword; lastPenalty = 0; lastKern = 0
setPageDepth(0); pageMaxDepth = 0

@ 어떤 때에는 상자 255가 비어 있어야(곧 |null|이어야) 하거나, 삽입 상자가 세로 목록을 받을 수 있어야 한다. 그렇지 않으면 오류 메시지를
찍고, 다음 서브루틴이 원하지 않는 내용을 사용자에게 보여 주고 없앤다.

@<함수들@>=
func boxError(n eightBits) {
	reportError(); beginDiagnostic()
	printNl("The following box has been deleted:")
@.The following...deleted@>
	showBox(box(n)); endDiagnostic(true)
	flushNodeList(box(n)); setBoxReg(n, null)
}

@ 다음 프로시저는 주어진 상자 레지스터에 \.{\\hbox}가 들어 있지 않음을 보장한다. 삽입물은 세로 상자에만 쌓을 수 있기 때문이다.

@<함수들@>=
func ensureVbox(n eightBits) {
	p := box(n) // 상자 레지스터의 내용
	if p != null && typ(p) == hlistNode {
		printErr("Insertions can only be added to a vbox")
@.Insertions can only...@>
		help3("Tut tut: You're trying to \\insert into a",
			"\\box register that now contains an \\hbox.",
			"Proceed, and I'll discard its present contents.")
		boxError(n)
	}
}

@ 프로시저 |buildPage|를 부를 때 \TeX이 늘 세로 모드에 있는 것은 아니다. 현재 모드는 기여 목록을 비운 뒤 \TeX이 돌아가야 할 곳을
나타낸다. 이를테면 문단을 끝낸 뒤라면 아직 가로 모드에서 막 나온 참일 수 있다. 그리고 |buildPage|를 부른 바로 뒤에는 \TeX의 중앙
제어점인 `|goto bigSwitch|'가 와야 한다. 출력 루틴을 시작했을 수 있기 때문이다.


@<함수들@>=
@<|fireUp|이라는 프로시저를 선언한다@>@;
func buildPage() { // 기여 내용을 현재 쪽에 덧붙인다
	var p pointer // 덧붙이는 노드
	var q, r pointer // 살피는 노드들
	var b, c int32 // 현재 쪽의 나쁨과 비용
	var pi int32 // 나쁨에 더할 벌점
	var n int32 // 삽입 상자 번호; |minQuarterword .. 255|
	var delta, h, w scaled // 삽입 계산에 쓰는 크기들
	if link(contribHead) == null || outputActive {
		return
	}
	for {
	again:
		p = link(contribHead)
		@<|lastGlue|, |lastPenalty|, |lastKern|의 값을 갱신한다@>
		@<노드 |p|를 현재 쪽으로 옮기고, 쪽 나눔 때가 되면 출력을 준비한다@>
		if link(contribHead) == null {
			break
		}
	}
	@<꼬리를 |contribHead|로 해서 기여 목록을 비운다@>
}

@ 기여 목록이 비었으면 그 꼬리를 |contribHead|로 되돌린다. 기여 목록의 꼬리는 |nest[0].tailField|다.

@<꼬리를 |contribHead|로...@>=
if nestPtr == 0 {
	tail = contribHead // 세로 모드
} else {
	nest[0].tailField = contribHead // 다른 모드들; |contribTail|
}

@ 명령 \.{\\lastskip}, \.{\\lastpenalty}, \.{\\lastkern}이 쓸 수 있도록, 쪽으로 들어가는 노드가 글루나 벌점이나 커닝이면 그 값을 기억해 둔다.
@<|lastGlue|, |lastPenalty|, |lastKern|의...@>=
if lastGlue != maxHalfword {
	deleteGlueRef(lastGlue)
}
lastPenalty = 0; lastKern = 0
if typ(p) == glueNode {
	lastGlue = gluePtr(p); addGlueRef(lastGlue)
} else {
	lastGlue = maxHalfword
	if typ(p) == penaltyNode {
		lastPenalty = penalty(p)
	} else if typ(p) == kernNode {
		lastKern = width(p)
	}
}

@ 여기 코드는 서로 다른 곳에서 합쳐지는 루틴들로 들어가는 여러 갈래 분기의 한 보기다. 이것을 구조 없는 프로그래밍이라고 부르는
사람도 있지만, 저자는 여러 레이블의 뜻이 잘 이해되어 있는 한 그리 잘못된 점을 보지 못한다.
@^Knuth, Donald Ervin@>

노드 |p|를 현재 쪽으로 옮기고, 쪽 나눔 때가 되면 나눔 뒤의 노드들을 기여 목록으로 되돌리고, 사용자의 출력 루틴이 있으면 그리로
|return|한다.

@<노드 |p|를 현재 쪽으로 옮기고...@>=
@<현재 쪽이 비었고 |p|를 지워야 하면 |goto done1|; 아니면 쪽 상태를 갱신한다@>
@<새 챔피언 나눔점이면 기록하고, 때가 되면 쪽을 내보낸다@>
if typ(p) < glueNode || typ(p) > kernNode {
	goto contribute
}
updateHeights:
	@<현재 쪽 측정값을 노드~|p|의 글루나 커닝으로 갱신한다@>
contribute:
	@<|pageMaxDepth|를 넘지 않게 한다@>
	@<노드 |p|를 현재 쪽에 잇고 |goto done|@>
done1:
	@<노드 |p|를 재활용한다@>
done:

@ 노드 |p|를 기여 목록에서 떼어 현재 쪽의 끝에 붙인다.
@<노드 |p|를 현재 쪽에...@>=
setLink(pageTail, p); pageTail = p
setLink(contribHead, link(p)); setLink(p, null); goto done

@ 쪽이 비어 있을 때 들어온 글루, 커닝, 벌점은 버린다. 쪽의 맨 위에는 그런 것이 남지 않아야 하기 때문이다.
@<노드 |p|를 재활용한다@>=
setLink(contribHead, link(p)); setLink(p, null); flushNodeList(p)

@ 이 절의 이름은 이미 너무 길어서, 더 정확하게 하느라 더 길게 만들지 않는 편이 좋아 보인다. 그래서 기여 목록 끝의 커닝 노드는 그 다음
노드를 알 때까지 기여되지 않는다는 사실은 이름에 넣지 않았다. 다음 노드가 글루인지 알아야 그 커닝이 나눔점인지 정할 수 있기 때문이다.

노드 |p|로 현재 쪽의 상태를 고친다. 이 노드가 삽입물이면 |goto contribute|하고, 합법적인 나눔점이 아니면 |goto contribute|나
|goto updateHeights|하고, 그렇지 않으면 |pi|를 이 나눔점에 딸린 벌점으로 정한다.

@<현재 쪽이 비었고...@>=
switch typ(p) {
case hlistNode, vlistNode, ruleNode:
	if pageContents < boxThere {
		@<현재 쪽을 초기화하고, |p| 앞에 \.{\\topskip} 글루를 넣고, |goto again|@>
	} else {
		@<상자나 괘선 노드를 현재 쪽으로 옮길 준비를 하고 |goto contribute|@>
	}
case whatsitNode: @<whatsit |p|를 현재 쪽으로 옮길 준비를 하고 |goto contribute|@>
case glueNode:
	if pageContents < boxThere {
		goto done1
	} else if precedesBreak(pageTail) {
		pi = 0
	} else {
		goto updateHeights
	}
case kernNode:
	if pageContents < boxThere {
		goto done1
	} else if link(p) == null {
		return
	} else if typ(link(p)) == glueNode {
		pi = 0
	} else {
		goto updateHeights
	}
case penaltyNode:
	if pageContents < boxThere { goto done1 } else { pi = penalty(p) }
case markNode: goto contribute
case insNode: @<현재 쪽에 삽입물을 덧붙이고 |goto contribute|@>
default: confusion("page")
@:this can't happen page}{\quad page@>
}

@ 쪽에 첫 상자가 들어온다. 쪽 지정을 얼리고, 상자 앞에 \.{\\topskip} 글루를 넣는다. 그 너비는 첫 줄의 기준선이 쪽의 위 끝에서
\.{\\topskip}만큼 떨어지도록 상자의 높이만큼 줄인다. 상자가 그보다 높으면 0이다.
@<현재 쪽을 초기화하고...@>=
if pageContents == empty {
	freezePageSpecs(boxThere)
} else {
	pageContents = boxThere
}
q = newSkipParam(topSkipCode) // 이제 |tempPtr=gluePtr(q)|
if width(tempPtr) > height(p) {
	setWidth(tempPtr, width(tempPtr)-height(p))
} else {
	setWidth(tempPtr, 0)
}
setLink(q, p); setLink(contribHead, q); goto again

@ 상자나 괘선이면 앞의 깊이와 이 항목의 높이를 쪽 높이에 더하고, 이 항목의 깊이를 쪽 깊이로 삼는다.
@<상자나 괘선 노드를 현재 쪽으로...@>=
setPageTotal(pageTotal() + pageDepth() + height(p))
setPageDepth(depth(p))
goto contribute

@ 쪽 깊이가 \.{\\maxdepth}를 넘으면 넘는 만큼을 높이로 옮긴다.
@<|pageMaxDepth|를 넘지...@>=
if pageDepth() > pageMaxDepth {
	setPageTotal(pageTotal() + pageDepth() - pageMaxDepth)
	setPageDepth(pageMaxDepth)
}

@ 글루나 커닝만큼 쪽 높이를 늘린다. 글루의 늘어남과 줄어듦은 차수별로 쌓는다. 무한 줄어듦이 있으면 오류다.
@<현재 쪽 측정값을 노드~|p|의...@>=
if typ(p) == kernNode {
	q = p
} else {
	q = gluePtr(p)
	pageSoFar[2+stretchOrder(q)] = pageSoFar[2+stretchOrder(q)] + stretch(q)
	setPageShrink(pageShrink() + shrink(q))
	if shrinkOrder(q) != normal && shrink(q) != 0 {
		printErr("Infinite glue shrinkage found on current page")
@.Infinite glue shrinkage...@>
		help4("The page about to be output contains some infinitely",
			"shrinkable glue, e.g., `\\vss' or `\\vskip 0pt minus 1fil'.",
			"Such glue doesn't belong there; but you can safely proceed,",
			"since the offensive shrinkability has been made finite.")
		reportError()
		r = newSpec(q); setShrinkOrder(r, normal); deleteGlueRef(q)
		setGluePtr(p, r); q = r
	}
}
setPageTotal(pageTotal() + pageDepth() + width(q)); setPageDepth(0)

@ 나눔점이면 그 자리에서 쪽을 끝낼 때의 비용 |c|를 \secref{page-cost}의 식대로 계산한다. 지금까지의 최소 이하이면 새 챔피언으로 기록한다.
비용이 무한이거나 강제 나눔이면 쪽 나눔 때가 된 것이다. 그러면 출력을 준비해서 사용자의 출력 루틴을 작동시키고 |return|하거나, 쪽을
내보내고 |goto done|한다.

@<새 챔피언 나눔점이면...@>=
if pi < infPenalty {
	@<현재 쪽의 나쁨 |b|를 계산한다@>
	if b < awfulBad {
		if pi <= ejectPenalty {
			c = pi
		} else if b < infBad {
			c = b + pi + insertPenalties
		} else {
			c = deplorable
		}
	} else {
		c = b
	}
	if insertPenalties >= 10000 {
		c = awfulBad
	}
	if stat && tracingPages() > 0 {
		@<쪽 나눔 비용을 보인다@>
	}
	if c <= leastPageCost {
		@<지금 나눔을 가장 좋은 쪽 나눔으로 기록한다@>
	}
	if c == awfulBad || pi <= ejectPenalty {
		fireUp(p) // 현재 쪽을 가장 좋은 곳에서 출력한다
		if outputActive {
			return // 사용자의 출력 루틴이 작동할 것이다
		}
		goto done // 쪽은 기본 출력 루틴으로 내보내졌다
	}
}

@ 앞 절에서 새 챔피언을 기록한다. 그때의 삽입물 상태도 |bestInsPtr|에 함께 기억해 둔다.

@<지금 나눔을 가장 좋은 쪽 나눔으로...@>=
bestPageBreak = p; bestSize = pageGoal()
leastPageCost = c
r = link(pageInsHead)
for r != pageInsHead {
	setBestInsPtr(r, lastInsPtr(r))
	r = link(r)
}

@ 매개변수 \.{\\tracingpages}가 양수이면 나눔점마다 `\.{\% t=503.0 g=528.0 b=10000 p=0 c=100000\#}'처럼 쪽 높이, 목표, 나쁨, 벌점, 비용을 찍는다.
맨 끝의 `\.\#'는 이 나눔이 지금의 챔피언이라는 뜻이다.
@<쪽 나눔 비용을...@>=
beginDiagnostic(); printNl("%")
printStr(" t="); printTotals()
printStr(" g="); printScaled(pageGoal())
printStr(" b=")
if b == awfulBad { printChar('*') } else { printInt(b) }
@.*\relax@>
printStr(" p="); printInt(pi)
printStr(" c=")
if c == awfulBad { printChar('*') } else { printInt(c) }
if c <= leastPageCost {
	printChar('#')
}
endDiagnostic(false)

@ 현재 쪽의 나쁨을 계산한다. 쪽이 너무 차서 줄일 수 있는 양으로도 맞출 수 없으면 |awfulBad|를 쓴다.

@<현재 쪽의 나쁨 |b|를...@>=
if pageTotal() < pageGoal() {
	if pageSoFar[3] != 0 || pageSoFar[4] != 0 || pageSoFar[5] != 0 {
		b = 0
	} else {
		b = badness(pageGoal()-pageTotal(), pageSoFar[2])
	}
} else if pageTotal()-pageGoal() > pageShrink() {
	b = awfulBad
} else {
	b = badness(pageTotal()-pageGoal(), pageShrink())
}

@ 쪽에 삽입물이 들어온다. 그 삽입 번호의 쪽 삽입 노드를 찾고, 없으면 새로 만든다. 이미 나뉜 부류이면 이 삽입물은 다음 쪽으로 넘긴다.
아니면 삽입물이 통째로 들어맞는지 보고, 들어맞으면 목표 높이를 줄이고, 들어맞지 않으면 삽입물을 나눈다.
@<현재 쪽에 삽입물을 덧붙이고...@>=
if pageContents == empty {
	freezePageSpecs(insertsOnly)
}
n = subtype(p); r = pageInsHead
for n >= subtype(link(r)) {
	r = link(r)
}
n = qo(n)
if subtype(r) != qi(n) {
	@<|subtype(r)=qi(n)|인 쪽 삽입 노드를 만들고 상자 |n|의 글루 보정을 넣는다@>
}
if typ(r) == splitUp {
	insertPenalties += floatCost(p)
} else {
	setLastInsPtr(r, p)
	delta = pageGoal() - pageTotal() - pageDepth() + pageShrink()
	// 최대로 줄이면 이만큼 공간이 남는다
	if count(n) == 1000 {
		h = height(p)
	} else {
		h = xOverN(height(p), 1000) * count(n) // 이만큼 공간이 필요하다
	}
	if (h <= 0 || h <= delta) && height(p)+height(r) <= dimen(n) {
		setPageGoal(pageGoal() - h); setHeight(r, height(r)+height(p))
	} else {
		@<삽입물을 나누는 가장 좋은 방법을 찾고 |typ(r)|를 |splitUp|으로 바꾼다@>
	}
}
goto contribute

@ 레지스터 \.{\\skip}~|n|의 값과 \.{\\box}~|n|의 높이 더하기 깊이는 새 쪽에서 첫 \.{\\insert}~|n| 노드를 만났을 때에만 기록해 둔다.
첫 \.{\\insert}~|n| 뒤에 \.{\\box}~|n|의 내용을 바꾸는 사용자는 아주 조심스럽거나 아주 운이 좋거나, 아니면 둘 다여야 한다. 목표 높이에서는
상자의 높이와 \.{\\skip}~|n|을 \.{\\count}~|n|/1000배로 빼고, \.{\\skip}의 늘어남과 줄어듦은 쪽 합계에 더한다.

@<|subtype(r)=qi(n)|인 쪽 삽입 노드를...@>=
q = getNode(pageInsNodeSize); setLink(q, link(r)); setLink(r, q); r = q
setSubtype(r, qi(n)); setType(r, inserting); ensureVbox(n)
if box(n) == null {
	setHeight(r, 0)
} else {
	setHeight(r, height(box(n))+depth(box(n)))
}
setBestInsPtr(r, null)
q = skip(n)
if count(n) == 1000 {
	h = height(r)
} else {
	h = xOverN(height(r), 1000) * count(n)
}
setPageGoal(pageGoal() - h - width(q))
pageSoFar[2+stretchOrder(q)] = pageSoFar[2+stretchOrder(q)] + stretch(q)
setPageShrink(pageShrink() + shrink(q))
if shrinkOrder(q) != normal && shrink(q) != 0 {
	printErr("Infinite glue shrinkage inserted from "); printEsc("skip")
@.Infinite glue shrinkage...@>
	printInt(n)
	help3("The correction glue for page breaking with insertions",
		"must have finite shrinkability. But you may proceed,",
		"since the offensive shrinkability has been made finite.")
	reportError()
}

@ 다음은 비상시에 긴 각주를 여러 쪽에 걸쳐 나누는 코드다. 지금 상황을 다시 간추려 볼 만하다. 노드 |p|는 상자 |n|에 넣을 삽입물이다. 이
삽입물은 통째로는 들어맞지 않는다. 넣으면 상자 |n|의 전체 내용이 \.{\\dimen}~|n|보다 커지거나, 늘어나는 양 |h|가 쓸 수 있는 공간 |delta|보다
커지거나, 둘 다이기 때문이다. (이 양 |h|에는 삽입 배율, 곧 \.{\\count}~|n|을 1000으로 나눈 것이 곱해져 있다.) 이제 \.{\\vsplit}와 같은
기준으로 삽입물의 세로 목록을 나누는 가장 좋은 방법을 고른다. 나눈 자리의 벌점은 |insertPenalties|에 더한다.

@<삽입물을 나누는 가장 좋은 방법을...@>=
if count(n) <= 0 {
	w = maxDimen
} else {
	w = pageGoal() - pageTotal() - pageDepth()
	if count(n) != 1000 {
		w = xOverN(w, count(n)) * 1000
	}
}
if w > dimen(n)-height(r) {
	w = dimen(n) - height(r)
}
q = vertBreak(insPtr(p), w, depth(p))
setHeight(r, height(r)+bestHeightPlusDepth)
if stat && tracingPages() > 0 {
	@<삽입물 나누기 비용을 보인다@>
}
if count(n) != 1000 {
	bestHeightPlusDepth = xOverN(bestHeightPlusDepth, 1000) * count(n)
}
setPageGoal(pageGoal() - bestHeightPlusDepth)
setType(r, splitUp); setBrokenPtr(r, q); setBrokenIns(r, p)
if q == null {
	insertPenalties += ejectPenalty
} else if typ(q) == penaltyNode {
	insertPenalties += penalty(q)
}

@ 매개변수 \.{\\tracingpages}가 양수이면 `\.{\% split200 to 100.0,98.0 p=-10000}'처럼 삽입물을 나눈 결과를 찍는다.
@<삽입물 나누기 비용을...@>=
beginDiagnostic(); printNl("% split"); printInt(n)
@.split@>
printStr(" to "); printScaled(w)
printChar(','); printScaled(bestHeightPlusDepth)
printStr(" p=")
if q == null {
	printInt(ejectPenalty)
} else if typ(q) == penaltyNode {
	printInt(penalty(q))
} else {
	printChar('0')
}
endDiagnostic(false)

@ 다음 쪽 나눔 앞에 나올 수 있는 내용을 다 보고 나면, 쪽 조립기는 결정을 내린다. 나쁨이 가장 작은 나눔에서 완성된 ``쪽''을 상자 255에
넣고, 삽입물은 저마다 제 상자에 덧붙인다.

표시 |topMark|, |firstMark|, |botMark|의 값도 정한다. 앞 쪽의 |botMark|가 새 쪽의 |topMark|가 된다. 프로그램은 |botMark!=null|이면
|firstMark!=null|이라는 사실을 이용하고, |botMark=null|이면 |topMark=firstMark=null|이라는 것도 안다.

서브루틴 |fireUp|은 현재 쪽을 가장 좋은 곳에서 출력할 준비를 한 다음, 사용자의 출력 루틴이 있으면 그것을 작동시키고, 없으면 그냥 쪽을
내보낸다. 매개변수 |c|는 출력을 강제하기로 결정했을 때 쪽에 들어오고 있던 노드다.

@<|fireUp|이라는...@>=
func fireUp(c pointer) {
	var p, q, r, s pointer // 살피거나 바꾸는 노드들
	var prevP pointer // |p|의 앞 노드
	var n int32 // 삽입 상자 번호; |minQuarterword .. 255|
	var wait bool // 지금 삽입물을 다음으로 미루어야 하는가?
	@<|outputPenalty|의 값을 정한다@>
	if botMark() != null {
		if topMark() != null {
			deleteTokenRef(topMark())
		}
		setTopMark(botMark()); addTokenRef(topMark())
		deleteTokenRef(firstMark()); setFirstMark(null)
	}
	@<최적의 현재 쪽을 상자 255에 넣고, 삽입물을 덧붙이고, 나머지를 기여 목록에 되돌린다@>
	if topMark() != null && firstMark() == null {
		setFirstMark(topMark()); addTokenRef(topMark())
	}
	if outputRoutine() != null {
		if deadCycles >= maxDeadCycles() {
			@<죽은 순환이 너무 많이 이어졌다고 설명한다@>
		} else {
			@<사용자의 출력 루틴을 작동시키고 |return|한다@>
		}
	}
	@<기본 출력 루틴을 수행한다@>
}

@ 쪽을 나눈 자리의 벌점을 \.{\\outputpenalty}에 넣고, 그 벌점 노드는 무한 벌점으로 바꾸어 둔다. 출력 루틴이 쪽을 기여 목록으로 되돌렸을 때
같은 자리에서 다시 나뉘지 않게 하려는 것이다. 벌점이 아닌 곳에서 나누었으면 \.{\\outputpenalty}는 10000이다.
@<|outputPenalty|의 값을...@>=
if typ(bestPageBreak) == penaltyNode {
	geqWordDefine(intBase+outputPenaltyCode, penalty(bestPageBreak))
	setPenalty(bestPageBreak, infPenalty)
} else {
	geqWordDefine(intBase+outputPenaltyCode, infPenalty)
}

@ 쪽을 마침내 출력할 준비를 하는 동안 포인터 |p|는 세로 목록을 훑고, |prevP|가 그 뒤를 따른다. 포인터 |q|는 다음 쪽으로 미루는 삽입물
목록의 꼬리다. 삽입 노드를 만나면 그 내용을 해당 상자에 넣거나 미루고, 표시 노드를 만나면 표시를 고친다.

이 코드는 |firstMark|와 |botMark|도 고친다.

@<최적의 현재 쪽을 상자 255에...@>=
if c == bestPageBreak {
	bestPageBreak = null // |c|는 아직 이어지지 않았다
}
@<출력 전에 상자 255가 비었는지 확인한다@>
insertPenalties = 0 // 이것은 미룬 삽입물의 수를 셀 것이다
saveSplitTopSkip := splitTopSkip() // |splitTopSkip|의 저장된 값
if holdingInserts() <= 0 {
	@<삽입물에 관련된 모든 상자를 큐처럼 쓰도록 준비한다@>
}
q = holdHead; setLink(q, null); prevP = pageHead; p = link(prevP)
for p != bestPageBreak {
	if typ(p) == insNode {
		if holdingInserts() <= 0 {
			@<노드 |p|가 지정한 내용을 상자에 넣거나 다음 쪽으로 미룬다@>
		}
	} else if typ(p) == markNode {
		@<|firstMark|와 |botMark|의 값을 갱신한다@>
	}
	prevP = p; p = link(prevP)
}
setSplitTopSkip(saveSplitTopSkip)
@<현재 쪽을 노드 |p|에서 나누어 상자~255에 넣고 나머지를 기여 목록에 둔다@>
@<쪽 삽입 노드들을 지운다@>

@ 출력하기 전에 상자 255가 비어 있는지 확인한다. 비어 있지 않으면 오류를 알리고 비운다.
@<출력 전에 상자 255가...@>=
if box(255) != null {
	printErr(""); printEsc("box"); printStr("255 is not void")
@:box255}{\.{\\box255 is not void}@>
	help2("You shouldn't use \\box255 except in \\output routines.",
		"Proceed, and I'll discard its present contents.")
	boxError(255)
}

@ 첫 표시는 |firstMark|로, 마지막 표시는 |botMark|로 삼는다.
@<|firstMark|와 |botMark|의...@>=
if firstMark() == null {
	setFirstMark(markPtr(p))
	addTokenRef(firstMark())
}
if botMark() != null {
	deleteTokenRef(botMark())
}
setBotMark(markPtr(p)); addTokenRef(botMark())

@ 다음 코드가 실행될 때 현재 쪽은 노드 |link(pageHead)|부터 노드 |prevP|까지이고, |p|부터 |pageTail|까지의 노드들은 기여 목록의 앞에 다시
놓아야 한다. 또 미룬 삽입물들은 |link(holdHead)|부터 |q|까지의 목록에 있다. 사용자의 출력 루틴이 도는 동안 안전하게 보관하려고 이것들을
현재 쪽 목록에 넣어 둔다. 여기서 |q=holdHead|일 수도 있다. 그리고 |prevP=pageTail|일 때, 그리고 오직 그때에만 |p=null|이다. 프로시저
|vpackage| 안에서는 오류 메시지를 억누른다. 삽입물을 위한 \.{\\skip} 레지스터의 늘어남과 줄어듦이 실제로는 상자에 없으므로, 상자가 그
때문에 넘치거나 덜 찬 것처럼 보일 수도 있기 때문이다.

여기서도 기여 목록의 꼬리는 |nest[0].tailField|다.

@<현재 쪽을 노드 |p|에서 나누어...@>=
if p != null {
	if link(contribHead) == null {
		if nestPtr == 0 {
			tail = pageTail
		} else {
			nest[0].tailField = pageTail
		}
	}
	setLink(pageTail, link(contribHead))
	setLink(contribHead, p)
	setLink(prevP, null)
}
saveVbadness := vbadness() // |vbadness|의 저장된 값
setVbadness(infBad)
saveVfuzz := vfuzz() // |vfuzz|의 저장된 값
setVfuzz(maxDimen) // 오류 메시지를 억누른다
setBoxReg(255, vpackage(link(pageHead), bestSize, exactly, pageMaxDepth))
setVbadness(saveVbadness); setVfuzz(saveVfuzz)
if lastGlue != maxHalfword {
	deleteGlueRef(lastGlue)
}
@<새 현재 쪽을 시작한다@> // 이것은 |lastGlue=maxHalfword|로 한다
if q != holdHead {
	setLink(pageHead, link(holdHead)); pageTail = q
}

@ 많은 삽입물이 같은 상자에 들어가야 한다면, 그 상자의 마지막 노드의 위치를 알고 싶다. 그래야 정보를 더 이어 붙일 때 시간을 낭비하지
않는다. 그래서 묶는 단계 동안 쪽 삽입 노드의 |lastInsPtr| 필드를 이 목적에 쓴다.

@<삽입물에 관련된 모든 상자를...@>=
r = link(pageInsHead)
for r != pageInsHead {
	if bestInsPtr(r) != null {
		n = qo(subtype(r)); ensureVbox(n)
		if box(n) == null {
			setBoxReg(n, newNullBox())
		}
		p = box(n) + listOffset
		for link(p) != null {
			p = link(p)
		}
		setLastInsPtr(r, p)
	}
	r = link(r)
}

@ 쪽 삽입 노드들을 모두 지우고 목록을 빈 상태로 되돌린다.
@<쪽 삽입 노드들을...@>=
r = link(pageInsHead)
for r != pageInsHead {
	q = link(r); freeNode(r, pageInsNodeSize); r = q
}
setLink(pageInsHead, pageInsHead)

@ 삽입 노드~|r|에 대응하는 상자는 그 상자에 마지막 삽입을 한 바로 뒤에 |bestInsPtr=null|로 하고 다시 꾸린다. 이 마지막 삽입이 `|splitUp|'이면,
나누고 쳐낸 뒤의 나머지(있으면)는 다음 쪽으로 넘어간다.

노드 |p|가 지정한 내용을 알맞은 상자에 넣거나 다음 쪽으로 미루고, 노드 |p|를 현재 쪽에서 지운다.

@<노드 |p|가 지정한 내용을...@>=
r = link(pageInsHead)
for subtype(r) != subtype(p) {
	r = link(r)
}
if bestInsPtr(r) == null {
	wait = true
} else {
	wait = false; s = lastInsPtr(r); setLink(s, insPtr(p))
	if bestInsPtr(r) == p {
		@<노드 |r|이 지정한 상자를 마무리한다@>
	} else {
		for link(s) != null {
			s = link(s)
		}
		setLastInsPtr(r, s)
	}
}
@<삽입 노드 |p|를 노드 |q| 뒤에 덧붙이거나 지운다@>

@ 필요하면 노드 |p|를 나누고, 나눈 뒤 노드 |p|에 나머지가 남으면 |wait=true|로 한다. 나머지는 \.{\\splittopskip}으로 위 끝을 맞추어 다음
쪽에 다시 넣는다.

@<노드 |r|이 지정한 상자를...@>=
if typ(r) == splitUp && brokenIns(r) == p && brokenPtr(r) != null {
	for link(s) != brokenPtr(r) {
		s = link(s)
	}
	setLink(s, null)
	setSplitTopSkip(splitTopPtr(p))
	setInsPtr(p, prunePageTop(brokenPtr(r)))
	if insPtr(p) != null {
		tempPtr = vpack(insPtr(p), natural, additional)
		setHeight(p, height(tempPtr)+depth(tempPtr))
		freeNode(tempPtr, boxNodeSize); wait = true
	}
}
setBestInsPtr(r, null)
n = qo(subtype(r))
tempPtr = listPtr(box(n))
freeNode(box(n), boxNodeSize)
setBoxReg(n, vpack(tempPtr, natural, additional))

@ 미룰 삽입 노드 |p|는 노드 |q| 뒤에 덧붙이고 현재 쪽에서 뺀다. 다 넣은 것이면 노드 |p|를 지운다. 미룬 삽입물의 수는 |insertPenalties|에 센다.
출력 루틴 안에서 \.{\\insertpenalties}는 이 수를 뜻한다.

@<삽입 노드 |p|를 노드 |q| 뒤에...@>=
setLink(prevP, link(p)); setLink(p, null)
if wait {
	setLink(q, p); q = p; insertPenalties++
} else {
	deleteGlueRef(splitTopPtr(p))
	freeNode(p, insNodeSize)
}
p = prevP

@ 사용자가 출력 루틴을 지정하지 않았으면, |link(pageHead)|부터 |pageTail|까지의 미룬 삽입물 목록을 기여 목록으로 옮겨야 한다.

@<기본 출력 루틴을...@>=
if link(pageHead) != null {
	if link(contribHead) == null {
		if nestPtr == 0 {
			tail = pageTail
		} else {
			nest[0].tailField = pageTail // |contribTail|
		}
	} else {
		setLink(pageTail, link(contribHead))
	}
	setLink(contribHead, link(pageHead))
	setLink(pageHead, null); pageTail = pageHead
}
shipOut(box(255)); setBoxReg(255, null)

@ 출력 루틴이 \.{\\shipout}을 하지 않고 \.{\\maxdeadcycles}번 넘게 잇달아 돌았으면 출력 루틴이 잘못된 것으로 보고, 상자 255를 직접
내보낸다.
@<죽은 순환이 너무 많이...@>=
printErr("Output loop---"); printInt(deadCycles)
@.Output loop...@>
printStr(" consecutive dead cycles")
help3("I've concluded that your \\output is awry; it never does a",
	"\\shipout, so I'm shipping \\box255 out myself. Next time",
	"increase \\maxdeadcycles if you want me to be more patient!")
reportError()

@ 사용자의 출력 루틴을 시작한다. 내부 세로 모드의 새 수준에 들어가고, 출력 루틴의 토큰 목록을 읽기 시작하고, 그룹을 연다. 출력 루틴은
중괄호로 둘러싸여 저장되어 있으므로 먼저 왼쪽 중괄호를 읽는다.
@<사용자의 출력 루틴을 작동시키고...@>=
outputActive = true
deadCycles++
pushNest(); mode = -vmode; setPrevDepth(ignoreDepth); modeLine = -line
beginTokenList(outputRoutine(), outputText)
newSaveLevel(outputGroup); normalParagraph()
scanLeftBrace()
return

@ 사용자의 출력 루틴이 끝나면 내부 세로 모드에서 세로 목록을 하나 만들어 놓았을 것이다. \TeX은 그 목록을 미룬 삽입물 뒤, 기여 목록의
앞에 놓고 쪽 조립기를 다시 돌린다.

@<출력 루틴이 끝난 뒤 쪽 조립기를 다시 시작한다@>=
if loc != null || (tokenType() != outputText && tokenType() != backedUp) {
	@<균형이 맞지 않는 출력 루틴에서 회복한다@>
}
endTokenList() // 출력이 더 일어날 때를 대비해 스택 공간을 아낀다
endGraf(); unsave(); outputActive = false; insertPenalties = 0
@<출력 뒤에 상자 255가 비었는지 확인한다@>
if tail != head { // 현재 목록은 미룬 삽입물 뒤에 간다
	setLink(pageTail, link(head))
	pageTail = tail
}
if link(pageHead) != null { // 그리고 둘 다 미룬 기여 내용 앞에 간다
	if link(contribHead) == null {
		nest[0].tailField = pageTail // |contribTail|
	}
	setLink(pageTail, link(contribHead))
	setLink(contribHead, link(pageHead))
	setLink(pageHead, null); pageTail = pageHead
}
popNest(); buildPage()

@ 출력 루틴의 중괄호가 맞지 않으면 오류를 알리고, 남은 토큰을 다 읽어 버린다.
@<균형이 맞지 않는 출력 루틴에서...@>=
printErr("Unbalanced output routine")
@.Unbalanced output routine@>
help2("Your sneaky output routine has problematic {'s and/or }'s.",
	"I can't handle that very well; good luck.")
reportError()
for {
	getToken()
	if loc == null {
		break
	}
} // 파일에서 읽고 있으면 끝없이 돈다. |null=minHalfword<=0|이기 때문이다

@ 출력 루틴이 상자 255를 다 쓰지 않았으면 오류를 알리고 비운다.
@<출력 뒤에 상자 255가...@>=
if box(255) != null {
	printErr("Output routine didn't use all of ")
	printEsc("box"); printInt(255)
@.Output routine didn't use...@>
	help3("Your \\output commands should empty \\box255,",
		"e.g., by saying `\\shipout\\box255'.",
		"Proceed; I'll discard its present contents.")
	boxError(255)
}

@* 최고 집행부.
이제 |mainControl| 루틴에 이르렀다. 이 루틴에는 \TeX의 온갖 부분이 저마다 제 일을 올바른 차례로 하게 하는 주 스위치가 들어 있다.
\TeX에 비유하면 위에 해당한다.

어떤 뜻에서 이것은 프로그램의 웅장한 절정이다. 그토록 애써 만든 도구를 여기서 다 쓴다. 다른 뜻에서 이것은 프로그램에서 가장 어수선한
부분이다. 여기저기 흩어진 코드 조각들을 가리킬 수밖에 없어서, 다른 곳에서 정한 관례를 떠올리려고 앞뒤로 쪽을 넘겨 보지 않고는 무슨
일이 일어나는지 온전히 이해할 수 없다. 우리는 이제 거미줄(web)의 한가운데, 곧 다른 부분 대부분과 닿아서 그것들을 하나로 묶는 중추
신경계에 와 있다.
@^brain@>

루틴 |mainControl| 자체의 짜임새는 꽤 단순하다. 그 안에 |bigSwitch|라는 레이블이 있고, 그 지점에서 |getXToken|으로 입력의 다음 토큰을
가져온다. 그런 다음 현재 모드와 새로 가져온 명령 코드에 따라 약 100가지 방향 가운데 하나로 빠르게 갈라진다. 합 |abs(mode)+curCmd|가
다음에 무엇을 할지 알려 준다. 이를테면 `|vmode+letter|' 경우는 세로 모드(또는 내부 세로 모드)에서 글자가 나왔을 때다. 이 경우에는 새
문단을 시작하고 가로 모드로 들어간다. 그리고 그 글자를 다시 읽어 문단의 첫 글자로 삼는다.

이 여러 갈래 스위치를 담은 큰 |switch| 문에는 |reswitch|라는 레이블이 붙어 있어서, 다음 토큰을 이미 가져왔을 때는 |goto reswitch|할 수
있다. 경우 대부분은 꽤 짧다. 그 경우의 일을 하는 ``동작 프로시저''를 부른 다음, |goto reswitch|하거나 |switch| 문의 끝으로 ``흘러
내려가서'' |bigSwitch|로 돌아간다. 그래서 |mainControl|은 할 일이 그토록 많은데도 아주 큰 프로시저가 아니다. 프로시저 크기를 심하게
제한하는 컴파일러도 다룰 수 있을 만큼 작다.
@!@^action procedure@>

한 경우만은 특별히 다룬다. 전형적인 응용에서 \TeX이 하는 일의 대부분을 차지하기 때문이다. 보통의 텍스트를 읽어서 합자와 커닝을
찾으며 |charNode| 레코드로 바꾸는 과정은 \TeX의 ``안쪽 루프''의 일부다. 안쪽 루프가 빠르면 프로그램 전체가 효율적으로 돌아가므로,
이 부분은 특별히 공들여 썼다.

@ 먼저 |mainControl|의 안쪽 루프에 집중하고, 다른 경우들은 나중에 생각하자. 작업이 시작되면 먼저 \.{\\everyjob}을 끼워 넣는다. 그다음
|bigSwitch|에서 토큰을 하나 읽고, 가로 모드의 글자나 기타 문자나 \.{\\char}이면 주 루프로, 가로 모드의 공백이면 공백 처리로, 나머지는
큰 |switch|로 보낸다.
@^inner loop@>


@<함수들@>=
@<|mainControl|이 쓰는 동작 프로시저들@>@;
@<|handleRightBrace|라는 프로시저를 선언한다@>@;
func mainControl() { // \TeX의 활동을 다스린다
	var t int32 // 만능 임시 변수
	if everyJob() != null {
		beginTokenList(everyJob(), everyJobText)
	}
bigSwitch:
	getXToken()
reswitch:
	@<요청이 있으면 진단 정보를 준다@>
	switch abs(mode) + curCmd {
	case hmode + letter, hmode + otherChar, hmode + charGiven: goto mainLoop
	case hmode + charNum: scanCharNum(); curChr = curVal; goto mainLoop
	case hmode + noBoundary:
		getXToken()
		if curCmd == letter || curCmd == otherChar || curCmd == charGiven || curCmd == charNum {
			cancelBoundary = true
		}
		goto reswitch
	case hmode + spacer:
		if spaceFactor() == 1000 { goto appendNormalSpace } else { appSpace() }
	case hmode + exSpace, mmode + exSpace: goto appendNormalSpace
	@<안쪽 루프에 속하지 않는 |mainControl|의 경우들@>
	} // 큰 |case| 문의 끝
	goto bigSwitch
mainLoop:
	@<문자 |curChr|와 뒤따르는 문자들을 현재 가로 목록에 덧붙인다@>
appendNormalSpace:
	@<현재 목록에 보통 낱말 사이 공백을 덧붙이고 |goto bigSwitch|@>
}

@ 레이블 |bigSwitch|에서 새 토큰을 막 가져왔을 때가 \TeX의 활동을 지켜보기에 가장 좋은 곳이다. 끼어들기가 있으면 여기서 처리하고,
\.{\\tracingcommands}가 양수이면 명령을 보여 준다.
@^debugging@>

@<요청이 있으면 진단 정보를...@>=
if interrupt != 0 && okToInterrupt {
	backInput(); checkInterrupt(); goto bigSwitch
}
if debug && panicking {
	checkMem(false)
}
if tracingCommands() > 0 {
	showCurCmdChr()
}

@ 프로그램의 다음 부분은 처음에 ``섣부른 최적화는 모든 악의 뿌리다''라는 철학에 따라 구조적으로 짰다. 그런 다음 가장 흔한 동작들이
되풀이되는 일 없이 곧장 진행되도록 스파게티 조각들로 다시 배치했다.

이 알고리즘의 최적화하지 않은 원래 모양은 앞에서 하이픈 넣기와 함께 설명한 |reconstitute| 프로시저와 닮았다. 여기서도 문자 |curL|과
|curR| 사이에 보이지 않는 ``커서''가 있다. 주된 차이는 이제 |ligStack|에 가짜 합자뿐 아니라 문자 노드도 들어 있을 수 있다는 것이다. 이
스택은 이제 대개 비어 있지 않다. 입력의 다음 문자(있으면)가 거기 들어 있기 때문이다. 루틴 |mainControl|에서는
|character(ligStack)=fontFalseBchar[curFont]|일 때를 빼면, |ligStack>null|이면 |curR=character(ligStack)|이고 그렇지 않으면
|curR=fontBchar[curFont]|이다. 전역 변수가 몇 개 더 필요하다.

@<전역 변수@>=
var @!mainF internalFontNumber // 현재 글꼴
var @!mainI fourQuarters // |curL|의 문자 정보 바이트
var @!mainJ fourQuarters // 합자/커닝 명령
var @!mainK fontIndex // |fontInfo|의 첨자
var @!mainP pointer // 목록을 다루는 임시 레지스터
var @!mainS int32 // 공백 인자 값
var @!bchar halfword // 현재 글꼴의 경계 문자, 또는 |nonChar|
var @!falseBchar halfword // |bchar|와 맞는 없는 문자, 또는 |nonChar|
var @!cancelBoundary bool // 왼쪽 경계를 무시해야 하는가?
var @!insDisc bool // 선택적 나눔 노드를 넣어야 하는가?

@ 주 루프의 불 변수들은 보통 거짓이고, 루프를 떠나기 전에 늘 거짓으로 되돌린다. 그래서 매번 초기화하는 수고를 던다.

@<핵심 변수들의...@>=
ligaturePresent = false; cancelBoundary = false; lftHit = false; rtHit = false
insDisc = false

@ 공백 인자부터 정한다. 코드가 |sfCode(curChr)=0|이면 |spaceFactor|를 바꾸지 않는다. 그렇지 않으면 |sfCode(curChr)|로 하는데, 다만 1000보다
작은 값에서 1000을 넘는 값으로 단숨에 바뀌지는 않아야 한다. 이를테면 대문자 뒤의 마침표(`\.{U.S.}'의 `\.S.')는 문장 끝으로 보지 않는다.
가장 흔한 경우는 |sfCode(curChr)=1000|이므로 이 경우가 빠르기를 바란다.

주 루프의 전체 짜임새를 여기 보인다. 몇몇 레이블은 각 절 안에 있다. 문자를 하나 읽으면 |ligStack|에 넣고, 커서를 오른쪽으로 옮기면서
합자와 커닝을 찾고, 다음 문자를 내다본다.
@^inner loop@>

공백 인자를 맞추는 작은 함수 |adjustSpaceFactor|는 두 곳에서 쓴다.

@<문자 |curChr|와 뒤따르는...@>=
adjustSpaceFactor()
mainF = curFont()
bchar = fontBchar[mainF]; falseBchar = fontFalseBchar[mainF]
if mode > 0 && language() != clang() {
	fixLanguage()
}
ligStack = fastGetAvail(); setFontField(ligStack, mainF); curL = qi(curChr)
setCharacter(ligStack, curL)
curQ = tail
if cancelBoundary {
	cancelBoundary = false; mainK = nonAddress
} else {
	mainK = bcharLabel[mainF]
}
if mainK == nonAddress {
	goto mainLoopMove2 // 왼쪽 경계 처리를 하지 않는다
}
curR = curL; curL = nonChar
goto mainLigLoop1 // 커서가 왼쪽 경계 뒤에 있는 채로 시작한다
@#
mainLoopWrapup:
	@<|ligaturePresent|이면 합자 노드를 만들고, 알맞으면 널 선택적 나눔을 넣는다@>
mainLoopMove:
	@<커서를 한 걸음 오른쪽으로 옮긴다@>
mainLoopLookahead:
	@<다른 문자를 내다보거나, 없으면 |ligStack|을 비워 둔다@>
mainLigLoop:
	@<|curL|과 |curR|에 관련된 합자/커닝 명령이 있으면 텍스트를 고친다@>
mainLoopMoveLig:
	@<가짜 합자를 지나 커서를 옮기고 |goto mainLoopLookahead|나 |mainLigLoop|@>

@ 함수 |adjustSpaceFactor|는 현재 문자의 |sfCode|에 따라 공백 인자를 바꾼다. 공백 인자가 1000보다 작을 때 1000을 넘는 코드가 오면 1000으로
한다.

@<함수들@>=
func adjustSpaceFactor() {
	mainS = sfCode(curChr)
	if mainS == 1000 {
		setSpaceFactor(1000)
	} else if mainS < 1000 {
		if mainS > 0 {
			setSpaceFactor(mainS)
		}
	} else if spaceFactor() < 1000 {
		setSpaceFactor(1000)
	} else {
		setSpaceFactor(mainS)
	}
}

@ 함수 |wrapup|을 부를 때 |link(curQ)|가 널이 아니면, |curQ|는 합자 문자~|curL|을 만드는 동안 써 버린 문자들의 목록을 가리킨다.

명시적 하이픈(그 글꼴의 \.{\\hyphenchar}) 뒤에는 빈 선택적 나눔을 넣어 거기서 줄을 나눌 수 있게 한다. 다만 제한된 가로 모드에서는 넣지
않는다. 특히 이렇게 하면 선택적 나눔 노드를 다른 선택적 나눔 안에 넣는 일을 피한다.
@^inner loop@>

합자 노드를 만드는 작은 함수 |packLig|와 |wrapup|은 전역 변수만 쓴다. 함수 |wrapup|은 세 곳에서 쓰며, 그 매개변수는 |rtHit|이거나
|false|다.

@<함수들@>=
func packLig(z bool) { // 매개변수는 |rtHit|이거나 |false|다
	mainP = newLigature(mainF, curL, link(curQ))
	if lftHit {
		setSubtype(mainP, 2); lftHit = false
	}
	if z && ligStack == null {
		setSubtype(mainP, subtype(mainP)+1); rtHit = false
	}
	setLink(curQ, mainP); tail = mainP; ligaturePresent = false
}

func wrapup(z bool) {
	if curL < nonChar {
		if link(curQ) > null && character(tail) == qi(hyphenChar[mainF]) {
			insDisc = true
		}
		if ligaturePresent {
			packLig(z)
		}
		if insDisc {
			insDisc = false
			if mode > 0 {
				tailAppend(newDisc())
			}
		}
	}
}

@ 합자가 있으면 합자 노드를 만든다.
@<|ligaturePresent|이면 합자 노드를...@>=
wrapup(rtHit)

@ 커서 바로 뒤에 오른쪽 경계가 있으면 |goto reswitch|하고, 무효한 문자가 있으면 |goto bigSwitch|하고, 그렇지 않으면 커서를 한 걸음
오른쪽으로 옮기고 |goto mainLigLoop|한다. 옮길 때 그 문자가 글꼴에 없으면 경고하고 버린다.

@<커서를 한 걸음...@>=
@^inner loop@>
if ligStack == null {
	goto reswitch
}
curQ = tail; curL = character(ligStack)
mainLoopMove1:
	if !isCharNode(ligStack) {
		goto mainLoopMoveLig
	}
mainLoopMove2:
	if curChr < fontBc[mainF] || curChr > fontEc[mainF] {
		charWarning(mainF, curChr); freeAvail(ligStack); goto bigSwitch
	}
	mainI = charInfo(mainF, curL)
	if !charExists(mainI) {
		charWarning(mainF, curChr); freeAvail(ligStack); goto bigSwitch
	}
	setLink(tail, ligStack); tail = ligStack // 다음은 |mainLoopLookahead|다

@ 여기는 |mainLoopMoveLig|다. 이 코드를 시작할 때 |curQ=tail|이고 |curL=character(ligStack)|이다. 가짜 합자를 지나가며 그 안에 남아 있던
원래 문자를 목록에 덧붙인다.

@<가짜 합자를 지나...@>=
mainP = ligPtr(ligStack)
if mainP > null {
	tailAppend(mainP) // 문자 하나를 덧붙인다
}
tempPtr = ligStack; ligStack = link(tempPtr)
freeNode(tempPtr, smallNodeSize)
mainI = charInfo(mainF, curL); ligaturePresent = true
if ligStack == null {
	if mainP > null {
		goto mainLoopLookahead
	}
	curR = bchar
} else {
	curR = character(ligStack)
}
goto mainLigLoop

@ 다음 문자를 내다본다. 명령 \.{\\char}의 결과도 합자나 커닝에 참여할 수 있으므로 그것도 내다보아야 한다. 매크로는 펼쳐 보되, 다음
토큰이 \.{\\noboundary}이면 오른쪽 경계를 없앤다. 문자가 아닌 것이 오면 낱말이 끝난 것이다.

@<다른 문자를 내다보거나...@>=
getNext() // 속도를 위해 |curCmd|와 |curChr|만 정한다
if curCmd == letter || curCmd == otherChar || curCmd == charGiven {
	goto mainLoopLookahead1
}
xToken() // 이제 펼치고 |curCmd|, |curChr|, |curTok|를 정한다
if curCmd == letter || curCmd == otherChar || curCmd == charGiven {
	goto mainLoopLookahead1
}
if curCmd == charNum {
	scanCharNum(); curChr = curVal; goto mainLoopLookahead1
}
if curCmd == noBoundary {
	bchar = nonChar
}
curR = bchar; ligStack = null; goto mainLigLoop
mainLoopLookahead1:
	adjustSpaceFactor()
	ligStack = fastGetAvail(); setFontField(ligStack, mainF)
	curR = qi(curChr); setCharacter(ligStack, curR)
	if curR == falseBchar {
		curR = nonChar // 이렇게 하면 엉뚱한 합자를 막는다
	}

@ 합자/커닝 프로그램이 있는 문자는 비교적 적지만, 여기 있는 명령 가운데 몇몇은 \TeX의 안쪽 루프의 일부로 친다. 잠재적으로 긴 순차
@^inner loop@>
탐색을 해야 하기 때문이다. 이를테면 Computer Modern Roman으로 시험해 보니, 실제로 만나는 문자의 40퍼센트쯤에 합자/커닝 프로그램이 있었고,
그런 문자마다 합자/커닝 명령을 네 개쯤 살펴보았다.

이 코드의 처음에서 |mainI=charInfo(mainF,curL)|이다. 두 문자 |curL|과 |curR|에 관련된 명령이 있으면 텍스트를 알맞게 고치고, 없으면 |mainLoopWrapup|으로
빠져나간다.

@<|curL|과 |curR|에 관련된...@>=
if charTag(mainI) != ligTag {
	goto mainLoopWrapup
}
if curR == nonChar {
	goto mainLoopWrapup
}
mainK = ligKernStart(mainF, mainI); mainJ = fontInfo[mainK].qqqq
if skipByte(mainJ) <= stopFlag {
	goto mainLigLoop2
}
mainK = ligKernRestart(mainF, mainJ)
mainLigLoop1:
	mainJ = fontInfo[mainK].qqqq
mainLigLoop2:
	if nextChar(mainJ) == curR && skipByte(mainJ) <= stopFlag {
		@<합자나 커닝 명령을 수행하고, 알맞은 곳으로 돌아간다@>
	}
	if skipByte(mainJ) == qi(0) {
		mainK++
	} else {
		if skipByte(mainJ) >= stopFlag {
			goto mainLoopWrapup
		}
		mainK = mainK + qo(skipByte(mainJ)) + 1
	}
	goto mainLigLoop1

@ 합자나 커닝 명령이 문자와 맞으면, 그 문자는 보통 방법으로 있는지 확인하지 않았어도 글꼴에 있다는 것을 |readFontInfo|의 검사 덕분에 안다.

루틴 |mainControl| 안의 코드를 줄여야 한다면 이 절을 서브루틴으로 만들 수도 있을 것이다. 이 절은 |mainLigLoop|나 |mainLoopWrapup|이나
|mainLoopMove|로 돌아간다. 커닝이면 커닝 노드를 넣고, 합자이면 여덟 가지 합자 종류(\secref{tfm-ligkern})에 따라 커서 둘레의 문자를 바꾼다.

\chardef\?='174 % 문자를 남김을 나타내는 세로 막대

@<합자나 커닝 명령을 수행하고...@>=
if opByte(mainJ) >= kernFlag {
	wrapup(rtHit)
	tailAppend(newKern(charKern(mainF, mainJ))); goto mainLoopMove
}
if curL == nonChar {
	lftHit = true
} else if ligStack == null {
	rtHit = true
}
checkInterrupt() // 끝없는 합자 루프가 있을 때 빠져나갈 길을 둔다
switch opByte(mainJ) {
case qi(1), qi(5): // \.{=:\?}, \.{=:\?>}
	curL = remByte(mainJ)
	mainI = charInfo(mainF, curL); ligaturePresent = true
case qi(2), qi(6): @<|curR|을 바꾸고 |ligStack|을 고친다@> // \.{\?=:}, \.{\?=:>}
case qi(3): // \.{\?=:\?}
	curR = remByte(mainJ)
	mainP = ligStack; ligStack = newLigItem(curR)
	setLink(ligStack, mainP)
case qi(7), qi(11): // \.{\?=:\?>}, \.{\?=:\?>>}
	wrapup(false)
	curQ = tail; curL = remByte(mainJ)
	mainI = charInfo(mainF, curL); ligaturePresent = true
default: // \.{=:}
	curL = remByte(mainJ); ligaturePresent = true
	if ligStack == null {
		goto mainLoopWrapup
	}
	goto mainLoopMove1
}
if opByte(mainJ) > qi(4) && opByte(mainJ) != qi(7) {
	goto mainLoopWrapup
}
if curL < nonChar {
	goto mainLigLoop
}
mainK = bcharLabel[mainF]; goto mainLigLoop1

@ 앞 절의 코드에서 떼어 낸 부분이다. 커서 오른쪽의 문자를 합자 결과로 바꾼다.

@<|curR|을 바꾸고 |ligStack|을...@>=
curR = remByte(mainJ)
if ligStack == null { // 오른쪽 경계 문자를 소비하고 있다
	ligStack = newLigItem(curR); bchar = nonChar
} else if isCharNode(ligStack) { // |link(ligStack)=null|
	mainP = ligStack; ligStack = newLigItem(curR)
	setLigPtr(ligStack, mainP)
} else {
	setCharacter(ligStack, curR)
}

@ 빈칸은 거의 \TeX의 안쪽 루프의 일부다. 대개 빈칸 아닌 문자 다섯 개마다 공백 하나쯤을 만나기 때문이다. 그래서 |mainControl|은 보통
@^inner loop@>
공백에 두 번째로 높은 우선순위를 준다. 공백 인자가 1000이면 여기서 곧바로 글루를 넣고, 아니면 |appSpace|가 공백 인자에 맞추어 늘이고
줄인 글루를 만든다.

매개변수 \.{\\spaceskip} 같은 글루 매개변수를 `\.{0pt}'로 하면, 그 글루 명세가 그저 0으로 가득 찬 어떤 명세가 아니라 정확히 |zeroGlue|가 되도록
나중에 신경 쓸 것이다. 그래서 글루 매개변수가 0인지 검사하기가 간단하다.

@<현재 목록에 보통 낱말 사이 공백을...@>=
if spaceSkip() == zeroGlue {
	@<현재 글꼴의 텍스트 공백을 위한 글루 명세 |mainP|를 찾는다@>
	tempPtr = newGlue(mainP)
} else {
	tempPtr = newParamGlue(spaceSkipCode)
}
setLink(tail, tempPtr); tail = tempPtr
goto bigSwitch

@ 텍스트 글꼴마다 |fontGlue|를 할당해 두면 시간과 메모리를 모두 아낀다. 낱말 사이 공백마다 새 명세를 만들지 않고 이 명세를 함께 쓰기
때문이다. 세 공백 매개변수 가운데 어느 것이든 나중에 \.{\\fontdimen}으로 바뀌면, 프로시저 |findFontDimen|이 여기서 할당한 |fontGlue|
명세를 해제한다.

@<현재 글꼴의 텍스트 공백을 위한...@>=
mainP = fontGlue[curFont()]
if mainP == null {
	mainP = newSpec(zeroGlue); mainK = paramBase[curFont()] + spaceCode
	setWidth(mainP, fontInfo[mainK].sc) // 그것이 |space(curFont)|다
	setStretch(mainP, fontInfo[mainK+1].sc) // 그리고 |spaceStretch(curFont)|
	setShrink(mainP, fontInfo[mainK+2].sc) // 그리고 |spaceShrink(curFont)|
	fontGlue[curFont()] = mainP
}

@ 공백 인자가 1000이 아닐 때의 공백이다. 공백 인자가 2000 이상이고 \.{\\xspaceskip}이 0이 아니면 그것을 쓰고, 아니면 \.{\\spaceskip}이나
글꼴의 공백 글루를 공백 인자에 맞추어 고친 새 명세를 만든다.
@<|mainControl|이 쓰는 동작...@>=
func appSpace() { // |spaceFactor!=1000|일 때 공백을 다룬다
	var q pointer // 글루 노드
	if spaceFactor() >= 2000 && xspaceSkip() != zeroGlue {
		q = newParamGlue(xspaceSkipCode)
	} else {
		if spaceSkip() != zeroGlue {
			mainP = spaceSkip()
		} else {
			@<현재 글꼴의 텍스트 공백을 위한...@>
		}
		mainP = newSpec(mainP)
		@<공백 인자에 따라 |mainP|의 글루 명세를 고친다@>
		q = newGlue(mainP); setGlueRefCount(mainP, null)
	}
	setLink(tail, q); tail = q
}

@ 공백 인자가 2000 이상이면 글꼴의 \.{extra space}를 더한다. 늘어남은 공백 인자/1000배로, 줄어듦은 1000/공백 인자배로 한다. 그래서 문장
끝의 공백은 더 넓고 더 잘 늘어나며 덜 줄어든다.
@<공백 인자에 따라...@>=
if spaceFactor() >= 2000 {
	setWidth(mainP, width(mainP)+extraSpace(curFont()))
}
setStretch(mainP, xnOverD(stretch(mainP), spaceFactor(), 1000))
setShrink(mainP, xnOverD(shrink(mainP), 1000, spaceFactor()))

@ 휴---이것으로 주 루프를 다 다루었다. 이제 다른 조합들을 느긋하게 살펴볼 수 있다.

모드와 상관없는 명령 |c|는 세 경우 |vmode+c|, |hmode+c|, |mmode+c|를 한 |case|에 늘어놓는다.

@<안쪽 루프에 속하지 않는...@>=
case vmode + relax, hmode + relax, mmode + relax, vmode + spacer, mmode + spacer, mmode + noBoundary:
	// 아무것도 하지 않는다
case vmode + ignoreSpaces, hmode + ignoreSpaces, mmode + ignoreSpaces:
	@<공백도 호출도 아닌...@>
	goto reswitch
case vmode + stop:
	if itsAllOver() {
		return // 이것이 유일한 출구다
	}
case @<|mainControl|이 금지하는 경우들@>
	vmode + macParam, hmode + macParam, mmode + macParam:
	reportIllegalCase()
@<수식 아닌 모드의 수식 전용 경우들과 그 반대@>
@<상자와 목록을 만드는 |mainControl|의 경우들@>
@<|mode|에 상관없는 |mainControl|의 경우들@>
@<\TeX의 확장을 위한 |mainControl|의 경우들@>

@ 다음은 사용자가 실수로 수식 모드에 들어가거나 나온 것 같은 경우들이다. 이를테면 문단에서 \.{x\^2}를 쓰면 위첨자 기호가 수식 밖에
나온 것이다. \TeX은 달러 기호를 끼워 넣고 현재 토큰을 다시 읽는다.

여기서도 두 경우 |vmode+c|, |hmode+c|를 나란히 늘어놓는다. 이 절은 레이블 목록만이 아니라 동작까지 담은 |case| 절 전체를 담는다.
\.{gtangle}이 절 끝에 줄바꿈을 넣으므로 레이블 목록 뒤에 쌍점이 오면 \GO/ 문법이 깨지기 때문이다(\secref{print-char}).

@<수식 아닌 모드의 수식 전용...@>=
case vmode + supMark, hmode + supMark, vmode + subMark, hmode + subMark,
	vmode + mathCharNum, hmode + mathCharNum, vmode + mathGiven, hmode + mathGiven,
	vmode + mathComp, hmode + mathComp, vmode + delimNum, hmode + delimNum,
	vmode + leftRight, hmode + leftRight, vmode + above, hmode + above,
	vmode + radical, hmode + radical, vmode + mathStyle, hmode + mathStyle,
	vmode + mathChoice, hmode + mathChoice, vmode + vcenter, hmode + vcenter,
	vmode + nonScript, hmode + nonScript, vmode + mkern, hmode + mkern,
	vmode + limitSwitch, hmode + limitSwitch, vmode + mskip, hmode + mskip,
	vmode + mathAccent, hmode + mathAccent,
	mmode + endv, mmode + parEnd, mmode + stop, mmode + vskip, mmode + unVbox,
	mmode + valign, mmode + hrule:
	insertDollarSign()

@ `\.{Missing \$ inserted}' 오류를 내고 달러 기호를 끼워 넣는다.
@<|mainControl|이 쓰는 동작...@>=
func insertDollarSign() {
	backInput(); curTok = mathShiftToken + '$'
	printErr("Missing $ inserted")
@.Missing \$ inserted@>
	help2("I've inserted a begin-math/end-math symbol since I think",
		"you left one out. Proceed, with fingers crossed.")
	insError()
}

@ 잘못된 상황이 생기면 \TeX은 대개 그 오류에 맞춘 오류 메시지를 낸다. 이를테면 `\.{\\noalign}'은 어느 모드에서도 그냥 나와서는 안 된다.
정당하게 나오는 곳에서는 모두 |alignPeek| 루틴이 알아보기 때문이다. 그래서 `\.{\\noalign}'이 다른 곳에 나오면 특별한 오류 메시지를 낸다.
그러나 때로는 가장 알맞은 오류 메시지가 그저 사용자가 하려던 일이 허락되지 않는다는 것이다. 이를테면 `\.{\\moveleft}'는 세로 모드에서만,
`\.{\\lower}'는 세로 아닌 모드에서만 허락된다. 그런 경우들을 여기와, `See also \dots'에 나오는 다른 절들에 늘어놓는다.

@<|mainControl|이 금지하는...@>=
vmode + vmove, hmode + hmove, mmode + hmove,
vmode + lastItem, hmode + lastItem, mmode + lastItem,

@ 프로시저 `|youCant|'는 현재 명령을 현재 모드에서 쓸 수 없다는 줄을 `\.{! You can't use \\moveleft in horizontal mode}'처럼 찍는다.

@<|mainControl|이 쓰는 동작...@>=
func youCant() {
	printErr("You can't use `")
@.You can't use x in y mode@>
	printCmdChr(curCmd, curChr)
	printStr("' in "); printMode(mode)
}

@ 허락되지 않는 경우를 알리는 프로시저다.
@<|mainControl|이 쓰는 동작...@>=
func reportIllegalCase() {
	youCant()
	help4("Sorry, but I'm not programmed to handle this case;",
		"I'll just pretend that you didn't ask for it.",
		"If you're in the wrong mode, you might be able to",
		"return to the right one by typing `I}' or `I$' or `I\\par'.")
	reportError()
}

@ 어떤 연산은 특권 모드, 곧 |mode>0|일 때만 허락된다. 함수 |privileged|는 이 규칙을 어긴 것을 찾아낸다. 현재 |mode|가 음수이면 오류
메시지를 내고 |false|를 돌려준다. 이를테면 \.{\\end}는 상자 안에서 쓸 수 없다.

@<|mainControl|이 쓰는 동작...@>=
func privileged() bool {
	if mode > 0 {
		return true
	}
	reportIllegalCase(); return false
}

@ 명령 \.{\\dump}와 \.{\\end}는 둘 다 명령 코드가 `|stop|'이므로 어느 것이든 |mainControl|을 마무리 단계로 들어가게 한다.

@<\TeX의 원시 명령을...@>=
primitive("end", stop, 0)
@!@:end_}{\.{\\end} primitive@>
primitive("dump", stop, 1)
@!@:dump_}{\.{\\dump} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case stop:
	if chrCode == 1 { printEsc("dump") } else { printEsc("end") }

@ 명령 |stop|을 만났다고 해서 |mainControl|을 곧바로 떠나고 싶지는 않다. 일이 정말로 멈추기 전에 \.{\\output} 루틴을 여러 번 불러야 할 수도
있기 때문이다. (출력 루틴이 `\.{\\gdef\\end\{...\}}'라고 해서 작업의 수명을 늘릴 수도 있다.) 그래서 |itsAllOver|는 현재 쪽과 기여 목록이
비어 있고, 마지막 출력이 ``죽은 순환''이 아니었을 때에만 |true|다. 그렇지 않으면 \.{\\end}를 되돌려 놓고, 쪽 너비의 빈 상자와 \.{\\vfill}과
\.{\\penalty-1073741824}을 넣어 쪽을 강제로 내보낸 다음 다시 끝내 본다.

@<|mainControl|이 쓰는 동작...@>=
func itsAllOver() bool { // \.{\\end}나 \.{\\dump}가 나타나면 이것을 한다
	if privileged() {
		if pageHead == pageTail && head == tail && deadCycles == 0 {
			return true
		}
		backInput() // 남은 내용을 내보낸 뒤 다시 끝내 보겠다
		tailAppend(newNullBox())
		setWidth(tail, hsize())
		tailAppend(newGlue(fillGlue))
		tailAppend(newPenalty(-0o10000000000))
		buildPage() // \.{\\hbox to \\hsize\{\}\\vfill\\penalty-'10000000000}을 덧붙인다
	}
	return false
}

@* 상자와 목록 만들기.
루틴 |mainControl|의 가장 중요한 부분들은 상자를 만드는 \TeX의 주된 임무에 관련되어 있다. 세로 목록과 가로 목록에 항목을 넣는 일과,
그 목록들을 상자로 바꾸는 일을 다스려야 한다. 필요한 장치는 이미 다 마련했다. 남은 일은 알맞은 때에 ``단추를 누르는'' 것이다.

@ 이 루틴들의 맛보기로 가장 단순한 경우 하나를 생각해 보자. 세로 모드에서 `\.{\\hrule}'이, 또는 가로 모드나 수식 모드에서
`\.{\\vrule}'이 나오면 어떻게 되는가? 루틴 |scanRuleSpec|이 필요한 일의 대부분을 이미 해 주므로 |mainControl|의 코드는 짧다. 그래서
따로 동작 프로시저가 필요 없다.

세로 모드에서 괘선 뒤에는 |prevDepth=ignoreDepth|로 해서 baselineskip 계산을 끈다는 데 눈여겨보자. 괘선 바로 아래 줄은 괘선에 붙어
나오는 것이다.

@<상자와 목록을 만드는...@>=
case vmode + hrule, hmode + vrule, mmode + vrule:
	tailAppend(scanRuleSpec())
	if abs(mode) == vmode {
		setPrevDepth(ignoreDepth)
	} else if abs(mode) == hmode {
		setSpaceFactor(1000)
	}

@ 명령 \.{\\hskip}과 \.{\\vskip} 같은 것의 처리는 조금 더 복잡하다. 그래도 |mainControl|의 코드는 아주 짧다. 그저 동작 루틴 |appendGlue|를
부르기 때문이다. 마찬가지로 \.{\\kern}은 |appendKern|을 부른다.

@<상자와 목록을 만드는...@>=
case vmode + vskip, hmode + hskip, mmode + hskip, mmode + mskip: appendGlue()
case vmode + kern, hmode + kern, mmode + kern, mmode + mkern: appendKern()

@ 명령 코드 |hskip|과 |vskip|은 \.{\\hskip}과 \.{\\vskip}만이 아니라 \.{\\hss}나 \.{\\vfil} 같은 제어 시퀀스에도 쓴다. 차이는 |curChr|의
값에 있다.

@<정의@>=
const (
	@!filCode = iota // \.{\\hfil}과 \.{\\vfil}을 나타낸다
	@!fillCode // \.{\\hfill}과 \.{\\vfill}을 나타낸다
	@!ssCode // \.{\\hss}와 \.{\\vss}를 나타낸다
	@!filNegCode // \.{\\hfilneg}과 \.{\\vfilneg}을 나타낸다
	@!skipCode // \.{\\hskip}과 \.{\\vskip}을 나타낸다
	@!mskipCode // \.{\\mskip}을 나타낸다
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("hskip", hskip, skipCode)
@!@:hskip_}{\.{\\hskip} primitive@>
primitive("hfil", hskip, filCode)
@!@:hfil_}{\.{\\hfil} primitive@>
primitive("hfill", hskip, fillCode)
@!@:hfill_}{\.{\\hfill} primitive@>
primitive("hss", hskip, ssCode)
@!@:hss_}{\.{\\hss} primitive@>
primitive("hfilneg", hskip, filNegCode)
@!@:hfil_neg_}{\.{\\hfilneg} primitive@>
primitive("vskip", vskip, skipCode)
@!@:vskip_}{\.{\\vskip} primitive@>
primitive("vfil", vskip, filCode)
@!@:vfil_}{\.{\\vfil} primitive@>
primitive("vfill", vskip, fillCode)
@!@:vfill_}{\.{\\vfill} primitive@>
primitive("vss", vskip, ssCode)
@!@:vss_}{\.{\\vss} primitive@>
primitive("vfilneg", vskip, filNegCode)
@!@:vfil_neg_}{\.{\\vfilneg} primitive@>
primitive("mskip", mskip, mskipCode)
@!@:mskip_}{\.{\\mskip} primitive@>
primitive("kern", kern, explicit)
@!@:kern_}{\.{\\kern} primitive@>
primitive("mkern", mkern, muGlue)
@!@:mkern_}{\.{\\mkern} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case hskip:
	switch chrCode {
	case skipCode: printEsc("hskip")
	case filCode: printEsc("hfil")
	case fillCode: printEsc("hfill")
	case ssCode: printEsc("hss")
	default: printEsc("hfilneg")
	}
case vskip:
	switch chrCode {
	case skipCode: printEsc("vskip")
	case filCode: printEsc("vfil")
	case fillCode: printEsc("vfill")
	case ssCode: printEsc("vss")
	default: printEsc("vfilneg")
	}
case mskip: printEsc("mskip")
case kern: printEsc("kern")
case mkern: printEsc("mkern")

@ 글루를 만드는 일은 모두 다음 서브루틴에 맡겼다. 명령 \.{\\hfil} 같은 것은 미리 만들어 둔 글루 명세를 쓰고, \.{\\hskip}은 글루를 읽는다.
명령 \.{\\mskip}이면 수식 글루로 표시한다. 이 서브루틴은 |buildPage|를 부르면 안 되는 곳에서도 적어도 한 군데 쓰이므로 |buildPage|를 부르지
않는다.

@<|mainControl|이 쓰는 동작...@>=
func appendGlue() {
	s := curChr // 건너뛰기 명령의 변경자
	switch s {
	case filCode: curVal = filGlue
	case fillCode: curVal = fillGlue
	case ssCode: curVal = ssGlue
	case filNegCode: curVal = filNegGlue
	case skipCode: scanGlue(glueVal)
	case mskipCode: scanGlue(muVal)
	} // 이제 |curVal|은 글루 명세를 가리킨다
	tailAppend(newGlue(curVal))
	if s >= skipCode {
		setGlueRefCount(curVal, glueRefCount(curVal)-1)
		if s > skipCode {
			setSubtype(tail, muGlue)
		}
	}
}

@ 커닝을 넣는다. 명령 \.{\\mkern}이면 mu 단위로 읽는다.
@<|mainControl|이 쓰는 동작...@>=
func appendKern() {
	s := curChr // 커닝 노드의 |subtype|
	scanDimen(s == muGlue, false, false)
	tailAppend(newKern(curVal)); setSubtype(tail, s)
}

@ 상자 만들기에 관련된 동작의 많은 것은 입력에 중괄호가 나오면서 시작된다. 이를테면 사용자가 세로 모드에서 `\.{\\hbox} \.{to}
\.{100pt\{$\langle\,\hbox{\rm hlist}\,\rangle$\}}'라고 하면, 상자 크기에 관한 정보(100pt, |exactly|)를 |saveStack|에 넣고 그 바로 위에
수준 경계 낱말을 두며, |curGroup=adjustedHboxGroup|으로 한다. \TeX은 가로 목록을 처리하려고 제한된 가로 모드로 들어간다. 오른쪽 중괄호가
나오면 결국 |saveStack|이 이전 상태로 돌아가고, 그때 상자 크기에 관한 정보(100pt, |exactly|)를 다시 쓸 수 있다. 상자를 꾸리고 제한된 가로
모드를 떠나서, 새 상자를 바깥 모드의 현재 목록(이 경우 세로 모드의 현재 목록)에 덧붙이고, |hpack|이 상자에서 꺼낸 세로 조정이 있으면 그
뒤에 덧붙인다.

그래서 프로그램의 다음 몇 절은 왼쪽과 오른쪽 중괄호를 다루는 일에 관련되어 있다.

@ 왼쪽 중괄호가 쪽이나 문단 가운데에 나오면 그냥 새 그룹 수준을 들여올 뿐이고, 짝이 맞는 오른쪽 중괄호도 그리 극적인 일을 하지 않는다.
그런 그룹은 모드에도 현재 목록에도 영향을 주지 않는다. 명령 \.{\\begingroup}과 \.{\\endgroup}도 같지만, 중괄호와는 따로 짝을 맞춘다.

@<상자와 목록을 만드는...@>=
case vmode + leftBrace, hmode + leftBrace: newSaveLevel(simpleGroup)
case vmode + beginGroup, hmode + beginGroup, mmode + beginGroup: newSaveLevel(semiSimpleGroup)
case vmode + endGroup, hmode + endGroup, mmode + endGroup:
	if curGroup == semiSimpleGroup { unsave() } else { offSave() }

@ 중괄호 같은 것이 제대로 짝을 이루지 않는 오류를 다루어야 한다. 사용자는 여분의 기호를 넣는 실수를 할 때도 있고, 빠뜨리는 실수를
할 때도 있다. \TeX은 둘을 늘 구별할 수는 없으므로, 짐작을 해 보고 루프에 빠지지 않게 조심한다.

루틴 |offSave|는 현재 그룹 코드가 잘못되었을 때, 이를테면 \.{\\begingroup} 안에서 \.{\\right}를 만났을 때 부른다. 맨 위 수준을 깨끗이
닫는 데 도움이 될 것을 사용자의 입력에 끼워 넣으려 한다.

@<|mainControl|이 쓰는 동작...@>=
func offSave() {
	var p pointer // 끼워 넣은 토큰
	if curGroup == bottomLevel {
		@<현재 토큰을 버리고 짝이 맞지 않았다고 불평한다@>
	} else {
		backInput(); p = getAvail(); setLink(tempHead, p)
		printErr("Missing ")
		@<|curGroup|에 맞는 토큰을 끼워 넣을 준비를 하고 그것을 찍는다@>
		printStr(" inserted"); insList(link(tempHead))
		help5("I've inserted something that you may have forgotten.",
			"(See the <inserted text> above.)",
			"With luck, this will get me unwedged. But if you",
			"really didn't forget anything, try typing `2' now; then",
			"my insertion and my current dilemma will both disappear.")
		reportError()
	}
}

@ 이 시점에서 |link(tempHead)=p|이고, 이것은 빈 한 낱말짜리 노드를 가리키는 포인터다. 그룹의 종류에 따라 빠진 \.{\\endgroup}이나 \.\$나
\.{\\right.}나 \.\}를 끼워 넣는다.

@<|curGroup|에 맞는 토큰을...@>=
switch curGroup {
case semiSimpleGroup:
	setInfo(p, csTokenFlag+frozenEndGroup)
	printEsc("endgroup")
@.Missing \\endgroup inserted@>
case mathShiftGroup:
	setInfo(p, mathShiftToken+'$'); printChar('$')
@.Missing \$ inserted@>
case mathLeftGroup:
	setInfo(p, csTokenFlag+frozenRight); setLink(p, getAvail())
	p = link(p); setInfo(p, otherToken+'.'); printEsc("right.")
@.Missing \\right\hbox{.} inserted@>
@^null delimiter@>
default:
	setInfo(p, rightBraceToken+'}'); printChar('}')
@.Missing \} inserted@>
}

@ 바깥 수준에서 그룹을 닫으려 했다. 현재 토큰을 버리고 짝이 맞지 않았다고 알린다.
@<현재 토큰을 버리고...@>=
printErr("Extra "); printCmdChr(curCmd, curChr)
@.Extra x@>
help1("Things are pretty mixed up, but I think the worst is over.")
reportError()

@ 범주가 |rightBrace|인 문자를 위한 루틴은 여러 경우로 갈라진다. 그룹 코드 |curGroup|에 따라 여러 가지 일이 일어날 수 있기 때문이다.
어떤 종류의 그룹은 오른쪽 중괄호로 끝나서는 안 된다. 그런 때는 문제를 정확히 짚어 주기를 바라며 오류 메시지를 낸다. 이 루틴의 갈래 대부분은
이해할 준비가 되었을 때 나중에 채운다. 그 사이에 그런 오류를 다룰 준비를 해 두어야 한다.

@<상자와 목록을 만드는...@>=
case vmode + rightBrace, hmode + rightBrace, mmode + rightBrace: handleRightBrace()

@ 오른쪽 중괄호를 그룹의 종류에 따라 처리한다. 단순한 그룹이면 값을 되살리기만 하고, 그룹 바깥이면 중괄호가 너무 많다고 알린다.
@<|handleRightBrace|라는...@>=
func handleRightBrace() {
	var p, q pointer // 잠깐 쓰는 변수
	var d scaled // |insertGroup|에서 |splitMaxDepth|를 담는다
	var f int32 // |insertGroup|에서 |floatingPenalty|를 담는다
	switch curGroup {
	case simpleGroup: unsave()
	case bottomLevel:
		printErr("Too many }'s")
@.Too many \}'s@>
		help2("You've closed more groups than you opened.",
			"Such booboos are generally harmless, so keep going.")
		reportError()
	case semiSimpleGroup, mathShiftGroup, mathLeftGroup: extraRightBrace()
	@<|rightBrace|가 미루어 둔 동작을 일으키는 |handleRightBrace|의 경우들@>
	default: confusion("rightbrace")
@:this can't happen rightbrace}{\quad rightbrace@>
	}
}

@ 명령 \.{\\begingroup}이나 \.\$나 \.{\\left}로 연 그룹을 오른쪽 중괄호로 닫으려 했다. 그 중괄호를 버리고 알린다.
@<|mainControl|이 쓰는 동작...@>=
func extraRightBrace() {
	printErr("Extra }, or forgotten ")
@.Extra \}, or forgotten x@>
	switch curGroup {
	case semiSimpleGroup: printEsc("endgroup")
	case mathShiftGroup: printChar('$')
	case mathLeftGroup: printEsc("right")
	}
	help5("I've deleted a group-closing symbol because it seems to be",
		"spurious, as in `$x}$'. But perhaps the } is legitimate and",
		"you forgot something else, as in `\\hbox{$x}'. In such cases",
		"the way to recover is to insert both the forgotten and the",
		"deleted material, e.g., by typing `I$}'.")
	reportError()
	alignState++
}

@ 다음은 문단마다, 그리고 내부 세로 모드에 들어갈 때 기본값으로 돌아가야 할 매개변수들을 되돌리는 곳이다. 매개변수 \.{\\looseness},
\.{\\hangindent}, \.{\\hangafter}, \.{\\parshape}가 그렇다. 이 매개변수들은 문단 하나에만 쓰이는 것이 보통이기 때문이다.

@<|mainControl|이 쓰는 동작...@>=
func normalParagraph() {
	if looseness() != 0 {
		eqWordDefine(intBase+loosenessCode, 0)
	}
	if hangIndent() != 0 {
		eqWordDefine(dimenBase+hangIndentCode, 0)
	}
	if hangAfter() != 1 {
		eqWordDefine(intBase+hangAfterCode, 1)
	}
	if parShapePtr() != null {
		eqDefine(parShapeLoc, shapeRef, null)
	}
}

@ 이제 \.{\\hbox}를 어떻게 다루는지로 돌아가자. 사실 조금 더 넓게 생각해야 한다. `\.{\\setbox3=}\penalty0\.{\\hbox...}'와
`\.{\\leaders}\penalty0\.{\\hbox...}'와 `\.{\\lower3.8pt\\hbox...}' 같은 것은 상자를 꾸린 뒤에 저마다 꽤 다른 일을 해야 하기 때문이다.
거꾸로 `\.{\\setbox3=}' 같은 것 뒤에는 여러 종류의 상자가 올 수 있고, 그런 것을 효율적으로 부호화하고 싶다.

다시 말해 문제가 둘 있다. 상자를 어디에 쓸지(문맥) 나타내는 것과, 어떤 상자인지(종류) 나타내는 것이다.

첫째 문제는 |scanSpec|이 만드는 치수 두 항목 바로 아래에 ``문맥 코드''를 |saveStack|에 넣어서 해결한다. 문맥 코드는 (부호 있는) 옮김
양이거나, |boxFlag=@t$2^{30}$@>|일 때 |>=boxFlag|인 큰 정수다. 코드 |boxFlag|부터 |boxFlag+255|까지는 `\.{\\setbox0}'부터
`\.{\\setbox255}'까지를, 코드 |boxFlag+256|부터 |boxFlag+511|까지는 `\.{\\global\\setbox0}'부터 `\.{\\global\\setbox255}'까지를 나타낸다.
코드 |boxFlag+512|는 `\.{\\shipout}'을, 코드 |boxFlag+513|부터 |boxFlag+515|까지는 `\.{\\leaders}', `\.{\\cleaders}', `\.{\\xleaders}'를
나타낸다. 옮김 양은 치수이므로 절댓값이 $2^{30}$보다 작아 이 코드들과 겹치지 않는다.

둘째 문제는 상자를 만드는 제어 시퀀스에 모두 명령 코드 |makeBox|를 주고, 다음 |chrCode| 값들로 구별해서 해결한다. 곧 |boxCode|, |copyCode|,
|lastBoxCode|, |vsplitCode|, |vtopCode|, |vtopCode+vmode|, |vtopCode+hmode|이다. 뒤의 둘은 각각 \.{\\vbox}와 \.{\\hbox}를 나타낸다.

@<정의@>=
const (
	@!boxFlag = 0o10000000000 // `\.{\\setbox0}'의 문맥 코드
	@!shipOutFlag = boxFlag + 512 // `\.{\\shipout}'의 문맥 코드
	@!leaderFlag = boxFlag + 513 // `\.{\\leaders}'의 문맥 코드
	@!boxCode = 0 // `\.{\\box}'의 |chrCode|
	@!copyCode = 1 // `\.{\\copy}'의 |chrCode|
	@!lastBoxCode = 2 // `\.{\\lastbox}'의 |chrCode|
	@!vsplitCode = 3 // `\.{\\vsplit}'의 |chrCode|
	@!vtopCode = 4 // `\.{\\vtop}'의 |chrCode|
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("moveleft", hmove, 1)
@!@:move_left_}{\.{\\moveleft} primitive@>
primitive("moveright", hmove, 0)
@!@:move_right_}{\.{\\moveright} primitive@>
primitive("raise", vmove, 1)
@!@:raise_}{\.{\\raise} primitive@>
primitive("lower", vmove, 0)
@!@:lower_}{\.{\\lower} primitive@>
@#
primitive("box", makeBox, boxCode)
@!@:box_}{\.{\\box} primitive@>
primitive("copy", makeBox, copyCode)
@!@:copy_}{\.{\\copy} primitive@>
primitive("lastbox", makeBox, lastBoxCode)
@!@:last_box_}{\.{\\lastbox} primitive@>
primitive("vsplit", makeBox, vsplitCode)
@!@:vsplit_}{\.{\\vsplit} primitive@>
primitive("vtop", makeBox, vtopCode)
@!@:vtop_}{\.{\\vtop} primitive@>
primitive("vbox", makeBox, vtopCode+vmode)
@!@:vbox_}{\.{\\vbox} primitive@>
primitive("hbox", makeBox, vtopCode+hmode)
@!@:hbox_}{\.{\\hbox} primitive@>
primitive("shipout", leaderShip, aLeaders-1) // |shipOutFlag=leaderFlag-1|
@!@:ship_out_}{\.{\\shipout} primitive@>
primitive("leaders", leaderShip, aLeaders)
@!@:leaders_}{\.{\\leaders} primitive@>
primitive("cleaders", leaderShip, cLeaders)
@!@:c_leaders_}{\.{\\cleaders} primitive@>
primitive("xleaders", leaderShip, xLeaders)
@!@:x_leaders_}{\.{\\xleaders} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case hmove:
	if chrCode == 1 { printEsc("moveleft") } else { printEsc("moveright") }
case vmove:
	if chrCode == 1 { printEsc("raise") } else { printEsc("lower") }
case makeBox:
	switch chrCode {
	case boxCode: printEsc("box")
	case copyCode: printEsc("copy")
	case lastBoxCode: printEsc("lastbox")
	case vsplitCode: printEsc("vsplit")
	case vtopCode: printEsc("vtop")
	case vtopCode + vmode: printEsc("vbox")
	default: printEsc("hbox")
	}
case leaderShip:
	if chrCode == aLeaders {
		printEsc("leaders")
	} else if chrCode == cLeaders {
		printEsc("cleaders")
	} else if chrCode == xLeaders {
		printEsc("xleaders")
	} else {
		printEsc("shipout")
	}

@ 상자가 필요한 구성은 알맞은 문맥 코드로 |scanBox|를 불러서 시작한다. 루틴 |scanBox|는 다음에 |makeBox| 명령이 오는지 확인한 다음
|beginBox|를 부른다. 그냥 \.{\\hbox} 같은 것이 나오면 문맥 코드는 0, 곧 옮기지 않고 현재 목록에 넣으라는 뜻이다.

@<상자와 목록을 만드는...@>=
case vmode + hmove, hmode + vmove, mmode + vmove:
	t = curChr
	scanNormalDimen()
	if t == 0 { scanBox(curVal) } else { scanBox(-curVal) }
case vmode + leaderShip, hmode + leaderShip, mmode + leaderShip:
	scanBox(leaderFlag - aLeaders + curChr)
case vmode + makeBox, hmode + makeBox, mmode + makeBox: beginBox(0)

@ 전역 변수 |curBox|는 새로 만든 상자를 가리킨다. 상자가 비어 있으면 |curBox=null|이다. 그렇지 않으면 |typ(curBox)=hlistNode|나 |vlistNode|나
|ruleNode|이다. 그 가운데 |ruleNode|는 리더에서만 생길 수 있다.

@<전역 변수@>=
var @!curBox pointer // 문맥에 놓일 상자

@ 프로시저 |boxEnd|는 |boxContext|가 앞에서 설명한 문맥을 나타낼 때, |curBox|를 가지고 그 문맥에 맞는 일을 한다. 목록에 넣거나, 레지스터에
저장하거나, 내보내거나, 리더로 쓴다.

@<|mainControl|이 쓰는 동작...@>=
func boxEnd(boxContext int32) {
	var p pointer // 수식 모드에서 새 상자를 위한 |ordNoad|
	if boxContext < boxFlag {
		@<상자 |curBox|를 |boxContext|만큼 옮겨 현재 목록에 덧붙인다@>
	} else if boxContext < shipOutFlag {
		@<|curBox|를 상자 레지스터에 저장한다@>
	} else if curBox != null {
		if boxContext > shipOutFlag {
			@<|curBox|를 쓰는 새 리더 노드를 덧붙인다@>
		} else {
			shipOut(curBox)
		}
	}
}

@ 상자를 옮겨 현재 목록에 덧붙인다. 세로 모드이면 줄 간격 글루를 넣고 조정 재료도 덧붙이며, 가로 모드이면 공백 인자를 1000으로 하고,
수식 모드이면 상자를 담은 |ordNoad|를 만든다. 전역 변수 |adjustTail|은 현재 상자에 현재 세로 목록에 덧붙여야 할 조정이 들어 있을 수 있을
때, 그리고 오직 그때에만 널이 아니다.

@<상자 |curBox|를 |boxContext|만큼...@>=
if curBox != null {
	setShiftAmount(curBox, boxContext)
	if abs(mode) == vmode {
		appendToVlist(curBox)
		if adjustTail != null {
			if adjustHead != adjustTail {
				setLink(tail, link(adjustHead)); tail = adjustTail
			}
			adjustTail = null
		}
		if mode > 0 {
			buildPage()
		}
	} else {
		if abs(mode) == hmode {
			setSpaceFactor(1000)
		} else {
			p = newNoad()
			setMathType(nucleus(p), subBox)
			setInfo(nucleus(p), curBox); curBox = p
		}
		setLink(tail, curBox); tail = curBox
	}
}

@ 상자를 레지스터에 지역적으로, 또는 \.{\\global}이면 전역적으로 저장한다.
@<|curBox|를 상자 레지스터에...@>=
if boxContext < boxFlag+256 {
	eqDefine(boxBase-boxFlag+boxContext, boxRef, curBox)
} else {
	geqDefine(boxBase-boxFlag-256+boxContext, boxRef, curBox)
}

@ 리더 상자 뒤에는 알맞은 방향의 글루가 와야 한다. 가로 모드이면 \.{\\hskip} 계열, 세로 모드이면 \.{\\vskip} 계열이다. 그 글루 노드를 리더로
바꾸고 상자를 붙인다.
@<|curBox|를 쓰는 새 리더 노드를...@>=
@<공백도 relax도 호출도...@>
if (curCmd == hskip && abs(mode) != vmode) || (curCmd == vskip && abs(mode) == vmode) {
	appendGlue(); setSubtype(tail, boxContext-(leaderFlag-aLeaders))
	setLeaderPtr(tail, curBox)
} else {
	printErr("Leaders not followed by proper glue")
@.Leaders not followed by...@>
	help3("You should say `\\leaders <box or rule><hskip or vskip>'.",
		"I found the <box or rule>, but there's no suitable",
		"<hskip or vskip>, so I'm ignoring these leaders.")
	backError()
	flushNodeList(curBox)
}

@ 이제 상자가 마지막에 어떻게 되는지 알았으니 상자를 만드는 첫 단계를 생각할 수 있다. 루틴 |beginBox|는 |boxContext|가 문맥을 지정하고,
|curChr|가 원하는 상자의 종류를 지정하고, |curCmd=makeBox|일 때 부른다. 명령 \.{\\box}와 \.{\\copy}는 레지스터의 상자를 꺼내거나 베끼고,
\.{\\lastbox}는 현재 목록의 마지막 상자를 떼어 내고, \.{\\vsplit}는 상자를 나누고, 나머지는 새 상자를 만들기 시작한다.

@<|mainControl|이 쓰는 동작...@>=
func beginBox(boxContext int32) {
	var p, q pointer // 현재 목록을 훑는다
	var m quarterword // 대체 목록의 길이
	var k halfword // 0이나 |vmode|나 |hmode|
	var n eightBits // 상자 번호
	switch curChr {
	case boxCode:
		scanEightBitInt(); curBox = box(curVal)
		setBoxReg(curVal, null) // 상자는 같은 수준에서 빈 상자가 된다
	case copyCode: scanEightBitInt(); curBox = copyNodeList(box(curVal))
	case lastBoxCode: @<현재 목록이 상자 노드로 끝나면 그것을 떼어 |curBox|로 한다@>
	case vsplitCode: @<세로 상자의 일부를 떼어 |curBox|가 가리키게 한다@>
	default: @<가로 상자나 세로 상자 만들기를 시작하고 |return|한다@>
	}
	boxEnd(boxContext) // 단순한 경우에는 상자를 바로 쓴다
}

@ 조건 |!isCharNode(tail)|은 |head!=tail|을 뜻한다는 데 주의하자. 머리 |head|는 한 낱말짜리 노드이기 때문이다. 현재 목록이 상자 노드로
끝나지 않으면 |curBox=null|로 한다. 수식 모드와 주 세로 목록의 현재 쪽에서는 \.{\\lastbox}를 쓸 수 없다.

@<현재 목록이 상자 노드로 끝나면...@>=
curBox = null
if abs(mode) == mmode {
	youCant(); help1("Sorry; this \\lastbox will be void."); reportError()
} else if mode == vmode && head == tail {
	youCant()
	help2("Sorry...I usually can't take things from the current page.",
		"This \\lastbox will therefore be void.")
	reportError()
} else if !isCharNode(tail) && (typ(tail) == hlistNode || typ(tail) == vlistNode) {
	@<선택적 나눔의 일부가 아니면 마지막 상자를 떼어 낸다@>
}

@ 마지막 상자가 선택적 나눔의 대체 텍스트 안에 들어 있으면 떼어 낼 수 없다. 목록을 처음부터 따라가며 확인한다.
@<선택적 나눔의 일부가 아니면...@>=
q = head
for {
	p = q
	if !isCharNode(q) && typ(q) == discNode {
		for m = 1; m <= replaceCount(q); m++ {
			p = link(p)
		}
		if p == tail {
			goto done
		}
	}
	q = link(p)
	if q == tail {
		break
	}
}
curBox = tail; setShiftAmount(curBox, 0)
tail = p; setLink(p, null)
done: ;

@ 여기서 `\.{\\vsplit 13 to 100pt}' 같은 것을 다룬다. `\.{to}'가 빠졌으면 알리고 치수를 읽는다.

@<세로 상자의 일부를 떼어...@>=
scanEightBitInt(); n = curVal
if !scanKeyword("to") {
@.to@>
	printErr("Missing `to' inserted")
@.Missing `to' inserted@>
	help2("I'm working on `\\vsplit<box number> to <dimen>';",
		"will look for the <dimen> next.")
	reportError()
}
scanNormalDimen()
curBox = vsplit(n, curVal)

@ 여기서 상자를 만들려고 제한된 가로 모드나 내부 세로 모드로 들어간다. 상자 지정을 읽고 새 의미 수준을 연 다음, \.{\\everyhbox}나
\.{\\everyvbox}를 끼워 넣는다.

@<가로 상자나 세로 상자 만들기를...@>=
k = curChr - vtopCode; setSaved(0, boxContext)
if k == hmode {
	if boxContext < boxFlag && abs(mode) == vmode {
		scanSpec(adjustedHboxGroup, true)
	} else {
		scanSpec(hboxGroup, true)
	}
} else {
	if k == vmode {
		scanSpec(vboxGroup, true)
	} else {
		scanSpec(vtopGroup, true); k = vmode
	}
	normalParagraph()
}
pushNest(); mode = -k
if k == vmode {
	setPrevDepth(ignoreDepth)
	if everyVbox() != null {
		beginTokenList(everyVbox(), everyVboxText)
	}
} else {
	setSpaceFactor(1000)
	if everyHbox() != null {
		beginTokenList(everyHbox(), everyHboxText)
	}
}
return

@ 다음 입력은 상자를 지정해야 한다. 리더라면 괘선이어도 된다. 그 밖의 것이 오면 오류다.
@<|mainControl|이 쓰는 동작...@>=
func scanBox(boxContext int32) { // 다음 입력은 상자나 어쩌면 괘선을 지정해야 한다
	@<공백도 relax도 호출도...@>
	if curCmd == makeBox {
		beginBox(boxContext)
	} else if boxContext >= leaderFlag && (curCmd == hrule || curCmd == vrule) {
		curBox = scanRuleSpec(); boxEnd(boxContext)
	} else {
		printErr("A <box> was supposed to be here")
@.A <box> was supposed to...@>
		help3("I was expecting to see \\hbox or \\vbox or \\copy or \\box or",
			"something like that. So you might find something missing in",
			"your output. But keep trying; you can fix this later.")
		backError()
	}
}

@ 구성 \.{\\hbox}나 \.{\\vbox}나 \.{\\vtop}의 끝에서 오른쪽 중괄호가 나오면 루틴 |packageBox|가 일한다. 세로 상자이면 끝나지 않은 문단을
먼저 마무리해야 할 수도 있다. 세로 모드의 \.{\\hbox}이면 \.{\\vadjust} 같은 재료를 바깥으로 옮겨 낼 수 있도록 |adjustTail|을 준비한다.

@<|rightBrace|가 미루어 둔 동작을...@>=
case hboxGroup: packageBox(0)
case adjustedHboxGroup: adjustTail = adjustHead; packageBox(0)
case vboxGroup: endGraf(); packageBox(0)
case vtopGroup: endGraf(); packageBox(vtopCode)

@ 상자를 꾸려 문맥에 따라 처리한다. 저장해 둔 지정을 꺼내 |hpack|이나 |vpackage|로 꾸린다. 세로 상자의 깊이는 \.{\\boxmaxdepth}를 넘지
않게 한다.
@<|mainControl|이 쓰는 동작...@>=
func packageBox(c smallNumber) {
	var h scaled // 상자의 높이
	var p pointer // 상자의 첫 노드
	d := boxMaxDepth() // 최대 깊이
	unsave(); savePtr -= 3
	if mode == -hmode {
		curBox = hpack(link(head), saved(2), saved(1))
	} else {
		curBox = vpackage(link(head), saved(2), saved(1), d)
		if c == vtopCode {
			@<\.{\\vtop}을 위해 |curBox|의 높이와 깊이를 다시 맞춘다@>
		}
	}
	popNest(); boxEnd(saved(0))
}

@ 상자 `\.{\\vtop}'의 높이는 그 목록의 첫 항목이 |hlistNode|나 |vlistNode|나 |ruleNode|이면 그 항목의 높이이고, 그렇지 않으면 0이다. 나머지는
모두 깊이로 간다. 그래서 \.{\\vtop}은 첫 줄의 기준선이 상자의 기준선이 된다.

@<\.{\\vtop}을 위해 |curBox|의...@>=
h = 0; p = listPtr(curBox)
if p != null && typ(p) <= ruleNode {
	h = height(p)
}
setDepth(curBox, depth(curBox)-h+height(curBox)); setHeight(curBox, h)

@ 문단은 세로 모드에서 가로 모드의 내용이 나올 때, 또는 `\.{\\indent}'나 `\.{\\noindent}'로 명시적으로 문단을 시작할 때 시작한다.

@<\TeX의 원시 명령을...@>=
primitive("indent", startPar, 1)
@!@:indent_}{\.{\\indent} primitive@>
primitive("noindent", startPar, 0)
@!@:no_indent_}{\.{\\noindent} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case startPar:
	if chrCode == 0 { printEsc("noindent") } else { printEsc("indent") }

@ 세로 모드에서 글자, 수식 전환 문자, \.{\\hskip} 같은 가로 모드의 것이 나오면 그 토큰을 되돌려 놓고 들여쓰기한 새 문단을 시작한다.
@<상자와 목록을 만드는...@>=
case vmode + startPar: newGraf(curChr > 0)
case vmode + letter, vmode + otherChar, vmode + charNum, vmode + charGiven,
	vmode + mathShift, vmode + unHbox, vmode + vrule,
	vmode + accent, vmode + discretionary, vmode + hskip, vmode + valign,
	vmode + exSpace, vmode + noBoundary:
	backInput(); newGraf(true)

@ \seclabel{norm-min}함수 |normMin|은 \.{\\lefthyphenmin}과 \.{\\righthyphenmin}의 값을 1부터 63까지로 자른다. 프로시저 |newGraf|는 새 문단을
시작한다. 가로 모드로 들어가서 언어 정보를 |prevGraf|에 담아 두고(\secref{nest} 뒤의 설명을 보라), 들여쓰기 상자를 넣고, \.{\\everypar}를
끼워 넣는다. 바깥이 주 세로 목록이면 쪽 조립기를 먼저 돌린다.
@<|mainControl|이 쓰는 동작...@>=
func normMin(h int32) smallNumber {
	if h <= 0 {
		return 1
	} else if h >= 63 {
		return 63
	} else {
		return h
	}
}
@#
func newGraf(indented bool) {
	prevGraf = 0
	if mode == vmode || head != tail {
		tailAppend(newParamGlue(parSkipCode))
	}
	pushNest(); mode = hmode; setSpaceFactor(1000); setCurLang(); setClang(curLang)
	prevGraf = (normMin(leftHyphenMin())*0o100+normMin(rightHyphenMin()))*0o200000 + curLang
	if indented {
		tail = newNullBox(); setLink(head, tail); setWidth(tail, parIndent())
	}
	if everyPar() != null {
		beginTokenList(everyPar(), everyParText)
	}
	if nestPtr == 1 {
		buildPage() // |parSkip| 글루를 현재 쪽에 놓는다
	}
}

@ 가로 모드나 수식 모드의 \.{\\indent}와 \.{\\noindent}는 |indentInHmode|가 처리한다.
@<상자와 목록을 만드는...@>=
case hmode + startPar, mmode + startPar: indentInHmode()

@ 가로 모드에서 \.{\\indent}는 너비가 \.{\\parindent}인 빈 상자를 넣는다. 수식 모드이면 그 상자를 |ordNoad|로 감싼다. 명령 \.{\\noindent}는 아무
일도 하지 않는다.
@<|mainControl|이 쓰는 동작...@>=
func indentInHmode() {
	var p, q pointer
	if curChr > 0 { // \.{\\indent}
		p = newNullBox(); setWidth(p, parIndent())
		if abs(mode) == hmode {
			setSpaceFactor(1000)
		} else {
			q = newNoad(); setMathType(nucleus(q), subBox)
			setInfo(nucleus(q), p); p = q
		}
		tailAppend(p)
	}
}

@ 문단은 가로 모드에 있다가 |parEnd| 명령을 만날 때 끝난다. 명령 \.{\\vbox}, \.{\\insert}, \.{\\output}처럼 세로 모드로 처리하는 구성의
오른쪽 중괄호에 이르렀을 때도 끝난다. 또 가로 모드에서 \.{\\vskip}이나 \.{\\hrule}처럼 세로 모드에만 어울리는 것이 나오면, 그것을
처리하기 전에 먼저 문단을 끝내야 한다.

@<상자와 목록을 만드는...@>=
case vmode + parEnd:
	normalParagraph()
	if mode > 0 {
		buildPage()
	}
case hmode + parEnd:
	if alignState < 0 {
		offSave() // 이것은 제대로 끝나지 않은 정렬에서 회복하려 한다
	}
	endGraf() // |mode>0|이면 이것은 둘러싼 모드로 데려간다
	if mode == vmode {
		buildPage()
	}
case hmode + stop, hmode + vskip, hmode + hrule, hmode + unVbox, hmode + halign: headForVmode()

@ 가로 모드에서 세로 모드의 것이 나왔을 때 부르는 루틴이다. 바깥 가로 모드이면 그 토큰 앞에 \.{\\par}를 끼워 넣어 문단을 끝내고
다시 읽게 한다. 제한된 가로 모드(|mode<0|)에서는 문단을 끝낼 수 없으므로 오류다. 그 가운데 \.{\\hrule}은 리더로만 쓸 수 있다고
따로 알려 준다.
@<|mainControl|이 쓰는 동작...@>=
func headForVmode() {
	if mode < 0 {
		if curCmd != hrule {
			offSave()
		} else {
			printErr("You can't use `")
			printEsc("hrule"); printStr("' here except with leaders")
@.You can't use \\hrule...@>
			help2("To put a horizontal rule in an hbox or an alignment,",
				"you should use \\leaders or \\hrulefill (see The TeXbook).")
			reportError()
		}
	} else {
		backInput(); curTok = parToken; backInput(); setTokenType(inserted)
	}
}

@ 프로시저 |endGraf|는 문단을 끝낸다. 비어 있는 문단은 그냥 버리고, 그렇지 않으면 줄 나눔 루틴에 넘긴다. 문단 하나에만 쓰이는
매개변수를 되돌리고, 문단이 무사히 끝났으니 오류 개수도 0으로 돌려놓는다.
@<|mainControl|이 쓰는 동작...@>=
func endGraf() {
	if mode == hmode {
		if head == tail {
			popNest() // 빈 문단은 무시한다
		} else {
			lineBreak(widowPenalty())
		}
		normalParagraph()
		errorCount = 0
	}
}

@ 삽입, 조정, 표시 노드는 프로그램의 다음 조각들이 만든다.

@<상자와 목록을 만드는...@>=
case vmode + insert, hmode + insert, mmode + insert, hmode + vadjust, mmode + vadjust:
	beginInsertOrAdjust()
case vmode + mark, hmode + mark, mmode + mark: makeMark()

@ 세로 모드에서는 \.{\\vadjust}를 쓸 수 없다. 이미 세로 목록에 있으니 옮겨 낼 바깥이 없기 때문이다.
@<|mainControl|이 금지하는...@>=
vmode + vadjust,

@ 명령 \.{\\insert}$n$과 \.{\\vadjust}는 둘 다 내부 세로 모드에서 재료를 모은다. 그래서 같은 루틴으로 시작한다. 삽입 번호를
|saveStack|에 넣어 두는데, \.{\\vadjust}이면 255를 넣는다. 상자 255는 출력 루틴에 쓰는 특별한 상자이므로 \.{\\insert255}는 허락하지 않는다.
@<|mainControl|이 쓰는 동작...@>=
func beginInsertOrAdjust() {
	if curCmd == vadjust {
		curVal = 255
	} else {
		scanEightBitInt()
		if curVal == 255 {
			printErr("You can't "); printEsc("insert"); printInt(255)
@.You can't \\insert255@>
			help1("I'm changing to \\insert0; box 255 is special.")
			reportError(); curVal = 0
		}
	}
	setSaved(0, curVal); savePtr++
	newSaveLevel(insertGroup); scanLeftBrace(); normalParagraph()
	pushNest(); mode = -vmode; setPrevDepth(ignoreDepth)
}

@ 오른쪽 중괄호가 삽입 그룹이나 출력 그룹을 닫을 때 할 일이다.
@<|rightBrace|가 미루어 둔 동작을...@>=
case insertGroup: @<삽입이나 조정 노드를 마무리한다@>
case outputGroup: @<출력 루틴이 끝난 뒤 쪽 조립기를...@>

@ 앞 절의 |insertGroup| 경우다. 이제 |saved(0)|은 삽입 번호이거나, \.{\\vadjust}이면 255다. 모은 재료를 세로 상자로 꾸린 다음, 삽입
노드나 조정 노드에 그 목록을 옮겨 담는다. 삽입 노드에는 그 순간의 \.{\\splittopskip}, \.{\\splitmaxdepth}, \.{\\floatingpenalty} 값도
함께 기록한다. 쪽 조립기가 나중에 그 값을 써야 하기 때문이다.

@<삽입이나 조정 노드를 마무리한다@>=
endGraf(); q = splitTopSkip(); addGlueRef(q)
d = splitMaxDepth(); f = floatingPenalty(); unsave(); savePtr--
p = vpack(link(head), natural, additional); popNest()
if saved(0) < 255 {
	tailAppend(getNode(insNodeSize))
	setType(tail, insNode); setSubtype(tail, qi(saved(0)))
	setHeight(tail, height(p)+depth(p)); setInsPtr(tail, listPtr(p))
	setSplitTopPtr(tail, q); setDepth(tail, d); setFloatCost(tail, f)
} else {
	tailAppend(getNode(smallNodeSize))
	setType(tail, adjustNode)
	setSubtype(tail, 0) // |subtype|은 쓰이지 않는다
	setAdjustPtr(tail, listPtr(p)); deleteGlueRef(q)
}
freeNode(p, boxNodeSize)
if nestPtr == 0 {
	buildPage()
}

@ 표시 노드는 \.{\\mark}의 토큰 목록을 확장해서 읽고, 그 참조 횟수 포인터를 노드에 담는다.
@<|mainControl|이 쓰는 동작...@>=
func makeMark() {
	var p pointer // 새 노드
	p = scanToks(false, true); p = getNode(smallNodeSize)
	setType(p, markNode); setSubtype(p, 0) // |subtype|은 쓰이지 않는다
	setMarkPtr(p, defRef); setLink(tail, p); tail = p
}

@ 벌점 노드는 명령 |breakPenalty|로 목록에 들어간다.
@^penalties@>

@<상자와 목록을 만드는...@>=
case vmode + breakPenalty, hmode + breakPenalty, mmode + breakPenalty: appendPenalty()

@ 세로 모드에서 벌점을 넣으면 곧바로 쪽 조립기를 돌린다. 벌점이 쪽 나눔 후보가 되기 때문이다.
@<|mainControl|이 쓰는 동작...@>=
func appendPenalty() {
	scanInt(); tailAppend(newPenalty(curVal))
	if mode == vmode {
		buildPage()
	}
}

@ 명령 |removeItem|은 현재 목록의 꼬리에 벌점, 커닝, 글루 노드가 있으면 그것을 없앤다. 꼬리 바로 앞 노드를 찾으려고 목록을 처음부터
무작정 선형으로 훑는다. 명령 \.{\\lastbox}처럼 이 명령도 세로 모드(내부 세로 모드는 빼고)에서는 쓸 수 없다. 세로 모드의 현재 목록은
이미 쪽 조립기로 넘어갔기 때문이다. 그래도 세로 모드에서 할 수 있는 경우는 해 준다.

@<상자와 목록을 만드는...@>=
case vmode + removeItem, hmode + removeItem, mmode + removeItem: deleteLast()

@ 프로시저 |deleteLast|를 부를 때 |curChr|는 지울 노드(있다면)의 \ID{type}이다. 선택적 나눔의 대체 텍스트 안에 들어 있는 노드는
지우지 않는다는 데 주의하자.

@<|mainControl|이 쓰는 동작...@>=
func deleteLast() {
	var p, q pointer // 현재 목록을 훑는다
	var m quarterword // 대체 목록의 길이
	if mode == vmode && tail == head {
		@<지금은 이 연산을 할 수 없다고 사과한다@>
	} else if !isCharNode(tail) && typ(tail) == curChr {
		q = head
		for {
			p = q
			if !isCharNode(q) && typ(q) == discNode {
				for m = 1; m <= replaceCount(q); m++ {
					p = link(p)
				}
				if p == tail {
					return
				}
			}
			q = link(p)
			if q == tail {
				break
			}
		}
		setLink(p, null); flushNodeList(tail); tail = p
	}
}

@ 명령 \.{\\unskip}이 글루 아닌 것 뒤에 온 경우가 아니면, 지금은 이 연산을 할 수 없다고 사과한다.

@<지금은 이 연산을...@>=
if curChr != glueNode || lastGlue != maxHalfword {
	youCant()
	help2("Sorry...I usually can't take things from the current page.",
		"Try `I\\vskip-\\lastskip' instead.")
	if curChr == kernNode {
		helpLine[0] = "Try `I\\kern-\\lastkern' instead."
	} else if curChr != glueNode {
		helpLine[0] = "Perhaps you can make the output routine do it."
	}
	reportError()
}

@ 앞 절의 원시 명령들을 해시 표에 넣는다.
@<\TeX의 원시 명령을...@>=
primitive("unpenalty", removeItem, penaltyNode)
@!@:un_penalty_}{\.{\\unpenalty} primitive@>
primitive("unkern", removeItem, kernNode)
@!@:un_kern_}{\.{\\unkern} primitive@>
primitive("unskip", removeItem, glueNode)
@!@:un_skip_}{\.{\\unskip} primitive@>
primitive("unhbox", unHbox, boxCode)
@!@:un_hbox_}{\.{\\unhbox} primitive@>
primitive("unhcopy", unHbox, copyCode)
@!@:un_hcopy_}{\.{\\unhcopy} primitive@>
primitive("unvbox", unVbox, boxCode)
@!@:un_vbox_}{\.{\\unvbox} primitive@>
primitive("unvcopy", unVbox, copyCode)
@!@:un_vcopy_}{\.{\\unvcopy} primitive@>

@ 이 명령들의 이름은 이렇게 찍는다.
@<원시 명령의 이름을 찍는...@>=
case removeItem:
	if chrCode == glueNode {
		printEsc("unskip")
	} else if chrCode == kernNode {
		printEsc("unkern")
	} else {
		printEsc("unpenalty")
	}
case unHbox:
	if chrCode == copyCode { printEsc("unhcopy") } else { printEsc("unhbox") }
case unVbox:
	if chrCode == copyCode { printEsc("unvcopy") } else { printEsc("unvbox") }

@ 명령 |unHbox|와 |unVbox|는 상자 레지스터 256개 가운데 하나의 포장을 푼다.

@<상자와 목록을 만드는...@>=
case vmode + unVbox, hmode + unHbox, mmode + unHbox: unpackage()

@ 상자의 포장을 풀어 그 내용을 현재 목록에 붙인다. 명령 \.{\\unhcopy}나 \.{\\unvcopy}이면 내용을 베끼고, 그렇지 않으면 레지스터를 비운다.
가로 상자는 가로 모드에서만, 세로 상자는 세로 모드에서만 풀 수 있고, 수식 모드에서는 어떤 상자도 풀 수 없다. 도움말에 나오는
판도라는 아마 그 상자를 열고 싶었던 모양이다.
@<|mainControl|이 쓰는 동작...@>=
func unpackage() {
	c := curChr // 베껴야 하는가? |boxCode..copyCode|
	scanEightBitInt(); p := box(curVal) // 상자
	if p == null {
		return
	}
	if abs(mode) == mmode || (abs(mode) == vmode && typ(p) != vlistNode) ||
		(abs(mode) == hmode && typ(p) != hlistNode) {
		printErr("Incompatible list can't be unboxed")
@.Incompatible list...@>
		help3("Sorry, Pandora. (You sneaky devil.)",
			"I refuse to unbox an \\hbox in vertical mode or vice versa.",
			"And I can't open any boxes in math mode.")
		reportError(); return
	}
	if c == copyCode {
		setLink(tail, copyNodeList(listPtr(p)))
	} else {
		setLink(tail, listPtr(p)); setBoxReg(curVal, null)
		freeNode(p, boxNodeSize)
	}
	for link(tail) != null {
		tail = link(tail)
	}
}

@ 세로 모드에서는 기울임 보정을 쓸 수 없다.
@<|mainControl|이 금지하는...@>=
vmode + italCorr,

@ 기울임 보정은 |italCorr| 명령이 문자 뒤에 올 때 커닝 노드로 바뀐다. 수식 모드에서는 여기서 0인 커닝을 덧붙여 자리만 잡아 둔다.
수식에서는 기울임 보정을 나중에 따로 넣기 때문이다.

@<상자와 목록을 만드는...@>=
case hmode + italCorr: appendItalicCorrection()
case mmode + italCorr: tailAppend(newKern(0))

@ 현재 목록의 꼬리가 문자나 합자이면 그 문자의 기울임 보정만큼 커닝을 넣는다. 그 커닝은 \.{\\kern}으로 넣은 커닝처럼
|explicit|으로 표시한다. 꼬리가 다른 것이면 아무 일도 하지 않는다.
@<|mainControl|이 쓰는 동작...@>=
func appendItalicCorrection() {
	var p pointer // 현재 목록의 꼬리에 있는 |charNode|
	var f internalFontNumber // |charNode|의 글꼴
	if tail != head {
		if isCharNode(tail) {
			p = tail
		} else if typ(tail) == ligatureNode {
			p = ligChar(tail)
		} else {
			return
		}
		f = font(p)
		tailAppend(newKern(charItalic(f, charInfo(f, character(p)))))
		setSubtype(tail, explicit)
	}
}

@ 선택적 나눔은 흔한 경우인 `\.{\\-}'에서는 쉽다. 그러나 일반적인 경우에는 항목이 가득 든 중괄호 세 개를 처리해야 한다.

@<\TeX의 원시 명령을...@>=
primitive("-", discretionary, 1)
@!@:Single-character primitives -}{\quad\.{\\-}@>
primitive("discretionary", discretionary, 0)
@!@:discretionary_}{\.{\\discretionary} primitive@>

@ 선택적 나눔 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case discretionary:
	if chrCode == 1 { printEsc("-") } else { printEsc("discretionary") }

@ 선택적 나눔은 가로 모드와 수식 모드에서 쓸 수 있다.
@<상자와 목록을 만드는...@>=
case hmode + discretionary, mmode + discretionary: appendDiscretionary()

@ 선택적 나눔 노드를 덧붙여도 공백 인자는 바뀌지 않는다. 다만 그 안의 하위 목록에서는 공백 인자가 1000으로 시작한다. 명령 `\.{\\-}'이면
글꼴의 하이픈 문자를 나눔 앞 목록에 넣으면 끝이다. 명령 \.{\\discretionary}이면 첫째 중괄호 그룹을 읽기 시작한다.

@<|mainControl|이 쓰는 동작...@>=
func appendDiscretionary() {
	var c int32 // 하이픈 문자
	tailAppend(newDisc())
	if curChr == 1 {
		c = hyphenChar[curFont()]
		if c >= 0 && c < 256 {
			setPreBreak(tail, newCharacter(curFont(), c))
		}
	} else {
		savePtr++; setSaved(-1, 0); newSaveLevel(discGroup)
		scanLeftBrace(); pushNest(); mode = -hmode; setSpaceFactor(1000)
	}
}

@ 선택적 나눔의 세 목록은 가로 상자와 비슷하게 만든다. 서브루틴 |buildDiscretionary|가 세 목록 사이를 옮겨 가는 일을 맡는다. (꽤 재미있는
부분이다.)

@<|rightBrace|가 미루어 둔 동작을...@>=
case discGroup: buildDiscretionary()

@ 중괄호 그룹 하나가 끝날 때마다 이 루틴이 불린다. 저장해 둔 |saved(-1)|이 지금이 몇 번째 목록인지 알려 준다. 0이면 나눔 앞 목록,
1이면 나눔 뒤 목록, 2이면 대체 텍스트다. 셋째 목록이 아니면 다음 중괄호 그룹을 읽기 시작한다.
@<|mainControl|이 쓰는 동작...@>=
func buildDiscretionary() {
	var p, q pointer // 링크를 다루는 데 쓴다
	var n int32 // 선택적 나눔 목록의 길이
	unsave()
	@<현재 목록에 허락된 노드만 남도록 쳐내고, |n|을 길이로, |q|를 꼬리로 한다@>
	p = link(head); popNest()
	switch saved(-1) {
	case 0: setPreBreak(tail, p)
	case 1: setPostBreak(tail, p)
	case 2: @<목록 |p|를 현재 목록에 붙이고 그 길이를 기록한 뒤, 마무리하고 |return|한다@>
	} // 다른 경우는 없다
	setSaved(-1, saved(-1)+1); newSaveLevel(discGroup); scanLeftBrace()
	pushNest(); mode = -hmode; setSpaceFactor(1000)
}

@ 셋째 목록은 현재 목록에 직접 붙인다. 그 길이가 대체 개수다. 수식에서는 대체 텍스트가 비어 있어야 한다.
@<목록 |p|를 현재 목록에 붙이고...@>=
if n > 0 && abs(mode) == mmode {
	printErr("Illegal math "); printEsc("discretionary")
@.Illegal math \\disc...@>
	help2("Sorry: The third part of a discretionary break must be",
		"empty, in math formulas. I had to delete your third part.")
	flushNodeList(p); n = 0; reportError()
} else {
	setLink(tail, p)
}
if n <= maxQuarterword {
	setReplaceCount(tail, n)
} else {
	printErr("Discretionary list is too long")
@.Discretionary list is too long@>
	help2("Wow---I never thought anybody would tweak me here.",
		"You can't seriously need such a huge discretionary list?")
	reportError()
}
if n > 0 {
	tail = q
}
savePtr--; return

@ 현재 목록에 |charNode|, |kernNode|, |hlistNode|, |vlistNode|, |ruleNode|, |ligatureNode| 항목만 남도록 필요하면 쳐낸다. 이 루프가 도는
동안 |p=link(q)|이고 |p| 앞에 항목이 |n|개 있다.

@<현재 목록에 허락된 노드만...@>=
q = head; p = link(q); n = 0
for p != null {
	if !isCharNode(p) && typ(p) > ruleNode && typ(p) != kernNode && typ(p) != ligatureNode {
		printErr("Improper discretionary list")
@.Improper discretionary list@>
		help1("Discretionary lists must contain only boxes and kerns.")
		reportError()
		beginDiagnostic()
		printNl("The following discretionary sublist has been deleted:")
@.The following...deleted@>
		showBox(p)
		endDiagnostic(true)
		flushNodeList(p); setLink(q, null); goto done
	}
	q = p; p = link(q); n++
}
done:

@ 가로 모드 루틴들을 완성하려면 한 가지만 더 있으면 된다. 바로 원시 명령 \.{\\accent}다.

@<상자와 목록을 만드는...@>=
case hmode + accent: makeAccent()

@ 악센트를 놓는 일은 간단하지만 지루하다. 높이 |x|, 기울기 |s|인 문자를 위해 설계된 너비 |a|의 악센트가 있고, 너비 |w|, 높이 |h|,
기울기 |t|인 문자가 주어졌다고 하자. 그러면 악센트를 |x-h|만큼 아래로 옮기고(|h>x|이면 위로 올라가는 셈이다), 문자 위의 가운데에 오도록 오른쪽으로
$\delta={1\over2}(w-a)+h\cdot t-x\cdot s$만큼 옮긴다. 옮기는 일은 커닝 노드로 한다. 둘 가운데 어느 한 문자라도 글꼴에 없으면 옮기지 않고
있는 것만 쓴다.

@<|mainControl|이 쓰는 동작...@>=
func makeAccent() {
	var s, t float64 // 기울기의 양
	var q, r pointer // 문자, 상자, 커닝 노드
	var f internalFontNumber // 관련된 글꼴
	var a, h, x, w, delta scaled // 위에서 설명한 높이와 너비
	var i fourQuarters // 문자 정보
	scanCharNum(); f = curFont(); p := newCharacter(f, curVal)
	if p != null {
		x = xHeight(f); s = float64(slant(f)) / floatConstant(65536)
@^real division@>
		a = charWidth(f, charInfo(f, character(p)))
		doAssignments()
		@<다음 문자를 위한 문자 노드 |q|를 만들되, 문제가 생기면 |q=null|로 한다@>
		if q != null {
			@<알맞은 커닝과 함께 악센트를 덧붙이고 |p=q|로 한다@>
		}
		setLink(tail, p); tail = p; setSpaceFactor(1000)
	}
}

@ 악센트 뒤의 문자를 읽는다. 악센트와 그 문자 사이에 \.{\\font} 같은 지정이 끼어 있을 수 있으므로, 앞에서 |doAssignments|를 먼저
불러 두었다. 그래서 문자의 글꼴이 악센트의 글꼴과 다를 수도 있다.
@<다음 문자를 위한 문자 노드...@>=
q = null; f = curFont()
if curCmd == letter || curCmd == otherChar || curCmd == charGiven {
	q = newCharacter(f, curChr)
} else if curCmd == charNum {
	scanCharNum(); q = newCharacter(f, curVal)
} else {
	backInput()
}

@ 여기서 덧붙이는 커닝 노드는 다른 커닝과 구별해야 한다. 그렇지 않으면 하이픈 넣기 알고리즘이나 앞선 줄 나눔이 그것을 지워 버릴 것이다.

두 커닝은 (기계마다 다를 수 있는) 부동 소수점 산술로 계산하지만, 그 합은 기계에 따라 다르지 않다. 사용자는 이 노드들을 없앨 수도 없고
\.{\\lastkern}으로 들여다볼 수도 없으므로 알짜 효과는 기계에 상관없다.

@<알맞은 커닝과 함께 악센트를...@>=
t = float64(slant(f)) / floatConstant(65536)
@^real division@>
i = charInfo(f, character(q))
w = charWidth(f, i); h = charHeight(f, heightDepth(i))
if h != x { // 악센트를 위나 아래로 옮겨야 한다
	p = hpack(p, natural, additional); setShiftAmount(p, x-h)
}
delta = round(float64(w-a)/floatConstant(2) + float64(h)*t - float64(x)*s)
@^real multiplication@>
@^real addition@>
r = newKern(delta); setSubtype(r, accKern); setLink(tail, r); setLink(r, p)
tail = newKern(-a - delta); setSubtype(tail, accKern); setLink(p, tail); p = q

@ 명령 `\.{\\cr}'나 `\.{\\span}'이나 탭 표시가 훑개를 지나 |mainControl|까지 오면, 사용자가 어리석게도 정렬과 아무 상관 없는 곳에 그것을
넣었을 수도 있다. 그러나 왼쪽 중괄호나 오른쪽 중괄호를 빠뜨렸을 가능성이 훨씬 크다. 프로시저 |getNext|는 `\.{\\cr}'이나 `\.{\\span}'이나
탭 표시가 |alignState=0|일 때 나타날 때만 정렬에 알맞은 동작을 하기 때문이다. 다음 프로그램은 알맞게 회복하려 한다.

@<상자와 목록을 만드는...@>=
case vmode + carRet, hmode + carRet, mmode + carRet,
	vmode + tabMark, hmode + tabMark, mmode + tabMark:
	alignError()
case vmode + noAlign, hmode + noAlign, mmode + noAlign: noAlignError()
case vmode + omit, hmode + omit, mmode + omit: omitError()

@ 변수 |alignState|가 작은 수이면 중괄호가 하나 모자라거나 남는 경우로 보고, 빠진 중괄호를 끼워 넣는다. 음수이면 왼쪽 중괄호를,
양수이면 오른쪽 중괄호를 넣는다. 그렇지 않으면 정렬 바깥에서 쓴 것이다.
@<|mainControl|이 쓰는 동작...@>=
func alignError() {
	if abs(alignState) > 2 {
		@<정렬이 진행 중이지 않다는 사실에 당황을 나타낸다@>
	} else {
		backInput()
		if alignState < 0 {
			printErr("Missing { inserted")
@.Missing \{ inserted@>
			alignState++; curTok = leftBraceToken + '{'
		} else {
			printErr("Missing } inserted")
@.Missing \} inserted@>
			alignState--; curTok = rightBraceToken + '}'
		}
		help3("I've put in what seems to be necessary to fix",
			"the current column of the current alignment.",
			"Try to go on, since this might almost work.")
		insError()
	}
}

@ 정렬 바깥에서 탭 표시나 \.{\\span}이나 \.{\\cr}을 쓴 경우다. 탭 표시이면 그냥 앰퍼샌드를 원했을 수도 있으니 `\.{I\\\&}'를 권한다.
@<정렬이 진행 중이지 않다는...@>=
printErr("Misplaced "); printCmdChr(curCmd, curChr)
@.Misplaced \&@>
@.Misplaced \\span@>
@.Misplaced \\cr@>
if curTok == tabToken+'&' {
	help6("I can't figure out why you would want to use a tab mark",
		"here. If you just want an ampersand, the remedy is",
		"simple: Just type `I\\&' now. But if some right brace",
		"up above has ended a previous alignment prematurely,",
		"you're probably due for more error messages, and you",
		"might try typing `S' now just to see what is salvageable.")
} else {
	help5("I can't figure out why you would want to use a tab mark",
		"or \\cr or \\span just now. If something like a right brace",
		"up above has ended a previous alignment prematurely,",
		"you're probably due for more error messages, and you",
		"might try typing `S' now just to see what is salvageable.")
}
reportError()

@ 여기 도움말 메시지에는 작은 선의의 거짓말이 들어 있다. 사실 \.{\\noalign}과 \.{\\omit}은 `\.{\\noalign\{...\}}' 뒤에도 쓸 수 있기
때문이다.

@<|mainControl|이 쓰는 동작...@>=
func noAlignError() {
	printErr("Misplaced "); printEsc("noalign")
@.Misplaced \\noalign@>
	help2("I expect to see \\noalign only after the \\cr of",
		"an alignment. Proceed, and I'll ignore this case.")
	reportError()
}

func omitError() {
	printErr("Misplaced "); printEsc("omit")
@.Misplaced \\omit@>
	help2("I expect to see \\omit only after tab marks or the \\cr of",
		"an alignment. Proceed, and I'll ignore this case.")
	reportError()
}

@ 이제 \.{\\halign}과 \.{\\valign}을 잘못 쓰는 경우를 대부분 다루었다. 올바르게 쓸 때 무슨 일이 일어나는지 살펴보자. 수식 모드의
\.{\\halign}은 디스플레이 수식에서만, 그리고 그 디스플레이에 다른 것이 없을 때만 쓸 수 있다.

@<상자와 목록을 만드는...@>=
case vmode + halign, hmode + valign: initAlign()
case mmode + halign:
	if privileged() {
		if curGroup == mathShiftGroup {
			initAlign()
		} else {
			offSave()
		}
	}
case vmode + endv, hmode + endv: doEndv()

@ 그룹 코드 |alignGroup|은 정렬하는 내내, |finAlign|이 그것을 없앨 때까지 |saveStack|에 남아 있어야 한다.

교활한 사용자는 |endv| 명령이 거의 아무 곳에서나 나타나게 할 수도 있다. 그런 장난은 막아야 한다. 그래서 입력 스택을 거슬러 올라가며
지금 끝나는 것이 정말 $v_j$ 틀인지 확인한다. 정렬의 머리말이 서로 얽혀 있으면 회복할 길이 없으므로 치명적 오류로 멈춘다.

@<|mainControl|이 쓰는 동작...@>=
func doEndv() {
	basePtr = inputPtr; inputStack[basePtr] = curInput()
	for inputStack[basePtr].indexField != vTemplate &&
		inputStack[basePtr].locField == null &&
		inputStack[basePtr].stateField == tokenList {
		basePtr--
	}
	if inputStack[basePtr].indexField != vTemplate ||
		inputStack[basePtr].locField != null ||
		inputStack[basePtr].stateField != tokenList {
		fatalError("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	if curGroup == alignGroup {
		endGraf()
		if finCol() {
			finRow()
		}
	} else {
		offSave()
	}
}

@ 정렬을 오른쪽 중괄호로 닫으려 하면 그 앞에 \.{\\cr}을 끼워 넣는다.
@<|rightBrace|가 미루어 둔 동작을...@>=
case alignGroup:
	backInput(); curTok = csTokenFlag + frozenCr
	printErr("Missing "); printEsc("cr"); printStr(" inserted")
@.Missing \\cr inserted@>
	help1("I'm guessing that you meant to end an alignment here.")
	insError()

@ 명령 \.{\\noalign} 그룹이 끝나면 정렬의 다음 줄을 살펴보러 간다.
@<|rightBrace|가 미루어 둔 동작을...@>=
case noAlignGroup: endGraf(); unsave(); alignPeek()

@ 마지막으로 \.{\\endcsname}은 |mainControl|까지 와서는 안 된다.

@<상자와 목록을 만드는...@>=
case vmode + endCsName, hmode + endCsName, mmode + endCsName: csError()

@ 짝이 되는 \.{\\csname} 없이 나온 \.{\\endcsname}은 알리고 무시한다.
@<|mainControl|이 쓰는 동작...@>=
func csError() {
	printErr("Extra "); printEsc("endcsname")
@.Extra \\endcsname@>
	help1("I'm ignoring this, since I wasn't doing a \\csname.")
	reportError()
}

@* 수식 목록 만들기.
\TeX이 수식 목록을 만드는 루틴들은 방금 본 가로 목록과 세로 목록을 만드는 루틴들과 비슷하다. 다만 노드(node)만이 아니라
노드(noad)도 만들어야 한다. 그러니 다음 프로그램을 읽기 전에 수식 모드의 자료 구조를 다룬 부분을 다시 훑어보기 바란다.

먼저 작은 루틴 하나를 보자. 하위 수식을 처리하기 시작할 때마다 이 루틴을 부른다. 매개변수는 |mathGroup| 같은 그룹 코드다.

@<|mainControl|이 쓰는 동작...@>=
func pushMath(c groupCode) {
	pushNest(); mode = -mmode; setIncompleatNoad(null); newSaveLevel(c)
}

@ 가로 모드에서 수식 전환 문자 `\.\$'(곧 |mathShift|)를 만나면 수식 모드로 들어간다. 이때 바로 뒤에 `\.\$'가 하나 더 오는지 확인해야
한다. 그렇다면 따로 세운 수식 모드로 들어가야 하기 때문이다.

@<상자와 목록을 만드는...@>=
case hmode + mathShift: initMath()

@ 프로시저 |initMath|는 다음 토큰을 보고 어느 수식 모드로 들어갈지 정한다. 여기서 |getXToken| 대신 |getToken|을 쓰는 데는 까닭이 있다.
`\.\$' 바로 뒤에 \.{\\ifmmode}가 오면, 그것을 확장하는 시점에는 아직 수식 모드에 들어가지 않았으므로 틀린 답을 낼 것이기 때문이다.
따로 세운 수식은 바깥 가로 모드(|mode>0|)에서만 시작할 수 있다. 문단 안의 제한된 가로 모드, 이를테면 \.{\\hbox} 안에서 `\.{\$\$}'를 쓰면
빈 보통 수식이 된다.
@<|mainControl|이 쓰는 동작...@>=
func initMath() {
	var w scaled // 새 또는 부분 |preDisplaySize|
	var l scaled // 새 |displayWidth|
	var s scaled // 새 |displayIndent|
	var p pointer // |preDisplaySize|를 계산할 때 현재 노드
	var q pointer // |preDisplaySize|를 계산할 때 글루 명세
	var f internalFontNumber // 현재 |charNode|의 글꼴
	var n int32 // 문단 모양 지정의 범위
	var v scaled // |w|에 가능한 글루 양을 더한 것
	var d scaled // |v|의 증분
	getToken() // |getXToken|은 \.{\\ifmmode}에서 실패할 것이다\thinspace!
	if curCmd == mathShift && mode > 0 {
		@<따로 세운 수식 모드로 들어간다@>
	} else {
		backInput(); @<보통 수식 모드로 들어간다@>
	}
}

@ 보통 수식 모드로 들어갈 때는 새 수식 그룹을 열고, \.{\\fam}을 $-1$로 해 두고, \.{\\everymath}를 끼워 넣는다.
@<보통 수식 모드로...@>=
pushMath(mathShiftGroup); eqWordDefine(intBase+curFamCode, -1)
if everyMath() != null {
	beginTokenList(everyMath(), everyMathText)
}

@ 따로 세운 수식 모드에서 `\.{\\eqno}'나 `\.{\\leqno}'가 나타나면 보통 수식 모드로 들어가서 수식 번호를 읽는다. 이때 |curChr|는 각각
0이나~1이고, 이 값은 나중을 위해 |saveStack|에 보관한다.

@<상자와 목록을 만드는...@>=
case mmode + eqNo:
	if privileged() {
		if curGroup == mathShiftGroup {
			startEqNo()
		} else {
			offSave()
		}
	}

@ 앞 절의 원시 명령들을 해시 표에 넣는다.
@<\TeX의 원시 명령을...@>=
primitive("eqno", eqNo, 0)
@!@:eq_no_}{\.{\\eqno} primitive@>
primitive("leqno", eqNo, 1)
@!@:leq_no_}{\.{\\leqno} primitive@>

@ \TeX이 따로 세운 수식 모드에 있을 때는 |curGroup=mathShiftGroup|이다. 그러니 프로시저 |startEqNo|가 이 조건을 다시 검사할 필요는
없다.

@<|mainControl|이 쓰는 동작...@>=
func startEqNo() {
	setSaved(0, curChr); savePtr++
	@<보통 수식 모드로...@>
}

@ 수식 번호 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case eqNo:
	if chrCode == 1 { printEsc("leqno") } else { printEsc("eqno") }

@ 수식 모드 바깥에서는 \.{\\eqno}와 \.{\\leqno}를 쓸 수 없다.
@<|mainControl|이 금지하는...@>=
vmode + eqNo, hmode + eqNo,

@ 따로 세운 수식 모드에 들어갈 때는 먼저 |lineBreak|를 불러야 한다. 따로 세운 수식 때문에 방금 끊긴 부분 문단을 처리해야 하기
때문이다. 그런 다음에야 |displayWidth|와 |displayIndent|와 |preDisplaySize|의 알맞은 값을 정할 수 있다. 문단이 비어 있었다면, 곧
`\.{\\noindent\$\$}'처럼 시작했다면 마지막 줄이 없으므로 |preDisplaySize|는 $-$|maxDimen|이 된다.

@<따로 세운 수식 모드로...@>=
if head == tail { // `\.{\\noindent\$\$}'나 `\.{\$\${ }\$\$}'
	popNest(); w = -maxDimen
} else {
	lineBreak(displayWidowPenalty())
	@<마지막 줄의 문자들이 기준점 오른쪽으로 뻗는 자연 너비 |w|를 계산한다@>
}
// 이제 세로 모드에서, 따로 세운 수식을 담을 목록을 다루고 있다
@<따로 세운 수식 줄의 길이 |l|과 옮김 양 |s|를 계산한다@>
pushMath(mathShiftGroup); mode = mmode
eqWordDefine(intBase+curFamCode, -1)
eqWordDefine(dimenBase+preDisplaySizeCode, w)
eqWordDefine(dimenBase+displayWidthCode, l)
eqWordDefine(dimenBase+displayIndentCode, s)
if everyDisplay() != null {
	beginTokenList(everyDisplay(), everyDisplayText)
}
if nestPtr == 1 {
	buildPage()
}

@ 매개변수 \.{\\predisplaysize}는 바로 앞 줄의 내용이 기준점에서 어디까지 뻗는지 나타낸다. 그 줄의 마지막 ``보이는'' 항목의 오른쪽
끝을 재고, 여기에 두 em을 더한다. 그 줄에서 빈칸이 아닌 정보의 위치가 늘이기나 줄이기에 따라 달라지면 |w=maxDimen|으로 한다.

@<마지막 줄의 문자들이...@>=
v = shiftAmount(justBox) + 2*quad(curFont()); w = -maxDimen
p = listPtr(justBox)
for p != null {
	@<|d|를 노드 |p|의 자연 너비로 한다@>
	if v < maxDimen {
		v += d
	}
	goto notFound
found:
	if v < maxDimen {
		v += d; w = v
	} else {
		w = maxDimen; goto done
	}
notFound:
	p = link(p)
}
done: ;

@ 노드가 ``보이는'' 것이면 |goto found|하고, 늘어나거나 줄어든 글루이면 |v=maxDimen|으로 한다.

@<|d|를 노드 |p|의 자연 너비로...@>=
reswitch:
	if isCharNode(p) {
		f = font(p); d = charWidth(f, charInfo(f, character(p)))
		goto found
	}
	switch typ(p) {
	case hlistNode, vlistNode, ruleNode: d = width(p); goto found
	case ligatureNode: @<노드 |p|를 |charNode|처럼...@>
	case kernNode, mathNode: d = width(p)
	case glueNode: @<|d|를 이 글루의 자연 너비로 하고, 늘이거나 줄이면 |v=maxDimen|으로 한다@>
	case whatsitNode: @<|d|를 whatsit |p|의 너비로 한다@>
	default: d = 0
	}

@ 변수 |w|, |v|, |d|가 |glueSet| 값에 의존하지 않도록 조심해야 한다. 그런 값은 시스템마다 다르게 반올림되기 때문이다. \TeX82는 모든
기계에서 같은 결정을 내려야 하므로, 시스템에 따라 다른 수가 |preDisplaySize| 같은 매개변수에 스며들어서는 안 된다. 그래서 글루가 실제로
얼마나 늘어났는지는 계산하지 않고, 늘어났을 수 있으면 그냥 |v=maxDimen|으로 한다. 리더이면 |goto found|한다.

@<|d|를 이 글루의 자연 너비로...@>=
q = gluePtr(p); d = width(q)
if glueSign(justBox) == stretching {
	if glueOrder(justBox) == stretchOrder(q) && stretch(q) != 0 {
		v = maxDimen
	}
} else if glueSign(justBox) == shrinking {
	if glueOrder(justBox) == shrinkOrder(q) && shrink(q) != 0 {
		v = maxDimen
	}
}
if subtype(p) >= aLeaders {
	goto found
}

@ 따로 세운 수식은 문단의 세 줄을 차지하는 것으로 여긴다. 그래서 줄 번호 |prevGraf+2|의 길이와 오프셋을 계산한다.

@<따로 세운 수식 줄의 길이...@>=
if parShapePtr() == null {
	if hangIndent() != 0 &&
		((hangAfter() >= 0 && prevGraf+2 > hangAfter()) || prevGraf+1 < -hangAfter()) {
		l = hsize() - abs(hangIndent())
		if hangIndent() > 0 { s = hangIndent() } else { s = 0 }
	} else {
		l = hsize(); s = 0
	}
} else {
	n = info(parShapePtr())
	if prevGraf+2 >= n {
		p = parShapePtr() + 2*n
	} else {
		p = parShapePtr() + 2*(prevGraf+2)
	}
	s = mem[p-1].sc; l = mem[p].sc
}

@ 수식 안의 하위 수식은 저장 스택에서만이 아니라 의미 둥지에서도 수식 모드의 새 수준으로 들어간다. 이런 하위 수식이 생기는 경우는 몇
가지다. (1)~왼쪽 중괄호가 홀로 나오면 상자에 넣을 하위 수식이 시작된다. 그 안의 글루는 얼어붙고 그 안에서는 줄을 나누지 않는다.
(2)~아래첨자나 위첨자는 문자 하나가 아니면 하위 수식으로 다룬다. 명령 \.{\\underline} 같은 것의 핵도 마찬가지다. (3)~원시 명령
\.{\\left}는 짝이 되는 \.{\\right}로 끝날 하위 수식을 시작한다. 이 세 경우에 |saveStack|에 놓이는 그룹 코드는 각각 |mathGroup|,
|mathGroup|, |mathLeftGroup|이다.

다음은 경우 (1)을 다루는 코드다. 다른 경우들은 그리 간단하지 않으므로 나중에 생각하겠다.

@<상자와 목록을 만드는...@>=
case mmode + leftBrace:
	tailAppend(newNoad())
	backInput(); scanMath(nucleus(tail))

@ 노드(noad)의 |nucleus|, |subscr|, |supscr| 필드는 |mathType|과, |info|나 |(fam,character)|라는 하위 필드로 나뉜다는 것을 떠올리자.
프로시저 |scanMath|는 이 주요 필드 가운데 하나에 무엇을 놓을지 알아낸다. 입력에서 다음에 오는 하위 수식을 보고, 그것을 부호화한 값을
|mem|의 주어진 낱말에 놓는다.

함수 |famInRange|는 \.{\\fam}의 현재 값이 쓸 수 있는 글꼴 묶음 번호인지 알려 준다. 수식 코드가 ``변수'' 꼴(|varCode| 이상)일 때
이 값을 묶음으로 쓴다.

@<정의@>=
func famInRange() bool { return curFam() >= 0 && curFam() < 16 }

@ 이제 프로시저 |scanMath| 자체를 보자. 다음 토큰이 문자나 수식 문자 코드이면 바로 |mathChar| 필드를 채우고, 그렇지 않으면 중괄호로
둘러싼 하위 수식을 읽기 시작한다. 수식 코드가 |0o100000|인 문자는 능동 문자처럼 다룬다.

@<|mainControl|이 쓰는 동작...@>=
func scanMath(p pointer) {
	var c int32 // 수식 문자 코드
restart:
	@<공백도 relax도 호출도...@>
reswitch:
	switch curCmd {
	case letter, otherChar, charGiven:
		c = ho(mathCode(curChr))
		if c == 0o100000 {
			@<|curChr|를 능동 문자로 다룬다@>
			goto restart
		}
	case charNum:
		scanCharNum(); curChr = curVal; curCmd = charGiven
		goto reswitch
	case mathCharNum: scanFifteenBitInt(); c = curVal
	case mathGiven: c = curChr
	case delimNum: scanTwentySevenBitInt(); c = curVal / 0o10000
	default: @<중괄호로 둘러싼 하위 수식을 훑고 |return|한다@>
	}
	setMathType(p, mathChar); setCharacter(p, qi(c%256))
	if c >= varCode && famInRange() {
		setFam(p, curFam())
	} else {
		setFam(p, (c/256)%16)
	}
}

@ 여기서는 |outerCall|인 능동 문자도 허락된다.

@<|curChr|를 능동 문자로...@>=
curCs = curChr + activeBase
curCmd = eqType(curCs); curChr = equiv(curCs)
xToken(); backInput()

@ 복잡한 하위 수식을 훑는 동안에는 포인터 |p|를 |saveStack|에 보관해 둔다. 하위 수식이 끝나면 오른쪽 중괄호를 처리하는 루틴이
그것을 꺼내 쓴다.

@<중괄호로 둘러싼 하위 수식을...@>=
backInput(); scanLeftBrace()
setSaved(0, p); savePtr++; pushMath(mathGroup); return

@ 가장 간단한 수식은 물론 노드를 하나도 만들지 않는 `\.{\${ }\$}'다. 그다음으로 간단한 것은 이를테면 `\.{\$x\$}'처럼 문자 하나를
담은 수식이다. 별로 흥미로워 보이지 않을지도 모른다. 그러나 \TeX이 `\.{\$x\$}'를 처음으로 제대로 조판했을 때 저자가 얼마나 기뻤을지는
짐작이 갈 것이다. 그때 쓰인 것이 바로 이 절의 코드다.
@^Knuth, Donald Ervin@>

@<상자와 목록을 만드는...@>=
case mmode + letter, mmode + otherChar, mmode + charGiven:
	setMathChar(ho(mathCode(curChr)))
case mmode + charNum:
	scanCharNum(); curChr = curVal
	setMathChar(ho(mathCode(curChr)))
case mmode + mathCharNum: scanFifteenBitInt(); setMathChar(curVal)
case mmode + mathGiven: setMathChar(curChr)
case mmode + delimNum: scanTwentySevenBitInt(); setMathChar(curVal / 0o10000)

@ 프로시저 |setMathChar|는 주어진 수식 코드에 알맞은 새 노드를 만들어 현재 수식 목록에 덧붙인다. 수식 코드의 맨 위 자리(|c/0o10000|)는
노드의 종류(보통, 연산자, 이항, 관계 등)를 정한다. 다만 수식 코드가 |0o100000|만큼 크면 |curChr|를 능동 문자로 다루고 아무것도 덧붙이지
않는다.

@<|mainControl|이 쓰는 동작...@>=
func setMathChar(c int32) {
	var p pointer // 새 노드
	if c >= 0o100000 {
		@<|curChr|를 능동 문자로...@>
	} else {
		p = newNoad(); setMathType(nucleus(p), mathChar)
		setCharacter(nucleus(p), qi(c%256))
		setFam(nucleus(p), (c/256)%16)
		if c >= varCode {
			if famInRange() {
				setFam(nucleus(p), curFam())
			}
			setType(p, ordNoad)
		} else {
			setType(p, ordNoad+(c/0o10000))
		}
		setLink(tail, p); tail = p
	}
}

@ 원시 명령 \.{\\mathop}과 \.{\\underline} 같은 것에는 명령 코드 |mathComp|를 주고, 그것이 만드는 노드 형을 수정자로 준다.

@<\TeX의 원시 명령을...@>=
primitive("mathord", mathComp, ordNoad)
@!@:math_ord_}{\.{\\mathord} primitive@>
primitive("mathop", mathComp, opNoad)
@!@:math_op_}{\.{\\mathop} primitive@>
primitive("mathbin", mathComp, binNoad)
@!@:math_bin_}{\.{\\mathbin} primitive@>
primitive("mathrel", mathComp, relNoad)
@!@:math_rel_}{\.{\\mathrel} primitive@>
primitive("mathopen", mathComp, openNoad)
@!@:math_open_}{\.{\\mathopen} primitive@>
primitive("mathclose", mathComp, closeNoad)
@!@:math_close_}{\.{\\mathclose} primitive@>
primitive("mathpunct", mathComp, punctNoad)
@!@:math_punct_}{\.{\\mathpunct} primitive@>
primitive("mathinner", mathComp, innerNoad)
@!@:math_inner_}{\.{\\mathinner} primitive@>
primitive("underline", mathComp, underNoad)
@!@:underline_}{\.{\\underline} primitive@>
primitive("overline", mathComp, overNoad)
@!@:overline_}{\.{\\overline} primitive@>
primitive("displaylimits", limitSwitch, normal)
@!@:display_limits_}{\.{\\displaylimits} primitive@>
primitive("limits", limitSwitch, limits)
@!@:limits_}{\.{\\limits} primitive@>
primitive("nolimits", limitSwitch, noLimits)
@!@:no_limits_}{\.{\\nolimits} primitive@>

@ 이 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case mathComp:
	switch chrCode {
	case ordNoad: printEsc("mathord")
	case opNoad: printEsc("mathop")
	case binNoad: printEsc("mathbin")
	case relNoad: printEsc("mathrel")
	case openNoad: printEsc("mathopen")
	case closeNoad: printEsc("mathclose")
	case punctNoad: printEsc("mathpunct")
	case innerNoad: printEsc("mathinner")
	case underNoad: printEsc("underline")
	default: printEsc("overline")
	}
case limitSwitch:
	if chrCode == limits {
		printEsc("limits")
	} else if chrCode == noLimits {
		printEsc("nolimits")
	} else {
		printEsc("displaylimits")
	}

@ 수식 성분 명령은 해당 종류의 노드를 만들고 그 핵을 읽는다. 명령 \.{\\limits}, \.{\\nolimits}, \.{\\displaylimits}는 따로 처리한다.
@<상자와 목록을 만드는...@>=
case mmode + mathComp:
	tailAppend(newNoad())
	setType(tail, curChr); scanMath(nucleus(tail))
case mmode + limitSwitch: mathLimitSwitch()

@ 명령 \.{\\limits} 따위는 바로 앞의 연산자 노드의 |subtype|을 바꾼다. 앞에 연산자가 없으면 오류다.
@<|mainControl|이 쓰는 동작...@>=
func mathLimitSwitch() {
	if head != tail && typ(tail) == opNoad {
		setSubtype(tail, curChr); return
	}
	printErr("Limit controls must follow a math operator")
@.Limit controls must follow...@>
	help1("I'm ignoring this misplaced \\limits or \\nolimits command."); reportError()
}

@ 노드(noad)의 구분자 필드는 루틴 |scanDelimiter|가 채운다. 이 프로시저의 첫 매개변수는 구분자를 놓을 |mem| 주소이고, 둘째는 이
구분자가 \.{\\radical} 뒤에 오는지 알려 준다. 구분자 코드의 아래 24비트는 작은 구분자의 묶음과 문자, 큰 구분자의 묶음과 문자를 차례로
담는다.

@<|mainControl|이 쓰는 동작...@>=
func scanDelimiter(p pointer, r bool) {
	if r {
		scanTwentySevenBitInt()
	} else {
		@<공백도 relax도 호출도...@>
		switch curCmd {
		case letter, otherChar: curVal = delCode(curChr)
		case delimNum: scanTwentySevenBitInt()
		default: curVal = -1
		}
	}
	if curVal < 0 {
		@<무효한 구분자 코드를 널로 바꾼다고 알리고 |curVal=0|으로 한다@>
	}
	setSmallFam(p, (curVal/0o4000000)%16)
	setSmallChar(p, qi((curVal/0o10000)%256))
	setLargeFam(p, (curVal/256)%16)
	setLargeChar(p, qi(curVal%256))
}

@ 구분자 자리에 구분자로 쓸 수 없는 것이 오면 널 구분자로 바꾸고 알린다.
@<무효한 구분자 코드를...@>=
printErr("Missing delimiter (. inserted)")
@.Missing delimiter...@>
help6("I was expecting to see something like `(' or `\\{' or",
	"`\\}' here. If you typed, e.g., `{' instead of `\\{', you",
	"should probably delete the `{' by typing `1' now, so that",
	"braces don't get unbalanced. Otherwise just proceed.",
	"Acceptable delimiters are characters whose \\delcode is",
	"nonnegative, or you can use `\\delimiter <delimiter code>'.")
backError(); curVal = 0

@ 근호는 |mathRadical|이 만든다.
@<상자와 목록을 만드는...@>=
case mmode + radical: mathRadical()

@ 근호 노드는 구분자 하나와 핵 하나를 읽는다.
@<|mainControl|이 쓰는 동작...@>=
func mathRadical() {
	tailAppend(getNode(radicalNoadSize))
	setType(tail, radicalNoad); setSubtype(tail, normal)
	mem[nucleus(tail)].hh = emptyField
	mem[subscr(tail)].hh = emptyField
	mem[supscr(tail)].hh = emptyField
	scanDelimiter(leftDelimiter(tail), true); scanMath(nucleus(tail))
}

@ 수식 악센트는 |mathAc|이 만든다.
@<상자와 목록을 만드는...@>=
case mmode + accent, mmode + mathAccent: mathAc()

@ 수식 모드에서 \.{\\accent}를 쓰면 \.{\\mathaccent}로 바꾸어 처리한다. 악센트 문자는 15비트 수식 코드로 읽는다.
@<|mainControl|이 쓰는 동작...@>=
func mathAc() {
	if curCmd == accent {
		@<사용자가 \.{\\mathaccent}라고 했어야 한다고 불평한다@>
	}
	tailAppend(getNode(accentNoadSize))
	setType(tail, accentNoad); setSubtype(tail, normal)
	mem[nucleus(tail)].hh = emptyField
	mem[subscr(tail)].hh = emptyField
	mem[supscr(tail)].hh = emptyField
	setMathType(accentChr(tail), mathChar)
	scanFifteenBitInt()
	setCharacter(accentChr(tail), qi(curVal%256))
	if curVal >= varCode && famInRange() {
		setFam(accentChr(tail), curFam())
	} else {
		setFam(accentChr(tail), (curVal/256)%16)
	}
	scanMath(nucleus(tail))
}

@ 수식의 악센트는 본문의 악센트와 다르게 놓이므로 \.{\\mathaccent}를 쓰라고 알린다. 도움말에서 \TeX은 행운을 빌어 달라고 한다.
@<사용자가 \.{\\mathaccent}라고...@>=
printErr("Please use "); printEsc("mathaccent")
printStr(" for accents in math mode")
@.Please use \\mathaccent...@>
help2("I'm changing \\accent to \\mathaccent here; wish me luck.",
	"(Accents are not the same in formulas as they are in text.)")
reportError()

@ 명령 \.{\\vcenter}는 \.{\\vbox}처럼 내부 세로 모드에서 재료를 모은다.
@<상자와 목록을 만드는...@>=
case mmode + vcenter:
	scanSpec(vcenterGroup, false); normalParagraph()
	pushNest(); mode = -vmode; setPrevDepth(ignoreDepth)
	if everyVbox() != null {
		beginTokenList(everyVbox(), everyVboxText)
	}

@ 그룹 \.{\\vcenter}가 끝나면 세로 상자로 꾸려서 |vcenterNoad|의 핵에 넣는다.
@<|rightBrace|가 미루어 둔 동작을...@>=
case vcenterGroup:
	endGraf(); unsave(); savePtr -= 2
	p = vpack(link(head), saved(1), saved(0)); popNest()
	tailAppend(newNoad()); setType(tail, vcenterNoad)
	setMathType(nucleus(tail), subBox); setInfo(nucleus(tail), p)

@ 노드 |styleNode|를 넣는 루틴에는 놀랄 것이 없다.

@<\TeX의 원시 명령을...@>=
primitive("displaystyle", mathStyle, displayStyle)
@!@:display_style_}{\.{\\displaystyle} primitive@>
primitive("textstyle", mathStyle, textStyle)
@!@:text_style_}{\.{\\textstyle} primitive@>
primitive("scriptstyle", mathStyle, scriptStyle)
@!@:script_style_}{\.{\\scriptstyle} primitive@>
primitive("scriptscriptstyle", mathStyle, scriptScriptStyle)
@!@:script_script_style_}{\.{\\scriptscriptstyle} primitive@>

@ 스타일 명령의 이름은 |printStyle|이 찍는다.
@<원시 명령의 이름을 찍는...@>=
case mathStyle: printStyle(chrCode)

@ 스타일 명령은 스타일 노드를 덧붙인다. 명령 \.{\\nonscript}는 특별한 글루 노드를 넣는데, 이 글루는 첨자 스타일에서 바로 뒤의 글루를 없앤다.
@<상자와 목록을 만드는...@>=
case mmode + mathStyle: tailAppend(newStyle(curChr))
case mmode + nonScript:
	tailAppend(newGlue(zeroGlue))
	setSubtype(tail, condMathGlue)
case mmode + mathChoice: appendChoices()

@ 명령 \.{\\mathchoice}의 수식 목록 넷을 훑는 루틴은 선택적 나눔 노드를 만드는 루틴과 아주 비슷하다.

@<|mainControl|이 쓰는 동작...@>=
func appendChoices() {
	tailAppend(newChoice()); savePtr++; setSaved(-1, 0)
	pushMath(mathChoiceGroup); scanLeftBrace()
}

@ 오른쪽 중괄호가 \.{\\mathchoice}의 한 목록을 닫으면 다음 목록으로 넘어간다.
@<|rightBrace|가 미루어 둔 동작을...@>=
case mathChoiceGroup: buildChoices()

@ 프로시저 |buildChoices|는 \.{\\mathchoice}의 중괄호 그룹 하나가 끝날 때마다 불린다. 방금 끝난 수식 목록을 |saved(-1)|이 가리키는 자리,
곧 디스플레이, 본문, 첨자, 이중 첨자 스타일의 목록 가운데 하나에 넣는다. 넷째 목록이 아니면 다음 그룹을 읽기 시작한다.
@<|mainControl|이 쓰는 동작...@>=
@<|finMlist|라는 함수를 선언한다@>@;
func buildChoices() {
	unsave(); p := finMlist(null) // 현재 수식 목록
	switch saved(-1) {
	case 0: setDisplayMlist(tail, p)
	case 1: setTextMlist(tail, p)
	case 2: setScriptMlist(tail, p)
	case 3: setScriptScriptMlist(tail, p); savePtr--; return
	} // 다른 경우는 없다
	setSaved(-1, saved(-1)+1); pushMath(mathChoiceGroup); scanLeftBrace()
}

@ 아래첨자와 위첨자는 동작 프로시저 |subSup|가 앞의 핵에 붙인다. 여기서는 |subMark=supMark+1|이고 |subscr(p)=supscr(p)+1|이라는
@^superscripts@>@^subscripts@>
사실을 이용한다. 그래서 |curCmd-supMark|를 더하기만 하면 알맞은 필드를 고를 수 있다.

@<상자와 목록을 만드는...@>=
case mmode + subMark, mmode + supMark: subSup()

@ 현재 목록의 꼬리가 첨자를 붙일 수 있는 노드이고 그 자리가 비어 있으면 거기에 첨자를 읽어 넣는다. 그렇지 않으면 빈 핵을 가진 노드를
새로 만들어 거기에 붙인다.
@<|mainControl|이 쓰는 동작...@>=
func subSup() {
	var t smallNumber // 앞 첨자의 형
	var p pointer // |scanMath|가 채울 필드
	t = empty; p = null
	if tail != head && scriptsAllowed(tail) {
		p = supscr(tail) + curCmd - supMark // |supscr|나 |subscr|
		t = mathType(p)
	}
	if p == null || t != empty {
		@<첨자를 붙일 가짜 노드를 넣는다@>
	}
	scanMath(p)
}

@ 같은 종류의 첨자가 이미 있으면 `\.{x\^1\^2}'를 `\.{x\^1\{\}\^2}'처럼 다룬다고 알린다. 앞에 첨자를 붙일 노드가 없을 때는 알리지 않고
조용히 빈 노드를 만든다.
@<첨자를 붙일 가짜 노드를...@>=
tailAppend(newNoad())
p = supscr(tail) + curCmd - supMark // |supscr|나 |subscr|
if t != empty {
	if curCmd == supMark {
		printErr("Double superscript")
@.Double superscript@>
		help1("I treat `x^1^2' essentially like `x^1{}^2'.")
	} else {
		printErr("Double subscript")
@.Double subscript@>
		help1("I treat `x_1_2' essentially like `x_1{}_2'.")
	}
	reportError()
}

@ `\.{\\over}' 같은 연산은 현재 수식 목록을 잠시 멈추어 둔다. 변수 |incompleatNoad|는 지금까지의 수식 목록을 분자로 담은 |fractionNoad|를
가리키고, 분모는 아직 오지 않았다. 마침내 수식 목록이 끝나면 분모가 이 미완성 분수 노드에 들어간다. 그 노드는 `\.{\\left}'와 `\.{\\right}'
구분자로 둘러싸여 있지 않으면 그 자체로 수식 전체가 된다.

@<정의@>=
const (
	@!aboveCode = iota // `\.{\\above}'
	@!overCode // `\.{\\over}'
	@!atopCode // `\.{\\atop}'
	@!delimitedCode // `\.{\\abovewithdelims}' 따위
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("above", above, aboveCode)
@!@:above_}{\.{\\above} primitive@>
primitive("over", above, overCode)
@!@:over_}{\.{\\over} primitive@>
primitive("atop", above, atopCode)
@!@:atop_}{\.{\\atop} primitive@>
primitive("abovewithdelims", above, delimitedCode+aboveCode)
@!@:above_with_delims_}{\.{\\abovewithdelims} primitive@>
primitive("overwithdelims", above, delimitedCode+overCode)
@!@:over_with_delims_}{\.{\\overwithdelims} primitive@>
primitive("atopwithdelims", above, delimitedCode+atopCode)
@!@:atop_with_delims_}{\.{\\atopwithdelims} primitive@>

@ 분수 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case above:
	switch chrCode {
	case overCode: printEsc("over")
	case atopCode: printEsc("atop")
	case delimitedCode + aboveCode: printEsc("abovewithdelims")
	case delimitedCode + overCode: printEsc("overwithdelims")
	case delimitedCode + atopCode: printEsc("atopwithdelims")
	default: printEsc("above")
	}

@ 분수 명령은 |mathFraction|이 처리한다.
@<상자와 목록을 만드는...@>=
case mmode + above: mathFraction()

@ 한 수식 목록 안에 분수 명령이 두 번 나오면 어떻게 묶어야 할지 알 수 없다. 그렇지 않으면 지금까지의 목록을 분자로 하는 분수 노드를
만들고, 현재 목록은 빈 채로 분모를 모으기 시작한다.
@<|mainControl|이 쓰는 동작...@>=
func mathFraction() {
	c := curChr // 훑고 있는 일반화된 분수의 형
	if incompleatNoad() != null {
		@<분수 연산을 무시하고 이 모호한 경우에 대해 불평한다@>
	} else {
		setIncompleatNoad(getNode(fractionNoadSize))
		setType(incompleatNoad(), fractionNoad)
		setSubtype(incompleatNoad(), normal)
		setMathType(numerator(incompleatNoad()), subMlist)
		setInfo(numerator(incompleatNoad()), link(head))
		mem[denominator(incompleatNoad())].hh = emptyField
		mem[leftDelimiter(incompleatNoad())].qqqq = nullDelimiter
		mem[rightDelimiter(incompleatNoad())].qqqq = nullDelimiter
		setLink(head, null); tail = head
		@<코드 |c|로 일반화된 분수들을 구별한다@>
	}
}

@ 구분자가 붙은 분수이면 구분자 둘을 읽는다. 그다음 분수선의 두께를 정한다. 명령 \.{\\above}는 두께를 읽고, \.{\\over}는 기본 두께를
뜻하는 |defaultCode|를, \.{\\atop}은 0을 쓴다.
@<코드 |c|로 일반화된...@>=
if c >= delimitedCode {
	scanDelimiter(leftDelimiter(incompleatNoad()), false)
	scanDelimiter(rightDelimiter(incompleatNoad()), false)
}
switch c % delimitedCode {
case aboveCode: scanNormalDimen(); setThickness(incompleatNoad(), curVal)
case overCode: setThickness(incompleatNoad(), defaultCode)
case atopCode: setThickness(incompleatNoad(), 0)
} // 다른 경우는 없다

@ 무시하는 분수 명령의 인자도 읽어서 버려야 한다. 그렇지 않으면 그것이 수식의 일부가 되어 버린다.
@<분수 연산을 무시하고...@>=
if c >= delimitedCode {
	scanDelimiter(garbage, false); scanDelimiter(garbage, false)
}
if c%delimitedCode == aboveCode {
	scanNormalDimen()
}
printErr("Ambiguous; you need another { and }")
@.Ambiguous...@>
help3("I'm ignoring this fraction specification, since I don't",
	"know whether a construction like `x \\over y \\over z'",
	"means `{x \\over y} \\over z' or `x \\over {y \\over z}'.")
reportError()

@ 수식이나 하위 수식이 끝나면 루틴 |finMlist|를 불러 새로 완성된 수식 목록을 가리키는 포인터를 돌려받고, 의미 둥지의 바깥 수준으로
돌아간다. 함수 |finMlist|의 매개변수는 널이 아니면 현재 수식 목록을 끝내는 |rightNoad|를 가리킨다. 이 |rightNoad|는 아직 목록에
덧붙이지 않은 상태다.

@<|finMlist|라는...@>=
func finMlist(p pointer) pointer {
	var q pointer // 돌려줄 수식 목록
	if incompleatNoad() != null {
		@<미완성 노드를 완성한다@>
	} else {
		setLink(tail, p); q = link(head)
	}
	popNest(); return q
}

@ 미완성 분수 노드에 분모를 넣는다. 명령 \.{\\left}로 시작한 목록이었다면 분자의 첫 항목이 그 |leftNoad|이므로, 그것을 분자에서 떼어 내어
분수 앞에 다시 두고 끝에 |rightNoad|를 붙인다. 그러면 구분자가 분수 전체를 둘러싼다.
@<미완성 노드를...@>=
setMathType(denominator(incompleatNoad()), subMlist)
setInfo(denominator(incompleatNoad()), link(head))
if p == null {
	q = incompleatNoad()
} else {
	q = info(numerator(incompleatNoad()))
	if typ(q) != leftNoad {
		confusion("right")
	}
@:this can't happen right}{\quad right@>
	setInfo(numerator(incompleatNoad()), link(q))
	setLink(q, incompleatNoad()); setLink(incompleatNoad(), p)
}

@ 드디어 수식 안에서 오른쪽 중괄호가 나타나면 무슨 일이 일어나는지 볼 준비가 되었다. 여기서 두 특별한 경우를 단순하게 만든다.
중괄호가 첨자 없는 Ord 하나를 둘러싸거나, Ord 원자의 핵 자리에서 악센트 하나를 둘러싸면 중괄호는 사실상 없어진다.

@<|rightBrace|가 미루어 둔 동작을...@>=
case mathGroup:
	unsave(); savePtr--
	setMathType(saved(0), subMlist); p = finMlist(null); setInfo(saved(0), p)
	if p != null && link(p) == null {
		if typ(p) == ordNoad {
			if mathType(subscr(p)) == empty && mathType(supscr(p)) == empty {
				mem[saved(0)].hh = mem[nucleus(p)].hh
				freeNode(p, noadSize)
			}
		} else if typ(p) == accentNoad && saved(0) == nucleus(tail) && typ(tail) == ordNoad {
			@<목록의 꼬리를 |p|로 바꾼다@>
		}
	}

@ 꼬리 노드를 바꾸려면 그 앞 노드를 찾아야 하므로 목록을 처음부터 훑는다.
@<목록의 꼬리를 |p|로...@>=
q = head
for link(q) != tail {
	q = link(q)
}
setLink(q, p); freeNode(tail, noadSize); tail = p

@ 수식 모드의 구성 가운데 `\.{\\left}'와 `\.{\\right}'만 빼고 모두 다루었다. 그 둘은 다음 몇 절에서 다루어 그림을 완성한다.

@<\TeX의 원시 명령을...@>=
primitive("left", leftRight, leftNoad)
@!@:left_}{\.{\\left} primitive@>
primitive("right", leftRight, rightNoad)
@!@:right_}{\.{\\right} primitive@>
setText(frozenRight, str("right")); eqtb[frozenRight] = eqtb[curVal]

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case leftRight:
	if chrCode == leftNoad { printEsc("left") } else { printEsc("right") }

@ 구분자 명령은 |mathLeftRight|가 처리한다.
@<상자와 목록을 만드는...@>=
case mmode + leftRight: mathLeftRight()

@ 명령 \.{\\left}는 새 수식 그룹을 열고 그 목록의 첫 항목으로 |leftNoad|를 둔다. 명령 \.{\\right}는 그 그룹을 닫고 완성된 목록을
|innerNoad|의 핵으로 해서 바깥 목록에 붙인다.
@<|mainControl|이 쓰는 동작...@>=
func mathLeftRight() {
	var p pointer // 새 노드
	t := curChr // |leftNoad|나 |rightNoad|
	if t == rightNoad && curGroup != mathLeftGroup {
		@<짝이 맞지 않는 \.{\\right}에서 회복해 본다@>
	} else {
		p = newNoad(); setType(p, t)
		scanDelimiter(delimiter(p), false)
		if t == leftNoad {
			pushMath(mathLeftGroup); setLink(head, p); tail = p
		} else {
			p = finMlist(p); unsave() // |mathLeftGroup|의 끝
			tailAppend(newNoad()); setType(tail, innerNoad)
			setMathType(nucleus(tail), subMlist)
			setInfo(nucleus(tail), p)
		}
	}
}

@ 짝이 되는 \.{\\left} 없이 \.{\\right}가 나온 경우다. 수식의 바깥 수준이면 그 구분자를 읽어 버리고 무시한다. 다른 그룹 안이면 그
그룹을 닫는 데 도움이 될 것을 끼워 넣는다.
@<짝이 맞지 않는 \.{\\right}에서...@>=
if curGroup == mathShiftGroup {
	scanDelimiter(garbage, false)
	printErr("Extra "); printEsc("right")
@.Extra \\right.@>
	help1("I'm ignoring a \\right that had no matching \\left.")
	reportError()
} else {
	offSave()
}

@ 수식 모드에서 나가는 길은 이것뿐이다.

@<상자와 목록을 만드는...@>=
case mmode + mathShift:
	if curGroup == mathShiftGroup { afterMath() } else { offSave() }

@ 프로시저 |afterMath|는 수식을 끝낸다. 먼저 수식 기호 글꼴이 제대로 갖추어졌는지 확인한다. 수식 번호를 읽던 중이었다면 그것을 상자로
만들어 |a|에 넣고 한 수준 더 바깥으로 나간다. 그다음 본문 안의 수식이면 가로 목록으로 바꾸어 붙이고, 따로 세운 수식이면 가운데 맞추어
세로 목록에 붙인다.
@<|mainControl|이 쓰는 동작...@>=
func afterMath() {
	var l bool // `\.{\\eqno}' 대신 `\.{\\leqno}'인가
	var danger bool // 기호 글꼴이 넉넉하지 않은가
	var p pointer // 수식
	var a pointer // 수식 번호를 담은 상자
	@<따로 세운 수식을 마무리하는 지역 변수@>@;
	danger = false
	@<수식 기호 글꼴이 갖추어졌는지 확인한다@>
	m := mode // |mmode|나 |-mmode|
	l = false; p = finMlist(null) // 이것이 둥지를 꺼낸다
	if mode == -m { // 수식 번호의 끝
		@<\.\$가 하나 더 오는지 확인한다@>
		curMlist = p; curStyle = textStyle; mlistPenalties = false
		mlistToHlist(); a = hpack(link(tempHead), natural, additional)
		unsave(); savePtr-- // 이제 |curGroup=mathShiftGroup|이다
		if saved(0) == 1 {
			l = true
		}
		danger = false
		@<수식 기호 글꼴이...@>
		m = mode; p = finMlist(null)
	} else {
		a = null
	}
	if m < 0 {
		@<본문 안의 수식을 마무리한다@>
	} else {
		if a == null {
			@<\.\$가 하나 더 오는지...@>
		}
		@<따로 세운 수식을 마무리한다@>
	}
}

@ 수식 기호에 필요한 글꼴이 있는지 확인하고, 없으면 현재 수식 목록을 비우고 |danger=true|로 한다. 묶음 2는 \.{\\fontdimen}
매개변수가 22개 이상, 묶음 3은 13개 이상 있어야 한다.

@<수식 기호 글꼴이...@>=
if fontParams[famFnt(2+textSize)] < totalMathsyParams ||
	fontParams[famFnt(2+scriptSize)] < totalMathsyParams ||
	fontParams[famFnt(2+scriptScriptSize)] < totalMathsyParams {
	printErr("Math formula deleted: Insufficient symbol fonts")
@.Math formula deleted...@>
	help3("Sorry, but I can't typeset math unless \\textfont 2",
		"and \\scriptfont 2 and \\scriptscriptfont 2 have all",
		"the \\fontdimen values needed in math symbol fonts.")
	reportError(); flushMath(); danger = true
} else if fontParams[famFnt(3+textSize)] < totalMathexParams ||
	fontParams[famFnt(3+scriptSize)] < totalMathexParams ||
	fontParams[famFnt(3+scriptScriptSize)] < totalMathexParams {
	printErr("Math formula deleted: Insufficient extension fonts")
	help3("Sorry, but I can't typeset math unless \\textfont 3",
		"and \\scriptfont 3 and \\scriptscriptfont 3 have all",
		"the \\fontdimen values needed in math extension fonts.")
	reportError(); flushMath(); danger = true
}

@ 여기서 |unsave|는 다른 일을 모두 한 다음에 한다. 그래서 `\.{\$...\$}' 안에 `\.{\\mathsurround}'가 나타나면 바로 그 \.\$들의 간격에
영향을 준다. 이것은 `\.{\$\$...\$\$}'의 관례와도 들어맞는다. 따로 세운 수식 안의 `\.{\\abovedisplayskip}'은 그 수식 위의 공간에 영향을
주기 때문이다.

@<본문 안의 수식을...@>=
tailAppend(newMath(mathSurround(), before))
curMlist = p; curStyle = textStyle; mlistPenalties = mode > 0; mlistToHlist()
setLink(tail, link(tempHead))
for link(tail) != null {
	tail = link(tail)
}
tailAppend(newMath(mathSurround(), after))
setSpaceFactor(1000); unsave()

@ 따로 세운 수식을 끝내는 첫 `\.\$'를 훑은 다음 \TeX은 프로그램의 이 부분에 이른다.

@<\.\$가 하나 더 오는지...@>=
getXToken()
if curCmd != mathShift {
	printErr("Display math should end with $$")
@.Display math...with \$\$@>
	help2("The `$' that I just saw supposedly matches a previous `$$'.",
		"So I shall assume that you typed `$$' both times.")
	backError()
}

@ 가장 까다로운 것을 마지막까지 남겨 두었다. 수식 모드 처리에서 가장 성가신 부분은 따로 세운 수식을 가운데 맞추고, 수식 번호가
있으면 그것과 함께 놓는 일이다.

@<따로 세운 수식을 마무리하는 지역...@>=
var b pointer // 수식을 담은 상자
var w scaled // 수식의 너비
var z scaled // 줄의 너비
var e scaled // 수식 번호의 너비
var q scaled // 수식 번호의 너비에 수식과 떼어 놓을 공간을 더한 것
var d scaled // 줄 안에서 수식의 변위
var s scaled // 줄을 이만큼 오른쪽으로 옮긴다
var g1, g2 smallNumber // 앞뒤의 글루 매개변수 코드
var r pointer // 따로 세운 수식의 자리를 잡는 데 쓰는 커닝 노드
var t pointer // 조정 목록의 꼬리

@ 이 시점에서 |p|는 수식의 수식 목록을 가리키고, |a|는 |null|이거나 수식 번호를 담은 상자를 가리키며, 우리는 세로 모드(또는 내부 세로
모드)에 있다. 수식을 상자 |b|로 꾸리고 그 너비 |w|를 잰 다음, 수식 번호의 너비 |e|와 함께 줄 너비 |z| 안에 들어가는지 본다.

@<따로 세운 수식을 마무리한다@>=
curMlist = p; curStyle = displayStyle; mlistPenalties = false
mlistToHlist(); p = link(tempHead)
adjustTail = adjustHead; b = hpack(p, natural, additional); p = listPtr(b)
t = adjustTail; adjustTail = null
w = width(b); z = displayWidth(); s = displayIndent()
if a == null || danger {
	e = 0; q = 0
} else {
	e = width(a); q = e + mathQuad(textSize)
}
if w+q > z {
	@<수식을 될 수 있는 대로 줄이고, 수식 번호를 따로 한 줄에 놓아야 하면 |e=0|으로 한다@>
}
@<줄 크기 |z|에 대한 수식 왼쪽 끝의 변위 |d|를 정한다@>
@<따로 세운 수식 앞의 글루나 수식 번호를 덧붙인다@>
@<따로 세운 수식과, 어쩌면 수식 번호도 덧붙인다@>
@<따로 세운 수식 뒤의 글루나 수식 번호를 덧붙인다@>
resumeAfterDisplay()

@ 따로 세운 수식이 끝나면 문단은 계속된다. 그 수식이 세 줄을 차지한 것으로 치고, 가로 모드로 다시 들어간다. 언어 정보도 새 문단처럼
다시 정한다.
@<|mainControl|이 쓰는 동작...@>=
func resumeAfterDisplay() {
	if curGroup != mathShiftGroup {
		confusion("display")
	}
@:this can't happen display}{\quad display@>
	unsave(); prevGraf += 3
	pushNest(); mode = hmode; setSpaceFactor(1000); setCurLang(); setClang(curLang)
	prevGraf = (normMin(leftHyphenMin())*0o100+normMin(rightHyphenMin()))*0o200000 + curLang
	@<선택적인 공백 하나를 훑는다@>
	if nestPtr == 1 {
		buildPage()
	}
}

@ 수식과 수식 번호가 한 줄에 들어가지 않으면, 먼저 수식을 줄여서 둘 다 넣어 본다. 그래도 안 되면 수식 번호를 따로 한 줄에 놓는다.
사용자는 수식 번호의 너비를 0으로 만들어서 번호를 따로 한 줄에 놓이게 할 수 있다.

@<수식을 될 수 있는 대로...@>=
if e != 0 && (w-totalShrink[normal]+q <= z || totalShrink[fil] != 0 ||
	totalShrink[fill] != 0 || totalShrink[filll] != 0) {
	freeNode(b, boxNodeSize)
	b = hpack(p, z-q, exactly)
} else {
	e = 0
	if w > z {
		freeNode(b, boxNodeSize)
		b = hpack(p, z, exactly)
	}
}
w = width(b)

@ 먼저 수식 번호는 아랑곳하지 않고 따로 세운 수식을 가운데 맞추어 본다. 그랬더니 수식과 번호가 너무 가까워지면(``너무 가깝다''는 것은
따로 세운 수식과 수식 번호 사이의 공간이 수식 번호의 너비보다 작다는 뜻이다), 남은 공간의 가운데에 놓거나 수식 번호에서 될 수 있는
대로 멀리 옮긴다. 뒤의 것은 따로 세운 수식이 글루로 시작할 때만 택한다. 사용자가 간격을 정확히 다스리려고 거기 글루를 넣었다고 보기
때문이다. 이 계산은 |l=false|라고 가정한다.

@<줄 크기 |z|에 대한...@>=
d = half(z - w)
if e > 0 && d < 2*e { // 너무 가깝다
	d = half(z - w - e)
	if p != null && !isCharNode(p) && typ(p) == glueNode {
		d = 0
	}
}

@ 수식 번호를 수식 앞이나 뒤에 따로 한 줄로 놓을 때는 무한 벌점을 덧붙인다. 그래야 쪽 나눔이 따로 세운 수식과 그 번호를 떼어 놓지
않는다. 그리고 `\.{\\parshape}'가 무엇을 지정하든 따로 세운 수식의 잠재적인 세 줄 모두에 같은 크기와 변위를 쓴다.

앞 줄이 수식에 닿을 만큼 길거나(|d+s<=preDisplaySize|) \.{\\leqno}이면 보통 간격인 \.{\\abovedisplayskip}과 \.{\\belowdisplayskip}을, 그렇지 않으면
짧은 간격인 \.{\\abovedisplayshortskip}과 \.{\\belowdisplayshortskip}을 쓴다.

@<따로 세운 수식 앞의...@>=
tailAppend(newPenalty(preDisplayPenalty()))
if d+s <= preDisplaySize() || l { // 틈이 넉넉하지 않다
	g1 = aboveDisplaySkipCode; g2 = belowDisplaySkipCode
} else {
	g1 = aboveDisplayShortSkipCode
	g2 = belowDisplayShortSkipCode
}
if l && e == 0 { // 이로부터 |typ(a)=hlistNode|이다
	setShiftAmount(a, s); appendToVlist(a)
	tailAppend(newPenalty(infPenalty))
} else {
	tailAppend(newParamGlue(g1))
}

@ 수식 번호가 수식과 같은 줄에 있으면 둘 사이에 커닝을 넣어 한 상자로 묶는다. 명령 \.{\\leqno}이면 번호가 왼쪽에, \.{\\eqno}이면 오른쪽에
온다.
@<따로 세운 수식과, 어쩌면...@>=
if e != 0 {
	r = newKern(z - w - e - d)
	if l {
		setLink(a, r); setLink(r, b); b = a; d = 0
	} else {
		setLink(b, r); setLink(r, a)
	}
	b = hpack(b, natural, additional)
}
setShiftAmount(b, s+d); appendToVlist(b)

@ 수식 번호를 수식 아래 따로 한 줄에 놓았다면 아래 간격 글루는 넣지 않는다. 수식 안에서 \.{\\vadjust}나 \.{\\insert}로 옮겨 낸 재료는
수식 번호 뒤에 붙인다.
@<따로 세운 수식 뒤의...@>=
if a != null && e == 0 && !l {
	tailAppend(newPenalty(infPenalty))
	setShiftAmount(a, s+z-width(a))
	appendToVlist(a)
	g2 = 0
}
if t != adjustHead { // 옮겨 가는 내용은 수식 번호 뒤에 온다
	setLink(tail, link(adjustHead)); tail = t
}
tailAppend(newPenalty(postDisplayPenalty()))
if g2 > 0 {
	tailAppend(newParamGlue(g2))
}

@ 따로 세운 수식 안에 \.{\\halign}이 나타나면, 정렬 루틴은 본질적으로 세로 모드에서처럼 일한다. 그것이 끝나면 다음 프로그램이 이어받는다.
이때 |p|와 |q|는 결과 목록의 처음과 끝을 가리키고, |auxSave|는 |prevDepth| 값을 담고 있다.

@<따로 세운 수식 안의 정렬을...@>=
doAssignments()
if curCmd != mathShift {
	@<따로 세운 수식 안의 부적절한 정렬에 대해 훈계한다@>
} else {
	@<\.\$가 하나 더 오는지...@>
}
popNest()
tailAppend(newPenalty(preDisplayPenalty()))
tailAppend(newParamGlue(aboveDisplaySkipCode))
setLink(tail, p)
if p != null {
	tail = q
}
tailAppend(newPenalty(postDisplayPenalty()))
tailAppend(newParamGlue(belowDisplaySkipCode))
setPrevDepth(auxSave.sc); resumeAfterDisplay()

@ 따로 세운 수식 안의 정렬 뒤에는 `\.{\$\$}' 말고 다른 것이 오면 안 된다.
@<따로 세운 수식 안의 부적절한 정렬에...@>=
printErr("Missing $$ inserted")
@.Missing {\$\$} inserted@>
help2("Displays can use special alignments (like \\eqalignno)",
	"only if nothing but the alignment itself is between $$'s.")
backError()

@* 모드에 상관없는 처리.
긴 프로시저 |mainControl|에서 아직 정하지 않은 것은 이제 현재 모드와 상관없는 몇몇 활동뿐이다. 이 활동들은 현재 세로 목록이나 가로
목록이나 수식 목록을 바꾸지 않는다. 바꾸는 것은 매개변수의 값이나 제어 시퀀스의 뜻이다.

표 |eqtb|의 값을 대입할 때는 전역으로 할 수도, 지역으로 할 수도 있다. 게다가 제어 시퀀스를 `\.{\\long}'이나 `\.{\\outer}'로 정의할 수도
있고, 정의를 펼칠 수도 펼치지 않을 수도 있다. 접두어 `\.{\\global}', `\.{\\long}', `\.{\\outer}'는 어떤 차례로든 나타날 수 있다. 그래서
접두어마다 2의 거듭제곱인 코드를 주어, 나온 접두어들의 코드를 더하기만 하면 그 합집합을 나타낼 수 있게 했다. (언어에 집합 형이 있다면
그것을 써도 되었을 것이다.)

@<\TeX의 원시 명령을...@>=
primitive("long", prefix, 1)
@!@:long_}{\.{\\long} primitive@>
primitive("outer", prefix, 2)
@!@:outer_}{\.{\\outer} primitive@>
primitive("global", prefix, 4)
@!@:global_}{\.{\\global} primitive@>
primitive("def", def, 0)
@!@:def_}{\.{\\def} primitive@>
primitive("gdef", def, 1)
@!@:gdef_}{\.{\\gdef} primitive@>
primitive("edef", def, 2)
@!@:edef_}{\.{\\edef} primitive@>
primitive("xdef", def, 3)
@!@:xdef_}{\.{\\xdef} primitive@>

@ 이 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case prefix:
	if chrCode == 1 {
		printEsc("long")
	} else if chrCode == 2 {
		printEsc("outer")
	} else {
		printEsc("global")
	}
case def:
	if chrCode == 0 {
		printEsc("def")
	} else if chrCode == 1 {
		printEsc("gdef")
	} else if chrCode == 2 {
		printEsc("edef")
	} else {
		printEsc("xdef")
	}

@ 접두어와, 접두어가 붙을 수 있는 모든 명령은 동작 프로시저 |prefixedCommand|를 부른다. 이 루틴은 접두어 아닌 것에 이를 때까지 접두어를
모은 다음 그 명령을 수행한다.

@<|mode|에 상관없는...@>=
case vmode + toksRegister, hmode + toksRegister, mmode + toksRegister,
	vmode + assignToks, hmode + assignToks, mmode + assignToks,
	vmode + assignInt, hmode + assignInt, mmode + assignInt,
	vmode + assignDimen, hmode + assignDimen, mmode + assignDimen,
	vmode + assignGlue, hmode + assignGlue, mmode + assignGlue,
	vmode + assignMuGlue, hmode + assignMuGlue, mmode + assignMuGlue,
	vmode + assignFontDimen, hmode + assignFontDimen, mmode + assignFontDimen,
	vmode + assignFontInt, hmode + assignFontInt, mmode + assignFontInt,
	vmode + setAux, hmode + setAux, mmode + setAux,
	vmode + setPrevGraf, hmode + setPrevGraf, mmode + setPrevGraf,
	vmode + setPageDimen, hmode + setPageDimen, mmode + setPageDimen,
	vmode + setPageInt, hmode + setPageInt, mmode + setPageInt,
	vmode + setBoxDimen, hmode + setBoxDimen, mmode + setBoxDimen,
	vmode + setShape, hmode + setShape, mmode + setShape,
	vmode + defCode, hmode + defCode, mmode + defCode,
	vmode + defFamily, hmode + defFamily, mmode + defFamily,
	vmode + setFont, hmode + setFont, mmode + setFont,
	vmode + defFont, hmode + defFont, mmode + defFont,
	vmode + register, hmode + register, mmode + register,
	vmode + advance, hmode + advance, mmode + advance,
	vmode + multiply, hmode + multiply, mmode + multiply,
	vmode + divide, hmode + divide, mmode + divide,
	vmode + prefix, hmode + prefix, mmode + prefix,
	vmode + let, hmode + let, mmode + let,
	vmode + shorthandDef, hmode + shorthandDef, mmode + shorthandDef,
	vmode + readToCs, hmode + readToCs, mmode + readToCs,
	vmode + def, hmode + def, mmode + def,
	vmode + setBox, hmode + setBox, mmode + setBox,
	vmode + hyphData, hmode + hyphData, mmode + hyphData,
	vmode + setInteraction, hmode + setInteraction, mmode + setInteraction:
	prefixedCommand()

@ 사용자가 이를테면 `\.{\\global\\global}'이라고 하면 그 중복은 조용히 받아들인다. 접두어를 다 모으고 나면, 쓸모없는 접두어를 걸러 내고
\.{\\globaldefs}에 맞추어 전역 여부를 고친 다음, 명령의 종류에 따라 대입을 한다. 대입이 끝나면 \.{\\afterassignment}로 맡겨 둔 토큰이
있는지 본다.

@<|mainControl|이 쓰는 동작...@>=
@<|prefixedCommand|의 하위 프로시저들@>@;
func prefixedCommand() {
	var a smallNumber // 지금까지 쌓은 접두어 코드
	var f internalFontNumber // 글꼴을 가리킨다
	var j halfword // \.{\\parshape} 지정의 첨자
	var k fontIndex // |fontInfo|의 첨자
	var p, q pointer // 잠깐 쓰는 변수
	var n int32 // 마찬가지
	var e bool // 정의를 펼쳐야 하는가? 또는 \.{\\let}을 하지 않았는가?
	a = 0
	for curCmd == prefix {
		if !odd(a / curChr) {
			a += curChr
		}
		@<공백도 relax도 호출도...@>
		if curCmd <= maxNonPrefixedCommand {
			@<잘못된 접두어를 버리고 |return|한다@>
		}
	}
	@<쓸모없으면 접두어 \.{\\long}과 \.{\\outer}를 버린다@>
	@<\.{\\globaldefs} 설정에 맞춘다@>
	switch curCmd {
	@<대입들@>
	default: confusion("prefix")
@:this can't happen prefix}{\quad prefix@>
	}
done:
	@<\.{\\afterassignment}가 저장한 토큰이 있으면 끼워 넣는다@>
}

@ 접두어 뒤에 접두어를 붙일 수 없는 명령이 오면, 접두어를 버리고 그 명령을 다시 읽게 한다.
@<잘못된 접두어를...@>=
printErr("You can't use a prefix with `")
@.You can't use a prefix with x@>
printCmdChr(curCmd, curChr); printChar('\'')
help1("I'll pretend you didn't say \\long or \\outer or \\global.")
backError(); return

@ 명령 \.{\\long}과 \.{\\outer}는 \.{\\def} 계열 앞에서만 뜻이 있다. 다른 명령 앞에 오면 알리고 무시한다.
@<쓸모없으면 접두어...@>=
if curCmd != def && a%4 != 0 {
	printErr("You can't use `"); printEsc("long"); printStr("' or `")
	printEsc("outer"); printStr("' with `")
@.You can't use \\long...@>
	printCmdChr(curCmd, curChr); printChar('\'')
	help1("I'll pretend you didn't say \\long or \\outer here.")
	reportError()
}

@ 앞 루틴은 |a%4==0|이 되도록 |a|를 맞출 필요가 없다. 다음 루틴들은 \.{\\global} 접두어를 이렇게 검사하기 때문이다.

접두어를 살피는 작은 함수 |global|, |define|, |wordDefine|은 부르는 쪽의 지역 변수 |a|를 써야 한다. 이 함수들은 |prefixedCommand|와
|doRegisterCommand| 두 곳에서 쓰이므로 |a|를 첫 인자로 받는다.

@<정의@>=
func global(a smallNumber) bool { return a >= 4 }

func define(a smallNumber, p pointer, t quarterword, e halfword) {
	if global(a) { geqDefine(p, t, e) } else { eqDefine(p, t, e) }
}

func wordDefine(a smallNumber, p pointer, w int32) {
	if global(a) { geqWordDefine(p, w) } else { eqWordDefine(p, w) }
}

@ 매개변수 \.{\\globaldefs}가 양수이면 모든 대입을 전역으로, 음수이면 모든 대입을 지역으로 한다. 0이면 접두어대로 한다.
@<\.{\\globaldefs} 설정에...@>=
if globalDefs() != 0 {
	if globalDefs() < 0 {
		if global(a) {
			a -= 4
		}
	} else if !global(a) {
		a += 4
	}
}

@ 명령 \.{\\def}나 \.{\\let} 같은 것으로 제어 시퀀스를 정의할 때 루틴 |getRToken|은 정의할 이름을 읽는다. 공백은 건너뛴다. 다시 정의할
수 없는 토큰, 곧 문자 토큰이나 얼린 제어 시퀀스가 오면 알리고, 그 대신 특별한 제어 시퀀스 \.{\\inaccessible}을 넣는다.

@<|prefixedCommand|의 하위...@>=
func getRToken() {
restart:
	for {
		getToken()
		if curTok != spaceToken {
			break
		}
	}
	if curCs == 0 || curCs > frozenControlSequence {
		printErr("Missing control sequence inserted")
@.Missing control...@>
		help5("Please don't say `\\def cs{...}', say `\\def\\cs{...}'.",
			"I've inserted an inaccessible control sequence so that your",
			"definition will be completed without mixing me up too badly.",
			"You can recover graciously from this error, if you're",
			"careful; see exercise 27.2 in The TeXbook.")
@:TeXbook}{\sl The \TeX book@>
		if curCs == 0 {
			backInput()
		}
		curTok = csTokenFlag + frozenProtection; insError(); goto restart
	}
}

@ 그 특별한 제어 시퀀스의 이름은 이렇다.
@<표의 항목들을 초기화한다...@>=
setText(frozenProtection, str("inaccessible"))
@.inaccessible@>

@ 다음은 뒤따르는 루틴 대부분이 일하는 방식의 한 보기다. (안타깝게도 모두 이렇게 단순하지는 않다.)

@<대입들@>=
case setFont: define(a, curFontLoc, data, curChr)

@ 명령 |def|를 훑었을 때 |curChr|가 홀수이면 정의는 전역이어야 하고, |curChr>=2|이면 정의를 펼쳐야 한다. 곧 \.{\\gdef}는 1,
\.{\\edef}는 2, \.{\\xdef}는 3이다. 접두어 \.{\\long}과 \.{\\outer}의 코드 |a%4|를 |call|에 더하면 매크로의 명령 코드가 된다.

@<대입들@>=
case def:
	if odd(curChr) && !global(a) && globalDefs() >= 0 {
		a += 4
	}
	e = curChr >= 2; getRToken(); p = curCs
	q = scanToks(true, e); define(a, p, call+(a%4), defRef)

@ 명령 \.{\\let}과 \.{\\futurelet}은 명령 코드 |let|을 함께 쓴다.

@<\TeX의 원시 명령을...@>=
primitive("let", let, normal)
@!@:let_}{\.{\\let} primitive@>
primitive("futurelet", let, normal+1)
@!@:future_let_}{\.{\\futurelet} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case let:
	if chrCode != normal { printEsc("futurelet") } else { printEsc("let") }

@ 명령 \.{\\let}은 등호(와 그 뒤의 공백 하나)를 건너뛰고 다음 토큰의 뜻을 그대로 베낀다. 명령 \.{\\futurelet}$\,cs\,t_1t_2$는 $t_2$의
뜻을 $cs$에 주되, $t_1t_2$는 읽지 않은 것처럼 입력에 되돌려 놓는다. 앞을 내다본 다음 뒤로 물러서는 셈이다.
@<대입들@>=
case let:
	n = curChr
	getRToken(); p = curCs
	if n == normal {
		for {
			getToken()
			if curCmd != spacer {
				break
			}
		}
		if curTok == otherToken+'=' {
			getToken()
			if curCmd == spacer {
				getToken()
			}
		}
	} else {
		getToken(); q = curTok; getToken(); backInput()
		curTok = q; backInput() // 앞을 내다본 다음 뒤로 물러선다
	} // |backInput|은 |curCmd|, |curChr|에 영향을 주지 않는다는 것에 주의하라
	if curCmd >= call {
		addTokenRef(curChr)
	}
	define(a, p, curCmd, curChr)

@ 명령 \.{\\chardef}는 |cmd|가 |charGiven|인 제어 시퀀스를 만들고, \.{\\mathchardef}는 |cmd|가 |mathGiven|인 제어 시퀀스를 만든다.
그 |chr|는 문자 코드나 수식 코드다. 명령 \.{\\countdef}, \.{\\dimendef}, \.{\\skipdef}, \.{\\muskipdef}는 |cmd|가 |assignInt|부터
|assignMuGlue|까지 가운데 하나인 제어 시퀀스를 만들고, 그 |chr|는 해당 레지스터의 |eqtb| 위치다.

@<정의@>=
const (
	@!charDefCode = iota // \.{\\chardef}의 |shorthandDef|
	@!mathCharDefCode // \.{\\mathchardef}의 |shorthandDef|
	@!countDefCode // \.{\\countdef}의 |shorthandDef|
	@!dimenDefCode // \.{\\dimendef}의 |shorthandDef|
	@!skipDefCode // \.{\\skipdef}의 |shorthandDef|
	@!muSkipDefCode // \.{\\muskipdef}의 |shorthandDef|
	@!toksDefCode // \.{\\toksdef}의 |shorthandDef|
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("chardef", shorthandDef, charDefCode)
@!@:char_def_}{\.{\\chardef} primitive@>
primitive("mathchardef", shorthandDef, mathCharDefCode)
@!@:math_char_def_}{\.{\\mathchardef} primitive@>
primitive("countdef", shorthandDef, countDefCode)
@!@:count_def_}{\.{\\countdef} primitive@>
primitive("dimendef", shorthandDef, dimenDefCode)
@!@:dimen_def_}{\.{\\dimendef} primitive@>
primitive("skipdef", shorthandDef, skipDefCode)
@!@:skip_def_}{\.{\\skipdef} primitive@>
primitive("muskipdef", shorthandDef, muSkipDefCode)
@!@:mu_skip_def_}{\.{\\muskipdef} primitive@>
primitive("toksdef", shorthandDef, toksDefCode)
@!@:toks_def_}{\.{\\toksdef} primitive@>

@ 이 명령들의 이름을 찍는다. 명령 \.{\\chardef}로 만든 제어 시퀀스는 `\.{\\char"41}'처럼 그 값을 16진수로 함께 찍는다.
@<원시 명령의 이름을 찍는...@>=
case shorthandDef:
	switch chrCode {
	case charDefCode: printEsc("chardef")
	case mathCharDefCode: printEsc("mathchardef")
	case countDefCode: printEsc("countdef")
	case dimenDefCode: printEsc("dimendef")
	case skipDefCode: printEsc("skipdef")
	case muSkipDefCode: printEsc("muskipdef")
	default: printEsc("toksdef")
	}
case charGiven: printEsc("char"); printHex(chrCode)
case mathGiven: printEsc("mathchar"); printHex(chrCode)

@ 정의할 제어 시퀀스 |p|를 잠깐 |relax|로 정의해 둔다. 그러면 정의를 훑는 동안 |p|가 나타나도 ``정의되지 않은 제어 시퀀스'' 오류를
내거나 이전 뜻을 펼치지 않고, 그냥 훑기를 멈춘다. 그래서 이를테면 `\.{\\chardef\\foo=123\\foo}'라고 써도 된다.

@<대입들@>=
case shorthandDef:
	n = curChr; getRToken(); p = curCs; define(a, p, relax, 256)
	scanOptionalEquals()
	switch n {
	case charDefCode: scanCharNum(); define(a, p, charGiven, curVal)
	case mathCharDefCode: scanFifteenBitInt(); define(a, p, mathGiven, curVal)
	default:
		scanEightBitInt()
		switch n {
		case countDefCode: define(a, p, assignInt, countBase+curVal)
		case dimenDefCode: define(a, p, assignDimen, scaledBase+curVal)
		case skipDefCode: define(a, p, assignGlue, skipBase+curVal)
		case muSkipDefCode: define(a, p, assignMuGlue, muSkipBase+curVal)
		case toksDefCode: define(a, p, assignToks, toksBase+curVal)
		} // 다른 경우는 없다
	}

@ 명령 \.{\\read}$\,n$ \.{to}$\,cs$는 입력 줄 하나를 읽어 매크로로 정의한다. 실제로 읽는 일은 |readToks|가 한다.
@<대입들@>=
case readToCs:
	scanInt(); n = curVal
	if !scanKeyword("to") {
@.to@>
		printErr("Missing `to' inserted")
@.Missing `to'...@>
		help2("You should have said `\\read<number> to \\cs'.",
			"I'm going to look for the \\cs now.")
		reportError()
	}
	getRToken()
	p = curCs; readToks(n, p); define(a, p, call, curVal)

@ 토큰 목록 매개변수 \.{\\output}과 \.{\\everypar} 따위는 다음 방식으로 값을 받는다. 빈 목록을 주면 정의되지 않은 상태로 돌아간다.
(안전을 위해 \.{\\output} 목록은 중괄호 한 쌍으로 둘러싼다.)

@<대입들@>=
case toksRegister, assignToks:
	q = curCs
	if curCmd == toksRegister {
		scanEightBitInt(); p = toksBase + curVal
	} else {
		p = curChr // |p=everyParLoc|이나 |outputRoutineLoc|이나 \dots
	}
	scanOptionalEquals()
	@<공백도 relax도 호출도...@>
	if curCmd != leftBrace {
		@<오른쪽 변이 토큰 매개변수나 토큰 레지스터이면 대입을 마치고 |goto done|@>
	}
	backInput(); curCs = q; q = scanToks(false, false)
	if link(defRef) == null { // 빈 목록: 기본값으로 돌아간다
		define(a, p, undefinedCs, null); freeAvail(defRef)
	} else {
		if p == outputRoutineLoc { // 중괄호로 둘러싼다
			setLink(q, getAvail()); q = link(q)
			setInfo(q, rightBraceToken+'}')
			q = getAvail(); setInfo(q, leftBraceToken+'{')
			setLink(q, link(defRef)); setLink(defRef, q)
		}
		define(a, p, call, defRef)
	}

@ 등호 오른쪽에 중괄호 대신 다른 토큰 목록 매개변수나 토큰 레지스터가 올 수도 있다. 그때는 그 목록을 베끼지 않고 참조 횟수만
늘려서 함께 쓴다.
@<오른쪽 변이 토큰 매개변수나...@>=
if curCmd == toksRegister {
	scanEightBitInt(); curCmd = assignToks; curChr = toksBase + curVal
}
if curCmd == assignToks {
	q = equiv(curChr)
	if q == null {
		define(a, p, undefinedCs, null)
	} else {
		addTokenRef(q); define(a, p, call, q)
	}
	goto done
}

@ 수치 매개변수에 값을 대입할 때도 비슷한 루틴을 쓴다.

@<대입들@>=
case assignInt:
	p = curChr; scanOptionalEquals(); scanInt()
	wordDefine(a, p, curVal)
case assignDimen:
	p = curChr; scanOptionalEquals()
	scanNormalDimen(); wordDefine(a, p, curVal)
case assignGlue, assignMuGlue:
	p = curChr; n = curCmd; scanOptionalEquals()
	if n == assignMuGlue { scanGlue(muVal) } else { scanGlue(glueVal) }
	trapZeroGlue()
	define(a, p, glueRef, curVal)

@ 글루 레지스터나 매개변수가 0이 되면, 다음 프로시저 때문에 늘 |zeroGlue|를 가리키게 된다. 그러면 메모리를 아낄 수 있다.
(예외: 서문을 훑는 동안에는 tabskip 글루를 가로채지 않는다.)

@<|prefixedCommand|의 하위...@>=
func trapZeroGlue() {
	if width(curVal) == 0 && stretch(curVal) == 0 && shrink(curVal) == 0 {
		addGlueRef(zeroGlue)
		deleteGlueRef(curVal); curVal = zeroGlue
	}
}

@ 여러 문자 코드 표는 |defCode| 명령으로 바꾸고, 글꼴 묶음은 |defFamily| 명령으로 선언한다.

@<\TeX의 원시 명령을...@>=
primitive("catcode", defCode, catCodeBase)
@!@:cat_code_}{\.{\\catcode} primitive@>
primitive("mathcode", defCode, mathCodeBase)
@!@:math_code_}{\.{\\mathcode} primitive@>
primitive("lccode", defCode, lcCodeBase)
@!@:lc_code_}{\.{\\lccode} primitive@>
primitive("uccode", defCode, ucCodeBase)
@!@:uc_code_}{\.{\\uccode} primitive@>
primitive("sfcode", defCode, sfCodeBase)
@!@:sf_code_}{\.{\\sfcode} primitive@>
primitive("delcode", defCode, delCodeBase)
@!@:del_code_}{\.{\\delcode} primitive@>
primitive("textfont", defFamily, mathFontBase)
@!@:text_font_}{\.{\\textfont} primitive@>
primitive("scriptfont", defFamily, mathFontBase+scriptSize)
@!@:script_font_}{\.{\\scriptfont} primitive@>
primitive("scriptscriptfont", defFamily, mathFontBase+scriptScriptSize)
@!@:script_script_font_}{\.{\\scriptscriptfont} primitive@>

@ 이 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case defCode:
	if chrCode == catCodeBase {
		printEsc("catcode")
	} else if chrCode == mathCodeBase {
		printEsc("mathcode")
	} else if chrCode == lcCodeBase {
		printEsc("lccode")
	} else if chrCode == ucCodeBase {
		printEsc("uccode")
	} else if chrCode == sfCodeBase {
		printEsc("sfcode")
	} else {
		printEsc("delcode")
	}
case defFamily: printSize(chrCode - mathFontBase)

@ 코드 값의 종류마다 허락되는 범위가 다르다. 다음 프로그램은 각 경우를 조심스럽게 검사한다. 구분자 코드만은 음수도 허락한다.

@<대입들@>=
case defCode:
	@<|curChr|에 따라 |n|을 가장 큰 합법적인 코드 값으로 한다@>
	p = curChr; scanCharNum(); p += curVal; scanOptionalEquals()
	scanInt()
	if (curVal < 0 && p < delCodeBase) || curVal > n {
		printErr("Invalid code ("); printInt(curVal)
@.Invalid code@>
		if p < delCodeBase {
			printStr("), should be in the range 0..")
		} else {
			printStr("), should be at most ")
		}
		printInt(n)
		help1("I'm going to use 0 instead of that illegal code value.")
		reportError(); curVal = 0
	}
	if p < mathCodeBase {
		define(a, p, data, curVal)
	} else if p < delCodeBase {
		define(a, p, data, hi(curVal))
	} else {
		wordDefine(a, p, curVal)
	}

@ 범주 코드는 |maxCharCode|(15)까지, 수식 코드는 |0o100000|까지, 공백 인자 코드는 |0o77777|까지, 구분자 코드는 |0o77777777|까지 쓸 수 있다.
대소문자 코드는 255까지다.
@<|curChr|에 따라 |n|을...@>=
if curChr == catCodeBase {
	n = maxCharCode
} else if curChr == mathCodeBase {
	n = 0o100000
} else if curChr == sfCodeBase {
	n = 0o77777
} else if curChr == delCodeBase {
	n = 0o77777777
} else {
	n = 255
}

@ 명령 \.{\\textfont}, \.{\\scriptfont}, \.{\\scriptscriptfont}는 글꼴 묶음 번호와 글꼴을 읽어 정의한다.
@<대입들@>=
case defFamily:
	p = curChr; scanFourBitInt(); p += curVal
	scanOptionalEquals(); scanFontIdent(); define(a, p, data, curVal)

@ 다음으로 \TeX의 수치 레지스터를 바꾸는 일을 생각하자.

@<대입들@>=
case register, advance, multiply, divide: doRegisterCommand(a)

@ 여기서는 |register<advance<multiply<divide|라는 사실을 이용한다. 결과가 범위를 넘치면 아무것도 바꾸지 않고 알린다.

@<|prefixedCommand|의 하위...@>=
func doRegisterCommand(a smallNumber) {
	var l, q, r, s pointer // 목록을 다루는 데 쓴다
	var p int32 // 관련된 레지스터의 형; |intVal..muVal|
	q = curCmd
	@<레지스터 위치 |l|과 그 형 |p|를 계산하되, 무효하면 |return|한다@>
	if q == register {
		scanOptionalEquals()
	} else if scanKeyword("by") {
		// 선택적인 `\.{by}'
	}
@.by@>
	arithError = false
	if q < multiply {
		@<|register|나 |advance|의 결과를 계산해 |curVal|에 넣는다@>
	} else {
		@<|multiply|나 |divide|의 결과를 계산해 |curVal|에 넣는다@>
	}
	if arithError {
		printErr("Arithmetic overflow")
@.Arithmetic overflow@>
		help2("I can't carry out that multiplication or division,",
			"since the result is out of range.")
		if p >= glueVal {
			deleteGlueRef(curVal)
		}
		reportError(); return
	}
	if p < glueVal {
		wordDefine(a, l, curVal)
	} else {
		trapZeroGlue(); define(a, l, glueRef, curVal)
	}
}

@ 여기서는 연속된 코드 |intVal..muVal|과 |assignInt..assignMuGlue|가 서로 잘 대응한다는 사실을 이용한다. 명령 \.{\\advance} 따위
뒤에는 레지스터만이 아니라 \.{\\parindent} 같은 매개변수도 올 수 있다.

@<레지스터 위치 |l|과 그 형 |p|를...@>=
if q != register {
	getXToken()
	if curCmd >= assignInt && curCmd <= assignMuGlue {
		l = curChr; p = curCmd - assignInt; goto found
	}
	if curCmd != register {
		printErr("You can't use `"); printCmdChr(curCmd, curChr)
@.You can't use x after ...@>
		printStr("' after "); printCmdChr(q, 0)
		help1("I'm forgetting what you said and not changing anything.")
		reportError(); return
	}
}
p = curChr; scanEightBitInt()
switch p {
case intVal: l = curVal + countBase
case dimenVal: l = curVal + scaledBase
case glueVal: l = curVal + skipBase
case muVal: l = curVal + muSkipBase
} // 다른 경우는 없다
found:

@ 명령 \.{\\count} 따위의 대입과 \.{\\advance}의 결과를 계산한다.
@<|register|나 |advance|의 결과를...@>=
if p < glueVal {
	if p == intVal { scanInt() } else { scanNormalDimen() }
	if q == advance {
		curVal += eqtb[l].sc
	}
} else {
	scanGlue(p)
	if q == advance {
		@<두 글루 명세의 합을 계산한다@>
	}
}

@ 두 글루를 더할 때 늘이기와 줄이기는 차수가 같으면 더하고, 다르면 높은 차수의 것을 남긴다. 다만 0인 성분의 차수는 따지지 않는다.
@<두 글루 명세의 합을...@>=
q = newSpec(curVal); r = equiv(l)
deleteGlueRef(curVal)
setWidth(q, width(q)+width(r))
if stretch(q) == 0 {
	setStretchOrder(q, normal)
}
if stretchOrder(q) == stretchOrder(r) {
	setStretch(q, stretch(q)+stretch(r))
} else if stretchOrder(q) < stretchOrder(r) && stretch(r) != 0 {
	setStretch(q, stretch(r)); setStretchOrder(q, stretchOrder(r))
}
if shrink(q) == 0 {
	setShrinkOrder(q, normal)
}
if shrinkOrder(q) == shrinkOrder(r) {
	setShrink(q, shrink(q)+shrink(r))
} else if shrinkOrder(q) < shrinkOrder(r) && shrink(r) != 0 {
	setShrink(q, shrink(r)); setShrinkOrder(q, shrinkOrder(r))
}
curVal = q

@ 명령 \.{\\multiply}와 \.{\\divide}는 정수를 인자로 받는다. 글루이면 각 성분에 그 정수를 곱하거나 나눈다.
@<|multiply|나 |divide|의 결과를...@>=
scanInt()
if p < glueVal {
	if q == multiply {
		if p == intVal {
			curVal = multIntegers(eqtb[l].sc, curVal)
		} else {
			curVal = nxPlusY(eqtb[l].sc, curVal, 0)
		}
	} else {
		curVal = xOverN(eqtb[l].sc, curVal)
	}
} else {
	s = equiv(l); r = newSpec(s)
	if q == multiply {
		setWidth(r, nxPlusY(width(s), curVal, 0))
		setStretch(r, nxPlusY(stretch(s), curVal, 0))
		setShrink(r, nxPlusY(shrink(s), curVal, 0))
	} else {
		setWidth(r, xOverN(width(s), curVal))
		setStretch(r, xOverN(stretch(s), curVal))
		setShrink(r, xOverN(shrink(s), curVal))
	}
	curVal = r
}

@ 상자는 조금 다르게 처리한다. 옛 상자의 값을 실제로 바꾸기 전에 새 상자 전체를 훑어서 만들어야 할 수도 있기 때문이다.

@<대입들@>=
case setBox:
	scanEightBitInt()
	if global(a) { n = 256 + curVal } else { n = curVal }
	scanOptionalEquals()
	if setBoxAllowed {
		scanBox(boxFlag + n)
	} else {
		printErr("Improper "); printEsc("setbox")
@.Improper \\setbox@>
		help2("Sorry, \\setbox is not allowed after \\halign in a display,",
			"or between \\accent and an accented character.")
		reportError()
	}

@ 명령 |setAux|를 만나면 |spaceFactor|나 |prevDepth| 설정이 바뀐다. 마찬가지로 |setPrevGraf|가 있으면 |prevGraf|가 바뀌고,
|setPageInt|가 있으면 |deadCycles|나 |insertPenalties|가 바뀐다. 이 정의들은 늘 전역이다.

상자 레지스터의 치수를 바꾸는 것은 꼭 전역은 아니다. 그러나 \TeX은 이때 \.{\\global} 스위치를 보지 않는다.

@<대입들@>=
case setAux: alterAux()
case setPrevGraf: alterPrevGraf()
case setPageDimen: alterPageSoFar()
case setPageInt: alterInteger()
case setBoxDimen: alterBoxDimen()

@ 매개변수 \.{\\spacefactor}는 가로 모드에서만, \.{\\prevdepth}는 세로 모드에서만 쓸 수 있다. 공백 인자는 1부터 32767까지여야 한다.
@<|prefixedCommand|의 하위...@>=
func alterAux() {
	var c halfword // |hmode|나 |vmode|
	if curChr != abs(mode) {
		reportIllegalCase()
	} else {
		c = curChr; scanOptionalEquals()
		if c == vmode {
			scanNormalDimen(); setPrevDepth(curVal)
		} else {
			scanInt()
			if curVal <= 0 || curVal > 32767 {
				printErr("Bad space factor")
@.Bad space factor@>
				help1("I allow only values in the range 1..32767 here.")
				intError(curVal)
			} else {
				setSpaceFactor(curVal)
			}
		}
	}
}

@ 매개변수 \.{\\prevgraf}를 바꾸면 둥지에서 가장 가까운 세로 모드 수준의 값이 바뀐다. 그 값이 바로 지금 만드는 문단의 줄 수를 다스리기
때문이다.
@<|prefixedCommand|의 하위...@>=
func alterPrevGraf() {
	nest[nestPtr] = curList(); p := nestPtr // |nest|의 첨자; |0 .. nestSize|
	for abs(nest[p].modeField) != vmode {
		p--
	}
	scanOptionalEquals(); scanInt()
	if curVal < 0 {
		printErr("Bad "); printEsc("prevgraf")
@.Bad \\prevgraf@>
		help1("I allow only nonnegative values here.")
		intError(curVal)
	} else {
		nest[p].pgField = curVal; setCurList(nest[nestPtr])
	}
}

@ 명령 \.{\\pagegoal}이나 \.{\\pagetotal} 따위는 |pageSoFar| 배열의 해당 항목을 바꾼다.
@<|prefixedCommand|의 하위...@>=
func alterPageSoFar() {
	c := curChr // |pageSoFar|의 첨자; |0..7|
	scanOptionalEquals(); scanNormalDimen()
	pageSoFar[c] = curVal
}

@ 명령 \.{\\deadcycles}와 \.{\\insertpenalties}를 바꾼다.
@<|prefixedCommand|의 하위...@>=
func alterInteger() {
	c := curChr // \.{\\deadcycles}이면 0, \.{\\insertpenalties}이면 1
	scanOptionalEquals(); scanInt()
	if c == 0 {
		deadCycles = curVal
	} else {
		insertPenalties = curVal
	}
}

@ 명령 \.{\\wd}, \.{\\ht}, \.{\\dp}는 상자의 치수를 바꾼다. 빈 레지스터이면 아무 일도 하지 않는다.
@<|prefixedCommand|의 하위...@>=
func alterBoxDimen() {
	var b eightBits // 상자 번호
	c := curChr // |widthOffset|나 |heightOffset|나 |depthOffset|
	scanEightBitInt(); b = curVal; scanOptionalEquals()
	scanNormalDimen()
	if box(b) != null {
		mem[box(b)+c].sc = curVal
	}
}

@ 문단 모양은 뻔한 방식으로 마련한다. 줄 수 $n$을 읽고, 줄마다 들여쓰기와 너비를 읽어 노드 하나에 담는다.

@<대입들@>=
case setShape:
	scanOptionalEquals(); scanInt(); n = curVal
	if n <= 0 {
		p = null
	} else {
		p = getNode(2*n + 1); setInfo(p, n)
		for j = 1; j <= n; j++ {
			scanNormalDimen()
			mem[p+2*j-1].sc = curVal // 들여쓰기
			scanNormalDimen()
			mem[p+2*j].sc = curVal // 너비
		}
	}
	define(a, parShapeLoc, shapeRef, p)

@ 다음은 그리 뻔하지 않다. 이 검사는 |getNode(2*n+1)|이 메모리 용량을 넘치지 않는 양수~|n|이라면 모두 |info(parShapePtr)|에 담을 수
있도록 보장한다.

@<``상수'' 값들이...@>=
if 2*maxHalfword < memTop-memMin {
	bad = 41
}

@ 새 하이픈 넣기 자료는 |hyphData| 명령으로 불러온다.

@<\TeX의 원시 명령을...@>=
primitive("hyphenation", hyphData, 0)
@!@:hyphenation_}{\.{\\hyphenation} primitive@>
primitive("patterns", hyphData, 1)
@!@:patterns_}{\.{\\patterns} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case hyphData:
	if chrCode == 1 { printEsc("patterns") } else { printEsc("hyphenation") }

@ 하이픈 넣기 패턴은 \.{INITEX}에서만 읽을 수 있다. 다른 판에서는 알리고 그 그룹을 건너뛴다. 예외 낱말은 언제든 보탤 수 있다.
@<대입들@>=
case hyphData:
	if curChr == 1 {
		if iniVersion {
			newPatterns(); goto done
		}
		printErr("Patterns can be loaded only by INITEX")
@.Patterns can be...@>
		help0(); reportError()
		for {
			getToken()
			if curCmd == rightBrace {
				break
			}
		} // 패턴을 버린다
		return
	} else {
		newHyphExceptions(); goto done
	}

@ 글꼴 정보, 대화 모드, 하이픈 넣기 표만 빼고 \TeX의 모든 매개변수는 |eqtb|에 있다. 이 셋은 언제나 전역이다.

@<대입들@>=
case assignFontDimen:
	findFontDimen(true); k = curVal
	scanOptionalEquals(); scanNormalDimen(); fontInfo[k].sc = curVal
case assignFontInt:
	n = curChr; scanFontIdent(); f = curVal
	scanOptionalEquals(); scanInt()
	if n == 0 { hyphenChar[f] = curVal } else { skewChar[f] = curVal }

@ 글꼴마다 따로 정해 두는 정수 두 가지는 \.{\\hyphenchar}와 \.{\\skewchar}다.
@<\TeX의 원시 명령을...@>=
primitive("hyphenchar", assignFontInt, 0)
@!@:hyphen_char_}{\.{\\hyphenchar} primitive@>
primitive("skewchar", assignFontInt, 1)
@!@:skew_char_}{\.{\\skewchar} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case assignFontInt:
	if chrCode == 0 { printEsc("hyphenchar") } else { printEsc("skewchar") }

@ 다음은 새 글꼴의 정보를 불러들이는 곳이다.

@<대입들@>=
case defFont: newFont(a)

@ 프로시저 |newFont|는 `\.{\\font\\cs=}' 뒤에 파일 이름과 크기 지정이 오는 꼴을 처리한다. 먼저 사용자의 글꼴 식별자 |u|를 읽고, 그 글꼴을 나중에
찍을 때 쓸 이름 |t|를 정한다. 식별자를 미리 |nullFont|로 정의해 두는 것은, 크기 지정을 읽는 동안 이 식별자가 나타나도 이전 뜻이 쓰이지
않게 하려는 것이다. 같은 글꼴을 이미 불러왔으면 그것을 다시 쓰고, 그렇지 않으면 |readFontInfo|로 \.{TFM} 파일을 읽는다.
@<|prefixedCommand|의 하위...@>=
func newFont(a smallNumber) {
	var u pointer // 사용자의 글꼴 식별자
	var s scaled // 지정된 ``at'' 크기, 또는 배율에 음의 부호를 붙인 것
	var f internalFontNumber // 기존 글꼴들을 훑는다
	var t strNumber // 얼린 글꼴 식별자의 이름
	var oldSetting int32 // |selector| 설정을 담아 둔다; |0 .. maxSelector|
	var flushableString strNumber // 아직 참조되지 않은 문자열
	if jobName == 0 {
		openLogFile() // \.{texput}을 글꼴 이름과 헷갈리지 않게 한다
	}
@.texput@>
	getRToken(); u = curCs
	if u >= hashBase {
		t = text(u)
	} else if u >= singleBase {
		if u == nullCs { t = str("FONT") } else { t = u - singleBase }
	} else {
		oldSetting = selector; selector = newString
		printStr("FONT"); printStr(u - activeBase); selector = oldSetting
@.FONTx@>
		strRoom(1); t = makeString()
	}
	define(a, u, setFont, nullFont); scanOptionalEquals(); scanFileName()
	@<글꼴 크기 지정을 훑는다@>
	@<이 글꼴을 이미 불러왔으면 |f|를 내부 글꼴 번호로 하고 |goto commonEnding|@>
	f = readFontInfo(u, curName, curArea, s)
commonEnding:
	setEquiv(u, f); eqtb[fontIDBase+f] = eqtb[u]; setFontIDText(f, t)
}

@ 크기 지정은 `\.{at}' 뒤에 치수가 오거나, `\.{scaled}' 뒤에 정수가 오거나, 아예 없다. 변수 |s|가 양수이면 `at' 크기이고, 음수이면 배율의 음수이며, 없으면
$-1000$이다. 배율은 1부터 32768까지여야 한다.
@<글꼴 크기 지정을...@>=
nameInProgress = true // 이것은 |curName|이 바뀌지 않게 한다
if scanKeyword("at") {
	@<(양수인) `at' 크기를 |s|에 넣는다@>
@.at@>
} else if scanKeyword("scaled") {
@.scaled@>
	scanInt(); s = -curVal
	if curVal <= 0 || curVal > 32768 {
		printErr("Illegal magnification has been changed to 1000")
@.Illegal magnification...@>
		help1("The magnification ratio must be between 1 and 32768.")
		intError(curVal); s = -1000
	}
} else {
	s = -1000
}
nameInProgress = false

@ 글꼴의 `at' 크기는 양수이고 2048pt보다 작아야 한다. 그렇지 않으면 10pt로 바꾼다.
@<(양수인) `at' 크기를...@>=
scanNormalDimen(); s = curVal
if s <= 0 || s >= 0o1000000000 {
	printErr("Improper `at' size (")
	printScaled(s); printStr("pt), replaced by 10pt")
@.Improper `at' size...@>
	help2("I can only handle fonts at positive sizes that are",
		"less than 2048pt, so I've changed what you said to 10pt.")
	reportError(); s = 10 * unity
}

@ 사용자가 이미 불러온 글꼴에 새 식별자를 주면, 새 이름이 그 글꼴의 공식 식별자가 된다. 글꼴 이름 `\.{xyz}'와 `\.{XYZ}'는 서로 다른
것으로 여긴다. 이름이 같아도 크기가 다르면 다른 글꼴이다. 파일 이름을 담으려고 막 만든 문자열이 필요 없어지면 버린다.

@<이 글꼴을 이미 불러왔으면...@>=
flushableString = strPtr - 1
for f = fontBase + 1; f <= fontPtr; f++ {
	if strEqStr(fontName[f], curName) && strEqStr(fontArea[f], curArea) {
		if curName == flushableString {
			flushString(); curName = fontName[f]
		}
		if s > 0 {
			if s == fontSize[f] {
				goto commonEnding
			}
		} else if fontSize[f] == xnOverD(fontDsize[f], -s, 1000) {
			goto commonEnding
		}
	}
}

@ 글꼴 식별자의 뜻은 `\.{select font cmr10 at 12.0pt}'처럼 찍는다. 설계 크기로 쓸 때는 크기를 찍지 않는다.
@<원시 명령의 이름을 찍는...@>=
case setFont:
	printStr("select font "); slowPrint(fontName[chrCode])
	if fontSize[chrCode] != fontDsize[chrCode] {
		printStr(" at "); printScaled(fontSize[chrCode])
		printStr("pt")
	}

@ 대화 모드를 바꾸는 명령 넷이다.
@<\TeX의 원시 명령을...@>=
primitive("batchmode", setInteraction, batchMode)
@!@:batch_mode_}{\.{\\batchmode} primitive@>
primitive("nonstopmode", setInteraction, nonstopMode)
@!@:nonstop_mode_}{\.{\\nonstopmode} primitive@>
primitive("scrollmode", setInteraction, scrollMode)
@!@:scroll_mode_}{\.{\\scrollmode} primitive@>
primitive("errorstopmode", setInteraction, errorStopMode)
@!@:error_stop_mode_}{\.{\\errorstopmode} primitive@>

@ 이 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case setInteraction:
	switch chrCode {
	case batchMode: printEsc("batchmode")
	case nonstopMode: printEsc("nonstopmode")
	case scrollMode: printEsc("scrollmode")
	default: printEsc("errorstopmode")
	}

@ 대화 모드 바꾸기도 대입의 한 가지로 다룬다. 다만 \.{\\global}이 붙든 말든 언제나 전역이다.
@<대입들@>=
case setInteraction: newInteraction()

@ 대화 모드가 바뀌면 출력할 곳도 바뀐다. 이를테면 \.{\\batchmode}에서는 터미널에 아무것도 찍지 않는다.
@<|prefixedCommand|의 하위...@>=
func newInteraction() {
	printLn()
	interaction = curChr
	@<|interaction|에 따라 찍기 |selector|를 초기화한다@>
	if logOpened {
		selector += 2
	}
}

@ 명령 \.{\\afterassignment}는 토큰 하나를 전역 변수 |afterToken|에 넣는다. 이 변수는 대입을 할 때마다 바로 뒤에 살펴본다.

@<전역 변수@>=
var @!afterToken halfword // 0이거나 저장된 토큰

@ 처음에는 저장된 토큰이 없다.
@<핵심 변수들의...@>=
afterToken = 0

@ 명령 \.{\\afterassignment}는 모드에 상관없이 다음 토큰 하나를 저장한다. 이전에 저장해 둔 토큰이 있으면 그것은 잊힌다.
@<|mode|에 상관없는...@>=
case vmode + afterAssignment, hmode + afterAssignment, mmode + afterAssignment:
	getToken(); afterToken = curTok

@ 대입이 끝나면 저장해 둔 토큰을 입력에 되돌려 놓는다. 그래서 그 토큰이 다음에 읽힌다.
@<\.{\\afterassignment}가 저장한...@>=
if afterToken != 0 {
	curTok = afterToken; backInput(); afterToken = 0
}

@ 다음은 `공백도 relax도 호출도 대입도 아닌 다음 토큰을 얻는다'라고 부를 만한 프로시저다. 악센트 뒤의 문자나 수식 모드의 끝 따위를
읽기 전에 그 사이에 낀 대입을 처리하는 데 쓴다. 이 대입들 가운데서는 \.{\\setbox}를 쓸 수 없다.

@<|mainControl|이 쓰는 동작...@>=
func doAssignments() {
	for {
		@<공백도 relax도 호출도...@>
		if curCmd <= maxNonPrefixedCommand {
			return
		}
		setBoxAllowed = false; prefixedCommand(); setBoxAllowed = true
	}
}

@ 명령 \.{\\aftergroup}은 토큰 하나를 저장 스택에 넣어 두었다가 현재 그룹이 끝날 때 꺼낸다.
@<|mode|에 상관없는...@>=
case vmode + afterGroup, hmode + afterGroup, mmode + afterGroup:
	getToken(); saveForAfter(curTok)

@ 명령 \.{\\read}를 위한 파일은 명령 |inStream|으로 열고 닫는다.

@<\TeX의 원시 명령을...@>=
primitive("openin", inStream, 1)
@!@:open_in_}{\.{\\openin} primitive@>
primitive("closein", inStream, 0)
@!@:close_in_}{\.{\\closein} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case inStream:
	if chrCode == 0 { printEsc("closein") } else { printEsc("openin") }

@ 파일 열기와 닫기는 모드에 상관없다.
@<|mode|에 상관없는...@>=
case vmode + inStream, hmode + inStream, mmode + inStream: openOrCloseIn()

@ 스트림 번호는 0부터 15까지다. 이미 열린 스트림이면 먼저 닫는다. 명령 \.{\\openin}은 확장자가 없으면 `\.{.tex}'를 붙여서 파일을
연다. 열지 못해도 오류를 내지 않는다. 그 스트림은 닫힌 채로 남고, \.{\\ifeof}로 그것을 알아낼 수 있다.
@<|mainControl|이 쓰는 동작...@>=
func openOrCloseIn() {
	c := curChr // \.{\\openin}이면 1, \.{\\closein}이면 0
	scanFourBitInt(); n := curVal // 스트림 번호; |0..15|
	if readOpen[n] != closed {
		aClose(&readFile[n]); readOpen[n] = closed
	}
	if c != 0 {
		scanOptionalEquals(); scanFileName()
		if curExt == str("") {
			curExt = str(".tex")
		}
		packCurName()
		if aOpenIn(&readFile[n]) {
			readOpen[n] = justOpen
		}
	}
}

@ 사용자는 현재 모드와 상관없이 터미널에 메시지를 낼 수 있다.

@<|mode|에 상관없는...@>=
case vmode + message, hmode + message, mmode + message: issueMessage()

@ 메시지 명령 둘이다.
@<\TeX의 원시 명령을...@>=
primitive("message", message, 0)
@!@:message_}{\.{\\message} primitive@>
primitive("errmessage", message, 1)
@!@:err_message_}{\.{\\errmessage} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case message:
	if chrCode == 0 { printEsc("message") } else { printEsc("errmessage") }

@ 메시지의 토큰 목록을 확장해서 읽은 다음 문자열로 바꾼다. 명령 \.{\\message}이면 터미널에 찍고, \.{\\errmessage}이면 오류 메시지로
낸다. 다 쓴 문자열은 버린다.
@<|mainControl|이 쓰는 동작...@>=
func issueMessage() {
	c := curChr // \.{\\message}와 \.{\\errmessage}를 구별한다; |0..1|
	setLink(garbage, scanToks(false, true))
	oldSetting := selector // |selector| 설정을 담아 둔다; |0 .. maxSelector|
	selector = newString
	tokenShow(defRef); selector = oldSetting
	flushList(defRef)
	strRoom(1); s := makeString() // 메시지
	if c == 0 {
		@<문자열 |s|를 터미널에 찍는다@>
	} else {
		@<문자열 |s|를 오류 메시지로 찍는다@>
	}
	flushString()
}

@ 메시지가 현재 줄에 들어가지 않으면 줄을 바꾸고, 들어가면 앞의 것과 공백 하나로 떼어 놓는다.
@<문자열 |s|를 터미널에...@>=
if termOffset+length(s) > maxPrintLine-2 {
	printLn()
} else if termOffset > 0 || fileOffset > 0 {
	printChar(' ')
}
slowPrint(s); updateTerminal()

@ 스크롤 모드에서 사용자가 \.{\\errhelp}를 정의하지 않은 채 \.{\\errmessage}를 자주 쓰면, 매번 긴 도움말 메시지를 보여 주고 싶지는
않다. 그래서 장황한 설명은 한 번만 한다.

@<전역 변수@>=
var @!longHelpSeen bool // 긴 \.{\\errmessage} 도움말을 썼는가?

@ 처음에는 긴 도움말을 아직 보이지 않았다.
@<핵심 변수들의...@>=
longHelpSeen = false

@ 사용자가 \.{\\errhelp}를 정의했으면 그것을 도움말로 쓴다. 그렇지 않으면 \TeX의 표준 설명을 준다.
@<문자열 |s|를 오류 메시지로...@>=
printErr(""); slowPrint(s)
if errHelp() != null {
	useErrHelp = true
} else if longHelpSeen {
	help1("(That was another \\errmessage.)")
} else {
	if interaction < errorStopMode {
		longHelpSeen = true
	}
	help4("This error message was generated by an \\errmessage",
		"command, so I can't give any explicit help.",
		"Pretend that you're Hercule Poirot: Examine all clues,",
@^Poirot, Hercule@>
		"and deduce the truth by order and method.")
}
reportError(); useErrHelp = false

@ 루틴 |reportError|는 도움말을 |errHelp| 매개변수에서 가져와야 할 때 |giveErrHelp|를 부른다.

@<함수들@>=
func giveErrHelp() {
	tokenShow(errHelp())
}

@ 명령 \.{\\uppercase}와 \.{\\lowercase}는 먼저 토큰 목록을 만들고, 그 안의 글자들의 대소문자를 바꾸어서 구현한다.

@<|mode|에 상관없는...@>=
case vmode + caseShift, hmode + caseShift, mmode + caseShift: shiftCase()

@ 대소문자 바꾸기 명령 둘이다. 그 |chrCode|는 \.{\\lccode} 표나 \.{\\uccode} 표의 시작 위치다.
@<\TeX의 원시 명령을...@>=
primitive("lowercase", caseShift, lcCodeBase)
@!@:lowercase_}{\.{\\lowercase} primitive@>
primitive("uppercase", caseShift, ucCodeBase)
@!@:uppercase_}{\.{\\uppercase} primitive@>

@ 이 두 명령의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case caseShift:
	if chrCode == lcCodeBase { printEsc("lowercase") } else { printEsc("uppercase") }

@ 토큰 목록은 확장하지 않고 읽는다. 대소문자를 바꾼 다음 그 목록을 입력에 되돌려 놓으면 \TeX이 그것을 다시 읽는다.
@<|mainControl|이 쓰는 동작...@>=
func shiftCase() {
	var p pointer // 토큰 목록을 훑는다
	var t halfword // 토큰
	var c eightBits // 문자 코드
	b := curChr // |lcCodeBase|나 |ucCodeBase|
	p = scanToks(false, false); p = link(defRef)
	for p != null {
		@<알맞으면 |p|에 있는 토큰의 대소문자를 바꾼다@>
		p = link(p)
	}
	backList(link(defRef)); freeAvail(defRef) // 참조 횟수는 빼 둔다
}

@ 문자 토큰의 대소문자를 바꿀 때 |cmd|는 바꾸지 않는다. 그래서 범주 코드는 그대로다. 또 |csTokenFlag+activeBase|가 256의 배수라는 사실을
이용해서 능동 문자도 함께 바꾼다. 대응하는 코드가 0인 문자는 그대로 둔다.
@^data structure assumptions@>

@<알맞으면 |p|에 있는...@>=
t = info(p)
if t < csTokenFlag+singleBase {
	c = t % 256
	if equiv(b+c) != 0 {
		setInfo(p, t-c+equiv(b+c))
	}
}

@ 마침내 |mainControl|에서 빠진 마지막 조각들, 곧 디버깅에 쓸모 있는 `\.{\\show}' 명령들에 이르렀다.

@<|mode|에 상관없는...@>=
case vmode + xray, hmode + xray, mmode + xray: showWhatever()

@ 명령 \.{\\show} 계열은 다음 네 가지로 나뉜다.
@<정의@>=
const (
	@!showCode = iota // \.{\\show}
	@!showBoxCode // \.{\\showbox}
	@!showTheCode // \.{\\showthe}
	@!showListsCode // \.{\\showlists}
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("show", xray, showCode)
@!@:show_}{\.{\\show} primitive@>
primitive("showbox", xray, showBoxCode)
@!@:show_box_}{\.{\\showbox} primitive@>
primitive("showthe", xray, showTheCode)
@!@:show_the_}{\.{\\showthe} primitive@>
primitive("showlists", xray, showListsCode)
@!@:show_lists_code_}{\.{\\showlists} primitive@>

@ 이 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case xray:
	switch chrCode {
	case showBoxCode: printEsc("showbox")
	case showTheCode: printEsc("showthe")
	case showListsCode: printEsc("showlists")
	default: printEsc("show")
	}

@ 명령 \.{\\show} 계열은 무언가를 보여 준 다음 오류처럼 멈춘다. 사용자가 다른 것도 볼 수 있게 하려는 것이다. 이것은 진짜 오류가 아니므로
오류 개수를 늘리지 않는다. 명령 \.{\\errorstopmode}가 아니면 도움말도 보여 주지 않는다.
@<|mainControl|이 쓰는 동작...@>=
func showWhatever() {
	switch curChr {
	case showListsCode: beginDiagnostic(); showActivities()
	case showBoxCode: @<상자의 현재 내용을 보인다@>
	case showCode: @<토큰의 현재 뜻을 보이고 |goto commonEnding|@>
	default: @<어떤 매개변수나 레지스터의 현재 값을 보이고 |goto commonEnding|@>
	}
	@<길어질 수 있는 \.{\\show} 명령을 마무리한다@>
commonEnding:
	if interaction < errorStopMode {
		help0(); errorCount--
	} else if tracingOnline() > 0 {
		help3("This isn't an error message; I'm just \\showing something.",
			"Type `I\\show...' to show more (e.g., \\show\\cs,",
			"\\showthe\\count10, \\showbox255, \\showlists).")
	} else {
		help5("This isn't an error message; I'm just \\showing something.",
			"Type `I\\show...' to show more (e.g., \\show\\cs,",
			"\\showthe\\count10, \\showbox255, \\showlists).",
			"And type `I\\tracingonline=1\\show...' to show boxes and",
			"lists on your terminal as well as in the transcript file.")
	}
	reportError()
}

@ 명령 \.{\\show}는 다음 토큰을 확장하지 않고 읽어 그 뜻을 보여 준다.
@<토큰의 현재 뜻을...@>=
getToken()
if interaction == errorStopMode {
	wakeUpTerminal()
}
printNl("> ")
if curCs != 0 {
	sprintCs(curCs); printChar('=')
}
printMeaning(); goto commonEnding

@ 매크로 따위의 이름은 이렇게 찍는다.
@<원시 명령의 이름을 찍는...@>=
case undefinedCs: printStr("undefined")
case call: printStr("macro")
case longCall: printEsc("long macro")
case outerCall: printEsc("outer macro")
case longOuterCall: printEsc("long"); printEsc("outer macro")
case endTemplate: printEsc("outer endtemplate")

@ 명령 \.{\\showbox}는 상자의 내용을 진단 출력으로 보여 준다. 그 내용은 길어질 수 있으므로 \.{\\showboxdepth}와 \.{\\showboxbreadth}의
제한을 받는다.
@<상자의 현재 내용을...@>=
scanEightBitInt(); beginDiagnostic()
printNl("> \\box"); printInt(curVal); printChar('=')
if box(curVal) == null {
	printStr("void")
} else {
	showBox(box(curVal))
}

@ 명령 \.{\\showthe}는 \.{\\the}가 만들 토큰 목록을 보여 준다. 여기서는 |theToks|가 돌려주는 값을 쓰지 않는다.

@<어떤 매개변수나 레지스터의...@>=
theToks() // 결과(보여 줄 토큰 목록의 꼬리)는 쓰지 않는다
if interaction == errorStopMode {
	wakeUpTerminal()
}
printNl("> "); tokenShow(tempHead)
flushList(link(tempHead)); goto commonEnding

@ 명령 \.{\\showbox}와 \.{\\showlists}의 결과는 길 수 있다. 그래서 \.{\\tracingonline}이 양수가 아니면 기록 파일에만 쓰고, 터미널에는
기록 파일을 보라고만 알린다.
@<길어질 수 있는...@>=
endDiagnostic(true); printErr("OK")
@.OK@>
if selector == termAndLog && tracingOnline() <= 0 {
	selector = termOnly; printStr(" (see the transcript file)")
	selector = termAndLog
}

@* 표의 덤프와 언덤프.
\.{INITEX}는 글꼴과 매크로를 한 무더기 읽어 들인 다음, 필요한 정보를 모두 보조 파일에 써 둘 수 있다. 그러면 실무용 \TeX은 그 파일을
읽어 메모리를 아주 빨리 초기화할 수 있다. 프로그램의 이 부분이 그 출력과 입력을 맡는다. 쓰는 쪽과 읽는 쪽이 서로 거꾸로라는 것이
잘 드러나도록, 저장하는 과정과 되살리는 과정을 나란히 살펴보겠다.
@.INITEX@>

전역 변수 |formatIdent|는 \TeX이 시작할 준비가 되었을 때 |banner| 줄 바로 뒤에 찍는 문자열이다. \.{INITEX}에서 이 문자열은 그저
`\.{ (INITEX)}'이고, 다른 판의 \TeX에서는 이를테면 `\.{ (preloaded format=plain 1982.11.19)}'처럼 포맷 파일을 만든 날짜를 보여 준다.
\TeX의 표를 불러오기 전에는 |formatIdent=0|이다.

@<전역 변수@>=
var @!formatIdent strNumber

@ 처음에는 포맷 식별 문자열이 없다.
@<핵심 변수들의...@>=
formatIdent = 0

@ 표를 손수 초기화하는 \.{INITEX}에서는 식별 문자열을 이렇게 둔다.
@<표의 항목들을 초기화한다...@>=
formatIdent = str(" (INITEX)")

@ 이 프로시저는 \.{INITEX}에서만 쓰인다. 명령 \.{\\dump}가 부르며, 포맷 파일에 담을 것을 차례로 쓴다. 차례는 일관성 검사용 상수, 문자열
풀, 동적 메모리, 등가물 표, 글꼴 정보, 하이픈 넣기 표, 그리고 마무리 낱말이다.

@<|mainControl|이 쓰는 동작...@>=
func storeFmtFile() {
	var j, k, l int32 // 만능 첨자
	var p, q pointer // 만능 포인터
	var x int32 // 덤프할 무언가
	var w fourQuarters // ASCII 코드 네 개
	@<|storeFmtFile| 안의 작은 함수@>@;
	@<덤프가 허락되지 않으면 그만둔다@>
	@<|formatIdent|를 만들고, 포맷 파일을 열고, 덤프를 시작했다고 알린다@>
	@<일관성 검사를 위한 상수들을 덤프한다@>
	@<문자열 풀을 덤프한다@>
	@<동적 메모리를 덤프한다@>
	@<등가물 표를 덤프한다@>
	@<글꼴 정보를 덤프한다@>
	@<하이픈 넣기 표를 덤프한다@>
	@<몇 가지 더와 마무리 검사 낱말을 덤프한다@>
	@<포맷 파일을 닫는다@>
}

@ 포맷 파일을 덤프하는 프로시저와 짝을 이루어, 포맷 파일을 읽어 들이는 함수가 있다. 이 함수는 덤프된 포맷이 지금 \TeX의 표 크기 따위와
맞지 않으면 |false|를 돌려준다. 읽는 차례는 쓰는 차례와 똑같다.

포맷 파일의 표가 지금 \TeX의 표보다 크면, 뒤에서 정의하는 함수 |undumpSize|가 메시지를 찍고 |false|를 돌려준다. 그러면 부르는 쪽이
|goto badFmt|한다.

@<함수들@>=
@<|openFmtFile|이라는 함수를 선언한다@>@;
func loadFmtFile() bool {
	var j, k int32 // 만능 첨자
	var p, q pointer // 만능 포인터
	var x int32 // 언덤프한 무언가
	var w fourQuarters // ASCII 코드 네 개
	@<|loadFmtFile|의 매크로@>@;
	@<일관성 검사를 위한 상수들을 언덤프한다@>
	@<문자열 풀을 언덤프한다@>
	@<동적 메모리를 언덤프한다@>
	@<등가물 표를 언덤프한다@>
	@<글꼴 정보를 언덤프한다@>
	@<하이픈 넣기 표를 언덤프한다@>
	@<몇 가지 더와 마무리 검사 낱말을 언덤프한다@>
	return true // 됐다!
badFmt:
	wakeUpTerminal()
	wtermLn("(Fatal format file error; I'm stymied)")
@.Fatal format file error@>
	return false
}

@ 포맷 파일은 |savePtr=0|일 때에만 덤프할 수 있다. 이 조건은 |curLevel=levelOne|이라는 뜻이다. 그러면 배열 |xeqLevel|의 값은 모두
같으므로 그것을 덤프할 필요가 없다.

@<덤프가 허락되지 않으면...@>=
if savePtr != 0 {
	printErr("You can't dump inside a group")
@.You can't dump...@>
	help1("`{...\\dump}' is a no-no."); succumb()
}

@ \seclabel{dump-words}포맷 파일은 |memoryWord| 항목들로 이루어진다. 여러 형의 낱말을 덤프하는 데 다음 함수들을 쓴다.

@<전역 변수@>=
var @!fmtFile wordFile // 포맷 정보의 입력이나 출력에 쓴다

func dumpWd(w memoryWord) { fmtFile.buf = w; wPut(&fmtFile) }
func dumpInt(x int32) { fmtFile.buf = memoryWord{sc: x}; wPut(&fmtFile) }
func dumpHh(h twoHalves) { fmtFile.buf = memoryWord{hh: h}; wPut(&fmtFile) }
func dumpQqqq(q fourQuarters) { fmtFile.buf = memoryWord{qqqq: q}; wPut(&fmtFile) }

@ 낱말 파일의 기본 연산은 둘이다. 현재 원소 |f.buf|를 파일에 쓰는 |wPut|과, 다음 원소를 |f.buf|에 읽어 오는 |wGet|이다. 형 |memoryWord|는
필드가 따로따로인 구조체이므로(\secref{memory-word}), 한 낱말을 쓸 때 모든 필드를 차례로 쓴다. 32비트 정수 아홉 개와 64비트 부동 소수점
수 하나, 모두 44바이트다. 바이트 순서는 리틀 엔디언으로 정했다. 포맷 파일이 다 그렇듯이, 이 형식의 파일은 이 프로그램으로 만든
\TeX끼리만 주고받을 수 있다.
@^system dependencies@>

@<함수들@>=
func wPut(f *wordFile) { // |f.buf|를 파일에 쓴다
	var b [44]byte
	var g = math.Float64bits(f.buf.gr)
	var v = [11]uint32{uint32(f.buf.sc), uint32(g), uint32(g >> 32),
		uint32(f.buf.hh.rh), uint32(f.buf.hh.lh), uint32(f.buf.hh.b0), uint32(f.buf.hh.b1),
		uint32(f.buf.qqqq.b0), uint32(f.buf.qqqq.b1), uint32(f.buf.qqqq.b2), uint32(f.buf.qqqq.b3)}
	for i, x := range v {
		b[4*i], b[4*i+1], b[4*i+2], b[4*i+3] = byte(x), byte(x>>8), byte(x>>16), byte(x>>24)
	}
	f.w.Write(b[:])
}

func wGet(f *wordFile) { // 다음 원소를 |f.buf|에 읽어 온다
	var b [44]byte
	var v [11]uint32
	if _, err := io.ReadFull(f.r, b[:]); err != nil {
		f.atEOF = true; return
	}
	for i := range v {
		v[i] = uint32(b[4*i]) | uint32(b[4*i+1])<<8 | uint32(b[4*i+2])<<16 | uint32(b[4*i+3])<<24
	}
	f.buf.sc = int32(v[0]); f.buf.gr = math.Float64frombits(uint64(v[1]) | uint64(v[2])<<32)
	f.buf.hh = twoHalves{rh: int32(v[3]), lh: int32(v[4]), b0: int32(v[5]), b1: int32(v[6])}
	f.buf.qqqq = fourQuarters{int32(v[7]), int32(v[8]), int32(v[9]), int32(v[10])}
}

@ 언덤프 함수들은 조금 더 복잡하다. 읽어 들이는 값이 알맞은 범위에 있는지 검사해야 하기 때문이다. 이를테면 `|undump(a,b,&x)|'는
|a<=x<=b| 범위에 있어야 할 정수 값 |x|를 읽는다. 언덤프하는 동안에는 시스템 오류 메시지를 억눌러야 한다.
@^system dependencies@>

값이 범위를 벗어나면 |goto badFmt|해야 한다. 그러나 \GO/의 함수는 부른 쪽의 레이블로 갈 수 없다. 그래서 |undump(a,b,&x)|와
|undumpSize(a,b,s,&x)|는 값이 맞으면 |x|에 넣고 |true|를, 그렇지 않으면 |false|를 돌려주고, 부르는 쪽이 |goto badFmt|한다. 범위를
검사하지 않는 |undumpWd| 따위는 읽은 값을 그대로 돌려준다.

@<함수들@>=
func undumpWd() memoryWord { wGet(&fmtFile); return fmtFile.buf }
func undumpInt() int32 { wGet(&fmtFile); return fmtFile.buf.sc }
func undumpHh() twoHalves { wGet(&fmtFile); return fmtFile.buf.hh }
func undumpQqqq() fourQuarters { wGet(&fmtFile); return fmtFile.buf.qqqq }

func undump(a, b int32, v *int32) bool {
	x := undumpInt()
	if x < a || x > b {
		return false
	}
	*v = x; return true
}

func undumpSize(a, b int32, s string, v *int32) bool {
	x := undumpInt()
	if x < a {
		return false
	}
	if x > b { // 표가 너무 작다
		wakeUpTerminal()
		wtermLn("---! Must increase the ", s)
@.Must increase the x@>
		return false
	}
	*v = x; return true
}

@ \seclabel{dump-constants}다음 몇 절을 보면 덤프 함수와 언덤프 함수를 어떻게 쓰는지 분명해질 것이다. 먼저 일관성 검사에 쓸 상수들을
덤프한다. 첫 낱말에는 문자열 상수 목록의 검사합 |poolCheckSum|을 쓴다(\secref{pool-check}). 그다음에는 메모리와 표의 크기를 쓴다.
읽는 쪽에서 이 값들이 하나라도 다르면 그 포맷 파일은 쓸 수 없다.

@<일관성 검사를 위한 상수들을 덤프한다@>=
dumpInt(poolCheckSum())
dumpInt(memBot)
dumpInt(memTop)
dumpInt(eqtbSize)
dumpInt(hashPrime)
dumpInt(hyphSize)

@ 검사합 함수 |poolCheckSum|은 미리 불러 두는 문자열들의 문자와 길이로 계산한다.

@<함수들@>=
func poolCheckSum() int32 { // 미리 불러 두는 문자열들의 검사합
	var a int32 = 271828
	for _, s := range poolLiterals {
		for i := 0; i < len(s); i++ {
			a = (a*31 + int32(s[i])) % 0o10000000000
		}
		a = (a*37 + int32(len(s))) % 0o10000000000
	}
	return a
}

@ 이 판에서는 프로그램 하나가 \.{INITEX}와 실무용 판을 겸하므로 \.{INITEX}와 \TeX은 언제나 같은 문자열 상수 목록을 가진다. (물론 그렇게
되는 것이 바람직하다.) 그래도 검사합은 확인한다. 다른 판의 프로그램이 만든 포맷 파일을 잘못 읽는 일을 막아 주기 때문이다.
@^string pool@>

@<일관성 검사를 위한 상수들을 언덤프한다@>=
x = fmtFile.buf.sc
if x != poolCheckSum() {
	goto badFmt // 문자열들이 같은지 검사한다
}
x = undumpInt()
if x != memBot {
	goto badFmt
}
x = undumpInt()
if x != memTop {
	goto badFmt
}
x = undumpInt()
if x != eqtbSize {
	goto badFmt
}
x = undumpInt()
if x != hashPrime {
	goto badFmt
}
x = undumpInt()
if x != hyphSize {
	goto badFmt
}

@ 문자 넷을 한 낱말로 덤프하는 작은 함수 |dumpFourASCII|는 |storeFmtFile|의 지역 변수 |k|와 |w|를 쓴다. 그래서 그 안의 함수 리터럴로
두었다.

@<|storeFmtFile| 안의 작은 함수@>=
dumpFourASCII := func() {
	w.b0 = qi(so(strPool[k])); w.b1 = qi(so(strPool[k+1]))
	w.b2 = qi(so(strPool[k+2])); w.b3 = qi(so(strPool[k+3]))
	dumpQqqq(w)
}

@ 문자열 풀은 각 문자열의 시작 위치와, 문자 넷씩 묶은 낱말들로 덤프한다. 마지막 묶음은 끝에서 거꾸로 네 글자를 잡으므로 앞 묶음과
겹칠 수 있지만, 해는 없다.
@<문자열 풀을 덤프한다@>=
dumpInt(poolPtr)
dumpInt(strPtr)
for k = 0; k <= strPtr; k++ {
	dumpInt(strStart[k])
}
k = 0
for k+4 < poolPtr {
	dumpFourASCII(); k += 4
}
k = poolPtr - 4; dumpFourASCII()
printLn(); printInt(strPtr); printStr(" strings of total length ")
printInt(poolPtr)

@ 언덤프 쪽의 짝이다.
@<|loadFmtFile|의 매크로@>=
undumpFourASCII := func() {
	w = undumpQqqq()
	strPool[k] = si(qo(w.b0)); strPool[k+1] = si(qo(w.b1))
	strPool[k+2] = si(qo(w.b2)); strPool[k+3] = si(qo(w.b3))
}

@ 문자열 풀을 되살린다. 크기가 지금 \TeX의 한도를 넘으면 포맷을 읽을 수 없다.
@<문자열 풀을 언덤프한다@>=
if !undumpSize(0, poolSize, "string pool size", &poolPtr) {
	goto badFmt
}
if !undumpSize(0, maxStrings, "max strings", &strPtr) {
	goto badFmt
}
for k = 0; k <= strPtr; k++ {
	if !undump(0, poolPtr, &strStart[k]) {
		goto badFmt
	}
}
k = 0
for k+4 < poolPtr {
	undumpFourASCII(); k += 4
}
k = poolPtr - 4; undumpFourASCII()
initStrPtr = strPtr; initPoolPtr = poolPtr

@ 배열 |mem|의 가변 크기 부분에서 빈 공간 목록을 정렬해 두면, 대개 동적 메모리를 그리 많이 덤프하지 않아도 된다. 쓰는 블록만 차례로
덤프하고 빈 블록은 머리 두 낱말만 쓰면 되기 때문이다.

또 |varUsed|와 |dynUsed|를 다시 계산해서, 통계를 모으지 않았을 때도 \.{INITEX}가 올바른 정보를 덤프하게 한다.

@<동적 메모리를 덤프한다@>=
sortAvail(); varUsed = 0
dumpInt(loMemMax); dumpInt(rover)
p = memBot; q = rover; x = 0
for {
	for k = p; k <= q+1; k++ {
		dumpWd(mem[k])
	}
	x = x + q + 2 - p; varUsed = varUsed + q - p
	p = q + nodeSize(q); q = rlink(q)
	if q == rover {
		break
	}
}
varUsed = varUsed + loMemMax - p; dynUsed = memEnd + 1 - hiMemMin
for k = p; k <= loMemMax; k++ {
	dumpWd(mem[k])
}
x = x + loMemMax + 1 - p
dumpInt(hiMemMin); dumpInt(avail)
for k = hiMemMin; k <= memEnd; k++ {
	dumpWd(mem[k])
}
x = x + memEnd + 1 - hiMemMin
@<동적 메모리 사용량을 덤프하고 알린다@>

@ 앞 절에 이어서 한 낱말짜리 메모리 사용량을 바로잡아 덤프하고 알린다.

@<동적 메모리 사용량을...@>=
p = avail
for p != null {
	dynUsed--; p = link(p)
}
dumpInt(varUsed); dumpInt(dynUsed)
printLn(); printInt(x)
printStr(" memory locations dumped; current usage is ")
printInt(varUsed); printChar('&'); printInt(dynUsed)

@ 동적 메모리를 되살린다. 덤프할 때와 같은 차례로 블록들을 읽는다.
@<동적 메모리를 언덤프한다@>=
if !undump(loMemStatMax+1000, hiMemStatMin-1, &loMemMax) {
	goto badFmt
}
if !undump(loMemStatMax+1, loMemMax, &rover) {
	goto badFmt
}
p = memBot; q = rover
for {
	for k = p; k <= q+1; k++ {
		mem[k] = undumpWd()
	}
	p = q + nodeSize(q)
	if p > loMemMax || (q >= rlink(q) && rlink(q) != rover) {
		goto badFmt
	}
	q = rlink(q)
	if q == rover {
		break
	}
}
for k = p; k <= loMemMax; k++ {
	mem[k] = undumpWd()
}
@<아래쪽 메모리를 더 쓸 수 있게 하고 위쪽 메모리를 언덤프한다@>

@ 앞 절의 코드에서 떼어 낸 부분이다. 지금 \TeX의 |memMin|이 \.{INITEX}의 것보다 작으면 아래쪽에 남는 메모리를 빈 블록으로 만들어
쓸 수 있게 한다.

@<아래쪽 메모리를 더 쓸 수...@>=
if memMin < memBot-2 { // 아래쪽 메모리를 더 쓸 수 있게 한다
	p = llink(rover); q = memMin + 1
	setLink(memMin, null); setInfo(memMin, null) // 맨 아래 낱말은 쓰지 않는다
	setRlink(p, q); setLlink(rover, q)
	setRlink(q, rover); setLlink(q, p); setLink(q, emptyFlag)
	setNodeSize(q, memBot-q)
}
if !undump(loMemMax+1, hiMemStatMin, &hiMemMin) {
	goto badFmt
}
if !undump(null, memTop, &avail) {
	goto badFmt
}
memEnd = memTop
for k = hiMemMin; k <= memEnd; k++ {
	mem[k] = undumpWd()
}
varUsed = undumpInt(); dynUsed = undumpInt()

@ 등가물 표와 해시 표를 덤프한다. 특별한 위치 |parLoc|과 |writeLoc|도 함께 쓴다.
@<등가물 표를 덤프한다@>=
@<|eqtb|의 영역 1--4를 덤프한다@>
@<|eqtb|의 영역 5와 6을 덤프한다@>
dumpInt(parLoc); dumpInt(writeLoc)
@<해시 표를 덤프한다@>

@ 언덤프 쪽의 짝이다. 위치 |parLoc|을 되살리면 |parToken|도 다시 계산한다.
@<등가물 표를 언덤프한다@>=
@<|eqtb|의 영역 1--6을 언덤프한다@>
if !undump(hashBase, frozenControlSequence, &parLoc) {
	goto badFmt
}
parToken = csTokenFlag + parLoc
if !undump(hashBase, frozenControlSequence, &writeLoc) {
	goto badFmt
}
@<해시 표를 언덤프한다@>

@ 등가물 표에는 같은 값이 되풀이되는 일이 많으므로 압축해서 덤프한다. 포맷 파일에서 $n+2$개 값의 나열 $(n,x_1,\ldots,x_n,m)$은 |eqtb|의
연속된 항목 $n+m$개를 나타낸다. 곧 $x_n$의 사본이 |m|개 더 붙은 $(x_1,\ldots,x_n,x_n,\ldots,x_n)$이다.

@<|eqtb|의 영역 1--4를...@>=
k = activeBase
for {
	j = k
	for j < intBase-1 {
		if equiv(j) == equiv(j+1) && eqType(j) == eqType(j+1) && eqLevel(j) == eqLevel(j+1) {
			goto found1
		}
		j++
	}
	l = intBase; goto done1 // |j=intBase-1|
found1:
	j++; l = j
	for j < intBase-1 {
		if equiv(j) != equiv(j+1) || eqType(j) != eqType(j+1) || eqLevel(j) != eqLevel(j+1) {
			goto done1
		}
		j++
	}
done1:
	dumpInt(l - k)
	for k < l {
		dumpWd(eqtb[k]); k++
	}
	k = j + 1; dumpInt(k - l)
	if k == intBase {
		break
	}
}

@ 영역 5와 6은 수치 값만 들어 있으므로 |sc| 필드만 비교한다. 이 영역에는 |xeqLevel|이 따로 있으므로 단계 필드가 없다.
@<|eqtb|의 영역 5와 6을...@>=
for {
	j = k
	for j < eqtbSize {
		if eqtb[j].sc == eqtb[j+1].sc {
			goto found2
		}
		j++
	}
	l = eqtbSize + 1; goto done2 // |j=eqtbSize|
found2:
	j++; l = j
	for j < eqtbSize {
		if eqtb[j].sc != eqtb[j+1].sc {
			goto done2
		}
		j++
	}
done2:
	dumpInt(l - k)
	for k < l {
		dumpWd(eqtb[k]); k++
	}
	k = j + 1; dumpInt(k - l)
	if k > eqtbSize {
		break
	}
}

@ 언덤프는 압축을 푸는 것이다. 값 |n|개를 읽은 다음, 마지막 값을 |m|번 더 베낀다.
@<|eqtb|의 영역 1--6을...@>=
k = activeBase
for {
	x = undumpInt()
	if x < 1 || k+x > eqtbSize+1 {
		goto badFmt
	}
	for j = k; j <= k+x-1; j++ {
		eqtb[j] = undumpWd()
	}
	k += x
	x = undumpInt()
	if x < 0 || k+x > eqtbSize+1 {
		goto badFmt
	}
	for j = k; j <= k+x-1; j++ {
		eqtb[j] = eqtb[k-1]
	}
	k += x
	if k > eqtbSize {
		break
	}
}

@ 해시 표는 다른 방식으로 압축한다. 그 아래쪽 영역은 대개 성기기 때문이다. 그래서 |p<=hashUsed|이고 |text(p)!=0|인 항목은 |p|와
|hash[p]|의 두 낱말로 쓴다. 그리고 |p>hashUsed|인 쪽은 해시 표가 물론 촘촘히 차 있으므로 나머지 항목을 한 덩어리로 쓴다.

@<해시 표를 덤프한다@>=
dumpInt(hashUsed); csCount = frozenControlSequence - 1 - hashUsed
for p = hashBase; p <= hashUsed; p++ {
	if text(p) != 0 {
		dumpInt(p); dumpHh(hash[p]); csCount++
	}
}
for p = hashUsed + 1; p <= undefinedControlSequence-1; p++ {
	dumpHh(hash[p])
}
dumpInt(csCount)
printLn(); printInt(csCount); printStr(" multiletter control sequences")

@ 해시 표를 되살린다. 위치 번호는 늘어나는 차례로 와야 한다.
@<해시 표를 언덤프한다@>=
if !undump(hashBase, frozenControlSequence, &hashUsed) {
	goto badFmt
}
p = hashBase - 1
for {
	if !undump(p+1, hashUsed, &p) {
		goto badFmt
	}
	hash[p] = undumpHh()
	if p == hashUsed {
		break
	}
}
for p = hashUsed + 1; p <= undefinedControlSequence-1; p++ {
	hash[p] = undumpHh()
}
csCount = undumpInt()

@ 글꼴 정보는 |fontInfo| 배열 전체와, 글꼴마다 하나씩 있는 배열들의 항목을 덤프한다. 앞의 일곱 낱말은 |nullFont|의 매개변수이므로 통계에서
뺀다.
@<글꼴 정보를 덤프한다@>=
dumpInt(fmemPtr)
for k = 0; k <= fmemPtr-1; k++ {
	dumpWd(fontInfo[k])
}
dumpInt(fontPtr)
for k = nullFont; k <= fontPtr; k++ {
	@<내부 글꼴 번호 |k|의 배열 정보를 덤프한다@>
}
printLn(); printInt(fmemPtr - 7); printStr(" words of font info for ")
printInt(fontPtr - fontBase); printStr(" preloaded font")
if fontPtr != fontBase+1 {
	printChar('s')
}

@ 언덤프 쪽의 짝이다.
@<글꼴 정보를 언덤프한다@>=
if !undumpSize(7, fontMemSize, "font mem size", &fmemPtr) {
	goto badFmt
}
for k = 0; k <= fmemPtr-1; k++ {
	fontInfo[k] = undumpWd()
}
if !undumpSize(fontBase, fontMax, "font max", &fontPtr) {
	goto badFmt
}
for k = nullFont; k <= fontPtr; k++ {
	@<내부 글꼴 번호 |k|의 배열 정보를 언덤프한다@>
}

@ 글꼴마다 배열의 항목을 하나씩 덤프하고, `\.{\\font\\cmr=cmr10}' 같은 꼴로 알린다.
@<내부 글꼴 번호 |k|의 배열 정보를 덤프한다@>=
dumpQqqq(fontCheck[k])
dumpInt(fontSize[k]); dumpInt(fontDsize[k]); dumpInt(fontParams[k])
dumpInt(hyphenChar[k]); dumpInt(skewChar[k])
dumpInt(fontName[k]); dumpInt(fontArea[k])
dumpInt(fontBc[k]); dumpInt(fontEc[k])
dumpInt(charBase[k]); dumpInt(widthBase[k]); dumpInt(heightBase[k])
dumpInt(depthBase[k]); dumpInt(italicBase[k]); dumpInt(ligKernBase[k])
dumpInt(kernBase[k]); dumpInt(extenBase[k]); dumpInt(paramBase[k])
dumpInt(fontGlue[k])
dumpInt(bcharLabel[k]); dumpInt(fontBchar[k]); dumpInt(fontFalseBchar[k])
printNl("\\font"); printEsc(fontIDText(k)); printChar('=')
printFileName(fontName[k], fontArea[k], str(""))
if fontSize[k] != fontDsize[k] {
	printStr(" at "); printScaled(fontSize[k]); printStr("pt")
}

@ 글꼴마다 배열의 항목을 하나씩 되살린다. 범위를 검사할 수 있는 것은 검사한다.
@<내부 글꼴 번호 |k|의 배열 정보를 언덤프한다@>=
fontCheck[k] = undumpQqqq()
fontSize[k] = undumpInt(); fontDsize[k] = undumpInt()
if !undump(minHalfword, maxHalfword, &fontParams[k]) {
	goto badFmt
}
hyphenChar[k] = undumpInt(); skewChar[k] = undumpInt()
if !undump(0, strPtr, &fontName[k]) || !undump(0, strPtr, &fontArea[k]) {
	goto badFmt
}
if !undump(0, 255, &fontBc[k]) || !undump(0, 255, &fontEc[k]) {
	goto badFmt
}
charBase[k] = undumpInt(); widthBase[k] = undumpInt(); heightBase[k] = undumpInt()
depthBase[k] = undumpInt(); italicBase[k] = undumpInt(); ligKernBase[k] = undumpInt()
kernBase[k] = undumpInt(); extenBase[k] = undumpInt(); paramBase[k] = undumpInt()
if !undump(minHalfword, loMemMax, &fontGlue[k]) {
	goto badFmt
}
if !undump(0, fmemPtr-1, &bcharLabel[k]) {
	goto badFmt
}
if !undump(minQuarterword, nonChar, &fontBchar[k]) ||
	!undump(minQuarterword, nonChar, &fontFalseBchar[k]) {
	goto badFmt
}

@ 하이픈 넣기 표는 두 부분으로 나누어 덤프한다. 먼저 하이픈 넣기 예외와 트라이를, 그다음 트라이 연산 표를 덤프한다(다음 절). 트라이가
아직 압축되지 않았으면 먼저 압축한다.

@<하이픈 넣기 표를 덤프한다@>=
dumpInt(hyphCount)
for k = 0; k <= hyphSize; k++ {
	if hyphWord[k] != 0 {
		dumpInt(k); dumpInt(hyphWord[k]); dumpInt(hyphList[k])
	}
}
printLn(); printInt(hyphCount); printStr(" hyphenation exception")
if hyphCount != 1 {
	printChar('s')
}
if trieNotReady {
	initTrie()
}
dumpInt(trieMax)
for k = 0; k <= trieMax; k++ {
	dumpHh(trie[k])
}
@<트라이 연산 표를 덤프한다@>

@ 앞 절에서 떼어 낸, 트라이 연산 표를 덤프하는 부분이다. 언어마다 연산이 몇 개인지도 알린다.

@<트라이 연산 표를 덤프한다@>=
dumpInt(trieOpPtr)
for k = 1; k <= trieOpPtr; k++ {
	dumpInt(hyfDistance[k])
	dumpInt(hyfNum[k])
	dumpInt(hyfNext[k])
}
printNl("Hyphenation trie of length "); printInt(trieMax)
@.Hyphenation trie...@>
printStr(" has "); printInt(trieOpPtr); printStr(" op")
if trieOpPtr != 1 {
	printChar('s')
}
printStr(" out of "); printInt(trieOpSize)
for k = 255; k >= 0; k-- {
	if trieUsed[k] > minQuarterword {
		printNl("  "); printInt(qo(trieUsed[k]))
		printStr(" for language "); printInt(k)
		dumpInt(k); dumpInt(qo(trieUsed[k]))
	}
}

@ 하이픈 넣기 예외와 트라이를 되살린다. 배열 |opStart|에서 ``비어 있지 않은'' 부분만 되살리면 된다.

@<하이픈 넣기 표를 언덤프한다@>=
if !undump(0, hyphSize, &hyphCount) {
	goto badFmt
}
for k = 1; k <= hyphCount; k++ {
	if !undump(0, hyphSize, &j) {
		goto badFmt
	}
	if !undump(0, strPtr, &hyphWord[j]) || !undump(minHalfword, maxHalfword, &hyphList[j]) {
		goto badFmt
	}
}
if !undumpSize(0, trieSize, "trie size", &j) {
	goto badFmt
}
if iniVersion {
	trieMax = j
}
for k = 0; k <= j; k++ {
	trie[k] = undumpHh()
}
@<트라이 연산 표를 언덤프한다@>

@ 앞 절에서 떼어 낸, 트라이 연산 표를 언덤프하는 부분이다.

@<트라이 연산 표를 언덤프한다@>=
if !undumpSize(0, trieOpSize, "trie op size", &j) {
	goto badFmt
}
if iniVersion {
	trieOpPtr = j
}
for k = 1; k <= j; k++ {
	if !undump(0, 63, &hyfDistance[k]) || !undump(0, 63, &hyfNum[k]) || // |smallNumber|
		!undump(minQuarterword, maxQuarterword, &hyfNext[k]) {
		goto badFmt
	}
}
if iniVersion {
	for k = 0; k <= 255; k++ {
		trieUsed[k] = minQuarterword
	}
}
k = 256
for j > 0 {
	if !undump(0, k-1, &k) || !undump(1, j, &x) {
		goto badFmt
	}
	if iniVersion {
		trieUsed[k] = qi(x)
	}
	j -= x; opStart[k] = qo(j)
}
if iniVersion {
	trieNotReady = false
}

@ 마지막으로 대화 모드와 포맷 식별 문자열과 검사 낱말 69069를 쓴다. 통계는 이미 많이 찍었으므로, 그것이 다시 나타나지 않도록
|tracingStats=0|으로 한다.

@<몇 가지 더와 마무리 검사 낱말을 덤프한다@>=
dumpInt(interaction); dumpInt(formatIdent); dumpInt(69069)
setTracingStats(0)

@ 마지막 검사 낱말이 69069이고 그 뒤에 파일이 끝나야 포맷 파일이 온전한 것이다.
@<몇 가지 더와 마무리 검사 낱말을 언덤프한다@>=
if !undump(batchMode, errorStopMode, &interaction) {
	goto badFmt
}
if !undump(0, strPtr, &formatIdent) {
	goto badFmt
}
x = undumpInt()
if x != 69069 || fmtFile.atEOF {
	goto badFmt
}

@ 포맷 식별 문자열은 작업 이름과 오늘 날짜로 만든다. 포맷 파일 이름도 작업 이름을 따른다.
@<|formatIdent|를 만들고...@>=
selector = newString
printStr(" (preloaded format="); printStr(jobName); printChar(' ')
printInt(year()); printChar('.')
printInt(month()); printChar('.'); printInt(day()); printChar(')')
if interaction == batchMode {
	selector = logOnly
} else {
	selector = termAndLog
}
strRoom(1)
formatIdent = makeString()
packJobName(formatExtension)
for !wOpenOut(&fmtFile) {
	promptFileName("format file name", ".fmt")
}
printNl("Beginning to dump on file ")
@.Beginning to dump...@>
slowPrint(wMakeNameString(&fmtFile)); flushString()
printNl(""); slowPrint(formatIdent)

@ 덤프가 끝나면 포맷 파일을 닫는다.
@<포맷 파일을 닫는다@>=
wClose(&fmtFile)

@* 주 프로그램.
드디어 왔다. 이것이 우리가 써 온 그 모든 프로시저를 실제로 돌리는 \TeX의 부분이다.

음---거의 그렇다. 혹시 잊은 루틴이 있을지 모르니 몇 개 들어갈 자리를 남겨 두자.

@<함수들@>=
@<마지막 순간의 프로시저들@>

@ 앞에서 \TeX82에는 두 판이 있다고 말했다. 하나는 \.{INITEX}라고 부르며 먼저 실행해야 한다. 이 판은 포맷 파일을 읽지 않고 모든 것을
@.INITEX@>
처음부터 초기화하며, 포맷 파일을 덤프할 줄 안다. 다른 하나는 `\.{VIRTEX}'라고 부른다. 이것은 일을 시작하려면 포맷 파일을 읽어야
@.VIRTEX@>
하는 ``처녀'' 프로그램이다. 대개 \.{VIRTEX}는 \.{INITEX}보다 메모리를 더 많이 쓸 수 있다. 보조 하이픈 넣기 표나 |primitive|의 수많은
호출 따위가 차지하는 공간이 필요 없기 때문이다.

물론 \.{VIRTEX}라도 포맷 파일을 순식간에 읽을 수는 없다. 그래서 가장 좋은 구현에서는 목적 코드를 불러들이는 루틴만이 아니라 포맷 파일을
읽는 일까지 건너뛰는, 포맷을 미리 불러 둔 실무용 \TeX을 만든다. 표준 언어의 기능만으로는 이것이 불가능하다. 그러나 많은 시스템에서는
초기화를 건너뛰도록 속이는 간단한 방법이 있다. (1)~|readyAlready|라는 전역 정수 변수를 선언한다. \.{VIRTEX}를 처음 불러들였을 때 이
변수가 314159 같은 특정한 값을 가지고 있을 확률은 무시해도 된다. (2)~포맷 파일을 읽어 들이고 모든 것을 초기화한 뒤에 |readyAlready=314159|로
한다. (3)~곧 \.{VIRTEX}는 `\.*'를 찍고 입력을 기다린다. 이때 프로그램을 끊고 그 코어 이미지를 운영체제가 빨리 다시 불러들일 수 있는
꼴로 저장한다. (4)~그 코어 이미지를 실행하면 프로그램은 처음부터 다시 시작한다. 그러나 이제는 |readyAlready=314159|이고 다른 전역 변수도
모두 초기화된 값을 가지고 있다. 처녀성은 사라졌다!

다시 말해, |readyAlready|에 값을 주기 전에 |readyAlready=314159|인지 검사하는 반칙을 스스로 허락하면 긴 초기화를 피할 수 있다. 더러운
속임수가 이렇게 큰 보상을 주는 일은 드물다.
@^system dependencies@>

미리 불러 두기를 할 수 있는 시스템에서는 \.{TeX}이라는 표준 프로그램이 \.{plain} 포맷을 미리 불러 둔 것이어야 한다. 그래야
{\sl The \TeX book}과 맞기 때문이다. 흔히 쓰는 다른 포맷, 이를테면 \.{AmSTeX}을 위한 판도 마련해 두면 좋다.
@:TeXbook}{\sl The \TeX book@>
@.AmSTeX@>
@.plain@>

\GO/ 프로그램은 늘 모든 전역 변수를 0으로 하고 시작한다. 그러니 코어 이미지를 저장해 둘 수 없는 시스템에서 이 속임수는 아무 일도 하지
않는다. 그래도 해가 없으므로 그대로 둔다.

@<전역 변수@>=
var @!readyAlready int32 // 경제를 위해 순수를 희생한다

@ \seclabel{main}이제 정말로 왔다. \TeX은 여기서 시작하고 여기서 끝난다.

실행 시스템이 영리해서 초기화하지 않은 변수를 읽는 ``실수''를 잡아낸다면, |readyAlready|에 관한 처음의 검사는 지워야 한다.
@^system dependencies@>

다른 프로시저에서 레이블 |endOfTEX|나 |finalEnd|로 갈 때는 그 레이블을 값으로 |panic|을 일으킨다(\secref{outer-labels}). 그래서 |main|은
맨 처음에 그것을 |recover|로 받는 함수를 미루어(|defer|) 둔다. 그 함수는 받은 값이 |endOfTEX|이면 |closeFilesAndTerminate|를 부르고,
어느 쪽이든 |finalEnd| 뒤의 일을 한다. 정상적인 흐름에서는 주 프로그램 안에서 |endOfTEX|로 뛰는 곳이 없으므로 그 레이블은 주석으로만
남는다. \.{INITEX}로 돌지는 명령줄의 첫 인자가 `\.{-ini}'인지로 정한다.

@<주 프로그램@>=
func main() { // |startHere|
	@<바깥 레이블로 가는 |panic|을 받을 함수를 미루어 둔다@>
	iniVersion = len(os.Args) > 1 && os.Args[1] == "-ini"
	@<끼어들기 신호를 받으면...@>
	@<파일 색인을 만들 고루틴을 띄운다@>
	history = fatalErrorStop // 초기화하는 동안 그만둘 때를 대비한다
	tOpenOut() // 터미널을 출력용으로 연다
	if readyAlready == 314159 {
		goto startOfTEX
	}
	@<``상수'' 값들이 서로 맞는지 검사한다@>
	if bad > 0 {
		wtermLn("Ouch---my internal constants have been clobbered!", "---case ", bad)
@.Ouch...clobbered@>
		goto finalEnd
	}
	initialize() // 전역 변수들을 처음 값으로 정한다
	if iniVersion {
		if !getStringsStarted() {
			goto finalEnd
		}
		initPrim() // 원시 명령마다 |primitive|를 부른다
		initStrPtr = strPtr; initPoolPtr = poolPtr; fixDateAndTime()
	}
	readyAlready = 314159
startOfTEX:
	@<출력 루틴들을 초기화한다@>
	@<입력의 첫 줄을 얻고 시작할 준비를 한다@>
	history = spotless // 출발 준비 완료!
	mainControl() // 살아난다
	finalCleanup() // 죽을 준비를 한다
	closeFilesAndTerminate() // |endOfTEX|
finalEnd:
	readyAlready = 0
	@<터미널의 마지막 줄을 끝내고 출력 버퍼를 비운다@>
}

@ 터미널의 마지막 줄이 끝나지 않았으면 줄 끝을 손수 덧붙이고, 버퍼에 남은 터미널 출력도 비운다.

@<터미널의 마지막 줄을 끝내고...@>=
if termOffset > 0 {
	wtermCr()
}
updateTerminal()

@ 다음은 바깥 레이블로 가는 |panic|을 받는 함수다. 그 밖의 |panic|은 진짜 사고이므로 다시 일으킨다.

@<바깥 레이블로 가는...@>=
defer func() {
	r := recover()
	if r == nil {
		return
	}
	if r == endOfTEX {
		closeFilesAndTerminate()
	} else if r != finalEnd {
		panic(r)
	}
	readyAlready = 0 // |finalEnd|
	@<터미널의 마지막 줄을 끝내고 출력 버퍼를 비운다@>
}()

@ 주 프로그램은 뼈대의 끝에 둔다. 그 줄거리는 간단하다. 내부 상수들이 서로 맞는지 검사하고, 표를 초기화하고, 입력의 첫 줄을 읽은 다음
|mainControl|에 일을 맡긴다. 그것이 돌아오면 뒷정리를 하고 파일들을 닫는다.

@<함수들@>=
@<주 프로그램@>

@ 여기서는 지역 운영체제에서 \TeX의 일을 우아하게 마치는 데 필요한 일은 무엇이든 한다. 이 코드는 치명적 오류 뒤에도 돌 수 있다. 그러므로
오류 메시지를 낼 일이 없는 ``안전한'' 연산으로만 이루어져야 한다. 이를테면 여기서 |strRoom|이나 |makeString|을 부르면 안 된다.
그러면 |overflow|를 부르게 되어 끝없는 루프에 빠질 수도 있다.
@^system dependencies@>
(실은 |prepareMag|를 거쳐 오류 메시지가 나올 수 있는 길이 하나 있다. 그러나 그것으로 끝없는 재귀가 일어나지는 않는다.)
@^recursion@>

프로시저 |finalCleanup|을 건너뛰고 여기 오면, 이 프로그램은 아직 열려 있을지도 모르는 입력 파일들을 굳이 닫지 않는다.

@<마지막 순간의...@>=
func closeFilesAndTerminate() {
	var k int32 // 만능 첨자
	@<확장들을 마무리한다@>
	setNewLineChar(-1)
	if stat && tracingStats() > 0 {
		@<이 작업에 관한 통계를 출력한다@>
	}
	wakeUpTerminal(); @<\.{DVI} 파일을 마무리한다@>
	if logOpened {
		wlogCr(); aClose(&logFile); selector -= 2
		if selector == termOnly {
			printNl("Transcript written on ")
@.Transcript written...@>
			slowPrint(logName); printChar('.')
		}
	}
}

@ 이 절은 |printStr| 명령을 쓰지 않고 기록 파일에 바로 쓴다. 그래야 {\bf stat} 판이 아닌 \TeX에서 이 문자열들이 |strPool| 메모리를
차지하지 않는다.

@<이 작업에 관한 통계를...@>=
if logOpened {
	wlogLn(" ")
	wlogLn("Here is how much of TeX's memory", " you used:")
@.Here is how much...@>
	wlog(" ", strPtr-initStrPtr, " string")
	if strPtr != initStrPtr+1 {
		wlog("s")
	}
	wlogLn(" out of ", maxStrings-initStrPtr)
	wlogLn(" ", poolPtr-initPoolPtr, " string characters out of ", poolSize-initPoolPtr)
	wlogLn(" ", loMemMax-memMin+memEnd-hiMemMin+2, " words of memory out of ", memEnd+1-memMin)
	wlogLn(" ", csCount, " multiletter control sequences out of ", hashSize)
	@<글꼴, 하이픈 넣기, 스택에 관한 통계를 출력한다@>
}

@ 앞 절의 코드에서 떼어 낸 부분이다. 스택 통계에서 `\.{5i,4n,...}'의 글자는 차례로 입력 스택, 의미 둥지, 매개변수 스택, 버퍼, 저장
스택을 뜻한다.

@<글꼴, 하이픈 넣기, 스택에...@>=
wlog(" ", fmemPtr, " words of font info for ", fontPtr-fontBase, " font")
if fontPtr != fontBase+1 {
	wlog("s")
}
wlogLn(", out of ", fontMemSize, " for ", fontMax-fontBase)
wlog(" ", hyphCount, " hyphenation exception")
if hyphCount != 1 {
	wlog("s")
}
wlogLn(" out of ", hyphSize)
wlogLn(" ", maxInStack, "i,", maxNestStack, "n,", maxParamStack, "p,",
	maxBufStack+1, "b,", maxSaveStack+6, "s stack positions out of ",
	stackSize, "i,", nestSize, "n,", paramSize, "p,", bufSize, "b,", saveSize, "s")

@ 명령 \.{\\end}나 \.{\\dump}를 훑었고 |itsAllOver|이면 루틴 |finalCleanup|에 이른다. 아직 열려 있는 입력을 모두 닫고, 끝나지 않은 그룹이나
조건문이 있으면 알린다. 명령 \.{\\dump}이면 \.{INITEX}에서만 포맷 파일을 덤프한다. 덤프하기 전에 표시와 마지막 글루가 쥐고 있는 참조를
놓아 둔다. 그래야 포맷 파일에 쓸데없는 것이 남지 않는다.

@<마지막 순간의...@>=
func finalCleanup() {
	c := curChr // \.{\\end}이면 0, \.{\\dump}이면 1
	if c != 1 {
		setNewLineChar(-1)
	}
	if jobName == 0 {
		openLogFile()
	}
	for inputPtr > 0 {
		if state == tokenList { endTokenList() } else { endFileReading() }
	}
	for openParens > 0 {
		printStr(" )"); openParens--
	}
	if curLevel > levelOne {
		printNl("("); printEsc("end occurred ")
		printStr("inside a group at level ")
@:end_}{\.{(\\end occurred...)}@>
		printInt(curLevel - levelOne); printChar(')')
	}
	@<끝나지 않은 조건문들을 알리고 없앤다@>
	if history != spotless && (history == warningIssued || interaction < errorStopMode) &&
		selector == termAndLog {
		selector = termOnly
		printNl("(see the transcript file for additional information)")
@.see the transcript file...@>
		selector = termAndLog
	}
	if c == 1 {
		if iniVersion {
			for c = topMarkCode; c <= splitBotMarkCode; c++ {
				if curMark[c] != null {
					deleteTokenRef(curMark[c])
				}
			}
			if lastGlue != maxHalfword {
				deleteGlueRef(lastGlue)
			}
			storeFmtFile(); return
		}
		printNl("(\\dump is performed only by INITEX)"); return
@:dump_}{\.{\\dump...only by INITEX}@>
	}
}

@ 앞 절의 코드에서 떼어 낸 부분이다. 끝나지 않은 조건문을 안쪽부터 하나씩 알리고 없앤다.

@<끝나지 않은 조건문들을...@>=
for condPtr != null {
	printNl("("); printEsc("end occurred ")
	printStr("when "); printCmdChr(ifTest, curIf)
	if ifLine != 0 {
		printStr(" on line "); printInt(ifLine)
	}
	printStr(" was incomplete)")
	ifLine = ifLineField(condPtr)
	curIf = subtype(condPtr); tempPtr = condPtr
	condPtr = link(condPtr); freeNode(tempPtr, ifNodeSize)
}

@ 이 프로시저는 \.{INITEX}에서만 쓰인다. 원시 명령을 모두 해시 표에 넣는다. 이 동안에만 새 제어 시퀀스를 만들 수 있다.

@<마지막 순간의...@>=
func initPrim() { // 모든 원시 명령을 초기화한다
	noNewControlSequence = false
	@<\TeX의 원시 명령을 저마다 해시 표에 넣는다@>
	noNewControlSequence = true
}

@ \seclabel{startup}다음 코드가 시작될 때 \TeX의 표에는 아직 쓰레기가 들어 있을 수도 있다. 문자열조차 없을지 모른다. 그러므로 조심스럽게
한 걸음씩 나아가며 스스로를 일으켜 세워야 한다.

포맷이 미리 불려 있지 않거나 첫 줄이 `\.\&'로 시작하면 포맷 파일을 읽는다. 첫 줄의 나머지가 제어 시퀀스로 시작하지 않으면 그것을
파일 이름으로 보고 \.{\\input}한다.

프로그램의 이 부분을 마치면 \TeX은 |mainControl| 루틴을 불러 일을 시킬 준비가 된다.

@<입력의 첫 줄을 얻고...@>=
@<입력 루틴들을 초기화한다@>
if formatIdent == 0 || buffer[loc] == '&' {
	if formatIdent != 0 {
		initialize() // 미리 불러 둔 포맷을 지운다
	}
	if !openFmtFile() {
		goto finalEnd
	}
	if !loadFmtFile() {
		wClose(&fmtFile); goto finalEnd
	}
	wClose(&fmtFile)
	for loc < limit && buffer[loc] == ' ' {
		loc++
	}
}
if endLineCharInactive() {
	limit--
} else {
	buffer[limit] = endLineChar()
}
fixDateAndTime()
@<마법의 오프셋을 계산한다@>
@<|interaction|에 따라 찍기 |selector|를 초기화한다@>
if loc < limit && catCode(buffer[loc]) != escape {
	startInput() // \.{\\input}을 가정한다
}

@* 디버깅.
\TeX이 일단 돌아가면 \.{\\show} 명령과 다른 진단 기능으로 대부분의 오류를 진단할 수 있을 것이다. 그러나 디버깅의 초기 단계나 정말로 깊은
수수께끼를 밝힐 때는 \TeX을 컴파일할 때 실행 시간 검사와 디버거 같은 도구 몇 가지를 더 넣을 수 있다. 오류 메시지 뒤에 `\.D'를 치면
|debugHelp|라는 루틴이 돈다. 이 루틴은 치명적 오류로 \TeX이 굴복하기 바로 전에도 나타난다.
@^debugging@>
@^system dependencies@>

루틴 |debugHelp|와 주고받는 방식은 원시적이다. 그러나 중단점을 걸고 변수를 읽고 값을 바꿀 수 있는 디버거와 함께 쓰면 충분하다.
`\.{debug \#}'라는 재촉 기호가 나오면 음수(|debugHelp|를 빠져나간다)나 0(중단점을 걸 수 있는 곳으로 가서 디버거와 대화한다)을 치거나,
양수 |m|과 그 뒤에 인자 |n|을 친다. 두 수 |m|과 |n|의 뜻은 아래 프로그램을 보면 분명할 것이다. (|m=13|이면 인자 |l|이 하나 더 있다.)
@.debug \#@>

이 프로시저는 |debug|가 참일 때에만 불린다. 터미널에서 수를 읽을 때는 |fmt.Fscan|을 쓴다.

@<마지막 순간의...@>=
func debugHelp() { // 여러 가지를 보이는 루틴
	var k, l, m, n int32
	clearTerminal()
	for {
		wakeUpTerminal()
		printNl("debug # (-1 to exit):"); updateTerminal()
@.debug \#@>
		fmt.Fscan(termIn.r, &m)
		if m < 0 {
			return
		} else if m == 0 {
			goto breakpoint // 선언한 모든 레이블에 적어도 한 번은 간다
		breakpoint:
			m = 0 // `BREAKPOINT'
		} else {
			fmt.Fscan(termIn.r, &n)
			switch m {
			@<|debugHelp|의 번호 붙은 경우들@>
			default: printStr("?")
			}
		}
	}
}

@ 명령 번호 |m|마다 하는 일이다. 메모리 낱말을 여러 꼴로 보이거나, 상자나 토큰 목록을 보이거나, 메모리를 검사하거나, 어떤 위치를
가리키는 포인터를 찾는다. 16번은 |panicking| 스위치를 켜고 끈다.
@<|debugHelp|의 번호 붙은...@>=
case 1: printWord(mem[n]) // |mem[n]|을 모든 꼴로 보인다
case 2: printInt(info(n))
case 3: printInt(link(n))
case 4: printWord(eqtb[n])
case 5: printWord(fontInfo[n])
case 6: printWord(saveStack[n])
case 7: showBox(n) // |showBoxDepth|와 |showBoxBreadth|로 줄여서 상자를 보인다
case 8:
	breadthMax = 10000; depthThreshold = poolSize - poolPtr - 10
	showNodeList(n) // 상자를 온전히 보인다
case 9: showTokenList(n, null, 1000)
case 10: slowPrint(n)
case 11: checkMem(n > 0) // 올바른지 검사한다; |n>0|이면 새로 쓰는 위치를 찍는다
case 12: searchMem(n) // |n|을 가리키는 포인터를 찾는다
case 13: fmt.Fscan(termIn.r, &l); printCmdChr(n, l)
case 14:
	for k = 0; k <= n; k++ {
		printStr(buffer[k])
	}
case 15: fontInShortDisplay = nullFont; shortDisplay(n)
case 16: panicking = !panicking

@* 확장.
위의 프로그램에는 \TeX의 기본 구조를 흐트러뜨리지 않고 기능을 보탤 수 있게 해 주는 ``갈고리''가 여럿 들어 있다. 이 갈고리는 대부분
특별한 목적에 쓰는 ``whatsit'' 노드와 관련되어 있다. \TeX을 확장하면서 새 종류의 whatsit 노드를 들여올 때마다, 그런 노드를 다루는
아래 루틴들을 거기에 맞게 고쳐야 한다. 그러나 대개 이 프로그램의 다른 부분은 그리 많이 고치지 않아도 될 것이다.

확장을 어떻게 만드는지 보여 주려고, `\.{\\write}', `\.{\\openout}', `\.{\\closeout}', `\.{\\immediate}', `\.{\\special}',
`\.{\\setlanguage}'를 마치 확장인 것처럼 다루겠다. 이 명령들은 실은 \TeX의 원시 명령이고, 이 시스템의 모든 구현에 있어야 한다. 그러나
그렇지 않다고 상상해 보자. 그러면 아래 프로그램은 누군가가 그것들을 어떻게 보탤 수 있는지 보여 주는 본보기가 된다.

물론 확장하려면 \TeX 자체를 고쳐야 할 때도 있다. 어떤 갈고리 체계도 생각할 수 있는 모든 확장을 다 받아 줄 만큼 완전할 수는 없다.
명령 `\.{\\write}'에 관련된 기능은 거의 모두 다음 절들에 모여 있다. 그러나 |printLn|과 |printChar| 프로시저에는 \.{\\write} 문자 때문에 들여온
작은 부분이 있다. 게다가 훑개가 알아보는 토큰 목록 가운데 하나가 |writeText|이고, \.{\\write}의 이런저런 면을 위해 마련해 둔 곳이 몇 군데
더 있다. \TeX을 확장하는 사람은 프로그램의 표준 부분을 고치는 일을 될 수 있는 대로 줄이고, 할 수 있으면 아예 피하는 것을 목표로 삼아야
한다. 또 \TeX이 이미 가진 표준 기능으로는 원하는 것을 쉽게 이룰 길이 정말 없는지 확인해야 한다. ``확장하기 전에 세 번 생각하라.''
그러면 수고도 많이 덜고, 서로 맞지 않는 \TeX의 확장들이 퍼지는 것도 막을 수 있다.
@^system dependencies@>
@^extensions to \TeX@>

@ 먼저 \.{\\write}와 그 친척들에 딸린 자료를 담는 whatsit 노드의 꼴을 생각해 보자. whatsit은 \ID{type}${}={}$|whatsitNode|이고, |subtype|이
whatsit의 종류를 구별한다는 것을 떠올리자. 노드는 두 낱말 이상을 차지한다. 정확한 낱말 수는 |subtype|이나 다른 자료로 쉽게 알아낼 수
있기만 하면 몇이든 상관없다.

여기서는 제어 시퀀스 \.{\\openout}, \.{\\write}, \.{\\closeout}, \.{\\special}, \.{\\setlanguage}에 대응하는 |subtype| 값 다섯을 들여온다.
입출력 whatsit의 둘째 낱말에는 쓰기 스트림 번호를 담는 |writeStream| 필드가 있다. 번호는 0부터 15까지이고, 범위를 벗어난 양수는 16,
음수는 17로 나타낸다. 명령 \.{\\write}와 \.{\\special}의 노드에는 내보낼 토큰 목록의 참조 횟수를 가리키는 필드도 있다. 그리고
\.{\\openout}의 노드에는 파일 이름, 영역, 확장자의 문자열 번호를 담을 하위 필드 셋이 필요하므로 한 낱말을 더 쓴다.

@<정의@>=
const (
	@!writeNodeSize = 2 // write/whatsit 노드의 낱말 수
	@!openNodeSize = 3 // open/whatsit 노드의 낱말 수
	@!openNode = 0 // \.{\\openout}할 파일을 나타내는 whatsit의 |subtype|
	@!writeNode = 1 // \.{\\write}할 것을 나타내는 whatsit의 |subtype|
	@!closeNode = 2 // \.{\\closeout}할 스트림을 나타내는 whatsit의 |subtype|
	@!specialNode = 3 // \.{\\special}한 것을 나타내는 whatsit의 |subtype|
	@!languageNode = 4 // 현재 언어를 바꾸는 whatsit의 |subtype|
)

func whatLang(p pointer) halfword { return link(p + 1) } // 언어 번호; |0..255|
func setWhatLang(p pointer, v halfword) { setLink(p+1, v) }
func whatLhm(p pointer) quarterword { return typ(p + 1) } // 최소 왼쪽 조각; |1..63|
func setWhatLhm(p pointer, v quarterword) { setType(p+1, v) }
func whatRhm(p pointer) quarterword { return subtype(p + 1) } // 최소 오른쪽 조각; |1..63|
func setWhatRhm(p pointer, v quarterword) { setSubtype(p+1, v) }

@ 앞 절의 정의가 이어진다. 필드를 읽고 쓰는 함수들이다.

@<정의@>=
func writeTokens(p pointer) halfword { return link(p + 1) } // 쓸 토큰 목록의 참조 횟수
func setWriteTokens(p pointer, v halfword) { setLink(p+1, v) }
func writeStream(p pointer) halfword { return info(p + 1) } // 스트림 번호(0부터 17까지)
func setWriteStream(p pointer, v halfword) { setInfo(p+1, v) }
func openName(p pointer) strNumber { return link(p + 1) } // 열 파일 이름의 문자열 번호
func setOpenName(p pointer, v strNumber) { setLink(p+1, v) }
func openArea(p pointer) strNumber { return info(p + 2) } // |openName|의 파일 영역의 문자열 번호
func setOpenArea(p pointer, v strNumber) { setInfo(p+2, v) }
func openExt(p pointer) strNumber { return link(p + 2) } // |openName|의 파일 확장자의 문자열 번호
func setOpenExt(p pointer, v strNumber) { setLink(p+2, v) }

@ 쓸 수 있는 \.{\\write} 스트림 열여섯 개는 배열 |writeFile|로 나타낸다. 원소 |writeOpen[j]|가 |true|일 때, 그리고 오직 그때에만 |j|번째
파일이 열려 있다. 마지막 두 원소는 특별하다. 원소 |writeOpen[16]|은 15보다 큰 스트림 번호를, |writeOpen[17]|은 음수 스트림 번호를
나타내며, 늘 |false|다. 그래서 이런 번호로 쓴 것은 터미널이나 기록 파일로 간다.

@<전역 변수@>=
var @!writeFile [16]alphaFile
var @!writeOpen [18]bool

@ 처음에는 열린 스트림이 없다.
@<핵심 변수들의...@>=
for k = 0; k <= 17; k++ {
	writeOpen[k] = false
}

@ 확장은 새 명령 코드를 들여올 수도 있다. 그러나 할 수 있으면 명령 코드 |extension|에 수정자를 붙여 쓰는 것이 가장 좋다. 그러면
|mainControl|을 고치지 않아도 된다.

@<정의@>=
const (
	@!immediateCode = 4 // \.{\\immediate}의 명령 변경자
	@!setLanguageCode = 5 // \.{\\setlanguage}의 명령 변경자
)

@ 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("openout", extension, openNode)
@!@:open_out_}{\.{\\openout} primitive@>
primitive("write", extension, writeNode); writeLoc = curVal
@!@:write_}{\.{\\write} primitive@>
primitive("closeout", extension, closeNode)
@!@:close_out_}{\.{\\closeout} primitive@>
primitive("special", extension, specialNode)
@!@:special_}{\.{\\special} primitive@>
primitive("immediate", extension, immediateCode)
@!@:immediate_}{\.{\\immediate} primitive@>
primitive("setlanguage", extension, setLanguageCode)
@!@:set_language_}{\.{\\setlanguage} primitive@>

@ 방금 들여온 변수 |writeLoc|은 쓰기 텍스트가 ``폭주''할 때 알맞은 오류 메시지를 내는 데 쓴다.

@<전역 변수@>=
var @!writeLoc pointer // \.{\\write}의 |eqtb| 주소

@ 확장 명령들의 이름을 찍는다.
@<원시 명령의 이름을 찍는...@>=
case extension:
	switch chrCode {
	case openNode: printEsc("openout")
	case writeNode: printEsc("write")
	case closeNode: printEsc("closeout")
	case specialNode: printEsc("special")
	case immediateCode: printEsc("immediate")
	case setLanguageCode: printEsc("setlanguage")
	default: printStr("[unknown extension!]")
	}

@ 명령 |extension|이 어느 모드에서든 |mainControl|에 나타나면 루틴 |doExtension|을 부른다.

@<\TeX의 확장을 위한...@>=
case vmode + extension, hmode + extension, mmode + extension: doExtension()

@ 프로시저 |doExtension|은 확장 명령마다 알맞은 일을 하도록 갈라진다.
@<|mainControl|이 쓰는 동작...@>=
@<|doExtension|에 필요한 프로시저들@>@;
func doExtension() {
	var k int32 // 만능 정수
	var p pointer // 만능 포인터
	switch curChr {
	case openNode: @<\.{\\openout}을 구현한다@>
	case writeNode: @<\.{\\write}를 구현한다@>
	case closeNode: @<\.{\\closeout}을 구현한다@>
	case specialNode: @<\.{\\special}을 구현한다@>
	case immediateCode: @<\.{\\immediate}를 구현한다@>
	case setLanguageCode: @<\.{\\setlanguage}를 구현한다@>
	default: confusion("ext1")
@:this can't happen ext1}{\quad ext1@>
	}
}

@ 다음은 주어진 |subtype|과 주어진 낱말 수를 가진 whatsit 노드를 만드는 서브루틴이다. whatsit의 첫 낱말만 초기화하고, 그것을 현재 목록에
덧붙인다.


@<|doExtension|에 필요한...@>=
func newWhatsit(s smallNumber, w smallNumber) {
	p := getNode(w) // 새 노드
	setType(p, whatsitNode); setSubtype(p, s)
	setLink(tail, p); tail = p
}

@ 다음 서브루틴은 |curChr|로 whatsit의 종류를 정하고, |writeStream| 번호도 넣는다. 명령 \.{\\openout}에서는 0부터 15까지만 허락하지만,
\.{\\write}와 \.{\\closeout}에서는 아무 정수나 쓸 수 있다.

@<|doExtension|에 필요한...@>=
func newWriteWhatsit(w smallNumber) {
	newWhatsit(curChr, w)
	if w != writeNodeSize {
		scanFourBitInt()
	} else {
		scanInt()
		if curVal < 0 {
			curVal = 17
		} else if curVal > 15 {
			curVal = 16
		}
	}
	setWriteStream(tail, curVal)
}

@ 명령 \.{\\openout}은 파일 이름을 읽어 노드에 담아 둔다. 실제로 파일을 여는 것은 그 노드를 내보낼 때다.
@<\.{\\openout}을 구현한다@>=
newWriteWhatsit(openNodeSize)
scanOptionalEquals(); scanFileName()
setOpenName(tail, curName); setOpenArea(tail, curArea); setOpenExt(tail, curExt)

@ 명령 `\.{\\write 12\{...\}}'가 나타나면 토큰 목록 `\.{\{...\}}'를 매크로를 펼치지 않고 훑는다. 매크로는 나중에 이 토큰 목록을 다시
훑을 때 펼친다. 그래야 쪽 번호처럼 쪽을 내보낼 때에야 정해지는 값을 쓸 수 있다.

@<\.{\\write}를 구현한다@>=
k = curCs; newWriteWhatsit(writeNodeSize)
curCs = k; p = scanToks(false, false); setWriteTokens(tail, defRef)

@ 명령 \.{\\closeout}의 노드는 토큰 목록이 없다는 것만 빼면 \.{\\write}의 노드와 같다.
@<\.{\\closeout}을 구현한다@>=
newWriteWhatsit(writeNodeSize); setWriteTokens(tail, null)

@ 명령 `\.{\\special\{...\}}'가 나타나면 \.{\\xdef}와 \.{\\mark}에서처럼 토큰 목록의 매크로를 곧바로 펼친다.

@<\.{\\special}을 구현한다@>=
newWhatsit(specialNode, writeNodeSize); setWriteStream(tail, null)
p = scanToks(false, true); setWriteTokens(tail, defRef)

@ 우리 자료 구조에 새 종류의 노드가 나타나면, 그것을 보이고 베끼고 없애는 따위의 일을 모두 할 수 있어야 한다. 쓰기 관련 whatsit에
필요한 루틴은 표시 노드의 루틴과 조금 비슷하다. 물론 다른 확장에서는 여기서 더 미묘한 것이 끼어들 수도 있다.

@<기본 인쇄...@>=
func printWriteWhatsit(s string, p pointer) {
	printEsc(s)
	if writeStream(p) < 16 {
		printInt(writeStream(p))
	} else if writeStream(p) == 16 {
		printChar('*')
	} else {
@.*\relax@>
		printChar('-')
	}
}

@ whatsit 노드는 `\.{\\write3\{...\}}'나 `\.{\\openout3=foo}'처럼 보인다. 스트림 번호가 15보다 크면 `\.*'를, 음수이면 `\.-'를 찍는다.
@<whatsit 노드 |p|를 보인다@>=
switch subtype(p) {
case openNode:
	printWriteWhatsit("openout", p)
	printChar('='); printFileName(openName(p), openArea(p), openExt(p))
case writeNode:
	printWriteWhatsit("write", p)
	printMark(writeTokens(p))
case closeNode: printWriteWhatsit("closeout", p)
case specialNode:
	printEsc("special")
	printMark(writeTokens(p))
case languageNode:
	printEsc("setlanguage")
	printInt(whatLang(p)); printStr(" (hyphenmin ")
	printInt(whatLhm(p)); printChar(',')
	printInt(whatRhm(p)); printChar(')')
default: printStr("whatsit?")
}

@ whatsit 노드를 베낄 때는 토큰 목록을 베끼지 않고 참조 횟수만 늘린다.
@<whatsit 노드 |p|의 부분 사본 |r|를...@>=
switch subtype(p) {
case openNode: r = getNode(openNodeSize); words = openNodeSize
case writeNode, specialNode:
	r = getNode(writeNodeSize)
	addTokenRef(writeTokens(p)); words = writeNodeSize
case closeNode, languageNode: r = getNode(smallNodeSize); words = smallNodeSize
default: confusion("ext2")
@:this can't happen ext2}{\quad ext2@>
}

@ whatsit 노드를 지울 때는 토큰 목록의 참조 횟수를 줄인다.
@<whatsit 노드 |p|를 지우고...@>=
switch subtype(p) {
case openNode: freeNode(p, openNodeSize)
case writeNode, specialNode:
	deleteTokenRef(writeTokens(p))
	freeNode(p, writeNodeSize); goto done
case closeNode, languageNode: freeNode(p, smallNodeSize)
default: confusion("ext3")
@:this can't happen ext3}{\quad ext3@>
}
goto done

@ 세로 상자를 꾸릴 때 whatsit 노드는 치수에 아무 영향도 주지 않는다.
@<whatsit 노드를 세로 상자에...@>=
// 아무것도 하지 않는다

@ 가로 상자를 꾸릴 때도 마찬가지다.
@<whatsit 노드를 가로 상자에...@>=
// 아무것도 하지 않는다

@ 따로 세운 수식 앞 줄의 너비를 잴 때 whatsit 노드의 너비는 0이다.
@<|d|를 whatsit |p|의 너비로...@>=
d = 0

@ 언어 whatsit 노드를 지나갈 때 쓰는 작은 함수 |advPast|는 두 곳에서 쓰이고 전역 변수만 쓴다. 노드에 담긴 언어와 하이픈 최소 길이를
현재 값으로 삼는다.

@<정의@>=
func advPast(p pointer) {
	if subtype(p) == languageNode {
		curLang = whatLang(p); lHyf = whatLhm(p); rHyf = whatRhm(p)
	}
}

@ 줄 나눔 루프에서 whatsit 노드를 만나면 언어 정보를 갱신한다.
@<|lineBreak| 루프에서 whatsit 노드를...@>=
advPast(curP)

@ 하이픈 넣기 전처리 루프에서도 마찬가지다.
@<하이픈 넣기 전처리 루프에서 whatsit...@>=
advPast(s)

@ 쪽 조립기에서 whatsit 노드는 그냥 현재 쪽으로 옮긴다.
@<whatsit |p|를 현재 쪽으로...@>=
goto contribute

@ 세로 목록을 나눌 때 whatsit 노드는 나눔 후보가 아니다.
@<|vertBreak| 루프에서 whatsit...@>=
goto notFound

@ 세로 목록을 내보낼 때 whatsit 노드는 |outWhat|이 처리한다.
@<세로 목록에서 whatsit 노드...@>=
outWhat(p)

@ 가로 목록을 내보낼 때도 마찬가지다.
@<가로 목록에서 whatsit 노드...@>=
outWhat(p)

@ 이 모든 준비를 마치고, 드디어 요청된 자료를 실제로 내보내는 루틴들에 이르렀다. 명령 \.{\\special}부터 하자(그것이 더 쉽다). 토큰
목록을 문자열로 바꾸어 \.{DVI} 파일의 |xxx1|이나 |xxx4| 명령에 담는다. 문자열은 쓰고 나면 바로 지운다.

@<|hlistOut|과 |vlistOut|에 필요한...@>=
func specialOut(p pointer) {
	var k poolPointer // |strPool|의 첨자
	synchH(); synchV()
	oldSetting := selector // 찍기 |selector|를 담아 둔다; |0 .. maxSelector|
	selector = newString
	showTokenList(link(writeTokens(p)), null, poolSize-poolPtr)
	selector = oldSetting
	strRoom(1)
	if curLength() < 256 {
		dviOut(xxx1); dviOut(curLength())
	} else {
		dviOut(xxx4); dviFour(curLength())
	}
	for k = strStart[strPtr]; k <= poolPtr-1; k++ {
		dviOut(so(strPool[k]))
	}
	poolPtr = strStart[strPtr] // 문자열을 지운다
}

@ 토큰 목록을 쓰려면 그것을 \TeX의 훑개에 통과시켜 매크로와 \.{\\the}와 \.{\\number} 따위를 펼쳐야 한다. 그런데 그러다 보면 구분된
매크로 매개변수가 짝을 찾지 못해 폭주가 일어날 수 있다. 지금은 \.{\\shipout} 명령 한가운데에서 \TeX의 훑개를 부르는 것이니, 폭주가
일어나면 몹시 헷갈릴 것이다. 그래서 토큰 목록 바로 뒤에 가짜 제어 시퀀스를 ``마개''로 놓는다. 이 제어 시퀀스는 일부러 \.{\\outer}로
정의해 둔다.
@:end_write_}{\.{\\endwrite}@>

@<표의 항목들을 초기화한다...@>=
setText(endWrite, str("endwrite")); setEqLevel(endWrite, levelOne)
setEqType(endWrite, outerCall); setEquiv(endWrite, null)

@ 프로시저 |writeOut|은 토큰 목록을 펼친 다음 해당 스트림에 쓴다. 파일이 열려 있지 않으면 터미널과 기록 파일에 쓴다. 다만 스트림
번호가 음수이면 기록 파일에만 쓴다.
@<|hlistOut|과 |vlistOut|에 필요한...@>=
func writeOut(p pointer) {
	@<토큰 목록의 매크로를 펼치고 |link(defRef)|가 그 결과를 가리키게 한다@>
	oldSetting := selector // 찍기 |selector|를 담아 둔다; |0 .. maxSelector|
	j := writeStream(p) // 쓰기 스트림 번호
	if writeOpen[j] {
		selector = j
	} else { // 파일이 열려 있지 않으면 터미널에 쓴다
		if j == 17 && selector == termAndLog {
			selector = logOnly
		}
		printNl("")
	}
	tokenShow(defRef); printLn()
	flushList(defRef); selector = oldSetting
}

@ 다음 절에 나오는 루틴의 마지막 줄은 조금 미묘하다. 적어도 저자는 데어 보기 전까지는 그것을 생각하지 못했다! 스택에는 다 쓴 토큰 목록이
@^Knuth, Donald Ervin@>
하나 남아 있다. 곧 |endWriteToken|을 담았던 것이다. (위에서 말했듯이 폭주를 막으려고 이 인위적인 `\.{\\endwrite}'를 끼워 넣는다.) 그것을
없애지 않으면 한 쪽에 쓰기가 많을 때 스택이 넘칠 것이다.

@<정의@>=
const @!endWriteToken = csTokenFlag + endWrite

@ 토큰 목록 앞뒤에 중괄호와 `\.{\\endwrite}'를 끼워 넣어 `\.\{$\langle\,$토큰 목록$\,\rangle$\.{\} \\endwrite}'를 만든 다음 그것을
훑는다. 이때 |mode=0|으로 해 둔다. 그러면 \.{\\prevdepth}나 \.{\\spacefactor} 같은 것을 쓸 수 없어서, 쪽을 내보내는 도중에 엉뚱한 목록을
들여다보는 일이 없다.

@<토큰 목록의 매크로를 펼치고...@>=
q := getAvail() // 목록을 다루는 임시 변수
setInfo(q, rightBraceToken+'}')
r := getAvail(); setLink(q, r); setInfo(r, endWriteToken); insList(q)
beginTokenList(writeTokens(p), writeText)
q = getAvail(); setInfo(q, leftBraceToken+'{'); insList(q)
oldMode := mode // 저장된 |mode|
mode = 0
// \.{\\prevdepth}, \.{\\spacefactor}, \.{\\lastskip}, \.{\\prevgraf}를 끈다
curCs = writeLoc; q = scanToks(false, true) // 매크로 따위를 펼친다
getToken()
if curTok != endWriteToken {
	@<균형이 맞지 않는 쓰기 명령에서 회복한다@>
}
mode = oldMode
endTokenList() // 스택 공간을 아낀다

@ 토큰 목록에 오른쪽 중괄호가 더 많아서 \.{\\endwrite}에 이르기 전에 훑기가 끝났다. 알리고, 마개가 나올 때까지 토큰을 버린다.
@<균형이 맞지 않는 쓰기 명령에서...@>=
printErr("Unbalanced write command")
@.Unbalanced write...@>
help2("On this page there's a \\write with fewer real {'s than }'s.",
	"I can't handle that very well; good luck.")
reportError()
for {
	getToken()
	if curTok == endWriteToken {
		break
	}
}

@ 프로시저 |outWhat|는 |vlistOut|과 |hlistOut|을 위해 whatsit 노드를 출력하는 일을 맡는다.

@<|hlistOut|과 |vlistOut|에 필요한...@>=
func outWhat(p pointer) {
	var j smallNumber // 쓰기 스트림 번호
	switch subtype(p) {
	case openNode, writeNode, closeNode: @<\.{\\write}를 위해 미루어 둔 일을 한다@>
	case specialNode: specialOut(p)
	case languageNode: // 아무것도 하지 않는다
	default: confusion("ext4")
@:this can't happen ext4}{\quad ext4@>
	}
}

@ 리더 안의 \.{\\write}는 실행하지 않는다. (리더 상자가 나타나는 횟수는 글루 계산의 기계 의존적 반올림 때문에 구현마다 다를 수 있기
때문이다.) 명령 \.{\\openout}이면 그 스트림을 먼저 닫고 새 파일을 연다. 확장자가 없으면 `\.{.tex}'를 붙인다.
@^leaders@>

@<\.{\\write}를 위해 미루어 둔...@>=
if !doingLeaders {
	j = writeStream(p)
	if subtype(p) == writeNode {
		writeOut(p)
	} else {
		if writeOpen[j] {
			aClose(&writeFile[j])
		}
		if subtype(p) == closeNode {
			writeOpen[j] = false
		} else if j < 16 {
			curName = openName(p); curArea = openArea(p)
			curExt = openExt(p)
			if curExt == str("") {
				curExt = str(".tex")
			}
			packCurName()
			for !aOpenOut(&writeFile[j]) {
				promptFileName("output file name", ".tex")
			}
			writeOpen[j] = true
		}
	}
}

@ 접두어 `\.{\\immediate}'가 있으면 프로시저 |doExtension|은 재귀로 한 수준 내려가서 whatsit 노드를 만들고, 그것을 곧바로 실행한 다음
버린다. 그 뒤에 `\.{\\openout}'이나 `\.{\\write}'나 `\.{\\closeout}'이 오지 않으면 아무 일도 일어나지 않는다.
@^recursion@>

@<\.{\\immediate}를 구현한다@>=
getXToken()
if curCmd == extension && curChr <= closeNode {
	p = tail; doExtension() // whatsit 노드를 덧붙인다
	outWhat(tail) // 그 동작을 곧바로 한다
	flushNodeList(tail); tail = p; setLink(p, null)
} else {
	backInput()
}

@ 확장 \.{\\language}는 조금 다르다. 현재 문단의 언어 |clang|과 다른 \.{\\language} 값에서 문자를 덧붙일 때, 언어가 바뀌었다는 표시를
목록에 남기는 서브루틴이 필요하다. 그 표시가 언어 whatsit 노드다.

@<|mainControl|이 쓰는 동작...@>=
func fixLanguage() {
	var l asciiCode // 새 현재 언어
	if language() <= 0 {
		l = 0
	} else if language() > 255 {
		l = 0
	} else {
		l = language()
	}
	if l != clang() {
		newWhatsit(languageNode, smallNodeSize)
		setWhatLang(tail, l); setClang(l)
		setWhatLhm(tail, normMin(leftHyphenMin()))
		setWhatRhm(tail, normMin(rightHyphenMin()))
	}
}

@ 명령 \.{\\setlanguage}는 가로 모드에서만 쓸 수 있다. 문단의 언어를 \.{\\language}와 상관없이 바꾼다.
@<\.{\\setlanguage}를 구현한다@>=
if abs(mode) != hmode {
	reportIllegalCase()
} else {
	newWhatsit(languageNode, smallNodeSize)
	scanInt()
	if curVal <= 0 {
		setClang(0)
	} else if curVal > 255 {
		setClang(0)
	} else {
		setClang(curVal)
	}
	setWhatLang(tail, clang())
	setWhatLhm(tail, normMin(leftHyphenMin()))
	setWhatRhm(tail, normMin(rightHyphenMin()))
}

@ 일이 끝나면 열린 쓰기 파일을 모두 닫는다.
@<확장들을 마무리한다@>=
for k = 0; k <= 15; k++ {
	if writeOpen[k] {
		aClose(&writeFile[k])
	}
}

@* 시스템에 따른 변경.
필요하면 이 부분을 특정 설치에서 \TeX을 돌리는 데 필요한 특별한 수정으로 채운다. 변경 파일을 설계할 때는 대개 앞 절들을 고치더라도 절
번호가 그대로 남게 하는 것이 가장 좋다. 그러면 누구의 판이든 출판된 프로그램과 맞는다. 새 절을 들여와야 하는 큰 변경은 여기에 끼워
넣으면 된다. 그러면 바뀌는 절 번호는 찾아보기뿐이다.
@^system dependencies@>

이 구현은 시스템에 따른 변경을 여기에 따로 모으지 않고 제자리에 넣어 두었다. 찾아보기의 `system dependencies' 항목에서 그런 곳을 모두
찾을 수 있다. 이를테면 파일 이름과 파일 찾기(\secref{tex-area} 부근), 터미널 입력(\secref{init-terminal}), 낱말 파일의 형식(\secref{dump-words}
부근), 바깥 레이블로 가는 |goto|(\secref{outer-labels}, \secref{main})가 그렇다.

@* 찾아보기.
다음은 프로그램의 각 식별자가 쓰인 곳을 모두 모아 놓은 것이다. 밑줄 친 항목은 그 식별자가 정의된 곳이다. 오류 메시지와 ``이런 일은
일어날 수 없다'' 같은 흥미로운 것들도 찾아볼 수 있다. 특히 ``system dependencies'' 항목을 보면, 다른 컴퓨터에 \TeX을 설치할 때 고쳐야
할지도 모르는 곳을 모두 찾을 수 있다. 미리 정해 둔 몇몇 주제 아래에는 \TeX의 그 부분을 이해하는 데 도움이 될 곳들이 모여 있다.
