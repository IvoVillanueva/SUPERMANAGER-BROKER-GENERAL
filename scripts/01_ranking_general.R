# =========================================================
# Script: 01_descargar_jornadas.R
# Autor: Ivo Villanueva
# Fecha: 2025-11-08
# Descripción: Descarga datos crudos de clasificación
#              general del SuperManager ACB.
# =========================================================

source("scripts/helpers.R")


pausa <- 1
pause_every <- 100
pause_seconds <- 5

resultados <- list()

for (i in 1:3081) {
  url <- construir_url_sm("general", i)
  df <- get_sm_data(url)

  if (is.null(df) || sum(df$totalPlayerPoints, na.rm = TRUE) <= 0) break

  resultados[[i]] <- df

  Sys.sleep(pausa)
  if (i %% pause_every == 0) Sys.sleep(pause_seconds)
}

# Dataset unificado
df_general <- bind_rows(resultados)

