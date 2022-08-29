---
title: data.table -- 3常见操作
date: '2018-01-18'
categories: data.table
---


```R
knitr::opts_chunk$set(message = F,warning = F,comment = "#>",collapse = TRUE)
```

**数据准备**


```R
library(data.table)
library(magrittr)
iris_1 = data.table(iris[1:5,])
iris_2 = data.table(iris[51:55,])
iris_1
iris_2
```



## 1. 两个data.table行合并

```R
##### --- 两个data.table行合并 --两个数据的列数应该相等 ##### 
#### --- 方法一 --纯粹的合并
rbind(iris_1,iris_2)

### -- 方法2  --- 
l = list(iris_1,iris_2)
rbindlist(l, use.names=TRUE, fill=TRUE) %>% head()


```

## 2. 两个data.table列合并

```R
##### --- 两个data.table列合并 --两个数据的行数应该相等
## --方法一  纯粹的合并
cbind(iris_1[,1:2],iris_2[,5])
## --方法2  --- 类似 dplyr包中的链接
# merge(iris_1[,1:2], iris_2[,5], all=TRUE,sort=F) 

## --方法3  --- 类似 dplyr包中的链接
# dt_a[dt_b,on=.(b = y)]

```



**多个data.table 合并-- 按照自己想要的方式合并**

```R
# Merge multiple data.tables 
dt_list    <- list(dt1, dt2, dt3)
merge_func <- function(...) merge(..., all = TRUE, by='carname')
dt_merged  <- Reduce(merge_func, dt_list)
```



## 3. 把list类型转变为data.table类型

```R
####  把list类型转变为data.table类型
aa = lapply(1:5, function(x) list('CR' = x,'CSI' = x^2))
aa
rbindlist(aa)


```

##  4.对列进行批量操作
###  4. 1对列进行操作
```R
## 对每一列都进行某个操作
iris_1[,lapply(.SD, function(x)length(x))]

## 也可以指定列进行计算
iris_1[,lapply(.SD, function(x){sum(x)/.N}),.SDcol = 1:3]
# 指定的列，可以使用数字列，也可以使用字符列

iris_1[,lapply(.SD, function(x){sum(x)/.N}),.SDcol = c("Sepal.Length","Sepal.Width")]





#### 排除列进行操作,  排除列可以用！ 也可用 - 
# eg： 排除某些列，然后对剩下的列进行操作
iris_1 = data.table(iris[1:50,])
iris_1[1:5, lapply(.SD, function(x)x*100 ),.SDcols = !(5)] # 排除第5列，对其余列进行操作
iris_1[1:5, lapply(.SD, function(x)x*100 ),.SDcols = !(4:5)]# 

iris_1[1:5, lapply(.SD, function(x)x*100 ),.SDcols = -(c(1,5))] 
iris_1[1:5, lapply(.SD, function(x)x*100 ),.SDcols = !(c("Sepal.Length","Species"))]


```

### 4.2 对列进行有匹配的筛选

只用`data.table` 包

```R
iris_dt = data.table(iris[1:5,])
# 筛选列名中包含"Sep"字符串的列,这类似于shell中的grep命令,或者基本R中的grepl命令
iris_dt[,names(iris_dt) %like% "Sep", with=FALSE]

# 筛选列名中包含"Length"字符串的列
iris_dt[,names(iris_dt) %like% "Length", with=FALSE]

```

也可以引进`dplyr包`进行结合使用，
```R
library(data.table)
iris_1 = data.table(iris[1:5,])
library(dplyr)
iris_1[,select(.SD,contains("S"))] # 从列中筛选出列名包含"S"的列，这列contains函数不区分大小写
iris_1[,select(.SD,contains("s"))] 

iris_1[,select(.SD,starts_with("Sep"))]  # 列名是"Sep"字符串开始的
iris_1[,select(.SD,ends_with("th"))] # 列名是"th"字符串结束的


iris_1[,select_if(.SD,is.numeric)] # 为数值型属性的列
iris_1[,select_if(.SD,is.factor)] 



```

### 4. 3 对列进行批量重命名
#### 4.3.1 更新部分列
** 记住`.SD`只能用于`:=`的右边 ，不能用于左边，左边应该是字符、数值格式** 
```R
iris_1[,colnames(iris_1[,1:4]) := lapply(.SD[,1:4],function(x) x*100)]
iris_1

# iris_1[,colnames(.SD[,1:4]) := lapply(.SD[,1:4],function(x) x*100)] # 出错
```

#### 4.3.2左边利用数值进行更新列
```R
# 左边利用数值进行更新列
iris_1 = data.table(iris[1:5,])
iris_1[1:5, (c(2,3,4)):=lapply(.SD, function(x)x*100 ),.SDcols = !(c(1,5))]
iris_1[1:5,]


iris_1 = data.table(iris[1:5,])
## 如果左边用数字并打上() 代表第几列，指定第几列的操作
iris_1[,(2:3):=Species] # 把第2：3列的值进行更新，即第2:3列都为Species列
iris_1

```

#### 4.3.3 左边利用字符串更新列
```R
# 左边利用字符串更新列
## 对指定的列进行计算 --- 并修改原有的列
iris_1 = data.table(iris[1:5,])
col_names = c("Sepal.Length","Sepal.Width")
iris_1[, (col_names) := lapply(.SD, function(x)x*10 ),.SDcols = col_names]
iris_1

```

## 5.data.table 数据的重组与拆分

这里的`melt` 和`cast` 针对`data.table` 进行了优化

- `melt`  — — 把宽格式数据转化成长格式。

- `dcast`  — — 把长格式数据转化成宽格式。参考前面的,这里只讲`data.frame`, `data.table`类似

**如果不是data.table数据格式，推荐使用tidyr包进行数据的重组与拆分**

```R
melt(data, id.vars = c(""),#保留的列 ，可以省略(表示不保留列)
         measure.vars= c("",""), # 指定列进行融合，不指定时表示全部融合，可以使用正则表达式
         variable.name='variable',value.name = 'value')# 融合后的名字与值
```

参见下图：



![melt](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/melt.png)

## 6. 实现dplyr中的join_left操作

| 类型  | 语法1                                 | 语法2(推荐)        |
| ----- | ------------------------------------- | ------------------ |
| Inner | X[Y,nomatch=0] 或者<br>Y[X,nomatch=0] | merge(X,Y,all=F)   |
| Left  | Y[X]                                  | merge(X,Y,all.x=T) |
| Right | X[Y]                                  | merge(X,Y,all.y=T) |
| Full  | -                                     | merge(X,Y,all=T)   |
|       |                                       |                    |

```R
merge(x, y, by = NULL, by.x = NULL, by.y = NULL, all = FALSE,
all.x = all, all.y = all, sort = TRUE, suffixes = c(".x", ".y"), no.dups = TRUE,
allow.cartesian=getOption("datatable.allow.cartesian"),  # default FALSE
...)

参数解释
	x, y : 需要合并的数据集
	by : 用于连接两个数据集的列,当两个数据集公共列名相同,可以写成 by = "公共列名"
	by.x, by.y: 用于指定依据那个列合并,常用与当两个数据集公共列名不一样的时候
	all, all.x, all.y 指定对于的合并类型 
```

## 7.  按照A列分组后,找出B列的最大值

即选择每组中某列对应最大值的行, 

~~分组有一个功能,即提取所有的值都是唯一的.~~  

~~`unique()`函数提供的唯一性, 有一定缺陷~~

-  ~~作用于向量, 返回唯一的向量, 有重复项默认前面的值作为返回对象~~
- ~~作用于数据框,返回数据框的每一行都唯一~~
- ~~不能到达数据框A列保持唯一,若A列有重复项,选择B列中最大的那个值作为返回对象.~~

```R
ID    <- c(1,1,1,2,2,2,2,3,3)
Value <- c(2,3,5,2,5,8,17,3,5)
Event <- c(1,1,2,1,2,1,2,2,2)
group <- data.frame(Subject=ID, pt=Value, Event=Event)
require(data.table) 
group <- as.data.table(group)
group
# 所有最大值
group[group[, .I[pt == max(pt)], by=Subject]$V1,]

# 只想要第一个最大值
group[group[, .I[which.max(pt)], by=Subject]$V1,]# 方法一: 很快
group[, .SD[which.max(pt)], by=Subject]# 方法二: 较慢


```

https://stackoverflow.com/questions/24558328/how-to-select-the-row-with-the-maximum-value-in-each-group

## 8. 按照A列分组后,找出B列的第2大的值

```R

group[group[,.I[order(-pt)[2]],by=.(Subject)]$V1,]


group[,.SD[order(-pt)[2]], by = Subject]

```

 



```R
  ## 方法一:
  dtf_t = dt[dt[, .I[order(-count_dot,abbr_len)[1]], by=journal_lower]$V1,]

  ## 方法二:
  dtf = dt[dt[, .I[{
    temp = which(count_dot == max(count_dot))
    ifelse(length(temp) == 1, temp, which.min(abbr_len))
  }], by = journal_lower]$V1,]
```

