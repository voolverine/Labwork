import os.path
from search_engine import textworker
import base64

import sys
import django
sys.path.append('/Users/volverine/workfolder/Labwork/ISP/4_term/Lab3/aliot/')
os.environ['DJANGO_SETTINGS_MODULE']='aliot.settings'
django.setup()
from searcher.models import IndexedWord


class Finder(object):
    def __init__(self):
        pass

    def find_indexes_for_word(self, searching_word):
        result = {}

        try:
            db_search_result = IndexedWord.objects.get(word=searching_word) 
            url_count_pair = list(db_search_result.wordindoccount_set.all())

            for pair in url_count_pair:
                result[pair.document_link.encode('utf-8')] = pair.word_count_in_document
        except:
            pass


        return result


    def find_answer(self, splitted_request):
        answer = {}

        for word in splitted_request:
                id_count = self.find_indexes_for_word(word)
                for fileid, count in id_count.iteritems():
                    #from here adding to answer

                    if not fileid in answer:
                        answer[fileid] = count
                    else:
                        answer[fileid] += count

        return answer


    def range_answer(self, not_range_answer):
        return sorted(not_range_answer.iteritems(), key=lambda key_value: key_value[1], reverse=True) 

    
    def make_pretty_urls(self, answer_dict):
        pretty_urls = []

        for filename in answer_dict:
            pretty_url = base64.b64decode(filename[0])
            pretty_urls.append(pretty_url)

        return pretty_urls 


    def find(self, request):
        splitted_request = textworker.split_text_in_words(request)
        not_ranged_answer = self.find_answer(splitted_request)
        ranged_answer = self.range_answer(not_ranged_answer)
        return self.make_pretty_urls(ranged_answer)

def main():
    finder = Finder()

    l = finder.find('how to sort dict')
    for i in l:
        print i

if __name__ == "__main__":
    main() 
