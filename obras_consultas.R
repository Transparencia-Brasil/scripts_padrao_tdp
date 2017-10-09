#Script padrão para verificação das obras do simec
# A planilha é baixada do site do SIMEC

library(dplyr)

obras <- read.csv(url("http://simec.mec.gov.br/painelObras/download.php"), sep=";")

#conferir que a importação foi bem feita:
View(obras) 


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



obras_google <- obras %>%
  filter(Tipo.do.Projeto %in% filtro_google_tipodeprojeto ) %>%
  filter(Situação %in% filtro_google_situacao ) %>%
  filter(Rede.de.Ensino.Público == "Municipal")


#Esse comando abaixo cria um objeto com a lista de município que está
# no app e o número de obras contidas em cada um. Não é necessário alterar
# nada


obras_google_munic <- obras_google %>%
  mutate(num=1) %>%
  group_by(Município, UF) %>%
  summarise(obras = sum(num))

#Salvar: 

setwd("inserir aqui o destino")

write.table(obras_google_munic, file="obras_google_munic.csv", 
            sep=";", row.names=F, na="")


## Para conseguir as escolas em um município X 
## (substituir o X pelo nome do município e o Y pelo estado)

obras_gooole_X <- obras_google %>%
  filter( UF == "Y",                    #substituir
          Município %in% c("X")) %>%    #substituir
  select(id, Nome, Município, CEP, Logradouro, Bairro)

#importante: se estiver com dúvidas sobre a grafia do município ou uf, rode:

unique(obras_google$Município)
unique(obras_google$UF)

#Salvar: 

setwd("inserir aqui o destino")

write.table(obras_google_x, file="obras_google_x.csv", 
            sep=";", row.names=F, na="", quote = F)
