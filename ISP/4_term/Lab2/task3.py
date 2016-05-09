def literalToJson(ch):
    string_literals = ["\\", "\"", "\'", "\b", "\f", "\n", "\r", "\t", "\v"]
    replace_literals = ["\\\\", "\\\"", "\'", "\\b", "\\f", "\\n", "\\r", "\\t", "\\v"] 

    ans = ch
    for i in xrange(len(string_literals)):
        if string_literals[i] == ch:
            ans = replace_literals[i]
            break

    return ans


def isNumerical(x):
    if type(x) == int or type(x) == long or type(x) == float \
            or type(x) == bool:
        return True
    else:
        return False


def to_json(obj, raise_unknown=None):
    if (raise_unknown == None):
        raise_unknown = False

    ans = []
    if type(obj) == list or type(obj) == tuple:
        ans.append('[')
        for i in obj:
            ans.append(to_json(i))
            ans.append(", ")

        ans = ans[:-1]
        ans.append(']')

    elif type(obj) == dict:
        ans.append('{')

        for item in obj.items():
            if isNumerical(item[0]):    # Key cannot be number in json -> Convert to str
                ans.append("\"")
                ans.append(to_json(item[0]))
                ans.append("\"")
            else:
                ans.append(to_json(item[0]))

            ans.append(": ")
            ans.append(to_json(item[1]))
            ans.append(", ")

        ans = ans[:-1]
        ans.append('}')

    elif isNumerical(obj):
        ans.append(str(obj))

    elif type(obj) == str:
        ans.append('\"')
        for char in obj:
            ans.append(literalToJson(char))

        ans.append('\"')
    else:
        if raise_unknown:
            raise TypeError("{0} is not JSON serializable".format(type(obj)))

    return "".join(ans)

