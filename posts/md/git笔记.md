---
title: git 笔记
date: '2019-11-20'
categories:
  - git
---


## 1. git 的安装与配置

安装不多说,

初次运行 git前的配置, 配置全局信息: 用户名与邮箱,(此处的用户名与邮箱需要到 github 注册)

```powershell
$ git config --global user.name "XXX"
$ git config --global user.email "email@example.com"
```

 如果已经多次使用 git ,可以用以下命令进行查看

```powershell
$ git config -l   % 查看所有配置信息
$ git config --global -l   % 查看全局配置信息
$ cat ~/.gitconfig   % 用户的配置文件
```

注意`git config`命令的`--global`参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

一些终端基础命令

```powershell
$ ls -al    # 查看所有文件夹
$ pwd       # 查看当前所在的目录
$ clear     # 清屏(终端)
```

## 2 . 创建本地仓库

![git01](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git01.png)

### 2.1 创建版本库  (即初始化一个空仓库, 这个目录下的所有路径都称作工作区)

版本库又名仓库(**repository**)，你可以简单理解成一个目录，这个目录里面的所有文件都可以被Git管理起来，每个文件的修改、删除，Git都能跟踪，以便任何时刻都可以追踪历史，或者在将来某个时刻可以“还原”。

```powershell
$ git init    # 该命令会在当前目录下创建了隐藏目录.git(与 git有关的信息都存储在这个文件夹里面)
```

```powershell
$ git status    # 可以让我们时刻掌握仓库当前的状态, 检查当前文件状态
#可根据返回的字体颜色进行判断(红色代表在工作区,绿色代表在暂存区,什么都看不见证明所有修改的东西都已经提交到历史区)
```

### 2.2 把工作区中的文件(夹)提交到暂存区

当本地编写文件完成后(在工作区) , 把一些文件提交到暂存区

```powershell
$ git add XXX     # 把 XXX 单个文件或文件夹提交到暂存区
$ git add .       # 把当前仓库中所有最新修改的文件都提交到暂存区
$ git add -A      # 等价于 git add .
```

###  2.3 把暂存区提交到历史区

狭义的版本库指的是历史区,广义的版本库指的是这个目录下的所有操作.

```powershell
$ git commit -m "描述信息"    # 是把暂存区的所有文件一次性提交到历史区
```

### 2.4 查看历史区的 commit id 

即查看你一共使用了多少次`git commit -m '' `, 每一次该命令使用都会产生一个 `commit id` .   下面的命令都可以查看提交的历史(也可以在 github 网站的code查看,前提本地仓库与远程仓库以及同步 )

```powershell
$ git log       # 可以查看提交历史，以便确定要回退到哪个版本。 (可用于穿梭历史),
$ git reflog    # 查看命令历史，以便确定要回到未来的哪个版本。 (可用于穿梭未来,包含历史的回滚),
```

### 2.5  退回某个commit id 版本

![git02](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git02.png)

可以用于回滚(即可以回到历史版本,也可回到未来版本(zhu)) , 

```powershell
$ git reset --hard ****   #可以指定回到某个提交的历史版本, **** 为 commit id,id可以不写全
```

从工作区提交到暂存区,从暂存区提交到历史区: 是把内容复制一份传过去的,本区域依然存在这些信息(只有这样才能对比出那些文件是否进行了修增改删)

### 2.6 从暂存区撤销到工作区, 以及从工作区撤销修改

```powershell
$ git  reset HEAD <file># 从暂存区中删除该文件,但是文件内容不会修改(只撤销提交这个记录,即删除 git add操作),
$ git checkout --<file> # 把工作区的修改后文件的文件还原(撤销修改)
$ git checkout .          # 放弃没有提交的修改(类似回退到最新的一次提交)
```

### 2.7  .gitignore

.gitignore 用于定义忽略提交的文件

- 所有空行或者以注释符号 `＃` 开头的行都会被 Git 忽略。
- 匹配模式最后跟反斜杠（`/`）说明要忽略的是目录。
- 可以使用标准的 glob 模式匹配。

```powershell
.idea
/vendor       # 忽略目录
*.txt
!a.txt    # *.txt 和 !a.txt 结合,表示除了a.txt以外的所有 txt 文件都被忽略
```

### 2.8一些其他操作

```powershell
$ git commit --amend   # 修改最新一次提交的备注, 
# 如果还有新的文件要和上次提交一起, 可以先把新文件添加到暂存区,然后使用 git commit --amend  就可以把新文件添加到最新的一次提交当中


$ git rm <file>          # 一般情况下, 仓库中(版本库)和本地都会删除该文件
$ git rm --cached <file>   # 删除仓库中的文件,不删除本地文件

$ git clean -fd    # 删除没有add 的文件和目录 
$ git clean -n     # 显示将要删除的文件或目录 
```



## 3. github

### 3.1 github 简介

> 网站: https://www.github.com
>
> 一个开源的源代码管理平台

setting 用户设置

- profile 修改自己的基本信息
- Account 可以修改用户名
- security  可以修改自己的密码
- ….

### 3.2 创建远程仓库,

 直接去 github 网页上点击`new repository--> 填写信息--> 创建仓库`创建

-  public 公共仓库作为开源项目

- private  私有仓库作为内部团队合作项目
	- setting  —> collaborators 设置合作开发人员
	- code 可以查看历史版本信息和分支信息 

### 3.3 把本地仓库信息提交到远程仓库

#### 3.3.1第一步: 首先建立本地仓库与远程仓库的链接

```powershell
$ git remote -v   # 查看当前仓库与那个远程仓库建立了链接,没有建立链接,则不显示

设置本地仓库与远程仓库建立一个链接, 链接名为 origin (可以更改,但一般都用这个)
$ git remote add origin [git 远程仓库地址]

删除管理信息
$ git remote rm origin
```

#### 3.3.2 第二步: 本地仓库提交到远程仓库
```shell
#提交之前最好先拉取--- 即把远程和本地的进行同步合并
$ git pull origin master
#把本地代码提交到远程仓库(可能需要 github 的用户名和密码)
$ git push origin master #将 master 分支推送到 origin 服务器
$ git push -u origin master 上面命令将本地的master分支推送到origin主机
# 加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令: git push，默认只推送当前分支
```



## 4 分支

### 4.1 分支的功能

分支的作用: 用于为项目增加新功能或修复Bug时使用。

![git03](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git03.png)

假设当前节点处于 id03 , 一般默认处于 master 分支上, 现在要

```shell
创建分支:  git branch dev
查看分支:  git branch     # 分支前面有一个* 号,代表处于当前分支
切换分支:  git checkout dev
创建并切换分支:  git checkout -b dev
合并dev分支到 master : 
		git checkout master  % 先切换分支,然后再合并
		git merge dev
删除分支:  git branch -d dev
删除没有合并的分支: git branch -D dev
删除远程分支:  git push origin :dev

查看未合并的分支(切换到master):  git branch --no-merged
查看已经合并的分支(切换到master) : git branch --merged

```

![git04](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git04.png)

### 4.2 合并分支可能会产生冲突

#### 4.2.1  git 分支冲突

产生原因: 不同分支修改同一个文件或不同开发者修改同一个分支文件都可能造成冲突，造成无法提交代码。

1. 手动使用编辑器修改冲突的文件
2. 添加暂存 git add . 表示已经解决冲突
3. git commit 提交完成

另一种解决冲突的办法---- 强制推送

#### 4.2.2. git强制覆盖本地文件（与git远程仓库保持一致）：

```shell
# 方法一: 多条命令执行
git fetch --all
git reset --hard origin/master
git pull

# 方法二: 单条命令执行, git强制覆盖本地命令（单条执行）：
git fetch --all && git reset --hard origin/master && git pull
```



#### 4.2.3. git强制推送本地代码到远程仓库


强制用本地的代码去覆盖掉远程仓库的代码:

```shell
git push -f origin master
%注释： origin远程仓库名，master分支名，-f为force，意为：强行、强制。
% 一般情况下 推送可简写为 git push. 
```







### 4.3 储藏（Stashing）

当你正在进行项目中某一部分的工作，里面的东西处于一个比较杂乱的状态，而你想转到其他分支上进行一些工作。问题是，你不想提交进行了一半的工作，否则以后你无法回到这个工作点。

"暂存" 可以获取你工作目录的中间状态——也就是你修改过的被追踪的文件和暂存的变更——并将它保存到一个未完结变更的堆栈中，随时可以重新应用。

1. 储藏当前工作状态          `git stash`
2. 查看储藏列表    `git stash list`
3. 应用(恢复到)最近的储藏 `git stash apply`
4. 应用(恢复到)更早的储藏 `git stash apply stash@{2}`
5. 删除储藏 `git stash drop stash@{0}     其中stash@{0} 表示存储的标识.
6. 应用并删除储藏 `git stash pop`



### 4.4 Tag

Git 也可以对某一时间点上的版本打上标签 ，用于发布软件版本如 v1.0

1. 添加标签 `git tag v1.0`
2. 列出标签 `git tag`
3. 推送标签 `git push --tags`
4. 删除标签 `git tag -d v1.0.1`
5. 删除远程标签 `git push origin :v1.0.1`

### 4.5 生成zip压缩包

```bash
方法一: git archive --format zip --output "./output.zip" master -0
方法二: git archive --format zip --output dump.zip master
```

### 4.6 移动分支的基础点, 产生干净的合并记录 --rebase

![git05](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git05.png)

![git06](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/git06-20200525194419221.png)

### 4.7 git 压缩提交记录次数

发现自己提交次数有点多，想来合并以前的一些提交记录，减少提交次数，命令如下:

```shell
git rebase -i HEAD~n  //n代表你要查看的提交记录条数
```

![image-20200528104231661](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/image-20200528104231661.png)

https://blog.csdn.net/xiaowu_zhu/article/details/83345313

## 5. git 别名 alias



```bash
# 方式一: 命令设置别名,  a == add .   # 即 git a  == git add .
$ git config --global alias.a add . 
$ git config --global alias.c commit

# 方式二: 直接修改配置文件
$ subl ~/.gitconfig   #用sublime 打开git的配置文件, 注意该配置文件的地址
# mac 一般在~目录下, win一般也在用户目录下
```

