// ConsoleApplication1.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdio.h>
#include <conio.h>
#include <iostream>
#include <string>


const char KEYCODE_BACKSPACE = 8;
const char KEYCODE_ENTER = '\r';
const char KEYCODE_MINUS = '-';


__int8 a[8] = { 2, 3, 4, 5, 6, 7, 8, 0 };
__int8 b[8] = { 2, 3, 4, 5, 6, 7, 8, 5 };
__int8 c[8] = { 1, 2, 3, 4, 5, 6, 7, 4 };
__int16 d[8] = { 1, 2, 3, 4, 5, 6, 7, 3500 };
__int16 f[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };

using namespace std;

int nextInt(int size) {
	size--;
	int minimal = (1 << size) * (-1);
	int maximal = (1 << size) - 1;

	bool negative = false;
	int cur = 0;
	string s = "";

	while (42) {
		char ch = _getch();
		if (ch == KEYCODE_ENTER) {
			if ((int)s.size() == 0) {
				continue;
			} else
			if ((int)s.size() == 1 && negative) {
				continue;
			}
			else {
				if (negative)  {
					cur *= -1;
				}
				return cur;
			}
		}

		if (ch == KEYCODE_BACKSPACE) {
			if ((int)s.size() == 0) {
				continue;
			} else
			if ((int)s.size() == 1 && negative) {
				cout << '\b';
				negative = false;
				s = "";
				continue;
			}
			else {
				s.pop_back();
				cur /= 10;
				cout << '\b' << ' ' << '\b';
				continue;
			}
		}

		if (ch == KEYCODE_MINUS) {
			if ((int)s.size() == 0) {
				s = "-";
				negative = true;
				cout << '-';
			}
			else {
				continue;
			}
		}

		if (ch >= '0' && ch <= '9') {
			int newc = cur * 10 + (ch - '0');
			if (negative) {
				newc *= -1;
			}

			if (minimal <= newc && newc <= maximal) {
				cur = abs(newc);
				s += ch;
				cout << ch;
			}
		}
	}

	return cur * (negative ? -1 : 1);
}


void read_int8arr(__int8 *arr, int n, string name) {
	for (int i = 0; i < n; i++) {
		cout << name + "[" << i + 1 << "] = ";
		arr[i] = (__int8)nextInt(8);
		cout << endl;
	}
}


void read_int16arr(__int16 *arr, int n, string name) {
	for (int i = 0; i < n; i++) {
		cout << name + "[" << i + 1 << "] = ";
		arr[i] = (__int16)nextInt(16);
		cout << endl;
	}
}


void show_arr(__int8 *arr, int n, string name) {
	cout << name << " = [";
	for (int i = 0; i < n; i++) {
		cout << (int)arr[i];
		if (i < n - 1) {
			cout << ", ";
		}
	}
	cout << ']' << endl;
}


void show_arr(__int16 *arr, int n, string name) {
	cout << name << " = [";
	for (int i = 0; i < n; i++) {
		cout << (int)arr[i];
		if (i < n - 1) {
			cout << ", ";
		}
	}
	cout << ']' << endl;
}



int _tmain(int argc, _TCHAR* argv[])
{
	/* =============================================================== INPUT
	cout << "F[i] = A[i] - (B[i] + C[i]) * D[i]" << endl;
	read_int8arr(a, 8, "A");
	read_int8arr(b, 8, "B");
	read_int8arr(c, 8, "C");
	read_int16arr(d, 8, "D");
	   =============================================================== INPUT */

	cout << "F[i] = A[i] - (B[i] + C[i]) * D[i]" << endl;
	show_arr(a, 8, "A");
	show_arr(b, 8, "B");
	show_arr(c, 8, "C");
	show_arr(d, 8, "D");

	__asm{

		movq mm0, b
		paddb mm0, c

		movq mm1, mm0
		pxor mm4, mm4
		pcmpgtb mm4, mm0
		punpcklbw mm1, mm4
		punpckhbw mm0, mm4

		pmullw mm0, d[TYPE d * 0]
		pmullw mm1, d[TYPE d * 4]

		movq mm2, a
		movq mm3, mm2
		pxor mm4, mm4
		pcmpgtb mm4, mm2
		punpcklbw mm2, mm4
		punpckhbw mm3, mm4

		psubsw mm2, mm0
		psubsw mm3, mm1

		movq f[TYPE f * 0], mm2 
		movq f[TYPE f * 4], mm3
	}

	show_arr(f, 8, "F");

	system("pause");
	return 0;
}

