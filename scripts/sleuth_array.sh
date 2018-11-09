#!/bin/bash
#SBATCH --time=02:00:00       # walltime
#SBATCH --ntasks=1            # number of processor cores (i.e. tasks)
#SBATCH --nodes=1             # number of nodes
#SBATCH --mem-per-cpu=128G    # memory per CPU core
#SBATCH -J "Sleuth"       # job name
#SBATCH --array=1-15         # job array 

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch
export PATH=$PATH:/fslhome/parkerac/kallisto_bin/bin

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE

Rscript ~/compute/roundTwoAnalysis/scripts/copyData.R ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/sleuth_script.R ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/create_abundance_table.R ${SLURM_ARRAY_TASK_ID}
python3 ~/compute/roundTwoAnalysis/scripts/convert_to_symbols.py ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/gage_script.R ${SLURM_ARRAY_TASK_ID}
python3 ~/compute/roundTwoAnalysis/scripts/filter_transcripts.py ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/edit_file.R ${SLURM_ARRAY_TASK_ID}
Rscript ~/compute/roundTwoAnalysis/scripts/convertGageToExcel.R ${SLURM_ARRAY_TASK_ID}
