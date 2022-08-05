[返回-pytorch使用](pytorch使用.md)

# pytorch 的使用 - 快速创建模型

对于安装了 CPU 或者 GPU 版本的 Pytorch 的小伙伴。这里提供 Pytorch 的使用指导。


## Pytorch 是什么，怎么使用？

Pytorch 是一个开源机器学习框架，可加速从研究原型设计到生产部署的路径。

在 python 中使用安装好的 pytorch：

```
import torch
## 这样就导入了 pytorch 包
```

导入没有任何报错，就可以使用了。

如果需要的话，当用到别的包，我们再导入。

## 我想立刻用 pytorch 建立一个模型？

神经网络的训练从数据开始，通过模型进行训练，同时我们要学会保存和加载模型，以应对不同的使用情况。

我们先迅速开始，至于细节，再慢慢学习。

### 提供数据

当前，我们直接使用如下 python 指令导入和获取数据：

```
# -*- coding:utf-8 -*-
# /bin/env python

import torch
from torchvision import datasets
from torchvision.transforms import ToTensor

# Download training data from open datasets.
training_data = datasets.FashionMNIST(
    root="data",
    train=True,
    download=True,
    transform=ToTensor(),
)

# Download test data from open datasets.
test_data = datasets.FashionMNIST(
    root="data",
    train=False,
    download=True,
    transform=ToTensor(),
)

print(training_data)
print(test_data)
```

输出是这样的：

```
Dataset FashionMNIST
    Number of datapoints: 60000
    Root location: data
    Split: Train
    StandardTransform
Transform: ToTensor()
Dataset FashionMNIST
    Number of datapoints: 10000
    Root location: data
    Split: Test
    StandardTransform
Transform: ToTensor()

```

这样，我们的数据，就存储在 `training_data` 和 `test_data` 中了。

我们使用 `DataLoader` 来加载数据：

```
from torch.utils.data import DataLoader

batch_size = 64

# Create data loaders.
train_dataloader = DataLoader(training_data, batch_size=batch_size)
test_dataloader = DataLoader(test_data, batch_size=batch_size)

for X, y in test_dataloader:
    print(f"Shape of X [N, C, H, W]: {X.shape}")
    print(f"Shape of y: {y.shape} {y.dtype}")
    break
```


其中，我们设定 `batch_size = 64` .

输出是这样的：
```
Transform: ToTensor()
Shape of X [N, C, H, W]: torch.Size([64, 1, 28, 28])
Shape of y: torch.Size([64]) torch.int64
```



### 创建模型

通过以下方式我们可以定义一个神经网络：

```
from torch import nn

# 使用 CPU 或 GPU
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Using {device} device")

# Define model
class NeuralNetwork(nn.Module):
    def __init__(self):
        super(NeuralNetwork, self).__init__()
        self.flatten = nn.Flatten()
        self.linear_relu_stack = nn.Sequential(
            nn.Linear(28*28, 512),
            nn.ReLU(),
            nn.Linear(512, 512),
            nn.ReLU(),
            nn.Linear(512, 10)
        )

    def forward(self, x):
        x = self.flatten(x)
        logits = self.linear_relu_stack(x)
        return logits

model = NeuralNetwork().to(device)
print(model)

```

输出是这样的：
```
Using cuda device
NeuralNetwork(
  (flatten): Flatten(start_dim=1, end_dim=-1)
  (linear_relu_stack): Sequential(
    (0): Linear(in_features=784, out_features=512, bias=True)
    (1): ReLU()
    (2): Linear(in_features=512, out_features=512, bias=True)
    (3): ReLU()
    (4): Linear(in_features=512, out_features=10, bias=True)
  )
)
```

### 模型训练

我们需要一个损失函数 和一个优化器，来训练一个模型。

```
loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)
```

定义一个训练器，它接受 `dataloader` 的数据，传入模型、损失函数、优化器。

```
def train(dataloader, model, loss_fn, optimizer):
    size = len(dataloader.dataset)
    model.train()
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            loss, current = loss.item(), batch * len(X)
            print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")
```

根据测试数据集检查模型的性能，以确保它正在学习。
```
def test(dataloader, model, loss_fn):
    size = len(dataloader.dataset)
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            X, y = X.to(device), y.to(device)
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    correct /= size
    print(f"Test Error: \n Accuracy: {(100*correct):>0.1f}%, Avg loss: {test_loss:>8f} \n")
```

在迭代中不断改进，经过很多个 `epoch` 我们希望看到每个 epoch 的准确率增加多少、损失减少多少。

```
epochs = 5
for t in range(epochs):
    print(f"Epoch {t+1}\n-------------------------------")
    train(train_dataloader, model, loss_fn, optimizer)
    test(test_dataloader, model, loss_fn)
print("Done!")
```

训练过程：

```
Epoch 1
-------------------------------
loss: 2.329429  [    0/60000]
loss: 2.309937  [ 6400/60000]
loss: 2.291264  [12800/60000]
loss: 2.266989  [19200/60000]
loss: 2.259492  [25600/60000]
loss: 2.243607  [32000/60000]
loss: 2.232175  [38400/60000]
loss: 2.213094  [44800/60000]
loss: 2.207207  [51200/60000]
loss: 2.168434  [57600/60000]
Test Error: 
 Accuracy: 47.8%, Avg loss: 2.175150 

Epoch 2
-------------------------------
loss: 2.193502  [    0/60000]
loss: 2.184575  [ 6400/60000]
loss: 2.135859  [12800/60000]
loss: 2.133664  [19200/60000]
loss: 2.100769  [25600/60000]
loss: 2.055261  [32000/60000]
loss: 2.060685  [38400/60000]
loss: 2.001950  [44800/60000]
loss: 1.995799  [51200/60000]
loss: 1.924304  [57600/60000]
Test Error: 
 Accuracy: 57.0%, Avg loss: 1.934051 

Epoch 3
-------------------------------
loss: 1.967136  [    0/60000]
loss: 1.948179  [ 6400/60000]
loss: 1.841085  [12800/60000]
loss: 1.856853  [19200/60000]
loss: 1.770945  [25600/60000]
loss: 1.725338  [32000/60000]
loss: 1.716912  [38400/60000]
loss: 1.632975  [44800/60000]
loss: 1.641908  [51200/60000]
loss: 1.531296  [57600/60000]
Test Error: 
 Accuracy: 60.6%, Avg loss: 1.559509 

Epoch 4
-------------------------------
loss: 1.622936  [    0/60000]
loss: 1.595014  [ 6400/60000]
loss: 1.449656  [12800/60000]
loss: 1.502216  [19200/60000]
loss: 1.394695  [25600/60000]
loss: 1.390178  [32000/60000]
loss: 1.380283  [38400/60000]
loss: 1.313331  [44800/60000]
loss: 1.347661  [51200/60000]
loss: 1.235147  [57600/60000]
Test Error: 
 Accuracy: 62.6%, Avg loss: 1.271715 

Epoch 5
-------------------------------
loss: 1.347430  [    0/60000]
loss: 1.331492  [ 6400/60000]
loss: 1.172755  [12800/60000]
loss: 1.266603  [19200/60000]
loss: 1.149738  [25600/60000]
loss: 1.176681  [32000/60000]
loss: 1.178730  [38400/60000]
loss: 1.122707  [44800/60000]
loss: 1.165764  [51200/60000]
loss: 1.066620  [57600/60000]
Test Error: 
 Accuracy: 64.0%, Avg loss: 1.098096 

Done!
```



### 保存模型

```
torch.save(model.state_dict(), "model.pth")
print("Saved PyTorch Model State to model.pth")
```

### 加载模型
```
model = NeuralNetwork()
model.load_state_dict(torch.load("model.pth"))
```

### 使用模型进行预测

```
classes = [
    "T-shirt/top",
    "Trouser",
    "Pullover",
    "Dress",
    "Coat",
    "Sandal",
    "Shirt",
    "Sneaker",
    "Bag",
    "Ankle boot",
]

model.eval()
x, y = test_data[0][0], test_data[0][1]
with torch.no_grad():
    pred = model(x)
    predicted, actual = classes[pred[0].argmax(0)], classes[y]
    print(f'Predicted: "{predicted}", Actual: "{actual}"')
```




[返回-pytorch使用](pytorch使用.md)
