#' map_sfb_faxinar_tabela_ng_pag_com_img
#'
#' Descrição da função
#' Função utilizada para faxinar as tabelas de núcleos regionais das páginas do
#' mapeamento SFB-IFPR. Deixando elas estruturadas de uma maneira prática e tidy.
#' 
#' @param tabela_bruta_extraida tabela extraida do pdf pela função tabulizer::extract_tables
#' @param nome_nucleo_regional nome do núcleo regional
#' 
#' @return retorna uma tibble organizada e faxinada com as informações das tabelas das páginas
#' 
map_sfb_faxinar_tabela_ng_pag_com_img <- function(tabela_bruta_extraida, nome_nucleo_regional){
  
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
    dplyr::relocate(tabela_fonte:nucleo_regional, .before = municipio)
  
  #falta adicionar a transformação de colunas
  
}
