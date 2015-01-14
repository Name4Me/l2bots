unit Unit2;

interface

uses SysUtils,Dialogs,Classes,Windows,Variants;
  procedure UserInfo(cid,sx,sy,sz,OID,ClID,iSP:integer;Nm:string);
  procedure CharInfo(cid,x,y,z,OID,ClasID,ClanID:integer;Nm:string);
  procedure NpcInfo(CID,OID,NID,isa,inc,isld,X,Y,Z:integer);
  procedure ValidatePosition(CID,mx,my,mz:integer);
  procedure MTL(CID,OID,sx,sy,sz:integer;TAR:integer=0;f:boolean = false);
  procedure AA(CID:integer);
  procedure MyT(CID,TID:integer);
  procedure TargetSelected(CID,OID,TID:integer);
  procedure UnTarget(CID,OID:integer);
  procedure ByPass(CID:integer;command:string);
  procedure PartySWUpdate(CID,OID,CP,MCP,HP,MHP,MP,MMP,Lvl,CLID:integer;nm:string);
  procedure PartyMemberPosition(CID,OID,x,y,z:integer);
  procedure PartySpelled(CID,OID,skid,dur:integer);
  procedure ASUpdate(cid,skid,Duration:integer);
  procedure MagicSkillUse(cid,OID,TID,inSkid,delay:integer);
  procedure StatsUpdate(cid,OID,id,Value:integer);
  procedure Attack(CID,ATK,TAR,x,y:integer);
  procedure DropItem(CID,PlayerID,OID,InvID,x,y,z,c:integer);
  procedure IL(CID,OID,IID,C,AB,n:integer);
  procedure InventoryUpdate(CID,CH,OID,IID,C,AB:integer);
  procedure DelObj(CID,OID:integer);
  procedure Die(CID,OID,sw:integer);
  procedure Unkast(CID,OID:integer);
  procedure RR(CID:integer);
  procedure ActionFailed(CID:integer);
implementation
uses AAction,msbu,msbform,Other_Func,Agumentation;
procedure ActionFailed(CID:integer);
Begin
  With User[CID] do
  if INPU and (CurentPUID<>0) then Say(Cid,IntToStr(DropList.ItemO[CurentPUID].Dist));

End;

//---------------------------------------------------------------»ÌÙ‡ Ó ˜‡‡ı---
procedure UserInfo(cid,sx,sy,sz,OID,ClID,iSP:integer;Nm:string);
begin
Try
  //if  User[CID]=nil then User[CID]:=TUser.create(Nm);
  with User[CID] do Begin
    if (ClassID<>ClID) or (PName<>Nm) then begin
      Save;
      Form2.DN(CID);
      say(ClID,'ClassID '+inttostr(ClID));
      ClassID:=ClID;
      init(Nm);
      Form2.Ncr(CID);
      end;

    ObjectID:=OID;
    x:=sx;
    y:=sy;
    z:=sz;
    SP:=iSP;
    PName:=nm;
    NpcList.SetXYZ(x,y,z);
    End;


  //ShowInfo(cid);

  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ UserInfo:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------------»ÌÙ‡ Ó ˜‡‡ı---
procedure CharInfo(cid,x,y,z,OID,ClasID,ClanID:integer;Nm:string);
begin
Try
  user[CID].CharList.AddChar(x,y,z,OID,ClasID,ClanID,Nm);
  //if (ClasID=116) or(ClasID=97) or (ClasID=16)then Say(cid,'!!!');///ShowCharInfo(cid);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ CharInfo:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------

//----------------------------------------------------Œ·‡·ÓÚÍ‡ ÔÓˇ‚ÎÂÌËˇ Npc---
procedure NpcInfo(CID,OID,NID,isa,inc,isld,X,Y,Z:integer);
var ni:integer;
begin
  Try
  ni:=nid-1000000;

  if (ni=29001) and (isld=0) then log.Add(FormatDateTime('yyyy.mm.dd hh:nn',Now)+' Ant Queen Alive');
  if (ni=29001) and (isld=1) then log.Add(FormatDateTime('yyyy.mm.dd hh:nn',Now)+' Ant Queen Die');
  if (ni=29001) then log.SaveToFile('Ak.log');
  if isld=0 then
    if npid.Values[inttostr(ni)]<>'' then User[cid].NpcList.ADDNpc(OID,ni,isa,X,Y,Z,npid.Values[inttostr(ni)])
      else User[cid].NpcList.ADDNpc(OID,ni,isa,X,Y,Z,'NoName')
    else
      if OID=User[CID].CurentT.ID Then Begin if not User[CID].DieD.Active then with User[CID] do Begin
        NpcList.DelNpc(OID);
        if ATList.IndexOf(inttostr(OID))<>-1 then
          ATList.Delete(ATList.IndexOf(inttostr(OID)));
        isInCombat:=false;
        //INPU:=false;
        CurentT.isInCurse:=False;
        CurentT.spoiled:=False;
        Pet.isInCombat:=false;
        if Lider.DTT=OID then Begin
          Lider.DTT:=0;
          Lider.isInCombat:=False;
          End;
        AA(CID);
      End
      Else User[CID].DieD.SLTU(1000);
      End;

  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ NpcInfo:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//-----------------------------------------------------------ValidatePosition---
procedure ValidatePosition(CID,mx,my,mz:integer);
begin
  Try

  with User[CID] do begin
    if isInMTT.Active then isInMTT.SLTU(2500);
    x:=mx;
    y:=my;
    z:=mz;  //say(CID,'CID'+inttostr(CID)+'/'+inttostr(User[CID].CID));
    NpcList.SetXYZ(mx,my,mz);
    DropList.SetXYZ(mx,my,mz);
    if isInMTP and (ras(mx,my,MovePoint.x,MovePoint.y)<180) and not OnSBS then Begin
      isInMTP:=false;
      //MoveTT(CID);
      End;
    if (RecordTreck) and (Treck.Count=0) then Treck.AddPoint(x,y,z);
    if (RecordTreck) and (Treck.Count>0) and (ras(x,y,Treck[Treck.Count-1].x,Treck[Treck.Count-1].y)>100) then Begin
      Treck.AddPoint(x,y,z);
      say(cid,'P['+inttostr(Treck.Count-1)+']');
      End;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MoveToLocation:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------Œ·‡·ÓÚÍ‡ ‰‚ËÊÂÌËˇ---
procedure MTL(CID,OID,sx,sy,sz:integer;TAR:integer=0;f:boolean=false);
begin
  Try
  with User[CID] do begin
    if (OID=Lider.ID) then Begin
      Lider.x:=sx;
      Lider.y:=sy;
      Lider.z:=sz;
      //if (not f) or (f and (not isInCombat and not lider.isInCombat)) then
      move2(CID);
      End;
    if (OID=CurentT.ID) then Begin
      CurentT.x:=sx;
      CurentT.y:=sy;
      CurentT.z:=sz;
      //if (not f) or (f and (not isInCombat and not lider.isInCombat)) then
      End;
    NpcList.MTL(OID,sx,sy,sz);
    PartyList.MTL(OID,sx,sy,sz,x,y);
    if ObjectID=OID then DropList.SetXYZ(sx,sy,sz);
    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MoveToLocation:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//-------------------------------------------------------------------------AA---
procedure AA(CID:integer);
begin
  Try
  with user[CID] do if hp>0 then begin
    IsInAA:=True;
    Form2.StUpdate(CID);
    AutoBotleUse(CID);
    if GetTickCount-CurentT.CurseTime>15000 then CurentT.isInCurse:=false;
    if (mhs<>0) and (not INKT) then AutoHeal(CID);
    if (ClassID=55) and(SwepList.Count<>0) and (not INPU) and (not INKT) then Sweep(CID);
    if (OnSelfBaf) and (not INPU) and (not INKT) and (not isInHeal) then SelfBaf(CID);
    if (OnPartyBaf) and (not INPU) and (not INKT) and (not isInHeal) and (not isInSBaf) then PartyBaf(CID);
    if (OnAutoBaf) and (not INKT) then AutoBaf(CID);
    if (OnOfBaf) and (not INKT) then OfBaf(CID);
    if (OnAutoPickUp) and (not isInSweep) and (isInMTT.Active) and (not INKT)and (not INPU) and ((ATList.Count=0)or (not OnAutoAtack)) then PickUp(CID);
    if (OnAutoAtack) and (not isInSweep) and (not isInMTP) and (not INKT) and (not INPU) then AAtack(CID);
    if (OnAutoAssist) and (not isInSweep) and (not isInMTP) and (not INKT)and (not INPU) and (Lider.isInCombat) then AAssist(CID);
    if (OnAutoMTT) and (not isInMTP) then MoveTT(CID);
    //if (i=0) and (User[cid].CurentCK.x<>0) then STS(cid,'0f'+anti4HEX(User[cid].CurentCK.x)+anti4HEX(User[cid].CurentCK.y)+anti4HEX(User[cid].CurentCK.z)+'00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00');
    
    //isInHeal:=false;
    //isInSBaf:=false;
    if (not MA.Count>0) and (not MA.isComplete) and (not INKT) then DoAction(CID);

    IsInAA:=False;
    Form2.StUpdate(CID);
    end;


  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ AA:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//----------------------------------------------------------œÓÎÛ˜ÂÌËÂ Ú‡„ÂÚ‡---
procedure MyT(CID,TID:integer);
begin
Try
  User[CID].CurentT.id:=TID;
  User[CID].CurentT.selected:=true;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MyT:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------
//-------------------------------------------------------------TargetSelected---
procedure TargetSelected(CID,OID,TID:integer);
begin
Try

  if (User[CID].Online) and (OID=User[CID].Lider.ID) then Begin
    User[CID].Lider.DTT:=TID;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ TargetSelected:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------


//-------------------------------------------------------------œÓÚÂˇ Ú‡„ÂÚ‡---
procedure UnTarget(CID,OID:integer);
begin
Try
  with User[CID] do begin
    if OID=ObjectID then Begin
      CurentT.id:=0;
      CurentT.DTT:=0;
      CurentT.MaxHP:=0;
      CurentT.HP:=0;
      CurentT.x:=0;
      CurentT.y:=0;
      CurentT.selected:=false;
      CurentT.isInCurse:=false;
      CurentT.spoiled:=false;

      isInCombat:=false;
      //INPU:=false;
      //say(CID,'UnTarget');
      End;

    if OID=Lider.ID then Begin
      Lider.isInCombat:=false;
      Lider.DTT:=0;
      //say(CID,'UnTarget');
      End;
  end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ UnTarget:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------

procedure ByPass(CID:integer;command:string);
var i:integer;
Begin
  With User[CID] Do begin
    if command='sbs' then OnSBS:=True;
    if command='np' then isInMTP:=false;
    if command='p4' then CurentPN:=4;
    if command='ag' then Augment(CID);
    if command='rp' then Treck.AddPoint(x,y,z);
    if command='mtt' then Begin
      OnAutoMTT:=true;
      say(CID,'OnAutoMTT On');
      End;
  end;
  //ShowInfo(CID);
End;
//------------------------------------------------------------------------------
//-----------------------------------------------------PartySmallWindowUpdate---
procedure PartySWUpdate(CID,OID,CP,MCP,HP,MHP,MP,MMP,Lvl,CLID:integer;nm:string);
var i:integer;
Begin
try
  with user[CID].PartyList do begin
    i:=IFOID(OID);
    if i=-1 then Begin
      AddChar(0,0,0,OID,0,0,'');
      i:=IFOID(OID);
      End;
    items[i].CP:=CP;
    items[i].MaxCP:=MCP;
    items[i].HP:=HP;
    items[i].MaxHP:=MHP;
    items[i].MP:=MP;
    items[i].MaxMP:=MMP;
    items[i].Lvl:=Lvl;
    items[i].ClassID:=CLID;
    items[i].Name:=nm;
    items[i].Ch:=false;
    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ PartySWUpdate:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------
//--------------------------------------------------------PartyMemberPosition---
procedure PartyMemberPosition(CID,OID,x,y,z:integer);
var i:integer;
Begin
Try
  with user[CID].PartyList do begin
    i:=IFOID(OID);
    if i=-1 then Begin
      AddChar(0,0,0,OID,0,0,'');
      i:=IFOID(OID);
      End;
    items[i].x:=x;
    items[i].y:=y;
    items[i].z:=z;
    items[i].dist:=ras(x,y,user[CID].x,user[CID].y);
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ PartyMemberPosition:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------
//---------------------------------------------------------------PartySpelled---
procedure PartySpelled(CID,OID,skid,dur:integer);
var i:integer;
Begin
Try
  with user[CID].PartyList do begin
    i:=IFOID(OID);
    if i=-1 then Begin
      AddChar(0,0,0,OID,0,0,'');
      i:=IFOID(OID);
      End;
    items[i].Baffs.SLTU(skid,dur);
    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ PartySpelled:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------
//-------------------------------------------------------AbnormalStatusUpdate---
procedure ASUpdate(cid,skid,Duration:integer);
Begin
Try
  User[cid].Baffs.SLTU(skid,Duration);
  if (pos(inttostr(skid),'4072,4073')<>0) and (Duration>0) then User[cid].isInHold:=True;
  if (pos(inttostr(skid),'4072,4073')<>0) and (Duration=0) then Begin
    UnHold(CID);
    User[cid].isInHold:=False;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ ASUpdate:'+User[cid].PName+'//'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;
//------------------------------------------------------------------------------

//--------------------------------------------------------------MagicSkillUse---
procedure MagicSkillUse(cid,OID,TID,inSkid,delay:integer);
Begin
Try
  with User[cid] do Begin
    //say(cid,inttostr(skid)+'>'+inttostr(delay));
    if (OID=ObjectID) and (SkilList.IFIID(inSkid)<>-1) then begin
      SkilList.Itemi[inSkid].SetDelay(delay,GetTickCount);
      //say(cid,sid.Values[inttostr(skid)]+' '+inttostr(delay));
      end;
    if (inSkid<>42) and(OID=Lider.ID) and (TID<>Lider.ID) and (TID<>ObjectID) and (PartyList.IFOID(TID)=-1) then Begin
      Lider.isInCombat:=true;
      Lider.DTT:=TID;
      End;
    if (OID=ObjectID) and (TID<>ObjectID) and (inSkid=MAS) then isInCombat:=true;

    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ MagicSkillUse:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
End;

//------------------------------------------------------------------------------



//----------------------------------------------------------------StatsUpdate---
procedure StatsUpdate(cid,OID,id,Value:integer);
begin
  Try
  with User[cid] do Begin
    if OID=ObjectID then case id of
      9: HP:=Value;
      10: MaxHP:=Value;
      33: CP:=Value;
      34: MaxCP:=Value;
      11: MP:=Value;
      12: MaxMP:=Value;
      end;
    if OID=CurentT.ID then case id of
      9: CurentT.HP:=Value;
      10: CurentT.MaxHP:=Value;
      end;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ StatsUpdate:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------


//----------------------------------------------------Ó·‡·ÓÚÍ‡ Ô‡ÍÂÚ‡ ‡Ú‡ÍË!---
procedure Attack(CID,ATK,TAR,x,y:integer);
begin
  Try
  with user[CID] do begin
    if (ATK=ObjectID) then Begin
      CurentT.ID:=TAR;
      //INAA:=true;
      isInCombat:=true;
      if (not CurentT.spoiled) and (ClassID=55) and (CharList.IFOID(TAR)=-1) then sts(cid,'39FE0000000000000000');
      if (not CurentT.spoiled) and (ClassID=117) and (CharList.IFOID(TAR)=-1) then sts(cid,'395C0100000000000000');
      if (Pet.ID<>0) and (not Pet.isInCombat) then Begin
        Pet.isInCombat:=true;
        //sts(cid,'56100000000000000000');
        if Pet.stype=1 then  sts(cid,'56160000000000000000');
        End;
      End;
    if (ATK=user[CID].Lider.ID) then Begin
      Lider.isInCombat:=true;
      Lider.DTT:=TAR;
      End;
    if (ATList.IndexOf(inttostr(ATK))=-1) and (NpcList.IFOID(ATK)<>-1) and
      ((TAR=ObjectID) or (PartyList.IFOID(TAR)<>-1)) then
      ATList.Add(inttostr(ATK));

    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ Attack:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------

//-------------------------------------------------------------------DropItem---
procedure DropItem(CID,PlayerID,OID,InvID,x,y,z,c:integer);
begin
  Try
    //if (PlayerID=0) or(PlayerID=user[CID].CurentT.ID) then
    user[CID].DropList.AddItem(OID,InvID,C,0,x,y,z,0)
      //Else user[CID].DropList.AddItem(OID,InvID,C,0,x,y,z,GetTickCount);
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ DropItem:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------

//-------------------------------------------------------------------ItemList---
procedure IL(CID,OID,IID,C,AB,n:integer);
begin
Try
  user[CID].IList.AddItem(OID,IID,C,AB);
  

except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ IL:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------InventoryUpdate---
procedure InventoryUpdate(CID,CH,OID,IID,C,AB:integer);
var i:integer;
begin
Try
  with user[CID] do with IList do begin
    i:=IFOID(OID);
    if i<>-1 Then case ch of
      3: Delete(i);
      2: IList[i].Count:=C;
      End;
    if ch=1 Then IList.AddItem(OID,IID,C,AB);
    if (IID=3949) and (c<=20) and (c>0) and (IFIID(5264)<>-1) then useitem(cid,5264);//Blessed Spiritshot: C Grade
    if (IID=3950) and (c<=20) and (c>0) and (IFIID(5265)<>-1) then useitem(cid,5265);//Blessed Spiritshot: B Grade
    if (IID=3951) and (c<=20) and (c>0) and (IFIID(5266)<>-1) then useitem(cid,5266);//Blessed Spiritshot: A Grade
    if (IID=3952) and (c<=20) and (c>0) and (IFIID(5267)<>-1) then useitem(cid,5267);//Blessed Spiritshot: S Grade
    if (IID=1464) and (c<=20) and (c>0) and (IFIID(5255)<>-1) then useitem(cid,5255);//Soulshot: C-grade
    if (IID=1465) and (c<=20) and (c>0) and (IFIID(5253)<>-1) then useitem(cid,5253);//Soulshot: B-grade
    if (IID=1466) and (c<=20) and (c>0) and (IFIID(5254)<>-1) then useitem(cid,5254);//Soulshot: A-grade
    if (IID=1467) and (c<=20) and (c>0) and (IFIID(5255)<>-1) then useitem(cid,5255);//Soulshot: S-grade
    if (IID=7501) and (c>=699) then STS(CID,'44');
    if ((CH=2) or (CH=1)) and (ADL.IndexOf(IntToStr(IID))<>-1) then STS(CID,'60'+anti4HEX(oid)+anti4HEX(c));

    end;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ InventoryUpdate:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------Die---
procedure Die(CID,OID,sw:integer);
begin
Try
  with User[cid] do Begin
    //DinoIsRaedy:=false;
    NpcList.DelNpc(OID);
    if (sw=1) and ((ClassID=55) or (ClassID=117))then Begin
      if ((CurentT.ID<>OID) or INKT or isInHold) and (ATList.IndexOf(inttostr(OID))<>-1) then SwepList.Add(inttostr(OID));
      if (CurentT.ID=OID) and not INKT then Begin
        INKT:=True;
        SkilList.Itemi[42].Cust(Cid);
        End;
      End;
    if ATList.IndexOf(inttostr(OID))<>-1 then
      ATList.Delete(ATList.IndexOf(inttostr(OID)));
    if (OID=ObjectID) and (OnAutoOFF) then Begin
      sts(CID,'7D00000000');
      sts(CID,'84',false);//LeaveWorld
      End;
  End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ DelObj:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------------------DelObj---
procedure DelObj(CID,OID:integer);
begin
Try
  with User[CID] do Begin

    CharList.DelChar(OID);
    NpcList.DelNpc(OID);
    DropList.DelObj(OID);
    if ATList.IndexOf(inttostr(OID))<>-1 then
      ATList.Delete(ATList.IndexOf(inttostr(OID)));
    if SwepList.IndexOf(inttostr(OID))<>-1 then
      SwepList.Delete(SwepList.IndexOf(inttostr(OID)));
    if CurentT.ID=OID then Begin
      CurentT.ID:=0;
      CurentT.selected:=False;
      CurentT.spoiled:=False;
      CurentT.isInCurse:=False;
      Pet.isInCombat:=false;
      isInCombat:=false;
      End;

    if CurentPUID=OID then Begin
      CurentPUID:=0;
      INPU:=false;
      PickUp(cid);
      //AA(CID);
      End;
    End;
  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ DelObj:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------------------Unkast---
procedure Unkast(CID,OID:integer);
begin
  Try
    if User[CID].ObjectID=OID then Begin
      User[CID].INKT:=False;
      if not User[CID].OnAutoMTT then User[CID].isInMTP:=False;
    End;

  except on E : Exception do
    ShowMessage('Œÿ»¡ ¿ Unkast:'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------
procedure RR(CID:integer);
Begin
  Try
  User[CID].Save;
  Form2.DN(CID);
  except on E:Exception do
    ShowMessage('RR'+E.ClassName+' Ó¯Ë·Í‡: '+E.Message);
  end;
end;
end.
