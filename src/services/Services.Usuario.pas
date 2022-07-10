unit Services.Usuario;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections,
  FireDAC.VCLUI.Wait, System.JSON;

type
  TServiceUsuario = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisalogin: TWideStringField;
    qryPesquisastatus: TSmallintField;
    qryPesquisatelefone: TWideStringField;
    qryPesquisasexo: TSmallintField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrologin: TWideStringField;
    qryCadastrosenha: TWideStringField;
    qryCadastrostatus: TSmallintField;
    qryCadastrotelefone: TWideStringField;
    qryCadastrosexo: TSmallintField;
    qryCadastrofoto: TBlobField;
    procedure qryCadastroBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    function listAll(const aParams: TDictionary<string, string>): TFDQuery; override;
    function update(const aJSON: TJSONObject): boolean; override;
    function GetById(const AId: string): TFDQuery; override;
    function Append(const AJson: TJSONObject): Boolean; override;
    function salvarFotoUsuario(const AFoto: TStream): boolean;
    function obterFotoUsuario(): TStream;
  end;

var
  ServiceUsuario: TServiceUsuario;

implementation

uses
  Bcrypt;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TServiceUsuario.Append(const AJson: TJSONObject): Boolean;
begin
  Result := inherited Append(AJson);
  qryCadastrosenha.Visible := False;
end;

function TServiceUsuario.GetById(const AId: string): TFDQuery;
begin
  Result := inherited GetById(AId);
  qryCadastrosenha.Visible := False;
end;

function TServiceUsuario.listAll(const aParams: TDictionary<string, string>): TFDQuery;
begin
  if aParams.containsKey('id') then
  begin
    qryPesquisa.sql.add('and u.id=:id');
    qryPesquisa.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
    qryRecordCount.sql.add('and u.id=:id');
    qryRecordCount.ParamByName('id').AsLargeInt := aParams.items['id'].ToInt64();
  end;
  if aParams.containsKey('nome') then
  begin
    qryPesquisa.sql.add('and lower(u.nome) like :nome');
    qryPesquisa.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
    qryRecordCount.sql.add('and lower(u.nome) like :nome');
    qryRecordCount.ParamByName('nome').asString := '%' + aParams.items['nome'].toLower() + '%';
  end;
  if aParams.containsKey('login') then
  begin
    qryPesquisa.sql.add('and u.login=:login');
    qryPesquisa.ParamByName('login').asString := aParams.items['login'];
    qryRecordCount.sql.add('and u.login=:login');
    qryRecordCount.ParamByName('login').asString := aParams.items['login'];
  end;
  if aParams.containsKey('status') then
  begin
    qryPesquisa.sql.add('and u.status=:status');
    qryPesquisa.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
    qryRecordCount.sql.add('and u.status=:status');
    qryRecordCount.ParamByName('status').AsSmallInt := aParams.items['status'].toInteger();
  end;
   if aParams.containsKey('sexo') then
  begin
    qryPesquisa.sql.add('and u.sexo=:sexo');
    qryPesquisa.ParamByName('sexo').AsSmallInt := aParams.items['sexo'].toInteger();
    qryRecordCount.sql.add('and u.sexo=:sexo');
    qryRecordCount.ParamByName('sexo').AsSmallInt := aParams.items['sexo'].toInteger();
  end;
  if aParams.containsKey('telefone') then
  begin
    qryPesquisa.sql.add('and u.telefone=:telefone');
    qryPesquisa.ParamByName('telefone').asString := aParams.items['telefone'];
    qryRecordCount.sql.add('and u.telefone=:telefone');
    qryRecordCount.ParamByName('telefone').asString := aParams.items['telefone'];
  end;
  qryPesquisa.sql.add('order by u.id');
  result := inherited listAll(aParams);
end;

procedure TServiceUsuario.qryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (qryCadastrosenha.oldValue <> qryCadastrosenha.newValue) and
     (not qryCadastrosenha.asString.trim.isEmpty) then
    qryCadastrosenha.asString := TBcrypt.generateHash(qryCadastrosenha.asString);
end;

function TServiceUsuario.update(const aJSON: TJSONObject): boolean;
begin
  qryCadastrosenha.visible := true;
  result := inherited update(aJson);
end;

function TServiceUsuario.obterFotoUsuario(): TStream;
begin
  result := nil;
  if qryCadastrofoto.isNull then
    exit;
  result := TMemoryStream.create();
  qryCadastrofoto.saveToStream(result);
end;

function TServiceUsuario.salvarFotoUsuario(const AFoto: TStream): boolean;
begin
  qryCadastro.edit;
  qryCadastroFoto.loadFromStream(AFoto);
  qryCadastro.post;
  result := qryCadastro.ApplyUpdates(0) = 0;
end;

end.
