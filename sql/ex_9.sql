-- Descobrindo analitos para os quais a medição é um valor numérico

SELECT DISTINCT ON (de_analito, de_valor_referencia) de_exame, de_analito, de_resultado, de_valor_referencia
FROM dados_processados.exames e 
INNER JOIN dados_processados.exames_covid ec 
ON e.id_exame = ec.id_exame 
WHERE covid
AND de_resultado IS NOT NULL

-- Vamos agrupar os exames por aqueles que tiverem os mesmos valores de referência
-- Essa técnica é melhor que olhar exame / analito para esse caso

WITH covid_resultados_numeros AS (
SELECT * FROM crosstab('
  SELECT id_paciente,
         id_atendimento,
         concat(analito, ''_max_cents_'', (valor_referencia*100)::integer::text) AS analito_referencia,
         resultado
  FROM (
    SELECT id_paciente,
           id_atendimento,
           (CASE
              WHEN de_analito ILIKE ''%igg%'' THEN ''igg'' 
              WHEN de_analito ILIKE ''%igm%'' THEN ''igm''
              WHEN de_analito ILIKE ''%iga%'' THEN ''iga''
              WHEN de_analito ILIKE ''%totais%'' THEN ''anticorpos_totais''
              WHEN de_analito ILIKE ''%anti-spike%'' THEN ''anti_spike''
              ELSE NULL
           END) AS analito,
           avg(extract_number(de_resultado)) AS resultado,
           extract_number(de_valor_referencia) AS valor_referencia
    FROM dados_processados.exames e 
    INNER JOIN dados_processados.exames_covid ec 
    ON e.id_exame = ec.id_exame
    WHERE covid
    AND de_analito = ANY(ARRAY[
      ''Covid 19, Anticorpos IgG, Quimiolumin.-Indice'',
      ''Covid 19, Anticorpos IgM, Quimiolumin.-Indice'',
      ''Covid 19, Anticorpos Totais, Eletroquim-Indic'',
      ''Covid 19, Anticorpos IgA, Elisa - Indice'',
      ''Covid 19, Anticorpos IgG, Elisa - Indice'',
      ''Covid 19, Anticorpos IgG, indice'',
      ''Covid 19, Anticorpos IgA, indice'',
      ''Covid 19, Anticorpos IgA'',
      ''Covid 19, Anticorpos IgG'',
      ''IgG, COVID19'',
      ''IgA, COVID19:'',
      ''IgM, COVID19'',
      ''Covid 19, Anti-Spike Neutralizantes - Indice'',
      ''CoV2-G (IgG para SARS-CoV2)''
    ])
    AND de_valor_referencia IS NOT NULL
    GROUP BY id_paciente, id_atendimento, analito, valor_referencia
  ) AS analitos_resultados',
  $$ VALUES
      ('anticorpos_totais_max_cents_60'),
      ('anti_spike_max_cents_2000'),
      ('iga_max_cents_'),
      ('iga_max_cents_80'),
      ('igg_max_cents_'),
      ('igg_max_cents_100'),
      ('igg_max_cents_101'),
      ('igg_max_cents_1500'),
      ('igg_max_cents_60'),
      ('igg_max_cents_80'),
      ('igg_max_cents_90'),
      ('igm_max_cents_'),
      ('igm_max_cents_100'),
      ('igm_max_cents_110'),
      ('igm_max_cents_70'),
      ('igm_max_cents_80'),
      ('igm_max_cents_90')
  $$
) AS ct(
  id_paciente uuid,
  id_atendimento uuid,
  anticorpos_totais_max_cents_60 float,
  anti_spike_max_cents_2000 float,
  iga_max_cents_ float,
  iga_max_cents_80 float,
  igg_max_cents_ float,
  igg_max_cents_100 float,
  igg_max_cents_101 float,
  igg_max_cents_1500 float,
  igg_max_cents_60 float,
  igg_max_cents_80 float,
  igg_max_cents_90 float,
  igm_max_cents_ float,
  igm_max_cents_100 float,
  igm_max_cents_110 float,
  igm_max_cents_70 float,
  igm_max_cents_80 float,
  igm_max_cents_90 float
)
),
covid_resultados_intervalos AS (
SELECT id_paciente,
       id_atendimento,
       resultado,
       (CASE
          WHEN resultado != (LAG (resultado) OVER (PARTITION BY id_paciente ORDER BY dt_coleta ASC))
            THEN dt_coleta - (LAG (dt_coleta) OVER (PARTITION BY id_paciente ORDER BY dt_coleta ASC))
          ELSE NULL
       END) AS dias_desde_resultado_diferente
FROM (
  SELECT id_paciente,
         id_atendimento,
         dt_coleta,
         NULLIF(
           sum(CASE
             WHEN resultado THEN 1
             WHEN resultado = FALSE THEN -1
             ELSE 0
           END), 
           0
         ) > 0 AS resultado -- positivo se maioria for positiva
  FROM dados_processados.exames e
  INNER JOIN dados_processados.exames_covid_resultado ecr 
  ON e.id_exame = ecr.id_exame
  GROUP BY id_paciente, id_atendimento, dt_coleta
) AS temp_tabela_agregado_dia
)
SELECT crn.*, cri.resultado, cri.dias_desde_resultado_diferente
FROM covid_resultados_intervalos cri
FULL OUTER JOIN covid_resultados_numeros crn
ON cri.id_atendimento = crn.id_atendimento
WHERE dias_desde_resultado_diferente IS NOT NULL
AND cri.id_paciente = crn.id_paciente;