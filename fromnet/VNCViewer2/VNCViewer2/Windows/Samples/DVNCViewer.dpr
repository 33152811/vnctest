program DVNCViewer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  viewer_u in 'viewer_u.pas' {Viewer_F},
  option_u in 'option_u.pas' {Option_F},
  progress_U in 'progress_U.pas' {Progress_F},
  Chat_U in 'Chat_U.pas' {Chat_F},
  FileTransfer_U in 'FileTransfer_U.pas' {FileTransfer_F},
  Status_U in 'Status_U.pas' {Status_F};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi VNC Viewer';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOption_F, Option_F);
  Application.CreateForm(TProgress_F, Progress_F);
  Application.Run;
end.
