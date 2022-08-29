---
title: 计算各种距离 （matlab）
date: '2019-12-11'
categories:
  - 距离
  - matlab
---


pdist --不推荐使用--好像是计算元素之间的距离

观测值对之间的成对距离

 matlab中自带的计算距离矩阵的函数有两个pdist和pdist2。前者计算一个向量自身的距离矩阵，后者计算两个向量之间的距离矩阵。基本调用形式如下：

输入： 一个矩阵

计算方法: 案例计算各自的距离



```matlab
D = pdist(X)
D = pdist(X,Distance)
D = pdist(X,Distance,DistParameter)
```

pdist2  --- 计算向量之间的距离
