unit Unit2;

interface

uses System.Classes, System.SysUtils;

type
  TFindState = (fdShort, fdNormal, fdNone);

  TPageSearch = class
  private
    FText: string;
    FWordList, FList, FResultLST: TStringList;
    function checkState(var st: integer; word, line: string): TFindState;
    procedure processNormal(var id: integer; word, line: string);
    procedure processShort(var id, ln: integer; word: string; var line: string);
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(const Text: string): string;
    property WordList: TStringList read FWordList;
  end;

var
  SearchModule1: TPageSearch;

implementation

{ TPageSearch }

const
  str = '<span style=background-color:yellow>%s</span>';

var
  bool: Boolean;

function TPageSearch.checkState(var st: integer; word, line: string)
  : TFindState;
begin
  result := fdNone;
  for var id := st to Length(line) do
  begin
    if line[id] <> word[1] then
      Continue;
    FText := FText + Copy(line, st, id - st);
    st := id;
    if Copy(line, id, Length(word)) = word then
    begin
      result := fdNormal;
      bool := true;
      break;
    end
    else if Pos(Copy(line, id, Length(line)), word) > 0 then
      result := fdShort;
  end;
end;

constructor TPageSearch.Create;
begin
  FWordList := TStringList.Create;
  FWordList.QuoteChar := '"';
  FWordList.Delimiter := ' ';
  FList := TStringList.Create;
  FResultLST := TStringList.Create;
end;

destructor TPageSearch.Destroy;
begin
  FWordList.Free;
  FList.Free;
  FResultLST.Free;
  inherited;
end;

procedure TPageSearch.processNormal(var id: integer; word, line: string);
begin
  FText := FText + Format(str, [word]);
  inc(id, Length(word));
end;

procedure TPageSearch.processShort(var id, ln: integer; word: string;
  var line: string);
var
  wrd: string;
  cnt: integer;
  state: TFindState;
begin
  state := fdShort;
  cnt := Length(word);
  wrd := Copy(line, id, Length(word));
  FText := FText + Format(str, [wrd]);
  dec(cnt, Length(wrd));
  while state = fdShort do
  begin
    wrd := Copy(word, Length(wrd) + 1, Length(line));
    FText := FText + #13#10 + Format(str, [wrd]);
    dec(cnt, Length(wrd));
    inc(ln);
    if FList.count = ln then
    begin
      bool := false;
      Exit;
    end;
    line := FList[ln];
    id := 1;
    state := checkState(id, wrd, line);
    inc(id, Length(wrd));
  end;
  bool := cnt = 0;
end;

function TPageSearch.Execute(const Text: string): string;
var
  i, id: integer;
  state: TFindState;
  s: string;
begin
  FList.Text := Text;
  bool := false;
  for var str in WordList do
  begin
    FText := '';
    i := 0;
    id := 1;
    while i < FList.count do
    begin
      s := FList[i];
      state := checkState(id, str, s);
      case state of
        fdShort:
          processShort(id, i, str, s);
        fdNormal:
          processNormal(id, str, s);
        fdNone:
          begin
            FText := FText + Copy(s, id, Length(s)) + #13#10;
            id := 1;
            inc(i);
          end;
      end;
    end;
    FList.Text := FText;
  end;
  if bool then
    result := FList.Text;
end;

end.

