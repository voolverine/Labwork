# -*- coding: utf-8 i-*i_

class Iter(object):

    def __init__(self, s):
        self.offset = 0
        self.data = s
        if isinstance(s, tuple):
            self = s
        if isinstance(s, list):
            self = s
        if isinstance(s, dict):
            self = s

    def __iter__(self):
        return self

    def next(self):
        if self.offset == len(self.data):
            self.offset = 0
            raise StopIteration
        element = self.data[self.offset]
        self.offset += 1
        return element

    def filter(self, f):
        return [x for x in self.data if f(x)]
        


def f1(x):
    return x < 20

def f2(x):
    return x > 10

def main():
    a = Iter([1, 23, 432, 12, 23])

    first = []
    for i in a:
        first.append(i)
        if i == 432:
            break
    second = []
    for i in a:
        second.append(i)

    #print "Before 432 = {}".format(first)
    #print "All element = {}".format(second)

    print a.filter(f1).filter(f2)

if __name__ == "__main__":
    main()
