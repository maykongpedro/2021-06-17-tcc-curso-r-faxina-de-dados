
<!-- README.md is generated from README.Rmd. Please edit that file -->

# project

<!-- badges: start -->
<!-- badges: end -->

# Fáxina de dados do mapeamento de florestas plantadas SFB-IFPR no Paraná

## Introdução

Esse repositório consiste no projeto realizado para entrega final do
curso de Fáxina de Dados da Curso R. Nesse `README` será destacado de
maneira resumida o que era necessário na entrega do trabalho e o que foi
feito nesse em específico. O tema escolhido era de livre escolha do
aluno, decidi por pegar uma base em .pdf referente ao mapeamento de
florestas plantadas no Paraná, realizado pelo Instituto de Florestas do
Paraná - IFPR em conjunto com o Serviço Florestal Brasileiro - SFB,
lançado em 2015. A razão para isso é minha própria formação, Engenharia
Florestal, e o fato de eu já ter necessitado consultar essa base antes e
ter ficado limitado em relação às análises por conta do fato dela ser
disponibilizada em pdf, a ideia aqui foi unir o útil ao agradável.

## Objetivo específico

Extrair todas as tabelas do pdf que contenham dados de mapeamento de
área em hectares de Eucalipto, Pinus e regiões de Corte (colhidas). Após
isso, consolidar em uma base de dados tidy, onde cada linha representa
uma observaçõa distinta e as colunas representam variáveis.

<!-- badges: start -->

<!-- badges: end -->

## Sobre o projeto

As regras para entrega do trabalho consistiam nos seguintes itens: - A
base de dados em formato bruto OU um script de acesso a essa base,
fazendo um download por exemplo. - Um ou mais scripts R que transformem
a sua base bruta e untidy em uma (ou mais) base(s) tidy.

O(s) script(s) deve(m) necessariamente: - Ler os dados brutos;

-   Manipular uma coluna do tipo texto;
-   Salvar uma base de dados ao final do script que esteja no formato
    tidy “aumentado” que foi apresentado no começo do curso, no formato
    .rds.

### Por que a base pode ser considerada untidy?

Primeiramente porque os dados estão consolidados dentro de um pdf. Em
segundo, uma vez extraídos, as colunas númericas (áreas em hectares)
estão distribuídas em três itens principais: corte, eucalipto e pinus.
Considerando que nesse caso as observações ficam distribuídas entre
colunas junto com as variáveis, pode ser considerada uma base untidy.

### Como foram organizados os arquivos para transformar essa base em tidy?

A base tidy final é o arquivo
`mapeamento_SFB-IFPR_completo_cod_IBGE.rds`.

Para extração das tabelas do pdf foi utilizado principalmente a função
`tabulizer::extract_tables`. Para algumas páginas, não foi possível
efetuar a correta extração, então foi necessário separar essas páginas
específicas do arquivo original de mapeamento, gerando assim três pdfs
adicionais além do pdf principal referente ao mapeamento, todos esses
arquivos usados como fonte de dados constam no caminho
`./data-raw/pdf/01-SFB-IFPR`. A faxina dos dados foi realizada com os
pacotes do `tidyverse` e afins.

Já para a organização dos scripts de extração e faxina de dados, todos
constam na pasta `./data-raw`. Foram divididos entre situações parecidas
de faxina e fonte de dados, o primeiro script é apenas um exemplo de
extração do professor Athos no
[blog](https://blog.curso-r.com/posts/2021-01-08-tabulizer/) da curso R.
O script 02 até o 08 é onde constam os códigos usados para extrair e
faxinar as tabelas. O penúltipo script (09) é um complemento de melhoria
ao projeto, onde é adicionado uma coluna referente ao código do
município do IBGE, visando facilitar as posteriores manipulações e
análises. O décimo e último script é apenas a plotagem do mapa exibido
nesse `README`.

As fórmulas de faxina, quando possível, foram estruturadas em scripts
específicos de fórmulas documentadas dentro da pasta `./R`.

Na pasta `./inst/01-PR-SFB-IFPR` constam as páginas que sofreram
extração e faxina, ou seja, as páginas do Mapeamento que continham
tabelas de interesse para o trabalho.

A estrutura de organização dos arquivos pode ser verificada a seguir:

    #> .
    #> ├── 2021-06-17-tcc-curso-r-faxina-de-dados.Rproj
    #> ├── R
    #> │   ├── 01-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens.R
    #> │   ├── 02-fn-faxinar-tabela-nucleo-regional-paginas-com-imagens-col-erro.R
    #> │   ├── 03-fn-faxinar-tabela-nucleo-regional-paginas-sem-imagens.R
    #> │   ├── 04-fn-faxinar-tabela-nucleo-regional-paginas-sem-imagens-tab-mal-identif.R
    #> │   └── 05-fn-faxinar-tabela-nucleo-regional-paginas-sem-imagens-tab-mal-identif-col-pinus.R
    #> ├── README.Rmd
    #> ├── README.md
    #> ├── README_files
    #> │   └── figure-gfm
    #> │       └── pressure-1.png
    #> ├── data
    #> │   ├── mapeamento_SFB-IFPR_completo.rds
    #> │   ├── mapeamento_SFB-IFPR_completo_cod_IBGE.rds
    #> │   ├── tb_area_total.rds
    #> │   ├── tb_ivaipora_b.rds
    #> │   ├── tb_tidy_francisco_beltrao.rds
    #> │   ├── tbs_pag_com_imagens.rds
    #> │   ├── tbs_tidy_pag_sem_imagens.rds
    #> │   └── tbs_tidy_pag_sem_imagens_mal_ident.rds
    #> ├── data-raw
    #> │   ├── 01-Exemplo-Athos.R
    #> │   ├── 02-Mapeamentos-SFB-IFPR.R
    #> │   ├── 03-Tabelas-com-Imagens.R
    #> │   ├── 04-Tabela-Nucleo-Reg-Ivaipora-B.R
    #> │   ├── 05-Tabelas-sem-Imagens.R
    #> │   ├── 06-Tabelas-sem-Imagens-Mal-Identificadas.R
    #> │   ├── 07-Tabela-Nucleo-Reg-Francisco-Beltrao-B.R
    #> │   ├── 08-Conferencias.R
    #> │   ├── 09-Adiciona-Coluna-Cod-IBGE.R
    #> │   ├── 10-Plotar-mapa-distribuicao-por-genero.R
    #> │   └── pdf
    #> │       └── 01-SFB-IFPR
    #> │           ├── IFPR e SFB – Mapeamento dos plantios florestais do estado do Paraná.pdf
    #> │           ├── IFPR e SFB-61-apenas-tabela.pdf
    #> │           ├── IFPR e SFB-70-tabela.pdf
    #> │           └── IFPR e SFB-páginas-36,40,42,44-46,48-49,51-53,55,57-58,60-61,63-64,66,68-69,71-tabelas.pdf
    #> └── inst
    #>     ├── 01-PR-SFB-IFPR
    #>     │   ├── 30.png
    #>     │   ├── 36.png
    #>     │   ├── 37.png
    #>     │   ├── 40.png
    #>     │   ├── 41.png
    #>     │   ├── 42.png
    #>     │   ├── 43.png
    #>     │   ├── 44.png
    #>     │   ├── 45.png
    #>     │   ├── 46.png
    #>     │   ├── 47.png
    #>     │   ├── 48.png
    #>     │   ├── 49.png
    #>     │   ├── 50.png
    #>     │   ├── 51.png
    #>     │   ├── 52.png
    #>     │   ├── 53.png
    #>     │   ├── 54.png
    #>     │   ├── 55.png
    #>     │   ├── 56.png
    #>     │   ├── 57.png
    #>     │   ├── 58.png
    #>     │   ├── 59.png
    #>     │   ├── 60.png
    #>     │   ├── 61.png
    #>     │   ├── 62.png
    #>     │   ├── 63.png
    #>     │   ├── 64.png
    #>     │   ├── 65.png
    #>     │   ├── 66.png
    #>     │   ├── 67.png
    #>     │   ├── 68.png
    #>     │   ├── 69.png
    #>     │   ├── 70.png
    #>     │   ├── 71.png
    #>     │   └── 72.png
    #>     └── plot_mapa_ajust.png

### Que tipo de análise a base tidy possibilitá?

Com a base tidy será fácil gerar análises e resumos de dados sobre a
área de florestas plantadas no Paraná referente ao mapeamento publicado
pela SFB-IFPR em 2015, com ano-base 2014. Os dados pode ser analisados
em nível de:

-   Núcleo regional
-   Município
-   Área de corte (cohida)
-   Área de eucalipto (plantado)
-   Área de pinus (plantado)

## Análise da base: Distribuição espacial

Uma análise rápida que pode ser feita é a distribuição espacial das
áreas por gênero de plantio, visando demonstar a utilização da base
tidy.

### Carregar dados

``` r
# Carregar apenas pipe
'%>%' <- magrittr::`%>%`

# Carregar base do mapeamento
base_mapeamento <- readr::read_rds("./data/mapeamento_SFB-IFPR_completo_cod_IBGE.rds") 


# Lendo shape dos municípios do PR
base_muni_pr <- geobr::read_municipality(code_muni= "PR", year=2010)
#> Loading required namespace: sf
#> Using year 2010
#> Downloading: 780 B     Downloading: 780 B     Downloading: 1.6 kB     Downloading: 1.6 kB     Downloading: 1.8 kB     Downloading: 1.8 kB     Downloading: 1.9 kB     Downloading: 1.9 kB     Downloading: 1.9 kB     Downloading: 1.9 kB     Downloading: 1.9 kB     Downloading: 1.9 kB     Downloading: 10 kB     Downloading: 10 kB     Downloading: 10 kB     Downloading: 10 kB     Downloading: 10 kB     Downloading: 10 kB     Downloading: 18 kB     Downloading: 18 kB     Downloading: 18 kB     Downloading: 18 kB     Downloading: 18 kB     Downloading: 18 kB     Downloading: 26 kB     Downloading: 26 kB     Downloading: 26 kB     Downloading: 26 kB     Downloading: 26 kB     Downloading: 26 kB     Downloading: 34 kB     Downloading: 34 kB     Downloading: 34 kB     Downloading: 34 kB     Downloading: 34 kB     Downloading: 34 kB     Downloading: 42 kB     Downloading: 42 kB     Downloading: 42 kB     Downloading: 42 kB     Downloading: 42 kB     Downloading: 42 kB     Downloading: 50 kB     Downloading: 50 kB     Downloading: 50 kB     Downloading: 50 kB     Downloading: 50 kB     Downloading: 50 kB     Downloading: 59 kB     Downloading: 59 kB     Downloading: 59 kB     Downloading: 59 kB     Downloading: 59 kB     Downloading: 59 kB     Downloading: 67 kB     Downloading: 67 kB     Downloading: 67 kB     Downloading: 67 kB     Downloading: 67 kB     Downloading: 67 kB     Downloading: 75 kB     Downloading: 75 kB     Downloading: 75 kB     Downloading: 75 kB     Downloading: 75 kB     Downloading: 75 kB     Downloading: 83 kB     Downloading: 83 kB     Downloading: 83 kB     Downloading: 83 kB     Downloading: 83 kB     Downloading: 83 kB     Downloading: 91 kB     Downloading: 91 kB     Downloading: 91 kB     Downloading: 91 kB     Downloading: 91 kB     Downloading: 91 kB     Downloading: 99 kB     Downloading: 99 kB     Downloading: 99 kB     Downloading: 99 kB     Downloading: 99 kB     Downloading: 99 kB     Downloading: 110 kB     Downloading: 110 kB     Downloading: 110 kB     Downloading: 110 kB     Downloading: 110 kB     Downloading: 110 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 120 kB     Downloading: 130 kB     Downloading: 130 kB     Downloading: 130 kB     Downloading: 130 kB     Downloading: 130 kB     Downloading: 130 kB     Downloading: 140 kB     Downloading: 140 kB     Downloading: 140 kB     Downloading: 140 kB     Downloading: 140 kB     Downloading: 140 kB     Downloading: 150 kB     Downloading: 150 kB     Downloading: 150 kB     Downloading: 150 kB     Downloading: 150 kB     Downloading: 150 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 160 kB     Downloading: 170 kB     Downloading: 170 kB     Downloading: 170 kB     Downloading: 170 kB     Downloading: 170 kB     Downloading: 170 kB     Downloading: 180 kB     Downloading: 180 kB     Downloading: 180 kB     Downloading: 180 kB     Downloading: 180 kB     Downloading: 180 kB     Downloading: 190 kB     Downloading: 190 kB     Downloading: 190 kB     Downloading: 190 kB     Downloading: 190 kB     Downloading: 190 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 200 kB     Downloading: 210 kB     Downloading: 210 kB     Downloading: 210 kB     Downloading: 210 kB     Downloading: 210 kB     Downloading: 210 kB     Downloading: 220 kB     Downloading: 220 kB     Downloading: 220 kB     Downloading: 220 kB     Downloading: 220 kB     Downloading: 220 kB     Downloading: 230 kB     Downloading: 230 kB     Downloading: 230 kB     Downloading: 230 kB     Downloading: 230 kB     Downloading: 230 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 240 kB     Downloading: 250 kB     Downloading: 250 kB     Downloading: 250 kB     Downloading: 250 kB     Downloading: 250 kB     Downloading: 250 kB     Downloading: 260 kB     Downloading: 260 kB     Downloading: 260 kB     Downloading: 260 kB     Downloading: 260 kB     Downloading: 260 kB     Downloading: 270 kB     Downloading: 270 kB     Downloading: 270 kB     Downloading: 270 kB     Downloading: 270 kB     Downloading: 270 kB     Downloading: 280 kB     Downloading: 280 kB     Downloading: 280 kB     Downloading: 280 kB     Downloading: 280 kB     Downloading: 280 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 290 kB     Downloading: 300 kB     Downloading: 300 kB     Downloading: 300 kB     Downloading: 300 kB     Downloading: 300 kB     Downloading: 300 kB     Downloading: 310 kB     Downloading: 310 kB     Downloading: 310 kB     Downloading: 310 kB     Downloading: 310 kB     Downloading: 310 kB     Downloading: 320 kB     Downloading: 320 kB     Downloading: 320 kB     Downloading: 320 kB     Downloading: 320 kB     Downloading: 320 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 330 kB     Downloading: 340 kB     Downloading: 340 kB     Downloading: 340 kB     Downloading: 340 kB     Downloading: 340 kB     Downloading: 340 kB     Downloading: 350 kB     Downloading: 350 kB     Downloading: 350 kB     Downloading: 350 kB     Downloading: 350 kB     Downloading: 350 kB     Downloading: 360 kB     Downloading: 360 kB     Downloading: 360 kB     Downloading: 360 kB     Downloading: 360 kB     Downloading: 360 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 370 kB     Downloading: 380 kB     Downloading: 380 kB     Downloading: 380 kB     Downloading: 380 kB     Downloading: 380 kB     Downloading: 380 kB     Downloading: 390 kB     Downloading: 390 kB     Downloading: 390 kB     Downloading: 390 kB     Downloading: 390 kB     Downloading: 390 kB     Downloading: 400 kB     Downloading: 400 kB     Downloading: 400 kB     Downloading: 400 kB     Downloading: 400 kB     Downloading: 400 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 410 kB     Downloading: 420 kB     Downloading: 420 kB     Downloading: 420 kB     Downloading: 420 kB     Downloading: 420 kB     Downloading: 420 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 430 kB     Downloading: 440 kB     Downloading: 440 kB     Downloading: 440 kB     Downloading: 440 kB     Downloading: 440 kB     Downloading: 440 kB     Downloading: 450 kB     Downloading: 450 kB     Downloading: 450 kB     Downloading: 450 kB     Downloading: 450 kB     Downloading: 450 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 460 kB     Downloading: 470 kB     Downloading: 470 kB     Downloading: 470 kB     Downloading: 470 kB     Downloading: 470 kB     Downloading: 470 kB     Downloading: 480 kB     Downloading: 480 kB     Downloading: 480 kB     Downloading: 480 kB     Downloading: 480 kB     Downloading: 480 kB     Downloading: 490 kB     Downloading: 490 kB     Downloading: 490 kB     Downloading: 490 kB     Downloading: 490 kB     Downloading: 490 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 500 kB     Downloading: 510 kB     Downloading: 510 kB     Downloading: 510 kB     Downloading: 510 kB     Downloading: 510 kB     Downloading: 510 kB     Downloading: 520 kB     Downloading: 520 kB     Downloading: 520 kB     Downloading: 520 kB     Downloading: 520 kB     Downloading: 520 kB     Downloading: 530 kB     Downloading: 530 kB     Downloading: 530 kB     Downloading: 530 kB     Downloading: 530 kB     Downloading: 530 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 540 kB     Downloading: 550 kB     Downloading: 550 kB     Downloading: 550 kB     Downloading: 550 kB     Downloading: 550 kB     Downloading: 550 kB     Downloading: 560 kB     Downloading: 560 kB     Downloading: 560 kB     Downloading: 560 kB     Downloading: 560 kB     Downloading: 560 kB     Downloading: 570 kB     Downloading: 570 kB     Downloading: 570 kB     Downloading: 570 kB     Downloading: 570 kB     Downloading: 570 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 580 kB     Downloading: 590 kB     Downloading: 590 kB     Downloading: 590 kB     Downloading: 590 kB     Downloading: 590 kB     Downloading: 590 kB     Downloading: 600 kB     Downloading: 600 kB     Downloading: 600 kB     Downloading: 600 kB     Downloading: 600 kB     Downloading: 600 kB     Downloading: 610 kB     Downloading: 610 kB     Downloading: 610 kB     Downloading: 610 kB     Downloading: 610 kB     Downloading: 610 kB     Downloading: 620 kB     Downloading: 620 kB     Downloading: 620 kB     Downloading: 620 kB     Downloading: 620 kB     Downloading: 620 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 630 kB     Downloading: 640 kB     Downloading: 640 kB     Downloading: 640 kB     Downloading: 640 kB     Downloading: 640 kB     Downloading: 640 kB     Downloading: 650 kB     Downloading: 650 kB     Downloading: 650 kB     Downloading: 650 kB     Downloading: 650 kB     Downloading: 650 kB     Downloading: 660 kB     Downloading: 660 kB     Downloading: 660 kB     Downloading: 660 kB     Downloading: 660 kB     Downloading: 660 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 670 kB     Downloading: 680 kB     Downloading: 680 kB     Downloading: 680 kB     Downloading: 680 kB     Downloading: 680 kB     Downloading: 680 kB     Downloading: 690 kB     Downloading: 690 kB     Downloading: 690 kB     Downloading: 690 kB     Downloading: 690 kB     Downloading: 690 kB     Downloading: 700 kB     Downloading: 700 kB     Downloading: 700 kB     Downloading: 700 kB     Downloading: 700 kB     Downloading: 700 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 710 kB     Downloading: 720 kB     Downloading: 720 kB     Downloading: 720 kB     Downloading: 720 kB     Downloading: 720 kB     Downloading: 720 kB     Downloading: 730 kB     Downloading: 730 kB     Downloading: 730 kB     Downloading: 730 kB     Downloading: 730 kB     Downloading: 730 kB     Downloading: 740 kB     Downloading: 740 kB     Downloading: 740 kB     Downloading: 740 kB     Downloading: 740 kB     Downloading: 740 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 750 kB     Downloading: 760 kB     Downloading: 760 kB     Downloading: 760 kB     Downloading: 760 kB     Downloading: 760 kB     Downloading: 760 kB     Downloading: 770 kB     Downloading: 770 kB     Downloading: 770 kB     Downloading: 770 kB     Downloading: 770 kB     Downloading: 770 kB     Downloading: 780 kB     Downloading: 780 kB     Downloading: 780 kB     Downloading: 780 kB     Downloading: 780 kB     Downloading: 780 kB     Downloading: 790 kB     Downloading: 790 kB     Downloading: 790 kB     Downloading: 790 kB     Downloading: 790 kB     Downloading: 790 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 800 kB     Downloading: 810 kB     Downloading: 810 kB     Downloading: 810 kB     Downloading: 810 kB     Downloading: 810 kB     Downloading: 810 kB     Downloading: 820 kB     Downloading: 820 kB     Downloading: 820 kB     Downloading: 820 kB     Downloading: 820 kB     Downloading: 820 kB     Downloading: 830 kB     Downloading: 830 kB     Downloading: 830 kB     Downloading: 830 kB     Downloading: 830 kB     Downloading: 830 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 840 kB     Downloading: 850 kB     Downloading: 850 kB     Downloading: 850 kB     Downloading: 850 kB     Downloading: 850 kB     Downloading: 850 kB     Downloading: 860 kB     Downloading: 860 kB     Downloading: 860 kB     Downloading: 860 kB     Downloading: 860 kB     Downloading: 860 kB     Downloading: 870 kB     Downloading: 870 kB     Downloading: 870 kB     Downloading: 870 kB     Downloading: 870 kB     Downloading: 870 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 880 kB     Downloading: 890 kB     Downloading: 890 kB     Downloading: 890 kB     Downloading: 890 kB     Downloading: 890 kB     Downloading: 890 kB     Downloading: 900 kB     Downloading: 900 kB     Downloading: 900 kB     Downloading: 900 kB     Downloading: 900 kB     Downloading: 900 kB     Downloading: 910 kB     Downloading: 910 kB     Downloading: 910 kB     Downloading: 910 kB     Downloading: 910 kB     Downloading: 910 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 920 kB     Downloading: 930 kB     Downloading: 930 kB     Downloading: 930 kB     Downloading: 930 kB     Downloading: 930 kB     Downloading: 930 kB     Downloading: 940 kB     Downloading: 940 kB     Downloading: 940 kB     Downloading: 940 kB     Downloading: 940 kB     Downloading: 940 kB     Downloading: 950 kB     Downloading: 950 kB     Downloading: 950 kB     Downloading: 950 kB     Downloading: 950 kB     Downloading: 950 kB     Downloading: 960 kB     Downloading: 960 kB     Downloading: 960 kB     Downloading: 960 kB     Downloading: 960 kB     Downloading: 960 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 970 kB     Downloading: 980 kB     Downloading: 980 kB     Downloading: 980 kB     Downloading: 980 kB     Downloading: 980 kB     Downloading: 980 kB     Downloading: 990 kB     Downloading: 990 kB     Downloading: 990 kB     Downloading: 990 kB     Downloading: 990 kB     Downloading: 990 kB     Downloading: 1,000 kB     Downloading: 1,000 kB     Downloading: 1,000 kB     Downloading: 1,000 kB     Downloading: 1,000 kB     Downloading: 1,000 kB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.1 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB     Downloading: 1.2 MB
```

### Transformar e juntar bases

``` r
# fazer joiin da base com o shape
base_geo <-
  base_muni_pr %>% 
  dplyr::left_join(base_mapeamento, by = "code_muni")
```

### Plotar mapa

``` r
quebras <- c(0, 1000, 5000, 10000, 20000, 30000, 40000, 50000)
ordem <- c("0-1000", "1000-5000", "5000-10000", "10000-20000", "20000-30000", "30000-40000", "40000-50000")

plot <- 
  base_geo %>% 
  dplyr::filter(!is.na(tipo_genero),
                tipo_genero != "corte"
  ) %>% 
  dplyr::mutate(
    
    tipo_genero = dplyr::case_when(tipo_genero == "pinus" ~ "Pinus",
                                   tipo_genero == "eucalipto" ~ "Eucalipto",
                                   TRUE ~ tipo_genero),
    
    area_ha = cut(area_ha,
                  quebras,
                  dig.lab = 5),
    
    area_ha = stringr::str_remove_all(area_ha, "\\(|\\]"),
    
    area_ha = stringr::str_replace_all(area_ha,  ",", "-"),
    
    area_ha = factor(area_ha,
                     levels = ordem,
                     ordered = TRUE)
    
  ) %>% 
  
  ggplot2::ggplot() +
  ggplot2::geom_sf(alpha = .5,
                   color = "white",
                   size = 0.2) +
  ggplot2::geom_sf(ggplot2::aes(fill = area_ha)) +
  
  ggplot2::scale_fill_viridis_d(
    direction = -1,
    option = "magma",
    guide = ggplot2::guide_legend(
      keyheight = ggplot2::unit(3, units = "mm"),
      keywidth = ggplot2::unit(12, units = "mm"),
      label.position = "top",
      title.position = 'top',
      title.theme = ggplot2::element_text(size = 10),
      nrow = 1
    )
  ) +
  
  ggplot2::facet_wrap(~tipo_genero) +
  ggplot2::labs(fill = "Legenda: Classe de área (ha)",
                subtitle = "Mapeamento de florestas plantadas do Serviço Florestal Brasileiro (SFB) \nem conjunto com o Instituto de Florestas do Paraná (IFPR). Ano-base: 2014",
                caption = "**Dataviz:** @maykongpedro | **Fonte:** Mapeamento SFB-IFPR no Paraná (Dados organizados pelo autor)") +
  ggplot2::ggtitle("Distribuição espacial de florestas plantadas no Paraná") +
  
  ggspatial::annotation_north_arrow(
    location = "br",
    which_north = "true",
    height = ggplot2::unit(1, "cm"),
    width = ggplot2::unit(1, "cm"),
    pad_x = ggplot2::unit(0.1, "in"),
    pad_y = ggplot2::unit(0.1, "in"),
    style = ggspatial::north_arrow_fancy_orienteering
  ) +
  ggspatial::annotation_scale() +
  ggiraphExtra::theme_clean2() +
  ggplot2::theme(
    strip.background.x = ggplot2::element_rect(
      color="black"
    ),
    plot.title = ggplot2::element_text(face = "bold",
                                       vjust = 13),
    plot.subtitle = ggplot2::element_text(vjust = 17),
    plot.caption = ggtext::element_markdown(),
    legend.position = c(0.28, 1.22), #horizontal, vertical
    plot.margin = ggplot2::unit(c(1.5,1,0,1), "cm"),
    panel.grid = ggplot2::element_blank()
  )
```

![](https://github.com/maykongpedro/2021-06-17-tcc-curso-r-faxina-de-dados/raw/r-studio-cloud/inst/plot_mapa_ajust.png)
