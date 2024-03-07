program api;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.SysUtils,
  employee in 'employee.pas',
  index in 'index.pas',
  Unit1 in 'Unit1.pas' {DataModule1: TDataModule},
  article in 'article.pas',
  Unit2 in 'Unit2.pas',
  search in 'search.pas',
  help in 'help.pas';

begin
  DataModule1 := TDataModule1.Create(nil);
  try
    THorse.Use(Jhonson);
    with THorse.Group.Prefix('/apis') do
    begin
      Route('/register/:title').Post(index.API_Index);
      Route('/articles/:title/:id').Get(article.Get_Article);
      Route('/articles/:title').Get(article.Get_Comments);
      Route('/articles').Get(article.Get_Titles);
      Route('/search').Post(search.Post_Search);
      Route('/help').Post(help.Post_Help);
      Route('/help/:title/:id').Post(help.Post_Alert);
    end;
    THorse.Listen(8080,
      procedure
      begin
        Writeln(Format('Server is runing on %s:%d', [THorse.Host,
          THorse.Port]));
      end,
      procedure
      begin
        Writeln('end horse');
      end);
  finally
    DataModule1.Free;
  end;

end.
