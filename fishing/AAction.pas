unit AAction;

interface
uses Coding, SysUtils,Dialogs,Classes,windows,ExtCtrls,Other_Func;
  procedure MagicSU(CID,MagicID:integer);
  procedure UseItem(CID,OID:integer);
  procedure Reeling(CID:integer);
  procedure Pumping(CID:integer);
  procedure STS(CID:integer;msg:string;F:boolean = true);
  procedure Say(CID:integer;msg:string);


const
  fish=1312;   //ID fishing
  pump=1313;  //ID pumping
  reel=1314; //ID reeling

Var
  MyID:integer;

  FShotID:integer;
  FShotOID:integer;
  FShotCount:integer;

  LHID:integer;// ќбЇкт в левой руке
  RHID:integer;// ќбЇкт в правой руке
  
  CurenLureOID:integer;
  CurenLureCount:integer;
  Tfe:integer;
  stop:boolean = false;


  isFishing:boolean = false; //Ћовим

  INH:boolean;

  HP:integer;
  MaxHP:integer;



  HPObjID:integer;
  HPiID:integer;
  HPc:integer;

  ppck: PPacket;
  ps: TPluginStruct;
implementation


procedure MagicSU(CID,MagicID:integer);
begin
  sts(CID,'39'+anti4HEX(inttostr(MagicID))+'00 00 00 00 00');
end;

procedure UseItem(CID,OID:integer);
begin
  sts(CID,'19'+anti4HEX(inttostr(OID))+'00 00 00 00');
end;

procedure Reeling(CID:integer);
begin
  if (FShotOID<>0) and (FShotcount>0) then UseItem(CID,FShotOID);
  MagicSU(CID,reel);
end;
procedure Pumping(CID:integer);
begin
  if (FShotOID<>0) and (FShotcount>0) then UseItem(CID,FShotOID);
  MagicSU(CID,pump);
end;



procedure Say(CID:integer;msg:string);
var
  buf: string;
begin
  with ps do begin
    buf:=HexToString('4A 00 00 00 00');
    WriteD(buf,2);
    WriteS(buf,'AutoFisher');
    WriteS(buf,msg);
    SendPckStr(buf,CID,False);
  end;
end;

//------------------------------------------------------------ќтправка пакета---
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

end.

