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


setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\tadepe\\planilhas_exportadas_admin_tdp")
write.table(contatos_tdp, file="contatos_upload.csv",
            row.names = FALSE, fileEncoding = "utf-8",
            quote = FALSE, sep=",", na= "")
