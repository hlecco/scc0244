-- Usamos a VIEW já criada no exercício 2

SELECT id_paciente,
       id_atendimento,
       de_resultado AS de_resultado_bruto,
       de_valor_referencia,
       (CASE WHEN resultado = TRUE THEN 'Positivo' WHEN resultado = FALSE THEN 'Negativo' ELSE NULL END) AS de_resultado
FROM dados_processados.exames e
INNER JOIN dados_processados.exames_covid_resultado ecr
ON e.id_exame = ecr.id_exame
