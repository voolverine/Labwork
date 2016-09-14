from django.contrib import admin

from .models import IndexedWord
from .models import Urls

# Register your models here.
class Index(admin.ModelAdmin):
    model = IndexedWord
    list_display = ['word', 'get_files_id']

    def get_files_id(self, obj):
        return obj.wordindoccount_set.all()


admin.site.register(IndexedWord, Index)
admin.site.register(Urls)
