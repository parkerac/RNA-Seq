#!/bin/bash
FILES=($(ls ~/compute/roundTwoAnalysis/trimmomatic_output/*_paired_output.fastq.gz))
NUM_FILES=${#FILES[@]}
echo "${NUM_FILES}"
ZB_NUM_FILES=$(($NUM_FILES - 1))
echo "${ZB_NUM_FILES}"
mkdir ~/compute/roundTwoAnalysis/kallisto_output
sbatch --array=0-${ZB_NUM_FILES}:2 ~/compute/roundTwoAnalysis/scripts/run_kallisto.sh
