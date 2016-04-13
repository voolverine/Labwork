def cached(func):
    def inner(*args):
        if args in inner.memoize:
            return inner.memoize[args]

        result = func(*args)
        inner.memoize[args] = result
        return result

    inner.memoize = {}
    return inner
