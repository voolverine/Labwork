unit Unit2;

interface

uses Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
      Dialogs, StdCtrls, ComCtrls, Grids, Math;

type

    RefToNode = ^node;

    node = record
        value, key: string[80];
        height: longint;
        left, right: RefToNode;
    end;


    Tree = class(TObject)
        private
            { Private declarations }
            root: RefToNode;
            function get_balance(p: RefToNode): longint;
            function cmp(s1, s2: string): boolean;
            function insert(current, p: RefToNode): RefToNode;
            function find_min(current: RefToNode): RefToNode;
            function remove_min(current: RefToNode): RefToNode;
            function rotateleft(current: RefToNode): RefToNode;
            function rotateright(current: RefToNode): RefToNode;
            function Balance(current: RefToNode): RefToNode;
            function ifStartEquals(s1, s2: string): longint;            
            procedure fixheight(current: RefToNode);

        public
            { Public declarations }
            Constructor Create();
            procedure Destroy(current: RefToNode);
            procedure Add(new_key, new_value: string);
            procedure Show(TreeView1: TTreeView; current: RefToNode; previos: TTreeNode);
            procedure WriteLinear(Memo1: TMemo; current: RefToNode);
            procedure WriteReverse(Memo1: TMemo; current: RefToNode);
            procedure Balance_all_tree(current: RefToNode);
            function Remove(current: RefToNode; key: string): RefToNode;
            function getWordsStartWithA(s: string; current: RefToNode): longint;

    end;

implementation

Constructor Tree.Create;
begin
    root := nil;
end;

procedure Tree.Destroy(current: RefToNode);
begin
    if (current = nil) then begin
        current := root;
        root := nil;
    end;
    if (current^.left <> nil) then begin
        Destroy(current^.left);
    end;
    if (current^.right <> nil) then begin
        Destroy(current^.right);
    end;
    FreeMem(current);
end;

function Tree.get_balance(p: RefToNode): longint;
var hl, hr: longint;
begin
    hl := 0;
    hr := 0;
    if (p^.left <> nil) then begin
        hl := p^.left^.height;
    end;
    if (p^.right <> nil) then begin
        hr := p^.right^.height;
    end;
    get_balance := hr - hl;
end;

procedure Tree.fixheight(current: RefToNode);
var hl, hr: longint;
begin
    hl := 0;
    hr := 0;
    if (current^.left <> nil) then begin
        hl := current^.left^.height;
    end;
    if (current^.right <> nil) then begin
        hr := current^.right^.height;
    end;
    current^.height := max(hr, hl) + 1;
end;

function Tree.cmp(s1, s2: string): boolean;
var i: longint;
begin
    for i := 1 to min(length(s1), length(s2)) do begin
        if (s1[i] < s2[i]) then begin
            cmp := true;
            exit;
        end;
        if (s1[i] > s2[i]) then begin
            cmp := false;
            exit;
        end;
    end;

    if (length(s1) <= length(s2)) then begin
        cmp := true;
    end
    else begin
        cmp := false;
    end;
end;


function Tree.insert(current, p: RefToNode): RefToNode;
begin
    if (current = nil) then begin
        insert := p;
        exit;
    end;
    if (cmp(p^.key, current^.key)) then begin
        current^.left := insert(current^.left, p);
    end
    else begin
        current^.right := insert(current^.right, p);
    end;
    insert := current;
end;

procedure Tree.Add(new_key, new_value: string);
var new_element, current: RefToNode;
begin
    GetMem(new_element, sizeof(node));
    new_element^.key := new_key;
    new_element^.value := new_value;
    new_element^.left := nil;
    new_element^.right := nil;
    new_element^.height := 1;
    if (root = nil) then begin
        root := new_element;
    end
    else begin
        current := root;
        insert(root, new_element);
    end;
end;

procedure Tree.Show(TreeView1: TTreeView; current: RefToNode; previos: TTreeNode);
begin
    if (previos = nil) then begin
        if (root = nil) then begin
            exit;
        end;
        current := root;
        previos := TreeView1.Items.AddFirst(nil, current^.key + ' ' + current^.value);
    end
    else begin
        previos := TreeView1.Items.AddChildFirst(previos, current^.key + ' ' + current^.value);
    end;

    if (current^.right <> nil) then begin
        Show(TreeView1, current^.right, previos);
    end;
    if (current^.left <> nil) then begin
        Show(TreeView1, current^.left, previos);
    end;
    TreeView1.FullExpand();

end;

procedure Tree.WriteLinear(Memo1: TMemo; current: RefToNode);
begin
    if (current = nil) then begin
        current := root;
    end;

    Memo1.Lines.Add(current^.key + ' ' + current^.value);
    if (current^.left <> nil) then begin
        WriteLinear(Memo1, current^.left);
    end;
    if (current^.right <> nil) then begin
        WriteLinear(Memo1, current^.right);
    end;
end;

procedure Tree.WriteReverse(Memo1: TMemo; current: RefToNode);
begin
    if (current = nil) then begin
        current := root;
    end;

    if (current^.left <> nil) then begin
        WriteReverse(Memo1, current^.left);
    end;
    if (current^.right <> nil) then begin
        WriteReverse(Memo1, current^.right);
    end;
    Memo1.Lines.Add(current^.key + ' ' + current^.value);
end;

function Tree.remove_min(current: RefToNode): RefToNode;
begin
    if (current^.left = nil) then begin
        remove_min := current^.right;
        exit;
    end;
    current^.left := remove_min(current^.left);
    remove_min := current;
end;

function Tree.find_min(current: RefToNode): RefToNode;
begin
    if (current^.left = nil) then begin
        find_min := current;
        exit;
    end;
    find_min := find_min(current^.left);
end;

function Tree.Remove(current: RefToNode; key: string): RefToNode;
var left, right, min: RefToNode;
begin
    if (current = nil) then begin
        current := root;
    end;

    if (cmp(key, current^.key)) then begin
        if (cmp(current^.key, key)) then begin
            left := current^.left;
            right := current^.right;
            FreeMem(current);
            if (right = nil) then begin
                if (root = current) then begin
                    root := left;
                end;
                Remove := left;
                exit;
            end;

            min := find_min(right);
            min^.right := remove_min(right);
            min^.left := left;
            if (root = current) then begin
                    root := min;
            end;
            Remove := min;
            exit;
        end else begin
            if (current^.left <> nil) then begin
                 current^.left := Remove(current^.left, key);
            end;
        end;
    end
    else begin
        if (current^.right <> nil) then begin
            current^.right := Remove(current^.right, key);
        end;
    end;
    Remove := current;
end;

function Tree.rotateleft(current: RefToNode): RefToNode;
var right: RefToNode;
begin
    right := current^.right;
    current^.right := right^.left;
    right^.left := current;
    fixheight(current);
    fixheight(right);
    rotateleft := right;
end;

function Tree.rotateright(current: RefToNode): RefToNode;
var left: RefToNode;
begin
    left := current^.left;
    current^.left := left^.right;
    left^.right := current;
    fixheight(current);
    fixheight(left);
    rotateright := left;
end;

function Tree.Balance(current: RefToNode): RefToNode;
begin
    fixheight(current);
    if (get_balance(current) = 2) then begin
        if (get_balance(current^.right) < 0) then begin
            current^.right := rotateright(current^.right);
        end;
        current := rotateleft(current);
    end;

    if (get_balance(current) = -2) then begin
        if (get_balance(current^.left) > 0) then begin
            current^.left := rotateleft(current^.left);
        end;
        current := rotateright(current);
    end;

    Balance := current;
end;

procedure Tree.Balance_all_tree(current: RefToNode);
begin
    if (current = nil) then begin
        current := root;
        if (current = nil) then begin
            exit;
        end;
    end;
    if (current^.left <> nil) then begin
        Balance_all_tree(current^.left);
        current^.left := Balance(current^.left);
    end;
    if (current^.right <> nil) then begin
        Balance_all_tree(current^.right);
        current^.right := Balance(current^.right);
    end;
end;

function Tree.ifStartEquals(s1, s2: string): longint;
var i: longint;
    f: boolean;
begin
    f := true;
    for i := 1 to min(length(s1), length(s2)) do begin
        if (s1[i] <> s2[i]) then begin
            f := false;
        end;
    end;

    if (f) then begin
        ifStartEquals := 1;
    end
    else begin
        ifStartEquals := 0;
    end;
end;

function Tree.getWordsStartWithA(s: string; current: RefToNode): longint;
var count: longint;
begin
    if (current = nil) then begin
        current := root;
    end;

    count := ifStartEquals(s, current^.key);

    if ((current^.right <> nil) and ((cmp(current^.key, s)) or (count = 1))) then begin
        count := count + getWordsStartWithA(s, current^.right);
    end;

    if ((current^.left <> nil) and (cmp(s, current^.key))) then begin
        count := count + getWordsStartWithA(s, current^.left);
    end;

    getWordsStartWithA := count;
end;

end.
