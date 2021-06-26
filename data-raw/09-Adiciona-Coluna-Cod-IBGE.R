

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
#saveRDS(base_mapeamento_com_cod_ibge, "./data/mapeamento_SFB-IFPR_completo_cod_IBGE.rds")



# Visualizar o mapa -------------------------------------------------------


quebras <- c(0, 1000, 5000, 10000, 20000, 30000, 40000, 50000)
ordem <- c("0-1000", "1000-5000", "5000-10000", "10000-20000", "20000-30000", "30000-40000", "40000-50000")

base_geo_ajust %>% 
  dplyr::filter(!is.na(tipo_genero),
                tipo_genero != "corte"
                ) %>% 
  dplyr::mutate(
    
    tipo_genero = dplyr::case_when(tipo_genero == "pinus" ~ "Pinus",
                                   tipo_genero == "eucalipto" ~ "Eucalipto",
                                   TRUE ~ tipo_genero),
    
    area_ha = cut(area_ha,
                  quebras,
                  dig.lab = 5),
    
    area_ha = stringr::str_remove_all(area_ha, "\\(|\\]"),
    
    area_ha = stringr::str_replace_all(area_ha,  ",", "-"),
    
    area_ha = factor(area_ha,
                     levels = ordem,
                     ordered = TRUE)
    
    ) %>% 
  
  ggplot2::ggplot() +
  ggplot2::geom_sf(alpha = .5,
                   color = "white",
                   size = 0.2) +
  ggplot2::geom_sf(ggplot2::aes(fill = area_ha)) +
  
  ggplot2::scale_fill_viridis_d(
    direction = -1,
    option = "magma",
    guide = ggplot2::guide_legend(
      keyheight = ggplot2::unit(3, units = "mm"),
      keywidth = ggplot2::unit(12, units = "mm"),
      label.position = "top",
      title.position = 'top',
      title.theme = ggplot2::element_text(size = 10),
      nrow = 1
    )
  ) +
  
  ggplot2::facet_wrap(~tipo_genero) +
  ggplot2::labs(fill = "Legenda: Classe de área (ha)",
                subtitle = "Mapeamento de florestas plantadas do Serviço Florestal Brasileiro (SFB) \nem conjunto com o Instituto de Florestas do Paraná (IFPR)",
                caption = "**Dataviz:** @maykongpedro | **Fonte:** Mapeamento SFB-IFPR no Paraná (Dados organizados pelo autor)") +
  ggplot2::ggtitle("Distribuição espacial de florestas plantadas no Paraná") +
  
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
  ggiraphExtra::theme_clean2() +
  ggplot2::theme(
    strip.background.x = ggplot2::element_rect(
      color="black"
    ),
    plot.title = ggplot2::element_text(face = "bold",
                                       vjust = 13),
    plot.subtitle = ggplot2::element_text(vjust = 17),
    plot.caption = ggtext::element_markdown(),
    legend.position = c(0.28, 1.22), #horizontal, vertical
    plot.margin = ggplot2::unit(c(1.5,1,0,1), "cm"),
    panel.grid = ggplot2::element_blank()
  )


# Salvando gráfico
ggplot2::ggsave(
  filename = "./inst/plot_mapa.png",
  dpi = 300
)

