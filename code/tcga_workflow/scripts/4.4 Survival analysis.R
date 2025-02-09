# 4.4 Survival analysis
# Author: Muntasim Fuad


# Load required packages

library(TCGAplot)
library(tidyverse)

# Input your gene symbol

gene <- "WNT2"

# Input cancer type

cancer <- "BRCA"


# Input color palette
# scientific journal palettes from ggsci R package,
# e.g.: "npg", "aaas", "lancet","tron", "jama", "jco", "ucscgb", "uchicago", "simpsons" and "rickandmorty".

col_pal <- "tron"


# 4.4.1 Survival analysis based on the expression of a single gene

png(filename = paste0("figures/Survival analysis (expression)/", gene, ".png"), 
    width = 6000, height = 5000, 
    res = 600)

tcga_kmplot(cancer,gene, palette= col_pal) #The alternatives to be passed to correlation are "spearman" and "kendall".

dev.off()


# 4.4.2 Survival analysis based on the promoter methylation of a specific gene

methy_kmplot(cancer,gene,palette= col_pal)

# "A pdf file will be generated in the working directory."

from <- paste0(gene, "_", "methylation", "_kmplot_", cancer, ".pdf")
to <- paste0("figures/Survival analysis (promoter methylation)/", gene, "_", "methylation", "_kmplot_", cancer, ".pdf")

file.rename(from = from, to = to)


