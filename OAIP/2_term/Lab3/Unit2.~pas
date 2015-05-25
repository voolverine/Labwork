unit Unit2;

interface
  uses Math, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TStudent = record
      initials: string[30];
      adress: string[30];
      ball: extended;
  end;

  studentClass = class(TObject)
    public studentList: array of TStudent;

    public procedure readFromFile();
    public procedure writeToFile();
    public procedure writeToMemo(Memo1: TMemo; all: boolean);
    public procedure buttonAddClicked(initials: string; adress: string; ball: extended);
    public procedure buttonDeleteClicked(initials: string);
    Constructor Create();

    private function compareInitials(initials1: string; initials2: string): longint;
    private function searchStudent(initials: string): longint;
    private procedure deleteStudentFromLocal(initials: string);
    private procedure addStudentToLocal(tempStudent: TStudent);
    private procedure swapLocalElements(var student1: TStudent; var student2: TStudent);
    private procedure clearLocal();
    private procedure sortStudents(l, r: longint);
  end;

implementation

  procedure studentClass.readFromFile();
  var listOfStudents: File of TStudent;
      tempStudent: TStudent;
  begin
    assignFile(listOfStudents, 'dataBase.dat');
    reset(listOfStudents);
    clearLocal();

    while (not eof(listOfStudents)) do
      begin
        read(listOfStudents, tempStudent);
        addStudentToLocal(tempStudent);
      end;
    closeFile(listOfStudents);
  end;

  procedure studentClass.writeToFile();
  var i: longint;
      listOfStudents: File of TStudent;
  begin
      assignFile(listOfStudents, 'dataBase.dat');
      rewrite(listOfStudents);
      sortStudents(0, length(studentList) - 1);

      for i := 0 to length(StudentList) - 1 do
        write(listOfStudents, studentList[i]);

      closeFile(listOfStudents);
  end;

  procedure studentClass.writeToMemo(Memo1: TMemo; all: boolean);
  var i: longint;
  begin
    if (length(studentList) = 0)
    then readFromFile();
    Memo1.Clear();
    sortStudents(0, length(studentList) - 1);

    for i := 0 to length(studentList) - 1 do
      if (all)
      then Memo1.Lines.Add(studentList[i].initials + ' ' + studentList[i].adress + ' ' + FloatToStrF(studentList[i].ball, fffixed, 8, 2))
      else if ((studentList[i].ball >= 4.5) and (studentList[i].adress = 'г.Минск'))
           then Memo1.Lines.Add(studentList[i].initials + ' ' + studentList[i].adress + ' ' + FloatToStrF(studentList[i].ball, fffixed, 8, 2));
  end;

  procedure studentClass.deleteStudentFromLocal(initials: string);
  var pos, i: longint;
  begin
    pos := searchStudent(initials);
    if (compareInitials(studentList[pos].initials, initials) <> 0)
    then exit;

    for i := pos to length(studentList) - 2 do
      studentList[i] := studentList[i + 1];

    SetLength(studentList, length(studentList) - 1);
  end;

  procedure studentClass.buttonAddClicked(initials: string; adress: string; ball: extended);
  var tempStudent: TStudent;
  begin
    tempStudent.initials := initials;
    tempStudent.adress := adress;
    tempStudent.ball := ball;
    addStudentToLocal(tempStudent);
    writeToFile();
  end;

  procedure studentClass.buttonDeleteClicked(initials: string);
  begin
    deleteStudentFromLocal(initials);
    writeToFile();
  end;

  constructor studentClass.Create();
  begin
    SetLength(studentList, 0);
    readFromFIle();
  end;

  function studentClass.compareInitials(initials1: string; initials2: string): longint;
  var minLength, i: longint;
  begin
    minLength := min(length(initials1), length(initials2));
    for i := 1 to minLength do
      begin
        if (initials1[i] < initials2[i])
        then begin
              compareInitials := 1;
              exit;
        end;
        if (initials1[i] > initials2[i])
        then begin
              compareInitials := -1;
              exit;
        end;
      end;

    if (length(initials1) < length(initials2))
    then begin
          compareInitials := 1;
          exit;
    end;
    if (length(initials1) > length(initials2))
    then begin
          compareInitials := -1;
          exit;
    end;
    compareInitials := 0;
  end;

  function studentClass.searchStudent(initials: string): longint;
  var l, r, mid, check: longint;
  begin
    l := 0;
    r := length(studentList) - 1;
    sortStudents(l, r);
    while (l < r) do
      begin
        mid := (l + r) div 2;
        check := compareInitials(studentList[mid].initials, initials);
        if (check = 0)
        then begin
              searchStudent := mid;
              exit;
        end;
        if (check = -1)
        then r := mid - 1
        else l := mid + 1;
      end;
    searchStudent := l;
  end;

  procedure studentClass.addStudentToLocal(tempStudent: TStudent);
  begin
    SetLength(studentList, length(studentList) + 1);
    studentList[length(studentList) - 1] := tempStudent;
  end;

  procedure studentClass.swapLocalElements(var student1: TStudent; var student2: TStudent);
  var tempStudent: TStudent;
  begin
    tempStudent := student1;
    student1 := student2;
    student2 := tempStudent;
  end;

  procedure  studentClass.clearLocal();
  begin
    SetLength(studentList, 0);
  end;

  procedure studentClass.sortStudents(l, r: longint);
  var mid, i, j: longint;
  begin
    mid := (l + r) div 2;
    i := l;
    j := r;
    repeat
        while (compareInitials(studentList[i].initials, studentList[mid].initials) = 1) do
          begin
            inc(i);
          end;
        while (compareInitials(studentList[mid].initials, studentList[j].initials) = 1) do
          begin
            dec(j);
          end;

        if (i <= j)
        then begin
              swapLocalElements(studentList[i], studentList[j]);
              inc(i);
              dec(j);
        end;
    until (i >= j);

    if (l < j)
    then sortStudents(l, j);
    if (i < r)
    then sortStudents(i, r);
  end;


end.
