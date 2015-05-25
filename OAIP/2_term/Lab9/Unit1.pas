unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Unit2;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Button3: TButton;
    Edit3: TEdit;
    Button4: TButton;
    Button6: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myTable: HashTable;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
    randomize();
    Edit1.Text := '20';
    StringGrid1.Cells[0, 0] := 'Key';
    StringGrid1.Cells[0, 1] := 'Text';
    myTable := HashTable.Create(17);
end;

function generate_text(): string;
var i, l: longint;
    res: string;
begin
    l := random(20) + 1;
    for i := 1 to l do begin
        res := res + Chr(Ord('a') + random(26));
    end;

    generate_text := res;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i, n: longint;
begin
    n := StrToInt(Edit1.Text);
    StringGrid1.ColCount := n + 1;
    for i := 1 to n do begin
        StringGrid1.Cells[i, 0] := IntToStr(random(1000) - 499);
        StringGrid1.Cells[i, 1] := generate_text();
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    Edit3.Text := myTable.getElement(StrToInt(Edit2.Text));
end;

procedure TForm1.Button2Click(Sender: TObject);
var i: longint;
begin
    for i := 1 to StringGrid1.ColCount - 1 do begin
        myTable.Add(StrToInt(StringGrid1.Cells[i, 0]), StringGrid1.Cells[i, 1]);
    end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    Edit3.Text := myTable.deleteElement(StrToInt(Edit2.Text));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    myTable.ShowAll(Memo1);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    myTable.remove_all();
end;

end.
