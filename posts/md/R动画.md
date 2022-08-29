---
title: R动画
date: '2020-08-16'
categories: r
---




# R 动画

动画的本质是有n张图片进行拼接,到达欺骗人的眼睛.

在R中有常见的有两个包.

- `gifski` 包, 搭配 rmd 文件使用, 
- `gganimation`  包

## **gifski** 包

安装 **gifski** 包：

```R
xfun::pkg_load2('gifski')
```

再用代码段选项 `animation.hook='gifski'`，如:

~~~R
```R
for (i in 1:2) {
  pie(c(i %% 2, 6), col = c('red', 'yellow'),
    labels = NA)
}
```
~~~

则会直接生成gif动画

https://slides.yihui.org/2020-bearclub-rmarkdown.html#7

## `gganimation`  包

见官网



