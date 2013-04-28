"author               : miliao.
"vim version required : vim 7.0 and above.
"other requirment     : compile vim with option: --enable-cscope.
"plugin               : LookupFile,TagList,autocomplete(acp.vim),a.vim,NERD_Commenter,bufExplorer,vimExplorer,MRU.

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

filetype plugin on
filetype indent on


"appearance
syntax on
set t_Co=256
set guifont=Monospace\ 14
set background=light
colorscheme deveiate 
"deveiate
"molokai
"torte
"darkburn


set guioptions-=m "hide menu bar.
set guioptions-=T "hide tool bar.

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

"edit my vimrc
map <leader>ev :tabedit $MYVIMRC<CR>
map <F9> :so ~/.vimrc<CR>
map <F6> :copen<CR> 

"toggle gvim tool bar.
map <M-m> :call ToggleToolsBar()<CR> 

"generate file names list
"this will replace the previous TagExpr setting.
map <F10> :call RefreshCodeTags()<CR>
map <F11> :call List_lookup_file()<CR>
map <F12> :call RefreshGuiCodeFiles()<CR>


"tab key mapping
map <C-t> :tabnew<CR>
map <leader>xx :tabclose<CR>
map <M-x> :tabclose<CR>
map <M-w> :x<CR>

map <M-1> :tabp<CR>
map <M-2> :tabn<CR>
map <C-j> :tabp<CR>
map <C-k> :tabn<CR>

map <M-o> :tabnew %<CR> :A<CR>
map <C-h> :tabnew %<CR> :A<CR>

map <F2>  :MRU<CR>
"map <F3>  :AS<CR>

map <C-A> ggVG

"taglist
map <leader>tl :Tlist<CR>  
map <F4> :Tlist<CR>  

"file explorer
map <leader>ve :VE<CR><CR>
map <leader>fe :tabnew<CR>:Ve <CR><C-W><C-W>:x<CR> 

"look up file
map <leader>lf :LookupFile<CR>

"using cscope to find text reference.
map <F7> :call FindReference()<CR>

"checkout file using p4.
map <leader>co  :!~/tools/p4 edit %<CR>


map <leader>sstf :mksession! ~/session/tflex<CR>
map <leader>ss :mksession! ~/session/<CR>
map <leader>sotf :so ~/session/tflex<CR>
map <leader>sos :so ~/session/<CR>


"bookmark setting

map mm :call BookmarkHere()<CR>
map mc :CopenBookmarks<CR>
map md :call DelBookmark()<CR>



"------cscope key mapping.

"find reference 
map <leader>fr :let g:word = expand("<cword>")<CR>:tabedit<CR>:cs find s <C-R>=g:word<CR><CR>:copen<CR>
"find definition
map <leader>fd :let g:word = expand("<cword>")<CR>:tabedit<CR>:cs find g <C-R>=g:word<CR><CR>:copen<CR>
"find caller
map <leader>fc :let g:word = expand("<cword>")<CR>:tabedit<CR>:cs find c <C-R>=g:word<CR><CR>:copen<CR>
"find what you specify,find text
map <leader>ft :let g:word = expand("<cword>")<CR>:tabedit<CR>:cs find t <C-R>=g:word<CR><CR>:copen<CR>

"find this egrep pattern
map <leader>fe :let g:word = expand("<cword>")<CR>:tabedit<CR>:cs find e <C-R>=g:word<CR><CR>:copen<CR>

"find file
map <leader>ff :let g:file = expand("<cfile>")<CR>:tabedit<CR>:cs find f <C-R>=g:file<CR><CR>:copen<CR>
"find files that include this file
map <leader>fi :let g:file = expand("<cfile>")<CR>:tabedit<CR>:cs find i <C-R>=g:file<CR><CR>:copen<CR>
"map <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>



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
let g:OmniCpp_NamespaceSearch = 1

let g:OmniCpp_ShowPrototypeInAbbr = 1 

let g:OmniCpp_MayCompleteScope = 1 

"MRU setting
"no help doc is provided.
let g:MRU_Max_Entries=1024
let g:MRU_Use_Current_Window = 0 "
let g:MRU_Auto_Close = 0 "do not close on selecting file.
let g:MRU_Add_Menu = 0 "disable gui menu setting.

"let g:vbookmark_bookmarkSaveFile=$HOME.'/.vimbookmark'

let g:simple_bookmarks_signs = 1
let g:simple_bookmarks_new_tab = 0 
let g:simple_bookmarks_auto_close = 0 
"---------------------function ------------------------------------

function! P4CheckOut()
	let f = expand("<cfile>")
	call system("~/tools/p4 edit ".f)
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

	if filereadable(csFiles)
		let csfilesdeleted=delete(csFiles)
	endif

	if filereadable(csOut)
		let csoutdeleted=delete(csOut)
	endif


	if(has('cscope'))
		if filereadable(csFiles)	
		else
			silent! execute "!~/.vim/list.cscope.files.sh"
		endif

		silent! execute "!cscope -C -Rbq -i ~/.vim/caches/cscope.files"
		silent! execute "!mv cscope.*  ~/.vim/caches/"

		if filereadable(csOut)
			silent! execute "normal :"
			silent! execute "cs add ".csOut
		endif

	else
		echo "please install cscope first"
	endif


endfunction

function! RefreshCodeTags()

	let txt=input("refresh gui code?otherwise refresh current path.(y/n):")
	if txt == "y"
		execute "! ~/.vim/list.code.tags.sh gui"
	else
		execute "!~/.vim/list.code.tags.sh"
	endif
	
endfunction



"setup files in current folder for LookupFiel, Cscope.
function! List_lookup_file()

	let txt="y"
	if filereadable("filenametags")
      let txt = input("tags existed,rebuild or not ?(y/n)") 
	endif

	if txt == "y"
		execute "! ~/.vim/list.all.files.cur"
	endif

	execute "let g:LookupFile_TagExpr='\"filenametags\"'"

	if filereadable("cscope.files")
	else
		silent! execute "!find `pwd` -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cc' -o -name '*.hpp' > cscope.files"
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
	silent! execute "copen"
endfunction



function! BookmarkHere()
	let txt = input("bookmark name:")
	if txt == ""
		return
	endif

	silent! execute "Bookmark ".txt

endfunction

function! DelBookmark()

	let txt = input("bookmark to be deleted:")
	if(txt == "")
		return
	endif

	silent! execute "DelBookmark ".txt

endfunction

