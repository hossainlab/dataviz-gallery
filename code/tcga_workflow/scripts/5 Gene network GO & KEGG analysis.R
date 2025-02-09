# 5 Gene network GO & KEGG analysis
# Author: Muntasim Fuad

# Load reqquired packages

library(TCGAplot)
library(tidyverse)


# Load list of genes
genes <- readxl::read_xlsx("data/genes_string_interaction.xlsx")

# 5.1 Gene network GO analysis

GO <- gene_network_go(genes$`Gene Symbol`)

ggsave(filename = paste0("figures/Gene network analysis/GO.png"), 
       plot = GO, 
       width = 14,height = 10, 
       dpi = 300)


# 5.2 Gene network KEGG analysis
KEGG <- gene_network_go(genes$`Gene Symbol`)

ggsave(filename = paste0("figures/Gene network analysis/KEGG.png"), 
       plot = KEGG, 
       width = 14,height = 10, 
       dpi = 300)