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

" ----------------------global variable---------------------------
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


" ------------------------plugin setting--------------------------------------

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


" ----------------------autocmd------------------------------------
augroup AutoEventHandler

    autocmd!

    " rule of thumb: evaluate <afile> <abuf> both inside function or both in parameter.
    " keep them consistent, and better use just one.

    autocmd BufWinEnter *.cpp,*.cc,*.c,*.h,*.hpp,*.cxx call TlistOnBufferWinEnter(expand("<afile>"))
    autocmd WinEnter * call OnWinEnter()

    " invoke code-changed event: for p4 to checkout file
    if g:PerforceExisted
        autocmd BufWritePost */*.cpp,*/*.cc,*/*.c,*/*.cxx,*/*.h,*/*.hpp,*/*.sh,*/*.pl,*/*.mk,*/*.py call OnBufWrite(expand("<afile>"))
    endif

    " autocmd BufHidden * call OnBufHidden(str2nr(expand("<afile>")))

    autocmd BufWritePost ~/.vimrc so ~/.vimrc
    autocmd BufWritePost */code/*.cpp,*/code/*.cxx,*/code/*.cc,*/code/*.c,*/code/*.h call UpdateGtags()
    autocmd TabEnter * call OnTabEnter()
    autocmd BufEnter * call HandleTerminWin(expand("<afile>"))

    " note: this event will not trigger for those buffers that is displayed in
    " multiple windows.
    " BufWinLeave
    autocmd QuitPre * call CloseWinIfNecessary(str2nr(expand("<abuf>")))

    autocmd VimEnter *.cc,*.h,*.cpp,*.c,*.hpp,*.cxx call AutoOpenTaglistOnVimStartup()
    autocmd VimEnter * call SetupVim()

augroup end
" ---------------------function ------------------------------------

" -----------------autocmd handler---------------

function! SetupVim()

    let g:IsVimInitialized = 1

    if g:support_p4_edit_event
        silent! execute "call CheckPerforce()"
    endif

    if filereadable("filenametags")
        silent! execute "call SetupCurFolderData(\"skip\")"
    else
        silent! execute "call SetupCscope()"
    endif

endfunction

function! AutoOpenTaglistOnVimStartup()

    if &diff == 0 "if not in diff mode
        let l:win = winnr()
        TlistOpen
        silent! execute l:win."wincmd w"
    endif

endfunction

function! OnBufferWriteByP4(file)

    " if we don't have p4 here, skip it.
    if g:support_p4_edit_event == 0 || g:PerforceExisted == 0
        echo "p4 command not available."
        return
    endif

    let l:index = stridx(a:file, g:p4_code_base)
    if l:index == -1
        return
    endif

    let l:nr = bufnr('%')
    if exists("g:files_checkout[l:nr]") && filewritable(l:nr) && g:files_checkout[l:nr] == 1
        return
    endif

    let l:ret = P4CheckOut(expand("%:p"))

    if (l:ret == 1)
        let g:files_checkout[l:nr] = 1
    endif

endfunction

function! OnBufWrite(file)

    call OnBufferWriteByP4(a:file)

endfunction

" bug exists when wipping buffer from BufHidden
" use bunload
function! OnBufHidden(buf)

    call CloseWinIfNecessary(a:buf)

endfunction

function! IsTerminalWin(file)

    if match(a:file, g:TerminalName) > -1
        retur 1
    elseif bufwinnr(g:TerminalName) != -1
        return 1
    endif

    return 0

endfunction

" should we open tlist window when entering a buffer window?
" rules are:
" 1. not in diff mode.
" 2. not in terminal window.
function! ShouldSuppressTlist(file)

    if g:AutoOpenTlist == 0
        return 1
    endif

    if &diff
        return 1
    endif

    return IsTerminalWin(a:file)

endfunction

function! TlistOnBufferWinEnter(file)

    let l:skip = ShouldSuppressTlist(a:file)

    if bufwinnr(g:TaglistName) == -1 && l:skip == 0
        let l:win = winnr()
        silent! execute "TlistOpen"
        silent! execute l:win."wincmd w"
    endif

endfunction

" when in terminal window, disable autocomplete plugin
" otherwise enable it
function! HandleTerminWin(file)

    if match(a:file,g:TerminalName) > -1
        silent! execute "AcpDisable"
        silent! execute "set cursorline!"
        silent! execute "startinsert"
        silent! execute "set laststatus=0"
        return 1
    else
        silent! execute "AcpEnable"
        silent! execute "set cursorline"
        silent! execute "stopinsert"
        silent! execute "set laststatus=2"
        return 0
    endif

endfunction

function! OnWinEnter()

    " exit when there is only mru window.
    " not finish yet.

    let l:buflist = tabpagebuflist()

    for b in l:buflist

        if (IsNullBuf(b) || IsFileWin(b) || IsTerminalWin(b))
            return
        endif

    endfor

    if tabpagenr("$") > 1
        execute "tabclose"
    else
        execute "quit"
    endif

endfunction

function! OnTabEnter()

    if winnr("$") == 1 && IsBufShowInCurrTab(g:TerminalName) > 0
        return
    endif

    call ShowQuickfixIfNecessary()
    call OpenHistoryIfNecessary()

endfunction

function! UpdateGtags()

    if(g:UseGlobalOverCscope)
        silent! execute "! ~/.vim/script/gtags.setup.sh update &"
        call CsAddTags(g:mycodetags, 0)
        redraw!
    endif

endfunction

" ----------------end autocmd handler------------------


" ----------------handle shell cmd----------------------
" check whether shell command "cmd" exist
function! IsShellCmdExist(cmd)

    silent! system("which ", a:cmd." 2>&1 1>/dev/null")
    return !v:shell_error

endfunction

function! CheckPerforce()
    let g:PerforceExisted = IsShellCmdExist("p4")
endfunction


" deal with path like: /home/miliao/code/aa/../cc
" output should be:/home/miliao/code/cc
"
" /nfs/all/home/miliao/code/cc
" output: /home/miliao/code/cc

" not quite familiar with vim script resulting in writting such a huge function
function! NormalizePath(file_)

    " try to remove absolute path
    let l:s = stridx(a:file_, "/home/")

    if l:s == -1
        let l:s = 0
    endif

    let l:file = strpart(a:file_, l:s)

    " try to translate ..
    let l:id = stridx(l:file, "..")
    if l:id == -1
        return l:file
    endif

    " try to extract parent folder.
    let l:left = l:id + 2

    while l:file[l:left] == '/'
        let l:left = l:left + 1
    endwhile

    while l:id > 0 && l:file[l:id] != '/'
        let l:id = l:id - 1
    endwhile

    if l:id > 0
        let l:id = l:id - 1
    endif

    " now move up
    while l:id >= 0 && l:file[l:id] != '/'
        let l:id = l:id - 1
    endwhile

    " eliminate extra '/'
    while l:id > 0 && l:file[l:id - 1] == '/'
        let l:id = l:id - 1
    endwhile

    if l:id < 0
        return l:file
    endif

    let l:pre = strpart(l:file, 0, l:id)
    let l:pos = strpart(l:file, l:left)

    let l:path = l:pre."/".l:pos

    return l:path

endfunction

" use p4 command to checkout a file
function! P4CheckOut(file)

    let l:path = NormalizePath(a:file)

    silent execute("! p4 edit ".l:path." > /dev/null 2>&1")

    if v:shell_error
        echo "p4 edit error,please check if you are log in\n"
        return 0
    endif

    return 1

endfunction

" ----------------end handling shell cmd-----------------------



" ---------------code writting helper----------------------

function! Refresh_filelookup_data()

    let l:lookupfiles = $HOME."/.vim/caches/filenametags"
    if filereadable(l:lookupfiles)
        silent! execute "!rm ".l:lookupfiles
    endif

    silent! execute "!~/.vim/script/list.all.files.sh&"
    if filereadable(l:lookupfiles)
        execute "let g:LookupFile_TagExpr='\"".l:lookupfiles."\"'"
    endif

endfunction


" refresh code in code base, eg, ~/code/gui_tflex/, the specific path is decided in the shell script.
function! RefreshCscopeData()
    " let dir = getcwd()

    if !has("cscope")
        return
    endif

    if g:UseGlobalOverCscope == 0

        let l:csFiles=$HOME."/.vim/caches/cscope.files"

        if filereadable(l:csFiles)
            let csfilesdeleted=delete(l:csFiles)
            if (filereadable(l:csFiles))
                echo "refresh cache failed, can not delete ".l:csFiles."\n"
                return
            endif
        endif

        let l:csOut=$HOME."/.vim/caches/cscope.out"
        if filereadable(l:csOut)
            silent! execute "!rm ".l:csOut
        endif

    else

        let l:csOut=$HOME."/.vim/caches/GTAGS"
        silent! execute "!rm ".l:csOut

    endif


    if g:UseGlobalOverCscope == 0

        if !filereadable(l:csFiles)	
            silent! execute "!~/.vim/script/list.cscope.files.sh&"
        endif

    else

        silent! execute "! ~/.vim/script/gtags.setup.sh setup&"

    endif

    call CsAddTags(l:csOut, 1)

    redraw!

endfunction


function! RefreshCodeData()
    call Refresh_filelookup_data()
    call RefreshCscopeData()
endfunction

" refreshing ctags data. pretty much not in use often.
" ctags data is currently used by omni complete plugin only.
function! RefreshCodeTags()

    let txt=input("refresh code base? otherwise refresh current path.(y/n):")
    " ignore case
    if txt ==? "y"
        execute "! ~/.vim/script/list.code.tags.sh &"
    else
        execute "!~/.vim/script/list.code.tags.sh cur &"
    endif

    redraw!

endfunction


" setup files in current folder for LookupFiel, Cscope.
function! List_lookup_file_for_cur_folder(mode)

    let txt="n"

    if a:mode ==# "scan" && filereadable("filenametags")
        let txt = input("filenametags existed,rebuild or not ?(y/n)")
    endif

    if txt ==? "y"
        silent! execute "! ~/.vim/script/list.all.files.sh cur"
    endif

    execute "let g:LookupFile_TagExpr='\"filenametags\"'"

endfunction


function! SetupCscopeForCurFolder(mode)

    if !has("cscope")
        return
    endif

    let l:tags = "cscope.out"

    if a:mode ==# "scan"

        if g:UseGlobalOverCscope == 0

            silent! execute "! ~/.vim/script/list.cscope.files.sh cur"

        else

            let l:tags = "GTAGS"
            silent! execute "! ~/.vim/script/gtags.setup.sh cur &"

        endif

    endif

    call CsAddTags(l:tags, 0)

endfunction

function! SetupCurFolderData(mode)

    call List_lookup_file_for_cur_folder(a:mode)
    call SetupCscopeForCurFolder(a:mode)
    let g:WorkingInCurrDir = 1

endfunction

" if we are in WorkingInCurrDir mode, then switch to code base mode.
" this two mode is different in that: cscope date, file look up data, ctags data is different.
" thus influencing auto complete, etc.
function! SwitchToCodeBase()

    let g:WorkingInCurrDir = 0
    let g:LookupFile_TagExpr = '$HOME."/.vim/caches/filenametags"'

    if (g:UseGlobalOverCscope)
        let g:mycodetags = $HOME."/.vim/caches/GTAGS"
    else
        let g:mycodetags = $HOME."/.vim/caches/cscope.out"
    endif

    call CsAddTags(g:mycodetags, 0)

endfunction

" using cscope to find reference by searching text.
" this type of searching is extremely unefficient, and will block vim for quite a while.
function! FindReference()
    let txt = input('enter text:')
    if txt ==# ""
        return
    endif

    echo "...searching..."

    silent! execute "cs find e ".txt
    silent! call OpenCscopeSearchList()
endfunction


function! ToggleSyntasticCheck()

    let l:nr = bufnr('%')
    if exists("g:files_syntastic[l:nr]") && g:files_syntastic[l:nr] == 1
        SyntasticReset
        unlet g:files_syntastic[l:nr]
    else
        SyntasticCheck
        let g:files_syntastic[l:nr] = 1
    endif

endfunction

function! OpenCscopeSearchList()

    if g:IsQuickfixOpen == 0
        call ToggleQuickfix()
    endif

endfunction

" find symbol from cscope cached data.
" very fast, but may not be accurate if cache is out of date.
function! CscopeFind(file,type)
    silent! execute "cs find ".a:type." ".a:file
    silent! call OpenCscopeSearchList()
    redraw!
endfunction

" setup cscope cached data path
function! CsAddTags(tags, silent)

    silent! execute "cs kill -1"

    if g:UseGlobalOverCscope == 0
        silent! execute "cs add ".a:tags
    else
        silent! execute "cs add ".a:tags
        " silent! execute "cs add ".a:tags." -Ca"
    endif

    set cscopequickfix=c-,d-,e-,g-,i-,s-,t-

    if !a:silent && !filereadable(a:tags)
        execute "echoerr \"can not find ".a:tags.", f11 or f12 please\""
    endif

endfunction

" setup cscope database.
function! SetupCscope()

    if(!has('cscope')) "if vim compiled with cscope, then proceed.
        return
    endif

    if  g:IgnoreGtags == 0 && filereadable(g:gtagsCscopePath)

        set csprg=gtags-cscope
        let g:UseGlobalOverCscope = 1

        let g:mycodetags = $HOME."/.vim/caches/GTAGS"

        " gtags.setup.sh will set up link to code root, prepare cache, etc.
        silent! execute "! ~/.vim/script/gtags.setup.sh env"

    elseif filereadable(g:CscopePath)

        let g:UseGlobalOverCscope = 0
        set csprg=cscope
        set cscopetag

    endif

    call CsAddTags(g:mycodetags, 0)

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
            silent! execute "! ~/.vim/script/gtags.setup.sh env"
        endif

     endif

    call CsAddTags(g:mycodetags, 0)
    redraw!

endfunction

  " ---------------end code writing helper.------------------------

  " ---------------UI setup --------------------------------------
function! ToggleToolsBar()

    if(has("gui_running"))
        if &guioptions =~# 'T'
            silent! execute "set guioptions-=T"
            silent! execute "set guioptions-=m"
        else
            silent! execute "set guioptions+=T"
            silent! execute "set guioptions+=m"
        endif
    endif

endfunction

function! BookMarkHere()
    let txt = input("bookmark name:")
    if txt ==# ""
        return
    endif

    silent! execute "Bookmark ".txt

endfunction


function! DelBookMark()

    let txt = input("bookmark to be deleted:")
    if(txt ==# "")
        return
    endif

    silent! execute "DelBookmark ".txt

endfunction


" handle functional window, taglist, quickfix, etc.
function! ToggleBufferExp(file)

    let l:buf = ToggleWinByName(g:BufExplorerName)

    " echoerr "find: ".l:buf

    if l:buf == -2
        return
    endif

    let l:null = IsCurrentTabEmpty()

    if l:null
        silent! execute "TlistClose"
        silent! execute "BufExplorer"
    else
        silent! execute "BufExplorerVerticalSplit"
    endif

endfunction

function! ToggleQuickfix()

    if tabpagewinnr(tabpagenr(), '$') == 1 && IsTerminalWin(bufname("%"))
        cclose
        return
    endif

    if g:IsQuickfixOpen == 0
        let l:win = winnr()
        silent! execute "bo copen"
        silent! execute l:win."wincmd w"
        let g:IsQuickfixOpen = 1
    else
        silent! execute "cclose"
        let g:IsQuickfixOpen = 0
    endif

    silent! execute "redraw!"

endfunction

function! OpenBookMark()
    let l:win = winnr()
    silent execute "CopenBookmarks"
    silent! execute l:win."wincmd w"
    let g:IsQuickfixOpen = 1
endfunction

" mru does not use quickfix to display history.
function! OpenHistory()

    let g:IsHistoryWinOpened = 1
    let l:win = winnr()
    silent! execute "MRU"
    silent! execute l:win."wincmd w"

endfunction

" still have bugs,should enable auto close mru.
function! OpenHistoryIfNecessary()
    " let l:mruwinnr = bufnr(g:MruBufferName)
    if g:IsHistoryWinOpened == 1

        call OpenHistory()

    else

        let l:mruwinnr = bufnr(g:MruBufferName)
        call CloseHistoryBuffer(l:mruwinnr)

    endif

endfunction

function! ToggleHistoryWin()

    let l:mruwinnr = bufwinnr(g:MruBufferName)
    if l:mruwinnr != -1
        let g:IsHistoryWinOpened = 0
        silent! execute l:mruwinnr."wincmd w"
        silent! execute "x"
    else
        call OpenHistory()
    endif

endfunction

function! CloseHistoryBuffer(buf)

    let g:IsHistoryWinOpened = 0
    if a:buf > 0
        silent! execute "bw! ".a:buf
    elseif a:buf == -2
        let br = FindBufferWithName(g:MruBufferName)
        if br > 0
            silent! execute "bw! ".br
        endif
    endif

endfunction

function! IsQuickfixBuf(buf)
    let l:type = getbufvar(a:buf, "&buftype")
    return l:type ==# "quickfix"
endfunction

function! IsNullBuf(buf)
    let l:type = getbufvar(a:buf, "&buftype")
    if (l:type ==# "" && bufname(a:buf) ==# "")
        return 1
    endif
    return 0
endfunction

function! IsFileWin(buf)

    let l:type = getbufvar(a:buf, "&buftype")
    if (l:type ==# "quickfix" || (l:type ==# "nofile" && match(bufname(a:buf),g:BufExplorerName) == -1) || IsNullBuf(a:buf))
        return 0
    endif

    return 1

endfunction

function! CloseCurrentWin()

    let br = bufnr("%")
    let nm = bufname(br)

    if match(nm, g:TerminalName) > -1
        silent exe "bw! ".br
    " elseif nm ==# ""
        " silent exe "bw! ".br
    else
        silent exe "quit"
    endif

endfunction

function! CloseWinIfNecessary(br)

    if a:br < 0
        return
    elseif (IsQuickfixBuf(a:br))
        let g:IsQuickfixOpen = 0
    endif

    let buffer = bufname(a:br)

    if buffer ==? g:MruBufferName
        call CloseHistoryBuffer(-1)
    elseif match(buffer, g:TerminalName) > -1
        silent! execute "bw! ".a:br
    elseif match(buffer, "Vundle") > -1
        silent! execute "bw! ".a:br
    elseif buffer ==# ""
        execute "bw! ".a:br
    endif

endfunction


function! IsCurrentTabEmpty()

    let l:buflist = tabpagebuflist()
    let l:len = len(l:buflist)
    if len(l:buflist) > 1

        let l:new = 0
        for b in l:buflist
            if !IsFileWin(b)
                let l:new = 1
                break
            endif
        endfor

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

    return l:new == 0

endfunction

function! EditMyVimrc()

    let l:new = IsCurrentTabEmpty()

    if !l:new
        silent! execute "tabedit $MYVIMRC"
    else
        silent! execute "edit $MYVIMRC"
    endif

endfunction

" if buffer by name is existed in current tab, then close it
" otherwise return buffer number.
function! ToggleWinByName(name)

    let l:buf = IsBufShowInCurrTab(a:name)

    " echoerr "win ".a:name." existed?:".l:buf

    if (l:buf != -1)
        " toggle, if window already opened, then close it.
        let l:win = bufwinnr(l:buf)

        " echoerr "to close(".l:buf.",".l:win.")"
        " silent! execute l:win."wincmd w"
        " silent! execute "x"
        silent! execute "bw! ".l:buf
        return -2
    endif

    let l:buf = FindBufferWithName(a:name)

    return l:buf

endfunction

function! CloseAuxiliaryWin()
    execute "cclose"
    call CloseHistoryBuffer(-2)
endfunction

function! ShowQuickfixIfNecessary()

    if g:IsQuickfixOpen == 1
        let l:win = winnr()
        silent! execute "bo copen"
        silent! execute l:win."wincmd w"
    else
        silent! execute "cclose"
    endif

endfunction

function! ShowTerminal(mode)

    let l:buf = ToggleWinByName(g:TerminalName)

    if l:buf == -2
        return
    endif

    if l:buf > 0
        silent! execute "sb ".l:buf
        return
    endif

    let l:null = IsCurrentTabEmpty()

    if l:null
        silent! execute "ConqueTerm bash"
    elseif a:mode ==# "tab"
        silent! execute "ConqueTermTab bash"
        call CloseAuxiliaryWin()
    else
        silent! execute "ConqueTermVSplit bash"
    endif

endfunction

" find the first buffer with the name specified in parameter "name"
" regular expression is supported in "name"
function! FindBufferWithName(name)
    let l:bufcount = bufnr("$")
    let l:currbufnr = 1

    while currbufnr <= bufcount
        if (bufexists(currbufnr))
            let l:currbufname = bufname(currbufnr)
            if (match(l:currbufname, a:name) > -1)
                return currbufnr
            endif
        endif

        let l:currbufnr = l:currbufnr + 1
    endwhile

    return 0
endfunction

function! CleanHiddenBuffer()

    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor

    for b in range(1, bufnr("$"))
        if bufloaded(b) && !has_key(visible, b)
            silent! execute "bw! ".b
        endif
    endfor

endfunction

function! IsBuffHidden(buf)

    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor

    if bufloaded(a:buf) && has_key(visible, a:buf)
        return 0
    endif

    return 1

endfunction

" can not just bufwinnr() to judge whether a buffer show in current tab.
" some hidden buffer is not excluded by bufwinnr()
function! IsBufShowInCurrTab(name)

    let l:nr = FindBufferWithName(a:name)

    if l:nr <= 0
        return -1
    endif

    " echoerr "find ".a:name." num: ".l:nr

    for b in tabpagebuflist(tabpagenr())
        if l:nr == b
            return l:nr
        endif
    endfor

    return -1

endfunction


" ------------------------- vim setting -------------------------
" source other setttings
if IsShellCmdExist("git")
    so ~/.vim/.bundlerc
endif

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
" set <M-key>=<Esc>key
" see :h map-alt-keys
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
" set background=light

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

" solarized
" allan deveiate
" pacific
" molokai
" torte

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


" -------------key mapping-------------------------------

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


