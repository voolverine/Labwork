import copy

class sequence(object):
    def __init__(self, s):
        if not hasattr(s, "__iter__"):
            raise TypeError("Not iterable object. ;(")
        self.sequence = s


    def __iter__(self):
        return self.sequence.__iter__()


    def __str__(self):
        s = ""
        for i in self:
            s += str(i) + ' '

        return s

    
    def filter(self, func):
        tsequence = copy.deepcopy(self.sequence)
        for i in list(tsequence):
            if not func(i):
                if hasattr(tsequence, "remove"):
                    tsequence.remove(i)
                elif hasattr(tsequence, "__delitem__"):
                    del tsequence[i]

        return sequence(tsequence)
