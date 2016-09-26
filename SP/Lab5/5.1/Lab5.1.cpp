// Lab5.1.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Lab5.1.h"

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

HWND color_radiogroup;
HWND shape_radiogroup;
HWND checkbox_draw;
HWND target_hwnd;

UINT WM_SETCOLOR;
UINT WM_SETSHAPE;
UINT WM_DISACTIV;

struct State {
	int color;
	int shape;
	int active;
} current_state;



void collect_data(HWND hWnd) {
	if (IsDlgButtonChecked(hWnd, IDC_CHECKBOX_DRAW) == BST_CHECKED) {
		current_state.active = 1;
	} else
	{
		current_state.active = 0;
	}

	if (IsDlgButtonChecked(color_radiogroup, IDC_RED_RADIO) == BST_CHECKED) {
		current_state.color = IDD_COLOR_RED;
	} else
	if (IsDlgButtonChecked(color_radiogroup, IDC_GREEN_RADIO) == BST_CHECKED) {
		current_state.color = IDD_COLOR_GREEN;
	} else
	if (IsDlgButtonChecked(color_radiogroup, IDC_BLUE_RADIO) == BST_CHECKED) {
		current_state.color = IDD_COLOR_BLUE;
	} else {
		current_state.color = IDD_UNDEFINDED;
	}


	if (IsDlgButtonChecked(shape_radiogroup, IDC_DIAMOND_RADIO) == BST_CHECKED) {
		current_state.shape = IDD_SHAPE_DIAMOND;
	} else
	if (IsDlgButtonChecked(shape_radiogroup, IDC_SQUARE_RADIO) == BST_CHECKED) {
		current_state.shape = IDD_SHAPE_SQUARE;
	} else
	if (IsDlgButtonChecked(shape_radiogroup, IDC_CIRCLE_RADIO) == BST_CHECKED) {
		current_state.shape = IDD_SHAPE_CIRCLE;
	} else
	if (IsDlgButtonChecked(shape_radiogroup, IDC_STAR_RADIO) == BST_CHECKED) {
		current_state.shape = IDD_SHAPE_STAR;
	} else
	{
		current_state.shape = IDD_UNDEFINDED;
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
    LoadStringW(hInstance, IDC_LAB51, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
return FALSE;
	}

	HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB51));

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

	return (int)msg.wParam;
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

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB51));
	wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = MAKEINTRESOURCEW(IDC_LAB51);
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

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
		SetWindowText(hWnd, L"Sender");
		color_radiogroup = CreateWindow(L"BUTTON", L"Color", WS_VISIBLE | WS_CHILD | BS_GROUPBOX,
			50, 50, 100, 100, hWnd, NULL, hInst, NULL);
 		CreateWindow(L"BUTTON", L"Red", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 20, 60, 10, color_radiogroup, (HMENU)IDC_RED_RADIO, hInst, NULL);
		CreateWindow(L"BUTTON", L"Green", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 40, 60, 10, color_radiogroup, (HMENU)IDC_GREEN_RADIO, hInst, NULL);
		CreateWindow(L"BUTTON", L"Blue", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 60, 60, 10, color_radiogroup, (HMENU)IDC_BLUE_RADIO, hInst, NULL);

		shape_radiogroup = CreateWindow(L"BUTTON", L"Shape", WS_VISIBLE | WS_CHILD | BS_GROUPBOX,
			150, 50, 100, 100, hWnd, NULL, hInst, NULL);
		CreateWindow(L"BUTTON", L"Diamond", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 20, 80, 10, shape_radiogroup, (HMENU)IDC_DIAMOND_RADIO, hInst, NULL);
		CreateWindow(L"BUTTON", L"Square", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 40, 80, 10, shape_radiogroup, (HMENU)IDC_SQUARE_RADIO, hInst, NULL);
		CreateWindow(L"BUTTON", L"Circle", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 60, 80, 10, shape_radiogroup, (HMENU)IDC_CIRCLE_RADIO, hInst, NULL);
		CreateWindow(L"BUTTON", L"Star", WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,
			7, 80, 80, 10, shape_radiogroup, (HMENU)IDC_STAR_RADIO, hInst, NULL);
		checkbox_draw = CreateWindow(L"BUTTON", L"Draw", WS_VISIBLE | WS_CHILD | BS_CHECKBOX,
			50, 155, 80, 10, hWnd, (HMENU)IDC_CHECKBOX_DRAW, hInst, NULL);

		WM_SETCOLOR = RegisterWindowMessage(L"set_drawing_color");
		WM_SETSHAPE = RegisterWindowMessage(L"set_drawing_shape");
		WM_DISACTIV = RegisterWindowMessage(L"dis_activate");

		SetTimer(hWnd, IDT_TIMER1, 100, NULL);
		break;
	}
	case WM_TIMER:
	{
		switch (wParam) {
		case IDT_TIMER1:
			collect_data(hWnd);
			target_hwnd = FindWindow(NULL, L"Accessor");
			if (target_hwnd != NULL) {
				SendMessage(target_hwnd, WM_SETCOLOR, (WPARAM)current_state.color, NULL);
				SendMessage(target_hwnd, WM_SETSHAPE, (WPARAM)current_state.shape, NULL);
				SendMessage(target_hwnd, WM_DISACTIV, (WPARAM)current_state.active, NULL);
			}
			break;
		}
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
			case IDC_CHECKBOX_DRAW:
			{
				bool checked = IsDlgButtonChecked(hWnd, IDC_CHECKBOX_DRAW);
				if (!checked) {
					CheckDlgButton(hWnd, IDC_CHECKBOX_DRAW, BST_CHECKED);
				}
				else {
					CheckDlgButton(hWnd, IDC_CHECKBOX_DRAW, BST_UNCHECKED);
				}
				break;
			}
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