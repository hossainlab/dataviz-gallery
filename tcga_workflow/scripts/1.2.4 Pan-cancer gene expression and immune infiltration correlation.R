# 1.2.4 Pan-cancer gene expression and immune infiltration correlation

# Load required packages
library(TCGAplot)
library(tidyverse)

# Input your gene
gene <- "WNT11"

# 1.2.4.1 Pan-cancer gene expression and Immune cell ratio correlation
immucell_heatmap <-gene_immucell_heatmap(gene,method="pearson",
                                              lowcol="blue",highcol="red",
                                              cluster_row=T,cluster_col=T,legend=T)

ggsave(filename = paste0("figures/Immune cell ratio correlation/", gene, ".png"), 
       plot = immucell_heatmap, 
       width = 10,height = 6, 
       dpi = 300)


# 1.2.4.2 Pan-cancer gene expression and Immune score correlation
immunescore_heatmap <-gene_immunescore_heatmap(gene,method="pearson",
                         lowcol="blue",
                         highcol="red",
                         cluster_row=T, cluster_col=T,
                         legend=T)

ggsave(filename = paste0("figures/Immune score correlation/", gene, ".png"), 
       plot = immunescore_heatmap, 
       width = 8.5,height = 3, 
       dpi = 300)
