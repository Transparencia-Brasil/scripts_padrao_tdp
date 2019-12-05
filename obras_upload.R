#Script para upar plhanilha no admin do TDP

library(dplyr)
library(janitor)

#inserindo obras SIMEC

obras <- read.csv("", sep=";")

#importante: essa planilha não lê NAs , porque foi assim
# que o SIMEC deixou. Para outros scripts inserir na.strings="" nos parâmetros
#de importação


#tirando os ; da planilha

obras[] <- lapply(obras, gsub, pattern=';', replacement='/')


#inserindo o header padrão
#isso é necessário porque o SIMEC muda o header o tempo todo.


quadras <- c("QUADRA ESCOLAR COBERTA COM PALCO- PROJETO FNDE",   
             "QUADRA ESCOLAR COBERTA COM VESTIÁRIO- PROJETO FNDE",
             "QUADRA ESCOLAR COBERTA - PROJETO PRÓPRIO",                         
             "COBERTURA DE QUADRA ESCOLAR PEQUENA - PROJETO FNDE", 
             "COBERTURA DE QUADRA ESCOLAR GRANDE - PROJETO FNDE", 
             "COBERTURA DE QUADRA ESCOLAR - PROJETO PRÓPRIO",      
             "Quadra Escolar Coberta e Vestiário - Modelo 2")        

obras <- obras %>%
  clean_names() %>%
  mutate(nome = toupper(nome),
         nome = ifelse(tipo_do_projeto %in% quadras & !grepl("QUADRA", nome), paste0("QUADRA ", nome), nome)) %>%
  filter(!is.na(nome))

names(obras) <- c( "ID"                                            
                   , "Nome"                                          
                   , "Situação"                                      
                   , "Município"                                     
                   , "UF"                                            
                   , "CEP"                                           
                   , "Logradouro"                                    
                   , "Bairro"                                        
                   , "Termo/Convênio"                                
                   , "Fim da Vigência Termo/Convênio"                
                   , "Situação do Termo/Convênio"                    
                   , "Percentual de Execução"                        
                   , "Data Prevista de Conclusão da Obra"            
                   , "Tipo de ensino / Modalidade"                   
                   , "Tipo do Projeto"                               
                   , "Tipo da Obra"                                  
                   , "Classificação da Obra"                         
                   , "Valor Pactuado pelo FNDE"                      
                   , "Rede de Ensino Público"                        
                   , "CNPJ"                                          
                   , "Inscrição Estadual"                            
                   , "Nome da Entidade"                              
                   , "Razão Social"                                  
                   , "Email"                                         
                   , "Sigla"                                         
                   , "Telefone Comercial"                            
                   , "Fax"                                           
                   , "CEP Entidade"                                  
                   , "Logradouro Entidade"                           
                   , "Complemento Entidade"                          
                   , "Número Entidade"                               
                   , "Bairro Entidade"                               
                   , "UF Entidade"                                   
                   , "Munícipio Entidade"                            
                   , "Modalidade de Licitação"                       
                   , "Número da Licitação"                           
                   , "Homologação da Licitação"                      
                   , "Empresa Contratada"                            
                   , "Data de Assinatura do Contrato"                
                   , "Prazo de Vigência"                             
                   , "Data de Término do Contrato"                   
                   , "Valor do Contrato"                             
                   , "Valor Pactuado com o FNDE"                     
                   , "Data da Última Vistoria do Estado ou Município"
                   , "Situação da Vistoria"                          
                   , "OBS"                                           
                   , "Total Pago"                                    
                   , "Percentual Pago"                               
                   , "Banco"                                         
                   , "Agência"                                       
                   , "Conta"                                         
                   , "Data"                                          
                   , "Saldo da Conta"                                
                   , "Saldo Fundos"                                  
                   , "Saldo da Poupança"                             
                   , "Saldo CDB"                                     
                   , "Saldo TOTAL")


hj <- Sys.Date()

#colocar pasta de destino:

setwd()

write.table(obras, file=paste0("obras", hj, ".csv"), sep=";", 
            fileEncoding = "utf-8", row.names = FALSE,
            na ="")
