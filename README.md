vim
===

usage:

1. install

   git clone http://github.com/kmalloc/vim.git

2. make sure your vim is compiled to support: cscope, python.

   if not, compile it with the following option: configure --enable-cscope --enable-pythoninterp --with-features=huge

3. setup environment variable.

   set up MD_CODE_BASE to the root of your project. this is for cscope to create file index.

4. lauch vim!

   for the very first time, vim will try to install vundle. make sure you have installed git and have access to the internet.

5. press F12 to refresh all cached data(cscope, omni completion etc)

key mappings:

01. f1/f5 -> toggle terminal win. press twice f1/f5 open terminal win within current tab.
02. f2 -> toggle history window.
03. f3 -> toggle bufexplorer win.
04. f4 -> toggle taglist window.
05. f6 -> toggle cscope window.
06. f7 -> text searching using cscope.
06. f8 -> toggle gtags usage.
07. f9 -> source .vimrc, press twice invoke "deep" flush of internal settings.
08. f10 -> refresh ctags data.
09. f11 -> use cscope for current directory. <f11><f11> turn back to global cscope settings.
10. f12 -> refresh cscope data


to be continue....

