library(data.table)
library(magrittr)
library(janitor)
library(lubridate)
library(ggplot2)

# packageVersion("patchwork")

fmt <- paste0("%.", 2, "f")

nea_color <- c("#BED73B", "#58B6DC","#F58A06")

LJYtheme_basic <- theme(
  plot.title = element_text(size = 12, vjust = 0, face = "bold"),
  axis.text.x = element_text(size = 12, hjust=.5, vjust=1, colour="black"),
  axis.text.y = element_text(size = 12, hjust=1, vjust=.5, colour="black"),
  axis.title.y = element_text(size = 12, color = "black", face = "bold", vjust = 0.5, hjust = 0.5),
  axis.title.x = element_text(size = 12, color = "black", face = "bold", vjust = 0.5, hjust = 0.5),
  axis.line = element_line(color = "black"),
  # panel.grid.major=element_blank(),
  # panel.grid.major = element_line(colour="#f0f0f0"),
  panel.grid.major = element_line(colour="#f7f7f7"),
  # panel.grid.major = element_blank(),
  # panel.grid.minor=element_line(colour="#f0f0f0",size = 0.1),
  panel.grid.minor=element_blank(),
  # panel.background=element_rect(fill='white',colour='black'),
  legend.text = element_text(size = 12),
  legend.key = element_rect(colour = NA, fill = "white"),
  panel.background = element_blank(),
  # legend.position = "bottom",
  # legend.direction = "horizontal",
  # legend.key.size= unit(0.3, "cm"),
  # legend.margin = margin(0,0,0,0,"cm"),
  legend.title = element_text(face = "bold", size = 12),
  strip.background = element_rect(colour= NA, fill="#f0f0f0"),
  strip.text = element_text(face = "bold", size = 12)
)

