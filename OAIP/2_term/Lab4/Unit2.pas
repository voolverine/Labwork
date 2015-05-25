unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Math;

type

    TStudent = record
        initials: string[50];
        city: string[20];
        rating: extended;
    end;

    RefListElem = ^ListElem;

    ListElem = record
        student: TStudent;
        next: RefListElem;
        prev: RefListElem;
    end;

    List = class(TObject)
    public
        first: RefListElem;
        last: RefListElem;
        count: longint;
        constructor Create();
        procedure Add(student: TStudent);
        procedure showAllInTheCurrentMemo(Memo1: TMemo);
        procedure showZadrotsInTheCurrentMemo(Memo1: TMemo);
        procedure TryToDelete(student: TStudent);
        procedure TryToSortInArray(l, r: longint);
        procedure ReadFromDataBase();
        procedure RewriteDataBase();

    private
        function CreateNewListElement(student: TStudent): RefListElem;
        function FindStudent(student: TStudent): RefListElem;
        function lower_bound(l, r: longint; student: TStudent): RefListElem;
        function compareInitials(person1: string; person2: string): boolean;
        function WhosNameBigger(i1: string; i2: string): boolean;
        function getIdInitials(id: longint): string;
        procedure deleteElement(current: RefListElem);
        procedure sort(var a: array of TStudent; l, r: longint);
        procedure swap(var p1: TStudent; var p2: TStudent);
        procedure DestroyList();

    end;

var database: string;

implementation

constructor List.Create();
begin
    first := nil;
    last := nil;
    count := 0;
end;

function List.getIdInitials(id: longint): string;
var current: RefListElem;
    i: longint;
begin
    current := first;
    for i := 1 to count do begin
        if (i = id) then begin
            break;
        end;
        current := current^.next;
    end;

    getIdInitials := current^.student.initials;
end;

function List.lower_bound(l, r: longint; student: TStudent): RefListElem;
var mid: longint;
    i: longint;
    current: RefListElem;
begin
    while (l < r) do begin
        mid := (l + r + 1) div 2;
        if (WhosNameBigger(getIdInitials(mid), student.initials) = true) then begin
            r := mid - 1;
        end else begin
            l := mid;
        end;
    end;

    if (getIdInitials(l) = student.initials) then begin
        current := first;
        for i := 1 to count do begin
            if (i = l) then begin
                break;
            end;
            current := current^.next;
        end;
        
        lower_bound := current;
    end else begin
        lower_bound := nil;
    end;
end;

function List.CreateNewListElement(student: TStudent): RefListElem;
var new_element: ListElem;
begin
    new_element.student := student;
    new_element.next := nil;
    new_element.prev := last;
    GetMem(result, sizeof(ListElem));
    result^ := new_element;
end;

procedure List.Add(student: TStudent);
var new_element: refListElem;
begin
    new_element := CreateNewListElement(student);

    if (count <> 0) then
    begin
        last^.next := new_element;
    end else begin
        first := new_element;
        last := new_element;
    end;

    last := new_element;
    inc(count);
end;

procedure List.showZadrotsInTheCurrentMemo(Memo1: TMemo);
var I: longint;
    current: refListElem;
begin
    Memo1.Clear();
    current := first;
    for i := 1 to count do begin
        if ((current^.student.rating >= 4.5) and (current^.student.city = 'Минск')) then
            Memo1.Lines.Add(current^.student.initials + ' ' + current^.student.city + ' ' + FloatToStrF(current^.student.rating, fffixed, 8, 8));
        current := current^.next;
    end;
end;

procedure List.showAllInTheCurrentMemo(Memo1: TMemo);
var I: longint;
    current: refListElem;
begin
    Memo1.Clear();
    current := first;
    for i := 1 to count do begin
        Memo1.Lines.Add(current^.student.initials + ' ' + current^.student.city + ' ' + FloatToStrF(current^.student.rating, fffixed, 8, 8));
        current := current^.next;
    end;
end;

procedure List.deleteElement(current: RefListElem);
begin
    dec(count);
    if (current = first) then
    begin
        first := current^.next;
        if (first <> nil) then
        begin
            first^.prev := nil;
        end;
        FreeMem(current);
        exit;
    end;
    if (current = last) then
    begin
        last := current^.prev;
        if (last <> nil) then
        begin
            last^.next := nil;
        end;
        FreeMem(current);
        exit;
    end;
    (current^.next)^.prev := current.prev;
    (current^.prev)^.next := current.next;
    FreeMem(current);
end;

function List.compareInitials(person1: string; person2: string): boolean;
var i: longint;
begin
    if (length(person1) <> length(person2)) then
    begin
        compareInitials := false;
        exit;
    end;
    for i := 1 to length(person1) do begin
        if (person1[i] <> person2[i]) then begin
            compareInitials := false;
            exit;
        end;
    end;
    compareInitials := true;
end;


function List.FindStudent(student: TStudent): RefListElem;
var i: longint;
    current: RefListElem;
begin
    FindStudent := lower_bound(1, count, student);
end;

procedure List.TryToDelete(student: TStudent);
var position: RefListElem;
begin
    position := FindStudent(student);
    if (position = nil) then begin
        ShowMessage('There is no such element in the list!');
        exit;
    end;

    deleteElement(position);
end;

procedure List.swap(var p1: TStudent; var p2: TStudent);
var temp: TStudent;
begin
    temp := p1;
    p1 := p2;
    p2 := temp;
end;

function List.WhosNameBigger(i1: string; i2: string): boolean;
var i: longint;
begin

    for i := 1 to min(length(i1), length(i2)) do begin
        if (i1[i] > i2[i]) then begin
            WhosNameBigger := true;
            exit;
        end;
        if (i1[i] < i2[i]) then begin
            WhosNameBigger := false;
            exit;
        end;
    end;

    WhosNameBigger := false;
end;

procedure List.sort(var a: array of TStudent; l, r: longint);
var i, j: longint;
    mid: string;
begin
    i := l;
    j := r;
    mid := a[(i + j) div 2].initials;
    repeat
        while (WhosNameBigger(mid, a[i].initials) = true) do
            inc(i);
        while (WhosNameBigger(a[j].initials, mid) = true) do
            dec(j);
        if (i <= j) then begin
            swap(a[i], a[j]);
            inc(i);
            dec(j);
        end;
    until i >= j;

    if (l < j) then
        sort(a, l, j);
    if (i < r) then
        sort(a, i, r);
end;

procedure List.TryToSortInArray(l, r: longint);
var current: RefListElem;
    p: array of TStudent;
    i: longint;
begin
    current := first;
    SetLength(p, 1);
    for i := 1 to count do begin
        if ((i >= l) and (i <= r)) then begin
            SetLength(p, length(p) + 1);
            p[length(p) - 1] := current^.student;
        end;
        current := current^.next;
    end;

    sort(p, l, r);
    
    current := first;
    for i := 1 to count do begin
        if ((i >= l) and (i <= r)) then begin
            current^.student := p[i - l + 1];
        end;
        current := current^.next;
    end;
end;

procedure List.DestroyList();
var current, temp: RefListElem;
    i: longint;
begin
    current := first;
    for i := 1 to count do begin
        temp := current;
        current := current^.next;
        FreeMem(temp);
    end;

    count := 0;
    first := nil;
    last := nil;
end;

procedure List.ReadFromDataBase();
var f: file of TStudent;
    temp: TStudent;
begin
    AssignFile(f, database);
    DestroyList();
    Reset(f);

    while (not eof(f)) do begin
        read(f, temp);
        Add(temp);
    end;

    CloseFile(f);
end;

procedure List.RewriteDataBase();
var f: file of TStudent;
    current: RefListElem;
    i, j: longint;
begin
    AssignFile(f, database);
    Rewrite(f);

    current := first;

    for i := 1 to count do begin
        write(f, current^.student);
        current := current^.next;
    end;

    CloseFile(f);
end;

end.
