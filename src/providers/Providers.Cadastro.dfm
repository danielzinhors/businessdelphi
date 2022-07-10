inherited ProvidersCadastro: TProvidersCadastro
  OldCreateOrder = True
  Height = 204
  Width = 430
  object qryPesquisa: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 304
    Top = 32
  end
  object qryRecordCount: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 304
    Top = 120
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
  object qryCadastro: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 224
    Top = 80
  end
end
