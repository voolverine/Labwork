install: clean all
	mv main.exe ../build/main.exe
	mv mylib.so ../build/mylib.so

all: mylib main

monitor:
	g++ -c -fPIC monitor.cpp -std=c++11

main:
	mcs main.cs

mylib: monitor
	g++ -shared -fPIC -o mylib.so monitor.o

clean:
	rm -f *.o *.cpp~ *.so *.h~ *.cs~ *.exe
	rm -f ../build/*
