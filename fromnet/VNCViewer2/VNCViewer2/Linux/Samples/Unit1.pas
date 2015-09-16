unit Unit1;

interface

uses
  
  QMenus,Qforms,VNCViewer, QTypes, QStdCtrls, QButtons, Classes, QControls,viewer_u,QDialogs,SysUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    ListBox1: TListBox;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    Edit3: TEdit;
    BitBtn3: TBitBtn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Options1: TMenuItem;
    ConnectionInfomation1: TMenuItem;
    RequestScreenRefresh1: TMenuItem;
    N2: TMenuItem;
    mFullScreen: TMenuItem;
    NewConnection1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    N4: TMenuItem;
    FileTransfer1: TMenuItem;
    Chat1: TMenuItem;
    CheckBox1: TCheckBox;
    Edit4: TEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure VNCViewerAuthFail(Sender: TObject);
    procedure VNCViewerConnectClose(Sender: TObject);
    procedure VNCViewerConnected(Sender: TObject);
    procedure VNCViewerFrameSize(Sender: TObject; FrameWidth,
      FrameHeight: Integer);
    procedure VNCViewerHostName(Sender: TObject; HostName: String);
    procedure VNCViewerStatus(Sender: TObject; ErrorMsg: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure VNCViewerConnectError(Sender: TObject; ErrorMsg: String);
    procedure BitBtn3Click(Sender: TObject);
    procedure mFullScreenClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure ConnectionInfomation1Click(Sender: TObject);
    procedure NewConnection1Click(Sender: TObject);
  private
    { Private declarations }
  public
    viewer:TViewer_F;
    function ReadTimetick:Int64;
    procedure WriteLog(msg:String);
    procedure SetOptions(lViewer:TDelphiVNCViewer);
    procedure ReadOption(lViewer:TDelphiVNCViewer);
      function GetFileSizeDiv(lSize:LongWord):Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses option_u;


{$R *.dfm}

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.VNCViewerAuthFail(Sender: TObject);
begin
  ShowMessage('Auth fail!');
  ((Sender as TDelphiVNCViewer).Parent as TForm).Close;
end;

procedure TForm1.VNCViewerConnectClose(Sender: TObject);
begin
  if ((Sender as TDelphiVNCViewer).Parent as TForm).Visible then
    ((Sender as TDelphiVNCViewer).Parent as TForm).Close;
  self.Show;
end;

procedure TForm1.VNCViewerConnected(Sender: TObject);
begin
  if assigned(Viewer) then
  begin
    self.Hide;
    Viewer.Show;
  end;
end;

procedure TForm1.VNCViewerFrameSize(Sender: TObject; FrameWidth,
  FrameHeight: Integer);
begin
  if Assigned(Viewer) then
  begin
    Viewer.ClientWidth:=FrameWidth+5;
    Viewer.ClientHeight:=FrameHeight+5;
    viewer.Constraints.MaxWidth:=Viewer.Width+5;
    viewer.Constraints.MaxHeight:=viewer.Height+5;
  end;
end;

procedure TForm1.VNCViewerHostName(Sender: TObject; HostName: String);
begin
  if Assigned(Viewer) then
  begin
    Viewer.Caption:=HostName;
  end;
end;

procedure TForm1.VNCViewerStatus(Sender: TObject; ErrorMsg: String);
begin
  WriteLog(ErrorMsg);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if trim(edit1.Text)='' then
  begin
    ShowMessage('Host addr can''t been blank!');
    exit;
  end;
  ListBox1.Items.Clear;
  Viewer:=Viewer_F;
  if Checkbox1.Checked then
  begin
        Viewer.Viewer.UseRepeater:=true;
        Viewer.Viewer.RepeaterAddr:=Copy(Edit4.Text,1,Pos(':',Edit4.Text)-1);
        Viewer.Viewer.RepeaterPort:=StrToIntDef(Copy(Edit4.Text,Pos(':',Edit4.Text),255),5901);
  end;
  Viewer.Viewer.OnAuthFail:=VNCViewerAuthFail;
  viewer.Viewer.OnConnectError:=VNCViewerConnectError;
  viewer.Viewer.OnConnectClose:=VNCViewerConnectClose;
  viewer.Viewer.OnConnected:=VNCViewerConnected;
  viewer.Viewer.OnFrameSize:=VNCViewerFrameSize;
  viewer.Viewer.OnHostName:=VNCViewerHostName;
  viewer.Viewer.OnStatus:=VNCViewerStatus;
  viewer.Viewer.Server:=edit1.Text;
  viewer.Viewer.Port:=StrtoIntDef(edit2.Text,5900);
  viewer.Viewer.Password:=Edit3.Text;
  SetOptions(Viewer.Viewer);
  Viewer.fullScreen:=Option_F.chkFullScreen.Checked;
  viewer.Viewer.Connect;
end;

procedure TForm1.WriteLog(msg:String);
begin
  ListBox1.Items.Add(msg);
  ListBox1.ItemIndex:=ListBox1.Items.Count-1;
end;

procedure TForm1.VNCViewerConnectError(Sender: TObject; ErrorMsg: String);
begin
  WriteLog(ErrorMsg);
  ((Sender as TDelphiVNCViewer).Parent as TForm).Close;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
//  Option_F.chkFullScreen.Enabled:=true;
  Option_F.chkShared.Enabled:=true;
  Option_F.chkFullScreen.Enabled:=false;
  Option_F.ShowModal;
end;

procedure TForm1.mFullScreenClick(Sender: TObject);
var
  lform:TViewer_F;
begin
  if Screen.ActiveForm<>nil then
    if Screen.ActiveForm is TViewer_F then
    begin
      lForm:=(Screen.ActiveForm as TViewer_F);
      lForm.fullScreen:=not lForm.fullScreen;
    end;
end;

procedure TForm1.SetOptions(lViewer: TDelphiVNCViewer);
begin
  case Option_F.rgEncoding.ItemIndex of    //
    0: lViewer.Codec:=VNCHextile;
    1: lViewer.Codec:=VNCCoRRE;
    2: lViewer.Codec:=VNCRRE;
    3: lViewer.Codec:=VNCCopyRect;
    4: lViewer.Codec:=VNCRAW;
  end;    // case
  if Option_F.chkBitColor.Checked then
    lViewer.PixelFormat:=VNC8Bit
  else
    lViewer.PixelFormat:=vncAuto;
  lViewer.TransferKeys:=not Option_F.chkViewOnly.Checked;
  lViewer.TransferMouse:=not Option_F.chkViewOnly.Checked;
  lViewer.TransferLocalClipboard:=not Option_F.chkClipboard.Checked;
  lViewer.TransferServerClipBoard:=not Option_F.chkClipboard.Checked;
  lViewer.ShareDesktop:=option_F.chkShared.Checked;
  lViewer.Stretch:=option_F.chkStretch.Checked;
  lViewer.EnableBell:=option_F.chkBell.Checked;
end;

procedure TForm1.Options1Click(Sender: TObject);
var
  lform:TViewer_F;
begin
  if Screen.ActiveForm<>nil then
    if Screen.ActiveForm is TViewer_F then
    begin
      lForm:=(Screen.ActiveForm as TViewer_F);
      Option_F.chkFullScreen.Enabled:=false;
      Option_F.chkShared.Enabled:=false;
      Option_F.chkFullScreen.Enabled:=true;
      Option_F.chkFullScreen.Checked:=lForm.fullScreen;
      Option_F.chkShared.Checked:=lForm.Viewer.ShareDesktop;
      ReadOption(lform.Viewer);
      if Option_F.ShowModal=mrOK then
        SetOptions(lForm.Viewer);
    end;
end;

procedure TForm1.ReadOption(lViewer: TDelphiVNCViewer);
begin
  case lViewer.Codec of    //
    VNCHextile:Option_F.rgEncoding.ItemIndex:=0;
    VNCCoRRE:Option_F.rgEncoding.ItemIndex:=1;
    VNCRRE:Option_F.rgEncoding.ItemIndex:=2;
    VNCCopyRect:Option_F.rgEncoding.ItemIndex:=3;
    VNCRAW:Option_F.rgEncoding.ItemIndex:=4;
  end;    // case
  if lViewer.PixelFormat = VNC8Bit then
    Option_F.chkBitColor.Checked:=true
  else
    Option_F.chkBitColor.Checked:=false;
  Option_F.chkViewOnly.Checked:=not lViewer.TransferKeys;
  Option_F.chkClipboard.Checked:=not lViewer.TransferLocalClipboard;
  option_F.chkShared.Checked:=lViewer.ShareDesktop;
  option_F.chkStretch.Checked:=lViewer.Stretch;
  option_F.chkBell.Checked:=lViewer.EnableBell;
end;

procedure TForm1.ConnectionInfomation1Click(Sender: TObject);
var
  lform:TViewer_F;
begin
  if Screen.ActiveForm<>nil then
    if Screen.ActiveForm is TViewer_F then
    begin
      lForm:=(Screen.ActiveForm as TViewer_F);
      with lForm do
        ShowMessage('Connected to:'+trim(lForm.Caption)+#13#10+'Host:'+viewer.Server+':'+IntToStr(viewer.Port)+#13#10+'Desktop geometry:'+IntToStr(viewer.RemoteDeskWidth)+' x '+IntToStr(viewer.RemoteDeskHeight));
    end;
end;

procedure TForm1.NewConnection1Click(Sender: TObject);
begin
  self.Show;
end;

function TForm1.ReadTimetick: Int64;
begin
end;

function TForm1.GetFileSizeDiv(lSize: LongWord): Integer;
begin
end;


end.
