# 2.1.2 Expression analysis grouped by the expression of a specific gene
# Author: Muntasim Fuad


# Load reqquired packages

library(TCGAplot)
library(tidyverse)


# Input your gene symbol

gene <- "WNT2"

# Input cancer type

cancer <- "BRCA"

# 2.1.2.1 Differential expressed gene heatmap grouped by a specific gene

deg_heatmap <- gene_deg_heatmap(cancer, gene,top_n=20)


ggsave(filename = paste0("figures/Differential expressed gene heatmap/", gene, "_", cancer, ".png"), 
       plot = deg_heatmap, 
       width = 10, 
       height = 8, 
       dpi = 300)

# 2.1.2.2 GSEA-GO grouped by the expression of a specific gene

gsea_go <- gene_gsea_go(cancer,gene)

ggsave(filename = paste0("figures/GSEA-GO grouped by the expression/", gene, "_", cancer, ".png"), 
       plot = gsea_go, 
       width = 10, 
       height = 8, 
       dpi = 300)


# 2.1.2.3 GSEA-KEGG grouped by the expression of a specific gene

gsea_kegg <- gene_gsea_kegg(cancer,gene)

ggsave(filename = paste0("figures/GSEA-KEGG grouped by the expression/", gene, "_", cancer, ".png"), 
       plot = gsea_kegg, 
       width = 10, 
       height = 8, 
       dpi = 300)

