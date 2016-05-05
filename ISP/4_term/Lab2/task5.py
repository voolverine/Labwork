
class Logger(object):
    @classmethod
    def logger(cls, func):
        def inner(self, *args, **kwargs):
            self.log += "{0} was called with args = \
                            str(args) + {1} kwargs = {2}\n".format(func.__name, args, kwargs)

            return func(*args, **kwargs)
        return inner


    def __str__(self):
        return self.log


    def __new__(self):
        self.log = ""

        for func in self.__dict__:
            if hasattr(getattr(self, func), "__name__") and \
               getattr(self, "__name__") != "logger" and callable(getattr(self, func)):
                setattr(self, func, Logger.logger(getattr(self, func)))
                print func

        return self


class test(Logger):
    def fi(self, x):
        return x * x

    def log(self):
        print Logger.str(self)
