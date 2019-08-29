# Navim &middot; [![Build Status](https://travis-ci.org/taohexxx/navim.svg?branch=master)](https://travis-ci.org/taohexxx/navim) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

A full-blown IDE based on Neovim (or Vim) with better navigation.

![Navim](http://taohexxx.github.io/navim/images/navim.gif)

**Table of Contents**

- [Key Mapping](#key-mapping)
- [Basic Installation](#basic-installation)
- [Advanced Settings](#advanced-settings)
- [Advanced Installation](#advanced-installation)
- [Plugins](#plugins)
- [Coding Style](#coding-style)
- [Tags](#tags)
- [Credits](#credits)
- [License](#license)

## Key Mapping

You don't need to remember any key mapping, as navigation bar will show up immediately after the leader key (<kbd>Space</kbd> by default) is pressed.

Default `<Leader>` is <kbd>Space</kbd>, `<LocalLeader>` is <kbd>,</kbd>. For example, <kbd>Space</kbd> <kbd>s</kbd> <kbd>s</kbd> search the word under cursor. As shown below, key mapping is carefully-chosen.

![Navim Key Mapping](http://taohexxx.github.io/navim/images/navim_key_mapping.png)

Most of key mapping is [denite](https://github.com/Shougo/denite.nvim) centric. More key mapping is listed here:

Key Mapping                                                   | Description
--------------------------------------------------------------|------------------------------------------------------------
<kbd>Left</kbd> and <kbd>Right</kbd>                          | previous buffer, next buffer
<kbd>Ctrl</kbd>+<kbd>h</kbd> and <kbd>Ctrl</kbd>+<kbd>l</kbd> | move to window in the direction of hl
<kbd>Ctrl</kbd>+<kbd>j</kbd> and <kbd>Ctrl</kbd>+<kbd>k</kbd> | move to window in the direction of jk
<kbd>Ctrl</kbd>+<kbd>w</kbd> <kbd>o</kbd>                     | maximize or restore current window in split structure
<kbd>Q</kbd>                                                  | close windows and delete the buffer (if it is the last buffer window)

## Basic Installation

Basic installation is simple:

```sh
git clone --recursive https://github.com/taohexxx/navim ~/.config/nvim
```

Make links if you are using Vim:

```sh
mv ~/.vim ~/.vim.backup
mv ~/.vimrc ~/.vimrc.backup
ln -s ~/.config/nvim ~/.vim
ln -s ~/.config/nvim/init.vim ~/.vimrc
```

Startup vim and [dein](https://github.com/Shougo/dein.vim) will detect and ask you install any missing plugins.

## Advanced Settings

Plugins are nicely organised in layers. There are many ready-to-use layers (javascript, navigation, scm, web, etc.) and you can add your own ones.

Private layers can be added to `private_layers/`. And Private plugins can be added to `private_bundle/`. The content of these two directory is ignored by Git.

It is completely customisable using a `~/.navimrc` file. Just copy `.navimrc.sample` to `~/.navimrc` and modify anything.

After restart Neovim (or Vim), run `call dein#clear_state() || call dein#update()` to apply changes.

### Global Variables

In most instances, modify `g:navim_settings` in `~/.navimrc` should meet your needs.

Key                      | Value                                               | Description
-------------------------|-----------------------------------------------------|-------------------------------------------
`layers`                 | `'c'`, `'completion'`, `'editing'`, ...             | files in `layers/` or `private_layers/`
`additional_plugins`     | `'joshdick/onedark.vim'`, ...                       | github repo
`encoding`               | `'utf-8'`, `'gbk'`, `'latin1'`, ...                 | files in `encoding/`
`bin_dir`                | `'/usr/local/bin'`, ...                             | bin directory for cscope, ctags, gdb, ...
`explorer_plugin`        | `'defx'`, `'nerdtree'`                              |
`statusline_plugin`      | `'airline'`, `'lightline'`                          |
`completion_autoselect`  | `1`, `0`                                            | if equals `1`, auto select the best plugin (recommended)
`completion_plugin`      | `'deoplete'`, `'coc'`, `'ycm'`                      | only set this when `completion_autoselect` is `0`
`syntaxcheck_autoselect` | `1`, `0`                                            | if equals `1`, auto select the best plugin (recommended)
`syntaxcheck_plugin`     | `'ale'`, `'syntastic'`                              | only set this when `syntaxcheck_autoselect` is `0`
`colorscheme`            | `'solarized'`, `'molokai'`, `'jellybeans'`          | use other colorschemes in `additional_plugins` or `layers` is supported
`powerline_fonts`        | `1`, `0`                                            | requires [fonts](https://github.com/taohexxx/fonts)
`nerd_fonts`             | `1`, `0`                                            | requires [fonts](https://github.com/taohexxx/fonts)

Use `:echo g:navim_setting` in Neovim (or Vim) to check for runtime settings.

if `completion_plugin` is `'coc'`, you need to install coc extensions manually like this for the first time: `:CocInstall coc-snippets coc-highlight coc-lists`. [Using coc extensions](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions)

## Advanced Installation

### macOS

YouComplete **only** support Neovim or MacVim.

#### Install Neovim (Recommended)

```sh
pip install --upgrade pip
pip3 install --upgrade pip
pip install --user --upgrade neovim
pip3 install --user --upgrade neovim
brew tap neovim/neovim
brew update
brew reinstall --HEAD neovim
```

Make alias

```sh
alias vi='nvim'
alias vim="nvim"
alias vimdiff="nvim -d"
```

If `<C-h>` does not work in neovim, add these line to `~/.zshrc`

```sh
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
```

Execute the `:UpdateRemotePlugins` and restart Neovim.

#### Install MacVim

```sh
brew install macvim --with-luajit --override-system-vim
```

Make alias

```sh
alias vi="mvim -v"
alias vim="mvim -v"
alias vimdiff="mvim -d -v"
```

#### Install GLOBAL

```sh
brew install global
```

#### Quick Compile YouCompleteMe

##### Compile ycm_core

```sh
cd ~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/
./install.sh --all
# or
# ./install.sh --clang-completer --go-completer --js-completer
```

Check for `~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/libclang.dylib` and `~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/ycm_core.so`, done

##### TypeScript Support

```sh
yarn global add typescript
```

#### Full Compile YouCompleteMe

Try this if quick compile does not work

##### Clone

```sh
mkdir -p ~/.config/nvim/bundle/repos/github.com/Valloric/
cd ~/.config/nvim/bundle/repos/github.com/Valloric/
git clone https://github.com/Valloric/YouCompleteMe
cd YouCompleteMe/
git submodule update --init --recursive
```

##### Compile ycm_core

Download clang from <http://llvm.org/releases/download.html> to `~/local/src/` and compile ycm_core

```sh
mkdir -p ~/local/src/
cd ~/local/src/
tar xf clang+llvm-6.0.0-x86_64-apple-darwin.tar.xz
mkdir -p ~/local/src/ycm_build/
cd ~/local/src/ycm_build/
cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/local/src/clang+llvm-6.0.0-x86_64-apple-darwin . ~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
```

Check for `~/.vim/bundle/YouCompleteMe/third_party/ycmd/libclang.dylib` and `~/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so`, done

##### Compile regex (Optional)

```sh
cmake -G "Unix Makefiles" . ~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/cregex
cmake --build . --target _regex --config Release
```

Check for `~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/cregex/regex_3/_regex.so`, done

##### Go Support

```sh
cd ~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/gocode
go build
```

##### JavaScript Support

```sh
cd ~/.config/nvim/bundle/repos/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/tern_runtime
yarn install --production
```

##### TypeScript Support

```sh
yarn global add typescript
```

#### Project Configuration

Download <https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py> to your project directory

### Windows

```sh
git clone --recursive https://github.com/taohexxx/navim %userprofile%\AppData\Local\nvim
```

run `nvim.exe` before run `nvim-qt.exe`

## Plugins

*	[denite.nvim](https://github.com/Shougo/denite.nvim)
*	[unite.vim](https://github.com/Shougo/unite.vim)
*	[lightline.vim](https://github.com/itchyny/lightline.vim)
*	[lightline-buffer](https://github.com/taohexxx/lightline-buffer)
*	[deoplete](https://github.com/Shougo/deoplete.nvim)
*	[vimfiler.vim](https://github.com/Shougo/vimfiler.vim)
*	[unimpaired](https://github.com/tpope/vim-unimpaired)
*	[editorconfig](https://github.com/editorconfig/editorconfig-vim)
*	...

## Coding Style

[EditorConfig](http://editorconfig.org/) is supported.
Create an `.editorconfig` in any parent directory for consistent coding styles.

## Tags

`~/.config/nvim/tags/*.tags` will be auto added.

[Tags (`:h navim-tags`)](https://github.com/taohexxx/navim/blob/master/doc/navim.txt#L338)

## Help

[Help (`:h navim`)](https://github.com/taohexxx/navim/blob/master/doc/navim.txt)

## Credits

Built with :heart:. I wanted to give special thanks to all of the following projects and people, because I learned a lot and took many ideas and incorporated them into my configuration.

*	[spacemacs](https://github.com/syl20bnr/spacemacs)
*	[shougo](https://github.com/Shougo)
*	...

