# -*- coding: utf-8 -*-

# Task #1
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


def evaluate(B, x2, x1):
    from numpy import linalg as LA

    return LA.norm(B) / (1 - LA.norm(B)) * LA.norm(x2 - x1)

def FixedPointIteration(B, c, x_prev):
    eps = 0.00001
    x = 0
    k = 0

    while (True):
        x = B.dot(x_prev)
        x = x + c
        k +=1
        if (evaluate(B, x, x_prev) < eps):
            print "Для достижения точности e = {} понадобилось " \
                    "{} итераций".format(eps, k)
            return x

        x_prev = x

import numpy as np

A = np.array([[40.42, 2.42, 2.86],
              [3.34, 35.12, 1.52],
              [2.46, 4.85, 30.14]])
b = np.array([10.42, 12.12, 42.15])
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
    print "\nРешение методом простых итераций:"
    print FixedPointIteration(A, b, x0)
