#/bin/sh

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q /usr/include/
mkdir -p ${HOME}/.vim/cpp.tags
mv tags ${HOME}/.vim/cpp.tags



name="miliao"

if [ "`whoami`" == "$name" ];then
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q $THIRD_PARTY/wxWidgets/2.8.9/include
	mkdir -p ${HOME}/.vim/wx.tags
	mv tags ${HOME}/.vim/wx.tags
else
	echo "not office computer.wx code is not going to be ctags"
fi


