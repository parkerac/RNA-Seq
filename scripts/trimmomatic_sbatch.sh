#!/bin/bash
FILES=($(ls ~/compute/roundTwoAnalysis/FASTQ_data/*.gz))
NUM_FILES=${#FILES[@]}
echo "${NUM_FILES}"
ZB_NUM_FILES=$(($NUM_FILES - 1))
echo "${ZB_NUM_FILES}"
sbatch --array=0-${ZB_NUM_FILES}:2 ~/compute/roundTwoAnalysis/scripts/run_trimmomatic.sh
