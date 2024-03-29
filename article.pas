unit article;

interface

uses Horse;

procedure Get_Article(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Get_Titles(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Get_Comments(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses Unit1, System.JSON.Serializers, System.SysUtils, System.Variants,
  FireDAC.Stan.Param, System.JSON, DataSet.Serialize, System.Classes;

procedure Get_Article(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  tid, id: Variant;
  JSON: TJSONObject;
  cnt: integer;
  str1, str2: string;
begin
  tid := Req.Params['title'];
  id := Req.Params['id'];
  with DataModule1 do
  begin
    DataSource1.Enabled := false;
    if FDTable1.Locate('titlenum;cmnumber', VarArrayOf([tid, id])) then
    begin
      cnt := FDTable1.FieldByName('comcnt').AsInteger;
      ReadComment(str1, str2, FDTable1.FieldByName('comment').AsString, cnt);
      JSON := TJSONObject.Create;
      JSON.AddPair('name', FDTable1.FieldByName('name').AsString);
      JSON.AddPair('comment', ProcessComment(str1));
      JSON.AddPair('code', str2);
      JSON.AddPair('date', FDTable1.FieldByName('datetime').AsDateTime);
      Res.Send(JSON.ToJSON);
    end;
    DataSource1.Enabled := true;
  end;
end;

procedure Get_Titles(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JSON: TJSONObject;
  jsonArray: TJSONArray;
begin
  with DataModule1 do
  begin
    FDQuery1.Open
      ('select titlenum, title, name, datetime from nametable, maintable where dbnumber = 1 and cmnumber = 1;');
    jsonArray := FDQuery1.ToJSONArray;
    JSON := TJSONObject.Create;
    try
      JSON.AddPair('titles', jsonArray);
      Res.Send(JSON.ToJSON);
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
  cnt: integer;
  title: Variant;
  str1, str2: string;
begin
  title := Req.Params['title'];
  with DataModule1 do
  begin
    if not FDTable2.Locate('dbnumber;titlenum', VarArrayOf([1, title])) then
      Exit;
    jsonArray := TJSONArray.Create;
    FDTable1.First;
    while not FDTable1.Eof do
    begin
      cnt := FDTable1.FieldByName('comcnt').AsInteger;
      ReadComment(str1, str2, FDTable1.FieldByName('comment').AsString, cnt);
      JSON := TJSONObject.Create;
      JSON.AddPair('name', FDTable1.FieldByName('name').AsString);
      JSON.AddPair('comment', ProcessComment(str1));
      JSON.AddPair('code', str2);
      JSON.AddPair('date', FDTable1.FieldByName('datetime').AsDateTime);
      FDTable1.Next;
      jsonArray.Add(JSON);
    end;
    JSON := TJSONObject.Create;
    try
      JSON.AddPair('title', FDTable2.FieldByName('title').AsString);
      JSON.AddPair('comments', jsonArray);
      Res.Send(JSON.ToJSON);
    finally
      JSON.Free;
    end;
  end;
end;

end.
