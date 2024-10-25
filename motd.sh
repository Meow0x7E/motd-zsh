#!/usr/bin/zsh

typeset -r Version="1.0.0"
typeset -A Log=()
typeset -A MOTD=()
typeset -a MODULE=()

typeset this=${0:A:h}

MOTD[share]=${MOTD_SHARE:-"/usr/share"}
MOTD[lib]=${MOTD_LIB:-"/usr/lib"}

function log() {
    (( ${(s:,:)${MOTD[log,enableList]}[(I)$1]} )) \
    && print -u 2 "[${Log[$1,color]};1m[${Log[$1,level]}]${log_header}: ${@[2,-1]}[0m"
}

for module (${(f)"$(zsh ${MOTD[lib]}/motd/core/get.sh)"}) {
    . "${MOTD[lib]}/motd/core/$module/run.sh"
}

#################### Start ####################
# 解析命令行参数
# Parse command line arguments

while {getopts hvdgu arg} {
    case $arg {
        (h)
            >&2 <<-EOF
使用: motd [选项]

选项:
    -h 打印帮助到错误流
    -v 打印版本到错误流
    -d 打印调试信息到错误流
    -g 以默认设置创建一个配置文件到 ~/.config
EOF
            exit
        ;;
        (v)
            print -u 2 "motd - v$Version"
            exit
        ;;
        (d)
            MOTD_DEBUG=1
            MOTD[log,enableList]="n,i,w,e,f"
            print -a -C 2 ${(kv)MOTD}
        ;;
        (g)
            install -Dm 644 "${MOTD[share]}/motd.conf" "~/.config/motd.conf"
            exit
        ;;
        (*)
            exit 1
        ;;
    }
}

# 解析命令行参数
# Parse command line arguments
####################  End  ####################


#################### Start ####################
# MOTD 打印
# MOTD Print

for module (${(f)"$(zsh "${MOTD[lib]}/motd/module/get.sh")"}) {
    typeset log_header="[$module]"
    typeset module_dir="${MOTD[lib]}/motd/module/$module"

    if (( MOTD[${module},enable] <= 0 )) {
        log n "Module $module disabled, skip run"
        continue
    }

    typeset -a fn=(${(f)"$(find "${MOTD[lib]}/motd/module/${module}/function" -type f | sort)"})

    for f ($fn) {
        log n "Load function ${f:t:r}"
        . $f
    }

    . "${MOTD[lib]}/motd/module/${module}/run.sh"

    for f ($fn) {
        log n "Unload function ${f:t:r}"
        unfunction ${f:t:r}
    }
}

# MOTD 打印
# MOTD Print
####################  End  ####################
