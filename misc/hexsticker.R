# define colors
fill_color <- "#FFD6E4"
border_color <- "#FFFFFF"

# hex sticker library
library(hexSticker)
library(here)

# public domain image source:
imgurl<-"https://svgsilh.com/png/852818.png"

# 'print' sticker
sticker(imgurl, package="ggx", p_size=10, s_x=1.01, s_y=.85, s_width=.6,
        filename=here("man/figures/ggx-hexsticker.png"),h_fill = fill_color, h_color = border_color,p_color="black")
