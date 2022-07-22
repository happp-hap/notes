
# ubuntu 安装 CUDA 环境
# 从操作系统开始定制 pytorch 环境
(未整理)


$: sudo apt update

$: ubuntu-drivers devices

$: sudo ubuntu-drivers autoinstall

此处ubuntu自己安装驱动,而且会把cuda一并装好,装好之后重启。
重启后使用nvidia-smi显示显卡状态,可以看到Driver VERSION和CUDA VERSION，此处这个cuda版本指的是目前能兼容的最高版本。


Anaconda3 will now be installed into this location:
/home/hap/anaconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/home/hap/anaconda3] >>> 


==> 要使更改生效，请关闭并重新打开当前的 shell。 <==

如果您希望 conda 的基础环境在启动时不被激活，
   将 auto_activate_base 参数设置为 false：

conda config --set auto_activate_base false

感谢您安装 Anaconda3！

==================================================== ==========================

在 DataSpell 中使用 Python 和 Jupyter 是一件轻而易举的事。它是一个 IDE
专为探索性数据分析和机器学习而设计。获得更好的数据洞察力
与数据拼写。

Anaconda 的 DataSpell 位于：https://www.anaconda.com/dataspell

## 安装 nvidia-cuda-toolkit

```
NOTE: 'conda-forge' channel is required for cudatoolkit 11.6
```
```
sudo apt install nvidia-cuda-toolkit
```

## 安装 anaconda 

不需要：
```
conda update -n base conda
conda update --all
conda update --prefix ~/anaconda3 anaconda
conda update --all
```

conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge

(base) hap@hap-ubuntu-8220:~$ echo $?
0


(base) hap@hap-ubuntu-8220:~$ python
Python 3.9.12 (main, Jun  1 2022, 11:38:51) 
[GCC 7.5.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> x = torch.rand(5, 3)
>>> print(x)
tensor([[0.7891, 0.5419, 0.1950],
        [0.8197, 0.2126, 0.4105],
        [0.0279, 0.1776, 0.7230],
        [0.6351, 0.5237, 0.4980],
        [0.1989, 0.3342, 0.1737]])
>>> 

import torch
x = torch.rand(5, 3)
print(x)
torch.cuda.is_available()


## ubuntu 自动安装 cuda11.6

sudo ubuntu-drivers autoinstall

会直接安装最新驱动，目前是515，对应cuda11.7. 但是pytorch 不支持11.7.

sudo apt install nvidia-driver-510 

就会自动安装 cuda11.6


## conda 激活和关闭环境
 To activate this environment, use

     $ conda activate torch

 To deactivate an active environment, use

     $ conda deactivate


## nvcc 是什么

nvcc就是CUDA的编译器

nvcc是10.0就代表你装了CUDA的版本是10,0.

nvcc可以从CUDA Toolkit的/bin目录中获取,类似于gcc就是c语言的编译器。由于程序是要经过编译器编程成可执行的二进制文件，而cuda程序有两种代码，一种是运行在cpu上的host代码，一种是运行在gpu上的device代码，所以nvcc编译器要保证两部分代码能够编译成二进制文件在不同的机器上执行



echo 'export PATH=/usr/local/cuda-11.6/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc

## 我安装pytorch遇到问题了，怎么办？

如果遇到：
```
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
```
这不是问题，不管，网络可以的情况下使劲等就行。大概就是固定流程走不通，采用灵活方案继续执行的意思。如果半小时等不出来，估计是网络问题。



## conda 操作

conda info --envs


## 成了！

```
[GCC 7.5.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> x = torch.rand(5, 3)
>>> print(x)
tensor([[0.7396, 0.4977, 0.2923],
        [0.7645, 0.2151, 0.3493],
        [0.6917, 0.5644, 0.2311],
        [0.9763, 0.9188, 0.2849],
        [0.6425, 0.3189, 0.3022]])
>>> torch.cuda.is_available()
True
```

base 环境是 cpu 版本
torch 环境是 gpu 版本
