---
title: bib与enw文件之间的相互转换
date: '2020-07-29'
categories: latex
---


## `*.bib`  与`*.enw` 文件之间的相互转换

方法一: JabRef 软件

方法二: [`bibutils`](http://sourceforge.net/p/bibutils/home/Bibutils/)

为了将BibTeX转换为带标签的Endnote，只需调用：

```tex
$ bib2xml input.bib | xml2end > output.enw
```

转换为RIS类似于：

```tex
$ bib2xml input.bib | xml2ris > output.ris
```

