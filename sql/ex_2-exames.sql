-- MV identificando quais são os exames de COVID-19
-- Tem as colunas id_exame e covid
-- Para usar, faça um join dessa MV com a tabela de exames

CREATE MATERIALIZED VIEW dados_processados.exames_covid AS (
    SELECT 
        id_exame,
        (CASE WHEN de_analito ILIKE '%covid%' OR de_analito ILIKE '%sars%cov%' THEN TRUE ELSE FALSE END) AS covid
        FROM dados_processados.exames
);

-- Função para extrair último número de uma string

CREATE OR REPLACE FUNCTION extract_number(text) RETURNS float AS
'SELECT REPLACE((regexp_matches($1, ''(\d+\.?,?\d+?)(?!.*\d)''))[1], '','', ''.'')::float;'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

SELECT de_resultado, extract_number(de_resultado) FROM dados_processados.exames TABLESAMPLE SYSTEM (1);


-- Exames solicitados por paciente

SELECT id_paciente, count(*) exames_solicitados FROM dados_processados.exames
GROUP BY id_paciente
ORDER BY exames_solicitados DESC;

-- Média de exames por sexo
WITH exames_pacientes AS (
    SELECT exames.id_paciente, id_sexo, count(*) AS qtd_exames
    FROM dados_processados.exames
    LEFT JOIN dados_processados.pacientes ON pacientes.id_paciente = exames.id_paciente
    GROUP BY exames.id_paciente, id_sexo
)
SELECT id_sexo, avg(qtd_exames) AS media_exames FROM exames_pacientes
GROUP BY id_sexo;


-- View com ids de exames de covid e os respectivos resultados
-- A base de dados mostra que os valores de referência sempre tem como último número
-- o valor máximo para que uma amostra seja não reagente, por isso a função extract_number
-- acima funciona delimitando um valor máximo.
--
-- Em outros casos, buscamos por palavras chaves na descrição do resultado

CREATE OR REPLACE VIEW dados_processados.exames_covid_resultado AS (
  SELECT exames.id_exame,
  COALESCE(
    extract_number(de_resultado) > extract_number(de_valor_referencia),
    (CASE
        WHEN LEFT(dados_processados.unaccent(de_resultado), 100) ILIKE ANY(ARRAY['%nao%', '%negativ%', '%ausen%'])THEN FALSE
        WHEN LEFT(dados_processados.unaccent(de_resultado), 100) ILIKE ANY(ARRAY['%reagente%', '%detectad%']) THEN TRUE
        ELSE NULL
     END)
  ) AS resultado
  FROM dados_processados.exames TABLESAMPLE SYSTEM (1)
  INNER JOIN dados_processados.exames_covid
  ON exames.id_exame = exames_covid.id_exame
  WHERE covid
);


-- Covid por faixas etárias

WITH bins(n_bins, min_value, max_value) AS (
    SELECT 5 AS n_bins, min(2021 - aa_nascimento) AS min_value, max(2021 - aa_nascimento) AS max_value
    FROM dados_processados.pacientes
),
pacientes_buckets AS (
    SELECT WIDTH_BUCKET(
        2021 - aa_nascimento,
        min_value,
        max_value,
        n_bins
    ) AS bucket,
    id_paciente,
    id_sexo,
    2021 - aa_nascimento AS idade
    FROM dados_processados.pacientes, bins
    WHERE aa_nascimento IS NOT NULL 
)
SELECT ecr.id_exame,
       min_value + ((max_value - min_value) / n_bins) * bucket AS idade_minima,
       min_value + ((max_value - min_value) / n_bins) * (1 + bucket) AS idade_maxima,
       idade,
       id_sexo,
       resultado
FROM bins, dados_processados.exames_covid_resultado AS ecr
INNER JOIN dados_processados.exames ON exames.id_exame = ecr.id_exame
INNER JOIN pacientes_buckets pb ON pb.id_paciente = exames.id_paciente


-- Covid por faixas etárias e sexo, agregado

WITH bins(n_bins, min_value, max_value) AS (
    SELECT 10 AS n_bins, min(2021 - aa_nascimento) AS min_value, max(2021 - aa_nascimento) AS max_value
    FROM dados_processados.pacientes
),
pacientes_buckets AS (
    SELECT WIDTH_BUCKET(
        2021 - aa_nascimento,
        min_value,
        max_value,
        n_bins
    ) AS bucket,
    id_paciente,
    id_sexo,
    2021 - aa_nascimento AS idade
    FROM dados_processados.pacientes, bins
    WHERE aa_nascimento IS NOT NULL 
)
SELECT min_value + ((max_value - min_value) / n_bins) * bucket AS idade_minima,
       min_value + ((max_value - min_value) / n_bins) * (1 + bucket) AS idade_maxima,
       id_sexo,
       sum(resultado::integer) AS positivo,
       sum(1 - resultado::integer) AS negativo
FROM bins, dados_processados.exames_covid_resultado AS ecr
INNER JOIN dados_processados.exames ON exames.id_exame = ecr.id_exame
INNER JOIN pacientes_buckets pb ON pb.id_paciente = exames.id_paciente
GROUP BY idade_minima, idade_maxima, id_sexo
