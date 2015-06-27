program Split_Aud_Gui;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MyFunctions in 'MyFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Split_Aud Gui';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
