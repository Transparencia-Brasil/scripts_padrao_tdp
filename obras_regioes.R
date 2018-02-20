#Pedidos Lai para regiões 
# Usando esse script para fazer pedidos para regiões para trabalhos dos ESF

library(dplyr)

`%notin%` = function(x,y) !(x %in% y)

obras <- read.csv(url("http://simec.mec.gov.br/painelObras/download.php"), sep=";")

regiao_passos <- c("Pratápolis","Itau de Minas",
                       "São João Batista do Glória",
                       "São José Da Barra", "Passos")

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

#Obras que estão no app na região
obras_apppassos <- obras %>%
  filter(Tipo.do.Projeto %in% filtro_google_tipodeprojeto,
         Situação %in% filtro_google_situacao,
         Rede.de.Ensino.Público == "Municipal",
         Município %in% regiao_passos, UF == "MG")

#Obras pedido novo hamburgo
obras_pedido_passos <- obras %>%
  filter(Tipo.do.Projeto %notin% filtro_google_tipodeprojeto,
         Situação %in% filtro_google_situacao,
         Tipo.do.Projeto %notin% filtro_not_work,
         Rede.de.Ensino.Público == "Municipal",
         Município %in% regiao_passos, UF == "MG")

setwd("C:\\Users\\jvoig\\Documents\\Tadepe")

write.table(obras_apppassos, file="obras_apppassos.csv", 
            sep=";", row.names=F, na="", quote = F)

write.table(obras_pedido_passos, file="obras_pedido_passos.csv", 
            sep=";", row.names=F, na="", quote = F)
