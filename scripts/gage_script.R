## Perform a pathway analysis
library(gage)
library(GSEABase)
library(dplyr)

args <- commandArgs(trailingOnly = T)
comparison <- paste("comparison", args[1], sep = '')
directory <- paste("/fslhome/parkerac/compute/roundTwoAnalysis/", comparison, "/", comparison, sep = '')

# Read RNA-Seq values from file
normalizedGeneCounts = read.table(paste(directory, "_symbol_abundance_table.tsv", sep = ''), sep="\t", header=TRUE, check.names=FALSE)
row.names(normalizedGeneCounts) <- make.names(normalizedGeneCounts$gene, unique = T)
normalizedGeneCounts <- select(normalizedGeneCounts, -gene)

# Read gene-set database from file
geneSetDatabase <- getGmt("/fslhome/parkerac/compute/h.all.v6.1.symbols.gmt.txt", collectionType=BroadCollection(category="c2"), geneIdType=SymbolIdentifier())


cn=colnames(normalizedGeneCounts)
comparison <- args[1]

if (comparison == '1' || comparison == '2' || comparison == '3' || comparison == '4' || comparison == '5') {
  wt=grep('WT',cn)
  r=grep('R',cn)
} else if (comparison == '6' || comparison == '7' || comparison == '8') {
  wt=grep('_',cn, invert = T)
  r=grep('_',cn)
} else if (comparison == '9' || comparison == '10') {
  wt=grep('(_C|R)',cn, invert = T)
  r=grep('(_C|R)',cn)
} else if (comparison == '11') {
  wt=grep('N',cn)
  r=grep('T',cn)
} else if (comparison == '12') {
  wt=grep('(127|66|106|37|143|61|66|1244)',cn, invert = T)
  r=grep('(127|66|106|37|143|61|66|1244)',cn)
} else if (comparison == '13') {
  wt=grep('(33|47|55|62|29|32|127|130|53|66)', cn, invert = T)
  r=grep('(33|47|55|62|29|32|127|130|53|66)', cn)
} else if (comparison == '14') {
  wt=grep('(48|195)', cn, invert = T)
  r=grep('(48|195)', cn)
} else if (comparison == '15') {
  wt=grep('(R|127|66|106|37|143|61|66|1244)', cn, invert = T)
  r=grep('(R|127|66|106|37|143|61|66|1244)', cn)
}

print(wt)
print(r)

# Perform gene-set analysis using GAGE
geneSetResults <- gage(normalizedGeneCounts, gsets = geneIds(geneSetDatabase), ref = wt, samp = r, compare ="unpaired", same.dir=FALSE)$greater
print(geneSetResults)

# Save GAGE results to file
write.table(geneSetResults, paste(directory, ".gage", sep = ''), sep="\t", col.names=NA, row.names=TRUE, quote=FALSE)
