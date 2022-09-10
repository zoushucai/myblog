---
title: 并行化计算之foreach包
date: '2018-04-08'
categories:
  - r
---




foreach包执行任务的核心理念与传统的apply组函数基本一致，都是与split – apply – combine一致的流程，不过foreach比传统apply组函数的优越之处在于，它可以通过调用操作系统的多核运行性能来执行并行任务，这样特别是对于I/O密集型任务而言，可以大大节省代码执行效率。

**解读foreach()函数**

```R
library("doParallel")      #加载doParallel包用于之后注册进程
library("foreach")         #导入foreach包
########################################################################
##########  foreach()函数主要是对原本的for循环进行并行运算 ###############
#########################################################################
#############并行化格式
detectCores() #这个网上说是核数，但实际上是线程数，和真实的物理核多一倍，4核8线程
cl<- makeCluster(detectCores())      # 不过R中能运行满线程 ，即detectCores()返回的核数。
registerDoParallel(cl)       #进行进程注册
mydata1 <- foreach(
          ...,        # 并行化参数（循环参数）,当参数为两个以上时，选长度较短的循环完为止.
          .combine,  #合并方式，default是list，“c”返回vector,cbind和rbind返回矩阵,也可以自定义函数.
                      # "+"和"*"是対返回后的list进行同列操作
          .init,      #.combine函数的第一个变量,当.combine参数被具体化是才用
          .final=NULL, #返回最后结果
          .inorder=TRUE,#返回和原始输入相同顺序的结果
          .multicombine=FALSE,#设定.combine函数的传递参数，FALSE表示其参数是2，TRUE可以设定多个参数
          .maxcombine=if (.multicombine) 100 else 2,  #设定.combine的最大参数
          .errorhandling=c('stop', 'remove', 'pass'),#如果循环中出现错误，对错误的处理方法
          .packages=NULL,# 指定在%dopar%运算过程中依赖的package（%do%会忽略这个选项）。
          .export=NULL, # 在编译函数的时候需要预先加载一些内容进去，类似parallel的clusterExport
          .noexport=NULL,
          .verbose=FALSE) ##是否打印运行信息
  ) %dopar% {***} #并行的代码，也可以是相应的函数,即我们for循环的函数体

stopCluster(cl)   # 结束集群

```

注意：平时我们大多数使用时，很多参数都选取默认状态，其中常用参数为：`...` 、`.combine`、`.packages`.





**基本操作**

```R
library("doParallel")      #加载doParallel包用于之后注册进程
library("foreach")         #导入foreach包
cl<- makeCluster(detectCores()-1)      
registerDoParallel(cl)       #进行进程注册
getDoParWorkers()  #  #查看注册了多少个核

code=function(){
    x1<-(a + b);
    x2<-a*b;
    c(x1,x2);  
}

# 并行化参数,当参数为两个以上时，选长度较短的循环完为止.
(x <- foreach(a=1:10, b=rep(10, 3),.combine=list) %dopar% code())

(x <- foreach(a=1:10, b=rep(10, 3), .combine="c") %dopar% code())#每次的结果按向量排列合并为向量

(x <- foreach(a=1:10, b=rep(10, 3), .combine="cbind") %dopar% code())#每次的结果按列排列合并为矩阵

(x <- foreach(a=1:10, b=rep(10, 3), .combine="rbind") %dopar% code())#每次的结果按行排列合并为矩阵

#  # "+"和"*"是対返回后的list(或者rbind)结果，对其结果进行同列"+"或"*"操作
(x <- foreach(a=1:10, b=rep(10, 3), .combine="+")%dopar% code())  

(x <- foreach(a=1:10, b=rep(10, 3), .combine="*") %dopar% code())


#.combine使用自定义函数,也是对返回的list进行同列操作

cfun <- function(a, b) paste(a,b,sep = ",")
(x <- foreach(a=1:3, b=rep(10, 3), .combine="cfun") %dopar% code())

stopCluster(cl)   # 结束集群
```

**常用操作**

巧好最近在研究爬虫，以R爬虫为列，

```R

library(rvest)
library(data.table)
library(tibble)
library(dplyr)
library(stringr)
##################################################################
################  对某单一页面进行操作提取
people_information=function(url){
  web=read_html(url,encoding = "GBK")
  people_info=web %>% html_nodes("table.teach_info_table>tr>td")%>% html_text()
  people_info=people_info[-5] #这里是储存照片的地方
  
  people_attr=c()
  people_value=c()
  for(i in 1:length(people_info)){
    if(i%%2==1){
      people_attr=append(people_attr,people_info[i])
    }else {
      people_value=append(people_value,people_info[i])
    }
  }
  
  people_info=data.frame(people_attr,people_value) %>% apply(.,2,function(x){gsub("(\\t)","",x)}) %>% as.data.frame()
  people_info=apply(people_info, 2, str_trim)
  Sys.sleep(5)
  return(people_info)
}
#########################################################################
########### 读取我们要爬取的所有链接（这里的链接，我提前已经爬取好了，存储在本地）
df=fread("people.csv",encoding = "UTF-8")
link_finally=df[,link_finally]
len=length(link_finally)# 3000+多个网页
p_info=data.frame()


################################################################
##################### 并行化爬取
library("doParallel")      #加载doParallel包用于之后注册进程
library("foreach")         #导入foreach包
##### 我要循环爬取的信息
myfun=function(i){
  people_information(i) %>% as.data.frame()
}
##### 每次循环完成获得的数据，进行如下两两合并
bind_fun=function(a,b){
  full_join(a,b,by = "people_attr")  %>% as.data.frame()
}
######### 并行开始
cl<- makeCluster(detectCores()-1)      
registerDoParallel(cl)       #进行进程注册
p_info <- foreach(i=link_finally[1:len], #循环的长度,不在是"in"
                  .combine="bind_fun",
                  .packages = c("rvest", "data.table","tibble","dplyr","stringr") 
                  ) %dopar% myfun(i)
stopCluster(cl)   
####### 结束并行

##########################################################################
##### 对抓取的结果p_info数据进行处理
colnames(p_info)=1:dim(p_info)[2]
p_info=t(p_info)
write.csv(p_info,"people_info3333.csv",row.names = F)
```



**补充函数**

- detectCores()             #查看自己电脑的线程数，
- getDoParWorkers( )    #查看注册了多少个核，配合doMC package中的registerDoMC( )使用  
- getDoParRegistered( ) # 查看doPar是否注册；如果没有注册返回FALSE  
- getDoParName( )       #查看已经注册的doPar的名字  
- getDoParVersion( )    #查看已经注册的doPar的version 
