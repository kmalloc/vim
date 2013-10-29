#! /bin/bash

#code base is defined by env varaible: MD_CODE_BASE
#default is ~/code
GTAGSROOT=${MD_CODE_BASE:-"${HOME}/code"}

GTAGSROOT=${GTAGSROOT/#~/$HOME}

#hard-coded cache data path
GTAGSDBPATH="${HOME}/.vim/caches"

mode=${1:-"update"}

if [ ${mode} == "cur" ];then
    GTAGSROOT="`pwd`"
    GTAGSDBPATH=${GTAGSROOT}
fi

function list_files
{
    search_path=${1:-"."}
    out_path=${2:-"."}

    find ${search_path} -name \*.cpp -o -name \*.h -o -name \*.pl -o -name \*.pm -o -name \*.cc -o -name \*.hpp -o -name \*.sh -o -name \*.c > ${out_path}/gtags.files
}

function set_link 
{
    file=${1:?"please specify file to link"}

    if [ -e "${GTAGSROOT}/${file}" ];then
        rm ${GTAGSROOT}/${file};
    fi
    

    if [ -e ${GTAGSDBPATH}/$file ];then
        ln -s ${HOME}/.vim/caches/$file ${GTAGSROOT}
    fi
}

function setup_tags
{
    root=${1:?"please specify root to search"}
    out_dir=${2:?"please specify output directory"}

    cd ${root}

    pgrep gtags|xargs kill -9
    list_files $root $out_dir
    gtags -f "${out_dir}/gtags.files" ${out_dir}
}

if [ ${mode} == "setup" ];then

    if [ -e "${GTAGSDBPATH}/GTAGS" ];then

        rm ${GTAGSDBPATH}/GTAGS 

    fi

    if [ -e "${GTAGSDBPATH}/GRTAGS" ];then

        rm ${GTAGSDBPATH}/GRTAGS 

    fi

    if [ -e "${GTAGSDBPATH}/GPATH" ];then

        rm ${GTAGSDBPATH}/GPATH

    fi

    setup_tags ${GTAGSROOT} $GTAGSDBPATH

elif [ ${mode} == "cur" ];then

    setup_tags ${GTAGSROOT} $GTAGSDBPATH

elif [ ${mode} == "files" ];then

    path=${2:-"."}
    list_files $path $GTAGSDBPATH    

elif [ ${mode} == "env" ];then

    set_link GTAGS
    set_link GPATH
    set_link GRTAGS

else 

    cd ${GTAGSROOT}
    pgrep gtags|xargs kill -9
    global -u > /dev/null 2>&1
fi




