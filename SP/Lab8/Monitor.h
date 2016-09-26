#include <vector>
#include <map>
#include <windows.h>
#include <vector>
#include "tlhelp32.h"
#include "ProcessInfo.h"

#pragma once
class Monitor
{
public:
	typedef void(Monitor::*pfunction)();

	Monitor(HWND listbox1, HWND listbox2);
	~Monitor();

	void run();
	void pause();
	static DWORD WINAPI thread_function(LPVOID lpParam);
	void update_processes();
	void update_process_info();
	void change_priority(DWORD priority);

private:
	const size_t THREAD_COUNT = 2;
	std::vector<HANDLE> threads;
	std::vector<DWORD> threads_id;
	static std::map<DWORD, pfunction> thread_functions;
	bool threads_suspended = true;

	HWND listbox1;
	HWND listbox2;



	std::vector<ProcessInfo *> processes_now;
	std::vector<ProcessInfo *> processes_then;
	void get_process_list();
	ProcessInfo *findProcessInfoByText(TCHAR *text);



	TCHAR now_showing[256];

};

