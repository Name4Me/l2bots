unit AAction;

interface
uses usharedstructs,SysUtils,Dialogs,Classes,windows,ExtCtrls,unit2,Other_Func,OtherTypes;

  function MoveToXYZ(CID,mx,my,mz:integer):boolean;
  function MoveTT(CID:integer):boolean;
  function MoveToPoint(CID:integer;Pnt:TPoint):boolean;
  function UseItem(CID,IID:integer):boolean;
  function AutoBaf(CID:integer):boolean;
  function Sweep(CID:integer):boolean;
  procedure PickUp(cid:integer);
  procedure ShowInfo(CID:integer);
  procedure MagicSU(CID,MagicID:integer);
  procedure AAtack(cid:integer);
  procedure AAssist(cid:integer);
  procedure PartyBaf(CID:integer);
  procedure SelfBaf(CID:integer);
  procedure OfBaf(CID:integer);
  procedure AutoHeal(CID:integer);
  Procedure AutoBotleUse(CID:integer);
  procedure Move2(Cid:integer);
  procedure STS(CID:integer;msg:string;F:boolean = true);
  procedure Say(CID:integer;msg:string);
  procedure DoAction(CID:integer);
  Procedure StopMoveTT(CID:integer);
  Procedure Fishing(CID:integer);
  Procedure UnHold(CID:integer);
const
  fish=1312;   //ID fishing
  pump=1313;  //ID pumping
  reel=1314; //ID reeling
Var
  ppck: PPacket;
  ps: TPluginStruct;
implementation
uses msbu,MsbForm;
Procedure UnHold(CID:integer);
Begin
  with user[CID] do Begin
    isInHold:=false;
    IsHPUse:=false;
    IsMPUse:=false;
    IsCPUse:=false;
    isInCombat:=false;
    isInHeal:=false;
    INPU:=false;
    INKT:=false;
    End;
End;

Procedure Fishing(CID:integer);
Begin
  if user[CID]<>nil then with user[CID] do Begin
     if (RoodOID<>0) and (RHID<>RoodOID) then UseItem(CID,RoodOID);
            if (CurenLureOID<>0) and (LHID<>CurenLureOID) then UseItem(CID,CurenLureOID);

  End;
End;
Procedure StopMoveTT(CID:integer);
Begin
  if user[CID]<>nil then with user[CID] do Begin
    OnAutoMTT:=False;
    isInMTP:=false;
  End;
End;
procedure DoAction(CID:integer);
var
  al:TStrings;
  id,oid:integer;
  fl:boolean;
  s,buf:string;
Begin
Try
  with user[CID] do if (MA.AList<>'') and (MA.md.Active) then begin
    fl:=false;
    oid:=0;
    al:=TstringList.Create;
    al.Text:=MA.AList; //NPCDLG(Jeremy[ID=31521])
    if pos('NPCDLG',al[MA.CA])<>0 then Begin
      id:=strtoint(copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1));
      id:=NpcList.IFIID(id);
      if id<>-1 then oid:=NpcList[id].ObjectID;
      if (oid<>0) and (CurentT.ID<>oid) then Begin
        STS(cid,'1f'+anti4HEX(oid)+'00000000000000000000000000');
        MA.md.SLTU(1000);
        End;
      if (oid<>0) and (CurentT.ID=oid) then Begin
        STS(cid,'1f'+anti4HEX(oid)+'00000000000000000000000000');
        fl:=true;
        MA.md.SLTU(1000);
        End;
      if oid=0 then MA.isComplete:=true;

      End;
    if pos('DLGSEL',al[MA.CA])<>0 then Begin
      s:=copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1);
      with ps do begin
        buf:=HexToString('23');
        WriteS(buf,s);
        SendPacketStr(buf,CID,True);
        end;
      fl:=true;
      MA.md.SLTU(1000);
      End;
    if pos('SETRK',al[MA.CA])<>0 then Begin
      s:=copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1);
      RK:=StrToIntDef(s,0);
      with Treck[CurentPN] do begin
        CurentCK.x:=x;
        CurentCK.y:=y;
        CurentCK.z:=z;
        NpcList.SetXYZ(x,y,z,True);
        end;
      fl:=true;
      End;
    if pos('UseSkillIf',al[MA.CA])<>0 then Begin
      s:=copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1);
      if SkilList.Itemi[strtoint(s)].Cust(CID) then INKT:=True;
      fl:=true;
      MA.md.SLTU(1000);
      End;
    if pos('UseSkill',al[MA.CA])<>0 then Begin
      s:=copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1);
      if SkilList.Itemi[strtoint(s)].Cust(CID) then Begin
        INKT:=True;
        fl:=true;
        MA.md.SLTU(200);
        End;
      End;
    if pos('USEITEM',al[MA.CA])<>0 then Begin //USEITEM(Greater Haste Potion[ID=1374])
      id:=strtoint(copy(al[MA.CA],pos('(',al[MA.CA])+1,pos(')',al[MA.CA])-pos('(',al[MA.CA])-1));

      if (id=1374) and (Baffs.Itemi[2034].Duration<=300) then UseItem(CID,id);

      if id<>1374 then UseItem(CID,id);
      fl:=true;
      MA.md.SLTU(200);
      End;
    if pos('RESTART',al[MA.CA])<>0 then Begin
      CurentPN:=0;
      fl:=true;
      End;
    if fl then inc(MA.CA);
    if MA.CA=MA.Count then MA.isComplete:=true;
    al.Free;
    End;

  
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ DoAction:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//---------------------------------------------------------------AutoBotleUse---
Procedure AutoBotleUse(CID:integer);
Begin
Try
  with User[CID] do begin
    if (HP>0) and (MaxCP>0) and (MaxCP-CP>100) and (not IsCPUse) and (useitem(cid,CPiID)) then IsCPUse:=True;
    if (HP>0) and (MaxHP>0) and (HP/MaxHP<0.85) and (not IsHPUse) and (useitem(cid,HPiID)) then IsHPUse:=True;
    if (HP>0) and (MaxMP>0) and (MP/MaxMP<0.8) and (not IsMPUse) and (useitem(cid,MPiID)) then IsMPUse:=True;
    end;
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ AutoBotleUse:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//------------------------------------------------------------------------------
//------------------------------------------------------------------MoveToXYZ---
function MoveToXYZ(CID,mx,my,mz:integer):boolean;
Begin
Result:=false;
Try
  with User[CID] do if ras(x,y,mx,my)>20 then begin
    isInMTP:=true;
    MovePoint.x:=mx;
    MovePoint.y:=my;
    MovePoint.z:=mz;
    STS(cid,'0f'+anti4HEX(mx)+anti4HEX(my)+anti4HEX(mz)+'00000000000000000000000001000000');
    Result:=true;
    end;
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ MoveToPoint:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//------------------------------------------------------------------------------
//----------------------------------------------------------------MoveToTreck---
function MoveTT(CID:integer):boolean;
Begin
Result:=false;
Try

  with User[CID] do begin
    OnAutoOFF:=true;
    //say(CID,'Curent point: '+inttostr(CurentPN));
    if (Treck.Count>0) and (CurentPN<=Treck.Count-1) then Begin
      if (Treck[CurentPN].alist<>'') and (ma.PN<>CurentPN) then
        ma.SetAction(CurentPN,Treck[CurentPN].alist);
      if ((Treck[CurentPN].alist='') or (ma.isComplete)) and (CurentPN<Treck.Count-1) then Begin
        inc(CurentPN);
        MoveToXYZ(CID,Treck[CurentPN].x,Treck[CurentPN].y,Treck[CurentPN].z);
        End;
      End;
  end;
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ MoveToPoint:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//------------------------------------------------------------------------------
//----------------------------------------------------------------MoveToPoint---
function MoveToPoint(CID:integer;Pnt:TPoint):boolean;
Begin
Result:=false;
Try
  with User[CID] do begin
    if (Pnt.alist<>'') then Begin
      ma.SetAction(Pnt.pn,Pnt.alist);
      DoAction(CID);
      End;
    MoveToXYZ(CID,Pnt.x,Pnt.y,Pnt.z);
  end;
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ MoveToPoint:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//------------------------------------------------------------------------------
//-----------------------------------------------------------------------Swep---
function Sweep(CID:integer):boolean;
Begin
Result:=false;
Try
  with User[CID] do if (SwepList.Count>0) and ((User[cid].ClassID=55) or (ClassID=117)) then begin
    if (CurentT.ID<>strtoint(SwepList[0])) and (not CurentT.selected) then Begin
      isInSweep:=true;
      CurentT.ID:=strtoint(SwepList[0]);
      STS(cid,'1f'+anti4HEX(CurentT.ID)+'00000000000000000000000001');
      End;
    if (CurentT.ID=strtoint(SwepList[0])) and CurentT.selected then Begin
      INKT:=True;
      SkilList.Itemi[42].Cust(Cid);
      SwepList.Delete(0);
      End;
    Result:=true;
    end;
except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ Swep:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
End;
//------------------------------------------------------------------------------
//----------------------------------------------------------------¿‚ÚÓ PickUp---
procedure PickUp(cid:integer);
begin
  Try
  with User[cid] do Begin
    INPU:=true;
    //Say(cid,'PU');
    CurentPUID:=DropList.GetMinDist(600);
    if (CurentPUID<>0) and ((ATList.Count=0) or (not OnAutoAtack)) then Begin
      //Say(cid,'PU+');
      INPU:=true;
      //Memo1.Lines.Add();
      STS(cid,'1f'+anti4HEX(CurentPUID)+'00000000000000000000000000');
      End;
    if CurentPUID=0 then INPU:=False;
    End;

  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ PickUp:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------

//-------------------------------------------------------------------ShowInfo---
procedure ShowInfo(CID:integer);
var
  buf: string;
  hmlstr:widestring;
begin
Try
  with User[cid] do Begin
    hmlstr:='';
    hmlstr:='<html><title>'+PName+' ['+inttostr(ClassID)+']['+inttostr(ObjectID)+']'+'</title><body>';
    hmlstr:=hmlstr+'<center>';
    hmlstr:=hmlstr+'<br><button action="bypass mtt" value="MTT" width=74 height=21 back="L2UI_CH3.Btn1_normalOn" fore="L2UI_CH3.Btn1_normal">';
    hmlstr:=hmlstr+'<br><button action="bypass sbs" value="SBS" width=74 height=21 back="L2UI_CH3.Btn1_normalOn" fore="L2UI_CH3.Btn1_normal">';
    hmlstr:=hmlstr+'<br><button action="bypass np" value="Next point" width=74 height=21 back="L2UI_CH3.Btn1_normalOn" fore="L2UI_CH3.Btn1_normal">';
    hmlstr:=hmlstr+'<br><button action="bypass rp" value="ADD point" width=74 height=21 back="L2UI_CH3.Btn1_normalOn" fore="L2UI_CH3.Btn1_normal">';
    hmlstr:=hmlstr+'<br><button action="bypass Agumentation" value="Ag" width=74 height=21 back="L2UI_CH3.Btn1_normalOn" fore="L2UI_CH3.Btn1_normal">';
    hmlstr:=hmlstr+'</center>';
    //hmlstr:=hmlstr+'<buttom value="MTT" action="bypass mtt" width="100" height="22"><br>';
    //hmlstr:=hmlstr+'<buttom value="Next point" action="bypass np" width="100" height="22" back="L2UI_CT1.Button_DF_Down" fore="L2UI_CT1.Button_DF"><br>';
    hmlstr:=hmlstr+'</body></html>';
  End;
  if User[cid].ObjectID<>0 then with ps do begin
    buf:=HexToString('19');
    WriteD(buf,User[cid].ObjectID);
    WriteS(buf,hmlstr);
    WriteD(buf,0);
    SendPacketStr(buf,CID,False);
  end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ ShowInfo:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------
//--------------------------------------------------------------------MagicSU---
procedure MagicSU(CID,MagicID:integer);
begin
  sts(CID,'39'+anti4HEX(MagicID)+'0000000000');
end;
//------------------------------------------------------------------------------
//--------------------------------------------------------------------UseItem---
function UseItem(CID,IID:integer):boolean;
begin
  Result:=false;
  Try
  with User[cid].IList.Itemi[IID] do begin
    if (OID<>0) and (Count<>0) then Result:=true;
    if Result then sts(CID,'19'+anti4HEX(OID)+'00000000');
    end;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ UseItem:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//-----------------------------------------------------------------¿‚ÚÓ Atack---
procedure AAtack(cid:integer);
Var i:integer;
  fl:boolean;
begin
  Try
  fl:=false;
  with  User[cid] do Begin
    if (DropList.Count=0) or (DropList[0].Dist>=600)or (not OnAutoPickUp)or (ATList.Count<>0) then Begin
      if (((CurentT.ID=0) and (not CurentT.selected)) or
        ((CurentT.HP=0) or
        ((CurentT.MaxHP=1) and (User[cid].isInMTT.Active))) and (not isInCombat)) then Begin
        if ATList.Count>0 Then i:= StrToInt(ATList[0]) else i:=NpcList.GetMinDist(rk);
        if i<>0 then Begin
          CurentT.ID:=i;
          CurentT.HP:=1;
          CurentT.MaxHP:=1;
          isInMTT.SLTU(2500);
          LastCombat.SLTU(5000);
          if i<>0 then STS(cid,'1f'+anti4HEX(i)+'00000000000000000000000001');
          End;
        End;
      if (CurentT.selected) and (not isInCombat) and(status[6]='-') and (CurentT.HP>1) and (CD.Active) then Begin
        CD.SLTU(2000);
        STS(cid,'1f'+anti4HEX(CurentT.ID)+'00000000000000000000000000');
        End;
      if (CurentT.selected)  and (MAS<>0) and (CurentT.HP>1) then Begin
        isInCombat:=true;
        if (MCS<>0) and (not CurentT.isInCurse) then Begin
          fl:=true;
          CurentT.CurseTime:=GetTickCount;
          CurentT.isInCurse:=true;
          SkilList.Itemi[MCS].Cust(Cid);
          End;
        if not fl then SkilList.Itemi[MAS].Cust(Cid);
        End;
    End;
    //--------------------------------------------------------------------------
    if ( CurentT.ID=0) and (LastCombat.Active) and (Treck.Count>0) and (ATList.Count=0) and
    ((not OnAutoPickUp)or (OnAutoPickUp and (DropList.GetMinDist(600)=0)))
     then Begin
      if Treck.MoveForward then inc(CurentPN) else dec(CurentPN);
      if (CurentPN<=Treck.Count-1) and (CurentPN>0) and (Ras(x,y,Treck[CurentPN].x,Treck[CurentPN].y)<9000)  then MoveToPoint(CID,Treck[CurentPN]);
      if ((Treck.MoveForward) and (CurentPN>=Treck.Count-1))or((not Treck.MoveForward) and (CurentPN<=0)) then Treck.MoveForward:= not Treck.MoveForward;
      End;

    //--------------------------------------------------------------------------

  End;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ AAtack:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------------¿‚ÚÓ AAssist---
procedure AAssist(cid:integer);
var
fl:boolean;
begin
  Try
  fl:=false;
  with  User[cid] do Begin
    if (CurentT.ID<>Lider.DTT) and (Lider.DTT<>0) then Begin
      CurentT.ID:=Lider.DTT;
      STS(cid,'1f'+anti4HEX(CurentT.ID)+'00000000000000000000000001');
      isInCombat:=False;
      End;
    if (CurentT.ID=Lider.DTT) and (Lider.DTT<>0) and (not isInCombat) and(status[6]='-') then Begin
      //isInCombat:=true;
      STS(cid,'1f'+anti4HEX(CurentT.ID)+'00000000000000000000000000');
      End;
    if (CurentT.ID=Lider.DTT) and (Lider.DTT<>0) and (MAS<>0) then Begin
      if (MCS<>0) and (not CurentT.isInCurse) then Begin
        isInCombat:=true;
        fl:=true;
        CurentT.CurseTime:=GetTickCount;
        CurentT.isInCurse:=true;
        SkilList.Itemi[MCS].Cust(Cid);
        End;
      if not fl then SkilList.Itemi[MAS].Cust(Cid);
      End;
    End;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ AAssist:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//-------------------------------------------------------------------PartyBuf---
procedure PartyBaf(CID:integer);
var i,p,bi:integer;
fl,pfl:boolean;
ms,bt:boolean;
begin
  Try
  fl:=false;
  pfl:=false;
  ms:=false;
  p:=0;
  bi:=0;
  with User[cid] do Begin
    while (p<=PartyList.Count-1) and (not pfl) do Begin
      case PartyList[p].ClassID of
        10..17,25..30,38..43,49..52,94..98,103..105,110..112,115,116:bt:=true;
        else bt:=false;
        end;
      if bt and (MBList.Count<>0) then begin//--------------------Mistick baf---
        i:=0;
        while (i<=MBList.Count-1) and (not fl) and (PartyList[p].HP>0) and (PartyList[p].dist<700) do Begin
          if not PartyList[p].Baffs.Active[StrToInt(MBList.Names[i])] then fl:=true;
          if not fl then inc(i);
          End;
        if fl then bi:=strtoint(MBList.Names[i]);
        if fl then pfl:=true;
        End;

      if not bt and (FBList.Count<>0) then begin//----------------Fighter baf---
        i:=0;
        while (i<=FBList.Count-1) and (not fl) and (PartyList[p].HP>0) and (PartyList[p].dist<700) do Begin
          if not PartyList[p].Baffs.Active[StrToInt(FBList.Names[i])] then fl:=true;
          if not fl then inc(i);
          End;
        if fl then bi:=strtoint(FBList.Names[i]);
        if fl then pfl:=true;
        End;
      if not pfl then inc(p);
      End;

      //if (pfl) and (User[cid].PartyList[p].dist>700) then pfl:=false;

    if (pfl) and (((CurentT.ID=PartyList[p].ObjectID) and (CurentT .selected)) or (ms)) and (not INKT) then Begin
      if SkilList.Itemi[bi].Cust(cid) then INKT:=True;;
      End;
    if (pfl) and (CurentT.ID<>PartyList[p].ObjectID) and (not ms) then Begin
      CurentT.selected:=false;
      CurentT.ID:=PartyList[p].ObjectID;
      STS(cid,'1f'+anti4HEX(CurentT.ID)+'00000000000000000000000001');
      End;
      if INKT then Begin
        isInCombat:=false;
        INPU:=False;
        End
    End;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ PartyBaf:'+Inttostr(CID)+'-'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------

//--------------------------------------------------------------------SelfBaf---
procedure SelfBaf(CID:integer);
var i,bi:integer;
fl,ms,bt:boolean;
begin
  Try

  fl:=false;
  ms:=false;
  bi:=0;
  with User[cid] do begin
    case ClassID of
      10..17,25..30,38..43,49..52,94..98,103..105,110..112,115,116:bt:=true;
      else bt:=false;
      end;
    if bt and (MBList.Count<>0) then begin
      i:=0;
      while (i<=MBList.Count-1) and (not fl) do Begin
        if not Baffs.Active[StrToInt(MBList.Names[i])] then fl:=true;
        if not fl then inc(i);
        End;
      if fl then bi:=strtoint(MBList.Names[i]);
      End;
    if not bt and (FBList.Count<>0) then begin
      i:=0;
      while (i<=FBList.Count-1) and (not fl) do Begin
        if not Baffs.Active[StrToInt(FBList.Names[i])] then fl:=true;
        if not fl then inc(i);
        End;
      if fl then bi:=strtoint(FBList.Names[i]);
      End;
    case ClassID of
      95:ms:=true;
      end;
    if (bi<>0) and (CurentT.ID<>ObjectID) and (not ms) then Begin
    //User[cid].INKT:=True;
      CurentT.selected:=false;
      CurentT.ID:=ObjectID;
      STS(cid,'1f'+anti4HEX(ObjectID)+'00000000000000000000000001');
      End;
    if (bi<>0) and (((CurentT.ID=ObjectID) and CurentT.selected) or ms) and
      not INKT and SkilList.Itemi[bi].Cust(CID) then INKT:=True;

    if bi=0 then isInSBaf:=false else isInSBaf:=true;
    if INKT then Begin
        isInCombat:=false;
        INPU:=False;
        End
  end;


  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ SelfBaf:'+Inttostr(CID)+'-'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//-----------------------------------------------------------------OfPartyBaf---
procedure OfBaf(CID:integer);
var i,bi:integer;
fl,ms,bt:boolean;
begin
  Try

  fl:=false;
  ms:=false;
  bi:=0;
  with User[Form2.CIDRGroup.ItemIndex] do if ObjectID=User[Cid].Lider.ID then begin
    case ClassID of
      10..17,25..30,38..43,49..52,94..98,103..105,110..112,115,116:bt:=true;
      else bt:=false;
      end;
    if bt and (User[Cid].MBList.Count<>0) then begin
      i:=0;
      while (i<=User[Cid].MBList.Count-1) and (not fl) do Begin
        if (not Baffs.Active[StrToInt(User[Cid].MBList.Names[i])]) and (User[Cid].MBList.Names[i]<>'1062') then fl:=true;
        if not fl then inc(i);
        End;
      if fl then bi:=strtoint(User[Cid].MBList.Names[i]);
      End;
    if not bt and (User[Cid].FBList.Count<>0) then begin
      i:=0;
      while (i<=User[Cid].FBList.Count-1) and (not fl) do Begin
        if (not Baffs.Active[StrToInt(User[Cid].FBList.Names[i])]) and (User[Cid].FBList.Names[i]<>'1062') then fl:=true;
        if not fl then inc(i);
        End;
      if fl then bi:=strtoint(User[Cid].FBList.Names[i]);
      End;
    case ClassID of
      95:ms:=true;
      end;
    if (bi<>0) and (User[Cid].CurentT.ID<>ObjectID) and (not ms) then Begin
    //User[cid].INKT:=True;
      User[Cid].CurentT.selected:=false;
      User[Cid].CurentT.ID:=ObjectID;
      STS(cid,'1f'+anti4HEX(ObjectID)+'00000000000000000000000001');
      End;
    if (bi<>0) and (((User[Cid].CurentT.ID=ObjectID) and User[Cid].CurentT.selected) or ms) and
      not User[Cid].INKT and User[Cid].SkilList.Itemi[bi].Cust(CID) then User[Cid].INKT:=True;
      if INKT then Begin
        isInCombat:=false;
        INPU:=False;
        End
  end;


  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ SelfBaf:'+Inttostr(CID)+'-'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//--------------------------------------------------------------------AutoBaf---
function AutoBaf(CID:integer):boolean;
var i,bi:integer;
fl:boolean;
begin
  Result:=false;
  Try
  fl:=false;
  bi:=0;
  with User[cid] do Begin
    if ABList.Count<>0 then begin
      i:=0;
      while (i<=ABList.Count-1) and (not fl) do Begin
        if not Baffs.Active[StrToInt(ABList.Names[i])] then fl:=true;
        if not fl then inc(i);
        End;
      if fl then bi:=strtoint(ABList.Names[i]);
      End;
    if (bi<>0)  and (not INKT) then Begin
      if SkilList.Itemi[bi].Cust(CID) then INKT:=True;
      if INKT then Begin
        isInCombat:=false;
        INPU:=False;
        End;
      Result:=True
      End;
    End;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ AutoBaf:'+Inttostr(CID)+'-'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------

//--------------------------------------------------------------------AutoHeal---
procedure AutoHeal(CID:integer);
var i,n:integer;
begin
  Try
  with User[cid] do begin
    n:=0;
    i:=0;
    if (MHS<>0) then Begin
      if (MaxHP>0) and(HP/MaxHP<0.75) then n:=ObjectID;
      while (i<=PartyList.Count-1) and (n>=0) do with PartyList[i] do Begin
        if (ObjectID<>0) and (HP<>0) and (dist<630) and (MaxHP>0) and (HP/MaxHP<0.75) and (n>0)
          and (User[cid].MMH<>0)  and (SkilList[SkilList.IFIID(MMH)].isActive) then n:=-1;
        if (ObjectID<>0) and (HP<>0) and (dist<630) and (MaxHP>0) and (HP/MaxHP<0.75) and (n=0) then n:=ObjectID;
        inc(i);
        End;
      with User[Form2.CIDRGroup.ItemIndex] do
      if (n=0) and (ObjectID=User[Cid].Lider.ID) and (MaxHP>0) and (HP/MaxHP<0.75) then n:=ObjectID;
      if (n>0) and (CurentT.ID<>n) then Begin
        CurentT.selected:=false;
        CurentT.ID:=n;
        isInHeal:=True;
        STS(cid,'1f'+anti4HEX(n)+'00000000000000000000000001');
        End;
      if (n>0) and (CurentT.ID=n) and (CurentT.selected) and (not INKT) then
        if SkilList[SkilList.IFIID(MHS)].Cust(cid) then INKT:=True;
      End;
    if (n<0) and (MMH<>0) and (not INKT) then
      if SkilList[SkilList.IFIID(MMH)].Cust(cid) then INKT:=True;
    if n=0 then isInHeal:=False else Begin
      isInHeal:=True;
      INPU:=False;
      End;

    end;
  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ AutoHeal:'+Inttostr(CID)+'-'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure Move2(Cid:integer);// -------------------------—ÎÂ‰Ó‚‡ÌËÂ Á‡ ÎË‰ÂÓÏ---
var d:integer;
begin
  Try
  Randomize;
  with User[Cid] do if (Lider.ID<>0) and (OnMoveToLiader) Then  begin
    d:=ras(x,y,Lider.x,Lider.y);
    if (d>200) and (d<3900) then begin
      if random(10) mod 2 =0 then MoveToXYZ(Cid,Lider.x+30+random(50),Lider.y+30+random(50),Lider.z)
        else MoveToXYZ(Cid,Lider.x-30+random(50),Lider.y-30+random(50),Lider.z);
      INKT:=false;
      INPU:=false;
      isInHeal:=false;
      isInCombat:=false;
      Lider.isInCombat:=false;
      End;
    end;

  except on E : Exception do
  ShowMessage('Œÿ»¡ ¿ Move2:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------STS---
procedure STS(CID:integer;msg:string;F:boolean = true);
begin
  if (CID<>-1) and (msg<>'') then with ps do SendPacketStr(HexToString(msg),CID,f);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------Say---
procedure Say(CID:integer;msg:string);
var
  buf: string;
begin
  with ps do begin
    buf:=HexToString('4A00000000');
    WriteD(buf,2);
    WriteS(buf,'Auto');
    WriteS(buf,msg);
    SendPacketStr(buf,CID,False);
    end;
end;
//------------------------------------------------------------------------------
end.

