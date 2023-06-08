Some hacks for using the USyd Artemis cluster.

# Basics
SSH into the cluster with:
```bash
ssh -X <unikey>@hpc.sydney.edu.au
```

## Project storage 
The storage on the home remote filesystem is fairly limited. Extra storage is available at:
```bash
cd /project/<projectname>/
```
Luckily, you can symlink folders from project storage to home:
```bash
ln -s /project/<projectname>/<folder>/ /home/<unikey>/<folder>
```
This symlink method allows data folders to be housed in project storage but referred to from the home filesystem

## Initializing this repo
To set up the cluster filesystem and make use of this repo, run these few commands:
```bash
git clone https://github.com/brendanjohnharris/clustertools ~/clustertools
mkdir ~/build 
mkdir ~/code
mkdir ~/jobs
chmod u+x ~/clustertools/* # Make files in the repo executable
cp ~/clustertools/.bashrc ~/.bashrc # Probably back up your .bashrc first
source ~/.bashrc
```
So far we shouldn't require github authentication, but if you end up cloning a private repo you will need to do so with:
```bash
git config --global credential.helper cache
git push https://brendanjohnharris:<githubtoken>@github.com/brendanjohnharris/clustertools
```
where `<githubtoken>` is a github personal access token. It will be cached on the cluster, so future gitwork won't require a password.

## Submitting jobs
Most jobs are submitted using PBS scrips. You can submit the test job included in this repo with:
```bash
qsub ~/clustertools/PBS_interactive.pbs
```
You will have to edit the project name (DCOM) and the email to suit your system
This will spit the jobid back at you, or else an error.

### Job scripts
1) This script has a few parts. The first part, the shebang, specifies which shell the file should be executed with:
```bash
#!/bin/bash
```

2) Following this are the job flags:
```bash
#PBS -P DCOM                          # The name of the project recorded with Artemis, DCOM for me
#PBS -l select=1:ncpus=16:mem=48GB    # Start the job using 16 cores from 1 machine with 48 GB of memory
#PBS -l walltime=24:00:00             # Let the job run for at most 24 hours
#PBS -o ./jobs/PBS_interactive.o      # The path to the output file, writing stdout once the job has finished
#PBS -j oe                            # An option to merge stdout with error messages
#PBS -M bhar9988@uni.sydney.edu.au    # An email to notify once the job has completed
#PBS -m ae                            # An option to send an email when the job is either aborted or terminates
```

3) Before we navigate to the home folder and announce where we are to `stdout` :
```bash
cd $PBS_O_WORKDIR
echo $PBS_O_WORKDIR
```

4) The next few lines are required to point the job's shell to custom-build libraries. We'll get to those later:
```bash
# Custom compiled libraries required for julia packages to build properly
export PATH="$HOME/build/glib/usr/bin:$HOME/build/glib/bin:$PATH"
export MANPATH="$HOME/build/glib/usr/share/man:$MANPATH"
export LD_LIBRARY_PATH="$HOME/build/glib/usr/lib:$HOME/build/glib/usr/lib64:$LD_LIBRARY_PATH"
```

5) Finally, we run some command on the cluster. This dummy command does nothing, but keeps the job alive (the job terminates once all commands have completed):
```bash
sleep infinity
```

## Monitoring jobs
To get a list of your currently running jobs, and jobs in the queue, use:
```bash
qstat -u bhar9988 -n1
```
The `-u` flag specifies a user, and `-n1` specifies we want the name of the node each job is running on printed on the same line as the job.
To see the output of a specific command in job whilst it is running, you redirect the output of the command with:
```bash
# ....PBS flags go here, we are in a job script...
<some command like `pwd` or `julia afile.jl`> | tee ./jobs/${PBS_JOBID}.log
```
Then monitor the job output in real time with:
```bash
tail -f <jobid>.pbsserver.log
```
To make this even easier, I've included a little script in this repo: running`monitor` rolls the output of the most recently submitted job (or a job of your choosing). Make sure to edit it to suit your unikey and filesystem.

## Killing jobs
When it comes time to cull the weak, you can kill a specific job using:
```bash
qdel <jobid>
```
To commit genocide and kill _all_ your running and queued  jobs, use:
```bash
qselect -u <unikey> | xargs qdel
```
`qselect` returns job id's of the specified user, and xargs passes those id's individually onto the `qdel` commands 

# Custom software
Although the cluster has many programs available as modules, most of these are related to specific computing tasks and don't make general QOL on the cluster any better.
In some cases, though, we are able to build custom software from source. 
To begin, create a user directory for our custom software:
```bash
mkdir ~/build
cd ~/build
```

## Fish shell
A nice shell that includes features such as auto-suggestion and history searching.

### Installation
```bash
mkdir ~/build/fish
cd ~/build/fish
wget https://github.com/fish-shell/fish-shell/releases/download/2.6.0/fish-2.6.0.tar.gz
tar -xf fish-2.6.0.tar.gz
cd ~/build/fish/fish-2.6.0
./configure --prefix=$HOME/build/fish
make
make install
```

My .bashrc file also has a line adding an alias for fish, so to start fish after login:
```bash
fish
```

## glib
Many Julia packages require a version of glib that isn't as ancient as the one installed on the cluster's CentOS distribution. Building it manually is a necessary evil. It requires specific versions of many modules (such as bison, binutils, cmake) but I've included these in my `.bashrc`. To install glib:
```bash
mkdir ~/build/glib
yumdownloader --destdir ~/build/glib/ --resolve glib2-2.28.8-9.el6
rpm2cpio ~/build/glib/glib2-2.28.8-9.el6.x86_64.rpm | cpio -id
```

We also require pointing Julia to our custom-build shared libraries, but once again I've taken care of that in my `/.bashrc`.

# Supercharged interactive jobs
You can start a regular interactive job with:
```fish
qsub -IP <project> -l select=1:ncpus=1:mem=16GB,walltime=2:00:00
```
This will drop you into a shell on a compute node.
Interactive jobs are alright, but they only last for 2 hours max. Not so useful if you have long-running commands that you'd like to return to later on.

To use a regular job, which can be run for any amount of time, with greater resources, in an interactive way, you submit start the `PBS_interactive.pbs` script that I include in this repo. This will start a persistent job that you can ssh into.
To do so easily, add the following lines to your _local_ `~/.ssh/config`(and change the username from `bhar9988`):
```bash
# ~/.ssh/config
Host hpc.sydney.edu.au
	HostName hpc.sydney.edu.au
	User bhar9988
	ForwardX11 yes
	ForwardX11Trusted yes

Host hpc* !hpc.sydney.edu.au
	ForwardX11 yes
	ProxyCommand ssh -W %h:%p hpc.sydney.edu.au
	HostKeyAlgorithms=+ssh-dss
	User bhar9988
	ForwardX11 yes
	ForwardX11Trusted yes
```
If the remote supports gateway, like the physics cluster, you can use:
```
Host headnode.physics.usyd.edu.au
	HostName headnode.physics.usyd.edu.au
	ForwardAgent yes
	ForwardX11Trusted Yes
	ProxyJump bhar9988@gateway.physics.usyd.edu.au
	User bhar9988
```

Now you should be able to, in a local terminal, go:
```bash
ssh <node name, such as hpc183>
```
You will be asked to enter a password twice: once to log in to headnode, once to log in to the job node. All going well, you will also have X forwarding: test it by running `xterm`.

## VSCode SSH
It's possible and a great idea, to set up vscode via ssh on the physics cluster. The commands for this are self-explanatory (`ctrl + p : add remote host` in vscode), but make sure you have set up ssh key pairs for passwordless login between your local machine and headnode, your local machine and physics, and gateway and headnode.

### tmux is a beautiful thing
If you ssh into a supercharged interactive job, then exit, the current terminal session is killed. This means you can't leave a script running without having a local terminal open.
Unless...
```bash
tmux # Create a new tmux session
```
This command creates a persistent terminal session. You can log out of the cluster, come back, then:
```bash
tmux attach
```
to return where you left off.
Some useful shortcuts are: 
- `ctrl+b d`: detach from the current terminal
- `ctrl+b [`: step out of the current terminal control so you can e.g. scroll. Step back in to the terminal with `q`
- `ctrl+b s`: see a list of tmux sessions, and switch between them

# Internet in jobs

If you cannot access internet inside a job, add the following lines to your .cshrc (or equivalent lines for bash) to set up a socks5 proxy that forwards *most* internet traffic through an ssh connection with headnode (where, presumable, you have internet access):
```
if(`hostname`:q =~ node*) then
	ssh -D 8080 -f -C -q -N bhar9988@headnode
	setenv http_proxy "socks5h://0:8080"
	setenv https_proxy "socks5h://0:8080"
endif
```

# Display forwarding
It's possible to have applications forward their display output to the local machine, but it's finicky.
In the simplest case, you should `ssh` to the headnode with `ssh -X bhar9988@uni.sydney.edu.au`. This will forward the display of the headnode to your local machine, meaning you can do `xterm` and have the application open locally.

## Viewing plots in Julia 
`Plots.jl` with the GR backend displays and forwards plot outputs like a charm. `CairoMakie.jl` can save plots, but can't display them out of the box. `GLLMakie.jl` is just broken, we have no way of installing OpenGL/LibATK-bridge.

There is a way, however, to get CairoMakie plots to display in a GTK window (thankfully GTK works). Install `GTK.jl` and `CairoMakie.jl`, then:
```bash
using Gtk
using CairoMakie
using Foresight # www.github.com/brenndanjohnharris/Foresight.jl
f = plot(sin.(0.1:1.1:10));
gtkshow(f)
```
All going well, the last line should not be necessary if you load `Gtk` before loading `Foresight`.

# Coding locally 
Although you can do some simple edits to files on the cluster using vim (from the terminal) and emacs (with X display forwarding), for anything more substantial you should probably use Visual Studio Code. Unfortunately, this can't be installed on the cluster because of it's archaic CentOS 6 distribution.
The next best thing (which also has a bunch of other uses, like file transfer) is to make the remote/cluster file system locally accessible. This allows you to:
- See remote files on your local machine, as though they were local files 
- Have edits transfer directly to files on the cluster 
- Edit remote files in your favourite IDE
- Read (not just transfer) large files from project storage
To wormhole into the remote storage from the local fiesystem, use:
```bash
sshfs -o follow_symlinks <unikey>@hpc.sydney.edu.au:/home/<unikey> ~/Artemis/
```
This uses the package `sshfs`, which must be installed locally, and gives access to the remote filesystem at the local directory `~/Artemis/`.

# Submitting all scripts in a folder
This repo also contains a little script that lets you submit all Julia scripts in a given directory into different jobs. 
This uses a template job script, `PBS_julia.pbs`, in which you can set parameters such as the walltime and requested cpus.
To use this script, simply:
```bash
submitall /path/to/directory/
```
