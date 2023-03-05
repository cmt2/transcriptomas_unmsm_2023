library(gridExtra)
library(tidyverse)

#####  cargar datos ##### 
load("datos/diff_expression.RData") 
anotacion <- read.csv(file = "datos/trinotate_annotation_report.csv",
                      na.strings = ".", stringsAsFactors = FALSE)

#####  funcion para procesar términos GO ##### 
parse_go_terms <- function(terms) {
  cell_components <- character()
  mol_functions <- character()
  bio_process <- character()
  for (i in 1:length(terms)){
    if (!is.na(terms[i])){
      
      l <- unlist(strsplit(terms[i],  "`"))
      
      for (j in 1:length(l)){
        
        s <- unlist(strsplit(l[j], "\\^"))
        
        if (s[2] == "cellular_component"){
          cell_components <- append(cell_components, s[3])
        } else if (s[2]  == "molecular_function"){
          mol_functions <- append(mol_functions, s[3])
        } else if (s[2] == "biological_process"){
          bio_process <- append(bio_process, s[3])
        }
      }
    }
  }
  return(list(cell_components = cell_components,
              mol_functions = mol_functions,
              bio_process =  bio_process))
}

##### selecionar genes significativos y juntar información de GO ##### 
diff_expression %>%
  left_join(anotacion) %>%
  mutate(abs_log2FoldChange = abs(log2FoldChange)) %>%
  arrange(desc(abs_log2FoldChange)) %>%
  head(n = 10) -> top_10_DEGs

##### hacer tabla ##### 
transcript <- character()
ann_name <- character()
names <- character()
log2FoldChange <- numeric()
cell_components <- character()
mol_functions <- character()
bio_process <- character()

for (i in 1:length(top_10_DEGs$gene_ontology_blast)){
  transcript[i] <- top_10_DEGs$transcript_id[i]
  ann_name[i] <- strsplit(strsplit(strsplit(strsplit(top_10_DEGs$sprot_Top_BLASTP_hit[i], "\\^")[[1]][6], "=")[[1]][2], ";")[[1]][1], "\\{")[[1]][1]
  names[i] <- paste0(transcript[i], ": ", ann_name[i])
  log2FoldChange[i] <- round(top_10_DEGs$log2FoldChange[i], digits = 2)
  c <- character()
  m <- character()
  b <- character() 
  if (!is.na(top_10_DEGs$gene_ontology_blast[i])){
    l <- unlist(strsplit(top_10_DEGs$gene_ontology_blast[i],  "`"))
    for (j in 1:length(l)){
      s <- unlist(strsplit(l[j], "\\^"))
      if (s[2] == "cellular_component"){
        c <- append(c, s[3])
      } else if (s[2]  == "molecular_function"){
        m <- append(m, s[3])
      } else if (s[2] == "biological_process"){
        b <- append(b, s[3])
      }
    }
    cell_components[i] <- paste(c, collapse = ", ")
    mol_functions[i] <- paste(m, collapse = ", ")
    bio_process[i] <- paste(b, collapse = ", ")
  } else {
    cell_components[i] <- NA
    mol_functions[i] <- NA
    bio_process[i] <- NA
  }
}

data.frame(names = names,
           log2FoldChange = log2FoldChange,
           cell_components = cell_components, 
           mol_functions = mol_functions,
           bio_process = bio_process) -> table 

pdf("figuras/tabla.pdf", height=5, width=35)
p <- grid.table(table,
                rows = rep("", 10))
print(p)
dev.off()
