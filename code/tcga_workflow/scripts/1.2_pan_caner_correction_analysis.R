# 1.2 Pan-cancer correction analysis
# Load required packages
library(TCGAplot)
library(tidyverse)

# Input your gene symbol
gene <- "PIK3R2"

# 1.2.1 Pan-cancer gene expression and TMB correlation radar chart
png(
  filename = paste0("figures/04_pan_cancer_tmb_correlation/", 
                    gene, 
                    "_tmb_correlation_radar.png"),
  width = 5000,
  height = 5000,
  res = 600
)
gene_TMB_radar(
  gene,
  method = "pearson" # Alternatives: "spearman", "kendall"
)
dev.off()

# 1.2.2 Pan-cancer gene expression and MSI correlation radar chart
png(
  filename = paste0("figures/05_pan_cancer_msi_correlation/",
                    gene, 
                    "_msi_correlation_radar.png"),
  width = 5000,
  height = 5000,
  res = 600
)

gene_MSI_radar(
  gene,
  method = "pearson"
)
dev.off()
