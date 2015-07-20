#/bin/sh

cppOutDir=${HOME}/.vim/caches/cpp.ctags
if [ -e ${cppOutDir}/tags ];then
	rm ${cppOutDir}/tags
fi

wxOutDir=${HOME}/.vim/caches/wx.ctags
if [ -e ${wxOutDir}/tags ];then
	rm ${wxOutDir}/tags
fi

function call_ctags
{
    outloc=${1?"output path is not specified."}
    codeloc=${2?"code path is not specified."}

    running=`ps ux|grep "ctags .* ${codeloc}\$"`

    if [ "$running" != "" ];then
        exit
    fi

    if [ ! -e $outloc ];then
        mkdir -p $outloc
    fi

    tag_file=$outloc/tags
    ctags -R --c++-kinds=+p --language-force=c++ --fields=+iaS --extra=+q -f $tag_file $codeloc
}

path="/usr/include/"
call_ctags $cppOutDir $path

if [ $MD_WX_SOURCE_PATH ];then
    # wxPath=/usr/local/brion/wxWidgets/2.8.9/include
    wxPath=${MD_WX_SOURCE_PATH/#~/$HOME}
    call_ctags $wxOutDir $wxPath
else
	echo "wx code is not specified, no tags is generated for it.\n"
fi

