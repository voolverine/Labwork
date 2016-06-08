import os.path
import tsd
import textworker
import base64

class Searcher(object):
    def __init__(self, inverted_index_filename, id_to_filename_table_filename):
        self.inverted_index = tsd.thread_safe_dict()
        self.inverted_index.load_from_file(inverted_index_filename)
        self.id_to_filename = tsd.thread_safe_dict()
        self.id_to_filename.load_from_file(id_to_filename_table_filename)


    def find_answer(self, splitted_request):
        answer = {}

        for word in splitted_request:
            if word in self.inverted_index:
                for fileid, count in self.inverted_index[word].iteritems():
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

        for fileid_count in answer_dict:
            filename = self.id_to_filename[fileid_count[0]].encode('utf-8')
            pretty_urls.append(base64.b64decode(filename))

        return pretty_urls 


    def search(self, request):
        splitted_request = textworker.split_text_in_words(request)
        not_ranged_answer = self.find_answer(splitted_request)
        ranged_answer = self.range_answer(not_ranged_answer)

        return self.make_pretty_urls(ranged_answer)

def main():
    searcher = Searcher(inverted_index_filename='index', id_to_filename_table_filename='id_to_filename')

    l = searcher.search('how to sort dict')
    for i in l:
        print i

if __name__ == "__main__":
    main() 
