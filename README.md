# 🏀 Clasificación Broker SuperManager 2026

Este repositorio **genera automáticamente una tabla visual con el Top 20 del BrokerBasket del SuperManager ACB 2025/26**, obteniendo los datos actualizados desde la API oficial de *SuperManager ACB* y renderizando una imagen `.png` con formato profesional.

El proceso se ejecuta cada lunes a las **03:00 (UTC)** y guarda la clasificación semanal en la carpeta `data/`.

---

## 📋 Qué hace este repositorio

- Ejecuta el script en R (`brokergeneral.R`) que:
  - Se conecta a la API de SuperManager usando un **token de autorización** almacenado como secreto (`SM_TOKEN`).
  - Extrae la clasificación **BrokerBasket general** (categoría 2, tipo 1).
  - Procesa los datos con `tidyverse`, `httr`, `jsonlite` y genera una tabla con **`gt` + `gtExtras`**.
  - Añade estilos personalizados, avatares de usuarios y un encabezado con logotipo.
  - Inserta en el pie el crédito de autoría, incluyendo los íconos de **𝕏 (Twitter)** y el usuario *@SuperManagerACB*.
  - Exporta la tabla como imagen `.png` dentro de `data/`, con nombre estructurado según la fecha y jornada:
    ```
    brokerGeneral_YYYY_MM_DD_semana_N_jor_J.png
    ```
- El flujo de trabajo de **GitHub Actions** se ejecuta automáticamente todos los lunes a las **03:00 UTC** y también puede lanzarse manualmente.
- Los nuevos archivos `.png` se hacen *commit* y *push* automáticos al repositorio.

---

## ⚙️ Cómo funciona

1. **GitHub Actions** arranca el workflow:
   - Automáticamente cada **lunes a las 03:00 UTC** (`cron: '0 3 * * 1'`).
   - Manualmente mediante *Run workflow*.
2. Configura un entorno **R** con las dependencias necesarias:
   - `tidyverse`, `httr`, `jsonlite`, `gt`, `gtExtras`, `glue`, `lubridate`.
3. Ejecuta el script `brokergeneral.R`, que:
   - Lee el token de acceso desde el secreto `SM_TOKEN`.
   - Consulta las APIs de SuperManager para obtener la jornada actual y la clasificación.
   - Crea la tabla visual del **Top 20 BrokerBasket** con formato ESPN y colores personalizados.
   - Inserta el logotipo del SuperManager y créditos de autoría.
   - Guarda el archivo `.png` dentro de `data/`.
4. Si hay un nuevo archivo, el workflow:
   - Hace `git add data/*.png`
   - Commitea con mensaje `"Auto-update: brokerbasket general"`
   - Ejecuta `git push` automáticamente.

---

## 🗓️ Programación automática

El workflow se ejecuta automáticamente:
- **Todos los lunes a las 03:00 UTC**  
  (equivalente a **05:00 en Madrid** durante el horario de verano y **04:00 en invierno**)
