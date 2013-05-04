#

mode=${1:-"code"}
user="`whoami`"
officeUser="miliao"
outLoc=${HOME}/.vim/caches/cscope.files
searchLoc=${HOME}/code

rm ${outLoc} 

if [ "${mode}" == "code" ] && [ "${user}" == "${officeUser}" ];then
	searchLoc="${HOME}/code/gui_tflex"
elif [ "${mode}" == "cur" ];then
	searchLoc="`pwd`"
	outLoc="${searchLoc}"
fi


find ${searchLoc} -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' > ${outLoc}
