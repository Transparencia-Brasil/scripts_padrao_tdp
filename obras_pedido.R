#Pedidos Lai por município
#O objetivo desse script é gerar listas de obras para pedidos de cronogramas 
#por cidade

library(dplyr)

`%notin%` = function(x,y) !(x %in% y)

obras <- read.csv(url("http://simec.mec.gov.br/painelObras/download.php"), sep=";")


filtro_google_tipodeprojeto <- c("Espaço Educativo - 12 Salas",
                                 "Espaço Educativo - 01 Sala",
                                 "Espaço Educativo - 02 Salas",
                                 "Espaço Educativo - 04 Salas",
                                 "Espaço Educativo - 06 Salas",
                                 "Projeto 1 Convencional",
                                 "Projeto 2 Convencional")  


filtro_google_situacao <- c("Inacabada",
                            "Planejamento pelo proponente",
                            "Execução",
                            "Paralisada",
                            "Contratação",
                            "Licitação",
                            "Em Reformulação")

filtro_not_work <- c("Ampliação",
                     "Espaço Educativo Ensino Médio Profissionalizante",
                     "Reforma",
                     "QUADRA ESCOLAR COBERTA COM PALCO- PROJETO FNDE",
                     "QUADRA ESCOLAR COBERTA COM VESTIÁRIO- PROJETO FNDE",
                     "QUADRA ESCOLAR COBERTA - PROJETO PRÓPRIO",
                     "COBERTURA DE QUADRA ESCOLAR PEQUENA - PROJETO FNDE",
                     "COBERTURA DE QUADRA ESCOLAR GRANDE - PROJETO FNDE",
                     "COBERTURA DE QUADRA ESCOLAR - PROJETO PRÓPRIO")

#substituir X e Y por Município e UF desejados:

obras_pedido <- obras %>%
  filter(Tipo.do.Projeto %notin% filtro_google_tipodeprojeto,
         Situação %in% filtro_google_situacao,
         Tipo.do.Projeto %notin% filtro_not_work,
         Rede.de.Ensino.Público == "Municipal",
         Município == "X", UF == "Y")

setwd("inserir aqui o destino")

#trocar o x por nome do município

write.table(obras_pedido, file="obras_pedido_X.csv", 
            sep=";", row.names=F, na="", quote = F)