import threading


class thread_safe_set(object):
    
    def __init__(self, obj=None):
        if obj == None:
            self.tss = set()
        else:
            self.tss = set(obj)

        self.lock = threading.Lock()

    def add(self, obj):
        try:
            lock.acquire()
            tss.append(obj)
        except Exception, e:
            print str(e) 
        finally:
            lock.release() 


    def __contains__(self, obj):
        is_already_in_set = True

        try:
            lock.acquire()
            is_already_in_set = obj in self.tss
        except Exception, e:
            print str(s)
        finally:
            lock.release()

        return is_already_in_set
