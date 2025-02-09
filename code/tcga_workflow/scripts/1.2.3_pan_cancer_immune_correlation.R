# 1.2.3 Pan-cancer gene expression and immune-related genes correlation
# Load required packages
library(TCGAplot)
library(tidyverse)

# Input your gene symbol
gene <- "PIK3R1"

# Define color gradients
lowcol <- "#3182bd"
highcol <- "#f03b20"

# 1.2.3.1 Pan-cancer gene expression and ICGs correlation
gene_checkpoint_heatmap <- gene_checkpoint_heatmap(
  gene,
  method = "pearson",
  lowcol = lowcol, 
  highcol = highcol,
  cluster_row = TRUE,
  cluster_col = TRUE,
  legend = TRUE
)

ggsave(
  filename = paste0("figures/06_icg_correlation/",gene, "_icg_correlation.png"), 
  plot = gene_checkpoint_heatmap,
  width = 8, 
  height = 4, 
  dpi = 300
)

# 1.2.3.2 Pan-cancer gene expression and Chemokine correlation 
gene_chemokine_heatmap <- gene_chemokine_heatmap(
  gene,
  method = "pearson",
  lowcol = lowcol,
  highcol = highcol,
  cluster_row = TRUE,
  cluster_col = TRUE,
  legend = TRUE
)

ggsave(
  filename = paste0("figures/07_chemokine_correlation/",gene, "_chemokine_correlation.png"), 
  plot = gene_chemokine_heatmap, 
  width = 8, 
  height = 8,
  dpi = 300
)

# 1.2.3.3 Pan-cancer gene expression and Chemokine receptor correlation
gene_receptor_heatmap <- gene_receptor_heatmap(
  gene,
  method = "pearson",
  lowcol = lowcol,
  highcol = highcol,
  cluster_row = TRUE, 
  cluster_col = TRUE,
  legend = TRUE
)

ggsave(
  filename = paste0("figures/08_chemokine_receptor_correlation/", gene, "_chemokine_receptor_correlation.png"), 
  plot = gene_receptor_heatmap, 
  width = 8, 
  height = 5,
  dpi = 300
)

# 1.2.3.4 Pan-cancer gene expression and Immune stimulator correlation
gene_immustimulator_heatmap <- gene_immustimulator_heatmap(
  gene,
  method = "pearson",
  lowcol = lowcol, 
  highcol = highcol,
  cluster_row = TRUE,
  cluster_col = TRUE,
  legend = TRUE
)

ggsave(
  filename = paste0("figures/09_immune_stimulator_correlation/", gene, "_immune_stimulator_correlation.png"), 
  plot = gene_immustimulator_heatmap, 
  width = 8, 
  height = 9, 
  dpi = 300
)

# 1.2.3.5 Pan-cancer gene expression and Immune inhibitor correlation
gene_immuinhibitor_heatmap <- gene_immuinhibitor_heatmap(
  gene,
  method = "pearson",
  lowcol = lowcol, 
  highcol = highcol,
  cluster_row = TRUE,
  cluster_col = TRUE,
  legend = TRUE
)

ggsave(
  filename = paste0("figures/10_immune_inhibitor_correlation/", gene, "_immune_inhibitor_correlation.png"), 
  plot = gene_immuinhibitor_heatmap, 
  width = 8, 
  height = 6, 
  dpi = 600
)
