
# ubuntu 安装 CUDA 环境

## 什么是 pytorch？

PyTorch是由Facebook(脸书公司)人工智能团队开发的一款产品。它是根据Torch开发的开源机器学习库。PyTorch的前端除了可以是python以外，也可以是C++。现在不仅Facebook在使用PyTorch，别的公司也在使用。例如，Uber的Pyro概率程序软件在后端就用到了PyTorch。

PyTorch是一个基于Python语言的科技计算包。它的主要功能包括：

利用GPUs的功能替换Python中Numpy。（GPU是Graphics Processing Unit的缩写。它的意思是图形处理器。它是一种专门在个人电脑、平板电脑、智能手机等设备上进行图像和图形相关运算工作的微处理器。）

提供最灵活和最快计算速度的深度学习模型。
（摘自网络）

## 什么是 ubuntu？

Ubuntu是一个以桌面应用为主的Linux操作系统。

## 什么是 Conda？Conda与pip的区别是什么？

总的来说，在本文中 Conda 可以提供独立的 python 虚拟环境，并且很好地帮你处理繁琐的库依赖关系。总的来说，Conda 比 pip 提供更多，更便利。


有兴趣可以阅读下面段落。


Conda是适用于任何语言的软件包、依赖项和环境管理系统--包括Python，R，Ruby，Lua，Scala，Java，JavaScript，C / C ++，FORTRAN等。


Conda是在Windows、macOS和Linux上运行的开源软件包管理系统和环境管理系统。仅需几个命令，您就可以设置一个完全独立的环境来运行不同版本的Python，同时继续在正常环境中运行喜欢的Python版本。

## 什么是 CUDA ？什么是 cudatoolkit ？什么是……

CUDA：为“GPU通用计算”构建的运算平台。
cudnn：为深度学习计算设计的软件库。
CUDA Toolkit (nvidia)： CUDA完整的工具安装包，其中提供了 Nvidia 驱动程序、开发 CUDA 程序相关的开发工具包等可供安装的选项。包括 CUDA 程序的编译器、IDE、调试器等，CUDA 程序所对应的各式库文件以及它们的头文件。
CUDA Toolkit (Pytorch)： CUDA不完整的工具安装包，其主要包含在使用 CUDA 相关的功能时所依赖的动态链接库。不会安装驱动程序。
（NVCC 是CUDA的编译器，只是 CUDA Toolkit 中的一部分）
注：CUDA Toolkit 完整和不完整的区别：在安装了CUDA Toolkit (Pytorch)后，只要系统上存在与当前的 cudatoolkit 所兼容的 Nvidia 驱动，则已经编译好的 CUDA 相关的程序就可以直接运行，不需要重新进行编译过程。如需要为 Pytorch 框架添加 CUDA 相关的拓展时（Custom C++ and CUDA Extensions），需要对编写的 CUDA 相关的程序进行编译等操作，则需安装完整的 Nvidia 官方提供的 CUDA Toolkit。

版权声明：本文为CSDN博主「健0000」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_41094058/article/details/116207333

## nvcc 是什么

nvcc就是CUDA的编译器

nvcc是10.0就代表你装了CUDA的版本是10,0.

nvcc可以从CUDA Toolkit的/bin目录中获取,类似于gcc就是c语言的编译器。由于程序是要经过编译器编程成可执行的二进制文件，而cuda程序有两种代码，一种是运行在cpu上的host代码，一种是运行在gpu上的device代码，所以nvcc编译器要保证两部分代码能够编译成二进制文件在不同的机器上执行

## 建议从操作系统开始定制 pytorch 环境

pytorch 官方网站   ：https://pytorch.org/
从本地安装 pytorch ：https://pytorch.org/get-started/locally/

为什么要从操作系统开始定制呢，因为 pytorch 在用来做机器学习训练的时候，需要 GPU 加速，来避免我们在训练时间上产生无法忍受的开销。

而 GPU 加速，肯定是需要显卡相关的软件支持，而这些相关的软件，总是和操作系统有相关性的。如果相应版本不匹配，在安装的时候就会遇到诸多麻烦，甚至常常无法安装。

## 操作系统版本、CUDA版本、cudatoolkit版本、pytorch版本

简单来说，安装 ubuntu20.4 + CUDA11.6 + cudatoolkit11.6 + pytorch1.12.0

比如说我们要安装 pytorch_stable_1.12.0 版本的 pytorch，是linux环境，使用 conda。经查阅官网，最高可以使用 cudatoolkit11.6。本机的 CUDA 最好也是 11.6 匹配最佳。而 CUDA11.6 时代的 ubuntu 是 20.04版本，如果使用更高版本的 ubuntu，安装就会遇到问题，解决起来比较麻烦。

可以参看这个文档，讲的很好：https://www.cnblogs.com/yhjoker/p/10972795.html

## 安装 CUDA 11.6

如果实在 CUDA11.6 是最新版本的情况下，下面三行指令将会安装它。不过现在最新版是 CUDA11.7 了，需要手动选择安装的驱动型号。

```
$: sudo apt update
$: ubuntu-drivers devices
$: sudo ubuntu-drivers autoinstall
```
### ubuntu 自动安装 cuda11.6

上面指令会直接安装最新驱动，目前是515，对应cuda11.7. 但是 pytorch 不完美兼容 CUDA11.7，我们要尽量让 CUDA 和 cudatoolkit 版本完全一致.

```
sudo apt install nvidia-driver-510 
```
手动选择装这个驱动就会自动安装 cuda11.6

此处ubuntu自己安装驱动,而且会把cuda一并装好，装好之后重启才能使用。

重启后使用nvidia-smi显示显卡状态,可以看到Driver VERSION和CUDA VERSION.
```
Sat Jul 23 13:17:31 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 510.73.05    Driver Version: 510.73.05    CUDA Version: 11.6     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0  On |                  N/A |
| N/A   53C    P0    25W /  N/A |    202MiB /  6144MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      1289      G   /usr/lib/xorg/Xorg                127MiB |
|    0   N/A  N/A      1657      G   ...ome-remote-desktop-daemon        1MiB |
|    0   N/A  N/A      1702      G   /usr/bin/gnome-shell               25MiB |
|    0   N/A  N/A     10435      G   ...782933897633032226,131072       42MiB |
+-----------------------------------------------------------------------------+
```

如果上面这个方法行不通，就得去 CUDA 官网查询安装了。

CUDA11.6 官网：
https://developer.nvidia.com/cuda-11-6-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local

我又通过官网装了一次 CUDA Toolkit 11.6。

装完后可以把路径写进 .bashrc，就可以直接访问 nvcc -V 了。

```
echo 'export PATH=/usr/local/cuda-11.6/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

## 安装Anaconda

这个没什么难度,从官网安装就好了:
https://www.anaconda.com/

安装的时候注意看一下安装位置:
```
Anaconda3 will now be installed into this location:
/home/hap/anaconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/home/hap/anaconda3] >>> 
```

安装完之后会有提示，保存一下，不然忘了没法激活环境。

```
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
```

## conda 操作
### conda 激活和关闭环境
 To activate this environment, use

     $ conda activate torch

 To deactivate an active environment, use

     $ conda deactivate

### conda 查询环境信息
```
conda info --envs
```

## 安装 pytorch

官网上有指令，复制过来就行：

```
conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge

(base) hap@hap-ubuntu-xxxx:~$ echo $?
0
```

## 我安装 pytorch 遇到问题了，怎么办？

如果遇到：
```
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
```
这不是问题，不管，网络可以的情况下使劲等就行。大概就是固定流程走不通，采用灵活方案继续执行的意思。如果半小时等不出来，估计是网络问题。

如果很久都没等出来，试试下面指令，然后再重新安装 pytorch：
```
conda update -n base conda
conda update --all
conda update --prefix ~/anaconda3 anaconda
conda update --all
```

## 测试 pytorch 和 pytorch 的 GPU 支持

### 基本测试
打开 python，导入 torch 包。不报错就安装成功了，简单测试一下。

```
(base) hap@hap-ubuntu-xxxx:~$ python
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
```

### 测试 GPU 支持

```
>>> import torch
>>> torch.cuda.is_available()
True
>>> 
```

如果 GPU 支持是 FALSE，那就麻烦了。我安装了一个 CPU 环境和一个 GPU 环境，可以对比一下：


base 环境是 cpu 版本
torch 环境是 gpu 版本


CPU：

```
(base) hap@hap-ubuntu-xxxx:~$ conda list | grep torch

pytorch                   1.12.0              py3.9_cpu_0    pytorch
pytorch-mutex             1.0                         cpu    pytorch
torchaudio                0.12.0                 py39_cpu    pytorch
torchvision               0.13.0                 py39_cpu    pytorch
cudatoolkit               11.6.0              hecad31d_10    conda-forge
ipython                   8.4.0            py39h06a4308_0  
ipython_genutils          0.2.0              pyhd3eb1b0_1  
msgpack-python            1.0.3            py39hd09550d_0  
python                    3.9.12               h12debd9_1  
python-dateutil           2.8.2              pyhd3eb1b0_0  
python-fastjsonschema     2.15.1             pyhd3eb1b0_0  
python-libarchive-c       2.9                pyhd3eb1b0_1  
python-lsp-black          1.0.0              pyhd3eb1b0_0  
python-lsp-jsonrpc        1.0.0              pyhd3eb1b0_0  
python-lsp-server         1.2.4              pyhd3eb1b0_0  
python-slugify            5.0.2              pyhd3eb1b0_0  
python-snappy             0.6.0            py39h2531618_3  
python_abi                3.9                      2_cp39    conda-forge

```

GPU：

```
(torch) hap@hap-ubuntu-xxxx:~$ conda list | grep torch

# packages in environment at /home/hap/anaconda3/envs/torch:
ffmpeg                    4.3                  hf484d3e_0    pytorch
pytorch                   1.12.0          py3.9_cuda11.6_cudnn8.3.2_0    pytorch
pytorch-mutex             1.0                        cuda    pytorch
torchaudio                0.12.0               py39_cu116    pytorch
torchvision               0.13.0               py39_cu116    pytorch
cudatoolkit               11.6.0              hecad31d_10    conda-forge
pytorch                   1.12.0          py3.9_cuda11.6_cudnn8.3.2_0    pytorch
pytorch-mutex             1.0                        cuda    pytorch
python                    3.9.12               h12debd9_1  
python_abi                3.9                      2_cp39    conda-forge

```

可以看到，如果是 cpu 版本的 torch，可能需要重新搞个 conda 环境来一遍了。

方便拷贝的版本：

```
import torch
x = torch.rand(5, 3)
print(x)
torch.cuda.is_available()

conda list | grep torch
conda list | grep cuda
conda list | grep python
```


