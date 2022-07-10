unit Controllers.Cliente;

interface

uses
  Horse;

  procedure registry();

implementation

uses
  Services.Cliente, System.JSON, DataSet.Serialize, Data.Db;

procedure listarClientes(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceCliente.create();
  var lRetorno := TJSONObject.create();
  try
    lRetorno.addPair('data', LService.listAll(req.query.dictionary).toJSONArray());
    lRetorno.addPair('records', TJSONNumber.create(LService.getRecordCount()));
    res.send(LRetorno);
  finally
    LService.free;
  end;
end;

procedure obterCliente(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceCliente.create();
  try
    var lidCliente := req.Params['id'];
    if LService.getById(lidCliente).IsEmpty then
      raise EHorseException.create('Cliente não cadastrado').status(THTTPStatus.notFound);
    res.send(LService.qryCadastro.toJSONObject());
  finally
    LService.free;
  end;
end;

procedure cadastrarCliente(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceCliente.create();
  try
    var LCliente := req.Body<TJSONObject>;
    if LService.append(LCliente) then
      res.send(LService.qryCadastro.toJSONObject()).status(THTTPStatus.created);
  finally
    LService.free;
  end;
end;

procedure alterarCliente(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceCliente.create();
  try
    var lidCliente := req.Params['id'];
    if LService.getById(lidCliente).IsEmpty then
      raise EHorseException.create('Cliente não cadastrado').status(THTTPStatus.notFound);
    var LCliente := req.Body<TJSONObject>;
    if LService.update(LCliente) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure deletarCliente(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceCliente.create();
  try
    var lidCliente := req.Params['id'];
    if LService.getById(lidCliente).IsEmpty then
      raise EHorseException.create('Cliente não cadastrado').status(THTTPStatus.notFound);
    if LService.delete() then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure registry();
begin
  THorse.get('/clientes', listarClientes);
  THorse.get('/clientes/:id', obterCliente);
  THorse.post('/clientes', cadastrarCliente);
  THorse.put('/clientes/:id', alterarCliente);
  THorse.delete('/clientes/:id', deletarCliente);
end;

end.
