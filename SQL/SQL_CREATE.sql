-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS pedidos_db;
USE pedidos_db;

-- Tabla Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    Codigo INT PRIMARY KEY AUTO_INCREMENT, -- Clave primaria
    Nome VARCHAR(100) NOT NULL,
    Cidade VARCHAR(100),
    UF CHAR(2)
);

-- Tabla Produtos

CREATE TABLE IF NOT EXISTS Produtos (
    Codigo INT PRIMARY KEY AUTO_INCREMENT, -- Clave primaria
    Descricao VARCHAR(100) NOT NULL,
    PrecoVenda DECIMAL(10, 2) NOT NULL
);

-- Tabla Pedidos (Datos Generales del Pedido)
CREATE TABLE IF NOT EXISTS Pedidos (
    NumeroPedido INT PRIMARY KEY AUTO_INCREMENT, -- Clave primaria
    DataEmissao DATE NOT NULL,
    CodigoCliente INT NOT NULL,
    ValorTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CodigoCliente) REFERENCES Clientes(Codigo) -- Clave foránea
);

-- Tabla PedidosProdutos (Productos del Pedido)
CREATE TABLE IF NOT EXISTS PedidosProdutos (
    AutoIncrem INT PRIMARY KEY AUTO_INCREMENT, -- Clave primaria
    NumeroPedido INT NOT NULL,
    CodigoProduto INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL(10, 2) NOT NULL,
    ValorTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido), -- Clave foránea
    FOREIGN KEY (CodigoProduto) REFERENCES Produtos(Codigo) -- Clave foránea
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_pedidos_codigo_cliente ON Pedidos(CodigoCliente);
CREATE INDEX idx_pedidos_produtos_numero_pedido ON PedidosProdutos(NumeroPedido);
CREATE INDEX idx_pedidos_produtos_codigo_produto ON PedidosProdutos(CodigoProduto);

-- Ajustando Auto Incremento
 -- SHOW CREATE TABLE Clientes;
 -- ALTER TABLE Clientes MODIFY Codigo INT PRIMARY KEY AUTO_INCREMENT;


