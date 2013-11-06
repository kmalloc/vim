"author               : miliao.
"vim version required : vim 7.0 and above.
"other requirment     : compile vim with option: --enable-cscope, --enable-pythoninterp, --with-features=huge
"plugin               : LookupFile,TagList,autocomplete(acp.vim),a.vim,NERD_Commenter,
"                       echofunc,bufExplorer,vimExplorer,MRU.
"usage                : to enable cscope&ctags usage, please setup environment variable "MD_CODE_BASE" to specify the code path
"                     : to enable perforce checkout event on file changed, setup "MD_P4_CODE_BASE" env variable
"others               : some shell scripts are put in .vim/


set nocompatible

" must set term before setting alt key binding.
if (!has("gui_running"))
    set term=$TERM
endif

" ------------------------- vim setting -------------------------
set textwidth=0
let mapleader=","

" search
set ignorecase
set incsearch
set hlsearch

" document
set number
set nobackup
set autoread
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gb18030,ucs-bom,gbk,gb2312,cp936
set path+=~/code/*
" set colorcolumn=90 "make column 90th visible
" set list "visible last column of each line, set nolist
" set spell spelllang=en_us

set foldenable
set foldmethod=manual

" share system clipboard
set clipboard=unnamed

" key and mouse
set mouse=a
set winaltkeys=no "disable hot key for the menu in gvim.
set backspace=indent,eol,start "set backspace key

set timeout timeoutlen=250 ttimeoutlen=100

" enable alt key in terminal
" set <M-key>=<Esc>key ,see :h map-alt-keys
if(!has("gui_running"))
    exe "set <M-x>=\<ESC>x"
    exe "set <M-w>=\<ESC>w"
    exe "set <M-o>=\<ESC>o"
    exe "set <M-1>=\<ESC>1"
    exe "set <M-2>=\<ESC>2"
    exe "set <M-d>=\<ESC>d"
    exe "set <M-u>=\<ESC>u"
    exe "set <M-n>=\<ESC>n"
    exe "set <M-p>=\<ESC>p"
endif

set tags=~/.vim/caches/cpp.ctags/tags
set tags+=~/.vim/caches/code.ctags/tags
set tags+=~/.vim/caches/wx.ctags/tags
set tags+=~/.vim/caches/cur.ctags/tags
set tags+=~/.vim/caches/caches/tags

" indention
set ai
set si
set cindent
set smartindent
set autoindent
set ruler
set showmatch
set expandtab "replace tab with space, always.
set tabstop=4
set shiftwidth=4
set ruler

" tab
set switchbuf=usetab  ",newtab

set hidden

filetype plugin on
filetype indent on

" appearance
syntax on
set t_Co=256

" source bundle setting
source $HOME/.vim/.bundle.vimrc

if (has("gui_running"))
    set background=dark

    set guifont=MiscFixed\ 18
    set guioptions-=m "hide menu bar.
    set guioptions-=T "hide tool bar.

    " disable scrollbar
    set guioptions-=l
    set guioptions-=r
    set guioptions-=L
    set guioptions-=R

    " colorscheme DimGreen "solarized
    colorscheme solarized
else
    colorscheme torte
    " colorscheme allan
endif

set cursorline "highlight current line
set laststatus=2 "always show status line
set completeopt-=preview "remove preview window for autocompletion

" context menu
highlight Pmenu guibg=darkblue ctermbg=blue
highlight PmenuSel guibg=brown ctermbg=darkgreen

highlight cursorline term=bold ctermfg=brown gui=bold guibg=bg "guifg=browse

hi User1 guifg=#eea040 guibg=#222222 ctermfg=darkred    ctermbg=darkblue
hi User2 guifg=#dd3333 guibg=#222222 ctermfg=cyan       ctermbg=darkblue
hi User3 guifg=#ff66ff guibg=#222222 ctermfg=darkgreen  ctermbg=darkblue
hi User4 guifg=#a0ee40 guibg=#222222 ctermfg=darkyellow ctermbg=darkblue
hi User5 guifg=#eeee40 guibg=#222222 ctermfg=cyan       ctermbg=darkblue

set statusline =%3*[%F]              "full path of current file
set statusline +=%1*%r               "readonly flag
set statusline +=%4*[%v]             "virtual column number
set statusline +=%5*%m               "modified flag
" set statusline +=%2*%L              "total lines
" set statusline +=%1*%n              "buffer number
" set statusline +=%5*%{&ff}          "file format



" ------------------------ plugin setting --------------------------------------

" ConqueTerm setting
let g:ConqueTerm_Color=1

" taglist.vim setting
let g:Tlist_Inc_Winwidth=1
let g:Tlist_Show_One_File=1
let g:Tlist_Exit_OnlyWindow=1
let g:Tlist_File_Fold_Auto_Close=1
let g:Tlist_GainFocus_On_ToggleOpen=0
let g:Tlist_Auto_Open=0
let g:Tlist_Auto_Update=1
let g:Tlist_Use_Right_Window=1
let g:Tlist_Display_Tag_Scope = 0
" let Tlist_Display_Prototype=1
" let Tlist_Compact_Format=1

" filelookup setting.
let g:LookupFile_TagExpr = '$HOME."/.vim/caches/filenametags"'
let g:LookupFile_PreserveLastPattern = 0 "do not preserve last search pattern.
let g:LookupFile_PreservePatternHistory = 0 "preserve search history
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles=0
let g:LookupFile_MinPatLength = 3
let g:LookupFile_UsingSpecializedTags = 1
let g:LookupFile_ignorecase=1
" make arrow work normally.
let g:LookupFile_EscCancelsPopup = 0
let g:LookupFile_SearchForBufsInTabs = 1
let g:LookupFile_Bufs_LikeBufCmd = 0
let g:LookupFile_DisableDefaultMap = 1 "I prefer f5 to open terminal window.

" autocomplete setting.
let g:AutoComplPop_CompleteoptPreview = 1


" OmniCppCompletion
let g:OmniCpp_NamespaceSearch = 2
let g:OmniCpp_ShowPrototypeInAbbr = 1
let g:OmniCpp_MayCompleteScope = 0

" MRU setting
" no help doc is provided.
let g:MRU_Max_Entries=1024
let g:MRU_Use_Current_Window=0
let g:MRU_Auto_Close = 0 "do not close on selecting file.
let g:MRU_Add_Menu = 0 "disable gui menu setting.
let MRU_Open_File_Use_Tabs = 0 "1
let g:bufExplorerSortBy='name'       " Sort by the buffer's name.

" let g:vbookmark_bookmarkSaveFile=$HOME.'/.vimbookmark'

let g:simple_bookmarks_signs = 1
let g:simple_bookmarks_new_tab = 0
let g:simple_bookmarks_auto_close = 0

" a.vim setting: search path.
let g:alternateSearchPath = 'sfr:./src,sfr:../,sfr:../include,sfr:../src'


" echofunc.vim setting.
" if the following is set to 1.
" information will not shown on status line.
let g:EchoFuncShowOnStatus=0
let g:EchoFuncAutoStartBalloonDeclaration=0 "disable ballon declaration
let g:EchoFunc_AutoTrigger = 0
let g:EchoFuncKeyPrev='<M-p>'
let g:EchoFuncKeyNext='<M-n>'
" need to find an appropriate mapping,
" otherwhise default mapping will not work in terminal.
" let g:EchoFuncKeyNext='<C-->'
" let g:EchoFuncKeyNext='<C-=>'

" gtags-cscope
let g:GtagsCscope_Ignore_Case = 1
let g:GtagsCscope_Absolute_Path = 1

" put a space after comment sign
let g:NERDSpaceDelims = 1

" Syntastic Check setting.
let g:syntastic_check_on_wq=0
let g:syntastic_enable_balloons = 1
" let g:syntastic_auto_loc_list=2
" let g:syntastic_always_populate_loc_list=1
"
" ------------------------- end plugin settings -----------------------



" --------------------------------------------- global variable -----------------------------------------------

if !exists("g:IsVimInitialized")
    let g:IsVimInitialized = 0
endif

" initialize global variables when vim is launched.
if (!g:IsVimInitialized)

    if !exists("g:IsHistoryWinOpened")
        let g:IsHistoryWinOpened = 0
    endif

    if !exists("g:IsQuickfixOpen")
        let g:IsQuickfixOpen = 0
    endif

    let g:p4_code_base = $MD_P4_CODE_BASE
    let g:BufExplorerName = '\[BufExplorer\]' "use single quote, regex
    let g:MruBufferName = "__MRU_Files__"
    let g:TaglistName = "__Tag_List__"
    let g:TerminalName = "bash - "

    " setting AutoOpenTlist to 1, then each time open a c/c++ file,
    " taglist will popout to the right automatically.
    let g:AutoOpenTlist = 0

    " indicate whether perforce exists
    let g:PerforceExisted = 0

    " rule of thumb: try to avoid hard-coded path for code base in vimrc.
    " instead, put all code base relative path in shell script.

    " set support_p4_edit_event to checkout file if file is changed.
    let g:support_p4_edit_event = 1

    if g:support_p4_edit_event
        let g:files_checkout = {} "files that have been checkout by p4
    endif

    let g:files_syntastic= {} "files that are currently runing syntastic check

    if !exists("g:files_hidden")
        let g:files_hidden = {}
    endif

    " using gtags by default if gtags has installed in folder: ~/tools/gtags
    let g:UseGlobalOverCscope = 0
    let g:IgnoreGtags = 1 "value '1' to disable using gtags.

    " cache file for gtags or for cscope
    let g:mycodetags = $HOME."/.vim/caches/cscope.out"

    let g:WorkingInCurrDir = 0

    let g:gtagsCscopePath = system("which gtags-cscope")
    let g:gtagsCscopePath = substitute(g:gtagsCscopePath,'\n$','','') "remove \n from the end
    let g:CscopePath = system("which cscope")
    let g:CscopePath = substitute(g:CscopePath,'\n$','','')
    " $HOME."/tools/gtags/bin/gtags-cscope"

endif


" ----------------------autocmd------------------------------------

augroup MD_EventHandler

    autocmd! MD_EventHandler

    " rule of thumb: evaluate <afile> <abuf> both inside function or both in parameter.
    " keep them consistent, and better use just one.

    autocmd BufWinEnter *.cpp,*.cc,*.c,*.h,*.hpp,*.cxx call TlistOnBufferWinEnter(expand("<afile>"))
    autocmd WinEnter * call OnWinEnter()

    " invoke code-changed event: for p4 to checkout file
    autocmd BufWritePost */*.cpp,*/*.cc,*/*.c,*/*.cxx,*/*.h,*/*.hpp,*/*.sh,*/*.pl,*/*.mk,*/*.py call OnBufWrite(expand("<afile>"))

    autocmd BufHidden * call OnBufHidden(str2nr(expand("<abuf>")))
    autocmd BufWinLeave * call OnBufLeaveWin(str2nr(expand("<abuf>")))

    autocmd BufWritePost ~/.vimrc,~/.vim/*.vimrc so ~/.vimrc
    autocmd BufWritePost */code/*.cpp,*/code/*.cxx,*/code/*.cc,*/code/*.c,*/code/*.h call UpdateGtags()
    autocmd TabEnter * call OnTabEnter()
    autocmd BufEnter * call HandleTerminWin(expand("<afile>"))

    autocmd VimEnter *.cc,*.h,*.cpp,*.c,*.hpp,*.cxx call AutoOpenTaglistOnVimStartup()
    autocmd VimEnter * call SetupVim()

augroup end


source $HOME/.vim/.func.vimrc


" ----------------------------- key mapping ---------------------------------------------

" edit my vimrc
map <leader>ev  :call EditMyVimrc()<CR>

map <F9> :so ~/.vimrc<CR>
map <F9><F9> :let g:IsVimInitialized = 0<CR> :so ~/.vimrc<CR> :call SetupVim()<CR>

map <F6> :call ToggleQuickfix()<CR>
map <F3> :call ToggleBufferExp(expand("<cfile>"))<CR>

" toggle gvim tool bar.
if (has("gui_running"))
    map <M-m> :call ToggleToolsBar()<CR>
endif

" generate file names list
" this will replace the previous TagExpr setting.
map <F10> :call RefreshCodeTags()<CR>
map <F11> :call SetupCurFolderData("scan")<CR>
map <F11><F11> :call SwitchToCodeBase()<CR>
map <S-F11> :call List_lookup_file_for_cur_folder("scan")<CR>
map <F12> :call RefreshCodeData()<CR>

" use gtags, or cscope to find reference. note, gtags does not support perl for the moment.
map <F8>  :call ToggleGtags()<CR>

" open terminal to a new tab, if terminal already open, switch to it.
map <F5>  :call ShowTerminal("tab")<CR>

" open termial to a vertical split window within current tab.
map <F5><F5>  :call ShowTerminal("win")<CR>

map <F1>  :call ShowTerminal("tab")<CR>
map <F1><F1>  :call ShowTerminal("win")<CR>

" tab key mapping
map <C-t> :tabnew<CR>
map <M-x> :tabclose<CR>
map <M-w> :call CloseCurrentWin()<CR>
map <M-d> <C-d>
map <M-u> <C-u>

map <M-1> :tabp<CR>
map <M-2> :tabn<CR>
map <C-j> :tabp<CR>
map <C-k> :tabn<CR>
" tabm +1 tabm -1

map <M-o> :tabnew %<CR> :A<CR>

" toggle header/cpp file
map <C-h> :A<CR>

map <F2>  :call ToggleHistoryWin()<CR>
" map <F3>  :AS<CR>

" select all
map <C-A> ggVG

" window operation
map <S-TAB> <C-W>w
map <S-TAB-TAB> <C-W>p

" resize current window
nmap <silent> <C-Left>    <C-W><:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Right>   <C-W>>:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Up>      <C-W>+:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Down>    <C-W>-:unlet! t:flwwinlayout<CR>

" taglist
map <leader>tl :Tlist<CR>
map <F4> :Tlist<CR>

" file explorer
map <leader>ve :Ve<CR>

" look up file
map <leader>lf :LookupFile<CR>

" using cscope to find text reference.
map <F7> :call FindReference()<CR>

" checkout file using p4.
if g:support_p4_edit_event
    map <leader>co   :!p4 edit %<CR>
    map <leader>add  :!p4 add %<CR>
endif

" save session
map <leader>ss :mksession! ~/session/vs<CR>
map <leader>sos :so ~/session/vs<CR>

" bookmark setting
map mm :call BookMarkHere()<CR>
map mc :call OpenBookMark()<CR>
map md :call DelBookMark()<CR>


" syntastic check.
map <leader>sc :call ToggleSyntasticCheck()<CR>
map <leader>scu :SyntasticReset<CR>


" ------cscope key mapping------------------------------------------

" find reference
map <leader>fr :call CscopeFind(expand("<cword>"),"s")<CR>

" find definition
map <leader>fd :call CscopeFind(expand("<cword>"),"g")<CR>

" find caller
map <leader>fc :call CscopeFind(expand("<cword>"),"c")<CR>

" find what you specify,find text
map <leader>ft :call CscopeFind(expand("<cword>"),"t")<CR>

" find this egrep pattern
map <leader>fe :call CscopeFind(expand("<cword>"),"e")<CR>

" find file
map <leader>ff :call CscopeFind(expand("<cfile>"),"f")<CR>

" find files that include this file
map <leader>fi :call CscopeFind(expand("<cfile>"),"i")<CR>

" map <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:call OpenCscopeSearchList()<CR>

