---
title: Windows系统下R Markdown 设置中文pdf完美解决方案
date: '2018-03-10'
categories: rmarkdown
---


# 方法一： 生成pdf中文

后文有与之对应的方法。

需要安装完整版的CTeX_2.92套装（有没有感觉文件很大，文章最后教大家一个简单的安装版本），还要自己新建一个文本文件命名为`header.tex`,其内容为`\usepackage{ctex}` ,把这个文件和运行的rmarkdown文件保存在同级目录中，然后把rmarkdown的头文件yaml改写为如下情况：

```R
---
title: 'Untitled'
author: 'zsc'
date: "`r Sys.Date()`"
output:
  pdf_document:
  includes:
    in_header: header.tex
  keep_tex: yes
  latex_engine: xelatex
---
```

这样就可以生成中文的pdf了

于是我仿照上面的步骤，写了一个函数`rmarkdown_pdf` 保存为`rmarkdown_pdf.R`

```R
rmarkdown_pdf=function(file_name,new_filename=file_name){
cat("\\usepackage{ctex}\n", file = "header.tex")
txt="---
title: 'Untitled'
author: 'zsc'
date: \"`r Sys.Date()`\"
output:\n  pdf_document:\n    includes:\n      in_header: header.tex\n    keep_tex: yes\n    latex_engine: xelatex
---
"
x=readLines(file_name,n=-1,encoding = "UTF-8")
la=max(which(x=="---")[1:2])
cat(c(txt,x[(la+1):length(x)]),sep = "\n",file = new_filename,append = F)
rm(list = ls())
}

```

在把这个函数加载到自定义环境中，

- 第一步：安装目录找到Rprofile.site这个文件，我的是在“D:\R\etc”这个目录； 


- 第二步：用文本文件打开Rprofile.site，配置文件里按照R语言自定义函数的格式自定义一个函数保存即可。


```R
.First<-function(){
# 也可以加载包library(data.table)
# 加载函数
source("函数rmarkdown_pdf.R存放的路径")路径为1111/22/33 
}
```

这种设置，会产生很多的中间文件（系统并未自己删除），亲测成功：

![pdf1](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf1.png)



# 方法二： 生成pdf中文--用rticles包的模板

很久就知道谢意辉早就把rmarkdown可以转换为中文pdf的方案，一直没有尝试，今天尝试一下，结果失败了，我的电脑是win10 ，R的版本为3.4.3 ，安装了CTeX_2.92套装，我用的是rticles包中的模板文件，想测试一下中文pdf能否生成，结果报错如下（英文生成pdf没有问题）

![pdf3](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf3.png)

重点！重点！重点！来了

## CteX的版安装问题

原来是CteX的版本的问题 ----解决方案如下 

- (1)	卸载CteX(注意卸载干净)；

- (2)	然后到[MiKTek官网](https://miktex.org/download)下载最新版64位MiKTek软件并安装(当前最新版本:basic-miktex-2.9.6615-x64.exe);几乎就是next就好了（建议把安装目录改了）
- (3)	安装以后,直接在Rstudio中点击knitr生成中文的pdf，系统会自动调用MiKTek里面的文件，并弹出对话框将要安装下列的包，安装包的时候注意选择更新源（一般选择离自己较近的下载源（我选清华）） ，会自动安装很多的包，

![pdf4](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf4.png)

![pdf5](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf5.png)

![pdf6](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf6.png)

​	点击install就好了（每安装一个文件都要弹出对话框并让你点击安装，这样很麻烦，可以把always前面的√取消掉），直到rmarkdown可以生成中文为止。

- （4）这种安装的方法也实用与方法一也适合,如果卸载CteX的时候没卸载干净，后面卸载basic-miktex-2.9.6615的时候，总是报错，总之是不能卸载的，所以我每次卸载的时候都是直接删除安装的目录（为何要卸载，测试软件啊！！！！！），大功告成！！！


![pdf2](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/pdf2.png)

​	



所用以上操作--我是翻墙操作的，毕竟下载软件的时候比较快



## **补充：**

这个补充是我后面遇到的情况，忘记了，总是编译不通过，就连方法二都没通过，于是逐一排查电脑，后面电脑环境成功安装以后，进而进一步补充说明（2018年11月17日）  

 1. 如果没有用上述模板（rticles模板），想要Rmd 文件生成对应的中文，直接knitr是行不通的，会报以下错误，当然想要正常显示用模板方便很多啊！

    ![buchong01](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/buchong01.png)

```R
output file: test.knit.md

! Package inputenc Error: Unicode character 浣?(U+4F60)
(inputenc)                not set up for use with LaTeX.

错误: Failed to compile test.tex. See test.log for more info.
此外: Warning message:
In grepl("==> Fatal error occurred", x[i], fixed = TRUE) :
  输入的字符串1不适用于此语言环境
停止执行
    ```

 2. 方法一：如果Rmd中有中文，你想要正常显示，可以忽视中文，让中文显示空白，这时，只需设置YAML选项，

```R
output:
   pdf_document:
       latex_engine: xelatex
```

    ![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/buchong02.png)

	3. 方法二：如果想让中文显示，需要如下设置，这都是基于rticles模板的或者基于Latex的（由谢易辉的提供的案列进行总结的）

    方法一：

    ![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/buchong03.png)

    直接在YAML格式中添加参数即可：

```yaml
如图
```

	4. 方法三： 首先在你的Rmd文件开始部分加入：

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/buchong04.png)



```R
---
output:
    pdf_document:
        includes:
            in_header: header.tex
---
```

然后，建立一个新文件 header.tex，

内容如下：

```latex
\usepackage{ctex} 
%\setCJKmainfont{Adobe 宋体 Std}      % 中文缺省字体，
%\setCJKsansfont{Adobe 黑体 Std}      % 中文无衬线字体，   调用命令： \sffamily
%\setCJKmonofont{Adobe 仿宋 Std}     % 中文打字机（等宽）字体， 调用命令： \ttfamily
```

去掉注释，更改你自己定义的字体。

然后利用rmarkdown包正常编译Rmd文件就可以了。





**本机环境**

```R
> sessionInfo()
R version 3.5.1 (2018-07-02)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

Matrix products: default

locale:
[1] LC_COLLATE=Chinese (Simplified)_China.936  LC_CTYPE=Chinese (Simplified)_China.936   
[3] LC_MONETARY=Chinese (Simplified)_China.936 LC_NUMERIC=C                              
[5] LC_TIME=Chinese (Simplified)_China.936    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
 [1] compiler_3.5.1  backports_1.1.2 rprojroot_1.3-2 htmltools_0.3.6 tools_3.5.1     yaml_2.2.0     
 [7] Rcpp_1.0.0      rmarkdown_1.10  knitr_1.20      digest_0.6.18   evaluate_0.12  
```

