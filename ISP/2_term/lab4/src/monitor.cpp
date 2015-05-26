#include <cstdio>
#include <cstdlib>
#include <string.h>
#include "sys/types.h"
#include "sys/sysinfo.h"
#include <stdexcept>


struct sysinfo memoryinfo;


extern "C" 
{
    unsigned long long getUsedRAM();
    unsigned long long getUsedSwapMemory();
    unsigned long long getFreeRAM();
    unsigned long long getFreeSwapMemory();
    double getCpuUsage();
}


unsigned long long getUsedRAM() 
{
    sysinfo(&memoryinfo);
    return (memoryinfo.totalram - memoryinfo.freeram) * memoryinfo.mem_unit / 1024 / 1024;
}


unsigned long long getUsedSwapMemory() 
{
    sysinfo(&memoryinfo); 
    return (memoryinfo.totalswap - memoryinfo.freeswap) * memoryinfo.mem_unit / 1024 / 1024;
}


unsigned long long getFreeRAM() 
{
    sysinfo(&memoryinfo); 
    return memoryinfo.freeram * memoryinfo.mem_unit / 1024 / 1024;
}


unsigned long long getFreeSwapMemory() 
{
    sysinfo(&memoryinfo); 
    return memoryinfo.freeswap * memoryinfo.mem_unit / 1024 / 1024;
}


static unsigned long long lastTotalUser, lastTotalUserLow, lastTotalSys, lastTotalIdle;

double getCpuUsage() 
{
    double percent;
    FILE* file;
    unsigned long long totalUser, totalUserLow, totalSys, totalIdle, total;

    file = fopen("/proc/stat", "r");
    fscanf(file, "cpu %Ld %Ld %Ld %Ld", &totalUser, &totalUserLow, &totalSys, &totalIdle);
    fclose(file);

    if (totalUser < lastTotalUser || totalUserLow < lastTotalUserLow || totalSys < lastTotalSys || totalIdle < lastTotalIdle){
        percent = -1.0;
    } 
    else
     {
        total = (totalUser - lastTotalUser) + (totalUserLow - lastTotalUserLow) +
        (totalSys - lastTotalSys);
        percent = total;
        total += (totalIdle - lastTotalIdle);
        percent /= total;
        percent *= 100;
    }
    lastTotalUser = totalUser;
    lastTotalUserLow = totalUserLow;
    lastTotalSys = totalSys;
    lastTotalIdle = totalIdle;

    return percent;
}
