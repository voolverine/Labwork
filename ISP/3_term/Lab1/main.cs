using System;
using System.Collections;
using System.Collections.Generic;

class Question
{
    private string question;
    private int answer;
    private List<string> answers = new List<string> ();

    public int Answer
    {
        get {return answer;}
        set {answer = value;}
    }

    public string Q 
    {
        set {question = value;}
        get {return question;}
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
        Answer = answer + 1;
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
        Console.WriteLine(Q); 
        int i = 0;

        foreach (string ans in answers) 
        {
            i++;
            Console.WriteLine("\t{0}) {1}", i, ans);        
        }
    }
}

class Test : IEnumerable 
{
    private string name;
    private List<Question> questions = new List<Question> ();
   

    public string Name 
    {
        get {return name;}
        set {name = value;}
    }

    public Test(string name) 
    {
        Name = name;
    }

    public Question this[int index] 
    {
        get {return questions[index];}
        set {questions[index] = value;}
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
    public static List<Test> myTests = new List<Test> ();

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

        Console.WriteLine("\n\n\n\t\t\t\t\t\t\t\t\t\t\tTest successfully finished. Your result is {0} of {1}.", rightA, all_questions);
    }


    public static void Main() 
    {

        /*
         * Auto add idk answer to each question
         */

        myTests.Add(new Test("Random Test"));  // Add test
        myTests[0].AddQuestion(new Question("Who am I?", new List<string> {"Monkey", "Human", "Dog", "Cat"}, 3)); // Add question in the first test
        myTests[0][0].remove_possible_answer(4); // remove DOG from answers of first test of first question
        myTests[0][0].Add_possible_answer("Butterfly"); // add new answer to first test first question

        myTests[0].AddQuestion(new Question("What is BSUIR?")); // add second question to the first test
        myTests[0][1].Add_possible_answer("University"); // add possible anser to the second question of the first test
        myTests[0][1].Add_possible_answer("City"); // add possible anser to the second question of the first test
        myTests[0][1].Answer = 2; // set second answer as right (University), idk is the first answer

        myTests[0].RemoveQuestion(2); // Remove second question from first test

        Emulate(myTests[0]); // Run first test
    }
}
