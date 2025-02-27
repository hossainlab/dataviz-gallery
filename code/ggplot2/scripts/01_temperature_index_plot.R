# Data: https://data.giss.nasa.gov/gistemp/
library(tidyverse)

read_csv("data/GLB.Ts+dSST.csv", skip=1, na = "***") |>
  select(year = Year, t_diff = `J-D`)  |> 
  drop_na() |>
  ggplot(aes(x=year, y=t_diff)) +
  geom_line(aes(color = "1"), size=0.5, show.legend = FALSE) + 
  geom_point(fill="white", aes(color = "1"), shape=21, show.legend=TRUE) +
  geom_smooth(se=FALSE, aes(color = "2"), size=0.5, span=0.15, show.legend = FALSE) +
  scale_x_continuous(breaks=seq(1880, 2024, 20), expand=c(0,0)) +
  scale_y_continuous(limits=c(-0.5, 1.5), expand=c(0,0)) +
  scale_color_manual(name=NULL,
                     breaks=c(1, 2),
                     values=c("gray", "black"),
                     labels=c("Annual mean", "Lowess smoothing"), 
                     guide = guide_legend(override.aes = list(shape=15, size=5))) +
  labs(
    x = "Year",
    y = "Temperature anomaly (C)",
    title = "Global Land-Ocean Temperature Index",
    subtitle = "Visualizing temperature anomalies from 1880 to present, highlighting annual variations and long-term trends.",
    caption = "Data Source:NASA/GISS"
  ) +
  theme_light() +
  theme(
    axis.ticks = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(margin = margin(b=5), color="black", face="bold"),
    plot.subtitle = element_text(size=8, margin = margin(b=8)),
    legend.position = c(0.15, 0.9),
    legend.title = element_text(size=0),
    legend.key.height = unit(10, "pt"),
    legend.margin = margin(0,0,0,0)
  )

ggsave("outputs/ggplot2/01_temperature_index_plot.png", width=6, height=4)
