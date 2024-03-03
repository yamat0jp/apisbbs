unit article;

interface

uses Horse;

procedure Get_Article(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Get_Titles(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Get_Comments(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses Unit1, System.JSON.Serializers, System.SysUtils, System.Variants,
  FireDAC.Stan.Param, System.JSON, DataSet.Serialize;

procedure Get_Article(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  tid, id: Variant;
  JSON: TJSONObject;
begin
  tid := Req.Params['title'];
  id := Req.Params['id'];
  with DataModule1 do
    if FDTable1.Locate('titlenum;cmnumber', VarArrayOf([tid, id])) then
    begin
      JSON := TJSONObject.Create;
      JSON.AddPair('name', FDTable1.FieldByName('name').AsString);
      JSON.AddPair('comment', comment(FDTable1.FieldByName('comment')
        .AsString));
      JSON.AddPair('date', FDTable1.FieldByName('datetime').AsDateTime);
      Res.Send(JSON.ToString);
    end;
end;

procedure Get_Titles(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JSON: TJSONObject;
  jsonArray: TJSONArray;
begin
  with DataModule1 do
  begin
    FDQuery1.Open;
    jsonArray := FDQuery1.ToJSONArray;
    JSON := TJSONObject.Create;
    try
      JSON.AddPair('titles', jsonArray);
      Res.Send(JSON.ToString);
    finally
      JSON.Free;
      FDQuery1.Close;
    end;
  end;
end;

procedure Get_Comments(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JSON: TJSONObject;
  jsonArray: TJSONArray;
  tid: Variant;
begin
  with DataModule1 do
  begin
    tid := Req.Params['title'];
    if not FDTable2.Locate('dbnumber;titlenum', VarArrayOf([1, tid])) then
      Exit;
    jsonArray := TJSONArray.Create;
    FDTable1.First;
    while not FDTable1.Eof do
    begin
      JSON := TJSONObject.Create;
      JSON.AddPair('name', FDTable1.FieldByName('name').AsString);
      JSON.AddPair('comment', comment(FDTable1.FieldByName('comment')
        .AsString));
      JSON.AddPair('date', FDTable1.FieldByName('datetime').AsDateTime);
      FDTable1.Next;
      jsonArray.Add(JSON);
    end;
    JSON := TJSONObject.Create;
    try
      JSON.AddPair('title', FDTable2.FieldByName('title').AsString);
      JSON.AddPair('comments', jsonArray);
      Res.Send(JSON.ToString);
    finally
      JSON.Free;
    end;
  end;
end;

end.
