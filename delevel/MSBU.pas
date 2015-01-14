unit MSBU;
interface
uses Windows,Dialogs,SysUtils,ExtCtrls,Classes,Coding,IniFiles,variants,Contnrs
  ,AAction,TItems,Other_Func;

Type
  TUser= class
  Public
    Name: String[40];
    Online:boolean;
    ObjectID:integer;

    DP:integer; //DeathPenaltyBuffLevel
    Lvl:integer;
    
    x:integer;
    y:integer;
    z:integer;

    INMTT:boolean;
    INRP:boolean;
    INDP:boolean;
    IList:TItemList;
    status:string[10];

    Procedure Init(CnName:string);

    constructor create;
    destructor destroy; override;
end;
  TUserList = class(TObjectList)
  private
    function GetItems(Index: Integer): TUser;
    procedure SetItems(Index: Integer; const Value: TUser);
  public
    property Items[Index: Integer]: TUser read GetItems write SetItems; default;
  end;
var
  User:TUserList;
  implementation


constructor TUser.create;
begin
  IList:=TItemList.Create;
end;

destructor TUser.destroy;
begin
  if IList<>nil then IList.Free;
  inherited;
end;
procedure TUser.Init(CnName:string);
begin
  Online:=true;
  Name:=CnName;

end;

function TUserList.GetItems(Index: Integer): TUser;
begin
Result:=nil;
try
  Result := TUser(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TUserList.GetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

procedure TUserList.SetItems(Index: Integer; const Value: TUser);
begin
try
  inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TUserList.SetItems:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
End;
end;

Begin
end.
