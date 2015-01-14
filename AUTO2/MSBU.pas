unit MSBU;
interface
uses Windows,Dialogs,SysUtils,ExtCtrls,Classes,IniFiles,variants,Contnrs
  ,AAction,TItems,TSkils,TNpcs,TChars,Other_Func,OtherTypes;

Type

  Target = Record
    DTT:integer;//--Дістанция до цели---
    ID:integer;
    HP,MaxHP,HPID,HPC:integer;
    x,y,z:integer;
    isInCombat:boolean;
    isInCurse:boolean;
    CurseTime:DWORD;
    selected:boolean;
    spoiled:boolean;
    LTU:DWORD;
    stype:integer;
    End;
  

  TUser= class(TObject)
  Public
    PName: String[40];
    Bussi:integer;
    ConectionID:integer;
    Online:boolean;
    ClassID:integer;
    ObjectID:integer;
    LHID,RHID,RoodID,WeaponID,RoodOID,CurenLureOID:integer;

    CD,isInMTT,DieD,LastCombat:TMyDelay;

    CurentPUID:Integer;
    CurentPN:Integer;
    MA:TMyMacroAction;

    ASkID,ASkLvl:integer; //For Auto skill learn

    BaffsCount:integer;
    Baffs:TBaffList;

    CP:integer;
    MaxCP:integer;
    HP:integer;
    MaxHP:integer;
    MP:integer;
    MaxMP,SP:integer;

    CurentT:Target;
    CurentCK:Target;
    Lider:Target;
    Pet:Target;

    MPiID:integer;
    HPiID:integer;
    CPiID:integer;

    status: String[10];

    MAS:integer;//Основной атакующий скил
    MCS:integer;//Основной curse скил
    MDS:integer;//Основной дрейн скил
    MBS:integer;//Основной ближний скил

    MHS:integer;//Основной heal скил
    MMH:integer;//Основной mas heal скил

    x:integer;
    y:integer;
    z:integer;

    rk:integer;
    vpheading:integer;

    INKT:boolean;//Kust

    OnAutoBaf:boolean;
    OnPartyBaf:boolean;
    OnSelfBaf:boolean;
    OnOfBaf:boolean;
    OnAutoAtack:boolean;
    OnAutoPickUp:boolean;
    OnAutoAssist:boolean;
    OnMoveToLiader:boolean;
    OnAutoMTT:boolean;
    OnAutoOFF:boolean;
    OnSBS:boolean;
    RecordTreck:boolean;

    

    INPU:boolean; //PickUp
    INRM:boolean; //Restore mp

    MovePoint:TPoint;
    IsInAA:boolean;
    IsCPUse:boolean;
    IsHPUse:boolean;
    IsMPUse:boolean;
    isInMTP:boolean;
    isInHeal:boolean;
    isInSBaf:boolean;
    isInCombat:boolean;
    isInSweep:boolean;
    isInHold:boolean;
    //isMistick:boolean;


    AF:Boolean;



    Treck:Poligon;

    DropList:TItemList;
    ATList:TStrings;
    SwepList:TStrings;
    NpcList:TNpcList;
    IList:TItemList;

    FBList:TStrings;
    MBList:TStrings;
    ABList:TStrings;
    ADL:TStrings;
    ASL:TStrings;
    IgnorList:TStrings;
    PartyList:TCharList;
    CharList:TCharList;
    SkilList:TSkilList;
    
    Procedure Init(CnName:string);
    Procedure Save;
    procedure Reload;
    constructor create(CID:integer;CnName:string);
    Destructor Destroy; override;
end;
//-----------------------------------------------------------TUserList-[Begin]--
  TUserList = class(TObjectList)
    private
      function GetItems(Index: Integer): TUser;
      procedure SetItems(Index: Integer; const Value: TUser);
    function GetItemi(Index: Integer): TUser;
    procedure SetItemi(Index: Integer; const Value: TUser);
     
    public
      function IndexByConID(CID: Integer): Integer;
      property Items[Index: Integer]: TUser read GetItems write SetItems; default;
      property Itemi[Index: Integer]: TUser read GetItemi write SetItemi; 
    end;
//-------------------------------------------------------------TUserList-[End]--

var
  User:TUserList;
  LiderOn:boolean = False;
  Onform:boolean = false;

  sid,itid,npid,log:TStrings;

  //tic:integer;
  CurrentDir:String;
  Tr:Poligon;

  implementation


constructor TUser.create(CID:integer;CnName:string);
Begin
try
  inherited Create;
  PName:=CnName;
  ConectionID:=CID;
  ATList:=Tstringlist.Create;
  DropList:=TItemList.Create;
  NpcList:=TNpcList.Create;
  IList:=TItemList.Create;
  FBList:=Tstringlist.Create;
  MBList:=Tstringlist.Create;
  SwepList:=Tstringlist.Create;
  ABList:=Tstringlist.Create;
  ADL:=Tstringlist.Create;
  ASL:=Tstringlist.Create;
  IgnorList:=Tstringlist.Create;
  PartyList:=TCharList.Create;
  CharList:=TCharList.Create;
  SkilList:=TSkilList.Create;
  Treck:=Poligon.Create;
  MovePoint:=TPoint.Create;
  Init(CnName);
  except on E : Exception do
    ShowMessage('ОШИБКА TUser.create:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

destructor TUser.Destroy;
begin
try
  Save;
  if ATList<>nil then ATList.Free;
  if SwepList<>nil then SwepList.Free;
  if DropList<>nil then DropList.Free;
  if NpcList<>nil then NpcList.Free;
  if IList<>nil then IList.Free;
  if FBList<>nil then FBList.Free;
  if MBList<>nil then MBList.Free;
  if ABList<>nil then ABList.Free;
  if ADL<>nil then ADL.Free;
  if ASL<>nil then ASL.Free;
  if IgnorList<>nil then IgnorList.Free;
  if PartyList<>nil then PartyList.Free;
  if CharList<>nil then CharList.Free;
  if SkilList<>nil then SkilList.Free;
  if Treck<>nil then Treck.Free;

  if MovePoint<>nil then MovePoint.Free;
  inherited;
  except on E : Exception do
    ShowMessage('ОШИБКА TUser.Destroy:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure TUser.Init(CnName:string);
var MyIniF:TIniFile; //DelphiIni := TIniFile.Create('c:\windows\delphi32.ini');
  ml:tstrings;
  i:integer;
begin
try
  if ATList<>nil then ATList.Clear;
  if SwepList<>nil then SwepList.Clear;
  if DropList<>nil then DropList.Clear;
  if NpcList<>nil then NpcList.Clear;
  if IList<>nil then IList.Clear;
  if FBList<>nil then FBList.Clear;
  if MBList<>nil then MBList.Clear;
  if ABList<>nil then ABList.Clear;
  if IgnorList<>nil then IgnorList.Clear;
  if PartyList<>nil then PartyList.Clear;
  if CharList<>nil then CharList.Clear;
  if SkilList<>nil then SkilList.Clear;

  Online:=true;
  PName:=CnName;
  MyIniF:= TIniFile.Create(CurrentDir+'\Chars\'+PName+'.ini');
  if ClassId=0 then ClassId:=MyIniF.ReadInteger(PName,'ClassID',0);
  //NpcList.pol.LoadFromFile(CurrentDir+'\Treks\Gludio1.trk');
  MyIniF.ReadSectionValues('IgnorList',IgnorList);
  MyIniF.ReadSectionValues('FBList'+inttostr(ClassId),FBList);
  MyIniF.ReadSectionValues('MBList'+inttostr(ClassId),MBList);
  MyIniF.ReadSectionValues('ABList'+inttostr(ClassId),ABList);
  ADL.LoadFromFile(CurrentDir+'\Settings\ADL.ini');
  ASL.LoadFromFile(CurrentDir+'\Settings\ASL.ini');
  Ml:=TstringList.Create;
  MyIniF.ReadSectionValues('SkilList'+inttostr(ClassId),ml);

  for i := 0 to ml.Count - 1 do
    if IgnorList.IndexOfName(ml.names[i])=-1 then
      SkilList.ADDSkil(ml.ValueFromIndex[i],strtoint(ml.names[i]));
  ml.Free;

  HPiID:=MyIniF.ReadInteger(inttostr(ClassId),'HPiID',0);
  MPiID:=MyIniF.ReadInteger(inttostr(ClassId),'MPiID',0);
  CPiID:=MyIniF.ReadInteger(inttostr(ClassId),'CPiID',0);

  Mas:=MyIniF.ReadInteger(inttostr(ClassId),'MAS',0);
  MCS:=MyIniF.ReadInteger(inttostr(ClassId),'MCS',0);
  Mds:=MyIniF.ReadInteger(inttostr(ClassId),'MDS',0);
  Mbs:=MyIniF.ReadInteger(inttostr(ClassId),'MBS',0);
  MHS:=MyIniF.ReadInteger(inttostr(ClassId),'MHS',0);
  MMH:=MyIniF.ReadInteger(inttostr(ClassId),'MMH',0);
  status:=MyIniF.ReadString(inttostr(ClassId),'Status','----------');

  x:=MyIniF.ReadInteger(inttostr(ClassId),'x',0);
  y:=MyIniF.ReadInteger(inttostr(ClassId),'y',0);
  z:=MyIniF.ReadInteger(inttostr(ClassId),'z',0);
  rk:=MyIniF.ReadInteger(inttostr(ClassId),'RK',400);

  MyIniF.Free;
  except on E : Exception do
    ShowMessage('ОШИБКА TUser.Init:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure TUser.Reload;
var MyIniF:TIniFile; //DelphiIni := TIniFile.Create('c:\windows\delphi32.ini');
  ml:tstrings;
  i:integer;
begin
try
  if ATList<>nil then ATList.Clear;
  if SwepList<>nil then SwepList.Clear;
  if FBList<>nil then FBList.Clear;
  if MBList<>nil then MBList.Clear;
  if ABList<>nil then ABList.Clear;
  if IgnorList<>nil then IgnorList.Clear;
  if SkilList<>nil then SkilList.Clear;
  MyIniF:= TIniFile.Create(CurrentDir+'\Chars\'+PName+'.ini');
  if ClassId=0 then ClassId:=MyIniF.ReadInteger(PName,'ClassID',0);
  //NpcList.pol.LoadFromFile(CurrentDir+'\Treks\Gludio1.trk');
  MyIniF.ReadSectionValues('IgnorList',IgnorList);
  MyIniF.ReadSectionValues('FBList'+inttostr(ClassId),FBList);
  MyIniF.ReadSectionValues('MBList'+inttostr(ClassId),MBList);
  MyIniF.ReadSectionValues('ABList'+inttostr(ClassId),ABList);
  ADL.LoadFromFile(CurrentDir+'\Settings\ADL.ini');
  ASL.LoadFromFile(CurrentDir+'\Settings\ASL.ini');
  Ml:=TstringList.Create;
  MyIniF.ReadSectionValues('SkilList'+inttostr(ClassId),ml);

  for i := 0 to ml.Count - 1 do
    if IgnorList.IndexOfName(ml.names[i])=-1 then
      SkilList.ADDSkil(ml.ValueFromIndex[i],strtoint(ml.names[i]));
  ml.Free;

  HPiID:=MyIniF.ReadInteger(inttostr(ClassId),'HPiID',0);
  MPiID:=MyIniF.ReadInteger(inttostr(ClassId),'MPiID',0);
  CPiID:=MyIniF.ReadInteger(inttostr(ClassId),'CPiID',0);

  MyIniF.Free;
  except on E : Exception do
    ShowMessage('ОШИБКА TUser.Reload:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure TUser.Save;
var MyIniF:TIniFile;
  i:integer;
begin
try
  if PName<>'' then Begin
  
  MyIniF:= TIniFile.Create(CurrentDir+'\Chars\'+PName+'.ini');
  MyIniF.WriteInteger(PName,'ClassID',ClassId);
  MyIniF.WriteInteger(inttostr(ClassId),'MAS',MAS);
  MyIniF.WriteInteger(inttostr(ClassId),'MCS',MCS);
  MyIniF.WriteInteger(inttostr(ClassId),'MDS',MDS);
  MyIniF.WriteInteger(inttostr(ClassId),'MBS',MBS);
  MyIniF.WriteInteger(inttostr(ClassId),'MHS',MHS);
  MyIniF.WriteInteger(inttostr(ClassId),'MMH',MMH);
  MyIniF.WriteString(inttostr(ClassId),'Status',Status);


  MyIniF.WriteInteger(inttostr(ClassId),'CP',CP);
  MyIniF.WriteInteger(inttostr(ClassId),'MaxCP',MaxCP);
  MyIniF.WriteInteger(inttostr(ClassId),'HP',HP);
  MyIniF.WriteInteger(inttostr(ClassId),'MaxHP',MaxHP);
  MyIniF.WriteInteger(inttostr(ClassId),'MP',MP);
  MyIniF.WriteInteger(inttostr(ClassId),'MaxMP',MaxMP);

  MyIniF.WriteInteger(inttostr(ClassId),'CPiID',CPiID);
  MyIniF.WriteInteger(inttostr(ClassId),'MPiID',MPiID);
  MyIniF.WriteInteger(inttostr(ClassId),'HPiID',HPiID);


  MyIniF.WriteInteger(inttostr(ClassId),'x',x);
  MyIniF.WriteInteger(inttostr(ClassId),'y',y);
  MyIniF.WriteInteger(inttostr(ClassId),'z',z);
  MyIniF.WriteInteger(inttostr(ClassId),'RK',rk);
  if ABList.Count<>0 then for i := 0 to ABList.Count - 1 do
    MyIniF.WriteString('ABList'+inttostr(ClassID),ABList.Names[i],ABList.ValueFromIndex[i]);

  if SkilList.Count<>0 then for i := 0 to SkilList.Count - 1 do
    MyIniF.WriteString('SkilList'+inttostr(ClassID),inttostr(SkilList.Items[i].ID),SkilList.Items[i].Name);
  if IgnorList.Count<>0 then for i := 0 to IgnorList.Count - 1 do
    MyIniF.WriteString('IgnorList',IgnorList.Names[i],IgnorList.ValueFromIndex[i]);
  MyIniF.Free;
  End;
except on E : Exception do
    ShowMessage('ОШИБКА TUser.Save:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

//------------------------------------------------------------------------------
//-----------------------------------------------------------TUserList-[Begin]--
function TUserList.GetItemi(Index: Integer): TUser;
begin
  Result:=nil;
try
  if (Index>=0) And (Index<=Count-1) then Result := TUser(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('ОШИБКА TUserList.GetItemi:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

function TUserList.GetItems(Index: Integer): TUser;
begin
  Result:=nil;
try
  if index>=0 Then Index:=IndexByConID(Index);
  if (Index>=0) And (Index<=Count-1) then Result := TUser(inherited GetItem(Index));
  except on E : Exception do
    ShowMessage('ОШИБКА TUserList.GetItems:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

function TUserList.IndexByConID(CID: Integer): Integer;
Var i:integer;
begin
  Result:=-1;
try
  i:=0;
  while (Result=-1) and (i<Count) do
    if itemi[i].ConectionID=CID then Result:=i else inc(i);
  except on E : Exception do
    ShowMessage('ОШИБКА TUserList.IndexByConID:'+E.ClassName+' ошибка: '+E.Message);
  end;
end;

procedure TUserList.SetItemi(Index: Integer; const Value: TUser);
begin
try
  if (Index>=0) And (Index<=Count-1) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('ОШИБКА TUserList.SetItemi:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;

procedure TUserList.SetItems(Index: Integer; const Value: TUser);
begin
try
  Index:=IndexByConID(Index);
  if (Index>=0) And (Index<=Count-1) then inherited SetItem(Index, Value);
  except on E : Exception do
    ShowMessage('ОШИБКА TUserList.SetItems:'+E.ClassName+' ошибка: '+E.Message);
  End;
end;
//-------------------------------------------------------------TUserList-[End]--

Begin
  Tr:=Poligon.Create;
  CurrentDir:=GetCurrentDir;
  sid:=Tstringlist.Create;
  itid:=Tstringlist.Create;
  npid:=Tstringlist.Create;
  log:=Tstringlist.Create;
  sid.LoadFromFile(CurrentDir+'\Settings\SkillsID.ini');
  itid.LoadFromFile(CurrentDir+'\Settings\ItemsID.ini');
  npid.LoadFromFile(CurrentDir+'\Settings\npcsid.ini');
end.
