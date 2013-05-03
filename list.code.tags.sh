#/bin/sh

path=${1:-"cur"}
user="miliao"

if [ "${path}" == "gui" ] && [ "`whoami`" != "$user" ];then
	echo "error,not in office computer"
    exit 0	
fi


if [ "${path}" == "cur" ];then
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q `pwd`

	mkdir -p ${HOME}/.vim/cur.tags
	mv tags ${HOME}/.vim/cur.tags
elif [ "${path}" == "gui" ];then
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${HOME}/code/gui_tflex/

	mkdir -p ${HOME}/.vim/gui.tags
	mv tags ${HOME}/.vim/gui.tags
else

	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${path}

	mkdir -p ${HOME}/.vim/cur.tags
	mv tags ${HOME}/.vim/cur.tags
fi





