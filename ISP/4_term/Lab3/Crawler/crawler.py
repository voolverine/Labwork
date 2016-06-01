# -*- coding: utf-8 -*-

import urllib2
from bs4 import BeautifulSoup


class Crawler(object):

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
    def get_all_urls_from_page(page):
        soup = BeautifulSoup(page)
        for a in soup.find_all('a', href=True):
            print "Found the URL: ", a['href']

def main():
    page = Crawler.downloadUrl("http://docs.python.org/")
    print Crawler.get_all_urls_from_page(page)


if __name__ == "__main__":
    main()
