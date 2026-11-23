-- Alterações com segurança e testes de integridade
-- Regra de ouro: UPDATE e DELETE sempre com WHERE, e sempre com SELECT antes e depois

-- UPDATE: aumentar em 5 unidades o estoque da Webcam (id 4)
SELECT id, nome, estoque FROM produto WHERE id = 4;  -- antes: 0
UPDATE produto SET estoque = estoque + 5 WHERE id = 4;
SELECT id, nome, estoque FROM produto WHERE id = 4;  -- depois: 5

-- Erro 1451: não é possível apagar um cliente que tem pedido.
-- A chave estrangeira pedido.cliente_id usa ON DELETE RESTRICT,
-- então o banco protege o pedido 2, que pertence ao cliente 2.
DELETE FROM cliente WHERE id = 2;

-- Erro 1452: o cliente 6 não existe, então a chave estrangeira recusa o pedido.
INSERT INTO pedido (data, cliente_id) VALUES ('2026-11-15', 6);

-- Erro 1062: a coluna email é UNIQUE e ana@mail.com já está cadastrado.
INSERT INTO cliente (nome, email, cidade) VALUES ('Teste', 'ana@mail.com', 'Goiânia');
