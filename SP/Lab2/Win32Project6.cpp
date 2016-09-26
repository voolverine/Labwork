// Win32Project6.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Win32Project6.h"
#include "Boxes.h"

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

HWND listbox1, listbox2;
HWND button_add, button_clear, button_delete, button_to_right;
HWND edit;
Boxes *boxes;

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
    LoadStringW(hInstance, IDC_WIN32PROJECT6, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32PROJECT6));

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
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_WIN32PROJECT6));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_WIN32PROJECT6);
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
      CW_USEDEFAULT, 0, 800, 600, nullptr, nullptr, hInstance, nullptr);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}


void window_elements_initilisation(HWND hWnd) {
	listbox1 = CreateWindow(_T("LISTBOX"), _T("First Listbox"), WS_VISIBLE | WS_HSCROLL | WS_VSCROLL
		| WS_CHILD | WS_BORDER, 100, 10, 200, 300, hWnd, (HMENU)IDC_LISTBOX_1, hInst, NULL);
	listbox2 = CreateWindow(_T("LISTBOX"), _T("Second Listbox"), WS_VISIBLE | WS_HSCROLL | WS_VSCROLL
		| WS_CHILD | WS_BORDER, 340, 10, 200, 300, hWnd, (HMENU)IDC_LISTBOX_2, hInst, NULL);
	edit = CreateWindow(_T("EDIT"), _T("EDIT"), WS_VISIBLE | WS_CHILD | WS_BORDER,
		100, 310, 200, 20, hWnd, (HMENU)IDC_EDIT, hInst, NULL);
	SendMessage(edit, WM_SETTEXT, NULL, (LPARAM)(L""));

	button_add = CreateWindow(_T("BUTTON"), _T("Add"), WS_VISIBLE | WS_BORDER | WS_CHILD,
		302, 310, 36, 20, hWnd, (HMENU)IDC_BUTTON_ADD, hInst, NULL);
	button_to_right = CreateWindow(_T("BUTTON"), _T("\u2192"), WS_VISIBLE | WS_BORDER | WS_CHILD,
		302, 145, 36, 20, hWnd, (HMENU)IDC_BUTTON_TORIGHT, hInst, NULL);
	button_delete = CreateWindow(_T("BUTTON"), _T("Delete"), WS_VISIBLE | WS_BORDER | WS_CHILD,
		340, 310, 50, 20, hWnd, (HMENU)IDC_BUTTON_DELETE, hInst, NULL);
	button_clear = CreateWindow(_T("BUTTON"), _T("Clear"), WS_VISIBLE | WS_BORDER | WS_CHILD,
		490, 310, 50, 20, hWnd, (HMENU)IDC_BUTTON_CLEAR, hInst, NULL);

	boxes = new Boxes(edit, listbox1, listbox2);
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
		window_elements_initilisation(hWnd);
		break;
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
			LPWSTR buffer[256];

            // Parse the menu selections:
            switch (wmId)
            {
			case IDC_BUTTON_ADD:
				boxes -> add_pressed();
				break;
			case IDC_BUTTON_DELETE:
				boxes -> delete_pressed();
				break;
			case IDC_BUTTON_TORIGHT:
			{
				boxes -> toright_pressed();
				break;
			}
			case IDC_BUTTON_CLEAR:
				boxes -> clear_pressed();
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