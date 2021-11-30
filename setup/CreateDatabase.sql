CREATE TYPE sexo AS ENUM ('F', 'M');
CREATE TYPE pais AS ENUM ('XX', 'BR');
CREATE TYPE uf AS ENUM ('AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO', 'UU');

-- Dados brutos
CREATE SCHEMA dados_brutos;

-- Pacientes
CREATE TABLE dados_brutos.bp_pacientes (
    id_paciente char(16) NOT NULL,
    ic_sexo sexo NOT NULL,
    aa_nascimento char(4) NOT NULL,
    cd_pais pais NOT NULL,
    cd_uf uf NOT NULL,
    cd_municipio text NOT NULL,
    cd_cepreduzido char(5) NOT NULL
);

CREATE TABLE dados_brutos.ei_pacientes (
    id_paciente char(40) NOT NULL,
    ic_sexo sexo NOT NULL,
    aa_nascimento char(4) NOT NULL,
    cd_uf uf NOT NULL,
    cd_municipio text NOT NULL,
    cd_cepreduzido varchar(8) NOT NULL,
    cd_pais pais NOT NULL
);

CREATE TABLE dados_brutos.fy_pacientes (
    id_paciente char(32) NOT NULL,
    ic_sexo sexo NOT NULL,
    aa_nascimento char(4) NOT NULL,
    cd_pais pais NOT NULL,
    cd_uf uf NOT NULL,
    cd_municipio text NOT NULL,
    cd_cepreduzido char(5) NOT NULL
);

CREATE TABLE dados_brutos.hc_pacientes (
    id_paciente char(32) NOT NULL,
    ic_sexo sexo NOT NULL,
    aa_nascimento char(4) NOT NULL,
    cd_pais pais NOT NULL,
    cd_uf uf NOT NULL,
    cd_municipio text NOT NULL,
    cd_cepreduzido char(5) NOT NULL
);

CREATE TABLE dados_brutos.sl_pacientes (
    id_paciente char(32) NOT NULL,
    ic_sexo sexo NOT NULL,
    aa_nascimento char(4) NOT NULL,
    cd_pais pais NOT NULL,
    cd_uf uf NOT NULL,
    cd_municipio text NOT NULL,
    cd_cepreduzido char(5) NOT NULL
);


-- Desfechos
CREATE TABLE dados_brutos.bp_desfechos (
    id_paciente varchar(16) NOT NULL, 
    id_atendimento char(32) NOT NULL,
    dt_atendimento char(10) NOT NULL,
    de_tipo_atendimento text,
    id_clinica integer NOT NULL,
    de_clinica text,
    dt_desfecho char(10),
    de_desfecho text
);

CREATE TABLE dados_brutos.sl_desfechos (
    id_paciente char(32) NOT NULL,
    id_atendimento char(32) NOT NULL,
    dt_atendimento char(10) NOT NULL,
    de_tipo_atendimento text,
    id_clinica integer NOT NULL,
    de_clinica text,
    dt_desfecho char(10),
    de_desfecho text
);


-- Exames
CREATE TABLE dados_brutos.bp_exames (
    id_paciente char(16) NOT NULL,
    id_atendimento char(32) NOT NULL,
    dt_coleta char(10) NOT NULL,
    de_origem varchar(4) NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    cd_unidade text,
    de_valor_referencia text
);

CREATE TABLE dados_brutos.ei_exames (
    id_paciente char(40) NOT NULL,
    dt_coleta char(10) NOT NULL,
    de_origem varchar(4) NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    cd_unidade text,
    de_valor_referencia text
);

CREATE TABLE dados_brutos.fy_exames (
    id_paciente char(32) NOT NULL,
    id_atendimento char(32) NOT NULL,
    dt_coleta char(10) NOT NULL,
    de_origem varchar(4) NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    cd_unidade text,
    de_valor_referencia text
);

CREATE TABLE dados_brutos.hc_exames (
    id_paciente char(32) NOT NULL,
    id_atendimento char(32) NOT NULL,
    dt_coleta char(10) NOT NULL,
    de_origem varchar(4) NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    cd_unidade text,
    de_valor_referencia text
);

CREATE TABLE dados_brutos.sl_exames (
    id_paciente char(32) NOT NULL,
    id_atendimento char(32) NOT NULL,
    dt_coleta char(10) NOT NULL,
    de_origem text NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    cd_unidade text,
    de_valor_referencia text
);


-- Dados processados
CREATE SCHEMA dados_processados;

CREATE TABLE dados_processados.pacientes (
    id_paciente uuid PRIMARY KEY,
    id_sexo sexo NOT NULL,
    aa_nascimento integer,
    cd_pais pais,
    cd_uf uf,
    cd_municipio TEXT,
    cd_cepreduzido char(5),
    id_hospital char(2)
);

CREATE TABLE dados_processados.exames (
    id_paciente uuid NOT NULL,
    id_atendimento uuid,
    dt_coleta date NOT NULL,
    de_exame text,
    de_analito text,
    de_resultado text,
    de_valor_referencia text,
    cd_unidade text,
    id_hospital char(2),
    PRIMARY KEY (id_atendimento, de_exame, de_analito)
);

CREATE TABLE dados_processados.desfechos (
    id_paciente uuid REFERENCES dados_processados.pacientes(id_paciente),
    id_atendimento uuid PRIMARY KEY,
    dt_atendimento date NOT NULL,
    de_tipo_atendimento TEXT,
    id_clinica integer,
    dt_desfecho date,
    de_desfecho TEXT,
    id_hospital char(2) NOT NULL
);
