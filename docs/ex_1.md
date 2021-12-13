## Exercício 1

Para ingerir os dados, foi usado um container Docker do PostgreSQL, na versão 13.
O esquema do banco é definido em `setup/CreateDatabase.sql` e a ingestão dos dados
é feita por `setup/InsertData.sql`.

Para executar, é necessário baixar todos os arquivos disponíveis no repositório
da FAPESP e extraí-los em `/setup/data/`.

Para cada arquivo `csv`, é feita uma tabela onde os dados serão carregados.
Posteriormente, todos os dados serão agregados nas tabelas:
  - `dados_processados.pacientes`
  - `dados_processados.exames`
  - `dados_processados.desfechos`

Após serem carregados e inseridos nas tabelas do schema `dados_processados`,
as tabelas de dados brutos são truncadas, para economizar espaço em disco.

Procediemntos adicionais de limpeza e outras transformações (como remoção de acentos etc.)
Serão feitos posteriormente, conforme a demanda das consultas a serem executadas.

Algumas colunas adicionais estão presentes nas tabelas de dados processados:
  - `id_hospital` identifica o hospital ao qual o dado se refere.
  - `id_exame`, na tabela de exames, é criada para servir como chave primária.

Os procedimentos de limpeza são bem simples, como substituir alguns dados por nulos
e transformar ids em UUID, o que usa consideravelmente menos espaço em disco e acelera
consultas, em comparação a um formato textual.
