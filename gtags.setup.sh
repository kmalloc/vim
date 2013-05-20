#! /bin/bash

mode=${1:-"update"}

if [ ${mode} == "setup" ];then
    if [ -e "${GTAGSROOT}/GTAGS" ];then

        rm $GTAGSROOT/GTAGS 

    fi

    if [ -e "${GTAGSROOT}/GRTAGS" ];then

        rm $GTAGSROOT/GRTAGS 

    fi

    if [ -e "${GTAGSROOT}/GPATH" ];then

        rm $GTAGSROOT/GPATH

    fi

    cd ${GTAGSROOT}
    GTAGSROOT="${HOME}/code" GTAGSDBPATH="${HOME}/.vim/caches" gtags $GTAGSDBPATH

else

    cd ${GTAGSROOT}
    GTAGSROOT="${HOME}/code" GTAGSDBPATH="${HOME}/.vim/caches" global -u"

fi
