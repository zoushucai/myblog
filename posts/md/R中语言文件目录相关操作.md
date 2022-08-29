---
title: R语言文件目录相关操作
date: '2017-04-08'
categories: r
---


## 1. 文件系统介绍

R语言对文件系统的操作，包括文件操作和目录操作，函数API都定义在base包中。



## 2. 目录操作

**2.1 查看目录**

查看当前目录下的子目录。

```R
 setwd()               #设定某个目录为当前目录
 getwd()               # 当前的目录
 list.dirs()           # 查看当前目录的子目录  参数详见dir()
 
 dir()                 #查看当前目录的子目录和文件。
 dir(path="C:/windows")#查看指定目录的子目录和文件
 dir(path="C:/windows",all.files=TRUE)# 列出目录下所有的目录和文件，包括隐藏文件
 dir(path="C:/windows",pattern='^R')#只列出以字母R开头的子目录或文件
 
 file.info(".")         # 查看当前目录权限
```

**2.2 创建目录**

```R
dir.create("your dir")        # 在当前目录下，新建一个目录
dir.create(path="a1/b2/c3",recursive = TRUE)  #递归创建一个3级子目录./a1/b2/c3，直接创建会出错
```

**2.3 检查目录是否存在**

```R
system("tree")                      # 通过系统命令查看目录结构
file.exists("./a1")             # 查看某个目录是否存在,可以多层次调用目录
```

**2.4 检查目录的权限**

```R
df<-dir(full.names = TRUE)         #获取当前目录的所有目录(不含子目录)和文件名（含后缀）
file.access(df, model=0) == 0      # 检查文件或目录是否存在，mode=0
         						  # 检查文件或目录是否可执行，mode=1，目录为可以执行
         						  # 检查文件或目录是否可写，mode=2
          						 # 检查文件或目录是否可读，mode=4
```

**2.5修改目录权限。**

```R
 Sys.chmod("./create", mode = "0555", use_umask = TRUE)  # 修改目录权限，所有用户只读
 
```

**2.6 对目录重名**

```R
file.rename("create", "newcreate")            # 对tcreate目录重命名为newcreate
unlink("newcreate", recursive = TRUE)         # 删除newcreate目录   递归删除
```

**2.7 其他功能函数**

```R
file.path("p1","p2","p3")                  # 拼接目录字符串
dirname(path="")                           #获得某个路径的目录名
basename(path="")                          #获得某个目录的最底层目录或者文件名
normalizePath(c(R.home(), tempdir()))      #获取目录的绝对路径
```

## 3. 文件操作

**3.1 查看文件**

```R
file.exists("readme.txt")         # 检查文件是否存在
file.info("readme.txt")            # 查看文件完整信息
file.access("readme.txt",0)        # 查看文件访问权限，存在详情见2.4
file_test("-d", "readme.txt")      #判断是文件还是目录。-d ,是目录返回ture
file_test("-f", "readme.txt")      # 判断是否是文件 .  -f 是文件但会ture

```

 **3.2 创建文件**

```R
file.create("A.txt")            # 创建一个空文件 A.txt
cat("file B\n", file = "B.txt") # 把相关的内容写入B.txt文件中，没有这个文件则创建文件并写入内容 

readLines("A.txt")         # 读取A.txt并打印
file.append("A.txt", rep("B.txt", 10))   # 合并文件,把文件B.txt的内容，合并到 A.txt。
file.copy("A.txt", "C.txt")    #把文件A.txt复制到文件C.txt ,文件复制
```

**3.3 修改文件权限**

```R
# 修改文件权限，创建者可读可写可执行，其他人无权限
Sys.chmod("A.txt", mode = "0700", use_umask = TRUE)
```

**3.4 文件重命名**

```R
file.rename("A.txt","AA.txt")     # 给文件A.txt重命名为AA.txt
```

**3.5 删除文件**

有两个函数可以使用file.remove和unlink，其中unlink函数使用同删除目录操作是一样的。

```R
file.remove("A.txt", "B.txt", "C.txt")      # 删除文件
unlink("readme.txt")                   # 删除文件
system("ls -l")            # 查看目录文件
```

## 4. 几个特殊的目录

- `R.home()` 查看R软件的相关目录
- `.Library` 查看R核心包的目录
- `.Library.site` 查看R核心包的目录和root用户安装包目录
- `.libPaths()` 查看R所有包的存放目录
- `system.file()` 查看指定包所在的目录

参考：[http://blog.fens.me/r-file-folder/](http://blog.fens.me/r-file-folder/)
