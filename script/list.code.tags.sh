#/bin/sh

mode=${1:-"code"}

path=${MD_CODE_BASE:-"${HOME}/code"}
path=${path/#~/$HOME}

outPutDir=${HOME}/.vim/caches/code.ctags

if [ "${mode}" == "cur" ];then
	path="`pwd`"
    # outPutDir=${HOME}/.vim/caches/cur.ctags
    outPutDir=.
fi

running=`ps ux|grep "ctags .* ${path}\$"`

if [ "$running" != "" ];then
    exit
fi

if [ -e "$path/tags" ];then
	rm $path/tags
fi

if [ -e "${outPutDir}/tags" ];then
	rm ${outPutDir}/tags
fi

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q ${path}

if [ $outPutDir != "." ];then
    mkdir -p $outPutDir
    mv tags $outPutDir/tags
fi

