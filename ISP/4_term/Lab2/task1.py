import argparse
import tempfile
import os


def strNumsToIntList(str):
    ans = []
    cur = []

    for i in str:
        if i == ',':
            ans.append(''.join(cur))
            del cur[:]

        cur.append(i)

    if len(cur) > 0:
        ans.append(''.join(cur))
        del cur[:]

    ans = map(int, ans)
    
    return ans



def cmp1(tfirst, tsecond, key, numeric):
    first = []
    second = []

    if type(key) == str and key == 'all':
        first = tfirst
        second = tsecond
    else:
        for i in key:
            first.append(tfirst[i])
            second.append(tsecond[i])

    if numeric:
        first = map(int, first)
        second = map(int, second)

        for i in xrange(min(len(first), len(second))):
            if first[i] > second[i]:
                return False

        if len(first) <= len(second):
            return True
        else:
            return False
    else:
        first = ''.join(first)
        second = ''.join(second)
        return first <= second


def cmp2(tfirst, tsecond, numeric):
    first = []
    second = []

    if type(key) == str and key == 'all':
        first = tfirst
        second = tsecond


    for i in key:
        first.append(tfirst[i])
        second.append(tsecond[i])


    if numeric:
        first = map(int, first)
        second = map(int, second)

        for i in xrange(min(len(first), len(second))):
            if first[i] < second[i]:
                return False

        if len(first) >= len(second):
            return True
        else:
            return False
    else:
        first = ''.join(first)
        second = ''.join(second)
        return first >= second


def read_line(f, fields_separator, lines_separator):
    temp = []
    fields = []

    while 42:
        char = f.read(1)

        if char == lines_separator or char == '':
            if len(temp) > 0:
                fields.append(''.join(temp))
                del temp[:]
            break

        if char == fields_separator:
            fields.append(''.join(temp)) 
            del temp[:]
            continue

        temp.append(char)

    return fields


def check(cmp=None, in_file_name=None, out_file_name=None, lines_separator=None,
            fields_separator=None, key=None, numeric=None, bufer_size=None):

    if cmp == None:
        cmp = cmp1
    if in_file_name == None:
        in_file_name = "input"
    if out_file_name == None:
        out_file_name = "output"
    if lines_separator == None:
        lines_separator = '\n'    
    if fields_separator == None:
        fields_separator = '\t'
    if key == None:
        key = 'all'
    elif type(key) == str and key != 'all':
        key = strNumsToIntList(key)
    if numeric == None:
        numeric = False
    if bufer_size == None:
        bufer_size = 1024

    with open(in_file_name, 'r') as f:
        prev_line = read_line(f, fields_separator, lines_separator)
        
        while 42:
            next_line = read_line(f, fields_separator, lines_separator)
            if len(next_line) == 0:
                break

            if not cmp(prev_line, next_line, key, numeric):
                return False

    return True




def sort(cmp=None, in_file_name=None, out_file_name=None, lines_separator=None,
            fields_separator=None, key=None, numeric=None, bufer_size=None):

    if cmp == None:
        cmp = cmp1
    if in_file_name == None:
        in_file_name = "input"
    if out_file_name == None:
        out_file_name = "output"
    if lines_separator == None:
        lines_separator = '\n'    
    if fields_separator == None:
        fields_separator = '\t'
    if key == None:
        key = 'all'
    elif type(key) == str and key != 'all':
        key = strNumsToIntList(key)
    if numeric == None:
        numeric = False
    if bufer_size == None:
        bufer_size = 1024


#    def merge_sort():

#    merge_sort()
    return

def main():
    parser = argparse.ArgumentParser(description="Scpecify huge sort.")
    parser.add_argument("-i", "--input", action="store", default="input", help="Defines input file.")
    parser.add_argument("-o", "--output", action="store", default="output", help = "Defines output file.")
    parser.add_argument("-ls", "--lines_separator", action="store", default="\n", help="Defines separator of lines in file.")
    parser.add_argument("-fs", "--fields_separator", action="store", default="\n", help="Defines separator of fields in line.")
    parser.add_argument("-k", "--key", action="store", default="all", help="Defines indexes in string to sort.")
    parser.add_argument("-n", "--numeric", action="store_true", help="Defines to interpret fields as numbers.")
    parser.add_argument("--check", action="store_true", help="Defines only to check if sequence is sorted according to all setted options.")
    parser.add_argument("--buffer_size", action="store", default="1024", help="Defines sort buffer size.")
    parser.add_argument("--reverse", action="store_true", help="Defines if sort should be reversed.")

    args = parser.parse_args()
    
    if args.reverse:
        cmp = cmp2
    else:
        cmp = cmp1

    if args.check:
        print check(cmp, args.input, args.output, args.lines_separator,
                args.fields_separator, args.key, args.numeric, args.buffer_size)
    else:
        sort(args, cmp)





if __name__ == "__main__":
    main()
