#!/usr/bin/zsh

function run_it() {
    typeset log_header="[Core][Utils][run_it]"

    typeset command=(${(f)"$(which -ap $1 | head -n 1)"})

    if [[ "$1 not found" == $command ]] {
        log e "$1 not found"
        return 1
    }

    log n "$command $@[2,-1]"
    $command $@[2,-1]
}

function run_it_or_like_pipe() {
    typeset log_header="[Core][Utils][run_it_or_like_pipe]"

    typeset command=(${(f)"$(which -ap $1 | head -n 1)"})

    if [[ "$1 not found" == $command ]] {
        >&1
        return
    }

    log n $command $@[2,-1]
    $command $@[2,-1]
}

function slow-scan-print() {
    if [[ ${MOTD[$module,delay]:-0} != "0" ]] {
        run_it_or_like_pipe slow-scan-print -c -t "${MOTD[$module,delay]:-0}" $@
    }
    >&1
}

function lolcat() {
    run_it_or_like_pipe lolcat -F
}
