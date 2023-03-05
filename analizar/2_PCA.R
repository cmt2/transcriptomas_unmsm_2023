library(DESeq2)
library(tidyverse)
library(ggthemes)

source("analizar/1_procesar.R")

##### transformar con "variance stabilizing transformation" #####

# transformación para normalizar los datos (tamaño y varianza)
vst <- vst(dds, blind = FALSE) 

# estimar coordinados para el PCA
pcaData_vst <- plotPCA(vst, returnData = TRUE) 

# estimar porcentage de cada axis 
percentVar <- round(100 * attr(pcaData_vst, "percentVar")) 

# colores 
myColors <- c("tub" = "#a6cee3", "roo" = "#1f78b4",
              "rhi" = "#b2df8a", "SAM" = "#33a02c")

# dataframe con los nombres de muestras en los datos 
# y a cuál planta pertenence 
samples_to_individuals <- data.frame(
  sample = c("tub_2","roo_2","rhi_2",
             "SAM_3","SAM_1","SAM_2",
             "tub_1","roo_3","rhi_1",
             "rhi_3","roo_1","tub_3"),
  individual = c("A", "A", "A", "A",
                 "B", "C", "D", "D",
                 "D", "E", "E", "E"))

pcaData_vst <- inner_join(pcaData_vst, 
                          samples_to_individuals, 
                          by = c("name"="sample"))

# hacer la figura 
pdf("figuras/pca.pdf", width = 5, height = 5, useDingbats = FALSE)
p <- ggplot(pcaData_vst, aes(x = PC1, 
                             y = PC2, 
                             color = group)) +
     geom_point(size = 2) +
     geom_text(aes(label = individual),size = 3,
               color = "black",
               nudge_x = 4, nudge_y = 0,
               show.legend = FALSE) +
     xlab(paste0("PC1: ", percentVar[1], "% variance")) +
     ylab(paste0("PC2: ", percentVar[2], "% variance")) +
     coord_equal() +
     scale_color_manual(values = myColors,
                        name = "Tissue Type",
                        breaks = c("SAM","rhi",
                                   "roo","tub"),
                        labels = c("Aerial Shoot",
                                   "Rhizome",
                                   "Fibrous Root",
                                   "Tuberous Root") ) +
     ggtitle("VST transformed transcript counts") +
     theme_few() +
     guides(color = guide_legend(override.aes = 
                                   list(shape = 20))) +
     theme(plot.title = element_text(hjust = 0.5),
           legend.position = c(0.01, 0.01),
           legend.justification = c(0,0),
           legend.key.size = unit(.2, "cm"),
           legend.text=element_text(size=9),
           legend.title = element_text(size = 10),
           legend.text.align = 0,
           legend.title.align = 0,
           axis.ticks = element_blank(),
           axis.text = element_blank())
print(p)
dev.off()
