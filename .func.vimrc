
" --------------------- functions ------------------------------------


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
        silent! execute "call LinkCodeTags()"
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
        return
    endif

    let l:index = stridx(a:file, g:p4_code_base)
    if l:index == -1
        return
    endif

    let l:nr = bufnr(a:file)
    if exists("g:files_checkout[l:nr]") && filewritable(l:nr) && g:files_checkout[l:nr] == 1
        return
    endif

    let l:ret = P4CheckOut(a:file, "open")

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

    call HandleHiddenBuf(a:buf)

endfunction

function! IsTerminalWin(file)

    if match(a:file, g:TerminalName) > -1
        retur 1
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

    silent! execute "stopinsert"

    if IsTerminalWin(a:file)
        silent! execute "AcpDisable"
        silent! execute "set cursorline!"
        " silent! execute "startinsert"

        if winnr("$") == 1
            silent! execute "set laststatus=0"
        else
            setlocal statusline=%3*[terminal]
        endif

        match none

        return 1
    else
        match TrailingSpace /\s\+$/
        silent! execute "AcpEnable"
        silent! execute "set cursorline"
        silent! execute "set laststatus=2"
        return 0
    endif

endfunction

function! OnWinEnter()

    " exit when there is only mru window.
    " not finish yet.

    call CleanHiddenUslessBuffer()

    let l:buflist = tabpagebuflist()

    for b in l:buflist

        if (IsNullBuf(b) || IsFileWin(b) || IsTerminalWin(bufname(b)))
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
function! P4CheckOut(file, mode)

    let l:path = NormalizePath(a:file)

    if a:mode ==# "open"
        let op = "edit"
    else
        let op = "add"
    endif

    " silent execute("! p4 ".op." ".l:path)

    let output = system("! p4 ".op." ".l:path)

    if v:shell_error && stridx(output, "opened") == -1
        echoerr "p4 ".op." error:".output
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
    call RefreshCodeTags()
endfunction

" refreshing ctags data. pretty much not in use often.
" ctags data is currently used by omni complete plugin only.
function! RefreshCodeTags()

    if g:WorkingInCurrDir == 1
        execute "!~/.vim/script/list.code.tags.sh cur &"
    else
        execute "! ~/.vim/script/list.code.tags.sh &"
    endif

    redraw!

endfunction


" setup files in current folder for LookupFiel, Cscope.
function! List_lookup_file_for_cur_folder(mode)

    let txt="y"

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

    set path="./"
    let g:WorkingInCurrDir = 1

    call List_lookup_file_for_cur_folder(a:mode)
    call SetupCscopeForCurFolder(a:mode)
    call RefreshCodeTags()
    call LinkCodeTags()

    redraw!

endfunction

" if we are in WorkingInCurrDir mode, then switch to code base mode.
" this two mode is different in that: cscope date, file look up data, ctags data is different.
" thus influencing auto complete, etc.
function! SwitchToCodeBase()

    let g:WorkingInCurrDir = 0

    set path=$MD_CODE_BASE
    let g:LookupFile_TagExpr = '$HOME."/.vim/caches/filenametags"'

    if (g:UseGlobalOverCscope)
        let g:mycodetags = $HOME."/.vim/caches/GTAGS"
    else
        let g:mycodetags = $HOME."/.vim/caches/cscope.out"
    endif

    call CsAddTags(g:mycodetags, 0)
    call LinkCodeTags()

endfunction

" using cscope to find reference by searching text.
" this type of searching is extremely unefficient, and will block vim for quite a while.
function! FindReference()
    let txt = input('enter text:')
    if txt ==# ""
        return
    endif

    call CleanQuickfix()

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
    call CleanQuickfix()
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

function! LinkCodeTags()
    set tags=~/.vim/caches/cpp.ctags/tags
    set tags+=~/.vim/caches/wx.ctags/tags

    if g:WorkingInCurrDir == 1
        set tags+=~/.vim/caches/code.ctags/tags
    else
        set tags+=./tags
    endif
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

    if l:buf > 0
        execute "bw ".l:buf
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

function! CloseQuickfixWin()
    if g:IsQuickfixOpen == 1
        silent! execute "cclose"
        let g:IsQuickfixOpen = 0
    endif
endfunction

function! CleanQuickfix()
    execute "call setqflist([])"
    call CleanUnlistedCodeFileBuffer()
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

function! IsHelpBuf(buf)
    let l:type = getbufvar(a:buf, "&buftype")
    return l:type ==# "help"
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
    if (l:type ==# "quickfix" || (l:type ==# "nofile" && match(bufname(a:buf),g:BufExplorerName) == -1 && match(bufname(a:buf),g:LookupFileName)) || IsNullBuf(a:buf))
        return 0
    endif

    return 1

endfunction

function! CloseCurrentWin()

    silent exe ":quit"

endfunction

function! HandleHiddenBuf(br)

    if a:br < 0
        return
    endif

    if !IsFileWin(a:br)
        let g:files_hidden[a:br] = 1
    endif

endfunction

function! OnBufLeaveWin(br)

    if (IsQuickfixBuf(a:br))
        let g:IsQuickfixOpen = 0
    endif

    let buffer = bufname(a:br)

    if buffer ==? g:MruBufferName
        call CloseHistoryBuffer(-1)
    endif

endfunction

function! IsCurrentTabEmpty()

    let l:buflist = tabpagebuflist()
    let l:len = len(l:buflist)
    if len(l:buflist) > 1

        let l:new = 0
        for b in l:buflist
            if IsFileWin(b)
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

function! EditMyVimrc(file)

    let l:new = IsCurrentTabEmpty()

    let br = bufnr(a:file)

    if br > 0

        if IsBuffHidden(br)

            if !l:new
                execute "tabnew"
            endif

            execute "buffer ".br

        else
            execute "sb ".br
        endif

        return

    endif

    if !l:new
        silent! execute "tabedit ".a:file
    else
        silent! execute "edit ".a:file
    endif

endfunction

" if buffer by name is existed in current tab, then close it
" otherwise return buffer number.
function! ToggleWinByName(name)

    let l:buf = IsBufShowInCurrTab(a:name)

    " echoerr "win ".a:name." existed?:".l:buf

    if (l:buf != -1)
        " toggle, if window already opened, then close it.
        " let l:win = bufwinnr(l:buf)

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
        call CloseAuxiliaryWin()
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

function! CleanHiddenUslessBuffer()

    if (g:clean_hidden_buffer_co % 8)

        for key in keys(g:files_hidden)
            if bufloaded(key) && !IsFileWin(key)
                execute "bw! ".key
            endif
        endfor

        let g:clean_hidden_buffer_co += 1

    else
        " the following implementation is simple and 100% coverage, but not the most efficient.
        " alternative is the above: keep a list of hidden buffers and wipe them out in autocmd BufHidden.
        " but not guarantee to have 100% coverage.

        let visible = {}
        for t in range(1, tabpagenr('$'))
            for b in tabpagebuflist(t)
                let visible[b] = 1
            endfor
        endfor

        for b in range(1, bufnr("$"))
            if bufloaded(b) && !has_key(visible, b)
                if !IsFileWin(b)
                    silent! execute "bw! ".b
                endif
            endif
        endfor

        let g:clean_hidden_buffer_co = 1

    endif

    let g:files_hidden = {}

endfunction

function! CleanUnlistedCodeFileBuffer()
   for b in range(1, bufnr("$"))
       if bufexists(b) && !buflisted(b) && (IsHelpBuf(b) || stridx(bufname(b), $MD_CODE_BASE) > -1 || getbufvar(b, "&buftype") ==# "")
           execute "bw! ".b
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

    " echoerr "find ".a:name." num: ".l:nr

    if l:nr <= 0
        return -1
    endif

    for b in tabpagebuflist(tabpagenr())
        if l:nr == b
            return l:nr
        endif
    endfor

    return -1

endfunction

function! CleanTrailingSpace()

    execute "%s/\\s\\+$//g"

endfunction

