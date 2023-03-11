# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export LD_LIBRARY_PATH=""
export LD_PRELOAD=""
export JULIA_NUM_THREADS="auto"
alias fish=$HOME/build/fish/bin/fish
# User specific aliases and functions
module load freeglut/3.0.0
module load ncurses/6.0
module load libqglviewer/2.7.1
module load qt/5.9.9
module load tk/8.6.3
module load node/14.15.4
module load julia/1.7.3
module load libffi/3.2.1
#module load glib/2.34.0
module load hdf5/1.8.16
module load python/3.7.7
module load bison/3.8
module load gmp/6.1.2
module load binutils/2.26
# module load gcc/5.4.0
module load gcc/12.1.0
module load binutils/2.39
module load cmake/3.21.1
module load tmux
module load ffmpeg/4.3.1
module load zlib/1.2.11
module load cuda/8.0.44
module load matlab/R2019a
#module load jupyter/base

export PATH="$HOME/clustertools/:$HOME/build/glib/usr/bin:$HOME/build/glib/bin:$PATH"

export MANPATH="$HOME/build/glib/usr/share/man:$MANPATH"

#L='/lib:/lib64:/usr/lib:/usr/lib64'
export LD_LIBRARY_PATH="$HOME/build/glib/usr/lib:$HOME/build/glib/usr/lib64:$LD_LIBRARY_PATH"

# $HOME/build/fish/bin/fish # DONT DO THIS. BREAKS SFTP


test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"
