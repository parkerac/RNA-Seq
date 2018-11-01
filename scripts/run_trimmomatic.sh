#!/bin/bash

#SBATCH --time=10:00:00   # walltime
#SBATCH --ntasks=4   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16G   # memory per CPU core
#SBATCH -J “Trimmomatic”   # job name
#SBATCH --mail-user=alyssaparker2000@gmail.com   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

FILES=($(ls ~/compute/roundTwoAnalysis/FASTQ_data/*.gz))
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
FILENAME2=${FILES[$(($SLURM_ARRAY_TASK_ID+1))]}
OUTNAME=$(echo ${FILENAME} | cut -d '.' -f 1)
OUTNAME2=$(echo ${FILENAME2} | cut -d '.' -f 1)
OUTNAME=$(echo ${OUTNAME} | cut -d '/' -f 7)
OUTNAME2=$(echo ${OUTNAME2} | cut -d '/' -f 7)

echo "Starting ${FILENAME}"
java -jar $HOME/compute/Trimmomatic-0-2.38/trimmomatic-0.38.jar PE -phred33 ${FILENAME} ${FILENAME2} $HOME/compute/roundTwoAnalysis/trimmomatic_output/${OUTNAME}_paired_output.fastq.gz $HOME/compute/roundTwoAnalysis/trimmomatic_output/${OUTNAME}_unpaired_output.fastq.gz $HOME/compute/roundTwoAnalysis/trimmomatic_output/${OUTNAME2}_paired_output.fastq.gz $HOME/compute/roundTwoAnalysis/trimmomatic_output/${OUTNAME2}_unpaired_output.fastq.gz ILLUMINACLIP:$HOME/compute/Trimmomatic-0-2.38/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:14 MINLEN:36  
echo "Finished ${FILENAME}"
