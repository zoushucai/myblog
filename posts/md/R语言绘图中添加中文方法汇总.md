---
title: 基本绘图中添加指定中文字体
date: '2020-03-10'
categories:
  - r
---



## 基本绘图中添加指定中文字体

### 方法一: 使用`par(family='STKaiti') `, 

### 方法二: 直接在画图函数后添加`family` 参数指定字体,在R.3.6.x  已经不可以了

```R
barplot(df[sex == '男',table(Year)],main = "男性条形统计图",family = 'Songti SC') 
```

### 方法三: 使用showtext包,需要xquartz软件,可以使用`brew cask install xquartz`

```R
library(showtext)
#使用下面的函数查看所有字体,选择中文字体添加
font_files()
showtext_auto(enable = TRUE)
font_add('Songti', 'Songti.ttc','STKaiti','STXihei')  #添加中文字体
quartz(family = "STXihei") 
#可以把STXihei替换成任意想要的字体，如'Songti', 'Songti.ttc','STKaiti'等
```

### 方法四: **[extrafontdb](https://github.com/wch/extrafontdb)**  软件包



## 方法五: ggplot2绘图中添加指定中文字体

```R
library(ggplot2) 
p = ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) + geom_point()
p = p + labs(title = "iris数据集")
p = p + theme(plot.title = element_text(hjust = 0.5))  #标题居中
p = p + theme(text=element_text(family="Songti SC"))
p 
```
