#!/bin/bash

#SBATCH --time=04:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16G   # memory per CPU core
#SBATCH -J "Kallisto"   # job name
#SBATCH --mail-user=alyssaparker2000@gmail.com   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch
export PATH=$PATH:/fslhome/parkerac/kallisto_bin/bin

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

#cd ~
#kallisto index -i compute/transcripts.idx compute/gencode.v28.transcripts.fa

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
#cd compute/complete_download 

FILES=($(ls ~/compute/roundTwoAnalysis/trimmomatic_output/*_paired_output.fastq.gz))
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
FILENAME2=${FILES[$(($SLURM_ARRAY_TASK_ID+1))]}
OUTNAME=$(echo ${FILENAME} |cut -d '/' -f 7)
OUTNAME=$(echo ${OUTNAME} | cut -d '.' -f 1)

echo "Starting ${FILENAME}"
kallisto quant -i ~/compute/transcripts.idx -o ~/compute/roundTwoAnalysis/kallisto_output/${OUTNAME} --genomebam --gtf ~/compute/gencode.v28.annotation.gtf.gz -b 100 ${FILENAME} ${FILENAME2}
echo "Finished ${FILENAME}"
