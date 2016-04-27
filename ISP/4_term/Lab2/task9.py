# Task 9
# myxrange - simple generator
# myxrange(to) =============== goes in interval [0, to] with step = 1
# myxrange(from, to) ========= goes in interval [from, to) with step = 1
# myxrange(from, to, step) === goes in interval [from, to) with step = step


def validate(func):
    def inner(*args):
        self = False

        for num in args:
            if not self:
                self = True
                continue
            if not (type(num) == int or type(num) == long):
                raise TypeError("Int or long are only allowed.")

        if len(args) <= 1 or len(args) > 4:                # self is invisible :D
            raise TypeError("myxrange takes 1-3 argumens ({0} given)".format(len(args)))

        return func(*args)

    return inner



class myxrange(object):

    @validate
    def __init__(self, *args):
        self.From = 0
        self.to = 0
        self.step = 1

        if len(args) == 1:
            self.to = args[0]

        elif len(args) == 2:
            self.From = args[0]
            self.to = args[1]

        elif len(args) == 3:
            self.From = args[0]
            self.to = args[1]
            self.step = args[2]

        self.length = (self.to - self.From) / self.step
        self.current = self.From


    def __getitem__(self, key):
        if not (type(key) == int or type(key) == long):
            raise TypeError("Index with type of {0} are not allowed. Only int or long.".format(type(key)))

        if abs(key) > self.length:
            raise IndexError("Myxrange object index out of range.")

        if (key < 0):
            key = self.length + key + 1

        return self.From + key * self.step


    def __len__(self):
        return self.length


    def __iter__(self):
        while self.current < self.to:
            yield self.current
            self.current += self.step

        raise StopIteration()
