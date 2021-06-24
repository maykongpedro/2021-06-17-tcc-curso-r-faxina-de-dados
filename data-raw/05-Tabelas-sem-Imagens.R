

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
# Toledo = 6 colunas, retirar 4 linhas - Usar fórmula A

# O que consta como "fórmula A" irei utilizar uma fórmula para faxinar tudo de uma vez,
# já para os outros itens, devido às suas peculariedades no momento da extração,
# o caminho mais prático e seguro é fazer a fáxina e organização de cada um
# individualmente.



# Extração núcleos pela mesma fórmula -------------------------------------

# Definir núcleos que serão extraídos pela mesma fórmula
nucleos_formula_a <- c("Campo Mourão", "Curitiba", "Cornélio Procópio", "Toledo")


# Extrair e juntar todas as tabelas
tabelas_tidy_pag_SEM_imgs <-
  purrr::map_dfr(.x = nucleos_formula_a,
                 ~ faxinar_tabela_ng_pag_SEM_img(tabelas_pag_sem_imgs, .x))




# Guarapuava --------------------------------------------------------------
tab_guarapuava_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Guarapuava")



# Umuarama ----------------------------------------------------------------
tab_umuarama_tidy <-
  tabelas_pag_sem_imgs %>% 
  purrr::pluck("Umuarama")



# Maringá -----------------------------------------------------------------
tab_maringa_tidy %>%
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Maringá")


# Cascavel ----------------------------------------------------------------
tab_cascavel_tidy %>%
  tabelas_pag_sem_imgs %>%
  purrr::pluck("Cascavel")