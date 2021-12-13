-- Remover acentos da coluna de_analito de dados_processados.exames
UPDATE dados_processados.exames
SET de_analito = dados_processados.unaccent(de_analito);

-- MV identificando quais exames são de hemograma
-- Contém as colunas id_exame e hemograma, com "hemograma" identificando se é
-- um exame de hemograma ou não
-- Para utilizar, dar join na tabela dados_processados.exames em id_exame

CREATE MATERIALIZED VIEW dados_processados.exames_hemograma
AS SELECT exames.id_exame,
        CASE
            WHEN exames.de_exame ~~* '%hemograma%' THEN true
            ELSE false
        END AS hemograma
   FROM dados_processados.exames;
   
-- Verificando os diferentes analitos
-- Precisamos saber quais existem para fazer a atualização
SELECT DISTINCT id_hospital, de_analito
FROM dados_processados.exames
INNER JOIN dados_processados.exames_hemograma
ON exames_hemograma.id_exame = exames.id_exame
WHERE hemograma;


-- Prévia do que será alterado
-- Agrupamos grafias diferentes de certos analitos em apenas uma
SELECT DISTINCT
       de_analito_antigo,
       (CASE
          WHEN de_analito ILIKE 'leucocitos%\%%' THEN 'Percentual de Leucocitos'
          WHEN de_analito ILIKE 'leucocitos%' THEN 'Leucocitos'
          WHEN de_analito ILIKE 'basofilos%\%%' THEN 'Percentual de Basofilos'
          WHEN de_analito ILIKE 'basofilos%' THEN 'Basofilos'
          WHEN de_analito ILIKE 'metamielocitos%\%%' THEN 'Percentual de Metamielocitos'
          WHEN de_analito ILIKE 'metamielocitos%' THEN 'Metamielocitos'
          WHEN de_analito ILIKE 'bastone%tes%\%%' THEN 'Percentual de Bastonetes'
          WHEN de_analito ILIKE 'bastone%tes%' THEN 'Bastonetes'
          WHEN de_analito ILIKE 'eosinofilos%\%%' THEN 'Percentual de Eosinofilos'
          WHEN de_analito ILIKE 'eosinofilos%' THEN 'Eosinofilos'
          WHEN de_analito ILIKE 'leucocitos%\%%' THEN 'Percentual de Leucocitos'
          WHEN de_analito ILIKE 'leucocitos%' THEN 'Leucocitos'
          WHEN de_analito ILIKE 'mieloblastos%\%%' THEN 'Percentual de Mieloblastos'
          WHEN de_analito ILIKE 'mieloblastos%' THEN 'Mieloblastos'
          WHEN de_analito ILIKE 'mielocitos%\%%' THEN 'Percentual de Mielocitos'
          WHEN de_analito ILIKE 'mielocitos%' THEN 'Mielocitos'
          WHEN de_analito ILIKE 'monocitos%\%%' THEN 'Percentual de Monocitos'
          WHEN de_analito ILIKE 'monocitos%' THEN 'Monocitos'
          WHEN de_analito ILIKE 'neutrofilos%\%%' THEN 'Percentual de Neutrofilos'
          WHEN de_analito ILIKE 'neutrofilos%' THEN 'Neutrofilos'
          WHEN de_analito ILIKE 'plasmo%os%\%%' THEN 'Percentual de Plasmocitos'
          WHEN de_analito ILIKE 'plasmo%os%' THEN 'Plasmocitos'
          WHEN de_analito ILIKE 'promielocitos%\%%' THEN 'Percentual de Promielocitos'
          WHEN de_analito ILIKE 'promielocitos%' THEN 'Promielocitos'
          WHEN de_analito ILIKE 'segmentados%\%%' THEN 'Percentual de Segmentados'
          WHEN de_analito ILIKE 'segmentados%' THEN 'Segmentados'
          WHEN de_analito ILIKE 'blastos%\%%' THEN 'Percentual de Blastos'
          WHEN de_analito ILIKE 'blastos%' THEN 'Blastos'
          WHEN de_analito = ANY(ARRAY['Volume Medio Plaquetario', 'Volume plaquetario medio']) THEN 'Volume Medio Plaquetario'
          WHEN de_analito = ANY(ARRAY['CHCM', 'HCM', 'Concentracao de Hemoglobina Corpuscular', 'Hemoglobina Corpuscular Media']) THEN 'CHCM'
          WHEN de_analito = ANY(ARRAY['Observacao Serie Branca', 'Observacao Seria Branca']) THEN 'Observacao Serie Branca'
          WHEN de_analito = ANY(ARRAY['Linfocitos', 'Linfocitos #']) THEN 'Linfocitos'
          ELSE de_analito
        END) AS de_analito_novo
FROM dados_processados.exames
INNER JOIN dados_processados.exames_hemograma
ON exames_hemograma.id_exame = exames.id_exame
WHERE hemograma;



-- Atualizando a tabela
-- Executamos as alterações mostradas acima

UPDATE dados_processados.exames
SET de_analito = (
    CASE
      WHEN de_analito ILIKE 'leucocitos%\%%' THEN 'Percentual de Leucocitos'
      WHEN de_analito ILIKE 'leucocitos%' THEN 'Leucocitos'
      WHEN de_analito ILIKE 'basofilos%\%%' THEN 'Percentual de Basofilos'
      WHEN de_analito ILIKE 'basofilos%' THEN 'Basofilos'
      WHEN de_analito ILIKE 'metamielocitos%\%%' THEN 'Percentual de Metamielocitos'
      WHEN de_analito ILIKE 'metamielocitos%' THEN 'Metamielocitos'
      WHEN de_analito ILIKE 'bastone%tes%\%%' THEN 'Percentual de Bastonetes'
      WHEN de_analito ILIKE 'bastone%tes%' THEN 'Bastonetes'
      WHEN de_analito ILIKE 'eosinofilos%\%%' THEN 'Percentual de Eosinofilos'
      WHEN de_analito ILIKE 'eosinofilos%' THEN 'Eosinofilos'
      WHEN de_analito ILIKE 'leucocitos%\%%' THEN 'Percentual de Leucocitos'
      WHEN de_analito ILIKE 'leucocitos%' THEN 'Leucocitos'
      WHEN de_analito ILIKE 'mieloblastos%\%%' THEN 'Percentual de Mieloblastos'
      WHEN de_analito ILIKE 'mieloblastos%' THEN 'Mieloblastos'
      WHEN de_analito ILIKE 'mielocitos%\%%' THEN 'Percentual de Mielocitos'
      WHEN de_analito ILIKE 'mielocitos%' THEN 'Mielocitos'
      WHEN de_analito ILIKE 'monocitos%\%%' THEN 'Percentual de Monocitos'
      WHEN de_analito ILIKE 'monocitos%' THEN 'Monocitos'
      WHEN de_analito ILIKE 'neutrofilos%\%%' THEN 'Percentual de Neutrofilos'
      WHEN de_analito ILIKE 'neutrofilos%' THEN 'Neutrofilos'
      WHEN de_analito ILIKE 'plasmo%os%\%%' THEN 'Percentual de Plasmocitos'
      WHEN de_analito ILIKE 'plasmo%os%' THEN 'Plasmocitos'
      WHEN de_analito ILIKE 'promielocitos%\%%' THEN 'Percentual de Promielocitos'
      WHEN de_analito ILIKE 'promielocitos%' THEN 'Promielocitos'
      WHEN de_analito ILIKE 'segmentados%\%%' THEN 'Percentual de Segmentados'
      WHEN de_analito ILIKE 'segmentados%' THEN 'Segmentados'
      WHEN de_analito ILIKE 'blastos%\%%' THEN 'Percentual de Blastos'
      WHEN de_analito ILIKE 'blastos%' THEN 'Blastos'
      WHEN de_analito = ANY(ARRAY['Volume Medio Plaquetario', 'Volume plaquetario medio']) THEN 'Volume Medio Plaquetario'
      WHEN de_analito = ANY(ARRAY['CHCM', 'HCM', 'Concentracao de Hemoglobina Corpuscular', 'Hemoglobina Corpuscular Media']) THEN 'CHCM'
      WHEN de_analito = ANY(ARRAY['Observacao Serie Branca', 'Observacao Seria Branca']) THEN 'Observacao Serie Branca'
      WHEN de_analito = ANY(ARRAY['Linfocitos', 'Linfocitos #']) THEN 'Linfocitos'
      ELSE de_analito
    END)
FROM dados_processados.exames_hemograma
WHERE exames.id_exame = exames_hemograma.id_exame
AND hemograma;


-- Exibindo exames realizados por cada hospital
SELECT DISTINCT id_hospital, de_exame, de_analito
FROM dados_processados.exames
INNER JOIN dados_processados.exames_hemograma
ON exames_hemograma.id_exame = exames.id_exame;
WHERE hemograma;
