#
rm ~/.vim/caches/cscope.files
find ~/code/gui_tflex/ -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' > ~/.vim/caches/cscope.files
