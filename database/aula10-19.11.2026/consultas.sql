-- Consultas no banco da loja
-- Ordem das cláusulas: WHERE -> ORDER BY -> LIMIT

-- 1. Produtos com preço maior que 100, do mais caro para o mais barato
SELECT * FROM produto WHERE preco > 100 ORDER BY preco DESC;

-- 2. Clientes cujo nome começa com C
SELECT * FROM cliente WHERE nome LIKE 'C%';

-- 3. Os 3 pedidos mais recentes (id, data e cliente)
SELECT id, data, cliente_id FROM pedido ORDER BY data DESC LIMIT 3;

-- 4. Clientes de Goiânia em ordem alfabética
SELECT * FROM cliente WHERE cidade = 'Goiânia' ORDER BY nome;

-- 5. Produtos sem estoque
SELECT * FROM produto WHERE estoque = 0;

-- 6. Pedidos do cliente 1, do mais antigo para o mais recente
SELECT * FROM pedido WHERE cliente_id = 1 ORDER BY data ASC;

-- 7. Itens do pedido 1 (produto e quantidade)
SELECT produto_id, quantidade FROM item_pedido WHERE pedido_id = 1;

-- 8. Produtos com estoque menor que 5
SELECT * FROM produto WHERE estoque < 5;
