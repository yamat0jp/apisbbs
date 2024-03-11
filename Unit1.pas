unit Unit1;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef,
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
    function ProcessComment(const Text: string): string;
    procedure ReadComment(out comment, code: string; const Text: string;
      cnt: integer);
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}
{ TDataModule1 }

function TDataModule1.ProcessComment(const Text: string): string;
var
  s, t: string;
  ls: TStringList;
begin
  ls := TStringList.Create;
  try
    ls.Text := Text;
    for var i := 0 to ls.Count - 1 do
    begin
      s := ls[i];
      t := '';
      if s = '' then
        s := '<br />'
      else
        for var j := 1 to Length(s) do
          if s[j] = ' ' then
            t := t + '&nbsp;'
          else
          begin
            s := t + Copy(s, j - 1, Length(s));
            break;
          end;
      ls[i] := '<p>' + s + '</p>';
    end;
    result := ls.Text;
  finally
    ls.Free;
  end;
end;

procedure TDataModule1.ReadComment(out comment, code: string;
  const Text: string; cnt: integer);
begin
  var
  list := TStringList.Create;
  try
    comment := '';
    code := '';
    list.Text := Text;
    if cnt = 0 then
      cnt := list.Count;
    for var i := 0 to cnt-1 do
      comment := comment + list[i];
    for var i := cnt to list.Count - 1 do
      code := code + list[i];
    if code <> '' then
      code := '<pre><code>' + code + '</code></pre>';
  finally
    list.Free;
  end;
end;

end.
