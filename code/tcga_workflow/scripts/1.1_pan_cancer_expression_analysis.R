# 1.1 Pan-cancer expression analysis
# Load required packages
library(TCGAplot)
library(tidyverse)

# Input your gene symbol
gene <- "PIK3R2"

# Input color palette
# Scientific journal palettes from ggsci R package,
# e.g.: "npg", "aaas", "lancet", "tron", "jama", "jco", "ucscgb", "uchicago", "simpsons", "rickandmorty".
col_pal <- "lancet"

# 1.1.1 Pan-cancer tumor-normal box plot
pan_boxplot <- pan_boxplot(
  gene,
  palette = col_pal,
  legend = "right",
  method = "wilcox.test" # Alternative method: "t.test"
)

ggsave(
  filename = paste0(
    "figures/01_pan_cancer_tumor_vs_normal/",
    gene, "_box_plot.png"
  ),
  plot = pan_boxplot,
  width = 10,
  height = 6,
  dpi = 300
)

# 1.1.2 Pan-cancer paired tumor-normal box plot
pan_paired_boxplot <- pan_paired_boxplot(
  gene,
  legend = "none",
  palette = col_pal
)

ggsave(
  filename = paste0(
    "figures/02_pan_cancer_paired_tumor_vs_normal/",
    gene, "_paired_box_plot.png"
  ),
  plot = pan_paired_boxplot,
  width = 10,
  height = 6,
  dpi = 300
)

# 1.1.3 Pan-tumor box plot
pan_tumor_boxplot <- pan_tumor_boxplot(gene)

ggsave(
  filename = paste0(
    "figures/03_pan_tumor/",
    gene, "_box_plot.png"
  ),
  plot = pan_tumor_boxplot,
  width = 10,
  height = 6,
  dpi = 300
)
