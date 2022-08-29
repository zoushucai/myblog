---
title: R软件常见问题
date: '2018-01-07'
categories:
  - r
  - hugo
---


## 1、读取数据编码问题

- 读取csv文件出现中文乱码方案，增加编码格式参数

  ```R
  read.csv(trainPath,header=TRUE,stringsAsFactors=TRUE,encoding = "UTF-8")
  ```

- 保存csv文件中出现乱码，编码格式参数

  ```R
  write.csv(outp, file = path, quote = F, fileEncoding = "UTF-8")
  #存储utf-8也乱码，我的电脑有时会发疯，有时又不会
  ```

- source 加载R脚本中文乱码

  ```R
  source("core.R",encoding="utf-8")
  ```


- RStudio中脚本中文乱码，编码格式设置：tools -> global option...., 设置为UTF-8，最后，在打开文件的时候，选择File -> Reopen with encoding菜单，选择我们使用UTF-8编码打开文件，这样子就可以正确地显示中文了。

- R语言环境的显示问题

  ```R
  sessionInfo()
  Sys.getlocale()
  Sys.setlocale(category = "LC_ALL",local="us")
  Sys.setlocale(category = "LC_ALL",local="chinese")
  ```

## 2、保存数据编码问题(win中)

由于用Rstudio设置了保存的编码都用UTF-8，所以在保存文件时（特别是csv文件），经常遇到乱码的现象，比如使用data.table:::fwrite()、自带的write.csv()、readr:::write_csv()都乱码

 产生的原因：

因为excel打开文件时默认使用unicode的编码方式（还有的网友说是默认以ANSI编码方式打开，待考）。在Unicode基本多文种平面定义的字符（无论是拉丁字母、汉字或其他文字或符号），一律使用2字节储存。恰恰utf-8是1字节的存储方式，所以excel直接打开时会出现乱码。

解决办法：

- **方法1、数据导入--**不建议

  打开 Excel，执行“数据”->“自文本”，选择 CSV 文件，出现文本导入向导，选择“分隔符号”，下一步，勾选“逗号”，去掉“ Tab 键”，下一步，完成，在“导入数据”对话框里，直接点确定。导入之后，所有汉字显示正常，乱码问题解决。

  万一这个文本里面的有逗号，巧好分割时候是逗号（csv文件是以逗号进行存储的）,这就会对不齐了，产生新的问题

- **方法2、先另存再打开**

  使用记事本打开CSV文件，“文件”->“另存为”，编码方式选择ANSI，保存完毕后，用EXCEL打开这个文件就不会出现乱码的情况。

  不会乱码以后选择另存为excel

- **方法3、用readr:::write_excel_csv()函数解决**

  直接用write_excel_csv()这个函数就可以解决上述问题



## 3、加载java问题

1. 首先下载java ，把java加入环境变量，测试是否安装成功，在cmd命名下输入: java -version,返回

   ```bash
   C:\Users\zsc>java -version
   java version "1.8.0_151"
   Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
   Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)
   ```

   

2. 如果上述都没问题，在R中运行rjava还是报错怎么办？比如，导入包library(xlsx)的时候，出错：

```R
> library(xlsx)
载入需要的程辑包：rJava
Error: package or namespace load failed for ‘rJava’:
 loadNamespace()里算'rJava'时.onLoad失败了，详细内容：
  调用: inDL(x, as.logical(local), as.logical(now), ...)
  错误: unable to load shared object 'D:/Program Files (x86)/R/R-3.4.2/library/rJava/libs/x64/rJava.dll':
  LoadLibrary failure:  找不到指定的模块。
Error: 无法载入程辑包‘rJava’
```

解决方法：因为在运行R的过程中，通常会需要调用rJava.dll来运行虚拟环境。这种情况，一般是系统中装了JAVA环境后安装其他软件的时候再次装了JAVA的类库rJava.dll，R的运行环境无法调用确认项。找到自己安装的JAVA环境，去配置R的系统环境中的rJava.dll：

​			`Sys.setenv(JAVA_HOME='D:/Program Files (x86)/Java/jdk1.8.0_144/jre')` 

再次运行library(xlsx),就可以了！(不过每次都要设置，可以在R的配置文件中更改哦！)

## 4、ggplot2作图标题无法居中

好像新版的ggplot2包标题默认居左，只需要在作图函数后面加上	  	

​			  			  `theme(plot.title = element_text(hjust = 0.5))  ` 

这行就好了

## 5、R更新

Windows系统中使⽤installr 套件的方式来更新R。建议在R终端机（termianl）中操作。

```R
install.packages("installr") # 安装installr
installr::updateR() # 未来要更新的R的时候，只要执行这行即可​
```

