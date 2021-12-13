-- Função para obter a variância de uma coluna a partir de seu nome como texto
CREATE OR REPLACE FUNCTION COLUMN_VARIANCE(column_name varchar,
                                           schema_name varchar,
                                           table_name varchar
                                          ) 
RETURNS float AS $$
DECLARE 
    column_variance float;
BEGIN
    EXECUTE format('SELECT variance(%s) FROM %s.%s', column_name, schema_name, table_name)
    INTO column_variance;
	RETURN column_variance;
EXCEPTION
    WHEN undefined_function THEN RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Preparamos uma consulta para descrever atributos sobre suas colunas
PREPARE describe_table (varchar, varchar) AS
    SELECT
        attname AS coluna,
        null_frac AS percentual_nulos,
        n_distinct AS valores_distintos,
        column_variance(attname::varchar, $1, $2) AS variancia,
        most_common_vals AS valores_mais_comuns
    FROM pg_catalog.pg_stats ps
    WHERE schemaname = $1
    AND tablename = $2;

-- Execução da consulta preparada para cada uma das tabelas
EXECUTE describe_table ('dados_processados', 'pacientes');
EXECUTE describe_table ('dados_processados', 'exames');
EXECUTE describe_table ('dados_processados', 'desfechos');

-- É uma boa prática limpar a consulta preparada após sua execução
DEALLOCATE describe_table;
