using System;
using System.Collections;
using System.Collections.Generic;

class Question
{
    private string question;
    private int answer;
    private List<string> answers;

    public int Answer
    {
        set {answer = value;}
    }

    public string Q 
    {
        set {question = value;}
        get {return question;}
    }

    public string this[int index] 
    {
        get {return answers[index];}
    }



    public Question(string question) 
    {
        Add_possible_answer("I don't know ;(");
        Answer = 0;
        Q = question; 
    }

    public Question(string question, List<string> possible_answers, int answer) 
    {
        Add_possible_answer("I don't know ;("); 
        Answer = answer;
        Q = question;
        foreach (string ans in possible_answers) 
        {
            Add_possible_answer(ans);
        }
    }

    public void Add_possible_answer(string possible_answer) 
    {
        answers.Add(possible_answer);
    }

    public bool remove_possible_answer(int index) 
    {
        index--;
        if (index <= 0 || index >= answers.Count || index == answer) 
        {
            return false;
        }
        if (index < answer) 
        {
            answer--;
        }

        
        answers.RemoveAt(index);
        return true;
    }

    public void show_question()
    {
        Console.WriteLine(Question); 
        int i = 0;

        foreach (string ans in answers) 
        {
            i++;
            Console.WriteLine("\t{0}) {1}", i, ans);        
        }
    }

    public int ShowMenuAndWait() 
    {
        Console.WriteLine("\n-------QuestionEditor-------\n");
        Console.WriteLine("1 - show question");
        Console.WriteLine("2 - add new possible answer");
        Console.WriteLine("3 - remove possible answer");
        Console.WriteLine("4 - change right answer");
        Console.WriteLine("5 - return to TestEditor");
        Console.WriteLine("-------QuestionEditor-------\n");

        return Int32.Parse(Console.ReadLine());
    }

    public void Edit() 
    {
        while (true) 
        {
            int what_to_do = ShowMenuAndWait();
            switch (what_to_do) 
            {
                case 1:
                    show_question();
                    break;

                case 2:
                    Add_possible_answer(Console.ReadLine());
                    break;

                case 3:
                    bool f = remove_possible_answer(Int32.Parse(Console.ReadLine()));
                    if (!f) 
                    {
                        Console.WriteLine("Something going wrong ;( Try again please\n");
                    }
                    break;

                case 4:
                    int new_ans = Int32.Parse(Console.ReadLine());
                    if (new_ans >= 0 && new_ans < answers.Count) 
                    {
                        Answer = new_ans;
                    } else 
                    {
                         Console.WriteLine("Something going wrong ;( Try again please\n");
                    }
                    break;

                case 5:
                    return;
                    break;

                default:
                    Console.WriteLine("Something going wrong ;( Try again please\n");
                    break;
            }
        }
    }


    IEnumerator IEnumerable.GetEnumerator() 
    {
        return GetEnumerator();
    }

    public IEnumerator GetEnumerator() 
    {
        foreach (string ans in answers) 
        {
            yield return ans;
        }
    }
}

class Test : IEnumerable 
{
    private string name;
    private List<Question> questions;
   

    public string Name 
    {
        get {return name;}
        set {name = value;}
    }

    public Test(string name) 
    {
        Name = name;
    }

    public void AddQuestion(Question new_question) 
    {
        questions.Add(new_question);
    }

    public bool RemoveQuestion(int index) 
    {
        index--;
        if (index < 0 && index >= questions.Count) 
        {
            return false;
        }

        questions.RemoveAt(index);
        return true;
    }

    public void ShowQuestions() 
    {
        int i = 0;
        foreach (Question question in questions) 
        {
            i++;
            Console.WriteLine("{0}. ", question.Q);
        }
    }


    public int ShowMenuAndWait() 
    {
        Console.WriteLine("\n-------TestEditor-------\n");
        Console.WriteLine("1 - add question");
        Console.WriteLine("2 - remove question");
        Console.WriteLine("3 - edit question");
        Console.WriteLine("4 - show all questions");
        Console.WriteLine("5 - return to TextManager");
        Console.WriteLine("-------TestEditor-------\n");
        return Int32.Parse(Console.ReadLine());
    }

    public void Edit() 
    {
        while (true) 
        {
            int what_to_do = ShowMenuAndWait();
            switch (what_to_do) 
            {
                case 1:
                    Console.WriteLine("Print Question");
                    AddQuestion(new Question(Console.ReadLine()));
                    break;

                case 2:
                    ShowQuestions();
                    Console.WriteLine("Print Question Number");
                    bool f = RemoveQuestion(Int32.Parse(Console.ReadLine()));
                    if (!f) 
                    {
                        Console.WriteLine("Something going wrong ;( Try again please\n");
                    }

                    break;

                case 3:
                    ShowQuestions();
                    Console.WriteLine("Print Question Number");
                    int question_num = Int32.Parse(Console.ReadLine());
                    if (question_num >= 0 && question_num <= questions.Count) 
                    {
                        questions[question_num].Edit();
                    } else 
                    {
                        Console.WriteLine("Something going wrong ;( Try again please\n");
                    }
                    break;

                case 4:
                    ShowQuestions();
                    break;

                case 5:
                    return;
                    break;

                default:
                    Console.WriteLine("Something going wrong ;( Try again please\n");
                    break;
            }
        }

    }


    IEnumerator IEnumerable.GetEnumerator() 
    {
        return GetEnumerator();
    }

    public IEnumerator GetEnumerator() 
    {
        foreach (Question question in questions) 
        {
            yield return question;
        }
    }
}

class main 
{
    List<Test> myTests;

    public void ShowAllTests() 
    {
        int i = 0;
        foreach (Test test in myTests) 
        {
            i++;
            Console.WriteLine("{0}. {1}", i, test.Name);
        }
    }

    public void AddNewTest() 
    {
        Console.WriteLine("Please print test name");
        myTests.Add(new Test(Console.ReadLine()));
    }

    public bool RemoveTest(int index) 
    {
        index--;
        if (index < 0 || index >= myTests.Count) 
        {
            return false;
        }

        myTests.RemoveAt(index);
        return true;
    }

    public void EditTest() 
    {
        ShowAllTests();
        Console.WriteLine("Print test number");
        int test_num = Int32.Parse(Console.ReadLine()); 
        if (test_num < 0 || test_num >= myTests.Count) 
        {
            Console.WriteLine("There is no such test.");
            return;
        }

        myTests[test_num].Edit();
    }

    public static void Emulate(Test current_Test) 
    {

        int rightA = 0;
        int all_questions = 0;

        foreach (Question question in current_Test) 
        {
            all_questions++;
            Console.Write("{0}. ", all_questions);
            question.show_question();
            string user_answer = Console.ReadLine();
            if (Int32.Parse(user_answer) == question.Answer) 
            {
                rightA++;
            }
        }

        Console.WriteLine("\n\tTest successfully finished. Your result if {0} of {1}.", rightA, all_questions);
    }

    public static int ShowMenuAndWait() 
    {
        Console.WriteLine("\n-------TestManager-------\n");
        Console.WriteLine("1 - show all tests");
        Console.WriteLine("2 - add new test");
        Console.WriteLine("3 - remove test");
        Console.WriteLine("4 - start some test");
        Console.WriteLine("5 - edit test");
        Console.WriteLine("6 - exit");
        Console.WriteLine("-------TestManager-------\n");

        return Int32.Parse(Console.ReadLine());
    }


    public static void Main() 
    {
        while (true) 
        {
            int what_to_do = ShowMenuAndWait();
            switch (what_to_do) 
            {
                case 1:
                    ShowAllTests(); 
                    break;

                case 2:
                    AddNewTest(); 
                    break;

                case 3:
                    ShowAllTests();
                    Console.WriteLine("Print test number");
                    int test_num = Int32.Parse(Console.ReadLine());
                    if (test_num < 0 || test_num >= myTests.Count) 
                    {
                        Console.WriteLine("There is no such test");
                        break;
                    }

                    RemoveTest(test_num);
                    break;

                case 4:
                    ShowAllTests();
                    Console.WriteLine("Print test number");
                    test_num = Int32.Parse(Console.ReadLine());
                    if (test_num < 0 || test_num >= myTests.Count) 
                    {
                        Console.WriteLine("There is no such test");
                        break;
                    }

                    Emulate(myTests[test_num]);
                    break;

                case 5:
                    ShowAllTests();
                    Console.WriteLine("Print test number");
                    test_num = Int32.Parse(Console.ReadLine());
                    if (test_num < 0 || test_num >= myTests.Count) 
                    {
                        Console.WriteLine("There is no such test");
                        break;
                    }
                    
                    myTests[test_num].Edit();
                    break;

                case 6:
                    return;

                default:
                    Console.WriteLine("Something going wrong ;( Try again please\n");
                    break;
            }
        }
    }
}
