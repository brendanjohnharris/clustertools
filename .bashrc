# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export LD_LIBRARY_PATH=""
export LD_PRELOAD=""
export JULIA_NUM_THREADS="auto"
alias fish=$HOME/build/fish/bin/fish
module unload gcc
module load gcc/12.1.0
export CC=gcc
module load gsl/2.3
module load binutils/2.39
module load cmake/3.21.1
module load libevent
module load tmux
module load ffmpeg/4.3.1
module load zlib/1.2.11
module load openblas/0.3.9
module load lapack/3.9.0
module load mpfr/4.0.2
module load mpc/1.1.0
module load hdf5/1.12.0
module load freeglut/3.0.0
module load ncurses/6.0
module load libqglviewer/2.7.1
# # module load qt/5.15.0
module load tk/8.6.3
module load node/14.15.4
module load julia/1.7.3
module load libffi/3.2.1
module load bison/3.8
module load gmp/6.1.2
module load cuda/8.0.44
module load python/3.9.15
module load pgsql/9.5.3
export PATH="$HOME/clustertools/:$HOME/build/glib/usr/bin:$HOME/build/glib/bin:$HOME/.local/bin/:$PATH"
#alias python="$HOME/python/bin/python3.9"
export MANPATH="$HOME/build/glib/usr/share/man:$MANPATH"

#L='/lib:/lib64:/usr/lib:/usr/lib64'
export LD_LIBRARY_PATH="$HOME/build/glib/usr/lib:$HOME/build/glib/usr/lib64:$LD_LIBRARY_PATH"

# $HOME/build/fish/bin/fish # DONT DO THIS. BREAKS SFTP

# conda activate pyjulia
test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"
