#

mode=${1:-"code"}
user="`whoami`"
officeUser="miliao"
outLoc=${HOME}/.vim/caches/cscope.files
searchLoc=${HOME}/code


if [ "${mode}" == "code" ] && [ "${user}" == "${officeUser}" ];then
	searchLoc="${HOME}/code/gui_tflex"
elif [ "${mode}" == "cur" ];then
	searchLoc="`pwd`"
    outLoc="${searchLoc}/cscope.files"
fi

rm ${outLoc} 

find ${searchLoc} -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' -o -name '*.pl' -o -name '*.pm' > ${outLoc}

cscope -C -Rbq -i ${outLoc}

if [ "${mode}" != "cur" ]; then
    mv cscope.*  ${HOME}/.vim/caches/
fi

