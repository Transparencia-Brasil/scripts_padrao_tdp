library(dplyr)
library(janitor)

obras <- read.csv(url("http://simec.mec.gov.br/painelObras/download.php"), sep=";", na.strings = "")

#Objetivo: 
# 1 . Encontrar todas as obras que já deviam ter sido terminadas independentemente de termos
# ou não o cronograma

#2. Encontrar todas as obras que, apesar de ter prazo de término, já deveriam ter sido concluídas
# de acordo com a execução do cronograma

#1. Objeto obras_1 : têm assinatura de contrato

obras_1 <- obras %>%
  clean_names() %>%
  mutate(data_de_inicio = as.character(substr(data_de_assinatura_do_contrato, 0, 10)),
         data_de_termino = as.character(substr(data_prevista_de_conclusao_da_obra, 0, 10)),
         data_de_inicio = as.Date(data_de_inicio, format="%Y-%m-%d"),
         data_de_termino = as.Date(data_de_termino, format="%d/%m/%Y"),
         hoje = as.Date("2018-04-20")) %>%
  filter(!is.na(data_de_inicio),
         situacao !="Concluída",
         situacao !="Obra Cancelada")

#b. cronogramas:

execucao <- c("projeto, execucao",
              "Escola de Educação Infantil Tipo B, 9",
              "Escola de Educação Infantil Tipo C, 6",
              "MI - Escola de Educação Infantil Tipo B, 6",
              "MI - Escola de Educação Infantil Tipo C, 4",
              "Espaço Educativo - 12 Salas, 13",
              "Espaço Educativo - 01 Sala, 5",
              "Espaço Educativo - 02 Salas, 5",
              "Espaço Educativo - 04 Salas, 7",
              "Espaço Educativo - 06 Salas, 7",
              "Projeto 1 Convencional, 11",
              "Projeto 2 Convencional, 9")

execucao  <- read.csv(text = execucao , strip.white = TRUE) 
projeto_conhecido <- execucao$projeto

#1 Atrasadas_oficialmente:

atrasadas_oficial <- obras_1 %>%
  filter(data_de_termino < hoje) %>%
  mutate(data_final_ideal = NA) %>%
  select(id, nome, situacao, municipio, uf, cep, logradouro, bairro, termo_convenio,
         fim_da_vigencia_termo_convenio, situacao_do_termo_convenio, percentual_de_execucao,
         data_de_inicio, data_de_termino, data_final_ideal, tipo_do_projeto, tipo_de_ensino_modalidade, tipo_da_obra,
         valor_pactuado_pelo_fnde, percentual_pago)

id_atrasadas_oficial <- atrasadas_oficial$id

#2 Atrasadas não oficialmente

`%notin%` = function(x,y) !(x %in% y)

atrasadas_real <- obras_1 %>%
  filter(id %notin% id_atrasadas_oficial,
         tipo_do_projeto %in% projeto_conhecido)%>%
  left_join(execucao, by=c("tipo_do_projeto" = "projeto"))%>%
  mutate(execucao_dias = as.numeric(execucao)*30,
         data_final_ideal = data_de_inicio + execucao_dias) %>%
  filter(data_final_ideal < hoje) %>%
  select(id, nome, situacao, municipio, uf, cep, logradouro, bairro, termo_convenio,
         fim_da_vigencia_termo_convenio, situacao_do_termo_convenio, percentual_de_execucao,
         data_de_inicio, data_de_termino, data_final_ideal, tipo_do_projeto, tipo_de_ensino_modalidade, tipo_da_obra,
         valor_pactuado_pelo_fnde, percentual_pago)
         
  
atrasadas_real_oficial <- bind_rows(atrasadas_real, atrasadas_oficial)%>%
  arrange(desc(data_de_termino))

x <- atrasadas_real_oficial %>%
  group_by(municipio, uf) %>%
  summarise(obras=n())

setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\tadepe\\scripts_padrao_tdp")
save(atrasadas_real_oficial, file="atrasadas_real_oficial.Rdata")

write.csv(atrasadas_real_oficial, file="atrasadas_real_oficial.csv", row.names = FALSE)
