#!/usr/bin/zsh

[[ -r /etc/motd.conf ]] && source /etc/motd.conf
[[ -r ${HOME}/.config/motd.conf ]] && source ${HOME}/.config/motd.conf

#[AutomaticDerive]
Log[n,level]="Noice"
#[AutomaticDerive]
Log[i,level]="Info"
#[AutomaticDerive]
Log[w,level]="Warn"
#[AutomaticDerive]
Log[e,level]="Error"
#[AutomaticDerive]
Log[f,level]="Fail"

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
MOTD[root_warn,enable]=${MOTD[root_warn,enable]:-1}
MOTD[banner,enable]=${MOTD[banner,enable]:-1}
MOTD[fetch,enable]=${MOTD[fetch,enable]:-1}
MOTD[hitokoto,enable]=${MOTD[hitokoto,enable]:-1}

# 慢扫描打印时的延迟，如果值为0则关闭慢扫描打印
# Delay during slow scan printing, if the value is 0 then slow scan printing is turned off
MOTD[root_warn,enable]=${MOTD[root_warn,enable]:-32ms}
MOTD[banner,delay]=${MOTD[banner,delay]:-16ms}
MOTD[fetch,delay]=${MOTD[fetch,delay]:-16ms}
MOTD[hitokoto,delay]=${MOTD[hitokoto,delay]:-32ms}

MOTD[banner,font]=${MOTD[banner,font]:-"/usr/lib/motd/ANSI_Shadow.flf"}

# Git 设置
# Git settings
# Git 镜像开关
# Git Proxy Switch
MOTD[git,proxy,enable]=${MOTD[git,proxy,enable]:-1}
# Git 镜像格式化 URL
# Git Mirror Formatting URL
MOTD[git,proxy,format]=${MOTD[git,proxy,format]:-"https://ghp.ci/github.com/%s"}

# 缓存目录
# cache directory
MOTD[cache]=${MOTD[cache]:-"${HOME}/.local/share/motd"}

# 可以显示的日志级别
# Log levels that can be shown
MOTD[log,enableList]=${MOTD[log,enableList]:-"i,w,f"}

# hitokoto module
#[AutomaticDerive]
if [[ $MOTD[git,proxy,enable] > 0 ]] {
    MOTD[hitokoto,git,origin]="$(printf ${MOTD[git,proxy,format]} hitokoto-osc/sentences-bundle.git)"
} else {
    MOTD[hitokoto,git,origin]="https://github.com/hitokoto-osc/sentences-bundle.git"
}
#[AutomaticDerive]
MOTD[hitokoto,git,path]="${MOTD[cache]}/sentences-bundle"
