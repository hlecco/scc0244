-- Removendo acentos

CREATE EXTENSION unaccent;

UPDATE dados_processados.desfechos
SET de_desfecho = unaccent(de_desfecho);


-- Total óbitos / altas

WITH desfecho_simplificado AS (
  SELECT id_atendimento,
    	 de_desfecho,
         de_desfecho ILIKE '%obito%' AS obito,
         de_desfecho ILIKE '%alta%' AS alta
  FROM dados_processados.desfechos
)
SELECT sum(obito::integer) AS total_obitos,
       sum(alta::integer) AS total_alta,
       sum(1 - (obito OR alta)::integer) AS outros
FROM desfecho_simplificado;

-- Total obitos / altas por década de nascimento

WITH pacientes_decadas AS (
    SELECT id_paciente,
           aa_nascimento - aa_nascimento % 10 AS decada_nascimento,
           id_sexo
    FROM dados_processados.pacientes
    WHERE aa_nascimento IS NOT NULL 
),
desfecho_simplificado AS (
  SELECT id_atendimento,
         id_paciente,
    	 de_desfecho,
         de_desfecho ILIKE '%obito%' AS obito,
         de_desfecho ILIKE '%alta%' AS alta
  FROM dados_processados.desfechos
)
SELECT decada_nascimento,
       id_sexo,
       sum(obito::integer) AS total_obitos,
       sum(alta::integer) AS total_alta,
       sum(1 - (obito OR alta)::integer) AS outros
FROM desfecho_simplificado
INNER JOIN pacientes_decadas
ON desfecho_simplificado.id_paciente = pacientes_decadas.id_paciente
GROUP BY decada_nascimento, id_sexo
ORDER BY id_sexo, decada_nascimento ASC;
