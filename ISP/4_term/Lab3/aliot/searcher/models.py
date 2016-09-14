from __future__ import unicode_literals

from django.db import models

# Create your models here.


class IndexedWord(models.Model):
    word = models.CharField(max_length=300)

    class Meta:
        app_label = 'searcher'

    def __str__(self):
        return self.word


class WordInDocCount(models.Model):
    word = models.ForeignKey(IndexedWord, on_delete=models.CASCADE)
    document_link = models.CharField(max_length=350, default='')
    word_count_in_document = models.IntegerField()

    class Meta:
        app_label = 'searcher'

    def __str__(self):
        return self.document_link

    def __repr__(self):
        return str((self.document_link, self.word_count_in_document))


class Urls(models.Model):
    url = models.TextField()
    text = models.TextField()

    def __str__(self):
        return self.url

    def __repr__(self):
        return str(text)
