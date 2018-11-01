from sys import argv
import gzip

gtf = gzip.open("/fslhome/parkerac/compute/gencode.v28.annotation.gtf.gz")
geneDictionary = {}

lineCount = 0
for line in gtf:
    lineCount += 1
    if lineCount > 5:
        line = line.decode()
        line = line.strip().split('\t')
        data = line[8]
        splitData = data.split('; ')
        if line[2] == "gene":
            geneID = splitData[0][9:-1]
            geneType = splitData[1][11:-1]
            geneDictionary[geneID] = geneType

comparison = "comparison" + argv[1]
table = "/fslhome/parkerac/compute/roundTwoAnalysis/" +  comparison + "/" + comparison + "_gene_wt_complete_table.tsv"
outputPath = "/fslhome/parkerac/compute/roundTwoAnalysis/" + comparison + "/" + comparison + "_gene_wt_complete_with_types.tsv"
results = open(table)
output = open(outputPath, 'w')

lineCount = 0
for line in results:
    lineCount += 1
    line = line.strip()
    splitLine = line.split('\t')
    gene = splitLine[0]
    if lineCount == 1:
        newLine = line + "\tgene_type\n"
    else:
        newLine = line + "\t" + geneDictionary[gene] + "\n"
    output.write(newLine)

gtf.close()
results.close()
output.close()
