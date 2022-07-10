inherited ServiceUsuario: TServiceUsuario
  inherited FDConnection: TFDConnection
    Connected = True
  end
  inherited qryPesquisa: TFDQuery
    SQL.Strings = (
      'SELECT u.id, u.nome, u.login, u.sexo, u.status, u.telefone '
      'FROM usuario u'
      'where 1=1')
    object qryPesquisaid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryPesquisanome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object qryPesquisalogin: TWideStringField
      FieldName = 'login'
      Origin = '"login"'
      Size = 30
    end
    object qryPesquisastatus: TSmallintField
      FieldName = 'status'
      Origin = 'status'
    end
    object qryPesquisatelefone: TWideStringField
      FieldName = 'telefone'
      Origin = 'telefone'
    end
    object qryPesquisasexo: TSmallintField
      FieldName = 'sexo'
      Origin = 'sexo'
    end
  end
  inherited qryRecordCount: TFDQuery
    SQL.Strings = (
      'SELECT count(u.id)'
      'FROM usuario u'
      'where 1=1')
  end
  inherited qryCadastro: TFDQuery
    BeforePost = qryCadastroBeforePost
    SQL.Strings = (
      
        'SELECT u.id, u.nome, u.login, u.senha, u.status, u.telefone, u.s' +
        'exo, u.foto'
      'FROM usuario u')
    object qryCadastroid: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCadastronome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object qryCadastrologin: TWideStringField
      FieldName = 'login'
      Origin = '"login"'
      Size = 30
    end
    object qryCadastrosenha: TWideStringField
      FieldName = 'senha'
      Origin = 'senha'
      Size = 255
    end
    object qryCadastrostatus: TSmallintField
      FieldName = 'status'
      Origin = 'status'
    end
    object qryCadastrotelefone: TWideStringField
      FieldName = 'telefone'
      Origin = 'telefone'
    end
    object qryCadastrosexo: TSmallintField
      FieldName = 'sexo'
      Origin = 'sexo'
    end
    object qryCadastrofoto: TBlobField
      FieldName = 'foto'
      Origin = 'foto'
    end
  end
end
