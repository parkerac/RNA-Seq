library("readr")
library("dplyr")
library("stringr")
library("writexl")

args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')

setwd(paste0("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison))

table <- read_tsv(paste0(comparison, ".gage"))
names(table)[1] <- "pathway"
write_xlsx(table, paste0(comparison, "_ontology.xlsx"))
