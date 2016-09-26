// Win32Project2.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Win32Project2.h"
#include <time.h>
#include <random>

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


HWND start_button;
HWND stop_button;
bool stopped = true;
const int THREADS_COUNT = 2;
bool activated = true;
POINT triangle1[3] = { {0, 0}, {800, 0}, {0, 600} };
POINT triangle2[3] = { {800, 0}, {800, 600}, {0, 600} };
DWORD threads_id[THREADS_COUNT];
HANDLE threads[THREADS_COUNT];
CRITICAL_SECTION critical_section;
thread_local std::mt19937 generator(std::random_device{}());


int nextInt(int from, int to) {
	return generator() % (from - to) + to;
}


void set_random_brush(HDC hdc) {
	int red = nextInt(0, 256);
	int green = nextInt(0, 256);
	int blue = nextInt(0, 256);

	HBRUSH new_brush = CreateSolidBrush(RGB(red, green, blue));
	HBRUSH old_brush = (HBRUSH)SelectObject(hdc, new_brush);
	DeleteObject(old_brush);
}


void separate_window(HDC hdc) {
	Polygon(hdc, triangle1, 3);
	Polygon(hdc, triangle2, 3);
}


void random_colorise(HWND hWnd) {
	POINT *triangle;

	DWORD current_thread_id = GetCurrentThreadId();
	if (current_thread_id == threads_id[0]) {
		triangle = triangle1;
	} else
	if (current_thread_id == threads_id[1]) {
		triangle = triangle2;
	}
	else {
		return;
	}

	HDC hdc = GetDC(hWnd);

	EnterCriticalSection(&critical_section);

	set_random_brush(hdc);
	Polygon(hdc, triangle, 3);
	RedrawWindow(start_button, NULL, NULL, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN);
	RedrawWindow(stop_button, NULL, NULL, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN);

	LeaveCriticalSection(&critical_section);
}


DWORD WINAPI thread_func(LPVOID pParam) {
	while (activated) {
		random_colorise((HWND)pParam);
		Sleep(500);
	}

	ExitThread(0);
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
    LoadStringW(hInstance, IDC_WIN32PROJECT2, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }


	srand(time(NULL));
    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32PROJECT2));

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



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
    WNDCLASSEXW wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);

    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_WIN32PROJECT2));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_WIN32PROJECT2);
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

    return RegisterClassExW(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   hInst = hInstance; // Store instance handle in our global variable

   HWND hWnd = CreateWindowW(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, 817, 660, nullptr, nullptr, hInstance, nullptr);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND  - process the application menu
//  WM_PAINT    - Paint the main window
//  WM_DESTROY  - post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)
    {
	case WM_CREATE:
		threads[0] = CreateThread(NULL, 0, thread_func, hWnd, CREATE_SUSPENDED, &threads_id[0]);
		threads[1] = CreateThread(NULL, 0, thread_func, hWnd, CREATE_SUSPENDED, &threads_id[1]);
		InitializeCriticalSection(&critical_section);

		start_button = CreateWindow(L"BUTTON", L"Start", WS_VISIBLE | WS_CHILD | WS_BORDER,
			50, 50, 50, 20, hWnd, (HMENU)IDC_BUTTON_START, hInst, NULL);
		stop_button = CreateWindow(L"BUTTON", L"Stop", WS_VISIBLE | WS_CHILD | WS_BORDER,
			100, 50, 50, 20, hWnd, (HMENU)IDC_BUTTON_STOP, hInst, NULL);
		break;
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            // Parse the menu selections:
            switch (wmId)
            {
			case IDC_BUTTON_START:
				if (stopped) {
					for (int i = 0; i < THREADS_COUNT; i++) {
						ResumeThread(threads[i]);
					}
					stopped = false;
				}
				break;
			case IDC_BUTTON_STOP:
				if (!stopped) {
					for (int i = 0; i < THREADS_COUNT; i++) {
						SuspendThread(threads[i]);
					}
					stopped = true;
				}
				break;
            case IDM_EXIT:
                DestroyWindow(hWnd);
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
			separate_window(hdc);
            EndPaint(hWnd, &ps);
        }
        break;
    case WM_DESTROY:
		activated = false;
		for (int i = 0; i < THREADS_COUNT; i++) {
			int killed = WaitForSingleObject(threads[i], 50);

			if (WAIT_OBJECT_0) {
				TerminateThread(threads[i], 0);
			}
			DeleteCriticalSection(&critical_section);
		}
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}
