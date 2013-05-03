#
rm ${HOME}/.vim/caches/cscope.files
find ${HOME}/code/gui_tflex/ -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' > ${HOME}/.vim/caches/cscope.files
