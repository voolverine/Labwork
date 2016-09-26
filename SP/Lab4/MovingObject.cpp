#include "stdafx.h"
#include "MovingObject.h"
#include <cmath>


MovingObject::MovingObject(HDC hdc, int x, int y)
{
	current_x = x;
	current_y = y;
	target_x = x;
	target_y = y;

	shadow_hdc = CreateCompatibleDC(hdc);

	wchar_t left_base[100], right_base[100];
	wcsncpy(left_base, L"C:\\Users\\volverine\\Documents\\Visual Studio 2015\\Projects\\Win32Project8\\zbr_left_x.bmp", 100);
	wcsncpy(right_base, L"C:\\Users\\volverine\\Documents\\Visual Studio 2015\\Projects\\Win32Project8\\zbr_right_x.bmp", 100);

	for (int i = 1; i < 5; i++) {
		left_base[wcslen(left_base) - 5] = i + '0';
		right_base[wcslen(right_base) - 5] = i + '0';

		HANDLE handler_left = LoadImage(0,
			left_base,
			IMAGE_BITMAP,
			0, 0,
			LR_LOADFROMFILE | LR_CREATEDIBSECTION);
		left.push_back(handler_left);
		HANDLE handler_right = LoadImage(0,
			right_base,
			IMAGE_BITMAP,
			0, 0,
			LR_LOADFROMFILE | LR_CREATEDIBSECTION);
		right.push_back(handler_right);
	}
}


MovingObject::~MovingObject()
{
}

void MovingObject::Move() {
	if (current_x == target_x && current_y == target_y) {
		moved_in_current_cycle = false;
		return;
	}

	double best_dist = 1234567;
	int best_id = -1;

	for (int i = 0; i < D_SIZE; i++) {
		int new_x = current_x + dx[i];
		int new_y = current_y + dy[i];
		double possible_bast_dist = dist(new_x, new_y, target_x, target_y);
		if (possible_bast_dist < best_dist) {
			best_dist = possible_bast_dist;
			best_id = i;
		}
	}

	current_x += dx[best_id];
	current_y += dy[best_id];

	if (dx[best_id] > 0) {
		moving_left = false;
	}
	else {
		moving_left = true;
	}
	moved_in_current_cycle = true;
}

void MovingObject::setTarger(int x, int y) {
	target_x = x;
	target_y = y;
}

double MovingObject::dist(double x1, double y1, double x2, double y2) {
	return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
}

void MovingObject::draw(HDC hdc) {
	before_change--;
	if (before_change <= 0 && moved_in_current_cycle) {
		if (moving_left) {
			current_left = (current_left + 1) % (int)left.size();
		}
		else {
			current_right = (current_right + 1) % (int)right.size();
		}
		before_change = CHANGE_RATE;
	}
	
	if (moving_left) {
		SelectObject(shadow_hdc, left[current_left]);
	}
	else {
		SelectObject(shadow_hdc, right[current_right]);
	}

	BitBlt(hdc, current_x, current_y, 40, 32, shadow_hdc, 0, 0, SRCCOPY);
}
