# Modify the terminal's 256 color palette to use the gruvbox theme
set -l GRUVBOX_SCRIPT ~/.vim/pack/gruvbox/gruvbox_256palette.sh
if test -f $GRUVBOX_SCRIPT
    $GRUVBOX_SCRIPT
end