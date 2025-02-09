# TCGAplot (v8.0.0)
# Author: Muntasim Fuad, Shekhar Saha

# Dependencies for TCGAplot
if(!require("BiocManager")) install.packages("BiocManager",update = F,ask = F)

cran_packages=c("magrittr",
                "dplyr",
                "tibble",
                "ggpubr",
                "stringr",
                "reshape2",
                "psych",
                "limma",
                "circlize",
                "grid",
                "fmsb",
                "survival",
                "survminer",
                "forestplot",
                "pROC",
                "tinyarray",
                "ggplot2",
                "patchwork",
                "ggsci",
                "RColorBrewer",
                "pheatmap")

Biocductor_packages=c("edgeR",
                      "org.Hs.eg.db",
                      "clusterProfiler",
                      "enrichplot",
                      "ComplexHeatmap",
                      "GSVA")

# install packages in CRAN
for (pkg in cran_packages){
  if (!require(pkg,character.only=T)){
    install.packages(pkg,ask = F,update = F)
    require(pkg,character.only=T) 
  }
}

# install packages in Biocductor
for (pkg in Biocductor_packages){
  if (!require(pkg,character.only=T)) {
    BiocManager::install(pkg,ask = F,update = F)
    require(pkg,character.only=T) 
  }
}

# Load required packages

library(TCGAplot)
library(tidyverse)




