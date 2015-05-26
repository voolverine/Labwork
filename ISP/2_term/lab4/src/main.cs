using System;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;

public class monitor 
{
    [DllImport ("libcpp.so", EntryPoint = "getUsedRAM")] static public extern ulong getUsedRAM();
    [DllImport ("libcpp.so", EntryPoint = "getUsedSwapMemory")] static public extern ulong getUsedSwapMemory();
    [DllImport ("libcpp.so", EntryPoint = "getFreeRAM")] static public extern ulong getFreeRAM();
    [DllImport ("libcpp.so", EntryPoint = "getFreeSwapMemory")] static public extern ulong getFreeSwapMemory();
    [DllImport ("libcpp.so", EntryPoint = "getCpuUsage")] static public extern double getCpuUsage();
}

public class Lab4 
{
    public static void Main() 
    {
        while (true) 
        {
            Thread.Sleep(500);
            Console.Clear();
            
            ulong usedRAM = monitor.getUsedRAM();
            ulong freeRAM = monitor.getFreeRAM();
            ulong usedSwapMemory = monitor.getUsedSwapMemory();
            ulong freeSwapMemory = monitor.getFreeSwapMemory();
            double cpuUsage = monitor.getCpuUsage();
            Console.WriteLine("Used RAM = {0}MB", usedRAM);
            Console.WriteLine("Free RAM = {0}MB", freeRAM);
            Console.WriteLine("Used Swap Memory = {0}MB", usedSwapMemory);
            Console.WriteLine("Free Swap Memory = {0}MB", freeSwapMemory);
            Console.WriteLine("CPU Loaded = {0:F2}%", cpuUsage);
        }

    }

}


