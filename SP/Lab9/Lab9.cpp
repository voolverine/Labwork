// Lab9.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Lab9.h"
#include <set>
#include <vector>
#include <map>
#include <sys/stat.h>
#include <string>

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;                                // current instance
WCHAR szTitle[MAX_LOADSTRING];                  // The title bar text
WCHAR szWindowClass[MAX_LOADSTRING];            // the main window class name

// Forward declarations of functions included in this code module:
ATOM                MyRegisterClass(HINSTANCE hInstance);
BOOL                InitInstance(HINSTANCE, int);
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK    About(HWND, UINT, WPARAM, LPARAM);

HWND listbox;
HWND find_button;
HWND repair_button;
HWND stop_button;
HWND delete_button;
CRITICAL_SECTION critical_section;
const int SEARCH_THREADS = 5;

bool threads_searching;
std::vector<HANDLE> threads;
std::vector<DWORD> threads_id;
HWND hData;
HWND hPath;
bool empty_data = false;
bool unreal_path = false;

bool finding_now = false;

std::map<DWORD, HKEY> starting_points;

std::vector<TCHAR *> templates = {
	L"C:\\",
	L"D:\\"
};

struct Paralel {
	HKEY brunch;
	wchar_t path[256];

	Paralel(HKEY brunch, wchar_t *path) {
		this->brunch = brunch;
		wcscpy(this->path, path);
	}
};

std::vector<Paralel> paralels;

HKEY *get_starting_point(DWORD PID) {
	HKEY *key;
	EnterCriticalSection(&critical_section);
	key = &starting_points[PID];
	LeaveCriticalSection(&critical_section);
	return key;
}



void add_to_listbox(TCHAR *str) {
	EnterCriticalSection(&critical_section);
	SendMessage(listbox, LB_ADDSTRING, NULL, (LPARAM)str);
	LeaveCriticalSection(&critical_section);
}


bool is_path(TCHAR *str) {


	for (size_t i = 0; i < templates.size(); i++) {
		int min_length = min(wcslen(str), wcslen(templates[i]));
		bool equal = true;
		for (int j = 0; j < min_length; j++) {
			if (templates[i][j] != str[j]) {
				equal = false;
				break;
			}
		}
		if (equal && min_length != 0) {
			return true;
		}
	}

	return false;
}


std::vector<TCHAR *> ntemplates = {
	L",-1", L",-2", L",-3", L",-4", L",-5", L",-6", L",-7", L",-8", L",-9", L",-10",
	L".FriendlyAppName",
	L".ApplicationCompany"
};


void process_file_name(TCHAR *filename) {
	int len = wcslen(filename);
	for (size_t i = 0; i < ntemplates.size(); i++) {
		wchar_t *start = wcswcs(filename, ntemplates[i]);

		if (start != NULL) {
			*start = '\0';
			break;
		}
	}
}

bool file_exists(TCHAR *path) {
	//process_file_name(path);

	struct _stat64i32 s;
	if (_wstat(path, &s)) {
		return true;
	}
	else {
		return false;
	}
}
int kk = 0;

void analize_branch(HKEY *starting_point, wchar_t *current_path) {

	DWORD cvalues, ckeys;
	LONG ret_key_info = RegQueryInfoKey(*starting_point, NULL, NULL, NULL, &ckeys, NULL, NULL, &cvalues, NULL,
		NULL, NULL, NULL);
	Sleep(10);

	for (DWORD i = 0; i < cvalues; i++) {
		wchar_t name[256];
		DWORD cName = 256;
		wchar_t data[256];
		DWORD cData = 256;
		DWORD type;

		LONG error = RegEnumValue(*starting_point, i, name, &cName, NULL, &type, (LPBYTE)data, &cData);
		if (error == ERROR_SUCCESS) {
			bool need = false;
			if (unreal_path && (type == REG_SZ || type == REG_MULTI_SZ || type == REG_EXPAND_SZ) &&
						is_path(name) && file_exists(name) ) {
				
				need = true;
			} else
			if (empty_data && cData == 0 && wcslen(name) != 0) {
				need = true;
			}

			if (need) {
				paralels.push_back(Paralel(starting_points[GetCurrentThreadId()], current_path));
				add_to_listbox(name);
			}
		}
	}

	for (DWORD i = 0; i < ckeys; i++) {
		wchar_t SubKeyName[256];
		DWORD cName = 256;
		LONG err = RegEnumKeyEx(*starting_point, i, SubKeyName, &cName, NULL, NULL, NULL, NULL);
		if (err != ERROR_SUCCESS) {
			continue;
		}
		
		HKEY sub_key;
		RegOpenKeyEx(*starting_point, SubKeyName, 0, KEY_READ, &sub_key);
		int position = wcslen(current_path);
		wcscat(current_path, SubKeyName);
		wcscat(current_path, L"\\");
		if (finding_now) {
			analize_branch(&sub_key, current_path);
		}
		RegCloseKey(sub_key);
		current_path[position] = '\0';
		if (!finding_now) {
			return;
		}
	}
}

DWORD WINAPI thread_function(LPVOID lpParam) {
	DWORD current_thread_id = GetCurrentThreadId();
	HKEY *starting_point = get_starting_point(current_thread_id);
	
	wchar_t path[1000] = L"";
	analize_branch(starting_point, path);

	ExitThread(0);
}


void stop_all_threads() {
	finding_now = false;
	for (size_t i = 0; i < threads.size(); i++) {
		int result = WaitForSingleObject(threads[i], 15);
		if (result != WAIT_OBJECT_0) {
			TerminateThread(threads[i], 0);
		}
		CloseHandle(threads[i]);
	}
	threads.clear();
	threads_id.clear();
}


bool check_if_find_finished() {
	bool all_close = true;
	for (size_t i = 0; i < threads.size(); i++) {
		DWORD result = WaitForSingleObject(threads[i], 0);

		if (result != WAIT_OBJECT_0) {
			all_close = false;
		}
	}

	return all_close;
}


void find_fake_records() {
	if (finding_now) {
		return;
	}
	SendMessage(listbox, LB_RESETCONTENT, NULL, NULL);
	paralels.clear();
	finding_now = true;
	if (threads_id.size() == 0) {
		threads_id.resize(SEARCH_THREADS);
	}
	kk++;

	for (int i = 0; i < SEARCH_THREADS; i++) {
		HANDLE thread = CreateThread(NULL, 0, thread_function, NULL, CREATE_SUSPENDED, &threads_id[i]);
		threads.push_back(thread);
	}

	starting_points.clear();
	starting_points = {
		{threads_id[0], HKEY_CLASSES_ROOT},
		{threads_id[1], HKEY_CURRENT_USER},
		{threads_id[2], HKEY_LOCAL_MACHINE},
		{threads_id[3], HKEY_USERS},
		{threads_id[4], HKEY_CURRENT_CONFIG}
	};

	for (size_t i = 0; i < threads.size(); i++) {
		ResumeThread(threads[i]);
	}
}


int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    // TODO: Place code here.

    // Initialize global strings
    LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
    LoadStringW(hInstance, IDC_LAB9, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB9));

    MSG msg;

    // Main message loop:
    while (GetMessage(&msg, nullptr, 0, 0))
    {
        if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

    return (int) msg.wParam;
}



ATOM MyRegisterClass(HINSTANCE hInstance)
{
    WNDCLASSEXW wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);

    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB9));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_LAB9);
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

    return RegisterClassExW(&wcex);
}


BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   hInst = hInstance; // Store instance handle in our global variable

   HWND hWnd = CreateWindowW(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, 800, 600, nullptr, nullptr, hInstance, nullptr);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}


LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)
    {
	case WM_CREATE:
	{
		InitializeCriticalSection(&critical_section);
		listbox = CreateWindow(L"LISTBOX", L"Keys", WS_CHILD | WS_BORDER | WS_VSCROLL | WS_VISIBLE,
			50, 50, 700, 400, hWnd, (HMENU)IDC_LISTBOX, hInst, NULL);
		find_button = CreateWindow(L"BUTTON", L"Find", WS_CHILD | WS_BORDER | WS_VISIBLE,
			360, 450, 50, 20, hWnd, (HMENU)IDC_FIND_BUTTON, hInst, NULL);
		stop_button = CreateWindow(L"BUTTON", L"Stop", WS_CHILD | WS_BORDER | WS_VISIBLE,
			420, 450, 50, 20, hWnd, (HMENU)IDC_STOP_BUTTON, hInst, NULL);
		repair_button = CreateWindow(L"BUTTON", L"Clear", WS_CHILD | WS_BORDER | WS_VISIBLE,
			360, 480, 50, 20, hWnd, (HMENU)IDC_CLEAR_BUTTON, hInst, NULL);
		delete_button = CreateWindow(L"BUTTON", L"Delete", WS_CHILD | WS_BORDER | WS_VISIBLE,
			420, 480, 50, 20, hWnd, (HMENU)IDC_DELETE_BUTTON, hInst, NULL);
		hPath = CreateWindow(L"BUTTON", L"", WS_CHILD | WS_BORDER | WS_VISIBLE | BS_CHECKBOX,
			50, 460, 15, 15, hWnd, (HMENU)IFS_UNREAL_FILES_CHECKBOX, hInst, NULL);
		hData = CreateWindow(L"BUTTON", L"", WS_CHILD | WS_BORDER | WS_VISIBLE | BS_CHECKBOX,
			50, 480, 15, 15, hWnd, (HMENU)IFS_EMPTY_DATA, hInst, NULL);

		SetTimer(hWnd, IDT_TIMER1, 100, NULL);

		break;
	}
	case WM_TIMER:

		switch (wParam)
		{
		case IDT_TIMER1:
			if (finding_now) {
				bool finished = check_if_find_finished();

				if (finished) {
					finding_now = false;
					MessageBox(hWnd, L"Search finished.", L"OK", MB_OK);
				}
			}
			break;
		default:
			break;
		}

		break;
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            switch (wmId)
            {
            case IDM_EXIT:
                DestroyWindow(hWnd);
                break;
			case IDC_FIND_BUTTON:
				find_fake_records();
				break;
			case IDC_CLEAR_BUTTON:
				SendMessage(listbox, LB_RESETCONTENT, NULL, NULL);
				paralels.clear();
				break;
			case IFS_EMPTY_DATA:
				if (empty_data) {
					empty_data = false;
					CheckDlgButton(hWnd, IFS_EMPTY_DATA, BST_UNCHECKED);
				} else {
					empty_data = true;
					CheckDlgButton(hWnd, IFS_EMPTY_DATA, BST_CHECKED);
				}
				break;
			case IFS_UNREAL_FILES_CHECKBOX:
				if (unreal_path) {
					unreal_path = false;
					CheckDlgButton(hWnd, IFS_UNREAL_FILES_CHECKBOX, BST_UNCHECKED);
				}
				else {
					unreal_path = true;
					CheckDlgButton(hWnd, IFS_UNREAL_FILES_CHECKBOX, BST_CHECKED);
				}
				break;
			case IDC_DELETE_BUTTON:
			{
				int index = (int)SendMessage(listbox, LB_GETCURSEL, NULL, NULL);
				if (index == -1) {
					break;
				}

				wchar_t selected[256];
				SendMessage(listbox, LB_GETTEXT, (WPARAM)index, (LPARAM)selected);
				SendMessage(listbox, LB_DELETESTRING, (WPARAM)index, NULL);

				Paralel &paralel = paralels[index];
				HKEY hKey;
				DWORD error = RegOpenKeyEx(paralel.brunch, paralel.path, 0, KEY_ALL_ACCESS, &hKey);
				RegDeleteValue(hKey, selected);

				if (error != ERROR_SUCCESS) {
					MessageBox(hWnd, L"Access Denied", L"Access Denied", MB_OK);
				}

				RegCloseKey(hKey);
				paralels.erase(paralels.begin() + index, paralels.begin() + index + 1);

				break;
			}
			case IDC_STOP_BUTTON:
				if (finding_now) {
					stop_all_threads();
				}
				break;
            default:
                return DefWindowProc(hWnd, message, wParam, lParam);
            }
        }
        break;
    case WM_PAINT:
        {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hWnd, &ps);
            // TODO: Add any drawing code that uses hdc here...
			TextOut(hdc, 70, 460, L"Unreal files", 14);
			TextOut(hdc, 70, 480, L"Empty data", 11);
            EndPaint(hWnd, &ps);
        }
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}