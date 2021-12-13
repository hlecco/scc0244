## Exercício 2

### Descrição das tabelas

O script `ex_2-tabelas.sql` descreve uma consulta preparada que permite
obter dados estatísticos básicos a respeito de uma tabela do banco,
dados o schema e o nome.

Assim, obtemos o percentual de nulos, a quantidade de valores distintos,
a variância (em caso numérico) e os valores mais comuns para cada coluna
da tabela

coluna        |percentual_nulos|valores_distintos|variancia        |valores_mais_comuns                                                                                                                                                                                                                                            |
--------------|----------------|-----------------|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
id_paciente   |             0.0|             -1.0|                 |                                                                                                                                                                                                                                                               |
id_sexo       |             0.0|              2.0|                 |{F,M}                                                                                                                                                                                                                                                          |
aa_nascimento |     0.032933332|             91.0|298.6609669490619|{1982,1981,1983,1987,1986,1985,1988,1979,1980,1984,1978,1989,1990,1977,1976,1991,1975,1974,1992,1993,1994,1973,1972,1970,1995,1971,1996,1997,1967,1969,1965,1998,1964,1966,1968,1963,1962,1999,2000,1960,1961,1958,2001,1957,1956,1955,1959,1953,1952,1954,2002|
cd_pais       |          0.0001|              1.0|                 |{BR}                                                                                                                                                                                                                                                           |
cd_uf         |             0.0|             19.0|                 |{SP,RJ,RS,PR,PE,BA,MA,UU,DF,MG,RN,SC,GO,AM}                                                                                                                                                                                                                    |
cd_municipio  |     0.062366668|            137.0|                 |{"SAO PAULO","RIO DE JANEIRO",OSASCO,CURITIBA,"PORTO ALEGRE",RECIFE,NITEROI,SALVADOR,CAMPINAS,"SANTO ANDRE",BARUERI,GUARULHOS,"SAO BERNARDO DO CAMPO",JUNDIAI,"SANTANA DE PARNAIBA","SAO LUIS","SAO GONCALO","DUQUE DE CAXIAS",COTIA,"SAO CAETANO DO SUL","NOVA|
cd_cepreduzido|          0.6587|           1100.0|                 |{60299,80520,24220,06029,22631,51020,22790,24230,80420,41830,13015,06543,05465,22793,05651,51021,09823,05652,13213,01431,22230,50070,04344,80510,22775,01455,22250,20510,22620,52050,24210,05303,22451,52061,21221,65075,22210,22640,24240,52060,04502,22630,50|
id_hospital   |             0.0|              4.0|                 |{FY,EI,BP,HC}                                                                                                                                                                                                                                                  |


## Tabela Pacientes

Descrevemos uma função para obter a idade a partir do ano de nascimento,
para tornar as consultas mais legíveis.
A função, no entanto, não é usada, pois a consulta torna-se mais rápida ao simplesmente
usar o ano atual - 2021.

Cada exercício é descrito por uma transação no script.
As distribuições em faixas etárias são feitas usando histogramas de modo a
simplificar a visualização dos dados.

- Qual a quantidade de pacientes presente na base de dados? Quantos são homens e quantos são mulheres?

sexo |count |
-----|------|
F    |472071|
Total|862571|
M    |390500|


- Qual é a faixa etária dos pacientes homens e mulheres? Qual a distribuição dos quartis dentro de cada faixa?

id_sexo|idade_minima|idade_maxima|primeiro_quartil|mediana|terceiro_quartil|num_pacientes|
-------|------------|------------|----------------|-------|----------------|-------------|
F      |          18|          36|             6.0|   10.0|            15.0|        35312|
F      |          36|          54|            26.0|   30.0|            33.0|       150148|
F      |          54|          72|            40.0|   43.0|            48.0|       173129|
F      |          72|          90|            58.0|   61.0|            66.0|        74431|
F      |          90|         108|            75.0|   78.0|            83.0|        20670|
F      |         108|         126|            91.0|   91.0|            91.0|         2630|
M      |          18|          36|             6.0|   10.0|            14.0|        36270|
M      |          36|          54|            26.0|   30.0|            33.0|       120547|
M      |          54|          72|            40.0|   44.0|            48.0|       143694|
M      |          72|          90|            58.0|   61.0|            66.0|        61007|
M      |          90|         108|            75.0|   78.0|            82.0|        15374|
M      |         108|         126|            91.0|   91.0|            91.0|         1013|

- Qual a distribuição em cada gênero por década de vida?

id_sexo|decada_nascimento|idade_primeiro_quartil|idade_mediana|idade_terceiro_quartil|num_pacientes|
-------|-----------------|----------------------|-------------|----------------------|-------------|
F      |             1930|                  84.0|         87.0|                  91.0|         9363|
F      |             1940|                  73.0|         75.0|                  78.0|        16371|
F      |             1950|                  64.0|         66.0|                  68.0|        34759|
F      |             1960|                  54.0|         56.0|                  59.0|        55608|
F      |             1970|                  43.0|         46.0|                  48.0|        89838|
F      |             1980|                  34.0|         37.0|                  39.0|       126328|
F      |             1990|                  25.0|         27.0|                  30.0|        78170|
F      |             2000|                  15.0|         18.0|                  20.0|        26033|
F      |             2010|                   4.0|          7.0|                   9.0|        19193|
F      |             2020|                   1.0|          1.0|                   1.0|          657|
M      |             1930|                  83.0|         86.0|                  89.0|         5229|
M      |             1940|                  73.0|         75.0|                  78.0|        13053|
M      |             1950|                  64.0|         66.0|                  68.0|        27479|
M      |             1960|                  54.0|         56.0|                  58.0|        47812|
M      |             1970|                  44.0|         46.0|                  48.0|        75639|
M      |             1980|                  34.0|         37.0|                  39.0|       100687|
M      |             1990|                  25.0|         27.0|                  30.0|        62442|
M      |             2000|                  14.0|         17.0|                  20.0|        24321|
M      |             2010|                   4.0|          7.0|                   9.0|        20445|
M      |             2020|                   1.0|          1.0|                   1.0|          798|


### Tabela exames

Os resultados aqui mostrados estão descritos em `ex_2-exames.sql`.
Definimos uma MV para agilizar consultas sobre dados de Covid, bem como uma função para extrair o último
número (com decimais) de uma string. O motivo para essa função é que, em todos os casos,
os valores de referência para Covid tem como último valor o mínimo para que um exame seja positivo.

As consultas que geram as respostas estão presentes em `ex_2-exames.sql`

- Qual é a maior quantidade de exames solicitados para um único paciente?

id_paciente                        |exames_solicitados|
-----------------------------------|------------------|
5aef7e0-19e2-1e76-0b0a-88f6a97526de|             10271|

- Qual é amédia de exames pedidos para homens e para mulheres?

id_sexo|media_exames       |
-------|-------------------|
F      |60.7046119191906264|
M      |46.6191027309868413|

- Quantos exames de Coronavírus foram solicitados? Para cada idade, mostre os resultados dos exames de Coronavírus

idade_minima|idade_maxima|id_sexo|positivo|negativo|
------------|------------|-------|--------|--------|
9|18|F|157|500|
9|18|M|135|649|
18|27|F|186|817|
18|27|M|202|751|
27|36|F|541|2426|
27|36|M|447|2117|
36|45|F|1215|5468|
36|45|M|936|3707|
45|54|F|1418|4848|
45|54|M|898|3993|
54|63|F|852|2872|
54|63|M|772|2598|
63|72|F|547|2059|
63|72|M|554|1465|
72|81|F|345|1116|
72|81|M|381|937|
81|90|F|177|424|
81|90|M|160|349|
90|99|F|75|238|
90|99|M|45|134|
99|108|F|8|68|
99|108|M|11|28|



### Desfechos

Identificamos os desfechos como óbitos ou altas. Para isso, é necessário remover os acentos da descrição dos
desfechos e buscar a presença de tais palavras no texto.

As consultas estão presentes no arquivo `ex_2-desfechos.sql`.

- Qual é o desfecho para a maioria dos casos registrados?

total_obitos|total_alta|outros|
------------|----------|------|
1036|305629|1262|

- E para cada distribuição por gênero e por década de vida?

decada_nascimento|id_sexo|total_obitos|total_alta|outros|
-----------------|-------|------------|----------|------|
1930|F|71|2969|14|
1940|F|43|4131|16|
1950|F|22|7489|31|
1960|F|14|11339|43|
1970|F|9|17846|59|
1980|F|4|23225|77|
1990|F|1|12684|60|
2000|F|1|2425|19|
2010|F|1|850|5|
2020|F|2|151|2|
1930|M|110|3222|27|
1940|M|70|5817|36|
1950|M|43|9795|54|
1960|M|21|10511|71|
1970|M|9|11663|63|
1980|M|5|13034|73|
1990|M|2|8047|35|
2000|M|1|2302|4|
2010|M|0|1400|5|
2020|M|0|142|11|
