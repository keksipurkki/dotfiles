##############################################################################
#
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
##############################################################################
#
# 2018-03-18
#
# Note to self: do not put sensitive stuff here
#
##############################################################################

# Functions
if [[ -r $(dirname $BASH_SOURCE)/cli-tools/functions.sh ]]; then
  source $(dirname $BASH_SOURCE)/cli-tools/functions.sh
else
  echo "No \`functions.sh' found." >&2
fi

# Only proceed with the rest if running interactively
[[ $- != *i* ]] && return

eval "$(ansi_escapes)"

# More goodies
if [[ -r /usr/local/etc/bash_completion ]]; then
  source /usr/local/etc/bash_completion
fi

# Make less more friendly for non-text input files, see lesspipe(1)
if which lesspipe.sh &>/dev/null; then
  eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

# Shell options
shopt -s histappend
shopt -s checkwinsize
history -a

# Keybindings
bind '"\e[A":  history-search-backward'
bind '"\e[B":  history-search-forward'
bind '"\"\"":"\"\C-b\""'

# Alias definitions

alias webshare='python3 -m http.server'
alias ..='cd ..'
alias diff="git diff --no-index"
alias curl='curl -#'
alias hdd='df -h | grep "^/dev" | sort'
alias rsync='rsync -h -P'
alias tunnelview="lsof -i4 -s TCP:LISTEN -n | awk '/^ssh/{print \$(NF-1),\$2}'"
alias mplayer='mplayer -nolirc'
alias yle-dl="yle-dl --vfat"
alias whereis="fd"

# Mac OSX-only aliases
if [[ "$(uname)" = Darwin ]]; then
  alias tar='COPYFILE_DISABLE=true tar'
fi

# The do-it-all vim wrapper -- use `vi' to edit all kinds of files
#
# A convenience function behaving just the way I like
#
# Open files in graphical editor if it's possible but also behave nicely
# in a purely virtual console environment.
#
# If GUI_EDITOR is defined in the environment, it is used as the editor in
# graphical model.
unalias vi &> /dev/null
vi ()
{

  local vim=""
  local args=()

  vim=$(which vim 2> /dev/null)
  vim=${vim:-$(which vi)}

  if ! tty &> /dev/null || [[ "$@" = - ]]; then

    # Reading from stdin. Start in RO mode and discard custom configuration files
    args+=("-c" "runtime! macros/less.vim" "--cmd" "let no_plugin_maps=1")

  elif [[ -n "$DISPLAY" || $(uname) = Darwin ]]; then

    vim=${GUI_EDITOR:-"mvim"}
    if (( $# > 0 )); then # Open files in tabs
      args+=("--remote-tab-silent")
    fi

  fi

  set -- "${args[@]}" "$@"
  $vim "$@"

}

unset PROMPT_COMMAND
export PROMPT_COMMAND="echo -ne \"\033]0;\$PWD (on \$HOSTNAME)\007\""