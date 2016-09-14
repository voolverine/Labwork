# -*- coding: utf-8 -*-

import os.path
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import django
sys.path.append('/Users/volverine/workfolder/Labwork/ISP/4_term/Lab3/aliot/')
os.environ['DJANGO_SETTINGS_MODULE']='aliot.settings'
django.setup()

from searcher.models import IndexedWord, WordInDocCount, Urls
from search_engine import textworker
from django.db import transaction
import Queue
import threading
import time
import base64

class Indexer(object):
    def __init__(self, storage_dir, thread_count):
        self.file_queue = Queue.Queue()
        self.lock = threading.Lock()
        
        # Event if everything is indexed
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
    
    @transaction.atomic
    def save_unioned_inverted_indexes(self, indexes):
        for w in indexes:
            index = IndexedWord(word=w)
            index.save()
    
    @transaction.atomic
    def save_unioned_files(self, files):
        for file_info in files:
            to_index = WordInDocCount(document_link=file_info[0], word_count_in_document=file_info[1])
            to_index.word = file_info[2]
            to_index.save()

    def process_unknown_words(self, words):
        unknown_words = [] 
        
        for w in words:
            if not IndexedWord.objects.filter(word=w).exists():
                unknown_words.append(w)

        self.save_unioned_inverted_indexes(unknown_words)


    def process_text_to_index(self, words_counts, filename):
        to_index = []
        for word, count in words_counts.iteritems():
            query_result = IndexedWord.objects.raw('SELECT * FROM searcher_indexedword WHERE word=%s', [word])
            to_index.append((filename, count, query_result[0]))

        self.save_unioned_files(to_index)

    def is_already_here(self, filename):
        return Urls.objects.filter(url=base64.b64decode(filename)).exists()

    def add_url_and_text(self, filename, text_in_url):
        new_url = base64.b64decode(filename)

        record = Urls(url=new_url, text=text_in_url)
        record.save()

    def add_file_to_index(self, filename):
        if self.is_already_here(filename):
            return

        text = None
        with open(os.path.join(self.storage_dir, filename), 'r') as f:
            text = f.read()
        
        self.add_url_and_text(filename, text)
        words = textworker.split_text_in_words(text)
        words = Indexer.encount_each_word(words)
        print len(words)
        self.process_unknown_words(words) 
        self.process_text_to_index(words, filename)


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

        while not self.stopped():
            time.sleep(1)

        return


def main():
    indexer = Indexer(storage_dir='search_engine/downloaded_urls/', thread_count=1)
    indexer.make_index_from_dir()


if __name__ == "__main__":
    main()
