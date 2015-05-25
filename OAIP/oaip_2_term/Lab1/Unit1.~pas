unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Init();
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  n: integer;

implementation

{$R *.dfm}

procedure TForm1.Init();
begin
    n := StrToInt(Edit1.Text);
end;

function recurCalc(n: integer): extended;
begin
    if (n = 1)
    then begin
         recurCalc := 1.0 / 1.5;
         exit;
    end;
    recurCalc := 1.0 / (recurCalc(n - 1) + n);
end;

function bruteCalc(n: integer): extended;
var i: integer;
    res: extended;
begin
    res := 0.5;
    for i := 1 to n do
        begin
            res := 1.0 / (1.0 * i + res);
        end;
    bruteCalc := res;
end;

procedure TForm1.Button1Click(Sender: TObject);
var recurRes, bruteRes: extended;
begin
    Init();
    Memo1.Lines.Clear;
    recurRes := recurCalc(n);
    bruteRes := bruteCalc(n);
    Memo1.Lines.Add('Рекурентная вычисление = ' + FloatToStrF(recurRes, fffixed, 8, 8));
    Memo1.Lines.Add('Нерекурентное вычисление = ' + FloatToStrF(bruteRes, fffixed, 8, 8));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Memo1.Text := '';
end;

end.
