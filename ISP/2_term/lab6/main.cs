using System;
using System.Text;
using System.Collections.Generic;

public interface actions<T>
    where T : class
{
    void Swap(ref T obj);
    void print_info();
}

public abstract class ALU 
{

    protected string company;
    protected string model;
    protected string country;
    protected string city;
    protected int kernels;

    public string Company 
    {
        get { return company; }
        set { company = value; }
    }

    public string Model 
    {
        get { return model; }
        set { model = value; }
    }

    public string Country 
    {
        get { return country; }
        set { country = value; }
    }

    public string City 
    {
        get { return city; }
        set { city = value; }
    }

    public int Kernels 
    {
        get { return kernels; }
        set {kernels = value; }
    }

}

public class processor: ALU, actions<processor>, IEquatable<processor>, IComparable<processor> 
{
    public processor() {}
    public processor(processor temp) 
    {
        company = temp.company;
        model = temp.model;
        country = temp.country;
        city = temp.city;
        kernels = temp.kernels;
    }

    public processor(string company, string model, string country, string city, int kernels) 
    {
        this.company = company;
        this.model = model;
        this.country = country;
        this.city = city;
        this.kernels = kernels;
    }

    public bool Equals(processor obj) 
    {
        if (obj == null) 
        {
            return false;
        }
        if (company == obj.company && model == obj.model && country == obj.country && city == obj.city
                && kernels == obj.kernels) 
        {
            return true;
        } else 
        {
            return false;
        }
    }

    public int CompareTo(processor obj) 
    {
        if (obj == null) 
        {
            return 1;
        }
        if (Equals(obj) || kernels == obj.kernels) 
        {
            return 0;
        }

        if (kernels > obj.kernels) 
        {
            return 1;
        } else 
        {
            return -1;
        }
    }

    public void print_info() 
    {
        Console.WriteLine("{0} {1} processor. Made in {2}, {3}. Kernels = {4}.", company, model, country, city, kernels);
    }
    
    public void Swap(ref processor obj) 
    {
        processor temp = new processor(this);
        company = obj.company;
        model = obj.model;
        country = obj.country;
        city = obj.city;
        kernels = obj.kernels;
        obj = new processor(temp);
    }


}

public class Lab6 
{
    public static void bubble_sort(processor[] my_proc, int n) 
    {
        for (int i = 0; i < n; i++) 
        {
            for (int j = i + 1; j < n; j++) 
            {
                int cmp = my_proc[i].CompareTo(my_proc[j]);
                if (cmp == 0) 
                {
                    continue;
                }
                if (cmp > 0) 
                {
                    my_proc[i].Swap(ref my_proc[j]);
                }
            }
        }
    }

    public static void Main()
    {
        Console.Clear();
        Random rnd = new Random();
        processor[] my_proc = new processor[10];
        for (int i = 0; i < 10; i++) 
        {
            string company, model, country, city;
            int kernels;
            int r = rnd.Next(2);
            if (r == 0) 
            {
                company = "Intel";
                model = "Celerone";
            } else 
            {
                company = "AMD";
                model = "Athlon";
            }

            r = rnd.Next(2);
            if (r == 0) 
            {
                country = "Russia";
                city = "Magadan";
            } else 
            {
                country = "USA";
                city = "Miami";
            }
            kernels = rnd.Next(50) + 1;
            my_proc[i] = new processor(company, model, country, city, kernels);
            my_proc[i].print_info();
        }
        Console.WriteLine("Processors sorted by kernels:");
        bubble_sort(my_proc, 10);
        for (int i = 0; i < 10; i++) 
        {
            my_proc[i].print_info();
        }
    }

}


