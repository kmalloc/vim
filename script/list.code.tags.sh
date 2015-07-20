#/bin/sh

mode=${1:-"code"}

path=${MD_CODE_BASE:-"${HOME}/code"}
path=${path/#~/$HOME}

tmp_loc=${HOME}/.vim/caches
outPutDir=${HOME}/.vim/caches/code.ctags

if [ "${mode}" == "cur" ];then
	path="`pwd`"
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

if [ ! -e "${tmp_loc}" ];then
    mkdir -p $tmp_loc
fi

tmp_loc=$tmp_loc/t_ctags

if [ -e "${tmp_loc}" ];then
    rm ${tmp_loc}
fi

ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q -f $tmp_loc ${path}

if [ $outPutDir != "." ];then
    mkdir -p $outPutDir
fi

mv $tmp_loc $outPutDir/tags

cpp_tag="$HOME/.vim/caches/cpp.ctags/tags"
if [ ! -e $cpp_tag ];then
    `$HOME/.vim/script/list.ctags.cpp.wx.sh`
fi

