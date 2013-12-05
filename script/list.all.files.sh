#!/bin/sh

#2 different modes:
#cur:search current directory.
#code:search code path(different in office and home)
mode=${1:-"code"}


function makelist
{
  outloc=${1:-"."}
  codeloc=${2:-"."}

  rm -f ${outloc}/filenametags
  touch ${outloc}/filenametags
  echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase" > ${outloc}/filenametags
  find ${codeloc}  -regex '.*\.\(h\|c\|cpp\|cc\|cxx\|py\|mk\|xrc\|sql\|sh\|pl\|pm\|txt\|Makefile\)' -type f -printf "%f\t%p\t1\n" | \
  sort -f >> ${outloc}/filenametags
}


if [ "${mode}" == "code" ]; then

    caches_folder=$HOME/.vim/caches

    #default code path is ~/code, if env variable MD_CODE_BASE is not defined
    code=${MD_CODE_BASE:-"${HOME}/code"}
    code=${code/#~/$HOME}

elif [ "${mode}" == "cur" ]; then

    caches_folder=`pwd`
    code_folder=${caches_folder}

else
	echo "invalid input."
fi

mkdir -p $caches_folder
makelist "${caches_folder}" "${code}"

