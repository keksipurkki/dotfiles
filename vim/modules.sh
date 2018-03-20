#!/bin/bash

modules=(
  https://github.com/ekalinin/Dockerfile.vim.git
  https://github.com/scrooloose/nerdtree.git
  https://github.com/tyru/restart.vim.git
  https://github.com/SirVer/ultisnips.git
  https://github.com/bling/vim-airline.git
  https://github.com/altercation/vim-colors-solarized.git
  https://github.com/ap/vim-css-color.git
  https://github.com/hash-bang/vim-php-autolint.git
  https://github.com/hynek/vim-python-pep8-indent.git
  https://github.com/vim-scripts/TeX-9.git
  https://github.com/w0rp/ale.git
  https://github.com/pangloss/vim-javascript.git
  https://github.com/mxw/vim-jsx.git
  https://github.com/prettier/vim-prettier.git
  https://github.com/leafgarland/typescript-vim.git
)

mkdir -p pack/modules/start

for module in ${modules[@]}
do
  path=pack/modules/start/$(basename -s ".git" $module)
  if [[ -d "$path" ]]; then
    git -C $path pull
  else
    git clone $module $path
  fi
done