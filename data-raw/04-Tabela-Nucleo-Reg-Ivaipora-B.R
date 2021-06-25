

# Carregar pipe e função --------------------------------------------------
'%>%' <- magrittr::`%>%`
source("./R/01-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens.R")


# Tabela Ivaiporã - b -----------------------------------------------------

# otter caminho
paginas_processadas <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas.pdf"

# Ivaiporã - b (pág 16 do arquivo de tabelas com imagens) não quis funcionar.
# Foi necessário extrair a página, converter para word, apagar tudo e deixar
# somente a tabela, ai sim salvar novamente em pdf.

# Não captura a informação completa
tabela_ivaipora_b <- tabulizer::extract_tables(paginas_processadas,
                                               pages = 16,
                                               method = "lattice")

print(tabela_ivaipora_b)


# Extrair corretamente ----------------------------------------------------

# Arquivo processado apenas com a tabela da página 61 do mapeamento original
pag61 <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB-61-apenas-tabela.pdf"
tabela_ivaipora_b <- tabulizer::extract_tables(pag61)

# Nomeia a lista
names(tabela_ivaipora_b) <- "Ivaiporã - b"

# Printa no console
print(tabela_ivaipora_b)


# Faxinar -----------------------------------------------------------------

# Faxinar a tabela 
tab_ivaipora_b_tidy <-
  faxinar_tabela_ng_pag_com_img(tabela_ivaipora_b, "Ivaiporã - b") %>% 
  dplyr::filter(!municipio %in% c("TOTAL", "%"))

print(tab_ivaipora_b_tidy)


# Salvar tabela -----------------------------------------------------------
saveRDS(tab_ivaipora_b_tidy,"./data/tb_ivaipora_b.rds")

