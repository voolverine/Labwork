class Logger(object):

    def __init__(self):
        # print "init executing"
        self._log = []


    def __str__(self):
        # print "str executing"
        log = []

        for i in self._log:
            log.append("{0} called with args = {1}, kwargs = {2}, result = {3}".
                            format(i[0], i[1], i[2], i[3]))

        return '\n'.join(log)

    def __getattribute__(self, attr):
        # print "getattribute executing"
        super_attr = super(Logger, self).__getattribute__(attr)
        if callable(super_attr):
            def logger(*args, **kwargs):
                res = super_attr(*args, **kwargs) 
                self._log.append([attr, args, kwargs, res])
                return res

            return logger
        else:
            return super_attr 
