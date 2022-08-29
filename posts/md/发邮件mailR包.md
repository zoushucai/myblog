---
title: R语言发邮件--mailR包
date: '2018-11-13'
categories: r
---





亲测试邮箱为163邮箱 和QQ邮箱

## mailR 包参数

mailR 包中只有一个接口函数---send.mail ,该包依恋java环境，请首先配置该环境，下面是该函数的一些基本参数：

```R
send.mail(from, to, subject = "", body = "", encoding = "iso-8859-1",
  html = FALSE, inline = FALSE, smtp = list(), authenticate = FALSE,
  send = TRUE, attach.files = NULL, debug = FALSE, ...)
```

| 参数         | 说明                                                |
| ------------ | --------------------------------------------------- |
| from         | 发件人邮箱                                          |
| to           | 收件人邮箱                                          |
| subject      | 邮件标题                                            |
| body         | 邮件的内容(正文),内容可以是文本也可以是html网页格式 |
| html         | 一个bool值，是否应该讲邮箱正文解析为HTML            |
| inline       | 一个bool值，HTML文件中的图像是否应该被嵌入          |
| smtp         | 重要的参数，设置服务器参数用的                      |
| authenticate | 是否应该使用smtp中的参数                            |
| attach.files | 指定相应的附件，若是多个则用字符向量表示            |
| file.names   | （省略参数），对相应的附件进行重命名                |
| debug        | 你是否要查看详细的调试信息                          |

## 163 邮箱:

如果发送频率过快，容易被封号，暂时发布出去了，只有等解封以后再发,

**注意**： 在测试的时候，尽量写的和平时邮件一样的格式，不然会被认为是垃圾邮件

```R
library(mailR)
sender <- "********@163.com"  # 发件人
recipients <- c("******@qq.com") # 收件人，可以多个
send.mail(from = sender,
          to = recipients,
          subject = "Program Done.",
          body = "My program is finished.",
          smtp = list( 
            host.name = "smtp.163.com",  # 163邮箱的服务器地址
            port = 465,
            user.name = "********@163.com",
            passwd = "*********", # 这个是授权码而非密码
            ssl = TRUE,
            tls =TRUE), 
          encoding = "utf-8",
          authenticate = TRUE,
          send = TRUE)
```

报错：其中的信息：（表示发送的邮件过多）

```bash
Caused by: com.sun.mail.smtp.SMTPSendFailedException: 554 DT:SPM 163 smtp2,DNGowAA3E32d1ONbg+8oAA--.78S2 1541657766,please see http://mail.163.com/help/help_spam_16.htm?ip=182.88.95.17&hostid=smtp2&time=1541657766
```



## QQ 邮箱:

QQ邮箱好像不存在发多了被封号的问题，我猜如果发到一定量，也应该会出现上述问题吧

```R
sender <- "******@qq.com"
recipients <- c("*******@163.com","*******@qq.com") 
send.mail(from = sender,
          to = recipients,
          subject = "你好！我的朋友",
          body = "第一次用程序写邮件!!哈哈",
          smtp = list(
            host.name = "smtp.qq.com", ## QQ邮箱的服务器地址
            port = 465,
            user.name = "********@qq.com",
            passwd = "*********", ## 这个是授权码而非密码
            ssl = TRUE), 
          encoding = "utf-8",
          authenticate = TRUE,
          attach.files =c("./bbbb.xlsx","01_hellworld.cpp"), #附件
          file.names = c("aaa","bbb"), # 对附件进行重命名
          file.descriptions = c( "xlsx 文件","c++文件作业"),# 附件的说明
          send = TRUE)
```

