import argparse
import random


def generateNumber(maxn):
    return str(random.randrange(-maxn, maxn))


def generateWord(maxn):
    lenght = random.randrange(1, maxn)
    special = ['\n', '\t', '\b', '\r', '\v']

    result = []
    for i in xrange(0, maxn):
        ch = ""
        while 42:
            ch = chr(random.randrange(0, 256))
            if ch not in special:
                break;
        result.append(ch)

    return "".join(result)


def generate(args):
    MAX_WORD_LENGTH = 10
    MAX_ABSINT = 2100000000

    with open(args.file_name, "w") as f:
        for i in xrange(int(args.lines_number)):
            for j in xrange(int(args.fields_in_line)):
                if not args.numeric:
                    f.write(generateWord(MAX_WORD_LENGTH))
                else:
                    f.write(generateNumber(MAX_ABSINT))
                
                f.write(args.fields_separator)

            if (i != int(args.lines_number) - 1):
                f.write(args.lines_separator)


def main():

    parser = argparse.ArgumentParser(description="Specifies generared sequences.")
    parser.add_argument("-fl", "--fields_in_line", action="store", default="5", help="Defines number of fields in one line.")
    parser.add_argument("-ln", "--lines_number", action="store", default="50", help="Defines number of lines in file.")
    parser.add_argument("-fs", "--fields_separator", action="store", default="\t", help="Defines separator of fields in one line.")
    parser.add_argument("-ls", "--lines_separator", action="store", default="\n", help="Defines separator of lines in file.")
    parser.add_argument("-n", "--numeric", action="store_true", help="Defines numeric fields if argument specified.")
    parser.add_argument("-fn", "--file_name", action="store", default="out", help="Defines output file name")
    args = parser.parse_args()

    generate(args)

if __name__ == "__main__":
    main()
