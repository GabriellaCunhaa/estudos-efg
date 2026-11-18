# Revisão de SQL

| Comando | Para que serve | Exemplo |
|---|---|---|
| CREATE / ALTER / DROP | Criar, mudar ou apagar estruturas (DDL) | `ALTER TABLE produto ADD descricao VARCHAR(200);` |
| INSERT | Incluir registros, sempre com os nomes das colunas | `INSERT INTO cliente (nome, email) VALUES ('Ana', 'ana@mail.com');` |
| SELECT | Consultar com filtros e ordenação | `SELECT * FROM produto WHERE preco > 100 ORDER BY preco DESC LIMIT 3;` |
| UPDATE | Alterar registros, sempre com WHERE | `UPDATE produto SET estoque = 5 WHERE id = 4;` |
| DELETE | Apagar registros, sempre com WHERE | `DELETE FROM cliente WHERE id = 9;` |

**Ordem das cláusulas:** WHERE → ORDER BY → LIMIT.

**Ordem dos INSERTs:** primeiro as tabelas sem chave estrangeira (`cliente`, `produto`), depois as que dependem delas (`pedido`, `item_pedido`).

**Regra de ouro:** rodar um SELECT antes e outro depois de todo UPDATE e DELETE. Sem WHERE, o comando altera ou apaga a tabela inteira.

**Integridade referencial:** a chave estrangeira impede apontar para um registro que não existe e impede apagar um registro que ainda é usado por outra tabela (quando a regra é `ON DELETE RESTRICT`).
