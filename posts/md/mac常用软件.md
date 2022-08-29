---
title: mac 常用软件
date: '2019-11-20'
categories: mac
---



## 1, xcode命令工具(一下 以都是在 终端下运行 ,`%`为注释)

```shell
xcode-select --install
```

## 2.` homebrew` 主页:  https://brew.sh/

### 2.1安装

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 2.2 卸载(未试过)

方法一: 网上找的,

可参考: https://blog.csdn.net/qq_41234116/article/details/79366454

方法 2: 官方版本

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

https://github.com/Homebrew/brew/blob/master/docs/FAQ.md 

https://stackoverflow.com/questions/23251665/how-to-uninstall-homebrew



### 2.3 安装包 和卸载包

```bash
brew install <packageName>     % 这个安装的是只有命令行的工具
brew cask install google-chrome   % 注意 brew cask install  安装的是有图像界面的 app
brew uninstall <packageName>
brew cask uninstall <packageName>
brew list    % 已安装列表
brew update   % 注意每次使用这个是 都很慢, 可进行源的更新
brew cask search <packageName>  %查询<packageName>
brew cask info <packageName>   % 查看版本信息
brew config             %查看brew配置
brew outdated   % 查看那些包（软件）可以更新
brew upgrade             # 更新所有的包，Homebrew 会安装新版本的包，但旧版本仍然会保留
brew upgrade $FORMULA    # 更新指定的包
brew cleanup             # 清理所有包的旧版本，将旧有的软件安装包进行清理
brew cleanup $FORMULA    # 清理指定包的旧版本
brew cleanup -n          # 查看可清理的旧版本包，不执行实际操作
brew cask install qlcolorcode  # 预览使得文本具有颜色,即给代码上色
brew cask install qlstephen  # 语法高亮
### 更新brew cask 安装过的软件...
brew cask outdated # 查看过时的软件
brew cask upgrade  # 更新所有过时的软件
brew cask upgrade *** # 更新指定软件
brew cask reinstall qq         #推荐，直接重新安装
超级右键   macApp 安装
```

### 2.4 homebrew 的清华更新源

清华镜像官网: 

https://mirror.tuna.tsinghua.edu.cn/help/homebrew/ 

https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/

下面给出清华镜像官网链接(注意在 终端下直接运行下面的**四句命令**即可), ,**一般情况下,替换镜像的命令镜像网站会给出,所以以后要进行更新源的操作,直接去相应的镜像网站找更新命令**

```bash
git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git

brew update
```

复原

```bash
git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git

git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git

git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git

brew update
```

还可以参考::https://www.cnblogs.com/DjangoBlogs/p/10762310.html

### 2.5Homebrew-bottles 镜像使用帮助

**注:该镜像是 Homebrew 二进制预编译包的镜像。本镜像站同时提供 Homebrew 的 formula 索引的镜像（即 brew update 时所更新内容），请参考Homebrew 镜像使用帮助。**

#### 2.5.1临时替换

```bash
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
```

#### 2.5.2长期替换

```bash
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile
```

注意: 个人理解  Homebrew-bottles 安装的是 类似安装包的形式,即编译好的包.

### 2.6 Homebrew 关闭自动更新

#### 2.5.1临时关闭

```bash
export HOMEBREW_NO_AUTO_UPDATE=true
```

#### 2.5.2长期关闭

```bash
echo 'export HOMEBREW_NO_AUTO_UPDATE=true' >> ~/.bash_profile
source ~/.bash_profile
```

### 2.7 mac Linux命令解释

- `export A = B` 把 B 写入 A中,不过重启后无效, 还可以设置环境变量,不过 mac 一般会自动配置,不怎么用这个,用的较多的是`~/.bash_profile`文件来管理环境变量.
- `echo 'xxx' >>  file `  把`'xxx'`内容追加到 `file` 文件末尾, 用一个`>`表示覆盖 `file`文件.

- `source ~/.bash_profile` 刷新配置文件
- `cat file` 查看 file 文件
- `vim file`  利用 vim 打开 file文件,vim 可以编辑修改 file 文件

## 3. 常用软件

- 谷歌浏览器 , 

- `Typora` 写作软件, 	

- sublime-text3, 

- github桌面版, 

- mathpix-snipping-tool公式识别器,

- tencent-lemon :  腾讯柠檬垃圾清理软件

- contexts: 快速切换 mac 窗口

- firefox(火狐浏览器,虽然 Google 浏览器很强了,不过国内有些软件需要这个)

- the-unarchiver  (只能)解压软件

- keka 解压压缩都行,

- qq : mac上只有 qq,暂时没有 TIM

- iina % 视频播放器

- mounty %挂着 NTFS

- baidunetdisk %百度网盘

```bash
brew cask install google-chrome
brew cask install typora
brew cask install sublime-text	 
brew cask install github
brew cask install mathpix-snipping-tool
brew cask install tencent-lemon
brew cask install contexts
brew cask install firefox
brew cask install the-unarchiver 
brew cask install keka
		brew cask install qq
					brew cask install iina 
brew cask install mounty 
			brew cask install baidunetdisk 
```

- loopback: 收费软件,需要找到破解版,不建议用这个安装,结合 mac 自带的录屏软件,可以录制有声音的视频,不管是系统声音还是软件声音都行.

```bash
brew cask install loopback
```

-  java 的安装,个人建议还是从官网下载安装对应的版本,我记得第一次试的时候,好像没有配置成功

```bash
% 先安装 r 以及 rstudio 在安装java, 看能否配置成功
		brew cask install r
			brew cask install rstudio
			
brew cask install java   %将会安装jdk的最新版本，jdk内嵌jre
brew cask install java8  %安装jdk8的最新版本

```

-  grammarly : 语法安装软件, 个人不推荐,因为有浏览器插件就够了

- cajviewer: caj 云阅读

- zotero: 论文参考文献管理, 可以快速进行期刊缩写与展开

- mendeley : 论文参考文献管理，可以快速进行期刊缩写与展开

- jabref : 论文管理软件, 只适合 bibtex 文件的管理, 这个可以缩写期刊, 以及查找文献的 doi, 并且不修改原有的bibtex 文件信息(除非手动修改), 注意一定要找到对应期刊的 bst 文件,才能显示出适合的参考文献格式, 可以集合 zotero 以及 mendeley 的软件查找相应的参考文献样式或者直接从网站https://www.zotero.org/styles查找下载相关参考文献的样式, 最终结合 bibtex 生成最终的 pdf(bibtex文件生成的临时文件 *.bbl 就是对应的的thebibliography环境以及bibitem条目 ),  备注: 个人推荐 jabref, 然后全部的参考文献都去 Google 学术上下载 bibtex 文件,不能一会从百度学术一会从谷歌学术下载,或者从相应的参考软件下载,这样会很乱,  注意:谷歌浏览器插件MyBibCitation Generator 也能产生相应的参考文献样式


- jabref  % 建议安装开发版本,这个默认是稳定版本

```bash
brew cask install grammarly	
brew cask install cajviewer	
brew cask install zotero
brew cask install mendeley
brew cask install jabref     
# 建议安装开发版本,这个默认是稳定版本s
```

