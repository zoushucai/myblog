---
title: mactex卸载
date: '2020-07-01'
categories: latex
---


# mactex卸载

参考：
[http://www.tug.org/mactex/uninstalling.html](http://www.tug.org/mactex/uninstalling.html)

[https://blog.csdn.net/nicekwell/article/details/97279215](https://blog.csdn.net/nicekwell/article/details/97279215)

MacTeX是mac下的latex工具，卸载方法：

1、`/usr/local/texlive/2018/` 目录，这是占用空间最大的目录

2、卸载GUI，到`/Application/` 目录里删掉几个app即可。

3、`/Library/TeX`

4、`~/Library/texlive/2019`



```shell
sudo rm -rf /usr/local/texlive/

sudo rm -rf /Library/TeX/

sudo rm -rf ~/Library/texlive


cd /usr/local/
sudo rm -rf texlive/

cd /Library/
sudo rm -rf TeX/

cd ~/Library/texlive
sudo rm -rf 2020

cd ~/Library
sudo rm -rf texlive

```

