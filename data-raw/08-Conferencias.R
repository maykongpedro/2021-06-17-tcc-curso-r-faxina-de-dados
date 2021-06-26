

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
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
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

# criar lista das tabelas
list_tabelas_tidy <- list(
  tb_ivaipora_b,
  tb_sem_imagens,
  tb_sem_imagens_mal_ident,
  tb_francisco_beltrao_b
)

# empilhando tudo
tab_mapeamento_tidy <-
  tbs_com_imagens %>% 
  
  # empilhar
  dplyr::bind_rows(list_tabelas_tidy) %>% 
  
  # limpar letras adicionais nos nomes dos núcleos
  dplyr::mutate(tabela_fonte = stringr::str_remove_all(tabela_fonte, " - a"),
                tabela_fonte = stringr::str_remove_all(tabela_fonte, " - b"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - a"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - b")
  ) %>% 
  
  # organizar por ordem alfábetica
  dplyr::arrange(nucleo_regional)

  
tab_mapeamento_tidy


# Conferência final -------------------------------------------------------

# área por nucleo considerando a tabela resumo
area_por_nucleo <-
  tb_area_total %>% 
  dplyr::group_by(nucleo_regional) %>% 
  dplyr::summarise(area = sum(area_ha)) 

# área por núcleo considerando a tabela completa
area_por_nucleo_tab_completa <-
  tab_mapeamento_tidy %>% 
  dplyr::group_by(nucleo_regional) %>% 
  dplyr::summarise(total = sum(area_ha, na.rm = TRUE)) 

# verificar diferenças
area_por_nucleo %>%
  dplyr::left_join(area_por_nucleo_tab_completa) %>% 
  dplyr::mutate(dif = total - area) %>% 
  print(n = 50)

# apenas questões de arrendondamento, show!

# Salvar tabela -----------------------------------------------------------
saveRDS(tab_mapeamento_tidy,"./data/mapeamento_SFB-IFPR_completo.rds")

