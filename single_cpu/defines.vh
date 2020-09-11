


`define WRITEABLE 1'b1
`define UNWRITEABLE 1'b0
`define EXTENDSIGNAL_SIZE 1:0

`define RESETABLE 1'b1
`define RESETUNABLE 1'b0

`define ZEROWORD 32'h00000000

`define INSTRLENGTH 31:0
`define DATALENGTH 31:0 
`define ADDRLENGTH 31:0
`define ALUCONTROL_SIZE 4:0
`define INSTR_INDEX 25:0

`define INSTR_MEM_NUM 131071
`define DATA_MEM_NUM 2048

`define INSTRSIZE 31:0
`define PCSIZE 31:0

`define OP_SIZE 5:0
`define R_SIZE 4:0
`define IMI_SIZE 15:0
//`define SIG_IMI_SIZE 31:0

`define ALUCONTROL_SIZE 4:0



`define REGNUM 32
// opcode
`define OP_ALL_ZERO 6'b000000
`define OP_LW 6'b100011
`define OP_ORI 6'b001101
`define OP_REGIMM 6'b000001
`define OP_LW 6'b100011
`define OP_ORI 6'b001101
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_ALL_ZERO 6'b000000
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGTZ 6'b000111
`define OP_BLEZ 6'b000110
`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_ANDI 6'b001100  
`define OP_XORI 6'b001110  
`define OP_LUI 6'b001111  
/*****  load and store instr  *******/
`define OP_LB  6'b100000 
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_LW 6'b100011
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_SW 6'b101011
`define OP_LWL 6'b100010
`define OP_LWR 6'b100110
`define OP_SWL 6'b101010
`define OP_SWR 6'b101110
`define OP_CP0 6'b010000
// opcode over
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001

// ALU code
`define ALU_ADD 5'b00010
`define ALU_ADD_OVERFLOW 5'b10010
`define ALU_SUB 5'b00110
`define ALU_OR 5'b00001
`define ALU_NONE 5'b00000
// ALU code over
