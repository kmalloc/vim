#! /bin/sh

mode=${1:-"update"}
GTAGSROOT="${HOME}/code"
GTAGSDBPATH="${HOME}/.vim/caches"

if [ ${mode} != "cur" ] && [ `whoami` == "miliao" ];then
    GTAGSROOT=$GTAGSROOT/gui_tflex
elif [ ${mode} == "cur" ];then
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
    if [ ! -e "${GTAGSROOT}/${file}" ] && [ -e ${GTAGSDBPATH}/$file ];then
        ln -s ${HOME}/.vim/caches/$file ${GTAGSROOT}
    fi
}


function setup_tags
{
    root=${1:?"please specify root to search"}
    out_dir=${2:?"please specify output directory"}

    cd ${root}
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
    global -u  > /dev/null 2>&1 &
fi




