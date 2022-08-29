---
title: seq*函数族
date: '2018-07-08'
categories: r
---




```R
seq(from = 1, to = 1, by = 步长（默认为1),length.out = NULL, along.with = NULL, ...)

seq.int(from, to, by, length.out, along.with, ...)

seq_along(along.with)  

seq_len(length.out)

from：生成向量的起点，
to：生成向量的终点，默认步长为1（可修改） 
length.out：向量中元素数目
along.with：表示生成的向量为现有一向量元素的索引
```



主要介绍`seq_along(along.with)  `和`seq_len(length.out)`函数，应用于循环中

比如:

```R
# 要循环某个向量长度的次数,比如向量a，其长度未知
for(i in seq_along(a)){...}  代替 for(i in 1:length(a)){...}   ## 经常犯这样的错误，不美观

# 循环中，循环1:10可以用一下方法
for(i in seq_len(10)){...}  代替 for(i in 1:10){...} 
```



`head(x,5) ` : 取向量的前5个元素，向量 ，数据框 ，list都适用

`tail(x,5)`: 取向量的后5个元素，等价 `x[-(1:(length(x)-5))]`   等价 `x[(length(n-4):length(n)] `

