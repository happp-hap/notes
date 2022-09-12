

# ubuntu 网络问题记录

## ubuntu 脸上WiFi无法打开网页
    
```
sudo emacs /etc/resolv.conf
```
可以看到里面有 nameserver ，但是这个 nameserver 不可用。

注释掉当前的 nameserver，加入：
```
nameserver 114.114.114.114
```
即可使用。

