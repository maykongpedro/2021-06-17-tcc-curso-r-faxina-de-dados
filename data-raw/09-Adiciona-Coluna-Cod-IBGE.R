

# Instalar e carregar pacotes ---------------------------------------------

# if(!require("pacman")) install.packages("pacman")
#pacman::p_load(geobr, crul, sf, ggspatial, ggtext, ggiraphExtra)

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Carregar bases ----------------------------------------------------------

# Carregar base do mapeamento
base_mapeamento <- readr::read_rds("./data/mapeamento_SFB-IFPR_completo.rds") 
  

# lendo municípios do PR
base_muni_pr <- geobr::read_municipality(code_muni= "PR", year=2010)



# Transformar e juntar bases ----------------------------------------------

# transformar coluna de municípios
base_alterada <-
  base_mapeamento %>% 
  dplyr::mutate(name_muni = stringr::str_to_lower(municipio))


# fazendo primeiro join
base_geo <-
  base_muni_pr %>% 
  dplyr::mutate(municipio = stringr::str_to_lower(name_muni)) %>% 
  dplyr::left_join(base_alterada, by = "municipio") 


# identificando itens faltantas
base_geo %>% 
  dplyr::filter(is.na(tipo_genero))



# fazendo segundo join considerando municípios não encontrados
base_geo_ajust <-
  base_muni_pr %>% 
  dplyr::mutate(
    name_muni = dplyr::case_when(name_muni == "Altônia" ~ "Altonia",
                                 name_muni == "Flor Da Serra Do Sul" ~ "Flor da Serra Azul",
                                 name_muni == "Itapejara D'oeste" ~ "Itapejara D' Oeste",
                                 name_muni == "Joaquim Távora" ~ "Joaquim Távola",
                                 name_muni == "Pérola D'oeste" ~ "Pérola D' Oeste",                                
                                 name_muni == "Quitandinha" ~ "Quitandinhas",
                                 name_muni == "Santa Lúcia" ~ "Santa Lucia",
                                 name_muni == "Santa Tereza Do Oeste" ~ "Santa Terezinha do Oeste",
                                 name_muni == "Santa Terezinha De Itaipu" ~ "Santa Terezinha do Itaipu",
                                 name_muni == "Santo Antônio Do Paraíso" ~ "Santo Antônio do Paraiso",
                                 name_muni == "São José Dos Pinhais" ~ "São José dos Pinhas",
                                 TRUE ~ name_muni),
    
    name_muni = stringr::str_to_lower(name_muni)
  ) %>% 
  dplyr::left_join(base_alterada, by = "name_muni") 

  
# verificando itens não encontrados
base_geo_ajust %>% 
  dplyr::filter(is.na(tipo_genero))

# o único que não foi encontrado é Guaraqueçaba, que reealmente não existe mapeamento
# na base para esse município


# adicionar na base de mapeamento o código do IBGE
base_mapeamento

base_mapeamento_com_cod_ibge <-
  base_mapeamento %>% 
  dplyr::mutate(
    name_muni = stringr::str_to_lower(municipio)
  ) %>% 
  dplyr::left_join(base_geo_ajust) %>% 
  dplyr::select(-name_muni, -code_state, -abbrev_state, -geom) %>% 
  dplyr::relocate(code_muni, .after = "municipio")
  
# verificando itens não encontrados
base_mapeamento_com_cod_ibge %>% 
  dplyr::filter(is.na(code_muni))


# Salvar base com o código ibge -------------------------------------------
saveRDS(base_mapeamento_com_cod_ibge, "./data/mapeamento_SFB-IFPR_completo_cod_IBGE.rds")



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
  

