
[返回-pytorch使用](pytorch使用.md)

# pytorch 张量

## 张量是什么？

张量是机器学习程序中的数字容器,本质上就是各种不同维度的数组。


比如，我们可以使用 1 维张量表示一个一维数组。

比如，用 2 维张量表示一个矩阵。


比如，一张图片有三个通道，每个单色通道相当于一个数字矩阵，

所以用 3 维张量表示一张具有三色通道的图片，


并把很多张这种图片组成的视频或者单纯是要处理很多图片，需要存储在 4 维张量中。

我们要处理很多这样的视频，使用 5 维张量进行存储。

比如官方文档这么说
```
您有时会看到一个称为向量的 一维张量 。

同样，二维张量通常被称为 矩阵。

任何超过二维的东西通常都称为 张量。
```


## 创建张量

```
import torch

## creating tensors

# 3x4 3rows 4columns  # 2-demensional
x = torch.empty(3,4)
n
print(type(x))
print(x)
```

1. 导入 torch 包。
2. `torch.empty()` 创建一个 3 行 4 列的张量。有行和列，是 2 维张量。
3. `torch.empty()` 返回的类型是 `<class 'torch.Tensor'>`，是 `torch.FloatTensor` 的别名。默认情况下，PyTorch 张量使用有 32 位浮点数。
4. `torch.empty()` 产生的数字是随机的，取决于内存中当前的随机数。因为它没有对数字进行初始化。

## 初始化张量


很多时候，你会想要用一些值来初始化你的张量。常见的情况是全零、全一或随机值， torch模块为所有这些提供工厂方法：

```
zeros = torch.zeros(2, 3)
print(zeros)

ones = torch.ones(2, 3)
print(ones)

torch.manual_seed(1729)
random = torch.rand(2, 3)
print(random)
```

## 使用随机值初始化张量

实验中经常需要确保结果的可重复性，手动设置随机数生成器的种子是个好方法：
```
torch.manual_seed(1729)
random1 = torch.rand(2, 3)
print(random1)

random2 = torch.rand(2, 3)
print(random2)

torch.manual_seed(1729)
random3 = torch.rand(2, 3)
print(random3)

random4 = torch.rand(2, 3)
print(random4)
```

可以得到一样的随机值：

```
tensor([[0.3126, 0.3791, 0.3087],
        [0.0736, 0.4216, 0.0691]])
tensor([[0.3126, 0.3791, 0.3087],
        [0.0736, 0.4216, 0.0691]])
tensor([[0.2332, 0.4047, 0.2162],
        [0.9927, 0.4128, 0.5938]])
tensor([[0.3126, 0.3791, 0.3087],
        [0.0736, 0.4216, 0.0691]])
tensor([[0.2332, 0.4047, 0.2162],
        [0.9927, 0.4128, 0.5938]])
```

## 张量的形状

我们经常需要相同形状的张量。

下面的例子创建一个 2x2x3 形状的张量，并根据它的形状产生新的张量。

```

x = torch.empty(2, 2, 3)
print(x.shape)
print(x)

empty_like_x = torch.empty_like(x)
print(empty_like_x.shape)
print(empty_like_x)

zeros_like_x = torch.zeros_like(x)
print(zeros_like_x.shape)
print(zeros_like_x)

ones_like_x = torch.ones_like(x)
print(ones_like_x.shape)
print(ones_like_x)

rand_like_x = torch.rand_like(x)
print(rand_like_x.shape)
print(rand_like_x)
```

输出：
```
torch.Size([2, 2, 3])
tensor([[[-5.1434e+12,  3.0673e-41, -5.1422e+12],
         [ 3.0673e-41,  8.9683e-44,  0.0000e+00]],

        [[ 1.1210e-43,  0.0000e+00, -2.1103e-31],
         [ 3.0677e-41, -5.1436e+12,  3.0673e-41]]])
torch.Size([2, 2, 3])
tensor([[[ 4.2351e+22,  4.5886e-41,  4.2351e+22],
         [ 4.5886e-41, -0.0000e+00,  1.5912e+00]],

        [[ 3.6893e+19,  1.8732e+00, -2.0000e+00],
         [ 1.7064e+00,  1.0842e-19,  1.7735e+00]]])
torch.Size([2, 2, 3])
tensor([[[0., 0., 0.],
         [0., 0., 0.]],

        [[0., 0., 0.],
         [0., 0., 0.]]])
torch.Size([2, 2, 3])
tensor([[[1., 1., 1.],
         [1., 1., 1.]],

        [[1., 1., 1.],
         [1., 1., 1.]]])
torch.Size([2, 2, 3])
tensor([[[0.6128, 0.1519, 0.0453],
         [0.5035, 0.9978, 0.3884]],

        [[0.6929, 0.1703, 0.1384],
         [0.4759, 0.7481, 0.0361]]])
```

我们也可以从数字直接定义张量：

```
some_constants = torch.tensor([[3.1415926, 2.71828], [1.61803, 0.0072897]])
print(some_constants)

some_integers = torch.tensor((2, 3, 5, 7, 11, 13, 17, 19))
print(some_integers)

more_integers = torch.tensor(((2, 4, 6), [3, 6, 9]))
print(more_integers)
```

## 设置张量数据类型
```
a = torch.ones((2, 3), dtype=torch.int16)
print(a)

b = torch.rand((2, 3), dtype=torch.float64) * 20.
print(b)

c = b.to(torch.int32)
print(c)
```

输出：

```
tensor([[1, 1, 1],
        [1, 1, 1]], dtype=torch.int16)
tensor([[ 0.9956,  1.4148,  5.8364],
        [11.2406, 11.2083, 11.6692]], dtype=torch.float64)
tensor([[ 0,  1,  5],
        [11, 11, 11]], dtype=torch.int32)

```
可用的数据类型包括：

torch.bool

torch.int8

torch.uint8

torch.int16

torch.int32

torch.int64

torch.half

torch.float

torch.double

torch.bfloat

## PyTorch 张量的数学和逻辑

张量支持的简单运算：
```
ones = torch.zeros(2, 2) + 1
twos = torch.ones(2, 2) * 2
threes = (torch.ones(2, 2) * 7 - 1) / 2
fours = twos ** 2
sqrt2s = twos ** 0.5

print(ones)
print(twos)
print(threes)
print(fours)
print(sqrt2s)
```
输出：
```
tensor([[1., 1.],
        [1., 1.]])
tensor([[2., 2.],
        [2., 2.]])
tensor([[3., 3.],
        [3., 3.]])
tensor([[4., 4.],
        [4., 4.]])
tensor([[1.4142, 1.4142],
        [1.4142, 1.4142]])

```

两个张量之间的类似操作也表现得很直观：
```
powers2 = twos ** torch.tensor([[1, 2], [3, 4]])
print(powers2)

fives = ones + fours
print(fives)

dozens = threes * fours
print(dozens)

```

输出：
```
tensor([[ 2.,  4.],
        [ 8., 16.]])
tensor([[5., 5.],
        [5., 5.]])
tensor([[12., 12.],
        [12., 12.]])
```

形状不同的张量无法这样运算：

```
a = torch.rand(2, 3)
b = torch.rand(3, 2)

print(a * b) # 错误
```

## 张量的维度扩张*

```
rand = torch.rand(2, 4)
doubled = rand * (torch.ones(1, 4) * 2)

print(rand)
print(doubled)
```

```
tensor([[0.6146, 0.5999, 0.5013, 0.9397],
        [0.8656, 0.5207, 0.6865, 0.3614]])
tensor([[1.2291, 1.1998, 1.0026, 1.8793],
        [1.7312, 1.0413, 1.3730, 0.7228]])
```

## 更多张量数学
PyTorch 张量有超过三百个可以在它们上执行的操作。

以下是一些主要操作类别的小样本：

```
# common functions
a = torch.rand(2, 4) * 2 - 1
print('Common functions:')
print(torch.abs(a))
print(torch.ceil(a))
print(torch.floor(a))
print(torch.clamp(a, -0.5, 0.5))

# trigonometric functions and their inverses
angles = torch.tensor([0, math.pi / 4, math.pi / 2, 3 * math.pi / 4])
sines = torch.sin(angles)
inverses = torch.asin(sines)
print('\nSine and arcsine:')
print(angles)
print(sines)
print(inverses)

# bitwise operations
print('\nBitwise XOR:')
b = torch.tensor([1, 5, 11])
c = torch.tensor([2, 7, 10])
print(torch.bitwise_xor(b, c))

# comparisons:
print('\nBroadcasted, element-wise equality comparison:')
d = torch.tensor([[1., 2.], [3., 4.]])
e = torch.ones(1, 2)  # many comparison ops support broadcasting!
print(torch.eq(d, e)) # returns a tensor of type bool

# reductions:
print('\nReduction ops:')
print(torch.max(d))        # returns a single-element tensor
print(torch.max(d).item()) # extracts the value from the returned tensor
print(torch.mean(d))       # average
print(torch.std(d))        # standard deviation
print(torch.prod(d))       # product of all numbers
print(torch.unique(torch.tensor([1, 2, 1, 2, 1, 2]))) # filter unique elements

# vector and linear algebra operations
v1 = torch.tensor([1., 0., 0.])         # x unit vector
v2 = torch.tensor([0., 1., 0.])         # y unit vector
m1 = torch.rand(2, 2)                   # random matrix
m2 = torch.tensor([[3., 0.], [0., 3.]]) # three times identity matrix

print('\nVectors & Matrices:')
print(torch.cross(v2, v1)) # negative of z unit vector (v1 x v2 == -v2 x v1)
print(m1)
m3 = torch.matmul(m1, m2)
print(m3)                  # 3 times m1
print(torch.svd(m3))       # singular value decomposition
```

## 就地改变张量的值

只需要在操作函数后加一个小小的下划线，比如 `.sin()` 写成 `.sin_()` 即可，就可以就地改变张量的值。

```
a = torch.tensor([0, math.pi / 4, math.pi / 2, 3 * math.pi / 4])
print('a:')
print(a)
print(torch.sin(a))   # this operation creates a new tensor in memory
print(a)              # a has not changed

b = torch.tensor([0, math.pi / 4, math.pi / 2, 3 * math.pi / 4])
print('\nb:')
print(b)
print(torch.sin_(b))  # note the underscore
print(b)              # b has changed
```

输出：

```
a:
tensor([0.0000, 0.7854, 1.5708, 2.3562])
tensor([0.0000, 0.7071, 1.0000, 0.7071])
tensor([0.0000, 0.7854, 1.5708, 2.3562])

b:
tensor([0.0000, 0.7854, 1.5708, 2.3562])
tensor([0.0000, 0.7071, 1.0000, 0.7071])
tensor([0.0000, 0.7071, 1.0000, 0.7071])
```

## 如何复制张量

与 Python 中的任何对象一样，将张量分配给变量会使变量成为张量的标签，而不是复制它。例如：

```
a = torch.ones(2, 2)
b = a

a[0][1] = 561  # we change a...
print(b)       # ...and b is also altered
```

使用clone()方法：

```
a = torch.ones(2, 2)
b = a.clone()

assert b is not a      # different objects in memory...
print(torch.eq(a, b))  # ...but still with the same contents!

a[0][1] = 561          # a changes...
print(b)               # ...but b is still all ones
```


## 如何将张量迁移到 GPU

我们获取当前的设备信息，并通过字符串传递给 tensor。

```
if torch.cuda.is_available():
    my_device = torch.device('cuda')
else:
    my_device = torch.device('cpu')
print('Device: {}'.format(my_device))

x = torch.rand(2, 2, device=my_device)
print(x)
```

如果您有一个现有的张量存在于一个设备上，您可以使用该方法将其移动到另一个设备上to()。以下代码行在 CPU 上创建一个张量，并将其移动到您在前一个单元格中获取的任何设备句柄。
```
y = torch.rand(2, 2)
y = y.to(my_device)
```
重要的是要知道，为了进行涉及两个或多个张量的计算，所有张量必须在同一个设备上。无论您是否有可用的 GPU 设备，以下代码都会引发运行时错误：
```
x = torch.rand(2, 2)
y = torch.rand(2, 2, device='gpu')
z = x + y  # exception will be thrown
```

## 给张量添加一个维度

```
a = torch.rand(3, 226, 226)
b = a.unsqueeze(0) # 添加第 0 维度

print(a.shape)
print(b.shape)
```

## NumPy 和 PyTorch 转换
PyTorch 和 NumPy 之间有很深的亲缘关系。

NumPy 转到 PyTorch ：
```
import numpy as np

numpy_array = np.ones((2, 3))
print(numpy_array)

pytorch_tensor = torch.from_numpy(numpy_array)
print(pytorch_tensor)
```


PyTorch 转到 NumPy ：
```
pytorch_rand = torch.rand(2, 3)
print(pytorch_rand)

numpy_rand = pytorch_rand.numpy()
print(numpy_rand)
```
转换后的对象使用与其源对象相同的底层内存，一个变了另一个也会变：

```
numpy_array[1, 1] = 23
print(pytorch_tensor)

pytorch_rand[1, 1] = 17
print(numpy_rand)
```
输出：
```
tensor([[ 1.,  1.,  1.],
        [ 1., 23.,  1.]], dtype=torch.float64)
[[ 0.87163675  0.2458961   0.34993553]
 [ 0.2853077  17.          0.5695162 ]]
```

[返回-pytorch使用](pytorch使用.md)
