---
title: data.table -- 2基本概念
date: '2018-01-17'
categories:
  - r
  - data.table
---


# data.table基本概念和其余函数---还需要修改

`set*  ` 函数族 会改变原有的数据，没有返回值，在`data.table`里，操作符`":="`和所有的以`set`开头函数（比如`setkey`,`setorder`,`setname`等）一样，它们都会更新输入的原数据。


```R
library(data.table)
iris_dt = data.table(iris)
# setnames(DT,oldnames,newnames) # 改变DT的列名oldnames,newnames为向量即变量

#改变列的顺序
col_names = colnames(iris_dt)
setcolorder(iris_dt,col_names[5:1])

# 更改某行某列的值,即更新元素的值
set(iris_dt,1,1,NA)# 更改1行1列的值为NA

```

## 1、键（主键）的概念

1. `data.table`从来不使用行名。`data.table`类似有行名的形式为`1:，2: , ...`
2. **主键会对筛选的列进行重排序**
3. 我们把data.table数据中的行名叫做键（或主键），他类似于python的字典，使用键值对类型查找数据，键要求唯一，每一行有且只有一个键。但是R中的键可以用多个甚至可以重复，键就相当于索引，通过键进行数据的查找
4. `setkey()` 和 `setkeyv()`可以直接更新输入的data.table，就和上一讲中的操作符":="一样。它们没有返回值。
5. 这个主键和其它语言不一样，例如python的键，唯一，在r中任意列都能使用setkey()来设置主键

```R
library(data.table)
mtcars_dt <- data.table(mtcars)  # 可以看出mtcars数据集中的行名没有了，替而代之为1: ，2:

# 若想保留行名，设置keep.rownames = T，当keep.rowname＝"new"时，列名改为new即可
mtcars_dt <- data.table(mtcars,keep.rownames = T)#默认创建一个叫做 rn的列，并且将行名赋值给这一列。
mtcars_dt
```

#### 1.2、设置／获取／使用主键
怎么将数据中的某一列设置为主键呢？---setkey()函数

  -  `setkey(DT, key) `将DT中的key列设置为主键，但是类行名 1:，2:,...,不会发生改变, 
  -  上面等价`  setkeyv(DT, "key")` ，也将DT中的key列设置为主键
  -  一旦将某一列设置成data.table的主键，就可以在参数i里指定 `.()`来subset那些主键了(就可以进行行筛选了)。我们还是用mtcars数据集，我们增加一个新列new

```R
mtcars_dt <- data.table(mtcars)
mtcars_dt[,new:=Sys.Date()+1:32] #增加一列new，内容为时间
setkey(mtcars_dt,new)
mtcars_dt   # 类似行名并没有发生改变，
mtcars_dt[.(Sys.Date()+1)]
key(mtcars_dt)    #查询设置主键的列名


# 也可以在r中任意列都能使用setkey()来设置主键
setkey(mtcars_dt,cyl,vs)	#会把先前设置的new主键给覆盖掉
mtcars_dt[.(4,1)]	#如果主键是字符型的列，那么可以省略 .()
key(mtcars_dt)	#查询设置主键的列名

haskey(mtcars_dt) # 返回TF值，检查是否有Key
```

## 2 、二级索引

二级索引和data.table的主键类似（**二级索引不重排序，主键会重排序**），但有以下两点不同：

- 它不会再内存里将整个data.table重新排序（`setkey`会）。它只会计算某列的顺序，将这个顺序向量保存在一个额外的，叫做index的属性里面。
- 一个data.table可以有多个二级索引，我们把主键与二级索引提取行方法进行对比

```R
# 设置主键的过程
mtcars_dt <- data.table(mtcars)
mtcars_dt[,new:=Sys.Date()+1:32] #增加一列new，内容为时间
setkey(mtcars_dt,cyl,vs)	#设置主键
mtcars_dt[.(4,1)]	#提取cyl==4,vs==1的所有行
```

```R
#  设置二级索引的过程--方法1
mtcars_dt <- data.table(mtcars)
mtcars_dt[,new:=Sys.Date()+1:32] #增加一列new，内容为时间
setindex(mtcars_dt,cyl,vs)# 把cyl,vs两列都设置二级索引的过程--方法1
mtcars_dt   # 等价 setindexv(mtcars_dt,"cyl","vs")

#注意mtcars_dt实际上没有按照cyl列的升序重新排列。还记得吗？setkey()会重新排序！
# setindex(mtcars_dt,NULL)  会删除所有的二级索引。
indices(mtcars_dt,vectors = FALSE)#  获取数据的二级索引,  默认为FALSE
setindex(mtcars_dt,new) #再次建立一个二级索引
indices(mtcars_dt)# 查看二级索引，可以发现在原有的二级索引上追加了新的索引，不会覆盖，还记得setkey(mtcars_dt,cyl,vs)会把先前设置的new主键给覆盖掉
```

  - 参数on能自动创建并重用二级索引－－等价setindex() 函数
  - 通过创建索引进行subset。每次都能节省setindex()的时间。
  - 通过检查属性，可以简单地重用已经存在的二级索引。
  - 语法简单。
  - 在参数i里面指定取值，在参数on里面指定列名。参数on必须是一个字符型的向量。
  - 注意参数on也可以用来指定主键。事实上，为了更佳的可读性，我们鼓励在参数on里面指定主键。

```R
#  设置二级索引的过程--方法2
mtcars_dt <- data.table(mtcars)
mtcars_dt[,new:=Sys.Date()+1:32] #增加一列new，内容为时间
mtcars_dt[.(6),on="cyl"]#当为字符时，可以省略.()
mtcars_dt[.(6,3),on=c("cyl","gear")]#同时满足cyl=6,gear=3的行
```

**主键与索引用来提取行，对参数i处理的一个变形，可以结合j，by参数进行处理**

## 3、参数mult和nomatch

##### a) 参数mult，默认为“all”
对于每次查询指定所有符合条件的行都被返回，若只返回第一行／最后一行设置为“first”或“last”。

##### b)参数nomatch 默认为NA
指定在没有找到符合条件的数据的情况下，是返回NA。设置 nomatch = 0L 跳过哪些不存在的数据

```R
library(data.table)
library(magrittr)
iris_dt = data.table(iris) 
iris_dt[.(5.1), on='Sepal.Length'] %>% head(3)
iris_dt[.(100), on='Sepal.Length'] # 没有找到Sepal.Length==100 的行,则返回NA
iris_dt[.(100), on='Sepal.Length', nomatch = 0]
```



## 4、数据融合
#### a) 函数melt－－拆数据

```R
melt(data, id.vars, measure.vars, 
    variable.name = "variable", value.name = "value", 
    ..., na.rm = FALSE, variable.factor = TRUE, 
    value.factor = FALSE, 
    verbose = getOption("datatable.verbose"))

```

- 参数 measure.vars 指定了想要拆分（或合并）的列。我们也可以指定索引而不是列名。
- 默认variable列是 factor类型的。如果你想返回一个字符型的向量，可以将参数 variable.factor 设为 FALSE。参数 variable.factor 是data.table的函数melt() 里独有的，增强包reshape2 里面没有这个参数。
- variable.name = "variable", value.name = "value", 会把转化后的列被自动命名为 variable 和 value（默认值）。
- 在结果里，函数melt() 保持了原来列的属性。

#### b) 函数dcast－－和数据

```R
dcast(data, formula, fun.aggregate = NULL, sep = "_", 
    ..., margins = NULL, subset = NULL, fill = NULL, 
    drop = TRUE, value.var = guess(data),
    verbose = getOption("datatable.verbose"))
```

- 函数 dcast() 使用了操作符“~”，左边是作为 id.vars 的列，右边是作为 measure.vars 的列。
- 参数 value.var 指定了需要被分拆扩张的列。
- 函数 dcast() 也会在结果中尽量保持原来的属性
- 可以给参数 fun.aggregate 传递一个函数。当操作符“~”不方便指定列名的时候，这个功能特别有用。


## 5、by的其他参数技巧

  + **rleid**   ---- 计算某向量的游程数（游程数：每次连续作为一组）（可以结合by参数使用）

```R
DT = data.table(grp=rep(c("A", "B", "C", "A", "B"), c(2,2,3,1,2)), value=1:10)
DT
rleid(DT$grp) # 获取DT$grp的游程数，返回一个和原向量等长的向量
rleidv(DT, "grp") # 与上面等价

rleid(DT$grp, prefix="grp") # 在游程数前面加"grp"

# 也可以按游程数进行分组，并计算其游程数的个数等操作
DT[, .N, by=.(rleid(grp))]

```

  + **rowid**  -----某个值在向量中出现的次数，出现第几次就显示为几

```R

DT = data.table(x=c(20,10,10,30,30,20), y=c("a", "a", "a", "b", "b", "b"), z=1:6)
DT
rowid(DT$x) # 1,1,2,1,2,2
rowidv(DT, cols="x") # 和上面等价

rowid(DT$x, prefix="group") # 数字前面加"group"

# 多列组合,看每一行的所有元素是否相同，相同则计数+1
rowid(DT$x, DT$y)#等价rowidv(DT, cols=c("x","y")) 

DT[, .(N=seq_len(.N)), by=.(x,y)]$N # 上面相当于做了这样的事
# 应用
dcast(DT, x ~ rowid(x, prefix="group"), value.var="z") #
```

  + **tstrsplit**      ---字符串拆分函数，类似`strsplit`函数,只不过结果和`strsplit`进行了转置

```R
name <- 1:3
dates <- c("2016-3-4","2016-3-14","2016-3-24")
nd <- data.table(name,dates)
nd
strsplit(dates,"-")
tstrsplit(dates,"-") 
nd[,c("year","month","day"):=tstrsplit(dates,"-")] # 实现拆分
nd
```



## 6、其他操作

| 函数                            | 功能                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| `%between%`                     | 快速查找某一区间：<br>` mtcars_dt[disp %between% c(150,200)]# 150<= disp <= 200之间`<br>` DT[c %between% list(a,b)]#a列 <= c <=b 列之间(向量版本)` |
| `%chin%`                        | 快速匹配 （%in% 的加速版）：  x %chin% table                 |
| `%inrange%`                     | 快速查找某一区间：<br> `dft[V1 %inrange% c(50,60)]`  即选择`50 <= V1 <=60`所有的行<br>`dft[V1 %inrange% list(V2,V3)]` 即选择 `V2 <= V1 <= V3`的所有行 |
| `A %like% B`                    | **匹配字符串A中含有B的字符**                                 |
| `.I`                            | 表示（分组后）每一行在原数据框中是第几行  dft[,.I[2],by=accept]<br>.I是一个整数向量，等于seq_len(nrow(x)), While grouping, it holds for each item in the group, its row location in x. This is useful to subset in j; <br>e.g.` DT[, .I[which.max(somecol)], by=grp].`  结合by,提取子集时,非常有用 |
| `.N`                            | .N 代表行的数量，用by参数分组时则是每一组的行数量            |
| `.SD`                           | 是经过`i` 和`by` 处理之后剩下的那部分数据集,本质是一个`data.table` |
| **`.SDcols`**                   | .SDcols 指定.SD 代表的数据框包括哪些列                       |
| `setDF(DT)`                     | 将data.table转化为data.frame                                 |
| `setDT(df)`                     | 将data.frame转化为data.table                                 |
| `setnames(DT,old,new)`          | 修改列名 也可以通过重新赋值操作 colnames(DT)                 |
| `fsort`                         | 排序                                                         |
| `frank`                         | 求秩, 类似rank                                               |
| `fintersect(x, y, all = FALSE)` | x与y的交集,相比于基础函数(默认为FALSE)， 增加了all参数，控制重复值 |
| `fsetdiff(x, y, all = FALSE)`   | x与y的差集，即x-y                                            |
| `funion(x, y, all = FALSE)`     | x与y的并集                                                   |
| `fsetequal(x, y)`               | 检验x与y二者是否完全相等,返回逻辑值                          |
| `shift(x,n=1L,...)`             | 把向量x向前移动或者向后移动n个数字                           |

### 6.1  `%between%`   与 `inrange()` 的区别

两者都是选择某列的值在一个范围内的所有行,即 $a \leq c \leq b$

`DT[c %between% list(a,b)]` 这里的a,b 一定是DT自身的列名

`DT[c %inrange% list(a,b)]`  这里的a,b 不是DT自身的列名,可以是外部的变量

### 6.2 `shift()` 把向量x向前移动或者向后移动n个数字

```R
DT <- data.table(A=1:5)
DT[ , X := shift(A, 1, type="lag")]
DT[ , Y := shift(A, 1, type="lead")]
DT[ , Y1 := shift(A, 2, type="lead")]
DT
```

### 6.3  `.I()`  返回匹配的行号

由于data.table 没有行号,因此`.I()`一般不单独使用

```R
mtcars_dt <- data.table(mtcars) 
mtcars_dt[, .I[cyl==6]] # 返回 cyl ==6 所在的行号
## 等价于
mtcars_dt[, which(cyl==6)]
```

### 6.4 `.SD ` 是经过`i` 和`by` 处理之后剩下的那部分数据集

**`.SD`代表行经过`i` 筛选后, 列除了`by`参数指定的列以外的所有列组成的新的data.table, 是原数据的子集**

```R
library(data.table)
mtcars_dt = data.table::as.data.table(mtcars)
mtcars_dt[, .SD, by=cyl]
output <- mtcars_dt[, lapply(.SD[, 1:10, with=F], mean), by=cyl]
output

```



## 7  set() 函数可以加快循环

`set(x, i = NULL, j, value)`

作用:  将value 值快速分配给i行j列元素, `i` , `j` 使用整数`10L` 而不是`10`, j参数不能省

```R
m = matrix(1,nrow=3,ncol=4)
DT = as.data.table(m)    
set(DT,3L,1L,10)# 第3行第1列元素改为10
set(DT,,2L,20) # 第2列的所有元素都改为20
DT


m = matrix(1,nrow=100000,ncol=100)
DF = as.data.frame(m)
DT = as.data.table(m)  
DT2 = copy(DT)
system.time(for (i in 1:10000) DF[i,1] <- i)
system.time(for (i in 1:10000) DT[i,V1:=i])
system.time(for (i in 1:10000) set(DT2,i,1L,i*10))
```

## 8、options设置

在控制台中输入options()会打印出一个list，这是当前的options设置值，比如显示保留几位小数等。加载data.table包之后，这里新增了一些data.table专用的参数，可以用下面的命令查看

```R
ops <- options() # ops就是一个list，参数和值的一一对应
# 由于data.table专用参数都是以datatable为前缀，使用我们输入时可以这样
ops$datatable.print.nrows # 返回100，设置打印的最大行数，超过了则简单打印
getOption("datatable.print.topn") #返回5，简单打印设置，前后各5行，其余行省略
```
