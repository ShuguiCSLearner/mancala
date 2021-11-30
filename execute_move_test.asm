.data
newline: .asciiz "\n"
board_filename: .asciiz "game02.txt"
origin_pocket: .byte 4
.align 2
state:        
    .byte 0         # bot_mancala       	(byte #0)
    .byte 0         # top_mancala       	(byte #1)
    .byte 6         # bot_pockets       	(byte #2)
    .byte 6         # top_pockets        	(byte #3)
    .byte 0         # moves_executed	(byte #4)
    .byte 'B'    # player_turn        		(byte #5)
    # game_board                     		(bytes #6-end)
    .asciiz
    "0004040404040404070404040400"
.text
.globl main
main:

#check execute_move


la $a0, state
lb $a1, origin_pocket
jal execute_move
# You must write your own code here to check the correctness of the function implementation.

move $a0, $v0
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

move $a0, $v1
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall


#Checking GameBoard
la $t0, state
lb $a0, 0($t0)
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
lb $a0, 0($t0)
li $v0, 11
syscall

la $a0, newline
li $v0, 4
syscall

addi $t0, $t0, 1
move $a0, $t0
li $v0, 4
syscall

la $a0, newline
li $v0, 4
syscall


li $v0, 10
syscall

.include "hw3.asm"
