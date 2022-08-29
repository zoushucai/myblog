---
title: mac终端样式PS1
date: '2019-11-19'
categories:
  - mac
---







# mac终端样式PS1

首先，弄明白bash 和zsh....

## 1 mac shell一览

unix核的系统如linux、macos的shell 默认都是bash

就如第一张图查询所示，mac有6个shell，默认是/bin/bash

### 1.1 查看安装了哪些shell ：

```bash
cat /etc/shells
```

### 1.2 查看当前使用的shell

```bash
echo $SHELL   # 方法一
echo $0       # 方法二
```

### 1.3 bash和zsh切换

**切换到bash**

```bash
chsh -s /bin/bash
```

**切换到zsh**

```bash
chsh -s /bin/zsh
```

记得输入切换命令后，要重新打开终端terminal才生效哦！



## 2、终端美化 ---iterm2 + zsh配置方法

### 2.1 安装iterm2 -官网 

我不能确定zsh是否需要iterm2作为基础，因此我安装了iterm2 

- 官网下载安装： https://www.iterm2.com/
- brew 安装，`$  brew cask install iterm2`

### 2.2 zsh 配置方法

要自定义各种配置 我们就要修改默认shell 改用zsh，据说zsh比bash更强大（都是浮云 读者自行查找为啥强大吧），oh my zsh是开源的 a delightful & open source framework for Z-Shell，也就是说我们用它 配置zsh更容易

直接去官网https://ohmyz.sh/ 找到如下命令复制到终端即可（如果遇到提示则输入Yes和回车即可）：

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

下载完毕后打开终端 样式已经变成zsh的默认样式robbyrussell了

### 2.3 切换主题

如果不喜欢oh my zsh的自带主题，可以通过修改配置文件 修改主题

主题查看 -》[oh my zsh github主题列表](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)

我认为好看的主题，mh 、ys、cloud

打开配置文件

```bash
vim ~/.zshrc
```

找到ZSH_THEME，按‘ **i** ’编辑修改主题，编辑完毕后按键盘ese退出并输入":wq"保存

```bash
ZSH_THEME="cloud"
```

双引号的内容就是你想修改成的主题名，我修改成的 就是cloud主题 还蛮可爱的

然后重启终端就能发现样式起作用啦，或者不重启，使用命令更新配置

```bash
source  ~/.zshrc
```

#### 2.4 卸载

必须在处于zsh环境下才能卸载zsh, 它讲默认还原为系统指定的环境（mac则还原为 bash）,卸载命令如下.

```bash
uninstall_oh_my_zsh
```



## 3、终端美化 ---bash(推荐)

还有一种方法是用mac自带的bash 进行修改， 这与上面的zsh有冲突，要么使用bash 要么使用zsh,不过zsh也有类似修改样式参数的命令。自行百度

### 3.1  prompt解析

在osx系统下，对系统自带的终端进行配色可以通过设置PS1环境变量来实现的

### 在osx系统下prompt的表示成

```bash
[\u@\h: ] \w \$
```

示例：

```bash
[elmman@192: ] ~ $
```

### 3.2 设置PS1环境

把一下内容追加到 ` ~/.bash_profile `这个文件中保存并退出

```bash
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\e[01;33m\][\[\e[01;32m\]\u\[\e[01;33m\]@\[\e[01;35m\]\h:\[\e[01;33m\]] \[\e[01;36m\]\w \[\e[01;32m\]\$ '
```

```bash
$ vim ~/.bash_profile  % 把上述文件追加到这个文件末尾
$ source ~/.bash_profile  % 使配置文件生效

```

以一个颜色开始直到遇到另一个颜色命令结束

上述有一个问题,就是当输入字符过多以后,不会自动换行,会导致字符重叠,建议后改为后面的这个

```bash
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\e[01;33m\][\[\e[01;35m\]\u\[\e[01;33m\]@\[\e[01;34m\]\h:\[\e[01;33m\]] \[\e[01;36m\]\w \[\e[01;32m\]\$ '
```

参考: https://my.oschina.net/6tao/blog/1587040?p=1

### 3.2 PS1 参数解释

在mac下 一般用下面的结构来表示终端

```bash
[\u@\h: ] \w \$
```

实例：

```bash
[zsc@zscdeMacBook-Air:] ~ $ 
```

- \u表示用户（这里是elmman）

- @表示@（这里是@）

- \h表示host（我的电脑是：zscdeMacBook-Air）

- :也是个无意义符号（这里是:） 一一对应的

- \w表示当前目录（这里是~，即家目录）

- \$表示命令提示符（这里是\$）

    如果发现用户名太长,可以修改, 参考: https://zhidao.baidu.com/question/1819212125670125468.html

    改成短的名字,有利用查看(个人觉得)

### 3.3 PS1的配色规则（即在shell当中颜色的表示码）

| 默认 : \e[00m    | 黄色 : \e[01;33m  |
| ---------------- | ----------------- |
| 黑色 : \e[01;30m | 蓝色 : \e[01;34m< |
| 红色 : \e[01;31m | 洋红 : \e[01;35m  |
| 绿色 : \e[01;32m | 青色 : \e[01;36m< |
|                  | 白色 : \e[01;37m  |

其中还有两个命令：

- CLICOLOR=1表示开启命令行颜色设置。
- LSCOLORS=gxfxcxdxbxegedabagacad这个参数是对ls命令展示的内容进行配色，

参考： https://blog.csdn.net/maotianyi941005/article/details/86505688

参考 https://blog.csdn.net/xchenhao/article/details/90648636

注意，如果使用mac --默认使用的是bash，因此推荐使用bash，这样能够保证mac 系统有些配置能正常运行，不然可能需要重新去配置zsh。

###  linux 更改终端颜色

```bash
echo "PS1='\[\e[01;33m\][\[\e[01;32m\]\u\[\e[01;33m\]@\[\e[01;35m\]\h:\[\e[01;33m\]] \[\e[01;36m\]\w \[\e[01;32m\]\$ '" >> ~/.bashrc 

# 记得重新运行
$ source ~/.bashrc  % 使配置文件生效
```





## mac中终端中添加显示分支情况

```bash
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\e[01;33m\][\[\e[01;32m\]\u\[\e[01;33m\]@\[\e[01;35m\]\h:\[\e[01;33m\]] \[\e[01;36m\]\w\[\e[01;34m\]$(parse_git_branch) \[\e[01;32m\]\$ '
```





![04](https://i0.hdslb.com/bfs/album/fe8c7995aa5a9840dab4c0645fef56098e52cf35.png)
