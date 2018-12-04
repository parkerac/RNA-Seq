#!/bin/bash
#SBATCH --time=00:10:00       # walltime
#SBATCH --ntasks=1            # number of processor cores (i.e. tasks)
#SBATCH --nodes=1             # number of nodes
#SBATCH --mem-per-cpu=128G    # memory per CPU core
#SBATCH -J "Visualize"       # job name
#SBATCH --array=1-15         # job array 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

Rscript ~/compute/roundTwoAnalysis/scripts/make_volcano.R ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/make_heatmap.R ${SLURM_ARRAY_TASK_ID}

