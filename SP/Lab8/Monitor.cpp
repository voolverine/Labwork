#include "stdafx.h"
#include "Monitor.h"

std::map<DWORD, Monitor::pfunction> Monitor::thread_functions;
std::vector<ProcessInfo *> processes_now;
std::vector<ProcessInfo *> processes_then;

Monitor::Monitor(HWND listbox1, HWND listbox2)
{
	now_showing[0] = '\0';
	this->listbox1 = listbox1;
	this->listbox2 = listbox2;

	threads_id.resize(THREAD_COUNT);
	for (size_t i = 0; i < THREAD_COUNT; i++) {
		HANDLE new_thread_handle = CreateThread(NULL, 0, thread_function, this, CREATE_SUSPENDED,
												&threads_id[i]);
		threads.push_back(new_thread_handle);
	}


	thread_functions.emplace(threads_id[0], &Monitor::update_processes);
	thread_functions.emplace(threads_id[1], &Monitor::update_process_info);
}


Monitor::~Monitor()
{

}


void Monitor::run() {
	if (!threads_suspended) {
		return;
	}
	threads_suspended = false;

	for (size_t i = 0; i < THREAD_COUNT; i++) {
		ResumeThread(threads[i]);
	}
}


void Monitor::pause() {
	if (threads_suspended) {
		return;
	}
	threads_suspended = true;

	for (size_t i = 0; i < THREAD_COUNT; i++) {
		SuspendThread(threads[i]);
	}
}


DWORD WINAPI Monitor::thread_function(LPVOID lpParam) {
	DWORD current_thread_id = GetCurrentThreadId();
	const pfunction func = thread_functions[current_thread_id];
	Monitor *monitor = (Monitor *)lpParam;

	while (true) {
		(*monitor.*func)();
		Sleep(300);
	}
}


void Monitor::update_processes() {
	get_process_list();
	return;
}

ProcessInfo *Monitor::findProcessInfoByText(TCHAR *text) {
	for (size_t i = 0; i < (int)processes_now.size(); i++) {

		if (wcscmp(text, processes_now[i]->display_string) == 0) {
			return processes_now[i];
		}
	}

	return NULL;
}

void Monitor::change_priority(DWORD priority)
{
	int selected = (int)SendMessage(listbox1, LB_GETCURSEL, NULL, NULL);
	if (selected == -1) {
		return;
	}

	TCHAR selected_proc[256];
	SendMessage(listbox1, LB_GETTEXT, (WPARAM)selected, (LPARAM)selected_proc);

	ProcessInfo *pInfo = findProcessInfoByText(selected_proc);
	if (pInfo != NULL) {
		HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pInfo->PID);
		SetPriorityClass(hProcess, priority);
		pInfo->update_priority();
		CloseHandle(hProcess);
		pInfo->redisplay();
	}

	return;
}

void Monitor::update_process_info() {

	int selected = SendMessage(listbox1, LB_GETCURSEL, NULL, NULL);
	if (selected == -1) {
		SendMessage(listbox2, LB_RESETCONTENT, NULL, NULL);
		return;
	}

	TCHAR selected_proc[256];
	SendMessage(listbox1, LB_GETTEXT, (WPARAM)selected, (LPARAM)selected_proc);

	if (wcscmp(selected_proc, now_showing) == 0) {
		return;
	}
	else {
		SendMessage(listbox2, LB_RESETCONTENT, NULL, NULL);
		wcscpy(now_showing, selected_proc);

		ProcessInfo *pInfo = findProcessInfoByText(now_showing);
		if (pInfo != NULL) {
			pInfo->show_modules(listbox2);
		}
	}
	
	return;
}

void Monitor::get_process_list()
{
	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,
		0);

	if (hSnapshot == INVALID_HANDLE_VALUE) {
		return;
	}

	PROCESSENTRY32 process_entry;
	process_entry.dwSize = sizeof(PROCESSENTRY32);
	Process32First(hSnapshot, &process_entry);

	do {
		ProcessInfo *pInfo = new ProcessInfo(process_entry, listbox1);
		processes_then.push_back(pInfo);
	} while (Process32Next(hSnapshot, &process_entry));
	
	for (size_t i = 0; i < processes_now.size(); i++) {
		int finded = -1;
		
		for (size_t j = 0; j < processes_then.size(); j++) {
			if (processes_now[i]->PID == processes_then[j]->PID) {
				finded = j;
				break;
			}
		}

		if (finded == -1) {
			if (processes_now[i]->displayed) {
				processes_now[i]->remove_from_listbox();
			}
		} else {
			delete processes_then[finded];
			processes_then[finded] = processes_now[i];
		}
	}
	
	
	processes_now.clear();
	while (processes_then.size() > 0) {
		processes_now.push_back(processes_then.back());
		processes_then.pop_back();

		if (processes_now.back()->displayed == false) {
			processes_now.back()->display();
		}
	}

	CloseHandle(hSnapshot);
}
