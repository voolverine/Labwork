def cached(func):
    def inner(*args):
        if args in inner.memoize:
            return inner.memoize[args]

        result = func(*args)
        inner.memoize[args] = result
        return result

    inner.memoize = {}
    return inner

@cached
def power(a, b):
    result = 1

    while b:
        if (b & 1):
            result *= a
        a *= a
        b >>= 1
    return result
