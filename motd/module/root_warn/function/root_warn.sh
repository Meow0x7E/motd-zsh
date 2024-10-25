#!/usr/bin/zsh

function root_warn() {
    [[ "$(id -u)" != "0" ]] && return
    print "
[31;1m##################### Attention! #####################
#                                                    #
#         you are logged in as root,                 #
#         you should be careful what you do!         #
#                                                    #
######################################################[0m"
}
