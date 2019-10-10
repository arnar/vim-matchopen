" Vim plugin for highlighting the opening delimiter of the scope
" that the cursor is in. Based on matchparen.vim.
" Maintainer: Arnar Birgisson <arnarbi@gmail.com>
" Last Change: 2019 Oct 10

if exists("g:loaded_matchopen") || &cp || !exists("##CursorMoved")
  finish
endif
let g:loaded_matchopen = 1

augroup matchlastopen
  autocmd! CursorMoved,CursorMovedI,WinEnter * call s:Highlight_Last_Open()
augroup END

if exists("*s:Highlight_Last_Open")
  finish
endif

if !hlexists("MatchOpen")
  highlight link MatchOpen MatchParen
endif

let s:cpo_save = &cpo
set cpo-=C

function! s:Highlight_Last_Open()
  if exists('w:lastpar_hl_on') && w:lastpar_hl_on
    2match none
    let w:lastpar_hl_on = 0
  endif

  if pumvisible() || (&t_Co < 8 && !has("gui_running"))
    return
  endif

  let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
        \ '=~?  "string\\|character\\|singlequote\\|escape\\|comment"'

  let stopline = line('w0')

  let hl_pattern = ''

  for [p_open, p_close] in [['(',')'], ['{','}'], ['\[', '\]']]
      let [m_lnum, m_col] = searchpairpos(p_open, '', p_close, 'nbW', s_skip, stopline)
      if m_lnum > 0 && m_lnum >= stopline
        let hl_pattern = hl_pattern . '\%' . m_lnum . 'l\%' . m_col . 'c\|'
      endif
  endfor

  if !empty(hl_pattern)
    exe '2match MatchOpen /' . hl_pattern[:-3] . '/'
    let w:lastpar_hl_on = 1
  endif
endfunction

command! NoMatchLastOpen windo 2match none | unlet! g:loaded_matchopen | au! matchlastopen
command! DoMatchLastOpen runtime plugin/matchopen.vim | windo doau CursorMoved

let &cpo = s:cpo_save
unlet s:cpo_save
