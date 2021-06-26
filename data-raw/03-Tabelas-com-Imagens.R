

# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`
source("./R/01-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens.R")
source("./R/02-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens-col-erro.R")

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


# Um problema que encontrei foi o fato de algumas tabelas terem 6 colunas
# e a quarta ser vazia, então para essas tive que estruturar uma fórmula diferente
# Então a princípio a faxina é feita nas tabelas com 5 e 6 colunas que possuam
# dados e mesmo padrão. Após isso, é feita a extração apenas para as tabelas
# que possuem uma coluna vazia.


# Extrair e juntar todas as tabelas com 5 e 6 colunas que tenham dados
nucleos_regionais_com_dados <- c(
  "Campo Mourão",
  "Cianorte - a",
  "Cianorte - b",
  "Umuarama",
  "Apucarana",
  "Cornélio Procópio",
  "Ivaiporã - a",
  "Londrina - a",
  "Londrina - b",
  "Cascavel",
  "Dois Vizinhos",
  "Toledo"
)
  

tabelas_tidy_pag_com_imgs_a <-
  purrr::map_dfr(.x = nucleos_regionais_com_dados,
                 ~ faxinar_tabela_ng_pag_com_img(tabelas_pag_com_imgs, .x))

# outra notação
# purrr::map_dfr(.x = nucleos_regionais_com_dados, 
#                .f = faxinar_tabela_ng_pag_com_img,
#                tabela_bruta_extraida = tabelas_pag_com_imgs)

print(tabelas_tidy_pag_com_imgs_a)

# verificar tabelas
tabelas_tidy_pag_com_imgs_a %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 200)


# Extrair e juntar todas as tabelas que contenham uma coluna vazia
nucleos_regionais_com_col_vazia <- c(
  "Curitiba",
  "Guarapuava",
  "Irati",
  "Laranjeiras do Sul - a",
  "Laranjeiras do Sul - b",
  "Ponta Grossa - a",
  "Ponta Grossa - b",
  # "Paranaguá",  dá problema, terá que ser extraído individualmente
  "Francisco Beltrão"
)

tabelas_tidy_pag_com_imgs_b <-
  purrr::map_dfr(.x = nucleos_regionais_com_col_vazia,
                 ~ faxinar_tabela_ng_pag_com_img_col_erro(tabelas_pag_com_imgs, .x))


# verificar  tabelas
tabelas_tidy_pag_com_imgs_b %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 200)



# empilhar as duas bases
tabelas_tidy_pag_com_imgs <-
  tabelas_tidy_pag_com_imgs_a %>% 
  dplyr::bind_rows(tabelas_tidy_pag_com_imgs_b)




# Faxinar paranaguá -------------------------------------------------------

loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")
nome_nucleo_regional <- "Paranaguá"

# municípios que estão dando erro no pinus
pinus_paranagua <- c(
  "Antonina",
  "Matinhos"
)

# municípios que tem eucalipto
eucalipto_paranagua <- c(
  "Guaratuba",
  "Morretes",
  "Paranaguá",
  "Pontal do Paraná"
)

# ajustar paranaguá
tab_paranagua_tidy <- 
  tabelas_pag_com_imgs %>%
  faxinar_tabela_ng_pag_com_img_col_erro(nome_nucleo_regional) %>%
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>%
  
  # retirar NA da coluna de municipio
  dplyr::filter(!is.na(municipio)) %>% 
  
  # ajustar coluna de euc e de pin
  dplyr::mutate(
    
    # colocar os números faltantes que estão na coluna de euc
    pinus = dplyr::case_when(municipio %in% pinus_paranagua ~ eucalipto,
                             TRUE ~ pinus),
    
    # converter coluna de euc para character
    eucalipto = as.character(eucalipto),
    
    # deletar números de pinus que estão dentro de euc
    eucalipto = dplyr::case_when(!municipio %in% eucalipto_paranagua ~ NA_character_,
                                 TRUE ~ eucalipto),
    
    # converter novamente coluna de euc para double
    eucalipto = readr::parse_number(eucalipto, 
                                    locale = readr::locale(decimal_mark = ".",
                                                           grouping_mark = ","))
    
  ) %>% 
  
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")

  
# Conferindo totais
tab_paranagua_tidy %>% 
  dplyr::group_by(tipo_genero) %>% 
  dplyr::summarise(total = sum(area_ha, na.rm = TRUE))


# Empilhar paranaguá na base principal
tabelas_tidy_pag_com_imgs <-
  tabelas_tidy_pag_com_imgs %>% 
  dplyr::bind_rows(tab_paranagua_tidy)



# Consertar problemas em  Cianorte --------------------------------------

# tem problemas em CIANORTE
tibble::view(tabelas_tidy_pag_com_imgs)


# verificar tabela individualmente - Cianorte
tabelas_pag_com_imgs[["Cianorte - a"]]
tabelas_tidy_pag_com_imgs %>% 
  dplyr::filter(nucleo_regional == "Cianorte - a") %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 100)

# em Cianorte ele pegou o número da página e colocou como parte da tabela, basta
# excluir a linha com número "50" da coluna município

# ajustando erros
tabelas_tidy_pag_com_imgs_ajust <- 
  tabelas_tidy_pag_com_imgs %>% 
  dplyr::filter(municipio != 50)

tibble::view(tabelas_tidy_pag_com_imgs_ajust)


# Organizar base ----------------------------------------------------------


# Arrumar nomes de tabelas "a" e "b"
tabs_tidy_pag_com_imgs_ajust_final <-
  tabelas_tidy_pag_com_imgs_ajust %>% 
  dplyr::mutate(tabela_fonte = stringr::str_remove_all(tabela_fonte, " - a"),
                tabela_fonte = stringr::str_remove_all(tabela_fonte, " - b"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - a"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - b")
  )


# Visualizar colunas ajustadas
tabs_tidy_pag_com_imgs_ajust_final %>% 
  dplyr::distinct(tabela_fonte, nucleo_regional)


# Salvar tabela -----------------------------------------------------------
saveRDS(tabs_tidy_pag_com_imgs_ajust_final,"./data/tbs_pag_com_imagens.rds")
