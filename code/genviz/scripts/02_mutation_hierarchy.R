# Load necessary libraries
library(tidyverse)
library(data.table)
library(GenVisR)
library(gridExtra)

# Set seed for reproducibility
set.seed(426)

# Create a sample dataset with random mutation data
input_data <- data.frame(
  sample = sample(1:5, 20, replace = TRUE),
  gene = sample(letters[1:5], 20, replace = TRUE),
  variant_class = sample(c("silent", "frameshift", "missense"), 20, replace = TRUE)
)

# Define mutation hierarchy as a data frame
mutation_hierarchy <- data.frame(
  variant_class = c("frameshift", "missense", "silent"),
  color = c("#E41A1C", "#377EB8", "#4DAF4A")  # Assign colors
)

# Generate waterfall plot with the defined mutation hierarchy
p1 <- Waterfall(
  input_data, 
  mutationHierarchy = mutation_hierarchy
)

# Generate waterfall plot with reversed deleterious order
p2 <- Waterfall(
  input_data, 
  mutationHierarchy = rev(most_deleterious)
)

# Arrange the two plots side by side
grid.arrange(p1, p2, ncol = 2)

# Summarize the mutation types for a given sample and gene
subset(input_data, sample == 5 & gene == "a")
