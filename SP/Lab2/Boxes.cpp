#include "stdafx.h"
#include "Boxes.h"
#include "Resource.h"
#include "stdio.h"


Boxes::Boxes(HWND edit, HWND listbox1, HWND listbox2)
{
	this -> edit = edit;
	this -> listbox1 = listbox1;
	this -> listbox2 = listbox2;

	buffer1 = new LPWSTR[MAX_STRING_LENGTH];
	buffer2 = new LPWSTR[MAX_STRING_LENGTH];
}


Boxes::~Boxes()
{
	delete[] buffer1;
	delete[] buffer2;
}


bool Boxes::in_listbox(LPWSTR *text, int listbox_id) {
	HWND current_listbox;
	if (listbox_id == IDC_LISTBOX_1) {
		current_listbox = listbox1;
	} else
	if (listbox_id == IDC_LISTBOX_2) {
		current_listbox = listbox2;
	}

	int count = (int) SendMessage(current_listbox, LB_GETCOUNT, NULL, NULL);
	for (int i = 0; i < count; i++) {
		SendMessage(current_listbox, LB_GETTEXT, (WPARAM)i, (LPARAM)buffer2);

		if (!wcscmp((LPWSTR)text, (LPWSTR)buffer2)) {
			return true;
		}
	}

	return false;
}


void Boxes::add_pressed() {
	SendMessage(edit, WM_GETTEXT, MAX_STRING_LENGTH, (LPARAM)buffer1);
	if (!in_listbox(buffer1, IDC_LISTBOX_1)) {
		SendMessage(listbox1, LB_ADDSTRING, NULL, (LPARAM)buffer1);
	}

	SendMessage(edit, WM_SETTEXT, NULL, (LPARAM)(L""));
}


void Boxes::delete_pressed() {
	int selected_index1 = (int)SendMessage(listbox1, LB_GETCURSEL, NULL, NULL);
	if (selected_index1 != -1) {
		SendMessage(listbox1, LB_DELETESTRING, selected_index1, NULL);
	}

	int selected_index2 = (int)SendMessage(listbox2, LB_GETCURSEL, NULL, NULL);
	if (selected_index2 != -1) {
			SendMessage(listbox2, LB_DELETESTRING, selected_index2, NULL);
	}
}


void Boxes::clear_pressed() {
	SendMessage(listbox1, LB_RESETCONTENT, NULL, NULL);
	SendMessage(listbox2, LB_RESETCONTENT, NULL, NULL);
}


void Boxes::toright_pressed() {
	int selected_index = (int)SendMessage(listbox1, LB_GETCURSEL, NULL, NULL);
	
	if (selected_index == -1) {
		return;
	}
	SendMessage(listbox1, LB_GETTEXT, (WPARAM)selected_index, (LPARAM)buffer1);

	if (!in_listbox(buffer1, IDC_LISTBOX_2)) {
		SendMessage(listbox2, LB_ADDSTRING, NULL, (LPARAM)buffer1);
	}
}