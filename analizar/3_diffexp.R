library(tidyverse)
library(DESeq2)

# cargar los datos y la anotación de la transcriptoma 
source("analizar/1_procesar.R")
annotated <- read.csv(file = "datos/trinotate_annotation_report.csv",
                      na.strings = ".", stringsAsFactors = FALSE)

# correr análisis de differential expression
dds <- DESeq(dds) # muy sencillo el código no?? pero complicado lo que hace

# identficar las isoformas significativos entre tubérculos y raíces
results(dds, contrast = c("condition","tub","roo"),
        alpha  = 0.01, lfcThreshold = 2) %>%
  as.data.frame() %>%
  mutate(transcript_id = rownames(.) ) %>%
  mutate(sig = abs(log2FoldChange) > 2 & padj < 0.01) %>%
  mutate(xaxis = 1:nrow(dds)) %>%
  arrange(sig) -> 
  diff_expression

#guardar en datos
save(diff_expression, file = "datos/diff_expression.RData")

# plot 
pdf("figuras/logfoldchange.pdf")
p <- ggplot(diff_expression) +
  geom_point(aes(x = xaxis, 
                 y = log2FoldChange,
                 color = sig,
                 shape = sig)) +
  scale_color_discrete() +
  scale_shape_manual(values = c("TRUE" = 3,
                                "FALSE" = 20), 
                     labels = c("Not Signficant","Significant")) +
  scale_color_manual(values = c("TRUE" = "red", 
                                "FALSE" = "#bbbbbb60"),
                     labels = c("Not Signficant","Significant")) +
  scale_y_continuous(name = "Log2 Fold Change in Expression") +
  theme_bw() +
  theme(legend.title = element_blank(), 
        legend.position = c(0.015, 0.01),
        legend.justification = c(0,0),
        legend.background = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank())
print(p)
dev.off()
