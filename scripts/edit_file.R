library("readr")
library("dplyr")
library("stringr")
library("writexl")

args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')

setwd(paste0("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison))

table <- read_tsv(paste(comparison, "_gene_wt_complete_with_types.tsv", sep = ''))
names(table)[5] <- "fold_change"
write_xlsx(table, paste(comparison, "_results.xlsx", sep = ''))



  
