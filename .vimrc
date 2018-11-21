"-----------------------------------------------------------
"vim配置-----General
"-----------------------------------------------------------
syntax enable
syntax on
set showmode
set showcmd
colorscheme industry
set autoindent
set number
set ruler 	"在状态栏显示光标位置
set tags=./.tags;,.tags
set background=dark
"set relativenumber
set cursorline
"set spell spelllang=en_us
set incsearch
"autocmd BufWritePost $MYVIMRC source $MYVIMRC "配置立刻生效

execute pathogen#infect()
filetype plugin indent on

"-----------------------------------------------------------
"vim-plug----
"-----------------------------------------------------------
call plug#begin('~/.vim/plugged')
" 定义插件，默认用法，和 Vundle 的语法差不多
Plug 'junegunn/vim-easy-align'
Plug 'Lokaltog/vim-powerline'
Plug 'skywind3000/quickmenu.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'majutsushi/tagbar'
" 延迟按需加载，使用到命令的时候再加载或者打开对应文件类型才加载
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" 确定插件仓库中的分支或者 tag
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
call plug#end()

"-------------------------------------------------------------------------
"vim-powerline
"-------------------------------------------------------------------------
let g:Powerline_symbols = 'fancy'
set encoding=utf-8 
set laststatus=2


"--------------------------------------------------------------------------
" NERDTree config
" open a NERDTree automatically when vim starts up
" -------------------------------------------------------------------------
autocmd vimenter * NERDTree
"open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"map F2 to open NERDTree
map <F2> :NERDTreeToggle<CR>
"close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"------------------------------------------------------------------------
" Tagbar
"-------------------------------------------------------------------------
let g:tagbar_width=35
let g:tagbar_autofocus=1
let g:tagbar_left = 1
nmap <F3> :TagbarToggle<CR>

"------------------------------------------------------------------------
"C++-----configure----
"------------------------------------------------------------------------
	if version >= 603	
		set helplang=cn
        	set encoding=utf-8
	endif
"显示中文帮助

"-----------------------------------------------------------------------
"新建.c,.h,.sh,.java文件，自动插入文件头
"-----------------------------------------------------------------------

autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
"定义函数SetTitle，自动插入文件头
func SetTitle()
	    "如果文件类型为.sh文件
	        if &filetype == 'sh'
	                call setline(1,"\#########################################################################")
		        call append(line("."), "\# File Name: ".expand("%"))
		        call append(line(".")+1, "\# mail: j.wang2018i@gmail.com")
			call append(line(".")+2, "\# Created Time: ".strftime("%c"))
			call append(line(".")+3, "\#########################################################################")
		        call append(line(".")+4, "\#!/bin/bash")
			call append(line(".")+5, "")
		else
			call setline(1, "/*************************************************************************")
		        call append(line("."), "    > File Name: ".expand("%"))
		        call append(line(".")+1, "    > Mail: j.wang2018i@gmail.com")
			call append(line(".")+2, "    > Created Time: ".strftime("%c"))
			call append(line(".")+3, " ************************************************************************/")
		        call append(line(".")+4, "")
		endif	
		if &filetype == 'cpp'
			call append(line(".")+5, "#include<iostream>")
			call append(line(".")+6, "using namespace std;")
			call append(line(".")+7, "")	
		endif
		if &filetype == 'c'
			call append(line(".")+5, "#include<stdio.h>")
			call append(line(".")+6, "")
		endif 
		"新建文件后，自动定位到文件末尾
		"autocmd BufNewFile * normal G
	endfunc

"*************************************************************************
"*                     C/C++/JAVA设置<F5>编译                            *
"*************************************************************************
map <F5> :call CompileRunGcc()<CR>

func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!clang % -o %<"
		exec "! ./%<"
	elseif &filetype == 'cpp'
		exec "!clang++ % -o %<"
		exec "! ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!java %<"
	elseif &filetype == 'sh'
		:!./%
	endif
endfunc

"C++调试
map <F8> :call Rungdb()<CR>

func! Rungdb()
	exec "w"
	exec "!clang++ % -g -o %<"
	exec "!gdb ./%<"
endfunc
autocmd FileType make set noexpandtab
