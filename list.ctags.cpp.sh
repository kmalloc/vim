#/bin/sh

cpptarget=${HOME}/.vim/cpp.tags/tags
if [ -e ${cpptarget} ];then
	rm ${cpptarget}
fi

wxtarget=${HOME}/.vim/wx.tags/tags
if [ -e ${wxtarget} ];then
	rm ${wxtarget}
fi

if [ -e "tags" ];then
	rm tags
fi

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q /usr/include/
mkdir -p ${HOME}/.vim/cpp.ctags
mv tags ${HOME}/.vim/cpp.ctags

if [ $MD_WX_SOURCE_PATH ];then
    # wxPath=/usr/local/brion/wxWidgets/2.8.9/include
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${MD_WX_SOURCE_PATH}
	mkdir -p ${HOME}/.vim/wx.ctags
	mv tags ${HOME}/.vim/wx.ctags
else
	echo "not office computer.wx code is not going to be ctags"
fi


