class defaultdict(object):

    def __init__(self):
        self.d = dict()


    def hashable(self, key):
        if hash(key):
            return True
        else:
            # Error in this case
            return False


    def __getitem__(self, key):
        if self.hashable(key):
            pass

        if key in self.d:
            return self.d[key]
        else:
            self.d[key] = defaultdict()
            return self.d[key]


    def __setitem__(self, key, value):
        if self.hashable(key):
            pass

        self.d[key] = value


    def __delitem__(self, key):
        if self.hashable(key):
            pass

        del self.d[key]

    def __contains__(self, item):
        if hashable(item):
            pass

        return item in self.d


    def __str__(self):
        ans = ['{']
        for items in self.d.items():
            ans.append(str(items[0]))
            ans.append(": ")
            ans.append(str(items[1]))
            ans.append(", ")

        if len(ans) > 1:
            ans = ans[:-1]

        ans.append('}')
        return "".join(ans)
