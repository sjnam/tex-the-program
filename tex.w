% 이 파일은 크누스의 tex.web(Version 3.141592653, 2021)을 한글 GWEB(Go)로
% 옮긴 것이다. 원본 tex.web (C) 1982 Donald E. Knuth.
% 원본의 조건(``고친 파일은 tex.web이라는 이름을 달아서는 안 된다'')에 따라
% 이 파일은 tex.web이 아니며, 크누스의 TeX 꾸러미의 일부가 아니다.
% 손대지 않은 원본은 CTAN의 systems/knuth/dist/tex/tex.web에 있다.

\input kotexgweb

% 원본 tex.web의 림보에 있던 매크로들
\def\hang{\hangindent 3em\noindent\ignorespaces}
\def\hangg#1 {\hang\hbox{#1 }}
\def\textindent#1{\hangindent2.5em\noindent\hbox to2.5em{\hss#1 }\ignorespaces}
\def\PASCAL{Pascal}
\def\ph{\hbox{Pascal-H}}
\def\pct!{{\char`\%}} % 본문의 퍼센트 기호
\font\logo=logo10 % METAFONT 로고에 쓰는 글꼴
\def\MF{{\logo META}\-{\logo FONT}}
\def\<#1>{$\langle#1\rangle$}
\def\section{\mathhexbox278}
\def\(#1){} % 절 이름이 잘 정렬되도록 쓴다
\def\yskip{\vskip3pt plus1pt}
% 옮긴이가 덧붙인 절은 \dg로 시작한다. 덧붙인 절이 하나 나올 때마다 그 뒤의 절
% 번호는 원본보다 하나씩 커지므로, 원본의 절 번호를 \orignum으로 따로 센다.
% 번호가 서로 다른 절에는 머리에 원본의 번호를 작게 적는다. 또 원본의 번호와 이
% 문서의 번호의 대응을 \jobname.onum에 적어 두었다가, 다음 조판에서 \os{원본
% 번호}가 이 문서의 절 번호로 바뀌어 연결되게 한다(조판을 두 번 해야 한다).
\def\dg{{\bf 보충.}\enspace\ignorespaces}
\newcount\orignum
\def\origmap#1#2{\expandafter\gdef\csname onum:#1\endcsname{#2}}
\openin1=\jobname.onum
\ifeof1 \else \closein1 \input \jobname.onum \fi
\newwrite\onumout
\immediate\openout\onumout=\jobname.onum
\def\os#1{\expandafter\ifx\csname onum:#1\endcsname\relax
    \S#1\else\S\SN{\csname onum:#1\endcsname}\fi}
\def\origtag#1{\global\advance\orignum1
  \immediate\write\onumout{\string\origmap{\the\orignum}{#1}}%
  \ifnum\orignum=#1 \else{\eightrm[원본 \the\orignum]}\enspace\fi}
\let\GWEBM=\M
\def\M#1{\GWEBM{#1}\def\cursec{#1}\futurelet\next\checkorig}
\def\checkorig{\ifx\next\dg\else\origtag\cursec\fi\ignorespaces}
\let\GWEBN=\N
\def\N#1#2#3{\GWEBN{#1}{#2}{#3}\origtag{#2}\ignorespaces}

\def\title{\TeX82}
\def\topofcontents{\null\vfill
  \centerline{\titlefont \TeX82}
  \vskip 15pt
  \centerline{도널드 크누스의 \TeX\ 프로그램을 한글 \.{GWEB}으로 옮김}
  \vfill}
\def\botofcontents{\vfill
  \ninepoint\baselineskip12pt
  \noindent 원본 \copyright\ 1982 Donald E. Knuth
  \bigskip\noindent
  크누스의 원본 파일 \.{tex.web}은 고치지 않는 한 얼마든지 복사하고 배포할 수 있다.
  고친 파일은 이름이 \.{tex.web}이 아닐 때에만 허용된다.
  \bigskip\noindent
  이 문서는 그 조건에 따라 원본을 한글과 \GO/로 옮긴 것이며,
  크누스의 \TeX\ 꾸러미의 일부가 아니다. 손대지 않은 원본은
  {\tt https://mirrors.ctan.org/systems/knuth/dist/tex/tex.web}에서
  받을 수 있다. 번역에 잘못이 있다면 그것은 옮긴이의
  탓이지 크누스의 탓이 아니다.}

% gweave가 형으로 알아보지 못하는 이름들.
@s bufio.Reader int
@s bufio.Writer int
@s os.File int

@* 들어가며.
이것은 \TeX, 곧 품질 높은 조판을 만들어 내려는 문서 컴파일러다.
뒤따르는 \PASCAL\ 프로그램은 \TeX82의 정의다. \TeX82는 \TeX의 표준판으로서,
@^PASCAL@>
@^TeX82@>
이식성이 아주 높도록 설계되어 매우 다양한 컴퓨터에서 똑같은 출력을 얻을 수 있다.

다음 프로그램의 주된 목적은 \TeX의 알고리즘을 될 수 있는 대로 명료하게 설명하는
데 있다. 그 결과로, 특정한 \PASCAL\ 컴파일러가 이 프로그램을 특정한 기계어로
옮겼을 때 아주 효율적이지는 않을 수도 있다. 그러나 이 프로그램은 비교적 적은 수의
변경만으로 매우 다양한 운영 환경에서 효율적으로 돌아가도록 조율할 수 있게 쓰였다.
이런 유연성이 가능한 것은 뒤따르는 문서가 \.{WEB} 언어로 쓰였기 때문이다. \.{WEB}은
\PASCAL보다 높은 수준의 언어이고, \.{WEB}을 \PASCAL로 바꾸는 전처리 단계에서 필요한
다듬기를 대부분 넣을 수 있다. 다른 언어로 반자동 번역하는 것도 가능한데, 아래의
프로그램은 \PASCAL에만 있는 특이한 기능을 그리 많이 쓰지 않기 때문이다.

\TeX\ 같은 큰 소프트웨어에는 일정한 수준 아래로는 줄일 수 없는 본질적인 복잡성이
있다. 비록 낱낱의 부분은 그 자체로는 꽤 단순하더라도 말이다. \.{WEB} 언어는
프로그램의 낱낱의 조각들이 서로 맞물리는 방식을 드러내고, 서로 다른 부분을 잇는
상호 참조를 제공함으로써 알고리즘을 될 수 있는 대로 읽기 쉽게 하려는 것이다.
무슨 일이 일어나고 있는지, 그리고 왜 어떤 일을 어떤 방식으로 했는지에 대한 자세한
설명을 프로그램 곳곳에 넉넉히 뿌려 두었다. 이 설명들은 구현의 특징을 밝히지만,
\TeX\ 언어 자체를 설명하려 들지는 않는다. 독자는 {\sl The \TeX book}에 익숙하다고
여기기 때문이다.
@.WEB@>
@^TeXbook@>

보충: 이 문서는 크누스의 \.{tex.web}을 한글과 \GO/로 옮긴 것이다. 원본의 \PASCAL\
코드는 \GO/ 코드로, 영어 설명은 한글 설명으로 바꾸었다. 옮긴이가 덧붙인 설명은
``보충:''으로 시작하고, 원본에 없던 절을 새로 끼워 넣을 때는 그 절을 \dg 로 시작한다.
그러므로 이런 절이 하나 나올 때마다 그 뒤의 절 번호는 원본(곧 『\TeX: The Program』)의
절 번호보다 하나씩 커진다. 번역의 원칙은 \os3과 \os4의 보충 설명에 모아 두었다.

@ 지금의 구현은 오랜 내력을 지니고 있다. 그것은 1977년 여름, 마이클~F. 플래스와
프랭크~M. 리앙이 그해 5월에 저자가 만든 명세를 바탕으로 원형을 설계하고 짠 데서
시작되었다.
@^Plass, Michael Frederick@>
@^Liang, Franklin Mark@>
@^Knuth, Donald Ervin@>
이 최초의 원형 \TeX에는 매크로 정의와 상자와 글루를 다루는 기본 조작은 들어 있었지만,
줄 나누기, 쪽 나누기, 수식, 정렬 루틴, 오류 복구, 그리고 지금의 의미 둥지(semantic
nest)는 없었다. 게다가 토큰 목록 대신 문자 목록을 썼기 때문에, \.{\\halign} 같은 제어
시퀀스는 일곱 문자의 목록으로 표현되었다. \TeX의 완전한 판은 1977년 말과 1978년
초에 저자가 설계하고 짰다. 그 프로그램은 원형과 마찬가지로 {\mc SAIL} 언어로
쓰였는데, 이 언어에는 훌륭한 디버깅 시스템이 있었다. {\mc SAIL} 코드를 지금의
``웹''과 얼마쯤 비슷한 꼴로 바꾸려는 예비 계획은 1979년 초에 루이스 트랍 파르도와
@^Trabb Pardo, Luis Isidoro@>
저자가 세웠고, 이그나시오~A. 사발라가 1979년과 1980년에 완전한 구현을 만들었다.
@^Zabala Salelles, Ignacio Andr\'es@>
\TeX82 프로그램은 저자가 1981년 후반과 1982년 초반에 쓴 것인데, 여기에는 레오니다스
@^Guibas, Leonidas Ioannis@>
@^Sedgewick, Robert@>
@^Wyatt, Douglas Kirk@>
기바스, 로버트 세지윅, 더글러스 와이엇이 1979년에 제록스 팰로앨토 연구소에서
{\mc MESA}로 쓴 \TeX\ 구현의 착상들도 들어 있다. 처음 구현들에서 얻은 경험을 바탕으로
\TeX82에는 수백 가지 개선이 이루어졌으므로, 시스템의 거의 모든 부분이 상당히
나아졌다. 1982년 9월에 ``Version 0''이 나온 뒤로 이 프로그램은 많은 사람들, 특히
데이비드~R. 퍽스와 하워드~W. 트리키의 의견에서 큰 도움을 받았다.
1989년 9월의 마지막 개정에서는 입력 문자 집합을 8비트 코드로 넓히고, 마이클~J.
퍼거슨의 착상을 바탕으로 여러 언어의 낱말을 하이픈으로 나누는 기능을 넣었다.
@^Fuchs, David Raymond@>
@^Trickey, Howard Wellington@>
@^Ferguson, Michael John@>

의심할 것 없이 아직도 고칠 여지는 많지만, 저자는 이제부터 \TeX82를 ``동결''해
두기로 굳게 마음먹었다. 안정성과 신뢰성이 이 프로그램의 주된 미덕이 될 것이다.

한편 \.{WEB} 서술은 \TeX82 자체의 핵심을 바꾸지 않고도 확장할 수 있으며, 이
프로그램은 그런 확장이 그리 어렵지 않도록 설계되었다. 여기서 정의하는 문자열
|banner|는 \TeX에 어떤 수정이든 가해질 때마다 바꾸어야 한다. 그래야 문제가 생겼을
때 어느 판의 \TeX이 범인인지 분명해진다.
@^extensions to \TeX@>
@^system dependencies@>

이 프로그램을 고친다면 그 결과로 생긴 시스템을 `\TeX'이라고 불러서는 안 된다.
`\TeX'이라는 공식 이름은 서로 완전히 호환되는 소프트웨어 시스템을 위해 남겨 둔
것이다. 어떤 구현이 `\TeX'이라고 불릴 자격이 있는지 판정하는 데 도움을 주는
``\.{TRIP} 시험''이라는 특별한 시험 묶음이 있다[스탠퍼드 대학교 전산학과 보고서
CS1027, 1984년 11월 참조].

보충: 이 번역은 원본을 고친 것이므로, 저자의 부탁에 따라 |banner|에 ``\.{(GWEB)}''을
덧붙여 원본과 구별한다. 원본의 |banner|는 \.{'This is TeX, Version 3.141592653'}이다.

@<정의@>=
const banner = "This is TeX, Version 3.141592653 (GWEB)" // \TeX이 시작할 때 찍는다

@ \PASCAL마다 관례가 조금씩 다르다. 지금의 프로그램은 저자가 1982년에 쓸 수
@^PASCAL H@>
있었던 \PASCAL로 \TeX을 표현한다. 이 특정한 컴파일러를 \ph라고 부르겠다. 이 컴파일러에
맞춘 구성들을 보면, 필요할 때 다른 시스템에 알맞은 인터페이스를 어떻게 만들지 독자가
알 수 있을 것이다. (\ph는 찰스 헤드릭이 고친 컴파일러다.
@^Hedrick, Charles Locke@>
원래는 함부르크 대학교에서 DECsystem-10용으로 개발한 것이다. {\sl Software---Practice
and Experience \bf6} (1976), 29--42쪽 참조. 아래의 \TeX\ 프로그램은 크게 고치지 않고도
다른 대부분의 \PASCAL에 맞출 수 있게 하려는 것이어서, \ph의 훌륭한 기능을 다 쓰지는
않는다. 실은 표준 \PASCAL\ 자체의 몇 가지 특이한 기능도 일부러 피하려고 애썼다.
그래서 코드의 대부분을 다른 고급 언어로 기계적으로 옮길 수 있다. 예컨대 `\KW{with}'와
`|new|' 기능은 쓰지 않았고, 포인터 형, 집합 형, 열거 스칼라 형도 쓰지 않았다. 파일의
경우를 빼면 `\KW{var}' 매개변수도 없다. 가변 레코드에는 태그 필드가 없다. 또 |real:=integer|
꼴의 대입도 없다. 다른 프로시저 안에 지역적으로 선언한 프로시저도 없다.)

시스템에 따라 달라지는 코드, 곧 \PASCAL\ 컴파일러의 차이나 운영체제의 차이 때문에
고쳐야 할지도 모르는 부분은, 찾아보기에서 `system dependencies' 항목에 적힌 번호의
절들을 보면 알 수 있다. 또한 찾아보기의 `dirty \PASCAL' 항목에는 이런저런 까닭으로
\PASCAL의 제약을 완벽하게 지키지 않은 곳이 모두 적혀 있다.
@^system dependencies@>
@^dirty \PASCAL@>

덧붙여 말하면, \PASCAL의 표준 함수 |round|는 IEEE 부동소수점 표준과 어긋나기 때문에
말썽을 일으킬 수 있다. 그래서 많은 구현자가 손수 만든 반올림 프로시저로
바꾸어 쓴다.

보충: 원본이 일부러 \PASCAL의 특이한 기능을 피한 덕분에, 이 프로그램은 \GO/로 거의
기계적으로 옮길 수 있었다. 옮긴이가 따른 원칙은 다음과 같다.
\smallskip
\item{$\bullet$} 식별자는 원본의 이름을 그대로 쓴다. \GO/의 관례인 낙타 등 표기
(|getNext|)로 바꾸지 않고 밑줄 표기(|get_next|)를 그대로 두었다. 그래야 이 문서를
원본이나 『\TeX: The Program』과 나란히 놓고 읽을 수 있다. 다만 \GO/의 예약어와 이름이
같으면 뒤에 밑줄을 붙인다(|type_|, 레이블 \ID{continue\_}).
\item{$\bullet$} \PASCAL의 전역 변수는 \GO/ 꾸러미 수준의 변수가 되고, \PASCAL의
프로시저와 함수는 \GO/의 함수가 된다. 원본에서 한 번만 불리는 프로시저도 원본의 구조를
지키려고 함수로 남겨 두었다.
\item{$\bullet$} \.{WEB} 매크로는 \GO/에 없다. 수를 정의하는 매크로는 \GO/의 상수가
되고, 매개변수가 있는 매크로는 함수가 된다. 메모리의 필드를 가리키는 매크로, 이를테면
|link(p)|처럼 대입문의 왼쪽에도 오는 매크로는 값을 읽는 함수 |link(p)|와 값을 쓰는 함수
|set_link(p,q)|의 짝이 된다.
\item{$\bullet$} \.{WEB}에서는 한 절에 정의부(\.{@@d})와 코드부가 함께 있을 수 있다.
\.{GWEB}의 \.{@@d}는 코드를 만들지 않으므로, 정의부는 \GO/ 코드로 옮겨 이름 있는 절
|@<정의@>|에 둔다. 절의 코드부가 이미 다른 이름의 함수 안쪽 코드라면, 정의부는 그
절 바로 뒤에 덧붙인 절(\dg)로 옮긴다.
\item{$\bullet$} 원본의 |goto|는 \GO/에서 허용되는 한 그대로 |goto|로 옮겼다.
\GO/가 허용하지 않는 곳(블록 안으로 뛰어드는 경우 따위)만 구조를 바꾸고 그 사실을
보충 설명에 밝혔다. 프로시저 바깥으로 뛰는 |goto|는 \GO/의 |panic|과 |recover|로
흉내 낸다.
\smallskip\noindent
그 밖의 원칙, 이를테면 자료형과 문자열을 다루는 방식은 그것이 처음 나오는 곳에서
설명한다.

@ 프로그램은 보통의 \PASCAL\ 프로그램 머리로 시작하는데, 그 구성 요소들은 나중에
\.{WEB}의 관례에 따라 채워진다.
@.WEB@>
이를테면 아래에서 `|@<전역 변수@>|'라고 부르는 프로그램 부분은 변수 선언들의 나열로
바뀔 것이고, 그 나열은 이 문서의 \os{13}에서 시작한다. 이런 방법으로 우리는 낱낱의 전역
변수를 그것이 무엇을 뜻하는지 이해할 준비가 되었을 때 정의할 수 있다. 모든 전역 변수를
한꺼번에 정의할 필요가 없는 것이다. 원한다면 \os{13}의 끝에 ``이 코드는 \dots절에도
정의되어 있다''라고 나오는 상호 참조를 따라가서 전역 변수 전체를 볼 수도 있다. 프로그램 머리의 다른
부분들에도 비슷한 이야기가 들어맞는다.

사실 여기 보인 머리는 아주 보통의 것은 아니다. 머리의 |program| 줄에 |output| 파일이 없는데,
여기서 |output|을 지정하면 \ph가 \TeX\ 사용자에게 파일 이름을 물어보기 때문이다.
@^PASCAL H@>
@^system dependencies@>

보충: \GO/ 프로그램의 머리는 \PASCAL과 생김새가 다르다. 원본의 |program| 줄 대신 |package|
선언과 |import| 목록이 온다. \PASCAL은 레이블, 상수, 형, 변수, 프로시저를 반드시 이
순서로 선언해야 하고 무엇이든 쓰기 전에 선언해야 하지만, \GO/에서는 꾸러미 수준의
선언 순서가 자유롭다. 그래서 원본에서 프로그램의 뒷부분을 이루는 \.{@@p} 절들은
모두 이름 있는 절 |@<함수들@>|로 모아 여기서 한꺼번에 끼워 넣는다. 원본의 주 프로그램은
\GO/의 |main| 함수가 된다(\os{1332}).

@c
@<컴파일러 지시문@>
package main

import (
	"bufio"
	"fmt"
	"io"
	"math"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
)

@<바깥 블록의 레이블@>
@<바깥 블록의 상수@>
@<바깥 블록의 형@>
@<전역 변수@>
@<정의@>

func initialize() { // 이 프로시저는 일이 제대로 시작되게 한다
	@<초기화를 위한 지역 변수@>
	@<\TeX이 건드릴 만한 것은 무엇이든 초기화한다@>
}

@<기본 인쇄 프로시저@>
@<오류 처리 프로시저@>
@<함수들@>

@ 전체 \TeX\ 프로그램은 방금 보인 머리로 시작하고, 그 뒤에 프로시저 선언과 함수
선언이 한 무더기 온다. 마지막으로 우리는 `|start_here|'라는 주석으로 시작하는 주
프로그램에 이르게 될 것이다. 지금 바로 주 프로그램으로 건너뛰고 싶다면 찾아보기에서
`|start_here|'를 찾으면 된다. 그러나 이 프로그램을 이해하는 가장 좋은 방법으로 저자가
권하는 것은, 지금 읽고 있는 \.{WEB} 서술에 나오는 \TeX의 구성 요소들의 순서를 대체로
따라가는 것이다. 지금의 순서는 조금 복잡한 시스템을 이해하는 문제에 대해 ``상향식''과
``하향식'' 접근법의 장점을 함께 살리려고 짠 것이기 때문이다.

@ 주 프로그램에서 레이블 세 개를 선언해야 하므로, 이것들에 기호 이름을 붙인다.

보충: \GO/의 레이블은 미리 선언하지 않는다. 그러나 이 세 레이블 가운데 |end_of_TEX|와
|final_end|로는 다른 프로시저 안에서도 뛰어든다(\os{35}, \os{81}). \GO/의 |goto|는 함수
바깥으로 뛸 수 없으므로, 그런 곳에서는 이 레이블을 값으로 삼아 |panic|을 일으키고 주
프로그램이 그것을 |recover|로 받아서 해당하는 곳으로 간다. 그 값의 형이 |outer_label|이다.
\GO/에서 레이블 이름과 보통 식별자 이름은 서로 다른 이름 공간에 있으므로, 주 프로그램
안의 레이블 \ID{end\_of\_TEX}와 이 상수 |end_of_TEX|는 부딪치지 않는다.

@<바깥 블록의 레이블@>=
type outer_label int32 // 바깥 블록의 레이블로 가는 |panic|의 값

const (
	start_of_TEX outer_label = 1    // \TeX의 변수들이 초기화되면 여기로 간다
	end_of_TEX   outer_label = 9998 // 파일을 닫고 우아하게 끝낼 때 여기로 간다
	final_end    outer_label = 9999 // 이 레이블은 프로그램의 끝을 표시한다
)

@ 아래 코드의 일부는 \TeX을 설치할 때 이따금 생기는 이상한 행동을 진단할 때나, 시스템
마법사들이 자기가 무엇을 하는지 잘 모르면서 \TeX을 만지작거릴 때에만 쓰려는 것이다.
이런 코드는 보통 때에는 컴파일되지 않는다. 그것은 `$|debug|\ldots|gubed|$'라는
암호어로 둘러싸여 있다. 영어의 순수성을 지키고 싶어 하는 이들에게는 사과한다.

마찬가지로 `$|stat|\ldots|tats|$'로 둘러싼 조건부 코드도 있는데, 이것은 \TeX의 메모리 사용에 관한 통계를 모을 때 쓰려는 것이다. 이 |stat|$\ldots$|tats| 코드는
\.{\\tracingparagraphs}, \.{\\tracingpages}, \.{\\tracingrestores}를 위한 진단 정보도
구현한다.
@^debugging@>

보충: \.{WEB}은 |debug|와 |gubed|를 주석의 시작과 끝으로 정의해서 그 사이의 코드를
없앤다. \GO/에는 그런 매크로가 없으므로, 옮긴이는 불 상수 |debug|와 |stat|을 두고
`|if debug {|$\,\ldots\,$|}|' 꼴로 썼다. 상수 조건의 |if| 문은 \GO/ 컴파일러가 아예
없애 주므로 효과는 같다. 실제로 쓰이는 \TeX\ 구현들은 대개 통계 코드를 넣어서
컴파일하므로 |stat|은 참으로 둔다.

@<정의@>=
const (
	debug = false // 디버깅할 때 |true|로 바꾼다
	stat  = true  // 사용 통계를 모으지 않으려면 |false|로 바꾼다
)

@ 이 프로그램에는 중요한 변형이 둘 있다. (1)~\.{INITEX}라는 길고 느린 판은 \TeX의
@.INITEX@>
내부 표를 초기화하는 데 필요한 여분의 계산을 한다. (2)~짧고 빠른 실무용 판은
초기화를 최소한으로 줄인다. (1)에는 필요하지만 (2)에는 필요 없는 부분은
`$|init|\ldots|tini|$'라는 암호어로 둘러싼다.

보충: 원본에서 두 판은 서로 다른 컴파일의 결과다. 옮긴이는 \GO/ 프로그램 하나가 두
노릇을 다 하게 했다. 불 변수 |ini_version|이 참이면 \.{INITEX}이고, 원본의
`$|init|\ldots|tini|$'는 `|if ini_version {|$\,\ldots\,$|}|'가 된다. 이 변수는 주
프로그램이 명령줄을 보고 정한다(\os{1332}). \GO/에서 \ID{init}는 꾸러미 초기화 함수를
위해 남겨 둔 이름이라 변수 이름으로 쓸 수 없다.

@<\TeX이 건드릴...@>=
@<핵심 변수들의 초깃값을 정한다@>
if ini_version {
	@<표의 항목들을 초기화한다(\.{INITEX}만 한다)@>
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
var ini_version bool // 이것이 \.{INITEX}인가?

@ \PASCAL\ 주석의 첫 글자가 달러 기호면, \ph는 그 주석을 이 프로그램을 기계어로
옮기는 데 영향을 미치는 ``컴파일러 지시문''의 목록으로 다룬다. 아래 보인 지시문들은
\TeX을 디버깅할 때는 완전한 검사와 \PASCAL\ 디버거를 넣고, 실무용 시스템을 만들 때는
범위 검사와 그 밖의 군더더기 코드를 없애라고 한다. 산술 넘침은 언제나 잡는다.
@^PASCAL H@>
@^system dependencies@>
@^overflow in arithmetic@>

보충: \GO/에는 이런 컴파일러 지시문이 없다. \GO/는 배열 첨자의 범위를 언제나 검사하고,
정수 산술의 넘침은 결코 잡지 않는다(넘친 값은 조용히 감긴다). 그러므로 원본의 지시문과
반대로, 범위는 늘 검사되고 넘침은 잡히지 않는다. \TeX\ 자신이 넘칠 만한 곳마다 미리
검사하므로 넘침을 잡지 못해도 크게 걱정할 일은 아니다.

@<컴파일러 지시문@>=
// \GO/에는 컴파일러 지시문이 없다

@ 이 \TeX\ 구현은 젠슨과 비르트가 1975년에 펴낸 {\sl Pascal User Manual}의 규칙을 따른다.
@^PASCAL@>
@^system dependencies@>
@^Wirth, Niklaus@>
@^Jensen, Kathleen@>
다만 쓸모 있는 시스템 프로그램을 만드는 데 필요한 시스템 의존 코드는 예외이고, 또
하나, 규칙을 지키면 뜻이 불필요하게 흐려지고 코드가 어지러워질 경우도 예외다.
우리는 |case| 문에 맞는 레이블이 없을 때 적용되는 기본 경우를 둘 수 있다고 가정한다.
그래서 다음과 같은 구성을 쓴다.
$$\vbox{\halign{\ignorespaces#\hfil\cr
\KW{case} |x| \KW{of}\cr
1: $\langle\,$|x=1|일 때의 코드$\,\rangle$;\cr
3: $\langle\,$|x=3|일 때의 코드$\,\rangle$;\cr
\KW{othercases} $\langle\,$|x!=1|이고 |x!=3|일 때의 코드$\,\rangle$\cr
\KW{endcases}\cr}}$$
대부분의 \PASCAL\ 컴파일러가 이런저런 기본 경우 장치를 넣어 언어의 이 구멍을 막아 왔기
때문이다. 이를테면 \ph\ 컴파일러는 `\KW{others}:'를 기본 레이블로 허용하고, 다른
\PASCAL들은 `\KW{else}'나 `\KW{otherwise}'나 `\ID{otherwise}:' 따위의 문법을 허용한다.
매크로 |othercases|와 |endcases|의 정의는 그 지역의 관례에 맞게 바꾸어야 한다. 이 프로그램에서는
|endcases| 앞에 쌍반점이 오지 않으므로, 컴파일러가 쌍반점을 원한다면 |endcases|의 정의에
쌍반점을 넣어야 한다. (물론 기본 경우 장치가 전혀 없다면 \TeX의 |case| 문은 나머지
경우를 모두 늘어놓도록 힘들게 늘려야 할 것이다. 그런 \PASCAL에 갇힌 사람들은 실제로
그렇게 해냈다. 성공적이었지만 즐겁지는 않았다!)
@^PASCAL H@>

보충: \GO/의 |switch| 문에는 |default|가 있으므로 이 문제가 없다. 원본의 \KW{othercases}는
|default|가 된다. 또한 \GO/의 |switch|는 \PASCAL의 |case|처럼 맞는 경우 하나만 실행하고
끝난다. 다만 \PASCAL에서는 맞는 레이블이 없고 기본 경우도 없으면 오류지만, \GO/에서는
아무 일도 하지 않고 지나간다.

@ 다음 매개변수들은 \TeX의 용량을 늘리거나 줄이도록 컴파일할 때 바꿀 수 있다.
\.{INITEX}와 실무용 \TeX에서 값이 서로 다를 수 있다.
@.INITEX@>
@^system dependencies@>

보충: 옮긴이는 원본의 값을 그대로 두었다. 다만 \GO/ 프로그램 하나가 \.{INITEX}와
실무용 판을 겸하므로, 원본의 설명처럼 |mem_max|는 |mem_top|과 같아야 하고 |mem_min|은
|mem_bot|과 같아야 한다. 원본의 |pool_name|은 문자열 풀 파일의 이름인데, 이 번역은 그
파일을 쓰지 않으므로(\os{50}) 뺐다. 또 요즘의 파일 이름은 40글자보다 길기 일쑤라서
|file_name_size|만은 늘렸다.

@<바깥 블록의 상수@>=
const (
	@!mem_max = 30000 // \TeX의 내부 배열 |mem|의 가장 큰 첨자;
	// |max_halfword|보다 엄격히 작아야 한다;
	// \.{INITEX}에서는 |mem_top|과 같아야 하고, 그 밖에는 |>=mem_top|
	@!mem_min = 0 // \TeX의 내부 배열 |mem|의 가장 작은 첨자;
	// |min_halfword| 이상이어야 한다;
	// \.{INITEX}에서는 |mem_bot|과 같아야 하고, 그 밖에는 |<=mem_bot|
	@!buf_size = 500 // 열린 파일들의 현재 줄과 \.{\\csname}과 \.{\\endcsname} 사이의
	// 제어 시퀀스에 동시에 들어 있는 문자 수의 최댓값; |max_halfword|를 넘으면 안 된다
	@!error_line = 72 // 터미널 오류 메시지의 문맥 줄의 너비
	@!half_error_line = 42 // 터미널 오류 메시지에서 문맥 첫 줄의 너비;
	// 30과 |error_line-15| 사이여야 한다
	@!max_print_line = 79 // 출력하는 텍스트 줄의 가장 긴 너비; 적어도 60이어야 한다
	@!stack_size = 200 // 동시에 열려 있는 입력원의 최대 개수
	@!max_in_open = 6 // 동시에 진행할 수 있는 입력 파일과 오류 삽입의 최대 개수
	@!font_max = 75 // 내부 글꼴 번호의 최댓값; |max_quarterword|를 넘으면 안 되고
	// 많아야 |font_base+256|이어야 한다
	@!font_mem_size = 20000 // 모든 글꼴을 위한 |font_info|의 낱말 수
	@!param_size = 60 // 동시에 쓰이는 매크로 매개변수의 최대 개수
	@!nest_size = 40 // 동시에 활성인 의미 수준의 최대 개수
	@!max_strings = 3000 // 문자열의 최대 개수; |max_halfword|를 넘으면 안 된다
	@!string_vacancies = 8000 // \TeX\ 자신의 오류 메시지를 저장한 뒤에 사용자의
	// 제어 시퀀스와 글꼴 이름을 위해 남아 있어야 할 문자 수의 최솟값
	@!pool_size = 32000 // 문자열들에 든 문자 수의 최댓값; 모든 오류 메시지와 도움말,
	// 모든 글꼴과 제어 시퀀스의 이름을 포함한다; |string_vacancies|보다
	// \TeX\ 자신의 문자열들의 전체 길이(지금 약 23000)만큼 커야 한다
	@!save_size = 600 // 현재 그룹 바깥의 값들을 저장하는 공간; 많아야 |max_halfword|
	@!trie_size = 8000 // 하이픈 넣기 패턴을 위한 공간; 실무용 \TeX보다
	// \.{INITEX}에서 더 커야 한다
	@!trie_op_size = 500 // 하이픈 넣기 패턴의 ``연산 코드''를 위한 공간
	@!dvi_buf_size = 800 // 출력 버퍼의 크기; 8의 배수여야 한다
	@!file_name_size = 1024 // 파일 이름은 이보다 길면 안 된다(원본은 40)
)

@ 앞의 매개변수들과 마찬가지로 다음 값들도 \TeX의 용량을 늘리거나 줄이도록 컴파일할 때
바꿀 수 있다. 그러나 이것들을 바꾸면 초기화 프로그램 \.{INITEX}를 다시 돌려서 실무용
@.INITEX@>
\TeX\ 프로그램을 위한 새 표를 만들어야 한다. 다음 상수들을 함부로 이리저리 바꿀 수는
없는데, 꽤 복잡한 초기화 수치 몇몇이 이것들로부터 계산되기 때문이다. 이 구별을
강조하려고, 여기서는 이것들을 \PASCAL의 |const| 목록에 넣지 않고 \.{WEB} 매크로로
정의한다.

보충: \GO/에서는 둘 다 상수다. 다만 이 절의 것들은 |@<바깥 블록의 상수@>|가 아니라
|@<정의@>|에 두어 원본의 구별을 남겼다.

@<정의@>=
const (
	@!mem_bot = 0 // \.{INITEX}가 내보내는 |mem| 배열의 가장 작은 첨자;
	// |mem_min|보다 작으면 안 된다
	@!mem_top = 30000 // \.{INITEX}가 내보내는 |mem| 배열의 가장 큰 첨자;
	// |mem_bot|보다 상당히 커야 하고 |mem_max|보다 크면 안 된다
	@!font_base = 0 // 가장 작은 내부 글꼴 번호; |min_quarterword|보다 작으면 안 된다
	@!hash_size = 2100 // 제어 시퀀스의 최대 개수; 많아야 대략
	// |(mem_max-mem_min)/10|이어야 한다
	@!hash_prime = 1777 // |hash_size|의 약 85\pct!에 해당하는 소수
	@!hyph_size = 307 // 또 하나의 소수; \.{\\hyphenation} 예외의 개수
)
@^system dependencies@>

@ 누군가 실수로 ``상수''를 잘못 정했을 때에 대비해서, \TeX은 |bad|라는 전역 변수를
써서 그것들을 검사한다.

이것은 \TeX에서 전역 변수를 정의하는 수많은 절 가운데 첫 번째다.

@<전역 변수@>=
var @!bad int32 // 어떤 ``상수''가 잘못되었나?

@ 나중에 우리는 `\ignorespaces|if mem_max>=max_halfword| \KW{then} |bad:=14|'와 같은 말을 할
것이다. (|max_halfword|를 정의하기 전까지는 그렇게 할 수 없다.)

@<``상수'' 값들이 서로 맞는지 검사한다@>=
bad = 0
if half_error_line < 30 || half_error_line > error_line-15 {
	bad = 1
}
if max_print_line < 60 {
	bad = 2
}
if dvi_buf_size%8 != 0 {
	bad = 3
}
if mem_bot+1100 > mem_top {
	bad = 4
}
if hash_prime > hash_size {
	bad = 5
}
if max_in_open >= 128 {
	bad = 6
}
if mem_top < 256+11 {
	bad = 7 // 우리는 |null_list>255|이기를 바랄 것이다
}

@ 가끔 나오는 |goto| 문의 뜻이 잘 통하도록, 레이블에는 다음 정의로 기호 이름을 붙인다.
`|return|' 문(아래에서 정의한다)을 쓴 프로시저에서는 그 프로시저의
`\ignorespaces|end|\unskip' 바로 앞에 레이블 `|exit|'를 넣는다. 레이블 `|restart|'는
가끔 프로시저의 맨 앞에서 쓰이고, 레이블 `|reswitch|'는 가끔 |case| 문 바로 앞에서
쓰인다. 어떤 경우가 조건을 바꾼 다음 다른 경우로 넘어가야 할 때다.
아래에서 정의하는 |loop| 구성으로 짠 루프는 흔히 `|done|'이나 `|found|'나
`|not_found|'로 가서 빠져나오고, 가끔은 `\ID{continue}'로 가서 되풀이된다. 서브루틴의
둘 이상의 부분이 서로 다르게 시작하지만 같게 끝난다면, 그 공통 코드는
`|common_ending|'에 모아 둘 수 있다.

덧붙여 말하면, 이 프로그램은 실제로 쓰지 않는 레이블을 결코 선언하지 않는다.
까다로운 \PASCAL\ 컴파일러는 쓸데없는 레이블에 대해 불평할 것이기 때문이다.

보충: \PASCAL의 레이블은 수여야 하므로 원본은 |exit=10|, |restart=20|, |reswitch=21|,
\ID{continue}${}=22$, |done=30|, |done1=31|, \dots, |done6=36|, |found=40|, |found1=41|,
|found2=42|, |not_found=45|, |common_ending=50|이라는 매크로를 두었다. \GO/의 레이블은
이름이므로 그런 정의가 필요 없다. 레이블 \ID{exit}로 가는 |goto|는 \GO/의 |return|이
되므로 레이블 \ID{exit}는 대개 쓰지 않는다. 다만 |macro_call|이나 |try_break|처럼 그 레이블 뒤에 할 일이 남아
있는 프로시저에서는 레이블 \ID{exit}로 가는 |goto|를 그대로 쓴다. \ID{continue}는 \GO/의 예약어이므로 레이블
이름으로는 \ID{continue\_}를 쓴다. \GO/ 컴파일러도 쓰지 않는 레이블을 오류로 다루므로,
원본의 이 습관은 \GO/에서도 그대로 필요하다.

@ 다음은 흔한 프로그래밍 관용구를 위한 매크로들이다.

보충: 원본의 정의는 다음과 같다.
$$\vbox{\halign{#\hfil\qquad&#\hfil\cr
|incr(#)| $\equiv$ |#:=#+1|&변수를 1만큼 늘린다\cr
|decr(#)| $\equiv$ |#:=#-1|&변수를 1만큼 줄인다\cr
|negate(#)| $\equiv$ |#:=-#|&변수의 부호를 바꾼다\cr
|loop| $\equiv$ \KW{while} \KW{true} \KW{do}&|goto|가 일어날 때까지 끝없이 되풀이한다\cr
|do_nothing| $\equiv$ \null&빈 문장\cr
|return| $\equiv$ |goto exit|&프로시저 호출을 끝낸다\cr
|empty| $=$ 0&널 상수의 기호 이름\cr}}$$
\GO/에서는 이것들이 저마다 |x++|, |x--|, |x=-x|, `|for {|$\,\ldots\,$|}|', 빈 문장,
|return|이 된다. 상수 |empty|만 남는다.

@<정의@>=
const empty = 0 // 널 상수의 기호 이름

@ \dg 원본은 \PASCAL의 내장 함수 |abs|, |odd|, |round|를 쓴다. \GO/에는 정수의
절댓값 함수도 홀수 판정 함수도 없으므로 여기서 만든다. \PASCAL의 |round|는 \GO/의
|math.Round|처럼 한가운데 값을 0에서 먼 쪽으로 반올림한다. 다만 \PASCAL에서는 결과가
정수 범위를 벗어나면 오류지만 \GO/에서 |float64|를 |int32|로 바꿀 때 범위를 벗어나면
결과가 정의되지 않으므로, 여기서는 결과를 $\pm(2^{31}-1)$로 자른다. 실제로 쓰이는
\TeX\ 구현들도 이렇게 한다.
@^dirty \PASCAL@>

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
\TeX을 매우 다양한 컴퓨터에 쉽게 옮겨 갈 수 있도록, 모든 입력 텍스트는 표준
{\mc ASCII}(``American Standard Code for Information Interchange'')를 포함하는 내부
8비트 코드로 바뀐다. 이 변환은 각 문자를 읽어 들이는 즉시 이루어진다. 거꾸로, 문자는
텍스트 파일로 출력되기 바로 전에 {\mc ASCII}에서 사용자의 외부 표현으로 바뀐다.

이런 내부 코드가 \TeX\ 사용자와 관계가 있는 것은 주로 그것이 글꼴 안의 문자 위치를
정하기 때문이다. 이를테면 문자 `\.A'의 {\mc ASCII} 코드는 $65=\.{'101}$이고, \TeX은 이
글자를 조판할 때 현재 글꼴의 65번 문자를 지정한다. 그 글꼴이 실제로는 `\.A'를 다른
위치에 두었다면 \TeX은 진짜 위치가 어디인지 모른다. \TeX의 장치 독립 파일로부터 실제
인쇄를 하는 프로그램이 {\mc ASCII}를 특정 글꼴 인코딩으로 바꿀 책임을 진다.
@^ASCII code@>

\TeX의 내부 코드는 역따옴표로 시작하는 상수의 값도 정한다. 또 \.{\\catcode},
\.{\\mathcode}, \.{\\uccode}, \.{\\lccode}, \.{\\delcode} 표의 첨자가 된다.

@ \TeX의 내부 형태로 바뀐 텍스트 문자의 형을 |ASCII_code|라고 한다. 이것은 정수의
부분 범위다.

보충: \PASCAL의 부분 범위 형 |0..255|에 딱 맞는 \GO/ 형은 없다. 옮긴이는 \TeX이 쓰는
정수 형을 거의 모두 |int32|의 별칭으로 삼았다. 바이트 한 개짜리 형(|uint8|)으로 하면
메모리는 아끼지만, \PASCAL처럼 정수 형끼리 마음대로 섞어 쓸 수 없어서 코드 곳곳에
형 변환이 들어가야 하기 때문이다. 별칭(|type ASCII_code = int32|)은 새 형이 아니라 같은
형의 다른 이름이므로, \PASCAL의 부분 범위 형처럼 다른 정수와 자유롭게 섞인다. 부분
범위의 경계 검사는 잃지만, 원본도 실무용 판에서는 범위 검사를 끈다(\os9).

@<바깥 블록의 형@>=
type @!ASCII_code = int32 // 8비트 수

@ 원래의 \PASCAL\ 컴파일러는 6비트 문자 집합이 흔하던 60년대 후반에 설계되었으므로,
소문자를 다룰 방법을 마련하지 않았다. 물론 요즘에는 대문자와 소문자를 둘 다 편리하게
다루어야 하고, 조판 프로그램에서는 더욱 그렇다. 그래서 지금의 \TeX\ 명세는 \PASCAL\
컴파일러와 실행 시스템이 64개보다 많은 문자를 구별하는 텍스트 파일을 쓸 수 있다고
가정하고 쓰였다. 더 정확히 말하면, 문자 집합에는 적어도 {\mc ASCII} 코드 \.{'40}부터
\.{'176}까지에 해당하는 글자와 기호가 있다고 가정한다. 이 문자들은 이제 대부분의
컴퓨터 터미널에서 쓸 수 있다.

처음의 \PASCAL\ 컴파일러에 있던 것보다 많은 문자를 다루므로, 그 자료형을 무엇이라고
부를지 정해야 한다. 어떤 \PASCAL은 텍스트 파일의 문자에 원래 이름 |char|를 쓴다. 이제
그런 문자가 64개보다 많은데도 말이다. 다른 \PASCAL들은 |char|를 다른 이름의 더 큰
자료형에서 원소 64개짜리 부분 범위로 여긴다.

이 차이를 받아들이려고, 입력할 때 |ASCII_code|로 바뀌고 출력할 때 |ASCII_code|에서 바뀌는
문자들의 자료형을 |text_char|라는 이름으로 나타내기로 한다. 또 |text_char|는
|chr(first_text_char)|부터 |chr(last_text_char)|까지의 원소로 이루어진다고 가정한다.
다음 정의는 필요하면 고쳐야 한다.
@^system dependencies@>

보충: \GO/에서 텍스트 파일의 문자는 바이트이므로 |text_char|는 |byte|의 별칭이다.
원본에서 이 절의 코드부는 |initialize|의 지역 변수 |i|를 선언한다. \GO/에서 그 선언은
|initialize| 함수 안에 들어가므로, 정의부는 다음 절로 옮긴다.

@<초기화를 위한 지역 변수@>=
var @!i int32

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
type text_char = byte // 텍스트 파일의 문자의 자료형

const (
	first_text_char = 0   // |text_char|의 가장 작은 원소의 서수
	last_text_char  = 255 // |text_char|의 가장 큰 원소의 서수
)

@ \TeX\ 처리기는 \PASCAL의 함수 |ord|와 |chr|에 해당하는 배열 |xord|와 |xchr|를 써서
{\mc ASCII} 코드와 사용자의 외부 문자 집합 사이를 오간다.

@<전역 변수@>=
var @!xord [256]ASCII_code // 입력 문자의 변환을 지정한다
var @!xchr [256]text_char  // 출력 문자의 변환을 지정한다

@ 우리는 \PASCAL\ 시스템이 표준 {\mc ASCII}의 보이는 문자들을 읽고 쓸 수 있다고
가정하고 있다(그것을 나타내는 데 꼭 {\mc ASCII} 코드를 쓰지는 않더라도). 그러므로 다음
대입문들은 시스템에 따라 고칠 필요 없이 배열 |xchr|의 표준 부분을 제대로 초기화한다.
한편 \TeX을 덜 완전한 문자 집합으로 구현할 수도 있는데, 그런 경우에는 여기서 무언가를
바꾸어야 할 것이다.
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

@ 보이는 문자가 없는 {\mc ASCII} 코드 가운데 몇몇은 특별한 뜻으로 쓰이기 때문에 이
프로그램에서 기호 이름을 얻었다.

@<정의@>=
const (
	@!null_code       = 0o0   // 사라질지도 모르는 {\mc ASCII} 코드
	@!carriage_return = 0o15  // 줄 끝에 쓰는 {\mc ASCII} 코드
	@!invalid_code    = 0o177 // 많은 시스템이 텍스트 파일에서 금지하는 {\mc ASCII} 코드
)

@ {\mc ASCII} 코드는 어느 정도까지만 ``표준''이다. 많은 컴퓨터 설치처에서는 94개보다
많은 인쇄 문자를 쉽게 쓸 수 있는 편이 낫다고 보았기 때문이다. {\sl The \TeX book}의
부록~C는 문자들과 \TeX\ 내부 표현 사이의 의도된 대응을 완전히 명세한다.
@^TeXbook@>

\TeX을 표준 {\mc ASCII} 코드만 입출력 파일에 나타나는 평범한 \PASCAL에서 쓴다면,
|xchr[0..@'37]|에 어떤 코드를 넣든 별로 상관없지만, 가장 안전한 방침은 아래 코드처럼
모두 공백으로 두는 것이다.

그러나 |xchr|를 달리 정하면 확장 문자 집합을 가진 컴퓨터에서 \TeX이 더 친절해져서,
사용자가 `\.{\\ne}' 대신 `\.^^Z' 같은 것을 칠 수 있게 된다. 확장 문자 집합을 가진
사람들은 코드를 마음대로 정해서, \TeX\ 사용자가 입력 파일에 쓸 수 있는 문자는 무엇이든
그에 해당하는 |xchr|를 줄 수 있다. 될 수 있으면 코드를 부록~C에 보인 의도된 해석에
맞추는 것이 가장 좋지만, 꼭 그래야 하는 것은 아니다. 이를테면 알파벳이 26글자보다 많은
나라에서는 대개 추가 글자들을 \.{'40}보다 작은 코드에 대응시키는 것이 가장 좋다. 가장
``너그러운'' 문자 집합을 얻으려면 이 대입문들의 오른쪽에 있는 |' '|를 |chr(i)|로 바꾸면
된다.
@^character set dependencies@>
@^system dependencies@>

@<핵심 변수들의...@>=
for i = 0; i <= 0o37; i++ {
	xchr[i] = ' '
}
for i = 0o177; i <= 0o377; i++ {
	xchr[i] = ' '
}

@ 다음의 시스템 독립 코드는 배열 |xord|가 |xchr|의 정보에 대한 알맞은 역을 담게 한다.
두 코드 |i<j<@'177|에 대해 |xchr[i]=xchr[j]|이면 |xord[xchr[i]]|의 값은 |j| 이상이 된다는 데
주목하라. 그러므로 우연히 겹칠 때에는 \.{'40}보다 작은 코드 대신 표준 {\mc ASCII} 코드
번호가 쓰인다.

@<핵심 변수들의...@>=
for i = first_text_char; i <= last_text_char; i++ {
	xord[text_char(i)] = invalid_code
}
for i = 0o200; i <= 0o377; i++ {
	xord[xchr[i]] = i
}
for i = 0; i <= 0o176; i++ {
	xord[xchr[i]] = i
}

@* 입력과 출력.
이식성의 골칫거리는 운영체제마다 입력과 출력을 아주 다르게 다룬다는 사실이다. 아마
전산학자들이 이 문제에 충분한 관심을 기울이지 않았기 때문일 것이다. 사람들은 어쩐지
입력과 출력이 ``진짜'' 프로그래밍의 일부가 아니라고 느껴 왔다. 하기야 어떤 종류의
프로그래밍이 다른 것보다 더 재미있는 것은 사실이다. 지금의 입출력 관례들이 이토록 다양하고
이토록 지저분하니, 코드의 이런 부분에서 기쁨을 얻는 길은 프로그램을 그렇지 않았을 때보다
조금이나마 덜 나쁘게 만드는 방법을 찾아내는 드문 경우뿐이다. 우리에게는 두 가지 선택이
있다. 입출력에 지금 덤벼들어 끝내 버리든지, 입출력을 끝 무렵까지 미루든지. 어느 쪽도 그리
끌리지 않으니, 끝내 버리기로 하자.

우리가 해야 할 기본 연산은 다음과 같다. (1)~파일이나 사용자의 터미널로부터 텍스트를
입력하고 그곳으로 텍스트를 출력한다. (2)~파일로부터 8비트 바이트를 입력하고 파일로 8비트
바이트를 출력한다. (3)~운영체제에게 지정된 파일에 대한 입력이나 출력을 시작하라(``열라'')
또는 끝내라(``닫으라'')고 지시한다. (4)~입력 파일의 끝에 이르렀는지 검사한다.

\TeX은 두 종류의 파일을 다루어야 한다. 텍스트 자료를 담은 파일은 |alpha_file|이라고 부르고,
8비트 이진 정보를 담은 파일은 |byte_file|이라고 부르기로 한다. 많은 컴퓨터에서 이 두 형은
같은 것이지만 때로는 중요한 차이가 있으므로, 우리는 둘을 조심스럽게 구별할 것이다. 이런
파일을 고속 망을 통해 컴퓨터에서 컴퓨터로 옮기는 표준 규약을 이제 점점 더 많은 사용자 집단이
쓸 수 있게 되었다.

이 프로그램은 실은 세 번째 종류의 파일도 쓴다. 그것을 |word_file|이라고 부르는데, 프로그램이
자기 초기화에 쓸 기본 정보를 내보냈다가 다시 읽어 들이는 데 쓴다. 낱말 파일은 나중에
정의하겠지만, 그 전에도 낱말 파일에 대한 간단한 연산들은 지정할 수 있을 것이다.

보충: \PASCAL의 파일 형 \KW{file} \KW{of}~$T$에는 ``버퍼 변수'' |f^|가 딸려 있어서,
파일의 현재 원소를 언제나 들여다볼 수 있다. 프로시저 |get(f)|는 다음 원소를 |f^|로 읽어 오고,
|put(f)|는 |f^|를 파일에 덧붙이며, |eof(f)|는 파일의 끝에 이르렀는지 알려 준다. \GO/에는
이런 파일 형이 없으므로, 옮긴이는 \GO/의 |os.File|과 버퍼를 둔 읽기·쓰기 객체를 묶어
구조체로 만들었다. 이진 파일에는 버퍼 변수 |f^|에 해당하는 필드 |buf|와 파일 끝 표시
|at_eof|를 둔다. 파일을 인자로 받는 \PASCAL\ 프로시저는 \KW{var} 매개변수를 쓰므로, \GO/에서는
파일을 가리키는 포인터를 넘긴다.

@<바깥 블록의 형@>=
type @!eight_bits = int32 // 부호 없는 한 바이트짜리 양
type @!alpha_file struct { // 텍스트 자료를 담은 파일
	f *os.File
	r *bufio.Reader
	w *bufio.Writer
}
type @!byte_file struct { // 이진 자료를 담은 파일
	f      *os.File
	r      *bufio.Reader
	w      *bufio.Writer
	buf    eight_bits // \PASCAL의 버퍼 변수 |f^|
	at_eof bool       // \PASCAL의 |eof(f)|
}

@ 입력과 출력에 관해 해야 할 일의 대부분은 \PASCAL의 표준 입출력 기능, 곧 |get|, |put|,
|eof| 따위의 루틴으로 처리할 수 있다. 그러나 표준 \PASCAL에서는 파일 변수를 실행 중에 정해지는
파일 이름과 연결할 수 없으므로, 그것만으로는 \TeX을 구현할 수 없다. \PASCAL의 보통의
|reset|과 |rewrite|를 어떤 식으로든 확장하는 것이 우리의 목적에 결정적이다. 우리는
|name_of_file|이 알맞은 형의 변수여서, \TeX을 구현하는 데 쓰는 \PASCAL\ 실행 시스템이 외부
이름이 |name_of_file|로 지정된 파일을 열 수 있다고 가정한다.
@^system dependencies@>

보충: 원본에서 |name_of_file|은 \KW{packed} \KW{array}~$[1..file\_name\_size]$ \KW{of}
\KW{char}다. \GO/에서도 1부터 시작하는 바이트 배열로 둔다.

@<전역 변수@>=
var @!name_of_file [file_name_size + 1]text_char // 어떤 시스템에서는 \KW{record} 변수일 수도 있다
var @!name_length int32 // |name_of_file|에서 실제로 뜻이 있는 문자의 수(나머지는 공백)

@ 지금 판의 \TeX을 만들 때 쓴 \ph\ 컴파일러는 \PASCAL의 규칙을 아주 편리하게 확장했다.
파일~|f|를 열려면 다음과 같이 쓸 수 있다.
$$\vbox{\halign{#\hfil\qquad&#\hfil\cr
|reset(f,@t\ID{name}@>,'/O')|&입력용;\cr
|rewrite(f,@t\ID{name}@>,'/O')|&출력용.\cr}}$$
`\ID{name}' 매개변수는 형이 `\KW{packed} \KW{array} $[\langle\ID{any}\rangle]$ \KW{of}
\ID{char}'인데, 입력이나 출력을 위해 여는 외부 파일의 이름을 나타낸다. \ID{name}에
나올지도 모르는 공백은 무시된다.

`\.{/O}' 매개변수는 무언가 잘못되었을 때 운영체제에게 자기 오류 메시지를 내지 말라고 지시한다.
지정한 이름의 파일을 찾을 수 없거나 다른 까닭으로 열 수 없으면(이를테면 누군가 같은
파일에 쓰려 하고 있을 수도 있다), |reset|이나 |rewrite|가 실패한 뒤에 |@!erstat(f)!=0|이
된다. 그래서 \TeX은 알맞은 바로잡기 조치를 할 수 있다.
@^PASCAL H@>
@^system dependencies@>

\TeX의 파일 여는 프로시저들은 |name_of_file|이 가리키는 파일을 열 수 없으면 |false|를
돌려준다.

보충: \GO/에서는 |os.Open|과 |os.Create|가 오류를 돌려주므로 \ph의 |erstat|이 필요 없다.
파일의 외부 이름은 함수 |external_name|이 |name_of_file|로부터 만든다(이 절 뒤의 둘째 덧붙인
절). 낱말 파일의 형 |word_file|은 \os{113}에서 정의한다.

@<함수들@>=
func a_open_in(f *alpha_file) bool { // 텍스트 파일을 입력용으로 연다
	file, err := os.Open(external_name())
	if err != nil { return false }
	*f = alpha_file{f: file, r: bufio.NewReader(file)}
	return true
}

func a_open_out(f *alpha_file) bool { // 텍스트 파일을 출력용으로 연다
	file, err := os.Create(external_name())
	if err != nil { return false }
	*f = alpha_file{f: file, w: bufio.NewWriter(file)}
	return true
}

func b_open_in(f *byte_file) bool { // 이진 파일을 입력용으로 연다
	file, err := os.Open(external_name())
	if err != nil { return false }
	*f = byte_file{f: file, r: bufio.NewReader(file)}
	b_get(f) // \PASCAL의 |reset|은 첫 원소를 |f^|에 읽어 둔다
	return true
}

func b_open_out(f *byte_file) bool { // 이진 파일을 출력용으로 연다
	file, err := os.Create(external_name())
	if err != nil { return false }
	*f = byte_file{f: file, w: bufio.NewWriter(file)}
	return true
}

@ \dg 낱말 파일을 여는 함수도 마찬가지다.

@<함수들@>=
func w_open_in(f *word_file) bool { // 낱말 파일을 입력용으로 연다
	file, err := os.Open(external_name())
	if err != nil { return false }
	*f = word_file{f: file, r: bufio.NewReader(file)}
	w_get(f) // \PASCAL의 |reset|은 첫 원소를 |f^|에 읽어 둔다
	return true
}

func w_open_out(f *word_file) bool { // 낱말 파일을 출력용으로 연다
	file, err := os.Create(external_name())
	if err != nil { return false }
	*f = word_file{f: file, w: bufio.NewWriter(file)}
	return true
}

@ \dg 원본은 파일 이름을 운영체제에 그대로 넘긴다. 그러나 \TeX은 입력 파일을 찾지 못하면
그 이름 앞에 `\.{TeXinputs:}'를 붙여 다시 찾고, 글꼴 파일의 이름에는 `\.{TeXfonts:}'를,
포맷 파일의 이름에는 `\.{TeXformats:}'를 붙인다(\os{514}, \os{524}). 이것은 원본을 개발한
시스템에서 표준 파일들이 있는 곳을 가리키는 이름이다. 옮긴이의 시스템에서는 그런 이름이
뜻이 없으므로, 함수 |external_name|이 이 머리말을 알아보고 해당하는 파일을 찾아 준다. 먼저
환경 변수 \.{TEXINPUTS}, \.{TEXFONTS}, \.{TEXFORMATS}에 쌍점으로 나누어 적은 디렉터리들을
차례로 뒤지고, 거기서 찾지 못하면 \TeX\ 배포판의 \.{kpsewhich} 명령에게 물어본다. 다만 포맷
파일은 구현마다 형식이 달라서 다른 \TeX의 것을 읽을 수 없으므로 \.{kpsewhich}에게 묻지 않는다.
찾지 못하면 머리말을 뗀 이름을 돌려주므로, 그런 파일이 현재 디렉터리에 있으면 그것이 열린다.
@^system dependencies@>

@<함수들@>=
func external_name() string {
	nm := string(name_of_file[1 : name_length+1])
	for _, a := range [...]struct{ area, env string }{
		{"TeXinputs:", "TEXINPUTS"}, {"TeXfonts:", "TEXFONTS"},
		{"TeXformats:", "TEXFORMATS"}} {
		if strings.HasPrefix(nm, a.area) {
			nm = strings.TrimPrefix(nm, a.area)
			for _, dir := range filepath.SplitList(os.Getenv(a.env)) {
				if dir != "" {
					if _, err := os.Stat(filepath.Join(dir, nm)); err == nil {
						return filepath.Join(dir, nm)
					}
				}
			}
			if a.env != "TEXFORMATS" {
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

@ 파일은 \ph의 루틴 `|close(f)|'로 닫을 수 있다. 이것은 |f|에 대한 입력이나 출력이 모두
@^PASCAL H@>
@^system dependencies@>
끝났을 때 써야 한다. 그러면 원한다면 |f|를 다시 열 수 있게 된다. 또 |f|를 출력에 썼다면
|close| 연산은 해당하는 외부 파일이 사용자의 영역에 나타나서 읽힐 준비가 되게 한다.

이 프로시저들은 파일이 성공적으로 열리기 전에 닫히더라도 오류 메시지를 내면 안 된다.

보충: \GO/에서는 쓰기 버퍼를 비운 다음 파일을 닫는다. 열린 적이 없는 파일이면 아무
일도 하지 않는다.

@<함수들@>=
func a_close(f *alpha_file) { // 텍스트 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = alpha_file{}
}

func b_close(f *byte_file) { // 이진 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = byte_file{}
}

func w_close(f *word_file) { // 낱말 파일을 닫는다
	if f.w != nil {
		f.w.Flush()
	}
	if f.f != nil {
		f.f.Close()
	}
	*f = word_file{}
}

@ 이진 입력과 출력은 \PASCAL의 보통의 |get|과 |put| 프로시저로 하므로, 이진 입출력을 위해
따로 특별한 준비를 할 필요는 없다. 텍스트 출력도 표준 \PASCAL\ 루틴으로 쉽게 할 수 있다.
그러나 텍스트 입력은 |ASCII_code| 값으로 바꾸어야 하기 때문에 더 어렵다. \TeX의 관례는
효율적이어야 하고, 사용자의 운영 환경과 잘 어울려야 한다.

@ \dg 원본이 쓰는 \PASCAL의 표준 루틴들 가운데 \GO/에 없는 것을 여기서 만든다. 프로시저 |write(f,
@t$\ldots$@>)|와 |write_ln(f,@t$\ldots$@>)|는 인자들을 텍스트 파일 |f|에 차례로 쓰고, |write_ln|은
끝에 줄바꿈을 덧붙인다. \PASCAL에서와 같이 인자는 문자열, 문자(\GO/에서는 |byte|), 정수일 수
있다. 정수는 최소 너비, 곧 \PASCAL의 `|n:1|'처럼 찍는다. 이진 파일의 |b_get|은 \PASCAL의
|get|에, |b_put|은 \PASCAL의 |write(f,c)|에 해당한다.

조심할 점이 하나 있다. \GO/의 작은따옴표 상수 |' '|는 문자가 아니라 정수(|rune|)이므로,
|write|에 넘기면 수로 찍힌다. 그래서 원본의 \PASCAL\ 문자열 상수는 모두 \GO/의 큰따옴표
문자열로 옮긴다.

@<함수들@>=
func write(f *alpha_file, xs ...any) {
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

func write_ln(f *alpha_file, xs ...any) {
	write(f, xs...)
	f.w.WriteByte('\n')
}

func b_get(f *byte_file) { // \PASCAL의 |get(f)|
	c, err := f.r.ReadByte()
	if err != nil {
		f.at_eof = true
		f.buf = 0
		return
	}
	f.buf = eight_bits(c)
}

func b_put(f *byte_file, c eight_bits) { // \PASCAL의 |write(f,c)|
	f.w.WriteByte(byte(c))
}

@ 텍스트 파일의 입력은 |input_ln|이라는 루틴을 써서 한 번에 한 줄씩 읽는다. 이 함수는
|buffer|, |first|, |last|라는 전역 변수로 정의되는데, 이것들은 나중에 자세히 설명할 것이다.
지금으로서는 |buffer|가 |ASCII_code| 값의 배열이고, |first|와 |last|가 이 배열의 첨자로서
텍스트 한 줄의 시작과 끝을 나타낸다는 것만 알면 된다.

@<전역 변수@>=
var @!buffer [buf_size + 1]ASCII_code // 읽고 있는 문자들의 줄
var @!first int32 // |buffer|에서 쓰이지 않는 첫 위치
var @!last int32 // |buffer|에 방금 입력한 줄의 끝
var @!max_buf_stack int32 // |buffer|에서 쓰인 가장 큰 첨자

@ 함수 |input_ln|은 지정된 파일의 다음 줄을 버퍼 배열의 쓸 수 있는 위치로 가져오고 |true|를
돌려준다. 다만 파일을 이미 다 읽었다면 |false|를 돌려주고 |last:=first|로 놓는다. 일반적으로
파일의 다음 줄을 나타내는 |ASCII_code| 수들은 |buffer[first]|, |buffer[first+1]|, \dots,
|buffer[last-1]|에 들어가고, 전역 변수 |last|는 |first|에 그 줄의 길이를 더한 값이 된다.
줄 끝의 공백들은 지운다. 그러므로 |last=first|이거나(이때 그 줄은 완전히 비어 있었다)
|buffer[last-1]!=" "|이다.

그러나 |input_ln|의 보통 동작으로 |last>=buf_size|가 될 것 같으면 넘침 오류를 낸다. 이렇게
해서 \TeX의 다른 부분들은 배열 |buffer|의 경계를 넘어설 걱정 없이 |buffer[last+1]|의 내용을
안전하게 들여다볼 수 있다. 함수 |input_ln|에 들어올 때는 언제나 |first<buf_size|라는 조건이
성립하므로, ``빈'' 줄을 위한 자리는 언제나 있다.

변수 |max_buf_stack|은 지금의 작업을 해내려면 매개변수 |buf_size|가 얼마나 커야 하는지
추적하는 데 쓰이는데, 이것도 |input_ln|이 최신 상태로 유지한다.

매개변수 |bypass_eoln|이 |true|면 |input_ln|은 줄의 첫 문자를 보기 전에 |get|을 한다.
이렇게 해서 |f^|에 있던 |eoln|을 건너뛴다. 이 프로시저는 줄의 끝에 이르렀을 때 |get|을 하지
않는다. 그러므로 보통의 텍스트 파일만이 아니라 사용자의 터미널에서 입력을 얻는 데도 쓸 수
있다.

표준 \PASCAL은 파일에서 |eof| 바로 앞에 |eoln|이 있어야 한다고 하지만, \TeX에 필요한 것은 더
약한 제약뿐이다. 줄 한가운데서 파일이 끝나면(|eof|) 시스템 함수 |eoln|은 |true|를
돌려주어야 한다(|f^|는 정의되지 않더라도).

함수 |input_ln|의 안쪽 루프는 \TeX의 ``안쪽 루프''의 일부이므로(입력의 모든 문자가 여기를 지나
들어온다), 문자 배열 전체를 한꺼번에 읽어 들이는 특별한 루틴이 있다면 그것을 써서 시스템
부담을 줄이는 것이 현명하다. 다음 코드는 해야 할 일을 보이려고 표준 \PASCAL을 쓰지만,
잘 발달한 \PASCAL\ 설치처에서는 대개 더 세밀한 조율이 가능하다.
@^inner loop@>

@<함수들@>=
func input_ln(f *alpha_file, bypass_eoln bool) bool { // 다음 줄을 입력하거나 |false|를 돌려준다
	var last_nonblank int32 // 줄 끝의 공백을 지운 |last|
	last = first // 마태복음 19:30 참조
	c, err := f.r.ReadByte()
	if err != nil {
		return false
	}
	last_nonblank = first
	for err == nil && c != '\n' {
		@<문자 |c|를 |buffer|에 넣고 다음 문자를 읽는다@>
	}
	last = last_nonblank
	return true
}

@ \dg 앞 절의 안쪽 루프 몸체다.

보충: \GO/의 |bufio.Reader|에서는 줄 끝 문자를 버퍼 변수에 남겨 두는 대신 줄을 읽을 때 함께
읽어 버리는 편이 자연스럽다. 그러면 다음 줄을 읽기 전에 |eoln|을 건너뛸 필요가 없으므로
|bypass_eoln|은 쓰이지 않는다. 그 밖의 동작은 원본과 같다. 파일의 끝에서 첫 바이트를 읽지
못하면 |false|를 돌려주고, 마지막 줄에 줄바꿈 문자가 없어도 그 줄을 읽는다.
@^system dependencies@>

@<문자 |c|를 |buffer|에...@>=
if last >= max_buf_stack {
	max_buf_stack = last + 1
	if max_buf_stack == buf_size {
		@<입력 버퍼의 넘침을 알리고 그만둔다@>
	}
}
buffer[last] = xord[c]
c, err = f.r.ReadByte()
last++
if buffer[last-1] != ' ' {
	last_nonblank = last
}

@ 사용자의 터미널은 다른 텍스트 파일들과 본질적으로 똑같이 행동한다. 다만 입력과 출력에
모두 쓰인다는 점이 다르다. 터미널을 입력 파일로 볼 때는 파일 변수를 |term_in|이라고 부르고,
출력 파일로 볼 때는 |term_out|이라고 부른다.
@^system dependencies@>

@<전역 변수@>=
var @!term_in alpha_file // 입력 파일로서의 터미널
var @!term_out alpha_file // 출력 파일로서의 터미널

@ 다음은 \ph에서 터미널 파일들을 여는 방법이다. `\.{/I}' 스위치는 첫 |get|을 막는다.
@^PASCAL H@>
@^system dependencies@>

보충: \GO/에서는 표준 입력과 표준 출력이 터미널이다.

@<정의@>=
func t_open_in()  { term_in.r = bufio.NewReader(os.Stdin) }  // 터미널을 텍스트 입력용으로 연다
func t_open_out() { term_out.w = bufio.NewWriter(os.Stdout) } // 터미널을 텍스트 출력용으로 연다

@ 사용자의 터미널에서는 입력과 출력이 뒤섞이므로 그 둘을 맞추어야 할 때가 있다. 이 목적에는
시스템에 따라 다른 프로시저 셋을 쓴다. 첫째인 |update_terminal|은 지금까지 터미널에 출력한 것이 모두
실제로 컴퓨터의 내부 버퍼를 떠나 보내졌는지 확인하고 싶을 때 부른다. 둘째인
|clear_terminal|은 사용자가 미리 쳐 둔 입력을 모두 취소하고 싶을 때 부른다(곧 뜻밖의 오류
메시지를 낼 참이기 때문이다). 셋째인 |wake_up_terminal|은 사용자가 운영체제에 어떤 지시를
해서 터미널을 꺼 두었다면 그것을 되살리기로 되어 있다. 다음 매크로들은 이 연산들을 \ph에서
어떻게 지정하는지 보여 준다.
@^PASCAL H@>
@^system dependencies@>

보충: \GO/에서 미리 쳐 둔 입력을 취소하거나 꺼 둔 터미널을 되살리는 이식성 있는 방법은
없으므로, 뒤의 둘은 아무 일도 하지 않는다.

@<정의@>=
func update_terminal()  { term_out.w.Flush() } // 터미널 출력 버퍼를 비운다
func clear_terminal()   {}                     // 터미널 입력 버퍼를 비운다
func wake_up_terminal() {}                     // 사용자가 출력을 막아 둔 것을 푼다

@ \TeX\ 입력의 첫 줄을 사용자의 터미널에서 읽으려면 특별한 루틴이 필요하다. 이 줄이 다른
것은 기록 파일을 열기 전에 읽기 때문이다. 여기에는 일종의 ``닭이 먼저냐 달걀이 먼저냐''
문제가 있다. 사용자가 첫 줄에 `\.{\\input paper}'를 치거나, 그 줄이 부른 어떤 매크로가 그런
\.{\\input}을 하면 기록 파일의 이름은 `\.{paper.log}'가 된다. 그러나 터미널 입력의 첫 줄을
처리하는 동안 \.{\\input} 명령이 하나도 실행되지 않으면, 기록 파일은 기본 이름
`\.{texput.log}'를 얻게 된다. (첫 \.{\\input} 명령 전에 첫 줄이 낸 오류 메시지는 기록
파일에 들어가지 않는다.)
@.texput@>

운이 좋아서 운영체제가 \TeX을 평범한 \PASCAL\ 목적 프로그램과 다르게 대해 준다면 첫 줄은
더욱 특별하다. 사용자가 `\.{tex paper}' 같은 명령줄을 쳐서 \TeX\ 작업을 시작할 수 있으면
좋다. 그런 경우 \TeX은 입력의 첫 줄이 `\.{paper}'인 것처럼, 곧 첫 줄이 명령줄에서 \TeX을
부른 부분 뒤의 나머지인 것처럼 동작할 것이다.

첫 줄은 또 \TeX이 포맷 파일을 읽어 들이기 전에 읽힐 수도 있다는 점에서도 특별하다. 그런
경우에는 아직 보통의 오류 메시지를 낼 수 없다. 다음 코드는 나중에 설명할 개념들을 쓴다.
(\PASCAL\ 컴파일러가 비지역 |@!goto|를 지원하지 않는다면 `|goto final_end|' 문은 프로그램을
조용히 끝내는 무언가로 바꾸어야 한다.)
@^system dependencies@>

보충: \GO/에서는 |panic(final_end)|가 그 노릇을 한다(\os6). 원본의
|cur_input.loc_field|와 |cur_input.limit_field|는 이 번역에서 전역 변수 |loc|과
|limit|이다(\os{302}).

@<입력 버퍼의 넘침을 알리고 그만둔다@>=
if format_ident == 0 {
	write_ln(&term_out, "Buffer size exceeded!")
	panic(final_end)
@.Buffer size exceeded@>
} else {
	loc = first
	limit = last - 1
	overflow("buffer size", buf_size)
@:TeX capacity exceeded buffer size}{\quad buffer size@>
}

@ 시스템마다 시작하는 방법이 다르다. 그러나 어떤 관례를 받아들이든, 터미널을 초기화하는
루틴은 다음 명세를 만족해야 한다.

\yskip\textindent{1)}터미널로부터 입력받도록 파일 |term_in|을 연다. (파일 |term_out|은
이미 터미널로 출력하도록 열려 있을 것이다.)

\textindent{2)}사용자가 명령줄을 주었다면 그 줄을 터미널 입력의 첫 줄로 여긴다. 그렇지
않으면 사용자에게 `\.{**}'로 입력을 재촉하고, 그에 대한 대답으로 친 것을 입력의 첫 줄로
삼는다.

\textindent{3)}입력의 첫 줄은, 명령줄이든 아니든, 배열 |buffer|의 위치 |first|부터
|last-1|까지에 나타나야 한다.

\textindent{4)}전역 변수 |loc|은 \TeX이 다음에 읽을 문자가 |buffer[loc]|에 있도록 정해야
한다. 이 문자는 공백이 아니어야 하고, |loc<last|여야 한다.

\yskip\noindent(공백이 아닌 줄이 들어올 때까지 사용자에게 여러 번 재촉해야 할 수도 있다.
재촉 기호가 나중의 `\.*' 대신 `\.{**}'인 것은 뜻이 조금 다르기 때문이다. `\.{**}' 바로 뒤에는
`\.{\\input}'을 치지 않아도 된다.)

보충: 원본은 여기서 매크로 |loc|을 |cur_input.loc_field|로 정의한다. 이 번역에서
|loc|은 전역 변수이고, \os{302}에서 다른 입력 상태 변수들과 함께 선언한다.

@ 다음 프로그램은 명령줄을 얻어 오지 않고 필요한 초기화를 한다. 시스템이 명령줄을
허용한다면 이 루틴을 어떻게 고쳐서 명령줄을 다룰지는 분명할 것이다.
@^system dependencies@>

보충: \GO/에서는 명령줄 인자를 |os.Args|로 얻을 수 있으므로, 옮긴이는 바로 그렇게 고쳤다.
인자가 있으면 그것들을 공백으로 이어 붙인 것을 첫 줄로 삼는다. 다만 첫 인자가
`\.{-ini}'면 그것은 \.{INITEX}로 돌라는 뜻이므로(\os{1332}) 첫 줄에 넣지 않는다. 이를테면
`\.{tex -ini plain \\dump}'라고 치면 첫 줄은 `\.{plain \\dump}'가 된다. 첫 줄이 버퍼에 다
들어가지 않으면 명령줄이 없는 것처럼 한다.

@<함수들@>=
func init_terminal() bool { // 터미널 입력을 시작한다
	t_open_in()
	@<명령줄이 있으면 그것을 첫 줄로 삼고 |return true|@>
	for {
		wake_up_terminal()
		write(&term_out, "**")
		update_terminal()
@.**@>
		if !input_ln(&term_in, true) { // 이런 일은 일어나지 않아야 한다
			write_ln(&term_out)
			write(&term_out, "! End of file on the terminal... why?")
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
		write_ln(&term_out, "Please type the name of your input file.")
	}
}

@ \dg 명령줄의 인자들을 공백으로 이어 붙여 버퍼의 |first|부터 넣는다. 그것이 온통 공백이 아니면 원본이
터미널의 첫 줄을 받았을 때와 똑같이 |loc|을 정하고 |true|를 돌려준다.

@<명령줄이 있으면...@>=
args := os.Args[1:]
if len(args) > 0 && args[0] == "-ini" {
	args = args[1:]
}
if cmd := strings.Join(args, " "); len(cmd) > 0 && first+int32(len(cmd)) < buf_size {
	last = first
	for k := 0; k < len(cmd); k++ {
		buffer[last] = xord[cmd[k]]
		last++
	}
	for last > first && buffer[last-1] == ' ' { // |input_ln|처럼 줄 끝의 공백을 지운다
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
제어 시퀀스의 이름과 진단 메시지는 8비트 문자들로 된 가변 길이 문자열이다. \PASCAL에는 잘
발달한 문자열 기능이 없으므로, \TeX은 모든 문자열 처리를 손수 만든 방법으로 한다.

정교한 동적 문자열 기능은 필요 없으므로, 필요한 연산은 모두 간단한 자료 구조로 처리할 수
있다. 배열 |str_pool|은 모든 문자열의 모든 (8비트) {\mc ASCII} 코드를 담고, 배열
|str_start|는 각 문자열의 시작점의 첨자를 담는다. 문자열은 정수 번호로 가리키므로, 문자열
번호 |s|는 |str_start[s]<=j<str_start[s+1]|인 문자 |str_pool[j]|들로 이루어진다. 정수 변수
|pool_ptr|과 |str_ptr|은 각각 |str_pool|과 |str_start|에서 지금까지 쓴 항목의 수를
나타낸다. 위치 |str_pool[pool_ptr]|와 |str_start[str_ptr]|는 다음 문자열을 할당할 준비가
되어 있다.

문자열 번호 0부터 255까지는 {\mc ASCII} 문자 하나에 해당하는 문자열을 위해 남겨 둔다. 이것은
\.{WEB}의 관례에 따른 것이다. \.{WEB}은 문자 하나짜리 문자열을 그 문자의 {\mc ASCII} 코드
@.WEB@>
번호로 바꾸고, 다른 문자열들은 정수로 바꾸어 문자열 풀 파일을 만든다. 그래서 아래
프로그램에 문자열 상수 \.{"."}가 나오면 \.{WEB}은 그것을 마침표의 {\mc ASCII} 코드인 정수
46으로 바꾸고, \.{"hello"} 같은 문자열은 255보다 큰 어떤 정수로 바꾼다. 문자열 번호 46은
아마 문자 하나 `\..'일 것이다. 그러나 어떤 {\mc ASCII} 코드에는 표준적인 보이는 표현이
없는데, \TeX은 때로 임의의 {\mc ASCII} 문자를 찍을 수 있어야 하므로, 처음 256개의 문자열은
256가지 경우 각각에 대해 무엇을 찍어야 하는지 정확히 지정하는 데 쓴다.

배열 |str_pool|의 원소는 실제로 찍을 수 있는 {\mc ASCII} 코드여야 한다. 곧 그 지역의 문자
집합에 |xchr| 등가물이 있어야 한다. (이 제약은 미리 실어 둔 문자열에만 적용되고, 사용자가
동적으로 만든 문자열에는 적용되지 않는다.)

어떤 \PASCAL\ 컴파일러는 정수가 |-128..127| 범위에 있지 않으면 한 바이트에 묶어 넣지
않는다. 그런 시스템을 받아들이려고, 우리는 쉽게 다시 정의할 수 있는 매크로를 통해서만
문자열 풀에 접근한다.
@^system dependencies@>

보충: 이 번역에서는 |packed_ASCII_code|만 바이트(|uint8|)이고 |ASCII_code|는 |int32|의
별칭이므로, 원본의 매크로 |si|와 |so|는 정말로 형을 바꾸는 함수가 된다. 원본이 이 둘을 빠짐없이
쓴 덕분에 \GO/의 형 검사가 그 쓰임새를 하나하나 확인해 준다.

@<바깥 블록의 형@>=
type @!pool_pointer = int32 // |str_pool|을 가리키는 변수를 위해; |0..pool_size|
type @!str_number = int32 // |str_start|를 가리키는 변수를 위해; |0..max_strings|
type @!packed_ASCII_code = uint8 // 배열 |str_pool|의 원소

func si(c ASCII_code) packed_ASCII_code { return packed_ASCII_code(c) } // |ASCII_code|를 |packed_ASCII_code|로 바꾼다
func so(c packed_ASCII_code) ASCII_code { return ASCII_code(c) } // |packed_ASCII_code|를 |ASCII_code|로 바꾼다

@ @<전역 변수@>=
var @!str_pool [pool_size + 1]packed_ASCII_code // 문자들
var @!str_start [max_strings + 1]pool_pointer // 시작 포인터들
var @!pool_ptr pool_pointer // |str_pool|에서 쓰이지 않는 첫 위치
var @!str_ptr str_number // 지금 만들고 있는 문자열의 번호
var @!init_pool_ptr pool_pointer // |pool_ptr|의 처음 값
var @!init_str_ptr str_number // |str_ptr|의 처음 값

@ 기본적인 문자열 연산 가운데 몇몇은 \PASCAL\ 프로시저 대신 \.{WEB} 매크로로 한다. 그 연산들
가운데 많은 것이 아주 자주 쓰이므로 프로시저 호출의 부담을 피하고 싶기 때문이다. 이를테면
다음은 문자열의 길이를 계산하는 간단한 매크로다.
@.WEB@>

보충: \GO/ 컴파일러는 이런 작은 함수를 부르는 곳에 펼쳐 넣으므로, 함수로 옮겨도 부담은 없다.

@<정의@>=
func length(s str_number) int32 { return str_start[s+1] - str_start[s] } // 문자열 |s|의 문자 수

@ 현재 문자열의 길이는 |cur_length|라고 부른다.

@<정의@>=
func cur_length() int32 { return pool_ptr - str_start[str_ptr] }

@ 문자열은 문자 코드를 |str_pool|에 덧붙여서 만든다. 여기서 정의하는 매크로 |append_char|는
|pool_ptr|의 값이 너무 커졌는지 검사하지 않는다. 이 검사는 |append_char|를 쓰기 전에 해야 한다.
덧붙인 마지막 문자를 지우는 매크로 |flush_char|도 있다.

배열 |str_pool|에 문자를 |l|개 더 덧붙일 자리가 있는지 검사하려면 |str_room(l)|이라고 쓴다. 자리가
없으면 이것은 사과하는 오류 메시지를 내고 \TeX을 그만두게 한다.

@<정의@>=
func append_char(c ASCII_code) { // |ASCII_code| |c|를 |str_pool|의 끝에 넣는다
	str_pool[pool_ptr] = si(c)
	pool_ptr++
}

func flush_char() { pool_ptr-- } // 풀의 마지막 문자를 잊는다

func str_room(l int32) { // 풀이 넘치지 않았는지 확인한다
	if pool_ptr+l > pool_size {
		overflow("pool size", pool_size-init_pool_ptr)
@:TeX capacity exceeded pool size}{\quad pool size@>
	}
}

@ 일련의 문자들을 |str_pool|에 덧붙이고 나면, 함수 |make_string|을 부를 때 그것이 정식으로
문자열이 된다. 이 함수는 새 문자열의 식별 번호를 값으로 돌려준다.

@<함수들@>=
func make_string() str_number { // 현재 문자열이 풀에 들어간다
	if str_ptr == max_strings {
		overflow("number of strings", max_strings-init_str_ptr)
@:TeX capacity exceeded number of strings}{\quad number of strings@>
	}
	str_ptr++
	str_start[str_ptr] = pool_ptr
	return str_ptr - 1
}

@ 가장 최근에 만든 문자열을 없애려면 |flush_string|이라고 한다.

@<정의@>=
func flush_string() {
	str_ptr--
	pool_ptr = str_start[str_ptr]
}

@ 다음 서브루틴은 문자열 |s|를, |buffer|의 위치 |k|에서 시작하는 같은 길이의 다른 문자열과
비교한다. 두 문자열이 같을 때, 그리고 오직 그때에만 결과는 |true|다. 실험해 보니
|str_eq_buf|는 약 80퍼센트의 경우에 |true|를 돌려주는 방식으로 쓰이는 경향이 있다.

@<함수들@>=
func str_eq_buf(s str_number, k int32) bool { // 문자열이 같은지 검사한다
	var j pool_pointer // 차례로 도는 첨자
	var result bool // 비교의 결과
	j = str_start[s]
	for j < str_start[s+1] {
		if so(str_pool[j]) != buffer[k] {
			result = false
			goto not_found
		}
		j++
		k++
	}
	result = true
not_found:
	return result
}

@ 다음은 비슷한 루틴인데, 문자열 풀 안의 두 문자열을 비교하며 두 문자열의 길이가 같다고
가정하지 않는다.

@<함수들@>=
func str_eq_str(s, t str_number) bool { // 문자열이 같은지 검사한다
	var j, k pool_pointer // 차례로 도는 첨자들
	var result bool // 비교의 결과
	result = false
	if length(s) != length(t) {
		goto not_found
	}
	j = str_start[s]
	k = str_start[t]
	for j < str_start[s+1] {
		if str_pool[j] != str_pool[k] {
			goto not_found
		}
		j++
		k++
	}
	result = true
not_found:
	return result
}

@ 변수 |str_pool|, |str_start|, |pool_ptr|, |str_ptr|의 처음 값은 \.{INITEX} 프로그램이
계산하는데, 그 일부는 \.{WEB}이 \TeX을 처리하면서 출력한 정보를 바탕으로 한다.
@.INITEX@>
@^string pool@>

보충: 이 함수는 \.{INITEX}에서만 쓰인다. 원본은 이것을 `$|init|\ldots|tini|$'로 둘러쌌다.

@<함수들@>=
func get_strings_started() bool { // 문자열 풀을 초기화한다.
	// 무언가 잘못되면 |false|를 돌려준다
	var k, l int32 // 작은 첨자가나 계수기
	pool_ptr = 0
	str_ptr = 0
	str_start[0] = 0
	@<처음 256개의 문자열을 만든다@>
	@<나머지 문자열을 \.{TEX.POOL}에서 읽고 |true|나 |false|를 돌려준다@>
}

@ 보충: 원본은 이 절의 정의부에서 매크로 |app_lc_hex|를 정의한다. 이 매크로는 이 절의
코드에서만 쓰이므로, \GO/에서는 코드 안의 함수 리터럴로 옮겼다.

@<처음 256개...@>=
app_lc_hex := func(x int32) {
	l = x
	if l < 10 {
		append_char(l + '0')
	} else {
		append_char(l - 10 + 'a')
	}
}
for k = 0; k <= 255; k++ {
	unprintable := @<문자 |k|를 찍을 수 없다@>
	if unprintable {
		append_char('^')
		append_char('^')
		if k < 0o100 {
			append_char(k + 0o100)
		} else if k < 0o200 {
			append_char(k - 0o100)
		} else {
			app_lc_hex(k / 16)
			app_lc_hex(k % 16)
		}
	} else {
		append_char(k)
	}
	make_string() // 원본은 결과를 쓰레기 변수 |g|에 넣는다
}

@ 처음 128개의 문자열에는 95개의 표준 {\mc ASCII} 문자가 들어가고, 나머지 33개의 문자는
시스템에 따른 변경을 여기서 하지 않는 한 `\.{\^\^A}' 같은 세 기호 꼴로 찍힐 것이다. 확장
문자 집합을 가진 설치처, 이를테면 |xchr[@'32]=@t\.{\'^^Z\'}@>|인 곳에서는 문자열 \.{'32}가
세 문자 \.{'136}, \.{'136}, \.{'132}(\.{\^\^Z}) 대신 문자 하나 \.{'32}이기를 바랄 것이다.
한편 확장 문자 집합을 가진 사람들도 문자열 \.{'15}는 \.{\^\^M}으로 나타내고 싶을 것이다.
\.{'15}는 |carriage_return|이기 때문이다. 탭이나 줄 먹임이나 캐리지 리턴이나 벨 소리, 또는
텍스트 파일에서 이상하게 다루어지는 문자들 대신 눈에 보이는 문자열을 만들어 내자는 것이다.

코드 128--255의 찍을 수 없는 문자들도 비슷하게 \.{\^\^80}--\.{\^\^ff}로 나타낸다.

여기서 정의하는 불 식은 \TeX\ 내부 코드 번호~|k|가 그 지역의 문자 집합에서 말썽 없는 보이는
기호에 해당하지 않는 한 |true|여야 한다. 이를테면 {\sl The \TeX book}이 권하는 확장 문자
집합에 알맞은 식은 `|k in [0,@'10..@'12,@'14,@'15,@'33,@'177..@'377]|'일 것이다. 문자 |k|를
찍을 수 없고 |k<@'200|이면 문자 |k+@'100|이나 |k-@'100|은 찍을 수 있어야 한다. 게다가
{\mc ASCII} 코드 |[@'41..@'46, @'60..@'71, @'136, @'141..@'146, @'160..@'171]|은 찍을 수
있어야 한다. 그러므로 찍을 수 있는 문자가 적어도 80개는 필요하다.
@^TeXbook@>
@^character set dependencies@>
@^system dependencies@>

@<문자 |k|를 찍을 수 없다@>=
(k < ' ' || k > '~')

@ \.{WEB} 시스템 프로그램인 \.{TANGLE}은 지금 읽고 있는 \.{TEX.WEB} 서술을 처리하면서
\PASCAL\ 프로그램 \.{TEX.PAS}와 함께 문자열 풀 파일 \.{TEX.POOL}을 출력한다. \.{INITEX}
@.WEB@>@.INITEX@>
프로그램은 이 풀 파일을 읽어 들여서 그 정보를 \TeX의 문자열 메모리에 기록한다. 풀 파일에서
각 문자열은 두 자리 십진 길이 다음에 문자열 자체가 오는 꼴로 나타난다.

보충: \.{GWEB}은 문자열 풀 파일을 만들지 않는다. 이 번역에서 \TeX\ 자신의 메시지들은 \GO/의
문자열 상수로 남아 있고, |print| 같은 프로시저가 그것을 직접 찍는다(\os{59}). 그러나 원본의
문자열 상수 가운데 몇몇은 찍히기만 하는 것이 아니라 문자열 번호로서 변수에 들어가거나 다른
문자열 번호와 비교된다. 이를테면 |cur_ext:=".tex"|나 |if cur_ext="" then|$\,\ldots\,$ 같은
것이다. 그런 문자열들은 풀 안에 있어야 하므로, 옮긴이는 그것들을 목록 |pool_literals|에 모아
두고 \.{INITEX}가 처음 256개의 문자열 바로 다음에 차례로 풀에 넣게 했다. 그러면 목록의 $i$번째
문자열의 번호는 언제나 $256+i$가 된다. 포맷 파일은 풀 전체를 담으므로 실무용 판에서도 번호가
같다. 함수 |str|이 문자열 상수의 번호를 돌려준다(\os{53} 다음의 덧붙인 절). 원본에서 풀 파일을
가리키던 전역 변수 |pool_file|은 필요 없다.

@<전역 변수@>=
var @!pool_literals = [...]string{ // 번호로 쓰이는 문자열 상수들
	"", ".tex", ".log", ".dvi", ".fmt", ".tfm", "texput", "notexpanded:",
	"endgroup", "relax", "fi", "TeXinputs:", "TeXfonts:", "nullfont",
	"0234000122*4000133**3**344*0400400*000000234000111*1111112341011", "cr",
	"endtemplate", "right", "inaccessible", "FONT", " (INITEX)", "endwrite",
}

@ 보충: 원본의 매크로 |bad_pool(#)|은 메시지 |#|를 터미널에 쓰고 풀 파일을 닫은 뒤
|get_strings_started|가 |false|를 돌려주게 한다. 이 번역에는 풀 파일이 없으므로 여기서는
문자열들을 목록 |pool_literals|에서 가져온다.

@<나머지 문자열을...@>=
for _, lit := range pool_literals {
	@<문자열 하나를 읽되, 자리가 빠듯하면 |false|를 돌려준다@>
}
return true

@ 보충: 원본은 풀 파일의 각 줄에서 두 자리 길이를 읽고 그만큼의 문자를 읽는다. 여기서는
\GO/ 문자열 |lit|의 길이가 곧 |l|이다. 그 밖의 검사는 원본과 같다.

@<문자열 하나를 읽되...@>=
l = int32(len(lit)) // 길이를 계산한다
if pool_ptr+l+string_vacancies > pool_size {
	wake_up_terminal()
	write_ln(&term_out, "! You have to increase POOLSIZE.")
@.You have to increase POOLSIZE@>
	return false
}
for k = 0; k < l; k++ {
	append_char(xord[lit[k]])
}
make_string()

@ \.{WEB}의 연산 \.{@@\$}는 이 \.{TEX.POOL} 파일의 끝에 있어야 할 값을 나타낸다. 다른 값이
있으면 엉뚱한 풀 파일을 읽어 들인 것이다.
@^check sum@>

보충: 원본은 여기서 풀 파일 끝의 아홉 자리 검사합을 읽고 맞추어 본다. 검사합이 맞지 않으면
\.{TEX.POOL doesn't match; TANGLE me again.}이라고 알린다. 풀 파일이 없는 이 번역에는
해당하는 코드가 없다.

@ \dg 함수 |str|은 \GO/ 문자열 상수 |s|에 해당하는 풀 문자열의 번호를 돌려준다. \.{WEB}이
한 문자짜리 문자열 상수를 그 문자의 코드로 바꾸듯이, 길이가 1인 문자열에는 그 문자의 코드를
돌려준다. 그 밖의 문자열은 목록 |pool_literals|에 있어야 한다. 목록에 없는 문자열을 물으면
옮긴이의 잘못이므로 |panic|을 일으킨다.

@<함수들@>=
func str(s string) str_number {
	if len(s) == 1 {
		return str_number(s[0])
	}
	for i, lit := range pool_literals {
		if lit == s {
			return 256 + str_number(i)
		}
	}
	panic("str: " + s + " is not in pool_literals")
}

@* 화면과 기록 파일에 찍기.
사용자의 터미널과 기록 파일로 보내는 메시지는 여러 `|print|' 프로시저가 만든다. 이
프로시저들은 전역 변수 |selector|의 값에 따라 출력을 여러 곳으로 보내는데, 그 값은 다음과
같을 수 있다.

\yskip
\hang |term_and_log|, 보통의 설정으로, 터미널과 기록 파일에 찍는다.

\hang |log_only|, 기록 파일에만 찍는다.

\hang |term_only|, 터미널에만 찍는다.

\hang |no_print|, 아무 데도 찍지 않는다. 기록 파일을 열기 전의 드문 경우에만 쓰인다.

\hang |pseudo|, 출력을 순환 버퍼에 넣는다. 이 버퍼는 루틴 |show_context|가 쓴다. 이 이상한
방식을 쓰는 까닭은 그 루틴에 이르렀을 때 이야기할 것이다.

\hang |new_string|, 출력을 문자열 풀의 현재 문자열에 덧붙인다.

\hang 0부터 15까지, \.{\\write}의 출력을 위한 열여섯 파일 가운데 하나에 찍는다.

\yskip
\noindent 기호 이름 `|term_and_log|' 따위에는 |no_print+1=term_only|, |no_print+2=log_only|,
|term_only+2=log_only+1=term_and_log|라는 편리한 관계를 만족하는 수 코드를 주었다.

전역 변수 셋, 곧 |tally|와 |term_offset|과 |file_offset|은 가장 최근에 0으로 되돌린 뒤로
찍은 문자의 수를 기록한다. 변수 |tally|는 (아주 길 수도 있는) 찍은 구간의 길이를 기록하는 데
쓴다. 한편 |term_offset|과 |file_offset|은 각각 터미널과 기록 파일에 출력하고 있는 현재
줄에 지금까지 문자가 몇 개 나왔는지 추적한다.

@<전역 변수@>=
const (
	@!no_print = 16 // 자료가 사라지게 하는 |selector| 설정
	@!term_only = 17 // 터미널에만 찍는다
	@!log_only = 18 // 기록 파일에만 찍는다
	@!term_and_log = 19 // 보통의 |selector| 설정
	@!pseudo = 20 // |show_context|를 위한 특별한 |selector| 설정
	@!new_string = 21 // 찍는 것을 문자열 풀로 돌린다
	@!max_selector = 21 // 가장 큰 |selector| 설정
)

var @!log_file alpha_file // \TeX\ 작업의 기록
var @!selector int32 // 메시지를 찍을 곳; |0..max_selector|
var @!dig [23]int32 // 출력하고 있는 수의 숫자들; 저마다 |0..15|
var @!tally int32 // 최근에 찍은 문자의 수
var @!term_offset int32 // 현재 터미널 줄의 문자 수; |0..max_print_line|
var @!file_offset int32 // 현재 파일 줄의 문자 수; |0..max_print_line|
var @!trick_buf [error_line + 1]ASCII_code // 흉내 찍기를 위한 순환 버퍼
var @!trick_count int32 // 흉내 찍기의 문턱값; 나중에 설명한다
var @!first_count int32 // 흉내 찍기를 위한 또 하나의 변수

@ @<출력 루틴들을 초기화한다@>=
selector = term_only
tally = 0
term_offset = 0
file_offset = 0

@ 터미널과 기록 파일로 출력하는 매크로 약어들을 편의를 위해 여기서 정의한다. 어떤
시스템에서는 터미널 출력에 특별한 관례가 필요한데, 이 절에서 |wterm|, |wterm_ln|,
|wterm_cr|를 바꾸어 그 관례를 따를 수 있다.
@^system dependencies@>

@<정의@>=
func wterm(xs ...any)    { write(&term_out, xs...) }
func wterm_ln(xs ...any) { write_ln(&term_out, xs...) }
func wterm_cr()          { write_ln(&term_out) }
func wlog(xs ...any)     { write(&log_file, xs...) }
func wlog_ln(xs ...any)  { write_ln(&log_file, xs...) }
func wlog_cr()           { write_ln(&log_file) }

@ 텍스트 출력의 한 줄을 끝내려면 |print_ln|을 부른다.

@<기본 인쇄...@>=
func print_ln() { // 줄의 끝을 찍는다
	switch selector {
	case term_and_log:
		wterm_cr()
		wlog_cr()
		term_offset = 0
		file_offset = 0
	case log_only:
		wlog_cr()
		file_offset = 0
	case term_only:
		wterm_cr()
		term_offset = 0
	case no_print, pseudo, new_string:
		// 아무것도 하지 않는다
	default:
		write_ln(&write_file[selector])
	}
} // |tally|는 영향을 받지 않는다

@ 프로시저 |print_char|는 문자 하나를 원하는 곳으로 보낸다. 이때 배열 |xchr|를 써서 그 문자를
|input_ln|과 어울리는 외부 문자로 바꾼다. 찍는 것은 모두 |print_ln|이나 |print_char|를 거친다.

보충: 원본의 `\ignorespaces\.{if @@<문자 |s|가 현재의 줄바꿈 문자다@@> then}'처럼 이름 있는 절을
식으로 쓰는 곳이 몇 군데 있다. \.{gtangle}은 이름 있는 절을 펼칠 때 그 앞뒤에서 줄을 바꾸는데,
\GO/는 줄 끝의 `\.)' 뒤에 쌍반점을 넣으므로 |if| 문의 조건 자리에서는 이것이 문법 오류가 된다.
그래서 이런 곳에서는 절의 값을 먼저 지역 변수(여기서는 |is_nl|)에 받아 두고 그 변수를 검사한다.

@<기본 인쇄...@>=
func print_char(s ASCII_code) { // 문자 하나를 찍는다
	is_nl := @<문자 |s|가 현재의 줄바꿈 문자다@>
	if is_nl {
		if selector < pseudo {
			print_ln()
			return
		}
	}
	@<|selector|에 따라 문자 |s|를 보낸다@>
	tally++
}

@ \dg 앞 절의 |case| 문이다.

@<|selector|에 따라...@>=
switch selector {
case term_and_log:
	wterm(xchr[s])
	wlog(xchr[s])
	term_offset++
	file_offset++
	if term_offset == max_print_line {
		wterm_cr()
		term_offset = 0
	}
	if file_offset == max_print_line {
		wlog_cr()
		file_offset = 0
	}
case log_only:
	wlog(xchr[s])
	file_offset++
	if file_offset == max_print_line {
		print_ln()
	}
case term_only:
	wterm(xchr[s])
	term_offset++
	if term_offset == max_print_line {
		print_ln()
	}
case no_print:
	// 아무것도 하지 않는다
case pseudo:
	if tally < trick_count {
		trick_buf[tally%error_line] = s
	}
case new_string:
	if pool_ptr < pool_size {
		append_char(s)
	} // 문자열 공간이 가득 차면 문자들을 버린다
default:
	write(&write_file[selector], xchr[s])
}

@ 문자열 전체는 |print|를 불러서 출력한다. 표준 {\mc ASCII} 문자 하나 \.c를 출력할
때는 |print("c")|를 부를 수도 있다는 데 주목하라. 앞에서 설명했듯이 |"c"=99|가 문자 하나짜리
문자열의 번호이기 때문이다. 그러나 |print_char("c")|가 더 빠르므로, \TeX은 그것이 안전하다고
알 때에는 바로 |print_char| 루틴으로 간다. (지금의 구현은 보이는 {\mc ASCII} 문자를 찍는
것은 언제나 안전하다고 가정한다.)
@^system dependencies@>

보충: 이 번역에서 |print|의 인자 |x|는 원본처럼 문자열 번호(정수)일 수도 있고, \GO/의
문자열 상수일 수도 있다(\os{50}). 그래서 형이 |any|다. 길이가 1이 아닌 \GO/ 문자열은 원본에서
번호가 255보다 큰 풀 문자열에 해당하므로, 원본이 그런 문자열을 찍는 방법 그대로 그 문자들을
|print_char|로 찍는다. 길이가 1인 \GO/ 문자열은 \.{WEB}이 그렇게 하듯이 그 문자의 코드로
바꾼다. 그러므로 이를테면 |print(".")|는 원본에서처럼 |print(46)|과 같고, \.{\\newlinechar}가
마침표면 줄을 바꾼다. 인자를 문자열 번호로 바꾸는 일은 함수 |strnum|이 한다(다음 절).

원본은 |s|가 범위를 벗어나면 |s:="???"|라고 하고 그 문자열을 찍는다. \GO/에서 |s|는 정수이므로
여기서는 \GO/ 문자열 |"???"|를 바로 찍는다.

@<기본 인쇄...@>=
func print(x any) { // 문자열 |s|를 찍는다
	var j pool_pointer // 현재 문자 코드의 위치
	var nl int32 // 되돌려 놓을 줄바꿈 문자
	if t, ok := x.(string); ok && len(t) != 1 {
		for k := 0; k < len(t); k++ {
			print_char(xord[t[k]])
		}
		return
	}
	s := strnum(x)
	if s >= str_ptr {
		print("???") // 이런 일은 일어날 수 없다
		return
@.???@>
	} else if s < 256 {
		if s < 0 {
			print("???") // 일어날 수 없다
			return
		} else {
			@<한 문자짜리 문자열 |s|를 찍고 |return|한다@>
		}
	}
	j = str_start[s]
	for j < str_start[s+1] {
		print_char(so(str_pool[j]))
		j++
	}
}

@ \dg 앞 절에서 번호가 256보다 작은 문자열을 찍는 부분이다. 내부 문자열을 만들 때에는 문자를 그대로
넣는다. 그렇지 않으면 현재의 줄바꿈 문자는 줄바꿈으로 찍고, 다른 문자는 그 문자열(이를테면 \.{\^\^M})을
찍되 그 동안에는 줄바꿈 문자를 잠시 끈다.

@<한 문자짜리 문자열 |s|를...@>=
if selector > pseudo {
	print_char(s)
	return // 내부 문자열은 펼치지 않는다
}
is_nl := @<문자 |s|가 현재의 줄바꿈 문자다@>
if is_nl {
	if selector < pseudo {
		print_ln()
		return
	}
}
nl = new_line_char()
set_new_line_char(-1) // 줄바꿈 문자를 잠시 끈다
j = str_start[s]
for j < str_start[s+1] {
	print_char(so(str_pool[j]))
	j++
}
set_new_line_char(nl)
return

@ \dg 함수 |strnum|은 |print|와 그 친척들이 받은 인자를 문자열 번호로 바꾼다. 인자는 정수이거나
길이가 1인 \GO/ 문자열이어야 한다. \GO/의 작은따옴표 상수(|rune|)는 |int32|의 별칭이므로
그대로 문자 코드가 된다.

@<기본 인쇄...@>=
func strnum(x any) str_number {
	switch x := x.(type) {
	case int32:
		return x
	case int:
		return str_number(x)
	case string:
		return str(x)
	}
	panic(fmt.Sprintf("strnum: %T", x))
}

@ 제어 시퀀스의 이름, 파일 이름, \.{\\string}으로 만든 문자열에는 |print_char|로 찍을 수 없는
|ASCII_code| 값이 들어 있을 수 있다. 그래서 그런 것에는 |slow_print|를 쓴다.

보충: \GO/ 문자열 상수가 인자로 오면 그 문자들을 하나씩 |print|로 찍는다. 원본에서 풀
문자열을 이 프로시저로 찍을 때와 같다.

@<기본 인쇄...@>=
func slow_print(x any) { // 문자열 |s|를 찍는다
	var j pool_pointer // 현재 문자 코드의 위치
	if t, ok := x.(string); ok && len(t) != 1 {
		for k := 0; k < len(t); k++ {
			print(xord[t[k]])
		}
		return
	}
	s := strnum(x)
	if s >= str_ptr || s < 256 {
		print(s)
	} else {
		j = str_start[s]
		for j < str_start[s+1] {
			print(so(str_pool[j]))
			j++
		}
	}
}

@ 다음은 \TeX이 맨 처음 찍는 것, 곧 판 번호와 포맷 꾸러미를 밝히는 머리줄이다. 변수
|term_offset|은 잠시 틀린 값을 갖지만, 이 부분은 시스템에 따라 다르다고 가정하므로 그 어긋남은
심각하지 않다.
@^system dependencies@>

@<출력 루틴들을...@>=
wterm(banner)
if format_ident == 0 {
	wterm_ln(" (no format preloaded)")
} else {
	slow_print(format_ident)
	print_ln()
}
update_terminal()

@ 프로시저 |print_nl|은 |print|와 같지만, 문자열이 새 줄의 처음에 나타나도록 한다.

@<기본 인쇄...@>=
func print_nl(s any) { // 문자열 |s|를 줄의 처음에 찍는다
	if (term_offset > 0 && odd(selector)) ||
		(file_offset > 0 && selector >= log_only) {
		print_ln()
	}
	print(s)
}

@ 프로시저 |print_esc|는 사용자의 탈출 문자(대개 역빗금)를 앞세워 문자열을 찍는다.

@<기본 인쇄...@>=
func print_esc(s any) { // 탈출 문자를 찍고 나서 |s|를 찍는다
	var c int32 // 탈출 문자의 코드
	@<변수 |c|를 현재의 탈출 문자로 놓는다@>
	if c >= 0 {
		if c < 256 {
			print(c)
		}
	}
	slow_print(s)
}

@ 범위 |0..15|의 숫자들로 된 배열은 |print_the_digs|로 찍는다.

@<기본 인쇄...@>=
func print_the_digs(k eight_bits) { // |dig[k-1]|$\,\ldots\,$|dig[0]|을 찍는다
	for k > 0 {
		k--
		if dig[k] < 10 {
			print_char('0' + dig[k])
		} else {
			print_char('A' - 10 + dig[k])
		}
	}
}

@ 정수 |n|의 십진 표현을 찍는 다음 프로시저는 |n=0|이거나 |(-n)|이 넘침을 일으킬 때에도
제대로 동작하도록 조심스럽게 썼다. 이것은 음수 인자에 |mod|나 |div|를 쓰지 않는다. 그런
연산은 모든 \PASCAL\ 컴파일러가 똑같이 구현하지는 않기 때문이다.

@<기본 인쇄...@>=
func print_int(n int32) { // 정수를 십진 꼴로 찍는다
	var k int32 // 현재 숫자의 첨자; $\vert n\vert<10^{23}$이라고 가정한다
	var m int32 // 위험할 수도 있는 경우에 |n|의 부호를 바꾸는 데 쓴다
	k = 0
	if n < 0 {
		print_char('-')
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
		n = n / 10
		k++
		if n == 0 {
			break
		}
	}
	print_the_digs(k)
}

@ 다음은 숫자 두 개를 찍는 하찮은 프로시저다. 대개 |0<=n<=99| 범위의 매개변수로 불린다.

@<함수들@>=
func print_two(n int32) { // 가장 낮은 두 자리 숫자를 찍는다
	n = abs(n) % 100
	print_char('0' + (n / 10))
	print_char('0' + (n % 10))
}

@ 음이 아닌 정수의 십육진 찍기는 |print_hex|가 한다.

@<함수들@>=
func print_hex(n int32) { // 양의 정수를 십육진 꼴로 찍는다
	var k int32 // 현재 숫자의 첨자; $0\L n<16^{22}$이라고 가정한다
	k = 0
	print_char('"')
	for {
		dig[k] = n % 16
		n = n / 16
		k++
		if n == 0 {
			break
		}
	}
	print_the_digs(k)
}

@ 옛 판의 \TeX에는 |print_ASCII|라는 프로시저가 필요했는데, 그 기능은 이제 |print|에 들어가
있다. 앞날의 소프트웨어 고고학자들에게 도움이 될 수도 있으므로 여기 옛 이름을 남겨 둔다.

@<정의@>=
var print_ASCII = print

@ 로마 숫자는 루틴 |print_roman_int|가 만든다. 수수께끼를 좋아하는 독자는 이 교묘한 코드가
어떻게 동작하는지 알아내 보며 즐길 수 있을 것이다. 그러니 설명은 하지 않겠다. 1990이
\.{mxm}이 아니라 \.{mcmxc}가 된다는 데 주목하라.

보충: 원본은 풀 문자열 \.{"m2d5c2l5x2v5i"}의 문자들을 |str_pool|에서 직접 읽는다. 여기서는
같은 \GO/ 문자열 |roman|을 첨자로 읽는다. 첨자 |j|와 |k|는 그 문자열의 처음에서 센다.

@<함수들@>=
func print_roman_int(n int32) {
	const roman = "m2d5c2l5x2v5i"
	var j, k pool_pointer // |roman|에 대한 수수께끼 같은 첨자들
	var u, v int32 // 수수께끼 같은 수들
	j = 0
	v = 1000
	for {
		for n >= v {
			print_char(ASCII_code(roman[j]))
			n = n - v
		}
		if n <= 0 {
			return // 양이 아닌 입력은 아무것도 출력하지 않는다
		}
		k = j + 2
		u = v / (ASCII_code(roman[k-1]) - '0')
		if roman[k-1] == '2' {
			k = k + 2
			u = u / (ASCII_code(roman[k-1]) - '0')
		}
		if n+u >= v {
			print_char(ASCII_code(roman[k]))
			n = n + u
		} else {
			j = j + 2
			v = v / (ASCII_code(roman[j-1]) - '0')
		}
	}
}

@ 서브루틴 |print|는 아직 만들고 있는 문자열을 찍지 않는다. 다음 프로시저는 찍는다.

@<함수들@>=
func print_current_string() { // 아직 만들지 않은 문자열을 찍는다
	var j pool_pointer // 현재 문자 코드를 가리킨다
	j = str_start[str_ptr]
	for j < pool_ptr {
		print_char(so(str_pool[j]))
		j++
	}
}

@ 다음은 사용자에게 입력 한 줄을 치라고 하는 프로시저다. 이 프로시저는 |selector|의 설정이 |term_only|나
|term_and_log|라고 가정한다. 입력은 배열 |buffer|의 위치 |first|부터 |last-1|까지에 들어가고,
알맞으면 기록 파일에 메아리친다.

이 프로시저는 |interaction<scroll_mode|일 때는 결코 불리지 않는다.

@<함수들@>=
func prompt_input(s any) { // 문자열을 찍고 입력 한 줄을 얻는다
	wake_up_terminal()
	print(s)
	term_input()
}

func term_input() { // 터미널에서 한 줄을 얻는다
	var k int32 // |buffer|의 첨자
	update_terminal() // 이제 사용자는 틀림없이 재촉 기호를 본다
	if !input_ln(&term_in, true) {
		fatal_error("End of file on the terminal!")
@.End of file on the terminal@>
	}
	term_offset = 0 // 사용자의 줄은 \<\rm return>으로 끝났다
	selector-- // 입력을 메아리칠 준비를 한다
	if last != first {
		for k = first; k <= last-1; k++ {
			print(buffer[k])
		}
	}
	print_ln()
	selector++ // 앞의 상태로 되돌린다
}

@* 오류 알리기.
무언가 이상한 것이 발견되면 \TeX은 대개 다음과 같은 일을 한다.
$$\vbox{\halign{#\hfil\cr
|print_err("Something anomalous has been detected")|\cr
|help3("This is the first line of my offer to help.",|\cr
|"This is the second line. I'm trying to",|\cr
|"explain the best way for you to proceed.")|\cr
|error()|\cr}}$$
도움말이 두 줄이면 |help2|를 쓰는 식이다. 이런 비공식 도움말은 찍힌 공식 오류 메시지의
낱말들을 보완하는 쉬운 낱말로 써야 한다. (미국 바깥에서는 도움말을 그 지역의 말로 옮기는
것이 좋다. 지금의 구현에서 도움말 한 줄은 많아야 60글자이므로 |max_print_line|을 넘지 않는다.)

프로시저 |print_err|는 공식 메시지 앞에 `\.!'를 붙이고, 멈추게 될 경우에 터미널이 깨어
있도록 한다. 프로시저 |error|는 공식 메시지 뒤에 `\..'를 붙이고 오류가 난 곳을 보여 준다. 또
|interaction=error_stop_mode|면 사용자와 대화에 들어가는데, 그동안 도움말을 찍을 수도 있다.
@^system dependencies@>

보충: 원본의 |help3|은 매개변수 세 개를 \.{WEB} 특유의 방식으로 하나씩 받는
매크로다(\os{79}). \GO/에서는 인자 셋을 받는 함수다.

@ 전역 변수 |interaction|의 설정은 넷인데, 사용자와 주고받는 정도가 차례로 커진다.

@<전역 변수@>=
const (
	@!batch_mode = 0 // 멈추지 않고 터미널 출력도 하지 않는다
	@!nonstop_mode = 1 // 멈추지 않는다
	@!scroll_mode = 2 // 오류에서 멈추지 않는다
	@!error_stop_mode = 3 // 기회가 있을 때마다 멈추어 사용자와 대화한다
)

func print_err(s any) {
	if interaction == error_stop_mode {
		wake_up_terminal()
	}
	print_nl("! ")
	print(s)
}

var @!interaction int32 // 사용자와 주고받는 현재 수준; |batch_mode..error_stop_mode|

@ @<핵심 변수들의...@>=
interaction = error_stop_mode

@ \TeX은 |selector|의 설정이 보통과 다를 수도 있을 때에는 |error|를 부르지 않도록
조심한다. 오류 메시지를 낼 때 |selector|가 가질 수 있는 값은 다음뿐이다.

\yskip\hang|no_print| (|interaction=batch_mode|이고 |log_file|을 아직 열지 않았을 때);

\hang|term_only| (|interaction>batch_mode|이고 |log_file|을 아직 열지 않았을 때);

\hang|log_only| (|interaction=batch_mode|이고 |log_file|이 열려 있을 때);

\hang|term_and_log| (|interaction>batch_mode|이고 |log_file|이 열려 있을 때).

@<|interaction|에 따라 찍기 |selector|를 초기화한다@>=
if interaction == batch_mode {
	selector = no_print
} else {
	selector = term_only
}

@ 프로시저 |error|를 부를 때 |get_next| 루틴이 활성이면 전역 변수 |deletions_allowed|를 |false|로
놓는다. 이렇게 해서 |get_next|와 |get_token| 같은 관련 루틴들이 결코 재귀적으로 불리지 않게
한다. 비슷한 잠금 장치가 |set_box_allowed|다.
@^recursion@>

전역 변수 |history|는 지금까지 발견된 오류 가운데 가장 나쁜 수준을 기록한다. 이 변수는 네
가지 값, 곧 |spotless|, |warning_issued|, |error_message_issued|, |fatal_error_stop|을 가질
수 있다.

또 하나의 전역 변수 |error_count|는 대화 없이 |error|가 일어날 때마다 1씩 늘어나고, 문단이
끝날 때마다 0으로 되돌아간다. 이 값이 100에 이르면 \TeX은 더 계속해 봐야 소용없다고
판단한다.

@<전역 변수@>=
const (
	@!spotless = 0 // 아직 아무 잘못도 없을 때의 |history| 값
	@!warning_issued = 1 // |begin_diagnostic|을 불렀을 때의 |history| 값
	@!error_message_issued = 2 // |error|를 불렀을 때의 |history| 값
	@!fatal_error_stop = 3 // 너무 일찍 끝났을 때의 |history| 값
)

var @!deletions_allowed bool // |error|가 |get_token|을 불러도 안전한가?
var @!set_box_allowed bool // \.{\\setbox} 대입을 해도 안전한가?
var @!history int32 // 지금까지 입력이 깨끗했나? |spotless..fatal_error_stop|
var @!error_count int32 // 지난 문단이 끝난 뒤로 대화 없이 지나간 오류의 수; |-1..100|

@ 변수 |history|의 처음 값은 |fatal_error_stop|이지만, \TeX이 초기화 과정에서 살아남으면
|spotless|로 바뀐다.

@<핵심 변수들의...@>=
deletions_allowed = true
set_box_allowed = true
error_count = 0 // |history|는 다른 곳에서 초기화한다

@ 오류는 \TeX의 거의 어디에서나 발견될 수 있으므로, 오류 프로시저들은 프로그램의 처음 가까이에서
선언하고 싶다. 그러나 오류 프로시저들은 다시 다른 프로시저들을 쓰고, 그것들은 |error| 자체에
이르기 전에 |forward|로 선언해야 한다.

프로시저 |get_token|으로 토큰 하나를 지우는 동안 어떤 오류가 일어나거나, \TeX이 치명적이지 않은 오류를
고치려 하는 동안 치명적인 오류가 일어나면 |error|가 재귀적으로 불릴 수 있다. 그러나 그런
재귀는 결코 두 단계보다 깊어지지 않는다.
@^recursion@>

보충: 원본은 여기서 오류 프로시저들이 쓰는 프로시저 열 개를 |forward|로 선언한다. 그것들은
|normalize_selector|와 |get_token|과 |term_input|과 |show_context|와 |begin_file_reading|과
|open_log_file|과 |close_files_and_terminate|와 |clear_for_error_prompt|와 |give_err_help|,
그리고 디버깅할 때만 쓰는 |debug_help|다. \GO/에서는 함수를
쓰기 전에 선언할 필요가 없으므로 이 절의 코드는 비어 있다.

@<오류 처리 프로시저@>=
// \GO/에서는 |forward| 선언이 필요 없다

@ 도움말의 낱낱의 줄은 배열 |help_line|에 기록된다. 이 배열의 위치 |0..(help_ptr-1)|에
항목들이 들어 있다. 그것들은 거꾸로, 곧 |help_line[0]|이 맨 마지막에 나오도록 찍어야 한다.

보충: 원본의 매크로 |help3("a")("b")("c")|는 |help_ptr:=3|, |help_line[2]:="a"|,
|help_line[1]:="b"|, |help_line[0]:="c"|로 펼쳐진다. 이 번역의 함수 |help3("a","b","c")|도
같은 일을 한다. 도움말은 언제나 문자열 상수이므로 |help_line|은 \GO/ 문자열의 배열이다.

@<전역 변수@>=
func help0() { help_ptr = 0 } // 이따금 도움말이 없을 수도 있다
func help1(a string) { // 도움말이 한 줄일 때 쓴다
	help_ptr = 1
	help_line[0] = a
}
func help2(a, b string) { // 도움말이 두 줄일 때 쓴다
	help_ptr = 2
	help_line[1], help_line[0] = a, b
}
func help3(a, b, c string) { // 도움말이 세 줄일 때 쓴다
	help_ptr = 3
	help_line[2], help_line[1], help_line[0] = a, b, c
}
func help4(a, b, c, d string) { // 도움말이 네 줄일 때 쓴다
	help_ptr = 4
	help_line[3], help_line[2], help_line[1], help_line[0] = a, b, c, d
}
func help5(a, b, c, d, e string) { // 도움말이 다섯 줄일 때 쓴다
	help_ptr = 5
	help_line[4], help_line[3], help_line[2], help_line[1], help_line[0] = a, b, c, d, e
}
func help6(a, b, c, d, e, f string) { // 도움말이 여섯 줄일 때 쓴다
	help_ptr = 6
	help_line[5], help_line[4], help_line[3] = a, b, c
	help_line[2], help_line[1], help_line[0] = d, e, f
}

var @!help_line [6]string // 다음 |error|를 위한 도움말
var @!help_ptr int32 // 들어 있는 도움말 줄의 수; |0..6|
var @!use_err_help bool // |err_help| 목록을 보여 주어야 하나?

@ @<핵심 변수들의...@>=
help_ptr = 0
use_err_help = false

@ 프로시저 |jump_out|은 활성인 모든 프로시저 단계를 그냥 가로질러 |end_of_TEX|로 간다. 이것이
프로그램 전체에서 단 하나의 뻔하지 않은 |@!goto| 문이다. 이것은 특정한 오류에서 회복할 길이
없을 때 쓰인다.

어떤 \PASCAL\ 컴파일러는 비지역 |goto| 문을 구현하지 않는다. 그런 경우 |jump_out|의 몸체는
@^system dependencies@>
그냥 `|close_files_and_terminate|;\thinspace' 다음에 프로그램을 조용히 끝내는 어떤 시스템
프로시저의 호출이 오는 것이어야 한다.

보충: \GO/에서는 |panic|으로 모든 함수를 빠져나가고, 주 프로그램이 그것을 받아 레이블
\ID{end\_of\_TEX}로 간다(\os6, \os{1332}).

@<오류 처리...@>=
func jump_out() {
	panic(end_of_TEX)
}

@ 이제 일반적인 |error| 루틴이다.

보충: \GO/의 이름 |error|는 내장 인터페이스 형의 이름이지만, 꾸러미 수준에서 함수 이름으로
다시 쓸 수 있다. 그러면 이 꾸러미 안에서는 내장 형 |error|를 쓸 수 없게 되는데, 이 프로그램은
그 형의 이름을 쓸 일이 없다.

@<오류 처리...@>=
func error() { // 오류 보고의 일을 마친다
	var c ASCII_code // 사용자가 친 것
	var s1, s2, s3, s4 int32 // 토큰을 지울 때 전역 변수들을 저장하는 데 쓴다
	if history < error_message_issued {
		history = error_message_issued
	}
	print_char('.')
	show_context()
	if interaction == error_stop_mode {
		@<사용자의 조언을 얻고 |return|한다@>
	}
	error_count++
	if error_count == 100 {
		print_nl("(That makes 100 errors; please try again.)")
@.That makes 100 errors...@>
		history = fatal_error_stop
		jump_out()
	}
	@<도움말을 기록 파일에 넣는다@>
}

@ 보충: 원본의 `|goto continue|'는 루프 몸체의 맨 처음으로 가므로, \GO/의 |continue| 문과 같다.
\GO/의 |continue|는 |switch| 문 안에서도 그것을 둘러싼 |for| 루프에 대해 작용한다.

@<사용자의 조언을...@>=
for {
	if interaction != error_stop_mode {
		return
	}
	clear_for_error_prompt()
	prompt_input("? ")
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

@ 여기서 사용자가 \TeX에서 시스템 편집기로 쉽게 돌아갈 수 있도록, 문제의 줄을 바로 고칠 수
있게 해 주는 `\.E' 선택지를 주면 좋을 것이다. 그러나 그런 확장에는 시스템 마법이 좀 필요하므로,
지금의 구현은 고쳐야 할 파일의 이름과 해당 줄 번호를 찍어 주기만 한다.
@^system dependencies@>

디버깅 루틴들을 주석으로 막지 않았을 때 쓸 수 있는 비밀 선택지 `\.D'도 있다.
@^debugging@>

@<코드 |c|를 해석하고...@>=
switch c {
case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
	if deletions_allowed {
		@<토큰 |c-"0"|개를 지우고 |goto continue|@>
	}
case 'D':
	if debug {
		debug_help()
		continue
	}
case 'E':
	if base_ptr > 0 {
		if input_stack[base_ptr].name_field >= 256 {
			print_nl("You want to edit file ")
@.You want to edit file x@>
			slow_print(input_stack[base_ptr].name_field)
			print(" at line ")
			print_int(line)
			interaction = scroll_mode
			jump_out()
		}
	}
case 'H':
	@<도움말 정보를 찍고 |goto continue|@>
case 'I':
	@<터미널에서 새 재료를 끼워 넣고 |return|한다@>
case 'Q', 'R', 'S':
	@<대화 수준을 바꾸고 |return|한다@>
case 'X':
	interaction = scroll_mode
	jump_out()
default:
	// 아무것도 하지 않는다
}
@<쓸 수 있는 선택지들의 차림표를 찍는다@>

@ @<쓸 수 있는 선택지들의...@>=
print("Type <return> to proceed, S to scroll future error messages,")
@.Type <return> to proceed...@>
print_nl("R to run without stopping, Q to run quietly,")
print_nl("I to insert something, ")
if base_ptr > 0 {
	if input_stack[base_ptr].name_field >= 256 {
		print("E to edit your file,")
	}
}
if deletions_allowed {
	print_nl("1 or ... or 9 to ignore the next 1 to 9 tokens of input,")
}
print_nl("H for help, X to quit.")

@ 여기서 \TeX의 저자는 |"Q"|, |"R"|, |"S"|와 원하는 대화 설정 |batch_mode|, |nonstop_mode|,
|scroll_mode| 사이의 수치 관계를 이용한 것을 사과한다.
@^Knuth, Donald Ervin@>

@<대화 수준을...@>=
error_count = 0
interaction = batch_mode + c - 'Q'
print("OK, entering ")
switch c {
case 'Q':
	print_esc("batchmode")
	selector--
case 'R':
	print_esc("nonstopmode")
case 'S':
	print_esc("scrollmode")
} // 다른 경우는 없다
print("...")
print_ln()
update_terminal()
return

@ 다음 코드를 실행할 때, |buffer[(first+1)..(last-1)]|에는 사용자가 끼워 넣은 재료가 들어
있을 수 있다. 그렇지 않으면 다시 재촉한다. 프로그램의 이 부분을 완전히 이해하려면 \TeX의 입력
스택에 익숙해야 한다.

@<터미널에서 새 재료를...@>=
begin_file_reading() // 터미널 입력을 위해 새 구문 수준에 들어간다
// 이제 |state=mid_line|이므로, 처음의 공백은 공백으로 친다
if last > first+1 {
	loc = first + 1
	buffer[first] = ' '
} else {
	prompt_input("insert>")
	loc = first
@.insert>@>
}
first = last
limit = last - 1 // 이 줄은 |end_line_char|로 끝나지 않는다
return

@ 한 번에 토큰을 99개까지 지울 수 있다.

@<토큰 |c-"0"|개를...@>=
s1 = cur_tok
s2 = cur_cmd
s3 = cur_chr
s4 = align_state
align_state = 1000000
OK_to_interrupt = false
if last > first+1 && buffer[first+1] >= '0' && buffer[first+1] <= '9' {
	c = c*10 + buffer[first+1] - '0'*11
} else {
	c = c - '0'
}
for c > 0 {
	get_token() // |error|의 한 단계 재귀 호출이 일어날 수 있다
	c--
}
cur_tok = s1
cur_cmd = s2
cur_chr = s3
align_state = s4
OK_to_interrupt = true
help2("I have just deleted some text, as you asked.",
	"You can now delete more, or insert, or whatever.")
show_context()
continue

@ @<도움말 정보를...@>=
if use_err_help {
	give_err_help()
	use_err_help = false
} else {
	if help_ptr == 0 {
		help2("Sorry, I don't know how to help in this situation.",
			"Maybe you should try asking a human?")
	}
	for {
		help_ptr--
		print(help_line[help_ptr])
		print_ln()
		if help_ptr == 0 {
			break
		}
	}
}
help4("Sorry, I already gave what help I could...",
	"Maybe you should try asking a human?",
	"An error might have occurred before I noticed any problems.",
	"``If all else fails, read the instructions.''")
continue

@ @<도움말을 기록 파일에...@>=
if interaction > batch_mode {
	selector-- // 터미널 출력을 피한다
}
if use_err_help {
	print_ln()
	give_err_help()
} else {
	for help_ptr > 0 {
		help_ptr--
		print_nl(help_line[help_ptr])
	}
}
print_ln()
if interaction > batch_mode {
	selector++ // 터미널 출력을 다시 살린다
}
print_ln()

@ 오류 메시지 열두어 개가 괄호에 싼 정수로 끝나므로, 다음 프로시저를 선언해서 프로그램 공간을
아주 조금 아낀다.

@<함수들@>=
func int_error(n int32) {
	print(" (")
	print_int(n)
	print_char(')')
	error()
}

@ 이상한 경우에는 찍기 선택자가 알 수 없는 상태에 있을 수도 있다. 다음 서브루틴은 조금 더
오래 돌아갈 수 있을 만큼만 상황을 바로잡는다.

@<함수들@>=
func normalize_selector() {
	if log_opened {
		selector = term_and_log
	} else {
		selector = term_only
	}
	if job_name == 0 {
		open_log_file()
	}
	if interaction == batch_mode {
		selector--
	}
}

@ 다음 프로시저는 \TeX이 죽기 전에 남기는 마지막 말을 찍는다.

@<오류 처리...@>=
func succumb() {
	if interaction == error_stop_mode {
		interaction = scroll_mode // 더는 대화하지 않는다
	}
	if log_opened {
		error()
	}
	if debug {
		if interaction > batch_mode {
			debug_help()
		}
	}
	history = fatal_error_stop
	jump_out() // 회복할 수 없는 오류
}

func fatal_error(s string) { // |s|를 찍고, 그것으로 끝이다
	normalize_selector()
	print_err("Emergency stop")
	help1(s)
	succumb()
@.Emergency stop@>
}

@ 다음은 가장 무서운 오류 메시지다.

@<오류 처리...@>=
func overflow(s string, n int32) { // 유한성 때문에 멈춘다
	normalize_selector()
	print_err("TeX capacity exceeded, sorry [")
@.TeX capacity exceeded ...@>
	print(s)
	print_char('=')
	print_int(n)
	print_char(']')
	help2("If you really absolutely need more capacity,",
		"you can ask a wizard to enlarge me.")
	succumb()
}

@ 프로그램이 언젠가 완전히 미쳐 날뛸 수도 있는데, 그때는 멈추는 수밖에 없다. 그 전에 아무
오류도 발견되지 않았다면 그것은 나쁜 소식이다. 그래서 사용자보다는 \TeX\ 관리자를 위한
메시지를 찍는다(사용자가 유달리 악랄하지 않았다면 말이다). 찾아보기의 `this can't happen'
항목들이 문제를 정확히 짚어 내는 데 도움이 될 것이다.
@^dry rot@>

보충: 첫 도움말 줄의 ``can fix can fix''는 오타가 아니라 저자의 장난이다. 원본에도 그렇게
되어 있다.

@<오류 처리...@>=
func confusion(s string) { // 일관성 검사가 어긋났다; |s|가 그곳을 알려 준다
	normalize_selector()
	if history < error_message_issued {
		print_err("This can't happen (")
		print(s)
		print_char(')')
@.This can't happen@>
		help1("I'm broken. Please show this to someone who can fix can fix")
	} else {
		print_err("I can't go on meeting you like this")
@.I can't go on...@>
		help2("One of your faux pas seems to have wounded me deeply...",
			"in fact, I'm barely conscious. Please fix it and try again.")
	}
	succumb()
}

@ 사용자는 이따금 \TeX이 돌아가는 동안 끼어들고 싶어 한다. \PASCAL\ 실행 시스템이 이것을
허용한다면, 그런 끼어들기 신호가 오면 전역 변수 |interrupt|를 0이 아닌 값으로 놓는 루틴을 구현할
수 있다. 그렇지 않더라도 아마 적어도 \PASCAL\ 디버거를 써서 |interrupt|를 0이 아니게 할 방법은
있을 것이다.
@^system dependencies@>
@^debugging@>

보충: \GO/에서는 |os/signal| 꾸러미로 끼어들기 신호를 받을 수 있다. 옮긴이는 주 프로그램이
신호를 받으면 |interrupt|를 1로 놓게 했다(바로 다음의 덧붙인 절).

@<전역 변수@>=
func check_interrupt() {
	if interrupt != 0 {
		pause_for_instructions()
	}
}

var @!interrupt int32 // \TeX이 멈추고 지시를 기다려야 하나?
var @!OK_to_interrupt bool // 끼어들기를 받아들여야 하나?
var @!interrupt_signal = make(chan os.Signal, 1) // 끼어들기 신호가 들어오는 통로

@ @<핵심 변수들의...@>=
interrupt = 0
OK_to_interrupt = true

@ \dg 주 프로그램은 시작하자마자 다음 일을 해 둔다(\os{1332}). 사용자가 끼어들기 신호(대개
\.{Ctrl-C})를 보내면 따로 도는 고루틴이 그것을 받아서 |interrupt|를 1로 놓는다. 이것은 원본이
가정하는 ``끼어들기 신호가 오면 |interrupt|를 0이 아닌 값으로 놓는 루틴''에 해당한다. \TeX은
|check_interrupt|를 부를 때에만 이 변수를 살피므로, 신호는 그때 처리된다.

@<끼어들기 신호를 받으면 |interrupt|를 놓게 한다@>=
signal.Notify(interrupt_signal, os.Interrupt)
go func() {
	for range interrupt_signal {
		interrupt = 1
	}
}()

@ 끼어들기가 발견되면 프로그램은 가장 높은 대화 수준에 들어가서, 사용자가 |error| 루틴의 거의
모든 유연성을 누리게 한다. \TeX은 그렇게 해도 안전한 때에만 끼어들기를 검사한다.

@<함수들@>=
func pause_for_instructions() {
	if OK_to_interrupt {
		interaction = error_stop_mode
		if selector == log_only || selector == no_print {
			selector++
		}
		print_err("Interruption")
@.Interruption@>
		help3("You rang?",
			"Try to insert an instruction for me (e.g., `I\\showlists'),",
			"unless you just want to quit by typing `X'.")
		deletions_allowed = false
		error()
		deletions_allowed = true
		interrupt = 0
	}
}

@* 눈금 단위 치수의 산술.
\TeX이 하는 주된 계산은 절댓값이 $2^{31}$보다 작은 정수만으로 이루어지고, 나눗셈은 피제수와
제수가 모두 음이 아닐 때에만 한다. 그래서 이 프로그램에 지정된 산술은 몇몇 작은 컴퓨터를
포함한 매우 다양한 컴퓨터에서 정확히 같은 방식으로 수행될 수 있다. 왜 그래야 할까? 서로 다른
기계에서 \TeX이 같은 출력을 낸다고 보장하려면 산술 계산을 정확하게 밝혀 두어야 하기 때문이다.
어떤 양이 구현마다 다르게 반올림된다면 줄 나눔, 심지어 쪽 나눔이 서로 다른 곳에서 일어날 수도
있다. 그래서 \TeX의 산술은 조심스럽게 설계되었고, \TeX82의 구현이라고 자처하는 시스템은
@^TeX82@>
지금의 프로그램에 나타난 계산을 정확히 따라야 한다.

(실은 \TeX이 음일 수도 있는 피제수로 |div|를 쓰는 곳이 세 군데 있다. 이것들은 해가 없다.
찾아보기의 |div|를 보라. 또 사용자가 \.{\\time}이나 \.{\\year}를 음수로 정하면, 어떤 진단
정보에 음의 피제수 나눗셈이 들어간다. 연산 |div|뿐 아니라 |mod|에 대해서도 같은 이야기가 들어맞는다.)

보충: \PASCAL의 |div|와 |mod|는 \GO/의 |/|와 |%|가 된다. \GO/의 정수 나눗셈은 0 쪽으로
자르고 나머지의 부호는 피제수를 따르는데, 이것은 거의 모든 \PASCAL\ 구현과 같다. 피제수와
제수가 음이 아니면 어차피 차이가 없다.

@ 다음은 홀수인 부호 있는 정수에 대해 모호하지 않은 관례를 써서 정수의 절반을 계산하는
루틴이다.

@<함수들@>=
func half(x int32) int32 {
	if odd(x) {
		return (x + 1) / 2
	} else {
		return x @!/ 2
	}
}

@ 고정 소수점 산술은 $2^{-16}$의 배수인 {\sl 눈금 정수\/}(scaled integer)로 한다. 다시 말하면
이진 소수점이 이진 컴퓨터 낱말의 오른쪽 끝에서 열여섯 비트 위치에 있다고 가정한다.

@<바깥 블록의 형@>=
const (
	unity = 0o200000 // $2^{16}$, 1.00000을 나타낸다
	two = 0o400000 // $2^{17}$, 2.00000을 나타낸다
)

type @!scaled = int32 // 이 형은 눈금 정수에 쓴다
type @!nonnegative_integer = int32 // $0\L x<2^{31}$
type @!small_number = int32 // 이 형은 이름이 다 말해 준다; |0..63|

@ 다음 함수는 주어진 십진 소수 $(.d_0d_1\ldots d_{k-1})$로부터 눈금 정수를 만드는 데 쓴다.
여기서 |0<=k<=17|이다. 숫자 $d_i$는 |dig[i]|에 주어지고, 계산은 올바르게 반올림한 결과를 낸다.

@<함수들@>=
func round_decimals(k small_number) scaled { // 십진 소수를 바꾼다
	var a int32 // 누산기
	a = 0
	for k > 0 {
		k--
		a = (a + dig[k]*two) / 10
	}
	return (a + 1) / 2
}

@ 거꾸로, 다음은 |print_int|와 비슷한 프로시저다. 이 프로시저의 출력을 나중에 \TeX이 읽어서
위의 |round_decimals| 루틴으로 바꾸면 원래의 값이 정확히 다시 만들어진다. 그런 십진수 가운데
``가장 간단한'' 것을 출력하는데, 소수점 뒤에는 언제나 숫자가 적어도 하나 온다.

\KW{repeat} 루프의 불변 관계는, 앞으로 찍을 십진 숫자들의 나열이 범위
$s-\delta\L10\cdot2^{16}f<s$에 있는 분수~$f$를 이룰 때, 그리고 오직 그때에만 원래의 수를
내놓는다는 것이다. 값 $f=0$이 이 조건을 만족할 때, 그리고 오직 그때에만 멈출 수 있다. 루프는 $s$가
0이 될 수 있기 전에 끝난다.

@<함수들@>=
func print_scaled(s scaled) { // 다섯 자리로 반올림한 눈금 실수를 찍는다
	var delta scaled // 허용되는 부정확함의 양
	if s < 0 {
		print_char('-')
		s = -s // 음수면 부호를 찍는다
	}
	print_int(s / unity) // 정수 부분을 찍는다
	print_char('.')
	s = 10*(s%unity) + 5
	delta = 10
	for {
		if delta > unity {
			s = s + 0o100000 - 50000 // 마지막 숫자를 반올림한다
		}
		print_char('0' + (s / unity))
		s = 10 * (s % unity)
		delta = delta * 10
		if s <= delta {
			break
		}
	}
}

@ \TeX\ 사용자가 문서의 부분들에 지정하는 물리적 크기는 내부에서 눈금 포인트로 나타낸다.
그러니까 `sp'(scaled point, 눈금 포인트)를 인쇄업자의 포인트의 $2^{-16}$에 해당하는 단위로
@^sp@>
정의하면, \TeX\ 안의 모든 치수는 sp의 정수 배다. 1인치는 정확히 4,736,286.72\,sp다. 사용자는
$2^{30}-1$\,sp보다 큰 치수를 지정할 수 없다. 그것은 약 18.892피트(5.7583미터)의 거리다. 그런 양
둘은 32비트 컴퓨터에서 넘침 없이 더할 수 있다.

지금의 \TeX\ 구현은 치수를 더하거나 뺄 때 넘침을 검사하지 않는다. 이것은 `\ignorespaces|if
@^overflow in arithmetic@>
x>=@'10000000000 then @t\ID{report\_overflow}@>|' 꼴의 검사를 수십 개 넣으면 할 수 있겠지만,
넘침의 가능성은 너무나 희박해서 그런 검사는 할 만한 가치가 없어 보인다.

\TeX은 눈금 양에 대해 덧셈과 뺄셈 말고는 몇 가지 산술 연산만 하면 되고, 다음 서브루틴들이 그
일의 대부분을 한다. 계산 하나가 서브루틴을 여러 번 부를 수도 있는데, 산술 넘침이 일어났을 때
오류 메시지를 여러 번 내지 않는 것이 바람직하다. 그래서 루틴들은 사용자에게 오류를 바로 알리는
대신 전역 변수 |arith_error|를 |true|로 놓는다. 또 하나의 전역 변수 |remainder|는 나눗셈한
뒤의 나머지를 담는다.

@<전역 변수@>=
var @!arith_error bool // 최근에 산술 넘침이 일어났나?
var @!remainder scaled // 정확한 나눗셈을 얻으려고 뺀 양

@ 첫째로 필요한 산술 서브루틴은 $nx+y$를 계산한다. 여기서 |x|와~|y|는 |scaled|이고 |n|은
정수다. 이것은 정수를 곱하는 데도 쓸 것이다.

@<함수들@>=
func nx_plus_y(n int32, x, y scaled) scaled { return mult_and_add(n, x, y, 0o7777777777) }
func mult_integers(n int32, x scaled) scaled { return mult_and_add(n, x, 0, 0o17777777777) }

func mult_and_add(n int32, x, y, max_answer scaled) scaled {
	if n < 0 {
		x = -x
		n = -n
	}
	if n == 0 {
		return y
	} else if x <= (max_answer-y)/n && -x <= (max_answer+y)/n {
		return n*x + y
	} else {
		arith_error = true
		return 0
	}
}

@ 눈금 치수를 정수로 나누는 것도 필요하다.

@<함수들@>=
func x_over_n(x scaled, n int32) (x_over_n scaled) {
	var negative bool // |remainder|의 부호를 바꾸어야 하나?
	negative = false
	if n == 0 {
		arith_error = true
		x_over_n = 0
		remainder = x
	} else {
		if n < 0 {
			x = -x
			n = -n
			negative = true
		}
		if x >= 0 {
			x_over_n = x / n
			remainder = x % n
		} else {
			x_over_n = -((-x) / n)
			remainder = -((-x) % n)
		}
	}
	if negative {
		remainder = -remainder
	}
	return
}

@ 다음은 눈금 수에 분수 |n/d|를 곱하는 것이다. 여기서 |n|과 |d|는 |<=@t$2^{16}$@>|인 음이
아닌 정수이고, |d|는 양수다. 먼저 |n|을 곱하고 그다음 |d|로 나누면 넘침이 일어나기 쉬워서 너무
위험하고, 먼저 |d|로 나누고 그다음 |n|을 곱하면 너무 부정확하다. 그래서 이 서브루틴은
1.5배 정밀도 산술을 흉내 낸다.

보충: 앞 절과 이 절에서는 함수의 결과 변수에 함수와 같은 이름(이를테면 |xn_over_d|)을 붙였다.
\PASCAL에서 함수의 값은 함수 이름에 대입해서 정하는데, \GO/에서도 결과 변수에 이름을 붙이면
그 이름에 대입하고 빈 |return|으로 끝낼 수 있으므로 원본의 코드를 거의 그대로 옮길 수 있다.

@<함수들@>=
func xn_over_d(x scaled, n, d int32) (xn_over_d scaled) {
	var positive bool // |x>=0|이었나?
	var t, u, v nonnegative_integer // 중간 양들
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
		arith_error = true
	} else {
		u = 0o100000*(u/d) + (v / d)
	}
	if positive {
		xn_over_d = u
		remainder = v % d
	} else {
		xn_over_d = -u
		remainder = -(v % d)
	}
	return
}

@ 다음 서브루틴은 글루의 ``나쁨''(badness)을 계산하는 데 쓴다. 합이~|s|인 양들로 전체~|t|를
만들어야 하는 경우다. {\sl The \TeX book}에 따르면 이 상황의 나쁨은 $100(t/s)^3$이다. 그러나
@^TeXbook@>
나쁨은 그저 어림법일 뿐이므로, 그것을 계산할 때 정확도를 마지막 한 방울까지 짜낼 필요는 없다.
우리가 정말로 바라는 것은 비슷한 성질을 지닌 근삿값이다.

나쁨을 계산하는 실제 방법은 말로 설명하는 것보다 프로그램에서 읽는 편이 쉽다. 그것은
$100(t/s)^3$에 꽤 가까운 근삿값인 정수를 내놓으며, \TeX의 모든 구현은 바로 이 방법을 써야 한다.
나쁨이 $2^{13}$ 이상이면 무한히 나쁜 것으로 보고 10000으로 나타낸다.

$$\hbox{|badness(t+1,s)>=badness(t,s)>=badness(t,s+1)|}$$임을 증명하기는 어렵지 않다. 여기서
정의한 나쁨 함수는 서로 다른 값을 많아야 1095개 계산할 수 있지만, 그것으로 충분하다.

보충: 근사의 뜻을 풀어 보자. 원하는 값은 $100(t/s)^3$인데, $297^3=26198073\approx
99.94\times2^{18}$이므로 $r=297t/s$로 두면 $r^3/2^{18}\approx100(t/s)^3$이다. 마지막 줄의
$(r^3+2^{17})/2^{18}$은 $r^3/2^{18}$을 가장 가까운 정수로 반올림한 것이다. 곱 |t*297|이 넘치지
않도록 $t\le7230584$일 때에만 먼저 곱하고, 그렇지 않으면 $s$를 먼저 297로 나눈다. 다만 $s<1663497$이면
그냥 $r=t$로 두어 결과가 |inf_bad|가 되게 한다. 이때 $t/s>4.34$이므로 참값도 이미 8200을 넘는다.
정확도를 조금 버리고 계산을 단순하게 한 것이다.

@<함수들@>=
const inf_bad = 10000 // 무한히 나쁜 값

func badness(t, s scaled) halfword { // |t>=0|일 때 나쁨을 계산한다
	var r int32 // $\alpha t/s$의 근삿값, 여기서 $\alpha^3\approx100\cdot2^{18}$
	if t == 0 {
		return 0
	} else if s <= 0 {
		return inf_bad
	} else {
		if t <= 7230584 {
			r = (t * 297) / s // $297^3=99.94\times2^{18}$
		} else if s >= 1663497 {
			r = t / (s / 297)
		} else {
			r = t
		}
		if r > 1290 {
			return inf_bad // $1290^3<2^{31}<1291^3$
		} else {
			return (r*r*r + 0o400000) / 0o1000000
		} // 이것은 $r^3/2^{18}$을 가장 가까운 정수로 반올림한 것이다
	}
}

@ \TeX이 목록을 상자로 ``꾸릴'' 때는 상자 안의 글루가 늘어나거나 줄어들어야 할 비례 비율을
계산해야 한다. 이 계산은 \TeX의 판단에 영향을 주지 않으므로, 글루 계산의 반올림 같은
세부는 서로 다른 컴퓨터에서 결과가 일관되는 데 결정적이지 않다.

이런 비례 비율에는 형 |glue_ratio|를 쓴다. 글루 비율이 \TeX의 다른 자료 구조와 매끄럽게
어울리려면 |integer|와 같은 크기의 메모리(대개 32비트)를 차지해야 한다. 그러므로 어떤
\PASCAL\ 구현에서는 |glue_ratio|가 |short_real|과 같아야 한다. 아니면 고정 소수점 산술만으로
글루 비율을 다룰 수도 있다. {\sl TUGboat \bf3},1 (1982년 3월), 10--27쪽을 보라. (그러나 거기
인용된 루틴들은 음의 글루 비율을 허용하도록 고쳐야 한다.)
@^system dependencies@>

보충: 이 번역에서 |glue_ratio|는 \GO/의 |float64|다. 원본의 매크로들은 다음과 같다.
매크로 |set_glue_ratio_zero(#)|와 |set_glue_ratio_one(#)|는 |#|에 0.0과 1.0을 넣는데, 이것들은 늘
|glue_set(p)| 같은 필드에 쓰이므로 \GO/에서는 해당 필드의 쓰기 함수 호출, 이를테면
|set_glue_set(p,0.0)|이 된다. 매크로 |float(#)|와 |unfloat(#)|는 |glue_ratio|와 |real| 사이의 변환인데
\GO/에서는 둘 다 |float64|이므로 아무 일도 하지 않는다. 매크로 |float_constant(#)|는 정수 상수를 실수로
바꾼다.

@<바깥 블록의 형@>=
type @!glue_ratio = float64 // 글루 늘이기 비율의 한 낱말짜리 표현

func float(x glue_ratio) float64 { return x } // |glue_ratio|를 |real| 형으로 바꾼다
func unfloat(x float64) glue_ratio { return x } // |real|을 |glue_ratio| 형으로 바꾼다
func float_constant(n int32) float64 { return float64(n) } // |integer| 상수를 |real|로 바꾼다

@* 꾸린 자료.
메모리를 효율적으로 쓰려고, \TeX은 주요 자료 구조의 바탕을 |memory_word|에 둔다.
낱말 |memory_word|에는 (부호 있는) 정수(눈금 정수일 수도 있다)나 (부호 있는) |glue_ratio|가
들어가거나, 정수를 저장하는 데 쓰는 크기의 절반이나 4분의 1인 필드가 몇 개 들어간다.

변수 |x|의 형이 |memory_word|라면, |x|에는 다음과 같이 가리킬 수 있는 필드가 넷까지 들어 있다.
$$\vbox{\halign{\hfil#&#\hfil&#\hfil\cr
|x|&.|int|&(|integer| 하나)\cr
|x|&.|sc|\qquad&(|scaled| 정수 하나)\cr
|x|&.|gr|&(|glue_ratio| 하나)\cr
|x.hh.lh|, |x.hh|&.|rh|&(하프워드 필드 둘)\cr
|x.hh.b0|, |x.hh.b1|, |x.hh|&.|rh|&(쿼터워드 필드 둘, 하프워드 필드 하나)\cr
|x.qqqq.b0|, |x.qqqq.b1|, |x.qqqq|&.|b2|, |x.qqqq.b3|\hskip-100pt
  &\qquad\qquad\qquad(쿼터워드 필드 넷)\cr}}$$
이것은 쓰기에 좀 거추장스럽고 읽기에도 그리 좋지 않지만, 매크로를 써서 표기를 더 짧고 투명하게
할 것이다. 아래의 \PASCAL\ 코드는 꾸린 가변 레코드를 써서 |memory_word|와 그 하위 형들을
형식적으로 정의한다. \TeX은 낱말 안에서 필드들의 상대 위치에 대해 아무것도 가정하지 않는다.

정수를 32비트로 가정하고 있으므로 하프워드는 적어도 16비트, 쿼터워드는 적어도 8비트를 담아야
@^system dependencies@>
한다. 그러나 비트가 더 있어도 해롭지 않다. 이를테면 36비트 낱말이 넉넉하면 |mem_max|를
262142만큼 크게 할 수 있을지도 모르는데, 이것은 \TeX이 세상에 나온 첫 4년 동안 누구라도 가졌던
것보다 여덟 배나 많은 메모리다.

주의: \TeX을 |memory_word|의 모든 변형을 정수 하나의 공간에 꾸려 넣는 \PASCAL로 컴파일하지
않으면 귀중한 메모리가 끔찍하게 낭비된다. 이를테면 어떤 컴퓨터에서는 |glue_ratio| 낱말이
|real|이 아니라 |short_real|이어야 한다는 뜻이다. 어떤 \PASCAL\ 컴파일러는 부분 범위가
`|0..255|'인 정수를 8비트 필드에 꾸려 넣지만, 다른 것들은 부호 비트를 위한 공간을 더 할당하기를
고집한다. 그런 시스템에서는 부분 범위가 `|-128..127|'일 때에만 쿼터워드에 256가지 값을 넣을 수
있다.

지금의 구현은 될 수 있는 대로 많은 변형을 받아들이려 하므로 가정을 거의 하지 않는다. 부분
범위가 `|min_quarterword..max_quarterword|'인 정수를 쿼터워드에 꾸려 넣을 수 있고, 부분 범위가
`|min_halfword..max_halfword|'인 정수를 하프워드에 꾸려 넣을 수 있다면 모든 것이 만족스럽게
돌아갈 것이다.

대개는 |min_quarterword=min_halfword=0|으로 하는 것이 가장 효율적이므로, 심각한 문제를 일으키지
않는 한 그렇게 하도록 애써야 한다. 여기서 정의하는 값은 대부분의 32비트 컴퓨터에 권하는 값이다.

@<정의@>=
const (
	@!min_quarterword = 0 // |quarterword|에 허용되는 가장 작은 값
	@!max_quarterword = 255 // |quarterword|에 허용되는 가장 큰 값
	@!min_halfword = 0 // |halfword|에 허용되는 가장 작은 값
	@!max_halfword = 65535 // |halfword|에 허용되는 가장 큰 값
)

@ 쿼터워드와 하프워드의 값이 만족해야 하는 부등식들(정확히는 만족하면 안 되는 부등식들)은 다음과
같다.

@<``상수'' 값들이...@>=
if ini_version {
	if mem_min != mem_bot || mem_max != mem_top {
		bad = 10
	}
}
if mem_min > mem_bot || mem_max < mem_top {
	bad = 10
}
if min_quarterword > 0 || max_quarterword < 127 {
	bad = 11
}
if min_halfword > 0 || max_halfword < 32767 {
	bad = 12
}
if min_quarterword < min_halfword ||
	max_quarterword > max_halfword {
	bad = 13
}
if mem_min < min_halfword || mem_max >= max_halfword ||
	mem_bot-mem_min > max_halfword+1 {
	bad = 14
}
if font_base < min_quarterword || font_max > max_quarterword {
	bad = 15
}
if font_max > font_base+256 {
	bad = 16
}
if save_size > max_halfword || max_strings > max_halfword {
	bad = 17
}
if buf_size > max_halfword {
	bad = 18
}
if max_quarterword-min_quarterword < 255 {
	bad = 19
}

@ 값 |min_quarterword|를 더하거나 빼는 연산은 \TeX에서 꽤 자주 일어나므로, 쿼터워드 꼴로 넣고
꺼내는 이 연산을 매크로 |qi|와 |qo|로 줄여 쓰면 편리하다.

컴파일러가 `|x+0|'과 `|x-0|' 같은 식을 최적화하지 않는다면, |min_quarterword=0|일 때 이
매크로들을 뻔한 방식으로 단순하게 해 두어야 \TeX의 안쪽 루프가 더 빨리 돈다.
@^inner loop@>@^system dependencies@>

@<정의@>=
func qi(x int32) quarterword { return x + min_quarterword } // |eight_bits| 항목을 쿼터워드에 넣는다
func qo(x quarterword) int32 { return x - min_quarterword } // |eight_bits| 항목을 쿼터워드에서 꺼낸다
func hi(x int32) halfword { return x + min_halfword } // 16비트 항목을 하프워드에 넣는다
func ho(x halfword) int32 { return x - min_halfword } // 16비트 항목을 하프워드에서 꺼낸다

@ 독자는 다음 정의를 꼼꼼히 공부해야 한다.
@^system dependencies@>

보충: 원본은 매크로 |sc==int|로 |scaled| 자료가 |integer|와 같은 필드임을 밝힌다. 그러므로
\PASCAL의 |x.int|와 |x.sc|는 같은 필드다. 옮긴이는 이 필드를 \GO/에서 |sc| 하나로 썼다.
\GO/에서 |int|는 형의 이름이라 필드 이름으로 쓰면 헷갈리기 때문이다. 원본의 |x.int|는 모두
|x.sc|가 된다.

\GO/에는 가변 레코드(C의 공용체)가 없으므로 |memory_word|는 모든 변형을 따로 담는 구조체다.
원본이 ``\TeX은 낱말 안에서 필드들의 상대 위치에 대해 아무것도 가정하지 않는다''고 한 대로,
\TeX은 한 낱말에 어떤 변형으로 쓴 값을 다른 변형으로 읽는 일이 없으므로 이렇게 해도 동작은 같다.
다만 낱말 하나가 차지하는 메모리는 몇 배로 늘어난다. 하프워드 필드 |lh|와 쿼터워드 필드
|b0|, |b1|도 원본에서는 겹치지만 여기서는 따로 있다. 쿼터워드와 하프워드를 |int32|의 별칭으로
삼은 까닭은 \os{18}의 보충 설명과 같다. 원본의 형 |two_choices|와 |four_choices|는 가변
레코드의 꼬리표에만 쓰이므로 \GO/에서는 필요 없다.

이진 파일과 마찬가지로 낱말 파일에도 버퍼 변수 |f^|에 해당하는 필드 |buf|를 둔다.

@<바깥 블록의 형@>=
type @!quarterword = int32 // 낱말의 1/4; |min_quarterword..max_quarterword|
type @!halfword = int32 // 낱말의 1/2; |min_halfword..max_halfword|
type @!two_halves struct {
	@!rh halfword
	@!lh halfword // 원본에서는 이 필드와 다음 두 필드가 겹친다
	@!b0 quarterword
	@!b1 quarterword
}
type @!four_quarters struct {
	b0 quarterword
	b1 quarterword
	@!b2 quarterword
	@!b3 quarterword
}
type @!memory_word struct {
	@!sc int32 // 원본의 |int|와 |sc|
	@!gr glue_ratio
	@!hh two_halves
	@!qqqq four_quarters
}
type @!word_file struct {
	f      *os.File
	r      *bufio.Reader
	w      *bufio.Writer
	buf    memory_word // \PASCAL의 버퍼 변수 |f^|
	at_eof bool        // \PASCAL의 |eof(f)|
}

@ 디버깅할 때에는 |memory_word|가 어떤 형인지 모르고 찍고 싶을 수도 있다. 그래서 모든 방식으로
찍는다.
@^dirty \PASCAL@>@^debugging@>

보충: 원본은 이 프로시저를 디버깅할 때에만 컴파일한다. \GO/에서는 언제나 컴파일되지만, 디버깅
코드에서만 불린다.

@<함수들@>=
func print_word(w memory_word) { // |w|를 모든 방식으로 찍는다
	print_int(w.sc)
	print_char(' ')
	print_scaled(w.sc)
	print_char(' ')
	print_scaled(round(unity * float(w.gr)))
	print_ln()
@^real multiplication@>
	print_int(w.hh.lh)
	print_char('=')
	print_int(w.hh.b0)
	print_char(':')
	print_int(w.hh.b1)
	print_char(';')
	print_int(w.hh.rh)
	print_char(' ')
	print_int(w.qqqq.b0)
	print_char(':')
	print_int(w.qqqq.b1)
	print_char(':')
	print_int(w.qqqq.b2)
	print_char(':')
	print_int(w.qqqq.b3)
}

@* 동적 메모리 할당.
\TeX\ 시스템은 메모리 할당을 거의 다 스스로 한다. 그래서 문자열이나 쓰레기 수집 따위의
자동 기능이 없는 환경으로도 쉽게 옮겨 갈 수 있고, 사용자가 받는 오류 메시지를 스스로 통제할 수
있다. \TeX의 동적 저장 요구는 큰 배열 |mem|을 마련해서 처리하는데, \TeX\ 루틴들은 그 안의 잇닿은
낱말 덩어리들을 노드로 쓴다.

포인터 변수는 이 배열의 첨자이거나, 나중에 설명할 |eqtb|라는 다른 배열의 첨자이다. 포인터
변수는 |mem|의 경계 바깥에 있는 특별한 표시일 수도 있으므로, 포인터는 어떤 |halfword| 값이든 가질
수 있게 한다. 가장 작은 하프워드 값은 널 포인터를 나타낸다. \TeX은 |mem[null]|이 있다고 가정하지
않는다.

@<전역 변수@>=
type @!pointer = halfword // 표시이거나 |mem|이나 |eqtb|의 위치

const @!null = min_halfword // 널 포인터

var @!temp_ptr pointer // 이따금 급할 때 쓰는 포인터 변수

@ 배열 |mem|은 따로 할당되는 두 영역으로 나뉘지만, 두 영역의 경계선은 고정되어 있지 않다. 두
영역은 함께 자라다가 각 작업에서 저마다 ``자연스러운'' 크기를 찾는다. 위치 |lo_mem_max| 이하에는
낱말이 둘 이상인 가변 길이 레코드를 저장한다. 이 영역은 {\sl The Art of Computer Programming}의
연습 문제 2.5--19에 설명된 것과 비슷한 알고리즘으로 관리한다. 그러나 할당된 노드에는 크기 필드가
없다. 노드를 해제할 때 그 크기를 아는 것은 프로그램의 책임이다. 위치 |hi_mem_min| 이상에는 한
낱말짜리 레코드를 저장한다. 이 영역의 할당에는 관례적인 \.{AVAIL} 스택을 쓴다.

배열 |mem|에서 |mem_bot|부터 |mem_top|까지의 위치는 \.{INITEX} 전처리기가 미리 싣는 포맷 파일의 일부로
@.INITEX@>
내보낼 수 있다. 실무용 \TeX은 더 많은 공간을 마련하려고 메모리를 양쪽 끝으로 늘릴 수 있다.
아래쪽 끝의 |mem_min|과 |mem_bot| 사이 위치는 언제나 가변 크기 노드에 쓰이고, 위쪽 끝의 |mem_top|과
|mem_max| 사이 위치는 언제나 한 낱말짜리 노드에 쓰인다.

배열 |mem|의 할당을 다스리는 핵심 포인터들 사이에는 정해진 순서가 있다.
$$\advance\thickmuskip-2mu
\hbox{|null<=mem_min<=mem_bot<lo_mem_max<
  hi_mem_min<mem_top<=mem_end<=mem_max|.}$$

실험해 보니 지금의 \TeX\ 구현은 실행 시간의 약 9\pct!를 노드 할당에, 약 6\pct!를 쓰고 난
노드의 해제에 쓰는 경향이 있다.

보충: 이것이 \TeX의 메모리 관리 알고리즘의 전부다. 크기가 제각각인 노드(상자, 글루 명세
따위)는 아래쪽 영역에서 첫맞춤(first fit) 방식으로 얻고, 한 낱말짜리 노드(문자, 토큰 따위)는
위쪽 영역의 스택에서 얻는다. 두 영역이 마주 보고 자라므로 어느 한쪽의 크기를 미리 정할 필요가
없다.

보충: 원본의 배열 |mem|은 첨자 범위가 |mem_min..mem_max|다. 위의 부등식에서 |null<=mem_min|이고 |null=min_halfword=0|이므로,
이 번역에서는 첨자를 0부터 |mem_max|까지 잡아서 원본의 첨자를 그대로 쓴다. 첨자가 |mem_min|보다 작은 낱말은 쓰지 않는다.

@<전역 변수@>=
var @!mem [mem_max + 1]memory_word // 큰 동적 저장 영역
var @!lo_mem_max pointer // 쓰고 있는 가변 크기 메모리의 가장 큰 위치
var @!hi_mem_min pointer // 쓰고 있는 한 낱말짜리 메모리의 가장 작은 위치

@ 특정 응용의 메모리 요구를 연구하려고, 현재의 메모리 사용량과 최대 사용량을 추적하는
판의 \TeX을 마련할 수도 있다. 구분 기호 |@!stat| $\ldots$ |tats| 사이의 코드가 ``주석 처리''되지
않으면 \TeX은 조금 느려지지만, |tracing_stats|가 충분히 클 때 이 통계를 알려 준다.

@<전역 변수@>=
var @!var_used, @!dyn_used int32 // 메모리를 얼마나 쓰고 있나

@ 먼저 한 낱말짜리 메모리 영역을 살펴보자. 가장 간단하기 때문이다. 포인터 변수 |mem_end|는
지금까지 쓰인 적이 있는 |mem|의 가장 큰 번호의 위치를 담는다. 위치 |hi_mem_min|과 |mem_end| 사이(양
끝 포함)의 빈 위치들은 형이 |two_halves|이고, |mem[p]|가 이 형일 때 그 |lh| 필드와 |rh| 필드를
|info(p)|와 |link(p)|라고 쓴다. 한 낱말짜리 빈 위치들은 |null|로 끝나는 연결 목록
$$|avail|,\;\hbox{|link(avail)|},\;\hbox{|link(link(avail))|},\;\ldots$$
을 이룬다.

보충: 원본에서 |link(p)|와 |info(p)|는 |mem[p].hh.rh|와 |mem[p].hh.lh|를 가리키는 매크로여서
대입문의 왼쪽에도 올 수 있다. \GO/에서는 읽는 함수 |link(p)|와 쓰는 함수 |set_link(p,q)|로
나뉜다(\os3). 앞으로 나오는 모든 필드 매크로가 이와 같다.

@<전역 변수@>=
func link(p pointer) halfword       { return mem[p].hh.rh } // 메모리 낱말의 |link| 필드
func set_link(p pointer, v halfword) { mem[p].hh.rh = v }
func info(p pointer) halfword       { return mem[p].hh.lh } // 메모리 낱말의 |info| 필드
func set_info(p pointer, v halfword) { mem[p].hh.lh = v }

var @!avail pointer // 쓸 수 있는 한 낱말짜리 노드 목록의 머리
var @!mem_end pointer // |mem|에서 쓰인 마지막 한 낱말짜리 노드

@ 메모리가 바닥났다면 사용자가 오른쪽 중괄호를 잊어버렸다는 뜻일지도 모른다. 나중에 우리는
문제를 정확히 짚어 내는 데 도움을 주려는 프로시저들을 정의할 것이다.

@<함수들@>=
@<|show_token_list|라는 프로시저를 선언한다@>
@<|runaway|라는 프로시저를 선언한다@>

@ 함수 |get_avail|은 |link| 필드가 널인 새 한 낱말짜리 노드를 가리키는 포인터를 돌려준다.
그러나 남은 자리가 없으면 \TeX은 멈춘다.
@^inner loop@>

쓸 수 있는 공간의 목록이 비어 있으면, 곧 |avail=null|이면, 먼저 |mem_end|를 늘려 본다. 그렇게 할
수 없으면, 곧 |mem_end=mem_max|면, |hi_mem_min|을 줄여 본다. 그것도 할 수 없으면, 곧
|hi_mem_min=lo_mem_max+1|이면, 그만두어야 한다.

@<함수들@>=
func get_avail() pointer { // 한 낱말짜리 노드 할당
	var p pointer // 얻는 새 노드
	p = avail // |avail| 스택의 맨 위 위치를 얻는다
	if p != null {
		avail = link(avail) // 그리고 그것을 꺼낸다
	} else if mem_end < mem_max { // 아니면 처녀지로 들어간다
		mem_end++
		p = mem_end
	} else {
		hi_mem_min--
		p = hi_mem_min
		if hi_mem_min <= lo_mem_max {
			runaway() // 메모리가 바닥나면 폭주했을지 모르는 텍스트를 보인다
			overflow("main memory size", mem_max+1-mem_min)
			// 그만둔다; 한 낱말짜리 노드가 모두 쓰이고 있다
@:TeX capacity exceeded main memory size}{\quad main memory size@>
		}
	}
	set_link(p, null) // 새 노드에 흔히 원하는 초기화를 해 준다
	if stat {
		dyn_used++ // 통계를 유지한다
	}
	return p
}

@ 거꾸로, 한 낱말짜리 노드는 |free_avail|을 불러 재활용한다. 이 루틴은 \TeX의 ``안쪽 루프''의
일부이므로 빨라야 한다.
@^inner loop@>

@<정의@>=
func free_avail(p pointer) { // 한 낱말짜리 노드의 해방
	set_link(p, avail)
	avail = p
	if stat {
		dyn_used--
	}
}

@ 프로시저 호출의 부담을 아끼는 대신 프로그램을 더 써야 하는 |fast_get_avail| 루틴도 있다. 이
루틴은 |get_avail|을 가장 자주 부르게 될 곳들에서 그 대신 쓴다.
@^inner loop@>

보충: 원본의 |fast_get_avail(#)|은 인자 |#|에 새 노드를 넣는 매크로다. \GO/에서는 새 노드를
돌려주는 함수이므로 |fast_get_avail(p)|는 |p=fast_get_avail()|이 된다. \GO/ 컴파일러가 이 작은
함수를 펼쳐 넣으므로, 프로시저 호출의 부담을 아낀다는 원래의 목적도 대체로 이루어진다.

@<정의@>=
func fast_get_avail() (p pointer) {
	p = avail // 될 수 있으면 시간을 아끼려고 |get_avail|을 피한다
	if p == null {
		p = get_avail()
	} else {
		avail = link(p)
		set_link(p, null)
		if stat {
			dyn_used++
		}
	}
	return
}

@ 프로시저 |flush_list(p)|는 위치 |p|에서 시작하는 한 낱말짜리 노드들의 연결 목록 전체를
해제한다.
@^inner loop@>

@<함수들@>=
func flush_list(p pointer) { // 한 낱말짜리 노드들의 목록을 쓸 수 있게 한다
	var q, r pointer // 목록을 훑는 것들
	if p != null {
		r = p
		for {
			q = r
			r = link(r)
			if stat {
				dyn_used--
			}
			if r == null {
				break
			}
		} // 이제 |q|는 목록의 마지막 노드다
		set_link(q, avail)
		avail = p
	}
}

@ 배열 |mem|의 가변 크기 부분에서 쓸 수 있는 공간의 목록은 빈 노드들로 이루어진, 비어 있지 않은
이중 연결 순환 목록이다. 떠도는 포인터 |rover|가 이 목록을 가리킨다.

빈 노드는 저마다 크기가 2 이상이다. 첫 낱말의 |link| 필드에는 특별한 값 |max_halfword|가, |info|
필드에는 크기가 들어 있다. 둘째 낱말에는 이중 연결을 위한 포인터 둘이 들어 있다.

비어 있지 않은 노드도 저마다 크기가 2 이상이다. 그 첫 낱말은 형이 |two_halves|\kern-1pt이고,
그 |link| 필드는 결코 |max_halfword|와 같지 않다. 그 밖에는 다른 필드와 다른 낱말들의 내용에 대해
완전한 자유가 있다.

(조건 |mem_max<max_halfword|를 요구하는 것은 비어 있지 않은 노드의 |link| 필드에 |max_halfword|가
나타나면 끔찍한 일이 일어날 수 있기 때문이다.)

@<정의@>=
const @!empty_flag = max_halfword // 빈 가변 크기 노드의 |link|

func is_empty(p pointer) bool { return link(p) == empty_flag } // 빈 노드인지 검사한다
func node_size(p pointer) halfword { return info(p) } // 빈 가변 크기 노드의 크기 필드
func set_node_size(p pointer, v halfword) { set_info(p, v) }
func llink(p pointer) halfword { return info(p + 1) } // 빈 노드들의 이중 연결 목록에서 왼쪽 연결
func set_llink(p pointer, v halfword) { set_info(p+1, v) }
func rlink(p pointer) halfword { return link(p + 1) } // 빈 노드들의 이중 연결 목록에서 오른쪽 연결
func set_rlink(p pointer, v halfword) { set_link(p+1, v) }

@ \dg 앞 절의 전역 변수를 옮긴다.

@<전역 변수@>=
var @!rover pointer // 빈 노드 목록의 어떤 노드를 가리킨다

@ 함수 |get_node|를 인자 |s|로 부르면 크기가~|s|인 새 노드를 가리키는 포인터를 돌려준다. 크기 |s|는
2~이상이어야 한다. 이 새 노드의 첫 낱말의 |link| 필드는 널로 놓는다. 알맞은 공간이 없으면 넘침으로 멈춘다.

함수 |get_node|를 $s=2^{30}$으로 부르면 그저 이웃한 빈 영역들을 합치고 값 |max_halfword|를 돌려준다.

@<함수들@>=
func get_node(s int32) pointer { // 가변 크기 노드 할당
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
		return max_halfword
	}
	if lo_mem_max+2 < hi_mem_min {
		if lo_mem_max+2 <= mem_bot+max_halfword {
			@<가변 크기 메모리를 늘리고 |goto restart|@>
		}
	}
	overflow("main memory size", mem_max+1-mem_min)
	// 미안하지만 쓸 만한 것이 남아 있지 않다
@:TeX capacity exceeded main memory size}{\quad main memory size@>
found:
	set_link(r, null) // 이 노드는 이제 비어 있지 않다
	if stat {
		var_used = var_used + s // 사용 통계를 유지한다
	}
	return r
}

@ 메모리의 아래쪽 부분은 한 번에 1000낱말씩 자란다. 다만 바닥나기 직전이면 그보다 적게
자란다. 자랄 때는 새 노드 하나를 쓸 수 있는 공간의 목록에 이어 붙이기만 하면 된다. 이렇게 성장을
통제하는 방법은 \TeX을 ``가상 기억 장치'' 시스템에서 구현할 때 |mem| 사용이 잇닿아 있도록 하는 데
도움이 된다.
@^virtual memory@>

@<가변 크기 메모리를 늘리고 |goto restart|@>=
if hi_mem_min-lo_mem_max >= 1998 {
	t = lo_mem_max + 1000
} else {
	t = lo_mem_max + 1 + (hi_mem_min-lo_mem_max)/2
} // |lo_mem_max+2<=t<hi_mem_min|
p = llink(rover)
q = lo_mem_max
set_rlink(p, q)
set_llink(rover, q)
if t > mem_bot+max_halfword {
	t = mem_bot + max_halfword
}
set_rlink(q, rover)
set_llink(q, p)
set_link(q, empty_flag)
set_node_size(q, t-lo_mem_max)
lo_mem_max = t
set_link(lo_mem_max, null)
set_info(lo_mem_max, null)
rover = q
goto restart

@ 실험해 보니 이 절의 루틴은 할당 한 번에 평균 0.75번쯤 노드 합치기를 하고, 그 뒤 약
95\pct!의 경우에 |r>p+1|이다.

@<노드 |p|와 그 뒤의...@>=
q = p + node_size(p) // 물리적 후계자를 찾는다
@^inner loop@>
for is_empty(q) { // 노드 |p|와 노드 |q|를 합친다
	t = rlink(q)
	if q == rover {
		rover = t
	}
	set_llink(t, llink(q))
	set_rlink(llink(q), t)
	q = q + node_size(q)
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
set_node_size(p, q-p) // 크기가 커졌을 경우에 대비해 크기를 다시 놓는다

@ @<노드 |p|의 꼭대기에서...@>=
set_node_size(p, r-p) // 남은 크기를 저장한다
@^inner loop@>
rover = p // 다음에는 여기서 찾기 시작한다
goto found

@ 여기서는 노드 |p|를 루프에서 지우고 |rover|가 루프를 돌아다니게 한다.

@<노드 |p| 전체를...@>=
rover = rlink(p)
t = llink(p)
set_llink(rover, t)
set_rlink(t, rover)
goto found

@ 거꾸로, 어떤 가변 크기 노드 |p|가 더는 필요 없을 때 연산 |free_node(p,s)|는 그 낱말들을 쓸 수
있게 한다. 노드 |p|를 새 빈 노드로서 지금 |rover|가 가리키는 곳 바로 앞에 끼워 넣는 것이다.
@^inner loop@>

@<함수들@>=
func free_node(p pointer, s halfword) { // 가변 크기 노드의 해방
	var q pointer // |llink(rover)|
	set_node_size(p, s)
	set_link(p, empty_flag)
	q = llink(rover)
	set_llink(p, q)
	set_rlink(p, rover) // 두 연결을 다 놓는다
	set_llink(rover, p)
	set_rlink(q, p) // |p|를 루프에 끼워 넣는다
	if stat {
		var_used = var_used - s // 통계를 유지한다
	}
}

@ \.{INITEX}는 메모리를 써 내보내기 바로 전에 이중 연결된 쓸 수 있는 공간의 목록을 정렬한다.
그때 이 목록은 아마 아주 짧을 것이므로 간단한 삽입 정렬을 쓴다. 가장 작은 빈 위치는 |rover|가,
그다음으로 작은 것은 |rlink(rover)|가 가리키는 식이 된다.

@<함수들@>=
func sort_avail() { // 쓸 수 있는 가변 크기 노드들을 위치 순으로 정렬한다
	var p, q, r pointer // |mem|의 첨자들
	var old_rover pointer // |rover|의 처음 설정
	p = get_node(0o10000000000) // 이웃한 빈 영역들을 합친다
	p = rlink(rover)
	set_rlink(rover, max_halfword)
	old_rover = rover
	for p != old_rover {
		@<|p|를 |rover|의 목록에 정렬해 넣고 |p|를 나아가게 한다@>
	}
	p = rover
	for rlink(p) != max_halfword {
		set_llink(rlink(p), p)
		p = rlink(p)
	}
	set_rlink(p, rover)
	set_llink(rover, p)
}

@ 다음의 |while| 루프는 반드시 끝난다. 정렬하는 동안에는 |rover|에서 시작하는 목록이
|max_halfword|로 끝나기 때문이다.

@<|p|를 |rover|의 목록에...@>=
if p < rover {
	q = p
	p = rlink(q)
	set_rlink(q, rover)
	rover = q
} else {
	q = rover
	for rlink(q) < p {
		q = rlink(q)
	}
	r = rlink(p)
	set_rlink(p, rlink(q))
	set_rlink(q, p)
	p = r
}

@* 상자와 그 친구들의 자료 구조.
컴퓨터의 처지에서 보면 \TeX의 주된 임무는 가로 목록과 세로 목록을 만드는 것이다. 이제 이 목록들의
원소가 동적 메모리 안에서 노드로서 어떻게 표현되는지 살펴보자.

가로 목록이나 세로 목록은 각 노드의 첫 낱말에 있는 |link| 필드로 이어진다. 낱낱의 노드는 상자,
글루, 벌점, 또는 선택적 하이픈 같은 특별한 것을 나타낸다. 이렇게 종류가 다양하기 때문에 어떤
노드는 다른 노드보다 길고, 우리는 여러 종류의 노드를 구별해야 한다. 이를 위해 첫 낱말에 연결과
함께 `|type|' 필드를, 그리고 필요하면 `|subtype|' 필드를 넣는다.

보충: 필드 이름 |type|은 \GO/의 예약어이므로 읽는 함수의 이름은 |type_|이다. 쓰는 함수는 다른 필드와 같은
규칙에 따라 |set_type|이다.

@<정의@>=
func type_(p pointer) quarterword       { return mem[p].hh.b0 } // 이것이 어떤 종류의 노드인지 밝힌다
func set_type(p pointer, v quarterword) { mem[p].hh.b0 = v }
func subtype(p pointer) quarterword     { return mem[p].hh.b1 } // 어떤 경우의 두 번째 식별
func set_subtype(p pointer, v quarterword) { mem[p].hh.b1 = v }

@ 문자 노드 |@!char_node|는 문자 하나를 나타내는데, 모든 상자의 압도적 다수를 차지하므로 가장 중요한 종류의
노드다. 그래서 |char_node|가 메모리를 많이 차지하지 않도록 특별히 조심한다. 이런 노드는 모두 한
낱말 길이이고, 사실 이 성질로 알아볼 수 있다. 다른 종류의 노드는 적어도 두 낱말이고, |mem|에서
|hi_mem_min|보다 작은 위치에 나타나기 때문이다. 그래서 |char_node|에서는 |type| 필드를 뺄 수 있고,
그 자리에 |font|와 그 글꼴 안의 |character|를 밝히는 두 바이트를 둘 수 있다.

문자 노드의 형식은 글꼴을 256개까지, 글꼴마다 문자를 256개까지 허용한다는 데 주목하라. 그러나
대부분의 구현은 아마 작업 하나에 쓰는 글꼴의 총수를 75개보다 적게 제한할 것이고, 대부분의 글꼴은
코드가 128보다 작은 문자들을 고수할 것이다(더 높은 코드는 대부분의 자판에서 치기가 더 어렵기
때문이다).

동양 언어를 위한 \TeX의 확장에는 활자의 크기와 모양을 생각하면 $256\times256$보다 훨씬 많은
@^oriental characters@>@^Chinese characters@>@^Japanese characters@>
문자가 필요할 것이다. 중국어와 일본어 글꼴에서는 그런 문자를 잇닿은 |char_node| 두 항목으로
나타내기를 제안한다. 첫째 항목은 |font=font_base|이고 그 |link|가 둘째를 가리킨다. 둘째는 글꼴과
문자의 치수를 밝힌다. 동양 문자에서 다행인 점은 그 대부분이 같은 상자 치수를 가진다는 것이다.
첫째 |char_node|의 |character| 필드는 조판에서는 치수가 같은 그림 기호들을 서로 구별하는
``\ID{charext}''다. (\MF\ 설명서를 보라.) \TeX의 그런 확장은 어렵지 않을 것이다. 더 자세한 것은
독자에게 맡긴다.

문자 코드 |character|가 쿼터워드에 들어맞도록, \TeX은 실제 코드에 |min_quarterword|를 더한다.

문자 노드는 가로 목록에만 나타나고, 세로 목록에는 결코 나타나지 않는다.

보충: 필드 |font|에 쓰는 함수의 이름은 규칙대로라면 |set_font|여야 하지만, 그것은 이미 명령 코드의
이름이다(\os{209}). 그래서 이 함수만은 |set_font_field|라고 부른다.

@<정의@>=
func is_char_node(p pointer) bool { return p >= hi_mem_min } // 인자가 |char_node|를 가리키나?

func font(p pointer) quarterword            { return type_(p) } // |char_node|의 글꼴 코드
func set_font_field(p pointer, v quarterword) { set_type(p, v) }
func character(p pointer) quarterword       { return subtype(p) } // |char_node|의 문자 코드
func set_character(p pointer, v quarterword) { set_subtype(p, v) }

@ 노드 |hlist_node|는 가로 목록으로 만든 상자를 나타낸다. 이 노드는 저마다 일곱 낱말 길이이고, 다음
필드들을 담는다(반드시 있는 |type|과 |link|는 빼고 말한다. 다른 노드 형을 이야기할 때에도 이것들은
따로 말하지 않겠다). 필드 |height|와 |width|와 |depth|는 상자의 치수를 나타내는 눈금 정수다.
필드 |shift_amount|도 있는데, 이 상자를 얼마나 내려야 하는지(가로 목록에 나타날 때), 또는 오른쪽으로
얼마나 옮겨야 하는지(세로 목록에 나타날 때)를 나타내는 눈금 정수다. 필드 |list_ptr|는 이 상자를
만든 목록의 처음을 가리킨다. 이 필드가 |null|이면 상자는 비어 있다. 마지막으로 글루 설정을
나타내는 필드가 셋 있다. 필드 |glue_set(p)|는 글루 설정의 비례 상수를 나타내는 형 |glue_ratio|의
낱말이다. 필드 |glue_sign(p)|는 글루가 늘어나야 하는지 줄어들어야 하는지 그대로 있어야 하는지에 따라
|stretching|이나 |shrinking|이나 |normal|이다. 필드 |glue_order(p)|는 글루 설정이 적용되는 무한대의
차수(|normal|, |fil|, |fill|, |filll|)를 지정한다. 필드 |subtype|은 쓰이지 않는다.

@<정의@>=
const (
	@!hlist_node = 0 // 가로 목록 노드의 |type|
	@!box_node_size = 7 // 상자 노드에 할당할 낱말 수
	@!width_offset = 1 // 상자 노드에서 |width| 필드의 위치
	@!depth_offset = 2 // 상자 노드에서 |depth| 필드의 위치
	@!height_offset = 3 // 상자 노드에서 |height| 필드의 위치
	@!list_offset = 5 // 상자 노드에서 |list_ptr| 필드의 위치
	@!normal = 0 // 여러 경우에 이름을 붙일 때 가장 흔한 경우
	@!stretching = 1 // 글루 설정이 늘이기 성분에 적용된다
	@!shrinking = 2 // 글루 설정이 줄이기 성분에 적용된다
	@!glue_offset = 6 // 상자 노드에서 |glue_set|의 위치
)

func width(p pointer) scaled              { return mem[p+width_offset].sc } // 상자의 너비, sp 단위
func set_width(p pointer, v scaled)       { mem[p+width_offset].sc = v }
func depth(p pointer) scaled              { return mem[p+depth_offset].sc } // 상자의 깊이, sp 단위
func set_depth(p pointer, v scaled)       { mem[p+depth_offset].sc = v }
func height(p pointer) scaled             { return mem[p+height_offset].sc } // 상자의 높이, sp 단위
func set_height(p pointer, v scaled)      { mem[p+height_offset].sc = v }
func shift_amount(p pointer) scaled       { return mem[p+4].sc } // 자리 옮김 거리, sp 단위
func set_shift_amount(p pointer, v scaled) { mem[p+4].sc = v }
func list_ptr(p pointer) pointer          { return link(p + list_offset) } // 상자 안 목록의 처음
func set_list_ptr(p pointer, v pointer)   { set_link(p+list_offset, v) }
func glue_order(p pointer) quarterword    { return subtype(p + list_offset) } // 적용되는 무한대의 차수
func set_glue_order(p pointer, v quarterword) { set_subtype(p+list_offset, v) }
func glue_sign(p pointer) quarterword     { return type_(p + list_offset) } // 늘이나 줄이나
func set_glue_sign(p pointer, v quarterword) { set_type(p+list_offset, v) }
func glue_set(p pointer) glue_ratio       { return mem[p+glue_offset].gr } // 글루 설정을 위한 형 |glue_ratio|의 낱말
func set_glue_set(p pointer, v glue_ratio) { mem[p+glue_offset].gr = v }

@ 함수 |new_null_box|는 모든 하위 필드가 `\.{\\hbox\{\}}'에 해당하는 값을 가진 |hlist_node|를
가리키는 포인터를 돌려준다. (|subtype| 필드는 |min_quarterword|로 놓는데, 이것은 이제는 상관없는
역사적인 까닭 때문이다.)

@<함수들@>=
func new_null_box() pointer { // 새 상자 노드를 만든다
	var p pointer // 새 노드
	p = get_node(box_node_size)
	set_type(p, hlist_node)
	set_subtype(p, min_quarterword)
	set_width(p, 0)
	set_depth(p, 0)
	set_height(p, 0)
	set_shift_amount(p, 0)
	set_list_ptr(p, null)
	set_glue_sign(p, normal)
	set_glue_order(p, normal)
	set_glue_set(p, 0.0)
	return p
}

@ 노드 |vlist_node|는 세로 목록을 담는다는 점만 빼면 모든 면에서 |hlist_node|와 같다.

@<정의@>=
const @!vlist_node = 1 // 세로 목록 노드의 |type|

@ 노드 |rule_node|는 꽉 찬 검은 직사각형을 나타낸다. 이 노드에도 |hlist_node|처럼 |width|, |depth|, |height|
필드가 있다. 그러나 이 치수 가운데 어느 것이 $-2^{30}$이면, 실제 값은 괘선을 그것을 둘러싼 가장
안쪽 상자의 경계까지 뻗게 해서 정해진다. 이것을 ``흐르는 치수''(running dimension)라고 한다.
가로 목록에서 |width|는 결코 흐르지 않고, 세로 목록에서 |height|와 |depth|는 결코 흐르지 않는다.

@<정의@>=
const (
	@!rule_node = 2 // 괘선 노드의 |type|
	@!rule_node_size = 4 // 괘선 노드에 할당할 낱말 수
	@!null_flag = -0o10000000000 // $-2^{30}$, 빠진 항목을 뜻한다
)

func is_running(d scaled) bool { return d == null_flag } // 흐르는 치수인지 검사한다

@ 새 괘선 노드는 함수 |new_rule|이 내준다. 이 함수는 모든 치수를 ``흐르게'' 하므로, 흐르면 안 되는
치수는 바꾸어야 한다.

@<함수들@>=
func new_rule() pointer {
	var p pointer // 새 노드
	p = get_node(rule_node_size)
	set_type(p, rule_node)
	set_subtype(p, 0) // |subtype|은 쓰이지 않는다
	set_width(p, null_flag)
	set_depth(p, null_flag)
	set_height(p, null_flag)
	return p
}

@ 삽입은 |ins_node| 레코드로 나타내는데, 그 |subtype|이 해당하는 상자 번호를 나타낸다. 이를테면
`\.{\\insert 250}'은 |subtype|이 |250+min_quarterword|인 |ins_node|를 낳는다. 노드 |ins_node|의
|height| 필드는 이름이 조금 잘못 붙었다. 실제로는 끼워 넣는 세로 목록의 자연 높이에 깊이를 더한
것을 담는다. 필드 |depth|는 이 삽입이 쪼개질 경우에 쓸 |split_max_depth|를 담고, |split_top_ptr|는
해당하는 |split_top_skip|을 가리킨다. 필드 |float_cost|는 같은 종류의 쪼개진 삽입 뒤에 이 삽입이
다음 쪽으로 떠내려갈 때 쓰일 |floating_penalty|를 담는다. 필드가 하나 더 있는데, 바로 삽입할
세로 목록의 처음을 가리키는 |ins_ptr|다.

@<정의@>=
const (
	@!ins_node = 3 // 삽입 노드의 |type|
	@!ins_node_size = 5 // 삽입에 할당할 낱말 수
)

func float_cost(p pointer) int32           { return mem[p+1].sc } // 쓰일 |floating_penalty|
func set_float_cost(p pointer, v int32)    { mem[p+1].sc = v }
func ins_ptr(p pointer) pointer            { return info(p + 4) } // 끼워 넣을 세로 목록
func set_ins_ptr(p pointer, v pointer)     { set_info(p+4, v) }
func split_top_ptr(p pointer) pointer      { return link(p + 4) } // 쓰일 |split_top_skip|
func set_split_top_ptr(p pointer, v pointer) { set_link(p+4, v) }

@ 노드 |mark_node|에는 사용자의 \.{\\mark} 텍스트를 담은 토큰 목록의 참조 횟수를 가리키는 |mark_ptr|
필드가 있다. 이 필드는 하프워드가 아니라 온 낱말을 차지한다. 다른 하프워드에 넣을 것이 없기
때문이다. \PASCAL에서는 쓰지 않는 반쪽에 쓰레기를 남길 위험을 무릅쓰는 것보다 온 낱말을 쓰는 편이
쉽다.

@<정의@>=
const (
	@!mark_node = 4 // 표시 노드의 |type|
	@!small_node_size = 2 // 대부분의 노드 형에 할당할 낱말 수
)

func mark_ptr(p pointer) int32        { return mem[p+1].sc } // 표시의 토큰 목록의 머리
func set_mark_ptr(p pointer, v int32) { mem[p+1].sc = v }

@ 노드 |adjust_node|는 가로 목록에만 나타나는데, 둘러싼 세로 목록으로 옮겨 낼 재료를 지정한다. 곧
\TeX의 `\.{\\vadjust}' 연산을 구현하는 데 쓰인다. 필드 |adjust_ptr|는 이 재료를 담은 세로 목록을
가리킨다.

@<정의@>=
const @!adjust_node = 5 // 조정 노드의 |type|

func adjust_ptr(p pointer) int32        { return mark_ptr(p) } // 가로 목록에서 옮겨 낼 세로 목록
func set_adjust_ptr(p pointer, v int32) { set_mark_ptr(p, v) }

@ 노드 |ligature_node|는 가로 목록에만 나타나는데, 실제 문자 둘 이상이 서로 작용해서 만들어진 문자
하나를 지정한다. 노드의 둘째 낱말은 |lig_char| 낱말이라고 부르며, |char_node|에서처럼 |font|와
|character| 필드를 담는다. 합자를 만든 문자들은 잊히지 않는다. 진단 메시지와 하이픈 넣기에 필요하기
때문이다. 필드 |lig_ptr|는 지워진 원래 문자 모두의 문자 노드들의 연결 목록을 가리킨다. (합자를 만든
문자들이 다른 노드에 남아 있다면 이 목록은 비어 있을 수도 있다.)

필드 |subtype|은 0인데, 합자의 원래 출처에 암묵적인 왼쪽 경계나 오른쪽 경계가 들어 있었으면 각각
2나 1을 더한다.

@<정의@>=
const @!ligature_node = 6 // 합자 노드의 |type|

func lig_char(p pointer) pointer      { return p + 1 } // 합자가 들어 있는 낱말
func lig_ptr(p pointer) pointer       { return link(lig_char(p)) } // 문자들의 목록
func set_lig_ptr(p pointer, v pointer) { set_link(lig_char(p), v) }

@ 함수 |new_ligature|는 |font|, |character|, |lig_ptr| 필드의 내용이 주어진 합자 노드를 만든다.
함수 |new_lig_item|도 있는데, 이것은 |character| 필드가 주어진 두 낱말짜리 노드를 돌려준다. 이런
노드는 합자를 만드는 동안 임시 처리에 쓰인다.

@<함수들@>=
func new_ligature(f, c quarterword, q pointer) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, ligature_node)
	set_font_field(lig_char(p), f)
	set_character(lig_char(p), c)
	set_lig_ptr(p, q)
	set_subtype(p, 0)
	return p
}

func new_lig_item(c quarterword) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_character(p, c)
	set_lig_ptr(p, null)
	return p
}

@ 노드 |disc_node|는 가로 목록에만 나타나는데, ``선택적''(discretionary) 줄 나눔을 지정한다. 노드 |p|에서
그런 나눔이 일어나면, |pre_break(p)|에서 시작하는 텍스트가 나눔 앞에 오고, |post_break(p)|에서
시작하는 텍스트가 나눔 뒤에 오며, 다음 |replace_count(p)|개의 노드에 나타나는 텍스트는 무시된다.
이를테면 `\.{\\-}'로 나타내는 보통의 선택적 하이픈은 |pre_break|가 하이픈을 담은 |char_node|를
가리키고 |post_break=null|이며 |replace_count=0|인 |disc_node|를 낳는다. 세 가지 선택적 텍스트는
모두 문자, 커닝, 상자, 괘선, 합자 노드로만 이루어진 목록이어야 한다.

나눔 앞 텍스트가 없으면(|pre_break(p)=null|) 이 나눔에는 |ex_hyphen_penalty|가 매겨진다. 그렇지 않으면
|hyphen_penalty|가 매겨진다. 줄 나누기 알고리즘이 나눔을 하기로 결정하면 그 텍스트들이 실제로
목록에 대신 들어가고, 그때 선택적 나눔 노드는 사라진다. 그러므로 출력 루틴은 선택되지 않은 선택적
나눔 노드만 보게 된다.

@<정의@>=
const @!disc_node = 7 // 선택적 나눔 노드의 |type|

func replace_count(p pointer) quarterword       { return subtype(p) } // 뒤따르는 노드 가운데 몇 개를 바꿀지
func set_replace_count(p pointer, v quarterword) { set_subtype(p, v) }
func pre_break(p pointer) pointer               { return llink(p) } // 선택적 나눔 앞에 오는 텍스트
func set_pre_break(p pointer, v pointer)        { set_llink(p, v) }
func post_break(p pointer) pointer              { return rlink(p) } // 선택적 나눔 뒤에 오는 텍스트
func set_post_break(p pointer, v pointer)       { set_rlink(p, v) }

@ \dg 앞 절의 함수 |new_disc|를 옮긴다.

@<함수들@>=
func new_disc() pointer { // 빈 |disc_node|를 만든다
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, disc_node)
	set_replace_count(p, 0)
	set_pre_break(p, null)
	set_post_break(p, null)
	return p
}

@ 노드 |whatsit_node|는 \TeX의 확장을 위해 남겨 둔 만능 패다. 첫 낱말의 |subtype| 필드는 그것이 어떤
`\ID{whatsit}'인지 말해 주고, 노드의 크기(2 이상이어야 한다)와 나머지 낱말의 형식을 암묵적으로
정한다. 목록에서 |whatsit_node|를 만나면 특별한 동작이 일어난다. \TeX의 나머지 부분을 망가뜨리지
않도록 조심하는 지식 있는 사람들은 프로그램의 끝에 코드를 덧붙여 \TeX이 새로운 일을 하게 만들 수
있다. 이를테면 잉크의 색을 다르게 지정하는 `\TeX nicolor' 확장이 있을 수 있고, whatsit 노드에 원하는
@^extensions to \TeX@>
매개변수가 들어 있을 수 있다.

지금의 \TeX\ 구현은 그런 루틴을 어떻게 짤 수 있는지 보여 주려고 `\.{\\write}'와 `\.{\\special}'에
관련된 기능을 확장인 것처럼 다룬다. 확장에 관한 더 이상의 논의는 이 프로그램의 끝까지 미루겠다.

@<정의@>=
const @!whatsit_node = 8 // 특별한 확장 노드의 |type|

@ 노드 |math_node|는 가로 목록에만 나타나는데, 수식의 앞뒤에 나타난다. 필드 |subtype|은 수식
앞에서는 |before|이고 수식 뒤에서는 |after|다. 필드 |width|도 있는데, \.{\\mathsurround}로 넣은 둘레의
간격의 양을 나타낸다.

@<정의@>=
const (
	@!math_node = 9 // 수식 노드의 |type|
	@!before = 0 // 수식을 여는 수식 노드의 |subtype|
	@!after = 1 // 수식을 닫는 수식 노드의 |subtype|
)

@ \dg 앞 절의 함수 |new_math|를 옮긴다.

@<함수들@>=
func new_math(w scaled, s small_number) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, math_node)
	set_subtype(p, s)
	set_width(p, w)
	return p
}

@ \TeX은 |hlist_node|, |vlist_node|, |rule_node|, |ins_node|, |mark_node|, |adjust_node|,
|ligature_node|, |disc_node|, |whatsit_node|, |math_node|가 형 코드의 낮은 쪽 끝에 있다는 사실을
이용한다. 목록에서 앞 노드의 |type|이 |math_node|보다 작을 때, 그리고 오직 그때에만 글루에서
나눌 수 있게 하는 것이다. 또 나눔 뒤에서 노드의 형이 |math_node| 이상이면 그 노드는 버려진다.

@<정의@>=
func precedes_break(p pointer) bool  { return type_(p) < math_node }
func non_discardable(p pointer) bool { return type_(p) < math_node }

@ 노드 |glue_node|는 목록 안의 글루를 나타낸다. 그러나 이것은 실은 따로 있는 글루 명세를 가리키는
포인터일 뿐이다. 본질적으로 같은 글루 노드가 대개 여럿 있다는 사실을 \TeX이 이용하기 때문이다.
포인터 |p|가 |glue_node|를 가리키면 |glue_ptr(p)|는 늘이기와 줄이기 성분 따위를 지정하는 다른 낱말 묶음을
가리킨다.

글루 노드는 리더(leaders)를 나타내는 데에도 쓰인다. 필드 |subtype|으로 보통의 글루(|normal|이라고
부른다)와 세 가지 리더(|a_leaders|, |c_leaders|, |x_leaders|라고 부른다)를 구별한다. 필드 |leader_ptr|는 리더를 담은 괘선 노드나 상자 노드를 가리킨다. 보통의 글루 노드에서는 |null|로 놓인다.

글루의 많은 종류는 \TeX의 ``skip'' 매개변수로부터 계산되는데, 어떤 글루 노드가 어느 매개변수에서
나왔는지 알면 도움이 된다. 그래서 글루가 매개변수에서 비롯했으면 |subtype|을 그 출처를 나타내도록
놓는다. 매개변수 번호의 기호 이름은 나중에 정의할 것이다(이를테면 |line_skip_code=0|,
|baseline_skip_code=1| 따위). 지금은 매개변수 글루의 |subtype|이 매개변수 번호에 1을 더한 것과
같다고만 해 두면 충분하다.

수식에서는 글루 노드의 |subtype|에 두 가지 가능성이 더 있다. 그 가운데 |mu_glue|는 \.{\\mskip}을 나타내고(이때
단위는 눈금 \.{pt}가 아니라 눈금 \.{mu}다), |cond_math_glue|는 아래첨자에 나타나면 바로 다음 글루
노드를 취소하는 `\.{\\nonscript}' 기능을 나타낸다.

@<정의@>=
const (
	@!glue_node = 10 // 글루 명세를 가리키는 노드의 |type|
	@!cond_math_glue = 98 // 다음 노드의 글루를 억누르는 특별한 |subtype|
	@!mu_glue = 99 // 수식 글루의 |subtype|
	@!a_leaders = 100 // 정렬된 리더의 |subtype|
	@!c_leaders = 101 // 가운데 맞춘 리더의 |subtype|
	@!x_leaders = 102 // 펼친 리더의 |subtype|
)

func glue_ptr(p pointer) pointer         { return llink(p) } // 글루 명세를 가리키는 포인터
func set_glue_ptr(p pointer, v pointer)  { set_llink(p, v) }
func leader_ptr(p pointer) pointer       { return rlink(p) } // 리더를 위한 상자나 괘선 노드를 가리키는 포인터
func set_leader_ptr(p pointer, v pointer) { set_rlink(p, v) }

@ 글루 명세의 첫 낱말에는 하프워드 참조 횟수가 있는데, |null|에 그것을 가리키는 글루 노드의
@^reference counts@>
수(에서 하나를 뺀 것)를 더한 값을 나타낸다. 참조 횟수는 목록 노드의 |link| 필드와 같은 위치에
나타난다는 데 주목하라. 이 필드는 노드를 할당할 때 |null|로 초기화하는 필드이고, 빈 노드에서
|empty_flag|로 표시하는 필드이기도 하다.

글루 명세에는 |width|, |stretch|, |shrink| 치수를 위한 |scaled| 필드도 셋 있다. 마지막으로
|stretch_order|와 |shrink_order|라는 한 바이트짜리 필드가 둘 있는데, 늘이기와 줄이기 값에 해당하는
무한대의 차수(|normal|, |fil|, |fill|, |filll|)를 담는다.

@<바깥 블록의 형@>=
const (
	@!glue_spec_size = 4 // 글루 명세에 할당할 낱말 수
	@!fil = 1 // 1차 무한대
	@!fill = 2 // 2차 무한대
	@!filll = 3 // 3차 무한대
)

func glue_ref_count(p pointer) halfword         { return link(p) } // 글루 명세의 참조 횟수
func set_glue_ref_count(p pointer, v halfword)  { set_link(p, v) }
func stretch(p pointer) scaled                  { return mem[p+2].sc } // 이 글루 덩어리의 늘어남
func set_stretch(p pointer, v scaled)           { mem[p+2].sc = v }
func shrink(p pointer) scaled                   { return mem[p+3].sc } // 이 글루 덩어리의 줄어듦
func set_shrink(p pointer, v scaled)            { mem[p+3].sc = v }
func stretch_order(p pointer) quarterword       { return type_(p) } // 늘이기의 무한대 차수
func set_stretch_order(p pointer, v quarterword) { set_type(p, v) }
func shrink_order(p pointer) quarterword        { return subtype(p) } // 줄이기의 무한대 차수
func set_shrink_order(p pointer, v quarterword) { set_subtype(p, v) }

type @!glue_ord = int32 // 무한대의 0, 1, 2, 3제곱; |normal..filll|

@ 다음은 글루 명세의 사본을 가리키는 포인터를 돌려주는 함수다. 사본의 참조 횟수는 |null|이다.
새 명세에 대한 참조가 정확히 하나 있다고 가정하기 때문이다.

@<함수들@>=
func new_spec(p pointer) pointer { // 글루 명세를 복제한다
	var q pointer // 새 명세
	q = get_node(glue_spec_size)
	mem[q] = mem[p]
	set_glue_ref_count(q, null)
	set_width(q, width(p))
	set_stretch(q, stretch(p))
	set_shrink(q, shrink(p))
	return q
}

@ 그리고 다음은 번호로 밝힌 매개변수에 대한 글루 노드를 만드는 함수다. 이를테면
|new_param_glue(line_skip_code)|는 현재의 \.{\\lineskip}에 대한 글루 노드를 가리키는 포인터를
돌려준다.

@<함수들@>=
func new_param_glue(n small_number) pointer {
	var p pointer // 새 노드
	var q pointer // 글루 명세
	p = get_node(small_node_size)
	set_type(p, glue_node)
	set_subtype(p, n+1)
	set_leader_ptr(p, null)
	q = @<글루 매개변수 번호 |n|의 현재 |mem| 등가물@>
	set_glue_ptr(p, q)
	set_glue_ref_count(q, glue_ref_count(q)+1)
	return p
}

@ 이름이 딱히 없는(매개변수에서 오지 않은) 글루 노드는 함수 |new_glue|가 만든다. 그 인자는 글루
명세를 가리킨다.

@<함수들@>=
func new_glue(q pointer) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, glue_node)
	set_subtype(p, normal)
	set_leader_ptr(p, null)
	set_glue_ptr(p, q)
	set_glue_ref_count(q, glue_ref_count(q)+1)
	return p
}

@ 서브루틴이 하나 더 필요하다. 이것은 |new_param_glue|와 |new_glue|를 섞은 셈이다. 현재의 글루
매개변수 하나에 대한 글루 노드를 만들되, 글루 명세의 새 사본을 만든다. 매개변수는 그대로 있겠지만
그 명세는 아마 바뀔 것이기 때문이다. 전역 변수 |temp_ptr|는 새 명세의 주소로 놓인다.

보충: 원본은 |new_spec|의 인자 자리에 이름 있는 절을 바로 쓴다. \os{58}의 보충 설명에서 말한
까닭으로, 여기서는 절의 값을 먼저 |temp_ptr|에 받는다.

@<함수들@>=
func new_skip_param(n small_number) pointer {
	var p pointer // 새 노드
	temp_ptr = @<글루 매개변수 번호 |n|의...@>
	temp_ptr = new_spec(temp_ptr)
	p = new_glue(temp_ptr)
	set_glue_ref_count(temp_ptr, null)
	set_subtype(p, n+1)
	return p
}

@ 노드 |kern_node|에는 (보통 음수인) 간격의 양을 지정하는 |width| 필드가 있다. 이 간격 보정은 글꼴
설계자가 A와 V 같은 글자 사이를 더 가깝게 하거나 더 떨어뜨리는 편이 보기 좋다고 했을 때 가로
목록에서 글자 사이에 나타난다. 커닝 노드는 세로 목록에도 나타날 수 있는데, 이때 그 `|width|'는
세로 방향의 추가 간격을 나타낸다. 그 |subtype|은 |normal|(글꼴 정보나 수식 계산으로 넣은 커닝),
|explicit|(\.{\\kern}과 \.{\\/} 명령으로 넣은 커닝), |acc_kern|(수식이 아닌 악센트에서 넣은 커닝),
|mu_glue|(수식의 \.{\\mkern} 지정에서 넣은 커닝) 가운데 하나다.

@<정의@>=
const (
	@!kern_node = 11 // 커닝 노드의 |type|
	@!explicit = 1 // \.{\\kern}과 \.{\\/}에서 온 커닝 노드의 |subtype|
	@!acc_kern = 2 // 악센트에서 온 커닝 노드의 |subtype|
)

@ 함수 |new_kern|은 너비가 주어진 커닝 노드를 만든다.

@<함수들@>=
func new_kern(w scaled) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, kern_node)
	set_subtype(p, normal)
	set_width(p, w)
	return p
}

@ 노드 |penalty_node|는 줄 나누기나 쪽 나누기와 관련된 벌점을 |penalty| 필드에 지정한다. 이 필드는 온
낱말 정수이지만 정수 값의 전 범위가 쓰이지는 않는다. 값이 |>=10000|인 벌점은 무한대로 취급되어, 그렇게
높은 값에서는 나눔이 허용되지 않는다. 마찬가지로 |<=-10000|인 벌점은 음의 무한대로 취급되어 나눔이
강제된다.

@<정의@>=
const (
	@!penalty_node = 12 // 벌점 노드의 |type|
	@!inf_penalty = inf_bad // ``무한한'' 벌점 값
	@!eject_penalty = -inf_penalty // ``음으로 무한한'' 벌점 값
)

func penalty(p pointer) int32        { return mem[p+1].sc } // 여기서 목록을 나누는 데 드는 추가 비용
func set_penalty(p pointer, v int32) { mem[p+1].sc = v }

@ 앞의 몇 절을 읽은 사람이라면 다음에 무엇이 올지 짐작할 수 있을 것이다.

@<함수들@>=
func new_penalty(m int32) pointer {
	var p pointer // 새 노드
	p = get_node(small_node_size)
	set_type(p, penalty_node)
	set_subtype(p, 0) // |subtype|은 쓰이지 않는다
	set_penalty(p, m)
	return p
}

@ 이제 노드 형을 충분히 도입했다고 생각할지도 모르겠다. 글쎄, 거의 그렇지만 하나가 더 있다.
노드 |unset_node|는 형식이 |hlist_node|나 |vlist_node|와 거의 같다. 이것은 \.{\\halign}이나
\.{\\valign}의 항목 가운데 아직 마지막 꼴이 아닌 것에 쓰인다. 그 상자 치수는 글루를 조정하기 전의
``자연'' 크기이기 때문이다. 낱말 |glue_set|은 없고, 대신 |glue_stretch| 필드가 있는데, 상자로 만들
가로 목록이나 세로 목록에 있는 차수 |glue_order|의 늘어남의 합계를 담는다. 마찬가지로
|shift_amount| 필드 대신 |glue_shrink| 필드가 있는데, 차수 |glue_sign|의 줄어듦의 합계를 담는다.
필드 |subtype|은 |span_count|라고 부른다. 미정 상자는 대개 열 |qo(span_count)+1|개의 자료를 담는다.
미정 노드는 정렬이 끝나면 상자 노드로 바뀐다.

보충: 원본에서 |glue_stretch(p)|와 |glue_set(p)|는 같은 낱말의 서로 다른 변형이다. 이 번역에서는
|sc| 필드와 |gr| 필드로 따로 있지만, 미정 노드가 상자 노드로 바뀔 때 |glue_set|이 새로 정해지고
그 뒤로 |glue_stretch|를 읽는 일은 없으므로 상관없다(\os{113}).

@<정의@>=
const @!unset_node = 13 // 미정 노드의 |type|

func glue_stretch(p pointer) scaled              { return mem[p+glue_offset].sc } // 미정 노드의 늘어남 합계
func set_glue_stretch(p pointer, v scaled)       { mem[p+glue_offset].sc = v }
func glue_shrink(p pointer) scaled               { return shift_amount(p) } // 미정 노드의 줄어듦 합계
func set_glue_shrink(p pointer, v scaled)        { set_shift_amount(p, v) }
func span_count(p pointer) quarterword           { return subtype(p) } // 걸친 열의 수를 나타낸다
func set_span_count(p pointer, v quarterword)    { set_subtype(p, v) }

@ 사실 형은 더 나온다. 수식 처리에 이르면 |style_node|의 |type|이 14임을 보게 될 것이다. 그리고
수식 모드에서만 쓰이는 더 큰 형 코드도 여럿 정의할 것이다.

@ 경고: 이 자료 구조의 배치를 조금이라도 바꾸면, 이를테면 노드 크기를 바꾸거나 노드 안의 낱말
순서를 바꾸기만 해도, 프로시저 |copy_node_list|와 아래의 메모리 초기화 코드를 고쳐야 할 수도
있다. 프로그램의 이런 잠재적으로 위험한 부분들은 찾아보기의 `data structure assumptions'
항목에 적혀 있다.
@!@^data structure assumptions@>
그러나 노드에 대한 다른 참조들은 위의 \.{WEB} 매크로 정의를 써서 기호로 이루어지므로, 형식을 바꾸어도
\TeX의 다른 알고리즘들은 온전히 남는다.
@^system dependencies@>

@* 메모리의 배치.
배열 |mem|의 어떤 영역은 고정된 용도에 바쳐진다. 그렇게 해도 될 때에는 정적 할당이 동적 할당보다
효율적이기 때문이다. 이를테면 위치 |mem_bot|부터 |mem_bot+3|까지는 언제나 `\.{0pt plus 0pt minus
0pt}'인 글루의 명세를 저장하는 데 쓴다. 다음 매크로 정의들은 고정된 위치에 기호 이름을 붙여서 정적
할당을 해낸다. 정적인 가변 크기 노드는 위치 |mem_bot|부터 |lo_mem_stat_max|까지에 나타나고, 정적인
한 낱말짜리 노드는 위치 |hi_mem_stat_min|부터 |mem_top|까지(양 끝 포함)에 나타난다. 두 위치
|lig_trick|과 |garbage|가 |mem|의 같은 위치를 함께 써도 해가 없다.

@<정의@>=
const (
	@!zero_glue = mem_bot // \.{0pt plus 0pt minus 0pt}의 명세
	@!fil_glue = zero_glue + glue_spec_size // \.{0pt plus 1fil minus 0pt}
	@!fill_glue = fil_glue + glue_spec_size // \.{0pt plus 1fill minus 0pt}
	@!ss_glue = fill_glue + glue_spec_size // \.{0pt plus 1fil minus 1fil}
	@!fil_neg_glue = ss_glue + glue_spec_size // \.{0pt plus -1fil minus 0pt}
	@!lo_mem_stat_max = fil_neg_glue + glue_spec_size - 1 // 가변 크기 |mem|에서
	// 정적으로 할당된 가장 큰 낱말
	@#
	@!page_ins_head = mem_top // 현재 쪽의 삽입 자료 목록
	@!contrib_head = mem_top - 1 // 아직 현재 쪽에 들어가지 않은 항목들의 세로 목록
	@!page_head = mem_top - 2 // 현재 쪽의 세로 목록
	@!temp_head = mem_top - 3 // 어떤 종류의 임시 목록의 머리
	@!hold_head = mem_top - 4 // 다른 종류의 임시 목록의 머리
	@!adjust_head = mem_top - 5 // |hpack|이 돌려주는 조정 목록의 머리
	@!active = mem_top - 7 // |line_break|의 활성 목록의 머리; 두 낱말이 필요하다
	@!align_head = mem_top - 8 // 정렬의 서문 목록의 머리
	@!end_span = mem_top - 9 // 걸친 너비 목록들의 꼬리
	@!omit_template = mem_top - 10 // 상수 토큰 목록
	@!null_list = mem_top - 11 // 영원히 빈 목록
	@!lig_trick = mem_top - 12 // |char_node|로 가장한 합자
	@!garbage = mem_top - 12 // 쓰레기 정보에 쓴다
	@!backup_head = mem_top - 13 // |scan_keyword|가 만든 토큰 목록의 머리
	@!hi_mem_stat_min = mem_top - 13 // 한 낱말짜리 |mem|에서
	// 정적으로 할당된 가장 작은 낱말
	@!hi_mem_stat_usage = 14 // 언제나 있는 한 낱말짜리 노드의 수
)

@ 다음 코드는 \TeX이 느린~방법으로 스스로를 초기화할 때 |mem|이 좋은 출발을 하게 해 준다.

@<초기화를 위한 지역 변수@>=
var @!k int32 // |mem|, |eqtb| 따위의 첨자

@ @<표의 항목들을 초기화한다...@>=
for k = mem_bot + 1; k <= lo_mem_stat_max; k++ {
	mem[k].sc = 0
} // 글루 치수는 모두 0으로 놓는다
@^data structure assumptions@>
k = mem_bot
for k <= lo_mem_stat_max { // 글루 명세들의 첫 낱말을 놓는다
	set_glue_ref_count(k, null+1)
	set_stretch_order(k, normal)
	set_shrink_order(k, normal)
	k = k + glue_spec_size
}
set_stretch(fil_glue, unity)
set_stretch_order(fil_glue, fil)
set_stretch(fill_glue, unity)
set_stretch_order(fill_glue, fill)
set_stretch(ss_glue, unity)
set_stretch_order(ss_glue, fil)
set_shrink(ss_glue, unity)
set_shrink_order(ss_glue, fil)
set_stretch(fil_neg_glue, -unity)
set_stretch_order(fil_neg_glue, fil)
rover = lo_mem_stat_max + 1
set_link(rover, empty_flag) // 이제 동적 메모리를 초기화한다
set_node_size(rover, 1000) // 그것은 1000낱말짜리 빈 노드다
set_llink(rover, rover)
set_rlink(rover, rover)
lo_mem_max = rover + 1000
set_link(lo_mem_max, null)
set_info(lo_mem_max, null)
for k = hi_mem_stat_min; k <= mem_top; k++ {
	mem[k] = mem[lo_mem_max]
} // 목록의 머리들을 비운다
@<특별한 목록 머리와 상수 노드들을 초기화한다@>
avail = null
mem_end = mem_top
hi_mem_min = hi_mem_stat_min // 한 낱말짜리 메모리를 초기화한다
var_used = lo_mem_stat_max + 1 - mem_bot
dyn_used = hi_mem_stat_usage // 통계를 초기화한다

@ \TeX을 잘못 확장하면 배열 |mem|이 엉망이 될 수도 있다. 이를테면 어떤 포인터가 틀렸거나, 어떤
``죽은'' 노드가 마지막 참조가 사라졌을 때 해제되지 않았을 수도 있다. 그런 문제를 진단하는 데 도움이
되도록 프로시저 |check_mem|과 |search_mem|이 있다. 이 프로시저들은 |free|와 |was_free|라는 두
배열을 쓰는데, 이것들은 \TeX의 디버깅 루틴들이 들어가 있을 때에만 있다. (디버깅하는 동안에는
|mem|의 크기를 줄이고 싶을 수도 있다.)
@^debugging@>

보충: 이 번역에서 디버깅 코드는 언제나 컴파일되므로(\os7), 이 변수들도 언제나 있다.

@<전역 변수@>=
var @!free [mem_max + 1]bool // 빈 칸들
var @!was_free [mem_max + 1]bool // 앞서 비어 있던 칸들
var @!was_mem_end, @!was_lo_max, @!was_hi_min pointer
	// 앞서의 |mem_end|, |lo_mem_max|, |hi_mem_min|
var @!panicking bool // 메모리를 끊임없이 검사하고 싶은가?

@ @<핵심 변수들의...@>=
if debug {
	was_mem_end = mem_min // 모든 것이 앞서 비어 있었다고 표시한다
	was_lo_max = mem_min
	was_hi_min = mem_max
	panicking = false
}

@ 프로시저 |check_mem|은 |mem|의 쓸 수 있는 공간의 목록들이 제대로 된 꼴인지 확인하고, 원하면
지난번에 이 프로시저를 불렀을 때는 비어 있었지만 지금은 예약된 위치들을 모두 찍는다.

@<함수들@>=
func check_mem(print_locs bool) {
	var p, q pointer // |mem|에서 지금 관심 있는 위치들
	var clobbered bool // 무언가 잘못되었나?
	for p = mem_min; p <= lo_mem_max; p++ {
		free[p] = false
	} // 아마 이것을 더 빨리 할 수 있을 것이다
	for p = hi_mem_min; p <= mem_end; p++ {
		free[p] = false
	} // 마찬가지
	@<한 낱말짜리 |avail| 목록을 검사한다@>
	@<가변 크기 |avail| 목록을 검사한다@>
	@<쓸 수 없는 노드들의 표시를 검사한다@>
	if print_locs {
		@<새로 바빠진 위치들을 찍는다@>
	}
	for p = mem_min; p <= lo_mem_max; p++ {
		was_free[p] = free[p]
	}
	for p = hi_mem_min; p <= mem_end; p++ {
		was_free[p] = free[p]
	} // |was_free:=free|가 더 빠를 수도 있다
	was_mem_end = mem_end
	was_lo_max = lo_mem_max
	was_hi_min = hi_mem_min
}

@ @<한 낱말짜리...@>=
p = avail
q = null
clobbered = false
for p != null {
	if p > mem_end || p < hi_mem_min {
		clobbered = true
	} else if free[p] {
		clobbered = true
	}
	if clobbered {
		print_nl("AVAIL list clobbered at ")
@.AVAIL list clobbered...@>
		print_int(q)
		goto done1
	}
	free[p] = true
	q = p
	p = link(q)
}
done1:

@ @<가변 크기 |avail| 목록을 검사한다@>=
p = rover
q = null
clobbered = false
for {
	if p >= lo_mem_max || p < mem_min {
		clobbered = true
	} else if rlink(p) >= lo_mem_max || rlink(p) < mem_min {
		clobbered = true
	} else if !is_empty(p) || node_size(p) < 2 ||
		p+node_size(p) > lo_mem_max || llink(rlink(p)) != p {
		clobbered = true
	}
	if clobbered {
		print_nl("Double-AVAIL list clobbered at ")
		print_int(q)
		goto done2
	}
	for q = p; q <= p+node_size(p)-1; q++ { // 모든 위치를 비었다고 표시한다
		if free[q] {
			print_nl("Doubly free location at ")
@.Doubly free location...@>
			print_int(q)
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

@ @<쓸 수 없는 노드들의...@>=
p = mem_min
for p <= lo_mem_max { // 노드 |p|는 비어 있으면 안 된다
	if is_empty(p) {
		print_nl("Bad flag at ")
		print_int(p)
@.Bad flag...@>
	}
	for p <= lo_mem_max && !free[p] {
		p++
	}
	for p <= lo_mem_max && free[p] {
		p++
	}
}

@ @<새로 바빠진...@>=
print_nl("New busy locs:")
for p = mem_min; p <= lo_mem_max; p++ {
	if !free[p] && (p > was_lo_max || was_free[p]) {
		print_char(' ')
		print_int(p)
	}
}
for p = hi_mem_min; p <= mem_end; p++ {
	if !free[p] &&
		(p < was_hi_min || p > was_mem_end || was_free[p]) {
		print_char(' ')
		print_int(p)
	}
}

@ 프로시저 |search_mem|은 ``누가 노드~|p|를 가리키나?''라는 물음에 답하려 한다. 그러면서 형이
|two_halves|가 아닐 수도 있는 |mem|의 |link|와 |info| 필드를 읽는다. 엄밀히 말하면 이것은
@^dirty \PASCAL@>
\PASCAL에서 정의되지 않은 일이고, ``헛걸림''(순전히 우연히 |p|를 가리키는 것처럼 보이는 낱말)을
낳을 수 있다. 그러나 디버깅의 목적으로는 |p|를 가리키지 {\sl 않는\/} 곳들을 가려내고 싶은 것이므로,
헛걸림이 조금 있는 것은 참을 만하다.

@<함수들@>=
func search_mem(p pointer) { // |p|를 가리키는 포인터들을 찾는다
	var q int32 // 지금 찾고 있는 위치
	for q = mem_min; q <= lo_mem_max; q++ {
		if link(q) == p {
			print_nl("LINK(")
			print_int(q)
			print_char(')')
		}
		if info(q) == p {
			print_nl("INFO(")
			print_int(q)
			print_char(')')
		}
	}
	for q = hi_mem_min; q <= mem_end; q++ {
		if link(q) == p {
			print_nl("LINK(")
			print_int(q)
			print_char(')')
		}
		if info(q) == p {
			print_nl("INFO(")
			print_int(q)
			print_char(')')
		}
	}
	@<|eqtb|에서 |p|와 같은 등가물을 찾는다@>
	@<|save_stack|에서 |p|를 가리키는 등가물을 찾는다@>
	@<|hyph_list|에서 |p|를 가리키는 포인터를 찾는다@>
}

@* 상자 보이기.
방금 도입한 자료 구조에 대한 지식을 다지려면 목록을 기호 꼴로 보여 주는 두 프로시저를 살펴보면
된다. 첫째인 |short_display|는 ``꽉 찬 상자''(overfull box) 메시지에서 목록의 맨 위 수준을
묘사하는 데 쓰인다. 다른 하나인 |show_node_list|는 자료 구조에 정확히 무엇이 들어 있는지 자세히
묘사해서 찍는다.

프로시저 |short_display|의 철학은 상자 안에 정확히 무엇이 들어 있는지에 관한 세세한 점은 무시하되, 합자와
선택적 나눔만은 펼쳐 보이는 것이다. 그 결과 |short_display|는 재귀 프로시저이지만, 재귀는 결코 한
단계보다 깊어지지 않는다.
@^recursion@>

전역 변수 |font_in_short_display|는 |short_display|가 시작할 때 있다고 가정하는 글꼴 코드를
기록한다. 글꼴이 이것과 달라지면 그 글꼴을 찍는다.

@<전역 변수@>=
var @!font_in_short_display int32 // 내부 글꼴 번호

@ 상자, 괘선, 삽입, whatsit, 표시, 그리고 대체로 ``복잡한'' 것들은 `\.{[]}'를 찍어서 나타내기만
한다.

@<함수들@>=
func short_display(p int32) { // 목록 |p|의 두드러진 점을 찍는다
	var n int32 // 바꿈 횟수를 위해
	for p > mem_min {
		if is_char_node(p) {
			if p <= mem_end {
				if font(p) != font_in_short_display {
					if font(p) < font_base || font(p) > font_max {
						print_char('*')
@.*\relax@>
					} else {
						@<|font(p)|의 글꼴 식별자를 찍는다@>
					}
					print_char(' ')
					font_in_short_display = font(p)
				}
				print_ASCII(qo(character(p)))
			}
		} else {
			@<노드 |p|의 내용을 짧게 나타내어 찍는다@>
		}
		p = link(p)
	}
}

@ @<노드 |p|의 내용을 짧게...@>=
switch type_(p) {
case hlist_node, vlist_node, ins_node, whatsit_node, mark_node, adjust_node,
	unset_node:
	print("[]")
case rule_node:
	print_char('|')
case glue_node:
	if glue_ptr(p) != zero_glue {
		print_char(' ')
	}
case math_node:
	print_char('$')
case ligature_node:
	short_display(lig_ptr(p))
case disc_node:
	short_display(pre_break(p))
	short_display(post_break(p))
	n = replace_count(p)
	for n > 0 {
		if link(p) != null {
			p = link(p)
		}
		n--
	}
default:
	// 아무것도 하지 않는다
}

@ 루틴 |show_node_list|에는 보조 서브루틴이 몇 개 필요하다. 글꼴과 문자의 짝을 찍는 것, 토큰
목록을 참조 횟수 없이 찍는 것, 괘선 치수를 찍는 것이다.

@<함수들@>=
func print_font_and_char(p int32) { // |char_node|의 자료를 찍는다
	if p > mem_end {
		print_esc("CLOBBERED.")
	} else {
		if font(p) < font_base || font(p) > font_max {
			print_char('*')
@.*\relax@>
		} else {
			@<|font(p)|의 글꼴 식별자를...@>
		}
		print_char(' ')
		print_ASCII(qo(character(p)))
	}
}

func print_mark(p int32) { // 토큰 목록의 자료를 중괄호 안에 찍는다
	print_char('{')
	if p < hi_mem_min || p > mem_end {
		print_esc("CLOBBERED.")
	} else {
		show_token_list(link(p), null, max_print_line-10)
	}
	print_char('}')
}

func print_rule_dimen(d scaled) { // 괘선 노드의 치수를 찍는다
	if is_running(d) {
		print_char('*')
	} else {
		print_scaled(d)
	}
@.*\relax@>
}

@ 그다음은 글루의 늘어남과 줄어듦을 찍는 서브루틴이다. 그 뒤에는 유한 단위의 이름이 올 수도 있다.

보충: 원본의 |s|는 문자열 번호이거나 0이다. 0은 단위 이름이 없다는 뜻이다. 이 번역에서 |s|는 늘
\GO/ 문자열 상수이므로 빈 문자열이 원본의 0 노릇을 한다. 다음 절의 |print_spec|도 같다.

@<함수들@>=
func print_glue(d scaled, order int32, s string) { // 글루 성분 하나를 찍는다
	print_scaled(d)
	if order < normal || order > filll {
		print("foul")
	} else if order > normal {
		print("fil")
		for order > fil {
			print_char('l')
			order--
		}
	} else if s != "" {
		print(s)
	}
}

@ 다음 서브루틴은 글루 명세 전체를 찍는다.

@<함수들@>=
func print_spec(p int32, s string) { // 글루 명세를 찍는다
	if p < mem_min || p >= lo_mem_max {
		print_char('*')
@.*\relax@>
	} else {
		print_scaled(width(p))
		if s != "" {
			print(s)
		}
		if stretch(p) != 0 {
			print(" plus ")
			print_glue(stretch(p), stretch_order(p), s)
		}
		if shrink(p) != 0 {
			print(" minus ")
			print_glue(shrink(p), shrink_order(p), s)
		}
	}
}

@ 이 문서의 뒤에 나오는 프로시저도 몇 개 선언해야 한다.

@<함수들@>=
@<수식 목록의 원소들을 보이는 데 필요한 프로시저들을 선언한다@>
@<|print_skip_param|이라는 프로시저를 선언한다@>

@ 상자 안에 상자가 있을 수 있으므로 |show_node_list|는 본래 재귀적이다. 다만 주어진 최대 단계까지만
@^recursion@>
내려간다. 중첩의 내력은 현재 문자열이 나타내는데, 이것은 각 줄의 처음에 찍힌다. 이 문자열의 길이,
곧 |cur_length|가 중첩의 깊이다.

그러므로 |show_node_list|의 재귀 호출은 다음 패턴을 쓴다.

@<함수들@>=
func node_list_display(p int32) {
	append_char('.')
	show_node_list(p)
	flush_char()
} // |str_room|은 검사하지 않아도 된다; 아래의 |show_box|를 보라

@ 전역 변수 |depth_threshold|는 |show_node_list|가 정보를 보여 줄 중첩 깊이의 최댓값을 기록하는 데
쓴다. 이를테면 |depth_threshold=0|이면 맨 위 수준의 정보만 주어지고 하위 목록은 하나도 훑지 않는다.
또 하나의 전역 변수 |breadth_max|는 각 수준에서 보여 줄 항목의 최대 개수를 알려 준다. 이 값은
양수여야 한다. 그렇지 않으면 아무것도 보지 못할 것이다.

@<전역 변수@>=
var @!depth_threshold int32 // 상자 보이기에서 중첩 깊이의 최댓값
var @!breadth_max int32 // 같은 목록 수준에서 보여 줄 항목의 최대 개수

@ 이제 |show_node_list| 자체를 볼 준비가 되었다. 이 프로시저는 프로그램의 나머지 부분에 있는 버그
때문에 자료 구조가 엉망이 되었더라도 무너지거나 루프에 빠지지 않는다는 뜻에서 ``아주 튼튼하게''
쓰였다. \TeX을 디버깅할 때에는 그 부모 루틴 |show_box(p)|를 |p|의 아무 값으로나 안전하게 부를 수
있다. 그러나 나쁜 자료가 있으면 이 프로시저는 저장된 방식과 변형이 다른 |memory_word|를 읽을 수도
@^dirty \PASCAL@>@^debugging@>
있다. 이를테면 |p|가 망가진 포인터이거나 아무렇게나 고른 포인터라면 |mem[p]|에 눈금 정수가 들어
있는데 |mem[p].hh|를 읽으려 할 수도 있다.

@<함수들@>=
func show_node_list(p int32) { // 노드 목록을 기호로 찍는다
	var n int32 // 이 수준에서 이미 찍은 항목의 수
	var g float64 // 부동 소수점 수로 나타낸 글루 비율
	if cur_length() > depth_threshold {
		if p > null {
			print(" []")
		} // 잘라 냈음을 나타낸다
		return
	}
	n = 0
	for p > mem_min {
		print_ln()
		print_current_string() // 중첩의 내력을 보인다
		if p > mem_end { // 범위를 벗어난 포인터
			print("Bad link, display aborted.")
			return
@.Bad link...@>
		}
		n++
		if n > breadth_max { // 멈출 때다
			print("etc.")
			return
@.etc@>
		}
		@<노드 |p|를 보인다@>
		p = link(p)
	}
}

@ @<노드 |p|를 보인다@>=
if is_char_node(p) {
	print_font_and_char(p)
} else {
	switch type_(p) {
	case hlist_node, vlist_node, unset_node:
		@<상자 |p|를 보인다@>
	case rule_node:
		@<괘선 |p|를 보인다@>
	case ins_node:
		@<삽입 |p|를 보인다@>
	case whatsit_node:
		@<whatsit 노드 |p|를 보인다@>
	case glue_node:
		@<글루 |p|를 보인다@>
	case kern_node:
		@<커닝 |p|를 보인다@>
	case math_node:
		@<수식 노드 |p|를 보인다@>
	case ligature_node:
		@<합자 |p|를 보인다@>
	case penalty_node:
		@<벌점 |p|를 보인다@>
	case disc_node:
		@<선택적 나눔 노드 |p|를 보인다@>
	case mark_node:
		@<표시 |p|를 보인다@>
	case adjust_node:
		@<조정 |p|를 보인다@>
	@<수식 목록에서만 생기는 |show_node_list|의 경우들@>
	default:
		print("Unknown node type!")
	}
}

@ @<상자 |p|를 보인다@>=
if type_(p) == hlist_node {
	print_esc("h")
} else if type_(p) == vlist_node {
	print_esc("v")
} else {
	print_esc("unset")
}
print("box(")
print_scaled(height(p))
print_char('+')
print_scaled(depth(p))
print(")x")
print_scaled(width(p))
if type_(p) == unset_node {
	@<미정 노드 |p|의 특별한 필드들을 보인다@>
} else {
	@<|glue_set(p)|의 값을 보인다@>
	if shift_amount(p) != 0 {
		print(", shifted ")
		print_scaled(shift_amount(p))
	}
}
node_list_display(list_ptr(p)) // 재귀 호출

@ @<미정 노드 |p|의 특별한...@>=
if span_count(p) != min_quarterword {
	print(" (")
	print_int(qo(span_count(p)) + 1)
	print(" columns)")
}
if glue_stretch(p) != 0 {
	print(", stretch ")
	print_glue(glue_stretch(p), glue_order(p), "")
}
if glue_shrink(p) != 0 {
	print(", shrink ")
	print_glue(glue_shrink(p), glue_sign(p), "")
}

@ 형 |glue_ratio|가 보통의 |real|이 아니라 구조 형이라면 이곳의 코드를 바꾸어야 할 것이다. 이 루틴은
|glue_set| 필드에 아무렇게나 된 값이 들어 있더라도 산술 오류를 피해야 한다는 데 주목하라. 다음 코드는
제대로 된 0 아닌 |real| 수를 정수로 볼 때 그 절댓값이 $2^{20}$ 이상이라고 가정한다. 이 예방책은
저자의 컴퓨터에서 부동 소수점 아래넘침을 막기에 충분했다.
@^system dependencies@>
@^dirty \PASCAL@>

보충: 원본은 이 가정을 `\ignorespaces|if abs(mem[p+glue_offset].int)<@'4000000 then
print("?.?")|'라는 검사로 쓴다. 같은 낱말을 실수로 쓰고 정수로 읽는 이 ``더러운'' 검사는, 변형들이
겹치지 않는 이 번역에서는 뜻이 없다(\os{113}). \GO/의 부동 소수점 연산은 아래넘침이나 넘침으로 멈추지
않으므로, 여기서는 그 대신 값이 수가 아닌 경우(NaN)에만 `\.{?.?}'를 찍는다. 실제로 쓰이는 \TeX\
구현들도 이 검사를 뺐다.

@<|glue_set(p)|의 값을...@>=
g = float(glue_set(p))
if g != float_constant(0) && glue_sign(p) != normal {
	print(", glue set ")
	if glue_sign(p) == shrinking {
		print("- ")
	}
	if math.IsNaN(g) {
		print("?.?")
	} else if math.Abs(g) > float_constant(20000) {
		if g > float_constant(0) {
			print_char('>')
		} else {
			print("< -")
		}
		print_glue(20000*unity, glue_order(p), "")
	} else {
		print_glue(round(unity*g), glue_order(p), "")
	}
@^real multiplication@>
}

@ @<괘선 |p|를...@>=
print_esc("rule(")
print_rule_dimen(height(p))
print_char('+')
print_rule_dimen(depth(p))
print(")x")
print_rule_dimen(width(p))

@ @<삽입 |p|를...@>=
print_esc("insert")
print_int(qo(subtype(p)))
print(", natural size ")
print_scaled(height(p))
print("; split(")
print_spec(split_top_ptr(p), "")
print_char(',')
print_scaled(depth(p))
print("); float cost ")
print_int(float_cost(p))
node_list_display(ins_ptr(p)) // 재귀 호출

@ @<글루 |p|를...@>=
if subtype(p) >= a_leaders {
	@<리더 |p|를 보인다@>
} else {
	print_esc("glue")
	if subtype(p) != normal {
		print_char('(')
		if subtype(p) < cond_math_glue {
			print_skip_param(subtype(p) - 1)
		} else if subtype(p) == cond_math_glue {
			print_esc("nonscript")
		} else {
			print_esc("mskip")
		}
		print_char(')')
	}
	if subtype(p) != cond_math_glue {
		print_char(' ')
		if subtype(p) < cond_math_glue {
			print_spec(glue_ptr(p), "")
		} else {
			print_spec(glue_ptr(p), "mu")
		}
	}
}

@ @<리더 |p|를...@>=
print_esc("")
if subtype(p) == c_leaders {
	print_char('c')
} else if subtype(p) == x_leaders {
	print_char('x')
}
print("leaders ")
print_spec(glue_ptr(p), "")
node_list_display(leader_ptr(p)) // 재귀 호출

@ ``명시적'' 커닝 값은 명시적인 공백 하나로 암묵적으로 나타낸다.

@<커닝 |p|를...@>=
if subtype(p) != mu_glue {
	print_esc("kern")
	if subtype(p) != normal {
		print_char(' ')
	}
	print_scaled(width(p))
	if subtype(p) == acc_kern {
		print(" (for accent)")
	}
@.for accent@>
} else {
	print_esc("mkern")
	print_scaled(width(p))
	print("mu")
}

@ @<수식 노드 |p|를...@>=
print_esc("math")
if subtype(p) == before {
	print("on")
} else {
	print("off")
}
if width(p) != 0 {
	print(", surrounded ")
	print_scaled(width(p))
}

@ @<합자 |p|를...@>=
print_font_and_char(lig_char(p))
print(" (ligature ")
if subtype(p) > 1 {
	print_char('|')
}
font_in_short_display = font(lig_char(p))
short_display(lig_ptr(p))
if odd(subtype(p)) {
	print_char('|')
}
print_char(')')

@ @<벌점 |p|를...@>=
print_esc("penalty ")
print_int(penalty(p))

@ 선택적 나눔 노드의 |post_break| 목록은, |pre_break| 목록 앞에 붙는 `\..' 대신 `\.{\char'174}'를
앞에 붙여 나타낸다.

@<선택적 나눔 노드 |p|를...@>=
print_esc("discretionary")
if replace_count(p) > 0 {
	print(" replacing ")
	print_int(replace_count(p))
}
node_list_display(pre_break(p)) // 재귀 호출
append_char('|')
show_node_list(post_break(p))
flush_char() // 재귀 호출

@ @<표시 |p|를...@>=
print_esc("mark")
print_mark(mark_ptr(p))

@ @<조정 |p|를...@>=
print_esc("vadjust")
node_list_display(adjust_ptr(p)) // 재귀 호출

@ 재귀 장치는 |show_box|를 불러서 시동한다.
@^recursion@>

@<함수들@>=
func show_box(p pointer) {
	@<|depth_threshold|와 |breadth_max|의 값을 정한다@>
	if breadth_max <= 0 {
		breadth_max = 5
	}
	if pool_ptr+depth_threshold >= pool_size {
		depth_threshold = pool_size - pool_ptr - 1
	} // 이제 접두 문자열을 위한 자리가 넉넉하다
	show_node_list(p) // 보이기는 |p|에서 시작한다
	print_ln()
}

@* 상자 없애기.
노드 목록을 다 쓰고 나면 그 하위 목록까지 모두 빈 저장 공간으로 돌려주어야 한다. 재귀 프로시저
|flush_node_list|가 이 일을 해 준다.

@ 그러나 그 전에 더 간단한 일을 하는 비재귀 프로시저 둘을 살펴보자. 첫째인 |delete_token_ref|는
토큰 목록의 참조 횟수를 가리키는 포인터 하나가 없어질 때 불린다. 이것은 참조 횟수가 |null|이었으면
토큰 목록이 사라져야 하고, 그렇지 않으면 횟수가 하나 줄어야 한다는 뜻이다.
@^reference counts@>

@<함수들@>=
func token_ref_count(p pointer) halfword        { return info(p) } // 토큰 목록 앞의 참조 횟수
func set_token_ref_count(p pointer, v halfword) { set_info(p, v) }

func delete_token_ref(p pointer) { // |p|는 참조 하나를 잃는 토큰 목록의 참조 횟수를 가리킨다
	if token_ref_count(p) == null {
		flush_list(p)
	} else {
		set_token_ref_count(p, token_ref_count(p)-1)
	}
}

@ 마찬가지로 |delete_glue_ref|는 글루 명세를 가리키는 포인터 하나를 거둘 때 불린다.
@^reference counts@>

@<함수들@>=
func fast_delete_glue_ref(p pointer) {
	if glue_ref_count(p) == null {
		free_node(p, glue_spec_size)
	} else {
		set_glue_ref_count(p, glue_ref_count(p)-1)
	}
}

func delete_glue_ref(p pointer) { // |p|는 글루 명세를 가리킨다
	fast_delete_glue_ref(p)
}

@ 이제 어떤 노드 목록이든 재귀적으로 지울 준비가 되었다. 실제로 지우는 노드는 대개 문자 노드이고
(약 3분의 2의 경우), 나머지 경우의 약 절반은 글루 노드다.
@^recursion@>

@<함수들@>=
func flush_node_list(p pointer) { // |p|에서 시작하는 노드 목록을 지운다
	var q pointer // 노드 |p|의 후계자
	for p != null {
@^inner loop@>
		q = link(p)
		if is_char_node(p) {
			free_avail(p)
		} else {
			@<노드 형에 따라 하위 목록을 지우거나, 노드를 해제하고 |goto done|@>
			free_node(p, small_node_size)
		done:
		}
		p = q
	}
}

@ \dg 앞 절의 |case| 문이다. 크기가 |small_node_size|가 아닌 노드는 여기서 해제하고 |done|으로
간다. 나머지는 앞 절에서 |free_node(p,small_node_size)|로 해제한다.

@<노드 형에 따라 하위 목록을...@>=
switch type_(p) {
case hlist_node, vlist_node, unset_node:
	flush_node_list(list_ptr(p))
	free_node(p, box_node_size)
	goto done
case rule_node:
	free_node(p, rule_node_size)
	goto done
case ins_node:
	flush_node_list(ins_ptr(p))
	delete_glue_ref(split_top_ptr(p))
	free_node(p, ins_node_size)
	goto done
case whatsit_node:
	@<whatsit 노드 |p|를 지우고 |goto done|@>
case glue_node:
	fast_delete_glue_ref(glue_ptr(p))
	if leader_ptr(p) != null {
		flush_node_list(leader_ptr(p))
	}
case kern_node, math_node, penalty_node:
	// 아무것도 하지 않는다
case ligature_node:
	flush_node_list(lig_ptr(p))
case mark_node:
	delete_token_ref(mark_ptr(p))
case disc_node:
	flush_node_list(pre_break(p))
	flush_node_list(post_break(p))
case adjust_node:
	flush_node_list(adjust_ptr(p))
@<수식 목록에서만 생기는 |flush_node_list|의 경우들@>
default:
	confusion("flushing")
@:this can't happen flushing}{\quad flushing@>
}

@* 상자 베끼기.
상자에 작용하는 또 하나의 재귀 연산이 이따금 필요하다. 프로시저 |copy_node_list|는 원래의 것과
구조와 뜻이 같은 다른 노드 목록을 가리키는 포인터를 돌려준다. 글루 명세와 토큰 목록에는 참조 횟수가
있으므로 그것들은 베낄 필요가 없다는 데 주목하라. 참조 횟수는 하프워드에 들어가지 못할 만큼 커질 수
없다. 노드를 가리키는 포인터는 저마다 서로 다른 메모리 주소에 있고, 메모리 주소의 총수는
하프워드에 들어가기 때문이다.
@^recursion@>
@^reference counts@>

(글쎄, 실은 |mem| 바깥에서 오는 참조도 있다. 스택 |save_stack|을 마음대로 크게 만들면 이론상 참조 횟수를
넘치게 해서 \TeX을 망가뜨릴 수도 있을 것이다. 그러나 누가 그러고 싶겠는가?)

@<함수들@>=
func add_token_ref(p pointer) { set_token_ref_count(p, token_ref_count(p)+1) } // 토큰 목록에 대한 새 참조
func add_glue_ref(p pointer)  { set_glue_ref_count(p, glue_ref_count(p)+1) } // 글루 명세에 대한 새 참조

@ 베끼는 프로시저는 낱말들을 낱낱의 필드는 들여다보지 않고 한꺼번에 베낀다. 노드 형식이 바뀌면,
이를테면 크기가 달라지거나 어떤 연결 필드가 다른 상대 위치로 옮겨지면, 이 코드도 바꾸어야 할 수 있다.
@^data structure assumptions@>

@<함수들@>=
func copy_node_list(p pointer) pointer { // |p|에서 시작하는 노드 목록의 복제를 만들고
	// 새 목록을 가리키는 포인터를 돌려준다
	var h pointer // 베낀 목록의 임시 머리
	var q pointer // 새 목록에서 앞의 위치
	var r pointer // 새 목록을 위해 지금 만들고 있는 노드
	var words int32 // 아직 베낄 낱말의 수; |0..5|
	h = get_avail()
	q = h
	for p != null {
		@<노드 |p|의 사본을 노드 |r|에 만든다@>
		set_link(q, r)
		q = r
		p = link(p)
	}
	set_link(q, null)
	q = link(h)
	free_avail(h)
	return q
}

@ @<노드 |p|의 사본을...@>=
words = 1 // 이 설정이 다른 어느 것보다 많은 갈래에서 쓰인다
if is_char_node(p) {
	r = get_avail()
} else {
	@<형에 따라 베끼고 |words|를 정하는 |case| 문@>
}
for words > 0 {
	words--
	mem[r+words] = mem[p+words]
}

@ 보충: 원본처럼 짧은 문장 몇 개를 쌍반점으로 이어 한 줄에 쓴 곳이 있다. \GO/에서도 이렇게 쓸 수 있다.
\.{gtangle}이 만든 \.{.go} 파일에 \.{gofmt}를 돌리면 이것들은 한 줄에 하나씩으로 풀린다.

@<형에 따라 베끼고...@>=
switch type_(p) {
case hlist_node, vlist_node, unset_node:
	r = get_node(box_node_size)
	mem[r+6] = mem[p+6]; mem[r+5] = mem[p+5] // 마지막 두 낱말을 베낀다
	set_list_ptr(r, copy_node_list(list_ptr(p))) // 이것은 |mem[r+5]|에 영향을 준다
	words = 5
case rule_node:
	r = get_node(rule_node_size); words = rule_node_size
case ins_node:
	r = get_node(ins_node_size); mem[r+4] = mem[p+4]
	add_glue_ref(split_top_ptr(p))
	set_ins_ptr(r, copy_node_list(ins_ptr(p))) // 이것은 |mem[r+4]|에 영향을 준다
	words = ins_node_size - 1
case whatsit_node:
	@<whatsit 노드 |p|의 부분 사본 |r|를 만들고 |words|를 정한다@>
case glue_node:
	r = get_node(small_node_size); add_glue_ref(glue_ptr(p))
	set_glue_ptr(r, glue_ptr(p))
	set_leader_ptr(r, copy_node_list(leader_ptr(p)))
case kern_node, math_node, penalty_node:
	r = get_node(small_node_size); words = small_node_size
case ligature_node:
	r = get_node(small_node_size)
	mem[lig_char(r)] = mem[lig_char(p)] // |font|와 |character|를 베낀다
	set_lig_ptr(r, copy_node_list(lig_ptr(p)))
case disc_node:
	r = get_node(small_node_size)
	set_pre_break(r, copy_node_list(pre_break(p)))
	set_post_break(r, copy_node_list(post_break(p)))
case mark_node:
	r = get_node(small_node_size); add_token_ref(mark_ptr(p)); words = small_node_size
case adjust_node:
	r = get_node(small_node_size)
	set_adjust_ptr(r, copy_node_list(adjust_ptr(p)))
	// |words=1=small_node_size-1|
default:
	confusion("copying")
@:this can't happen copying}{\quad copying@>
}

@* 명령 코드.
더 나아가기 전에, \TeX이 따르는 여러 명령을 나타내는 내부 코드 번호에 기호 이름을 정의해야 한다.
이 코드들은 어느 정도 임의로 정했지만 완전히 그렇지는 않다. 이를테면 문자 형을 위한 명령 코드는
언어가 정한다. 사용자가 이를테면 `\.{\\catcode \`\\\${} = 3}'이라고 해서 \.{\char'44}를 수식
구분자로 만드는데, 명령 코드 |math_shift|는 3과 같기 때문이다. 다른 몇몇 코드는 프로그램의
|case| 문이 멀리 떨어진 경우들을 고려하지 않아도 되도록, 또는 |case| 문을 |if| 문으로 바꿀 수
있도록 서로 이웃하게 만들었다.

어쨌든 나중에 참고할 수 있도록 목록을 여기 보인다. 먼저 ``catcode'' 명령들이 온다. 그 가운데
몇몇은 \TeX의 훑기 루틴에서 그 catcode가 나올 수 없을 때 보통 명령과 수 코드를 나누어 쓴다.

@<정의@>=
const (
	@!escape = 0 // 탈출 구분자({\sl The \TeX book}에서는 \.\\라고 부른다)
@^TeXbook@>
	@!relax = 0 // 아무것도 하지 않는다( \.{\\relax} )
	@!left_brace = 1 // 그룹의 시작( \.\{ )
	@!right_brace = 2 // 그룹의 끝( \.\} )
	@!math_shift = 3 // 수식 전환 문자( \.\$ )
	@!tab_mark = 4 // 정렬 구분자( \.\&, \.{\\span} )
	@!car_ret = 5 // 줄의 끝( |carriage_return|, \.{\\cr}, \.{\\crcr} )
	@!out_param = 5 // 매크로 매개변수를 출력한다
	@!mac_param = 6 // 매크로 매개변수 기호( \.\# )
	@!sup_mark = 7 // 위첨자( \.{\char'136} )
	@!sub_mark = 8 // 아래첨자( \.{\char'137} )
	@!ignore = 9 // 무시할 문자( \.{\^\^@@} )
	@!endv = 9 // 정렬 틀에서 \<v_j> 목록의 끝
	@!spacer = 10 // 공백과 같은 문자( \.{\ } )
	@!letter = 11 // 글자로 여기는 문자( \.{A..Z}, \.{a..z} )
	@!other_char = 12 // 특별한 문자 형이 아닌 것
	@!active_char = 13 // 매크로를 부르는 문자( \.{\char`\~} )
	@!par_end = 13 // 문단의 끝( \.{\\par} )
	@!match = 13 // 매크로 매개변수에 맞춘다
	@!comment = 14 // 주석을 시작하는 문자( \.\% )
	@!end_match = 14 // 매크로 매개변수들의 끝
	@!stop = 14 // 작업의 끝( \.{\\end}, \.{\\dump} )
	@!invalid_char = 15 // 나타나면 안 되는 문자( \.{\^\^?} )
	@!delim_num = 15 // 구분자를 수로 지정한다( \.{\\delimiter} )
	@!max_char_code = 15 // 낱낱의 문자를 위한 가장 큰 catcode
)

@ 다음은 보통의 평범한 명령 코드들이다. 값이 |min_internal| 이상인 코드는 `\.{\\the}'로 펼칠 수도 있는
내부 양을 나타낸다.

@<정의@>=
const (
	@!char_num = 16 // 수로 지정한 문자( \.{\\char} )
	@!math_char_num = 17 // 명시적 수식 코드( \.{\\mathchar} )
	@!mark = 18 // 표시 정의( \.{\\mark} )
	@!xray = 19 // \TeX\ 속을 들여다본다( \.{\\show}, \.{\\showbox} 따위 )
	@!make_box = 20 // 상자를 만든다( \.{\\box}, \.{\\copy}, \.{\\hbox} 따위 )
	@!hmove = 21 // 가로 이동( \.{\\moveleft}, \.{\\moveright} )
	@!vmove = 22 // 세로 이동( \.{\\raise}, \.{\\lower} )
	@!un_hbox = 23 // 상자를 푼다( \.{\\unhbox}, \.{\\unhcopy} )
	@!un_vbox = 24 // 상자를 푼다( \.{\\unvbox}, \.{\\unvcopy} )
	@!remove_item = 25 // 마지막 항목을 없앤다( \.{\\unpenalty}, \.{\\unkern}, \.{\\unskip} )
	@!hskip = 26 // 가로 글루( \.{\\hskip}, \.{\\hfil} 따위 )
	@!vskip = 27 // 세로 글루( \.{\\vskip}, \.{\\vfil} 따위 )
	@!mskip = 28 // 수식 글루( \.{\\mskip} )
	@!kern = 29 // 고정된 간격( \.{\\kern} )
	@!mkern = 30 // 수식 커닝( \.{\\mkern} )
	@!leader_ship = 31 // 상자를 쓴다( \.{\\shipout}, \.{\\leaders} 따위 )
	@!halign = 32 // 가로 표 정렬( \.{\\halign} )
	@!valign = 33 // 세로 표 정렬( \.{\\valign} )
	@!no_align = 34 // 정렬에서 잠시 벗어난다( \.{\\noalign} )
	@!vrule = 35 // 세로 괘선( \.{\\vrule} )
	@!hrule = 36 // 가로 괘선( \.{\\hrule} )
	@!insert = 37 // 상자에 끼워 넣는 세로 목록( \.{\\insert} )
	@!vadjust = 38 // 둘러싼 문단에 끼워 넣는 세로 목록( \.{\\vadjust} )
	@!ignore_spaces = 39 // |spacer| 토큰들을 삼킨다( \.{\\ignorespaces} )
	@!after_assignment = 40 // 대입이 끝날 때까지 남겨 둔다( \.{\\afterassignment} )
	@!after_group = 41 // 그룹이 끝날 때까지 남겨 둔다( \.{\\aftergroup} )
	@!break_penalty = 42 // 추가 나쁨( \.{\\penalty} )
)

@ \dg 앞 절에 이어 보통 명령 코드를 정의한다.

@<정의@>=
const (
	@!start_par = 43 // 문단을 시작한다( \.{\\indent}, \.{\\noindent} )
	@!ital_corr = 44 // 기울임 보정( \.{\\/} )
	@!accent = 45 // 본문의 악센트를 붙인다( \.{\\accent} )
	@!math_accent = 46 // 수식의 악센트를 붙인다( \.{\\mathaccent} )
	@!discretionary = 47 // 선택적 텍스트( \.{\\-}, \.{\\discretionary} )
	@!eq_no = 48 // 수식 번호( \.{\\eqno}, \.{\\leqno} )
	@!left_right = 49 // 크기가 변하는 구분자( \.{\\left}, \.{\\right} )
	@!math_comp = 50 // 수식의 구성 요소( \.{\\mathbin} 따위 )
	@!limit_switch = 51 // 극한 관례를 바꾼다( \.{\\displaylimits} 따위 )
	@!above = 52 // 일반화된 분수( \.{\\above}, \.{\\atop} 따위 )
	@!math_style = 53 // 모양 지정( \.{\\displaystyle} 따위 )
	@!math_choice = 54 // 선택 지정( \.{\\mathchoice} )
	@!non_script = 55 // 조건부 수식 글루( \.{\\nonscript} )
	@!vcenter = 56 // 세로 상자를 세로로 가운데 맞춘다( \.{\\vcenter} )
	@!case_shift = 57 // 대소문자를 강제한다( \.{\\lowercase}, \.{\\uppercase}~)
	@!message = 58 // 사용자에게 보낸다( \.{\\message}, \.{\\errmessage} )
	@!extension = 59 // \TeX의 확장( \.{\\write}, \.{\\special} 따위 )
	@!in_stream = 60 // 읽을 파일( \.{\\openin}, \.{\\closein} )
	@!begin_group = 61 // 지역 그룹을 시작한다( \.{\\begingroup} )
	@!end_group = 62 // 지역 그룹을 끝낸다( \.{\\endgroup} )
	@!omit = 63 // 정렬 틀을 빼먹는다( \.{\\omit} )
	@!ex_space = 64 // 명시적 공백( \.{\\\ } )
	@!no_boundary = 65 // 경계 합자를 억누른다( \.{\\noboundary} )
	@!radical = 66 // 제곱근과 비슷한 기호( \.{\\radical} )
	@!end_cs_name = 67 // 제어 시퀀스를 끝낸다( \.{\\endcsname} )
	@!min_internal = 68 // \.{\\the} 뒤에 올 수 있는 가장 작은 코드
	@!char_given = 68 // \.{\\chardef}로 정의한 문자 코드
	@!math_given = 69 // \.{\\mathchardef}로 정의한 수식 코드
	@!last_item = 70 // 가장 최근 항목( \.{\\lastpenalty}, \.{\\lastkern}, \.{\\lastskip} )
	@!max_non_prefixed_command = 70 // \.{\\global}일 수 없는 가장 큰 명령 코드
)

@ 다음 코드들은 특별하다. 모두 \TeX의 내부 레지스터나 표에 모드와 상관없이 값을 대입하는 일과
관계가 있다. 값이 |max_internal| 이하인 코드는 `\.{\\the}'로 펼칠 수도 있는 내부 양을 나타낸다.

@<정의@>=
const (
	@!toks_register = 71 // 토큰 목록 레지스터( \.{\\toks} )
	@!assign_toks = 72 // 특별한 토큰 목록( \.{\\output}, \.{\\everypar} 따위 )
	@!assign_int = 73 // 사용자가 정의한 정수( \.{\\tolerance}, \.{\\day} 따위 )
	@!assign_dimen = 74 // 사용자가 정의한 길이( \.{\\hsize} 따위 )
	@!assign_glue = 75 // 사용자가 정의한 글루( \.{\\baselineskip} 따위 )
	@!assign_mu_glue = 76 // 사용자가 정의한 수식 글루( \.{\\thinmuskip} 따위 )
	@!assign_font_dimen = 77 // 사용자가 정의한 글꼴 치수( \.{\\fontdimen} )
	@!assign_font_int = 78 // 사용자가 정의한 글꼴 정수( \.{\\hyphenchar}, \.{\\skewchar} )
	@!set_aux = 79 // 상태 정보를 지정한다( \.{\\spacefactor}, \.{\\prevdepth} )
	@!set_prev_graf = 80 // 상태 정보를 지정한다( \.{\\prevgraf} )
	@!set_page_dimen = 81 // 상태 정보를 지정한다( \.{\\pagegoal} 따위 )
	@!set_page_int = 82 // 상태 정보를 지정한다( \.{\\deadcycles}, \.{\\insertpenalties} )
	@!set_box_dimen = 83 // 상자의 치수를 바꾼다( \.{\\wd}, \.{\\ht}, \.{\\dp} )
	@!set_shape = 84 // 멋진 문단 모양을 지정한다( \.{\\parshape} )
	@!def_code = 85 // 문자 코드를 정의한다( \.{\\catcode} 따위 )
	@!def_family = 86 // 수식 글꼴을 선언한다( \.{\\textfont} 따위 )
	@!set_font = 87 // 현재 글꼴을 정한다( 글꼴 식별자 )
	@!def_font = 88 // 글꼴 파일을 정의한다( \.{\\font} )
	@!register = 89 // 내부 레지스터( \.{\\count}, \.{\\dimen} 따위 )
	@!max_internal = 89 // \.{\\the} 뒤에 올 수 있는 가장 큰 코드
	@!advance = 90 // 레지스터나 매개변수를 늘린다( \.{\\advance} )
	@!multiply = 91 // 레지스터나 매개변수를 곱한다( \.{\\multiply} )
	@!divide = 92 // 레지스터나 매개변수를 나눈다( \.{\\divide} )
	@!prefix = 93 // 정의에 한정어를 붙인다( \.{\\global}, \.{\\long}, \.{\\outer} )
	@!let = 94 // 명령 코드를 대입한다( \.{\\let}, \.{\\futurelet} )
	@!shorthand_def = 95 // 코드 정의( \.{\\chardef}, \.{\\countdef} 따위 )
	@!read_to_cs = 96 // 제어 시퀀스로 읽어 들인다( \.{\\read} )
	@!def = 97 // 매크로 정의( \.{\\def}, \.{\\gdef}, \.{\\xdef}, \.{\\edef} )
	@!set_box = 98 // 상자를 정한다( \.{\\setbox} )
	@!hyph_data = 99 // 하이픈 넣기 자료( \.{\\hyphenation}, \.{\\patterns} )
	@!set_interaction = 100 // 대화 수준을 정한다( \.{\\batchmode} 따위 )
	@!max_command = 100 // |big_switch|에서 보는 가장 큰 명령 코드
)

@ 나머지 명령 코드들은 더욱 특별하다. \TeX의 훑개를 지나 주 제어 루틴에 이를 수 없기 때문이다. 그
특별한 성질을 쉽게 알아볼 수 있도록 |max_command|보다 큰 값을 주었다. ``펼칠 수 있는'' 명령들이 먼저
온다.

@<정의@>=
const (
	@!undefined_cs = max_command + 1 // 대부분의 |eq_type| 필드의 처음 상태
	@!expand_after = max_command + 2 // 특별한 펼치기( \.{\\expandafter} )
	@!no_expand = max_command + 3 // 특별한 펼치지 않기( \.{\\noexpand} )
	@!input = max_command + 4 // 원본 파일을 입력한다( \.{\\input}, \.{\\endinput} )
	@!if_test = max_command + 5 // 조건부 텍스트( \.{\\if}, \.{\\ifcase} 따위 )
	@!fi_or_else = max_command + 6 // 조건문의 구분자( \.{\\else} 따위 )
	@!cs_name = max_command + 7 // 토큰들로 제어 시퀀스를 만든다( \.{\\csname} )
	@!convert = max_command + 8 // 텍스트로 바꾼다( \.{\\number}, \.{\\string} 따위 )
	@!the = max_command + 9 // 내부 양을 펼친다( \.{\\the} )
	@!top_bot_mark = max_command + 10 // 끼워 넣은 표시( \.{\\topmark} 따위 )
	@!call = max_command + 11 // long도 outer도 아닌 제어 시퀀스
	@!long_call = max_command + 12 // long이면서 outer가 아닌 제어 시퀀스
	@!outer_call = max_command + 13 // long이 아니면서 outer인 제어 시퀀스
	@!long_outer_call = max_command + 14 // long이면서 outer인 제어 시퀀스
	@!end_template = max_command + 15 // 정렬 틀의 끝
	@!dont_expand = max_command + 16 // 다음 토큰은 \.{\\noexpand}로 표시되었다
	@!glue_ref = max_command + 17 // 등가물이 글루 명세를 가리킨다
	@!shape_ref = max_command + 18 // 등가물이 문단 모양 명세를 가리킨다
	@!box_ref = max_command + 19 // 등가물이 상자 노드를 가리키거나 |null|이다
	@!data = max_command + 20 // 등가물이 그저 하프워드 수다
)

@* 의미 둥지.
\TeX은 대개 여러 목록을 한꺼번에 만드는 중이다. 이를테면 수식을 처리할 때 \TeX은 수식 모드에서
수식 목록(mlist)을 만들고 있다. 이 수식은 \TeX이 가로 모드에서 문단의 가로 목록을 만들던 일을 잠시
가로막았고, 이 문단은 다시 \TeX이 세로 모드에서 문서의 다음 쪽을 위한 세로 목록을 만들던 일을 잠시
가로막았다. 마찬가지로 \.{\\hbox} 안에 \.{\\vbox}가 나오면 \TeX은 제한된 가로 모드에서 하던 일을 잠시
멈추고 내부 세로 모드에 들어간다. ``의미 둥지''(semantic nest)는 지금 어떤 목록과 모드들이 멈추어
있는지 추적하는 스택이다.

처리의 각 수준에서 우리는 여섯 모드 가운데 하나에 있다.

\yskip\hang|vmode|는 세로 모드(쪽 조립기)를 나타낸다.

\hang|hmode|는 가로 모드(문단 조립기)를 나타낸다.

\hang|mmode|는 따로 세운 수식 모드를 나타낸다.

\hang|-vmode|는 내부 세로 모드를 나타낸다(이를테면 \.{\\vbox} 안).

\hang|-hmode|는 제한된 가로 모드를 나타낸다(이를테면 \.{\\hbox} 안).

\hang|-mmode|는 (따로 세우지 않은) 수식 모드를 나타낸다.

\yskip\noindent \.{\\write} 텍스트를 처리하는 동안에는 모드를 잠시 0으로 놓는다.

모드 |vmode|, |hmode|, |mmode|에는 수 값을 주어서, \TeX의 ``큰 의미 전환기''가 |abs(mode)+cur_cmd|라는
값을 계산해서 할 일을 고를 수 있게 한다. 여기서 |mode|는 현재 모드이고 |cur_cmd|는 현재 명령
코드다.

@<함수들@>=
const (
	@!vmode = 1 // 세로 모드
	@!hmode = vmode + max_command + 1 // 가로 모드
	@!mmode = hmode + max_command + 1 // 수식 모드
)

@ \dg 다음 프로시저는 모드 |m|을 찍는다. 원본에서는 앞 절의 코드부에 있다.

@<함수들@>=
func print_mode(m int32) { // |m|이 나타내는 모드를 찍는다
	if m > 0 {
		switch m / (max_command + 1) {
		case 0:
			print("vertical")
		case 1:
			print("horizontal")
		case 2:
			print("display math")
		}
	} else if m == 0 {
		print("no")
	} else {
		switch (-m) / (max_command + 1) {
		case 0:
			print("internal vertical")
		case 1:
			print("restricted horizontal")
		case 2:
			print("math")
		}
	}
	print(" mode")
}

@ 각 의미 수준의 사정은 다섯 값으로 나타낼 수 있다.

\yskip\hang|mode|는 방금 설명한 대로 의미 모드를 나타내는 수다.

\yskip\hang|head|는 만들고 있는 목록의 목록 머리를 가리키는 |pointer|다. 그러므로 |link(head)|는
목록의 첫 원소를 가리키거나, 목록이 비어 있으면 |null|이다.

\yskip\hang|tail|은 만들고 있는 목록의 마지막 노드를 가리키는 |pointer|다. 그러므로 목록이 비어 있을
때, 그리고 오직 그때에만 |tail=head|다.

\yskip\hang|prev_graf|는 현재 문단에서 이미 지금의 세로 목록에 들어간 줄의 수다.

\yskip\hang|aux|는 사정을 특징짓는 데 필요한 정보를 더 주는 보조 |memory_word|다.

\yskip\noindent
세로 모드에서 |aux|는 |prev_depth|라고도 하는데, 기준선 계산에 쓰려고 앞 상자의 깊이를 나타내는 눈금
값이거나, 세로 목록의 다음 상자가 기준선 계산에서 면제되어야 하면 |<=-1000|pt다. 가로 모드에서
|aux|는 |space_factor|와 |clang|이라고도 하는데, 간격 계산에 쓰는 현재의 공백 인자와 하이픈 넣기에
쓰는 현재의 언어를 담는다. (제한된 가로 모드에서 |clang|의 값은 정의되지 않는다.) 수식 모드에서
|aux|는 |incompleat_noad|라고도 하는데, |null|이 아니면 일반화된 분수의 분자를 나타내는 레코드를
가리킨다. 그 분수의 분모를 지금 현재 목록에서 만들고 있는 것이다.

여섯째 양 |mode_line|도 있다. 이것은 의미 둥지를 사용자의 입력과 이어 준다. 이 값은 현재
중첩 수준에 들어온 원본 줄 번호를 담는다. 사용자의 출력 루틴 수준에서는 이 줄 번호의 음수가
|mode_line|이다.

가로 모드에서 |prev_graf| 필드는 처음 언어 자료에 쓰인다.

의미 둥지는 |nest|라는 배열이다. 이 배열은 현재 활성인 수준 아래의 모든 의미 수준에 대해 |mode|,
|head|, |tail|, |prev_graf|, |aux|, |mode_line| 값을 담는다. 현재 활성인 수준에 관한 정보는 전역 양
|mode|, |head|, |tail|, |prev_graf|, |aux|, |mode_line|에 들어 있는데, 이것들은 필요하면 |nest|에
쌓을 수 있도록 \PASCAL\ 레코드 하나 안에 산다.

@<바깥 블록의 형@>=
const @!ignore_depth = -65536000 // 무시하는 |prev_depth| 값

type @!list_state_record struct {
	@!mode_field int32 // |-mmode..mmode|
	@!head_field, @!tail_field pointer
	@!pg_field, @!ml_field int32
	@!aux_field memory_word
}

@ 보충: 원본은 매크로로 |mode|를 |cur_list.mode_field|로, |head|를 |cur_list.head_field|로
정의하는 식으로 현재 수준의 레코드 |cur_list|의 필드들에 짧은 이름을 붙인다. \GO/에는 매크로가 없고
변수에 다른 이름을 붙일 방법도 없으므로, 옮긴이는 레코드 |cur_list|를 두지 않고 그 필드들을 저마다
전역 변수 |mode|, |head|, |tail|, |prev_graf|, |mode_line|, |aux|로 두었다. 원본에서 |cur_list|를
통째로 다루는 곳, 곧 `|nest[nest_ptr]:=cur_list|'와 `|cur_list:=nest[nest_ptr]|'는 이 변수들을
레코드로 묶는 함수 |cur_list()|와 레코드를 풀어 놓는 함수 |set_cur_list(r)|로 옮긴다.

변수 |aux|의 다른 이름들인 |prev_depth|와 |space_factor|와 |clang|과 |incompleat_noad|는 다른 필드
매크로처럼 읽는 함수와 쓰는 함수의 짝이 된다. 원본에서 이것들은 저마다 |aux.sc|와 |aux.hh.lh|와
|aux.hh.rh|와 |aux.int|다. 필드 |sc|와 |int|는 같은 필드이므로(\os{113}) |prev_depth|와
|incompleat_noad|는 둘 다 |aux.sc|다.

@<전역 변수@>=
var @!mode int32 // 현재 모드
var @!head pointer // 현재 목록의 머리 노드
var @!tail pointer // 현재 목록의 마지막 노드
var @!prev_graf int32 // 쌓인 문단 줄의 수
var @!aux memory_word // 현재 목록에 관한 보조 자료
var @!mode_line int32 // 목록이 시작된 원본 파일 줄 번호

func prev_depth() scaled                { return aux.sc } // 세로 모드에서 |aux|의 이름
func set_prev_depth(v scaled)           { aux.sc = v }
func space_factor() halfword            { return aux.hh.lh } // 가로 모드에서 |aux|의 한 부분
func set_space_factor(v halfword)       { aux.hh.lh = v }
func clang() halfword                   { return aux.hh.rh } // 가로 모드에서 |aux|의 다른 부분
func set_clang(v halfword)              { aux.hh.rh = v }
func incompleat_noad() int32            { return aux.sc } // 수식 모드에서 |aux|의 이름
func set_incompleat_noad(v int32)       { aux.sc = v }

func cur_list() list_state_record { // ``맨 위'' 의미 상태
	return list_state_record{mode, head, tail, prev_graf, mode_line, aux}
}

func set_cur_list(r list_state_record) {
	mode, head, tail = r.mode_field, r.head_field, r.tail_field
	prev_graf, mode_line, aux = r.pg_field, r.ml_field, r.aux_field
}

var @!nest [nest_size + 1]list_state_record
var @!nest_ptr int32 // |nest|에서 쓰이지 않는 첫 위치; |0..nest_size|
var @!max_nest_stack int32 // 쌓을 때 |nest_ptr|의 최댓값
var @!shown_mode int32 // \.{\\tracingcommands}가 가장 최근에 보인 모드

@ 다음은 현재 목록을 늘리는 흔한 방법이다.

@<정의@>=
func tail_append(p pointer) {
	set_link(tail, p)
	tail = link(tail)
}

@ 나중에 보겠지만 맨 아래 의미 수준의 세로 목록은 두 부분으로 나뉜다. ``현재 쪽''은 |page_head|에서
|page_tail|까지이고, ``기여 목록''은 |contrib_head|에서 의미 수준 0의 |tail|까지다. 기여할 것들은 먼저
세로 모드에서 만들어진 다음 현재 쪽에 ``기여''되고, 그동안 쪽 나누기 결정이 이루어진다는 생각이다.
지금으로서는 쪽을 조립하는 과정에 관해 더 알 필요가 없다.

@<핵심 변수들의...@>=
nest_ptr = 0
max_nest_stack = 0
mode = vmode
head = contrib_head
tail = contrib_head
set_prev_depth(ignore_depth)
mode_line = 0
prev_graf = 0
shown_mode = 0
@<새 현재 쪽을 시작한다@>

@ \TeX이 어떤 수준에서 하던 일이 가로막히면 |push_nest|를 불러서 상태를 저장한다. 이 루틴은
새 (빈) 목록을 시작하도록 |head|와 |tail|을 바꾼다. 그러나 |mode|나 |aux|는 바꾸지 않는다.

@<함수들@>=
func push_nest() { // 새 의미 수준에 들어가고, 옛것을 저장한다
	if nest_ptr > max_nest_stack {
		max_nest_stack = nest_ptr
		if nest_ptr == nest_size {
			overflow("semantic nest size", nest_size)
		}
@:TeX capacity exceeded semantic nest size}{\quad semantic nest size@>
	}
	nest[nest_ptr] = cur_list() // 레코드를 쌓는다
	nest_ptr++
	head = get_avail()
	tail = head
	prev_graf = 0
	mode_line = line
}

@ 거꾸로, \TeX이 현재 수준의 일을 마치면 |pop_nest|를 불러서 앞의 상태를 되살린다. 이 루틴은 가장
낮은 의미 수준에서는 결코 불리지 않으며, |head|가 빈 메모리로 돌려주어야 할 노드가 아니면 불리지
않는다.

@<함수들@>=
func pop_nest() { // 의미 수준을 떠나 옛 수준에 다시 들어간다
	free_avail(head)
	nest_ptr--
	set_cur_list(nest[nest_ptr])
}

@ 다음은 \TeX이 모든 수준에서 무엇을 하고 있는지 보여 주는 프로시저다.

@<함수들@>=
func show_activities() {
	var p int32 // |nest|의 첨자; |0..nest_size|
	var m int32 // 모드; |-mmode..mmode|
	var a memory_word // 보조
	var q, r pointer // 현재 쪽을 보이기 위해
	var t int32 // 마찬가지
	nest[nest_ptr] = cur_list() // 맨 위 수준을 배열에 넣는다
	print_nl("")
	print_ln()
	for p = nest_ptr; p >= 0; p-- {
		m = nest[p].mode_field
		a = nest[p].aux_field
		print_nl("### ")
		print_mode(m)
		print(" entered at line ")
		print_int(abs(nest[p].ml_field))
		if m == hmode {
			if nest[p].pg_field != 0o40600000 {
				print(" (language")
				print_int(nest[p].pg_field % 0o200000)
				print(":hyphenmin")
				print_int(nest[p].pg_field / 0o20000000)
				print_char(',')
				print_int((nest[p].pg_field / 0o200000) % 0o100)
				print_char(')')
			}
		}
		if nest[p].ml_field < 0 {
			print(" (\\output routine)")
		}
		if p == 0 {
			@<현재 쪽의 상태를 보인다@>
			if link(contrib_head) != null {
				print_nl("### recent contributions:")
			}
		}
		show_box(link(nest[p].head_field))
		@<보조 필드 |a|를 보인다@>
	}
}

@ 보충: 가로 모드에서 |prev_graf| 필드에 담긴 처음 언어 자료는 세 수를 묶은 것이다. 이것은
\os{1091}에서 $|norm_min(left_hyphen_min)|\cdot2^{22}+|norm_min(right_hyphen_min)|\cdot2^{16}
+|cur_lang|$으로 만들어진다. 그래서 위에서 그것을 $2^{16}$(\.{'200000})과 $2^{22}$(\.{'20000000})으로
나누어 다시 푼다. 값 \.{'40600000}은 언어가 0이고 두 hyphenmin이 각각 2와 3인 기본값이다.

@<보조 필드...@>=
switch abs(m) / (max_command + 1) {
case 0:
	print_nl("prevdepth ")
	if a.sc <= ignore_depth {
		print("ignored")
	} else {
		print_scaled(a.sc)
	}
	if nest[p].pg_field != 0 {
		print(", prevgraf ")
		print_int(nest[p].pg_field)
		print(" line")
		if nest[p].pg_field != 1 {
			print_char('s')
		}
	}
case 1:
	print_nl("spacefactor ")
	print_int(a.hh.lh)
	if m > 0 {
		if a.hh.rh > 0 {
			print(", current language ")
			print_int(a.hh.rh)
		}
	}
case 2:
	if a.sc != null {
		print("this will begin denominator of:")
		show_box(a.sc)
	}
} // 다른 경우는 없다

@* 등가물 표.
\TeX의 의미 루틴들을 위한 자료 구조를 공부했으니, 이제 구문 루틴들이 쓰는 자료 구조를 살펴보아야
한다. 다시 말하면, 다음 관심사는 사용자가 쓴 것을 \TeX이 훑을 때 들여다보는 표들이다.

그런 표 가운데 가장 크고 가장 중요한 것은 |eqtb|라고 부른다. 이것은 \TeX의 그룹 장치가 주는 중첩
구조를 따르는 모든 양에 대해 그 현재의 ``등가물''(equivalent)을 담는다. 곧 그것들이 무엇을 뜻하는지,
현재 값이 무엇인지를 알려 준다. 표 |eqtb|는 여섯 부분으로 되어 있다.

\yskip\hangg 1) |eqtb[active_base..(hash_base-1)]|은 한 문자짜리 제어 시퀀스의 현재 등가물을 담는다.

\yskip\hangg 2) |eqtb[hash_base..(glue_base-1)]|은 여러 글자짜리 제어 시퀀스의 현재 등가물을 담는다.

\yskip\hangg 3) |eqtb[glue_base..(local_base-1)]|은 현재의 baselineskip 같은 글루 매개변수의 현재
등가물을 담는다.

\yskip\hangg 4) |eqtb[local_base..(int_base-1)]|은 현재의 상자 레지스터, 현재의 ``catcode'', 현재
글꼴, 현재 문단 모양을 가리키는 포인터 같은 지역 하프워드 양의 현재 등가물을 담는다.

\yskip\hangg 5) |eqtb[int_base..(dimen_base-1)]|은 현재의 하이픈 벌점 같은 온 낱말 정수 매개변수의
현재 등가물을 담는다.

\yskip\hangg 6) |eqtb[dimen_base..eqtb_size]|는 현재의 hsize나 매달린 들여쓰기의 양 같은 온 낱말
치수 매개변수의 현재 등가물을 담는다.

\yskip\noindent 이를테면 현재의 baselineskip 글루의 양은 |eqtb|의 영역~3의 특정 위치의 설정으로
정해지지만, 제어 시퀀스 `\.{\\baselineskip}'의 현재 뜻(\.{\\def}나 \.{\\let}으로 바뀌었을 수도
있다)은 영역~2에 나타난다는 데 주목하라.

@ 표 |eqtb|의 각 항목은 |memory_word|다. 이 낱말들의 대부분은 형이 |two_halves|이고, 세 필드로 나뉜다.

\yskip\hangg 1) |eq_level|(쿼터워드)은 이 등가물이 정의된 그룹 수준이다. 수준이 |level_zero|면 그
등가물은 한 번도 정의된 적이 없다. 수준 |level_one|은 바깥 수준(모든 그룹의 바깥)을 가리키며, 결코
사라지지 않는 전역 정의에도 이 수준을 쓴다. 더 높은 수준은 그 그룹이 끝날 때 사라질 등가물을 위한
것이다. @^global definitions@>

\yskip\hangg 2) |eq_type|(또 하나의 쿼터워드)은 이것이 어떤 종류의 항목인지 지정한다. 형이 많은데,
\.{\\hbox}, \.{\\def} 따위의 \TeX\ 원시 명령마다 저만의 특별한 코드가 있기 때문이다. 앞의 명령 코드
목록에 |eq_type| 필드의 가능한 설정이 모두 들어 있다.

\yskip\hangg 3) |equiv|(하프워드)는 현재의 등가 값이다. 이것은 글꼴 번호일 수도 있고, |mem|을
가리키는 포인터일 수도 있으며, 그 밖의 여러 가지일 수 있다.

@<정의@>=
func eq_level_field(w memory_word) quarterword { return w.hh.b1 }
func eq_type_field(w memory_word) quarterword  { return w.hh.b0 }
func equiv_field(w memory_word) halfword       { return w.hh.rh }

func eq_level(p pointer) quarterword        { return eq_level_field(eqtb[p]) } // 정의의 수준
func set_eq_level(p pointer, v quarterword) { eqtb[p].hh.b1 = v }
func eq_type(p pointer) quarterword         { return eq_type_field(eqtb[p]) } // 등가물의 명령 코드
func set_eq_type(p pointer, v quarterword)  { eqtb[p].hh.b0 = v }
func equiv(p pointer) halfword              { return equiv_field(eqtb[p]) } // 등가 값
func set_equiv(p pointer, v halfword)       { eqtb[p].hh.rh = v }

const (
	@!level_zero = min_quarterword // 정의되지 않은 양의 수준
	@!level_one = level_zero + 1 // 정의된 양의 가장 바깥 수준
)

@ 표 |eqtb|의 많은 위치에 기호 이름이 있다. 다음 문단들의 목적은 이 이름들을 정의하고 등가물의 처음 값을
정하는 것이다.

첫째 영역에는 제어 시퀀스처럼 행동하는 ``능동 문자''를 위한 256개의 등가물이 있고, 그 뒤에 한
문자짜리 제어 시퀀스를 위한 256개의 등가물이 온다.

그다음은 나중에 정의할 해시 표에 해당하는 영역~2다. 이 영역의 가장 큰 주소는 영원히 정의되지 않는
가짜 제어 시퀀스에 쓰인다. 오류 복구에 쓰이므로 영원히 정의되어 있는 제어 시퀀스를 위한 위치도 몇
개 있다.

@<표의 항목들을 초기화한다...@>=
set_eq_type(undefined_control_sequence, undefined_cs)
set_equiv(undefined_control_sequence, null)
set_eq_level(undefined_control_sequence, level_zero)
for k = active_base; k <= undefined_control_sequence-1; k++ {
	eqtb[k] = eqtb[undefined_control_sequence]
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!active_base = 1 // 영역 1의 시작, 능동 문자 등가물을 위해
	@!single_base = active_base + 256 // 한 문자짜리 제어 시퀀스의 등가물
	@!null_cs = single_base + 256 // \.{\\csname\\endcsname}의 등가물
	@!hash_base = null_cs + 1 // 영역 2의 시작, 해시 표를 위해
	@!frozen_control_sequence = hash_base + hash_size // 오류 복구를 위해
	@!frozen_protection = frozen_control_sequence // 접근할 수 없지만 정의할 수 있다
	@!frozen_cr = frozen_control_sequence + 1 // 영구적인 `\.{\\cr}'
	@!frozen_end_group = frozen_control_sequence + 2 // 영구적인 `\.{\\endgroup}'
	@!frozen_right = frozen_control_sequence + 3 // 영구적인 `\.{\\right}'
	@!frozen_fi = frozen_control_sequence + 4 // 영구적인 `\.{\\fi}'
	@!frozen_end_template = frozen_control_sequence + 5 // 영구적인 `\.{\\endtemplate}'
	@!frozen_endv = frozen_control_sequence + 6 // 두 번째 영구적인 `\.{\\endtemplate}'
	@!frozen_relax = frozen_control_sequence + 7 // 영구적인 `\.{\\relax}'
	@!end_write = frozen_control_sequence + 8 // 영구적인 `\.{\\endwrite}'
	@!frozen_dont_expand = frozen_control_sequence + 9 // 영구적인 `\.{\\notexpanded:}'
	@!frozen_null_font = frozen_control_sequence + 10 // 영구적인 `\.{\\nullfont}'
	@!font_id_base = frozen_null_font - font_base // 영구적인 글꼴 식별자 257개의 표가 시작한다
	@!undefined_control_sequence = frozen_null_font + 257 // 가짜 위치
	@!glue_base = undefined_control_sequence + 1 // 영역 3의 시작
)

@ 다음은 영역 1이나~2에 있는 |eqtb| 항목의 현재 뜻을 보여 주는 루틴이다. (다른 영역을 위한 비슷한
루틴들은 아래에 나온다.)

@<등가물 |n|을 보인다, 영역 1이나 2@>=
sprint_cs(n)
print_char('=')
print_cmd_chr(eq_type(n), equiv(n))
if eq_type(n) >= call {
	print_char(':')
	show_token_list(link(equiv(n)), null, 32)
}

@ 표 |eqtb|의 영역 3에는 256개의 \.{\\skip} 레지스터와 여기서 정의하는 글루 매개변수들이 들어 있다.
``muskip'' 매개변수들의 번호가 다른 것들보다 큰 것이 중요하다.

@<글루 매개변수 번호 |n|의 현재 |mem| 등가물@>=
glue_par(n)

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!line_skip_code = 0 // |baseline_skip|을 쓸 수 없을 때의 줄 사이 글루
	@!baseline_skip_code = 1 // 기준선 사이의 바라는 글루
	@!par_skip_code = 2 // 문단 바로 위의 추가 글루
	@!above_display_skip_code = 3 // 따로 세운 수식 바로 위의 추가 글루
	@!below_display_skip_code = 4 // 따로 세운 수식 바로 아래의 추가 글루
	@!above_display_short_skip_code = 5 // 짧은 줄 뒤의 따로 세운 수식 위의 글루
	@!below_display_short_skip_code = 6 // 짧은 줄 뒤의 따로 세운 수식 아래의 글루
	@!left_skip_code = 7 // 양쪽 맞춘 줄의 왼쪽 글루
	@!right_skip_code = 8 // 양쪽 맞춘 줄의 오른쪽 글루
	@!top_skip_code = 9 // 본문 쪽 맨 위의 글루
	@!split_top_skip_code = 10 // 쪼갠 쪽 맨 위의 글루
	@!tab_skip_code = 11 // 정렬된 항목 사이의 글루
	@!space_skip_code = 12 // 낱말 사이의 글루(|zero_glue|가 아니면)
	@!xspace_skip_code = 13 // 문장 뒤의 글루(|zero_glue|가 아니면)
	@!par_fill_skip_code = 14 // 문단 마지막 줄의 글루
	@!thin_mu_skip_code = 15 // 수식의 가는 공백
	@!med_mu_skip_code = 16 // 수식의 중간 공백
	@!thick_mu_skip_code = 17 // 수식의 굵은 공백
	@!glue_pars = 18 // 글루 매개변수의 총수
	@!skip_base = glue_base + glue_pars // 256개의 ``skip'' 레지스터의 표
	@!mu_skip_base = skip_base + 256 // 256개의 ``muskip'' 레지스터의 표
	@!local_base = mu_skip_base + 256 // 영역 4의 시작
)

@ \dg 영역 3의 글루 명세를 가리키는 포인터들을 읽는 함수들이다.

@<정의@>=
func skip(n int32) pointer     { return equiv(skip_base + n) } // 글루 명세의 |mem| 위치
func mu_skip(n int32) pointer  { return equiv(mu_skip_base + n) } // 수식 글루 명세의 |mem| 위치
func glue_par(n int32) pointer { return equiv(glue_base + n) } // 글루 명세의 |mem| 위치

func line_skip() pointer                { return glue_par(line_skip_code) }
func baseline_skip() pointer            { return glue_par(baseline_skip_code) }
func par_skip() pointer                 { return glue_par(par_skip_code) }
func above_display_skip() pointer       { return glue_par(above_display_skip_code) }
func below_display_skip() pointer       { return glue_par(below_display_skip_code) }
func above_display_short_skip() pointer { return glue_par(above_display_short_skip_code) }
func below_display_short_skip() pointer { return glue_par(below_display_short_skip_code) }
func left_skip() pointer                { return glue_par(left_skip_code) }
func right_skip() pointer               { return glue_par(right_skip_code) }
func top_skip() pointer                 { return glue_par(top_skip_code) }
func split_top_skip() pointer           { return glue_par(split_top_skip_code) }
func set_split_top_skip(v pointer)      { set_equiv(glue_base+split_top_skip_code, v) }
func tab_skip() pointer                 { return glue_par(tab_skip_code) }
func space_skip() pointer               { return glue_par(space_skip_code) }
func xspace_skip() pointer              { return glue_par(xspace_skip_code) }
func par_fill_skip() pointer            { return glue_par(par_fill_skip_code) }
func thin_mu_skip() pointer             { return glue_par(thin_mu_skip_code) }
func med_mu_skip() pointer              { return glue_par(med_mu_skip_code) }
func thick_mu_skip() pointer            { return glue_par(thick_mu_skip_code) }

@ 때로는 \TeX의 내부 코드 번호를 기호 꼴로 바꾸어야 한다. 루틴 |print_skip_param|은 글루 매개변수의
기호 이름을 준다.

@<|print_skip_param|이라는...@>=
func print_skip_param(n int32) {
	switch n {
	case line_skip_code: print_esc("lineskip")
	case baseline_skip_code: print_esc("baselineskip")
	case par_skip_code: print_esc("parskip")
	case above_display_skip_code: print_esc("abovedisplayskip")
	case below_display_skip_code: print_esc("belowdisplayskip")
	case above_display_short_skip_code: print_esc("abovedisplayshortskip")
	case below_display_short_skip_code: print_esc("belowdisplayshortskip")
	case left_skip_code: print_esc("leftskip")
	case right_skip_code: print_esc("rightskip")
	case top_skip_code: print_esc("topskip")
	case split_top_skip_code: print_esc("splittopskip")
	case tab_skip_code: print_esc("tabskip")
	case space_skip_code: print_esc("spaceskip")
	case xspace_skip_code: print_esc("xspaceskip")
	case par_fill_skip_code: print_esc("parfillskip")
	case thin_mu_skip_code: print_esc("thinmuskip")
	case med_mu_skip_code: print_esc("medmuskip")
	case thick_mu_skip_code: print_esc("thickmuskip")
	default: print("[unknown glue parameter!]")
	}
}

@ 글루 매개변수의 기호 이름은 아래에서 정의할 루틴 |primitive|를 써서 \TeX의 해시 표에 넣는다. 그
매개변수 이름들을 다른 데서 다시 늘어놓지 않도록 지금 넣어 두자.

@<\TeX의 원시 명령을 저마다 해시 표에 넣는다@>=
primitive("lineskip", assign_glue, glue_base+line_skip_code)
@!@:line_skip_}{\.{\\lineskip} primitive@>
primitive("baselineskip", assign_glue, glue_base+baseline_skip_code)
@!@:baseline_skip_}{\.{\\baselineskip} primitive@>
primitive("parskip", assign_glue, glue_base+par_skip_code)
@!@:par_skip_}{\.{\\parskip} primitive@>
primitive("abovedisplayskip", assign_glue, glue_base+above_display_skip_code)
@!@:above_display_skip_}{\.{\\abovedisplayskip} primitive@>
primitive("belowdisplayskip", assign_glue, glue_base+below_display_skip_code)
@!@:below_display_skip_}{\.{\\belowdisplayskip} primitive@>
primitive("abovedisplayshortskip",
	assign_glue, glue_base+above_display_short_skip_code)
@!@:above_display_short_skip_}{\.{\\abovedisplayshortskip} primitive@>
primitive("belowdisplayshortskip",
	assign_glue, glue_base+below_display_short_skip_code)
@!@:below_display_short_skip_}{\.{\\belowdisplayshortskip} primitive@>
primitive("leftskip", assign_glue, glue_base+left_skip_code)
@!@:left_skip_}{\.{\\leftskip} primitive@>
primitive("rightskip", assign_glue, glue_base+right_skip_code)
@!@:right_skip_}{\.{\\rightskip} primitive@>
primitive("topskip", assign_glue, glue_base+top_skip_code)
@!@:top_skip_}{\.{\\topskip} primitive@>
primitive("splittopskip", assign_glue, glue_base+split_top_skip_code)
@!@:split_top_skip_}{\.{\\splittopskip} primitive@>
primitive("tabskip", assign_glue, glue_base+tab_skip_code)
@!@:tab_skip_}{\.{\\tabskip} primitive@>
primitive("spaceskip", assign_glue, glue_base+space_skip_code)
@!@:space_skip_}{\.{\\spaceskip} primitive@>
primitive("xspaceskip", assign_glue, glue_base+xspace_skip_code)
@!@:xspace_skip_}{\.{\\xspaceskip} primitive@>
primitive("parfillskip", assign_glue, glue_base+par_fill_skip_code)
@!@:par_fill_skip_}{\.{\\parfillskip} primitive@>
primitive("thinmuskip", assign_mu_glue, glue_base+thin_mu_skip_code)
@!@:thin_mu_skip_}{\.{\\thinmuskip} primitive@>
primitive("medmuskip", assign_mu_glue, glue_base+med_mu_skip_code)
@!@:med_mu_skip_}{\.{\\medmuskip} primitive@>
primitive("thickmuskip", assign_mu_glue, glue_base+thick_mu_skip_code)
@!@:thick_mu_skip_}{\.{\\thickmuskip} primitive@>

@ @<원시 명령의 이름을 찍는 |print_cmd_chr|의 경우들@>=
case assign_glue, assign_mu_glue:
	if chr_code < skip_base {
		print_skip_param(chr_code - glue_base)
	} else if chr_code < mu_skip_base {
		print_esc("skip")
		print_int(chr_code - skip_base)
	} else {
		print_esc("muskip")
		print_int(chr_code - mu_skip_base)
	}

@ 모든 글루 매개변수와 레지스터는 처음에 `\.{0pt plus0pt minus0pt}'이다.

@<표의 항목들을 초기화한다...@>=
set_equiv(glue_base, zero_glue)
set_eq_level(glue_base, level_one)
set_eq_type(glue_base, glue_ref)
for k = glue_base + 1; k <= local_base-1; k++ {
	eqtb[k] = eqtb[glue_base]
}
set_glue_ref_count(zero_glue, glue_ref_count(zero_glue)+local_base-glue_base)

@ @<등가물 |n|을 보인다, 영역 3@>=
if n < skip_base {
	print_skip_param(n - glue_base)
	print_char('=')
	if n < glue_base+thin_mu_skip_code {
		print_spec(equiv(n), "pt")
	} else {
		print_spec(equiv(n), "mu")
	}
} else if n < mu_skip_base {
	print_esc("skip")
	print_int(n - skip_base)
	print_char('=')
	print_spec(equiv(n), "pt")
} else {
	print_esc("muskip")
	print_int(n - mu_skip_base)
	print_char('=')
	print_spec(equiv(n), "mu")
}

@ 표 |eqtb|의 영역 4에는 여기서 정의하는 지역 양들이 들어 있다. 이 영역의 대부분은 8비트 문자를 첨자로
쓰는 표 다섯 개가 차지하는데, 이 표들은 \TeX의 구문 부분과 의미 부분에 모두 중요하다. 글꼴과 토큰
매개변수 같은 특별한 것들도 한 무더기 있고, \.{\\toks}와 \.{\\box} 레지스터의 표들도 있다.

@<\TeX의 원시 명령을...@>=
primitive("output", assign_toks, output_routine_loc)
@!@:output_}{\.{\\output} primitive@>
primitive("everypar", assign_toks, every_par_loc)
@!@:every_par_}{\.{\\everypar} primitive@>
primitive("everymath", assign_toks, every_math_loc)
@!@:every_math_}{\.{\\everymath} primitive@>
primitive("everydisplay", assign_toks, every_display_loc)
@!@:every_display_}{\.{\\everydisplay} primitive@>
primitive("everyhbox", assign_toks, every_hbox_loc)
@!@:every_hbox_}{\.{\\everyhbox} primitive@>
primitive("everyvbox", assign_toks, every_vbox_loc)
@!@:every_vbox_}{\.{\\everyvbox} primitive@>
primitive("everyjob", assign_toks, every_job_loc)
@!@:every_job_}{\.{\\everyjob} primitive@>
primitive("everycr", assign_toks, every_cr_loc)
@!@:every_cr_}{\.{\\everycr} primitive@>
primitive("errhelp", assign_toks, err_help_loc)
@!@:err_help_}{\.{\\errhelp} primitive@>

@ \dg 앞 절의 정의부를 옮긴다. 원본에서 |box(#)|에 대입하는 곳은 쓰는 함수 |set_box_reg|가 된다.
규칙대로라면 이름이 |set_box|여야 하지만 그것은 이미 명령 코드의 이름이기 때문이다(\os{209}).

@<정의@>=
const (
	@!par_shape_loc = local_base // 문단 모양을 지정한다
	@!output_routine_loc = local_base + 1 // \.{\\output}의 토큰 목록을 가리킨다
	@!every_par_loc = local_base + 2 // \.{\\everypar}의 토큰 목록을 가리킨다
	@!every_math_loc = local_base + 3 // \.{\\everymath}의 토큰 목록을 가리킨다
	@!every_display_loc = local_base + 4 // \.{\\everydisplay}의 토큰 목록을 가리킨다
	@!every_hbox_loc = local_base + 5 // \.{\\everyhbox}의 토큰 목록을 가리킨다
	@!every_vbox_loc = local_base + 6 // \.{\\everyvbox}의 토큰 목록을 가리킨다
	@!every_job_loc = local_base + 7 // \.{\\everyjob}의 토큰 목록을 가리킨다
	@!every_cr_loc = local_base + 8 // \.{\\everycr}의 토큰 목록을 가리킨다
	@!err_help_loc = local_base + 9 // \.{\\errhelp}의 토큰 목록을 가리킨다
	@!toks_base = local_base + 10 // 256개의 토큰 목록 레지스터의 표
	@!box_base = toks_base + 256 // 256개의 상자 레지스터의 표
	@!cur_font_loc = box_base + 256 // 수식 모드 바깥의 내부 글꼴 번호
	@!math_font_base = cur_font_loc + 1 // 48개의 수식 글꼴 번호의 표
	@!cat_code_base = math_font_base + 48 // 256개의 명령 코드(``catcode'')의 표
	@!lc_code_base = cat_code_base + 256 // 256개의 소문자 대응의 표
	@!uc_code_base = lc_code_base + 256 // 256개의 대문자 대응의 표
	@!sf_code_base = uc_code_base + 256 // 256개의 공백 인자 대응의 표
	@!math_code_base = sf_code_base + 256 // 256개의 수식 모드 대응의 표
	@!int_base = math_code_base + 256 // 영역 5의 시작
)

@ \dg 영역 4의 등가물을 읽고 쓰는 함수들이다.

@<정의@>=
func par_shape_ptr() pointer   { return equiv(par_shape_loc) }
func output_routine() pointer  { return equiv(output_routine_loc) }
func every_par() pointer       { return equiv(every_par_loc) }
func every_math() pointer      { return equiv(every_math_loc) }
func every_display() pointer   { return equiv(every_display_loc) }
func every_hbox() pointer      { return equiv(every_hbox_loc) }
func every_vbox() pointer      { return equiv(every_vbox_loc) }
func every_job() pointer       { return equiv(every_job_loc) }
func every_cr() pointer        { return equiv(every_cr_loc) }
func err_help() pointer        { return equiv(err_help_loc) }
func toks(n int32) pointer     { return equiv(toks_base + n) }
func box(n int32) pointer      { return equiv(box_base + n) }
func set_box_reg(n int32, v pointer) { set_equiv(box_base+n, v) }
func cur_font() halfword       { return equiv(cur_font_loc) }
func fam_fnt(n int32) halfword { return equiv(math_font_base + n) }
func cat_code(n int32) halfword { return equiv(cat_code_base + n) }
func set_cat_code(n int32, v halfword) { set_equiv(cat_code_base+n, v) }
func lc_code(n int32) halfword  { return equiv(lc_code_base + n) }
func set_lc_code(n int32, v halfword) { set_equiv(lc_code_base+n, v) }
func uc_code(n int32) halfword  { return equiv(uc_code_base + n) }
func set_uc_code(n int32, v halfword) { set_equiv(uc_code_base+n, v) }
func sf_code(n int32) halfword  { return equiv(sf_code_base + n) }
func set_sf_code(n int32, v halfword) { set_equiv(sf_code_base+n, v) }
func math_code(n int32) halfword { return equiv(math_code_base + n) }
	// 주의: |math_code(c)|는 참 수식 코드에 |min_halfword|를 더한 것이다
func set_math_code(n int32, v halfword) { set_equiv(math_code_base+n, v) }

@ @<원시 명령의 이름을 찍는...@>=
case assign_toks:
	if chr_code >= toks_base {
		print_esc("toks")
		print_int(chr_code - toks_base)
	} else {
		switch chr_code {
		case output_routine_loc:
			print_esc("output")
		case every_par_loc:
			print_esc("everypar")
		case every_math_loc:
			print_esc("everymath")
		case every_display_loc:
			print_esc("everydisplay")
		case every_hbox_loc:
			print_esc("everyhbox")
		case every_vbox_loc:
			print_esc("everyvbox")
		case every_job_loc:
			print_esc("everyjob")
		case every_cr_loc:
			print_esc("everycr")
		default:
			print_esc("errhelp")
		}
	}

@ 대부분의 것은 널 값이나 정의되지 않은 값으로 초기화한다. 정의되지 않은 글꼴은 내부 코드
|font_base|로 나타낸다.

그러나 문자 코드 표들에는 {\mc ASCII} 코드의 관례적인 해석에 바탕을 둔 처음 값을 준다. 이 처음 값은
\TeX을 영어가 아닌 언어에 맞출 때에도 바꾸면 안 된다. 초기화 관례에 대한 모든 변경은 \TeX\ 자체가
아니라 포맷 꾸러미에서 해야 한다. 그래야 세계 곳곳에서 포맷을 주고받을 수 있다.

@<표의 항목들을 초기화한다...@>=
set_equiv(par_shape_loc, null) // 원본은 |par_shape_ptr:=null|
set_eq_type(par_shape_loc, shape_ref); set_eq_level(par_shape_loc, level_one)
for k = output_routine_loc; k <= toks_base+255; k++ {
	eqtb[k] = eqtb[undefined_control_sequence]
}
set_box_reg(0, null)
set_eq_type(box_base, box_ref); set_eq_level(box_base, level_one)
for k = box_base + 1; k <= box_base+255; k++ {
	eqtb[k] = eqtb[box_base]
}
set_equiv(cur_font_loc, null_font) // 원본은 |cur_font:=null_font|
set_eq_type(cur_font_loc, data); set_eq_level(cur_font_loc, level_one)
for k = math_font_base; k <= math_font_base+47; k++ {
	eqtb[k] = eqtb[cur_font_loc]
}
set_equiv(cat_code_base, 0)
set_eq_type(cat_code_base, data); set_eq_level(cat_code_base, level_one)
for k = cat_code_base + 1; k <= int_base-1; k++ {
	eqtb[k] = eqtb[cat_code_base]
}
for k = 0; k <= 255; k++ {
	set_cat_code(k, other_char); set_math_code(k, hi(k)); set_sf_code(k, 1000)
}
set_cat_code(carriage_return, car_ret); set_cat_code(' ', spacer)
set_cat_code('\\', escape); set_cat_code('%', comment)
set_cat_code(invalid_code, invalid_char); set_cat_code(null_code, ignore)
for k = '0'; k <= '9'; k++ {
	set_math_code(k, hi(k+var_code))
}
for k = 'A'; k <= 'Z'; k++ {
	set_cat_code(k, letter); set_cat_code(k+'a'-'A', letter)
	set_math_code(k, hi(k+var_code+0x100))
	set_math_code(k+'a'-'A', hi(k+'a'-'A'+var_code+0x100))
	set_lc_code(k, k+'a'-'A'); set_lc_code(k+'a'-'A', k+'a'-'A')
	set_uc_code(k, k); set_uc_code(k+'a'-'A', k)
	set_sf_code(k, 999)
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!null_font = font_base
	@!var_code = 0o70000 // ``현재 가족을 쓰라''는 뜻의 수식 코드
)

@ @<등가물 |n|을 보인다, 영역 4@>=
if n == par_shape_loc {
	print_esc("parshape")
	print_char('=')
	if par_shape_ptr() == null {
		print_char('0')
	} else {
		print_int(info(par_shape_ptr()))
	}
} else if n < toks_base {
	print_cmd_chr(assign_toks, n)
	print_char('=')
	if equiv(n) != null {
		show_token_list(link(equiv(n)), null, 32)
	}
} else if n < box_base {
	print_esc("toks")
	print_int(n - toks_base)
	print_char('=')
	if equiv(n) != null {
		show_token_list(link(equiv(n)), null, 32)
	}
} else if n < cur_font_loc {
	print_esc("box")
	print_int(n - box_base)
	print_char('=')
	if equiv(n) == null {
		print("void")
	} else {
		depth_threshold = 0
		breadth_max = 1
		show_node_list(equiv(n))
	}
} else if n < cat_code_base {
	@<|eqtb[n]|의 글꼴 식별자를 보인다@>
} else {
	@<|eqtb[n]|의 하프워드 코드를 보인다@>
}

@ @<|eqtb[n]|의 글꼴 식별자를...@>=
if n == cur_font_loc {
	print("current font")
} else if n < math_font_base+16 {
	print_esc("textfont")
	print_int(n - math_font_base)
} else if n < math_font_base+32 {
	print_esc("scriptfont")
	print_int(n - math_font_base - 16)
} else {
	print_esc("scriptscriptfont")
	print_int(n - math_font_base - 32)
}
print_char('=')
print_esc(hash[font_id_base+equiv(n)].rh) // 이것은 |font_id_text(equiv(n))|이다

@ @<|eqtb[n]|의 하프워드...@>=
if n < math_code_base {
	if n < lc_code_base {
		print_esc("catcode")
		print_int(n - cat_code_base)
	} else if n < uc_code_base {
		print_esc("lccode")
		print_int(n - lc_code_base)
	} else if n < sf_code_base {
		print_esc("uccode")
		print_int(n - uc_code_base)
	} else {
		print_esc("sfcode")
		print_int(n - sf_code_base)
	}
	print_char('=')
	print_int(equiv(n))
} else {
	print_esc("mathcode")
	print_int(n - math_code_base)
	print_char('=')
	print_int(ho(equiv(n)))
}

@ 표 |eqtb|의 영역 5에는 여기서 정의하는 정수 매개변수와 레지스터, 그리고 표 |del_code|가 들어 있다. 이
표는 앞에 나온 |cat_code..math_code| 표들과 다르다. 구분자 코드는 온 낱말 정수인데, 다른 종류의
코드들은 많아야 하프워드를 차지하기 때문이다. 영역~5가 영역~4와 다른 까닭이 이것이다. 등가물의 |eq_level|
정보는 나중에 정의할 쿼터워드의 보조 배열에 저장한다.

@<|depth_threshold|와 |breadth_max|의...@>=
depth_threshold = show_box_depth()
breadth_max = show_box_breadth()

@ \dg 앞 절의 정의부를 옮긴다. 원본에서 정수 매개변수에 직접 대입하는 곳은 몇 군데뿐이다. 그런
매개변수에만 쓰는 함수를 둔다.

@<정의@>=
const (
	@!pretolerance_code = 0 // 하이픈 넣기 전의 나쁨 허용치
	@!tolerance_code = 1 // 하이픈 넣은 뒤의 나쁨 허용치
	@!line_penalty_code = 2 // 모든 줄의 나쁨에 더한다
	@!hyphen_penalty_code = 3 // 선택적 하이픈 뒤에서 나누는 벌점
	@!ex_hyphen_penalty_code = 4 // 명시적 하이픈 뒤에서 나누는 벌점
	@!club_penalty_code = 5 // 클럽 줄을 만드는 벌점
	@!widow_penalty_code = 6 // 과부 줄을 만드는 벌점
	@!display_widow_penalty_code = 7 // 마찬가지, 따로 세운 수식 바로 앞에서
	@!broken_penalty_code = 8 // 나뉜 줄에서 쪽을 나누는 벌점
	@!bin_op_penalty_code = 9 // 이항 연산 뒤에서 나누는 벌점
	@!rel_penalty_code = 10 // 관계 기호 뒤에서 나누는 벌점
	@!pre_display_penalty_code = 11 // 따로 세운 수식 바로 앞에서 나누는 벌점
	@!post_display_penalty_code = 12 // 따로 세운 수식 바로 뒤에서 나누는 벌점
	@!inter_line_penalty_code = 13 // 줄 사이의 추가 벌점
	@!double_hyphen_demerits_code = 14 // 하이픈 나눔이 겹칠 때의 감점
	@!final_hyphen_demerits_code = 15 // 마지막 하이픈 나눔의 감점
	@!adj_demerits_code = 16 // 서로 맞지 않는 이웃 줄의 감점
	@!mag_code = 17 // 확대 비율
	@!delimiter_factor_code = 18 // 크기가 변하는 구분자의 비율
	@!looseness_code = 19 // 문단의 줄 수를 바꾼다
	@!time_code = 20 // 현재 시각
	@!day_code = 21 // 현재 날짜
	@!month_code = 22 // 현재 달
	@!year_code = 23 // 현재 연도(서기)
	@!show_box_breadth_code = 24 // |show_box|에서 수준마다 보일 노드 수
	@!show_box_depth_code = 25 // |show_box|에서 보일 최대 수준
	@!hbadness_code = 26 // 나쁨이 이것을 넘는 가로 상자는 |hpack|이 보여 준다
	@!vbadness_code = 27 // 나쁨이 이것을 넘는 세로 상자는 |vpack|이 보여 준다
)

@ \dg 앞 절에 이어 정수 매개변수의 코드를 정의한다.

@<정의@>=
const (
	@!pausing_code = 28 // 파일에서 줄을 하나 읽을 때마다 멈춘다
	@!tracing_online_code = 29 // 진단 출력을 터미널에 보인다
	@!tracing_macros_code = 30 // 매크로를 펼칠 때 보인다
	@!tracing_stats_code = 31 // \TeX이 안다면 메모리 사용량을 보인다
	@!tracing_paragraphs_code = 32 // 줄 나누기 계산을 보인다
	@!tracing_pages_code = 33 // 쪽 나누기 계산을 보인다
	@!tracing_output_code = 34 // 상자를 내보낼 때 보인다
	@!tracing_lost_chars_code = 35 // 글꼴에 없는 문자를 보인다
	@!tracing_commands_code = 36 // |big_switch|에서 명령 코드를 보인다
	@!tracing_restores_code = 37 // 등가물을 되살릴 때 보인다
	@!uc_hyph_code = 38 // 대문자로 시작하는 낱말에도 하이픈을 넣는다
	@!output_penalty_code = 39 // 현재 쪽 나눔에서 찾은 벌점
	@!max_dead_cycles_code = 40 // 출력의 헛돈 주기가 잇달아 일어날 수 있는 한계
	@!hang_after_code = 41 // 매달린 들여쓰기가 이만큼의 줄 뒤에 바뀐다
	@!floating_penalty_code = 42 // 쪼갠 뒤에 남겨진 삽입의 벌점
	@!global_defs_code = 43 // \.{\\global} 지정을 무시한다
	@!cur_fam_code = 44 // 현재 가족
	@!escape_char_code = 45 // 토큰을 출력할 때의 탈출 문자
	@!default_hyphen_char_code = 46 // 글꼴을 실을 때 \.{\\hyphenchar}의 값
	@!default_skew_char_code = 47 // 글꼴을 실을 때 \.{\\skewchar}의 값
	@!end_line_char_code = 48 // 버퍼의 오른쪽 끝에 놓는 문자
	@!new_line_char_code = 49 // |print_ln|으로 찍히는 문자
	@!language_code = 50 // 현재의 하이픈 넣기 표
	@!left_hyphen_min_code = 51 // 하이픈 왼쪽 조각의 최소 크기
	@!right_hyphen_min_code = 52 // 하이픈 오른쪽 조각의 최소 크기
	@!holding_inserts_code = 53 // \.{\\box255}에서 삽입 노드를 없애지 않는다
	@!error_context_lines_code = 54 // 보여 줄 중간 줄 쌍의 최대 개수
	@!int_pars = 55 // 정수 매개변수의 총수
	@!count_base = int_base + int_pars // 사용자의 \.{\\count} 레지스터 256개
	@!del_code_base = count_base + 256 // 256개의 구분자 코드 대응
	@!dimen_base = del_code_base + 256 // 영역 6의 시작
)

@ \dg 영역 5의 정수들을 읽는 함수들이다.

@<정의@>=
func del_code(n int32) int32          { return eqtb[del_code_base+n].sc }
func set_del_code(n int32, v int32)   { eqtb[del_code_base+n].sc = v }
func count(n int32) int32             { return eqtb[count_base+n].sc }
func int_par(n int32) int32           { return eqtb[int_base+n].sc } // 정수 매개변수
func set_int_par(n int32, v int32)    { eqtb[int_base+n].sc = v }
func pretolerance() int32 { return int_par(pretolerance_code) }
func tolerance() int32 { return int_par(tolerance_code) }
func line_penalty() int32 { return int_par(line_penalty_code) }
func hyphen_penalty() int32 { return int_par(hyphen_penalty_code) }
func ex_hyphen_penalty() int32 { return int_par(ex_hyphen_penalty_code) }
func club_penalty() int32 { return int_par(club_penalty_code) }
func widow_penalty() int32 { return int_par(widow_penalty_code) }
func display_widow_penalty() int32 { return int_par(display_widow_penalty_code) }
func broken_penalty() int32 { return int_par(broken_penalty_code) }
func bin_op_penalty() int32 { return int_par(bin_op_penalty_code) }
func rel_penalty() int32 { return int_par(rel_penalty_code) }
func pre_display_penalty() int32 { return int_par(pre_display_penalty_code) }
func post_display_penalty() int32 { return int_par(post_display_penalty_code) }
func inter_line_penalty() int32 { return int_par(inter_line_penalty_code) }
func double_hyphen_demerits() int32 { return int_par(double_hyphen_demerits_code) }
func final_hyphen_demerits() int32 { return int_par(final_hyphen_demerits_code) }
func adj_demerits() int32 { return int_par(adj_demerits_code) }
func mag() int32 { return int_par(mag_code) }
func delimiter_factor() int32 { return int_par(delimiter_factor_code) }
func looseness() int32 { return int_par(looseness_code) }
func time() int32 { return int_par(time_code) }
func day() int32 { return int_par(day_code) }
func month() int32 { return int_par(month_code) }
func year() int32 { return int_par(year_code) }
func show_box_breadth() int32 { return int_par(show_box_breadth_code) }
func show_box_depth() int32 { return int_par(show_box_depth_code) }
func hbadness() int32 { return int_par(hbadness_code) }
func vbadness() int32 { return int_par(vbadness_code) }
func pausing() int32 { return int_par(pausing_code) }

@ \dg 앞 절에 이어 정수 매개변수를 읽고 쓰는 함수들이다.

@<정의@>=
func tracing_online() int32 { return int_par(tracing_online_code) }
func tracing_macros() int32 { return int_par(tracing_macros_code) }
func tracing_stats() int32 { return int_par(tracing_stats_code) }
func tracing_paragraphs() int32 { return int_par(tracing_paragraphs_code) }
func tracing_pages() int32 { return int_par(tracing_pages_code) }
func tracing_output() int32 { return int_par(tracing_output_code) }
func tracing_lost_chars() int32 { return int_par(tracing_lost_chars_code) }
func tracing_commands() int32 { return int_par(tracing_commands_code) }
func tracing_restores() int32 { return int_par(tracing_restores_code) }
func uc_hyph() int32 { return int_par(uc_hyph_code) }
func output_penalty() int32 { return int_par(output_penalty_code) }
func max_dead_cycles() int32 { return int_par(max_dead_cycles_code) }
func hang_after() int32 { return int_par(hang_after_code) }
func floating_penalty() int32 { return int_par(floating_penalty_code) }
func global_defs() int32 { return int_par(global_defs_code) }
func cur_fam() int32 { return int_par(cur_fam_code) }
func escape_char() int32 { return int_par(escape_char_code) }
func default_hyphen_char() int32 { return int_par(default_hyphen_char_code) }
func default_skew_char() int32 { return int_par(default_skew_char_code) }
func end_line_char() int32 { return int_par(end_line_char_code) }
func new_line_char() int32 { return int_par(new_line_char_code) }
func language() int32 { return int_par(language_code) }
func left_hyphen_min() int32 { return int_par(left_hyphen_min_code) }
func right_hyphen_min() int32 { return int_par(right_hyphen_min_code) }
func holding_inserts() int32 { return int_par(holding_inserts_code) }
func error_context_lines() int32 { return int_par(error_context_lines_code) }
func set_mag(v int32)               { set_int_par(mag_code, v) }
func set_tolerance(v int32)         { set_int_par(tolerance_code, v) }
func set_time(v int32)              { set_int_par(time_code, v) }
func set_day(v int32)               { set_int_par(day_code, v) }
func set_month(v int32)             { set_int_par(month_code, v) }
func set_year(v int32)              { set_int_par(year_code, v) }
func set_vbadness(v int32)          { set_int_par(vbadness_code, v) }
func set_tracing_stats(v int32)     { set_int_par(tracing_stats_code, v) }
func set_max_dead_cycles(v int32)   { set_int_par(max_dead_cycles_code, v) }
func set_hang_after(v int32)        { set_int_par(hang_after_code, v) }
func set_escape_char(v int32)       { set_int_par(escape_char_code, v) }
func set_end_line_char(v int32)     { set_int_par(end_line_char_code, v) }
func set_new_line_char(v int32)     { set_int_par(new_line_char_code, v) }

@ 정수 매개변수의 기호 이름은 다음과 같이 찍을 수 있다.

@<함수들@>=
func print_param(n int32) {
	switch n {
	case pretolerance_code: print_esc("pretolerance")
	case tolerance_code: print_esc("tolerance")
	case line_penalty_code: print_esc("linepenalty")
	case hyphen_penalty_code: print_esc("hyphenpenalty")
	case ex_hyphen_penalty_code: print_esc("exhyphenpenalty")
	case club_penalty_code: print_esc("clubpenalty")
	case widow_penalty_code: print_esc("widowpenalty")
	case display_widow_penalty_code: print_esc("displaywidowpenalty")
	case broken_penalty_code: print_esc("brokenpenalty")
	case bin_op_penalty_code: print_esc("binoppenalty")
	case rel_penalty_code: print_esc("relpenalty")
	case pre_display_penalty_code: print_esc("predisplaypenalty")
	case post_display_penalty_code: print_esc("postdisplaypenalty")
	case inter_line_penalty_code: print_esc("interlinepenalty")
	case double_hyphen_demerits_code: print_esc("doublehyphendemerits")
	case final_hyphen_demerits_code: print_esc("finalhyphendemerits")
	case adj_demerits_code: print_esc("adjdemerits")
	case mag_code: print_esc("mag")
	case delimiter_factor_code: print_esc("delimiterfactor")
	case looseness_code: print_esc("looseness")
	case time_code: print_esc("time")
	case day_code: print_esc("day")
	case month_code: print_esc("month")
	case year_code: print_esc("year")
	case show_box_breadth_code: print_esc("showboxbreadth")
	case show_box_depth_code: print_esc("showboxdepth")
	case hbadness_code: print_esc("hbadness")
	case vbadness_code: print_esc("vbadness")
	case pausing_code: print_esc("pausing")
	@<|print_param|의 나머지 경우들@>
	default: print("[unknown integer parameter!]")
	}
}

@ \dg 앞 절에 이어지는 경우들이다.

@<|print_param|의 나머지...@>=
case tracing_online_code: print_esc("tracingonline")
case tracing_macros_code: print_esc("tracingmacros")
case tracing_stats_code: print_esc("tracingstats")
case tracing_paragraphs_code: print_esc("tracingparagraphs")
case tracing_pages_code: print_esc("tracingpages")
case tracing_output_code: print_esc("tracingoutput")
case tracing_lost_chars_code: print_esc("tracinglostchars")
case tracing_commands_code: print_esc("tracingcommands")
case tracing_restores_code: print_esc("tracingrestores")
case uc_hyph_code: print_esc("uchyph")
case output_penalty_code: print_esc("outputpenalty")
case max_dead_cycles_code: print_esc("maxdeadcycles")
case hang_after_code: print_esc("hangafter")
case floating_penalty_code: print_esc("floatingpenalty")
case global_defs_code: print_esc("globaldefs")
case cur_fam_code: print_esc("fam")
case escape_char_code: print_esc("escapechar")
case default_hyphen_char_code: print_esc("defaulthyphenchar")
case default_skew_char_code: print_esc("defaultskewchar")
case end_line_char_code: print_esc("endlinechar")
case new_line_char_code: print_esc("newlinechar")
case language_code: print_esc("language")
case left_hyphen_min_code: print_esc("lefthyphenmin")
case right_hyphen_min_code: print_esc("righthyphenmin")
case holding_inserts_code: print_esc("holdinginserts")
case error_context_lines_code: print_esc("errorcontextlines")

@ 정수 매개변수의 이름들을 해시 표에 넣어야 한다.

@<\TeX의 원시 명령을...@>=
primitive("pretolerance", assign_int, int_base+pretolerance_code)
@!@:pretolerance_}{\.{\\pretolerance} primitive@>
primitive("tolerance", assign_int, int_base+tolerance_code)
@!@:tolerance_}{\.{\\tolerance} primitive@>
primitive("linepenalty", assign_int, int_base+line_penalty_code)
@!@:line_penalty_}{\.{\\linepenalty} primitive@>
primitive("hyphenpenalty", assign_int, int_base+hyphen_penalty_code)
@!@:hyphen_penalty_}{\.{\\hyphenpenalty} primitive@>
primitive("exhyphenpenalty", assign_int, int_base+ex_hyphen_penalty_code)
@!@:ex_hyphen_penalty_}{\.{\\exhyphenpenalty} primitive@>
primitive("clubpenalty", assign_int, int_base+club_penalty_code)
@!@:club_penalty_}{\.{\\clubpenalty} primitive@>
primitive("widowpenalty", assign_int, int_base+widow_penalty_code)
@!@:widow_penalty_}{\.{\\widowpenalty} primitive@>
primitive("displaywidowpenalty", assign_int, int_base+display_widow_penalty_code)
@!@:display_widow_penalty_}{\.{\\displaywidowpenalty} primitive@>
primitive("brokenpenalty", assign_int, int_base+broken_penalty_code)
@!@:broken_penalty_}{\.{\\brokenpenalty} primitive@>
primitive("binoppenalty", assign_int, int_base+bin_op_penalty_code)
@!@:bin_op_penalty_}{\.{\\binoppenalty} primitive@>
primitive("relpenalty", assign_int, int_base+rel_penalty_code)
@!@:rel_penalty_}{\.{\\relpenalty} primitive@>
primitive("predisplaypenalty", assign_int, int_base+pre_display_penalty_code)
@!@:pre_display_penalty_}{\.{\\predisplaypenalty} primitive@>
primitive("postdisplaypenalty", assign_int, int_base+post_display_penalty_code)
@!@:post_display_penalty_}{\.{\\postdisplaypenalty} primitive@>
primitive("interlinepenalty", assign_int, int_base+inter_line_penalty_code)
@!@:inter_line_penalty_}{\.{\\interlinepenalty} primitive@>
primitive("doublehyphendemerits", assign_int, int_base+double_hyphen_demerits_code)
@!@:double_hyphen_demerits_}{\.{\\doublehyphendemerits} primitive@>
primitive("finalhyphendemerits", assign_int, int_base+final_hyphen_demerits_code)
@!@:final_hyphen_demerits_}{\.{\\finalhyphendemerits} primitive@>
primitive("adjdemerits", assign_int, int_base+adj_demerits_code)
@!@:adj_demerits_}{\.{\\adjdemerits} primitive@>
primitive("mag", assign_int, int_base+mag_code)
@!@:mag_}{\.{\\mag} primitive@>
primitive("delimiterfactor", assign_int, int_base+delimiter_factor_code)
@!@:delimiter_factor_}{\.{\\delimiterfactor} primitive@>
primitive("looseness", assign_int, int_base+looseness_code)
@!@:looseness_}{\.{\\looseness} primitive@>
primitive("time", assign_int, int_base+time_code)
@!@:time_}{\.{\\time} primitive@>
primitive("day", assign_int, int_base+day_code)
@!@:day_}{\.{\\day} primitive@>
primitive("month", assign_int, int_base+month_code)
@!@:month_}{\.{\\month} primitive@>
primitive("year", assign_int, int_base+year_code)
@!@:year_}{\.{\\year} primitive@>
primitive("showboxbreadth", assign_int, int_base+show_box_breadth_code)
@!@:show_box_breadth_}{\.{\\showboxbreadth} primitive@>
primitive("showboxdepth", assign_int, int_base+show_box_depth_code)
@!@:show_box_depth_}{\.{\\showboxdepth} primitive@>
primitive("hbadness", assign_int, int_base+hbadness_code)
@!@:hbadness_}{\.{\\hbadness} primitive@>
primitive("vbadness", assign_int, int_base+vbadness_code)
@!@:vbadness_}{\.{\\vbadness} primitive@>
primitive("pausing", assign_int, int_base+pausing_code)
@!@:pausing_}{\.{\\pausing} primitive@>

@ \dg 앞 절에 이어 나머지 정수 매개변수의 이름들을 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("tracingonline", assign_int, int_base+tracing_online_code)
@!@:tracing_online_}{\.{\\tracingonline} primitive@>
primitive("tracingmacros", assign_int, int_base+tracing_macros_code)
@!@:tracing_macros_}{\.{\\tracingmacros} primitive@>
primitive("tracingstats", assign_int, int_base+tracing_stats_code)
@!@:tracing_stats_}{\.{\\tracingstats} primitive@>
primitive("tracingparagraphs", assign_int, int_base+tracing_paragraphs_code)
@!@:tracing_paragraphs_}{\.{\\tracingparagraphs} primitive@>
primitive("tracingpages", assign_int, int_base+tracing_pages_code)
@!@:tracing_pages_}{\.{\\tracingpages} primitive@>
primitive("tracingoutput", assign_int, int_base+tracing_output_code)
@!@:tracing_output_}{\.{\\tracingoutput} primitive@>
primitive("tracinglostchars", assign_int, int_base+tracing_lost_chars_code)
@!@:tracing_lost_chars_}{\.{\\tracinglostchars} primitive@>
primitive("tracingcommands", assign_int, int_base+tracing_commands_code)
@!@:tracing_commands_}{\.{\\tracingcommands} primitive@>
primitive("tracingrestores", assign_int, int_base+tracing_restores_code)
@!@:tracing_restores_}{\.{\\tracingrestores} primitive@>
primitive("uchyph", assign_int, int_base+uc_hyph_code)
@!@:uc_hyph_}{\.{\\uchyph} primitive@>
primitive("outputpenalty", assign_int, int_base+output_penalty_code)
@!@:output_penalty_}{\.{\\outputpenalty} primitive@>
primitive("maxdeadcycles", assign_int, int_base+max_dead_cycles_code)
@!@:max_dead_cycles_}{\.{\\maxdeadcycles} primitive@>
primitive("hangafter", assign_int, int_base+hang_after_code)
@!@:hang_after_}{\.{\\hangafter} primitive@>
primitive("floatingpenalty", assign_int, int_base+floating_penalty_code)
@!@:floating_penalty_}{\.{\\floatingpenalty} primitive@>
primitive("globaldefs", assign_int, int_base+global_defs_code)
@!@:global_defs_}{\.{\\globaldefs} primitive@>
primitive("fam", assign_int, int_base+cur_fam_code)
@!@:fam_}{\.{\\fam} primitive@>
primitive("escapechar", assign_int, int_base+escape_char_code)
@!@:escape_char_}{\.{\\escapechar} primitive@>
primitive("defaulthyphenchar", assign_int, int_base+default_hyphen_char_code)
@!@:default_hyphen_char_}{\.{\\defaulthyphenchar} primitive@>
primitive("defaultskewchar", assign_int, int_base+default_skew_char_code)
@!@:default_skew_char_}{\.{\\defaultskewchar} primitive@>
primitive("endlinechar", assign_int, int_base+end_line_char_code)
@!@:end_line_char_}{\.{\\endlinechar} primitive@>
primitive("newlinechar", assign_int, int_base+new_line_char_code)
@!@:new_line_char_}{\.{\\newlinechar} primitive@>
primitive("language", assign_int, int_base+language_code)
@!@:language_}{\.{\\language} primitive@>
primitive("lefthyphenmin", assign_int, int_base+left_hyphen_min_code)
@!@:left_hyphen_min_}{\.{\\lefthyphenmin} primitive@>
primitive("righthyphenmin", assign_int, int_base+right_hyphen_min_code)
@!@:right_hyphen_min_}{\.{\\righthyphenmin} primitive@>
primitive("holdinginserts", assign_int, int_base+holding_inserts_code)
@!@:holding_inserts_}{\.{\\holdinginserts} primitive@>
primitive("errorcontextlines", assign_int, int_base+error_context_lines_code)
@!@:error_context_lines_}{\.{\\errorcontextlines} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case assign_int:
	if chr_code < count_base {
		print_param(chr_code - int_base)
	} else {
		print_esc("count")
		print_int(chr_code - count_base)
	}

@ 정수 매개변수는 실은 매크로 꾸러미가 초기화해야 한다. 다음 초기화는 \TeX이 완전히 실패하지 않을
만큼의 최소한만 한다.
@^null delimiter@>

@<표의 항목들을 초기화한다...@>=
for k = int_base; k <= del_code_base-1; k++ {
	eqtb[k].sc = 0
}
set_mag(1000)
set_tolerance(10000)
set_hang_after(1)
set_max_dead_cycles(25)
set_escape_char('\\')
set_end_line_char(carriage_return)
for k = 0; k <= 255; k++ {
	set_del_code(k, -1)
}
set_del_code('.', 0) // 이 널 구분자는 오류 복구에 쓰인다

@ 다음 프로시저는 \TeX이 입력과 출력을 초기화하기 바로 전에 불려서 날짜와 시각의 처음 값을 정한다.
@^system dependencies@>
표준 \PASCAL은 그런 정보를 줄 수 없으므로 무언가 특별한 것이 필요하다. 여기의 프로그램은 그저 알맞은
값이 전역 변수 \ID{sys\_time}, \ID{sys\_day}, \ID{sys\_month}, \ID{sys\_year}에 나타난다고
가정한다(구현자가 조심성이 없을 경우에 대비해서 1776년 7월 4일 정오로 초기화한다).

보충: \GO/에서는 |time| 꾸러미로 현재 날짜와 시각을 쉽게 얻을 수 있다. 그러나 옮긴이는 원본의
``자명한 진리''를 그대로 두었다. 이렇게 하면 같은 입력에 대해 언제나 같은 출력이 나오므로 결과를
비교하기 좋다. 미국 독립 선언문의 날짜를 쓴 저자의 장난도 살리고 싶었다.

@<함수들@>=
func fix_date_and_time() {
	sys_time = 12 * 60
	sys_day = 4
	sys_month = 7
	sys_year = 1776 // 자명한 진리들
	set_time(sys_time) // 자정부터 센 분
	set_day(sys_day) // 그 달의 날
	set_month(sys_month) // 그 해의 달
	set_year(sys_year) // 서기
}

@ @<등가물 |n|을 보인다, 영역 5@>=
if n < count_base {
	print_param(n - int_base)
} else if n < del_code_base {
	print_esc("count")
	print_int(n - count_base)
} else {
	print_esc("delcode")
	print_int(n - del_code_base)
}
print_char('=')
print_int(eqtb[n].sc)

@ @<변수 |c|를 현재의...@>=
c = escape_char()

@ @<문자 |s|가 현재의...@>=
s == new_line_char()

@ \TeX은 이따금 진단 정보를 찍어야 하는데, |tracing_online|이 양수가 아니면 그것은 기록 파일에만
들어간다. 다음은 찍기 명령의 목적지를 조정하는 두 루틴이다.

@<함수들@>=
func begin_diagnostic() { // 추적할 준비를 한다
	old_setting = selector
	if tracing_online() <= 0 && selector == term_and_log {
		selector--
		if history == spotless {
			history = warning_issued
		}
	}
}

func end_diagnostic(blank_line bool) { // 추적한 뒤에 알맞은 상태를 되살린다
	print_nl("")
	if blank_line {
		print_ln()
	}
	selector = old_setting
}

@ 물론 앞의 루틴들이 돌아가려면 전역 변수를 몇 개 더 선언해야 한다.

@<전역 변수@>=
var @!old_setting int32 // |0..max_selector|
var @!sys_time, @!sys_day, @!sys_month, @!sys_year int32 // 바깥 시스템이 주는 날짜와 시각

@ 표 |eqtb|의 마지막 영역에는 여기서 정의하는 치수 매개변수와 256개의 \.{\\dimen} 레지스터가 들어 있다.

@<함수들@>=
const (
	@!par_indent_code = 0 // 문단의 들여쓰기
	@!math_surround_code = 1 // 본문 속 수식 둘레의 간격
	@!line_skip_limit_code = 2 // |baseline_skip| 대신 |line_skip|을 쓰는 문턱값
	@!hsize_code = 3 // 가로 모드의 줄 너비
	@!vsize_code = 4 // 세로 모드의 쪽 높이
	@!max_depth_code = 5 // 본문 쪽에서 상자 깊이의 최댓값
	@!split_max_depth_code = 6 // 쪼갠 쪽에서 상자 깊이의 최댓값
	@!box_max_depth_code = 7 // 명시적 세로 상자의 최대 깊이
	@!hfuzz_code = 8 // 꽉 찬 가로 상자 메시지의 허용치
	@!vfuzz_code = 9 // 꽉 찬 세로 상자 메시지의 허용치
	@!delimiter_shortfall_code = 10 // 크기가 변하는 구분자가 덮지 못해도 되는 최대량
	@!null_delimiter_space_code = 11 // 널 구분자의 빈 간격
	@!script_space_code = 12 // 아래첨자나 위첨자 뒤의 추가 간격
	@!pre_display_size_code = 13 // 따로 세운 수식 앞 텍스트의 길이
	@!display_width_code = 14 // 따로 세운 수식의 줄 길이
	@!display_indent_code = 15 // 따로 세운 수식의 줄 들여쓰기
	@!overfull_rule_code = 16 // 꽉 찬 가로 상자를 알리는 괘선의 너비
	@!hang_indent_code = 17 // 매달린 들여쓰기의 양
	@!h_offset_code = 18 // 쪽을 내보낼 때 가로 어긋남의 양
	@!v_offset_code = 19 // 쪽을 내보낼 때 세로 어긋남의 양
	@!emergency_stretch_code = 20 // 줄 나누기의 마지막 단계에서 나쁨을 줄인다
	@!dimen_pars = 21 // 치수 매개변수의 총수
	@!scaled_base = dimen_base + dimen_pars // 사용자가 정의하는 \.{\\dimen} 레지스터 256개의 표
	@!eqtb_size = scaled_base + 255 // |eqtb|의 가장 큰 첨자
)

@ \dg 영역 6의 치수들을 읽고 쓰는 함수들이다.

@<함수들@>=
func dimen(n int32) scaled         { return eqtb[scaled_base+n].sc }
func dimen_par(n int32) scaled     { return eqtb[dimen_base+n].sc } // 눈금 양
func set_dimen_par(n int32, v scaled) { eqtb[dimen_base+n].sc = v }
func par_indent() scaled { return dimen_par(par_indent_code) }
func math_surround() scaled { return dimen_par(math_surround_code) }
func line_skip_limit() scaled { return dimen_par(line_skip_limit_code) }
func hsize() scaled { return dimen_par(hsize_code) }
func vsize() scaled { return dimen_par(vsize_code) }
func max_depth() scaled { return dimen_par(max_depth_code) }
func split_max_depth() scaled { return dimen_par(split_max_depth_code) }
func box_max_depth() scaled { return dimen_par(box_max_depth_code) }
func hfuzz() scaled { return dimen_par(hfuzz_code) }
func vfuzz() scaled { return dimen_par(vfuzz_code) }
func delimiter_shortfall() scaled { return dimen_par(delimiter_shortfall_code) }
func null_delimiter_space() scaled { return dimen_par(null_delimiter_space_code) }
func script_space() scaled { return dimen_par(script_space_code) }
func pre_display_size() scaled { return dimen_par(pre_display_size_code) }
func display_width() scaled { return dimen_par(display_width_code) }
func display_indent() scaled { return dimen_par(display_indent_code) }
func overfull_rule() scaled { return dimen_par(overfull_rule_code) }
func hang_indent() scaled { return dimen_par(hang_indent_code) }
func h_offset() scaled { return dimen_par(h_offset_code) }
func v_offset() scaled { return dimen_par(v_offset_code) }
func emergency_stretch() scaled { return dimen_par(emergency_stretch_code) }
func set_vfuzz(v scaled)         { set_dimen_par(vfuzz_code, v) }
func set_overfull_rule(v scaled) { set_dimen_par(overfull_rule_code, v) }

@ \dg 다음 프로시저는 치수 매개변수의 기호 이름을 찍는다. 원본에서는 앞 절들과 같은 절에 있다.

@<함수들@>=
func print_length_param(n int32) {
	switch n {
	case par_indent_code: print_esc("parindent")
	case math_surround_code: print_esc("mathsurround")
	case line_skip_limit_code: print_esc("lineskiplimit")
	case hsize_code: print_esc("hsize")
	case vsize_code: print_esc("vsize")
	case max_depth_code: print_esc("maxdepth")
	case split_max_depth_code: print_esc("splitmaxdepth")
	case box_max_depth_code: print_esc("boxmaxdepth")
	case hfuzz_code: print_esc("hfuzz")
	case vfuzz_code: print_esc("vfuzz")
	case delimiter_shortfall_code: print_esc("delimitershortfall")
	case null_delimiter_space_code: print_esc("nulldelimiterspace")
	case script_space_code: print_esc("scriptspace")
	case pre_display_size_code: print_esc("predisplaysize")
	case display_width_code: print_esc("displaywidth")
	case display_indent_code: print_esc("displayindent")
	case overfull_rule_code: print_esc("overfullrule")
	case hang_indent_code: print_esc("hangindent")
	case h_offset_code: print_esc("hoffset")
	case v_offset_code: print_esc("voffset")
	case emergency_stretch_code: print_esc("emergencystretch")
	default: print("[unknown dimen parameter!]")
	}
}

@ @<\TeX의 원시 명령을...@>=
primitive("parindent", assign_dimen, dimen_base+par_indent_code)
@!@:par_indent_}{\.{\\parindent} primitive@>
primitive("mathsurround", assign_dimen, dimen_base+math_surround_code)
@!@:math_surround_}{\.{\\mathsurround} primitive@>
primitive("lineskiplimit", assign_dimen, dimen_base+line_skip_limit_code)
@!@:line_skip_limit_}{\.{\\lineskiplimit} primitive@>
primitive("hsize", assign_dimen, dimen_base+hsize_code)
@!@:hsize_}{\.{\\hsize} primitive@>
primitive("vsize", assign_dimen, dimen_base+vsize_code)
@!@:vsize_}{\.{\\vsize} primitive@>
primitive("maxdepth", assign_dimen, dimen_base+max_depth_code)
@!@:max_depth_}{\.{\\maxdepth} primitive@>
primitive("splitmaxdepth", assign_dimen, dimen_base+split_max_depth_code)
@!@:split_max_depth_}{\.{\\splitmaxdepth} primitive@>
primitive("boxmaxdepth", assign_dimen, dimen_base+box_max_depth_code)
@!@:box_max_depth_}{\.{\\boxmaxdepth} primitive@>
primitive("hfuzz", assign_dimen, dimen_base+hfuzz_code)
@!@:hfuzz_}{\.{\\hfuzz} primitive@>
primitive("vfuzz", assign_dimen, dimen_base+vfuzz_code)
@!@:vfuzz_}{\.{\\vfuzz} primitive@>
primitive("delimitershortfall", assign_dimen, dimen_base+delimiter_shortfall_code)
@!@:delimiter_shortfall_}{\.{\\delimitershortfall} primitive@>
primitive("nulldelimiterspace", assign_dimen, dimen_base+null_delimiter_space_code)
@!@:null_delimiter_space_}{\.{\\nulldelimiterspace} primitive@>
primitive("scriptspace", assign_dimen, dimen_base+script_space_code)
@!@:script_space_}{\.{\\scriptspace} primitive@>
primitive("predisplaysize", assign_dimen, dimen_base+pre_display_size_code)
@!@:pre_display_size_}{\.{\\predisplaysize} primitive@>
primitive("displaywidth", assign_dimen, dimen_base+display_width_code)
@!@:display_width_}{\.{\\displaywidth} primitive@>
primitive("displayindent", assign_dimen, dimen_base+display_indent_code)
@!@:display_indent_}{\.{\\displayindent} primitive@>
primitive("overfullrule", assign_dimen, dimen_base+overfull_rule_code)
@!@:overfull_rule_}{\.{\\overfullrule} primitive@>
primitive("hangindent", assign_dimen, dimen_base+hang_indent_code)
@!@:hang_indent_}{\.{\\hangindent} primitive@>
primitive("hoffset", assign_dimen, dimen_base+h_offset_code)
@!@:h_offset_}{\.{\\hoffset} primitive@>
primitive("voffset", assign_dimen, dimen_base+v_offset_code)
@!@:v_offset_}{\.{\\voffset} primitive@>
primitive("emergencystretch", assign_dimen, dimen_base+emergency_stretch_code)
@!@:emergency_stretch_}{\.{\\emergencystretch} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case assign_dimen:
	if chr_code < scaled_base {
		print_length_param(chr_code - dimen_base)
	} else {
		print_esc("dimen")
		print_int(chr_code - scaled_base)
	}

@ @<표의 항목들을 초기화한다...@>=
for k = dimen_base; k <= eqtb_size; k++ {
	eqtb[k].sc = 0
}

@ @<등가물 |n|을 보인다, 영역 6@>=
if n < scaled_base {
	print_length_param(n - dimen_base)
} else {
	print_esc("dimen")
	print_int(n - scaled_base)
}
print_char('=')
print_scaled(eqtb[n].sc)
print("pt")

@ 다음은 |eqtb[n]|의 내용을 기호로 보여 주는 프로시저다.

@<함수들@>=
@<|print_cmd_chr|라는 프로시저를 선언한다@>
func show_eqtb(n pointer) {
	if n < active_base {
		print_char('?') // 이런 일은 일어날 수 없다
	} else if n < glue_base {
		@<등가물 |n|을 보인다, 영역 1이나 2@>
	} else if n < local_base {
		@<등가물 |n|을 보인다, 영역 3@>
	} else if n < int_base {
		@<등가물 |n|을 보인다, 영역 4@>
	} else if n < dimen_base {
		@<등가물 |n|을 보인다, 영역 5@>
	} else if n <= eqtb_size {
		@<등가물 |n|을 보인다, 영역 6@>
	} else {
		print_char('?') // 이것도 일어날 수 없다
	}
}

@ 표 |eqtb|의 마지막 두 영역에는 세 필드 |eq_level|, |eq_type|, |equiv| 대신 온 낱말 값이 들어 있다.
필드 |eq_type|은 필요 없지만 \TeX은 |eq_level| 정보를 |xeq_level|이라는 다른 배열에 저장해야 한다.

보충: 원본의 |xeq_level|은 첨자가 |int_base|에서 시작한다. \GO/ 배열은 0에서 시작하므로 여기서는
|eqtb_size+1|개를 잡고 |int_base|보다 작은 칸은 쓰지 않는다. 표 |eqtb|도 마찬가지로 칸 0을 쓰지 않는다.

@<전역 변수@>=
var @!eqtb [eqtb_size + 1]memory_word
var @!xeq_level [eqtb_size + 1]quarterword

@ @<핵심 변수들의...@>=
for k = int_base; k <= eqtb_size; k++ {
	xeq_level[k] = level_one
}

@ 디버깅 루틴 |search_mem|이 주어진 값을 가진 포인터를 찾을 때, |eqtb|에서는 영역 1부터~3까지와
영역~4의 첫 부분에만 관심이 있다.

@<|eqtb|에서 |p|와 같은...@>=
for q = active_base; q <= box_base+255; q++ {
	if equiv(q) == p {
		print_nl("EQUIV(")
		print_int(q)
		print_char(')')
	}
}

@* 해시 표.
제어 시퀀스는 ``합쳐지는 목록''(coalescing lists) 방법이라는 꽤 표준적인 해시 표 알고리즘으로 저장하고
꺼낸다({\sl The Art of Computer Programming}의 알고리즘 6.4C 참조). 제어 시퀀스는 한번 표에 들어가면
결코 지워지지 않는다. 명령 \.{\\gdef}가 얽힌 복잡한 상황에서는 그룹이 끝날 때 제어 시퀀스를 지우는 것이
실수가 될 수 있는데, 그것을 막으려면 복잡한 참조 횟수 장치를 도입해야 하기 때문이다.

제어 시퀀스 식별자를 이루는 실제 글자들은 다른 모든 문자열과 함께 배열 |str_pool|에 저장된다. 보조
배열 |hash|는 낱말마다 하프워드 필드가 둘 있는 항목들로 이루어진다. 그 첫째인 |next(p)|는 |p|에
해당하는 식별자와 같은 합쳐진 목록에 속하는 다음 식별자를 가리키고, 다른 하나인 |text(p)|는 |p|의
식별자의 |str_start| 항목을 가리킨다. 해시 표의 위치~|p|가 비어 있으면 |text(p)=0|이다. 위치 |p|가
비어 있거나 합쳐진 해시 목록의 끝이면 |next(p)=0|이다. 보조 포인터 변수 |hash_used|는 |p>=hash_used|인
모든 위치가 비어 있지 않도록 유지된다. 전역 변수 |cs_count|는 통계를 모을 때 여러 글자짜리 제어
시퀀스가 몇 개 정의되었는지 알려 준다.

전역 불 변수 |no_new_control_sequence|는 새 해시 표 항목이 금지된 동안 |true|로 놓인다.

보충: 원본의 |hash|는 첨자가 |hash_base|에서 시작한다. 여기서는 0부터 잡고 앞쪽 칸은 쓰지 않는다.

@<전역 변수@>=
func next(p pointer) halfword       { return hash[p].lh } // 합쳐진 목록의 연결
func set_next(p pointer, v halfword) { hash[p].lh = v }
func text(p pointer) str_number      { return hash[p].rh } // 제어 시퀀스 이름의 문자열 번호
func set_text(p pointer, v str_number) { hash[p].rh = v }
func hash_is_full() bool             { return hash_used == hash_base } // 모든 위치가 찼는지 검사한다
func font_id_text(f int32) str_number { return text(font_id_base + f) } // 얼어 있는 글꼴 식별자의 이름
func set_font_id_text(f int32, v str_number) { set_text(font_id_base+f, v) }

var @!hash [undefined_control_sequence]two_halves // 해시 표
var @!hash_used pointer // |hash|의 할당 포인터
var @!no_new_control_sequence bool // 새 식별자가 허용되나?
var @!cs_count int32 // 알려진 식별자의 총수

@ @<핵심 변수들의...@>=
no_new_control_sequence = true // 새 식별자는 보통 금지된다
set_next(hash_base, 0)
set_text(hash_base, 0)
for k = hash_base + 1; k <= undefined_control_sequence-1; k++ {
	hash[k] = hash[hash_base]
}

@ @<표의 항목들을 초기화한다...@>=
hash_used = frozen_control_sequence // 아무것도 쓰이지 않았다
cs_count = 0
set_eq_type(frozen_dont_expand, dont_expand)
set_text(frozen_dont_expand, str("notexpanded:"))
@.notexpanded:@>

@ 다음은 |buffer[j..(j+l-1)]|에 나타나는 길이 |l>1|인 문자열과 맞는 식별자를 해시 표에서 찾는
서브루틴이다. 식별자를 찾으면 해당하는 해시 표 주소를 돌려준다. 찾지 못하면, 전역 변수
|no_new_control_sequence|가 |true|일 때는 가짜 주소 |undefined_control_sequence|를 돌려준다. 그렇지
않으면 식별자를 해시 표에 넣고 그 위치를 돌려준다.

보충: 합쳐지는 목록 방법의 요점은 이렇다. 해시 값 $h$에 해당하는 위치에서 찾기 시작해서 |next|
연결을 따라간다. 찾지 못하면 표의 높은 쪽 끝에서부터 아래로 빈칸을 찾아(|hash_used|를 줄여 가며)
거기에 새 항목을 넣고, 목록의 끝에 이어 붙인다. 서로 다른 해시 값의 목록들이 이렇게 한데 합쳐질 수
있으므로 ``합쳐지는'' 목록이라고 한다. 따로 넘침 영역을 두지 않고 표 하나로 해결하는 점이 좋다.

@<함수들@>=
func id_lookup(j, l int32) pointer { // 해시 표를 찾는다
	var h int32 // 해시 코드
	var d int32 // 아직 덜 만든 현재 문자열의 문자 수
	var p pointer // 배열 |hash|의 첨자
	var k pointer // 배열 |buffer|의 첨자
	@<해시 코드 |h|를 계산한다@>
	p = h + hash_base // 여기서 찾기 시작한다; |0<=h<hash_prime|임에 주목하라
	for {
		if text(p) > 0 {
			if length(text(p)) == l {
				if str_eq_buf(text(p), j) {
					goto found
				}
			}
		}
		if next(p) == 0 {
			if no_new_control_sequence {
				p = undefined_control_sequence
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

@ @<|p| 뒤에 새 제어...@>=
if text(p) > 0 {
	for {
		if hash_is_full() {
			overflow("hash size", hash_size)
		}
@:TeX capacity exceeded hash size}{\quad hash size@>
		hash_used--
		if text(hash_used) == 0 {
			break
		}
	} // |hash|에서 빈 위치를 찾는다
	set_next(p, hash_used)
	p = hash_used
}
str_room(l)
d = cur_length()
for pool_ptr > str_start[str_ptr] {
	pool_ptr--
	str_pool[pool_ptr+l] = str_pool[pool_ptr]
} // 다른 문자열을 위한 자리를 만들려고 현재 문자열을 위로 옮긴다
for k = j; k <= j+l-1; k++ {
	append_char(buffer[k])
}
set_text(p, make_string())
pool_ptr = pool_ptr + d
if stat {
	cs_count++
}

@ 상수 |hash_prime|의 값은 |hash_size|의 대략 85\pct!여야 하고, 소수여야 한다. 해싱 이론에 따르면 찾기가
성공할 때 평균 두 번보다 적게 표를 들여다보리라고 기대할 수 있다. [J.~S. Vitter, {\sl Journal of the
ACM\/ \bf30} (1983), 231--258쪽을 보라.]
@^Vitter, Jeffrey Scott@>

@<해시 코드 |h|를...@>=
h = buffer[j]
for k = j + 1; k <= j+l-1; k++ {
	h = h + h + buffer[k]
	for h >= hash_prime {
		h = h - hash_prime
	}
}

@ 한 문자짜리 제어 시퀀스는 해시 표에서 찾을 필요가 없다. 문자 코드 자체를 직접 주소로 쓸 수 있기
때문이다. 프로시저 |print_cs|는 |eqtb| 안의 주소를 가리키는 포인터를 받아서 제어 시퀀스의 이름을
찍는다. 이름이 글자가 아닌 문자 하나이거나 능동 문자인 경우가 아니면 이름 뒤에 공백을 하나 찍는다. 이
프로시저는 엉뚱한 자료로 불릴 수도 있으므로 ``아주 튼튼하다.'' 낱낱의 문자는 찍을 수 없는 것일
수도 있으므로 |print|를 써서 하나씩 찍어야 한다.

@<기본 인쇄...@>=
func print_cs(p int32) { // 제어 시퀀스라고 여겨지는 것을 찍는다
	if p < hash_base { // 한 문자
		if p >= single_base {
			if p == null_cs {
				print_esc("csname")
				print_esc("endcsname")
				print_char(' ')
			} else {
				print_esc(p - single_base)
				if cat_code(p-single_base) == letter {
					print_char(' ')
				}
			}
		} else if p < active_base {
			print_esc("IMPOSSIBLE.")
@.IMPOSSIBLE@>
		} else {
			print(p - active_base)
		}
	} else if p >= undefined_control_sequence {
		print_esc("IMPOSSIBLE.")
	} else if text(p) < 0 || text(p) >= str_ptr {
		print_esc("NONEXISTENT.")
@.NONEXISTENT@>
	} else {
		print_esc(text(p))
		print_char(' ')
	}
}

@ 다음은 비슷한 프로시저다. 오류 검사를 하지 않으며, 제어 시퀀스 뒤에 공백을 결코 찍지 않는다.

@<기본 인쇄...@>=
func sprint_cs(p pointer) { // 제어 시퀀스를 찍는다
	if p < hash_base {
		if p < single_base {
			print(p - active_base)
		} else if p < null_cs {
			print_esc(p - single_base)
		} else {
			print_esc("csname")
			print_esc("endcsname")
		}
	} else {
		print_esc(text(p))
	}
}

@ \TeX의 ``원시'' 제어 시퀀스들을 그 명령 코드(|eq_type|이 된다)와 피연산자(|equiv|가 된다)와 함께
해시 표에 넣어야 한다. 프로시저 |primitive|가 이 일을 하는데, \TeX\ 사용자는 아무도 할 수 없는 방식으로
한다. 프로시저 |primitive|가 일을 마치면 전역 값 |cur_val|에 새 |eqtb| 포인터가 들어 있다.

보충: 원본의 |s|는 풀 문자열의 번호다. 그 값이 255보다 크면 원본은 그 문자열을 버퍼로 옮겨 |id_lookup|을
부르는데, |id_lookup|은 같은 문자열을 새로 하나 만든다. 그래서 원본은 그것을 |flush_string|으로
버리고 원래의 |s|를 |text(cur_val)|에 넣는다. 이 번역에서 |s|는 풀에 없는 \GO/ 문자열이므로,
|id_lookup|이 만든 문자열을 그대로 쓰면 된다. 원본의 지역 변수 |k|는 필요 없다.

@<함수들@>=
func primitive(s string, c quarterword, o halfword) {
	var j small_number // |buffer|의 첨자
	var l small_number // 문자열의 길이
	if len(s) == 1 {
		cur_val = ASCII_code(s[0]) + single_base
	} else {
		l = int32(len(s)) // |s|를 (비어 있는) |buffer|로 옮길 것이다
		for j = 0; j <= l-1; j++ {
			buffer[j] = xord[s[j]]
		}
		cur_val = id_lookup(0, l) // |no_new_control_sequence|는 |false|다
	}
	set_eq_level(cur_val, level_one)
	set_eq_type(cur_val, c)
	set_equiv(cur_val, o)
}

@ \TeX의 원시 명령 가운데 많은 것은 |equiv|가 필요 없다. 형 |eq_type|만으로 알아볼 수 있기 때문이다. 이런
원시 명령들은 다음과 같이 해시 표에 싣는다.

@<\TeX의 원시 명령을...@>=
primitive(" ", ex_space, 0)
@!@:Single-character primitives /}{\quad\.{\\\ }@>
primitive("/", ital_corr, 0)
@!@:Single-character primitives /}{\quad\.{\\/}@>
primitive("accent", accent, 0)
@!@:accent_}{\.{\\accent} primitive@>
primitive("advance", advance, 0)
@!@:advance_}{\.{\\advance} primitive@>
primitive("afterassignment", after_assignment, 0)
@!@:after_assignment_}{\.{\\afterassignment} primitive@>
primitive("aftergroup", after_group, 0)
@!@:after_group_}{\.{\\aftergroup} primitive@>
primitive("begingroup", begin_group, 0)
@!@:begin_group_}{\.{\\begingroup} primitive@>
primitive("char", char_num, 0)
@!@:char_}{\.{\\char} primitive@>
primitive("csname", cs_name, 0)
@!@:cs_name_}{\.{\\csname} primitive@>
primitive("delimiter", delim_num, 0)
@!@:delimiter_}{\.{\\delimiter} primitive@>
primitive("divide", divide, 0)
@!@:divide_}{\.{\\divide} primitive@>
primitive("endcsname", end_cs_name, 0)
@!@:end_cs_name_}{\.{\\endcsname} primitive@>
primitive("endgroup", end_group, 0)
@!@:end_group_}{\.{\\endgroup} primitive@>
set_text(frozen_end_group, str("endgroup"))
eqtb[frozen_end_group] = eqtb[cur_val]
primitive("expandafter", expand_after, 0)
@!@:expand_after_}{\.{\\expandafter} primitive@>
primitive("font", def_font, 0)
@!@:font_}{\.{\\font} primitive@>
primitive("fontdimen", assign_font_dimen, 0)
@!@:font_dimen_}{\.{\\fontdimen} primitive@>
primitive("halign", halign, 0)
@!@:halign_}{\.{\\halign} primitive@>
primitive("hrule", hrule, 0)
@!@:hrule_}{\.{\\hrule} primitive@>
primitive("ignorespaces", ignore_spaces, 0)
@!@:ignore_spaces_}{\.{\\ignorespaces} primitive@>
primitive("insert", insert, 0)
@!@:insert_}{\.{\\insert} primitive@>
primitive("mark", mark, 0)
@!@:mark_}{\.{\\mark} primitive@>
primitive("mathaccent", math_accent, 0)
@!@:math_accent_}{\.{\\mathaccent} primitive@>
primitive("mathchar", math_char_num, 0)
@!@:math_char_}{\.{\\mathchar} primitive@>
primitive("mathchoice", math_choice, 0)
@!@:math_choice_}{\.{\\mathchoice} primitive@>
primitive("multiply", multiply, 0)
@!@:multiply_}{\.{\\multiply} primitive@>

@ \dg 앞 절에 이어 원시 명령들을 싣는다.

@<\TeX의 원시 명령을...@>=
primitive("noalign", no_align, 0)
@!@:no_align_}{\.{\\noalign} primitive@>
primitive("noboundary", no_boundary, 0)
@!@:no_boundary_}{\.{\\noboundary} primitive@>
primitive("noexpand", no_expand, 0)
@!@:no_expand_}{\.{\\noexpand} primitive@>
primitive("nonscript", non_script, 0)
@!@:non_script_}{\.{\\nonscript} primitive@>
primitive("omit", omit, 0)
@!@:omit_}{\.{\\omit} primitive@>
primitive("parshape", set_shape, 0)
@!@:par_shape_}{\.{\\parshape} primitive@>
primitive("penalty", break_penalty, 0)
@!@:penalty_}{\.{\\penalty} primitive@>
primitive("prevgraf", set_prev_graf, 0)
@!@:prev_graf_}{\.{\\prevgraf} primitive@>
primitive("radical", radical, 0)
@!@:radical_}{\.{\\radical} primitive@>
primitive("read", read_to_cs, 0)
@!@:read_}{\.{\\read} primitive@>
primitive("relax", relax, 256) // |scan_file_name| 참조
@!@:relax_}{\.{\\relax} primitive@>
set_text(frozen_relax, str("relax"))
eqtb[frozen_relax] = eqtb[cur_val]
primitive("setbox", set_box, 0)
@!@:set_box_}{\.{\\setbox} primitive@>
primitive("the", the, 0)
@!@:the_}{\.{\\the} primitive@>
primitive("toks", toks_register, 0)
@!@:toks_}{\.{\\toks} primitive@>
primitive("vadjust", vadjust, 0)
@!@:vadjust_}{\.{\\vadjust} primitive@>
primitive("valign", valign, 0)
@!@:valign_}{\.{\\valign} primitive@>
primitive("vcenter", vcenter, 0)
@!@:vcenter_}{\.{\\vcenter} primitive@>
primitive("vrule", vrule, 0)
@!@:vrule_}{\.{\\vrule} primitive@>

@ 원시 명령마다 그에 해당하는 역이 있어서, |eqtb|의 알쏭달쏭한 수 내용을 기호 꼴로 보일 수 있다. 그래서
이 프로그램에서 |primitive|를 부르는 곳마다 아래의 루틴 |print_cmd_chr|의 일부를 이루는 간단한 코드가
따라온다.

@<원시 명령의 이름을 찍는...@>=
case accent: print_esc("accent")
case advance: print_esc("advance")
case after_assignment: print_esc("afterassignment")
case after_group: print_esc("aftergroup")
case assign_font_dimen: print_esc("fontdimen")
case begin_group: print_esc("begingroup")
case break_penalty: print_esc("penalty")
case char_num: print_esc("char")
case cs_name: print_esc("csname")
case def_font: print_esc("font")
case delim_num: print_esc("delimiter")
case divide: print_esc("divide")
case end_cs_name: print_esc("endcsname")
case end_group: print_esc("endgroup")
case ex_space: print_esc(" ")
case expand_after: print_esc("expandafter")
case halign: print_esc("halign")
case hrule: print_esc("hrule")
case ignore_spaces: print_esc("ignorespaces")
case insert: print_esc("insert")
case ital_corr: print_esc("/")
case mark: print_esc("mark")
case math_accent: print_esc("mathaccent")
case math_char_num: print_esc("mathchar")
case math_choice: print_esc("mathchoice")
case multiply: print_esc("multiply")

@ \dg 앞 절에 이어지는 경우들이다.

@<원시 명령의 이름을 찍는...@>=
case no_align: print_esc("noalign")
case no_boundary: print_esc("noboundary")
case no_expand: print_esc("noexpand")
case non_script: print_esc("nonscript")
case omit: print_esc("omit")
case radical: print_esc("radical")
case read_to_cs: print_esc("read")
case relax: print_esc("relax")
case set_box: print_esc("setbox")
case set_prev_graf: print_esc("prevgraf")
case set_shape: print_esc("parshape")
case the: print_esc("the")
case toks_register: print_esc("toks")
case vadjust: print_esc("vadjust")
case valign: print_esc("valign")
case vcenter: print_esc("vcenter")
case vrule: print_esc("vrule")

@ 다른 원시 명령들은 나중에, 그것들의 |eq_type|과 |equiv| 값이 더 뜻있게 되는 곳에서 다룰 것이다.
이를테면 수식 모드의 원시 명령들은 수식을 다루는 루틴들을 살펴볼 때 싣는다. 각 원시 명령이 어디서
다루어졌는지는 끝의 찾아보기를 보면 쉽게 알 수 있다. 이를테면 |"radical"|이 |eqtb|에 들어간 절은
`\.{\\radical} primitive' 항목에 적혀 있다. (`\.{\\/}'처럼 알파벳이 아닌 문자 하나로 된 원시 명령은
`Single-character primitives' 항목에 적혀 있다.)
@!@^Single-character primitives@>

그러는 사이에, 해시 표를 정의하기 전에는 할 수 없었던 일 하나를 여기서 마저 해 두기 좋다.

@<|font(p)|의 글꼴 식별자를...@>=
print_esc(font_id_text(font(p)))

@* 등가물 저장과 복원.
\TeX의 `$\.{\char'173}\ldots\.{\char'175}$' 그룹이 주는 중첩 구조 때문에, 바깥 그룹에서 유효한 |eqtb|
항목이 중괄호 안에서 덮어쓰이면 그것을 저장했다가 나중에 되살려야 한다. 그래서 새 |eqtb| 값을 대입할
때 프로그램은 앞의 항목이 바깥 수준에 속하는지 검사한다. 그렇다면 새 값이 |eqtb|에 들어가기 바로 전에
옛 값을 |save_stack|에 놓는다. 그룹 수준이 끝날 때, 곧 오른쪽 중괄호를 알아챌 때 |save_stack|을 써서
바깥 값들을 되살리고 안쪽 값들은 없앤다.

스택 |save_stack|의 항목은 형이 |memory_word|다. 이 스택의 맨 위 항목은 |save_stack[p]|이고 여기서
|p=save_ptr-1|이다. 이 항목에는 |save_type|, |save_level|, |save_index|라는 세 필드가 있고, 네 가지
가운데 한 가지로 해석된다.

\yskip\hangg 1) |save_type(p)=restore_old_value|면 |save_index(p)|는 |eqtb|의 위치인데, 그 현재 값은
현재 그룹이 끝날 때 없애고 |save_stack[p-1]|로 바꾸어야 한다. 또한 |save_index(p)>=int_base|면
|save_level(p)|이 |xeq_level|의 해당 항목을 바꾸어야 한다.

\yskip\hangg 2) |save_type(p)=restore_zero|면 |save_index(p)|는 |eqtb|의 위치인데, 그 현재 값은 현재
그룹이 끝날 때 없애고 |eqtb[undefined_control_sequence]|의 값으로 바꾸어야 한다.

\yskip\hangg 3) |save_type(p)=insert_token|이면 |save_index(p)|는 현재 그룹이 끝날 때 \TeX의 입력에
끼워 넣어야 할 토큰이다.

\yskip\hangg 4) |save_type(p)=level_boundary|면 |save_level(p)|은 우리가 앞서 어떤 종류의 그룹에
있었는지 설명하는 코드이고, |save_index(p)|는 그 그룹의 항목들 맨 아래에 있는 수준 경계 낱말을
가리킨다.

@<정의@>=
func save_type(p int32) quarterword        { return save_stack[p].hh.b0 } // |save_stack| 항목을 분류한다
func set_save_type(p int32, v quarterword) { save_stack[p].hh.b0 = v }
func save_level(p int32) quarterword       { return save_stack[p].hh.b1 } // 영역 5와 6을 위해 저장한 수준, 또는 그룹 코드
func set_save_level(p int32, v quarterword) { save_stack[p].hh.b1 = v }
func save_index(p int32) halfword          { return save_stack[p].hh.rh } // |eqtb| 위치나 토큰이나 |save_stack| 위치
func set_save_index(p int32, v halfword)   { save_stack[p].hh.rh = v }

const (
	@!restore_old_value = 0 // 값을 나중에 되살려야 할 때의 |save_type|
	@!restore_zero = 1 // 정의되지 않은 항목을 되살려야 할 때의 |save_type|
	@!insert_token = 2 // 토큰을 나중에 쓰려고 저장할 때의 |save_type|
	@!level_boundary = 3 // 그룹의 시작에 해당하는 |save_type|
)

@ 다음은 여러 종류의 그룹을 구별하는 데 쓰는 그룹 코드들이다. 이 코드들 덕분에 \TeX은 그룹이 끝날 때
어떤 특별한 동작을 해야 하는지(해야 한다면) 결정할 수 있다.
\def\grp{\.{\char'173...\char'175}}

어떤 그룹은 오른쪽 중괄호로 끝나지 않게 되어 있다. 이를테면 수식을 시작하는 `\.\$'는
|math_shift_group|을 시작하는데, 이것은 짝이 맞는 `\.\$'로 끝나야 한다. 마찬가지로 \.{\\left}로
시작하는 그룹은 \.{\\right}로 끝나야 하고, \.{\\begingroup}으로 시작하는 그룹은 \.{\\endgroup}으로
끝나야 한다.

@<바깥 블록의 형@>=
const (
	@!bottom_level = 0 // 바깥 세계의 그룹 코드
	@!simple_group = 1 // 지역 구조만을 위한 그룹 코드
	@!hbox_group = 2 // `\.{\\hbox}\grp'의 코드
	@!adjusted_hbox_group = 3 // 세로 모드에서 `\.{\\hbox}\grp'의 코드
	@!vbox_group = 4 // `\.{\\vbox}\grp'의 코드
	@!vtop_group = 5 // `\.{\\vtop}\grp'의 코드
	@!align_group = 6 // `\.{\\halign}\grp', `\.{\\valign}\grp'의 코드
	@!no_align_group = 7 // `\.{\\noalign}\grp'의 코드
	@!output_group = 8 // 출력 루틴의 코드
	@!math_group = 9 // 이를테면 `\.{\char'136}\grp'의 코드
	@!disc_group = 10 // `\.{\\discretionary}\grp\grp\grp'의 코드
	@!insert_group = 11 // `\.{\\insert}\grp', `\.{\\vadjust}\grp'의 코드
	@!vcenter_group = 12 // `\.{\\vcenter}\grp'의 코드
	@!math_choice_group = 13 // `\.{\\mathchoice}\grp\grp\grp\grp'의 코드
	@!semi_simple_group = 14 // `\.{\\begingroup...\\endgroup}'의 코드
	@!math_shift_group = 15 // `\.{\$...\$}'의 코드
	@!math_left_group = 16 // `\.{\\left...\\right}'의 코드
	@!max_group_code = 16
)

type @!group_code = int32 // 수준 경계의 |save_level|; |0..max_group_code|

@ 전역 변수 |cur_group|은 지금 어떤 종류의 그룹 안에 있는지 추적한다. 또 하나의 전역 변수
|cur_boundary|는 맨 위의 |level_boundary| 낱말을 가리킨다. 그리고 |cur_level|은 현재의 중첩 깊이다.
루틴들은 |save_stack|이나 |eqtb|의 어떤 항목도 수준이 |cur_level|보다 크지 않다는 조건을 지키도록
설계되었다.

@ @<전역 변수@>=
var @!save_stack [save_size + 1]memory_word
var @!save_ptr int32 // |save_stack|에서 쓰이지 않는 첫 항목; |0..save_size|
var @!max_save_stack int32 // 저장 스택의 최대 사용량
var @!cur_level quarterword // 그룹의 현재 중첩 수준
var @!cur_group group_code // 현재 그룹의 종류
var @!cur_boundary int32 // 현재 수준이 시작하는 곳; |0..save_size|

@ 이쯤에서 독자는 매개변수 이름의 긴 목록 바로 앞에서 했던 |eqtb|의 소개를 다시 훑어보는 것이 좋겠다.
프로그램의 ``바깥 수준''은 |level_one|이라는 것을 떠올리자. 정의되지 않은 제어 시퀀스는 |level_zero|에서
``정의되었다''고 가정하기 때문이다.

@<핵심 변수들의...@>=
save_ptr = 0
cur_level = level_one
cur_group = bottom_level
cur_boundary = 0
max_save_stack = 0

@ 다음 매크로는 |save_stack|에 항목을 여섯 개까지 더 넣을 자리가 있는지 검사하는 데 쓴다. 이렇게
보수적으로 검사하면 몇 군데에서만 넘침을 검사해도 된다.

@<정의@>=
func check_full_save_stack() {
	if save_ptr > max_save_stack {
		max_save_stack = save_ptr
		if max_save_stack > save_size-6 {
			overflow("save size", save_size)
		}
@:TeX capacity exceeded save size}{\quad save size@>
	}
}

@ 프로시저 |new_save_level|은 그룹이 시작할 때 불린다. 인자는 `|hbox_group|' 같은 그룹 식별 코드다. 이
루틴을 부른 뒤에는 |save_stack|에 항목을 다섯 개 더 넣어도 안전하다.

어떤 경우에는 정수 값 항목들을 |level_boundary| 낱말 바로 아래 |save_stack|에 놓는다. 그룹이 끝났을 때
``튀어나와야'' 할 정보를 두기에 편리한 곳이기 때문이다. 이를테면 `\.{\\hbox to 100pt}\grp'를 처리할 때
100pt라는 치수를 |new_save_level|을 부르기 바로 전에 |save_stack|에 저장한다.

표기 |saved(k)|는 저장 스택의 위치 |save_ptr+k|에 나타나는 정수 항목을 나타낸다.

@<함수들@>=
func saved(k int32) int32        { return save_stack[save_ptr+k].sc }
func set_saved(k int32, v int32) { save_stack[save_ptr+k].sc = v }

func new_save_level(c group_code) { // 새 그룹 수준을 시작한다
	check_full_save_stack()
	set_save_type(save_ptr, level_boundary)
	set_save_level(save_ptr, cur_group)
	set_save_index(save_ptr, cur_boundary)
	if cur_level == max_quarterword {
		overflow("grouping levels",
@:TeX capacity exceeded grouping levels}{\quad grouping levels@>
			max_quarterword-min_quarterword)
	} // |(cur_level+1)|이 너무 커서 |eqtb|에 저장할 수 없으면 그만둔다
	cur_boundary = save_ptr
	cur_level++
	save_ptr++
	cur_group = c
}

@ 표 |eqtb|의 항목을 바꾸기 바로 전에 다음 프로시저를 불러서 다른 자료 구조들을 제대로 갱신해야 한다.
배열 |mem|의 참조 횟수에는 |save_stack| 안에서의 참조도 들어 있으므로 이 횟수들을 조심스럽게 다루어야
한다는 점을 명심해야 한다.
@^reference counts@>

@<함수들@>=
func eq_destroy(w memory_word) { // |w|를 잊을 준비를 한다
	var q pointer // |w|의 |equiv| 필드
	switch eq_type_field(w) {
	case call, long_call, outer_call, long_outer_call:
		delete_token_ref(equiv_field(w))
	case glue_ref:
		delete_glue_ref(equiv_field(w))
	case shape_ref:
		q = equiv_field(w) // \.{\\parshape} 덩어리를 해제해야 한다
		if q != null {
			free_node(q, info(q)+info(q)+1)
		} // 그런 덩어리는 |n=info(q)|일 때 |2n+1|낱말 길이다
	case box_ref:
		flush_node_list(equiv_field(w))
	default:
		// 아무것도 하지 않는다
	}
}

@ 수준 |l|에서 정해진 |eqtb[p]|의 값을 저장하려면 다음 서브루틴을 쓸 수 있다.

@<함수들@>=
func eq_save(p pointer, l quarterword) { // |eqtb[p]|를 저장한다
	check_full_save_stack()
	if l == level_zero {
		set_save_type(save_ptr, restore_zero)
	} else {
		save_stack[save_ptr] = eqtb[p]
		save_ptr++
		set_save_type(save_ptr, restore_old_value)
	}
	set_save_level(save_ptr, l)
	set_save_index(save_ptr, p)
	save_ptr++
}

@ 프로시저 |eq_define|은 |eq_type|과 |equiv| 필드가 지정된 |eqtb| 항목을 정의하고, 알맞으면 앞의
값을 저장한다. 이 프로시저는 |eqtb|의 처음 네 영역에 있는 항목, 곧 |eq_type|과 |equiv| 필드가 있는
항목에만 쓰인다. 이 루틴을 부른 뒤에는, 부르기 전에 항목 네 개를 더 넣을 자리가 있었다면, |save_stack|에
항목을 네 개 더 넣어도 안전하다. 프로시저 |eq_save|가 필요한 검사를 하기 때문이다.

@<함수들@>=
func eq_define(p pointer, t quarterword, e halfword) { // |eqtb|의 새 자료
	if eq_level(p) == cur_level {
		eq_destroy(eqtb[p])
	} else if cur_level > level_one {
		eq_save(p, eq_level(p))
	}
	set_eq_level(p, cur_level)
	set_eq_type(p, t)
	set_equiv(p, e)
}

@ 표 |eqtb|의 나머지 (온 낱말) 위치를 위한 |eq_define|의 짝은 |eq_word_define|이라고 부른다. 모든 |p|에
대해 |xeq_level[p]>=level_one|이므로, 이 경우에는 `|restore_zero|'가 결코 쓰이지 않는다.

@<함수들@>=
func eq_word_define(p pointer, w int32) {
	if xeq_level[p] != cur_level {
		eq_save(p, xeq_level[p])
		xeq_level[p] = cur_level
	}
	eqtb[p].sc = w
}

@ 루틴 |eq_define|과 |eq_word_define|은 지역 정의를 처리한다. 전역 정의도 거의 같은 방법으로 하지만,
@^global definitions@>
옛 값을 저장할 필요가 없고 새 값은 |level_one|과 연결된다.

@<함수들@>=
func geq_define(p pointer, t quarterword, e halfword) { // 전역 |eq_define|
	eq_destroy(eqtb[p])
	set_eq_level(p, level_one)
	set_eq_type(p, t)
	set_equiv(p, e)
}

func geq_word_define(p pointer, w int32) { // 전역 |eq_word_define|
	eqtb[p].sc = w
	xeq_level[p] = level_one
}

@ 서브루틴 |save_for_after|는 보관할 토큰 하나를 스택에 넣는다.

@<함수들@>=
func save_for_after(t halfword) {
	if cur_level > level_one {
		check_full_save_stack()
		set_save_type(save_ptr, insert_token)
		set_save_level(save_ptr, level_zero)
		set_save_index(save_ptr, t)
		save_ptr++
	}
}

@ 루틴 |unsave|는 반대로 |save_stack|에서 항목들을 꺼낸다. 이 루틴은 한 수준이 끝날 때 복원을 맡는다.
맨 위 그룹에 속하는 모든 것이 저장 스택에서 치워진다.

@<함수들@>=
@<|restore_trace|라는 프로시저를 선언한다@>
func unsave() { // 저장 스택의 맨 위 수준을 꺼낸다
	var p pointer // 되살릴 위치
	var l quarterword // |eqtb|의 온 낱말 영역에 있다면 저장된 수준
	var t halfword // 저장된 |cur_tok|의 값
	if cur_level > level_one {
		cur_level--
		@<|save_stack|에서 맨 위 수준을 치운다@>
	} else {
		confusion("curlevel") // |cur_group=bottom_level|일 때는 |unsave|를 쓰지 않는다
	}
@:this can't happen curlevel}{\quad curlevel@>
}

@ @<|save_stack|에서 맨 위...@>=
for {
	save_ptr--
	if save_type(save_ptr) == level_boundary {
		goto done
	}
	p = save_index(save_ptr)
	if save_type(save_ptr) == insert_token {
		@<토큰 |p|를 \TeX의 입력에 끼워 넣는다@>
	} else {
		if save_type(save_ptr) == restore_old_value {
			l = save_level(save_ptr)
			save_ptr--
		} else {
			save_stack[save_ptr] = eqtb[undefined_control_sequence]
		}
		@<|eqtb[p]|가 전역 값이 아니면 |save_stack[save_ptr]|를 거기 넣는다@>
	}
}
done:
cur_group = save_level(save_ptr)
cur_boundary = save_index(save_ptr)

@ 전역 정의는 수준을 |level_one|으로 놓으므로 |unsave|가 되돌리지 않는다. 방금 끝난 그룹 안에서
@^global definitions@>
|eqtb[p]|의 전역 정의가 적어도 한 번 이루어졌다면, 그 가운데 마지막 정의가 살아남게 된다.

@<|eqtb[p]|가 전역 값이...@>=
if p < int_base {
	if eq_level(p) == level_one {
		eq_destroy(save_stack[save_ptr]) // 저장된 값을 없앤다
		if stat {
			if tracing_restores() > 0 {
				restore_trace(p, "retaining")
			}
		}
	} else {
		eq_destroy(eqtb[p]) // 현재 값을 없앤다
		eqtb[p] = save_stack[save_ptr] // 저장된 값을 되살린다
		if stat {
			if tracing_restores() > 0 {
				restore_trace(p, "restoring")
			}
		}
	}
} else if xeq_level[p] != level_one {
	eqtb[p] = save_stack[save_ptr]
	xeq_level[p] = l
	if stat {
		if tracing_restores() > 0 {
			restore_trace(p, "restoring")
		}
	}
} else {
	if stat {
		if tracing_restores() > 0 {
			restore_trace(p, "retaining")
		}
	}
}

@ @<|restore_trace|라는...@>=
func restore_trace(p pointer, s string) { // |eqtb[p]|를 방금 되살렸거나 그대로 두었다
	begin_diagnostic()
	print_char('{')
	print(s)
	print_char(' ')
	show_eqtb(p)
	print_char('}')
	end_diagnostic(false)
}

@ 메모리의 한 위치를 가리킬 만한 포인터를 찾을 때에는 저장 스택에서 기다리고 있을지 모르는 |eqtb|로부터의
참조도 찾아보면 도움이 된다. 물론 엉뚱한 포인터도 찾게 될지 모른다. 그러나 이 루틴은 디버깅할 때
도움을 주려는 것일 뿐이고, 그럴 때는 나중에 상관없는 것으로 드러나더라도 정보 부스러기 하나하나가
고마운 법이다.
@^dirty \PASCAL@>

@<|save_stack|에서 |p|를...@>=
if save_ptr > 0 {
	for q = 0; q <= save_ptr-1; q++ {
		if equiv_field(save_stack[q]) == p {
			print_nl("SAVE(")
			print_int(q)
			print_char(')')
		}
	}
}

@ 표 |eqtb|에 있는 매개변수의 대부분은 마음대로 바꿀 수 있지만, 예외가 하나 있다. 확대 배율은 한 \TeX\
작업 동안 서로 다른 두 값으로 쓰이면 안 된다. 한 번의 실행 전체에 확대 배율 하나가 적용되기 때문이다.
전역 변수 |mag_set|은 확대 배율을 특정 값으로 ``얼려야'' 할 때마다 현재의 확대 배율로 놓인다.

@<전역 변수@>=
var @!mag_set int32 // 0이 아니면 앞으로 이 확대 배율을 써야 한다

@ @<핵심 변수들의...@>=
mag_set = 0

@ 서브루틴 |prepare_mag|는 \TeX이 확대에 |mag|를 쓰고 싶을 때마다 불린다.

@<함수들@>=
func prepare_mag() {
	if mag_set > 0 && mag() != mag_set {
		print_err("Incompatible magnification (")
		print_int(mag())
@.Incompatible magnification@>
		print(");")
		print_nl(" the previous value will be retained")
		help2("I can handle only one magnification ratio per job. So I've",
			"reverted to the magnification you used earlier on this run.")
		int_error(mag_set)
		geq_word_define(int_base+mag_code, mag_set) // |mag:=mag_set|
	}
	if mag() <= 0 || mag() > 32768 {
		print_err("Illegal magnification has been changed to 1000")
@.Illegal magnification...@>
		help1("The magnification ratio must be between 1 and 32768.")
		int_error(mag())
		geq_word_define(int_base+mag_code, 1000)
	}
	mag_set = mag()
}

@* 토큰 목록.
\TeX의 토큰은 문자이거나 제어 시퀀스이고, 내부에서는 두 가지 방법 가운데 하나로 나타낸다.
@^token@>
(1)~{\mc ASCII} 코드 번호가 |c|이고 명령 코드가 |m|인 문자는 수 $2^8m+c$로 나타낸다. 명령 코드는 범위
|1<=m<=14|에 있다. (2)~|eqtb| 주소가 |p|인 제어 시퀀스는 수 |cs_token_flag+p|로 나타낸다. 여기서
|cs_token_flag=@t$2^{12}-1$@>|은 $2^8m+c$보다 크지만, |cs_token_flag+p< max_halfword|일 만큼 작다.
그러므로 토큰 하나는 하프워드에 넉넉히 들어간다.

토큰 |t|는 |t<left_brace_limit|일 때, 그리고 오직 그때에만 |left_brace| 명령을 나타내고,
|left_brace_limit<=t<right_brace_limit|일 때, 그리고 오직 그때에만 |right_brace| 명령을 나타내며,
|match_token<=t<=end_match_token|일 때, 그리고 오직 그때에만 |match|나 |end_match| 명령을 나타낸다.
다음 정의들은 이런 토큰 관련 상수들과 그 밖의 몇 가지를 다룬다.

@<정의@>=
const (
	@!cs_token_flag = 0o7777 // 제어 시퀀스를 나타내는 토큰에서 |eqtb| 위치에 더하는 양;
	// 256의 배수에서 1을 뺀 것
	@!left_brace_token = 0o0400 // $2^8\cdot|left_brace|$
	@!left_brace_limit = 0o1000 // $2^8\cdot(|left_brace|+1)$
	@!right_brace_token = 0o1000 // $2^8\cdot|right_brace|$
	@!right_brace_limit = 0o1400 // $2^8\cdot(|right_brace|+1)$
	@!math_shift_token = 0o1400 // $2^8\cdot|math_shift|$
	@!tab_token = 0o2000 // $2^8\cdot|tab_mark|$
	@!out_param_token = 0o2400 // $2^8\cdot|out_param|$
	@!space_token = 0o5040 // $2^8\cdot|spacer|+|" "|$
	@!letter_token = 0o5400 // $2^8\cdot|letter|$
	@!other_token = 0o6000 // $2^8\cdot|other_char|$
	@!match_token = 0o6400 // $2^8\cdot|match|$
	@!end_match_token = 0o7000 // $2^8\cdot|end_match|$
)

@ @<``상수'' 값들이...@>=
if cs_token_flag+undefined_control_sequence > max_halfword {
	bad = 21
}

@ 토큰 목록은 |mem| 안의 한 낱말짜리 노드들의 단일 연결 목록이다. 낱말마다 토큰 하나와 연결 하나가 들어
있다. 매크로 정의, 출력 루틴 정의, 표시, \.{\\write} 텍스트, 그 밖의 몇 가지를 \TeX은 토큰 목록의 꼴로
기억하는데, 대개 그 앞에 |token_ref_count| 필드에 참조 횟수를 담은 노드가 온다. 위치 |p|에 저장된
토큰은 |info(p)|라고 부른다.

매크로 정의의 토큰 목록에는 특별한 명령이 셋 나타난다. 명령 |m=match|는 \TeX이 현재 매크로의 매개변수
하나를 훑어야 한다는 뜻이다. 명령 |m=end_match|는 매개변수 맞추기를 끝내고 매크로 텍스트를 읽기
시작해야 한다는 뜻이다. 명령 |m=out_param|은 \TeX이 이 자리에서 매개변수 번호 |c|를 텍스트에 끼워 넣어야 한다는 뜻이다.

매크로 정의를 둘러싼 \.{\char'173}와 \.{\char'175} 문자는 빠지지만, 출력 루틴은 중괄호로 둘러싸인다.

다음은 이 관례들을 보여 주는 매크로 정의의 예다. \TeX이 텍스트
$$\.{\\def\\mac a\#1\#2 \\b \{\#1\\-a \#\#1\#2 \#2\}}$$
를 처리하고 나면 \.{\\mac}의 정의는 다음을 담은 토큰 목록으로 나타난다.
$$\def\,{\hskip2pt}
\vbox{\halign{\hfil#\hfil\cr
(참조 횟수), |letter|\,\.a, |match|\,\#, |match|\,\#, |spacer|\,\.\ ,
\.{\\b}, |end_match|,\cr
|out_param|\,1, \.{\\-}, |letter|\,\.a, |spacer|\,\.\ , |mac_param|\,\#,
|other_char|\,\.1,\cr
|out_param|\,2, |spacer|\,\.\ , |out_param|\,2.\cr}}$$
프로시저 |scan_toks|가 이런 토큰 목록을 만들고, |macro_call|이 매개변수 맞추기를 한다.
@^reference counts@>

$$\.{\\def\\m\{\\def\\m\{a\}\ b\}}$$
같은 예는 \TeX에 \.{\\let} 연산이 없더라도 참조 횟수가 필요한 까닭을 설명해 준다. 매크로 \.{\\m}의 토큰 목록을
읽고 있는 동안 \.{\\m}을 다시 정의하면, 토큰 목록을 다 쓰기 전에 |eqtb| 항목이 바뀐다. 그러므로 제어
시퀀스를 다시 정의한다고 해서 그 토큰 목록을 그냥 없애 버릴 수는 없다.

정의의 매개변수 맞추기 부분이 `\.{\#\{}'로 끝나면, 해당하는 토큰 목록에는 `|end_match|' 바로 앞과
맨 끝에 `\.\{'가 있게 된다. 첫째 `\.\{'는 매개변수를 구분하는 데 쓰이고, 둘째 것은 첫째 것이 사라지지
않게 해 준다.

@ 프로시저 |show_token_list|는 주어진 노드 |p|에서 시작하는 토큰 목록을 기호 꼴로 찍는데, 이것이 위의
관례들을 잘 보여 준다. 보여 줄 토큰 목록은 참조 횟수로 시작하면 안 된다. 그러나 이 프로시저는
튼튼하도록 만든 것이어서, 메모리의 연결이 엉망이거나 |p|가 실제로 토큰 목록을 가리키는 포인터가
아니더라도 큰일이 일어나지는 않는다.

매개변수 |q|도 주어진다. 이 매개변수는 널이거나, 나중에 설명할 어떤 마법 같은 계산이 일어나는 토큰
목록의 노드를 가리킨다. (요컨대 |q|는 오류 메시지를 낼 때 두 줄짜리 문맥 정보를 찍는 경우에 널이 아니다.
포인터 |q|는 둘째 줄이 시작해야 할 곳에 해당하는 자리를 표시한다.)

이를테면 |p|가 위의 토큰 목록에서 첫째 \.a를 담은 노드를 가리키면, |show_token_list|는 문자열
$$\hbox{`\.{a\#1\#2\ \\b\ ->\#1\\-a\ \#\#1\#2\ \#2}'}$$
을 찍는다. 그리고 |q|가 둘째 \.a를 담은 노드를 가리키면, 둘째 \.a를 찍기 바로 전에 마법 같은 계산이
이루어진다.

찍은 길이가 주어진 한계~|l|을 넘으면 찍기를 멈추고 `\.{\\ETC.}'를 찍는다. 이상한 항목은 뒤에 공백이
오지 않는 제어 시퀀스의 꼴, 이를테면 `\.{\\BAD.}'로 찍힌다. 이것은 실제 제어 시퀀스와 헷갈릴 수 없다.
이름이 \.{BAD}인 진짜 제어 시퀀스는 `\.{\\BAD\ }'로 찍힐 것이기 때문이다.

@<|show_token_list|라는...@>=
func show_token_list(p, q int32, l int32) {
	var m, c int32 // 토큰의 조각들
	var match_chr ASCII_code // `|match|'에 쓰인 문자
	var n ASCII_code // 가장 큰 매개변수 번호, {\mc ASCII} 숫자로
	match_chr = '#'
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
		print_esc("ETC.")
	}
@.ETC@>
}

@ @<토큰 |p|를 보이되...@>=
if p < hi_mem_min || p > mem_end {
	print_esc("CLOBBERED.")
	return
@.CLOBBERED@>
}
if info(p) >= cs_token_flag {
	print_cs(info(p) - cs_token_flag)
} else {
	m = info(p) / 0o400
	c = info(p) % 0o400
	if info(p) < 0 {
		print_esc("BAD.")
@.BAD@>
	} else {
		@<토큰 $(|m|,|c|)$를 보인다@>
	}
}

@ 이 프로시저는 대개 |out_param| 명령을 만나기 전에 |match| 명령에서 매크로 매개변수에 쓰인 문자 코드를
보고 그것을 ``배운다.''

@<토큰 $(|m|,|c|)$를...@>=
switch m {
case left_brace, right_brace, math_shift, tab_mark, sup_mark, sub_mark, spacer,
	letter, other_char:
	print(c)
case mac_param:
	print(c)
	print(c)
case out_param:
	print(match_chr)
	if c <= 9 {
		print_char(c + '0')
	} else {
		print_char('!')
		return
	}
case match:
	match_chr = c
	print(c)
	n++
	print_char(n)
	if n > '9' {
		return
	}
case end_match:
	print("->")
@.->@>
default:
	print_esc("BAD.")
@.BAD@>
}

@ 다음은 참조 횟수를 가리키는 포인터가 주어졌을 때 토큰 목록을 보여 주고 싶을 때 이따금 쓰는 방법이다.
포인터는 널일 수도 있다.

@<함수들@>=
func token_show(p pointer) {
	if p != null {
		show_token_list(link(p), null, 10000000)
	}
}

@ 서브루틴 |print_meaning|은 |cur_cmd|와 |cur_chr|를 기호 꼴로 보여 준다. 매크로나 표시의 펼침도
보여 준다.

@<함수들@>=
func print_meaning() {
	print_cmd_chr(cur_cmd, cur_chr)
	if cur_cmd >= call {
		print_char(':')
		print_ln()
		token_show(cur_chr)
	} else if cur_cmd == top_bot_mark {
		print_char(':')
		print_ln()
		token_show(cur_mark[cur_chr])
	}
}

@* 구문 루틴 들어가기.
이제 잠깐 멈추어서 큰 그림을 보도록 하자. \TeX\ 프로그램은 세 주요 부분, 곧 구문 루틴, 의미 루틴, 출력
루틴으로 이루어져 있다. 구문 루틴의 주된 목적은 사용자의 입력을 한 번에 토큰 하나씩 의미 루틴에
건네주는 것이다. 의미 루틴은 이 토큰들, 곧 명령이라고 볼 수 있는 것들에 반응하는 해석기 노릇을 한다.
그리고 출력 루틴은 이따금 불려서 상자와 글루의 목록을 조판기에 보낼 간결한 명령 집합으로 바꾼다.
우리는 \TeX의 기본 자료 구조와 유틸리티 루틴을 다루었으니, 구문 루틴을 살펴보면서 실제 활동에 뛰어들
준비가 충분히 되었다.

지금의 목표는 \TeX의 입력 장치의 쐐기돌인 프로시저 |get_next|를 붙잡는 것이다. 이 프로시저를 부를
때마다 다음 입력 토큰을 나타내는 세 변수 |cur_cmd|, |cur_chr|, |cur_cs|의 값이 정해진다.
$$\vbox{\halign{#\hfil\cr
  \hbox{|cur_cmd|는 위에 보인 긴 코드 목록의 명령 코드를 나타낸다;}\cr
  \hbox{|cur_chr|는 문자 코드나 명령 코드의 다른 수식어를 나타낸다;}\cr
  \hbox{|cur_cs|는 현재 토큰이 제어 시퀀스였다면 현재 제어 시퀀스의 |eqtb| 위치이고,}\cr
  \hbox{\qquad 그렇지 않으면 0이다.}\cr}}$$
프로시저 |get_next|의 이런 겉 행동 밑에는 문자 파일을 토큰으로 바꾸는 데 필요한 모든 장치가 깔려 있다. 어느
때든 우리는 여러 파일(\.{\\input}으로 지정한 것들)을 읽다가 만 상태일 수 있고, 사용자가 정의한 매크로나
매크로 매개변수를 펼치다가 만 상태일 수 있으며, \.{\\halign}의 틀 안의 어떤 텍스트를 만들다가 만 상태일
수도 있고, 그 밖에도 여러 가지일 수 있다. 문자 파일을 읽을 때는 특별한 문자를 수식 구분자 따위로
분류해야 하고, 주석과 여분의 공백을 없애야 하며, 문단을 알아보아야 하고, 제어 시퀀스를 해시 표에서
찾아야 한다. 게다가 훑기 루틴들이 `\.{plus}' 같은 낱말을 미리 내다보았는데 그 낱말의 일부만 찾은
경우도 있다. 그러면 문자 몇 개를 입력에 되돌려 놓고 다시 훑어야 한다.

이 상황들은 모두 동시에 일어날 수도 있는데, 이것들을 다루려고 \TeX은 끝나지 않은 활동에 관한 정보를
담은 여러 스택을 쓰고, 입력 장치의 수준마다 유한 상태 제어가 있다. 이 스택들은 암묵적으로 재귀적인
과정의 현재 상태를 기록하지만, 프로시저 |get_next| 자체는 재귀적이지 않다. 그러므로 이 알고리즘들을
재귀를 지원하지 않는 저수준 언어로 옮기기도 어렵지 않을 것이다.

@<전역 변수@>=
var @!cur_cmd eight_bits // |get_next|가 정한 현재 명령
var @!cur_chr halfword // 현재 명령의 피연산자
var @!cur_cs pointer // 여기서 찾은 제어 시퀀스; 찾지 못하면 0
var @!cur_tok halfword // |cur_cmd|와 |cur_chr|를 꾸려 넣은 대표값

@ 루틴 |print_cmd_chr|는 명령 코드와 그 수식어의 기호 해석을 찍는다. 이것은 어떤 `\.{You can\'t}'
오류 메시지와 \.{\\show} 같은 진단 루틴의 구현에 쓰인다.

프로시저 |print_cmd_chr|의 몸체는 찍기 명령들을 꽤 지루하게 늘어놓은 것이고, 그 대부분은 \TeX\ 원시 명령을
|eqtb|에 넣는 루틴 |primitive|의 역이나 다름없다. 그래서 이 프로시저의 많은 부분은 프로그램의 다른
곳에서 해당하는 |primitive| 호출과 함께 나타난다.

보충: 원본의 매크로 |chr_cmd(#)|는 |print_cmd_chr|의 매개변수 |chr_code|를 쓴다. 여기서는
|print_cmd_chr| 안의 함수 리터럴로 옮겼다.

@<|print_cmd_chr|라는...@>=
func print_cmd_chr(cmd quarterword, chr_code halfword) {
	chr_cmd := func(s string) {
		print(s)
		print_ASCII(chr_code)
	}
	switch cmd {
	case left_brace:
		chr_cmd("begin-group character ")
	case right_brace:
		chr_cmd("end-group character ")
	case math_shift:
		chr_cmd("math shift character ")
	case mac_param:
		chr_cmd("macro parameter character ")
	case sup_mark:
		chr_cmd("superscript character ")
	case sub_mark:
		chr_cmd("subscript character ")
	case endv:
		print("end of alignment template")
	case spacer:
		chr_cmd("blank space ")
	case letter:
		chr_cmd("the letter ")
	case other_char:
		chr_cmd("the character ")
	@<원시 명령의 이름을 찍는...@>
	default:
		print("[unknown command code!]")
	}
}

@ 다음은 현재 명령을 보여 주는 프로시저다.

@<함수들@>=
func show_cur_cmd_chr() {
	begin_diagnostic()
	print_nl("{")
	if mode != shown_mode {
		print_mode(mode)
		print(": ")
		shown_mode = mode
	}
	print_cmd_chr(cur_cmd, cur_chr)
	print_char('}')
	end_diagnostic(false)
}

@* 입력 스택과 상태.
이 \TeX\ 구현은 순차 스택을 나타내는 데 두 가지 관례를 쓴다.
@^stack conventions@>@^conventions for representing stacks@>

\yskip\hangg 1) 맨 위 항목에 자주 접근하고 스택이 사실상 결코 비지 않는다면, 맨 위 항목은 전역 변수(기계
레지스터라면 더 좋을 것이다)에 두고 다른 항목들은 배열 $\ID{stack}[0\to(\ID{ptr}-1)]$에 둔다. 이를테면
앞에서 설명한 의미 스택이 이렇게 다루어지고, 이제 공부할 입력 스택도 그렇다.

\yskip\hangg 2) 맨 위에 드물게 접근한다면 스택의 내용 전체가 배열 $\ID{stack}[0\to(\ID{ptr}-1)]$에
있다. 이를테면 앞에서 보았듯이 |save_stack|이 이렇게 다루어진다.

\yskip\noindent
\TeX의 입력 장치의 상태는 입력 스택에 나타난다. 그 항목들은 |state|, |index|, |start|, |loc|, |limit|,
|name|이라는 여섯 필드를 가진 레코드다. 이 스택은 관례~(1)로 관리되므로 다음과 같이 선언한다.

@<바깥 블록의 형@>=
type @!in_state_record struct {
	@!state_field, @!index_field quarterword
	@!start_field, @!loc_field, @!limit_field, @!name_field halfword
}

@ @<전역 변수@>=
var @!input_stack [stack_size + 1]in_state_record
var @!input_ptr int32 // |input_stack|에서 쓰이지 않는 첫 위치; |0..stack_size|
var @!max_in_stack int32 // 쌓을 때 |input_ptr|의 가장 큰 값; |0..stack_size|

@ 기본 입출력 루틴을 논의할 때 이미 특별한 변수 |loc==cur_input.loc_field|를 정의했다. 레코드 |cur_input|의
다른 구성 요소들도 같은 방식으로 정의된다.

보충: 원본에는 관례 (1)에 따라 ``맨 위'' 입력 상태를 담는 레코드 |cur_input|이 있고, 매크로 |state|,
|index|, |start|, |loc|, |limit|, |name|이 그 필드들을 가리킨다. 의미 둥지의 |cur_list|(\os{213})와
마찬가지로, 이 번역에서는 이 여섯 필드가 저마다 전역 변수다. 원본에서 |cur_input|을 통째로 다루는
곳은 함수 |cur_input()|과 |set_cur_input(r)|로 옮긴다.

@<전역 변수@>=
var @!state quarterword // 현재 훑개의 상태
var @!index quarterword // 버퍼 정보를 가리키는 참조
var @!start halfword // |buffer|에서 시작 위치
var @!loc halfword // |buffer|에서 읽지 않은 첫 문자의 위치
var @!limit halfword // |buffer|에서 현재 줄의 끝
var @!name halfword // 현재 파일의 이름

func cur_input() in_state_record { // 관례 (1)에 따른 ``맨 위'' 입력 상태
	return in_state_record{state, index, start, loc, limit, name}
}

func set_cur_input(r in_state_record) {
	state, index, start = r.state_field, r.index_field, r.start_field
	loc, limit, name = r.loc_field, r.limit_field, r.name_field
}

@ 이제 \TeX이 어떤 파일이나 사용자의 터미널에서 입력된 문자들의 줄을 읽고 있다고 가정하고 제어 변수들
(|state|,~|index|,~|start|,~|loc|,~|limit|,~|name|)을 더 자세히 살펴보자. 배열 |buffer|가 있는데,
이것은 지금 파일에서 읽고 있는 모든 문자 줄의 스택 노릇을 한다. 입력 스택의 아래 수준에서 아직 끝나지
않은 줄들도 모두 여기 들어 있다. \TeX은 지금의 입력 파일을 다 읽으면 다른 줄들로 돌아간다.

(덧붙여 말하면, 바이트 단위로 주소를 매기는 기계에서는 |buffer|를 배열 |str_pool|과 합쳐서, 버퍼
항목들이 문자열 풀의 꼭대기에서 아래로 자라게 하고 이 두 표가 서로 부딪치지 않는지 검사하는 것이
알맞을 수도 있다.)

지금 다루고 있는 줄은 버퍼의 위치 |start|에서 시작한다. 다음에 읽을 문자는 |buffer[loc]|이고,
|limit|는 있는 마지막 문자의 위치다. 조건 |loc>limit|이 성립하면 그 줄은 다 읽은 것이다. 대개 |buffer[limit]|는
줄의 끝을 나타내는 |end_line_char|이지만, 현재 줄이 오류 메시지에 대한 대답으로 사용자가 터미널에서
친 삽입이라면 그렇지 않다.

변수 |name|은 텍스트 파일을 읽고 있다면 현재 파일의 이름을 가리키는 문자열 번호다. 터미널에서 읽고
있으면 0이다. 입력 스트림 |n|에서 읽고 있으면 |n+1|이다. 여기서 |0<=n<=16|이다. (입력 스트림 16은 잘못된
스트림 번호를 나타낸다. 그런 경우 입력은 실제로는 프로시저 |read_toks|의 통제 아래 터미널에서 온다.)

그런 파일을 훑을 때 변수 |state|는 세 값 가운데 하나를 가진다.
$$\baselineskip 15pt\vbox{\halign{#\hfil\cr
1) |state=mid_line|은 보통 상태다.\cr
2) |state=skip_blanks|는 |mid_line|과 같지만, 공백을 무시한다.\cr
3) |state=new_line|은 줄의 처음에서의 상태다.\cr}}$$
이 상태 값들에는 수 코드를 주어서, 상태 코드를 다음 문자의 명령 코드에 더하면 서로 다른 값을 얻게 한다.
이를테면 `|mid_line+spacer|'는 무시되지 않는 공백 문자가 줄 한가운데 나타나는 경우를 나타낸다. 이
경우를 처리하고 나면 |state|의 다음 값은 |skip_blanks|가 된다.

@<정의@>=
const (
	@!mid_line = 1 // 문자 줄을 훑을 때의 |state| 코드
	@!skip_blanks = 2 + max_char_code // 공백을 무시할 때의 |state| 코드
	@!new_line = 3 + max_char_code + max_char_code // 줄의 처음에서의 |state| 코드
)

@ 현재 줄에 관한 정보는 변수 |index|로도 얻을 수 있다. 이 변수는 현재 수준 아래에서 버퍼에 들어 있는
문자 줄의 수를 센다. 터미널에서 읽으면서 줄마다 사용자에게 재촉할 때는 |index=0|이다. 그러다가
사용자가 이를테면 `\.{\\input paper}'를 치면 파일 \.{paper.tex}를 읽는 동안 |index=1|이 된다. 그러나
|index|가 입력 스택 포인터와 같다는 뜻은 아니다. 입력 스택의 많은 수준이 토큰 목록에서 올 수 있기
때문이다. 이를테면 명령 `\.{\\input paper}'가 토큰 목록 안에 있을 수도 있다.

전역 변수 |in_open|은 토큰 목록이 아닌 가장 높은 수준의 |index| 값과 같다. 그러므로 버퍼에서 부분적으로
읽은 줄의 수는 |in_open+1|이고, 토큰 목록을 읽고 있지 않을 때는 |in_open=index|다.

지금 터미널이나 입력 스트림에서 읽고 있지 않으면 파일 변수 |input_file[index]|에서 읽고 있는 것이다.
조건 |name=0|의 편리한 약어로 |terminal_input|이라는 표기를, |input_file[index]|의 약어로 |cur_file|을 쓴다.

전역 변수 |line|은 오류 메시지에 쓰려고 맨 위에 열린 파일의 줄 번호를 담는다. 터미널에서 읽고 있지
않으면 |line_stack[index]|가 둘러싼 수준의 줄 번호를 담아서, 현재 파일을 다 읽었을 때 |line|을 되살릴
수 있게 한다. 줄 번호는 결코 음수가 되면 안 된다. 현재 줄 번호의 음수는 의미 둥지 항목의 |mode_line|
필드에서 사용자의 출력 루틴을 알아보는 데 쓰이기 때문이다.

입력 상태에 관한 정보가 더 필요하면 여기 보인 것 같은 작은 배열에 넣을 수 있다. 이를테면 입력 파일의
현재 쪽이나 구획 번호를 변수 |@!page|에 넣고, |line_stack|에 견주어 둘러싼 수준들을 위해
`\ignorespaces|@!page_stack:array[1..max_in_open] of integer|\unskip'에 유지할 수 있을 것이다.
@^system dependencies@>

보충: 원본에서 |cur_file|은 \KW{var} 매개변수로 넘겨지는 파일 변수이므로, \GO/에서는 그 파일을 가리키는
포인터를 돌려주는 함수다.

@<전역 변수@>=
func terminal_input() bool    { return name == 0 } // 터미널에서 읽고 있나?
func cur_file() *alpha_file   { return &input_file[index] } // 현재의 |alpha_file| 변수

var @!in_open int32 // 버퍼에 든 줄의 수에서 하나를 뺀 것; |0..max_in_open|
var @!open_parens int32 // 열린 텍스트 파일의 수; |0..max_in_open|
var @!input_file [max_in_open + 1]alpha_file
var @!line int32 // 현재 원본 파일의 현재 줄 번호
var @!line_stack [max_in_open + 1]int32

@ \TeX\ 사용자는 때로 왼쪽과 오른쪽 중괄호의 짝을 제대로 맞추는 것을 잊는다. \TeX이 그런 오류를
찾아내려는 방법 가운데 하나는 입력 파일을 \.{\\outer}로 선언된 제어 시퀀스들을 경계로 하위 파일들로
나뉜 것으로 보는 것이다.

변수 |scanner_status|는 하위 파일이 끝날 때 \TeX이 불평해야 하는지 아닌지를 알려 준다. 이 변수는
여섯 가지 값을 가질 수 있다.

\yskip\hang|normal|, 하위 파일이 여기서 아무 일 없이 끝나도 안전하다는 뜻이다.

\yskip\hang|skipping|, 하위 파일은 여기서 끝나도 안전하지만 파일은 그렇지 않다는 뜻이다. 선택되지
않은 조건부 텍스트를 지나가며 읽고 있기 때문이다.

\yskip\hang|defining|, 매크로를 정의하고 있으므로 하위 파일이 지금 끝나면 안 된다는 뜻이다.

\yskip\hang|matching|, 매크로를 쓰고 있고 그 인자의 끝을 찾고 있으므로 하위 파일이 지금 끝나면 안
된다는 뜻이다.

\yskip\hang|aligning|, \.{\\halign}이나 \.{\\valign}의 서문을 다 읽지 않았으므로 하위 파일이 지금
끝나면 안 된다는 뜻이다.

\yskip\hang|absorbing|, \.{\\message}, \.{\\write} 따위를 위한 균형 잡힌 토큰 목록을 읽고 있으므로
하위 파일이 지금 끝나면 안 된다는 뜻이다.

\yskip\noindent
이 변수가 |normal|이 아니면 변수 |warning_index|는 오류 메시지에 찍을 관련 제어 시퀀스
이름의 |eqtb| 위치를 가리킨다.

@<전역 변수@>=
const (
	@!skipping = 1 // 조건부 텍스트를 지나갈 때의 |scanner_status|
	@!defining = 2 // 매크로 정의를 읽을 때의 |scanner_status|
	@!matching = 3 // 매크로 인자를 읽을 때의 |scanner_status|
	@!aligning = 4 // 정렬 서문을 읽을 때의 |scanner_status|
	@!absorbing = 5 // 균형 잡힌 텍스트를 읽을 때의 |scanner_status|
)

var @!scanner_status int32 // 하위 파일이 지금 끝나도 되나? |normal..absorbing|
var @!warning_index pointer // |normal|이 아닌 훑개 상태에 관련된 식별자
var @!def_ref pointer // 정의하고 있는 토큰 목록의 참조 횟수

@ 다음은 하위 파일이 끝났을 때와 그 밖의 결정적인 때에 |scanner_status|를 써서 경고 메시지를 찍는
프로시저다.

@<|runaway|라는...@>=
func runaway() {
	var p pointer // 폭주 목록의 머리
	if scanner_status > skipping {
		print_nl("Runaway ")
@.Runaway...@>
		switch scanner_status {
		case defining:
			print("definition")
			p = def_ref
		case matching:
			print("argument")
			p = temp_head
		case aligning:
			print("preamble")
			p = hold_head
		case absorbing:
			print("text")
			p = def_ref
		} // 다른 경우는 없다
		print_char('?')
		print_ln()
		show_token_list(link(p), null, error_line-10)
	}
}

@ 그러나 입력 상태에 관한 이 모든 이야기는 실은 파일에서 입력하는 경우에만 들어맞는다. 또 하나의 중요한
경우, 곧 지금 토큰 목록에서 입력을 얻고 있는 경우가 있다. 이 경우에는 |state=token_list|이고, 다른 상태
변수들에 관한 관례가 다르다.

\yskip\hang|loc|은 토큰 목록의 현재 노드, 곧 다음에 읽을 노드를 가리키는 포인터다. 그리고 |loc=null|이면 토큰
목록을 다 읽은 것이다.

\yskip\hang|start|는 토큰 목록의 첫 노드를 가리킨다. 이 노드에는 관련된 토큰 목록의 종류에 따라 참조
횟수가 들어 있을 수도 있고 없을 수도 있다.

\yskip\hang|token_type|은 위의 논의에서 |index|를 대신하는 것으로, 어떤 종류의 토큰 목록을 훑고
있는지 설명하는 코드 번호다.

\yskip\hang|name|은 현재 토큰 목록이 매크로라면 펼치고 있는 제어 시퀀스의 |eqtb| 주소를 가리킨다.

\yskip\hang|param_start|는 |limit|를 대신하는 것으로, 현재 토큰 목록이 매크로라면 현재 매크로의
매개변수들이 |param_stack|의 어디에서 시작하는지 알려 준다.

\yskip\noindent 코드 |token_type|은 현재 토큰 목록이 어디서 왔는지에 따라 여러 값을 가질 수 있다.

\yskip\hang|parameter|, 매개변수를 훑고 있을 때;

\hang|u_template|, 정렬 틀의 \<u_j> 부분을 훑고 있을 때;

\hang|v_template|, 정렬 틀의 \<v_j> 부분을 훑고 있을 때;

\hang|backed_up|, 훑고 있는 토큰 목록이 `다시 읽을 것'으로 끼워 넣어졌을 때;

\hang|inserted|, 훑고 있는 토큰 목록이 \.{\\count} 같은 변수의 텍스트 펼침으로 끼워 넣어졌을 때;

\hang|macro|, 사용자가 정의한 제어 시퀀스를 훑고 있을 때;

\hang|output_text|, \.{\\output} 루틴을 훑고 있을 때;

\hang|every_par_text|, \.{\\everypar}의 텍스트를 훑고 있을 때;

\hang|every_math_text|, \.{\\everymath}의 텍스트를 훑고 있을 때;

\hang|every_display_text|, \.{\\everydisplay}의 텍스트를 훑고 있을 때;

\hang|every_hbox_text|, \.{\\everyhbox}의 텍스트를 훑고 있을 때;

\hang|every_vbox_text|, \.{\\everyvbox}의 텍스트를 훑고 있을 때;

\hang|every_job_text|, \.{\\everyjob}의 텍스트를 훑고 있을 때;

\hang|every_cr_text|, \.{\\everycr}의 텍스트를 훑고 있을 때;

\hang|mark_text|, \.{\\mark}의 텍스트를 훑고 있을 때;

\hang|write_text|, \.{\\write}의 텍스트를 훑고 있을 때.

\yskip\noindent
코드 |output_text|, |every_par_text| 따위는 어떤 상수에 토큰 목록 매개변수 |output_routine_loc|,
|every_par_loc| 따위의 해당 코드를 더한 것과 같다. 토큰 목록은 |token_type>=macro|일 때, 그리고 오직
그때에만 참조 횟수로 시작한다.
@^reference counts@>

@ \dg 앞 절의 정의부를 옮긴다.

보충: 이름 |token_type|과 |param_start|는 원본에서 변수 |index|와 |limit|의 다른 이름이다. \GO/에서는
\os{213}의 |prev_depth|처럼 읽는 함수와 쓰는 함수의 짝이 된다.

@<정의@>=
const (
	@!token_list = 0 // 토큰 목록을 훑을 때의 |state| 코드
	@!parameter = 0 // 매개변수의 |token_type| 코드
	@!u_template = 1 // \<u_j> 틀의 |token_type| 코드
	@!v_template = 2 // \<v_j> 틀의 |token_type| 코드
	@!backed_up = 3 // 다시 읽을 텍스트의 |token_type| 코드
	@!inserted = 4 // 끼워 넣은 텍스트의 |token_type| 코드
	@!macro = 5 // 정의된 제어 시퀀스의 |token_type| 코드
	@!output_text = 6 // 출력 루틴의 |token_type| 코드
	@!every_par_text = 7 // \.{\\everypar}의 |token_type| 코드
	@!every_math_text = 8 // \.{\\everymath}의 |token_type| 코드
	@!every_display_text = 9 // \.{\\everydisplay}의 |token_type| 코드
	@!every_hbox_text = 10 // \.{\\everyhbox}의 |token_type| 코드
	@!every_vbox_text = 11 // \.{\\everyvbox}의 |token_type| 코드
	@!every_job_text = 12 // \.{\\everyjob}의 |token_type| 코드
	@!every_cr_text = 13 // \.{\\everycr}의 |token_type| 코드
	@!mark_text = 14 // \.{\\topmark} 따위의 |token_type| 코드
	@!write_text = 15 // \.{\\write}의 |token_type| 코드
)

func token_type() quarterword        { return index } // 현재 토큰 목록의 종류
func set_token_type(v quarterword)   { index = v }
func param_start() halfword          { return limit } // |param_stack|에서 매크로 매개변수의 바닥
func set_param_start(v halfword)     { limit = v }

@ 스택 |param_stack|은 현재 입력 수준과 그 아래 수준들의 매개변수 토큰 목록을 가리키는 포인터들을 담는 데 쓰는
보조 배열이다. 이 스택은 관례 (2)로 관리되며, 다른 스택들과는 다른 속도로 자란다.

@<전역 변수@>=
var @!param_stack [param_size + 1]pointer // 매개변수의 토큰 목록 포인터
var @!param_ptr int32 // |param_stack|에서 쓰이지 않는 첫 항목; |0..param_size|
var @!max_param_stack int32 // |param_ptr|의 가장 큰 값, |<=param_size+9|일 것이다

@ 입력 루틴들은 \.{\\halign}과 \.{\\valign}의 처리와도 상호 작용해야 한다. 어떤 곳에 탭 표시와
\.{\\cr}이 나타나면 훑개 안에서 특별한 \<v_j> 틀 텍스트가 시작되어야 하기 때문이다. 이 마법은
|align_state|라는 변수로 이루어지는데, 이 변수는 `\.{\char'173}'를 훑으면 1 늘고 `\.{\char'175}'를
훑으면 1 줄어든다. 이 변수는 \<u_j> 틀 동안에는 0이 아니고, 그 뒤에 0으로 놓인다. \<v_j> 틀은
|align_state=0|일 때 탭 표시나 \.{\\cr}이 나타나면 시작한다.

@<전역 변수@>=
var @!align_state int32 // 현재 정렬에 대한 그룹 수준

@ 이렇듯 ``현재 입력 상태''는 정말이지 매우 복잡할 수 있다. 수준이 많을 수 있고, 각 수준은 여러
방법으로 생길 수 있다. 프로시저 |show_context|는 \TeX의 오류 보고 루틴이 입력 파일의 가장 최근 문자
줄에 이르기까지 모든 수준의 현재 입력 상태를 찍는 데 쓰는데, 이것이 이 관례들의 대부분을 보여 준다. 전역
변수 |base_ptr|에는 이 프로시저가 보여 준 가장 낮은 수준이 들어 있다.

@<전역 변수@>=
var @!base_ptr int32 // |show_context|가 보여 준 가장 얕은 수준; |0..stack_size|

@ 각 수준의 상태는 두 줄을 찍어서 나타낸다. 첫째 줄은 지금까지 읽은 것을, 둘째 줄은 앞으로 읽을 것을
보여 준다. 첫째 줄에 문자가 많아야 |half_error_line|개, 둘째 줄에 많아야 |error_line|개 들어가도록 필요하면
문맥을 잘라 낸다. 현재가 아닌 입력 수준 가운데 |token_type|이 `|backed_up|'인 것은 다 읽지 않았을 때에만
보여 준다.

@<함수들@>=
func show_context() { // 훑개가 어디 있는지 찍는다
	var old_setting int32 // 저장한 |selector| 설정; |0..max_selector|
	var nn int32 // 지금까지 보여 준 문맥의 수에서 하나를 뺀 것
	var bottom_line bool // 보여 줄 마지막 문맥에 이르렀나?
	@<서식 계산을 위한 지역 변수@>
	base_ptr = input_ptr
	input_stack[base_ptr] = cur_input() // 현재 상태를 저장한다
	nn = -1
	bottom_line = false
	for {
		set_cur_input(input_stack[base_ptr]) // 문맥 안으로 들어간다
		if state != token_list {
			if name > 17 || base_ptr == 0 {
				bottom_line = true
			}
		}
		if base_ptr == input_ptr || bottom_line || nn < error_context_lines() {
			@<현재 문맥을 보인다@>
		} else if nn == error_context_lines() {
			print_nl("...")
			nn++ // |error_context_lines<0|이면 빠진다
		}
		if bottom_line {
			goto done
		}
		base_ptr--
	}
done:
	set_cur_input(input_stack[input_ptr]) // 원래 상태를 되살린다
}

@ @<현재 문맥을...@>=
if base_ptr == input_ptr || state != token_list ||
	token_type() != backed_up || loc != null {
	// 이미 읽은 되돌린 토큰 목록은 빠뜨린다
	tally = 0 // 문자를 셀 준비를 한다
	old_setting = selector
	if state != token_list {
		@<현재 줄의 위치를 찍는다@>
		@<줄을 흉내 찍는다@>
	} else {
		@<토큰 목록의 종류를 찍는다@>
		@<토큰 목록을 흉내 찍는다@>
	}
	selector = old_setting // 흉내 찍기를 멈춘다
	@<흉내 찍은 교묘한 정보로 두 줄을 찍는다@>
	nn++
}

@ 이 루틴은 필요하면 바꾸어서, 현재 줄이 입력 파일의 어디에 있는지 될 수 있는 대로 잘 알려 주도록 해야
한다. 이를테면 어떤 시스템에서는 쪽 번호와 줄 번호를 둘 다 찍는 것이 가장 좋다.
@^system dependencies@>

@<현재 줄의 위치를...@>=
if name <= 17 {
	if terminal_input() {
		if base_ptr == 0 {
			print_nl("<*>")
		} else {
			print_nl("<insert> ")
		}
	} else {
		print_nl("<read ")
		if name == 17 {
			print_char('*')
		} else {
			print_int(name - 1)
		}
@.*\relax@>
		print_char('>')
	}
} else {
	print_nl("l.")
	print_int(line)
}
print_char(' ')

@ @<토큰 목록의 종류를...@>=
switch token_type() {
case parameter:
	print_nl("<argument> ")
case u_template, v_template:
	print_nl("<template> ")
case backed_up:
	if loc == null {
		print_nl("<recently read> ")
	} else {
		print_nl("<to be read again> ")
	}
case inserted:
	print_nl("<inserted text> ")
case macro:
	print_ln()
	print_cs(name)
case output_text:
	print_nl("<output> ")
case every_par_text:
	print_nl("<everypar> ")
case every_math_text:
	print_nl("<everymath> ")
case every_display_text:
	print_nl("<everydisplay> ")
case every_hbox_text:
	print_nl("<everyhbox> ")
case every_vbox_text:
	print_nl("<everyvbox> ")
case every_job_text:
	print_nl("<everyjob> ")
case every_cr_text:
	print_nl("<everycr> ")
case mark_text:
	print_nl("<mark> ")
case write_text:
	print_nl("<write> ")
default:
	print_nl("?") // 이런 일은 결코 일어나지 않아야 한다
}

@ 여기서 작은 요령 하나를 설명해야 한다. 토큰 목록에 해당하는 긴 문자열을 저장하고 싶지는 않다. 그
문자열이 많은 메모리를 차지할 수도 있고, 지금은 오류 메시지를 내는 중이므로 \TeX의 표 가운데 하나라도
넘치게 할지 모르는 일은 감히 할 수 없기 때문이다. 그래서 `흉내 찍기'(pseudoprinting)가 답이다. 우리는
길이가 |error_line|인 버퍼에 문자들을 저장하는 찍기 방식에 들어간다. 여기서 문자 $k+1$은
|k<trick_count|면 \hbox{|trick_buf[k mod error_line]|}에 놓이고, 그렇지 않으면 문자 |k|는 버려진다.
처음에는 |tally:=0|, |trick_count:=1000000|으로 놓는다. 그러다가 1행에서 2행으로 넘어가야 할 곳에
이르면 |first_count:=tally|, |trick_count:=@tmax@>(error_line, tally+1+error_line-half_error_line)|로
놓는다. 흉내 찍기가 끝나면 |first_count|, |tally|, |trick_count|의 값이 두 줄을 찍는 데 필요한 모든
정보를 주고, 필요한 텍스트는 모두 |trick_buf|에 들어 있다.

곧 첫째 줄에 나타나는 설명 정보의 길이를 |l|이라고 하자. 그 줄을 위해 모은 문맥 정보의 길이는
|k=first_count|이고, 2행을 위해 모은 문맥 정보의 길이는 $m=\min(|tally|, |trick_count|)-k$다.
이제 |h=half_error_line|이라고 하자. 만일 |l+k<=h|이면 1행의 설명 정보 뒤에 |trick_buf[0..k-1]|을 찍고
|n:=l+k|로 놓는다. 여기서 |n|은 1행의 길이다. 반대로 $l+k>h$이면 잘라 내야 하므로 |n:=h|로 놓고 `\.{...}' 다음에
$$\hbox{|trick_buf[(l+k-h+3)..k-1]|}$$
을 찍는다. 여기서 |trick_buf|의 첨자는 |error_line|을 법으로 순환한다. 둘째 줄은 공백 |n|개 다음에
|trick_buf[k..(k+m-1)]|이 오는 것인데, |n+m>error_line|이면 거기서 더 잘라 낸다. 이것은 설명하기보다
프로그램을 짜기가 더 쉽다.

@<서식 계산을...@>=
var @!i int32 // |buffer|의 첨자; |0..buf_size|
var @!j int32 // |buffer|에서 현재 줄의 끝; |0..buf_size|
var @!l int32 // 1행의 설명 정보의 길이; |0..half_error_line|
var @!m int32 // 2행을 위해 모은 문맥 정보
var @!n int32 // 1행의 길이; |0..error_line|
var @!p int32 // |trick_buf|에서 시작이나 끝 위치
var @!q int32 // 임시 첨자

@ 다음 코드는 찍기 루틴들이 원하는 정보를 모으도록 준비한다.

보충: 원본의 매크로 |begin_pseudoprint|는 |show_context|의 지역 변수 |l|을 쓰므로, 여기서는
|show_context| 안의 함수 리터럴로 옮겨 지역 변수들 곁에 둔다. 다른 매크로 |set_trick_count|는
|show_token_list|에서도 쓰이므로 다음 절에서 보통의 함수로 둔다.

@<서식 계산을...@>=
begin_pseudoprint := func() {
	l = tally
	tally = 0
	selector = pseudo
	trick_count = 1000000
}

@ \dg 앞 절의 정의부에서 매크로 |set_trick_count|를 옮긴다.

@<정의@>=
func set_trick_count() {
	first_count = tally
	trick_count = tally + 1 + error_line - half_error_line
	if trick_count < error_line {
		trick_count = error_line
	}
}

@ 그리고 다음 코드는 정보를 다 모은 뒤에 그것을 쓴다.

@<흉내 찍은 교묘한...@>=
if trick_count == 1000000 {
	set_trick_count()
} // |set_trick_count|를 반드시 해야 한다
if tally < trick_count {
	m = tally - first_count
} else {
	m = trick_count - first_count
} // 2행의 문맥
if l+first_count <= half_error_line {
	p = 0
	n = l + first_count
} else {
	print("...")
	p = l + first_count - half_error_line + 3
	n = half_error_line
}
for q = p; q <= first_count-1; q++ {
	print_char(trick_buf[q%error_line])
}
print_ln()
for q = 1; q <= n; q++ {
	print_char(' ')
} // 2행을 시작하는 공백 |n|개를 찍는다
if m+n <= error_line {
	p = first_count + m
} else {
	p = first_count + (error_line - n - 3)
}
for q = first_count; q <= p-1; q++ {
	print_char(trick_buf[q%error_line])
}
if m+n > error_line {
	print("...")
}

@ 그러나 이 요령은 지금의 목표, 곧 입력 상태를 이해하는 데서 우리의 주의를 흩뜨린다. 그러니 |show_context|
프로시저를 마무리하면서 흉내 찍히는 자료 구조에 집중하자.

@<줄을 흉내...@>=
begin_pseudoprint()
if buffer[limit] == end_line_char() {
	j = limit
} else {
	j = limit + 1
} // 줄의 실제 끝을 정한다
if j > 0 {
	for i = start; i <= j-1; i++ {
		if i == loc {
			set_trick_count()
		}
		print(buffer[i])
	}
}

@ @<토큰 목록을 흉내...@>=
begin_pseudoprint()
if token_type() < macro {
	show_token_list(start, loc, 100000)
} else {
	show_token_list(link(start), loc, 100000) // 참조 횟수를 피한다
}

@ 다음은 2행을 시작하는 토큰을 막 보여 주려 할 때 작동하는 |show_token_list|의 빠진 조각이다.

@<마법 같은...@>=
set_trick_count()

@* 입력 스택 관리하기.
다음 서브루틴들은 흔히 필요한 방식으로 입력 상태를 바꾼다.

먼저 |push_input|이 나온다. 이것은 현재 상태를 저장하고 새 수준을 만든다(새 수준은 처음에는 옛 수준과
성질이 같다).

@<정의@>=
func push_input() { // 새 입력 수준에 들어가고, 옛것을 저장한다
	if input_ptr > max_in_stack {
		max_in_stack = input_ptr
		if input_ptr == stack_size {
			overflow("input stack size", stack_size)
		}
@:TeX capacity exceeded input stack size}{\quad input stack size@>
	}
	input_stack[input_ptr] = cur_input() // 레코드를 쌓는다
	input_ptr++
}

@ 그리고 물론 올라간 것은 내려와야 한다.

@<정의@>=
func pop_input() { // 입력 수준을 떠나 옛 수준에 다시 들어간다
	input_ptr--
	set_cur_input(input_stack[input_ptr])
}

@ 다음은 토큰 목록 |p|와 그 종류 |t|가 주어졌을 때 토큰 목록 입력의 새 수준을 시작하는 프로시저다.
종류 |t|가 |macro|이면 부르는 루틴이 |name|과 |loc|을 정해야 한다.

@<함수들@>=
func back_list(p pointer) { begin_token_list(p, backed_up) } // 간단한 토큰 목록을 되돌린다
func ins_list(p pointer)  { begin_token_list(p, inserted) } // 간단한 토큰 목록을 끼워 넣는다

func begin_token_list(p pointer, t quarterword) {
	push_input()
	state = token_list
	start = p
	set_token_type(t)
	if t >= macro { // 토큰 목록이 참조 횟수로 시작한다
		add_token_ref(p)
		if t == macro {
			set_param_start(param_ptr)
		} else {
			loc = link(p)
			if tracing_macros() > 1 {
				begin_diagnostic()
				print_nl("")
				switch t {
				case mark_text:
					print_esc("mark")
				case write_text:
					print_esc("write")
				default:
					print_cmd_chr(assign_toks, t-output_text+output_routine_loc)
				}
				print("->")
				token_show(p)
				end_diagnostic(false)
			}
		}
	} else {
		loc = p
	}
}

@ 토큰 목록을 다 훑었으면 그 입력 수준을 떠나면서 다음 계산을 해야 한다. 토큰 목록의 종류 |token_type|은 약 3분의 2의
경우에 |backed_up|이나 |inserted|와 같은 경향이 있다.
@^inner loop@>

@<함수들@>=
func end_token_list() { // 토큰 목록 입력 수준을 떠난다
	if token_type() >= backed_up { // 지울 토큰 목록
		if token_type() <= inserted {
			flush_list(start)
		} else {
			delete_token_ref(start) // 참조 횟수를 갱신한다
			if token_type() == macro { // 매개변수들을 지워야 한다
				for param_ptr > param_start() {
					param_ptr--
					flush_list(param_stack[param_ptr])
				}
			}
		}
	} else if token_type() == u_template {
		if align_state > 500000 {
			align_state = 0
		} else {
			fatal_error("(interwoven alignment preambles are not allowed)")
		}
	}
@.interwoven alignment preambles...@>
	pop_input()
	check_interrupt()
}

@ 때로 \TeX은 너무 많이 읽어서, 본 것을 ``되돌려 놓고''(unscan) 싶어 한다. 프로시저 |back_input|은 방금 훑은
토큰을 입력 흐름에 되돌려 놓아서 다시 읽을 수 있게 하여 이 일을 처리한다. 이 프로시저는 |cur_tok|이 되돌릴
토큰을 나타낼 때에만 쓸 수 있다. \TeX의 어떤 응용은 이 프로시저를 아주 많이 쓰므로, 속도를 위해 조금
최적화했다.
@^inner loop@>

@<함수들@>=
func back_input() { // 입력 토큰 하나를 되돌린다
	var p pointer // 길이가 1인 토큰 목록
	for state == token_list && loc == null && token_type() != v_template {
		end_token_list() // 스택 공간을 아낀다
	}
	p = get_avail()
	set_info(p, cur_tok)
	if cur_tok < right_brace_limit {
		if cur_tok < left_brace_limit {
			align_state--
		} else {
			align_state++
		}
	}
	push_input()
	state = token_list
	start = p
	set_token_type(backed_up)
	loc = p // 이것은 프로시저 부담 없이 한 |back_list(p)|다
}

@ @<토큰 |p|를 \TeX의...@>=
t = cur_tok
cur_tok = p
back_input()
cur_tok = t

@ 루틴 |back_error|는 오류 메시지를 내기 바로 전에 잘못된 토큰을 되돌려 놓고 싶을 때 쓴다. 이 루틴도
|back_input|처럼 |cur_tok|이 정해져 있어야 한다. 도움말을 잃지 않도록 |back_input|을 부르는 동안에는
끼어들기를 막는다.

@<함수들@>=
func back_error() { // 토큰 하나를 되돌리고 |error|를 부른다
	OK_to_interrupt = false
	back_input()
	OK_to_interrupt = true
	error()
}

func ins_error() { // 끼워 넣은 토큰 하나를 되돌리고 |error|를 부른다
	OK_to_interrupt = false
	back_input()
	set_token_type(inserted)
	OK_to_interrupt = true
	error()
}

@ 프로시저 |begin_file_reading|은 파일에서 읽을 문자 줄이나 터미널에서 끼워 넣을 것을 위한 입력의 새
수준을 시작한다. 파일을 여는 일은 맡지 않으며, |loc|이나 |limit|이나 |line|도 정하지 않는다.
@^system dependencies@>

@<함수들@>=
func begin_file_reading() {
	if in_open == max_in_open {
		overflow("text input levels", max_in_open)
	}
@:TeX capacity exceeded text input levels}{\quad text input levels@>
	if first == buf_size {
		overflow("buffer size", buf_size)
	}
@:TeX capacity exceeded buffer size}{\quad buffer size@>
	in_open++
	push_input()
	index = in_open
	line_stack[index] = line
	start = first
	state = mid_line
	name = 0 // 이제 |terminal_input|은 |true|다
}

@ 거꾸로, 그런 입력 수준이 끝나면 변수들을 되돌려 놓아야 한다.

@<함수들@>=
func end_file_reading() {
	first = start
	line = line_stack[index]
	if name > 17 {
		a_close(cur_file()) // 그것을 잊는다
	}
	pop_input()
	in_open--
}

@ 끼워 넣은 `\.{\\show}' 명령이 길게 이어지는 동안 스택이 넘치지 않도록, 다음 루틴은 오류 때 끼워 넣은
줄 가운데 다 읽은 것들을 메모리에서 없앤다.

@<함수들@>=
func clear_for_error_prompt() {
	for state != token_list && terminal_input() &&
		input_ptr > 0 && loc > limit {
		end_file_reading()
	}
	print_ln()
	clear_terminal()
}

@ \TeX의 입력 장치 전체를 움직이게 하려고 다음 동작들을 한다.

보충: 원본의 `|goto final_end|'는 주 프로그램 안의 레이블로 가는 보통의 |goto|다. 이 절은 주 프로그램에
펼쳐지기 때문이다(\os{1337}).

@<입력 루틴들을 초기화한다@>=
input_ptr = 0
max_in_stack = 0
in_open = 0
open_parens = 0
max_buf_stack = 0
param_ptr = 0
max_param_stack = 0
first = buf_size
for {
	buffer[first] = 0
	first--
	if first == 0 {
		break
	}
}
scanner_status = normal
warning_index = null
first = 1
state = new_line
start = 1
index = 0
line = 0
name = 0
force_eof = false
align_state = 1000000
if !init_terminal() {
	goto final_end
}
limit = last
first = last + 1 // |init_terminal|이 |loc|과 |last|를 정했다

@* 다음 토큰 얻기.
\TeX의 입력 장치의 심장은 프로시저 |get_next|이고, 이것을 다음 몇 절에서 개발하겠다. 그러나 이것을
``심장''이라고 부르면 안 될지도 모르겠다. 실은 원본 파일을 읽어서 삼키는 \TeX의 눈과 입 노릇을 하기
때문이다. 그리고 다시 처리해야 할 저장된 토큰 목록을 \TeX이 되새김질하는 것도 돕는다.
@^eyes and mouth@>

프로시저 |get_next|의 주된 임무는 토큰 하나를 입력해서 |cur_cmd|와 |cur_chr|를 그 토큰의 명령 코드와 수식어로
놓는 것이다. 게다가 입력 토큰이 제어 시퀀스면 그 제어 시퀀스의 |eqtb| 위치를 |cur_cs|에 저장한다. 그렇지
않으면 |cur_cs|를 0으로 놓는다.

이 간단한 묘사 밑에는 다루어야 할 온갖 경우 때문에 얼마쯤 복잡한 것이 깔려 있다. 그러나 |get_next|의 안쪽
루프는 꽤 짧고 빠르다.

명령 \.{\\read}가 읽는 줄의 다음 토큰을 얻으라는 요청을 받았는데 그 줄에 토큰이 더 나타나지 않으면, |get_next|는
|cur_cmd=cur_chr=cur_cs=0|으로 놓는다. (줄 끝 문자 |end_line_char|의 catcode가 |ignore|라면 토큰이 아예 없을 수도
있다.)

@ 변수 |par_loc|의 값은 `\.{\\par}'의 |eqtb| 주소다. 입력의 빈 줄은 \.{\\par}가 나타난 것과 정확히 같아야
하므로 이 양이 필요하다. 빈 줄을 알아채면 |cur_cs:=par_loc|으로 놓아야 한다.

@<전역 변수@>=
var @!par_loc pointer // |eqtb|에서 `\.{\\par}'의 위치
var @!par_token halfword // `\.{\\par}'를 나타내는 토큰

@ @<\TeX의 원시 명령을...@>=
primitive("par", par_end, 256) // |scan_file_name| 참조
@!@:par_}{\.{\\par} primitive@>
par_loc = cur_val
par_token = cs_token_flag + par_loc

@ @<원시 명령의 이름을 찍는...@>=
case par_end:
	print_esc("par")

@ 프로시저 |get_next|로 들어가기 전에, `\.{\\outer}' 제어 시퀀스를 훑었을 때나 파일의 끝에 이르렀을 때 불리는
서브루틴을 살펴보자. 이 두 경우는 |cur_cs|로 구별하는데, 파일의 끝에서는 |cur_cs|가 0이다.

@<함수들@>=
func check_outer_validity() {
	var p pointer // 끼워 넣은 토큰 목록을 가리킨다
	var q pointer // 보조 포인터
	if scanner_status != normal {
		deletions_allowed = false
		@<바깥 제어 시퀀스를 다시 읽을 수 있도록 되돌린다@>
		if scanner_status > skipping {
			@<무엇이 폭주했는지 사용자에게 알리고 회복해 본다@>
		} else {
			print_err("Incomplete ")
			print_cmd_chr(if_test, cur_if)
@.Incomplete \\if...@>
			print("; all text was ignored after line ")
			print_int(skip_line)
			help3("A forbidden control sequence occurred in skipped text.",
				"This kind of error happens when you say `\\if...' and forget",
				"the matching `\\fi'. I've inserted a `\\fi'; this might work.")
			if cur_cs != 0 {
				cur_cs = 0
			} else {
				help_line[2] = "The file ended while I was skipping conditional text."
			}
			cur_tok = cs_token_flag + frozen_fi
			ins_error()
		}
		deletions_allowed = true
	}
}

@ 명령 \.{\\read} 안에 나타난 바깥 제어 시퀀스는 다시 읽지 않는다. 그 명령의 오류 복구는 그리 강력하지 않기
때문이다.

@<바깥 제어 시퀀스를 다시...@>=
if cur_cs != 0 {
	if state == token_list || name < 1 || name > 17 {
		p = get_avail()
		set_info(p, cs_token_flag+cur_cs)
		back_list(p) // 제어 시퀀스를 다시 읽을 준비를 한다
	}
	cur_cmd = spacer
	cur_chr = ' ' // 그것을 공백으로 바꾼다
}

@ @<무엇이 폭주했는지...@>=
runaway() // 정의나 인자나 서문을 찍는다
if cur_cs == 0 {
	print_err("File ended")
@.File ended while scanning...@>
} else {
	cur_cs = 0
	print_err("Forbidden control sequence found")
@.Forbidden control sequence...@>
}
print(" while scanning ")
@<`\.{definition}'이나 `\.{use}'나 `\.{preamble}'이나 `\.{text}'를 찍고,
  회복으로 이끌 토큰들을 끼워 넣는다@>
print(" of ")
sprint_cs(warning_index)
help4("I suspect you have forgotten a `}', causing me",
	"to read past where you wanted me to stop.",
	"I'll try to recover; but if the error is serious,",
	"you'd better type `E' or `X' now and fix your file.")
error()

@ 회복 절차는 그만두어야 할 \TeX\ 루틴들에 관해 더 알지 못하면 완전히 이해할 수 없지만, 여기서 그 생각을
대강 그려 볼 수는 있다. 폭주한 정의나 폭주한 균형 텍스트에는 오른쪽 중괄호를 끼워 넣는다. 폭주한
서문에는 특별한 \.{\\cr} 토큰과 오른쪽 중괄호를 끼워 넣는다. 폭주한 인자에는 |long_state|를
|outer_call|로 놓고 \.{\\par}를 끼워 넣는다.

@<`\.{definition}'이나...@>=
p = get_avail()
switch scanner_status {
case defining:
	print("definition")
	set_info(p, right_brace_token+'}')
case matching:
	print("use")
	set_info(p, par_token)
	long_state = outer_call
case aligning:
	print("preamble")
	set_info(p, right_brace_token+'}')
	q = p
	p = get_avail()
	set_link(p, q)
	set_info(p, cs_token_flag+frozen_cr)
	align_state = -1000000
case absorbing:
	print("text")
	set_info(p, right_brace_token+'}')
} // 다른 경우는 없다
ins_list(p)

@ 여기서 |get_next|가 부를 수도 있는 프로시저 하나를 언급해야 한다.

보충: 원본은 여기서 |firm_up_the_line|을 |forward|로 선언한다. \GO/에서는 필요 없다.

@<함수들@>=
// |firm_up_the_line|은 \os{363}에서 정의한다

@ 이제 |get_next| 자체로 뛰어들 준비가 되었다. 이 루틴의 부분들은 \TeX의 다른 어떤 명령보다 자주
실행된다.
@^mastication@>@^inner loop@>

보충: 원본은 레이블 |switch|와 |start_cs|에 수 25와 26을 준다(\os{15}). \GO/에서 |switch|는 예약어이므로
레이블 이름은 \ID{switch\_}다.

@<함수들@>=
func get_next() { // |cur_cmd|, |cur_chr|, |cur_cs|를 다음 토큰으로 놓는다
	var k int32 // |buffer|의 첨자; |0..buf_size|
	var t halfword // 토큰
	var cat int32 // 대개 |cat_code(cur_chr)|; |0..max_char_code|
	var c, cc ASCII_code // 펼쳐질 수 있는 코드의 구성 요소
	var d int32 // 펼쳐진 코드에서 남는 문자의 수; |2..3|
restart: // 다음 입력 토큰을 얻으려면 여기로 간다
	cur_cs = 0
	if state != token_list {
		@<바깥 파일에서 입력하고, 입력이 없으면 |goto restart|@>
	} else {
		@<토큰 목록에서 입력하고, 목록이 끝났거나 매개변수를 펼쳐야 하면 |goto restart|@>
	}
	@<정렬 항목이 방금 끝났으면 알맞은 조치를 한다@>
}

@ 정렬 항목은 탭이나 \.{\\cr}이 나타났을 때 끝난다. 다만 현재의 중괄호 수준이 그 정렬 항목이 시작할 때의
수준과 같아야, 곧 |align_state|가 그 항목의 \<u_j> 틀 뒤에 가졌던 값으로 돌아와 있어야 한다.
@^inner loop@>

@<정렬 항목이 방금...@>=
if cur_cmd <= car_ret {
	if cur_cmd >= tab_mark {
		if align_state == 0 {
			@<\<v_j> 틀을 끼워 넣고 |goto restart|@>
		}
	}
}

@ 보충: 레이블 \ID{switch\_}로 가면 파일에서 다음 문자를 먹고, |reswitch|로 가면 그것을 다시 소화한다.
\GO/의 |goto|는 블록 안으로는 뛸 수 없지만 둘러싼 블록의 레이블로는 앞으로든 뒤로든 뛸 수 있다. 여기의
|goto|는 모두 그런 경우다.

@<바깥 파일에서 입력하고...@>=
@^inner loop@>
switch_: // 파일에서 다음 문자를 먹으려면 여기로 간다
if loc <= limit { // 현재 줄을 아직 다 읽지 않았다
	cur_chr = buffer[loc]
	loc++
reswitch: // 그것을 다시 소화하려면 여기로 간다
	cur_cmd = cat_code(cur_chr)
	@<필요하면 상태를 바꾸고, 무시할 문자면 |goto switch|, 다른 문자로
	  바뀌면 |goto reswitch|@>
} else {
	state = new_line
	@<파일의 다음 줄로 옮겨 가거나, 다음 줄이 없으면 |goto restart|,
	  \.{\\read} 줄이 끝났으면 |return|@>
	check_interrupt()
	goto switch_
}

@ 다음의 48갈래 전환은, 쓸 만한 \PASCAL\ 컴파일러가 코드를 옮겼다고 가정하면, 훑기를 빨리 해낸다.
상태 |mid_line|, |skip_blanks|, |new_line|의 수 값이 서로 |max_char_code+1|만큼씩 떨어져 있으므로, 문자의 명령
코드를 상태에 더하면 둘을 함께 나타내는 수 하나를 얻는다는 데 주목하라.

보충: 원본은 매크로 |any_state_plus(#)|로 세 경우 |mid_line+#|, |skip_blanks+#|, |new_line+#|를 한꺼번에
나타낸다. \GO/에서는 이것을 그대로 늘어놓았다.

@<필요하면 상태를 바꾸고...@>=
switch state + cur_cmd {
@<문자를 무시하는 경우들@>
case mid_line + escape, skip_blanks + escape, new_line + escape:
	@<제어 시퀀스를 훑고 |state:=skip_blanks|나 |mid_line|으로 놓는다@>
case mid_line + active_char, skip_blanks + active_char, new_line + active_char:
	@<능동 문자 제어 시퀀스를 처리하고 |state:=mid_line|으로 놓는다@>
case mid_line + sup_mark, skip_blanks + sup_mark, new_line + sup_mark:
	@<이 |sup_mark|가 \.{\^\^A}나 \.{\^\^df} 같은 펼친 문자를 시작하면
	  |goto reswitch|, 아니면 |state:=mid_line|@>
case mid_line + invalid_char, skip_blanks + invalid_char, new_line + invalid_char:
	@<잘못된 문자를 꾸짖고 |goto restart|@>
@<공백, 중괄호, 상태 변화가 얽힌 상황을 다룬다@>
default:
	// 아무것도 하지 않는다
}

@ 보충: 원본에서 이 절은 |case| 레이블의 목록이고, 그것을 쓰는 곳에서 `|: goto switch|'를 덧붙인다.
\.{gtangle}은 이름 있는 절의 앞뒤에서 줄을 바꾸므로(\os{58}) 레이블 목록만 따로 끼워 넣을 수는 없다.
그래서 이 절은 |case| 절 전체를 담는다.

@<문자를 무시하는...@>=
case mid_line + ignore, skip_blanks + ignore, new_line + ignore,
	skip_blanks + spacer, new_line + spacer:
	goto switch_

@ 오류를 처리하고 나면 |state|가 |token_list|일 수도 있으므로(|clear_for_error_prompt|를 보라)
\ID{switch\_}가 아니라 |restart|로 간다.

@<잘못된 문자를...@>=
print_err("Text line contains an invalid character")
@.Text line contains...@>
help2("A funny symbol that I can't read has just been input.",
	"Continue, and I'll forget that it ever happened.")
deletions_allowed = false
error()
deletions_allowed = true
goto restart

@ 보충: 원본의 매크로 |add_delims_to(#)|는 |#+math_shift|, |#+tab_mark|, |#+mac_param|, |#+sub_mark|,
|#+letter|, |#+other_char|의 여섯 경우를 나타낸다. \GO/에서는 마지막 |case|에 그대로 늘어놓았다.

@<공백, 중괄호, 상태 변화가...@>=
case mid_line + spacer:
	@<|skip_blanks| 상태에 들어가고 공백을 내보낸다@>
case mid_line + car_ret:
	@<줄을 끝내고 공백을 내보낸다@>
case skip_blanks + car_ret, mid_line + comment, skip_blanks + comment, new_line + comment:
	@<줄을 끝내고 |goto switch|@>
case new_line + car_ret:
	@<줄을 끝내고 \.{\\par}를 내보낸다@>
case mid_line + left_brace:
	align_state++
case skip_blanks + left_brace, new_line + left_brace:
	state = mid_line
	align_state++
case mid_line + right_brace:
	align_state--
case skip_blanks + right_brace, new_line + right_brace:
	state = mid_line
	align_state--
case skip_blanks + math_shift, skip_blanks + tab_mark, skip_blanks + mac_param,
	skip_blanks + sub_mark, skip_blanks + letter, skip_blanks + other_char,
	new_line + math_shift, new_line + tab_mark, new_line + mac_param,
	new_line + sub_mark, new_line + letter, new_line + other_char:
	state = mid_line

@ 형이 |spacer|인 문자가 통과하면 그 문자 코드는 $\.{"\ "}=@'40$으로 바뀐다. 이것은 탭과 공백, 그리고
줄 끝에 끼워 넣은 공백의 {\mc ASCII} 코드가 매크로 매개변수를 맞출 때 똑같이 다루어진다는 뜻이다. 이렇게
하는 것은 이런 문자들을 대부분의 컴퓨터 터미널 화면에서 구별할 수 없기 때문이다.

@<줄을 끝내고 공백을...@>=
loc = limit + 1
cur_cmd = spacer
cur_chr = ' '

@ 다음 코드는 |cur_cmd=spacer|일 때에만 실행된다.

@<|skip_blanks| 상태에...@>=
state = skip_blanks
cur_chr = ' '

@ @<줄을 끝내고 |goto switch|@>=
loc = limit + 1
goto switch_

@ @<줄을 끝내고 \.{\\par}를...@>=
loc = limit + 1
cur_cs = par_loc
cur_cmd = eq_type(cur_cs)
cur_chr = equiv(cur_cs)
if cur_cmd >= outer_call {
	check_outer_validity()
}

@ \.{\^\^8} 같은 코드는 뒤에 십육진 숫자가 오지 않으면 \.x가 된다는 데 주목하라.

@<이 |sup_mark|가...@>=
if cur_chr == buffer[loc] {
	if loc < limit {
		c = buffer[loc+1]
		if c < 0o200 { // 그렇다, 펼친 문자가 있다
			loc = loc + 2
			if is_hex(c) {
				if loc <= limit {
					cc = buffer[loc]
					if is_hex(cc) {
						loc++
						hex_to_cur_chr(c, cc)
						goto reswitch
					}
				}
			}
			if c < 0o100 {
				cur_chr = c + 0o100
			} else {
				cur_chr = c - 0o100
			}
			goto reswitch
		}
	}
}
state = mid_line

@ \dg 앞 절의 정의부를 옮긴다. 원본의 매크로 |hex_to_cur_chr|는 |get_next|의 지역 변수 |c|와 |cc|를
쓰므로, \GO/에서는 그것들을 인자로 받는다.

@<정의@>=
func is_hex(c ASCII_code) bool {
	return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f')
}

func hex_to_cur_chr(c, cc ASCII_code) {
	if c <= '9' {
		cur_chr = c - '0'
	} else {
		cur_chr = c - 'a' + 10
	}
	if cc <= '9' {
		cur_chr = 16*cur_chr + cc - '0'
	} else {
		cur_chr = 16*cur_chr + cc - 'a' + 10
	}
}

@ @<능동 문자 제어...@>=
cur_cs = cur_chr + active_base
cur_cmd = eq_type(cur_cs)
cur_chr = equiv(cur_cs)
state = mid_line
if cur_cmd >= outer_call {
	check_outer_validity()
}

@ 제어 시퀀스 이름은 어떤 파일의 줄에 나타날 때에만 훑는다. 한번 훑고 나면 그 |eqtb| 위치가 유일한
식별자 노릇을 하므로, \TeX은 그 등가물을 기호 꼴로 찍을 때 말고는 원래 이름을 더 참조할 필요가 없다.

제어 시퀀스를 훑는 프로그램은 악의적인 사용자가 `\.{\\catcode\'15=0}' 같은 것을 시도할 때 일어날 수
있는 폭발을 피하도록 조심스럽게 쓰였다. 이 알고리즘은 |buffer[limit+1]|은 들여다볼 수 있지만
|buffer[limit+2]|는 결코 들여다보지 않는다.

`\.{\^\^A}'나 `\.{\^\^df}' 같은 펼친 문자가 제어 시퀀스 이름 안이나 바로 뒤에 나타나면, 그것을 버퍼
안의 한 문자로 바꾸고 과정을 되풀이한다. 느리지만 확실하게.

@<제어 시퀀스를 훑고...@>=
if loc > limit {
	cur_cs = null_cs // 이 경우에 |state|는 상관없다
} else {
start_cs: // 제어 시퀀스를 찾기 시작하려면 여기로 간다
	k = loc
	cur_chr = buffer[k]
	cat = cat_code(cur_chr)
	k++
	if cat == letter {
		state = skip_blanks
	} else if cat == spacer {
		state = skip_blanks
	} else {
		state = mid_line
	}
	if cat == letter && k <= limit {
		@<버퍼에서 글자가 아닌 것을 찾을 때까지 앞서 훑는다@>
	} else {
		@<펼친 코드가 있으면 줄이고 |goto start_cs|@>
	}
	cur_cs = single_base + buffer[loc]
	loc++
}
found: // 제어 시퀀스를 찾았으면 여기로 간다
cur_cmd = eq_type(cur_cs)
cur_chr = equiv(cur_cs)
if cur_cmd >= outer_call {
	check_outer_validity()
}

@ 다음 코드에 이를 때면 언제나 |cur_chr=buffer[k-1]|이고 |k<=limit+1|이며 |cat=cat_code(cur_chr)|다.
\.{\^\^A}나 \.{\^\^df} 같은 펼친 코드가 |buffer[(k-1)..(k+1)]|이나 |buffer[(k-1)..(k+2)]|에 나타나면,
해당하는 코드를 |buffer[k-1]|에 저장하고 버퍼의 나머지를 왼쪽으로 두세 자리 옮긴다.

@<펼친 코드가 있으면...@>=
if buffer[k] == cur_chr {
	if cat == sup_mark {
		if k < limit {
			c = buffer[k+1]
			if c < 0o200 { // 그렇다, 정말로 하나 있다
				d = 2
				if is_hex(c) {
					if k+2 <= limit {
						cc = buffer[k+2]
						if is_hex(cc) {
							d++
						}
					}
				}
				if d > 2 {
					hex_to_cur_chr(c, cc)
					buffer[k-1] = cur_chr
				} else if c < 0o100 {
					buffer[k-1] = c + 0o100
				} else {
					buffer[k-1] = c - 0o100
				}
				limit = limit - d
				first = first - d
				for k <= limit {
					buffer[k] = buffer[k+d]
					k++
				}
				goto start_cs
			}
		}
	}
}

@ 보충: 이 절의 이름은 원본의 이름(``버퍼에서 글자가 아닌 것을 찾을 때까지 앞서 훑는다. 펼친 코드를 만나면
줄이고 |goto start_cs|, 여러 글자짜리 제어 시퀀스를 찾으면 |cur_cs|와 |loc|을 고치고 |goto found|'')보다
짧다.

@<버퍼에서 글자가 아닌...@>=
for {
	cur_chr = buffer[k]
	cat = cat_code(cur_chr)
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
	cur_cs = id_lookup(loc, k-loc)
	loc = k
	goto found
}

@ 이제 |get_next|가 토큰 목록을 보고 있을 때 무슨 일이 일어나는지 살펴보자.

@<토큰 목록에서 입력하고...@>=
if loc != null { // 목록을 다 쓰지 않았다
@^inner loop@>
	t = info(loc)
	loc = link(loc) // 다음으로 옮겨 간다
	if t >= cs_token_flag { // 제어 시퀀스 토큰
		cur_cs = t - cs_token_flag
		cur_cmd = eq_type(cur_cs)
		cur_chr = equiv(cur_cs)
		if cur_cmd >= outer_call {
			if cur_cmd == dont_expand {
				@<펼치기를 억누르고 다음 토큰을 얻는다@>
			} else {
				check_outer_validity()
			}
		}
	} else {
		cur_cmd = t / 0o400
		cur_chr = t % 0o400
		switch cur_cmd {
		case left_brace:
			align_state++
		case right_brace:
			align_state--
		case out_param:
			@<매크로 매개변수를 끼워 넣고 |goto restart|@>
		default:
			// 아무것도 하지 않는다
		}
	}
} else { // 이 토큰 목록은 다 썼다
	end_token_list()
	goto restart // 앞 수준으로 돌아간다
}

@ 프로그램의 지금 지점에는 루틴 |expand|가 입력에 특별한 표시를 끼워 넣었을 때에만 이른다. 이 특별한
경우에 |info(loc)|은 제어 시퀀스 토큰임이 알려져 있고, |link(loc)=null|이다.

@<펼치기를 억누르고...@>=
cur_cs = info(loc) - cs_token_flag
loc = null
cur_cmd = eq_type(cur_cs)
cur_chr = equiv(cur_cs)
if cur_cmd > max_command {
	cur_cmd = relax
	cur_chr = no_expand_flag
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const @!no_expand_flag = 257 // |relax|의 특별한 변종을 나타낸다

@ @<매크로 매개변수를...@>=
begin_token_list(param_stack[param_start()+cur_chr-1], parameter)
goto restart

@ 이제 |get_next|의 쉬운 갈래들은 모두 다루었다. 갈래가 하나 더 있다.

@<파일의 다음 줄로...@>=
if name > 17 {
	@<파일의 다음 줄을 |buffer|에 읽거나, 파일이 끝났으면 |goto restart|@>
} else {
	if !terminal_input() { // \.{\\read} 줄이 끝났다
		cur_cmd = 0
		cur_chr = 0
		return
	}
	if input_ptr > 0 { // 오류 복구 중에 끼워 넣은 텍스트
		end_file_reading()
		goto restart // 앞 수준으로 돌아간다
	}
	if selector < log_only {
		open_log_file()
	}
	if interaction > nonstop_mode {
		if end_line_char_inactive() {
			limit++
		}
		if limit == start { // 앞 줄이 비어 있었다
			print_nl("(Please type a command or say `\\end')")
		}
@.Please type...@>
		print_ln()
		first = start
		prompt_input("*") // 화면에서 |buffer|로 입력한다
@.*\relax@>
		limit = last
		if end_line_char_inactive() {
			limit--
		} else {
			buffer[limit] = end_line_char()
		}
		first = limit + 1
		loc = start
	} else {
		fatal_error("*** (job aborted, no legal \\end found)")
@.job aborted@>
		// 밤새 일괄 처리하려는 비멈춤 모드에서는 화면 입력을 결코 기다리지 않는다
	}
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
func end_line_char_inactive() bool { return end_line_char() < 0 || end_line_char() > 255 }

@ 전역 변수 |force_eof|는 보통 |false|이고, \.{\\endinput} 명령이 |true|로 놓는다.

@<전역 변수@>=
var @!force_eof bool // 다음 \.{\\input}을 일찍 그만두어야 하나?

@ @<파일의 다음 줄을...@>=
line++
first = start
if !force_eof {
	if input_ln(cur_file(), true) { // 파일의 끝이 아니다
		firm_up_the_line() // 이것이 |limit|를 정한다
	} else {
		force_eof = true
	}
}
if force_eof {
	print_char(')')
	open_parens--
	update_terminal() // 파일을 다 읽었음을 사용자에게 보인다
	force_eof = false
	end_file_reading() // 앞 수준으로 돌아간다
	check_outer_validity()
	goto restart
}
if end_line_char_inactive() {
	limit--
} else {
	buffer[limit] = end_line_char()
}
first = limit + 1
loc = start // 읽을 준비가 되었다

@ 사용자가 매개변수 |pausing|을 어떤 양수로 정했고 |nonstop_mode|를 고르지 않았다면, 입력의 각 줄을 터미널과
기록 파일에 보이고 그 뒤에 `\.{=>}'를 찍는다. \TeX은 대답을 기다린다. 대답이 그냥 |carriage_return|이면
그 줄을 그대로 받아들이고, 그렇지 않으면 파일의 줄 대신 사용자가 친 줄을 쓴다.

@<함수들@>=
func firm_up_the_line() {
	var k int32 // |buffer|의 첨자; |0..buf_size|
	limit = last
	if pausing() > 0 {
		if interaction > nonstop_mode {
			wake_up_terminal()
			print_ln()
			if start < limit {
				for k = start; k <= limit-1; k++ {
					print(buffer[k])
				}
			}
			first = limit
			prompt_input("=>") // 사용자의 대답을 기다린다
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

@ 프로시저 |get_next|는 \TeX에서 아주 자주 쓰이므로, 조금 더 많은 일을 하는 관련 프로시저 셋을 정의하면 편리하다.

\yskip\hang|get_token|은 |cur_cmd|와 |cur_chr|만이 아니라, 현재 토큰을 하프워드로 꾸린 판인 |cur_tok|도
정한다.

\yskip\hang|get_x_token|은 ``펼친 토큰을 얻는다''는 뜻으로, |get_token|과 같지만 현재 토큰이 사용자가 정의한
제어 시퀀스(곧 매크로 호출)나 조건문이나 \.{\\topmark}, \.{\\expandafter}, \.{\\csname} 같은 것으로
밝혀지면, 매크로의 펼침이나 조건문의 계산을 시작해서 그것을 입력에서 없앤다.

\yskip\hang|x_token|은 |get_x_token|과 같지만, |get_next|를 이미 불렀다고 가정한다.

\yskip\noindent
실제로 이 세 프로시저가 |get_next|의 쓰임새의 거의 전부를 차지한다.

@ 프로시저 |get_token|을 부르는 동안이나 \.{\\csname}이 토큰 목록을 압축할 때 말고는 새 제어 시퀀스가 정의되지
않는다. 다른 때에는 |no_new_control_sequence|가 언제나 |true|이기 때문이다.

@<함수들@>=
func get_token() { // |cur_cmd|, |cur_chr|, |cur_tok|를 정한다
	no_new_control_sequence = false
	get_next()
	no_new_control_sequence = true
@^inner loop@>
	if cur_cs == 0 {
		cur_tok = (cur_cmd * 0o400) + cur_chr
	} else {
		cur_tok = cs_token_flag + cur_cs
	}
}

@* 다음 토큰 펼치기.
프로시저 |get_next|가 돌려줄 수 있는 명령 코드 가운데 |>max_command|인 것은 열두어 개뿐이다. 커지는 차례로 그것들은
|undefined_cs|, |expand_after|, |no_expand|, |input|, |if_test|, |fi_or_else|, |cs_name|, |convert|,
|the|, |top_bot_mark|, |call|, |long_call|, |outer_call|, |long_outer_call|, |end_template|이다.

서브루틴 |expand|는 |cur_cmd>max_command|일 때 쓰인다. 이것은 ``호출''이나 조건문이나 방금 늘어놓은
다른 특별한 연산 가운데 하나를 없앤다. 그러므로 |expand|는 자기 자신을 재귀적으로 부를 수도 있다.
어떤 경우에든 |expand|는 현재 토큰을 없애지만, 다음 |get_next|가 알맞은 다음 토큰을 내주도록 준비해
둔다. 프로시저 |expand|를 부를 때 |cur_tok|의 값은 알 필요가 없다.

기본 훑기 루틴 몇몇은 전역 변수로 서로 소통하므로, 재귀 호출이 그 값을 망가뜨리지 않도록 |expand|의
지역 변수에 그 값들을 저장해 둔다.
@^recursion@>

보충: 원본은 여기서 |pass_text|, |start_input|, |conditional|, |get_x_token|, |conv_toks|,
|ins_the_toks|를 |forward|로 선언한다. \GO/에서는 필요 없다.

@<함수들@>=
@<|macro_call|이라는 프로시저를 선언한다@>
@<|insert_relax|라는 프로시저를 선언한다@>
func expand() {
	var t halfword // ``뒤에 펼쳐지는'' 토큰
	var p, q, r pointer // 목록을 다루기 위해
	var j int32 // |buffer|의 첨자; |0..buf_size|
	var cv_backup int32 // 전역 양 |cur_val|을 저장한다
	var cvl_backup, radix_backup, co_backup small_number // |cur_val_level| 따위를 저장한다
	var backup_backup pointer // |link(backup_head)|를 저장한다
	var save_scanner_status small_number // |scanner_status|를 잠시 저장한다
	cv_backup = cur_val
	cvl_backup = cur_val_level
	radix_backup = radix
	co_backup = cur_order
	backup_backup = link(backup_head)
	if cur_cmd < call {
		@<매크로가 아닌 것을 펼친다@>
	} else if cur_cmd < end_template {
		macro_call()
	} else {
		@<|frozen_endv|를 담은 토큰을 끼워 넣는다@>
	}
	cur_val = cv_backup
	cur_val_level = cvl_backup
	radix = radix_backup
	cur_order = co_backup
	set_link(backup_head, backup_backup)
}

@ @<매크로가 아닌 것을...@>=
if tracing_commands() > 1 {
	show_cur_cmd_chr()
}
switch cur_cmd {
case top_bot_mark:
	@<알맞은 표시 텍스트를 훑개에 끼워 넣는다@>
case expand_after:
	@<다음 토큰 뒤의 토큰을 펼친다@>
case no_expand:
	@<다음 토큰의 펼치기를 억누른다@>
case cs_name:
	@<제어 시퀀스 이름을 만들어 낸다@>
case convert:
	conv_toks() // 이 프로시저는 아래 27부에서 다룬다
case the:
	ins_the_toks() // 이 프로시저는 아래 27부에서 다룬다
case if_test:
	conditional() // 이 프로시저는 아래 28부에서 다룬다
case fi_or_else:
	@<현재 조건문을 끝내고 \.{\\fi}까지 건너뛴다@>
case input:
	@<파일에서 입력을 시작하거나 끝낸다@>
default:
	@<정의되지 않은 매크로를 불평한다@>
}

@ \TeX이 \.{\\expandafter}라고 부르는 일은 약간만 뒤섞으면 된다.

@<다음 토큰 뒤의...@>=
get_token()
t = cur_tok
get_token()
if cur_cmd > max_command {
	expand()
} else {
	back_input()
}
cur_tok = t
back_input()

@ 명령 \.{\\noexpand}의 구현은 조금 더 까다롭다. \TeX의 읽기 장치에 특별한 `|dont_expand|' 표시를 끼워 넣어야
하기 때문이다. 이 특별한 표시는 |get_next|가 처리하지만, 안쪽 루프를 느리게 하지는 않는다.

여기서 \.{\\outer} 매크로가 생길 수도 있으므로 |scanner_status|도 잠시 지워야 한다.

@<다음 토큰의 펼치기를...@>=
save_scanner_status = scanner_status
scanner_status = normal
get_token()
scanner_status = save_scanner_status
t = cur_tok
back_input() // 이제 |start|와 |loc|은 되돌린 토큰 |t|를 가리킨다
if t >= cs_token_flag {
	p = get_avail()
	set_info(p, cs_token_flag+frozen_dont_expand)
	set_link(p, loc)
	start = p
	loc = p
}

@ @<정의되지 않은 매크로를...@>=
print_err("Undefined control sequence")
@.Undefined control sequence@>
help5("The control sequence at the end of the top line",
	"of your error message was never \\def'ed. If you have",
	"misspelled it (e.g., `\\hobx'), type `I' and the correct",
	"spelling (e.g., `I\\hbox'). Otherwise just continue,",
	"and I'll forget about whatever was undefined.")
error()

@ 프로시저 |expand|와 토큰 목록을 만드는 다른 몇몇 루틴은 다음 매크로를 쓰면 편리하다. 이 매크로들은
변수 |p|와 |q|가 토큰 목록을 만드는 데 따로 쓰일 때에만 맞다.

보충: 원본의 매크로는 부르는 프로시저의 지역 변수 |p|와 |q|를 바꾼다. \GO/의 함수는 다른 함수의 지역
변수를 볼 수 없으므로, 이 둘을 \PASCAL의 \KW{var} 매개변수처럼 포인터로 받는다. 그래서 원본의
|store_new_token(cur_tok)|은 |store_new_token(&p,&q,cur_tok)|이 된다.

@<정의@>=
func store_new_token(p, q *pointer, t halfword) {
	*q = get_avail()
	set_link(*p, *q)
	set_info(*q, t)
	*p = *q // |link(p)|는 |null|이다
}

func fast_store_new_token(p, q *pointer, t halfword) {
	*q = fast_get_avail()
	set_link(*p, *q)
	set_info(*q, t)
	*p = *q // |link(p)|는 |null|이다
}

@ @<제어 시퀀스 이름을...@>=
r = get_avail()
p = r // 문자 목록의 머리
for {
	get_x_token()
	if cur_cs == 0 {
		store_new_token(&p, &q, cur_tok)
	}
	if cur_cs != 0 {
		break
	}
}
if cur_cmd != end_cs_name {
	@<\.{\\endcsname}이 빠졌다고 불평한다@>
}
@<목록 |r|의 문자들을 해시 표에서 찾아 |cur_cs|를 정한다@>
flush_list(r)
if eq_type(cur_cs) == undefined_cs {
	eq_define(cur_cs, relax, 256) // 주의: |save_stack|이 바뀔 수도 있다
} // 이제 그 제어 시퀀스는 `\.{\\relax}'와 맞는다
cur_tok = cur_cs + cs_token_flag
back_input()

@ @<\.{\\endcsname}이 빠졌다고...@>=
print_err("Missing ")
print_esc("endcsname")
print(" inserted")
@.Missing \\endcsname...@>
help2("The control sequence marked <to be read again> should",
	"not appear between \\csname and \\endcsname.")
back_error()

@ @<목록 |r|의 문자들을...@>=
j = first
p = link(r)
for p != null {
	if j >= max_buf_stack {
		max_buf_stack = j + 1
		if max_buf_stack == buf_size {
			overflow("buffer size", buf_size)
		}
@:TeX capacity exceeded buffer size}{\quad buffer size@>
	}
	buffer[j] = info(p) % 0o400
	j++
	p = link(p)
}
if j > first+1 {
	no_new_control_sequence = false
	cur_cs = id_lookup(first, j-first)
	no_new_control_sequence = true
} else if j == first {
	cur_cs = null_cs // 목록이 비어 있다
} else {
	cur_cs = single_base + buffer[first] // 목록의 길이가 1이다
}

@ 명령 |end_template|은 다음 코드로 사실상 |endv| 명령으로 바뀐다. (그 까닭은 아래에서 논의한다. 틀의
끝에 있는 |frozen_end_template|은 |check_outer_validity| 검사를 통과했으므로 오류를 찾아내는 임무는
이루었다.)

@<|frozen_endv|를 담은...@>=
cur_tok = cs_token_flag + frozen_endv
back_input()

@ 명령 \.{\\input}의 처리에는 서브루틴 |start_input|이 쓰이는데, 이것은 나중에 선언한다. 그리고 \.{\\endinput}의
처리는 하찮다.

@<\TeX의 원시 명령을...@>=
primitive("input", input, 0)
@!@:input_}{\.{\\input} primitive@>
primitive("endinput", input, 1)
@!@:end_input_}{\.{\\endinput} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case input:
	if chr_code == 0 {
		print_esc("input")
	} else {
		print_esc("endinput")
	}

@ @<파일에서 입력을 시작하거나...@>=
if cur_chr > 0 {
	force_eof = true
} else if name_in_progress {
	insert_relax()
} else {
	start_input()
}

@ 때로는 펼치기가 너무 앞을 내다보므로, 사용자의 입력에 해가 없는 \.{\\relax}를 끼워 넣고 싶다.

@<|insert_relax|라는...@>=
func insert_relax() {
	cur_tok = cs_token_flag + cur_cs
	back_input()
	cur_tok = cs_token_flag + frozen_relax
	back_input()
	set_token_type(inserted)
}

@ 다음은 \TeX이 입력의 다음 토큰을 얻는 보통의 방법인 재귀 프로시저다. 흔한 경우들을 고려해서 조금
최적화했다.

@<함수들@>=
func get_x_token() { // |cur_cmd|, |cur_chr|, |cur_tok|를 정하고 매크로를 펼친다
restart:
	get_next()
@^inner loop@>
	if cur_cmd <= max_command {
		goto done
	}
	if cur_cmd >= call {
		if cur_cmd < end_template {
			macro_call()
		} else {
			cur_cs = frozen_endv
			cur_cmd = endv
			goto done // |cur_chr=null_list|
		}
	} else {
		expand()
	}
	goto restart
done:
	if cur_cs == 0 {
		cur_tok = (cur_cmd * 0o400) + cur_chr
	} else {
		cur_tok = cs_token_flag + cur_cs
	}
}

@ 프로시저 |get_x_token|은 본질적으로 프로시저 호출 두 번, 곧 |get_next; x_token|과 같다.

@<함수들@>=
func x_token() { // 처음의 |get_next|가 없는 |get_x_token|
	for cur_cmd > max_command {
		expand()
		get_next()
	}
	if cur_cs == 0 {
		cur_tok = (cur_cmd * 0o400) + cur_chr
	} else {
		cur_tok = cs_token_flag + cur_cs
	}
}

@ 사용자가 \.{\\def}로 정의한 제어 시퀀스는 \TeX의 프로시저 |macro_call|이 펼친다.

그러나 |macro_call|의 자세한 내용에 들어가기 전에 \.{\\topmark} 같은 원시 명령의 처리를 살펴보자.
이것들은 본질적으로 매개변수 없는 매크로이기 때문이다. 이런 표시의 토큰 목록은 포인터 다섯 개짜리 전역
배열에 둔다. 이 배열의 낱낱의 항목은 |top_mark| 따위의 기호 이름으로 가리킨다. 항목 |top_mark|의 값은
|null|이거나 토큰 목록의 참조 횟수를 가리키는 포인터다.

보충: 이름 |top_mark| 따위는 배열 원소의 다른 이름이므로, \GO/에서는 다른 필드 매크로처럼 읽는 함수와
쓰는 함수의 짝(이를테면 |top_mark()|와 |set_top_mark(v)|)이 된다. 원소를 첨자로 훑는 곳에서는
|cur_mark[c]|를 바로 쓴다.

@<전역 변수@>=
const (
	@!top_mark_code = 0 // 앞 쪽 나눔에서 효력이 있는 표시
	@!first_mark_code = 1 // |top_mark|와 |bot_mark| 사이의 첫 표시
	@!bot_mark_code = 2 // 현재 쪽 나눔에서 효력이 있는 표시
	@!split_first_mark_code = 3 // \.{\\vsplit}이 찾은 첫 표시
	@!split_bot_mark_code = 4 // \.{\\vsplit}이 찾은 마지막 표시
)

func top_mark() pointer         { return cur_mark[top_mark_code] }
func first_mark() pointer       { return cur_mark[first_mark_code] }
func bot_mark() pointer         { return cur_mark[bot_mark_code] }
func split_first_mark() pointer { return cur_mark[split_first_mark_code] }
func split_bot_mark() pointer   { return cur_mark[split_bot_mark_code] }
func set_top_mark(v pointer)         { cur_mark[top_mark_code] = v }
func set_first_mark(v pointer)       { cur_mark[first_mark_code] = v }
func set_bot_mark(v pointer)         { cur_mark[bot_mark_code] = v }
func set_split_first_mark(v pointer) { cur_mark[split_first_mark_code] = v }
func set_split_bot_mark(v pointer)   { cur_mark[split_bot_mark_code] = v }

var @!cur_mark [split_bot_mark_code + 1]pointer // 표시들의 토큰 목록

@ @<핵심 변수들의...@>=
cur_mark[top_mark_code] = null
cur_mark[first_mark_code] = null
cur_mark[bot_mark_code] = null
cur_mark[split_first_mark_code] = null
cur_mark[split_bot_mark_code] = null

@ @<\TeX의 원시 명령을...@>=
primitive("topmark", top_bot_mark, top_mark_code)
@!@:top_mark_}{\.{\\topmark} primitive@>
primitive("firstmark", top_bot_mark, first_mark_code)
@!@:first_mark_}{\.{\\firstmark} primitive@>
primitive("botmark", top_bot_mark, bot_mark_code)
@!@:bot_mark_}{\.{\\botmark} primitive@>
primitive("splitfirstmark", top_bot_mark, split_first_mark_code)
@!@:split_first_mark_}{\.{\\splitfirstmark} primitive@>
primitive("splitbotmark", top_bot_mark, split_bot_mark_code)
@!@:split_bot_mark_}{\.{\\splitbotmark} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case top_bot_mark:
	switch chr_code {
	case first_mark_code: print_esc("firstmark")
	case bot_mark_code: print_esc("botmark")
	case split_first_mark_code: print_esc("splitfirstmark")
	case split_bot_mark_code: print_esc("splitbotmark")
	default: print_esc("topmark")
	}

@ 다음 코드는 |cur_cmd=top_bot_mark|이고 |cur_chr|가 |top_mark_code| 같은 코드일 때 작동한다.

@<알맞은 표시 텍스트를...@>=
if cur_mark[cur_chr] != null {
	begin_token_list(cur_mark[cur_chr], mark_text)
}

@ 이제 |macro_call| 자체를 살펴보자. 이 프로시저는 \TeX이 |cur_cmd|가 |call|, |long_call|,
|outer_call|, |long_outer_call| 가운데 하나인 제어 시퀀스를 훑고 있을 때 불린다. 그 제어 시퀀스의 정의는
참조 횟수가 |mem|의 위치 |cur_chr|에 있는 토큰 목록에 나타난다.

전역 변수 |long_state|는 그 제어 시퀀스가 매개변수 안에 \.{\\par}를 허용하지 않는지 아닌지에 따라 |call|이나
|long_call|로 놓인다. 루틴 |get_next|는 인자 한가운데에서 파일이 끝나거나 \.{\\outer} 제어 시퀀스가
나타나면 |long_state|를 |outer_call|로 놓고 \.{\\par}를 내보낸다.

@<전역 변수@>=
var @!long_state int32 // \.{\\par}를 받아들일지 다스린다; |call..long_outer_call|

@ 매개변수가 있다면 매크로를 펼치기 전에 훑어야 한다. 매개변수는 참조 횟수가 없는 토큰 목록이다. 이것들은
훑는 동안 |pstack|이라는 보조 스택에 놓인다. 맞추는 과정에서 |param_stack|이 항목을 잃을 수도 있기
때문이다. (스택 |param_stack|이 항목을 얻을 수는 없다는 데 주목하라. 이 스택에 무언가를 넣는 루틴은
|macro_call|뿐이고, 그것은 재귀적이지 않기 때문이다.)

@<전역 변수@>=
var @!pstack [9]pointer // 매크로에 주어진 인자들

@ 매개변수 훑기가 끝나면 매개변수들을 |param_stack|으로 옮긴다. 그런 다음 매크로 몸체를 훑개에 먹인다.
다시 말해 |macro_call|은 제어 시퀀스의 정의된 텍스트를 \TeX의 입력 스택 맨 위에 놓아서 |get_next|가 다음에
그것을 읽게 한다.

전역 변수 |cur_cs|에는 |macro_call|이 시작할 때 펼치고 있는 제어 시퀀스의 |eqtb| 주소가 들어 있다. 이 제어
시퀀스가 \.{\\long}으로 선언되지 않았다면, 곧 |eq_type| 필드의 명령 코드가 |long_call|이나
|long_outer_call|이 아니라면, 그 매개변수에는 제어 시퀀스 \.{\\par}가 들어 있으면 안 된다. 허용되지 않는
\.{\\par}가 나타나면 매크로 호출을 그만두고 \.{\\par}를 다시 훑는다.

보충: 원본의 |return|은 레이블 |exit|로 가는데, 이 프로시저에서는 |exit| 뒤에 저장해 둔 값들을 되살리는
문장이 있다. 그래서 \GO/에서도 |return| 대신 |goto exit|를 쓴다.

@<|macro_call|이라는...@>=
func macro_call() { // 사용자가 정의한 제어 시퀀스를 부른다
	var r pointer // 매크로의 토큰 목록에서 현재 노드
	var p pointer // 만들고 있는 매개변수 토큰 목록의 현재 노드
	var q pointer // 토큰 목록에 넣을 새 노드
	var s pointer // 매개변수 맞추기를 위한 되돌림 포인터
	var t pointer // 되돌림 복구를 위한 순환 포인터
	var u, v pointer // 되돌림 복구를 위한 보조 포인터
	var rbrace_ptr pointer // 마지막 |right_brace| 토큰의 한 걸음 앞
	var n small_number // 훑은 매개변수의 수
	var unbalance halfword // 현재 매개변수에서 짝이 맞지 않는 왼쪽 중괄호
	var m halfword // 토큰이나 그룹의 수(대개)
	var ref_count pointer // 토큰 목록의 시작
	var save_scanner_status small_number // 들어올 때의 |scanner_status|
	var save_warning_index pointer // 들어올 때의 |warning_index|
	var match_chr ASCII_code // 매개변수에 쓰인 문자
	save_scanner_status = scanner_status
	save_warning_index = warning_index
	warning_index = cur_cs
	ref_count = cur_chr
	r = link(ref_count)
	n = 0
	if tracing_macros() > 0 {
		@<펼치는 매크로의 텍스트를 보인다@>
	}
	if info(r) != end_match_token {
		@<매개변수들을 훑고 |link(r)|이 매크로 몸체를 가리키게 한다@>
	}
	@<매크로 몸체와 그 매개변수들을 훑개에 먹인다@>
exit:
	scanner_status = save_scanner_status
	warning_index = save_warning_index
}

@ 입력 스택에 새 토큰 목록을 올리기 전에, 최근에 바닥난 토큰 목록들을 모두 치우는 것이 현명하다. 그러면
자기 자신을 부르는 것으로 끝나는 사용자 매크로가 스택 공간을 끝없이 요구하지 않는다.

@<매크로 몸체와 그...@>=
for state == token_list && loc == null && token_type() != v_template {
	end_token_list() // 스택 공간을 아낀다
}
begin_token_list(ref_count, macro)
name = warning_index
loc = link(r)
if n > 0 {
	if param_ptr+n > max_param_stack {
		max_param_stack = param_ptr + n
		if max_param_stack > param_size {
			overflow("parameter stack size", param_size)
		}
@:TeX capacity exceeded parameter stack size}{\quad parameter stack size@>
	}
	for m = 0; m <= n-1; m++ {
		param_stack[param_ptr+m] = pstack[m]
	}
	param_ptr = param_ptr + n
}

@ 여기서 독자는 앞에서 보인 토큰 목록 형식의 설명을 다시 훑어보는 것이 좋겠다. 그 형식의 많은 면은 주로
|macro_call| 루틴에서 중요하기 때문이다.

토큰 목록은 첫 |match|나 |end_match| 앞에 반드시 와야 할 토큰들의 문자열로 시작할 수도 있다. 그런 경우 매크로
이름 뒤에는 그 토큰들이 와야 한다. 다음 프로그램은 이 제약을 나타내려고 |s=null|로 놓는다. 그렇지 않으면
포인터 |s|는 다음 매개변수를 구분할 문자열의 첫 토큰으로 놓인다.

보충: 원본의 이름은 ``매개변수들을 훑고 |link(r)|이 매크로 몸체를 가리키게 한다. 그러나 허용되지 않는
\.{\\par}를 찾으면 |return|''이다.

@<매개변수들을 훑고...@>=
scanner_status = matching
unbalance = 0
long_state = eq_type(cur_cs)
if long_state >= outer_call {
	long_state = long_state - 2
}
for {
	set_link(temp_head, null)
	if info(r) > match_token+255 || info(r) < match_token {
		s = null
	} else {
		match_chr = info(r) - match_token
		s = link(r)
		r = s
		p = temp_head
		m = 0
	}
	@<구분 문자열을 찾을 때까지 매개변수 하나를 훑는다@>
	// 이제 |info(r)|은 명령 코드가 |match|나 |end_match|인 토큰이다
	if info(r) == end_match_token {
		break
	}
}

@ 토큰 |info(r)|이 |match|나 |end_match| 명령이면, 그것은 |get_token|이 찾은 어떤 토큰과도 같을 수 없다. 그러므로
구분되지 않은 매개변수, 곧 |match| 바로 뒤에 |match|나 |end_match|가 오는 것은 다음 알고리즘에서 언제나
`|cur_tok=info(r)|' 검사에 실패한다.

보충: 원본의 이름은 ``구분 문자열을 찾을 때까지 매개변수 하나를 훑는다. 또는 |s=null|이면 그냥 구분
문자열을 훑는다''이다. 레이블 \ID{continue\_}는 원본의 \ID{continue}다(\os{15}).

@<구분 문자열을 찾을 때까지...@>=
continue_:
get_token() // |cur_tok|을 입력의 다음 토큰으로 놓는다
if cur_tok == info(r) {
	@<|r|을 나아가게 하고, 구분자가 다 맞았으면 |goto found|, 아니면 |goto continue|@>
}
@<최근에 맞춘 토큰들을 현재 매개변수에 보태고, 부분적으로 맞은 상태면 |goto continue|@>
if cur_tok == par_token {
	if long_state != long_call {
		@<폭주한 인자를 알리고 그만둔다@>
	}
}
if cur_tok < right_brace_limit {
	if cur_tok < left_brace_limit {
		@<그룹 전체를 현재 매개변수에 보탠다@>
	} else {
		@<남는 오른쪽 중괄호를 알리고 |goto continue|@>
	}
} else {
	@<현재 토큰을 저장하되, 구분되지 않는 매개변수가 될 공백이면 |goto continue|@>
}
m++
if info(r) > end_match_token {
	goto continue_
}
if info(r) < match_token {
	goto continue_
}
found:
if s != null {
	@<방금 훑은 매개변수를 정리해서 넣어 둔다@>
}

@ @<현재 토큰을 저장하되...@>=
if cur_tok == space_token {
	if info(r) <= end_match_token {
		if info(r) >= match_token {
			goto continue_
		}
	}
}
store_new_token(&p, &q, cur_tok)

@ 여기서 조금 미묘한 점이 생긴다. 매개변수 구분자가 `\.{\#\{}'로 끝나면, 토큰 목록에는 |end_match|\kern-.4pt의
앞뒤에 모두 왼쪽 중괄호가 있다. 그 가운데 하나만 |align_state|에 영향을 주어야 하지만 둘 다 훑게 되므로
바로잡아야 한다.

@<|r|을 나아가게 하고...@>=
r = link(r)
if info(r) >= match_token && info(r) <= end_match_token {
	if cur_tok < left_brace_limit {
		align_state--
	}
	goto found
} else {
	goto continue_
}

@ @<남는 오른쪽 중괄호를...@>=
back_input()
print_err("Argument of ")
sprint_cs(warning_index)
@.Argument of \\x has...@>
print(" has an extra }")
help6("I've run across a `}' that doesn't seem to match anything.",
	"For example, `\\def\\a#1{...}' and `\\a}' would produce",
	"this error. If you simply proceed now, the `\\par' that",
	"I've just inserted will cause me to report a runaway",
	"argument that might be the root of the problem. But if",
	"your `}' was spurious, just type `2' and it will go away.")
align_state++
long_state = call
cur_tok = par_token
ins_error()
goto continue_ // 선의의 거짓말; \.{\\par}가 언제나 폭주를 일으키지는 않는다

@ 상태가 |long_state=outer_call|이면 폭주한 인자는 이미 알렸다.

@<폭주한 인자를 알리고...@>=
if long_state == call {
	runaway()
	print_err("Paragraph ended before ")
@.Paragraph ended before...@>
	sprint_cs(warning_index)
	print(" was complete")
	help3("I suspect you've forgotten a `}', causing me to apply this",
		"control sequence to too much text. How can we recover?",
		"My plan is to forget the whole thing and hope for the best.")
	back_error()
}
pstack[n] = link(temp_head)
align_state = align_state - unbalance
for m = 0; m <= n; m++ {
	flush_list(pstack[m])
}
goto exit

@ 다음 코드가 작동할 때, 우리는 |s|부터 |r|의 앞 노드까지의 토큰들을 맞추었고 |cur_tok!=info(r)|임을
알게 된 것이다. 이제 흥미로운 상황이 생긴다. 매개변수를 `\.{ab}' 같은 문자열로 구분해야 하는데 `\.{aa}'를
훑었다면, `\.a' 하나를 현재 매개변수에 보태고 `\.b'를 다시 찾아야 한다. 프로그램은 그런 부분적 맞춤을,
그리고 아주 복잡할 수도 있는 다른 경우들을 고려해야 한다. 그러나 대개는 |s=r|이어서 아무것도 할 필요가
없다.

덧붙여 말하면, \.{\\long}이 아닌 매크로의 어떤 매개변수에는 \.{\\par} 토큰이 몰래 끼어들 수 있다. 이를테면
`\.{\\def\\a\#1\\par!\{...\}}'에서 첫 \.{\\par} 뒤에 느낌표가 오지 않는 경우를 생각해 보라. 그런 상황에서
\.{\\par}를 금지하는 것은 알맞아 보이지 않으므로, \TeX은 이 규칙 위반에 대해 입을 다문다.

보충: 원본의 이름은 ``최근에 맞춘 토큰들을 현재 매개변수에 보태고, 부분적으로 맞은 상태가 아직
유효하면 |goto continue|. 그러나 |s=null|이면 그만둔다''이다.

@<최근에 맞춘 토큰들을...@>=
if s != r {
	if s == null {
		@<매크로를 잘못 썼다고 알리고 그만둔다@>
	} else {
		t = s
		for {
			store_new_token(&p, &q, info(t))
			m++
			u = link(t)
			v = s
			for {
				if u == r {
					if cur_tok != info(v) {
						goto done
					} else {
						r = link(v)
						goto continue_
					}
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

@ @<매크로를 잘못 썼다고...@>=
print_err("Use of ")
sprint_cs(warning_index)
@.Use of x doesn't match...@>
print(" doesn't match its definition")
help4("If you say, e.g., `\\def\\a1{...}', then you must always",
	"put `1' after `\\a', since control sequence names are",
	"made up of letters only. The macro here has not been",
	"followed by the required stuff, so I'm ignoring it.")
error()
goto exit

@ @<그룹 전체를 현재...@>=
unbalance = 1
@^inner loop@>
for {
	fast_store_new_token(&p, &q, cur_tok)
	get_token()
	if cur_tok == par_token {
		if long_state != long_call {
			@<폭주한 인자를 알리고...@>
		}
	}
	if cur_tok < right_brace_limit {
		if cur_tok < left_brace_limit {
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
rbrace_ptr = p
store_new_token(&p, &q, cur_tok)

@ 매개변수가 중괄호로 둘러싼 그룹 하나로 이루어져 있으면 둘러싼 중괄호를 떼어 내야 한다. 변수 |rbrace_ptr|를
도입한 것은 이 때문이다.

@<방금 훑은 매개변수를...@>=
if m == 1 && info(p) < right_brace_limit {
	set_link(rbrace_ptr, null)
	free_avail(p)
	p = link(temp_head)
	pstack[n] = link(p)
	free_avail(p)
} else {
	pstack[n] = link(temp_head)
}
n++
if tracing_macros() > 0 {
	begin_diagnostic()
	print_nl(match_chr)
	print_int(n)
	print("<-")
	show_token_list(pstack[n-1], null, 1000)
	end_diagnostic(false)
}

@ @<펼치는 매크로의...@>=
begin_diagnostic()
print_ln()
print_cs(warning_index)
token_show(ref_count)
end_diagnostic(false)

@* 기본 훑기 서브루틴.
이제 \TeX이 입력에서 어떤 종류의 패턴을 소화하려고 자주 부르는 프로시저들로 넘어가자. 그 대부분은 아주
간단하지만, 몇몇은 꽤 정교하다. 거의 모든 루틴이 |get_x_token|을 부르는데, 그 때문에 이 루틴들이
재귀적으로 불릴 수 있다.
@^stomach@>
@^recursion@>

@ 루틴 |scan_left_brace|는 다음의 공백 아닌 토큰이 왼쪽 중괄호여야 할 때 불린다. (``왼쪽 중괄호''라는
말은 더 정확히는 catcode가 |left_brace|인 문자를 뜻한다.) \TeX은 |left_brace| 앞에 \.{\\relax}가 나타나도
괜찮다고 본다.

@<함수들@>=
func scan_left_brace() { // 반드시 와야 할 |left_brace|를 읽는다
	@<공백도 relax도 호출도 아닌 다음 토큰을 얻는다@>
	if cur_cmd != left_brace {
		print_err("Missing { inserted")
@.Missing \{ inserted@>
		help4("A left brace was mandatory here, so I've put one in.",
			"You might want to delete and/or insert some corrections",
			"so that I will find a matching right brace soon.",
			"(If you're confused by all this, try typing `I}' now.)")
		back_error()
		cur_tok = left_brace_token + '{'
		cur_cmd = left_brace
		cur_chr = '{'
		align_state++
	}
}

@ @<공백도 relax도 호출도...@>=
for {
	get_x_token()
	if cur_cmd != spacer && cur_cmd != relax {
		break
	}
}

@ 루틴 |scan_optional_equals|는 선택적인 공백들 다음에 오는 선택적인 `\.=' 기호를 찾는다. 여기서는
`\.{\\relax}'를 무시하지 않는다.

@<함수들@>=
func scan_optional_equals() {
	@<공백도 호출도 아닌 다음 토큰을 얻는다@>
	if cur_tok != other_token+'=' {
		back_input()
	}
}

@ @<공백도 호출도 아닌...@>=
for {
	get_x_token()
	if cur_cmd != spacer {
		break
	}
}

@ 지루해지기 시작했다면, 여기 조금 덜 하찮은 루틴이 있다. `\.{pt}'나 `\.{plus}'나 `\.{width}' 같은 소문자
문자열이 주어지면, 루틴 |scan_keyword|는 입력의 다음 토큰들이 이 문자열과 맞는지 검사한다. 맞춤은
정확해야 하지만, 대문자는 그에 해당하는 소문자와 맞는다. 대문자 등가물은 |uc_code| 표를 쓰지 않고
|"a"-"A"|를 빼서 정한다. \TeX은 이 루틴을 자기 자신의 한정된 키워드 집합에만 쓰기 때문이다.

맞는 것을 찾으면 그 문자들은 사실상 입력에서 지워지고 |true|를 돌려준다. 그렇지 않으면 |false|를
돌려주고 입력은 본질적으로 바뀌지 않은 채 남는다(어떤 매크로가 펼쳐졌을 수 있다는 사실 따위를
빼면).
@^inner loop@>

보충: 원본의 |s|는 풀 문자열의 번호이고 |k|는 |str_pool|의 첨자이다. 키워드는 언제나 문자열 상수이므로,
여기서 |s|는 \GO/ 문자열이고 |k|는 그 문자열의 첨자이다.

@<함수들@>=
func scan_keyword(s string) bool { // 주어진 문자열을 찾는다
	var p pointer // 되돌림 목록의 꼬리
	var q pointer // |store_new_token|으로 토큰 목록에 보탤 새 노드
	var k int // |s|의 첨자
	p = backup_head
	set_link(p, null)
	k = 0
	for k < len(s) {
		get_x_token() // 여기서 재귀가 일어날 수 있다
@^recursion@>
		if cur_cs == 0 &&
			(cur_chr == ASCII_code(s[k]) || cur_chr == ASCII_code(s[k])-'a'+'A') {
			store_new_token(&p, &q, cur_tok)
			k++
		} else if cur_cmd != spacer || p != backup_head {
			back_input()
			if p != backup_head {
				back_list(link(backup_head))
			}
			return false
		}
	}
	flush_list(link(backup_head))
	return true
}

@ 다음은 mu 단위와 mu가 아닌 단위가 바뀔 때 경보를 울리는 프로시저다.

@<함수들@>=
func mu_error() {
	print_err("Incompatible glue units")
@.Incompatible glue units@>
	help1("I'm going to assume that 1mu=1pt when they're mixed.")
	error()
}

@ 다음 루틴 `|scan_something_internal|'은 `\.{\\hsize}' 같은 내부 양을 가져오는 데 쓰이고, `\.{\\the\\toks0}'와
`\.{\\the\\baselineskip}' 같은 구성을 펼칠 때 `\.{\\the}'를 처리하는 데에도 쓰인다. 곧 |scan_int| 프로시저를
살펴볼 텐데, 이것은 |scan_something_internal|을 부른다. 한편 |scan_something_internal|도
`\.{\\catcode\`\\\$}'나 `\.{\\fontdimen} \.3 \.{\\ff}' 같은 구성을 위해 |scan_int|를 부른다. 그래서 우리는
|scan_int|를 |forward| 프로시저로 선언해야 한다. 다른 프로시저 몇 개도 여기서 선언한다.

@<함수들@>=
@<제한된 종류의 정수를 훑는 프로시저들을 선언한다@>
@<글꼴에 관련된 것을 훑는 프로시저들을 선언한다@>

@ \TeX은 |scan_something_internal|이 시작할 때 무엇을 기대해야 할지 정확히 모른다. 이를테면 `\.{\\hskip}'
바로 뒤에는 정수나 치수나 글루 값이 올 수 있다. 또 `\.{\\xdef\\o\{\\the\\output\}}' 같은 구성에서는 토큰 목록에
대해서도 \.{\\the}라고 할 수 있다. 한편 `\.{\\count}' 같은 구성 뒤에는 정수만 허용된다. 여러 가능성을
다루려고 |scan_something_internal|에는 매개변수 |level|이 있는데, 이것은 |scan_something_internal|이 만들어
낼 수 있는 가장 ``높은'' 종류의 양을 알려 준다. 수준은 여섯 가지, 곧 |int_val|, |dimen_val|, |glue_val|,
|mu_val|, |ident_val|, |tok_val|로 구별된다.

프로시저 |scan_something_internal|의 출력(그리고 아래의 다른 루틴 |scan_int|, |scan_dimen|, |scan_glue|의 출력)은
전역 변수 |cur_val|에 들어가고, 그 수준은 |cur_val_level|에 들어간다. 변수 |cur_val_level|의 가장 높은
값들은 특별하다. 수준 |mu_val|은 |cur_val|이 ``muskip'' 레지스터 안의 무언가나 세 매개변수 \.{\\thinmuskip},
\.{\\medmuskip}, \.{\\thickmuskip} 가운데 하나를 가리킬 때에만 쓰인다. 수준 |ident_val|은 |cur_val|이 글꼴
식별자를 가리킬 때에만 쓰인다. 수준 |tok_val|은 |cur_val|이 |null|이나 토큰 목록의 참조 횟수를 가리킬 때에만
쓰인다. 마지막 두 경우는 |scan_something_internal|이 |level=tok_val|로 불렸을 때에만 허용된다.

출력이 글루라면 |cur_val|은 글루 명세를 가리키고, 그 글루의 참조 횟수는 이 참조를 반영하도록 갱신되어
있을 것이다. 출력이 비어 있지 않은 토큰 목록이면 |cur_val|은 그 참조 횟수를 가리키지만, 이 경우에는 횟수가
갱신되지 않는다. 그 밖에는 |cur_val|에 해당하는 정수 값이나 눈금 값이 들어 있다.

@<전역 변수@>=
const (
	@!int_val = 0 // 정수 값
	@!dimen_val = 1 // 치수 값
	@!glue_val = 2 // 글루 명세
	@!mu_val = 3 // 수식 글루 명세
	@!ident_val = 4 // 글꼴 식별자
	@!tok_val = 5 // 토큰 목록
)

var @!cur_val int32 // 수 훑기 루틴이 돌려주는 값
var @!cur_val_level int32 // 이 값의 ``수준''; |int_val..tok_val|

@ 해시 표는 `\.{\\count}', `\.{\\dimen}', `\.{\\skip}', `\.{\\muskip}'이 모두 |register|를 명령 코드로 갖도록
초기화된다. 이것들은 |chr_code|로 구별하는데, |chr_code|는 |int_val|, |dimen_val|, |glue_val|, |mu_val|
가운데 하나다.

@<\TeX의 원시 명령을...@>=
primitive("count", register, int_val)
@!@:count_}{\.{\\count} primitive@>
primitive("dimen", register, dimen_val)
@!@:dimen_}{\.{\\dimen} primitive@>
primitive("skip", register, glue_val)
@!@:skip_}{\.{\\skip} primitive@>
primitive("muskip", register, mu_val)
@!@:mu_skip_}{\.{\\muskip} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case register:
	if chr_code == int_val {
		print_esc("count")
	} else if chr_code == dimen_val {
		print_esc("dimen")
	} else if chr_code == glue_val {
		print_esc("skip")
	} else {
		print_esc("muskip")
	}

@ 이제 |scan_something_internal| 자체를 볼 준비가 되었다. 둘째 매개변수 |negative|는 찾은 값의 부호를 바꾸어야
하면 |true|로 놓인다. 변수 |cur_cmd|와 |cur_chr|는 훑을 내부 양의 첫 토큰을 나타낸다고 가정한다.
명령 코드가 |cur_cmd<min_internal|이거나 |cur_cmd>max_internal|이면 오류를 알린다.

보충: 원본의 매크로 |scanned_result(#1)(#2)|는 |cur_val:=#1; cur_val_level:=#2|다. \GO/에서는 인자 둘을 받는
함수다.

@<함수들@>=
func scan_something_internal(level small_number, negative bool) { // 내부 매개변수를 가져온다
	var m halfword // 피연산자 토큰의 |chr_code| 부분
	var p int32 // |nest|의 첨자; |0..nest_size|
	m = cur_chr
	switch cur_cmd {
	case def_code: @<어떤 표에서 문자 코드를 가져온다@>
	case toks_register, assign_toks, def_family, set_font, def_font:
		@<|level=tok_val|이면 토큰 목록이나 글꼴 식별자를 가져온다@>
	case assign_int: scanned_result(eqtb[m].sc, int_val)
	case assign_dimen: scanned_result(eqtb[m].sc, dimen_val)
	case assign_glue: scanned_result(equiv(m), glue_val)
	case assign_mu_glue: scanned_result(equiv(m), mu_val)
	case set_aux: @<|space_factor|나 |prev_depth|를 가져온다@>
	case set_prev_graf:
		@<|prev_graf|를 가져온다@>
	case set_page_int: @<|dead_cycles|나 |insert_penalties|를 가져온다@>
	case set_page_dimen:
		@<|page_so_far|의 무언가를 가져온다@>
	case set_shape: @<|par_shape|의 크기를 가져온다@>
	case set_box_dimen:
		@<상자의 치수를 가져온다@>
	case char_given, math_given: scanned_result(cur_chr, int_val)
	case assign_font_dimen: @<글꼴 치수를 가져온다@>
	case assign_font_int:
		@<글꼴 정수를 가져온다@>
	case register: @<레지스터를 가져온다@>
	case last_item:
		@<알맞으면 현재 노드의 항목을 가져온다@>
	default:
		@<\.{\\the}가 이것을 할 수 없다고 불평하고 0을 결과로 준다@>
	}
	for cur_val_level > level {
		@<|cur_val|을 낮은 수준으로 바꾼다@>
	}
	@<참조 횟수가 있으면 고치고, |negative|면 |cur_val|의 부호를 바꾼다@>
}

@ \dg 앞 절의 정의부에서 매크로 |scanned_result|를 옮긴다.

@<정의@>=
func scanned_result(v int32, l int32) {
	cur_val = v
	cur_val_level = l
}

@ @<어떤 표에서 문자...@>=
scan_char_num()
if m == math_code_base {
	scanned_result(ho(math_code(cur_val)), int_val)
} else if m < math_code_base {
	scanned_result(equiv(m+cur_val), int_val)
} else {
	scanned_result(eqtb[m+cur_val].sc, int_val)
}

@ @<|level=tok_val|이면...@>=
if level != tok_val {
	print_err("Missing number, treated as zero")
@.Missing number...@>
	help3("A number should have been here; I inserted `0'.",
		"(If you can't figure out why I needed to see a number,",
		"look up `weird error' in the index to The TeXbook.)")
@^TeXbook@>
	back_error()
	scanned_result(0, dimen_val)
} else if cur_cmd <= assign_toks {
	if cur_cmd < assign_toks { // |cur_cmd=toks_register|
		scan_eight_bit_int()
		m = toks_base + cur_val
	}
	scanned_result(equiv(m), tok_val)
} else {
	back_input()
	scan_font_ident()
	scanned_result(font_id_base+cur_val, ident_val)
}

@ 사용자는 `\.{\\the\\spacefactor}'를 가로 모드에서만, `\.{\\the\\prevdepth}'를 세로 모드에서만 쓴다. 그래서
명령 |set_aux|의 수식어 부분에 해당하는 모드를 넣는다. 명령 |set_page_int|의 수식어는 0이나 1로, 저마다
`\.{\\deadcycles}'와 `\.{\\insertpenalties}'를 뜻한다. 명령 |set_box_dimen|의 수식어는 |width_offset|,
|height_offset|, |depth_offset| 가운데 하나다. 그리고 명령 |last_item|의 수식어는 |int_val|, |dimen_val|,
|glue_val|, |input_line_no_code|, |badness_code| 가운데 하나다.

@<\TeX의 원시 명령을...@>=
primitive("spacefactor", set_aux, hmode)
@!@:space_factor_}{\.{\\spacefactor} primitive@>
primitive("prevdepth", set_aux, vmode)
@!@:prev_depth_}{\.{\\prevdepth} primitive@>
primitive("deadcycles", set_page_int, 0)
@!@:dead_cycles_}{\.{\\deadcycles} primitive@>
primitive("insertpenalties", set_page_int, 1)
@!@:insert_penalties_}{\.{\\insertpenalties} primitive@>
primitive("wd", set_box_dimen, width_offset)
@!@:wd_}{\.{\\wd} primitive@>
primitive("ht", set_box_dimen, height_offset)
@!@:ht_}{\.{\\ht} primitive@>
primitive("dp", set_box_dimen, depth_offset)
@!@:dp_}{\.{\\dp} primitive@>
primitive("lastpenalty", last_item, int_val)
@!@:last_penalty_}{\.{\\lastpenalty} primitive@>
primitive("lastkern", last_item, dimen_val)
@!@:last_kern_}{\.{\\lastkern} primitive@>
primitive("lastskip", last_item, glue_val)
@!@:last_skip_}{\.{\\lastskip} primitive@>
primitive("inputlineno", last_item, input_line_no_code)
@!@:input_line_no_}{\.{\\inputlineno} primitive@>
primitive("badness", last_item, badness_code)
@!@:badness_}{\.{\\badness} primitive@>

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!input_line_no_code = glue_val + 1 // \.{\\inputlineno}의 코드
	@!badness_code = glue_val + 2 // \.{\\badness}의 코드
)

@ @<원시 명령의 이름을 찍는...@>=
case set_aux:
	if chr_code == vmode {
		print_esc("prevdepth")
	} else {
		print_esc("spacefactor")
	}
case set_page_int:
	if chr_code == 0 {
		print_esc("deadcycles")
	} else {
		print_esc("insertpenalties")
	}
case set_box_dimen:
	if chr_code == width_offset {
		print_esc("wd")
	} else if chr_code == height_offset {
		print_esc("ht")
	} else {
		print_esc("dp")
	}
case last_item:
	switch chr_code {
	case int_val: print_esc("lastpenalty")
	case dimen_val: print_esc("lastkern")
	case glue_val: print_esc("lastskip")
	case input_line_no_code: print_esc("inputlineno")
	default: print_esc("badness")
	}

@ @<|space_factor|나 |prev_depth|를...@>=
if abs(mode) != m {
	print_err("Improper ")
	print_cmd_chr(set_aux, m)
@.Improper \\spacefactor@>
@.Improper \\prevdepth@>
	help4("You can refer to \\spacefactor only in horizontal mode;",
		"you can refer to \\prevdepth only in vertical mode; and",
		"neither of these is meaningful inside \\write. So",
		"I'm forgetting what you said and using zero instead.")
	error()
	if level != tok_val {
		scanned_result(0, dimen_val)
	} else {
		scanned_result(0, int_val)
	}
} else if m == vmode {
	scanned_result(prev_depth(), dimen_val)
} else {
	scanned_result(space_factor(), int_val)
}

@ @<|dead_cycles|나 |insert_penalties|를...@>=
if m == 0 {
	cur_val = dead_cycles
} else {
	cur_val = insert_penalties
}
cur_val_level = int_val

@ @<상자의 치수를 가져온다@>=
scan_eight_bit_int()
if box(cur_val) == null {
	cur_val = 0
} else {
	cur_val = mem[box(cur_val)+m].sc
}
cur_val_level = dimen_val

@ 출력 루틴 \.{\\output} 안에서 사용자는 출력이 시작된 순간에 있던 쪽 합계들을 보고 싶을 수도 있다.

@<|page_so_far|의 무언가를...@>=
if page_contents == empty && !output_active {
	if m == 0 {
		cur_val = max_dimen
	} else {
		cur_val = 0
	}
} else {
	cur_val = page_so_far[m]
}
cur_val_level = dimen_val

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const @!max_dimen = 0o7777777777 // $2^{30}-1$

@ @<|prev_graf|를...@>=
if mode == 0 {
	scanned_result(0, int_val) // \.{\\write} 안에서는 |prev_graf=0|
} else {
	nest[nest_ptr] = cur_list()
	p = nest_ptr
	for abs(nest[p].mode_field) != vmode {
		p--
	}
	scanned_result(nest[p].pg_field, int_val)
}

@ @<|par_shape|의 크기를...@>=
if par_shape_ptr() == null {
	cur_val = 0
} else {
	cur_val = info(par_shape_ptr())
}
cur_val_level = int_val

@ 다음은 \.{\\lastpenalty}, \.{\\lastkern}, \.{\\lastskip}을 구현하는 곳이다. 그 가운데 \.{\\lastskip}의 참조 횟수는
나중에 갱신한다.

명령 \.{\\inputlineno}와 \.{\\badness}도 여기서 다룬다. 이것들도 비슷한 문맥에서 쓸 수 있기 때문이다.

@<알맞으면 현재 노드의...@>=
if cur_chr > glue_val {
	if cur_chr == input_line_no_code {
		cur_val = line
	} else {
		cur_val = last_badness // |cur_chr=badness_code|
	}
	cur_val_level = int_val
} else {
	if cur_chr == glue_val {
		cur_val = zero_glue
	} else {
		cur_val = 0
	}
	cur_val_level = cur_chr
	if !is_char_node(tail) && mode != 0 {
		switch cur_chr {
		case int_val: if type_(tail) == penalty_node { cur_val = penalty(tail) }
		case dimen_val: if type_(tail) == kern_node { cur_val = width(tail) }
		case glue_val:
			if type_(tail) == glue_node {
				cur_val = glue_ptr(tail)
				if subtype(tail) == mu_glue {
					cur_val_level = mu_val
				}
			}
		} // 다른 경우는 없다
	} else if mode == vmode && tail == head {
		switch cur_chr {
		case int_val: cur_val = last_penalty
		case dimen_val: cur_val = last_kern
		case glue_val: if last_glue != max_halfword { cur_val = last_glue }
		} // 다른 경우는 없다
	}
}

@ @<글꼴 치수를...@>=
find_font_dimen(false)
font_info[fmem_ptr].sc = 0
scanned_result(font_info[cur_val].sc, dimen_val)

@ @<글꼴 정수를...@>=
scan_font_ident()
if m == 0 {
	scanned_result(hyphen_char[cur_val], int_val)
} else {
	scanned_result(skew_char[cur_val], int_val)
}

@ @<레지스터를...@>=
scan_eight_bit_int()
switch m {
case int_val: cur_val = count(cur_val)
case dimen_val: cur_val = dimen(cur_val)
case glue_val: cur_val = skip(cur_val)
case mu_val: cur_val = mu_skip(cur_val)
} // 다른 경우는 없다
cur_val_level = m

@ @<\.{\\the}가 이것을...@>=
print_err("You can't use `")
print_cmd_chr(cur_cmd, cur_chr)
@.You can't use x after ...@>
print("' after ")
print_esc("the")
help1("I'm forgetting what you said and using zero instead.")
error()
if level != tok_val {
	scanned_result(0, dimen_val)
} else {
	scanned_result(0, int_val)
}

@ 수준이 |glue_val|에서 |dimen_val|로 바뀔 때는 글루의 너비 성분을 쓴다. 참조 횟수는 아직 늘리지 않았으므로
줄일 필요가 없다. 수준이 |dimen_val|에서 |int_val|로 바뀔 때는 눈금 포인트를 쓰므로 값이 실제로 바뀌지 않는다.
그리고 |mu_val|에서 |glue_val|로 바뀔 때도 값은 바뀌지 않는다.

@<|cur_val|을 낮은 수준으로...@>=
if cur_val_level == glue_val {
	cur_val = width(cur_val)
} else if cur_val_level == mu_val {
	mu_error()
}
cur_val_level--

@ 이 시점에서 |cur_val|이 글루 명세를 가리키면, 그 글루의 참조 횟수에는 아직 |cur_val|에 의한 참조가 들어
있지 않다. 매개변수 |negative|가 |true|이면 |cur_val_level|은 |<=mu_val|임이 알려져 있다.

@<참조 횟수가 있으면 고치고...@>=
if negative {
	if cur_val_level >= glue_val {
		cur_val = new_spec(cur_val)
		@<|cur_val|의 글루 성분 셋의 부호를 모두 바꾼다@>
	} else {
		cur_val = -cur_val
	}
} else if cur_val_level >= glue_val && cur_val_level <= mu_val {
	add_glue_ref(cur_val)
}

@ @<|cur_val|의 글루 성분 셋의...@>=
set_width(cur_val, -width(cur_val))
set_stretch(cur_val, -stretch(cur_val))
set_shrink(cur_val, -shrink(cur_val))

@ 다음 목표는 \TeX이 정수로 다루는 것은 무엇이든 훑는 프로시저 |scan_int|를 쓰는 것이다. 그러나 먼저
|scan_something_internal| 안에서 이미 쓰인 |scan_int|의 간단한 응용 몇 가지를 살펴보는 것이 좋겠다.

@ @<제한된 종류의 정수를...@>=
func scan_eight_bit_int() {
	scan_int()
	if cur_val < 0 || cur_val > 255 {
		print_err("Bad register code")
@.Bad register code@>
		help2("A register number must be between 0 and 255.",
			"I changed this one to zero.")
		int_error(cur_val)
		cur_val = 0
	}
}

@ @<제한된 종류의 정수를...@>=
func scan_char_num() {
	scan_int()
	if cur_val < 0 || cur_val > 255 {
		print_err("Bad character code")
@.Bad character code@>
		help2("A character number must be between 0 and 255.",
			"I changed this one to zero.")
		int_error(cur_val)
		cur_val = 0
	}
}

@ 하는 김에 나중에 필요할 비슷한 루틴들도 다루어 두자.

@<제한된 종류의 정수를...@>=
func scan_four_bit_int() {
	scan_int()
	if cur_val < 0 || cur_val > 15 {
		print_err("Bad number")
@.Bad number@>
		help2("Since I expected to read a number between 0 and 15,",
			"I changed this one to zero.")
		int_error(cur_val)
		cur_val = 0
	}
}

@ @<제한된 종류의 정수를...@>=
func scan_fifteen_bit_int() {
	scan_int()
	if cur_val < 0 || cur_val > 0o77777 {
		print_err("Bad mathchar")
@.Bad mathchar@>
		help2("A mathchar number must be between 0 and 32767.",
			"I changed this one to zero.")
		int_error(cur_val)
		cur_val = 0
	}
}

@ @<제한된 종류의 정수를...@>=
func scan_twenty_seven_bit_int() {
	scan_int()
	if cur_val < 0 || cur_val > 0o777777777 {
		print_err("Bad delimiter code")
@.Bad delimiter code@>
		help2("A numeric delimiter code must be between 0 and 2^{27}-1.",
			"I changed this one to zero.")
		int_error(cur_val)
		cur_val = 0
	}
}

@ 정수 앞에는 공백과 `\.+'나 `\.-' 부호가 몇 개든 올 수 있다. 그다음에는 십진 상수(곧 기수 10),
팔진 상수(곧 기수 8, 앞에~\.\'가 붙는다), 십육진 상수(기수 16, 앞에~\."가 붙는다), 알파벳 상수(앞에~\.\`가
붙는다), 또는 내부 변수가 온다. 훑기가 끝나면 |cur_val|에 답이 들어 있는데, 그 절댓값은 많아야
$2^{31}-1=2147483647$이어야 한다. 변수 |radix|의 값은 십진, 팔진, 십육진 상수의 경우에 10, 8, 16으로 놓이고, 그
밖에는 0으로 놓인다. 상수 뒤에는 선택적인 공백 하나가 온다.

@<전역 변수@>=
const (
	@!octal_token = other_token + '\'' // 작은따옴표, 팔진 상수를 나타낸다
	@!hex_token = other_token + '"' // 큰따옴표, 십육진 상수를 나타낸다
	@!alpha_token = other_token + '`' // 역따옴표, 알파벳 상수 앞에 온다
	@!point_token = other_token + '.' // 소수점
	@!continental_point_token = other_token + ',' // 소수점, 유럽식
)

var @!radix small_number // |scan_int|가 이것을 8, 10, 16, 0 가운데 하나로 놓는다

@ 기본 훑기 루틴 가운데 어느 것이 값을 대입하기 전에 |expand|가 작동할 경우에 대비해서 다음 전역 변수들을
초기화한다.

@<핵심 변수들의...@>=
cur_val = 0
cur_val_level = int_val
radix = 0
cur_order = normal

@ 루틴 |scan_int|는 분수의 정수 부분을 훑는 데에도 쓰인다. 이를테면 `\.{3.14159}'의 `\.3'은 |scan_int|가
찾는다. 루틴 |scan_dimen|은 이런 분수의 정수 부분을 |scan_int|가 훑은 뒤에 |cur_tok=point_token|이고, 소수점이
다시 훑도록 되돌려져 있다고 가정한다.

@<함수들@>=
func scan_int() { // |cur_val|을 정수로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	var m int32 // |@t$2^{31}$@> div radix|, 위험의 문턱값
	var d small_number // 방금 훑은 숫자
	var vacuous bool // 숫자가 하나도 나타나지 않았나?
	var OK_so_far bool // 오류 메시지를 냈나?
	radix = 0
	OK_so_far = true
	@<공백도 부호도 아닌 다음 토큰을 얻고 |negative|를 알맞게 놓는다@>
	if cur_tok == alpha_token {
		@<알파벳 문자 코드를 |cur_val|에 훑어 넣는다@>
	} else if cur_cmd >= min_internal && cur_cmd <= max_internal {
		scan_something_internal(int_val, false)
	} else {
		@<수 상수를 훑는다@>
	}
	if negative {
		cur_val = -cur_val
	}
}

@ @<공백도 부호도 아닌...@>=
negative = false
for {
	@<공백도 호출도 아닌...@>
	if cur_tok == other_token+'-' {
		negative = !negative
		cur_tok = other_token + '+'
	}
	if cur_tok != other_token+'+' {
		break
	}
}

@ 알파벳 문자 상수 뒤의 공백은 무시한다. 그래야 그런 상수가 수 상수처럼 행동한다.

@<알파벳 문자 코드를...@>=
get_token() // 매크로 펼치기를 억누른다
if cur_tok < cs_token_flag {
	cur_val = cur_chr
	if cur_cmd <= right_brace {
		if cur_cmd == right_brace {
			align_state++
		} else {
			align_state--
		}
	}
} else if cur_tok < cs_token_flag+single_base {
	cur_val = cur_tok - cs_token_flag - active_base
} else {
	cur_val = cur_tok - cs_token_flag - single_base
}
if cur_val > 255 {
	print_err("Improper alphabetic constant")
@.Improper alphabetic constant@>
	help2("A one-character control sequence belongs after a ` mark.",
		"So I'm essentially inserting \\0 here.")
	cur_val = '0'
	back_error()
} else {
	@<선택적인 공백 하나를 훑는다@>
}

@ @<선택적인 공백 하나를...@>=
get_x_token()
if cur_cmd != spacer {
	back_input()
}

@ @<수 상수를...@>=
radix = 10
m = 214748364
if cur_tok == octal_token {
	radix = 8
	m = 0o2000000000
	get_x_token()
} else if cur_tok == hex_token {
	radix = 16
	m = 0o1000000000
	get_x_token()
}
vacuous = true
cur_val = 0
@<|cur_tok|이 알맞은 숫자가 아닐 때까지 상수를 쌓는다@>
if vacuous {
	@<수가 없다는 데 놀라움을 나타낸다@>
} else if cur_cmd != spacer {
	back_input()
}

@ 보충: 넘침 검사가 미묘하다. 십진 상수에서 |m|은 $\lfloor(2^{31}-1)/10\rfloor=214748364$이다. 지금까지의 값이
|m|보다 크거나, |m|과 같은데 다음 숫자가 7보다 크면 $2^{31}-1$을 넘게 된다. 팔진과 십육진에서는
$|m|=2^{31}/8$과 $2^{31}/16$이므로, 값이 |m|에 이르기만 하면 다음 숫자가 무엇이든 넘친다.

@<|cur_tok|이 알맞은...@>=
for {
	if cur_tok < zero_token+radix && cur_tok >= zero_token &&
		cur_tok <= zero_token+9 {
		d = cur_tok - zero_token
	} else if radix == 16 {
		if cur_tok <= A_token+5 && cur_tok >= A_token {
			d = cur_tok - A_token + 10
		} else if cur_tok <= other_A_token+5 && cur_tok >= other_A_token {
			d = cur_tok - other_A_token + 10
		} else {
			goto done
		}
	} else {
		goto done
	}
	vacuous = false
	if cur_val >= m && (cur_val > m || d > 7 || radix != 10) {
		if OK_so_far {
			print_err("Number too big")
@.Number too big@>
			help2("I can only go up to 2147483647='17777777777=\"7FFFFFFF,",
				"so I'm using that number instead of yours.")
			error()
			cur_val = infinity
			OK_so_far = false
		}
	} else {
		cur_val = cur_val*radix + d
	}
	get_x_token()
}
done:

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!infinity = 0o17777777777 // \TeX이 아는 가장 큰 양수 값
	@!zero_token = other_token + '0' // 가장 작은 숫자 0
	@!A_token = letter_token + 'A' // 가장 작은 특별한 십육진 숫자
	@!other_A_token = other_token + 'A' // 형이 |other_char|인 특별한 십육진 숫자
)

@ @<수가 없다는 데...@>=
print_err("Missing number, treated as zero")
@.Missing number...@>
help3("A number should have been here; I inserted `0'.",
	"(If you can't figure out why I needed to see a number,",
	"look up `weird error' in the index to The TeXbook.)")
@^TeXbook@>
back_error()

@ 루틴 |scan_dimen|은 |scan_int|와 비슷하지만, |cur_val|을 |scaled| 값, 곧 sp의 정수 배로 놓는다. 그러므로
이 루틴의 주된 임무 가운데 하나는 여러 단위의 약어를 해석하고 측정값을 눈금 포인트로 바꾸는 것이다.

매개변수가 셋 있다. 매개변수 |mu|가 |true|면 유한 단위는 `\.{mu}'여야 하고, |false|면 `\.{mu}' 단위는
허용되지 않는다. 매개변수 |inf|가 |true|면 무한 단위 `\.{fil}', `\.{fill}', `\.{filll}'이 허용된다. 그리고 |shortcut|이 |true|면
|cur_val|에 이미 정수가 들어 있어서 단위만 고려하면 된다.

무한 글루의 경우에 찾은 무한대의 차수는 전역 변수 |cur_order|로 돌려준다.

@<전역 변수@>=
var @!cur_order glue_ord // |scan_dimen|이 찾은 무한대의 차수

@ `\.{-\'77 pt}' 같은 구성도 올바른 치수이므로 |scan_dimen|은 |scan_int|로 시작할 수 있다. 소수의 정수 부분에도
|scan_int|를 쓰면 편리한 까닭이 이것이다.

루틴 |scan_dimen|의 여러 갈래는 |cur_val|을 정수로 다루면서 보조 분수 |f|를 함께 다루므로, 실제로 관심 있는 양은
$|cur_val|+|f|/2^{16}$이다. 루틴이 끝날 때 이 ``풀어 놓은'' 표현은 낱말 하나 |cur_val|에 들어가는데, 이때
|cur_val|의 뜻은 갑자기 |integer|에서 |scaled|로 바뀐다.

보충: 원본은 레이블 |attach_fraction|과 |attach_sign|에 수 88과 89를 준다. 매크로
|scan_normal_dimen|은 |scan_dimen(false,false,false)|다.

@<함수들@>=
func scan_normal_dimen() { scan_dimen(false, false, false) }

func scan_dimen(mu, inf, shortcut bool) { // |cur_val|을 치수로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	var f int32 // 분모가 $2^{16}$인 분수의 분자
	@<치수 계산을 위한 지역 변수@>
	f = 0
	arith_error = false
	cur_order = normal
	negative = false
	if !shortcut {
		@<부호와 정수 부분과 소수 부분을 훑는다@>
	}
	if cur_val < 0 { // 이 경우에는 |f=0|이다
		negative = !negative
		cur_val = -cur_val
	}
	@<단위를 훑고 |cur_val|을 $x\cdot(|cur_val|+f/2^{16})$으로 놓는다@>
	@<선택적인 공백 하나를...@>
attach_sign: // |cur_val|이 부호 말고는 맞을 때 여기로 간다
	if arith_error || abs(cur_val) >= 0o10000000000 {
		@<이 치수가 범위를 벗어났다고 알린다@>
	}
	if negative {
		cur_val = -cur_val
	}
}

@ \dg 루틴 |scan_dimen|의 앞부분이다. 매개변수 |shortcut|이 |false|일 때 실행된다.

@<부호와 정수 부분과...@>=
@<공백도 부호도 아닌...@>
if cur_cmd >= min_internal && cur_cmd <= max_internal {
	@<내부 치수를 가져와 |goto attach_sign|, 아니면 내부 정수를 가져온다@>
} else {
	back_input()
	if cur_tok == continental_point_token {
		cur_tok = point_token
	}
	if cur_tok != point_token {
		scan_int()
	} else {
		radix = 10
		cur_val = 0
	}
	if cur_tok == continental_point_token {
		cur_tok = point_token
	}
	if radix == 10 && cur_tok == point_token {
		@<소수 부분을 훑는다@>
	}
}

@ @<내부 치수를 가져와...@>=
if mu {
	scan_something_internal(mu_val, false)
	@<글루를 치수로 바꾼다@>
	if cur_val_level == mu_val {
		goto attach_sign
	}
	if cur_val_level != int_val {
		mu_error()
	}
} else {
	scan_something_internal(dimen_val, false)
	if cur_val_level == dimen_val {
		goto attach_sign
	}
}

@ @<치수 계산을 위한...@>=
var @!num, @!denom int32 // 훑은 단위의 변환 비율; |1..65536|
var @!k, @!kk small_number // 소수 부분의 숫자 수
var @!p, @!q pointer // 십진 숫자 스택의 맨 위
var @!v scaled // 내부 치수
var @!save_cur_val int32 // |cur_val|을 잠시 저장한다

@ 다음 코드는 |scan_something_internal|을 |mu_val|을 요구하며 불렀는데 실제로 원한 것이 ``mu 글루''가 아니라
``mu 치수''였을 때 실행된다.

@<글루를 치수로...@>=
if cur_val_level >= glue_val {
	v = width(cur_val)
	delete_glue_ref(cur_val)
	cur_val = v
}

@ 다음 코드를 실행할 때는 |cur_tok=point_token|이지만, 이 토큰은 |back_input|으로 되돌려져 있다. 먼저 그것을
버려야 한다.

소수점 하나만 있으면 `\.{0.0}'과 같다는 것이 밝혀진다. 사람들이 이 사실을 쓰지 않기를 바라자.

@<소수 부분을...@>=
k = 0
p = null
get_token() // |point_token|을 다시 훑는다
for {
	get_x_token()
	if cur_tok > zero_token+9 || cur_tok < zero_token {
		goto done1
	}
	if k < 17 { // |k>=17|인 숫자는 결과에 영향을 줄 수 없다
		q = get_avail()
		set_link(q, p)
		set_info(q, cur_tok-zero_token)
		p = q
		k++
	}
}
done1:
for kk = k; kk >= 1; kk-- {
	dig[kk-1] = info(p)
	q = p
	p = link(p)
	free_avail(q)
}
f = round_decimals(k)
if cur_cmd != spacer {
	back_input()
}

@ 이제 더 어려운 부분이 온다. 프로그램의 이 지점에서 |cur_val|은 음이 아닌 정수이고 $f/2^{16}$은 1보다 작은
음이 아닌 분수다. 우리는 이 두 양의 합에 지정된 단위에 따른 알맞은 인자를 곱해서 |scaled| 결과를 얻고
싶은데, 그 계산을 넘침이 없는 고정 소수점 산술로 하고 싶다.

보충: 원본의 이름은 ``단위를 훑고 |cur_val|을 $x\cdot(|cur_val|+f/2^{16})$으로 놓는다. 여기서 |x|는 단위당
sp의 수다. 단위가 내부 치수면 |goto attach_sign|''이다.

@<단위를 훑고...@>=
if inf {
	@<\.{fil} 단위를 훑고, 찾았으면 |goto attach_fraction|@>
}
@<내부 치수인 단위를 훑고, 찾았으면 |cur_val|을 정해 |goto attach_sign|@>
if mu {
	@<\.{mu} 단위를 훑고 |goto attach_fraction|@>
}
if scan_keyword("true") {
	@<확대 배율에 맞추어 조정한다@>
}
@.true@>
if scan_keyword("pt") {
	goto attach_fraction // 쉬운 경우
}
@.pt@>
@<다른 모든 단위를 훑어 |cur_val|과 |f|를 조정하고, 눈금 포인트면 |goto done|@>
attach_fraction: // |cur_val|과 |f|를 |cur_val|에 꾸려 넣으려면 여기로 간다
if cur_val >= 0o40000 {
	arith_error = true
} else {
	cur_val = cur_val*unity + f
}
done:

@ `\.{filllll}'이나 `\.{fill L L L}' 같은 지정은 오류 메시지 두 개를 낳는다(덧붙은 키워드 \.{"l"}마다 하나).

@<\.{fil} 단위를...@>=
if scan_keyword("fil") {
@.fil@>
	cur_order = fil
	for scan_keyword("l") {
		if cur_order == filll {
			print_err("Illegal unit of measure (")
@.Illegal unit of measure@>
			print("replaced by filll)")
			help1("I dddon't go any higher than filll.")
			error()
		} else {
			cur_order++
		}
	}
	goto attach_fraction
}

@ @<내부 치수인 단위를...@>=
save_cur_val = cur_val
@<공백도 호출도 아닌...@>
if cur_cmd < min_internal || cur_cmd > max_internal {
	back_input()
} else {
	if mu {
		scan_something_internal(mu_val, false)
		@<글루를 치수로...@>
		if cur_val_level != mu_val {
			mu_error()
		}
	} else {
		scan_something_internal(dimen_val, false)
	}
	v = cur_val
	goto found
}
if mu {
	goto not_found
}
if scan_keyword("em") {
	v = @<|cur_font|의 em 너비@>
@.em@>
} else if scan_keyword("ex") {
	v = @<|cur_font|의 x 높이@>
@.ex@>
} else {
	goto not_found
}
@<선택적인 공백 하나를...@>
found:
cur_val = nx_plus_y(save_cur_val, v, xn_over_d(v, f, 0o200000))
goto attach_sign
not_found:

@ @<\.{mu} 단위를...@>=
if scan_keyword("mu") {
	goto attach_fraction
} else {
@.mu@>
	print_err("Illegal unit of measure (")
	print("mu inserted)")
@.Illegal unit of measure@>
	help4("The unit of measurement in math glue must be mu.",
		"To recover gracefully from this error, it's best to",
		"delete the erroneous units; e.g., type `2' to delete",
		"two letters. (See Chapter 27 of The TeXbook.)")
@^TeXbook@>
	error()
	goto attach_fraction
}

@ @<확대 배율에 맞추어...@>=
prepare_mag()
if mag() != 1000 {
	cur_val = xn_over_d(cur_val, 1000, mag())
	f = (1000*f + 0o200000*remainder) / mag()
	cur_val = cur_val + (f / 0o200000)
	f = f % 0o200000
}

@ 필요한 변환 인자는 모두 분자와 분모의 합이 32768 이하인 분수로 정확히 지정할 수 있다. 여기의 정의에 따르면
$\rm2660\,dd\approx1000.33297\,mm$인데, 이것은 보스하르트가 {\sl Technische Grundlagen zur Satzherstellung\/}
@^Bosshard, Hans Rudolf@>
(Bern, 1980)에서 인용한 값 $\rm1000.333\,mm$와 잘 맞는다.

보충: 원본의 매크로 |set_conversion(#1)(#2)|는 |num:=#1; denom:=#2|다. \GO/에서는 다중 대입
`|num, denom = #1, #2|'로 쓴다.

@<다른 모든 단위를...@>=
if scan_keyword("in") {
	num, denom = 7227, 100
@.in@>
} else if scan_keyword("pc") {
	num, denom = 12, 1
@.pc@>
} else if scan_keyword("cm") {
	num, denom = 7227, 254
@.cm@>
} else if scan_keyword("mm") {
	num, denom = 7227, 2540
@.mm@>
} else if scan_keyword("bp") {
	num, denom = 7227, 7200
@.bp@>
} else if scan_keyword("dd") {
	num, denom = 1238, 1157
@.dd@>
} else if scan_keyword("cc") {
	num, denom = 14856, 1157
@.cc@>
} else if scan_keyword("sp") {
	goto done
@.sp@>
} else {
	@<모르는 단위를 불평하고 |goto done2|@>
}
cur_val = xn_over_d(cur_val, num, denom)
f = (num*f + 0o200000*remainder) / denom
cur_val = cur_val + (f / 0o200000)
f = f % 0o200000
done2:

@ @<모르는 단위를...@>=
print_err("Illegal unit of measure (")
print("pt inserted)")
@.Illegal unit of measure@>
help6("Dimensions can be in units of em, ex, in, pt, pc,",
	"cm, mm, dd, cc, bp, or sp; but yours is a new one!",
	"I'll assume that you meant to say pt, for printer's points.",
	"To recover gracefully from this error, it's best to",
	"delete the erroneous units; e.g., type `2' to delete",
	"two letters. (See Chapter 27 of The TeXbook.)")
@^TeXbook@>
error()
goto done2

@ @<이 치수가 범위를...@>=
print_err("Dimension too large")
@.Dimension too large@>
help2("I can't work with sizes bigger than about 19 feet.",
	"Continue and I'll use the largest value I can.")
error()
cur_val = max_dimen
arith_error = false

@ \TeX의 값 훑기 삼총사의 마지막은 |scan_glue|인데, 이것은 |cur_val|이 글루 명세를 가리키게 한다. 그 글루
명세의 참조 횟수는 |cur_val|이 그것을 가리키고 있다는 사실을 고려한 값이 된다.

매개변수 |level|은 |glue_val|이나 |mu_val|이어야 한다.

루틴 |scan_dimen|이 |scan_int|보다 훨씬 복잡했으니 |scan_glue|는 더 나쁘리라고 예상할지도 모른다. 그러나 다행히도
이것은 아주 간단하다. 일의 대부분이 이미 이루어졌기 때문이다.

@<함수들@>=
func scan_glue(level small_number) { // |cur_val|을 글루 명세 포인터로 놓는다
	var negative bool // 답의 부호를 바꾸어야 하나?
	var q pointer // 새 글루 명세
	var mu bool // |level=mu_val|인가?
	mu = (level == mu_val)
	@<공백도 부호도 아닌...@>
	if cur_cmd >= min_internal && cur_cmd <= max_internal {
		scan_something_internal(level, negative)
		if cur_val_level >= glue_val {
			if cur_val_level != level {
				mu_error()
			}
			return
		}
		if cur_val_level == int_val {
			scan_dimen(mu, false, true)
		} else if level == mu_val {
			mu_error()
		}
	} else {
		back_input()
		scan_dimen(mu, false, false)
		if negative {
			cur_val = -cur_val
		}
	}
	@<너비가 |cur_val|인 새 글루 명세를 만들고 늘어남과 줄어듦 성분을 훑는다@>
}

@ @<너비가 |cur_val|인...@>=
q = new_spec(zero_glue)
set_width(q, cur_val)
if scan_keyword("plus") {
@.plus@>
	scan_dimen(mu, true, false)
	set_stretch(q, cur_val)
	set_stretch_order(q, cur_order)
}
if scan_keyword("minus") {
@.minus@>
	scan_dimen(mu, true, false)
	set_shrink(q, cur_val)
	set_shrink_order(q, cur_order)
}
cur_val = q

@ 다음은 괘선 노드를 가리키는 포인터를 돌려주는 비슷한 프로시저다. 이 루틴은 \TeX이 \.{\\hrule}이나
\.{\\vrule}을 본 바로 뒤에 불린다. 그러므로 |cur_cmd|는 |hrule|이나 |vrule|이다. 생각은 이렇다. 기본 괘선
치수를 노드에 넣어 두었다가, `\.{height}'나 `\.{width}'나 `\.{depth}' 지정을 찾으면(순서는 상관없다) 그것으로
덮어쓴다.

@<함수들@>=
const @!default_rule = 26214 // 0.4\thinspace pt

func scan_rule_spec() pointer {
	var q pointer // 만들고 있는 괘선 노드
	q = new_rule() // 이제 |width|, |depth|, |height|는 모두 |null_flag|다
	if cur_cmd == vrule {
		set_width(q, default_rule)
	} else {
		set_height(q, default_rule)
		set_depth(q, 0)
	}
reswitch:
	if scan_keyword("width") {
@.width@>
		scan_normal_dimen()
		set_width(q, cur_val)
		goto reswitch
	}
	if scan_keyword("height") {
@.height@>
		scan_normal_dimen()
		set_height(q, cur_val)
		goto reswitch
	}
	if scan_keyword("depth") {
@.depth@>
		scan_normal_dimen()
		set_depth(q, cur_val)
		goto reswitch
	}
	return q
}

@* 토큰 목록 만들기.
매크로와, \.{\\mark}, \.{\\output}, \.{\\write} 같은 다른 것들을 위한 토큰 목록은 |scan_toks|라는
프로시저가 만든다.

프로시저 |scan_toks|의 자세한 내용에 들어가기 전에 훨씬 간단한 일, 곧 현재 문자열을 토큰 목록으로 바꾸는 일을
살펴보자. 함수 |str_toks|가 이 일을 한다. 이 함수는 공백을 형 |spacer|로, 나머지는 모두 형 |other_char|로
분류한다.

함수 |str_toks|가 만든 토큰 목록은 |link(temp_head)|에서 시작해서 돌려주는 값 |p|에서 끝난다. (값이
|p=temp_head|면 목록은 비어 있다.)

@<함수들@>=
func str_toks(b pool_pointer) pointer { // |str_pool[b..pool_ptr-1]|을 토큰 목록으로 바꾼다
	var p pointer // 토큰 목록의 꼬리
	var q pointer // |store_new_token|으로 토큰 목록에 보탤 새 노드
	var t halfword // 덧붙일 토큰
	var k pool_pointer // |str_pool|의 첨자
	str_room(1)
	p = temp_head
	set_link(p, null)
	k = b
	for k < pool_ptr {
		t = so(str_pool[k])
		if t == ' ' {
			t = space_token
		} else {
			t = other_token + t
		}
		fast_store_new_token(&p, &q, t)
		k++
	}
	pool_ptr = b
	return p
}

@ 함수 |str_toks|를 원하는 주된 까닭은 다음 함수 |the_toks|인데, 이것도 입력과 출력의 성질이 비슷하다.

이 프로시저는 `\.{\\skip\\count12}' 같은 것, 곧 `\.{\\the}' 뒤에 올 수 있는 것은 무엇이든 훑어서
`\.{-3.0pt minus 0.5fill}' 같은 것을 담은 토큰 목록을 만든다.

@<함수들@>=
func the_toks() (the_toks pointer) {
	var old_setting int32 // |selector| 설정을 담는다; |0..max_selector|
	var p, q, r pointer // 토큰 목록을 베끼는 데 쓴다
	var b pool_pointer // 임시 문자열의 바닥
	get_x_token()
	scan_something_internal(tok_val, false)
	if cur_val_level >= ident_val {
		@<토큰 목록을 베낀다@>
	} else {
		old_setting = selector
		selector = new_string
		b = pool_ptr
		switch cur_val_level {
		case int_val:
			print_int(cur_val)
		case dimen_val:
			print_scaled(cur_val)
			print("pt")
		case glue_val:
			print_spec(cur_val, "pt")
			delete_glue_ref(cur_val)
		case mu_val:
			print_spec(cur_val, "mu")
			delete_glue_ref(cur_val)
		} // 다른 경우는 없다
		selector = old_setting
		the_toks = str_toks(b)
	}
	return
}

@ @<토큰 목록을 베낀다@>=
p = temp_head
set_link(p, null)
if cur_val_level == ident_val {
	store_new_token(&p, &q, cs_token_flag+cur_val)
} else if cur_val != null {
	r = link(cur_val) // 참조 횟수는 베끼지 않는다
	for r != null {
		fast_store_new_token(&p, &q, info(r))
		r = link(r)
	}
}
the_toks = p

@ 다음은 이제 완성할 준비가 된 |expand| 서브루틴의 일부다.

@<함수들@>=
func ins_the_toks() {
	set_link(garbage, the_toks())
	ins_list(link(temp_head))
}

@ 원시 명령 \.{\\number}, \.{\\romannumeral}, \.{\\string}, \.{\\meaning}, \.{\\fontname}, \.{\\jobname}은
다음과 같이 정의된다.

@<\TeX의 원시 명령을...@>=
primitive("number", convert, number_code)
@!@:number_}{\.{\\number} primitive@>
primitive("romannumeral", convert, roman_numeral_code)
@!@:roman_numeral_}{\.{\\romannumeral} primitive@>
primitive("string", convert, string_code)
@!@:string_}{\.{\\string} primitive@>
primitive("meaning", convert, meaning_code)
@!@:meaning_}{\.{\\meaning} primitive@>
primitive("fontname", convert, font_name_code)
@!@:font_name_}{\.{\\fontname} primitive@>
primitive("jobname", convert, job_name_code)
@!@:job_name_}{\.{\\jobname} primitive@>

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!number_code = 0 // \.{\\number}의 명령 코드
	@!roman_numeral_code = 1 // \.{\\romannumeral}의 명령 코드
	@!string_code = 2 // \.{\\string}의 명령 코드
	@!meaning_code = 3 // \.{\\meaning}의 명령 코드
	@!font_name_code = 4 // \.{\\fontname}의 명령 코드
	@!job_name_code = 5 // \.{\\jobname}의 명령 코드
)

@ @<원시 명령의 이름을 찍는...@>=
case convert:
	switch chr_code {
	case number_code: print_esc("number")
	case roman_numeral_code: print_esc("romannumeral")
	case string_code: print_esc("string")
	case meaning_code: print_esc("meaning")
	case font_name_code: print_esc("fontname")
	default: print_esc("jobname")
	}

@ 프로시저 |conv_toks|는 |str_toks|를 써서 |convert| 함수들의 토큰 목록을 훑개에 끼워 넣는다. `\.{\\string}'과
`\.{\\meaning}' 뒤에는 `\.{\\outer}' 제어 시퀀스가 와도 된다.

@<함수들@>=
func conv_toks() {
	var old_setting int32 // |selector| 설정을 담는다; |0..max_selector|
	var c int32 // 원하는 변환의 종류; |number_code..job_name_code|
	var save_scanner_status small_number // 들어올 때의 |scanner_status|
	var b pool_pointer // 임시 문자열의 바닥
	c = cur_chr
	@<명령 |c|의 인자를 훑는다@>
	old_setting = selector
	selector = new_string
	b = pool_ptr
	@<명령 |c|의 결과를 찍는다@>
	selector = old_setting
	set_link(garbage, str_toks(b))
	ins_list(link(temp_head))
}

@ @<명령 |c|의 인자를...@>=
switch c {
case number_code, roman_numeral_code:
	scan_int()
case string_code, meaning_code:
	save_scanner_status = scanner_status
	scanner_status = normal
	get_token()
	scanner_status = save_scanner_status
case font_name_code:
	scan_font_ident()
case job_name_code:
	if job_name == 0 {
		open_log_file()
	}
} // 다른 경우는 없다

@ @<명령 |c|의 결과를...@>=
switch c {
case number_code:
	print_int(cur_val)
case roman_numeral_code:
	print_roman_int(cur_val)
case string_code:
	if cur_cs != 0 {
		sprint_cs(cur_cs)
	} else {
		print_char(cur_chr)
	}
case meaning_code:
	print_meaning()
case font_name_code:
	print(font_name[cur_val])
	if font_size[cur_val] != font_dsize[cur_val] {
		print(" at ")
		print_scaled(font_size[cur_val])
		print("pt")
	}
case job_name_code:
	print(job_name)
} // 다른 경우는 없다

@ 이제 더는 어려움을 미룰 수 없다. 용감하게 |scan_toks|에 덤벼들어야 한다. 이 함수는 새 토큰 목록의 꼬리를
가리키는 포인터를 돌려주고, 또 |def_ref|가 그 목록 머리의 참조 횟수를 가리키게 한다.

불 매개변수가 둘 있는데, |macro_def|와 |xpand|다. 매개변수 |macro_def|가 참이면 목표는 매크로 정의를 위한 토큰 목록을
만드는 것이다. 그렇지 않으면 목표는 다른 \TeX\ 원시 명령, 곧 \.{\\mark}, \.{\\output}, \.{\\everypar},
\.{\\lowercase}, \.{\\uppercase}, \.{\\message}, \.{\\errmessage}, \.{\\write}, \.{\\special} 가운데 하나를 위한
토큰 목록을 만드는 것이다. 뒤의 경우들에서는 다음에 왼쪽 중괄호를 훑어야 한다. 이 왼쪽 중괄호는 토큰 목록에
들어가지 않으며, 끝에 오는 짝이 맞는 오른쪽 중괄호도 마찬가지다. 매개변수 |xpand|가 거짓이면 토큰 목록은 |get_token|을
써서 입력에서 그냥 베낀다. 그렇지 않으면 펼칠 수 있는 토큰들을 펼칠 수 없는 토큰만 남을 때까지 모두
펼친다. 다만 `\.{\\the}'를 펼친 결과는 더 펼치지 않는다. 두 매개변수가 둘 다 참이면 펼치기는 매크로
몸체(곧 첫 |left_brace| 문자 뒤에 오는 재료)에만 적용된다.

함수 |scan_toks|가 시작할 때 |cur_cs|의 값은 ``폭주'' 오류 메시지에 보여 줄 제어 시퀀스의 |eqtb| 주소여야 한다.

@<함수들@>=
func scan_toks(macro_def, xpand bool) pointer {
	var t halfword // 가장 큰 매개변수 번호를 나타내는 토큰
	var s halfword // 저장한 토큰
	var p pointer // 만들고 있는 토큰 목록의 꼬리
	var q pointer // |store_new_token|으로 토큰 목록에 보탤 새 노드
	var unbalance halfword // 짝이 맞지 않는 왼쪽 중괄호의 수
	var hash_brace halfword // `\.{\#\{}' 토큰일 수도 있는 것
	if macro_def {
		scanner_status = defining
	} else {
		scanner_status = absorbing
	}
	warning_index = cur_cs
	def_ref = get_avail()
	set_token_ref_count(def_ref, null)
	p = def_ref
	hash_brace = 0
	t = zero_token
	if macro_def {
		@<매크로 정의의 매개변수 부분을 훑어 만든다@>
	} else {
		scan_left_brace() // 반드시 있어야 할 왼쪽 중괄호를 없앤다
	}
	@<토큰 목록의 몸체를 훑어 만들고, 끝나면 |goto found|@>
found:
	scanner_status = normal
	if hash_brace != 0 {
		store_new_token(&p, &q, hash_brace)
	}
	return p
}

@ @<매크로 정의의 매개변수...@>=
for {
continue_:
	get_token() // |cur_cmd|, |cur_chr|, |cur_tok|를 정한다
	if cur_tok < right_brace_limit {
		goto done1
	}
	if cur_cmd == mac_param {
		@<|match| 토큰을 만들거나, \.{\#\{}면 |goto done|@>
	}
	store_new_token(&p, &q, cur_tok)
}
done1:
store_new_token(&p, &q, end_match_token)
if cur_cmd == right_brace {
	@<왼쪽 중괄호가 빠졌다고 놀라고 |goto found|@>
}
done:

@ @<왼쪽 중괄호가 빠졌다고...@>=
print_err("Missing { inserted")
align_state++
@.Missing \{ inserted@>
help2("Where was the left brace? You said something like `\\def\\a}',",
	"which I'm going to interpret as `\\def\\a{}'.")
error()
goto found

@ 보충: 원본의 이름은 ``다음 문자가 매개변수 번호면 |cur_tok|을 |match| 토큰으로 만든다. 그러나 왼쪽
중괄호면 `|left_brace|, |end_match|'를 저장하고 |hash_brace|를 정한 뒤 |goto done|''이다.

@<|match| 토큰을 만들거나...@>=
s = match_token + cur_chr
get_token()
if cur_tok < left_brace_limit {
	hash_brace = cur_tok
	store_new_token(&p, &q, cur_tok)
	store_new_token(&p, &q, end_match_token)
	goto done
}
if t == zero_token+9 {
	print_err("You already have nine parameters")
@.You already have nine...@>
	help2("I'm going to ignore the # sign you just used,",
		"as well as the token that followed it.")
	error()
	goto continue_
} else {
	t++
	if cur_tok != t {
		print_err("Parameters must be numbered consecutively")
@.Parameters...consecutively@>
		help2("I've inserted the digit you should have used after the #.",
			"Type `1' to delete what you did use.")
		back_error()
	}
	cur_tok = s
}

@ @<토큰 목록의 몸체를...@>=
unbalance = 1
for {
	if xpand {
		@<입력의 다음 부분을 펼친다@>
	} else {
		get_token()
	}
	if cur_tok < right_brace_limit {
		if cur_cmd < right_brace {
			unbalance++
		} else {
			unbalance--
			if unbalance == 0 {
				goto found
			}
		}
	} else if cur_cmd == mac_param {
		if macro_def {
			@<매개변수 번호나 \.{\#\#}를 찾는다@>
		}
	}
	store_new_token(&p, &q, cur_tok)
}

@ 여기서는 |the_toks|가 만든 토큰 목록 전체를 더 펼치지 않고 끼워 넣는다.

@<입력의 다음 부분을...@>=
for {
	get_next()
	if cur_cmd <= max_command {
		goto done2
	}
	if cur_cmd != the {
		expand()
	} else {
		q = the_toks()
		if link(temp_head) != null {
			set_link(p, link(temp_head))
			p = q
		}
	}
}
done2:
x_token()

@ @<매개변수 번호나...@>=
s = cur_tok
if xpand {
	get_x_token()
} else {
	get_token()
}
if cur_cmd != mac_param {
	if cur_tok <= zero_token || cur_tok > t {
		print_err("Illegal parameter number in definition of ")
@.Illegal parameter number...@>
		sprint_cs(warning_index)
		help3("You meant to type ## instead of #, right?",
			"Or maybe a } was forgotten somewhere earlier, and things",
			"are all screwed up? I'm going to assume that you meant ##.")
		back_error()
		cur_tok = s
	} else {
		cur_tok = out_param_token - '0' + cur_chr
	}
}

@ 토큰 목록을 만드는 또 하나의 방법은 \.{\\read} 명령이다. 읽는 데 쓸 수 있는 파일 열여섯 개는 다음 전역
변수들에 나타난다. 스트림 번호 |n|을 열지 않았거나 다 읽었으면 |read_open[n]|의 값은 |closed|다.
명령 \.{\\openin}은 했지만 \.{\\read}는 하지 않았으면 |just_open|이고, 열려서 다음 줄을 읽을 준비가 되어 있으면
|normal|이다.

@<전역 변수@>=
const (
	@!closed = 2 // 열려 있지 않거나 파일 끝에 있다
	@!just_open = 1 // 새로 열렸고, 첫 줄을 아직 읽지 않았다
)

var @!read_file [16]alpha_file // \.{\\read}에 쓰인다
var @!read_open [17]int32 // |read_file[n]|의 상태; |normal..closed|

@ @<핵심 변수들의...@>=
for k = 0; k <= 16; k++ {
	read_open[k] = closed
}

@ 프로시저 |read_toks|는 다른 매크로 정의와 같은 토큰 목록을 만들고 |cur_val|이 그것을 가리키게 한다.
매개변수 |r|은 이 토큰 목록을 받을 제어 시퀀스를 가리킨다.

@<함수들@>=
func read_toks(n int32, r pointer) {
	var p pointer // 토큰 목록의 꼬리
	var q pointer // |store_new_token|으로 토큰 목록에 보탤 새 노드
	var s int32 // 저장한 |align_state|의 값
	var m small_number // 흐름 번호
	scanner_status = defining
	warning_index = r
	def_ref = get_avail()
	set_token_ref_count(def_ref, null)
	p = def_ref // 참조 횟수
	store_new_token(&p, &q, end_match_token)
	if n < 0 || n > 15 {
		m = 16
	} else {
		m = n
	}
	s = align_state
	align_state = 1000000 // 탭 표시 따위를 끈다
	for {
		@<파일의 다음 줄에서 토큰들을 입력해서 저장한다@>
		if align_state == 1000000 {
			break
		}
	}
	cur_val = def_ref
	scanner_status = normal
	align_state = s
}

@ @<파일의 다음 줄에서...@>=
begin_file_reading()
name = m + 1
if read_open[m] == closed {
	@<터미널에서 \.{\\read}를 위한 입력을 한다@>
} else if read_open[m] == just_open {
	@<|read_file[m]|의 첫 줄을 입력한다@>
} else {
	@<|read_file[m]|의 다음 줄을 입력한다@>
}
limit = last
if end_line_char_inactive() {
	limit--
} else {
	buffer[limit] = end_line_char()
}
first = limit + 1
loc = start
state = new_line
for {
	get_token()
	if cur_tok == 0 {
		goto done
	} // 줄의 끝에서는 |cur_cmd=cur_chr=0|이 된다
	if align_state < 1000000 { // 짝이 맞지 않는 `\.\}'는 그 줄을 그만두게 한다
		for {
			get_token()
			if cur_tok == 0 {
				break
			}
		}
		align_state = 1000000
		goto done
	}
	store_new_token(&p, &q, cur_tok)
}
done:
end_file_reading()

@ 여기서는 화면에서 배열 |buffer|로 입력하는데, |n>=0|이면 사용자에게 명시적으로 재촉한다. 여러 줄의 입력일
경우에 재촉을 더 하지 않도록 |n|의 값을 음수로 놓는다.

@<터미널에서 \.{\\read}를...@>=
if interaction > nonstop_mode {
	if n < 0 {
		prompt_input("")
	} else {
		wake_up_terminal()
		print_ln()
		sprint_cs(r)
		prompt_input("=")
		n = -1
	}
} else {
	fatal_error("*** (cannot \\read from terminal in nonstop modes)")
}
@.cannot \\read@>

@ 파일의 첫 줄은 특별하게 다루어야 한다. 함수 |input_ln|에게 |get|으로 시작하지 말라고 알려야 하기 때문이다.
@^system dependencies@>

@<|read_file[m]|의 첫 줄을...@>=
if input_ln(&read_file[m], false) {
	read_open[m] = normal
} else {
	a_close(&read_file[m])
	read_open[m] = closed
}

@ 파일 |read_file|의 끝에는 빈 줄 하나가 덧붙는다.
@^empty line at end of file@>

@<|read_file[m]|의 다음 줄을...@>=
if !input_ln(&read_file[m], true) {
	a_close(&read_file[m])
	read_open[m] = closed
	if align_state != 1000000 {
		runaway()
		print_err("File ended within ")
		print_esc("read")
@.File ended within \\read@>
		help1("This \\read has unbalanced braces.")
		align_state = 1000000
		limit = 0
		error()
	}
}

@* 조건문 처리.
이제 \TeX이 여러 종류의 \.{\\if} 명령을 다루는 방식을 살펴보자.

@<\TeX의 원시 명령을...@>=
primitive("if", if_test, if_char_code)
@!@:if_char_}{\.{\\if} primitive@>
primitive("ifcat", if_test, if_cat_code)
@!@:if_cat_code_}{\.{\\ifcat} primitive@>
primitive("ifnum", if_test, if_int_code)
@!@:if_int_}{\.{\\ifnum} primitive@>
primitive("ifdim", if_test, if_dim_code)
@!@:if_dim_}{\.{\\ifdim} primitive@>
primitive("ifodd", if_test, if_odd_code)
@!@:if_odd_}{\.{\\ifodd} primitive@>
primitive("ifvmode", if_test, if_vmode_code)
@!@:if_vmode_}{\.{\\ifvmode} primitive@>
primitive("ifhmode", if_test, if_hmode_code)
@!@:if_hmode_}{\.{\\ifhmode} primitive@>
primitive("ifmmode", if_test, if_mmode_code)
@!@:if_mmode_}{\.{\\ifmmode} primitive@>
primitive("ifinner", if_test, if_inner_code)
@!@:if_inner_}{\.{\\ifinner} primitive@>
primitive("ifvoid", if_test, if_void_code)
@!@:if_void_}{\.{\\ifvoid} primitive@>
primitive("ifhbox", if_test, if_hbox_code)
@!@:if_hbox_}{\.{\\ifhbox} primitive@>
primitive("ifvbox", if_test, if_vbox_code)
@!@:if_vbox_}{\.{\\ifvbox} primitive@>
primitive("ifx", if_test, ifx_code)
@!@:ifx_}{\.{\\ifx} primitive@>
primitive("ifeof", if_test, if_eof_code)
@!@:if_eof_}{\.{\\ifeof} primitive@>
primitive("iftrue", if_test, if_true_code)
@!@:if_true_}{\.{\\iftrue} primitive@>
primitive("iffalse", if_test, if_false_code)
@!@:if_false_}{\.{\\iffalse} primitive@>
primitive("ifcase", if_test, if_case_code)
@!@:if_case_}{\.{\\ifcase} primitive@>

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!if_char_code = 0 // `\.{\\if}'
	@!if_cat_code = 1 // `\.{\\ifcat}'
	@!if_int_code = 2 // `\.{\\ifnum}'
	@!if_dim_code = 3 // `\.{\\ifdim}'
	@!if_odd_code = 4 // `\.{\\ifodd}'
	@!if_vmode_code = 5 // `\.{\\ifvmode}'
	@!if_hmode_code = 6 // `\.{\\ifhmode}'
	@!if_mmode_code = 7 // `\.{\\ifmmode}'
	@!if_inner_code = 8 // `\.{\\ifinner}'
	@!if_void_code = 9 // `\.{\\ifvoid}'
	@!if_hbox_code = 10 // `\.{\\ifhbox}'
	@!if_vbox_code = 11 // `\.{\\ifvbox}'
	@!ifx_code = 12 // `\.{\\ifx}'
	@!if_eof_code = 13 // `\.{\\ifeof}'
	@!if_true_code = 14 // `\.{\\iftrue}'
	@!if_false_code = 15 // `\.{\\iffalse}'
	@!if_case_code = 16 // `\.{\\ifcase}'
)

@ @<원시 명령의 이름을 찍는...@>=
case if_test:
	switch chr_code {
	case if_cat_code: print_esc("ifcat")
	case if_int_code: print_esc("ifnum")
	case if_dim_code: print_esc("ifdim")
	case if_odd_code: print_esc("ifodd")
	case if_vmode_code: print_esc("ifvmode")
	case if_hmode_code: print_esc("ifhmode")
	case if_mmode_code: print_esc("ifmmode")
	case if_inner_code: print_esc("ifinner")
	case if_void_code: print_esc("ifvoid")
	case if_hbox_code: print_esc("ifhbox")
	case if_vbox_code: print_esc("ifvbox")
	case ifx_code: print_esc("ifx")
	case if_eof_code: print_esc("ifeof")
	case if_true_code: print_esc("iftrue")
	case if_false_code: print_esc("iffalse")
	case if_case_code: print_esc("ifcase")
	default: print_esc("if")
	}

@ 조건문 안에 조건문이 있을 수 있는데, 이 중첩에는 |save_stack|과는 따로 스택이 있다.

전역 변수 넷이 조건 스택의 맨 위를 나타낸다. 포인터 |cond_ptr|는 아래로 밀려 내려간 항목들이 있으면 그것을
가리킨다. 변수 |if_limit|는 구문상 허용되는 |fi_or_else| 명령의 가장 큰 코드를 지정한다. 변수 |cur_if|는 현재 조건문의
종류의 이름이고, |if_line|은 그것이 시작한 줄 번호다.

진행 중인 조건문이 없으면 조건 스택은 특별한 상태 |cond_ptr=null|, |if_limit=normal|, |cur_if=0|, |if_line=0|에
있다. 그렇지 않으면 |cond_ptr|는 두 낱말짜리 노드를 가리킨다. 그 첫 낱말의 |type|, |subtype|, |link| 필드에는
다음 수준의 |if_limit|, |cur_if|, |cond_ptr|가 들어 있고, 둘째 낱말에는 그에 해당하는 |if_line|이 들어 있다.

@<전역 변수@>=
const (
	@!if_node_size = 2 // 조건문을 위한 스택 항목의 낱말 수
	@!if_code = 1 // 계산하고 있는 \.{\\if...}의 코드
	@!fi_code = 2 // \.{\\fi}의 코드
	@!else_code = 3 // \.{\\else}의 코드
	@!or_code = 4 // \.{\\or}의 코드
)

func if_line_field(p pointer) int32        { return mem[p+1].sc }
func set_if_line_field(p pointer, v int32) { mem[p+1].sc = v }

var @!cond_ptr pointer // 조건 스택의 맨 위
var @!if_limit int32 // |fi_or_else| 코드의 상한; |normal..or_code|
var @!cur_if small_number // 처리하고 있는 조건문의 종류
var @!if_line int32 // 그 조건문이 시작한 줄

@ @<핵심 변수들의...@>=
cond_ptr = null
if_limit = normal
cur_if = 0
if_line = 0

@ @<\TeX의 원시 명령을...@>=
primitive("fi", fi_or_else, fi_code)
@!@:fi_}{\.{\\fi} primitive@>
set_text(frozen_fi, str("fi"))
eqtb[frozen_fi] = eqtb[cur_val]
primitive("or", fi_or_else, or_code)
@!@:or_}{\.{\\or} primitive@>
primitive("else", fi_or_else, else_code)
@!@:else_}{\.{\\else} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case fi_or_else:
	if chr_code == fi_code {
		print_esc("fi")
	} else if chr_code == or_code {
		print_esc("or")
	} else {
		print_esc("else")
	}

@ 조건부 텍스트를 건너뛸 때는, 오류 메시지에 쓰려고 건너뛰기를 시작한 줄 번호를 추적한다.

@<전역 변수@>=
var @!skip_line int32 // 여기서 건너뛰기를 시작했다

@ 다음은 $\.{\\if}\ldots\.{\\fi}$ 중첩의 현재 수준에서 \.{\\or}나 \.{\\else}나 \.{\\fi}에 이를 때까지 텍스트를
무시하는 프로시저다. 이 프로시저가 일을 마치면 |cur_chr|는 찾은 토큰을 나타내지만, |cur_tok|은 정해지지
않는다(그러면 프로시저가 더 빨리 돌기 때문이다).

@<함수들@>=
func pass_text() {
	var l int32 // $\.{\\if}\ldots\.{\\fi}$ 중첩의 수준
	var save_scanner_status small_number // 들어올 때의 |scanner_status|
	save_scanner_status = scanner_status
	scanner_status = skipping
	l = 0
	skip_line = line
	for {
		get_next()
		if cur_cmd == fi_or_else {
			if l == 0 {
				goto done
			}
			if cur_chr == fi_code {
				l--
			}
		} else if cur_cmd == if_test {
			l++
		}
	}
done:
	scanner_status = save_scanner_status
}

@ 새 \.{\\if}를 처리하기 시작할 때 |if_limit:=if_code|로 놓는다. 그러면 현재 \.{\\if}의 조건을 계산하기 전에
\.{\\or}나 \.{\\else}나 \.{\\fi}가 나타날 경우 \.{\\relax}가 끼워 넣어진다. 이를테면 `\.{\\ifvoid1\\else...\\fi}'
같은 명령 나열은 그렇지 않으면 `\.1' 뒤에 무언가가 필요할 것이다.

@<조건 스택에 쌓는다@>=
p = get_node(if_node_size)
set_link(p, cond_ptr)
set_type(p, if_limit)
set_subtype(p, cur_if)
set_if_line_field(p, if_line)
cond_ptr = p
cur_if = cur_chr
if_limit = if_code
if_line = line

@ @<조건 스택에서 꺼낸다@>=
p = cond_ptr
if_line = if_line_field(p)
cur_if = subtype(p)
if_limit = type_(p)
cond_ptr = link(p)
free_node(p, if_node_size)

@ 다음은 |cond_ptr|의 주어진 값에 해당하는 |if_limit| 코드를 바꾸는 프로시저다.

@<함수들@>=
func change_if_limit(l small_number, p pointer) {
	var q pointer
	if p == cond_ptr {
		if_limit = l // 쉬운 경우다
	} else {
		q = cond_ptr
		for {
			if q == null {
				confusion("if")
			}
@:this can't happen if}{\quad if@>
			if link(q) == p {
				set_type(q, l)
				return
			}
			q = link(q)
		}
	}
}

@ 프로시저 |expand|가 |if_test| 명령을 만나면 조건문이 시작된다. 그 경우 |expand|가 하는 일은 재귀
프로시저 |conditional|을 부르는 것으로 줄어든다.
@^recursion@>

@<함수들@>=
func conditional() {
	var b bool // 조건이 참인가?
	var r int32 // 계산할 관계; |"<"..">"|
	var m, n int32 // 둘째 피연산자와 견줄 것
	var p, q pointer // \.{\\ifx} 검사에서 토큰 목록을 훑기 위해
	var save_scanner_status small_number // 들어올 때의 |scanner_status|
	var save_cond_ptr pointer // 이 조건문에 해당하는 |cond_ptr|
	var this_if small_number // 이 조건문의 종류
	@<조건 스택에 쌓는다@>
	save_cond_ptr = cond_ptr
	this_if = cur_chr
	@<\.{\\ifcase}를 처리하거나 |b|를 불 조건의 값으로 놓는다@>
	if tracing_commands() > 1 {
		@<|b|의 값을 보인다@>
	}
	if b {
		change_if_limit(else_code, save_cond_ptr)
		return // \.{\\else}나 \.{\\fi}를 기다린다
	}
	@<\.{\\else}나 \.{\\fi}까지 건너뛰고 |goto common_ending|@>
common_ending:
	if cur_chr == fi_code {
		@<조건 스택에서...@>
	} else {
		if_limit = fi_code // \.{\\fi}를 기다린다
	}
}

@ `\.{\\if\\iftrue abc\\else d\\fi}' 같은 구성에서, \.{\\if}가 거짓임을 안 뒤에 처음 만나는 \.{\\else}는 우리가
찾는 \.{\\else}가 아니다. 그래서 다음의 기묘한 논리가 필요하다.

@ @<\.{\\else}나 \.{\\fi}까지...@>=
for {
	pass_text()
	if cond_ptr == save_cond_ptr {
		if cur_chr != or_code {
			goto common_ending
		}
		print_err("Extra ")
		print_esc("or")
@.Extra \\or@>
		help1("I'm ignoring this; it doesn't match any \\if.")
		error()
	} else if cur_chr == fi_code {
		@<조건 스택에서...@>
	}
}

@ @<\.{\\ifcase}를 처리하거나...@>=
switch this_if {
case if_char_code, if_cat_code: @<두 문자가 맞는지 검사한다@>
case if_int_code, if_dim_code: @<정수나 치수 사이의 관계를 검사한다@>
case if_odd_code: @<정수가 홀수인지 검사한다@>
case if_vmode_code: b = (abs(mode) == vmode)
case if_hmode_code: b = (abs(mode) == hmode)
case if_mmode_code: b = (abs(mode) == mmode)
case if_inner_code: b = (mode < 0)
case if_void_code, if_hbox_code, if_vbox_code: @<상자 레지스터의 상태를 검사한다@>
case ifx_code: @<두 토큰이 맞는지 검사한다@>
case if_eof_code:
	scan_four_bit_int()
	b = (read_open[cur_val] == closed)
case if_true_code: b = true
case if_false_code: b = false
case if_case_code: @<알맞은 경우를 고르고 |return|하거나 |goto common_ending|@>
} // 다른 경우는 없다

@ @<|b|의 값을...@>=
begin_diagnostic()
if b {
	print("{true}")
} else {
	print("{false}")
}
end_diagnostic(false)

@ 여기서는 |"<"|, |"="|, |">"|가 잇달아 있는 {\mc ASCII} 코드라는 사실을 쓴다.
@^ASCII code@>

@<정수나 치수 사이의...@>=
if this_if == if_int_code {
	scan_int()
} else {
	scan_normal_dimen()
}
n = cur_val
@<공백도 호출도 아닌...@>
if cur_tok >= other_token+'<' && cur_tok <= other_token+'>' {
	r = cur_tok - other_token
} else {
	print_err("Missing = inserted for ")
@.Missing = inserted@>
	print_cmd_chr(if_test, this_if)
	help1("I was expecting to see `<', `=', or `>'. Didn't.")
	back_error()
	r = '='
}
if this_if == if_int_code {
	scan_int()
} else {
	scan_normal_dimen()
}
switch r {
case '<': b = (n < cur_val)
case '=': b = (n == cur_val)
case '>': b = (n > cur_val)
}

@ @<정수가 홀수인지...@>=
scan_int()
b = odd(cur_val)

@ @<상자 레지스터의 상태를...@>=
scan_eight_bit_int()
p = box(cur_val)
if this_if == if_void_code {
	b = (p == null)
} else if p == null {
	b = false
} else if this_if == if_hbox_code {
	b = (type_(p) == hlist_node)
} else {
	b = (type_(p) == vlist_node)
}

@ 명령 \.{\\if\\noexpand}나 \.{\\ifcat\\noexpand} 뒤에서 능동 문자는 범주 13으로 다루어진다. 여기서는 모든 제어
시퀀스 가운데 능동 문자의 토큰이 가장 작다는 사실을 쓴다.

@<두 문자가 맞는지...@>=
get_x_token_or_active_char()
if cur_cmd > active_char || cur_chr > 255 { // 문자가 아니다
	m = relax
	n = 256
} else {
	m = cur_cmd
	n = cur_chr
}
get_x_token_or_active_char()
if cur_cmd > active_char || cur_chr > 255 {
	cur_cmd = relax
	cur_chr = 256
}
if this_if == if_char_code {
	b = (n == cur_chr)
} else {
	b = (m == cur_cmd)
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
func get_x_token_or_active_char() {
	get_x_token()
	if cur_cmd == relax {
		if cur_chr == no_expand_flag {
			cur_cmd = active_char
			cur_chr = cur_tok - cs_token_flag - active_base
		}
	}
}

@ 명령 `\.{\\ifx}'는 두 매크로의 텍스트가 같더라도 하나는 \ID{long}이나 \ID{outer}이고 다른 하나는 그렇지 않으면
두 매크로를 다르다고 판정한다는 데 주목하라.

여기서는 \.{\\outer} 제어 시퀀스가 허용되지만, 매크로 정의나 서문을 훑고 있을 수도 있으므로
|scanner_status|를 되돌려 놓아야 한다.

@<두 토큰이 맞는지...@>=
save_scanner_status = scanner_status
scanner_status = normal
get_next()
n = cur_cs
p = cur_cmd
q = cur_chr
get_next()
if cur_cmd != p {
	b = false
} else if cur_cmd < call {
	b = (cur_chr == q)
} else {
	@<두 매크로 텍스트가 맞는지 검사한다@>
}
scanner_status = save_scanner_status

@ 또 `\.{\\ifx}'는 다음과 같은 예에서 매크로 \.{\\a}와 \.{\\b}가 다르다고 판정한다는 데 주목하라.
$$\vbox{\halign{\.{#}\hfil&\qquad\.{#}\hfil\cr
  {}\\def\\a\{\\c\}&
  {}\\def\\c\{\}\cr
  {}\\def\\b\{\\d\}&
  {}\\def\\d\{\}\cr}}$$

@<두 매크로 텍스트가...@>=
p = link(cur_chr)
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

@ @<알맞은 경우를 고르고...@>=
scan_int()
n = cur_val // |n|은 지나갈 경우의 수다
if tracing_commands() > 1 {
	begin_diagnostic()
	print("{case ")
	print_int(n)
	print_char('}')
	end_diagnostic(false)
}
for n != 0 {
	pass_text()
	if cond_ptr == save_cond_ptr {
		if cur_chr == or_code {
			n--
		} else {
			goto common_ending
		}
	} else if cur_chr == fi_code {
		@<조건 스택에서...@>
	}
}
change_if_limit(or_code, save_cond_ptr)
return // \.{\\or}나 \.{\\else}나 \.{\\fi}를 기다린다

@ 조건문의 처리는 다음 코드를 빼면 끝났다. 이 코드는 실은 |expand|의 일부인데, \.{\\or}나 \.{\\else}나
\.{\\fi}를 훑었을 때 작동한다.

@<현재 조건문을 끝내고...@>=
if cur_chr > if_limit {
	if if_limit == if_code {
		insert_relax() // 조건을 아직 계산하지 않았다
	} else {
		print_err("Extra ")
		print_cmd_chr(fi_or_else, cur_chr)
@.Extra \\or@>
@.Extra \\else@>
@.Extra \\fi@>
		help1("I'm ignoring this; it doesn't match any \\if.")
		error()
	}
} else {
	for cur_chr != fi_code {
		pass_text() // \.{\\fi}까지 건너뛴다
	}
	@<조건 스택에서...@>
}

@* 파일 이름.
이제 파일 이름에 대해 애를 태울 때가 되었다. 운영체제마다 파일을 다르게 다룬다는 사실 말고도, 사람들의
무리마다 완전히 다른 이름 짓기 관례를 쓴다는 사실을 감당해야 한다. 다음 프로그램들은 어느 한 운영체제에서
필요한 것을 보여 준다. 다른 시스템을 위한 비슷한 루틴을 고안하기는 어렵지 않다.
@^fingers@>
@^system dependencies@>

\TeX은 파일 이름이 세 부분, 곧 본디 이름과 ``확장자''와 바깥 파일 시스템에서 그것을 찾을 ``파일
영역''으로 이루어진다고 가정한다. 입력 파일이나 쓰기 파일의 확장자는 따로 지정하지 않으면 `\.{.tex}'라고
가정한다. \TeX의 각 실행을 기록하는 기록 파일은 `\.{.log}', \TeX이 쓰는 글꼴의 문자들을 묘사하는 글꼴 계량
파일은 `\.{.tfm}', 조판 정보를 지정하는 출력 파일은 `\.{.dvi}', \.{INITEX}가 \TeX을 초기화하려고 쓰는 포맷
파일은 `\.{.fmt}'다. 입력 파일의 영역은 무엇이든 될 수 있지만, 파일은 대개 사용자의 현재 영역에
출력된다. 입력 파일을 지정한 영역에서 찾을 수 없으면 \TeX은 특별한 시스템 영역에서 찾는다. 이 특별한
영역은 \.{webmac.tex}처럼 흔히 쓰는 입력 파일을 위한 것이다.

\TeX을 간단히 쓸 때는 명시적인 확장자나 영역이 없는 파일 이름만 쓴다. 이를테면 사람들은 대개
`\.{\\input} \.{paper.new}'나 `\.{\\font\\tenrm} \.= \.{<csd.knuth>test}' 대신 `\.{\\input} \.{paper}'나
`\.{\\font\\tenrm} \.= \.{helvetica}'라고 한다. 간단한 파일 이름이 가장 좋다. 그래야 \TeX\ 원본 파일을
옮겨 갈 수 있기 때문이다. 파일 이름이 글자와 숫자로만 이루어져 있으면 \TeX의 모든 구현이 그것을 똑같이
다루어야 한다. 그러나 사용자는 자기 환경의 다른 파일들을, 특히 열 수 없는 파일에 관한 오류 메시지에
대답할 때 가리킬 수 있어야 한다. 그래서 그들이 좋아하는 운영체제의 문법을 쓰게 해 주고 싶다.

다음 프로시저들은 공백이 파일 이름의 일부가 되는 것을 허용하지 않는다. 그러나 어떤 사용자는 띄어 쓴 이름을
좋아하는 것 같다. 그런 것을 허용하는 시스템 의존 변경은 마지못해서만, 그리고 공백을 포함한 파일 이름 전체를
어떤 식으로든 ``따옴표로 묶을'' 때에만 해야 할 것이다.

@ 파일 이름의 시스템 의존적인 면을 따로 떼어 내려고, \TeX의 시스템 독립 부분은 |begin_name|, |more_name|,
@^system dependencies@>
|end_name|이라는 세 시스템 의존 프로시저로 표현된다. 본질적으로, 사용자가 지정한 파일 이름의 문자들이
$c_1\ldots c_n$이면 시스템 독립 구동 프로그램은 다음 연산들을 한다.
$$|begin_name|;\,|more_name|(c_1);\,\ldots\,;\,|more_name|(c_n);\,|end_name|.$$
이 세 프로시저는 전역 변수로 서로 소통한다. 그 뒤에 파일 이름은 문자열 풀에 |cur_name|\penalty10000\hskip-.05em,
|cur_area|, |cur_ext|라는 세 문자열로 나타난다. 뒤의 둘은 사용자가 명시적으로 지정하지 않는 한 널(곧
|""|)이다.

실제 상황은 조금 더 복잡하다. \TeX은 파일 이름이 어디서 끝나는지 알아야 하기 때문이다. 루틴 |more_name|은
(부수 효과가 있는) 함수로서, 호출 |more_name|$(c_1)$, \dots, |more_name|$(c_{n-1})$에서 |true|를 돌려준다.
마지막 호출 |more_name|$(c_n)$은 |false|를 돌려주거나, |true|를 돌려주고 $c_n$ 다음 토큰이 `\.{\\hbox}'
같은 것(곧 문자가 아닌 것)이다. 다시 말하면 |more_name|은 파일 이름을 다 훑었다고 확신하지 않는 한
|true|를 돌려주기로 되어 있고, |end_name|은 $|more_name|(c_n)$이 |true|를 돌려주었든 |false|를 돌려주었든
|cur_name|, |cur_area|, |cur_ext|의 조립을 마칠 수 있어야 한다.

@<전역 변수@>=
var @!cur_name str_number // 방금 훑은 파일의 이름
var @!cur_area str_number // 방금 훑은 파일 영역, 또는 \.{""}
var @!cur_ext str_number // 방금 훑은 파일 확장자, 또는 \.{""}

@ 설명을 위해 다룰 파일 이름은 다음 구조를 지닌다. 이름에 `\.>'나 `\.:'가 들어 있으면 파일 영역은 그런
문자 가운데 마지막 것까지(그것을 포함해서)의 모든 문자로 이루어진다. 그렇지 않으면 파일 영역은 널이다.
나머지 파일 이름에 `\..'가 들어 있으면 파일 확장자는 남은 첫 `\..'부터 끝까지의 문자들로 이루어지고,
그렇지 않으면 파일 확장자는 널이다.
@^system dependencies@>

영역 구분자와 확장자 구분자가 나타나는 곳을 추적하는 전역 변수 둘을 쓰면 그런 파일 이름을 쉽게 훑을 수
있다.

보충: 옮긴이의 시스템(유닉스 계열)에서는 `\./'가 디렉터리를 가른다. 그래서 |more_name|이 `\.>'와
`\.:'에 더해 `\./'도 영역 구분자로 알아보게 고쳤다. 이를테면 `\.{\\input ../d.v2/paper}'에서 영역은
`\.{../d.v2/}', 이름은 `\.{paper}', 확장자는 널이 되므로 `\.{.tex}'가 붙고, 작업 이름은 `\.{paper}'가
된다. 원본의 규칙대로 두면 `\./'는 보통 문자여서, 이름 첫머리의 `\..'이 확장자의 시작으로 읽혀 이름이
비고 확장자가 `\.{../d.v2/paper}' 전체가 된다. 그러면 이것이 첫 \.{\\input}일 때 작업 이름이 비어서
기록 파일 이름이 `\.{.log}'가 된다.

@<전역 변수@>=
var @!area_delimiter pool_pointer // 가장 최근의 `\.>'나 `\.:'나 `\./', 있다면
var @!ext_delimiter pool_pointer // 관련된 `\..', 있다면

@ 사용자의 영역에서 찾을 수 없는 입력 파일은 |TEX_area|라는 표준 시스템 영역에 있을 수 있다. 영역을
명시적으로 주지 않은 글꼴 계량 파일은 |TEX_font_area|라는 표준 시스템 영역에 있다고 가정한다. 물론 이
시스템 영역 이름은 곳마다 다를 것이다.
@^system dependencies@>

보충: 원본에서 이 둘은 문자열 상수, 곧 풀 문자열의 번호다. 여기서는 그 번호를 담은 꾸러미 변수로 둔다.
\GO/는 꾸러미 변수를 초기화할 때 |pool_literals|를 먼저 초기화하므로 |str|을 불러도 된다. 이 영역 이름들이
실제로 어디를 가리키는지는 \os{27} 뒤의 둘째 덧붙인 절에서 설명했다.

@<전역 변수@>=
var TEX_area = str("TeXinputs:")
@.TeXinputs@>
var TEX_font_area = str("TeXfonts:")
@.TeXfonts@>

@ 다음은 파일 이름 훑기를 위한 시스템 의존 루틴 가운데 첫째다.
@^system dependencies@>

@<함수들@>=
func begin_name() {
	area_delimiter = 0
	ext_delimiter = 0
}

@ 그리고 다음은 둘째다. 파일 이름을 훑는 동안 새 \.{\\csname}이 들어올 수도 있으므로 문자열 풀이 바뀔 수
있다. 그래서 |area_delimiter|와 |ext_delimiter|에 |pool_ptr| 같은 절대 주소를 주지 않고, 현재 문자열의
처음에 대한 상대 위치로 둔다.
@^system dependencies@>

@<함수들@>=
func more_name(c ASCII_code) bool {
	if c == ' ' {
		return false
	} else {
		str_room(1)
		append_char(c) // |c|를 현재 문자열에 보탠다
		if c == '>' || c == ':' || c == '/' {
			area_delimiter = cur_length()
			ext_delimiter = 0
		} else if c == '.' && ext_delimiter == 0 {
			ext_delimiter = cur_length()
		}
		return true
	}
}

@ 셋째다.
@^system dependencies@>

@<함수들@>=
func end_name() {
	if str_ptr+3 > max_strings {
		overflow("number of strings", max_strings-init_str_ptr)
	}
@:TeX capacity exceeded number of strings}{\quad number of strings@>
	if area_delimiter == 0 {
		cur_area = str("")
	} else {
		cur_area = str_ptr
		str_start[str_ptr+1] = str_start[str_ptr] + area_delimiter
		str_ptr++
	}
	if ext_delimiter == 0 {
		cur_ext = str("")
		cur_name = make_string()
	} else {
		cur_name = str_ptr
		str_start[str_ptr+1] = str_start[str_ptr] + ext_delimiter - area_delimiter - 1
		str_ptr++
		cur_ext = make_string()
	}
}

@ 거꾸로, 다음은 세 문자열을 받아서 그것들을 만들어 냈을 법한 파일 이름을 찍는 루틴이다. (어떤 운영체제는
파일 영역을 처음이 아니라 마지막에 두므로 이 루틴은 시스템에 따라 다르다.)
@^system dependencies@>

@<기본 인쇄...@>=
func print_file_name(n, a, e int32) {
	slow_print(a)
	slow_print(n)
	slow_print(e)
}

@ \TeX의 내부 문자열 셋을 파일을 열 때 쓰는 |name_of_file| 값으로 바꾸는 시스템 의존 루틴이 또 하나
필요하다. 지금의 코드는 파일 이름에 소문자와 대문자를 다 허용한다.
@^system dependencies@>

보충: 원본의 매크로 |append_to_name(#)|은 부르는 프로시저의 지역 변수 |k|와 |c|를 쓴다. 이 매크로는 다음
절의 |pack_buffered_name|에서도 쓰이므로, 여기서는 |k|를 포인터로 받는 함수로 옮겼다. 그리고 |c|는 임시 변수일
뿐이므로 함수의 매개변수가 된다.

@<함수들@>=
func append_to_name(k *int32, c ASCII_code) {
	*k++
	if *k <= file_name_size {
		name_of_file[*k] = xchr[c]
	}
}

func pack_file_name(n, a, e str_number) {
	var k int32 // |name_of_file|에서 채운 위치의 수
	var j pool_pointer // |str_pool|의 첨자
	k = 0
	for j = str_start[a]; j <= str_start[a+1]-1; j++ {
		append_to_name(&k, so(str_pool[j]))
	}
	for j = str_start[n]; j <= str_start[n+1]-1; j++ {
		append_to_name(&k, so(str_pool[j]))
	}
	for j = str_start[e]; j <= str_start[e+1]-1; j++ {
		append_to_name(&k, so(str_pool[j]))
	}
	if k <= file_name_size {
		name_length = k
	} else {
		name_length = file_name_size
	}
	for k = name_length + 1; k <= file_name_size; k++ {
		name_of_file[k] = ' '
	}
}

@ 더 지저분한 루틴도 필요하다. 포맷 파일의 이름은 \TeX의 문자열 장치가 초기화되기 전에 훑어야 하기
때문이다. 전역 변수 |TEX_format_default|를 써서 포맷 파일에 관련된 기본 시스템 영역과 확장자의 텍스트를
준다.
@^system dependencies@>

@<전역 변수@>=
const (
	@!format_default_length = 20 // 문자열 |TEX_format_default|의 길이
	@!format_area_length = 11 // 그 영역 부분의 길이
	@!format_ext_length = 4 // 그 `\.{.fmt}' 부분의 길이
)

var format_extension = str(".fmt") // 확장자, \.{WEB} 상수로서

var @!TEX_format_default [format_default_length + 1]text_char

@ @<핵심 변수들의...@>=
copy(TEX_format_default[1:], "TeXformats:plain.fmt")
@.TeXformats@>
@.plain@>
@^system dependencies@>

@ @<``상수'' 값들이 서로 맞는지 검사한다@>=
if format_default_length > file_name_size {
	bad = 31
}

@ 다음은 방금 말한 지저분한 루틴이다. 이것은 |name_of_file|을 |TEX_format_default|의 처음 |n|문자,
|buffer[a..b]|, |TEX_format_default|의 마지막 |format_ext_length|문자를 차례로 이은 것으로 놓는다.

\TeX은 |error| 루틴이 움직일 준비가 되기 전에 이 루틴을 부르므로, 여기서는 감히 오류 메시지를 낼 수
없다. 그 대신 남는 문자들을 그냥 버린다. 이상한 파일 이름을 찾지 못하면 오류가 다른 방법으로 드러날
것이기 때문이다.
@^system dependencies@>

@<함수들@>=
func pack_buffered_name(n small_number, a, b int32) {
	var k int32 // |name_of_file|에서 채운 위치의 수
	var j int32 // |buffer|나 |TEX_format_default|의 첨자
	if n+b-a+1+format_ext_length > file_name_size {
		b = a + file_name_size - n - 1 - format_ext_length
	}
	k = 0
	for j = 1; j <= n; j++ {
		append_to_name(&k, xord[TEX_format_default[j]])
	}
	for j = a; j <= b; j++ {
		append_to_name(&k, buffer[j])
	}
	for j = format_default_length - format_ext_length + 1; j <= format_default_length; j++ {
		append_to_name(&k, xord[TEX_format_default[j]])
	}
	if k <= file_name_size {
		name_length = k
	} else {
		name_length = file_name_size
	}
	for k = name_length + 1; k <= file_name_size; k++ {
		name_of_file[k] = ' '
	}
}

@ 다음은 |pack_buffered_name|을 쓰는 유일한 곳이다. 프로그램의 이 부분은 ``처녀'' \TeX이 예비 초기화를 막
마치고 움직이기 시작하려 할 때나, 사용자가 처음의 `\.{**}' 재촉 기호 뒤에 `\.\&'를 쳐서 다른 포맷 파일로
바꿀 때 작동한다. 버퍼에는 입력의 첫 줄이 |buffer[loc..(last-1)]|에 들어 있는데, |loc<last|이고
|buffer[loc]!=" "|다.

@<|open_fmt_file|이라는 함수를 선언한다@>=
func open_fmt_file() bool {
	var j int32 // 포맷 파일 이름 뒤의 첫 공백; |0..buf_size|
	j = loc
	if buffer[loc] == '&' {
		loc++
		j = loc
		buffer[last] = ' '
		for buffer[j] != ' ' {
			j++
		}
		pack_buffered_name(0, loc, j-1) // 먼저 시스템 파일 영역 없이 해 본다
		if w_open_in(&fmt_file) {
			goto found
		}
		pack_buffered_name(format_area_length, loc, j-1)
		// 이제 시스템 포맷 파일 영역을 해 본다
		if w_open_in(&fmt_file) {
			goto found
		}
		wake_up_terminal()
		wterm_ln("Sorry, I can't find that format;", " will try PLAIN.")
@.Sorry, I can't find...@>
		update_terminal()
	}
	// 이제 모든 수단을 써 본다: 시스템의 \.{plain} 파일을 찾는다
	pack_buffered_name(format_default_length-format_ext_length, 1, 0)
	if !w_open_in(&fmt_file) {
		wake_up_terminal()
		wterm_ln("I can't find the PLAIN format file!")
@.I can't find PLAIN...@>
@.plain@>
		return false
	}
found:
	loc = j
	return true
}

@ 운영체제는 흔히 열린 파일의 정확한 이름(과 판 번호)을 알아낼 수 있게 해 준다. 다음 루틴은 그저
|name_of_file|의 값으로 \TeX\ 문자열을 만드는데, 될 수 있으면 가장 최근에 연 파일~|f|의 온전한 이름을
알아내도록 바꾸어야 한다. \PASCAL\ 프로그램에서 그렇게 할 수 있다면 말이다.
@^system dependencies@>

이 루틴은 문자열 메모리가 넘친 뒤에 불릴 수도 있으므로 감히 `|str_room|'을 쓸 수 없다.

보충: \GO/에서는 열린 파일의 실제 경로를 |f.f.Name()|으로 알 수 있다. 원본의 권유대로 |a_make_name_string|
따위는 그 경로를 |name_of_file|에 넣은 뒤 |make_name_string|을 부른다. 그래서 이를테면 \TeX이
`\.{TeXinputs:}' 영역에서 찾은 파일의 이름은 그 파일의 실제 경로로 찍힌다.

@<함수들@>=
func make_name_string() str_number {
	var k int32 // |name_of_file|의 첨자; |1..file_name_size|
	if pool_ptr+name_length > pool_size || str_ptr == max_strings ||
		cur_length() > 0 {
		return '?'
	} else {
		for k = 1; k <= name_length; k++ {
			append_char(xord[name_of_file[k]])
		}
		return make_string()
	}
}

@ \dg 앞 절의 보충 설명에서 말한 함수들이다.

@<함수들@>=
func set_name_of_file(nm string) { // 열린 파일의 실제 경로를 |name_of_file|에 넣는다
	if len(nm) > file_name_size {
		return
	}
	name_length = int32(copy(name_of_file[1:], nm))
}

func a_make_name_string(f *alpha_file) str_number {
	if f.f != nil {
		set_name_of_file(f.f.Name())
	}
	return make_name_string()
}

func b_make_name_string(f *byte_file) str_number {
	if f.f != nil {
		set_name_of_file(f.f.Name())
	}
	return make_name_string()
}

func w_make_name_string(f *word_file) str_number {
	if f.f != nil {
		set_name_of_file(f.f.Name())
	}
	return make_name_string()
}

@ 이제 \TeX이 시스템과 상관없는 방식으로 파일 이름을 다루는 ``구동'' 루틴들을 살펴보자. 먼저 |get_x_token|을
불러 정보를 얻으면서 입력에서 파일 이름을 찾는 프로시저가 온다.

@<함수들@>=
func scan_file_name() {
	name_in_progress = true
	begin_name()
	@<공백도 호출도 아닌...@>
	for {
		if cur_cmd > other_char || cur_chr > 255 { // 문자가 아니다
			back_input()
			goto done
		}
		if !more_name(cur_chr) {
			goto done
		}
		get_x_token()
	}
done:
	end_name()
	name_in_progress = false
}

@ 전역 변수 |name_in_progress|는 |scan_file_name|을 재귀적으로 쓰지 못하게 하는 데 쓴다. 프로시저 |begin_name|과 다른
프로시저들이 전역 변수로 소통하기 때문이다. 재귀는 `\.{\\input\\input f}' 같은 엉큼한 술수로만 생길 텐데,
그런 방해 공작은 막아야 한다. 게다가 |name_in_progress|는 글꼴 크기 지정을 훑고 있는 동안 \.{\\input}이
@^recursion@>
시작되지 못하게 한다.

또 하나의 전역 변수 |job_name|에는 사용자가 처음 \.{\\input}한 파일 이름이 들어 있다. \TeX의 출력 파일
이름은 이 이름에 `\.{.log}', `\.{.dvi}', `\.{.fmt}'를 붙여 만든다.

@<전역 변수@>=
var @!name_in_progress bool // 파일 이름을 훑고 있나?
var @!job_name str_number // 주 파일 이름
var @!log_opened bool // 기록 파일을 열었나?

@ 처음에는 |job_name=0|이다. 참 이름을 알게 되면 곧바로 0이 아니게 된다. `\.{log}' 파일을 열지 않았을 때,
그리고 오직 그때에만 |job_name=0|이다. 물론 |job_name|이 0이 아니게 된 직후의 짧은 시간은 빼고 말이다.

@<출력 루틴들을...@>=
job_name = 0
name_in_progress = false
log_opened = false

@ 다음은 |job_name!=0|이라고 가정하고 출력 파일 이름을 만들어 내는 루틴이다. 이 루틴은 |cur_area|와
|cur_ext|의 현재 설정을 무시하고 바꾼다.

@<함수들@>=
func pack_cur_name() { pack_file_name(cur_name, cur_area, cur_ext) }

func pack_job_name(s str_number) { // |s = ".log"|, |".dvi"|, 또는 |format_extension|
	cur_area = str("")
	cur_ext = s
	cur_name = job_name
	pack_cur_name()
}

@ \TeX이 파일을 열려고 할 때 무언가 말썽이 생기면, 다음 루틴이 사용자에게 다른 파일 이름을 대라고 청한다.
매개변수~|s|는 오류 메시지에서 파일의 종류를 밝히는 데 쓰이고, 매개변수~|e|는 확장자가 주어지지 않았을 때의
기본 확장자다. 이 루틴에서 나올 때 변수 |cur_name|, |cur_area|, |cur_ext|, |name_of_file|은 파일 열기를
다시 시도할 준비가 되어 있다.

보충: 매개변수 |s|와 |e|는 언제나 문자열 상수이므로 \GO/ 문자열로 받는다. 그리고 |e|를 |cur_ext|에 넣을 때에만 |str|로
풀 문자열의 번호를 얻는다.

@<함수들@>=
func prompt_file_name(s, e string) {
	var k int32 // |buffer|의 첨자; |0..buf_size|
	if interaction == scroll_mode {
		wake_up_terminal()
	}
	if s == "input file name" {
		print_err("I can't find file `")
@.I can't find file x@>
	} else {
		print_err("I can't write on file `")
	}
@.I can't write on file x@>
	print_file_name(cur_name, cur_area, cur_ext)
	print("'.")
	if e == ".tex" {
		show_context()
	}
	print_nl("Please type another ")
	print(s)
@.Please type...@>
	if interaction < scroll_mode {
		fatal_error("*** (job aborted, file error in nonstop mode)")
	}
@.job aborted, file error...@>
	clear_terminal()
	prompt_input(": ")
	@<버퍼에서 파일 이름을 훑는다@>
	if cur_ext == str("") {
		cur_ext = str(e)
	}
	pack_cur_name()
}

@ @<버퍼에서 파일 이름을...@>=
begin_name()
k = first
for buffer[k] == ' ' && k < last {
	k++
}
for {
	if k == last {
		goto done
	}
	if !more_name(buffer[k]) {
		goto done
	}
	k++
}
done:
end_name()

@ 다음은 이 관례들을 쓰는 방법의 한 예다. 상자를 내보낼 때가 될 때마다 매크로 |ensure_dvi_open|을 쓴다.

@<전역 변수@>=
func ensure_dvi_open() {
	if output_file_name == 0 {
		if job_name == 0 {
			open_log_file()
		}
		pack_job_name(str(".dvi"))
		for !b_open_out(&dvi_file) {
			prompt_file_name("file name for output", ".dvi")
		}
		output_file_name = b_make_name_string(&dvi_file)
	}
}

var @!dvi_file byte_file // 장치 독립 출력이 여기로 간다
var @!output_file_name str_number // 출력 파일의 온전한 이름
var @!log_name str_number // 기록 파일의 온전한 이름

@ @<출력 루틴들을...@>=
output_file_name = 0

@ 루틴 |open_log_file|은 기록 파일을 열고, 그것이 앞서 터미널에 찍힌 것을 따라잡게 돕는 데 쓰인다.

@<함수들@>=
func open_log_file() {
	var old_setting int32 // 앞의 |selector| 설정; |0..max_selector|
	var k int32 // |months|와 |buffer|의 첨자; |0..buf_size|
	var l int32 // 첫 입력 줄의 끝; |0..buf_size|
	var months string // 달 이름의 약어들
	old_setting = selector
	if job_name == 0 {
		job_name = str("texput")
	}
@.texput@>
	pack_job_name(str(".log"))
	for !a_open_out(&log_file) {
		@<다른 기록 파일 이름을 얻어 본다@>
	}
	log_name = a_make_name_string(&log_file)
	selector = log_only
	log_opened = true
	@<날짜와 시각을 포함해서 머리줄을 찍는다@>
	input_stack[input_ptr] = cur_input() // 맨 아래 수준이 메모리에 있도록 한다
	print_nl("**")
@.**@>
	l = input_stack[0].limit_field // 첫 줄의 마지막 위치
	if buffer[l] == end_line_char() {
		l--
	}
	for k = 1; k <= l; k++ {
		print(buffer[k])
	}
	print_ln() // 이제 기록 파일에 입력의 첫 줄이 들어 있다
	selector = old_setting + 2 // |log_only|나 |term_and_log|
}

@ 루틴 |open_log_file|은 \TeX이 오류 메시지를 찍을 수 없거나 |show_context|조차 할 수 없는 곤란한 때에 불리기도
한다. 루틴 |prompt_file_name|은 |fatal_error|를 일으킬 수 있지만, |log_opened|가 거짓이므로 |error| 루틴은
불리지 않는다.

모드 |batch_mode|의 기본 취지는 터미널에 아무것도 쓰지 않는 것이다. 그러나 기록 파일을 하나도 열 수 없는
드문 경우에는 예외를 두어 설명 메시지가 보이게 한다.

덧붙여 말하면, 이 프로그램은 기록 파일을 언제나 `\.{transcript file}'이라고 부른다. 어떤 시스템에서는 이
파일에 확장자 `\.{.log}'를 쓸 수 없기 때문이다.

@<다른 기록 파일 이름을...@>=
selector = term_only
prompt_file_name("transcript file name", ".log")

@ 보충: 원본에서 |months|는 1부터 시작하는 문자 배열이다. 여기서는 \GO/ 문자열이므로 첨자에서 1을 뺀다.

@<날짜와 시각을 포함해서...@>=
wlog(banner)
slow_print(format_ident)
print("  ")
print_int(sys_day)
print_char(' ')
months = "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
for k = 3*sys_month - 2; k <= 3*sys_month; k++ {
	wlog(months[k-1])
}
print_char(' ')
print_int(sys_year)
print_char(' ')
print_two(sys_time / 60)
print_char(':')
print_two(sys_time % 60)

@ 이제 `\.{\\input}' 명령을 처리할 때 파일 읽기를 시작하는 데 쓰는 프로시저로 넘어가자. 조심하라. 역사적인
까닭으로 이 코드는 어리석게도 문자열 풀 공간을 아주 조금 아끼는데, 그것이 대화식 `\.E' 선택지를 헷갈리게 할
수 있다.
@^system dependencies@>

@<함수들@>=
func start_input() { // \TeX이 무언가를 \.{\\input}할 것이다
	scan_file_name() // |cur_name|을 원하는 파일 이름으로 놓는다
	if cur_ext == str("") {
		cur_ext = str(".tex")
	}
	pack_cur_name()
	@<입력 파일을 열 수 있을 때까지 해 보고 |goto done|@>
done:
	name = a_make_name_string(cur_file())
	if job_name == 0 {
		job_name = cur_name
		open_log_file()
	} // |open_log_file|은 |show_context|를 하지 않으므로 |limit|와 |loc|은
	// 아직 뜻 있는 값으로 정하지 않아도 된다
	if term_offset+length(name) > max_print_line-2 {
		print_ln()
	} else if term_offset > 0 || file_offset > 0 {
		print_char(' ')
	}
	print_char('(')
	open_parens++
	slow_print(name)
	update_terminal()
	state = new_line
	if name == str_ptr-1 { // 문자열 풀 공간을 아낀다(그러나 위의 주의를 보라)
		flush_string()
		name = cur_name
	}
	@<새 파일의 첫 줄을 읽는다@>
}

@ \dg 앞 절에서 파일을 여는 루프다. 지정한 영역에서 열지 못하고 영역이 따로 주어지지 않았으면
시스템 영역 |TEX_area|에서 찾아본다. 그래도 열지 못하면 사용자에게 다른 이름을 묻는다.

@<입력 파일을 열 수 있을 때까지...@>=
for {
	begin_file_reading() // |cur_file|과 입력의 새 수준을 마련한다
	if a_open_in(cur_file()) {
		goto done
	}
	if cur_area == str("") {
		pack_file_name(cur_name, TEX_area, cur_ext)
		if a_open_in(cur_file()) {
			goto done
		}
	}
	end_file_reading() // 쓸모없었던 수준을 없앤다
	prompt_file_name("input file name", ".tex")
}

@ 여기서는 |input_ln| 루틴에게 |get|으로 시작하지 말라고 알리는 것을 잊지 말아야 한다. 파일이 비어 있으면
빈 줄 하나가 들어 있는 것으로 여긴다.
@^system dependencies@>
@^empty line at end of file@>

@<새 파일의 첫 줄을...@>=
line = 1
if input_ln(cur_file(), false) {
	// 아무것도 하지 않는다
}
firm_up_the_line()
if end_line_char_inactive() {
	limit--
} else {
	buffer[limit] = end_line_char()
}
first = limit + 1
loc = start

@* 글꼴 계량 자료.
\TeX은 글꼴에 관한 지식을 글꼴 계량 파일, 곧 \.{TFM} 파일에서 얻는다. `\.{TFM}'의 `\.T'는 \TeX을 뜻하지만, 다른
@^TFM files@>
@^font metric files@>
프로그램들도 이 파일을 안다.

\.{TFM} 파일의 정보는 8비트 바이트의 나열로 나타난다. 바이트 수는 언제나 4의 배수이므로 파일을 32비트 낱말의
나열로 볼 수도 있지만, \TeX은 바이트 해석을 쓴다. \.{TFM} 파일의 형식은 라일 램쇼가 1980년에 설계했다. 그
@^Ramshaw, Lyle Harold@>
목적은 여러 가지 다른 종류의 정보를 간결하면서도 쓸모 있는 꼴로 전하는 것이다.

@<전역 변수@>=
var @!tfm_file byte_file

@ \.{TFM} 파일의 처음 24바이트(6낱말)에는 뒤따르는 여러 부분의 길이를 주는 16비트 정수 열두 개가 들어 있다.
이 열두 정수는 차례로 다음과 같다.
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
이것들은 모두 음이 아니고 $2^{15}$보다 작다. 또 |bc-1<=ec<=255|이어야 하고
$$\hbox{|lf=6+lh+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+np|}$$
여야 한다. 글꼴에는 문자가 256개까지(|bc=0|이고 |ec=255|면) 들어 있을 수도 있고, 하나도(|bc=ec+1|이면) 없을 수도
있다는 데 주목하라.

덧붙여 말하면, 8비트 바이트 둘 이상을 합쳐서 16비트 이상의 정수를 만들 때는 가장 높은 자리의 바이트가 파일에서
먼저 나타난다. 이것을 빅엔디언(BigEndian) 순서라고 한다.
@!@^BigEndian order@>

@ \.{TFM} 파일의 나머지는 비공식적으로 다음과 같이 명세되는 자료 배열 열 개의 나열로 볼 수 있다.
$$\vbox{\halign{\hfil\ID{#}&$\,:\,$\KW{array} #\hfil\cr
header&$[0\to\ID{lh}-1]$ \KW{of} \ID{stuff}\cr
char\_info&$[\ID{bc}\to\ID{ec}]$ \KW{of} |char_info_word|\cr
width&$[0\to\ID{nw}-1]$ \KW{of} |fix_word|\cr
height&$[0\to\ID{nh}-1]$ \KW{of} |fix_word|\cr
depth&$[0\to\ID{nd}-1]$ \KW{of} |fix_word|\cr
italic&$[0\to\ID{ni}-1]$ \KW{of} |fix_word|\cr
lig\_kern&$[0\to\ID{nl}-1]$ \KW{of} |lig_kern_command|\cr
kern&$[0\to\ID{nk}-1]$ \KW{of} |fix_word|\cr
exten&$[0\to\ID{ne}-1]$ \KW{of} |extensible_recipe|\cr
param&$[1\to\ID{np}]$ \KW{of} |fix_word|\cr}}$$
여기서 쓰이는 가장 중요한 자료형은 |@!fix_word|인데, 이것은 이진 분수의 32비트 표현이다. 이 자료형은 부호
있는 양으로서, 음수는 낱말 전체의 2의 보수로 나타낸다. 그 32비트 가운데 정확히 12비트가 이진
소수점의 왼쪽에 있다. 그러므로 가장 큰 |fix_word| 값은 $2048-2^{-20}$이고 가장 작은 것은 $-2048$이다. 그러나
아래에서 보겠지만 |fix_word| 값 가운데 둘을 빼고는 모두 $-16$과 $+16$ 사이에 있어야 한다.

@ 첫 자료 배열은 머리 정보의 덩어리로서, 글꼴에 관한 일반적인 사실들을 담는다. 머리에는 적어도 두 낱말
|header[0]|과 |header[1]|이 들어 있어야 하는데, 그 뜻은 아래에서 설명한다. 다른 소프트웨어 루틴에 쓸모 있는
머리 정보가 더 들어 있을 수도 있지만, \TeX82는 그런 자세한 것을 알 필요가 없다. 이를테면 제록스 팰로앨토
연구소에서는 머리 정보 16낱말을 더 쓴다. 처음 열 낱말은 쓰인 문자 코드 체계(이를테면 `\.{XEROX text}'나
`\.{TeX math symbols}')를, 다음 다섯 낱말은 글꼴 식별자(이를테면 `\.{HELVETICA}'나 `\.{CMSY}')를, 마지막
낱말은 ``얼굴 바이트''를 준다. \.{DVI} 파일을 제록스 인쇄 형식으로 바꾸는 프로그램은 이 정보를 \.{TFM} 파일에서
얻는다. 그 프로그램은 \.{DVI}~형식에 명시적으로 되풀이되지 않는 다른 정보 때문에 어차피 그 파일을 읽어야
한다.

\yskip\hang|header[0]|은 32비트 검사합으로서, \TeX은 이것을 \.{DVI} 출력 파일에 베껴 넣는다. 나중에 \.{DVI}
파일을 (어쩌면 다른 컴퓨터에서) 인쇄할 때, 실제로 쓰이는 글꼴은 \TeX이 쓴 \.{TFM} 파일의 검사합과 맞는
검사합을 가져야 한다. 이렇게 해서 사용자는 호환되지 않을 가능성에 대해 경고를 받는다. (그러나 글꼴 파일이나
\.{TFM} 파일 가운데 어느 한쪽의 검사합이 0이면 검사하지 않는다.) 이 검사합과 \.{TFM} 파일의 나머지 사이의
실제 관계는 중요하지 않다. 검사합은 호환되지 않는 글꼴들이 거의 언제나 서로 다른 검사합을 가진다는 성질을
지닌 식별 번호일 뿐이다.
@^check sum@>

\yskip\hang|header[1]|은 글꼴의 설계 크기를 \TeX\ 포인트 단위로 담은 |fix_word|다. 이 수는 적어도 1.0이어야
한다. 꽤 임의적이지만, 대개 ``10포인트'' 글꼴, 곧 10포인트 크기에서 가장 보기 좋도록 설계된 글꼴(그것이 정말
무엇을 뜻하든)의 설계 크기는 10.0이다. \TeX\ 사용자가 글꼴을 `\.{at} $\delta$ \.{pt}'로 요구하면, 설계 크기를
$\delta$로 바꾸고 글꼴 이미지의 점들의 $x$와~$y$ 좌표에 $\delta$를 설계 크기로 나눈 인자를 곱하는 효과가 있다.
{\sl \.{TFM} 파일의 다른 모든 치수는 설계 크기 단위의 |fix_word|\kern-1pt\ 수다.} 다만 |param[1]|(기울기 비율을
나타낸다)은 예외다. 그래서 이를테면 \.{em} 단위를 정의하는 |param[6]|의 값은 흔히 |fix_word| 값
$2^{20}=1.0$이다. 많은 글꼴의 설계 크기가 1\,em과 같기 때문이다. 다른 치수들은 절댓값이 설계 크기 단위로 16보다
작아야 한다. 그러므로 |header[1]|과 |param[1]|은 \.{TFM} 파일 전체에서 첫 바이트가 0이나 255가 아닐 수도 있는
유일한 |fix_word| 항목이다.

@ 다음에는 배열 |char_info|가 오는데, 여기에는 문자마다 |@!char_info_word| 하나가 들어 있다. 파일의 이 부분의 각
낱말에는 여섯 필드가 다음과 같이 네 바이트에 꾸려져 있다.

\yskip\hang 첫 바이트: |@!width_index| (8비트)\par
\hang 둘째 바이트: |@!height_index| (4비트) 곱하기 16, 더하기 |@!depth_index| (4~비트)\par
\hang 셋째 바이트: |@!italic_index| (6비트) 곱하기 4, 더하기 |@!tag| (2~비트)\par
\hang 넷째 바이트: |@!remainder| (8비트)\par
\yskip\noindent
문자의 실제 너비는 설계 크기 단위로 \ID{width}|[width_index]|다. 이것은 정보를 압축하는 장치다. 많은 문자가
너비가 같기 때문이다. 많은 문자가 높이나 깊이나 기울임 보정이 같은 것도 흔하므로, \.{TFM} 형식은 서로 다른
높이 16개, 서로 다른 깊이 16개, 서로 다른 기울임 보정 64개로 제한한다.

@!@^italic correction@>
문자의 기울임 보정에는 두 가지 쓰임새가 있다. (a)~보통의 텍스트에서 기울임 보정은 \TeX\ 사용자가 문자 뒤에
`\.{\\/}'를 지정했을 때에만 너비에 더해진다. (b)~수식에서 기울임 보정은 아래첨자의 위치를 정할 때를 빼고는 언제나
너비에 더해진다.

덧붙여 말하면, 관계 $\ID{width}[0]=\ID{height}[0]=\ID{depth}[0]=\ID{italic}[0]=0$이 언제나 성립해야 한다. 그래야
첨자 0이 값 0을 뜻하게 된다. 첨자 |width_index|는 문자가 글꼴에 없을 때 말고는 결코 0이면 안 된다. 문자는 |bc|와 |ec|
사이에 있고 |width_index|가 0이 아닐 때, 그리고 오직 그때에만 올바르기 때문이다.

@ 낱말 |char_info_word|의 |tag| 필드에는 |remainder| 필드를 어떻게 해석할지 알려 주는 값이 넷 있다.

\yskip\hangg|tag=0| (|no_tag|)은 |remainder|를 쓰지 않는다는 뜻이다.\par
\hangg|tag=1| (|lig_tag|)은 이 문자에 배열 |lig_kern|의 위치 |remainder|에서 시작하는 합자/커닝 프로그램이 있다는
뜻이다.\par
\hangg|tag=2| (|list_tag|)은 이 문자가 크기가 커지는 문자들의 사슬의 일부이고, 그 사슬에서 가장 큰 것은 아니라는
뜻이다. 이때 |remainder| 필드는 다음으로 큰 문자의 문자 코드를 준다.\par
\hangg|tag=3| (|ext_tag|)은 이 문자 코드가 늘일 수 있는 문자, 곧 작은 조각들로 쌓아 올려서 얼마든지 크게 만들 수
있는 문자를 나타낸다는 뜻이다. 그 조각들은 |@!exten[remainder]|에 지정되어 있다.\par
\yskip\noindent
태그가 |tag=2|나 |tag=3|인 문자는 수식의 특별한 상황에서 쓰일 때 말고는 |tag=0|인 문자로 다루어진다. 이를테면
\.{\\sum} 연산은 |list_tag|를 찾고, \.{\\left} 연산은 |list_tag|와 |ext_tag|를 둘 다 찾는다.

@<정의@>=
const (
	@!no_tag = 0 // 평범한 문자
	@!lig_tag = 1 // 합자/커닝 프로그램이 있는 문자
	@!list_tag = 2 // 문자 목록에 후계자가 있는 문자
	@!ext_tag = 3 // 늘일 수 있는 문자
)

@ 배열 |lig_kern|에는 특별한 글자 쌍에 대해 무엇을 할지 설명하는 간단한 프로그래밍 언어의 명령들이 들어 있다.
이 배열의 낱말은 저마다 네 바이트짜리 |@!lig_kern_command|다.

\yskip\hang 첫 바이트: |skip_byte|. 이 바이트가 128 이상이면 이것이 프로그램의 마지막 단계이고, 그렇지 않으면
그 수만큼의 사이에 있는 단계를 건너뛰어 다음 단계를 얻는다.\par
\hang 둘째 바이트: |next_char|. ``|next_char|가 현재 문자 다음에 오면 연산을 하고 멈추어라. 그렇지 않으면
계속하라.''\par
\hang 셋째 바이트: |op_byte|. 128보다 작으면 합자 단계를, 그렇지 않으면 커닝 단계를 나타낸다.\par
\hang 넷째 바이트: |remainder|.\par
\yskip\noindent
커닝 단계에서는 |kern[256*(op_byte-128)+remainder]|와 같은 추가 간격이 현재 문자와 |next_char| 사이에 들어간다.
이 양은 흔히 음수여서 문자들이 커닝으로 더 가까워지지만, 양수일 수도 있다.

합자 단계에는 여덟 가지가 있는데, |op_byte| 코드는 $4a+2b+c$이고 $0\le a\le b+c$이며 $0\le b,c\le1$이다. 코드가
|remainder|인 문자가 현재 문자와 |next_char| 사이에 들어가고, $b=0$이면 현재 문자를 지우고 $c=0$이면
|next_char|를 지운다. 그런 다음 $a$~개의 문자를 지나 다음 현재 문자(이것에도 자기 합자/커닝 프로그램이 있을 수
있다)에 이른다.

배열 |lig_kern|의 맨 처음 명령의 |skip_byte|가 255면 그 |next_char| 바이트가 이른바 이 글꼴의 경계 문자다.
그 값은 |bc|와~|ec| 사이에 있지 않아도 된다. 배열 |lig_kern|의 맨 마지막 명령의 |skip_byte|가 255면,
왼쪽의 경계 문자를 위한 특별한 합자/커닝 프로그램이 위치 |256*op_byte+remainder|에서 시작한다. 이것은 \TeX이 같은
글꼴의 잇달린 문자열마다 그 앞뒤에 암묵적인 경계 문자를 놓는다는 뜻이다. 이 암묵적인 문자들은 출력에 나타나지
않지만 합자와 커닝에 영향을 줄 수 있다.

문자의 |lig_kern| 프로그램의 맨 처음 명령의 |skip_byte|가 128보다 크면, 그 프로그램은 실은 위치
|256*op_byte+remainder|에서 시작한다. 이 기능 덕분에 큰 |lig_kern| 배열에도 접근할 수 있다. 그렇지 않으면 첫
명령은 |<=255|인 위치에 나타나야 하기 때문이다.

배열 |lig_kern|에서 |skip_byte>128|인 명령은 모두
$$\hbox{|256*op_byte+remainder<nl|}$$
라는 조건을 만족해야 한다. 보통의 프로그램 실행 중에 그런 명령을 만나면 그것은 무조건 멈춤을 뜻한다. 합자나
커닝 명령은 수행되지 않는다.

@<정의@>=
const (
	@!stop_flag = 128 + min_quarterword // 합자/커닝 프로그램에서 `\.{STOP}'을 나타내는 값
	@!kern_flag = 128 + min_quarterword // 커닝 단계의 연산 코드
)

func skip_byte(q four_quarters) quarterword { return q.b0 }
func next_char(q four_quarters) quarterword { return q.b1 }
func op_byte(q four_quarters) quarterword   { return q.b2 }
func rem_byte(q four_quarters) quarterword  { return q.b3 }

@ 늘일 수 있는 문자는 |@!extensible_recipe|로 지정하는데, 이것은 |@!top|, |@!mid|, |@!bot|, |@!rep|라는 네
바이트로(이 순서로) 이루어진다. 이 바이트들은 큰 기호를 쌓아 올리는 데 쓰는 낱낱의 조각들의 문자 코드다.
조각 |top|이나 |mid|나 |bot|이 0이면 그것은 쌓아 올린 결과에 나타나지 않는다. 이를테면 늘일 수 있는 세로 줄은 늘일
수 있는 대괄호와 같되, 위와 아래 조각이 없는 것이다.

기호 $T$, $M$, $B$, $R$로 저마다의 조각(조각이 없으면 빈 상자)을 나타내자. 그러면 늘일 수 있는 문자는
위에서 아래로 어떤 |k>=0|에 대해 $TR^kMR^kB$의 꼴이다. 다만 $M$이 없으면 짝수와 홀수 |k| 모두에 대해 $TR^kB$일
수 있다. 늘일 수 있는 문자의 너비는 $R$의 너비이고, 높이 더하기 깊이는 쓰인 구성 요소들의 높이 더하기 깊이의
합이다. 조각들이 세로 목록 안에서 맞붙여지기 때문이다.

@<정의@>=
func ext_top(q four_quarters) quarterword { return q.b0 } // 조립법의 |top| 조각
func ext_mid(q four_quarters) quarterword { return q.b1 } // 조립법의 |mid| 조각
func ext_bot(q four_quarters) quarterword { return q.b2 } // 조립법의 |bot| 조각
func ext_rep(q four_quarters) quarterword { return q.b3 } // 조립법의 |rep| 조각

@ \.{TFM} 파일의 마지막 부분은 배열 |param|인데, 이것도 |fix_word| 값의 나열이다.

\yskip\hang|param[1]=slant|는 기울기의 양으로서, 악센트의 위치를 정하는 데 쓰인다. 이를테면 |slant=.25|는 한
단위 위로 올라가면 오른쪽으로도 .25단위 간다는 뜻이다. 이 값은 순수한 수다. 설계 크기 자체 말고는 설계
크기로 눈금이 매겨지지 않는 유일한 |fix_word|다.

\hang|param[2]=space|는 텍스트의 낱말 사이의 보통 간격이다. 글꼴의 문자 |" "|는 공백과 아무 관계가 없어도 된다는
데 주목하라.

\hang|param[3]=space_stretch|는 낱말 사이 글루의 늘어남의 양이다.

\hang|param[4]=space_shrink|는 낱말 사이 글루의 줄어듦의 양이다.

\hang|param[5]=x_height|는 그 글꼴의 1\,ex의 크기다. 이것은 악센트를 올리거나 내리지 않아도 되는 글자들의
높이이기도 하다.

\hang|param[6]=quad|는 그 글꼴의 1\,em의 크기다.

\hang|param[7]=extra_space|는 문장 끝에서 |param[2]|에 더하는 양이다.

\yskip\noindent
매개변수가 일곱 개보다 적으면 \TeX은 빠진 매개변수들을 0으로 놓는다. 수식 기호에 쓰는 글꼴에는 매개변수 정보가
더 필요한데, 그것은 나중에 설명한다.

@<정의@>=
const (
	@!slant_code = 1
	@!space_code = 2
	@!space_stretch_code = 3
	@!space_shrink_code = 4
	@!x_height_code = 5
	@!quad_code = 6
	@!extra_space_code = 7
)

@ \.{TFM} 파일에 담긴 것은 이와 같다. \TeX은 많은 글꼴에 대해 그런 정보를 흡수해야 하므로, 자료의 대부분을
|font_info|라는 큰 배열에 저장한다. 이 배열의 항목은 저마다 |memory_word|다. 형이 |fix_word|인 자료는 |scaled| 항목으로
바뀌고, 나머지는 모두 형이 |four_quarters|인 낱말에 들어간다.

사용자가 이를테면 \.{\\font\\f}를 정의하면, \TeX은 사용자의 글꼴~\.{\\f}에 내부 번호를 준다. 이 번호를
|font_id_base|에 더하면, 언제나 그 글꼴을 고르는 ``얼어 있는'' 제어 시퀀스의 |eqtb| 위치가 된다.

@<바깥 블록의 형@>=
type @!internal_font_number = int32 // |char_node|의 |font|; |font_base..font_max|
type @!font_index = int32 // |font_info|의 첨자; |0..font_mem_size|

@ 이제 (꽤 만만찮은) 글꼴 배열들의 배열이 나온다.

@<전역 변수@>=
const (
	@!non_char = 256 + min_quarterword // 진짜 문자와 맞을 수 없는 |halfword| 코드
	@!non_address = 0 // 가짜 |bchar_label|
)

var @!font_info [font_mem_size + 1]memory_word // 글꼴 자료의 큰 모음
var @!fmem_ptr font_index // |font_info|에서 쓰이지 않는 첫 낱말
var @!font_ptr internal_font_number // 쓰이고 있는 가장 큰 내부 글꼴 번호
var @!font_check [font_max + 1]four_quarters // 검사합
var @!font_size [font_max + 1]scaled // ``at'' 크기
var @!font_dsize [font_max + 1]scaled // ``설계'' 크기
var @!font_params [font_max + 1]font_index // 글꼴 매개변수가 몇 개 있나
var @!font_name [font_max + 1]str_number // 글꼴의 이름
var @!font_area [font_max + 1]str_number // 글꼴의 영역
var @!font_bc [font_max + 1]eight_bits // 처음(가장 작은) 문자 코드
var @!font_ec [font_max + 1]eight_bits // 끝(가장 큰) 문자 코드
var @!font_glue [font_max + 1]pointer // 낱말 사이 공백의 글루 명세, 할당하지 않았으면 |null|
var @!font_used [font_max + 1]bool // 이 글꼴의 문자가 실제로 출력에 나타났나?
var @!hyphen_char [font_max + 1]int32 // 현재의 \.{\\hyphenchar} 값
var @!skew_char [font_max + 1]int32 // 현재의 \.{\\skewchar} 값
var @!bchar_label [font_max + 1]font_index // 왼쪽 경계 문자의 |lig_kern| 프로그램의 시작,
	// 없으면 |non_address|
var @!font_bchar [font_max + 1]int32 // 경계 문자, 없으면 |non_char|; |min_quarterword..non_char|
var @!font_false_bchar [font_max + 1]int32 // 글꼴에 없으면 |font_bchar|, 있으면 |non_char|

@ 방금 늘어놓은 배열 말고도, |font_info|의 낱낱의 항목에 쉽게 이르게 해 주는 디렉터리 배열들이 있다. 이를테면
글꼴 |f|의 문자 |c|에 대한 |char_info| 자료는 |font_info[char_base[f]+c].qqqq|에 있을 것이다. 그리고 |w|가 이
낱말의 |width_index| 부분(|b0| 필드)이면 그 문자의 너비는 |font_info[width_base[f]+w].sc|다. (이 공식들은 |c|와
|w|에 이미 |min_quarterword|가 더해져 있다고 가정한다. \TeX은 쿼터워드를 그렇게 저장하기 때문이다.)

@<전역 변수@>=
var @!char_base [font_max + 1]int32 // |char_info|의 바닥 주소
var @!width_base [font_max + 1]int32 // 너비의 바닥 주소
var @!height_base [font_max + 1]int32 // 높이의 바닥 주소
var @!depth_base [font_max + 1]int32 // 깊이의 바닥 주소
var @!italic_base [font_max + 1]int32 // 기울임 보정의 바닥 주소
var @!lig_kern_base [font_max + 1]int32 // 합자/커닝 프로그램의 바닥 주소
var @!kern_base [font_max + 1]int32 // 커닝의 바닥 주소
var @!exten_base [font_max + 1]int32 // 늘일 수 있는 문자 조립법의 바닥 주소
var @!param_base [font_max + 1]int32 // 글꼴 매개변수의 바닥 주소

@ @<핵심 변수들의...@>=
for k = font_base; k <= font_max; k++ {
	font_used[k] = false
}

@ \TeX은 적어도 글꼴 하나, 곧 널 글꼴은 언제나 안다. 널 글꼴에는 문자가 없고, 일곱 매개변수는 모두 0이다.

@<표의 항목들을 초기화한다...@>=
font_ptr = null_font
fmem_ptr = 7
font_name[null_font] = str("nullfont")
font_area[null_font] = str("")
hyphen_char[null_font] = '-'
skew_char[null_font] = -1
bchar_label[null_font] = non_address
font_bchar[null_font] = non_char
font_false_bchar[null_font] = non_char
font_bc[null_font] = 1
font_ec[null_font] = 0
font_size[null_font] = 0
font_dsize[null_font] = 0
char_base[null_font] = 0; width_base[null_font] = 0
height_base[null_font] = 0; depth_base[null_font] = 0
italic_base[null_font] = 0; lig_kern_base[null_font] = 0
kern_base[null_font] = 0; exten_base[null_font] = 0
font_glue[null_font] = null
font_params[null_font] = 7
param_base[null_font] = -1
for k = 0; k <= 6; k++ {
	font_info[k].sc = 0
}

@ @<\TeX의 원시 명령을...@>=
primitive("nullfont", set_font, null_font)
@!@:null_font_}{\.{\\nullfont} primitive@>
set_text(frozen_null_font, str("nullfont"))
eqtb[frozen_null_font] = eqtb[cur_val]

@ 물론 우리는 글꼴 정보가 실제로 어떻게 꾸려져 있는지의 세세한 것을 감추는 매크로들을 정의하고 싶다. 그래야
$$\hbox{|font_info[width_base[f]+font_info[char_base[f]+c].qqqq.b0].sc|}$$
같은 것을 너무 자주 쓰지 않아도 된다. 여기의 \.{WEB} 정의들은 |char_info(f)(c)|를 글꼴 |f|의 문자 |c|에 해당하는
글꼴 정보의 |four_quarters| 낱말로 만든다. 그런 낱말을 |q|라고 하면 |char_width(f)(q)|가 그 문자의 너비가 된다. 그래서
위의 긴 공식은 적어도
$$\hbox{|char_width(f)(char_info(f)(c))|}$$
로 줄어든다. 물론 대개는 |q|를 먼저 가져와서 그 필드 여럿을 한꺼번에 볼 것이다.

문자의 기울임 보정은 |char_italic(f)(q)|로 나타내므로 |char_width|와 비슷하다. 그러나 높이와 깊이는 조금 다른
방법으로 얻는다. 둘 가운데 하나를 원하면 대개 둘 다 계산하고 싶기 때문이다. 함수 |height_depth(q)|의 값은 8비트 양
$$b=|height_index|\times16+|depth_index|$$
이고, |b|가 그런 바이트면 |q=char_info(f)(c)|인 문자 |c|의 높이와 깊이를 |char_height(f)(b)|와 |char_depth(f)(b)|로
쓴다. 알겠는가?

태그 필드는 |char_tag(q)|라고 부르고, 나머지 바이트는 위에서 이미 정의한 매크로를 써서 |rem_byte(q)|라고 부른다.

문자의 |width|, |height|, |depth|, |tag| 필드에 접근하는 것은 \TeX의 안쪽 루프의 일부이므로, 이 매크로들이 그런
상황에서 될 수 있는 대로 빠른 코드를 내기를 바란다.
@^inner loop@>

보충: 원본은 |char_info(f)(c)|처럼 괄호를 두 번 쓰는 \.{WEB} 매크로 요령을 쓴다. \GO/에서는 인자 둘을 받는 함수
|char_info(f,c)|가 된다. 이 절의 다른 매크로들도 마찬가지다.

@<정의@>=
func char_info(f internal_font_number, c quarterword) four_quarters {
	return font_info[char_base[f]+c].qqqq
}
func char_width(f internal_font_number, q four_quarters) scaled {
	return font_info[width_base[f]+q.b0].sc
}
func char_exists(q four_quarters) bool { return q.b0 > min_quarterword }
func char_italic(f internal_font_number, q four_quarters) scaled {
	return font_info[italic_base[f]+(qo(q.b2))/4].sc
}
func height_depth(q four_quarters) int32 { return qo(q.b1) }
func char_height(f internal_font_number, hd int32) scaled {
	return font_info[height_base[f]+(hd)/16].sc
}
func char_depth(f internal_font_number, hd int32) scaled {
	return font_info[depth_base[f]+(hd)%16].sc
}
func char_tag(q four_quarters) int32 { return (qo(q.b2)) % 4 }

@ 전역 변수 |null_character|는 글꼴에 없는 문자의 |char_info| 낱말로 놓인다. 그런 낱말은 잘못된 상황을 다루는
편리한 방법이 된다.

@<전역 변수@>=
var @!null_character four_quarters // 글꼴에 없는 문자의 정보

@ @<핵심 변수들의...@>=
null_character.b0 = min_quarterword
null_character.b1 = min_quarterword
null_character.b2 = min_quarterword
null_character.b3 = min_quarterword

@ 다음은 합자와 커닝을 처리하는 데 도움을 주는 매크로들이다. 글꼴~|f|에서 커닝 명령~|j|가 지정하는 커닝의
양을 찾으려면 |char_kern(f)(j)|라고 쓴다. 낱말 |j|가 합자/커닝 프로그램이 있는 문자의 |char_info|면, 그 프로그램의 첫
명령은 |skip_byte(i)<=stop_flag|인지 아닌지에 따라 |i=font_info[lig_kern_start(f)(j)]|이거나
|font_info[lig_kern_restart(f)(i)]|다.

상수 |kern_base_offset|은 국지 최적화를 하지 않는 \PASCAL\ 컴파일러를 위해 간단하게 해야 한다.
@^system dependencies@>

@<정의@>=
const @!kern_base_offset = 256 * (128 + min_quarterword)

func char_kern(f internal_font_number, q four_quarters) scaled {
	return font_info[kern_base[f]+256*op_byte(q)+rem_byte(q)].sc
}
func lig_kern_start(f internal_font_number, q four_quarters) int32 { // 합자/커닝 프로그램의 시작
	return lig_kern_base[f] + rem_byte(q)
}
func lig_kern_restart(f internal_font_number, q four_quarters) int32 {
	return lig_kern_base[f] + 256*op_byte(q) + rem_byte(q) + 32768 - kern_base_offset
}

@ 글꼴 매개변수는 |slant(f)|, |space(f)| 따위로 가리킨다.

@<|cur_font|의 em 너비@>=
quad(cur_font())

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
func param(n int32, f internal_font_number) scaled {
	return font_info[n+param_base[f]].sc
}
func slant(f internal_font_number) scaled { // 위로 단위 거리마다 오른쪽 기울기
	return param(slant_code, f)
}
func space(f internal_font_number) scaled { // 낱말 사이의 보통 간격
	return param(space_code, f)
}
func space_stretch(f internal_font_number) scaled { // 낱말 사이의 늘어남
	return param(space_stretch_code, f)
}
func space_shrink(f internal_font_number) scaled { // 낱말 사이의 줄어듦
	return param(space_shrink_code, f)
}
func x_height(f internal_font_number) scaled { // 1\,ex
	return param(x_height_code, f)
}
func quad(f internal_font_number) scaled { // 1\,em
	return param(quad_code, f)
}
func extra_space(f internal_font_number) scaled { // 문장 끝의 추가 간격
	return param(extra_space_code, f)
}

@ @<|cur_font|의 x 높이@>=
x_height(cur_font())

@ \TeX은 \.{TFM} 파일의 정보를 읽어 들이면서 그것이 올바른지 검사하므로, 조판하는 동안에는 더 검사할 필요가
없다. 이 일을 하는 좀 지루한 서브루틴을 |read_font_info|라고 부른다. 이것에는 매개변수가 넷 있다. 사용자의 글꼴
식별자~|u|, 파일 이름과 영역 문자열 |nom|과 |aire|, 그리고 ``at'' 크기~|s|다. 크기 |s|가 음수면 그것은 설계 크기에
적용할 배율의 음수다. 보통은 |s=-1000|이다. 그렇지 않으면 |s|가 설계 크기를 대신한다. 이 경우 |s|는 양수이고
$2048\rm\,pt$보다 작아야 한다(곧 정수로 보아 $2^{27}$보다 작아야 한다).

이 서브루틴은 |tfm_file|이라는 전역 파일 변수를 열고 닫는다. 그리고 방금 실은 글꼴의 내부 글꼴 번호를 돌려준다.
오류를 찾으면 오류 메시지를 내고 글꼴 정보는 하나도 저장하지 않는다. 이 경우에는 |null_font|를 돌려준다.

보충: 원본은 매크로 |abort|를 레이블 |bad_tfm|으로 가는 |goto|로 정의한다(|bad_tfm=11|). 이 매크로는 \.{TFM}
자료를 읽는 다른 여러 매크로 안에서도 쓰인다. 그 매크로들은 |read_font_info|의 지역 변수를 쓰므로 \GO/에서는
|read_font_info| 안의 함수 리터럴이 된다(|@<\.{TFM} 파일을 읽는 매크로들@>|). 그러나 \GO/의 |goto|는 함수
리터럴 바깥으로 뛸 수 없으므로, 그런 함수 리터럴은 자료가 잘못되었으면 |false|를 돌려주고, 부르는 쪽에서
`|if !read_sixteen(&lf) { goto bad_tfm }|'처럼 |abort|한다.

@<함수들@>=
func read_font_info(u pointer, nom, aire str_number,
	s scaled) internal_font_number { // \.{TFM} 파일을 입력한다
	var k font_index // |font_info|의 첨자
	var file_opened bool // |tfm_file|을 잘 열었나?
	var lf, lh, bc, ec, nw, nh, nd, ni, nl, nk, ne, np halfword // 하위 파일들의 크기
	var f internal_font_number // 새 글꼴의 번호
	var g internal_font_number // 돌려줄 번호
	var a, b, c, d eight_bits // 바이트 변수들
	var qw four_quarters
	var sw scaled // 누산기들
	var bch_label int32 // 왼쪽 경계의 시작 위치, 또는 무한대
	var bchar int32 // 경계 문자, 또는 256; |0..256|
	var z scaled // 설계 크기나 ``at'' 크기
	var alpha int32
	var beta int32 // 고정 소수점 곱셈에 쓰는 보조 양들; |1..16|
	@<\.{TFM} 파일을 읽는 매크로들@>
	g = null_font
	@<글꼴 자료를 읽고 검사한다@>
bad_tfm:
	@<글꼴을 싣지 않겠다고 알린다@>
done:
	if file_opened {
		b_close(&tfm_file)
	}
	return g
}

@ \.{TFtoPL}과 \.{PLtoTF}라는 프로그램이 \.{TFM} 형식과, 쉽게 고칠 수 있는 기호 꼴의 속성 목록 형식 사이를
바꾸어 준다. 이 프로그램들에는 자세한 진단 정보가 많이 들어 있으므로, \TeX은 어떤 \.{TFM} 파일을 왜 거부하는지
시시콜콜 알려 줄 필요가 없다.
@.TFtoPL@> @.PLtoTF@>

@<글꼴을 싣지 않겠다고...@>=
start_font_error_message()
@.Font x=xx not loadable...@>
if file_opened {
	print(" not loadable: Bad metric (TFM) file")
} else {
	print(" not loadable: Metric (TFM) file not found")
}
help5("I wasn't able to read the size data for this font,",
	"so I will ignore the font specification.",
	"[Wizards can fix TFM files using TFtoPL/PLtoTF.]",
	"You might try inserting a different font spec;",
	"e.g., type `I\\font<same font id>=<substitute font name>'.")
error()

@ \dg 앞 절의 정의부에서 매크로 |start_font_error_message|를 옮긴다. 이것은 |read_font_info|의 매개변수들을
쓰므로 함수 리터럴이다.

@<\.{TFM} 파일을 읽는 매크로들@>=
start_font_error_message := func() {
	print_err("Font ")
	sprint_cs(u)
	print_char('=')
	print_file_name(nom, aire, str(""))
	if s >= 0 {
		print(" at ")
		print_scaled(s)
		print("pt")
	} else if s != -1000 {
		print(" scaled ")
		print_int(-s)
	}
}

@ 보충: 원본의 이름은 ``글꼴 자료를 읽고 검사한다. \.{TFM} 파일이 잘못 만들어졌으면 |abort|, 이 글꼴을 위한
자리가 없으면 그렇다고 말하고 |goto done|, 그렇지 않으면 |incr(font_ptr)|하고 |goto done|''이다.

@<글꼴 자료를 읽고...@>=
@<|tfm_file|을 입력용으로 연다@>
@<\.{TFM}의 크기 필드들을 읽는다@>
@<크기 필드들로 글꼴 정보를 할당한다@>
@<\.{TFM}의 머리를 읽는다@>
@<문자 자료를 읽는다@>
@<상자 치수들을 읽는다@>
@<합자/커닝 프로그램을 읽는다@>
@<늘일 수 있는 문자의 조립법을 읽는다@>
@<글꼴 매개변수들을 읽는다@>
@<마지막 조정을 하고 |goto done|@>

@ @<|tfm_file|을 입력용으로...@>=
file_opened = false
if aire == str("") {
	pack_file_name(nom, TEX_font_area, str(".tfm"))
} else {
	pack_file_name(nom, aire, str(".tfm"))
}
if !b_open_in(&tfm_file) {
	goto bad_tfm
}
file_opened = true

@ 주의: 잘못 만든 \.{TFM} 파일은 주장하는 것보다 짧을 수도 있다. 그러므로 |read_font_info|가 |tfm_file^|를
참조하거나 |get(tfm_file)|이라고 할 때 |eof(tfm_file)|이 참일 수도 있다. 그런 상황이 시스템 오류 메시지를
일으킨다면 어떻게든 그것을 막아야 한다. 이를테면 |fget|을 `\ignorespaces|begin get(tfm_file);| |if
eof(tfm_file) then abort; end|\unskip'로 정의할 수 있다.
@^system dependencies@>

보충: 이 번역의 |b_get|은 파일 끝에서 오류를 내지 않고 |buf|를 0으로 놓으므로 그런 걱정이 없다(\os{29}
다음의 덧붙인 절).

@<\.{TFM} 파일을 읽는 매크로들@>=
fget := func() { b_get(&tfm_file) }
fbyte := func() eight_bits { return tfm_file.buf }
read_sixteen := func(x *halfword) bool { // |false|면 |abort|해야 한다
	*x = fbyte()
	if *x > 127 {
		return false
	}
	fget()
	*x = *x*0o400 + fbyte()
	return true
}
store_four_quarters := func(x *four_quarters) {
	fget(); a = fbyte(); qw.b0 = qi(a)
	fget(); b = fbyte(); qw.b1 = qi(b)
	fget(); c = fbyte(); qw.b2 = qi(c)
	fget(); d = fbyte(); qw.b3 = qi(d)
	*x = qw
}

@ @<\.{TFM}의 크기 필드들을...@>=
if !read_sixteen(&lf) { goto bad_tfm }
fget(); if !read_sixteen(&lh) { goto bad_tfm }
fget(); if !read_sixteen(&bc) { goto bad_tfm }
fget(); if !read_sixteen(&ec) { goto bad_tfm }
if bc > ec+1 || ec > 255 {
	goto bad_tfm
}
if bc > 255 { // |bc=256|이고 |ec=255|
	bc = 1
	ec = 0
}
fget(); if !read_sixteen(&nw) { goto bad_tfm }
fget(); if !read_sixteen(&nh) { goto bad_tfm }
fget(); if !read_sixteen(&nd) { goto bad_tfm }
fget(); if !read_sixteen(&ni) { goto bad_tfm }
fget(); if !read_sixteen(&nl) { goto bad_tfm }
fget(); if !read_sixteen(&nk) { goto bad_tfm }
fget(); if !read_sixteen(&ne) { goto bad_tfm }
fget(); if !read_sixteen(&np) { goto bad_tfm }
if lf != 6+lh+(ec-bc+1)+nw+nh+nd+ni+nl+nk+ne+np {
	goto bad_tfm
}
if nw == 0 || nh == 0 || nd == 0 || ni == 0 {
	goto bad_tfm
}

@ 첨자 오프셋 변수 |char_base|, |width_base|, |lig_kern_base|, |kern_base|, |exten_base|의 예비 설정은 나중에
|min_quarterword|를 빼서 바로잡는다. 그리고 |param_base|에서도 1을 뺀다. 그런 변칙은 나중까지 잊어버리는 것이
가장 좋다.

@<크기 필드들로...@>=
lf = lf - 6 - lh // |font_info|에 실어야 할 낱말이 |lf|개다
if np < 7 {
	lf = lf + 7 - np
} // 매개변수가 적어도 일곱 개 나타날 것이다
if font_ptr == font_max || fmem_ptr+lf > font_mem_size {
	@<글꼴을 싣지 못한다고 사과하고 |goto done|@>
}
f = font_ptr + 1
char_base[f] = fmem_ptr - bc
width_base[f] = char_base[f] + ec + 1
height_base[f] = width_base[f] + nw
depth_base[f] = height_base[f] + nh
italic_base[f] = depth_base[f] + nd
lig_kern_base[f] = italic_base[f] + ni
kern_base[f] = lig_kern_base[f] + nl - kern_base_offset
exten_base[f] = kern_base[f] + kern_base_offset + nk
param_base[f] = exten_base[f] + ne

@ @<글꼴을 싣지 못한다고...@>=
start_font_error_message()
print(" not loaded: Not enough room left")
@.Font x=xx not loaded...@>
help4("I'm afraid I won't be able to make use of this font,",
	"because my memory for character-size data is too small.",
	"If you're really stuck, ask a wizard to enlarge me.",
	"Or maybe try `I\\font<same font id>=<name of loaded font>'.")
error()
goto done

@ \TeX82에는 머리의 처음 두 낱말만 필요하다.

@<\.{TFM}의 머리를...@>=
if lh < 2 {
	goto bad_tfm
}
store_four_quarters(&font_check[f])
fget()
if !read_sixteen(&z) { // 이것은 음의 설계 크기를 거부한다
	goto bad_tfm
}
fget(); z = z*0o400 + fbyte(); fget(); z = (z * 0o20) + (fbyte() / 0o20)
if z < unity {
	goto bad_tfm
}
for lh > 2 {
	fget(); fget(); fget(); fget(); lh-- // 머리의 나머지는 무시한다
}
font_dsize[f] = z
if s != -1000 {
	if s >= 0 {
		z = s
	} else {
		z = xn_over_d(z, -s, 1000)
	}
}
font_size[f] = z

@ @<문자 자료를...@>=
for k = fmem_ptr; k <= width_base[f]-1; k++ {
	store_four_quarters(&font_info[k].qqqq)
	if a >= nw || b/0o20 >= nh || b%0o20 >= nd || c/4 >= ni {
		goto bad_tfm
	}
	switch c % 4 {
	case lig_tag: if d >= nl { goto bad_tfm }
	case ext_tag: if d >= ne { goto bad_tfm }
	case list_tag: @<문자 목록의 순환을 검사한다@>
	default: // |no_tag|
	}
}

@ 태그가 |list_tag|인 항목들로 함께 이어진 문자들의 순환이 없는지 확인하고 싶다. 그런 순환이 있으면 \TeX이 끝없는
루프에 빠질 것이기 때문이다. 그런 순환이 있으면 여기의 루틴이 순환에서 가장 큰 문자 코드를 처리할 때 그것을
찾아낸다.

@<문자 목록의 순환을...@>=
if !check_byte_range(d) {
	goto bad_tfm
}
for d < current_character_being_worked_on() {
	qw = char_info(f, d)
	// 주의: |qi(d)|가 아니다. |char_base[f]|를 아직 조정하지 않았기 때문이다
	if char_tag(qw) != list_tag {
		goto not_found
	}
	d = qo(rem_byte(qw)) // 목록의 다음 문자
}
if d == current_character_being_worked_on() {
	goto bad_tfm // 그렇다, 순환이 있다
}
not_found: ;

@ \dg 앞 절의 정의부를 옮긴다.

@<\.{TFM} 파일을 읽는 매크로들@>=
check_byte_range := func(c eight_bits) bool { return !(c < bc || c > ec) } // |false|면 |abort|
current_character_being_worked_on := func() int32 { return k + bc - fmem_ptr }

@ 네 바이트가 왼쪽부터 $(a,b,c,d)$인 |fix_word|는 수
$$x=\left\{\vcenter{\halign{$#$,\hfil\qquad&$#$일 때\hfil\cr
b\cdot2^{-4}+c\cdot2^{-12}+d\cdot2^{-20}&a=0\cr
-16+b\cdot2^{-4}+c\cdot2^{-12}+d\cdot2^{-20}&a=255\cr}}\right.$$
를 나타낸다. (설계 크기 단위로 나타낸 수의 크기는 16보다 작아야 하므로 |a|의 다른 값은 허용되지 않는다.) 우리는
이 양에 정수~|z|를 곱하고 싶은데, |z|는 $2^{27}$보다 작다고 알려져 있다. 만일 $|z|<2^{23}$이면 낱낱의 곱셈 $b\cdot z$,
$c\cdot z$, $d\cdot z$는 넘칠 수 없다. 그렇지 않으면 |z|를 2, 4, 8, 16으로 나누어서 $2^{23}$보다 작은 곱수를 얻고,
나중에 이것을 보정한다. 그래서 |z|가 $|z|^\prime=|z|/2^e$로 바뀌었다면 $\beta=2^{4-e}$로 두고, $a=0$이면
$$\lfloor(b+c\cdot2^{-8}+d\cdot2^{-16})\,z^\prime/\beta\rfloor$$
를 계산하고, $a=255$면 같은 양에서 $\alpha=2^{4+e}z^\prime$을 뺀 것을 계산한다. 이 계산은 \TeX을 컴퓨터 사이에
옮길 수 있도록 보장하려면 정확히 해야 한다.

@<상자 치수들을...@>=
@<|z|를 $|z|^\prime$으로 바꾸고 $\alpha$와 $\beta$를 계산한다@>
for k = width_base[f]; k <= lig_kern_base[f]-1; k++ {
	if !store_scaled(&font_info[k].sc) {
		goto bad_tfm
	}
}
if font_info[width_base[f]].sc != 0 {
	goto bad_tfm // \ID{width}[0]은 0이어야 한다
}
if font_info[height_base[f]].sc != 0 {
	goto bad_tfm // \ID{height}[0]은 0이어야 한다
}
if font_info[depth_base[f]].sc != 0 {
	goto bad_tfm // \ID{depth}[0]은 0이어야 한다
}
if font_info[italic_base[f]].sc != 0 {
	goto bad_tfm // \ID{italic}[0]은 0이어야 한다
}

@ \dg 앞 절의 정의부를 옮긴다.

@<\.{TFM} 파일을 읽는 매크로들@>=
store_scaled := func(x *scaled) bool { // |false|면 |abort|해야 한다
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

@ @<|z|를 $|z|^\prime$으로...@>=
alpha = 16
for z >= 0o40000000 {
	z = z / 2
	alpha = alpha + alpha
}
beta = 256 / alpha
alpha = alpha * z

@ @<합자/커닝 프로그램을...@>=
bch_label = 0o77777
bchar = 256
if nl > 0 {
	for k = lig_kern_base[f]; k <= kern_base[f]+kern_base_offset-1; k++ {
		store_four_quarters(&font_info[k].qqqq)
		if a > 128 {
			if 256*c+d >= nl {
				goto bad_tfm
			}
			if a == 255 {
				if k == lig_kern_base[f] {
					bchar = b
				}
			}
		} else {
			@<합자/커닝 명령 하나를 검사한다@>
		}
	}
	if a == 255 {
		bch_label = 256*c + d
	}
}
for k = kern_base[f] + kern_base_offset; k <= exten_base[f]-1; k++ {
	if !store_scaled(&font_info[k].sc) {
		goto bad_tfm
	}
}

@ \dg 앞 절의 정의부에서 매크로 |check_existence|를 옮긴다.

@<\.{TFM} 파일을 읽는 매크로들@>=
check_existence := func(c eight_bits) bool { // |false|면 |abort|해야 한다
	if !check_byte_range(c) {
		return false
	}
	qw = char_info(f, c) // 주의: |qi(c)|가 아니다
	return char_exists(qw)
}

@ \dg 앞 절에서 합자/커닝 명령 하나를 검사하는 부분을 떼어 낸다.

@<합자/커닝 명령 하나를...@>=
if b != bchar {
	if !check_existence(b) {
		goto bad_tfm
	}
}
if c < 128 { // 합자를 검사한다
	if !check_existence(d) {
		goto bad_tfm
	}
} else if 256*(c-128)+d >= nk {
	goto bad_tfm // 커닝을 검사한다
}
if a < 128 {
	if k-lig_kern_base[f]+a+1 >= nl {
		goto bad_tfm
	}
}

@ @<늘일 수 있는 문자의...@>=
for k = exten_base[f]; k <= param_base[f]-1; k++ {
	store_four_quarters(&font_info[k].qqqq)
	if a != 0 && !check_existence(a) { goto bad_tfm }
	if b != 0 && !check_existence(b) { goto bad_tfm }
	if c != 0 && !check_existence(c) { goto bad_tfm }
	if !check_existence(d) { goto bad_tfm }
}

@ \.{TFM} 파일이 너무 일찍 끝나지 않는지 검사한다. 그러나 낱말이 |lf|개보다 많은 파일에 대해서는 오류 메시지를
내지 않는다.

@<글꼴 매개변수들을...@>=
for k = 1; k <= np; k++ {
	if k == 1 { // 매개변수 |slant|는 순수한 수다
		fget(); sw = fbyte()
		if sw > 127 {
			sw = sw - 256
		}
		fget(); sw = sw*0o400 + fbyte(); fget(); sw = sw*0o400 + fbyte()
		fget(); font_info[param_base[f]].sc = (sw * 0o20) + (fbyte() / 0o20)
	} else if !store_scaled(&font_info[param_base[f]+k-1].sc) {
		goto bad_tfm
	}
}
if tfm_file.at_eof {
	goto bad_tfm
}
for k = np + 1; k <= 7; k++ {
	font_info[param_base[f]+k-1].sc = 0
}

@ 이제 마무리하자. \.{TFM} 파일에 관해 필요한 것은 모두 검사했고, 남은 일은 새 글꼴의 자료를 다듬는 것뿐이다.

보충: 원본의 매크로 |adjust(#)|는 |#[f]:=qo(#[f])|다. 여기서는 다섯 배열에 대해 그대로 펼쳐 썼다.

@<마지막 조정을...@>=
if np >= 7 {
	font_params[f] = np
} else {
	font_params[f] = 7
}
hyphen_char[f] = default_hyphen_char()
skew_char[f] = default_skew_char()
if bch_label < nl {
	bchar_label[f] = bch_label + lig_kern_base[f]
} else {
	bchar_label[f] = non_address
}
font_bchar[f] = qi(bchar)
font_false_bchar[f] = qi(bchar)
if bchar <= ec {
	if bchar >= bc {
		qw = char_info(f, bchar) // 주의: |qi(bchar)|가 아니다
		if char_exists(qw) {
			font_false_bchar[f] = non_char
		}
	}
}
font_name[f] = nom
font_area[f] = aire
font_bc[f] = bc; font_ec[f] = ec; font_glue[f] = null
char_base[f] = qo(char_base[f]) // |min_quarterword|만큼 넘친 것을 바로잡는다
width_base[f] = qo(width_base[f])
lig_kern_base[f] = qo(lig_kern_base[f])
kern_base[f] = qo(kern_base[f])
exten_base[f] = qo(exten_base[f])
param_base[f]--
fmem_ptr = fmem_ptr + lf
font_ptr = f
g = f
goto done

@ 이 표들의 형식을 잊어버리기 전에, 글꼴 정보에 관련된 \TeX의 기본 훑기 루틴 둘을 다루자.

@<글꼴에 관련된 것을...@>=
func scan_font_ident() {
	var f internal_font_number
	var m halfword
	@<공백도 호출도 아닌...@>
	if cur_cmd == def_font {
		f = cur_font()
	} else if cur_cmd == set_font {
		f = cur_chr
	} else if cur_cmd == def_family {
		m = cur_chr
		scan_four_bit_int()
		f = equiv(m + cur_val)
	} else {
		print_err("Missing font identifier")
@.Missing font identifier@>
		help2("I was looking for a control sequence whose",
			"current meaning has been defined by \\font.")
		back_error()
		f = null_font
	}
	cur_val = f
}

@ 다음 루틴은 `\.{\\fontdimen} |n| |f|'를 구현하는 데 쓰인다. 부르는 프로그램이 매개변수 값을 바꿀 생각이면 불
매개변수 |writing|을 |true|로 놓는다.

@<글꼴에 관련된 것을...@>=
func find_font_dimen(writing bool) { // |cur_val|을 |font_info|의 위치로 놓는다
	var f internal_font_number
	var n int32 // 매개변수 번호
	scan_int()
	n = cur_val
	scan_font_ident()
	f = cur_val
	if n <= 0 {
		cur_val = fmem_ptr
	} else {
		if writing && n <= space_shrink_code &&
			n >= space_code && font_glue[f] != null {
			delete_glue_ref(font_glue[f])
			font_glue[f] = null
		}
		if n > font_params[f] {
			if f < font_ptr {
				cur_val = fmem_ptr
			} else {
				@<마지막 글꼴의 매개변수 수를 늘린다@>
			}
		} else {
			cur_val = n + param_base[f]
		}
	}
	@<|cur_val=fmem_ptr|면 오류 메시지를 낸다@>
}

@ @<|cur_val=fmem_ptr|면...@>=
if cur_val == fmem_ptr {
	print_err("Font ")
	print_esc(font_id_text(f))
	print(" has only ")
	print_int(font_params[f])
	print(" fontdimen parameters")
@.Font x has only...@>
	help2("To increase the number of font parameters, you must",
		"use \\fontdimen immediately after the \\font is loaded.")
	error()
}

@ @<마지막 글꼴의 매개변수...@>=
for {
	if fmem_ptr == font_mem_size {
		overflow("font memory", font_mem_size)
	}
@:TeX capacity exceeded font memory}{\quad font memory@>
	font_info[fmem_ptr].sc = 0
	fmem_ptr++
	font_params[f]++
	if n == font_params[f] {
		break
	}
}
cur_val = fmem_ptr - 1 // 이것은 |param_base[f]+font_params[f]|와 같다

@ \TeX이 글꼴에 없는 문자를 조판하려 하면 문자 노드를 만들지 않는다. 그러므로 출력 루틴은 문자 노드를 보면 그
문자가 있다고 가정할 수 있다. 다음 프로시저는 사용자가 막지 않았다면 경고 메시지를 찍는다.

@<함수들@>=
func char_warning(f internal_font_number, c eight_bits) {
	if tracing_lost_chars() > 0 {
		begin_diagnostic()
		print_nl("Missing character: There is no ")
@.Missing character@>
		print_ASCII(c)
		print(" in font ")
		slow_print(font_name[f])
		print_char('!')
		end_diagnostic(false)
	}
}

@ 다음은 주어진 글꼴의 주어진 문자에 대한 문자 노드를 가리키는 포인터를 돌려주는 함수다. 그 문자가 없으면
대신 |null|을 돌려준다.

@<함수들@>=
func new_character(f internal_font_number, c eight_bits) pointer {
	var p pointer // 새로 할당한 노드
	if font_bc[f] <= c {
		if font_ec[f] >= c {
			if char_exists(char_info(f, qi(c))) {
				p = get_avail()
				set_font_field(p, f)
				set_character(p, qi(c))
				return p
			}
		}
	}
	char_warning(f, c)
	return null
}

@* 장치 독립 파일 형식.
\TeX\ 실행이 내놓는 가장 중요한 출력은 문자와 괘선이 인쇄된 쪽의 어디에 나타나야 하는지 지정하는 ``장치
독립''(\.{DVI}) 파일이다. 이 파일의 형식은 데이비드 R. 퍽스가 1979년에 설계했다. \.{DVI} 파일을 입력으로 받는
@^Fuchs, David Raymond@>
@^DVI files@>
프로그램으로 거의 모든 쓸 만한 조판 장치를 몰 수 있으며, 그런 \.{DVI}-에서-무엇이든 프로그램이 수십 개 쓰였다.
그래서 \TeX을 장치 독립 ``전단''으로 써서 \TeX의 출력을 여러 종류의 장비로 인쇄할 수 있다.

\.{DVI} 파일은 8비트 바이트의 흐름으로서, 기계어 같은 언어의 명령들의 나열로 볼 수 있다. 각 명령의 첫 바이트는
연산 코드이고, 그 뒤에 명령의 매개변수를 주는 바이트가 0개 이상 온다. 매개변수 자체는 잇닿은 바이트 여럿으로
이루어질 수 있다. 이를테면 `|set_rule|' 명령에는 매개변수가 둘 있는데, 저마다 네 바이트 길이다. 매개변수는 대개
음이 아닌 정수로 여기지만, 네 바이트짜리 매개변수와 거리를 나타내는 더 짧은 매개변수는 양수일 수도 음수일 수도
있다. 그런 매개변수는 2의 보수 표기로 주어진다. 이를테면 두 바이트짜리 거리 매개변수의 값은 $-2^{15}$와
$2^{15}-1$ 사이에 있다. \.{TFM} 파일에서처럼, 바이트 위치를 여럿 차지하는 수는 빅엔디언 순서로 나타난다.

\.{DVI} 파일은 ``서문''(preamble), 그 뒤에 하나 이상의 ``쪽''의 나열, 그 뒤에 ``후문''(postamble)으로 이루어진다.
서문은 그저 파일에 쓰인 치수를 정의하는 매개변수들을 가진 |pre| 명령이다. 이것이 맨 처음에 와야 한다. 각
``쪽''은 |bop| 명령, 그 뒤에 물리적인 쪽의 어디에 문자들을 놓을지 알려 주는 다른 명령들(몇 개든), 그 뒤에 |eop|
명령으로 이루어진다. 쪽들은 \TeX이 만든 순서대로 나타난다. 명령 |nop|과 \ID{fnt\_def}(이것들은 파일의 어느 두
명령 사이에도 올 수 있다)을 무시하면, 각 |eop| 명령 바로 뒤에는 |bop| 명령이나 |post| 명령이 온다. 뒤의 경우
파일에 쪽이 더 없고, 남은 바이트들이 후문을 이룬다. 후문에 관한 더 자세한 것은 나중에 설명하겠다.

\.{DVI} 명령의 어떤 매개변수는 ``포인터''다. 이것은 파일의 다른 어떤 바이트의 위치 번호를 주는 네 바이트짜리
양이다. 첫 바이트가 0번, 그다음이 1번, 하는 식이다. 이를테면 |bop| 명령의 매개변수 하나는 앞 |bop|을 가리킨다.
그래서 출력을 앞면이 위로 오게 쌓는 장치로 보낼 경우에 쪽을 거꾸로 읽을 수 있다. \.{DVI} 파일의 서문이 바이트
0부터 99까지 차지한다고 하자. 이제 첫 쪽이 이를테면 바이트 100부터 999까지 차지하고 둘째 쪽이 바이트
1000부터 1999까지 차지하면, 바이트 1000에서 시작하는 |bop|은 100을 가리키고 바이트 2000에서 시작하는 |bop|은
1000을 가리킨다. (맨 처음 |bop|, 곧 바이트 100에서 시작하는 것의 포인터는~$-1$이다.)

@ \.{DVI} 형식은 간결하면서도 기계가 쉽게 해석할 수 있게 하려는 것이다. 간결함은 정보의 대부분을 명시하지 않고
함축하게 해서 얻는다. \.{DVI}를 읽는 프로그램은 한 쪽의 명령들을 읽으면서 몇 가지 양을 추적한다. (a)~현재
글꼴 |f|는 정수다. 이 값은 \ID{fnt}와 \ID{fnt\_num} 명령으로만 바뀐다. (b)~쪽 위의 현재 위치는 가로 좌표와 세로
좌표라고 부르는 두 수 |h|와 |v|로 주어진다. 두 좌표는 쪽의 왼쪽 위 모서리에서 0이다. 오른쪽으로 가면 가로
좌표가 커지고, 아래로 가면 세로 좌표가 커진다. 그러므로 좌표는 세로 방향이 뒤집힌 것만 빼면 본질적으로 데카르트
좌표다. 좌표 |(h,v)|의 데카르트 판은 |(h,-v)|일 것이다. (c)~현재의 간격 양은 네 수 |w|, |x|, |y|, |z|로 주어진다. 그 가운데 |w|와~|x|는
가로 간격에, |y|와~|z|는 세로 간격에 쓰인다. (d)~|(h,v,w,x,y,z)| 값을 담는 스택이 있다. \.{DVI} 명령 |push|와
|pop|이 현재의 연산 수준을 바꾸는 데 쓰인다. 현재 글꼴~|f|는 쌓고 꺼내지 않는다는 데 주목하라. 스택에는 위치에 관한
정보만 들어 있다.

양 |h|, |v|, |w|, |x|, |y|, |z|의 값은 부호를 포함해서 32비트까지의 부호 있는 정수다. 이것들은 물리적 거리를
나타내므로, |h|를~1 늘리면 오른쪽으로 어떤 작은 거리를 움직인다는 뜻이 되는 작은 측정 단위가 있다. 실제 측정
단위는 아래에서 설명하듯이 바뀔 수 있다. \TeX은 \.{DVI} 출력이 sp 단위, 곧 눈금 포인트로 되게 해서, \TeX의 자료
구조에 있는 모든 |scaled| 치수와 맞도록 한다.

@ 다음은 \.{DVI} 파일에 나타날 수 있는 모든 명령의 목록이다. 각 명령은 기호 이름(이를테면 |bop|), 연산 코드
바이트(이를테면 139), 그리고 (있다면) 매개변수로 지정된다. 매개변수 뒤에는 몇 바이트를 차지하는지 알려 주는
대괄호 속의 수가 온다. 이를테면 `|p[4]|'는 매개변수 |p|가 네 바이트 길이라는 뜻이다.

\yskip\hang|set_char_0| 0. 글꼴~|f|의 문자 번호~0을 그 문자의 기준점이 |(h,v)|에 오도록 조판한다. 그런 다음 |h|를
그 문자의 너비만큼 늘린다. 문자의 너비가 0이거나 음수일 수 있으므로 이 명령 뒤에 |h|가 커진다고 확신할 수는
없지만, 대개 |h|는 커진다.

\yskip\hang\ID{set\_char\_1}부터 \ID{set\_char\_127}까지(연산 코드 1부터 127까지). 명령 |set_char_0|의 연산을 하되, 문자~0
대신 번호가 연산 코드와 맞는 문자를 쓴다.

\yskip\hang|set1| 128 |c[1]|. 명령 |set_char_0|과 같지만, 문자 번호~|c|를 조판한다. \TeX82는 범위 |128<=c<256|의 문자에
이 명령을 쓴다.

\yskip\hang|@!set2| 129 |c[2]|. 명령 |set1|과 같지만, |c|가~두 바이트 길이여서 범위 |0<=c<65536|에 있다. \TeX82는 이
명령을 결코 쓰지 않지만, 동양 언어를 다루는 \TeX의 확장에는 쓸모가 있을 것이다.
@^oriental characters@>@^Chinese characters@>@^Japanese characters@>

\yskip\hang|@!set3| 130 |c[3]|. 명령 |set1|과 같지만, |c|가~세 바이트 길이여서 $2^{24}-1$만큼 클 수 있다. 중국어조차 이렇게
많은 문자를 갖고 있지는 않지만, 이 명령은 아직 내다보지 못한 어떤 확장에 쓸모 있을지도 모른다.

\yskip\hang|@!set4| 131 |c[4]|. 명령 |set1|과 같지만, |c|가~네 바이트 길이다. 상상해 보라.

\yskip\hang|set_rule| 132 |a[4]| |b[4]|. 높이가~|a|이고 너비가~|b|인 꽉 찬 검은 직사각형을 그 왼쪽 아래 모서리가
|(h,v)|에 오도록 조판한다. 그런 다음 |h:=h+b|로 놓는다. 다만 |a<=0|이거나 |b<=0|이면 아무것도 조판하지 않아야 한다.
또 |b<0|이면 다른 아무 일도 일어나지 않더라도 |h|의 값은 줄어든다는 데 주목하라. \MF와의 일관성이 보장되도록 괘선을
조판하는 방법에 관한 자세한 것은 아래를 보라.

\yskip\hang|@!put1| 133 |c[1]|. 글꼴~|f|의 문자 번호~|c|를 그 문자의 기준점이 |(h,v)|에 오도록 조판한다. (`put'
명령들은 `set' 명령들과 똑같지만, 문자나 괘선을 내보내기만 하고 그 뒤에 기준점을 옮기지 않는다.)

\yskip\hang|@!put2| 134 |c[2]|. 명령 |set2|와 같지만, |h|를 바꾸지 않는다.

\yskip\hang|@!put3| 135 |c[3]|. 명령 |set3|과 같지만, |h|를 바꾸지 않는다.

\yskip\hang|@!put4| 136 |c[4]|. 명령 |set4|와 같지만, |h|를 바꾸지 않는다.

\yskip\hang|put_rule| 137 |a[4]| |b[4]|. 명령 |set_rule|과 같지만, |h|를 바꾸지 않는다.

\yskip\hang|nop| 138. 아무 연산도 하지 않는다. \.{DVI} 명령 사이에는 |nop|이 몇 개든 올 수 있지만, 명령과 그
매개변수 사이나 두 매개변수 사이에는 끼워 넣을 수 없다.

\yskip\hang|bop| 139 $c_0[4]$ $c_1[4]$ $\ldots$ $c_9[4]$ $p[4]$. 쪽의 시작: |(h,v,w,x,y,z):=(0,0,0,0,0,0)|으로 놓고
스택을 비운다. 현재 글꼴 |f|를 정의되지 않은 값으로 놓는다. 열 개의 $c_i$ 매개변수는 이 쪽에 대해 \.{\\shipout}을
불렀을 때 \TeX에 있던 \.{\\count0} $\ldots$ \.{\\count9}의 값을 담는다. 사용자가 \.{DVI} 파일의 일부만 인쇄하고
싶을 때 쪽을 알아보는 데 쓸 수 있다. 매개변수 |p|는 파일에서 앞 |bop|을 가리킨다. 첫 |bop|에서는 $p=-1$이다.

\yskip\hang|eop| 140. 쪽의 끝: 앞 |bop| 뒤로 읽은 것을 인쇄한다. 이 시점에 스택은 비어 있어야 한다. (대부분의
출력 장치를 모는 \.{DVI}를 읽는 프로그램은 방금 끝난 쪽에 나타나는 재료를 버퍼에 담아 두었을 것이다. 이 재료는
대부분 |v| 좌표 순서로, 그리고 (|v|가 같으면) |h|~좌표 순서로 되어 있지만 완전히 그렇지는 않다. 그래서 대개 해당
장치에 알맞은 어떤 순서로 정렬해야 한다.)

\yskip\hang|push| 141. |(h,v,w,x,y,z)|의 현재 값을 스택의 맨 위에 쌓는다. 이 값들은 하나도 바꾸지 않는다. 글꼴 |f|는 쌓지
않는다는 데 주목하라.

\yskip\hang|pop| 142. 스택의 맨 위 값 여섯 개를 꺼내 차례로 |(h,v,w,x,y,z)|에 대입한다. 명령 |pop|의 수는 결코
|push|의 수를 넘어서는 안 된다. 명령 |pop|을 만났을 때 스택이 비어 있으면 아주 난처할 것이기 때문이다.

\yskip\hang|right1| 143 |b[1]|. 오른쪽으로 |b|단위 움직인다. 곧 |h:=h+b|로 놓는다. 매개변수는 2의 보수 표기의 부호
있는 수로서 |-128<=b<128|이다. 매개변수가 음수면 기준점은 왼쪽으로 움직인다.

\yskip\hang|@!right2| 144 |b[2]|. 명령 |right1|과 같지만, |b|는 범위 |-32768<=b<32768|의 두 바이트짜리 양이다.

\yskip\hang|@!right3| 145 |b[3]|. 명령 |right1|과 같지만, |b|는 범위 |@t$-2^{23}$@><=b<@t$2^{23}$@>|의 세 바이트짜리
양이다.

\yskip\hang|@!right4| 146 |b[4]|. 명령 |right1|과 같지만, |b|는 범위 |@t$-2^{31}$@><=b<@t$2^{31}$@>|의 네 바이트짜리
양이다.

\yskip\hang|w0| 147. 오른쪽으로 |w|단위 움직인다. 곧 |h:=h+w|로 놓는다. 운이 좋으면 이 매개변수 없는 명령으로 대개 충분할
것이다. 같은 종류의 움직임이 잇달아 여러 번 일어나기 때문이다. 다음 명령들은 |w|가 어떻게 특정한 값을 얻는지
설명한다.

\yskip\hang|w1| 148 |b[1]|. 두 값을 |w:=b|와 |h:=h+b|로 놓는다. 매개변수 |b|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=b<128|이다. 이 명령은 현재의 |w|~간격을 바꾸고 오른쪽으로 |b|만큼 움직인다.

\yskip\hang|@!w2| 149 |b[2]|. 명령 |w1|과 같지만, |b|는 두 바이트 길이로 |-32768<=b<32768|이다.

\yskip\hang|@!w3| 150 |b[3]|. 명령 |w1|과 같지만, |b|는 세 바이트 길이로 |@t$-2^{23}$@><=b<@t$2^{23}$@>|이다.

\yskip\hang|@!w4| 151 |b[4]|. 명령 |w1|과 같지만, |b|는 네 바이트 길이로 |@t$-2^{31}$@><=b<@t$2^{31}$@>|이다.

\yskip\hang|x0| 152. 오른쪽으로 |x|단위 움직인다. 곧 |h:=h+x|로 놓는다. 이 `|x|' 명령들은 `|w|' 명령들과 같지만, |w| 대신
|x|에 관계한다.

\yskip\hang|x1| 153 |b[1]|. 두 값을 |x:=b|와 |h:=h+b|로 놓는다. 매개변수 |b|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=b<128|이다. 이 명령은 현재의 |x|~간격을 바꾸고 오른쪽으로 |b|만큼 움직인다.

\yskip\hang|@!x2| 154 |b[2]|. 명령 |x1|과 같지만, |b|는 두 바이트 길이로 |-32768<=b<32768|이다.

\yskip\hang|@!x3| 155 |b[3]|. 명령 |x1|과 같지만, |b|는 세 바이트 길이로 |@t$-2^{23}$@><=b<@t$2^{23}$@>|이다.

\yskip\hang|@!x4| 156 |b[4]|. 명령 |x1|과 같지만, |b|는 네 바이트 길이로 |@t$-2^{31}$@><=b<@t$2^{31}$@>|이다.

\yskip\hang|down1| 157 |a[1]|. 아래로 |a|단위 움직인다. 곧 |v:=v+a|로 놓는다. 매개변수는 2의 보수 표기의 부호 있는
수로서 |-128<=a<128|이다. 매개변수가 음수면 기준점은 위로 움직인다.

\yskip\hang|@!down2| 158 |a[2]|. 명령 |down1|과 같지만, |a|는 범위 |-32768<=a<32768|의 두 바이트짜리 양이다.

\yskip\hang|@!down3| 159 |a[3]|. 명령 |down1|과 같지만, |a|는 범위 |@t$-2^{23}$@><=a<@t$2^{23}$@>|의 세 바이트짜리
양이다.

\yskip\hang|@!down4| 160 |a[4]|. 명령 |down1|과 같지만, |a|는 범위 |@t$-2^{31}$@><=a<@t$2^{31}$@>|의 네 바이트짜리
양이다.

\yskip\hang|y0| 161. 아래로 |y|단위 움직인다. 곧 |v:=v+y|로 놓는다. 운이 좋으면 이 매개변수 없는 명령으로 대개 충분할
것이다. 같은 종류의 움직임이 잇달아 여러 번 일어나기 때문이다. 다음 명령들은 |y|가 어떻게 특정한 값을 얻는지
설명한다.

\yskip\hang|y1| 162 |a[1]|. 두 값을 |y:=a|와 |v:=v+a|로 놓는다. 매개변수 |a|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=a<128|이다. 이 명령은 현재의 |y|~간격을 바꾸고 아래로 |a|만큼 움직인다.

\yskip\hang|@!y2| 163 |a[2]|. 명령 |y1|과 같지만, |a|는 두 바이트 길이로 |-32768<=a<32768|이다.

\yskip\hang|@!y3| 164 |a[3]|. 명령 |y1|과 같지만, |a|는 세 바이트 길이로 |@t$-2^{23}$@><=a<@t$2^{23}$@>|이다.

\yskip\hang|@!y4| 165 |a[4]|. 명령 |y1|과 같지만, |a|는 네 바이트 길이로 |@t$-2^{31}$@><=a<@t$2^{31}$@>|이다.

\yskip\hang|z0| 166. 아래로 |z|단위 움직인다. 곧 |v:=v+z|로 놓는다. 이 `|z|' 명령들은 `|y|' 명령들과 같지만, |y| 대신 |z|에
관계한다.

\yskip\hang|z1| 167 |a[1]|. 두 값을 |z:=a|와 |v:=v+a|로 놓는다. 매개변수 |a|의 값은 2의 보수 표기의 부호 있는 양으로서
|-128<=a<128|이다. 이 명령은 현재의 |z|~간격을 바꾸고 아래로 |a|만큼 움직인다.

\yskip\hang|@!z2| 168 |a[2]|. 명령 |z1|과 같지만, |a|는 두 바이트 길이로 |-32768<=a<32768|이다.

\yskip\hang|@!z3| 169 |a[3]|. 명령 |z1|과 같지만, |a|는 세 바이트 길이로 |@t$-2^{23}$@><=a<@t$2^{23}$@>|이다.

\yskip\hang|@!z4| 170 |a[4]|. 명령 |z1|과 같지만, |a|는 네 바이트 길이로 |@t$-2^{31}$@><=a<@t$2^{31}$@>|이다.

\yskip\hang|fnt_num_0| 171. 현재 글꼴을 |f:=0|으로 놓는다. 글꼴 0은 아래에서 설명하듯이 \ID{fnt\_def} 명령으로 미리 정의되어
있어야 한다.

\yskip\hang\ID{fnt\_num\_1}부터 \ID{fnt\_num\_63}까지(연산 코드 172부터 234까지). 저마다 |f:=1|, \dots,
\hbox{|f:=63|}으로 놓는다.

\yskip\hang|fnt1| 235 |k[1]|. 현재 글꼴을 |f:=k|로 놓는다. \TeX82는 범위 |64<=k<256|의 글꼴 번호에 이 명령을 쓴다.

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

\yskip\hang|fnt_def1| 243 |k[1]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<256|이다. 글꼴 정의는 곧 설명하겠다.

\yskip\hang|@!fnt_def2| 244 |k[2]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<65536|이다.

\yskip\hang|@!fnt_def3| 245 |k[3]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|0<=k<@t$2^{24}$@>|이다.

\yskip\hang|@!fnt_def4| 246 |k[4]| |c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|. 글꼴 |k|를 정의한다. 여기서
|@t$-2^{31}$@><=k<@t$2^{31}$@>|이다.

\yskip\hang|pre| 247 |i[1]| |num[4]| |den[4]| |mag[4]| |k[1]| |x[k]|. 서문의 시작. 이것은 파일의 맨 처음에 와야
한다. 매개변수 |i|, |num|, |den|, |mag|, |k|, |x|는 아래에서 설명한다.

\yskip\hang|post| 248. 후문의 시작. 아래를 보라.

\yskip\hang|post_post| 249. 후문의 끝. 아래를 보라.

\yskip\noindent 명령 250--255는 지금은 정의되어 있지 않다.

@ @<정의@>=
const (
	@!set_char_0 = 0 // 문자 0을 조판하고 오른쪽으로 움직인다
	@!set1 = 128 // 문자를 조판하고 오른쪽으로 움직인다
	@!set_rule = 132 // 괘선을 조판하고 오른쪽으로 움직인다
	@!put_rule = 137 // 괘선을 조판한다
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
	@!fnt_num_0 = 171 // 현재 글꼴을 0으로 놓는다
	@!fnt1 = 235 // 현재 글꼴을 정한다
	@!xxx1 = 239 // \.{DVI} 원시 명령의 확장
	@!xxx4 = 242 // 길어질 수 있는 \.{DVI} 원시 명령의 확장
	@!fnt_def1 = 243 // 글꼴 번호의 뜻을 정의한다
	@!pre = 247 // 서문
	@!post = 248 // 후문의 시작
	@!post_post = 249 // 후문의 끝
)

@ 서문에는 파일 전체에 관한 기본 정보가 들어 있다. 앞에서 말했듯이 매개변수가 여섯 개 있다.
$$\hbox{|@!i[1]| |@!num[4]| |@!den[4]| |@!mag[4]| |@!k[1]| |@!x[k]|.}$$
바이트 |i|는 \.{DVI} 형식을 밝힌다. 지금 이 바이트는 언제나~2로 놓인다. (값 |i=3|은 지금 오른쪽에서 왼쪽으로의
조판과 왼쪽에서 오른쪽으로의 조판을 섞을 수 있는 확장 형식에 쓰인다. 언젠가 \.{DVI} 형식이 또 한 번 호환되지 않는
변화를 겪으면, 아마 2048년쯤에, |i=4|로 놓을 것이다.)

다음 두 매개변수 |num|과 |den|은 측정 단위를 정의하는 양의 정수다. 이것들은 \.{DVI} 파일의 모든 치수에 곱해서
$10^{-7}$미터 단위의 길이를 얻을 수 있는 분수의 분자와 분모다. 길이 $\rm 7227{pt} = 254{cm}$이고 \TeX은 1포인트가
$2^{16}$\,sp인 눈금 포인트로 일하므로, \TeX은 $|num|/|den|=(254\cdot10^5)/(7227\cdot2^{16})=25400000/473628672$로
놓는다.
@^sp@>

매개변수 |mag|는 \TeX이 \.{\\mag}라고 부르는 것, 곧 원하는 확대 배율의 1000배다. 그러므로 치수에 곱하는 실제
분수는 $|mag|\cdot|num|/1000|den|$이다. \TeX\ 원본 문서가 `\.{true}' 치수를 하나도 요구하지 않는다면, 그리고 다른
\.{\\mag} 설정을 지정하는 것만으로 그 문서를 바꾼다면, \TeX이 만드는 \.{DVI} 파일은 서문과 후문의 |mag| 값 말고는
전혀 바뀌지 않는다는 데 주목하라. (멋진 \.{DVI}를 읽는 프로그램은 \.{DVI} 파일을 인쇄할 때 사용자가 |mag|~설정을
무시할 수 있게 해 준다.)

마지막으로 |k|와 |x|는 \.{DVI}를 쓰는 쪽이 주석을 넣을 수 있게 해 준다. 주석은 더 해석되지 않는다. 주석 |x|의
길이는 |k|이고, |0<=k<256|이다.

@<정의@>=
const @!id_byte = 2 // 여기서 설명하는 종류의 \.{DVI} 파일을 밝힌다

@ 주어진 글꼴 번호 |k|에 대한 글꼴 정의에는 매개변수
$$\hbox{|c[4]| |s[4]| |d[4]| |a[1]| |l[1]| |n[a+l]|}$$
가 더 들어 있다. 네 바이트짜리 값 |c|는 \TeX이 이 글꼴의 \.{TFM} 파일에서 찾은 검사합이다. 이 값은 이 \.{DVI} 파일을
읽는 프로그램들이 찾은 글꼴의 검사합과 맞아야 한다.
@^check sum@>

매개변수 |s|에는 글꼴 |k|의 문자 너비에 적용하는 고정 소수점 배율이 들어 있다. \.{TFM} 파일과 다른 글꼴 파일의
글꼴 치수들은 이 양에 대한 상대값인데, 이 양을 이 문서의 다른 곳에서는 ``at 크기''라고 부른다. 그 값은 언제나
양수이고 $2^{27}$보다 작다. 이것은 다른 \.{DVI} 치수와 같은 단위로, 곧 \TeX82가 파일을 만들었을 때는 sp 단위로
주어진다. 매개변수 |d|는 |s|와 비슷하다. 그것은 ``설계 크기''이고, (|s|처럼) \.{DVI} 단위로 주어진다. 그러므로 글꼴
|k|는 보통 크기의 $|mag|\cdot s/1000d$배로 쓰인다.

글꼴 정의의 나머지 부분은 글꼴의 외부 이름을 주는데, 그것은 길이가 |a+l|인 {\mc ASCII} 문자열이다. 수 |a|는
``영역''이나 디렉터리의 길이이고, |l|은 글꼴 이름 자체의 길이다. 길이 |a|가 0이면 표준 지역 시스템 글꼴 영역을 쓰기로 되어
있다. 필드 |n|의 처음 |a|바이트에 영역이 들어 있다.

글꼴 정의는 특정한 글꼴 번호를 처음 쓰기 전에 나타나야 한다. 글꼴 |k|를 한번 정의하면 다시 정의해서는 안 된다.
그러나 아래에서 보겠지만 글꼴 정의는 쪽들 안에도 후문에도 나타나므로, 이런 뜻에서 각 글꼴 번호는 정의된다면
정확히 두 번 정의된다. 명령 |nop|처럼 글꼴 정의는 첫 |bop| 앞에, 또는 |eop|와 |bop| 사이에 나타날 수 있다.

@ 때로는 가로 괘선이나 세로 괘선을 글꼴의 문자들의 어떤 특징과 정확히 맞추는 것이 바람직하다. 다음 원칙들을
지키면 \.{DVI} 출력과 \MF가 만든 문자들이 정확히 맞도록 보장할 수 있다. (1)~\MF\ 문자는, 괘선의 아래쪽 가장자리나
왼쪽 가장자리와 맞추어야 할 아래쪽 가장자리나 왼쪽 가장자리가 기준점에, 곧 \MF\ 래스터의 0행과 0열에 나타나도록
놓아야 한다. 그러면 화소 크기가 \.{DVI} 파일의 측정 단위의 정확한 배수가 아니더라도 괘선의 위치가 다르게
반올림되지 않는다. (2)~높이가 $a>0$이고 너비가 $b>0$인 조판된 괘선은, \MF\ 좌표가 |0<=x<@t$\alpha$@>b|와
|0<=y<@t$\alpha$@>a|를 만족하는 래스터 위치에만 정확히 검은 화소가 있는 \MF가 만든 문자와 같아야 한다. 여기서
$\alpha$는 \.{DVI} 단위당 화소 수다.
@^METAFONT@>
@^alignment of rules with characters@>
@^rules aligning with characters@>

@ \.{DVI} 파일의 마지막 쪽 뒤에는 `|post|'가 온다. 이 명령은 후문을 시작하는데, 후문은 \TeX이 파일에 관해 모은
중요한 사실들을 요약해서, 자료의 일부를 꽤 효율적으로 인쇄할 수 있게 해 준다. 후문의 꼴은 다음과 같다.
$$\vbox{\halign{\hbox{#\hfil}\cr
  |post| |p[4]| |num[4]| |den[4]| |mag[4]| |l[4]| |u[4]| |s[2]| |t[2]|\cr
  $\langle\,$글꼴 정의들$\,\rangle$\cr
  |post_post| |q[4]| |i[1]| 223들$[\ge4]$\cr}}$$
여기서 |p|는 파일의 마지막 |bop|을 가리키는 포인터다. 다음 세 매개변수 |num|, |den|, |mag|는 서문에 나타난 양들의
사본이다.

매개변수 |l|과 |u|는 저마다 가장 높은 쪽의 높이 더하기 깊이와 가장 넓은 쪽의 너비를 파일의 다른 치수와 같은 단위로
준다. 이 수들은 \.{DVI}를 읽는 프로그램이 낱낱의 ``쪽''을 큰 필름이나 종이 위에 배치하는 데 쓸 수 있다. 그러나 보통
크기의 종이에 출력하는 표준 관례는 각 쪽의 왼쪽 위 모서리가 왼쪽과 위에서 정확히 1인치 떨어지도록 놓는 것이다.
경험에 따르면 출력을 영리하게 가운데 맞추려 드는 \.{DVI}-프린터 소프트웨어를 설계하는 것은 현명하지 못하다. 왼쪽
위 모서리의 위치를 고정하는 편이 사용자가 이해하고 다루기에 가장 쉽다. 그래서 |l|과~|u|는 흔히 무시된다.

매개변수 |s|는 이 파일을 처리하는 데 필요한 스택의 최대 깊이(곧 |pop| 명령에 대한 |push| 명령의 가장 큰 초과량)다.
그다음에 들어 있는 쪽(|bop| 명령)의 총수 |t|가 온다.

후문은 글꼴 정의들로 이어지는데, 이것은 앞에서 설명한 \ID{fnt\_def} 명령들이 몇 개든 오는 것이다. 그 사이사이에
|nop| 명령이 낄 수 있다. \.{DVI} 파일에 쓰인 글꼴 번호는 저마다 정확히 두 번 정의되어야 한다. 한 번은 \ID{fnt}
명령으로 처음 골라지기 전에, 한 번은 후문에서.

@ 글꼴 정의의 끝을 알리는 |post_post| 바이트 다음에 오는 후문의 마지막 부분에는 후문을 시작한 |post| 명령을 가리키는
포인터 |q|가 들어 있다. 그다음에는 식별 바이트 |i|가 오는데, 이것은 지금 서문에서처럼~2와 같다.

바이트 |i| 뒤에는 모두 십진수 223(곧 팔진수 \.{'337})과 같은 바이트가 넷 이상 온다. \TeX은 파일의 전체 길이가 4바이트의
배수가 될 때까지 이 꼬리 바이트를 넷에서 일곱 개 내보낸다. 낱말 하나에 네 바이트를 꾸려 넣는 기계에서는 이것이
가장 잘 맞기 때문이다. 그러나 적어도 넷만 있으면 223이 몇 개든 허용된다. 사실상 223은 맨 끝에 덧붙이는 일종의
서명이다.
@^Fuchs, David Raymond@>

\.{DVI} 파일을 이렇게 신기한 방법으로 끝맺으면, \TeX은 후문을 마지막에 쓰고 싶어 하는데도 \.{DVI}를 읽는 프로그램은
대부분의 컴퓨터에서 후문을 먼저 찾을 수 있다. 대부분의 운영체제는 파일의 낱낱의 낱말이나 바이트에 무작위로 접근할
수 있게 해 주므로, \.{DVI}를 읽는 쪽은 끝에서 시작해서 식별 바이트를 찾을 때까지 223들을 거슬러 건너뛸 수 있다.
그런 다음 네 바이트를 되돌아가서 |q|를 읽고 파일의 바이트 |q|로 옮겨 갈 수 있다. 물론 이 바이트에는 값
248(|post|)이 들어 있어야 한다. 이제 후문을 읽을 수 있으므로, \.{DVI}를 읽는 쪽은 쪽들을 조판하는 데 필요한 모든
정보를 알아낼 수 있다. \.{DVI} 파일을 꽤 빠르게 건너뛰며 특정한 쪽을 찾을 수도 있다는 데 주목하라. 그렇게 하면
시간이 많이 절약된다. 실제 작업에 쓰이는 \.{DVI} 파일은 큰 경향이 있기 때문이다.

그러나 불행히도 표준 \PASCAL에는 파일의 임의의 위치에 접근하는 능력이 없고, 파일의 길이를 알아내는 능력조차
@^system dependencies@>
없다. 요즘은 거의 모든 시스템이 필요한 능력을 주므로, \.{DVI} 형식은 현대의 운영체제에서 가장 효율적으로 돌아가도록
설계되었다. 그러나 \.{DVI} 파일을 표준 \PASCAL의 제약 아래에서 처리해야 한다면, 그냥 앞에서 뒤로 읽으면 된다. 필요한
머리 정보는 서문과 글꼴 정의에 들어 있기 때문이다. (후문에만 나타나는 매개변수 |l|과 |u|와 |s|와 |t|는 편리하지만
반드시 필요하지는 않은 ``장식''이다.)

@* 쪽 내보내기.
\TeX의 눈과 위를 살펴보았으니, 이제 창자에 이르렀다.
@^bowels@>

프로시저 |ship_out|은 상자를 가리키는 포인터를 받는다. 그 임무는 그 상자를 \.{DVI} 꼴로 묘사해서 ``쪽'' 하나를
|dvi_file|에 출력하는 것이다. \.{DVI} 좌표 $(h,v)=(0,0)$은 내보내는 상자의 왼쪽 위 모서리에 해당해야 한다.

상자는 상자 안의 상자 안에 있을 수 있으므로, |ship_out|의 주된 일은 서로 재귀적인 두 루틴 |hlist_out|과
|vlist_out|이 한다. 이것들은 가로 상자와 세로 상자 안의 가로 목록과 세로 목록을 훑는다.

낱낱의 쪽을 처리하면서 쪽 전체에 관한 정보를 쌓아 두어야 한다. 그런 통계는 후문에서 알려야 하기 때문이다. 전역
변수 |total_pages|, |max_v|, |max_h|, |max_push|, |last_bop|이 이 정보를 기록하는 데 쓰인다.

변수 |doing_leaders|는 리더를 출력하는 동안 |true|다. 변수 |dead_cycles|에는 마지막 |ship_out| 뒤로 출력 루틴이
시작된 횟수가 들어 있다.

루틴 |vlist_out|과 |hlist_out|에서 쓰려고 전역 변수 몇 개를 여기서 더 정의한다. 이것들은 지역 변수일 수도 있었지만, 그러면
상자가 깊이 중첩될 때 스택 공간이 낭비된다. 이 변수들의 값은 재귀 호출 동안에는 필요 없기 때문이다.
@^recursion@>

@<전역 변수@>=
var @!total_pages int32 // 내보낸 쪽의 수
var @!max_v scaled // 지금까지 내보낸 쪽의 높이 더하기 깊이의 최댓값
var @!max_h scaled // 지금까지 내보낸 쪽의 너비의 최댓값
var @!max_push int32 // 지금까지 만난 |push| 명령의 가장 깊은 중첩
var @!last_bop int32 // \.{DVI} 출력에서 앞 |bop|의 위치
var @!dead_cycles int32 // 아무것도 내보내지 않은 최근 출력의 수
var @!doing_leaders bool // 리더 상자 안에 있나?
@#
var @!c, @!f quarterword // 현재 |char_node|의 문자와 글꼴
var @!rule_ht, @!rule_dp, @!rule_wd scaled // 지금 출력하는 괘선의 크기
var @!g pointer // 현재 글루 명세
var @!lq, @!lr int32 // 리더 계산에 쓰는 양들

@ @<핵심 변수들의...@>=
total_pages = 0
max_v = 0
max_h = 0
max_push = 0
last_bop = -1
doing_leaders = false
dead_cycles = 0
cur_s = -1

@ \.{DVI} 바이트는 출력 파일에 곧바로 쓰지 않고 버퍼에 출력한다. 그러면 서브루틴 호출의 부담을 줄일 수 있어서
계산이 눈에 띄게 빨라진다. \.{DVI} 바이트의 출력은 \TeX의 안쪽 루프의 일부이기 때문이다. 다른 이점도 있다. 출력을 더
간결하게 하려고 버퍼 안의 명령을 바꿀 수 있다. 이를테면 `|down2|' 명령을 `|y2|'로 바꾸면 뒤따르는 `|y0|' 명령을 쓸
수 있게 되어 두 바이트를 아낀다.

출력 버퍼는 크기가 같은 두 부분으로 나뉜다. 구간 |dvi_buf[0..half_buf-1]|에 있는 바이트가 앞쪽 절반을 이루고,
|dvi_buf[half_buf..dvi_buf_size-1]|에 있는 바이트가 뒤쪽 절반을 이룬다. 전역 변수 |dvi_ptr|는 다음 출력 바이트를 받을
위치를 가리킨다. 이 포인터가 |dvi_limit|에 이르면, 다음에 침범할 반쪽 버퍼를 출력으로 보내고 |dvi_limit|를 다른
값으로 바꾼다. 한계 |dvi_limit|는 언제나 두 값 |half_buf|나 |dvi_buf_size| 가운데 하나와 같다. 그러므로 작업의 맨 처음을
빼고는 언제나 적어도 반쪽 버퍼만큼의 정보가 들어 있다.

\.{DVI} 파일의 바이트에는 0부터 차례로 번호를 매긴다. 다음에 만들 바이트의 번호는 |dvi_offset+dvi_ptr|다. 바이트는
번호가 |>=dvi_gone|일 때에만 버퍼에 있다.

@<바깥 블록의 형@>=
type @!dvi_index = int32 // 출력 버퍼의 첨자; |0..dvi_buf_size|

@ 어떤 시스템에서는 |dvi_buf|를 |packed| 배열로 하는 편이 더 효율적일 수 있다. 네 바이트를 한꺼번에 출력하기가 더
쉬울 수 있기 때문이다.
@^system dependencies@>

@<전역 변수@>=
var @!dvi_buf [dvi_buf_size + 1]eight_bits // \.{DVI} 출력을 위한 버퍼
var @!half_buf dvi_index // |dvi_buf_size|의 절반
var @!dvi_limit dvi_index // 현재 반쪽 버퍼의 끝
var @!dvi_ptr dvi_index // 쓸 수 있는 다음 버퍼 주소
var @!dvi_offset int32 // |dvi_buf_size|에 출력 버퍼를 완전히 비운 횟수를 곱한 것
var @!dvi_gone int32 // 이미 |dvi_file|에 출력한 바이트 수

@ 처음에는 버퍼 전체가 한 덩어리다. 처음으로 가득 찬 뒤에야 그 절반을 출력한다.

@<핵심 변수들의...@>=
half_buf = dvi_buf_size / 2
dvi_limit = dvi_buf_size
dvi_ptr = 0
dvi_offset = 0
dvi_gone = 0

@ 버퍼 구간 |dvi_buf[a..b]|를 |dvi_file|에 실제로 출력하는 일은 |write_dvi(a,b)|를 불러서 한다. 이 프로시저는 \TeX의 안쪽
루프의 일부이므로, 가장 좋은 결과를 얻으려면 시스템마다 될 수 있는 대로 빨리 돌도록 최적화해야 한다.
그리고 |write_dvi(a,b)|를 부를 때 |a|와 |b+1|이 둘 다 4의 배수라고 가정해도 안전하다. 그러므로 많은 기계에서 낱말 하나에
네 바이트를 꾸려 넣고 낱말의 배열을 시스템 호출 한 번으로 출력하는 효율적인 방법을 쓸 수 있다.
@^system dependencies@>
@^inner loop@>
@^defecation@>

@<함수들@>=
func write_dvi(a, b dvi_index) {
	var k dvi_index
	for k = a; k <= b; k++ {
		b_put(&dvi_file, dvi_buf[k])
	}
}

@ 바이트를 버퍼에 넣을 때마다 프로시저를 부르는 비용을 치르지 않으려고 매크로 |dvi_out|을 쓴다.

@<함수들@>=
func dvi_out(x int32) {
	dvi_buf[dvi_ptr] = x
	dvi_ptr++
	if dvi_ptr == dvi_limit {
		dvi_swap()
	}
}

func dvi_swap() { // 버퍼의 절반을 출력한다
	if dvi_limit == dvi_buf_size {
		write_dvi(0, half_buf-1)
		dvi_limit = half_buf
		dvi_offset = dvi_offset + dvi_buf_size
		dvi_ptr = 0
	} else {
		write_dvi(half_buf, dvi_buf_size-1)
		dvi_limit = dvi_buf_size
	}
	dvi_gone = dvi_gone + half_buf
}

@ 다음은 \TeX이 일을 다 마쳤을 때 버퍼를 비우는 방법이다. 그때 포인터 |dvi_ptr|는 4의 배수일 것이다.

@<|dvi_buf|의 마지막 바이트들을 비운다@>=
if dvi_limit == half_buf {
	write_dvi(half_buf, dvi_buf_size-1)
}
if dvi_ptr > 0 {
	write_dvi(0, dvi_ptr-1)
}

@ 프로시저 |dvi_four|는 산술 넘침의 위험 없이 네 바이트를 2의 보수 표기로 출력한다.

보충: 인자 |x|가 음수면 $2^{30}$을 두 번 더해서 $x+2^{31}$을 만든다. 이것은 넘치지 않고 음이 아닌 값이 된다. 그 첫
바이트에 128을 더하면 2의 보수 표현의 첫 바이트가 된다.

@<함수들@>=
func dvi_four(x int32) {
	if x >= 0 {
		dvi_out(x / 0o100000000)
	} else {
		x = x + 0o10000000000
		x = x + 0o10000000000
		dvi_out((x / 0o100000000) + 128)
	}
	x = x % 0o100000000
	dvi_out(x / 0o200000)
	x = x % 0o200000
	dvi_out(x / 0o400)
	dvi_out(x % 0o400)
}

@ 루틴 |dvi_pop|이 출력을 조금 최적화한다. 이것은 `|push| |pop|' 짝을 지울 수 없을 때에만 |pop|을 낸다. 이 루틴의
매개변수는 새 |pop|과 짝이 맞는 옛 |push| 다음의 바이트 주소다.

@<함수들@>=
func dvi_pop(l int32) {
	if l == dvi_offset+dvi_ptr && dvi_ptr > 0 {
		dvi_ptr--
	} else {
		dvi_out(pop)
	}
}

@ 다음은 글꼴 정의를 출력하는 프로시저다. \TeX82는 작업 하나에 서로 다른 글꼴을 많아야 256개 쓰므로 명령 코드로는
언제나 |fnt_def1|을 쓴다.

@<함수들@>=
func dvi_font_def(f internal_font_number) {
	var k pool_pointer // |str_pool|의 첨자
	dvi_out(fnt_def1)
	dvi_out(f - font_base - 1)
	dvi_out(qo(font_check[f].b0))
	dvi_out(qo(font_check[f].b1))
	dvi_out(qo(font_check[f].b2))
	dvi_out(qo(font_check[f].b3))
	dvi_four(font_size[f])
	dvi_four(font_dsize[f])
	dvi_out(length(font_area[f]))
	dvi_out(length(font_name[f]))
	@<내부 번호가 |f|인 글꼴의 이름을 출력한다@>
}

@ @<내부 번호가 |f|인...@>=
for k = str_start[font_area[f]]; k <= str_start[font_area[f]+1]-1; k++ {
	dvi_out(so(str_pool[k]))
}
for k = str_start[font_name[f]]; k <= str_start[font_name[f]+1]-1; k++ {
	dvi_out(so(str_pool[k]))
}

@ 작은 컴퓨터를 위한 판의 \TeX은 이 프로그램의 다음 몇 부분의 착상을 빼도 좋을 것이다. 명령 |w0|, |x0|, |y0|, |z0|를
써서 \.{DVI} 코드를 최적화하는 것이 꼭 필요하지는 않기 때문이다. 게다가 이제 설명할 알고리즘은 \.{DVI} 코드의 길이를
최적으로 줄인다고 내세우지 않는다. 결국 간결함보다는 속도가 더 중요하다. 그러나 이 방법은 놀랍도록 효과적이고,
시간도 비교적 적게 든다.

기본 생각을 가장 잘 이해하려면 먼저 본질적인 특징이 같은 더 간단한 문제를 살펴보면 된다. 숫자들의 나열, 이를테면
$3\,1\,4\,1\,5\,9\,2\,6\,5\,3\,5\,8\,9$가 주어졌을 때, 각 숫자에 첨자 $d$, $y$, $z$ 가운데 하나를 붙여서 ``$y$-맞음''과
``$z$-맞음''의 수를 최대로 하고 싶다. 여기서 $y$-맞음이란 첨자가 $y$인 같은 숫자가 두 번 나타나되 그 사이에 $y$가 끼지 않은
경우를 말하고, $z$-맞음도 비슷하게 정의한다. 이를테면 위의 나열에는 다음과 같이 첨자를 붙일 수 있다.
$$3_z\,1_y\,4_d\,1_y\,5_y\,9_d\,2_d\,6_d\,5_y\,3_z\,5_y\,8_d\,9_d.$$
여기에는 $y$-맞음이 셋($1_y\ldots1_y$와 $5_y\ldots5_y\ldots5_y$), $z$-맞음이 하나($3_z\ldots3_z$) 있다. 숫자 $9_d$가 두 번 나타나는
사이에 $d$들이 있으므로 $d$-맞음은 없지만, $d$-맞음은 세지 않으므로 몇 개인지는 상관없다. 이 첨자들은 \ID{down},
$y$, $z$라는 \.{DVI} 명령에 해당하고, 숫자들은 서로 다른 세로 움직임의 양에 해당한다. 그리고 $y$-맞음이나 $z$-맞음은 \.{DVI}
파일에서 한 바이트짜리 명령 |y0|이나 |z0|을 쓸 기회에 해당한다.

\TeX이 첨자를 붙이는 방법은 다음과 같다. 나열의 오른쪽에 새 숫자, 이를테면 $\delta$를 덧붙인다. 이제 다음 가운데
하나가 일어날 때까지 나열을 거슬러 훑는다. (a)~$\delta_y$나 $\delta_z$를 보았고, 그것이 각각 $y$나 $z$ 첨자를 처음
만난 것이다. 그러면 새 $\delta$에 $y$나 $z$를 붙인다. 맞음을 얻은 것이다. (b)~$\delta_d$를 보았고, 이 찾기 동안
아직 $y$ 첨자를 하나도 만나지 않았다. 그러면 앞의 $\delta_d$를 $\delta_y$로 바꾸고(이것은 출력 버퍼의 명령을 바꾸는
것에 해당한다) 새 $\delta$에 $y$를 붙인다. 또 하나의 맞음이다. (c)~$\delta_d$를 보았고, $y$ 첨자는 보았지만 $z$는 보지
않았다. 앞의 $\delta_d$를 $\delta_z$로 바꾸고 새 $\delta$에 $z$를 붙인다. (d)~알맞은 $\delta$를 만나기 전에 $y$와 $z$
첨자를 둘 다 만났거나, 나열의 맨 앞까지 다 훑었다. 새 $\delta$에 $d$를 붙인다. 이 붙임은 나중에 바뀔 수도 있다.

위의 예의 첨자 $3_z\,1_y\,4_d\ldots\,$는 사실 이 절차로 만든 것이다. 독자는 확인해 볼 수 있다. (어서 해 보라.)

@ 이런 생각을 구현하려고 \TeX은 현재 쪽에 대해 만든 \ID{down}, $y$, $z$ 명령을 가리키는 포인터들의 스택을 유지한다.
\ID{right}, |w|, |x| 명령에 대해서도 비슷한 스택이 있다. 이 스택들을 아래 스택과 오른쪽 스택이라고 부르고, 그 맨 위
원소는 변수 |down_ptr|와 |right_ptr|에 둔다.

이 스택들의 각 항목에는 필드가 넷 있다. 필드 |width|는 아래나 오른쪽으로 움직이는 양이다. 필드 |location|은 해당
\.{DVI} 명령의 바이트 번호다(알맞은 |dvi_offset|을 포함한다). 필드 |link|는 스택에서 이 항목 바로 아래의 항목을
가리킨다. 필드 |info|는 \.{DVI} 명령을 바꿀 수 있는 선택지들을 나타낸다.

@<전역 변수@>=
const @!movement_node_size = 3 // 아래 스택과 오른쪽 스택의 항목마다의 낱말 수

func location(p pointer) int32        { return mem[p+2].sc } // 움직임 명령의 \.{DVI} 바이트 번호
func set_location(p pointer, v int32) { mem[p+2].sc = v }

var @!down_ptr, @!right_ptr pointer // 아래 스택과 오른쪽 스택의 머리

@ @<핵심 변수들의...@>=
down_ptr = null
right_ptr = null

@ 다음은 지정된 아래쪽이나 오른쪽 움직임에 대한 \.{DVI} 명령을 만드는 서브루틴이다. 매개변수가 둘 있다. 그 가운데 |w|는
움직임의 양이고, |o|는 |down1|이나 |right1|이다. 명령 코드들이 편리한 산술 성질 |y1-down1=w1-right1|과
|z1-down1=x1-right1|을 지닌다는 사실을 쓴다.

보충: 원본은 수 레이블 |2|와 |1|도 쓴다(\os{610}). \GO/의 레이블은 식별자여야 하므로 \ID{\_2}와 \ID{\_1}로
옮겼다.

@<함수들@>=
func movement(w scaled, o eight_bits) {
	var mstate small_number // |y|나 |z|를 보았나?
	var p, q pointer // 스택의 현재 노드와 맨 위 노드
	var k int32 // |dvi_buf|의 첨자, |dvi_buf_size|를 법으로
	q = get_node(movement_node_size) // 스택의 맨 위를 위한 새 노드
	set_width(q, w)
	set_location(q, dvi_offset+dvi_ptr)
	if o == down1 {
		set_link(q, down_ptr)
		down_ptr = q
	} else {
		set_link(q, right_ptr)
		right_ptr = q
	}
	@<다른 스택 항목들을 보고, 노드 |p|가 ``맞음''이면 |goto found|@>
	@<|w|에 대한 |down|이나 |right| 명령을 만들고 |return|@>
found:
	@<앞에 나타난~|w|를 다시 쓰도록 |y0|이나 |z0| 명령을 만든다@>
}

@ 아래 스택이나 오른쪽 스택의 항목의 |info| 필드는 여섯 가지 설정을 가질 수 있다. 값 |y_here|나 |z_here|는 \.{DVI} 명령이
각각 |y|나 |z|(가로 움직임이라면 |w|나 |x|)를 가리킨다는 뜻이다. 값 |yz_OK|는 \.{DVI} 명령이 \ID{down}(또는
\ID{right})이지만 |y|나 |z|(또는 |w|나 |x|)로 바꿀 수 있다는 뜻이다. 값 |y_OK|는 그것이 \ID{down}이고 |y|로는 바꿀 수
있지만 |z|로는 바꿀 수 없다는 뜻이다. 값 |z_OK|도 비슷하다. 값 |d_fixed|는 그것이 \ID{down}으로 남아야 한다는 뜻이다.

위에서 말한 숫자에 첨자 붙이기 문제를 풀기만 한다면 네 설정 |yz_OK|, |y_OK|, |z_OK|, |d_fixed|를 서로 구별할 필요가
없을 것이다. 그러나 \TeX의 경우에는 |push|와 |pop| 명령의 중첩 구조 때문에 복잡해진다. 숫자에 첨자 붙이기 문제에
괄호를 더하고, $\delta_y$ 사이의 모든 $y$가 제대로 중첩된 괄호 안에 있고 오른쪽 $\delta_y$의 괄호 수준이 왼쪽 것과
같거나 더 깊으면 $\delta_y\ldots \delta_y$를 맞음이라고 다시 정의하자. 그러니까 `('와 `)'는 `|push|'와 `|pop|'에
해당한다. 이제 나열
$$2_y\,7_d\,1_d\,(\,8_z\,2_y\,8_z\,)\,1$$
의 마지막 1에 첨자를 붙이고 싶다면, 앞의 $1_d$를 $1_y$로 바꿀 수 없다. 그러면 $2_y\ldots2_y$ 맞음이 무효가 되기
때문이다. 그러나 $1_z$로는 바꿀 수 있다. 사이에 있는 $8_z$들은 괄호 안에 있으므로 맞음을 얻는다.

아래의 프로그램은 |push| 뒤에 들어온 움직임 노드들을 그에 해당하는 |pop|을 출력하기 전에 없앤다.

@<정의@>=
const (
	@!y_here = 1 // 움직임 항목이 |y| 명령을 가리킬 때의 |info|
	@!z_here = 2 // 움직임 항목이 |z| 명령을 가리킬 때의 |info|
	@!yz_OK = 3 // 제약 없는 \ID{down} 명령에 해당하는 |info|
	@!y_OK = 4 // |z|가 될 수 없는 \ID{down}에 해당하는 |info|
	@!z_OK = 5 // |y|가 될 수 없는 \ID{down}에 해당하는 |info|
	@!d_fixed = 6 // 바뀔 수 없는 \ID{down}에 해당하는 |info|
)

@ 프로시저 |movement|가 레이블 |found|에 이르면 |info(p)|의 값은 |y_here|나 |z_here|다. 이를테면 그것이 |y_here|면
이 프로시저는 |y0| 명령(또는 |w0| 명령)을 만들고, |q|와 |p| 사이의 모든 |info| 필드에 그 범위에서 |y|가 괜찮지
않다고 표시한다.

@<앞에 나타난~|w|를 다시...@>=
set_info(q, info(p))
if info(q) == y_here {
	dvi_out(o + y0 - down1) // |y0|이나 |w0|
	for link(q) != p {
		q = link(q)
		switch info(q) {
		case yz_OK: set_info(q, z_OK)
		case y_OK: set_info(q, d_fixed)
		default: // 아무것도 하지 않는다
		}
	}
} else {
	dvi_out(o + z0 - down1) // |z0|이나 |x0|
	for link(q) != p {
		q = link(q)
		switch info(q) {
		case yz_OK: set_info(q, y_OK)
		case z_OK: set_info(q, d_fixed)
		default: // 아무것도 하지 않는다
		}
	}
}

@ @<|w|에 대한 |down|이나...@>=
set_info(q, yz_OK)
if abs(w) >= 0o40000000 {
	dvi_out(o + 3) // |down4|나 |right4|
	dvi_four(w)
	return
}
if abs(w) >= 0o100000 {
	dvi_out(o + 2) // |down3|나 |right3|
	if w < 0 {
		w = w + 0o100000000
	}
	dvi_out(w / 0o200000)
	w = w % 0o200000
	goto _2
}
if abs(w) >= 0o200 {
	dvi_out(o + 1) // |down2|나 |right2|
	if w < 0 {
		w = w + 0o200000
	}
	goto _2
}
dvi_out(o) // |down1|나 |right1|
if w < 0 {
	w = w + 0o400
}
goto _1
_2:
dvi_out(w / 0o400)
_1:
dvi_out(w % 0o400)
return

@ 스택을 훑어 나가는 동안 우리는 |y_here|나 |z_here| 노드를 만났는지에 따라 |y_seen|, |z_seen|, |none_seen| 가운데
한 상태에 있다. 빨리 결정할 수 있도록 이 상태들은 6의 배수로 나타내어 |info| 필드에 더할 수 있게 한다.
@^inner loop@>

@<다른 스택 항목들을 보고...@>=
p = link(q)
mstate = none_seen
for p != null {
	if width(p) == w {
		@<너비가 맞는 노드를 살피고, 맞음이면 |goto found|@>
	} else {
		switch mstate + info(p) {
		case none_seen + y_here: mstate = y_seen
		case none_seen + z_here: mstate = z_seen
		case y_seen + z_here, z_seen + y_here: goto not_found
		default: // 아무것도 하지 않는다
		}
	}
	p = link(p)
}
not_found:

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const (
	@!none_seen = 0 // 아직 |y_here|나 |z_here| 노드를 만나지 않았다
	@!y_seen = 6 // |y_here|는 보았지만 |z_here|는 보지 않았다
	@!z_seen = 12 // |z_here|는 보았지만 |y_here|는 보지 않았다
)

@ 버퍼에서 이미 나가 버린 |y|나 |z| 바이트에서 올바른 맞음을 찾을 수도 있다. 그러나 영원히 나가 버린 바이트는 바꿀
수 없다. ``움직이는 손가락은 쓰고, $\ldots\,\,$.''

@<너비가 맞는 노드를...@>=
switch mstate + info(p) {
case none_seen + yz_OK, none_seen + y_OK, z_seen + yz_OK, z_seen + y_OK:
	if location(p) < dvi_gone {
		goto not_found
	} else {
		@<버퍼의 명령을 |y|나 |w|로 바꾸고 |goto found|@>
	}
case none_seen + z_OK, y_seen + yz_OK, y_seen + z_OK:
	if location(p) < dvi_gone {
		goto not_found
	} else {
		@<버퍼의 명령을 |z|나 |x|로 바꾸고 |goto found|@>
	}
case none_seen + y_here, none_seen + z_here, y_seen + z_here, z_seen + y_here:
	goto found
default: // 아무것도 하지 않는다
}

@ @<버퍼의 명령을 |y|나 |w|로...@>=
k = location(p) - dvi_offset
if k < 0 {
	k = k + dvi_buf_size
}
dvi_buf[k] = dvi_buf[k] + y1 - down1
set_info(p, y_here)
goto found

@ @<버퍼의 명령을 |z|나 |x|로...@>=
k = location(p) - dvi_offset
if k < 0 {
	k = k + dvi_buf_size
}
dvi_buf[k] = dvi_buf[k] + z1 - down1
set_info(p, z_here)
goto found

@ 움직임 노드들이 언제 \TeX의 메모리에서 모두 없어지는지 궁금하다면, 답은 |hlist_out|과 |vlist_out|이 상자 출력을
마치기 바로 전에 그것들을 재활용한다는 것이다. 이렇게 하면 아래 스택과 오른쪽 스택은 그 상자를 출력하기 전의 상태로 돌아간다.
다만 어떤 |info|는 더 엄격해졌을 수 있다.

@<함수들@>=
func prune_movements(l int32) { // |location>=l|인 움직임 노드들을 지운다
	var p pointer // 지우는 노드
	for down_ptr != null {
		if location(down_ptr) < l {
			goto done
		}
		p = down_ptr
		down_ptr = link(p)
		free_node(p, movement_node_size)
	}
done:
	for right_ptr != null {
		if location(right_ptr) < l {
			return
		}
		p = right_ptr
		right_ptr = link(p)
		free_node(p, movement_node_size)
	}
}

@ 움직이고 싶은 실제 거리는 따로따로인 움직임 여럿의 합으로 계산될 수도 있다. 이를테면 글루 노드 여럿이 잇달아 있을
수도 있고, 어떤 상자의 너비에 글루의 양을 더한 만큼 오른쪽으로 움직이고 싶을 수도 있다. 더 중요하게는, 기준선 간격
거리는 글루와 이웃 상자들의 깊이와 높이로 계산되는데, \.{DVI} 파일에서는 이 세 양을 한 움직임으로 뭉뚱그리고 싶다.

그래서 \TeX은 전역 변수 두 쌍을 유지한다. 한 쌍인 |dvi_h|와 |dvi_v|는 실제로 \.{DVI} 파일에 출력한 명령들에 해당하는 |h|와
|v| 좌표이고, 다른 한 쌍인 |cur_h|와 |cur_v|는 출력 루틴들의 현재 상태에 해당하는 좌표다. 좌표 변화는 |cur_h|와 |cur_v|에 쌓이기만
하고 출력에는 반영되지 않다가, 그런 변화가 필요해지거나 바람직해지면 반영된다. 그리고 |dvi_h=cur_h|나 |dvi_v=cur_v|로
만들고 싶을 때마다 프로시저 |movement|를 부르면 된다.

\.{DVI} 출력에 반영된 현재 글꼴은 |dvi_f|라고 부른다. `\ID{cur\_f}' 변수는 필요 없다.

루틴 |hlist_out|과 |vlist_out|의 중첩 깊이는 |cur_s|라고 부른다. 이것은 본질적으로 \.{DVI} 출력에서 |push| 명령의 깊이다.

@<전역 변수@>=
func synch_h() {
	if cur_h != dvi_h {
		movement(cur_h-dvi_h, right1)
		dvi_h = cur_h
	}
}

func synch_v() {
	if cur_v != dvi_v {
		movement(cur_v-dvi_v, down1)
		dvi_v = cur_v
	}
}

var @!dvi_h, @!dvi_v scaled // \.{DVI}를 읽는 프로그램은 우리가 여기 있다고 생각한다
var @!cur_h, @!cur_v scaled // \TeX은 우리가 여기 있다고 생각한다
var @!dvi_f internal_font_number // 현재 글꼴
var @!cur_s int32 // 출력 상자 중첩의 현재 깊이, 처음에는 $-1$

@ @<|ship_out|을 시작할 때 변수들을 초기화한다@>=
dvi_h = 0
dvi_v = 0
cur_h = h_offset()
dvi_f = null_font
ensure_dvi_open()
if total_pages == 0 {
	dvi_out(pre)
	dvi_out(id_byte) // 서문을 출력한다
@^preamble of \.{DVI} file@>
	dvi_four(25400000)
	dvi_four(473628672) // sp를 위한 변환 비율
	prepare_mag()
	dvi_four(mag()) // 확대 배율이 얼어붙는다
	old_setting = selector
	selector = new_string
	print(" TeX output ")
	print_int(year())
	print_char('.')
	print_two(month())
	print_char('.')
	print_two(day())
	print_char(':')
	print_two(time() / 60)
	print_two(time() % 60)
	selector = old_setting
	dvi_out(cur_length())
	for s = str_start[str_ptr]; s <= pool_ptr-1; s++ {
		dvi_out(so(str_pool[s]))
	}
	pool_ptr = str_start[str_ptr] // 현재 문자열을 비운다
}

@ 프로시저 |hlist_out|이 불리면 그 의무는 |temp_ptr|가 가리키는 |hlist_node|가 나타내는 상자를 출력하는 것이다. 그 상자의
기준점의 좌표는 |(cur_h,cur_v)|다.

마찬가지로 |vlist_out|이 불리면 그 의무는 |temp_ptr|가 가리키는 |vlist_node|가 나타내는 상자를 출력하는 것이다. 그
상자의 기준점의 좌표는 |(cur_h,cur_v)|다.
@^recursion@>

보충: 원본은 여기서 |vlist_out|을 |forward|로 선언한다. 두 프로시저 |hlist_out|과 |vlist_out|은 서로 재귀적이기 때문이다.
\GO/에서는 필요 없다.

@ 재귀 프로시저 |hlist_out|과 |vlist_out|에는 저마다 지역 변수 |save_h|와 |save_v|가 있어서, 새 재귀 수준에 들어가기
바로 전의 |dvi_h|와 |dvi_v|의 값을 담는다. 사실상 \TeX의 실행 시간 스택에 있는 |save_h|와 |save_v|의 값들은
\.{DVI}를 읽는 프로그램이 좌표 스택에 쌓을 |h|와 |v|의 값들에 해당한다.

보충: 원본은 레이블 |move_past|, |fin_rule|, |next_p|에 수 13, 14, 15를 준다.

@<함수들@>=
@<|hlist_out|과 |vlist_out|에 필요한 프로시저들을 선언한다@>
func hlist_out() { // |hlist_node| 상자를 출력한다
	var base_line scaled // 이 상자의 기준선 좌표
	var left_edge scaled // 이 상자의 왼쪽 좌표
	var save_h, save_v scaled // |dvi_h|와 |dvi_v|가 꺼내져 돌아갈 값
	var this_box pointer // 둘러싼 상자를 가리키는 포인터
	var g_order glue_ord // 글루에 적용되는 무한대의 차수
	var g_sign int32 // 글루의 종류를 고른다; |normal..shrinking|
	var p pointer // 가로 목록의 현재 위치
	var save_loc int32 // 들어올 때의 \.{DVI} 바이트 위치
	var leader_box pointer // 되풀이하는 리더 상자
	var leader_wd scaled // 되풀이하는 리더 상자의 너비
	var lx scaled // 리더 상자 사이의 추가 간격
	var outer_doing_leaders bool // 리더를 하고 있었나?
	var edge scaled // 하위 상자의 왼쪽 가장자리, 또는 리더 공간의 오른쪽 가장자리
	var glue_temp float64 // 반올림하기 전의 글루 값
	var cur_glue float64 // 지금까지 본 글루
	var cur_g scaled // |cur_glue| 곱하기 글루 비율을 반올림한 값
	cur_g = 0; cur_glue = float_constant(0)
	this_box = temp_ptr; g_order = glue_order(this_box)
	g_sign = glue_sign(this_box); p = list_ptr(this_box)
	cur_s++
	if cur_s > 0 {
		dvi_out(push)
	}
	if cur_s > max_push {
		max_push = cur_s
	}
	save_loc = dvi_offset + dvi_ptr; base_line = cur_v; left_edge = cur_h
	for p != null {
		@<|hlist_out|에서 노드 |p|를 출력하고 다음 노드로 옮겨 간다@>
	}
	prune_movements(save_loc)
	if cur_s > 0 {
		dvi_pop(save_loc)
	}
	cur_s--
}

@ 프로시저 |hlist_out|의 한 부분은 \TeX의 안쪽 루프에 속하므로 그 효율에 특별히 마음을 써야 한다. 문자 노드
|char_node|를 만나면, |char_node|가 아닌 것에 이를 때까지 노드 여럿을 잇달아 처리해서 시간을 조금 아낀다. 이 프로그램은 |set_char_0=0|이라는
사실을 쓴다.
@^inner loop@>

보충: 원본의 이름은 ``|hlist_out|에서 노드 |p|를 출력하고 다음 노드로 옮겨 가되, 조건 |cur_v=base_line|을 지킨다''이다.

@<|hlist_out|에서 노드 |p|를...@>=
reswitch:
if is_char_node(p) {
	synch_h()
	synch_v()
	for {
		f = font(p)
		c = character(p)
		if f != dvi_f {
			@<글꼴 |dvi_f|를 |f|로 바꾼다@>
		}
		if c >= qi(128) {
			dvi_out(set1)
		}
		dvi_out(qo(c))
		cur_h = cur_h + char_width(f, char_info(f, c))
		p = link(p)
		if !is_char_node(p) {
			break
		}
	}
	dvi_h = cur_h
} else {
	@<|hlist_out|에서 |char_node|가 아닌 |p|를 출력하고 다음 노드로 옮겨 간다@>
}

@ @<글꼴 |dvi_f|를 |f|로...@>=
if !font_used[f] {
	dvi_font_def(f)
	font_used[f] = true
}
if f <= 64+font_base {
	dvi_out(f - font_base - 1 + fnt_num_0)
} else {
	dvi_out(fnt1)
	dvi_out(f - font_base - 1)
}
dvi_f = f

@ 보충: 레이블 |fin_rule|, |move_past|, |next_p|는 이 절의 블록 안에 있고, 그리로 가는 |goto|는 모두 이 블록 안의 더
깊은 곳에 있다. \GO/는 이런 |goto|를 허용한다.

@<|hlist_out|에서 |char_node|가 아닌...@>=
switch type_(p) {
case hlist_node, vlist_node: @<가로 목록에서 상자를 출력한다@>
case rule_node:
	rule_ht = height(p); rule_dp = depth(p); rule_wd = width(p)
	goto fin_rule
case whatsit_node: @<가로 목록에서 whatsit 노드 |p|를 출력한다@>
case glue_node: @<오른쪽으로 움직이거나 리더를 출력한다@>
case kern_node, math_node: cur_h = cur_h + width(p)
case ligature_node: @<노드 |p|를 |char_node|처럼 보이게 하고 |goto reswitch|@>
default: // 아무것도 하지 않는다
}
goto next_p
fin_rule: // 괘선의 처리를 마치려면 여기로 간다
@<가로 목록에서 괘선을 출력한다@>
move_past: // 글루나 괘선을 지나 나아갈 때 여기로 간다
cur_h = cur_h + rule_wd
next_p: // 노드 |p|를 다 처리했으면 여기로 간다
p = link(p)

@ @<가로 목록에서 상자를...@>=
if list_ptr(p) == null {
	cur_h = cur_h + width(p)
} else {
	save_h = dvi_h
	save_v = dvi_v
	cur_v = base_line + shift_amount(p) // 상자를 아래로 옮긴다
	temp_ptr = p
	edge = cur_h
	if type_(p) == vlist_node {
		vlist_out()
	} else {
		hlist_out()
	}
	dvi_h = save_h
	dvi_v = save_v
	cur_h = edge + width(p)
	cur_v = base_line
}

@ @<가로 목록에서 괘선을...@>=
if is_running(rule_ht) {
	rule_ht = height(this_box)
}
if is_running(rule_dp) {
	rule_dp = depth(this_box)
}
rule_ht = rule_ht + rule_dp // 이것이 괘선의 두께다
if rule_ht > 0 && rule_wd > 0 { // 빈 괘선은 출력하지 않는다
	synch_h()
	cur_v = base_line + rule_dp
	synch_v()
	dvi_out(set_rule)
	dvi_four(rule_ht)
	dvi_four(rule_wd)
	cur_v = base_line
	dvi_h = dvi_h + rule_wd
}

@ 보충: 원본의 매크로 |vet_glue(#)|는 |glue_temp:=#|로 놓은 다음, 그 값이 $\pm10^9$을 넘으면 잘라 낸다. 이 매크로는
|hlist_out|과 |vlist_out|의 지역 변수 |glue_temp|를 쓰므로, \GO/에서는 잘라 낸 값을 돌려주는 함수가 되고 부르는 쪽에서
|glue_temp|에 넣는다. 지나치게 큰 글루 값은 |round|가 정수로 바꿀 수 없기 때문이다.

@<오른쪽으로 움직이거나...@>=
g = glue_ptr(p)
rule_wd = width(g) - cur_g
if g_sign != normal {
	if g_sign == stretching {
		if stretch_order(g) == g_order {
			cur_glue = cur_glue + float64(stretch(g))
			glue_temp = vet_glue(float(glue_set(this_box)) * cur_glue)
@^real multiplication@>
			cur_g = round(glue_temp)
		}
	} else if shrink_order(g) == g_order {
		cur_glue = cur_glue - float64(shrink(g))
		glue_temp = vet_glue(float(glue_set(this_box)) * cur_glue)
		cur_g = round(glue_temp)
	}
}
rule_wd = rule_wd + cur_g
if subtype(p) >= a_leaders {
	@<가로 목록에서 리더를 출력하고, 괘선이면 |goto fin_rule|, 다 했으면 |goto next_p|@>
}
goto move_past

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const @!billion = 1000000000.0 // |float_constant(1000000000)|

func vet_glue(g float64) float64 {
	if g > billion {
		return billion
	} else if g < -billion {
		return -billion
	}
	return g
}

@ @<가로 목록에서 리더를...@>=
leader_box = leader_ptr(p)
if type_(leader_box) == rule_node {
	rule_ht = height(leader_box)
	rule_dp = depth(leader_box)
	goto fin_rule
}
leader_wd = width(leader_box)
if leader_wd > 0 && rule_wd > 0 {
	rule_wd = rule_wd + 10 // 부동 소수점 반올림을 보정한다
	edge = cur_h + rule_wd
	lx = 0
	@<|cur_h|를 첫 상자의 위치로 놓고, |leader_wd+lx|를 상자 사이의 간격으로 놓는다@>
	for cur_h+leader_wd <= edge {
		@<|cur_h|에 리더 상자 하나를 출력하고 |cur_h|를 |leader_wd+lx|만큼 나아가게 한다@>
	}
	cur_h = edge - 10
	goto next_p
}

@ 리더에 관련된 계산은 조금 조심해야 한다. 먼저 |a_leaders|(정렬된 리더)의 경우에는, |cur_h|를 |left_edge|에
|leader_wd|의 배수 가운데 그 결과가 |cur_h|의 현재 값보다 작지 않은 가장 작은 것을 더한 곳으로 옮기고 싶다. 곧
|cur_h|는 $|left_edge|+|leader_wd|\times\lceil(|cur_h|-|left_edge|)/|leader_wd|\rceil$이 되어야 한다. 어떤 \PASCAL\
구현은 |cur_h|가 |left_edge|보다 작을 때 |div| 연산에 대해 표준이 아닌 결과를 주지만, 여기의 프로그램은 모든
경우에 돌아갈 것이다.

가운데 맞춘 리더 |c_leaders|의 경우에는 리더가 차지하지 않은 남는 공간의 절반만큼 |cur_h|를 늘리고 싶다. 그리고
펼친 리더 |x_leaders|의 경우에는 이 남는 공간의 $1/(q+1)$만큼 |cur_h|를 늘린다. 여기서 $q$는 리더 상자를 되풀이할
횟수다. 나눗셈의 작은 부정확함이 쌓일 수 있는데, 이 반올림 오차의 절반을 리더의 양 끝에 둔다.

@<|cur_h|를 첫 상자의...@>=
if subtype(p) == a_leaders {
	save_h = cur_h
	cur_h = left_edge + leader_wd*((cur_h-left_edge)@!/leader_wd)
	if cur_h < save_h {
		cur_h = cur_h + leader_wd
	}
} else {
	lq = rule_wd / leader_wd // 상자 사본의 수
	lr = rule_wd % leader_wd // 남는 공간
	if subtype(p) == c_leaders {
		cur_h = cur_h + (lr / 2)
	} else {
		lx = lr / (lq + 1)
		cur_h = cur_h + ((lr - (lq-1)*lx) / 2)
	}
}

@ 여기의 `\ID{synch}' 연산들은 \.{DVI} 출력에서 가로와 세로 움직임을 지정하는 데 필요한 바이트 수를 줄이려는 것이다.

@<|cur_h|에 리더 상자...@>=
cur_v = base_line + shift_amount(leader_box)
synch_v()
save_v = dvi_v
synch_h()
save_h = dvi_h
temp_ptr = leader_box
outer_doing_leaders = doing_leaders
doing_leaders = true
if type_(leader_box) == vlist_node {
	vlist_out()
} else {
	hlist_out()
}
doing_leaders = outer_doing_leaders
dvi_v = save_v
dvi_h = save_h
cur_v = base_line
cur_h = save_h + leader_wd + lx

@ 루틴 |vlist_out|은 |hlist_out|과 비슷하지만 조금 더 간단하다.

@<함수들@>=
func vlist_out() { // |vlist_node| 상자를 출력한다
	var left_edge scaled // 이 상자의 왼쪽 좌표
	var top_edge scaled // 이 상자의 위쪽 좌표
	var save_h, save_v scaled // |dvi_h|와 |dvi_v|가 꺼내져 돌아갈 값
	var this_box pointer // 둘러싼 상자를 가리키는 포인터
	var g_order glue_ord // 글루에 적용되는 무한대의 차수
	var g_sign int32 // 글루의 종류를 고른다; |normal..shrinking|
	var p pointer // 세로 목록의 현재 위치
	var save_loc int32 // 들어올 때의 \.{DVI} 바이트 위치
	var leader_box pointer // 되풀이하는 리더 상자
	var leader_ht scaled // 되풀이하는 리더 상자의 높이
	var lx scaled // 리더 상자 사이의 추가 간격
	var outer_doing_leaders bool // 리더를 하고 있었나?
	var edge scaled // 리더 공간의 아래 경계
	var glue_temp float64 // 반올림하기 전의 글루 값
	var cur_glue float64 // 지금까지 본 글루
	var cur_g scaled // |cur_glue| 곱하기 글루 비율을 반올림한 값
	cur_g = 0; cur_glue = float_constant(0)
	this_box = temp_ptr; g_order = glue_order(this_box)
	g_sign = glue_sign(this_box); p = list_ptr(this_box)
	cur_s++
	if cur_s > 0 {
		dvi_out(push)
	}
	if cur_s > max_push {
		max_push = cur_s
	}
	save_loc = dvi_offset + dvi_ptr; left_edge = cur_h; cur_v = cur_v - height(this_box)
	top_edge = cur_v
	for p != null {
		@<|vlist_out|에서 노드 |p|를 출력하고 다음 노드로 옮겨 간다@>
	}
	prune_movements(save_loc)
	if cur_s > 0 {
		dvi_pop(save_loc)
	}
	cur_s--
}

@ 보충: 원본의 이름은 ``|vlist_out|에서 노드 |p|를 출력하고 다음 노드로 옮겨 가되, 조건 |cur_h=left_edge|를
지킨다''이다.

@<|vlist_out|에서 노드 |p|를...@>=
if is_char_node(p) {
	confusion("vlistout")
@:this can't happen vlistout}{\quad vlistout@>
} else {
	@<|vlist_out|에서 |char_node|가 아닌 |p|를 출력한다@>
}
next_p:
p = link(p)

@ @<|vlist_out|에서 |char_node|가...@>=
switch type_(p) {
case hlist_node, vlist_node: @<세로 목록에서 상자를 출력한다@>
case rule_node:
	rule_ht = height(p); rule_dp = depth(p); rule_wd = width(p)
	goto fin_rule
case whatsit_node: @<세로 목록에서 whatsit 노드 |p|를 출력한다@>
case glue_node: @<아래로 움직이거나 리더를 출력한다@>
case kern_node: cur_v = cur_v + width(p)
default: // 아무것도 하지 않는다
}
goto next_p
fin_rule:
@<세로 목록에서 괘선을 출력하고 |goto next_p|@>
move_past:
cur_v = cur_v + rule_ht

@ 여기의 |synch_v| 덕분에 \.{DVI} 출력은 대부분의 경우에 |v|를 조정하는 데 한 바이트짜리 명령을 쓸 수 있다. 기준선
간격 거리는 대개 일정하기 때문이다.

@<세로 목록에서 상자를...@>=
if list_ptr(p) == null {
	cur_v = cur_v + height(p) + depth(p)
} else {
	cur_v = cur_v + height(p)
	synch_v()
	save_h = dvi_h
	save_v = dvi_v
	cur_h = left_edge + shift_amount(p) // 상자를 오른쪽으로 옮긴다
	temp_ptr = p
	if type_(p) == vlist_node {
		vlist_out()
	} else {
		hlist_out()
	}
	dvi_h = save_h
	dvi_v = save_v
	cur_v = save_v + depth(p)
	cur_h = left_edge
}

@ @<세로 목록에서 괘선을...@>=
if is_running(rule_wd) {
	rule_wd = width(this_box)
}
rule_ht = rule_ht + rule_dp // 이것이 괘선의 두께다
cur_v = cur_v + rule_ht
if rule_ht > 0 && rule_wd > 0 { // 빈 괘선은 출력하지 않는다
	synch_h()
	synch_v()
	dvi_out(put_rule)
	dvi_four(rule_ht)
	dvi_four(rule_wd)
}
goto next_p

@ @<아래로 움직이거나...@>=
g = glue_ptr(p)
rule_ht = width(g) - cur_g
if g_sign != normal {
	if g_sign == stretching {
		if stretch_order(g) == g_order {
			cur_glue = cur_glue + float64(stretch(g))
			glue_temp = vet_glue(float(glue_set(this_box)) * cur_glue)
@^real multiplication@>
			cur_g = round(glue_temp)
		}
	} else if shrink_order(g) == g_order {
		cur_glue = cur_glue - float64(shrink(g))
		glue_temp = vet_glue(float(glue_set(this_box)) * cur_glue)
		cur_g = round(glue_temp)
	}
}
rule_ht = rule_ht + cur_g
if subtype(p) >= a_leaders {
	@<세로 목록에서 리더를 출력하고, 괘선이면 |goto fin_rule|, 다 했으면 |goto next_p|@>
}
goto move_past

@ @<세로 목록에서 리더를...@>=
leader_box = leader_ptr(p)
if type_(leader_box) == rule_node {
	rule_wd = width(leader_box)
	rule_dp = 0
	goto fin_rule
}
leader_ht = height(leader_box) + depth(leader_box)
if leader_ht > 0 && rule_ht > 0 {
	rule_ht = rule_ht + 10 // 부동 소수점 반올림을 보정한다
	edge = cur_v + rule_ht
	lx = 0
	@<|cur_v|를 첫 상자의 위치로 놓고, |leader_ht+lx|를 상자 사이의 간격으로 놓는다@>
	for cur_v+leader_ht <= edge {
		@<|cur_v|에 리더 상자 하나를 출력하고 |cur_v|를 |leader_ht+lx|만큼 나아가게 한다@>
	}
	cur_v = edge - 10
	goto next_p
}

@ @<|cur_v|를 첫 상자의...@>=
if subtype(p) == a_leaders {
	save_v = cur_v
	cur_v = top_edge + leader_ht*((cur_v-top_edge)@!/leader_ht)
	if cur_v < save_v {
		cur_v = cur_v + leader_ht
	}
} else {
	lq = rule_ht / leader_ht // 상자 사본의 수
	lr = rule_ht % leader_ht // 남는 공간
	if subtype(p) == c_leaders {
		cur_v = cur_v + (lr / 2)
	} else {
		lx = lr / (lq + 1)
		cur_v = cur_v + ((lr - (lq-1)*lx) / 2)
	}
}

@ 프로그램의 이 부분에 이르면 |cur_v|는 리더 상자의 기준선이 아니라 위쪽을 가리킨다.

@<|cur_v|에 리더 상자...@>=
cur_h = left_edge + shift_amount(leader_box)
synch_h()
save_h = dvi_h
cur_v = cur_v + height(leader_box)
synch_v()
save_v = dvi_v
temp_ptr = leader_box
outer_doing_leaders = doing_leaders
doing_leaders = true
if type_(leader_box) == vlist_node {
	vlist_out()
} else {
	hlist_out()
}
doing_leaders = outer_doing_leaders
dvi_v = save_v
dvi_h = save_h
cur_h = left_edge
cur_v = save_v - height(leader_box) + leader_ht + lx

@ 이제 |hlist_out|과 |vlist_out| 프로시저가 완성되었으니, 맨 처음에 이것들을 시동하는 |ship_out| 루틴을 볼 준비가
되었다.

@<함수들@>=
func ship_out(p pointer) { // 상자 |p|를 출력한다
	var page_loc int32 // 현재 |bop|의 위치
	var j, k int32 // 처음 열 개의 \.{\\count} 레지스터의 첨자; |0..9|
	var s pool_pointer // |str_pool|의 첨자
	var old_setting int32 // 저장한 |selector| 설정; |0..max_selector|
	if tracing_output() > 0 {
		print_nl("")
		print_ln()
		print("Completed box being shipped out")
@.Completed box...@>
	}
	if term_offset > max_print_line-9 {
		print_ln()
	} else if term_offset > 0 || file_offset > 0 {
		print_char(' ')
	}
	print_char('[')
	j = 9
	for count(j) == 0 && j > 0 {
		j--
	}
	for k = 0; k <= j; k++ {
		print_int(count(k))
		if k < j {
			print_char('.')
		}
	}
	update_terminal()
	if tracing_output() > 0 {
		print_char(']')
		begin_diagnostic()
		show_box(p)
		end_diagnostic(true)
	}
	@<상자 |p|를 내보낸다@>
	if tracing_output() <= 0 {
		print_char(']')
	}
	dead_cycles = 0
	update_terminal() // 진행 보고
	@<상자를 메모리에서 지우고, 요청이 있으면 통계를 보인다@>
}

@ @<상자를 메모리에서...@>=
if stat {
	if tracing_stats() > 1 {
		print_nl("Memory usage before: ")
@.Memory usage...@>
		print_int(var_used)
		print_char('&')
		print_int(dyn_used)
		print_char(';')
	}
}
flush_node_list(p)
if stat {
	if tracing_stats() > 1 {
		print(" after: ")
		print_int(var_used)
		print_char('&')
		print_int(dyn_used)
		print("; still untouched: ")
		print_int(hi_mem_min - lo_mem_max - 1)
		print_ln()
	}
}

@ @<상자 |p|를 내보낸다@>=
@<|max_h|와 |max_v|의 값을 갱신하되, 쪽이 너무 크면 |goto done|@>
@<|ship_out|을 시작할 때...@>
page_loc = dvi_offset + dvi_ptr
dvi_out(bop)
for k = 0; k <= 9; k++ {
	dvi_four(count(k))
}
dvi_four(last_bop)
last_bop = page_loc
cur_v = height(p) + v_offset()
temp_ptr = p
if type_(p) == vlist_node {
	vlist_out()
} else {
	hlist_out()
}
dvi_out(eop)
total_pages++
cur_s = -1
done:

@ 사용자가 다른 오류 메시지들을 무시하고 있어서 거대한 쪽을 만들 때가 있다. 그런 쪽은 인쇄 소프트웨어를 헷갈리게 할
수 있으므로 \.{dvi} 파일에 출력하지 않는다.

@<|max_h|와 |max_v|의...@>=
if height(p) > max_dimen || depth(p) > max_dimen ||
	height(p)+depth(p)+v_offset() > max_dimen ||
	width(p)+h_offset() > max_dimen {
	print_err("Huge page cannot be shipped out")
@.Huge page...@>
	help2("The page just created is more than 18 feet tall or",
		"more than 18 feet wide, so I suspect something went wrong.")
	error()
	if tracing_output() <= 0 {
		begin_diagnostic()
		print_nl("The following box has been deleted:")
@.The following...deleted@>
		show_box(p)
		end_diagnostic(true)
	}
	goto done
}
if height(p)+depth(p)+v_offset() > max_v {
	max_v = height(p) + depth(p) + v_offset()
}
if width(p)+h_offset() > max_h {
	max_h = width(p) + h_offset()
}

@ 프로그램이 끝날 때 후문을 써서 일을 마무리해야 한다. 쪽 수 |total_pages|가 0이면 \.{DVI} 파일은 한 번도 열리지 않았다.
그 값이 65536 이상이면 \.{DVI} 파일은 거짓말을 할 것이다. 그리고 |max_push>=65536|이면 사용자는 무슨 혼돈이 뒤따르든
받아 마땅하다.

이 루틴에 쓸 정수 변수 |k|가 선언될 것이다.

@<\.{DVI} 파일을 마무리한다@>=
for cur_s > -1 {
	if cur_s > 0 {
		dvi_out(pop)
	} else {
		dvi_out(eop)
		total_pages++
	}
	cur_s--
}
if total_pages == 0 {
	print_nl("No pages of output.")
@.No pages of output@>
} else {
	@<후문을 출력하고 \.{DVI} 파일을 닫는다@>
}

@ \dg 앞 절의 |else| 부분이다.

@<후문을 출력하고...@>=
dvi_out(post) // 후문의 시작
dvi_four(last_bop)
last_bop = dvi_offset + dvi_ptr - 5 // |post|의 위치
dvi_four(25400000)
dvi_four(473628672) // sp를 위한 변환 비율
prepare_mag()
dvi_four(mag()) // 확대 배율
dvi_four(max_v)
dvi_four(max_h)
dvi_out(max_push / 256); dvi_out(max_push % 256)
dvi_out((total_pages / 256) % 256); dvi_out(total_pages % 256)
@<쓰인 모든 글꼴의 정의를 출력한다@>
dvi_out(post_post)
dvi_four(last_bop)
dvi_out(id_byte)
k = 4 + ((dvi_buf_size - dvi_ptr) % 4) // 223의 수
for k > 0 {
	dvi_out(223)
	k--
}
@<|dvi_buf|의 마지막 바이트들을...@>
print_nl("Output written on ")
slow_print(output_file_name)
@.Output written on x@>
print(" (")
print_int(total_pages)
print(" page")
if total_pages != 1 {
	print_char('s')
}
print(", ")
print_int(dvi_offset + dvi_ptr)
print(" bytes).")
b_close(&dvi_file)

@ @<쓰인 모든 글꼴의...@>=
for font_ptr > font_base {
	if font_used[font_ptr] {
		dvi_font_def(font_ptr)
	}
	font_ptr--
}

@* 꾸리기.
이제 \TeX에서 입력(|get_next|)과 출력(|ship_out|)에 관계된 부분은 본질적으로 끝났다. 그러니 조판의 진짜 일을 하는
나머지 부분에 본격적으로 들어갈 때다.

목록을 만들고 나면 \TeX은 그것을 싸서 상자에 넣는다. 이 일은 두 주요 서브루틴이 맡는다. 그 가운데 |hpack|은 가로 목록에,
|vpack|은 세로 목록에 적용된다. 두 서브루틴의 주된 임무는 만들어지는 상자의 치수를 계산하고, 그 치수 가운데
하나가 미리 지정되어 있으면 글루를 조정하는 것이다. 계산된 크기는 보통 새 상자 안의 모든 재료를 둘러싼다. 그러나 음의
글루가 쓰였거나, 상자가 꽉 찼거나, \.{\\vbox}에 왼쪽으로 옮긴 다른 상자들이 들어 있으면 어떤 항목은 삐져나올 수도
있다.

서브루틴 호출 |hpack(p,w,m)|은 |p|에서 시작하는 가로 목록을 담은 상자에 대한 |hlist_node|를 가리키는 포인터를
돌려준다. 매개변수 |w|는 너비를 지정하고, 매개변수 |m|은 `|exactly|'나 `|additional|'이다. 그러므로
|hpack(p,w,exactly)|는 너비가 정확히 |w|인 상자를 만들고, |hpack(p,w,additional)|은 너비가 자연 너비 더하기 |w|인
상자를 내놓는다. 가장 흔한 경우를 다루는 `|natural|'이라는 매크로를 정의하면 편리하다. 그러면 |hpack(p,natural)|이라고
해서 목록 |p|의 자연 너비를 가진 상자를 얻을 수 있다.

마찬가지로 |vpack(p,w,m)|은 |p|에서 시작하는 세로 목록을 담은 상자에 대한 |vlist_node|를 가리키는 포인터를 돌려준다.
이 경우에 |w|는 너비가 아니라 높이를 나타낸다. 매개변수 |m|은 |hpack|에서와 같이 해석된다.

보충: 원본의 매크로 |natural|은 인자 둘, 곧 `|0,additional|'로 펼쳐진다. \GO/에는 이런 매크로가 없으므로, 상수
|natural|을 0으로 정의하고 원본의 |hpack(p,natural)|을 |hpack(p,natural,additional)|로 쓴다.

@<정의@>=
const (
	@!exactly = 0 // 상자의 치수가 미리 지정되어 있다
	@!additional = 1 // 상자의 치수를 자연 치수에서 늘린다
	@!natural = 0 // |hpack|과 |vpack|의 매개변수를 위한 약칭(의 앞쪽 절반)
)

@ 서브루틴 |hpack|과 |vpack|의 매개변수들은 `\.{\\hbox} \.{to} \.{300pt}', `\.{\\hbox} \.{spread} \.{10pt}' 같은 \TeX의 원시
명령에 해당한다. 뒤에 치수가 오지 않는 `\.{\\hbox}'는 `\.{\\hbox} \.{spread} \.{0pt}'와 같다는 데 주목하라. 서브루틴
|scan_spec|은 사용자의 입력에서 그런 구성을 그 뒤에 반드시 오는 왼쪽 중괄호까지 훑고, 그 지정을 |save_stack|에 넣는다.
그러면 나중에 다음 코드를 실행해서 원하는 상자를 얻을 수 있다.
$$\vbox{\halign{#\hfil\cr
|save_ptr:=save_ptr-2;|\cr
|hpack(p,saved(1),saved(0)).|\cr}}$$
특별한 |save_stack| 코드들이 새 그룹 코드 바로 아래에 놓이도록 특별히 조심해야 한다. 명령 \.{\\csname}이 나타나면 훑기가
|save_stack|을 바꿀 수 있기 때문이다.

@<함수들@>=
func scan_spec(c group_code, three_codes bool) { // 상자 지정과 왼쪽 중괄호를 훑는다
	var s int32 // 잠시 저장한 값
	var spec_code int32 // |exactly..additional|
	if three_codes {
		s = saved(0)
	}
	if scan_keyword("to") {
		spec_code = exactly
@.to@>
	} else if scan_keyword("spread") {
		spec_code = additional
@.spread@>
	} else {
		spec_code = additional
		cur_val = 0
		goto found
	}
	scan_normal_dimen()
found:
	if three_codes {
		set_saved(0, s)
		save_ptr++
	}
	set_saved(0, spec_code)
	set_saved(1, cur_val)
	save_ptr = save_ptr + 2
	new_save_level(c)
	scan_left_brace()
}

@ 글루 설정을 알아내려고 |hpack|과 |vpack|은 무한대의 네 차수를 모두 고려해서 늘어남과 줄어듦이 얼마나 있는지 정한다.
그런 다음 계수가 0이 아닌 가장 높은 무한대 차수를 다른 차수가 없는 것처럼 쓴다.

이를테면 주어진 목록에 늘어남이 저마다 3pt, 8fill, 5fil, 6pt, $-3$fil, $-8$fill인 글루 노드 여섯 개가 있다고 하자.
그러면 합계는 본질적으로 2fil이다. 그리고 늘여서 모두 6pt의 추가 공간을 얻어야 한다면, `fil' 글루만 고려하므로 실제
늘어나는 양은 0pt, 0pt, 15pt, 0pt, $-9$pt, 0pt가 된다. (그러므로 `fill' 글루는 실은 `fil'에 대해 무한히 늘어나는 것이
아니다. 누구도 정말로 그런 일이 일어나기를 바라지는 않을 것이다.)

배열 |total_stretch|와 |total_shrink|는 각 종류의 글루가 얼마나 있는지 정하는 데 쓴다. 전역 변수 |last_badness|는
\.{\\badness}를 구현하는 데 쓴다.

@<전역 변수@>=
var @!total_stretch, @!total_shrink [filll + 1]scaled // |hpack|이나 |vpack|이 찾은 글루
var @!last_badness int32 // 가장 최근에 꾸린 상자의 나쁨

@ 전역 변수 |adjust_tail|이 널이 아니면, |hpack| 루틴은 |ins_node|, |mark_node|, |adjust_node| 항목들을 모두 없애고 그
결과로 생긴 재료를 위치 |adjust_tail|에서 끝나는 목록에 덧붙인다.

@<전역 변수@>=
var @!adjust_tail pointer // 조정 목록의 꼬리

@ @<핵심 변수들의...@>=
adjust_tail = null
last_badness = 0

@ 이제 놀랄 일이 거의 없는 |hpack|이다.

보충: 원본의 |return|은 레이블 |exit|로 가서 |hpack:=r|을 하므로 \GO/에서는 |return r|이 된다.

@<함수들@>=
func hpack(p pointer, w scaled, m small_number) pointer {
	var r pointer // 돌려줄 상자 노드
	var q pointer // |p| 뒤를 따른다
	var h, d, x scaled // 높이, 깊이, 자연 너비
	var s scaled // 옮김의 양
	var g pointer // 글루 명세를 가리킨다
	var o glue_ord // 무한대의 차수
	var f internal_font_number // |char_node|의 글꼴
	var i four_quarters // |char_node|에 관한 글꼴 정보
	var hd eight_bits // 문자의 높이와 깊이 첨자
	last_badness = 0
	r = get_node(box_node_size)
	set_type(r, hlist_node)
	set_subtype(r, min_quarterword)
	set_shift_amount(r, 0)
	q = r + list_offset
	set_link(q, p)
	h = 0
	@<치수들을 0으로 지운다@>
	for p != null {
		@<가로 목록의 노드 |p|를 살펴 반영하고 다음으로 나아간다@>
	}
	if adjust_tail != null {
		set_link(adjust_tail, null)
	}
	set_height(r, h)
	set_depth(r, d)
	@<|width(r)|의 값과 알맞은 글루 설정을 정하고, |return|하거나 |goto common_ending|@>
common_ending:
	@<꽉 차거나 덜 찬 가로 상자에 관한 진단 메시지를 마저 낸다@>
	return r
}

@ @<치수들을 0으로...@>=
d = 0
x = 0
total_stretch[normal] = 0; total_shrink[normal] = 0
total_stretch[fil] = 0; total_shrink[fil] = 0
total_stretch[fill] = 0; total_shrink[fill] = 0
total_stretch[filll] = 0; total_shrink[filll] = 0

@ @<가로 목록의 노드 |p|를...@>=
@^inner loop@>
reswitch:
for is_char_node(p) {
	@<문자의 치수를 그것을 담을 가로 상자의 치수에 반영하고 다음 노드로 옮겨 간다@>
}
if p != null {
	switch type_(p) {
	case hlist_node, vlist_node, rule_node, unset_node:
		@<상자의 치수를 그것을 담을 가로 상자의 치수에 반영한다@>
	case ins_node, mark_node, adjust_node:
		if adjust_tail != null {
			@<노드 |p|를 조정 목록으로 옮긴다@>
		}
	case whatsit_node: @<whatsit 노드를 가로 상자에 반영한다@>
	case glue_node: @<글루를 가로 합계에 반영한다@>
	case kern_node, math_node: x = x + width(p)
	case ligature_node: @<노드 |p|를 |char_node|처럼...@>
	default: // 아무것도 하지 않는다
	}
	p = link(p)
}

@ @<노드 |p|를 |char_node|처럼...@>=
mem[lig_trick] = mem[lig_char(p)]
set_link(lig_trick, link(p))
p = lig_trick
goto reswitch

@ 여기의 코드는 흐르는 치수가 |null_flag|로 나타난다는 사실을 암묵적으로 쓴다. 그 값은 아주 큰 음수이므로
계산에서 무시된다.

@<상자의 치수를 그것을 담을 가로...@>=
x = x + width(p)
if type_(p) >= rule_node {
	s = 0
} else {
	s = shift_amount(p)
}
if height(p)-s > h {
	h = height(p) - s
}
if depth(p)+s > d {
	d = depth(p) + s
}

@ 다음 코드는 \TeX의 안쪽 루프의 일부다. 곧 사용자의 입력에 텍스트 문자 하나를 더 보태면 이 명령들이 저마다 한 번씩
더 실행된다.
@^inner loop@>

@<문자의 치수를...@>=
f = font(p)
i = char_info(f, character(p))
hd = height_depth(i)
x = x + char_width(f, i)
s = char_height(f, hd)
if s > h {
	h = s
}
s = char_depth(f, hd)
if s > d {
	d = s
}
p = link(p)

@ 노드 |q|가 반드시 노드 |p|의 바로 앞 노드인 것은 아니지만, 언제나 |p| 앞의 목록에 있는 어떤 노드를 가리킨다. 그러므로
필요할 때 |q|를 옮겨서 노드를 지울 수 있다. 이 알고리즘은 선형 시간이 걸리며, 지울 필요가 없는 한 그 추가 계산이 안쪽
루프에 끼어들지 않는다.
@^inner loop@>

@<노드 |p|를 조정 목록으로...@>=
for link(q) != p {
	q = link(q)
}
if type_(p) == adjust_node {
	set_link(adjust_tail, adjust_ptr(p))
	for link(adjust_tail) != null {
		adjust_tail = link(adjust_tail)
	}
	p = link(p)
	free_node(link(q), small_node_size)
} else {
	set_link(adjust_tail, p)
	adjust_tail = p
	p = link(p)
}
set_link(q, p)
p = q

@ @<글루를 가로 합계에...@>=
g = glue_ptr(p)
x = x + width(g)
o = stretch_order(g)
total_stretch[o] = total_stretch[o] + stretch(g)
o = shrink_order(g)
total_shrink[o] = total_shrink[o] + shrink(g)
if subtype(p) >= a_leaders {
	g = leader_ptr(p)
	if height(g) > h {
		h = height(g)
	}
	if depth(g) > d {
		d = depth(g)
	}
}

@ 프로그램의 지금 부분에 이르면 |x|는 꾸리고 있는 상자의 자연 너비다.

@<|width(r)|의 값과...@>=
if m == additional {
	w = x + w
}
set_width(r, w)
x = w - x // 이제 |x|는 메워야 할 초과분이다
if x == 0 {
	set_glue_sign(r, normal)
	set_glue_order(r, normal)
	set_glue_set(r, 0.0)
	return r
} else if x > 0 {
	@<가로 글루의 늘이기 설정을 정하고, |return|하거나 |goto common_ending|@>
} else {
	@<가로 글루의 줄이기 설정을 정하고, |return|하거나 |goto common_ending|@>
}

@ @<가로 글루의 늘이기...@>=
@<늘이기 차수를 정한다@>
set_glue_order(r, o)
set_glue_sign(r, stretching)
if total_stretch[o] != 0 {
	set_glue_set(r, unfloat(float64(x)/float64(total_stretch[o])))
@^real division@>
} else {
	set_glue_sign(r, normal)
	set_glue_set(r, 0.0) // 늘일 것이 없다
}
if o == normal {
	if list_ptr(r) != null {
		@<덜 찬 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
	}
}
return r

@ @<늘이기 차수를...@>=
if total_stretch[filll] != 0 {
	o = filll
} else if total_stretch[fill] != 0 {
	o = fill
} else if total_stretch[fil] != 0 {
	o = fil
} else {
	o = normal
}

@ @<덜 찬 가로 상자를...@>=
last_badness = badness(x, total_stretch[normal])
if last_badness > hbadness() {
	print_ln()
	if last_badness > 100 {
		print_nl("Underfull")
	} else {
		print_nl("Loose")
	}
	print(" \\hbox (badness ")
	print_int(last_badness)
@.Underfull \\hbox...@>
@.Loose \\hbox...@>
	goto common_ending
}

@ 꽉 찬 상자나 덜 찬 상자가 어디서 비롯했는지 알맞게 알려 주려고, 전역 변수 |pack_begin_line|을 쓴다. 이 변수는
|hpack|을 문단 조립기나 정렬 마무리 루틴이 부를 때에만 0이 아닌 값으로 놓인다.

@<전역 변수@>=
var @!pack_begin_line int32 // 현재 문단이나 정렬이 시작한 원본 파일 줄; 음수는 정렬을 뜻한다

@ @<핵심 변수들의...@>=
pack_begin_line = 0

@ @<꽉 차거나 덜 찬 가로 상자에...@>=
if output_active {
	print(") has occurred while \\output is active")
} else {
	if pack_begin_line != 0 {
		if pack_begin_line > 0 {
			print(") in paragraph at lines ")
		} else {
			print(") in alignment at lines ")
		}
		print_int(abs(pack_begin_line))
		print("--")
	} else {
		print(") detected at line ")
	}
	print_int(line)
}
print_ln()
font_in_short_display = null_font
short_display(list_ptr(r))
print_ln()
begin_diagnostic()
show_box(r)
end_diagnostic(true)

@ @<가로 글루의 줄이기...@>=
@<줄이기 차수를 정한다@>
set_glue_order(r, o)
set_glue_sign(r, shrinking)
if total_shrink[o] != 0 {
	set_glue_set(r, unfloat(float64(-x)/float64(total_shrink[o])))
@^real division@>
} else {
	set_glue_sign(r, normal)
	set_glue_set(r, 0.0) // 줄일 것이 없다
}
if total_shrink[o] < -x && o == normal && list_ptr(r) != null {
	last_badness = 1000000
	set_glue_set(r, 1.0) // 최대로 줄인다
	@<꽉 찬 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
} else if o == normal {
	if list_ptr(r) != null {
		@<빡빡한 가로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
	}
}
return r

@ @<줄이기 차수를...@>=
if total_shrink[filll] != 0 {
	o = filll
} else if total_shrink[fill] != 0 {
	o = fill
} else if total_shrink[fil] != 0 {
	o = fil
} else {
	o = normal
}

@ @<꽉 찬 가로 상자를...@>=
if -x-total_shrink[normal] > hfuzz() || hbadness() < 100 {
	if overfull_rule() > 0 && -x-total_shrink[normal] > hfuzz() {
		for link(q) != null {
			q = link(q)
		}
		set_link(q, new_rule())
		set_width(link(q), overfull_rule())
	}
	print_ln()
	print_nl("Overfull \\hbox (")
@.Overfull \\hbox...@>
	print_scaled(-x - total_shrink[normal])
	print("pt too wide")
	goto common_ending
}

@ @<빡빡한 가로 상자를...@>=
last_badness = badness(-x, total_shrink[normal])
if last_badness > hbadness() {
	print_ln()
	print_nl("Tight \\hbox (badness ")
	print_int(last_badness)
@.Tight \\hbox...@>
	goto common_ending
}

@ 서브루틴 |vpack|은 실은 |vpackage|라는 조금 더 일반적인 루틴의 특별한 경우다. 이 루틴에는 매개변수가 넷 있다. 넷째
매개변수는 |vpack|의 경우에는 |max_dimen|인데, 만들어지는 쪽 상자의 최대 깊이를 지정한다. 깊이는 먼저 보통의 규칙으로
계산된다. 그것이 이 한계를 넘으면 한계 깊이에 이를 때까지 기준점을 그냥 아래로 옮긴다.

@<함수들@>=
func vpack(p pointer, h scaled, m small_number) pointer { // 깊이에 제약이 없는 특별한 경우
	return vpackage(p, h, m, max_dimen)
}

func vpackage(p pointer, h scaled, m small_number, l scaled) pointer {
	var r pointer // 돌려줄 상자 노드
	var w, d, x scaled // 너비, 깊이, 자연 높이
	var s scaled // 옮김의 양
	var g pointer // 글루 명세를 가리킨다
	var o glue_ord // 무한대의 차수
	last_badness = 0
	r = get_node(box_node_size)
	set_type(r, vlist_node)
	set_subtype(r, min_quarterword)
	set_shift_amount(r, 0)
	set_list_ptr(r, p)
	w = 0
	@<치수들을 0으로...@>
	for p != null {
		@<세로 목록의 노드 |p|를 살펴 반영하고 다음으로 나아간다@>
	}
	set_width(r, w)
	if d > l {
		x = x + d - l
		set_depth(r, l)
	} else {
		set_depth(r, d)
	}
	@<|height(r)|의 값과 알맞은 글루 설정을 정하고, |return|하거나 |goto common_ending|@>
common_ending:
	@<꽉 차거나 덜 찬 세로 상자에 관한 진단 메시지를 마저 낸다@>
	return r
}

@ @<세로 목록의 노드 |p|를...@>=
if is_char_node(p) {
	confusion("vpack")
@:this can't happen vpack}{\quad vpack@>
} else {
	switch type_(p) {
	case hlist_node, vlist_node, rule_node, unset_node:
		@<상자의 치수를 그것을 담을 세로 상자의 치수에 반영한다@>
	case whatsit_node: @<whatsit 노드를 세로 상자에 반영한다@>
	case glue_node: @<글루를 세로 합계에 반영한다@>
	case kern_node:
		x = x + d + width(p)
		d = 0
	default: // 아무것도 하지 않는다
	}
}
p = link(p)

@ @<상자의 치수를 그것을 담을 세로...@>=
x = x + d + height(p)
d = depth(p)
if type_(p) >= rule_node {
	s = 0
} else {
	s = shift_amount(p)
}
if width(p)+s > w {
	w = width(p) + s
}

@ @<글루를 세로 합계에...@>=
x = x + d
d = 0
g = glue_ptr(p)
x = x + width(g)
o = stretch_order(g)
total_stretch[o] = total_stretch[o] + stretch(g)
o = shrink_order(g)
total_shrink[o] = total_shrink[o] + shrink(g)
if subtype(p) >= a_leaders {
	g = leader_ptr(p)
	if width(g) > w {
		w = width(g)
	}
}

@ 프로그램의 지금 부분에 이르면 |x|는 꾸리고 있는 상자의 자연 높이다.

@<|height(r)|의 값과...@>=
if m == additional {
	h = x + h
}
set_height(r, h)
x = h - x // 이제 |x|는 메워야 할 초과분이다
if x == 0 {
	set_glue_sign(r, normal)
	set_glue_order(r, normal)
	set_glue_set(r, 0.0)
	return r
} else if x > 0 {
	@<세로 글루의 늘이기 설정을 정하고, |return|하거나 |goto common_ending|@>
} else {
	@<세로 글루의 줄이기 설정을 정하고, |return|하거나 |goto common_ending|@>
}

@ @<세로 글루의 늘이기...@>=
@<늘이기 차수를...@>
set_glue_order(r, o)
set_glue_sign(r, stretching)
if total_stretch[o] != 0 {
	set_glue_set(r, unfloat(float64(x)/float64(total_stretch[o])))
@^real division@>
} else {
	set_glue_sign(r, normal)
	set_glue_set(r, 0.0) // 늘일 것이 없다
}
if o == normal {
	if list_ptr(r) != null {
		@<덜 찬 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
	}
}
return r

@ @<덜 찬 세로 상자를...@>=
last_badness = badness(x, total_stretch[normal])
if last_badness > vbadness() {
	print_ln()
	if last_badness > 100 {
		print_nl("Underfull")
	} else {
		print_nl("Loose")
	}
	print(" \\vbox (badness ")
	print_int(last_badness)
@.Underfull \\vbox...@>
@.Loose \\vbox...@>
	goto common_ending
}

@ @<꽉 차거나 덜 찬 세로 상자에...@>=
if output_active {
	print(") has occurred while \\output is active")
} else {
	if pack_begin_line != 0 { // 실은 음수다
		print(") in alignment at lines ")
		print_int(abs(pack_begin_line))
		print("--")
	} else {
		print(") detected at line ")
	}
	print_int(line)
	print_ln()
}
begin_diagnostic()
show_box(r)
end_diagnostic(true)

@ @<세로 글루의 줄이기...@>=
@<줄이기 차수를...@>
set_glue_order(r, o)
set_glue_sign(r, shrinking)
if total_shrink[o] != 0 {
	set_glue_set(r, unfloat(float64(-x)/float64(total_shrink[o])))
@^real division@>
} else {
	set_glue_sign(r, normal)
	set_glue_set(r, 0.0) // 줄일 것이 없다
}
if total_shrink[o] < -x && o == normal && list_ptr(r) != null {
	last_badness = 1000000
	set_glue_set(r, 1.0) // 최대로 줄인다
	@<꽉 찬 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
} else if o == normal {
	if list_ptr(r) != null {
		@<빡빡한 세로 상자를 알리고, 이 상자가 충분히 나쁘면 |goto common_ending|@>
	}
}
return r

@ @<꽉 찬 세로 상자를...@>=
if -x-total_shrink[normal] > vfuzz() || vbadness() < 100 {
	print_ln()
	print_nl("Overfull \\vbox (")
@.Overfull \\vbox...@>
	print_scaled(-x - total_shrink[normal])
	print("pt too high")
	goto common_ending
}

@ @<빡빡한 세로 상자를...@>=
last_badness = badness(-x, total_shrink[normal])
if last_badness > vbadness() {
	print_ln()
	print_nl("Tight \\vbox (badness ")
	print_int(last_badness)
@.Tight \\vbox...@>
	goto common_ending
}

@ 상자를 현재의 세로 목록에 덧붙일 때 기준선 간격 계산은 루틴 |append_to_vlist|가 맡는다.

@<함수들@>=
func append_to_vlist(b pointer) {
	var d scaled // 기준선 사이 간격의 모자람
	var p pointer // 새 글루 노드
	if prev_depth() > ignore_depth {
		d = width(baseline_skip()) - prev_depth() - height(b)
		if d < line_skip_limit() {
			p = new_param_glue(line_skip_code)
		} else {
			p = new_skip_param(baseline_skip_code)
			set_width(temp_ptr, d) // |temp_ptr=glue_ptr(p)|
		}
		set_link(tail, p)
		tail = p
	}
	set_link(tail, b)
	tail = b
	set_prev_depth(depth(b))
}

@* 수식 모드의 자료 구조.
\TeX은 \.\$로 둘러싼 수식을 읽으면 {\sl 수식 목록}(mlist)을 만든다. 이것은 본질적으로 그 수식을 나타내는 나무
구조다. 수식 목록은 항목들의 선형 나열이지만, 수식 목록 안에 수식 목록이 나타날 수 있으므로 나무 구조로 볼 수 있다.
이를테면 많은 항목에 아래첨자나 위첨자가 붙을 수 있는데, 그런 ``첨자''는 그 자체로 수식 목록이다.

실제 조판을 하기 전에 수식 전체를 그런 나무로 분석한다. 대개 수식을 다 훑을 때까지는 현재의 활자 모양을 알 수 없기
때문이다. 이를테면 수식 `\.{\$a+b \\over c+d\$}'를 읽을 때, `\.{\\over}'가 나타나기 전에는 `\.{a+b}'가 첨자 크기가 될지
알 길이 없다.

훑는 과정에서 만들고 있는 수식 목록의 원소는 저마다 관계, 이항 연산자, 여는 괄호 따위로, 또는 쌓아 올려야 하는
`\.{\\sqrt}' 같은 구성으로 분류된다. 이 분류는 수식 목록 자료 구조에 나타난다.

수식을 다 훑고 나면 수식 목록을 가로 목록으로 바꾸어서 둘레의 텍스트에 넣을 수 있게 한다. 이 변환은 재귀 프로시저가
다스리는데, 이 프로시저는 가장 바깥 수준에서 시작해서 하위 수식들로 들어가며 ``하향식''으로 알맞은 모양을 모두
정한다. 결국 수식은 가로 상자와 세로 상자를 조합하고, 필요하면 글루와 벌점 노드를 끼워 넣어서 붙여 맞춘다.

수식 목록은 내부에서 주로 ``노드''(noad, `노-애드'라고 읽는다)로 이루어진 연결 목록으로 나타낸다. 이 이름은 가로
목록과 세로 목록의 조금 비슷한 ``노드''(node)와 구별하려는 것이다. 어떤 종류의 보통 노드(node)는 노드(noad)와 함께 수식 목록에
나타날 수 있다. \TeX은 둘을 |type| 필드로 구별한다. 노드(noad)의 |type|은 언제나 노드(node)의 것보다 크기 때문이다.
수식 목록에는 문자 노드, 가로 목록 노드, 세로 목록 노드, 수식 노드, 합자 노드, 미정 노드가 들어 있지 않다. 특히
수식 목록의 항목은 모두 |mem|의 가변 크기 부분에 나타나므로 |type| 필드가 언제나 있다.

보충: 이 번역에서는 수식의 ``noad''를 그냥 노드라고 옮기되, 필요하면 원어를 덧붙인다.

@ 노드(noad)는 저마다 네 낱말 이상의 길이다. 첫 낱말에는 이미 우리에게 아주 익숙한 |type|과 |subtype|과 |link| 필드가 들어
있다. 둘째, 셋째, 넷째 낱말은 노드의 |nucleus|, |subscr|, |supscr| 필드라고 부른다.

이를테면 간단한 수식 `\.{\$x\^2\$}'를 생각해 보자. 이것은 |ord_noad|라고 부르는 원소 하나를 담은 수식 목록으로
분석된다. 이 노드의 |nucleus|는 `\.x'의 표현이고, |subscr|는 비어 있으며, |supscr|는 `\.2'의 표현이다.

필드 |nucleus|, |subscr|, |supscr|는 다시 하위 필드로 나뉜다. 포인터 |p|가 노드를 가리키고 |q|가 그 주요 필드 가운데 하나라면
(이를테면 |q=subscr(p)|), |q|의 |math_type|에 따라 하위 필드의 가능성이 여럿 있다.

\yskip\hang|math_type(q)=math_char|는 |fam(q)|가 열여섯 글꼴 가족 가운데 하나를 가리키고, |character(q)|가 문자 노드에서처럼
그 가족의 글꼴 안의 문자 번호라는 뜻이다.

\yskip\hang|math_type(q)=math_text_char|도 비슷하지만, 그 문자에는 아래첨자도 위첨자도 붙지 않았고 바로 뒤에 같은 글꼴의
다른 문자가 온다. (이 |math_type| 설정은 처리하는 동안 잠깐만 나타난다. 원하지 않는 기울임 보정을 막는 데 쓰인다.)

\yskip\hang|math_type(q)=empty|는 값이 없는 필드를 나타낸다(노드 |p|의 해당 속성이 없다).

\yskip\hang|math_type(q)=sub_box|는 |info(q)|가 상자 노드(|hlist_node|나 |vlist_node|)를 가리키고, 그것을 이 필드의 값으로
써야 한다는 뜻이다. 하위 상자 노드의 |shift_amount|는 그 상자를 아래로 옮길 양이다.

\yskip\hang|math_type(q)=sub_mlist|는 |info(q)|가 수식 목록을 가리킨다는 뜻이다. 이 필드의 값을 얻으려면 그 수식 목록을
가로 목록으로 바꾸어야 한다.

\yskip\noindent 뒤의 경우에는 |info(q)=null|일 수도 있다. 이것은 |math_type(q)=empty|와 같지 않다. 이를테면
`\.{\$P\_\{\}\$}'와 `\.{\$P\$}'는 다른 결과를 낸다(앞의 것에서는 |P|의 너비에 ``기울임 보정''이 더해지지 않지만,
``첨자 간격''이 더해진다).

여기서 정한 하위 필드의 정의는 분명히 공간을 낭비한다. 필드 |math_type|에는 세 비트면 될 텐데 하프워드를 쓰기 때문이다.
그러나 노드(noad)가 한꺼번에 많이 있는 일은 거의 없다. 노드(noad)는 곧 더 많은 공간을 차지하는 노드(node)로 바뀌므로, 프로그래밍을
가장 단순하게 하는 방식으로 나타낼 여유가 있다.

@<정의@>=
const (
	@!noad_size = 4 // 보통 노드의 낱말 수
	@!math_char = 1 // 속성이 단순할 때의 |math_type|
	@!sub_box = 2 // 속성이 상자일 때의 |math_type|
	@!sub_mlist = 3 // 속성이 수식일 때의 |math_type|
	@!math_text_char = 4 // 기울임 보정이 미심쩍을 때의 |math_type|
)

func nucleus(p pointer) pointer { return p + 1 } // 노드의 |nucleus| 필드
func supscr(p pointer) pointer  { return p + 2 } // 노드의 |supscr| 필드
func subscr(p pointer) pointer  { return p + 3 } // 노드의 |subscr| 필드
func math_type(p pointer) halfword { return link(p) } // |mem|의 |halfword|
func set_math_type(p pointer, v halfword) { set_link(p, v) }
func fam(p pointer) quarterword { return font(p) } // |mem|의 |quarterword|
func set_fam(p pointer, v quarterword) { set_font_field(p, v) }

@ 수식의 각 부분은 간격과 줄 나누기를 위해 Ord, Op, Bin, Rel, Open, Close, Punct, Inner 가운데 하나로 분류된다. 여러
종류의 부분을 나타내는 데 |ord_noad|, |op_noad|, |bin_noad|, |rel_noad|, |open_noad|, |close_noad|, |punct_noad|,
|inner_noad|가 쓰인다. 이를테면 수식 안의 `\.=' 기호는 |nucleus| 필드가 등호의 표현인(대개 |fam=0|, |character=@'75|)
|rel_noad|를 만든다. 명령 \.{\\mathrel}이 앞에 붙은 수식도 |rel_noad|를 낳는다. 노드 |rel_noad| 뒤에 이를테면 |op_noad|가 오면(그
사이에 보통 노드가 하나 이상 끼어 있을 수도 있다), \TeX은 |rel_noad|에 해당하는 수식 바로 뒤에 (현재의 |rel_penalty|를
가진) 벌점 노드를 끼워 넣는다. 다만 바로 뒤에 이미 벌점이 있으면 넣지 않는다. 그리고 |op_noad|에 해당하는 수식 바로
앞에는 ``굵은 공백''을 끼워 넣는다.

형이 |ord_noad|, |op_noad|, \dots, |inner_noad|인 노드는 대개 |subtype=normal|이다. 단 하나의 예외는 이 연산자에 대해 극한의
보통 위치가 무시되었다면 |op_noad|의 |subtype|이 |limits|나 |no_limits|일 수 있다는 것이다.

@<정의@>=
const (
	@!ord_noad = unset_node + 3 // Ord로 분류된 노드의 |type|
	@!op_noad = ord_noad + 1 // Op로 분류된 노드의 |type|
	@!bin_noad = ord_noad + 2 // Bin으로 분류된 노드의 |type|
	@!rel_noad = ord_noad + 3 // Rel로 분류된 노드의 |type|
	@!open_noad = ord_noad + 4 // Open으로 분류된 노드의 |type|
	@!close_noad = ord_noad + 5 // Close로 분류된 노드의 |type|
	@!punct_noad = ord_noad + 6 // Punct로 분류된 노드의 |type|
	@!inner_noad = ord_noad + 7 // Inner로 분류된 노드의 |type|
	@!limits = 1 // 첨자가 위아래에 오는 |op_noad|의 |subtype|
	@!no_limits = 2 // 첨자가 보통 자리에 오는 |op_noad|의 |subtype|
)

@ 노드 |radical_noad|는 다섯 낱말 길이다. 다섯째 낱말은 |left_delimiter| 필드인데, 대개 제곱근 기호를 나타낸다.

노드 |fraction_noad|는 여섯 낱말 길이다. 여기에는 |left_delimiter|만이 아니라 |right_delimiter| 필드도 있다.

구분자 필드는 형이 |four_quarters|이고, |small_fam|, |small_char|, |large_fam|, |large_char|라는 하위 필드가 넷 있다. 이
하위 필드들은 {\sl The \TeX book}의 17장에서 설명하듯이 ``작은'' 시작 문자와 ``큰'' 시작 문자를 주어서 크기가 변하는
@^TeXbook@>
구분자를 나타낸다.

노드 |fraction_noad|는 실은 다른 모든 노드와 아주 다르다. 여섯 낱말이라는 것만이 아니라, |nucleus|, |subscr|, |supscr| 대신
|thickness|, |denominator|, |numerator| 필드가 있다. 필드 |thickness|는 분수 괘선을 얼마나 두껍게 할지 알려 주는 눈금 값이다.
다만 특별한 값 |default_code|는 현재 크기의 |default_rule_thickness|를 나타내는 데 쓰인다. 필드 |numerator|와 |denominator|는
분수를 정의하는 수식 목록을 가리킨다. 언제나 $$\hbox{|math_type(numerator)=math_type(denominator)=sub_mlist|}$$이다.
필드 |left_delimiter|와 |right_delimiter|는 분수의 왼쪽과 오른쪽에 놓을 구분자를 지정한다. 이렇게 해서 |fraction_noad|는
\TeX의 연산자 \.{\\over}, \.{\\atop}, \.{\\above}, \.{\\overwithdelims}, \.{\\atopwithdelims}, \.{\\abovewithdelims}를 모두
나타낼 수 있다.

@<정의@>=
const (
	@!radical_noad = inner_noad + 1 // 제곱근을 위한 노드의 |type|
	@!radical_noad_size = 5 // 근호 노드의 |mem| 낱말 수
	@!fraction_noad = radical_noad + 1 // 일반화된 분수를 위한 노드의 |type|
	@!fraction_noad_size = 6 // 분수 노드의 |mem| 낱말 수
	@!default_code = 0o10000000000 // |default_rule_thickness|를 나타낸다
)

func left_delimiter(p pointer) pointer  { return p + 4 } // 노드의 첫 구분자 필드
func right_delimiter(p pointer) pointer { return p + 5 } // 분수 노드의 둘째 구분자 필드
func small_fam(p pointer) quarterword  { return mem[p].qqqq.b0 } // ``작은'' 구분자의 |fam|
func set_small_fam(p pointer, v quarterword)  { mem[p].qqqq.b0 = v }
func small_char(p pointer) quarterword { return mem[p].qqqq.b1 } // ``작은'' 구분자의 |character|
func set_small_char(p pointer, v quarterword) { mem[p].qqqq.b1 = v }
func large_fam(p pointer) quarterword  { return mem[p].qqqq.b2 } // ``큰'' 구분자의 |fam|
func set_large_fam(p pointer, v quarterword)  { mem[p].qqqq.b2 = v }
func large_char(p pointer) quarterword { return mem[p].qqqq.b3 } // ``큰'' 구분자의 |character|
func set_large_char(p pointer, v quarterword) { mem[p].qqqq.b3 = v }
func thickness(p pointer) scaled { return width(p) } // 분수 노드의 |thickness| 필드
func set_thickness(p pointer, v scaled) { set_width(p, v) }
func numerator(p pointer) pointer   { return supscr(p) } // 분수 노드의 |numerator| 필드
func denominator(p pointer) pointer { return subscr(p) } // 분수 노드의 |denominator| 필드

@ 전역 변수 |empty_field|는 새 노드의 빈 필드를 초기화하는 데 쓰려고 마련해 둔다. 마찬가지로 |null_delimiter|는 구분자
필드를 초기화하는 데 쓴다.

@<전역 변수@>=
var @!empty_field two_halves
var @!null_delimiter four_quarters

@ @<핵심 변수들의...@>=
empty_field.rh = empty
empty_field.lh = null
null_delimiter.b0 = 0
null_delimiter.b1 = min_quarterword
null_delimiter.b2 = 0
null_delimiter.b3 = min_quarterword

@ 함수 |new_noad|는 완전히 빈 |ord_noad|를 만든다.

@<함수들@>=
func new_noad() pointer {
	var p pointer
	p = get_node(noad_size)
	set_type(p, ord_noad)
	set_subtype(p, normal)
	mem[nucleus(p)].hh = empty_field
	mem[subscr(p)].hh = empty_field
	mem[supscr(p)].hh = empty_field
	return p
}

@ 노드 몇 종류가 더 있으면 한 벌이 완성된다. 노드 |under_noad|는 핵에 밑줄을 긋고, |over_noad|는 윗줄을 긋는다.
노드 |accent_noad|는 핵 위에 악센트를 놓는다. 악센트 문자는 |fam(accent_chr(p))|와 |character(accent_chr(p))|로 나타난다.
노드 |vcenter_noad|는 핵을 수식의 축에 대해 세로로 가운데 맞춘다. 그런 노드에서는 언제나 |math_type(nucleus(p))=sub_box|다.

그리고 마지막으로 \TeX의 \.{\\left}와 \.{\\right}를 구현하는 |left_noad|와 |right_noad| 형이 있다. 그런 노드의 |nucleus|는
|delimiter| 필드로 바뀐다. 그래서 이를테면 `\.{\\left(}'는 |delimiter(p)|가 모든 왼쪽 괄호의 가족과 문자 코드를 담은
|left_noad|를 낳는다. 노드 |left_noad|는 수식 목록에서 첫 원소로만 나타나고, |right_noad|는 마지막 원소로만 나타난다. 게다가
|left_noad|와 |right_noad|는 둘 다 있거나 둘 다 없다. 이 두 노드에서 |subscr|와 |supscr| 필드는 언제나
|empty|다.

@<정의@>=
const (
	@!under_noad = fraction_noad + 1 // 밑줄을 위한 노드의 |type|
	@!over_noad = under_noad + 1 // 윗줄을 위한 노드의 |type|
	@!accent_noad = over_noad + 1 // 악센트 붙은 하위 수식을 위한 노드의 |type|
	@!accent_noad_size = 5 // 악센트 노드의 |mem| 낱말 수
	@!vcenter_noad = accent_noad + 1 // \.{\\vcenter}를 위한 노드의 |type|
	@!left_noad = vcenter_noad + 1 // \.{\\left}를 위한 노드의 |type|
	@!right_noad = left_noad + 1 // \.{\\right}를 위한 노드의 |type|
)

func accent_chr(p pointer) pointer { return p + 4 } // 악센트 노드의 |accent_chr| 필드
func delimiter(p pointer) pointer  { return nucleus(p) } // 왼쪽과 오른쪽 노드의 |delimiter| 필드
func scripts_allowed(p pointer) bool { return type_(p) >= ord_noad && type_(p) < left_noad }

@ 수식에는 \.{\\textstyle}처럼 \TeX의 보통 모양 규칙을 무시하는 명령도 들어 있을 수 있다. 그런 명령을 기록하려고
자료 구조에 |style_node|를 끼워 넣는다. 이것은 세 낱말 길이이므로 노드(noad)가 아니라 노드(node)로 여겨진다.
그 |subtype|은 |display_style|이나 |text_style|이나 |script_style|이나 |script_script_style|이다. 노드 |style_node|의 둘째와 셋째
낱말은 쓰이지 않지만, |choice_node|가 |style_node|로 바뀌므로 있다.

\TeX은 기본 모양 |display_style|, \dots, |script_script_style|을 짝수 0, 2, 4, 6으로 나타내고, 1을 더해서 이 모양들의
``조인''(cramped) 판을 얻는다. 이렇게 하면 수의 순서가 {\sl The \TeX book}의 부록~G의 관례와 거꾸로가 된다. 곧 더 작은
@^TeXbook@>
모양의 수 값이 더 크다.

@<함수들@>=
const (
	@!style_node = unset_node + 1 // 모양 노드의 |type|
	@!style_node_size = 3 // 모양 노드의 낱말 수
	@!display_style = 0 // \.{\\displaystyle}의 |subtype|
	@!text_style = 2 // \.{\\textstyle}의 |subtype|
	@!script_style = 4 // \.{\\scriptstyle}의 |subtype|
	@!script_script_style = 6 // \.{\\scriptscriptstyle}의 |subtype|
	@!cramped = 1 // 조이지 않은 모양을 조이려면 이것을 더한다
)

func new_style(s small_number) pointer { // 모양 노드를 만든다
	var p pointer // 새 노드
	p = get_node(style_node_size)
	set_type(p, style_node)
	set_subtype(p, s)
	set_width(p, 0)
	set_depth(p, 0) // |width|와 |depth|는 쓰이지 않는다
	return p
}

@ 마지막으로 원시 명령 \.{\\mathchoice}는 |choice_node|를 만든다. 이 노드에는 각 모양을 위한 수식 목록을 가리키는 특별한
하위 필드 |display_mlist|, |text_mlist|, |script_mlist|, |script_script_mlist|가 있다.

@<함수들@>=
const @!choice_node = unset_node + 2 // 선택 노드의 |type|

func display_mlist(p pointer) pointer       { return info(p + 1) } // 따로 세운 모양에 쓸 수식 목록
func set_display_mlist(p pointer, v pointer) { set_info(p+1, v) }
func text_mlist(p pointer) pointer          { return link(p + 1) } // 본문 모양에 쓸 수식 목록
func set_text_mlist(p pointer, v pointer)   { set_link(p+1, v) }
func script_mlist(p pointer) pointer        { return info(p + 2) } // 첨자 모양에 쓸 수식 목록
func set_script_mlist(p pointer, v pointer) { set_info(p+2, v) }
func script_script_mlist(p pointer) pointer { return link(p + 2) } // 첨자의 첨자 모양에 쓸 수식 목록
func set_script_script_mlist(p pointer, v pointer) { set_link(p+2, v) }

func new_choice() pointer { // 선택 노드를 만든다
	var p pointer // 새 노드
	p = get_node(style_node_size)
	set_type(p, choice_node)
	set_subtype(p, 0) // |subtype|은 쓰이지 않는다
	set_display_mlist(p, null)
	set_text_mlist(p, null)
	set_script_mlist(p, null)
	set_script_script_mlist(p, null)
	return p
}

@ 이제 |show_node_list|에서 아직 쓰지 않은 부분, 곧 수식 목록에만 있을 수 있는 것들을 보여 주는 부분을 살펴보자. 이
프로그램은 방금 정의한 자료 구조에 접근하는 방법을 보여 준다.

다음 프로그램의 문맥에서 |p|는 보여 줄 노드를 가리키고, 현재 문자열에는 이 지점에 이르는 ``재귀 내력''이 들어 있다.
재귀 내력은 |p|가 어떤 노드의 하위에 있거나 어떤 노드의 |nucleus| 필드의 하위에 있는 바깥 수준마다 점 하나씩으로
이루어진다. 포인터 |p|가 노드의 |subscr|나 |supscr|나 |denominator|나 |numerator| 필드에서 내려온 것이면 점 대신 `\.\_'나
`\.\^'나 `\./'나 `\.\\'가 된다. 이를테면 |p|가 (터무니없는) 수식
`\.{\$\\sqrt\{a\^\{\\mathinner\{b\_\{c\\over x+y\}\}\}\}\$}'에서 |x|에 대한 |ord_noad|를 가리키면 현재 문자열은
`\.{.\^.\_/}'일 것이다.

@<수식 목록에서만 생기는 |show_node_list|의 경우들@>=
case style_node: print_style(subtype(p))
case choice_node: @<선택 노드 |p|를 보인다@>
case ord_noad, op_noad, bin_noad, rel_noad, open_noad, close_noad, punct_noad, inner_noad,
	radical_noad, over_noad, under_noad, vcenter_noad, accent_noad,
	left_noad, right_noad: @<보통 노드 |p|를 보인다@>
case fraction_noad: @<분수 노드 |p|를 보인다@>

@ 다음은 노드를 보이는 데 쓰는 간단한 루틴 몇 개다.

@<수식 목록의 원소들을 보이는...@>=
func print_fam_and_char(p pointer) { // 가족과 문자를 찍는다
	print_esc("fam")
	print_int(fam(p))
	print_char(' ')
	print_ASCII(qo(character(p)))
}

func print_delimiter(p pointer) { // 구분자를 24비트 십육진 값으로 찍는다
	var a int32 // 누산기
	a = small_fam(p)*256 + qo(small_char(p))
	a = a*0x1000 + large_fam(p)*256 + qo(large_char(p))
	if a < 0 {
		print_int(a) // 이런 일은 결코 일어나지 않아야 한다
	} else {
		print_hex(a)
	}
}

@ 다음 서브루틴은 하위 수식 목록을 보여야 할 때 재귀의 다른 수준으로 내려간다. 매개변수 |c|는 재귀 내력의 일부가 될
문자를 나타낸다. 빈 수식 목록은 |math_type(p)=empty|인 필드와 구별한다. 이 둘은 (위에서 설명했듯이) 같지 않기 때문이다.
@^recursion@>

보충: 원본은 여기서 |show_info|를 |forward|로 선언한다. \GO/에서는 필요 없다.

@<수식 목록의 원소들을 보이는...@>=
func print_subsidiary_data(p pointer, c ASCII_code) { // 노드의 필드를 보인다
	if cur_length() >= depth_threshold {
		if math_type(p) != empty {
			print(" []")
		}
	} else {
		append_char(c) // |c|를 재귀 내력에 넣는다
		temp_ptr = p // 재귀가 필요하면 |show_info|를 위해 준비한다
		switch math_type(p) {
		case math_char:
			print_ln()
			print_current_string()
			print_fam_and_char(p)
		case sub_box:
			show_info() // 재귀 호출
		case sub_mlist:
			if info(p) == null {
				print_ln()
				print_current_string()
				print("{}")
			} else {
				show_info() // 재귀 호출
			}
		default: // |empty|
		}
		flush_char() // |c|를 재귀 내력에서 없앤다
	}
}

@ 위의 코드에 |show_info|를 꼴사납게 끌어들인 것은, 매개변수가 있는 프로시저에 \PASCAL의 이상한 |forward| 선언을 쓰는
대안보다 나아 보인다. \PASCAL에서 |forward| 뒤의 프로시저에 매개변수를 빼는 관례는, 솔직히 말해서 \TeX의 저자에게 너무도
참을 수 없는 것이어서, 그는 차라리 전역 임시 변수를 통해 소통하는 데까지 몸을 낮추겠다. (비슷한 어리석음이 앞에서
|hlist_out|과 |vlist_out|에 대해 있었고, 아래에서 |mlist_to_hlist|에 대해서도 있을 것이다.)
@^Knuth, Donald Ervin@>
@^PASCAL@>

보충: \GO/에는 이런 문제가 없지만, 원본의 구조를 지키려고 |show_info|와 전역 변수 |temp_ptr|를 그대로 쓴다.

@<함수들@>=
func show_info() { // 독자는 이것을 너그러이 용서해 주시라
	show_node_list(info(temp_ptr))
}

@ @<수식 목록의 원소들을 보이는...@>=
func print_style(c int32) {
	switch c / 2 {
	case 0: print_esc("displaystyle") // |display_style=0|
	case 1: print_esc("textstyle") // |text_style=2|
	case 2: print_esc("scriptstyle") // |script_style=4|
	case 3: print_esc("scriptscriptstyle") // |script_script_style=6|
	default: print("Unknown style!")
	}
}

@ @<선택 노드 |p|를...@>=
print_esc("mathchoice")
append_char('D'); show_node_list(display_mlist(p)); flush_char()
append_char('T'); show_node_list(text_mlist(p)); flush_char()
append_char('S'); show_node_list(script_mlist(p)); flush_char()
append_char('s'); show_node_list(script_script_mlist(p)); flush_char()

@ @<보통 노드 |p|를...@>=
switch type_(p) {
case ord_noad: print_esc("mathord")
case op_noad: print_esc("mathop")
case bin_noad: print_esc("mathbin")
case rel_noad: print_esc("mathrel")
case open_noad: print_esc("mathopen")
case close_noad: print_esc("mathclose")
case punct_noad: print_esc("mathpunct")
case inner_noad: print_esc("mathinner")
case over_noad: print_esc("overline")
case under_noad: print_esc("underline")
case vcenter_noad: print_esc("vcenter")
case radical_noad: print_esc("radical"); print_delimiter(left_delimiter(p))
case accent_noad: print_esc("accent"); print_fam_and_char(accent_chr(p))
case left_noad: print_esc("left"); print_delimiter(delimiter(p))
case right_noad: print_esc("right"); print_delimiter(delimiter(p))
}
if subtype(p) != normal {
	if subtype(p) == limits {
		print_esc("limits")
	} else {
		print_esc("nolimits")
	}
}
if type_(p) < left_noad {
	print_subsidiary_data(nucleus(p), '.')
}
print_subsidiary_data(supscr(p), '^')
print_subsidiary_data(subscr(p), '_')

@ @<분수 노드 |p|를...@>=
print_esc("fraction, thickness ")
if thickness(p) == default_code {
	print("= default")
} else {
	print_scaled(thickness(p))
}
if small_fam(left_delimiter(p)) != 0 ||
	small_char(left_delimiter(p)) != min_quarterword ||
	large_fam(left_delimiter(p)) != 0 ||
	large_char(left_delimiter(p)) != min_quarterword {
	print(", left-delimiter ")
	print_delimiter(left_delimiter(p))
}
if small_fam(right_delimiter(p)) != 0 ||
	small_char(right_delimiter(p)) != min_quarterword ||
	large_fam(right_delimiter(p)) != 0 ||
	large_char(right_delimiter(p)) != min_quarterword {
	print(", right-delimiter ")
	print_delimiter(right_delimiter(p))
}
print_subsidiary_data(numerator(p), '\\')
print_subsidiary_data(denominator(p), '/')

@ 보일 수 있는 것은 없앨 수도 있다.

@<수식 목록에서만 생기는 |flush_node_list|의 경우들@>=
case style_node:
	free_node(p, style_node_size)
	goto done
case choice_node:
	flush_node_list(display_mlist(p))
	flush_node_list(text_mlist(p))
	flush_node_list(script_mlist(p))
	flush_node_list(script_script_mlist(p))
	free_node(p, style_node_size)
	goto done
case ord_noad, op_noad, bin_noad, rel_noad, open_noad, close_noad, punct_noad, inner_noad,
	radical_noad, over_noad, under_noad, vcenter_noad, accent_noad:
	if math_type(nucleus(p)) >= sub_box {
		flush_node_list(info(nucleus(p)))
	}
	if math_type(supscr(p)) >= sub_box {
		flush_node_list(info(supscr(p)))
	}
	if math_type(subscr(p)) >= sub_box {
		flush_node_list(info(subscr(p)))
	}
	if type_(p) == radical_noad {
		free_node(p, radical_noad_size)
	} else if type_(p) == accent_noad {
		free_node(p, accent_noad_size)
	} else {
		free_node(p, noad_size)
	}
	goto done
case left_noad, right_noad:
	free_node(p, noad_size)
	goto done
case fraction_noad:
	flush_node_list(info(numerator(p)))
	flush_node_list(info(denominator(p)))
	free_node(p, fraction_noad_size)
	goto done

@* 수식 모드의 서브루틴.
수식 목록을 가로 목록으로, 곧 노드(noad)를 노드(node)로 바꾸려면 서브루틴이 여럿 필요한데, 지금 다루어 두는 것이
편하다.

먼저 매개변수와 그 밖의 글꼴 정보를 쉽게 꺼낼 수 있게 해 주는 매크로를 소개하자. 16의 배수인 크기 코드를 가족 번호에
더하면, 가족과 크기의 조합마다 내부 글꼴 번호를 담은 표의 첨자를 얻는다. (조심하라. 크기 코드는 활자가 작아질수록
커진다.)

@<기본 인쇄...@>=
const (
	@!text_size = 0 // 한 가족에서 가장 큰 크기의 크기 코드
	@!script_size = 16 // 한 가족에서 중간 크기의 크기 코드
	@!script_script_size = 32 // 한 가족에서 가장 작은 크기의 크기 코드
)

func print_size(s int32) {
	if s == text_size {
		print_esc("textfont")
	} else if s == script_size {
		print_esc("scriptfont")
	} else {
		print_esc("scriptscriptfont")
	}
}

@ 수식 목록을 가로 목록으로 바꾸기 전에 \TeX은 가족~2의 글꼴들이 수식 기호 글꼴이 될 만큼 매개변수를 넉넉히 가졌는지,
가족~3의 글꼴들이 수식 확장 글꼴이 될 만큼 매개변수를 가졌는지 확인한다. 수식 기호 매개변수는 다음 매크로로 가리킨다.
이 매크로는 크기 코드를 매개변수로 받는다. 이를테면 |num1(cur_size)|는 현재 크기에서 |num1| 매개변수의 값이다.
@^parameters for symbols@>
@^font parameters@>

@<정의@>=
func mathsy(k, s int32) scaled { return font_info[k+param_base[fam_fnt(2+s)]].sc }

func math_x_height(s int32) scaled { return mathsy(5, s) } // `\.x'의 높이
func math_quad(s int32) scaled { return mathsy(6, s) } // \.{18mu}
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
func sup_drop(s int32) scaled { return mathsy(18, s) } // 큰 상자의 위 끝에서 위첨자 기준선까지
func sub_drop(s int32) scaled { return mathsy(19, s) } // 큰 상자의 아래 끝에서 아래첨자 기준선까지
func delim1(s int32) scaled { return mathsy(20, s) } // 따로 세운 모양에서 \.{\\atopwithdelims} 구분자의 크기
func delim2(s int32) scaled { return mathsy(21, s) } // 다른 모양에서 \.{\\atopwithdelims} 구분자의 크기
func axis_height(s int32) scaled { return mathsy(22, s) } // 기준선 위로 분수 괘선까지의 높이

const @!total_mathsy_params = 22

@ 수식 확장 매개변수에도 비슷한 매크로가 있지만 크기 코드는 뺀다(그런 매개변수를 쓸 때는 언제나 |cur_size|이기 때문이다).
@^parameters for symbols@>
@^font parameters@>

@<정의@>=
func mathex(k int32) scaled { return font_info[k+param_base[fam_fnt(3+cur_size)]].sc }

func default_rule_thickness() scaled { return mathex(8) } // \.{\\over} 괘선의 두께
func big_op_spacing1() scaled { return mathex(9) } // 따로 세운 연산자 위의 최소 틈
func big_op_spacing2() scaled { return mathex(10) } // 따로 세운 연산자 아래의 최소 틈
func big_op_spacing3() scaled { return mathex(11) } // 따로 세운 연산자 위의 최소 기준선 간격
func big_op_spacing4() scaled { return mathex(12) } // 따로 세운 연산자 아래의 최소 기준선 간격
func big_op_spacing5() scaled { return mathex(13) } // 따로 세운 극한의 위와 아래에 덧대는 양

const @!total_mathex_params = 13

@ 수식 목록과 그 하위 수식 목록 사이의 모양 변화도 계산해야 한다. 다음 매크로는 윗줄 그은 핵(|cramped_style|), 아래첨자나
위첨자(|sub_style|나 |sup_style|), 분자나 분모(|num_style|이나 |denom_style|)의 하위 모양을 정의한다.

@<정의@>=
func cramped_style(c int32) int32 { return 2*(c/2) + cramped } // 모양을 조인다
func sub_style(c int32) int32 { return 2*(c/4) + script_style + cramped } // 더 작게, 조여서
func sup_style(c int32) int32 { return 2*(c/4) + script_style + (c % 2) } // 더 작게
func num_style(c int32) int32 { return c + 2 - 2*(c/6) } // 이미 첨자의 첨자가 아니면 더 작게
func denom_style(c int32) int32 { return 2*(c/2) + cramped + 2 - 2*(c/6) } // 더 작게, 조여서

@ 모양이 바뀌면 다음 프로그램 조각이 그에 딸린 정보를 계산한다.

@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>=
if cur_style < script_style {
	cur_size = text_size
} else {
	cur_size = 16 * ((cur_style - text_style) / 2)
}
cur_mu = x_over_n(math_quad(cur_size), 18)

@ 다음은 주어진 두께 |t|의 괘선 노드를 가리키는 포인터를 돌려주는 함수다. 이 괘선은 결국 자신을 담을 세로 목록의 경계까지
가로로 뻗는다.

@<함수들@>=
func fraction_rule(t scaled) pointer { // 분수 괘선을 만든다
	var p pointer // 새 노드
	p = new_rule()
	set_height(p, t)
	set_depth(p, 0)
	return p
}

@ 함수 |overbar|는 세로 목록 상자를 가리키는 포인터를 돌려준다. 이 상자는 주어진 상자 |b|로 이루어지는데, 그 위에 높이 |k|의
커닝이 있고, 그 위에 두께 |t|의 분수 괘선이 있고, 다시 그 위에 높이 |t|의 빈 공간이 있다.

@<함수들@>=
func overbar(b pointer, k, t scaled) pointer {
	var p, q pointer // 만들고 있는 노드들
	p = new_kern(k); set_link(p, b)
	q = fraction_rule(t); set_link(q, p)
	p = new_kern(t); set_link(p, q)
	return vpack(p, natural, additional)
}

@ 넉넉히 큰 구분자를 찾거나 만드는 함수 |var_delimiter|는 지금 우리가 다루는 보조 함수 가운데 가장 흥미롭다. 어떤 노드의
구분자 필드를 가리키는 포인터 |d|와 크기 코드 |s|와 세로 거리 |v|가 주어지면, 이 함수는 높이와 깊이의 합이 |v| 이상인
|d|의 변형 가운데 가장 작은 것을 담은 상자를 가리키는 포인터를 돌려준다. (그리고 넉넉히 큰 변형이 없으면 가장 큰 변형을
돌려준다.) 특히 |d|가 늘일 수 있는 문자로 이어지면, 이 루틴은 그 조각들로 얼마든지 큰 구분자를 조립한다.

돌려주는 값은 상자인데, 그 |shift_amount|는 주어진 크기의 축에 대해 상자가 세로로 가운데 놓이도록 정해져 있다. 조립한
기호를 돌려줄 때, 옮기기 전 상자의 높이는 가장 위 조각의 높이일 것이다.

@<함수들@>=
@<|var_delimiter|의 하위 프로시저들@>@;
func var_delimiter(d pointer, s small_number, v scaled) pointer {
	var b pointer // 만들 상자
	var f, g internal_font_number // 지금까지 가장 좋은 글꼴 코드와 시험 중인 글꼴 코드
	var c, x, y quarterword // 지금까지 가장 좋은 문자 코드와 시험 중인 문자 코드들
	var m, n int32 // 조각의 개수
	var u scaled // 시험 중인 문자의 높이와 깊이의 합
	var w scaled // 지금까지 가장 큰 높이와 깊이의 합
	var q four_quarters // 문자 정보
	var hd eight_bits // 높이-깊이 바이트
	var r four_quarters // 늘일 수 있는 문자의 조각
	var z small_number // 글꼴 가족의 원소들을 훑는다
	var large_attempt bool // ``큰'' 변형을 시도하고 있는가?
	f = null_font; w = 0; large_attempt = false
	z = small_fam(d); x = small_char(d)
	for {
		@<|(z,x)|의 변형들을 살핀다@>
		if large_attempt {
			goto found // 넉넉히 큰 것이 없었다
		}
		large_attempt = true; z = large_fam(d); x = large_char(d)
	}
found:
	if f != null_font {
		@<변수 |b|가 |(f,c)|를 담은 상자를 가리키게 한다@>
	} else {
		b = new_null_box()
		set_width(b, null_delimiter_space()) // 구분자를 찾지 못하면 이 너비를 쓴다
	}
	set_shift_amount(b, half(height(b)-depth(b))-axis_height(s))
	return b
}

@ 어떤 문자는 어떤 글꼴에 없을 수도 있고, 문자들을 높이가 커지는 차례로 살피지 않을 수도 있어서, 찾는 과정이 조금
복잡하다. 더 좋은 문자를 찾을 때마다 |f|와 |c|를 정하고, 넉넉히 큰 변형을 만나자마자 |goto found|한다.

@<|(z,x)|의 변형들을 살핀다@>=
if z != 0 || x != min_quarterword {
	z = z + s + 16
	for {
		z = z - 16; g = fam_fnt(z)
		if g != null_font {
			@<글꼴 |g|에서 |x|로 시작하는 문자 목록을 살핀다@>
		}
		if z < 16 {
			break
		}
	}
}

@ 여기서도 더 좋은 문자를 찾을 때마다 |f|와 |c|를 정하고, 넉넉히 큰 변형을 만나자마자 |goto found|한다.

@<글꼴 |g|에서 |x|로 시작하는 문자 목록을 살핀다@>=
y = x
if qo(y) >= font_bc[g] && qo(y) <= font_ec[g] {
continue_:
	q = char_info(g, y)
	if char_exists(q) {
		if char_tag(q) == ext_tag {
			f = g; c = y; goto found
		}
		hd = height_depth(q)
		u = char_height(g, hd) + char_depth(g, hd)
		if u > w {
			f = g; c = y; w = u
			if u >= v {
				goto found
			}
		}
		if char_tag(q) == list_tag {
			y = rem_byte(q); goto continue_
		}
	}
}

@ 다음 서브루틴은 문자 하나만 담은 목록을 가진 새 상자를 만드는데, 그 너비에는 그 문자의 기울임 보정이 들어간다. 문자의
높이나 깊이가 음수이면 상자의 높이나 깊이도 음수가 된다. 그래서 이 루틴은 |hpack|이 내놓을 결과와 조금 다른 결과를 낼
수도 있다.

@<|var_delimiter|의 하위...@>=
func char_box(f internal_font_number, c quarterword) pointer {
	var q four_quarters
	var hd eight_bits // |height_depth| 바이트
	var b, p pointer // 새 상자와 그 문자 노드
	q = char_info(f, c); hd = height_depth(q)
	b = new_null_box(); set_width(b, char_width(f, q)+char_italic(f, q))
	set_height(b, char_height(f, hd)); set_depth(b, char_depth(f, hd))
	p = get_avail(); set_character(p, c); set_font_field(p, f); set_list_ptr(b, p)
	return b
}

@ 다음 코드가 실행될 때, 조립한 기호를 돌려주어야 하는 경우, 그리고 오직 그때에만 |char_tag(q)|가 |ext_tag|와 같다.

@<변수 |b|가 |(f,c)|를 담은 상자를...@>=
if char_tag(q) == ext_tag {
	@<조립법 |rem_byte(q)|와 글꼴 |f|로 새 상자 |b|에 늘일 수 있는 문자를 만든다@>
} else {
	b = char_box(f, c)
}

@ 늘일 수 있는 문자를 만들 때는 다음 서브루틴이 있으면 편하다. 이것은 주어진 문자를 상자 |b|에 이미 있는 문자들 위에 얹는다.

@<|var_delimiter|의 하위...@>=
func stack_into_box(b pointer, f internal_font_number, c quarterword) {
	var p pointer // |b|에 넣을 새 노드
	p = char_box(f, c); set_link(p, list_ptr(b)); set_list_ptr(b, p)
	set_height(b, height(p))
}

@ 또 하나의 편리한 서브루틴은 주어진 문자의 높이와 깊이의 합을 계산한다.

@<|var_delimiter|의 하위...@>=
func height_plus_depth(f internal_font_number, c quarterword) scaled {
	var q four_quarters
	var hd eight_bits // |height_depth| 바이트
	q = char_info(f, c); hd = height_depth(q)
	return char_height(f, hd) + char_depth(f, hd)
}

@ @<조립법 |rem_byte(q)|와 글꼴 |f|로...@>=
b = new_null_box()
set_type(b, vlist_node)
r = font_info[exten_base[f]+rem_byte(q)].qqqq
@<알맞은 최소 높이 |w|와 확장 단계 수 |n|을 계산하고 |width(b)|도 정한다@>
c = ext_bot(r)
if c != min_quarterword {
	stack_into_box(b, f, c)
}
c = ext_rep(r)
for m = 1; m <= n; m++ {
	stack_into_box(b, f, c)
}
c = ext_mid(r)
if c != min_quarterword {
	stack_into_box(b, f, c); c = ext_rep(r)
	for m = 1; m <= n; m++ {
		stack_into_box(b, f, c)
	}
}
c = ext_top(r)
if c != min_quarterword {
	stack_into_box(b, f, c)
}
set_depth(b, w-height(b))

@ 늘일 수 있는 문자의 너비는 되풀이할 수 있는 조각의 너비다. 이 조각의 높이와 깊이의 합이 양수가 아니면 이것을 하나도 쓰지
않는다. 그렇지 않으면 될 수 있는 대로 적게 쓴다(가운데 조각이 있으면 둘씩 묶어서 쓴다).

@<알맞은 최소 높이 |w|와...@>=
c = ext_rep(r); u = height_plus_depth(f, c)
w = 0; q = char_info(f, c); set_width(b, char_width(f, q)+char_italic(f, q))
c = ext_bot(r); if c != min_quarterword { w = w + height_plus_depth(f, c) }
c = ext_mid(r); if c != min_quarterword { w = w + height_plus_depth(f, c) }
c = ext_top(r); if c != min_quarterword { w = w + height_plus_depth(f, c) }
n = 0
if u > 0 {
	for w < v {
		w = w + u; n++
		if ext_mid(r) != min_quarterword {
			w = w + u
		}
	}
}

@ 다음 서브루틴은 훨씬 간단하다. 분수의 분자와 분모, 그리고 따로 세운 연산자와 그 위아래의 극한에 쓰인다. 주어진 상자~|b|를
받아서 너비~|w|인 상자 안의 가운데에 놓이도록 바꾼다. 가운데 맞춤은 |b| 안의 목록 왼쪽과 오른쪽에 \.{\\hss} 글루를 넣고
새 상자로 묶어서 한다. 그러므로 그 상자가 이미 무한 글루를 담고 있으면 실제로는 가운데에 놓이지 않을 수도 있다.

주어진 상자에 문자 하나만 들어 있고 그 문자의 기울임 보정이 상자 너비에 더해져 있을 수도 있다. 그때는 그것을 상쇄하는
커닝을 끼워 넣는다.

@<함수들@>=
func rebox(b pointer, w scaled) pointer {
	var p pointer // 목록을 다루는 임시 레지스터
	var f internal_font_number // 문자 하나짜리 상자의 글꼴
	var v scaled // 기울임 보정을 뺀 문자의 너비
	if width(b) != w && list_ptr(b) != null {
		if type_(b) == vlist_node {
			b = hpack(b, natural, additional)
		}
		p = list_ptr(b)
		if is_char_node(p) && link(p) == null {
			f = font(p); v = char_width(f, char_info(f, character(p)))
			if v != width(b) {
				set_link(p, new_kern(width(b)-v))
			}
		}
		free_node(b, box_node_size)
		b = new_glue(ss_glue); set_link(b, p)
		for link(p) != null {
			p = link(p)
		}
		set_link(p, new_glue(ss_glue))
		return hpack(b, w, exactly)
	} else {
		set_width(b, w); return b
	}
}

@ 다음은 `\.{mu}'로 표현한 글루 명세로부터, 수식 단위의 값이 주어지면, 새 글루 명세를 만드는 서브루틴이다.

보충: 원본의 매크로 |mu_mult|는 호출하는 쪽의 지역 변수 |n|과 |f|를 쓴다. 두 함수에서 쓰므로 그 둘을 인자로 받는 함수로
옮긴다.

@<함수들@>=
func mu_mult(n int32, f scaled, x scaled) scaled { return nx_plus_y(n, x, xn_over_d(x, f, 0o200000)) }

func math_glue(g pointer, m scaled) pointer {
	var p pointer // 새 글루 명세
	var n int32 // |m|의 정수 부분
	var f scaled // |m|의 소수 부분
	n = x_over_n(m, 0o200000); f = remainder
	if f < 0 {
		n--; f = f + 0o200000
	}
	p = get_node(glue_spec_size)
	set_width(p, mu_mult(n, f, width(g))) // \.{mu}를 \.{pt}로 바꾼다
	set_stretch_order(p, stretch_order(g))
	if stretch_order(p) == normal {
		set_stretch(p, mu_mult(n, f, stretch(g)))
	} else {
		set_stretch(p, stretch(g))
	}
	set_shrink_order(p, shrink_order(g))
	if shrink_order(p) == normal {
		set_shrink(p, mu_mult(n, f, shrink(g)))
	} else {
		set_shrink(p, shrink(g))
	}
	return p
}

@ 서브루틴 |math_kern|은 수식 단위의 값이 주어지면 커닝 노드에서 |mu_glue|를 없앤다.

@<함수들@>=
func math_kern(p pointer, m scaled) {
	var n int32 // |m|의 정수 부분
	var f scaled // |m|의 소수 부분
	if subtype(p) == mu_glue {
		n = x_over_n(m, 0o200000); f = remainder
		if f < 0 {
			n--; f = f + 0o200000
		}
		set_width(p, mu_mult(n, f, width(p))); set_subtype(p, explicit)
	}
}

@ 때로는 수식 목록을 없애야 한다. 다음 서브루틴은 |abs(mode)=mmode|라고 가정하고 현재 목록을 비운다.

@<함수들@>=
func flush_math() {
	flush_node_list(link(head)); flush_node_list(incompleat_noad())
	set_link(head, null); tail = head; set_incompleat_noad(null)
}

@* 수식 조판.
수식을 다루는 \TeX의 가장 중요한 루틴은 |mlist_to_hlist|다. 수식을 훑어서 수식 목록으로 나타내고 나면, 이 루틴이 그것을
상자에 넣거나 문단의 텍스트에 끼울 수 있는 가로 목록으로 바꾼다. 전역 변수로 넘기는 암묵적 매개변수가 셋 있다. 그 가운데 |cur_mlist|는
주어진 수식 목록의 첫 노드(node)나 노드(noad)를 가리키고(|null|일 수도 있다), |cur_style|은 모양 코드이며,
|mlist_penalties|는 결과 가로 목록에 줄 나누기 후보가 될 벌점 노드를 넣어야 하면 |true|다. 이 루틴이 일을 마치면
|link(temp_head)|가 번역된 가로 목록을 가리킨다.

수식 목록 안에 수식 목록이 있을 수 있으므로 이 프로시저는 재귀적이다. 그리고 이것은 \TeX의 안쪽 루프의 일부가 아니므로,
프로그램을 효율보다는 간결함에 무게를 두어 썼다.
@^recursion@>

@<전역 변수@>=
var @!cur_mlist pointer // 번역할 수식 목록의 시작
var @!cur_style small_number // 목록의 현재 자리의 모양 코드
var @!cur_size small_number // |cur_style|에 대응하는 크기 코드
var @!cur_mu scaled // |cur_size|에 대응하는 수식 단위 너비
var @!mlist_penalties bool // |mlist_to_hlist|가 벌점을 넣어야 하는가?

@ 프로시저 |mlist_to_hlist|의 재귀는 주로 |clean_box|라는 서브루틴에서 비롯한다. 이것은 주어진 노드 필드를 주어진 수식 모양으로
상자에 넣는다. 곧 |mlist_to_hlist|는 |clean_box|를 부를 수 있고, |clean_box|는 |mlist_to_hlist|를 부를 수 있다.
@^recursion@>

서브루틴 |clean_box|가 돌려주는 상자는 |shift_amount|가 0이라는 뜻에서 ``깨끗하다''.

보충: 원본은 여기서 |mlist_to_hlist|를 |forward|로 선언한다. \GO/에서는 필요 없다.

@<함수들@>=
func clean_box(p pointer, s small_number) pointer {
	var q pointer // 상자에 넣을 목록의 시작
	var save_style small_number // 되돌릴 |cur_style|
	var x pointer // 돌려줄 상자
	var r pointer // 임시 포인터
	switch math_type(p) {
	case math_char: cur_mlist = new_noad(); mem[nucleus(cur_mlist)] = mem[p]
	case sub_box: q = info(p); goto found
	case sub_mlist: cur_mlist = info(p)
	default: q = new_null_box(); goto found
	}
	save_style = cur_style; cur_style = s; mlist_penalties = false
	mlist_to_hlist(); q = link(temp_head) // 재귀 호출
	cur_style = save_style // 모양을 되돌린다
	@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
found:
	if is_char_node(q) || q == null {
		x = hpack(q, natural, additional)
	} else if link(q) == null && type_(q) <= vlist_node && shift_amount(q) == 0 {
		x = q // 이미 깨끗하다
	} else {
		x = hpack(q, natural, additional)
	}
	@<자명한 상자를 단순하게 한다@>
	return x
}

@ 흔한 경우에 메모리 공간을 아낀다.

@<자명한 상자를...@>=
q = list_ptr(x)
if is_char_node(q) {
	r = link(q)
	if r != null && link(r) == null && !is_char_node(r) && type_(r) == kern_node {
		// 필요 없는 기울임 보정
		free_node(r, small_node_size); set_link(q, null)
	}
}

@ 형이 |math_char|인 필드를 ``풀어 놓은'' 꼴로 바꾸는 프로시저가 있으면 편리하다. 루틴 |fetch|는 주어진 노드 필드의 글꼴 코드,
문자 코드, 문자 정보 바이트를 |cur_f|, |cur_c|, |cur_i|에 넣는다. 또한 없는 문자에 대한 오류 메시지도 낸다. 그런 경우
|fetch|가 일을 마친 뒤에는 |char_exists(cur_i)|가 |false|이고, 그 필드도 |empty|로 다시 정해져 있다.

@<함수들@>=
func fetch(a pointer) { // |math_char| 필드 |a|를 푼다
	cur_c = character(a); cur_f = fam_fnt(fam(a) + cur_size)
	if cur_f == null_font {
		@<정의되지 않은 가족에 대해 불평하고 |cur_i|를 널로 한다@>
	} else {
		if qo(cur_c) >= font_bc[cur_f] && qo(cur_c) <= font_ec[cur_f] {
			cur_i = char_info(cur_f, cur_c)
		} else {
			cur_i = null_character
		}
		if !char_exists(cur_i) {
			char_warning(cur_f, qo(cur_c))
			set_math_type(a, empty); cur_i = null_character
		}
	}
}

@ @<정의되지 않은 가족에 대해...@>=
print_err(""); print_size(cur_size); print_char(' ')
print_int(fam(a)); print(" is undefined (character ")
print_ASCII(qo(cur_c)); print_char(')')
help4("Somewhere in the math formula just ended, you used the",
	"stated character from an undefined font family. For example,",
	"plain TeX doesn't allow \\it or \\sl in subscripts. Proceed,",
	"and I'll try to forget that I needed that character.")
error(); cur_i = null_character; set_math_type(a, empty)

@ 루틴 |fetch|의 출력은 전역 변수에 놓인다.

@<전역 변수@>=
var @!cur_f internal_font_number // |math_char|의 |font| 필드
var @!cur_c quarterword // |math_char|의 |character| 필드
var @!cur_i four_quarters // |math_char|의 |char_info|, 또는 합자/커닝 명령

@ 할 일이 많고 갖가지이므로, |mlist_to_hlist|는 주어진 수식 목록을 두 번 훑는다.

첫째 훑기가 처리의 대부분을 한다. 글루에서 ``mu'' 간격을 없애고, 모든 하위 수식 목록을 재귀적으로 계산해서 맨 위 수준의
수식 목록만 다루면 되게 하고, 분수와 제곱근 따위를 상자에 넣고, 아래첨자와 위첨자를 붙이고, 맨 위 수준 수식 목록의 전체
높이와 깊이를 계산해서 |left_noad|와 |right_noad|의 구분자 크기를 알 수 있게 한다. 각 노드(noad)에서 나온 가로 목록은 그 노드의
|new_hlist| 필드에 기록된다. 이것은 |nucleus|나 |thickness|를 대신하는 정수 필드다.
@^recursion@>

둘째 훑기는 노드(noad)를 모두 없애고, 노드(node) 사이에 알맞은 글루와 벌점을 끼워 넣는다.

@<정의@>=
func new_hlist(p pointer) int32 { return mem[nucleus(p)].sc } // 수식 목록의 번역
func set_new_hlist(p pointer, v int32) { mem[nucleus(p)].sc = v }

@ 다음은 |mlist_to_hlist|의 전체 계획과 그 지역 변수의 목록이다.

보충: 원본은 레이블 |done_with_noad|(노드(noad)를 다 번역했을 때 가는 곳), |done_with_node|(노드(node)를 다 바꾸었을 때 가는 곳),
|check_dimensions|(|max_h|와 |max_d|를 갱신하러 가는 곳), |delete_q|(|q|를 지우고 다음 노드로 가는 곳)에 번호 80--83을
매기는 정의를 둔다. \GO/의 레이블은 이름이므로 이 정의는 필요 없다.

@<함수들@>=
@<수식 구성 프로시저들@>@;
func mlist_to_hlist() {
	var mlist pointer // 주어진 목록의 시작
	var penalties bool // 벌점 노드를 넣어야 하는가?
	var style small_number // 주어진 모양
	var save_style small_number // 재귀하는 동안 |cur_style|을 담아 둔다
	var q pointer // 수식 목록을 훑는다
	var r pointer // |q| 앞의 가장 최근 노드
	var r_type small_number // 노드 |r|의 |type|, |r=null|이면 |op_noad|
	var t small_number // 둘째 훑기에서 노드 |q|의 실질적인 |type|
	var p, x, y, z pointer // 목록을 만드는 임시 레지스터들
	var pen int32 // 넣을 벌점
	var s small_number // 지울 노드의 크기
	var max_h, max_d scaled // 지금까지 번역한 목록의 최대 높이와 깊이
	var delta scaled // 아래첨자와 위첨자 사이의 어긋남
	mlist = cur_mlist; penalties = mlist_penalties
	style = cur_style // 전역 매개변수를 지역 변수로 챙겨 둔다
	q = mlist; r = null; r_type = op_noad; max_h = 0; max_d = 0
	@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
	for q != null {
		@<노드 |q|를 첫째 훑기에서 할 수 있는 만큼 처리하고 다음으로 간다@>
	}
	@<마지막 |bin_noad|를 |ord_noad|로 바꾼다@>
	@<수식 목록을 다시 훑어 노드를 없애고 간격과 벌점을 넣는다@>
}

@ 수식 목록에는 문자 노드가 나타나지 않는다는 사실을 이용한다. 그래서 필드 |type(q)|는 언제나 있다.

@<노드 |q|를 첫째 훑기에서...@>=
@<|type(q)|에 따라 첫째 훑기 처리를 한다@>
check_dimensions:
	z = hpack(new_hlist(q), natural, additional)
	if height(z) > max_h {
		max_h = height(z)
	}
	if depth(z) > max_d {
		max_d = depth(z)
	}
	free_node(z, box_node_size)
done_with_noad:
	r = q; r_type = type_(r)
done_with_node:
	q = link(q)

@ 첫째 훑기에서 할 일 가운데 하나는, |bin_noad|가 이항 연산자의 문맥에 있지 않으면 그것을 |ord_noad|로 바꾸는 것이다. 변수 |r|과
|r_type|의 값이 있으면 이 일이 꽤 쉽다.

이 절은 노드(noad)를 다 처리했으면 |goto done_with_noad|하고, |new_hlist(q)|로 번역했으면 |goto check_dimensions|하고, 노드(node)를
다 처리했으면 |goto done_with_node|한다.

@<|type(q)|에 따라 첫째 훑기...@>=
reswitch:
	delta = 0
	switch type_(q) {
	case bin_noad:
		switch r_type {
		case bin_noad, op_noad, rel_noad, open_noad, punct_noad, left_noad:
			set_type(q, ord_noad); goto reswitch
		}
	case rel_noad, close_noad, punct_noad, right_noad:
		@<마지막 |bin_noad|를 |ord_noad|로 바꾼다@>
		if type_(q) == right_noad {
			goto done_with_noad
		}
	@<|bin_noad| 뒤에 올 수 있는 노드의 경우들@>
	@<수식 목록에 나타날 수 있는 노드(node)의 경우들@>
	default: confusion("mlist1")
@:this can't happen mlist1}{\quad mlist1@>
	}
	@<|nucleus(q)|를 가로 목록으로 바꾸고 첨자를 붙인다@>

@ @<마지막 |bin_noad|를...@>=
if r_type == bin_noad {
	set_type(r, ord_noad)
}

@ 다음 경우들은 처리를 마치면 |goto done_with_node|한다.

@<수식 목록에 나타날 수 있는 노드(node)의 경우들@>=
case style_node:
	cur_style = subtype(q)
	@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
	goto done_with_node
case choice_node: @<이 노드를 모양 노드와 알맞은 선택으로 바꾼다@>
case ins_node, mark_node, adjust_node, whatsit_node, penalty_node, disc_node:
	goto done_with_node
case rule_node:
	if height(q) > max_h {
		max_h = height(q)
	}
	if depth(q) > max_d {
		max_d = depth(q)
	}
	goto done_with_node
case glue_node:
	@<수식 글루를 보통 글루로 바꾼다@>
	goto done_with_node
case kern_node: math_kern(q, cur_mu); goto done_with_node

@ 선택 노드를 모양 노드로 바꾸고 현재 모양에 맞는 선택을 그 뒤에 이은 다음 |goto done_with_node|한다.

보충: 원본은 매크로 |choose_mlist(#)|를 `|p:=#(q); #(q):=null|'로 정의해서 쓴다. 여기서는 펼쳐서 쓴다.

@<이 노드를 모양 노드와...@>=
switch cur_style / 2 {
case 0: p = display_mlist(q); set_display_mlist(q, null) // |display_style=0|
case 1: p = text_mlist(q); set_text_mlist(q, null) // |text_style=2|
case 2: p = script_mlist(q); set_script_mlist(q, null) // |script_style=4|
case 3: p = script_script_mlist(q); set_script_script_mlist(q, null) // |script_script_style=6|
} // 다른 경우는 없다
flush_node_list(display_mlist(q))
flush_node_list(text_mlist(q))
flush_node_list(script_mlist(q))
flush_node_list(script_script_mlist(q))
set_type(q, style_node); set_subtype(q, cur_style); set_width(q, 0); set_depth(q, 0)
if p != null {
	z = link(q); set_link(q, p)
	for link(p) != null {
		p = link(p)
	}
	set_link(p, z)
}
goto done_with_node

@ 조건부 수식 글루(`\.{\\nonscript}')는 |zero_glue|를 가리키고 |subtype(q)=cond_math_glue|인 |glue_node|가 된다. 이 경우
현재 크기가 |text_size|와 다르면, 뒤따르는 노드가 글루나 커닝 노드일 때 그것을 없앤다. 조건 없는 수식 글루(`\.{\\muskip}')는
치수에 |cur_mu|를 곱해서 보통 글루로 바꾼다.
@!@:non_script_}{\.{\\nonscript} primitive@>

@<수식 글루를 보통 글루로...@>=
if subtype(q) == mu_glue {
	x = glue_ptr(q)
	y = math_glue(x, cur_mu); delete_glue_ref(x); set_glue_ptr(q, y)
	set_subtype(q, normal)
} else if cur_size != text_size && subtype(q) == cond_math_glue {
	p = link(q)
	if p != null && (type_(p) == glue_node || type_(p) == kern_node) {
		set_link(q, link(p)); set_link(p, null); flush_node_list(p)
	}
}

@ @<|bin_noad| 뒤에 올 수 있는 노드의 경우들@>=
case left_noad: goto done_with_noad
case fraction_noad: make_fraction(q); goto check_dimensions
case op_noad:
	delta = make_op(q)
	if subtype(q) == limits {
		goto check_dimensions
	}
case ord_noad: make_ord(q)
case open_noad, inner_noad: // 아무것도 하지 않는다
case radical_noad: make_radical(q)
case over_noad: make_over(q)
case under_noad: make_under(q)
case accent_noad: make_math_accent(q)
case vcenter_noad: make_vcenter(q)

@ 프로시저 |mlist_to_hlist|의 실제 조립 작업은 대부분 |make_fraction|, |make_radical| 따위의 이름을 가진 프로시저들이 한다. 그런
프로시저들의 일반적인 짜임새를 보여 주려고 간단한 것 두어 개부터 시작하자.

@<수식 구성 프로시저들@>=
func make_over(q pointer) {
	set_info(nucleus(q),
		overbar(clean_box(nucleus(q), cramped_style(cur_style)),
			3*default_rule_thickness(), default_rule_thickness()))
	set_math_type(nucleus(q), sub_box)
}

@ @<수식 구성 프로시저들@>=
func make_under(q pointer) {
	var p, x, y pointer // 상자를 만드는 임시 레지스터들
	var delta scaled // 전체 높이와 깊이의 합
	x = clean_box(nucleus(q), cur_style)
	p = new_kern(3 * default_rule_thickness()); set_link(x, p)
	set_link(p, fraction_rule(default_rule_thickness()))
	y = vpack(x, natural, additional)
	delta = height(y) + depth(y) + default_rule_thickness()
	set_height(y, height(x)); set_depth(y, delta-height(y))
	set_info(nucleus(q), y); set_math_type(nucleus(q), sub_box)
}

@ @<수식 구성 프로시저들@>=
func make_vcenter(q pointer) {
	var v pointer // 세로로 가운데 맞출 상자
	var delta scaled // 그 높이와 깊이의 합
	v = info(nucleus(q))
	if type_(v) != vlist_node {
		confusion("vcenter")
	}
@:this can't happen vcenter}{\quad vcenter@>
	delta = height(v) + depth(v)
	set_height(v, axis_height(cur_size)+half(delta))
	set_depth(v, delta-height(v))
}

@ \.{DVI} 파일 명세의 규칙에 따라, 우리는 근호 기호의 기준선이 괘선의 아래 끝과 같다고 가정해서 근호 기호와 핵 위의 괘선을
@^square roots@>
가지런히 맞춘다. 근호 기호의 높이는 괘선의 두께가 되고, 근호 기호의 깊이는 핵의 높이와 깊이의 합에 어떤 최소 틈~|clr|을
더한 것 이상이어야 한다. 그 기호는 실제 틈이 |clr|에 남는 양의 절반을 더한 것이 되도록 놓인다.

@<수식 구성 프로시저들@>=
func make_radical(q pointer) {
	var x, y pointer // 상자를 만드는 임시 레지스터들
	var delta, clr scaled // 계산에 쓰는 치수들
	x = clean_box(nucleus(q), cramped_style(cur_style))
	if cur_style < text_style { // 따로 세운 모양
		clr = default_rule_thickness() + (abs(math_x_height(cur_size)) / 4)
	} else {
		clr = default_rule_thickness(); clr = clr + (abs(clr) / 4)
	}
	y = var_delimiter(left_delimiter(q), cur_size, height(x)+depth(x)+clr+
		default_rule_thickness())
	delta = depth(y) - (height(x) + depth(x) + clr)
	if delta > 0 {
		clr = clr + half(delta) // 실제 틈을 늘린다
	}
	set_shift_amount(y, -(height(x) + clr))
	set_link(y, overbar(x, clr, height(y)))
	set_info(nucleus(q), hpack(y, natural, additional)); set_math_type(nucleus(q), sub_box)
}

@ 수식 모드에서 악센트를 놓을 때는 기울기를 고려하지 않는다. 악센트는 악센트를 받는 것 위의 가운데에 놓이고, 악센트의 너비는
마지막 상자의 크기에 대해 0으로 다룬다.

@<수식 구성 프로시저들@>=
func make_math_accent(q pointer) {
	var p, x, y pointer // 상자를 만드는 임시 레지스터들
	var a int32 // 합자/커닝 명령의 주소
	var c quarterword // 악센트 문자
	var f internal_font_number // 그 글꼴
	var i four_quarters // 그 |char_info|
	var s scaled // 악센트를 오른쪽으로 비낄 양
	var h scaled // 악센트를 받는 문자의 높이
	var delta scaled // 악센트와 악센트를 받는 것 사이에서 뺄 공간
	var w scaled // 첨자를 뺀, 악센트를 받는 것의 너비
	fetch(accent_chr(q))
	if char_exists(cur_i) {
		i = cur_i; c = cur_c; f = cur_f
		@<비낌의 양을 계산한다@>
		x = clean_box(nucleus(q), cramped_style(cur_style)); w = width(x); h = height(x)
		@<알맞으면 더 큰 악센트로 바꾼다@>
		if h < x_height(f) { delta = h } else { delta = x_height(f) }
		if math_type(supscr(q)) != empty || math_type(subscr(q)) != empty {
			if math_type(nucleus(q)) == math_char {
				@<아래첨자와 위첨자를 상자 |x|로 옮긴다@>
			}
		}
		y = char_box(f, c)
		set_shift_amount(y, s+half(w-width(y)))
		set_width(y, 0); p = new_kern(-delta); set_link(p, x); set_link(y, p)
		y = vpack(y, natural, additional); set_width(y, width(x))
		if height(y) < h {
			@<상자 |y|의 높이를 |h|와 같게 한다@>
		}
		set_info(nucleus(q), y)
		set_math_type(nucleus(q), sub_box)
	}
}

@ @<상자 |y|의 높이를...@>=
p = new_kern(h - height(y)); set_link(p, list_ptr(y)); set_list_ptr(y, p)
set_height(y, h)

@ @<알맞으면 더 큰 악센트로...@>=
for {
	if char_tag(i) != list_tag {
		goto done
	}
	y = rem_byte(i)
	i = char_info(f, y)
	if !char_exists(i) {
		goto done
	}
	if char_width(f, i) > w {
		goto done
	}
	c = y
}
done:

@ @<비낌의 양을...@>=
s = 0
if math_type(nucleus(q)) == math_char {
	fetch(nucleus(q))
	if char_tag(cur_i) == lig_tag {
		a = lig_kern_start(cur_f, cur_i)
		cur_i = font_info[a].qqqq
		if skip_byte(cur_i) > stop_flag {
			a = lig_kern_restart(cur_f, cur_i)
			cur_i = font_info[a].qqqq
		}
		for {
			if qo(next_char(cur_i)) == skew_char[cur_f] {
				if op_byte(cur_i) >= kern_flag && skip_byte(cur_i) <= stop_flag {
					s = char_kern(cur_f, cur_i)
				}
				goto done1
			}
			if skip_byte(cur_i) >= stop_flag {
				goto done1
			}
			a = a + qo(skip_byte(cur_i)) + 1
			cur_i = font_info[a].qqqq
		}
	}
}
done1:

@ @<아래첨자와 위첨자를 상자 |x|로...@>=
flush_node_list(x); x = new_noad()
mem[nucleus(x)] = mem[nucleus(q)]
mem[supscr(x)] = mem[supscr(q)]
mem[subscr(x)] = mem[subscr(q)]
mem[supscr(q)].hh = empty_field
mem[subscr(q)].hh = empty_field
set_math_type(nucleus(q), sub_mlist); set_info(nucleus(q), x)
x = clean_box(nucleus(q), cur_style); delta = delta + height(x) - h; h = height(x)

@ 프로시저 |make_fraction|은 조금 다르다. 하위 상자를 만드는 대신 |new_hlist(q)|를 바로 정하기 때문이다.

@<수식 구성 프로시저들@>=
func make_fraction(q pointer) {
	var p, v, x, y, z pointer // 상자를 만드는 임시 레지스터들
	var delta, delta1, delta2, shift_up, shift_down, clr scaled // 상자 계산에 쓰는 치수들
	if thickness(q) == default_code {
		set_thickness(q, default_rule_thickness())
	}
	@<분자와 분모를 너비가 같은 상자 |x|와 |z|에 넣는다@>
	if thickness(q) == 0 {
		@<분수 괘선이 없을 때 |shift_up|과 |shift_down|을 맞춘다@>
	} else {
		@<분수 괘선이 있을 때 |shift_up|과 |shift_down|을 맞춘다@>
	}
	@<|shift_up|과 |shift_down|에 따라 분수의 세로 목록 상자를 만든다@>
	@<분수를 구분자와 함께 상자에 넣고 |new_hlist(q)|가 가리키게 한다@>
}

@ 분자와 분모를 너비가 같은 상자 |x|와 |z|에 넣고, 기준선에서 이들을 옮길 기본 양 |shift_up|과 |shift_down|을 계산한다.

@<분자와 분모를 너비가...@>=
x = clean_box(numerator(q), num_style(cur_style))
z = clean_box(denominator(q), denom_style(cur_style))
if width(x) < width(z) {
	x = rebox(x, width(z))
} else {
	z = rebox(z, width(x))
}
if cur_style < text_style { // 따로 세운 모양
	shift_up = num1(cur_size); shift_down = denom1(cur_size)
} else {
	shift_down = denom2(cur_size)
	if thickness(q) != 0 {
		shift_up = num2(cur_size)
	} else {
		shift_up = num3(cur_size)
	}
}

@ 분자와 분모는 어떤 최소 틈만큼 떨어져 있어야 한다. 다음 프로그램에서 이것을 |clr|이라고 부른다. 이 값과 실제 틈의 차이는
|delta|의 두 배다.

@<분수 괘선이 없을 때...@>=
if cur_style < text_style {
	clr = 7 * default_rule_thickness()
} else {
	clr = 3 * default_rule_thickness()
}
delta = half(clr - ((shift_up - depth(x)) - (height(z) - shift_down)))
if delta > 0 {
	shift_up = shift_up + delta
	shift_down = shift_down + delta
}

@ 분수 괘선이 있을 때 최소 틈은 괘선의 실제 두께에 따라 달라진다.

@<분수 괘선이 있을 때...@>=
if cur_style < text_style {
	clr = 3 * thickness(q)
} else {
	clr = thickness(q)
}
delta = half(thickness(q))
delta1 = clr - ((shift_up - depth(x)) - (axis_height(cur_size) + delta))
delta2 = clr - ((axis_height(cur_size) - delta) - (height(z) - shift_down))
if delta1 > 0 {
	shift_up = shift_up + delta1
}
if delta2 > 0 {
	shift_down = shift_down + delta2
}

@ @<|shift_up|과 |shift_down|에 따라 분수의...@>=
v = new_null_box(); set_type(v, vlist_node)
set_height(v, shift_up+height(x)); set_depth(v, depth(z)+shift_down)
set_width(v, width(x)) // 이것은 |width(z)|와도 같다
if thickness(q) == 0 {
	p = new_kern((shift_up - depth(x)) - (height(z) - shift_down))
	set_link(p, z)
} else {
	y = fraction_rule(thickness(q))
	p = new_kern((axis_height(cur_size) - delta) - (height(z) - shift_down))
	set_link(y, p); set_link(p, z)
	p = new_kern((shift_up - depth(x)) - (axis_height(cur_size) + delta))
	set_link(p, y)
}
set_link(x, p); set_list_ptr(v, x)

@ @<분수를 구분자와 함께...@>=
if cur_style < text_style {
	delta = delim1(cur_size)
} else {
	delta = delim2(cur_size)
}
x = var_delimiter(left_delimiter(q), cur_size, delta); set_link(x, v)
z = var_delimiter(right_delimiter(q), cur_size, delta); set_link(v, z)
set_new_hlist(q, hpack(x, natural, additional))

@ 노드 |op_noad|의 핵이 문자 하나이면, 따로 세운 모양일 때는 먼저 (글꼴의 문자 목록을 따라) 키운 다음, 축에 대해 세로로 가운데에
놓는다. 따로 세운 모양에서는 극한을 연산자의 위와 아래에 놓는 것이 보통 관례다.

아래첨자가 있고 극한을 위아래에 놓지 않으면 문자에서 기울임 보정을 뺀다. 루틴 |make_op|는 아래첨자와 위첨자 사이의 어긋남으로
쓸 값을 돌려준다.

루틴 |make_op|가 일을 마치면, 극한을 연산자의 위와 아래에 놓았을 때, 그리고 오직 그때에만 |subtype(q)|가 |limits|다. 그
경우에는 |new_hlist(q)|에 원하는 마지막 상자가 이미 들어 있다.

@<수식 구성 프로시저들@>=
func make_op(q pointer) scaled {
	var delta scaled // 아래첨자와 위첨자 사이의 어긋남
	var p, v, x, y, z pointer // 상자를 만드는 임시 레지스터들
	var c quarterword; var i four_quarters // 문자를 살피는 레지스터들
	var shift_up, shift_down scaled // 상자 계산에 쓰는 치수들
	if subtype(q) == normal && cur_style < text_style {
		set_subtype(q, limits)
	}
	if math_type(nucleus(q)) == math_char {
		fetch(nucleus(q))
		if cur_style < text_style && char_tag(cur_i) == list_tag { // 키운다
			c = rem_byte(cur_i); i = char_info(cur_f, c)
			if char_exists(i) {
				cur_c = c; cur_i = i; set_character(nucleus(q), c)
			}
		}
		delta = char_italic(cur_f, cur_i); x = clean_box(nucleus(q), cur_style)
		if math_type(subscr(q)) != empty && subtype(q) != limits {
			set_width(x, width(x)-delta) // 기울임 보정을 뺀다
		}
		set_shift_amount(x, half(height(x)-depth(x))-axis_height(cur_size)) // 세로로 가운데 맞춘다
		set_math_type(nucleus(q), sub_box); set_info(nucleus(q), x)
	} else {
		delta = 0
	}
	if subtype(q) == limits {
		@<위아래에 극한이 붙고 |delta|만큼 비낀 상자를 만든다@>
	}
	return delta
}

@ 다음 프로그램은 따로 세운 극한을 위한 세로 목록 상자 |v|를 만든다. 극한이 비껴 있어도 상자의 너비는 영향을 받지 않는다.

@<위아래에 극한이 붙고...@>=
x = clean_box(supscr(q), sup_style(cur_style))
y = clean_box(nucleus(q), cur_style)
z = clean_box(subscr(q), sub_style(cur_style))
v = new_null_box(); set_type(v, vlist_node); set_width(v, width(y))
if width(x) > width(v) {
	set_width(v, width(x))
}
if width(z) > width(v) {
	set_width(v, width(z))
}
x = rebox(x, width(v)); y = rebox(y, width(v)); z = rebox(z, width(v))
set_shift_amount(x, half(delta)); set_shift_amount(z, -shift_amount(x))
set_height(v, height(y)); set_depth(v, depth(y))
@<극한을 |y|에 붙이고 |height(v)|와 |depth(v)|를 맞춘다@>
set_new_hlist(q, v)

@ 다음 프로그램에서 |shift_up|과 |shift_down|은 따로 세운 연산자 |y|와 그 극한 |x|와 |z| 사이의 글루의 양으로 쓴다. 상자 |v|
안의 세로 목록은 |x| 다음에 |y|, 그 다음에 |z|로 이루어지고, 그 사이와 둘레의 공간을 위한 커닝 노드가 들어간다.

@<극한을 |y|에 붙이고...@>=
if math_type(supscr(q)) == empty {
	free_node(x, box_node_size); set_list_ptr(v, y)
} else {
	shift_up = big_op_spacing3() - depth(x)
	if shift_up < big_op_spacing1() {
		shift_up = big_op_spacing1()
	}
	p = new_kern(shift_up); set_link(p, y); set_link(x, p)
	p = new_kern(big_op_spacing5()); set_link(p, x); set_list_ptr(v, p)
	set_height(v, height(v)+big_op_spacing5()+height(x)+depth(x)+shift_up)
}
if math_type(subscr(q)) == empty {
	free_node(z, box_node_size)
} else {
	shift_down = big_op_spacing4() - height(z)
	if shift_down < big_op_spacing2() {
		shift_down = big_op_spacing2()
	}
	p = new_kern(shift_down); set_link(y, p); set_link(p, z)
	p = new_kern(big_op_spacing5()); set_link(z, p)
	set_depth(v, depth(v)+big_op_spacing5()+height(z)+depth(z)+shift_down)
}

@ 수식에서 찾은 합자는 |ligature_node|를 만들지 않는다. 나중에 하이픈 넣기를 할 일이 없기 때문이다. 합자는 |ord_noad|에 머물러
있다가 그냥 보통 |char_node|에 저장된다.

현재 문자가 수식 글꼴(곧 |space=0|인 글꼴)에 속할 때에만 기울임 보정을 하고 싶은 경우에는, 여기서 |math_type|을
|math_text_char|로 바꾼다.

이런 합자에는 경계 문자가 끼어들지 않는다.

@<수식 구성 프로시저들@>=
func make_ord(q pointer) {
	var a int32 // 합자/커닝 명령의 주소
	var p, r pointer // 목록을 다루는 임시 레지스터들
restart:
	if math_type(subscr(q)) == empty && math_type(supscr(q)) == empty &&
		math_type(nucleus(q)) == math_char {
		p = link(q)
		if p != null && type_(p) >= ord_noad && type_(p) <= punct_noad &&
			math_type(nucleus(p)) == math_char && fam(nucleus(p)) == fam(nucleus(q)) {
			set_math_type(nucleus(q), math_text_char)
			fetch(nucleus(q))
			if char_tag(cur_i) == lig_tag {
				a = lig_kern_start(cur_f, cur_i)
				cur_c = character(nucleus(p))
				cur_i = font_info[a].qqqq
				if skip_byte(cur_i) > stop_flag {
					a = lig_kern_restart(cur_f, cur_i)
					cur_i = font_info[a].qqqq
				}
				for {
					@<|cur_i|가 |cur_c|와의 커닝이나 합자이면 |q|와 |p|를 처리한다@>
					if skip_byte(cur_i) >= stop_flag {
						return
					}
					a = a + qo(skip_byte(cur_i)) + 1
					cur_i = font_info[a].qqqq
				}
			}
		}
	}
}

@ 노드 |ord_noad|와 다른 종류의 노드 사이의 합자는 두 노드가 하나로 합쳐질 때 |ord_noad|로 바뀐다는 것에 주의하라. 그러나 이를테면
괄호가 어떤 글자 뒤에 올 때 모양이 바뀌게 할 수도 있다. 아마 글꼴 디자이너는 이 관례가 말이 될 때에만 그런 합자를 정의할
것이다.

명령 |cur_i|가 |cur_c|와의 커닝이면 그 커닝을 |q| 뒤에 붙이고, |cur_c|와의 합자이면 노드 |q|와 |p|를 알맞게 합친다. 그런
다음 커서가 노드를 지나쳐 움직였으면 |return|하고, 그렇지 않으면 |goto restart|한다.

\chardef\?='174 % 문자를 남김을 나타내는 세로 막대

@<|cur_i|가 |cur_c|와의...@>=
if next_char(cur_i) == cur_c && skip_byte(cur_i) <= stop_flag {
	if op_byte(cur_i) >= kern_flag {
		p = new_kern(char_kern(cur_f, cur_i))
		set_link(p, link(q)); set_link(q, p); return
	} else {
		check_interrupt() // 끝없는 합자 루프에서 빠져나갈 길을 둔다
		switch op_byte(cur_i) {
		case qi(1), qi(5): set_character(nucleus(q), rem_byte(cur_i)) // \.{=:\?}, \.{=:\?>}
		case qi(2), qi(6): set_character(nucleus(p), rem_byte(cur_i)) // \.{\?=:}, \.{\?=:>}
		case qi(3), qi(7), qi(11): @<새 노드 |r|을 |q|와 |p| 사이에 넣는다@>
		default:
			set_link(q, link(p))
			set_character(nucleus(q), rem_byte(cur_i)) // \.{=:}
			mem[subscr(q)] = mem[subscr(p)]; mem[supscr(q)] = mem[supscr(p)]
			free_node(p, noad_size)
		}
		if op_byte(cur_i) > qi(3) {
			return
		}
		set_math_type(nucleus(q), math_char); goto restart
	}
}

@ \dg 앞 절의 합자 가운데 \.{\?=:\?}, \.{\?=:\?>}, \.{\?=:\?>>}를 처리한다. 이때는 두 문자를 모두 남기고 그 사이에 새
문자를 넣는다.

@<새 노드 |r|을...@>=
r = new_noad()
set_character(nucleus(r), rem_byte(cur_i))
set_fam(nucleus(r), fam(nucleus(q)))
set_link(q, r); set_link(r, p)
if op_byte(cur_i) < qi(11) {
	set_math_type(nucleus(r), math_char)
} else {
	set_math_type(nucleus(r), math_text_char) // 결합을 막는다
}

@ 다음 부분에 이르렀을 때는 |check_dimensions|나 |done_with_noad|나 |done_with_node|로 가지 않은 경우들에서 ``흘러 내려온''
것이다. 그래서 |q|~는 핵을 가로 목록으로 바꾸어야 할 수도 있고, 아래첨자와 위첨자가 있으면 그것들을 덧붙여야 하는 노드를
가리킨다.

핵 |nucleus(q)|가 |math_char|가 아니면, 변수 |delta|는 둘 다 있을 때 위첨자를 아래첨자에 대해 오른쪽으로 옮길 양이다.
@^subscripts@>
@^superscripts@>

@<|nucleus(q)|를 가로 목록으로...@>=
switch math_type(nucleus(q)) {
case math_char, math_text_char:
	@<|nucleus(q)|의 문자 노드 |p|를 만든다@>
case empty: p = null
case sub_box: p = info(nucleus(q))
case sub_mlist:
	cur_mlist = info(nucleus(q)); save_style = cur_style
	mlist_penalties = false; mlist_to_hlist() // 재귀 호출
@^recursion@>
	cur_style = save_style; @<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
	p = hpack(link(temp_head), natural, additional)
default: confusion("mlist2")
@:this can't happen mlist2}{\quad mlist2@>
}
set_new_hlist(q, p)
if math_type(subscr(q)) == empty && math_type(supscr(q)) == empty {
	goto check_dimensions
}
make_scripts(q, delta)

@ 핵 |nucleus(q)|의 문자 노드 |p|를 만드는데, 기울임 보정을 위한 커닝 노드가 그 뒤에 올 수도 있다. 아래첨자가 있으면 |delta|를
기울임 보정으로 정한다.

@<|nucleus(q)|의 문자 노드...@>=
fetch(nucleus(q))
if char_exists(cur_i) {
	delta = char_italic(cur_f, cur_i); p = new_character(cur_f, qo(cur_c))
	if math_type(nucleus(q)) == math_text_char && space(cur_f) != 0 {
		delta = 0 // 본문 글꼴의 낱말 가운데에서는 기울임 보정을 하지 않는다
	}
	if math_type(subscr(q)) == empty && delta != 0 {
		set_link(p, new_kern(delta)); delta = 0
	}
} else {
	p = null
}

@ 프로시저 |make_scripts(q,delta)|의 목적은, 노드 |q|의 아래첨자와 위첨자가 둘 다 비어 있지는 않을 때, 그것들을 |new_hlist(q)|에서
시작하는 목록에 덧붙이는 것이다. 위첨자는 아래첨자보다 주어진 거리 |delta|만큼 오른쪽에 나타난다.

변수 |shift_down|과 |shift_up|은 주어진 핵에 따라 아래첨자와 위첨자의 기준선을 옮길 최소량으로 정한다.

@<수식 구성 프로시저들@>=
func make_scripts(q pointer, delta scaled) {
	var p, x, y, z pointer // 상자를 만드는 임시 레지스터들
	var shift_up, shift_down, clr scaled // 계산에 쓰는 치수들
	var t small_number // 하위 크기 코드
	p = new_hlist(q)
	if is_char_node(p) {
		shift_up = 0; shift_down = 0
	} else {
		z = hpack(p, natural, additional)
		if cur_style < script_style { t = script_size } else { t = script_script_size }
		shift_up = height(z) - sup_drop(t)
		shift_down = depth(z) + sub_drop(t)
		free_node(z, box_node_size)
	}
	if math_type(supscr(q)) == empty {
		@<위첨자가 없을 때 아래첨자 상자 |x|를 만든다@>
	} else {
		@<위첨자 상자 |x|를 만든다@>
		if math_type(subscr(q)) == empty {
			set_shift_amount(x, -shift_up)
		} else {
			@<위첨자를 |delta|만큼 비낀 첨자 조합 상자 |x|를 만든다@>
		}
	}
	if new_hlist(q) == null {
		set_new_hlist(q, x)
	} else {
		p = new_hlist(q)
		for link(p) != null {
			p = link(p)
		}
		set_link(p, x)
	}
}

@ 위첨자 없이 아래첨자가 있으면, 아래첨자의 위 끝이 기준선에 x 높이의 5분의 4를 더한 것을 넘어서는 안 된다.

@<위첨자가 없을 때...@>=
x = clean_box(subscr(q), sub_style(cur_style))
set_width(x, width(x)+script_space())
if shift_down < sub1(cur_size) {
	shift_down = sub1(cur_size)
}
clr = height(x) - (abs(math_x_height(cur_size)*4) / 5)
if shift_down < clr {
	shift_down = clr
}
set_shift_amount(x, shift_down)

@ 위첨자의 아래 끝은 결코 기준선에 x 높이의 4분의 1을 더한 것보다 내려가서는 안 된다.

@<위첨자 상자 |x|를...@>=
x = clean_box(supscr(q), sup_style(cur_style))
set_width(x, width(x)+script_space())
if odd(cur_style) {
	clr = sup3(cur_size)
} else if cur_style < text_style {
	clr = sup1(cur_size)
} else {
	clr = sup2(cur_size)
}
if shift_up < clr {
	shift_up = clr
}
clr = depth(x) + (abs(math_x_height(cur_size)) / 4)
if shift_up < clr {
	shift_up = clr
}

@ 아래첨자와 위첨자가 둘 다 있으면, 아래첨자는 위첨자와 적어도 |default_rule_thickness|의 네 배만큼 떨어져 있어야 한다.
이 조건이 깨질 것 같으면 아래첨자를 내리고, 그 다음 위첨자의 아래 끝이 적어도 기준선에 x 높이의 5분의 4를 더한 높이가
되도록 아래첨자와 위첨자를 함께 올린다.

@<위첨자를 |delta|만큼...@>=
y = clean_box(subscr(q), sub_style(cur_style))
set_width(y, width(y)+script_space())
if shift_down < sub2(cur_size) {
	shift_down = sub2(cur_size)
}
clr = 4*default_rule_thickness() - ((shift_up - depth(x)) - (height(y) - shift_down))
if clr > 0 {
	shift_down = shift_down + clr
	clr = (abs(math_x_height(cur_size)*4) / 5) - (shift_up - depth(x))
	if clr > 0 {
		shift_up = shift_up + clr
		shift_down = shift_down - clr
	}
}
set_shift_amount(x, delta) // 위첨자는 아래첨자보다 |delta|만큼 오른쪽에 있다
p = new_kern((shift_up - depth(x)) - (height(y) - shift_down)); set_link(x, p); set_link(p, y)
x = vpack(x, natural, additional); set_shift_amount(x, shift_down)

@ 이제 |mlist_to_hlist|의 첫째 훑기에서 남은 일을 모두 마무리했다. 둘째 훑기는 그저 목록을 지나가며 알맞은 글루와 벌점으로
모든 것을 이어 붙인다. 이제 |max_h|와 |max_d|를 알므로, 있을 수 있는 |left_noad|와 |right_noad|도 처리한다. 변수 |p|는 마지막
가로 목록의 현재 끝에 있는 노드를 가리킨다.

@<수식 목록을 다시 훑어...@>=
p = temp_head; set_link(p, null); q = mlist; r_type = 0; cur_style = style
@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
for q != null {
	@<노드 |q|의 종류에 따라 |t|와 |s|와 |pen|을 정한다@>
	@<|r_type|과 |t|에 따라 원소 사이 간격을 덧붙인다@>
	@<|q|의 |new_hlist| 항목과 알맞은 벌점을 덧붙인다@>
	r_type = t
delete_q:
	r = q; q = link(q); free_node(r, s)
done: ;
}

@ 둘째 훑기에서 큰 |case| 갈래로 들어가기 바로 앞에서, 프로그램은 기본값을 정해 두어 갈래 대부분이 짧아지게 한다.

노드 |q|가 모양 노드이면 모양을 바꾸고 |goto delete_q|한다. 노드(noad)가 아니면 가로 목록에 넣고 |q|를 다음으로 옮긴 다음
|goto done|한다. 그렇지 않으면 |s|를 노드 |q|의 크기로, |t|를 그에 딸린 형(|ord_noad..inner_noad|)으로, |pen|을 그에 딸린
벌점으로 정한다.

@<노드 |q|의 종류에 따라...@>=
t = ord_noad; s = noad_size; pen = inf_penalty
switch type_(q) {
case op_noad, open_noad, close_noad, punct_noad, inner_noad: t = type_(q)
case bin_noad: t = bin_noad; pen = bin_op_penalty()
case rel_noad: t = rel_noad; pen = rel_penalty()
case ord_noad, vcenter_noad, over_noad, under_noad: // 아무것도 하지 않는다
case radical_noad: s = radical_noad_size
case accent_noad: s = accent_noad_size
case fraction_noad: s = fraction_noad_size
case left_noad, right_noad: t = make_left_right(q, style, max_d, max_h)
case style_node: @<현재 모양을 바꾸고 |goto delete_q|한다@>
case whatsit_node, penalty_node, rule_node, disc_node, adjust_node, ins_node, mark_node,
	glue_node, kern_node:
	set_link(p, q); p = q; q = link(q); set_link(p, null); goto done
default: confusion("mlist3")
@:this can't happen mlist3}{\quad mlist3@>
}

@ 함수 |make_left_right|는 필요한 크기의 왼쪽이나 오른쪽 구분자를 만들고 |open_noad|나 |close_noad|를 돌려준다. 노드 |right_noad|와
|left_noad|는 둘 다 원래의 |style|에 바탕을 두므로 크기가 서로 어울린다.

여기서는 |right_noad-left_noad=close_noad-open_noad|라는 사실을 이용한다.

@<수식 구성 프로시저들@>=
func make_left_right(q pointer, style small_number, max_d, max_h scaled) small_number {
	var delta, delta1, delta2 scaled // 계산에 쓰는 치수들
	if style < script_style {
		cur_size = text_size
	} else {
		cur_size = 16 * ((style - text_style) / 2)
	}
	delta2 = max_d + axis_height(cur_size)
	delta1 = max_h + max_d - delta2
	if delta2 > delta1 {
		delta1 = delta2 // |delta1|은 축으로부터의 최대 거리다
	}
	delta = (delta1 / 500) * delimiter_factor()
	delta2 = delta1 + delta1 - delimiter_shortfall()
	if delta < delta2 {
		delta = delta2
	}
	set_new_hlist(q, var_delimiter(delimiter(q), cur_size, delta))
	return type_(q) - (left_noad - open_noad) // |open_noad|나 |close_noad|
}

@ @<현재 모양을 바꾸고...@>=
cur_style = subtype(q); s = style_node_size
@<|cur_style|에 따라 |cur_size|와 |cur_mu|의 값을 정한다@>
goto delete_q

@ 수식의 원소 사이 간격은 \TeX이 64자리 문자열로 미리 불러 두는 $8\times8$ 표에 따라 정해진다. 이 문자열의 원소는 다음과 같은
뜻을 가진다.
$$\vbox{\halign{#\hfil\cr
\.0은 공백이 없다는 뜻이다.\cr
\.1은 조건부 가는 공백(\.{\\nonscript\\mskip\\thinmuskip})이라는 뜻이다.\cr
\.2는 가는 공백(\.{\\mskip\\thinmuskip})이라는 뜻이다.\cr
\.3은 조건부 중간 공백(\.{\\nonscript\\mskip\\medmuskip})이라는 뜻이다.\cr
\.4는 조건부 굵은 공백(\.{\\nonscript\\mskip\\thickmuskip})이라는 뜻이다.\cr
\.*는 있을 수 없는 경우라는 뜻이다.\cr}}$$
이것은 꽤 알쏭달쏭하지만, {\sl The \TeX book}이 무슨 일이 일어나야 하는지 설명하고, 이 문자열이 그 일을 일으킨다.
@:TeXbook}{\sl The \TeX book@>

전역 변수 |magic_offset|은 |a|와 |b|가 |ord_noad..inner_noad| 범위에 있을 때 |str_pool[a*8+b+magic_offset]|이 노드 형 |a|와
|b| 사이의 간격을 나타내는 숫자가 되도록 계산한다.

\PASCAL이 상수 배열을 미리 불러 둘 좋은 방법을 주었더라면 프로그램의 이 부분이 이렇게 이상하지는 않았을 것이다.
@:PASCAL}{\PASCAL@>

보충: 이 번역에서도 원본처럼 문자열 풀에 넣어 둔 문자열을 쓴다. \GO/라면 상수 문자열을 바로 첨자로 쓸 수 있지만, 원본의 짜임새를
따른다.

@<전역 변수@>=
const @!math_spacing = "0234000122*4000133**3**344*0400400*000000234000111*1111112341011"

var @!magic_offset int32 // 원소 사이 간격을 찾는 데 쓴다

@ @<마법의 오프셋을 계산한다@>=
magic_offset = str_start[str(math_spacing)] - 9*ord_noad

@ @<|r_type|과 |t|에 따라 원소 사이...@>=
if r_type > 0 { // 첫 노드가 아니다
	switch so(str_pool[r_type*8+t+magic_offset]) {
	case '0': x = 0
	case '1': if cur_style < script_style { x = thin_mu_skip_code } else { x = 0 }
	case '2': x = thin_mu_skip_code
	case '3': if cur_style < script_style { x = med_mu_skip_code } else { x = 0 }
	case '4': if cur_style < script_style { x = thick_mu_skip_code } else { x = 0 }
	default: confusion("mlist4")
@:this can't happen mlist4}{\quad mlist4@>
	}
	if x != 0 {
		y = math_glue(glue_par(x), cur_mu)
		z = new_glue(y); set_glue_ref_count(y, null); set_link(p, z); p = z
		set_subtype(z, x+1) // 기호적인 |subtype|을 저장한다
	}
}

@ 노드 |q|의 가로 목록 항목 뒤에는, |pen|이 ``무한'' 벌점이 아니고, |q| 바로 뒤의 노드가 벌점 노드도 |rel_noad|도 아니고
아예 없지도 않으면, 벌점 노드를 넣는다.

@<|q|의 |new_hlist| 항목과...@>=
if new_hlist(q) != null {
	set_link(p, new_hlist(q))
	for {
		p = link(p)
		if link(p) == null {
			break
		}
	}
}
if penalties && link(q) != null && pen < inf_penalty {
	r_type = type_(link(q))
	if r_type != penalty_node && r_type != rel_noad {
		z = new_penalty(pen); set_link(p, z); p = z
	}
}

@* 정렬.
원시 명령 \.{\\halign}과 \.{\\valign}이 작동한다면 그것은 일종의 기적이다. 이것들은 \TeX의 아주 많은 제어 구조를 가로지르기
때문이다.

그러니 지금 이 쪽은 초보자가 이 프로그램을 읽기 시작하기에 가장 좋은 곳은 아닐 것이다. 다른 것을 모두 먼저 익히는 편이
낫다.

정렬의 기적이 어떻게 일어나는지 감을 잡으려고, 입력이 어떤 모양일 수 있는지 한 보기에 생각을 모아 보자. 이 보기는 쓸모
있는 일은 하지 않지만, 다루어야 할 특수한 경우를 모두 보여 줄 만큼 일반적이다. 겉보기에 복잡하고 뜻이 없다고 해서
당황하지 말기 바란다.
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
(0) `\.{\\halign to 300pt\{}'를 훑으면 루틴 |scan_spec|이 300pt라는 치수를 |save_stack|에 넣고, 그 위에 |align_group|
코드를 넣는다. 이렇게 해 두면 짝이 맞는 `\.\}'를 찾았을 때 정렬을 마무리할 수 있다.

(1) 다음으로 서문을 훑는다. 서문의 매크로는, tabskip 지정의 일부가 아니면 펼치지 않는다. 이를테면 위의 서문에서 \.{u2}가
@^preamble@>
매크로였다면 펼쳐졌을 것이다. \TeX이 tabskip 글루의 일부로 `\.{minus...}'를 찾아보아야 하기 때문이다. 사용자의 서문에
바탕을 두고 ``서문 목록''을 만든다. 우리 보기에서 이 목록은 다음 일곱 항목을 담는다.
$$\vbox{\halign{\.{#}\hfil\qquad&(#)\hfil\cr
{}\\glue 2pt plus 3pt&1열 앞의 tabskip\cr
{}\\alignrecord, width $-\infty$&1열의 서문 정보\cr
{}\\glue 2pt plus 3pt&1열과 2열 사이의 tabskip\cr
{}\\alignrecord, width $-\infty$&2열의 서문 정보\cr
{}\\glue 1pt plus 1fil&2열과 3열 사이의 tabskip\cr
{}\\alignrecord, width $-\infty$&3열의 서문 정보\cr
{}\\glue 1pt plus 1fil&3열 뒤의 tabskip\cr}}$$
이 ``alignrecord''(정렬 기록) 항목들은 |unset_node|와 크기가 같다. 나중에 그런 노드로 바뀌기 때문이다. 그러나 지금은
|type|이나 |subtype| 필드가 없다. 대신 |info| 필드가 있고, 아래에서 설명할 까닭으로 이 |info| 필드의 처음 값은 |end_span|이다.
게다가 정렬 기록 노드에는 |height|나 |depth| 필드가 없다. 이것들은 |u_part|와 |v_part|로 이름이 바뀌고, 정렬의 틀을 나타내는
토큰 목록을 가리킨다. 이를테면 첫 정렬 기록의 |u_part| 필드는 토큰 목록 `\.{u1}', 곧 1열의 `\.\#' 앞에 있는 틀을 가리킨다.

(2) 이제 \TeX은 서문을 끝낸 \.{\\cr} 뒤에 무엇이 오는지 본다. `\.{\\noalign}'도 `\.{\\omit}'도 아니므로, 이 입력은 다시
읽도록 되돌려지고, 틀 `\.{u1}'이 훑개에 공급된다. 이 틀을 읽기 바로 전에 \TeX은 제한된 가로 모드로 들어간다. 그리고
이것을 읽은 바로 뒤에 \TeX은 `\.{a1}'을 보고, 그 다음 ({\.\&}를 감지하면) `\.{v1}'을 본다. 그런 다음 \TeX은 열의 끝을 나타내는
|endv| 토큰을 훑는다. 이 시점에서 현재 가로 목록의 내용(곧 `\.{u1a1v1}')을 담은 |unset_node|가 만들어진다. 이 미정
노드의 자연 너비가 1열의 정렬 기록의 |width| 필드를 대신한다. 일반적으로 정렬 기록은 주어진 열에서 지금까지 나온 최대
자연 너비를 기록한다.

(3) `\.\&' 뒤에 `\.{\\omit}'이 오므로 이제 2열의 틀은 건너뛴다. \TeX은 다시 제한된 가로 모드로 들어가서, 그 결과 가로
목록으로 |unset_node|를 만든다. 그러나 이번에는 가로 목록에 그저 `\.{a2}'만 들어 있다. 새 미정 상자의 자연 너비는 2열의
정렬 기록의 |width| 필드에 기억된다.

(4) 세 번째 |unset_node|가 3열을 위해 만들어지는데, 1열에서 작동한 것과 본질적으로 같은 방식을 쓴다. 이 미정 상자는
`\.{u3\\vrule v3}'을 담는다. 이 경우 세로 괘선은 흐르는 치수를 가지고, 나중에 첫 행 전체의 높이와 깊이까지 늘어난다. 한
행의 각 |unset_node|는 결국 자신을 둘러싼 상자의 높이와 깊이를 물려받기 때문이다.

(5) 이제 첫 행이 끝났다. 이것은 다음 일곱 항목으로 이루어진 미정 상자 하나가 된다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: u1a1v1\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: a2\cr
{}\\glue 1pt plus 1fil\cr
{}\\unsetbox for 1 column: u3\\vrule v3\cr
{}\\glue 1pt plus 1fil\cr}}$$
이 미정 행의 너비는 중요하지 않지만, 높이와 깊이는 올바르다. 그래서 이 행을 세로 목록에 넣을 때 올바른 baselineskip
글루가 계산된다.

(6) 현재 \.{\\cr} 뒤에 `\.{\\noalign}'이 오므로, \TeX은 추가 내용(이 경우 \.{\\vskip 3pt})을 세로 목록에 덧붙인다. 이 내용을
처리하는 동안 \TeX은 내부 세로 모드에 있고, |save_stack|에는 |no_align_group|이 있다.

(7) 다음 행은 이런 모양의 미정 상자를 낳는다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 2 columns: u1b1v1u2b2v2\cr
{}\\glue 1pt plus 1fil\cr
{}\\unsetbox for 1 column: {\rm(empty)}\cr
{}\\glue 1pt plus 1fil\cr}}$$
1열과 2열에 걸친 미정 상자의 자연 너비는 ``걸침 노드''(span node)에 저장되는데, 이것은 나중에 설명한다. 1열의 정렬 기록의
|info| 필드는 이제 새 걸침 노드를 가리키고, 걸침 노드의 |info|는 |end_span|을 가리킨다.

(8) 마지막 행은 다음 미정 상자를 낳는다.
$$\vbox{\halign{\hbox to 325pt{\qquad\.{#}\hfil}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 1 column: {\rm(empty)}\cr
{}\\glue 2pt plus 3pt\cr
{}\\unsetbox for 2 columns: u2c2v2\cr
{}\\glue 1pt plus 1fil\cr}}$$
2열의 정렬 기록에 새 걸침 노드가 붙는다.

(9) 마지막 단계는 참된 열 너비를 계산하고, 미정 상자를 모두 가로 상자로 바꾸고, 그 전부를 \.{\\halign}을 둘러싼 세로 목록에
덧붙이는 것이다. 각 미정 열 상자의 마지막 너비를 정하는 규칙은 아래에서 설명한다.

\yskip\noindent
명령 \.{\\halign}을 처리하는 동안 우리는 두려움 없이 제어를 \TeX의 나머지 부분에 넘겨준다는 것에 주목하라. 결정적인 고비마다
정렬 루틴이 불려 나와 작은 일을 하지만, 대부분의 시간 동안 이 루틴들은 그저 뒤에 숨어 있다. 최면 후 암시 같은 것이다.

@ 정렬 기록에는 |height|나 |depth| 필드가 없다고 말했다. 그 |glue_sign|과 |glue_order|도 다른 용도로 쓰인다. 틀이 끝날 때
무엇을 할지에 관한 정보를 저장해야 하기 때문이다. 이 정보를 |extra_info| 필드라고 부른다.

@<정의@>=
func u_part(p pointer) int32 { return mem[p+height_offset].sc } // \<u_j> 토큰 목록을 가리키는 포인터
func set_u_part(p pointer, v int32) { mem[p+height_offset].sc = v }
func v_part(p pointer) int32 { return mem[p+depth_offset].sc } // \<v_j> 토큰 목록을 가리키는 포인터
func set_v_part(p pointer, v int32) { mem[p+depth_offset].sc = v }
func extra_info(p pointer) halfword { return info(p + list_offset) } // 틀을 처리하는 동안 기억할 정보
func set_extra_info(p pointer, v halfword) { set_info(p+list_offset, v) }

@ 정렬 안에 정렬이 있을 수 있으므로, 작은 스택을 써서 정렬 기록 정보에 접근한다. 각 수준에는 서문 목록의 시작을 가리키는
|preamble| 포인터, 서문 목록의 현재 위치를 가리키는 |cur_align| 포인터, 걸친 열들이 시작할 때의 |cur_align| 값을 가리키는
|cur_span| 포인터, 현재 목록을 늘일 때 다음에 베낄 정렬 기록 앞의 tabskip 글루를 가리키는 |cur_loop| 포인터, 그리고 중괄호의
중첩을 나타내서 \.{\\cr}과 \.{\\span}과 탭 표시를 제대로 가로챌 수 있게 해 주는 변수 |align_state|가 있다. 또 가로 모드에서
세로 모드로 옮겨 가는 조정 목록의 머리와 꼬리를 가리키는 포인터 |cur_head|와 |cur_tail|도 있다.

이 일곱 양의 현재 값은 전역 변수에 있다. 이것들을 밀어 내려야 할 때는 다섯 낱말짜리 노드에 저장하고, |align_ptr|가 그런
노드 가운데 맨 위의 것을 가리킨다.

@<전역 변수@>=
func preamble() pointer { return link(align_head) } // 현재 서문 목록
func set_preamble(v pointer) { set_link(align_head, v) }

const @!align_stack_node_size = 5 // 정렬 상태를 저장하는 |mem| 낱말의 수

var @!cur_align pointer // 서문 목록의 현재 위치
var @!cur_span pointer // 서문 목록에서 현재 걸친 열들의 시작
var @!cur_loop pointer // 주기적인 서문을 늘일 때 베낄 곳
var @!align_ptr pointer // 가장 최근에 밀어 내린 정렬 스택 노드
var @!cur_head, @!cur_tail pointer // 조정 목록 포인터들

@ 변수 |align_state|와 |preamble|은 다른 곳에서 초기화한다.

@<핵심 변수들의...@>=
align_ptr = null; cur_align = null; cur_span = null; cur_loop = null
cur_head = null; cur_tail = null

@ 정렬 스택은 |push_alignment|와 |pop_alignment|라는 하찮은 루틴 한 쌍이 관리한다.

@<함수들@>=
func push_alignment() {
	var p pointer // 새 정렬 스택 노드
	p = get_node(align_stack_node_size)
	set_link(p, align_ptr); set_info(p, cur_align)
	set_llink(p, preamble()); set_rlink(p, cur_span)
	mem[p+2].sc = cur_loop; mem[p+3].sc = align_state
	set_info(p+4, cur_head); set_link(p+4, cur_tail)
	align_ptr = p
	cur_head = get_avail()
}

func pop_alignment() {
	var p pointer // 맨 위의 정렬 스택 노드
	free_avail(cur_head)
	p = align_ptr
	cur_tail = link(p + 4); cur_head = info(p + 4)
	align_state = mem[p+3].sc; cur_loop = mem[p+2].sc
	cur_span = rlink(p); set_preamble(llink(p))
	cur_align = info(p); align_ptr = link(p)
	free_node(p, align_stack_node_size)
}

@ \TeX에는 정렬을 다스리는 프로시저가 여덟 있다. 그 가운데 |init_align|과 |fin_align|은 맨 처음과 맨 끝에 쓰이고, |init_row|와
|fin_row|는 각 행의 처음과 끝에 쓰인다. 또 |init_span|은 걸친 열들(열 하나뿐일 수도 있다)의 처음에 쓰이고, |init_col|과
|fin_col|은 각 열의 처음과 끝에 쓰인다. 그리고 |align_peek|은 \.{\\cr} 뒤에서 다음 항목이 \.{\\noalign}인지 보는 데 쓰인다.

이 루틴들을 완전한 \.{\\halign}의 진행 과정에서 처음 쓰이는 차례대로, 곧 |init_align|, |align_peek|, |init_row|, |init_span|,
|init_col|, |fin_col|, |fin_row|, |fin_align| 차례로 살펴보자.

@ 알맞은 모드에서 \.{\\halign}이나 \.{\\valign}을 훑으면 \TeX은 |init_align|을 부른다. 이 루틴의 임무는 모든 것을 좋게
출발시키는 것이다. 이 일은 주로 서문을 훑고 그 정보를 서문 목록에 넣는 것이다.
@^preamble@>

보충: 원본은 여기서 |align_peek|과 |normal_paragraph|를 |forward|로 선언한다. \GO/에서는 필요 없다.

@<함수들@>=
@<|get_preamble_token|이라는 프로시저를 선언한다@>@;
func init_align() {
	var save_cs_ptr pointer // 오류 메시지를 위한 |warning_index| 값
	var p pointer // 잠깐 쓰는 임시 변수
	save_cs_ptr = cur_cs // 대개 \.{\\halign}이나 \.{\\valign}
	push_alignment(); align_state = -1000000 // 새 정렬 수준에 들어간다
	@<따로 세운 수식 안의 부적절한 정렬을 검사한다@>
	push_nest() // 새 의미 수준에 들어간다
	@<현재 모드를 \.{\\halign}이면 |-vmode|로, \.{\\valign}이면 |-hmode|로 바꾼다@>
	scan_spec(align_group, false)
	@<서문을 훑어 |preamble| 목록에 기록한다@>
	new_save_level(align_group)
	if every_cr() != null {
		begin_token_list(every_cr(), every_cr_text)
	}
	align_peek() // \.{\\noalign}이나 \.{\\omit}을 찾는다
}

@ 세로 모드에서는 |prev_depth|가 이미 올바른 값을 가지고 있다. 그러나 |mmode|(따로 세운 수식 모드)에 있으면, 올바른 기준선
계산을 낳는 |prev_depth| 값을 얻으려고 둘러싼 세로 모드까지 손을 뻗는다.

@<현재 모드를...@>=
if mode == mmode {
	mode = -vmode; set_prev_depth(nest[nest_ptr-2].aux_field.sc)
} else if mode > 0 {
	mode = -mode
}

@ 명령 \.{\\halign}을 따로 세운 수식으로 쓸 때는 다른 수식 목록 조각이 없어야 한다.

@<따로 세운 수식 안의 부적절한 정렬을 검사한다@>=
if mode == mmode && (tail != head || incompleat_noad() != null) {
	print_err("Improper "); print_esc("halign"); print(" inside $$'s")
@.Improper \\halign...@>
	help3("Displays can use special alignments (like \\eqalignno)",
		"only if nothing but the alignment itself is between $$'s.",
		"So I've deleted the formulas that preceded this alignment.")
	error(); flush_math()
}

@ @<서문을 훑어...@>=
set_preamble(null); cur_align = align_head; cur_loop = null; scanner_status = aligning
warning_index = save_cs_ptr; align_state = -1000000 // 이 시점에서 |cur_cmd=left_brace|
for {
	@<현재 tabskip 글루를 서문 목록에 덧붙인다@>
	if cur_cmd == car_ret {
		goto done // \.{\\cr}이 서문을 끝낸다
	}
	@<|cur_cmd|가 |tab_mark|나 |car_ret|일 때까지 서문 텍스트를 훑는다@>
}
done:
	scanner_status = normal

@ @<현재 tabskip 글루를...@>=
set_link(cur_align, new_param_glue(tab_skip_code))
cur_align = link(cur_align)

@ 명령 코드 |cur_cmd|가 |tab_mark|나 |car_ret|일 때까지 서문 텍스트를 훑으면서 tabskip 글루의 변화를 찾아보고, 정렬 기록을 서문 목록에
덧붙인다.

@<|cur_cmd|가 |tab_mark|나...@>=
@<틀 \<u_j>를 훑어 그 토큰 목록을 |hold_head|에 둔다@>
set_link(cur_align, new_null_box()); cur_align = link(cur_align) // 새 정렬 기록
set_info(cur_align, end_span); set_width(cur_align, null_flag)
set_u_part(cur_align, link(hold_head))
@<틀 \<v_j>를 훑어 그 토큰 목록을 |hold_head|에 둔다@>
set_v_part(cur_align, link(hold_head))

@ 명령 `\.{\\span}'은 |tab_mark|를 명령 코드로, |span_code|를 명령 변경자로 해서 |eqtb|에 넣는다. 그러면 \TeX은 이것을 `\.\&' 같은
정렬 구분자와 본질적으로 같게 해석하지만, 보통 구분자와 구별해야 할 때는 다르다는 것을 알아볼 수 있다. 그리고 `\.{\\cr}'에는 특별한
|cr_code|를 주고, `\.{\\crcr}'에는 그보다 더 큰 |cr_cr_code|를 주는 것도 쓸모 있다.

틀의 끝은 \.{\\endtemplate}이라는 두 ``얼린'' 제어 시퀀스로 나타낸다. 첫째 것의 명령 코드는 |end_template|인데, 이것은
|>outer_call|이어서 오류가 있어도 쉽게 사라지지 않는다. 루틴 |get_x_token|은 첫째 것을 둘째 것으로 바꾸는데, 둘째 것의
명령 코드는 |endv|다.

@<정의@>=
const (
	@!span_code = 256 // 어떤 문자와도 다르다
	@!cr_code = 257 // |span_code|와도, 어떤 문자와도 다르다
	@!cr_cr_code = cr_code + 1 // 이것으로 \.{\\crcr}을 \.{\\cr}과 구별한다
	@!end_template_token = cs_token_flag + frozen_end_template
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("span", tab_mark, span_code)
@!@:span_}{\.{\\span} primitive@>
primitive("cr", car_ret, cr_code)
@!@:cr_}{\.{\\cr} primitive@>
set_text(frozen_cr, str("cr")); eqtb[frozen_cr] = eqtb[cur_val]
primitive("crcr", car_ret, cr_cr_code)
@!@:cr_cr_}{\.{\\crcr} primitive@>
set_text(frozen_end_template, str("endtemplate")); set_text(frozen_endv, str("endtemplate"))
@.endtemplate@>
set_eq_type(frozen_endv, endv); set_equiv(frozen_endv, null_list)
set_eq_level(frozen_endv, level_one)
eqtb[frozen_end_template] = eqtb[frozen_endv]
set_eq_type(frozen_end_template, end_template)

@ @<원시 명령의 이름을 찍는...@>=
case tab_mark:
	if chr_code == span_code {
		print_esc("span")
	} else {
		chr_cmd("alignment tab character ")
	}
case car_ret:
	if chr_code == cr_code {
		print_esc("cr")
	} else {
		print_esc("crcr")
	}

@ 서문은 그대로 베낀다. 다만 \.{\\tabskip}은 tabskip 글루를 바꾸고, 그래서 바로 뒤에 오는 매크로를 펼칠 수도 있다.
명령 \.{\\span}이 나타나도 그런 펼침이 일어난다.

서문에 `\.{\\global\\tabskip}'이 들어 있으면 `\.{\\global}' 토큰은 서문에 남고, `\.{\\tabskip}'은 새 tabskip 글루를 (지역적으로)
정의한다는 것에 주의하라.

@<|get_preamble_token|이라는...@>=
func get_preamble_token() {
restart:
	get_token()
	for cur_chr == span_code && cur_cmd == tab_mark {
		get_token() // 이 토큰은 한 번 펼쳐진다
		if cur_cmd > max_command {
			expand(); get_token()
		}
	}
	if cur_cmd == endv {
		fatal_error("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	if cur_cmd == assign_glue && cur_chr == glue_base+tab_skip_code {
		scan_optional_equals(); scan_glue(glue_val)
		if global_defs() > 0 {
			geq_define(glue_base+tab_skip_code, glue_ref, cur_val)
		} else {
			eq_define(glue_base+tab_skip_code, glue_ref, cur_val)
		}
		goto restart
	}
}

@ 틀의 처음에 있는 공백은 없앤다.

@<틀 \<u_j>를 훑어...@>=
p = hold_head; set_link(p, null)
for {
	get_preamble_token()
	if cur_cmd == mac_param {
		goto done1
	}
	if cur_cmd <= car_ret && cur_cmd >= tab_mark && align_state == -1000000 {
		if p == hold_head && cur_loop == null && cur_cmd == tab_mark {
			cur_loop = cur_align
		} else {
			print_err("Missing # inserted in alignment preamble")
@.Missing \# inserted...@>
			help3("There should be exactly one # between &'s, when an",
				"\\halign or \\valign is being set up. In this case you had",
				"none, so I've put one in; maybe that will work.")
			back_error(); goto done1
		}
	} else if cur_cmd != spacer || p != hold_head {
		set_link(p, get_avail()); p = link(p); set_info(p, cur_tok)
	}
}
done1:

@ @<틀 \<v_j>를 훑어...@>=
p = hold_head; set_link(p, null)
for {
continue_:
	get_preamble_token()
	if cur_cmd <= car_ret && cur_cmd >= tab_mark && align_state == -1000000 {
		goto done2
	}
	if cur_cmd == mac_param {
		print_err("Only one # is allowed per tab")
@.Only one \# is allowed...@>
		help3("There should be exactly one # between &'s, when an",
			"\\halign or \\valign is being set up. In this case you had",
			"more than one, so I'm ignoring all but the first.")
		error(); goto continue_
	}
	set_link(p, get_avail()); p = link(p); set_info(p, cur_tok)
}
done2:
	set_link(p, get_avail()); p = link(p)
	set_info(p, end_template_token) // 끝에 \.{\\endtemplate}을 둔다

@ 정렬에서 까다로운 부분은 틀을 알맞은 때에 훑개에 넣는 것, 그리고 행이나 열이 끝났을 때 제어를 되찾는 것이다.

대개 \.{\\cr}을 감지할 때마다 새 행을 시작한다. 다만 그 \.{\\cr} 뒤에 \.{\\noalign}이나 정렬을 끝내는 오른쪽 중괄호가 오면
그렇지 않다. 루틴 |align_peek|은 앞을 내다보고 올바른 일을 하는 데 쓰인다. 이것은 새 행을 시작하거나, \.{\\noalign}을
시작하거나, 정렬을 마무리한다.

@<|align_peek|이라는 프로시저를 선언한다@>=
func align_peek() {
restart:
	align_state = 1000000; @<공백도 호출도 아닌...@>
	if cur_cmd == no_align {
		scan_left_brace(); new_save_level(no_align_group)
		if mode == -vmode {
			normal_paragraph()
		}
	} else if cur_cmd == right_brace {
		fin_align()
	} else if cur_cmd == car_ret && cur_chr == cr_cr_code {
		goto restart // \.{\\crcr}은 무시한다
	} else {
		init_row() // 새 행을 시작한다
		init_col() // 새 열을 시작하고, 엿본 것을 되돌린다
	}
}

@ 행(row)을 시작하려면 새 의미 수준에 들어가서 첫 tabskip 글루를 베끼고, 내부 세로 모드에서 제한된 가로 모드로, 또는 그
반대로 바꾼다. 이 의미 수준에서는 |space_factor|와 |prev_depth|를 쓰지 않지만, 그저 깔끔하게 하려고 0으로 해 둔다.

@<함수들@>=
@<|init_span|이라는 프로시저를 선언한다@>@;
func init_row() {
	push_nest(); mode = (-hmode - vmode) - mode
	if mode == -hmode { set_space_factor(0) } else { set_prev_depth(0) }
	tail_append(new_glue(glue_ptr(preamble())))
	set_subtype(tail, tab_skip_code+1)
	cur_align = link(preamble()); cur_tail = cur_head; init_span(cur_align)
}

@ 프로시저 |init_span|의 매개변수는 다음 열이나 열 무리가 시작할 정렬 기록을 가리키는 포인터다. 새 의미 수준에 들어가서, 열들이
나중에 상자로 묶을 목록을 만들어 내게 한다.

@<|init_span|이라는...@>=
func init_span(p pointer) {
	push_nest()
	if mode == -hmode {
		set_space_factor(1000)
	} else {
		set_prev_depth(ignore_depth); normal_paragraph()
	}
	cur_span = p
}

@ 열이 시작할 때 우리는 |cur_cmd|가 |omit|이거나, 아니면 \<u_j> 틀을 훑을 때까지 현재 토큰을 입력에 되돌려 두어야 한다고
가정한다. (|cur_cmd|가 |tab_mark|나 |car_ret|일 수도 있다는 것에 주의하라.) 또한 이때 |align_state|가 대략 1000000이라고
가정한다. 같은 모드에 머물러 있으면서, 필요하면 틀을 시작한다.

@<함수들@>=
func init_col() {
	set_extra_info(cur_align, cur_cmd)
	if cur_cmd == omit {
		align_state = 0
	} else {
		back_input(); begin_token_list(u_part(cur_align), u_template)
	} // 이제 |align_state=1000000|
}

@ \<u_j> 틀이 끝나면 훑개가 |align_state|를 0으로 한다. 그 뒤에 \.{\\cr}이나 \.{\\span}이나 탭 표시가 |align_state=0|일 때
나타나면 훑개는 다음 코드를 작동시키고, 이 코드가 \<v_j> 틀을 시작한다. 이때 |cur_chr|를 기억해 두어야 한다. 이것은 열 텍스트가
어떻게 끝났는지에 따라 |cr_cr_code|, |cr_code|, |span_code|, 또는 문자 코드다.

프로그램의 이 부분은 다른 정렬의 서문을 훑고 있을 때나, 활성 정렬 서문이 없을 때는 작동하지 않는 편이 좋다.

@<\<v_j> 틀을 끼워...@>=
if scanner_status == aligning || cur_align == null {
	fatal_error("(interwoven alignment preambles are not allowed)")
}
@.interwoven alignment preambles...@>
cur_cmd = extra_info(cur_align); set_extra_info(cur_align, cur_chr)
if cur_cmd == omit {
	begin_token_list(omit_template, v_template)
} else {
	begin_token_list(v_part(cur_align), v_template)
}
align_state = 1000000; goto restart

@ 방금 말한 토큰 목록 |omit_template|은 특별한 제어 시퀀스 \.{\\endtemplate}만 담은 상수 토큰 목록이다.

@<특별한 목록 머리와...@>=
set_info(omit_template, end_template_token) // |link(omit_template)=null|

@ \<v_j> 틀의 끝에 있는 |endv| 명령이 훑개를 지나오면 정말로 일이 일어나기 시작한다. 그 일을 일으키는 것이 루틴 |fin_col|이다.
이 루틴은 열만이 아니라 행까지 끝났으면 |true|를 돌려준다.

@<함수들@>=
func fin_col() bool {
	var p pointer // 현재 정렬 기록 다음의 정렬 기록
	var q, r pointer // 목록을 다루는 임시 포인터들
	var s pointer // 새 걸침 노드
	var u pointer // 새 미정 상자
	var w scaled // 자연 너비
	var o glue_ord // 무한의 차수
	var n halfword // 걸침 계수기
	if cur_align == null {
		confusion("endv")
	}
	q = link(cur_align); if q == null { confusion("endv") }
@:this can't happen endv}{\quad endv@>
	if align_state < 500000 {
		fatal_error("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	p = link(q)
	@<서문 목록을 다 지나왔으면 행이 끝났는지 검사한다@>
	if extra_info(cur_align) != span_code {
		unsave(); new_save_level(align_group)
		@<현재 열의 미정 상자를 묶고 그 너비를 기록한다@>
		@<열 사이의 tabskip 글루를 베낀다@>
		if extra_info(cur_align) >= cr_code {
			return true
		}
		init_span(p)
	}
	align_state = 1000000; @<공백도 호출도 아닌...@>
	cur_align = p
	init_col(); return false
}

@ @<서문 목록을 다 지나왔으면...@>=
if p == null && extra_info(cur_align) < cr_code {
	if cur_loop != null {
		@<서문을 주기적으로 늘인다@>
	} else {
		print_err("Extra alignment tab has been changed to ")
@.Extra alignment tab...@>
		print_esc("cr")
		help3("You have given more \\span or & marks than there were",
			"in the preamble to the \\halign or \\valign now in progress.",
			"So I'll assume that you meant to type \\cr instead.")
		set_extra_info(cur_align, cr_code); error()
	}
}

@ @<서문을 주기적으로...@>=
set_link(q, new_null_box()); p = link(q) // 새 정렬 기록
set_info(p, end_span); set_width(p, null_flag); cur_loop = link(cur_loop)
@<노드 |cur_loop|의 틀을 노드 |p|로 베낀다@>
cur_loop = link(cur_loop)
set_link(p, new_glue(glue_ptr(cur_loop)))
set_subtype(link(p), tab_skip_code+1)

@ @<노드 |cur_loop|의 틀을...@>=
q = hold_head; r = u_part(cur_loop)
for r != null {
	set_link(q, get_avail()); q = link(q); set_info(q, info(r)); r = link(r)
}
set_link(q, null); set_u_part(p, link(hold_head))
q = hold_head; r = v_part(cur_loop)
for r != null {
	set_link(q, get_avail()); q = link(q); set_info(q, info(r)); r = link(r)
}
set_link(q, null); set_v_part(p, link(hold_head))

@ @<열 사이의 tabskip...@>=
tail_append(new_glue(glue_ptr(link(cur_align))))
set_subtype(tail, tab_skip_code+1)

@ @<현재 열의 미정 상자를...@>=
if mode == -hmode {
	adjust_tail = cur_tail; u = hpack(link(head), natural, additional); w = width(u)
	cur_tail = adjust_tail; adjust_tail = null
} else {
	u = vpackage(link(head), natural, additional, 0); w = height(u)
}
n = min_quarterword // 이것은 걸침 계수 1을 나타낸다
if cur_span != cur_align {
	@<걸친 열들의 너비 항목을 갱신한다@>
} else if w > width(cur_align) {
	set_width(cur_align, w)
}
set_type(u, unset_node); set_span_count(u, n)
@<늘이기 차수를 정한다@>
set_glue_order(u, o); set_glue_stretch(u, total_stretch[o])
@<줄이기 차수를 정한다@>
set_glue_sign(u, o); set_glue_shrink(u, total_shrink[o])
pop_nest(); set_link(tail, u); tail = u

@ 걸침 노드는 |width|, |info|, |link| 필드를 가진 두 낱말짜리 레코드다. 필드 |link|는 실제로는 링크가 아니라 걸친 열의
수를 나타낸다. 필드 |info|는 같은 열에서 시작하면서 더 넓게 걸친 걸침 노드를 가리키거나, 가능한 가장 큰 |link| 필드를 가진
|end_span|을 가리킨다. 필드 |width|는 특정한 걸친 열 묶음에 대응하는 가장 큰 자연 너비를 담는다.

주어진 열에서 시작하는 걸친 열들에 대해 지금까지의 최대 너비 목록은 그 열의 정렬 기록의 |info| 필드에서 시작한다.

@<정의@>=
const @!span_node_size = 2 // 걸침 노드의 |mem| 낱말 수

@ \dg 앞 절의 |end_span|을 초기화한다.

@<특별한 목록 머리와...@>=
set_link(end_span, max_quarterword+1); set_info(end_span, null)

@ @<걸친 열들의 너비...@>=
q = cur_span
for {
	n++; q = link(link(q))
	if q == cur_align {
		break
	}
}
if n > max_quarterword {
	confusion("256 spans") // 이런 일이 일어날 수는 있지만, 일어나지 않을 것이다
}
@^system dependencies@>
@:this can't happen 256 spans}{\quad 256 spans@>
q = cur_span
for link(info(q)) < n {
	q = info(q)
}
if link(info(q)) > n {
	s = get_node(span_node_size); set_info(s, info(q)); set_link(s, n)
	set_info(q, s); set_width(s, w)
} else if width(info(q)) < w {
	set_width(info(q), w)
}

@ 행이 끝나면 미정 상자 하나를 현재 세로 목록(\.{\\halign}의 경우)이나 현재 가로 목록(\.{\\valign}의 경우)에 덧붙인다. 이
미정 상자는 tabskip 글루로 나뉜 열들의 미정 상자를 담는다. 모든 것은 나중에 정해진다.

@<함수들@>=
func fin_row() {
	var p pointer // 새 미정 상자
	if mode == -hmode {
		p = hpack(link(head), natural, additional)
		pop_nest(); append_to_vlist(p)
		if cur_head != cur_tail {
			set_link(tail, link(cur_head)); tail = cur_tail
		}
	} else {
		p = vpack(link(head), natural, additional); pop_nest()
		set_link(tail, p); tail = p; set_space_factor(1000)
	}
	set_type(p, unset_node); set_glue_stretch(p, 0)
	if every_cr() != null {
		begin_token_list(every_cr(), every_cr_text)
	}
	align_peek()
} // |glue_shrink==shift_amount|이므로 |glue_shrink(p)=0|임에 주의하라

@ 마침내 정렬의 끝에 이르고, 메모리가 넘치지 않았다는 데 안도의 한숨을 쉴 수 있다. 이제 모든 미정 상자를 정해서, 걸친 열들을
알맞게 고려하며 열들이 가지런히 서게 한다.

보충: 원본은 여기서 |do_assignments|, |resume_after_display|, |build_page|를 |forward|로 선언한다. \GO/에서는 필요 없다.

@<함수들@>=
func fin_align() {
	var p, q, r, s, u, v pointer // 목록 연산을 위한 레지스터들
	var t, w scaled // 열의 너비
	var o scaled // 미정 상자를 옮길 양
	var n halfword // 맞추어 볼 걸침의 양
	var rule_save scaled // |overfull_rule|을 잠시 담아 둔다
	var aux_save memory_word // |aux|를 잠시 담아 둔다
	if cur_group != align_group {
		confusion("align1")
	}
@:this can't happen align}{\quad align@>
	unsave() // 그 |align_group|은 각 항목을 위한 것이었다
	if cur_group != align_group {
		confusion("align0")
	}
	unsave() // 그 |align_group|은 정렬 전체를 위한 것이었다
	if nest[nest_ptr-1].mode_field == mmode {
		o = display_indent()
	} else {
		o = 0
	}
	@<서문 목록을 지나가며 열 너비를 정하고 정렬 기록을 바꾼다@>
	@<서문 목록을 묶어 |p|가 그 견본 상자를 가리키게 한다@>
	@<현재 목록의 모든 미정 상자의 글루를 정한다@>
	flush_node_list(p); pop_alignment()
	@<현재 목록을 그 환경에 넣는다@>
}

@<|align_peek|이라는...@>

@ 이제 서문 목록을 해체하고 열 너비를 계산할 때다. 값 $w_{ij}$를 $i$열부터 $j$열까지(양 끝 포함) 걸친 모든 항목의 자연 너비의
최댓값이라고 하자. 그러면 $i$열의 정렬 기록은 |width| 필드에 $w_{ii}$를 담고, 또 |info| 필드로 접근할 수 있는 연결 목록에 $j$가
커지는 차례로 0이 아닌 $w_{ij}$를 담는다. 이 걸침 노드들의 |link| 필드에는 $j-i+|min_quarterword|$ 값이 들어 있다.
값 $w_{ii}$는 |null_flag|로 초기화되었는데, 우리는 이것을 $-\infty$로 여긴다.

마지막 열 너비는 다음 식으로 정의한다.
$$w_j=\max_{1\le i\le j}\biggl( w_{ij}-\sum_{i\le k<j}(t_k+w_k)\biggr)$$
여기서 $t_k$는 $k$열과 $k+1$열 사이 tabskip 글루의 자연 너비다. 다만 |1<=i<=j| 범위의 모든 |i|에 대해 $w_{ij}=-\infty$이면
(곧 |j|열에 관련된 모든 항목이 |j+1|열에도 관련되면), $w_j=0$으로 하고 |j|열 뒤의 tabskip 글루를 0으로 만든다.

\TeX은 이 값들을 다음 방식으로 계산한다. 먼저 $w_1=w_{11}$이다. 그런 다음 모든 $j>1$에 대해 $w_{2j}$를 $\max(w_{2j},
w_{1j}-t_1-w_1)$로 바꾼다. 그러면 $w_2=w_{22}$다. 그런 다음 모든 $j>2$에 대해 $w_{3j}$를 $\max(w_{3j},w_{2j}-t_2-w_2)$로
바꾼다. 이렇게 계속한다. 어떤 $w_j$가 $-\infty$로 판명되면 그 값을 0으로 바꾸고, 다음 tabskip도 0으로 바꾼다.

보충: 정렬 기록들은 여기서 가짜 미정 상자로 바뀐다.

@<서문 목록을 지나가며...@>=
q = link(preamble())
for {
	flush_list(u_part(q)); flush_list(v_part(q))
	p = link(link(q))
	if width(q) == null_flag {
		@<|width(q)|와 이 열 뒤의 tabskip 글루를 없앤다@>
	}
	if info(q) != end_span {
		@<|q|의 걸침 노드 너비를 |p|의 것과 합치고 |q|의 걸침 노드를 없앤다@>
	}
	set_type(q, unset_node); set_span_count(q, min_quarterword); set_height(q, 0)
	set_depth(q, 0); set_glue_order(q, normal); set_glue_sign(q, normal)
	set_glue_stretch(q, 0); set_glue_shrink(q, 0); q = p
	if q == null {
		break
	}
}

@ @<|width(q)|와 이 열 뒤의...@>=
set_width(q, 0); r = link(q); s = glue_ptr(r)
if s != zero_glue {
	add_glue_ref(zero_glue); delete_glue_ref(s)
	set_glue_ptr(r, zero_glue)
}

@ 두 걸침 노드 목록을 합치는 것은 선형 연결 자료 구조를 다루는 전형적인 연습 문제다. 다음 |repeat| 루프의 본질적인 불변식은
이렇다. 우리는 |q|의 목록에 있는 노드 |r|을 처리하려 하고, |u|는 그 다음 노드다. 그리고 |p|의 목록에서 |s|까지(|s| 포함)의 모든
노드는 처리되었고, |s|의 다음 노드는 |link(r)=n|이냐 |link(r)>n|이냐 |link(r)<n|이냐에 따라 |r|과 맞거나, |r|보다 앞서거나,
|r|보다 뒤에 온다.

@<|q|의 걸침 노드 너비를...@>=
t = width(q) + width(glue_ptr(link(q)))
r = info(q); s = end_span; set_info(s, p); n = min_quarterword + 1
for {
	set_width(r, width(r)-t); u = info(r)
	for link(r) > n {
		s = info(s); n = link(info(s)) + 1
	}
	if link(r) < n {
		set_info(r, info(s)); set_info(s, r); set_link(r, link(r)-1); s = r
	} else {
		if width(r) > width(info(s)) {
			set_width(info(s), width(r))
		}
		free_node(r, span_node_size)
	}
	r = u
	if r == end_span {
		break
	}
}

@ 이제 서문 목록은 미정 상자와 tabskip 글루가 번갈아 나오는 목록으로 바뀌었고, 상자 너비는 마지막 열 크기와 같다.
명령 \.{\\valign}의 경우에는 너비를 높이로 바꾸어서, 정렬이 넘치거나 덜 찰 때 올바른 오류 메시지가 나오게 한다.

@<서문 목록을 묶어...@>=
save_ptr = save_ptr - 2; pack_begin_line = -mode_line
if mode == -vmode {
	rule_save = overfull_rule()
	set_overfull_rule(0) // 괘선이 묶이지 않게 한다
	p = hpack(preamble(), saved(1), saved(0)); set_overfull_rule(rule_save)
} else {
	q = link(preamble())
	for {
		set_height(q, width(q)); set_width(q, 0); q = link(link(q))
		if q == null {
			break
		}
	}
	p = vpack(preamble(), saved(1), saved(0))
	q = link(preamble())
	for {
		set_width(q, height(q)); set_height(q, 0); q = link(link(q))
		if q == null {
			break
		}
	}
}
pack_begin_line = 0

@ @<현재 목록의 모든 미정 상자의...@>=
q = link(head); s = head
for q != null {
	if !is_char_node(q) {
		if type_(q) == unset_node {
			@<미정 상자 |q|와 그 안의 미정 상자들을 정한다@>
		} else if type_(q) == rule_node {
			@<괘선 |q|의 흐르는 치수를 정렬의 경계까지 늘인다@>
		}
	}
	s = q; q = link(q)
}

@ @<괘선 |q|의 흐르는...@>=
if is_running(width(q)) {
	set_width(q, width(p))
}
if is_running(height(q)) {
	set_height(q, height(p))
}
if is_running(depth(q)) {
	set_depth(q, depth(p))
}
if o != 0 {
	r = link(q); set_link(q, null); q = hpack(q, natural, additional)
	set_shift_amount(q, o); set_link(q, r); set_link(s, q)
}

@ 미정 상자 |q|는 미정 상자를 하나 이상 담은 행을 나타낸다. 몇 개를 담는지는 그 행에서 \.{\\cr}이 얼마나 일찍 나왔는지에
달려 있다.

@<미정 상자 |q|와 그 안의...@>=
if mode == -vmode {
	set_type(q, hlist_node); set_width(q, width(p))
} else {
	set_type(q, vlist_node); set_height(q, height(p))
}
set_glue_order(q, glue_order(p)); set_glue_sign(q, glue_sign(p))
set_glue_set(q, glue_set(p)); set_shift_amount(q, o)
r = link(list_ptr(q)); s = link(list_ptr(p))
for {
	@<노드 |r|의 글루를 정하고 미정 노드에서 바꾼다@>
	r = link(link(r)); s = link(link(s))
	if r == null {
		break
	}
}

@ 걸친 열들로 만든 상자 뒤에는, 걸침이 없었던 것처럼 tabskip 글루 노드와 빈 상자가 따라온다. 이렇게 하면 뒤따르는 항목들을
완벽하게 가지런히 맞출 수 있고, 부동 소수점 산술에 따라 달라지는 값이 어떤 상자의 치수에도 들어가지 않는다.

@<노드 |r|의 글루를...@>=
n = span_count(r); t = width(s); w = t; u = hold_head
for n > min_quarterword {
	n--
	@<목록 |u|에 tabskip 글루와 빈 상자를 덧붙이고 |s|와 |t|를 갱신한다@>
}
if mode == -vmode {
	@<미정 노드 |r|을 너비 |w|인 |hlist_node|로 바꾼다@>
} else {
	@<미정 노드 |r|을 높이 |w|인 |vlist_node|로 바꾼다@>
}
set_shift_amount(r, 0)
if u != hold_head { // 걸친 노드들 몫의 빈 상자를 덧붙인다
	set_link(u, link(r)); set_link(r, link(hold_head)); r = u
}

@ 견본 노드들을 지나가면서 |s|와 |t|를 갱신한다.

@<목록 |u|에 tabskip 글루와...@>=
s = link(s); v = glue_ptr(s); set_link(u, new_glue(v)); u = link(u)
set_subtype(u, tab_skip_code+1); t = t + width(v)
if glue_sign(p) == stretching {
	if stretch_order(v) == glue_order(p) {
		t = t + round(float(glue_set(p))*float64(stretch(v)))
	}
@^real multiplication@>
} else if glue_sign(p) == shrinking {
	if shrink_order(v) == glue_order(p) {
		t = t - round(float(glue_set(p))*float64(shrink(v)))
	}
}
s = link(s); set_link(u, new_null_box()); u = link(u); t = t + width(s)
if mode == -vmode {
	set_width(u, width(s))
} else {
	set_type(u, vlist_node); set_height(u, width(s))
}

@ 글루는 너비가 |t|인 것처럼 정한다.

@<미정 노드 |r|을 너비 |w|인...@>=
set_height(r, height(q)); set_depth(r, depth(q))
if t == width(r) {
	set_glue_sign(r, normal); set_glue_order(r, normal)
	set_glue_set(r, 0.0)
} else if t > width(r) {
	set_glue_sign(r, stretching)
	if glue_stretch(r) == 0 {
		set_glue_set(r, 0.0)
	} else {
		set_glue_set(r, unfloat(float64(t-width(r))/float64(glue_stretch(r))))
	}
@^real division@>
} else {
	set_glue_order(r, glue_sign(r)); set_glue_sign(r, shrinking)
	if glue_shrink(r) == 0 {
		set_glue_set(r, 0.0)
	} else if glue_order(r) == normal && width(r)-t > glue_shrink(r) {
		set_glue_set(r, 1.0)
	} else {
		set_glue_set(r, unfloat(float64(width(r)-t)/float64(glue_shrink(r))))
	}
}
set_width(r, w); set_type(r, hlist_node)

@ 글루는 높이가 |t|인 것처럼 정한다.

@<미정 노드 |r|을 높이 |w|인...@>=
set_width(r, width(q))
if t == height(r) {
	set_glue_sign(r, normal); set_glue_order(r, normal)
	set_glue_set(r, 0.0)
} else if t > height(r) {
	set_glue_sign(r, stretching)
	if glue_stretch(r) == 0 {
		set_glue_set(r, 0.0)
	} else {
		set_glue_set(r, unfloat(float64(t-height(r))/float64(glue_stretch(r))))
	}
@^real division@>
} else {
	set_glue_order(r, glue_sign(r)); set_glue_sign(r, shrinking)
	if glue_shrink(r) == 0 {
		set_glue_set(r, 0.0)
	} else if glue_order(r) == normal && height(r)-t > glue_shrink(r) {
		set_glue_set(r, 1.0)
	} else {
		set_glue_set(r, unfloat(float64(height(r)-t)/float64(glue_shrink(r))))
	}
}
set_height(r, w); set_type(r, vlist_node)

@ 이제 |head|에서 시작해 |tail|에서 끝나는 목록에 완성된 정렬이 있다. 이 목록은 그것을 둘러싼 목록에 합쳐진다. (둘러싼 모드가
따로 세운 수식을 위한 |mmode|라면 수식 앞뒤에 글루를 넣어야 한다. 프로그램의 그 부분은 그런 연산에 더 익숙해질 때까지 미루어
둔다.)

제한된 가로 모드에서는 |aux|의 |clang| 부분이 정의되어 있지 않다. 지나치게 조심스러운 \PASCAL\ 실행 시스템은 이것을
불평할지도 모른다.
@^dirty \PASCAL@>

@<현재 목록을 그 환경에...@>=
aux_save = aux; p = link(head); q = tail; pop_nest()
if mode == mmode {
	@<따로 세운 수식 안의 정렬을 마무리한다@>
} else {
	aux = aux_save; set_link(tail, p)
	if p != null {
		tail = q
	}
	if mode == vmode {
		build_page()
	}
}

@* 문단을 줄로 나누기.
이제 아마 \TeX에서 가장 흥미로운 알고리즘일 것에 이르렀다. 문단의 각 줄을 낳는 ``가장 좋은'' 나눔점을 고르는 방법이다.
\TeX의 줄 나누기 알고리즘은 주어진 가로 목록을 받아서, 현재 세로 목록에 덧붙일 상자들의 나열로 바꾼다. 이 일을 하는
동안 \TeX의 다른 곳에서는 쓰지 않는 세 종류의 레코드를 담은 특별한 자료 구조를 만든다. 그런 노드는 문단을 처리하는 동안
만들어지고 그 뒤에 없어진다. 그래서 \TeX의 다른 부분은 줄 나누기를 어떻게 하는지 전혀 알 필요가 없다.

여기서 쓰는 방법은 마이클~F. 플래스(Michael F. Plass)와 저자가 1977년에 고안한 접근법에 바탕을 두고, 그 뒤 같은 두 사람이
@^Plass, Michael Frederick@>
@^Knuth, Donald Ervin@>
1980년에 일반화하고 개선한 것이다. 자세한 논의는 {\sl Software---Practice and Experience \bf11} (1981), 1119--1184에 있다.
거기서 줄 나누기 문제를 비순환 네트워크에서 최단 경로를 계산하는 문제의 특수한 경우로 볼 수 있음을 보였다. 그 논문에는
많은 보기가 있고, 인쇄공들이 오랜 세월 해 온 줄 나누기의 역사도 서술되어 있다. 지금의 구현은 1980년의 알고리즘에 새 생각
두 가지를 더한다. 비활성 노드에 활성 노드보다 작은 레코드를 써서 메모리 요구량을 상당히 줄였고, 문단의 처음부터 현재
지점까지의 전체 거리를 기록하는 대신 ``델타 거리''를 써서 산술 넘침을 피했다.

@ 프로시저 |line_break|는 가로 모드에서만 불러야 한다. 이것은 그 모드를 떠나서, 둘러싼 세로 모드(또는 내부 세로 모드)의 현재
세로 목록에 출력을 놓는다. 명시적인 매개변수는 |final_widow_penalty| 하나인데, 이것은 문단의 마지막 줄 앞에 넣을 추가
벌점의 양이다.

암묵적인 매개변수도 여럿 있다. 나눌 가로 목록은 |link(head)|에서 시작하고, 비어 있지 않다. 둘러싼 의미 수준의 |prev_graf|
값은 매달린 들여쓰기나 \.{\\parshape}를 쓸 때를 대비해 문단이 줄 번호의 나열에서 어디서 시작해야 하는지 알려 준다.
이 값은 이 문단이 따로 세운 수식 뒤에 이어지는 것이 아니면 0이다. 포인터 |par_shape_ptr|와 하이픈 넣기에 쓸 여러 벌점 따위의
다른 암묵적 매개변수는 |eqtb|에 있다.

프로시저 |line_break|가 일을 마치면 현재 세로 목록과 |prev_graf|의 값이 갱신되어 있다. 게다가 전역 변수 |just_box|가 |line_break|가
만든 마지막 상자를 가리키므로, 따로 세운 수식 앞에 |above_display_skip|을 쓸지 |above_display_short_skip|을 쓸지 정해야 할 때
이 줄의 너비를 알아낼 수 있다.

@<전역 변수@>=
var @!just_box pointer // 새 문단의 마지막 줄을 위한 |hlist_node|

@ 프로시저 |line_break|는 꽤 길므로---일종의 작은 세계다---\TeX의 더 단순한 프로시저들을 다룰 때보다 좀 더 조심스럽게
조금씩 쌓아 올려야 한다. 다음은 전체 윤곽이다.

@<함수들@>=
@<|line_break|의 하위 프로시저들@>@;
func line_break(final_widow_penalty int32) {
	@<줄 나누기의 지역 변수@>@;
	pack_begin_line = mode_line // 넘치거나 덜 찬 상자 메시지를 위한 것이다
	@<줄 나누기를 시작할 준비를 한다@>
	@<최적의 나눔점들을 찾는다@>
	@<고른 나눔점들에서 문단을 나누어 줄을 맞추고 세로 목록에 덧붙인다@>
	@<나눔 노드들을 없애 메모리를 청소한다@>
	pack_begin_line = 0
}

@ 첫 할 일은 목록을 |head|에서 |temp_head|로 옮기고 둘러싼 의미 수준으로 들어가는 것이다. 또 문단 끝에 \.{\\parfillskip}
글루를 덧붙이는데, 거기에 공백(이나 다른 글루 노드)이 있었으면 없앤다. 빈 줄이나 `\.{\$\$}' 앞에는 대개 공백이 있기
때문이다. 글루 |par_fill_skip| 앞에는 무한 벌점이 있으므로 이것은 결코 나눔점 후보로 고려되지 않는다.

이 코드는 |glue_node|와 |penalty_node|가 같은 수의 |mem|~낱말을 차지한다고 가정한다.
@^data structure assumptions@>

@<줄 나누기를 시작할...@>=
set_link(temp_head, link(head))
if is_char_node(tail) {
	tail_append(new_penalty(inf_penalty))
} else if type_(tail) != glue_node {
	tail_append(new_penalty(inf_penalty))
} else {
	set_type(tail, penalty_node); delete_glue_ref(glue_ptr(tail))
	flush_node_list(leader_ptr(tail)); set_penalty(tail, inf_penalty)
}
set_link(tail, new_param_glue(par_fill_skip_code))
init_cur_lang = prev_graf % 0o200000
init_l_hyf = prev_graf / 0o20000000
init_r_hyf = (prev_graf / 0o200000) % 0o100
pop_nest()

@ 최적의 줄 나눔을 찾을 때, \TeX은 {\sl 실행 가능한}(feasible) 나눔마다 ``나눔 노드''를 만든다. 여기서 실행 가능하다는 것은
어떤 줄도 주어진 허용치보다 더 늘이지 않고 그 자리에서 줄을 끝낼 길이 있다는 뜻이다. 나눔 노드는 세 가지로 특징지어진다.
나눔의 위치(|glue_node|, |math_node|, |penalty_node|, |disc_node|를 가리키는 포인터), 이 나눔점 뒤에 올 줄의 번호, 방금 끝난
줄의 맞음새 분류, 곧 |tight_fit|, |decent_fit|, |loose_fit|, |very_loose_fit|이다.

@<정의@>=
const (
	@!tight_fit = 3 // 줄일 수 있는 양의 0.5에서 1.0만큼 줄이는 줄의 맞음새 분류
	@!loose_fit = 1 // 늘일 수 있는 양의 0.5에서 1.0만큼 늘이는 줄의 맞음새 분류
	@!very_loose_fit = 0 // 늘일 수 있는 양보다 더 늘이는 줄의 맞음새 분류
	@!decent_fit = 2 // 그 밖의 모든 줄의 맞음새 분류
)

@ 이 알고리즘은 본질적으로 위치, 줄, 맞음새의 실행 가능한 조합마다 그것을 이루는 가장 좋은 길을 정한다. 그래서 ``넷째 줄이
이러저러한 곳에서 끝나는 빡빡한 줄이 되도록 문단의 앞부분을 나누는 가장 좋은 방법은 무엇인가?'' 같은 물음에 답한다.
그러나 어떤 지점 뒤로는 모든 줄의 길이가 같다는 사실 덕분에, looseness 매개변수가 0일 때는 넉넉히 큰 줄 번호를 모두 같은
것으로 볼 수 있고, 이 덕분에 알고리즘이 공간과 시간을 아낄 수 있다.

고려해야 할 실행 가능한 나눔점마다 |mem|에 ``활성 노드''와 ``수동 노드''를 만든다. 활성 노드는 세 낱말 길이고 수동 노드는
두 낱말 길이다. 활성 노드는 문단에서 지금 살피고 있는 곳 가까이의 나눔점에만 필요하므로, 만들어진 뒤 비교적 짧은 시간
안에 재활용된다.

@ 주어진 나눔점의 활성 노드에는 필드가 여섯 있다.

\yskip\hang|link|는 활성 노드 목록의 다음 노드를 가리킨다. 마지막 활성 노드는 |link=last_active|다.

\yskip\hang|break_node|는 이 나눔점에 딸린 수동 노드를 가리킨다.

\yskip\hang|line_number|는 이 나눔점 뒤에 오는 줄의 번호다.

\yskip\hang|fitness|는 이 나눔점에서 끝나는 줄의 맞음새 분류다.

\yskip\hang|type|은 이 나눔점이 |disc_node|인지에 따라 |hyphenated|나 |unhyphenated|다.

\yskip\hang|total_demerits|는 문단의 처음부터 이 나눔점까지 이르는 모든 줄에 걸친 감점(demerit) 합의 가능한 최솟값이다.

\yskip\noindent
포인터 |link(active)|는 현재 활성인 모든 노드의 연결 목록에서 첫 활성 노드를 가리킨다. 이 목록은 |line_number| 차례로
놓여 있다. 다만 |line_number>easy_line|인 노드들끼리는 어떤 차례로든 놓일 수 있다.

@<정의@>=
const @!active_node_size = 3 // 활성 노드의 낱말 수

func fitness(p pointer) quarterword { return subtype(p) } // 이 나눔의 마지막 줄의 |very_loose_fit..tight_fit|
func set_fitness(p pointer, v quarterword) { set_subtype(p, v) }
func break_node(p pointer) pointer { return rlink(p) } // 대응하는 수동 노드를 가리키는 포인터
func set_break_node(p pointer, v pointer) { set_rlink(p, v) }
func line_number(p pointer) halfword { return llink(p) } // 이 나눔점에서 시작하는 줄
func set_line_number(p pointer, v halfword) { set_llink(p, v) }
func total_demerits(p pointer) int32 { return mem[p+2].sc } // \TeX이 최소로 만드는 양
func set_total_demerits(p pointer, v int32) { mem[p+2].sc = v }

const (
	@!unhyphenated = 0 // 보통 활성 나눔 노드의 |type|
	@!hyphenated = 1 // |disc_node|에서 나누는 활성 노드의 |type|
	@!last_active = active // 활성 목록은 시작한 곳에서 끝난다
)

@ @<특별한 목록 머리와...@>=
set_type(last_active, hyphenated); set_line_number(last_active, max_halfword)
set_subtype(last_active, 0) // 알고리즘은 |subtype|을 결코 살피지 않는다

@ 주어진 나눔점의 수동 노드에는 필드가 넷만 있다.

\yskip\hang|link|는 이것 바로 앞에 만든 수동 노드가 있으면 그것을 가리키고, 없으면 |null|이다.

\yskip\hang|cur_break|는 나누고 있는 문단의 가로 목록에서 이 나눔점의 위치를 가리킨다.

\yskip\hang|prev_break|는 이 나눔점에 이르는 최적 경로에서 이것 앞에 와야 할 수동 노드를 가리킨다.

\yskip\hang|serial|은 이 수동 노드가 현재 훑기에서 |n|번째로 만든 것이면 |n|이다. (이 필드는 줄 나누기 계산에 관한 자세한
통계를 찍을 때만 쓰인다.)

\yskip\noindent
가장 최근에 만든 수동 노드를 가리키는 |passive|라는 전역 변수가 있다. 또 다른 전역 변수 |printed_node|는 줄 나누기 계산에
관한 자세한 정보를 보여 줄 때 문단을 찍는 것을 돕는 데 쓰인다.

@<전역 변수@>=
const @!passive_node_size = 2 // 수동 노드의 낱말 수

func cur_break(p pointer) pointer { return rlink(p) } // 수동 노드에서 이 나눔점의 위치를 가리킨다
func set_cur_break(p pointer, v pointer) { set_rlink(p, v) }
func prev_break(p pointer) pointer { return llink(p) } // 이것 앞에 와야 할 수동 노드를 가리킨다
func set_prev_break(p pointer, v pointer) { set_llink(p, v) }
func serial(p pointer) halfword { return info(p) } // 기호적 식별을 위한 일련번호
func set_serial(p pointer, v halfword) { set_info(p, v) }

var @!passive pointer // 수동 목록의 가장 최근 노드
var @!printed_node pointer // 가장 최근에 찍은 노드
var @!pass_number halfword // 이번 훑기에서 할당한 수동 노드의 수

@ 활성 목록에는 알고리즘이 각 줄의 나쁨을 계산하는 것을 돕는 ``델타'' 노드도 들어 있다. 그런 노드는 두 활성 노드 사이에만
나타나고 |type=delta_node|다. 두 활성 노드 |p|와 |r| 사이에 델타 노드 |q|가 있어서 |link(p)=q|이고 |link(q)=r|이면, |q|는
가로 목록에서 나눔점 |p| 뒤에 시작하는 줄과 나눔점 |r| 뒤에 시작하는 줄 사이의 공간 차이를 알려 준다. 다시 말해 |p| 뒤에
시작해서 현재 위치에서 끝나는 줄의 길이를 알면, |r| 뒤에 시작하는 줄의 대응하는 길이는 노드~|q|의 양들을 더해서 얻는다.
델타 노드는 눈금 수 여섯 개를 담는다. 모든 차수의 무한에 대해 글루의 늘일 수 있는 양의 순변화를 기록해야 하기 때문이다.
자연 너비의 차이는 |mem[q+1].sc|에, pt, fil, fill, filll 단위의 늘어남 차이는 |mem[q+2..q+5].sc|에, 줄어듦 차이는
|mem[q+6].sc|에 있다. 델타 노드의 |subtype| 필드는 쓰이지 않는다.

@<정의@>=
const (
	@!delta_node_size = 7 // 델타 노드의 낱말 수
	@!delta_node = 2 // 델타 노드의 |type| 필드
)

@ 알고리즘이 돌아가는 동안, 첫 활성 나눔점 뒤에서 시작해 주어진 가로 목록의 현재 위치까지 이르는 줄의 길이를 위해 델타 같은
레지스터 여섯 개의 묶음을 관리한다. 활성 목록을 훑을 때는 현재 관심 있는 활성 나눔점 뒤의 길이를 위해서도 비슷한 레지스터
여섯 개의 묶음을 관리한다. 셋째 묶음은 빈 줄의 길이(곧 \.{\\leftskip}과 \.{\\rightskip}의 합)를 담고, 넷째 묶음은 새 델타
노드를 만드는 데 쓰인다.

델타 노드를 지날 때 우리는 $$\hbox{\ignorespaces|for k:=1 to 6 do cur_active_width[k]:=cur_active_width[k]+mem[q+k].sc|}$$
같은 연산을 하고 싶다. 그리고 이것을 |for| 루프의 부담 없이 하고 싶다. 매크로 |do_all_six|가 그런 여섯 짝 연산을 편하게
해 준다.

보충: 원본의 |do_all_six(#)|는 `|#(1);#(2);#(3);#(4);#(5);#(6)|'으로 펼쳐지고, |#| 자리에는 |copy_to_cur_active| 같은 한
인자 매크로가 온다. \GO/에는 이런 매크로가 없으므로, 이 번역에서는 매크로를 쓰는 자리마다 |k|가 1부터 6까지 도는 |for|
루프로 쓰고, 원본의 매크로 이름을 주석으로 남긴다. 원본의 배열 |[1..6]|은 첨자 0을 쓰지 않는 길이 7의 배열로 옮긴다.

@<전역 변수@>=
var @!active_width [7]scaled // 첫 활성 노드에서 |cur_p|까지의 거리
var @!cur_active_width [7]scaled // 현재 활성 노드에서부터의 거리
var @!background [7]scaled // ``빈'' 줄의 길이
var @!break_width [7]scaled // 현재 나눔 뒤에 계산하고 있는 길이

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
|active_width|에는 $\gamma+\beta(p)-\alpha(a_1)$ 값이 들어 있다. 활성 노드 목록을 훑으며 이를테면 $a_2$에서 |p|까지 가는
시험 줄을 고려하고 있다면, 배열 |cur_active_width|에는 $\gamma+\beta(p)-\alpha(a_2)$ 값이 들어 있다. 그러므로 $a_2$에서
$a_3$으로 옮겨 갈 때는 |cur_active_width|에 $\alpha(a_2)-\alpha(a_3)$을 더하면 된다. 이것이 바로 활성 목록에서 $a_2$와
$a_3$ 사이에 있는 $\delta_2$다. 배열 |background|에는 $\gamma$가 들어 있다. 배열 |break_width|는 활성 목록을 갱신할 때 새
델타 노드의 값을 계산하는 데 쓰인다.

@ 문단으로 만들 가로 목록의 글루 노드에는 ``무한'' 줄어듦이 없어야 한다. 그래서 알고리즘은 늘이기를 위한 레지스터 넷과
줄이기를 위한 레지스터 하나만 관리한다. 사용자가 무한 줄어듦을 넣으려 하면 줄어듦을 유한하게 다시 정하고 오류 메시지를
낸다. 불 변수 |no_shrink_error_yet|은 이 오류 메시지가 문단마다 한 번보다 많이 나타나지 않게 한다.

보충: 원본의 매크로 |check_shrinkage(#)|는 `|if (shrink_order(#)!=normal)and(shrink(#)!=0) then #:=finite_shrink(#)|'으로
펼쳐진다. 그 인자가 \.{\\leftskip}과 \.{\\rightskip}의 |eqtb| 항목이거나 |glue_ptr(cur_p)|여서 \GO/에서는 대입할 곳이 저마다
다르므로, 쓰는 자리마다 펼쳐 쓴다.

@<전역 변수@>=
var @!no_shrink_error_yet bool // 무한 줄어듦에 대해 불평했는가?

@ @<|line_break|의 하위...@>=
func finite_shrink(p pointer) pointer { // 무한 줄어듦에서 회복한다
	var q pointer // 새 글루 명세
	if no_shrink_error_yet {
		no_shrink_error_yet = false
		if stat && tracing_paragraphs() > 0 {
			end_diagnostic(true)
		}
		print_err("Infinite glue shrinkage found in a paragraph")
@.Infinite glue shrinkage...@>
		help5("The paragraph just ended includes some glue that has",
			"infinite shrinkability, e.g., `\\hskip 0pt minus 1fil'.",
			"Such glue doesn't belong there---it allows a paragraph",
			"of any length to fit on one line. But it's safe to proceed,",
			"since the offensive shrinkability has been made finite.")
		error()
		if stat && tracing_paragraphs() > 0 {
			begin_diagnostic()
		}
	}
	q = new_spec(p); set_shrink_order(q, normal)
	delete_glue_ref(p); return q
}

@ @<줄 나누기를 시작할...@>=
no_shrink_error_yet = true
if shrink_order(left_skip()) != normal && shrink(left_skip()) != 0 {
	set_equiv(glue_base+left_skip_code, finite_shrink(left_skip()))
}
if shrink_order(right_skip()) != normal && shrink(right_skip()) != 0 {
	set_equiv(glue_base+right_skip_code, finite_shrink(right_skip()))
}
q = left_skip(); r = right_skip(); background[1] = width(q) + width(r)
background[2] = 0; background[3] = 0; background[4] = 0; background[5] = 0
background[2+stretch_order(q)] = stretch(q)
background[2+stretch_order(r)] = background[2+stretch_order(r)] + stretch(r)
background[6] = shrink(q) + shrink(r)

@ 나눔점을 찾는 동안 포인터 변수 |cur_p|가 주어진 가로 목록을 훑는다. 이 변수는 |line_break|와 그 하위 프로시저 |try_break|가
함께 쓰므로 전역 변수다.

또 다른 전역 변수 |threshold|는 각 줄이 실행 가능한지 정하는 데 쓰인다. 나쁨이 |threshold|를 넘는 줄을 만들지 않고
이를 수 있으면 그 나눔점은 실행 가능하다. (나쁨은 벌점을 더하기 전에 |threshold|와 비교하므로, 벌점이 10000 이상이면 나눌
수 없다는 것 말고는 벌점 값이 나눔점의 실행 가능성에 영향을 주지 않는다.) 문턱값 |threshold|가 10000 이상이면 모든 합법적인 나눔이
실행 가능한 것으로 여겨진다. 앞에서 정한 함수 |badness|는 결코 10000보다 큰 값을 돌려주지 않기 때문이다.

실행 가능한 나눔점 집합을 적어도 하나 찾으려고 문단을 세 번까지 훑을 수 있다. 첫째 훑기에서는 |threshold=pretolerance|이고
|second_pass=final_pass=false|다. 이 훑기가 실행 가능한 해를 찾지 못하면 |threshold|를 |tolerance|로 하고, |second_pass|를
|true|로 하고, 될 수 있는 대로 많은 낱말에 하이픈을 넣어 본다. 그것도 실패하면 바탕의 늘일 수 있는 양에 |emergency_stretch|를
더하고 |final_pass=true|로 한다.

@<전역 변수@>=
var @!cur_p pointer // 지금 고려하고 있는 나눔점
var @!second_pass bool // 이것이 이 문단을 나누는 둘째 시도인가?
var @!final_pass bool // 이것이 이 문단을 나누는 마지막 시도인가?
var @!threshold int32 // 실행 가능한 줄의 최대 나쁨

@ 줄 나누기 프로시저의 심장은 `|try_break|'다. 이 서브루틴은 활성 목록을 훑으며 활성 노드에서 |cur_p|까지 어떤 텍스트 줄을
만들 수 있는지 보아서 현재 나눔점 |cur_p|가 실행 가능한지 검사한다. 실행 가능한 나눔이 있으면 새 나눔 노드를 만든다.
그리고 |cur_p|가 어떤 활성 노드에서 너무 멀면 그 노드를 비활성화한다.

서브루틴 |try_break|의 매개변수 |pi|는 |cur_p|에서 나누는 데 딸린 벌점이다. 나눔이 강제되면 |pi=eject_penalty|이고, 나눔이
허락되지 않으면 |pi=inf_penalty|다.

다른 매개변수 |break_type|은 현재 나눔이 |disc_node|에서 일어나는지에 따라 |hyphenated|나 |unhyphenated|다. 문단의 끝도
`|hyphenated|'로 여기는데, 이 경우는 조건 |cur_p=null|로 구별할 수 있다.

보충: 원본에서 |return|은 레이블 |exit|로 가는 것이고, 그 레이블 뒤에는 통계 코드가 있다. 그래서 이 함수에서는 원본의
|return|을 \GO/의 |return|이 아니라 |goto exit|로 옮긴다. 원본은 레이블 |deactivate|에 번호 60을 매기는 정의도 둔다.

@<|line_break|의 하위...@>=
func try_break(pi int32, break_type small_number) {
	var r pointer // 활성 목록을 훑는다
	var prev_r pointer // |r|보다 한 걸음 뒤에 머문다
	var old_l halfword // 현재 줄 동치류의 최대 줄 번호
	var no_break_yet bool // |cur_p|에서 실행 가능한 나눔을 찾았는가?
	@<|try_break|의 다른 지역 변수@>@;
	@<|pi|가 알맞은 범위에 있게 한다@>
	no_break_yet = true; prev_r = active; old_l = 0
	for k := int32(1); k <= 6; k++ {
		cur_active_width[k] = active_width[k] // |copy_to_cur_active|
	}
	for {
	continue_:
		r = link(prev_r)
		@<노드 |r|이 델타 노드이면 너비를 갱신하고 |goto continue_|@>
		@<줄 번호 부류가 끝났으면 새 활성 노드들을 만든다@>
		@<|r|에서 |cur_p|까지의 줄의 감점을 고려한다@>
	}
exit:
	if stat {
		@<|printed_node|의 값을 갱신한다@>
	}
}

@ @<|try_break|의 다른 지역 변수@>=
var prev_prev_r pointer // |type(prev_r)=delta_node|이면 |prev_r|보다 한 걸음 뒤
var s pointer // |cur_p| 앞쪽의 노드들을 훑는다
var q pointer // 새로 만드는 노드를 가리킨다
var v pointer // 글루 명세나 |cur_p| 앞쪽의 노드를 가리킨다
var t int32 // |cur_p|가 선택적 나눔 노드일 때의 노드 개수
var f internal_font_number // 문자 너비 계산에 쓴다
var l halfword // 현재 활성 노드의 줄 번호
var node_r_stays_active bool // 노드 |r|이 활성 목록에 남아야 하는가?
var line_width scaled // 현재 줄은 이 너비로 맞추어진다
var fit_class int32 // 시험 줄의 가능한 맞음새 분류, |very_loose_fit..tight_fit|
var b halfword // 시험 줄의 나쁨
var d int32 // 시험 줄의 감점
var artificial_demerits bool // |d|를 억지로 0으로 했는가?
var save_link pointer // |link(cur_p)|의 값을 잠시 담아 둔다
var shortfall scaled // 나쁨 계산에 쓴다

@ @<|pi|가 알맞은 범위에...@>=
if abs(pi) >= inf_penalty {
	if pi > 0 {
		goto exit // 이 나눔점은 무한 벌점으로 막혀 있다
	} else {
		pi = eject_penalty // 이 나눔점은 강제된다
	}
}

@ 다음 코드는 |type(last_active)!=delta_node|라는 사실을 이용한다.

@<노드 |r|이 델타 노드이면...@>=
@^inner loop@>
if type_(r) == delta_node {
	for k := int32(1); k <= 6; k++ {
		cur_active_width[k] = cur_active_width[k] + mem[r+k].sc // |update_width|
	}
	prev_prev_r = prev_r; prev_r = r; goto continue_
}

@ 주어진 줄 번호 부류 안에서 |cur_p|에서 줄을 끝내는 여러 방법을 고려하면서, 맞음새 분류마다 항목이 하나씩 있는 배열에 지금까지
알려진 가장 좋은 전체 감점을 기록해 둔다. 이를테면 |minimal_demerits[tight_fit]|에는 |tight_fit| 줄로 |cur_p|에서 끝나는
실행 가능한 줄 나눔들의 가장 적은 전체 감점이 들어 있다. 또 |best_place[tight_fit]|는 그런 최적을 이루는, |cur_p| 앞 나눔의 수동
노드를 가리키고, |best_pl_line[tight_fit]|은 |best_place[tight_fit]|에 대응하는 활성 노드의 |line_number| 필드다. 실행 가능한
나눔 나열이 알려지지 않았을 때는 |minimal_demerits| 항목이 $2^{30}-1$인 |awful_bad|와 같다. 또 다른 변수 |minimum_demerits|는
배열 |minimal_demerits|의 가장 작은 값을 기록한다.

@<전역 변수@>=
const @!awful_bad = 0o7777777777 // 십억이 넘는 감점

var @!minimal_demerits [tight_fit + 1]int32 // 맞음새별로 현재 줄 부류와 위치에 대해 알려진 가장 좋은 전체 감점
var @!minimum_demerits int32 // 현재 줄 부류와 위치에 대해 알려진 가장 좋은 전체 감점
var @!best_place [tight_fit + 1]pointer // |minimal_demerits|를 이루는 방법
var @!best_pl_line [tight_fit + 1]halfword // 대응하는 줄 번호

@ @<줄 나누기를 시작할...@>=
minimum_demerits = awful_bad
minimal_demerits[tight_fit] = awful_bad
minimal_demerits[decent_fit] = awful_bad
minimal_demerits[loose_fit] = awful_bad
minimal_demerits[very_loose_fit] = awful_bad

@ 다음 코드의 앞부분은 \TeX의 안쪽 루프의 일부이므로 시간을 조금도 낭비하고 싶지 않다. 현재 활성 노드, 곧 노드 |r|에는 다음에
고려할 줄 번호가 들어 있다. 목록의 끝에서는 |r=last_active|이고 |line_number(last_active)>old_l|이 되도록 자료 구조를
마련해 두었다.
@^inner loop@>

줄 번호 부류가 끝났으면 그 부류에서 찾은 가장 좋은 실행 가능한 나눔들을 위해 새 활성 노드를 만든다. 그런 다음
|r=last_active|이면 |goto exit|하고, 그렇지 않으면 새 |line_width|를 계산한다.

@<줄 번호 부류가 끝났으면...@>=
l = line_number(r)
if l > old_l { // 이제 안쪽 루프를 벗어났다
	if minimum_demerits < awful_bad && (old_l != easy_line || r == last_active) {
		@<방금 찾은 가장 좋은 실행 가능한 나눔들을 위해 새 활성 노드를 만든다@>
	}
	if r == last_active {
		goto exit
	}
	@<새 줄 너비를 계산한다@>
}

@ 감점 |minimal_demerits|가 |minimum_demerits+abs(adj_demerits)|보다 큰 새 활성 노드는 만들 필요가 없다. 그런 활성 노드는 마지막
문단 나눔에서 결코 선택되지 않을 것이기 때문이다. 이 관찰 덕분에 실행 가능한 나눔점 가운데 상당수를 더 고려하지 않아도 된다.

@<방금 찾은 가장 좋은...@>=
if no_break_yet {
	@<|break_width|의 값들을 계산한다@>
}
@<|cur_p|에서의 나눔을 준비하는 델타 노드를 넣는다@>
if abs(adj_demerits()) >= awful_bad-minimum_demerits {
	minimum_demerits = awful_bad - 1
} else {
	minimum_demerits = minimum_demerits + abs(adj_demerits())
}
for fit_class = very_loose_fit; fit_class <= tight_fit; fit_class++ {
	if minimal_demerits[fit_class] <= minimum_demerits {
		@<|best_place[fit_class]|에서 |cur_p|까지 새 활성 노드를 넣는다@>
	}
	minimal_demerits[fit_class] = awful_bad
}
minimum_demerits = awful_bad
@<다음 활성 노드를 준비하는 델타 노드를 넣는다@>

@ 노드 |cur_p|에서의 나눔을 위해 새 활성 노드를 넣을 때, 이 새 노드가 활성 노드 |a| 바로 앞에 놓인다고 하자. 그러면 본질적으로
`$\delta\,|cur_p|\,\delta^\prime$'을 |a| 앞에 넣고 싶은 것이다. 여기서 위에서 설명한 표기로 $\delta=\alpha(a)-\alpha(|cur_p|)$
이고 $\delta^\prime=\alpha(|cur_p|)-\alpha(a)$다. 배열 |cur_active_width|에는 지금 $\gamma+\beta(|cur_p|)-\alpha(a)$가 들어
있다. 그러므로 $\delta$는 양 $\gamma+\beta(|cur_p|)-\alpha(|cur_p|)$에서 |cur_active_width|를 빼서 얻을 수 있다. 뒤의 양은
``|cur_p|에서 |cur_p|까지'' 줄의 길이로 볼 수 있다. 우리는 이것을 |cur_p|에서의 |break_width|라고 부른다.

이 값 |break_width|는 대개 음수다. 이것은 바탕(대개 0)에서, 나눈 뒤에 없어지는 |cur_p| 다음 노드들의 너비를 뺀 것이기 때문이다.
이를테면 노드 |cur_p|가 글루 노드이면 이 글루의 너비를 바탕에서 빼고, 앞을 내다보아 뒤따르는 모든 글루, 벌점, 커닝, 수식
노드를 없애면서 그 너비도 뺀다.

커닝 노드는 |explicit|이 아니면 줄 나눔에서 사라지지 않는다.

@<|break_width|의 값들을...@>=
no_break_yet = false
for k := int32(1); k <= 6; k++ {
	break_width[k] = background[k] // |set_break_width_to_background|
}
s = cur_p
if break_type > unhyphenated && cur_p != null {
	@<선택적 나눔의 |break_width| 값들을 계산한다@>
}
for s != null {
	if is_char_node(s) {
		goto done
	}
	switch type_(s) {
	case glue_node: @<|break_width|에서 글루를 뺀다@>
	case penalty_node: // 아무것도 하지 않는다
	case math_node: break_width[1] = break_width[1] - width(s)
	case kern_node:
		if subtype(s) != explicit {
			goto done
		} else {
			break_width[1] = break_width[1] - width(s)
		}
	default: goto done
	}
	s = link(s)
}
done: ;

@ @<|break_width|에서 글루를...@>=
v = glue_ptr(s); break_width[1] = break_width[1] - width(v)
break_width[2+stretch_order(v)] = break_width[2+stretch_order(v)] - stretch(v)
break_width[6] = break_width[6] - shrink(v)

@ 노드 |cur_p|가 선택적 나눔이면, 다른 계산들이 맞아떨어지도록 ``|cur_p|에서 |cur_p|까지'' 줄의 길이를 제대로 정의해야 한다.
그리고 |cur_p|에서 나눔 앞 텍스트의 길이가 $l_0$, 나눔 뒤 텍스트의 길이가 $l_1$, 대체 텍스트의 길이가 |l|이라고 하자. 또 |q|가 대체
텍스트 다음의 노드라고 하자. 그러면 |cur_p|에서 |q|까지 줄의 길이는 $\gamma+\beta(q)-\alpha(|cur_p|)$로 계산되는데, 여기서
$\beta(q)=\beta(|cur_p|)-l_0+l$이다. 실제 길이는 바탕에 $l_1$을 더한 것이 될 것이므로, |cur_p|에서 |cur_p|까지의 길이는
$\gamma+l_0+l_1-l$이어야 한다. 선택적 나눔의 나눔 뒤 텍스트가 비어 있으면 나눔이 |q|를 버릴 수도 있다. 그런 드문 경우에는
|q|의 길이와, 선택적 나눔 뒤에 버려질 다른 노드들의 길이를 뺀다.

길이 $l_0$의 값은 계산할 필요가 없다. 프로시저 |line_break|가 |try_break|를 부르기 전에 그것을 전역 변수 |disc_width|에 넣어 두기 때문이다.

@<전역 변수@>=
var @!disc_width scaled // 나눔 앞에 있는 선택적 나눔 내용의 길이

@ @<선택적 나눔의 |break_width|...@>=
t = replace_count(cur_p); v = cur_p; s = post_break(cur_p)
for t > 0 {
	t--; v = link(v)
	@<|break_width|에서 노드 |v|의 너비를 뺀다@>
}
for s != null {
	@<|break_width|에 노드 |s|의 너비를 더한다@>
	s = link(s)
}
break_width[1] = break_width[1] + disc_width
if post_break(cur_p) == null {
	s = link(v) // 나눔 뒤에 버릴 수 있는 노드들이 있을 수 있다
}

@ 대체 텍스트와 선택적 나눔 텍스트에는 문자 노드, 커닝 노드, 합자 노드, 상자나 괘선 노드만 들어 있어야 한다.

@<|break_width|에서 노드 |v|의...@>=
if is_char_node(v) {
	f = font(v)
	break_width[1] = break_width[1] - char_width(f, char_info(f, character(v)))
} else {
	switch type_(v) {
	case ligature_node:
		f = font(lig_char(v))
		break_width[1] = break_width[1] - char_width(f, char_info(f, character(lig_char(v))))
	case hlist_node, vlist_node, rule_node, kern_node:
		break_width[1] = break_width[1] - width(v)
	default: confusion("disc1")
@:this can't happen disc1}{\quad disc1@>
	}
}

@ @<|break_width|에 노드 |s|의...@>=
if is_char_node(s) {
	f = font(s)
	break_width[1] = break_width[1] + char_width(f, char_info(f, character(s)))
} else {
	switch type_(s) {
	case ligature_node:
		f = font(lig_char(s))
		break_width[1] = break_width[1] + char_width(f, char_info(f, character(lig_char(s))))
	case hlist_node, vlist_node, rule_node, kern_node:
		break_width[1] = break_width[1] + width(s)
	default: confusion("disc2")
@:this can't happen disc2}{\quad disc2@>
	}
}

@ 여기서는 |type(active)!=delta_node|라는 사실을 이용한다.

@<|cur_p|에서의 나눔을 준비하는...@>=
if type_(prev_r) == delta_node { // 기존의 델타 노드를 고친다
	for k := int32(1); k <= 6; k++ { // |convert_to_break_width|
		mem[prev_r+k].sc = mem[prev_r+k].sc - cur_active_width[k] + break_width[k]
	}
} else if prev_r == active { // 처음에는 델타 노드가 필요 없다
	for k := int32(1); k <= 6; k++ {
		active_width[k] = break_width[k] // |store_break_width|
	}
} else {
	q = get_node(delta_node_size); set_link(q, r); set_type(q, delta_node)
	set_subtype(q, 0) // |subtype|은 쓰이지 않는다
	for k := int32(1); k <= 6; k++ {
		mem[q+k].sc = break_width[k] - cur_active_width[k] // |new_delta_to_break_width|
	}
	set_link(prev_r, q); prev_prev_r = prev_r; prev_r = q
}

@ 다음 코드를 수행할 때는 |r| 앞에 활성 노드를 적어도 하나 방금 넣었으므로 |type(prev_r)!=delta_node|다.

@<다음 활성 노드를 준비하는...@>=
if r != last_active {
	q = get_node(delta_node_size); set_link(q, r); set_type(q, delta_node)
	set_subtype(q, 0) // |subtype|은 쓰이지 않는다
	for k := int32(1); k <= 6; k++ {
		mem[q+k].sc = cur_active_width[k] - break_width[k] // |new_delta_from_break_width|
	}
	set_link(prev_r, q); prev_prev_r = prev_r; prev_r = q
}

@ 활성 노드를 만들 때 대응하는 수동 노드도 만든다.

@<|best_place[fit_class]|에서 |cur_p|까지...@>=
q = get_node(passive_node_size)
set_link(q, passive); passive = q; set_cur_break(q, cur_p)
if stat {
	pass_number++; set_serial(q, pass_number)
}
set_prev_break(q, best_place[fit_class])
q = get_node(active_node_size); set_break_node(q, passive)
set_line_number(q, best_pl_line[fit_class]+1)
set_fitness(q, fit_class); set_type(q, break_type)
set_total_demerits(q, minimal_demerits[fit_class])
set_link(q, r); set_link(prev_r, q); prev_r = q
if stat && tracing_paragraphs() > 0 {
	@<새 나눔 노드를 기호로 설명해 찍는다@>
}

@ @<새 나눔 노드를 기호로...@>=
print_nl("@@@@"); print_int(serial(passive))
@.\AT!\AT!@>
print(": line "); print_int(line_number(q) - 1)
print_char('.'); print_int(fit_class)
if break_type == hyphenated {
	print_char('-')
}
print(" t="); print_int(total_demerits(q))
print(" -> @@@@")
if prev_break(passive) == null {
	print_char('0')
} else {
	print_int(serial(prev_break(passive)))
}

@ 줄의 길이는 사용자가 \.{\\parshape}나 \.{\\hangindent}를 지정했는지에 따라 달라진다. 포인터 |par_shape_ptr|가 널이 아니면 그것은
|mem|의 $(2n+1)$낱말짜리 레코드를 가리키는데, 첫 낱말의 |info|에는 |n|의 값이 들어 있고, 나머지 $2n$ 낱말에는 문단의 처음
|n|줄의 왼쪽 여백과 줄 길이가 들어 있다. 그리고 |n|번째 줄의 지정은 그 뒤의 모든 줄에 적용된다. 그 포인터가 널이면 문단의
모양은 |n=hang_after|의 값에 따라 정해진다. 그리고 |n>=0|이면 매달린 들여쓰기가 |n+1|, |n+2|, \dots\ 줄에서 일어나고, 그렇지
않으면 1, \dots, $\vert n\vert$ 줄에서 일어난다. 매달린 들여쓰기가 작동할 때 왼쪽 여백은 |hang_indent>=0|이면
|hang_indent|이고 그렇지 않으면 0이다. 줄 길이는 $|hsize|-\vert|hang_indent|\vert$이다. 보통 설정은 |par_shape_ptr=null|,
|hang_after=1|, |hang_indent=0|이다. 들여쓰기가 |hang_indent=0|이면 |hang_after|의 값은 상관없다는 것에 주의하라.
@^length of lines@> @^hanging indentation@>

@<전역 변수@>=
var @!easy_line halfword // 나눔 노드에서 |>easy_line|인 줄 번호는 모두 같은 것으로 본다
var @!last_special_line halfword // |>last_special_line|인 줄 번호는 모두 너비가 같다
var @!first_width scaled // \.{\\parshape}가 지정되지 않았을 때 |<=last_special_line|인 모든 줄의 너비
var @!second_width scaled // |>last_special_line|인 모든 줄의 너비
var @!first_indent scaled // |first_width|와 함께 갈 왼쪽 여백
var @!second_indent scaled // |second_width|와 함께 갈 왼쪽 여백

@ 변수 |easy_line|의 값과 줄 길이에 관련된 다른 지역 변수의 값은 프로시저 |line_break|가 스스로를 초기화할 때 계산한다.

@<줄 나누기를 시작할...@>=
if par_shape_ptr() == null {
	if hang_indent() == 0 {
		last_special_line = 0; second_width = hsize()
		second_indent = 0
	} else {
		@<매달린 들여쓰기에 대비해 줄 길이 매개변수를 정한다@>
	}
} else {
	last_special_line = info(par_shape_ptr()) - 1
	second_width = mem[par_shape_ptr()+2*(last_special_line+1)].sc
	second_indent = mem[par_shape_ptr()+2*last_special_line+1].sc
}
if looseness() == 0 {
	easy_line = last_special_line
} else {
	easy_line = max_halfword
}

@ @<매달린 들여쓰기에 대비해...@>=
last_special_line = abs(hang_after())
if hang_after() < 0 {
	first_width = hsize() - abs(hang_indent())
	if hang_indent() >= 0 {
		first_indent = hang_indent()
	} else {
		first_indent = 0
	}
	second_width = hsize(); second_indent = 0
} else {
	first_width = hsize(); first_indent = 0
	second_width = hsize() - abs(hang_indent())
	if hang_indent() >= 0 {
		second_indent = hang_indent()
	} else {
		second_indent = 0
	}
}

@ 다음 코드에 이르렀을 때는 |line_number| 필드에 |l|이 들어 있는 첫 활성 노드~|r|을 방금 만난 것이다. 그래서 현재 문단의
$l\mskip1mu$번째 줄의 길이를 계산하고 싶다. 또 |old_l|을 |l|과 동치인 줄 번호 부류의 마지막 번호로 정하고 싶다.

@<새 줄 너비를...@>=
if l > easy_line {
	line_width = second_width; old_l = max_halfword - 1
} else {
	old_l = l
	if l > last_special_line {
		line_width = second_width
	} else if par_shape_ptr() == null {
		line_width = first_width
	} else {
		line_width = mem[par_shape_ptr()+2*l].sc
	}
}

@ 서브루틴 |try_break|의 나머지 부분은 |r|에서 |cur_p|까지 나누는 데 드는 감점의 계산을 다룬다.

먼저 할 일은 나쁨 |b|를 계산하는 것이다. 이 값은 언제나 0과 |inf_bad+1| 사이에 있다. 뒤의 값은 |r|에서 |cur_p|까지의 줄이
필요한 너비에 맞을 만큼 줄어들 수 없는 경우에만 나온다. 그런 경우 노드 |r|은 비활성화된다. 또 |cur_p|에서의 나눔이 강제될 때도
노드~|r|을 비활성화한다. 앞으로의 나눔은 강제된 나눔을 반드시 지나야 하기 때문이다.

노드 |r|이 더는 활성이지 않아야 하면 비활성화하고, |r|에서 |cur_p|까지의 줄이 실행 불가능하면 |goto continue_|하고, 그렇지
않으면 새 실행 가능한 나눔을 기록한다.

@<|r|에서 |cur_p|까지의 줄의 감점을...@>=
artificial_demerits = false
@^inner loop@>
shortfall = line_width - cur_active_width[1] // 이만큼 너무 짧다
if shortfall > 0 {
	@<줄을 늘일 때의 나쁨을 |b|에, 그에 맞는 |fit_class|를 정한다@>
} else {
	@<줄을 줄일 때의 나쁨을 |b|에, 그에 맞는 |fit_class|를 정한다@>
}
if b > inf_bad || pi == eject_penalty {
	@<노드~|r|의 비활성화를 준비하고, 까닭이 없으면 |goto deactivate|@>
} else {
	prev_r = r
	if b > threshold {
		goto continue_
	}
	node_r_stays_active = true
}
@<새 실행 가능한 나눔을 기록한다@>
if node_r_stays_active {
	goto continue_ // |prev_r|는 |r|로 정해져 있다
}
deactivate:
	@<노드 |r|을 비활성화한다@>

@ 줄을 늘여야 할 때, 쓸 수 있는 늘일 수 있는 양은 부분 배열 |cur_active_width[2..5]|에 pt, fil, fill, filll 단위로 있다.

이 절은 \TeX의 안쪽 루프의 일부이고, 나쁨이 무한일 때 가장 자주 수행된다. 그래서 서브루틴 |badness|를 부르기 전에 너비
초과가 크고 늘일 수 있는 양이 작은지 재빨리 검사해 볼 만하다.
@^inner loop@>

@<줄을 늘일 때의...@>=
if cur_active_width[3] != 0 || cur_active_width[4] != 0 || cur_active_width[5] != 0 {
	b = 0; fit_class = decent_fit // 무한 늘어남
} else {
	if shortfall > 7230584 && cur_active_width[2] < 1663497 {
		b = inf_bad; fit_class = very_loose_fit; goto done1
	}
	b = badness(shortfall, cur_active_width[2])
	if b > 12 {
		if b > 99 {
			fit_class = very_loose_fit
		} else {
			fit_class = loose_fit
		}
	} else {
		fit_class = decent_fit
	}
done1: ;
}

@ 문단 안에서 줄어듦은 결코 무한이 아니다. 그래서 |r|에서 |cur_p|까지의 줄은 많아야 |cur_active_width[6]|만큼 줄일 수 있다.

@<줄을 줄일 때의...@>=
if -shortfall > cur_active_width[6] {
	b = inf_bad + 1
} else {
	b = badness(-shortfall, cur_active_width[6])
}
if b > 12 { fit_class = tight_fit } else { fit_class = decent_fit }

@ 마지막 훑기에서는 활성 노드를 모두 잃는 모험을 해서는 안 된다. 그러면 이미 찾은 줄 나눔들과의 끈을 잃기 때문이다. 여기 보인
코드는 넘치는 상자를 마지막 수단으로 허락해서 그런 파국이 일어나지 않게 한다. \TeX의 이 부분은 올바른 프로그램 논리를 마침내
찾아내기 전까지 여러 미묘한 버그의 근원이었다. 그러니 \TeX을 ``개선''하려는 독자는 여기서 무엇이든 감히 바꾸기 전에 세 번
생각해야 한다.
@^overfull boxes@>

@<노드~|r|의 비활성화를 준비하고...@>=
if final_pass && minimum_demerits == awful_bad && link(r) == last_active && prev_r == active {
	artificial_demerits = true // 감점을 0으로 한다. 이 나눔은 강제된다
} else if b > threshold {
	goto deactivate
}
node_r_stays_active = false

@ 코드의 이 부분에 이르면 |r|에서 |cur_p|까지의 줄은 실행 가능하고, 그 나쁨은~|b|이며, 맞음새 분류는 |fit_class|다. 이
나눔을 위한 활성 노드를 아직 만들고 싶지는 않지만, 전체 감점을 계산해서, 이 나눔이 주어진 줄 번호 부류와 맞음새 부류에서
|cur_p|에 이르는 모든 길 가운데 현재 챔피언이면 배열 |minimal_demerits|에 기록한다.

@<새 실행 가능한 나눔을...@>=
if artificial_demerits {
	d = 0
} else {
	@<|r|에서 |cur_p|까지의 감점 |d|를 계산한다@>
}
if stat && tracing_paragraphs() > 0 {
	@<이 실행 가능한 나눔을 기호로 설명해 찍는다@>
}
d = d + total_demerits(r) // 이것은 처음부터 |r|을 거쳐 |cur_p|까지의 최소 전체 감점이다
if d <= minimal_demerits[fit_class] {
	minimal_demerits[fit_class] = d
	best_place[fit_class] = break_node(r); best_pl_line[fit_class] = l
	if d < minimum_demerits {
		minimum_demerits = d
	}
}

@ @<이 실행 가능한 나눔을 기호로...@>=
if printed_node != cur_p {
	@<|printed_node|와 |cur_p| 사이의 목록을 찍고 |printed_node:=cur_p|로 한다@>
}
print_nl("@@")
@.\AT!@>
if cur_p == null {
	print_esc("par")
} else if type_(cur_p) != glue_node {
	if type_(cur_p) == penalty_node {
		print_esc("penalty")
	} else if type_(cur_p) == disc_node {
		print_esc("discretionary")
	} else if type_(cur_p) == kern_node {
		print_esc("kern")
	} else {
		print_esc("math")
	}
}
print(" via @@@@")
if break_node(r) == null { print_char('0') } else { print_int(serial(break_node(r))) }
print(" b=")
if b > inf_bad { print_char('*') } else { print_int(b) }
@.*\relax@>
print(" p="); print_int(pi); print(" d=")
if artificial_demerits { print_char('*') } else { print_int(d) }

@ @<|printed_node|와 |cur_p| 사이의...@>=
print_nl("")
if cur_p == null {
	short_display(link(printed_node))
} else {
	save_link = link(cur_p)
	set_link(cur_p, null); print_nl(""); short_display(link(printed_node))
	set_link(cur_p, save_link)
}
printed_node = cur_p

@ 선택적 나눔의 자료를 보여 줄 때는 |pre_break|와 |post_break| 목록을 이미 찍었을 것이다. 셋째 목록은 건너뛰어서 선택적 나눔
자료가 두 번 나타나지 않게 하고 싶다. 다음 코드는 |try_break|의 맨 끝에서 수행된다.

@<|printed_node|의 값을...@>=
if cur_p == printed_node && cur_p != null && type_(cur_p) == disc_node {
	t = replace_count(cur_p)
	for t > 0 {
		t--; printed_node = link(printed_node)
	}
}

@ @<|r|에서 |cur_p|까지의 감점...@>=
d = line_penalty() + b
if abs(d) >= 10000 { d = 100000000 } else { d = d * d }
if pi != 0 {
	if pi > 0 {
		d = d + pi*pi
	} else if pi > eject_penalty {
		d = d - pi*pi
	}
}
if break_type == hyphenated && type_(r) == hyphenated {
	if cur_p != null {
		d = d + double_hyphen_demerits()
	} else {
		d = d + final_hyphen_demerits()
	}
}
if abs(fit_class-fitness(r)) > 1 {
	d = d + adj_demerits()
}

@ 활성 노드가 사라질 때, 그 활성 노드가 활성 목록의 처음이나 끝에 있었거나 델타 노드들로 둘러싸여 있었으면 이웃한 델타
노드를 지워야 한다. 또 |cur_active_width|가 |link(prev_r)|에서 |cur_p|까지 내용의 길이를 나타낸다는 성질도 지켜야 한다.

@<노드 |r|을 비활성화한다@>=
set_link(prev_r, link(r)); free_node(r, active_node_size)
if prev_r == active {
	@<첫 활성 노드가 지워졌으므로 활성 너비들을 갱신한다@>
} else if type_(prev_r) == delta_node {
	r = link(prev_r)
	if r == last_active {
		for k := int32(1); k <= 6; k++ {
			cur_active_width[k] = cur_active_width[k] - mem[prev_r+k].sc // |downdate_width|
		}
		set_link(prev_prev_r, last_active)
		free_node(prev_r, delta_node_size); prev_r = prev_prev_r
	} else if type_(r) == delta_node {
		for k := int32(1); k <= 6; k++ {
			cur_active_width[k] = cur_active_width[k] + mem[r+k].sc // |update_width|
		}
		for k := int32(1); k <= 6; k++ {
			mem[prev_r+k].sc = mem[prev_r+k].sc + mem[r+k].sc // |combine_two_deltas|
		}
		set_link(prev_r, link(r)); free_node(r, delta_node_size)
	}
}

@ 다음 코드는 |type(last_active)!=delta_node|라는 사실을 이용한다. 활성 목록이 방금 비었으면 배열 |active_width|를 갱신할
필요가 없다. 다음에 활성 노드를 넣을 때 초기화될 것이기 때문이다.

@<첫 활성 노드가 지워졌으므로...@>=
r = link(active)
if type_(r) == delta_node {
	for k := int32(1); k <= 6; k++ {
		active_width[k] = active_width[k] + mem[r+k].sc // |update_active|
	}
	for k := int32(1); k <= 6; k++ {
		cur_active_width[k] = active_width[k] // |copy_to_cur_active|
	}
	set_link(active, link(r)); free_node(r, delta_node_size)
}

@* 문단을 줄로 나누기, 계속.
지금까지 |line_break| 루틴에 조금 들어가서 그 중요한 서브루틴 |try_break|를 다루었다. 이제 나머지 과정을 살펴보자.

프로시저 |line_break|의 주 루프는 |link(temp_head)|에서 시작하는 주어진 가로 목록을 지나가며 합법적인 나눔점마다 |try_break|를 부른다.
변수 |auto_breaking|은 수식 안이 아니면 참이다. 수식 안에 나타나는 글루 노드는 합법적인 나눔점이 아니기 때문이다.

가로 목록에서 지금 관심 있는 노드는 |cur_p|가 가리킨다. 또 다른 변수 |prev_p|는 대개 |cur_p|보다 한 걸음 뒤에 있지만,
그 참뜻은 이렇다. 노드 |cur_p|가 글루 노드이면(|type(cur_p)=glue_node|), |auto_breaking|이 참이고 |prev_p|가 글루 노드, 벌점 노드, 명시적 커닝
노드, 수식 노드를 가리키지 않을 때, 그리고 오직 그때에만 |cur_p|가 합법적인 나눔점이다.

다음 선언은 특별한 계산에 쓰이는 몇몇 다른 지역 변수를 마련한다.

@<줄 나누기의 지역 변수@>=
var auto_breaking bool // 노드 |cur_p|가 수식 바깥에 있는가?
var prev_p pointer // 글루 노드가 언제 나눔점인지 정하는 것을 돕는다
var q, r, s, prev_s pointer // 잠깐 관심 있는 여러 노드
var f internal_font_number // 문자 너비를 계산할 때 쓴다

@ 다음 코드의 `\ignorespaces|for|\unskip' 루프는 |line_break|를 한 번 부를 때마다 많아야 세 번 수행된다. 실은 문단 전체를
한 번 훑는 것이기 때문이다.

@<최적의 나눔점들을...@>=
threshold = pretolerance()
if threshold >= 0 {
	if stat && tracing_paragraphs() > 0 {
		begin_diagnostic(); print_nl("@@firstpass")
	}
	second_pass = false; final_pass = false
} else {
	threshold = tolerance(); second_pass = true
	final_pass = emergency_stretch() <= 0
	if stat && tracing_paragraphs() > 0 {
		begin_diagnostic()
	}
}
for {
	if threshold > inf_bad {
		threshold = inf_bad
	}
	if second_pass {
		@<문단에 하이픈을 넣을 준비를 한다@>
	}
	@<문단의 처음을 나타내는 활성 나눔점을 만든다@>
	cur_p = link(temp_head); auto_breaking = true
	prev_p = cur_p // 처음의 글루는 합법적인 나눔점이 아니다
	for cur_p != null && link(active) != last_active {
		@<|cur_p|가 합법적인 나눔점이면 |try_break|를 부르고 다음으로 나아간다@>
	}
	if cur_p == null {
		@<문단 끝에서 마지막 줄 나눔을 시도하고, 원하는 나눔점들을 찾았으면 |goto done|@>
	}
	@<나눔 노드들을 없애 메모리를...@>
	@<다음 훑기를 준비한다@>
}
done:
	if stat && tracing_paragraphs() > 0 {
		end_diagnostic(true); normalize_selector()
	}

@ \dg 앞 절에 이어서, 첫째 훑기가 실패했으면 둘째 훑기를, 둘째 훑기도 실패했으면 비상 훑기를 준비한다.

@<다음 훑기를...@>=
if !second_pass {
	if stat && tracing_paragraphs() > 0 {
		print_nl("@@secondpass")
	}
	threshold = tolerance(); second_pass = true; final_pass = emergency_stretch() <= 0
} else { // 처음에 성공하지 못하면, \dots
	if stat && tracing_paragraphs() > 0 {
		print_nl("@@emergencypass")
	}
	background[2] = background[2] + emergency_stretch(); final_pass = true
}

@ 시작점을 나타내는 활성 노드에는 대응하는 수동 노드가 필요 없다.

@<문단의 처음을 나타내는...@>=
q = get_node(active_node_size)
set_type(q, unhyphenated); set_fitness(q, decent_fit)
set_link(q, last_active); set_break_node(q, null)
set_line_number(q, prev_graf+1); set_total_demerits(q, 0); set_link(active, q)
for k := int32(1); k <= 6; k++ {
	active_width[k] = background[k] // |store_background|
}
passive = null; printed_node = temp_head; pass_number = 0
font_in_short_display = null_font

@ @<나눔 노드들을 없애...@>=
q = link(active)
for q != last_active {
	cur_p = link(q)
	if type_(q) == delta_node {
		free_node(q, delta_node_size)
	} else {
		free_node(q, active_node_size)
	}
	q = cur_p
}
q = passive
for q != null {
	cur_p = link(q)
	free_node(q, passive_node_size)
	q = cur_p
}

@ 다음은 |line_break| 루틴의 주 갈래로, 여기서 합법적인 나눔이 정해진다. 가로 목록을 지나가면서 배열 |active_width|를 늘
최신으로 유지해서, |try_break|가 각 줄의 나쁨을 쉽게 계산할 수 있게 해야 한다. 활성 너비 가운데 글루가 아닌 실제 너비를
나타내는 성분에 짧은 이름 |act_width|를 쓰면 편리하다.

노드 |cur_p|가 합법적인 나눔점이면 |try_break|를 부르고, 둘째 훑기에서 |cur_p|가 글루 노드이면 다음 낱말에 하이픈을 넣어 본다. 그런
다음 |cur_p|를 문단에서 합법적인 나눔점일 수 있는 다음 노드로 옮긴다.

보충: 원본의 |act_width|는 |active_width[1]|을 가리키는 매크로다. 대입할 수 있어야 하므로 이 번역에서는 |active_width[1]|이라고
바로 쓴다. 원본의 매크로 |kern_break|는 두 곳에서 쓰이므로 이름 있는 절로 옮긴다(다음의 덧붙인 절).

@<|cur_p|가 합법적인 나눔점이면 |try_break|를 부르고 다음으로 나아간다@>=
if is_char_node(cur_p) {
	@<|cur_p|를 지금 문자열 다음의 노드로 옮긴다@>
}
switch type_(cur_p) {
case hlist_node, vlist_node, rule_node: active_width[1] = active_width[1] + width(cur_p)
case whatsit_node: @<|line_break| 루프에서 whatsit 노드를 지나간다@>
case glue_node:
	@<|cur_p|가 합법적인 나눔점이면 |try_break|를 부르고 글루를 활성 너비에 넣는다@>
	if second_pass && auto_breaking {
		@<다음 낱말에 하이픈을 넣어 본다@>
	}
case kern_node:
	if subtype(cur_p) == explicit {
		@<|kern_break|를 한다@>
	} else {
		active_width[1] = active_width[1] + width(cur_p)
	}
case ligature_node:
	f = font(lig_char(cur_p))
	active_width[1] = active_width[1] + char_width(f, char_info(f, character(lig_char(cur_p))))
case disc_node: @<선택적 나눔 조각 뒤에서 나누어 보고 |goto done5|@>
case math_node: auto_breaking = subtype(cur_p) == after; @<|kern_break|를 한다@>
case penalty_node: try_break(penalty(cur_p), unhyphenated)
case mark_node, ins_node, adjust_node: // 아무것도 하지 않는다
default: confusion("paragraph")
@:this can't happen paragraph}{\quad paragraph@>
}
prev_p = cur_p; cur_p = link(cur_p)
done5: ;

@ \dg 원본의 매크로 |kern_break|다. 커닝이나 수식 노드 뒤에 바로 글루가 오면 그 자리에서 나누어 보고, 그 노드의 너비를 더한다.

@<|kern_break|를 한다@>=
if !is_char_node(link(cur_p)) && auto_breaking {
	if type_(link(cur_p)) == glue_node {
		try_break(0, unhyphenated)
	}
}
active_width[1] = active_width[1] + width(cur_p)

@ 문단의 낱말 문자들을 지나가는 코드는 \TeX의 안쪽 루프의 일부이므로 속도를 위해 다듬어 두었다. 각 문단 끝에
`\.{\\parfillskip}' 글루가 나타난다는 사실을 이용한다. 그래서 |cur_p|가 문자 노드일 때 |link(cur_p)=null|인지 검사할 필요가 없다.
@^inner loop@>

@<|cur_p|를 지금 문자열...@>=
prev_p = cur_p
for {
	f = font(cur_p)
	active_width[1] = active_width[1] + char_width(f, char_info(f, character(cur_p)))
	cur_p = link(cur_p)
	if !is_char_node(cur_p) {
		break
	}
}

@ 노드 |cur_p|가 글루 노드이면, 위에서 설명했듯이 |prev_p|를 보아서 |cur_p|에서 나누는 것이 합법적인지 알아본다. 그런 다음
|glue_ptr(cur_p)|의 글루를 넣어 활성 너비를 갱신한다.

@<|cur_p|가 합법적인 나눔점이면 |try_break|를 부르고 글루를...@>=
if auto_breaking {
	if is_char_node(prev_p) {
		try_break(0, unhyphenated)
	} else if precedes_break(prev_p) {
		try_break(0, unhyphenated)
	} else if type_(prev_p) == kern_node && subtype(prev_p) != explicit {
		try_break(0, unhyphenated)
	}
}
if shrink_order(glue_ptr(cur_p)) != normal && shrink(glue_ptr(cur_p)) != 0 {
	set_glue_ptr(cur_p, finite_shrink(glue_ptr(cur_p))) // |check_shrinkage|
}
q = glue_ptr(cur_p)
active_width[1] = active_width[1] + width(q)
active_width[2+stretch_order(q)] = active_width[2+stretch_order(q)] + stretch(q)
active_width[6] = active_width[6] + shrink(q)

@ 다음 코드는 선택적 나눔 텍스트에 문자 노드, 커닝 노드, 상자 노드, 괘선 노드, 합자 노드만 들어 있다는 것을 안다.

@<선택적 나눔 조각 뒤에서...@>=
s = pre_break(cur_p); disc_width = 0
if s == null {
	try_break(ex_hyphen_penalty(), hyphenated)
} else {
	for {
		@<|disc_width|에 노드 |s|의 너비를 더한다@>
		s = link(s)
		if s == null {
			break
		}
	}
	active_width[1] = active_width[1] + disc_width
	try_break(hyphen_penalty(), hyphenated)
	active_width[1] = active_width[1] - disc_width
}
r = replace_count(cur_p); s = link(cur_p)
for r > 0 {
	@<|act_width|에 노드 |s|의 너비를 더한다@>
	r--; s = link(s)
}
prev_p = cur_p; cur_p = s; goto done5

@ @<|disc_width|에 노드 |s|의...@>=
if is_char_node(s) {
	f = font(s)
	disc_width = disc_width + char_width(f, char_info(f, character(s)))
} else {
	switch type_(s) {
	case ligature_node:
		f = font(lig_char(s))
		disc_width = disc_width + char_width(f, char_info(f, character(lig_char(s))))
	case hlist_node, vlist_node, rule_node, kern_node:
		disc_width = disc_width + width(s)
	default: confusion("disc3")
@:this can't happen disc3}{\quad disc3@>
	}
}

@ @<|act_width|에 노드 |s|의...@>=
if is_char_node(s) {
	f = font(s)
	active_width[1] = active_width[1] + char_width(f, char_info(f, character(s)))
} else {
	switch type_(s) {
	case ligature_node:
		f = font(lig_char(s))
		active_width[1] = active_width[1] + char_width(f, char_info(f, character(lig_char(s))))
	case hlist_node, vlist_node, rule_node, kern_node:
		active_width[1] = active_width[1] + width(s)
	default: confusion("disc4")
@:this can't happen disc4}{\quad disc4@>
	}
}

@ 문단 끝의 강제 줄 나눔은 나눔점 목록을 줄여서, 모든 활성 노드가 |cur_p=null|에서의 나눔을 나타내게 한다. 첫째 훑기에서는
올바른 ``느슨함''(looseness)을 가진 활성 노드를 찾아야만 한다. 마지막 훑기에서는 활성 노드가 적어도 하나 있을 것이고, 원하는
느슨함에 될 수 있는 대로 잘 맞춘다.

전역 변수 |best_bet|은 문단을 나누는 가장 좋은 방법을 나타내는 활성 노드로 정해지고, 몇몇 다른 변수가 무엇이 가장 좋은지
정하는 것을 돕는다.

@<전역 변수@>=
var @!best_bet pointer // 이 수동 노드와 그 앞의 것들을 쓴다
var @!fewest_demerits int32 // |best_bet|에 딸린 감점
var @!best_line halfword // 새 문단의 마지막 줄 다음의 줄 번호
var @!actual_looseness int32 // |line_number(best_bet)|와 최적의 |best_line|의 차이
var @!line_diff int32 // 현재 줄 번호와 최적의 |best_line|의 차이

@ @<문단 끝에서 마지막 줄 나눔을...@>=
try_break(eject_penalty, hyphenated)
if link(active) != last_active {
	@<감점이 가장 적은 활성 노드를 찾는다@>
	if looseness() == 0 {
		goto done
	}
	@<원하는 느슨함에 가장 좋은 활성 노드를 찾는다@>
	if actual_looseness == looseness() || final_pass {
		goto done
	}
}

@ @<감점이 가장 적은...@>=
r = link(active); fewest_demerits = awful_bad
for {
	if type_(r) != delta_node && total_demerits(r) < fewest_demerits {
		fewest_demerits = total_demerits(r); best_bet = r
	}
	r = link(r)
	if r == last_active {
		break
	}
}
best_line = line_number(best_bet)

@ 원하는 느슨함에 맞추는 조정은 방금 본 루프를 조금 더 복잡하게 한 것이다. 문단이 따로 세운 수식으로 여러 토막으로 나뉘면, 각
토막이 다른 토막과 상관없이 따로 느슨함 계산을 받는다는 것에 주의하라.

@<원하는 느슨함에 가장 좋은...@>=
r = link(active); actual_looseness = 0
for {
	if type_(r) != delta_node {
		line_diff = line_number(r) - best_line
		if (line_diff < actual_looseness && looseness() <= line_diff) ||
			(line_diff > actual_looseness && looseness() >= line_diff) {
			best_bet = r; actual_looseness = line_diff
			fewest_demerits = total_demerits(r)
		} else if line_diff == actual_looseness && total_demerits(r) < fewest_demerits {
			best_bet = r; fewest_demerits = total_demerits(r)
		}
	}
	r = link(r)
	if r == last_active {
		break
	}
}
best_line = line_number(best_bet)

@ 가장 좋은 나눔점 나열을 찾고 나면(만세!) 프로시저 |post_line_break|를 불러 나머지 일을 마무리한다. (이 하위 프로시저를
들여온 덕분에 |line_break|가 지나치게 길어지지 않게 할 수 있다.)

@<고른 나눔점들에서...@>=
post_line_break(final_widow_penalty)

@ 프로시저 |post_line_break|가 조판할 줄의 전체 수는 |best_line-prev_graf-1|이다. 마지막 나눔점은 |break_node(best_bet)|로 지정되고,
이 수동 노드는 |prev_break| 링크를 거쳐 다른 나눔점들을 가리킨다. 마무리 단계는 관련된 수동 노드들을 앞으로 가는 차례로
잇는 것으로 시작한다. 곧 |prev_break|를 |next_break|로 바꾸는 것이다. (필드 |next_break|는 실제로 |prev_break| 필드가 있던 같은
메모리 공간에 있지만, 새 뜻을 가지므로 새 이름을 준다.) 그런 다음 줄들을 하나씩 맞춘다.

@<|line_break|의 하위...@>=
func next_break(p pointer) pointer { return prev_break(p) } // 링크를 뒤집은 뒤 |prev_break|의 새 이름
func set_next_break(p pointer, v pointer) { set_prev_break(p, v) }

func post_line_break(final_widow_penalty int32) {
	var q, r, s pointer // 목록을 다루는 임시 레지스터들
	var disc_break bool // 현재 나눔이 선택적 나눔 노드에서 일어났는가?
	var post_disc_break bool // 그리고 그 나눔 뒤 부분이 비어 있지 않았는가?
	var cur_width scaled // 줄 번호 |cur_line|의 너비
	var cur_indent scaled // 줄 번호 |cur_line|의 왼쪽 여백
	var t quarterword // 선택적 나눔 노드의 대체 개수에 쓴다
	var pen int32 // 줄 사이 벌점을 계산할 때 쓴다
	var cur_line halfword // 지금 맞추고 있는 줄 번호
	@<관련된 수동 노드들의 링크를 뒤집고 |cur_p|를 첫 나눔점으로 한다@>
	cur_line = prev_graf + 1
	for {
		@<나눔점 |cur_p|에서 끝나는 줄을 맞추어 현재 세로 목록에 덧붙인다@>
		cur_line++; cur_p = next_break(cur_p)
		if cur_p != null && !post_disc_break {
			@<다음 줄의 처음에서 원하지 않는 노드들을 쳐낸다@>
		}
		if cur_p == null {
			break
		}
	}
	if cur_line != best_line || link(temp_head) != null {
		confusion("line breaking")
	}
@:this can't happen line breaking}{\quad line breaking@>
	prev_graf = best_line - 1
}

@ 목록의 링크를 뒤집는 일은 한 스택에서 항목을 꺼내 다른 스택에 넣는 일로 보면 편리하다. 여기서는 |q|가 가리키고 |prev_break|
필드를 가진 스택에서 꺼내서, |cur_p|가 가리키고 |next_break| 필드를 가진 스택에 넣는다. 노드 |r|은 한 스택에서 다른 스택으로
옮기고 있는 수동 노드다.

@<관련된 수동 노드들의...@>=
q = break_node(best_bet); cur_p = null
for {
	r = q; q = prev_break(q); set_next_break(r, cur_p); cur_p = r
	if q == null {
		break
	}
}

@ 줄의 처음에서는 글루, 벌점, 커닝, 수식 노드를 지운다. 다만 지울 노드가 실은 고른 나눔점 가운데 하나인 변칙적인 경우는
예외다. 여기서 하는 쳐내기는 |try_break|의 내다보기 계산, 곧 선택적 나눔이 아닌 나눔점에 대해 |break_width| 값을 계산하는
것과 맞도록 설계되어 있다.

@<다음 줄의 처음에서...@>=
r = temp_head
for {
	q = link(r)
	if q == cur_break(cur_p) {
		goto done1 // |cur_break(cur_p)|는 다음 나눔점이다
	}
	// 이제 |q|는 |null|일 수 없다
	if is_char_node(q) {
		goto done1
	}
	if non_discardable(q) {
		goto done1
	}
	if type_(q) == kern_node && subtype(q) != explicit {
		goto done1
	}
	r = q // 이제 |type(q)=glue_node|, |kern_node|, |math_node|, |penalty_node|
}
done1:
	if r != temp_head {
		set_link(r, null); flush_node_list(link(temp_head))
		set_link(temp_head, q)
	}

@ 맞출 현재 줄은 |link(temp_head)|에서 시작해 |cur_break(cur_p)|에서 끝나는 가로 목록에 있다. 그 끝 노드 |cur_break(cur_p)|가 글루
노드이면 그 글루를 |right_skip| 글루와 같게 다시 정한다. 그렇지 않으면 오른쪽에 |right_skip| 글루를 덧붙인다.
끝 노드가 선택적 나눔 노드이면 그 나눔이 강제되도록 목록을 고치고 |disc_break|를 |true|로 한다. 그리고 줄의 왼쪽에는,
0이 아니면 |left_skip| 글루를 덧붙인다.

나눔점 |cur_p|에서 끝나는 줄을 맞추어 현재 세로 목록에 덧붙이면서, 거기 딸린 벌점과 다른 삽입물도 함께 덧붙인다.

@<나눔점 |cur_p|에서 끝나는 줄을...@>=
@<나눔의 성질을 반영해 줄 끝을 고치고 \.{\\rightskip}을 넣는다@>
@<\.{\\leftskip} 글루를 왼쪽에 놓고 이 줄을 떼어 낸다@>
@<묶기 서브루틴을 불러 |just_box|를 맞춘 상자로 한다@>
@<새 상자를 현재 세로 목록에 덧붙이고, 묶개가 꺼낸 특별한 노드들을 잇는다@>
@<알맞으면 0이 아닌 벌점 노드를 덧붙인다@>

@ 다음 코드의 끝에서 |q|는 맞추려는 목록의 마지막 노드를 가리킨다. 이 코드는 |disc_break|의 알맞은 값도 정한다.

@<나눔의 성질을 반영해...@>=
q = cur_break(cur_p); disc_break = false; post_disc_break = false
if q != null { // |q|는 |char_node|일 수 없다
	if type_(q) == glue_node {
		delete_glue_ref(glue_ptr(q))
		set_glue_ptr(q, right_skip())
		set_subtype(q, right_skip_code+1); add_glue_ref(right_skip())
		goto done
	} else {
		if type_(q) == disc_node {
			@<선택적 나눔을 강제 나눔으로 바꾸고 |disc_break:=true|로 한다@>
		} else if type_(q) == math_node || type_(q) == kern_node {
			set_width(q, 0)
		}
	}
} else {
	q = temp_head
	for link(q) != null {
		q = link(q)
	}
}
@<노드 |q| 뒤에 \.{\\rightskip} 글루를 놓는다@>
done:

@ @<선택적 나눔을 강제 나눔으로...@>=
t = replace_count(q)
@<|q| 뒤의 노드 |t|개를 없애고 |r|이 그 다음 노드를 가리키게 한다@>
if post_break(q) != null {
	@<나눔 뒤 목록을 옮겨 심는다@>
}
if pre_break(q) != null {
	@<나눔 앞 목록을 옮겨 심는다@>
}
set_link(q, r); disc_break = true

@ @<|q| 뒤의 노드 |t|개를...@>=
if t == 0 {
	r = link(q)
} else {
	r = q
	for t > 1 {
		r = link(r); t--
	}
	s = link(r)
	r = link(s); set_link(s, null)
	flush_node_list(link(q)); set_replace_count(q, 0)
}

@ 나눔 뒤 목록을 노드 |q| 안에서 주 목록으로 옮기는데, 지금 노드 |r| 바로 앞에 다시 붙이고 |r|을 다시 정한다.

@<나눔 뒤 목록을...@>=
s = post_break(q)
for link(s) != null {
	s = link(s)
}
set_link(s, r); r = post_break(q); set_post_break(q, null); post_disc_break = true

@ 나눔 앞 목록을 노드 |q| 안에서 주 목록으로 옮기는데, 지금 노드 |q| 바로 뒤에 다시 붙이고 |q|를 다시 정한다.

@<나눔 앞 목록을...@>=
s = pre_break(q); set_link(q, s)
for link(s) != null {
	s = link(s)
}
set_pre_break(q, null); q = s

@ @<노드 |q| 뒤에 \.{\\rightskip}...@>=
r = new_param_glue(right_skip_code); set_link(r, link(q)); set_link(q, r); q = r

@ 다음 코드는 |q|가 맞출 목록의 끝에 있는 채로 시작한다. 끝날 때는 |q|가 그 목록의 처음에 있고, |link(temp_head)|는 문단의
나머지가 있으면 그것을 가리킨다.

@<\.{\\leftskip} 글루를 왼쪽에...@>=
r = link(q); set_link(q, null); q = link(temp_head); set_link(temp_head, r)
if left_skip() != zero_glue {
	r = new_param_glue(left_skip_code)
	set_link(r, q); q = r
}

@ @<새 상자를 현재 세로 목록에...@>=
append_to_vlist(just_box)
if adjust_head != adjust_tail {
	set_link(tail, link(adjust_head)); tail = adjust_tail
}
adjust_tail = null

@ 이제 |q|는 문단의 현재 줄을 나타내는 가로 목록을 가리킨다. 알맞은 줄 너비를 계산하고, 줄을 그 크기의 상자로 묶고, 상자를
알맞은 들여쓰기 양만큼 옮겨야 한다.

@<묶기 서브루틴을 불러...@>=
if cur_line > last_special_line {
	cur_width = second_width; cur_indent = second_indent
} else if par_shape_ptr() == null {
	cur_width = first_width; cur_indent = first_indent
} else {
	cur_width = mem[par_shape_ptr()+2*cur_line].sc
	cur_indent = mem[par_shape_ptr()+2*cur_line-1].sc
}
adjust_tail = adjust_head; just_box = hpack(q, cur_width, exactly)
set_shift_amount(just_box, cur_indent)

@ 문단의 줄 사이 벌점은 클럽 줄과 과부 줄(club and widow lines)에서, 매개변수 |inter_line_penalty|에서, 그리고 선택적
나눔에서 끝나는 줄에서 온다. 두 줄짜리 문단의 줄 사이에서 나누면 클럽 줄과 과부 줄 벌점을 둘 다 받는다. 지역 변수 |pen|은
현재 줄에 관련된 모든 벌점의 합으로 정해진다. 다만 마지막 줄에는 결코 벌점을 매기지 않는다.

@<알맞으면 0이 아닌 벌점...@>=
if cur_line+1 != best_line {
	pen = inter_line_penalty()
	if cur_line == prev_graf+1 {
		pen = pen + club_penalty()
	}
	if cur_line+2 == best_line {
		pen = pen + final_widow_penalty
	}
	if disc_break {
		pen = pen + broken_penalty()
	}
	if pen != 0 {
		r = new_penalty(pen)
		set_link(tail, r); tail = r
	}
}

@* 하이픈 넣기 전처리.
줄 나누기 루틴이 실행 가능한 나눔점 나열을 찾지 못하면, 문단을 두 번째로 훑으면서 하이픈을 넣을 수 있는 낱말에 하이픈을
넣어 본다. 하이픈 넣기의 목표는 문단에 선택적 나눔 내용을 끼워 넣어서 나눌 수 있는 후보 자리를 늘리는 것이다.

하이픈 넣기의 일반 규칙은 조금 복잡하고 기술적이다. 문장 부호가 앞이나 뒤에 붙은 낱말에도 하이픈을 넣을 수 있어야 하고,
영어 말고 다른 언어에서도 규칙이 작동해야 하기 때문이다. 또 하이픈이 낱말의 합자와 커닝 구조를 근본적으로 바꿀 수도 있다는
사실과도 씨름해야 한다.

문자 나열은 현재 문단의 ``하이픈을 넣을 수 있을지도 모르는 부분''에 속할 때에만 하이픈 넣기 대상으로 고려된다. 이것은
노드 나열 $p_0p_1\ldots p_m$인데, $p_0$은 글루 노드이고, $p_1\ldots p_{m-1}$은 문자나 합자나 whatsit이나 암묵적 커닝 노드이고,
$p_m$은 글루나 벌점이나 삽입이나 조정이나 표시나 whatsit이나 명시적 커닝 노드다. (그러므로 상자, 수식, 사용자가 이미 넣은
선택적 나눔 노드는 하이픈 넣기를 막는다.) 노드 $p_1\ldots p_{m-1}$ 가운데 합자 노드는 사실상 원래의 합자 아닌 문자들로 펼쳐지고,
커닝 노드와 whatsit은 무시된다. 이제 각 문자 |c|는 비문자(|lc_code(c)=0|이면), 소문자(|lc_code(c)=c|이면), 대문자(그 밖의
경우) 가운데 하나로 분류된다. 대문자는 하이픈 넣기에서 |lc_code(c)|인 것처럼 다룬다. 노드 $p_1\ldots p_{m-1}$이 만들어 내는
문자들은 비문자로 시작할 수도 있다. 합자의 한가운데에 있지 않은 첫 글자를 $c_1$이라고 하자. 글자 $c_1$ 앞의 whatsit 노드는
무시하고, $c_1$ 뒤에서 찾은 whatsit은 끝내는 노드 $p_m$이 된다. 그리고 $c_1$과 글꼴이 같지 않은 문자는 모두 비문자로 다룬다. 그
글꼴의 |hyphen_char|는 0과 255 사이여야 하고, 그렇지 않으면 하이픈 넣기를 시도하지 않는다. \TeX은 될 수 있는 대로 많은
연속 글자 $c_1\ldots c_n$을 내다본다. 다만 |n|은 64보다 작아야 하므로, 그렇지 않았으면 $c_{64}$가 될 문자는 사실상 글자가
아니다. 게다가 $c_n$은 합자의 한가운데에 있어서는 안 된다. 이렇게 해서 노드 $p_a\ldots p_b$가 만들어 내는 글자 문자열
$c_1\ldots c_n$을 얻는다. 여기서 |1<=a<=b+1<=m|이다. 길이가 |n>=l_hyf+r_hyf|이면 이 문자열은 하이픈 넣기 대상이 된다. 다만 $c_1$이
대문자이면 |uc_hyph|가 양수여야 한다.

하이픈 넣기 과정은 세 단계로 일어난다. 먼저 후보 나열 $c_1\ldots c_n$을 찾는다. 그런 다음 하이픈 넣기 표를 참조해서 하이픈이
들어갈 수 있는 자리를 정한다. 그리고 마지막으로 노드 $p_a\ldots p_b$를 찾아낸 선택적 나눔을 담은 새 노드 나열로 바꾼다.

다행히 이 계산을 모두 아주 자주 할 필요는 없다. \TeX의 안쪽 루프에서 빼내 두었기 때문이다. 이를테면 저자의 700쪽짜리 책
{\sl Seminumerical Algorithms} 제2판을 \TeX으로 조판했을 때, 줄 나누기 알고리즘이 두 번 훑어야 했던 문단은 약 5퍼센트뿐이어서
@^Knuth, Donald Ervin@>
문단마다 시도해야 했던 하이픈 넣기는 1.2번쯤이었다.

@<문단에 하이픈을 넣을...@>=
if ini_version && trie_not_ready {
	init_trie()
}
cur_lang = init_cur_lang; l_hyf = init_l_hyf; r_hyf = init_r_hyf

@ 하이픈 넣기 후보인 글자 $c_1\ldots c_n$은 |hc|라는 배열에 놓이고, 수 |n|은 |hn|에 놓인다. 위 설명의 노드 $p_{a-1}$과~$p_b$를
가리키는 포인터는 변수 |ha|와 |hb|에, 글꼴 번호는 |hf|에 놓인다.

@<전역 변수@>=
var @!hc [66]halfword // 하이픈을 넣을 낱말; |0..256|
var @!hn small_number // |hc|에서 차지한 자리의 수; |0..64|, 늘 |small_number|인 것은 아니다
var @!ha, @!hb pointer // 노드 |ha..hb|를 하이픈 넣은 결과로 바꾸어야 한다
var @!hf internal_font_number // |hc|에 있는 글자들의 글꼴 번호
var @!hu [64]halfword // 소문자로 바꾸기 전의 |hc|와 같은 것; |0..256|
var @!hyf_char int32 // 관련된 글꼴의 하이픈 문자
var @!cur_lang, @!init_cur_lang ASCII_code // 지금 관심 있는 하이픈 넣기 표
var @!l_hyf, @!r_hyf, @!init_l_hyf, @!init_r_hyf int32 // 조각 크기의 한계
var @!hyf_bchar halfword // $c_n$ 뒤의 경계 문자

@ 하이픈 넣기 루틴에는 지역 변수가 몇 개 더 필요하다.

@<줄 나누기의 지역 변수@>=
var j small_number // |hc|나 |hu|의 첨자
var c int32 // 하이픈 넣기를 고려하고 있는 문자; |0..255|

@ 다음 코드가 작동할 때 프로시저 |line_break|는 둘째 훑기에 있고, |cur_p|는 글루 노드를 가리킨다.

@<다음 낱말에 하이픈을...@>=
prev_s = cur_p; s = link(prev_s)
if s != null {
	@<노드 |ha|까지 건너뛴다. 하이픈을 넣지 말아야 하면 |goto done1|@>
	if l_hyf+r_hyf > 63 {
		goto done1
	}
	@<글자들을 |hu|와 |hc|에 넣으며 노드 |hb|까지 건너뛴다@>
	@<|hb| 뒤의 노드들이 하이픈 넣기를 허락하는지 검사한다@>
	hyphenate()
}
done1: ;

@ @<|line_break|의 하위...@>=
@<|reconstitute|라는 함수를 선언한다@>@;
func hyphenate() {
	@<하이픈 넣기의 지역 변수@>@;
	@<|hc|에 있는 낱말의 하이픈 자리를 찾거나 |return|한다@>
	@<하이픈을 하나도 찾지 못했으면 |return|한다@>
	@<노드 |ha..hb|를 선택적 하이픈을 담은 노드 나열로 바꾼다@>
}

@ 먼저 할 일은 첫 글자 바로 앞의 노드 |ha|를 찾는 것이다.

@<노드 |ha|까지 건너뛴다...@>=
for {
	if is_char_node(s) {
		c = qo(character(s)); hf = font(s)
	} else if type_(s) == ligature_node {
		if lig_ptr(s) == null {
			goto continue_
		} else {
			q = lig_ptr(s); c = qo(character(q)); hf = font(q)
		}
	} else if type_(s) == kern_node && subtype(s) == normal {
		goto continue_
	} else if type_(s) == whatsit_node {
		@<하이픈 넣기 전처리 루프에서 whatsit 노드를 지나간다@>
		goto continue_
	} else {
		goto done1
	}
	if lc_code(c) != 0 {
		if lc_code(c) == c || uc_hyph() > 0 {
			goto done2
		} else {
			goto done1
		}
	}
continue_:
	prev_s = s; s = link(prev_s)
}
done2:
	hyf_char = hyphen_char[hf]
	if hyf_char < 0 {
		goto done1
	}
	if hyf_char > 255 {
		goto done1
	}
	ha = prev_s

@ 하이픈을 넣을 낱말을 이제 배열 |hu|와 |hc|로 옮긴다.

@<글자들을 |hu|와 |hc|에 넣으며...@>=
hn = 0
for {
	if is_char_node(s) {
		if font(s) != hf {
			goto done3
		}
		hyf_bchar = character(s); c = qo(hyf_bchar)
		if lc_code(c) == 0 {
			goto done3
		}
		if hn == 63 {
			goto done3
		}
		hb = s; hn++; hu[hn] = c; hc[hn] = lc_code(c); hyf_bchar = non_char
	} else if type_(s) == ligature_node {
		@<합자 노드의 문자들을 |hu|와 |hc|로 옮긴다@>
	} else if type_(s) == kern_node && subtype(s) == normal {
		hb = s
		hyf_bchar = font_bchar[hf]
	} else {
		goto done3
	}
	s = link(s)
}
done3:

@ 합자 노드를 펼칠 때는 저장하고 있는 문자의 첨자를 |j|로 한다. 합자 전체가 글자로 이루어졌다는 것을 확인하기 전에는 |hn|을
늘리고 싶지 않기 때문이다. 글자가 아닌 것이 있으면 |goto done3|한다. 또 |hn=0|이고 |hb|가 아무 값으로도 정해지지 않은 채
|done3|에 이를 수도 있다는 것에 주의하라.

@<합자 노드의 문자들을...@>=
if font(lig_char(s)) != hf {
	goto done3
}
j = hn; q = lig_ptr(s)
if q > null {
	hyf_bchar = character(q)
}
for q > null {
	c = qo(character(q))
	if lc_code(c) == 0 {
		goto done3
	}
	if j == 63 {
		goto done3
	}
	j++; hu[j] = c; hc[j] = lc_code(c)
	q = link(q)
}
hb = s; hn = j
if odd(subtype(s)) { hyf_bchar = font_bchar[hf] } else { hyf_bchar = non_char }

@ 적어도 |l_hyf+r_hyf|개의 글자를 찾았는지도 검사한다. 그렇지 않으면 |goto done1|한다.

@<|hb| 뒤의 노드들이...@>=
if hn < l_hyf+r_hyf {
	goto done1 // |l_hyf|와 |r_hyf|는 |>=1|이다
}
for {
	if !is_char_node(s) {
		switch type_(s) {
		case ligature_node: // 아무것도 하지 않는다
		case kern_node:
			if subtype(s) != normal {
				goto done4
			}
		case whatsit_node, glue_node, penalty_node, ins_node, adjust_node, mark_node:
			goto done4
		default: goto done1
		}
	}
	s = link(s)
}
done4:

@* 하이픈 넣기 후처리.
글자 |hc[j]|와 |hc[j+1]| 사이에 하이픈을 넣을 수 있으면, 하이픈 넣기 프로시저는 |hyf[j]|를 어떤 작은 홀수로 정한다. 그러나 줄 나누기
알고리즘의 나머지와 독립된 \TeX의 하이픈 넣기 프로시저를 보기 전에, 그것이 찾은 하이픈을 가지고 무엇을 할지 먼저 생각해
보자. 변수 |ha|와 |hb| 따위가 무엇인지 잊어버리기 전에 프로그램의 이 부분을 다루는 편이 낫기 때문이다.

@<전역 변수@>=
var @!hyf [65]int32 // 홀수 값은 선택적 하이픈을 나타낸다; |0..9|
var @!init_list pointer // 낱말 앞의 문장 부호 문자들의 목록
var @!init_lig bool // |init_list|가 합자를 나타내는가?
var @!init_lft bool // 그렇다면, 그 합자에 왼쪽 경계가 끼어 있었는가?

@ @<하이픈 넣기의 지역 변수@>=
var i, j, l int32 // |hc|나 |hu|의 첨자; |0..65|
var q, r, s pointer // 목록을 다루는 임시 레지스터들
var bchar halfword // 하이픈 넣은 낱말의 경계 문자, 또는 |non_char|

@ \TeX은 앞에 \.{\\lefthyphenmin}보다 적은 글자가 있거나 뒤에 \.{\\righthyphenmin}보다 적은 글자가 있는 하이픈은 결코 넣지
않는다. 그래서 짧은 낱말은 하이픈이 들어갈 가능성이 비교적 적다. 하이픈을 하나도 찾지 못했으면 문단을 하나도 바꾸지 않아도
되므로 시간을 아낄 수 있다.

@<하이픈을 하나도 찾지 못했으면...@>=
for j = l_hyf; j <= hn-r_hyf; j++ {
	if odd(hyf[j]) {
		goto found1
	}
}
return
found1:

@ 하이픈을 정말로 넣을 것이라면, \TeX은 먼저 |ha|와~|hb| 사이의 노드 부분 나열을 지운다. 암묵적 경계 문자와 문장 부호가 하이픈
넣은 낱말 안의 합자에 미친 효과를 지키려고, 왼쪽 경계나 앞 문자를 |hu[0]|에 저장하고 가능한 오른쪽 경계를 |bchar|에 저장한다.
글자 |hu[0]|이 재구성의 일부가 되어야 하면 |j:=0|으로 하고, 그렇지 않으면 |j:=1|로 한다. 변수 |s|는 현재 가로 목록의 꼬리를 가리키고,
|q|는 |hb| 다음의 노드를 가리킨다. 그래서 하이픈 넣은 낱말을 재구성한 뒤에 이어 붙일 수 있다.

@<노드 |ha..hb|를 선택적 하이픈을...@>=
q = link(hb); set_link(hb, null); r = link(ha); set_link(ha, null); bchar = hyf_bchar
if is_char_node(ha) {
	if font(ha) != hf {
		goto found2
	} else {
		init_list = ha; init_lig = false; hu[0] = qo(character(ha))
	}
} else if type_(ha) == ligature_node {
	@<|ha|가 합자 노드일 때 |init_list|를 정한다@>
} else { // 문장 부호를 찾지 못했다. 왼쪽 경계를 찾아본다
	if !is_char_node(r) && type_(r) == ligature_node && subtype(r) > 1 {
		goto found2
	}
	j = 1; s = ha; init_list = null; goto common_ending
}
s = cur_p // |type(cur_p)=glue_node|이므로 |cur_p!=ha|다
for link(s) != ha {
	s = link(s)
}
j = 0; goto common_ending
found2:
	s = ha; j = 0; hu[0] = 256; init_lig = false; init_list = null
common_ending:
	flush_node_list(r)
	@<하이픈 넣은 낱말의 노드들을 재구성하고 선택적 하이픈을 끼워 넣는다@>
	flush_list(init_list)

@ \dg 앞 절에서 |ha|가 합자 노드인 경우다.

@<|ha|가 합자 노드일 때...@>=
if font(lig_char(ha)) != hf {
	goto found2
} else {
	init_list = lig_ptr(ha); init_lig = true; init_lft = subtype(ha) > 1
	hu[0] = qo(character(lig_char(ha)))
	if init_list == null && init_lft {
		hu[0] = 256; init_lig = false
	} // 이 경우에는 합자를 처음부터 재구성한다
	free_node(ha, small_node_size)
}

@ 하이픈을 찾았다고 해서 싸움이 끝난 것은 아니라는 사실을 이제 마주해야 한다. 낱말을 재구성하는 과정은 간단하지 않을 수
{\def\!{\kern-1pt}%
있다. 하이픈이 있으면 합자가 바뀔 수도 있기 때문이다. {\sl The \TeX book}은 낱말 ``difficult''의 어려움을 논하는데, 하이픈을
둘러싼 선택적 나눔 내용은 그보다 훨씬 더 복잡할 수 있다. 합자로 \.{b\!c}, \.{c\!d}, \.{d\!e}, \.{e\!f}만 있는 글꼴의
낱말 \.{abcdef}를 생각하자. 이 낱말이 \.b와 \.c 사이에 하이픈 넣기를 허락하면, 하이픈이 있을 때와 없을 때의 두 모양은
$\.a\,\.b\,\.-\,\.{c\!d}\,\.{e\!f}$와 $\.a\,\.{b\!c}\,\.{d\!e}\,\.f$다. 그러니 하이픈 하나를 넣으면 그 효과가 낱말의 나머지로
얼마든지 멀리 물결처럼 퍼질 수 있다. 그런 물결과 함께 하이픈이 더 나타나면 문제가 더 복잡해진다. 이를테면 방금 든 보기의
낱말에 \.c와 \.d 사이에도 하이픈을 넣을 수 있다면 그렇다. \TeX은 그런 기묘한 경우에 추가 하이픈을 그냥 무시해서 이 문제를
피한다.}

원래 문자들을 지우지 않는 합자가 있으면 문제가 더욱 복잡해진다. 하이픈을 넣을 낱말 앞에 문장 부호가 있으면 \TeX의 방법은
모든 가능한 시나리오에서 완벽하지는 않다. 문장 부호와 글자가 정보를 앞뒤로 퍼뜨릴 수 있기 때문이다. 이를테면 하이픈 넣기
전의 원래 쌍 \.{*a}가 \.{\?=:} 합자로 \.{*y}로 바뀌고, 그것이 다시 \.{=:\?} 합자로 \.{xy}로 바뀐다고 하자. 그리고 $p_{a-1}=\.x$이고
$p_a=\.y$이면 재구성 프로시저는 \.{xy}를 다시 얻을 만큼 영리하지 못하다. 그런 경우 글꼴 디자이너는 \.{xa}에서 \.{xy}로 가는
합자를 넣어야 한다.

@ 처리는 |reconstitute|라는 서브루틴이 수월하게 해 준다. 문자열 $x_j\ldots x_n$이 주어지면, 합자와 커닝에 의한
$x_j\ldots x_n$의 ``번역''이 $y_1\ldots y_t$ 다음에 $x_{m+1}\ldots x_n$의 번역이 오는 꼴이 되는 가장 작은 첨자 $m\ge j$가 있다.
여기서 $y_1\ldots y_t$는 문자, 합자, 커닝 노드의 비어 있지 않은 나열이다. 우리는 $x_j\ldots x_m$을 $x_j\ldots x_n$의 ``잘린
머리''(cut prefix)라고 부른다. 이를테면 $x_1x_2x_3=\.{fly}$이고 글꼴에 `fl' 합자와 `fl'과 `y' 사이의 커닝이 있으면, $m=2$,
$t=2$이고, $y_1$은 `fl'의 합자 노드, 그 다음은 알맞은 커닝 노드~$y_2$다. 가장 흔한 경우에는 $x_j$가 $x_{j+1}$과 합자를 이루지
않고, 그냥 $m=j$, $y_1=x_j$다. 그리고 $m<n$이면 $x_{m+1}\ldots x_n$에 이 과정을 되풀이해서 번역 전체를 얻을 수 있다.

함수 |reconstitute|는 정수 $m$을 돌려주고, 노드 $y_1\ldots y_t$를 |link(hold_head)|에서 시작하는 연결 목록에 넣는다. 입력
$x_j\ldots x_n$은 배열 |hu|에서 얻는다. 그리고 $x_j=256$이면 $x_j$를 암묵적 왼쪽 경계 문자로 여긴다. 이 경우 |j|는 |n|보다 반드시
작아야 한다. 매개변수 |bchar|는 256이거나, $x_n$ 바로 뒤에 있다고 가정하는 암묵적 오른쪽 경계 문자다. (|hu[n+1]|의 값은 결코
명시적으로 살피지 않지만, 알고리즘은 거기에 |bchar|가 있다고 상상한다.)

범위 $j\le k\le m$에 |hyf[k]|가 홀수이고, $x_{k+1}$이 |hchar|였다면 |reconstitute|의 결과가 달라졌을 첨자 |k|가 있으면,
|reconstitute|는 |hyphen_passed|를 그런 |k| 가운데 가장 작은 것으로 정한다. 그렇지 않으면 |hyphen_passed|를 0으로 한다.

첨자가 |j=0|인 경우에는 특별한 관례를 쓴다. 그때는 |hu[0]|의 번역이 |init_list|에서 시작하는 특별한 문자 노드 목록에 있다고
가정한다. 게다가 |init_lig|가 |true|이면 |hu[0]|은 합자 문자이고, |init_lft|가 |true|이면 그 합자에 왼쪽 경계가 끼어 있다.
이 기능은 하이픈을 넣을 낱말 앞에 낱말 처음의 번역에 영향을 줄 수 있는 문장 부호(이를테면 작은따옴표나 큰따옴표)가 있는
경우를 위한 것이다.

@<전역 변수@>=
var @!hyphen_passed small_number // 합자 안의 첫 하이픈, 있으면

@ 보충: 원본의 매크로 |append_charnode_to_t|, |set_cur_r|, |wrap_lig|, |pop_lig_stack|은 |reconstitute|의 지역 변수를 쓰므로
함수 안의 함수 리터럴로 옮겼다. 이것들은 아래 여러 절에서 정의한다.

@<|reconstitute|라는...@>=
func reconstitute(j, n small_number, bchar, hchar halfword) small_number {
	var p pointer // 목록을 다루는 임시 레지스터
	var t pointer // 덧붙여 나가는 노드
	var q four_quarters // 문자 정보나 합자/커닝 명령
	var cur_rh halfword // 합자 검사를 위한 하이픈 문자
	var test_char halfword // 합자 검사를 위한 하이픈이나 다른 문자
	var w scaled // 커닝의 양
	var k font_index // 현재 합자/커닝 명령의 자리
	@<|reconstitute|의 매크로들@>@;
	hyphen_passed = 0; t = hold_head; w = 0; set_link(hold_head, null)
	// 이 시점에서 |ligature_present=lft_hit=rt_hit=false|
	@<커서가 자리 |j| 뒤에 오도록 자료 구조를 마련한다@>
continue_:
	@<커서 자리에 합자나 커닝이 있으면 자료 구조를 갱신한다@>
	@<번역에 합자나 커닝을 덧붙이고, 합자 스택이 비어 있지 않으면 |goto continue_|@>
	return j
}

@ 재구성 프로시저는 \TeX이 하이픈 넣기 전에 낱말을 처리할 때 쓴 전역 자료 구조 여럿을 함께 쓴다. 문자 |cur_l|과 |cur_r| 사이에
암묵적인 ``커서''가 있다. 이 두 문자에 대해 합자가 일어날 수 있는지 검사한다. 그리고 |ligature_present|이면 |cur_l|은 현재 번역 목록에서
|cur_q| 다음의 원래 문자들로 만든 합자 문자다. 커서와 문자 |j+1| 사이에는 ``합자 스택''이 있는데, 이것은 |link| 필드로 이어진
가짜 합자 노드들로 이루어진다. 이 스택은 합자 명령이 나중에 처리해야 할 새 문자를 만들지 않았으면 대개 비어 있다. 가짜 합자는
잠재적 합자를 나타내는 |character| 필드와, |char_node|를 가리키거나 |null|인 |lig_ptr| 필드를 가진 특별한 노드다. 문자 |cur_r|의 값은
다음과 같다. 곧 |lig_stack>null|이면 |cur_r=character(lig_stack)|이고, |lig_stack=null|이고 |j<n|이면 |cur_r=qi(hu[j+1])|이며,
|lig_stack=null|이고 |j=n|이면 |cur_r=bchar|다.

@<전역 변수@>=
var @!cur_l, @!cur_r halfword // 커서 앞뒤의 문자
var @!cur_q pointer // 합자를 떼어 낼 곳
var @!lig_stack pointer // 커서 오른쪽에 남은 일
var @!ligature_present bool // |cur_l|을 위한 합자 노드를 만들어야 하는가?
var @!lft_hit, @!rt_hit bool // 경계 문자와의 합자를 만났는가?

@ @<|reconstitute|의 매크로들@>=
append_charnode_to_t := func(c quarterword) {
	set_link(t, get_avail()); t = link(t)
	set_font_field(t, hf); set_character(t, c)
}
set_cur_r := func() {
	if j < n { cur_r = qi(hu[j+1]) } else { cur_r = bchar }
	if odd(hyf[j]) { cur_rh = hchar } else { cur_rh = non_char }
}

@ \dg 앞 절의 코드부를 옮긴다.

@<커서가 자리 |j| 뒤에...@>=
cur_l = qi(hu[j]); cur_q = t
if j == 0 {
	ligature_present = init_lig; p = init_list
	if ligature_present {
		lft_hit = init_lft
	}
	for p > null {
		append_charnode_to_t(character(p)); p = link(p)
	}
} else if cur_l < non_char {
	append_charnode_to_t(cur_l)
}
lig_stack = null; set_cur_r()

@ 합자/커닝 프로그램을 두 번, 곧 하이픈에 대해 한 번, 보통 글자에 대해 한 번 보고 싶을 수 있다. (하이픈이 프로그램에서 그
글자 뒤에 나타날 수도 있으므로, 둘을 한꺼번에 찾으려 하지 않는 편이 낫다.) 처리는 커서가 움직일 때까지 계속하는데, |j|가 늘
수도 있다.

@<커서 자리에 합자나 커닝이...@>=
if cur_l == non_char {
	k = bchar_label[hf]
	if k == non_address { goto done } else { q = font_info[k].qqqq }
} else {
	q = char_info(hf, cur_l)
	if char_tag(q) != lig_tag {
		goto done
	}
	k = lig_kern_start(hf, q); q = font_info[k].qqqq
	if skip_byte(q) > stop_flag {
		k = lig_kern_restart(hf, q); q = font_info[k].qqqq
	}
} // 이제 |k|는 합자/커닝 프로그램의 시작 주소다
if cur_rh < non_char { test_char = cur_rh } else { test_char = cur_r }
for {
	@<합자/커닝 명령 |q|가 |test_char|와 맞으면 처리한다@>
	if skip_byte(q) >= stop_flag {
		if cur_rh == non_char {
			goto done
		} else {
			cur_rh = non_char; goto continue_
		}
	}
	k = k + qo(skip_byte(q)) + 1; q = font_info[k].qqqq
}
done:

@ \dg 앞 절의 루프 몸체다. 하이픈과 맞으면 |hyphen_passed|를 정하고, 보통 문자와 맞으면 합자를 바꾸거나 커닝을 기억해 둔다.

@<합자/커닝 명령 |q|가...@>=
if next_char(q) == test_char && skip_byte(q) <= stop_flag {
	if cur_rh < non_char {
		hyphen_passed = j; hchar = non_char; cur_rh = non_char
		goto continue_
	} else {
		if hchar < non_char && odd(hyf[j]) {
			hyphen_passed = j; hchar = non_char
		}
		if op_byte(q) < kern_flag {
			@<합자 대체를 수행하고 커서 구조를 갱신한다@>
		}
		w = char_kern(hf, q); goto done // 이 커닝은 아래에서 넣는다
	}
}

@ @<|reconstitute|의 매크로들@>=
wrap_lig := func(b bool) {
	if ligature_present {
		p = new_ligature(hf, cur_l, link(cur_q))
		if lft_hit {
			set_subtype(p, 2); lft_hit = false
		}
		if b && lig_stack == null {
			set_subtype(p, subtype(p)+1); rt_hit = false
		}
		set_link(cur_q, p); t = p; ligature_present = false
	}
}
pop_lig_stack := func() {
	if lig_ptr(lig_stack) > null {
		set_link(t, lig_ptr(lig_stack)) // 이것은 |hu[j+1]|의 문자 노드다
		t = link(t); j++
	}
	p = lig_stack; lig_stack = link(p); free_node(p, small_node_size)
	if lig_stack == null { set_cur_r() } else { cur_r = character(lig_stack) }
} // |lig_stack|이 |null|이 아니면 |cur_rh=non_char|다

@ \dg 앞 절의 코드부를 옮긴다.

@<번역에 합자나 커닝을...@>=
wrap_lig(rt_hit)
if w != 0 {
	set_link(t, new_kern(w)); t = link(t); w = 0
}
if lig_stack > null {
	cur_q = t; cur_l = character(lig_stack); ligature_present = true
	pop_lig_stack(); goto continue_
}

@ 합자 대체를 수행하고 커서 구조를 갱신하는데, |j|가 늘 수도 있다. 커서가 나아가지 않으면 |goto continue_|하고, 나아가면
|goto done|한다.

@<합자 대체를 수행하고...@>=
if cur_l == non_char {
	lft_hit = true
}
if j == n && lig_stack == null {
	rt_hit = true
}
check_interrupt() // 끝없는 합자 루프가 있을 때 빠져나갈 길을 둔다
switch op_byte(q) {
case qi(1), qi(5): cur_l = rem_byte(q); ligature_present = true // \.{=:\?}, \.{=:\?>}
case qi(2), qi(6): @<|cur_r|을 바꾸고 합자 스택을 마련한다@> // \.{\?=:}, \.{\?=:>}
case qi(3): // \.{\?=:\?}
	cur_r = rem_byte(q)
	p = lig_stack; lig_stack = new_lig_item(cur_r); set_link(lig_stack, p)
case qi(7), qi(11): // \.{\?=:\?>}, \.{\?=:\?>>}
	wrap_lig(false)
	cur_q = t; cur_l = rem_byte(q); ligature_present = true
default: // \.{=:}
	cur_l = rem_byte(q); ligature_present = true
	if lig_stack > null {
		pop_lig_stack()
	} else if j == n {
		goto done
	} else {
		append_charnode_to_t(cur_r); j++; set_cur_r()
	}
}
if op_byte(q) > qi(4) && op_byte(q) != qi(7) {
	goto done
}
goto continue_

@ \dg 앞 절의 코드에서 떼어 낸 부분이다.

@<|cur_r|을 바꾸고 합자 스택을...@>=
cur_r = rem_byte(q)
if lig_stack > null {
	set_character(lig_stack, cur_r)
} else {
	lig_stack = new_lig_item(cur_r)
	if j == n {
		bchar = non_char
	} else {
		p = get_avail(); set_lig_ptr(lig_stack, p)
		set_character(p, qi(hu[j+1])); set_font_field(p, hf)
	}
}

@ 이제 찾아낸 잠재적 하이픈들을 넣을 준비가 되었다. 다음 프로그램이 실행될 때 우리는 낱말 |hu[1..hn]|을 노드 |ha| 뒤에
덧붙이고, 그 결과에 노드 |q|를 덧붙이고 싶다. 이 과정에서 변수 |i|는 |hu|의 임시 첨자이고, 변수 |j|는 |hu|에서 현재 위치의
첨자이며, 변수 |l|은 선택적 나눔 갈래에서 |j|에 대응하는 것이다. 변수 |r|은 새로 만드는 노드를 가리킨다. 그리고 새 지역
변수가 몇 개 필요하다.

@<하이픈 넣기의 지역...@>=
var major_tail, minor_tail pointer // 재구성하고 있는 주 갈래와 선택적 나눔 갈래의 목록 끝
var c ASCII_code // 하이픈으로 잠시 바꾼 문자
var c_loc int32 // 그 문자가 있던 곳; |0..63|
var r_count int32 // 선택적 나눔의 대체 개수
var hyf_node pointer // 하이픈, 있으면

@ 다음 코드가 수행될 때 |hyf[0]|과 |hyf[hn]|은 0이다.

@<하이픈 넣은 낱말의 노드들을...@>=
for {
	l = j; j = reconstitute(j, hn, bchar, qi(hyf_char)) + 1
	if hyphen_passed == 0 {
		set_link(s, link(hold_head))
		for link(s) > null {
			s = link(s)
		}
		if odd(hyf[j-1]) {
			l = j; hyphen_passed = j - 1; set_link(hold_head, null)
		}
	}
	if hyphen_passed > 0 {
		@<하이픈 없는 낱말의 대안으로 선택적 나눔 노드를 만들어 덧붙인다@>
	}
	if j > hn {
		break
	}
}
set_link(s, q)

@ 이 반복 루프에서는 앞 선택적 나눔의 두 갈래가 모두 자리 |j-1|에서 끝날 때 |hyf[j-1]|이 홀수이면 선택적 나눔을 하나 더 넣는다.
엄밀히 말하면 이렇게 하는 것은 정당하지 않다. 자리 |j-1| 뒤의 하이픈이 그 갈래들과 정말로 독립인지 모르기 때문이다. 그러나 거의 모든
응용에서 잠재적으로 값진 하이픈 자리를 잃지 않는 편을 택할 것이다. (`difficult'라는 낱말을 생각해 보라. 여기서 글자 `c'가 자리
|j|에 있다.)

두 갈래가 같아질 때까지 계속 키워 나간다.

보충: 원본의 매크로 |advance_major_tail|은 `|major_tail:=link(major_tail); incr(r_count)|'다. 두 곳에서 펼쳐 쓴다.

@<하이픈 없는 낱말의 대안으로...@>=
for {
	r = get_node(small_node_size)
	set_link(r, link(hold_head)); set_type(r, disc_node)
	major_tail = r; r_count = 0
	for link(major_tail) > null {
		major_tail = link(major_tail); r_count++ // |advance_major_tail|
	}
	i = hyphen_passed; hyf[i] = 0
	@<문자 |hu[l..i]|와 하이픈을 |pre_break(r)|에 넣는다@>
	@<문자 |hu[i+1..]|를 |post_break(r)|에 넣고 두 갈래를 맞춘다@>
	@<포인터 |s|를 현재 목록의 끝으로 옮기고 |replace_count(r)|를 정한다@>
	hyphen_passed = j - 1; set_link(hold_head, null)
	if !odd(hyf[j-1]) {
		break
	}
}

@ 새 하이픈은 앞 문자와 합자나 커닝을 이룰 수도 있다. 이 시점에서 |l-1<=i<j|이고 |i<hn|이다.

@<문자 |hu[l..i]|와 하이픈을...@>=
minor_tail = null; set_pre_break(r, null); hyf_node = new_character(hf, hyf_char)
if hyf_node != null {
	i++; c = hu[i]; hu[i] = hyf_char; free_avail(hyf_node)
}
for l <= i {
	l = reconstitute(l, i, font_bchar[hf], non_char) + 1
	if link(hold_head) > null {
		if minor_tail == null {
			set_pre_break(r, link(hold_head))
		} else {
			set_link(minor_tail, link(hold_head))
		}
		minor_tail = link(hold_head)
		for link(minor_tail) > null {
			minor_tail = link(minor_tail)
		}
	}
}
if hyf_node != null {
	hu[i] = c // 하이픈 자리의 문자를 되돌린다
	l = i; i--
}

@ 맞추기 알고리즘은 |l=i+1<=j|로 시작한다. 문자들을 |post_break(r)|에 넣으면서, 맞추어질 때까지 이 목록과 |major_tail|에
덧붙여 나간다.

@<문자 |hu[i+1..]|를...@>=
minor_tail = null; set_post_break(r, null); c_loc = 0
if bchar_label[hf] != non_address { // 새 줄의 처음에 왼쪽 경계를 둔다
	l--; c = hu[l]; c_loc = l; hu[l] = 256
}
for l < j {
	for {
		l = reconstitute(l, hn, bchar, non_char) + 1
		if c_loc > 0 {
			hu[c_loc] = c; c_loc = 0
		}
		if link(hold_head) > null {
			if minor_tail == null {
				set_post_break(r, link(hold_head))
			} else {
				set_link(minor_tail, link(hold_head))
			}
			minor_tail = link(hold_head)
			for link(minor_tail) > null {
				minor_tail = link(minor_tail)
			}
		}
		if l >= j {
			break
		}
	}
	for l > j {
		@<|hu[j..]|의 문자들을 |major_tail|에 덧붙이며 |j|를 늘린다@>
	}
}

@ @<|hu[j..]|의 문자들을...@>=
j = reconstitute(j, hn, bchar, non_char) + 1
set_link(major_tail, link(hold_head))
for link(major_tail) > null {
	major_tail = link(major_tail); r_count++ // |advance_major_tail|
}

@ 합자를 끼워 넣으면 낱말의 크기가 지수적으로 커질 수 있다. 그래서 하이픈 넣은 텍스트가 많아야 63자였어도 여기서 |r_count|의
크기를 검사해야 한다.

@<포인터 |s|를 현재 목록의...@>=
if r_count > 127 { // 선택적 하이픈을 잊어야 한다
	set_link(s, link(r)); set_link(r, null); flush_node_list(r)
} else {
	set_link(s, r); set_replace_count(r, r_count)
}
s = major_tail

@* 하이픈 넣기.
낱말 |hc[1..hn]|이 하이픈 넣기 후보를 담도록 마련되면, \TeX은 먼저 그 낱말이 사용자의 예외 사전에 있는지 본다. 없으면 주어진
낱말 안에 나타나는 패턴에 바탕을 두고 하이픈을 넣는데, 이때 프랭크~M. 리앙(Frank M. Liang)의 알고리즘을 쓴다.
@^Liang, Franklin Mark@>

예외 찾기 루틴보다 훨씬 흥미로우므로 리앙의 방법부터 살펴보자. 알고리즘은 모든 |j|에 대해 |hyf[j]|를 0으로 하고, 구분자 구실을
하도록 |hc[0]|과 |hc[hn+1]|에 무효한 문자를 넣는 것으로 시작한다. 그런 다음 주어진 패턴 집합 가운데 어느 것이 낱말
|hc[0..(hn+1)]| 안에 나타나는지 꽤 빠른 방법으로 알아본다. 길이 |k|인 각 패턴 $p_1\ldots p_k$에는 |k+1|개의 수 $n_0\ldots n_k$로
된 나열이 딸려 있다. 패턴이 |hc[(j+1)..(j+k)]|에 나타나면 \TeX은 |0<=i<=k|에 대해 |hyf[j+i]:=@tmax@>(hyf[j+i],@t$n_i$@>)|로
한다. 나타나는 패턴마다 이 일을 하고 나면, 이미 보았듯이 |hyf[j]|가 홀수일 때 |hc[j]|와 |hc[j+1]| 사이에 선택적 하이픈이 들어간다.

패턴 $p_1\ldots p_k$와 딸린 수 $n_0\ldots n_k$의 집합은 물론 하이픈을 넣을 낱말의 언어와, 원하는 하이픈 넣기의 정도에 따라
달라진다. 주어진 낱말 사전과 받아들일 수 있는 하이픈 넣기로부터 알맞은 |p|와 |n|을 찾는 방법은 리앙의 박사 학위 논문(Stanford
University, 1983)에서 논의한다. \TeX은 그저 패턴에서 출발해서 일한다.

@ 패턴은 조밀하면서도 꺼내 쓰기에 효율적인 표에 저장하는데, ``트라이(trie) 메모리''[{\sl The Art of Computer Programming \bf3}
(1973), 481--505 참조]의 변형을 쓴다. 관련된 언어 번호보다 하나 큰 수를 $z_0$으로 하고, |1<=i<=k|에 대해
|@t$z_i$@>:=trie_link@t$(z_{i-1})+p_i$@>|로 하면 각 패턴 $p_1\ldots p_k$를 찾을 수 있다. 패턴은 수 $z_k$로 식별된다. 모든 패턴
정보가 하나의 |trie_link| 배열에 함께 채워져 있으므로, 서로 다른 패턴의 자료가 뒤섞이지 않게 해야 한다. 그래서 모든 |i|에 대해
|trie_char@t$(z_i)=p_i$@>|인 또 하나의 표를 둔다. 또 $p_1\ldots p_k$에 딸린 수 $n_0\ldots n_k$를 식별하는 표 |trie_op|$(z_k)$도
있다.

실제로 나타나는 수 나열 $n_0\ldots n_k$는 비교적 몇 가지 안 된다. 대부분의 |n|은 대개 0이기 때문이다. 그래서 수 나열은
|trie_op|$(z_k)$가 한 바이트 길이가 되도록 부호화한다. 언어 |t|에서 $p_1\ldots p_k$가 |hc[(l-k+1)..l@,]|의 글자들과 맞았고
|trie_op(@t$z_k$@>)!=min_quarterword|이면, 다음 작은 프로그램을 수행해서 이 패턴에 필요한 연산을 모두 한다.
먼저 |v:=trie_op(@t$z_k$@>)|로 한다. 그런 다음 |v:=v+op_start[t]|,
|hyf[l-hyf_distance[v]]:=@tmax@>(hyf[l-hyf_distance[v]], hyf_num[v])|, |v:=hyf_next[v]|로 한다. 필요하면
|v=min_quarterword|가 될 때까지 되풀이한다.

@<바깥 블록의 형@>=
type @!trie_pointer = int32 // |trie|의 첨자; |0..trie_size|

@ @<정의@>=
func trie_link(p trie_pointer) halfword { return trie[p].rh } // 트라이의 ``아래로'' 가는 링크
func set_trie_link(p trie_pointer, v halfword) { trie[p].rh = v }
func trie_char(p trie_pointer) quarterword { return trie[p].b1 } // 이 트라이 자리에서 맞춘 문자
func set_trie_char(p trie_pointer, v quarterword) { trie[p].b1 = v }
func trie_op(p trie_pointer) quarterword { return trie[p].b0 } // 이 트라이 자리의 하이픈 넣기 프로그램
func set_trie_op(p trie_pointer, v quarterword) { trie[p].b0 = v }

@ \dg 앞 절의 전역 변수를 옮긴다.

보충: 원본의 배열 |[1..trie_op_size]|는 첨자 0을 쓰지 않는 길이 |trie_op_size+1|의 배열로 옮긴다.

@<전역 변수@>=
var @!trie [trie_size + 1]two_halves // |trie_link|, |trie_char|, |trie_op|
var @!hyf_distance [trie_op_size + 1]small_number // $n_j$의 자리 |k-j|
var @!hyf_num [trie_op_size + 1]small_number // $n_j$의 값
var @!hyf_next [trie_op_size + 1]quarterword // 이어지는 코드
var @!op_start [256]int32 // 현재 언어의 오프셋; |0..trie_op_size|

@ @<하이픈 넣기의 지역...@>=
var z trie_pointer // |trie|의 첨자
var v int32 // |hyf_distance| 따위의 첨자

@ 이런 보조 표들이 제대로 마련되어 있다고 가정하면 하이픈 넣기 알고리즘은 꽤 짧다. 다음 코드에서는 |hc[hn+3]|을 결코 꺼내지
않도록 |hc[hn+2]|를 불가능한 값 256으로 한다.

@<|hc|에 있는 낱말의 하이픈 자리를...@>=
for j = 0; j <= hn; j++ {
	hyf[j] = 0
}
@<낱말 |hc[1..hn]|을 예외 표에서 찾고, 있으면 |goto found|@>
if trie_char(trie_pointer(cur_lang)+1) != qi(cur_lang) {
	return // |cur_lang|의 패턴이 없다
}
hc[0] = 0; hc[hn+1] = 0; hc[hn+2] = 256 // 구분자를 넣는다
for j = 0; j <= hn-r_hyf+1; j++ {
	z = trie_link(trie_pointer(cur_lang)+1) + hc[j]; l = j
	for hc[l] == qo(trie_char(z)) {
		if trie_op(z) != min_quarterword {
			@<|hyf| 표에 최댓값들을 저장한다@>
		}
		l++; z = trie_link(z) + hc[l]
	}
}
found:
	for j = 0; j <= l_hyf-1; j++ {
		hyf[j] = 0
	}
	for j = 0; j <= r_hyf-1; j++ {
		hyf[hn-j] = 0
	}

@ @<|hyf| 표에 최댓값들을...@>=
v = trie_op(z)
for {
	v = v + op_start[cur_lang]; i = l - hyf_distance[v]
	if hyf_num[v] > hyf[i] {
		hyf[i] = hyf_num[v]
	}
	v = hyf_next[v]
	if v == min_quarterword {
		break
	}
}

@ \TeX의 원시 명령 \.{\\hyphenation}이 만드는 예외 표는 선형 탐사를 쓰는 순서 해시 표[Amble and Knuth, {\sl The Computer
@^Amble, Ole@> @^Knuth, Donald Ervin@>
Journal \bf17} (1974), 135--142 참조]로 짜여 있다. 낱말 $\alpha$와 $\beta$에 대해, $\vert\alpha\vert<\vert\beta\vert$이거나,
$\vert\alpha\vert=\vert\beta\vert$이고 $\alpha$가 사전 순으로 $\beta$보다 작으면 $\alpha<\beta$라고 하자. (표기 $\vert\alpha\vert$는
$\alpha$의 길이를 나타낸다.) 순서 해싱의 생각은, 주어진 낱말 $\alpha$를 찾으려면 해시 주소 $h=h(\alpha)$를 계산한 다음 표의
자리 |h|, |h-1|, \dots를 차례로 보다가 $\le\alpha$인 첫 낱말을 만날 때 멈추면 되도록 표를 배치하는 것이다. 그 낱말이
$\alpha$와 다르면 $\alpha$가 표에 없다고 결론지을 수 있다.

표의 낱말들은 |info| 필드에 하이픈 자리를 지정한 |mem|의 목록을 가리킨다. 낱말 $c_1\ldots c_n$에 $c_k$와 $c_{k+1}$ 사이의
선택적 하이픈이 있으면 그 목록에 수 |k|가 들어 있다.

@<바깥 블록의 형@>=
type @!hyph_pointer = int32 // 순서 해시 표의 첨자; |0..hyph_size|

@ @<전역 변수@>=
var @!hyph_word [hyph_size + 1]str_number // 예외 낱말
var @!hyph_list [hyph_size + 1]pointer // 하이픈 자리 목록
var @!hyph_count hyph_pointer // 예외 사전의 낱말 수

@ @<초기화를 위한 지역 변수@>=
var @!z hyph_pointer // 예외 사전을 훑는다

@ @<핵심 변수들의...@>=
for z = 0; z <= hyph_size; z++ {
	hyph_word[z] = 0; hyph_list[z] = null
}
hyph_count = 0

@ 지역 변수가 몇 개 더 있으면 예외 찾기 알고리즘은 꽤 간단하다.

@<하이픈 넣기의 지역...@>=
var h hyph_pointer // |hyph_word|와 |hyph_list|의 첨자
var k str_number // |str_start|의 첨자
var u pool_pointer // |str_pool|의 첨자

@ 먼저 해시 코드 |h|를 계산하고, 낱말을 찾거나 찾지 못할 때까지 찾는다. 서로 다른 언어의 낱말은 문자열에 언어 코드를 덧붙여서
따로 둔다. 낱말을 찾으면 |hyf|에 하이픈이 담긴 채로 |goto found|한다.

@<낱말 |hc[1..hn]|을 예외 표에서...@>=
h = hc[1]; hn++; hc[hn] = cur_lang
for j = 2; j <= hn; j++ {
	h = (h + h + hc[j]) % hyph_size
}
for {
	@<문자열 |hyph_word[h]|를 |hc[1..hn]|과 견준다@>
	if h > 0 { h-- } else { h = hyph_size }
}
not_found:
	hn--

@ 문자열 |hyph_word[h]|가 |hc[1..hn]|보다 작으면 |goto not_found|한다. 두 문자열이 같으면 |hyf|를 하이픈 자리로 정하고
|goto found|한다.

@<문자열 |hyph_word[h]|를 |hc[1..hn]|과...@>=
k = hyph_word[h]
if k == 0 {
	goto not_found
}
if length(k) < hn {
	goto not_found
}
if length(k) == hn {
	j = 1; u = str_start[k]
	for {
		if so(str_pool[u]) < hc[j] {
			goto not_found
		}
		if so(str_pool[u]) > hc[j] {
			goto done
		}
		j++; u++
		if j > hn {
			break
		}
	}
	@<|hyph_list[h]|에 지정된 대로 하이픈을 넣는다@>
	hn--; goto found
}
done:

@ @<|hyph_list[h]|에 지정된...@>=
s = hyph_list[h]
for s != null {
	hyf[info(s)] = 1; s = link(s)
}

@ @<|hyph_list|에서 |p|를 가리키는...@>=
for q = 0; q <= hyph_size; q++ {
	if hyph_list[q] == p {
		print_nl("HYPH("); print_int(q); print_char(')')
	}
}

@ 이제 하이픈 넣기 루틴을 마쳤으므로, 프로시저 |line_break|도 마침내 끝났다. 하이픈 넣기 예외 표가 머릿속에 생생하니, 그 표에
새 항목을 더하는 루틴을 다루기에 좋은 때다.

\TeX이 `\.{\\hyphenation}'을 훑으면, 알맞은 일을 하는 |new_hyph_exceptions|라는 프로시저를 부른다.

보충: 원본의 매크로 |set_cur_lang|은 네 곳에서 쓰이므로 함수로 옮긴다.

@<함수들@>=
func set_cur_lang() {
	if language() <= 0 {
		cur_lang = 0
	} else if language() > 255 {
		cur_lang = 0
	} else {
		cur_lang = language()
	}
}

func new_hyph_exceptions() { // 새 예외를 넣는다
	var n int32 // 현재 낱말의 길이; |0..64|, 늘 |small_number|인 것은 아니다
	var j int32 // |hc|의 첨자; |0..64|
	var h hyph_pointer // |hyph_word|와 |hyph_list|의 첨자
	var k str_number // |str_start|의 첨자
	var p pointer // 하이픈 자리 목록의 머리
	var q pointer // 목록 |p|의 새 노드를 만들 때 쓴다
	var s, t str_number // 비교하거나 저장하는 문자열
	var u, v pool_pointer // |str_pool|의 첨자
	scan_left_brace() // \.{\\hyphenation} 뒤에는 왼쪽 중괄호가 와야 한다
	set_cur_lang()
	@<오른쪽 중괄호에 이를 때까지 나열된 하이픈 넣기 예외를 모두 넣고 |return|한다@>
}

@ @<오른쪽 중괄호에 이를 때까지 나열된 하이픈 넣기 예외를 모두 넣고 |return|한다@>=
n = 0; p = null
for {
	get_x_token()
reswitch:
	switch cur_cmd {
	case letter, other_char, char_given: @<새 글자나 하이픈을 덧붙인다@>
	case char_num:
		scan_char_num(); cur_chr = cur_val; cur_cmd = char_given
		goto reswitch
	case spacer, right_brace:
		if n > 1 {
			@<하이픈 넣기 예외 하나를 넣는다@>
		}
		if cur_cmd == right_brace {
			return
		}
		n = 0; p = null
	default: @<부적절한 \.{\\hyphenation} 오류를 낸다@>
	}
}

@ @<부적절한 \.{\\hyph...@>=
print_err("Improper "); print_esc("hyphenation")
@.Improper \\hyphenation...@>
print(" will be flushed")
help2("Hyphenation exceptions must contain only letters",
	"and hyphens. But continue; I'll forgive and forget.")
error()

@ @<새 글자나 하이픈을...@>=
if cur_chr == '-' {
	@<목록 |p|에 값 |n|을 덧붙인다@>
} else {
	if lc_code(cur_chr) == 0 {
		print_err("Not a letter")
@.Not a letter@>
		help2("Letters in \\hyphenation words must have \\lccode>0.",
			"Proceed; I'll ignore the character I just read.")
		error()
	} else if n < 63 {
		n++; hc[n] = lc_code(cur_chr)
	}
}

@ @<목록 |p|에 값 |n|을...@>=
if n < 63 {
	q = get_avail(); set_link(q, p); set_info(q, n); p = q
}

@ @<하이픈 넣기 예외 하나를...@>=
n++; hc[n] = cur_lang; str_room(n); h = 0
for j = 1; j <= n; j++ {
	h = (h + h + hc[j]) % hyph_size
	append_char(hc[j])
}
s = make_string()
@<쌍 |(s,p)|를 예외 표에 넣는다@>

@ @<쌍 |(s,p)|를...@>=
if hyph_count == hyph_size {
	overflow("exception dictionary", hyph_size)
}
@:TeX capacity exceeded exception dictionary}{\quad exception dictionary@>
hyph_count++
for hyph_word[h] != 0 {
	@<문자열 |hyph_word[h]|가 |s| 이하이면 두 쌍을 맞바꾼다@>
	if h > 0 { h-- } else { h = hyph_size }
}
hyph_word[h] = s; hyph_list[h] = p

@ 문자열 |hyph_word[h]|가 |s| 이하이면 |(hyph_word[h],hyph_list[h])|와 |(s,p)|를 맞바꾼다.

@<문자열 |hyph_word[h]|가 |s| 이하이면...@>=
k = hyph_word[h]
if length(k) < length(s) {
	goto found
}
if length(k) > length(s) {
	goto not_found
}
u = str_start[k]; v = str_start[s]
for {
	if str_pool[u] < str_pool[v] {
		goto found
	}
	if str_pool[u] > str_pool[v] {
		goto not_found
	}
	u++; v++
	if u == str_start[k+1] {
		break
	}
}
found:
	q = hyph_list[h]; hyph_list[h] = p; p = q
	t = hyph_word[h]; hyph_word[h] = s; s = t
not_found: ;

@* 하이픈 넣기 표의 초기화.
\TeX의 하이픈 넣기 알고리즘을 위한 트라이는 \.{\\patterns} 지정 뒤에 오는 패턴 나열로 만든다. 그런 지정은 \.{INITEX}에서만
허락된다. 보조 표를 위한 추가 메모리와 초기화 프로그램 자체가 실무용 \TeX을 쓸데없는 군더더기로 어지럽힐 뿐이기 때문이다.

첫 단계는 차례로 놓인 저장소에 채워 넣는 대신 링크로 이어진 트라이를 만드는 것이다. 그래야 끼워 넣기가 쉽다. 모든 패턴을
처리하고 나면 \.{INITEX}는 공통 부분 트라이를 찾아내서 연결 트라이를 압축한다. 마지막으로 트라이를 하이픈 넣기 알고리즘이 실제로
쓰는 효율적인 순차 꼴로 채워 넣는다.

보충: 원본은 이 프로시저들을 \.{INITEX}에서만 컴파일한다(|init|$\ldots$|tini|). 이 번역에서는 늘 컴파일하되, 실행 시간 깃발
|ini_version|이 참일 때만 불린다.

@<|line_break|의 하위...@>=
@<하이픈 넣기 패턴을 전처리하는 프로시저들@>@;

@ 트라이 만들기를 자세히 논하기 전에, 배열 |hyf_distance|, |hyf_num|, |hyf_next|를 만드는 더 단순한 문제를 생각해 보자.

이를테면 \TeX이 패턴 `\.{ab2cde1}'을 읽는다고 하자. 이것은 길이 5인 패턴이고, 위의 표기로 $n_0\ldots n_5=0\,0\,2\,0\,0\,1$이다.
우리는 대응하는 |trie_op| 코드 |v|가 |hyf_distance[v]=3|, |hyf_num[v]=2|, |hyf_next[v]=@t$v^\prime$@>|를 가지기를 바란다. 여기서
보조 |trie_op| 코드 $v^\prime$은 |hyf_distance[@t$v^\prime$@>]=0|, |hyf_num[@t$v^\prime$@>]=1|,
|hyf_next[@t$v^\prime$@>]=min_quarterword|를 가진다.

\TeX은 아래의 서브루틴 |new_trie_op|로 알맞은 값 |v|를 계산한다. 곧
$$\hbox{|@t$v^\prime$@>:=new_trie_op(0,1,min_quarterword)|,\qquad |v:=new_trie_op(3,2,@t$v^\prime$@>)|}$$
로 한다. 이 서브루틴은 세 매개변수를 특별한 해시 표에서 찾아보고, 현재 언어에서 이 셋이 전에 나타난 적이 없을 때에만 새 값을
배정한다.

이 해시 표를 |trie_op_hash|라고 부르고, 거기 담긴 항목의 수는 |trie_op_ptr|이다.

보충: 원본의 배열 |trie_op_hash|는 첨자 범위가 |-trie_op_size..trie_op_size|다. \GO/의 배열은 첨자가 0부터 시작하므로,
이 번역에서는 원본의 첨자 |h|에 |trie_op_size|를 더해 쓴다.

@<전역 변수@>=
var @!trie_op_hash [2*trie_op_size + 1]int32 // 네 짝의 트라이 연산 코드; |0..trie_op_size|
var @!trie_used [256]quarterword // 이 언어에서 지금까지 쓴 가장 큰 연산 코드
var @!trie_op_lang [trie_op_size + 1]ASCII_code // 해시한 네 짝의 언어 부분
var @!trie_op_val [trie_op_size + 1]quarterword // 해시한 네 짝에 대응하는 연산 코드
var @!trie_op_ptr int32 // 지금까지 저장한 연산의 수; |0..trie_op_size|

@ 다음 프로시저에서 |overflow| 정지를 없애고 싶은 유혹이 든다. 함수 |new_trie_op|가 작업을 중단하는 대신 |min_quarterword|를 돌려줄
수도 있을 것이다(그러면 하이픈 넣기 패턴의 일부를 그냥 무시하게 된다). 그러나 그러면 같은 패턴을 쓰는 서로 다른 \TeX 설치에서
하이픈 넣기 결과가 달라질 것이다. 그러니 |overflow| 정지는 패턴의 이식성을 위해 꼭 필요하다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func new_trie_op(d, n small_number, v quarterword) quarterword {
	var h int32 // 시험 해시 자리; |-trie_op_size..trie_op_size|
	var u quarterword // 시험 연산 코드
	var l int32 // 저장된 자료를 가리킨다; |0..trie_op_size|
	h = abs(n+313*d+361*v+1009*cur_lang)%(trie_op_size+trie_op_size) - trie_op_size
	for {
		l = trie_op_hash[trie_op_size+h]
		if l == 0 { // 새 연산을 위한 빈 자리를 찾았다
			if trie_op_ptr == trie_op_size {
				overflow("pattern memory ops", trie_op_size)
			}
			u = trie_used[cur_lang]
			if u == max_quarterword {
				overflow("pattern memory ops per language", max_quarterword-min_quarterword)
			}
			trie_op_ptr++; u++; trie_used[cur_lang] = u
			hyf_distance[trie_op_ptr] = d
			hyf_num[trie_op_ptr] = n; hyf_next[trie_op_ptr] = v
			trie_op_lang[trie_op_ptr] = cur_lang; trie_op_hash[trie_op_size+h] = trie_op_ptr
			trie_op_val[trie_op_ptr] = u; return u
		}
		if hyf_distance[l] == d && hyf_num[l] == n && hyf_next[l] == v && trie_op_lang[l] == cur_lang {
			return trie_op_val[l]
		}
		if h > -trie_op_size { h-- } else { h = trie_op_size }
	}
}

@ 함수 |new_trie_op|가 필요한 연산 코드 정보를 압축하고 나면, 우리의 하이픈 넣기 알고리즘에 필요한 최종 꼴로 자료를 풀어 놓기에
넉넉한 정보가 있다.

@<하이픈 넣기 연산 표를 올바른 차례로 정렬한다@>=
op_start[0] = -min_quarterword
for j = 1; j <= 255; j++ {
	op_start[j] = op_start[j-1] + qo(trie_used[j-1])
}
for j = 1; j <= trie_op_ptr; j++ {
	trie_op_hash[trie_op_size+j] = op_start[trie_op_lang[j]] + trie_op_val[j] // 목적지
}
for j = 1; j <= trie_op_ptr; j++ {
	for trie_op_hash[trie_op_size+j] > j {
		k = trie_op_hash[trie_op_size+j]
		t = hyf_distance[k]; hyf_distance[k] = hyf_distance[j]; hyf_distance[j] = t
		t = hyf_num[k]; hyf_num[k] = hyf_num[j]; hyf_num[j] = t
		t = hyf_next[k]; hyf_next[k] = hyf_next[j]; hyf_next[j] = t
		trie_op_hash[trie_op_size+j] = trie_op_hash[trie_op_size+k]; trie_op_hash[trie_op_size+k] = k
	}
}

@ 지금까지 말한 자료 구조를 어떻게 초기화하는지 잊기 전에, 그것들을 출발시키는 코드를 적어 두자.

@<표의 항목들을 초기화한다...@>=
for k = -trie_op_size; k <= trie_op_size; k++ {
	trie_op_hash[trie_op_size+k] = 0
}
for k = 0; k <= 255; k++ {
	trie_used[k] = min_quarterword
}
trie_op_ptr = 0

@ 하이픈 넣기 패턴을 전처리하는 데 쓰는 연결 트라이는 여러 전역 배열에 있다. 각 노드는 ``문자 |c|를 보면 연산 |o|를 수행하고,
다음 문자로 옮겨 가서 노드 |l|로 가라. 그렇지 않으면 노드 |r|로 가라'' 꼴의 명령을 나타낸다. 네 양 |c|, |o|, |l|, |r|은 네 배열
|trie_c|, |trie_o|, |trie_l|, |trie_r|에 저장된다. 트라이의 뿌리는 |trie_l[0]|이고, 노드의 수는 |trie_ptr|다. 널 트라이 포인터는
0으로 나타낸다. 트라이를 초기화하려면 그냥 |trie_l[0]|과 |trie_ptr|를 0으로 하면 된다. 알고리즘이 |trie_c[0]|에 접근할 수도
있으므로 거기에도 아무 값이나 넣어 둔다.

알고리즘은 $$\hbox{|z!=0|이고 |trie_r[z]!=0|일 때마다 |trie_c[trie_r[z]]>trie_c[z]|}$$라는 조건을 지킨다. 다시 말해 형제 노드들은
|c| 필드 순서로 놓인다.

@<전역 변수@>=
func trie_root() trie_pointer { return trie_l[0] } // 연결 트라이의 뿌리
func set_trie_root(v trie_pointer) { trie_l[0] = v }

var @!trie_c [trie_size + 1]packed_ASCII_code // 맞출 문자
var @!trie_o [trie_size + 1]quarterword // 수행할 연산
var @!trie_l [trie_size + 1]trie_pointer // 왼쪽 부분 트라이 링크
var @!trie_r [trie_size + 1]trie_pointer // 오른쪽 부분 트라이 링크
var @!trie_ptr trie_pointer // 트라이의 노드 수
var @!trie_hash [trie_size + 1]trie_pointer // 동치인 부분 트라이를 찾아내는 데 쓴다

@ 연결 트라이가 이미 만들어져 있다고 하자. 경험에 따르면 공통 부분 트라이를 알아보면 그 크기를 줄일 수 있는 일이 많다. 그래서
이 목적으로 |trie_op_hash|와 조금 비슷한 또 하나의 해시 표를 들여온다. 새 해시 표는 0으로 초기화한다.

함수 |trie_node(p)|는 |p|가 지금까지 본 다른 노드들과 다르면 |p|를 돌려주고, 그렇지 않으면 처음 본 동치인 노드의 번호를
돌려준다.

서로 다른 언어의 패턴에 대응해서 트라이 연산의 뜻이 아주 다를 수 있는 부분 트라이들도 동치로 만들 수 있다는 것에 주목하라.
그래도 전혀 문제없다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func trie_node(p trie_pointer) trie_pointer { // 표준 꼴로 바꾼다
	var h trie_pointer // 시험 해시 자리
	var q trie_pointer // 시험 트라이 노드
	h = abs(int32(trie_c[p])+1009*trie_o[p]+2718*trie_l[p]+3142*trie_r[p]) % trie_size
	for {
		q = trie_hash[h]
		if q == 0 {
			trie_hash[h] = p; return p
		}
		if trie_c[q] == trie_c[p] && trie_o[q] == trie_o[p] && trie_l[q] == trie_l[p] && trie_r[q] == trie_r[p] {
			return q
		}
		if h > 0 { h-- } else { h = trie_size }
	}
}

@ 이제 깔끔한 재귀 프로시저가 트라이를 지나가며 그 노드들에 ``아래에서 위로'' |trie_node|를 적용해서 트라이를 압축할 수 있다.
배열 |trie_hash|를 0으로 지운 다음 `|trie_root:=compress_trie(trie_root)|'라고 하면 트라이 전체를 압축한다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func compress_trie(p trie_pointer) trie_pointer {
	if p == 0 {
		return 0
	} else {
		trie_l[p] = compress_trie(trie_l[p])
		trie_r[p] = compress_trie(trie_r[p])
		return trie_node(p)
	}
}

@ 압축된 트라이는 ``위에서 아래로 처음 맞는 곳''(top-down first-fit) 절차로 배열 |trie|에 채워 넣는다. 이것은 조금 까다로우므로
독자는 주의를 기울여야 한다. 이 단계에서 배열 |trie_hash|는 다시 0으로 지워지고 |trie_ref|라는 이름으로 바뀐다. 나중에
|trie_ref[p]|는 연결 트라이 노드 |p|가 한 가족에서 가장 작은 문자이고, 그 가족의 문자 |c|들이 배열 |trie|의 자리 |trie_ref[p]+c|에
배정되었을 때에만 0이 아니다. 배열 |trie|에서 쓰고 있는 자리는 |trie_link=0|이고, |trie|에서 쓰지 않는 구멍들은 이중으로 이어져서
|trie_link|는 다음으로 큰 빈 자리를, |trie_back|은 다음으로 작은 빈 자리를 가리킨다. 이 이중 연결은 |trie_max|까지만 되어 있는데,
|trie_max|는 필요할 |trie|의 가장 큰 첨자다. 트라이의 낮은 쪽에서 시간을 아끼려고 배열 항목 |trie_min[c]|가 |c|보다 큰 가장 작은
구멍을 가리키게 한다. 또 하나의 배열 |trie_taken|은 주어진 자리가 어떤 |p|의 |trie_ref[p]|와 같은지 알려 준다. 이 배열은 압축된
트라이의 서로 다른 노드들이 서로 다른 |trie_ref| 항목을 가지도록 하는 데 쓰인다.

보충: 원본의 |trie_ref|는 |trie_hash|를 가리키는 매크로다. 이 번역에서는 같은 배열을 가리키는 포인터로 옮긴다. \GO/에서는 배열
포인터에도 첨자를 쓸 수 있다.

@<전역 변수@>=
var @!trie_ref = &trie_hash // 연결 트라이 가족이 |trie|에 들어가는 곳

func trie_back(p trie_pointer) halfword { return trie[p].lh } // |trie| 구멍의 뒤로 가는 링크
func set_trie_back(p trie_pointer, v halfword) { trie[p].lh = v }

var @!trie_taken [trie_size + 1]bool // 여기서 가족이 시작하는가? 첨자 |1..trie_size|
var @!trie_min [256]trie_pointer // 문자마다 가능한 첫 자리
var @!trie_max trie_pointer // |trie|에서 쓴 가장 큰 자리
var @!trie_not_ready bool // 트라이가 아직 연결된 꼴인가?

@ 명령 \.{\\patterns}가 나타날 때마다 앞으로 만들 트라이에 패턴을 더 보탠다. 트라이는 하이픈 넣기를 시도하거나 포맷 파일을 덤프할
때에만 만들어진다. 불 변수 |trie_not_ready|는 트라이를 압축할 때 |false|로 바뀌고, 그러면 패턴을 더 보탤 수 없다.

@<표의 항목들을 초기화한다...@>=
trie_not_ready = true; set_trie_root(0); trie_c[0] = si(0); trie_ptr = 0

@ 다음은 트라이 압축 자료 구조를 초기화하는 방법이다. 저장 공간이 빠듯하면 |trie_op_hash|, |trie_op_lang|, |trie_op_val|을
|trie|, |trie_hash|, |trie_taken|과 겹쳐 쓸 수도 있을 것이다. 앞의 것들을 다 쓰고 나서야 뒤의 것들이 필요하기 때문이다.

@<트라이를 압축할 준비를 한다@>=
@<하이픈 넣기 연산 표를...@>
for p = 0; p <= trie_size; p++ {
	trie_hash[p] = 0
}
set_trie_root(compress_trie(trie_root())) // 동치인 부분 트라이를 찾아낸다
for p = 0; p <= trie_ptr; p++ {
	trie_ref[p] = 0
}
for p = 0; p <= 255; p++ {
	trie_min[p] = p + 1
}
set_trie_link(0, 1); trie_max = 0

@ 프로시저 |first_fit|는 주어진 노드 |p|에서 시작하는 트라이 가족이 |z|에서 시작하는 빈 자리들에 들어맞는 |trie|의 가장 작은
구멍 |z|를 찾는다. 그리고 |c=trie_c[p]|이면, 이것은 자리 |z-c|를 다른 가족이 이미 차지하지 않았어야 하고, 가족의 모든 문자 $c^\prime$에
대해 |z-c+@t$c^\prime$@>|가 비어 있어야 한다는 뜻이다. 이 프로시저는 처음 맞는 곳을 찾으면 |trie_ref[p]|를 |z-c|로 한다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func first_fit(p trie_pointer) { // 가족 하나를 |trie|에 채워 넣는다
	var h trie_pointer // |trie_ref[p]|의 후보
	var z trie_pointer // 구멍들을 훑는다
	var q trie_pointer // |p|에서 시작하는 가족을 훑는다
	var c ASCII_code // 가족에서 가장 작은 문자
	var l, r trie_pointer // 왼쪽과 오른쪽 이웃
	var ll int32 // |trie_min|을 갱신할 위 한계; |1..256|
	c = so(trie_c[p])
	z = trie_min[c] // 처음으로 그럴듯한 구멍을 얻는다
	for {
		h = z - c
		@<|trie_max>=h+256|이 되게 한다@>
		if trie_taken[h] {
			goto not_found
		}
		@<가족의 모든 문자가 |h|에 대해 들어맞으면 |goto found|, 아니면 |goto not_found|@>
	not_found:
		z = trie_link(z) // 다음 구멍으로 옮긴다
	}
found:
	@<가족을 |h|에 대해 |trie|에 채워 넣는다@>
}

@ 한계 |trie_max|가 적어도 |h+256|이 되게 하면 |h=z-c|이므로 |trie_max>z|임을 확신할 수 있다. 따라서 자리 |trie_max|는 |trie|에서 결코
차지되지 않을 것이고, |trie_max>=trie_link(z)|일 것이다.

@<|trie_max>=h+256|이...@>=
if trie_max < h+256 {
	if trie_size <= h+256 {
		overflow("pattern memory", trie_size)
	}
@:TeX capacity exceeded pattern memory}{\quad pattern memory@>
	for {
		trie_max++; trie_taken[trie_max] = false
		set_trie_link(trie_max, trie_max+1); set_trie_back(trie_max, trie_max-1)
		if trie_max == h+256 {
			break
		}
	}
}

@ @<가족의 모든 문자가...@>=
q = trie_r[p]
for q > 0 {
	if trie_link(h+so(trie_c[q])) == 0 {
		goto not_found
	}
	q = trie_r[q]
}
goto found

@ @<가족을 |h|에 대해...@>=
trie_taken[h] = true; trie_ref[p] = h; q = p
for {
	z = h + so(trie_c[q]); l = trie_back(z); r = trie_link(z)
	set_trie_back(r, l); set_trie_link(l, r); set_trie_link(z, 0)
	if l < 256 {
		if z < 256 { ll = z } else { ll = 256 }
		for {
			trie_min[l] = r; l++
			if l == ll {
				break
			}
		}
	}
	q = trie_r[q]
	if q == 0 {
		break
	}
}

@ 연결 트라이 전체를 채워 넣으려면 다음 재귀 프로시저를 쓴다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func trie_pack(p trie_pointer) { // 한 가족의 부분 트라이들을 채워 넣는다
	var q trie_pointer // 재귀 호출에서 저장할 필요가 없는 지역 변수
	for {
		q = trie_l[p]
		if q > 0 && trie_ref[q] == 0 {
			first_fit(q); trie_pack(q)
		}
		p = trie_r[p]
		if p == 0 {
			break
		}
	}
}

@ 트라이 전체를 순차 표에 배정하고 나면, |trie|가 올바른 정보를 담도록 한 번 더 지나가야 한다. 연결 트라이의 널 포인터는 값~0으로
나타내는데, 이것은 ``빈'' 가족을 제대로 구현한다.

@<자료를 |trie|로 옮긴다@>=
h.rh = 0; h.b0 = min_quarterword; h.b1 = min_quarterword // |trie_link:=0|, |trie_op:=min_quarterword|, |trie_char:=qi(0)|
if trie_root() == 0 { // 패턴이 하나도 주어지지 않았다
	for r = 0; r <= 256; r++ {
		trie[r] = h
	}
	trie_max = 256
} else {
	trie_fix(trie_root()) // 이것이 |trie|의 구멍 아닌 곳을 바로잡는다
	r = 0 // 이제 구멍을 모두 0으로 지운다
	for {
		s = trie_link(r); trie[r] = h; r = s
		if r > trie_max {
			break
		}
	}
}
set_trie_char(0, qi('?')) // 모든 |c|에 대해 |trie_char(c)!=c|가 되게 한다

@ 바로잡는 프로시저는 물론 재귀적이다. 연결 트라이에는 대개 겹치는 부분 트라이가 있으므로 같은 자료를 여러 번 옮길 수도
있다. 그러나 그래도 해가 없고, 많아야 압축하지 않은 트라이를 만드는 데 든 만큼의 일만 한다.
@^recursion@>

@<하이픈 넣기 패턴을 전처리하는...@>=
func trie_fix(p trie_pointer) { // |p|와 그 형제들을 |trie|로 옮긴다
	var q trie_pointer // 재귀 호출에서 저장할 필요가 없는 지역 변수
	var c ASCII_code // 저장할 필요가 없는 또 하나
	var z trie_pointer // |trie| 참조; 이 지역 변수는 저장해야 한다
	z = trie_ref[p]
	for {
		q = trie_l[p]; c = so(trie_c[p])
		set_trie_link(z+c, trie_ref[q]); set_trie_char(z+c, qi(c)); set_trie_op(z+c, trie_o[p])
		if q > 0 {
			trie_fix(q)
		}
		p = trie_r[p]
		if p == 0 {
			break
		}
	}
}

@ 이제 더 쉬운 문제, 곧 연결 트라이를 만드는 문제로 돌아가자. \.{INITEX}가 제어 시퀀스 `\.{\\patterns}'를 훑으면, 알맞은 일을
하는 |new_patterns|를 부른다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func new_patterns() { // 하이픈 넣기 패턴 자료를 초기화한다
	var k, l int32 // |hc|와 |hyf|의 첨자; |0..64|, 늘 |small_number| 범위인 것은 아니다
	var digit_sensed bool // 다음 숫자를 글자로 다루어야 하는가?
	var v quarterword // 트라이 연산 코드
	var p, q trie_pointer // 끼워 넣는 동안 지나가는 트라이 노드
	var first_child bool // |p=trie_l[q]|인가?
	var c ASCII_code // 끼워 넣는 문자
	if trie_not_ready {
		set_cur_lang(); scan_left_brace() // \.{\\patterns} 뒤에는 왼쪽 중괄호가 와야 한다
		@<오른쪽 중괄호에 이를 때까지 모든 패턴을 연결 트라이에 넣는다@>
	} else {
		print_err("Too late for "); print_esc("patterns")
		help1("All patterns must be given before typesetting begins.")
		error(); set_link(garbage, scan_toks(false, false)); flush_list(def_ref)
	}
}

@ 초보자는 \.{\\patterns}를 쓰지 않을 것으로 보므로 오류 메시지가 간결하다. (\.{INITEX}에서만 쓰더라도 모든 오류 메시지는
\TeX의 문자열 풀에 있다는 것에 주의하라.)

@<오른쪽 중괄호에 이를 때까지 모든 패턴을...@>=
k = 0; hyf[0] = 0; digit_sensed = false
for {
	get_x_token()
	switch cur_cmd {
	case letter, other_char: @<새 글자나 하이픈 수준을 덧붙인다@>
	case spacer, right_brace:
		if k > 0 {
			@<연결 트라이에 새 패턴을 넣는다@>
		}
		if cur_cmd == right_brace {
			goto done
		}
		k = 0; hyf[0] = 0; digit_sensed = false
	default:
		print_err("Bad "); print_esc("patterns")
@.Bad \\patterns@>
		help1("(See Appendix H.)"); error()
	}
}
done:

@ @<새 글자나 하이픈 수준을...@>=
if digit_sensed || cur_chr < '0' || cur_chr > '9' {
	if cur_chr == '.' {
		cur_chr = 0 // 낱말 가장자리 구분자
	} else {
		cur_chr = lc_code(cur_chr)
		if cur_chr == 0 {
			print_err("Nonletter")
@.Nonletter@>
			help1("(See Appendix H.)"); error()
		}
	}
	if k < 63 {
		k++; hc[k] = cur_chr; hyf[k] = 0; digit_sensed = false
	}
} else if k < 63 {
	hyf[k] = cur_chr - '0'; digit_sensed = true
}

@ 다음 코드가 작동할 때 패턴 $p_1\ldots p_k$는 |hc[1..k]|에 있고, 대응하는 수 나열 $n_0\ldots n_k$는 |hyf[0..k]|에 있다.

@<연결 트라이에 새 패턴을...@>=
@<트라이 연산 코드 |v|를 계산하고 |l:=0|으로 한다@>
q = 0; hc[0] = cur_lang
for l <= k {
	c = hc[l]; l++; p = trie_l[q]; first_child = true
	for p > 0 && c > so(trie_c[p]) {
		q = p; p = trie_r[q]; first_child = false
	}
	if p == 0 || c < so(trie_c[p]) {
		@<|q|와 |p| 사이에 새 트라이 노드를 넣고 |p|가 그것을 가리키게 한다@>
	}
	q = p // 이제 노드 |q|는 $p_1\ldots p_{l-1}$을 나타낸다
}
if trie_o[q] != min_quarterword {
	print_err("Duplicate pattern")
@.Duplicate pattern@>
	help1("(See Appendix H.)"); error()
}
trie_o[q] = v

@ @<|q|와 |p| 사이에 새 트라이 노드를...@>=
if trie_ptr == trie_size {
	overflow("pattern memory", trie_size)
}
@:TeX capacity exceeded pattern memory}{\quad pattern memory@>
trie_ptr++; trie_r[trie_ptr] = p; p = trie_ptr; trie_l[p] = 0
if first_child { trie_l[q] = p } else { trie_r[q] = p }
trie_c[p] = si(c); trie_o[p] = min_quarterword

@ @<트라이 연산 코드 |v|를...@>=
if hc[1] == 0 {
	hyf[0] = 0
}
if hc[k] == 0 {
	hyf[k] = 0
}
l = k; v = min_quarterword
for {
	if hyf[l] != 0 {
		v = new_trie_op(k-l, hyf[l], v)
	}
	if l > 0 { l-- } else { goto done1 }
}
done1:

@ 마침내 모든 것을 한데 모은다. 트라이가 최종의 효율적인 꼴에 이르는 방법은 이렇다. 다음 채워 넣기 루틴은 연결 트라이의 뿌리가
하이픈 넣기 알고리즘이 요구하는 대로 |trie|의 자리 1로 가도록 꾸며져 있다. 프로시저 |first_fit|의 첫 호출이 자리~1을 ``차지''하기
때문이다.

@<하이픈 넣기 패턴을 전처리하는...@>=
func init_trie() {
	var p trie_pointer // 초기화를 위한 포인터
	var j, k, t int32 // 초기화를 위한 만능 레지스터들
	var r, s trie_pointer // 채워 넣은 |trie|를 청소하는 데 쓴다
	var h two_halves // |trie|의 구멍을 0으로 지우는 데 쓰는 틀
	@<트라이를 압축할 준비를 한다@>
	if trie_root() != 0 {
		first_fit(trie_root()); trie_pack(trie_root())
	}
	@<자료를 |trie|로 옮긴다@>
	trie_not_ready = false
}

@* 세로 목록을 쪽으로 나누기.
\TeX의 \.{\\vsplit} 연산을 구현하는 프로시저 |vsplit|는 |line_break|보다 훨씬 단순하다. 하이픈 넣기를 걱정하지 않아도 되고,
그 임무가 나눔점의 최적 나열이 아니라 나눔 하나를 찾는 것이기 때문이다. 그러나 |vsplit|의 세부로 들어가기 전에 좀 더 기본적인
것 몇 가지를 생각해야 한다.

@ 서브루틴 |prune_page_top|은 세로 목록을 가리키는 포인터를 받아서, 첫 상자나 괘선 노드 앞의 모든 글루, 커닝, 벌점 노드를 지운
고친 세로 목록을 가리키는 포인터를 돌려준다. 다만 첫 상자나 괘선 앞에는 새로 만든 글루 노드를 실제로 놓는데, 이 글루는 뒤로
물러서지 않고도 가능하다면 맨 위 기준선이 위 끝에서 |split_top_skip|만큼 떨어지도록 짜여 있다.

이 루틴과 뒤따르는 루틴들에서는 세로 목록에 문자 노드가 없다는 사실, 그래서 목록의 모든 노드에 |type| 필드가 있다는 사실을
이용한다.
@^data structure assumptions@>

@<함수들@>=
func prune_page_top(p pointer) pointer { // 쪽 나눔 뒤에 위 끝을 맞춘다
	var prev_p pointer // |p|보다 한 걸음 뒤처진다
	var q pointer // 목록을 다루는 임시 변수
	prev_p = temp_head; set_link(temp_head, p)
	for p != null {
		switch type_(p) {
		case hlist_node, vlist_node, rule_node:
			@<|split_top_skip|을 위한 글루를 넣고 |p:=null|로 한다@>
		case whatsit_node, mark_node, ins_node:
			prev_p = p; p = link(prev_p)
		case glue_node, kern_node, penalty_node:
			q = p; p = link(q); set_link(q, null)
			set_link(prev_p, p); flush_node_list(q)
		default: confusion("pruning")
@:this can't happen pruning}{\quad pruning@>
		}
	}
	return link(temp_head)
}

@ @<|split_top_skip|을 위한 글루를...@>=
q = new_skip_param(split_top_skip_code); set_link(prev_p, q); set_link(q, p)
// 이제 |temp_ptr=glue_ptr(q)|
if width(temp_ptr) > height(p) {
	set_width(temp_ptr, width(temp_ptr)-height(p))
} else {
	set_width(temp_ptr, 0)
}
p = null

@ 다음 서브루틴은 주어진 세로 목록을 나누어 높이~|h|, 최대 깊이~|d|인 상자를 얻을 가장 좋은 자리를 찾는다. 세로 목록의 시작을
가리키는 포인터가 주어지고, 최적 나눔점을 가리키는 포인터를 돌려준다. 목록 뒤에는 사실상 강제 나눔, 곧 |eject_penalty|를 가진
벌점 노드가 온다. 가장 좋은 나눔이 이 인위적인 노드에서 일어나면 값 |null|을 돌려준다.

프로시저 |line_break|에서처럼 |scaled| 거리 여섯 개의 배열을 써서 목록의 처음부터 현재 자리까지의 높이를 기록한다. 실은 같은 배열 가운데
하나를 쓰되, 새 뜻을 반영하도록 이름만 바꾼다.

보충: 원본의 |active_height|는 |active_width|의 새 이름이고, |cur_height|는 |active_height[1]|을 가리키는 매크로다. 이 번역에서
|active_height|는 |active_width|를 가리키는 포인터이고, |cur_height|는 대입할 수 있어야 하므로 |active_height[1]|이라고 바로
쓴다. 원본은 레이블 |update_heights|에 번호 90을 매기는 정의도 둔다.

@<전역 변수@>=
var @!active_height = &active_width // 거리 변수 여섯 개의 새 이름

@ \dg 앞 절의 함수 |vert_break|를 옮긴다.

@<함수들@>=
func vert_break(p pointer, h, d scaled) pointer { // 최적 쪽 나눔을 찾는다
	var prev_p pointer // |p|가 글루 노드이면 |type(prev_p)|가 |p|가 합법적인 나눔점인지 정한다
	var q, r pointer // 글루 명세
	var pi int32 // 벌점 값
	var b int32 // 시험 나눔점의 나쁨
	var least_cost int32 // 지금까지 찾은 가장 작은 나쁨과 벌점의 합
	var best_place pointer // |least_cost|에 이르는 가장 최근의 나눔
	var prev_dp scaled // 목록에서 앞 상자의 깊이
	var t small_number // 커닝 다음 노드의 |type|
	prev_p = p // 처음의 글루 노드는 합법적인 나눔점이 아니다
	least_cost = awful_bad
	for k := int32(1); k <= 6; k++ {
		active_height[k] = 0 // |set_height_zero|
	}
	prev_dp = 0
	for {
		@<노드 |p|가 합법적인 나눔점이면 가장 좋은지 검사한다@>
		prev_p = p; p = link(prev_p)
	}
done:
	return best_place
}

@ 전역 변수 |best_height_plus_depth|는 |vert_break|가 찾은 최적 나눔점에 대응하는 상자의 자연 크기로 정해진다. (이 값은 쪽
조립기의 삽입물 나누기 알고리즘이 쓴다.)

@<전역 변수@>=
var @!best_height_plus_depth scaled // 늘이거나 줄이지 않은 가장 좋은 상자의 높이

@ 여기서 주목할 미묘한 점은 최대 깊이~|d|가 음수일 수도 있다는 것이다. 그래서 글루나 커닝 노드 뒤에서도 |cur_height|와
|prev_dp|를 바로잡아야 할 수 있다.

노드 |p|가 합법적인 나눔점이면 이 나눔이 알려진 것 가운데 가장 좋은지 검사하고, |p|가 널이거나 지금까지의 쪽이 이미 너무 차서
더 받을 수 없으면 |goto done|한다.

@<노드 |p|가 합법적인 나눔점이면...@>=
if p == null {
	pi = eject_penalty
} else {
	@<노드 |p|로 현재 높이와 깊이 측정값을 갱신한다@>
}
@<노드 |p|가 새 챔피언 나눔점인지 검사한다@>
if type_(p) < glue_node || type_(p) > kern_node {
	goto not_found
}
update_heights:
	@<글루나 커닝 노드~|p|에 대해 현재 높이와 깊이 측정값을 갱신한다@>
not_found:
	if prev_dp > d {
		active_height[1] = active_height[1] + prev_dp - d
		prev_dp = d
	}

@ 이 노드가 합법적인 나눔점이 아니면 |goto not_found|나 |goto update_heights|하고, 그렇지 않으면 |pi|를 그 나눔에 딸린 벌점으로
정한다.

@<노드 |p|로 현재 높이와...@>=
switch type_(p) {
case hlist_node, vlist_node, rule_node:
	active_height[1] = active_height[1] + prev_dp + height(p); prev_dp = depth(p)
	goto not_found
case whatsit_node: @<|vert_break| 루프에서 whatsit |p|를 처리하고 |goto not_found|@>
case glue_node:
	if precedes_break(prev_p) {
		pi = 0
	} else {
		goto update_heights
	}
case kern_node:
	if link(p) == null {
		t = penalty_node
	} else {
		t = type_(link(p))
	}
	if t == glue_node { pi = 0 } else { goto update_heights }
case penalty_node: pi = penalty(p)
case mark_node, ins_node: goto not_found
default: confusion("vertbreak")
@:this can't happen vertbreak}{\quad vertbreak@>
}

@ 노드 |p|가 강제 나눔이거나 지금까지의 쪽이 이미 너무 찼으면 |goto done|한다.

@<노드 |p|가 새 챔피언...@>=
if pi < inf_penalty {
	@<나쁨 |b|를 계산하되, 상자가 너무 차면 |awful_bad|로 한다@>
	if b < awful_bad {
		if pi <= eject_penalty {
			b = pi
		} else if b < inf_bad {
			b = b + pi
		} else {
			b = deplorable
		}
	}
	if b <= least_cost {
		best_place = p; least_cost = b
		best_height_plus_depth = active_height[1] + prev_dp
	}
	if b == awful_bad || pi <= eject_penalty {
		goto done
	}
}

@ \dg 앞 절의 정의부를 옮긴다.

@<정의@>=
const @!deplorable = 100000 // |inf_bad|보다 크지만 |awful_bad|보다 작다

@ @<나쁨 |b|를 계산하되...@>=
if active_height[1] < h {
	if active_height[3] != 0 || active_height[4] != 0 || active_height[5] != 0 {
		b = 0
	} else {
		b = badness(h-active_height[1], active_height[2])
	}
} else if active_height[1]-h > active_height[6] {
	b = awful_bad
} else {
	b = badness(active_height[1]-h, active_height[6])
}

@ 프로시저 |vert_break|를 거칠 세로 목록에는 무한 줄어듦이 없어야 한다. 그런 것이 있으면 아무리 많은 정보라도 한 쪽에 ``들어맞을''
수 있을 것이기 때문이다.

@<글루나 커닝 노드~|p|에 대해...@>=
if type_(p) == kern_node {
	q = p
} else {
	q = glue_ptr(p)
	active_height[2+stretch_order(q)] = active_height[2+stretch_order(q)] + stretch(q)
	active_height[6] = active_height[6] + shrink(q)
	if shrink_order(q) != normal && shrink(q) != 0 {
		print_err("Infinite glue shrinkage found in box being split")
@.Infinite glue shrinkage...@>
		help4("The box you are \\vsplitting contains some infinitely",
			"shrinkable glue, e.g., `\\vss' or `\\vskip 0pt minus 1fil'.",
			"Such glue doesn't belong there; but you can safely proceed,",
			"since the offensive shrinkability has been made finite.")
		error(); r = new_spec(q); set_shrink_order(r, normal); delete_glue_ref(q)
		set_glue_ptr(p, r); q = r
	}
}
active_height[1] = active_height[1] + prev_dp + width(q); prev_dp = 0

@ 이제 |vsplit| 자체를 살펴볼 준비가 되었다. 그 일의 대부분은 방금 살펴본 두 서브루틴이 해낸다.

세로 목록 상자의 번호 |n|과 원하는 쪽 높이 |h|가 주어지면, 함수 |vsplit|는 그 세로 목록의 가장 좋은 첫 토막을 찾아서 높이~|h|인
쪽을 위한 상자를 돌려준다. 세로 목록의 나머지가 있으면, 글루와 벌점을 없애고 |split_top_skip|에 맞추어 조정한 뒤 원래 상자를
대신한다. 떼어 낸 상자 안의 표시 노드는 |split_first_mark|와 |split_bot_mark|의 값을 정하는 데 쓰인다. 여기서는 |split_bot_mark=null|일
때, 그리고 오직 그때에만 |split_first_mark=null|이라는 사실을 이용한다.

원래 상자는 전부 떼어 냈을 때, 그리고 오직 그때에만 ``빈'' 상자가 된다. 떼어 낸 상자는 원래 상자가 비어 있었을 때(또는
잘못해서 가로 목록 상자였을 때), 그리고 오직 그때에만 ``빈'' 상자가 된다.

@<함수들@>=
func vsplit(n eight_bits, h scaled) pointer { // 상자 |n|에서 높이 |h|인 쪽을 떼어 낸다
	var v pointer // 나눌 상자
	var p pointer // 세로 목록을 훑는다
	var q pointer // 나눔이 일어나는 곳을 가리킨다
	v = box(n)
	if split_first_mark() != null {
		delete_token_ref(split_first_mark()); set_split_first_mark(null)
		delete_token_ref(split_bot_mark()); set_split_bot_mark(null)
	}
	@<비었거나 잘못된 상자의 자명한 경우를 처리한다@>
	q = vert_break(list_ptr(v), h, split_max_depth())
	@<나눔 앞 노드들의 표시를 모두 살피고, 나눔에서 마지막 링크를 |null|로 한다@>
	q = prune_page_top(q); p = list_ptr(v); free_node(v, box_node_size)
	if q == null {
		set_box_reg(n, null) // 상자의 |eq_level|은 그대로다
	} else {
		set_box_reg(n, vpack(q, natural, additional))
	}
	return vpackage(p, h, exactly, split_max_depth())
}

@ @<비었거나 잘못된 상자의...@>=
if v == null {
	return null
}
if type_(v) != vlist_node {
	print_err(""); print_esc("vsplit"); print(" needs a ")
	print_esc("vbox")
@:vsplit_}{\.{\\vsplit needs a \\vbox}@>
	help2("The box you are trying to split is an \\hbox.",
		"I can't split such a box, so I'll leave it alone.")
	error(); return null
}

@ 상자가 ``가장 좋은'' 나눔인 벌점 노드로 시작할 수도 있으므로, 이 특별한 경우를 조심해서 제대로 다루어야 한다.

@<나눔 앞 노드들의 표시를...@>=
p = list_ptr(v)
if p == q {
	set_list_ptr(v, null)
} else {
	for {
		if type_(p) == mark_node {
			if split_first_mark() == null {
				set_split_first_mark(mark_ptr(p))
				set_split_bot_mark(split_first_mark())
				set_token_ref_count(split_first_mark(), token_ref_count(split_first_mark())+2)
			} else {
				delete_token_ref(split_bot_mark())
				set_split_bot_mark(mark_ptr(p))
				add_token_ref(split_bot_mark())
			}
		}
		if link(p) == q {
			set_link(p, null); goto done
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
|link(page_head)|에서 시작해서 |page_tail|에서 끝난다. 이 목록이 비어 있으면 |page_head=page_tail|이다.
@^current page@>

쪽을 만드는 동안 사용자가 쪽 지정을 자꾸 바꾸면 완전한 혼돈이 일어날 것이다. 그래서 쪽 조립기는 쪽이 첫 상자나 삽입물을 받자마자
관련 지정을 얼려 둔다. 전역 변수 |page_contents|는 현재 쪽에 표시 노드와 내용 없는 whatsit 노드만 있으면 |empty|이고, 표시와
whatsit 말고 삽입 노드만 있으면 |inserts_only|다. 글루 노드, 커닝 노드, 벌점 노드는 상자나 괘선 노드가 나타날 때까지 버려지고,
그런 노드가 나타나면 |page_contents|는 |box_there|로 바뀐다. 그리고 이 변수가 |empty|가 아니게 되자마자 현재의 |vsize|와
|max_depth|를 |page_goal|과 |page_max_depth|에 챙겨 둔다. 쪽이 사용자의 출력 루틴으로 넘어갈 때까지 뒤의 값들이 쓰인다.
글루 \.{\\topskip}의 조정은 |page_contents|가 |box_there|로 바뀔 때 한다.

목표 |page_goal|은 |vsize|와 같게 출발하지만, 지금까지 고려한 삽입물의 눈금 매긴 자연 높이와 깊이의 합만큼, 그리고 그 삽입물들의
\.{\\skip} 보정만큼 줄어든다. 그러므로 현재 쪽의 모든 삽입물을 넣었다고 할 때 삽입물 아닌 내용이 들어가야 할 크기를 나타낸다.

전역 변수 |best_page_break|와 |least_page_cost|는 이미 공부한 |vert_break| 루틴의 지역 변수 |best_place|와 |least_cost|에 각각
대응한다. 곧 현재 쪽을 나눌 곳으로 현재 알려진 가장 좋은 곳의 위치와 값을 기록한다. 가장 좋은 나눔 때의 |page_goal| 값은
|best_size|에 저장된다.

@<정의@>=
const (
	@!inserts_only = 1 // 삽입 노드는 들어왔지만 상자는 없을 때의 |page_contents|
	@!box_there = 2 // 상자나 괘선이 들어왔을 때의 |page_contents|
)

@ \dg 앞 절의 전역 변수를 옮긴다.

@<전역 변수@>=
var @!page_tail pointer // 현재 쪽의 마지막 노드
var @!page_contents small_number // 지금까지 현재 쪽에 무엇이 있는가? |empty..box_there|
var @!page_max_depth scaled // 만들고 있는 쪽의 최대 상자 깊이
var @!best_page_break pointer // 여기서 나누면 지금까지 알려진 가장 좋은 쪽을 얻는다
var @!least_page_cost int32 // 지금 가장 좋은 이 쪽의 점수
var @!best_size scaled // 그 |page_goal|

@ 쪽 조립기에는 삽입물을 기록하는 자료 구조가 하나 더 있다. 이것은 |page_ins_head|에서 시작해서 끝나는 네 낱말짜리 노드들의
목록이다. 곧 목록의 첫 원소는 노드 |r@t$_1$@>=link(page_ins_head)|이고, 노드 $r_j$ 다음에는 |r@t$_{j+1}$@>=link(r@t$_j$@>)|가 오며,
항목이 |n|개이면 |r@t$_{n+1}$@>=page_ins_head|이다. 이 목록의 각 노드의 |subtype| 필드는 삽입 번호를 가리킨다. 이를테면
`\.{\\insert 250}'은 |subtype|이 |qi(250)|인 노드에 대응한다(관련된 |ins_node|의 |subtype| 필드와 같다). 이 |subtype| 필드들은
커지는 차례로 놓이고, |subtype(page_ins_head)=qi(255)|이므로 |page_ins_head|는 목록 끝의 편리한 보초 구실을 한다. 현재 쪽에
나타나는 삽입 번호마다 레코드가 하나 있다.

이 노드들의 |type| 필드는 최적 쪽 나눔을 정하기 전에 앞을 내다볼 때 일어날 수 있는 두 가능성을 구별한다. 그리고 |type(r)=inserting|이면
|height(r)|에는 상자와 지금까지 본 그 모든 삽입물의 높이와 깊이 치수의 합계가 들어 있다. 또 |type(r)=split_up|이면 이 상자에는 더
삽입하지 않는다. 앞선 삽입물 가운데 적어도 하나가 너무 커서 현재 쪽에 들어가지 않았기 때문이다. 그때 |broken_ptr(r)|는 \TeX이
그 삽입물을 나누기로 정하면 나눌 노드를 가리키고, |broken_ins(r)|는 시험 삼아 나눈 삽입 노드를 가리키며, |height(r)|에는 떼어 낼
부분의 자연 높이와 깊이의 합도 들어 있다.

두 경우 모두 |last_ins_ptr(r)|는 상자 |qo(subtype(r))|를 위해 만난 |ins_node| 가운데 다음 쪽에 적어도 일부가 삽입될 마지막 것을
가리킨다. 그리고 |best_ins_ptr(r)|는 지금까지 고려한 모든 쪽 나눔 가운데 나쁨이 가장 작은 쪽을 얻으려면 실제로 삽입해야 할 그런
마지막 |ins_node|를 가리킨다. 이 최적 쪽을 만들려면 이 상자에 아무것도 삽입하지 말아야 할 때, 그리고 오직 그때에만
|best_ins_ptr(r)=null|이다.

여기서 자료 구조를 정의할 때는 |@!height| 필드가 상자 노드의 넷째 낱말에 있다는 사실을 이용한다.
@^data structure assumptions@>

@<정의@>=
const (
	@!page_ins_node_size = 4 // 쪽 삽입 노드의 낱말 수
	@!inserting = 0 // 아직 넘치지 않은 삽입 부류
	@!split_up = 1 // 넘친 삽입 부류
)

func broken_ptr(p pointer) pointer { return link(p + 1) } // 이 부류의 삽입물이 나뉜다면 여기서 나뉜다
func set_broken_ptr(p pointer, v pointer) { set_link(p+1, v) }
func broken_ins(p pointer) pointer { return info(p + 1) } // 이 삽입물이 |broken_ptr|에서 나뉠 수 있다
func set_broken_ins(p pointer, v pointer) { set_info(p+1, v) }
func last_ins_ptr(p pointer) pointer { return link(p + 2) } // 이 |subtype|의 가장 최근 삽입물
func set_last_ins_ptr(p pointer, v pointer) { set_link(p+2, v) }
func best_ins_ptr(p pointer) pointer { return info(p + 2) } // 최적인 가장 최근 삽입물
func set_best_ins_ptr(p pointer, v pointer) { set_info(p+2, v) }

@ \dg 앞 절에서 특별한 목록 머리를 초기화하는 부분을 옮긴다.

@<특별한 목록 머리와...@>=
set_subtype(page_ins_head, qi(255))
set_type(page_ins_head, split_up); set_link(page_ins_head, page_ins_head)

@ 배열 |page_so_far|는 현재 쪽에 있는 모든 것의 높이와 깊이를 기록한다. 이 배열에는 |line_break|와 |vert_break|에서 이미 본
비슷한 배열들처럼 |scaled| 수 여섯 개가 들어 있고, 또 |page_goal|과 |page_depth|도 들어 있다. 이 값들은 모두 사용자가
|set_page_dimen| 명령으로 접근할 수 있기 때문이다. 원소 |page_so_far[1]|의 값은 |page_total|이라고도 부른다. 각 삽입물의
\.{\\skip} 보정의 늘어남과 줄어듦 성분은 |page_so_far|에 들어가지만, 보정의 자연 공간 성분은 들어가지 않는다. 그것은
|page_goal|에서 이미 뺐기 때문이다.

변수 |page_depth|는 현재 쪽의 깊이를 기록한다. 이 값은 많아야 |page_max_depth|가 되도록 조정되어 있다. 변수 |last_glue|는
기여 목록에서 가장 최근에 들어온 노드가 글루 노드였으면 그 글루 명세를 가리키고, 그렇지 않으면 |last_glue=max_halfword|이다.
(그러나 기여 목록이 비어 있지 않으면 |last_glue|의 값이 반드시 정확하지는 않다.) 변수 |last_penalty|와 |last_kern|도 비슷하다.
그리고 마지막으로 |insert_penalties|는 나뉜 삽입물과 떠다니는 삽입물에 딸린 벌점의 합을 담는다.

@<전역 변수@>=
func page_goal() scaled { return page_so_far[0] } // 만들고 있는 쪽에 들어갈 정보의 원하는 높이
func set_page_goal(v scaled) { page_so_far[0] = v }
func page_total() scaled { return page_so_far[1] } // 현재 쪽의 높이
func set_page_total(v scaled) { page_so_far[1] = v }
func page_shrink() scaled { return page_so_far[6] } // 현재 쪽의 줄일 수 있는 양
func set_page_shrink(v scaled) { page_so_far[6] = v }
func page_depth() scaled { return page_so_far[7] } // 현재 쪽의 깊이
func set_page_depth(v scaled) { page_so_far[7] = v }

var @!page_so_far [8]scaled // 현재 쪽의 높이와 글루
var @!last_glue pointer // \.{\\lastskip}을 구현하는 데 쓴다
var @!last_penalty int32 // \.{\\lastpenalty}를 구현하는 데 쓴다
var @!last_kern scaled // \.{\\lastkern}을 구현하는 데 쓴다
var @!insert_penalties int32 // 미루어 둔 삽입물에 대한 벌점의 합

@ @<\TeX의 원시 명령을...@>=
primitive("pagegoal", set_page_dimen, 0)
@!@:page_goal_}{\.{\\pagegoal} primitive@>
primitive("pagetotal", set_page_dimen, 1)
@!@:page_total_}{\.{\\pagetotal} primitive@>
primitive("pagestretch", set_page_dimen, 2)
@!@:page_stretch_}{\.{\\pagestretch} primitive@>
primitive("pagefilstretch", set_page_dimen, 3)
@!@:page_fil_stretch_}{\.{\\pagefilstretch} primitive@>
primitive("pagefillstretch", set_page_dimen, 4)
@!@:page_fill_stretch_}{\.{\\pagefillstretch} primitive@>
primitive("pagefilllstretch", set_page_dimen, 5)
@!@:page_filll_stretch_}{\.{\\pagefilllstretch} primitive@>
primitive("pageshrink", set_page_dimen, 6)
@!@:page_shrink_}{\.{\\pageshrink} primitive@>
primitive("pagedepth", set_page_dimen, 7)
@!@:page_depth_}{\.{\\pagedepth} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case set_page_dimen:
	switch chr_code {
	case 0: print_esc("pagegoal")
	case 1: print_esc("pagetotal")
	case 2: print_esc("pagestretch")
	case 3: print_esc("pagefilstretch")
	case 4: print_esc("pagefillstretch")
	case 5: print_esc("pagefilllstretch")
	case 6: print_esc("pageshrink")
	default: print_esc("pagedepth")
	}

@ 보충: 원본의 매크로 |print_plus(#)|는 |page_so_far[#]|가 0이 아니면 `\.{ plus }'와 그 값과 단위를 찍는다. 네 번 쓰이므로 여기서는
펼쳐 쓰는 대신 루프로 쓴다.

@<함수들@>=
func print_totals() {
	print_scaled(page_total())
	for i, unit := range [...]string{"", "fil", "fill", "filll"} { // |print_plus(2..5)|
		if page_so_far[2+i] != 0 {
			print(" plus "); print_scaled(page_so_far[2+i]); print(unit)
		}
	}
	if page_shrink() != 0 {
		print(" minus "); print_scaled(page_shrink())
	}
}

@ @<현재 쪽의 상태를 보인다@>=
if page_head != page_tail {
	print_nl("### current page:")
	if output_active {
		print(" (held over for next output)")
	}
@.held over for next output@>
	show_box(link(page_head))
	if page_contents > empty {
		print_nl("total height "); print_totals()
@:total_height}{\.{total height}@>
		print_nl(" goal height "); print_scaled(page_goal())
@.goal height@>
		r = link(page_ins_head)
		for r != page_ins_head {
			@<쪽 삽입 노드 |r|의 상태를 보인다@>
			r = link(r)
		}
	}
}

@ \dg 앞 절의 루프 몸체다.

@<쪽 삽입 노드 |r|의 상태를...@>=
print_ln(); print_esc("insert"); t = qo(subtype(r))
print_int(t); print(" adds ")
if count(t) == 1000 {
	t = height(r)
} else {
	t = x_over_n(height(r), 1000) * count(t)
}
print_scaled(t)
if type_(r) == split_up {
	q = page_head; t = 0
	for {
		q = link(q)
		if type_(q) == ins_node && subtype(q) == subtype(r) {
			t++
		}
		if q == broken_ins(r) {
			break
		}
	}
	print(", #"); print_int(t); print(" might split")
}

@ 다음은 |page_contents|가 |empty|에서 |inserts_only|나 |box_there|로 바뀔 때 부르는 프로시저다.

@<함수들@>=
func freeze_page_specs(s small_number) {
	page_contents = s
	set_page_goal(vsize()); page_max_depth = max_depth()
	set_page_depth(0)
	for k := 1; k <= 6; k++ {
		page_so_far[k] = 0 // |set_page_so_far_zero|
	}
	least_page_cost = awful_bad
	if stat && tracing_pages() > 0 {
		begin_diagnostic()
		print_nl("%% goal height="); print_scaled(page_goal())
@.goal height@>
		print(", max depth="); print_scaled(page_max_depth)
		end_diagnostic(false)
	}
}

@ 쪽은 \TeX의 세로 모드에서 현재 목록에 노드를 덧붙여서 만든다. 이 세로 모드는 의미 둥지의 가장 바깥 수준에 있다. 이 세로
목록은 두 부분으로 나뉜다. 이미 많이 이야기한 ``현재 쪽''과, 새 노드가 만들어지는 대로 받아들이는 ``기여 목록''이다. 현재 쪽에는
위에서 설명했듯이 쪽 조립기가 그 자료 구조에 셈해 넣은 모든 것이 들어 있고, 기여 목록에는 \TeX의 다른 부분이 만들었지만 쪽
조립기가 아직 보지 않은 다른 것들이 들어 있다. 기여 목록은 |link(contrib_head)|에서 시작해서 \TeX의 세로 모드의 현재 노드에서
끝난다.

\TeX이 세로 모드에서 새 내용을 덧붙이면 프로시저 |build_page|를 부른다. 이 프로시저는 기여 목록의 노드를 현재 쪽으로 옮겨서
따라잡으려 한다. 이 프로시저는 쪽 나눔을 발견하지 않는 한, 곧 현재 쪽이 다음 최적 쪽 나눔이 정해질 만큼 자라지 않는 한, 기여
목록을 비운다는 목표를 이룬다. 쪽 나눔을 발견하면 최적 나눔 뒤의 노드들은 기여 목록으로 돌아가고, 제어는 사실상 사용자의 출력
루틴으로 넘어간다.

현재 쪽의 처음에 있는 글루 노드가 올바른 나눔점으로 여겨지지 않도록 |type(page_head)=glue_node|로 한다.

@<특별한 목록 머리와...@>=
set_type(page_head, glue_node); set_subtype(page_head, normal)

@ 전역 변수 |output_active|는 사용자의 출력 루틴이 \TeX을 몰고 있는 동안 참이다.

@<전역 변수@>=
var @!output_active bool // 출력 루틴 한가운데에 있는가?

@ @<핵심 변수들의...@>=
output_active = false; insert_penalties = 0

@ 다음 상태 변수들을 초기화하면 쪽 조립기는 새 쪽을 시작할 준비가 된다. (그러나 쪽 삽입 목록은 다른 곳에서 초기화한다.)

@<새 현재 쪽을 시작한다@>=
page_contents = empty; page_tail = page_head; set_link(page_head, null)
last_glue = max_halfword; last_penalty = 0; last_kern = 0
set_page_depth(0); page_max_depth = 0

@ 어떤 때에는 상자 255가 비어 있어야(곧 |null|이어야) 하거나, 삽입 상자가 세로 목록을 받아들일 준비가 되어 있어야 한다. 그렇지
않으면 오류 메시지를 찍고, 다음 서브루틴이 원하지 않는 내용을 사용자에게 알리며 없앤다.

@<함수들@>=
func box_error(n eight_bits) {
	error(); begin_diagnostic()
	print_nl("The following box has been deleted:")
@.The following...deleted@>
	show_box(box(n)); end_diagnostic(true)
	flush_node_list(box(n)); set_box_reg(n, null)
}

@ 다음 프로시저는 주어진 상자 레지스터에 \.{\\hbox}가 들어 있지 않음을 보장한다.

@<함수들@>=
func ensure_vbox(n eight_bits) {
	var p pointer // 상자 레지스터의 내용
	p = box(n)
	if p != null && type_(p) == hlist_node {
		print_err("Insertions can only be added to a vbox")
@.Insertions can only...@>
		help3("Tut tut: You're trying to \\insert into a",
			"\\box register that now contains an \\hbox.",
			"Proceed, and I'll discard its present contents.")
		box_error(n)
	}
}

@ 프로시저 |build_page|를 부를 때 \TeX이 늘 세로 모드에 있는 것은 아니다. 현재 모드는 기여 목록을 비운 뒤 \TeX이 돌아가야 할 곳을
반영한다. 그리고 |build_page| 호출 바로 뒤에는 \TeX의 중앙 제어점인 `|goto big_switch|'가 와야 한다.

보충: 원본은 레이블 |contribute|에 번호 80을 매기는 정의도 둔다.

@<함수들@>=
@<|fire_up|이라는 프로시저를 선언한다@>@;
func build_page() { // 기여 내용을 현재 쪽에 덧붙인다
	var p pointer // 덧붙이는 노드
	var q, r pointer // 살피는 노드들
	var b, c int32 // 현재 쪽의 나쁨과 비용
	var pi int32 // 나쁨에 더할 벌점
	var n int32 // 삽입 상자 번호; |min_quarterword..255|
	var delta, h, w scaled // 삽입 계산에 쓰는 크기들
	if link(contrib_head) == null || output_active {
		return
	}
	for {
	continue_:
		p = link(contrib_head)
		@<|last_glue|, |last_penalty|, |last_kern|의 값을 갱신한다@>
		@<노드 |p|를 현재 쪽으로 옮기고, 쪽 나눔 때가 되면 출력을 준비한다@>
		if link(contrib_head) == null {
			break
		}
	}
	@<꼬리를 |contrib_head|로 해서 기여 목록을 비운다@>
}

@ 보충: 원본의 매크로 |contrib_tail|은 |nest[0].tail_field|, 곧 기여 목록의 꼬리다. 대입할 수 있어야 하므로 바로 쓴다.

@<꼬리를 |contrib_head|로...@>=
if nest_ptr == 0 {
	tail = contrib_head // 세로 모드
} else {
	nest[0].tail_field = contrib_head // 다른 모드들; |contrib_tail|
}

@ @<|last_glue|, |last_penalty|, |last_kern|의...@>=
if last_glue != max_halfword {
	delete_glue_ref(last_glue)
}
last_penalty = 0; last_kern = 0
if type_(p) == glue_node {
	last_glue = glue_ptr(p); add_glue_ref(last_glue)
} else {
	last_glue = max_halfword
	if type_(p) == penalty_node {
		last_penalty = penalty(p)
	} else if type_(p) == kern_node {
		last_kern = width(p)
	}
}

@ 여기 코드는 서로 다른 곳에서 합쳐지는 루틴들로 들어가는 여러 갈래 분기의 한 보기다. 이것을 구조 없는 프로그래밍이라고 부르는
사람도 있지만, 저자는 여러 레이블의 뜻이 잘 이해되어 있는 한 별로 잘못된 점을 보지 못한다.
@^Knuth, Donald Ervin@>

노드 |p|를 현재 쪽으로 옮기고, 쪽 나눔 때가 되면 나눔 뒤의 노드들을 기여 목록으로 되돌리고 사용자의 출력 루틴이 있으면 그리로
|return|한다.

@<노드 |p|를 현재 쪽으로 옮기고...@>=
@<현재 쪽이 비었고 |p|를 지워야 하면 |goto done1|; 아니면 쪽 상태를 갱신한다@>
@<새 챔피언 나눔점이면 기록하고, 때가 되면 쪽을 내보낸다@>
if type_(p) < glue_node || type_(p) > kern_node {
	goto contribute
}
update_heights:
	@<현재 쪽 측정값을 노드~|p|의 글루나 커닝으로 갱신한다@>
contribute:
	@<|page_max_depth|를 넘지 않게 한다@>
	@<노드 |p|를 현재 쪽에 잇고 |goto done|@>
done1:
	@<노드 |p|를 재활용한다@>
done:

@ @<노드 |p|를 현재 쪽에...@>=
set_link(page_tail, p); page_tail = p
set_link(contrib_head, link(p)); set_link(p, null); goto done

@ @<노드 |p|를 재활용한다@>=
set_link(contrib_head, link(p)); set_link(p, null); flush_node_list(p)

@ 이 절의 제목은 이미 너무 길어서, 더 정확하게 하느라 더 길게 만들지 않는 편이 좋아 보인다. 그래서 기여 목록 끝의 커닝 노드는
그 다음 노드를 알 때까지 기여되지 않는다는 사실은 제목에 넣지 않았다.

노드 |p|를 써서 현재 쪽의 상태를 갱신한다. 이 노드가 삽입물이면 |goto contribute|하고, 합법적인 나눔점이 아니면 |goto contribute|나
|goto update_heights|하고, 그렇지 않으면 |pi|를 이 나눔점에 딸린 벌점으로 정한다.

@<현재 쪽이 비었고...@>=
switch type_(p) {
case hlist_node, vlist_node, rule_node:
	if page_contents < box_there {
		@<현재 쪽을 초기화하고, |p| 앞에 \.{\\topskip} 글루를 넣고, |goto continue_|@>
	} else {
		@<상자나 괘선 노드를 현재 쪽으로 옮길 준비를 하고 |goto contribute|@>
	}
case whatsit_node: @<whatsit |p|를 현재 쪽으로 옮길 준비를 하고 |goto contribute|@>
case glue_node:
	if page_contents < box_there {
		goto done1
	} else if precedes_break(page_tail) {
		pi = 0
	} else {
		goto update_heights
	}
case kern_node:
	if page_contents < box_there {
		goto done1
	} else if link(p) == null {
		return
	} else if type_(link(p)) == glue_node {
		pi = 0
	} else {
		goto update_heights
	}
case penalty_node:
	if page_contents < box_there { goto done1 } else { pi = penalty(p) }
case mark_node: goto contribute
case ins_node: @<현재 쪽에 삽입물을 덧붙이고 |goto contribute|@>
default: confusion("page")
@:this can't happen page}{\quad page@>
}

@ @<현재 쪽을 초기화하고...@>=
if page_contents == empty {
	freeze_page_specs(box_there)
} else {
	page_contents = box_there
}
q = new_skip_param(top_skip_code) // 이제 |temp_ptr=glue_ptr(q)|
if width(temp_ptr) > height(p) {
	set_width(temp_ptr, width(temp_ptr)-height(p))
} else {
	set_width(temp_ptr, 0)
}
set_link(q, p); set_link(contrib_head, q); goto continue_

@ @<상자나 괘선 노드를 현재 쪽으로...@>=
set_page_total(page_total() + page_depth() + height(p))
set_page_depth(depth(p))
goto contribute

@ @<|page_max_depth|를 넘지...@>=
if page_depth() > page_max_depth {
	set_page_total(page_total() + page_depth() - page_max_depth)
	set_page_depth(page_max_depth)
}

@ @<현재 쪽 측정값을 노드~|p|의...@>=
if type_(p) == kern_node {
	q = p
} else {
	q = glue_ptr(p)
	page_so_far[2+stretch_order(q)] = page_so_far[2+stretch_order(q)] + stretch(q)
	set_page_shrink(page_shrink() + shrink(q))
	if shrink_order(q) != normal && shrink(q) != 0 {
		print_err("Infinite glue shrinkage found on current page")
@.Infinite glue shrinkage...@>
		help4("The page about to be output contains some infinitely",
			"shrinkable glue, e.g., `\\vss' or `\\vskip 0pt minus 1fil'.",
			"Such glue doesn't belong there; but you can safely proceed,",
			"since the offensive shrinkability has been made finite.")
		error()
		r = new_spec(q); set_shrink_order(r, normal); delete_glue_ref(q)
		set_glue_ptr(p, r); q = r
	}
}
set_page_total(page_total() + page_depth() + width(q)); set_page_depth(0)

@ 쪽 나눔 때가 되면 출력을 준비하고, 사용자의 출력 루틴을 작동시키고 |return|하거나, 쪽을 내보내고 |goto done|한다.

@<새 챔피언 나눔점이면...@>=
if pi < inf_penalty {
	@<현재 쪽의 나쁨 |b|를 계산한다@>
	if b < awful_bad {
		if pi <= eject_penalty {
			c = pi
		} else if b < inf_bad {
			c = b + pi + insert_penalties
		} else {
			c = deplorable
		}
	} else {
		c = b
	}
	if insert_penalties >= 10000 {
		c = awful_bad
	}
	if stat && tracing_pages() > 0 {
		@<쪽 나눔 비용을 보인다@>
	}
	if c <= least_page_cost {
		@<지금 나눔을 가장 좋은 쪽 나눔으로 기록한다@>
	}
	if c == awful_bad || pi <= eject_penalty {
		fire_up(p) // 현재 쪽을 가장 좋은 곳에서 출력한다
		if output_active {
			return // 사용자의 출력 루틴이 작동할 것이다
		}
		goto done // 쪽은 기본 출력 루틴으로 내보내졌다
	}
}

@ \dg 앞 절에서 새 챔피언을 기록한다.

@<지금 나눔을 가장 좋은 쪽 나눔으로...@>=
best_page_break = p; best_size = page_goal()
least_page_cost = c
r = link(page_ins_head)
for r != page_ins_head {
	set_best_ins_ptr(r, last_ins_ptr(r))
	r = link(r)
}

@ @<쪽 나눔 비용을...@>=
begin_diagnostic(); print_nl("%")
print(" t="); print_totals()
print(" g="); print_scaled(page_goal())
print(" b=")
if b == awful_bad { print_char('*') } else { print_int(b) }
@.*\relax@>
print(" p="); print_int(pi)
print(" c=")
if c == awful_bad { print_char('*') } else { print_int(c) }
if c <= least_page_cost {
	print_char('#')
}
end_diagnostic(false)

@ 상자가 너무 차면 |awful_bad|를 쓴다.

@<현재 쪽의 나쁨 |b|를...@>=
if page_total() < page_goal() {
	if page_so_far[3] != 0 || page_so_far[4] != 0 || page_so_far[5] != 0 {
		b = 0
	} else {
		b = badness(page_goal()-page_total(), page_so_far[2])
	}
} else if page_total()-page_goal() > page_shrink() {
	b = awful_bad
} else {
	b = badness(page_total()-page_goal(), page_shrink())
}

@ @<현재 쪽에 삽입물을 덧붙이고...@>=
if page_contents == empty {
	freeze_page_specs(inserts_only)
}
n = subtype(p); r = page_ins_head
for n >= subtype(link(r)) {
	r = link(r)
}
n = qo(n)
if subtype(r) != qi(n) {
	@<|subtype(r)=qi(n)|인 쪽 삽입 노드를 만들고 상자 |n|의 글루 보정을 넣는다@>
}
if type_(r) == split_up {
	insert_penalties = insert_penalties + float_cost(p)
} else {
	set_last_ins_ptr(r, p)
	delta = page_goal() - page_total() - page_depth() + page_shrink()
	// 최대로 줄이면 이만큼 공간이 남는다
	if count(n) == 1000 {
		h = height(p)
	} else {
		h = x_over_n(height(p), 1000) * count(n) // 이만큼 공간이 필요하다
	}
	if (h <= 0 || h <= delta) && height(p)+height(r) <= dimen(n) {
		set_page_goal(page_goal() - h); set_height(r, height(r)+height(p))
	} else {
		@<삽입물을 나누는 가장 좋은 방법을 찾고 |type(r)|를 |split_up|으로 바꾼다@>
	}
}
goto contribute

@ 레지스터 \.{\\skip}~|n|의 값과 \.{\\box}~|n|의 높이와 깊이의 합은 새 쪽에서 첫 \.{\\insert}~|n| 노드를 만났을 때에만 기록해 둔다. 그
첫 \.{\\insert}~|n| 뒤에 \.{\\box}~|n|의 내용을 바꾸는 사용자는 아주 조심스럽거나 아주 운이 좋거나, 아니면 둘 다여야 한다.

@<|subtype(r)=qi(n)|인 쪽 삽입 노드를...@>=
q = get_node(page_ins_node_size); set_link(q, link(r)); set_link(r, q); r = q
set_subtype(r, qi(n)); set_type(r, inserting); ensure_vbox(n)
if box(n) == null {
	set_height(r, 0)
} else {
	set_height(r, height(box(n))+depth(box(n)))
}
set_best_ins_ptr(r, null)
q = skip(n)
if count(n) == 1000 {
	h = height(r)
} else {
	h = x_over_n(height(r), 1000) * count(n)
}
set_page_goal(page_goal() - h - width(q))
page_so_far[2+stretch_order(q)] = page_so_far[2+stretch_order(q)] + stretch(q)
set_page_shrink(page_shrink() + shrink(q))
if shrink_order(q) != normal && shrink(q) != 0 {
	print_err("Infinite glue shrinkage inserted from "); print_esc("skip")
@.Infinite glue shrinkage...@>
	print_int(n)
	help3("The correction glue for page breaking with insertions",
		"must have finite shrinkability. But you may proceed,",
		"since the offensive shrinkability has been made finite.")
	error()
}

@ 다음은 비상시에 긴 각주를 여러 쪽에 걸쳐 나누는 코드다. 지금 상황을 다시 간추려 볼 만하다. 노드 |p|는 상자 |n|에 대한
삽입물이다. 이 삽입물은 통째로는 들어맞지 않는다. 상자 |n|의 전체 내용을 \.{\\dimen} |n|보다 크게 만들거나, 늘어나는 양 |h|를
쓸 수 있는 공간 |delta|보다 크게 만들거나, 둘 다이기 때문이다. (이 양 |h|에는 삽입 배율, 곧 \.{\\count} |n|을 1000으로 나눈 것이
곱해져 있다.) 이제 \.{\\vsplit} 연산에서와 같은 기준으로 삽입물의 세로 목록을 나누는 가장 좋은 방법을 고른다.

@<삽입물을 나누는 가장 좋은 방법을...@>=
if count(n) <= 0 {
	w = max_dimen
} else {
	w = page_goal() - page_total() - page_depth()
	if count(n) != 1000 {
		w = x_over_n(w, count(n)) * 1000
	}
}
if w > dimen(n)-height(r) {
	w = dimen(n) - height(r)
}
q = vert_break(ins_ptr(p), w, depth(p))
set_height(r, height(r)+best_height_plus_depth)
if stat && tracing_pages() > 0 {
	@<삽입물 나누기 비용을 보인다@>
}
if count(n) != 1000 {
	best_height_plus_depth = x_over_n(best_height_plus_depth, 1000) * count(n)
}
set_page_goal(page_goal() - best_height_plus_depth)
set_type(r, split_up); set_broken_ptr(r, q); set_broken_ins(r, p)
if q == null {
	insert_penalties = insert_penalties + eject_penalty
} else if type_(q) == penalty_node {
	insert_penalties = insert_penalties + penalty(q)
}

@ @<삽입물 나누기 비용을...@>=
begin_diagnostic(); print_nl("% split"); print_int(n)
@.split@>
print(" to "); print_scaled(w)
print_char(','); print_scaled(best_height_plus_depth)
print(" p=")
if q == null {
	print_int(eject_penalty)
} else if type_(q) == penalty_node {
	print_int(penalty(q))
} else {
	print_char('0')
}
end_diagnostic(false)

@ 다음 쪽 나눔 앞에 나타날 수 있는 만큼의 내용을 다 보고 나면, 쪽 조립기는 결정을 내린다. 나쁨이 가장 작은 나눔을 써서 완성된
``쪽''을 상자 255에 넣고, 삽입물들은 저마다 다른 상자에 덧붙인다.

표시 |top_mark|, |first_mark|, |bot_mark|의 값도 정한다. 프로그램은 |bot_mark!=null|이면 |first_mark!=null|이라는 사실을 이용하고,
|bot_mark=null|이면 |top_mark=first_mark=null|이라는 것도 안다.

서브루틴 |fire_up|은 현재 쪽을 가장 좋은 곳에서 출력할 준비를 한 다음, 사용자의 출력 루틴이 있으면 그것을 작동시키고, 없으면
그냥 쪽을 내보낸다. 매개변수가 하나 있는데, |c|는 출력을 강제하기로 결정했을 때 쪽에 들어오고 있던 노드를 나타낸다.

@<|fire_up|이라는...@>=
func fire_up(c pointer) {
	var p, q, r, s pointer // 살피거나 바꾸는 노드들
	var prev_p pointer // |p|의 앞 노드
	var n int32 // 삽입 상자 번호; |min_quarterword..255|
	var wait bool // 지금 삽입물을 다음으로 미루어야 하는가?
	var save_vbadness int32 // |vbadness|의 저장된 값
	var save_vfuzz scaled // |vfuzz|의 저장된 값
	var save_split_top_skip pointer // |split_top_skip|의 저장된 값
	@<|output_penalty|의 값을 정한다@>
	if bot_mark() != null {
		if top_mark() != null {
			delete_token_ref(top_mark())
		}
		set_top_mark(bot_mark()); add_token_ref(top_mark())
		delete_token_ref(first_mark()); set_first_mark(null)
	}
	@<최적의 현재 쪽을 상자 255에 넣고, 삽입물을 덧붙이고, 나머지를 기여 목록에 되돌린다@>
	if top_mark() != null && first_mark() == null {
		set_first_mark(top_mark()); add_token_ref(top_mark())
	}
	if output_routine() != null {
		if dead_cycles >= max_dead_cycles() {
			@<죽은 순환이 너무 많이 이어졌다고 설명한다@>
		} else {
			@<사용자의 출력 루틴을 작동시키고 |return|한다@>
		}
	}
	@<기본 출력 루틴을 수행한다@>
}

@ @<|output_penalty|의 값을...@>=
if type_(best_page_break) == penalty_node {
	geq_word_define(int_base+output_penalty_code, penalty(best_page_break))
	set_penalty(best_page_break, inf_penalty)
} else {
	geq_word_define(int_base+output_penalty_code, inf_penalty)
}

@ 쪽을 마침내 출력할 준비를 하는 동안 포인터 |p|는 세로 목록을 훑고, |prev_p|가 그 뒤를 따른다. 포인터 |q|는 다음 쪽으로 미루는
삽입물 목록의 꼬리다.

이 코드는 |first_mark|와 |bot_mark|도 갱신한다.

@<최적의 현재 쪽을 상자 255에...@>=
if c == best_page_break {
	best_page_break = null // |c|는 아직 이어지지 않았다
}
@<출력 전에 상자 255가 비었는지 확인한다@>
insert_penalties = 0 // 이것은 미룬 삽입물의 수를 셀 것이다
save_split_top_skip = split_top_skip()
if holding_inserts() <= 0 {
	@<삽입물에 관련된 모든 상자를 큐처럼 쓰도록 준비한다@>
}
q = hold_head; set_link(q, null); prev_p = page_head; p = link(prev_p)
for p != best_page_break {
	if type_(p) == ins_node {
		if holding_inserts() <= 0 {
			@<노드 |p|가 지정한 내용을 상자에 넣거나 다음 쪽으로 미룬다@>
		}
	} else if type_(p) == mark_node {
		@<|first_mark|와 |bot_mark|의 값을 갱신한다@>
	}
	prev_p = p; p = link(prev_p)
}
set_split_top_skip(save_split_top_skip)
@<현재 쪽을 노드 |p|에서 나누어 상자~255에 넣고 나머지를 기여 목록에 둔다@>
@<쪽 삽입 노드들을 지운다@>

@ @<출력 전에 상자 255가...@>=
if box(255) != null {
	print_err(""); print_esc("box"); print("255 is not void")
@:box255}{\.{\\box255 is not void}@>
	help2("You shouldn't use \\box255 except in \\output routines.",
		"Proceed, and I'll discard its present contents.")
	box_error(255)
}

@ @<|first_mark|와 |bot_mark|의...@>=
if first_mark() == null {
	set_first_mark(mark_ptr(p))
	add_token_ref(first_mark())
}
if bot_mark() != null {
	delete_token_ref(bot_mark())
}
set_bot_mark(mark_ptr(p)); add_token_ref(bot_mark())

@ 다음 코드가 실행될 때 현재 쪽은 노드 |link(page_head)|부터 노드 |prev_p|까지이고, |p|부터 |page_tail|까지의 노드들은 기여 목록의
앞에 다시 놓아야 한다. 게다가 미룬 삽입물들은 |link(hold_head)|부터 |q|까지의 목록에 있다. 사용자의 출력 루틴이 작동하는 동안
안전하게 보관하려고 이것들을 현재 쪽 목록에 넣는다. 여기서 |q=hold_head|일 수도 있다. 그리고 |prev_p=page_tail|일 때, 그리고
오직 그때에만 |p=null|이다. 프로시저 |vpackage| 안에서는 오류 메시지를 억누른다. 삽입물을 위한 \.{\\skip} 레지스터의 늘어남과 줄어듦이
실제로는 상자에 없으므로, 상자가 그저 그 때문에 넘치거나 덜 찬 것처럼 보일 수도 있기 때문이다.

보충: 원본의 |contrib_tail|은 |nest[0].tail_field|다.

@<현재 쪽을 노드 |p|에서 나누어...@>=
if p != null {
	if link(contrib_head) == null {
		if nest_ptr == 0 {
			tail = page_tail
		} else {
			nest[0].tail_field = page_tail
		}
	}
	set_link(page_tail, link(contrib_head))
	set_link(contrib_head, p)
	set_link(prev_p, null)
}
save_vbadness = vbadness(); set_vbadness(inf_bad)
save_vfuzz = vfuzz(); set_vfuzz(max_dimen) // 오류 메시지를 억누른다
set_box_reg(255, vpackage(link(page_head), best_size, exactly, page_max_depth))
set_vbadness(save_vbadness); set_vfuzz(save_vfuzz)
if last_glue != max_halfword {
	delete_glue_ref(last_glue)
}
@<새 현재 쪽을 시작한다@> // 이것은 |last_glue:=max_halfword|로 한다
if q != hold_head {
	set_link(page_head, link(hold_head)); page_tail = q
}

@ 많은 삽입물이 같은 상자에 들어가야 한다면, 그 상자의 마지막 노드의 위치를 알고 싶다. 그래야 정보를 더 이어 붙일 때 시간을
낭비하지 않는다. 그래서 묶는 단계 동안 쪽 삽입 노드의 |last_ins_ptr| 필드를 이 목적에 쓴다.

@<삽입물에 관련된 모든 상자를...@>=
r = link(page_ins_head)
for r != page_ins_head {
	if best_ins_ptr(r) != null {
		n = qo(subtype(r)); ensure_vbox(n)
		if box(n) == null {
			set_box_reg(n, new_null_box())
		}
		p = box(n) + list_offset
		for link(p) != null {
			p = link(p)
		}
		set_last_ins_ptr(r, p)
	}
	r = link(r)
}

@ @<쪽 삽입 노드들을...@>=
r = link(page_ins_head)
for r != page_ins_head {
	q = link(r); free_node(r, page_ins_node_size); r = q
}
set_link(page_ins_head, page_ins_head)

@ 삽입 노드~|r|에 대응하는 상자는 그 상자에 마지막 삽입을 한 바로 뒤에 |best_ins_ptr:=null|로 하고 묶는다. 이 마지막 삽입이
`|split_up|'이면, 나누고 쳐낸 뒤의 나머지(있으면)는 다음 쪽으로 넘어간다.

노드 |p|가 지정한 내용을 알맞은 상자에 넣거나 다음 쪽으로 미루고, 노드 |p|를 현재 쪽에서 지운다.

@<노드 |p|가 지정한 내용을...@>=
r = link(page_ins_head)
for subtype(r) != subtype(p) {
	r = link(r)
}
if best_ins_ptr(r) == null {
	wait = true
} else {
	wait = false; s = last_ins_ptr(r); set_link(s, ins_ptr(p))
	if best_ins_ptr(r) == p {
		@<노드 |r|이 지정한 상자를 마무리한다@>
	} else {
		for link(s) != null {
			s = link(s)
		}
		set_last_ins_ptr(r, s)
	}
}
@<삽입 노드 |p|를 노드 |q| 뒤에 덧붙이거나 지운다@>

@ 필요하면 노드 |p|를 나누고, 나눈 뒤 노드 |p|에 나머지가 남으면 |wait:=true|로 한다.

@<노드 |r|이 지정한 상자를...@>=
if type_(r) == split_up && broken_ins(r) == p && broken_ptr(r) != null {
	for link(s) != broken_ptr(r) {
		s = link(s)
	}
	set_link(s, null)
	set_split_top_skip(split_top_ptr(p))
	set_ins_ptr(p, prune_page_top(broken_ptr(r)))
	if ins_ptr(p) != null {
		temp_ptr = vpack(ins_ptr(p), natural, additional)
		set_height(p, height(temp_ptr)+depth(temp_ptr))
		free_node(temp_ptr, box_node_size); wait = true
	}
}
set_best_ins_ptr(r, null)
n = qo(subtype(r))
temp_ptr = list_ptr(box(n))
free_node(box(n), box_node_size)
set_box_reg(n, vpack(temp_ptr, natural, additional))

@ 삽입 노드 |p|를 노드 |q| 뒤에 덧붙이고 현재 쪽에서 없애거나, 노드 |p|를 지운다.

@<삽입 노드 |p|를 노드 |q| 뒤에...@>=
set_link(prev_p, link(p)); set_link(p, null)
if wait {
	set_link(q, p); q = p; insert_penalties++
} else {
	delete_glue_ref(split_top_ptr(p))
	free_node(p, ins_node_size)
}
p = prev_p

@ 사용자가 출력 루틴을 지정하지 않았으면, |link(page_head)|부터 |page_tail|까지의 미룬 삽입물 목록을 기여 목록으로 옮겨야 한다.

@<기본 출력 루틴을...@>=
if link(page_head) != null {
	if link(contrib_head) == null {
		if nest_ptr == 0 {
			tail = page_tail
		} else {
			nest[0].tail_field = page_tail // |contrib_tail|
		}
	} else {
		set_link(page_tail, link(contrib_head))
	}
	set_link(contrib_head, link(page_head))
	set_link(page_head, null); page_tail = page_head
}
ship_out(box(255)); set_box_reg(255, null)

@ @<죽은 순환이 너무 많이...@>=
print_err("Output loop---"); print_int(dead_cycles)
@.Output loop...@>
print(" consecutive dead cycles")
help3("I've concluded that your \\output is awry; it never does a",
	"\\shipout, so I'm shipping \\box255 out myself. Next time",
	"increase \\maxdeadcycles if you want me to be more patient!")
error()

@ @<사용자의 출력 루틴을 작동시키고...@>=
output_active = true
dead_cycles++
push_nest(); mode = -vmode; set_prev_depth(ignore_depth); mode_line = -line
begin_token_list(output_routine(), output_text)
new_save_level(output_group); normal_paragraph()
scan_left_brace()
return

@ 사용자의 출력 루틴이 끝나면 내부 세로 모드에서 세로 목록을 만들어 놓았을 것이고, \TeX은 다음 일을 한다.

@<출력 루틴이 끝난 뒤 쪽 조립기를 다시 시작한다@>=
if loc != null || (token_type() != output_text && token_type() != backed_up) {
	@<균형이 맞지 않는 출력 루틴에서 회복한다@>
}
end_token_list() // 출력이 더 일어날 때를 대비해 스택 공간을 아낀다
end_graf(); unsave(); output_active = false; insert_penalties = 0
@<출력 뒤에 상자 255가 비었는지 확인한다@>
if tail != head { // 현재 목록은 미룬 삽입물 뒤에 간다
	set_link(page_tail, link(head))
	page_tail = tail
}
if link(page_head) != null { // 그리고 둘 다 미룬 기여 내용 앞에 간다
	if link(contrib_head) == null {
		nest[0].tail_field = page_tail // |contrib_tail|
	}
	set_link(page_tail, link(contrib_head))
	set_link(contrib_head, link(page_head))
	set_link(page_head, null); page_tail = page_head
}
pop_nest(); build_page()

@ @<균형이 맞지 않는 출력 루틴에서...@>=
print_err("Unbalanced output routine")
@.Unbalanced output routine@>
help2("Your sneaky output routine has problematic {'s and/or }'s.",
	"I can't handle that very well; good luck.")
error()
for {
	get_token()
	if loc == null {
		break
	}
} // 파일에서 읽고 있으면 끝없이 돈다. |null=min_halfword<=0|이기 때문이다

@ @<출력 뒤에 상자 255가...@>=
if box(255) != null {
	print_err("Output routine didn't use all of ")
	print_esc("box"); print_int(255)
@.Output routine didn't use...@>
	help3("Your \\output commands should empty \\box255,",
		"e.g., by saying `\\shipout\\box255'.",
		"Proceed; I'll discard its present contents.")
	box_error(255)
}

@* 최고 집행부.
이제 |main_control| 루틴에 이르렀다. 이 루틴에는 \TeX의 온갖 부분이 저마다 제 일을 올바른 차례로 하게 하는 주 스위치가 들어
있다.

어떤 뜻에서 이것은 프로그램의 웅장한 절정이다. 우리가 그토록 애써 만든 모든 도구를 여기서 쓴다. 다른 뜻에서 이것은 프로그램에서
가장 어수선한 부분이다. 여기저기 흩어진 다른 코드 조각들을 가리킬 수밖에 없어서, 다른 곳에서 정의한 관례를 떠올리려고 앞뒤로
쪽을 넘겨 보지 않고는 무슨 일이 일어나는지 온전히 이해할 수 없다. 우리는 이제 거미줄(web)의 중심, 곧 다른 부분 대부분과 닿아서
그것들을 하나로 묶는 중추 신경계에 와 있다.
@^brain@>

루틴 |main_control| 자체의 구조는 꽤 단순하다. 그 안에 |big_switch|라는 레이블이 있고, 그 지점에서 |get_x_token|으로 입력의 다음 토큰을
가져온다. 그런 다음 프로그램은 현재 모드와 새로 가져온 명령 코드의 값에 따라 약 100가지 가능한 방향 가운데 하나로 빠르게
갈라진다. 합 |abs(mode)+cur_cmd|가 다음에 무엇을 할지 알려 준다. 이를테면 `|vmode+letter|' 경우는 세로 모드(또는 내부 세로
모드)에서 글자가 나타날 때 생긴다. 이 경우는 새 문단을 초기화하고 가로 모드로 들어가는 명령으로 이어진다.

이 여러 갈래 스위치를 담은 큰 |case| 문에는 |reswitch|라는 레이블이 붙어 있어서, 다음 토큰을 이미 가져왔을 때는 |goto reswitch|할
수 있다. 경우 대부분은 꽤 짧다. 그 경우의 일을 하는 ``동작 프로시저''를 부른 다음, |goto reswitch|하거나 |case| 문의 끝으로
``흘러 내려가서'' |big_switch|로 제어를 돌려준다. 그래서 |main_control|은 해야 할 일이 그토록 많은데도 아주 큰 프로시저가 아니다.
프로시저 크기를 심하게 제한하는 \PASCAL\ 컴파일러도 다룰 수 있을 만큼 작다.
@!@^action procedure@>

한 경우는 특별히 다룬다. 전형적인 응용에서 \TeX이 하는 활동의 대부분을 차지하기 때문이다. 단순한 텍스트를 읽어서 합자와 커닝을
찾으며 |char_node| 레코드로 바꾸는 과정은 \TeX의 ``안쪽 루프''의 일부다. 안쪽 루프가 빠르면 프로그램 전체가 효율적으로 돌아가므로,
이 부분은 특별히 공들여 썼다.

@ 먼저 |main_control|의 안쪽 루프에 집중하고, 다른 경우들은 나중에 생각하자.
@^inner loop@>

보충: 원본은 레이블 |big_switch|, |main_loop|, |main_loop_wrapup|, |main_loop_move|, |main_loop_move_lig|, |main_loop_lookahead|,
|main_lig_loop|, |append_normal_space|에 번호 60--120을 매긴다. 원본은 이를테면 |main_loop_move+1| 같은 레이블도 쓰는데, \GO/의
레이블은 이름이므로 이 번역에서는 |main_loop_move_1|처럼 쓴다.

@<함수들@>=
@<|main_control|이 쓰는 동작 프로시저들@>@;
@<|handle_right_brace|라는 프로시저를 선언한다@>@;
func main_control() { // \TeX의 활동을 다스린다
	var t int32 // 만능 임시 변수
	if every_job() != null {
		begin_token_list(every_job(), every_job_text)
	}
big_switch:
	get_x_token()
reswitch:
	@<요청이 있으면 진단 정보를 준다@>
	switch abs(mode) + cur_cmd {
	case hmode + letter, hmode + other_char, hmode + char_given: goto main_loop
	case hmode + char_num: scan_char_num(); cur_chr = cur_val; goto main_loop
	case hmode + no_boundary:
		get_x_token()
		if cur_cmd == letter || cur_cmd == other_char || cur_cmd == char_given || cur_cmd == char_num {
			cancel_boundary = true
		}
		goto reswitch
	case hmode + spacer:
		if space_factor() == 1000 { goto append_normal_space } else { app_space() }
	case hmode + ex_space, mmode + ex_space: goto append_normal_space
	@<안쪽 루프에 속하지 않는 |main_control|의 경우들@>
	} // 큰 |case| 문의 끝
	goto big_switch
main_loop:
	@<문자 |cur_chr|와 뒤따르는 문자들을 현재 가로 목록에 덧붙인다@>
append_normal_space:
	@<현재 목록에 보통 낱말 사이 공백을 덧붙이고 |goto big_switch|@>
}

@ 레이블 |big_switch|에서 새 토큰을 막 가져왔을 때가 \TeX의 활동을 감시하기에 이상적인 곳이다.
@^debugging@>

@<요청이 있으면 진단 정보를...@>=
if interrupt != 0 && OK_to_interrupt {
	back_input(); check_interrupt(); goto big_switch
}
if debug && panicking {
	check_mem(false)
}
if tracing_commands() > 0 {
	show_cur_cmd_chr()
}

@ 프로그램의 다음 부분은 처음에는 ``섣부른 최적화는 모든 악의 뿌리다''라는 철학에 따라 구조적으로 썼다. 그런 다음 가장 흔한
동작들이 중복을 거의 또는 전혀 거치지 않고 진행되도록 스파게티 조각들로 다시 배치했다.

이 알고리즘의 최적화하지 않은 원래 모양은 앞에서 하이픈 넣기와 관련해 설명한 |reconstitute| 프로시저와 닮았다. 여기서도 문자
|cur_l|과 |cur_r| 사이에 암묵적인 ``커서''가 있다. 주된 차이는 이제 |lig_stack|에 가짜 합자뿐 아니라 문자 노드도 들어 있을 수
있다는 것이다. 이 스택은 이제 대개 비어 있지 않다. 입력의 다음 문자(있으면)가 거기 덧붙어 있기 때문이다. 루틴 |main_control|에서는
|character(lig_stack)=font_false_bchar[cur_font]|일 때를 빼면, |lig_stack>null|이면 |cur_r=character(lig_stack)|이고 그렇지
않으면 |cur_r=font_bchar[cur_font]|이다. 전역 변수가 몇 개 더 필요하다.

@<전역 변수@>=
var @!main_f internal_font_number // 현재 글꼴
var @!main_i four_quarters // |cur_l|의 문자 정보 바이트
var @!main_j four_quarters // 합자/커닝 명령
var @!main_k font_index // |font_info|의 첨자
var @!main_p pointer // 목록을 다루는 임시 레지스터
var @!main_s int32 // 공백 인자 값
var @!bchar halfword // 현재 글꼴의 경계 문자, 또는 |non_char|
var @!false_bchar halfword // |bchar|와 맞는 없는 문자, 또는 |non_char|
var @!cancel_boundary bool // 왼쪽 경계를 무시해야 하는가?
var @!ins_disc bool // 선택적 나눔 노드를 넣어야 하는가?

@ 주 루프의 불 변수들은 보통 거짓이고, 루프를 떠나기 전에 늘 거짓으로 되돌린다. 그래서 매번 초기화하는 수고를 던다.

@<핵심 변수들의...@>=
ligature_present = false; cancel_boundary = false; lft_hit = false; rt_hit = false
ins_disc = false

@ 코드가 |sf_code(cur_chr)=0|이면 |space_factor|를 바꾸지 않는다. 그렇지 않으면 |sf_code(cur_chr)|와 같게 하는데, 다만 1000보다 작은
값에서 1000을 넘는 값으로는 결코 바뀌지 않아야 한다. 가장 흔한 경우는 |sf_code(cur_chr)=1000|이므로 이 경우가 빠르기를 바란다.

주 루프의 전체 구조를 여기 보인다. 몇몇 프로그램 레이블은 각 절 안에 있다.
@^inner loop@>

보충: 원본의 매크로 |adjust_space_factor|는 두 곳에서 쓰이고 전역 변수만 쓰므로 함수로 옮긴다.

@<문자 |cur_chr|와 뒤따르는...@>=
adjust_space_factor()
main_f = cur_font()
bchar = font_bchar[main_f]; false_bchar = font_false_bchar[main_f]
if mode > 0 && language() != clang() {
	fix_language()
}
lig_stack = fast_get_avail(); set_font_field(lig_stack, main_f); cur_l = qi(cur_chr)
set_character(lig_stack, cur_l)
cur_q = tail
if cancel_boundary {
	cancel_boundary = false; main_k = non_address
} else {
	main_k = bchar_label[main_f]
}
if main_k == non_address {
	goto main_loop_move_2 // 왼쪽 경계 처리를 하지 않는다
}
cur_r = cur_l; cur_l = non_char
goto main_lig_loop_1 // 커서가 왼쪽 경계 뒤에 있는 채로 시작한다
@#
main_loop_wrapup:
	@<|ligature_present|이면 합자 노드를 만들고, 알맞으면 널 선택적 나눔을 넣는다@>
main_loop_move:
	@<커서를 한 걸음 오른쪽으로 옮긴다@>
main_loop_lookahead:
	@<다른 문자를 내다보거나, 없으면 |lig_stack|을 비워 둔다@>
main_lig_loop:
	@<|cur_l|과 |cur_r|에 관련된 합자/커닝 명령이 있으면 텍스트를 고친다@>
main_loop_move_lig:
	@<가짜 합자를 지나 커서를 옮기고 |goto main_loop_lookahead|나 |main_lig_loop|@>

@ \dg 앞 절의 정의부에서 매크로 |adjust_space_factor|를 옮긴다.

@<함수들@>=
func adjust_space_factor() {
	main_s = sf_code(cur_chr)
	if main_s == 1000 {
		set_space_factor(1000)
	} else if main_s < 1000 {
		if main_s > 0 {
			set_space_factor(main_s)
		}
	} else if space_factor() < 1000 {
		set_space_factor(1000)
	} else {
		set_space_factor(main_s)
	}
}

@ 함수 |wrapup|을 부를 때 |link(cur_q)|가 널이 아니면, |cur_q|는 합자 문자~|cur_l|을 만드는 동안 소비한 문자들의 목록을 가리킨다.

제한된 가로 모드에 있을 때는 명시적 하이픈에 선택적 나눔을 넣지 않는다. 특히 이렇게 하면 선택적 나눔 노드를 다른 선택적 나눔 안에
넣는 일을 피한다.
@^inner loop@>

보충: 원본의 매크로 |pack_lig(#)|과 |wrapup(#)|은 전역 변수만 쓰고, |wrapup|은 세 곳에서 쓰이므로 함수로 옮긴다. 매개변수는
|rt_hit|이거나 |false|다.

@<함수들@>=
func pack_lig(z bool) { // 매개변수는 |rt_hit|이거나 |false|다
	main_p = new_ligature(main_f, cur_l, link(cur_q))
	if lft_hit {
		set_subtype(main_p, 2); lft_hit = false
	}
	if z && lig_stack == null {
		set_subtype(main_p, subtype(main_p)+1); rt_hit = false
	}
	set_link(cur_q, main_p); tail = main_p; ligature_present = false
}

func wrapup(z bool) {
	if cur_l < non_char {
		if link(cur_q) > null && character(tail) == qi(hyphen_char[main_f]) {
			ins_disc = true
		}
		if ligature_present {
			pack_lig(z)
		}
		if ins_disc {
			ins_disc = false
			if mode > 0 {
				tail_append(new_disc())
			}
		}
	}
}

@ \dg 앞 절의 코드부를 옮긴다.

@<|ligature_present|이면 합자 노드를...@>=
wrapup(rt_hit)

@ 커서 바로 뒤에 오른쪽 경계가 있으면 |goto reswitch|하고, 무효한 문자가 있으면 |goto big_switch|하고, 그렇지 않으면 커서를 한
걸음 오른쪽으로 옮기고 |goto main_lig_loop|한다.

@<커서를 한 걸음...@>=
@^inner loop@>
if lig_stack == null {
	goto reswitch
}
cur_q = tail; cur_l = character(lig_stack)
main_loop_move_1:
	if !is_char_node(lig_stack) {
		goto main_loop_move_lig
	}
main_loop_move_2:
	if cur_chr < font_bc[main_f] || cur_chr > font_ec[main_f] {
		char_warning(main_f, cur_chr); free_avail(lig_stack); goto big_switch
	}
	main_i = char_info(main_f, cur_l)
	if !char_exists(main_i) {
		char_warning(main_f, cur_chr); free_avail(lig_stack); goto big_switch
	}
	set_link(tail, lig_stack); tail = lig_stack // 다음은 |main_loop_lookahead|다

@ 여기는 |main_loop_move_lig|다. 이 코드를 시작할 때 |cur_q=tail|이고 |cur_l=character(lig_stack)|이다.

@<가짜 합자를 지나...@>=
main_p = lig_ptr(lig_stack)
if main_p > null {
	tail_append(main_p) // 문자 하나를 덧붙인다
}
temp_ptr = lig_stack; lig_stack = link(temp_ptr)
free_node(temp_ptr, small_node_size)
main_i = char_info(main_f, cur_l); ligature_present = true
if lig_stack == null {
	if main_p > null {
		goto main_loop_lookahead
	} else {
		cur_r = bchar
	}
} else {
	cur_r = character(lig_stack)
}
goto main_lig_loop

@ 명령 \.{\\char}의 결과도 합자나 커닝에 참여할 수 있으므로 그것도 내다보아야 한다.

@<다른 문자를 내다보거나...@>=
get_next() // 속도를 위해 |cur_cmd|와 |cur_chr|만 정한다
if cur_cmd == letter || cur_cmd == other_char || cur_cmd == char_given {
	goto main_loop_lookahead_1
}
x_token() // 이제 펼치고 |cur_cmd|, |cur_chr|, |cur_tok|를 정한다
if cur_cmd == letter || cur_cmd == other_char || cur_cmd == char_given {
	goto main_loop_lookahead_1
}
if cur_cmd == char_num {
	scan_char_num(); cur_chr = cur_val; goto main_loop_lookahead_1
}
if cur_cmd == no_boundary {
	bchar = non_char
}
cur_r = bchar; lig_stack = null; goto main_lig_loop
main_loop_lookahead_1:
	adjust_space_factor()
	lig_stack = fast_get_avail(); set_font_field(lig_stack, main_f)
	cur_r = qi(cur_chr); set_character(lig_stack, cur_r)
	if cur_r == false_bchar {
		cur_r = non_char // 이렇게 하면 엉뚱한 합자를 막는다
	}

@ 합자/커닝 프로그램이 있는 문자는 비교적 적지만, 여기 있는 명령 가운데 몇몇은 \TeX의 안쪽 루프의 일부로 친다. 잠재적으로 긴
@^inner loop@>
순차 탐색을 해야 하기 때문이다. 이를테면 Computer Modern Roman으로 시험해 보니, 실제로 만나는 모든 문자의 약 40퍼센트에
합자/커닝 프로그램이 있었고, 그런 문자마다 합자/커닝 명령을 약 네 개씩 조사했다.

이 코드의 처음에서 |main_i=char_info(main_f)(cur_l)|이다. 관련된 명령이 있으면 텍스트를 알맞게 고치고, |main_loop_wrapup|으로
빠져나간다.

@<|cur_l|과 |cur_r|에 관련된...@>=
if char_tag(main_i) != lig_tag {
	goto main_loop_wrapup
}
if cur_r == non_char {
	goto main_loop_wrapup
}
main_k = lig_kern_start(main_f, main_i); main_j = font_info[main_k].qqqq
if skip_byte(main_j) <= stop_flag {
	goto main_lig_loop_2
}
main_k = lig_kern_restart(main_f, main_j)
main_lig_loop_1:
	main_j = font_info[main_k].qqqq
main_lig_loop_2:
	if next_char(main_j) == cur_r && skip_byte(main_j) <= stop_flag {
		@<합자나 커닝 명령을 수행하고, 알맞은 곳으로 돌아간다@>
	}
	if skip_byte(main_j) == qi(0) {
		main_k++
	} else {
		if skip_byte(main_j) >= stop_flag {
			goto main_loop_wrapup
		}
		main_k = main_k + qo(skip_byte(main_j)) + 1
	}
	goto main_lig_loop_1

@ 합자나 커닝 명령이 문자와 맞으면, 그 문자가 보통 방법으로 존재를 확인하지는 않았어도 글꼴에 있다는 것을 |read_font_info|에서
안다.

루틴 |main_control| 안의 코드를 줄여야 한다면 이 절을 서브루틴으로 만들 수도 있을 것이다. 이 절은 |main_lig_loop|나
|main_loop_wrapup|이나 |main_loop_move|로 돌아간다.

\chardef\?='174 % 문자를 남김을 나타내는 세로 막대

@<합자나 커닝 명령을 수행하고...@>=
if op_byte(main_j) >= kern_flag {
	wrapup(rt_hit)
	tail_append(new_kern(char_kern(main_f, main_j))); goto main_loop_move
}
if cur_l == non_char {
	lft_hit = true
} else if lig_stack == null {
	rt_hit = true
}
check_interrupt() // 끝없는 합자 루프가 있을 때 빠져나갈 길을 둔다
switch op_byte(main_j) {
case qi(1), qi(5): // \.{=:\?}, \.{=:\?>}
	cur_l = rem_byte(main_j)
	main_i = char_info(main_f, cur_l); ligature_present = true
case qi(2), qi(6): @<|cur_r|을 바꾸고 |lig_stack|을 고친다@> // \.{\?=:}, \.{\?=:>}
case qi(3): // \.{\?=:\?}
	cur_r = rem_byte(main_j)
	main_p = lig_stack; lig_stack = new_lig_item(cur_r)
	set_link(lig_stack, main_p)
case qi(7), qi(11): // \.{\?=:\?>}, \.{\?=:\?>>}
	wrapup(false)
	cur_q = tail; cur_l = rem_byte(main_j)
	main_i = char_info(main_f, cur_l); ligature_present = true
default: // \.{=:}
	cur_l = rem_byte(main_j); ligature_present = true
	if lig_stack == null {
		goto main_loop_wrapup
	} else {
		goto main_loop_move_1
	}
}
if op_byte(main_j) > qi(4) && op_byte(main_j) != qi(7) {
	goto main_loop_wrapup
}
if cur_l < non_char {
	goto main_lig_loop
}
main_k = bchar_label[main_f]; goto main_lig_loop_1

@ \dg 앞 절의 코드에서 떼어 낸 부분이다.

@<|cur_r|을 바꾸고 |lig_stack|을...@>=
cur_r = rem_byte(main_j)
if lig_stack == null { // 오른쪽 경계 문자를 소비하고 있다
	lig_stack = new_lig_item(cur_r); bchar = non_char
} else if is_char_node(lig_stack) { // |link(lig_stack)=null|
	main_p = lig_stack; lig_stack = new_lig_item(cur_r)
	set_lig_ptr(lig_stack, main_p)
} else {
	set_character(lig_stack, cur_r)
}

@ 빈칸은 거의 \TeX의 안쪽 루프의 일부다. 대개 빈칸 아닌 문자 다섯 개마다 공백 하나쯤을 만나기 때문이다. 그래서 |main_control|은
@^inner loop@>
보통 공백에 두 번째로 높은 우선순위를 준다.

만일 \.{\\spaceskip} 같은 글루 매개변수를 `\.{0pt}'로 하면, 대응하는 글루 명세가 그저 0으로 가득 찬 어떤 명세를 가리키는 포인터가 아니라
정확히 |zero_glue|가 되도록 나중에 신경 쓸 것이다. 그래서 글루 매개변수가 0인지 아닌지 검사하기가 간단하다.

@<현재 목록에 보통 낱말 사이 공백을...@>=
if space_skip() == zero_glue {
	@<현재 글꼴의 텍스트 공백을 위한 글루 명세 |main_p|를 찾는다@>
	temp_ptr = new_glue(main_p)
} else {
	temp_ptr = new_param_glue(space_skip_code)
}
set_link(tail, temp_ptr); tail = temp_ptr
goto big_switch

@ 텍스트 글꼴마다 |font_glue|를 할당해 두면 시간과 메모리를 모두 아낀다. 세 공백 매개변수 가운데 어느 것이든 나중에
\.{\\fontdimen}으로 바뀌면, 프로시저 |find_font_dimen|이 여기서 할당한 |font_glue| 명세를 해제한다.

@<현재 글꼴의 텍스트 공백을 위한...@>=
main_p = font_glue[cur_font()]
if main_p == null {
	main_p = new_spec(zero_glue); main_k = param_base[cur_font()] + space_code
	set_width(main_p, font_info[main_k].sc) // 그것이 |space(cur_font)|다
	set_stretch(main_p, font_info[main_k+1].sc) // 그리고 |space_stretch(cur_font)|
	set_shrink(main_p, font_info[main_k+2].sc) // 그리고 |space_shrink(cur_font)|
	font_glue[cur_font()] = main_p
}

@ @<|main_control|이 쓰는 동작...@>=
func app_space() { // |space_factor!=1000|일 때 공백을 다룬다
	var q pointer // 글루 노드
	if space_factor() >= 2000 && xspace_skip() != zero_glue {
		q = new_param_glue(xspace_skip_code)
	} else {
		if space_skip() != zero_glue {
			main_p = space_skip()
		} else {
			@<현재 글꼴의 텍스트 공백을 위한...@>
		}
		main_p = new_spec(main_p)
		@<공백 인자에 따라 |main_p|의 글루 명세를 고친다@>
		q = new_glue(main_p); set_glue_ref_count(main_p, null)
	}
	set_link(tail, q); tail = q
}

@ @<공백 인자에 따라...@>=
if space_factor() >= 2000 {
	set_width(main_p, width(main_p)+extra_space(cur_font()))
}
set_stretch(main_p, xn_over_d(stretch(main_p), space_factor(), 1000))
set_shrink(main_p, xn_over_d(shrink(main_p), 1000, space_factor()))

@ 휴---이것으로 주 루프를 다 다루었다. 이제 다른 가능성의 조합들을 느긋하게 살펴볼 수 있다.

보충: 원본의 매크로 |any_mode(#)|는 `|vmode+#,hmode+#,mmode+#|'로 펼쳐지는데, 모드와 상관없는 명령에 쓴다. 이 번역에서는
펼쳐 쓴다.

@<안쪽 루프에 속하지 않는...@>=
case vmode + relax, hmode + relax, mmode + relax, vmode + spacer, mmode + spacer, mmode + no_boundary:
	// 아무것도 하지 않는다
case vmode + ignore_spaces, hmode + ignore_spaces, mmode + ignore_spaces:
	@<공백도 호출도 아닌...@>
	goto reswitch
case vmode + stop:
	if its_all_over() {
		return // 이것이 유일한 출구다
	}
case @<|main_control|이 금지하는 경우들@>
	vmode + mac_param, hmode + mac_param, mmode + mac_param:
	report_illegal_case()
@<수식 아닌 모드의 수식 전용 경우들과 그 반대@>
@<상자와 목록을 만드는 |main_control|의 경우들@>
@<|mode|에 상관없는 |main_control|의 경우들@>
@<\TeX의 확장을 위한 |main_control|의 경우들@>

@ 다음은 사용자가 실수로 수식 모드에 들어가거나 나온 것 같은 경우들의 목록이다. \TeX은 달러 기호를 끼워 넣고 현재 토큰을 다시
훑는다.

보충: 원본의 매크로 |non_math(#)|는 `|vmode+#,hmode+#|'로 펼쳐진다. 원본에서 이 절은 |case| 레이블 목록이지만, \.{GTANGLE}이
절 끝에 줄바꿈을 넣으므로 레이블 목록 뒤에 콜론이 오면 \GO/ 문법이 깨진다. 그래서 이 절에는 동작까지 담은 |case| 절 전체를 둔다.

@<수식 아닌 모드의 수식 전용...@>=
case vmode + sup_mark, hmode + sup_mark, vmode + sub_mark, hmode + sub_mark,
	vmode + math_char_num, hmode + math_char_num, vmode + math_given, hmode + math_given,
	vmode + math_comp, hmode + math_comp, vmode + delim_num, hmode + delim_num,
	vmode + left_right, hmode + left_right, vmode + above, hmode + above,
	vmode + radical, hmode + radical, vmode + math_style, hmode + math_style,
	vmode + math_choice, hmode + math_choice, vmode + vcenter, hmode + vcenter,
	vmode + non_script, hmode + non_script, vmode + mkern, hmode + mkern,
	vmode + limit_switch, hmode + limit_switch, vmode + mskip, hmode + mskip,
	vmode + math_accent, hmode + math_accent,
	mmode + endv, mmode + par_end, mmode + stop, mmode + vskip, mmode + un_vbox,
	mmode + valign, mmode + hrule:
	insert_dollar_sign()

@ @<|main_control|이 쓰는 동작...@>=
func insert_dollar_sign() {
	back_input(); cur_tok = math_shift_token + '$'
	print_err("Missing $ inserted")
@.Missing \$ inserted@>
	help2("I've inserted a begin-math/end-math symbol since I think",
		"you left one out. Proceed, with fingers crossed.")
	ins_error()
}

@ 잘못된 상황이 생기면 \TeX은 대개 그 오류에 특화된 오류 메시지를 낸다. 이를테면 `\.{\\noalign}'은 어느 모드에서도 나타나서는
안 된다. 정당하게 나타나는 곳에서는 모두 |align_peek| 루틴이 알아보기 때문이다. 그래서 `\.{\\noalign}'이 다른 곳에 나타나면
특별한 오류 메시지를 낸다. 그러나 때로는 가장 알맞은 오류 메시지가 그저 사용자가 하려던 일을 하도록 허락되지 않는다는 것이다.
이를테면 `\.{\\moveleft}'는 세로 모드에서만, `\.{\\lower}'는 세로 아닌 모드에서만 허락된다. 그런 경우들을 여기와, `See also
\dots'에 나오는 다른 절들에 늘어놓는다.

@<|main_control|이 금지하는...@>=
vmode + vmove, hmode + hmove, mmode + hmove,
vmode + last_item, hmode + last_item, mmode + last_item,

@ 프로시저 `|you_cant|'는 현재 명령이 현재 모드에서 허락되지 않는다는 줄을 찍는다. 이것들을 기호로 나타낸다.

@<|main_control|이 쓰는 동작...@>=
func you_cant() {
	print_err("You can't use `")
@.You can't use x in y mode@>
	print_cmd_chr(cur_cmd, cur_chr)
	print("' in "); print_mode(mode)
}

@ @<|main_control|이 쓰는 동작...@>=
func report_illegal_case() {
	you_cant()
	help4("Sorry, but I'm not programmed to handle this case;",
		"I'll just pretend that you didn't ask for it.",
		"If you're in the wrong mode, you might be able to",
		"return to the right one by typing `I}' or `I$' or `I\\par'.")
	error()
}

@ 어떤 연산은 특권 모드, 곧 |mode>0|인 경우에만 허락된다. 함수 |privileged|는 이 규칙의 위반을 찾아내는 데 쓰인다. 현재 |mode|가
음수이면 오류 메시지를 내고 |false|를 돌려준다.

@<|main_control|이 쓰는 동작...@>=
func privileged() bool {
	if mode > 0 {
		return true
	} else {
		report_illegal_case(); return false
	}
}

@ 명령 \.{\\dump}나 \.{\\end}는 둘 다 명령 코드가 `|stop|'이므로 어느 것이든 |main_control|을 마무리 단계로 들어가게 한다.

@<\TeX의 원시 명령을...@>=
primitive("end", stop, 0)
@!@:end_}{\.{\\end} primitive@>
primitive("dump", stop, 1)
@!@:dump_}{\.{\\dump} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case stop:
	if chr_code == 1 { print_esc("dump") } else { print_esc("end") }

@ 명령 |stop|을 감지했다고 해서 |main_control|을 곧바로 떠나고 싶지는 않다. 일이 정말로 멈추기 전에 \.{\\output} 루틴을 여러 번
불러야 할 수도 있기 때문이다. (출력 루틴이 `\.{\\gdef\\end\{...\}}'라고 해서 작업의 수명을 늘릴 수도 있다.) 그래서 |its_all_over|는
현재 쪽과 기여 목록이 비어 있고, 마지막 출력이 ``죽은 순환''이 아니었을 때에만 |true|다.

@<|main_control|이 쓰는 동작...@>=
func its_all_over() bool { // \.{\\end}나 \.{\\dump}가 나타나면 이것을 한다
	if privileged() {
		if page_head == page_tail && head == tail && dead_cycles == 0 {
			return true
		}
		back_input() // 남은 내용을 내보낸 뒤 다시 끝내 보겠다
		tail_append(new_null_box())
		set_width(tail, hsize())
		tail_append(new_glue(fill_glue))
		tail_append(new_penalty(-0o10000000000))
		build_page() // \.{\\hbox to \\hsize\{\}\\vfill\\penalty-'10000000000}을 덧붙인다
	}
	return false
}

@* 상자와 목록 만들기.
루틴 |main_control|의 가장 중요한 부분들은 상자 만들기라는 \TeX의 주된 임무에 관련되어 있다. 세로 목록과 가로 목록에 항목을 넣는
활동과, 그 목록들을 상자로 바꾸는 활동을 다스려야 한다. 필요한 장치는 이미 모두 마련했다. 남은 일은 알맞은 때에 ``단추를 누르는''
것이다.

@ 이 루틴들의 입문으로 가장 단순한 경우 하나를 생각해 보자. 세로 모드에서 `\.{\\hrule}'이, 또는 가로 모드나 수식 모드에서
`\.{\\vrule}'이 나타나면 어떻게 되는가? 루틴 |scan_rule_spec|이 필요한 일의 대부분을 이미 하므로 |main_control|의 코드는 짧다.
그래서 특별한 동작 프로시저가 필요 없다.

세로 모드에서 괘선 뒤에는 |prev_depth:=ignore_depth|로 해서 baselineskip 계산을 끈다는 것에 주목하라.

@<상자와 목록을 만드는...@>=
case vmode + hrule, hmode + vrule, mmode + vrule:
	tail_append(scan_rule_spec())
	if abs(mode) == vmode {
		set_prev_depth(ignore_depth)
	} else if abs(mode) == hmode {
		set_space_factor(1000)
	}

@ 명령 \.{\\hskip}과 \.{\\vskip} 같은 것의 처리는 조금 더 복잡하다. 그러나 |main_control|의 코드는 아주 짧다. 그저 동작 루틴
|append_glue|를 부르기 때문이다. 마찬가지로 \.{\\kern}은 |append_kern|을 작동시킨다.

@<상자와 목록을 만드는...@>=
case vmode + vskip, hmode + hskip, mmode + hskip, mmode + mskip: append_glue()
case vmode + kern, hmode + kern, mmode + kern, mmode + mkern: append_kern()

@ 명령 코드 |hskip|과 |vskip|은 \.{\\hskip}과 \.{\\vskip}만이 아니라 \.{\\hss}나 \.{\\vfil} 같은 제어 시퀀스에도 쓰인다. 차이는
|cur_chr|의 값에 있다.

@<정의@>=
const (
	@!fil_code = 0 // \.{\\hfil}과 \.{\\vfil}을 나타낸다
	@!fill_code = 1 // \.{\\hfill}과 \.{\\vfill}을 나타낸다
	@!ss_code = 2 // \.{\\hss}와 \.{\\vss}를 나타낸다
	@!fil_neg_code = 3 // \.{\\hfilneg}과 \.{\\vfilneg}을 나타낸다
	@!skip_code = 4 // \.{\\hskip}과 \.{\\vskip}을 나타낸다
	@!mskip_code = 5 // \.{\\mskip}을 나타낸다
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("hskip", hskip, skip_code)
@!@:hskip_}{\.{\\hskip} primitive@>
primitive("hfil", hskip, fil_code)
@!@:hfil_}{\.{\\hfil} primitive@>
primitive("hfill", hskip, fill_code)
@!@:hfill_}{\.{\\hfill} primitive@>
primitive("hss", hskip, ss_code)
@!@:hss_}{\.{\\hss} primitive@>
primitive("hfilneg", hskip, fil_neg_code)
@!@:hfil_neg_}{\.{\\hfilneg} primitive@>
primitive("vskip", vskip, skip_code)
@!@:vskip_}{\.{\\vskip} primitive@>
primitive("vfil", vskip, fil_code)
@!@:vfil_}{\.{\\vfil} primitive@>
primitive("vfill", vskip, fill_code)
@!@:vfill_}{\.{\\vfill} primitive@>
primitive("vss", vskip, ss_code)
@!@:vss_}{\.{\\vss} primitive@>
primitive("vfilneg", vskip, fil_neg_code)
@!@:vfil_neg_}{\.{\\vfilneg} primitive@>
primitive("mskip", mskip, mskip_code)
@!@:mskip_}{\.{\\mskip} primitive@>
primitive("kern", kern, explicit)
@!@:kern_}{\.{\\kern} primitive@>
primitive("mkern", mkern, mu_glue)
@!@:mkern_}{\.{\\mkern} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case hskip:
	switch chr_code {
	case skip_code: print_esc("hskip")
	case fil_code: print_esc("hfil")
	case fill_code: print_esc("hfill")
	case ss_code: print_esc("hss")
	default: print_esc("hfilneg")
	}
case vskip:
	switch chr_code {
	case skip_code: print_esc("vskip")
	case fil_code: print_esc("vfil")
	case fill_code: print_esc("vfill")
	case ss_code: print_esc("vss")
	default: print_esc("vfilneg")
	}
case mskip: print_esc("mskip")
case kern: print_esc("kern")
case mkern: print_esc("mkern")

@ 글루를 만드는 일은 모두 다음 서브루틴에 맡겼다. 이 서브루틴은 |build_page|를 부르면 잘못이 되는 곳에서도 적어도 한
군데 쓰이므로 |build_page|를 부르지 않는다.

@<|main_control|이 쓰는 동작...@>=
func append_glue() {
	var s small_number // 건너뛰기 명령의 변경자
	s = cur_chr
	switch s {
	case fil_code: cur_val = fil_glue
	case fill_code: cur_val = fill_glue
	case ss_code: cur_val = ss_glue
	case fil_neg_code: cur_val = fil_neg_glue
	case skip_code: scan_glue(glue_val)
	case mskip_code: scan_glue(mu_val)
	} // 이제 |cur_val|은 글루 명세를 가리킨다
	tail_append(new_glue(cur_val))
	if s >= skip_code {
		set_glue_ref_count(cur_val, glue_ref_count(cur_val)-1)
		if s > skip_code {
			set_subtype(tail, mu_glue)
		}
	}
}

@ @<|main_control|이 쓰는 동작...@>=
func append_kern() {
	var s quarterword // 커닝 노드의 |subtype|
	s = cur_chr; scan_dimen(s == mu_glue, false, false)
	tail_append(new_kern(cur_val)); set_subtype(tail, s)
}

@ 상자 만들기에 관련된 동작의 많은 것은 입력에 중괄호가 나타나면서 시작된다. 이를테면 사용자가 세로 모드에서 `\.{\\hbox}
\.{to} \.{100pt\{$\langle\,\hbox{\rm hlist}\,\rangle$\}}'라고 하면, 상자 크기에 관한 정보(100pt, |exactly|)를 |save_stack|에
넣고 그 바로 위에 수준 경계 낱말을 두며, |cur_group:=adjusted_hbox_group|으로 한다. \TeX은 가로 목록을 처리하려고 제한된 가로
모드로 들어간다. 오른쪽 중괄호가 나오면 결국 |save_stack|이 이전 상태로 되돌아가고, 그때 상자 크기에 관한 정보(100pt,
|exactly|)를 다시 쓸 수 있다. 상자를 묶고 제한된 가로 모드를 떠나서, 새 상자를 둘러싼 모드의 현재 목록(이 경우 세로 모드의 현재
목록)에 덧붙이고, |hpack|이 상자에서 꺼낸 세로 조정이 있으면 그 뒤에 덧붙인다.

그래서 프로그램의 다음 몇 절은 왼쪽과 오른쪽 중괄호를 다루는 데 관련되어 있다.

@ 왼쪽 중괄호가 쪽이나 문단 가운데에 나타나면 그냥 새 그룹 수준을 들여올 뿐이고, 짝이 맞는 오른쪽 중괄호도 그렇게 극적인 효과를
내지 않는다. 그런 그룹은 모드에도 현재 목록에도 영향을 주지 않는다.

@<상자와 목록을 만드는...@>=
case vmode + left_brace, hmode + left_brace: new_save_level(simple_group)
case vmode + begin_group, hmode + begin_group, mmode + begin_group: new_save_level(semi_simple_group)
case vmode + end_group, hmode + end_group, mmode + end_group:
	if cur_group == semi_simple_group { unsave() } else { off_save() }

@ 중괄호 같은 것이 제대로 둥지를 이루지 않는 오류를 다루어야 한다. 사용자가 여분의 기호를 넣는 실행 오류를 저지를 때도 있고,
빠뜨리는 누락 오류를 저지를 때도 있다. \TeX은 둘을 늘 구별할 수는 없으므로, 짐작을 하고 루프에 빠지지 않으려 한다.

루틴 |off_save|는 현재 그룹 코드가 잘못되었을 때 불린다. 맨 위 수준을 깨끗이 치우는 데 도움이 될 무언가를 사용자의 입력에 끼워
넣으려 한다.

@<|main_control|이 쓰는 동작...@>=
func off_save() {
	var p pointer // 끼워 넣은 토큰
	if cur_group == bottom_level {
		@<현재 토큰을 버리고 짝이 맞지 않았다고 불평한다@>
	} else {
		back_input(); p = get_avail(); set_link(temp_head, p)
		print_err("Missing ")
		@<|cur_group|에 맞는 토큰을 끼워 넣을 준비를 하고 그것을 찍는다@>
		print(" inserted"); ins_list(link(temp_head))
		help5("I've inserted something that you may have forgotten.",
			"(See the <inserted text> above.)",
			"With luck, this will get me unwedged. But if you",
			"really didn't forget anything, try typing `2' now; then",
			"my insertion and my current dilemma will both disappear.")
		error()
	}
}

@ 이 시점에서 |link(temp_head)=p|이고, 이것은 빈 한 낱말짜리 노드를 가리키는 포인터다.

@<|cur_group|에 맞는 토큰을...@>=
switch cur_group {
case semi_simple_group:
	set_info(p, cs_token_flag+frozen_end_group)
	print_esc("endgroup")
@.Missing \\endgroup inserted@>
case math_shift_group:
	set_info(p, math_shift_token+'$'); print_char('$')
@.Missing \$ inserted@>
case math_left_group:
	set_info(p, cs_token_flag+frozen_right); set_link(p, get_avail())
	p = link(p); set_info(p, other_token+'.'); print_esc("right.")
@.Missing \\right\hbox{.} inserted@>
@^null delimiter@>
default:
	set_info(p, right_brace_token+'}'); print_char('}')
@.Missing \} inserted@>
}

@ @<현재 토큰을 버리고...@>=
print_err("Extra "); print_cmd_chr(cur_cmd, cur_chr)
@.Extra x@>
help1("Things are pretty mixed up, but I think the worst is over.")
error()

@ 범주가 |right_brace|인 문자를 위한 루틴은 여러 하위 경우로 갈라진다. 그룹 코드 |cur_group|에 따라 여러 가지 일이 일어날 수 있기 때문이다. 어떤
종류의 그룹은 오른쪽 중괄호로 끝나서는 안 된다. 문제를 정확히 짚어 내기를 바라며 오류 메시지를 낸다. 이 루틴의 갈래 대부분은
그것을 이해할 준비가 되었을 때 나중에 채운다. 그 사이에 그런 오류를 다룰 준비를 해 두어야 한다.

@<상자와 목록을 만드는...@>=
case vmode + right_brace, hmode + right_brace, mmode + right_brace: handle_right_brace()

@ @<|handle_right_brace|라는...@>=
func handle_right_brace() {
	var p, q pointer // 잠깐 쓰는 변수
	var d scaled // |insert_group|에서 |split_max_depth|를 담는다
	var f int32 // |insert_group|에서 |floating_penalty|를 담는다
	switch cur_group {
	case simple_group: unsave()
	case bottom_level:
		print_err("Too many }'s")
@.Too many \}'s@>
		help2("You've closed more groups than you opened.",
			"Such booboos are generally harmless, so keep going.")
		error()
	case semi_simple_group, math_shift_group, math_left_group: extra_right_brace()
	@<|right_brace|가 미루어 둔 동작을 일으키는 |handle_right_brace|의 경우들@>
	default: confusion("rightbrace")
@:this can't happen rightbrace}{\quad rightbrace@>
	}
}

@ @<|main_control|이 쓰는 동작...@>=
func extra_right_brace() {
	print_err("Extra }, or forgotten ")
@.Extra \}, or forgotten x@>
	switch cur_group {
	case semi_simple_group: print_esc("endgroup")
	case math_shift_group: print_char('$')
	case math_left_group: print_esc("right")
	}
	help5("I've deleted a group-closing symbol because it seems to be",
		"spurious, as in `$x}$'. But perhaps the } is legitimate and",
		"you forgot something else, as in `\\hbox{$x}'. In such cases",
		"the way to recover is to insert both the forgotten and the",
		"deleted material, e.g., by typing `I$}'.")
	error()
	align_state++
}

@ 다음은 문단마다, 그리고 내부 세로 모드에 들어갈 때 기본값으로 돌아가야 할 매개변수들을 지우는 곳이다.

@<|main_control|이 쓰는 동작...@>=
func normal_paragraph() {
	if looseness() != 0 {
		eq_word_define(int_base+looseness_code, 0)
	}
	if hang_indent() != 0 {
		eq_word_define(dimen_base+hang_indent_code, 0)
	}
	if hang_after() != 1 {
		eq_word_define(int_base+hang_after_code, 1)
	}
	if par_shape_ptr() != null {
		eq_define(par_shape_loc, shape_ref, null)
	}
}

@ 이제 \.{\\hbox}를 어떻게 다루는지 문제로 돌아가자. 실은 조금 더 넓은 문맥도 생각해야 한다. `\.{\\setbox3=}\penalty0\.{\\hbox...}'와
`\.{\\leaders}\penalty0\.{\\hbox...}'와 `\.{\\lower3.8pt\\hbox...}' 같은 구성은 상자를 묶은 뒤에 꽤 다른 동작을 일으켜야 하기
때문이다. 거꾸로 `\.{\\setbox3=}' 같은 구성 뒤에는 여러 종류의 상자가 올 수 있고, 그런 것을 효율적으로 부호화하고 싶다.

다시 말해 문제가 둘 있다. 상자의 문맥을 나타내는 것과 그 종류를 나타내는 것이다.

첫째 문제는 |scan_spec|이 만드는 치수를 담은 두 항목 바로 아래에 ``문맥 코드''를 |save_stack|에 넣어서 해결한다. 문맥 코드는
(부호 있는) 옮김 양이거나, |box_flag=@t$2^{30}$@>|일 때 |>=box_flag|인 큰 정수다. 코드 |box_flag|부터 |box_flag+255|까지는
`\.{\\setbox0}'부터 `\.{\\setbox255}'까지를 나타내고, 코드 |box_flag+256|부터 |box_flag+511|까지는 `\.{\\global\\setbox0}'부터
`\.{\\global\\setbox255}'까지를 나타낸다. 코드 |box_flag+512|는 `\.{\\shipout}'을 나타내고, 코드 |box_flag+513|부터 |box_flag+515|까지는
`\.{\\leaders}', `\.{\\cleaders}', `\.{\\xleaders}'를 나타낸다.

둘째 문제는 상자를 만드는 모든 제어 시퀀스에 명령 코드 |make_box|를 주고, 그것들을 구별하는 데 다음 |chr_code| 값들을 써서
해결한다. 곧 |box_code|, |copy_code|, |last_box_code|, |vsplit_code|, |vtop_code|, |vtop_code+vmode|, |vtop_code+hmode|이다. 뒤의 둘은
각각 \.{\\vbox}와 \.{\\hbox}를 나타낸다.

@<정의@>=
const (
	@!box_flag = 0o10000000000 // `\.{\\setbox0}'의 문맥 코드
	@!ship_out_flag = box_flag + 512 // `\.{\\shipout}'의 문맥 코드
	@!leader_flag = box_flag + 513 // `\.{\\leaders}'의 문맥 코드
	@!box_code = 0 // `\.{\\box}'의 |chr_code|
	@!copy_code = 1 // `\.{\\copy}'의 |chr_code|
	@!last_box_code = 2 // `\.{\\lastbox}'의 |chr_code|
	@!vsplit_code = 3 // `\.{\\vsplit}'의 |chr_code|
	@!vtop_code = 4 // `\.{\\vtop}'의 |chr_code|
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

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
primitive("box", make_box, box_code)
@!@:box_}{\.{\\box} primitive@>
primitive("copy", make_box, copy_code)
@!@:copy_}{\.{\\copy} primitive@>
primitive("lastbox", make_box, last_box_code)
@!@:last_box_}{\.{\\lastbox} primitive@>
primitive("vsplit", make_box, vsplit_code)
@!@:vsplit_}{\.{\\vsplit} primitive@>
primitive("vtop", make_box, vtop_code)
@!@:vtop_}{\.{\\vtop} primitive@>
primitive("vbox", make_box, vtop_code+vmode)
@!@:vbox_}{\.{\\vbox} primitive@>
primitive("hbox", make_box, vtop_code+hmode)
@!@:hbox_}{\.{\\hbox} primitive@>
primitive("shipout", leader_ship, a_leaders-1) // |ship_out_flag=leader_flag-1|
@!@:ship_out_}{\.{\\shipout} primitive@>
primitive("leaders", leader_ship, a_leaders)
@!@:leaders_}{\.{\\leaders} primitive@>
primitive("cleaders", leader_ship, c_leaders)
@!@:c_leaders_}{\.{\\cleaders} primitive@>
primitive("xleaders", leader_ship, x_leaders)
@!@:x_leaders_}{\.{\\xleaders} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case hmove:
	if chr_code == 1 { print_esc("moveleft") } else { print_esc("moveright") }
case vmove:
	if chr_code == 1 { print_esc("raise") } else { print_esc("lower") }
case make_box:
	switch chr_code {
	case box_code: print_esc("box")
	case copy_code: print_esc("copy")
	case last_box_code: print_esc("lastbox")
	case vsplit_code: print_esc("vsplit")
	case vtop_code: print_esc("vtop")
	case vtop_code + vmode: print_esc("vbox")
	default: print_esc("hbox")
	}
case leader_ship:
	if chr_code == a_leaders {
		print_esc("leaders")
	} else if chr_code == c_leaders {
		print_esc("cleaders")
	} else if chr_code == x_leaders {
		print_esc("xleaders")
	} else {
		print_esc("shipout")
	}

@ 상자가 필요한 구성은 지정된 문맥 코드로 |scan_box|를 불러서 시작한다. 루틴 |scan_box|는 다음에 |make_box| 명령이 오는지 확인한
다음 |begin_box|를 부른다.

@<상자와 목록을 만드는...@>=
case vmode + hmove, hmode + vmove, mmode + vmove:
	t = cur_chr
	scan_normal_dimen()
	if t == 0 { scan_box(cur_val) } else { scan_box(-cur_val) }
case vmode + leader_ship, hmode + leader_ship, mmode + leader_ship:
	scan_box(leader_flag - a_leaders + cur_chr)
case vmode + make_box, hmode + make_box, mmode + make_box: begin_box(0)

@ 전역 변수 |cur_box|는 새로 만든 상자를 가리킨다. 상자가 비어 있으면 |cur_box=null|이다. 그렇지 않으면 |type(cur_box)=hlist_node|나
|vlist_node|나 |rule_node|이다. 그 가운데 |rule_node| 경우는 리더에서만 생길 수 있다.

@<전역 변수@>=
var @!cur_box pointer // 문맥에 놓일 상자

@ 프로시저 |box_end|는 |box_context|가 위에서 설명한 대로 문맥을 나타낼 때 |cur_box|로 올바른 일을 한다.

@<|main_control|이 쓰는 동작...@>=
func box_end(box_context int32) {
	var p pointer // 수식 모드에서 새 상자를 위한 |ord_noad|
	if box_context < box_flag {
		@<상자 |cur_box|를 |box_context|만큼 옮겨 현재 목록에 덧붙인다@>
	} else if box_context < ship_out_flag {
		@<|cur_box|를 상자 레지스터에 저장한다@>
	} else if cur_box != null {
		if box_context > ship_out_flag {
			@<|cur_box|를 쓰는 새 리더 노드를 덧붙인다@>
		} else {
			ship_out(cur_box)
		}
	}
}

@ 전역 변수 |adjust_tail|은 현재 상자에 현재 세로 목록에 덧붙여야 할 조정이 들어 있을 수 있을 때, 그리고 오직 그때에만
널이 아니다.

@<상자 |cur_box|를 |box_context|만큼...@>=
if cur_box != null {
	set_shift_amount(cur_box, box_context)
	if abs(mode) == vmode {
		append_to_vlist(cur_box)
		if adjust_tail != null {
			if adjust_head != adjust_tail {
				set_link(tail, link(adjust_head)); tail = adjust_tail
			}
			adjust_tail = null
		}
		if mode > 0 {
			build_page()
		}
	} else {
		if abs(mode) == hmode {
			set_space_factor(1000)
		} else {
			p = new_noad()
			set_math_type(nucleus(p), sub_box)
			set_info(nucleus(p), cur_box); cur_box = p
		}
		set_link(tail, cur_box); tail = cur_box
	}
}

@ @<|cur_box|를 상자 레지스터에...@>=
if box_context < box_flag+256 {
	eq_define(box_base-box_flag+box_context, box_ref, cur_box)
} else {
	geq_define(box_base-box_flag-256+box_context, box_ref, cur_box)
}

@ @<|cur_box|를 쓰는 새 리더 노드를...@>=
@<공백도 relax도 호출도...@>
if (cur_cmd == hskip && abs(mode) != vmode) || (cur_cmd == vskip && abs(mode) == vmode) {
	append_glue(); set_subtype(tail, box_context-(leader_flag-a_leaders))
	set_leader_ptr(tail, cur_box)
} else {
	print_err("Leaders not followed by proper glue")
@.Leaders not followed by...@>
	help3("You should say `\\leaders <box or rule><hskip or vskip>'.",
		"I found the <box or rule>, but there's no suitable",
		"<hskip or vskip>, so I'm ignoring these leaders.")
	back_error()
	flush_node_list(cur_box)
}

@ 이제 상자가 결국 어떻게 되는지 알았으니 상자를 만드는 첫 단계를 생각할 수 있다. 루틴 |begin_box|는 |box_context|가 문맥 지정이고,
|cur_chr|가 원하는 상자의 종류를 지정하고, |cur_cmd=make_box|일 때 불린다.

@<|main_control|이 쓰는 동작...@>=
func begin_box(box_context int32) {
	var p, q pointer // 현재 목록을 훑는다
	var m quarterword // 대체 목록의 길이
	var k halfword // 0이나 |vmode|나 |hmode|
	var n eight_bits // 상자 번호
	switch cur_chr {
	case box_code:
		scan_eight_bit_int(); cur_box = box(cur_val)
		set_box_reg(cur_val, null) // 상자는 같은 수준에서 빈 상자가 된다
	case copy_code: scan_eight_bit_int(); cur_box = copy_node_list(box(cur_val))
	case last_box_code: @<현재 목록이 상자 노드로 끝나면 그것을 떼어 |cur_box|로 한다@>
	case vsplit_code: @<세로 상자의 일부를 떼어 |cur_box|가 가리키게 한다@>
	default: @<가로 상자나 세로 상자 만들기를 시작하고 |return|한다@>
	}
	box_end(box_context) // 단순한 경우에는 상자를 바로 쓴다
}

@ 조건 |not is_char_node(tail)|은 |head!=tail|을 뜻한다는 것에 주의하라. 머리 |head|는 한 낱말짜리 노드이기 때문이다. 현재 목록이
상자 노드로 끝나지 않으면 |cur_box:=null|로 한다.

@<현재 목록이 상자 노드로 끝나면...@>=
cur_box = null
if abs(mode) == mmode {
	you_cant(); help1("Sorry; this \\lastbox will be void."); error()
} else if mode == vmode && head == tail {
	you_cant()
	help2("Sorry...I usually can't take things from the current page.",
		"This \\lastbox will therefore be void.")
	error()
} else {
	if !is_char_node(tail) && (type_(tail) == hlist_node || type_(tail) == vlist_node) {
		@<선택적 나눔의 일부가 아니면 마지막 상자를 떼어 낸다@>
	}
}

@ @<선택적 나눔의 일부가 아니면...@>=
q = head
for {
	p = q
	if !is_char_node(q) && type_(q) == disc_node {
		for m = 1; m <= replace_count(q); m++ {
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
cur_box = tail; set_shift_amount(cur_box, 0)
tail = p; set_link(p, null)
done: ;

@ 여기서 `\.{\\vsplit 13 to 100pt}' 같은 것을 다룬다.

@<세로 상자의 일부를 떼어...@>=
scan_eight_bit_int(); n = cur_val
if !scan_keyword("to") {
@.to@>
	print_err("Missing `to' inserted")
@.Missing `to' inserted@>
	help2("I'm working on `\\vsplit<box number> to <dimen>';",
		"will look for the <dimen> next.")
	error()
}
scan_normal_dimen()
cur_box = vsplit(n, cur_val)

@ 여기서 상자를 만들려고 제한된 가로 모드나 내부 세로 모드로 들어간다.

@<가로 상자나 세로 상자 만들기를...@>=
k = cur_chr - vtop_code; set_saved(0, box_context)
if k == hmode {
	if box_context < box_flag && abs(mode) == vmode {
		scan_spec(adjusted_hbox_group, true)
	} else {
		scan_spec(hbox_group, true)
	}
} else {
	if k == vmode {
		scan_spec(vbox_group, true)
	} else {
		scan_spec(vtop_group, true); k = vmode
	}
	normal_paragraph()
}
push_nest(); mode = -k
if k == vmode {
	set_prev_depth(ignore_depth)
	if every_vbox() != null {
		begin_token_list(every_vbox(), every_vbox_text)
	}
} else {
	set_space_factor(1000)
	if every_hbox() != null {
		begin_token_list(every_hbox(), every_hbox_text)
	}
}
return

@ @<|main_control|이 쓰는 동작...@>=
func scan_box(box_context int32) { // 다음 입력은 상자나 어쩌면 괘선을 지정해야 한다
	@<공백도 relax도 호출도...@>
	if cur_cmd == make_box {
		begin_box(box_context)
	} else if box_context >= leader_flag && (cur_cmd == hrule || cur_cmd == vrule) {
		cur_box = scan_rule_spec(); box_end(box_context)
	} else {
		print_err("A <box> was supposed to be here")
@.A <box> was supposed to...@>
		help3("I was expecting to see \\hbox or \\vbox or \\copy or \\box or",
			"something like that. So you might find something missing in",
			"your output. But keep trying; you can fix this later.")
		back_error()
	}
}

@ 구성 \.{\\hbox}나 \.{\\vbox}나 \.{\\vtop}의 끝에서 오른쪽 중괄호가 나오면 루틴 |package_|가 작동한다. 끝나지 않은 문단을
마무리해야 할 수도 있다.

@<|right_brace|가 미루어 둔 동작을...@>=
case hbox_group: package_(0)
case adjusted_hbox_group: adjust_tail = adjust_head; package_(0)
case vbox_group: end_graf(); package_(0)
case vtop_group: end_graf(); package_(vtop_code)

@ @<|main_control|이 쓰는 동작...@>=
func package_(c small_number) {
	var h scaled // 상자의 높이
	var p pointer // 상자의 첫 노드
	var d scaled // 최대 깊이
	d = box_max_depth(); unsave(); save_ptr = save_ptr - 3
	if mode == -hmode {
		cur_box = hpack(link(head), saved(2), saved(1))
	} else {
		cur_box = vpackage(link(head), saved(2), saved(1), d)
		if c == vtop_code {
			@<\.{\\vtop}을 위해 |cur_box|의 높이와 깊이를 다시 맞춘다@>
		}
	}
	pop_nest(); box_end(saved(0))
}

@ 상자 `\.{\\vtop}'의 높이는 그 목록의 첫 항목이 |hlist_node|나 |vlist_node|나 |rule_node|이면 그것에서 물려받고, 그렇지 않으면
\.{\\vtop}의 높이는 0이다.

@<\.{\\vtop}을 위해 |cur_box|의...@>=
h = 0; p = list_ptr(cur_box)
if p != null && type_(p) <= rule_node {
	h = height(p)
}
set_depth(cur_box, depth(cur_box)-h+height(cur_box)); set_height(cur_box, h)

@ 문단은 세로 모드에서 가로 모드 내용이 나타날 때, 또는 `\.{\\indent}'나 `\.{\\noindent}'로 명시적으로 문단을 시작할 때 시작한다.

@<\TeX의 원시 명령을...@>=
primitive("indent", start_par, 1)
@!@:indent_}{\.{\\indent} primitive@>
primitive("noindent", start_par, 0)
@!@:no_indent_}{\.{\\noindent} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case start_par:
	if chr_code == 0 { print_esc("noindent") } else { print_esc("indent") }

@ @<상자와 목록을 만드는...@>=
case vmode + start_par: new_graf(cur_chr > 0)
case vmode + letter, vmode + other_char, vmode + char_num, vmode + char_given,
	vmode + math_shift, vmode + un_hbox, vmode + vrule,
	vmode + accent, vmode + discretionary, vmode + hskip, vmode + valign,
	vmode + ex_space, vmode + no_boundary:
	back_input(); new_graf(true)

@ @<|main_control|이 쓰는 동작...@>=
func norm_min(h int32) small_number {
	if h <= 0 {
		return 1
	} else if h >= 63 {
		return 63
	} else {
		return h
	}
}
@#
func new_graf(indented bool) {
	prev_graf = 0
	if mode == vmode || head != tail {
		tail_append(new_param_glue(par_skip_code))
	}
	push_nest(); mode = hmode; set_space_factor(1000); set_cur_lang(); set_clang(cur_lang)
	prev_graf = (norm_min(left_hyphen_min())*0o100+norm_min(right_hyphen_min()))*0o200000 + cur_lang
	if indented {
		tail = new_null_box(); set_link(head, tail); set_width(tail, par_indent())
	}
	if every_par() != null {
		begin_token_list(every_par(), every_par_text)
	}
	if nest_ptr == 1 {
		build_page() // |par_skip| 글루를 현재 쪽에 놓는다
	}
}

@ @<상자와 목록을 만드는...@>=
case hmode + start_par, mmode + start_par: indent_in_hmode()

@ @<|main_control|이 쓰는 동작...@>=
func indent_in_hmode() {
	var p, q pointer
	if cur_chr > 0 { // \.{\\indent}
		p = new_null_box(); set_width(p, par_indent())
		if abs(mode) == hmode {
			set_space_factor(1000)
		} else {
			q = new_noad(); set_math_type(nucleus(q), sub_box)
			set_info(nucleus(q), p); p = q
		}
		tail_append(p)
	}
}

@ 문단은 |par_end| 명령을 감지할 때, 또는 \.{\\vbox}, \.{\\insert}, \.{\\output} 같은 세로 모드 루틴의 오른쪽 중괄호에 이르렀을
때 가로 모드에 있으면 끝난다.

@<상자와 목록을 만드는...@>=
case vmode + par_end:
	normal_paragraph()
	if mode > 0 {
		build_page()
	}
case hmode + par_end:
	if align_state < 0 {
		off_save() // 이것은 제대로 끝나지 않은 정렬에서 회복하려 한다
	}
	end_graf() // |mode>0|이면 이것은 둘러싼 모드로 데려간다
	if mode == vmode {
		build_page()
	}
case hmode + stop, hmode + vskip, hmode + hrule, hmode + un_vbox, hmode + halign: head_for_vmode()

@ @<|main_control|이 쓰는 동작...@>=
func head_for_vmode() {
	if mode < 0 {
		if cur_cmd != hrule {
			off_save()
		} else {
			print_err("You can't use `")
			print_esc("hrule"); print("' here except with leaders")
@.You can't use \\hrule...@>
			help2("To put a horizontal rule in an hbox or an alignment,",
				"you should use \\leaders or \\hrulefill (see The TeXbook).")
			error()
		}
	} else {
		back_input(); cur_tok = par_token; back_input(); set_token_type(inserted)
	}
}

@ @<|main_control|이 쓰는 동작...@>=
func end_graf() {
	if mode == hmode {
		if head == tail {
			pop_nest() // 빈 문단은 무시한다
		} else {
			line_break(widow_penalty())
		}
		normal_paragraph()
		error_count = 0
	}
}

@ 삽입, 조정, 표시 노드는 프로그램의 다음 조각들이 만든다.

@<상자와 목록을 만드는...@>=
case vmode + insert, hmode + insert, mmode + insert, hmode + vadjust, mmode + vadjust:
	begin_insert_or_adjust()
case vmode + mark, hmode + mark, mmode + mark: make_mark()

@ @<|main_control|이 금지하는...@>=
vmode + vadjust,

@ @<|main_control|이 쓰는 동작...@>=
func begin_insert_or_adjust() {
	if cur_cmd == vadjust {
		cur_val = 255
	} else {
		scan_eight_bit_int()
		if cur_val == 255 {
			print_err("You can't "); print_esc("insert"); print_int(255)
@.You can't \\insert255@>
			help1("I'm changing to \\insert0; box 255 is special.")
			error(); cur_val = 0
		}
	}
	set_saved(0, cur_val); save_ptr++
	new_save_level(insert_group); scan_left_brace(); normal_paragraph()
	push_nest(); mode = -vmode; set_prev_depth(ignore_depth)
}

@ @<|right_brace|가 미루어 둔 동작을...@>=
case insert_group: @<삽입이나 조정 노드를 마무리한다@>
case output_group: @<출력 루틴이 끝난 뒤 쪽 조립기를...@>

@ \dg 앞 절의 |insert_group| 경우다. 이제 |saved(0)|은 삽입 번호이거나, |vadjust|이면 255다.

@<삽입이나 조정 노드를 마무리한다@>=
end_graf(); q = split_top_skip(); add_glue_ref(q)
d = split_max_depth(); f = floating_penalty(); unsave(); save_ptr--
p = vpack(link(head), natural, additional); pop_nest()
if saved(0) < 255 {
	tail_append(get_node(ins_node_size))
	set_type(tail, ins_node); set_subtype(tail, qi(saved(0)))
	set_height(tail, height(p)+depth(p)); set_ins_ptr(tail, list_ptr(p))
	set_split_top_ptr(tail, q); set_depth(tail, d); set_float_cost(tail, f)
} else {
	tail_append(get_node(small_node_size))
	set_type(tail, adjust_node)
	set_subtype(tail, 0) // |subtype|은 쓰이지 않는다
	set_adjust_ptr(tail, list_ptr(p)); delete_glue_ref(q)
}
free_node(p, box_node_size)
if nest_ptr == 0 {
	build_page()
}

@ @<|main_control|이 쓰는 동작...@>=
func make_mark() {
	var p pointer // 새 노드
	p = scan_toks(false, true); p = get_node(small_node_size)
	set_type(p, mark_node); set_subtype(p, 0) // |subtype|은 쓰이지 않는다
	set_mark_ptr(p, def_ref); set_link(tail, p); tail = p
}

@ 벌점 노드는 명령 |break_penalty|로 목록에 들어간다.
@^penalties@>

@<상자와 목록을 만드는...@>=
case vmode + break_penalty, hmode + break_penalty, mmode + break_penalty: append_penalty()

@ @<|main_control|이 쓰는 동작...@>=
func append_penalty() {
	scan_int(); tail_append(new_penalty(cur_val))
	if mode == vmode {
		build_page()
	}
}

@ 명령 |remove_item|은 현재 목록의 꼬리에 벌점, 커닝, 글루 노드가 있으면 무작정 선형 탐색으로 그것을 없앤다. 명령 \.{\\lastbox}처럼 이
명령도 세로 모드(내부 세로 모드는 빼고)에서는 허락되지 않는다. 세로 모드의 현재 목록은 쪽 조립기로 보내지기 때문이다. 그러나
세로 모드에서 구현할 수 있는 경우가 되면 그렇게 한다.

@<상자와 목록을 만드는...@>=
case vmode + remove_item, hmode + remove_item, mmode + remove_item: delete_last()

@ 프로시저 |delete_last|를 부를 때 |cur_chr|는 있으면 지울 노드의 |type|이다.

@<|main_control|이 쓰는 동작...@>=
func delete_last() {
	var p, q pointer // 현재 목록을 훑는다
	var m quarterword // 대체 목록의 길이
	if mode == vmode && tail == head {
		@<지금은 이 연산을 할 수 없다고 사과한다@>
	} else {
		if !is_char_node(tail) && type_(tail) == cur_chr {
			q = head
			for {
				p = q
				if !is_char_node(q) && type_(q) == disc_node {
					for m = 1; m <= replace_count(q); m++ {
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
			set_link(p, null); flush_node_list(tail); tail = p
		}
	}
}

@ 명령 \.{\\unskip}이 글루 아닌 것 뒤에 오는 경우가 아니면, 지금은 이 연산을 할 수 없다고 사과한다.

@<지금은 이 연산을...@>=
if cur_chr != glue_node || last_glue != max_halfword {
	you_cant()
	help2("Sorry...I usually can't take things from the current page.",
		"Try `I\\vskip-\\lastskip' instead.")
	if cur_chr == kern_node {
		help_line[0] = "Try `I\\kern-\\lastkern' instead."
	} else if cur_chr != glue_node {
		help_line[0] = "Perhaps you can make the output routine do it."
	}
	error()
}

@ @<\TeX의 원시 명령을...@>=
primitive("unpenalty", remove_item, penalty_node)
@!@:un_penalty_}{\.{\\unpenalty} primitive@>
primitive("unkern", remove_item, kern_node)
@!@:un_kern_}{\.{\\unkern} primitive@>
primitive("unskip", remove_item, glue_node)
@!@:un_skip_}{\.{\\unskip} primitive@>
primitive("unhbox", un_hbox, box_code)
@!@:un_hbox_}{\.{\\unhbox} primitive@>
primitive("unhcopy", un_hbox, copy_code)
@!@:un_hcopy_}{\.{\\unhcopy} primitive@>
primitive("unvbox", un_vbox, box_code)
@!@:un_vbox_}{\.{\\unvbox} primitive@>
primitive("unvcopy", un_vbox, copy_code)
@!@:un_vcopy_}{\.{\\unvcopy} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case remove_item:
	if chr_code == glue_node {
		print_esc("unskip")
	} else if chr_code == kern_node {
		print_esc("unkern")
	} else {
		print_esc("unpenalty")
	}
case un_hbox:
	if chr_code == copy_code { print_esc("unhcopy") } else { print_esc("unhbox") }
case un_vbox:
	if chr_code == copy_code { print_esc("unvcopy") } else { print_esc("unvbox") }

@ 명령 |un_hbox|와 |un_vbox|는 현재 상자 256개 가운데 하나의 포장을 푼다.

@<상자와 목록을 만드는...@>=
case vmode + un_vbox, hmode + un_hbox, mmode + un_hbox: unpackage()

@ @<|main_control|이 쓰는 동작...@>=
func unpackage() {
	var p pointer // 상자
	var c int32 // 베껴야 하는가? |box_code..copy_code|
	c = cur_chr; scan_eight_bit_int(); p = box(cur_val)
	if p == null {
		return
	}
	if abs(mode) == mmode || (abs(mode) == vmode && type_(p) != vlist_node) ||
		(abs(mode) == hmode && type_(p) != hlist_node) {
		print_err("Incompatible list can't be unboxed")
@.Incompatible list...@>
		help3("Sorry, Pandora. (You sneaky devil.)",
			"I refuse to unbox an \\hbox in vertical mode or vice versa.",
			"And I can't open any boxes in math mode.")
		error(); return
	}
	if c == copy_code {
		set_link(tail, copy_node_list(list_ptr(p)))
	} else {
		set_link(tail, list_ptr(p)); set_box_reg(cur_val, null)
		free_node(p, box_node_size)
	}
	for link(tail) != null {
		tail = link(tail)
	}
}

@ @<|main_control|이 금지하는...@>=
vmode + ital_corr,

@ 기울임 보정은 |ital_corr| 명령이 문자 뒤에 올 때 커닝 노드로 바뀐다. 수식 모드에서는 여기서 0인 커닝을 덧붙여서 같은 효과를
얻는다. 기울임 보정은 나중에 주어지기 때문이다.

@<상자와 목록을 만드는...@>=
case hmode + ital_corr: append_italic_correction()
case mmode + ital_corr: tail_append(new_kern(0))

@ @<|main_control|이 쓰는 동작...@>=
func append_italic_correction() {
	var p pointer // 현재 목록의 꼬리에 있는 |char_node|
	var f internal_font_number // |char_node|의 글꼴
	if tail != head {
		if is_char_node(tail) {
			p = tail
		} else if type_(tail) == ligature_node {
			p = lig_char(tail)
		} else {
			return
		}
		f = font(p)
		tail_append(new_kern(char_italic(f, char_info(f, character(p)))))
		set_subtype(tail, explicit)
	}
}

@ 선택적 나눔 노드는 흔한 경우인 `\.{\\-}'에서는 쉽지만, 일반적인 경우에는 항목이 가득 든 중괄호 세 개를 처리해야 한다.

@<\TeX의 원시 명령을...@>=
primitive("-", discretionary, 1)
@!@:Single-character primitives -}{\quad\.{\\-}@>
primitive("discretionary", discretionary, 0)
@!@:discretionary_}{\.{\\discretionary} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case discretionary:
	if chr_code == 1 { print_esc("-") } else { print_esc("discretionary") }

@ @<상자와 목록을 만드는...@>=
case hmode + discretionary, mmode + discretionary: append_discretionary()

@ 선택적 나눔 노드를 덧붙일 때 공백 인자는 바뀌지 않지만, 하위 목록에서는 1000으로 시작한다.

@<|main_control|이 쓰는 동작...@>=
func append_discretionary() {
	var c int32 // 하이픈 문자
	tail_append(new_disc())
	if cur_chr == 1 {
		c = hyphen_char[cur_font()]
		if c >= 0 && c < 256 {
			set_pre_break(tail, new_character(cur_font(), c))
		}
	} else {
		save_ptr++; set_saved(-1, 0); new_save_level(disc_group)
		scan_left_brace(); push_nest(); mode = -hmode; set_space_factor(1000)
	}
}

@ 세 선택적 나눔 목록은 어느 정도 가로 상자처럼 만든다. 서브루틴 |build_discretionary|가 전환을 다룬다. (이것은 꽤
재미있다.)

@<|right_brace|가 미루어 둔 동작을...@>=
case disc_group: build_discretionary()

@ @<|main_control|이 쓰는 동작...@>=
func build_discretionary() {
	var p, q pointer // 링크를 다루는 데 쓴다
	var n int32 // 선택적 나눔 목록의 길이
	unsave()
	@<현재 목록에 허락된 노드만 남도록 쳐내고, |n|을 길이로, |q|를 꼬리로 한다@>
	p = link(head); pop_nest()
	switch saved(-1) {
	case 0: set_pre_break(tail, p)
	case 1: set_post_break(tail, p)
	case 2: @<목록 |p|를 현재 목록에 붙이고 그 길이를 기록한 뒤, 마무리하고 |return|한다@>
	} // 다른 경우는 없다
	set_saved(-1, saved(-1)+1); new_save_level(disc_group); scan_left_brace()
	push_nest(); mode = -hmode; set_space_factor(1000)
}

@ @<목록 |p|를 현재 목록에 붙이고...@>=
if n > 0 && abs(mode) == mmode {
	print_err("Illegal math "); print_esc("discretionary")
@.Illegal math \\disc...@>
	help2("Sorry: The third part of a discretionary break must be",
		"empty, in math formulas. I had to delete your third part.")
	flush_node_list(p); n = 0; error()
} else {
	set_link(tail, p)
}
if n <= max_quarterword {
	set_replace_count(tail, n)
} else {
	print_err("Discretionary list is too long")
@.Discretionary list is too long@>
	help2("Wow---I never thought anybody would tweak me here.",
		"You can't seriously need such a huge discretionary list?")
	error()
}
if n > 0 {
	tail = q
}
save_ptr--; return

@ 현재 목록에 |char_node|, |kern_node|, |hlist_node|, |vlist_node|, |rule_node|, |ligature_node| 항목만 남을 때까지 필요하면
쳐낸다. 이 루프가 도는 동안 |p=link(q)|이고 |p| 앞에 항목이 |n|개 있다.

@<현재 목록에 허락된 노드만...@>=
q = head; p = link(q); n = 0
for p != null {
	if !is_char_node(p) && type_(p) > rule_node && type_(p) != kern_node && type_(p) != ligature_node {
		print_err("Improper discretionary list")
@.Improper discretionary list@>
		help1("Discretionary lists must contain only boxes and kerns.")
		error()
		begin_diagnostic()
		print_nl("The following discretionary sublist has been deleted:")
@.The following...deleted@>
		show_box(p)
		end_diagnostic(true)
		flush_node_list(p); set_link(q, null); goto done
	}
	q = p; p = link(q); n++
}
done:

@ 가로 모드 루틴들을 완성하는 데 한 가지만 더 필요하다. 바로 원시 명령 \.{\\accent}다.

@<상자와 목록을 만드는...@>=
case hmode + accent: make_accent()

@ 악센트를 놓는 일은 간단하지만 지루하다. 높이 |x|와 기울기 |s|인 문자를 위해 설계된 너비 |a|의 악센트와, 너비 |w|, 높이 |h|,
기울기 |t|인 문자가 주어졌다고 하자. 악센트를 |x-h|만큼 아래로 옮기고, 악센트를 문자 위의 가운데에 놓으면서 오른쪽으로
$\delta={1\over2}(w-a)+h\cdot t-x\cdot s$만큼 옮기는 효과를 내는 커닝 노드들을 넣는다. 어느 한 문자라도 글꼴에 없으면 옮기지
않고 그냥 다른 것을 쓴다.

@<|main_control|이 쓰는 동작...@>=
func make_accent() {
	var s, t float64 // 기울기의 양
	var p, q, r pointer // 문자, 상자, 커닝 노드
	var f internal_font_number // 관련된 글꼴
	var a, h, x, w, delta scaled // 위에서 설명한 높이와 너비
	var i four_quarters // 문자 정보
	scan_char_num(); f = cur_font(); p = new_character(f, cur_val)
	if p != null {
		x = x_height(f); s = float64(slant(f)) / float_constant(65536)
@^real division@>
		a = char_width(f, char_info(f, character(p)))
		do_assignments()
		@<다음 문자를 위한 문자 노드 |q|를 만들되, 문제가 생기면 |q:=null|로 한다@>
		if q != null {
			@<알맞은 커닝과 함께 악센트를 덧붙이고 |p:=q|로 한다@>
		}
		set_link(tail, p); tail = p; set_space_factor(1000)
	}
}

@ @<다음 문자를 위한 문자 노드...@>=
q = null; f = cur_font()
if cur_cmd == letter || cur_cmd == other_char || cur_cmd == char_given {
	q = new_character(f, cur_chr)
} else if cur_cmd == char_num {
	scan_char_num(); q = new_character(f, cur_val)
} else {
	back_input()
}

@ 여기서 덧붙이는 커닝 노드는 다른 커닝과 구별해야 한다. 그렇지 않으면 하이픈 넣기 알고리즘이나 앞선 줄 나눔이 그것들을 지워
버릴 것이다.

두 커닝은 (기계에 따라 다른) |real| 산술로 계산하지만 그 합은 기계에 따라 다르지 않다. 사용자는 이 노드들을 없앨 수도 없고
\.{\\lastkern}으로 접근할 수도 없으므로, 알짜 효과는 기계에 상관없다.

@<알맞은 커닝과 함께 악센트를...@>=
t = float64(slant(f)) / float_constant(65536)
@^real division@>
i = char_info(f, character(q))
w = char_width(f, i); h = char_height(f, height_depth(i))
if h != x { // 악센트를 위나 아래로 옮겨야 한다
	p = hpack(p, natural, additional); set_shift_amount(p, x-h)
}
delta = round(float64(w-a)/float_constant(2) + float64(h)*t - float64(x)*s)
@^real multiplication@>
@^real addition@>
r = new_kern(delta); set_subtype(r, acc_kern); set_link(tail, r); set_link(r, p)
tail = new_kern(-a - delta); set_subtype(tail, acc_kern); set_link(p, tail); p = q

@ 명령 `\.{\\cr}'나 `\.{\\span}'이나 탭 표시가 훑개를 지나 |main_control|로 오면, 사용자가 어리석게도 정렬과 아무 상관 없는 곳에 그것을
넣었을 수도 있다. 그러나 왼쪽 중괄호나 오른쪽 중괄호를 빠뜨렸을 가능성이 훨씬 크다. 프로시저 |get_next|는 `\.{\\cr}'이나 `\.{\\span}'이나
탭 표시가 |align_state=0|일 때 나타날 때만 정렬에 알맞은 동작을 하기 때문이다. 다음 프로그램은 알맞게 회복하려 한다.

@<상자와 목록을 만드는...@>=
case vmode + car_ret, hmode + car_ret, mmode + car_ret,
	vmode + tab_mark, hmode + tab_mark, mmode + tab_mark:
	align_error()
case vmode + no_align, hmode + no_align, mmode + no_align: no_align_error()
case vmode + omit, hmode + omit, mmode + omit: omit_error()

@ @<|main_control|이 쓰는 동작...@>=
func align_error() {
	if abs(align_state) > 2 {
		@<정렬이 진행 중이지 않다는 사실에 당황을 나타낸다@>
	} else {
		back_input()
		if align_state < 0 {
			print_err("Missing { inserted")
@.Missing \{ inserted@>
			align_state++; cur_tok = left_brace_token + '{'
		} else {
			print_err("Missing } inserted")
@.Missing \} inserted@>
			align_state--; cur_tok = right_brace_token + '}'
		}
		help3("I've put in what seems to be necessary to fix",
			"the current column of the current alignment.",
			"Try to go on, since this might almost work.")
		ins_error()
	}
}

@ @<정렬이 진행 중이지 않다는...@>=
print_err("Misplaced "); print_cmd_chr(cur_cmd, cur_chr)
@.Misplaced \&@>
@.Misplaced \\span@>
@.Misplaced \\cr@>
if cur_tok == tab_token+'&' {
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
error()

@ 여기 도움말 메시지에는 작은 선의의 거짓말이 들어 있다. 명령 \.{\\noalign}과 \.{\\omit}은 `\.{\\noalign\{...\}}' 뒤에도 허락되기
때문이다.

@<|main_control|이 쓰는 동작...@>=
func no_align_error() {
	print_err("Misplaced "); print_esc("noalign")
@.Misplaced \\noalign@>
	help2("I expect to see \\noalign only after the \\cr of",
		"an alignment. Proceed, and I'll ignore this case.")
	error()
}

func omit_error() {
	print_err("Misplaced "); print_esc("omit")
@.Misplaced \\omit@>
	help2("I expect to see \\omit only after tab marks or the \\cr of",
		"an alignment. Proceed, and I'll ignore this case.")
	error()
}

@ 이제 \.{\\halign}과 \.{\\valign}의 남용 대부분을 다루었다. 이것들을 올바르게 쓸 때 무슨 일이 일어나는지 살펴보자.

@<상자와 목록을 만드는...@>=
case vmode + halign, hmode + valign: init_align()
case mmode + halign:
	if privileged() {
		if cur_group == math_shift_group {
			init_align()
		} else {
			off_save()
		}
	}
case vmode + endv, hmode + endv: do_endv()

@ 그룹 코드 |align_group|은 정렬 전체 동안, |fin_align|이 그것을 없앨 때까지 |save_stack|에 남아 있어야 한다.

교활한 사용자는 |endv| 명령이 거의 아무 곳에서나 나타나게 할 수도 있다. 그런 장난은 무찔러야 한다.

@<|main_control|이 쓰는 동작...@>=
func do_endv() {
	base_ptr = input_ptr; input_stack[base_ptr] = cur_input()
	for input_stack[base_ptr].index_field != v_template &&
		input_stack[base_ptr].loc_field == null &&
		input_stack[base_ptr].state_field == token_list {
		base_ptr--
	}
	if input_stack[base_ptr].index_field != v_template ||
		input_stack[base_ptr].loc_field != null ||
		input_stack[base_ptr].state_field != token_list {
		fatal_error("(interwoven alignment preambles are not allowed)")
	}
@.interwoven alignment preambles...@>
	if cur_group == align_group {
		end_graf()
		if fin_col() {
			fin_row()
		}
	} else {
		off_save()
	}
}

@ @<|right_brace|가 미루어 둔 동작을...@>=
case align_group:
	back_input(); cur_tok = cs_token_flag + frozen_cr
	print_err("Missing "); print_esc("cr"); print(" inserted")
@.Missing \\cr inserted@>
	help1("I'm guessing that you meant to end an alignment here.")
	ins_error()

@ @<|right_brace|가 미루어 둔 동작을...@>=
case no_align_group: end_graf(); unsave(); align_peek()

@ 마지막으로 \.{\\endcsname}은 |main_control|까지 와서는 안 된다.

@<상자와 목록을 만드는...@>=
case vmode + end_cs_name, hmode + end_cs_name, mmode + end_cs_name: cs_error()

@ @<|main_control|이 쓰는 동작...@>=
func cs_error() {
	print_err("Extra "); print_esc("endcsname")
@.Extra \\endcsname@>
	help1("I'm ignoring this, since I wasn't doing a \\csname.")
	error()
}

@* 수식 목록 만들기.
\TeX이 수식 목록을 만드는 데 쓰는 루틴들은 방금 본 가로 목록과 세로 목록을 만드는 루틴들과 비슷하다. 그러나 노드(node)만이 아니라
노드(noad)도 만들어야 하므로, 독자는 다음 프로그램을 이해하려 하기 전에 수식 모드 자료 구조에 관한 논의를 다시 보아야 한다.

다음은 하위 수식을 처리하려 할 때마다 해야 하는 작은 루틴이다. 매개변수는 |math_group| 같은 코드다.

@<|main_control|이 쓰는 동작...@>=
func push_math(c group_code) {
	push_nest(); mode = -mmode; set_incompleat_noad(null); new_save_level(c)
}

@ 수식 전환 문자 `\.\$'(곧 |math_shift|)를 훑으면 가로 모드에서 수식 모드로 들어간다. 따로 세운 수식 모드가 필요한 경우에 대비해서, 이
`\.\$' 바로 뒤에 다른 `\.\$'가 오는지 확인해야 한다.

@<상자와 목록을 만드는...@>=
case hmode + math_shift: init_math()

@ @<|main_control|이 쓰는 동작...@>=
func init_math() {
	var w scaled // 새 또는 부분 |pre_display_size|
	var l scaled // 새 |display_width|
	var s scaled // 새 |display_indent|
	var p pointer // |pre_display_size|를 계산할 때 현재 노드
	var q pointer // |pre_display_size|를 계산할 때 글루 명세
	var f internal_font_number // 현재 |char_node|의 글꼴
	var n int32 // 문단 모양 지정의 범위
	var v scaled // |w|에 가능한 글루 양을 더한 것
	var d scaled // |v|의 증분
	get_token() // |get_x_token|은 \.{\\ifmmode}에서 실패할 것이다\thinspace!
	if cur_cmd == math_shift && mode > 0 {
		@<따로 세운 수식 모드로 들어간다@>
	} else {
		back_input(); @<보통 수식 모드로 들어간다@>
	}
}

@ @<보통 수식 모드로...@>=
push_math(math_shift_group); eq_word_define(int_base+cur_fam_code, -1)
if every_math() != null {
	begin_token_list(every_math(), every_math_text)
}

@ 명령 `\.{\\eqno}'나 `\.{\\leqno}'가 나타나면 따로 세운 수식 모드에서 보통 수식 모드로 들어간다. 그런 경우 |cur_chr|는 각각 0이나~1이고,
|cur_chr|의 값은 안전하게 보관하려고 |save_stack|에 놓인다.

@<상자와 목록을 만드는...@>=
case mmode + eq_no:
	if privileged() {
		if cur_group == math_shift_group {
			start_eq_no()
		} else {
			off_save()
		}
	}

@ @<\TeX의 원시 명령을...@>=
primitive("eqno", eq_no, 0)
@!@:eq_no_}{\.{\\eqno} primitive@>
primitive("leqno", eq_no, 1)
@!@:leq_no_}{\.{\\leqno} primitive@>

@ \TeX이 따로 세운 수식 모드에 있을 때는 |cur_group=math_shift_group|이므로, 프로시저 |start_eq_no|가 이 조건을 검사할 필요가
없다.

@<|main_control|이 쓰는 동작...@>=
func start_eq_no() {
	set_saved(0, cur_chr); save_ptr++
	@<보통 수식 모드로...@>
}

@ @<원시 명령의 이름을 찍는...@>=
case eq_no:
	if chr_code == 1 { print_esc("leqno") } else { print_esc("eqno") }

@ @<|main_control|이 금지하는...@>=
vmode + eq_no, hmode + eq_no,

@ 따로 세운 수식 모드에 들어갈 때는, 따로 세운 수식 때문에 방금 끊긴 부분 문단을 처리하려고 |line_break|를 불러야 한다. 그런
다음 |display_width|와 |display_indent|와 |pre_display_size|의 알맞은 값을 정할 수 있다.

@<따로 세운 수식 모드로...@>=
if head == tail { // `\.{\\noindent\$\$}'나 `\.{\$\${ }\$\$}'
	pop_nest(); w = -max_dimen
} else {
	line_break(display_widow_penalty())
	@<마지막 줄의 문자들이 기준점 오른쪽으로 뻗는 자연 너비 |w|를 계산한다@>
}
// 이제 세로 모드에서, 따로 세운 수식을 담을 목록을 다루고 있다
@<따로 세운 수식 줄의 길이 |l|과 옮김 양 |s|를 계산한다@>
push_math(math_shift_group); mode = mmode
eq_word_define(int_base+cur_fam_code, -1)
eq_word_define(dimen_base+pre_display_size_code, w)
eq_word_define(dimen_base+display_width_code, l)
eq_word_define(dimen_base+display_indent_code, s)
if every_display() != null {
	begin_token_list(every_display(), every_display_text)
}
if nest_ptr == 1 {
	build_page()
}

@ 여기에 두 em을 더한다. 그 줄의 빈칸 아닌 정보가 늘이기나 줄이기의 영향을 받으면 |w:=max_dimen|으로 한다.

@<마지막 줄의 문자들이...@>=
v = shift_amount(just_box) + 2*quad(cur_font()); w = -max_dimen
p = list_ptr(just_box)
for p != null {
	@<|d|를 노드 |p|의 자연 너비로 한다@>
	if v < max_dimen {
		v = v + d
	}
	goto not_found
found:
	if v < max_dimen {
		v = v + d; w = v
	} else {
		w = max_dimen; goto done
	}
not_found:
	p = link(p)
}
done: ;

@ 노드가 ``보이는'' 것이면 |goto found|하고, 늘어나거나 줄어드는 글루이면 |v:=max_dimen|으로 한다.

@<|d|를 노드 |p|의 자연 너비로...@>=
reswitch:
	if is_char_node(p) {
		f = font(p); d = char_width(f, char_info(f, character(p)))
		goto found
	}
	switch type_(p) {
	case hlist_node, vlist_node, rule_node: d = width(p); goto found
	case ligature_node: @<노드 |p|를 |char_node|처럼...@>
	case kern_node, math_node: d = width(p)
	case glue_node: @<|d|를 이 글루의 자연 너비로 하고, 늘이거나 줄이면 |v:=max_dimen|으로 한다@>
	case whatsit_node: @<|d|를 whatsit |p|의 너비로 한다@>
	default: d = 0
	}

@ 변수 |w|, |v|, |d|가 |glue_set| 값에 의존하지 않도록 조심해야 한다. 그런 값은 시스템에 따라 다른 반올림을 겪기 때문이다.
\TeX82는 모든 기계에서 같은 결정을 내려야 하므로, 시스템에 따라 다른 수가 |pre_display_size| 같은 매개변수에 스며들어서는 안
된다. 리더이면 |goto found|한다.

@<|d|를 이 글루의 자연 너비로...@>=
q = glue_ptr(p); d = width(q)
if glue_sign(just_box) == stretching {
	if glue_order(just_box) == stretch_order(q) && stretch(q) != 0 {
		v = max_dimen
	}
} else if glue_sign(just_box) == shrinking {
	if glue_order(just_box) == shrink_order(q) && shrink(q) != 0 {
		v = max_dimen
	}
}
if subtype(p) >= a_leaders {
	goto found
}

@ 따로 세운 수식은 세 줄 길이로 여기므로, 줄 번호 |prev_graf+2|의 길이와 오프셋을 계산한다.

@<따로 세운 수식 줄의 길이...@>=
if par_shape_ptr() == null {
	if hang_indent() != 0 &&
		((hang_after() >= 0 && prev_graf+2 > hang_after()) || prev_graf+1 < -hang_after()) {
		l = hsize() - abs(hang_indent())
		if hang_indent() > 0 { s = hang_indent() } else { s = 0 }
	} else {
		l = hsize(); s = 0
	}
} else {
	n = info(par_shape_ptr())
	if prev_graf+2 >= n {
		p = par_shape_ptr() + 2*n
	} else {
		p = par_shape_ptr() + 2*(prev_graf+2)
	}
	s = mem[p-1].sc; l = mem[p].sc
}

@ 수식의 하위 수식은 저장 스택에서만이 아니라 의미 둥지에서도 수식 모드의 새 수준으로 들어가게 한다. 이런 하위 수식은 몇 가지로
생긴다. (1)~왼쪽 중괄호 하나만 있으면 상자에 넣을 하위 수식이 시작된다는 뜻이고, 그래서 그 글루를 얼리고 줄 나눔을 막는다.
(2)~아래첨자나 위첨자는 문자 하나가 아니면 하위 수식으로 다룬다. 명령 \.{\\underline} 같은 것의 핵도 마찬가지다. (3)~원시 명령
\.{\\left}는 짝이 맞는 \.{\\right}로 끝날 하위 수식을 시작한다. 이 세 경우에 |save_stack|에 놓이는 그룹 코드는 각각 |math_group|,
|math_group|, |math_left_group|이다.

다음은 경우 (1)을 다루는 코드다. 다른 경우들은 그렇게 하찮지 않으므로 나중에 생각하겠다.

@<상자와 목록을 만드는...@>=
case mmode + left_brace:
	tail_append(new_noad())
	back_input(); scan_math(nucleus(tail))

@ 노드(noad)의 |nucleus|, |subscr|, |supscr| 필드는 |math_type|과, |info|나 |(fam,character)|라는 하위 필드로 나뉜다는 것을 떠올리자.
프로시저 |scan_math|의 일은 이 주요 필드 가운데 하나에 무엇을 놓을지 알아내는 것이다. 이것은 입력에서 다음에 오는 하위 수식을 보고,
그 하위 수식을 부호화한 값을 |mem|의 주어진 낱말에 놓는다.

@<정의@>=
func fam_in_range() bool { return cur_fam() >= 0 && cur_fam() < 16 }

@ \dg 앞 절의 프로시저 |scan_math|를 옮긴다.

@<|main_control|이 쓰는 동작...@>=
func scan_math(p pointer) {
	var c int32 // 수식 문자 코드
restart:
	@<공백도 relax도 호출도...@>
reswitch:
	switch cur_cmd {
	case letter, other_char, char_given:
		c = ho(math_code(cur_chr))
		if c == 0o100000 {
			@<|cur_chr|를 능동 문자로 다룬다@>
			goto restart
		}
	case char_num:
		scan_char_num(); cur_chr = cur_val; cur_cmd = char_given
		goto reswitch
	case math_char_num: scan_fifteen_bit_int(); c = cur_val
	case math_given: c = cur_chr
	case delim_num: scan_twenty_seven_bit_int(); c = cur_val / 0o10000
	default: @<중괄호로 둘러싼 하위 수식을 훑고 |return|한다@>
	}
	set_math_type(p, math_char); set_character(p, qi(c%256))
	if c >= var_code && fam_in_range() {
		set_fam(p, cur_fam())
	} else {
		set_fam(p, (c/256)%16)
	}
}

@ 여기서는 |outer_call|인 능동 문자도 허락된다.

@<|cur_chr|를 능동 문자로...@>=
cur_cs = cur_chr + active_base
cur_cmd = eq_type(cur_cs); cur_chr = equiv(cur_cs)
x_token(); back_input()

@ 복잡한 하위 수식을 훑는 동안 포인터 |p|를 |save_stack|에 놓는다.

@<중괄호로 둘러싼 하위 수식을...@>=
back_input(); scan_left_brace()
set_saved(0, p); save_ptr++; push_math(math_group); return

@ 가장 간단한 수식은 물론 노드를 하나도 만들지 않는 `\.{\${ }\$}'다. 그 다음으로 간단한 경우는 이를테면 `\.{\$x\$}'처럼 문자 하나를
담은 것이다. 그런 경우가 그리 흥미로워 보이지 않을 수도 있지만, 독자는 아마 `\.{\$x\$}'를 \TeX이 처음으로 제대로 조판했을 때
저자가 얼마나 기뻤는지 이해할 수 있을 것이다. 그때 이 절의 코드가 쓰였다.
@^Knuth, Donald Ervin@>

@<상자와 목록을 만드는...@>=
case mmode + letter, mmode + other_char, mmode + char_given:
	set_math_char(ho(math_code(cur_chr)))
case mmode + char_num:
	scan_char_num(); cur_chr = cur_val
	set_math_char(ho(math_code(cur_chr)))
case mmode + math_char_num: scan_fifteen_bit_int(); set_math_char(cur_val)
case mmode + math_given: set_math_char(cur_chr)
case mmode + delim_num: scan_twenty_seven_bit_int(); set_math_char(cur_val / 0o10000)

@ 프로시저 |set_math_char|는 주어진 수식 코드에 알맞은 새 노드를 만들어서 현재 수식 목록에 덧붙인다. 그러나 수식 코드가 넉넉히
크면 |cur_chr|를 능동 문자로 다루고 아무것도 덧붙이지 않는다.

@<|main_control|이 쓰는 동작...@>=
func set_math_char(c int32) {
	var p pointer // 새 노드
	if c >= 0o100000 {
		@<|cur_chr|를 능동 문자로...@>
	} else {
		p = new_noad(); set_math_type(nucleus(p), math_char)
		set_character(nucleus(p), qi(c%256))
		set_fam(nucleus(p), (c/256)%16)
		if c >= var_code {
			if fam_in_range() {
				set_fam(nucleus(p), cur_fam())
			}
			set_type(p, ord_noad)
		} else {
			set_type(p, ord_noad+(c/0o10000))
		}
		set_link(tail, p); tail = p
	}
}

@ 원시 수식 연산자 \.{\\mathop}과 \.{\\underline} 같은 것에는 명령 코드 |math_comp|를 주고, 그것이 만드는 노드 형을 덧붙인다.

@<\TeX의 원시 명령을...@>=
primitive("mathord", math_comp, ord_noad)
@!@:math_ord_}{\.{\\mathord} primitive@>
primitive("mathop", math_comp, op_noad)
@!@:math_op_}{\.{\\mathop} primitive@>
primitive("mathbin", math_comp, bin_noad)
@!@:math_bin_}{\.{\\mathbin} primitive@>
primitive("mathrel", math_comp, rel_noad)
@!@:math_rel_}{\.{\\mathrel} primitive@>
primitive("mathopen", math_comp, open_noad)
@!@:math_open_}{\.{\\mathopen} primitive@>
primitive("mathclose", math_comp, close_noad)
@!@:math_close_}{\.{\\mathclose} primitive@>
primitive("mathpunct", math_comp, punct_noad)
@!@:math_punct_}{\.{\\mathpunct} primitive@>
primitive("mathinner", math_comp, inner_noad)
@!@:math_inner_}{\.{\\mathinner} primitive@>
primitive("underline", math_comp, under_noad)
@!@:underline_}{\.{\\underline} primitive@>
primitive("overline", math_comp, over_noad)
@!@:overline_}{\.{\\overline} primitive@>
primitive("displaylimits", limit_switch, normal)
@!@:display_limits_}{\.{\\displaylimits} primitive@>
primitive("limits", limit_switch, limits)
@!@:limits_}{\.{\\limits} primitive@>
primitive("nolimits", limit_switch, no_limits)
@!@:no_limits_}{\.{\\nolimits} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case math_comp:
	switch chr_code {
	case ord_noad: print_esc("mathord")
	case op_noad: print_esc("mathop")
	case bin_noad: print_esc("mathbin")
	case rel_noad: print_esc("mathrel")
	case open_noad: print_esc("mathopen")
	case close_noad: print_esc("mathclose")
	case punct_noad: print_esc("mathpunct")
	case inner_noad: print_esc("mathinner")
	case under_noad: print_esc("underline")
	default: print_esc("overline")
	}
case limit_switch:
	if chr_code == limits {
		print_esc("limits")
	} else if chr_code == no_limits {
		print_esc("nolimits")
	} else {
		print_esc("displaylimits")
	}

@ @<상자와 목록을 만드는...@>=
case mmode + math_comp:
	tail_append(new_noad())
	set_type(tail, cur_chr); scan_math(nucleus(tail))
case mmode + limit_switch: math_limit_switch()

@ @<|main_control|이 쓰는 동작...@>=
func math_limit_switch() {
	if head != tail && type_(tail) == op_noad {
		set_subtype(tail, cur_chr); return
	}
	print_err("Limit controls must follow a math operator")
@.Limit controls must follow...@>
	help1("I'm ignoring this misplaced \\limits or \\nolimits command."); error()
}

@ 노드(noad)의 구분자 필드는 루틴 |scan_delimiter|가 채운다. 이 프로시저의 첫 매개변수는 구분자를 놓을 |mem| 주소이고, 둘째는 이
구분자가 \.{\\radical} 뒤에 오는지 알려 준다.

@<|main_control|이 쓰는 동작...@>=
func scan_delimiter(p pointer, r bool) {
	if r {
		scan_twenty_seven_bit_int()
	} else {
		@<공백도 relax도 호출도...@>
		switch cur_cmd {
		case letter, other_char: cur_val = del_code(cur_chr)
		case delim_num: scan_twenty_seven_bit_int()
		default: cur_val = -1
		}
	}
	if cur_val < 0 {
		@<무효한 구분자 코드를 널로 바꾼다고 알리고 |cur_val:=0|으로 한다@>
	}
	set_small_fam(p, (cur_val/0o4000000)%16)
	set_small_char(p, qi((cur_val/0o10000)%256))
	set_large_fam(p, (cur_val/256)%16)
	set_large_char(p, qi(cur_val%256))
}

@ @<무효한 구분자 코드를...@>=
print_err("Missing delimiter (. inserted)")
@.Missing delimiter...@>
help6("I was expecting to see something like `(' or `\\{' or",
	"`\\}' here. If you typed, e.g., `{' instead of `\\{', you",
	"should probably delete the `{' by typing `1' now, so that",
	"braces don't get unbalanced. Otherwise just proceed.",
	"Acceptable delimiters are characters whose \\delcode is",
	"nonnegative, or you can use `\\delimiter <delimiter code>'.")
back_error(); cur_val = 0

@ @<상자와 목록을 만드는...@>=
case mmode + radical: math_radical()

@ @<|main_control|이 쓰는 동작...@>=
func math_radical() {
	tail_append(get_node(radical_noad_size))
	set_type(tail, radical_noad); set_subtype(tail, normal)
	mem[nucleus(tail)].hh = empty_field
	mem[subscr(tail)].hh = empty_field
	mem[supscr(tail)].hh = empty_field
	scan_delimiter(left_delimiter(tail), true); scan_math(nucleus(tail))
}

@ @<상자와 목록을 만드는...@>=
case mmode + accent, mmode + math_accent: math_ac()

@ @<|main_control|이 쓰는 동작...@>=
func math_ac() {
	if cur_cmd == accent {
		@<사용자가 \.{\\mathaccent}라고 했어야 한다고 불평한다@>
	}
	tail_append(get_node(accent_noad_size))
	set_type(tail, accent_noad); set_subtype(tail, normal)
	mem[nucleus(tail)].hh = empty_field
	mem[subscr(tail)].hh = empty_field
	mem[supscr(tail)].hh = empty_field
	set_math_type(accent_chr(tail), math_char)
	scan_fifteen_bit_int()
	set_character(accent_chr(tail), qi(cur_val%256))
	if cur_val >= var_code && fam_in_range() {
		set_fam(accent_chr(tail), cur_fam())
	} else {
		set_fam(accent_chr(tail), (cur_val/256)%16)
	}
	scan_math(nucleus(tail))
}

@ @<사용자가 \.{\\mathaccent}라고...@>=
print_err("Please use "); print_esc("mathaccent")
print(" for accents in math mode")
@.Please use \\mathaccent...@>
help2("I'm changing \\accent to \\mathaccent here; wish me luck.",
	"(Accents are not the same in formulas as they are in text.)")
error()

@ @<상자와 목록을 만드는...@>=
case mmode + vcenter:
	scan_spec(vcenter_group, false); normal_paragraph()
	push_nest(); mode = -vmode; set_prev_depth(ignore_depth)
	if every_vbox() != null {
		begin_token_list(every_vbox(), every_vbox_text)
	}

@ @<|right_brace|가 미루어 둔 동작을...@>=
case vcenter_group:
	end_graf(); unsave(); save_ptr = save_ptr - 2
	p = vpack(link(head), saved(1), saved(0)); pop_nest()
	tail_append(new_noad()); set_type(tail, vcenter_noad)
	set_math_type(nucleus(tail), sub_box); set_info(nucleus(tail), p)

@ 노드 |style_node|를 넣는 루틴에는 놀랄 것이 없다.

@<\TeX의 원시 명령을...@>=
primitive("displaystyle", math_style, display_style)
@!@:display_style_}{\.{\\displaystyle} primitive@>
primitive("textstyle", math_style, text_style)
@!@:text_style_}{\.{\\textstyle} primitive@>
primitive("scriptstyle", math_style, script_style)
@!@:script_style_}{\.{\\scriptstyle} primitive@>
primitive("scriptscriptstyle", math_style, script_script_style)
@!@:script_script_style_}{\.{\\scriptscriptstyle} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case math_style: print_style(chr_code)

@ @<상자와 목록을 만드는...@>=
case mmode + math_style: tail_append(new_style(cur_chr))
case mmode + non_script:
	tail_append(new_glue(zero_glue))
	set_subtype(tail, cond_math_glue)
case mmode + math_choice: append_choices()

@ 명령 \.{\\mathchoice}의 수식 목록 넷을 훑는 루틴은 선택적 나눔 노드를 만드는 루틴과 아주 비슷하다.

@<|main_control|이 쓰는 동작...@>=
func append_choices() {
	tail_append(new_choice()); save_ptr++; set_saved(-1, 0)
	push_math(math_choice_group); scan_left_brace()
}

@ @<|right_brace|가 미루어 둔 동작을...@>=
case math_choice_group: build_choices()

@ @<|main_control|이 쓰는 동작...@>=
@<|fin_mlist|라는 함수를 선언한다@>@;
func build_choices() {
	var p pointer // 현재 수식 목록
	unsave(); p = fin_mlist(null)
	switch saved(-1) {
	case 0: set_display_mlist(tail, p)
	case 1: set_text_mlist(tail, p)
	case 2: set_script_mlist(tail, p)
	case 3: set_script_script_mlist(tail, p); save_ptr--; return
	} // 다른 경우는 없다
	set_saved(-1, saved(-1)+1); push_math(math_choice_group); scan_left_brace()
}

@ 아래첨자와 위첨자는 동작 프로시저 |sub_sup|가 앞의 핵에 붙인다. 여기서는 |sub_mark=sup_mark+1|이고 |subscr(p)=supscr(p)+1|이라는
@^superscripts@>@^subscripts@>
사실을 이용한다.

@<상자와 목록을 만드는...@>=
case mmode + sub_mark, mmode + sup_mark: sub_sup()

@ @<|main_control|이 쓰는 동작...@>=
func sub_sup() {
	var t small_number // 앞 첨자의 형
	var p pointer // |scan_math|가 채울 필드
	t = empty; p = null
	if tail != head && scripts_allowed(tail) {
		p = supscr(tail) + cur_cmd - sup_mark // |supscr|나 |subscr|
		t = math_type(p)
	}
	if p == null || t != empty {
		@<첨자를 붙일 가짜 노드를 넣는다@>
	}
	scan_math(p)
}

@ @<첨자를 붙일 가짜 노드를...@>=
tail_append(new_noad())
p = supscr(tail) + cur_cmd - sup_mark // |supscr|나 |subscr|
if t != empty {
	if cur_cmd == sup_mark {
		print_err("Double superscript")
@.Double superscript@>
		help1("I treat `x^1^2' essentially like `x^1{}^2'.")
	} else {
		print_err("Double subscript")
@.Double subscript@>
		help1("I treat `x_1_2' essentially like `x_1{}_2'.")
	}
	error()
}

@ `\.{\\over}' 같은 연산은 현재 수식 목록을 일시 정지 상태로 만든다. 변수 |incompleat_noad|는 지금까지의 수식 목록을 분자로 담은
|fraction_noad|를 가리키고, 분모는 아직 오지 않았다. 마침내 수식 목록이 끝나면 분모가 미완성 분수 노드에 들어가고, 그 노드는
`\.{\\left}'와 `\.{\\right}' 구분자로 둘러싸이지 않았으면 수식 전체가 된다.

@<정의@>=
const (
	@!above_code = 0 // `\.{\\above}'
	@!over_code = 1 // `\.{\\over}'
	@!atop_code = 2 // `\.{\\atop}'
	@!delimited_code = 3 // `\.{\\abovewithdelims}' 따위
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("above", above, above_code)
@!@:above_}{\.{\\above} primitive@>
primitive("over", above, over_code)
@!@:over_}{\.{\\over} primitive@>
primitive("atop", above, atop_code)
@!@:atop_}{\.{\\atop} primitive@>
primitive("abovewithdelims", above, delimited_code+above_code)
@!@:above_with_delims_}{\.{\\abovewithdelims} primitive@>
primitive("overwithdelims", above, delimited_code+over_code)
@!@:over_with_delims_}{\.{\\overwithdelims} primitive@>
primitive("atopwithdelims", above, delimited_code+atop_code)
@!@:atop_with_delims_}{\.{\\atopwithdelims} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case above:
	switch chr_code {
	case over_code: print_esc("over")
	case atop_code: print_esc("atop")
	case delimited_code + above_code: print_esc("abovewithdelims")
	case delimited_code + over_code: print_esc("overwithdelims")
	case delimited_code + atop_code: print_esc("atopwithdelims")
	default: print_esc("above")
	}

@ @<상자와 목록을 만드는...@>=
case mmode + above: math_fraction()

@ @<|main_control|이 쓰는 동작...@>=
func math_fraction() {
	var c small_number // 훑고 있는 일반화된 분수의 형
	c = cur_chr
	if incompleat_noad() != null {
		@<분수 연산을 무시하고 이 모호한 경우에 대해 불평한다@>
	} else {
		set_incompleat_noad(get_node(fraction_noad_size))
		set_type(incompleat_noad(), fraction_noad)
		set_subtype(incompleat_noad(), normal)
		set_math_type(numerator(incompleat_noad()), sub_mlist)
		set_info(numerator(incompleat_noad()), link(head))
		mem[denominator(incompleat_noad())].hh = empty_field
		mem[left_delimiter(incompleat_noad())].qqqq = null_delimiter
		mem[right_delimiter(incompleat_noad())].qqqq = null_delimiter
		set_link(head, null); tail = head
		@<코드 |c|로 일반화된 분수들을 구별한다@>
	}
}

@ @<코드 |c|로 일반화된...@>=
if c >= delimited_code {
	scan_delimiter(left_delimiter(incompleat_noad()), false)
	scan_delimiter(right_delimiter(incompleat_noad()), false)
}
switch c % delimited_code {
case above_code: scan_normal_dimen(); set_thickness(incompleat_noad(), cur_val)
case over_code: set_thickness(incompleat_noad(), default_code)
case atop_code: set_thickness(incompleat_noad(), 0)
} // 다른 경우는 없다

@ @<분수 연산을 무시하고...@>=
if c >= delimited_code {
	scan_delimiter(garbage, false); scan_delimiter(garbage, false)
}
if c%delimited_code == above_code {
	scan_normal_dimen()
}
print_err("Ambiguous; you need another { and }")
@.Ambiguous...@>
help3("I'm ignoring this fraction specification, since I don't",
	"know whether a construction like `x \\over y \\over z'",
	"means `{x \\over y} \\over z' or `x \\over {y \\over z}'.")
error()

@ 수식이나 하위 수식의 끝에서는 루틴 |fin_mlist|를 불러서 새로 완성된 수식 목록을 가리키는 포인터를 돌려받고, 둥지를 둘러싼 의미
수준으로 되돌린다. 함수 |fin_mlist|의 매개변수는 널이 아니면 현재 수식 목록을 끝내는 |right_noad|를 가리킨다. 이 |right_noad|는 아직
덧붙지 않았다.

@<|fin_mlist|라는...@>=
func fin_mlist(p pointer) pointer {
	var q pointer // 돌려줄 수식 목록
	if incompleat_noad() != null {
		@<미완성 노드를 완성한다@>
	} else {
		set_link(tail, p); q = link(head)
	}
	pop_nest(); return q
}

@ @<미완성 노드를...@>=
set_math_type(denominator(incompleat_noad()), sub_mlist)
set_info(denominator(incompleat_noad()), link(head))
if p == null {
	q = incompleat_noad()
} else {
	q = info(numerator(incompleat_noad()))
	if type_(q) != left_noad {
		confusion("right")
	}
@:this can't happen right}{\quad right@>
	set_info(numerator(incompleat_noad()), link(q))
	set_link(q, incompleat_noad()); set_link(incompleat_noad(), p)
}

@ 이제 마침내 수식 안에서 오른쪽 중괄호가 나타나면 무슨 일이 일어나는지 볼 준비가 되었다. 여기서 두 특별한 경우를 단순하게 한다.
중괄호가 첨자 없는 Ord 하나를 둘러싸거나, Ord 원자의 핵인 악센트를 둘러싸면 중괄호는 사실상 없어진다.

@<|right_brace|가 미루어 둔 동작을...@>=
case math_group:
	unsave(); save_ptr--
	set_math_type(saved(0), sub_mlist); p = fin_mlist(null); set_info(saved(0), p)
	if p != null && link(p) == null {
		if type_(p) == ord_noad {
			if math_type(subscr(p)) == empty && math_type(supscr(p)) == empty {
				mem[saved(0)].hh = mem[nucleus(p)].hh
				free_node(p, noad_size)
			}
		} else if type_(p) == accent_noad && saved(0) == nucleus(tail) && type_(tail) == ord_noad {
			@<목록의 꼬리를 |p|로 바꾼다@>
		}
	}

@ @<목록의 꼬리를 |p|로...@>=
q = head
for link(q) != tail {
	q = link(q)
}
set_link(q, p); free_node(tail, noad_size); tail = p

@ 수식 모드의 구성 가운데 `\.{\\left}'와 `\.{\\right}'만 빼고 모두 다루었다. 그래서 프로그램의 다음 절들이 그림을 완성한다.

@<\TeX의 원시 명령을...@>=
primitive("left", left_right, left_noad)
@!@:left_}{\.{\\left} primitive@>
primitive("right", left_right, right_noad)
@!@:right_}{\.{\\right} primitive@>
set_text(frozen_right, str("right")); eqtb[frozen_right] = eqtb[cur_val]

@ @<원시 명령의 이름을 찍는...@>=
case left_right:
	if chr_code == left_noad { print_esc("left") } else { print_esc("right") }

@ @<상자와 목록을 만드는...@>=
case mmode + left_right: math_left_right()

@ @<|main_control|이 쓰는 동작...@>=
func math_left_right() {
	var t small_number // |left_noad|나 |right_noad|
	var p pointer // 새 노드
	t = cur_chr
	if t == right_noad && cur_group != math_left_group {
		@<짝이 맞지 않는 \.{\\right}에서 회복해 본다@>
	} else {
		p = new_noad(); set_type(p, t)
		scan_delimiter(delimiter(p), false)
		if t == left_noad {
			push_math(math_left_group); set_link(head, p); tail = p
		} else {
			p = fin_mlist(p); unsave() // |math_left_group|의 끝
			tail_append(new_noad()); set_type(tail, inner_noad)
			set_math_type(nucleus(tail), sub_mlist)
			set_info(nucleus(tail), p)
		}
	}
}

@ @<짝이 맞지 않는 \.{\\right}에서...@>=
if cur_group == math_shift_group {
	scan_delimiter(garbage, false)
	print_err("Extra "); print_esc("right")
@.Extra \\right.@>
	help1("I'm ignoring a \\right that had no matching \\left.")
	error()
} else {
	off_save()
}

@ 다음이 수식 모드에서 나가는 유일한 길이다.

@<상자와 목록을 만드는...@>=
case mmode + math_shift:
	if cur_group == math_shift_group { after_math() } else { off_save() }

@ @<|main_control|이 쓰는 동작...@>=
func after_math() {
	var l bool // `\.{\\eqno}' 대신 `\.{\\leqno}'인가
	var danger bool // 기호 글꼴이 넉넉하지 않은가
	var m int32 // |mmode|나 |-mmode|
	var p pointer // 수식
	var a pointer // 수식 번호를 담은 상자
	@<따로 세운 수식을 마무리하는 지역 변수@>@;
	danger = false
	@<수식 기호 글꼴이 갖추어졌는지 확인한다@>
	m = mode; l = false; p = fin_mlist(null) // 이것이 둥지를 꺼낸다
	if mode == -m { // 수식 번호의 끝
		@<\.\$가 하나 더 오는지 확인한다@>
		cur_mlist = p; cur_style = text_style; mlist_penalties = false
		mlist_to_hlist(); a = hpack(link(temp_head), natural, additional)
		unsave(); save_ptr-- // 이제 |cur_group=math_shift_group|이다
		if saved(0) == 1 {
			l = true
		}
		danger = false
		@<수식 기호 글꼴이...@>
		m = mode; p = fin_mlist(null)
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

@ 수식 기호에 필요한 글꼴이 있는지 확인하고, 없으면 현재 수식 목록을 비우고 |danger:=true|로 한다.

@<수식 기호 글꼴이...@>=
if font_params[fam_fnt(2+text_size)] < total_mathsy_params ||
	font_params[fam_fnt(2+script_size)] < total_mathsy_params ||
	font_params[fam_fnt(2+script_script_size)] < total_mathsy_params {
	print_err("Math formula deleted: Insufficient symbol fonts")
@.Math formula deleted...@>
	help3("Sorry, but I can't typeset math unless \\textfont 2",
		"and \\scriptfont 2 and \\scriptscriptfont 2 have all",
		"the \\fontdimen values needed in math symbol fonts.")
	error(); flush_math(); danger = true
} else if font_params[fam_fnt(3+text_size)] < total_mathex_params ||
	font_params[fam_fnt(3+script_size)] < total_mathex_params ||
	font_params[fam_fnt(3+script_script_size)] < total_mathex_params {
	print_err("Math formula deleted: Insufficient extension fonts")
	help3("Sorry, but I can't typeset math unless \\textfont 3",
		"and \\scriptfont 3 and \\scriptscriptfont 3 have all",
		"the \\fontdimen values needed in math extension fonts.")
	error(); flush_math(); danger = true
}

@ 여기서 |unsave|는 다른 모든 일을 한 뒤에 한다. 그래서 `\.{\$...\$}' 안에 `\.{\\mathsurround}'가 나타나면 바로 이 \.\$들의 간격에
영향을 준다. 이것은 `\.{\$\$...\$\$}'의 관례와 들어맞는다. 따로 세운 수식 안의 `\.{\\abovedisplayskip}'이 그 수식 위의 공간에 영향을
주기 때문이다.

@<본문 안의 수식을...@>=
tail_append(new_math(math_surround(), before))
cur_mlist = p; cur_style = text_style; mlist_penalties = mode > 0; mlist_to_hlist()
set_link(tail, link(temp_head))
for link(tail) != null {
	tail = link(tail)
}
tail_append(new_math(math_surround(), after))
set_space_factor(1000); unsave()

@ 따로 세운 수식을 끝내는 첫 `\.\$'를 훑었을 때 \TeX은 프로그램의 다음 부분에 이른다.

@<\.\$가 하나 더 오는지...@>=
get_x_token()
if cur_cmd != math_shift {
	print_err("Display math should end with $$")
@.Display math...with \$\$@>
	help2("The `$' that I just saw supposedly matches a previous `$$'.",
		"So I shall assume that you typed `$$' both times.")
	back_error()
}

@ 가장 까다로운 것을 마지막까지 남겨 두었다. 수식 모드 처리에서 가장 성가신 부분은 따로 세운 수식을 가운데 맞추고 선택적인 수식
번호와 함께 놓을 때 일어난다.

@<따로 세운 수식을 마무리하는 지역...@>=
var b pointer // 수식을 담은 상자
var w scaled // 수식의 너비
var z scaled // 줄의 너비
var e scaled // 수식 번호의 너비
var q scaled // 수식 번호의 너비에 수식과 떼어 놓을 공간을 더한 것
var d scaled // 줄 안에서 수식의 변위
var s scaled // 줄을 이만큼 오른쪽으로 옮긴다
var g1, g2 small_number // 앞뒤의 글루 매개변수 코드
var r pointer // 따로 세운 수식의 자리를 잡는 데 쓰는 커닝 노드
var t pointer // 조정 목록의 꼬리

@ 이때 |p|는 수식의 수식 목록을 가리키고, |a|는 |null|이거나 수식 번호를 담은 상자를 가리키며, 우리는 세로 모드(또는 내부 세로
모드)에 있다.

@<따로 세운 수식을 마무리한다@>=
cur_mlist = p; cur_style = display_style; mlist_penalties = false
mlist_to_hlist(); p = link(temp_head)
adjust_tail = adjust_head; b = hpack(p, natural, additional); p = list_ptr(b)
t = adjust_tail; adjust_tail = null
w = width(b); z = display_width(); s = display_indent()
if a == null || danger {
	e = 0; q = 0
} else {
	e = width(a); q = e + math_quad(text_size)
}
if w+q > z {
	@<수식을 될 수 있는 대로 줄이고, 수식 번호를 따로 한 줄에 놓아야 하면 |e:=0|으로 한다@>
}
@<줄 크기 |z|에 대한 수식 왼쪽 끝의 변위 |d|를 정한다@>
@<따로 세운 수식 앞의 글루나 수식 번호를 덧붙인다@>
@<따로 세운 수식과, 어쩌면 수식 번호도 덧붙인다@>
@<따로 세운 수식 뒤의 글루나 수식 번호를 덧붙인다@>
resume_after_display()

@ @<|main_control|이 쓰는 동작...@>=
func resume_after_display() {
	if cur_group != math_shift_group {
		confusion("display")
	}
@:this can't happen display}{\quad display@>
	unsave(); prev_graf = prev_graf + 3
	push_nest(); mode = hmode; set_space_factor(1000); set_cur_lang(); set_clang(cur_lang)
	prev_graf = (norm_min(left_hyphen_min())*0o100+norm_min(right_hyphen_min()))*0o200000 + cur_lang
	@<선택적인 공백 하나를 훑는다@>
	if nest_ptr == 1 {
		build_page()
	}
}

@ 사용자는 수식 번호의 너비를 0으로 만들어서 수식 번호를 따로 한 줄에 놓게 할 수 있다.

@<수식을 될 수 있는 대로...@>=
if e != 0 && (w-total_shrink[normal]+q <= z || total_shrink[fil] != 0 ||
	total_shrink[fill] != 0 || total_shrink[filll] != 0) {
	free_node(b, box_node_size)
	b = hpack(p, z-q, exactly)
} else {
	e = 0
	if w > z {
		free_node(b, box_node_size)
		b = hpack(p, z, exactly)
	}
}
w = width(b)

@ 먼저 수식 번호가 있는지 상관하지 않고 따로 세운 수식을 가운데 맞추어 본다. 그렇게 해서 수식과 번호가 너무 가까워지면(``너무 가깝다''는 것은
따로 세운 수식과 수식 번호 사이의 공간이 수식 번호의 너비보다 작다는 뜻이다), 남은 공간의 가운데에 놓거나 수식 번호에서 될 수
있는 대로 멀리 옮긴다. 뒤의 것은 따로 세운 수식이 글루로 시작할 때만 택한다. 사용자가 간격을 정확히 다스리려고 거기 글루를
넣었다고 가정하기 때문이다. 이 계산은 |l=false|라고 가정한다.

@<줄 크기 |z|에 대한...@>=
d = half(z - w)
if e > 0 && d < 2*e { // 너무 가깝다
	d = half(z - w - e)
	if p != null && !is_char_node(p) && type_(p) == glue_node {
		d = 0
	}
}

@ 수식 번호를 수식 앞이나 뒤에 따로 한 줄로 놓으면, 쪽 나눔이 따로 세운 수식과 그 번호를 떼어 놓지 않도록 무한 벌점을 덧붙인다.
그리고 `\.{\\parshape}'가 다르게 지정하더라도, 따로 세운 수식의 잠재적인 세 줄 모두에 같은 크기와 변위를 쓴다.

@<따로 세운 수식 앞의...@>=
tail_append(new_penalty(pre_display_penalty()))
if d+s <= pre_display_size() || l { // 틈이 넉넉하지 않다
	g1 = above_display_skip_code; g2 = below_display_skip_code
} else {
	g1 = above_display_short_skip_code
	g2 = below_display_short_skip_code
}
if l && e == 0 { // 이로부터 |type(a)=hlist_node|이다
	set_shift_amount(a, s); append_to_vlist(a)
	tail_append(new_penalty(inf_penalty))
} else {
	tail_append(new_param_glue(g1))
}

@ @<따로 세운 수식과, 어쩌면...@>=
if e != 0 {
	r = new_kern(z - w - e - d)
	if l {
		set_link(a, r); set_link(r, b); b = a; d = 0
	} else {
		set_link(b, r); set_link(r, a)
	}
	b = hpack(b, natural, additional)
}
set_shift_amount(b, s+d); append_to_vlist(b)

@ @<따로 세운 수식 뒤의...@>=
if a != null && e == 0 && !l {
	tail_append(new_penalty(inf_penalty))
	set_shift_amount(a, s+z-width(a))
	append_to_vlist(a)
	g2 = 0
}
if t != adjust_head { // 옮겨 가는 내용은 수식 번호 뒤에 온다
	set_link(tail, link(adjust_head)); tail = t
}
tail_append(new_penalty(post_display_penalty()))
if g2 > 0 {
	tail_append(new_param_glue(g2))
}

@ 따로 세운 수식 안에 \.{\\halign}이 나타나면, 정렬 루틴은 본질적으로 세로 모드에서처럼 작동한다. 그런 다음 다음 프로그램이
작동하는데, |p|와 |q|는 결과 목록의 처음과 끝을 가리키고, |aux_save|는 |prev_depth| 값을 담고 있다.

@<따로 세운 수식 안의 정렬을...@>=
do_assignments()
if cur_cmd != math_shift {
	@<따로 세운 수식 안의 부적절한 정렬에 대해 훈계한다@>
} else {
	@<\.\$가 하나 더 오는지...@>
}
pop_nest()
tail_append(new_penalty(pre_display_penalty()))
tail_append(new_param_glue(above_display_skip_code))
set_link(tail, p)
if p != null {
	tail = q
}
tail_append(new_penalty(post_display_penalty()))
tail_append(new_param_glue(below_display_skip_code))
set_prev_depth(aux_save.sc); resume_after_display()

@ @<따로 세운 수식 안의 부적절한 정렬에...@>=
print_err("Missing $$ inserted")
@.Missing {\$\$} inserted@>
help2("Displays can use special alignments (like \\eqalignno)",
	"only if nothing but the alignment itself is between $$'s.")
back_error()

@* 모드에 상관없는 처리.
긴 프로시저 |main_control|은 이제 현재 모드와 상관없는 몇몇 활동만 빼고 모두 정해졌다. 이 활동들은 현재 세로 목록이나 가로
목록이나 수식 목록을 바꾸지 않는다. 무엇을 바꾼다면 매개변수의 값이나 제어 시퀀스의 뜻이다.

표 |eqtb|의 값에 대한 대입은 전역일 수도 지역일 수도 있다. 게다가 제어 시퀀스를 `\.{\\long}'이나 `\.{\\outer}'로 정의할 수도 있고,
펼칠 수도 펼치지 않을 수도 있다. 접두어 `\.{\\global}', `\.{\\long}', `\.{\\outer}'는 어떤 차례로든 나타날 수 있다. 그래서 이진
수 코드를 배정해서, 대응하는 코드를 더하는 것으로 지정된 모든 접두어의 합집합을 쌓을 수 있게 한다. (\PASCAL의 |set| 연산을
쓸 수도 있었을 것이다.)

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

@ @<원시 명령의 이름을 찍는...@>=
case prefix:
	if chr_code == 1 {
		print_esc("long")
	} else if chr_code == 2 {
		print_esc("outer")
	} else {
		print_esc("global")
	}
case def:
	if chr_code == 0 {
		print_esc("def")
	} else if chr_code == 1 {
		print_esc("gdef")
	} else if chr_code == 2 {
		print_esc("edef")
	} else {
		print_esc("xdef")
	}

@ 모든 접두어, 그리고 접두어가 붙을 수도 붙지 않을 수도 있는 모든 명령 코드는 동작 프로시저 |prefixed_command|를 부른다. 이
루틴은 접두어 아닌 것에 이를 때까지 접두어 나열을 쌓은 다음 그 명령을 수행한다.

@<|mode|에 상관없는...@>=
case vmode + toks_register, hmode + toks_register, mmode + toks_register,
	vmode + assign_toks, hmode + assign_toks, mmode + assign_toks,
	vmode + assign_int, hmode + assign_int, mmode + assign_int,
	vmode + assign_dimen, hmode + assign_dimen, mmode + assign_dimen,
	vmode + assign_glue, hmode + assign_glue, mmode + assign_glue,
	vmode + assign_mu_glue, hmode + assign_mu_glue, mmode + assign_mu_glue,
	vmode + assign_font_dimen, hmode + assign_font_dimen, mmode + assign_font_dimen,
	vmode + assign_font_int, hmode + assign_font_int, mmode + assign_font_int,
	vmode + set_aux, hmode + set_aux, mmode + set_aux,
	vmode + set_prev_graf, hmode + set_prev_graf, mmode + set_prev_graf,
	vmode + set_page_dimen, hmode + set_page_dimen, mmode + set_page_dimen,
	vmode + set_page_int, hmode + set_page_int, mmode + set_page_int,
	vmode + set_box_dimen, hmode + set_box_dimen, mmode + set_box_dimen,
	vmode + set_shape, hmode + set_shape, mmode + set_shape,
	vmode + def_code, hmode + def_code, mmode + def_code,
	vmode + def_family, hmode + def_family, mmode + def_family,
	vmode + set_font, hmode + set_font, mmode + set_font,
	vmode + def_font, hmode + def_font, mmode + def_font,
	vmode + register, hmode + register, mmode + register,
	vmode + advance, hmode + advance, mmode + advance,
	vmode + multiply, hmode + multiply, mmode + multiply,
	vmode + divide, hmode + divide, mmode + divide,
	vmode + prefix, hmode + prefix, mmode + prefix,
	vmode + let, hmode + let, mmode + let,
	vmode + shorthand_def, hmode + shorthand_def, mmode + shorthand_def,
	vmode + read_to_cs, hmode + read_to_cs, mmode + read_to_cs,
	vmode + def, hmode + def, mmode + def,
	vmode + set_box, hmode + set_box, mmode + set_box,
	vmode + hyph_data, hmode + hyph_data, mmode + hyph_data,
	vmode + set_interaction, hmode + set_interaction, mmode + set_interaction:
	prefixed_command()

@ 사용자가 이를테면 `\.{\\global\\global}'이라고 하면 그 중복은 조용히 받아들인다.

@<|main_control|이 쓰는 동작...@>=
@<|prefixed_command|의 하위 프로시저들@>@;
func prefixed_command() {
	var a small_number // 지금까지 쌓은 접두어 코드
	var f internal_font_number // 글꼴을 가리킨다
	var j halfword // \.{\\parshape} 지정의 첨자
	var k font_index // |font_info|의 첨자
	var p, q pointer // 잠깐 쓰는 변수
	var n int32 // 마찬가지
	var e bool // 정의를 펼쳐야 하는가? 또는 \.{\\let}을 하지 않았는가?
	a = 0
	for cur_cmd == prefix {
		if !odd(a / cur_chr) {
			a = a + cur_chr
		}
		@<공백도 relax도 호출도...@>
		if cur_cmd <= max_non_prefixed_command {
			@<잘못된 접두어를 버리고 |return|한다@>
		}
	}
	@<쓸모없으면 접두어 \.{\\long}과 \.{\\outer}를 버린다@>
	@<\.{\\globaldefs} 설정에 맞춘다@>
	switch cur_cmd {
	@<대입들@>
	default: confusion("prefix")
@:this can't happen prefix}{\quad prefix@>
	}
done:
	@<\.{\\afterassignment}가 저장한 토큰이 있으면 끼워 넣는다@>
}

@ @<잘못된 접두어를...@>=
print_err("You can't use a prefix with `")
@.You can't use a prefix with x@>
print_cmd_chr(cur_cmd, cur_chr); print_char('\'')
help1("I'll pretend you didn't say \\long or \\outer or \\global.")
back_error(); return

@ @<쓸모없으면 접두어...@>=
if cur_cmd != def && a%4 != 0 {
	print_err("You can't use `"); print_esc("long"); print("' or `")
	print_esc("outer"); print("' with `")
@.You can't use \\long...@>
	print_cmd_chr(cur_cmd, cur_chr); print_char('\'')
	help1("I'll pretend you didn't say \\long or \\outer here.")
	error()
}

@ 앞 루틴은 |a mod 4=0|이 되도록 |a|를 맞출 필요가 없다. 다음 루틴들은 \.{\\global} 접두어를 다음과 같이 검사하기 때문이다.

보충: 원본의 매크로 |global|, |define(#)|, |word_define(#)|은 호출하는 쪽의 지역 변수(또는 매개변수) |a|를 쓴다. 이 매크로들은
|prefixed_command|와 |do_register_command|에서 쓰이므로, 이 번역에서는 |a|를 첫 인자로 받는 함수로 옮긴다.

@<정의@>=
func global(a small_number) bool { return a >= 4 }

func define(a small_number, p pointer, t quarterword, e halfword) {
	if global(a) { geq_define(p, t, e) } else { eq_define(p, t, e) }
}

func word_define(a small_number, p pointer, w int32) {
	if global(a) { geq_word_define(p, w) } else { eq_word_define(p, w) }
}

@ \dg 앞 절의 코드부를 옮긴다.

@<\.{\\globaldefs} 설정에...@>=
if global_defs() != 0 {
	if global_defs() < 0 {
		if global(a) {
			a = a - 4
		}
	} else {
		if !global(a) {
			a = a + 4
		}
	}
}

@ 명령 \.{\\def}나 \.{\\let} 같은 것으로 제어 시퀀스를 정의할 때, 루틴 |get_r_token|은 다시 정의할 수 없는 토큰 대신 특별한 제어
시퀀스를 넣는다.

@<|prefixed_command|의 하위...@>=
func get_r_token() {
restart:
	for {
		get_token()
		if cur_tok != space_token {
			break
		}
	}
	if cur_cs == 0 || cur_cs > frozen_control_sequence {
		print_err("Missing control sequence inserted")
@.Missing control...@>
		help5("Please don't say `\\def cs{...}', say `\\def\\cs{...}'.",
			"I've inserted an inaccessible control sequence so that your",
			"definition will be completed without mixing me up too badly.",
			"You can recover graciously from this error, if you're",
			"careful; see exercise 27.2 in The TeXbook.")
@:TeXbook}{\sl The \TeX book@>
		if cur_cs == 0 {
			back_input()
		}
		cur_tok = cs_token_flag + frozen_protection; ins_error(); goto restart
	}
}

@ @<표의 항목들을 초기화한다...@>=
set_text(frozen_protection, str("inaccessible"))
@.inaccessible@>

@ 다음은 뒤따르는 루틴 다수가 작동하는 방식의 한 보기다. (불행히도 모두 이렇게 단순하지는 않다.)

@<대입들@>=
case set_font: define(a, cur_font_loc, data, cur_chr)

@ 명령 |def|를 훑었을 때, 정의가 전역이어야 하면 |cur_chr|는 홀수이고, 정의를 펼쳐야 하면 |cur_chr>=2|이다.

@<대입들@>=
case def:
	if odd(cur_chr) && !global(a) && global_defs() >= 0 {
		a = a + 4
	}
	e = cur_chr >= 2; get_r_token(); p = cur_cs
	q = scan_toks(true, e); define(a, p, call+(a%4), def_ref)

@ 명령 \.{\\let}과 \.{\\futurelet}은 명령 코드 |let|을 함께 쓴다.

@<\TeX의 원시 명령을...@>=
primitive("let", let, normal)
@!@:let_}{\.{\\let} primitive@>
primitive("futurelet", let, normal+1)
@!@:future_let_}{\.{\\futurelet} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case let:
	if chr_code != normal { print_esc("futurelet") } else { print_esc("let") }

@ @<대입들@>=
case let:
	n = cur_chr
	get_r_token(); p = cur_cs
	if n == normal {
		for {
			get_token()
			if cur_cmd != spacer {
				break
			}
		}
		if cur_tok == other_token+'=' {
			get_token()
			if cur_cmd == spacer {
				get_token()
			}
		}
	} else {
		get_token(); q = cur_tok; get_token(); back_input()
		cur_tok = q; back_input() // 앞을 내다본 다음 뒤로 물러선다
	} // |back_input|은 |cur_cmd|, |cur_chr|에 영향을 주지 않는다는 것에 주의하라
	if cur_cmd >= call {
		add_token_ref(cur_chr)
	}
	define(a, p, cur_cmd, cur_chr)

@ 명령 \.{\\chardef}는 |cmd|가 |char_given|인 제어 시퀀스를 만들고, \.{\\mathchardef}는 |cmd|가 |math_given|인 제어 시퀀스를 만든다.
대응하는 |chr|는 문자 코드나 수식 코드다. 그리고 \.{\\countdef}나 \.{\\dimendef}나 \.{\\skipdef}나 \.{\\muskipdef}는 |cmd|가
|assign_int|나 \dots\ |assign_mu_glue|인 제어 시퀀스를 만들고, 대응하는 |chr|는 해당 내부 레지스터의 |eqtb| 위치다.

@<정의@>=
const (
	@!char_def_code = 0 // \.{\\chardef}의 |shorthand_def|
	@!math_char_def_code = 1 // \.{\\mathchardef}의 |shorthand_def|
	@!count_def_code = 2 // \.{\\countdef}의 |shorthand_def|
	@!dimen_def_code = 3 // \.{\\dimendef}의 |shorthand_def|
	@!skip_def_code = 4 // \.{\\skipdef}의 |shorthand_def|
	@!mu_skip_def_code = 5 // \.{\\muskipdef}의 |shorthand_def|
	@!toks_def_code = 6 // \.{\\toksdef}의 |shorthand_def|
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("chardef", shorthand_def, char_def_code)
@!@:char_def_}{\.{\\chardef} primitive@>
primitive("mathchardef", shorthand_def, math_char_def_code)
@!@:math_char_def_}{\.{\\mathchardef} primitive@>
primitive("countdef", shorthand_def, count_def_code)
@!@:count_def_}{\.{\\countdef} primitive@>
primitive("dimendef", shorthand_def, dimen_def_code)
@!@:dimen_def_}{\.{\\dimendef} primitive@>
primitive("skipdef", shorthand_def, skip_def_code)
@!@:skip_def_}{\.{\\skipdef} primitive@>
primitive("muskipdef", shorthand_def, mu_skip_def_code)
@!@:mu_skip_def_}{\.{\\muskipdef} primitive@>
primitive("toksdef", shorthand_def, toks_def_code)
@!@:toks_def_}{\.{\\toksdef} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case shorthand_def:
	switch chr_code {
	case char_def_code: print_esc("chardef")
	case math_char_def_code: print_esc("mathchardef")
	case count_def_code: print_esc("countdef")
	case dimen_def_code: print_esc("dimendef")
	case skip_def_code: print_esc("skipdef")
	case mu_skip_def_code: print_esc("muskipdef")
	default: print_esc("toksdef")
	}
case char_given: print_esc("char"); print_hex(chr_code)
case math_given: print_esc("mathchar"); print_hex(chr_code)

@ 잠시 |p|를 |relax|로 정의해서, 정의를 훑는 동안 |p|가 나타나면 ``정의되지 않은 제어 시퀀스'' 오류를 내거나 이전 뜻을 펼치는
대신 그냥 훑기를 멈추게 한다. 이렇게 하면 이를테면 `\.{\\chardef\\foo=123\\foo}'가 가능하다.

@<대입들@>=
case shorthand_def:
	n = cur_chr; get_r_token(); p = cur_cs; define(a, p, relax, 256)
	scan_optional_equals()
	switch n {
	case char_def_code: scan_char_num(); define(a, p, char_given, cur_val)
	case math_char_def_code: scan_fifteen_bit_int(); define(a, p, math_given, cur_val)
	default:
		scan_eight_bit_int()
		switch n {
		case count_def_code: define(a, p, assign_int, count_base+cur_val)
		case dimen_def_code: define(a, p, assign_dimen, scaled_base+cur_val)
		case skip_def_code: define(a, p, assign_glue, skip_base+cur_val)
		case mu_skip_def_code: define(a, p, assign_mu_glue, mu_skip_base+cur_val)
		case toks_def_code: define(a, p, assign_toks, toks_base+cur_val)
		} // 다른 경우는 없다
	}

@ @<대입들@>=
case read_to_cs:
	scan_int(); n = cur_val
	if !scan_keyword("to") {
@.to@>
		print_err("Missing `to' inserted")
@.Missing `to'...@>
		help2("You should have said `\\read<number> to \\cs'.",
			"I'm going to look for the \\cs now.")
		error()
	}
	get_r_token()
	p = cur_cs; read_toks(n, p); define(a, p, call, cur_val)

@ 토큰 목록 매개변수 \.{\\output}과 \.{\\everypar} 따위는 다음 방식으로 값을 받는다. (안전을 위해 \.{\\output} 목록은 중괄호
한 쌍으로 둘러싼다.)

@<대입들@>=
case toks_register, assign_toks:
	q = cur_cs
	if cur_cmd == toks_register {
		scan_eight_bit_int(); p = toks_base + cur_val
	} else {
		p = cur_chr // |p=every_par_loc|이나 |output_routine_loc|이나 \dots
	}
	scan_optional_equals()
	@<공백도 relax도 호출도...@>
	if cur_cmd != left_brace {
		@<오른쪽 변이 토큰 매개변수나 토큰 레지스터이면 대입을 마치고 |goto done|@>
	}
	back_input(); cur_cs = q; q = scan_toks(false, false)
	if link(def_ref) == null { // 빈 목록: 기본값으로 돌아간다
		define(a, p, undefined_cs, null); free_avail(def_ref)
	} else {
		if p == output_routine_loc { // 중괄호로 둘러싼다
			set_link(q, get_avail()); q = link(q)
			set_info(q, right_brace_token+'}')
			q = get_avail(); set_info(q, left_brace_token+'{')
			set_link(q, link(def_ref)); set_link(def_ref, q)
		}
		define(a, p, call, def_ref)
	}

@ @<오른쪽 변이 토큰 매개변수나...@>=
if cur_cmd == toks_register {
	scan_eight_bit_int(); cur_cmd = assign_toks; cur_chr = toks_base + cur_val
}
if cur_cmd == assign_toks {
	q = equiv(cur_chr)
	if q == null {
		define(a, p, undefined_cs, null)
	} else {
		add_token_ref(q); define(a, p, call, q)
	}
	goto done
}

@ 수치 매개변수에 값을 대입하는 데도 비슷한 루틴을 쓴다.

@<대입들@>=
case assign_int:
	p = cur_chr; scan_optional_equals(); scan_int()
	word_define(a, p, cur_val)
case assign_dimen:
	p = cur_chr; scan_optional_equals()
	scan_normal_dimen(); word_define(a, p, cur_val)
case assign_glue, assign_mu_glue:
	p = cur_chr; n = cur_cmd; scan_optional_equals()
	if n == assign_mu_glue { scan_glue(mu_val) } else { scan_glue(glue_val) }
	trap_zero_glue()
	define(a, p, glue_ref, cur_val)

@ 글루 레지스터나 매개변수가 0이 되면 다음 프로시저 때문에 늘 |zero_glue|를 가리키게 된다. (예외: 서문을 훑는 동안에는 tabskip
글루를 가로채지 않는다.)

@<|prefixed_command|의 하위...@>=
func trap_zero_glue() {
	if width(cur_val) == 0 && stretch(cur_val) == 0 && shrink(cur_val) == 0 {
		add_glue_ref(zero_glue)
		delete_glue_ref(cur_val); cur_val = zero_glue
	}
}

@ 여러 문자 코드 표는 |def_code| 명령으로 바뀌고, 글꼴 가족은 |def_family|로 선언된다.

@<\TeX의 원시 명령을...@>=
primitive("catcode", def_code, cat_code_base)
@!@:cat_code_}{\.{\\catcode} primitive@>
primitive("mathcode", def_code, math_code_base)
@!@:math_code_}{\.{\\mathcode} primitive@>
primitive("lccode", def_code, lc_code_base)
@!@:lc_code_}{\.{\\lccode} primitive@>
primitive("uccode", def_code, uc_code_base)
@!@:uc_code_}{\.{\\uccode} primitive@>
primitive("sfcode", def_code, sf_code_base)
@!@:sf_code_}{\.{\\sfcode} primitive@>
primitive("delcode", def_code, del_code_base)
@!@:del_code_}{\.{\\delcode} primitive@>
primitive("textfont", def_family, math_font_base)
@!@:text_font_}{\.{\\textfont} primitive@>
primitive("scriptfont", def_family, math_font_base+script_size)
@!@:script_font_}{\.{\\scriptfont} primitive@>
primitive("scriptscriptfont", def_family, math_font_base+script_script_size)
@!@:script_script_font_}{\.{\\scriptscriptfont} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case def_code:
	if chr_code == cat_code_base {
		print_esc("catcode")
	} else if chr_code == math_code_base {
		print_esc("mathcode")
	} else if chr_code == lc_code_base {
		print_esc("lccode")
	} else if chr_code == uc_code_base {
		print_esc("uccode")
	} else if chr_code == sf_code_base {
		print_esc("sfcode")
	} else {
		print_esc("delcode")
	}
case def_family: print_size(chr_code - math_font_base)

@ 코드 값의 종류마다 합법적인 범위가 다르다. 다음 프로그램은 각 경우를 조심스럽게 검사한다.

@<대입들@>=
case def_code:
	@<|cur_chr|에 따라 |n|을 가장 큰 합법적인 코드 값으로 한다@>
	p = cur_chr; scan_char_num(); p = p + cur_val; scan_optional_equals()
	scan_int()
	if (cur_val < 0 && p < del_code_base) || cur_val > n {
		print_err("Invalid code ("); print_int(cur_val)
@.Invalid code@>
		if p < del_code_base {
			print("), should be in the range 0..")
		} else {
			print("), should be at most ")
		}
		print_int(n)
		help1("I'm going to use 0 instead of that illegal code value.")
		error(); cur_val = 0
	}
	if p < math_code_base {
		define(a, p, data, cur_val)
	} else if p < del_code_base {
		define(a, p, data, hi(cur_val))
	} else {
		word_define(a, p, cur_val)
	}

@ @<|cur_chr|에 따라 |n|을...@>=
if cur_chr == cat_code_base {
	n = max_char_code
} else if cur_chr == math_code_base {
	n = 0o100000
} else if cur_chr == sf_code_base {
	n = 0o77777
} else if cur_chr == del_code_base {
	n = 0o77777777
} else {
	n = 255
}

@ @<대입들@>=
case def_family:
	p = cur_chr; scan_four_bit_int(); p = p + cur_val
	scan_optional_equals(); scan_font_ident(); define(a, p, data, cur_val)

@ 다음으로 \TeX의 수치 레지스터를 바꾸는 것을 생각하자.

@<대입들@>=
case register, advance, multiply, divide: do_register_command(a)

@ 여기서는 |register<advance<multiply<divide|라는 사실을 이용한다.

@<|prefixed_command|의 하위...@>=
func do_register_command(a small_number) {
	var l, q, r, s pointer // 목록을 다루는 데 쓴다
	var p int32 // 관련된 레지스터의 형; |int_val..mu_val|
	q = cur_cmd
	@<레지스터 위치 |l|과 그 형 |p|를 계산하되, 무효하면 |return|한다@>
	if q == register {
		scan_optional_equals()
	} else if scan_keyword("by") {
		// 선택적인 `\.{by}'
	}
@.by@>
	arith_error = false
	if q < multiply {
		@<|register|나 |advance|의 결과를 계산해 |cur_val|에 넣는다@>
	} else {
		@<|multiply|나 |divide|의 결과를 계산해 |cur_val|에 넣는다@>
	}
	if arith_error {
		print_err("Arithmetic overflow")
@.Arithmetic overflow@>
		help2("I can't carry out that multiplication or division,",
			"since the result is out of range.")
		if p >= glue_val {
			delete_glue_ref(cur_val)
		}
		error(); return
	}
	if p < glue_val {
		word_define(a, l, cur_val)
	} else {
		trap_zero_glue(); define(a, l, glue_ref, cur_val)
	}
}

@ 여기서는 연속된 코드 |int_val..mu_val|과 |assign_int..assign_mu_glue|가 서로 잘 대응한다는 사실을 이용한다.

@<레지스터 위치 |l|과 그 형 |p|를...@>=
if q != register {
	get_x_token()
	if cur_cmd >= assign_int && cur_cmd <= assign_mu_glue {
		l = cur_chr; p = cur_cmd - assign_int; goto found
	}
	if cur_cmd != register {
		print_err("You can't use `"); print_cmd_chr(cur_cmd, cur_chr)
@.You can't use x after ...@>
		print("' after "); print_cmd_chr(q, 0)
		help1("I'm forgetting what you said and not changing anything.")
		error(); return
	}
}
p = cur_chr; scan_eight_bit_int()
switch p {
case int_val: l = cur_val + count_base
case dimen_val: l = cur_val + scaled_base
case glue_val: l = cur_val + skip_base
case mu_val: l = cur_val + mu_skip_base
} // 다른 경우는 없다
found:

@ @<|register|나 |advance|의 결과를...@>=
if p < glue_val {
	if p == int_val { scan_int() } else { scan_normal_dimen() }
	if q == advance {
		cur_val = cur_val + eqtb[l].sc
	}
} else {
	scan_glue(p)
	if q == advance {
		@<두 글루 명세의 합을 계산한다@>
	}
}

@ @<두 글루 명세의 합을...@>=
q = new_spec(cur_val); r = equiv(l)
delete_glue_ref(cur_val)
set_width(q, width(q)+width(r))
if stretch(q) == 0 {
	set_stretch_order(q, normal)
}
if stretch_order(q) == stretch_order(r) {
	set_stretch(q, stretch(q)+stretch(r))
} else if stretch_order(q) < stretch_order(r) && stretch(r) != 0 {
	set_stretch(q, stretch(r)); set_stretch_order(q, stretch_order(r))
}
if shrink(q) == 0 {
	set_shrink_order(q, normal)
}
if shrink_order(q) == shrink_order(r) {
	set_shrink(q, shrink(q)+shrink(r))
} else if shrink_order(q) < shrink_order(r) && shrink(r) != 0 {
	set_shrink(q, shrink(r)); set_shrink_order(q, shrink_order(r))
}
cur_val = q

@ @<|multiply|나 |divide|의 결과를...@>=
scan_int()
if p < glue_val {
	if q == multiply {
		if p == int_val {
			cur_val = mult_integers(eqtb[l].sc, cur_val)
		} else {
			cur_val = nx_plus_y(eqtb[l].sc, cur_val, 0)
		}
	} else {
		cur_val = x_over_n(eqtb[l].sc, cur_val)
	}
} else {
	s = equiv(l); r = new_spec(s)
	if q == multiply {
		set_width(r, nx_plus_y(width(s), cur_val, 0))
		set_stretch(r, nx_plus_y(stretch(s), cur_val, 0))
		set_shrink(r, nx_plus_y(shrink(s), cur_val, 0))
	} else {
		set_width(r, x_over_n(width(s), cur_val))
		set_stretch(r, x_over_n(stretch(s), cur_val))
		set_shrink(r, x_over_n(shrink(s), cur_val))
	}
	cur_val = r
}

@ 상자의 처리는 조금 다르다. 옛 상자의 값을 실제로 바꾸기 전에 상자 전체를 훑고 만들어야 할 수도 있기 때문이다.

@<대입들@>=
case set_box:
	scan_eight_bit_int()
	if global(a) { n = 256 + cur_val } else { n = cur_val }
	scan_optional_equals()
	if set_box_allowed {
		scan_box(box_flag + n)
	} else {
		print_err("Improper "); print_esc("setbox")
@.Improper \\setbox@>
		help2("Sorry, \\setbox is not allowed after \\halign in a display,",
			"or between \\accent and an accented character.")
		error()
	}

@ 명령 |set_aux|를 감지하면 |space_factor|나 |prev_depth| 설정이 바뀐다. 마찬가지로 |set_prev_graf|가 있으면 |prev_graf|가 바뀌고,
|set_page_int|가 있으면 |dead_cycles|나 |insert_penalties|가 바뀐다. 이 정의들은 늘 전역이다.

상자 레지스터의 어떤 치수를 바꿀 때 그 변화는 꼭 전역은 아니다. 그러나 \TeX은 \.{\\global} 스위치를 보지 않는다.

@<대입들@>=
case set_aux: alter_aux()
case set_prev_graf: alter_prev_graf()
case set_page_dimen: alter_page_so_far()
case set_page_int: alter_integer()
case set_box_dimen: alter_box_dimen()

@ @<|prefixed_command|의 하위...@>=
func alter_aux() {
	var c halfword // |hmode|나 |vmode|
	if cur_chr != abs(mode) {
		report_illegal_case()
	} else {
		c = cur_chr; scan_optional_equals()
		if c == vmode {
			scan_normal_dimen(); set_prev_depth(cur_val)
		} else {
			scan_int()
			if cur_val <= 0 || cur_val > 32767 {
				print_err("Bad space factor")
@.Bad space factor@>
				help1("I allow only values in the range 1..32767 here.")
				int_error(cur_val)
			} else {
				set_space_factor(cur_val)
			}
		}
	}
}

@ @<|prefixed_command|의 하위...@>=
func alter_prev_graf() {
	var p int32 // |nest|의 첨자; |0..nest_size|
	nest[nest_ptr] = cur_list(); p = nest_ptr
	for abs(nest[p].mode_field) != vmode {
		p--
	}
	scan_optional_equals(); scan_int()
	if cur_val < 0 {
		print_err("Bad "); print_esc("prevgraf")
@.Bad \\prevgraf@>
		help1("I allow only nonnegative values here.")
		int_error(cur_val)
	} else {
		nest[p].pg_field = cur_val; set_cur_list(nest[nest_ptr])
	}
}

@ @<|prefixed_command|의 하위...@>=
func alter_page_so_far() {
	var c int32 // |page_so_far|의 첨자; |0..7|
	c = cur_chr; scan_optional_equals(); scan_normal_dimen()
	page_so_far[c] = cur_val
}

@ @<|prefixed_command|의 하위...@>=
func alter_integer() {
	var c int32 // \.{\\deadcycles}이면 0, \.{\\insertpenalties}이면 1
	c = cur_chr; scan_optional_equals(); scan_int()
	if c == 0 {
		dead_cycles = cur_val
	} else {
		insert_penalties = cur_val
	}
}

@ @<|prefixed_command|의 하위...@>=
func alter_box_dimen() {
	var c small_number // |width_offset|나 |height_offset|나 |depth_offset|
	var b eight_bits // 상자 번호
	c = cur_chr; scan_eight_bit_int(); b = cur_val; scan_optional_equals()
	scan_normal_dimen()
	if box(b) != null {
		mem[box(b)+c].sc = cur_val
	}
}

@ 문단 모양은 뻔한 방식으로 마련한다.

@<대입들@>=
case set_shape:
	scan_optional_equals(); scan_int(); n = cur_val
	if n <= 0 {
		p = null
	} else {
		p = get_node(2*n + 1); set_info(p, n)
		for j = 1; j <= n; j++ {
			scan_normal_dimen()
			mem[p+2*j-1].sc = cur_val // 들여쓰기
			scan_normal_dimen()
			mem[p+2*j].sc = cur_val // 너비
		}
	}
	define(a, par_shape_loc, shape_ref, p)

@ 다음은 그리 뻔하지 않은 것이다. 이것은 |get_node(2*n+1)|이 메모리 용량을 넘치지 않는 모든 양수~|n|을 |info(par_shape_ptr)|가 담을
수 있도록 보장한다.

@<``상수'' 값들이...@>=
if 2*max_halfword < mem_top-mem_min {
	bad = 41
}

@ 새 하이픈 넣기 자료는 |hyph_data| 명령으로 불러온다.

@<\TeX의 원시 명령을...@>=
primitive("hyphenation", hyph_data, 0)
@!@:hyphenation_}{\.{\\hyphenation} primitive@>
primitive("patterns", hyph_data, 1)
@!@:patterns_}{\.{\\patterns} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case hyph_data:
	if chr_code == 1 { print_esc("patterns") } else { print_esc("hyphenation") }

@ @<대입들@>=
case hyph_data:
	if cur_chr == 1 {
		if ini_version {
			new_patterns(); goto done
		}
		print_err("Patterns can be loaded only by INITEX")
@.Patterns can be...@>
		help0(); error()
		for {
			get_token()
			if cur_cmd == right_brace {
				break
			}
		} // 패턴을 버린다
		return
	} else {
		new_hyph_exceptions(); goto done
	}

@ 글꼴 정보, 대화 모드, 하이픈 넣기 표만 빼고 \TeX의 모든 매개변수는 |eqtb|에 있다. 이 셋은 엄격하게 전역이다.

@<대입들@>=
case assign_font_dimen:
	find_font_dimen(true); k = cur_val
	scan_optional_equals(); scan_normal_dimen(); font_info[k].sc = cur_val
case assign_font_int:
	n = cur_chr; scan_font_ident(); f = cur_val
	scan_optional_equals(); scan_int()
	if n == 0 { hyphen_char[f] = cur_val } else { skew_char[f] = cur_val }

@ @<\TeX의 원시 명령을...@>=
primitive("hyphenchar", assign_font_int, 0)
@!@:hyphen_char_}{\.{\\hyphenchar} primitive@>
primitive("skewchar", assign_font_int, 1)
@!@:skew_char_}{\.{\\skewchar} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case assign_font_int:
	if chr_code == 0 { print_esc("hyphenchar") } else { print_esc("skewchar") }

@ 다음은 새 글꼴의 정보를 불러들이는 곳이다.

@<대입들@>=
case def_font: new_font(a)

@ @<|prefixed_command|의 하위...@>=
func new_font(a small_number) {
	var u pointer // 사용자의 글꼴 식별자
	var s scaled // 지정된 ``at'' 크기, 또는 배율에 음의 부호를 붙인 것
	var f internal_font_number // 기존 글꼴들을 훑는다
	var t str_number // 얼린 글꼴 식별자의 이름
	var old_setting int32 // |selector| 설정을 담아 둔다; |0..max_selector|
	var flushable_string str_number // 아직 참조되지 않은 문자열
	if job_name == 0 {
		open_log_file() // \.{texput}을 글꼴 이름과 헷갈리지 않게 한다
	}
@.texput@>
	get_r_token(); u = cur_cs
	if u >= hash_base {
		t = text(u)
	} else if u >= single_base {
		if u == null_cs { t = str("FONT") } else { t = u - single_base }
	} else {
		old_setting = selector; selector = new_string
		print("FONT"); print(u - active_base); selector = old_setting
@.FONTx@>
		str_room(1); t = make_string()
	}
	define(a, u, set_font, null_font); scan_optional_equals(); scan_file_name()
	@<글꼴 크기 지정을 훑는다@>
	@<이 글꼴을 이미 불러왔으면 |f|를 내부 글꼴 번호로 하고 |goto common_ending|@>
	f = read_font_info(u, cur_name, cur_area, s)
common_ending:
	set_equiv(u, f); eqtb[font_id_base+f] = eqtb[u]; set_font_id_text(f, t)
}

@ @<글꼴 크기 지정을...@>=
name_in_progress = true // 이것은 |cur_name|이 바뀌지 않게 한다
if scan_keyword("at") {
	@<(양수인) `at' 크기를 |s|에 넣는다@>
@.at@>
} else if scan_keyword("scaled") {
@.scaled@>
	scan_int(); s = -cur_val
	if cur_val <= 0 || cur_val > 32768 {
		print_err("Illegal magnification has been changed to 1000")
@.Illegal magnification...@>
		help1("The magnification ratio must be between 1 and 32768.")
		int_error(cur_val); s = -1000
	}
} else {
	s = -1000
}
name_in_progress = false

@ @<(양수인) `at' 크기를...@>=
scan_normal_dimen(); s = cur_val
if s <= 0 || s >= 0o1000000000 {
	print_err("Improper `at' size (")
	print_scaled(s); print("pt), replaced by 10pt")
@.Improper `at' size...@>
	help2("I can only handle fonts at positive sizes that are",
		"less than 2048pt, so I've changed what you said to 10pt.")
	error(); s = 10 * unity
}

@ 사용자가 이전에 불러온 글꼴에 새 식별자를 주면, 새 이름이 그 글꼴의 공식 식별자가 된다. 글꼴 이름 `\.{xyz}'와 `\.{XYZ}'는
서로 다른 것으로 여긴다.

@<이 글꼴을 이미 불러왔으면...@>=
flushable_string = str_ptr - 1
for f = font_base + 1; f <= font_ptr; f++ {
	if str_eq_str(font_name[f], cur_name) && str_eq_str(font_area[f], cur_area) {
		if cur_name == flushable_string {
			flush_string(); cur_name = font_name[f]
		}
		if s > 0 {
			if s == font_size[f] {
				goto common_ending
			}
		} else if font_size[f] == xn_over_d(font_dsize[f], -s, 1000) {
			goto common_ending
		}
	}
}

@ @<원시 명령의 이름을 찍는...@>=
case set_font:
	print("select font "); slow_print(font_name[chr_code])
	if font_size[chr_code] != font_dsize[chr_code] {
		print(" at "); print_scaled(font_size[chr_code])
		print("pt")
	}

@ @<\TeX의 원시 명령을...@>=
primitive("batchmode", set_interaction, batch_mode)
@!@:batch_mode_}{\.{\\batchmode} primitive@>
primitive("nonstopmode", set_interaction, nonstop_mode)
@!@:nonstop_mode_}{\.{\\nonstopmode} primitive@>
primitive("scrollmode", set_interaction, scroll_mode)
@!@:scroll_mode_}{\.{\\scrollmode} primitive@>
primitive("errorstopmode", set_interaction, error_stop_mode)
@!@:error_stop_mode_}{\.{\\errorstopmode} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case set_interaction:
	switch chr_code {
	case batch_mode: print_esc("batchmode")
	case nonstop_mode: print_esc("nonstopmode")
	case scroll_mode: print_esc("scrollmode")
	default: print_esc("errorstopmode")
	}

@ @<대입들@>=
case set_interaction: new_interaction()

@ @<|prefixed_command|의 하위...@>=
func new_interaction() {
	print_ln()
	interaction = cur_chr
	@<|interaction|에 따라 찍기 |selector|를 초기화한다@>
	if log_opened {
		selector = selector + 2
	}
}

@ 명령 \.{\\afterassignment}는 토큰 하나를 전역 변수 |after_token|에 넣는다. 이 전역 변수는 대입을 할 때마다 바로 뒤에 살핀다.

@<전역 변수@>=
var @!after_token halfword // 0이거나 저장된 토큰

@ @<핵심 변수들의...@>=
after_token = 0

@ @<|mode|에 상관없는...@>=
case vmode + after_assignment, hmode + after_assignment, mmode + after_assignment:
	get_token(); after_token = cur_tok

@ @<\.{\\afterassignment}가 저장한...@>=
if after_token != 0 {
	cur_tok = after_token; back_input(); after_token = 0
}

@ 다음은 `공백도 relax도 호출도 대입도 아닌 다음 토큰을 얻는다'라고 부를 만한 프로시저다.

@<|main_control|이 쓰는 동작...@>=
func do_assignments() {
	for {
		@<공백도 relax도 호출도...@>
		if cur_cmd <= max_non_prefixed_command {
			return
		}
		set_box_allowed = false; prefixed_command(); set_box_allowed = true
	}
}

@ @<|mode|에 상관없는...@>=
case vmode + after_group, hmode + after_group, mmode + after_group:
	get_token(); save_for_after(cur_tok)

@ 명령 \.{\\read}를 위한 파일은 명령 |in_stream|으로 열고 닫는다.

@<\TeX의 원시 명령을...@>=
primitive("openin", in_stream, 1)
@!@:open_in_}{\.{\\openin} primitive@>
primitive("closein", in_stream, 0)
@!@:close_in_}{\.{\\closein} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case in_stream:
	if chr_code == 0 { print_esc("closein") } else { print_esc("openin") }

@ @<|mode|에 상관없는...@>=
case vmode + in_stream, hmode + in_stream, mmode + in_stream: open_or_close_in()

@ @<|main_control|이 쓰는 동작...@>=
func open_or_close_in() {
	var c int32 // \.{\\openin}이면 1, \.{\\closein}이면 0
	var n int32 // 스트림 번호; |0..15|
	c = cur_chr; scan_four_bit_int(); n = cur_val
	if read_open[n] != closed {
		a_close(&read_file[n]); read_open[n] = closed
	}
	if c != 0 {
		scan_optional_equals(); scan_file_name()
		if cur_ext == str("") {
			cur_ext = str(".tex")
		}
		pack_cur_name()
		if a_open_in(&read_file[n]) {
			read_open[n] = just_open
		}
	}
}

@ 사용자는 현재 모드와 상관없이 터미널에 메시지를 낼 수 있다.

@<|mode|에 상관없는...@>=
case vmode + message, hmode + message, mmode + message: issue_message()

@ @<\TeX의 원시 명령을...@>=
primitive("message", message, 0)
@!@:message_}{\.{\\message} primitive@>
primitive("errmessage", message, 1)
@!@:err_message_}{\.{\\errmessage} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case message:
	if chr_code == 0 { print_esc("message") } else { print_esc("errmessage") }

@ @<|main_control|이 쓰는 동작...@>=
func issue_message() {
	var old_setting int32 // |selector| 설정을 담아 둔다; |0..max_selector|
	var c int32 // \.{\\message}와 \.{\\errmessage}를 구별한다; |0..1|
	var s str_number // 메시지
	c = cur_chr; set_link(garbage, scan_toks(false, true))
	old_setting = selector; selector = new_string
	token_show(def_ref); selector = old_setting
	flush_list(def_ref)
	str_room(1); s = make_string()
	if c == 0 {
		@<문자열 |s|를 터미널에 찍는다@>
	} else {
		@<문자열 |s|를 오류 메시지로 찍는다@>
	}
	flush_string()
}

@ @<문자열 |s|를 터미널에...@>=
if term_offset+length(s) > max_print_line-2 {
	print_ln()
} else if term_offset > 0 || file_offset > 0 {
	print_char(' ')
}
slow_print(s); update_terminal()

@ 모드 |scroll_mode|에서 사용자가 정의한 \.{\\errhelp} 없이 \.{\\errmessage}가 자주 나타나면, 매번 긴 도움말 메시지를 주고 싶지는
않다. 그래서 장황한 설명은 한 번만 준다.

@<전역 변수@>=
var @!long_help_seen bool // 긴 \.{\\errmessage} 도움말을 썼는가?

@ @<핵심 변수들의...@>=
long_help_seen = false

@ @<문자열 |s|를 오류 메시지로...@>=
print_err(""); slow_print(s)
if err_help() != null {
	use_err_help = true
} else if long_help_seen {
	help1("(That was another \\errmessage.)")
} else {
	if interaction < error_stop_mode {
		long_help_seen = true
	}
	help4("This error message was generated by an \\errmessage",
		"command, so I can't give any explicit help.",
		"Pretend that you're Hercule Poirot: Examine all clues,",
@^Poirot, Hercule@>
		"and deduce the truth by order and method.")
}
error(); use_err_help = false

@ 루틴 |error|는 |err_help| 매개변수에서 도움말을 요청하면 |give_err_help|를 부른다.

@<함수들@>=
func give_err_help() {
	token_show(err_help())
}

@ 명령 \.{\\uppercase}와 \.{\\lowercase}는 토큰 목록을 만든 다음 그 안의 글자들의 대소문자를 바꾸어서 구현한다.

@<|mode|에 상관없는...@>=
case vmode + case_shift, hmode + case_shift, mmode + case_shift: shift_case()

@ @<\TeX의 원시 명령을...@>=
primitive("lowercase", case_shift, lc_code_base)
@!@:lowercase_}{\.{\\lowercase} primitive@>
primitive("uppercase", case_shift, uc_code_base)
@!@:uppercase_}{\.{\\uppercase} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case case_shift:
	if chr_code == lc_code_base { print_esc("lowercase") } else { print_esc("uppercase") }

@ @<|main_control|이 쓰는 동작...@>=
func shift_case() {
	var b pointer // |lc_code_base|나 |uc_code_base|
	var p pointer // 토큰 목록을 훑는다
	var t halfword // 토큰
	var c eight_bits // 문자 코드
	b = cur_chr; p = scan_toks(false, false); p = link(def_ref)
	for p != null {
		@<알맞으면 |p|에 있는 토큰의 대소문자를 바꾼다@>
		p = link(p)
	}
	back_list(link(def_ref)); free_avail(def_ref) // 참조 횟수는 빼 둔다
}

@ 코드 |chr_code|의 대소문자가 바뀔 때 |cmd|는 바꾸지 않는다. 또 |cs_token_flag+active_base|가 256의 배수라는 사실을 이용해서
능동 문자도 바꾼다.
@^data structure assumptions@>

@<알맞으면 |p|에 있는...@>=
t = info(p)
if t < cs_token_flag+single_base {
	c = t % 256
	if equiv(b+c) != 0 {
		set_info(p, t-c+equiv(b+c))
	}
}

@ 마침내 |main_control|에서 빠진 마지막 조각들, 곧 디버깅에 쓸모 있는 `\.{\\show}' 명령들에 이르렀다.

@<|mode|에 상관없는...@>=
case vmode + xray, hmode + xray, mmode + xray: show_whatever()

@ @<정의@>=
const (
	@!show_code = 0 // \.{\\show}
	@!show_box_code = 1 // \.{\\showbox}
	@!show_the_code = 2 // \.{\\showthe}
	@!show_lists_code = 3 // \.{\\showlists}
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("show", xray, show_code)
@!@:show_}{\.{\\show} primitive@>
primitive("showbox", xray, show_box_code)
@!@:show_box_}{\.{\\showbox} primitive@>
primitive("showthe", xray, show_the_code)
@!@:show_the_}{\.{\\showthe} primitive@>
primitive("showlists", xray, show_lists_code)
@!@:show_lists_code_}{\.{\\showlists} primitive@>

@ @<원시 명령의 이름을 찍는...@>=
case xray:
	switch chr_code {
	case show_box_code: print_esc("showbox")
	case show_the_code: print_esc("showthe")
	case show_lists_code: print_esc("showlists")
	default: print_esc("show")
	}

@ @<|main_control|이 쓰는 동작...@>=
func show_whatever() {
	switch cur_chr {
	case show_lists_code: begin_diagnostic(); show_activities()
	case show_box_code: @<상자의 현재 내용을 보인다@>
	case show_code: @<토큰의 현재 뜻을 보이고 |goto common_ending|@>
	default: @<어떤 매개변수나 레지스터의 현재 값을 보이고 |goto common_ending|@>
	}
	@<길어질 수 있는 \.{\\show} 명령을 마무리한다@>
common_ending:
	if interaction < error_stop_mode {
		help0(); error_count--
	} else if tracing_online() > 0 {
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
	error()
}

@ @<토큰의 현재 뜻을...@>=
get_token()
if interaction == error_stop_mode {
	wake_up_terminal()
}
print_nl("> ")
if cur_cs != 0 {
	sprint_cs(cur_cs); print_char('=')
}
print_meaning(); goto common_ending

@ @<원시 명령의 이름을 찍는...@>=
case undefined_cs: print("undefined")
case call: print("macro")
case long_call: print_esc("long macro")
case outer_call: print_esc("outer macro")
case long_outer_call: print_esc("long"); print_esc("outer macro")
case end_template: print_esc("outer endtemplate")

@ @<상자의 현재 내용을...@>=
scan_eight_bit_int(); begin_diagnostic()
print_nl("> \\box"); print_int(cur_val); print_char('=')
if box(cur_val) == null {
	print("void")
} else {
	show_box(box(cur_val))
}

@ 보충: \GO/는 쓰지 않는 지역 변수를 허락하지 않으므로 원본의 지역 변수 |p|를 뺐다.

@<어떤 매개변수나 레지스터의...@>=
the_toks() // 원본은 결과(보여 줄 토큰 목록의 꼬리)를 지역 변수 |p|에 넣지만 쓰지 않는다
if interaction == error_stop_mode {
	wake_up_terminal()
}
print_nl("> "); token_show(temp_head)
flush_list(link(temp_head)); goto common_ending

@ @<길어질 수 있는...@>=
end_diagnostic(true); print_err("OK")
@.OK@>
if selector == term_and_log && tracing_online() <= 0 {
	selector = term_only; print(" (see the transcript file)")
	selector = term_and_log
}

@* 표의 덤프와 언덤프.
\.{INITEX}가 글꼴과 매크로를 한 무더기 보고 나면, 필요한 정보를 모두 보조 파일에 써 둘 수 있다. 그래서 실무용 \TeX이 그 메모리를
빠른 속도로 초기화할 수 있다. 프로그램의 이 부분이 그런 출력과 입력을 맡는다. 둘 사이의 역관계가 분명하도록 저장과 복원 과정을
함께 살펴보겠다.
@.INITEX@>

전역 변수 |format_ident|는 \TeX이 시작할 준비가 되었을 때 |banner| 줄 바로 뒤에 찍는 문자열이다. \.{INITEX}에서 이 문자열은 그저
`\.{ (INITEX)}'라고 하고, 다른 판의 \TeX에서는 이를테면 `\.{ (preloaded format=plain 1982.11.19)}'라고 해서 포맷 파일을 만든 해와
달과 날을 보인다. \TeX의 표를 불러오기 전에는 |format_ident=0|이다.

@<전역 변수@>=
var @!format_ident str_number

@ @<핵심 변수들의...@>=
format_ident = 0

@ @<표의 항목들을 초기화한다...@>=
format_ident = str(" (INITEX)")

@ 보충: 원본은 이 프로시저를 \.{INITEX}에서만 컴파일한다. 이 번역에서는 늘 컴파일한다.

@<|main_control|이 쓰는 동작...@>=
func store_fmt_file() {
	var j, k, l int32 // 만능 첨자
	var p, q pointer // 만능 포인터
	var x int32 // 덤프할 무언가
	var w four_quarters // ASCII 코드 네 개
	@<|store_fmt_file|의 매크로@>@;
	@<덤프가 허락되지 않으면 그만둔다@>
	@<|format_ident|를 만들고, 포맷 파일을 열고, 덤프를 시작했다고 알린다@>
	@<일관성 검사를 위한 상수들을 덤프한다@>
	@<문자열 풀을 덤프한다@>
	@<동적 메모리를 덤프한다@>
	@<등가물 표를 덤프한다@>
	@<글꼴 정보를 덤프한다@>
	@<하이픈 넣기 표를 덤프한다@>
	@<몇 가지 더와 마무리 검사 낱말을 덤프한다@>
	@<포맷 파일을 닫는다@>
}

@ 포맷 파일을 덤프하는 프로시저에 대응해서, 포맷 파일을 읽어 들이는 함수가 있다. 이 함수는 덤프된 포맷이 지금 \TeX의 표 크기
따위와 맞지 않으면 |false|를 돌려준다.

보충: 원본의 매크로 |too_small(#)|은 메시지를 찍고 |goto bad_fmt|한다. 이 번역에서는 뒤에서 정의하는 함수 |undump_size|가 메시지를
찍고 |false|를 돌려주며, 부르는 쪽이 |goto bad_fmt|한다. 원본은 레이블 |bad_fmt|에 번호 6666을 매긴다.

@<함수들@>=
@<|open_fmt_file|이라는 함수를 선언한다@>@;
func load_fmt_file() bool {
	var j, k int32 // 만능 첨자
	var p, q pointer // 만능 포인터
	var x int32 // 언덤프한 무언가
	var w four_quarters // ASCII 코드 네 개
	@<|load_fmt_file|의 매크로@>@;
	@<일관성 검사를 위한 상수들을 언덤프한다@>
	@<문자열 풀을 언덤프한다@>
	@<동적 메모리를 언덤프한다@>
	@<등가물 표를 언덤프한다@>
	@<글꼴 정보를 언덤프한다@>
	@<하이픈 넣기 표를 언덤프한다@>
	@<몇 가지 더와 마무리 검사 낱말을 언덤프한다@>
	return true // 됐다!
bad_fmt:
	wake_up_terminal()
	wterm_ln("(Fatal format file error; I'm stymied)")
@.Fatal format file error@>
	return false
}

@ 사용자는 |save_ptr=0|일 때에만 포맷 파일을 덤프할 수 있다. 이 조건은 |cur_level=level_one|을 뜻하므로 배열 |xeq_level|은
일정하고, 그것을 덤프할 필요가 없다.

@<덤프가 허락되지 않으면...@>=
if save_ptr != 0 {
	print_err("You can't dump inside a group")
@.You can't dump...@>
	help1("`{...\\dump}' is a no-no."); succumb()
}

@ 포맷 파일은 |memory_word| 항목들로 이루어지고, 여러 형의 낱말을 덤프하는 데 다음 매크로들을 쓴다.

보충: 원본의 매크로 |dump_wd|, |dump_int|, |dump_hh|, |dump_qqqq|는 전역 변수 |fmt_file|만 쓰므로 함수로 옮긴다.

@<전역 변수@>=
var @!fmt_file word_file // 포맷 정보의 입력이나 출력에 쓴다

func dump_wd(w memory_word) { fmt_file.buf = w; w_put(&fmt_file) }
func dump_int(x int32) { fmt_file.buf = memory_word{sc: x}; w_put(&fmt_file) }
func dump_hh(h two_halves) { fmt_file.buf = memory_word{hh: h}; w_put(&fmt_file) }
func dump_qqqq(q four_quarters) { fmt_file.buf = memory_word{qqqq: q}; w_put(&fmt_file) }

@ \dg 원본은 낱말 파일의 원소를 \PASCAL의 |put|과 |get|으로 쓰고 읽는다. 이 번역의 |memory_word|는 변형 레코드가 아니라 필드가
따로따로인 구조체이므로(\os{113}), 한 낱말을 쓸 때 모든 필드를 차례로 쓴다. 32비트 정수 아홉 개와 64비트 부동 소수점 수 하나,
모두 44바이트다. 바이트 순서는 리틀 엔디언으로 정한다. 이 낱말 파일 형식은 이 번역의 \TeX끼리만 주고받을 수 있다.
@^system dependencies@>

@<함수들@>=
func w_put(f *word_file) { // \PASCAL의 |put(f)|
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

func w_get(f *word_file) { // \PASCAL의 |get(f)|
	var b [44]byte
	var v [11]uint32
	if _, err := io.ReadFull(f.r, b[:]); err != nil {
		f.at_eof = true; return
	}
	for i := range v {
		v[i] = uint32(b[4*i]) | uint32(b[4*i+1])<<8 | uint32(b[4*i+2])<<16 | uint32(b[4*i+3])<<24
	}
	f.buf.sc = int32(v[0]); f.buf.gr = math.Float64frombits(uint64(v[1]) | uint64(v[2])<<32)
	f.buf.hh = two_halves{rh: int32(v[3]), lh: int32(v[4]), b0: int32(v[5]), b1: int32(v[6])}
	f.buf.qqqq = four_quarters{int32(v[7]), int32(v[8]), int32(v[9]), int32(v[10])}
}

@ 역매크로는 조금 더 복잡하다. 읽어 들이는 값의 범위를 검사해야 하기 때문이다. 우리는 `|undump(a)(b)(x)|'라고 해서 |a<=x<=b|
범위에 있어야 할 정수 값 |x|를 읽는다. 언덤프하는 동안에는 시스템 오류 메시지를 억눌러야 한다.
@^system dependencies@>

보충: 원본의 언덤프 매크로들은 값이 범위를 벗어나면 |goto bad_fmt|한다. \GO/의 함수는 부른 쪽의 레이블로 갈 수 없으므로,
|undump(a,b,&x)|와 |undump_size(a,b,s,&x)|는 값이 맞으면 |x|에 넣고 |true|를, 그렇지 않으면 |false|를 돌려주며, 부르는 쪽이
|goto bad_fmt|한다. 범위를 검사하지 않는 |undump_wd| 따위는 읽은 값을 돌려준다.

@<함수들@>=
func undump_wd() memory_word { w_get(&fmt_file); return fmt_file.buf }
func undump_int() int32 { w_get(&fmt_file); return fmt_file.buf.sc }
func undump_hh() two_halves { w_get(&fmt_file); return fmt_file.buf.hh }
func undump_qqqq() four_quarters { w_get(&fmt_file); return fmt_file.buf.qqqq }

func undump(a, b int32, v *int32) bool {
	x := undump_int()
	if x < a || x > b {
		return false
	}
	*v = x; return true
}

func undump_size(a, b int32, s string, v *int32) bool {
	x := undump_int()
	if x < a {
		return false
	}
	if x > b { // 원본의 |too_small|
		wake_up_terminal()
		wterm_ln("---! Must increase the ", s)
@.Must increase the x@>
		return false
	}
	*v = x; return true
}

@ 프로그램의 다음 몇 절을 보면 덤프와 언덤프 매크로를 어떻게 쓰는지 분명해질 것이다.

보충: 원본은 첫 낱말로 \.{WEB}의 문자열 풀 검사합 `\.{@@\$}'를 덤프한다. 이 번역에는 문자열 풀 파일이 없으므로, 미리 불러 두는
문자열 목록 |pool_literals|에서 계산한 검사합 |pool_check_sum|을 대신 쓴다.

@<일관성 검사를 위한 상수들을 덤프한다@>=
dump_int(pool_check_sum())
dump_int(mem_bot)
dump_int(mem_top)
dump_int(eqtb_size)
dump_int(hash_prime)
dump_int(hyph_size)

@ \dg 앞 절의 보충 설명에서 말한 검사합 함수 |pool_check_sum|이다.

@<함수들@>=
func pool_check_sum() int32 { // 미리 불러 두는 문자열들의 검사합
	var a int32 = 271828
	for _, s := range pool_literals {
		for i := 0; i < len(s); i++ {
			a = (a*31 + int32(s[i])) % 0o10000000000
		}
		a = (a*37 + int32(len(s))) % 0o10000000000
	}
	return a
}

@ 원본에서는 \.{WEB} 프로그램의 ``주석 처리된'' 절들도 문자열 풀에 문자열을 보탠다. 그래서 \.{INITEX}와 \TeX은 같은 문자열을
가진다. (그리고 물론 그렇게 되는 것은 좋은 일이다.)
@.WEB@>
@^string pool@>

@<일관성 검사를 위한 상수들을 언덤프한다@>=
x = fmt_file.buf.sc
if x != pool_check_sum() {
	goto bad_fmt // 문자열들이 같은지 검사한다
}
x = undump_int()
if x != mem_bot {
	goto bad_fmt
}
x = undump_int()
if x != mem_top {
	goto bad_fmt
}
x = undump_int()
if x != eqtb_size {
	goto bad_fmt
}
x = undump_int()
if x != hash_prime {
	goto bad_fmt
}
x = undump_int()
if x != hyph_size {
	goto bad_fmt
}

@ 보충: 원본의 매크로 |dump_four_ASCII|는 |store_fmt_file|의 지역 변수 |k|와 |w|를 쓰므로 함수 안의 함수 리터럴로 옮긴다.

@<|store_fmt_file|의 매크로@>=
dump_four_ASCII := func() {
	w.b0 = qi(so(str_pool[k])); w.b1 = qi(so(str_pool[k+1]))
	w.b2 = qi(so(str_pool[k+2])); w.b3 = qi(so(str_pool[k+3]))
	dump_qqqq(w)
}

@ \dg 앞 절의 코드부를 옮긴다.

@<문자열 풀을 덤프한다@>=
dump_int(pool_ptr)
dump_int(str_ptr)
for k = 0; k <= str_ptr; k++ {
	dump_int(str_start[k])
}
k = 0
for k+4 < pool_ptr {
	dump_four_ASCII(); k = k + 4
}
k = pool_ptr - 4; dump_four_ASCII()
print_ln(); print_int(str_ptr); print(" strings of total length ")
print_int(pool_ptr)

@ @<|load_fmt_file|의 매크로@>=
undump_four_ASCII := func() {
	w = undump_qqqq()
	str_pool[k] = si(qo(w.b0)); str_pool[k+1] = si(qo(w.b1))
	str_pool[k+2] = si(qo(w.b2)); str_pool[k+3] = si(qo(w.b3))
}

@ \dg 앞 절의 코드부를 옮긴다.

@<문자열 풀을 언덤프한다@>=
if !undump_size(0, pool_size, "string pool size", &pool_ptr) {
	goto bad_fmt
}
if !undump_size(0, max_strings, "max strings", &str_ptr) {
	goto bad_fmt
}
for k = 0; k <= str_ptr; k++ {
	if !undump(0, pool_ptr, &str_start[k]) {
		goto bad_fmt
	}
}
k = 0
for k+4 < pool_ptr {
	undump_four_ASCII(); k = k + 4
}
k = pool_ptr - 4; undump_four_ASCII()
init_str_ptr = str_ptr; init_pool_ptr = pool_ptr

@ 배열 |mem|의 가변 크기 부분에서 쓸 수 있는 공간 목록을 정렬하면, 대개 동적 메모리를 그리 많이 덤프하지 않아도 된다.

또 |var_used|와 |dyn_used|를 다시 계산해서, 통계를 모으지 않았을 때도 \.{INITEX}가 올바른 정보를 덤프하게 한다.

@<동적 메모리를 덤프한다@>=
sort_avail(); var_used = 0
dump_int(lo_mem_max); dump_int(rover)
p = mem_bot; q = rover; x = 0
for {
	for k = p; k <= q+1; k++ {
		dump_wd(mem[k])
	}
	x = x + q + 2 - p; var_used = var_used + q - p
	p = q + node_size(q); q = rlink(q)
	if q == rover {
		break
	}
}
var_used = var_used + lo_mem_max - p; dyn_used = mem_end + 1 - hi_mem_min
for k = p; k <= lo_mem_max; k++ {
	dump_wd(mem[k])
}
x = x + lo_mem_max + 1 - p
dump_int(hi_mem_min); dump_int(avail)
for k = hi_mem_min; k <= mem_end; k++ {
	dump_wd(mem[k])
}
x = x + mem_end + 1 - hi_mem_min
@<동적 메모리 사용량을 덤프하고 알린다@>

@ \dg 앞 절에 이어서 한 낱말짜리 메모리 사용량을 바로잡아 덤프하고 알린다.

@<동적 메모리 사용량을...@>=
p = avail
for p != null {
	dyn_used--; p = link(p)
}
dump_int(var_used); dump_int(dyn_used)
print_ln(); print_int(x)
print(" memory locations dumped; current usage is ")
print_int(var_used); print_char('&'); print_int(dyn_used)

@ @<동적 메모리를 언덤프한다@>=
if !undump(lo_mem_stat_max+1000, hi_mem_stat_min-1, &lo_mem_max) {
	goto bad_fmt
}
if !undump(lo_mem_stat_max+1, lo_mem_max, &rover) {
	goto bad_fmt
}
p = mem_bot; q = rover
for {
	for k = p; k <= q+1; k++ {
		mem[k] = undump_wd()
	}
	p = q + node_size(q)
	if p > lo_mem_max || (q >= rlink(q) && rlink(q) != rover) {
		goto bad_fmt
	}
	q = rlink(q)
	if q == rover {
		break
	}
}
for k = p; k <= lo_mem_max; k++ {
	mem[k] = undump_wd()
}
@<아래쪽 메모리를 더 쓸 수 있게 하고 위쪽 메모리를 언덤프한다@>

@ \dg 앞 절의 코드에서 떼어 낸 부분이다.

@<아래쪽 메모리를 더 쓸 수...@>=
if mem_min < mem_bot-2 { // 아래쪽 메모리를 더 쓸 수 있게 한다
	p = llink(rover); q = mem_min + 1
	set_link(mem_min, null); set_info(mem_min, null) // 맨 아래 낱말은 쓰지 않는다
	set_rlink(p, q); set_llink(rover, q)
	set_rlink(q, rover); set_llink(q, p); set_link(q, empty_flag)
	set_node_size(q, mem_bot-q)
}
if !undump(lo_mem_max+1, hi_mem_stat_min, &hi_mem_min) {
	goto bad_fmt
}
if !undump(null, mem_top, &avail) {
	goto bad_fmt
}
mem_end = mem_top
for k = hi_mem_min; k <= mem_end; k++ {
	mem[k] = undump_wd()
}
var_used = undump_int(); dyn_used = undump_int()

@ @<등가물 표를 덤프한다@>=
@<|eqtb|의 영역 1--4를 덤프한다@>
@<|eqtb|의 영역 5와 6을 덤프한다@>
dump_int(par_loc); dump_int(write_loc)
@<해시 표를 덤프한다@>

@ @<등가물 표를 언덤프한다@>=
@<|eqtb|의 영역 1--6을 언덤프한다@>
if !undump(hash_base, frozen_control_sequence, &par_loc) {
	goto bad_fmt
}
par_token = cs_token_flag + par_loc
if !undump(hash_base, frozen_control_sequence, &write_loc) {
	goto bad_fmt
}
@<해시 표를 언덤프한다@>

@ 등가물 표에는 대개 되풀이되는 정보가 들어 있으므로 압축된 꼴로 덤프한다. 포맷 파일에서 $n+2$개 값의 나열 $(n,x_1,\ldots,x_n,m)$은
|eqtb|의 연속된 항목 $n+m$개를 나타낸다. 곧 $x_n$의 사본이 |m|개 더 붙은 $(x_1,\ldots,x_n,x_n,\ldots,x_n)$이다.

@<|eqtb|의 영역 1--4를...@>=
k = active_base
for {
	j = k
	for j < int_base-1 {
		if equiv(j) == equiv(j+1) && eq_type(j) == eq_type(j+1) && eq_level(j) == eq_level(j+1) {
			goto found1
		}
		j++
	}
	l = int_base; goto done1 // |j=int_base-1|
found1:
	j++; l = j
	for j < int_base-1 {
		if equiv(j) != equiv(j+1) || eq_type(j) != eq_type(j+1) || eq_level(j) != eq_level(j+1) {
			goto done1
		}
		j++
	}
done1:
	dump_int(l - k)
	for k < l {
		dump_wd(eqtb[k]); k++
	}
	k = j + 1; dump_int(k - l)
	if k == int_base {
		break
	}
}

@ @<|eqtb|의 영역 5와 6을...@>=
for {
	j = k
	for j < eqtb_size {
		if eqtb[j].sc == eqtb[j+1].sc {
			goto found2
		}
		j++
	}
	l = eqtb_size + 1; goto done2 // |j=eqtb_size|
found2:
	j++; l = j
	for j < eqtb_size {
		if eqtb[j].sc != eqtb[j+1].sc {
			goto done2
		}
		j++
	}
done2:
	dump_int(l - k)
	for k < l {
		dump_wd(eqtb[k]); k++
	}
	k = j + 1; dump_int(k - l)
	if k > eqtb_size {
		break
	}
}

@ @<|eqtb|의 영역 1--6을...@>=
k = active_base
for {
	x = undump_int()
	if x < 1 || k+x > eqtb_size+1 {
		goto bad_fmt
	}
	for j = k; j <= k+x-1; j++ {
		eqtb[j] = undump_wd()
	}
	k = k + x
	x = undump_int()
	if x < 0 || k+x > eqtb_size+1 {
		goto bad_fmt
	}
	for j = k; j <= k+x-1; j++ {
		eqtb[j] = eqtb[k-1]
	}
	k = k + x
	if k > eqtb_size {
		break
	}
}

@ 해시 표를 압축하는 데는 다른 방식을 쓴다. 그 아래쪽 영역은 대개 성기기 때문이다. 그래서 |p<=hash_used|에 대해 |text(p)!=0|이면 두 낱말,
곧 |p|와 |hash[p]|를 출력한다. 그리고 |p>=hash_used|에서는 해시 표가 물론 촘촘히 차 있으므로 나머지 항목은 한 덩어리로 출력한다.

@<해시 표를 덤프한다@>=
dump_int(hash_used); cs_count = frozen_control_sequence - 1 - hash_used
for p = hash_base; p <= hash_used; p++ {
	if text(p) != 0 {
		dump_int(p); dump_hh(hash[p]); cs_count++
	}
}
for p = hash_used + 1; p <= undefined_control_sequence-1; p++ {
	dump_hh(hash[p])
}
dump_int(cs_count)
print_ln(); print_int(cs_count); print(" multiletter control sequences")

@ @<해시 표를 언덤프한다@>=
if !undump(hash_base, frozen_control_sequence, &hash_used) {
	goto bad_fmt
}
p = hash_base - 1
for {
	if !undump(p+1, hash_used, &p) {
		goto bad_fmt
	}
	hash[p] = undump_hh()
	if p == hash_used {
		break
	}
}
for p = hash_used + 1; p <= undefined_control_sequence-1; p++ {
	hash[p] = undump_hh()
}
cs_count = undump_int()

@ @<글꼴 정보를 덤프한다@>=
dump_int(fmem_ptr)
for k = 0; k <= fmem_ptr-1; k++ {
	dump_wd(font_info[k])
}
dump_int(font_ptr)
for k = null_font; k <= font_ptr; k++ {
	@<내부 글꼴 번호 |k|의 배열 정보를 덤프한다@>
}
print_ln(); print_int(fmem_ptr - 7); print(" words of font info for ")
print_int(font_ptr - font_base); print(" preloaded font")
if font_ptr != font_base+1 {
	print_char('s')
}

@ @<글꼴 정보를 언덤프한다@>=
if !undump_size(7, font_mem_size, "font mem size", &fmem_ptr) {
	goto bad_fmt
}
for k = 0; k <= fmem_ptr-1; k++ {
	font_info[k] = undump_wd()
}
if !undump_size(font_base, font_max, "font max", &font_ptr) {
	goto bad_fmt
}
for k = null_font; k <= font_ptr; k++ {
	@<내부 글꼴 번호 |k|의 배열 정보를 언덤프한다@>
}

@ @<내부 글꼴 번호 |k|의 배열 정보를 덤프한다@>=
dump_qqqq(font_check[k])
dump_int(font_size[k]); dump_int(font_dsize[k]); dump_int(font_params[k])
dump_int(hyphen_char[k]); dump_int(skew_char[k])
dump_int(font_name[k]); dump_int(font_area[k])
dump_int(font_bc[k]); dump_int(font_ec[k])
dump_int(char_base[k]); dump_int(width_base[k]); dump_int(height_base[k])
dump_int(depth_base[k]); dump_int(italic_base[k]); dump_int(lig_kern_base[k])
dump_int(kern_base[k]); dump_int(exten_base[k]); dump_int(param_base[k])
dump_int(font_glue[k])
dump_int(bchar_label[k]); dump_int(font_bchar[k]); dump_int(font_false_bchar[k])
print_nl("\\font"); print_esc(font_id_text(k)); print_char('=')
print_file_name(font_name[k], font_area[k], str(""))
if font_size[k] != font_dsize[k] {
	print(" at "); print_scaled(font_size[k]); print("pt")
}

@ @<내부 글꼴 번호 |k|의 배열 정보를 언덤프한다@>=
font_check[k] = undump_qqqq()
font_size[k] = undump_int(); font_dsize[k] = undump_int()
if !undump(min_halfword, max_halfword, &font_params[k]) {
	goto bad_fmt
}
hyphen_char[k] = undump_int(); skew_char[k] = undump_int()
if !undump(0, str_ptr, &font_name[k]) || !undump(0, str_ptr, &font_area[k]) {
	goto bad_fmt
}
if !undump(0, 255, &font_bc[k]) || !undump(0, 255, &font_ec[k]) {
	goto bad_fmt
}
char_base[k] = undump_int(); width_base[k] = undump_int(); height_base[k] = undump_int()
depth_base[k] = undump_int(); italic_base[k] = undump_int(); lig_kern_base[k] = undump_int()
kern_base[k] = undump_int(); exten_base[k] = undump_int(); param_base[k] = undump_int()
if !undump(min_halfword, lo_mem_max, &font_glue[k]) {
	goto bad_fmt
}
if !undump(0, fmem_ptr-1, &bchar_label[k]) {
	goto bad_fmt
}
if !undump(min_quarterword, non_char, &font_bchar[k]) ||
	!undump(min_quarterword, non_char, &font_false_bchar[k]) {
	goto bad_fmt
}

@ 보충: 원본에서 이 절은 한 덩어리다. 여기서는 하이픈 넣기 예외와 트라이를 덤프하는 부분, 트라이 연산 표를 덤프하는 부분으로
나누어 적는다.

@<하이픈 넣기 표를 덤프한다@>=
dump_int(hyph_count)
for k = 0; k <= hyph_size; k++ {
	if hyph_word[k] != 0 {
		dump_int(k); dump_int(hyph_word[k]); dump_int(hyph_list[k])
	}
}
print_ln(); print_int(hyph_count); print(" hyphenation exception")
if hyph_count != 1 {
	print_char('s')
}
if trie_not_ready {
	init_trie()
}
dump_int(trie_max)
for k = 0; k <= trie_max; k++ {
	dump_hh(trie[k])
}
@<트라이 연산 표를 덤프한다@>

@ \dg 앞 절에서 떼어 낸, 트라이 연산 표를 덤프하는 부분이다.

@<트라이 연산 표를 덤프한다@>=
dump_int(trie_op_ptr)
for k = 1; k <= trie_op_ptr; k++ {
	dump_int(hyf_distance[k])
	dump_int(hyf_num[k])
	dump_int(hyf_next[k])
}
print_nl("Hyphenation trie of length "); print_int(trie_max)
@.Hyphenation trie...@>
print(" has "); print_int(trie_op_ptr); print(" op")
if trie_op_ptr != 1 {
	print_char('s')
}
print(" out of "); print_int(trie_op_size)
for k = 255; k >= 0; k-- {
	if trie_used[k] > min_quarterword {
		print_nl("  "); print_int(qo(trie_used[k]))
		print(" for language "); print_int(k)
		dump_int(k); dump_int(qo(trie_used[k]))
	}
}

@ 배열 |op_start|에서 ``비어 있지 않은'' 부분만 되살리면 된다.

@<하이픈 넣기 표를 언덤프한다@>=
if !undump(0, hyph_size, &hyph_count) {
	goto bad_fmt
}
for k = 1; k <= hyph_count; k++ {
	if !undump(0, hyph_size, &j) {
		goto bad_fmt
	}
	if !undump(0, str_ptr, &hyph_word[j]) || !undump(min_halfword, max_halfword, &hyph_list[j]) {
		goto bad_fmt
	}
}
if !undump_size(0, trie_size, "trie size", &j) {
	goto bad_fmt
}
if ini_version {
	trie_max = j
}
for k = 0; k <= j; k++ {
	trie[k] = undump_hh()
}
@<트라이 연산 표를 언덤프한다@>

@ \dg 앞 절에서 떼어 낸, 트라이 연산 표를 언덤프하는 부분이다.

@<트라이 연산 표를 언덤프한다@>=
if !undump_size(0, trie_op_size, "trie op size", &j) {
	goto bad_fmt
}
if ini_version {
	trie_op_ptr = j
}
for k = 1; k <= j; k++ {
	if !undump(0, 63, &hyf_distance[k]) || !undump(0, 63, &hyf_num[k]) || // |small_number|
		!undump(min_quarterword, max_quarterword, &hyf_next[k]) {
		goto bad_fmt
	}
}
if ini_version {
	for k = 0; k <= 255; k++ {
		trie_used[k] = min_quarterword
	}
}
k = 256
for j > 0 {
	if !undump(0, k-1, &k) || !undump(1, j, &x) {
		goto bad_fmt
	}
	if ini_version {
		trie_used[k] = qi(x)
	}
	j = j - x; op_start[k] = qo(j)
}
if ini_version {
	trie_not_ready = false
}

@ 통계는 이미 많이 찍었으므로, 그것이 다시 나타나지 않도록 |tracing_stats:=0|으로 한다.

@<몇 가지 더와 마무리 검사 낱말을 덤프한다@>=
dump_int(interaction); dump_int(format_ident); dump_int(69069)
set_tracing_stats(0)

@ @<몇 가지 더와 마무리 검사 낱말을 언덤프한다@>=
if !undump(batch_mode, error_stop_mode, &interaction) {
	goto bad_fmt
}
if !undump(0, str_ptr, &format_ident) {
	goto bad_fmt
}
x = undump_int()
if x != 69069 || fmt_file.at_eof {
	goto bad_fmt
}

@ @<|format_ident|를 만들고...@>=
selector = new_string
print(" (preloaded format="); print(job_name); print_char(' ')
print_int(year()); print_char('.')
print_int(month()); print_char('.'); print_int(day()); print_char(')')
if interaction == batch_mode {
	selector = log_only
} else {
	selector = term_and_log
}
str_room(1)
format_ident = make_string()
pack_job_name(format_extension)
for !w_open_out(&fmt_file) {
	prompt_file_name("format file name", ".fmt")
}
print_nl("Beginning to dump on file ")
@.Beginning to dump...@>
slow_print(w_make_name_string(&fmt_file)); flush_string()
print_nl(""); slow_print(format_ident)

@ @<포맷 파일을 닫는다@>=
w_close(&fmt_file)

@* 주 프로그램.
이것이 바로 그것이다. 우리가 써 온 그 모든 프로시저를 실행하는 \TeX의 부분이다.

음---거의 그렇다. 우리가 잊었을지도 모르는 루틴 몇 개를 위해 자리를 남겨 두자.

@<함수들@>=
@<마지막 순간의 프로시저들@>

@ \TeX82에는 두 판이 있다고 말했다. 하나는 \.{INITEX}라고 부르는데, 먼저 실행해야 한다. 이것은 포맷 파일을 읽지 않고
@.INITEX@>
모든 것을 처음부터 초기화하고, 포맷 파일을 덤프하는 능력이 있다. 다른 하나는 `\.{VIRTEX}'라고 부른다. 이것은 시작하려면 포맷
@.VIRTEX@>
파일을 입력해야 하는 ``처녀'' 프로그램이다. 대개 \.{VIRTEX}는 \.{INITEX}보다 메모리 용량이 크다. 보조 하이픈 넣기 표와
|primitive|의 수많은 호출 따위가 차지하는 공간이 필요 없기 때문이다.

물론 \.{VIRTEX} 프로그램은 포맷 파일을 순식간에 읽을 수는 없다. 그래서 가장 좋은 구현에서는, \PASCAL\ 목적 코드를 불러들이는
루틴을 건너뛸 뿐 아니라 포맷 파일까지 미리 불러 둔 실무용 \TeX을 만들 수 있다. 표준 \PASCAL을 고집하면 이것은 불가능하다. 그러나 많은 시스템을
속여서 초기화를 피하게 하는 간단한 방법이 있다. (1)~|ready_already|라는 전역 정수 변수를 선언한다. \.{VIRTEX}를 처음 불러들였을
때 이 변수가 314159 같은 특정한 값을 가질 확률은 무시할 만하다. (2)~포맷 파일을 읽어 들이고 모든 것을 초기화한 뒤에
|ready_already:=314159|로 한다. (3)~곧 \.{VIRTEX}는 `\.*'를 찍고 입력을 더 기다릴 것이다. 이때 프로그램을 끊고 그 코어
이미지를 운영체제가 빨리 다시 불러들일 수 있는 꼴로 저장한다. (4)~그 코어 이미지를 작동시키면 프로그램은 처음부터 다시
시작한다. 그러나 이제 |ready_already=314159|이고 다른 모든 전역 변수도 초깃값을 가지고 있다. 이전의 순결은 사라졌다!

다시 말해 |ready_already|에 값을 배정하기 전에 조건 |ready_already=314159|를 검사하는 것을 스스로 허락하면 긴 초기화를 피할 수
있다. 더러운 속임수가 이렇게 큰 보상을 주는 일은 드물다.
@^dirty \PASCAL@>
@^system dependencies@>

그런 미리 불러 두기를 허락하는 시스템에서는 \.{TeX}이라는 표준 프로그램이 \.{plain} 포맷을 미리 불러 둔 것이어야 한다. 그것이
{\sl The \TeX book}과 맞기 때문이다. 다른 판들, 이를테면 \.{AmSTeX}도 흔히 쓰는 포맷을 위해 마련해야 한다.
@:TeXbook}{\sl The \TeX book@>
@.AmSTeX@>
@.plain@>

보충: \GO/ 프로그램은 늘 모든 전역 변수를 0으로 하고 시작하므로 이 속임수는 작동하지 않는다. 원본의 구조를 보이려고 그대로
옮겨 둔다.

@<전역 변수@>=
var @!ready_already int32 // 경제를 위해 순수를 희생한다

@ 이제 정말로 그것이다. \TeX은 여기서 시작하고 여기서 끝난다.

변수 |ready_already|에 관한 처음의 검사는 \PASCAL\ 실행 시스템이 그런 ``실수''를 찾아낼 만큼 영리하면 지워야 한다.
@^system dependencies@>

보충: 원본에서는 다른 프로시저에서 레이블 |end_of_TEX|나 |final_end|로 뛰어든다. 이 번역에서는 그런 곳에서 그 레이블을 값으로
|panic|을 일으키므로(\os6), |main|은 맨 처음에 그것을 |recover|로 받는 함수를 미루어(|defer|) 둔다. 그 함수는 받은 값이
|end_of_TEX|이면 |close_files_and_terminate|를 부르고, 어느 쪽이든 |final_end| 뒤의 일을 한다. 정상적인 흐름에서는 주 프로그램
안에서 |end_of_TEX|로 뛰는 곳이 없으므로 그 레이블은 주석으로만 남긴다. 또 \.{INITEX}인지는 명령줄의 첫 인자가 `\.{-ini}'인지로
정한다. 그리고 \PASCAL\ 프로그램이 끝날 때 출력 버퍼가 저절로 비워지는 것과 달리 \GO/에서는 터미널 출력 버퍼를 손수 비워야
하므로, 끝에서 |update_terminal|을 부른다.

@<주 프로그램@>=
func main() { // |start_here|
	@<바깥 레이블로 가는 |panic|을 받을 함수를 미루어 둔다@>
	ini_version = len(os.Args) > 1 && os.Args[1] == "-ini"
	@<끼어들기 신호를 받으면...@>
	history = fatal_error_stop // 초기화하는 동안 그만둘 때를 대비한다
	t_open_out() // 터미널을 출력용으로 연다
	if ready_already == 314159 {
		goto start_of_TEX
	}
	@<``상수'' 값들이 서로 맞는지 검사한다@>
	if bad > 0 {
		wterm_ln("Ouch---my internal constants have been clobbered!", "---case ", bad)
@.Ouch...clobbered@>
		goto final_end
	}
	initialize() // 전역 변수들을 처음 값으로 정한다
	if ini_version {
		if !get_strings_started() {
			goto final_end
		}
		init_prim() // 원시 명령마다 |primitive|를 부른다
		init_str_ptr = str_ptr; init_pool_ptr = pool_ptr; fix_date_and_time()
	}
	ready_already = 314159
start_of_TEX:
	@<출력 루틴들을 초기화한다@>
	@<입력의 첫 줄을 얻고 시작할 준비를 한다@>
	history = spotless // 출발 준비 완료!
	main_control() // 살아난다
	final_cleanup() // 죽을 준비를 한다
	close_files_and_terminate() // |end_of_TEX|
final_end:
	ready_already = 0
	@<터미널의 마지막 줄을 끝내고 출력 버퍼를 비운다@>
}

@ \dg \PASCAL\ 프로그램이 끝나면 텍스트 파일의 마지막 줄이 끝나지 않았을 때 줄 끝이 저절로 덧붙는다. \GO/에서는 그것을 손수
하고, 버퍼에 남은 터미널 출력도 비운다.

@<터미널의 마지막 줄을 끝내고...@>=
if term_offset > 0 {
	wterm_cr()
}
update_terminal()

@ \dg 앞 절의 보충에서 설명한, 바깥 레이블로 가는 |panic|을 받는 함수다.

@<바깥 레이블로 가는...@>=
defer func() {
	r := recover()
	if r == nil {
		return
	}
	if r == end_of_TEX {
		close_files_and_terminate()
	} else if r != final_end {
		panic(r)
	}
	ready_already = 0 // |final_end|
	@<터미널의 마지막 줄을 끝내고 출력 버퍼를 비운다@>
}()

@ \dg 주 프로그램을 뼈대 끝에 둔다.

@<함수들@>=
@<주 프로그램@>

@ 여기서는 지역 운영체제에서 \TeX의 일을 우아하게 마치는 데 필요한 일은 무엇이든 한다. 여기 코드는 치명적 오류 뒤에 작동할 수도
있다. 그러므로 오류 메시지를 낼 수 없는 ``안전한'' 연산으로만 이루어져야 한다. 이를테면 이때 |str_room|이나 |make_string|을
부르는 것은 잘못일 것이다. 그러면 |overflow|를 부르게 되어 끝없는 루프로 이어질 수도 있기 때문이다.
@^system dependencies@>
(실은 |prepare_mag|를 거쳐 오류 메시지를 얻는 길이 하나 있다. 그러나 그것은 끝없는 재귀를 일으킬 수 없다.)
@^recursion@>

프로시저 |final_cleanup|을 건너뛰면 이 프로그램은 아직 열려 있을지도 모르는 입력 파일들을 닫는 수고를 하지 않는다.

@<마지막 순간의...@>=
func close_files_and_terminate() {
	var k int32 // 만능 첨자
	@<확장들을 마무리한다@>
	set_new_line_char(-1)
	if stat && tracing_stats() > 0 {
		@<이 작업에 관한 통계를 출력한다@>
	}
	wake_up_terminal(); @<\.{DVI} 파일을 마무리한다@>
	if log_opened {
		wlog_cr(); a_close(&log_file); selector = selector - 2
		if selector == term_only {
			print_nl("Transcript written on ")
@.Transcript written...@>
			slow_print(log_name); print_char('.')
		}
	}
}

@ 이 절은 |print| 명령을 쓰는 대신 기록 파일에 바로 쓴다. {\bf stat} 판이 아닌 \TeX을 쓸 때 이 문자열들이 |str_pool| 메모리를
차지할 필요가 없기 때문이다.

@<이 작업에 관한 통계를...@>=
if log_opened {
	wlog_ln(" ")
	wlog_ln("Here is how much of TeX's memory", " you used:")
@.Here is how much...@>
	wlog(" ", str_ptr-init_str_ptr, " string")
	if str_ptr != init_str_ptr+1 {
		wlog("s")
	}
	wlog_ln(" out of ", max_strings-init_str_ptr)
	wlog_ln(" ", pool_ptr-init_pool_ptr, " string characters out of ", pool_size-init_pool_ptr)
	wlog_ln(" ", lo_mem_max-mem_min+mem_end-hi_mem_min+2, " words of memory out of ", mem_end+1-mem_min)
	wlog_ln(" ", cs_count, " multiletter control sequences out of ", hash_size)
	@<글꼴, 하이픈 넣기, 스택에 관한 통계를 출력한다@>
}

@ \dg 앞 절의 코드에서 떼어 낸 부분이다.

@<글꼴, 하이픈 넣기, 스택에...@>=
wlog(" ", fmem_ptr, " words of font info for ", font_ptr-font_base, " font")
if font_ptr != font_base+1 {
	wlog("s")
}
wlog_ln(", out of ", font_mem_size, " for ", font_max-font_base)
wlog(" ", hyph_count, " hyphenation exception")
if hyph_count != 1 {
	wlog("s")
}
wlog_ln(" out of ", hyph_size)
wlog_ln(" ", max_in_stack, "i,", max_nest_stack, "n,", max_param_stack, "p,",
	max_buf_stack+1, "b,", max_save_stack+6, "s stack positions out of ",
	stack_size, "i,", nest_size, "n,", param_size, "p,", buf_size, "b,", save_size, "s")

@ 명령 \.{\\end}나 \.{\\dump}를 훑었고 |its_all_over|이면 루틴 |final_cleanup|에 이른다.

@<마지막 순간의...@>=
func final_cleanup() {
	var c small_number // \.{\\end}이면 0, \.{\\dump}이면 1
	c = cur_chr
	if c != 1 {
		set_new_line_char(-1)
	}
	if job_name == 0 {
		open_log_file()
	}
	for input_ptr > 0 {
		if state == token_list { end_token_list() } else { end_file_reading() }
	}
	for open_parens > 0 {
		print(" )"); open_parens--
	}
	if cur_level > level_one {
		print_nl("("); print_esc("end occurred ")
		print("inside a group at level ")
@:end_}{\.{(\\end occurred...)}@>
		print_int(cur_level - level_one); print_char(')')
	}
	@<끝나지 않은 조건문들을 알리고 없앤다@>
	if history != spotless && (history == warning_issued || interaction < error_stop_mode) &&
		selector == term_and_log {
		selector = term_only
		print_nl("(see the transcript file for additional information)")
@.see the transcript file...@>
		selector = term_and_log
	}
	if c == 1 {
		if ini_version {
			for c = top_mark_code; c <= split_bot_mark_code; c++ {
				if cur_mark[c] != null {
					delete_token_ref(cur_mark[c])
				}
			}
			if last_glue != max_halfword {
				delete_glue_ref(last_glue)
			}
			store_fmt_file(); return
		}
		print_nl("(\\dump is performed only by INITEX)"); return
@:dump_}{\.{\\dump...only by INITEX}@>
	}
}

@ \dg 앞 절의 코드에서 떼어 낸 부분이다.

@<끝나지 않은 조건문들을...@>=
for cond_ptr != null {
	print_nl("("); print_esc("end occurred ")
	print("when "); print_cmd_chr(if_test, cur_if)
	if if_line != 0 {
		print(" on line "); print_int(if_line)
	}
	print(" was incomplete)")
	if_line = if_line_field(cond_ptr)
	cur_if = subtype(cond_ptr); temp_ptr = cond_ptr
	cond_ptr = link(cond_ptr); free_node(temp_ptr, if_node_size)
}

@ 보충: 원본은 이 프로시저를 \.{INITEX}에서만 컴파일한다.

@<마지막 순간의...@>=
func init_prim() { // 모든 원시 명령을 초기화한다
	no_new_control_sequence = false
	@<\TeX의 원시 명령을 저마다 해시 표에 넣는다@>
	no_new_control_sequence = true
}

@ 다음 코드를 시작할 때 \TeX의 표에는 아직 쓰레기가 들어 있을 수도 있다. 문자열조차 없을지도 모른다. 그러므로 조심스럽게
나아가며 스스로를 일으켜 세워야 한다.

그러나 프로그램의 이 부분을 마치면 \TeX은 |main_control| 루틴을 불러 일을 시킬 준비가 된다.

@<입력의 첫 줄을 얻고...@>=
@<입력 루틴들을 초기화한다@>
if format_ident == 0 || buffer[loc] == '&' {
	if format_ident != 0 {
		initialize() // 미리 불러 둔 포맷을 지운다
	}
	if !open_fmt_file() {
		goto final_end
	}
	if !load_fmt_file() {
		w_close(&fmt_file); goto final_end
	}
	w_close(&fmt_file)
	for loc < limit && buffer[loc] == ' ' {
		loc++
	}
}
if end_line_char_inactive() {
	limit--
} else {
	buffer[limit] = end_line_char()
}
fix_date_and_time()
@<마법의 오프셋을 계산한다@>
@<|interaction|에 따라 찍기 |selector|를 초기화한다@>
if loc < limit && cat_code(buffer[loc]) != escape {
	start_input() // \.{\\input}을 가정한다
}

@* 디버깅.
\TeX이 일단 작동하면 \.{\\show} 명령과 다른 진단 기능으로 대부분의 오류를 진단할 수 있을 것이다. 그러나 디버깅의 초기 단계와,
정말로 깊은 수수께끼를 밝히는 데에는, \PASCAL\ 실행 시간 검사와 디버거를 비롯한 도구 몇 가지를 더 넣어 \TeX을 컴파일할 수 있다.
오류 메시지 뒤에 `\.D'를 치면 |debug_help|라는 루틴도 작동한다. 이 루틴은 치명적 오류 때문에 \TeX이 굴복하기 바로 전에도
나타난다.
@^debugging@>
@^system dependencies@>

루틴 |debug_help|와의 접속은 원시적이지만, 중단점을 걸고 변수를 읽고 값을 바꿀 수 있게 해 주는 \PASCAL\ 디버거와 함께 쓰면 충분하다.
`\.{debug \#}'라는 재촉 기호를 받고 나면 음수(이것은 |debug_help|를 빠져나간다)나 0(이것은 중단점을 걸 수 있는 곳으로 가서 \PASCAL\
디버거와의 대화로 들어간다)을 치거나, 양수 |m|과 그 뒤에 인자 |n|을 친다. 두 수 |m|과 |n|의 뜻은 아래 프로그램을 보면 분명할 것이다.
(|m=13|이면 인자 |l|이 하나 더 있다.)
@.debug \#@>

보충: 원본은 이 프로시저를 디버깅할 때에만 컴파일한다. 이 번역에서는 늘 컴파일하지만 |debug|가 참일 때에만 불린다. 원본은
레이블 |breakpoint|에 번호 888을 매긴다. 원본의 |read(term_in,m)|은 \GO/의 |fmt.Fscan|으로 옮긴다.

@<마지막 순간의...@>=
func debug_help() { // 여러 가지를 보이는 루틴
	var k, l, m, n int32
	clear_terminal()
	for {
		wake_up_terminal()
		print_nl("debug # (-1 to exit):"); update_terminal()
@.debug \#@>
		fmt.Fscan(term_in.r, &m)
		if m < 0 {
			return
		} else if m == 0 {
			goto breakpoint // 선언한 모든 레이블에 적어도 한 번은 간다
		breakpoint:
			m = 0 // `BREAKPOINT'
		} else {
			fmt.Fscan(term_in.r, &n)
			switch m {
			@<|debug_help|의 번호 붙은 경우들@>
			default: print("?")
			}
		}
	}
}

@ @<|debug_help|의 번호 붙은...@>=
case 1: print_word(mem[n]) // |mem[n]|을 모든 꼴로 보인다
case 2: print_int(info(n))
case 3: print_int(link(n))
case 4: print_word(eqtb[n])
case 5: print_word(font_info[n])
case 6: print_word(save_stack[n])
case 7: show_box(n) // |show_box_depth|와 |show_box_breadth|로 줄여서 상자를 보인다
case 8:
	breadth_max = 10000; depth_threshold = pool_size - pool_ptr - 10
	show_node_list(n) // 상자를 온전히 보인다
case 9: show_token_list(n, null, 1000)
case 10: slow_print(n)
case 11: check_mem(n > 0) // 올바른지 검사한다; |n>0|이면 새로 쓰는 위치를 찍는다
case 12: search_mem(n) // |n|을 가리키는 포인터를 찾는다
case 13: fmt.Fscan(term_in.r, &l); print_cmd_chr(n, l)
case 14:
	for k = 0; k <= n; k++ {
		print(buffer[k])
	}
case 15: font_in_short_display = null_font; short_display(n)
case 16: panicking = !panicking

@* 확장.
위의 프로그램에는 \TeX의 기본 구조를 흐트러뜨리지 않고 기능을 더 보탤 수 있게 해 주는 ``갈고리''가 여럿 들어 있다. 이 갈고리의
대부분은 특별한 목적에 쓰려는 ``whatsit'' 노드에 관련되어 있다. \TeX의 새 확장이 새 종류의 whatsit 노드를 끌어들일 때마다,
그런 노드를 다루는 아래 루틴들을 그에 맞게 바꾸어야 한다. 그러나 대개는 이 프로그램의 다른 부분을 많이 바꿀 필요는 없을 것이다.

확장을 어떻게 만들 수 있는지 보여 주려고, `\.{\\write}', `\.{\\openout}', `\.{\\closeout}', `\.{\\immediate}', `\.{\\special}',
`\.{\\setlanguage}'를 마치 확장인 것처럼 다루겠다. 이 명령들은 실은 \TeX의 원시 명령이고, 이 시스템의 모든 구현에 나타나야 한다.
그러나 그렇지 않다고 상상해 보자. 그러면 아래 프로그램은 누군가가 그것들을 어떻게 보탤 수 있는지 보여 준다.

물론 때로는 확장이 \TeX 자체를 바꾸어야 할 것이다. 어떤 갈고리 체계도 생각할 수 있는 모든 확장에 넉넉할 만큼 완전할 수는 없다.
명령 `\.{\\write}'에 관련된 기능은 거의 모두 다음 문단들에 국한되지만, |print_ln|과 |print_char| 프로시저에는 특별히 \.{\\write} 문자를
위해 들여온 작은 부분들이 있다. 게다가 훑개가 알아보는 토큰 목록 가운데 하나가 |write_text|이고, 이미 \.{\\write}의 어떤 면을
위해 마련해 둔 잡다한 곳이 몇 군데 더 있다. \TeX을 확장하는 사람의 목표는 프로그램의 표준 부분을 바꾸는 일을 최소로 줄이고,
할 수 있으면 아예 피하는 것이어야 한다. 그 사람은 또 \TeX이 이미 가진 표준 기능으로 원하는 목표를 이룰 쉬운 길이 없다는 것을
확실히 해야 한다. ``확장하기 전에 세 번 생각하라.'' 그러면 많은 일을 덜 수 있고, 서로 맞지 않는 \TeX의 확장이 퍼지는 것도 막을
수 있다.
@^system dependencies@>
@^extensions to \TeX@>

@ 먼저 \.{\\write}와 그 친척들에 딸린 자료를 나타내는 데 쓰는 whatsit 노드의 꼴을 생각해 보자. whatsit은 |type=whatsit_node|이고,
|subtype|이 여러 종류의 whatsit을 구별한다는 것을 떠올리자. 각 노드는 두 낱말 이상을 차지한다. 그 정확한 수는 |subtype|이나 다른
자료로 쉽게 정할 수 있기만 하면 상관없다.

여기서는 제어 시퀀스 \.{\\openout}, \.{\\write}, \.{\\closeout}, \.{\\special}, \.{\\setlanguage}에 대응하는 |subtype| 값 다섯을
들여온다. 입출력 whatsit의 둘째 낱말에는 쓰기 스트림 번호(0부터 15까지, 범위를 벗어난 양수면 16, 범위를 벗어난 음수면 17)를
나타내는 |write_stream| 필드가 있다. 명령 \.{\\write}와 \.{\\special}에는 보낼 토큰 목록의 참조 횟수를 가리키는 필드도 있다.
그리고 \.{\\openout}에는 이름, 영역, 확장자의 문자열 번호를 담을 세 낱말과 보조 하위 필드 셋이 필요하다.

@<정의@>=
const (
	@!write_node_size = 2 // write/whatsit 노드의 낱말 수
	@!open_node_size = 3 // open/whatsit 노드의 낱말 수
	@!open_node = 0 // \.{\\openout}할 파일을 나타내는 whatsit의 |subtype|
	@!write_node = 1 // \.{\\write}할 것을 나타내는 whatsit의 |subtype|
	@!close_node = 2 // \.{\\closeout}할 스트림을 나타내는 whatsit의 |subtype|
	@!special_node = 3 // \.{\\special}한 것을 나타내는 whatsit의 |subtype|
	@!language_node = 4 // 현재 언어를 바꾸는 whatsit의 |subtype|
)

func what_lang(p pointer) halfword { return link(p + 1) } // 언어 번호; |0..255|
func set_what_lang(p pointer, v halfword) { set_link(p+1, v) }
func what_lhm(p pointer) quarterword { return type_(p + 1) } // 최소 왼쪽 조각; |1..63|
func set_what_lhm(p pointer, v quarterword) { set_type(p+1, v) }
func what_rhm(p pointer) quarterword { return subtype(p + 1) } // 최소 오른쪽 조각; |1..63|
func set_what_rhm(p pointer, v quarterword) { set_subtype(p+1, v) }

@ \dg 앞 절의 정의가 이어진다.

@<정의@>=
func write_tokens(p pointer) halfword { return link(p + 1) } // 쓸 토큰 목록의 참조 횟수
func set_write_tokens(p pointer, v halfword) { set_link(p+1, v) }
func write_stream(p pointer) halfword { return info(p + 1) } // 스트림 번호(0부터 17까지)
func set_write_stream(p pointer, v halfword) { set_info(p+1, v) }
func open_name(p pointer) str_number { return link(p + 1) } // 열 파일 이름의 문자열 번호
func set_open_name(p pointer, v str_number) { set_link(p+1, v) }
func open_area(p pointer) str_number { return info(p + 2) } // |open_name|의 파일 영역의 문자열 번호
func set_open_area(p pointer, v str_number) { set_info(p+2, v) }
func open_ext(p pointer) str_number { return link(p + 2) } // |open_name|의 파일 확장자의 문자열 번호
func set_open_ext(p pointer, v str_number) { set_link(p+2, v) }

@ 열여섯 가지 가능한 \.{\\write} 스트림은 배열 |write_file|로 나타낸다. 원소 |write_open[j]|가 |true|일 때, 그리고 오직 그때에만 |j|번째
파일이 열려 있다. 마지막 두 스트림은 특별하다. 곧 |write_open[16]|은 15보다 큰 스트림 번호를 나타내고, |write_open[17]|은 음수 스트림
번호를 나타내며, 이 두 변수는 늘 |false|다.

@<전역 변수@>=
var @!write_file [16]alpha_file
var @!write_open [18]bool

@ @<핵심 변수들의...@>=
for k = 0; k <= 17; k++ {
	write_open[k] = false
}

@ 확장은 새 명령 코드를 들여올 수도 있다. 그러나 할 수 있으면 |extension|에 변경자를 붙여 쓰는 것이 가장 좋다. 그러면
|main_control|이 그대로 남는다.

@<정의@>=
const (
	@!immediate_code = 4 // \.{\\immediate}의 명령 변경자
	@!set_language_code = 5 // \.{\\setlanguage}의 명령 변경자
)

@ \dg 앞 절의 원시 명령들을 해시 표에 넣는다.

@<\TeX의 원시 명령을...@>=
primitive("openout", extension, open_node)
@!@:open_out_}{\.{\\openout} primitive@>
primitive("write", extension, write_node); write_loc = cur_val
@!@:write_}{\.{\\write} primitive@>
primitive("closeout", extension, close_node)
@!@:close_out_}{\.{\\closeout} primitive@>
primitive("special", extension, special_node)
@!@:special_}{\.{\\special} primitive@>
primitive("immediate", extension, immediate_code)
@!@:immediate_}{\.{\\immediate} primitive@>
primitive("setlanguage", extension, set_language_code)
@!@:set_language_}{\.{\\setlanguage} primitive@>

@ 방금 들여온 변수 |write_loc|은 ``폭주한'' 쓰기 텍스트가 있을 때 알맞은 오류 메시지를 주는 데 쓰인다.

@<전역 변수@>=
var @!write_loc pointer // \.{\\write}의 |eqtb| 주소

@ @<원시 명령의 이름을 찍는...@>=
case extension:
	switch chr_code {
	case open_node: print_esc("openout")
	case write_node: print_esc("write")
	case close_node: print_esc("closeout")
	case special_node: print_esc("special")
	case immediate_code: print_esc("immediate")
	case set_language_code: print_esc("setlanguage")
	default: print("[unknown extension!]")
	}

@ 명령 |extension|이 어느 모드에서든 |main_control|에 나타나면 루틴 |do_extension|을 부른다.

@<\TeX의 확장을 위한...@>=
case vmode + extension, hmode + extension, mmode + extension: do_extension()

@ @<|main_control|이 쓰는 동작...@>=
@<|do_extension|에 필요한 프로시저들@>@;
func do_extension() {
	var k int32 // 만능 정수
	var p pointer // 만능 포인터
	switch cur_chr {
	case open_node: @<\.{\\openout}을 구현한다@>
	case write_node: @<\.{\\write}를 구현한다@>
	case close_node: @<\.{\\closeout}을 구현한다@>
	case special_node: @<\.{\\special}을 구현한다@>
	case immediate_code: @<\.{\\immediate}를 구현한다@>
	case set_language_code: @<\.{\\setlanguage}를 구현한다@>
	default: confusion("ext1")
@:this can't happen ext1}{\quad ext1@>
	}
}

@ 다음은 주어진 |subtype|과 주어진 낱말 수를 가진 whatsit 노드를 만드는 서브루틴이다. whatsit의 첫 낱말만 초기화하고, 그것을
현재 목록에 덧붙인다.

보충: 원본의 |do_extension|은 만능 변수로 |i|, |j|, |k|, |p|, |q|, |r|을 선언하지만, |k|와 |p| 말고는 쓰지 않는다. \GO/는 쓰지
않는 지역 변수를 허락하지 않으므로 그것들은 뺐다.

@<|do_extension|에 필요한...@>=
func new_whatsit(s small_number, w small_number) {
	var p pointer // 새 노드
	p = get_node(w); set_type(p, whatsit_node); set_subtype(p, s)
	set_link(tail, p); tail = p
}

@ 다음 서브루틴은 |cur_chr|로 어떤 종류의 whatsit인지 정하고, |write_stream| 번호도 넣는다.

@<|do_extension|에 필요한...@>=
func new_write_whatsit(w small_number) {
	new_whatsit(cur_chr, w)
	if w != write_node_size {
		scan_four_bit_int()
	} else {
		scan_int()
		if cur_val < 0 {
			cur_val = 17
		} else if cur_val > 15 {
			cur_val = 16
		}
	}
	set_write_stream(tail, cur_val)
}

@ @<\.{\\openout}을 구현한다@>=
new_write_whatsit(open_node_size)
scan_optional_equals(); scan_file_name()
set_open_name(tail, cur_name); set_open_area(tail, cur_area); set_open_ext(tail, cur_ext)

@ 명령 `\.{\\write 12\{...\}}'가 나타나면 토큰 목록 `\.{\{...\}}'를 그 매크로를 펼치지 않고 훑는다. 매크로는 나중에 이 토큰 목록을 다시
훑을 때 펼친다.

@<\.{\\write}를 구현한다@>=
k = cur_cs; new_write_whatsit(write_node_size)
cur_cs = k; p = scan_toks(false, false); set_write_tokens(tail, def_ref)

@ @<\.{\\closeout}을 구현한다@>=
new_write_whatsit(write_node_size); set_write_tokens(tail, null)

@ 명령 `\.{\\special\{...\}}'가 나타나면 \.{\\xdef}와 \.{\\mark}에서처럼 토큰 목록의 매크로를 펼친다.

@<\.{\\special}을 구현한다@>=
new_whatsit(special_node, write_node_size); set_write_stream(tail, null)
p = scan_toks(false, true); set_write_tokens(tail, def_ref)

@ 우리 자료 구조에 나타나는 새 종류의 노드는 모두 보이고, 베끼고, 없애는 따위를 할 수 있어야 한다. 쓰기 관련 whatsit에 필요한
루틴은 표시 노드의 루틴과 조금 비슷하다. 물론 다른 확장에서는 여기서 더 미묘한 것이 끼어들 수도 있다.

@<기본 인쇄...@>=
func print_write_whatsit(s string, p pointer) {
	print_esc(s)
	if write_stream(p) < 16 {
		print_int(write_stream(p))
	} else if write_stream(p) == 16 {
		print_char('*')
	} else {
@.*\relax@>
		print_char('-')
	}
}

@ @<whatsit 노드 |p|를 보인다@>=
switch subtype(p) {
case open_node:
	print_write_whatsit("openout", p)
	print_char('='); print_file_name(open_name(p), open_area(p), open_ext(p))
case write_node:
	print_write_whatsit("write", p)
	print_mark(write_tokens(p))
case close_node: print_write_whatsit("closeout", p)
case special_node:
	print_esc("special")
	print_mark(write_tokens(p))
case language_node:
	print_esc("setlanguage")
	print_int(what_lang(p)); print(" (hyphenmin ")
	print_int(what_lhm(p)); print_char(',')
	print_int(what_rhm(p)); print_char(')')
default: print("whatsit?")
}

@ @<whatsit 노드 |p|의 부분 사본 |r|를...@>=
switch subtype(p) {
case open_node: r = get_node(open_node_size); words = open_node_size
case write_node, special_node:
	r = get_node(write_node_size)
	add_token_ref(write_tokens(p)); words = write_node_size
case close_node, language_node: r = get_node(small_node_size); words = small_node_size
default: confusion("ext2")
@:this can't happen ext2}{\quad ext2@>
}

@ @<whatsit 노드 |p|를 지우고...@>=
switch subtype(p) {
case open_node: free_node(p, open_node_size)
case write_node, special_node:
	delete_token_ref(write_tokens(p))
	free_node(p, write_node_size); goto done
case close_node, language_node: free_node(p, small_node_size)
default: confusion("ext3")
@:this can't happen ext3}{\quad ext3@>
}
goto done

@ @<whatsit 노드를 세로 상자에...@>=
// 아무것도 하지 않는다

@ @<whatsit 노드를 가로 상자에...@>=
// 아무것도 하지 않는다

@ @<|d|를 whatsit |p|의 너비로...@>=
d = 0

@ 보충: 원본의 매크로 |adv_past(#)|는 두 곳에서 쓰이고 전역 변수만 쓰므로 함수로 옮긴다.

@<정의@>=
func adv_past(p pointer) {
	if subtype(p) == language_node {
		cur_lang = what_lang(p); l_hyf = what_lhm(p); r_hyf = what_rhm(p)
	}
}

@ \dg 앞 절의 코드부를 옮긴다.

@<|line_break| 루프에서 whatsit 노드를...@>=
adv_past(cur_p)

@ @<하이픈 넣기 전처리 루프에서 whatsit...@>=
adv_past(s)

@ @<whatsit |p|를 현재 쪽으로...@>=
goto contribute

@ @<|vert_break| 루프에서 whatsit...@>=
goto not_found

@ @<세로 목록에서 whatsit 노드...@>=
out_what(p)

@ @<가로 목록에서 whatsit 노드...@>=
out_what(p)

@ 이 모든 예비 작업을 마치고, 마침내 요청된 자료를 실제로 내보내는 루틴들에 이르렀다. 명령 \.{\\special}부터 하자(그것이 더 쉽다).

@<|hlist_out|과 |vlist_out|에 필요한...@>=
func special_out(p pointer) {
	var old_setting int32 // 찍기 |selector|를 담아 둔다; |0..max_selector|
	var k pool_pointer // |str_pool|의 첨자
	synch_h(); synch_v()
	old_setting = selector; selector = new_string
	show_token_list(link(write_tokens(p)), null, pool_size-pool_ptr)
	selector = old_setting
	str_room(1)
	if cur_length() < 256 {
		dvi_out(xxx1); dvi_out(cur_length())
	} else {
		dvi_out(xxx4); dvi_four(cur_length())
	}
	for k = str_start[str_ptr]; k <= pool_ptr-1; k++ {
		dvi_out(so(str_pool[k]))
	}
	pool_ptr = str_start[str_ptr] // 문자열을 지운다
}

@ 토큰 목록을 쓰려면 그것을 \TeX의 훑개에 통과시켜서 매크로와 \.{\\the}와 \.{\\number} 따위를 펼쳐야 한다. 그러면 구분된 매크로
매개변수가 짝을 찾지 못할 때 폭주가 일어날 수 있다. 우리는 \.{\\shipout} 명령 한가운데에서 \TeX의 훑개를 부르고 있으므로, 폭주는
몹시 헷갈릴 것이다. 그래서 토큰 목록 바로 뒤에 가짜 제어 시퀀스를 ``마개''로 놓는다. 이 제어 시퀀스는 인위적으로 \.{\\outer}로
정의된다.
@:end_write_}{\.{\\endwrite}@>

@<표의 항목들을 초기화한다...@>=
set_text(end_write, str("endwrite")); set_eq_level(end_write, level_one)
set_eq_type(end_write, outer_call); set_equiv(end_write, null)

@ @<|hlist_out|과 |vlist_out|에 필요한...@>=
func write_out(p pointer) {
	var old_setting int32 // 찍기 |selector|를 담아 둔다; |0..max_selector|
	var old_mode int32 // 저장된 |mode|
	var j small_number // 쓰기 스트림 번호
	var q, r pointer // 목록을 다루는 임시 변수
	@<토큰 목록의 매크로를 펼치고 |link(def_ref)|가 그 결과를 가리키게 한다@>
	old_setting = selector; j = write_stream(p)
	if write_open[j] {
		selector = j
	} else { // 파일이 열려 있지 않으면 터미널에 쓴다
		if j == 17 && selector == term_and_log {
			selector = log_only
		}
		print_nl("")
	}
	token_show(def_ref); print_ln()
	flush_list(def_ref); selector = old_setting
}

@ 이 루틴의 마지막 줄은 조금 미묘하다. 적어도 저자는 데어 보기 전까지는 그것을 생각하지 못했다! 스택에는 다 쓴 토큰 목록이 하나
@^Knuth, Donald Ervin@>
있다. 곧 |end_write_token|을 담았던 것이다. (위에서 설명했듯이 폭주를 막으려고 이 인위적인 `\.{\\endwrite}'를 끼워 넣는다.)
그것을 없애지 않으면, 한 쪽에 쓰기가 많을 때 스택이 넘칠 것이다.

@<정의@>=
const @!end_write_token = cs_token_flag + end_write

@ \dg 앞 절의 코드부를 옮긴다. 토큰 목록 앞뒤에 중괄호와 `\.{\\endwrite}'를 끼워 넣어
`\.\{$\langle\,$토큰 목록$\,\rangle$\.{\} \\endwrite}'를 만든 다음 그것을 훑는다.

@<토큰 목록의 매크로를 펼치고...@>=
q = get_avail(); set_info(q, right_brace_token+'}')
r = get_avail(); set_link(q, r); set_info(r, end_write_token); ins_list(q)
begin_token_list(write_tokens(p), write_text)
q = get_avail(); set_info(q, left_brace_token+'{'); ins_list(q)
old_mode = mode; mode = 0
// \.{\\prevdepth}, \.{\\spacefactor}, \.{\\lastskip}, \.{\\prevgraf}를 끈다
cur_cs = write_loc; q = scan_toks(false, true) // 매크로 따위를 펼친다
get_token()
if cur_tok != end_write_token {
	@<균형이 맞지 않는 쓰기 명령에서 회복한다@>
}
mode = old_mode
end_token_list() // 스택 공간을 아낀다

@ @<균형이 맞지 않는 쓰기 명령에서...@>=
print_err("Unbalanced write command")
@.Unbalanced write...@>
help2("On this page there's a \\write with fewer real {'s than }'s.",
	"I can't handle that very well; good luck.")
error()
for {
	get_token()
	if cur_tok == end_write_token {
		break
	}
}

@ 프로시저 |out_what|는 |vlist_out|과 |hlist_out|을 위해 whatsit 노드를 출력하는 일을 맡는다.

@<|hlist_out|과 |vlist_out|에 필요한...@>=
func out_what(p pointer) {
	var j small_number // 쓰기 스트림 번호
	switch subtype(p) {
	case open_node, write_node, close_node: @<\.{\\write}를 위해 미루어 둔 일을 한다@>
	case special_node: special_out(p)
	case language_node: // 아무것도 하지 않는다
	default: confusion("ext4")
@:this can't happen ext4}{\quad ext4@>
	}
}

@ 리더 안의 \.{\\write}는 구현하지 않는다. (그 까닭은 리더 상자가 나타나는 횟수가 글루 계산의 기계 의존적 반올림 때문에 구현마다
다를 수 있기 때문이다.)
@^leaders@>

@<\.{\\write}를 위해 미루어 둔...@>=
if !doing_leaders {
	j = write_stream(p)
	if subtype(p) == write_node {
		write_out(p)
	} else {
		if write_open[j] {
			a_close(&write_file[j])
		}
		if subtype(p) == close_node {
			write_open[j] = false
		} else if j < 16 {
			cur_name = open_name(p); cur_area = open_area(p)
			cur_ext = open_ext(p)
			if cur_ext == str("") {
				cur_ext = str(".tex")
			}
			pack_cur_name()
			for !a_open_out(&write_file[j]) {
				prompt_file_name("output file name", ".tex")
			}
			write_open[j] = true
		}
	}
}

@ 접두어 `\.{\\immediate}'가 있으면 프로시저 |do_extension|은 재귀를 한 수준 내려간다. 그 뒤에 `\.{\\openout}'이나
`\.{\\write}'나 `\.{\\closeout}'이 오지 않으면 아무 일도 일어나지 않는다.
@^recursion@>

@<\.{\\immediate}를 구현한다@>=
get_x_token()
if cur_cmd == extension && cur_chr <= close_node {
	p = tail; do_extension() // whatsit 노드를 덧붙인다
	out_what(tail) // 그 동작을 곧바로 한다
	flush_node_list(tail); tail = p; set_link(p, null)
} else {
	back_input()
}

@ 확장 \.{\\language}는 조금 다르다. 현재 언어 |clang|이 아닌 언어의 문자를 현재 문단에 덧붙일 때 작동하는 서브루틴이 필요하다.

@<|main_control|이 쓰는 동작...@>=
func fix_language() {
	var l ASCII_code // 새 현재 언어
	if language() <= 0 {
		l = 0
	} else if language() > 255 {
		l = 0
	} else {
		l = language()
	}
	if l != clang() {
		new_whatsit(language_node, small_node_size)
		set_what_lang(tail, l); set_clang(l)
		set_what_lhm(tail, norm_min(left_hyphen_min()))
		set_what_rhm(tail, norm_min(right_hyphen_min()))
	}
}

@ @<\.{\\setlanguage}를 구현한다@>=
if abs(mode) != hmode {
	report_illegal_case()
} else {
	new_whatsit(language_node, small_node_size)
	scan_int()
	if cur_val <= 0 {
		set_clang(0)
	} else if cur_val > 255 {
		set_clang(0)
	} else {
		set_clang(cur_val)
	}
	set_what_lang(tail, clang())
	set_what_lhm(tail, norm_min(left_hyphen_min()))
	set_what_rhm(tail, norm_min(right_hyphen_min()))
}

@ @<확장들을 마무리한다@>=
for k = 0; k <= 15; k++ {
	if write_open[k] {
		a_close(&write_file[k])
	}
}

@* 시스템에 따른 변경.
필요하면 이 부분을 \TeX이 특정 설치에서 작동하는 데 필요한 특별한 수정으로 바꾸어야 한다. 대개는 변경 파일을 설계할 때 앞
절들에 대한 모든 변경이 절 번호를 지키게 하는 것이 가장 좋다. 그러면 모두의 판이 출판된 프로그램과 맞을 것이다. 새 절을
들여오는 더 큰 변경은 여기에 끼워 넣을 수 있다. 그러면 찾아보기만 새 절 번호를 얻는다.
@^system dependencies@>

보충: 이 번역에서 시스템에 따른 변경은 해당하는 곳마다 `보충'으로 밝혀 두었다. 이를테면 파일 이름과 파일 찾기(\os{514}
부근), 터미널 입력(\os{37}), 낱말 파일의 형식(\os{1305} 부근), 바깥 레이블로 가는 |goto|(\os6, \os{1332})가 그렇다.

@* 찾아보기.
다음은 프로그램에서 각 식별자가 쓰인 곳을 모두 찾을 수 있는 곳이다. 밑줄 친 항목은 그 식별자가 정의된 곳에 해당한다. 오류
메시지와 ``이런 일은 일어날 수 없다'' 따위의 다른 흥미로운 것들도 찾아볼 수 있다. 특히 ``system dependencies''라는 항목을
보면, 다른 컴퓨터에 \TeX을 설치할 때 바꾸어야 할지도 모르는 모든 곳을 찾을 수 있다. 미리 정해 둔 구성 이름 아래에는 \TeX의
그 부분을 이해하는 데 도움이 될 곳들이 모여 있다.
