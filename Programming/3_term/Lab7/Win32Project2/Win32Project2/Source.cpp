// GT_HelloWorldWin32.cpp
// compile with: /D_UNICODE /DUNICODE /DWIN32 /D_WINDOWS /c

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <cstring>
#include <tchar.h>
#include <vector>
#include <gdiplus.h>

using namespace Gdiplus;
#pragma comment (lib,"Gdiplus.lib")

int thickness = 2;
int currentColor = 0;

const int TOOLS_NUM = 3;
bool tool[] = { false, false, false };
// Pen, smth, Fill

COLORREF colors[] = {
	RGB(1, 1, 1),
	RGB(255, 255, 255),
	RGB(255, 0, 0),
	RGB(0, 255, 0),
	RGB(0, 0, 255),
	RGB(255, 0, 255)
};

int thicknesses[] = { 2, 4, 8, 16 };
const int THICKNESS_SIZE = 4;

const int RECT_SIZE = 30;
const int SELECTED = 5;
std::vector<std::pair<int, int> > rects;
std::vector<std::pair<int, int> > thick;


// The main window class name.
static TCHAR szWindowClass[] = _T("win32app");
static TCHAR szTitle[] = _T("MyPain");

HINSTANCE hInst;
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

HWND clear_button;
HWND pen_button;
HWND figure_button;
HWND background_button;


void drawLevy(HDC hdc, int xa, int ya, int xc, int yc, int i) {
	if (i == 0) {
		HPEN c;
		c = CreatePen(PS_SOLID, thicknesses[thickness], colors[currentColor]);
		SelectObject(hdc, c);	
		MoveToEx(hdc, xa, ya, NULL);
		if (yc <35 || ya <= 35) {
			return;
		}
		LineTo(hdc, xc, yc);
		DeleteObject(c);
	}
	else {
		int xb = (xa + xc) / 2 + (yc - ya) / 2;
		int yb = (ya + yc) / 2 - (xc - xa) / 2;
		drawLevy(hdc, xa, ya, xb, yb, i - 1);
		drawLevy(hdc, xb, yb, xc, yc, i - 1);
	}
}


void draw_colors(HDC hdc, int x, int y, int n) {
	for (int i = 0; i < n; i++) {
		for (int nx = i * RECT_SIZE + x; nx <= x + (i + 1) * RECT_SIZE; nx++) {
			for (int ny = y; ny <= RECT_SIZE + y; ny++) {
				SetPixel(hdc, nx, ny, colors[i]);
			}
		}
		rects.push_back(std::make_pair(i * 30 + x, y));
	}
}

std::string to_string(int a) {

	std::string res = "";
	while (a > 0) {
		res += (char)((a % 10) + '0');
		a /= 10;
	}
	reverse(res.begin(), res.end());
	return res;
}

void draw_thicknesses(HWND hWnd, int x, int y, int n) {
	for (int i = 0; i < n; i++) {
		std::string str = to_string(thicknesses[i]) + "pt";
		TCHAR *param = new TCHAR[str.size() + 1];
		param[str.size()] = '\0';
		//As much as we'd love to, we can't use memcpy() because
		//sizeof(TCHAR)==sizeof(char) may not be true:
		std::copy(str.begin(), str.end(), param);
		HWND hWndExample = CreateWindow(_T("STATIC"), param,
			WS_VISIBLE | WS_CHILD | SS_CENTER,
			x + i * RECT_SIZE, y, RECT_SIZE + 1, RECT_SIZE + 1, hWnd, NULL, NULL, NULL);
		thick.push_back(std::make_pair(i * RECT_SIZE + x, y));
	}
}

void color_rect(HDC hdc, int num, int color) {
	int x = rects[num].first;
	int y = rects[num].second;

	for (int i = x; i <= x + RECT_SIZE; i++) {
		for (int j = y; j <= y + RECT_SIZE; j++) {
			if ((i >= x && i <= x + 2)
				|| (j >= y && j <= y + 2)
				|| (i >= x + RECT_SIZE - 2 && i <= x + RECT_SIZE)
				|| (j >= y + RECT_SIZE - 2 && j <= y + RECT_SIZE)) {
				SetPixel(hdc, i, j, colors[color]);
			}
		}
	}
}


void color_thick(HDC hdc, int num, int color) {
	int x = thick[num].first;
	int y = thick[num].second;

	for (int i = x; i <= x + RECT_SIZE; i++) {
		for (int j = y; j <= y + RECT_SIZE; j++) {
			if ((i >= x && i <= x + 2)
				|| (j >= y && j <= y + 2)
				|| (i >= x + RECT_SIZE - 2 && i <= x + RECT_SIZE)
				|| (j >= y + RECT_SIZE - 2 && j <= y + RECT_SIZE)) {
				SetPixel(hdc, i, j, colors[color]);
			}
		}
	}
}

void selectSize(HDC hdc, int new_size) {
	color_thick(hdc, thickness, 1);
	color_thick(hdc, new_size, SELECTED);
	thickness = new_size;
}

void selectColor(HDC hdc, int new_color) {
	color_rect(hdc, currentColor, currentColor);
	color_rect(hdc, new_color, SELECTED);
	currentColor = new_color;
}

int isThicknessSelected(int x, int y) {
	for (int i = 0; i < (int)thick.size(); i++) {
		int lx = thick[i].first;
		int ly = thick[i].second;
		int rx = lx + RECT_SIZE;
		int ry = ly + RECT_SIZE;

		if (lx <= x && x <= rx
			&& ly <= y && y <= ry) {
			return i;
		}
	}
	return -1;
}

int isColorSelected(int x, int y) {
	for (int i = 0; i < SELECTED; i++) {
		int lx = rects[i].first;
		int ly = rects[i].second;
		int rx = lx + RECT_SIZE;
		int ry = ly + RECT_SIZE;

		if (lx <= x && x <= rx
			&& ly <= y && y <= ry) {
			return i;
		}
	}
	return -1;
}


int dist(int x1, int y1, int x2, int y2) {
	return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
}

void draw_pixel(HDC hdc, WORD x, WORD y) {
	for (int i = x - 16; i < x + 16; i++) {
		for (int j = y - 16; j < y + 16; j++) {
			if (j > 31 && j < 600 &&
				i > 1 && i < 800 &&
				dist(x, y, i, j) <= thicknesses[thickness] * thicknesses[thickness]) {
				SetPixel(hdc, i, j, colors[currentColor]);
			}
		}
	}
}

int WINAPI WinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR lpCmdLine,
	int nCmdShow)
{
	WNDCLASSEX wcex;
	GdiplusStartupInput gdiplusStartupInput;
	ULONG_PTR           gdiplusToken;

	// Initialize GDI+.
	GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

	wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

	if (!RegisterClassEx(&wcex))
	{
		MessageBox(NULL,
			_T("Call to RegisterClassEx failed!"),
			_T("Win32 Guided Tour"),
			NULL);

		return 1;
	}

	hInst = hInstance; // Store instance handle in our global variable

	// The parameters to CreateWindow explained:
	// szWindowClass: the name of the application
	// szTitle: the text that appears in the title bar
	// WS_OVERLAPPEDWINDOW: the type of window to create
	// CW_USEDEFAULT, CW_USEDEFAULT: initial position (x, y)
	// 500, 100: initial size (width, length)
	// NULL: the parent of this window
	// NULL: this application does not have a menu bar
	// hInstance: the first parameter from WinMain
	// NULL: not used in this application
	HWND hWnd = CreateWindow(
		szWindowClass,
		szTitle,
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, CW_USEDEFAULT,
		800, 600,
		NULL,
		NULL,
		hInstance,
		NULL
		);

	if (!hWnd)
	{
		MessageBox(NULL,
			_T("Call to CreateWindow failed!"),
			_T("Win32 Guided Tour"),
			NULL);

		return 1;
	}

	// The parameters to ShowWindow explained:
	// hWnd: the value returned from CreateWindow
	// nCmdShow: the fourth parameter from WinMain
	ShowWindow(hWnd,
		nCmdShow);
	UpdateWindow(hWnd);

	// Main message loop:
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	GdiplusShutdown(gdiplusToken);
	return (int)msg.wParam;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_PAINT    - Paint the main window
//  WM_DESTROY  - post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	PAINTSTRUCT ps;
	HDC hdc;

	switch (message)
	{
	case WM_CREATE:
		clear_button = CreateWindow(_T("BUTTON"),
			_T("Clear"),
			WS_VISIBLE | WS_CHILD | WS_BORDER,
			0, 0, 50, 30,
			hWnd, (HMENU)1, NULL, NULL);
		pen_button = CreateWindow(_T("BUTTON"),
			_T("Pen"),
			WS_VISIBLE | WS_CHILD | WS_BORDER,
			50, 0, 50, 30,
			hWnd, (HMENU)2, NULL, NULL);
		figure_button = CreateWindow(_T("BUTTON"),
			_T("Smt"),
			WS_VISIBLE | WS_CHILD | WS_BORDER,
			100, 0, 50, 30,
			hWnd, (HMENU)3, NULL, NULL);
		background_button = CreateWindow(_T("BUTTON"),
			_T("Fill"),
			WS_VISIBLE | WS_CHILD | WS_BORDER,
			150, 0, 100, 30,
			hWnd, (HMENU)4, NULL, NULL);
		break;
	case WM_PAINT:
		hdc = BeginPaint(hWnd, &ps);
		draw_colors(hdc, 250, 0, SELECTED);
		draw_thicknesses(hWnd, 250 + SELECTED * RECT_SIZE, 0, THICKNESS_SIZE);
		HBRUSH c;
		c = CreateSolidBrush(RGB(0, 0, 0));
		SelectObject(hdc, c);
		MoveToEx(hdc, 0, 31, NULL);
		LineTo(hdc, 800, 31);
		LineTo(hdc, 800, 600);
		LineTo(hdc, 0, 600);
		LineTo(hdc, 0, 30);
		selectColor(hdc, 0);
		selectSize(hdc, 0);
		EndPaint(hWnd, &ps);
		break;
	case WM_COMMAND:
		for (int i = 0; i < TOOLS_NUM; i++) {
			tool[i] = false;
		}
		switch (LOWORD(wParam))
		{
		case 1:
			RECT work_area;
			work_area = { 0, 31, 800, 600 };
			InvalidateRect(hWnd, &work_area, true);
			UpdateWindow(hWnd);
			break;
		case 2:
			tool[0] = true;
			break;
		case 3:
			tool[1] = true;
			break;
		case 4:
			tool[2] = true;
			break;
		}
		break;
	case WM_MOUSEMOVE:
		hdc = GetDC(hWnd);
		if (tool[0]) {
			if (GetKeyState(VK_LBUTTON) & 0x8000) {
				WORD xPos, yPos, nSize;
				xPos = LOWORD(lParam);
				yPos = HIWORD(lParam);
				draw_pixel(hdc, xPos, yPos);
			}
		}
		ReleaseDC(hWnd, hdc);
		break;
	case WM_LBUTTONDOWN:
		hdc = GetDC(hWnd);
		WORD xPos, yPos;
		xPos = LOWORD(lParam);
		yPos = HIWORD(lParam);
		int colorSelected;
		colorSelected = isColorSelected(xPos, yPos);
		if (colorSelected != -1) {
			selectColor(hdc, colorSelected);
			break;
		}
		int thickSelected;
		thickSelected = isThicknessSelected(xPos, yPos);
		if (thickSelected != -1) {
			selectSize(hdc, thickSelected);
			break;
		}

		if (tool[1]) {
			drawLevy(hdc, xPos - 70, yPos + 35, xPos + 70, yPos + 35, 10);
		}
		else
		if (tool[2]) {
			if (yPos > 31 && yPos < 600 &&
				xPos > 0 && xPos < 800) {
				HBRUSH c;
				c = CreateSolidBrush(colors[currentColor]);
				SelectObject(hdc, c);
				FloodFill(hdc, xPos, yPos, RGB(0, 0, 0));
				DeleteObject(c);
			}
		}
		ReleaseDC(hWnd, hdc);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
		break;
	}

	return 0;
}
