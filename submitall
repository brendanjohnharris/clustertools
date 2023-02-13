#!/bin/bash
targetdir=$1
directory=$(dirname -- "$0")
for file in "$targetdir"/*.jl; do
  echo "$file"
  cp "$directory/submitjob.pbs" "$targetdir/_submitjob.pbs"
  sed -i "s|xxxFILExxx|$file|g" "$targetdir/_submitjob.pbs"
  qsub -P DCOM -l select=1:ncpus=16:mem=48GB -l walltime=24:00:00 -o $HOME/jobs/PBS_julia.o -j oe -M bhar9988@uni.sydney.edu.au -N $(basename $file) -m ae "$targetdir/_submitjob.pbs"
  rm "$targetdir/_submitjob.pbs"
done