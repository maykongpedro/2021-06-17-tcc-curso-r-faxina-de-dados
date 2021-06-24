

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


# Extração genérica
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


# Arrumar nomes de tabelas "a" e "b"
tabelas_tidy_pag_com_imgs <-
  tabelas_tidy_pag_com_imgs %>% 
  dplyr::mutate(tabela_fonte = stringr::str_remove_all(tabela_fonte, " - a"),
                tabela_fonte = stringr::str_remove_all(tabela_fonte, " - b"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - a"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - b")
  )

