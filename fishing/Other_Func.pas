unit Other_Func;
interface
uses Dialogs,SysUtils,Variants;

  function ras(x1,y1,x2,y2:integer):integer;
  function anti4HEX(d:variant):string;

implementation
function ras(x1,y1,x2,y2:integer):integer;// --------------Растояние между точками---------------------------
begin
  Result:=-1;
  Try
    if ((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))<>0 then Result:=Round(Sqrt(((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2))))
    else result:=0;
  except on E:Exception do
    ShowMessage('ras: x1:'+inttostr(x1)+' y1:'+inttostr(y1)+' x2:'+inttostr(x2)+' y2:'+inttostr(y2)+' Result:'+inttostr(Result)+' !'+E.ClassName+' ошибка: '+E.Message);
  end;
end;
function anti4HEX(d:variant):string;// --------------Инт то Хекс----------------------------------
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
Function GetVarType(v:variant):string;
var
  typeString:String;
Begin

  // Установка строки для согласования типа
  case VarType(v) of
    varEmpty     : typeString := 'varEmpty';
    varNull      : typeString := 'varNull';
    varSmallInt  : typeString := 'varSmallInt';
    varInteger   : typeString := 'varInteger';
    varSingle    : typeString := 'varSingle';
    varDouble    : typeString := 'varDouble';
    varCurrency  : typeString := 'varCurrency';
    varDate      : typeString := 'varDate';
    varOleStr    : typeString := 'varOleStr';
    varDispatch  : typeString := 'varDispatch';
    varError     : typeString := 'varError';
    varBoolean   : typeString := 'varBoolean';
    varVariant   : typeString := 'varVariant';
    varUnknown   : typeString := 'varUnknown';
    varByte      : typeString := 'varByte';
    varWord      : typeString := 'varWord';
    varLongWord  : typeString := 'varLongWord';
    varInt64     : typeString := 'varInt64';
    varStrArg    : typeString := 'varStrArg';
    varString    : typeString := 'varString';
    varAny       : typeString := 'varAny';
    varTypeMask  : typeString := 'varTypeMask';
  end;
  Result:=typeString;
End;

end.
