unit Controllers.Produto;

interface

uses
    Horse;

  procedure registry();

implementation

uses
  Services.Produto, System.JSON, DataSet.Serialize, Data.Db;

procedure listarProdutos(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceProduto.create();
  var lRetorno := TJSONObject.create();
  try
    lRetorno.addPair('data', LService.listAll(req.query.dictionary).toJSONArray());
    lRetorno.addPair('records', TJSONNumber.create(LService.getRecordCount()));
    res.send(LRetorno);
  finally
    LService.free;
  end;
end;

procedure obterProduto(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceProduto.create();
  try
    var lidProduto := req.Params['id'];
    if LService.getById(lidProduto).IsEmpty then
      raise EHorseException.create('Produto não cadastrado').status(THTTPStatus.notFound);
    res.send(LService.qryCadastro.toJSONObject());
  finally
    LService.free;
  end;
end;

procedure cadastrarProduto(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceProduto.create();
  try
    var LProduto := req.Body<TJSONObject>;
    if LService.append(LProduto) then
      res.send(LService.qryCadastro.toJSONObject()).status(THTTPStatus.created);
  finally
    LService.free;
  end;
end;

procedure alterarProduto(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceProduto.create();
  try
    var lidProduto := req.Params['id'];
    if LService.getById(lidProduto).IsEmpty then
      raise EHorseException.create('Produto não cadastrado').status(THTTPStatus.notFound);
    var LProduto := req.Body<TJSONObject>;
    if LService.update(LProduto) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure deletarProduto(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServiceProduto.create();
  try
    var lidProduto := req.Params['id'];
    if LService.getById(lidProduto).IsEmpty then
      raise EHorseException.create('Produto não cadastrado').status(THTTPStatus.notFound);
    if LService.delete() then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure registry();
begin
  THorse.get('/produtos', listarProdutos);
  THorse.get('/produtos/:id', obterProduto);
  THorse.post('/produtos', cadastrarProduto);
  THorse.put('/produtos/:id', alterarProduto);
  THorse.delete('/produtos/:id', deletarProduto);
end;

end.
