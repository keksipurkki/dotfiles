# Dotfiles

## Set up (macOS)

```sh

git clone https://github.com/keksipurkki/dotfiles.git $HOME/Config

cat >> $HOME/.zprofile << "EOF"

export DOTFILES=$HOME/Config

# Environment variables
# export EDITOR='mvim -v'
# ...
#

source $DOTFILES/zshrc
source $DOTFILES/git-prompt.sh

EOF
```
