from sys import argv
import os

comparison = "comparison" + argv[1]
directory = "/fslhome/parkerac/compute/roundTwoAnalysis/" + comparison

os.chdir(directory)

completeTable = open(comparison + "_gene_wt_complete_table.tsv")

geneDictionary = {}

lineCount = 0

for line in completeTable:
  lineCount += 1
  if lineCount > 1:
    line = line.strip().split("\t")
    geneID = line[0]
    geneSymbol = line[1]
    geneDictionary[geneID] = geneSymbol
  
table = open(comparison + "_abundance_table.tsv")
output = open(comparison + "_symbol_abundance_table.tsv", "w")
  
lineCount = 0
for line in table:
  lineCount += 1
  line = line.strip().split("\t")
  newLine = line[1:]
  newLine = "\t".join(newLine)
  if lineCount == 1:
    output.write("gene\t" + newLine + "\n")
  else:
    ENSG = line[0]
    outputLine = geneDictionary[ENSG] + "\t" + newLine + "\n"
    output.write(outputLine)

table.close()
output.close()
completeTable.close()
