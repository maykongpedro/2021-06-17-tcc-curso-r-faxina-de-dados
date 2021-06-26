
# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`
source("./R/04-fn-faxinar-tabela-nucleo-regional-paginas-sem-imagens-tab-mal-identif.R")


# Tabela 2 em diante - Páginas sem imagens com tabelas zoadas ------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

# Páginas que a tabela ficou mal identificada na extração
paginas_tabelas_semi_ident <- c(47, 50, 54, 62)
nucleos_regionais_tab_semi_ident <- c("Pato Branco",
                                      "União da Vitória",
                                      "Paranavaí",
                                      "Jacarezinho")

# Extrair tabelas ---------------------------------------------------------

# extrair tabelas
tabelas_pag_sem_imgs_tab_semi_ident <-
  tabulizer::extract_tables(url_mapeamento,
                            pages = paginas_tabelas_semi_ident)

# Renomear listas
names(tabelas_pag_sem_imgs_tab_semi_ident) <- nucleos_regionais_tab_semi_ident




# Faxinar tabelas ---------------------------------------------------------


# Printar no console
print(tabelas_pag_sem_imgs_tab_semi_ident)

# Pato Branco - o único que precisa tirar 6 linhas, pode ser extraído com uma fórmula
# União da Vitória - precisa retirar somente 5 linhas do começo e filtrar TOTAL - usar fórmula
# Paranavaí -  mais complicado, ta duplicando o total na coluna do pinus - extrair individualmente
# Jacarezinho mesmo problema de cima - extrair individualmente


# Pato Branco -------------------------------------------------------------

nucleo_regional <- nucleos_regionais_tab_semi_ident[1]
tab_pato_branco_tidy <-
  tabelas_pag_sem_imgs_tab_semi_ident %>% 
  purrr::pluck(nome_nucleo_regional) %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("all", "percentual")) %>%
  dplyr::slice(-c(1:6)) %>%
  faxinar_tabela_ng_mal_identif(nome_nucleo_regional)
  
  
# Conferindo totais
tab_pato_branco_tidy %>% 
  dplyr::group_by(tipo_genero) %>% 
  dplyr::summarise(sum(area_ha, na.rm = TRUE))


# União da Vitória --------------------------------------------------------

nucleo_regional <- nucleos_regionais_tab_semi_ident[2]

tab_uniao_da_vitoria_tidy <-
  tabelas_pag_sem_imgs_tab_semi_ident %>% 
  purrr::pluck(nome_nucleo_regional) %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("all", "percentual")) %>%
  dplyr::slice(-c(1:5)) %>%
  faxinar_tabela_ng_mal_identif(nome_nucleo_regional) 
  

# Conferindo totais
tab_uniao_da_vitoria_tidy %>% 
  dplyr::group_by(tipo_genero) %>% 
  dplyr::summarise(sum(area_ha))
    


# Paranavaí ---------------------------------------------------------------

loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

nome_nucleo_regional <- nucleos_regionais_tab_semi_ident[3]

tab_paranavai <-
  faxinar_tabela_ng_mal_identif_col_pinus(tabelas_pag_sem_imgs_tab_semi_ident,
                                          nome_nucleo_regional)

  
# printar no console
print(tab_paranavai, n = 100)

# está gerando números a mais na coluna de pinus, preciso deletar eles

# Definir municípios que contém pinus
pinus_paranavai <- c(
  "Alto Paraná",
  "Amaporã",
  "Guairaçá",
  "Loanda",
  "Marilena",
  "Mirador",
  "Paranavaí",
  "Planaltina do Paraná",
  "Porto Rico",
  "Santa Cruz de Monte Castelo",
  "Santa Isabel do Ivaí",
  "Santa Mônica",
  "São João do Caiuá",
  "São Pedro do Paraná",
  "Tamboara"
)

# ajustando
tab_paranavai_tidy <-
  tab_paranavai %>% 
  dplyr::mutate(
    
    # transformar em character
    pinus = as.character(pinus),
    
    # excluir infos onde nao deve ter pinus (de acordo com as cidades no vetor auxiliar)
    pinus = dplyr::case_when(!municipio %in% pinus_paranavai ~ NA_character_,
                             TRUE ~ pinus),
    
    # transformar novamente em número
    pinus = readr::parse_number(pinus, 
                                locale = readr::locale(decimal_mark = ".", 
                                                       grouping_mark = ","))
    
  ) %>% 
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")


# Conferindo totais
tab_paranavai_tidy %>% 
  dplyr::group_by(tipo_genero) %>% 
  dplyr::summarise(sum(area_ha, na.rm = TRUE))



# Jacarezinho -------------------------------------------------------------

nome_nucleo_regional <- nucleos_regionais_tab_semi_ident[4]

tab_jacarezinho <-
  faxinar_tabela_ng_mal_identif_col_pinus(tabelas_pag_sem_imgs_tab_semi_ident,
                                          nome_nucleo_regional)
  
  
# printar no console
print(tab_jacarezinho, n = 100)  



# está gerando números a mais na coluna de pinus, preciso deletar eles

# Definir municípios que contém pinus
pinus_jacarezinho <- c(
  "Curiúva",
  "Figueira",
  "Ibaiti",
  "Jaboti",
  "Japira",
  "Joaquim Távola",
  "Pinhalão",
  "Santo Antônio da Platina",
  "São José da Boa Vista",
  "Siqueira Campos",
  "Tomazina",
  "Wenceslau Braz"
)

# ajustando
pinus_jacarezinho_tidy <-
  tab_jacarezinho %>% 
  dplyr::mutate(
    
    # transformar em character
    pinus = as.character(pinus),
    
    # excluir infos onde nao deve ter pinus (de acordo com as cidades no vetor auxiliar)
    pinus = dplyr::case_when(!municipio %in% pinus_jacarezinho ~ NA_character_,
                             TRUE ~ pinus),
    
    # transformar novamente em número
    pinus = readr::parse_number(pinus, 
                                locale = readr::locale(decimal_mark = ".", 
                                                       grouping_mark = ","))
    
  ) %>% 
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")



# Conferindo totais
pinus_jacarezinho_tidy %>% 
  dplyr::group_by(tipo_genero) %>% 
  dplyr::summarise(sum(area_ha, na.rm = TRUE))



  
  