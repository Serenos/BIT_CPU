#test jal
ori $1, $0, 0x0003
#jal 0x40
ori $1, $0, 0x0010 #the delayslot instruction
ori $1, $0, 0x0020 