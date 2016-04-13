# Task 9
# Xrange - simple generator
# Xrange(to) =============== goes in interval [0, to] with step = 1
# Xrange(from, to) ========= goes in interval [from, to) with step = 1
# Xrange(from, to, step) === goes in interval [from, to) with step = step

def Xrange(*args):
    if len(args) <= 0 or len(args) > 3:
        raise ArgsError("Expected 1-3 params.")

    if len(args) == 1:
        cur = 0

        while (cur < args[0]):
            yield cur
            cur += 1

    elif len(args) == 2:
        cur = args[0]

        while cur < args[1]:
            yield cur
            cur += 1

    elif len(args) == 3:
        cur = args[0]

        while cur < args[1]:
            yield cur
            cur += args[2]
