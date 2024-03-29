---
title: 环境
date: '2019-05-02'
categories: r
---



# 环境

详细的解释可以查看书《高级R语言编程指南》,这里总结一份与环境有关的函数总结：(参考R语言核心技术手册第二版)

| 函数                      | 描述                                                         |      |
| ------------------------- | ------------------------------------------------------------ | ---- |
| assign                    | 在envir环境中将名称x赋给value对象                            |      |
| get                       | 在envir环境中获得与名称x关联的对象                           |      |
| exists                    | 判断在环境envir是是否定义了名称x                             |      |
| objects                   | 以向量的形式返回envir环境中定义的所有(对象)名称              |      |
| remove                    | 从envir环境中将参数中罗列的对象删除(列表不适合作为参数的名称，尤其当参数是向量时) |      |
| search                    | 以向量的形式列出全局环境的所有父环境，也称为搜索路径         |      |
| searchpaths               | 以向量的形式返回全局环境的所有父环境的路径                   |      |
| attach                    | 将列表、数据框或数据文件中的对象添加到当前的搜索路径中       |      |
| detach                    | 将列表、数据框或数据文件中的对象从当前的搜索路径中删除       |      |
| emptyenv                  | 空环境对象，它是所有环境的祖先，也是唯一一个没有父环境的的环境 |      |
| parent.env                | 查看envir环境的父环境                                        |      |
| baseenv                   | 基础环境，它是R基础软件包的环境，它的父环境是空环境          |      |
| globalenv(或`.GlobalEnv`) | 用户的工作环境，也叫全局环境，通常情况下我们就是在这个环境中工作的，全局环境的父环境是由library() 或require()添加的最后一个添加包 |      |
| environment               | 它是当前环境，(默认情况下，当前环境等于全局环境)             |      |
| new.env                   | 手动创建一个新的环境对象                                     |      |
| parent.frame              | 返回函数被调用的环境 ,即可以访问调用环境的父环境，常常作为参数使用，需要搭配其他函数eg:eval |      |
|                           |                                                              |      |
|                           |                                                              |      |
|                           |                                                              |      |





## 函数调用 — 以堆栈的形式调用

调用栈的操作

| 函数         | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| sys.call     | 返回一个包含当前函数调用(包括参数)的语言对象                 |
| sys.frame    | 返回调用环境                                                 |
| sys.nframe   | 返回当前帧的编号(即在调用堆栈中的位置)，如果在R控制台中调用该函数，返回值为0, |
| sys.function | 返回当前计算的函数                                           |
| sys.parent   | 返回父环境的编号                                             |
| sys.calls    | 返回栈中所有帧的调用                                         |
| sys.frames   | 返回栈中所有的环境                                           |
| sys.parents  | 返回栈中每个帧的父帧                                         |
| sys.on.exit  | 返回当前on.exit所使用的表达式                                |
| sys.status   | 返回一个列表                                                 |
| parent.frame | 返回sys.frame(sys.parent(n))  ,即返回函数被调用的父环境，即允许访问调用父环境.常常作为参数使用，需要搭配其他函数eg:eval |
|              |                                                              |
|              |                                                              |
|              |                                                              |





## 参考

《R语言核心编程技巧第二版》








