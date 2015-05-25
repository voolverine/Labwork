unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Unit2;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sollution: calc;

implementation

{$R *.dfm}

function delete_spaces(s: string): string;
var res: string;
    i: longint;
begin
    res := '';
    for i := 1 to length(s) do begin
        if (s[i] <> ' ') then begin
            res := res + s[i];
        end;
    end;

    delete_spaces := res;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    StringGrid1.Cells[0, 0] := 'a';
    StringGrid1.Cells[0, 1] := 'd';
    StringGrid1.Cells[0, 2] := 'e';
    StringGrid1.Cells[0, 3] := 'f';
    StringGrid1.Cells[0, 4] := 'g';
    StringGrid1.Cells[0, 5] := 's';
    StringGrid1.Cells[0, 6] := 'w';

    StringGrid1.Cells[1, 0] := '1';
    StringGrid1.Cells[1, 1] := '2';
    StringGrid1.Cells[1, 2] := '3';
    StringGrid1.Cells[1, 3] := '4';
    StringGrid1.Cells[1, 4] := '5';
    StringGrid1.Cells[1, 5] := '6';
    StringGrid1.Cells[1, 6] := '7';

    Edit1.Text := '(d - e) ^ f * g + s / a + w';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    Edit1.Text := delete_spaces(Edit1.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    sollution.Free;

    sollution := calc.Create();
    sollution.values['a'] := StrToFloat(StringGrid1.Cells[1, 0]);
    sollution.values['d'] := StrToFloat(StringGrid1.Cells[1, 1]);
    sollution.values['e'] := StrToFloat(StringGrid1.Cells[1, 2]);
    sollution.values['f'] := StrToFloat(StringGrid1.Cells[1, 3]);
    sollution.values['g'] := StrToFloat(StringGrid1.Cells[1, 4]);
    sollution.values['s'] := StrToFloat(StringGrid1.Cells[1, 5]);
    sollution.values['w'] := StrToFloat(StringGrid1.Cells[1, 6]);

    Edit2.Text := sollution.transform_in_rpr(Edit1.Text);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Edit3.Text := FloatToStrF(sollution.get_result(), fffixed, 8, 2);
end;



procedure TForm1.StringGrid1Exit(Sender: TObject);
begin
    sollution.Free;

    sollution := calc.Create();
    sollution.values['a'] := StrToFloat(StringGrid1.Cells[1, 0]);
    sollution.values['d'] := StrToFloat(StringGrid1.Cells[1, 1]);
    sollution.values['e'] := StrToFloat(StringGrid1.Cells[1, 2]);
    sollution.values['f'] := StrToFloat(StringGrid1.Cells[1, 3]);
    sollution.values['g'] := StrToFloat(StringGrid1.Cells[1, 4]);
    sollution.values['s'] := StrToFloat(StringGrid1.Cells[1, 5]);
    sollution.values['w'] := StrToFloat(StringGrid1.Cells[1, 6]);
    
    Edit2.Text := sollution.transform_in_rpr(Edit1.Text);
end;

end.
