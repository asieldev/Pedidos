program ProPedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPedidos in 'uPedidos.pas' {Form1},
  uCliente in 'uCliente.pas',
  uProduto in 'uProduto.pas',
  uPedido in 'uPedido.pas',
  uPedidoProduto in 'uPedidoProduto.pas',
  uPedidoController in 'uPedidoController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPedidos, frmPedidos);
  Application.Run;
end.
