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
            ans.append('\"')
            ans.append(to_json(item[0]))
            ans.append('\"')
            ans.append(": ")
            ans.append(to_json(item[1]))
            ans.append(", ")

        ans = ans[:-1]
        ans.append('}')
    elif type(obj) == int or type(obj) == long or type(obj) == float:
        ans.append(str(obj))
    elif type(obj) == str:
        ans.append('\"')
        string_literals = ["\\", "\"", "\'", "\b", "\f", "\n", "\r", "\t", "\v"]

        for char in obj:
            if (char in string_literals):
                ans.append("\\" + char)
            else:
                ans.append(char)

        ans.append('\"')
    else:
        if raise_unknown:
            raise TypeError("{0} is not JSON serializable".format(type(obj)))

    return "".join(ans)

