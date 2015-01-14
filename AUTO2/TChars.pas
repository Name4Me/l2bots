unit TChars;

interface
Uses Contnrs,Dialogs,SysUtils,OtherTypes,Other_Func;

Type
TChar= class
  Public
    Name: String[40];
    ObjectID,Lvl,ClassID,ClanID:integer;
    HP,MaxHP:integer;
    CP,MaxCP:integer;
    MP,MaxMP:integer;
    DNTHeal:boolean;
    Ch:boolean;
    x,y,z,dist:integer;
    BaffsCount:integer;
    Baffs:TBaffList;
  end;
  TCharList= class(TObjectList)
    private
    function GetItems(Index: Integer): TChar;
    procedure SetItems(Index: Integer; const Value: TChar);
  public
    procedure AddChar(x,y,z,OID,ClasID,ClanID:integer;Nm:string);
    procedure DelChar(OID:integer);
    function IFOID(OID:Integer):Integer;
    function IDByName(Nm:String):Integer;
    function OIDByName(Nm:String):Integer;
    Procedure MTL(OID,sx,sy,sz,ux,uy:Integer);
    property Items[Index: Integer]: TChar read GetItems write SetItems; default;
  end;
implementation
{ TCharList }

procedure TCharList.AddChar(x,y,z,OID,ClasID,ClanID:integer;Nm:string);
Var NewChar:TChar;
begin
Try
  if IFOID(OID)=-1 then Begin
    NewChar:=TChar.Create;
    NewChar.ObjectID:=OID;
    NewChar.x:=x;
    NewChar.y:=y;
    NewChar.z:=z;
    NewChar.ClassID:=ClasID;
    NewChar.ClanID:=ClanID;
    NewChar.Name:=nm;
    NewChar.Ch:=false;
    Add(NewChar);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.AddChar:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TCharList.DelChar(OID: integer);
var i:integer;
begin
Try
  i:=IFOID(OID);
  if i<>-1 then Delete(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.DelChar:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TCharList.GetItems(Index: Integer): TChar;
begin
  Result := nil;
Try
  if Index<=Count-1 then Result :=  TChar(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.GetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TCharList.IDByName(Nm: String): Integer;
Var i:integer;
begin
  Result:=-1;
  Try
  for i:= 0 to Count - 1 do if items[i].Name=nm then  Result:=i;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.IDByName:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TCharList.IFOID(OID: Integer): Integer;
Var i:integer;
begin
  Result:=-1;
  Try
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].ObjectID=OID then  Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.IFIID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TCharList.OIDByName(Nm: String): Integer;
Var i:integer;
begin
  Result:=-1;
  Try
  for i:= 0 to Count - 1 do if items[i].Name=nm then  Result:=items[i].ObjectID;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.OIDByName:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TCharList.MTL(OID, sx, sy, sz,ux,uy: Integer);
var i:integer;
begin
Try
  i:=IFOID(OID);
  if i<>-1 then Begin
    items[i].x:=sx;
    items[i].y:=sy;
    items[i].z:=sz;
    items[i].dist:=ras(sx,sy,ux,uy);
  End;

  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.MTL:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

procedure TCharList.SetItems(Index: Integer; const Value: TChar);
begin
Try
  inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TCharList.SetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

end.
