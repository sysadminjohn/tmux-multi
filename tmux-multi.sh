#!/bin/bash


TMUX_SESSION_NAME=ssh

######### Functions

prepare_connect() {

    which tmux 2>/dev/null 1>/dev/null

    if [[ $(echo $?) -ne 0 ]]; then 
        echo "tmux package not installed or not found"
        exit 1 
    fi




    read -p "TMUX SESSION NAME: " TMUX_SESSION_NAME

    tmux has-session -t "$TMUX_SESSION_NAME" 2>/dev/null

    if [[ $(echo $?) -eq 0 ]]; then
        echo "Tmux session with that name already exists"
        exit 1
    fi





    read -p "HOSTS: " HOSTS

    if [[ $HOSTS == '' ]]; then 
        echo "No hosts provided"
        exit 1
    fi




    
    if [[ $1 == 'ssh' ]]; then
        ssh_connect "$1" "$2" "$3" "$HOSTS"
    fi


    if [[ $1 == 'nc' || $1 == 'netcat' ]]; then
        nc_connect "$1" "$2" "$HOSTS"
    fi

}


nc_connect() {

    NC_PORT=$2
    HOSTS=$3


    if [[ $NC_PORT -lt 1 || $NC_PORT -gt 65535 ]]; then 
        echo "Netcat port is invalid"
        exit 1
    fi
    

    tmux new-session -s $TMUX_SESSION_NAME -d "watch -n 5 tmux ls"

    for H in $HOSTS ; do 
        i=$((i+1))
        tmux new-window -t $TMUX_SESSION_NAME:$i -n $H "nc -vv $H $NC_PORT"
    done

    tmux attach-session -t $TMUX_SESSION_NAME

}



ssh_connect() { 
    
    SSH_USER=$2
    SSH_PORT=$3
    HOSTS=$4




    if [[ $SSH_USER == '' ]]; then 
        echo "No user provided"
        exit 1
    fi





    if [[ $SSH_PORT -lt 1 || $SSH_PORT -gt 65535 ]]; then 
        echo "SSH port is invalid"
        exit 1
    fi
    



    tmux new-session -s $TMUX_SESSION_NAME -d "watch -n 5 tmux ls"

    for H in $HOSTS ; do 
        i=$((i+1))
        tmux new-window -t $TMUX_SESSION_NAME:$i -n $H "ssh -p $SSH_PORT $SSH_USER@$H"
    done

    tmux attach-session -t $TMUX_SESSION_NAME

}




show_error() {
    echo "Unknown option $1. Use -h or --help for usage"
}



show_help() {
cat << EOF
Description:
    Basic script that spawns N connections to N hosts with a given command

Usage: 
    tmux-multi.sh COMMAND USERNAME HOSTPORT
    
    USERNAME is not always required. Hosts will be asked after pressing ENTER and can be inserted one after the other, in the same line

Examples:
    sh tmux-multi.sh ssh myusername 22 
    sh tmux-multi.sh netcat 5666
    sh tmux-multi.sh nc 5666
EOF
}



######### Main section


while [[ $# -gt 0 ]]; do
    case $1 in
        ssh) prepare_connect "$1" "$2" "$3"; exit 0 ;;
        nc) prepare_connect "$1" "$2"; exit 0 ;;
        netcat) prepare_connect "$1" "$2"; exit 0 ;;
        -h|--help) show_help; exit 0 ;;
        *) show_error "$1"; exit 0 ;;
    esac

    shift

done


