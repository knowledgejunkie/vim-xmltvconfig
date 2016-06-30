" Vim filetype detection for XMLTV grabber config files
" Language:    XMLTV grabber config files
" FileType:    xmltvconfig
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.01
" Last Change: 2016-06-30

autocmd BufNewFile,BufRead tv_grab_*.conf set filetype=xmltvconfig
autocmd BufNewFile,BufRead freeview*.conf set filetype=xmltvconfig
autocmd BufNewFile,BufRead freesat*.conf set filetype=xmltvconfig
autocmd BufNewFile,BufRead virgin*.conf set filetype=xmltvconfig
autocmd BufNewFile,BufRead sky*.conf set filetype=xmltvconfig
