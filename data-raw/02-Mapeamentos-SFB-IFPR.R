

# Carregar e instalar pacotes necessários ---------------------------------
if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, usethis, pdftools, tabulizer)

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Visualizar pdf ----------------------------------------------------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

# # definir páginas para extração
# paginas_alvo <- c(30, 36, 37, 40:72)
# 
# # definir caminho e nomes para cada arquivo imagem
# nome_arquivos <- paste0("./inst/01-PR-SFB-IFPR/" , paginas_alvo, ".png")
# 
# # salvar cada página para visualizar no diretório
# pdftools::pdf_convert(url_mapeamento, 
#                       pages = paginas_alvo,
#                       filenames = nome_arquivos)

# Podemos perceber que tem algumas tabelas que são divididas entre páginas, e
# algumas que estão em páginas que contém um mapa (imagem) na mesma página.
# Essas últimas dão problema na função extract_tables do Tabulizer, não consegui
# arrumar e nem entender o porquê. 
# Para contornar isso, fiz a extração das páginas que tem imagens e tabelas,
# converti para word e retirei as imagens dessas páginas, após isso, salvei
# novamente as páginas em pdf, assim gerando um arquivo adicional com todas
# as páginas que continham tabela e imagem na mesma folha, porém agora somente
# com a tabela.

# esse é um exeplo do erro disparado porque tem uma imagem na página
tabela_2_campo_mourao <- tabulizer::extract_tables(url_mapeamento, pages = 36)

# até é possível extrair apenas o texto, porém o trabalho para faxinar seria imenso
tabulizer::extract_text(url_mapeamento, pages = 36)

# visualizar uma imagem
# OpenImageR::imageShow("./inst/30.png")


# Tabela 1- Extrair e transformar dados -----------------------------------

# extrair tabela
tabela_1_total <- tabulizer::extract_tables(url_mapeamento, pages = 30)

# ajustar dados - all - tabela de área total
tabela_arrumada <-
  tabela_1_total %>% 
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
  
  # add um identificador da tabela e realocar ele
  dplyr::mutate(tabela_fonte = "Área Total") %>% 
  dplyr::relocate(tabela_fonte, .before = regiao) %>% 

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
  dplyr::mutate(
    
    # ajustar colunas de áreas
    dplyr::across(.cols = corte:total,
                  readr::parse_number,locale = loc)
    
    )

tibble::view(tabela_tidy)

# Como a próxima etapa é transformar algumas colunas em linhas, acho desnecessário
# manter a coluna de percentual e total, pois ambas podem ser obtida facilmente 
# por meio de funções do tidyverse, além de poderem ocasionar confusões ao longo
# de análises. Também optei por retirar o núcleo regional "sub-total", que representa
# a soma de todos os núcleos dentro da região.

tabela_tidy <- 
  tabela_tidy %>% 
  dplyr::select(-percentual, -total)


# Transformar colunas de áreas em linhas
tb_area_total <-
  tabela_tidy %>% 
  tidyr::pivot_longer(cols = corte:pinus,
                      names_to = "tipo_genero",
                      values_to = "area_ha")

tibble::view(tb_area_total)


# Salvar tabela -----------------------------------------------------------


