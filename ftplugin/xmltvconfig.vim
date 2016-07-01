" Vim filetype functions for XMLTV grabber config files
" Language:    XMLTV grabber config files
" FileType:    xmltvconfig
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvconfig
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.02
" Last Change: 2016-07-01

" Acknowledgement {{{1
"
" The framework for the normal/visual mode handling came directly from the
" awesome vim-commentary plugin (https://github.com/tpope/vim-commentary)
" by Tim Pope.
"
" }}}1

" Initialisation {{{1

if exists("g:loaded_xmltvconfig") || &cp || v:version < 700
  finish
endif
let g:loaded_xmltvconfig = 1

" }}}1

" Folding {{{1
setlocal foldmethod=expr
setlocal foldexpr=GetFold(v:lnum)
setlocal foldtext=FoldText()

setlocal foldenable
setlocal foldminlines=0
setlocal foldlevelstart=0
" setlocal foldclose=all

let s:SeenChannel = 0
let s:SeenSetting = 0

function! GetFold(lnum) abort
    if getline(a:lnum) !~? '\v^channel[=!]'
        if getline(a:lnum + 1) =~? '\v^channel[=!]'
            return '<1'
        elseif s:SeenSetting
            return 1
        else
            let s:SeenSetting = 1
            return '>1'
        endif
    elseif getline(a:lnum) =~? '\v^channel[=!]'
        if s:SeenChannel
            return 1
        else
            let s:SeenChannel = 1
            return '>1'
        endif
    endif
endfunction

function! FoldText() abort
    let sectionType = s:getFoldType(foldclosed(v:foldstart), foldclosedend(v:foldstart))
    let strFolded = "  "

    if sectionType == "s"
        let numFolded = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
        return strFolded . 'Settings: ' . numFolded . ' settings hidden'
    elseif sectionType == "c"
        let enabledChannels = s:getCountEnabledChannels(foldclosed(v:foldstart), foldclosedend(v:foldstart))
        let disabledChannels = s:getCountDisabledChannels(foldclosed(v:foldstart), foldclosedend(v:foldstart))
        return strFolded . 'Channels: ' . enabledChannels . " enabled, " . disabledChannels . " disabled, " . (enabledChannels + disabledChannels) . " total"
    endif
endfunction

function! s:getCountEnabledChannels(foldstart, foldend) abort
    let lnum = a:foldstart
    let enabled = 0
    while lnum <= a:foldend
        let line = getline(lnum)
        if line =~? '\v^channel[=]'
            let enabled += 1
        endif
        let lnum += 1
    endwhile
    return enabled
endfunction

function! s:getCountDisabledChannels(foldstart, foldend) abort
    let lnum = a:foldstart
    let disabled = 0
    while lnum <= a:foldend
        let line = getline(lnum)
        if line =~? '\v^channel[!]'
            let disabled += 1
        endif
        let lnum += 1
    endwhile
    return disabled
endfunction

function! s:getFoldType(foldstart, foldend) abort
    let lnum = a:foldstart
    let line = getline(lnum)
    if line =~? '\v^channel[!=]'
        return 'c'
    else
        return 's'
    endif
endfunction
" }}}1

" Toggle a range of XMLTV config file entries {{{1
function! s:Toggle(type,...) abort
  if a:0
    let [lnum1, lnum2] = [a:type, a:1]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  for lnum in range(lnum1,lnum2)
      call s:ToggleLine(lnum)
  endfor
endfunction
" }}}1

" Enable a range of XMLTV config file entries {{{1
function! s:Enable(type,...) abort
  if a:0
    let [lnum1, lnum2] = [a:type, a:1]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  for lnum in range(lnum1,lnum2)
      call s:EnableLine(lnum)
  endfor
endfunction
" }}}1

" Disable a range of XMLTV config file entries {{{1
function! s:Disable(type,...) abort
  if a:0
    let [lnum1, lnum2] = [a:type, a:1]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  for lnum in range(lnum1,lnum2)
      call s:DisableLine(lnum)
  endfor
endfunction
" }}}1

" Toggle an XMLTV config file entry {{{1
function! s:ToggleLine(lnum) abort
    let lnum = a:lnum
    let line = getline(lnum)
    " Look for lines containing key=enabled|disabled
    if line =~? '\v\=(enabled|disabled)$'
        call setline(lnum, s:ToggleSetting(line))
    " Next look for channel entries
    elseif line =~? '\v^channel[!=]'
        call setline(lnum, s:ToggleChannel(line))
    endif
endfunction
" }}}1

" Enable an XMLTV config file entry {{{1
function! s:EnableLine(lnum) abort
    let lnum = a:lnum
    let line = getline(lnum)
    " Look for lines containing key=disabled
    if line =~? '\v\=disabled$'
        call setline(lnum, s:EnableSetting(line))
    " Next look for channel entries
    elseif line =~? '\v^channel[!]'
        call setline(lnum, s:EnableChannel(line))
    endif
endfunction
" }}}1

" Disable an XMLTV config file entry {{{1
function! s:DisableLine(lnum) abort
    let lnum = a:lnum
    let line = getline(lnum)
    " Look for lines containing key=enabled
    if line =~? '\v\=enabled$'
        call setline(lnum, s:DisableSetting(line))
    " Next look for channel entries
    elseif line =~? '\v^channel[=]'
        call setline(lnum, s:DisableChannel(line))
    endif
endfunction
" }}}1

" Toggle a non-channel config entry {{{1
function! s:ToggleSetting(line) abort
    let line = a:line

    if line =~? '\v\=enabled$'
        return s:DisableSetting(line)
    elseif line =~? '\v\=disabled$'
        return s:EnableSetting(line)
    endif
endfunction
" }}}1

" Enable a non-channel config entry {{{1
function! s:EnableSetting(line) abort
    let line = a:line

    if line =~? '\v\=disabled$'
        return substitute(line, '=disabled$', '=enabled', "")
    endif
endfunction
" }}}1

" Disable a non-channel config entry {{{1
function! s:DisableSetting(line) abort
    let line = a:line

    if line =~? '\v\=enabled$'
        return substitute(line, '=enabled$', '=disabled', "")
    endif
endfunction
" }}}1

" Toggle a channel config entry {{{1
function! s:ToggleChannel(line) abort
    let line = a:line

    if line =~? '\v^channel\='
        return s:DisableChannel(line)
    elseif line =~? '\v^channel\!'
        return s:EnableChannel(line)
    endif
endfunction
" }}}1

" Enable a channel config entry {{{1
function! s:EnableChannel(line) abort
    let line = a:line

    if line =~? '\v^channel\!'
        return substitute(line, '^channel!', 'channel=', "")
    endif
endfunction
" }}}1

" Disable a channel config entry {{{1
function! s:DisableChannel(line) abort
    let line = a:line

    if line =~? '\v^channel\='
        return substitute(line, '^channel=', 'channel!', "")
    endif
endfunction
" }}}1

" Mappings {{{1
nnoremap <buffer> <silent> <Plug>ToggleLine :<C-U>set opfunc=<SID>Toggle<Bar>exe 'norm! 'v:count1.'g@_'<CR>
xnoremap <buffer> <silent> <Plug>Toggle     :<C-U>call <SID>Toggle(line("'<"),line("'>"))<CR>
nnoremap <buffer> <silent> <Plug>EnableLine :<C-U>set opfunc=<SID>Enable<Bar>exe 'norm! 'v:count1.'g@_'<CR>
xnoremap <buffer> <silent> <Plug>Enable     :<C-U>call <SID>Enable(line("'<"),line("'>"))<CR>
nnoremap <buffer> <silent> <Plug>DisableLine :<C-U>set opfunc=<SID>Disable<Bar>exe 'norm! 'v:count1.'g@_'<CR>
xnoremap <buffer> <silent> <Plug>Disable     :<C-U>call <SID>Disable(line("'<"),line("'>"))<CR>

if ! exists("g:xmltvconfig_no_mappings") || ! g:xmltvconfig_no_mappings
    nmap <buffer> <silent> <LocalLeader>t <Plug>ToggleLine
    xmap <buffer> <silent> <LocalLeader>t <Plug>Toggle
    nmap <buffer> <silent> <LocalLeader>e <Plug>EnableLine
    xmap <buffer> <silent> <LocalLeader>e <Plug>Enable
    nmap <buffer> <silent> <LocalLeader>d <Plug>DisableLine
    xmap <buffer> <silent> <LocalLeader>d <Plug>Disable
endif
" }}}1
