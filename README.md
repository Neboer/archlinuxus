# archlinuxus

基于Github Actions的AUR自动打包软件仓库。

## 为什么不使用archlinuxcn？

Archlinux US软件仓库收录所有在AUR上发布但是没有直接打包的软件。我们不依赖archlinuxcn源，因为


1. 该源不可控
2. archlinuxcn源打包经常过期
3. archlinuxcn源包不全

因此我们决定制作自己的镜像源。

## archlinuxcn代劳的包

如下的包已经使用archlinuxcn代劳打包，我们不需要再处理：
naiveproxy
yay
sing-box
micromamba-bin -> micromamba
frpc
frps
pacman-static
simdjson

## 此镜像如何工作？

archlinux-us 镜像的工作原理如下：


1. 在GitHub中，有一个仓库 Neboer/archlinuxus ，该仓库结构如下
   * .github/workflow/build-push.yml 控制整个流程的脚本。
     * 脚本流程：第一步：拉一个Ubuntu镜像。
     * 第二步：参考<https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux#Method_A:_Using_the_bootstrap_tarball_(recommended)> 中的教程，拉一个archlinux镜像，chroot到容器环境。
     * 第三步：参考 https://github.com/Jguer/yay#source 安装yay到系统中。
     * 第四步：签出仓库文件，用yay安装targets.txt中的每个软件，然后yay-cache-to-repo.sh制作软件仓库，最后sync-repo-to-remote.sh更新远端仓库。
   * targets.txt 每行都是一个软件名字的文件，这是更新目标。
   * prepare-archlinux.sh 负责下载镜像、解压、挂载、安装基本软件、安装yay、准备基本的构建环境
   * build-repo.sh 负责构建整个仓库
2. 远端仓库每次被GitHub脚本更至最新，同时仅保留最新的软件版本，不留旧包。

   远端仓库的结构如下：
   * x86_64/
     * archlinuxus.db
     * archlinuxus.db.tar.gz
     * xxx-xxx-xxx.tar.zst
     * …
3. 远端仓库工作失败，会报错，此时远端仓库不会继续更新当天的软件。任何一个错误都会导致流程彻底退出。
