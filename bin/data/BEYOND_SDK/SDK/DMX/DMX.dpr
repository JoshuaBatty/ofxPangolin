program DMX;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  DllCalls in '..\DllCalls.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
