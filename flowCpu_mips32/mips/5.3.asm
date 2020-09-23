#test slt, sltu, slti, sltiu

or $1, $0, 0xffff
sll $1, $1, 16
slt $2, $1, $0
sltu $2, $1, $0
slti $2, $1, 0x0020
sltiu $2, $1, 0x0020