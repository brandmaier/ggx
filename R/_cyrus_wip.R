library(ggplot2)

diamonds <- ggplot2::diamonds

p <- ggplot(data = diamonds, aes(x = carat, y = price)) + 
  geom_point()