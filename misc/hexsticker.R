# define colors
fill_color <- "#00D6E4"
#fill_color <- "#FF06E4"
border_color <- "#000000"

# hex sticker library
library(hexSticker)
library(here)

# public domain image source:
imgurl<-"https://svgsilh.com/png/156056.png"

# 'print' sticker
sticker(imgurl, package="ggx", p_size=10, p_y = 1.2, s_x=1.01, s_y=1.05, s_width=.7,
        filename=here("man/figures/ggx-hexsticker.png"),
        h_fill = fill_color, h_color = border_color,p_color="black")
