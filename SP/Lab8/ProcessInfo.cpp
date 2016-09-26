#include "stdafx.h"
#include "ProcessInfo.h"


void ProcessInfo::remove_from_listbox() {
	get_representation();
	int index = (int)SendMessage(listbox, LB_FINDSTRINGEXACT, NULL, (LPARAM)display_string);
	
	if (index != -1) {
		SendMessage(listbox, LB_DELETESTRING, (WPARAM)index, NULL);
	}
}

void ProcessInfo::show_modules(HWND listbox)
{
	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, this->PID);
	if (hSnapshot == INVALID_HANDLE_VALUE) {
		return;
	}

	MODULEENTRY32 module_entry;
	module_entry.dwSize = sizeof(MODULEENTRY32);
	Module32First(hSnapshot, &module_entry);

	do {
		SendMessage(listbox, LB_ADDSTRING, NULL, (LPARAM)module_entry.szModule);
	} while (Module32Next(hSnapshot, &module_entry));
}

bool ProcessInfo::update_priority() {
	HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, this->PID);
	int new_priority = GetPriorityClass(hProcess);

	if (new_priority != this->priority) {
		this->priority = new_priority;
		return true;
	}
	else {
		return false;
	}
}

std::map<DWORD, wchar_t *> names = {
	{IDLE_PRIORITY_CLASS, L"IDLE"},
	{NORMAL_PRIORITY_CLASS, L"NORMAL"},
	{HIGH_PRIORITY_CLASS, L"HIGH"},
	{REALTIME_PRIORITY_CLASS, L"REALTIME"}
};




TCHAR *ProcessInfo::get_representation() {
	if (names.find(priority) == names.end()) {
		swprintf(display_string, L"(0)[%4d]%-50s", PID, name, MAX_NAME + 10);
	}
	else {
		swprintf(display_string, L"(%s)[%4d]%-50s", names[priority], PID, name, MAX_NAME + 10);
	}

	return display_string;
}




void ProcessInfo::display()
{
	get_representation();

	id_in_listbox = (int)SendMessage(listbox, LB_GETCOUNT, NULL, NULL);
	SendMessage(listbox, LB_ADDSTRING, NULL, (LPARAM)display_string);
	displayed = true;

}

void ProcessInfo::redisplay()
{
	int index = (int)SendMessage(listbox, LB_FINDSTRINGEXACT, NULL, (LPARAM)display_string);
	get_representation();

	if (index == -1) {
		return;
	}

	SendMessage(listbox, LB_DELETESTRING, (WPARAM)index, NULL);
	SendMessage(listbox, LB_INSERTSTRING, (WPARAM)index, (LPARAM)display_string);
	SendMessage(listbox, LB_SETCURSEL, (WPARAM)index, NULL);
	displayed = true;
}

ProcessInfo::ProcessInfo(const PROCESSENTRY32 &process_entry, HWND listbox)
{
	this->PID = process_entry.th32ProcessID;
	wcscpy(this->name, process_entry.szExeFile);

	this->priority = 1>>25;
	update_priority();

	this->displayed = false;
	this -> listbox = listbox;
}


ProcessInfo::~ProcessInfo()
{
}
