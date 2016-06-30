# Vim plugin for managing XMLTV grabber config files

A Vim plugin providing functionality to make maintaining an [XMLTV][xmltv] grabber
configuration file easier and less error-prone.

This plugin provides:

* Automatic filetype detection
* Syntax highlighting
* Automatic folding
* Toggling of enabled/disabled settings
* Toggling of enabled/disabled channels
* Mappable toggle commands


## Features

### Automatic filetype detection

The following filenames are automatically set to the 'xmltvconfig' filetype:

* tv\_grab\_\*

* freeview\*.conf
* freesat\*.conf
* sky\*.conf
* virgin\*.conf

Other fixup files can be assigned the 'xmltvconfig' filetype automatically by adding
the following to your .vimrc:

    autocmd BufNewFile,BufRead */path/to/config/file set filetype=xmltvconfig


### Syntax highlighting

Highlighting of the 'xmltvconfig' filetype is used to distinguish the
following elements in a grabber config file:

* Setting key
* Setting value
* Enabled channels
* Disabled channels


### Automatic folding

Settings and channel entries are automatically folded into separate folds when
a config file is opened.


### Toggling of enabled/disabled settings

Configuration settings having a value of "enabled" or "disabled" can be toggled
by either calling:

    :ToggleLine

or by using the relevant mapping (see below).


### Toggling of enabled/disabled channels

Channel entries can be quickly enabled (=) or disabled (!) by either calling:

    :ToggleLine

or by using the relevant mapping (see below).


### Mappable toggle command

The plugin provides a <Plug> command that can be mapped. The default
mapping can be disabled by setting g:xmltvconfig_no_mappings=1 in your .vimrc

By default, the following convenience mapping is provided (for the xmltvconfig
filetype only, and only for the current buffer):

    <Leader>x    <Plug>ToggleLine


## Prerequisites

None. A working XMLTV installation makes this plugin useful.


## Installation (plugin)

Installing vim-xmltvconfig is straightforward. Use of a Vim plugin manager is
recommended (I currently use vim-plug).


### vim-plug

If you are using [vim-plug][vim-plug] you need to have the following line
in your `.vimrc`:

    Plug 'knowledgejunkie/vim-xmltvconfig'

To install the plugin from within Vim, run:

    :PlugInstall vim-xmltvconfig

To install the plugin from the command line, run:

    $ vim +PlugInstall vim-xmltvconfig +qall


### Vundle

For [Vundle][vundle] you need to make sure you have the following line in
your `.vimrc`:

    Bundle 'knowledgejunkie/vim-xmltvconfig'

To install the plugin from within Vim, run:

    :PluginInstall

To install the plugin from the command line, run:

    $ vim +PluginInstall +qall


### Pathogen

For [Pathogen][pathogen], execute:

    cd ~/.vim/bundle
    git clone https://github.com/knowledgejunkie/vim-xmltvconfig
    vim +Helptags +q


## Usage

Filetype detection, toggling, syntax highlighting and folding should "just work"
once the plugin is installed.


## TODO

* Support more settings (e.g. encodings)


## License

Copyright (c) 2016 Nick Morrott. Distributed under the same terms as Vim itself. See `:help license`.

[xmltv]: http://xmltv.org
[vim-plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[pathogen]: https://github.com/tpope/vim-pathogen
