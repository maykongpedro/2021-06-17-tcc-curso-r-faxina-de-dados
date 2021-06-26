
# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`


# Tabela Francisco Beltrão - b --------------------------------------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

# Francisco Beltrão - b (pág 70) não quis funcionar. Foi necessário extrair
# a página, converter para word e salvar novamente em pdf

# Não captura nada
tabela_fb <- tabulizer::extract_tables(url_mapeamento,
                                       pages = 70)

print(tabela_fb)


# Arquivo processado apenas com a página 70
pag70 <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-70-tabela.pdf"
tabela_fb <- tabulizer::extract_tables(pag70,
                                       pages = 1)

# Nomeia a lista
names(tabela_fb) <- "Francisco Beltrão"

# Printa no console
print(tabela_fb)


  
# Faxinar tabela ----------------------------------------------------------

loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

nome_nucleo_regional <- "Francisco Beltrão"

tab_franciso_beltrao_tidy <- 
  tabela_fb %>% 
  purrr::pluck(nome_nucleo_regional) %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto", "pinus", "total", "percentual")) %>%
  dplyr::slice(-c(1:3)) %>%
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>%
  dplyr::select(-total, -percentual) %>%
  dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                      nome_nucleo_regional),
                nucleo_regional = nome_nucleo_regional) %>%
  dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) %>%
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
  

# Conferindo resultado
tab_franciso_beltrao_tidy %>% 
  tidyr::pivot_wider(names_from = "tipo_genero",
                     values_from = "area_ha")


# Salvar tabela -----------------------------------------------------------
saveRDS(tab_franciso_beltrao_tidy,"./data/tb_tidy_francisco_beltrao.rds")
