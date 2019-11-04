## Como fazer algumas consultas na API do Tá de Pé em R?

O projeto Tá de Pé da Transparência Brasil coloca à disposição dos cidadãos uma API que permite que os dados do aplicativo sejam consultados. A seguir, escrevo como realizar algumas das consultas da API utilizando o R. Se você sabe um pouco de R mas não entende muito de APIs, fique tranquila(o) pois para obter os dados basta seguir as instruções abaixo.

### Documentação da API

Para entender o que cada coluna significa, acesse a documentação da API em [https://tadepe.docs.apiary.io/#](https://tadepe.docs.apiary.io/#)

### Obtendo autorização

A API do TDP exige um token de autorização. Você obtem esse token na documentação da API do TDP. Na [documentação](https://tadepe.docs.apiary.io/#) vá em Autorização >> Obter token e clique em *Auths*. Veja se o menu esquerdo está como *Console* e vá em *Call Resource*. Desça a tela até *Response Body* e pegue o código que aparece depois de token, que será algo como "Bearer yy...". Copie esse token, ele será necessário para executar os comandos no R.

### Consulta de obras visíveis no app

O script abaixo retornará um *dataframe* contendo todas as informações armazenadas no aplicativo Tá de Pé sobre as obras visíveis no app.

Apenas duas coisas precisarão ser alteradas no script abaixo: o token e o n.
O n é o número de páginas da consulta. Quando realizamos a consulta na API do TDP são exibidas 10 entradas por página. Hoje a quantidade de obras visíveis no app é 6033, portanto 604 páginas. Se você entende um pouco mais de APIs, você pode rodar uma consulta no console da documentação das APIs ( Obter obras >> Projects , marcar o visible = 1 ) e olhar o "count" dentro do parâmetro "meta" no final da consulta e dividir esse número por 10, esse será o número de páginas necessárias para coletar todas as informações. 

O *dataframe* resultante da consulta abaixo será o objeto *obras_visiveis*

```r
library(httr)
library(jsonlite)

#Obras visíveis no app

#número de obras visíveis que dá no meta da consulta no browser
n <- 604  

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

### Consulta de alertas recebidos

Nesse exemplo, vou fazer a consulta para uma série de projetos que estão dentro do objeto `ids`

```r
library(httr)
library(jsonlite)
library(dplyr)

#Obras visíveis no app

ids <- c("1006408", "1006409", "1010358", "1006332", "1006593", "1009183")

token_tdp <- " "

alertas <- data.frame()

for(i in 1:length(ids)){
  
  print(ids[i])
  url <- paste0("http://tadepe.transparencia.org.br/api/inspections/content?project_id=", ids[i])
  
  request <- GET(url, add_headers(Authorization = token_tdp))
  print(request$status_code)
  
  response <- content(request, as = "text", encoding = "UTF-8")
  
  df <- fromJSON(response, flatten = TRUE) 
  df <- df[[1]]
  
  alertas <-  rbind(alertas, df)
  print(url)
  }
```


### Consulta de respostas recebidas

Aqui está um exemplo de consulta às respostas do TDP.
No caso, eu optei por selecionar as respostas pelos ids dos alertas. Mas se eu quisesse trabalhar com o id dos projetos eu poderia ter terminado a consulta com `project_id=1009156`. Os ids dos alertas estão dentro do objeto `inspection_ids`.
O interessante é que caso o alerta ainda não tenha uma resposta, a consulta terá sucesso (status_code == 200) mas o df que será acrescido vai estar em branco. Por isso eu não precisei colocar condicionais (if) nessa consulta. 

```r

inspection_ids <- c("223", "224", "225")

respostas <- data.frame()

for(i in 1:length(inspection_ids)){
  
  url <- paste0("http://tadepe.transparencia.org.br/api/answers/content?inspection_id=", inspection_ids[i])
  request <- GET(url, add_headers(Authorization = token_tdp))
  print(request$status_code)
  response <- content(request, as = "text", encoding = "UTF-8")
  df <- fromJSON(response, flatten = TRUE) 
  df <- df[[1]]
  respostas <- rbind(respostas, df)
}

```
