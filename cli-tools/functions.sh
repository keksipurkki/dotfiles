#!/bin/bash
# @file
# @author Elias Toivanen

# @section LICENSE
# Copyright (c) 2016 Elias Toivanen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
# ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
# ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
# ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
# ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
# ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
# ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
# ▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌
# ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌
# ▐░░░░░░░░░░▌ ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▀▀▀▀▀▀▀▀▀▀   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀
#
#  ...rules everything around me...$$ is the PID ya!


# @brief POST a JSON file to an URL with curl
#
# @param JSON file
# @param An url
# @param opts, arguments passed to curl
#
function post_json
{
  local json=$1
  shift
  local endpoint=$1
  shift
  curl "$@" --header "Content-Type: application/json" -k -X POST\
    --data-binary @$json \
    "$endpoint"

}

# @brief PUT a JSON file to an URL with curl
#
# @param JSON file
# @param An url
# @param opts, arguments passed to curl
#
function put_json
{
  local json=$1
  shift
  local endpoint=$1
  shift
  curl "$@" --header "Content-Type: application/json" -k -X PUT\
    --data-binary @$json \
    "$endpoint"

}

function iface
{
  if [[ $(uname) == "Linux" ]]; then
    route -n | awk '$1 ~ /0.0.0.0/ {print $NF}'
  elif [[ $(uname) == "Darwin" ]]; then
    route get 0.0.0.0 2>/dev/null | awk '/interface: / {print $2}';
  fi
}

# @brief Print your local/public IP address
#
# @option -p Print the public IP address
#
function myip
{
  if [[ $# = 1 && $1 = '-p' ]]; then

    dig +short myip.opendns.com @resolver1.opendns.com

  else

    iface=$(iface)

    if which ipconfig &> /dev/null; then
      ipconfig getifaddr $iface
      return
    fi

    if which ifconfig &> /dev/null; then
      ifconfig $iface | grep -o 'inet addr:[^ ]\+ ' | cut -d: -f2
      return
    fi

  fi
}

# @brief Wrap each line on stdin with a string
function wrap
{
  local char=$1
  while read line
  do
    printf "$char%s$char\n" "$line"
  done
}

# @brief quote all lines on stdin
function quote_it
{
  wrap "${1:-\"}"
}

# @brief Trims stdin
#
# @param character
function unquote_it
{

  local char=$1

  while read line
  do
    line="${line%$char}"
    line="${line#$char}"
    printf "%s\n" "$line"
  done

}

# @brief url decode each line on stdin
function urldecode
{
  python -c "import urllib, sys; print urllib.unquote(sys.stdin.read()),"
}

# @brief url encode each line on stdin
function urlencode
{
  python -c "import urllib, sys; print urllib.quote(sys.stdin.read(), '\n\/'),"
}

# @brief find all matches
function findall
{
  python -c 'import re, sys; print re.findall("'$1'", sys.stdin.read())'
}

# @brief Print the HTTP status code of a server response
#
# @param url
function http_status
{
  local url=$1
  local code=$(curl -sL -o /dev/null -I -w "%{http_code}" "$url")
  printf '%d "%s"\n' $code "$url"
}

# @brief Represent a byte count in human readable form
#
# @param number of bytes
#
# Reference: Camilo Martin,
# http://unix.stackexchange.com/questions/44040/a-standard-tool-to-convert-a-byte-count-into-human-kib-mib-etc-like-du-ls1
function bytes_to_human
{
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    let s++
  done
  echo "$b$d ${S[$s]}"
}

# @brief Compute and print the size of stdin
#
# @option -g Print the compressed size (gzip)
function sizeof
{
  if [[ "$1" == '-g' ]]; then
    bytes_to_human $(gzip | wc -c)
  else
    bytes_to_human $(wc -c)
  fi
}

# @brief Join the argument list with a separator
#
# @param A separator character
# Reference: http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
function join
{
  local IFS="${1:-$IFS}"
  shift
  echo "$*"
}

# @brief colorize a pattern in the output stream
#
function highlight {
  local pattern=$1
  "grep" -E --color=always "${pattern}|$"
}

# @brief Prefix a command line with __ to copy the output of the command to the clipboard
#
# @usage __ ls # Now clipboard contains the output of ls
#
# Mac OSX specific
function __
{
  if which pbcopy &> /dev/null && (( $# )); then
    $* | tee /dev/stderr | pbcopy
  fi
}

# @brief Upload a file to a pastebin service (ix.io)
function pastebin
{
  cat $@ | curl -sF 'f:1=<-' ix.io
}

# @brief Binds the MySQL port (3306) of a remote server to localhost
#
# @param The remote server
# @param The local port (Default: 33306)
#
function mysql_to_localhost
{
  local server=${1}
  local local_p=${2:-33306}
  local remote_p=3306
  ssh -f -N \
    -o ControlMaster=no \
    -o ExitOnForwardFailure=yes \
    -o ConnectTimeout=10 \
    -o NumberOfPasswordPrompts=3 \
    -o TCPKeepAlive=no \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=1 \
    "$server" -L $local_p/127.0.0.1/$remote_p
}


# @brief Download a list of URLs in parallel (8 files at a time)
#
# See `man wget` for the wget options
function parallel_download
{
  echo "$@" | xargs -n 1 -P 8 wget -t 1 -x -nc
}

# @brief A convenience shim for sshfs (https://github.com/libfuse/sshfs)
#
# Mounts remote directories under ~/Remote in suitable subdirectories
#
# @usage sshfs SERVER:REMOTE_DIRECTORY # ~/Remote/SERVER_REMOTE_DIRECTORY
#
function sshfs
{
  local src=$1
  local folder=$(basename "${src##*:}")
  local hostname=${src%:*}  # strip path
  local sshfs_=

  [[ -n "$folder" ]] && folder=_$folder

  hostname=${hostname#*@} # strip user name
  mkdir -p $HOME/Remote/${hostname}${folder}
  shift

  sshfs_=$(\which sshfs)
  if [[ $(uname) == Darwin ]]; then
    opts=" -o volname=${hostname}${folder}"
  else
    opts=
  fi

  $sshfs_ $src $HOME/Remote/${hostname}${folder} $* $opts

}

# @brief list established SSH connections
function lsssh
{
  lsof -i4 -s TCP:ESTABLISHED -n | grep '^ssh' | while read conn
do
  ip=$(echo $conn | grep -oE '\->[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[^ ]+')
  ip=${ip/->/}
  domain=$(dig -x ${ip%:*} +short)
  domain=${domain%.}
  # display nonstandard port if relevant
  printf "%s (%s)\n" $domain  ${ip/:ssh}
done | column -t
}

# @brief Print a pile of poo if the current tree is dirty
# Requires an unicode shell and an emoji-enabled desktop enviroment
# See https://www.google.com/get/noto/#emoji-qaae-color for an emoji font
function git_dirty
{
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  if test -n "$(git status --porcelain 2> /dev/null)"; then
    echo -e '[\xF0\x9F\x92\xA9]'
  fi
}


# @brief Name of the current git branch
function git_branch
{
  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  [[ -n "$branch" ]] && printf "[%s]" $branch
}

# @brief A good looking git-aware prompt
# example usage: export PS1="$(git_prompt)"
function git_prompt
{
  printf "\$(git_dirty)\$(git_branch)"
}

function git_sed
{
  git ls-files -z | xargs -0 sed -i -e $@
}

function git_browse
{
  bash $(dirname $BASH_SOURCE)/git_browse $@
}

# http://stackoverflow.com/a/16509364/4301632
function fast_chr
{
  local __octal
  local __char
  printf -v __octal '%03o' $1
  printf -v __char \\$__octal
  REPLY=$__char
}

# unichr 0x1f600 -> :-) emoji
function unichr
{
  local c=$1    # Ordinal of char
  local l=0    # Byte ctr
  local o=63    # Ceiling
  local p=128    # Accum. bits
  local s=''    # Output string

  (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

  while (( c > o )); do
    fast_chr $(( t = 0x80 | c & 0x3f ))
    s="$REPLY$s"
    (( c >>= 6, l++, p += o+1, o>>=1 ))
  done

  fast_chr $(( t = p | c ))
  echo -n "$REPLY$s"
}

# @brief print all emojis
function emojis
{
  for char in $(seq 0x1f600 0x1f64f); do
    printf "0x%x %s\n" $char $(unichr $char)
  done
}

# @brief
# A cryptographically sound pseudo-random password generator
# https://www.2uo.de/myths-about-urandom/
function generate_password()
{
  head -c64 /dev/urandom | base64 | head -c 32 ; echo
}


# @brief
# The ANSI terminal escape codes
# Used for coloring the prompt and the like
function ansi_escapes()
{
  cat << EOF
    RESTORE='\[\033[0m\]'
    RED='\[\033[00;31m\]'
    GREEN='\[\033[00;32m\]'
    YELLOW='\[\033[00;33m\]'
    BLUE='\[\033[00;34m\]'
    PURPLE='\[\033[00;35m\]'
    CYAN='\[\033[00;36m\]'
    LIGHTGRAY='\[\033[00;37m\]'
    LRED='\[\033[01;31m\]'
    LGREEN='\[\033[01;32m\]'
    LYELLOW='\[\033[01;33m\]'
    LBLUE='\[\033[01;34m\]'
    LPURPLE='\[\033[01;35m\]'
    LCYAN='\[\033[01;36m\]'
    WHITE='\[\033[01;37m\]'
EOF
}

# @brief
# Poor man's disk clean up routine for MacOS
function clean_my_macos()
{
    echo "Pruning simulators"
    du -sh $HOME/Library/Developer/CoreSimulator/
    xcrun simctl delete unavailable
    du -sh $HOME/Library/Developer/CoreSimulator/

    echo "Pruning Homebrew"
    if which brew > /dev/null; then
        brew cleanup
    fi

    # More to come
}

# @brief
# RSA decrypt/encrypt
function rsa_decrypt()
{
  local encrypted=${1?}
  local secret_key=${2?}
  openssl rsautl -oaep -decrypt -in "$encrypted" -inkey "$secret_key"
}

function view_certificate ()
{
  openssl s_client -showcerts -connect $1:443
}
