library(httr)
library(jsonlite)

#Obras visíveis no app

#número de obras visíveis que dá no meta da consulta no browser
n <- 6000 

pagina <- c(1:n)

token_tdp <- ""

obras_visiveis <- data.frame()

for(i in 1: length(pagina)){ 
  
  url <-  paste0("http://tadepe.transparencia.org.br/api/projects/content?visible_on_app=1&page=", pagina[i]) 
  
  request <- GET(url, add_headers(Authorization = token_tdp))
  
  print(pagina[i])
  print(request$status_code)
  
  response <- content(request, as = "text", encoding = "UTF-8")
  
  df <- fromJSON(response, flatten = TRUE) %>% 
    data.frame()
  
  df <- df %>% mutate_all(as.character())
  
  obras_visiveis <- bind_rows(obras_visiveis, df)
 
  Sys.sleep(.25)
}


