

# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`
source("./R/01-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens.R")


# Tabela 2 em diante - Páginas com imagens --------------------------------

# obter caminho
paginas_processadas <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas.pdf"

# definir nomes dos núcleos regionais
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

# extrair tabelas
tabelas_pag_com_imgs <-
  tabulizer::extract_tables(paginas_processadas,
                            method = "stream")

# Nomear listas
names(tabelas_pag_com_imgs) <- nucleos_regionais_tab_imgs

# Printar no console
print(tabelas_pag_com_imgs)




# Faxinar e empilhar tabelas ----------------------------------------------

# Faxina genérica
faxinar_tabela_ng_pag_com_img(tabelas_pag_com_imgs, 
                              nucleos_regionais_tab_imgs[9]) 


# Extrair e juntar todas as tabelas
tabelas_tidy_pag_com_imgs <-
  purrr::map_dfr(.x = nucleos_regionais_tab_imgs,
                 ~ faxinar_tabela_ng_pag_com_img(tabelas_pag_com_imgs, .x))

# outra notação
# purrr::map_dfr(.x = nucleos_regionais_tab_imgs, 
#                .f = faxinar_tabela_ng_pag_com_img,
#                tabela_bruta_extraida = tabelas_pag_com_imgs)
print(tabelas_tidy_pag_com_imgs)



# Consertar problemas em dois núcleos -------------------------------------

# tem problemas em CIANORTE A e PARANAGUA
tibble::view(tabelas_tidy_pag_com_imgs)


# verificar tabela individualmente - Cianorte
tabelas_pag_com_imgs[["Cianorte - a"]]
tabelas_tidy_pag_com_imgs %>% 
  dplyr::filter(nucleo_regional == "Cianorte - a") %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  tibble::view()

# em Cianorte ele pegou o número da página e colocou como parte da tabela, basta
# excluir as linhas com número "50" da coluna município


# verificar tabela individualmente - Paranaguá
tabelas_pag_com_imgs[["Paranaguá"]]

tabelas_tidy_pag_com_imgs %>% 
  dplyr::filter(nucleo_regional == "Paranaguá") %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  tibble::view()

# nesse caso tinha uma coluna adicional antes de total, isso impactou na geração
# dos valores, então tenho que deletar ela da base principal e fazer a faxina
# separadamente. Depois disso, empilho ela junto com as outras.

tabelas_tidy_pag_com_imgs_ajust <- 
  tabelas_tidy_pag_com_imgs %>% 
  dplyr::filter(municipio != 50,
                nucleo_regional != "Paranaguá")




# Faxinar apenas Paranaguá ------------------------------------------------

#tabelas_pag_com_imgs[["Paranaguá"]]
nome_nucleo_regional <- "Paranaguá"
loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

tb_paranagua_tidy <-
  tabelas_pag_com_imgs %>% 
  purrr::pluck(nome_nucleo_regional) %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto_pinus", "erro", "total", "percentual")) %>%
  dplyr::slice(-c(1:3)) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>%
  dplyr::select(-erro, -total, -percentual) %>%
  dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                      nome_nucleo_regional),
                nucleo_regional = nome_nucleo_regional) %>%
  dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) %>%
  tidyr::separate(col = eucalipto_pinus,
                  sep = " ",
                  into = c("eucalipto", "pinus")) %>% 
  dplyr::mutate(dplyr::across(.cols = corte:pinus,
                              readr::parse_number, locale = loc)) %>%
  dplyr::filter(municipio != "%",
                !is.na(municipio)) %>% 
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")


# Organizar base ----------------------------------------------------------

# empilhar paranaguá
tabs_tidy_pag_com_imgs_ajust_final <-
  tabelas_tidy_pag_com_imgs_ajust %>% 
  dplyr::bind_rows(tb_paranagua_tidy)


# Arrumar nomes de tabelas "a" e "b"
tabs_tidy_pag_com_imgs_ajust_final <-
  tabs_tidy_pag_com_imgs_ajust_final %>% 
  dplyr::mutate(tabela_fonte = stringr::str_remove_all(tabela_fonte, " - a"),
                tabela_fonte = stringr::str_remove_all(tabela_fonte, " - b"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - a"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - b")
  )


# Visualizar
tibble::view(tabs_tidy_pag_com_imgs_ajust_final)


# Salvar tabela -----------------------------------------------------------
saveRDS(tabs_tidy_pag_com_imgs_ajust_final,"./data/tbs_pag_com_imagens.rds")
