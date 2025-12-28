
source("scripts/helpers.R")

# asegurar que la carpeta data existe
if (!dir.exists("png")) dir.create("png")

# extraer datos broker general
general <- fromJSON(txt = content(
  GET(
    url = Sys.getenv("URL_GENERAL_NAVIDAD"),
    add_headers(.headers = headers)
  ),
  "text",
  encoding = "UTF-8"
)) %>%
  tibble() %>%
  unnest(cols = c(all)) %>%
  select(-user) %>%
  mutate(userAvatar = paste0(Sys.getenv("URL_PNG"), userAvatar))

# tabla gt broker
general %>%
  mutate(
    combo_img = add_photo_frame(userAvatar),
    combo_img = map(combo_img, gt::html),
    rk1 = row_number(),
    rk2 = rank(brokerValor),
    nameTeam = toupper(nameTeam)
  ) %>%
  head(20) %>%
  select(arrow, combo_img, username, nameTeam, totalPlayerPoints,
    rk1 = position, brokerValor, rk2 = brokerPosition
  ) %>%
  gt() %>%
  cols_align(
    align = "center",
    columns = c(combo_img, totalPlayerPoints:rk2)
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
    totalPlayerPoints = gt::html("<span style='font-weight:bold;font-size:20px'>Pts General</span>"),
    rk2 = gt::html("<span style='font-weight:bold;font-size:20px'>rk</span>"),
    brokerValor = gt::html("<span style='font-weight:bold;font-size:20px'>Broker</span>")
  ) %>%
  gt_color_rows(rk1, palette = c("white", "#ffa031"), direction = -1) %>%
  gt_color_rows(rk2, palette = c("white", "#ffa031"), direction = -1) %>%
  cols_width(
    c(combo_img) ~ px(56)
  ) %>%
  cols_width(
    c(rk1, totalPlayerPoints, rk2) ~ px(66)
  ) %>%
  cols_width(
    c(nameTeam) ~ px(350)
  ) %>%
  fmt_currency(
    columns = c(brokerValor), sep_mark = ".",
    currency = "EUR",
    use_subunits = FALSE,
    placement = "right",
  ) %>%
  text_transform(
    locations = cells_body(columns = c(arrow)),
    fn = function(x) {
      rank_chg <- as.integer(x)

      choose_logo <- function(x) {
        if (x == 0) {
          gt::html(fontawesome::fa("equals", fill = "grey"))
        } else if (x > 0) {
          gt::html(
            glue::glue("<span style='color:#69b42e;font-face:bold;font-size:24px;'>{x}</span>"),
            fontawesome::fa("arrow-up", fill = "#69b42e")
          )
        } else if (x < 0) {
          gt::html(
            glue::glue("<span style='color:#a12513;font-face:bold;font-size:24px;'>{x}</span>"),
            fontawesome::fa("arrow-down", fill = "#a12513")
          )
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
    title = md("<div style='line-height:134px;vertical-align:middle;text-align:left;font-weight:600;font-size:64px'>
                 <img src='https://raw.githubusercontent.com/IvoVillanueva/SUPERMANAGER-BROKER-GENERAL/refs/heads/main/png/LogoSMNavidadAzulmarino.png'style='width:114px; height:114px;vertical-align:middle;padding-right:12px'
               <span style='text-align:left;'>Clasificación NAVIDAD</div>"),
    subtitle = md(glue("<span style='font-weight:400;color:#8C8C8C;fon t-size:20px'>Lideres En la General TOP20 en el SUPERMANAGER DE NAVIDAD 25/26 hasta la jornada {jornada_navidad}</span>"))
  ) %>%
  tab_source_note(
    source_note = md(paste0("**Datos**: *@SuperManagerACB*&nbsp;&nbsp; <img src='https://raw.githubusercontent.com/IvoVillanueva/acb_logo/main/Logo%20SM%20mosca%20340x340.png'
                     style='height:25px;width:25px;vertical-align:middle;'>", caption))
  ) %>%
  gtsave(paste0("png/General_jor_navidad_", jornada_navidad, "_.png"), vwidth = 3000, vheight = 1500, expand = 200)
