# Ref: https://r-graph-gallery.com/web-vertical-line-chart-with-ggplot2.html
library(tidyverse)
library(tidytuesdayR)
library(scales)
library(urbnmapr)
library(patchwork)

# Load the data
path <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-11-07/house.csv"
data <- read.csv(path, sep = ",")

path <- "https://raw.githubusercontent.com/holtzy/R-graph-gallery/refs/heads/master/DATA/democrats-and-republicans.csv"
advantage_df <- read.csv(path)

path <- "https://github.com/holtzy/R-graph-gallery/raw/master/DATA/US-presidents.csv"
presidents_df <- read.csv(path)

# Right chart - Presidents' party information
right_chart <- ggplot() +
  geom_segment(
    data = presidents_df,
    aes(
      x = Start_Year,
      y = 330,
      xend = End_Year,
      yend = 330,
      colour = prez_party
    ),
    linewidth = 2,  # Thicker line for clarity
    show.legend = FALSE
  ) +
  geom_text(
    data = presidents_df,
    aes(
      x = (Start_Year + End_Year) / 2 + 0.1,
      y = 400,
      label = president,
    ),
    color = "#555555",  # Darker color for better contrast
    size = 4,
    hjust = 0,  # Center the text horizontally
    vjust = 1,  # Adjust vertical position of text
    show.legend = FALSE
  ) +
  scale_y_continuous(
    limits = c(300, 1500),
    position = "left"
  ) +
  scale_color_manual(values = c("#64B6EC", "#FF8972")) +
  theme_void() +
  theme(
    plot.margin = margin(t = 0, r = 0, b = 0, l = 0, "points"),
    text = element_text(family = "Arial", size = 12)  # Set font for clarity
  ) +
  coord_flip()

# Left chart - Advantage in U.S. House of Representatives
left_chart <- advantage_df %>%
  ggplot(aes(
    x = year,
    y = advantage,
    color = majority,
    fill = majority
  )) +
  geom_line(aes(group = 1), linewidth = 1.2, show.legend = FALSE) +  # Slightly thicker line
  geom_hline(yintercept = 0, aes(linewidth = 0.5, alpha = 0.8)) +
  geom_point(
    shape = 21,
    data = . %>% filter(advantage != 0),
    size = 3,
    stroke = 1,
    show.legend = FALSE
  ) +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.margin = margin(15, 0, 15, 0),
    panel.grid.major.x = element_line(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.border = element_blank(),
    axis.title = element_text(
      colour = "#333333",  # Darker color for clarity
      size = 14,
      face = "bold"
    ),
    axis.ticks.x = element_blank(),
    axis.ticks.y.right = element_line(),
    axis.text = element_text(
      colour = "#333333",  # Darker color for clarity
      family = "Arial",
      size = 12,
      face = "bold"
    ),
    plot.title = element_text(
      size = 26,
      hjust = 0,
      lineheight = 1.2,
      face = "bold",
      margin = margin(b = 10)
    ),
    plot.subtitle = element_text(
      hjust = 0,
      lineheight = 1.1,
      size = 16,
      margin = margin(b = 20)
    ),
    plot.caption = element_text(
      hjust = 0,
      colour = "#555555",  # Darker color for caption
      size = 12,
      margin = margin(t = 20)
    )
  ) +
  scale_color_manual(values = c("#FF330F", "#2FA3DC")) +
  scale_fill_manual(values = c("#FF8972", "#64B6EC")) +
  scale_y_continuous(
    breaks = c(-300, -200, -100, 0, 100, 200, 300),
    labels = function(x) ifelse(x == -300, paste0(abs(x), " seats"), abs(x)),
    limits = c(-300, 300),
    position = "right"
  ) +
  scale_x_continuous(breaks = seq(1976, 2023, by = 4)) +
  labs(
    x = "",
    y = str_to_upper("  ◄ More Democrats | More Republicans ►"),
    title = str_wrap(
      "Party Advantage in the U.S. House of Representatives, 1976-Present",
      width = 50
    ),
    subtitle = str_wrap(
      "Recent trends in the U.S. House show a close margin between Democrats and Republicans, resulting in fewer dramatic swings in party dominance.",
      width = 75
    ),
    caption = "Source: MIT Election Data and Science Lab, tidytuesday project \nggplot re-creation of an original graphic by FiveThirtyEight\n\nGraphic: Aman Bhargava | Twitter: @thedivtagguy | 🔗 aman.bh"
  )

# Combine the two charts
combined_plot <- left_chart + right_chart + plot_layout(widths = c(8, 1))
combined_plot

# Save the plot with improved resolution and size
ggsave("outputs/ggplot2/03_vertical_linechart.png", plot = combined_plot, width = 7, height = 5, dpi = 300)
