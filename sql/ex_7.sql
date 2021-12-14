-- Verificando quais são os analitos mais comuns

SELECT de_analito, count(*) AS qtd FROM dados_processados.exames e
INNER JOIN dados_processados.exames_hemograma eh
ON e.id_exame = eh.id_exame
WHERE hemograma
GROUP BY de_analito
ORDER BY qtd DESC;

-- Verificando exames mais comuns que são feitos para cada um desses analitos

SELECT de_analito, de_exame, count(*) AS qtd FROM dados_processados.exames e 
INNER JOIN dados_processados.exames_hemograma eh 
ON e.id_exame = eh.id_exame 
WHERE hemograma
AND de_analito = ANY(ARRAY['CHCM', 'Leucocitos', 'Linfocitos', 'Neutrofilos', 'Monocitos', 'Eosinofilos', 'Basofilos'])
GROUP BY de_exame, de_analito
ORDER BY qtd DESC;

-- Removemos exames muito pouco significativos, restando:

SELECT DISTINCT de_exame,
                de_analito
FROM dados_processados.exames e 
INNER JOIN dados_processados.exames_hemograma eh 
ON e.id_exame = eh.id_exame 
WHERE hemograma
AND de_analito = ANY(ARRAY['CHCM', 'Leucocitos', 'Linfocitos', 'Neutrofilos', 'Monocitos', 'Eosinofilos', 'Basofilos'])
AND de_exame = ANY(ARRAY['HEMOGRAMA AUTOMATIZADO, sangue total', 'HEMOGRAMA COMPLETO', 'HEMOGRAMA, sangue total',
                         'Hemograma', 'Hemograma Contagem Auto', 'Hemograma automatizado pré-QT', 'Hemograma com Plaquetas',
                         'Hemograma completo, sangue total', 'Hemograma, pre-quimioterapia, sangue total', 'Hemograma, sangue total']);

-- Tabela de resultados
                         
SELECT * FROM crosstab('
  SELECT id_atendimento,
         concat(de_exame, '', '', de_analito) as exame_analito,
         avg(extract_number(de_resultado)) AS resultado
  FROM dados_processados.exames
  INNER JOIN dados_processados.exames_hemograma
  ON exames_hemograma.id_exame = exames.id_exame
  WHERE hemograma
  AND de_analito = ANY(ARRAY[''CHCM'', ''Leucocitos'', ''Linfocitos'', ''Neutrofilos'', ''Monocitos'', ''Eosinofilos'', ''Basofilos''])
  AND de_exame = ANY(ARRAY[''HEMOGRAMA AUTOMATIZADO, sangue total'', ''HEMOGRAMA COMPLETO'', ''HEMOGRAMA, sangue total'',
                           ''Hemograma'', ''Hemograma Contagem Auto'', ''Hemograma automatizado pré-QT'', ''Hemograma com Plaquetas'',
                           ''Hemograma completo, sangue total'', ''Hemograma, pre-quimioterapia, sangue total'', ''Hemograma, sangue total''])
  GROUP BY id_atendimento, exame_analito',
  $$VALUES 
        ('Hemograma, Basofilos'),
        ('Hemograma, CHCM'),
        ('Hemograma, Eosinofilos'),
        ('Hemograma, Leucocitos'),
        ('Hemograma, Linfocitos'),
        ('Hemograma, Monocitos'),
        ('Hemograma, Neutrofilos'),
        ('Hemograma automatizado pré-QT, Basofilos'),
        ('Hemograma automatizado pré-QT, CHCM'),
        ('Hemograma automatizado pré-QT, Eosinofilos'),
        ('Hemograma automatizado pré-QT, Leucocitos'),
        ('Hemograma automatizado pré-QT, Linfocitos'),
        ('Hemograma automatizado pré-QT, Monocitos'),
        ('Hemograma automatizado pré-QT, Neutrofilos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Basofilos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, CHCM'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Eosinofilos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Leucocitos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Linfocitos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Monocitos'),
        ('HEMOGRAMA AUTOMATIZADO, sangue total, Neutrofilos'),
        ('Hemograma com Plaquetas, CHCM'),
        ('Hemograma com Plaquetas, Leucocitos'),
        ('HEMOGRAMA COMPLETO, Basofilos'),
        ('HEMOGRAMA COMPLETO, CHCM'),
        ('HEMOGRAMA COMPLETO, Eosinofilos'),
        ('HEMOGRAMA COMPLETO, Leucocitos'),
        ('HEMOGRAMA COMPLETO, Linfocitos'),
        ('HEMOGRAMA COMPLETO, Monocitos'),
        ('HEMOGRAMA COMPLETO, Neutrofilos'),
        ('Hemograma completo, sangue total, Basofilos'),
        ('Hemograma completo, sangue total, CHCM'),
        ('Hemograma completo, sangue total, Eosinofilos'),
        ('Hemograma completo, sangue total, Leucocitos'),
        ('Hemograma completo, sangue total, Linfocitos'),
        ('Hemograma completo, sangue total, Monocitos'),
        ('Hemograma completo, sangue total, Neutrofilos'),
        ('Hemograma Contagem Auto, Basofilos'),
        ('Hemograma Contagem Auto, Eosinofilos'),
        ('Hemograma Contagem Auto, Linfocitos'),
        ('Hemograma Contagem Auto, Monocitos'),
        ('Hemograma Contagem Auto, Neutrofilos'),
        ('Hemograma, pre-quimioterapia, sangue total, Basofilos'),
        ('Hemograma, pre-quimioterapia, sangue total, CHCM'),
        ('Hemograma, pre-quimioterapia, sangue total, Eosinofilos'),
        ('Hemograma, pre-quimioterapia, sangue total, Leucocitos'),
        ('Hemograma, pre-quimioterapia, sangue total, Linfocitos'),
        ('Hemograma, pre-quimioterapia, sangue total, Monocitos'),
        ('Hemograma, pre-quimioterapia, sangue total, Neutrofilos'),
        ('Hemograma, sangue total, Basofilos'),
        ('Hemograma, sangue total, CHCM'),
        ('Hemograma, sangue total, Eosinofilos'),
        ('Hemograma, sangue total, Leucocitos'),
        ('Hemograma, sangue total, Linfocitos'),
        ('Hemograma, sangue total, Monocitos'),
        ('Hemograma, sangue total, Neutrofilos'),
        ('HEMOGRAMA, sangue total, Basofilos'),
        ('HEMOGRAMA, sangue total, CHCM'),
        ('HEMOGRAMA, sangue total, Eosinofilos'),
        ('HEMOGRAMA, sangue total, Leucocitos'),
        ('HEMOGRAMA, sangue total, Linfocitos'),
        ('HEMOGRAMA, sangue total, Monocitos'),
        ('HEMOGRAMA, sangue total, Neutrofilos')
  $$
)
AS ct(
  id_atendimento uuid,
  "Hemograma_Basofilos" float,
  "Hemograma_CHCM" float,
  "Hemograma_Eosinofilos" float,
  "Hemograma_Leucocitos" float,
  "Hemograma_Linfocitos" float,
  "Hemograma_Monocitos" float,
  "Hemograma_Neutrofilos" float,
  "Hemograma_automatizado_pré_QT_Basofilos" float,
  "Hemograma_automatizado_pré_QT_CHCM" float,
  "Hemograma_automatizado_pré_QT_Eosinofilos" float,
  "Hemograma_automatizado_pré_QT_Leucocitos" float,
  "Hemograma_automatizado_pré_QT_Linfocitos" float,
  "Hemograma_automatizado_pré_QT_Monocitos" float,
  "Hemograma_automatizado_pré_QT_Neutrofilos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Basofilos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_CHCM" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Eosinofilos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Leucocitos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Linfocitos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Monocitos" float,
  "HEMOGRAMA_AUTOMATIZADO_sangue_total_Neutrofilos" float,
  "Hemograma_com_Plaquetas_CHCM" float,
  "Hemograma_com_Plaquetas_Leucocitos" float,
  "HEMOGRAMA_COMPLETO_Basofilos" float,
  "HEMOGRAMA_COMPLETO_CHCM" float,
  "HEMOGRAMA_COMPLETO_Eosinofilos" float,
  "HEMOGRAMA_COMPLETO_Leucocitos" float,
  "HEMOGRAMA_COMPLETO_Linfocitos" float,
  "HEMOGRAMA_COMPLETO_Monocitos" float,
  "HEMOGRAMA_COMPLETO_Neutrofilos" float,
  "Hemograma_completo_sangue_total_Basofilos" float,
  "Hemograma_completo_sangue_total_CHCM" float,
  "Hemograma_completo_sangue_total_Eosinofilos" float,
  "Hemograma_completo_sangue_total_Leucocitos" float,
  "Hemograma_completo_sangue_total_Linfocitos" float,
  "Hemograma_completo_sangue_total_Monocitos" float,
  "Hemograma_completo_sangue_total_Neutrofilos" float,
  "Hemograma_Contagem_Auto_Basofilos" float,
  "Hemograma_Contagem_Auto_Eosinofilos" float,
  "Hemograma_Contagem_Auto_Linfocitos" float,
  "Hemograma_Contagem_Auto_Monocitos" float,
  "Hemograma_Contagem_Auto_Neutrofilos" float,
  "Hemograma_pre_quimioterapia_sangue_total_Basofilos" float,
  "Hemograma_pre_quimioterapia_sangue_total_CHCM" float,
  "Hemograma_pre_quimioterapia_sangue_total_Eosinofilos" float,
  "Hemograma_pre_quimioterapia_sangue_total_Leucocitos" float,
  "Hemograma_pre_quimioterapia_sangue_total_Linfocitos" float,
  "Hemograma_pre_quimioterapia_sangue_total_Monocitos" float,
  "Hemograma_pre_quimioterapia_sangue_total_Neutrofilos" float,
  "Hemograma_sangue_total_Basofilos" float,
  "Hemograma_sangue_total_CHCM" float,
  "Hemograma_sangue_total_Eosinofilos" float,
  "Hemograma_sangue_total_Leucocitos" float,
  "Hemograma_sangue_total_Linfocitos" float,
  "Hemograma_sangue_total_Monocitos" float,
  "Hemograma_sangue_total_Neutrofilos" float,
  "HEMOGRAMA_sangue_total_Basofilos" float,
  "HEMOGRAMA_sangue_total_CHCM" float,
  "HEMOGRAMA_sangue_total_Eosinofilos" float,
  "HEMOGRAMA_sangue_total_Leucocitos" float,
  "HEMOGRAMA_sangue_total_Linfocitos" float,
  "HEMOGRAMA_sangue_total_Monocitos" float,
  "HEMOGRAMA_sangue_total_Neutrofilos" float
);
