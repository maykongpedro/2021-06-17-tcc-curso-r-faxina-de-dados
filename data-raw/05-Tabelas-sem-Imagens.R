
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



# Extração núcleos pela mesma fórmula -------------------------------------

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


# Umuarama ----------------------------------------------------------------

# PROBLEMAAAAA
tab_umuarama_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Umuarama") %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto_pinus_total", "percentual")) %>%
  dplyr::slice(-c(1:4)) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>%
  
  tidyr::separate(col = eucalipto_pinus_total,
                  sep = " ",
                  into = c("eucalipto", "pinus", "total")) %>%
  dplyr::select(-total, -percentual) 




# Maringá -----------------------------------------------------------------

# MAIS DE BOAS
tab_maringa_tidy <-
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Maringá")


# Cascavel ----------------------------------------------------------------

# INFERNINHO
tab_cascavel_tidy <-
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Cascavel")


