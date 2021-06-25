
# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`
source("./R/03-fn-faxinar-tabela-nucleo-regional-paginas-sem-imagens.R")

# Tabela 2 em diante - Páginas sem imagens com tabelas ident. -------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

# Páginas apenas com tabelas que foram identificadas corretamente
paginas_tabelas <- c(37, 41, 43, 56, 59, 65, 67, 72)
nucleos_regionais_tab_ident <- c("Campo Mourão",
                                 "Curitiba",
                                 "Guarapuava",
                                 "Umuarama",
                                 "Cornélio Procópio",
                                 "Maringá",
                                 "Cascavel",
                                 "Toledo"
)
# Extrair tabelas
tabelas_pag_sem_imgs <- tabulizer::extract_tables(url_mapeamento,
                                                  pages = paginas_tabelas,
                                                  method = "stream")

# Renomear listas
names(tabelas_pag_sem_imgs) <- nucleos_regionais_tab_ident

# printar no console
print(tabelas_pag_sem_imgs)

# Analisando o output de extração, chego nas seguintes situações por núcleo regional:
# Campo Mourao = 5 colunas, retirar 5 linhas - Usar fórmula A
# Curitiba = 5 colunas, retirar 5 linhas - Usar fórmula A
# Guarapuava = 6 colunas, retirar 5 linhas, retirar quarta coluna - Extrair manualmente
# Umuarama = 4 colunas, retirar 4 linhas, separar colunas de tipo em 3 - Extrair manualmente
# Cornélio P. = 5 colunas, retirar 5 linhas - Usar fórmula A
# Maringá = 5 colunas, retirar 3 linhas - Extrair manualmente
# Cascavel = 4 colunas, retirar 5 linhas, separar colunas de tipo em 4 - Extrair manualmente
# Toledo = 6 colunas, retirar 4 linhas - Usar fórmula A

# O que consta como "fórmula A" irei utilizar uma fórmula para faxinar tudo de uma vez,
# já para os outros itens, devido às suas peculariedades no momento da extração,
# o caminho mais prático e seguro é fazer a fáxina e organização de cada um
# individualmente.


# Extração núcleos regionais pela mesma fórmula ---------------------------

# Definir núcleos que serão extraídos pela mesma fórmula
nucleos_formula_a <- c("Campo Mourão", "Curitiba", "Cornélio Procópio", "Toledo")


# Extrair e juntar todas as tabelas
tabelas_tidy_pag_SEM_imgs <-
  purrr::map_dfr(.x = nucleos_formula_a,
                 ~ faxinar_tabela_ng_pag_SEM_img(tabelas_pag_sem_imgs, .x))

# Conferir rapidamente
tabelas_tidy_pag_SEM_imgs %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha") %>% 
  print(n = 100)



# Guarapuava --------------------------------------------------------------

loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

nome_nucleo_regional <- "Guarapuava"
tab_guarapuava_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Guarapuava") %>% 
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto_pinus", "erro","total", "percentual")) %>%
  dplyr::slice(-c(1:5)) %>%
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
  dplyr::mutate(
    
    pinus = dplyr::case_when(stringr::str_detect(pinus, "%") ~ NA_character_,
                             TRUE ~ pinus),
    
    eucalipto = dplyr::case_when(stringr::str_detect(eucalipto, "%") ~ NA_character_,
                                 TRUE ~ eucalipto),
    
    corte = dplyr::case_when(stringr::str_detect(corte, "%") ~ NA_character_,
                             TRUE ~ corte)
    
  ) %>% 
  dplyr::mutate(dplyr::across(.cols = corte:pinus,
                              readr::parse_number, locale = loc)) %>%
  dplyr::filter(!municipio %in% c("TOTAL", "%")) %>% 
  
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")

print(tab_guarapuava_tidy, n = 10)


# Umuarama ----------------------------------------------------------------

nome_nucleo_regional <- "Umuarama"
tab_umuarama_tidy <-
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Umuarama") %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "euc_pin_total_perc", "percentual")) %>%
  dplyr::slice(-c(1:4)) %>%
  tidyr::separate(
    col = euc_pin_total_perc,
    sep = " ",
    into = c("eucalipto", "pinus", "total", "perc")
  ) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>%
  dplyr::select(-percentual) %>%
  dplyr::mutate(
    eucalipto = dplyr::case_when(
      stringr::str_detect(eucalipto, "%") ~ NA_character_,
      TRUE ~ eucalipto
    ),
    
    total = dplyr::case_when(stringr::str_detect(total, "%") ~ NA_character_,
                             TRUE ~ total)
    
  ) %>%
  dplyr::filter(!municipio %in% c("TOTAL", "%")) %>%
  
  dplyr::mutate(
    eucalipto = dplyr::case_when(is.na(eucalipto) == TRUE ~ total,
                                 TRUE ~ eucalipto),
    
    pinus = dplyr::case_when(
      municipio == "Ivaté" ~ perc,
      municipio == "São Jorge do Patrocínio" ~ perc,
      TRUE ~ pinus
    )
    
  ) %>%
  dplyr::select(-total, -perc) %>%
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha") %>% 
  dplyr::mutate(area_ha = readr::parse_number(area_ha, locale = loc)) %>% 
  dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                      nome_nucleo_regional),
                nucleo_regional = nome_nucleo_regional) %>%
  dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) 


print(tab_umuarama_tidy, n = 30)



# Maringá -----------------------------------------------------------------

nome_nucleo_regional <- "Maringá"
tab_maringa_tidy <-
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Maringá") %>% 
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto_pinus", "total", "percentual")) %>% 
  dplyr::slice(-c(1:3)) %>% 
  dplyr::select(-total, -percentual) %>% 
  tidyr::separate(col = eucalipto_pinus,
                  sep = " ",
                  into = c("eucalipto", "pinus")) %>%
  dplyr::mutate(
    corte = dplyr::case_when(stringr::str_detect(corte, "%") ~ NA_character_,
                             TRUE ~ corte),
    
    eucalipto = dplyr::case_when(stringr::str_detect(eucalipto, "%") ~ NA_character_,
                             TRUE ~ eucalipto),
    
    pinus = dplyr::case_when(stringr::str_detect(pinus, "%") ~ NA_character_,
                                 TRUE ~ pinus)
    
  ) %>%
  dplyr::mutate(dplyr::across(.cols = corte:pinus,
                              readr::parse_number, locale = loc)) %>%
  dplyr::filter(!municipio %in% c("TOTAL", "%")) %>%
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha") %>% 
  dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                      nome_nucleo_regional),
                nucleo_regional = nome_nucleo_regional) %>%
  dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) 

tab_maringa_tidy


# Cascavel ----------------------------------------------------------------

nome_nucleo_regional <- "Cascavel"
tab_cascavel_tidy <-
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Cascavel") %>% 
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "euc_pin_total_perc", "percentual")) %>%
  dplyr::slice(-c(1:5)) %>%
  tidyr::separate(
    col = euc_pin_total_perc,
    sep = " ",
    into = c("eucalipto", "pinus", "total", "perc")
  ) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>%
  dplyr::select(-percentual) %>%
  dplyr::mutate(
    eucalipto = dplyr::case_when(
      stringr::str_detect(eucalipto, "%") ~ NA_character_,
      TRUE ~ eucalipto
    ),

    pinus = dplyr::case_when(stringr::str_detect(pinus, "%") ~ NA_character_,
                             TRUE ~ pinus)

  ) %>%
  dplyr::filter(!municipio %in% c("TOTAL", "%")) %>%
  dplyr::mutate(
    eucalipto = dplyr::case_when(is.na(eucalipto) == TRUE ~ total,
                                 TRUE ~ eucalipto),

    pinus = dplyr::case_when(
      municipio == "Céu Azul" ~ perc,
      municipio == "Lindoeste" ~ perc,
      municipio == "Santa Terezinha do Itaipu" ~ perc,    
      TRUE ~ pinus
    )

  ) %>%
  dplyr::select(-total, -perc) %>%
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha") %>% 
  dplyr::mutate(area_ha = readr::parse_number(area_ha, locale = loc)) %>% 
  dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                      nome_nucleo_regional),
                nucleo_regional = nome_nucleo_regional) %>%
  dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) 
  
  
  

tab_cascavel_tidy

# Empilhar tabelas --------------------------------------------------------


# criar lista das tabelas individuais
list_nucleos_individuais <- list(
  tab_guarapuava_tidy,
  tab_umuarama_tidy,
  tab_maringa_tidy,
  tab_cascavel_tidy
)


# empilhar todas junto da principal
tabs_tidy_pag_sem_imagens <-
  tabelas_tidy_pag_SEM_imgs %>% 
  dplyr::bind_rows(list_nucleos_individuais)



# Salvar tabela -----------------------------------------------------------
saveRDS(tabs_tidy_pag_sem_imagens,"./data/tbs_tidy_pag_sem_imagens.rds")
