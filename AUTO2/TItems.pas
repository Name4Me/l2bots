unit TItems;

interface
Uses Windows,Contnrs,Dialogs,SysUtils;
Type
  TMyPosition=Record
    x,y,z:integer;
    End;
  TItem = class
  Public
    ID:integer;
    OID:integer;
    Count,Dist:integer;
    AugmentationBonus:integer;
    Position:TMyPosition;
    RTime:DWORD;

    end;

  TItemList = class(TObjectList)
  private
    PlPos:TMyPosition;
    PURadius,NearObj,NearOBjDist:integer;

    function GetItems(Index: Integer): TItem;
    procedure SetItems(Index: Integer; const Value: TItem);
    function GetItemsi(Index: Integer): TItem;
    procedure SetItemsi(Index: Integer; const Value: TItem);
    function GetItemso(Index: Integer): TItem;
    procedure SetItemso(Index: Integer; const Value: TItem);
  public
    procedure AddItem(OID,IID,C,AB:integer;sx:integer=0;sy:integer=0;sz:integer=0;dl:DWORD=0);
    Procedure DelObj(ObjId:Integer);
    function IFIID(ID:Integer):Integer;
    function IFOID(OID:Integer):Integer;
    Procedure SetXYZ(sx,sy,sz:Integer);
    function GetMinDist(minr:integer=9999): integer;
    property Items[Index: Integer]: TItem read GetItems write SetItems; default;
    property ItemI[Index: Integer]: TItem read GetItemsi write SetItemsi;
    property ItemO[Index: Integer]: TItem read GetItemso write SetItemso;
  end;
  Var NI:TItem;
  Function MyItemsSort(el1,el2:TItem):integer;
implementation

Uses Other_Func;
Function MyItemsSort(el1,el2:TItem):integer;
Begin
  Result:=0;
  Try
    result:=Compar—eInteger(el1.Dist,el2.Dist);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MyItemsSort:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;

{ TItemList }

procedure TItemList.AddItem(OID, IID, C,AB: integer;sx:integer=0;sy:integer=0;sz:integer=0;dl:DWORD=0);
Var NewItem:TItem;
begin
Try
  if IFOID(OID)=-1 then Begin
    NewItem:=TItem.Create;
    NewItem.ID:=IID;
    NewItem.OID:=OID;
    NewItem.Count:=C;
    NewItem.AugmentationBonus:=AB;
    NewItem.Position.x:=sx;
    NewItem.Position.y:=sy;
    NewItem.Position.z:=sz;
    NewItem.RTime:=dl;
    NewItem.Dist:=Ras(PlPos.x,PlPos.y,sx,sy);
    if dl<>0 then NewItem.Dist:=9999;
    Add(NewItem);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.AddItem:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;

end;

procedure TItemList.DelObj(ObjId: Integer);
begin
  if ObjId=NearObj then Begin
    NearObj:=0;
    NearObjDist:=0;
    End;

  ObjId:=IFOID(ObjId);
  if ObjId<>-1 then Delete(ObjId);
end;

function TItemList.GetItems(Index: Integer): TItem;
begin
  Result := TItem.Create;
Try
  if Index<Count then Result := TItem(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.GetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;
procedure TItemList.SetItems(Index: Integer; const Value: TItem);
begin
Try
  inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.SetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TItemList.GetItemsi(Index: Integer): TItem;
begin
  Result := NI;
Try
  Index:=IFIID(Index);
  if Index<>-1 then Result := TItem(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.GetItemsi:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TItemList.GetItemso(Index: Integer): TItem;
begin
  Result := NI;
Try
  Index:=IFOID(Index);
  if Index<>-1 then Result := TItem(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.GetItemso:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TItemList.GetMinDist(minr:integer=9999): integer;
Var i:integer;
begin
  Result:=0;
  NearOBjDist:=99999;
  for i := 0 to Count - 1 do with items[i] do
    if (Dist<minr) and (Dist<NearOBjDist) Then Begin
        Result:=OID;
        NearOBjDist:=Dist;
        NearObj:=Result;
        End;
  PURadius:=minr;
end;

function TItemList.IFIID(ID: Integer): Integer;
var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].ID=ID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.IFIID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;



function TItemList.IFOID(OID: Integer): Integer;
var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].OID=OID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.IFOID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TItemList.SetItemsi(Index: Integer; const Value: TItem);
begin
Try
  Index:=IFIID(Index);
  if Index<>-1 then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.SetItemsi:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
procedure TItemList.SetItemso(Index: Integer; const Value: TItem);
begin
Try
  Index:=IFOID(Index);
  if Index<>-1 then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.SetItemsi:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TItemList.SetXYZ(sx, sy, sz: Integer);
Var i:integer;
begin
  PlPos.x:=sx;
  PlPos.y:=sy;
  PlPos.z:=sz;
  for i := 0 to Count - 1 do with items[i] do
    if (RTime=0)or(GetTickCount-RTime>20000) then
      Dist:=Ras(Position.x,Position.y,sx,sy)
      Else Dist:=9999;
end;

Begin
NI:=TItem.Create;
end.
