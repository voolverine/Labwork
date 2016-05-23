import re

def remove_indentation(text):
    indent = ['\n', '\t', ' ']
    result = []

    for character in text:
        if character not in indent:
            result.append(character)

    return "".join(result)


def from_json(text):
    line = remove_indentation(text) 
    
    isDict =      re.compile('^\{[.]+\}$')
    isList =      re.compile('^\[[.]+\]$')
    isInt =       re.compile('^-?[0-9]+$')
    isFloat =     re.compile('^-?([0-9]+)+(.[0-9]*)?$')
    isBoolTrue =  re.compile('^True$')
    isBoolFalse = re.compile('^False$')
    isString =    re.compile('^\"[^\']+\"$')
    isPair =      re.compile('(?P<key>.+):(?P<value>.+)')

    if isDict.match(line):
        inner = line[1:-1].split(',')

        result = dict()
        for i in inner:
            pair = isPair.match(i)



def main():
    pass


if __name__ == "__main__":
    main()
