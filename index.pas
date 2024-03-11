unit index;

interface

uses
  Horse, System.JSON;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.Variants, Unit1, System.SysUtils, System.Classes;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cnt, tid: Variant;
  id: integer;
  na, comment, code: string;
  JSON: TJSONObject;
begin
  tid := Req.Params['title'];
  JSON := Req.Body<TJSONObject>;
  na := JSON.Values['name'].Value;
  comment := JSON.Values['comment'].Value;
  code := JSON.Values['code'].Value;
  var
  ls := TStringList.Create;
  try
    ls.Text := comment;
    cnt := ls.Count;
  finally
    ls.Free;
  end;
  with DataModule1 do
  begin
    FDQuery1.Open('select MAX(cmnumber) from maintable;');
    id := FDQuery1.FieldByName('max').AsInteger + 1;
    FDQuery1.Close;
    FDTable1.AppendRecord([1, id, tid, na, comment + #13#10 + code, Date, cnt]);
  end;
end;

end.
