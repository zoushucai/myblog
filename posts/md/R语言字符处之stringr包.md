---
title: R语言字符处理函数包---stringr包
date: '2018-04-05'
categories:
  - r
  - stringr
---

## 1.stringr介绍

stringr包被定义为一致的、简单易用的字符串工具集。所有的函数和参数定义都具有一致性，比如，用相同的方法进行NA处理和0长度的向量处理。

字符串处理虽然不是R语言中最主要的功能，却也是必不可少的，数据清洗、可视化等的操作都会用到。对于R语言本身的base包提供的字符串基础函数，随着时间的积累，已经变得很多地方不一致，不规范的命名，不标准的参数定义，很难看一眼就上手使用。字符串处理在其他语言中都是非常方便的事情，R语言在这方面确实落后了。stringr包就是为了解决这个问题，让字符串处理变得简单易用，提供友好的字符串操作接口。

## 2.stringr的API介绍

stringr包常用的字符串的处理以str_开头来命名，方便更直观理解函数的定义。我们可以根据使用习惯对函数进行分类：

### **字符串拼接函数**

| 函数                            | 说明                                       | R Base中对应函数                      |
| ------------------------------- | ------------------------------------------ | ------------------------------------- |
| str_c()<br>str_join() 同str_c() | 字符串拼接                                 | paste(),paste0()                      |
| str_trim())                     | 去掉字符串的空格和TAB(\t)                  |                                       |
| str_pad()                       | 用pad参数填充字符串的长度，长度自己设定    |                                       |
| str_dup()                       | 复制字符串                                 |                                       |
| str_wrap()                      | 控制字符串输出格式                         | strtrim()                             |
| str_sub()<br>str_sub() <- value | 截取字符串<br>抽取或替换正则表达式匹配子串 | regmatches()<br>regmatches() <- value |

### **字符串计算函数**

| 函数         | 说明                               | R Base中对应函数 |
| ------------ | ---------------------------------- | ---------------- |
| str_count()  | 字符串计数，返回指定匹配出现的次数 |                  |
| str_length() | 返回字符的长度                     | nchar()          |
| str_sort()   | 对字符值进行排序                   |                  |
| str_order()  | 字符串索引排序，                   |                  |

### **字符串匹配函数**

| 函数                                  | 说明                             | R Base中对应函数        |
| ------------------------------------- | -------------------------------- | ----------------------- |
| str_split()<br>str_split_fixed() 同上 | 按照模式分割字符串               | strsplit()              |
| str_match()<br>str_match_all()        | 从字符串中提取首个匹配组<br>     |                         |
| str_replace<br>str_replace_all        | 替换首个匹配模式<br>             | sub()<br>gsub()         |
| str_replace_na()                      | 把NA替换为NA字符串               |                         |
| str_locate()<br>str_locate_all()      | 返回首个匹配模式的字符的位置<br> | regexpr()<br>gregexpr() |
| str_extract()<br>str_extract_all()    | 提取首个匹配模式的字符<br>       |                         |
| str_subset()                          | 返回匹配的字符串                 |                         |
| str_detect()                          | 检测字符是否存在某些指定模式     | grepl()                 |
| word()                                | 从文本中提取单词                 |                         |

### **字符串变换函数**

| 函数                             | 说明                              | R Base中对应函数             |
| -------------------------------- | --------------------------------- | ---------------------------- |
| str_conv()                       | 字符编码转换,基本函数中的比较好用 | iconv(x, from = "", to = "") |
| str_to_upper()<br>str_to_lower() | 字符串转成大写/小写               | tolower(x)<br>toupper(x)     |
| str_to_title()<br>同大小写转换   | 字符串转成首字母大写              |                              |

### **参数控制函数**，

仅用于构造功能的参数，不能独立使用。

- boundary:	定义使用边界  
- coll:	       定义字符串标准排序规则。  
- fixed:	定义用于匹配的字符，包括正则表达式中的转义符
-  regex:	定义正则表达式



## 3.stringr的详细使用

**3.1 字符串拼接函数**

**3.1.1 str_c，字符串拼接操作，与str_join完全相同，与paste()行为不完全一致。**

函数定义：

```R
str_c(..., sep = "", collapse = NULL)
str_join(..., sep = "", collapse = NULL)
```

参数列表：

- …: 多参数的输入
- sep: 把多个字符串拼接为一个大的字符串，用于字符串的分割符。
- collapse: 把多个向量参数拼接为一个大的字符串，用于字符串的分割符。

把多个字符串拼接为一个大的字符串。

```R
> str_c('a','b')
[1] "ab"
> str_c('a','b',sep='-')
[1] "a-b"
> str_c(c('a','a1'),c('b','b1'),sep='-')
[1] "a-b"   "a1-b1"

```

把多个向量参数拼接为一个大的字符串。

```R
> str_c(head(letters), collapse = "")
[1] "abcdef"
> str_c(head(letters), collapse = ", ")
[1] "a, b, c, d, e, f"

# collapse参数，对多个字符串无效
> str_c('a','b',collapse = "-")   
[1] "ab"
> str_c(c('a','a1'),c('b','b1'),collapse='-')
[1] "ab-a1b1"

```

拼接有NA值的字符串向量时，NA还是NA

```R
> str_c(c("a", NA, "b"), "-d")
[1] "a-d" NA    "b-d"

```

对比str_c()函数和paste()函数之间的不同点。

```R
# 多字符串拼接，默认的sep参数行为不一致
> str_c('a','b')
[1] "ab"
> paste('a','b')
[1] "a b"

# 向量拼接字符串，collapse参数的行为一致
> str_c(head(letters), collapse = "")
[1] "abcdef"
> paste(head(letters), collapse = "")
[1] "abcdef"
 
#拼接有NA值的字符串向量，对NA的处理行为不一致
> str_c(c("a", NA, "b"), "-d")
[1] "a-d" NA    "b-d"
> paste(c("a", NA, "b"), "-d")
[1] "a -d"  "NA -d" "b -d" 

```

**3.1.2 str_trim:去掉字符串的空格和TAB(\t)**

函数定义：

```R
str_trim(string, side = c("both", "left", "right"))
```

参数列表：

- string: 字符串，字符串向量。
- side: 过滤方式，both两边都过滤，left左边过滤，right右边过滤

去掉字符串的空格和TAB(\t)

```R
#只过滤左边的空格
> str_trim("  left space\t\n",side='left') 
[1] "left space\t\n"

#只过滤右边的空格
> str_trim("  left space\t\n",side='right')
[1] "  left space"

#过滤两边的空格
> str_trim("  left space\t\n",side='both')
[1] "left space"

#过滤两边的空格
> str_trim("\nno space\n\t")
[1] "no space"

```

**3.1.3 str_pad:补充字符串的长度**

函数定义：

```R
str_pad(string, width, side = c("left", "right", "both"), pad = " ")
```

参数列表：

- string: 字符串，字符串向量。
- width: 字符串填充后的长度
- side: 填充方向，both两边都填充，left左边填充，right右边填充
- pad: 用于填充的字符

补充字符串的长度。

```R
# 从左边补充空格，直到字符串长度为20
> str_pad("conan", 20, "left")
[1] "               conan"

# 从右边补充空格，直到字符串长度为20
> str_pad("conan", 20, "right")
[1] "conan               "

# 从左右两边各补充空格，直到字符串长度为20
> str_pad("conan", 20, "both")
[1] "       conan        "

# 从左右两边各补充x字符，直到字符串长度为20
> str_pad("conan", 20, "both",'x')
[1] "xxxxxxxconanxxxxxxxx"

```

**3.1.4 str_dup: 复制字符串**

函数定义：

```R
str_dup(string, times)
```

参数列表：

- string: 字符串，字符串向量。
- times: 复制数量

复制一个字符串向量。

```R
> val <- c("abca4", 123, "cba2")

# 复制2次
> str_dup(val, 2)
[1] "abca4abca4" "123123"     "cba2cba2"  

# 按位置复制
> str_dup(val, 1:3)
[1] "abca4"        "123123"       "cba2cba2cba2"

```

**3.1.5 str_wrap，控制字符串输出格式**

函数定义：

```R
str_wrap(string, width = 80, indent = 0, exdent = 0)
```

参数列表：

- string: 字符串，字符串向量。
- width: 设置一行所占的宽度。
- indent: 段落首行的缩进值
- exdent: 段落非首行的缩进值

```R
 txt<-'R语言作为统计学一门语言，一直在小众领域闪耀着光芒。直到大数据的爆发，R语言变成了一门炙手可热的数据分析的利器。随着越来越多的工程背景的人的加入，R语言的社区在迅速扩大成长。现在已不仅仅是统计领域，教育，银行，电商，互联网….都在使用R语言。'

# 设置宽度为40个字符
> cat(str_wrap(txt, width = 40), "\n")
R语言作为统计学一门语言，一直在小众领域
闪耀着光芒。直到大数据的爆发，R语言变成
了一门炙手可热的数据分析的利器。随着越来
越多的工程背景的人的加入，R语言的社区在
迅速扩大成长。现在已不仅仅是统计领域，教
育，银行，电商，互联网….都在使用R语言。 

# 设置宽度为60字符，首行缩进2字符
> cat(str_wrap(txt, width = 60, indent = 2), "\n")
  R语言作为统计学一门语言，一直在小众领域闪耀着光芒。直到大数
据的爆发，R语言变成了一门炙手可热的数据分析的利器。随着越来
越多的工程背景的人的加入，R语言的社区在迅速扩大成长。现在已
不仅仅是统计领域，教育，银行，电商，互联网….都在使用R语言。 

# 设置宽度为10字符，非首行缩进4字符
> cat(str_wrap(txt, width = 10, exdent = 4), "\n")
R语言作为
    统计学一
    门语言，
    一直在小
    众领域闪
    耀着光芒。
    直到大数据
    的爆发，R
    语言变成了
    一门炙手可
    热的数据分
    析的利器。
    随着越来
    越多的工程
    背景的人的
    加入，R语
    言的社区在
    迅速扩大成
    长。现在已
    不仅仅是统
    计领域，教
    育，银行，
    电商，互联
    网….都在使
    用R语言。 

```

**3.1.6 str_sub,截取字符串**

函数定义：

```R
str_sub(string, start = 1L, end = -1L)
```

参数列表：

- string: 字符串，字符串向量。
- start : 开始位置
- end : 结束位置

截取字符串。

```R
> txt <- "I am Conan."

# 截取1-4的索引位置的字符串
> str_sub(txt, 1, 4)
[1] "I am"

# 截取1-6的索引位置的字符串
> str_sub(txt, end=6)
[1] "I am C"

# 截取6到结束的索引位置的字符串
> str_sub(txt, 6)
[1] "Conan."

# 分2段截取字符串
> str_sub(txt, c(1, 4), c(6, 8))
[1] "I am C" "m Con" 

# 通过负坐标截取字符串
> str_sub(txt, -3)
[1] "an."
> str_sub(txt, end = -3)
[1] "I am Cona"

```

对截取的字符串进行赋值。

```R
> x <- "AAABBBCCC"

# 在字符串的1的位置赋值为1
> str_sub(x, 1, 1) <- 1; x
[1] "1AABBBCCC"

# 在字符串从2到-2的位置赋值为2345
> str_sub(x, 2, -2) <- "2345"; x
[1] "12345C"

```

**3.2 字符串计算函数**

**3.2.1 str_count, 字符串计数**

函数定义：

```R
str_count(string, pattern = "")
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配的字符。

对字符串中匹配的字符计数

```R
> str_count('aaa444sssddd', "a")
[1] 3

```

对字符串向量中匹配的字符计数

```R
> fruit <- c("apple", "banana", "pear", "pineapple")
> str_count(fruit, "a")
[1] 1 3 1 1
> str_count(fruit, "p")
[1] 2 0 1 3

```

对字符串中的'.'字符计数，由于.是正则表达式的匹配符，直接判断计数的结果是不对的。

```R
> str_count(c("a.", ".", ".a.",NA), ".")
[1]  2  1  3 NA

# 用fixed匹配字符
> str_count(c("a.", ".", ".a.",NA), fixed("."))
[1]  1  1  2 NA

# 用\\匹配字符
> str_count(c("a.", ".", ".a.",NA), "\\.")
[1]  1  1  2 NA

```

**3.2.2 str_length,字符串长度**

函数定义：

```R
str_length(string)
```

参数列表：

- string: 字符串，字符串向量。

计算字符串的长度:

```R
> str_length(c("I", "am", "张丹", NA))
[1]  1  2  2 NA

```

**3.2.3 str_sort, 字符串值排序，同str_order索引排序**

函数定义：

```R
str_sort(x, decreasing = FALSE, na_last = TRUE, locale = "", ...)
str_order(x, decreasing = FALSE, na_last = TRUE, locale = "", ...)

```

参数列表：

- x: 字符串，字符串向量。
- decreasing: 排序方向。
- na_last:NA值的存放位置，一共3个值，TRUE放到最后，FALSE放到最前，NA过滤处理
- locale:按哪种语言习惯排序

对字符串值进行排序。

```R
# 按ASCII字母排序
> str_sort(c('a',1,2,'11'), locale = "en")  
[1] "1"  "11" "2"  "a" 

# 倒序排序
> str_sort(letters,decreasing=TRUE)         
 [1] "z" "y" "x" "w" "v" "u" "t" "s" "r" "q" "p" "o" "n" "m" "l" "k" "j" "i" "h"
[20] "g" "f" "e" "d" "c" "b" "a"

# 按拼音排序
> str_sort(c('你','好','粉','丝','日','志'),locale = "zh")  
[1] "粉" "好" "你" "日" "丝" "志"

```

对NA值的排序处理

```R
 #把NA放最后面
> str_sort(c(NA,'1',NA),na_last=TRUE) 
[1] "1" NA  NA
 
#把NA放最前面
> str_sort(c(NA,'1',NA),na_last=FALSE) 
[1] NA  NA  "1"

#去掉NA值 
> str_sort(c(NA,'1',NA),na_last=NA)    
[1] "1"

```

**3.3 字符串匹配函数**

**3.3.1 str_split,字符串分割，同str_split_fixed**

函数定义：

```R
str_split(string, pattern, n = Inf)
str_split_fixed(string, pattern, n)

```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配的字符。
- n: 分割个数

对字符串进行分割。

```R
> val <- "abc,123,234,iuuu"

# 以,进行分割
> s1<-str_split(val, ",");s1
[[1]]
[1] "abc"  "123"  "234"  "iuuu"

# 以,进行分割，保留2块
> s2<-str_split(val, ",",2);s2
[[1]]
[1] "abc"          "123,234,iuuu"

# 查看str_split()函数操作的结果类型list
> class(s1)
[1] "list"

# 用str_split_fixed()函数分割，结果类型是matrix
> s3<-str_split_fixed(val, ",",2);s3
     [,1]  [,2]          
[1,] "abc" "123,234,iuuu"

> class(s3)
[1] "matrix"

```

**3.3.2 str_subset:返回的匹配字符串**

函数定义：

```R
str_subset(string, pattern)
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配的字符。

```R
> val <- c("abc", 123, "cba")

# 全文匹配
> str_subset(val, "a")
[1] "abc" "cba"

# 开头匹配
> str_subset(val, "^a")
[1] "abc"

# 结尾匹配
> str_subset(val, "a$")
[1] "cba"

```

**3.3.3 word, 从文本中提取单词**

函数定义：

```R
word(string, start = 1L, end = start, sep = fixed(" "))
```

参数列表：

- string: 字符串，字符串向量。
- start: 开始位置。
- end: 结束位置。
- sep: 匹配字符。

```R
> val <- c("I am Conan.", "http://fens.me, ok")

# 默认以空格分割，取第一个位置的字符串
> word(val, 1)
[1] "I"               "http://fens.me,"
> word(val, -1)
[1] "Conan." "ok"    
> word(val, 2, -1)
[1] "am Conan." "ok"       

# 以,分割，取第一个位置的字符串 
> val<-'111,222,333,444'
> word(val, 1, sep = fixed(','))
[1] "111"
> word(val, 3, sep = fixed(','))
[1] "333"

```

**3.3.4 str_detect匹配字符串的字符**

函数定义：

```R
str_detect(string, pattern)
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配字符。

```R
> val <- c("abca4", 123, "cba2")

# 检查字符串向量，是否包括a
> str_detect(val, "a")
[1]  TRUE FALSE  TRUE

# 检查字符串向量，是否以a为开头
> str_detect(val, "^a")
[1]  TRUE FALSE FALSE

# 检查字符串向量，是否以a为结尾
> str_detect(val, "a$")
[1] FALSE FALSE FALSE

```

**3.3.6 str_match,从字符串中提取匹配组**

函数定义：

```R
str_match(string, pattern)
str_match_all(string, pattern)

```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配字符。

从字符串中提取匹配组

```R
> val <- c("abc", 123, "cba")

# 匹配字符a，并返回对应的字符
> str_match(val, "a")
     [,1]
[1,] "a" 
[2,] NA  
[3,] "a" 

# 匹配字符0-9，限1个，并返回对应的字符
> str_match(val, "[0-9]")
     [,1]
[1,] NA  
[2,] "1" 
[3,] NA  

# 匹配字符0-9，不限数量，并返回对应的字符
> str_match(val, "[0-9]*")
     [,1] 
[1,] ""   
[2,] "123"
[3,] ""  

```

从字符串中提取匹配组，以字符串matrix格式返回

```R
> str_match_all(val, "a")
[[1]]
     [,1]
[1,] "a" 

[[2]]
     [,1]

[[3]]
     [,1]
[1,] "a" 

> str_match_all(val, "[0-9]")
[[1]]
     [,1]

[[2]]
     [,1]
[1,] "1" 
[2,] "2" 
[3,] "3" 

[[3]]
     [,1]

```

**3.3.7 str_replace，字符串替换**

函数定义：

```R
str_replace(string, pattern, replacement)
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配字符。
- replacement: 用于替换的字符。

```R
> val <- c("abc", 123, "cba")

# 把目标字符串第一个出现的a或b，替换为-
> str_replace(val, "[ab]", "-")
[1] "-bc" "123" "c-a"

# 把目标字符串所有出现的a或b，替换为-
> str_replace_all(val, "[ab]", "-")
[1] "--c" "123" "c--"

# 把目标字符串所有出现的a，替换为被转义的字符
> str_replace_all(val, "[a]", "\1\1")
[1] "\001\001bc" "123"        "cb\001\001"

```

**3.3.8 str_replace_na把NA替换为NA字符串**

函数定义：

```R
str_replace_na(string, replacement = "NA")
```

参数列表：

- string: 字符串，字符串向量。
- replacement : 用于替换的字符。

把NA替换为字符串

```R
> str_replace_na(c(NA,'NA',"abc"),'x')
[1] "x"   "NA"  "abc"

```

**3.3.9 str_locate，找到的模式在字符串中的位置。**

函数定义：

```R
str_locate(string, pattern)
str_locate_all(string, pattern)
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配字符。

```R
> val <- c("abca", 123, "cba")

# 匹配a在字符串中的位置
> str_locate(val, "a")
     start end
[1,]     1   1
[2,]    NA  NA
[3,]     3   3

# 用向量匹配
> str_locate(val, c("a", 12, "b"))
     start end
[1,]     1   1
[2,]     1   2
[3,]     2   2

# 以字符串matrix格式返回
> str_locate_all(val, "a")
[[1]]
     start end
[1,]     1   1
[2,]     4   4

[[2]]
     start end

[[3]]
     start end
[1,]     3   3

# 匹配a或b字符，以字符串matrix格式返回
> str_locate_all(val, "[ab]")
[[1]]
     start end
[1,]     1   1
[2,]     2   2
[3,]     4   4

[[2]]
     start end

[[3]]
     start end
[1,]     2   2
[2,]     3   3

```

**3.3.10 str_extract从字符串中提取匹配模式**

函数定义：

```R
str_extract(string, pattern)
str_extract_all(string, pattern, simplify = FALSE)
```

参数列表：

- string: 字符串，字符串向量。
- pattern: 匹配字符。
- simplify: 返回值，TRUE返回matrix，FALSE返回字符串向量

```R
> val <- c("abca4", 123, "cba2")

# 返回匹配的数字
> str_extract(val, "\\d")
[1] "4" "1" "2"

# 返回匹配的字符
> str_extract(val, "[a-z]+")
[1] "abca" NA     "cba" 


> val <- c("abca4", 123, "cba2")
> str_extract_all(val, "\\d")
[[1]]
[1] "4"

[[2]]
[1] "1" "2" "3"

[[3]]
[1] "2"

> str_extract_all(val, "[a-z]+")
[[1]]
[1] "abca"

[[2]]
character(0)

[[3]]
[1] "cba"

```

**3.4 字符串变换函数**

**3.4.1 str_conv:字符编码转换**

函数定义：

```R
str_conv(string, encoding)
```

参数列表：

- string: 字符串，字符串向量。
- encoding: 编码名。

对中文进行转码处理。

```R
# 把中文字符字节化
> x <- charToRaw('你好');x
[1] c4 e3 ba c3

# 默认win系统字符集为GBK，GB2312为GBK字集，转码正常
> str_conv(x, "GBK")
[1] "你好"
> str_conv(x, "GB2312")
[1] "你好"

# 转UTF-8失败
> str_conv(x, "UTF-8")
[1] "���"
Warning messages:
1: In stri_conv(string, encoding, "UTF-8") :
  input data \xffffffc4 in current source encoding could not be converted to Unicode
2: In stri_conv(string, encoding, "UTF-8") :
  input data \xffffffe3\xffffffba in current source encoding could not be converted to Unicode
3: In stri_conv(string, encoding, "UTF-8") :
  input data \xffffffc3 in current source encoding could not be converted to Unicode

```

把unicode转UTF-8

```R
> x1 <- "\u5317\u4eac"
> str_conv(x1, "UTF-8")
[1] "北京"

```

**3.4.2 str_to_upper,字符串大写转换。**

函数定义：

```R
str_to_upper(string, locale = "")
str_to_lower(string, locale = "")
str_to_title(string, locale = "")

```

参数列表：

- string: 字符串。
- locale:按哪种语言习惯排序

字符串大写转换:

```R
> val <- "I am conan. Welcome to my blog! http://fens.me"

# 全大写
> str_to_upper(val)
[1] "I AM CONAN. WELCOME TO MY BLOG! HTTP://FENS.ME"

# 全小写
> str_to_lower(val)
[1] "i am conan. welcome to my blog! http://fens.me"

# 首字母大写
> str_to_title(val)
[1] "I Am Conan. Welcome To My Blog! Http://Fens.Me"

```

字符串在平常的数据处理中经常用过，需要对字符串进行分割、连接、转换等操作，本篇中通过介绍stringr，灵活的字符串处理库，可以有效地提高代码的编写效率。有了好的工具，在用R语言处理字符串就顺手了。



本文转载张丹的粉丝日志，链接：<http://blog.fens.me/r-stringr/>，
