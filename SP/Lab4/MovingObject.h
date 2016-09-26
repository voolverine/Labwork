#include<vector>

#pragma once
class MovingObject
{
private:
	int current_x;
	int current_y;
	int target_x;
	int target_y;
	static const int D_SIZE = 81;
	static const int CHANGE_RATE = 2;
	HDC shadow_hdc;

	int current_left = 0;
	int current_right = 0;
	
	std::vector<HANDLE> left;
	std::vector<HANDLE> right;
	bool moving_left = true;
	bool moved_in_current_cycle = true;
	int before_change = CHANGE_RATE;


	int dx[D_SIZE] = {-4, -4, -4, -4, -4, -4, -4, -4, -4, -3, -3, -3, -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4};
	int dy[D_SIZE] = {-4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4, -4, -3, -2, -1, 0, 1, 2, 3, 4};

public:
	MovingObject(HDC hdc, int x, int y);
	~MovingObject();

	void Move();
	void setTarger(int x, int y);
	double dist(double x1, double y1, double x2, double y2);
	void draw(HDC hdc);
};

