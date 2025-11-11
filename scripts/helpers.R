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

# ---------------------------------------------------------
# Obtiene el número de la jornada anterior (actual - 1)
# La API devuelve la jornada en curso, pero los datos válidos
# son de la jornada ya finalizada.
# ---------------------------------------------------------

# numero de jornada
jornada <- fromJSON(txt = content(GET(url = Sys.getenv("URL_JORNADA"), add_headers(.headers = headers)),
                                  "text",
                                  encoding = "UTF-8"
))$journeyActual$number-1

# ================================
# Funciones
# ================================

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
         border: 2px solid black;
       ' src='{userAvatar}'/>
    </div>"
  )
}

# Variables de entorno
base_url <- Sys.getenv("URL_GENERAL_BASE")
top_url <- Sys.getenv("URL_TOP_JORNADA")
png_base <- Sys.getenv("URL_PNG")

# ================================
# Funciones JSON - SuperManager ACB
# ================================

# Construye la URL según tipo ("general" o "jornada")
construir_url_sm <- function(tipo = c("general", "jornada"), indice) {
  tipo <- match.arg(tipo)
  
  if (tipo == "general") {
    paste0(base_url, indice, "&category=1&type=1&community=false")
  } else {
    paste0(top_url,jornada, "&community=false")
  }
}

# Descarga y procesa los datos desde una URL del SuperManager
get_sm_data <- function(construir_url_sm) {
  resp <- GET(url, add_headers(.headers = headers))
  
  if (status_code(resp) != 200) {
    warning(paste("⚠️ Error al acceder a", url))
    return(NULL)
  }
  
  fromJSON(txt = content(resp, "text", encoding = "UTF-8")) %>%
    tibble() %>%
    unnest(cols = c(all)) %>%
    select(-user)
}
