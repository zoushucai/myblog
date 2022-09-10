---
title: hugo-blogdown搭建网页过程中的小问题
date: '2017-12-28'
categories:
  - r
  - hugo
description: 一个页面的描述
---


### 1、hugo路径设置
在建立网站的时候，用rmarkdown生成的图片引用到网页中，不能使用中文，不然图片路径找不到（即不能正常显示）且不能用空格，但是可以用`-`,表示路径。
所以目录还是用英文吧，不过标题可以用中文

### 2、hugo生成网页首页产生0001样式

这是由于文章开头没有声明yaml格式，注意title author可以用双引号也可以不用，但请注意date的日期格式，尽量用`date: 2017-12-28` 这样的格式

### 3  运行blogdown:::serve_site()函数本地监听没有反应

即运行blogdown:::serve_site()改函数时，本地不能预览，这是由于我们自己写的rmd或者md文件的编码不是UTF-8引起的，所以我们一般要设置Rstudio的全局属性中保存UTF-8编码，但是这样在保存文件时又会产生新的问题，特别是保存的是csv文件

还有一种情况是设置了全局属性`echo = TRUE`这个选项，不过这个选项还有待验证

参见：

### 4、网站图片引入居中设置

方法一：嵌入html标签

```html
<img src="./xxx.png" width = "300" height = "200" alt="图片名称" align=center />
```



方法二：

```html
	<div align="center">
		![New Project](/img/NewProject.png)
	</div>
注意：一个代码区块会一直持续到没有缩进的那一行（或是文件结尾）
所以，<div></div>前面都有缩进
```

### 5、遇到：转换文件名时出了问题---名字太长?

在发布博客文章是，用rmd生成文章遇到

![2018091301item01](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2018091301item01-20200527144459191.png)

解决方法：   这是由于rmd的文件名中有中文，写成英文即可。

疑问： rmd文章短的时候可以用中文名。但是中文长的时候就不能用中文

### 6、  hogo生成动态网页 不显示图片

比如 DT包 、plotly包、dygraph、等



建议引用widgetframe包 如下 （并且rmd文件不能有中文名，不然不能识别，文章的标题可以是中文）



```R
library(dygraphs)
library(widgetframe)
## 载入需要的程辑包：htmlwidgets
## Loading required package: htmlwidgets
ts <- dygraph(nhtemp, main = "New Haven Temperatures")
frameWidget(ts, height = 350, width = '95%')

```

