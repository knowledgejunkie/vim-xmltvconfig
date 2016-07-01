" Vim syntax highlighting for XMLTV grabber config files
" Language:    XMLTV grabber config files
" FileType:    xmltvconfig
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvconfig
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.01
" Last Change: 2016-06-30

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'xmltvconfig'
endif

" Config lines
syntax region xmltvconfigChannelConfigLine start="^channel\(=\|!\)" excludenl end="$" contains=xmltvconfigEnabledChannel,xmltvconfigDisabledChannel
syntax match xmltvconfigEnabledChannel "^channel=.*" contained
syntax match xmltvconfigDisabledChannel "^channel!.*" contained

syntax region xmltvconfigNonChannelConfigLine keepend start="^\(channel\(=\|!\)\)\@![^#]\+" excludenl end="\v$" contains=xmltvconfigNonChannelKey,xmltvconfigNonChannelSeparator,xmltvconfigNonChannelValue
syntax match xmltvconfigNonChannelKey "^\(channel\)\@![^=]\+" contained nextgroup=xmltvconfigNonChannelSeparator
syntax match xmltvconfigNonChannelSeparator "=" contained nextgroup=xmltvconfigNonChannelValue
syntax match xmltvconfigNonChannelValue "[^=]\+$" contained

highlight def link xmltvconfigEnabledChannel Statement
highlight def link xmltvconfigDisabledChannel SpecialChar
highlight def link xmltvconfigNonChannelKey Type
highlight def link xmltvconfigNonChannelSeparator Question
highlight def link xmltvconfigNonChannelValue Function

" Comments
syntax region xmltvconfigCommentLine start="\v^#" excludenl end="\v$" contains=xmltvconfigComment
syntax match xmltvconfigComment "\v^#.*" contained

highlight def link xmltvconfigComment Comment


let b:current_syntax = "xmltvfixup"
if main_syntax == 'xmltvconfig'
  unlet main_syntax
endif
