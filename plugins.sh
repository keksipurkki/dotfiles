#!/bin/bash

prefix=com.github

plugins=(
  "https://github.com/marlonrichert/zsh-hist.git"
)

mkdir -p plugins

for plugin in ${plugins[@]}
do
  IFS='#' read url branch <<< "$plugin"

  path=plugins/$(basename -s ".git" $url)
  branch=${branch:-main}

  if [[ -d "$path" ]]; then
    git -C $path pull
  else
    git clone -b ${branch} $url $path
  fi

done
