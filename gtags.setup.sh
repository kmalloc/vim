#! /bin/sh

mode=${1:-"update"}
export GTAGSROOT="${HOME}/code"
export GTAGSDBPATH="${HOME}/.vim/caches"

function list_files
{
    search_path=${1:-"."}
    out_path=${2:-"."}

    find ${search_path} -name \*.cpp -o -name \*.h -o -name \*.cc -o -name \*.hpp -o -name \*.sh -o -name \*.c > ${out_path}/gtags.files
}


if [ ${mode} == "setup" ];then
    if [ -e "${GTAGSROOT}/GTAGS" ];then

        rm ${GTAGSROOT}/GTAGS 

    fi

    if [ -e "${GTAGSROOT}/GRTAGS" ];then

        rm ${GTAGSROOT}/GRTAGS 

    fi

    if [ -e "${GTAGSROOT}/GPATH" ];then

        rm ${GTAGSROOT}/GPATH

    fi

    cd ${HOME}/code/
    list_files $GTAGSROOT $GTAGSDBPATH
    gtags -f "${GTAGSDBPATH}/gtags.files" ${GTAGSDBPATH}

elif [ ${mode} == "files" ];then

    path=${2:-"."}
    list_files $path $GTAGSDBPATH    
else 

    cd ${GTAGSROOT}
    global -u &
fi




