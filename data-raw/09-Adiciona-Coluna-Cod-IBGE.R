

# Instalar e carregar pacotes ---------------------------------------------

# if(!require("pacman")) install.packages("pacman")
#pacman::p_load(geobr, crul, sf, ggspatial, ggtext, ggiraphExtra)

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Carregar bases ----------------------------------------------------------

# Carregar base do mapeamento
base <- readr::read_rds("./data/mapeamento_SFB-IFPR_completo.rds") 
  

# lendo municípios de SP
muni <- geobr::read_municipality(code_muni= "PR", year=2010)



# Transformar e juntar bases ----------------------------------------------

# transformar coluna de municípios
base_alterada <-
  base %>% 
  dplyr::mutate(municipio = stringr::str_to_lower(municipio))


# fazendo primeiro join
base_geo <-
  muni %>% 
  dplyr::mutate(municipio = stringr::str_to_lower(name_muni)) %>% 
  dplyr::left_join(base_alterada, by = "municipio") 
  #dplyr::filter(is.na(tipo_genero))


# fazendo join considerando os municípios não encontrados
"Altônia" = "Altonia"
"Flor Da Serra Do Sul" = "Flor da Serra Azul",
"Guaraqueçaba" = "Guaraqueçaba" -> nao tem mesmo
"Itapejara D'oeste" = "Itapejara D' Oeste"
"Joaquim Távola" = "Joaquim Távola"
"Pérola D'oeste" = "Pérola D' Oeste"
"Quitandinha" = "Quitandinhas"
"Santa Lúcia" = "Santa Lucia"
"Santa Tereza Do Oeste" = "Santa Terezinha do Oeste"
"Santa Terezinha De Itaipu" =  "Santa Terezinha do Itaipu"



# Visualizar o mapa -------------------------------------------------------
base_geo %>% 
  dplyr::filter(!is.na(tipo_genero),
                tipo_genero != "corte") %>% 
  ggplot2::ggplot() +
  ggplot2::geom_sf(alpha = .9,
                   color = "white",
                   size = 0.5) +
  ggplot2::geom_sf(ggplot2::aes(fill = area_ha)) +
  ggplot2::scale_fill_viridis_c(direction = -1, option = "magma") +
  ggplot2::facet_wrap(~tipo_genero) +
  ggplot2::labs(fill = "legenda",
                subtitle = "subtitulo",
                caption = "**Dataviz:** @maykongpedro | **Fonte:** AAA") +
  ggplot2::ggtitle("titulo") +
  ggspatial::annotation_north_arrow(
    location = "br",
    which_north = "true",
    height = ggplot2::unit(1, "cm"),
    width = ggplot2::unit(1, "cm"),
    pad_x = ggplot2::unit(0.1, "in"),
    pad_y = ggplot2::unit(0.1, "in"),
    style = ggspatial::north_arrow_fancy_orienteering
  ) +
  ggspatial::annotation_scale() +
  #ggplot2::theme_bw() +
  ggiraphExtra::theme_clean2() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold"),
    plot.subtitle = ggtext::element_markdown(),
    plot.caption = ggtext::element_markdown(hjust = 1),
    panel.grid = ggplot2::element_blank()
  )
  

