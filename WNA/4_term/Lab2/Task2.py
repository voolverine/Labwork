# -*- coding: utf-8 -*-

# Task #2
def maxLine(A):
    row = len(A)
    column = A.size / row

    msum = None
    for i in xrange(row):
        sum = 0
        for j in xrange(column):
            sum += abs(A[i][j])
        if msum == None or msum < sum:
            msum = sum

    if msum < 1:
        return True
    else:
        return False

def evaluateSeidel(H, F, x2, x1, k):
    from numpy import linalg as LA
    q = LA.norm(F) / (1 - LA.norm(H))
    q = q ** k

    return  q * LA.norm(x2 - x1)

def SeidelMethod(B, c, x_prev):
    eps = 0.001
    x = 0

    row = len(B)
    column = A.size / row

    H = np.array([0.0] * A.size).reshape(row, column)
    F = np.array([0.0] * A.size).reshape(row, column)
    E = np.identity(row)

    for i in xrange(row):
        for j in xrange(column):
            if j < i:
                H[i][j] = B[i][j]
            else:
                F[i][j] = B[i][j]

    k = 0
    print "Матрица H:\n{}\n".format(H)
    print "Матрица F:\n{}\n".format(F)

    while (True):
        t = np.linalg.matrix_power(E - H, -1)
        x = t.dot(F)
        x = x.dot(x_prev) + t.dot(c)
        k += 1
        print x
        if (evaluateSeidel(H, F, x, x_prev, k) < eps):
            print "Для достижения точности e = {} понадобилось " \
                    "{} итераций".format(eps, k)
            return x

        x_prev = x

import numpy as np

A = np.array([[10.0, 1.0, 1.0],
              [2.0, 10.0, 1.0],
              [2.0, 2.0, 10.0]])
b = np.array([12.0, 13.0, 14.0])
x0 = b

print "Исходная матрица:\n{}\n".format(A)

row = len(A)
column = A.size / row

for i in xrange(row):
    value = A[i][i]
    A[i][i] = 0
    b[i] /= value
    for j in xrange(column):
        A[i][j] /= -value

print "Матрица приведённая к итерационному виду:\n{}\n".format(A)

if not maxLine(A):
    print "Условие сходимости не выполняется"
else:
    print "\nРешение методом Зейделя:"
    print SeidelMethod(A, b, x0)
