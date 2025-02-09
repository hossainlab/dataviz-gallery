if(!require(pacman))install.packages("pacman")
pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png', 
               'grid', 'ggpubr', 'scales',
               'bbplot')


# Data for chart from gapminder package
line_df <- gapminder %>%
  filter(country == "Malawi") 

# Make plot
line <- ggplot(line_df, aes(x = year, y = lifeExp)) +
  geom_line(colour = "#1380A1", size = 1) +
  geom_hline(yintercept = 0, size = 1, colour="#333333") +
  bbc_style() +
  labs(title="Living longer",
       subtitle = "Life expectancy in Malawi 1952-2007")+
  theme(panel.grid.major.x = element_line(color="#cbcbcb"), 
        panel.grid.major.y=element_blank())


finalise_plot(plot_name = my_line_plot,
              source = "Source: Gapminder",
              save_filepath = "outputs/bbc/filename_that_my_plot_should_be_saved_to.png",
              width_pixels = 640,
              height_pixels = 450)

