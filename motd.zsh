#!/usr/bin/env zsh

typeset -A Log=()
typeset -A MOTD=()

[[ -r ${HOME}/.config/motd.conf ]] && source ${HOME}/.config/motd.conf

#[AutomaticDerive]
Log[n,level]='Noice'
#[AutomaticDerive]
Log[i,level]='Info'
#[AutomaticDerive]
Log[w,level]='Warn'
#[AutomaticDerive]
Log[e,level]='Error'
#[AutomaticDerive]
Log[f,level]='Fail'

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
MOTD[banner,enable]=${MOTD[banner,enable]:-1}
MOTD[fetch,enable]=${MOTD[fetch,enable]:-1}
MOTD[hitokoto,enable]=${MOTD[hitokoto,enable]:-1}

# 慢扫描打印时的延迟，如果值为0则关闭慢扫描打印
# Delay during slow scan printing, if the value is 0 then slow scan printing is turned off
MOTD[banner,delay]=${MOTD[banner,delay]:-16ms}
MOTD[fetch,delay]=${MOTD[fetch,delay]:-16ms}
MOTD[hitokoto,delay]=${MOTD[hitokoto,delay]:-20ms}

# Git 设置
# Git settings
# Git 镜像开关
# Git Proxy Switch
MOTD[git,proxy,enable]=${MOTD[git,proxy,enable]:-1}
# Git 镜像格式化 URL
# Git Mirror Formatting URL
MOTD[git,proxy,format]=${MOTD[git,proxy,format]:-'https://ghproxy.org/github.com/%s'}

# 缓存目录
# cache directory
MOTD[cache]=${MOTD[cache]:-"${HOME}/.local/share/motd"}

# 可以显示的日志级别
# Log levels that can be shown
# MOTD[log,enableList]=\"n,i,w,e,f\"
MOTD[log,enableList]=${MOTD[log,enableList]:-'i,w,e,f'}

# hitokoto module
#[AutomaticDerive]
if [[ $MOTD[git,proxy,enable] > 0 ]] {
    MOTD[hitokoto,git,origin]="$(printf $MOTD[git,proxy,format] 'hitokoto-osc/sentences-bundle.git')"
} else {
    MOTD[hitokoto,git,origin]='https://github.com/hitokoto-osc/sentences-bundle.git'
}
#[AutomaticDerive]
MOTD[hitokoto,git,path]="${MOTD[cache]}/sentences-bundle"

function slow-scan-print() {
    if [[ $1 == 0 ]] {
        0>&1
    } elif [[ -x ${HOME}/.cargo/bin/slow-scan-print ]] {
        ${HOME}/.cargo/bin/slow-scan-print -c -t $1 $2
    } elif [[ -x /usr/bin/slow-scan-print ]] {
        /usr/bin/slow-scan-print -c -t $1 $2
    } else {
        0>&1
    }
}

function lolcat() {
    if [[ -x ${HOME}/.cargo/bin/lolcat ]] {
        ${HOME}/.cargo/bin/lolcat -F
    } elif [[ -x /usr/bin/lolcat ]] {
        /usr/bin/lolcat -F
    } else {
        0>&1
    }
}

function log() {
    (( ${(s:,:)${MOTD[log,enableList]}[(I)$1]} )) \
    && print -u 2 -f "[%s;1m[%s]%s: %s[0m\n" $Log[$1,color] $Log[$1,level] $log_header $2
}

# 获取系统名称信息
function get_os() {
    typeset log_header="[Banner][GetOS]"
    log n '尝试获取...'

    if {hostnamectl | sed -n -e 's/Operating System: //p' \
        || uname -o} {
        log n "成功。"
    } else {
        log f '失败！'
    }
}

function banner() {
    typeset log_header="[Banner][Printer]"
    typeset os=$(get_os)
    log n "os = '$os'"

    if [[ ! -z $os ]] {
        # 提前腾出足够的行空间，否则在剩余行空间不足时会导致代码产生非预期结果，这足足困扰了我两个小时才被发现
        # Free up enough line space in advance,
        # otherwise the code will produce unintended results when there is not enough line space left,
        # which bugged me for two hours before I realized it
        print -n "7\n\n\n\n\n8"

        for i ({1..${#os}}) {
            # 它看起来是对的，所以它是对的
            print -l -n ${(f)"$(figlet -f "/usr/share/figlet/fonts/ANSI_Shadow_Meow0x7E_editor.flf" ${os[$i]})"}
        }
    } else {
        log e "无法进行打印，os 变量为空。"
    }
}

function fetch() {
    typeset log_header="[Fetch][Printer]"
    if [[ -x /usr/bin/fastfetch ]] {
        fastfetch --pipe 0

        typeset -i ERRORLEVEL=$?

        if [[ $ERRORLEVEL > 1 ]] {
            log e "fastfetch 大抵是因为上游程序变更导致配置文件又炸了罢。"
        }
    } elif [[ -x /usr/bin/neofetch ]] {
        neofetch
    } else {
        log w "模块处于启用状态，但没有找到实用程序可供使用。"
    }
}

function update_hitokoto() {
    typeset log_header="[Hitokoto][Update]"

    if [[ -d $MOTD[hitokoto,git,path] ]] {
        cd $MOTD[hitokoto,git,path]
        log i "正在从远程仓库拉取更新..."
        git pull || {
            log e "无法从远程仓库拉取更新。"
            exit 1
        }
    } else {
        log w "未发现本地仓库，正在 clone 远程仓库到本地..."
        git clone $MOTD[hitokoto,git,origin] $MOTD[hitokoto,git,path] || {
            log f "无法将远程仓库 clone 到本地。"
            exit 1
        }
    }
}

function hitokoto() {
    typeset log_header="[Hitokoto][Printer]"

    [[ ! -d $MOTD[hitokoto,git,path] ]] && update_hitokoto

    # 从技术上讲，我只是按照一定规则从一系列文件中读取出了其中的一段内容。
    # Technically, I just read out a paragraph from a series of files according to certain rules.
    # 如果这违反了 AGPL，请联系并告知我。
    # If this is a violation of the AGPL, please contact and let me know.
    # 根据中国的国内网络环境进行推断，我可能会在一个月内的随机时间内突然收到一封迟来已久的邮件
    # Extrapolating from China's domestic network environment, I may receive a long overdue email out of the blue at a random time within a month
    <${MOTD[hitokoto,git,path]}/sentences/*.json \
        | grep -e '^    "h' \
        | sed -e 's/^    "hitokoto": "//' -e 's/",\?$//' \
        | shuf -n 1
}

while {getopts hvdgu arg} {
    case $arg {
        (h)
            print -u 2 "motd\nversion 0.3.1"
            print -u 2 -a -C 2 \
                '\-h' '打印帮助到错误流' \
                '\-v' '打印版本到错误流' \
                '\-d' '打印调试信息到错误流' \
                '\-g' '生成配置文件到~/.config/motd.conf'
                '\-u' '更新hitokoto语句库'
            exit
        ;;
        (v)
            print -u 2 "motd\nversion 0.3.0"
            exit
        ;;
        (d)
            print -a -C 2 ${(kv)MOTD}
        ;;
        (g)
            print "\
# 决定每个日志级别的颜色
# 详见 https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
# Set the color of each log level
# See https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
Log[n,color]=${Log[n,color]}
Log[i,color]=${Log[i,color]}
Log[w,color]=${Log[w,color]}
Log[e,color]=${Log[e,color]}
Log[f,color]=${Log[f,color]}

# 模块开关
# Module Switch
MOTD[banner,enable]=${MOTD[banner,enable]}
MOTD[fetch,enable]=${MOTD[fetch,enable]}
MOTD[hitokoto,enable]=${MOTD[hitokoto,enable]}

# 慢扫描打印时的延迟，如果值为0则关闭慢扫描打印
# Delay during slow scan printing, if the value is 0 then slow scan printing is turned off
MOTD[banner,delay]=${MOTD[banner,delay]}
MOTD[fetch,delay]=${MOTD[fetch,delay]}
MOTD[hitokoto,delay]=${MOTD[hitokoto,delay]}

# Git 设置
# Git settings
# Git 镜像开关
# Git Proxy Switch
MOTD[git,proxy,enable]=${MOTD[git,proxy,enable]}
# Git 镜像格式化 URL
# Git Mirror Formatting URL
MOTD[git,proxy,format]=${MOTD[git,proxy,format]}

# 缓存目录
# cache directory
MOTD[cache]=${MOTD[cache]}

# 可以显示的日志级别
# Log levels that can be shown
# MOTD[log,enableList]='n,i,w,e,f'
MOTD[log,enableList]='${MOTD[log,enableList]}'

# vim:set ft=zsh:\
" | tee ${HOME}/.config/motd.conf
            print -u 2 "[32;1m[Config][Generator]: 完成。[0m"
            exit
        ;;
        (u)
            update_hitokoto
            exit
        ;;
        (*)
            exit 1
        ;;
    }
}

#################### Start ####################
# MOTD 打印
# MOTD Print

if [[ $MOTD[banner,enable] > 0 ]] {
    banner \
        | slow-scan-print $MOTD[banner,delay] -l \
        | lolcat
}

if [[ $MOTD[fetch,enable] > 0 ]] {
    fetch \
        | slow-scan-print $MOTD[fetch,delay] -l
}

if [[ $MOTD[hitokoto,enable] > 0 ]] {
    hitokoto \
        | slow-scan-print $MOTD[hitokoto,delay] \
        | lolcat
}

# MOTD 打印
# MOTD Print
####################  End  ####################
