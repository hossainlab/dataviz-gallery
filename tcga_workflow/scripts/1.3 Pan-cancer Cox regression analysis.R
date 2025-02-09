# 1.3 Pan-cancer Cox regression analysis
# Author: Shekhar Saha, Muntasim Fuad
 
library(TCGAplot)
library(tidyverse)
# Input your gene symbol
gene <- "WNT2"


#1.3.1 Pan-cancer Cox regression forest plot
pan_forest <-pan_forest(gene,
          adjust=F)

ggsave(filename = paste0("figures/Cox regression forest plot/", gene, ".png"), 
       plot = pan_forest, 
       width = 10, height = 8, 
       dpi = 300)