unit Main;

interface

uses
  Windows,  SysUtils, Graphics, Forms,  StdCtrls, Buttons,
  IdHTTP, Controls,mmsystem,ExtCtrls, Classes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, ShellApi,Messages, Menus;

  const WM_NOTIFYTRAYICON = WM_USER + 1;
type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Button5: TButton;
    Button6: TButton;
    Timer1: TTimer;
    IdHTTP1: TIdHTTP;
    LB1: TListBox;
    LB2: TListBox;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    Start1: TMenuItem;
    procedure MyRepaint;
    procedure MyBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ma2(mstr:string;mstr1:string);
    procedure Timer1Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Analiz(S: String);
    procedure LB1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LB1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LB1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LB2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure LB1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Panel1MouseEnter(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure LB2MouseEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    Procedure WMSysCommand(var message: TWMSysCommand); message WM_SysCommand;
    procedure My(var mes:TWMACTIVATE); message WM_ACTIVATE;
    procedure Close1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    procedure WMTRAYICONNOTIFY(var Msg: TMessage);
    message WM_NOTIFYTRAYICON;
  end;

  TMyThread = class(TThread)
  s:string;
  private
    procedure Repaint;
  protected
    procedure Execute; override;
  end;

var
  MainForm: TMainForm;
  mss:tstringlist;
  lt:TTime;
  tray: TNotifyIconData;
  TrayIcon: TIcon;
implementation

{$R *.dfm}

procedure TMainForm.Analiz(S: String);
var
  NewThread: TMyThread;
begin
  NewThread:=TMyThread.Create(true);
  NewThread.FreeOnTerminate:=true;
  NewThread.Priority:=tpLower;
  NewThread.s:=s;
  NewThread.Resume;
end;



procedure TMainForm.FormCreate(Sender: TObject);
Var i,p:integer;
  s:string;
begin
  TrayIcon := Application.Icon;
  with tray do begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := MainForm.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallBackMessage := WM_NOTIFYTRAYICON;
    hIcon := TrayIcon.Handle;
    szTip := 'RB monitor';
    end;
  Shell_NotifyIcon(NIM_ADD, Addr(tray));

  mss:=tstringlist.Create;
  mss.LoadFromFile('rb.txt');
  lt:=time;
  for i := 0 to mss.Count - 1 do Begin
    s:=mss[i];
    p:=pos('=',s);
    if s[p-1]='+' then  LB1.Items.Add(inttostr(i)+'='+mss.ValueFromIndex[i]);
    LB2.Items.Add(copy(s,1,p-3));
    End;
end;



procedure TMainForm.FormDestroy(Sender: TObject);
begin
  try
    with tray do begin
      cbSize := SizeOf(TNotifyIconData);
      Wnd := MainForm.Handle;
      uID := 1;
      end;
    Shell_NotifyIcon(NIM_DELETE, Addr(tray));
    finally
      Application.Terminate;
    end;
end;

procedure TMainForm.LB1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ID: integer;
  s:String;
begin
  if (Sender is TListbox) and (Source is TListBox) then
  begin
    ID:=TListBox(Source).ItemIndex;

    if TListBox(Sender).Items.IndexOfName(TListBox(Source).Items[ID])=-1 then Begin
      TListBox(Sender).Items.Add(InttoStr(ID)+'='+mss.ValueFromIndex[ID]);
      s:=mss[ID];
      s[pos('=',s)-1]:='+';
      mss[ID]:=s;
      End;
  end;

end;

procedure TMainForm.LB1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Sender is TListBox;
end;

procedure TMainForm.LB1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var s:string;
  ID:integer;
  MyLog:Tstrings;
begin
  with (Control as TListBox) do with Canvas do
  begin
    Brush.Color := clSkyBlue;
    if Index mod 2=0 then Begin
      Brush.Color := clMoneyGreen;
      Font.Color := clBlue;

      End else Begin
      Brush.Color := clSkyBlue;
      Font.Color := clGreen;

      End;
      FillRect(Rect);
      s:=TListBox(Control).Items[Index];
      //s:=copy(mss[m],1,length(mss[m])-2);
      if TListBox(Control).Name='LB2' then Begin

        TextOut(Rect.Left, Rect.Top,InttoStr(Index));
        TextOut(Rect.Left+TextWidth('WW'), Rect.Top,copy(s,1,length(s)-3));
        TextOut(Rect.Right-TextWidth('WW'), Rect.Top,copy(s,length(s)-1,2));
        s:=Mss.ValueFromIndex[Index];
        if s='Dead' then Font.Color := clRed Else Font.Color:=ClLime;
        if s='Unknown' then Font.Color := clBlack;
        TextOut(Rect.Right-TextWidth('WWWWWWW'), Rect.Top,s);
        End Else Begin
        TextOut(Rect.Left, Rect.Top,InttoStr(Index));
        //TextOut(Rect.Left+TextWidth('WW'), Rect.Top,Items[Index]);
        ID:=StrToInt(Items.Names[Index]);
        s:=Mss.Names[ID];

        //i:=pos('=',s);
        TextOut(Rect.Left+TextWidth('WW'), Rect.Top,copy(s,1,length(s)-5));
        //TextOut(Rect.Right-TextWidth('WWWW'), Rect.Top,copy(s,i-2,2));
        TextOut(Rect.Right-TextWidth('WW'), Rect.Top,copy(s,length(s)-3,2));
        //s:=Mss.ValueFromIndex[StrToInt(copy(s,i+1,length(s)-i+1))];
        s:=Mss.ValueFromIndex[ID];
        //SetVolume(14000,14000);
        if (s<>'Unknown') and (Items.ValueFromIndex[Index]<>'Unknown') and (s<>Items.ValueFromIndex[Index]) then Begin
          PlaySound('Sound.wav',0,SND_ASYNC);
          MyLog:=TstringList.Create;
          MyLog.LoadFromFile('Rb.log');
          MyLog.Add(FormatDateTime('[dd.mm.yyyy hh:nn] ',now)+copy(mss.Names[ID],1,length(mss.Names[ID])-5)+' ['+s+']');
          MyLog.SaveToFile('Rb.log');
          MyLog.Free;
          End;
        if s<>Items.ValueFromIndex[Index] then Items.ValueFromIndex[Index]:=s;
        if s='Dead' then Font.Color := clRed Else Font.Color:=ClLime;
        if s='Unknown' then Font.Color := clBlack;
        TextOut(Rect.Right-TextWidth('WWWWWWW'), Rect.Top,Mss.ValueFromIndex[ID]);
        End;

  end;
end;

procedure TMainForm.LB1EndDrag(Sender, Target: TObject; X, Y: Integer);
Var ID:integer;
  s:String;
begin
  if Target<>nil then

  With TListBox(Sender) do Begin
    ID:=StrToInt(Items.Names[ItemIndex]);
    s:=mss[ID];
    s[pos('=',s)-1]:='-';
    mss[ID]:=s;
    Items.Delete(ItemIndex);
    End;
end;

procedure TMainForm.LB2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if TListBox(Sender).Name='LB1' Then Accept:=True;
end;

procedure TMainForm.LB2MouseEnter(Sender: TObject);
begin
  MainForm.Height:=320;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
Var i:integer;
begin
  Timer1.Enabled:=false;
  for i := 0 to mss.Count - 1 do mss.ValueFromIndex[i]:='Unknown';
  mss.SaveToFile('rb.txt');
  mss.Free;
end;



procedure TMainForm.Ma2;
begin
    //sq:='INSERT INTO statrb (Name,Lvl,Ltime,Status,inf) VALUES ('''+copy(mstr,1,length(mstr)-3)+''','+copy(mstr,length(mstr)-1,2)+','''+FormatDateTime('yyyy.mm.dd hh:nn',Now)+''',';
    //if mstr1='Alive' then sq:=sq+'1,'''+mstr1+''')' else sq:=sq+'0,'''+mstr1+''')';
    //Memo1.Lines.Add('['+FormatDateTime('yyyy.mm.dd hh:nn',Now)+'] '+mstr+' - '+mstr1);
end;

procedure TMainForm.My(var mes: TWMACTIVATE);
begin
  if mes.Active=WA_INACTIVE then
  ShowWindow(MainForm.Handle, SW_HIDE)
end;

procedure TMainForm.MyBtnClick(Sender: TObject);
begin
  With Sender as TButton do Analiz(Caption);
end;

procedure TMainForm.MyRepaint;
begin
  LB1.Repaint;
  LB2.Repaint;
end;

procedure TMainForm.Panel1MouseEnter(Sender: TObject);
begin
  Panel1.Height:=33;
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
  if Timer1.Enabled then Start1.Caption:='Stop'
    Else Start1.Caption:='Start';
end;

procedure TMainForm.Start1Click(Sender: TObject);
begin
  Button5.Click;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
Var i:integer;
begin
  if TimeToStr(lt-now)>='0:03:00' then Begin
    lt:=time;
    Button6.Click;
    End;
    Caption:='RB monitor [ON]['+ FormatDateTime('nn:ss',(StrToTime('00:03:00')+lt-Time))+']';
end;



procedure TMainForm.Timer2Timer(Sender: TObject);
begin
  if (Mouse.CursorPos.Y-Top-Panel1.Top-30>33)
    or (Mouse.CursorPos.Y<Top)
  then Panel1.Height:=3;
  if
  (Mouse.CursorPos.Y-Top-LB2.Top-30>LB2.Height)
    or
    (Mouse.CursorPos.Y-Top-30<LB2.Top)
  then MainForm.Height:=200;;

end;

procedure TMainForm.WMSysCommand(var message: TWMSysCommand);
begin
  If (message.CmdType = (SC_MINIMIZE or SC_CLOSE)) then
    ShowWindow(MainForm.Handle, SW_HIDE)
    else Inherited;
end;

procedure TMainForm.WMTRAYICONNOTIFY(var Msg: TMessage);
begin
  case Msg.LParam of
    WM_LBUTTONDOWN: Begin
      SetForeGroundWindow(MainForm.Handle);
      ShowWindow(MainForm.Handle, SW_RESTORE);
      SetActiveWindow(MainForm.Handle);
      End;
    //WM_LBUTTONDBLCLK: {ваш код обработки события двойного нажатия на левую кнопку мыши}
    //WM_LBUTTONUP: {ваш код обработки события отпускания левой кнопки мыши}

    WM_RBUTTONDOWN: PopupMenu1.Popup(Mouse.CursorPos.x,Mouse.CursorPos.y);
    //WM_RBUTTONDBLCLK: ShowWindow(MainForm.Handle,SW_Show);
    //WM_RBUTTONUP: {ваш код}

    //WM_MOUSEMOVE: {ваш код}
    end;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  Timer1.Enabled:= Not Timer1.Enabled;
  if Timer1.Enabled then Button6.Click
    Else Begin
      Caption:='RB monitor [OFF]';
      End;
end;

procedure TMainForm.Button6Click(Sender: TObject);
Var
  fl1,fl2,fl3,fl4:boolean;
  i:integer;
begin
  fl1:=False;
  fl2:=False;
  fl3:=False;
  fl4:=False;
  for i := 0 to LB1.Count - 1 do
    case StrToint(LB1.Items.Names[i]) of
      0..49: fl1:=true;
      50..95: fl2:=true;
      96..152: fl3:=true;
      Else fl4:=true;
      end;
  if fl1 then Analiz('1');
  if fl2 then Analiz('2');
  if fl3 then Analiz('3');
  if fl4 then Analiz('4');
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

{ TMyThread }

procedure TMyThread.Execute;
Var MyHTTP: TIdHTTP;
var
  i:integer;
  MyS:string;
  ms1:tstringlist;
begin
  MyHTTP:=TIdHTTP.Create;
  MyS:=MyHTTP.Get('http://lineage2.cybernet.by/index.php?view=boss&num='+s);
  if MyHTTP.Connected then Begin
    ms1:=tstringlist.Create;
    if (pos('<tbody>',MyS)<>0)and(pos('</tbody>',MyS)<>0) then
      MyS:=copy(MyS,pos('<tbody>',MyS),pos('</tbody>',MyS)-pos('<tbody>',MyS)+8);
    while pos(#9,MyS)<>0 do delete(MyS,pos(#9,MyS),1);
    while pos(#60,MyS)<>0 do delete(MyS,pos(#60,MyS),pos(#62,MyS)-pos(#60,MyS)+1);
    ms1.Text:=MyS;
    i:=0;
    while (i<=ms1.Count-1) do begin
      if not((ms1[i]='Alive') xor (ms1[i]='Dead')) then ms1.Delete(i);
      if  (i<ms1.Count-1) and ((ms1[i]='Alive') xor (ms1[i]='Dead')) then inc(i);
      end;

    if s='1' then for i := 0 to ms1.Count - 1 do mss.ValueFromIndex[i]:=ms1[i];
    if s='2' then for i := 0 to ms1.Count - 1 do mss.ValueFromIndex[50+i]:=ms1[i];
    if s='3' then for i := 0 to ms1.Count - 1 do mss.ValueFromIndex[96+i]:=ms1[i];
    if s='4' then for i := 0 to ms1.Count - 1 do mss.ValueFromIndex[153+i]:=ms1[i];
    ms1.Free;

    End;
    MyHTTP.Free;
  Synchronize(Repaint);
  Terminate;
  inherited;
end;

procedure TMyThread.Repaint;
begin
  MainForm.MyRepaint;
end;

end.
