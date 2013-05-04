name="miliao"

if [ "`whoami`" == "$name" ];then
	ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q $THIRD_PARTY/wxWidgets/2.8.9/include
	mkdir -p ~/.vim/wx.tags
	mv tags ~/.vim/wx.tags
else
	echo "if condition work"
fi

#test message
