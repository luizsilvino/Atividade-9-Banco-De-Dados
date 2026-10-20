
-- =========================================
-- ATIVIDADE 9 - TABELAS VIRTUAIS
-- BANCO DE DADOS: vendas_online_db
-- =========================================

-- 1. Criar o banco de dados
IF DB_ID('vendas_online_db') IS NULL
    CREATE DATABASE vendas_online_db;
GO

USE vendas_online_db;
GO

-- 2. Criar tabela de clientes
CREATE TABLE clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(120),
    cidade VARCHAR(60),
    ativo BIT DEFAULT 1
);
GO

-- Índice por cidade
CREATE INDEX idx_cidade ON clientes(cidade);
GO

-- 3. Criar tabela de pedidos
CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);
GO

-- Índice por data do pedido
CREATE INDEX idx_data_pedido ON pedidos(data_pedido);
GO

-- 4. Inserir clientes
INSERT INTO clientes (nome, cpf, cidade)
VALUES
('Ana Souza', '11111111111', 'São Paulo'),
('Bruno Lima', '22222222222', 'São Paulo'),
('Carla Nunes', '33333333333', 'Rio de Janeiro'),
('Diego Martins', '44444444444', 'Curitiba'),
('Elisa Rocha', '55555555555', 'São Paulo');
GO

-- 5. Inserir pedidos
INSERT INTO pedidos (id_cliente, valor, data_pedido)
VALUES
(1, 150.00, '2025-01-10'),
(1, 89.90, '2025-02-05'),
(2, 320.00, '2025-03-12'),
(3, 500.00, '2025-04-01'),
(3, 75.50, '2025-04-15'),
(4, 120.00, '2025-05-02');
GO

-- 6. Criar tabela de entregas
CREATE TABLE entregas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    data_entrega DATE,
    status VARCHAR(20) NOT NULL,
    valor_frete DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);
GO

-- Índice por status da entrega
CREATE INDEX idx_status_entrega ON entregas(status);
GO

-- 7. Inserir entregas
INSERT INTO entregas
    (id_pedido, data_entrega, status, valor_frete)
VALUES
(1, '2025-01-13', 'Entregue', 25.00),
(2, '2025-02-07', 'Entregue', 18.50),
(3, '2025-03-20', 'Cancelada', 0.00),
(4, '2025-04-05', 'Entregue', 35.00),
(5, '2025-04-17', 'Pendente', 28.90),
(6, '2025-05-06', 'Entregue', 22.00);
GO

-- 8. VIEW 1: Resumo das entregas
CREATE VIEW vw_resumo_entregas AS
SELECT
    COUNT(CASE WHEN status = 'Entregue'
          THEN 1 END) AS total_entregas_realizadas,
    AVG(valor_frete) AS media_valor_frete
FROM entregas;
GO

-- 9. VIEW 2: Entregas concluídas
CREATE VIEW vw_entregas_concluidas AS
SELECT
    p.id AS id_pedido,
    p.valor AS valor_pedido,
    e.valor_frete,
    e.data_entrega
FROM entregas e
INNER JOIN pedidos p
    ON e.id_pedido = p.id
WHERE e.status = 'Entregue';
GO

-- 10. Consultar a VIEW 1
SELECT * FROM vw_resumo_entregas;
GO

-- 11. Consultar a VIEW 2
SELECT * FROM vw_entregas_concluidas;
GO
