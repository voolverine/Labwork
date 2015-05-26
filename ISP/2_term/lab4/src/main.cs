using System;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;


public class monitor 
{
    [DllImport ("mylib.so", EntryPoint = "getUsedRAM")] static public extern ulong getUsedRAM;
    [DllImport ("mylib.so", EntryPoint = "getUsedSwapMemory")] static public extern ulong getUsedSwapMemory;
    [DllImport ("mylib.so", EntryPoint = "getFreeRAM")] static public extern ulong getFreeRAM;
    [DllImport ("mylib.so", EntryPoint = "getFreeSwapMemory")] static public extern ulong getFreeSwapMemory;
    [DllImport ("mylib.so", EntryPoint = "getCpuUsage")] static public extern double getCpuUsage;
}

public class Lab4 
{
    public static void main() 
    {
        while (42) 
        {
            Thread.Sleep(1000);
            Console.Clear;

            Console.WriteLine("Used RAM = {0}MB\n", monitor.getUsedRAM());
            Console.WriteLine("Free RAM = {0}MB\n", monitor.getFreeRAM());
            Console.WriteLine("\n");
            Console.WriteLine("Used Swap Memory = {0}MB\n", monitor.getUsedSwapMemory());
            Console.WriteLine("Free Swap Memory = {0}MB\n", monitor.getFreeSwapMemory());
            Console.WriteLine("\n");
            Console.WriteLine("CPU Loaded = {0}%\n", monitor.getCpuUsage());
        }

    }

}


