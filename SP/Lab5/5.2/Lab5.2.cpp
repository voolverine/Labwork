// Lab5.2.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Lab5.2.h"
#include <cmath>

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
UINT WM_SETCOLOR;
UINT WM_SETSHAPE;
UINT WM_DISACTIV;

HBRUSH red_brush;
HBRUSH blue_brush;
HBRUSH green_brush;
HPEN red_pen;
HPEN blue_pen;
HPEN green_pen;

struct State {
	int color;
	int shape;
	int active;
} current_state;

const int BASE_SIZE = 25;


void draw_diamond(HDC hdc, int x, int y) {
	POINT pt[4];
	pt[0].x = x;
	pt[0].y = y - (int)(BASE_SIZE * 0.8);
	pt[1].x = x + (int)(BASE_SIZE * 1.2);
	pt[1].y = y;
	pt[2].x = x;
	pt[2].y = y + (int)(BASE_SIZE * 0.8);
	pt[3].x = x - (int)(BASE_SIZE * 1.2);
	pt[3].y = y;

	Polygon(hdc, pt, 4);
}

void draw_square(HDC hdc, int x, int y) {
	Rectangle(hdc, x - BASE_SIZE, y - BASE_SIZE, x + BASE_SIZE, y + BASE_SIZE);
}

void draw_circle(HDC hdc, int x, int y) {
	Ellipse(hdc, x - BASE_SIZE, y - BASE_SIZE, x + BASE_SIZE, y + BASE_SIZE);
}

const double pi = 3.14159265359;

void draw_star(HDC hdc, int x, int y) {
	POINT pt[10];
	int radius = (int) (BASE_SIZE * 2.0);
	pt[0].x = x - radius / 2;
	pt[0].y = y + radius / 2;

	double current_angle = 0;

	for (int i = 1; i < 10; i++) {
		current_angle += 108.0 * pi / 180.0;
		pt[i].x = pt[i - 1].x + (int)(radius * sin(current_angle));
		pt[i].y = pt[i - 1].y + (int)(radius * cos(current_angle));
	}

	Polygon(hdc, pt, 10);
}


void handle_mouse_click(HWND hWnd, HDC hdc, int x, int y) {
	if (!current_state.active) {
		return;
	}

	switch (current_state.color) {
	case IDD_COLOR_RED:
		SelectObject(hdc, red_brush);
		SelectObject(hdc, red_pen);
		break;
	case IDD_COLOR_GREEN:
		SelectObject(hdc, green_brush);
		SelectObject(hdc, green_pen);
		break;
	case IDD_COLOR_BLUE:
		SelectObject(hdc, blue_brush);
		SelectObject(hdc, blue_pen);
		break;
	case IDD_UNDEFINDED:
		MessageBox(hWnd, L"Color is not selected", L"OK", MB_OK);
		return;
	}

	switch (current_state.shape) {
	case IDD_SHAPE_DIAMOND:
		draw_diamond(hdc, x, y);
		break;
	case IDD_SHAPE_SQUARE:
		draw_square(hdc, x , y);
		break;
	case IDD_SHAPE_CIRCLE:
		draw_circle(hdc, x, y);
		break;
	case IDD_SHAPE_STAR:
		draw_star(hdc, x, y);
		break;
	case IDD_UNDEFINDED:
		MessageBox(hWnd, L"Shape is not selected", L"OK", MB_OK);
		return;
		break;
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
    LoadStringW(hInstance, IDC_LAB52, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB52));

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
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB52));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_LAB52);
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
	if (WM_SETCOLOR != NULL && message == WM_SETCOLOR) {
		current_state.color = (int)wParam;
		return 0;
	} else
	if (WM_SETSHAPE != NULL && message == WM_SETSHAPE) {
		current_state.shape = (int)wParam;
		return 0;
	} else
	if (WM_DISACTIV != NULL && message == WM_DISACTIV) {
		current_state.active = (int)wParam;
		return 0;
	}

    switch (message)
    {
	case WM_CREATE:
		SetWindowText(hWnd, L"Accessor");
		WM_SETCOLOR = RegisterWindowMessage(L"set_drawing_color");
		WM_SETSHAPE = RegisterWindowMessage(L"set_drawing_shape");
		WM_DISACTIV = RegisterWindowMessage(L"dis_activate");
		red_brush = CreateSolidBrush(RGB(255, 0, 0));
		green_brush = CreateSolidBrush(RGB(0, 255, 0));
		blue_brush = CreateSolidBrush(RGB(0, 0, 255));

		red_pen = CreatePen(PS_SOLID, 1, RGB(255, 0, 0));
		green_pen = CreatePen(PS_SOLID, 1, RGB(0, 255, 0));
		blue_pen = CreatePen(PS_SOLID, 1, RGB(0, 0, 255));
		break;
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            // Parse the menu selections:
            switch (wmId)
            {
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
	case WM_LBUTTONDOWN:
	{	
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		handle_mouse_click(hWnd, GetDC(hWnd), x, y);
		break;
	}
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}