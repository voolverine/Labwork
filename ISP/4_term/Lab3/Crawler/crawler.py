# -*- coding: utf-8 -*-

import urllib2
from bs4 import BeautifulSoup
from urlparse import urljoin


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
    page = Crawler.downloadUrl(url)

    print Crawler.get_all_urls_from_page(url, page)


if __name__ == "__main__":
    main()
