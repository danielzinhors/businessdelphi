unit Providers.Cadastro;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Json, System.Generics.Collections,
  FireDAC.VCLUI.Wait;

type
  TProvidersCadastro = class(TProvidersConnection)
    qryPesquisa: TFDQuery;
    qryRecordCount: TFDQuery;
    qryCadastro: TFDQuery;
    qryRecordCountCOUNT: TLargeintField;
  private
    { Private declarations }
  public
    constructor Create(); reintroduce;
     function append(const aJSON: TJSONObject): boolean; virtual;
     function update(const aJSON: TJSONObject): boolean; virtual;
     function delete(): boolean; virtual;
     function listAll(const aParams: TDictionary<string, string>): TFDQuery; virtual;
     function getById(const aId: string): TFDQuery; virtual;
     function getRecordCount(): int64; virtual;
  end;

var
  ProvidersCadastro: TProvidersCadastro;

implementation

uses
  DataSet.Serialize;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProvidersCadastro }

constructor TProvidersCadastro.Create();
begin
  inherited create(nil);
end;

function TProvidersCadastro.append(const aJSON: TJSONObject): boolean;
begin
  qryCadastro.sql.add('where 1<>1');
  qryCadastro.open();
  qryCadastro.loadFromJSON(aJSON, false); //false não destroy a instancia do json
  result := qryCadastro.applyUpdates(0) = 0;
end;

function TProvidersCadastro.delete(): boolean;
begin
  qryCadastro.delete;
  result := qryCadastro.applyUpdates(0) = 0;
end;

function TProvidersCadastro.getById(const aId: string): TFDQuery;
begin
  qryCadastro.sql.add('where id=:id');
  qryCadastro.paramByName('id').asLargeInt := aId.toInt64;
  qryCadastro.open();
  result := qryCadastro;
end;

function TProvidersCadastro.getRecordCount(): int64;
begin
  qryRecordCount.open();
  result := qryRecordCountCOUNT.asLargeInt;
end;

function TProvidersCadastro.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('limit') then
  begin
    qryPesquisa.fetchOptions.RecsMax := StrToIntDef(aParams.items['limit'], 50);
    qryPesquisa.fetchOptions.RowsetSize := StrToIntDef(aParams.items['limit'], 50);
  end;
  if aParams.ContainsKey('offset') then
    qryPesquisa.fetchOptions.RecsSkip := StrToIntDef(aParams.items['offset'], 0);
  qryPesquisa.open();
  result := qryPesquisa;
end;

function TProvidersCadastro.update(const aJSON: TJSONObject): boolean;
begin
  qryCadastro.mergeFromJSONObject(AJSON, false);  //false não destroy a instancia do json
  result := qryCadastro.applyUpdates(0) = 0;
end;

end.
