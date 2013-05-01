#/bin/sh

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q /usr/include/
mkdir -p ~/.vim/cpp.tags
mv tags ~/.vim/cpp.tags



name="miliao"

if [ "`whoami`" == "$name" ];then
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q $THIRD_PARTY/wxWidgets/2.8.9/include
	mkdir -p ~/.vim/wx.tags
	mv tags ~/.vim/wx.tags
else
	echo "not office computer.wx code is not going to be ctags"
fi


