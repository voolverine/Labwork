#pragma once
class Boxes
{
private:
	HWND edit;
	HWND listbox1;
	HWND listbox2;

	const int MAX_STRING_LENGTH = 256;
	LPWSTR *buffer1;
	LPWSTR *buffer2;

public:
	Boxes(HWND edit, HWND listbox1, HWND listbox2);
	~Boxes();

	bool in_listbox(LPWSTR *text, int listbox_id);
	void add_pressed();
	void delete_pressed();
	void clear_pressed();
	void toright_pressed();
};

