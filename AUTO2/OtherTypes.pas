unit OtherTypes;

interface

uses Windows,Classes;

Type
  TBaff = Record
    public
    SkillID:integer;
    LTU:DWORD;
    Duration:integer;
    End;

  TBaffList = Record
    private
      items:array[0..36] of TBaff;
      Count:integer;
      function IFID(ID: Integer): Integer;
      function GetR(ID: Integer): boolean;
      function GetItem(ID: Integer): TBaff;
    public
      Procedure SLTU(ID:Integer;D:integer = 1000);
      Property Active[ID: Integer]:boolean read GetR;
      Property Itemi[ID: Integer]:TBaff read GetItem;
    End;

  TMyDelay = Record
    private
      Delay:DWord;
      LTU:DWord;
      function GetR: boolean;
    public
      Procedure SLTU(D:integer = 1000);
      Property Active:boolean read GetR;
    End;

  TMyMacroAction = Record
      md:TMyDelay;
      CA:DWord;
      Count:DWord;
      AList:string;
      PN:integer;
      isComplete:Boolean;
      Procedure SetAction (PointN:integer;ActionList:string);
    End;
implementation

{------------------------------------------------------------------TBaffList---}

function TBaffList.GetItem(ID: Integer): TBaff;
var i:integer;
 b:TBaff;
begin
  Result:=b;
  i:=IFID(ID);
  if i<>-1 then Result:=Items[i];
end;

function TBaffList.GetR(ID: Integer): boolean;
var i:integer;
begin
  Result:=false;
  i:=IFID(ID);
  if (i<>-1) and (((items[i].Duration-(GetTickCount-items[i].LTU)/1000)>20)) then Result:=True;
end;

procedure TBaffList.SLTU(ID:Integer;D: integer);
var i:integer;
begin
  i:=IFID(ID);
  if i=-1 then Begin
    items[Count].SkillID:=ID;
    items[Count].Duration:=D;
    items[Count].LTU:=GetTickCount;
    inc(Count);
    End else Begin
      items[i].Duration:=D;
      items[i].LTU:=GetTickCount;
      End;
end;

function TBaffList.IFID(ID: Integer): Integer;
var i:integer;
begin
  Result:=-1;
  i:=0;
  while (Result=-1) and (i<Count) do
    if items[i].SkillID=ID then  Result:=i else inc(i);
end;
{-------------------------------------------------------------------TMyDelay---}

function TMyDelay.GetR: boolean;
begin
  Result := false;
  if LTU+Delay<GetTickCount then Result := True;
end;

procedure TMyDelay.SLTU(D:integer = 1000);
begin
  Delay:=D;
  LTU:=GetTickCount;
end;

{ TMyMacroAction }

procedure TMyMacroAction.SetAction(PointN:integer;ActionList:string);
var ml:TStrings;
begin
  ml:=TstringList.Create;
  isComplete:=false;
  PN:=PointN;
  CA:=0;
  AList:=ActionList;
  ml.Text:=ActionList;
  Count:=ml.Count;
  ml.Free;
end;

end.
