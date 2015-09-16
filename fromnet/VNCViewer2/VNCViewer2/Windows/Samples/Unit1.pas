unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, VNCViewer,viewer_u, Menus, AppEvnts, ComCtrls;

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
    ApplicationEvents1: TApplicationEvents;
    N4: TMenuItem;
    FileTransfer1: TMenuItem;
    Chat1: TMenuItem;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
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
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure mFullScreenClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure ConnectionInfomation1Click(Sender: TObject);
    procedure NewConnection1Click(Sender: TObject);
    procedure VNCViewerCommandReturn(Sender: TObject);
    procedure VNCViewerDirPacketDone(Sender: TObject);
    procedure VNCViewerReceiveFileFinish(Sender: TObject);
    procedure VNCViewerReceiveFileProgress(Sender: TObject;
      Value: Integer);
    procedure VNCViewerReceiveFileStart(Sender: TObject; FileName: String;
      FileSize: Integer);
    procedure VNCViewerRequestFilePermissionDone(Sender: TObject);
    procedure VNCViewerSendFileFinish(Sender: TObject);
    procedure VNCViewerSendFileProgress(Sender: TObject; Value: Integer);
    procedure VNCViewerSendFileStart(Sender: TObject; FileName: String;
      FileSize: Integer);
    procedure VNCViewerTextChatClose(Sender: TObject);
    procedure VNCViewerTextChatMsg(Sender: TObject; Text: String);
    procedure VNCViewerTextChatOpen(Sender: TObject);
    procedure FileTransfer1Click(Sender: TObject);
    procedure Chat1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    procedure umshowfiletransfer(var msg:TMessage);message WM_USER+101;
  public
    viewer:TViewer_F;
    FCounter1:TLargeInteger;
    FCounter2:TLargeInteger;
      mvFileSizeDiv:Integer;
    function ReadTimetick:Int64;
    procedure WriteLog(msg:String);
    procedure SetOptions(lViewer:TDelphiVNCViewer);
    procedure ReadOption(lViewer:TDelphiVNCViewer);
      function GetFileSizeDiv(lSize:DWORD):Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses option_u, FileTransfer_U,ShellAPI, progress_U, Status_U, Chat_U;


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
    Viewer.ClientWidth:=FrameWidth;
    Viewer.ClientHeight:=FrameHeight;
    viewer.Constraints.MaxWidth:=Viewer.Width;
    viewer.Constraints.MaxHeight:=viewer.Height;
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
  Viewer:=TViewer_F.Create(self);
  if CheckBox2.Checked then
  begin
    viewer.Viewer.UseRepeater:=true;
    viewer.Viewer.RepeaterAddr:=Copy(edit4.Text,1,Pos(':',Edit4.Text)-1);
    viewer.Viewer.RepeaterPort:=StrToIntDef(copy(Edit4.Text,Pos(':',Edit4.Text),255),5901);
  end;
  Viewer.Viewer.OnAuthFail:=VNCViewerAuthFail;
  viewer.Viewer.OnConnectError:=VNCViewerConnectError;
  viewer.Viewer.OnConnectClose:=VNCViewerConnectClose;
  viewer.Viewer.OnConnected:=VNCViewerConnected;
  viewer.Viewer.OnFrameSize:=VNCViewerFrameSize;
  viewer.Viewer.OnHostName:=VNCViewerHostName;
  viewer.Viewer.OnStatus:=VNCViewerStatus;
  viewer.Viewer.OnTextChatOpen:=VNCViewerTextChatOpen;
  viewer.Viewer.OnTextChatClose:=VNCViewerTextChatClose;
  viewer.Viewer.OnTextChatMsg:=VNCViewerTextChatMsg;
  viewer.Viewer.OnDirPacketDone:=VNCViewerDirPacketDone;
  viewer.Viewer.OnRequestFilePermissionDone:=VNCViewerRequestFilePermissionDone;
  Viewer.Viewer.OnReceiveFileStart:=VNCViewerReceiveFileStart;
  viewer.Viewer.OnReceiveFileProgress:=VNCViewerReceiveFileProgress;
  viewer.Viewer.OnReceiveFileFinish:=VNCViewerReceiveFileFinish;
  viewer.Viewer.OnSendFileStart:=VNCViewerSendFileStart;
  viewer.Viewer.OnSendFileProgress:=VNCViewerSendFileProgress;
  viewer.Viewer.OnSendFileFinish:=VNCViewerSendFileFinish;
  viewer.viewer.OnCommandReturn:=VNCViewerCommandReturn;
  viewer.Viewer.Server:=edit1.Text;
  viewer.Viewer.Port:=StrtoIntDef(edit2.Text,5900);
  viewer.Viewer.Password:=Edit3.Text;
  SetOptions(Viewer.Viewer);
  Viewer.fullScreen:=Option_F.chkFullScreen.Checked;
  if CheckBox1.Checked then
    if ComboBox1.Text<>'' then
      viewer.Viewer.SetDSM(ExtractFilePath(Application.ExeName)+ComboBox1.Text,Edit3.Text);
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

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  s:TSearchRec;
begin
    for i:=0 to Popupmenu1.Items.count-1 do
      if Popupmenu1.items[i].Caption='-' then
       AppendMenu(GetSystemMenu(Application.Handle,false),MF_SEPARATOR,i+10,Pchar(Popupmenu1.Items[i].Caption))
      else
        AppendMenu(GetSystemMenu(Application.Handle,false),MF_STRING,i+10,Pchar(Popupmenu1.Items[i].Caption));
  if FindFirst(ExtractFilePath(Application.ExeName)+'*.dsm',faAnyFile,s)=0 then
    repeat
      ComboBox1.Items.Add(s.Name);
    until FindNext(s)<>0;
  FindClose(s);
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  item:TMenuItem;
begin
  if msg.message=WM_SYSCOMMAND then
  begin
    if loword(msg.wParam)-10<Popupmenu1.Items.Count then
    begin
      item:=Popupmenu1.Items.Items[loword(msg.wParam)-10];
      item.Click;
    end;
  end;
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
        MessageBox(handle,pchar('Connected to:'+trim(lForm.Caption)+#13#10+'Host:'+viewer.Server+':'+IntToStr(viewer.Port)+#13#10+'Desktop geometry:'+IntToStr(viewer.RemoteDeskWidth)+' x '+IntToStr(viewer.RemoteDeskHeight)),'System',MB_ICONINFORMATION+MB_OK);
    end;
end;

procedure TForm1.NewConnection1Click(Sender: TObject);
begin
  self.Show;
end;

procedure TForm1.VNCViewerCommandReturn(Sender: TObject);
var
  lfound:Boolean;
  i: Integer;
begin
  lFound:=false;
  if viewer.Viewer.FileTransfer.CurrentCommand=rfbAFileDelete then
    with FileTransfer_F do
      for I :=mvFileCount  to lvRemote.Items.Count - 1 do
        if lvRemote.Items.Item[i].Selected then
        begin
          if Integer(lvRemote.Items.Item[i].Data)=1 then
          begin
            continue;
          end
          else
          begin
            if MessageDlg('Do you sure to delete "'+lvRemote.Items.Item[i].Caption+'"?',mtConfirmation,[mbYes,mbNo],0)=mrNO then
              Continue;
            lFound:=true;
            Viewer.FileTransfer.DeleteRemoteFile(RemoteRoot+lvRemote.Items.Item[i].Caption);
          end;
          mvFileCount:=i+1;
          break;
        end;
  if not lFound then
    FileTransfer_F.SetRemotePath(FileTransfer_F.RemoteRoot);
end;

procedure TForm1.VNCViewerDirPacketDone(Sender: TObject);
var
  FileInfo: TSHFileInfo;
  I: Integer;
  lItem:TListItem;
begin
  if Assigned(FileTransfer_F) then
    with FileTransfer_F do
    begin
      if Viewer.FileTransfer.HaveItem then
      begin
        begin
          if cbRemote.Text<>'Remote Host' then
          begin
            if cbRemote.Items.IndexOf(cbRemote.Text)<0 then
              cbRemote.Items.Add(cbRemote.Text);
            RemoteRoot:=cbRemote.Text;
            SetImageList(true);
          end
          else
          begin
            if cbRemote.Items.IndexOf('Remote Host')<0 then
              cbRemote.Items.Add('Remote Host');
//            RemoteRoot:=cbRemote.Text;
            SetImageList(false);
          end;
          lvRemote.Items.BeginUpdate;
          try
            lvRemote.Items.Clear;
            for I := 0 to Viewer.FileTransfer.DirList.Count-1 do    // Iterate
            begin
              lItem:=lvRemote.Items.Add;
              lItem.SubItems.Add(Viewer.FileTransfer.DirList.Items[i].Size);
              lItem.SubItems.Add(Viewer.FileTransfer.DirList.Items[i].ModifiedTime);
              FillChar(FileInfo, SizeOf(FileInfo), #0);
              if Viewer.FileTransfer.DirList.Items[i].IsDir then
              begin
                lItem.Caption:='[ '+Viewer.FileTransfer.DirList.Items[i].DirName+' ]';
                SHGetFileInfo(Pchar(extractfilepath(application.ExeName)),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
                lItem.Data:=Pointer(1);
              end
              else
              begin
                lItem.Caption:=Viewer.FileTransfer.DirList.Items[i].DirName;
                SHGetFileInfo(Pchar(lItem.Caption),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES or SHGFI_SMALLICON);
                lItem.Data:=Pointer(2);
              end;
              lItem.ImageIndex:=FileInfo.iIcon;
              if Viewer.FileTransfer.DirList.Items[i].Size='Unknown' then
                lItem.ImageIndex:=1;
              if Viewer.FileTransfer.DirList.Items[i].Size='Local Disk' then
                lItem.ImageIndex:=2;
              if Viewer.FileTransfer.DirList.Items[i].Size='Removable' then
                lItem.ImageIndex:=0;
              if Viewer.FileTransfer.DirList.Items[i].Size='CD-ROM' then
                lItem.ImageIndex:=4;
              if Viewer.FileTransfer.DirList.Items[i].Size='Network' then
                lItem.ImageIndex:=3;
            end;    // for
          finally
            lvRemote.Items.EndUpdate;
          end;  // try/finally
        end;    // with
      end
      else
      begin
        WriteLog('No Item List!',2);
      end;
      WriteLog('Get remote Directory List Done.',1);
    end;
end;

procedure TForm1.VNCViewerReceiveFileFinish(Sender: TObject);
var
  lSize:Int64;
  lStream:TFileStream;
  lFileName:String;
  I: Integer;
  lFound:Boolean;
begin
  Progress_F.Close;
  lFound:=false;
  with FileTransfer_F do
    for I := mvFileCount to lvRemote.Items.Count - 1 do
      if lvRemote.Items.Item[i].Selected then
      begin
        if not IsExists(ListView,lvRemote.Items.Item[i].Caption) then
          continue;
        lFound:=true;
        lFileName:=cbPath.Text;
        if Copy(lFileName,length(lFileName),1)<>'\' then
          lFileName:=lFileName+'\';
        lFileName:=lFileName+lvRemote.Items.Item[i].Caption;
        if Integer(lvRemote.Items.Item[i].Data)=1 then
        begin
          //lFileName:=RemoteRoot+lvRemote.Items.Item[i].Caption;
  //        GetFile(lFileName,RemoteRoot+Copy(lvRemote.Items.Item[i].Caption,2,length(lvRemote.Items.Item[i].Caption)-2));
          mvStatus_F:=TStatus_F.Create(FileTransfer_F);
          TStatus_F(mvStatus_F).Panel1.Caption:='Please wait for server Compress the folder.....';
          mvStatus_F.Show;
          GetFile(lFileName,RemoteRoot+lvRemote.Items.Item[i].Caption);
        end
        else
          GetFile(lFileName,RemoteRoot+lvRemote.Items.Item[i].Caption);
        mvFileCount:=i+1;
        break;
      end;
  if not lFound then
  begin
    FileTransfer_F.SetPath(FileTransfer_F.LocalRoot);
    FileTransfer_F.Enabled:=true;
  end;
end;

procedure TForm1.VNCViewerReceiveFileProgress(Sender: TObject;
  Value: Integer);
begin
  Progress_F.Label2.Caption:=format('%d kBytes',[round((Value / (ReadTimetick div 1000))*1000/1024)]);
  Progress_F.Gauge1.Progress:=Value div mvFileSizeDiv;
end;

procedure TForm1.VNCViewerReceiveFileStart(Sender: TObject;
  FileName: String; FileSize: Integer);
begin
  Progress_F.Label1.Caption:='Receiving File:'+FileName;
  mvFileSizeDiv:=GetFileSizeDiv(FileSize);
  if Assigned(FileTransfer_F.mvStatus_F) then
  begin
    FileTransfer_F.mvStatus_F.Close;
    FileTransfer_F.mvStatus_F.Free;
    FileTransfer_F.mvStatus_F:=nil;
  end;
  Progress_F.Gauge1.MaxValue:=FileSize div mvFileSizeDiv;
  Progress_F.Gauge1.MinValue:=0;
  Progress_F.Gauge1.Progress:=0;
  Progress_F.Show;
  QueryPerformanceCounter(Int64((@FCounter1)^));
end;

procedure TForm1.VNCViewerRequestFilePermissionDone(Sender: TObject);
var
  oldTransferMouse:Boolean;
begin
  if not (Sender as TDelphiVNCViewer).EnabledFileTransfer then
  begin
    ShowMessage('Can''t Start File Transfer!');
    Exit;
  end;
  //(Sender as TDelphiVNCViewer).FileTransfer.RequestRemoteDriver;
//  PostMessage(Handle,WM_USER+101,0,0);
  FileTransfer_F:=TFileTransfer_F.Create(nil);
  oldTransferMouse:= Viewer.Viewer.TransferMouse;
  FileTransfer_F.Viewer:=Viewer.Viewer;
  Viewer.Viewer.RequestFreames:=false;
  FileTransfer_F.ShowModal;
  Viewer.Viewer.RequestFreames:=true;
  Viewer.Viewer.TransferMouse:=oldTransferMouse;
  FileTransfer_F.Free;
  FileTransfer_F:=nil;
end;

procedure TForm1.VNCViewerSendFileFinish(Sender: TObject);
var
  lSize:Int64;
  lStream:TFileStream;
  lFileName:String;
  I: Integer;
  lFound:Boolean;
begin
  Progress_F.Close;
  lFound:=false;
  with FileTransfer_F do
    for I := mvFileCount to ListView.Items.Count - 1 do
      if ListView.Items.Item[i].Selected then
      begin
        if not IsExists(lvRemote,ListView.items.Item[i].Caption) then
          Continue;
        lFound:=true;
        lFileName:=cbPath.Text;
        if Copy(lFileName,length(lFileName),1)<>'\' then
          lFileName:=lFileName+'\';
        lFileName:=lFileName+ListView.items.Item[i].Caption;
        if Integer(ListView.items.Item[i].Data)=1 then
        begin
//          lFileName:=lFileName+'\';
          mvStatus_F:=TStatus_F.Create(self);
          TStatus_F(mvStatus_F).Panel1.Caption:='Please wait for Compress the folder.....';
          mvStatus_F.Show;
          PutFile(lFileName,RemoteRoot);
        end
        else
          PutFile(lFileName,RemoteRoot);
        mvFileCount:=i+1;
        break;
      end;
  if not lFound then
  begin
    FileTransfer_F.SetRemotePath(FileTransfer_F.RemoteRoot);
    FileTransfer_F.Enabled:=true;
  end;
end;

procedure TForm1.VNCViewerSendFileProgress(Sender: TObject;
  Value: Integer);
begin
  Progress_F.Label2.Caption:=format('%d kBytes',[round((Value / (ReadTimetick div 1000))*1000/1024)]);
  Progress_F.Gauge1.Progress:=Value div mvFileSizeDiv;
end;

procedure TForm1.VNCViewerSendFileStart(Sender: TObject; FileName: String;
  FileSize: Integer);
begin
  Progress_F.Label1.Caption:='Send File:'+FileName;
  mvFileSizeDiv:=GetFileSizeDiv(FileSize);
  if Assigned(FileTransfer_F.mvStatus_F) then
  begin
    FileTransfer_F.mvStatus_F.Close;
    FileTransfer_F.mvStatus_F.Free;
    FileTransfer_F.mvStatus_F:=nil;
  end;
  Progress_F.Gauge1.MaxValue:=FileSize div mvFileSizeDiv;
  Progress_F.Gauge1.MinValue:=0;
  Progress_F.Gauge1.Progress:=0;
  Progress_F.Show;
  QueryPerformanceCounter(Int64((@FCounter1)^));
end;

procedure TForm1.VNCViewerTextChatClose(Sender: TObject);
begin
  if Assigned(Chat_F) then
    Chat_F.Close;
end;

procedure TForm1.VNCViewerTextChatMsg(Sender: TObject; Text: String);
var
  oldstart:Integer;
begin
  if Assigned(Chat_F) then
  begin
    TChat_F(Chat_F).edtMsg.SelStart:=9999999;
    oldstart:=TChat_F(Chat_F).edtMsg.SelStart;
    TChat_F(Chat_F).edtMsg.Lines.Add(Copy('Remote:'+text,1,length('Remote:'+text)-1));
    TChat_F(Chat_F).edtMsg.SelStart:=oldstart;
    TChat_F(Chat_F).edtMsg.SelLength:=length('Remote:'+text);
    TChat_F(Chat_F).edtMsg.SelAttributes.Color:=clblue;
    TChat_F(Chat_F).edtMsg.SelLength:=0;
    TChat_F(Chat_F).edtMsg.SelStart:=99999999;
  end;
end;

procedure TForm1.VNCViewerTextChatOpen(Sender: TObject);
begin
  if Assigned(Chat_F) then
    Exit;
  Chat_F:=TChat_F.Create(nil);
  Viewer.Viewer.RequestFreames:=false;
  TChat_F(Chat_F).Viewer:=Viewer.Viewer;
  Chat_F.ShowModal;
  Chat_F.free;
  Chat_F:=nil;
  Viewer.Viewer.RequestFreames:=true;
end;

function TForm1.ReadTimetick: Int64;
var
  Frequency:Int64;
begin
  QueryPerformanceCounter(Int64((@FCounter2)^));
  QueryPerformanceFrequency(Int64((@Frequency)^));
  Result:=Round(1000000 * (Fcounter2 -
                       FCounter1) / Frequency);
  // ///////////////////////////////////////////////////////////////////////////////////
  // Fix Div Zero Error
  // ///////////////////////////////////////////////////////////////////////////////////
  if result<1000 then
    result:=1000;
  // ///////////////////////////////////////////////////////////////////////////////////
  
end;

function TForm1.GetFileSizeDiv(lSize: DWORD): Integer;
begin
  if lSize<$7FFF then
    result := 1
  else
  if (lSize>=$7FFF) and (lSize<$7FFFFFFF) then
    result := 32768
  else if (lSize>=$7FFFFFFF) and (lSize<=$FFFFFFFF) then
    result := 65536;
end;

procedure TForm1.FileTransfer1Click(Sender: TObject);
begin
  if Assigned(Viewer) then
  begin
    if not Viewer.Viewer.EnabledChatAndFileTransfer then
    begin
      ShowMessage('Server Can''t support function');
      Exit;
    end;
    viewer.Viewer.FileTransfer.RequestPermission;
  end;
end;

procedure TForm1.Chat1Click(Sender: TObject);
begin
  if Assigned(Chat_F) then
    Exit;
  if Assigned(Viewer) then
  begin
    if not Viewer.Viewer.EnabledChatAndFileTransfer then
    begin
      ShowMessage('Server Can''t support function');
      Exit;
    end;
    Chat_F:=TChat_F.Create(nil);
    Viewer.Viewer.RequestFreames:=false;
    TChat_F(Chat_F).Viewer:=Viewer.Viewer;
    Chat_F.ShowModal;
    Chat_F.free;
    Chat_F:=nil;
    Viewer.Viewer.RequestFreames:=true;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  combobox1.Enabled:=checkbox1.Checked;
  if checkbox1.Checked then
    if combobox1.Items.Count>0 then
      combobox1.ItemIndex:=0;
end;

procedure TForm1.umshowfiletransfer(var msg: TMessage);
var
  oldTransferMouse:Boolean;
begin
  FileTransfer_F:=TFileTransfer_F.Create(nil);
  oldTransferMouse:= Viewer.Viewer.TransferMouse;
  FileTransfer_F.Viewer:=Viewer.Viewer;
  Viewer.Viewer.RequestFreames:=false;
  FileTransfer_F.ShowModal;
  Viewer.Viewer.RequestFreames:=true;
  Viewer.Viewer.TransferMouse:=oldTransferMouse;
  FileTransfer_F.Free;
  FileTransfer_F:=nil;
end;

end.
