class vector(object):

    def __init__(self, l = None):
        if l == None:
            l = []

        for i in l:
            if not(type(i) == int or type(i) == float or type(i) == long):
                raise TypeError("Vector elements should be of numerical type")

        self.array = l[:]


    def __len__(self):
        return(len(self.array))



    def __getitem__(self, key):
        return self.array[key]

    def __setitem__(self, key, value):
        self.array[key] = value
        return self.array[key]


    def __str__(self):
        return str(self.array)


    def __add__(self, other):
        if not type(other) == type(self):
            raise TypeError("Cannot add {0} to {1} ;(", type(other), type(self))

        if len(self) != len(other):
            raise TypeError("Cannot sum vectors with different lenght.")

        ans = []
        for i in xrange(len(self)):
            ans.append(self[i] + other[i])
        return vector(ans)


    def __sub__(self, other):
        if not type(other) == type(self):
            raise TypeError("Cannot subtract {1} from {0} ;(", type(other), type(self))

        if len(self) != len(other):
            raise TypeError("Cannot subtract vectors with different lenght.")

        ans = []
        for i in xrange(len(self)):
            ans.append(self[i] - other[i])
        return vector(ans)


    def __mul__(self, other):
        if type(other) == type(self):
            if len(self) != len(other):
                raise TypeError("Cannot multiply vectors with different lenght.")

            ans = 0
            for i in xrange(len(self)):
                ans += self[i] * other[i]

            return ans
        elif type(other) == int or type(other) == long or type(other) == float:
            ans = []

            for i in xrange(len(self)):
                ans.append(self[i] * other)

            return vector(ans)
        else:
            raise TypeError("Vector could be multyplied only by numerical type.")
