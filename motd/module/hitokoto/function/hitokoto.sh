#!/usr/bin/zsh

function hitokoto() {
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
