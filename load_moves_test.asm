.data
newline: .asciiz "\n"
filename: .asciiz "moves03.txt"
.align 0
moves: .byte 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.text
.globl main
main:
la $a0, moves
la $a1, filename
jal load_moves

# You must write your own code here to check the correctness of the function implementation.
move $a0, $v0
li $v0, 1
syscall

la $a0, newline
li $v0, 4
syscall
#separator
la $t0, moves
lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall

lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall

lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall


lbu $a0, 0($t0)
li $v0, 1
syscall
addi $t0, $t0, 1

la $a0, newline
li $v0, 4
syscall



#separator


li $v0, 10
syscall

.include "hw3.asm"
