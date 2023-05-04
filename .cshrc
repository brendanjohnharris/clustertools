# @(#)cshrc 1.11 89/11/29 SMI
#
# Call system cshrc file

source /etc/cshrc

# Users may add customisation below

limit coredumpsize 0
umask 022
set filec
module load pbspro

set prompt="`hostname -s`:`dirs`> "
alias cd 'cd \!*;set prompt="`hostname -s`:`dirs`> "'
alias julia '$HOME/build/julia-1.8.2/bin/julia -t auto'
alias fish '$HOME/build/fish/fish'
alias code '$HOME/build/vscode/bin/code'
# Printers on Linux Workstations
#@ setenv PRINTER `more < ~/.default_printer`
#@ setenv LWPRINTER `more < ~/.default_printer`
#@ setenv LPDEST `more < ~/.default_printer`

setenv LD_LIBRARY_PATH ""
setenv LD_PRELOAD ""
setenv JULIA_NUM_THREADS "auto"

setenv TERM vt100
#exec $HOME/build/fish/fish
