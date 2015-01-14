unit TSkils;

interface
Uses Windows,Dialogs,SysUtils,ExtCtrls,Contnrs;
Type
  TSkil = class(TObject)
  private
    function Getp: Boolean;
    Public
      ReuseDelay:DWORD;
      ID:integer;
      Name: String;
      Duration:integer;
      LastTimeUsed:DWORD;
      Procedure SetDelay(Delay,LTU:integer);
      function Cust(CID:integer):Boolean;
      property isActive:Boolean read Getp;
  end;

  TSkilList = class(TObjectList)
  private
    function GetItems(Index: Integer): TSkil;
    procedure SetItems(Index: Integer; const Value: TSkil);
    function GetItemsi(Index: Integer): TSkil;
    procedure SetItemsi(Index: Integer; const Value: TSkil);
  public
    function IFIID(ID:Integer):Integer;
    function IFName(Nm:String):Integer;
    Procedure ADDSkil(SkilName:string;ID:Integer);
    property Items[Index: Integer]: TSkil read GetItems write SetItems; default;
    property Itemi[Index: Integer]: TSkil read GetItemsi write SetItemsi;
  end;
  Var NI:TSkil;
implementation
Uses AAction;
{ TSkil }
//----------------------------------------------------------------------TSkil---
function TSkil.Getp: Boolean;
begin
  Result:=false;
  Try
  if (GetTickCount-LastTimeUsed)>=ReuseDelay then  Result:=True;
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkil.Getp:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

Procedure TSkil.SetDelay(Delay,LTU:integer);
Begin
Try
  LastTimeUsed:=LTU;
  ReuseDelay:=Delay;
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkil.SetDelay:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
End;


function TSkil.Cust(CID:integer):boolean;
Begin
result:=false;
Try
  if isActive then Begin
    LastTimeUsed:=GetTickCount;
    ReuseDelay:=1500;
    MagicSU(CID,ID);
    Result:=true;
    End;
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkil.Cust:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------
{ TSkilList }
//------------------------------------------------------------------TSkilList---
function TSkilList.GetItems(Index: Integer): TSkil;
begin
Result:=NI;
Try
  if (Index>-1)and(Index<Count) then Result :=  TSkil(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.GetItems:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

function TSkilList.GetItemsi(Index: Integer): TSkil;
begin
Result:=TSkil.Create;
Try
  Index:=IFIID(Index);
  if (Index>-1)and(Index<Count) then Result := TSkil(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.GetItems:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

function TSkilList.IFIID(ID: Integer): Integer;
Var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].ID=ID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.IFIID:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

function TSkilList.IFName(Nm: String): Integer;
Var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].Name=Nm then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.IFName:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

procedure TSkilList.SetItems(Index: Integer; const Value: TSkil);
begin
Try
  if (Index>-1)and(Index<Count) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.SetItems:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

procedure TSkilList.SetItemsi(Index: Integer; const Value: TSkil);
begin
Try
  Index:=IFIID(Index);
  if (Index>-1)and(Index<Count) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.SetItems:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

Procedure TSkilList.ADDSkil(SkilName:string;ID:Integer);
Var MySkil:TSkil;
Begin
Try
  if IFIID(ID)=-1 then Begin
     MySkil:=TSkil.create;
     MySkil.Name:=SkilName;
     MySkil.ID:=ID;
     Add(MySkil);
    End;
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ TSkilList.ADDSkil:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
End;
Begin
  NI:=TSkil.Create;
end.
