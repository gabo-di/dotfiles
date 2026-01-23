" --- minimal vimrc ---

" UI / search basics
set nu rnu hls is
syntax on

" Indentation / tabs
set ai ts=4 sw=4 et

" Mouse support
set mouse=a

" Recursive :find + command-line completion
set path=.,**
set wildmenu wildignorecase
set wildignore+=*.o,*.pyc,*.swp

" Grep via ripgrep -> quickfix (:copen, :cnext, :cprev)
if executable('rg')
  set gp=rg\ --vimgrep\ --smart-case\ --no-heading
  set gfm=%f:%l:%c:%m,%f:%l:%m
endif

" Fast fuzzy-ish file finder via fd/fdfind (no plugins)
" Usage: :fdfind <pattern><Tab>
if executable('fdfind') || executable('fd')
  let s:fd = executable('fdfind') ? 'fdfind' : 'fd'

  " type :fdfind ... -> becomes :Fdfind ...
  cnoreabbrev <expr> fdfind (getcmdtype()==':' && getcmdline() =~# '^fdfind\>' ? 'Fdfind' : 'fdfind')

  " Core: return RELATIVE matches (nice for <Tab>)
  function! s:fdrel(pat) abort
    let l:g = empty(a:pat) ? '*' : '*'.a:pat.'*'
    return systemlist('cd '.shellescape(getcwd()).' && '.s:fd.' --type f --hidden --follow --glob '.shellescape(l:g).' .')
  endfunction

  " Completion func must accept (A, L, P)
  function! s:fdcomp(A, L, P) abort
    return s:fdrel(a:A)
  endfunction

  function! s:fdopen(arg) abort
    let l:cwd = getcwd()

    " If user gives a real path, open directly
    if a:arg =~# '^/' || a:arg =~# '^\./' || a:arg =~# '^\.\./'
      execute 'edit ' . fnameescape(fnamemodify(a:arg, ':p'))
      return
    endif

    " If user picked a relative file from <Tab>, open it
    if filereadable(a:arg)
      execute 'edit ' . fnameescape(fnamemodify(l:cwd.'/'.a:arg, ':p'))
      return
    endif

    " Otherwise treat as pattern
    let l:f = s:fdrel(a:arg)
    if empty(l:f)
      echo 'No match: '.a:arg
    elseif len(l:f)==1
      execute 'edit ' . fnameescape(fnamemodify(l:cwd.'/'.l:f[0], ':p'))
    else
      call setqflist(map(l:f,{_,v->{'filename':fnamemodify(l:cwd.'/'.v,':p')}}),'r',{'title':'fdfind: '.a:arg})
      copen
    endif
  endfunction

  command! -nargs=? -complete=customlist,s:fdcomp Fdfind call s:fdopen(<q-args>)
endif
