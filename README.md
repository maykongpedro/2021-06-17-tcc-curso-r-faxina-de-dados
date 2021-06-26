
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Fáxina de dados do mapeamento de florestas plantadas SFB-IFPR no Paraná

## Introdução
Esse repositório consiste no projeto realizado para entrega final do curso de Fáxina de Dados da Curso R. Nesse `README` será destacado de maneira resumida o que era necessário na entrega do trabalho e o que foi feito nesse em específico.
O tema escolhido era de livre escolha do aluno, decidi por pegar uma base em .pdf referente ao mapeamento de florestas plantadas no Paraná, realizado pelo Instituto de Florestas do Paraná - IFPR em conjunto com o Serviço Florestal Brasileiro - SFB, lançado em 2015.
A razão para isso é minha própria formação, Engenharia Florestal, e o fato de eu já ter necessitado consultar essa base antes e ter ficado limitado em relação às análises por conta do fato dela ser disponibilizada em pdf, a ideia aqui foi unir o útil ao agradável.

## Objetivo específico
Extrair todas as tabelas do pdf que contenham dados de mapeamento da área em hectares de Eucalipto, Pinus e regiões de Corte (colhidas). Após isso, consolidar em uma base de dados tidy, onde cada linha representa uma observaçõa distinta e as colunas representam variáveis.


<!-- badges: start -->
<!-- badges: end -->

## Sobre o projeto 
As regras para entrega do trabalho consistiam nos seguintes itens:
- A base de dados em formato bruto OU um script de acesso a essa base, fazendo um download por exemplo.
- Um ou mais scripts R que transformem a sua base bruta e untidy em uma (ou mais) base(s) tidy. 

O(s) script(s) deve(m) necessariamente:
- Ler os dados brutos;
- Manipular uma coluna do tipo texto;
- Salvar uma base de dados ao final do script que esteja no formato tidy “aumentado” que apresentamos no começo do curso, no formato .rds.


### Por que a base pode ser considerada untidy? 

### Como foram organizados os arquivos para transformar essa base em tidy?

### Que tipo de análise a base tidy possibilitá?

```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

![](README_files/figure-gfm/pressure-1.png)<!-- -->

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub.
