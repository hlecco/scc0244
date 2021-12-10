-- Insert CSV files
COPY dados_brutos.bp_pacientes
FROM '/docker-entrypoint-initdb.d/data/bpsp_pacientes_01.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.ei_pacientes
FROM '/docker-entrypoint-initdb.d/data/EINSTEIN_Pacientes_2.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.fy_pacientes
FROM '/docker-entrypoint-initdb.d/data/GrupoFleury_Pacientes_4.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.hc_pacientes
FROM '/docker-entrypoint-initdb.d/data/HC_PACIENTES_1.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.sl_pacientes
FROM '/docker-entrypoint-initdb.d/data/HSL_Pacientes_4.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.bp_desfechos
FROM '/docker-entrypoint-initdb.d/data/bpsp_desfecho_01.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.sl_desfechos
FROM '/docker-entrypoint-initdb.d/data/HSL_Desfechos_4.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.bp_exames
FROM '/docker-entrypoint-initdb.d/data/bpsp_exames_01.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.ei_exames
FROM '/docker-entrypoint-initdb.d/data/EINSTEIN_Exames_2.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.fy_exames
FROM '/docker-entrypoint-initdb.d/data/GrupoFleury_Exames_4.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.hc_exames
FROM '/docker-entrypoint-initdb.d/data/HC_EXAMES_1.csv'
DELIMITER '|'
CSV HEADER;

COPY dados_brutos.sl_exames
FROM '/docker-entrypoint-initdb.d/data/HSL_Exames_4.csv'
DELIMITER '|'
CSV HEADER;

-- Processa dados e salva no schema dados_processados

-- pacientes
INSERT INTO dados_processados.pacientes (
  SELECT DISTINCT ON (id_paciente)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      ic_sexo AS id_sexo,
      (CASE
          WHEN aa_nascimento = 'YYYY' THEN NULL
          WHEN aa_nascimento = 'AAAA' THEN 1930
          ELSE aa_nascimento::integer
       END) AS aa_nascimento,
      NULLIF(cd_pais, 'XX') AS cd_pais,
      cd_uf,
      NULLIF(cd_municipio, 'MMMM') AS cd_municipio,
      NULLIF(cd_cepreduzido, 'CCCC') AS cd_cepreduzido,
      'BP' AS id_hospital
  FROM dados_brutos.bp_pacientes
)
ON CONFLICT (id_paciente) DO UPDATE SET
    id_sexo = EXCLUDED.id_sexo,
    aa_nascimento = EXCLUDED.aa_nascimento,
    cd_pais = EXCLUDED.cd_pais,
    cd_uf = EXCLUDED.cd_uf,
    cd_municipio = EXCLUDED.cd_municipio,
    cd_cepreduzido = EXCLUDED.cd_cepreduzido;                           

TRUNCATE TABLE dados_brutos.bp_pacientes;


INSERT INTO dados_processados.pacientes (
  SELECT DISTINCT ON (id_paciente)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      ic_sexo AS id_sexo,
      (CASE
          WHEN aa_nascimento = 'YYYY' THEN NULL
          WHEN aa_nascimento = 'AAAA' THEN 1930
          ELSE aa_nascimento::integer
       END) AS aa_nascimento,
      NULLIF(cd_pais, 'XX') AS cd_pais,
      cd_uf,
      NULLIF(cd_municipio, 'MMMM') AS cd_municipio,
      NULLIF(LEFT(cd_cepreduzido, 5), 'CCCC') AS cd_cepreduzido,
      'EI' AS id_hospital
  FROM dados_brutos.ei_pacientes
)
ON CONFLICT (id_paciente) DO UPDATE SET
    id_sexo = EXCLUDED.id_sexo,
    aa_nascimento = EXCLUDED.aa_nascimento,
    cd_pais = EXCLUDED.cd_pais,
    cd_uf = EXCLUDED.cd_uf,
    cd_municipio = EXCLUDED.cd_municipio,
    cd_cepreduzido = EXCLUDED.cd_cepreduzido;

TRUNCATE dados_brutos.ei_pacientes;


INSERT INTO dados_processados.pacientes (
  SELECT DISTINCT ON (id_paciente)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      ic_sexo AS id_sexo,
      (CASE
          WHEN aa_nascimento = 'YYYY' THEN NULL
          WHEN aa_nascimento = 'AAAA' THEN 1930
          ELSE aa_nascimento::integer
       END) AS aa_nascimento,
      NULLIF(cd_pais, 'XX') AS cd_pais,
      cd_uf,
      NULLIF(cd_municipio, 'MMMM') AS cd_municipio,
      NULLIF(cd_cepreduzido, 'CCCC') AS cd_cepreduzido,
      'FY' AS id_hospital
  FROM dados_brutos.fy_pacientes
  )
ON CONFLICT (id_paciente) DO UPDATE SET
    id_sexo = EXCLUDED.id_sexo,
    aa_nascimento = EXCLUDED.aa_nascimento,
    cd_pais = EXCLUDED.cd_pais,
    cd_uf = EXCLUDED.cd_uf,
    cd_municipio = EXCLUDED.cd_municipio,
    cd_cepreduzido = EXCLUDED.cd_cepreduzido;

TRUNCATE dados_brutos.fy_pacientes;

INSERT INTO dados_processados.pacientes (
  SELECT DISTINCT ON (id_paciente)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      ic_sexo AS id_sexo,
      (CASE
          WHEN aa_nascimento = 'YYYY' THEN NULL
          WHEN aa_nascimento = 'AAAA' THEN 1930
          ELSE aa_nascimento::integer
       END) AS aa_nascimento,
      NULLIF(cd_pais, 'XX') AS cd_pais,
      cd_uf,
      NULLIF(cd_municipio, 'MMMM') AS cd_municipio,
      NULLIF(cd_cepreduzido, 'CCCC') AS cd_cepreduzido,
      'HC' AS id_hospital
  FROM dados_brutos.hc_pacientes
)
ON CONFLICT (id_paciente) DO UPDATE SET
    id_sexo = EXCLUDED.id_sexo,
    aa_nascimento = EXCLUDED.aa_nascimento,
    cd_pais = EXCLUDED.cd_pais,
    cd_uf = EXCLUDED.cd_uf,
    cd_municipio = EXCLUDED.cd_municipio,
    cd_cepreduzido = EXCLUDED.cd_cepreduzido;

TRUNCATE dados_brutos.hc_pacientes;


INSERT INTO dados_processados.pacientes (
  SELECT DISTINCT ON (id_paciente)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      ic_sexo AS id_sexo,
      (CASE
          WHEN aa_nascimento = 'YYYY' THEN NULL
          WHEN aa_nascimento = 'AAAA' THEN 1930
          ELSE aa_nascimento::integer
       END) AS aa_nascimento,
      NULLIF(cd_pais, 'XX') AS cd_pais,
      cd_uf,
      NULLIF(cd_municipio, 'MMMM') AS cd_municipio,
      NULLIF(cd_cepreduzido, 'CCCC') AS cd_cepreduzido,
      'HC' AS id_hospital
  FROM dados_brutos.sl_pacientes
  )
ON CONFLICT (id_paciente) DO UPDATE SET
    id_sexo = EXCLUDED.id_sexo,
    aa_nascimento = EXCLUDED.aa_nascimento,
    cd_pais = EXCLUDED.cd_pais,
    cd_uf = EXCLUDED.cd_uf,
    cd_municipio = EXCLUDED.cd_municipio,
    cd_cepreduzido = EXCLUDED.cd_cepreduzido;                             
 
TRUNCATE dados_brutos.sl_pacientes;

-- exames

INSERT INTO dados_processados.exames (
  id_paciente,
  id_atendimento,
  dt_coleta,
  de_exame,
  de_analito,
  de_resultado,
  de_valor_referencia,
  cd_unidade,
  id_hospital
) (
  SELECT DISTINCT ON (id_atendimento, de_exame, de_analito)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_coleta, 'DD/MM/YYYY') AS dt_coleta,
      de_exame,
      de_analito,
      de_resultado,
      cd_unidade,
      de_valor_referencia,
      'BP' AS id_hospital
  FROM dados_brutos.bp_exames
);

TRUNCATE dados_brutos.bp_exames;

INSERT INTO dados_processados.exames (
  id_paciente,
  id_atendimento,
  dt_coleta,
  de_exame,
  de_analito,
  de_resultado,
  de_valor_referencia,
  cd_unidade,
  id_hospital
) (
  SELECT DISTINCT ON (id_atendimento, de_exame, de_analito)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      md5(random()::TEXT || clock_timestamp()::TEXT)::uuid AS id_atendimento,
      to_date(dt_coleta, 'DD/MM/YYYY') AS dt_coleta,
      de_exame,
      de_analito,
      de_resultado,
      de_valor_referencia,
      cd_unidade,
      'EI' AS id_hospital
  FROM dados_brutos.ei_exames
);

TRUNCATE dados_brutos.ei_exames;


INSERT INTO dados_processados.exames (
  id_paciente,
  id_atendimento,
  dt_coleta,
  de_exame,
  de_analito,
  de_resultado,
  de_valor_referencia,
  cd_unidade,
  id_hospital
) (
  SELECT DISTINCT ON (id_atendimento, de_exame, de_analito)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_coleta, 'DD/MM/YYYY') AS dt_coleta,
      de_exame,
      de_analito,
      de_resultado,
      de_valor_referencia,
      cd_unidade,
      'FY' AS id_hospital
  FROM dados_brutos.fy_exames
);

TRUNCATE dados_brutos.fy_exames;


INSERT INTO dados_processados.exames (
  id_paciente,
  id_atendimento,
  dt_coleta,
  de_exame,
  de_analito,
  de_resultado,
  de_valor_referencia,
  cd_unidade,
  id_hospital
) (
  SELECT DISTINCT ON (id_atendimento, de_exame, de_analito)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_coleta, 'YYYY-MM-DD') AS dt_coleta,
      de_exame,
      de_analito,
      de_resultado,
      de_valor_referencia,
      cd_unidade,
      'HC' AS id_hospital
  FROM dados_brutos.hc_exames
);

TRUNCATE dados_brutos.hc_exames;


INSERT INTO dados_processados.exames (
  id_paciente,
  id_atendimento,
  dt_coleta,
  de_exame,
  de_analito,
  de_resultado,
  de_valor_referencia,
  cd_unidade,
  id_hospital
) (
  SELECT DISTINCT ON (id_atendimento, de_exame, de_analito)
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_coleta, 'DD/MM/YYYY') AS dt_coleta,
      de_exame,
      de_analito,
      de_resultado,
      de_valor_referencia,
      cd_unidade,
      'SL' AS id_hospital
  FROM dados_brutos.sl_exames
);

TRUNCATE dados_brutos.sl_exames;


-- desfechos

INSERT INTO dados_processados.desfechos (
  SELECT
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_atendimento, 'DD/MM/YYYY') AS dt_atendimento,
      de_tipo_atendimento,
      id_clinica,
      to_date(NULLIF(dt_desfecho, 'DDMMAA'), 'DD/MM/YYYY') AS dt_atendimento,
      de_desfecho,
      'BP' AS id_hospital
 FROM dados_brutos.bp_desfechos
 WHERE LPAD(id_paciente, 32, '0')::uuid IN (SELECT id_paciente FROM dados_processados.pacientes)
) ON CONFLICT (id_atendimento) DO UPDATE SET
  id_paciente = EXCLUDED.id_paciente,
  dt_atendimento = EXCLUDED.dt_atendimento,
  de_tipo_atendimento = EXCLUDED.de_tipo_atendimento,
  id_clinica = EXCLUDED.id_clinica,
  dt_desfecho = EXCLUDED.dt_desfecho,
  de_desfecho = EXCLUDED.de_desfecho;
 
TRUNCATE TABLE dados_brutos.bp_desfechos;
 
 
 INSERT INTO dados_processados.desfechos (
  SELECT
      LPAD(id_paciente, 32, '0')::uuid AS id_paciente,
      LPAD(id_atendimento, 32, '0')::uuid AS id_atendimento,
      to_date(dt_atendimento, 'DD/MM/YYYY') AS dt_atendimento,
      de_tipo_atendimento,
      id_clinica,
      to_date(NULLIF(dt_desfecho, 'DDMMAA'), 'DD/MM/YYYY') AS dt_atendimento,
      de_desfecho,
      'SL' AS id_hospital
 FROM dados_brutos.sl_desfechos
 WHERE LPAD(id_paciente, 32, '0')::uuid IN (SELECT id_paciente FROM dados_processados.pacientes)
) ON CONFLICT (id_atendimento) DO UPDATE SET
  id_paciente = EXCLUDED.id_paciente,
  dt_atendimento = EXCLUDED.dt_atendimento,
  de_tipo_atendimento = EXCLUDED.de_tipo_atendimento,
  id_clinica = EXCLUDED.id_clinica,
  dt_desfecho = EXCLUDED.dt_desfecho,
  de_desfecho = EXCLUDED.de_desfecho;

TRUNCATE TABLE dados_brutos.sl_desfechos;
