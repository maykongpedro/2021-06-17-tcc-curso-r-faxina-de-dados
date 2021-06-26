
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
    #>     └── plot_mapa.png

### Que tipo de análise a base tidy possibilitá?

## Análise da base: Distribuição espacial de área por gênero

![](https://github.com/maykongpedro/2021-06-17-tcc-curso-r-faxina-de-dados/raw/r-studio-cloud/inst/plot_mapa.png)

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.
