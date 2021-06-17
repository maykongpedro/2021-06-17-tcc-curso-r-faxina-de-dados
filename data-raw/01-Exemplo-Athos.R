
url_pdf <- "https://curso-r.github.io/main-regressao-linear/referencias/Ci%C3%AAncia%20de%20Dados.%20Fundamentos%20e%20Aplica%C3%A7%C3%B5es.%20Vers%C3%A3o%20parcial%20preliminar.%20maio%20Pedro%20A.%20Morettin%20Julio%20M.%20Singer.pdf"

# extrai a tabela do PDF (e não do PNG!)
tabela_extrida_do_pdf <- tabulizer::extract_tables(url_pdf, pages = 153)
tabela_extrida_do_pdf[[1]]

# library(tidyverse)
# library(janitor)
# Carregar pipe
'%>%' <- magrittr::`%>%`

tabela_extrida_do_pdf[[1]] %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  janitor::row_to_names(2) %>%
  janitor::clean_names() %>%
  tidyr::pivot_longer(everything(), names_to = c(".value", "conjunto"), names_sep = "_") %>%
  dplyr::select(-conjunto) %>%
  head() 