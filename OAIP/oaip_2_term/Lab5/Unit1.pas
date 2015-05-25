unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Unit2;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myStack: Stack;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    randomize;

    Edit1.Text := '10';
    myStack := Stack.Create();
end;

procedure TForm1.Button1Click(Sender: TObject);
var n, i: longint;
begin
    n := StrToInt(Edit1.Text);
    myStack.Destroy();

    for i := 1 to n do begin
        myStack.push_back(random(2000) - 1000);
    end;

    myStack.print(StringGrid1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    myStack.bubble_sort();
    myStack.print(StringGrid1);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    myStack.push_back(random(2000) - 1000);
    myStack.print(StringGrid1);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    myStack.pop_back();
    myStack.print(StringGrid1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    myStack.swapExtremuls();
    myStack.print(StringGrid1);
end;

end.
