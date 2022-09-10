---
title: R语言字符处理---基本函数
date: '2018-04-05'
categories: r
---


## R语言字符处理---基本函数



| 函数                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Encoding(x)        <br>Encoding(x) <- value  <br>enc2native(x)  <br>enc2utf8(x) | 读取或设置字符向量的编码<br>常结合iconv(x, from = "", to = "")函数使用<br>注意：Encoding(x) <- value 这是一种赋值函数 |
| nchar(x, type = "chars", allowNA = FALSE, keepNA = NA)<br>nzchar(x, keepNA = FALSE) | nchar()返回字符长度<br>nzchar()判断是否空字符<br>keepNA为真是NA保留，不计入计数<br>对于缺失值NA，nchar和nzchar函数默认是字符数为2的字符串。<br>对于NULL，nchar和nzchar函数会忽略掉。 |
| substr(x, start, stop)<br>substring(text, first, last = 1000000L)<br>substr(x, start, stop) <- value<br>substring(text, first, last = 1000000L) <- value | 提取或替换字符向量的子字段，substring同substr功能一样        |
| strtrim(x, width)                                            | 按显示宽度截断字符串                                         |
| paste (..., sep = " ", collapse = NULL)<br>paste0(..., collapse = NULL) | 通过sep连接间隔连接对象,返回字符串向量<br>设定collapse的话，会通过collapse连接间隔将上一步的字符串向量连接成一个字符串 |
| strsplit(x, split, fixed = FALSE, perl = FALSE, useBytes = FALSE) | 基于split子句分割字符向量x<br>fixed为TRUE的话，完全匹配split；否则，基于正则表达式。<br>可以使用split=NULL来分割每个字符。 |
| chartr(old, new, x)                                          | 将x中的字符old变换为字符new<br>注意替换的是单个对应的字符，而非字符串 |
| tolower(x)<br>toupper(x)                                     | 大小写转换                                                   |
| sprintf(fmt, ...)                                            | 系统C库函数sprintf封装器，格式化输出函数                     |
|                                                              |                                                              |



## 正则表达式-----字符串匹配函数

| 函数                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| grep(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE,fixed = FALSE, useBytes = FALSE) | 若x为list，则找出和(参数pattern)匹配的序列编号<br>若x为字符串，则判别改字符串中是否包含特定的字符,包含返回1，不包含返回integer(0)<br>若x为字符向量,同list<br>只找到第一个即可 |
| grepl(pattern, x, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | 返回TRUE 或FALSE                                             |
| sub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | 只替换匹配到的第一个字符串                                   |
| gsub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | 替换匹配到的所用字符串                                       |
| regexpr(pattern, text, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | 返回第一个和(参数pattern)匹配的起始位置(或下标)和匹配长度(pattern的长度，若为正则，则是匹配字符串的实际长度)<br>若没有则返回: -1 |
| gregexpr(pattern, text, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | regexpr()函数只匹配第一个，想要多次匹配则用gregexpr()函数    |
| regexec(pattern, text, ignore.case = FALSE, perl = FALSE,fixed = FALSE, useBytes = FALSE) | 和regexpr()函数一样                                          |
|                                                              | 共同参数解析：<br>   1、fixed = TRUE: 使用精确匹配<br>   2、perl = TRUE: 使用Perl风格正则表达式<br>   3、fixed = FALSE且perl = FALSE: 使用POSIX 1003.2扩展正则表达式<br>   4、 useBytes = TRUE时逐字节匹配，否则逐字符匹配 |
| regmatches(x, m, invert = FALSE)<br>regmatches(x, m, invert = FALSE) <- value | 抽取或替换正则表达式匹配子串<br> invert = TRUE则抽取或替换不匹配子串<br> str<-c("Now is ","the"," time ") <br>m<-regexpr(" +",str)<br>regmatches(str,m)<- "9999"<br>str |
| glob2rx(pattern, trim.head = FALSE, trim.tail = TRUE)        | 将通配符模式变成正则表达式                                   |
|                                                              |                                                              |

### grep()函数参数：

|    参数     |                             功能                             |
| :---------: | :----------------------------------------------------------: |
|   pattern   |                    包含正则表达式的字符串                    |
|      x      | 寻找匹配的字符向量，或者可以通过字符向量强制转换的对象。支持长向量 |
| ignore.case | 如果为FALSE，则模式匹配区分大小写；如果为TRUE，则在匹配期间忽略大小写 |
|    perl     |             如果为TRUE，使用perl匹配的正则表达式             |
|    value    | 如果为FALSE，则返回包含由grep确定的匹配的索引的向量，如果为TRUE，则返回包含匹配元素本身的向量 |
|    fixed    |         如果为TRUE，则pattern是要按原样匹配的字符串          |
|  useBytes   |         如果为TRUE，则匹配是逐字节而不是逐字符完成的         |
|   invert    |           如果为TRUE，则返回不匹配的元素的索引或值           |

grep()能对向量中特定条件的元素进行查询，默认return为index,。grep()语法与grep()大致相似，但默认return为logical。
