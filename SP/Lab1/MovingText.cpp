#include "stdafx.h"
#include "string.h"
#include "MovingText.h"


MovingText::MovingText(wchar_t *str, int x, int y,
									int minimum_x, int minimum_y,
									int maximum_x, int maximum_y,
									int h)
{
	wcscpy(moving_text, str);
	this -> x = x;
	this -> y = y;
	this -> minimum_x = minimum_x;
	this -> minimum_y = minimum_y;
	this -> maximum_x = maximum_x;
	this -> maximum_y = maximum_y;
	this -> h = h;
}

void MovingText::Move() {
	if (direction == "RIGHT") {
		x += h;
	} else
	if (direction == "LEFT") {
		x -= h;
	}

	if (x <= minimum_x && direction == "LEFT") {
		direction = "RIGHT";
	} else
	if (x >= maximum_x && direction == "RIGHT") {
		direction = "LEFT";
	}
}

void MovingText::Draw(HDC hdc) {
	TextOut(hdc, x, y, moving_text, wcslen(moving_text));
}

MovingText::~MovingText()
{
 	delete[] moving_text;
}
