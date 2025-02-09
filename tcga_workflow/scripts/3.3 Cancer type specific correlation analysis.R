# 3.3 Cancer type specific correlation analysis
# Load required packages
library(TCGAplot)
library(tidyverse)

# 3.3.1 Gene-gene correlation scatter
# Input your 1st gene symbol
gene1 <- "WNT11"

# Input your 2nd gene symbol

gene2 <- "WNT7B"


# Input cancer type
cancer <- "BRCA"


png(filename = paste0("figures/Gene-gene correlation scatter/", gene1, "_", gene2, ".png"), 
    width = 6000, height = 5000, 
    res = 600)

gene_gene_scatter(cancer,gene1,gene2,density="T") # whether density of gene expression was shown.

dev.off()



# Input your  gene symbol

gene <- "WNT11"

# Input cancer type

cancer <- "BRCA"


# 3.3.2 Gene-promoter methylation correlation scatter

gene_methylation_scatter(cancer,gene)

from <- paste0(gene, "_", "methylation", "_correlation_", cancer, ".pdf")
to <- paste0("figures/Methylation correlation scatter/", gene, "_", "methylation", "_correlation_", cancer, ".pdf")

file.rename(from = from, to = to)


# 3.3.3 Expression heatmap of significantly correlated genes and GO analysis

coexp_heatmap <- gene_coexp_heatmap(cancer,gene,top_n=20, method="pearson")

ggsave(filename = paste0("figures/Correlated genes heatmap and GO analysis/", gene, "_", cancer, ".png"), 
       plot = coexp_heatmap, 
       width = 10, 
       height = 6, 
       dpi = 300)
