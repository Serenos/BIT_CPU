j 0xbfc00000
nop
beq $t5, $t6, 4
lw  $t6, 4($0)
sw  $t5, 4($0)
sll $t5, $t4, 1
slt
and $t2, $t1, $t0
sub $t1, $t1, $zero
addi $t0, $zero, 100