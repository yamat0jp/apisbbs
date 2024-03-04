unit help;

interface

uses Horse, Horse.Jhonson;

procedure Post_Help(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Post_Alert(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses System.JSON, System.Classes, System.SysUtils, Unit1, System.Variants;

procedure WriteData(const Text: array of string);
const
  str = 'voice.txt';
var
  f: TextFile;
  ans: string;
begin
  for var s in Text do
    ans := ans + #13#10 + s;
  ans := ans + #13#10 + '==================';
  AssignFile(f, str);
  try
    if FileExists(str) then
      Append(f)
    else
      Rewrite(f);
    Writeln(f, ans);
  finally
    CloseFile(f);
  end;
end;

procedure Post_Help(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  var
  JSON := Req.Body<TJSONObject>;
  if JSON.Values['help'] <> nil then
    WriteData(JSON.Values['help'].Value);
end;

procedure Post_Alert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  tid, id: Variant;
  JSON: TJSONObject;
  ti, na: string;
begin
  JSON := Req.Body<TJSONObject>;
  if JSON.Values['text'] = nil then
    Exit;
  tid := Req.Params['title'];
  id := Req.Params['id'];
  with DataModule1 do
    if FDTable2.Locate('dbnumber;titlenum', VarArrayOf([1, tid])) and
      FDTable1.Locate('cmnumber', id) then
    begin
      ti := FDTable2.FieldByName('title').AsString;
      na := FDTable1.FieldByName('name').AsString;
      WriteData([ti, na + ' ' + id, JSON.Values['text'].Value]);
    end;
end;

end.
