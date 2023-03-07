# ARN y análisis transcriptómica para biología organísmica

Curso de transcriptomas, marzo 2023, Museo de Historia Natural de UNMSM. 

Este repositorio tiene todas las materias para el curso. Para descargar los archivos, oprima el botón verde que dice "code" y seleciona la última opción "Download Zip." Eso permite que guarde una copia de los archivos compresados en su computador local. 

# instalar packages:

```{r}
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")

install.packages(c("tidyverse", "ggthemes", "gridExtra"))
```
