# https://simplystatistics.org/posts/2019-07-19-more-datasets-for-teaching-data-science-the-expanded-dslabs-package/
library(tidyverse)
library(ggplot2)
library(ggflags)
library(countrycode)
library(ggthemes)
library(dslabs)
library(ggrepel)
library(matrixStats)

# set colorblind-friendly color palette
colorblind_palette <- c("black", "#E69F00", "#56B4E9", "#009E73",
                        "#CC79A7", "#F0E442", "#0072B2", "#D55E00")

data(temp_carbon)
# line plot of annual global, land and ocean temperature anomalies since 1880
temp_carbon %>%
  select(Year = year, Global = temp_anomaly, Land = land_anomaly, Ocean = ocean_anomaly) %>%
  gather(Region, Temp_anomaly, Global:Ocean) %>%
  ggplot(aes(Year, Temp_anomaly, col = Region)) +
  geom_line(size = 1) +
  geom_hline(aes(yintercept = 0), col = colorblind_palette[8], lty = 2) +
  geom_label(aes(x = 2005, y = -.08), col = colorblind_palette[8], 
             label = "20th century mean", size = 4) +
  ylab("Temperature anomaly (degrees C)") +
  xlim(c(1880, 2018)) +
  scale_color_manual(values = colorblind_palette) +
  ggtitle("Temperature anomaly relative to 20th century mean, 1880-2018")+
  theme_light()
ggsave("figures/temperature_anomaly .png", width = 10, height = 6)
