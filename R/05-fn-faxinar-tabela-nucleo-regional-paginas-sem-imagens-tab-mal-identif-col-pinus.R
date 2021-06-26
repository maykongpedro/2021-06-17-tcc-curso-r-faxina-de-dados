#' faxinar_tabela_ng_mal_identif_col_pinus
#'
#' Descrição da função
#' Função utilizada para faxinar as tabelas de núcleos regionais das páginas do
#' mapeamento SFB-IFPR sem imagem, deixando elas estruturadas de uma maneira 
#' prática e utilizável. A noção de utilização como base de dados se estrutura 
#' no conceito de "tidy".
#' 
#' Essa fórmula é para faxinar tabelas das páginas sem imagens que ficaram mal
#' identificadas pós extração e com erro na coluna de PINUS.
#' 
#' Como cada tabela é extraida de uma maneira, no script é destacado quais núcleos
#' regionais podem ser faxinados com essa fórmula. É necessário faxina adicional
#' para ajustar a coluan de pinus.
#' 
#' @param tabela_extraida tabela extraida do pdf pela função tabulizer::extract_tables
#' @param nome_nucleo_regional nome do núcleo regional
#' 
#' @return retorna uma tibble organizada e faxinada com as informações das tabelas das páginas
#' 
faxinar_tabela_ng_mal_identif_col_pinus <- function(tabela_extraida, nome_nucleo_regional){
  
  loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")
  
  tabela_extraida %>% 
    purrr::pluck(nome_nucleo_regional) %>%
    tibble::as_tibble(.name_repair = "unique") %>%
    purrr::set_names(c("all", "percentual")) %>%
    dplyr::slice(-c(1:5)) %>%
    dplyr::mutate(
      # retirar números da coluna
      municipio = stringr::str_remove_all(all, "[0-9]"),
      
      # retirar pontos, víruglas e '%'
      municipio = stringr::str_remove_all(municipio, "\\,|\\.|%"),
      
      # retirar espaços em branco no fim e começo das palavras
      municipio = stringr::str_squish(municipio),
      
      # retirar letras da coluna "all" e o apóstrofo
      all = stringr::str_remove_all(all, "[:alpha:]|\\'"),
      
      # remover espaços vazios no fim e começo
      all = stringr::str_squish(all)
      
    ) %>% 
    dplyr::relocate(municipio, .before = all) %>% 
    dplyr::mutate(dplyr::across(dplyr::everything(),
                                dplyr::na_if, "")) %>% 
    dplyr::filter(!is.na(municipio)) %>% 
    tidyr::separate(col = all,
                    sep = " ",
                    into = c("corte", "eucalipto", "pinus", "total")) %>% 
    dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                        nome_nucleo_regional),
                  nucleo_regional = nome_nucleo_regional) %>%
    dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) %>%
    dplyr::mutate(
      
      corte = dplyr::case_when(stringr::str_detect(corte, "%") ~ NA_character_,
                               TRUE ~ corte),
      
      eucalipto = dplyr::case_when(stringr::str_detect(eucalipto, "%") ~ NA_character_,
                                   TRUE ~ eucalipto),
      
      pinus = dplyr::case_when(stringr::str_detect(pinus, "%") ~ NA_character_,
                               TRUE ~ pinus)
      
    ) %>% 
    dplyr::select(-total, -percentual) %>% 
    dplyr::mutate(dplyr::across(.cols = corte:pinus,
                                readr::parse_number, locale = loc)) %>% 
    dplyr::filter(!municipio %in% c("TOTAL", "%")) 
  
}
