using System;


class laba() {
    static Random rnd = new Random();

    static string nextString() {
        string input;
        input = Console.ReadLine(); 
        return input;
    }	

    static int max(int a, int b) {
        if (a > b) {
            return a;
        } else {
            return b;
        }
    }

    static string getWord(ref string s) {
        string word = "";
        for (int i = 0; i < s.Length && s[i] != ' '; i++) {
            word += s[i]; 
        }
        if (s.IndexOf(" ") > 0) { 
            s = s.Substring(s.IndexOf(' ') + 1);
        } else {
            s = "";
        }
        return word;
    }

    static void swap(ref char c1, ref char c2) {
        char temp = c1;
        c1 = c2;
        c2 = temp;
    }

    static string reverse(string s) {
        char[] charArray = s.ToCharArray();
        for (int i = 0; i < s.Length / 2; i++) {
            swap(ref charArray[i], ref charArray[s.Length - 1 - i]);
        }
        return new string(charArray);
    }
   
    static string reverseAllWords(string s) {
        string result = "";
        while (s.Length > 0) {
            string word = getWord(ref s);
            result += reverse(word) + ' ';
        }
        return result;
    }

    static double parseToDouble(string s) {
        double result = 0;
        long tenPower = 10;
        bool f = false;
        for (int i = 0; i < s.Length; i++) {
            if (s[i] == '.') {
                f = true;
            } else {
                if (f == false) {
                    result *= 10;
                    result += Char.GetNumericValue(s[i]);
                } else {
                    result += Char.GetNumericValue(s[i]) * 1.0 / tenPower;
                    tenPower *= 10;
                }
            }
        } 
        return result;
    }


    static string generateString() {
        string chars = "qwertyuiopasdfghjklzxcvbnm";
        string result = "";
        int len = rnd.Next(1, 5);
        for (int i = 0; i < len; i++) {
            int x = rnd.Next(0, 26);
            result += chars[x];
        }
        return result;
    }

	static void Main() {
        while (true) {
            Console.WriteLine("1 = generate string");
            Console.WriteLine("2 = parse double");
            Console.WriteLine("3 = reverse all words");
            string whatToDo = nextString();
            switch(whatToDo) {
                case "1":
                    Console.WriteLine(generateString());
                    break;
                case "2":
                    Console.WriteLine(parseToDouble(Console.ReadLine()));
                    break;
                case "3":
                    Console.WriteLine(reverseAllWords(Console.ReadLine()));
                    break;
                default:
                    return;
            }
        }
    }
}
