-- Dados iniciais: tabelas independentes (cliente e produto)
-- Rodar depois do criar.sql

INSERT INTO cliente (nome, email, cidade) VALUES
('Ana Souza',    'ana@mail.com',    'Goiânia'),
('Bruno Lima',   'bruno@mail.com',  'Anápolis'),
('Carla Mendes', 'carla@mail.com',  'Goiânia'),
('Diego Rocha',  'diego@mail.com',  'Valparaíso de Goiás'),
('Camila Alves', 'camila@mail.com', 'Goiânia');

INSERT INTO produto (nome, preco, estoque) VALUES
('Teclado',        150.00, 10),
('Mouse',           60.00,  3),
('Monitor',        899.90,  2),
('Webcam',         220.00,  0),
('Fone de ouvido',  89.90, 12);

-- Conferência: devem dar 5 e 5
SELECT COUNT(*) FROM cliente;
SELECT COUNT(*) FROM produto;
