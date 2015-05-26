install: clean all
	mv main.exe ../build/main.exe
	mv libcpp.so ../build/libcpp.so

all: libcpp main

monitor:
	g++ -c -fPIC monitor.cpp -std=c++11

main:
	mcs main.cs

libcpp: monitor
	g++ -shared -fPIC -o libcpp.so monitor.o

clean:
	rm -f *.o *.cpp~ *.so *.h~ *.cs~ *.exe
	rm -f ../build/*
