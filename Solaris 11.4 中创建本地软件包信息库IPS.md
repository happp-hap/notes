# Solaris 11.4 中创建本地软件包信息库IPS
(从CBE安装IPS)



IPS（Image Packaging System）软件包信息库

1. 下载CBE
	从Oracle Solaris官网。
	
2. ftp下载到的文件到目标Solaris系统上。
	压缩包都点开看看，会发现有一些README。
	
3. 解压CBE中的V1019846-01.zip文件。
	文件中的内容是：
	install-repo.ksh                                      生产ISO的脚本
	README-zipped-repo.txt                      怎么使用的说明
	sol-11_4_42_111_0-repo_digest.txt     MD5验证集
	
	这些文件和一堆zip压缩包在同一个目录下。
	给install-repo.ksh脚本x执行权限，运行命令：$ sudo ./install-repo.ksh -d /tank/repos/dev -I -v -c 

	输出：

	`Using V1019847-01 files for sol-11_4_42_111_0-repo download.

	Comparing digests of downloaded files...done. Digests match.

	Uncompressing V1019847-01_1of7.zip...done.
	Uncompressing V1019847-01_2of7.zip...done.
	Uncompressing V1019847-01_3of7.zip...done.
	Uncompressing V1019847-01_4of7.zip...done.
	Uncompressing V1019847-01_5of7.zip...done.
	Uncompressing V1019847-01_6of7.zip...done.
	Uncompressing V1019847-01_7of7.zip...done.
	Repository can be found in /tank/repos/dev.
	Initiating repository verification.
	Building ISO image...wdone.
	ISO image can be found at:
	/export/home/hap/solariscbe/sol-11_4_42_111_0-repo.iso
	Instructions for using the ISO image can be found at:
	/tank/repos/dev/README-repo-iso.txt`

	
	最终生成一个15G的大文件。
	
4. 从sol-11_4_42_111_0-repo.iso文件，创建永久性本地软件包信息库。
	
	创建一个zfs文件系统：

		`sudo zfs create rpool/export/repoSolaris11`
		
		`sudo zfs set atime=off rpool/export/repoSolaris11(atime关闭，主要是为了获取高性能)`

	挂载iso到/reposource：
		`sudo mount -F hsfs /export/home/hap/solariscbe/sol-11_4_42_111_0-repo.iso /reposource`

	将挂载好的iso导入zfs文件系统（将 SRU 包导入现有的 Oracle Solaris 11.4 信息库）：
		`sudo rsync -aP /reposource /export/repoSolaris11`

	重建存储库的搜索索引：
		`sudo pkgrepo rebuild -s /export/repoSolaris11/reposource/repo/
		输出：
		Initiating repository rebuild.
		`
	发布：
        `pkg unset-publisher solaris

        pkg set-publisher -g file:///export/repoSolaris11/reposource/repo/ solaris    (直接发布IPS软件包)
        sudo pkg set-publisher --disable ha-cluster (把没有用的发布者屏蔽)`

5. 安装个gdb试试

    $ sudo pkg search gdb

    INDEX                ACTION VALUE                          PACKAGE
    pkg.description      set    GDB, the GNU Debugger...       pkg:/developer/debug/gdb@10.2-11.4.42.0.0.111.0
    basename             file   usr/bin/gdb                    pkg:/developer/debug/gdb@10.2-11.4.42.0.0.111.0
    com.oracle.info.name set    gdb                            pkg:/developer/debug/gdb@10.2-11.4.42.0.0.111.0
    pkg.fmri             set    solaris/developer/debug/gdb    pkg:/developer/debug/gdb@10.2-11.4.42.0.0.111.0


    $ sudo pkg install gdb
    Password: 
               Packages to install:  1
                Services to change:  1
           Create boot environment: No
    Create backup boot environment: No
    
    DOWNLOAD                                PKGS         FILES    XFER (MB)   SPEED
    Completed                                1/1         57/57      5.0/5.0      --
    
    PHASE                                          ITEMS
    Installing new actions                         85/85
    Updating package state database                 Done 
    Updating package cache                           0/0 
    Updating image state                            Done 
    Creating fast lookup database                   Done 
    Updating package cache                           2/2 
    
    $ gdb
    GNU gdb (GDB) 10.2
    Copyright (C) 2021 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "x86_64-pc-solaris2.11".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <https://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.
    
    For help, type "help".
    Type "apropos word" to search for commands related to "word".


参考：
	
	在 Oracle® Solaris 11.2 中添加和更新软件:
	https://docs.oracle.com/cd/E56344_01/html/E53748/gijmo.html
	
	Solaris 11配置IPS安装系统包（类似linux中的yum源）(aliyun):
	看过以后理清了思路，很好的文章。
	https://developer.aliyun.com/article/248428


小插曲：

    没空间了……
    df -hl
    hap@solaris:~/solariscbe$ df -hl
    Filesystem             Size   Used  Available Capacity  Mounted on
    rpool/ROOT/11.4.42.111.0
                          62.5G  15.5G          0   100%    /
    rpool/ROOT/11.4.42.111.0/var
                          62.5G  60.5M          0   100%    /var
    /devices                  0      0          0     0%    /devices
    /dev                      0      0          0     0%    /dev
    ctfs                      0      0          0     0%    /system/contract
    proc                      0      0          0     0%    /proc
    mnttab                    0      0          0     0%    /etc/mnttab
    swap                  3.18G  6.59M      3.18G     1%    /system/volatile
    swap                  3.18G    12K      3.18G     1%    /tmp
    objfs                     0      0          0     0%    /system/object
    sharefs                   0      0          0     0%    /etc/dfs/sharetab
    fd                        0      0          0     0%    /dev/fd
    /usr/lib/libc/libc_hwcap1.so.1
                          15.5G  15.5G          0   100%    /lib/libc.so.1
    rpool/VARSHARE        62.5G  1.86M          0   100%    /var/share
    rpool/VARSHARE/tmp    62.5G    31K          0   100%    /var/tmp
    rpool/VARSHARE/kvol   62.5G    31K          0   100%    /var/share/kvol
    rpool/VARSHARE/zones  62.5G    31K          0   100%    /system/zones
    rpool/VARSHARE/cores  62.5G    31K          0   100%    /var/share/cores
    rpool/export          62.5G    33K          0   100%    /export
    rpool/export/home     62.5G    32K          0   100%    /export/home
    rpool/export/home/hap
                          62.5G  29.7G          0   100%    /export/home/hap
    rpool                 62.5G     3M          0   100%    /rpool
    df: cannot statvfs /var/share/sstore/repo: Permission denied
    rpool/VARSHARE/pkg    62.5G    32K          0   100%    /var/share/pkg
    rpool/VARSHARE/pkg/repositories
                          62.5G    31K          0   100%    /var/share/pkg/repositories
    /export/home/hap/solariscbe/sol-11_4_42_111_0-repo.iso
                          14.4G  14.4G          0   100%    /reposource
    rpool/export/repoSolaris11
                          62.5G  11.9G          0   100%    /export/repoSolaris11
    
    不扩容，太麻烦了。删掉那些用不着的zip文件。








docker





