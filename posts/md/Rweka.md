---
title: Rweka包解读
date: '2015-11-16'
categories: r
---


## 1. 数据输入和输出
```R
WOW()：查看Weka函数的参数。
Weka_control()：设置Weka函数的参数。
read.arff()：读(ARFF)格式的数据。一般的数据需要用这两个函数（先写再读）进行转换成（arff）格式的数据
write.arff()：将数据写入Weka Attribute-Relation File Format (ARFF)格式的文件。
```
## 2. 数据预处理
- `Normalize()`：无监督的标准化连续性数据,即min-max标准化。对于字符、逻辑、因子变量跳过，只对连续数据标准化

- `Discretize()`：用MDL(最小描述长度)方法，有监督的离散化连续性数值数据。感觉用处不大，把连续的数据全离散成“all”字符


## 3. 分类和回归
-  `IBk()`：k最近邻分类，用法和LBR一样

-  `LBR()`：naive Bayes法分类

```R
   RWeka包中的IBK函数实现knn算法
        * model=IBk(formula, data, subset, na.action,control = Weka_control(), options = NULL)
                + formula:公式，分类变量~特征，和回归一样
                + data : 训练数据集,必须为*.raff格式的数据,对于R中的数据，
                      + 可以先把某个对象先用write.arff(iris,'iris.arff')写成raff文件格式
                      + 再次用read.arff("iris.arff")读入R内存中即可
                + control:参数控制 control=Weka_control(K= 22,X = TRUE) 
                      + X K都为大写，表示自动选取1：K=22里面最适合的K近邻分类 
             
        * evaluate_Weka_classifier(object, newdata = NULL, cost = NULL, 
                                   numFolds = 0, complexity = FALSE,
                                   class = FALSE, seed = NULL, ...)
                + object: 一个Weka_classifier对象,Rweka建立的分类对象模型
                + newdata: 测试数据，若为省略或为0 ，则为训练数据
                + numFolds： k-交叉验证
```

- 
  J48()：C4.5决策树算法（决策树在分析各个属性时，是完全独立的）。

- LMT()：组合树结构和Logistic回归模型，每个叶子节点是一个Logistic回归模型，准确性比单独的决策树和Logistic回归方法要好。
- M5P()：M5 模型数算法，组合了树结构和线性回归模型，每个叶子节点是一个线性回归模型，因而可用于连续数据的回归。
- DecisionStump()：单层决策树算法，常被作为boosting的基本学习器。
- SMO()：支持向量机分类
- AdaBoostM1()：Adaboost M1方法。-W参数指定弱学习器的算法。
- Bagging()：通过从原始数据取样(用替换方法)，创建多个模型。
- LogitBoost()：弱学习器采用了对数回归方法,学习到的是实数值
- MultiBoostAB()：AdaBoost 方法的改进，可看作AdaBoost 和 “wagging”的组合。
- Stacking()：用于不同的基本分类器集成的算法。
- LinearRegression()：建立合适的线性回归模型。
- Logistic()：建立logistic回归模型。
- JRip()：一种规则学习方法。
- M5Rules()：用M5方法产生回归问题的决策规则。
- OneR()：简单的1-R分类法。
- PART()：产生PART决策规则。

## 4) 聚类

- Cobweb()：这是种基于模型方法，它假设每个聚类的模型并发现适合相应模型的数据。不适合对大数据库进行聚类处理。
- FarthestFirst()：快速的近似的k均值聚类算法
- SimpleKMeans()：k均值聚类算法
- XMeans()：改进的k均值法，能自动决定类别数
- DBScan()：基于密度的聚类方法，它根据对象周围的密度不断增长聚类。它能从含有噪声的空间数据库中发现任意形状的聚类。此方法将一个聚类定义为一组“密度连接”的点集。

## 5）关联规则

- Apriori()：Apriori 是关联规则领域里最具影响力的基础算法，是一种广度优先算法，通过多次扫描数据库来获取支持度大于最小支持度的频繁项集。它的理论基础是频繁项集的两个单 调性原则：频繁项集的任一子集一定是频繁的；非频繁项集的任一超集一定是非频繁的。在海量数据的情况下，Apriori 算法的时间和空间成本非常高。
- Tertius()：Tertius算法。

## 6）预测和评估：

- predict()：根据分类或聚类结果预测新数据的类别
- table()：比较两个因子对象
- evaluate_Weka_classifier()：评估模型的执行，如：TP Rate，FP Rate，Precision，Recall，F-Measure。

   
