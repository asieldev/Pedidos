-- Insertar clientes
INSERT INTO Clientes (Nome, Cidade, UF) VALUES
('Cliente 1', 'São Paulo', 'SP'),
('Cliente 2', 'Rio de Janeiro', 'RJ'),
('Cliente 3', 'Belo Horizonte', 'MG');

-- Insertar productos
INSERT INTO Produtos (Descricao, PrecoVenda) VALUES
('Produto A', 10.50),
('Produto B', 20.00),
('Produto C', 15.75);

-- Insertar pedidos
INSERT INTO Pedidos (DataEmissao, CodigoCliente, ValorTotal) VALUES
('2023-10-01', 1, 50.00),
('2023-10-02', 2, 100.00);

-- Insertar productos en los pedidos
INSERT INTO PedidosProdutos (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) values
(7, 2, 1, 20.00, 20.00),
(8, 3, 3, 15.75, 47.25);


