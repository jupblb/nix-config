set fish_greeting
theme_gruvbox light hard

complete --command aws --no-files --arguments '(begin; set --local \
    --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); \
    aws_completer | sed \'s/ $//\'; end)'

if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
  exec sway
end
