## RNA-Seq
Scripts for running Trimmomatic, Kallisto, and Sleuth.

## Install Software
Instructions for installing the software for this analysis can be found at the following links: [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic), [Kallisto](https://pachterlab.github.io/kallisto/starting), and [Sleuth](https://pachterlab.github.io/sleuth/download).

## Run Scripts
The scripts are designed to execute this analysis on a supercomputer over ssh. Files beginning with "run" contain code for executing the programs on the supercomputer. Files ending in "sbatch.sh" submit jobs to the supercomputer.

Scripts should be run in the following order:
1. trimmomatic_sbatch.sh
2. kallisto_sbatch.sh
3. sleuth_array.sh

All other scripts are called within the scripts listed above.

## Description of Scripts
**trimmomatic_sbatch.sh** submits a job to the supercomputer to run trimmomatic using **run_trimmomatic.sh**. Trimmomatic removes adapters and bad quality reads from the RNA-seq data. The output from trimmomatic is compiled in a folder called "trimmomatic_output." 
**kallisto_sbatch.sh** submits a job to the supercomputer to run kallisto using **run_kallisto.sh**. Kallisto performs a pseudoalignment of the RNA-seq reads and quantifies transcript abundances. The output from kallisto is compiled in a folder called "kallisto output."

**sleuth_array.sh** executes multiple scripts that run sleuth and perform a variety of transformations on the data.

Before running sleuth, metadata files must be written for each comparison. These files should list the samples used in each comparison and which group each of the samples belongs to (control or mutant). Data must be sorted into comparison folders. If metadata files are written properly, this can be completed using **copyData.R**.

After the data is sorted, sleuth can be run using **sleuth_script.R**. In our analysis, we were interested in fold change values, so we used a function to transform b values to fold change values. This function is executed in **sleuth_script.R**.


