## RNA-Seq
Scripts for running Trimmomatic, Kallisto, and Sleuth.

## Install Software
Instructions for installing the software for this analysis can be found at the following links: [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic), [Kallisto](https://pachterlab.github.io/kallisto/starting), and [Sleuth](https://pachterlab.github.io/sleuth/download)

## Run Scripts
The scripts are designed to execute this analysis on a supercomputer over ssh. Files beginning with "run" contain code for executing the programs on the supercomputer. Files ending in "sbatch.sh" submit jobs to the supercomputer.

Scripts should be run in the following order:
1. trimmomatic_sbatch.sh
2. kallisto_sbatch.sh
3. sleuth_array.sh

All other scripts are called within the scripts listed above.
