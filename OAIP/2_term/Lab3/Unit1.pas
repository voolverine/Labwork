unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Unit2;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dataBase: studentClass;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Text := '';
  StringGrid1.ColCount := 4;
  StringGrid1.RowCount := 2;
  StringGrid1.Cells[1, 0] := 'Ф.И.О.';
  StringGrid1.Cells[2, 0] := 'Адрес(город)';
  StringGrid1.Cells[3, 0] := 'Средний балл';
  dataBase := studentClass.Create();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  dataBase.buttonAddClicked(StringGrid1.Cells[1, 1], StringGrid1.Cells[2, 1], StrToFloat(StringGrid1.Cells[3, 1]));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  dataBase.buttonDeleteClicked(StringGrid1.Cells[1, 1]);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  dataBase.writeToMemo(Memo1, true);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  dataBase.writeToMemo(Memo1, false);
end;

end.
