library(GenVisR)

# Load relevant data from the manuscript
mutationData <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_Mutation_Data.tsv")
clinicalData <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_Clinical.tsv")
mutationBurden <- read.delim("http://genomedata.org/gen-viz-workshop/GenVisR/BKM120_MutationBurden.tsv")

# Reformat the mutation data for waterfall()
mutationData <- mutationData[,c("patient", "gene.name", "trv.type", "amino.acid.change")]
colnames(mutationData) <- c("sample", "gene", "variant_class", "amino.acid.change")

# Create a vector to save mutation priority order for plotting
mutation_priority <- as.character(unique(mutationData$variant_class))

# Create an initial plot
waterfall(mutationData, fileType = "Custom", variant_class_order=mutation_priority)
