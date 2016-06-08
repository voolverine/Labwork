import os.path
import os
import tsd
import tss
import Queue
import threading
import time

class Indexer(object):
    def __init__(self, storage_dir, thread_count, inverted_index_filename, id_to_filename_table_filename):
        self.inverted_index = tsd.thread_safe_dict()
        self.id_to_filename = tsd.thread_safe_dict() 
        self.file_queue = Queue.Queue()
        self.current_file_id = 0
        self.lock = threading.Lock()
        self.inverted_index_filename = inverted_index_filename
        self.id_to_filename_table_filename = id_to_filename_table_filename
        
        # Event if everythin is indexed
        self._stop = threading.Event()

        self.thread_pool = []
        for i in xrange(thread_count):
            new_thread = threading.Thread(target=self.thread_action)
            new_thread.signal = True
            new_thread.daemon = True
            self.thread_pool.append(new_thread)
        
        self.storage_dir = storage_dir

    def stop(self):
        self._stop.set()
        return
    
    def stopped(self):
        return self._stop.isSet()

    @staticmethod
    def encount_each_word(words):
        encounted = {}

        for word in words:
            if word in encounted:
                encounted[word] += 1 
            else:
                encounted[word] = 1

        return encounted
    
    @staticmethod
    def split_text_in_words(text):
        split_by = [',', '.', '\\', '/', '\n', '\t', ':', '!', '?', ';', '-', ' ', \
                        '}', '{', '\r', '\'', '\"', '(', ')', '#', '$', '%', '^', '&', '*', \
                        '>', '<'] 

        # to append last word, add fake point to the end
        ''.join([text, '.']) 

        words = []
        buffer = []

        for character in text:
            if character in split_by:
                if len(buffer) > 0:
                    words.append(''.join(buffer))
                buffer = []
            else:
                buffer.append(character)

        return words

    def add_file_to_index(self, filename):

        self.lock.acquire()
        file_id = self.current_file_id 
        self.id_to_filename[self.current_file_id] = filename
        self.current_file_id += 1 
        self.lock.release()

        text = None
        with open(os.path.join(self.storage_dir, filename), 'r') as f:
            text = f.read()

        words = Indexer.split_text_in_words(text)
        words = Indexer.encount_each_word(words)

        for word, count in words.iteritems():
            if word in self.inverted_index:
                # {'word1': {id1: count1, id2: count2, ...}}
                self.inverted_index[word][file_id] = count
            else:
                self.inverted_index[word] = dict()
                self.inverted_index[word][file_id] = count

        return

    def thread_action(self):
        while True:
            if self.file_queue.empty():
                self.stop()

            if self.stopped():
                raise Exception('Queue is empty.')

            filename = self.file_queue.get()
            print 'file {} is indexing'.format(filename)
            self.add_file_to_index(filename)
        return


    def make_index_from_dir(self):
        for smth in os.listdir(self.storage_dir):
            if os.path.isfile(os.path.join(self.storage_dir, smth)):
                self.file_queue.put(smth)

        for thread in self.thread_pool:
            thread.start()

        return

    def write_index_to_file(self):
        self.inverted_index.write_to_file(self.inverted_index_filename)
        self.id_to_filename.write_to_file(self.id_to_filename_table_filename)



def main():
    indexer = Indexer(storage_dir='downloaded_urls', thread_count=2, inverted_index_filename='index', \
                        id_to_filename_table_filename='id_to_filename')
    indexer.make_index_from_dir()

    while not indexer.stopped():
        time.sleep(1)

    indexer.write_index_to_file()
    

if __name__ == "__main__":
    main()
