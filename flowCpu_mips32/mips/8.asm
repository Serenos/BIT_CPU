# test sb, lb, lbu
ori $3, $0, 0xeeff
sb $3, 0x3($0)
srl $3, $3, 8
sb $3, 2($0)
ori $3, $0, 0xccdd
sb $3, 1($0)
srl $3, $3, 8
sb $3, 0($0)
lb $1, 3($0)
lbu $1, 3($0)

