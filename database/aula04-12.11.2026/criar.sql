-- Banco da loja: criação das tabelas
-- Banco: loja_squad (collation utf8mb4_general_ci)
-- Todas as tabelas em InnoDB para que as chaves estrangeiras funcionem

CREATE TABLE cliente (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(100) NOT NULL,
  email     VARCHAR(120) NOT NULL UNIQUE,
  cidade    VARCHAR(60)
) ENGINE=InnoDB;

CREATE TABLE produto (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(100) NOT NULL,
  preco     DECIMAL(10,2) NOT NULL,
  estoque   INT DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE pedido (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  data        DATE NOT NULL DEFAULT (CURRENT_DATE),
  cliente_id  INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
  pedido_id       INT,
  produto_id      INT,
  quantidade      INT NOT NULL,
  preco_unitario  DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (pedido_id, produto_id),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
  FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE RESTRICT
) ENGINE=InnoDB;
