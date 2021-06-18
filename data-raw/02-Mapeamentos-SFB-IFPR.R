

# Carregar e instalar pacotes necessários ---------------------------------
if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, usethis, pdftools, tabulizer)

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`



# Visualizar pdf ----------------------------------------------------------

# ver páginas
url_mapeamento <- "./data-raw/pdf/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"
pdftools::pdf_convert(url_mapeamento, pages = 30, filenames = "./inst/ifpr_pag30.png")

# extrair tabela
tabela_ext <- tabulizer::extract_tables(url_mapeamento, pages = 30)



# Transformar dados -------------------------------------------------------

# ajustar dados - all
tabela_arrumada <-
  tabela_ext %>% 
  # selecionar o item 1 da lista
  purrr::pluck(1) %>% 
  
  # transformar em tible 
  tibble::as_tibble(.name_repair = "unique") %>%
  
  # setar os nomes das colunas
  purrr::set_names(c("regiao", "nucleo_regional", "corte", "eucalipto_pinus", "total", "percentual")) %>% 
  
  # retirar linhas iniciais e finais
  dplyr::slice(-c(1:3), 
               -c(36, 37)) %>% 
  
  # substituir o que é vazio por NA
  dplyr::mutate(dplyr::across(dplyr::everything(),
                              dplyr::na_if, "")) %>% 
  
  # adicionar e modificar colunas
  dplyr::mutate(
    
    # adicionar coluna de índice
    id = dplyr::row_number(),
    
    # retirar as regiões existentes
    regiao = dplyr::case_when(regiao != NA ~ ""),
    
    # colocar o nome da região na primeira linha de cada nucleo_regional
    regiao = dplyr::case_when(id == 1 ~ "Centro-Oeste",
                              id == 4 ~ "Centro-Sul",
                              id == 13 ~ "Litoral",
                              id == 16 ~ "Noroeste",
                              id == 21 ~ "Norte",
                              id == 28 ~ "Oeste",
                              TRUE ~ regiao)) %>% 
  
  # preencher regiões com base na primeira linha de cada item
  tidyr::fill(regiao) %>% 
  
  # retirar linhas com NA
  tidyr::drop_na() %>% 
  
  # retirar coluna de ID
  dplyr::select(-id) %>% 

  # separar coluna de gênero
  tidyr::separate(col = eucalipto_pinus,
                  sep = " ",
                  into = c("eucalipto", "pinus"))


# Verificar no console
tabela_arrumada %>% 
  print(n = nrow(tabela_arrumada))


# Corrigir tipos de dados
loc <- readr::locale(decimal_mark = ",", grouping_mark = ".")

tabela_tidy <- 
  tabela_arrumada %>% 
  dplyr::mutate(dplyr::across(.cols = corte:total,
                              readr::parse_number, locale = loc))
    


# Deletar arquivos temporários --------------------------------------------
fs::file_delete("./inst/ifpr_pag30.png")