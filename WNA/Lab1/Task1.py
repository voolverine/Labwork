# -*- coding: utf-8 -*-

# Task #1

import numpy as np
a = np.array([[5.0, 1.0, 5.0, 11.0],
              [-1.0, 5.0, 1.0, 7.0],
              [5.0, -1.0, 5.0, 9.0]])

print "Исходаная матрица:"
print a

rows = len(a)
columns = a.size / rows

for i in xrange(rows):
    for j in xrange(i + 1, rows):
        temp = np.multiply(a[i], (-1.0 * a[j][i]) / (1.0 * a[i][i]))
        a[j] = np.add(a[j], temp)


x = [0] * rows
for i in xrange(rows - 1, -1, -1):
    res = a[i][columns - 1]

    for j in xrange(columns - 1):
        if (i != j):
            res -= a[i][j] * x[j]
    x[i] = round(res / a[i][i], 4)

X = ["x", "y", "z"]
print "\nМатрица приведённая к диагональному виду:"
print a

print "\nОтвет:"
print zip(X, x)
