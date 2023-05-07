#! /bin/csh
# @(#)cshrc 1.11 89/11/29 SMI
#
# Call system cshrc file

source /etc/cshrc

# Users may add customisation below

limit coredumpsize 0
umask 022
set filec
module load pbspro
module load Anaconda3-5.1.0

set prompt="`hostname -s`:`dirs`> "
alias cd 'cd \!*;set prompt="`hostname -s`:`dirs`> "'
#alias julia '$HOME/build/julia-1.8.2/bin/julia -t auto'
#alias fish '$HOME/build/fish/fish'
#setenv PATH /headnode2/bhar9988/build/fish/:$PATH
alias code '$HOME/build/vscode/code --no-sandbox'
# Printers on Linux Workstations
#@ setenv PRINTER `more < ~/.default_printer`
#@ setenv LWPRINTER `more < ~/.default_printer`
#@ setenv LPDEST `more < ~/.default_printer`

setenv LD_LIBRARY_PATH ""
setenv LD_PRELOAD ""
setenv JULIA_NUM_THREADS "auto"

#setenv TERM vt100
#exec $HOME/build/fish/fish
#setenv PATH "/usr/physics/python/anaconda3/bin:$PATH"
#. $HOME/.conda/setup
#conda activate bhar9988
setenv CONDA_DEFAULT_ENV "bhar9988"
setenv PATH /headnode2/bhar9988/.conda/envs/bhar9988/bin:$PATH
exec fish -l
