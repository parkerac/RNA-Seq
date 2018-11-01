library(readr)
library(sleuth)
library(dplyr)

args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')
directory <- paste("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, "/", sep = '')

setwd(directory)

so <- sleuth_load(paste0(comparison, "_gene_wt_sleuth_object"))
table <- kallisto_table(so, use_filtered = FALSE, normalized = TRUE)
samples <- unique(table$sample)
dataMatrix <- unique(table$target_id)

for (item in samples) {
  sampleData <- filter(table, sample == item)
  tpmData <- select(sampleData, tpm)
  colnames(tpmData) <- item
  dataMatrix <- cbind(dataMatrix, tpmData)
}

dataFrame <- as.data.frame(dataMatrix)

#finalDataFrame <- select(dataFrame, -dataMatrix)
write_tsv(dataFrame, paste0(comparison, "_abundance_table.tsv"))
