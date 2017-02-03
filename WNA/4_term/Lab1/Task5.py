# -*- coding: utf-8 -*-

# Task #5
import numpy as np
from numpy.linalg import matrix_rank
import sympy
from sympy import *

def GC(M, x, ans):
    symb = Symbol("a")
    a = np.array(M)
    a = np.append(a, ans, axis=1)

    for i in xrange(len(a)):
        for j in xrange(len(a[0])):
            if (a[i][j] == symb):
                a[i][j] = x

    print "\nПолученная матрица:"
    print a

    rows = len(a)
    columns = a.size / rows
    variables = len(a[0]) - 1

    for i in xrange(variables):
        for j in xrange(i + 1, rows):
            temp = np.multiply(a[i], (-1.0 * a[j][i]) / (1.0 * a[i][i]))
            a[j] = np.add(a[j], temp)
    for i in xrange(len(a)):
        for j in xrange(len(a[i])):
            a[i][j] = round(a[i][j], 4)
    rank = Matrix(a).rank()
    x = [sympy.Symbol(i) for i in ["x", "y", "z"]]

    for i in xrange(rank - 1, -1, -1):
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
####################################################################################

a = Symbol("a")
A = Matrix([[5, -3, a],
            [a, 4.0, -3.0],
            [7.0, 1.0, -1.0]])
B = np.array([[0.0], [0.0], [0.0]])

print "Исходная система:"
print np.array(A)

ParamValues = solve(Eq(A.det(), 0), a)
print "\nЗначения а при которых система уровнений имеет ненулевое решение:"
print ParamValues

for value in ParamValues:
    print "\n Решение системы при a = {0}:".format(value)
    GC(A, value, B)
