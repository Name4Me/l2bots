unit AAction;

interface
uses Coding, SysUtils,Dialogs,Classes,windows,ExtCtrls,unit2;
  procedure STS(CID:integer;msg:string;F:boolean = true);
Var
  ppck: PPacket;
  ps: TPluginStruct;

implementation
//------------------------------------------------------------Отправка пакета---
procedure STS(CID:integer;msg:string;F:boolean = true);
var
  buf: string;
begin
  if (CID<>-1) and (msg<>'') then
  with ps do begin
    buf:=HexToString(msg);
    SendPckStr(buf,CID,f);
  end;
end;
//------------------------------------------------------------------------------
end.

