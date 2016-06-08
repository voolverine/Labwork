# -*- coding: utf-8 -*-

import urllib2
import threading
import Queue
import time
import tss
import base64
import os.path
from bs4 import BeautifulSoup
from urlparse import urljoin

# TODO: fix downloading same url more than one time (tss)

class Crawler(object):

    def __init__(self, thread_count, start_url, crawling_depth, storage_dir):
        self.storage_dir = storage_dir
        self.thread_pool = []
        self.url_queue = Queue.Queue()
        self.crawling_depth = crawling_depth

        self.url_queue.put((start_url, 0))

        for i in xrange(thread_count):
            new_thread = threading.Thread(target=self.thread_action)
            new_thread.signal = True
            new_thread.daemon = True
            self.thread_pool.append(new_thread)


    def thread_action(self):
        while True:
            try:
                self.crawl()
            except Exception, e:
                print str(e) 

    def start_crawling(self):
        for thread in self.thread_pool:
            thread.start()


    def crawl(self):
        current_url, current_depth = self.url_queue.get()

        if current_depth == self.crawling_depth:
            return

        current_page = Crawler.downloadUrl(current_url)
        self.write_to_file(current_url, current_page)

        links = Crawler.get_all_urls_from_page(current_url, current_page)
        for link in links:
            self.url_queue.put((link, current_depth + 1))


    @staticmethod
    def downloadUrl(url):
        user_agent = "Simple python crawler"

        req = urllib2.Request(url)
        req.add_header('User-Agent', user_agent)
        response = urllib2.urlopen(req)
        
        print url
        print response.code

        if response.code >= 400:
            raise Exception("Error code {} while downloading {}".format(response.code, url))
        
        return response.read()


    @staticmethod
    def get_absolute_url(current_url, next_url):
        # character '#' for anchors, it is not links to the new pages ;(
        if len(next_url) == 0 or (len(next_url) > 0 and next_url[0] == '#'):
            return ''
    
        without_anchor = []
        for character in next_url:
            if character == '#':
                break
            
            without_anchor.append(character)

        without_anchor = ''.join(without_anchor)
        return urljoin(current_url, without_anchor)

    @staticmethod
    def get_all_urls_from_page(url, page):
        soup = BeautifulSoup(page, "html.parser")
        result = []

        for link_tag in soup.find_all('a', href=True):
            link = link_tag['href']
            link = Crawler.get_absolute_url(url, link)

            if not link == '':
                result.append(link)

        return result

    def write_to_file(self, url, html):
        filename = base64.b64encode(url)    
        soup = BeautifulSoup(html, 'html.parser')
        texts = soup.findAll(text=True)

        if not os.path.exists(self.storage_dir):
            os.makedirs(self.storage_dir)

        with open(os.path.join(self.storage_dir, filename), "w") as f:
            for text in texts:
                f.write(text.encode('utf-8'))

def main():
    url = "http://docs.python.org/"
    crawler = Crawler(thread_count=4, start_url=url, crawling_depth=3, storage_dir="downloaded_urls")
    crawler.start_crawling()

    while True:
        time.sleep(1)

if __name__ == "__main__":
    main()
