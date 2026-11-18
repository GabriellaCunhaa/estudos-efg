-- Dados dependentes: pedido (depende de cliente) e item_pedido (depende de pedido e produto)
-- Rodar depois dos dados de clientes e produtos

INSERT INTO pedido (data, cliente_id) VALUES
('2026-10-01', 1),
('2026-10-05', 2),
('2026-10-12', 1),
('2026-10-20', 3),
('2026-10-28', 4),
('2026-11-02', 5),
('2026-11-08', 1),
('2026-11-12', 3);

INSERT INTO item_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 150.00),
(1, 2, 2,  60.00),
(2, 3, 1, 899.90),
(3, 5, 1,  89.90),
(4, 1, 1, 150.00),
(4, 4, 1, 220.00),
(5, 2, 1,  60.00),
(6, 5, 2,  89.90),
(7, 3, 1, 899.90),
(8, 4, 1, 220.00);

-- Conferência: devem dar 5, 5, 8 e 10
SELECT COUNT(*) FROM cliente;
SELECT COUNT(*) FROM produto;
SELECT COUNT(*) FROM pedido;
SELECT COUNT(*) FROM item_pedido;
