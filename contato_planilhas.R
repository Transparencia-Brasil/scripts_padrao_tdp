library(readxl)
library(googlesheets)
library(dplyr)

url_contatos <- "https://docs.google.com/spreadsheets/d/1cxk1KUvncZ8SiavMmGkP4lYXjQ-7KD4corBjqkMjOxA/edit?usp=sharing"

#Autenticação:
gs_ls() 

#Importando:
contatos_sheet <- gs_title("TDP_Contatos_produção_nova")

#Atribuindo o df a um objeto:
contatos_tdp <- contatos_sheet %>%
  gs_read()


setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\tadepe\\planilhas_exportadas_admin_tdp")
write.table(contatos_tdp, file="contatos_upload.csv",
            row.names = FALSE, fileEncoding = "utf-8",
            quote = FALSE, sep=",", na= "")
