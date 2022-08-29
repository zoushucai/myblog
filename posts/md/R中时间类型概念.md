---
title: R中时间类型概念
date: '2018-04-14'
categories: r
---




## 基本类型介绍

在R中，所有有关时间和日期的类(包),都可以处理日历时间(eg:2018年4月13日)，只有某些特定的类才能处理日期时间类型(eg:2018年4月13日 下午6:45)

| 类         | 处理类型 | 说明                                                         | 强制转换        | R所在包     |
| ---------- | -------- | ------------------------------------------------------------ | --------------- | ----------- |
| Date类     | 日历日期 | 实际存储的为数字，是从1970年1月1日算起到该时间以天计算的一个数值.<br>eg:  "2018-04-13" | as.Date()       | 基本函数    |
| POSIXct类  | 日期时间 | 实际存储的为数字，是从1970年1月1日算起到该时间以秒计算的一个数值.<br>eg:  "2018-04-13 19:47:18 CST"<br>个人建议使用这个，存储数据 | as.POSIXct()    | 基本函数    |
| POSIXlt类  | 日期时间 | 实际存储为含有9个元素的列表,其中包括年、月、日、小时、分钟、秒。<br>eg:  "2018-04-13 19:47:18 CST"<br>存储非结构化数据 | as.POSIXlt()    | 基本函数    |
| Date类     | 日历日期 | 同上                                                         | as_date()       | lubridate包 |
| POSIXct类  | 日期时间 | 同上                                                         | as_datetime()   | lubridate包 |
| difftime类 | 时间     | 实际存储的为数字，是从当天00:00:00算起到该时间以秒计算的一个数值.<br>eg:"00:01:25" | hms::as.hms(85) | lubridate包 |

**在实际工作中，只要满足要求，尽量适用比较简单的类型，先考虑Date ，在考虑POSIXct**



## R中处理时间序列的包：

- chron   ：  常用于计量经济学和时间序列分析中

- lubridate： 推荐,特别适用于处理日期时间算法

- mondate:  特别适用于处理以月为单位的日期，（会计和精算工作中常用）

- timeDate： 很强大，对时间精度要求高的话，可以考虑




## 时间的基本用法

1. 字符串转换为日期： as.Date(x ,format="%m/%d/%y") ,建议format参数不能省，否则有时会出错

2. 日期转化为字符串: as.characher()  或者 format()

3. 把日期（Date类和POSIXct类）转换为整数 ： unclass(x)或者 as.integer(x)

4. 把整数转化为日期:  as.Date() 或者 as.POSXIce() 

5. 把年、月、日 ...等元素合并为日期 ：  
   - ISOdatetime(year, month, day, hour, min, sec, tz = "")
   - ISOdate(year, month, day, hour = 12, min = 0, sec = 0, tz = "GMT")
6. 给定日期 提取年、月、日、...等：
   1.   先把其转化为POSIXlt类，根据POSIXlt类是一个列表，提取相应的元素















当然这些是R的基本函数与方法，有更强大的处理时间的[lubridate包](https://www.rstudio.com/resources/cheatsheets/),推荐使用。
