---
title: latex 参考文献生成(总结)
date: '2020-08-13'
categories: latex
---


生成latex参考文献大致有4种方法.....

使用环境: `MacTeX 2018 + texstudio`, texstudio编译器改为xelatex

## 0. 什么是`*.bib` 文件

注意: 后面三种,都将涉及bib文件, 如何生成bib文件, 我们可以建立一个后缀名为`.bib`的文件,这里我建立一个bib文件, 如`text.bib`,  去google学术或百度学术找一篇文献,这里我随便找了一篇文献如下:

![image-20200809111644929](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809111644929.png)

![image-20200809111700803](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809111700803.png)

![image-20200809111722093](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809111722093.png)

把上图的内容复制到我们所创建的`test.bib`文件中即可. 

**注意: 生成参考文献的好坏,80% 都看你的bib数据文件**



## 1. 使用 `thebibliography` 环境-- 手动书写

使用格式:

```tex
\begin{thebibliography}{99}
		\bibitem{citekey1} ***自己书写参考文献***
		\bibitem{citekey2} ***自己书写参考文献***
		.....
\end{thebibliography}
```

完整的案例如下:

```latex
\documentclass{article}

\usepackage{ctex}%加载ctex宏包，中文支持

\begin{document}
	
	测试文档，参考文献\cite{hosseini2016modeling,wang2019snow}
	\begin{thebibliography}{99}
		\bibitem{hosseini2016modeling}	Hosseini~S, Barker~K. Modeling infrastructure resilience using {{Bayesian}} networks: {{A}}	case study of inland waterway ports [J]. Computers \& Industrial Engineering, 2016, 93: 252-266.
		\bibitem{wang2019snow}
		Wang~J, Liu~H. Snow removal resource location and allocation optimization for urban
		road network recovery: a resilience perspective [J]. Journal of Ambient Intelligence and Humanized Computing, 2019,
		10\penalty0 (1): 395-408.
	\end{thebibliography}
\end{document}
```

**个人不推荐**

## 2. 使用 `*.bst` 文件 -- 自动生成

texlive 2018 系统自带的bst文件数量大致有375个

```powershell
$ cd  /usr/local/texlive/2018/texmf-dist/bibtex/bst 
$ find . -name *.bst | WC -l
```

系统默认的参考文献风格在目录`base`中

```powershell
$ cat /usr/local/texlive/2018/texmf-dist/bibtex/bst/base
```

一共8种,为最基本的参考文献风格样式, 解释如下

```bash
plain，按字母的顺序排列，比较次序为作者、年度和标题.
unsrt，样式同plain，只是按照引用的先后排序.
alpha，用作者名首字母+年份后两位作标号，以字母顺序排序.
abbrv，类似plain，将月份全拼改为缩写，更显紧凑.
ieeetr，国际电气电子工程师协会期刊样式.
acm，美国计算机学会期刊样式.
siam，美国工业和应用数学学会期刊样式.
apalike，美国心理学学会期刊样式.
```

如果系统自带---- 一般情况下直接使用就好,  案例如下

```latex
\documentclass{article}
\usepackage{ctex}%加载ctex宏包，中文支持
\begin{document}

测试文档，参考文献\cite{xu2018methods,xu2014weak}

\bibliographystyle{unsrt} % unsrt 可以替换为任意风格的样式文件
\bibliography{test}% 这里填写bib文件名,无后缀

\end{document}
```

生成的pdf截图如下:

![image-20200809112144024](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809112144024.png)

比如我要使用`/usr/local/texlive/2018/texmf-dist/bibtex/bst/elsarticle/elsarticle-num-names.bst  ` 这个参考文献样式, 只需直接替换使用即可,如下,

```latex
\documentclass{article}
\usepackage{ctex}%加载ctex宏包，中文支持
\begin{document}
	测试文档，参考文献\cite{xu2018methods,xu2014weak}
	\bibliographystyle{elsarticle-num-names}
	\bibliography{test}
\end{document}
```

**还有一种方法, 把对应的bst文件拷贝到当前目录使用(当然,你也可以指定bst文件的具体路径), 然后在使用即可.**

当然有些期刊自己会提供对应的` *.bst`样式文件, 那么安照期刊的要求来即可.

顺便提一句,  通过 `*.bst`生成的参考文献当前目录会生成一个后缀名为`.bbl`的文件,你可以打开它, 里面是一个完整的 ` thebibliography ` 环境, 即可以通过`bst`文件自动生成`thebibliography`环境里面的条目信息.

补充: 

我要投稿,怎么知道是用哪个`*.bst`文件, 一般情况下期刊官网会提供, 若没有提供,按以下步骤查找

1. 首先记住你要准备投的期刊, 然后在 [这个网站]( https://csl.mendeley.com/searchByName/ )搜索, 一般情况下, 你准备的期刊参考文献有一个别名, 说白了可能是其他期刊的文献格式, 于是你找到那个别名.
2. 然后在目录`/usr/local/texlive/2018/texmf-dist/bibtex/bst `下去搜索你要的bst 参考文献

备注:

[爱思唯尔(Elsevier)期刊模板:](https://www.elsevier.com/authors/author-schemas/latex-instructions)

[latex 官网自带的 elsevier 模板:]( https://www.ctan.org/pkg/elsarticle)

## 3. 使用`*.csl` 样式文件 -- 自动生成

由于`Zotero`软件提供了大量的`csl`样式文件,大致接近[1万个参考文献样式](https://www.zotero.org/styles),  而 latex 软件本身是不能直接支持`csl`文件的

- 方法一: 可以使用 像`Zotero, Mendeley` 软件支持, 但是不能像`bst`文件那样使用,只能手动粘贴.参考文献数量多了,自然不方便
- 方法二: 借助 [pandoc](https://www.pandoc.org/) , 该软件提供了大量命令参数, 感兴趣的可以去探索,  而xieyihui 通过使用`*.Rmd`文件进行了封装(前提要安装并了解`R + Rstudio`),  个人在巨人的肩上, 进行了简单封装,提供了一个R包[journalabbr](https://github.com/zoushucai/journalabbr)提供了一个本地app 和一个[在线app](https://zoushucai.shinyapps.io/shiny_cankaowenxian/), 该app提供期刊缩写, 美化bib数据库文件以及提供类似`bst`文件那样批量生成一个完整的 ` thebibliography ` 环境. app截图如下:


![image-20200809120534362](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809120534362.png)

## 4. 使用biblatex -- 未来的版本

这里仅以国标gb7714为例子

首先把texstudio编译器改为xelatex, 并把bibtex 后端改为 biber. , 提供一个案例如下

```latex
\documentclass{article}
\usepackage{ctex}%加载ctex宏包，中文支持

\usepackage[backend = biber, style=gb7714-2015,gbnamefmt =  lowercase,
gbbiblabel=bracket]{biblatex}
\addbibresource[location=local]{test.bib}
\renewcommand{\bibfont}{\zihao{5}\songti}%设置参考文献的字体和字号
\setlength{\bibitemsep}{2pt}%设置各条参考文献之间的间距为2pt

\begin{document}
	测试文档，参考文献\cite{xu2018methods,xu2014weak}

\printbibliography[heading=bibliography,title=参考文献]
\end{document}


```

更多,可参考
[biblatex-gb7714-2015](https://github.com/hushidong/biblatex-gb7714-2015)

[biblatex参考文献和引用样式caspervector.pdf](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020072916biblatex参考文献和引用样式caspervector.pdf)

[biblatex-zh-cn](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020072916biblatex-zh-cn.pdf)

[biblatex-solution-to-latex-bibliography](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020072916biblatex-solution-to-latex-bibliography.pdf)

[biblatex-gb7714-2015](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020072916biblatex-gb7714-2015.pdf)

关于 国标gb7714 我们后面在进一步介绍.
