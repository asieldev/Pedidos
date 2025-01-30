unit uPedidoProduto;

interface

type
  TPedidoProduto = class
  private
    FAutoIncrem: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FQuantidade: Integer;
    FValorUnitario: Double;
    FValorTotal: Double;
  public
    property AutoIncrem: Integer read FAutoIncrem write FAutoIncrem;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;

implementation

end.
