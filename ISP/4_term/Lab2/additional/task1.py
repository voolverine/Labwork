import re

def remove_indentation(text):
    indent = ['\n', '\t', ' ']
    result = []

    for character in text:
        if character not in indent:
            result.append(character)

    return "".join(result)


def split_by_comma(line):
    result = []
    temp = []

    curly_brackets_count = 0
    square_brackets_count = 0
    quotes_count = 0

    for character in line:
        if character == '\"':
            quotes_count ^= 1
        elif character == '{' and quotes_count == 0:
            curly_brackets_count += 1
        elif character == '[' and quotes_count == 0:
            square_brackets_count += 1
        elif character == '}' and quotes_count == 0:
            curly_brackets_count -= 1
        elif character == ']' and quotes_count == 0:
            square_brackets_count -= 1

        if character == ',' and \
                curly_brackets_count == 0 and \
                square_brackets_count == 0 and \
                quotes_count == 0:
            
            result.append(''.join(temp))
            temp = []

        else:
            temp.append(character)

    if len(temp) != 0:
        result.append(''.join(temp))

    return result


def from_json(text):
    line = remove_indentation(text) 
    print line
    
    isDict =      re.compile('^\{.+\}$')
    isList =      re.compile('^\[.+\]$')
    isInt =       re.compile('^-?[0-9]+$')
    isFloat =     re.compile('^-?([0-9]+)+(,[0-9]*)?$')
    isBoolTrue =  re.compile('^true$')
    isBoolFalse = re.compile('^false$')
    isString =    re.compile('^\"[^\']+\"$')
    isPair =      re.compile('(?P<key>[^:]+):(?P<value>.+)')

    if isDict.match(line):
        inner = split_by_comma(line[1:-1])

        result = dict()
        for i in inner:
            pair = isPair.match(i)
            result[from_json(pair.group('key'))] = from_json(pair.group('value'))

        return result
    elif isList.match(line):
        inner = split_by_comma(line[1:-1])

        result = list()
        for i in inner:
            result.append(from_json(i))

        return result
    elif isInt.match(line):
        return int(line)
    elif isFloat.match(line):
        return float(line)
    elif isBoolTrue.match(line):
        return True
    elif isBoolFalse.match(line):
        return False
    elif isString.match(line):
        return line[1:-1]
    else:
        raise TypeError("Not json valid string.")



def main():
    pass


if __name__ == "__main__":
    main()
