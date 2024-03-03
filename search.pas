unit search;

interface

uses Horse, Unit1, Unit2;

procedure Post_Search(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Post_Register(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.Variants, System.JSON, System.SysUtils;

procedure Post_Search(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  text, s: string;
  JSON: TJSONObject;
  value: TJSONValue;
begin
  JSON := Req.Body<TJSONObject>;
  value := JSON.Values['word'];
  if (value = nil) or (value.value = '') then
  begin
    Res.Send('');
    Exit;
  end;
  text := '';
  SearchModule1 := TPageSearch.Create;
  try
    SearchModule1.WordList.DelimitedText := value.value;
    with DataModule1 do
    begin
      FDTable1.MasterSource.Enabled:=false;
      FDTable1.First;
      while not FDTable1.Eof do
      begin
        s := SearchModule1.Execute(FDTable1.FieldByName('comment').AsString);
        if s <> '' then
          text := text + '<hr>' + Comment(s);
        FDTable1.Next;
      end;
    end;
  finally
    SearchModule1.Free;
    DataModule1.FDTable1.MasterSource.Enabled:=true;
  end;
  Res.Send(text);
end;

procedure Post_Register(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cnt: integer;
  id, sc: Variant;
  db, ti, na, cm: string;
  JSON: TJSONObject;
begin
  JSON := Req.Body<TJSONObject>;
  ti := JSON.Values['title'].value;
  na := JSON.Values['name'].value;
  cm := JSON.Values['comment'].value;
  id := Req.Params['title'];
  sc := Req.Params['secret'];
  with DataModule1 do
  begin
    if FDTable2.Locate('dbnumber;titlenum', VarArrayOf([1, id])) then
    begin
      FDQuery1.Open('select MAX(dmnuber) as max from maintable;');
      cnt := FDQuery1.FieldByName('max').AsInteger + 1;
      FDTable1.AppendRecord([1, cnt, id, na, cm, Date, sc]);
    end;
    FDQuery1.Open('select MAX(id) as max from nametable;');
    cnt := FDQuery1.FieldByName('max').AsInteger + 1;
    db := FDTable2.FieldByName('dbname').AsString;
    FDTable2.AppendRecord([cnt, 1, db, id, ti]);
    FDQuery1.Close;
  end;
end;

end.