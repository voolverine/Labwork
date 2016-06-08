import threading

class thread_safe_dictionary(object):
    def __init__(self, obj=None):
        if obj == None:
            self.dict = dict()
        else:
            self.dict = dict(obj)

        self.lock = threading.Lock()
        return


    def __setitem__(self, key, value):
        try:
            lock.acquire()
            self.dict[key] = value
        except Exception, e:
            print str(e)    
        finally:
            lock.release()
        return


    def __contains__(self, key):
        result = False

        try:
            lock.acquire()
            result = key in self.dict
        except Exception, e:
            print str(e)    
        finally:
            lock.release()
        return result


    def __getitem__(self, key):
        result = None
        try:
            lock.acquire()
            if key in self.dict:
                result = self.dict[key]
            
        except Exception, e:
            print str(e)    
        finally:
            lock.release()
        return result
