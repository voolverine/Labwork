#?/usr/bin/env python

################## Task 1 ###################

def splitInWords(text):
    punctuation = ['.', ',', '"', '\'', '!', '?', ';', '-', ':']
    for sign in punctuation:
            text = text.replace(sign, ' ')

    words = text.split(' ')
    while '' in words:
        words.remove('')
    while '\n' in words:
        words.remove('\n')

    return words


def wordCount(text):
    words = splitInWords(text)
    return len(words)

def eachWordCount(text):
    words = splitInWords(text)
    d = {}

    for word in words:
        temp = d.get(word, 0)
        d[word] = temp + 1

    return d

def averageWordCount(text):
    lineEnding = ['!', '?', '.']

    sentances = 0
    for sign in lineEnding:
        while sign in text:
            text = text.replace(sign, '', 1)
            sentances += 1

    words = splitInWords(text)

    return 1.0 * len(words) / sentances


def splitInSentances(text):
    # Split text in sentances
    sentances = text.split(".")
    temp = []
    for sentance in sentances:
        temp.append(sentance)

    sentances = temp
    temp = []
    for sentance in sentances:
        temp.append(sentance.split("!"))

    sentances = []
    for lists in temp:
        for sentance in lists:
            sentances.append(sentance)

    temp = []
    for sentance in sentances:
        temp.append(sentance.split("?"))

    sentances = []
    for lists in temp:
        for sentance in lists:
            sentances.append(sentance)

    while "" in sentances:
        sentances.remove("")

    return sentances


def medianWordCount(text):
    punctuation = [',', '"', '\'', ';', '-', ':']

    for sign in punctuation:
        text = text.replace(sign, " ")
    sentances = splitInSentances(text)
    count = []

    for i in sentances:
        count.append(wordCount(i))

    count.sort()
    lenght = len(count)

    return count[(lenght - 1)/ 2]


def topNgrames(text, n, k):
    words = splitInWords(text)

    stat = {}
    for word in words:
        for j in xrange(0, len(word) - k, 1):
            ngram = word[j:j + k]
            count = stat.get(ngram, 0)
            stat[ngram] = count + 1

    k = min(k, len(stat))
    return sorted(stat.items(), key = lambda x:x[1], reverse = True)[0:k]

################## Task 2 ###################


#quick_sort
def quick_sort(a, l, r):
    if (r - l < 1):
        return a

    lo = l
    hi = r
    mid = a[(lo + hi) / 2]

    while lo < hi:
        while lo <= r and mid > a[lo]:
            lo += 1
        while hi >= l and mid < a[hi]:
            hi -= 1

        if lo <= hi:
            a[lo], a[hi] = a[hi], a[lo]
            hi -= 1
            lo += 1

    if (l < hi):
        a = quick_sort(a, l, hi)

    if (lo < r):
        a = quick_sort(a, lo, r)

    return a

# Merge Sort
def merge_sort(a):
    if (len(a) == 1):
        return a

    mid = len(a) / 2

    f = merge_sort(a[:mid])
    s = merge_sort(a[mid:])

    pos = 0
    curf, curs = 0, 0
    res = []
    while curf < len(f) and curs < len(s):
        if (f[curf] < s[curs]):
            res.append(f[curf])
            curf += 1
        else:
            res.append(s[curs])
            curs += 1
    while curf < len(f):
        res.append(f[curf])
        curf += 1
    while curs < len(s):
        res.append(s[curs])
        curs += 1
    return res


# Radix sort
def numberLength(x):
    l = 0
    while x:
        l += 1
        x /= 10
    return l

def radix_sort(a):
# preproc
    ten = [1]
    max_len = 0
    for i in a:
        max_len = max(max_len, numberLength(i))

    for i in xrange(1, max_len + 1):
        ten.append(ten[i - 1] * 10)
#preproc

    for i in range(1, max_len + 1):
        size = [0] * 10
        for x in a:
            last = x / ten[i - 1]
            last %= ten[1]
            size[last] += 1

        sum = 0
        for j in range(10):
            temp = size[j]
            size[j] = sum
            sum += temp

        b = [0] * len(a)
        for x in a:
            last = x / ten[i - 1]
            last %= ten[1]
            pos = size[last]
            b[pos] = x
            size[last] += 1
        a = b

    return a


###################### Task 4 ###############################
def xfibonacci(n):
    f1 = 0
    f2 = 1
    count = 1

    while count <= n:
        yield f2
        f1, f2 = f2, f1 + f2
        count += 1


#################### Task 3 ###############################
s = set()

def reformQuery(query):
    query = query.split(" ")
    query = filter(lambda a: a != "", query)

    result = []
    flag = 0
    temporary = ""

    for element in query:
        if len(element) >= 2 and element[0] == "\"" and \
                element[-1] == "\"":
            result.append(element[1: -1])
            continue

        if element[-1] == "\"" and flag:
            flag = 0
            temporary += " " + element[:-1]
            result.append(temporary)
            temporary = ""
            continue
        if element[0] == '\"':
            flag = 1
            temporary = element[1:]
        elif flag:
            temporary += " " + element
            if element == "":
                temporary += " "
        else:
            result.append(element)

    return result


def add(query):
    global s
    elements = reformQuery(query)

    for element in elements:
        s.add(element)


def remove(query):
    global s
    elements = reformQuery(query)

    for element in elements:
        s.discard(element)


def find(query):
    global s
    elements = reformQuery(query)
    here = []

    for element in elements:
        if element in s:
            here.append(element)

    print here


def viewAll():
    global s
    result = []

    for element in s:
        result.append(element)

    print result

def save():
    global s

    with open("set", "w") as f:
        for element in s:
            f.write(str(element) + "\n")

def load():
    global s
    s.clear()

    contains = 0
    with open("set", "r") as f:
        content = f.readlines()

        for elem in content:
            elem = elem[0:-1]
            if isIntNum(elem):
                s.add(int(elem))
            elif isFloatNum(elem):
                s.add(float(elem))
            else:
                s.add(elem)

def grep(reg):
    global s
    import re
    if reg[-1] != '$':
        reg += '$'
    reg = re.compile(reg)

    for elem in s:
        if reg.match(str(elem)):
            print elem


def endless():
    while (True):
        query = raw_input()
        if len(query) >= 3 and query[:3] == "add":
            add(query[3:])
        elif len(query) >= 4 and query[:4] == "find":
            find(query[4:])
        elif len(query) == 4 and query[:4] == "list":
            viewAll()
        elif len(query) >= 6 and query[:6] == "remove":
            remove(query[6:])
        elif len(query) == 4 and query == "stop":
            break
        elif len(query) == 4 and query == "save":
            save()
        elif len(query) == 4 and query == "load":
            load()
        elif len(query) >= 4 and query[:4] == "grep":
            grep(query[5:])
        elif (True):
            print "There is no such query. Sorry"

def strListToInt(l):
    l = splitInWords(l)
    print l
    return map(int, l)




# ============================ Aditional

def isMailValid(mail):
    import re

    reg = re.compile(r'^[a-zA-Z0-9_\-]+@[a-zA-Z\d]+\.[a-zA-Z]{2,4}$')
    if reg.match(mail):
        return True

    return False


def isFloatNum(num):
    import re
    reg = re.compile(r'^[\d]+[\.\d]*$')

    if reg.match(num):
        return True

    return False

def isIntNum(num):
    import re
    reg = re.compile(r'^[\d]+$')

    if reg.match(num):
        return True
    else:
        return False

def partURL(url):
    import re
    reg = re.compile(r'(?P<scheme>\w+)?[\:\/]*'
                     r'(?P<host>[\w\.\-\_]+)?'
                     r':(?P<port>\d*)?'
                     r'(?P<path>[\/\w\-\_\.\%]*)?'
                     r'\?|\#(?P<params>.*)?')
    return reg.match(url).groupdict()




def main():
    import argparse

    parser = argparse.ArgumentParser(description="Executes some funcitons", formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-f", "--file", action="store", help="get input form file", default="nofile")
    parser.add_argument("-a", "--action", action="store", help="function to execute:\n\n"
                                                                "\t0. splitInWords(text)\n"
                                                                "\t1. wordCount(text)\n"
                                                                "\t2. eachWordCount(text)\n"
                                                                "\t3. averageWordCount(text)\n"
                                                                "\t4. splitInSentances(text)\n"
                                                                "\t5. medianWordCount(text)\n"
                                                                "\t6. topNgrames(text)\n"
                                                                "\t7. quick_sort(list)\n"
                                                                "\t8. merge_sort(list)\n"
                                                                "\t9. numberLength(number)\n"
                                                                "\t10. radix_sort(list)\n"
                                                                "\t11. interactive()\n"
                                                                "if no [--action] interactive running")

    args = parser.parse_args()

    user_input = 0
    if (args.file != "nofile"):
        with open(args.file, "r") as f:
            user_input = f.read()
    else:
        user_input = raw_input()

    if args.action == "splitInWords":
        print splitInWords(user_input)
    elif args.action == "wordCount":
        print wordCount(user_input)
    elif args.action == "eachWordCount":
        print eachWordCount(user_input)
    elif args.action == "averageWordCount":
        print averageWordCount(user_input)
    elif args.action == "splitInSentances":
        print splitInSentances(user_input)
    elif args.action == "medianWordCount":
        print medianWordCount(user_input)
    elif args.action == "topNgrames":
        n = raw_input("n = ")
        k = raw_input("k = ")
        print topNgrames(user_input, n, k)
    elif args.action == "quick_sort":
        array = strListToInt(user_input)
        print quick_sort(array, 0, len(array) - 1)
    elif args.action == "merge_sort":
        print merge_sort(strListToInt(user_input))
    elif args.action == "numberLength":
        l = strListToInt(user_input)
        ans = []
        for num in l:
            ans.append(numberLength(num))
        print ans
    elif args.action == "radix_sort":
        print radix_sort(strListToInt(user_input))
    elif args.action == "endless":
        endless()
    else:
        print "No function found. Interactive started."
        endless()


#print partURL("http://www.DailyNews.ru:8080/goto/news?newsThisDay#yeah")
if __name__ == "__main__":
    main()
