# -*- coding: utf-8 -*-

import urllib2



class Crawler(object):

    def downloadUrl(url):
        user_agent = "Simple python crawler"
        headers = {'User-Agent': user_agent}

        data = {} 

        req = urllib2.Request(url, data, headers)
        response = urllib2.urlopen(req)
        
        if response.code >= 400:
            raise Exception("Error code {} while downloading {}".format(response.code, url))


def main():
    pass 


if __name__ == "__main__":
    main()
