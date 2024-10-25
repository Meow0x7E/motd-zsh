#!/usr/bin/zsh

function update_hitokoto() {
    typeset log_header="${log_header}[update]"

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
