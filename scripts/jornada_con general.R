source("scripts/helpers.R")

# asegurar que la carpeta data existe
if (!dir.exists("png")) dir.create("png")

resultados <- list()

for (i in 1:3081) {
  df <- fromJSON(txt = content(
    GET(
      url = paste0(
        "https://supermanager.acb.com/api/basic/userteam/standing/1?_page=",
        i, "&category=1&type=1&community=false"
      ),
      add_headers(.headers = headers)
    ),
    "text",
    encoding = "UTF-8"
  )) %>%
    tibble() %>%
    unnest(cols = c(all)) %>%
    select(-user) %>%
    mutate(
      userAvatar = paste0("https://supermanager.acb.com/files/", userAvatar),
      pagina_num = i, .before = amount
    )
  
  if (sum(df$totalPlayerPoints, na.rm = TRUE) <= 0) break
  
  resultados[[i]] <- df
  
  message("✅ Página ", i, " descargada")
  
  Sys.sleep(1)
  
  if (i %% 100 == 0) {
    Sys.sleep(5)
    message("⏸️ Pausa de 5 segundos después de 100 páginas")
  }
}

funcion_number_df <- bind_rows(resultados)


write_csv(funcion_number_df, paste0("data/supermanager_alltime_standings_5", Sys.Date(), ".csv"))

#######################################################################################################################################################
################################ clasifición jornada ##################################################################################################
#######################################################################################################################################################

# fecha de hoy
fecha <- paste0(Sys.Date(), "_semana_", week(today()))

clasificacion_general <-  funcion_number_df

fromJSON(txt = content(
  GET(
    url = paste0(
      "https://supermanager.acb.com/api/basic/userteam/standing/1?_page=1&category=1&type=2&numJourney=",
      jornada, "&community=false"
    ),
    add_headers(.headers = headers)
  ),
  "text",
  encoding = "UTF-8"
)) %>%
  tibble() %>%
  unnest(cols = c(all)) %>%
  select(-user) %>%
  mutate(userAvatar = paste0(
    "https://supermanager.acb.com/files/",
    userAvatar
  )) %>%
  head(20) %>%
  left_join(clasificacion_general %>%
              select(nameTeam,
                     pointsgeneral = totalPlayerPoints,
                     positiongneral = position
              ), join_by(nameTeam)) %>%
  mutate(
    combo_img = add_photo_frame(userAvatar),
    combo_img = map(combo_img, gt::html),
    rk1 = position,
    rk2 = positiongneral,
    # rk3 = rank(jornadaPlayerPoints),
    nameTeam = toupper(nameTeam)
  ) %>%
  head(20) %>%
  select(arrow, combo_img, username, nameTeam,
         totalPlayerPoints,
         rk1 = position, pointsgeneral,
         rk2 = positiongneral
  ) %>%
  replace(is.na(.),0) %>%
  gt() %>%
  cols_align(
    align = "center",
    columns = c(arrow, combo_img, totalPlayerPoints:rk2)
  ) %>%
  cols_align(
    align = "left",
    columns = c(username)
  ) %>%
  gt_merge_stack(col1 = nameTeam, col2 = username, font_size = c("18px", "14px")) %>%
  cols_label(
    arrow = "",
    combo_img = "",
    nameTeam = gt::html("<span style='font-weight:bold;font-size:20px'>team</span>"),
    rk1 = gt::html("<span style='font-weight:bold;font-size:20px'>RK</span>"),
    totalPlayerPoints = gt::html("<span style='font-weight:bold;font-size:20px'>Pts Jor.</span>"),
    rk2 = gt::html("<span style='font-weight:bold;font-size:20px'>rk</span>"),
    pointsgeneral = gt::html("<span style='font-weight:bold;font-size:20px'>Pts Gene.</span>")
    # rk3 = gt::html("<span style='font-weight:bold;font-size:15px'>RK</span>"),
    # jornadaPlayerPoints = gt::html("<span style='font-weight:bold;font-size:15px'>PTSJ</span>"),
    # ipt3 = gt::html("<span style='font-weight:bold;font-size:12px'>INT.</span>"),
    # pt3 = gt::html("<span style='font-weight:bold;font-size:12px'>PCT%</span>")
  ) %>%
  gt_color_rows(rk1, palette = c("white", "#ffa031"), direction = -1) %>%
  gt_color_rows(rk2, palette = c("white", "#ffa031"), direction = -1) %>%
  # data_color(rk3, palette = c("white", "#ffa031")) %>%
  cols_width(
    c(combo_img) ~ px(56)
  ) %>%
  cols_width(
    c(rk1) ~ px(100)
  ) %>%
  cols_width(
    c(rk2) ~ px(140)
  ) %>%
  cols_width(
    c(nameTeam) ~ px(250)
  ) %>%
  cols_width(
    c(arrow) ~ px(160)
  ) %>%
  # fmt_currency(columns = c(brokerValor),sep_mark = ".",
  #                  currency = "EUR",
  #                  use_subunits = FALSE,
  #                  placement = "right",
  #
  # )  %>%
  text_transform(
    locations = cells_body(columns = c(arrow)),
    fn = function(x) {
      rank_chg <- as.integer(x)
      
      choose_logo <- function(x) {
        if (x == 0) {
          gt::html(fontawesome::fa("equals", fill = "grey"))
        } else if (x > 0) {
          gt::html(glue::glue("<span style='color:#69b42e;font-face:bold;font-size:24px;'>{x}</span>"), fontawesome::fa("arrow-up", fill = "#69b42e"))
        } else if (x < 0) {
          gt::html(glue::glue("<span style='color:#a12513;font-face:bold;font-size:24px;'>{x}</span>"), fontawesome::fa("arrow-down", fill = "#a12513"))
        }
      }
      
      map(rank_chg, choose_logo)
    }
  ) %>%
  gtExtras::gt_theme_espn() |>
  tab_options(
    heading.align = "left",
    table.font.names = "Oswald",
    table.background.color = "white",
    table.font.size = 22,
    data_row.padding = px(1),
    source_notes.font.size = 15,
    table.additional_css = "
  @import url('https://fonts.googleapis.com/css2?family=Oswald:wght@400;600;700&display=swap');
  @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css');
  .gt_table, .gt_table * { font-family: 'Oswald', sans-serif !important; }
  .gt_table { margin-bottom: 40px; }
"
  ) |>
  tab_header(
    title = md(glue::glue("<div style='line-height:134px;vertical-align:middle;text-align:left;font-weight:600;font-size:104px'>
                 <img src='https://raw.githubusercontent.com/IvoVillanueva/acb_logo/main/Logo%20SM%20mosca%20340x340.png'style='width:100px; height:100px;vertical-align:middle;padding-right:12px'
               <span style='text-align:left;'>Clasificación Jornada {jornada}</div>")),
    subtitle = md(glue::glue("<span style='font-weight:400;color:#8C8C8C;font-size:20px'>Managers Lideres TOP20 en Valoración en la J{jornada} y su Posición en la General</span>"))
  ) %>%
  tab_source_note(
    source_note = md(paste0("**Datos**: *@SuperManagerACB*&nbsp;&nbsp; <img src='https://raw.githubusercontent.com/IvoVillanueva/acb_logo/main/Logo%20SM%20mosca%20340x340.png'
                     style='height:25px;width:25px;vertical-align:middle;'>", caption))
  ) %>%
  #gtsave(paste0("data/jornada_con_general_", gsub("-", "_", fecha), "_jor_", jornada, ".png"), vwidth = 3000, vheight = 1500, expand = 200)
