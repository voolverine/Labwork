# -*- coding: utf-8 -*-

import urllib2
import threading
import Queue
import time
from bs4 import BeautifulSoup
from urlparse import urljoin


class Crawler(object):

    def __init__(self, thread_count, start_url, crawling_depth):
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
            except Exception:
                pass

    def start_crawling(self):
        for thread in self.thread_pool:
            thread.start()


    def crawl(self):
        current_url, current_depth = self.url_queue.get()
        print current_url
        if current_depth == self.crawling_depth:
            return

        current_page = Crawler.downloadUrl(current_url)
        links = Crawler.get_all_urls_from_page(current_url, current_page)

        for link in links:
            self.url_queue.put((link, current_depth + 1))


    @staticmethod
    def downloadUrl(url):
        user_agent = "Simple python crawler"

        req = urllib2.Request(url)
        req.add_header('User-Agent', user_agent)
        response = urllib2.urlopen(req)
        
        print response.code
        if response.code >= 400:
            raise Exception("Error code {} while downloading {}".format(response.code, url))
        
        return response.read()

    @staticmethod
    def get_all_urls_from_page(url, page):
        soup = BeautifulSoup(page, "html.parser")
        result = []

        for link_tag in soup.find_all('a', href=True):
            # character '#' for anchors, it is not links ;(
            link = link_tag['href']
            if len(link) > 0 and link[0] != '#': 
                result.append(urljoin(url, link))

        return result

def main():
    url = "http://docs.python.org/"
    crawler = Crawler(thread_count=1, start_url=url, crawling_depth=2)
    crawler.start_crawling()

    while True:
        time.sleep(1)

if __name__ == "__main__":
    main()
