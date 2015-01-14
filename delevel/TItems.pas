unit TItems;

interface
Uses Contnrs,Dialogs,SysUtils;
Type
  TItem = class
  Public
    ID:integer;
    OID:integer;
    Count:integer;
  end;

  TItemList = class(TObjectList)
  private
    function GetItems(Index: Integer): TItem;
    procedure SetItems(Index: Integer; const Value: TItem);
  public
    procedure AddItem(OID,IID,C:integer);
    function IFIID(ID:Integer):Integer;
    function CountFromID(ID:Integer):Integer;
    function OIDFromID(ID:Integer):Integer;
    property Items[Index: Integer]: TItem read GetItems write SetItems; default;
  end;

implementation
{ TItemList }

procedure TItemList.AddItem(OID, IID, C: integer);
Var NewItem:TItem;
begin
Try
  if IFIID(IID)=-1 then Begin
    NewItem:=TItem.Create;
    NewItem.ID:=IID;
    NewItem.OID:=OID;
    NewItem.Count:=C;
    Add(NewItem);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.AddItem:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;

end;

function TItemList.CountFromID(ID: Integer): Integer;
var i:integer;
begin
  Result:=0;
Try
  if Count<>0 then
    for i:= 0 to Count - 1 do if items[i].ID=ID then  Result:=items[i].Count;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.CountFromID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TItemList.GetItems(Index: Integer): TItem;
begin
  Result := nil;
Try
  Result := TItem(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.GetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

function TItemList.IFIID(ID: Integer): Integer;
var i:integer;
begin
  Result:=-1;
Try
  for i:= 0 to Count - 1 do if items[i].ID=ID then  Result:=i;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.IFIID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;

function TItemList.OIDFromID(ID: Integer): Integer;
var i:integer;
begin
  Result:=0;
Try
  if Count<>0 then
    for i:= 0 to Count - 1 do if items[i].ID=ID then  Result:=items[i].OID;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TItemList.OIDFromID:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
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

end.
