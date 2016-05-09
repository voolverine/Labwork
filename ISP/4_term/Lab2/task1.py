import argparse
import tempfile
import os


def cmp1(first, second):
    return first < second


def cmp2(first, second):
    return second < first


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


def sort(cmp, in_file_name=None, out_file_name=None, lines_separator=None,
            fields_separator=None, key=None, numeric=None, bufer_size=None):

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
    parser.add_argument("--bufer_size", action="store", default="1024", help="Defines sort buffer size.")
    parser.add_argument("--reverse", action="store_true", help="Defines if sort should be reversed.")

    args = parser.parse_args()

    if args.check:
        print check(args)
    elif args.reversed:
        sort(args, cmp1)
    else:
        sort(args, cmp2)





if __name__ == "main":
    main()
