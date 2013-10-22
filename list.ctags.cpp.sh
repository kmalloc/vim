#/bin/sh

cppOutDir=${HOME}/.vim/caches/cpp.ctags
if [ -e ${cppOutDir}/tags ];then
	rm ${cppOutDir}/tags
fi

wxOutDir=${HOME}/.vim/caches/wx.ctags
if [ -e ${wxOutDir}/tags ];then
	rm ${wxOutDir}/tags
fi

if [ -e "tags" ];then
	rm tags
fi

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q /usr/include/

mkdir -p ${cppOutDir}
mv tags ${cppOutDir}/tags

if [ $MD_WX_SOURCE_PATH ];then
    # wxPath=/usr/local/brion/wxWidgets/2.8.9/include
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${MD_WX_SOURCE_PATH}
	mkdir -p $wxOutDir
	mv tags ${wxOutDir}/tags
else
	echo "not office computer.wx code is not going to be ctags"
fi


