# Installation: https://bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html
if (!require("BiocManager"))
  install.packages("BiocManager")
BiocManager::install("maftools")

# load required packages 
library(tidyverse)
library(maftools)

# path to TCGA LAML MAF file
laml_maf = system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools') 

# clinical information containing survival information and histology. This is optional
laml_clin = system.file('extdata', 'tcga_laml_annot.tsv', package = 'maftools') 

laml = read.maf(maf = laml_maf, clinicalData = laml_clin)

# plotmafSummary 
png("figures/plotmafSummary.png")
plotmafSummary(maf = laml,
               rmOutlier = TRUE,
               addStat = 'median', 
               dashboard = TRUE, 
               titvRaw = FALSE)
dev.off()





# Drawing oncoplots
# oncoplot for top ten mutated genes.
oncoplot(maf = laml, 
         top = 10)

# Transition and Transversions
laml_titv = titv(maf = laml, plot = FALSE, useSyn = TRUE)

# plot titv summary
plotTiTv(res = laml_titv)


# Lollipop plots for amino acid changes
# lollipop plot for DNMT3A, which is one of the most frequent mutated gene in Leukemia.
lollipopPlot(
  maf = laml,
  gene = 'DNMT3A',
  AACol = 'Protein_Change',
  showMutationRate = TRUE,
  labelPos = 882
)

# General protein domains can be drawn with the function plotProtein
plotProtein(gene = "TP53", 
            refSeqID = "NM_000546")

# Rainfall plots
brca <- system.file("extdata", "brca.maf.gz", package = "maftools")
brca = read.maf(maf = brca, verbose = FALSE)

rainfallPlot(maf = brca,
             detectChangePoints = TRUE, 
             pointSize = 0.4)

# Compare mutation load against TCGA cohorts
laml_mutload = tcgaCompare(maf = laml, 
                           cohortName = 'Example-LAML', 
                           logscale = TRUE, 
                           capture_size = 50)

# Plotting VAF
plotVaf(maf = laml,
        vafCol = 'i_TumorVAF_WU')

# Processing copy-number data
gistic_res_folder <- system.file("extdata", package = "maftools")
laml_gistic = readGistic(gisticDir = gistic_res_folder, 
                         isTCGA = TRUE)

# genome plot
gisticChromPlot(gistic = laml_gistic,
                markBands = "all")

# Co-gisticChromPlot
coGisticChromPlot(gistic1 = laml_gistic, 
                  gistic2 = laml_gistic, 
                  g1Name = "AML-1", 
                  g2Name = "AML-2", 
                  type = 'Amp')

# Bubble plot
gisticBubblePlot(gistic = laml_gistic)

# oncoplot
gisticOncoPlot(gistic = laml_gistic,
               clinicalData = getClinicalData(x = laml),
               clinicalFeatures = 'FAB_classification', 
               sortByAnnotation = TRUE,
               top = 10)
