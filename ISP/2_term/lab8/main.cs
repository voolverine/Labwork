using System;
using System.Collections.Generic;

public class Problems 
{
    public static void Negative(ref int m, ref int n) 
    {
        n = -n;
        m = -m;
        Console.WriteLine("You are trying to do n Negative, so now Rational = {0} / {1}", m, n);
    }

    public static void DevideByZero() 
    {
        Console.WriteLine("You are trying to devide by Zero! Now n = 1.");
    }

    public static bool isZero(int a) 
    {
        if (a == 0) 
        {
            return true;
        }
        return false;
    }

}


public delegate void MethodContainer();
public delegate void MethodContainer2(ref int m, ref int n);
public delegate bool MethodContainer3(int a);

public class Rational: IEquatable<Rational>, IComparable<Rational> 
{
    private int m, n;
    
    public static event MethodContainer DevideByZero;
    public static event MethodContainer2 Negative;
    
    public int M 
    {
        get { return m; }
        set { m = value; }
    }

    public int N 
    {
        get { return n; }
        set  
        {
            if (value == 0) 
            {
                DevideByZero();
                n = 1;
            } else 
            {
                n = value;
                if (value < 0) 
                {
                    Negative(ref m, ref n);
                } 
            }
        }
    }


    public Rational() 
    {
        N = 1;
        M = 0;
    }

    public Rational(int m, int n = 1) 
    {
        M = m;
        N = n;
        remove_gcd(ref this.n, ref this.m);
    }

    public Rational(Rational r) 
    {
        M = r.m;
        N = r.n;
    }

    public void Swap(ref Rational r) 
    {
        Rational temp = new Rational(r);
        r.m = m;
        r.n = n;

        m = temp.m;
        n = temp.n;
    }

    public bool Equals(Rational r) 
    {
        if (n == r.n && m == r.m) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public override bool Equals(Object obj) 
    {
        Rational r = obj as Rational;

        if (r != null) 
        {
            return Equals(r);
        } else 
        {
            return false;
        }
    }

    public int CompareTo(Rational r) 
    {
        if (this.m / this.n > r.m / r.n) 
        {
            return 1;
        }
        if (this.m / this.n < r.m / r.n) 
        {
            return -1;
        }

        Rational temp_this = new Rational(m, n);
        Rational temp_r = new Rational(r.m, r.n);
        temp_this.n *= r.m;
        temp_this.m *= r.m;
        temp_r.n *= m;
        temp_r.m *= m;

        if (temp_this.n > temp_r.n) 
        {
            return 1;
        }
        if (temp_this.n < temp_r.n) 
        {
            return -1;
        }

        return 0;
    }

    private static int gcd(int a, int b) 
    {
        if (a < 0) 
        {
            a = -a;
        }
        if (b < 0) 
        {
            b = -b;
        }


        while (a > 0 && b > 0) 
        {
            if (a > b) 
            {
                a %= b;
            } else 
            {
                b %= a;
            }
        }
        return a + b;    
    }

    private static void remove_gcd(ref Rational result) 
    {
        if (result.m == 0 || result.n == 1) 
        {
            return;
        }

        int g = gcd(result.m, result.n);
        result.n /= g;
        result.m /= g;
    }

    private static void remove_gcd(ref int m, ref int n) 
    {
        if (m == 0 || n == 1) 
        {
            return;
        }

        int g = gcd(m, n);
        m /= g;
        n /= g;
    }

    public static Rational operator+(Rational a, Rational b) 
    {
        Rational result = new Rational();
        result.m = a.m * b.n + a.n * b.m;
        result.n = a.n * b.n;

        remove_gcd(ref result);

        return result;
    }

    public static Rational operator-(Rational a, Rational b) 
    {
        Rational result = new Rational();
        result.m = a.m * b.n - a.n * b.m;
        result.n = a.n * b.n;

        remove_gcd(ref result);

        return result;
    }

    public static Rational operator*(Rational a, Rational b) 
    {
        Rational result = new Rational();
        result.m = a.m * b.m;
        result.n = a.n * b.n;

        remove_gcd(ref result);

        return result;
    }

    public static Rational operator/(Rational a, Rational b) 
    {
        Rational result = new Rational();
        result.m = a.m * b.n;
        result.n = a.n * b.m;

        remove_gcd(ref result);

        return result;
    }

    public static bool operator>(Rational a, Rational b) 
    {
        if (a.CompareTo(b) == 1) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public static bool operator>=(Rational a, Rational b) 
    {
        if (a.CompareTo(b) >= 0) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public static bool operator==(Rational a, Rational b) 
    {
        if (a.CompareTo(b) == 0) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public static bool operator<=(Rational a, Rational b) 
    {
        if (a.CompareTo(b) <= 0) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public static bool operator<(Rational a, Rational b) 
    {
        if (a.CompareTo(b) == -1) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public static bool operator!=(Rational a, Rational b) 
    {
        if (a.Equals(b) == true) 
        {
            return false;
        } else 
        {
            return true;
        }
    }

    public static implicit operator double(Rational a) 
    {
        double nn = a.n;
        double mm = a.m;
        return mm / nn;
    }

    public static implicit operator string(Rational a) 
    {
        return ToString(a);
    }

    private static string ToString(Rational r) 
    {
        return string.Format("{0}/{1}", r.m, r.n);
    }

    public override int GetHashCode() 
    {
        return (this.m / this.n).GetHashCode();
    }


    private static void getFromString(ref Rational r, string s) 
    {
        bool f = false;
        r.n = 0; 
        r.m = 0;
        for (int i = (s[0] == '-') ? 1 : 0; i < s.Length; i++) 
        {
            if (s[i] == '/') 
            {
                f = true;
                if (i + 1 < s.Length && s[i + 1] == '-') 
                {
                    throw new Exception("!");
                }

                continue;
            }
            if (s[i] >= '0' && s[i] <= '9') 
            {

                if (!f)
                {
                    r.m *= 10;
                    r.m += s[i] - '0';
                } else 
                {
                    r.n *= 10;
                    r.n += s[i] - '0';
                }
            } else 
            {
                throw new Exception("!");
            }

        }
        if (s[0] == '-') 
        {
            r.m = -r.m;
        }
        r.N = r.n;
        r.M = r.m;
        remove_gcd(ref r);
    }

    public static explicit operator Rational(string s) 
    {
        Rational result = new Rational();
        getFromString(ref result, s);
        return result;
    }

}


public class Lab8 
{
    public static void error(Exception e) 
    {
        Console.WriteLine("{0}\n\n\nBe careful, try again and don't crush my program.", e);
    }

    public static void printIfZero(MethodContainer3 current_delegate, int num)  
    {
        try 
        {
            if (current_delegate(num)) 
            {
                Console.WriteLine("{0} equals 0", num);
            } else 
            {
                Console.WriteLine("{0} doesn't equal 0", num);
            }
        } catch(Exception e) 
        {
            Console.WriteLine(e);
        }
    }



    public static void Main() 
    {
        Rational.DevideByZero += Problems.DevideByZero;
        Rational.Negative += Problems.Negative;
        Rational a = new Rational(3, 7);

        /*
         *  Events demonstration
         */

        a.N = 0;                                           // Devide by Zero Event

        a.N = -5;                                          // Negative N Event

        /*
         *  Events demostration
         */
       
        try 
        {
            a = (Rational)"5/0";
            Console.WriteLine("Rational = {0} / {1} = {2}", a.M, a.N, (double)a);
            a = (Rational)"123/-123";                                                                // Exception here
            Console.WriteLine("Rational = {0} / {1} = {2}", a.M, a.N, (double)a);
        } catch (Exception e)
        {
            error(e); 
        }
        
        MethodContainer3 delegate1 = new MethodContainer3(Problems.isZero);                          // Standart delegate
        MethodContainer3 delegate2 = delegate(int num)                                               // Anonymus method 
        {
            if (num == 0)
                return true;
            return false;
        };
        MethodContainer3 delegate4 = (int num) => Problems.isZero(num);                              // L-expression  
        Random rnd = new Random();
        
        printIfZero(delegate1, rnd.Next(2));
        printIfZero(delegate2, rnd.Next(3));
        printIfZero(delegate4, rnd.Next(5));
    }
}
