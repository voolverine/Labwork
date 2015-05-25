unit Unit2;

interface

uses  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
          Dialogs, StdCtrls, Grids;

type

    RefToStackElement = ^StackElement;

    StackElement = record
        key: longint;
        value: string[50];
        previos: RefToStackElement;
    end;


    Stack = class(TObject)
        private
            { Private declarations }
            top: RefToStackElement;

        public
            { Public declarations }
            Constructor Create();
            procedure push_back(key: longint; value: string);
            procedure remove(to_delete: RefToStackElement);
            procedure showAll(Memo1: TMemo);
            function pop_back(): string; 
            function search(key: longint): RefToStackElement;
            function getCount(): longint;
    end;

    stacks = array[0..0] of Stack;
    StackArray = ^stacks;

    HashTable = class(TObject)
        private
            { Private declarations }
            M: longint;
            table: StackArray;
            function getKeyInTheTable(key: longint): longint;

        public
            { Public declarations }
            Constructor Create(temp_M: longint);
            procedure Add(key: longint; value: string);
            procedure ShowAll(Memo1: TMemo);
            procedure remove_all();
            function getElement(key: longint): string;
            function deleteElement(key: longint): string;
    end;

implementation

Constructor Stack.Create();
begin
    top := nil;
end;

procedure Stack.push_back(key: longint; value: string);
var new_element: RefToStackElement;
begin
    GetMem(new_element, sizeof(StackElement));
    new_element^.key := key;
    new_element^.value := value;
    new_element^.previos := top;
    top := new_element;
end;

function Stack.pop_back(): string;
begin
    remove(top);
end;

function Stack.search(key: longint): RefToStackElement;
var current: RefToStackElement;
begin
    current := top;
    while (current <> nil) do begin
        if (current^.key = key) then begin
            search := current;
            exit;
        end;
        current := current^.previos;
    end;
    search := nil;
end;

procedure Stack.remove(to_delete: RefToStackElement);
var current: RefToStackElement;
begin
    current := top;
    while (current <> to_delete) do begin
        if (current^.previos = to_delete) then begin
            current^.previos := to_delete^.previos;
        end;
    end;
    if (current = top) then begin
        top := current^.previos;
    end;
    FreeMem(current);
end;

Constructor HashTable.Create(temp_M: longint);
var i: longint;
begin
    M := temp_M;
    GetMem(table, sizeof(stacks) * M);
    for i := 0 to M - 1 do begin
        table[i] := Stack.Create;
    end;
end;

procedure HashTable.Add(key: longint; value: string);
var key_in_table: longint;
begin
    key_in_table := getKeyInTheTable(key);
    table[key_in_table].push_back(key, value);
end;

function HashTable.getKeyInTheTable(key: longint): longint;
var res: longint;
begin
    res := key mod M;
    while (res < 0) do begin
        inc(res, M);
    end;
    getKeyInTheTable := res;           
end;

function HashTable.getElement(key: longint): string;
var key_in_table: longint;
    res: RefToStackElement;
begin
    key_in_table := getKeyInTheTable(key);
    res := table[key_in_table].search(key);
    if (res = nil) then begin
        getElement := 'There is no such element in the Hash Table!';
    end
    else begin
        getElement := res^.value;
    end;
end;

function HashTable.deleteElement(key: longint): string;
var key_in_table: longint;
    res: RefToStackElement;
begin
    key_in_table := getKeyInTheTable(key);
    res := table[key_in_table].search(key);
    if (res = nil) then begin
        deleteElement := 'There is no such element in the Hash Table!';
    end
    else begin
        deleteElement := res^.value;
        table[key_in_table].remove(res);
    end;
end;

function Stack.getCount(): longint;
var current: RefToStackElement;
    res: longint;
begin
    res := 0;
    current := top;
    while (current <> nil) do begin
        inc(res);
        current := current^.previos;
    end;
    getCount := res;
end;

procedure Stack.showAll(Memo1: TMemo);
var current: RefToStackElement;
begin
    current := top;
    while (current <> nil) do begin
        Memo1.Lines.Add('     Key = ' + IntToStr(current^.key) + ' Value = ' + current^.value);
        current := current^.previos;
    end;
    Memo1.Lines.Add('');
end;

procedure HashTable.ShowAll(Memo1: TMemo);
var i: longint;
    count: longint;
begin
    Memo1.Clear;
    Memo1.Lines.Add('Основание хеширования = ' + IntToStr(M));
    Memo1.Lines.Add('');
    for i := 0 to M - 1 do begin
        count := table[i].getCount();
        if (count <> 0) then begin
            Memo1.Lines.Add('Размер стека номер ' + IntToStr(i) + ' равен ' + IntToStr(count));
            table[i].showAll(Memo1);
        end;
    end;
end;

procedure HashTable.remove_all();
var i, count: longint;
begin
    for i := 0 to M - 1 do begin
        count := table[i].getCount();
        while (count > 0) do begin
            table[i].pop_back();
            dec(count);
        end;
    end;
end;


end.
 