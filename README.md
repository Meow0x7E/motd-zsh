# motd

```
使用: motd [<选项>]

选项:
     -h  打印帮助到错误流
     -v  打印版本到错误流
     -d  打印调试信息到错误流
     -g  生成配置文件到 ~/.config/motd.conf
     -u  更新hitokoto语句库

```

> [!TIP]
> `hitokoto` 数据存储在 `~/.local/share/motd` 目录中。


## 预览

![Preview](doc/preview.png)

## 安装

- Arch Linux
    - 在终端执行以下命令
    ```
        git clone https://github.com/Meow0x7E/motd.git
        cd motd
        makepkg -si
    ```
- 手动安装
    - 执行以下命令
    ```
    git clone https://github.com/Meow0x7E/motd-zsh.git /tmp/motd-zsh
    cd /tmp/motd-zsh
    sudo install -Dvm 755 "motd.zsh" "/usr/bin/motd"
    sudo install -Dvm 644 "ANSI_Shadow_Meow0x7E_editor.flf" "/usr/share/figlet/fonts/ANSI_Shadow_Meow0x7E_editor.flf"
    ```

## 卸载与清理

> [!CAUTION]
> 请慎重审查命令中的路径是否完整正确，否则错误的命令将可能导致系统损坏或数据丢失，我不会对错误的命令造成的任何损害负责

### 非手动安装
通过你使用的发行版的对应包管进行卸载

执行以下命令

```
rm -rf '~/.config/motd.conf' \
    '~/.local/share/motd/'
```

### 手动安装

执行以下命令

```
rm -rf '/usr/bin/motd' \
    '/usr/share/figlet/fonts/ANSI_Shadow_Meow0x7E_editor.flf' \
    '~/.config/motd.conf' \
    '~/.local/share/motd/'
```

## 默认配置文件

```
# 决定每个日志级别的颜色
# 详见 https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
# Set the color of each log level
# See https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
Log[n,color]=35
Log[i,color]=37
Log[w,color]=33
Log[e,color]=31
Log[f,color]=91

# 模块开关
# Module Switch
MOTD[banner,enable]=1
MOTD[fetch,enable]=1
MOTD[hitokoto,enable]=1

# 慢扫描打印时的延迟，如果值为0则关闭慢扫描打印
# Delay during slow scan printing, if the value is 0 then slow scan printing is turned off
MOTD[banner,delay]=0
MOTD[fetch,delay]=16ms
MOTD[hitokoto,delay]=20ms

# Git 设置
# Git settings
# Git 镜像开关
# Git Proxy Switch
MOTD[git,proxy,enable]=1
# Git 镜像格式化 URL
# Git Mirror Formatting URL
MOTD[git,proxy,format]=https://ghproxy.org/github.com/%s

# 缓存目录
# cache directory
MOTD[cache]=/home/Meow0x7E/.local/share/motd

# 可以显示的日志级别
# Log levels that can be shown
# MOTD[log,enableList]='n,i,w,e,f'
MOTD[log,enableList]='i,w,e,f'

# vim:set ft=zsh:
```
