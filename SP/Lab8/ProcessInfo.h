#include "tlhelp32.h"
#include "map"

#pragma once
class ProcessInfo
{
private:
	static const int MAX_NAME = 256;
	HWND listbox;

public:
	TCHAR name[MAX_NAME];
	TCHAR display_string[MAX_NAME + 10];
	DWORD PID = -1;
	DWORD priority;
	int id_in_listbox;
	bool displayed;

	ProcessInfo(const PROCESSENTRY32 &process_entry, HWND listbox);
	~ProcessInfo();

	bool update_priority();
	void display();
	void redisplay();
	void remove_from_listbox();
	void show_modules(HWND listbox);
	TCHAR *get_representation();
};

