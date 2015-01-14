unit Unit2;

interface

uses SysUtils,Dialogs,Classes,Windows;

  procedure StatsUpdate(cid,OID,id,Value:integer);

implementation
uses Other_Func,AAction;

//-----------------------------------------------------------Инфа по CP,HP,MP---
procedure StatsUpdate(cid,OID,id,Value:integer);
begin
  Try
  if OID=MyId then Begin
    case id of
        9: HP:=Value;
        10: MaxHP:=Value;
        end;
    if (MaxHP>0) and (HP/MaxHP<0.8) and (not INH)and (HPObjID<>0) and (HPc>0) then Begin
      INH:=True;
      STS(cid,'19'+anti4HEX(inttostr(HPObjID))+'00 00 00 00');
      End;
    end;
  except on E : Exception do
    ShowMessage('ОШИБКА StatsUpdate:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;
end.
