
#Script para upar plhanilha no admin do TDP

library(dplyr)

#inserindo obras SIMEC

obras <- read.csv(url("http://simec.mec.gov.br/painelObras/download.php"), sep=";")

#importante: essa planilha não lê NAs , porque foi assim
# que o SIMEC deixou. Para outros scripts inserir na.strings="" nos parâmetros
#de importação


#tirando os ; da planilha

obras[] <- lapply(obras, gsub, pattern=';', replacement='/')


#inserindo o header padrão
#isso é necessário porque o SIMEC muda o header o tempo todo.


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

dir <- getwd()
pasta <- paste0(dir, "/", "planilhas_upload")

setwd(pasta)

write.table(obras, file=paste0("obras", hj, ".csv"), sep=";", 
            fileEncoding = "utf-8", row.names = FALSE,
            na ="")
