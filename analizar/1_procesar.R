library(DESeq2)

#### procesar los datos ####

# estos primeros pasos son pesados, así que los vamos a saltar en este taller. 
# Parar correr estos pasos necesitarás otro paquete "tximport," lo cual se puede
# instalar en bioconductor igual que DESeq2

# conditions <- read.table("samples_described.txt",sep="\t", header = TRUE,
#                          row.names = 1)

# files <- file.path(paste0("isoform_results/RSEM.isoforms.results.", 
#                    rownames(conditions)))

# names(files) <- rownames(conditions)

# txi.rsem <- tximport(files, txIn = TRUE, txOut = TRUE,  
#                      geneIdCol =  "transcript_id", 
#                      txIdCol = "transcript_id",
#                      lengthCol = "effective_length",
#                      abundanceCol = "FPKM",
#                      countsCol = "expected_count")

# dds <- DESeqDataSetFromTximport(txi.rsem,
#                                 colData = conditions,
#                                 design = ~ condition)

# save(dds, file = "dds.RData")

load("datos/dds.RData")

# solo analizar isoformas que tienen 10 o mas 
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

dds$condition <- factor(dds$condition, levels = c("rhi", "roo", "SAM", "tub"))