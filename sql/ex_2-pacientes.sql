-- Função que retorna a idade a partir de um ano
-- Consideramos o ano atual como 2021 para agilizar as consultas,
-- Mas é possível obter um resultado similar com DATE_PART('year', CURRENT_DATE)

CREATE FUNCTION idade(integer) RETURNS integer AS
    'SELECT date_part(''year'', current_date) - $1'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;    
 
-- Quantidade de pacientes por sexo
SELECT id_sexo::varchar AS sexo, count(*) FROM dados_processados.pacientes
GROUP BY id_sexo 
UNION SELECT 'Total' AS sexo, count(*) FROM dados_processados.pacientes;


-- Faixas etárias por sexo
WITH bins(n_bins, min_value, max_value) AS (
    SELECT 5 AS n_bins, min(2021 - aa_nascimento) AS min, max(2021 - aa_nascimento) AS max
    FROM dados_processados.pacientes
),
pacientes_buckets AS (
    SELECT WIDTH_BUCKET(
        2021 - aa_nascimento,
        min_value,
        max_value,
        n_bins
    ) AS bucket,
    id_sexo,
    2021 - aa_nascimento AS idade
    FROM dados_processados.pacientes, bins
    WHERE aa_nascimento IS NOT NULL 
)
SELECT
    id_sexo,
    min_value + ((max_value - min_value) / n_bins) * bucket AS idade_minima,
    min_value + ((max_value - min_value) / n_bins) * (1 + bucket) AS idade_maxima,
    percentile_cont(0.25) WITHIN GROUP(ORDER BY idade) AS primeiro_quartil,
    percentile_cont(0.5) WITHIN GROUP(ORDER BY idade) AS mediana,
    percentile_cont(0.75) WITHIN GROUP(ORDER BY idade) AS terceiro_quartil,
    count(*) AS num_pacientes
FROM pacientes_buckets, bins
GROUP BY id_sexo, idade_minima, idade_maxima
ORDER BY id_sexo, idade_minima ASC;



-- Distribuição por década
WITH pacientes_decadas AS (
    SELECT
    aa_nascimento - aa_nascimento % 10 AS decada_nascimento,
    id_sexo,
    2021 - aa_nascimento AS idade
    FROM dados_processados.pacientes
    WHERE aa_nascimento IS NOT NULL 
)
SELECT
    id_sexo,
    decada_nascimento,
    percentile_cont(0.25) WITHIN GROUP(ORDER BY idade) AS idade_primeiro_quartil,
    percentile_cont(0.5) WITHIN GROUP(ORDER BY idade) AS idade_mediana,
    percentile_cont(0.75) WITHIN GROUP(ORDER BY idade) AS idade_terceiro_quartil,
    count(*) AS num_pacientes
FROM pacientes_decadas
GROUP BY id_sexo, decada_nascimento
ORDER BY id_sexo, decada_nascimento ASC;
