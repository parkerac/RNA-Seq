library("sleuth")
library("readr")
library("stringr")
library("writexl")

args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')
comparisonData <- paste(comparison, "_data", sep = '')
metadata <- paste(comparison, "_metadata.txt", sep = '')

setwd(paste("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, sep = ''))

sample_id <- dir(file.path(comparisonData))
sample_id

kal_dirs <- file.path(comparisonData, sample_id)
kal_dirs

s2c <- read.table(file.path(metadata), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
s2c

so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE, transformation_function = function(x) log2(x + 0.5))
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)

transcripts <- c()
ensembleGenes <- c()
genes <- c()

for (i in 1:nrow(sleuth_table)) {
  fulltargetID <- sleuth_table$target_id[i]
  targetIDList <- str_split(fulltargetID, "\\|")
  transcript <- fulltargetID
  ensembleGene <- targetIDList[[1]][2]
  gene <- targetIDList[[1]][6]
  transcripts <- c(transcripts, transcript)
  ensembleGenes <- c(ensembleGenes, ensembleGene)
  genes <- c(genes, gene) 
}

t2g <- data.frame(target_id = transcripts, ens_gene = ensembleGenes, ext_gene = genes, stringsAsFactors = F)

so <- sleuth_prep(s2c, ~ condition, target_mapping = t2g, aggregation_column = "ens_gene", gene_mode = T, transformation_function = function(x) log2(x + 0.5))
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
models(so)
so <- sleuth_wt(so, 'conditionz_mutation')
sleuth_table <- sleuth_results(so, 'conditionz_mutation', 'wt')


sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
head(sleuth_significant, 20)
sleuth_pval_significant <- dplyr::filter(sleuth_table, pval <= 0.05)
head(sleuth_pval_significant, 20)

write_tsv(sleuth_table, paste(comparison, "_gene_wt_complete_table.tsv", sep = ''))
write_tsv(sleuth_significant, paste(comparison, "_gene_wt_qval_significant.tsv", sep = ''))
write_tsv(sleuth_pval_significant, paste(comparison, "_gene_wt_pval_significant.tsv", sep = ''))
write_xlsx(sleuth_table, paste(comparison, "_gene_wt_complete_table.xlsx", sep = ''))
write_xlsx(sleuth_significant, paste(comparison, "_gene_wt_qval_significant.xlsx", sep = ''))
write_xlsx(sleuth_pval_significant, paste(comparison, "_gene_wt_pval_significant.xlsx", sep = ''))
sleuth_save(so, paste(comparison, "_gene_wt_sleuth_object", sep = ''))
