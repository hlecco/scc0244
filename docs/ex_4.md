### Exercício 4

### Subconsulta

Usando `GROUP BY` em uma subconsulta, podemos fazer

``` sql
SELECT cd_municipio,
       min(2021 - aa_nascimento) AS idade_mais_novo,
       max(2021 - aa_nascimento) AS idade_mais_velho
FROM dados_processados.pacientes
GROUP BY cd_municipio
```

para descobrir a idade do mais novo e mais velho em cada munícipio e usar em uma
subconsulta fazendo `JOIN` na idade:

``` sql
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
```


### CTE

Outra possibilidade é usar a mesma construção acima mas mudando a sintaxe de subconsulta para
uma `WITH` query:

``` sql
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
```

### Window functions

Particionando pelo município, podemos fazer a mesma coisa com window functions.
Como window functions não podem ser usadas em cláusulas `WHERE`, precisamos fazer uma subquery:

``` sql
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
```

Em todo caso, a resposta é a mesma:

cd_municipio       |id_paciente                         |idade|idade_mais_velho|idade_mais_novo|
-------------------|------------------------------------|-----|----------------|---------------|
ABREU E LIMA       |39c30a18-779c-641c-9084-857946cc0d86|   26|              44|             26|
ABREU E LIMA       |d13279a0-b11c-848c-06e5-a825a4c171be|   26|              44|             26|
ABREU E LIMA       |ecafc555-2eaa-3df0-121b-75de84334112|   26|              44|             26|
ABREU E LIMA       |f0c0bdf2-702c-86d8-bf13-95305709b414|   26|              44|             26|
ABREU E LIMA       |8085a832-afe6-3116-ffd5-0382ab50c080|   26|              44|             26|
ABREU E LIMA       |8312b901-b54d-4a6b-a5d5-db1f34a0d1d1|   26|              44|             26|
ABREU E LIMA       |b079d71c-5859-1970-dec5-8e14d3098dac|   26|              44|             26|
ABREU E LIMA       |ce56d570-c217-9b4f-a427-c32d2ae0eec6|   44|              44|             26|
ABREU E LIMA       |af90e249-0f5b-a892-f79b-fc383b3a8b5d|   44|              44|             26|
ABREU E LIMA       |78866e63-ee9b-1912-1420-874ff29ba657|   44|              44|             26|
ABREU E LIMA       |c911124f-a546-5d3b-c7c8-d5a9af0b11ea|   44|              44|             26|
ABREU E LIMA       |fed15ec4-48e5-e2ac-1358-f06f4bc48c07|   44|              44|             26|
ABREU E LIMA       |72feae9e-be11-342a-59d9-9c3df30568d1|   44|              44|             26|
ALMIRANTE TAMANDARE|d0af6b52-da5d-a527-c858-7295bc384c76|   23|              59|             23|
ALMIRANTE TAMANDARE|0eb52b00-6bfb-4789-e94d-6416151b22b3|   23|              59|             23|
ALMIRANTE TAMANDARE|1f3102a2-a50f-c29e-bc4b-9c53f04d7ec6|   23|              59|             23|
ALMIRANTE TAMANDARE|9e0f2380-24a3-a621-95f5-eca9b1a791c5|   23|              59|             23|
ALMIRANTE TAMANDARE|5b094669-d99a-0732-0c1c-f790c2958b1c|   23|              59|             23|
ALMIRANTE TAMANDARE|4b561fd2-02ec-b772-d453-0f53568b5415|   23|              59|             23|
ALMIRANTE TAMANDARE|d40adee0-8835-230a-3dd4-4c0180270e16|   59|              59|             23|
ALMIRANTE TAMANDARE|8657c19a-f485-1d62-c388-3d306a9d4569|   59|              59|             23|
ALMIRANTE TAMANDARE|c30cec71-ccc3-15bf-c973-c88cb05b4100|   59|              59|             23|
ALMIRANTE TAMANDARE|f0fe406e-2774-64c9-af76-4de1724ef6c0|   59|              59|             23|
ALMIRANTE TAMANDARE|6be6baeb-5dd8-a7d9-8273-c4b3b64d046d|   59|              59|             23|
ALMIRANTE TAMANDARE|97e7b2fb-9d04-73fb-6435-cb8e8f8f25fe|   59|              59|             23|
ALVORADA           |bc18a83e-c8e0-94bc-fae9-f0303c95b076|   22|              59|             22|
ALVORADA           |a876674a-5fed-2623-d4d3-8e1ca25d9796|   22|              59|             22|
ALVORADA           |4b8dd3dc-314e-5c4e-b07c-332e776b8223|   22|              59|             22|
ALVORADA           |86b3f168-5d16-a6ae-c359-22f8bbd8c8b5|   22|              59|             22|
ALVORADA           |95ff5d31-0411-3d0d-24a9-54318d25f829|   22|              59|             22|

Mais de um paciente aparece por cidade porque múltiplos pacientes têm as mesmas idades.
