## Exercício 6

Para os exames de colesterol, fazemos o mesmo processo de hemograma, criando uma
MV `dados_processados.exames_hemograma` para agilizar as consultas.

Em seguida, listam-se as diferentes grafias dos analitos:

``` sql
SELECT DISTINCT de_exame, de_analito FROM dados_processados.exames
INNER JOIN dados_processados.exames_colesterol
ON exames.id_exame = exames_colesterol.id_exame
WHERE colesterol;
```

E assim, faz-se uma transação para padronizá-las:

``` sql
UPDATE dados_processados.exames
SET de_analito = (
    CASE
      WHEN de_analito = 'COLESTEROL' THEN 'Colesterol'
      WHEN de_analito ILIKE 'colesterol%nao%hdl%' THEN 'Colesterol nao HDL'
      WHEN de_analito ILIKE 'hdl%-%colesterol' THEN 'HDL Colesterol'
      WHEN de_analito ILIKE 'ldl%colesterol' THEN 'LDL Colesterol'
      WHEN de_analito ILIKE 'v%colesterol' THEN 'VLDL Colesterol'
      ELSE de_analito
    END)
FROM dados_processados.exames_colesterol
WHERE exames.id_exame = exames_colesterol.id_exame
AND colesterol;
```


Usamos `crosstab` para exibir cada analito em uma coluna separada:

``` sql
SELECT * FROM crosstab('
  SELECT id_atendimento, de_analito, avg(extract_number(de_resultado)) AS resultado
  FROM dados_processados.exames
  INNER JOIN dados_processados.exames_colesterol
  ON exames_colesterol.id_exame = exames.id_exame
  WHERE colesterol
  GROUP BY id_atendimento, de_analito',
  $$VALUES ('Colesterol nao HDL'), ('LDL Colesterol'), ('HDL Colesterol'), ('VLDL Colesterol'), ('Triglicerides'), ('Colesterol total')$$)
AS ct(
  id_atendimento uuid,
  colesterol_nao_hdl float,
  ldl_colesterol float,
  hdl_colesterol float,
  vldl_colesterol float,
  triglicerides float,
  colesterol_total float
)
```

id_atendimento                      |colesterol_nao_hdl|ldl_colesterol|hdl_colesterol|vldl_colesterol|triglicerides|colesterol_total|
------------------------------------|------------------|--------------|--------------|---------------|-------------|----------------|
00000000-0000-0000-0062-b85e39974b43|                  |          88.0|          26.0|           33.0|        250.0|           147.0|
00000000-0000-0000-0504-e5d090a2b92c|                  |          68.0|          40.0|           29.0|        195.0|           124.0|
00000000-0000-0000-0c0f-17e64aff561f|                  |          63.0|          22.0|           28.0|        215.0|           113.0|
00000000-0000-0000-75b4-0c7d935f9cda|                  |          36.0|          38.0|           14.0|         68.0|            88.0|
00000000-0000-0000-7ad9-9297e77c11b5|                  |         117.0|          27.0|           46.0|        321.0|           190.0|
00000000-0000-0000-912a-023f806ffa3b|                  |          73.0|          34.0|           20.0|        106.0|           133.0|
00000000-0000-0000-b588-8a1a954c5f5b|                  |          87.0|          34.0|           24.0|        137.0|           145.0|
00000000-0000-0000-f175-30f05bee7912|                  |          65.0|          52.0|           14.0|         86.0|           124.0|
00000000-0000-0000-f284-aaaaf84a1953|                  |          28.0|          31.0|           20.0|        121.0|            79.0|
00000000-0000-0000-faf6-f750ba110901|                  |          89.0|          57.0|           26.0|        107.0|           167.0|
00000000-0000-0000-fda3-8489cdb19547|                  |         104.0|          48.0|           17.0|         82.0|           169.0|
00000000-0000-0000-fedb-db9722b60fe3|                  |          24.0|          28.0|           23.0|        142.0|            72.0|
0000205c-63fb-43c0-7154-94d77b78e4aa|             159.0|         141.0|          62.0|           18.0|             |           221.0|
00003470-2c58-dd6f-6136-c7a74e4aebdb|              48.0|          38.0|          59.0|           10.0|             |           107.0|
00003ccf-4b9f-bd5b-3669-5ce2fc12450b|                  |              |          60.0|               |             |           176.0|
00006ad9-6115-0584-77f5-58bba417e77e|              41.0|          31.0|          69.0|           10.0|             |           110.0|
00006c6d-b602-194b-9680-167bf83cdddd|              65.0|          52.0|          53.0|           13.0|             |           118.0|
00007eb6-319e-ac74-8930-958a09d5ade0|              97.0|          78.0|          48.0|           19.0|             |           145.0|
0000a888-59e2-cd2f-ef5c-e29588f8c9cd|              80.0|          66.0|          68.0|           14.0|             |           148.0|
0000ab95-38a2-e7b2-e25d-7754252605be|             133.0|         113.0|          67.0|           20.0|             |           200.0|
