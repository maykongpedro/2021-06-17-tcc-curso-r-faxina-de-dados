

######### Script para conferências gerais ##########

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Tabela 1 - Área total ---------------------------------------------------

# carregar arquivo
tb_area_total <- readr::read_rds("./data/tb_area_total.rds")


# comparar manualmente com a página 30 do pdf
# visualizar sub-totais por região
tb_area_total %>% 
  dplyr::group_by(regiao) %>% 
  dplyr::summarise(area = sum(area_ha)) 


# Tabela 2 em diante - Com imagens ----------------------------------------

# carregar arquivo
tbs_com_imagens <- readr::read_rds("./data/tbs_pag_com_imagens.rds")

# comparar manualmente com as respectivas páginas do arquivo:
# IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas

# definir os núcleos
nucleos_regionais_tab_imgs <- c("Campo Mourão",
                                "Curitiba",
                                "Guarapuava",
                                "Irati",
                                "Laranjeiras do Sul - a",
                                "Laranjeiras do Sul - b",
                                "Ponta Grossa - a",
                                "Ponta Grossa - b",
                                "Paranaguá",
                                "Cianorte - a",
                                "Cianorte - b",
                                "Umuarama",
                                "Apucarana",
                                "Cornélio Procópio",
                                "Ivaiporã - a",
                                #"Ivaiporã - b",
                                "Londrina - a",
                                "Londrina - b",
                                "Cascavel",
                                "Dois Vizinhos",
                                "Francisco Beltrão",
                                "Toledo"
)

# testar alguns
tbs_com_imagens %>% 
  dplyr::filter(nucleo_regional == nucleos_regionais_tab_imgs[[1]]) %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 50)


tbs_com_imagens %>% 
  dplyr::filter(nucleo_regional == nucleos_regionais_tab_imgs[[2]]) %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 50)

