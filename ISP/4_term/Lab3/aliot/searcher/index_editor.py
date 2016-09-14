from search_engine import textworker
from search_engine import crawler
from bs4 import BeautifulSoup
import indexer
import os.path
import shutil
import base64


def write_to_file(storage_dir, filename, texts):
    with open(os.path.join(storage_dir, filename), 'w') as f:
        for text in texts:
            f.write(text.encode('utf-8'))


def download_all_files(storage_dir, urls):
    url_status = []
    
    try:
        shutil.rmtree(os.path.join('/searcher/search_engine/', storage_dir))
    except:
        pass

    try:
        os.makedirs(os.path.join('searcher/search_engine/', storage_dir))
    except:
        pass

    for url in urls:
        try:
            html = crawler.Crawler.downloadUrl(url) 
            filename = base64.b64encode(url)    

            soup = BeautifulSoup(html, 'html.parser')
            texts = soup.findAll(text=True)
            write_to_file(os.path.join('searcher/search_engine/', storage_dir), filename, texts)

            url_status.append(True)
        except Exception, e:
            print e
            url_status.append(False)
        
    return url_status


def add_text_to_index(text):
    urls = textworker.get_urls_from_text(text)
    file_status = download_all_files('temp_folder', urls) 
    windexer = indexer.Indexer(storage_dir='searcher/search_engine/temp_folder', thread_count=1)
    try:
        windexer.make_index_from_dir()
    except:
        pass

    for i in xrange(len(file_status)):
        if file_status[i]:
            before = os.path.join('searcher/search_engine/temp_folder', base64.b64encode(urls[i]))
            after =  os.path.join('searcher/search_engine/downloaded_urls', base64.b64encode(urls[i]))
            os.rename(before, after)

    return zip(urls, file_status)

def main():
    pass


if __name__ == '__main__':
    main()
