object DataModule1: TDataModule1
  Height = 247
  Width = 252
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\yamat\Documents\GitHub\2023\My BBS\pbbs2\data\' +
        'NEWDATA.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'OpenMode=OpenOrCreate'
      'CharacterSet=UTF8'
      'DriverID=IB')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 40
  end
  object FDTable1: TFDTable
    Active = True
    IndexFieldNames = 'DBNUMBER;TITLENUM;CMNUMBER'
    MasterSource = DataSource1
    MasterFields = 'DBNUMBER;TITLENUM'
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'maintable'
    Left = 112
    Top = 104
    object FDTable1DBNUMBER: TIntegerField
      FieldName = 'DBNUMBER'
      Origin = 'DBNUMBER'
      Required = True
    end
    object FDTable1CMNUMBER: TIntegerField
      FieldName = 'CMNUMBER'
      Origin = 'CMNUMBER'
      Required = True
    end
    object FDTable1TITLENUM: TIntegerField
      FieldName = 'TITLENUM'
      Origin = 'TITLENUM'
      Required = True
    end
    object FDTable1NAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 800
    end
    object FDTable1COMMENT: TMemoField
      FieldName = 'COMMENT'
      Origin = 'COMMENT'
      BlobType = ftMemo
    end
    object FDTable1DATETIME: TDateField
      FieldName = 'DATETIME'
      Origin = 'DATETIME'
      Required = True
    end
    object FDTable1COMCNT: TIntegerField
      FieldName = 'COMCNT'
      Origin = 'COMCNT'
    end
  end
  object FDTable2: TFDTable
    Active = True
    IndexFieldNames = 'ID'
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'nametable'
    Left = 184
    Top = 104
    object FDTable2ID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      Required = True
    end
    object FDTable2DBNUMBER: TIntegerField
      FieldName = 'DBNUMBER'
      Origin = 'DBNUMBER'
      Required = True
    end
    object FDTable2DBNAME: TWideStringField
      FieldName = 'DBNAME'
      Origin = 'DBNAME'
      Required = True
      Size = 512
    end
    object FDTable2TITLENUM: TIntegerField
      FieldName = 'TITLENUM'
      Origin = 'TITLENUM'
      Required = True
    end
    object FDTable2TITLE: TWideStringField
      FieldName = 'TITLE'
      Origin = 'TITLE'
      Required = True
      Size = 512
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable2
    Left = 184
    Top = 32
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select title, name, datetime from nametable, maintable'
      '  where dbnumber = 1 and cmnumber = 1;')
    Left = 56
    Top = 168
  end
end
