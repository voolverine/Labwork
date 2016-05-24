class sequence(object):
    def __init__(self, s, filters = None):
        if not hasattr(s, "__iter__"):
            raise TypeError("Not iterable object. ;(")


        if filters == None:
            self.filters = None
        else:
            self.filters = filters

        self.sequence = s


    def __iter__(self):
        if self.filters == None:
            return self.sequence.__iter__()
        else:
            return (i for i in self.sequence.__iter__() if self.filters(i))


    def __str__(self):
        s = ""
        for i in self:
            s += str(i) + ' '

        return s

    
    def filter(self, func):
        return sequence(self, func)
