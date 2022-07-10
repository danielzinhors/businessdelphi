unit Controllers.Usuario;

interface

uses
  Horse;

  procedure registry();

implementation

uses
  Services.Usuario, System.JSON, DataSet.Serialize, Data.Db, System.Classes;

procedure listarUsuarios(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  var lRetorno := TJSONObject.create();
  try
    lRetorno.addPair('data', LService.listAll(req.query.dictionary).toJSONArray());
    lRetorno.addPair('records', TJSONNumber.create(LService.getRecordCount()));
    res.send(LRetorno);
  finally
    LService.free;
  end;
end;

procedure obterUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var lidUsuario := req.Params['id'];
    if LService.getById(lidUsuario).IsEmpty then
      raise EHorseException.New.status(THTTPStatus.notFound).Title('Usuario não cadastrado').Error('Id invalido');
    res.send(LService.qryCadastro.toJSONObject());
  finally
    LService.free;
  end;
end;

procedure cadastrarUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var LUsuario := req.Body<TJSONObject>;
    if LService.append(LUsuario) then
      res.send(LService.qryCadastro.toJSONObject()).status(THTTPStatus.created);
  finally
    LService.free;
  end;
end;

procedure alterarUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var lidUsuario := req.Params['id'];
    if LService.getById(lidUsuario).IsEmpty then
      raise EHorseException.create('Usuario não cadastrado').status(THTTPStatus.notFound).Error('Id invalido');
    var LUsuario := req.Body<TJSONObject>;
    if LService.update(LUsuario) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure deletarUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var lidUsuario := req.Params['id'];
    if LService.getById(lidUsuario).IsEmpty then
      raise EHorseException.New.status(THTTPStatus.notFound).Title('Usuario não cadastrado').Error('Id invalido');
    if LService.delete() then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure cadastrarFotoUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var lidUsuario := req.Params['id'];
    if LService.getById(lidUsuario).IsEmpty then
      raise EHorseException.New.status(THTTPStatus.notFound).Title('Usuario não cadastrado').Error('Id invalido');
    var LFoto := Req.body<TMemoryStream>;
    if not assigned(LFoto) then
      raise EHorseException.New.status(THTTPStatus.badRequest).Title('Foto inválida').Error('Imagem inválida');
    if LService.salvarFotoUsuario(LFoto) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure obterFotoUsuario(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceUsuario.create();
  try
    var lidUsuario := req.Params['id'];
    if LService.getById(lidUsuario).IsEmpty then
      raise EHorseException.New.status(THTTPStatus.notFound).Title('Usuario não cadastrado').Error('Id invalido');
    var LFoto := LService.obterFotoUsuario();
    if not assigned(LFoto) then
      raise EHorseException.New.status(THTTPStatus.badRequest).Title('Usuário sem imagem').Error('Imagem do usuário nula');
    res.send(LFoto).status(THTTPStatus.OK);
  finally
    LService.free;
  end;
end;

procedure registry();
begin
  THorse.get('/usuarios', listarUsuarios);
  THorse.get('/usuarios/:id', obterUsuario);
  THorse.post('/usuarios', cadastrarUsuario);
  THorse.put('/usuarios/:id', alterarUsuario);
  THorse.delete('/usuarios/:id', deletarUsuario);
  THorse.post('/usuarios/:id/foto', cadastrarFotoUsuario);
  THorse.get('/usuarios/:id/foto', obterFotoUsuario);
end;

end.
