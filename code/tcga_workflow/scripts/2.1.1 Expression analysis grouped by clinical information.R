# 2.1.1 Expression analysis grouped by clinical information
library(TCGAplot)
library(tidyverse)

# Input your gene symbol
gene <- "WNT2"

# Input Cancer type
cancer<- "BRCA"

# 2.1.1.1 Tumor-normal box plot
tcga_boxplot <- tcga_boxplot(cancer,gene,add = "jitter",
             palette="jco",legend="none",
             label="p.signif",
             method="wilcox.test")


ggsave(filename = paste0("figures/Tumor-normal box plot/", gene, ".png"), 
       plot = tcga_boxplot, width = 10,height = 8, dpi = 300)

# 2.1.1.2 Paired tumor-normal box plot
paired_boxplot <- paired_boxplot(cancer,gene,palette="jco",
               legend="none",label="p.signif",
               method="wilcox.test")

ggsave(filename = paste0("figures/Paired tumor-normal box plot/", gene, ".png"), 
       plot = paired_boxplot, width = 10,height = 8, dpi = 300)

# 2.1.1.3 Age grouped box plot
gene_age <- gene_age(cancer,gene,age=60,
         add = "jitter",palette="jco",
         legend="none",label="p.signif",method="wilcox.test")

ggsave(filename = paste0("figures/Age grouped box plot/", gene, ".png"), 
       plot = gene_age, width = 10,height = 8, dpi = 300)

# 2.1.1.4 Gender grouped box plot
gene_gender <- gene_gender(cancer,gene,add = "jitter",
            palette="jco",legend="none",
            label="p.signif",method="wilcox.test")

ggsave(filename = paste0("figures/Gender grouped box plot/", gene, ".png"), 
       plot = gene_gender, width = 10,height = 8, dpi = 300)
