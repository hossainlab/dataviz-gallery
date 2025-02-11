# Load Packages 
library(BSgenome) # for available ref-genome 
library(MutationalPatterns) # for mutational signature analysis 
library(NMF) # for non-negative matrix factorization(NMF or NNMF)
library(patchwork) # for managing plots and grid system 
library(tidyverse)

# List vailable genomes 
head(available.genomes())

# Load data 
ref_genome <- "BSgenome.Hsapiens.UCSC.hg19"
library(ref_genome, character.only = TRUE)

# Store VCF Files into vcf_files[vcf=variant call format] 
vcf_files <- list.files(system.file("extdata", package = "MutationalPatterns"), pattern = ".vcf", full.names = TRUE)
vcf_files

# Extract sample names from file paths
sample_names <- gsub("\\.vcf$", "", basename(vcf_files))
sample_names

# Load VCF files into GRanges[vcf_files, sample_names, ref_genome]
vcfs <- read_vcfs_as_granges(vcf_files, sample_names, ref_genome)

# 96 Mutational Profile 
mut_mat <- mut_matrix(vcf_list=vcfs, ref_genome = ref_genome)
head(mut_mat)

# De novo mutational signature extraction using NMF
mut_mat <- mut_mat + 0.0001 
estimate <- nmf(mut_mat, rank=2:5, method = "brunet", nrun=10, seed=123456) 
plot(estimate) 

# Save the NMF estimation plot
ggsave("figures/nmf_estimate.png", dpi = 300)

# Heatmap 
png("figures/nmf_heatmap.png", height = 1200, width = 1200)
consensusmap(estimate)
dev.off()

# Mutational Signatures Extraction 
nmf_res <- extract_signatures(mut_mat, rank = 2, nrun=10)
colnames(nmf_res$signatures) <- c("Signature A", "Signature B")
rownames(nmf_res$contribution) <- c("Signature A", "Signature B")
plot_96_profile(nmf_res$signatures, condensed = TRUE)

# Save the mutational profiles
ggsave("figures/mutational_profiles.png", dpi = 300)


# Contribution of Signatures in a bar plot 
pc1 <- plot_contribution(nmf_res$contribution,
                         nmf_res$signatures, 
                         mode = "relative") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

pc2 <- plot_contribution(nmf_res$contribution, 
                         nmf_res$signatures, 
                         mode = "absolute") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Combine plots using patchwork
pc1 + pc2 + plot_layout(nrow = 2)
ggsave("figures/signature_contribution.png", dpi = 300)

# Flip X and Y coordinates 
pc3 <- plot_contribution(nmf_res$contribution, 
                         nmf_res$signatures, 
                         mode="relative", 
                         coord_flip = TRUE)
pc4 <- plot_contribution(nmf_res$contribution,
                         nmf_res$signatures, 
                         mode="absolute", 
                         coord_flip = TRUE)
pc3 + pc4 + plot_layout(nrow = 2)
ggsave("figures/signature_contribution_flipped.png", dpi = 300)


# Heatmaps 
plot_contribution_heatmap(nmf_res$contribution, sig_order = c("Signature A", "Signature B"))
plot_contribution_heatmap(nmf_res$contribution, cluster_samples = FALSE)

# GRID 
pch1 <- plot_contribution_heatmap(nmf_res$contribution, sig_order = c("Signature A", "Signature B"))
pch2 <- plot_contribution_heatmap(nmf_res$contribution, cluster_samples = FALSE)
pch1 + pch2 + plot_layout(nrow = 2)
ggsave("figures/signature_contribution_heatmap.png", dpi = 300)

# Compare reconstructed mutational profile with original mutational profile 
plot_compare_profiles(mut_mat[,1], 
                      nmf_res$reconstructed[,1], 
                      profile_names = c("Original", "Reconstructed"), 
                      condensed = TRUE)
ggsave("figures/profile_comparison.png", dpi = 300)


# Cosmic Mutational Signatures 
sp_url <- paste("https://cancer.sanger.ac.uk/cancergenome/assets/signatures_probabilities.txt", sep = " ")

cancer_signatures = read.table(sp_url, sep = "\t", header = TRUE)
# Match the order of the mutation types to MutationalPatterns standardnew_order = match(row.names(mut_mat), cancer_signatures$Somatic.Mutation.Type)
# Reorder cancer signatures dataframe
new_order = match(row.names(mut_mat), cancer_signatures$Somatic.Mutation.Type)

cancer_signatures = cancer_signatures[as.vector(new_order),]

# Add trinucletiode changes names as row.names
row.names(cancer_signatures) = cancer_signatures$Somatic.Mutation.Type

# Keep only 96 contributions of the signatures in matrix
cancer_signatures = as.matrix(cancer_signatures[,4:33])

# Plot mutational profile of the first two COSMIC signatures
plot_96_profile(cancer_signatures[,1:2], condensed = TRUE, ymax = 0.3)
ggsave("figures/cosmic_signatures.png", dpi = 300)


# COSMIC dendrogram
png("figures/cosmic_dendrogram.png", width = 1200, height = 1200)
plot(hclust_cosmic)
dev.off()

# cosine similarity heatmap
cos_sim(mut_mat[,1], cancer_signatures[,1])
cos_sim_samples_signatures = cos_sim_matrix(mut_mat, cancer_signatures)
plot_cosine_heatmap(cos_sim_samples_signatures,
                    col_order = cosmic_order,
                    cluster_rows = TRUE)
ggsave("figures/cosine_similarity_heatmap.png", dpi = 300)