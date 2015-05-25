unit Unit2;


interface
uses Grids, SysUtils;

type

    RefToStackElement = ^StackElement;

    StackElement = record
        value: extended;
        previos: RefToStackElement;
    end;

    Stack = class(TObject)

    private
        { Private declarations }
        size: longint;
        recent_element: RefToStackElement;
        procedure destroy_recent_stack_element();
        procedure swap(first, second: longint);
        function make_new_stack_element(temp: extended): RefToStackElement;
        function getValueById(id: longint): extended;
        function getRefById(id: longint): RefToStackElement;

    public
        { Public declarations }
        Constructor Create();
        procedure Destroy();
        procedure push_back(temp: extended);
        procedure bubble_sort();
        procedure print(StringGrid1: TStringGrid);
        procedure swapExtremuls();
        function pop_back(): extended;

    end;

implementation

Constructor Stack.Create();
begin
    size := 0;
    recent_element := nil;
end;

procedure Stack.swapExtremuls();
var max_pos, min_pos, i: longint;
    maxx, minn: extended;
    current: RefToStackElement;
begin
    maxx := -100000;
    minn := 100000;
    
    current := recent_element;
    
    for i := 1 to size do begin
        if (current^.value > maxx) then begin
            maxx := current^.value;
            max_pos := i;
        end;
        if (current^.value < minn) then begin
            minn := current^.value;
            min_pos := i;
        end;
        current := current^.previos;
    end;

    swap(min_pos, max_pos);
end;

procedure Stack.Destroy();
begin
    while(size > 0) do begin
        pop_back();
    end;
end;

function Stack.make_new_stack_element(temp: extended): RefToStackElement;
var new_stack_element: RefToStackElement;
begin
    GetMem(new_stack_element, sizeof(StackElement));
    new_stack_element^.value := temp;
    new_stack_element^.previos := recent_element;
    make_new_stack_element := new_stack_element;
end;

procedure Stack.destroy_recent_stack_element();
var previous_stack_element: RefToStackElement;
begin
    previous_stack_element := recent_element^.previos;
    FreeMem(recent_element, sizeof(StackElement));
    recent_element := previous_stack_element;
end;

procedure Stack.push_back(temp: extended);
begin
    recent_element := make_new_stack_element(temp);
    inc(size);
end;

function Stack.pop_back(): extended;
begin
    pop_back := recent_element^.value;
    destroy_recent_stack_element();
    dec(size);
end;

function Stack.getValueById(id: longint): extended;
var current: RefToStackElement;
    i: longint;
begin
    current := recent_element;
    i := 1;
    while (i < id) do begin
        current := current^.previos;
        inc(i);
    end;

    getValueById := current^.value;
end;

function Stack.getRefById(id: longint): RefToStackELement;
var current: RefToStackElement;
    i: longint;
begin
    current := recent_element;
    i := 1;
    while (i < id) do begin
        current := current^.previos;
        inc(i);
    end;

    getRefById := current;
end;

procedure Stack.swap(first, second: longint);
var i: longint;
    current, first_ref, second_ref, temp_ref: RefToStackElement;
begin
    first_ref := getRefById(first);
    second_ref := getRefById(second);

    temp_ref := first_ref^.previos;
    first_ref^.previos := second_ref^.previos;
    second_ref^.previos := temp_ref;

    if (first_ref^.previos = first_ref) then begin
        first_ref^.previos := second_ref;
    end;
    if (second_ref^.previos = second_ref) then begin
        second_ref^.previos := first_ref;
    end;
    if (recent_element = second_ref) then begin
        recent_element := first_ref;
    end else begin
        if (recent_element = first_ref) then begin
            recent_element := second_ref;
        end;
    end;

    current := recent_element;
    i := 1;
    while (i < size) do begin
        if ((current^.previos = first_ref) and (current <> second_ref)) then begin
            current^.previos := second_ref;
        end else begin
                if ((current^.previos = second_ref) and (current <> first_ref)) then begin
                    current^.previos := first_ref;
                end;
        end;
        inc(i);
        current := current^.previos;
    end;
end;

procedure Stack.bubble_sort();
var i, j: longint;
begin
    for i := 1 to size do begin
        for j := i + 1 to size do begin
            if (getValueById(i) > getValueById(j)) then begin
                swap(i, j);
            end;
        end;
    end;
end;

procedure Stack.print(StringGrid1: TStringGrid);
var current: RefToStackElement;
    i: longint;
begin
    current := recent_element;
    StringGrid1.ColCount := size;
    StringGrid1.RowCount := 1;
    for i := 1 to size do begin
        StringGrid1.Cells[i - 1, 0] := FloatToStrF(current^.value, fffixed, 8, 4);
        current := current^.previos;
    end;
end;

end.
