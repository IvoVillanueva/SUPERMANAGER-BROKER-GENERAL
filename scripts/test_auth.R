# librerias
library(httr)
library(jsonlite)

# Cargar variables del entorno
token <- Sys.getenv("SM_TOKEN")
url <- Sys.getenv("URL_JORNADA")

# Comprobación básica
if (token == "" || url == "") {
  stop("❌ Faltan variables de entorno (SM_TOKEN o URL_JORNADA).")
}

# Petición de prueba
res <- GET(url, add_headers(Authorization = token))

# Verifica estado
if (status_code(res) == 200) {
  cat("✅ Autenticación correcta. Conexión establecida.\n")
} else {
  stop(paste0("❌ Error en la autenticación. Código: ", status_code(res)))
}
