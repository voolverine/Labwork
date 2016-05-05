// ConsoleApplication2.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <conio.h>
#include <iostream>
#include <string>

const char KEYCODE_BACKSPACE = 8;
const char KEYCODE_ENTER = '\r';
const char KEYCODE_MINUS = '-';
const char KEYCODE_DOT = '.';

using namespace std;


float a[8] = { 1.5, 4.0, 103.0, 4.128, 2.9, 6.0, 7.0, 91.11 };
float b[8] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 9.0 };
float c[8] = { 1.0, 2.33, 5.0, 41.0, 8.0, 6.0, 7.9, 8.0 };
double d[8] = { 1.0, 2.0, 32.0, 4.0, 22.0, 6.0, 2.0, 1.12 };
double f[8] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };


double nextFP() {
	int length = 0;
	double res = 0;
	bool negative = false;
	int dot = 0;

	while (true) {
		char ch = _getch();

		if (ch == KEYCODE_ENTER) {
			if (length == 0 || 
				(length == 1 && negative) || 
				(dot == 1)) {
				continue;
			}
			else {
				return res * (negative ? -1 : 1);
			}
		} else
		if (ch == KEYCODE_BACKSPACE) {
			if (length == 0) {
				continue;
			}

			cout << "\b \b";
			if (dot == 1) {
				dot = 0;
				length--;
				continue;
			}

			if (length == 1 && negative) {
				negative = false;
				length--;
				continue;
			}
			
			if (dot > 1) {
				dot--;
			}
			length--;
			double dec = pow(10, -1 * dot + 1);
			res -= fmod(res, dec);
			if (dot == 0) {
				res /= 10.0;
			}
		} else
		if (ch == KEYCODE_MINUS) {
			if (length == 0) {
				negative = true;
				length++;
				cout << ch;
			}
			continue;
		} else
		if (ch == KEYCODE_DOT) {
			if (length == 0 || (length == 1 && negative) || dot != 0) {
				continue;
			}
			length++;
			dot++;
			cout << '.';
		}
		else
		if ('0' <= ch && ch <= '9') {
			if (length >= 10) {
				continue;
			}
			if (dot == 0) {
				res *= 10;
				res += (ch - '0');
			}
			else {
				res += (ch - '0') * pow(10.0, -dot);
				dot++;
			}
			cout << ch;
			length++;
		}
	}
}


void read_FloatArr(float *arr, int n, string name) {
	for (int i = 0; i < n; i++) {
		cout << name + "[" << i + 1 << "] = ";
		arr[i] = (float)nextFP();
		cout << endl;
	}
}


void read_DoubleArr(double *arr, int n, string name) {
	for (int i = 0; i < n; i++) {
		cout << name + "[" << i + 1 << "] = ";
		arr[i] = (double)nextFP();
		cout << endl;
	}
}


void printArr(double *arr, int n, string name) {
	cout << name << " = [ ";
	cout.precision(3);
	for (int i = 0; i < n; i++) {
		cout << arr[i] << " ";
	}
	cout << ']' << endl;
}

void printArr(float *arr, int n, string name) {
	cout << name << " = [ ";
	cout.precision(2);
	
	for (int i = 0; i < n; i++) {
		cout << arr[i] << " ";
	}
	cout << ']' << endl;
}

int _tmain(int argc, _TCHAR* argv[])
{
	/* ==================================================== INPUT
	cout << "F[i] = A[i] - (B[i] + C[i]) * D[i]" << endl;
	read_FloatArr(a, 8, "A");
	read_FloatArr(b, 8, "B");
	read_FloatArr(c, 8, "C");
	read_DoubleArr(d, 8, "D");
	   ==================================================== INPUT */

	cout << "F[i] = A[i] - (B[i] + C[i]) * D[i]\n";
	printArr(a, 8, "A");
	printArr(b, 8, "B");
	printArr(c, 8, "C");
	printArr(d, 8, "D");

	__asm {
		movups xmm0, b
		movups xmm1, b[TYPE b * 4]

		movups xmm2, c
		movups xmm3, c[TYPE c * 4]
		addps xmm0, xmm2
		addps xmm1, xmm3
	
		cvtps2pd xmm4, xmm0
		cvtps2pd xmm6, xmm1
		shufps xmm0, xmm0, 01001110b 
		shufps xmm1, xmm1, 01001110b 
		cvtps2pd xmm5, xmm0
		cvtps2pd xmm7, xmm1

		mulpd xmm4, d[TYPE d * 0]
		mulpd xmm5, d[TYPE d * 2]
		mulpd xmm6, d[TYPE d * 4]
		mulpd xmm7, d[TYPE d * 6]
		/*
		movups f[TYPE f * 0], xmm4
		movups f[TYPE f * 2], xmm5
		movups f[TYPE f * 4], xmm6
		movups f[TYPE f * 6], xmm7
		*/


		movups xmm0, a
		cvtps2pd xmm1, xmm0
		shufps xmm0, xmm0, 01001110b 
		cvtps2pd xmm2, xmm0

		subpd xmm1, xmm4
		subpd xmm2, xmm5
		movupd f[TYPE f * 0], xmm1
		movupd f[TYPE f * 2], xmm2

		movups xmm0, a[TYPE a * 4]
		cvtps2pd xmm1, xmm0
		shufps xmm0, xmm0, 01001110b 
		cvtps2pd xmm2, xmm0

		subpd xmm1, xmm6
		subpd xmm2, xmm7
		movupd f[TYPE f * 4], xmm1
		movupd f[TYPE f * 6], xmm2
	}
	
	cout << endl;
	printArr(f, 8, "F");
	system("pause");
	return 0;
}

