
# Tabela Francisco Beltrão - b --------------------------------------------

# caminho do pdf
url_mapeamento <- "./data-raw/pdf/01-SFB-IFPR/IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf"

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