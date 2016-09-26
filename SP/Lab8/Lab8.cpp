// Lab8.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Lab8.h"
#include "Monitor.h"

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

HWND listbox1;
HWND listbox2;
Monitor *monitor;
HMENU hPopupMenu;

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
    LoadStringW(hInstance, IDC_LAB8, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB8));

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
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB8));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_LAB8);
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
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, nullptr, nullptr, hInstance, nullptr);

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
	{
		listbox1 = CreateWindow(L"LISTBOX", L"Process", WS_VISIBLE | WS_BORDER | WS_CHILD | WS_VSCROLL,
			50, 50, 400, 400, hWnd, (HMENU)IDL_LISTBOX1, hInst, NULL);
		listbox2 = CreateWindow(L"LISTBOX", L"Process", WS_VISIBLE | WS_BORDER | WS_CHILD | WS_VSCROLL,
			450, 50, 400, 400, hWnd, (HMENU)IDL_LISTBOX1, hInst, NULL);
		monitor = new Monitor(listbox1, listbox2);
		monitor->run();


		break;
	}
	case WM_CONTEXTMENU:
	{
		hPopupMenu = CreatePopupMenu();
		InsertMenu(hPopupMenu, 0, MF_BYPOSITION | MF_STRING, IPM_PRIORITY_IDLE, L"Idle priority");
		InsertMenu(hPopupMenu, 0, MF_BYPOSITION | MF_STRING, IPM_PRIORITY_NORMAL, L"Normal priority");
		InsertMenu(hPopupMenu, 0, MF_BYPOSITION | MF_STRING, IPM_PRIORITY_HIGH, L"High priority");
		InsertMenu(hPopupMenu, 0, MF_BYPOSITION | MF_STRING, IPM_PRIORITY_REALTIME, L"Realtime priority");

		POINT pt;
		GetCursorPos(&pt);
		int dx = pt.x;
		int dy = pt.y;
		ScreenToClient(hWnd, &pt);
		dx -= pt.x;
		dy -= pt.y;
		
		if (pt.x < 50 || pt.x > 450 || pt.y < 50 || pt.y > 450) {
			break;;
		}
		
		TrackPopupMenu(hPopupMenu, TPM_BOTTOMALIGN | TPM_LEFTALIGN, pt.x + dx, pt.y + dy, 0, hWnd, NULL);
		DestroyMenu(hPopupMenu);
		break;
	}
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            // Parse the menu selections:
            switch (wmId)
            {
            case IDM_EXIT:
                DestroyWindow(hWnd);
                break;
			case IPM_PRIORITY_IDLE:
				monitor->change_priority(IDLE_PRIORITY_CLASS);
				break;
			case IPM_PRIORITY_NORMAL:
				monitor->change_priority(NORMAL_PRIORITY_CLASS);
				break;
			case IPM_PRIORITY_HIGH:
				monitor->change_priority(HIGH_PRIORITY_CLASS);
				break;
			case IPM_PRIORITY_REALTIME:
				monitor->change_priority(REALTIME_PRIORITY_CLASS);
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