using System;


public struct producer 
{
    public string country, city;
}


public abstract class ALU
{
    
    protected int id;
    protected producer MadeIn; 
    protected string model;
    protected string company;
    

    public string Model
    {
        get { return model; }
        set { model = value; }
    }

    public string Company 
    {
        get { return company; }
        set { company = value; }
    }

    public string Country 
    {
        get { return MadeIn.country; }
        set { MadeIn.country = value; }
    }

    public string City 
    {
        get { return MadeIn.city; }
        set { MadeIn.city = value; }
    }

    abstract public void print_info();
}


class IntelProcessor : ALU
{
    private static int intel_pocessor_count = 0;

    public IntelProcessor() {
        this.company = "Intel";
        id = intel_pocessor_count;
        intel_pocessor_count++;
    }


    public IntelProcessor(string model) {
        this.model = model;
        this.company = "Intel";
        intel_pocessor_count++;
    }


    public IntelProcessor(string model, string country, string city) {
        this.model = model;
        this.MadeIn.country = country;
        this.MadeIn.city = city;
        this.company = "Intel";
        id = intel_pocessor_count;
        intel_pocessor_count++;
    }    


    public override void print_info() 
    {
        Console.WriteLine("It is Intel {0} processor with id = {3}. Made in {1}, {2}.\n", model, MadeIn.country, MadeIn.city, id);
    }


    public static void print_company_info() 
    {
        Console.WriteLine("{0} Intel processors solled.\n", intel_pocessor_count);
    }
}


class AmdProcessor : ALU
{
    private static int amd_processor_count = 0;

    public AmdProcessor() {
        this.company = "Intel";
        id = amd_processor_count;
        amd_processor_count++;
    }


    public AmdProcessor(string model) {
        this.model = model;
        this.company = "Intel";
        id = amd_processor_count;
        amd_processor_count++;
    }


    public AmdProcessor(string model, string country, string city) {
        this.model = model;
        this.MadeIn.country = country;
        this.MadeIn.city = city;
        this.company = "Intel";
        id = amd_processor_count;
        amd_processor_count++;
    }    


    public override void print_info() 
    {
        Console.WriteLine("It is Amd {0} processor with id = {3} . Made in {1}, {2}.\n", model, MadeIn.country, MadeIn.city, id);
    }


    public static void print_company_info() 
    {
        Console.WriteLine("{0} Amd processors solled.\n", amd_processor_count);
    }
}



class abacaba
{

    public static void Main() 
    {
        AmdProcessor GermanPc = new AmdProcessor("Athlon", "Germany", "Berlin");
        IntelProcessor MyPc = new IntelProcessor("Core i7", "Australia", "Canberra");

        GermanPc.print_info();
        MyPc.print_info();

       AmdProcessor.print_company_info();        
       IntelProcessor.print_company_info(); 
    }
}

