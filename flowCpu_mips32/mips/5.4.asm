# test mul, mult, multu
ori $1, $0, 0xffff
sll $1, $1, 16
ori $1, $1, 0xfffb
ori $2, $0, 6
mul $3, $1, $2