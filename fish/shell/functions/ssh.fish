# SYNOPSIS
#   ssh [arguments]
#
# USAGE
#   ssh-term-helper overloads the 'ssh' command and changes the
#   value of $TERM to a conservative setting present in most
#   termcap files. Any arguments are passed directly to the ssh
#   command.
#

function ssh -d "OpenSSH SSH client (remote login program) with a conservative $TERM value"
  set -lx TERM xterm
  command ssh $argv
end