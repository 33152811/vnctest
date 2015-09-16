program DVNCViewer;

uses
  QForms,
  Unit1 in 'Unit1.pas' {Form1},
  viewer_u in 'viewer_u.pas' {Viewer_F},
  option_u in 'option_u.pas' {Option_F};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi VNC Viewer';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOption_F, Option_F);
  Application.CreateForm(TViewer_F, Viewer_F);
  Application.Run;
end.
