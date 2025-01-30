unit uPedidoController;

interface

uses
  FireDAC.Comp.Client, System.Generics.Collections, uPedido, uPedidoProduto;

type
  TPedidoController = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function GravarPedido(APedido: TPedido; AProdutos: TList<TPedidoProduto>): Boolean;
    function CarregarPedido(ANumeroPedido: Integer; out APedido: TPedido; out AProdutos: TList<TPedidoProduto>): Boolean;
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TPedidoController.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TPedidoController.GravarPedido(APedido: TPedido; AProdutos: TList<TPedidoProduto>): Boolean;
var
  Query: TFDQuery;
  Transacao: TFDTransaction;
  PedidoProduto: TPedidoProduto;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  Transacao := TFDTransaction.Create(nil);
  try
    Query.Connection := FConnection;
    Transacao.Connection := FConnection;
    Transacao.StartTransaction;

    try
      // Gravar o pedido
      Query.SQL.Text := 'INSERT INTO Pedidos (DataEmissao, CodigoCliente, ValorTotal) ' +
                        'VALUES (:DataEmissao, :CodigoCliente, :ValorTotal)';
      Query.ParamByName('DataEmissao').AsDate := APedido.DataEmissao;
      Query.ParamByName('CodigoCliente').AsInteger := APedido.CodigoCliente;
      Query.ParamByName('ValorTotal').AsFloat := APedido.ValorTotal;
      Query.ExecSQL;

      // Obter o número do pedido gerado
      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS NumeroPedido';
      Query.Open;
      APedido.NumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;

      // Gravar os produtos do pedido
      for PedidoProduto in AProdutos do
      begin
        Query.SQL.Text := 'INSERT INTO PedidosProdutos (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) ' +
                          'VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, :ValorUnitario, :ValorTotal)';
        Query.ParamByName('NumeroPedido').AsInteger := APedido.NumeroPedido;
        Query.ParamByName('CodigoProduto').AsInteger := PedidoProduto.CodigoProduto;
        Query.ParamByName('Quantidade').AsInteger := PedidoProduto.Quantidade;
        Query.ParamByName('ValorUnitario').AsFloat := PedidoProduto.ValorUnitario;
        Query.ParamByName('ValorTotal').AsFloat := PedidoProduto.ValorTotal;
        Query.ExecSQL;
      end;

      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        raise Exception.Create('Erro ao gravar pedido: ' + E.Message);
      end;
    end;
  finally
    Query.Free;
    Transacao.Free;
  end;
end;

function TPedidoController.CarregarPedido(ANumeroPedido: Integer; out APedido: TPedido; out AProdutos: TList<TPedidoProduto>): Boolean;
var
  Query: TFDQuery;
  PedidoProduto: TPedidoProduto;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // Carregar dados gerais do pedido
    Query.SQL.Text := 'SELECT * FROM Pedidos WHERE NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
    Query.Open;

    if not Query.IsEmpty then
    begin
      APedido := TPedido.Create;
      APedido.NumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;
      APedido.DataEmissao := Query.FieldByName('DataEmissao').AsDateTime;
      APedido.CodigoCliente := Query.FieldByName('CodigoCliente').AsInteger;
      APedido.ValorTotal := Query.FieldByName('ValorTotal').AsFloat;

      // Carregar produtos do pedido
      AProdutos := TList<TPedidoProduto>.Create;
      Query.SQL.Text := 'SELECT * FROM PedidosProdutos WHERE NumeroPedido = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Query.Open;

      while not Query.Eof do
      begin
        PedidoProduto := TPedidoProduto.Create;
        PedidoProduto.NumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;
        PedidoProduto.CodigoProduto := Query.FieldByName('CodigoProduto').AsInteger;
        PedidoProduto.Quantidade := Query.FieldByName('Quantidade').AsInteger;
        PedidoProduto.ValorUnitario := Query.FieldByName('ValorUnitario').AsFloat;
        PedidoProduto.ValorTotal := Query.FieldByName('ValorTotal').AsFloat;
        AProdutos.Add(PedidoProduto);
        Query.Next;
      end;

      Result := True;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoController.CancelarPedido(ANumeroPedido: Integer): Boolean;
var
  Query: TFDQuery;
  Transacao: TFDTransaction;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  Transacao := TFDTransaction.Create(nil);
  try
    Query.Connection := FConnection;
    Transacao.Connection := FConnection;
    Transacao.StartTransaction;

    try
      // Excluir produtos do pedido
      Query.SQL.Text := 'DELETE FROM PedidosProdutos WHERE NumeroPedido = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Query.ExecSQL;

      // Excluir o pedido
      Query.SQL.Text := 'DELETE FROM Pedidos WHERE NumeroPedido = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Query.ExecSQL;

      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        raise Exception.Create('Erro ao cancelar pedido: ' + E.Message);
      end;
    end;
  finally
    Query.Free;
    Transacao.Free;
  end;
end;

end.
