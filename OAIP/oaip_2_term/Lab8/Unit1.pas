unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, Unit2;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    TreeView1: TTreeView;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myTree: Tree;

implementation

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
begin
    Edit1.Text := '9';
    Edit2.Text := '�';
    StringGrid1.Cells[0, 0] := '�.�.�.';
    StringGrid1.Cells[1, 0] := '����� ��������';
    StringGrid1.Cells[0, 1] := '������ �.�.';
    StringGrid1.Cells[0, 2] := '������ �.�.';
    StringGrid1.Cells[0, 3] := '������� �.�.';
    StringGrid1.Cells[0, 4] := '�������� �.�.';
    StringGrid1.Cells[0, 5] := '������� �.�.';
    StringGrid1.Cells[0, 6] := '����� �.�.';
    StringGrid1.Cells[0, 7] := '����� �.�.';
    StringGrid1.Cells[0, 8] := '������ �.�.';
    StringGrid1.Cells[0, 9] := '����� �.�.';
    StringGrid1.Cells[1, 1] := 'AB1000001';
    StringGrid1.Cells[1, 2] := 'AB1000002';
    StringGrid1.Cells[1, 3] := 'AB1000003';
    StringGrid1.Cells[1, 4] := 'AB1000004';
    StringGrid1.Cells[1, 5] := 'AB1000005';
    StringGrid1.Cells[1, 6] := 'AB1000006';
    StringGrid1.Cells[1, 7] := 'AB1000007';
    StringGrid1.Cells[1, 8] := 'AB1000008';
    StringGrid1.Cells[1, 9] := 'AB1000009';
    myTree := Tree.Create();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    StringGrid1.RowCount := StrToInt(Edit1.Text) + 1;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i, n: longint;
begin
    n := StringGrid1.RowCount - 1;
    for i := 1 to n do begin
        myTree.Add(StringGrid1.Cells[0, i], StringGrid1.Cells[1, i]);
    end;
    TreeView1.Items.Clear;
    myTree.Show(TreeView1, nil, nil);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    Memo1.Clear;
    myTree.WriteLinear(Memo1, nil);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    Memo1.Clear();
    myTree.WriteReverse(Memo1, nil);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    myTree.Destroy(nil);
    TreeView1.Items.Clear();
end;

procedure TForm1.Button3Click(Sender: TObject);
var n, i: longint;
begin
    n := StringGrid1.RowCount - 1;
    for i := 1 to n do begin
        myTree.Remove(nil, StringGrid1.Cells[0, i]);
    end;
    TreeView1.Items.Clear;
    myTree.Show(TreeView1, nil, nil);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
    myTree.Balance_all_tree(nil);
    TreeView1.Items.Clear;
    myTree.Show(TreeView1, nil, nil);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
    Edit3.Text := IntToStr(myTree.getWordsStartWithA(Edit2.Text, nil));
end;

end.
