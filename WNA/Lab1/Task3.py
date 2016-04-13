# -*- coding: utf-8 -*-

# Task #3
import numpy as np
from numpy.linalg import matrix_rank
import sympy

a = np.array([[3.0, 2.0, 1.0, 3],
              [2.0, 3.0, -1.0, -3],
              [2.0, 2.0, 3.0, 6.0],
              [1.0, 1.0, 1.0, 2.0],
              [2.0, 2.0, 1.0, 2.0]])

print "Исходаная матрица:"
print a

rows = len(a)
columns = a.size / rows
variables = len(a[0]) - 1

for i in xrange(variables):
    for j in xrange(i + 1, rows):
        temp = np.multiply(a[i], (-1.0 * a[j][i]) / (1.0 * a[i][i]))
        a[j] = np.add(a[j], temp)

x = [sympy.Symbol(i) for i in ["x", "y", "z"]]

for i in xrange(matrix_rank(a) - 1, -1, -1):
    x[i] = a[i][columns - 1]
    for j in xrange(columns - 1):
        if (i != j):
            x[i] -= a[i][j] * x[j]
    x[i] /= a[i][i]

print "\nМатрица приведённая к диагональному виду:"
print a

X = ["x", "y", "z"]
print "\nОтвет:"
print zip(X, x)
