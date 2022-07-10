unit Services.Pedido;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections;

type
  TServicePedido = class(TProvidersCadastro)
    qryCadastroid: TLargeintField;
    qryCadastroid_cliente: TLargeintField;
    qryCadastrodata: TSQLTimeStampField;
    qryCadastroid_usuario: TLargeintField;
    qryCadastronome_cliente: TWideStringField;
    qryPesquisaid: TLargeintField;
    qryPesquisaid_cliente: TLargeintField;
    qryPesquisadata: TSQLTimeStampField;
    qryPesquisaid_usuario: TLargeintField;
    qryPesquisanome_cliente: TWideStringField;
    procedure qryCadastroAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
     function listAll(const aParams: TDictionary<string, string>): TFDQuery; override;
     function getById(const aId: string): TFDQuery; override;
  end;

var
  ServicePedido: TServicePedido;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TServicePedido.getById(const aId: string): TFDQuery;
begin
  qryCadastro.sql.add('where p.id=:id');
  qryCadastro.paramByName('id').asLargeInt := aId.toInt64;
  qryCadastro.open();
  result := qryCadastro;
end;

function TServicePedido.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('id') then
  begin
    qryPesquisa.sql.add('and p.id=:id');
    qryPesquisa.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
    qryRecordCount.sql.add('and p.id=:id');
    qryRecordCount.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
  end;
  if aParams.containsKey('idCliente') then
  begin
    qryPesquisa.sql.add('and p.id_cliente=:id_cliente');
    qryPesquisa.ParamByName('id_cliente').AsLargeInt := aParams.items['idCliente'].toInt64();
    qryRecordCount.sql.add('and p.id_cliente=:id_cliente');
    qryRecordCount.ParamByName('id_cliente').AsLargeInt := aParams.items['idCliente'].toInt64();
  end;
  if aParams.containsKey('idUsuario') then
  begin
    qryPesquisa.sql.add('and p.id_usuario=:id_usuario');
    qryPesquisa.ParamByName('id_usuario').AsLargeInt := aParams.items['idUsuario'].toInt64();
    qryRecordCount.sql.add('and p.id_usuario=:id_usuario');
    qryRecordCount.ParamByName('id_usuario').AsLargeInt := aParams.items['idUsuario'].toInt64();
  end;
  if aParams.containsKey('nomeCliente') then
  begin
    qryPesquisa.sql.add('and lower(c.nome) like :nome');
    qryPesquisa.ParamByName('nome').asString := '%' + aParams.items['nomeCliente'].toLower() + '%';
    qryRecordCount.sql.add('and lower(c.nome) like :nome');
    qryRecordCount.ParamByName('nome').asString := '%' + aParams.items['nomeCliente'].toLower() + '%';
  end;
  qryPesquisa.sql.add('order by p.id');
  result := inherited listAll(aParams);
end;

procedure TServicePedido.qryCadastroAfterInsert(DataSet: TDataSet);
begin
  inherited;
  qryCadastrodata.asDateTime := now;
end;

end.
