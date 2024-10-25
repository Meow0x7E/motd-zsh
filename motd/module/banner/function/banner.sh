#!/usr/bin/zsh

# 神奇字符串魔法，别动，动了就爆炸
function banner() {
    source /etc/os-release || typeset NAME=$(uname -o)
    log n "Operating System: $NAME"

    if [[ -z $NAME ]] {
        log e "无法进行打印，未获取到操作系统名称"
        return
    }
    # figlet 会在打印结束后换行，需要减去一得到正确高度
    typeset -i height=$(( ${#${(f)"$(figlet -f "$MOTD[$module,font]" A)"}} - 1 ))

    for index ({1..$#NAME}) {
        typeset -a big_char=(${(f)"$(figlet -f "$MOTD[$module,font]" $NAME[$index])"})
        typeset -i char_length=0

        if (( index > 1 )) {
            print -n "[${height}A"
        }
        print "7${big_char[1]}"

        for line_index ({2..$#big_char}) {
            typeset buf="$big_char[$line_index]"

            (( char_length < #buf )) && char_length=$#buf

            (( line_index != #big_char )) && buf="7${buf}"
            buf="8D${buf}"
            print ${buf}
        }

        print -n "8[${char_length}C"
    }
}
