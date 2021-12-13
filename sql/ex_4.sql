-- Pacientes mais novos e mais velhos

-- GROUP BY
SELECT p.cd_municipio,
       p.id_paciente,
       2021 - p.aa_nascimento AS idade,
       idade_mais_novo,
       idade_mais_velho
FROM dados_processados.pacientes AS p
INNER JOIN (
  SELECT cd_municipio,
         min(2021 - aa_nascimento) AS idade_mais_novo,
         max(2021 - aa_nascimento) AS idade_mais_velho
  FROM dados_processados.pacientes
  GROUP BY cd_municipio
) AS idades
ON idades.cd_municipio = p.cd_municipio
AND (
  idade_mais_novo = (2021 - p.aa_nascimento)
  OR idade_mais_velho = (2021 - p.aa_nascimento)
)
ORDER BY cd_municipio, idade;


-- With
WITH idades AS (
  SELECT cd_municipio,
         min(2021 - aa_nascimento) AS idade_mais_novo,
         max(2021 - aa_nascimento) AS idade_mais_velho
  FROM dados_processados.pacientes
  GROUP BY cd_municipio
)
SELECT p.cd_municipio,
       p.id_paciente,
       2021 - p.aa_nascimento AS idade,
       idade_mais_novo,
       idade_mais_velho
FROM dados_processados.pacientes AS p
INNER JOIN idades
ON idades.cd_municipio = p.cd_municipio
WHERE 2021 - aa_nascimento = idade_mais_novo
OR 2021 - aa_nascimento = idade_mais_velho
ORDER BY cd_municipio, idade;


-- Window functions
SELECT cd_municipio,
       id_paciente,
       idade,
       idade_mais_velho,
       idade_mais_novo
FROM (
  SELECT cd_municipio,
         id_paciente,
         2021 - aa_nascimento AS idade,
         max(2021 - aa_nascimento) OVER (PARTITION BY cd_municipio) AS idade_mais_velho,
         min(2021 - aa_nascimento) OVER (PARTITION BY cd_municipio) AS idade_mais_novo
  FROM dados_processados.pacientes
) AS idades
WHERE idade = idade_mais_velho
OR idade = idade_mais_novo
ORDER BY cd_municipio, idade;
