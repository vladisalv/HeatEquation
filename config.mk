# опции. Их можно изменять при запуске: make run N=4 X=100 Z=100 S=500 D=0.2
S = i
L = 0
R = 1
t = 1
T = 0.001
c = 0.02

# версия DEBUG или RELEASE
VERSION        = DEBUG
VERSION_NUMBER = 0.0.3

# имя бинарника
PROG_NAME = HeatEquation

# компилятор
CC = g++

# программа для просмотра gif
GIFPROG = gifview
