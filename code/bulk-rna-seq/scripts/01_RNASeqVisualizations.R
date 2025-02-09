# packages for data manipulation
library(tidyverse)

# packages for DEG
library(airway)
library(DESeq2)

# packages for visualization 
library(RColorBrewer)
library(EnhancedVolcano)
library(pheatmap)

# package for poison distance calculation
library(PoiClaClu)

# package for gene filter 
library(genefilter)

# packages for gene annotations 
library(org.Hs.eg.db)
library(AnnotationDbi)

# know our data 
?airway

# load data from "airway" dataset 
data("airway")

# get the raw counts_data 
counts_data <- assay(airway)

# get the col_data / metadata  
col_data <- as.data.frame(colData(airway))

# making sure the row names in col_data matches to column names in counts_data
all(colnames(counts_data) == rownames(col_data))

# Construct a DESeqDataSetFromMatrix data object
dds <- DESeqDataSetFromMatrix(
  countData = counts_data, 
  colData = col_data, 
  design = ~dex
)

# Plot heatmap of poison distances between samples 
poisd <- PoissonDistance(t(counts(dds)))
sample_poison_matrix <- as.matrix(poisd$dd)
rownames(sample_poison_matrix) <- paste(dds$dex, sep = "-")
colnames(sample_poison_matrix) <- rownames(sample_poison_matrix)
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)
pheatmap(
  sample_poison_matrix, 
  clustering_distance_rows = poisd$dd, 
  clustering_distance_cols = poisd$dd, 
  color = colors,
  filename = "figures/poison_distance_heatmap.png" 
)

# perform differential gene expression analysis 
dds <- DESeq(dds)

# obtain results 
res <- results(dds)

# plot average expression versus log2 fold change - points are colored blue if Padj < 0.1
png("figures/MA_Plot.png", height = 2400, width = 3600, res=600) # PNG device
plotMA(res, ylim = c(-4, 4))
dev.off()

# plot histogram of P-values
png("figures/pvalue_histogram.png", height = 2400, width = 3600, res=600)  # PNG device
hist(res$pvalue, breaks = 20, col = "grey50", border = "white")
dev.off()

# plot histogram of padj values
png("figures/padj_histogram.png", height = 2400, width = 3600, res=600) # PNG device
hist(res$padj, breaks = 20, col = "grey50", border = "white")
dev.off()

# plot histogram of P-values - improved version by filtering out genes with very low expression levels
png("figures/filtered_pvalue_histogram.png", height = 2400, width = 3600, res=600) # PNG device
hist(res$pvalue[res$baseMean > 1], breaks = 20, col = "grey50", border = "white")
dev.off()

# Add gene annotation to results  
anno <- AnnotationDbi::select(org.Hs.eg.db,
                              keys = as.character(rownames(res)),
                              columns = c("ENSEMBL", "ENTREZID", "SYMBOL", "GENENAME"),
                              keytype = "ENSEMBL")

res_df <- as.data.frame(res)
res_df$ENSEMBL <- rownames(res)

# join annotation tables to results  
anno_results <- left_join(res_df, anno, by = "ENSEMBL")
anno_results

# Volcano Plot
EnhancedVolcano(
  anno_results, 
  lab = anno_results$SYMBOL, 
  x = "log2FoldChange", 
  y = "padj",
  title = "Untreated vs. Treated"
)
ggsave("figures/volcano_plot_default.png", width = 8, height = 6, dpi = 600)

EnhancedVolcano(
  anno_results, 
  lab = anno_results$SYMBOL, 
  x = "log2FoldChange", 
  y = "padj", 
  pCutoff = 0.001, 
  FCcutoff = 2, 
  pointSize = 1.5, 
  labSize = 3.0,
  title = "Untreated vs. Treated"
)
ggsave("figures/volcano_plot_custom1.png", width = 8, height = 6, dpi = 600)

EnhancedVolcano(
  anno_results, 
  lab = anno_results$SYMBOL, 
  x = "log2FoldChange", 
  y = "padj", 
  pCutoff = 0.001, 
  FCcutoff = 2, 
  pointSize = 1.5, 
  labSize = 3.0, 
  xlim = c(-5, 5), 
  ylim = c(0, -log10(10e-10)),
  title = "Untreated vs. Treated"
)
ggsave("figures/volcano_plot_custom2.png", width = 8, height = 6, dpi = 600)

EnhancedVolcano(
  anno_results, 
  lab = anno_results$SYMBOL, 
  x = "log2FoldChange", 
  y = "padj", 
  pCutoff = 0.001, 
  FCcutoff = 2, 
  pointSize = 1.5, 
  labSize = 3.0, 
  xlim = c(-5, 5), 
  ylim = c(0, -log10(10e-10)), 
  border = "full", 
  borderWidth = 1.5, 
  borderColour = "black", 
  gridlines.major = FALSE,
  title = "Untreated vs. Treated"
)
ggsave("figures/volcano_plot_custom3.png", width = 8, height = 6, dpi = 600)


# perform regularized-logarithm transformation (rlog) on the data
rld <- rlog(dds)

# plot Principal Component Analysis
plotPCA(rld, intgroup = "dex")
ggsave("figures/PCA_plot.png", height = 6, width = 6, dpi = 600)

# subset genes 
results_sig <- anno_results[which(anno_results$padj < 0.01 & abs(anno_results$log2FoldChange) >= 1 & anno_results$baseMean >= 20), ]

# DE genes with strongest downregulation (head)
downregulation <- head(results_sig[order(results_sig$log2FoldChange), ])
write.csv(downregulation, "data/downregulated_genes.csv", row.names = FALSE) # Save to CSV

# DE genes with strongest upregulation(tail)
upregulation <- tail(results_sig[order(results_sig$log2FoldChange), ])
write.csv(upregulation, "data/upregulated_genes.csv", row.names = FALSE) # Save to CSV


# plot expression of individual genes  
# gene with largest positive log2FC  
plotCounts(dds, gene = which.max(anno_results$log2FoldChange), intgroup = "dex")
ggsave("figures/max_log2FC_plot.png", height = 4, width = 6, dpi = 600)

plotCounts(dds, gene = which.min(anno_results$log2FoldChange), intgroup = "dex")
ggsave("figures/min_log2FC_plot.png", height = 4, width = 6, dpi = 600)

# specific gene of interest  
plotCounts(dds, gene = "ENSG00000127954", intgroup = "dex")
ggsave("figures/specific_gene_plot.png", height = 4, width = 6, dpi = 600)

# Save the DESeq2 results (optional, but highly recommended)
saveRDS(res, file = "data/deseq_results.rds")

# Save the annotated results
write.csv(anno_results, file = "figures/annotated_results.csv", row.names = FALSE)