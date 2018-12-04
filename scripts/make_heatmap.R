library(readxl)
library(ggplot2)
library(sleuth)
library(dplyr)

args <- commandArgs(trailingOnly = T)
comparison <- paste0("comparison", args[1])
directory <- paste0("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, "/", comparison)
data <- read_excel(paste0(directory, "_results.xlsx"))
so <- sleuth_load(paste0(directory, "_gene_wt_sleuth_object"))

plot_data = tibble(log2_fold_change=data$fold_change, nlp=-log10(data$pval), gene=data$ext_gene)

positive <- data[(data$fold_change > 0),]
negative <- data[(data$fold_change < 0),]

pos50 <- positive[1:50,]
neg50 <- negative[1:50,]

edge100 <- rbind(pos50, neg50)
transcripts <- edge100$target_id
so$sample_to_covariates$condition[which(so$sample_to_covariates$condition == "z_mutation")] <- "mutation"
so$sample_to_covariates$condition[which(so$sample_to_covariates$condition != "mutation")] <- "wild_type"

condition <- c("black", "white")
names(condition) <- c("wild_type", "mutation")
anno_colors <- list(condition = condition)
heatmap <- plot_transcript_heatmap(so, transcripts, fontsize = 4, cluster_rows = FALSE, annotation_colors = anno_colors, clustering_method = "mcquitty")

ggsave(paste0(directory, "_heatmap.pdf"), heatmap)
