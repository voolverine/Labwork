# -*- coding: utf-8 -*-

# All task together :D

from sympy import *

def SturmsWay(f, a, b):
    y = Symbol('y')
    series = [f, diff(f, x)]
    i = 1

    while 42:
        f = series[i - 1]
        g = series[i]
        q, r = div(f, g, x, y)
        if (r == 0):
            break
        series.append(-1.0 * r)
        i += 1

    seriesA = []
    seriesB = []

    for equitation in series:
        seriesA.append(equitation.subs(x, a))
        seriesB.append(equitation.subs(x, b))

    signA = seriesA[0] / abs(seriesA[0])
    signB = seriesB[0] / abs(seriesB[0])
    Achange = 0
    Bchange = 0

    for i in xrange(len(seriesA)):
        curSignA = seriesA[i] / abs(seriesA[i])
        curSignB = seriesB[i] / abs(seriesB[i])

        if (curSignA != signA):
            signA = curSignA
            Achange += 1
        if (curSignB != signB):
            signB = curSignB
            Bchange += 1

    return Achange - Bchange

def devideInIntervals(f, L, R, h):
    k = SturmsWay(f, L, R)
    intervals = []
    curL = L
    curR = L

    for i in xrange(k):
        while curR <= R:
            n = SturmsWay(f, curL, curR)
            if (n == 1):
                break
            curR += h
        if (SturmsWay(f, curL, curR) == 1):
            intervals.append((curL, curR))
        curL = curR

    return intervals

def BinarySearch(f, interval, eps):
    x = Symbol('x')
    l, r = interval
    it = 0

    while (r - l > eps):
        mid = (r + l) / 2
        f1 = f.subs(x, l)
        f2 = f.subs(x, mid)

        if f1 * f2 < 0:
            r = mid
        else:
            l = mid
        it += 1

    return (l, it)

def chordLengthMethod(f, interval, eps):
    l, r = interval

    df = diff(diff(f, x), x)

    dl = df.subs(x, l)
    dr = df.subs(x, r)

    g, x0 = 0, 0
    if (dl * f.subs(x, l) > 0):
        g = lambda value: value - f.subs(x, value) * \
            (l - value) / (f.subs(x, l) - f.subs(x, value))
        x0 = r
    else:
        g = lambda value: value - f.subs(x, value) * \
            (r - value) / (f.subs(x, r) - f.subs(x, value))
        x0 = l

    iteration = []
    iteration.append(x0)
    it = 0

    while 42:
        xprev = iteration[-1]
        xnew = g(xprev)
        iteration.append(xnew)
        it += 1

        if (abs(xnew - xprev) < eps):
            break

    return (iteration[-1], it)


x = Symbol('x')

iS, iE = -10, 10
a = -19.7997
b = 28.9378
c = 562.833
result = 1 << 30
f = x**3 + a * x**2 + b * x + c
eps = 0.001

print "Уравнение:"
print f

k = SturmsWay(f, iS, iE)
print "\nИмеет {0} корня".format(k)

intervals = devideInIntervals(f, iS, iE, 0.7)

print "Интервалы на которых лежат отделенные корни:"
print intervals

print "\nМетод половинного деления:"
for i in xrange(len(intervals)):
    res, it = BinarySearch(f, intervals[i], eps)
    result = min(result, res)
    print "x{0} = {1}, посчитано за {2} итераций".format(i + 1, res, it)
print "Минимальный корень x = {0}".format(result)

result = 1 << 30

print "\nМетод Хорд:"
for i in xrange(len(intervals)):
    res, it = chordLengthMethod(f, intervals[i], eps)
    result = min(result, res)
    print "x{0} = {1}, посчитано за {2} итераций".format(i + 1, res, it)
print chordLengthMethod(f, (-10, 10), eps)
print "Минимальный корень x = {0}".format(result)
