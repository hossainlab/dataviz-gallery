# ==========================================================
#
#      Plot anything
#      •   Bar plots
#      •   Histograms
#      •   Scatter plots
#      •   Box plots
#      •   Violin plots
#      •   Density plots
#      •   Dot-plots
#      •   Line-plots for time-course data
#      •   Pie charts
#      •   Venn diagrams (compare two or more lists of genes)
#
# ==========================================================
library(tidyverse)
library(RColorBrewer)
library(VennDiagram)
library(ggthemes)
library(ggsci)
library(ggpubr)
library(hrbrthemes)
theme_set(theme_gray() + 
            theme(
              axis.line = element_line(size=0.5),
              panel.background = element_rect(fill=NA,size=rel(20)), 
              panel.grid.minor = element_line(colour = NA), 
              axis.text = element_text(size=16), 
              axis.title = element_text(size=18)
            )
)

# Load variant data
data <- read.csv("data/variants_from_assembly.bed", sep="\t", quote='', stringsAsFactors=TRUE,header=FALSE)  |> 
  set_names(c("chrom", "start", "stop", "name", "size", "strand", "type", "ref_dist", "query_dist"))  |> 
  filter(chrom %in% c(as.character(1:22), "X", "Y", "MT"))  |> 
  mutate(
    chrom = factor(chrom, levels = c(as.character(1:22), "X", "Y", "MT")),
    type = factor(type, levels = c("Insertion", "Deletion", "Expansion", "Contraction"))
)

# Bar plot: Variants per chromosome
data |> 
  ggplot(aes(x = chrom, fill = type)) +
  geom_bar() +
  labs(title = "Variant Distribution by Chromosome", 
       x = "Chromosome", 
       y = "Count", 
       fill = "Type") +
  scale_fill_lancet() 
ggsave("figures/barplot_variants_per_chromosome.png", dpi = 300)

# Histogram: Variant size distribution
data  |> 
  ggplot(aes(x = size, fill = type)) +
  geom_histogram(binwidth = 10, alpha = 0.7, position = "identity") +
  xlim(0, 500) +
  labs(title = "Variant Size Distribution", 
       x = "Size (bp)", 
       y = "Count", 
       fill = "Type") +
  scale_fill_bmj()
ggsave("figures/histogram_variant_size.png", dpi = 300)

# Scatter plot: Reference vs. Query Distance
data  |> 
  ggplot(aes(x = ref_dist, y = query_dist, color = type)) +
  geom_point(alpha = 0.7) +
  xlim(-500, 500) + ylim(-500, 500) +
  labs(title = "Reference vs. Query Distance",
       x = "Reference Distance", 
       y = "Query Distance", 
       color = "Type") +
  scale_color_lancet()
ggsave("figures/scatter_ref_vs_query.png", dpi = 300)

# Violin plot: Variant size by type
data  |> 
  ggplot(aes(x = type, y = size, fill = type)) +
  geom_violin(adjust = 0.5) +
  scale_y_log10() +
  labs(title = "Variant Size Distribution by Type",
       x = "Variant Type", 
       y = "Size (log10 scale)", 
       fill = "Type") +
  scale_fill_bmj()
ggsave("figures/violinplot_variant_size.png", dpi = 300)

# Density plot
data |> 
  ggplot(aes(x = size, fill = type)) +
  geom_density(alpha = 0.5) +
  xlim(0, 500) +
  labs(title = "Density Plot of Variant Sizes",
       x = "Size (bp)", 
       y = "Density", 
       fill = "Type") +
  scale_fill_lancet()
ggsave("figures/densityplot_variant_size.png", dpi = 300)

# Pie chart
type_counts <- table(data$type)
png("figures/piechart_variant_types.png", width = 800, height = 800)
pie(type_counts, col = brewer.pal(length(type_counts), "Set1"), main = "Variant Type Distribution")
dev.off()

# Read gene lists and convert to named list of vectors
gene_lists <- list(
  A = read_csv("data/genes_list_A.txt", col_names = FALSE, show_col_types = FALSE) %>% pull(X1),
  B = read_csv("data/genes_list_B.txt", col_names = FALSE, show_col_types = FALSE) %>% pull(X1),
  C = read_csv("data/genes_list_C.txt", col_names = FALSE, show_col_types = FALSE) %>% pull(X1),
  D = read_csv("data/genes_list_D.txt", col_names = FALSE, show_col_types = FALSE) %>% pull(X1)
)

# Create Venn Diagram
venn.diagram(
  x = gene_lists,
  fill = c("yellow", "red", "cyan", "forestgreen"),
  filename = "figures/venn_genes.png"
)
