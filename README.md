# Dotfiles

## Set up (macOS)

```sh

git clone https://github.com/keksipurkki/dotfiles.git $HOME/Config

cat >> $HOME/.profile << "EOF"

export DOTFILES=$HOME/Config
export MYVIMRC=$DOTFILES/vim/vimrc
export VIMINIT="source $MYVIMRC"
export TIGRC_USER=$DOTFILES/tigrc
source $DOTFILES/bashrc

EOF

```
