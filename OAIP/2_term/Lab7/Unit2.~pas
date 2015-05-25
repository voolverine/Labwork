unit Unit2;

interface

uses Math;

type
    RefToStackElement = ^StackElement;

    StackElement = record
        value: char;
        previos: RefToStackElement;
    end;

    Stack = class(TObject)

        private
            { Private declarations }
            last: RefToStackElement;
            function createNewStackElement(value: char): RefToStackElement;

        public
            { Public declarations }
            Constructor Create();
            procedure push_back(value: char);
            function pop_back(): char;
            function top(): char;
            function empty(): boolean;
    end;

    calc = class(TObject)

        private
            { Private declarations }
            operates: set of char;
            postfix_form: string;
            function get_priority(c: char): longint;

        public
            { Public declarations }
            values: array['a'..'ÿ'] of extended;
            function transform_in_rpr(s: string): string;
            function get_result(): extended;
            Constructor Create();
    end;


implementation

Constructor Stack.Create();
begin
    last := nil;
end;

function Stack.empty(): boolean;
begin
    if (last = nil) then begin
        empty := true;
    end
    else begin
        empty := false;
    end;
end;

function Stack.top(): char;
begin
    if (last <> nil) then begin
        top := last^.value;
    end
    else begin
        top := '#';
    end;
end;

function Stack.createNewStackElement(value: char): RefToStackElement;
var new_element: RefToStackElement;
begin
    GetMem(new_element, sizeof(StackElement));
    new_element^.value := value;
    new_element^.previos := last;
    createNewStackElement := new_element;
end;

procedure Stack.push_back(value: char);
var new_element: RefToStackElement;
begin
    new_element := createNewStackElement(value);
    last := new_element;
end;

function Stack.pop_back(): char;
var previos: RefToStackElement;
begin
    pop_back := last^.value;
    previos := last^.previos;
    FreeMem(last);
    last := previos;
end;

Constructor calc.Create();
var i: longint;
begin
    operates := ['-', '+', '*', '/', '^', '(', ')'];

    postfix_form := '';
end;

function calc.get_priority(c: char): longint;
begin
    if ((c = '(') or (c = ')')) then begin
        get_priority := 0;
    end;
    if ((c = '+') or (c = '-')) then begin
        get_priority := 1;
    end;
    if ((c = '*') or (c = '/')) then begin
        get_priority := 2;
    end;
    if (c = '^') then begin
        get_priority := 3;
    end;
end;

function calc.transform_in_rpr(s: string): string;
var i: longint;
    myStack: Stack;
begin
    postfix_form := '';
    myStack := Stack.Create();

    for i := 1 to length(s) do begin
        if  (not(s[i] in operates)) then begin
            postfix_form := postfix_form + s[i];
        end
        else begin

            if (myStack.empty = true) then begin
                myStack.push_back(s[i]);
            end
            else begin

                if (s[i] = '(') then begin
                    myStack.push_back(s[i]);
                end
                else begin

                    if (s[i] = ')') then begin
                        while (myStack.top() <> '(') do begin
                            postfix_form := postfix_form + myStack.pop_back();
                        end;
                        if (not(myStack.empty)) then begin
                            myStack.pop_back();
                        end;
                    end
                    else begin

                        while (not(myStack.empty())
                                and (get_priority(s[i]) <= get_priority(myStack.top()))) do begin
                            postfix_form := postfix_form + myStack.pop_back();
                        end;
                        myStack.push_back(s[i]);
                    end;

                end;
            end;

        end;
    end;

    while (not(myStack.empty())) do begin
        postfix_form := postfix_form + myStack.pop_back();
    end;

    myStack.Free();
    transform_in_rpr := postfix_form;
end;

function calc.get_result(): extended;
var value1, value2, temp_result: extended;
    myStack: Stack;
    i: longint;
    st: char;
begin
    if (postfix_form = '') then begin
        exit;
    end;

    myStack := Stack.Create;
    st := Succ('z');
    for i := 1 to length(postfix_form) do begin
        if (not(postfix_form[i] in operates)) then begin
            myStack.push_back(postfix_form[i]);
        end
        else begin
            value2 := values[myStack.pop_back()];
            value1 := values[myStack.pop_back()];

            case (postfix_form[i]) of
                '+': temp_result := value1 + value2;
                '-': temp_result := value1 - value2;
                '*': temp_result := value1 * value2;
                '/': temp_result := value1 / value2;
                '^': temp_result := power(value1, value2);
            end;
            values[st] := temp_result;
            myStack.push_back(st);
            inc(st);
        end;
    end;

    get_result := values[myStack.pop_back()];
    myStack.Free();
end;

end.
