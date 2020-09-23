#test jump and branch instruction

ori $1, $0, 0x0001
#j 0x20
ori $1, $0, 0x0002 #the delayslot instruction
ori $1, $0, 0x1111
ori $1, $0, 0x1100


