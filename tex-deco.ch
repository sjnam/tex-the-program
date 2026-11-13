@x
\def\title{\TeX82}
@y
\input pic

\def\FrameBG{\vbox to 0pt{\vskip-.72in
  \moveleft.63in\hbox{\pic width 7.55in height 11.05in{decoframe.pdf}}\vss}%
  \nointerlineskip}
\let\twillbackground=\FrameBG % gtwill이 짜는 펼침면에도 액자를 두른다
\def\plainoutput{\shipout\vbox{\FrameBG\makeheadline\pagebody\makefootline}%
  \advancepageno \ifnum\outputpenalty>-20000 \else\dosupereject\fi}
\def\coloutput{%
  \if L\lr
    \global\setbox\lbox=\box255 \gdef\lr{R}%
  \else
    \shipout\vbox{\FrameBG\runheadline
      \vbox to\pageheight{\boxmaxdepth=\maxdimen
        \box\sbox\vss
        \hbox to\pagewidth{\box\lbox\hfil\box255}}}%
    \global\advance\pageno by1
    \global\setbox\sbox=\vbox{}\global\vsize=\pageheight \gdef\lr{L}%
  \fi}

% 본문을 액자 아랫변까지 늘여, 액자와 내용 사이가 위아래 모두 39pt쯤 되게 한다
\pageheight=9.6in \vsize=\pageheight
\def\title{\TeX82}
@z
