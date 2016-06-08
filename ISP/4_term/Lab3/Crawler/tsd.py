import threading
import json

class thread_safe_dict(object):
    def __init__(self, obj=None):
        if obj == None:
            self.dict = dict()
        else:
            self.dict = dict(obj)

        self.lock = threading.Lock()
        return


    def __setitem__(self, key, value):
        try:
            self.lock.acquire()
            self.dict[key] = value
        except Exception, e:
            print str(e)    
        finally:
            self.lock.release()
        return


    def __contains__(self, key):
        result = False

        try:
            self.lock.acquire()
            result = key in self.dict
        except Exception, e:
            print str(e)    
        finally:
            self.lock.release()
        return result


    def __getitem__(self, key):
        result = None
        try:
            self.lock.acquire()
            if key in self.dict:
                result = self.dict[key]
            
        except Exception, e:
            print str(e)    
        finally:
            self.lock.release()
        return result

    def to_json(self):
        return json.dumps(self.dict, indent=4)

    def from_json(self, text):
        self.dict = json.loads(text)
        return

    def write_to_file(self, file_path):
        with open(file_path, 'w') as f:
            f.write(self.to_json())

    def read_from_file(self, file_path):
        text = None
        
        if not os.path.exists(file_path):
            raise Exception('No such file named {}'.format(file_path))

        with open(file_path, 'r') as f:
            text = f.read()

        self.from_json(text)
        return
