#pragma once
class MovingText
{
private:
	wchar_t *moving_text = new wchar_t[30];
 	int x, y;
	int minimum_x, minimum_y;
	int maximum_x, maximum_y;
	int h;
	char *direction = "RIGHT";
public:
	MovingText(wchar_t *str, int x, int y, 
							int minimum_x, int minimum_y,
							int maximum_x, int maximum_y,
							int h);
	~MovingText();
	void Move();
	void Draw(HDC hdc);
};

