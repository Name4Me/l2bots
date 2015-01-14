unit Unit2;

interface

uses SysUtils,Dialogs,Classes,Windows,Variants;
  procedure UserInfo(cid,x,y,z,OID,ClassID,lvl:integer;Nm:string);
  procedure MTL(CID,OID,x,y,z:integer;f:boolean=false);
  procedure MyT(CID,TID:integer);
  procedure IL(CID,OID,IID,C,n:integer);
  procedure InventoryUpdate(CID,CH,OID,IID,C:integer);

  Var cr:char;
  Curtis:integer;
  MelvilLe:integer;
  Thoma:integer;
  Badenco:integer;
implementation
uses AAction,msbu,msbform,Other_Func;

//---------------------------------------------------------------Инфа о чарах---
procedure UserInfo(cid,x,y,z,OID,ClassID,lvl:integer;Nm:string);
Var mx,my,mz,mind,crd:integer;
begin
Try
  User[cid].ObjectID:=OID;
  User[cid].x:=x;
  User[cid].y:=y;
  User[cid].z:=z;
  User[cid].Name:=nm;
  User[cid].Lvl:=lvl;

  if (not user[cid].INMTT)and (User[cid].DP>0) then Begin
   User[cid].DP:=0;
    if (User[cid].Lvl>=40) and (User[cid].Lvl<52) and (User[cid].IList.CountFromID(8596)>0) then
      sts(cid,'19'+anti4HEX(User[cid].IList.OIDFromID(8596))+'00000000');
    if (User[cid].Lvl>=52) and (User[cid].Lvl<61) and (User[cid].IList.CountFromID(8597)>0) then
      sts(cid,'19'+anti4HEX(User[cid].IList.OIDFromID(8597))+'00000000');
    if (User[cid].Lvl>=61) and (User[cid].Lvl<72) and (User[cid].IList.CountFromID(8598)>0) then
      sts(cid,'19'+anti4HEX(User[cid].IList.OIDFromID(8598))+'00000000');
    End;
  if (not user[cid].INMTT) and (User[cid].DP=0) and (User[cid].Lvl>Form2.SpinEdit1.Value) then Begin
    user[cid].INMTT:=true;
    cr:='A';
    mind:=Ras(x,y,-14301,124710);
    mx:=-14301; my:=124710; mz:=-3120;
    crd:=Ras(x,y,-13309,123694);
    if mind>crd then Begin
      mind:=crd;
      cr:='B';
      mx:=-13309;
      my:=123694;
      mz:=-3112;
    End;
    crd:=Ras(x,y,-14704,122032);
    if mind>crd then Begin
      mind:=crd;
      cr:='C';
      mx:=-14704;
      my:=122032;
      mz:=-3048;
    End;
    crd:=Ras(x,y,-15635,124007);
    if mind>crd then Begin
      mind:=crd;
      cr:='D';
      mx:=-15635;
      my:=124007;
      mz:=-3112;
    End;
     if mind=0 then Begin
       MTL(CID,OID,x,y,z,true);
     End;
      if mind>=50 then STS(cid,'0f'+anti4HEX(mx)+anti4HEX(my)+anti4HEX(mz)+'00000000000000000000000001000000');
    End;
  except on E : Exception do
    ShowMessage('ОШИБКА UserInfo:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------
//---------------------------------------------------------Обработка движения---
procedure MTL(CID,OID,x,y,z:integer;f:boolean=false);
Var mx,my,mz:integer;
begin
  Try
  mx:=0;my:=0;mz:=0;
  IF OID=User[CID].ObjectID then Begin
    User[cid].x:=x;
    User[cid].y:=y;
    User[cid].z:=z;
    if (user[cid].INMTT) and f and not user[cid].INRP then Begin
    case CR of
    'A': if Ras(x,y,-14301,124710)<10 then Begin
      mx:=-14118;
      my:=126563;
      mz:=-3144;
      End;
    'B': if Ras(x,y,-13309,123694)<10 then Begin
      mx:=-11966;
      my:=123610;
      mz:=-3088;
      End;
    'C': if Ras(x,y,-14704,122032)<10 then Begin
      mx:=-14571;
      my:=121013;
      mz:=-2984;
      End;
    'D': if Ras(x,y,-15635,124007)<10 then Begin
      mx:=-16599;
      my:=124172;
      mz:=-3112;
      End;
    end;
    if mx<>0 then Begin
      user[cid].INRP:=True;
      STS(cid,'0f'+anti4HEX(mx)+anti4HEX(my)+anti4HEX(mz)+anti4HEX(user[cid].x)+anti4HEX(user[cid].y)+anti4HEX(user[cid].z)+'01000000');
      End;
    
  End;
  if (user[cid].INMTT) and (not user[cid].INDP) and (user[cid].INRP) then Begin
      case CR of
        'A': if Ras(x,y,-14118,126563)<10 then Begin
           if Curtis<>0 Then STS(cid,'1F'+anti4HEX(Curtis)+'00 00 00 00 00 00 00 00 00 00 00 00 00');
          user[cid].INDP:=true;
          End;
        'B': if Ras(x,y,-11966,123610)<10 then Begin
          if MelvilLe<>0 Then STS(cid,'1F'+anti4HEX(MelvilLe)+'00 00 00 00 00 00 00 00 00 00 00 00 00');
          user[cid].INDP:=true;
          End;
        'C': if Ras(x,y,-14571,121013)<10 then Begin
          if Thoma<>0 Then STS(cid,'1F'+anti4HEX(Thoma)+'00 00 00 00 00 00 00 00 00 00 00 00 00');
          user[cid].INDP:=true;
          End;
        'D': if Ras(x,y,-16599,124172)<10 then Begin
          if Badenco<>0 Then STS(cid,'1F'+anti4HEX(Badenco)+'00 00 00 00 00 00 00 00 00 00 00 00 00');
          user[cid].INDP:=true;
          End;
        end;
      End;
      Form2.Label1.Caption:=inttostr(user[cid].Lvl);
    End;


  except on E : Exception do
    ShowMessage('ОШИБКА MoveToLocation:'+E.ClassName+' ошибка: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
//----------------------------------------------------------Получение таргета---
procedure MyT(CID,TID:integer);
begin
Try
  if (User[CID].Online) and ((TID=Curtis)or(TID=MelvilLe)or(TID=Thoma)or(TID=Badenco) ) then Begin
    sts(cid,'39 94 04 00 00 01 00 00 00 00');

    //STS(cid,'01'+anti4HEX(TID)+'00 00 00 00 00 00 00 00 00 00 00 00 00');;
  End;
  except on E : Exception do
    ShowMessage('ОШИБКА MyT:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;
//------------------------------------------------------------------------------
//-------------------------------------------------------------------ItemList---
procedure IL(CID,OID,IID,C,n:integer);
begin
Try
  if n=0 then user[CID].IList.Clear;
  user[CID].IList.AddItem(OID,IID,C);
except on E : Exception do
    ShowMessage('ОШИБКА IL:'+E.ClassName+' ошибка: '+E.Message);
end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------InventoryUpdate---
procedure InventoryUpdate(CID,CH,OID,IID,C:integer);
begin
Try
  if user[CID].IList.IFIID(IID)<>-1 Then
  case ch of
    3: user[CID].IList.Delete(user[CID].IList.IFIID(IID));
    2: user[CID].IList[user[CID].IList.IFIID(IID)].Count:=C;
    End;
  if ch=1 Then user[CID].IList.AddItem(OID,IID,C);
  except on E : Exception do
    ShowMessage('ОШИБКА InventoryUpdate:'+E.ClassName+' ошибка: '+E.Message);
  end;
end;
//------------------------------------------------------------------------------
end.
