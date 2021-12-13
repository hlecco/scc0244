## Exercício 5

Para o exercício 5, duas etapas são feitas previamente:
 - Remoção dos acentos de `de_analito`
 - Criação de uma MV identificando quais exames são de hemograma (contendo a palavra "hemograma")

- Escreva uma consulta que mostre quais analitos podem ser medidos em exames de hemograma, em cada hospital

``` sql
SELECT DISTINCT id_hospital, de_analito
FROM dados_processados.exames
INNER JOIN dados_processados.exames_hemograma
ON exames_hemograma.id_exame = exames.id_exame
WHERE hemograma;
```

Na consulta acima, `hemograma` é uma coluna da MV que identifica os exames como hemograma ou não.
O resultado abaixo é obtido após a atualização da tabela feita no exercício seguinte:

id_hospital|de_analito                  |
-----------|----------------------------|
BP         |Linfocitos (%)              |
SL         |Percentual de Basofilos     |
SL         |Percentual de Segmentados   |
HC         |Segmentados                 |
FY         |Percentual de Blastos       |
SL         |Percentual de Neutrofilos   |
SL         |Leucocitos                  |
HC         |Hematocrito                 |
SL         |Percentual de Blastos       |
FY         |Mielocitos                  |
SL         |Plasmocitos                 |
BP         |Percentual de Segmentados   |
SL         |Percentual de Mielocitos    |
FY         |Percentual de Monocitos     |
FY         |Plasmocitos                 |
BP         |Percentual de Mielocitos    |
SL         |Metamielocitos              |
FY         |Hematocrito                 |
SL         |Blastos                     |
...        |...                         |

- Compare os nomes dos analitos entre os diferentes hospitais, e exe-
cute um processo de atualização dos nomes, corrigindo e integrando
as variantes e grafias óbvias.

É importante notar que alguns analitos são medidos tanto em valores absolutos como
percentuais. Para isso, usamos estruturas `CASE` com casos do tipo

``` sql
WHEN de_analito ILIKE 'leucocitos%\%%' THEN 'Percentual de Leucocitos'
WHEN de_analito ILIKE 'leucocitos%' THEN 'Leucocitos'
WHEN de_analito ILIKE 'basofilos%\%%' THEN 'Percentual de Basofilos'
```

para identificar qual é o caso.
Os primeiros casos, se encontrados, tem precedência pelos seguintes, por isso é fundamental
colocar os que contém porcentagem antes.
