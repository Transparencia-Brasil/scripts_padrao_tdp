library(readxl)
library(googlesheets)
library(dplyr)

#Autenticação:
gs_ls() 

#Importando:
contatos_sheet <- gs_title("planilha_contatos_producao_tdp")

#Atribuindo o df a um objeto:
contatos_tdp <- contatos_sheet %>%
  gs_read()

dir <- getwd()
destino <- paste0(dir, "/contatos_upload")
setwd(destino)

hj <- Sys.Date()

write.table(contatos_tdp, file=paste0(hj, "contatos_upload.csv"),
            row.names = FALSE, fileEncoding = "utf-8",
            quote = FALSE, sep=",", na= "")
