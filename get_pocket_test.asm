.data
newline: .asciiz "\n"
board_filename: .asciiz "game02.txt"
player: .byte 'B'
distance: .byte 3
.align 2
state:        
    .byte 0         # bot_mancala       	(byte #0)
    .byte 1         # top_mancala       	(byte #1)
    .byte 6         # bot_pockets       	(byte #2)
    .byte 6         # top_pockets        	(byte #3)
    .byte 2         # moves_executed	(byte #4)
    .byte 'B'    # player_turn        		(byte #5)
    # game_board                     		(bytes #6-end)
    .asciiz
    "0108070601000404040404040400"
.text
.globl main
main:

la $a0, state
la $a1, board_filename
jal load_game

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


la $a0, state
lb $a1, player
lb $a2, distance
jal get_pocket
# You must write your own code here to check the correctness of the function implementation.
move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

.include "hw3.asm"
