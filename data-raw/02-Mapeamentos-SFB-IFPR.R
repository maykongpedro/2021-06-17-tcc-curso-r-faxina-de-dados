

# Carregar e instalar pacotes necessários ---------------------------------
if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, janitor, usethis, pdftools, tabulizer)

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Visualizar pdf ----------------------------------------------------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

# definir páginas para extração
paginas_alvo <- c(30, 36, 37, 40:72)

# definir caminho e nomes para cada arquivo imagem
nome_arquivos <- paste0("./inst/01-PR-SFB-IFPR/" , paginas_alvo, ".png")

# salvar cada página para visualizar
pdftools::pdf_convert(url_mapeamento, 
                      pages = paginas_alvo,
                      filenames = nome_arquivos)

# Podemos perceber que tem algumas tabelas que são divididas entre páginas, e
# algumas que estão em páginas que contém um mapa (imagem) na mesma página.
# Essas últimas dão problema na função extract_tables do Tabulizer, não consegui
# arrumar e nem entender o porquê. 
# Para contornar isso, fiz a extração das páginas que tem imagens e tabelas,
# converti para word e retirei as imagens dessas páginas, após isso, salvei
# novamente as páginas em pdf, assim gerando um arquivo adicional com todas
# as páginas que continham tabela e imagem na mesma folha porém agora somente
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
                  readr::parse_number,locale = loc),
    
    # remover '%'
    percentual = stringr::str_remove_all(percentual, "%"),
    
    # ajustar coluna de percentual
    percentual = readr::parse_number(percentual,
                                     locale = loc),
    
    # dividir por 100
    percentual = percentual/100
    
    )

print(tabela_tidy)



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




# Tabela Ivaiporã - b -----------------------------------------------------

# Ivaiporã - b (pág 16 do arquivo de tabelas com imagens) não quis funcionar.
# Foi necessário extrair a página, converter para word, apagar tudo e deixar
# somente a tabela, ai sim salvar novamente em pdf.

# Não captura nada
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



# Tabela 2 em diante - Páginas sem imagens com tabelas ident. -------------

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
