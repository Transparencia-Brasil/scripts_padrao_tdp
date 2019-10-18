## Como fazer algumas consultas na API do Tá de Pé em R?

O projeto Tá de Pé da Transparência Brasil coloca à disposição dos cidadãos uma API que permite que os dados do aplicativo sejam consultados. A seguir, escrevo como realizar algumas das consultas da API utilizando o R. Se você sabe um pouco de R mas não entende muito de APIs, fique tranquila(o) pois para obter os dados basta seguir as instruções abaixo.

### Documentação da API

Para entender o que cada coluna significa, acesse a documentação da API em [https://tadepe.docs.apiary.io/#](https://tadepe.docs.apiary.io/#)

### Obtendo autorização

A API do TDP exige um token de autorização. Você obtem esse token na documentação da API do TDP. Na [documentação](https://tadepe.docs.apiary.io/#) vá em Autorização >> Obter token e clique em *Auths*. Veja se o menu esquerdo está como *Console* e vá em *Call Resource*. Desça a tela até *Response Body* e pegue o código que aparece depois de token, que será algo como "Bearer yy...". Copie esse token, ele será necessário para executar os comandos no R.

### Consulta de obras visíveis no app

O script abaixo retornará um *dataframe* contendo todas as informações armazenadas no aplicativo Tá de Pé sobre as obras visíveis no app.

```r
library(httr)
library(jsonlite)

#Obras visíveis no app

#número de obras visíveis que dá no meta da consulta no browser
n <- 6000  

pagina <- c(1:n)

token_tdp <- "" #insira aqui o token que você pegou no site da documentação da API

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
```
