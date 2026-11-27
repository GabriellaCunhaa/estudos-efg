-- JOIN e agregações no banco da loja
-- Banco: loja_squad, com os dados da Etapa 2
-- Os resultados comentados são os que o meu banco devolveu. Onde eles diferem do
-- resultado esperado no roteiro, a diferença vem dos dados de exemplo usados no roteiro
-- (outros nomes, preços e itens), e não da consulta.

-- =====================================================================
-- Missão 0: conferir o banco (checkpoint)
-- =====================================================================
SELECT
  (SELECT COUNT(*) FROM cliente)     AS clientes,
  (SELECT COUNT(*) FROM produto)     AS produtos,
  (SELECT COUNT(*) FROM pedido)      AS pedidos,
  (SELECT COUNT(*) FROM item_pedido) AS itens;
-- Resultado: 5 | 5 | 8 | 10, igual ao esperado.

-- =====================================================================
-- Missão 1: INNER JOIN (quem comprou o quê, em nível de pedido)
-- =====================================================================
SELECT c.nome, p.id AS pedido, p.data
FROM cliente c
INNER JOIN pedido p ON p.cliente_id = c.id
ORDER BY p.data;
-- Resultado: 8 linhas, uma por pedido, ordenadas pela data
--   Ana Souza    | 1 | 2026-10-01
--   Bruno Lima   | 2 | 2026-10-05
--   Ana Souza    | 3 | 2026-10-12
--   Carla Mendes | 4 | 2026-10-20
--   Diego Rocha  | 5 | 2026-10-28
--   Camila Alves | 6 | 2026-11-02
--   Ana Souza    | 7 | 2026-11-08
--   Carla Mendes | 8 | 2026-11-12
--
-- 1. Por que a condição é p.cliente_id = c.id, e não p.id = c.id?
--    Porque o que liga as duas tabelas é a chave estrangeira: pedido.cliente_id guarda
--    o id do cliente dono do pedido. p.id é o número do próprio pedido, então comparar
--    p.id com c.id juntaria o pedido 1 com o cliente 1, o pedido 2 com o cliente 2 e
--    assim por diante, por coincidência de número, e não por quem fez a compra.
--
-- 2. Trocando INNER JOIN por LEFT JOIN, o número de linhas muda?
--    Não, continua com 8 linhas. O LEFT JOIN só acrescentaria linhas para clientes sem
--    nenhum pedido (com pedido e data NULL), e no meu banco todos os 5 clientes têm
--    pelo menos um pedido.

-- =====================================================================
-- Missão 2: JOIN de três tabelas (quais produtos tem o pedido 1)
-- =====================================================================
SELECT p.id AS pedido, pr.nome AS produto, ip.quantidade
FROM pedido p
JOIN item_pedido ip ON ip.pedido_id = p.id
JOIN produto pr     ON pr.id = ip.produto_id
WHERE p.id = 1;
-- Resultado: 2 linhas
--   1 | Teclado | 1
--   1 | Mouse   | 2
-- Bate com o esperado: Mouse (quantidade 2) e Teclado (quantidade 1).

-- Desafio: trocar p.id = 1 por p.id = 5
SELECT p.id AS pedido, pr.nome AS produto, ip.quantidade
FROM pedido p
JOIN item_pedido ip ON ip.pedido_id = p.id
JOIN produto pr     ON pr.id = ip.produto_id
WHERE p.id = 5;
-- Resultado: 1 linha
--   5 | Mouse | 1
-- O pedido 5 tem só um produto: 1 unidade de Mouse.

-- =====================================================================
-- Missão 3: LEFT JOIN (o que nunca foi vendido)
-- =====================================================================
SELECT pr.nome
FROM produto pr
LEFT JOIN item_pedido ip ON ip.produto_id = pr.id
WHERE ip.pedido_id IS NULL;
-- Resultado: nenhuma linha (conjunto vazio)
-- No roteiro o esperado é Webcam, mas no meu banco a Webcam foi vendida nos pedidos
-- 4 e 8. Todos os 5 produtos aparecem em pelo menos um item, então não há produto
-- sem venda e a consulta está certa ao voltar vazia.

-- Teste de compreensão: INNER JOIN e sem o WHERE
SELECT pr.nome
FROM produto pr
INNER JOIN item_pedido ip ON ip.produto_id = pr.id;
-- Resultado: 10 linhas, uma por item vendido (cada produto aparece 2 vezes).
-- O que mudou: o INNER JOIN só traz os produtos que têm item, e um produto aparece
-- uma vez para cada item em que foi vendido.
-- Por que o IS NULL encontra o produto não vendido: o LEFT JOIN mantém todos os
-- produtos e preenche as colunas de item_pedido com NULL quando não há venda, então
-- filtrar ip.pedido_id IS NULL deixa só os produtos que nunca entraram em um pedido.

-- =====================================================================
-- Missão 4: GROUP BY (pedidos por cliente)
-- =====================================================================
SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
ORDER BY total_pedidos DESC;
-- Resultado: 5 linhas
--   Ana Souza    | 3
--   Carla Mendes | 2
--   Diego Rocha  | 1
--   Camila Alves | 1
--   Bruno Lima   | 1
-- Bate com o esperado nos totais. No roteiro os dois últimos clientes se chamam
-- Daniel Rocha e Eduarda Melo; no meu banco são Diego Rocha e Camila Alves.
-- Regra: toda coluna do SELECT que não está numa função de agregação precisa
-- estar no GROUP BY.

-- =====================================================================
-- Missão 5: SUM com conta dentro (valor de cada pedido)
-- =====================================================================
SELECT pedido_id, SUM(quantidade * preco_unitario) AS total_pedido
FROM item_pedido
GROUP BY pedido_id
ORDER BY pedido_id;
-- Resultado: 8 linhas
--   pedido 1 = 270.00   (1 x 150.00 + 2 x 60.00)
--   pedido 2 = 899.90
--   pedido 3 =  89.90
--   pedido 4 = 370.00   (1 x 150.00 + 1 x 220.00)
--   pedido 5 =  60.00
--   pedido 6 = 179.80   (2 x 89.90)
--   pedido 7 = 899.90
--   pedido 8 = 220.00
-- Os valores diferem do roteiro porque os preços do meu banco são outros
-- (Teclado 150.00 e Mouse 60.00, em vez de 120 e 50).
--
-- Pergunta: o pedido 5 tem 3 Mouses e 1 Teclado, e 3 x 50 + 1 x 120 = 270?
-- A conta está certa para os dados do roteiro: 150 + 120 = 270. No meu banco o pedido 5
-- tem só 1 Mouse a 60.00, então 1 x 60.00 = 60.00, que é exatamente o que a consulta
-- mostrou. O SUM soma quantidade x preço de cada item do pedido.

-- =====================================================================
-- Missão 6: HAVING (só clientes com mais de um pedido)
-- =====================================================================
SELECT c.nome, COUNT(*) AS pedidos
FROM cliente c
JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
HAVING COUNT(*) > 1;
-- Resultado: 2 linhas
--   Ana Souza    | 3
--   Carla Mendes | 2
-- Bate com o esperado.

-- Desafio: trocar HAVING COUNT(*) > 1 por WHERE COUNT(*) > 1
-- SELECT c.nome, COUNT(*) AS pedidos
-- FROM cliente c
-- JOIN pedido p ON p.cliente_id = c.id
-- WHERE COUNT(*) > 1
-- GROUP BY c.id, c.nome;
-- Resultado: erro 1111 (Invalid use of group function)
-- O WHERE filtra linha por linha, antes de os grupos existirem, e nesse momento
-- ainda não há contagem para comparar. O HAVING filtra depois do GROUP BY, quando
-- cada grupo já tem o seu COUNT, por isso condições com agregação vão no HAVING.
-- (A consulta fica comentada porque dá erro.)

-- =====================================================================
-- Missão 7: faturamento total e média
-- =====================================================================
SELECT SUM(total), AVG(total)
FROM (
  SELECT pedido_id, SUM(quantidade * preco_unitario) AS total
  FROM item_pedido
  GROUP BY pedido_id
) AS t;
-- Resultado: soma 2989.50 | média 373.6875
-- Difere do roteiro (2790 e 348.75) por causa dos preços diferentes. Conferindo:
-- 270 + 899.90 + 89.90 + 370 + 60 + 179.80 + 899.90 + 220 = 2989.50, e 2989.50 / 8 = 373.6875.
--
-- Pergunta: por que a média é a do total de cada pedido, e não a dos preços dos produtos?
-- Porque a subconsulta primeiro transforma a tabela em uma linha por pedido, com o valor
-- total daquele pedido (t.total). O AVG de fora trabalha sobre essas 8 linhas, ou seja,
-- calcula o ticket médio por pedido. A tabela produto nem entra na consulta, e o preço
-- usado é o preco_unitario gravado em cada item, multiplicado pela quantidade.

-- =====================================================================
-- Missão 8 (desafio final): quanto cada cliente gastou
-- =====================================================================
SELECT c.nome, SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente c
JOIN pedido p       ON p.cliente_id = c.id
JOIN item_pedido ip ON ip.pedido_id = p.id
GROUP BY c.id, c.nome
ORDER BY total_gasto DESC;
-- Resultado: 5 linhas
--   Ana Souza    | 1259.80   (pedidos 1, 3 e 7: 270 + 89.90 + 899.90)
--   Bruno Lima   |  899.90   (pedido 2)
--   Carla Mendes |  590.00   (pedidos 4 e 8: 370 + 220)
--   Camila Alves |  179.80   (pedido 6)
--   Diego Rocha  |   60.00   (pedido 5)
-- A soma dos cinco dá 2989.50, o mesmo faturamento total da missão 7.
-- Ana Souza continua em primeiro, como no roteiro; os outros valores mudam por causa
-- dos dados diferentes.
