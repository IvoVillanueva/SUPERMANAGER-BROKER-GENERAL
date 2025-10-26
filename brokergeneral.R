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
caption <- glue("**Gráfico**: *Ivo Villanueva* • {twitter} {tweetelcheff}&nbsp;&nbsp;para&nbsp;&nbsp;{twitter} *@SuperManagerACB*")


# asegurar que la carpeta data existe
if (!dir.exists("data")) dir.create("data")


# fecha de hoy
fecha <- paste0(Sys.Date(), "_semana_", week(today()))

# cabeceras
headers <- c(
  "Authorization" = Sys.getenv("SM_TOKEN"),
  "Accept" = "application/json"
)

# numero de jornada
jornada <- fromJSON(txt = content(GET(url = "https://supermanager.acb.com/api/basic/competition", add_headers(.headers = headers)),
  "text",
  encoding = "UTF-8"
))$journeyActual$number

#extraer datos broker general
brokerGeneral <- fromJSON(txt = content(
  GET(
    url = "https://supermanager.acb.com/api/basic/userteam/standing/1?_page=1&category=2&type=1&community=false",
    add_headers(.headers = headers)
  ),
  "text",
  encoding = "UTF-8"
)) %>%
  tibble() %>%
  unnest(cols = c(all)) %>%
  select(-user) %>%
  mutate(userAvatar = paste0("https://supermanager.acb.com/files/", userAvatar))


#funciones
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



#tabla gt
brokerGeneral %>%
  mutate(
    combo_img = add_photo_frame(userAvatar),
    combo_img = map(combo_img, gt::html),
    rk1 = row_number(),
    rk2 = rank(brokerValor),
    nameTeam = toupper(nameTeam)
  ) %>%
  head(20) %>%
  select(arrow, combo_img, username, nameTeam, totalPlayerPoints, rk1 = position, brokerValor, rk2 = brokerPosition) %>%
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
  # data_color(rk3, palette = c("white", "#ffa031")) %>%
   cols_width(
    c(combo_img) ~ px(56)
  ) %>%
  cols_width(
    c(rk1,totalPlayerPoints,rk2) ~ px(66)
  ) %>%
  cols_width(
    c(nameTeam) ~ px(250)
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
    title = md("<div style='line-height:134px;vertical-align:middle;text-align:left;font-weight:600;font-size:64px'>
                 <img src='https://raw.githubusercontent.com/IvoVillanueva/acb_logo/main/Logo%20SM%20mosca%20340x340.png'style='width:114px; height:114px;vertical-align:middle;padding-right:12px'
               <span style='text-align:left;'>Clasificación Broker</div>"),
    subtitle = md(glue("<span style='font-weight:400;color:#8C8C8C;fon t-size:20px'>Lideres En BrokerBasket TOP20 en el SuperManager 25/26 hasta la jornada {jornada}</span>"))
  ) %>%
    
    tab_source_note(
      source_note = md(paste0("**Datos**: *@SuperManagerACB*&nbsp;&nbsp; <img src='https://raw.githubusercontent.com/IvoVillanueva/acb_logo/main/Logo%20SM%20mosca%20340x340.png'
                     style='height:25px;width:25px;vertical-align:middle;'>", caption)
                       
      ) )%>%
  gtsave(paste0("data/brokerGeneral_", gsub("-", "_", fecha), "_jor_", jornada, ".png"), vwidth = 3000, vheight = 1500, expand = 60)
