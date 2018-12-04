library(readxl)
library(ggplot2)
library(dplyr)
library(ggrepel)

args <- commandArgs(trailingOnly = T)
comparison <- paste0("comparison", args[1])
directory <- paste0("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, "/", comparison)
data <- read_excel(paste0(directory, "_results.xlsx"))
plot_data <- tibble(log2_fold_change=data$fold_change, nlp=-log10(data$pval), gene=data$ext_gene)
plot_data <- arrange(plot_data, plot_data$nlp)
last10 <- tail(plot_data, 10)
cutoff <- last10$nlp[1]
title <- paste("Comparison", args[1])

volcano <- ggplot(plot_data, aes(x=log2_fold_change, y=nlp, label=gene)) +
  geom_point() +
  xlab("Fold change (log2)") +
  ylab("-log10(pval)") +
  theme_bw(base_size=16) +
  geom_text_repel(aes(label=ifelse(nlp>=cutoff, as.character(gene), '')), hjust=-0.1, vjust=0, size=2.5) +
  ggtitle(title)

ggsave(paste0(directory, "_volcano.pdf"), volcano)  
