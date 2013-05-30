"author               : miliao.
"vim version required : vim 7.0 and above.
"other requirment     : compile vim with option: --enable-cscope.
"plugin               : LookupFile,TagList,autocomplete(acp.vim),a.vim,NERD_Commenter,
"                       echofunc,bufExplorer,vimExplorer,MRU.



set textwidth=0
let mapleader=","
set number

"search 
set hlsearch
"set nohlsearch
set ignorecase
set incsearch

"document
set nocompatible
set nobackup
set autoread
set encoding=utf-8

set foldenable
set foldmethod=manual

"share system clipboard
set clipboard=unnamed

"key and mouse
set mouse=a
set winaltkeys=no "disable hot key for the menu in gvim.
set backspace=indent,eol,start

set timeout timeoutlen=350 ttimeoutlen=100

"enable alt key in terminal
"set <M-key>=<Esc>key
"see :h map-alt-keys
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
    exe "set <M-c>=\<ESC>c"
endif

let cpptags=$HOME."/.vim/cpp.tags/tags"
set tags=~/.vim/cpp.tags/tags
set tags+=~/.vim/gui.tags/tags
set tags+=~/.vim/wx.tags/tags
set tags+=~/.vim/cur.tags/tags
set tags+=~/.vim/caches/tags

"indention
set ai
set si
set cindent
set smartindent
set autoindent
set ruler
set nocp
set showmatch
set expandtab "replace tab with space, always.
set tabstop=4
set shiftwidth=4
set ruler

"tab
set switchbuf=usetab  ",newtab
set hidden

filetype plugin on
filetype indent on


"appearance
syntax on
set t_Co=256
set guifont=Courier\ 10\ Pitch\ 16
"set background=light

if (has("gui_running"))
    set background=dark
    colorscheme  solarized "deveiate 

    set guioptions-=m "hide menu bar.
    set guioptions-=T "hide tool bar.
else
    colorscheme torte
endif

"pacific
"molokai
"torte

set completeopt-=preview "remove preview window for autocompletio
"set statusline+=%{EchoFuncGetStatusLine()}

"context menu
highlight Pmenu guibg=darkblue ctermbg=blue
highlight PmenuSel guibg=brown ctermbg=darkgreen


"-------------key mapping-------------------------------
"a better way to replace esc
"noremap ;; <ESC>

"edit my vimrc
map <leader>ev :call EditMyVimrc()<CR>
map <F9> :so ~/.vimrc<CR>
map <F6> :call ToggleQuickfix()<CR> 
map <F3> :call ToggleBufferExp(expand("<cfile>"))<CR>

"toggle gvim tool bar.
map <M-m> :call ToggleToolsBar()<CR> 

"generate file names list
"this will replace the previous TagExpr setting.
map <F10> :call RefreshCodeTags()<CR>
map <F11> :call SetupCurFolderData("scan")<CR>
map <S-F11> :call List_lookup_file_for_cur_folder()<CR>
"List_lookup_file_for_cur_folder()<CR>
map <F12> :call RefreshGuiCodeData()<CR> 
"RefreshCscopeDataForGuiCode()<CR>
map <F8>  :call ToggleGtags()<CR>


"tab key mapping
map <C-t> :tabnew<CR>
map <M-x> :tabclose<CR>
map <M-w> :x<CR>
map <M-d> <C-d>
map <M-u> <C-u>

map <M-1> :tabp<CR>
map <M-2> :tabn<CR>
map <C-j> :tabp<CR>
map <C-k> :tabn<CR>

map <M-o> :tabnew %<CR> :A<CR>
map <C-h> :A<CR>

map <F2>  :call ToggleHistoryWin()<CR>
"map <F3>  :AS<CR>

map <C-A> ggVG

"window operation 
map <S-TAB> <C-W>w
map <S-TAB-TAB> <C-W>p

nmap <silent> <C-Left>    <C-W><:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Right>   <C-W>>:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Up>      <C-W>+:unlet! t:flwwinlayout<CR>
nmap <silent> <C-Down>    <C-W>-:unlet! t:flwwinlayout<CR>

"taglist
map <leader>tl :Tlist<CR>  
map <F4> :Tlist<CR>  

"file explorer
map <leader>ve :Ve<CR><CR>
map <leader>fe :tabnew<CR>:Ve <CR><C-W><C-W>:x<CR> 

"look up file
map <leader>lf :LookupFile<CR>

"using cscope to find text reference.
map <F7> :call FindReference()<CR>

"checkout file using p4.
map <leader>co   :!p4 edit %<CR>
map <leader>add  :!p4 add %<CR>


map <leader>sstf :mksession! ~/session/tflex<CR>
map <leader>ss :mksession! ~/session/<CR>
map <leader>sotf :so ~/session/tflex<CR>
map <leader>sos :so ~/session/<CR>


"bookmark setting

map mm :call BookMarkHere()<CR>
map mc :call OpenBookMark()<CR>
map md :call DelBookMark()<CR>



"map <C-c-t> :call OpenShellBuffer()<CR>
"------cscope key mapping.

"find reference 
map <leader>fr :call CscopeFind(expand("<cword>"),"s")<CR>

"find definition
map <leader>fd :call CscopeFind(expand("<cword>"),"g")<CR> 

"find caller
map <leader>fc :call CscopeFind(expand("<cword>"),"c")<CR>

"find what you specify,find text
map <leader>ft :call CscopeFind(expand("<cword>"),"t")<CR>

"find this egrep pattern
map <leader>fe :call CscopeFind(expand("<cword>"),"e")<CR>

"find file
map <leader>ff :call CscopeFind(expand("<cfile>"),"f")<CR>

"find files that include this file
map <leader>fi :call CscopeFind(expand("<cfile>"),"i")<CR>

"map <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:call OpenCscopeSearchList()<CR>



"------------------------plugin setting--------------------------------------



"taglist.vim setting
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Auto_Open=0
let Tlist_Auto_Update=1
let Tlist_Use_Right_Window=1
"let Tlist_Highlight_Tag_On_BufEnter = 0



"filelookup setting.
let g:LookupFile_TagExpr = '$HOME."/.vim/caches/filenametags"'
let g:LookupFile_PreserveLastPattern = 0 "do not preserve last search pattern.
let g:LookupFile_PreservePatternHistory = 0 "preserve search history
let g:LookupFile_AlwaysAcceptFirst = 0
let g:LookupFile_AllowNewFiles=0
let g:LookupFile_MinPatLength = 3
let g:LookupFile_UsingSpecializedTags = 1 
let g:LookupFile_ignorecase=1
"make arrow work normally.
let g:LookupFile_EscCancelsPopup = 0
let g:LookupFile_SearchForBufsInTabs = 1
let g:LookupFile_Bufs_LikeBufCmd = 0 


"autocomplete setting.
let g:AutoComplPop_CompleteoptPreview = 1


"OmniCppCompletion
let g:OmniCpp_NamespaceSearch = 2 
let g:OmniCpp_ShowPrototypeInAbbr = 1 
let g:OmniCpp_MayCompleteScope = 0 

"MRU setting
"no help doc is provided.
let g:MRU_Max_Entries=1024
let g:MRU_Use_Current_Window = 0 "
let g:MRU_Auto_Close = 0 "do not close on selecting file.
let g:MRU_Add_Menu = 0 "disable gui menu setting.
let g:MRU_Open_File_Use_Tabs = 1
let g:bufExplorerSortBy='name'       " Sort by the buffer's name.

"let g:vbookmark_bookmarkSaveFile=$HOME.'/.vimbookmark'

let g:simple_bookmarks_signs = 1
let g:simple_bookmarks_new_tab = 1 
let g:simple_bookmarks_auto_close = 0 

"a.vim setting: search path.
let g:alternateSearchPath = 'sfr:./src,sfr:../,sfr:../include,sfr:../src'


"echofunc.vim setting.
"if the following is set to 1.
"information will not shown on status line.
let g:EchoFuncShowOnStatus=0
let g:EchoFuncAutoStartBalloonDeclaration=0 "disable ballon declaration 
let g:EchoFunc_AutoTrigger = 0
let g:EchoFuncKeyPrev='<M-p>'
let g:EchoFuncKeyNext='<M-n>'
"need to find an appropriate mapping,
"otherwhise default mapping will not work in terminal.
"let g:EchoFuncKeyNext='<C-->'
"let g:EchoFuncKeyNext='<C-=>'

"gtags-cscope
let g:GtagsCscope_Ignore_Case = 1
let g:GtagsCscope_Absolute_Path = 1

"----------------------global variable---------------------------
let s:IsInitialized = 0 

if (!s:IsInitialized)

    let g:IsQuickfixOpen = 0
    let g:PerforceExisted = 0
    let g:MruBufferName = "__MRU_Files__"
    let g:TaglistName = "__Tag_List__"
    let g:IsHistoryWinOpened = 0

    "using gtags by default if gtags has installed in folder: ~/tools/gtags 
    let g:UseGlobalOverCscope = 0
    let g:IgnoreGtags = 0 "value '1' to disable using gtags.
    let g:mycodetags = $HOME."/.vim/caches/cscope.out"

    let g:WorkingInCurrDir = 0
    let g:mycoderoot=$HOME."/code/" 

    let g:gtagsCscopePath = system("which gtags-cscope")
    let g:gtagsCscopePath = substitute(g:gtagsCscopePath,'\n$','','') "remove \n from the end
    let g:CscopePath = system("which cscope")
    let g:CscopePath = substitute(g:CscopePath,'\n$','','')
    "$HOME."/tools/gtags/bin/gtags-cscope"

endif

"----------------------autocmd------------------------------------
augroup AutoEventHandler
    autocmd!
    autocmd BufWinEnter *.cpp,*.cc,*.c,*.h,*.hpp,*.cxx,*.vimrc call OnBufEnter()
    autocmd BufWinEnter * call OnBufferWinEnter()
    autocmd BufWritePost */code/gui_tflex/*.cpp,*/code/gui_tflex/*.cc,*/code/gui_tflex/*.c,*/code/gui_tflex/*.cxx,*/code/gui_tflex/*.h,*/code/gui_tflex/*.hpp,*/code/gui_tflex/*.sh,*/code/gui_tflex/*.mk call OnBufWrite(expand("<afile>"))
    autocmd BufWritePost ~/.vimrc so ~/.vimrc
    autocmd BufWritePost */code/*.cpp,*/code/*.cc,*/code/*.c,*/code/*.h call UpdateGtags()
    autocmd TabEnter * call OnTabEnter()

    "note: this event will not trigger for those buffers that is displayed in
    "multiple windows.
    autocmd BufWinLeave * call CloseWin(expand("<afile>"))

    autocmd VimEnter *.cc,*.h,*.cpp,*.c,*.hpp,*.cxx call AutoOpenTaglistOnVimStartup() 
    autocmd VimEnter * call SetupVim()

augroup end
"---------------------function ------------------------------------

"-----------------autocmd handler---------------

function! SetupVim()

    let s:IsInitialized = 1 
    silent! execute "call IsP4Exist()"

    if filereadable("filenametags")
        silent! execute "call SetupCurFolderData(\"skip\")"
    else
        silent! execute "call SetupCscope()"
    endif

    redraw!

endfunction

function! AutoOpenTaglistOnVimStartup()

    if &diff == 0
        TlistOpen
    endif

endfunction


function! OnBufWrite(file)

    if (g:PerforceExisted == 0)
        if( $USER == "miliao" )
            echoerr "p4 command not available."
        endif
        
        return
    else

        call P4CheckOut(a:file)

    endif

    "silent! execute("! cp ".a:file." change.cc")
endfunction


function! OnBufEnter()

    if bufwinnr(g:TaglistName) == -1 && &diff == 0
        let l:win = winnr()
        silent! execute "normal:"
        silent! execute "TlistOpen"
        silent! execute l:win."wincmd w"
    endif

endfunction


function! OnBufferWinEnter()

    "exit when there is only mru window.
    "not finish yet.
    if(winnr("$") == 1 && bufwinnr(g:MruBufferName) != -1)
        quit
    endif

    call OpenHistoryIfNecessary()

endfunction


function! OnTabEnter()


    if g:IsQuickfixOpen == 1
        let l:win = winnr()
        silent! execute "bo copen"
        silent! execute l:win."wincmd w"
    else
        silent! execute "cclose"
    endif

    call OpenHistoryIfNecessary()

endfunction

function! UpdateGtags()
    silent! execute "! ~/.vim/gtags.setup.sh update &"
    call CsAddTags(g:mycodetags) 
    redraw!
endfunction

"----------------end autocmd handler------------------


"----------------handle shell cmd---------------------- 
function! IsShellCmdExist(cmd)

    silent! execute "! which ".a:cmd." > /dev/null 2>&1"
    return !v:shell_error

endfunction

function! IsP4Exist()
    let g:PerforceExisted = IsShellCmdExist("p4") 
endfunction

function! P4CheckOut(file)

    if( filewritable(a:file) == 0)

        silent! execute("! p4 edit ".a:file." > /dev/null 2>&1")

        if v:shell_error
            echo "p4 edit error,please check if you are log in"
        endif

    else
        silent! echom "file writable"
    endif

endfunction

"----------------end handling shell cmd-----------------------



"---------------code writting helper----------------------

function! Refresh_filelookup_data()

    let l:lookupfiles = $HOME."/.vim/caches/filenametags"
    if filereadable(l:lookupfiles)
        delete(l:lookupfiles)
    endif

    silent! execute "!~/.vim/list.all.files&"
    if filereadable(l:lookupfiles)
        execute "let g:LookupFile_TagExpr='\"".l:lookupfiles."\"'"
    endif 

endfunction



"refresh code in folder ~/code/gui_tflex/
"setup caches for lookupFile, cscope.
function! RefreshCscopeDataForGuiCode()
    "let dir = getcwd()

    if !has("cscope")
        return
    endif


    if g:UseGlobalOverCscope == 0

        let l:csFiles=$HOME."/.vim/caches/cscope.files"

        if filereadable(l:csFiles)
            let csfilesdeleted=delete(l:csFiles)
        endif

        let l:csOut=$HOME."/.vim/caches/cscope.out"
        if filereadable(l:csOut)
            delete(l:csOut)
        endif

    else

        let l:csOut=$HOME."/.vim/caches/GTAGS"
        delete(l:csOut)

    endif


    if g:UseGlobalOverCscope == 0

        if !filereadable(l:csFiles)	
            silent! execute "!~/.vim/list.cscope.files.sh& "
        endif

    else

        "silent! execute "! ~/.vim/gtags.setup.sh files&"
        silent! execute "! ~/.vim/gtags.setup.sh setup&"

    endif

    call CsAddTags(l:csOut)

    redraw!

endfunction


function! RefreshGuiCodeData()
    call Refresh_filelookup_data()
    call RefreshCscopeDataForGuiCode()
endfunction

function! RefreshCodeTags()

    let txt=input("refresh code base? otherwise refresh current path.(y/n):")
    if txt == "y"
        execute "! ~/.vim/list.code.tags.sh &"
    else
        execute "!~/.vim/list.code.tags.sh cur &"
    endif

    redraw!

endfunction



"setup files in current folder for LookupFiel, Cscope.
function! List_lookup_file_for_cur_folder(mode)

    let txt="y"

    if a:mode == 'scan' && filereadable("filenametags")
        let txt = input("filenametags existed,rebuild or not ?(y/n)") 
    endif

    if txt == "y"
        execute "! ~/.vim/list.all.files \"cur\""
    endif

    execute "let g:LookupFile_TagExpr='\"filenametags\"'"


endfunction


function! SetupCscopeForCurFolder(mode)

    if !has("cscope")
        return
    endif

    let l:tags = "cscope.out"

    if a:mode == "scan"

        if g:UseGlobalOverCscope == 0

            silent! execute "!~/.vim/list.cscope.files.sh cur"

        else

            let l:tags = "GTAGS"
            silent! execute "! ~/.vim/gtags.setup.sh cur &"

        endif

    endif

    call CsAddTags(l:tags)

endfunction

function! SetupCurFolderData(mode)

    let l:cur = getcwd()

    if (a:mode == "scan" && g:mycoderoot == l:cur)
        return ''
    endif

    call List_lookup_file_for_cur_folder(a:mode)
    call SetupCscopeForCurFolder(a:mode)
    let g:WorkingInCurrDir = 1
    redraw!

endfunction

function! FindReference()
    let txt = input('enter text:')
    if txt == ""
        return
    endif

    echo "...searching..."

    "silent! execute "tabedit"
    silent! execute "cs find e ".txt
    "call ToggleQuickfix()
endfunction


function! OpenCscopeSearchList()
    if g:IsQuickfixOpen == 0
        call ToggleQuickfix()
    endif
endfunction


function! CscopeFind(file,type)
    silent! execute "cs find ".a:type." ".a:file 
    silent! call OpenCscopeSearchList()
    redraw!
endfunction


function! CsAddTags(tags)
    
    silent! execute "cs kill -1"

    if filereadable(a:tags)

        silent! execute "normal :"

        if g:UseGlobalOverCscope == 0
            silent! execute "cs add ".a:tags
        else
            silent! execute "cs add ".a:tags
            "silent! execute "cs add ".a:tags." -Ca"
        endif

    else
        execute "echoerr \"can not find cscope.out, f11 or f12 please\""
    endif

endfunction

"setup cscope database.
function! SetupCscope()

    if(!has('cscope'))
        return
    endif

    if  g:IgnoreGtags == 0 && filereadable(g:gtagsCscopePath)

        set csprg=gtags-cscope
        let g:UseGlobalOverCscope = 1
        let g:mycoderoot=$HOME."/code/" 

        if $USER == "miliao"
            let g:mycoderoot = g:mycoderoot."gui_tflex"
        endif

        let g:mycodetags = $HOME."/.vim/caches/GTAGS"
        "silent! execute "cd ".g:mycoderoot  
        silent! execute "! ~/.vim/gtags.setup.sh env"
  
    elseif filereadable(g:CscopePath)

        let g:UseGlobalOverCscope = 0 
        set cscopetag

        set csprg=cscope
    endif

    call CsAddTags(g:mycodetags)
    set cscopequickfix=c-,d-,e-,g-,i-,s-,t-
    redraw!

endfunction


function! ToggleGtags()
    
    if g:WorkingInCurrDir == 0
        let g:mycodetags = $HOME."/.vim/caches"
    else
        let g:mycodetags = "."
    endif

    if g:UseGlobalOverCscope == 1 && filereadable(g:CscopePath)
        
        let g:UseGlobalOverCscope = 0
        set csprg=cscope 
        let g:mycodetags = g:mycodetags."/cscope.out"

    elseif g:UseGlobalOverCscope == 0 && filereadable(g:gtagsCscopePath)

        set csprg=gtags-cscope
        let g:UseGlobalOverCscope = 1

        let g:mycodetags = g:mycodetags."/GTAGS"

        if (g:WorkingInCurrDir != 1)
            silent! execute "! ~/.vim/gtags.setup.sh env"
        endif

     endif

    call CsAddTags(g:mycodetags)
    redraw!

endfunction

  "---------------end code writing helper.------------------------

  "---------------UI setup --------------------------------------
function! ToggleToolsBar()

    if(has("gui_running"))
        if &guioptions =~# 'T'
            execute"set guioptions-=T"
            execute"set guioptions-=m"
        else
            execute"set guioptions+=T"
            execute"set guioptions+=m"
        endif
    endif

endfunction

function! BookMarkHere()
    let txt = input("bookmark name:")
    if txt == ""
        return
    endif

    silent! execute "Bookmark ".txt

endfunction


function! DelBookMark()

    let txt = input("bookmark to be deleted:")
    if(txt == "")
        return
    endif

    silent! execute "DelBookmark ".txt

endfunction


function! ToggleBufferExp(file)

    silent! execute "TlistClose"
    silent! execute "BufExplorer"

endfunction

function! ToggleQuickfix()

    if g:IsQuickfixOpen == 0 
        let l:win = winnr()
        silent! execute "bo copen"
        silent! execute l:win."wincmd w"
        let g:IsQuickfixOpen = 1
    else
        silent! execute "cclose"
        let g:IsQuickfixOpen = 0 
    endif

endfunction


function! OpenBookMark()
    let l:win = winnr()
    silent execute "CopenBookmarks"
    silent! execute l:win."wincmd w"
    let g:IsQuickfixOpen = 1
endfunction

"mru does not use quickfix to display history.
function! OpenHistory()

    let g:IsHistoryWinOpened = 1
    let l:win = winnr()
    execute "MRU"
    silent! execute l:win."wincmd w"

endfunction

"still have bugs,should enable auto close mru.
function! OpenHistoryIfNecessary()
    "let l:mruwinnr = bufnr(g:MruBufferName)
    if g:IsHistoryWinOpened == 1

        call OpenHistory()

    else

        call CloseHistoryBuffer()

    endif

endfunction

function! ToggleHistoryWin()

    let l:mruwinnr = bufwinnr(g:MruBufferName)
    if l:mruwinnr != -1
        let g:IsHistoryWinOpened = 0
        execute l:mruwinnr."wincmd w"
        execute "q"
    else
        call OpenHistory()
    endif

endfunction


function! CloseHistoryBuffer()

    let g:IsHistoryWinOpened = 0
    let l:mruwinnr = bufnr(g:MruBufferName)
    if l:mruwinnr != -1
        silent! execute "bd! ".l:mruwinnr
    endif

endfunction

function! CloseWin(buffer)

    if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" )
        let g:IsQuickfixOpen = 0
    endif

    "in BufWinLeave event , bufname("%") may not be the buffer being unloaded.
    "use <afile> instead.
    if a:buffer == g:MruBufferName
        call CloseHistoryBuffer()
    elseif (strpart(a:buffer,0,6) == "bash-")
        silent! execute "bw ".a:buffer
    endif

endfunction

function! EditMyVimrc()

    let l:buflist = tabpagebuflist() "[]
    let l:len = len(l:buflist)
    let l:new = 0
    if len(l:buflist) > 1 
        let l:new = 1
    elseif l:len == 1
        let l:name = bufname(winbufnr(0))
        if strlen(l:name) == 0
            let l:new = 0
        else
            let l:new = 1
        endif
    else
        let l:new = 0
    endif

    if l:new == 1
        execute "tabedit $MYVIMRC"
    else
        execute "edit $MYVIMRC"
    endif

endfunction


function! OpenShellBuffer()
    
    silent! execute "TlistClose"
    silent! execute "ConqueTermVSplit bash"

endfunction


