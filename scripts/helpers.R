#librerias
library(tidyverse)
library(httr)
library(jsonlite)
library(gt)
library(gtExtras)
library(glue)
library(lubridate)

#caption
twitter <- "<span style='color:#c04719'>&#x1D54F;</span>"
tweetelcheff <- "<span style='font-weight:bold;'>*@elcheff*</span>"
caption <- glue("&nbsp;&nbsp;**Gráfico**: *Ivo Villanueva* • {twitter} {tweetelcheff}&nbsp;&nbsp;para&nbsp;&nbsp;{twitter} *@SuperManagerACB*")

# fecha de hoy
fecha <- paste0(Sys.Date(), "_semana_", week(today()))

# cabeceras
headers <- c(
  "Authorization" = Sys.getenv("SM_TOKEN"),
  "Accept" = "application/json"
)

# numero de jornada
jornada <- fromJSON(txt = content(GET(url = Sys.getenv("URL_JORNADA"), add_headers(.headers = headers)),
                                  "text",
                                  encoding = "UTF-8"
))$journeyActual$number-1


#función ranking
add_rk <- function(rk) {
  div_out <- htmltools::div(
    style = (
      "background: linear-gradient(-45deg,  #fcfcfa, #ffa031);
                              margin: 1px;
  text-align: center;
  width: 50px;
  height: 50px;
  border-radius: 20%;
  font-size:30px;
  vertical-align:middle;
  background-color: #000000;
  color:white;
    position: relative;"
    ),
    paste(rk)
  )
  
  as.character(div_out) %>%
    gt::html()
}

#función foto
add_photo_frame <- function(userAvatar) {
  glue::glue(
    " <img style='
         width: 46px;
         height: 46px;
         border-radius: 50%;
         margin-top: 8px!important;
         display: block;
         align-items: right;
         border: 2px solid 'black';' src='{userAvatar}'/>
    </div>"
  )
}

