"author               : miliao.
"vim version required : vim 7.0 and above.
"other requirment     : compile vim with option: --enable-cscope.
"plugin               : LookupFile,TagList,autocomplete(acp.vim),a.vim,NERD_Commenter,
"                       echofunc,bufExplorer,vimExplorer,MRU.

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

"enable alt key in terminal
"set <M-key>=<Esc>key
"see :h map-alt-keys
if(!has("gui_running"))
	exe "set <M-x>=\<ESC>x"
	exe "set <M-w>=\<ESC>w"
	exe "set <M-o>=\<ESC>o"
	exe "set <M-1>=\<ESC>1"
	exe "set <M-2>=\<ESC>2"
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
set tabstop=4
set shiftwidth=4
set ruler

"tab
set switchbuf=usetab,newtab
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
else
	colorscheme  torte
endif

"pacific
"molokai
"torte
"darkburn

set guioptions-=m "hide menu bar.
set guioptions-=T "hide tool bar.
set completeopt-=preview "remove preview window for autocompletio
"set statusline+=%{EchoFuncGetStatusLine()}

"context menu
highlight Pmenu guibg=darkblue ctermbg=darkblue
highlight PmenuSel guibg=brown ctermbg=brown


"setup cscope database.
if(has('cscope'))
	if filereadable($HOME."/.vim/caches/cscope.out")
		silent! execute "normal :"
		silent! execute "cs add ".$HOME."/.vim/caches/cscope.out"
	else
		echo "can not find cscope.out,f12 please"
	endif

	set cscopequickfix=c-,d-,e-,g-,i-,s-,t-
endif

"-------------key mapping-------------------------------
"a better way to replace esc
inoremap ,,  <ESC>
inoremap ;;  <ESC>
 

"edit my vimrc
map <leader>ev :tabedit $MYVIMRC<CR>
map <F9> :so ~/.vimrc<CR>
map <F6> :call ToggleQuickfix()<CR> 
map <F3> :call ToggleBufferExp(expand("<cfile>"))<CR>

"toggle gvim tool bar.
map <M-m> :call ToggleToolsBar()<CR> 

"generate file names list
"this will replace the previous TagExpr setting.
map <F10> :call RefreshCodeTags()<CR>
map <F11> :call List_lookup_file()<CR>
map <F12> :call RefreshGuiCodeFiles()<CR>


"tab key mapping
map <C-t> :tabnew<CR>
map <M-x> :tabclose<CR>
map <M-w> :x<CR>

map <M-1> :tabp<CR>
map <M-2> :tabn<CR>
map <C-j> :tabp<CR>
map <C-k> :tabn<CR>

map <M-o> :tabnew %<CR> :A<CR>
map <C-h> :A<CR>

map <F2>  :call ToggleHistoryWin()<CR>
"map <F3>  :AS<CR>

map <C-A> ggVG

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
let Tlist_Auto_Open=1
let Tlist_Auto_Update=1
let Tlist_Use_Right_Window=1



"filelookup setting.
let g:LookupFile_TagExpr = '$HOME."/.vim/caches/filenametags"'
let g:LookupFile_PreserveLastPattern = 0 "do not preserve last search pattern.
let g:LookupFile_PreservePatternHistory = 0 "preserve search history
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles=0
let g:LookupFile_MinPatLength = 3
let g:LookupFile_UsingSpecializedTags = 1 
let g:LookupFile_ignorecase=1
"make arrow work normally.
let g:LookupFile_EscCancelsPopup = 0
"let g:LookupFile_SearchForBufsInTabs = 1
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
"need to find an appropriate mapping,
"otherwhise default mapping will not work in terminal.
"let g:EchoFuncKeyNext='<C-->'
"let g:EchoFuncKeyNext='<C-=>'


"----------------------global variable---------------------------
let g:IsQuickfixOpen = 0
let g:PerforceExisted = 0
let g:MruBufferName = "__MRU_Files__"
"----------------------autocmd------------------------------------
autocmd! BufWinEnter *.cpp,*.cc,*.h,*.hpp,*.vimrc call OnBufEnter()
autocmd! BufWinEnter * call OpenHistoryIfNecessary()
autocmd! BufWritePost *.cpp,*.cc,*.h,*.hpp call OnBufWrite(expand("<afile>"))
autocmd! BufWritePost ~/.vimrc so ~/.vimrc
autocmd! TabEnter * call OnTabEnter()
autocmd! BufWinLeave * call CloseWin()

"---------------------function ------------------------------------

function! OnBufWrite(file)
	if (g:PerforceExisted == 0)
		return
	else
		silent! execute("! p4 edit ".a:file." > /dev/null 2>&1")

		if v:shell_error
			echo "p4 edit error,please check if you are log in"
		endif
	endif

	"silent! execute("! cp ".a:file." change.cc")
endfunction



function! OnBufEnter()

	let l:win = winnr()
	silent! execute "normal:"
	silent! execute "TlistOpen"
	silent! execute l:win."wincmd w"

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

function! IsP4Exist()
	silent! execute "! which p4 > /dev/null 2>&1"
	if !v:shell_error
		let g:PerforceExisted = 1
	else
		let g:PerforceExisted = 0
	endif
endfunction

function! P4CheckOut()
	let f = expand("<cfile>")
	silent! execute("! p4 edit ".f)
endfunction



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


"refresh code in folder ~/code/gui_tflex/
"setup caches for lookupFile, cscope.
function! RefreshGuiCodeFiles()
	"let dir = getcwd()

	if has("cscope")
		silent! execute "cs kill -1"
	endif

	let csFiles = $HOME."/.vim/caches/cscope.files"
	let csOut = $HOME."/.vim/caches/cscope.out"
	let lookupfiles = $HOME."/.vim/caches/filenametags"

	if filereadable(csFiles)
		let csfilesdeleted=delete(csFiles)
	endif

	if filereadable(csOut)
		let csoutdeleted=delete(csOut)
	endif

	if filereadable(lookupfiles)
		let filetagsdeleted=delete(lookupfiles)
	endif

	silent! execute "!~/.vim/list.all.files&"

	if(has('cscope'))
		if filereadable(csFiles)	
		else
			silent! execute "!~/.vim/list.cscope.files.sh "
		endif

	   if filereadable(csOut)
			silent! execute "normal :"
			silent! execute "cs add ".csOut
		endif

	else
		echo "please install cscope first"
	endif


endfunction


function! RefreshCodeTags()

	let txt=input("refresh code base? otherwise refresh current path.(y/n):")
	if txt == "y"
		execute "! ~/.vim/list.code.tags.sh &"
	else
		execute "!~/.vim/list.code.tags.sh cur &"
	endif
	
endfunction



"setup files in current folder for LookupFiel, Cscope.
function! List_lookup_file()

	let txt="y"
	if filereadable("filenametags")
      let txt = input("filenametags existed,rebuild or not ?(y/n)") 
	endif

	if txt == "y"
		execute "! ~/.vim/list.all.files \"cur\""
	endif

	execute "let g:LookupFile_TagExpr='\"filenametags\"'"

	if filereadable("cscope.files")
		let txt="cscope.files existed, rebuild or not?(y/n)")
	endif


	if txt == "y"
		execute "! ~/.vim/list.cscope.files.sh cur"
	endif

	silent! execute "!cscope -C -Rbq -i cscope.files"

	if filereadable("cscope.out")
		silent! execute "normal :"
		silent! execute "cs add cscope.out"
	endif


endfunction



function! FindReference()
	let txt = input('enter text:')
	if txt == ""
		return
	endif

	echo "...searching..."

	silent! execute "tabedit"
	silent! execute "cs find e ".txt
	call ToggleQuickfix()
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
	let l:win = winnr()
	execute "MRU"
	silent! execute l:win."wincmd w"
endfunction

"still have bugs,should enable auto close mru.
function! OpenHistoryIfNecessary()
	let l:mruwinnr = bufnr(g:MruBufferName)
	if l:mruwinnr != -1
		let l:win = winnr()
		call OpenHistory()
		silent! execute l:win."wincmd w"
	endif
endfunction

function! ToggleHistoryWin()

	let l:mruwinnr = bufnr(g:MruBufferName)
	if l:mruwinnr != -1
		execute "bd! ".l:mruwinnr
	else
		call OpenHistory()
	endif
	
endfunction

function! CloseWin()

	if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix" )
		let g:IsQuickfixOpen = 0
	endif


	if bufname("%") == "__MRU_Files__"
		let l:mruwinnr = bufnr(g:MruBufferName)
		if l:mruwinnr != -1
			execute "bd! ".l:mruwinnr
		endif
	endif

endfunction


function! OpenCscopeSearchList()
	if g:IsQuickfixOpen == 0
		call ToggleQuickfix()
	endif
endfunction


function! CscopeFind(file,type)
	silent! execute "cs find ".a:type." ".a:file 
	silent! call OpenCscopeSearchList()
endfunction


"------------------------------call function to setup environment----

call IsP4Exist()
