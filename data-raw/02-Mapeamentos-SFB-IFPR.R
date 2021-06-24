

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
# de análises
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



# Tabela 2 em diante - Páginas com imagens --------------------------------

# otter caminho
paginas_processadas <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas.pdf"
nucleos_regionais_tab_imgs <- c("Campo Mourão",
                                "Curitiba",
                                "Guarapuava",
                                "Irati",
                                "Laranjeiras do Sul - a",
                                "Laranjeiras do Sul - b",
                                "Ponta Grossa - a",
                                "Ponta Grossa - b",
                                "Paranaguá",
                                "Cianorte - a",
                                "Cianorte - b",
                                "Umuarama",
                                "Apucarana",
                                "Cornélio Procópio",
                                "Ivaiporã - a",
                                #"Ivaiporã - b",
                                "Londrina - a",
                                "Londrina - b",
                                "Cascavel",
                                "Dois Vizinhos",
                                "Francisco Beltrão",
                                "Toledo"
                                )

# extrair tabelas
tabelas_pag_com_imgs <-
  tabulizer::extract_tables(paginas_processadas,
                            method = "stream")

# Nomear listas
names(tabelas_pag_com_imgs) <- nucleos_regionais_tab_imgs

# Printar no console
print(tabelas_pag_com_imgs)


# Extração genérica
faxinar_tabela_ng_pag_com_img(tabelas_pag_com_imgs, 
                              nucleos_regionais_tab_imgs[9]) 


# Extrair e juntar todas as tabelas
tabelas_tidy_pag_com_imgs <-
  purrr::map_dfr(.x = nucleos_regionais_tab_imgs,
                 ~ faxinar_tabela_ng_pag_com_img(tabelas_pag_com_imgs, .x))

# outra notação
# purrr::map_dfr(.x = nucleos_regionais_tab_imgs, 
#                .f = faxinar_tabela_ng_pag_com_img,
#                tabela_bruta_extraida = tabelas_pag_com_imgs)
print(tabelas_tidy_pag_com_imgs)


# Arrumar nomes de tabelas "a" e "b"
tabelas_tidy_pag_com_imgs <-
  tabelas_tidy_pag_com_imgs %>% 
  dplyr::mutate(tabela_fonte = stringr::str_remove_all(tabela_fonte, " - a"),
                tabela_fonte = stringr::str_remove_all(tabela_fonte, " - b"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - a"),
                nucleo_regional = stringr::str_remove_all(nucleo_regional, " - b")
                )




# Tabela Ivaiporã - b -----------------------------------------------------

# Ivaiporã - b (pág 16 do arquivo de tabelas com imagens) não quis funcionar.
# Foi necessário extrair a página, converter para word, apagar tudo e deixar
# somente a tabela, ai sim salvar novamente em pdf.

# Não captura a informação completa
tabela_ivaipora_b <- tabulizer::extract_tables(paginas_processadas,
                                               pages = 16,
                                               method = "lattice")

print(tabela_ivaipora_b)

# Arquivo processado apenas com a tabela da página 61 do mapeamento original
pag61 <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-61-apenas-tabela.pdf"
tabela_ivaipora_b <- tabulizer::extract_tables(pag61)

# Nomeia a lista
names(tabela_ivaipora_b) <- "Ivaiporã - b"

# Printa no console
print(tabela_ivaipora_b)

# Faxinar a tabela 
tab_ivaipora_b_tidy <-
  faxinar_tabela_ng_pag_com_img(tabela_ivaipora_b, "Ivaiporã - b") %>% 
  dplyr::filter(!municipio %in% c("TOTAL", "%"))

print(tab_ivaipora_b_tidy)


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
# Toledo = 6 colunas, retirar 5 linhas - Usar fórmula A

# O que consta como "fórmula A" irei utilizar uma fórmula para faxinar tudo de uma vez,
# já para os outros itens, devido às suas peculariedades no momento da extração,
# o caminho mais prático e seguro é fazer a fáxina e organização de cada um
# individualmente.

nucleos_formula_a <- c("Campo Mourão", "Curitiba", "Cornélio Procópio", "Toledo")


# teste
nome_nucleo_regional <- "Campo Mourão"
tabelas_pag_sem_imgs %>% 
  purrr::pluck(nome_nucleo_regional) %>%
  tibble::as_tibble(.name_repair = "unique") %>%
  purrr::set_names(c("municipio", "corte", "eucalipto_pinus", "total", "percentual")) %>%
  dplyr::slice(-c(1:5)) %>%
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
  
  # como retiro os números que acabam em %?
  
  dplyr::mutate(
    
    pinus = dplyr::case_when(stringr::str_detect(pinus, "%") ~ NA_character_,
                             TRUE ~ pinus),
    
    eucalipto = dplyr::case_when(stringr::str_detect(eucalipto, "%") ~ NA_character_,
                                 TRUE ~ eucalipto),
    
    corte = dplyr::case_when(stringr::str_detect(corte, "%") ~ NA_character_,
                             TRUE ~ corte)
    
    )
  





tabelas_pag_sem_imgs[[2]]
#tabelas_pag_sem_imgs[[5]] -> vou precisar retirar o % da coluna de pinus e da coluna de corte
#tabelas_pag_sem_imgs[[8]] -> vou precisar retirar o % da coluna de pinus e da coluna de corte


tab_guarapuava_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Guarapuava")


tab_umuarama_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Umuarama")


tab_maringa_tidy %>%
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Maringá")


tab_cascavel_tidy %>%
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Cascavel")



# Tabela 2 em diante - Páginas sem imagens com tabelas zoadas ------------

# Páginas que a tabela ficou mal identificada na extração
paginas_tabelas_semi_ident <- c(47, 50, 54, 62)
nucleos_regionais_tab_semi_ident <- c("Pato Branco",
                                      "União da Vitória",
                                      "Paranavaí",
                                      "Jacarezinho")

# extrair tabelas
tabelas_pag_sem_imgs_tab_semi_ident <-
  tabulizer::extract_tables(url_mapeamento,
                            pages = paginas_tabelas_semi_ident)

# Renomear listas
names(tabelas_pag_sem_imgs_tab_semi_ident) <- nucleos_regionais_tab_semi_ident

# Printar no console
print(tabelas_pag_sem_imgs_tab_semi_ident)




# Tabela Francisco Beltrão - b --------------------------------------------

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




# Deletar arquivos temporários --------------------------------------------
#fs::file_delete("./inst/ifpr_pag30.png")
