unit Unit2;

interface

uses SysUtils, Grids;

type

    RefToListElement = ^ListElement;

    ListElement = record
        value: longint;
        next, previos: RefToListELement;
    end;

    List = class(TObject)

    private
        { Private declarations }
        first, last: RefToListElement;
        size: longint;
        function createNewListElement(value: longint): RefToListElement;
        procedure deleteByRef(current: RefToListElement);

    public
        { Public declarations }
        Constructor Create();
        procedure push_back(value: longint);
        procedure print(StringGrid1: TStringGrid);
        procedure delete_iterations();
        procedure Destroy();

    end;
 
implementation


Constructor List.Create();
begin
    first := nil;
    last := nil;
    size := 0;
end;

procedure List.Destroy();
var current, to_delete: RefToListElement;
begin
    current := first;
    while (current <> nil) do begin
        to_delete := current;
        current := current^.next;
        FreeMem(to_delete);
    end;
    first := nil;
    last := nil;
    size := 0;
end;

function List.createNewListElement(value: longint): RefToListElement;
var new_element: RefToListElement;
begin
    GetMem(new_element, sizeof(ListElement));
    new_element^.value := value;
    new_element^.next := nil;
    new_element^.previos := nil;
    createNewListElement := new_element;
end;

procedure List.push_back(value: longint);
var new_element: RefToListElement;
begin
    new_element := createNewListElement(value);
    if (first = nil) then begin
        first := new_element;
    end;
    if (last <> nil) then begin
        last ^.next := new_element;
        new_element^.previos := last;
    end;
    last := new_element;
    inc(size);
end;

procedure List.print(StringGrid1: TStringGrid);
var current: RefToListELement;
    i: longint;
begin
    StringGrid1.ColCount := size;
    current := first;
    for i := 0 to size - 1 do begin
        StringGrid1.Cells[i, 0] := IntToStr(current^.value);
        current := current^.next;
    end;
end;

procedure List.deleteByRef(current: RefToListElement);
begin
    if (size = 1) then begin
        FreeMem(current);
        first := nil;
        last := nil;
    end
    else begin
        if (current = first) then begin
            current^.next^.previos := nil;
            first := current^.next;
            FreeMem(current);
        end
        else begin
            if (current = last) then begin
                current^.previos^.next := nil;
                last := current^.previos;
                FreeMem(current);
            end
            else begin
                current^.previos^.next := current^.next;
                current^.next^.previos := current^.previos;
                FreeMem(current);
            end;
        end;
    end;
    dec(size);
end;

procedure List.delete_iterations();
var i, j: longint;
    current, to_delete: RefToListElement;
begin
    if (size = 1) then begin
        exit;
    end;
    current := first;

    while ((current <> nil) and (current^.next <> nil)) do begin
        to_delete := current^.next;
        while (to_delete <> nil) do begin
            if (current^.value = to_delete^.value) then begin
                to_delete := to_delete^.previos;
                deleteByRef(to_delete^.next);
            end;
            to_delete := to_delete^.next;
        end;
        current := current^.next;
    end;
end;

end.
 