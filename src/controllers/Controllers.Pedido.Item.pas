unit Controllers.Pedido.Item;

interface
uses
  Horse;

  procedure registry();

implementation

uses
  Services.Pedido.Item, System.JSON, DataSet.Serialize, Data.Db;

procedure listarItens(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LIdPedido := req.params.items['id_pedido'];
  var LService := TServicePedidoItem.create();
  var lRetorno := TJSONObject.create();
  try
    lRetorno.addPair('data', LService.listAllByPedido(req.query.dictionary, LIdPedido).toJSONArray());
    lRetorno.addPair('records', TJSONNumber.create(LService.getRecordCount()));
    res.send(LRetorno);
  finally
    LService.free;
  end;
end;

procedure obterItem(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedidoItem.create();
  try
    var LIdPedido := req.params.items['id_pedido'];
    var lidItem := req.Params['id_item'];
    if LService.getByIdPedido(lidItem, LIdPedido).IsEmpty then
      raise EHorseException.create('Item não cadastrado').status(THTTPStatus.notFound);
    res.send(LService.qryCadastro.toJSONObject());
  finally
    LService.free;
  end;
end;

procedure cadastrarItem(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedidoItem.create();
  try
    var LItem := req.Body<TJSONObject>;
    var LIdPedido := req.params.items['id_pedido'];
    LItem.removePair('idPedido').free;
    LItem.addPair('idPedido', TJSONNumber.create(LIdPedido));
    if LService.append(LItem) then
      res.send(LService.qryCadastro.toJSONObject()).status(THTTPStatus.created);
  finally
    LService.free;
  end;
end;

procedure alterarItem(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedidoItem.create();
  try
    var lidItem := req.Params.items['id_item'];
    var LIdPedido := req.params.items['id_pedido'];
    //
    if LService.getByIdPedido(lidItem, LIdPedido).IsEmpty then
      raise EHorseException.create('Item não cadastrado').status(THTTPStatus.notFound);
    var LItem := req.Body<TJSONObject>;
    LItem.removePair('idPedido').free;
    if LService.update(LItem) then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure deletarItem(req: THorseRequest; res: THorseResponse; next: TProc);
begin
  var LService := TServicePedidoItem.create();
  try
    var lidItem := req.Params.items['id_item'];
    var lidPedido := req.Params['id_pedido'];
    if LService.getByIdPedido(lidItem, lidPedido).IsEmpty then
      raise EHorseException.create('Item não cadastrado').status(THTTPStatus.notFound);
    if LService.delete() then
      res.status(THTTPStatus.NoContent);
  finally
    LService.free;
  end;
end;

procedure registry();
begin
  THorse.get('/pedidos/:id_pedido/itens', listarItens);
  THorse.get('/pedidos/:id_pedido/itens/:id_item', obterItem);
  THorse.post('/pedidos/:id_pedido/itens', cadastrarItem);
  THorse.put('/pedidos/:id_pedido/itens/:id_item', alterarItem);
  THorse.delete('/pedidos/:id_pedido/itens/:id_item', deletarItem);
end;

end.
