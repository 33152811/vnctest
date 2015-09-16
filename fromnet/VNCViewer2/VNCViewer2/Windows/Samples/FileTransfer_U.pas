unit FileTransfer_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ToolWin,ShlObj, ImgList,Menus,VNCViewer;

const
  UM_CONNECT=WM_USER+101;  

type
  
  TFileTransfer_F = class(TForm)
    ToolbarImages: TImageList;
    ImageList1: TImageList;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PutDirectory1: TMenuItem;
    Get1: TMenuItem;
    ListBox1: TListBox;
    Panel1: TPanel;
    Splitter2: TSplitter;
    Panel2: TPanel;
    ListView: TListView;
    Panel3: TPanel;
    cbPath: TComboBox;
    ToolBar1: TToolBar;
    btnBrowse: TToolButton;
    btnBack: TToolButton;
    ToolButton3: TToolButton;
    btnLargeIcons: TToolButton;
    btnSmallIcons: TToolButton;
    btnList: TToolButton;
    btnReport: TToolButton;
    ToolButton9: TToolButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    cbRemote: TComboBox;
    ToolBar2: TToolBar;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    Panel7: TPanel;
    lvRemote: TListView;
    Splitter1: TSplitter;
    ImageList3: TImageList;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    Delete2: TMenuItem;
    Rename2: TMenuItem;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    CreateDirectory1: TMenuItem;
    tbtnNewFolder: TToolButton;
    procedure Rename2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnBackClick(Sender: TObject);
    procedure cbPathClick(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure PutDirectory1Click(Sender: TObject);
    procedure Get1Click(Sender: TObject);
    procedure cbRemoteClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure lvRemoteDblClick(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure cbRemoteKeyPress(Sender: TObject; var Key: Char);
    procedure cbPathKeyPress(Sender: TObject; var Key: Char);
    procedure btnLargeIconsClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CreateDirectory1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AppException(Sender:TObject;E:Exception);
  public
    { Public declarations }
    ServerAddr:String;
    Password:String;
    RemoteRoot:String;
    LocalRoot:String;
    LastLoginFail:Boolean;
    LastConnectFail:Boolean;
    Viewer:TDelphiVNCViewer;
    mvStatus_F:TForm;
    mvFileCount:Integer;
    function GetUpDir:String;
    function GetLocalUpDir:String;
    procedure GetDrive;
    procedure GetLocalDrive;
    procedure SetRemotePath(path:String);
    procedure SetPath(Value: string); 
    procedure SetImageList(Value:Boolean);
    procedure SetlocalImageList(Value:Boolean);
    procedure AddRemoteItem(pCaption:String;IsDir:Integer;pSize:String;pTime:String);
    procedure AddLocalItem(pCaption:String;IsDir:Integer;pSize:String;pTime:String);
    procedure PutFile(LocalName:String;RemoteName:String);
    procedure PutDir(LocalDir:String);
    procedure GetFile(LocalName:String;RemoteName:String);
    procedure GetDir(RemoteDir:String);
    procedure WriteLog(msg:String;Level:Integer);
    function IsExists(lv:TListView;Name:string):Boolean;
  end;

var
  FileTransfer_F: TFileTransfer_F;

implementation


{$R *.dfm}
uses ShellAPI, ActiveX, ComObj, CommCtrl, FileCtrl,
  progress_U, StringCommon, Status_U;

//PIDL MANIPULATION

procedure TFileTransfer_F.AddLocalItem(pCaption: String; IsDir: Integer;pSize:String;pTime:String);
var
  FileInfo: TSHFileInfo;
  lItem:TListItem;
begin
  lItem:=ListView.Items.Add;
  lItem.Caption:=pCaption;
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  if IsDir=1 then
    litem.Data:=Pointer(1)
  else
    litem.Data:=Pointer(0);
  if IsDir=1 then   //取目录图标
    SHGetFileInfo(Pchar(extractfilepath(application.ExeName)),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON)
  else//取文件图标
    SHGetFileInfo(Pchar(pCaption),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES or SHGFI_SMALLICON);
  lItem.ImageIndex:=FileInfo.iIcon;
  litem.SubItems.Add(pSize+'KB');
  litem.SubItems.Add(pTime);
end;

procedure TFileTransfer_F.AddRemoteItem(pCaption: String; IsDir: Integer;pSize:String;pTime:String);
var
  FileInfo: TSHFileInfo;
  lItem:TListItem;
begin
  lItem:=lvRemote.Items.Add;
  lItem.Caption:=pCaption;
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  if IsDir=1 then
    litem.Data:=Pointer(1)
  else
    litem.Data:=Pointer(0);
  if IsDir=1 then   //取目录图标
    SHGetFileInfo(Pchar(extractfilepath(application.ExeName)),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON)
  else//取文件图标
    SHGetFileInfo(Pchar(pCaption),0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES or SHGFI_SMALLICON);
  lItem.ImageIndex:=FileInfo.iIcon;
  litem.SubItems.Add(pSize+'KB');
  litem.SubItems.Add(pTime);
end;

procedure TFileTransfer_F.AppException(Sender: TObject; E: Exception);
begin
  WriteLog('Application Error:'+e.Message,2);
end;

procedure TFileTransfer_F.btnBackClick(Sender: TObject);
begin
  if LocalRoot='\\' then
  begin
    beep();
    exit;
  end;
  if length(LocalRoot)=3 then
  begin
    LocalRoot:='\\';
    GetLocalDrive;
  end
  else
    SetPath(GetLocalUpDir);
end;

procedure TFileTransfer_F.btnBrowseClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if SelectDirectory('Select Directory', '', S) then
  begin
    SetlocalImageList(true);
    SetPath(S);
  end;
end;

procedure TFileTransfer_F.btnLargeIconsClick(Sender: TObject);
begin
  ListView.ViewStyle := TViewStyle((Sender as TComponent).Tag);
end;

procedure TFileTransfer_F.cbPathClick(Sender: TObject);
begin
  if cbPath.Text='Local Host' then
    GetLocalDrive
  else
  begin
    SetLocalImageList(true);
    SetPath(cbpath.Text);
  end;
end;

procedure TFileTransfer_F.cbPathKeyPress(Sender: TObject; var Key: Char);
begin
  key:=#0;
end;

procedure TFileTransfer_F.cbRemoteClick(Sender: TObject);
begin
  if cbRemote.Text='Remote Host' then
  begin
    cbRemote.Text:='Remote Host';
    RemoteRoot:='';
    GetDrive;
  end
  else
  begin
    SetImageList(true);
    SetRemotePath(cbRemote.Text);
  end;
end;

procedure TFileTransfer_F.cbRemoteKeyPress(Sender: TObject; var Key: Char);
begin
  key:=#0;
end;

procedure TFileTransfer_F.Delete1Click(Sender: TObject);
begin
  if ListView.Selected=nil then
    Exit;
  if MessageBox(handle,'Confirm Delete the file or Direcotry?','System',MB_ICONQUESTION+MB_YESNO)=IDNO then
    Exit;
  if Integer(ListView.Selected.Data)=1 then
    DeleteDir(LocalRoot+ListView.Selected.Caption)
  else
    DeleteFile(LocalRoot+ListView.Selected.Caption);
  SetPath(LocalRoot);
end;

procedure TFileTransfer_F.Delete2Click(Sender: TObject);
var
  lSize:Int64;
  lStream:TFileStream;
  lFileName:String;
  I: Integer;
begin
  if lvRemote.Selected=nil then
    Exit;
  for I := 0 to lvRemote.Items.Count - 1 do
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
          Viewer.FileTransfer.DeleteRemoteFile(RemoteRoot+lvRemote.Items.Item[i].Caption);
      end;
      mvFileCount:=i+1;
      break;
    end;
end;

procedure TFileTransfer_F.FormCreate(Sender: TObject);
begin
  LastLoginFail:=false;
  LastConnectFail:=false;
  Application.OnException:=AppException;
  RemoteRoot:='';
  cbRemote.Text:='Remote Host';
  GetLocalDrive;
end;

procedure TFileTransfer_F.FormResize(Sender: TObject);
begin
  Panel2.Width:=Width div 2;
end;

procedure TFileTransfer_F.Get1Click(Sender: TObject);
var
  lSize:Int64;
  lStream:TFileStream;
  lFileName:String;
  I: Integer;
begin
  if lvRemote.Selected=nil then
    Exit;
  if cbPath.Text='Local Host' then
  begin
    ShowMessage('Error Directory to Get File!');
    Exit;
  end;
  for I := 0 to lvRemote.Items.Count - 1 do
    if lvRemote.Items.Item[i].Selected then
    begin
      if not IsExists(ListView,lvRemote.Items.Item[i].Caption) then
        continue;
      Self.Enabled:=false;
      lFileName:=cbPath.Text;
      if Copy(lFileName,length(lFileName),1)<>'\' then
        lFileName:=lFileName+'\';
      lFileName:=lFileName+lvRemote.Items.Item[i].Caption;
      if Integer(lvRemote.Items.Item[i].Data)=1 then
      begin
        //lFileName:=RemoteRoot+lvRemote.Items.Item[i].Caption;
//        GetFile(lFileName,RemoteRoot+Copy(lvRemote.Items.Item[i].Caption,2,length(lvRemote.Items.Item[i].Caption)-2));
        mvStatus_F:=TStatus_F.Create(self);
        TStatus_F(mvStatus_F).Panel1.Caption:='Please wait for server Compress the folder.....';
        mvStatus_F.Show;
        GetFile(lFileName,RemoteRoot+lvRemote.Items.Item[i].Caption);
      end
      else
        GetFile(lFileName,RemoteRoot+lvRemote.Items.Item[i].Caption);
      mvFileCount:=i+1;
      break;
    end;
end;

procedure TFileTransfer_F.GetDir(RemoteDir: String);
var
  FileInfo: TSHFileInfo;
  rtstr:String;
  fl:StringArray;
  fi:StringArray;
  I: Integer;
  lLocalName:String;
begin
end;

procedure TFileTransfer_F.GetDrive;
var
  rtstr:String;
  Dg:StringArray;
  ds:StringArray;
  I: Integer;
  lItem:TListItem;
begin
  SetImageList(false);
  Viewer.FileTransfer.RequestRemoteDriver;
end;

procedure TFileTransfer_F.GetFile(LocalName, RemoteName: String);
var
  lSize:Int64;
  lStream:TFileStream;
  ldir:StringArray;
  tmpdir:String;
  I: Integer;
begin
  Viewer.FileTransfer.RequestRemoteFile(RemoteName,ExtractFilePath(LocalName));
end;

procedure TFileTransfer_F.GetLocalDrive;
var
  I: Integer;
  dn:String;
  rtstr:String;
  dt:Integer;
  lItem:TListItem;
begin
  rtstr:='';
  dn:='CDEFGHIJKLMNOPQRSTUVWXYZ';
  SetlocalImageList(false);
  LocalRoot:='\\';
  if cbPath.Items.IndexOf('Local Host')<0 then
    cbPath.Items.Add('Local Host');
  cbPath.Text:='Local Host';
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;
  try
    for I := 1 to 24 do    // Iterate
    begin
      dt:=GetDriveType(pchar(Copy(dn,i,1)+':'));
      if (dt=2) or (dt=3) or (dt=4) or (dt=5) then
      begin
        litem:=ListView.Items.Add;
        lItem.Caption:=Copy(dn,i,1)+':\';
        lItem.Data:=Pointer(1);
        lItem.ImageIndex:=dt-1;
      end;
    end;    // for
  finally
    ListView.Items.EndUpdate;
  end;
end;

function TFileTransfer_F.GetLocalUpDir: String;
var
  ltmp:StringArray;
  I: Integer;
begin
  result:='';
  if LocalRoot='\\' then
    Exit;
  ltmp:=split(Copy(LocalRoot,1,length(LocalRoot)-1),'\');
  for I := 0 to High(ltmp) - 1 do
    Result:=Result+ltmp[i]+'\';
end;

function TFileTransfer_F.GetUpDir: String;
var
  ltmp:StringArray;
  I: Integer;
begin
  result:='';
  if RemoteRoot='' then
    Exit;
  ltmp:=split(Copy(RemoteRoot,1,length(RemoteRoot)-1),'\');
  for I := 0 to High(ltmp) - 1 do
    Result:=Result+ltmp[i]+'\';
end;

function TFileTransfer_F.IsExists(lv: TListView; Name: string): Boolean;
var
  I: Integer;
begin
  Result:=true;
  for I := 0 to lv.Items.Count - 1 do
    if lv.Items.Item[i].Caption=Name then
    begin
      Result:=(MessageBox(Handle,'File or Directory is Exists,Do you want to Overwrite?','System',MB_ICONWARNING+MB_YESNO)=IDYES);
      break;
    end;
end;

procedure TFileTransfer_F.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   x,y:integer;
   myicon:TBitMap;
   R,R1:TRect;
   myfont:TFont;
begin
     myicon:=TBitMap.Create;
     myfont:=TFont.Create;
     ImageList3.GetBitmap(Integer(ListBox1.Items.Objects[index]),MyIcon);
     R.Left:=0;
     R.Top:=Rect.Top;
     R.Right:=MyIcon.Width;
     R.Bottom:=MyIcon.Height+Rect.Top;
     R1.Left:=0;
     R1.Top:=0;
     R1.Right:=MyIcon.Width;
     R1.Bottom:=MyIcon.Height;
     with ListBox1.Canvas do
     begin
           case integer(ListBox1.Items.Objects[index]) of    //
             0: Brush.Color:=$009CFF9C;
             1: Brush.Color:=$00EFEFAD;
             2: Brush.Color:=$00CEC6FF;
             3: Brush.Color:=$00FFE7E7;
           end;    // case
                copymode:=cmsrcCopy;
                FillRect(Rect);
                CopyRect(R,MyIcon.Canvas,R1);
                x:=Rect.Left;
                y:=Rect.Top;
                MyFont.Assign(Font);
                myfont.Size:=9;
                myfont.Style:=[fsbold];
                myfont.Color:=RGB(0,0,0);
                font.Assign(Myfont);;
                TextOut(x+20,y,Listbox1.Items[Index]);
     end;
     MyIcon.free;
     myfont.Free;
end;

procedure TFileTransfer_F.ListViewDblClick(Sender: TObject);
var
  lItem:TListItem;
begin
  lItem:=ListView.Selected;
  if lItem=nil then
    Exit;
  if Integer(lItem.Data)=1 then
  begin
    if LocalRoot='\\' then
    begin
      SetLocalImageList(true);
      SetPath(litem.Caption);
    end
    else
    begin
      if litem.Caption='..' then
      begin
        SetPath(GetLocalUpDir);
      end
      else
        SetPath(LocalRoot+litem.Caption);
    end;
  end;
end;

procedure TFileTransfer_F.lvRemoteDblClick(Sender: TObject);
var
  lItem:TListItem;
begin
  lItem:=lvRemote.Selected;
  if lItem=nil then
    Exit;
  if Integer(lItem.Data)=1 then
  begin
//    if RemoteRoot='\\' then
//    begin
//      SetRemotePath(litem.Caption);
//    end
//    else
//    begin
      if litem.Caption='[ .. ]' then
      begin
        SetRemotePath(GetUpDir);
      end
      else
        SetRemotePath(RemoteRoot+Copy(litem.Caption,3,length(lItem.Caption)-4));
//    end;
  end;
end;


procedure TFileTransfer_F.PutDir(LocalDir: String);
var
  F:TSearchRec;
  lRemoteFile:String;
  lPos:Integer;
begin
  if FindFirst(LocalDir+'*.*',faAnyFile,F)=0 then
    repeat
      if (F.Name<>'.') and (F.Name<>'..') then
      begin
       if F.attr and faDirectory<>faDirectory then
       begin
          lRemoteFile:=RemoteRoot+Copy(LocalDir,length(LocalRoot)+1,255)+F.Name;
          PutFile(LocalDir+F.Name,lRemoteFile);
       end
       else
        PutDir(LocalDir+F.Name+'\');
      end;
    until FindNext(F)<>0;
end;

procedure TFileTransfer_F.PutDirectory1Click(Sender: TObject);
var
  lSize:Int64;
  lStream:TFileStream;
  lFileName:String;
  I: Integer;
begin
  if ListView.Selected=nil then
    Exit;
  if cbRemote.Text='Remote Host' then
  begin
    ShowMessage('Error Directory to Get File!');
    Exit;
  end;
  for I := 0 to ListView.Items.Count - 1 do
    if ListView.Items.Item[i].Selected then
    begin
      if not IsExists(lvRemote,ListView.items.Item[i].Caption) then
        Continue;
      Self.Enabled:=false;
      lFileName:=cbPath.Text;
      if Copy(lFileName,length(lFileName),1)<>'\' then
        lFileName:=lFileName+'\';
      lFileName:=lFileName+ListView.items.Item[i].Caption;
      if Integer(ListView.items.Item[i].Data)=1 then
      begin
        //lFileName:=lFileName+'\';
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
  //SetRemotePath(RemoteRoot);
end;

procedure TFileTransfer_F.PutFile(LocalName:String;RemoteName:String);
var
  lSize:Int64;
  lStream:TFileStream;
begin
  WriteLog('Begining Put file '+LocalName +'...',1);
  Viewer.FileTransfer.OfferLocalFile(LocalName,RemoteName);
  //WriteLog('Put File done.',3);
end;

procedure TFileTransfer_F.Rename1Click(Sender: TObject);
var
  lStr:String;
begin
  if ListView.Selected=nil then
    Exit;
  lstr:=ListView.Selected.Caption;
  if InputQuery('New Name','New Name:',lStr) then
    if not StringCommon.ReNameFile(LocalRoot+ListView.Selected.Caption,LocalRoot+lStr) then
      WriteLog('Error Reanme the File or Directory!',2);
  SetPath(LocalRoot);
end;

procedure TFileTransfer_F.Rename2Click(Sender: TObject);
var
  lStr:String;
begin
  if lvRemote.Selected=nil then
    Exit;
  if Integer(lvRemote.Selected.Data)=1 then
  begin
    lstr:=Copy(lvRemote.Selected.Caption,3,length(lvRemote.Selected.Caption)-4);
    if InputQuery('New Name','New Name:',lStr) then
    begin
      if lStr=Copy(lvRemote.Selected.Caption,3,length(lvRemote.Selected.Caption)-4) then
        Exit;
      Viewer.FileTransfer.RenameRemoteFileOrDirectory(RemoteRoot+Copy(lvRemote.Selected.Caption,3,length(lvRemote.Selected.Caption)-4),RemoteRoot+lStr);
    end;
  end
  else
  begin
    lstr:=lvRemote.Selected.Caption;
    if InputQuery('New Name','New Name:',lStr) then
    begin
      if lStr=lvRemote.Selected.Caption then
        Exit;
      Viewer.FileTransfer.RenameRemoteFileOrDirectory(RemoteRoot+lvRemote.Selected.Caption,RemoteRoot+lStr);
    end;
  end;
end;

procedure TFileTransfer_F.SetImageList(Value:Boolean);
var
  FileInfo: TSHFileInfo;
  ImageListHandle: THandle;
begin
  if Value then
  begin
    ImageListHandle := SHGetFileInfo('C:\',
                             0,
                             FileInfo,
                             SizeOf(FileInfo),
                             SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    SendMessage(lvRemote.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);

    ImageListHandle := SHGetFileInfo('C:\',
                             0,
                             FileInfo,
                             SizeOf(FileInfo),
                             SHGFI_SYSICONINDEX or SHGFI_LARGEICON);

    SendMessage(lvRemote.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);
  end
  else
  begin
    SendMessage(lvRemote.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageList1.Handle);
    SendMessage(lvRemote.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageList2.Handle);
  end;
end;


procedure TFileTransfer_F.SetlocalImageList(Value: Boolean);
var
  FileInfo: TSHFileInfo;
  ImageListHandle: THandle;
begin
  if Value then
  begin
    ImageListHandle := SHGetFileInfo('C:\',
                             0,
                             FileInfo,
                             SizeOf(FileInfo),
                             SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);

    ImageListHandle := SHGetFileInfo('C:\',
                             0,
                             FileInfo,
                             SizeOf(FileInfo),
                             SHGFI_SYSICONINDEX or SHGFI_LARGEICON);

    SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);
  end
  else
  begin
    SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageList1.Handle);
    SendMessage(ListView.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageList2.Handle);
  end;
end;

procedure TFileTransfer_F.SetRemotePath(path: String);
var
  FileInfo: TSHFileInfo;
  rtstr:String;
  fl:StringArray;
  fi:StringArray;
  I: Integer;
  lpath:String;
  lItem:TListItem;
begin
  lpath:=path;
  WriteLog('Begining Get remote Directory List ...',1);
  if Copy(lpath,length(lpath),1)<>'\' then
    lpath:=lpath+'\';
  cbRemote.Text:=lpath;
  Viewer.FileTransfer.RequestRemoteDirectoryContent(lpath);
end;

procedure TFileTransfer_F.SetPath(Value: string);
var
  st:SystemTime;
  lst:TDateTime;
  F:TSearchRec;
  isdir:Integer;
  lDir:String;
  litem:TListItem;
  FileInfo: TSHFileInfo;
begin
  lDir:=Value;
  if Copy(lDir,length(lDir),1)<>'\' then
    lDir:=lDir+'\';
  if cbPath.Items.IndexOf(lDir)<0 then
    cbPath.Items.Add(lDir);
  cbPath.Text:=lDir;
  LocalRoot:=lDir;
  lDir:=lDir+'*.*';
  ListView.Items.BeginUpdate;
  ListView.Items.Clear;
  try
    if FindFirst(lDir,faDirectory,F)=0 then
      repeat
        if (F.Name<>'.') then
        begin
         if F.attr and faDirectory<>faDirectory then
            Continue;
          FileTimeToSystemTime(F.FindData.ftLastWriteTime,st);
          lst:=EncodeDate(st.wYear,st.wMonth,st.wDay)+EncodeTime(st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
          AddLocalItem(F.Name,1,IntToStr(F.Size div 1024),DateTimeToStr(lst));
        end;
      until FindNext(F)<>0;
    if FindFirst(lDir,faDirectory,F)=0 then
      repeat
        if (F.Name<>'.') then
        begin
         if F.attr and faDirectory=faDirectory then
            Continue;
          FileTimeToSystemTime(F.FindData.ftLastWriteTime,st);
          lst:=EncodeDate(st.wYear,st.wMonth,st.wDay)+EncodeTime(st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
          AddLocalItem(F.Name,0,IntToStr(F.Size div 1024),DateTimeToStr(lst));
        end;
      until FindNext(F)<>0;
    FindClose(F);
  finally
    ListView.Items.EndUpdate;
  end;
end;


procedure TFileTransfer_F.ToolButton2Click(Sender: TObject);
begin
  if RemoteRoot='' then
  begin
    beep();
    exit;
  end;
  if length(RemoteRoot)=3 then
  begin
    cbRemote.Text:='Remote Host';
    RemoteRoot:='';
    GetDrive;
  end
  else
    SetRemotePath(GetUpDir);
end;

procedure TFileTransfer_F.ToolButton5Click(Sender: TObject);
begin
  lvRemote.ViewStyle := TViewStyle((Sender as TComponent).Tag);
end;

procedure TFileTransfer_F.WriteLog(msg: String; Level: Integer);
begin
  ListBox1.ItemIndex:=ListBox1.Items.AddObject(msg,TObject(Level));
  Application.ProcessMessages;
end;

procedure TFileTransfer_F.FormShow(Sender: TObject);
begin
  GetDrive;
end;

procedure TFileTransfer_F.CreateDirectory1Click(Sender: TObject);
var
  lstr:String;
begin
  if InputQuery('Directory Name','Directory Name',lStr) then
    Viewer.FileTransfer.CreateRemoteDirectory(RemoteRoot+lStr);
end;

end.
