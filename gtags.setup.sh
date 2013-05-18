#! /bin/bash

mode = ${1:-"full"}

export GTAGSROOT="~/code"
export GTAGSDBPATH="~/.vim/caches"

if [ $mode != "env" ];then

    if [ -e "${GTAGSROOT}/GTAGS" ];then

        rm $GTAGSROOT/GTAGS 

    fi

    if [ -e "${GTAGSROOT}/GRTAGS" ];then

        rm $GTAGSROOT/GRTAGS 

    fi

    if [ -e "${GTAGSROOT}/GPATH" ];then

        rm $GTAGSROOT/GPATH

    fi

    gtags $GTAGSDBPATH

fi


