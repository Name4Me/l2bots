library AUTO2;

{$define RELEASE} // для совместимости с релизом пакетхака, при дебуге можно закоментировать

uses
  SysUtils,
  Windows,
  Dialogs,
  Classes,
  IniFiles,
  Forms,
  AAction in 'AAction.pas',
  Unit2 in 'Unit2.pas',
  MSBU in 'MSBU.pas',
  TItems in 'TItems.pas',
  TSkils in 'TSkils.pas',
  TNpcs in 'TNpcs.pas',
  Other_Func in 'Other_Func.pas',
  MsbForm in 'MsbForm.pas' {Form2},
  OtherTypes in 'OtherTypes.pas',
  TChars in 'TChars.pas',
  Agumentation in 'Agumentation.pas',
  usharedstructs in 'usharedstructs.pas';

var                                {version} {revision}
  min_ver_a: array[0..3] of Byte = (3,5,12,120);
  min_ver: Integer absolute min_ver_a; // минимальная поддерживаемая версия программы
  fcl:boolean = false;
  MD:TMyDelay;
function GetPluginInfo(const ver: Integer): PChar; stdcall;
begin
  if ver<min_ver then
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.5.12+'+sLineBreak+
            'У вас старая версия программы! Плагин не сможет корректно с ней работать!'
  else
    Result:='Plugin к программе l2phx'+sLineBreak+
            'Для версий 3.5.12+'+sLineBreak+
            'Авто CP HP MP....';
end;                                   

function SetStruct(const struct: PPluginStruct): Boolean; stdcall;
begin
  ps:=TPluginStruct(struct^);
  Result:=True;
end;

procedure OnLoad; stdcall;
var
  ml:^Tstrings;
begin
Try
  
  Form2:=TForm2.Create(application);
  User:=TUserList.Create;
  User.OwnsObjects:=True;
  
  New(ml);
  ml^:=TstringList.Create;
  ml^.LoadFromFile(CurrentDir+'\Settings\My.ini');
  Form2.Left:=StrToIntDef(ml.Values['Left'],100);
  Form2.Top:=StrToIntDef(ml.Values['Top'],100);
  ml^.Free;
  Dispose(ml);
  except on E : Exception do
    ShowMessage('ОШИБКА OnLoad:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure OnPacket(const cnt: Cardinal; const fromServer: Boolean; const connectionname:string; var pck : tpacket); stdcall;
Var i,n:integer;
s:string;
begin
Try
  ppck:=@pck;
  if (pck.Size<3) or (fcl) then exit;
  //if (FromServer) // (user[cnt]=nil) and
    //and ((pck.pckId=$32) or (pck.pckId=$2F) or (pck.pckId=$11))then Begin
    //user.Add(TUser.create(cnt,connectionname));
    //Form2.Ncr(cnt);
   //End;
   //---------------------------------------------------------------UserInfo---
   Say(cnt,inttostr(pck.pckData[0]));
   //if (pck.pckData[0]=$32) and (FromServer) then Begin
      //Say(cnt,ps.ReadSEx(pck,23));
      //End;
  Exit;
  if user[cnt]=nil then Exit else
  with user[cnt] do Begin
    if connectionname<>user[cnt].PName then Init(connectionname);
    inc(Bussi);
//----------------------------------------------------------Пакети от клиента---
  if not FromServer then Begin
    //----------------------------------------------------------RequestRefine---
    if (pck.pckId=$D0) and (ps.ReadHEx(pck,3)=68) then Begin
      SetAgValue(cnt,ps.ReadHEx(pck,3),ps.ReadDEx(pck,5),ps.ReadDEx(pck,9),ps.ReadDEx(pck,13),ps.ReadDEx(pck,17));
      End;
    if pck.pckId=$5F then Begin//-----------------------------------------Enchat---
      //encid:=ps.ReadDEx(pck,3);
      //pck.size:=2;
      End;
    if pck.pckId=$49 then Begin
      s:=ps.ReadSEx(pck,3);
      if pos(s,'ago,pgo,sbgo,pbgo,abgo,obgo,sck,asgo,sl,srk,mtck,mtt,rgo,rstop,rp,gid,np,sbs,ag,ka,tp')<>0 then pck.size:=2; // не пропускаем пакет
      if s='tp' then Begin
        STS(cnt,'0f'+anti4HEX(x+100)+anti4HEX(y)+anti4HEX(z)+'00000000000000000000000001000000');

      End;


      if s='ago' then User[cnt].OnAutoAtack:=true;
      if s='asgo' then User[cnt].OnAutoAssist:=true;
      if s='pgo' then User[cnt].OnAutoPickUp:=true;
      if s='sbgo' then User[cnt].OnselfBaf:=true;
      if s='obgo' then User[cnt].OnOfBaf:=true;
      if s='pbgo' then User[cnt].OnPartyBaf:=true;
      if s='abgo' then User[cnt].OnAutoBaf:=true;
      if s='da' then MA.SetAction(0,'0=DLGSEL(talk_select)');
      if s='sbs' then User[cnt].OnSBS:=True;
      if s='np' then User[cnt].isInMTP:=false;

      if s='ag' then Begin 
        sts(cnt,'D0 44 00'+anti4HEX(IList.Itemi[6369].OID)+anti4HEX(IList.Itemi[8732].OID)+anti4HEX(IList.Itemi[2131].OID)+'19 00 00 00');
        End;
      if s='mtt' then Begin
        User[cnt].OnAutoMTT:=true;
        say(cnt,'OnAutoMTT On');
        End;
      if s='gid' then Begin
        say(cnt,'NpcID: '+inttostr(NpcList.Itemi[CurentT.ID].NpcID));
        End;
      if s='rgo' then User[cnt].RecordTreck:=true;
      if s='rp' then Treck.AddPoint(x,y,z);
      if s='rstop' then Begin
        User[cnt].RecordTreck:=False;
        User[cnt].Treck.SaveToFile(GetCurrentDir+'\Treks\'+User[cnt].PName+'.trk');
        End;

      if s='sck' then Begin
        CurentCK.x:=User[cnt].x;
        CurentCK.y:=User[cnt].y;
        CurentCK.z:=User[cnt].z;
        NpcList.SetXYZ(User[cnt].x,User[cnt].y,User[cnt].z,True);
        say(cnt,'Центр кача установлен');
        End;
      if s='mtck' then Begin
        with User[cnt].CurentCK do MoveToXYZ(cnt,x,y,z);
        say(cnt,'Идём к точке кача');
        End;
      if s='srk' then Begin
        if User[cnt].CurentCK.x<>0 then User[cnt].rk:=ras(User[cnt].CurentCK.x,User[cnt].CurentCK.y,User[cnt].x,User[cnt].y);
        say(cnt,'Радиус кача - '+inttostr(User[cnt].rk));
        End;
      if s='sl' then Begin
        if CurentT.ID<>0 then Lider.ID:=CurentT.ID;
        if Lider.ID<>0 then OnMoveToLiader:=True;
        say(cnt,'Лидер выбран');
        End;
      End;

    if(pck.pckId=$23) and (pos(ps.ReadSEx(pck,3),'sbs,np,mtt,p4,sa,ag,ka,rp')<>0) then Begin
      ByPass(cnt,ps.ReadSEx(pck,3));
      pck.size:=2; // не пропускаем пакет
      End;
  //------------------------------------------------------RequestSocialAction---
    if(pck.pckId=$34)then Begin
      if ps.ReadDEx(pck,3)=6 then Begin // Yes
        pck.size:=2;// не пропускаем пакет
        //Form2.Visible:=true;
        ShowInfo(cnt);
        End;
      if ps.ReadDEx(pck,3)=5 then Begin // No
        pck.size:=2;// не пропускаем пакет
        Form2.Visible:=false;
        End;
      if ps.ReadDEx(pck,3)=11 then Begin // Aplaus
        pck.size:=2;// не пропускаем пакет
        End;
      End;
    //-------------------------------------------------------ValidatePosition---
    if pck.pckId=$59 then
        ValidatePosition(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11));
    //--------------------------------------------------------------------------
    if pck.pckId=$0f then StopMoveTT(cnt);//--------------MoveBackwardToLocation---
    if pck.pckId=$48 then StopMoveTT(cnt);//----------------RequestTargetCanceld---
    //--------------------------------------------------------------------------
  End;
  //----------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------------------------------------------------------Пакети от сервера---
  if FromServer then  Begin
    //-----------------------------------------------------------AskJoinParty---
    if (pck.pckId=$39) and  (pos(ps.ReadSEx(pck,3),'M001,M002,Atrei')<>0) then sts(cnt,'4301000000');
    // 43 01 00 00 00  RequestAnswerJoinParty
    if (pck.pckId=$f3) and (ps.ReadDEx(pck,3)=1510) and (ps.ReadSEx(pck,15)='M002') then sts(cnt,'C6E605000001000000'+anti4HEX(User[cnt].ObjectID));
    if ((pck.pckId=$2f) or (pck.pckId=$27)) and (ObjectID=0) then sts(cnt,'14');
    //---------------------------------------------------------------SellList---
    if pck.pckId=$06 then Begin
      s:='';
      n:=0;
      for I := 0 to IList.Count - 1 do if ASL.IndexOf(intToStr(IList[i].ID))<>-1 then Begin
        With IList[i] do s:=s+anti4HEX(OID)+anti4HEX(ID)+anti4HEX(Count);
        inc(n);
        End;
      if n<>0 then STS(Cnt,'37'+anti4HEX(ps.ReadDEx(pck,7))+anti4HEX(n)+s);

        
      End;
    //-------------------------------------------------------AcquireSkillList---
    if pck.pckId=$90 then Begin
      ASkID:=0;
      ASkLvl:=0;
      for i:=0 to ps.ReadDEx(pck,7)-1 do
        if (ASkID=0) and (ps.ReadDEx(pck,27+i*20)=0) and (ps.ReadDEx(pck,23+i*20)<=SP) then Begin
          ASkID:=ps.ReadDEx(pck,11+i*20);
          ASkLvl:=ps.ReadDEx(pck,15+i*20);
          End;
       End;
    //-------------------------------------------------------AcquireSkillList---
    if (pck.pckId=$C7) and (ASkID<>0) then Begin
      sts(cnt,'7C'+anti4HEX(ASkID)+anti4HEX(ASkLvl)+'00000000');
      ASkID:=0;
      ASkLvl:=0;
      End;
    //---------------------------------------------------------------UserInfo---
    if pck.pckId=$32 then Begin
      i:=23+(Length(ps.ReadSEx(pck,23))*2)+2;
      n:=i;
      i:=i+508+(Length(ps.ReadSEx(pck,i+508))*2)+2;
      UserInfo(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,19),ps.ReadDEx(pck,i+53),ps.ReadDEx(pck,n+64),ps.ReadSEx(pck,23));
      RHID:=ps.ReadDEx(pck,(133+(length(ps.ReadSEx(pck,23))*2)));
      LHID:=ps.ReadDEx(pck,(137+(length(ps.ReadSEx(pck,23))*2)));
      End;
    //---------------------------------------------------------------CharInfo---
    if pck.pckId=$31 then Begin
      i:=23+(Length(ps.ReadSEx(pck,23))*2)+2;
      i:=i+272+(Length(ps.ReadSEx(pck,i+272))*2)+2;
      CharInfo(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,19),ps.ReadDEx(pck,i+41),ps.ReadDEx(pck,i),ps.ReadSEx(pck,23));
      //say(cnt,ps.ReadSEx(pck,23)+' - '+inttostr(ps.ReadDEx(pck,i)));  1435
      End;
    //----------------------------------------------------------------PetInfo---
    if (pck.pckId=$B2) or (pck.pckId=$B6) then Begin
      Pet.stype:=ps.ReadDEx(pck,3);
      Pet.ID:=ps.ReadDEx(pck,7);
      //if ps.ReadCEx(pck,125)=1 then user[cnt].Pet.isInCombat:=true else user[cnt].Pet.isInCombat:=false;
      End;
    //--------------------------------------------------------PetStatusUpdate---
    if pck.pckId=$B6 then Begin
      Pet.ID:=ps.ReadDEx(pck,7);
      i:=23+(Length(ps.ReadSEx(pck,23))*2)+2;
      Pet.HP:=ps.ReadDEx(pck,i+8);
      Pet.MaxHP:=ps.ReadDEx(pck,i+12);
      if (Pet.HP<(Pet.MaxHP-500)) and (Pet.HPC<>0)
        and (GetTickCount-Pet.LTU>15000) then Begin
          sts(cnt,'94'+anti4HEX(Pet.HPID));
          Pet.LTU:=GetTickCount;
          End;
      //say(cnt,inttostr(user[cnt].Pet.HP)+'\'+inttostr(user[cnt].Pet.MaxHP));
    End;
    //-----------------------------------------------------PetInventoryUpdate---
    if pck.pckId=$B4 then Begin
      for i:=0 to ps.ReadHEx(pck,3)-1 do Begin
        if ps.ReadDEx(pck,13+i*58)=1539 then Begin
          Pet.HPID:=ps.ReadDEx(pck,9+i*58);
          Pet.HPC:=ps.ReadDEx(pck,17+i*58);
          End;
        if (ps.ReadDEx(pck,13+i*58)=9668) and (ps.ReadDEx(pck,17+i*58)<20) then Begin
          say(cnt,inttostr(ps.ReadDEx(pck,17+i*58))+' Мало еди у питомца!!!');
          sts(cnt,'56130000000000000000');
          End;

      End;
    End;
    //-------------(CID,PlayerID,OID,InvID,x,y,z,c:integer)----------DropItem---
    if pck.pckId=$16 then
      DropItem(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,15),ps.ReadDEx(pck,19),ps.ReadDEx(pck,23),ps.ReadDEx(pck,31));
    //--------------------------------------------------------------------------
    if (pck.pckId=$17) and (ps.ReadDEx(pck,3)=ObjectID) then isInCombat:=False;
    //--------------------------------------------------------------------------
    if (pck.pckId=$05) then DropItem(cnt,0,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,15),ps.ReadDEx(pck,19),ps.ReadDEx(pck,27));
    //--------------------------------------------------------------------------

    //---------------------------------------------------------------ItemList---
    if (pck.pckId=$11) then //IL(CID,OID,IID,C,n:integer);
      for i:=0 to ps.ReadHEx(pck,5)-1 do
        IL(cnt,ps.ReadDEx(pck,9+i*72),ps.ReadDEx(pck,13+i*72),ps.ReadDEx(pck,21+i*72),ps.ReadDEx(pck,39+i*72),i);
    //--------------------------------------------------------------------------
    //--------------------------------------------------------InventoryUpdate---
    if (pck.pckId=$21) Then //InventoryUpdate(CID,CH,OID,IID,C:integer);
      for i:=0 to ps.ReadHEx(pck,3)-1 do
        InventoryUpdate(cnt,ps.ReadHEx(pck,5+(i*74)),ps.ReadDEx(pck,9+(i*74)),ps.ReadDEx(pck,13+(i*74)),ps.ReadDEx(pck,21+(i*74)),ps.ReadDEx(pck,39+(i*74)));
    //--------------------------------------------------------------------------
    //----------------------------------------------------------SystemMessage---
    if pck.pckId=$62 then Begin
      if (ps.ReadDEx(pck,3)=1405) or ((ps.ReadDEx(pck,3)=48) and (ps.ReadDEx(pck,15)=5592)) then IsCPUse:=false; //---------------------------CP restore---
      if (ps.ReadDEx(pck,3)=936) and (ps.ReadDEx(pck,15)=5592) then IsCPUse:=True;

      if (ps.ReadDEx(pck,3)=44) then Begin  //Крит
        //sts(cnt,'5F'+anti4HEX(encid));
        End;
      if (ps.ReadDEx(pck,3)=46) and (ps.ReadDEx(pck,15)=MCS)  then Begin
        CurentT.CurseTime:=GetTickCount;
        CurentT.isInCurse:=True;
        End;
      if (ps.ReadDEx(pck,3)=139) and (ps.ReadDEx(pck,31)= MCS)  then CurentT.isInCurse:=False;
      if (ps.ReadDEx(pck,3)=46) and (ps.ReadDEx(pck,15)= 42)  then isInSweep:=False;
      if (ps.ReadDEx(pck,3)=612) or (ps.ReadDEx(pck,3)=357) then CurentT.spoiled:=true;

      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=20320) then IsMPUse:=false;//20320
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=20370) then IsMPUse:=false;//20370
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2037) then IsHPUse:=false; //2037
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2035) then UseITEm(cnt,1375);
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2032) then IsHPUse:=false; //2032
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=2031) then IsHPUse:=false; //2031
      if (ps.ReadDEx(pck,3)=92)and(ps.ReadDEx(pck,15)=4072) then UnHold(cnt); //2031
      if (ps.ReadDEx(pck,3)=22)  or (ps.ReadDEx(pck,3)=181) then  Begin //(22) цель слишком далеко (181) цель не видно
        INKT:=false;
        isInCombat:=false;
        //sts(cnt,'84',false);//LeaveWorld
        if not MD.Active then sts(cnt,'57');//RequestRestart
        MD.SLTU(500);
        End;
      End;
    //--------------------------------------------------------------------------
    //-----------------------------------------------------------StatusUpdate---
    if pck.pckId=$18 then
       for i:=0 to ps.ReadDEx(pck,7)-1 do
        StatsUpdate(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,11+i*8),ps.ReadDEx(pck,15+i*8));
    //--------------------------------------------------------------------------
    //-----------------------------------------------------------PartySpelled---
    if pck.pckId=$F4 then
       for i:=0 to ps.ReadDEx(pck,11)-1 do
        PartySpelled(cnt,ps.ReadDEx(pck,7),ps.ReadDEx(pck,15+i*10),ps.ReadDEx(pck,21+i*10));
    //--------------------------------------------------------------------------
    //----------------------------------------------PartySmallWindowDeleteAll---
    if pck.pckId=$50 then PartyList.Clear;
    //-------------------------------------------------PartySmallWindowDelete---
    if pck.pckId=$51 then PartyList.DelChar(ps.ReadDEx(pck,3));
    //-------------------------------------------------PartySmallWindowUpdate---
    if pck.pckId=$52 then Begin
      i:=Length(ps.ReadSEx(pck,7))*2;
      PartySWUpdate(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,9+i),ps.ReadDEx(pck,13+i)
        ,ps.ReadDEx(pck,17+i),ps.ReadDEx(pck,21+i),ps.ReadDEx(pck,25+i)
        ,ps.ReadDEx(pck,29+i),ps.ReadDEx(pck,33+i),ps.ReadDEx(pck,37+i),ps.ReadSEx(pck,7));
    End;
    //--------------------------------------------------------------------------
    //-------------------------------------------------ExPartyPetWindowUpdate---
    if (pck.pckId=$FE) and (ps.ReadHEx(pck,3)=25) then Begin
      i:=Length(ps.ReadSEx(pck,21))*2;
      PartySWUpdate(cnt,ps.ReadDEx(pck,5),0,0
        ,ps.ReadDEx(pck,23+i),ps.ReadDEx(pck,27+i),ps.ReadDEx(pck,31+i)
        ,ps.ReadDEx(pck,35+i),ps.ReadDEx(pck,39+i),0,ps.ReadSEx(pck,21));
    End;
    //--------------------------------------------------------------------------
    //----------------------------------------------------PartyMemberPosition---
    if pck.pckId=$BA then for i:=0 to ps.ReadDEx(pck,3)-1 do
      PartyMemberPosition(cnt,ps.ReadDEx(pck,7+i*16),ps.ReadDEx(pck,11+i*16),ps.ReadDEx(pck,15+i*16),ps.ReadDEx(pck,19+i*16));
    //--------------------------------------------------------------------------
    //---------------------------------------------------------------SkilList---
    if (pck.pckId=$5f) and (User[cnt].PName<>'') then
      for i:=0 to ps.ReadDEx(pck,3)-1 do
        if ((ps.ReadDEx(pck,7+(i*13)))=0) and (User[cnt].IgnorList.IndexOfName(inttostr(ps.ReadDEx(pck,15+(i*13))))=-1) then
          User[cnt].SkilList.ADDSkil(sid.Values[inttostr(ps.ReadDEx(pck,15+(i*13)))],ps.ReadDEx(pck,15+(i*13)));
    //--------------------------------------------------------------------------
    //----------------------------------------------------------MagicSkillUse---
    if pck.pckId=$48 then MagicSkillUse(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),(ps.ReadDEx(pck,23)));    //ps.ReadDEx(pck,19)

    //---------------------------------------------------AbnormalStatusUpdate---
    if (pck.pckId=$85)and (PName<>'') then
      for i:=0 to ps.ReadHEx(pck,3)-1 do
        ASUpdate(cnt,ps.ReadDEx(pck,5+i*10),ps.ReadDEx(pck,11+i*10));
    //--------------------------------------------------------------------------
    if pck.pckId=$49 then Unkast(cnt,ps.ReadDEx(pck,3));//----MagicSkillCanceled---
    if pck.pckId=$54 then Unkast(cnt,ps.ReadDEx(pck,3));//----MagicSkillLaunched---
    //--------------------------------------------------------------------------
    if pck.pckId=$B9 then MyT(cnt,ps.ReadDEx(pck,3));//---------MyTargetSelected---
    //---------------------------------------------------------TargetSelected---
    if pck.pckId=$23 then TargetSelected(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7));
    //--------------------------------------------------------------------------
    if pck.pckId=$24 then UnTarget(cnt,ps.ReadDEx(pck,3));//------Потеря таргета---

    //------------------------------------------------Обработка появления Npc---
    if pck.pckId=$0C then
      NpcInfo(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadCEx(pck,121),ps.ReadCEx(pck,122),ps.ReadDEx(pck,15),ps.ReadDEx(pck,19),ps.ReadDEx(pck,23));
    //---------------------------------------------------------MoveToLocation---
    if pck.pckId=$2F then
      MTL(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,15));
    //-------------------------------------------------------ValidateLocation---
    if pck.pckId=$79 then
      MTL(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,11),ps.ReadDEx(pck,15));
    //-------------------------------------------------------------MoveToPawn---
    if pck.pckId=$72 then
      MTL(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,15),ps.ReadDEx(pck,19),ps.ReadDEx(pck,23),ps.ReadDEx(pck,7),true);
    //--------------------------------------------------------------------------
    if pck.pckId=$08 then DelObj(cnt,ps.ReadDEx(pck,3));//-------Удаляем обьєкти---
    if pck.pckId=$00 then Die(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,23));//---Die---
    //--------------------------------------------------------------------------
    //-----------------------------------------------------------------Attack---
    if pck.pckId=$33 then
      Attack(cnt,ps.ReadDEx(pck,3),ps.ReadDEx(pck,7),ps.ReadDEx(pck,16),ps.ReadDEx(pck,20));
    //--------------------------------------------------------------------------
    
    if pck.pckId=$71 then RR(cnt);//--------------------------RestartResponse---
    if pck.pckId=$84 then RR(cnt);//-----------------------------------logaut---
    if pck.pckId=$1f then ActionFailed(cnt);//----------------------ActionFailed---

  end;
  dec(User[cnt].Bussi);
  End;
  except on E : Exception do
    ShowMessage('ОШИБКА OnPacket:'+'--'+inttostr(cnt)+'--'+E.ClassName+' ошибка: '+E.Message);
  End;
  end;

// Необязательно вызываемая функция. (может отсутствовать в плагине)
// Вызывается при выгрузке плагине
procedure OnFree; stdcall;
var
  i:integer;
  ml:^Tstrings;
begin
Try
  fcl:=true;
  Form2.Free;
  for i := 0 to User.Count-1 do while User.Itemi[i].Bussi<>0 do;
  User.Free;
  //NI.Free;
  New(ml);
  ml^:=TstringList.Create;
  ml^.Add('Left='+inttostr(Form2.Left));
  ml^.Add('Top='+inttostr(Form2.top));
  ml^.SaveToFile(CurrentDir+'\Settings\My.ini');
  ml^.Free;
  Dispose(ml);
  sid.Free;
  itid.Free;
  npid.Free;
  log.Free;
  Tr.Free;
  except on E : Exception do;
    //ShowMessage('ОШИБКА OnFree:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;


exports
  GetPluginInfo,
  OnPacket,
  OnLoad,
  SetStruct,
  OnFree;
Begin
end.
