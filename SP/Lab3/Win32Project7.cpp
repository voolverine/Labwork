// Win32Project7.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "Win32Project7.h"
#include "stdio.h"

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
HWND draw_button;
HWND clear_button;


void draw_picture(HDC hdc) {
	HPEN pen_1px = CreatePen(PS_SOLID, 1, RGB(0, 0, 0));
	SelectObject(hdc, pen_1px);
	Ellipse(hdc, 400, 100, 500, 200);

	HPEN pen_4px = CreatePen(PS_SOLID, 4, RGB(0, 0, 0));
	SelectObject(hdc, pen_4px);
	Arc(hdc, 400, 100, 500, 200, 400, 180, 400, 120);

	POINT first_ear[3];
	first_ear[0].x = 475;
	first_ear[0].y = 105;
	first_ear[1].x = 465;
	first_ear[1].y = 80;
	first_ear[2].x = 450;
	first_ear[2].y = 100;
	Polygon(hdc, first_ear, 3);


	POINT second_ear[3];
	second_ear[0].x = 410;
	second_ear[0].y = 115;
	second_ear[1].x = 420;
	second_ear[1].y = 80;
	second_ear[2].x = 435;
	second_ear[2].y = 100;
	Polygon(hdc, second_ear, 3);

	Rectangle(hdc, 360, 200, 450, 260);

	POINT first_leg[3];
	first_leg[0].x = 355;
	first_leg[0].y = 272;
	first_leg[1].x = 370;
	first_leg[1].y = 245;
	first_leg[2].x = 385;
	first_leg[2].y = 272;
	Polygon(hdc, first_leg, 3);

	POINT second_leg[3];
	second_leg[0].x = 425;
	second_leg[0].y = 272;
	second_leg[1].x = 440;
	second_leg[1].y = 245;
	second_leg[2].x = 455;
	second_leg[2].y = 272;
	Polygon(hdc, second_leg, 3);

	POINT tail[4];
	tail[0].x = 360;
	tail[0].y = 200;
	tail[1].x = 340;
	tail[1].y = 245;
	tail[2].x = 320;
	tail[2].y = 260;
	tail[3].x = 340;
	tail[3].y = 220;
	Polygon(hdc, tail, 4);

	MoveToEx(hdc, 407, 176, NULL);
	LineTo(hdc, 310, 176);
	LineTo(hdc, 310, 140);

	MoveToEx(hdc, 407, 116, NULL);
	LineTo(hdc, 330, 116);
	Pie(hdc, 292, 98, 330, 136, 330, 117, 311, 138);
	for (int i = 130; i < 140; i++) {
		SetPixel(hdc, 311, i, RGB(0, 0, 0));
		SetPixel(hdc, 310, i, RGB(0, 0, 0));
		SetPixel(hdc, 309, i, RGB(0, 0, 0));
		SetPixel(hdc, 308, i, RGB(0, 0, 0));
	}

	SelectObject(hdc, pen_1px);
	Ellipse(hdc, 425, 125, 445, 145);
	HBRUSH black_brush = CreateSolidBrush(RGB(0, 0, 0));
	SelectObject(hdc, black_brush);
	Ellipse(hdc, 425, 128, 440, 143);

	HPEN pen_2px = CreatePen(PS_SOLID, 2, RGB(0, 0, 0));
	SelectObject(hdc, pen_2px);
	MoveToEx(hdc, 410, 175, NULL);
	SelectObject(hdc, pen_1px);
	LineTo(hdc, 310, 190);
	MoveToEx(hdc, 315, 188, NULL);
	LineTo(hdc, 319, 182);
	LineTo(hdc, 323, 188);
	LineTo(hdc, 327, 180);
	LineTo(hdc, 332, 186);
	LineTo(hdc, 337, 180);
	LineTo(hdc, 342, 184);
	LineTo(hdc, 348, 179);
	LineTo(hdc, 352, 183);
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
    LoadStringW(hInstance, IDC_WIN32PROJECT7, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    if (!InitInstance (hInstance, nCmdShow))
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32PROJECT7));

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
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_WIN32PROJECT7));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_WIN32PROJECT7);
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
		draw_button = CreateWindow(_T("BUTTON"), _T(""), WS_BORDER | WS_VISIBLE | WS_CHILD | BS_OWNERDRAW,
			10, 10, 32, 32, hWnd, (HMENU)IDC_BUTTON_CREATE, hInst, NULL);
		clear_button = CreateWindow(_T("BUTTON"), _T(""), WS_BORDER | WS_VISIBLE | WS_CHILD | BS_OWNERDRAW,
			50, 10, 32, 32, hWnd, (HMENU)IDC_BUTTON_CLEAR, hInst, NULL);
		break;
	case WM_DRAWITEM:
	{
		int wmId = LOWORD(wParam);
		LPDRAWITEMSTRUCT dis = (LPDRAWITEMSTRUCT)lParam;
		HBRUSH background = CreateSolidBrush(RGB(149, 204, 75));
		FillRect(dis->hDC, &dis->rcItem, background);


		switch (wmId) {
		case IDC_BUTTON_CREATE:
		{
			POINT lpPoints[6];
			lpPoints[0].x = 6;
			lpPoints[0].y = 12;
			lpPoints[1].x = 12;
			lpPoints[1].y = 18;
			lpPoints[2].x = 26;
			lpPoints[2].y = 4;
			lpPoints[3].x = 30;
			lpPoints[3].y = 8;
			lpPoints[4].x = 12;
			lpPoints[4].y = 26;
			lpPoints[5].x = 2;
			lpPoints[5].y = 16;

			HBRUSH good_brush_color = CreateSolidBrush(RGB(25, 178, 158));
			SelectObject(dis->hDC, good_brush_color);
			HPEN good_pen_color = CreatePen(PS_SOLID, 1, RGB(25, 178, 158));
			SelectObject(dis->hDC, good_pen_color);
			Polygon(dis->hDC, lpPoints, 6);
			break;
		}
		case IDC_BUTTON_CLEAR:
			POINT lpPoints[12];
			lpPoints[0].x = 7;
			lpPoints[0].y = 3;
			lpPoints[1].x = 15;
			lpPoints[1].y = 11;
			lpPoints[2].x = 23;
			lpPoints[2].y = 3;
			lpPoints[3].x = 27;
			lpPoints[3].y = 7;
			lpPoints[4].x = 19;
			lpPoints[4].y = 15;
			lpPoints[5].x = 27;
			lpPoints[5].y = 23;
			lpPoints[6].x = 23;
			lpPoints[6].y = 27;
			lpPoints[7].x = 15;
			lpPoints[7].y = 19;
			lpPoints[8].x = 7;
			lpPoints[8].y = 27;
			lpPoints[9].x = 3;
			lpPoints[9].y = 23;
			lpPoints[10].x = 11;
			lpPoints[10].y = 15;
			lpPoints[11].x = 3;
			lpPoints[11].y = 7;

			HBRUSH good_brush_color = CreateSolidBrush(RGB(153, 88, 0));
			SelectObject(dis->hDC, good_brush_color);
			HPEN good_pen_color = CreatePen(PS_SOLID, 1, RGB(153, 88, 0));
			SelectObject(dis->hDC, good_pen_color);
			Polygon(dis->hDC, lpPoints, 12);
			break;
		}

		if (dis->itemState & ODS_SELECTED) {
			switch (dis->CtlID) {
			case IDC_BUTTON_CREATE:
				draw_picture(GetDC(hWnd));
				break;
			case IDC_BUTTON_CLEAR:
				RECT r;
				r = {60, 60, 600, 600};
				FillRect(GetDC(hWnd), &r, (HBRUSH)GetStockObject(WHITE_BRUSH));
				break;
			}
		}

		if (dis->itemState & ODS_FOCUS) {
			dis->rcItem.left += 1;
			dis->rcItem.top += 1;
			dis->rcItem.right -= 1;
			dis->rcItem.bottom -= 1;
			DrawFocusRect(dis->hDC, &dis->rcItem);
		}

		break;
	}
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            // Parse the menu selections:
			//MessageBox(hWnd, L"CLICK", L"OK", MB_OK);
            switch (wmId)
            {
            case IDM_ABOUT:
                DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
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

// Message handler for about box.
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
    UNREFERENCED_PARAMETER(lParam);
    switch (message)
    {
    case WM_INITDIALOG:
        return (INT_PTR)TRUE;

    case WM_COMMAND:
        if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
        {
            EndDialog(hDlg, LOWORD(wParam));
            return (INT_PTR)TRUE;
        }
        break;
    }
    return (INT_PTR)FALSE;
}
