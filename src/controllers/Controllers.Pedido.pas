unit Controllers.Pedido;

interface

uses
  Horse;

  procedure registry();

implementation

uses
  Services.Pedido, System.JSON, DataSet.Serialize, Data.Db;

procedure listarPedidos(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedido.create();
  var lRetorno := TJSONObject.create();
  try
    lRetorno.addPair('data', LService.listAll(req.query.dictionary).toJSONArray());
    lRetorno.addPair('records', TJSONNumber.create(LService.getRecordCount()));
    res.send(LRetorno);
  finally
    LService.free;
  end;
end;

procedure obterPedido(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedido.create();
  try
    var lidPedido := req.Params['id'];
    if LService.getById(lidPedido).IsEmpty then
      raise EHorseException.create('Pedido não cadastrado').status(THTTPStatus.notFound);
    res.send(LService.qryCadastro.toJSONObject());
  finally
    LService.free;
  end;
end;

procedure cadastrarPedido(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedido.create();
  try
    var LPedido := req.Body<TJSONObject>;
    if LService.append(LPedido) then
      res.send(LService.qryCadastro.toJSONObject()).status(THTTPStatus.created);
  finally
    LService.free;
  end;
end;

procedure alterarPedido(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedido.create();
  try
    var lidPedido := req.Params['id'];
    if LService.getById(lidPedido).IsEmpty then
      raise EHorseException.create('Pedido não cadastrado').status(THTTPStatus.notFound);
    var LPedido := req.Body<TJSONObject>;
    if LService.update(LPedido) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure deletarPedido(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedido.create();
  try
    var lidPedido := req.Params['id'];
    if LService.getById(lidPedido).IsEmpty then
      raise EHorseException.create('Pedido não cadastrado').status(THTTPStatus.notFound);
    if LService.delete() then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure registry();
begin
  THorse.get('/pedidos', listarPedidos);
  THorse.get('/pedidos/:id', obterPedido);
  THorse.post('/pedidos', cadastrarPedido);
  THorse.put('/pedidos/:id', alterarPedido);
  THorse.delete('/pedidos/:id', deletarPedido);
end;

end.
