addiu $t0, $zero, 100
add   $t0, $t1,   $t2
lui   $t1, 200
lw $t1, 4($t0)
sw $t4, 4($t3)
beq $t5, $t6, 2
srav $t1, $t2, $1
nop
J 6



