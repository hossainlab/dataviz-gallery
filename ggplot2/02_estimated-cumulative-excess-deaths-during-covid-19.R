# Data Source:https://ourworldindata.org/explorers/covid?country=~BGD&Metric=Excess+mortality+%28estimates%29&Interval=Cumulative&Relative+to+population=false
library(tidyverse)

data <- read_csv("data/estimated-cumulative-excess-deaths-during-covid-19.csv") |> 
  select(date =Day, 
         central_estimate = `Cumulative excess deaths (central estimate)`, 
         lower_bound = `Cumulative excess deaths (95% CI, lower bound)`, 
         upper_bound = `Cumulative excess deaths (95% CI, upper bound)`, 
         confirmed_cases = `Total confirmed deaths due to COVID-19`) |> 
  filter(!is.na(central_estimate) | !is.na(lower_bound) | !is.na(upper_bound), !is.na(confirmed_cases))

# Convert date to proper date format
data$date <- ymd(data$date)
# Calculate y-axis limits to include all data points
y_min <- floor(min(data$lower_bound)) # Round down to nearest integer
y_max <- ceiling(max(data$upper_bound)) # Round up to nearest integer

# Create the plot
ggplot(data, aes(x = date)) +
  geom_line(aes(y = upper_bound), color = "lightgray", linewidth = 1.2) +
  geom_line(aes(y = central_estimate), color = "#A53F29", linewidth = 1.2) +
  geom_line(aes(y = lower_bound), color = "lightgray", linewidth = 1.2) +
  geom_line(aes(y = confirmed_cases), color = "black", linewidth = 1.2)+
  labs(title = "",
       x = "", 
       y = "") +
  
  # Add annotations (adjust positions as needed)
  annotate("text", x = max(data$date), y = 1400000, label = "1.4 million", hjust = 1, vjust = 0) +
  annotate("text", x = max(data$date), y = 1200000, label = "Upper bound", hjust = 1, vjust = 0, color = "lightgray") +
  annotate("text", x = max(data$date), y = 900000, label = "Central estimate", hjust = 1, vjust = 0, color = "#A53F29") +
  annotate("text", x = max(data$date), y = 300000, label = "Lower bound", hjust = 1, vjust = 0, color = "lightgray") +
  annotate("text", x = max(data$date), y = 0, label = "Confirmed deaths", hjust = 1, vjust = 1) +
  
  theme_light() +  # Use a minimal theme for cleaner look
  theme(panel.grid = element_blank(),  # Remove grid lines
        axis.text.y = element_text(size = 10),  # Adjust y-axis text size if needed
        axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability


ggsave("outputs/ggplot2/02_estimated-cumulative-excess-deaths-during-covid-19.png", width = 8, height = 6)

