unit MsbForm;


interface
                         
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,  
  Gauges, ToolWin, Buttons, ImgList,DateUtils, Menus,
  msbu, Spin, Tabs, DockTabSet, ButtonGroup, ActnList, AppEvnts,
  XPStyleActnCtrls, ActnMan;

type
  TForm2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TBR: TTrackBar;
    Shp1: TShape;
    Panel1: TPanel;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ImageList1: TImageList;
    CheckBox1: TCheckBox;
    Gauge3: TGauge;
    Timer1: TTimer;
    Panel2: TPanel;
    PM: TPopupMenu;
    FBUF1: TMenuItem;
    MBuf1: TMenuItem;
    AllBuF1: TMenuItem;
    ADD1: TMenuItem;
    Remove1: TMenuItem;
    FBuf2: TMenuItem;
    MBuf2: TMenuItem;
    AllBuf2: TMenuItem;
    Ignor1: TMenuItem;
    AutoBuff1: TMenuItem;
    MAS1: TMenuItem;
    MDS1: TMenuItem;
    MBS1: TMenuItem;
    SetLiader1: TMenuItem;
    WarList1: TMenuItem;
    FrendList1: TMenuItem;
    PB: TPaintBox;
    TrackBar3: TTrackBar;
    Button2: TButton;
    CIDRGroup: TRadioGroup;
    MCS1: TMenuItem;
    Button1: TButton;
    OPD: TOpenDialog;
    SpinEdit1: TSpinEdit;
    RSE: TSpinEdit;
    TrMemo: TMemo;
    CposEdit: TEdit;
    Button4: TButton;
    PageControl2: TPageControl;
    Button_3: TButton;
    Save1: TMenuItem;
    ActionManager1: TActionManager;
    ApplicationEvents1: TApplicationEvents;
    ActionList1: TActionList;
    MyClick: TAction;
    MyDblClick: TAction;
    Button3: TButton;
    Panel3: TPanel;
    Button5: TButton;
    Panel4: TPanel;
    TLBox: TListBox;
    Button6: TButton;
    RichEdit1: TRichEdit;
    Edit1: TEdit;
    PB2: TPaintBox;
    TBR1: TTrackBar;

    procedure Ncr(ID:integer);
    procedure DN(id:integer);
    procedure StUpdate(id:integer);
    procedure MyRGClick(Sender: TObject);
    procedure MyBTClick(Sender: TObject);
    procedure MySPClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure MyTimer(Sender: TObject);
    procedure FBUF1Click(Sender: TObject);
    procedure PMPopup(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure MySpinEditChange(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button_3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure RSEChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);

    procedure LBDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LBDblClick(Sender: TObject);
    procedure LBDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TLBoxClick(Sender: TObject);
    procedure TLBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

end;
var
  Form2: TForm2;
  mx,my:integer;
  lb:bool;
implementation
uses unit2,AAction,Other_Func,TNpcs;
{$R *.dfm}
//------------------------------------------------------------------------------
procedure TForm2.Ncr(ID:integer);
Var
  i:integer;
  mp,p,pg:TComponent;
begin
  with TTabSheet.Create(PageControl2) do begin
    Name:='NT_'+IntToStr(ID);
    Caption:=User[id].PName;
    CIDRGroup.Items.Add(Caption);
    PageControl:=PageControl2;
    end;

  mp:=PageControl2.FindComponent('NT_'+IntToStr(ID));
  with TPageControl.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='PGC';
    Width:=380;
    Height:=454;
    top:=215;
    Left:=3;
    end;

  p:=mp.FindComponent('PGC');
  for i:=1 to 4 do Begin
    with TTabSheet.Create(p) do begin
      Name:='PG'+IntTostr(i);
      case i of
        1: Caption:='NPC List';
        2: Caption:='Atack List';
        3: Caption:='Drop List';
        4: Caption:='Inventory';
        end;
      PageControl:=TPageControl(p);
      end;
    End;
  pg:=nil;
  for i:=1 to 6 do Begin
    case i of
      1..4: pg:=p.FindComponent('PG'+inttostr(i));
      5,6: pg:=p.FindComponent('PG'+inttostr(4));
      end;

    
    with TListBox.Create(pg) do begin
      Parent:=TTabSheet(pg);
      Top:=5;
      Left:=5;
      Text:='';
      Style:=lbOwnerDrawFixed;
      Color:=clMoneyGreen;
      Width:=TTabSheet(pg).Width-10;
      Height:=TTabSheet(pg).Height-10;
      Tag:=ID;
      case i of
        1: Name:='NL';
        2: Name:='AL';
        3: Name:='DL';
        4: Begin
          Name:='IL';
          Height:=((pg as TTabSheet).Height div 2)-10;
          Sorted:=True;
          End;
        5: Begin
          Name:='ASL';
          Height:=((pg as TTabSheet).Height div 4)-10;
          Top:=Height*2+25;
          Sorted:=True;
          End;
        6: Begin
          Name:='ADL';
          Height:=((pg as TTabSheet).Height div 4)-10;
          Top:=Height*3+35;
          Sorted:=True;
          End;
        end;
      DragMode:=dmAutomatic;
      OnDragOver:=ListBox2DragOver;
      OnDragDrop:=LBDragDrop;
      OnDrawItem:=LBDrawItem;
      OnDblClick:=LBDblClick;
      PopupMenu:=PM;
      end;
    End;
//--------------------------------------------------------------------TButton---
  with TButton.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='MB';
    Tag:=ID;
    Caption:='On';
    Width:=30;
    Height:=17;
    Top:=3;
    Left:=3;
    OnClick:=MyBTClick;
    end;
//------------------------------------------------------------------TSpinEdit---
  with TSpinEdit.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='SE';
    Tag:=ID;
    Width:=60;
    Height:=22;
    Top:=165;
    Left:=3;
    OnChange:=MySpinEditChange;
    ShowHint:=true;
    Hint:='Radius Kacha';
    end;
//------------------------------------------------------------------TComboBox---
  with TComboBox.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='SL';
    Tag:=ID;
    Top:=190;
    PopupMenu:=PM;
    Text:='';
    Width:=158;
    Left:=3;
    end;
//---------------------------------------------------------------------TShape---
  for i:=1 to 35 do with TShape.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='SH'+inttostr(i);
    Width:=10;
    Height:=10;
    ShowHint:=true;
    OnMouseDown:=MySPClick;
    Tag:=ID;
    case i of
      1:Hint:='IsInCombat';
      2:Hint:='IsCPUse';
      3:Hint:='IsHPUse';
      4:Hint:='IsMPUse';
      5:Hint:='TargetIsInCurse';
      6:Hint:='MoveToPoint';
      7:Hint:='isInHold';
      8:Hint:='isInHeal';
      9:Hint:='isInSBaf';
      10:Hint:='isInSweep';

      11:Hint:='OnAutoBaf';
      12:Hint:='OnPartyBaf';
      13:Hint:='OnSelfBaf';
      14:Hint:='OnAutoAtack';
      15:Hint:='OnAutoPickUp';
      16:Hint:='OnAutoAssist';
      17:Hint:='OnMoveToLiader';

      18:Hint:='INA';
      19:Hint:='INPU';
      20:Hint:='INAA';
      21:Hint:='INKT';
      22:Hint:='OnAutoOFF';

      23:Hint:='';
      24:Hint:='Mistik';
      25:Hint:='InAA';
      end;
    case i of
      1..25: Begin
        Top:=3;
        Left:=40+i*13;
        End;
      26..40: Begin
        Top:=16;
        Left:=40+(i-25)*13;
        End;
      end;
  end;
//---------------------------------------------------------------------TLabel---
  with TLabel.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='LB';
    top:=25;
    Left:=3;
  end;
  with TLabel.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='LBT';
    top:=63;
    Left:=3;
  end;
//---------------------------------------------------------------------TGauge---
  for i:=1 to 4 do
  with TGauge.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Case i of
      1: begin
          Name:='CG';
          ForeColor:=ClYellow;
          Top:=40;
        end;
      2: begin
          Name:='HG';
          ForeColor:=ClRed;
          Top:=47;
        end;
      3: begin
          Name:='MG';
          ForeColor:=ClBlue;
          Top:=54;
        end;
      4: begin
          Name:='HGT';
          ForeColor:=ClRed;
          Top:=78;
        end
    end;
    ShowText:=False;
    Width:=158;
    Height:=6;
    Left:=3;
    end;
//----------------------------------------------------------------TRadioGroup---
  for i:=1 to 2 do
  with TRadioGroup.Create(mp) do begin
    Parent:=TTabSheet(mp);
    Name:='RG'+inttostr(i);
    Tag:=ID;
    Width:=80;
    Height:=60;
    Left:=3+85*(i-1);
    Top:=95;
    case i of
      1:Begin
        Caption:='HP';
        items.Add('LHP'); items.Add('HP'); items.Add('GHP');
      End;
      2:Begin
        Caption:='MP';
        items.Add('MP'); items.Add('GMP');
      End;
    End;
    OnClick:=MyRGClick;
    end;
 //--------------------------------------------------------------------TTimer---
  with TTimer.Create(mp) do begin
    Name:='MT';
    Tag:=ID;
    Interval:=400;
    OnTimer:=MyTimer;
    Enabled:=False;
    end;
  Caption:='AUTO Monitor';
End;
//------------------------------------------------------------------------------
procedure TForm2.DN;
begin
  TTabSheet(PageControl2.FindComponent('NT_'+inttostr(ID))).Free;
  CIDRGroup.Items.Delete(User.IndexByConID(ID));
  User.Delete(User.IndexByConID(ID));
End;
//------------------------------------------------------------------------------
procedure TForm2.StUpdate(id:integer);
Var
  i:integer;
  s:string;
Begin
try
  if (User[id]<>nil) and(User[id].Online) and visible then with User[id] do
  with PageControl2 do
    with TTabSheet(FindComponent('NT_'+inttostr(id))) do Begin
      Caption:=User[id].PName+'['+inttostr(ClassID)+']';
      TLabel(FindComponent('LB')).Caption:=inttostr(ObjectID);
      TSpinEdit(FindComponent('SE')).Value:=rk;
      s:=inttostr(CurentT.ID)+'-['+inttostr(CurentT.HP)+'/'+inttostr(CurentT.MaxHP)+']';
      if CurentT.spoiled then s:=s+' [s]';
      TLabel(FindComponent('LBT')).Caption:=s;
      TGauge(FindComponent('CG')).MaxValue:=MaxCP;
      TGauge(FindComponent('CG')).Progress:=CP;
      TGauge(FindComponent('HG')).MaxValue:=MaxHP;
      TGauge(FindComponent('HG')).Progress:=HP;
      TGauge(FindComponent('MG')).MaxValue:=MaxMP;
      TGauge(FindComponent('MG')).Progress:=MP;
      TGauge(FindComponent('HGT')).MaxValue:=CurentT.MaxHP;
      TGauge(FindComponent('HGT')).Progress:=CurentT.HP;

      //-------------------------------------------------------------SkilList---
      if SkilList.Count<>0 then with TComboBox(FindComponent('SL')) do
        if Items.count<>SkilList.Count then Begin
          Clear;
          for I := 0 to SkilList.Count-1 do Items.Add(SkilList[i].Name);
          End;
      //------------------------------------------------------------------------
      With TRadioGroup(FindComponent('RG1')) do Begin
        Caption:='HP ['+inttostr(IList.Itemi[HPiID].Count)+']';
        if HPiID = 1060 then ItemIndex:=0;
        if HPiID = 1061 then ItemIndex:=1;
        if HPiID = 1539 then ItemIndex:=2;
        End;
      //------------------------------------------------------------------------
      With TRadioGroup(FindComponent('RG2')) do Begin
        Caption:='MP ['+inttostr(IList.Itemi[MPiID].Count)+']';
        if User[id].MPiID = 726 then ItemIndex:=0;
        if User[id].MPiID = 728 then ItemIndex:=1;
        End;


      for i:=1 to 35 do with TShape(FindComponent('SH'+IntToStr(i))).Brush do
        case i of
          1:  if isInCombat then Color:=Clgreen else Color:=ClWhite;
          2:  if IsCPUse then Color:=ClYellow else Color:=ClWhite;
          3:  if IsHPUse then Color:=ClRed else Color:=ClWhite;
          4:  if IsMPUse then Color:=ClBlue else Color:=ClWhite;
          5:  if CurentT.isInCurse then Color:=ClRed else Color:=ClWhite;
          6:  if isInMTP then Color:=Clgreen else Color:=ClWhite;
          7:  if isInHold then Color:=ClBlue else Color:=ClWhite;
          8:  if isInHeal then Color:=ClRed else Color:=ClWhite;
          9:  if isInSBaf then Color:=ClBlue else Color:=ClWhite;
          10:  if isInSweep then Color:=clFuchsia else Color:=ClWhite;
          11:  if OnAutoBaf then Color:=clFuchsia else Color:=ClWhite;
          12:  if OnPartyBaf then Color:=clFuchsia else Color:=ClWhite;
          13:  if OnSelfBaf then Color:=clFuchsia else Color:=ClWhite;
          14:  if OnAutoAtack then Color:=clFuchsia else Color:=ClWhite;
          15:  if OnAutoPickUp then Color:=clFuchsia else Color:=ClWhite;
          16:  if OnAutoAssist then Color:=clFuchsia else Color:=ClWhite;
          17:  if OnMoveToLiader then Color:=clFuchsia else Color:=ClWhite;
          18:  if IsInAA then Color:=clFuchsia else Color:=ClWhite;
          19:  if INPU then Color:=clFuchsia else Color:=ClWhite;
          21:  if INKT then Color:=clFuchsia else Color:=ClWhite;
          22:  if OnAutoOFF then Color:=clFuchsia else Color:=ClWhite;
          23:  if OnAutoMTT then Color:=clFuchsia else Color:=ClWhite;
          24:  if status[6]='+' then Color:=clFuchsia else Color:=ClWhite;
          //25:  if  then Color:=clFuchsia else Color:=ClWhite;
        end;

//------------------------------------------------------------------PGC-[Begin]-
      With TPageControl(FindComponent('PGC'+inttostr(id))) do
        case ActivePageIndex of
//--------------------------------------------------------------------NpcList---
          0: With TTabSheet(FindComponent('PG1'))do
            With TlistBox(FindComponent('NL')) do
              if Items.Count<>NpcList.Count then Begin
                Items.Clear;
                for I := 0 to NpcList.Count - 1 do
                  Items.Add(inttostr(NpcList[i].ObjectID));
                End Else Repaint;
//---------------------------------------------------------------------ATList---
          1: With TTabSheet(FindComponent('PG2'))do
            With TlistBox(FindComponent('AL')) do
              if Items.Text<>ATList.Text then Items.Text:=ATList.Text Else Repaint;
//-------------------------------------------------------------------DropList---
          2:With TTabSheet(FindComponent('PG3'))do
            With TlistBox(FindComponent('DL')) do
              if Items.Count<>DropList.Count then Begin
                Items.Clear;
                for I := 0 to DropList.Count - 1 do
                  Items.Add(inttostr(DropList[i].OID));
                End else Repaint;
//----------------------------------------------------------------------IList---
          3:  With TTabSheet(FindComponent('PG4'))do Begin
            With TlistBox(FindComponent('IL')) do
              if Items.Count<>IList.Count then Begin
                Items.Clear;
                for I := 0 to IList.Count - 1 do
                  Items.Add(inttostr(IList[i].ID));
                End else Repaint;
            With TlistBox(FindComponent('ADL')) do Begin
              if Items.Count<ADL.Count then Items.Text:=ADL.Text;
              if Items.Count>ADL.Count then ADL.Text:=Items.Text;
              End;
            With TlistBox(FindComponent('ASL')) do Begin
              if Items.Count<ASL.Count then Items.Text:=ASL.Text;
              if Items.Count>ASL.Count then ASL.Text:=Items.Text;
              End;
            End;
          End;
//--------------------------------------------------------------------PGC-[End]-
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ StUpdate:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;

procedure TForm2.MySpinEditChange(Sender: TObject);
begin
  with TSpinEdit(Sender) do User[tag].rk:=Value;
end;



procedure TForm2.LBDblClick(Sender: TObject);
begin
  with TListBox(Sender) do
    if (Pos('UL',Name)=1) or (Pos('NL',Name)=1) and (Items[ItemIndex]<>'') Then
      STS(tag,'1f'+anti4HEX(StrToIntDef(Items[ItemIndex],0))+'00000000000000000000000001'); //Select
end;

procedure TForm2.ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if ((Sender is TListBox) or (Source is TListBox)) then
  Accept := True;
end;

procedure TForm2.LBDragDrop(Sender, Source: TObject; X, Y: Integer);
Var S:string;
  Value:integer;
begin
  with TListBox(Source) do Begin
    if ItemIndex<>-1 then s:=Items[ItemIndex];
    if ((pos('ADL',Name)=1) or (pos('ASL',Name)=1)) and (ItemIndex<>-1) then
      Items.Delete(ItemIndex);
    End;
  with TListBox(Sender) do
    if ((pos('ADL',Name)=1) or (pos('ASL',Name)=1)) and (s<>'') And (Items.IndexOf(s)=-1) then
      Items.Add(s);
  with TListBox(Sender) do if Name='TLBox' then
  begin
    Value := ItemAtPos(Point(x, y), True);
    Form2.Caption:=Inttostr(ItemIndex)+'<>'+Inttostr(Value);
    if Value = -1 then
    begin
      Tr.Move(ItemIndex+1,Value+2);
      Items.Add(Items[ItemIndex]);
      Items.Delete(ItemIndex);
      
    end
    else
    if Value>ItemIndex then begin
      Tr.Move(ItemIndex+1,Value+1);
      Items.Insert(Value+1, Items[ItemIndex]);
      Items.Delete(ItemIndex);

      end else begin
      Tr.Move(ItemIndex+1,Value+1);
      Items.Insert(Value, Items[ItemIndex]);
      Items.Delete(ItemIndex);
      end;

  end;
end;

procedure TForm2.LBDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var i:Integer;
  nm:string;
begin
  with TListBox(Control) do Begin
  nm:=name;
  With User[Tag] do with TListBox(Control).Canvas do begin
    Brush.Color := clSkyBlue;
    if Index mod 2=0 then Begin
      Brush.Color := clMoneyGreen;
      Font.Color := clBlue
      End else Begin
      Brush.Color := clSkyBlue;
      Font.Color := clGreen;
      End;

    FillRect(Rect);
    i:=0;
    if (Control as TListBox).Items[Index]<>'' then
      i:=StrToIntDef((Control as TListBox).Items[Index],0);
    if (pos('AL',nm)=1) or (pos('NL',nm)<>0) then With NpcList.Itemi[i] do
      TextOut(Rect.Left, Rect.Top,NpcName+' ['+inttostr(i)+']['+inttostr(NpcID)+'] --> '+inttostr(Dist));
    if (pos('DL',nm)=1) then With DropList.ItemO[i] do
      TextOut(Rect.Left, Rect.Top,'i -- '+itid.Values[inttostr(id)]+' ['+inttostr(i)+'] --> '+inttostr(Dist));
    if (pos('IL',nm)=1) then
      TextOut(Rect.Left, Rect.Top,itid.Values[Items[Index]]+' - '+inttostr(IList.ItemI[i].Count));
    if (pos('ASL',nm)=1) or (pos('ADL',nm)<>0) then
      TextOut(Rect.Left, Rect.Top,itid.Values[Items[Index]]);
    if nm='TLBox' then
      TextOut(Rect.Left, Rect.Top,Items[Index]);
  end;
  end;
end;

procedure TForm2.SpinEdit1Change(Sender: TObject);
begin
  User.Itemi[CIDRGroup.ItemIndex].CurentPN:=SpinEdit1.Value;
end;

procedure TForm2.RSEChange(Sender: TObject);
begin
  User.Itemi[CIDRGroup.ItemIndex].rk:=RSE.Value;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
Var CID,i,ux,uy:integer;
  mt,mtx,mty:real;
  s:string;
begin
Try
  with PB2.Canvas do Begin
    Brush.Color := ClWhite;
    FillRect(ClipRect);
    Pen.Color:=ClRed;
    mtx:=(Tr.multx*0.01/TBR1.Position);
    mty:=(Tr.multy*0.01/TBR1.Position);
    if Tr.count>1 then with  Tr do Begin
      ux:=Tr.minx+Round((Tr.maxx-Tr.minx) div 2);
      uy:=Tr.miny+Round((Tr.maxy-Tr.miny) div 2);
      for i:= 1 to Tr.Count-1 do begin
        Pen.Width:=1;
        Font.Size:=4;
        TextOut(round((Items[i].x-ux)*mtx)+172,172+round((Items[i].y-uy)*mty),Items[i].Name);
        if i>1 then Begin
          MoveTo(round((Items[i-1].x-ux)*mtx)+172,172+round((Items[i-1].y-uy)*mty));
          LineTo(round((Items[i].x-ux)*mtx)+172,172+round((Items[i].y-uy)*mty));
          End;
        end;
      End;
    TextOut(5,2,'Treck minx: '+inttostr(Tr.minx)+' - '+inttostr(ux)+' - '+inttostr(Tr.maxx));
    TextOut(5,15,'Treck Size: '+inttostr(Tr.multx)+'/'+inttostr(Tr.multy) +'/'+inttostr(TBR1.Position));
    TextOut(5,28,'Treck Size: '+Floattostr(mt));
    End;


  With CIDRGroup do
    if (Items.Count>0) and (ItemIndex=-1) then ItemIndex:=0;
  CID:=CIDRGroup.ItemIndex;
  if User.Itemi[CID]<>nil then
  with PB.Canvas do with User.Itemi[CID] do Begin
    RSE.Value:=rk;
    ux:=x;
    uy:=y;
    s:=inttostr(x)+','+inttostr(y)+','+inttostr(z);
    if CposEdit.Text<>s Then CposEdit.Text:=s;
    Brush.Color := ClWhite;
    FillRect(ClipRect);
    Pen.Color:=ClRed;
    mt:=(350/TBR.Position);
    if CurentCK.x<>0 then
      Ellipse(round((CurentCK.x-x-rk)*mt)+190,190+round((CurentCK.y-y-rk)*mt),round((CurentCK.x-x+rk)*mt)+190,190+round((CurentCK.y-y+Rk)*mt))
      else Ellipse(round(-rk*mt)+190,190+round(-rk*mt),round(rk*mt)+190,190+round(Rk*mt));
    Pen.Color:=clFuchsia;
    Ellipse(round((CurentT.x-x)*mt)+184,184+round((CurentT.y-y)*mt),round((CurentT.x-x)*mt)+196,196+round((CurentT.y-y)*mt));
    Pen.Color:=ClRed;
    for i:= 0 to NpcList.Count-1 do with NpcList[i] do
      Ellipse(round((x-ux)*mt)+186,186+round((y-uy)*mt),round((x-ux)*mt)+194,194+round((y-uy)*mt));

    Pen.Color:=ClBlue;
    if Treck.count>1 then with  Treck do
      for i:= 1 to Treck.Count-1 do begin
        Pen.Width:=1;
        Font.Size:=4;
        TextOut(round((Items[i].x-x)*mt)+190,190+round((Items[i].y-y)*mt),Items[i].Name);
        if i>1 then Begin
          MoveTo(round((Items[i-1].x-x)*mt)+190,190+round((Items[i-1].y-y)*mt));
          LineTo(round((Items[i].x-x)*mt)+190,190+round((Items[i].y-y)*mt));
          End;
        End;
      Pen.Color:=clBlue;
      Brush.Color:=cllime;
      Ellipse(186,186,194,194);
      FloodFill(190,190,cllime,fsBorder);
      Brush.Color := ClWhite;
      Pen.Color:=ClGreen;
      Font.Size:=5;
      TextOut(5,2,'Curent poin: '+inttostr(CurentPN));
      TextOut(5,15,'Treck Size: '+inttostr(Treck.Count));
      TextOut(5,28,'Atack Radius: '+inttostr(rk));
      if Treck.MoveForward then TextOut(5,41,'Forward') else TextOut(5,41,'Back');
  End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ Timer1Timer:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TForm2.TLBoxClick(Sender: TObject);
begin
  With Tr.Items[TLBox.ItemIndex+1] do
  Edit1.Text:=inttostr(x)+','+inttostr(y)+','+inttostr(z);;
  RichEdit1.Lines.Text:=Tr.Items[TLBox.ItemIndex+1].alist;
end;

procedure TForm2.TLBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  Var i,n:integer;
begin
  With TLBox do
  if (Key=46) and (Count>0) Then Begin
    i:=-1;
    n:=ItemIndex;
    if (Count>1) and (ItemIndex=0) then i:=2;
    if (Count>1) and (ItemIndex>0) then i:=ItemIndex;
    if i<>-1 then Begin
      With Tr[i] do
        Edit1.Text:=inttostr(x)+','+inttostr(y)+','+inttostr(z);;
      RichEdit1.Lines.Text:=Tr[i].alist;
      End;
    Tr.Delete(ItemIndex+1);
    Items.Delete(ItemIndex);
    if (Count>0) and (n>0) then ItemIndex:=n-1;
    if (Count>0) and (n=0) then ItemIndex:=n;
    End;
end;

procedure TForm2.TrackBar3Change(Sender: TObject);
begin
  Form2.AlphaBlendValue:=TrackBar3.Position;
end;



procedure TForm2.PMPopup(Sender: TObject);
var i:integer;
begin
  With TPopupMenu(Sender) do Begin
    for I := 0 to Items.Count - 1 do With Items[i] do Begin
      Visible:=false;
        case Tag of
          33..35: if pos('UL',PopupComponent.name)=1 then Visible:=true;
          0,21..31,38: if pos('SL',PopupComponent.name)=1 then Visible:=true;
          50:  if (pos('ADL',PopupComponent.name)=1) or (pos('ASL',PopupComponent.name)=1) then
            Visible:=true;
       end;
      End;
    end;
end;

procedure TForm2.FBUF1Click(Sender: TObject);
begin
  if PM.PopupComponent is TComboBox then with TComboBox(PM.PopupComponent) do
    with User[Tag] do Begin
      Case TMenuItem(Sender).Tag of
        24: with SkilList[SkilList.IFName(SelText)] do
          if ABList.IndexOfName(inttostr(id))=-1 then ABList.Add(inttostr(id)+'='+Name);
        27: with SkilList[SkilList.IFName(SelText)] do
          if ABList.IndexOfName(inttostr(id))<>-1 then ABList.Delete(ABList.IndexOfName(inttostr(id)));
        29: MAS:=SkilList[SkilList.IFName(SelText)].ID;
        38: MCS:=SkilList[SkilList.IFName(SelText)].ID;
        End;
      End;

  if PM.PopupComponent is TListBox then
    with TListBox(PM.PopupComponent) do
      Case TMenuItem(Sender).Tag of
        50: Items.SaveToFile(CurrentDir+'\Settings\'+Copy(Name,1,3)+'.ini');
        End;
end;

procedure TForm2.Button1Click(Sender: TObject);
Var s:string;
begin
  s:=InputBox('Save Treck','Name',User.Itemi[CIDRGroup.ItemIndex].PName);
  if s<>'' then with User.Itemi[CIDRGroup.ItemIndex] do
    Treck.SaveToFile(CurrentDir+'\Treks\'+s+'.trk');
end;

procedure TForm2.Button2Click(Sender: TObject);
Var i:integer;
begin

  OPD.InitialDir:=CurrentDir+'\Treks\';
  OPD.Execute;
  if OPD.FileName<>'' then User.Itemi[CIDRGroup.ItemIndex].Treck.LoadFromFile(OPD.FileName);
  SetCurrentDir(CurrentDir);
  TBR.Position:=User.Itemi[CIDRGroup.ItemIndex].Treck.mult;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  DN(1200);
end;

procedure TForm2.Button_3Click(Sender: TObject);
begin
  user.Add(TUser.create(1200,'MrXtreme'));
  Form2.Ncr(1200);
  user.Add(TUser.create(120,'MoR'));
  Form2.Ncr(120);
end;

procedure TForm2.Button4Click(Sender: TObject);
Var s:string;
begin
  s:=InputBox('Save Treck','Name',Tr.Name);
  if s<>'' then Tr.SaveToFile(s);
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  if Button5.Caption='>>' then Begin
    Button5.Caption:='<<';
    Panel3.Width:=380;
    End else Begin
    Button5.Caption:='>>';
    Panel3.Width:=Button5.Width;
    End;

end;

procedure TForm2.Button6Click(Sender: TObject);
Var i:integer;
begin
  OPD.InitialDir:=CurrentDir+'\Treks\';
  OPD.Execute;
  if OPD.FileName<>'' then Tr.LoadFromFile(OPD.FileName);
  SetCurrentDir(CurrentDir);
  TrMemo.Lines.LoadFromFile(OPD.FileName);
  TLBox.Clear;
  for i := 1 to tr.Count - 1 do TLBox.Items.Add(Tr[i].Name);
  TBR1.Position:=Tr.mult;
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then Form2.FormStyle:=fsStayOnTop
    else Form2.FormStyle:=fsNormal;
end;

procedure TForm2.MyRGClick(Sender: TObject);
begin
  with sender as TRadioGroup do with User[tag] do
    case StrToInt(Name[3]) of
      1: case ItemIndex of
        0: HPiID:=1060;
        1: HPiID:=1061;
        2: HPiID:=1539;
        end;
      2: case ItemIndex of
        0: MPiID:=726;
        1: MPiID:=728;
        end;
      end;
end;

procedure TForm2.MyBTClick(Sender: TObject);
begin
  with sender as TButton do if Caption='On' then Begin
    User[tag].Reload;
    Caption:='Off';
    with PageControl2 do
      with  TTabSheet(Parent) do TTimer(FindComponent('MT')).Enabled:=True;
    End
    Else Begin
      Caption:='On';
      with PageControl2 do
        with  TTabSheet(parent) do TTimer(FindComponent('MT')).Enabled:=False;
      End;

end;

procedure TForm2.MySPClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with sender as TShape do
    with User[Tag] do
      Case strtoint(name[3]) of
        1: IsInCombat:= not IsInCombat;
        2: IsCPUse:= not IsCPUse;
        3: IsHPUse:= not IsHPUse;
        4: IsMPUse:= not IsMPUse;
        5: CurentT.IsInCurse:= not CurentT.IsInCurse;
        6: isInMTP:= not isInMTP;
        7: isInHold:= not isInHold;
        8: isInHeal:= not isInHeal;
        9: isInSBaf:= not isInSBaf;
        10: isInSweep:= not isInSweep;

        11: OnAutoBaf:= not OnAutoBaf;
        12: OnPartyBaf:= not OnPartyBaf;
        13: OnSelfBaf:= not OnSelfBaf;
        14: OnAutoAtack:= not OnAutoAtack;
        15: OnAutoPickUp:= not OnAutoPickUp;
        16: OnAutoAssist:= not OnAutoAssist;
        17: OnMoveToLiader:= not OnMoveToLiader;

        18: ;
        19: INPU:= not INPU;
        20: ;
        21: INKT:= not INKT;
        22: OnAutoOFF:= not OnAutoOFF;

        23: ;
        24: if status[6] = '-' then status[6]:='+' else status[6]:='-';
        //11: if Pen.Color=clLime then OnAutoBaf:=True else OnAutoBaf:=False;
        //12: if Pen.Color=clLime then OnPartyBaf:=True else OnPartyBaf:=False;
        //13: if Pen.Color=clLime then OnSelfBaf:=True else OnSelfBaf:=False;
        //14: if Pen.Color=clLime then OnAutoAtack:=True else OnAutoAtack:=False;
        //15: if Pen.Color=clLime then OnAutoPickUp:=True else OnAutoPickUp:=False;
        //16: if Pen.Color=clLime then OnAutoAssist:=True else OnAutoAssist:=False;
        //17: if Pen.Color=clLime then OnMoveToLiader:=True else OnMoveToLiader:=False;
        //24: if Pen.Color=clLime then status[6]:='+' else status[6]:='-';
        End;
end;

procedure TForm2.MyTimer(Sender: TObject);
begin
try
  with sender as TTimer do
  IF User[Tag]<> nil Then With User[Tag] Do Begin
    if not isInHold then AA(Tag);
    //if isInHold then with Baffs.Itemi[4072] do if Duration<(GetTickCount-LTU)/1000 then UnHold(cid);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MyTimer:'+inttostr(Tag)+' '+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;


end.
