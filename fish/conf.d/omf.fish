# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

# variables
# set -x GOPATH=$HOME/dev/go
# set -x PATH=$PATH:/usr/local/dev/go/bin
# set -x PATH=$PATH:/home/chris/.config/polybar
set -x PATH {/bin,/usr/bin,/home/chris/.dotfiles,/home/chris/.emacs.d/bin}
set -x QT_QPA_PLATFORMTHEME "qt5ct"
set -x EDITOR "emacsclient -a emacs"
set -x TERM alacritty

# aliases
alias ls="lsd -a"
alias rfi="/home/chris/.dotfiles/rofi/launchers-git/launcher.sh"
