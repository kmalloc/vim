#/bin/sh

mode=${1:-"code"}

path=${MD_CODE_BASE:-"${HOME}/code"}

if [ "${mode}" == "cur" ];then
	path="`pwd`"
fi

if [ -e "tags" ];then
	rm $path/tags
fi

codeTarget=${HOME}/.vim/code.ctags/tags

if [ -e "${codeTarget}" ];then
	rm ${codeTarget}
fi


ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${path}

if [ "${mode}" == "cur" ];then
	mkdir -p ${HOME}/.vim/cur.ctags
	mv tags ${HOME}/.vim/cur.ctags
elif [ "${mode}" == "code" ];then
	mkdir -p ${HOME}/.vim/code.ctags
	mv tags ${HOME}/.vim/code.ctags
fi


