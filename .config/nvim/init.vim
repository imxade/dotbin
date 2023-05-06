"" General
syntax on		" Enable syntax highlighting
filetype indent on	" Load filetype-specific indent files
set number		" Show line numbers
set relativenumber	" Show numbers relative to the current line
set linebreak		" Break lines at word (requires Wrap lines)
set showbreak=+++	" Wrap-broken line prefix
set showmatch		" Highlight matching brace
set visualbell		" Use visual bell (no beeping)
set mouse=a		" Enable use of the mouse for all modes
set laststatus=2	" Show the current file at the bottom
set hlsearch		" Highlight all search results
set incsearch		" Searches for strings incrementally
set autoindent		" Auto-indent new lines
set smartindent		" Enable smart-indent
set smarttab		" Enable smart-tabs
set cursorline		" Highlight current line
set cursorcolumn	" Highlight current column
set noshowcmd		" Show command in bottom bar
set cmdheight=1		" More space to display commands
set wildmenu		" Visual autocomplete for command menu
set wildmode=list:full	" Expands wildmenu
set showmatch		" highlight matching [{()}]
set incsearch		" search as characters are entered
set hlsearch		" highlight matches
set scrolloff=999	" Keep the cursor at middle of screen 
set background=dark	" use dark background
"set termguicolors	" 
"set showtabline=2	" Show vim tab pages all time
"set title		" Title of the current file displayed at the tab
"set noruler		" Don't show row and column ruler information
"set signcolumn=yes	" error signs
"set expandtab		" Use spaces instead of tabs
"set softtabstop=4	" Number of spaces per Tab
"set shiftwidth=4	" Number of auto-indent spaces
"set ignorecase		" Always case-insensitive
"set smartcase		" Enable smart-case search
"set nowrap		" Don't wrap the lines
"set textwidth=100	" Line wrap (number of cols)

"" Advanced
set nobackup			" No backup
set nowritebackup		" No backup
set undolevels=1000		" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour
set clipboard=unnamedplus	" Saves copied text from vim ro general clipboard

" Shortcuts for generic commands as alias to vim commands
:map <C-a> GVgg                   
" Select all 
:map <C-s> :w <Enter>   
" Save file
:map <C-z> u            
" Undo
:map <C-t> :tabnew <Enter>      
" Open new tab within vim
:map <C-i> >>           
" Move line
:map <C-f> :%s/
" Search
:map <F3> n             
" Search the latest action 
:map <C-h> :%s/
" Search and replace syntax
:map <S-Right> gt       
" Switch to the nex tab page
:map <S-Left> gT        
" Switch to the prior tab page

"" Theme
colorscheme slate
highlight LineNr ctermfg=lightgray

"" Statusline
set statusline+=%#PmenuSel#
set statusline+=%#StatusLineNC#
set statusline+=%F
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" Toggle Vexplore with Ctrl-O
function! ToggleVExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        let cur_win_num = winnr()

        if expl_win_num != -1
            while expl_win_num != cur_win_num
                exec "wincmd w"
                let cur_win_num = winnr()
            endwhile

            close
        endif

        unlet t:expl_buf_num
    else
         Vexplore
         let t:expl_buf_num = bufnr("%")
    endif
endfunction

map <silent> <C-O> :call ToggleVExplorer()<CR>

let g:netrw_winsize = -24 " absolute width of netrw window 
let g:netrw_banner = 0 " do not display info on the top of window
let g:netrw_liststyle = 3 " tree-view
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_browse_split = 4 " use the previous window to open file
