#!/bin/bash

prefix=com.github

modules=(
  "https://github.com/pangloss/vim-javascript.git"
  "https://github.com/ekalinin/Dockerfile.vim.git"
  "https://github.com/scrooloose/nerdtree.git"
  "https://github.com/tyru/restart.vim.git"
  "https://github.com/bling/vim-airline.git"
  "https://github.com/ap/vim-css-color.git"
  "https://github.com/hash-bang/vim-php-autolint.git"
  "https://github.com/keksipurkki/TeX-9.git"
  "https://github.com/prettier/vim-prettier.git"
  "https://github.com/editorconfig/editorconfig-vim.git"
  "https://github.com/vim-scripts/confluencewiki.vim.git"
  "https://github.com/modille/groovy.vim"
  "https://github.com/PProvost/vim-ps1.git"
  "https://github.com/clojure-vim/clojure.vim.git"
  "https://github.com/yegappan/lsp.git#main"
)

mkdir -p pack/$prefix/start

for module in ${modules[@]}
do
  IFS='#' read url branch <<< "$module"

  path=pack/$prefix/start/$(basename -s ".git" $url)
  branch=${branch:-master}

  if [[ -d "$path" ]]; then
    git -C $path pull
  else
    git clone -b ${branch} $url $path
  fi

done
