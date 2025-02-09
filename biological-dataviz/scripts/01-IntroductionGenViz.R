# Prepare your data 
library(tidyverse)
library(stringr)

# load raw data 
data <- read.csv("data/Encode_HMM_data.txt", sep="\t", header=FALSE)

# Rename the columns so we can plot things more easily without looking up which column is which
names(data)[1:4] <- c("chrom","start","stop","type")


# At any time, you can see what your data looks like using the head() function:
head(data)


# Now let's take a closer look at our data 

# We can see how big our data is
dim(data)

# We can ask our data some questions
summary(data)

# We can break these down by column to see more
summary(data$chrom)
summary(data$type)
summary(data$start)
summary(data$stop)

# We can even make a new column by doing math on the other columns
data$size = data$stop - data$start

# So now there's a new column
head(data)

# Basic statistics
summary(data$size)
mean(data$size)
sd(data$size)

median(data$size)
max(data$size)
min(data$size)

# Keep necessary columns for data visualization 
data <- data  |>  
  select(chrom, start, stop, type, size) 

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

# 1) Remove the "chr" prefix
data$chrom <- factor(gsub("chr", "", data$chrom))
summary(data$chrom)

# Order the chromosomes correctly
seq(1,22)
c(seq(1,22),"X","Y")

data$chrom <- factor(data$chrom, levels=c(seq(1,22),"X","Y"))
summary(data$chrom)

# plot again 
ggplot(data,aes(x=chrom,fill=type)) + geom_bar()

# Now let's do something about those types.
summary(data$type)
unique(data$type)

# Rename the types
cleaned_strings <- factor(gsub("[0-9_]+", " ", data$type))
summary(cleaned_strings)

# add to datasheet 
data$type <- factor(gsub("[0-9_]+", " ", data$type))
summary(data$type)

# Check the plot again
ggplot(data,aes(x=chrom,fill=type)) + geom_bar()

# The basics
ggplot(data,aes(x=chrom,fill=type)) + geom_bar()

# Change axis and legend labels, and caption
ggplot(data,aes(x=chrom,fill=type)) + 
  geom_bar() + 
  labs(x = "Chromosome",
       y="Count",
       fill="Feature", 
       caption = "Data Source: Insights from the UCSC Genome Browser: Unraveling Regulatory Features by Chromosome")

# Add a plot title and subtitle 
ggplot(data,aes(x=chrom,fill=type)) + 
  geom_bar() + 
  labs(title="Regulatory features by Chromosomes", 
       subtitle = "Decoding Genomic Governance: Exploring Regulatory Features Across Chromosomes", 
       x = "Chromosome",
       y="Count",
       fill="Feature", 
       caption = "Data Source: Insights from the UCSC Genome Browser: Unraveling Regulatory Features by Chromosome")

# Save the plot to easily try new things
basic <- ggplot(data,aes(x=chrom,fill=type)) + 
  geom_bar() + 
  labs(title="Regulatory features by Chromosomes", 
       subtitle = "Decoding Genomic Governance: Exploring Regulatory Features Across Chromosomes", 
       x = "Chromosome",
       y="Count",
       fill="Feature", 
       caption = "Data Source: Insights from the UCSC Genome Browser: Unraveling Regulatory Features by Chromosome")
basic

# Add theme with modifications to the basic plot, for instance with bigger text
basic + theme_gray(base_size = 20)

# But it only affects that plot, so the next plot we make is back to normal
basic

# You can also set a theme that will affect all the plots you make from now on
theme_set(theme_gray(base_size = 20))
basic

# To recover the default theme:
theme_set(theme_gray())
basic

# I prefer larger text myself
theme_set(theme_gray(base_size = 16))
basic

# Fonts and font sizes for everything at once
basic + theme_gray(base_size = 16, base_family = "Times New Roman")

# Color palettes:
library(RColorBrewer)
display.brewer.all()

basic + scale_fill_brewer(palette="Set1")
basic + scale_fill_brewer(palette="Pastel1")
basic + scale_fill_brewer(palette="YlOrRd")
basic + scale_fill_manual(values = c("green","blue","red"))

colors()

# What happens if we need a lot of colors?
chrom_plot <- ggplot(data,aes(x=type,fill=chrom)) + geom_bar()
chrom_plot

# rainbow is confusing, but color palettes are too short:
chrom_plot + scale_fill_brewer(type="qual",palette=1)


# to get the colors from a palette:
palette1 <- brewer.pal(9,"Set1")
palette1

palette2 <- brewer.pal(8,"Set2")
palette2

palette3 <- brewer.pal(9,"Set3")
palette3

# We can use a quick pie chart to see the colors:
pie(rep(1,length(palette1)),col=palette1)
pie(rep(1,length(palette2)),col=palette2)
pie(rep(1,length(palette3)),col=palette3)

# We can just stick a few color palettes together
big_palette <- c(palette1,palette2,palette3)
big_palette

# Pie chart of all the colors together:
pie(rep(1,length(big_palette)),col=big_palette)

chrom_plot + scale_fill_manual(values = big_palette)

# To shuffle the colors:
chrom_plot + scale_fill_manual(values = sample(big_palette))


# if you want to keep the colors the same every time you plot, 
# use set.seed()
set.seed(5)
# use different numbers until you find your favorite colors
chrom_plot + scale_fill_manual(values = sample(big_palette))

# This is possible, because:
# Fun fact: "Random" numbers from a computer aren't really random
# Color-blind safe palettes:
display.brewer.all(colorblindFriendly=TRUE)
# Mixing them might remove the color-friendly-ness so be careful
# Finding a set of 23 colors that a color-blind person can distinguish is a challenge

basic + scale_fill_brewer(palette="Set2")


# Done with colors
#======================================================================

# Default:
theme_set(theme_gray())


# Basic, normal plot:
basic

# Two basic themes:
basic + theme_gray() # the default
basic + theme_bw() # black and white

# Fonts and font sizes for everything at once
basic + theme_gray(base_size = 24, base_family = "Times New Roman")

# Font size for labels, tick labels, and legend separately ##############################
basic + theme(axis.text=element_text(size=20)) # numbers on axes
basic + theme(axis.title=element_text(size=20)) # titles on axes
basic + theme(legend.title=element_text(size=20)) # legend title
basic + theme(legend.text=element_text(size=20,family="Times New Roman"))

# legend category labels
basic + theme(
  legend.text=element_text(size=20,family="Times New Roman"),
  axis.title=element_text(size=30),
  axis.text=element_text(size=20)
) 

# Mix and match


# Change background color
basic + theme(panel.background = element_rect(fill="pink"))
basic + theme(panel.background = element_rect(fill="white"))

# Change grid-lines
basic + theme(panel.grid.major = element_line(colour = "blue"), panel.grid.minor = element_line(colour = "red"))

# Remove all gridlines:
basic + theme(panel.grid.major = element_line(NA), 
              panel.grid.minor = element_line(NA))

# Thin black major gridlines on y-axis, the others are removed
basic + theme(panel.grid.major.y = element_line(colour = "black",size=0.2), 
              panel.grid.major.x = element_line(NA),
              panel.grid.minor = element_line(NA))


# Change tick-marks
basic # normal ticks
basic + theme(axis.ticks = element_line(size=2))
basic + theme(axis.ticks = element_line(NA))
basic + theme(axis.ticks = element_line(color="blue",size=2))
basic + theme(axis.ticks = element_line(size=2), # affects both x and y
              axis.ticks.x = element_line(color="blue"), # x only
              axis.ticks.y = element_line(color="red"))  # y only

# Place legend in different locations
basic + theme(legend.position="top")
basic + theme(legend.position="bottom")
basic + theme(legend.position=c(0,0)) # bottom left
basic + theme(legend.position=c(1,1)) # top right
basic + theme(legend.position=c(0.8,0.8)) # near the top right

# Remove legend title
basic + labs(fill="")
basic + labs(fill="") + theme(legend.position=c(0.8,0.8))

# Remove legend completely
basic + guides(fill=FALSE)


# clear background, axis lines but no box, no grid lines, basic colors, no legend
publication_style <- basic + guides(fill=FALSE) +  theme(axis.line = element_line(size=0.5),panel.background = element_rect(fill=NA,size=rel(20)), panel.grid.minor = element_line(colour = NA), axis.text = element_text(size=16), axis.title = element_text(size=18)) 

publication_style

publication_style + scale_y_continuous(expand=c(0,0)) # to stop the bars from floating above the x-axis


# You can set the theme with all these changes and have it apply to all the future plots
theme_set(theme_gray()+theme(axis.line = element_line(size=0.5),panel.background = element_rect(fill=NA,size=rel(20)), panel.grid.minor = element_line(colour = NA), axis.text = element_text(size=16), axis.title = element_text(size=18)))

basic

# These tweaks aren't part of the theme, so you will still have to add them separately to each plot
basic + scale_y_continuous(expand=c(0,0)) + guides(fill=FALSE)


# and you can always reset to defaults with:
theme_set(theme_gray())
basic


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