library Delevel;

{$define RELEASE} // для совместимости с релизом пакетхака, при дебуге можно закоментировать

uses
  SysUtils,
  Windows,
  Dialogs,
  Classes,
  Coding,
  IniFiles,
  Forms,
  AAction in 'AAction.pas',
  Unit2 in 'Unit2.pas',
  MSBU in 'MSBU.pas',
  TItems in 'TItems.pas',
  Other_Func in 'Other_Func.pas',
  MsbForm in 'MsbForm.pas' {Form2};

var                                {version} {revision}
  min_ver_a: array[0..3] of Byte = ( 3,4,1,      46   );
  min_ver: Integer absolute min_ver_a; // минимальная поддерживаемая версия программы
function GetPluginInfo(const ver: Integer): PChar; stdcall;
begin
  if ver<min_ver then
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.4.0+'+sLineBreak+
            'У вас старая версия программы! Плагин не сможет корректно с ней работать!'
  else
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.4.0+'+sLineBreak+
            'Delevel';
end;

function SetStruct(const struct: TPluginStruct): Boolean; stdcall;
begin
  ps:=struct;
  Result:=True;
end;

procedure OnLoad; stdcall;
var i:integer;
begin
Try
  User:=TUserList.Create;
  for i := 0 to 9 do User.Add(TUser.create);

  except on E : Exception do
    ShowMessage('ОШИБКА OnLoad:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure OnPacket(const cnt: Cardinal; const fromServer: Boolean; var pck: TPacket); stdcall;
Var i:integer;
begin
Try
  if pck.size<3 then exit;
  ppck:=@pck;
  if (ps.Threads[cnt].Name<>'') and (not user[cnt].Online) then Begin
    user[cnt].Init(ps.Threads[cnt].Name);
  End;

//----------------------------------------------------------Пакети от клиента---
  if not FromServer then Begin
    if(pck.id=$3A) then User[cnt].INMTT:=False;//-------------------Appearing---
    //-------------------------------------------------------ValidatePosition---
    if pck.id=$59 then MTL(cnt,user[cnt].ObjectID,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),true);
    //--------------------------------------------------------------------------
  End;
  //----------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------------------------------------------------------Пакети от сервера---
  if FromServer then Begin
    //---------------------------------------------------------------UserInfo---
    if pck.id=$32 then Begin
      i:=length(ps.ReadSEx(pck,23))*2;
      UserInfo(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,19),ps.ReadDEx(pck,33+i),ps.ReadDEx(pck,37+i),ps.ReadSEx(pck,23));
    End;
    //---------------------------------------------------------------ItemList---
    if (pck.id=$11) then //IL(CID,OID,IID,C,n:integer);
      for i:=0 to ps.ReadHEx(pck,5)-1 do
        IL(cnt,ps.ReadDEx(pck,9+i*72),ps.ReadDEx(pck,13+i*72),ps.ReadDEx(pck,21+i*72),i);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------InventoryUpdate---
    if (pck.id=$21) Then //InventoryUpdate(CID,CH,OID,IID,C:integer);
      for i:=0 to ps.ReadHEx(pck,3)-1 do
        InventoryUpdate(cnt,ps.ReadHEx(pck,5+(i*70)),ps.ReadDEx(pck,9+(i*70)),ps.ReadDEx(pck,13+(i*70)),ps.ReadDEx(pck,21+(i*70)));
    //--------------------------------------------------------------------------
    if pck.id=$B9 then MyT(cnt,ps.ReadDEx(pck,3));//--------Получение таргета---
    if pck.id=$F9 then User[cnt].DP:=ps.ReadDEx(pck,27);//----EtcStatusUpdate---
    //------------------------------------------------Обработка появления Npc---
    if (pck.id=$0C) and (ps.ReadCEx(pck,122)=0) and (ps.ReadDEx(pck,11)=0)then Begin
      if ps.ReadDEx(pck,7)=1030336 then Curtis:= ps.ReadDEx(pck,3);
      if ps.ReadDEx(pck,7)=1030338 then MelvilLe:= ps.ReadDEx(pck,3);
      if ps.ReadDEx(pck,7)=1030331 then Thoma:= ps.ReadDEx(pck,3);
      if ps.ReadDEx(pck,7)=1030334 then Badenco:= ps.ReadDEx(pck,3);
      End;
    //-------------------------------------------------------ValidateLocation---
    if pck.id=$79 then MTL(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(ppck^,7),ps.ReadDEx(ppck^,11),ps.ReadDEx(ppck^,15));
    //--------------------------------------------------------------------Die---
    if (pck.id=$00) and (ps.ReadDEx(pck,3)=User[cnt].ObjectID) then Begin
      sts(cnt,'7D00000000');
      User[cnt].INRP:=false;
      User[cnt].INDP:=false;
      //User[cnt].INMTT:=false;
    End;
  end;
  except on E : Exception do
    ShowMessage('ОШИБКА OnPacket:'+inttostr(pck.id)+'--'+inttostr(cnt)+'--'+E.ClassName+' ошибка: '+E.Message);
  End;
  end;

// Необязательно вызываемая функция. (может отсутствовать в плагине)
// Вызывается при выгрузке плагине
procedure OnFree; stdcall;
begin
Try
  User.Free;

  except on E : Exception do
    ShowMessage('ОШИБКА OnFree:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;


exports
  GetPluginInfo,
  OnPacket,
  OnLoad,
  SetStruct,
  OnFree;
begin
Try Begin
  Form2:=TForm2.Create(application);
End;
  except on E : Exception do
    ShowMessage('код 1:ОШИБКА ИНИЦИАЛИЗАЦИИ ДАННЫХ!!! '+E.ClassName+' ошибка: '+E.Message);
End;
end.
