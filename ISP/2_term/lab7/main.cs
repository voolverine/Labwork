using System;
using System.Collections.Generic;

public class Rational: IEquatable<Rational>, IComparable<Rational> 
{
    private int m, n;

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
            if (value <= 0) 
            {
                throw new Exception("N should be natural.");
            } else 
            {
                n = value;
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
        this.M = m;
        this.N = n;
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
        int g = gcd(result.m, result.n);
        result.n /= g;
        result.m /= g;
    }

    private static void remove_gcd(ref int m, ref int n) 
    {
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
        return (m / n).GetHashCode();
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
                continue;
            }

            if (!f) 
            {
                r.m *= 10 + (s[i] - '0');
            } else 
            {
                r.n *= 10 + (s[i] -'0');
            }
        }
        if (s[0] == '-') 
        {
            r.m = -r.m;
        }
        
        r.M = r.m;
        r.N = r.n;
        remove_gcd(ref r);
    }

    public static explicit operator Rational(string s) 
    {
        Rational result = new Rational();
        getFromString(ref result, s);
        return result;
    }

}


public class Lab7 
{
    public static void buble_sort(Rational[] arr, int n) 
    {

        for (int i = 0; i < n; i++) 
        {
            for (int j = i + 1; j < n; j++) 
            {

                if (arr[i].CompareTo(arr[j]) > 0) 
                {
                    arr[i].Swap(ref arr[j]);
                }

            }

        }

    }

    public static void Main() 
    {
        Random rnd = new Random();
        Rational[] arr = new Rational[10];

        for (int i = 0; i < 10; i++) 
        {
            arr[i] = new Rational(rnd.Next(1000) + 1, rnd.Next(100) + 1); 
            Console.WriteLine("{0} = {1}", (string)arr[i], (double)arr[i]);
        }

        Console.WriteLine("\nSorted:\n");
        buble_sort(arr, 10);

        for (int i = 0; i < 10; i++) 
        {
            Console.WriteLine("{0} = {1}", (string)arr[i], (double)arr[i]);
        }

        Console.WriteLine("");
        Console.WriteLine("{0} + {1} = {2} = {3}", (string)arr[0], (string)arr[1], (string)(arr[0] + arr[1]), (double)(arr[0] + arr[1]));
        Console.WriteLine("{0} - {1} = {2} = {3}", (string)arr[0], (string)arr[1], (string)(arr[0] - arr[1]), (double)(arr[0] - arr[1]));
        Console.WriteLine("{0} * {1} = {2} = {3}", (string)arr[0], (string)arr[1], (string)(arr[0] * arr[1]), (double)(arr[0] * arr[1]));
        Console.WriteLine("{0} / {1} = {2} = {3}", (string)arr[0], (string)arr[1], (string)(arr[0] / arr[1]), (double)(arr[0] / arr[1]));
    }
}


