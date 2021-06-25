#' faxinar_tabela_ng_pag_com_img
#'
#' Descrição da função
#' Função utilizada para faxinar as tabelas de núcleos regionais das páginas do
#' mapeamento SFB-IFPR, deixando elas estruturadas de uma maneira prática e utilizável.
#' O conceito de utilização como base de dados se estrutura no conceito de "tidy".
#' Essa função foi especificamente ajustada para as páginas que continham tabelas
#' e imagens, cuja extração resultou em tabelas com 5 ou 6 colunas, todas com dados.
#' 
#' @param tabela_bruta_extraida tabela extraida do pdf pela função tabulizer::extract_tables
#' @param nome_nucleo_regional nome do núcleo regional
#' 
#' @return retorna uma tibble organizada e faxinada com as informações das tabelas das páginas
#' 
faxinar_tabela_ng_pag_com_img <- function(tabela_bruta_extraida, nome_nucleo_regional){

  numero_colunas <- ncol(tabela_bruta_extraida[[nome_nucleo_regional]])
  loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

  if (numero_colunas == 5){

    tabela_bruta_extraida %>%
      purrr::pluck(nome_nucleo_regional) %>%
      tibble::as_tibble(.name_repair = "unique") %>%
      purrr::set_names(c("municipio", "corte", "eucalipto_pinus", "total", "percentual")) %>%
      dplyr::slice(-c(1:3)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(),
                                  dplyr::na_if, "")) %>%
      dplyr::select(-total, -percentual) %>%
      dplyr::mutate(tabela_fonte = paste0("Área de Plantio de ",
                                          nome_nucleo_regional),
                    nucleo_regional = nome_nucleo_regional) %>%
      dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio) %>%
      tidyr::separate(col = eucalipto_pinus,
                      sep = " ",
                      into = c("eucalipto", "pinus")) %>%
      dplyr::mutate(dplyr::across(.cols = corte:pinus,
                                  readr::parse_number, locale = loc)) %>%
      dplyr::filter(!municipio %in% c("TOTAL", "%")) %>% 
      
      tidyr::pivot_longer(cols = corte:pinus,
                          names_to = "tipo_genero",
                          values_to = "area_ha")


  } else {

    tabela_bruta_extraida %>%
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
      dplyr::mutate(dplyr::across(.cols = corte:pinus,
                                  readr::parse_number, locale = loc)) %>%
      dplyr::filter(!municipio %in% c("TOTAL", "%")) %>% 
      tidyr::pivot_longer(cols = corte:pinus,
                          names_to = "tipo_genero",
                          values_to = "area_ha")

  }

}

