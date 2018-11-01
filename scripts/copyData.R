library(readr)
args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')
directory <- paste("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, "/", comparison, sep = '')
metadata <- read_tsv(paste0(directory, "_metadata.txt"))
dataFolder <- paste0(directory, "_data")
command <- paste0("mkdir ", dataFolder)
system(command)

for (i in 1:nrow(metadata)) {
  data <- metadata$sample[i]
  command <- paste0("cp -r /fslhome/parkerac/compute/roundTwoAnalysis/kallisto_output/", data, "* ", dataFolder, "/", data, "/")
  print(command)
  system(command)
}
