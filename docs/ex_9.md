## Exercício 9

Para exames de Covid, notou-se que os exames diferentes podem ser identificados com mais
facilidade a partir apenas do analito e do valor de referência.
Usamos apenas os exames cujos valores de referência são numéricos, isto é, podem ser extraídos usando
a função criada anteriormente.

A data do último exame realizado por um determinado paciente pode ser encontrada utilizando a window function
`LAG`, particionando pelo id do paciente e ordenando pela data de coleta.


Verificamos os analitos numéricos com a query
``` sql
SELECT DISTINCT ON (de_analito, de_valor_referencia) de_exame, de_analito, de_resultado, de_valor_referencia
FROM dados_processados.exames e 
INNER JOIN dados_processados.exames_covid ec 
ON e.id_exame = ec.id_exame 
WHERE covid
AND de_resultado IS NOT NULL
```

Utilizamos novamente `crosstab` para pivotear a tabela de resultados, transformando os valores destacados em novas colunas.

Abaixo, exibimos apenas os resultados nos quais é possível verificar uma mudança no diagnóstico:

id_paciente                         |id_atendimento                      |anticorpos_totais_max_cents_60|anti_spike_max_cents_2000|iga_max_cents_|iga_max_cents_80|igg_max_cents_|igg_max_cents_100|igg_max_cents_101|igg_max_cents_1500|igg_max_cents_60|igg_max_cents_80|igg_max_cents_90|igm_max_cents_|igm_max_cents_100|igm_max_cents_110|igm_max_cents_70|igm_max_cents_80|igm_max_cents_90|resultado|dias_desde_resultado_diferente|
------------------------------------|------------------------------------|------------------------------|-------------------------|--------------|----------------|--------------|-----------------|-----------------|------------------|----------------|----------------|----------------|--------------|-----------------|-----------------|----------------|----------------|----------------|---------|------------------------------|
cb99661b-bc28-b67c-ee05-e20d9747daf4|1c1c9840-2b88-bc6f-89c9-07e9d0700faa|                              |                         |              |                |              |                 |                 |                  |                |                |            0.88|              |                 |                 |                |                |            1.49|true     |                             6|
82a4fd12-4c8c-58d1-412d-42687596fd7f|290bc29c-d2c0-8d23-420b-7ca86cebd726|                         189.0|                         |              |                |              |                 |                 |                  |             7.1|                |                |              |                 |                 |                |             4.7|                |true     |                            96|
314bceec-381f-de16-8383-3e360a3a3f39|32d6f954-e14a-2db5-340d-c2dce9600b48|                           6.8|                         |              |                |              |                 |                 |                  |                |             0.2|                |              |                 |              0.5|                |             0.6|                |false    |                            14|
a025afb5-c55d-4c01-7884-4995ae73a35e|569f3e47-a061-8b9f-873c-c4be9f038677|                           0.1|                         |              |                |              |                 |                 |                  |             6.0|             0.1|                |              |                 |              0.7|                |             0.6|                |true     |                            47|
8d9a4809-1291-b4bb-c767-dcf7b6814d91|69630a56-15bf-873a-d71f-4d592ec9b829|                           7.3|                         |              |                |              |                 |                 |                  |                |             1.0|                |              |                 |              0.8|                |                |                |true     |                             5|


Para fazer isso, basta descomentar a última linha da query no arquivo correspondente.
