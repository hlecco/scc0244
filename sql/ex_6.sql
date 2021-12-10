-- MV identificando exames de colesterol
-- Similar à dados_processados.hemograma e dados_processados.covid
CREATE MATERIALIZED VIEW dados_processados.exames_colesterol
AS SELECT exames.id_exame,
        CASE
            WHEN exames.de_exame ~~* '%colesterol%' THEN true
            ELSE false
        END AS colesterol
   FROM dados_processados.exames;

-- Verificando os diferentes analitos
SELECT DISTINCT de_exame, de_analito FROM dados_processados.exames
INNER JOIN dados_processados.exames_colesterol
ON exames.id_exame = exames_colesterol.id_exame
WHERE colesterol;

-- Atualizando as diferentes grafias dos analitos
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


-- Para usar crosstab, função que permite fazer pivoteamento de tabelas
CREATE EXTENSION tablefunc;


-- Exibindo os valores para cada analito por atendimento
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
