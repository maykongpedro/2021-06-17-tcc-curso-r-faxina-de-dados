
# Tabela 2 em diante - Páginas sem imagens com tabelas zoadas ------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

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