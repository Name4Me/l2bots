unit Other_Func;
interface
uses Dialogs,SysUtils,Variants,Classes,IniFiles,Contnrs;

  function ras(x1,y1,x2,y2:integer):integer;
  function anti4HEX(d:variant):string;
  Function ComparÑeInteger(i1,i2:integer):integer;

  Type
  TPoint = class
    x,y,z,pn:integer;
    alist:string;
    Name:string;
    End;

  Poligon = class(TObjectList)
    Name:string;
    MoveForward:Boolean;
    minx,miny,maxx,maxy,mult,multx,multy:integer;
    Function isinpoligon(x,y:integer):boolean;
    Procedure SetResp(x,y,z:integer);
    Procedure AddPoint(x,y,z:integer;nm:string ='';a:string ='');
    Procedure SaveToFile(fname:string);
    Procedure LoadFromFile(fname:string);
  private
    function GetItems(Index: Integer): TPoint;
    procedure SetItems(Index: Integer; const Value: TPoint);
  published
    public
    property Items[Index: Integer]: TPoint read GetItems write SetItems; default;
    End;

implementation

function ras(x1,y1,x2,y2:integer):integer;// --------------Ðàñòîÿíèå ìåæäó òî÷êàìè---------------------------
begin
  Result:=9999;
  Try
    if (abs(x1-x2)>9999) or (abs(y1-y2)>9999) then Result:=9999 else
    if ((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))<>0 then Result:=Round(Sqrt(((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))))
    else result:=0;
  except on E:Exception do
    ShowMessage('ras: x1:'+inttostr(x1)+' y1:'+inttostr(y1)+' x2:'+inttostr(x2)+' y2:'+inttostr(y2)+' Result:'+inttostr(Result)+' !'+E.ClassName+' îøèáêà: '+E.Message);
  end;
end;
function anti4HEX(d:variant):string;// --------------Èíò òî Õåêñ----------------------------------
var S:String;
begin

  Try
    Result:='00000000';
    case VarType(d) of
      varString:  S:=IntToHex(strtoint(d),8);
      varInteger: S:=IntToHex(d,8);
    end;
   Result:=' '+S[7]+S[8]+' '+S[5]+S[6]+' '+S[3]+S[4]+' '+S[1]+S[2];
  except on E:Exception do
    ShowMessage('anti4HEX'+E.ClassName+' îøèáêà: '+E.Message);
  end;
end;

Function ComparÑeInteger(i1,i2:integer):integer;
Begin
  if i1=i2 then result:=0
    else if i1>i2 then result:=1 else result:=-1;
End;


{ Poligon }

procedure Poligon.AddPoint(x, y, z: integer;nm:string ='';a:string ='');
Var Point:TPoint;
begin
Try
  Point:=TPoint.Create;
  Point.x:=x;
  Point.y:=y;
  Point.z:=z;
  if nm<>'' Then Point.Name:=nm
    Else Point.Name:=copy('000',1,3-length(inttostr(Count)))+inttostr(Count);
  Point.alist:=a;
  if (minx=0) or (x<minx) then minx:=x;
  if (miny=0) or (y<miny) then miny:=y;
  if (maxx=0) or (x>maxx) then maxx:=x;
  if (maxy=0) or (y>maxy) then maxy:=y;
  if Count>0 then Begin
    if abs(maxx-minx)>abs(maxy-miny) then mult:=abs(maxx-minx);
    if abs(maxx-minx)<abs(maxy-miny) then mult:=abs(maxy-miny);
    multx:=abs(maxx-minx);
    multy:=abs(maxy-miny);
    End;
  Add(Point);
  except on E : Exception do
    ShowMessage('ÎØÈÁÊÀ Poligon.AddPoint:'+E.ClassName+' îøèáêà: '+E.Message);
  End;
end;

function Poligon.GetItems(Index: Integer): TPoint;
begin
  Result := TPoint(inherited GetItem(Index));
end;

function Poligon.isinpoligon(x, y: integer): boolean;
Var i,j:integer;
begin
  Result := false;
   if Count>3 then For i:=1 to Count-1 do Begin
    if i<Count-1 then j:=i+1 else j:=1;
    if   (((Items[i].y>y) and  (y>Items[j].y)) or ((Items[i].y<y) and (y<Items[j].y))) and
      ((Items[i].x+((Items[i].x-Items[j].x)*(Items[i].y-y))/(Items[j].y-Items[i].y))<x)
      then  Result :=  not Result;
    End;
end;

procedure Poligon.LoadFromFile(fname: string);
var ml,al:TStrings;
  i,x,y,z,n,c:integer;
  s:string;
  r: array [0..4] of integer;
  MyIniF:TIniFile;
begin
  Clear;
  minx:=0;
  miny:=0;
  maxx:=0;
  maxy:=0;
  ml:=TstringList.Create;
  al:=TstringList.Create;
  MyIniF:=TIniFile.Create(fname);
  MyIniF.ReadSectionValues('Points',ml);
  Name:=fname;

  //
  For i:=0 to ml.Count-1 do if ml[i]<>'' then Begin
    s:=ml[i];
    n:=0;
    for c := 1 to length(s) do Begin
      if (s[c]='=') or (s[c]=',') then r[n]:=c;
      if (s[c]='=') or (s[c]=',') then inc(n);
      End;
    x:=strtoint(copy(ml[i],r[0]+1,r[1]-r[0]-1));
    y:=strtoint(copy(ml[i],r[1]+1,r[2]-r[1]-1));
    z:=strtoint(copy(ml[i],r[2]+1,length(s)-r[2]));
    MyIniF.ReadSectionValues(copy(ml[i],1,r[0]-1),al);
    AddPoint(x,y,z,copy(ml[i],1,r[0]-1),al.Text);
    End;
  MyIniF.Free;
  ml.Free;
  al.Free;
end;

procedure Poligon.SaveToFile(fname: string);
var al:TStrings;
  i,n:integer;
  MyIniF:TIniFile;
  s:string;
begin
  MyIniF:=TIniFile.Create(fname);
  MyIniF.EraseSection('Points');
  al:=TstringList.Create;
  For i:=0 to Count-1 do With Items[i] do Begin
    s:=copy('000',1,3-length(inttostr(i)))+inttostr(i);
    MyIniF.WriteString('Points',s,inttostr(x)+','+inttostr(y)+','+inttostr(z));
    al.Text:=alist;
    MyIniF.EraseSection(s);
    For n:=0 to al.Count-1 do MyIniF.WriteString(s,al.Names[n],al.ValueFromIndex[n]);
    End;
  MyIniF.Free;
  al.Free;
end;

procedure Poligon.SetItems(Index: Integer; const Value: TPoint);
begin
  inherited SetItem(Index, Value);
end;

procedure Poligon.SetResp(x, y, z: integer);
begin
  Items[0].x:=x;
  Items[0].y:=y;
  Items[0].z:=z;
end;

end.

