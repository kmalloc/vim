" Vim color file
" Maintainer:	allanhuang<allanhuang@tencent.com>
" Last Change:	$Date: 2012/08/07 $
" URL:		
" Version:	

set background=dark
let g:colors_name="allan"

if exists("syntax_on")
	syntax reset
endif

"hi Normal ctermbg=DarkGrey ctermfg=White guifg=White guibg=grey20

"hi Normal	guifg=White guibg=grey20

" highlight groups
hi Cursor	guibg=khaki guifg=slategrey
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded	guibg=grey30 guifg=gold
hi FoldColumn	guibg=grey30 guifg=tan
hi IncSearch	guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg	guifg=goldenrod
hi MoreMsg	guifg=SeaGreen
hi NonText	guifg=LightBlue guibg=grey30
hi Question	guifg=springgreen
"hi Search	guibg=peru guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
hi Title	guifg=indianred
hi Visual	gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg	guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

" syntax highlighting groups
hi Comment	guifg=SkyBlue
hi Constant	guifg=#ffa0a0
hi Identifier	guifg=palegreen
hi Statement	guifg=khaki
hi PreProc	guifg=indianred
hi Type		guifg=darkkhaki
hi Special	guifg=navajowhite
"hi Underlined
hi Ignore	guifg=grey40
"hi Error
hi Todo		guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey	ctermfg=darkgreen
hi NonText	cterm=bold ctermfg=darkblue
hi Directory	ctermfg=darkcyan
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch ctermfg=yellow ctermbg=yellow
"hi Search	cterm=NONE ctermfg=yellow ctermbg=yellow
hi Search	ctermbg=1* ctermfg=3* cterm=reverse,bold
hi MoreMsg	ctermfg=darkgreen
hi ModeMsg	cterm=NONE ctermfg=brown
hi LineNr	ctermfg=24 
hi Question	ctermfg=green
hi StatusLine	cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit	cterm=reverse
hi Title	ctermfg=202
"hi Visual	cterm=reverse
hi Visual	cterm=reverse ctermbg=black
hi VisualNOS	cterm=bold,underline
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
"注释
hi Comment	ctermfg=243 
"常量
hi Constant	ctermfg=69
"转义
hi Special	ctermfg=202 
hi Identifier	ctermfg=164
"关键词
hi Statement	ctermfg=220
"预处理
hi PreProc	ctermfg=223
"变量类型
hi Type		ctermfg=40
hi Underlined	cterm=underline ctermfg=5
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=darkgrey
hi Error	cterm=bold ctermfg=7 ctermbg=1
"空行符
hi NonText ctermfg=24
"hi StatusLine ctermbg=darkred  ctermfg=lightgreen
hi Pmenu ctermbg=24 ctermfg=gray

hi MoreMsg ctermbg=red ctermfg=red
hi SpecialKey ctermbg=red ctermfg=red
hi SpecialKey ctermbg=red ctermfg=red
hi keyword ctermbg=red ctermfg=red
hi Subtitle ctermbg=red ctermfg=red
hi Identifier ctermfg=40
