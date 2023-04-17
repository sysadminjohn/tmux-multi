#!/bin/bash


TMUX_SESSION_NAME=multissh

######### Functions

ssh_connect() { 
    
    SSH_USER=$2
    SSH_PORT=$3

    read -p "HOSTS: " HOSTS
    
    tmux new-session -s $TMUX_SESSION_NAME -d 

    for H in $HOSTS ; do 
        i=$((i+1))
        tmux new-window -t $TMUX_SESSION_NAME:$i -n $H "ssh -p $SSH_PORT $SSH_USER@$H"
        # tmux new-window -t $TMUX_SESSION_NAME:$i -n $H "ping $H"
    done

    tmux attach-session -t $TMUX_SESSION_NAME

}

show_error() {
    echo "Unknown option $1. Use -h or --help for usage"
}

show_help() {
cat << EOF
Description:
    Basic script that spawns N ssh connections

Usage: 
    tmux-multi.sh PROTOCOL USERNAME HOSTPORT
    
    Hosts will be asked after pressing ENTER and can be inserted one after the other, in the same line

Examples:
    sh tmux-multi.sh ssh myusername 22 
    (hit ENTER, hosts will be asked at stdin)
EOF
}


######### Main section

while [[ $# -gt 0 ]]; do
    case $1 in
        ssh) ssh_connect "$1" "$2" "$3"; exit 0 ;;
        -h|--help) show_help; exit 0 ;;
        *) show_error "$1"; exit 0 ;;
    esac

    shift

done


