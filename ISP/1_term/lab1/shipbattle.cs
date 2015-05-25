using System;

class shipBattle() {

	static int[,] myState = new int[10, 10];
	static int[,] enemyState = new int[10, 10];
	static int cursorX = 0, cursorY = 0;
	static bool playerShoot = true;
	static int previosShootX = -1;
	static int previosShootY = -1;
	static Random rnd = new Random();
	
	static void setConsoleNormalBackground() {
		Console.BackgroundColor = ConsoleColor.Black;
	}

	static void setConsoleNormalForeground() {
		Console.ForegroundColor = ConsoleColor.White;
	}

	static void setConsoleCurPosBackground() {
		Console.BackgroundColor = ConsoleColor.DarkGray;
	}

	static char getMyStateXY(int a) {
		if (a == 0) {
			Console.ForegroundColor = ConsoleColor.Green;
			return '*';
		}
		if (a == 1) {
			Console.ForegroundColor = ConsoleColor.Blue;
			return '#';
		}
		if (a == 2) {
			Console.ForegroundColor = ConsoleColor.DarkRed;
			return '.';
		}
		if (a == 3) {
			Console.ForegroundColor = ConsoleColor.Red;
			return 'x';
		}
		return ' ';
	}

	static char getEnemyStateXY(int a) {
		if (a == 0 || a == 1) {
			Console.ForegroundColor = ConsoleColor.Gray;
			return '?';
		}
		if (a == 2) {
			Console.ForegroundColor = ConsoleColor.Blue;
			return '.';
		}
		if (a == 3) {
			Console.ForegroundColor = ConsoleColor.Green;
			return 'x';
		}
		return ' ';
	}

	static void refreshWindow(int cursorX, int cursorY) {
		Console.Clear();
		setConsoleNormalBackground();
		setConsoleNormalForeground();
		Console.Write("   ");
		for (int i = 0; i < 10; i++) {
			Console.Write((char)('A' + i));
			Console.Write(' ');
		}
		Console.Write("     ");
		for (int i = 0; i < 10; i++) {
			Console.Write((char)('A' + i));
			Console.Write(' ');
		}
		Console.Write("\n   ");
		for (int i = 0; i < 10; i++) {
			if (i == 9) {
				Console.Write("—");
			} else {
				Console.Write("——");
			}
		}
		Console.Write("      ");
		for (int i = 0; i < 10; i++) {
			if (i == 9) {
				Console.Write("—");
			} else {
				Console.Write("——");
			}
		}
		Console.Write(' ');
		for (int i = 0; i < 10; i++) {
			Console.Write("\n");
			Console.Write(i + 1);
			if (i < 9) {
				Console.Write(' ');
			}
			Console.Write('|');
			for (int j = 0; j < 10; j++) {
				Console.Write(getMyStateXY(myState[i, j]));
				setConsoleNormalForeground();
				Console.Write(' ');
			}
			Console.Write("  ");
			Console.Write(i + 1);
			if (i < 9) {
				Console.Write(' ');
			}
			Console.Write('|');
			for (int j = 0; j < 10; j++) {
				if (i == cursorX && j == cursorY) {
					setConsoleCurPosBackground();
				}
				Console.Write(getEnemyStateXY(enemyState[i, j]));
				setConsoleNormalForeground();
				setConsoleNormalBackground();
				Console.Write(' ');
			}
		}
		Console.Write("\n");
	}

	static void moveUp() {
		if (cursorX == 0) {
			cursorX = 9;
		} else {
			cursorX--;
		}
		refreshWindow(cursorX, cursorY);
	}

	static void moveDown() {
		if (cursorX == 9) {
			cursorX = 0;
		} else {
			cursorX++;
		}
		refreshWindow(cursorX, cursorY);
	}

	static void moveLeft() {
		if (cursorY == 0) {
			cursorY = 9;
		} else {
			cursorY--;
		}
		refreshWindow(cursorX, cursorY);
	}

	static void moveRight() {
		if (cursorY == 9) {
			cursorY = 0;
		} else {
			cursorY++;
		}
		refreshWindow(cursorX, cursorY);
	}

	static void shootXY(int cursorX, int cursorY) {
		if (enemyState[cursorX, cursorY] > 1) {
			return;
		}
		playerShoot = false;
		if (enemyState[cursorX, cursorY] == 0) {
			enemyState[cursorX, cursorY] = 2;
		}
		if (enemyState[cursorX, cursorY] == 1) {
			enemyState[cursorX, cursorY] = 3;
			playerShoot = true;
			if (checkIfKilled(cursorX, cursorY, -1, -1, ref enemyState) == true) {
				pointArroundKilled(cursorX, cursorY, -1, -1, ref enemyState);
			}
		}
		refreshWindow(cursorX, cursorY);
	}
	
	static bool checkIfKilled(int previosShootX, int previosShootY, int previousX, int previousY, ref int[,] state) {
		if ((previosShootX == -1 && previosShootY == -1) || (state[previosShootX, previosShootY] == 0))  {
			return true;
		}
		int[] dx = new int[4] {-1, 0, 0, 1};
		int[] dy = new int[4] {0, -1, 1, 0};
		bool f = true;
		for (int i = 0; i < 4; i++) {
			if (previosShootX + dx[i] >= 0 && previosShootX + dx[i] <= 9 && previosShootY + dy[i] >= 0 && previosShootY + dy[i] <= 9) {
				if (state[previosShootX + dx[i], previosShootY + dy[i]] == 1) {
					return false;
				}
				if (state[previosShootX + dx[i], previosShootY + dy[i]] == 3 &&
						((previousX == previosShootX + dx[i] && previousY != previosShootY + dy[i]) ||
					   		(previousX != previosShootX + dx[i] && previousY == previosShootY + dy[i]) ||
								(previousX == -1 && previousY == -1))) {
					if (checkIfKilled(previosShootX + dx[i], previosShootY + dy[i], previosShootX, previosShootY, ref state) == false) {
						f = false;
					}
				}
			}
		}
		return f;
	}

	static void getCurrentShipEnd(int x, int y, int previousX, int previousY) {
		int [] dx = new int[4] {-1, 0, 0, 1};
		int [] dy = new int[4] {0, -1, 1, 0};
		for (int i = 0; i < 4; i++) {
			if (x + dx[i] >= 0 && x + dx[i] <= 9 && y + dy[i] >= 0 && y + dy[i] <= 9) {
				if (myState[x + dx[i], y + dy[i]] == 1) {
					previosShootX = x;
					previosShootY = y;
					return;
				}
				if (myState[x + dx[i], y + dy[i]] == 3 && (((x + dx[i] == previousX || y + dy[i] == previousY) && (x + dx[i] != previousX || y + dy[i] != previousY)) ||
						(previousX == -1 && previousY == -1))) {
					getCurrentShipEnd(x + dx[i], y + dy[i], x, y);
				}
			}
		}
	}

	static void pointArroundKilled(int x, int y, int previousX, int previousY, ref int[,] state) {
		int[] dx = new int[8] {-1, -1, -1, 0, 0, 1, 1, 1};
		int[] dy = new int[8] {-1, 0, 1, -1, 1, -1, 0, 1};
		for (int i = 0; i < 8; i++) {
			if (x + dx[i] >= 0 && x + dx[i] < 10 && y + dy[i] >= 0 && y + dy[i] < 10) {
				if (state[x + dx[i], y + dy[i]] == 3 && ((x + dx[i] != previousX && y + dy[i] == previousY) ||
						(x + dx[i] == previousX && y + dy[i] != previousY) || (previousX == -1 && previousY == -1))) {
					pointArroundKilled(x + dx[i], y + dy[i], x, y, ref state);
				}
				if (state[x + dx[i], y + dy[i]] != 3) {
					state[x + dx[i], y + dy[i]] = 2;
				}
			}
		}
	}


	static void botShoot() {
		if ((previosShootX == -1 && previosShootY == -1) || checkIfKilled(previosShootX, previosShootY, -1, -1, ref myState) == true) {
			if (previosShootX != -1 && previosShootY != -1) {
				pointArroundKilled(previosShootX, previosShootY, -1, -1, ref myState);
			}
			int possibleX, possibleY;
			do {
				possibleX = rnd.Next(0, 10);
				possibleY = rnd.Next(0, 10);
			} while (myState[possibleX, possibleY] >= 2);
			if (myState[possibleX, possibleY] == 0) {
				myState[possibleX, possibleY] = 2;
				playerShoot = true;
			} else {
				myState[possibleX, possibleY] = 3;
				previosShootX = possibleX;
				previosShootY = possibleY;
			}
			refreshWindow(cursorX, cursorY);
			return;
		} else {
			getCurrentShipEnd(previosShootX, previosShootY, -1, -1);
			int[] dx = new int[4] {-1, 0, 0, 1};
		    int[] dy = new int[4] {0, 1, -1, 0};
			int i;
			do {
				i = rnd.Next(0, 4);
			} while (previosShootX + dx[i] < 0 || previosShootX + dx[i] > 9 || previosShootY + dy[i] < 0 || previosShootY + dy[i] > 9 || myState[previosShootX + dx[i], previosShootY + dy[i]] >= 2);
			if (myState[previosShootX + dx[i], previosShootY + dy[i]] == 0) {
				myState[previosShootX + dx[i], previosShootY + dy[i]] = 2;
				playerShoot = true;
			} else {
				myState[previosShootX + dx[i], previosShootY + dy[i]] = 3;
				previosShootX += dx[i];
				previosShootY += dy[i];	
			}
			refreshWindow(cursorX, cursorY);
			return;
		}
	}

	static bool checkForNeighboors(int x, int y, ref int[,] field) {
		int[] dx = new int[8] {-1, -1, -1, 0, 0, 1, 1, 1};
	    int[] dy = new int[8] {-1, 0, 1, -1, 1, -1, 0, 1};
		for (int i = 0; i < 8; i++) {
			if (x + dx[i] >= 0 && x + dx[i] <= 9 && y + dy[i] >= 0 && y + dy[i] <= 9 && field[x + dx[i], y + dy[i]] != 0) {
				return true;
			}		
		}
		return false;
	}

	static bool isHereFreeSpaceForXShip(int x, int y, int len, bool horizontal, int[,] field) {
		if (horizontal == true) {
			for (int i = 0; i < len; i++) {
				if (y + i >= 10 || field[x, y + i] != 0 || checkForNeighboors(x, y + i, ref field) == true) {
					return false;
				}
			}
		} else {
			for (int i = 0; i < len; i++) {
				if (x + i >= 10 || field[x + i, y] != 0 || checkForNeighboors(x + i, y, ref field) == true) {
					return false;
				}
			}
		}
		return true;
	}

	static bool tryToPutXShip(int x, int y, int len, ref int[,] field) {
		if (field[x, y] != 0) {
			return false;
		}
		int horizontal = rnd.Next(0, 2);
		if (horizontal == 1) {
			if (isHereFreeSpaceForXShip(x, y, len, true, field) == true) {
				for (int i = 0; i < len; i++) {
					field[x, y + i] = 1;
				}
				return true;		
			} else {
				if (isHereFreeSpaceForXShip(x, y, len, false, field) == true) {
					for (int i = 0; i < len; i++) {
						field[x + i, y] = 1;
					}
					return true;
				}			
			}
		} else {
			if (isHereFreeSpaceForXShip(x, y, len, false, field) == true) {
				for (int i = 0; i < len; i++) {
					field[x + i, y] = 1;
				}
				return true;		
			} else {
				if (isHereFreeSpaceForXShip(x, y, len, true, field) == true) {
					for (int i = 0; i < len; i++) {
						field[x, y + i] = 1;
					}
					return true;
				}			
			}
		}
		return false;

	}

	static void generateField(ref int[,] field) {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				field[i, j] = 0;
			}
		}
		//Generate 1x4SHIP
		bool f4 = false;
		do {
			int possibleX = rnd.Next(0, 10);
			int possibleY = rnd.Next(0, 10);	
			f4 = tryToPutXShip(possibleX, possibleY, 4, ref field);
		} while (f4 == false);
		//Generate 2x3SHIP
		for (int i = 0; i < 2; i++) {
			bool f3 = false;
			do {
				int possibleX = rnd.Next(0, 10);
				int possibleY = rnd.Next(0, 10);	
				f3 = tryToPutXShip(possibleX, possibleY, 3, ref field);
			} while (f3 == false);
		}
		//Generate 3x2SHIP
		for (int i = 0; i < 3; i++) {
			bool f2 = false;
			do {
				int possibleX = rnd.Next(0, 10);
				int possibleY = rnd.Next(0, 10);	
				f2 = tryToPutXShip(possibleX, possibleY, 2, ref field);
			} while (f2 == false);
		}
		//Generate 4x1SHIP
 		for (int i = 0; i < 4; i++) {
			bool f1 = false;
			do {
				int possibleX = rnd.Next(0, 10);
				int possibleY = rnd.Next(0, 10);	
				f1 = tryToPutXShip(possibleX, possibleY, 1, ref field);
			} while (f1 == false);
		}
 	}

	static bool checkPersonWin(ref int[,] state) {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++) {
				if (state[i, j] == 1) {
					return false;
				}
			}
		}
		return true;
	}

	static void win() {
		Console.Clear();
		for (int i = 0; i < 1000; i++) {
			Console.Write("You are winner!!! ");
		}
	}

	static void lose() {
		Console.Clear();
		for (int i = 0; i < 1000; i++) {
			Console.Write("You are looser :(\n");
		}
	}
		
	static void Main() {
		Console.Clear();
		refreshWindow(0, 0);
		generateField(ref myState);
		generateField(ref enemyState);	
		while (true) {
			if (playerShoot) {
				ConsoleKeyInfo info = Console.ReadKey();
				if (info.Key == ConsoleKey.UpArrow) {
					moveUp();
				}
				if (info.Key == ConsoleKey.RightArrow) {
					moveRight();
				}
				if (info.Key == ConsoleKey.DownArrow) {
					moveDown();
				}
				if (info.Key == ConsoleKey.LeftArrow) {
					moveLeft();
				}
				if (info.Key == ConsoleKey.Enter) {
					shootXY(cursorX, cursorY);
				}	
				if (checkPersonWin(ref enemyState) == true) {
					win();
					return;
				}
			} else {
				botShoot();
				if (checkPersonWin(ref myState) == true) {
					lose();
					return;
				}
			}
		}
	}

}
