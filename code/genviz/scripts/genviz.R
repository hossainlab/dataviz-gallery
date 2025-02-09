# https://github.com/griffithlab/GenVisR
# https://currentprotocols.onlinelibrary.wiley.com/doi/full/10.1002/cpz1.252
# Load necessary libraries
library(tidyverse)
library(GenVisR)

# Load datasets using readr for better performance
mutation_data <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_Mutation_Data.tsv")
clinical_data <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_Clinical.tsv")
mutation_burden <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_MutationBurden.tsv")

# Clean and reformat mutation data using native pipe
mutation_data <- mutation_data |>
  select(
    sample = patient,
    gene = gene.name,
    variant_class = trv.type,
    amino_acid_change = amino.acid.change
  ) |>
  mutate(variant_class = as.character(variant_class))

# Create a vector for mutation priority order
mutation_priority <- mutation_data |>
  distinct(variant_class) |>
  pull(variant_class) |> 
  as.character()

# Generate the waterfall plot
waterfall_plot <- Waterfall(
  mutation_data,
  fileType = "Custom",
  variant_class_order = mutation_priority
)

# Save the plot to the figures folder
output_file <- file.path(figures_dir, "waterfall_plot.png")
ggsave(output_file, plot = waterfall_plot, width = 10, height = 6, dpi = 300)

# Print confirmation message
message("Plot saved to: ", output_file)
