from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from . import finder 
import json
import index_editor
import os
import sys
import django
import base64
sys.path.append('/Users/volverine/workfolder/Labwork/ISP/4_term/Lab3/aliot/')
os.environ['DJANGO_SETTINGS_MODULE']='aliot.settings'
django.setup()
Finder = finder.Finder()

from indexer import Indexer
from models import WordInDocCount, Urls


URLS_IN_PAGE = 50


def index(request):
    return render(request, 'searcher/index.html')


def search(request):
    request_message = request.GET.get('request')
    response_message = Finder.find(request_message)
    return HttpResponse(json.dumps({'urls': response_message}), content_type='application/json') 

def edit(request):
    return render(request, 'searcher/add_to_index.html')


def add_to_index(request):
    request_message = request.GET.get('request')
    response = index_editor.add_text_to_index(request_message)

    return HttpResponse(json.dumps({'status': response}), content_type='application/json')


def all_urls():
    all_objects = Urls.objects.all()
    unique_links = []

    for obj in all_objects:
        unique_links.append(obj.url)

    return HttpResponse(json.dumps({'links': list(unique_links)}), content_type='application/json')


def delete_from_db(urls):
    urls = urls.split(',')
    
    for url_to_delete in urls:
        enc = base64.b64encode(url_to_delete)
        WordInDocCount.objects.filter(document_link=enc).delete()
        Urls.objects.filter(url=url_to_delete).delete()


def urls_request(request):
    rtype = request.GET.get('request_type') 
    if rtype == 'get_all_urls':
        return all_urls() 
    elif rtype == 'delete_urls':
        delete_from_db(request.GET.get('urls_to_delete'))
        return HttpResponse('OK')

    return HttpResponse('Something wrong.')

def urls(request):
    return render(request, 'searcher/urls.html')

def get_urls_slice(page):
    global URLS_IN_PAGE

    all_urls = Urls.objects.all()
    count = all_urls.count()

    if (page - 1) * URLS_IN_PAGE > count:
        return json.dumps({'urls': []})

    low = (page - 1) * URLS_IN_PAGE
    high = min(count, page * URLS_IN_PAGE)
    answer = []

    for i in xrange(low, high):
        answer.append(all_urls[i].url)

    return json.dumps({'urls': answer})

def get_page_number():
    global URLS_IN_PAGE
    all_urls_count = Urls.objects.all().count()

    pages_num = all_urls_count / URLS_IN_PAGE
    if all_urls_count % URLS_IN_PAGE:
        pages_num += 1

    return json.dumps({'page_number': pages_num})


def get_url_text(processing_url):
    url_text = Urls.objects.filter(url=processing_url)[0].text
    return json.dumps({'text': url_text})


def delete_file(encoded_url, decoded_url):
    WordInDocCount.objects.filter(document_link=encoded_url).delete()
    Urls.objects.filter(url=decoded_url).delete()

def save(saving_url, saving_text):
    encoded_url = base64.b64encode(saving_url)
    with open(os.path.join('searcher/search_engine/downloaded_urls/', encoded_url), 'w') as f:
        f.write(saving_text)

    delete_file(encoded_url, saving_url)
    indexer = Indexer(storage_dir='searcher/search_engine/downloaded_urls/', thread_count=1)
    indexer.add_file_to_index(encoded_url)

def index_table(request):
    rtype = request.GET.get('request_type')

    if rtype == 'get_index':
        page_number = request.GET.get('page_number').encode('utf-8')
        page_number = int(page_number)
        return HttpResponse(get_urls_slice(page_number), content_type='application/json')
    elif rtype == 'get_url_text':
        url = request.GET.get('url').encode('utf-8')
        return HttpResponse(get_url_text(url), content_type='application/json')
    elif rtype == 'get_page_number':
        return HttpResponse(get_page_number(), content_type='application/json')
    elif rtype == 'save':
        url = request.GET.get('url')
        text = request.GET.get('text')
        save(url, text)

    return render(request, 'searcher/index_table.html')
