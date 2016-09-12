set nocompatible
filetype off
filetype plugin indent on

let install_bundle=1
let vundle_readmd=expand("~/.vim.bundle/vundle/README.md")
if !filereadable(vundle_readmd)
    echo "Installing vundle"
    echo ""
    " let $GIT_SSL_NO_VERIFY = 'true'
    silent! execute "!mkdir -p ~/.vim.bundle/"
    silent! execute "!git clone https://github.com/gmarik/vundle.git ~/.vim.bundle/vundle"
    let install_bundle=0
endif

set rtp+=~/.vim.bundle/vundle/
call vundle#rc("~/.vim.bundle")

if install_bundle == 0
    echo "Installing bundles, please ignore errors"
    echo ""
    exe "BundleInstall"
endif

Bundle 'gmarik/vundle'

"personal plugin

Bundle 'Solarized'
Bundle 'bufexplorer.zip'
Bundle 'VimExplorer'
Bundle 'AutoComplPop'
Bundle 'genutils'
Bundle 'OmniCppComplete'
Bundle 'The-NERD-Commenter'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kmalloc/a.vim'
Bundle 'kmalloc/Syntastic'
Bundle 'kmalloc/mru.vim'
Bundle 'kmalloc/conque'
Bundle 'kmalloc/taglist.vim'
Bundle 'kmalloc/echofunc.vim'
Bundle 'kmalloc/simple_bookmarks.vim'
Bundle 'kmalloc/gtags.vim'
Bundle 'kmalloc/lookupfile'

filetype on

if install_bundle == 0
    echo "Installing font:"
    silent! execute "!mkdir -p ~/.fonts/"
    silent! execute "!cp ~/.vim/fonts/* ~/.fonts/"
endif
