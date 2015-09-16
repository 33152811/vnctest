unit viewer_u;

interface

uses
 QTypes, QExtCtrls,Qdialogs,QGraphics,Types,
  QControls, QForms, Classes, VNCViewer;


type
  TViewer_F = class(TForm)
    Viewer: TDelphiVNCViewer;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewConnection1Click(Sender: TObject);
    procedure RequestScreenRefresh1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure mFullScreenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FFullScreen: Boolean;
    procedure setFullScreen(const Value: Boolean);
    { Private declarations }
  public
      SavWL1:LongWord;
      SavWL2:LongWord;
      SvLeft:LongWord;
      SvTop:LongWord;
      SvWidth:LongWord;
      SvHeight:LongWord;
      Property fullScreen:Boolean Read FFullScreen write setFullScreen;
    { Public declarations }
  end;

var
  Viewer_F: TViewer_F;

implementation

uses Unit1;

{$R *.dfm}

procedure TViewer_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Viewer.DisConnect;
//  Action:=cafree;
end;

procedure TViewer_F.NewConnection1Click(Sender: TObject);
begin
  form1.Show;
end;

procedure TViewer_F.RequestScreenRefresh1Click(Sender: TObject);
begin
  viewer.UpdateRequest;
end;

procedure TViewer_F.About1Click(Sender: TObject);
begin
  ShowMessage('Delphi VNC Viewer Control version 2.2.1'+#13#10+'Magic Pot Shareware');
end;

procedure TViewer_F.mFullScreenClick(Sender: TObject);
var
  i: Integer;
begin
//    mFullScreen.Checked:=not mFullScreen.Checked;
//    if mFullScreen.Checked then
//    begin
//      LockWindowUpdate(Handle);
//      SavWL1:=GetWindowLong(Handle,GWL_STYLE);
//      SvLeft:=Left;
//      SvTop:=Top;
//      SvWidth:=Width;
//      SvHeight:=Height;
//      SetWindowPos(Handle,HWND_TOP,-2,-24,Screen.Width+2,Screen.Height+2,tnFlag);
//      LockWindowUpdate(0);
//      Viewer.AutoScroll:=false;
//    end
//    else
//    begin
//      LockWindowUpdate(Handle);
//      SetWindowLong(Handle,GWL_STYLE,SavWL1);
//      SetWindowPos(Handle,HWND_NOTOPMOST,SvLeft,SvTop,SvWidth,SvHeight,tnFlag);
//      LockWindowUpdate(0);
//      Viewer.AutoScroll:=true;
//    end;
end;

procedure TViewer_F.Timer1Timer(Sender: TObject);
var
  p:TPoint;
begin
  if FullScreen then
  begin
    GetCursorPos(p);
    if p.X=0 then
      viewer.xPosition:=viewer.xPosition-5;
    if p.Y=0 then
      viewer.yPosition:=viewer.yPosition-5;
    if p.x=screen.Width-1 then
      viewer.xPosition:=viewer.xPosition+5;
    if p.Y=Screen.Height-1 then
      viewer.yPosition:=viewer.yPosition+5;
  end;
end;

procedure TViewer_F.setFullScreen(const Value: Boolean);
begin
  FFullScreen := Value;
  if FFullScreen then
    begin
      SavWL1:=Constraints.MaxWidth;
      SavWL2:=Constraints.MaxHeight;
      Constraints.MaxWidth:=0;
      Constraints.MaxHeight:=0;
      BorderStyle:=fbsNone;
      SvLeft:=Left;
      SvTop:=Top;
      SvWidth:=Width;
      SvHeight:=Height;
      SetBounds(0,0,Screen.Width,Screen.Height);
      Viewer.AutoScroll:=false;
    end
  else
    begin
      Constraints.MaxWidth:=SavWL1;
      Constraints.MaxHeight:=SavWL2;
      BorderStyle:=fbsSizeable;
      SetBounds(SvLeft,SvTop,SvWidth,SvHeight);
      Viewer.AutoScroll:=true;
    end;
end;

end.
