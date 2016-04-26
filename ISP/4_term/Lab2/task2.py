import argparse
import random


MIN_WORD_LEN = 1
MAX_WORD_LEN = 100000

MIN_NUMBER = -1000000000
MAX_NUMBER = 1000000000

fields_number = None
numeric = None
field_separator = None
line_separator = None
line_number = None


def generate_word(File):
    length = random.randrange(MIN_WORD_LEN, MAX_WORD_LEN, 1)

    for i in xrange(length):
        File.write(chr(random.randrange(0, 256, 1)))
    return


def generateInt(File):
    File.write(str(random.randrange(MIN_NUMBER, MAX_NUMBER, 1)))
    return


def generateLine(File):
    global numeric
    global field_separator
    global line_separator

    f = None
    if numeric:
        f = generateInt
    else:
        f = generate_word


    for i in xrange(fields_number - 1):
        f(File)
        File.write(field_separator)

    f(File)
    File.write(line_separator)


def generate(File):
    global line_number

    for i in xrange(line_number):
        generateLine(File)


def main():

    global fields_number
    global numeric
    global field_separator
    global line_separator
    global line_number

    parser = argparse.ArgumentParser(description="Customise output result.", formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-fn", "--fields_number", action="store", default="5", help="Defines number of fields in one line.")
    parser.add_argument("-n", "--numeric", action="store_true", help="Defines numeric or ascii output.")
    parser.add_argument("-fs", "--field_separator", action="store", default=" ", help="Defines separator between fields.")
    parser.add_argument("-ls", "--line_separator", action="store", default="\n", help="Defines separator between lines.")
    parser.add_argument("-ln", "--line_number", action="store", default="500", help="Defines lines number")
    parser.add_argument("-f", "--file_name", action="store", default="out", help="Defines output file name")

    args = parser.parse_args()

    fields_number = int(args.fields_number)
    numeric = args.numeric
    field_separator = args.field_separator
    line_separator = args.field_separator
    line_number = int(args.line_number)

    with open(args.file_name, "w") as f:
        generate(f)


if __name__ == "__main__":
    main()
