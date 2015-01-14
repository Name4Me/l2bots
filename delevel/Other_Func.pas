unit Other_Func;
interface
uses Dialogs,SysUtils,Variants,Classes;

  function ras(x1,y1,x2,y2:integer):integer;
  function anti4HEX(d:variant):string;

  Type
  MyPoint=Record
  x,y,z:integer;
  End;

  Poligon=Record
  size:integer;
  Point:array[0..10]of MyPoint;
  Function isinpoligon(x,y:integer):boolean;
  Procedure SetResp(x,y,z:integer);
  Procedure AddPoint(x,y,z:integer);
  Procedure SaveToFile(fname:string);
  Procedure LoadFromFile(fname:string);
  Procedure clear;
  End;

implementation

function ras(x1,y1,x2,y2:integer):integer;// --------------Растояние между точками---------------------------
begin
  Result:=9999;
  Try
    if (abs(x1-x2)>9999) or (abs(y1-y2)>9999) then Result:=9999 else
    if ((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))<>0 then Result:=Round(Sqrt(((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))))
    else result:=0;
  except on E:Exception do
    ShowMessage('ras: x1:'+inttostr(x1)+' y1:'+inttostr(y1)+' x2:'+inttostr(x2)+' y2:'+inttostr(y2)+' Result:'+inttostr(Result)+' !'+E.ClassName+' ошибка: '+E.Message);
  end;
end;
//----------------------------------------------------------------Инт то Хекс---
function anti4HEX(d:variant):string;
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
    ShowMessage('anti4HEX'+E.ClassName+' ошибка: '+E.Message);
  end;
end;

{ Poligon }

procedure Poligon.AddPoint(x, y, z: integer);
begin
  inc(size);
  Point[size].x:=x;
  Point[size].y:=y;
  Point[size].z:=z;
end;

procedure Poligon.clear;
Var i:integer;
begin
  For i:=0 to size-1 do Begin
    Point[i].x:=0;
    Point[i].y:=0;
    Point[i].z:=0;
    End;
  size:=0;
end;

function Poligon.isinpoligon(x, y: integer): boolean;
Var i,j:integer;
begin
  Result := false;
   if size>3 then For i:=1 to size do Begin
    if i<size then j:=i+1 else j:=1;
    if   (((Point[i].y>y) and  (y>Point[j].y)) or ((Point[i].y<y) and (y<Point[j].y))) and
      ((Point[i].x+((Point[i].x-Point[j].x)*(Point[i].y-y))/(Point[j].y-Point[i].y))<x)
      then  Result :=  not Result;
    End;
end;

procedure Poligon.LoadFromFile(fname: string);
var ml:TStrings;
  i:integer;
  s:string;
begin
  ml:=TstringList.Create;
  ml.LoadFromFile(fname);
  For i:=0 to ml.Count-1 do if ml[i]<>'' then Begin
    Point[i].x:=strtoint(copy(ml[i],1,pos(',',ml[i])-1));
    s:=ml[i];
    Delete(s,1,pos(',',s));
    Point[i].y:=strtoint(copy(s,1,pos(',',s)-1));
    Delete(s,1,pos(',',s));
    Point[i].z:=strtoint(s);
    inc(size);
  End;
  ml.Free;
end;

procedure Poligon.SaveToFile(fname: string);
var ml:TStrings;
  i:integer;
begin
  ml:=TstringList.Create;
  For i:=0 to size do ml.Add(inttostr(Point[i].x)+','+inttostr(Point[i].y)+','+inttostr(Point[i].z));
  ml.SaveToFile(fname);
  ml.Free;
end;

procedure Poligon.SetResp(x, y, z: integer);
begin
  Point[0].x:=x;
  Point[0].y:=y;
  Point[0].z:=z;
end;

end.

