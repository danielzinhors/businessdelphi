unit Services.Pedido.Item;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  System.Generics.Collections;

type
  TServicePedidoItem = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisaid_produto: TLargeintField;
    qryPesquisavalor: TFMTBCDField;
    qryPesquisaquantidade: TFMTBCDField;
    qryPesquisanome_produto: TWideStringField;
    qryCadastroid: TLargeintField;
    qryCadastroid_pedido: TLargeintField;
    qryCadastroid_produto: TLargeintField;
    qryCadastrovalor: TFMTBCDField;
    qryCadastroquantidade: TFMTBCDField;
    qryCadastronome_produto: TWideStringField;
  private
    { Private declarations }
  public
    function append(const aJSON: TJSONObject): boolean; override;
    function listAllByPedido(const AParams: TDictionary<string, string>; const AIDPedido: string): TFDQuery;
    function listAll(const aParams: TDictionary<string, string>): TFDQuery; override;
    function getByIdPedido(const aId: string; const aIdPedido: string): TFDQuery;
  end;

var
  ServicePedidoItem: TServicePedidoItem;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicePedidoItem }

function TServicePedidoItem.append(const aJSON: TJSONObject): boolean;
begin
  result := inherited append(AJson);
  qryCadastroid_pedido.visible := false;
end;

function TServicePedidoItem.listAllByPedido(
  const AParams: TDictionary<string, string>;
  const AIDPedido: string): TFDQuery;
begin
  qryPesquisa.paramByName('id_pedido').AsLargeInt := AIdPedido.ToInt64();
  qryRecordCount.paramByName('id_pedido').AsLargeInt := AIdPedido.ToInt64();
  result := listAll(AParams);
end;

function TServicePedidoItem.getByIdPedido(const aId,
  aIdPedido: string): TFDQuery;
begin
  qryCadastro.sql.add('where i.id=:id');
  qryCadastro.sql.add('  and i.id_pedido=:id_pedido');
  qryCadastro.paramByName('id').AsLargeInt := AId.ToInt64();
  qryCadastro.paramByName('id_pedido').AsLargeInt := AIdPedido.ToInt64();
  qryCadastro.open();
  result := qryCadastro;
end;

function TServicePedidoItem.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('id') then
  begin
    qryPesquisa.sql.add('and id=:id');
    qryPesquisa.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
    qryRecordCount.sql.add('and id=:id');
    qryRecordCount.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
  end;
  if aParams.containsKey('id_produto') then
  begin
    qryPesquisa.sql.add('and id_produto=:id_produto');
    qryPesquisa.ParamByName('id_produto').AsLargeInt := aParams.items['id_produto'].toInt64();
    qryRecordCount.sql.add('and id_produto=:id_produto');
    qryRecordCount.ParamByName('id_produto').AsLargeInt := aParams.items['id_produto'].toInt64();
  end;
  if aParams.containsKey('nomeProduto') then
  begin
    qryPesquisa.sql.add('and lower(p.nome) like :nome');
    qryPesquisa.ParamByName('nome').asString := '%' + aParams.items['nomeProduto'].toLower() + '%';
    qryRecordCount.sql.add('and lower(p.nome) like :nome');
    qryRecordCount.ParamByName('nome').asString := '%' + aParams.items['nomeProduto'].toLower() + '%';
  end;
(*  if aParams.containsKey('data') then
  begin
    qryPesquisa.sql.add('and data=:data');
    qryPesquisa.ParamByName('data').asDateTime := strToDateTime(aParams.items['data']);
    qryRecordCount.sql.add('and data=:data');
    qryRecordCount.ParamByName('data').asDateTime := strToDateTime(aParams.items['data']);
  end; *)
  qryPesquisa.sql.add('order by i.id');
  result := inherited listAll(aParams);
end;


end.
