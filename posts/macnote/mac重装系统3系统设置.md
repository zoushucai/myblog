---
title: mac重装系统3系统设置
date: '2020-10-05'
categories:
  - mac
---





# mac 系统的设置

新系统, 首先我们要安装一些必要的软件,和做一些基本的设置.

本文做一些基本的设置

##  更改终端的颜色 和主机名

```bash
sudo echo "export CLICOLOR=1" >> ~/.bash_profile
sudo echo "export LSCOLORS=gxfxcxdxbxegedabagacad" >> ~/.bash_profile
sudo echo "export PS1='\[\e[01;33m\][\[\e[01;35m\]\u\[\e[01;33m\]@\[\e[01;34m\]\h:\[\e[01;33m\]] \[\e[01;36m\]\w \[\e[01;32m\]\$ '">> ~/.bash_profile

source ~/.bash_profile 
```

参考:  [2019-11-19mac终端样式PS1](2019-11-19mac终端样式PS1)

命令行更改主机名

```bash
scutil --set HostName lucky  # 重启终端
hostname   #查看主机名
```





- 备注： 还有在mac中使用vim, 可以有更好的方法 使用sublime

```bash
vim a.txt 
# 可以用  
subl a.txt
open a.txt
```



## 以下看情况设置

- 如果不能用则设置

###  设置网络的DNS.

打开--`wifi` --->> `高级`---> 设置 DNS  , 

添加

```bash
114.114.114.114
8.8.8.8
```



### 修改`/etc/hosts`

- 不推荐 修改这个文件啦

- 找到一个更好用的软件，  https://gitee.com/docmirror/dev-sidecar 因此可以不设置`/etc/hosts` 文件啦

```bash
$ sudo vim /etc/hosts
#### 把下面的信息添加到 该文件中即可
199.232.69.194   github.global.ssl.fastly.net
140.82.113.4      github.com
199.232.69.194    github.global.ssl.fastly.net
185.199.110.153   assets-cdn.github.com
140.82.113.4      gist.github.com

#192.30.253.119    gist.github.com
#199.232.28.133    assets-cdn.github.com
199.232.68.133    raw.githubusercontent.com
199.232.68.133    gist.githubusercontent.com
199.232.68.133    cloud.githubusercontent.com
199.232.68.133    camo.githubusercontent.com
199.232.68.133    avatars0.githubusercontent.com
199.232.68.133    avatars1.githubusercontent.com
199.232.68.133    avatars2.githubusercontent.com
199.232.68.133    avatars3.githubusercontent.com
```

[链接1](https://blog.csdn.net/Newbie_J/article/details/104467886/)

[链接2](https://blog.csdn.net/u010828718/article/details/106500543?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduend~default-1-106500543.nonecase&utm_term=github%E4%B8%8A%E7%9A%84%E5%9B%BE%E7%89%87%E6%97%A0%E6%B3%95%E6%98%BE%E7%A4%BA%20mac&spm=1000.2123.3001.4430)

 下一节,讲解软件的安装(主要用`homebrew`),如果上述不设置,可能软件安装不了

