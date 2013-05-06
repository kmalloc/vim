#/bin/sh

mode=${1:-"code"}
path=${HOME}/code
user="miliao"

if [ "${mode}" == "code" ];then
	if [ "${user}" == "`whoami`" ];then
		path=${HOME}/code/gui_tflex
		mode="gui"
	else
		mode="cur"
	fi
else
	path="`pwd`"
fi

if [ -e "tags" ];then
	rm tags
fi


guiTarget=${HOME}/.vim/gui.tags/tags
if [ -e "${guiTarget}" ];then
	rm ${guiTarget}
fi


ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${path}

if [ "${mode}" == "cur" ];then
	mkdir -p ${HOME}/.vim/cur.tags
	mv tags ${HOME}/.vim/cur.tags
elif [ "${mode}" == "gui" ];then
	mkdir -p ${HOME}/.vim/gui.tags
	mv tags ${HOME}/.vim/gui.tags
fi





