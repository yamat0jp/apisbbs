unit index;

interface

uses
  Horse, System.JSON;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.Variants, Unit1, System.SysUtils;

procedure API_Index(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cnt: Variant;
  id, tid: integer;
  na, text, title: string;
  JSON: TJSONObject;
begin
  JSON := Req.Body<TJSONObject>;
  title := JSON.Values['title'].Value;
  cnt := JSON.Values['cnt'].Value;
  na := JSON.Values['name'].Value;
  text := JSON.Values['text'].Value;
  with DataModule1 do
  begin
    FDQuery1.Open('select MAX(cmnumber) from maintable;');
    id := FDQuery1.FieldByName('max').AsInteger;
    FDQuery1.Close;
    tid := FDTable2.Lookup('dbnumber;title', VarArrayOf([1, title]),
      'titlenum');
    FDTable1.AppendRecord([1, id, tid, na, text, Date, cnt]);
  end;
end;

end.
