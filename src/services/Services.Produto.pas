unit Services.Produto;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections;

type
  TServiceProduto = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisavalor: TFMTBCDField;
    qryPesquisastatus: TSmallintField;
    qryPesquisaestoque: TFMTBCDField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrovalor: TFMTBCDField;
    qryCadastrostatus: TSmallintField;
    qryCadastroestoque: TFMTBCDField;
  private
    { Private declarations }
  public
     function listAll(const aParams: TDictionary<string, string>): TFDQuery; override;
  end;

var
  ServiceProduto: TServiceProduto;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServiceProduto }

function TServiceProduto.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('id') then
  begin
    qryPesquisa.sql.add('and p.id=:id');
    qryPesquisa.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
    qryRecordCount.sql.add('and p.id=:id');
    qryRecordCount.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
  end;
  if aParams.containsKey('nome') then
  begin
    qryPesquisa.sql.add('and lower(p.nome) like :nome');
    qryPesquisa.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
    qryRecordCount.sql.add('and lower(p.nome) like :nome');
    qryRecordCount.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
  end;
  if aParams.containsKey('status') then
  begin
    qryPesquisa.sql.add('and p.status=:status');
    qryPesquisa.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
    qryRecordCount.sql.add('and p.status=:status');
    qryRecordCount.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
  end;
  qryPesquisa.sql.add('order by p.id');
  result := inherited listAll(aParams);
end;

end.
