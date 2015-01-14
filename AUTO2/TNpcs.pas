unit TNpcs;

interface
Uses Contnrs,Dialogs,SysUtils,math,Other_Func;
Type
  Position = Record
    x,y,z:integer;
    End;
  TNpc = class
  Public
    ObjectID:integer;
    NpcID,IsAttackable:integer;
    NpcName:string;
    Dist:integer;
    x,y,z:integer;
  end;

  TNpcList = class(TObjectList)
  private
    us,ct:Position;
    centre:boolean;
    function GetItems(Index: Integer): TNpc;
    procedure SetItems(Index: Integer; const Value: TNpc);
    function GetItemsi(OID: Integer): TNpc;
    procedure SetItemsi(Index: Integer; const Value: TNpc);
  public
    pol:Poligon;
    function IFOID(OID:Integer):Integer;
    function IFIID(IID:Integer):Integer;
    function GetMinDist(minr:integer=9999): integer;
    Procedure ADDNpc(OID,NID,isa,sx,sy,sz:Integer;Nm:string);
    Procedure DelNpc(OID:Integer);
    Procedure SetXYZ(sx,sy,sz:Integer;cn:boolean = false);
    Procedure MTL(OID,sx,sy,sz:Integer);
    property Items[Index: Integer]: TNpc read GetItems write SetItems; default;
    property Itemi[OID: Integer]: TNpc read GetItemsi write SetItemsi;
  end;
    Function MyNPCSort(el1,el2:TNpc):integer;
implementation

Function MyNPCSort(el1,el2:TNpc):integer;
Begin
  Result:=0;
Try
  if ((el1.IsAttackable=0) and (el2.IsAttackable=0)) or
    ((el1.IsAttackable<>0) and (el2.IsAttackable<>0)) then
      result:=Compar—eInteger(el1.Dist,el2.Dist);
  if ((el1.IsAttackable=0) and (el2.IsAttackable<>0)) then result:=1;
  if ((el1.IsAttackable<>0) and (el2.IsAttackable=0)) then result:=-1;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MyNPCSort:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;

{ TNpcList }

procedure TNpcList.ADDNpc(OID, NID,isa, sx, sy, sz: Integer;Nm:string);
Var MyNpc:TNpc;
  i:integer;
Begin
Try
  i:=IFOID(OID);
  if i=-1 then Begin
    MyNpc:=TNpc.create;
    MyNpc.ObjectID:=OID;
    MyNpc.NpcID:=NID;
    MyNpc.IsAttackable:=isa;
    MyNpc.x:=sx;
    MyNpc.y:=sy;
    MyNpc.z:=sz;
    MyNpc.NpcName:=nm;
    MyNpc.Dist:=Ras(sx,sy,us.x,us.y);
    Add(MyNpc);
    End
  else Begin
    items[i].x:=sx;
    items[i].y:=sy;
    items[i].z:=sz;
    items[i].Dist:=Ras(sx,sy,us.x,us.y);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TTNpcList.ADDNpc:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TNpcList.DelNpc(OID: Integer);
var i:integer;
begin
Try
  i:=IFOID(OID);
  if i<>-1 then Delete(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.DelNpc:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TNpcList.GetItems(Index: Integer): TNpc;
begin
Result:=nil;
Try
  if (Index>-1)and(Index<Count) then Result := TNpc(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.GetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TNpcList.GetItemsi(OID: Integer): TNpc;
begin
  Result := TNpc.Create;
Try
  OID:=IFOID(OID);
  if (OID>-1)and(OID<Count) then Result := TNpc(inherited GetItem(OID));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.GetItemsi:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TNpcList.IFIID(IID: Integer): Integer;
Var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].NpcID=IID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.IFIID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TNpcList.IFOID(OID: Integer): Integer;
Var i:integer;
begin
  Result:=-1;
Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].ObjectID=OID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.IFOID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TNpcList.MTL(OID, sx, sy, sz: Integer);
begin
Try
  with itemi[OID] do if ObjectID<>0 then begin
    x:=sx;
    y:=sy;
    z:=sz;
    Dist:=Ras(sx,sy,us.x,us.y);
    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.MTL:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TNpcList.SetItems(Index: Integer; const Value: TNpc);
begin
Try
  if (Index>-1)and(Index<Count) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.SetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TNpcList.SetItemsi(Index: Integer; const Value: TNpc);
begin
Try
  Index:=IFOID(Index);
  if (Index>-1)and(Index<Count) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.SetItemsi:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TNpcList.SetXYZ(sx, sy, sz: Integer;cn:boolean = false);
var i:integer;
begin
Try
  if not cn then Begin
    us.x:=sx;
    us.y:=sy;
    us.z:=sz;
    for i := 0 to Count - 1 do items[i].Dist:=Ras(items[i].x,items[i].y,us.x,us.y);
    End else Begin
    ct.x:=sx;
    ct.y:=sy;
    ct.z:=sz;
    Centre:=true;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.SetXYZ:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
function TNpcList.GetMinDist(minr:integer=9999): integer;
var i:integer;
begin
Result:=0;
i:=0;
Try
  sort(@MyNPCSort);
  if count>0 Then while (result=0) and (i<Count-1) do with items[i] do begin
    if (not centre) and (IsAttackable=1)
      and (Dist<minr) and (abs(us.z-z)<=300) then Result:=ObjectID;
    if centre and (IsAttackable=1)
      and (Ras(x,y,ct.x,ct.y)<minr) and (abs(ct.z-z)<=300)  then Result:=ObjectID;
    inc(i);
    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TNpcList.SortByDist:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

end.
