unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Unit2;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myList: List;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    randomize;
    Edit1.Text := '15';
    myList := List.Create();
end;

procedure TForm1.Button1Click(Sender: TObject);
var size, i: longint;
begin
    myList.Destroy();
    size := StrToInt(Edit1.Text);
    StringGrid1.ColCount := size;
    StringGrid1.RowCount := 1;

    for i := 0 to size - 1 do begin
         myList.push_back(random(15));
    end;

    myList.print(StringGrid1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    myList.delete_iterations();
    myList.print(StringGrid1);
end;

end.
