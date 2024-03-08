unit search;

interface

uses Horse, Unit1, Unit2;

procedure Post_Search(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Post_Register(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.Variants, System.JSON, System.SysUtils, FireDAC.Stan.Param;

function localSearch(const title: string): TJSONObject;
var
  cnt: integer;
  str1, str2: string;
  JSON: TJSONObject;
  jsonArray: TJSONArray;
begin
  jsonArray := TJSONArray.Create;
  with DataModule1 do
  begin
    FDQuery1.SQL.Text :=
      'select * from nametable,maintable where title = :title order by datetime desc;';
    FDQuery1.ParamByName('title').AsString := title;
    FDQuery1.Open;
    try
      while not FDQuery1.Eof do
      begin
        cnt := FDQuery1.FieldByName('comcnt').AsInteger;
        ReadComment(str1, str2, FDQuery1.FieldByName('comment').AsString, cnt);
        JSON := TJSONObject.Create;
        JSON.AddPair('db', FDQuery1.FieldByName('dbnumber').AsInteger);
        JSON.AddPair('number', FDQuery1.FieldByName('cmnumber').AsInteger);
        JSON.AddPair('name', FDQuery1.FieldByName('name').AsString);
        JSON.AddPair('comment', ProcessComment(str1));
        JSON.AddPair('code', str2);
        JSON.AddPair('date', FDQuery1.FieldByName('datetime').AsDateTime);
        jsonArray.Add(JSON);
        FDQuery1.Next;
      end;
    finally
      FDQuery1.Close;
    end;
  end;
  result := TJSONObject.Create;
  result.AddPair('title', title);
  result.AddPair('response', jsonArray);
end;

procedure Post_Search(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  str1, str2, title: string;
  JSON: TJSONObject;
  value: TJSONValue;
  jsonArray: TJSONArray;
  cnt: integer;
begin
  JSON := Req.Body<TJSONObject>;
  value := JSON.Values['word'];
  if (value = nil) or (value.value = '') then
  begin
    Res.Send('');
    Exit;
  end;
  if JSON.Values['title'].value = 'title' then
  begin
    JSON := localSearch(value.value);
    Res.Send(JSON.ToJSON);
    JSON.Free;
    Exit;
  end;
  SearchModule1 := TPageSearch.Create;
  try
    SearchModule1.WordList.DelimitedText := value.value;
    jsonArray := TJSONArray.Create;
    with DataModule1 do
    begin
      DataSource1.Enabled := false;
      FDTable1.First;
      while not FDTable1.Eof do
      begin
        cnt := FDTable1.FieldByName('comcnt').AsInteger;
        ReadComment(str1, str2, FDTable1.FieldByName('comment').AsString, cnt);
        if SearchModule1.Execute(str1) then
        begin
          JSON := TJSONObject.Create;
          JSON.AddPair('db', 1);
          JSON.AddPair('number', FDTable1.FieldByName('cmnumber').AsInteger);
          JSON.AddPair('name', FDTable1.FieldByName('name').AsString);
          JSON.AddPair('comment', ProcessComment(str1));
          JSON.AddPair('code', str2);
          JSON.AddPair('date', FDTable1.FieldByName('datetime').AsString);
          jsonArray.Add(JSON);
        end;
        FDTable1.Next;
      end;
      if jsonArray.Count > 0 then
      begin
        cnt := FDTable1.FieldByName('titlenum').AsInteger;
        title := FDTable2.Lookup('titlenum', cnt, 'title');
      end;
    end;
  finally
    SearchModule1.Free;
    DataModule1.DataSource1.Enabled := true;
  end;
  JSON := TJSONObject.Create;
  JSON.AddPair('title', title);
  JSON.AddPair('response', jsonArray);
  Res.Send(JSON.ToJSON);
  JSON.Free;
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
