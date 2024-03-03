unit Unit1;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  Web.HTTPApp, FireDAC.Comp.UI;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable1DBNUMBER: TIntegerField;
    FDTable1CMNUMBER: TIntegerField;
    FDTable1TITLENUM: TIntegerField;
    FDTable1NAME: TWideStringField;
    FDTable1COMMENT: TMemoField;
    FDTable1DATETIME: TDateField;
    FDTable1COMCNT: TIntegerField;
    FDTable2: TFDTable;
    DataSource1: TDataSource;
    FDTable2ID: TIntegerField;
    FDTable2DBNUMBER: TIntegerField;
    FDTable2DBNAME: TWideStringField;
    FDTable2TITLENUM: TIntegerField;
    FDTable2TITLE: TWideStringField;
    FDQuery1: TFDQuery;
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    function Comment(Text: string): string;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDataModule1 }

function TDataModule1.Comment(Text: string): string;
begin
  result:=Text;
end;

end.
