

# TORCH.AUTOGRAD

torch.autograd是 PyTorch 的自动微分引擎，为神经网络训练提供动力。在本节中，您将对 autograd 如何帮助神经网络训练有一个概念性的了解。

## 背景

神经网络 (NN) 是在某些输入数据上执行的嵌套函数的集合。这些函数由参数 （由权重和偏差组成）定义，在 PyTorch 中存储在张量中。

训练 NN 分两个步骤进行：


前向传播：在前向传播中，NN 对正确的输出做出最好的猜测。它通过其每个函数运行输入数据以进行猜测。

反向传播：在反向传播中，神经网络根据猜测中的误差调整其参数。它通过从输出向后遍历，收集关于函数参数（梯度）的误差导数，并使用梯度下降优化参数来做到这一点。如需更详细的反向传播演练，请查看3Blue1Brown 中的此视频。

## 在 PyTorch 中的使用
让我们看一下单个训练步骤。对于此示例，我们从torchvision. 我们创建一个随机数据张量来表示具有 3 个通道、高度和宽度为 64 的单个图像，并将其对应的label初始化为一些随机值。预训练模型中的标签具有形状 (1,1000)。

`本教程仅适用于 CPU，不适用于 GPU（即使将张量移至 CUDA）。`

```
import torch, torchvision
model = torchvision.models.resnet18(pretrained=True)
data = torch.rand(1, 3, 64, 64)
labels = torch.rand(1, 1000)
```
接下来，我们通过模型的每一层运行输入数据以进行预测。这是前传。

```
prediction = model(data) # forward pass
```
我们使用模型的预测和相应的标签来计算误差（loss）。下一步是通过网络反向传播这个错误。当我们调用.backward()误差张量时，反向传播就开始了。Autograd 然后计算每个模型参数的梯度并将其存储在参数的.grad属性中。

```
loss = (prediction - labels).sum()
loss.backward() # backward pass
```
接下来，我们加载一个优化器，在本例中为 SGD，学习率为 0.01，动量为 0.9。我们在优化器中注册模型的所有参数。
```
optim = torch.optim.SGD(model.parameters(), lr=1e-2, momentum=0.9)
```
最后，我们调用.step()启动梯度下降。优化器通过存储在 中的梯度来调整每个参数.grad。
```
optim.step() #gradient descent
```

