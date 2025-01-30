unit uPedido;

interface

uses
  uCliente;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Double;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;

implementation

end.
