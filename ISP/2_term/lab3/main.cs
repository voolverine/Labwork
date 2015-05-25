using System;

class ALU
{
    
    private string producer;
    private string country;
    private static int intel_pocessor_count = 0;
    private static int amd_processor_count = 0;
    private int id;
   

    public ALU() {}

    public ALU(string producer, string country)
    {
        this.producer = producer;
        this.country = country;

        set_id(producer);
    }

    private void set_id(string producer) 
    {
        switch (producer) 
        {
            case "intel":
                id = intel_pocessor_count;
                intel_pocessor_count++;
                break;
            case "amd":
                id = amd_processor_count;
                amd_processor_count++;
                break;
            default:
                break;
        }
    }


    public string this[string index] 
    {
        get 
        {
            switch (index) 
            {
                case "producer":
                    return producer;
                case "country":
                    return country;
                case "id":
                    return id.ToString(); 
                default:
                    return "";
            }

        }

        set 
        {
            switch (index) 
            {
                case "producer":
                    producer = value;
                    set_id(producer);
                    return;
                case "country":
                    country = value;
                    return;
                case "id":
                    id = Int32.Parse(value);
                    return;
                default:
                    return;
            }

        }
    }


}



class abacaba
{

    public static void showALUInfo(ALU current_processor) 
    {
        Console.WriteLine("{0} {1} made in {2}\n", current_processor["producer"], current_processor["id"], current_processor["country"]);
        return;
    }

    public static void Main() 
    {
        ALU intel_first = new ALU("intel", "USA"); 
        ALU amd_first = new ALU();

        showALUInfo(intel_first);
        showALUInfo(amd_first);
    }

}

