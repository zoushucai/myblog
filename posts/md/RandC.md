---
title: R结合C++
date: '2019-05-24'
categories: r
---



# 1. R结合C++

首先要配置好`R`和`C++`的环境，在R官网中分别有不同操作系统的环境配置条件，按照下载R软件的步骤，在下载R软件页面有相应的配置说明。如果是mac系统也可以参考这篇文章：[macOS](http://thecoatlessprofessor.com/programming/r-compiler-tools-for-rcpp-on-macos/)

基本的用法可以参考：

1.  [http://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/rcpp.html](http://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/rcpp.html) 
2.  个人建议要写`c++ `代码给`R`软件使用，建议不要混合编程，我只是简单的实验过，这样会降低代码运行的效率，甚至，可能比R本身的运算还慢。
3. 基本的`c++` 大概能写一些简单的循环运算，但要涉及比较复杂的矩阵运算此时需要额外的库，不过不怕麻烦你自己也可以用`c++`写，这里推荐使用[Armadillo](http://arma.sourceforge.net/) 库，语法和`MATLAB`很相似，上手很快。

4. 由于查资料发现，[Armadillo](http://arma.sourceforge.net/) 被[RcppArmadillo](http://dirk.eddelbuettel.com/code/rcpp.armadillo.html)包给封装了，但基本没有对其做任何更改，所以你只需要简单的引入相应的`Rcpp`环境，就能简单的写`c++`了，再次说明，`c++`中最好不要混写R代码。

5. CSDN上有关`Armadillo`库的介绍，个人觉得还不错，https://blog.csdn.net/jnulzl/article/details/46808515

6. `c++ `并行运算对比 以及`RcppArmadillo`包的使用，如下，先做总结，推荐使用`feature.apply`包来并行`c++`代码，虽然有时候没有`C++ openMP`快，但是基本上符合人们需求，而且`feature.apply`包使用起来很简单，相对于其他`R`并行计算的包，不出错，记得使用`doParallel`包来并行`C++`总是出错，所以推荐`feature.apply`并行。




# 2. R运行速度对比

## 2.1 C++ 加上 feature.apply 并行

把下面的代码存为`sample_c.cpp`，然后运行`Rcpp::sourceCpp('sample_c.cpp')`即可

- `sample_mat` ： 随机构造n阶正互反判断矩阵
- `eig_max`：  求矩阵的最大特征值
- `veig_max(int n,int k =10000)`: 求k个n阶的最大特征值，返回一个向量。

```cpp
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <Rcpp.h>
using namespace Rcpp;
using namespace arma;


// [[Rcpp::export]]
mat sample_mat(int n)
{
  // 第一步： 随机构造n阶正互反判断矩阵
  vec  P = {1,2,3,4,5,6,7,8,9,1/2.0,1/3.0,1/4.0,1/5.0,1/6.0,1/7.0,1/8.0,1/9.0};
  vec  v = randu<vec>(0.5*n*(n-1)); //声明一个向量，并赋予随机值
  v *= 17;
  v = floor(v);
  
  
  mat A(n,n); // 声明一个n*n的矩阵
  int i = 0,j = 0,k=0,temp = 0;
  
  for(i = 0; i<n;i++){
    for(j =0; j<n;j++){
      if( i >j){
        temp =  static_cast<int>(v(k++));
        A(i,j) = P(temp);
        A(j,i) = 1/ P(temp);
      }else{
        A(i,j) =1;
      }
    }
  }
  return(A);
}


// [[Rcpp::export]]
double eig_max(mat A)
{
  // 第二步：求矩阵的最大特征值
  cx_vec eigval = eig_gen(A);
  return max(real(eigval));
}

// [[Rcpp::export]]
NumericVector veig_max(int n,int k =10000){
  int m = 0;
  mat A;
  NumericVector res(k);
  for(m = 0; m<k;m++){
    A = sample_mat(n);
    res(m) = eig_max(A);
  }
  return res;
}
```

## 2.2 利用c++ openMP并行

同理，把下面代码保存为`veig_max_mp.cpp`, 运行	` Rcpp::sourceCpp('veig_max_mp.cpp')`,只输出一个`veig_max_mp`函数，

由于c++中利用了并行，所R中不能再进行并行了，这样会报错。

```cpp
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <Rcpp.h>
#include <omp.h>
using namespace Rcpp;
using namespace arma;

double CI(int n)
{
  vec  P = {1,2,3,4,5,6,7,8,9,1/2.0,1/3.0,1/4.0,1/5.0,1/6.0,1/7.0,1/8.0,1/9.0};
  vec  v = randu<vec>(0.5*n*(n-1)); //声明一个向量，并赋予随机值
  v *= 17;
  v = floor(v);
  
  mat A(n,n); // 声明一个n*n的矩阵
  int i = 0,j= 0,k=0,temp =0;
  for(i = 0; i<n;i++){
    for(j =0; j<n;j++){
      if( i >j){
        temp =  static_cast<int>(v(k++));
        A(i,j) = P(temp);
        A(j,i) = 1/ P(temp);
      }else{
        A(i,j) =1;
      }
      
    }
  }
  cx_vec eigval;
  
  eig_gen(eigval,A);
  // cout<< omp_get_max_threads() << endl;
  return max(real(eigval));
}

// [[Rcpp::export]]
NumericVector veig_max_mp(int n,int k =10000){
  int ii = omp_get_max_threads();
  omp_set_num_threads(ii-1);
  int m = 0;
  NumericVector res(k);
  #pragma omp parallel for
  for(m =0; m<k;m++){
    res(m) = CI(n);
  }
  return res;
}



```

## 2.3运行对比

利用上面的函数，在R中运行进行对比(在24核32G的服务器上)

```R
system.time({
  d = lapply(3:20,veig_max_mp, k=1000000)
})

library(future.apply)
plan(multicore)
system.time({
    b = future_lapply(3:20,veig_max,k=1000000)
})


system.time({
    b = lapply(3:20,veig_max,k=1000000)
})
```

时间如下：

```R
> system.time({
+   d = lapply(3:20,veig_max_mp, k=1000000)
+ })
    user   system  elapsed 
1991.430    0.731  199.972 
> 
> library(future.apply)
Loading required package: future
> plan(multicore)
> system.time(
+   {
+     b = future_lapply(3:20,veig_max,k=1000000)
+   }
+ )
    user   system  elapsed 
1321.397    4.237  204.492 
> system.time(
+   {
+     b = lapply(3:20,veig_max,k=1000000)
+   }
+ )
    user   system  elapsed 
1514.744    0.805 1515.093 
> sessionInfo()
R version 3.5.2 (2018-12-20)
Platform: x86_64-redhat-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)

Matrix products: default
BLAS/LAPACK: /usr/lib64/R/lib/libRblas.so_

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] future.apply_1.2.0 future_1.12.0     

loaded via a namespace (and not attached):
 [1] compiler_3.5.2            parallel_3.5.2            tools_3.5.2              
 [4] RcppArmadillo_0.9.300.2.0 listenv_0.7.0             yaml_2.2.0               
 [7] Rcpp_1.0.1                codetools_0.2-16          digest_0.6.18            
[10] globals_0.12.4  
```



