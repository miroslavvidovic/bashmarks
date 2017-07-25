#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Miroslav Vidovic
#   file:      bashmarks.sh
#   created:   18.07.2017.-17:32:33
#   revision:  ---
#   version:   1.0
# -----------------------------------------------------------------------------
# Requirements:
#
# Description:
#   Directory bookmarking for the shell
# Usage:
#    bs bookmarkname - saves the curr dir as bookmarkname
#    bg bookmarkname - jumps to the that bookmark
#    bg b[TAB] - tab completion is available
#    bp bookmarkname - prints the bookmark
#    bp b[TAB] - tab completion is available
#    bd bookmarkname - deletes the bookmark
#    bd [TAB] - tab completion is available
#    bl - list all bookmarks
#
# Credits:
#   Original script by
#   Huy Nguyen, http://www.huyng.com
#   forked from https://github.com/huyng/bashmarks
# -----------------------------------------------------------------------------
# Script:

# setup file to store bookmarks
if [ ! -n "$SDIRS" ]; then
    SDIRS=~/.sdirs
fi
touch $SDIRS

RED="0;31m"

# save current directory to bookmarks
function bs {
    check_help "$1"
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$SDIRS" "export DIR_$1="
        CURDIR=$(echo $PWD| sed "s#^$HOME#\$HOME#g")
        echo "export DIR_$1=\"$CURDIR\"" >> $SDIRS
    fi
}

# jump to bookmark
function bg {
    check_help "$1"
    source $SDIRS
    target="$(eval $(echo echo $(echo \$DIR_$1)))"
    if [ -d "$target" ]; then
        cd "$target"
    elif [ ! -n "$target" ]; then
        echo -e "\033[${RED}WARNING: '${1}' bashmark does not exist\033[00m"
    else
        echo -e "\033[${RED}WARNING: '${target}' does not exist\033[00m"
    fi
}

# print bookmark
function bp {
    check_help "$1"
    source $SDIRS
    echo "$(eval $(echo echo $(echo \$DIR_$1)))"
}

# delete bookmark
function bd {
    check_help "$1"
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$SDIRS" "export DIR_$1="
        unset "DIR_$1"
    fi
}

# print out help for the forgetful
function check_help {
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        echo ''
        echo 'bs <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'bg <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'bp <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'bd <bookmark_name> - Deletes the bookmark'
        echo 'bl                 - Lists all available bookmarks'
        kill -SIGINT $$
    fi
}

# list bookmarks with directory name
function bl {
    check_help "$1"
    source $SDIRS

    # if color output is not working for you, comment out the line below '\033[1;32m' == "red"
    env | sort | awk '/^DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'
}

# list bookmarks without dirname
function _l {
    source $SDIRS
    env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "="
}

# validate bookmark name
function _bookmark_name_valid {
    exit_message=""
    if [ -z "$1" ]; then
        exit_message="bookmark name required"
        echo "$exit_message"
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="bookmark name is not valid"
        echo "$exit_message"
    fi
}

# completion command
function _comp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

# ZSH completion command
function _compzsh {
    reply=($(_l))
}

# safe delete line from sdirs
function _purge_line {
    if [ -s "$1" ]; then
        # safely create a temp file
        t=$(mktemp -t bashmarks.XXXXXX) || exit 1
        trap "/bin/rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        /bin/mv "$t" "$1"

        # cleanup temp file
        /bin/rm -f -- "$t"
        trap - EXIT
    fi
}

# Fuzzy search for a bookmark with fzf
function bf {
    source $SDIRS

    # First check if fzf is installed
    hash fzf 2>/dev/null || { 
       echo >&2 "Fzf required but it's not installed.  Aborting."; return 1; 
    }

    dir=$(env | sort | awk '/^DIR_.+/{split(substr($0,5),parts,"="); printf("%s\n", parts[2]);}' | fzf -m --reverse --margin 2%,2%,2%,2% )
    cd "$dir"
}

# bind completion command for bg,bp,bd to _comp
if [ "$ZSH_VERSION" ]; then
    compctl -K _compzsh bg
    compctl -K _compzsh bp
    compctl -K _compzsh bd
else
    shopt -s progcomp
    complete -F _comp bg
    complete -F _comp bp
    complete -F _comp bd
fi
