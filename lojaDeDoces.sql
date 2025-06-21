CREATE DATABASE SistemaVendasDB;
GO

USE SistemaVendasDB;
GO
CREATE TABLE Fornecedores (
    idFornecedor INT IDENTITY(1,1) PRIMARY KEY,
    nomeFornecedor NVARCHAR(255) NOT NULL,
    cnpjFornecedor NVARCHAR(18) UNIQUE, 
    contatoFornecedor NVARCHAR(255),
    enderecoFornecedor NVARCHAR(255),
    telefoneFornecedor NVARCHAR(20),
    emailFornecedor NVARCHAR(255) UNIQUE
);
GO

CREATE TABLE Produtos (
    idProduto INT IDENTITY(1,1) PRIMARY KEY,
    nomeProduto NVARCHAR(255) NOT NULL,
    descricaoProduto TEXT,
    precoUnitarioProduto DECIMAL(10, 2) NOT NULL,
    precoDeVendaProduto DECIMAL(10, 2) NOT NULL,
    unidadeMedidaProduto NVARCHAR(20), 
    pesoProduto DECIMAL(10, 3), 
    dimensoesProduto NVARCHAR(50),
    categoriaProduto NVARCHAR(100),
    marcaProduto NVARCHAR(100),
    codigoBarrasProduto NVARCHAR(100) UNIQUE,
    dataCadastroProduto DATETIME DEFAULT GETDATE(),
    statusProduto NVARCHAR(20) NOT NULL CHECK (statusProduto IN ('Ativo', 'Inativo', 'Fora de Linha')),
    origemProduto NVARCHAR(100),
    validadeProduto DATE,
    imagemProdutoURL NVARCHAR(512), 
    ncmProduto NVARCHAR(20),
    garantiaProduto NVARCHAR(100) 
);
GO

CREATE TABLE FornecedoresProdutos (
    idFornecedor INT,
    idProduto INT,
    CONSTRAINT PK_FornecedoresProdutos PRIMARY KEY (idFornecedor, idProduto),
    CONSTRAINT FK_FornecedoresProdutos_Fornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor),
    CONSTRAINT FK_FornecedoresProdutos_Produto FOREIGN KEY (idProduto) REFERENCES Produtos(idProduto)
);
GO

CREATE TABLE Clientes (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    nomeCliente NVARCHAR(255) NOT NULL,
    generoCliente CHAR(1),
    dataNascimentoCliente DATE,
    emailCliente NVARCHAR(255) UNIQUE,
    telefoneCliente NVARCHAR(20),
    enderecoCliente NVARCHAR(255),
    cpfCliente NVARCHAR(14) UNIQUE NOT NULL
);
GO

CREATE TABLE Funcionarios (
    idFuncionario INT IDENTITY(1,1) PRIMARY KEY,
    nomeFuncionario NVARCHAR(255) NOT NULL,
    cpfFuncionario NVARCHAR(14) UNIQUE NOT NULL,
    cargoFuncionario NVARCHAR(100),
    dataAdmissao DATE NOT NULL,
    statusFuncionario NVARCHAR(10) NOT NULL CHECK (statusFuncionario IN ('Ativo', 'Inativo'))
);
GO

CREATE TABLE SessoesCaixa (
    idSessaoCaixa INT IDENTITY(1,1) PRIMARY KEY,
    idCaixa INT NOT NULL, 
    idFuncionarioAbertura INT NOT NULL,
    dataHoraAbertura DATETIME NOT NULL,
    valorAbertura DECIMAL(10, 2) NOT NULL,
    idFuncionarioFechamento INT NULL, 
    dataHoraFechamento DATETIME NULL,
    valorFechamento DECIMAL(10, 2) NULL,
    statusSessao NVARCHAR(20) NOT NULL CHECK (statusSessao IN ('Aberta', 'Fechada', 'Conferida')),
    CONSTRAINT FK_SessoesCaixa_FuncAbertura FOREIGN KEY (idFuncionarioAbertura) REFERENCES Funcionarios(idFuncionario),
    CONSTRAINT FK_SessoesCaixa_FuncFechamento FOREIGN KEY (idFuncionarioFechamento) REFERENCES Funcionarios(idFuncionario)
);
GO

CREATE TABLE Compras (
    idCompra INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NULL, 
    idFuncionario INT NOT NULL,
    idSessaoCaixa INT NOT NULL,
    dataHoraCompra DATETIME DEFAULT GETDATE(),
    valorTotalCompra DECIMAL(10, 2) NOT NULL,
    descontoCompra DECIMAL(10, 2) DEFAULT 0.00,
    statusCompra NVARCHAR(20) NOT NULL CHECK (statusCompra IN ('Finalizada', 'Cancelada')),
    CONSTRAINT FK_Compras_Cliente FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
    CONSTRAINT FK_Compras_Funcionario FOREIGN KEY (idFuncionario) REFERENCES Funcionarios(idFuncionario),
    CONSTRAINT FK_Compras_SessaoCaixa FOREIGN KEY (idSessaoCaixa) REFERENCES SessoesCaixa(idSessaoCaixa)
);
GO

CREATE TABLE ItensCompra (
    idItemCompra INT IDENTITY(1,1) PRIMARY KEY,
    idCompra INT NOT NULL,
    idProduto INT NOT NULL,
    quantidade DECIMAL(10, 3) NOT NULL,
    precoUnitarioVenda DECIMAL(10, 2) NOT NULL,
    valorTotalItem AS (quantidade * precoUnitarioVenda),
    CONSTRAINT FK_ItensCompra_Compra FOREIGN KEY (idCompra) REFERENCES Compras(idCompra),
    CONSTRAINT FK_ItensCompra_Produto FOREIGN KEY (idProduto) REFERENCES Produtos(idProduto)
);
GO

CREATE TABLE TiposPagamento (
    idTipoPagamento INT IDENTITY(1,1) PRIMARY KEY,
    nomePagamento NVARCHAR(50) NOT NULL UNIQUE 
);
GO

CREATE TABLE PagamentosCompra (
    idPagamento INT IDENTITY(1,1) PRIMARY KEY,
    idCompra INT NOT NULL,
    idTipoPagamento INT NOT NULL,
    valorPagamento DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_PagamentosCompra_Compra FOREIGN KEY (idCompra) REFERENCES Compras(idCompra),
    CONSTRAINT FK_PagamentosCompra_TipoPagamento FOREIGN KEY (idTipoPagamento) REFERENCES TiposPagamento(idTipoPagamento)
);
GO

CREATE TABLE Estoque (
    idEstoque INT IDENTITY(1,1) PRIMARY KEY,
    idProduto INT NOT NULL,
    quantidade INT NOT NULL,
    localizacaoEstoque NVARCHAR(100),
    dataUltimaAtualizacao DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Estoque_ProdutoLocalizacao UNIQUE(idProduto, localizacaoEstoque),
    CONSTRAINT FK_Estoque_Produto FOREIGN KEY (idProduto) REFERENCES Produtos(idProduto)
);
GO
