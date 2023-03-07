# ARN y análisis transcriptómica para biología organísmica

Curso de transcriptomas, marzo 2023, Museo de Historia Natural de UNMSM. 

Este repositorio tiene todas las materias para el curso. Para descargar los archivos, oprima el botón verde que dice "code" y seleciona la última opción "Download Zip." Eso permite que guarde una copia de los archivos compresados en su computador local. 

El curso se consiste en tres partes:

1) Como y porque usar transcriptomas en estudios de biología organísmica 
2) Actividad en `R` para analizar datos de expresión 
3) Práctica de como extraer ARN de plantas 

## Preparación parte teórica

Antes del curso, los estudiantes deben leer los siguientes artiículos: 

1) Oppenheim, Sara J., et al. "We can't all be supermodels: the value of comparative transcriptomics to the study of non‐model insects." Insect Molecular Biology 24.2 (2015): 139-154

2) Tribble, Carrie M., et al. "Comparative transcriptomics of a monocotyledonous geophyte reveals shared molecular mechanisms of underground storage organ formation." Evolution & Development 23.3 (2021): 155-173.

## Preparación parte análisis

Los estudiantes deben traer computador personal, con R y RStudio instalado, y con los siguientes paquetes listos:

```{r}
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")

install.packages(c("tidyverse", "ggthemes", "gridExtra"))
```

Los estudiantes deben descargar este repositario en su computador. 

## Preparación parte laboratorio 

Los estudiantes deben traer dos muestras de plantas colectadas en RNAlater (el protocolo de colecta será descrito en la parte teórica y habrá RNAlater para los estudiantes). 
