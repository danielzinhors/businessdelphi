unit Services.Cliente;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections;

type
  TServiceCliente = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisastatus: TSmallintField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrostatus: TSmallintField;
  private
    { Private declarations }
  public
     function listAll(const aParams: TDictionary<string, string>): TFDQuery; override;
  end;

var
  ServiceCliente: TServiceCliente;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TServiceCliente.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('id') then
  begin
    qryPesquisa.sql.add('and c.id=:id');
    qryPesquisa.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
    qryRecordCount.sql.add('and c.id=:id');
    qryRecordCount.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
  end;
  if aParams.containsKey('nome') then
  begin
    qryPesquisa.sql.add('and lower(c.nome) like :nome');
    qryPesquisa.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
    qryRecordCount.sql.add('and lower(c.nome) like :nome');
    qryRecordCount.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
  end;
  if aParams.containsKey('status') then
  begin
    qryPesquisa.sql.add('and c.status=:status');
    qryPesquisa.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
    qryRecordCount.sql.add('and c.status=:status');
    qryRecordCount.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
  end;
  qryPesquisa.sql.add('order by c.id');
  result := inherited listAll(aParams);
end;

end.
