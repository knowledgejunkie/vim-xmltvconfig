" Vim filetype functions for XMLTV grabber config files
" Language:    XMLTV grabber config files
" FileType:    xmltvconfig
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.01
" Last Change: 2016-06-30

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

" Toggle an XMLTV config file entry {{{1
function! s:ToggleLine() abort
    let lnum = line(".")
    let line = getline(".")
    " Look for lines containing key=enabled|disabled
    if line =~? '\v\=(enabled|disabled)$'
        call setline(lnum, s:ToggleSetting(line))
    " Next look for channel entries
    elseif line =~? '\v^channel[!=]'
        call setline(lnum, s:ToggleChannel(line))
    endif
endfunction
" }}}1

" Toggle a non-channel config entry {{{1
function! s:ToggleSetting(line) abort
    let line = a:line

    if line =~? '\v\=enabled$'
        return substitute(line, '=enabled$', '=disabled', "")
    elseif line =~? '\v\=disabled$'
        return substitute(line, '=disabled$', '=enabled', "")
    endif
endfunction
" }}}1

" Toggle a channel config entry {{{1
function! s:ToggleChannel(line) abort
    let line = a:line

    if line =~? '\v^channel\='
        return substitute(line, '^channel=', 'channel!', "")
    elseif line =~? '\v^channel\!'
        return substitute(line, '^channel!', 'channel=', "")
    endif
endfunction
" }}}1

" Mappings {{{1
nnoremap <buffer> <silent> <Plug>ToggleLine :<C-U>call <SID>ToggleLine()<CR>

if ! exists("g:xmltvconfig_no_mappings") || ! g:xmltvconfig_no_mappings
    nmap <buffer> <silent> <Leader>x <Plug>ToggleLine
endif
" }}}1

" Commands {{{1
command! -buffer -nargs=0 ToggleLine call s:ToggleLine()
" }}}1

" Autocommands {{{1
" }}}1
