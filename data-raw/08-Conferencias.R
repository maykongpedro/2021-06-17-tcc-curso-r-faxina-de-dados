

######### Script para conferências gerais ##########

# Carregar apenas pipe
'%>%' <- magrittr::`%>%`


# Tabela 1 - Área total ---------------------------------------------------

# carregar arquivo
tb_area_total <- readr::read_rds("./data/tb_area_total.rds")


# comparar manualmente com a página 30 do pdf
# visualizar sub-totais por região
tb_area_total %>% 
  dplyr::group_by(regiao) %>% 
  dplyr::summarise(area = sum(area_ha)) 






