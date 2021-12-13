## Exercício 3

A ideia da consulta é verificar o percentual de atendimentos cujos pacientes são
de fora do estado onde o hospital se situa.
O local do hospital pode ser obtido, com alguma certeza, a partir do estado onde há mais atendimentos
realizados (embora saibamos que é São Paulo).

Podemos conferir, no entanto:

``` sql
SELECT DISTINCT ON (id_hospital)
       id_hospital,
       cd_uf,
       count(*) AS numero_pacientes
FROM dados_processados.pacientes
GROUP BY id_hospital, cd_uf
ORDER BY id_hospital, numero_pacientes DESC
```

id_hospital|cd_uf|numero_pacientes|
-----------|-----|----------------|
BP         |SP   |           37033|
EI         |SP   |           78921|
FY         |SP   |          424494|
HC         |SP   |           15801|


A partir disso, executa-se:

``` sql
SELECT id_hospital, sum((cd_uf != 'SP')::integer)::float/count(*) AS percentual_fora_sp
FROM dados_processados.pacientes
WHERE cd_uf != 'UU'
GROUP BY id_hospital
ORDER BY percentual_fora_sp DESC
```

id_hospital|percentual_fora_sp |
-----------|-------------------|
FY         | 0.4128721813662775|
HC         |0.07747547874824848|
EI         | 0.0007090671967788|
BP         | 0.0006476509161562|
