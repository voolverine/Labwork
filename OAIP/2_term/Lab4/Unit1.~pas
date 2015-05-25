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
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myStudents: List;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    StringGrid1.RowCount := 2;
    StringGrid1.ColCount := 3;
    StringGrid1.Cells[0, 0] := 'Ф.И.О.';
    StringGrid1.Cells[1, 0] := 'Город';
    StringGrid1.Cells[2, 0] := 'Ср.балл';
    Memo1.Clear();

    myStudents := List.Create();
    database := 'database.dat';
    myStudents.ReadFromDataBase();
end;

procedure TForm1.Button1Click(Sender: TObject);
var temp: TStudent;
begin
    temp.initials := StringGrid1.Cells[0, 1];
    temp.city := StringGrid1.Cells[1, 1];
    temp.rating := StrToFloat(StringGrid1.Cells[2, 1]);
    myStudents.Add(temp);
    myStudents.TryToSortInArray(1, myStudents.count);
    myStudents.showAllInTheCurrentMemo(Memo1);
    myStudents.RewriteDataBase();
end;



procedure TForm1.Button3Click(Sender: TObject);
begin
    myStudents.showAllInTheCurrentMemo(Memo1);
end;


procedure TForm1.Button2Click(Sender: TObject);
var temp: TStudent;
begin
    temp.initials := StringGrid1.Cells[0, 1];
    myStudents.TryToDelete(temp);
    myStudents.showAllInTheCurrentMemo(Memo1);
    myStudents.RewriteDataBase();
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    myStudents.showZadrotsInTheCurrentMemo(Memo1);
end;

end.
