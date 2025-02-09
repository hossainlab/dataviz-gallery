library(tidyverse)
library(stringr)

# import data 
data <- read.csv(here::here("data/Encode_HMM_Processed_Data.csv"))

# Examine first few rows  
head(data)

# check data structures 
glimpse(data)

# Steps in Data Visualization with ggplot2: Mapping data to aesthetics
# 1. Aesthetic
# 2. Visual property of a graph
# 3. Position, shape, color, etc.
# 4. Data
# 5. A column in a data set

# ggplot() template
ggplot(data = '', mapping = aes(x = '', y = '')) 

# A quick visualization
ggplot(data, aes(x = chrom, fill=type)) + geom_bar()

# Problems: 
# 1) Remove "chr" prefix from chromosome names
# 2) Order the chromosomes correctly
# 3) Pick a subset of the types and rename them
seq(1,22)
c(seq(1,22),"X","Y")

data$chrom <- factor(data$chrom, levels=c(seq(1,22),"X","Y"))

summary(data$chrom)

# plot again 
ggplot(data,aes(x=chrom,fill=type)) + geom_bar()

# Save the plot to a file
# Different file formats:
png("Lesson-01/plot.png")
ggplot( data,aes(x=chrom,fill=type)) + geom_bar()
dev.off()

tiff("Lesson-01/plot.tiff")
ggplot( data,aes(x=chrom,fill=type)) + geom_bar()
dev.off()

jpeg("Lesson-01/plot.jpg")
ggplot( data,aes(x=chrom,fill=type)) + geom_bar()
dev.off()

pdf("Lesson-01/plot.pdf")
ggplot( data,aes(x=chrom,fill=type)) + geom_bar()
dev.off()

# High-resolution:
png("Lesson-01/plot_hi_res.png",1000,1000)
ggplot(data,aes(x=chrom,fill=type)) + geom_bar()
dev.off()
