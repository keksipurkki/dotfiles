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
# Note to self: do not put sensitive stuff here
#
##############################################################################

# Functions
if [[ -r $HOME/Config/cli-tools/functions.sh ]]; then
  source $HOME/Config/cli-tools/functions.sh
else
  echo "No \`functions.sh' found." >&2
fi

# Plugins
source $HOME/Config/plugins/zsh-hist/zsh-hist.plugin.zsh

# Only proceed with the rest if running interactively
[[ $- != *i* ]] && return

autoload -Uz compinit && compinit
#source <(helm completion zsh)
#source <(npm completion)
eval "$(ansi_escapes)"

# Make less more friendly for non-text input files, see lesspipe(1)
if which lesspipe.sh &>/dev/null; then
  eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

# Shell options
#shopt -s histappend
#shopt -s checkwinsize
setopt PROMPT_SUBST
#history -a

# Keybindings
bindkey -e
bindkey -s '\"\"' '"^b"'

# History
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

export HISTSIZE=1000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.

{
  # Do not store typoed commands
  autoload -Uz add-zsh-hook

  command-not-found () {
    (( ? == 127 )) && hist -fs delete -1
  }

  add-zsh-hook precmd command-not-found
}

# Alias definitions

alias webshare='python3 -m http.server'
alias ..='cd ..'
alias diff="git diff --no-index"
alias curl='curl -#'
alias hdd='df -h | grep "^/dev" | sort'
alias rsync='rsync -h -P'
alias tunnelview="lsof -i4 -s TCP:LISTEN -n | awk '/^ssh/{print \$(NF-1),\$2}'"
alias yle-dl="yle-dl --vfat"
alias whereis="fd"
alias git-clean-commits='git rebase -i $(git merge-base --fork-point origin/master)'
alias ncu='ncu -t minor'
alias cert-bundle="openssl storeutl -noout -text -certs"
alias gfortran='gfortran -ffree-form'
alias ls='ls --color=always'
alias convert='magick'
alias clean_latex='rm *.aux *.out *.log'

function video_encode() {
  for video_file; do
    encoded=_$(basename ${video_file%.*}).mkv
    ffmpeg -i "$video_file" -vf scale=-1:720 -map 0 -b:v 1300k -c:v hevc_videotoolbox "$encoded"
  done
}

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
alias vim='mvim -v'
