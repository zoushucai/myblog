---
title: tibble包的列和行名相互转换以及添加行和列
date: '2017-12-31'
categories:
  - r
  - dplyr
---


## 1、列与行名相互转化
tibble包：

  + has_rownames(df)：检查是否存在行名

  + remove_rownames(df) ： 移除行名

  + rownames_to_column(df, var = "rowname") ： 行名变为某列

    + rowid_to_column(df, var = "rowid")： 行名变为某列,只能变为数字,个人不推荐

  + column_to_rownames(df, var = "rowname") ：  某列变为行名，并删除某列,要求这个列值唯一
  
```R
library(tibble)
head(mtcars)
has_rownames(mtcars) #检查是否存在行名
new_mtcars=rownames_to_column(mtcars, var = "new_col") #行名变为某列,行名此时被移除
head(new_mtcars)



has_rownames(rownames_to_column(mtcars, var = "new_col"))
has_rownames(rowid_to_column(mtcars, var = "new_col"))


df=remove_rownames(mtcars)#： 移除行名
head(df)
column_to_rownames(new_mtcars, var = "new_col")#  某列变为行名，并删除某列,要求这个列值唯一
```
## 2、添加行与列
添加行：
  + add_row(.data, ..., .before = NULL, .after = NULL)
   
添加列：
  + add_column(.data, ..., .before = NULL, .after = NULL)

   > + .before 指添加在第n行(列)，默认在最后
   > + .after 指添加在第n行(列)后（即n+1行(列)）
   
```R
df <- tibble(x = 1:3, y = 3:1)

add_row(df, x = 4, y = 0) #默认在最后添加

add_row(df, x = 4, y = 0, .before = 2)# 指定添加在第二行


add_row(df, x = 4:5, y = 0:-1) #也可以用向量添加多行，但是不推荐

add_row(df, x = 4) #添加变量不完整，则用NA添加，但是不能创建新变量
# 但是不能创建新变量，这个是错的  add_row(df, z = 10)

```

```R
df <- tibble(x = 1:3, y = 3:1)

add_column(df, z = -1:1, w = 0)

# 不能覆盖创建原来的列，也不能修改原来的列
```

