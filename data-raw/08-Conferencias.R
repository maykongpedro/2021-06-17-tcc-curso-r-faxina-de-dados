

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
  dplyr::filter(nucleo_regional == nucleos_regionais_tab_imgs[[4]]) %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 50) 

tbs_com_imagens %>% 
  dplyr::filter(tipo_genero == "pinus") %>% 
  tibble::view()



# Tabela Ivaiporã b - Com imagem ------------------------------------------

# carregar arquivo
tb_ivaipora_b <- readr::read_rds("./data/tb_ivaipora_b.rds")

# comparar manualmente com a página 16 do pdf:
# IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas

tb_ivaipora_b %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha")


# Tabelas sem imagens -----------------------------------------------------
tb_sem_imagens <- readr::read_rds("./data/tbs_tidy_pag_sem_imagens.rds")


# conferindo Maringá pela soma pois é a única tabela completa dentro dessa base
tb_sem_imagens %>% 
  dplyr::filter(nucleo_regional == "Maringá") %>% 
  dplyr::group_by(nucleo_regional) %>% 
  dplyr::summarise(total = sum(area_ha, na.rm = TRUE))

# conferindo as outras manualmente
tb_sem_imagens %>% 
  dplyr::filter(nucleo_regional != "Maringá") %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  tibble::view()


# Tabelas sem imagens mal identiicadas ------------------------------------

tb_sem_imagens_mal_ident <- readr::read_rds("./data/tbs_tidy_pag_sem_imagens_mal_ident.rds")


# conferir com a soma de cada tabela pois elas estão completas
tb_sem_imagens_mal_ident %>% 
  dplyr::group_by(nucleo_regional) %>% 
  dplyr::summarise(total = sum(area_ha, na.rm = TRUE))



# Tabela Francisco Beltrão b - Sem imagem ---------------------------------

tb_francisco_beltrao_b <- readr::read_rds("./data/tb_tidy_francisco_beltrao.rds")

# conferindo  manualmente
tb_francisco_beltrao_b %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  tibble::view()



# Empilhar todas as bases -------------------------------------------------







