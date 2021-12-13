-- Verificando que SP é o estado com mais pacientes
SELECT DISTINCT ON (id_hospital)
       id_hospital,
       cd_uf,
       count(*) AS numero_pacientes
FROM dados_processados.pacientes
GROUP BY id_hospital, cd_uf
ORDER BY id_hospital, numero_pacientes DESC


-- Percentual de pacientes fora de SP
SELECT id_hospital, sum((cd_uf != 'SP')::integer)::float/count(*) AS percentual_fora_sp
FROM dados_processados.pacientes
WHERE cd_uf != 'UU'
GROUP BY id_hospital
ORDER BY percentual_fora_sp DESC