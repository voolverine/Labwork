install: all
	mv main.exe ../build/main.exe
	&& clean

all: mylib main

monitor:
	g++ -c -fPIC monitor.cpp -std=c++11

main:
	mcs main.cs

mylib: monitor
	g++ -shared -fPIC -o mylib.so monitor.o

clean:
	rm -f *.o *.cpp~ *.so *.h~ *.cs~ *.exe
