#! /bin/env bash

mode=${1:-"code"}

#file path to store cscope files list
outLoc=${HOME}/.vim/caches/cscope.files

#code path is defined by env variable:MD_CODE_BASE, default is ~/code
searchLoc=${MD_CODE_BASE:-"${HOME}/code"}

searchLoc=${searchLoc/#~/$HOME}

if [ "${mode}" == "cur" ];then
	searchLoc="`pwd`"
    outLoc="${searchLoc}/cscope.files"
fi

if [ -e $outLoc ];then
    rm ${outLoc} 
fi

find ${searchLoc} -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' -o -name '*.pl' -o -name '*.pm' -o -name '*.py' > ${outLoc}

cscope -C -Rbq -i ${outLoc}

if [ "${mode}" != "cur" ]; then
    mv cscope.*  ${HOME}/.vim/caches/
fi

