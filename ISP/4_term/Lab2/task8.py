# Task 8
# Cached - simple decorator that memoize functions results
# NOTE: you should be sure your arguments are hashable 


def primitiveToImmutable(obj):
    # Add your immutable and hashable types :D
    immutable = [int, long, float, bool, str, tuple, unicode, frozenset, range, xrange]

    if type(obj) in immutable:
        return obj

    if type(obj) == list:
        for i in xrange(len(obj)):
            obj[i] = primitiveToImmutable(obj[i])

        return tuple(obj)

    elif type(obj) == set:
        ans = []

        for i in obj:
            ans.append(primitiveToImmutable(i))

        return tuple(ans)

    elif type(obj) == dict:
        ans = []

        for i in obj.items():
            ans.append(primitiveToImmutable(i))

        return tuple(ans)
    else:
        return obj   # NOTE: you should be sure your type is hashable


def cached(func):
    def inner(*args, **kwargs):

        # reform args and kwargs to tuple of args
        cur_args_list = [None] * len(func.__code__.co_varnames)
        for i in xrange(len(args)):
            cur_args_list[i] = args[i]

        for i in xrange(len(inner.arg_list)):
            var_name = inner.arg_list[i]

            if var_name in kwargs:
                cur_args_list[i] = kwargs[var_name]

        # All args reformed to tuple of tuples of args and kwargs
        tupled_args = primitiveToImmutable(cur_args_list)
        tupled_args = tuple(zip(inner.arg_list, tupled_args))
        # print tupled_args

        # If args have already memoized return answer
        if tupled_args in inner.memoize:
            print "Memoized"
            return inner.memoize[tupled_args]

        result = func(*args, **kwargs)
        inner.memoize[tupled_args] = result
        return result

    inner.memoize = {}     # memoized values for tuples of tuples of arguments (arg_name, arg_value)
    inner.arg_list = func.__code__.co_varnames  # list of arguments names
    return inner


# Example
@cached
def power(a, b):
    result = 1

    while b:
        if (b & 1):
            result *= a
        a *= a
        b >>= 1
    return result
