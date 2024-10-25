#!/usr/bin/zsh

function fetch() {
    if { run_it fastfetch --pipe 0 } {
    } elif { run_it neofetch } {
    } elif { run_it uwufetch } {
    } elif { run_it screenfetch } {
    } elif { run_it hyfetch } {
    } else {
        log w "模块处于启用状态，但没有找到实用程序可供使用。"
        log w "以下是可以供使用的包:"
        log w "\n    "{fast,neo,uwu,screen,hy}"fetch"
    }
}
