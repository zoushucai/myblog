---
title: 相关图之corrgram
date: '2018-07-15'
categories: r
---



**相关图**：
所谓相关图是基于变量间的相关系数大小，通过可视化方法反应不同变量组合间相关关系的差异图形。可以把相关图分为**相关矩阵图、相关层次图**

## 相关矩阵图


R语言中，绘制相关矩阵图的包主要有两个：`corrgram::corrgram`和`corrplot::corrplot`  
此处都以`mtcars`数据集为例，说明这两个函数的使用

## 相关矩阵图 --- --- corrgram


#### `corrgram::corrgram()`函数
```R
corrgram(x, type = NULL, order = FALSE, labels, panel = panel.shade,
    lower.panel = panel, upper.panel = panel, diag.panel = NULL,
    text.panel = textPanel, label.pos = c(0.5, 0.5), label.srt = 0,
    cex.labels = NULL, font.labels = 1, row1attop = TRUE, dir = "",
    gap = 0, abs = FALSE, col.regions = colorRampPalette(c("red", "salmon",
    "white", "royalblue", "navy")), cor.method = "pearson",
    outer.labels = NULL, ...)


参数解释：  
x: 数据框或者相关矩阵,输入数据框时，会自动识别数值型列进行计算相关矩阵，然后再绘图
order: 是否让变量按主成分分析相关矩阵排列.可以设置为TRUE或"PCA",默认FALSE
panel : 设置非对角线的面板形状,默认为阴影图
lower.panel: 设置相关矩阵下三角矩阵面板形状
upper.panel： 设置相关矩阵上三角矩阵面板形状
    面板形状设置参数： 
    panel.pie   用饼图的填充比例来表示相关性大小
        panel.shade 用阴影的深度来表示相关性
        panel.ellipse   绘制置信椭圆和平滑拟合曲线
        panel.pts   绘制散点图
    
text.panel 和 diag.panel 选项控制着主对角线元素类型。 
    textPanel    输出变量的名字（默认）
    panel.minmax    输出变量的最大最小值
        panel.txt      输出的变量名字          
```
画出相关矩阵图
```R
library(corrgram)
corrgram(cor(mtcars)) 
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-1-1.png)
```R
corrgram(mtcars)
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-1-2.png)
```R
corrgram(iris)
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-1-3.png)

#### 设置排序处理
```R
corrgram(mtcars,order = T) # 等价 corrgram(mtcars,order = "PCA")
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-2-1.png)

#### 设置上下三角面板形状
```R
corrgram(mtcars,order = "PCA",lower.panel = panel.shade,upper.panel = panel.pie)
```

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-3-1.png)

只显示下三角部分图
```R
corrgram(mtcars,order = "PCA",lower.panel = panel.shade,upper.panel = NULL)
```

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-4-1.png)

#### 调整版面颜色
```R
corrgram(mtcars,order = T,lower.panel = panel.shade,upper.panel = panel.pie,
            col.regions = colorRampPalette(c("darkgoldenrod4", "burlywood1","white","darkkhaki", "darkgreen")))
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-5-1.png)


```R
corrgram(mtcars,order=TRUE,
            lower.panel=panel.ellipse,
            upper.panel=panel.pts,
            text.panel=panel.txt,
            diag.panel=panel.minmax,
            main="Correlogram of Mtcars intercorrelations" )
```
![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/2020091417unnamed-chunk-6-1.png)
