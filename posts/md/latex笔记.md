---
title: latex 笔记
date: '2020-08-10'
categories:
  - mac
  - latex
---



## 1,  交叉引用

```latex
\eqref{eq:eq1}   :交叉引用公式编号自动带括号: 
```

## 2, 完整模板解析

```latex
\documentclass[review]{elsarticle}

%\usepackage{ctex}
\usepackage{lineno, hyperref}
\hypersetup{colorlinks=true, citecolor=blue, anchorcolor=blue}


\modulolinenumbers[5]

%\usepackage[colorlinks, linkcolor=blue, anchorcolor=blue, citecolor=blue]{hyperref}

\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{amsthm}

\usepackage[american]{babel} % 具有多语种处理功能的宏包,英文为默认文字,和microtype包一起使用,用于页面两端对齐
\usepackage{microtype} % 用于页面两端对齐

\usepackage{graphicx} % 插图包 ---  \includegraphics[height=高度][angle=旋转角度]{图片文件名}
\usepackage{multirow} % 处理表格 --列合并用”\multicolumn“，行合并用。\multirow{2}{*}{显示的文本}
% 引用 ---  \multirow 函数/标志符： {占用行数} {方框边界竖线|文字居左中右|方框边界竖线} {内容}
% 引用 --- \multicolumn 函数/标志符： {占用列数} {方框边界竖线|文字居左中右|方框边界竖线} {内容}

\usepackage{indentfirst} %段首缩进需要的宏包 
\setlength{\parindent}{2em}%设置段首缩进两个汉字 %\noindent强制不缩进
% \setlength{\parskip}{1em}%paragraph skip,调整的是段落间距离

%\usepackage{lscape} % 表格横置, 只需要引用 landscape 环境即可
%\usepackage{pdflscape} % 页面横置,只需引用landscape环境即可
%\usepackage[figuresright]{rotating} % 将表格旋转为纵向放置，使用rotating宏包 % 要使用 sidewaystable 环境
%\usepackage{natbib}\usepackage[authoryear]{natbib}

\usepackage{enumerate} % enumerate 宏包 ,可以给有序列表设置 label,以及有缩进
%\usepackage{enumitem} % 可以给出缩进调整间距, label
%\usepackage{showkeys} % 引用时显示引用的 label
%\usepackage{paralist} % 列表相互嵌套是的缩进 ,也可以给出相应 label ,但是 label 和缩进都要设置


%%%%%%  交叉引用 开始%%%%%%%
%% 第一部分 自定义新环境,
\theoremstyle{definition} %自定义环境内的风格,比如字体是否为斜体,等等,这里采用的是正体
\newtheorem{thm}{Theorem}
\newtheorem{cor}{Corollary}
\newtheorem{lem}{Lemma}
\newtheorem{pot}{\bf Proof}
\newtheorem{rmk}{Definition}
\newtheorem{pro}{Property}
\newtheorem{example}{Example}
%\newtheorem{exmp}{Example}

%% 第二部分 ,如果想要在引用时,自动添加definition,Theorem等字样,使用下面这部分
\usepackage[capitalize, nameinlink]{cleveref} %交叉应用 在数字前自动添加某些字符; 引用时 用\cref{}的形式
\crefname{thm}{Theorem}{Theorems}
%\crefname{cor}{Corollary}{Corollarys}
\crefname{lem}{Lemma}{Lemmas}
\crefname{pot}{Proof} {Proofs} 
\crefname{rmk}{Definition}{Definitions} 
\crefname{pro}{Property}{Propertys}
\crefname{example}{Example}{Examples} 
\crefname{figure}{Figure}{Figures} % 图片以及表格有默认的,但是也可以重新定义
% \DeclareUnicodeCharacter{0301}{\'{e}} %pdflatex 需要用到 UTF-8 字符时，需要此命令

%%%%%%  交叉引用结束 %%%%%%%

\journal{European Journal of Operational Research}


% 参考文献的引用样式,可以去网上找各大期刊的模板
\bibliographystyle{elsarticle-harv}\biboptions{authoryear}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%一下为正文部分
\begin{document}
\section{Introduction}

\section{Preliminaries}
\section*{Acknowledgements} 

\setcitestyle{numbers}
\bibliography{references} % 这里引用的 bibtex 参考文献
\end{document}

```

注释: 

对自定义环境格式的设置

```latex
\theoremstyle{definition} %环境内的风格,比如字体是否为斜体,等等,这里采用的是正体
%\theoremstyle{plain} is the default. it sets the text in italic and adds extra space above and below the \newtheorems listed below it in the input. it is recommended for theorems, corollaries, lemmas, propositions, conjectures, criteria, and (possibly; depends on the subject area) algorithms.
%\theoremstyle{plain} 是默认值。它将文本设置为斜体，并在输入的\\newTheorem的上方和下方添加额外的空间。建议用于定理、推论、引理、命题、猜想、标准和（可能；取决于主题区域）算法。

%\theoremstyle{definition} adds extra space above and below, but sets the text in roman. it is recommended for definitions, conditions, problems, and examples; i've alse seen it used for exercises.
%\theoremstyle{definition} 在上方和下方添加额外的空格，但将文本设置为罗马文本。建议用于定义、条件、问题和示例；我也见过它用于练习。

%\theoremstyle{remark} is set in roman, with no additional space above or below. it is recommended for remarks, notes, notation, claims, summaries, acknowledgments, cases, and conclusions.
%\theoremstyle{remark} 设置为罗马，上面或下面没有额外的空间。建议用于备注、注释、注释、索赔、总结、确认、案例和结论。
```



2， 参考文献尽量使用`*.bib`的格式 ，这样方便管理，然后使用 `jabref`软件进行 ` *.bib` 文件格式的管理

3， `bib`文件可以用Google学术生成导出`bibtex`格式文件

4， 参考文献 -- 使用作者加年份排版 如下：（同时使用）,一般去网上找对应期刊的 bst 文件模板即可

```latex
\usepackage{natbib} %参考文献 
\setcitestyle{authoryear,round,comma,aysep={;},yysep={,},notesep={, }}
\usepackage{hyperref} %为了更加好看可以设置超链接颜色,首先要确保引用的包不能冲突，
\hypersetup{colorlinks=true,citecolor=blue} %设置超链接颜色
```

特别注意:::  有些模板以及引用了相关的包，这样会造成相应包的冲突，可以尝试：

1、 先不引用这个包以及相关设置，检查能否运行 --能进行下一步

2、 利用这个包的相关参数进行修改，看能否达到自己的目的 
```bash
zscdeMacBook-Air.local
```
如果以上还是出现包的冲突，则仔细检查

注意：：：

```latex
%\bibliographystyle{elsarticle-num} 
% 不能与  \setcitestyle{authoryear,round,comma,aysep={;},yysep={,},notesep={, }}同时使用
```



 5、 参考文献的使用

```latex
文章开始前：{document}前
\bibliographystyle{elsarticle-num}  % 使用模板自带的参考文献格式
% \bibliographystyle{plainnat} % 包自带的格式
% \setcitestyle{authoryear,round,comma,aysep={;},yysep={,},notesep={, }} % 简单的自定义格式 
%%注意以上三种不能冲突使用，只能择其一
文章结尾：使用 即可

\section*{References}
%%%%\setcitestyle{numbers} % 注意这里只是 修改参考文献的样式
\bibliography{references} % references.bib文件。即参考文献
\end{document}
```

6、现在很多文章的定理、定义、推论、例子都采用统一编号，不再是独立编号。如定义 1.1，接下来可能 是定理 1.2，然后推论 1.3，等等。这可以用如下的定义来完成: 

```latex
 \newtheorem{thm}{Theorem}[section] %如果不采用章节号做前缀，则不用[section] 
 
 \newtheorem{defn}[thm]{Definition} %这句定义使得defn环境和thm共享编号 
 
 \newtheorem{lem}[thm]{Lemma} %这句定义使得lem环境和thm共享编号
 
\newtheorem{thm}{Theorem}
\newtheorem{cor}{Corollary}
\newtheorem{lem}{Lemma}
\newtheorem{pot}{\bf Proof}
\newtheorem{rmk}{Definition}
\newtheorem{pro}{Property}

```

7、公式环境的区别

```latex
公式环境的区别： 参考latex入门(刘海洋)

gather 环境得到的公式每行居中
align环境允许按照等号或其他关系（只需要在关系符号前加 & ）对齐


组合公式快环境
cases 环境太特殊( 不推荐)
gathered  组合公式与要组合的公式 居中排列组合一个整体
aligned   类似align
alignedat
```

8 enumerate 编号缩进问题, 直接使用空格

```latex
\begin{enumerate}[\hspace{2em} 1). ]
    \item $A^*$ also is RC matrix.

    \item every row of matrix $A^*$ is arranged in ascending order.

    \item every column of matrix $A^*$ is arranged in descending order.
\end{enumerate}
```

