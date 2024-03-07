unit index;

interface

uses
  Horse, System.JSON;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.Variants, Unit1, System.SysUtils;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cnt, tid: Variant;
  id: integer;
  na, text: string;
  JSON: TJSONObject;
begin
  tid:=Req.Params['title'];
  JSON := Req.Body<TJSONObject>;
  cnt := JSON.Values['cnt'].Value;
  na := JSON.Values['name'].Value;
  text := JSON.Values['text'].Value;
  with DataModule1 do
  begin
    FDQuery1.Open('select MAX(cmnumber) from maintable;');
    id := FDQuery1.FieldByName('max').AsInteger + 1;
    FDQuery1.Close;
    FDTable1.AppendRecord([1, id, tid, na, text, Date, cnt]);
  end;
end;

end.
