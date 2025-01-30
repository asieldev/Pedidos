unit uCliente;

interface

type
  TCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

implementation

end.
