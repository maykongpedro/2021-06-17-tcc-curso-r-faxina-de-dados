#' faxinar_tabela_ng_mal_identif
#'
#' Descrição da função
#' Função utilizada para faxinar as tabelas de núcleos regionais das páginas do
#' mapeamento SFB-IFPR sem imagem, deixando elas estruturadas de uma maneira 
#' prática e utilizável. A noção de utilização como base de dados se estrutura 
#' no conceito de "tidy".
#' 
#' Essa fórmula é para faxinar tabelas das páginas sem imagens que ficaram mal
#' identificadas pós extração.
#' 
#' Como cada tabela é extraida de uma maneira, no script é destacado quais núcleos
#' regionais podem ser faxinados com essa fórmula. Outro ponto é que resolvi
#' fazer apenas uma parte dela aqui para não repetir no script e deixar a 
#' definição do cabeçalho dentro da rotina mesmo.
#' 
#' @param tabela_extraida_header_org tabela extraida do pdf pela função tabulizer::extract_tables
#' e com cabeçalho organizado, além das linhas iniciais deletadas
#' @param nome_nucleo_regional nome do núcleo regional
#' 
#' @return retorna uma tibble organizada e faxinada com as informações das tabelas das páginas
#' 
faxinar_tabela_ng_mal_identif <- function(tabela_extraida_header_org, nome_nucleo_regional){
  
  loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")
  
  tabela_extraida_header_org %>% 
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
    dplyr::filter(!municipio %in% c("TOTAL", "%")) %>% 
    tidyr::pivot_longer(cols = corte:pinus,
                        names_to = "tipo_genero",
                        values_to = "area_ha")

}
