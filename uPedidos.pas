unit uPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Grid, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Phys.MySQL,
  uPedidoController, uCliente, uProduto, uPedido, uPedidoProduto, System.Rtti,
  FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait,
  FMX.ScrollBox, System.Generics.Collections, FireDAC.Comp.UI, FireDAC.DApt,
  System.IniFiles;

const
  COLUMNS_COUNT = 5;

type
  TfrmPedidos = class(TForm)
    pnlTop: TLayout;
    lblCliente: TLabel;
    edtCodigoCliente: TEdit;
    btnCarregarPedido: TButton;
    btnCancelarPedido: TButton;
    pnlCenter: TLayout;
    grdProdutos: TStringGrid;
    btnAdicionarProduto: TButton;
    btnGravarPedido: TButton;
    pnlBottom: TLayout;
    lblTotalPedido: TLabel;
    edtTotalPedido: TEdit;
    FDConnection: TFDConnection;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    FPedidoController: TPedidoController;
    procedure ConfigurarGrid;
    procedure AtualizarTotalPedido;
    procedure LimparTela;
    procedure ConectarBancoDados;
    procedure ExcluirLinhaGrid(ARow: Integer);

  public
    { Public declarations }
  end;

var
  frmPedidos: TfrmPedidos;

implementation

{$R *.fmx}

procedure TfrmPedidos.ConfigurarGrid;
var
  i: Integer;
begin
  // Limpiar columnas existentes
  grdProdutos.ClearColumns;

  // Crear 5 columnas
  for i := 0 to COLUMNS_COUNT-1 do
  begin
    grdProdutos.AddObject(TStringColumn.Create(grdProdutos));
  end;

  // Configurar encabezados
  grdProdutos.RowCount := 1;
  grdProdutos.Cells[0, 0] := 'Código';
  grdProdutos.Cells[1, 0] := 'Descrição';
  grdProdutos.Cells[2, 0] := 'Quantidade';
  grdProdutos.Cells[3, 0] := 'Valor Unitário';
  grdProdutos.Cells[4, 0] := 'Valor Total';
end;


procedure TfrmPedidos.btnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
begin
  try
    NumeroPedido := StrToIntDef(InputBox('Cancelar Pedido', 'Número do Pedido:', ''), 0);

    if NumeroPedido > 0 then
    begin
      if FPedidoController.CancelarPedido(NumeroPedido) then
      begin
        ShowMessage('Pedido cancelado com sucesso!');
        LimparTela; // Opcional: Limpiar la pantalla después de cancelar
      end
      else
      begin
        ShowMessage('Erro ao cancelar pedido.');
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao cancelar pedido: ' + E.Message);
  end;
end;

procedure TfrmPedidos.btnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  Pedido: TPedido;
  Produtos: TList<TPedidoProduto>;
  i: Integer;
begin
  NumeroPedido := StrToIntDef(InputBox('Carregar Pedido', 'Número do Pedido:', ''), 0);

  if NumeroPedido > 0 then
  begin
    if FPedidoController.CarregarPedido(NumeroPedido, Pedido, Produtos) then
    begin
      try
        // Limpiar la pantalla
        LimparTela;

        // Mostrar datos del cliente
        edtCodigoCliente.Text := IntToStr(Pedido.CodigoCliente);

        // Mostrar productos en el grid
        grdProdutos.RowCount := 1; // Resetear grid (solo cabecera)
        for i := 0 to Produtos.Count - 1 do
        begin
          grdProdutos.RowCount := grdProdutos.RowCount + 1;
          grdProdutos.Cells[0, grdProdutos.RowCount - 1] := IntToStr(Produtos[i].CodigoProduto);
          grdProdutos.Cells[1, grdProdutos.RowCount - 1] := 'Produto ' + IntToStr(Produtos[i].CodigoProduto); // Simulación
          grdProdutos.Cells[2, grdProdutos.RowCount - 1] := IntToStr(Produtos[i].Quantidade);
          grdProdutos.Cells[3, grdProdutos.RowCount - 1] := FloatToStr(Produtos[i].ValorUnitario);
          grdProdutos.Cells[4, grdProdutos.RowCount - 1] := FloatToStr(Produtos[i].ValorTotal);
        end;

        // Actualizar total
        edtTotalPedido.Text := FloatToStr(Pedido.ValorTotal);
      finally
        Pedido.Free;
        for i := 0 to Produtos.Count - 1 do
          Produtos[i].Free;
        Produtos.Free;
      end;
    end
    else
    begin
      ShowMessage('Pedido não encontrado.');
    end;
  end;
end;

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  ConectarBancoDados;
  FPedidoController := TPedidoController.Create(FDConnection);
  ConfigurarGrid;
end;

procedure TfrmPedidos.FormDestroy(Sender: TObject);
begin
  FPedidoController.Free;
end;

procedure TfrmPedidos.ConectarBancoDados;
var
  IniFile: TIniFile;
  Usuario: string;
  TiempoEspera: Integer;
  ModoOscuro: Boolean;
begin
  IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    FDConnection.Params.Clear;
    FDConnection.DriverName := 'MySQL';
    FDConnection.Params.Add('Database=' + IniFile.ReadString('Database', 'Database', ''));
    FDConnection.Params.Add('User_Name=' + IniFile.ReadString('Database', 'Username', ''));
    FDConnection.Params.Add('Password=' + IniFile.ReadString('Database', 'Password', ''));
    FDConnection.Params.Add('Server=' + IniFile.ReadString('Database', 'Server', ''));
    FDConnection.Params.Add('Port=' + IniFile.ReadString('Database', 'Port', ''));
    FDConnection.Params.Add('LibraryLocation=' + IniFile.ReadString('Database', 'LibraryPath', ''));
    FDPhysMySQLDriverLink.VendorLib := IniFile.ReadString('Database', 'LibraryPath', '');
    FDConnection.Connected := True;
  finally
    IniFile.Free;
  end;
end;

procedure TfrmPedidos.btnAdicionarProdutoClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario, ValorTotal: Double;
begin
  CodigoProduto := StrToIntDef(InputBox('Adicionar Produto', 'Código do Produto:', ''), 0);
  Quantidade := StrToIntDef(InputBox('Adicionar Produto', 'Quantidade:', ''), 0);
  ValorUnitario := StrToFloatDef(InputBox('Adicionar Produto', 'Valor Unitário:', ''), 0);
  ValorTotal := Quantidade * ValorUnitario;

  // Agregar una nueva fila al grid
  grdProdutos.RowCount := grdProdutos.RowCount + 1;

  // Asegurarse de que las columnas existen antes de acceder a ellas
  if grdProdutos.ColumnCount >= COLUMNS_COUNT then // Verificar que hay 5 columnas
  begin
    grdProdutos.Cells[0, grdProdutos.RowCount - 1] := IntToStr(CodigoProduto);
    grdProdutos.Cells[1, grdProdutos.RowCount - 1] := 'Produto ' + IntToStr(CodigoProduto);
    grdProdutos.Cells[2, grdProdutos.RowCount - 1] := IntToStr(Quantidade);
    grdProdutos.Cells[3, grdProdutos.RowCount - 1] := FloatToStr(ValorUnitario);
    grdProdutos.Cells[4, grdProdutos.RowCount - 1] := FloatToStr(ValorTotal);
  end;

  AtualizarTotalPedido;
end;

procedure TfrmPedidos.btnGravarPedidoClick(Sender: TObject);
var
  Pedido: TPedido;
  Produtos: TList<TPedidoProduto>;
  PedidoProduto: TPedidoProduto;
  i: Integer;
begin
  Pedido := TPedido.Create;
  try
    Pedido.CodigoCliente := StrToIntDef(edtCodigoCliente.Text, 0);
    Pedido.DataEmissao := Now;
    Pedido.ValorTotal := StrToFloatDef(edtTotalPedido.Text, 0);

    Produtos := TList<TPedidoProduto>.Create;
    try
      // Percorrer as linhas do grid (ignorando o cabeçalho)
      for i := 1 to grdProdutos.RowCount - 1 do
      begin
        PedidoProduto := TPedidoProduto.Create;
        PedidoProduto.CodigoProduto := StrToIntDef(grdProdutos.Cells[0, i], 0);
        PedidoProduto.Quantidade := StrToIntDef(grdProdutos.Cells[2, i], 0);
        PedidoProduto.ValorUnitario := StrToFloatDef(grdProdutos.Cells[3, i], 0);
        PedidoProduto.ValorTotal := StrToFloatDef(grdProdutos.Cells[4, i], 0);
        Produtos.Add(PedidoProduto);
      end;

      if FPedidoController.GravarPedido(Pedido, Produtos) then
      begin
        ShowMessage('Pedido gravado com sucesso!');
        LimparTela;
      end
      else
      begin
        ShowMessage('Erro ao gravar pedido.');
      end;
    finally
      for PedidoProduto in Produtos do
        PedidoProduto.Free;
      Produtos.Free;
    end;
  finally
    Pedido.Free;
  end;
end;

procedure TfrmPedidos.AtualizarTotalPedido;
var
  Total: Double;
  i: Integer;
begin
  Total := 0;
  for i := 1 to grdProdutos.RowCount - 1 do // Começa da linha 1 (ignora o cabeçalho)
  begin
    Total := Total + StrToFloatDef(grdProdutos.Cells[COLUMNS_COUNT-1, i], 0);
  end;
  edtTotalPedido.Text := FloatToStr(Total);
end;

procedure TfrmPedidos.LimparTela;
begin
  edtCodigoCliente.Text := '';
  grdProdutos.RowCount := 1; // Mantém apenas a linha de cabeçalho
  edtTotalPedido.Text := '';
end;

procedure TfrmPedidos.ExcluirLinhaGrid(ARow: Integer);
var
  i, j: Integer;
begin
  if (ARow >= 1) and (ARow < grdProdutos.RowCount) then
  begin
    // Mover las filas siguientes hacia arriba
    for i := ARow to grdProdutos.RowCount - 2 do
    begin
      for j := 0 to grdProdutos.ColumnCount - 1 do
      begin
        grdProdutos.Cells[j, i] := grdProdutos.Cells[j, i + 1];
      end;
    end;

    // Reducir el número de filas
    grdProdutos.RowCount := grdProdutos.RowCount - 1;
  end;
end;

procedure TfrmPedidos.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkDelete) and (grdProdutos.IsFocused) then
  begin
    if MessageDlg('Deseja realmente excluir o produto?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      ExcluirLinhaGrid(grdProdutos.Selected);
      AtualizarTotalPedido;
    end;
  end;
end;

procedure TfrmPedidos.edtCodigoClienteChange(Sender: TObject);
begin
  btnCarregarPedido.Enabled := edtCodigoCliente.Text = '';
  btnCancelarPedido.Enabled := edtCodigoCliente.Text = '';
end;

end.
