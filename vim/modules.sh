#!/bin/bash

modules=(
  https://github.com/ekalinin/Dockerfile.vim.git
  "https://github.com/neoclide/coc.nvim.git#release"
  https://github.com/scrooloose/nerdtree.git
  https://github.com/tyru/restart.vim.git
  https://github.com/bling/vim-airline.git
  https://github.com/altercation/vim-colors-solarized.git
  https://github.com/ap/vim-css-color.git
  https://github.com/hash-bang/vim-php-autolint.git
  https://github.com/hynek/vim-python-pep8-indent.git
  https://github.com/vim-scripts/TeX-9.git
  https://github.com/pangloss/vim-javascript.git
  https://github.com/prettier/vim-prettier.git
  https://github.com/leafgarland/typescript-vim.git
  https://github.com/peitalin/vim-jsx-typescript
  https://github.com/editorconfig/editorconfig-vim.git
  https://github.com/kballard/vim-swift.git
  https://github.com/vim-scripts/confluencewiki.vim.git
  https://github.com/modille/groovy.vim
)

mkdir -p pack/modules/start

for module in ${modules[@]}
do
  path=pack/modules/start/$(basename -s ".git" $module)
  if [[ -d "$path" ]]; then
    git -C $path pull
  else
    IFS='#' read  url branch <<< "$module"
    git clone -b ${branch-master} $url $path
  fi
done
