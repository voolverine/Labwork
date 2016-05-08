def addClassAttribute(cls):
    def inner(filename):
        if not type(filename) == str:
            raise TypeError("File name must be string variable, have {0}".format(type(filename)))

        cls._filename = filename
        return cls
    return inner


def getAttrs(filename):
    dct = {}

    with open(filename, 'r') as f:
        while 42:
            line = f.readline()
            if line == "":
                break
            param = line.split('=')
            dct[param[0]] = param[1][:-1]

    return dct


@addClassAttribute
class myMeta(type):
    def __new__(cls, name, bases, dct):
        filename = cls._filename
        delattr(cls, "_filename")
        
        attrs = getAttrs(filename)
        dct.update(attrs)
        #result = cls.__class__, cls).__new__(cls, name, bases, dct)
        #result = type(name, bases, dct)
        result = type.__new__(cls, name, bases, dct)
        return result



#class test(object):
#    __metaclass__ = myMeta("input")
