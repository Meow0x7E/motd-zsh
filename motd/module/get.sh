#!/usr/bin/zsh

{
    (( #Modules <= 0 )) && typeset -a Modules=(
        banner
        fetch
        root_warn
        hitokoto
    )

    print -l $Modules
}
