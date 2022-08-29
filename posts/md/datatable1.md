---
title: data.table -- 1基本函数
date: '2018-01-16'
categories:
  - r
  - data.table
---


data.table本质上是一个list，它们的列包含的元素个数都相同。

# 1、数据的读写

### 1.1数据读入－－fread

选其常用的参数如下：

```R
fread(input,na.strings="NA", file, stringsAsFactors=FALSE,encoding="unknown", ...)
```

- input 入的文件对象，`fread`函数可以自动判断分隔符类型，自动判断首行是否是列标题，同时默认读入时字符型变量不会变为因子型。也可也从网页读取数据
- na.strings,对NA的解释；
- file文件路径，再确保没有执行shell命令时很有用，也可以在input参数输入;
- stringsASFactors是否转化字符串为因子，
- encoding，默认"unknown"，其它可能"UTF-8"或者"Latin-1"，不是用来重新编码的，而是允许处理的字符串在本机编码;
- showProgress = T   显示进度条
- integer64 当数据列中有大于2 ^ 31的整数,可能会丢失精度
- quote  对带双引号的字符添加转义,在R中正常显示,但是输出时,可能会引起成倍的双引号,因此建议使用`fwrite`时,设置该参数`quote = FALSE`

### 1.2数据写入－－fwrite

```R
fwrite(x, file = "", append = FALSE, na = "", row.names = FALSE, col.names = TRUE,logicalAsInt = FALSE, ...)
```

- x,比如data.frame和data.table等R的对象；
- file，输出文件名,""意味着直接输出到操作台；
- append，如果TRUE,在原文件的后面添加；默认删除原来文件的数据，重新存储。
- na,na值的表示，默认""；
- row.names，是否写出行名，因为data.table没有行名，所以默认FALSE；
- col.names ，是否写出列名，默认TRUE，如果没有定义，并且append=TRUE和文件存在，那么就会默认使用FALSE;
- logicalAsInt,逻辑值作为数字写出还是作为FALSE和TRUE写出；



## 1.3  数据框转为data.table

对于数据的处理，`data.table`包提供了一个非常简洁的通用格式：`DT[i,j,by]`，

- 其中`i`控制列, `j`控制列, `by`控制分组. 上述表达式的意思是: 对于数据集`DT`，先选取子集行`i`,  然后通过`by`分组计算`j`。`i`设定数据的选取条件，`j`设定结果的计算方式，`by`设定数据的分组情况。通过这个，我们可以在一行代码中很方便地完成处理过程。首先需要把数据变为data.table类型

```R
library(data.table)
library(magrittr)
### 方法一: 赋值转换
mtcars_dt <- data.table(mtcars) # 也可以强制转化 as.data.table()

### 方法二: 引用转换
setDT(mtcars)  # 不需要赋值,这是引用转换, mtcars这个数据集已经变成了data.table 数据类型了
```

# 2. 数据行列筛选 --- i 参数

**行筛选：--i参数**

- 直接采用逻辑语句（慢）
- 使用主键(会对筛选的数据进行重排序--适中)
- 二级索引（不重排序，按原数据的顺序排序--快）

## 2.1 直接采用逻辑语句（慢）

```R
mtcars_dt <- data.table(mtcars) # 一共32行,11列
#直接采用逻辑语句（慢）
mtcars_dt[cyl==8 ]
mtcars_dt[cyl==8 & carb==4]
mtcars_dt[cyl %in% c("8","6")]# 等价 mtcars_dt[cyl %in% c(8,6)]
```

##  2.2 设置/获取/使用主键(适中)

| 函数                           | 说明                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `setkey(x,V1)`                 | 该函数可以对一个data.table按照某一列进行排序,排序之后,这个data.table 对象会被标记为排过序了, 由于不会在内存中复制被排序的data.table对象,所以非常高效. |
| `setkey(x,V1,V2,V3, ...)`      | 等价于`setkeyv(x,c("V1","V2",...) )`                         |
| `setkeyv(x,c("V1","V2",...) )` | 可以按照多列一起排序.先根据V1排序,然后根据V2排序, 以此类推.  |
| `table()`                      | 查看内存中所有data.table 的详细信息,包括key键,               |

- **`setkey(x,V1)`传入列名作为参数，不需要引号, 而`setkeyv(x,c("V1","V2",...) )` 传入一个字符型的向量, 这两个函数都没有返回值, 直接对data.table进行更新操作,和`:=`类似**

- **每一个table.table中只有一组key键, 像普通的data.frame, 每一行有且只有一个行名且行名具有唯一性, 行名可以看做是data.frame的索引. 而data.table可以利用主键进行索引, 且可以对多列设置主键,且主键不强调唯一性. 也就是说，不同列的主键可以是一样的。既然行可以通过主键排序，那么排序的时候，具有同样主键的一些行，会被排在一起。**

- **在data.table里，操作符":="和所有的以set开头函数（比如setkey,setorder,setname等）一样，它们都会更新输入的原数据。**


```R
#使用主键(会对筛选的数据进行重排序--适中)
mtcars_dt <- data.table(mtcars) 
setkey(mtcars_dt,cyl,carb)# 设置key键
mtcars_dt #可以看出已经排序了
tables()              # 查看内存中所有data.table 的详细信息,包括key键
iris_dt = data.table(iris)
tables()              # 
setkeyv(mtcars_dt,c("cyl","carb"))#先设置的cyl,carb列为主键
mtcars_dt[.(8,4)]     # 等价 mtcars_dt[cyl==8 & carb==4]
tables()              # 查看内存中所有data.table 的详细信息
```
## 2.3 二级索引`(indices)`（快）

#### a)  **什么是二级索引? 二级索引和主键有什么区别?**

  - 前面介绍了`setkey` 和`setkeyv`的使用,每一次使用`setkey`, data.table 对象都会在内存里被重新排序, 时间复杂度是`O(nlogn)`. 而  `setindex` 和`setindexv` 则不会对data.table对象进行重新排序, 它只会计算某列的顺序，将这个顺序向量保存在一个额外的，叫做index的属性里面。 此外,一个data.table对象只能有一组key,  但是可以有多个二级索引(indices). 二级索引的时间复杂度是`O(logn)`

| 函数                            | 说明                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| `setindex(x,V1)`                | 设置索引---即将V1列设置为该data.table的二级索引 <br> 等价`setindexv(x,c("V1"))` |
| `setindex(x,V1,V2,...)`         | 设置多列索引---即将V1,V2列设置为该data.table的二级索引<br/> 等价`setindexv(x,c("V1","V2",...))` |
| `setindexv(x,c("V1","V2",...))` | 以字符的方式设置索引                                         |
| `setindex(x, NULL)`             | 删除所有的二级索引。                                         |
| `indices(x) `                   | 获取data.table对象的所有二级索引, 如果该data.table没有二级索引，那么返回NULL。 |

```R
# 设置和获取二级索引
mtcars_dt <- data.table(mtcars) 
setindex(mtcars_dt,cyl,carb) # 等价于 setindexv(mtcars_dt,c("cyl","carb"))
names(attributes(mtcars_dt)) # 查询data.table 的属性
indices(mtcars_dt)
mtcars_dt #  注意并没有对数据进行重新排序, 而setkey会对数据进行重新排序
setindexv(mtcars_dt,c("vs", "am", "gear","carb"))
indices(mtcars_dt)


```
#### b)为什么使用二级索引 
原因是对一个data.table重新排序成本太高, 除非你要进行大量选子集的操作,建议使用setkey 来提取子集.
我们想快速地提取子集(subset)同时又不必重新排序,此时二级索引就派上用处了.

## 2.4 二级索引的快速使用 --- 参数on

上面我们都在讲先设置二级索引,然后在进行操作,这样能不能合成一步?----于是参数`on`诞生了, 参数`on`使得语法更简洁，并且能自动创建并重用二级索引

**参数on**

  - 通过创建索引进行subset。每次都能节省setindex()的时间。
  - 通过检查属性，可以简单地重用已经存在的二级索引。
  - 参数on必须是一个字符型的向量。
  - 注意参数on也可以用来指定主键。事实上，为了更佳的可读性，我们鼓励在参数on里面指定主键。
  - 参数`on`它不会把这个二级索引自动创建为data.table的一个属性。需要额外设置参数才可以(设`verbose = TRUE`).
```R
mtcars_dt[.(1),on="am"]#同时满足cyl=8,gear=4的行
## 等价的备选方案 -- mtcars_dt[list(1), on = "am"]
## 注意 on="am"表明我们要基于am这一列进行过滤,过滤的条件是am == 1, 1必须放置.()里面
## 原因是 am是numeric类型,如果不是numeric类型,就不用这样做

iris_dt = data.table(iris)
iris_dt["setosa",on="Species"]  
#等价的备选方案
iris_dt[.("setosa"),on="Species"] 
iris_dt[list("setosa"),on="Species"] 

# 选择 Species =setosa 或者 Species =virginica
iris_dt[.(c("setosa","virginica")) ,on="Species"] 
iris_dt[.(c("setosa","virginica"),c(3.0)) ,on=c("Species","Sepal.Width")] 

# 注意小心有NA行,原因在于Petal.Length列没有等于5.1的值
iris_dt[.(c("setosa","virginica"),c(5.1)) ,on=c("Species","Petal.Length")] 


#### on参数也可以像j那样直接使用列名 ,无需加引号
mtcars_dt[.(8,4),on=c("cyl","carb")]#同时满足cyl=8,gear=4的行
mtcars_dt[.(8,4),on=.(cyl,carb)]# 等价同上,

```

## 2.5 自动索引 --- 只支持操作符 == 和 %in% 

回顾一下，我们先学习如何通过主键使用快速二分法搜索进行subset。接着，我们学习了使用二级索引，它带来更好的效果，而且语法也更简洁。

等等，有没有更好的方法？

有！优化R的原生语法，使用内置的索引。这样我们毋需使用新的语法，就能得到同样的效果。这就是自动索引。
目前，**它只支持操作符 == 和 %in% 。而且只对一列起作用**。某一列会被自动创建为索引，并且作为data.table的属性保存起来。这跟参数on不同，参数on会每次创建一个临时索引，所以才会被叫做“二级索引”。

```R
iris_dt[Petal.Length == 5.1, ] 
iris_dt[Petal.Length %in% c(5.1,5.2), ] 
```



**注意, 以上都是针对`i`参数设置,因此可以同`j`参数, `by`参数同时使用**

**还有, 在进行行筛选时,尽量打个逗号,区分`i`和`j`**

# 3  列筛选：-- j参数

## 3.1 `.()`格式 == 等价list()

**用` .() `来包围列名，和`list()` 等价**    

```R
# 列筛选 --方法一, 直接输入列名
mtcars_dt[, .(mpg, cyl, hp)] %>% head()
mtcars_dt[, c("mpg", "cyl", "hp")]# 返回的都是data.table
mtcars_dt[, c("mpg", "cyl", "hp"), with =F]

# 列筛选 --方法二 如果没用list()或者.()包围列名 ，则返回的是向量（这不是我们想要的结果），如下
mtcars_dt[, c(mpg, cyl, hp)] %>% head()

# 列筛选 --方法三, 可以把列名改写成对应的数字列,但返回的是data.table类型
mtcars_dt[, c(1, 2, 4)] %>% head()
mtcars_dt[, c(1, 2, 4)] %>% class()

# 列筛选-- 方法四, 如果列名已经存储到一个变量里面了, 怎么根据它来选择列
library(data.table)
mtcars_dt = as.data.table(mtcars)
a = c(1,2,4)
b = c("mpg", "cyl", "hp")
mtcars_dt[,..a] # 在变量名前加两个点,  如果这样输入: mtcars_dt[,a], 则报错
mtcars_dt[,..b]# 在变量名前加两个点,  如果这样输入: mtcars_dt[,b], 则报错


# 列筛选 --方法五, 要排除列名怎么办，可以用数字
mtcars_dt[, -c(1, 2, 4)] %>% head() # 等价
mtcars_dt[, c("mpg", "cyl", "hp") :=NULL]  # 等价
mtcars_dt[, -c("mpg", "cyl", "hp"), with = F] %>% head() # 等价
mtcars_dt[, !c("mpg", "cyl", "hp"), with = F] %>% head() # 等价

# 下面只能用冒号(:)链接，不然会报错
mtcars_dt[, -(2:4)] %>% head() # 删除第2:4列变量
mtcars_dt[, mpg:disp, with = FALSE] %>% head() # 等价
mtcars_dt[,-(mpg:disp), with = FALSE] %>% head() # 等价
```

##  3.2 在j参数上可以进行计算： 

```R
# 返回按列计算的值
mtcars_dt[,.(sum(mpg),mean(cyl))]

# 当列的长度不一的时候，会循环对齐
mtcars_dt[,.(mpg,mean(cyl))] %>% head()


# 还可以输入多个表达式，用花括号括起来即可
mtcars_dt[,{print(mpg);plot(disp)}]

# {} 还有帮助我们隐藏一些过度中间变量
mtcars_dt[,.(x = cyl^2 +1, y = cyl^2 +2)] %>% head() # 这样cyl^2计算了两次,这样效率慢

mtcars_dt[,{temp = cyl^2; .(x = temp+1,y=temp+2)}] %>% head() 

```

**关键词`.SD` 和`.SDcol` 的作用** , 后面会讲解

```R

## 对data.table的每一列进行计算
mtcars_dt[,sapply(.SD, function(x){sum(is.na(x))/.N})]

## 也可以指定列进行计算
mtcars_dt[,sapply(.SD, function(x){sum(is.na(x))/.N}),.SDcol = c("A","B","C")]

iris_dt = data.table(iris)
col_names = colnames(iris_dt)

## 计算所有数值变量的均值, 可以先对变量名进行筛选
num_col = sapply(iris_dt, function(x) class(x) == "numeric" )
iris_dt[, lapply(.SD, mean), .SDcols = num_col]

#####  在数据框中把指定的列转换为因子列
## 方法一   ---- 这种方法已被弃用 with=F, 推荐使用方法2 
# col_names 为一个字符向量
# iris_dt[, col_names := lapply(.SD, function(x)as.factor(x)),.SDcols = col_names,with=F]
iris_dt[,col_names,with=F]  # 选择以col_names变量的内容的列


## 方法二
## (col_names):=  代表的是字符串向量，如果只使用col_names则表示列名为col_names的变量
iris_dt[, (col_names) := lapply(.SD, function(x)as.factor(x)) , .SDcols = col_names]

iris_dt[,("Sepal.Length"):=as.factor(Sepal.Length)] #同上

                                
## 如果左边用数字并打上() 代表第几列，指定第几列的操作
iris_dt[,(2:3):=Species] # 把第2：3列的值进行更新，即第2:3列都为Species列

### 用函数对列名进行筛选后,然后对这些列进行统一处理
#eg: 列名以S结尾的列全部转为因子,    
iris_dt[, lapply(.SD, function(x)as.factor(x)) , .SDcols = endsWith(names(iris_dt), "S")]
# startsWith(names(iris_dt), "S") # 表示以S开头的筛选变量方式
                 
                 

```



##  3.3 选取子集

选取子集仍然采用`subeset`函数，语法格式为：`subset(x, subset, select)`，x是data.table对象，subset是行满足条件，select是列满足条件

```R
# 用 .() 来包围列名，和list() 等价，都返回data.table数据类型,只要参数 j 返回一个list，这个list的每一个元素都会被转换成结果data.table的一列

subset(mtcars_dt,cyl==8,select =c('mpg','cyl','disp'))
# 等价
mtcars_dt[cyl==8,.(mpg,cyl,disp)]
# 等价
mtcars_dt[cyl==8,list(mpg,cyl,disp)]

## 注意 ，没用list()或者.()包围列名 ，则返回的是向量，如下
mtcars_dt[,c(mpg,cyl,hp)] 
```

## 3.4  对列进行排序

  - 排序采用`setorder`函数，输入待排序的列名，默认升序，降序列名前加`-`    
  - 注意：升序，降序都是按assic 值的大学排序
    
```R
setorder(mtcars_dt,mpg,-hp) #注意，这里直接对原数据进行了重排序，这点和R很多函数不一样，
#几乎等价
mtcars_dt[order(cyl,-hp)] #这个就基本符合R语言规律，不改变原数据。

# 还可以使用key键排序,这样会改变原数据
```

## 3.5 对列进行增删变量

**都是直接对原数据进行修改，无需重复赋值**

### 3.5.1 添加变量有三种语法格式：

```R
DT[i, LHS:=RHS, by=...] #适用单变量添加，等号（＝）前面为新的变量名,没有写明变量名，自动为V+  
DT[i, c("LHS1","LHS2") := list(RHS1, RHS2), by=...] #双变量添加  
DT[i, `:=`(LHS1=RHS1,LHS2=RHS2, ...), by=...] #多变量添加，注意`:=`  

# 有条件的添加变量
mtcars_dt <- data.table(mtcars) 
mtcars_dt[, cyl1:= 1*(cyl <= 6)]
mtcars_dt[, cyl2:= ifelse(cyl <=6, 1,0)]
mtcars_dt[, cyl_mpg:= ifelse(cyl <=6, mpg,cyl)]# 当cyl小于6时,则用mpg的数据,大于6时,则用cyl值保持不变
```

### 3.5.2 删除变量 --- `变量:=NULL`

```R

# 这里发现一个bug，数据集被改动了,但是rstudio中的变量的维度没变，但是数据集确实改变了
mtcars_dt[,`:=`(mpg1=1/mpg,new=cyl+gear)]#增加变量mpg1 与new变量
mtcars_dt[,mpg1:=NULL] #删除变量mpg1  也可以mtcars_dt[,`:=`(mpg1=NULL,new=NULL)],也可以用 mtcars_dt[, c("mpg") :=NULL] 

# 如果要删除多列时，可用以下方法,
mtcars_dt[, c("mpg", "cyl", "hp") :=NULL]  # 注意用 :=  会直接更改原数据
mtcars_dt[, -c("mpg", "cyl", "hp"), with = F]  # 这个会产生一个副本（或者叫拷贝）
mtcars_dt[, !c("mpg", "cyl", "hp"), with = F] # 同上，产生拷贝
mtcars_dt[, -c(1, 2, 4)]     #  同上，产生拷贝

# 删除多列
col = c("mpg", "cyl", "hp")
mtcars_dt[, col :=NULL]  # 这个只能删除列名为col的变量

mtcars_dt[, (col) :=NULL] # 能删除以col为变量的内容作为mtcars的列名，
# 上面等价mtcars_dt[, c("mpg", "cyl", "hp") :=NULL] 

# 下面只能有冒号(:)链接，不然会报错
mtcars_dt[, mpg:disp, with = FALSE] %>% head() # 等价
mtcars_dt[,-(mpg:disp), with = FALSE] %>% head() # 等价

```

**理解数据存储以及变量名** 。比如：数字，字符串 ，矩阵的内容，都会直接存在内存中，把数字3赋值给变量a,就相当于a指向数字3，改变a不会对内存进行修改，只是指针发生了改变，

**操作符“:=”会更新原数据**。操作符“:=”对输入的数据进行浅度复制，只是一份指向列的指针向量的复制，在内存里，数据不是真的被复制了。他会随着指针指向的对象变化而变化，

**不更新原数据用函数 copy()。**函数 copy() 对输入参数进行深度复制，因此对副本做的所有更新操作，都不会对原数据生效。简单理解：就是在内存中创建了一个和原来一模一样的数据.



# 4. 分组汇总－－by参数

## 4.1 分组汇总只需在`by`指定分组变量，在`j`指定计算函数即可

```R
#按cyl与vs分组，对统计分组下的mpg均值，disp的总和,分组数据个数num，共返回cyl，vs，以及分组下的三个新变量 
mtcars_dt[,.(mean_mpg = mean(mpg),num=length(mpg),sum_disp = sum(disp)),by=.(cyl,vs)] 
```

## 4.2 data.table有一个**特殊的变量`.N`**可以直接计算分组的观测值个数。

    - 当参数j里面只有一列，我们可以省略 .()，如下：mtcars_dt[,.N,by=.(cyl,vs)]	 
    - 当参数by里面只有一列，我们可以省略 .()，如下：mtcars_dt[,.N,by=cyl]

```R
mtcars_dt[,.(mean_mpg = mean(mpg),.N),by=.(cyl,vs)]
```

## 4.3 by参数还有接受表达式：

```R
# 可以对要分组的列进行表达式判断，按其真假进行分组
mtcars_dt[,.(mean_mpg = mean(mpg),.N),by=.(cyl>5,vs)]
# 也可以用函数进行简单的分组
mtcars_dt[,.(hp),by=sign(cyl-6)]
```

## 4.4 `.SD` 和`.SDcol` 关键词

**对j参数进行计算时，必须分别对每列指定 mean() 函数吗 ？** 

如上面的例子，要对分组变量进行计算难道都要指定每一列？可以采用`.SD` 函数，它常和`.SDcols`函数联合使用。

  - `.SD` 是经过`i` 和`by` 处理之后剩下的那部分数据集, 本质是一个`data.table`对象.
  - 另一种理解, **`.SD`代表行经过`i` 筛选后, 除了`by`参数指定的列以外的所有列组成的新的data.table, 是原数据的子集**
  - 首先,对`i`参数进行筛选, 然后把 `by`参数指定的那一列会被提前到首列, 其余列被按`by`指定的列进行分组组成新的`data.table`对象, 分成多少组,就有多少个`data.table` 对象, 这里的多个`data.table`对象出现的顺序是按照`by`指定列值出现的顺序
  - `.SD`只能在位置j中使用, 且只能在`:=`右边使用
  - 由于`.SD` 默认包含用于分组的所有列。我们需要指定列进行计算 -----可用关键词`.SDcol`
  - `.SDcols`指定`.SD `包括哪些列. eg: `.SDcols = c("disp","hp")`,  则  `.SD` 从默认的所有列改为只包含`disp`和`hp`这两列。
  - 我们也可以使用` -` 或者` ! `来移除列。比如:我们指定` !(colA:colB)` 或者` -(colA:colB)`表示移除从 `colA` 到 `colB` 的所有列。

```R
library(data.table)
mtcars_dt = data.table::as.data.table(mtcars)
mtcars_dt[, .SD, by=cyl] # 注意此时cyl 从第二列变成了第一列,故by指定的列提前到第一列,其余列顺序保持不变

mtcars_dt[, print(.SD), by=cyl] # 注意了多个data.table对象, 每一个对象是按照cyl值的先后顺序输出的

mtcars_dt[, lapply(.SD[, 1:2, with=F], mean), by=cyl] #.SD代表除了by指定的所有列组成的新data.table, 并选择新的data.table的前两列进行计算

# 按cyl vs变量进行分组后，对其余的每一列求均值
mtcars_dt[,lapply(.SD, mean),by=.(cyl,vs)]

# 按cyl分组以后对其余变量求和
mtcars_dt[,lapply(.SD, sum),by=.(cyl)] 

# 如果要对大量的变量做聚合计算，可以使用.SD函数，和.SDcols函数。
# 默认的，.SD函数指对所有变量进行计算
mtcars_dt[, lapply(.SD, mean)]

#只对某些特定的列 结合.SDcols参数
mtcars_dt[, lapply(.SD, mean), .SDcols = c("cyl", "vs")]#只对cyl, vs列进行计算

# 对多个变量实现多个统计指标计算
mtcars_dt[, sapply(.SD, function(x) c(mean=mean(x), median=median(x)))]
```

## 4.5 如果要对子集进行分组统计怎么办？，即对选出的i进行分组统计.  

可用`by=列名即可`允许按每一个已知i的子集分组，在使用by=.EACHI时需要设置键值 

```R
mtcars_dt[cyl==4 | cyl==8,mean(mpg),by = cyl]
```

# 5分组汇总的同时排序 —— keyby

和上面的by参数有什么不同？

data.table本身就被设计成能保持原数据的顺序。**在一些情况下，必须保持原来的顺序**。但是，有时我们**希望自动根据分组的变量排序**。使用`keyby`参数，使用参数`keyby`自动将引用的列设置为主键

1.  如何按照分组的变量排序

```R
mtcars_dt <- data.table(mtcars)
# 未设置主键时，分组变量cyl，vs是按原来mtcars_dt数据集中的顺序排序的
mtcars_dt[, .(mean_mpg = mean(mpg),.N), by=.(cyl,vs)]

#设置主键 ，把cyl,vs列设置主键--会根据分组的变量排序。
mtcars_dt[, .(mean_mpg = mean(mpg),.N), keyby=.(cyl,vs)]# 注意这里keyby里面不能进行降序排列，若在vs前面加一个负号，这等于在变量vs乘－1

# 等价
mtcars_dt[,.(mean_mpg = mean(mpg),.N),by=.(cyl,vs)][order(cyl,vs)]

```

# 6. chaining表达式

```R
我们可以一个接一个地添加表达式，做一系列操作，就像这样：
   1，DT[...][...][...]。
   2，DT[...
	         ][...
 	         ][...
 		        ]
```

比如要提取前面几行就可以`DT[...][1:5]`, 

- 大多数情况下没有问题, 有些时候可以在最后面加个空, eg: `DT[...][1:5][]` , 这样可以保证返回`data.table` 数据格式
- 发生这种原因,大多数和 `:=` 有关系, 如下

```R
# eg:
a = iris_dt[1:3, 1:4][, id := 1:3]  # 不会在控制台显示结果, 必须要显示打印: print(a)
### 如果换一个写法就不会啦
a = iris_dt[1:3, 1:4][, id := 1:3][]  # 直接正常显示,打印
```

**以上就是data.table的基本操作,后续更新一些本报的一些基本概念和其他函数**



# 7总结

data.table的语法形式是： 

```R
DT[i, j, by]
```

指定参数i： 

```R
* 类似于data.frame，我们可以subset行，除非不需要重复地使用 DT$，既然我们能将列当做变量来引用。 
* 我们可以使用order()排序。为了得到更快速的效果，order()函数内部使用了data.table的快速排序。 
我们可以通过参数i做更多的事，得到更快速的选取和连结。
```

指定参数j：

```R
* 以data.table的形式选取列：DT[, .(colA, colB)]。
* 以data.frame的形式选取列：DT[, c("colA", "colB"), with=FALSE]。
* 按列进行计算：DT[, .(sum(colA), mean(colB))]。
* 如果需要：DT[, .(sA =sum(colA), mB = mean(colB))]。
* 和i共同使用：DT[colA > value, sum(colB)]。
```

指定参数by：

```R
* 通过by，我们可以指定列或表达式，进行分组。参数j可以很灵活地配置参数i和by实现强大的功能。
* by可以指定多个列，也可以指定表达式。
* 我们可以用 keyby，对分组的结果自动排序。
* 我们可以在参数j中指定 .SD 和 .SDcols，对复数的列进行操作。例如：   
  1.把函数fun 应用到所有 .SDcols指定的列上，同时对参数by指定的列进行分组：
  							DT[, lapply(.SD, fun), by=., .SDcols=...]。 
  2.返回每组册前两行：DT[, head(.SD, 2), by=.]。
  3.三个参数联合使用：DT[col > val, head(.SD, 1), by=.]。
```

小提示：
只要j返回一个list，这个list的每个元素都会是结果data.table的一列。

https://youngspring1.github.io/2016/2016-03-13-datatable1/

https://youngspring1.github.io/2016/2016-03-21-datatable2/

https://youngspring1.github.io/2016/2016-03-22-datatable3/

https://youngspring1.github.io/2016/2016-04-02-datatable4/

https://youngspring1.github.io/2016/2016-04-08-datatable5/

