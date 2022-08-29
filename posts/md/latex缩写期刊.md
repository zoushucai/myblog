---
title: latex 缩写期刊
date: '2020-08-11'
categories:
  - latex
  - r
---


以下软件对参考文献都不能完美的满足我的要求, 因此可以结合不同软件的优势,达到最后的效果

## 1. zotero

设置—首选项—bitter bibtex —export — 最下面有一个期刊缩写,选购就能导出缩写的期刊名了

- 特点: 
	- 使用该软件, 系统自带的期刊缩写对照表很少, 且不能添加对照表,
	- 不会自动更新bib文件
	- 可以按照key键的顺序(升序) 导出bib数据库, 只需导出时选中[biter bibtex]选项即可
	- 也可以安装以前的方式导出bib数据库, 只需导出时选中[bibtex]选项即可

## 2. Mendeley

- 特点: 
	- 默认情况下, 联网会自动更新bib数据库, 这一点很烦(for me), 因此可以直接断网使用该软件
	- 期刊缩写很好,内置了很多比较全的期刊缩写.但某些期刊仍不全面,且缩写的格式看不见

![mendeley01](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/mendeley01.png)



![mendeley02](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/mendeley02.png)

## 3. Jabref软件

特点:

- 内置的期刊缩写相对较少, 但是可以手动添加期刊缩写列表(官网有), 就是电脑卡

- 由于bib文件中使用的是`\&` , 而jabref软件中默认使用`&`,  这样对照表中可能不会存在相应的缩写

- 不能导出按照key键顺序导出相应的bib文件

- 使用期刊缩写时,首先使用展开期刊全名,才去缩写,不然有可能找不到, 

- 不会自动更新bib文件

	下面是使用期刊缩写步骤, 先管理期刊缩写名(选择使用哪种类型的对照表),在进行期刊缩写

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/01.png)

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/02.png)

## 4. 自用软件包[journalabbr](https://github.com/zoushucai/journalabbr)

- 利用`Jabref`软件提供了大量的期刊缩写列表https://github.com/JabRef/abbrv.jabref.org,但是在`Jabref`软件中使用经常死机.
- 借助 [pandoc](https://www.pandoc.org/) , 该软件提供了大量命令参数, 感兴趣的可以去探索,  而xieyihui 通过使用`*.Rmd`文件进行了封装(前提要安装并了解`R + Rstudio`),  个人在巨人的肩上, 进行了简单封装,提供了一个R包[journalabbr](https://github.com/zoushucai/journalabbr)提供了一个本地app 和一个[在线app](https://zoushucai.shinyapps.io/shiny_cankaowenxian/), 解决了`Jabref`缩写期刊时遇到的缺点. 该app主要功能: 提供期刊缩写, 美化bib数据库文件以及提供类似`bst`文件那样批量生成一个完整的 ` thebibliography ` 环境. app截图如下:


![image-20200809120534362](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020081513image-20200809120534362.png)

