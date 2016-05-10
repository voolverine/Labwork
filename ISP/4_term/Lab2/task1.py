import argparse
import tempfile
import os
import sys


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
        for i in xrange(min(len(first), len(second))):
            if first[i] > second[i]:
                return False
            elif first[i] < second[i]:
                return True

        if len(first) <= len(second):
            return True
        else:
            return False
    else:
        first = ''.join(first)
        second = ''.join(second)
        return first <= second


def cmp2(tfirst, tsecond, key, numeric):
    first = []
    second = []

    if type(key) == str and key == 'all':
        first = tfirst
        second = tsecond


    for i in key:
        first.append(tfirst[i])
        second.append(tsecond[i])


    if numeric:
        for i in xrange(min(len(first), len(second))):
            if first[i] < second[i]:
                return False
            elif first[i] > second[i]:
                return True

        if len(first) >= len(second):
            return True
        else:
            return False
    else:
        first = ''.join(first)
        second = ''.join(second)
        return first >= second


def merge_sort(arr, cmp, key, numeric):
    def sort(arr):
        if len(arr) == 1:
            return arr 

        left = sort(arr[:len(arr) / 2])
        right = sort(arr[len(arr) / 2:])

        
        del arr[:]
        l = 0
        r = 0

        while l < len(left) and r < len(right):
            if cmp(left[l], right[r], key, numeric):
                arr.append(left[l]) 
                l += 1
            else:
                arr.append(right[r])
                r += 1

        while l < len(left):
            arr.append(left[l])
            l += 1
        while r < len(right):
            arr.append(right[r])
            r += 1

        # print "{} will be merged with {} \n resul = {}\n".format(left, right, arr)
        return arr
    
    arr = sort(arr)

        

def read_line(f, fields_separator, lines_separator, numeric):
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

    if numeric:
        fields = map(int, fields)

    return fields


def check(cmp=None, in_file_name=None, lines_separator=None,
            fields_separator=None, key=None, numeric=None):

    if cmp == None:
        cmp = cmp1
    if in_file_name == None:
        in_file_name = "input"
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

    with open(in_file_name, 'r') as f:
        prev_line = read_line(f, fields_separator, lines_separator, numeric)
        
        while 42:
            next_line = read_line(f, fields_separator, lines_separator, numeric)
            if len(next_line) == 0:
                break

            if not cmp(prev_line, next_line, key, numeric):
                return False

    return True




def sort(cmp=None, in_file_name=None, out_file_name=None, lines_separator=None,
            fields_separator=None, key=None, numeric=None, buff_size=None):

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
    if buff_size == None:
        buff_size = 1048576

    
    def writeLineToFile(f, line):
        f.write(str(line[0]))

        for j in xrange(1, len(line)):
            f.write(fields_separator)
            f.write(str(line[j]))

        f.write(lines_separator)


    def writeToFile(f, lines):
        #print "to file {0}, write {1}".format(f, lines)
        for line in lines:
            writeLineToFile(f, line) 
        f.seek(0)



    temp_files = []

    def to_sortedTempFiles():
        with open(in_file_name, "r") as f:
            lines = []
            cur_buffsize = 0

            while 42:
                line = read_line(f, fields_separator, lines_separator, numeric)

                if line == []:
                    break
                if cur_buffsize + sys.getsizeof(line) >= buff_size:
                    tmp = tempfile.TemporaryFile()
                    merge_sort(lines, cmp, key, numeric)
                    writeToFile(tmp, lines)
                    temp_files.append(tmp)
                    del lines[:]
                    lines.append(line)
                    cur_buffsize = sys.getsizeof(line)

                else:
                    cur_buffsize += sys.getsizeof(line)
                    lines.append(line)

            if len(lines) > 0:
                    tmp = tempfile.TemporaryFile()
                    merge_sort(lines, cmp, key, numeric)
                    writeToFile(tmp, lines)
                    temp_files.append(tmp)
                    del lines[:]


    def mergeTwoFiles(file1, file2):
        tmp = tempfile.TemporaryFile()

        f1 = read_line(file1, fields_separator, lines_separator, numeric)
        f2 = read_line(file2, fields_separator, lines_separator, numeric)

        while f1 != [] and f2 != []:
            if cmp(f1, f2, key, numeric):
                writeLineToFile(tmp, f1)
                f1 = read_line(file1, fields_separator, lines_separator, numeric)
            else:
                writeLineToFile(tmp, f2)
                f2 = read_line(file2, fields_separator, lines_separator, numeric)

        while f1 != []:
            writeLineToFile(tmp, f1)
            f1 = read_line(file1, fields_separator, lines_separator, numeric)

        while f2 != []:
            writeLineToFile(tmp, f2)
            f2 = read_line(file2, fields_separator, lines_separator, numeric)

        file1.close()
        file2.close()
        tmp.seek(0)

        return tmp


    def merge_sortedTempFiles():

        current_tempfiles = []
        while 42:
            if len(temp_files) == 1:
                break
            if len(temp_files) % 2 != 0:
                current_tempfiles.append(temp_files[-1])
                del temp_files[-1]

            for i in xrange(0, len(temp_files), 2):
                merged = mergeTwoFiles(temp_files[i], temp_files[i + 1])
                current_tempfiles.append(merged)

            # temp_files = current_tempfiles[:]           DON'T WORKS WHY??????

            del temp_files[:]
            for i in current_tempfiles:
                temp_files.append(i)
            del current_tempfiles[:]


    to_sortedTempFiles()
    merge_sortedTempFiles()

    with open(out_file_name, "w") as f:
        line = read_line(temp_files[0], fields_separator, lines_separator, numeric)

        while line != []:
            writeLineToFile(f, line)
            line = read_line(temp_files[0], fields_separator, lines_separator, numeric)


def main():
    parser = argparse.ArgumentParser(description="Scpecify huge sort.")
    parser.add_argument("-i", "--input", action="store", default="input", help="Defines input file.")
    parser.add_argument("-o", "--output", action="store", default="output", help = "Defines output file.")
    parser.add_argument("-ls", "--lines_separator", action="store", default="\n", help="Defines separator of lines in file.")
    parser.add_argument("-fs", "--fields_separator", action="store", default="\t", help="Defines separator of fields in line.")
    parser.add_argument("-k", "--key", action="store", default="all", help="Defines indexes in string to sort.")
    parser.add_argument("-n", "--numeric", action="store_true", help="Defines to interpret fields as numbers.")
    parser.add_argument("--check", action="store_true", help="Defines only to check if sequence is sorted according to all setted options.")
    parser.add_argument("--buffer_size", action="store", default="10241024", help="Defines sort buffer size.")
    parser.add_argument("--reverse", action="store_true", help="Defines if sort should be reversed.")

    args = parser.parse_args()
    
    if args.reverse:
        cmp = cmp2
    else:
        cmp = cmp1

    if args.check:
        print check(cmp, args.input, args.output, args.lines_separator,
                args.fields_separator, args.key, args.numeric, int(args.buffer_size))
    else:
        print sort(cmp, args.input, args.output, args.lines_separator,
                args.fields_separator, args.key, args.numeric, int(args.buffer_size))





if __name__ == "__main__":
    main()
