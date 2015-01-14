unit MsbForm;


interface
                         
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,  
  Gauges, ToolWin, Buttons, ImgList,DateUtils, Menus,
  msbu, Spin;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
end;
var
  Form2: TForm2;
  mx,my:integer;
  lb:bool;
implementation
uses unit2,AAction;
{$R *.dfm}
Begin
end.
