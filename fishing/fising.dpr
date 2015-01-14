library fising;

{$define RELEASE} // для совместимости с релизом пакетхака, при дебуге можно закоментировать

uses
  FastMM4,
  SysUtils,
  Windows,
  Dialogs,
  Classes,
  Coding,
  IniFiles,
  Other_Func in 'Other_Func.pas',
  AAction in 'AAction.pas';

var                                {version} {revision}
  min_ver_a: array[0..3] of Byte = ( 3,4,1,      46   );
  min_ver: Integer absolute min_ver_a; // минимальная поддерживаемая версия программы
  wc:integer;
  CharName:string;
function GetPluginInfo(const ver: Integer): PChar; stdcall;
begin
  if ver<min_ver then
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.4.0+'+sLineBreak+
            'У вас старая версия программы! Плагин не сможет корректно с ней работать!'
  else
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.4.0+'+sLineBreak+
            'Авто Рибалка';
end;

function SetStruct(const struct: TPluginStruct): Boolean; stdcall;
begin
  ps:=struct;
  Result:=True;
end;

procedure OnLoad; stdcall;
var i:integer;
begin
  wc:=-1;
  for i:=0 to ps.ThreadsCount-1 do begin
    //cntHP:=i;
    Say(i,'Для выбора нужного соединения наберите в чате слово set и отправьте');
  end;
  //cntHP:=-1;
end;

procedure OnPacket(const cnt: Cardinal; const fromServer: Boolean; var pck: TPacket); stdcall;
Var i:integer;
  IniF:TIniFile;
//var buf: string;
begin
Try
  if pck.size<3 then exit;
  ppck:=@pck;
//----------------------------------------------------------Пакети от клиента---
  if(ps.ReadSEx(pck,3)='set') and (wc<>-1)then Begin
    pck.size:=2; // не пропускаем пакет
    stop:=false;
  End;
  if(ps.ReadSEx(pck,3)='set') and (wc=-1)then begin
    pck.size:=2; // не пропускаем пакет
    wc:=cnt;
    CharName:=ps.Threads[cnt].Name;
    IniF:= TIniFile.Create(GetCurrentDir+'\Chars\'+CharName+'.ini');
    FShotID:=IniF.ReadInteger('Fishing','FShotID',0);
    HPiID:=IniF.ReadInteger(CharName,'HPiID',0);
    IniF.Free;
    Say(cnt,'Выбрано соединение '+inttostr(wc));
    sts(cnt,'14');
  end;
  if(ps.ReadSEx(pck,3)='stop') then Begin
    pck.size:=2;
    stop:=true;
  End;
//------------------------------------------------------------------------------
//----------------------------------------------------------Пакети от сервера---
  if FromServer then


    if (wc<>-1) and (wc=cnt) then Begin

      if (pck.id=$FE) and (wc<>-1) then case ps.ReadHEx(pck,3) of
      31: if not stop then Begin
        Tfe:=GetTickCount;
        isFishing:=false;
      End;
      40: begin
        if (ps.ReadCEx(pck,17)=0) and (ps.ReadCEx(pck,19)=0) then pumping(cnt);
        if (ps.ReadCEx(pck,17)=1) and (ps.ReadCEx(pck,19)=0) then reeling(cnt);
        end;
      end;
      

      if (GetTickCount-Tfe>2000) and (not isFishing) and (not stop) then Begin
        isFishing:=true;
        Tfe:=GetTickCount;
        if (CurenLureCount>0) then MagicSU(cnt,fish);
      End;
      if (pck.id=$32) and (cnt=wc) then Begin
        MyId:=ps.ReadDEx(pck,19);

        RHID:=ps.ReadDEx(pck,(133+(length(ps.ReadSEx(pck,23))*2)));
        LHID:=ps.ReadDEx(pck,(137+(length(ps.ReadSEx(pck,23))*2)));
        //Say(cnt,'CurenLure:'+inttostr(CurenLureOID)+'/'+inttostr(CurenLureCount));
      End;

    //-----------------------------------------------------------StatusUpdate---
    if (pck.id=$18) and (ps.ReadDEx(pck,3)=MyId) then
      for i:=0 to ps.ReadDEx(pck,7)-1 do Begin
        case ps.ReadDEx(pck,11+i*8) of
          9: HP:=ps.ReadDEx(pck,15+i*8);
          10: MaxHP:=ps.ReadDEx(pck,15+i*8);
          end;
        if (MaxHP>0) and (HP/MaxHP<0.8) and (not INH)and (HPObjID<>0) and (HPc>0) then Begin
          INH:=True;
          STS(cnt,'19'+anti4HEX(inttostr(HPObjID))+'00 00 00 00');
          End;
       End;


    //--------------------------------------------------------InventoryUpdate---
    if (pck.id=$21) Then
      for i:=0 to ps.ReadHEx(pck,3)-1 do begin
        if ps.ReadDEx(pck,13+(i*70))=FShotID then Begin
          FShotOID:=ps.ReadDEx(pck,9+(i*70));
          FShotcount:=ps.ReadDEx(pck,21+(i*70));
          End;
        if ps.ReadDEx(pck,13+(i*70))=HPiID then Begin
          HPObjID:=ps.ReadDEx(pck,9+(i*70));
          HPc:=ps.ReadDEx(pck,21+(i*70));
          End;
        case ps.ReadDEx(pck,13+i*72) of
          6519..6527: Begin
            if LHID=ps.ReadDEx(pck,9+i*72) then CurenLureOID:=LHID;
            if LHID=ps.ReadDEx(pck,9+i*72) then CurenLureCount:=ps.ReadDEx(pck,21+i*72);
          End;
        end;
        case ps.ReadDEx(pck,13+(i*70)) of
          6516..6518,6483..6491: UseItem(cnt,ps.ReadDEx(pck,9+(i*70)));
        end;
      end;
    //--------------------------------------------------------------------------
    //---------------------------------------------------------------ItemList---
    if (pck.id=$11) then
      for i:=0 to ps.ReadHEx(pck,5)-1 do Begin
        if ps.ReadDEx(pck,13+i*72)=FShotID then Begin
          FShotOID:=ps.ReadDEx(pck,9+i*72);
          FShotcount:=ps.ReadDEx(pck,21+i*72);
        //Say(cnt,'FShot:'+inttostr(FShotcount));
          End;
        if ps.ReadDEx(pck,13+i*72)=HPiID then Begin
          HPObjID:=ps.ReadDEx(pck,9+i*72);
          HPc:=ps.ReadDEx(pck,21+i*72);
          End;
        case ps.ReadDEx(pck,13+i*72) of
          6519..6527: Begin
            if LHID=ps.ReadDEx(pck,9+i*72) then CurenLureOID:=LHID;
            if LHID=ps.ReadDEx(pck,9+i*72) then CurenLureCount:=ps.ReadDEx(pck,21+i*72);
          End;
        end;
      End;
    //--------------------------------------------------------------------------
    if pck.id=$62 then Begin //---------------------------------SystemMessage---
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2037) then INH:=false; //2037
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2032) then INH:=false; //2032
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2031) then INH:=false; //2031
      End;
  end;     
  except on E : Exception do
    ShowMessage('ОШИБКА OnPacket:'+inttostr(pck.id)+'--'+inttostr(cnt)+'--'+E.ClassName+' ошибка: '+E.Message);
  End;
  end;

// Необязательно вызываемая функция. (может отсутствовать в плагине)
// Вызывается при выгрузке плагине
procedure OnFree; stdcall;
Var IniF:TIniFile;
begin
  IniF:= TIniFile.Create(GetCurrentDir+'\Chars\'+CharName+'.ini');
  IniF.WriteInteger('Fishing','FShotID',FShotID);
  IniF.WriteInteger(CharName,'HPiID',HPiID);
  IniF.Free;
end;


exports
  GetPluginInfo,
  OnPacket,
  OnLoad,
  SetStruct,
  OnFree;
begin
Try Begin
  //Form2:=TForm2.Create(application);
End;
  except on E : Exception do
    ShowMessage('код 1:ОШИБКА ИНИЦИАЛИЗАЦИИ ДАННЫХ!!! '+E.ClassName+' ошибка: '+E.Message);
End;
end.
