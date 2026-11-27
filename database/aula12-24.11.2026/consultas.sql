-- Consultas, alterações e integridade no banco da loja
-- Banco: loja_squad, com os dados da Etapa 2 (5 clientes, 5 produtos, 8 pedidos, 10 itens)
-- Os resultados comentados abaixo consideram o banco logo após os INSERTs,
-- com a Webcam (id 4) ainda com estoque 0.

-- =====================================================================
-- Consultas com SELECT
-- Ordem das cláusulas: WHERE -> ORDER BY -> LIMIT
-- =====================================================================

-- 1. Produtos com preço maior que 100, do mais caro para o mais barato
SELECT * FROM produto WHERE preco > 100 ORDER BY preco DESC;
-- Resultado: 3 linhas
--   3 | Monitor | 899.90 | estoque 2
--   4 | Webcam  | 220.00 | estoque 0
--   1 | Teclado | 150.00 | estoque 10
-- A Webcam aparece mesmo sem estoque, porque o filtro é só pelo preço.

-- 2. Clientes cujo nome começa com C
SELECT * FROM cliente WHERE nome LIKE 'C%';
-- Resultado: 2 linhas
--   3 | Carla Mendes | carla@mail.com  | Goiânia
--   5 | Camila Alves | camila@mail.com | Goiânia
-- O % do LIKE aceita qualquer sequência de caracteres depois do C.

-- 3. Os 3 pedidos mais recentes (id, data e cliente)
SELECT id, data, cliente_id FROM pedido ORDER BY data DESC LIMIT 3;
-- Resultado: 3 linhas
--   8 | 2026-11-12 | cliente 3
--   7 | 2026-11-08 | cliente 1
--   6 | 2026-11-02 | cliente 5

-- 4. Clientes de Goiânia em ordem alfabética
SELECT * FROM cliente WHERE cidade = 'Goiânia' ORDER BY nome;
-- Resultado: 3 linhas
--   1 | Ana Souza    | ana@mail.com
--   5 | Camila Alves | camila@mail.com
--   3 | Carla Mendes | carla@mail.com

-- 5. Produtos sem estoque
SELECT * FROM produto WHERE estoque = 0;
-- Resultado: 1 linha
--   4 | Webcam | 220.00 | estoque 0

-- 6. Pedidos do cliente 1, do mais antigo para o mais recente
SELECT * FROM pedido WHERE cliente_id = 1 ORDER BY data ASC;
-- Resultado: 3 linhas
--   1 | 2026-10-01
--   3 | 2026-10-12
--   7 | 2026-11-08

-- 7. Itens do pedido 1 (produto e quantidade)
SELECT produto_id, quantidade FROM item_pedido WHERE pedido_id = 1;
-- Resultado: 2 linhas
--   produto 1 (Teclado) | quantidade 1
--   produto 2 (Mouse)   | quantidade 2

-- 8. Produtos com estoque menor que 5
SELECT * FROM produto WHERE estoque < 5;
-- Resultado: 3 linhas
--   2 | Mouse   | estoque 3
--   3 | Monitor | estoque 2
--   4 | Webcam  | estoque 0

-- =====================================================================
-- Alterações com segurança
-- Regra de ouro: UPDATE e DELETE sempre com WHERE, e sempre com SELECT antes e depois
-- =====================================================================

-- 9. Aumentar em 5 unidades o estoque da Webcam (id 4)
SELECT id, nome, estoque FROM produto WHERE id = 4;
-- Resultado antes: 4 | Webcam | 0
UPDATE produto SET estoque = estoque + 5 WHERE id = 4;
-- Resultado: 1 linha afetada
SELECT id, nome, estoque FROM produto WHERE id = 4;
-- Resultado depois: 4 | Webcam | 5

-- 10. Tentar apagar o cliente de id 2
DELETE FROM cliente WHERE id = 2;
-- Resultado: erro 1451 (Cannot delete or update a parent row: a foreign key constraint fails)
-- O cliente 2 (Bruno Lima) é dono do pedido 2. A chave estrangeira pedido.cliente_id
-- usa ON DELETE RESTRICT, então o banco não deixa apagar o cliente e deixar o pedido órfão.

-- =====================================================================
-- Testes de integridade
-- =====================================================================

-- 11. Inserir um pedido para um cliente que não existe
INSERT INTO pedido (data, cliente_id) VALUES ('2026-11-15', 6);
-- Resultado: erro 1452 (Cannot add or update a child row: a foreign key constraint fails)
-- Não existe cliente com id 6, e a chave estrangeira só aceita valores
-- que já existem em cliente.id. Nenhuma linha foi inserida.

-- 12. Inserir um cliente com um e-mail que já existe
INSERT INTO cliente (nome, email, cidade) VALUES ('Teste', 'ana@mail.com', 'Goiânia');
-- Resultado: erro 1062 (Duplicate entry 'ana@mail.com' for key 'email')
-- A coluna email foi criada como UNIQUE, porque o e-mail identifica uma única pessoa.
-- Como ana@mail.com já pertence à cliente 1, o banco recusa a repetição.
