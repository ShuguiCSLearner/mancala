# Jay Chen(Shugui Chen)
# SHUGCHEN
# 112890591

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

# a0 = state, a1 = string of the file name
# v0 = valid or not(based on the rock number, not more than 99 stones), v1 = number of pocket (return 0 if pockets is more than )

# s0 = a0
# s1 = a1
# s2 = # of stone
# s3 = # of pockets
# s4 = # of stone of top mancala
# s5 = # of stone of bot mancala
# s6 = # of pockets each row

#temps
# t6 = '\r'
# t7 = '\n'
# t9 = address of state   /   $s0

#Part 1 Checked, all good.
load_game:
	move $fp, $sp
	move $s0, $a0 						#s0 and s1 save a0 and a1 respectively for temporary
	move $s1, $a1
	
	li $v0, 13						#open file call
	move $a0, $a1						#a0 = string address
	li $a1, 0						#a1 = 0 is reading mode
	syscall
	
	blt $v0, $zero, load_game_file_dont_exit		#v0 < 0 is negative which means file don't exit
	move $a0, $v0						#a0 = file descriptor
	
	li $t6, '\r'
	li $t7, '\n'
	li $t5, '0'
	li $t4, 10
	li $s4, 0						#initialize s4 = 0
	
	Check_Line_1_Loop:					#find the # of stone on top mancala
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Check_Line_1_Loop
	beq $t0, $t7, End_Check_Line_1_Loop			#next line
	
	mul $s4, $s4, $t4					#s4 = s4 * 10
	sub $t1, $t0, $t5					#t1 = digit
	add $s4, $s4, $t1
	j Check_Line_1_Loop					#looping
	
	End_Check_Line_1_Loop:
	li $s5, 0						#initialize s5 = 0
	
	Check_Line_2_Loop:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Check_Line_2_Loop
	beq $t0, $t7, End_Check_Line_2_Loop			#next line
	
	mul $s5, $s5, $t4					#s5 = s5 * 10
	sub $t1, $t0, $t5					#t1 = digit
	add $s5, $s5, $t1
	j Check_Line_2_Loop					#looping
	
	End_Check_Line_2_Loop:
	li $s6, 0
	
	Check_Line_3_Loop:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Check_Line_3_Loop
	beq $t0, $t7, End_Check_Line_3_Loop			#next line
	
	mul $s6, $s6, $t4					#s6 = s6 * 10
	sub $t1, $t0, $t5					#t1 = digit
	add $s6, $s6, $t1
	j Check_Line_3_Loop					#looping
	
	End_Check_Line_3_Loop:
	add $s3, $s6, $s6					#s3 = # of pockets
	add $s2, $zero, $s4
	add $s2, $s2, $s5					#s2 = # of stones in both mancala
	move $t9, $s0						#t9 = address of state
	sb $s5, 0($t9)						#store first byte   /    bot mancala
	addi $t9, $t9, 1
	sb $s4, 0($t9)						#store second byte  /    top mancala
	addi $t9, $t9, 1					
	sb $s6, 0($t9)						#store third byte   /    tot pockets
	addi $t9, $t9, 1					
	sb $s6, 0($t9)						#store fourth byte   /    bot pockets
	addi $t9, $t9, 1
	sb $zero 0($t9)						#store fifth byte    /    # of move
	addi $t9, $t9, 1
	li $t0, 'B'
	sb $t0, 0($t9)						#store sixth byte    /    player turn   initialized 'B'
	addi $t9, $t9, 1					#asciiz address now
	li $t4, 10
	li $t5, '0'
	
	Check_Line_4_Loop:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)						#t0
	addi $sp, $sp, 1
	
	beq $t0, $t6, Check_Line_4_Loop
	beq $t0, $t7, End_Check_Line_4_Loop			#next line
	
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t1, 0($sp)						#t1
	addi $sp, $sp, 1
	sub $t3, $t0, $t5
	mul $t3, $t3, $t4					#t3 = t0 * 10
	sub $t0, $t1, $t5
	add $t3, $t3, $t0					#t3 = t3 + t1
	add $s2, $s2, $t3					#s2 = total stone + current pocket
	j Check_Line_4_Loop
	
	End_Check_Line_4_Loop:
	li $t8, 0						#counter
	
	Check_Line_5_Loop:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)						#t0
	addi $sp, $sp, 1
	
	beq $t0, $t6, Check_Line_5_Loop
	beq $t0, $t7, End_Check_Line_5_Loop			#next line
	beq $t8, $s6, End_Check_Line_5_Loop			#ensure the space.
	
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t1, 0($sp)						#t1
	addi $sp, $sp, 1
	sub $t3, $t0, $t5
	mul $t3, $t3, $t4					#t3 = t0 * 10
	sub $t0, $t1, $t5
	add $t3, $t3, $t0					#t3 = t3 + t1
	add $s2, $s2, $t3					#s2 = total stone + current pocket
	addi $t8, $t8, 1					#counter++
	j Check_Line_5_Loop					#when end line 5, total stone is calculated and store into $s2.
								
	End_Check_Line_5_Loop:
	li $v0, 16						#close file call
	syscall							#a0 remains unchange throughout this function
	
	li $v0, 13						#open file call
	move $a0, $s1						#a0 = string address
	li $a1, 0						#a1 = 0 is reading mode
	syscall
	
	move $a0, $v0						#a0 = file descriptor
	li $t5, '0'
	li $t6, '\r'
	li $t7, '\n'
	
	# t9 = address of asciiz
	Add_First_Character_Of_Line_1_to_asciiz:
	sb $t5, 0($t9)						#set first to '0'
	addi $t9, $t9, 1
	
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)						#t0
	addi $sp, $sp, 1
	
	sb $t0, 0($t9)						#set second one to the first character
	addi $t9, $t9, 1
	
	Add_Second_Character_Of_Line_1_to_asciiz:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t1, 0($sp)						#t1
	addi $sp, $sp, 1
	
	beq $t1, $t6, Add_Second_Character_Of_Line_1_to_asciiz
	beq $t1, $t7, End_Add_Character_Of_Line_1_to_asciiz	#next line
	
	addi $t9, $t9, -1					#run here if top mancala is more than 9.
	addi $t9, $t9, -1					#go to index zero of ascciz
	sb $t0, 0($t9)						
	addi $t9, $t9, 1
	sb $t1, 0($t9)	
	addi $t9, $t9, 1					#empty index
	j Add_Second_Character_Of_Line_1_to_asciiz		#If there contain more than 2 characters in first line (rocks exceed limit at end)
	
	End_Add_Character_Of_Line_1_to_asciiz:
	Skip_Second_Line:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Skip_Second_Line				
	beq $t0, $t7, End_Skip_Second_Line
	j Skip_Second_Line
	
	End_Skip_Second_Line:
	
	Skip_Third_Line:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Skip_Third_Line				
	beq $t0, $t7, End_Skip_Third_Line
	j Skip_Third_Line
	
	End_Skip_Third_Line:
	
	Add_Fourth_Line_To_Asciiz:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Add_Fourth_Line_To_Asciiz				
	beq $t0, $t7, End_Add_Fourth_Line_To_Asciiz
	
	sb $t0, 0($t9)
	addi $t9, $t9, 1
	j Add_Fourth_Line_To_Asciiz
	
	End_Add_Fourth_Line_To_Asciiz:
	li $t8, 0
	Add_Fifth_Line_To_Asciiz:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1

	beq $t0, $t6, Add_Fifth_Line_To_Asciiz				
	beq $t0, $t7, End_Add_Fifth_Line_To_Asciiz
	beq $t8, $s3, End_Add_Fifth_Line_To_Asciiz
	
	sb $t0, 0($t9)
	addi $t9, $t9, 1
	addi $t8, $t8, 1
	j Add_Fifth_Line_To_Asciiz
	
	End_Add_Fifth_Line_To_Asciiz:
	li $v0, 16						#close file call
	syscall							#a0 remains unchange throughout this function
	
	li $v0, 13						#open file call
	move $a0, $s1						#a0 = string address
	li $a1, 0						#a1 = 0 is reading mode
	syscall
	
	move $a0, $v0						#a0 = file descriptor
	li $t5, '0'
	li $t6, '\r'
	li $t7, '\n'
	
	Skip_First_Line:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, Skip_First_Line				
	beq $t0, $t7, End_Skip_First_Line
	j Skip_First_Line
	
	End_Skip_First_Line:
	
	
	Add_Bot_Character_Of_Line_2_to_asciiz:
	sb $t5, 0($t9)						#set first to '0'
	addi $t9, $t9, 1
	
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)						#t0
	addi $sp, $sp, 1
	
	sb $t0, 0($t9)						#set second one to the first character
	addi $t9, $t9, 1
	
	Add_Second_Bot_Character_Of_Line_2_to_asciiz:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t1, 0($sp)						#t1
	addi $sp, $sp, 1
	
	beq $t1, $t6, Add_Second_Bot_Character_Of_Line_2_to_asciiz
	beq $t1, $t7, End_Add_Bot_Character_Of_Line_2_to_asciiz	#next line
	
	addi $t9, $t9, -1					#run here if top mancala is more than 9.
	addi $t9, $t9, -1					#go to index zero of ascciz
	sb $t0, 0($t9)						
	addi $t9, $t9, 1
	sb $t1, 0($t9)	
	addi $t9, $t9, 1					#empty index
	j Add_Second_Bot_Character_Of_Line_2_to_asciiz		#If there contain more than 2 characters in first line (rocks exceed limit at end)
	
	
	End_Add_Bot_Character_Of_Line_2_to_asciiz:		#Finish initialize the state
	li $v0, 16						#close file call
	syscall							#a0 remains unchange throughout this function
	
	li $t0, 99
	bgt $s2, $t0, Stone_Exceed				# # of stone > 99 ?
	li $v0, 1
	j Check_Pockets
	
	Stone_Exceed:
	li $v0, 0
	
	Check_Pockets:
	bge $s3, $t0, Pockets_Exceed				# # of pockets >= 99?   > 98?
	move $v1, $s3
	j finish_load_game
	
	Pockets_Exceed:
	li $v1, 0
	j finish_load_game
	
	load_game_file_dont_exit:
	li $v0, -1
	li $v1, -1
	
	finish_load_game:
	jr $ra
	
	
# a0 = state, a1 = byte player, a2 = byte distance
# v0 = -1 if error ; return # of stone at target pocket.

#Part 2 Checked, all good.
get_pocket:
	li $t0, 'B'
	beq $a1, $t0, get_pocket_valid_player
	li $t0, 'T'
	beq $a1, $t0, get_pocket_valid_player
	li $v0, -1						# If byte player != 'B' or 'T', v0 = -1
	j finish_get_pocket
	
	get_pocket_valid_player:
	lbu $t6, 2($a0)
	blt $a2, $t6, get_pocket_Check_valid_distance
	li $v0, -1						# If distance >= # of pockets
	j finish_get_pocket
	
	get_pocket_Check_valid_distance:
	bge $a2, $zero, get_pocket_valid_distance
	li $v0, -1						# If distance < 0 / negative
	j finish_get_pocket
	
	get_pocket_valid_distance:
	addi $a0, $a0, 6					# move a0's adress to the .ascizz's address
	li $t0, 'B'
	beq $a1, $t0, get_pocket_is_player_B			# If it is player B
	#else if it is player T
	addi $t0, $zero, 2
	mul $t1, $a2, $t0					# t1 = distance * 2
	add $t0, $t0, $t1					# t0 = located of the pocket.
	add $a0, $a0, $t0					# a0 = address of the target pocket.
	lbu $t4, 0($a0)						# t4 = 1st byte
	lbu $t5, 1($a0)						# t5 = 2nd byte
	j get_pocket_calculating_stones
	
	get_pocket_is_player_B:
	addi $t0, $zero, 2
	mul $t1, $t6, $t0					# t1 = pockets * 2
	add $t0, $t0, $t1
	add $t0, $t0, $t1					# t0 = located of the pocket at bot mancala / still need to - # of distance * 2 - 2
	li $t1, 2
	sub $t0, $t0, $t1					# t0 = located of the pocket at bot row left of bot mancala / still need to - # of distance * 2
	mul $t1, $a2, $t1					# t1 = distance * 2
	sub $t0, $t0, $t1
	add $a0, $a0, $t0					# a0 = address of the target pocket.
	lbu $t4, 0($a0)						# t4 = 1st byte
	lbu $t5, 1($a0)						# t5 = 2nd byte
	
	get_pocket_calculating_stones:
	li $t0, '0'
	li $t1, 10	
	sub $v0, $t4, $t0					# v0 = first digit
	mul $v0, $v0, $t1					# v0 = v0 * 10
	sub $t5, $t5, $t0					# t5 = t5 - '0'
	add $v0, $v0, $t5					# v0 = return value
	
	finish_get_pocket:
	jr $ra
	
# a0 = state, a1 = byte player, a2 = byte distance, a3 = int size
# v0 = -1 or - 2 if error ; return # of stone at target pocket.

#Part 3 Checked, all good.
set_pocket:
	li $t0, 'B'
	beq $a1, $t0, set_pocket_valid_player
	li $t0, 'T'
	beq $a1, $t0, set_pocket_valid_player
	li $v0, -1						# If byte player != 'B' or 'T', v0 = -1
	j finish_set_pocket
	
	set_pocket_valid_player:
	lbu $t6, 2($a0)						# t6 = # of pockets
	blt $a2, $t6, set_pocket_Check_valid_distance
	li $v0, -1						# If distance >= # of pockets
	j finish_set_pocket
	
	set_pocket_Check_valid_distance:
	bge $a2, $zero, set_pocket_valid_distance
	li $v0, -1						# If distance < 0 / negative
	j finish_set_pocket
	
	set_pocket_valid_distance:
	bge $a3, $zero, set_pocket_positive_size
	li $v0, -2						# size is negative
	j finish_set_pocket
	
	set_pocket_positive_size:
	li $t0, 99
	ble $a3, $t0, set_pocket_valid_size
	li $v0, -2						# size > 99
	j finish_set_pocket
	
	set_pocket_valid_size:
	
	set_pocket_size_to_character:				#make $a3 becomes two bits.
	li $t0, '0'						
	li $t1, 10
	div $a3, $t1						# size / 10
	mflo, $t2						# quotient
	mfhi, $t3						# remainder
	add $t8, $t0, $t2					# t8 = first byte
	add $t9, $t0, $t3					# t9 = second byte
	
	addi $a0, $a0, 6					# a0 = address of the asciiz
	li $t0, 'B'
	beq $a1, $t0, set_pocket_is_player_B			# jump if player is B
	# player is T operation
	addi $t0, $zero, 2					# t0 = 2
	mul $t1, $a2, $t0					# t1 = distance * 2
	add $t0, $t0, $t1					# t0 = taget distance of the pocket
	add $a0, $a0, $t0					# a0 = effective address of the target pocket					
	sb $t8, 0($a0)						
	sb $t9, 1($a0)
	move $v0, $a3						# return value = size
	j finish_set_pocket
	
	set_pocket_is_player_B:
	li $t0, 2						# t0 = 2
	mul $t6, $t6, $t0					
	mul $t6, $t6, $t0					# t6 = pocket next to mancala
	mul $t0, $a2, $t0
	sub $t6, $t6, $t0
	add $a0, $a0, $t6					# a0 = effective address of the target pocket
	sb $t8, 0($a0)						
	sb $t9, 1($a0)
	move $v0, $a3						# return value = size
	
	finish_set_pocket:
	jr $ra
	

# a0 = state, a1 = byte player, a2 = int stones
# v0 = -1 or -2 if error; else return stones(a2)

#Part 4 Checked, all good.
collect_stones:
	li $t0, 'B'
	beq $a1, $t0, collect_stones_valid_player
	li $t0, 'T'
	beq $a1, $t0, collect_stones_valid_player
	li $v0, -1						# if player != 'B' and != 'T'
	j finish_collect_stones
	
	collect_stones_valid_player:
	bgt $a2, $zero, collect_stones_valid_stones
	li $v0, -2						# if stones <= 0
	j finish_collect_stones
	
	collect_stones_valid_stones:
	move $v0, $a2						# v0 = return value / a2
	li $t0, 'B'
	beq $a1, $t0, collect_stones_is_player_B
	
	addi $a0, $a0, 1					# a0 = address of top mancala
	lbu $t0, 0($a0)						# t0 = value of top mancala
	add $t0, $t0, $a2					# t0 = number of stones in top mancala after add
	sb $t0, 0($a0)						# store byte in top mancala
	li $t1, 10
	li $t2, '0'
	div $t0, $t1
	mflo, $t3						# quotient
	mfhi, $t4						# remainder
	add $t8, $t2, $t3					# t8 = first byte
	add $t9, $t2, $t4					# t9 = second byte
	
	addi $a0, $a0, 5					# a0 = address of the asciiz
	sb $t8, 0($a0)
	sb $t9, 1($a0)
	j finish_collect_stones					# finished change to asciiz
	
	collect_stones_is_player_B:
	lbu $t0, 0($a0)						# t0 = value of bot mancala  /a0 = address of bot mancala
	add $t0, $t0, $a2					# t0 = number of stones in bot mancala after add
	sb $t0, 0($a0)						# store byte in bot mancala
	li $t1, 10
	li $t2, '0'
	div $t0, $t1
	mflo, $t3						# quotient
	mfhi, $t4						# remainder
	add $t8, $t2, $t3					# t8 = first byte
	add $t9, $t2, $t4					# t9 = second byte
	
	lbu $t6, 2($a0)						# t6 = # of pockets
	addi $a0, $a0, 6					# a0 = address of the asciiz
	li $t0, 2
	mul $t6, $t6, $t0
	mul $t6, $t6, $t0					# t6 = located at nearby pocket of bot mancala
	add $t6, $t6, $t0					# t6 = located at bot mancala
	add $a0, $a0, $t6					# a0 = address of bot mancala
	sb $t8, 0($a0)
	sb $t9, 1($a0)						# finished store bytes in asciiz
	
	finish_collect_stones:
	jr $ra
	
	
# a0 = state, a1 = byte origin_pocket, a2 = byte distance
# v0 = 2 if a2 == 99, 1 if legal move, 0 if origin_pocket has 0 stones, -1 if origin_pocket is invalid row, -2 if distance == 0 or not equal to number of stones

#Part 5 Checked, all good.
verify_move:
	li $t0, 99
	bne $a2, $t0, verify_move_distance_not_99
	# a2 == 99,   next 3 lines get the byte of # executed_move increment by 1
	lbu $t0, 4($a0)
	addi $t0, $t0, 1					# executed_move + 1		
	sb $t0, 4($a0)
	li $v0, 2						# a2 == 99
	li $t0, 'B'
	lbu $t6, 5($a0)
	beq $t0, $t6, verify_move_distance_99_is_player_B	#Is player B
	#Not player B, which means it is player T
	li $t0, 'B'
	sb $t0, 5($a0)						#Change player turn from 'T' to 'B'
	j finish_verify_move
	
	verify_move_distance_99_is_player_B:
	li $t0, 'T'
	sb $t0, 5($a0)						#Change player turn from 'B' to 'T'
	j finish_verify_move
	
	verify_move_distance_not_99:
	lbu $t0, 2($a0)						# t0 = # of pockets in a row
	verify_move_check_valid_row:
	blt $a1, $t0, verify_move_check_no_stones		# if origin_pocket is valid location            < # pockets
	li $v0, -1						# >= # of pockets   /   invalid row
	j finish_verify_move
	
	verify_move_check_no_stones:
	li $t0, 'B'
	lbu $t1, 5($a0)
	beq $t0, $t1, verify_move_check_no_stones_is_player_B	# go to label if current turn is player B
	#Not player B, which means it is player T
	
	addi $a0, $a0, 6					# $a0 = address of asciiz
	li $t0, 2
	mul $t1, $a1, $t0					# orginal_pocket * 2
	add $t0, $t0, $t1					# t0 = located of origin_pocket
	add $a0, $a0, $t0					# a0 = effective address of pocket
	lbu $t8, 0($a0)						# t8 = first byte
	lbu $t9, 1($a0)						# t9 = first byte
	j verify_move_check_no_stones_is_zero
	
	verify_move_check_no_stones_is_player_B:
	
	lbu $t6, 2($a0)						# t6 = # of pockets
	addi $a0, $a0, 6					# $a0 = address of asciiz
	li $t0, 2
	mul $t6, $t6, $t0					# t6 = # of pockets * 2
	mul $t6, $t6, $t0					# t6 = # of pockets * 2
	add $a0, $a0, $t6					# a0 = address of nearby pocket of bot mancala
	mul $t1, $a1, $t0					
	sub $a0, $a0, $t1					# a0 = effective address of pocket
	lbu $t8, 0($a0)						# t8 = first byte
	lbu $t9, 1($a0)						# t9 = first byte
	
	verify_move_check_no_stones_is_zero:
	
	li $t0, '0'
	li $t1, 10
	sub $t2, $t8, $t0					# t2 = value of first byte
	mul $t2, $t2, $t1					# t2 = t2 * 10
	sub $t3, $t9, $t0					# t3 = value of second byte
	add $t2, $t2, $t3					# t2 = # of stone in pocket
	bgt $t2, $zero, verify_move_no_stones_is_not_zero	# # of stone in pocket is not zero!!!
	li $v0, 0						# # of stone in origin_pocket_is 0!!!
	j finish_verify_move
	
	verify_move_no_stones_is_not_zero:
	beq $t2, $a2, verify_move_no_stones_is_equal_to_distance
	li $v0, -2						# # of stone in origin_pocket != distance
	j finish_verify_move
	
	verify_move_no_stones_is_equal_to_distance:
	li $v0, 1
	
	finish_verify_move:
	jr  $ra
	

# a0 = state, a1 = byte origin_pocket
# v0 = number of stone added to mancala ;  v1 = 2 if last deposit was in Mancala   , = 1 in the player's row and was empty, = 0 if deposit anywhere
# if last deposit was not in mancala , change the player's turn to another.
# if last deposit was in currently player's row and was empty, record the destination_pocket in s7.
# s0 = state
# s1 = byte origin_pocket
# s2 = byte of current player's turn
# s3 = byte of player in the current row
# s4 = # of stones remains
# s5 = # of stones to be add to mancala
# s6 = # current pocket's stones
# s7 = destination byte

#Part 6 Checked, all good.
execute_move:
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, 0($sp)						# store the ra into sp
	
	move $t9, $a0						# t9 = address of the state
	lbu $t0, 4($t9)						# # of moves executed
	addi $t0, $t0, 1					# increment by 1 after use this function call
	sb $t0, 4($t9)						# store # of moves executed back to the state
	
	move $s0, $a0						# s0 = state				
	move $s1, $a1						# s1 = byte origin_pocket

	lbu $t8, 2($t9)						# t8 = # of rows
	lbu $s2, 5($t9)						# s2 = byte of current player's turn
	lbu $s3, 5($t9)						# s3 = byte of player's row
	li $t1, 'B'
	beq $s2, $t1, execute_move_detect_player_B		# if == 'B'
	j execute_move_detect_player_T				# if != 'B'
	

	execute_move_detect_player_T:
	li $s5, 0						# s5 = # of stones to be add to mancala
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = byte player / current player's turn
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	move $s4, $v0						# s4 = number of stones now
	
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	li $a3, 0						# a3 = size
	jal set_pocket						# took all the stones in the pockets
	
	
	execute_move_player_T_stone_move_T_row:
	li $t0, 0
	beq $t0, $s4, execute_move_player_T_end			# no more stones
	# continue if there is stone left.
	addi $s1, $s1, -1					# next pocket     /     -1 counter-clock wise
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player / current row's player
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	
	blt $v0, $zero, execute_move_player_T_before_swap_row_to_B		# if distance is invalid
	# same row distance   /   and add stone is available
	addi $s6, $v0, 1					# s6 = # current pocket's stones + 1
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	move $a3, $s6						# a3 = stones to be added
	jal set_pocket						# add stones
	addi $s4, $s4, -1					# # of stones remain - 1
	j execute_move_player_T_stone_move_T_row
					
					
	execute_move_player_T_before_swap_row_to_B:
	addi $s4, $s4, -1					# # of stones remain - 1
	addi $s5, $s5, 1					# mancala's stone + 1
	li $s3, 'B'						# set row to player 'B'
	lbu $t0, 2($s0)						# t0 = # of rows
	move $s1, $t0						# s1 = byte distance now.
	j execute_move_player_T_stone_move_B_row
	
	
	execute_move_player_T_stone_move_B_row:
	li $t0, 0
	beq $t0, $s4, execute_move_player_T_end			# no more stones
	# continue if there is stone left.
	addi $s1, $s1, -1					# next pocket     /     -1 counter-clock wise
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player / current row's player
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	
	blt $v0, $zero,	execute_move_player_T_before_swap_row_to_T	# if distance is invalid
	# same row distance   /   and add stone is available
	addi $s6, $v0, 1					# s6 = # current pocket's stones + 1
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	move $a3, $s6						# a3 = stones to be added
	jal set_pocket						# add stones
	addi $s4, $s4, -1					# # of stones remain - 1
	j execute_move_player_T_stone_move_B_row
	
	
	execute_move_player_T_before_swap_row_to_T:
	li $s3, 'T'						# set row to player 'T'
	lbu $t0, 2($s0)						# t0 = # of rows
	move $s1, $t0						# s1 = byte distance now.
	j execute_move_player_T_stone_move_T_row
	
	
	execute_move_player_T_end:				# no more stones
	# check if last drop is in mancala
	li $t0, 'B'
	bne $t0, $s3, execute_move_player_T_end_last_drop_is_not_mancala
	# continue checking
	lbu $t0, 2($s0)						# # of row
	bne $t0, $s1, execute_move_player_T_end_last_drop_is_not_mancala
	# last drop is in mancala
	li $v1, 2
	j finish_execute_move
	
	execute_move_player_T_end_last_drop_is_not_mancala:
	li $t0, 'B'
	sb $t0, 5($s0)						# change player's turn
	bne $s2, $s3, execute_move_player_T_end_last_drop_is_not_empty	#it is in another player's pockets
	#continue checking
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = player
	move $a2, $s1						# a2 = distance
	jal get_pocket
	li $t0, 1
	bne, $t0, $v0, execute_move_player_T_end_last_drop_is_not_empty		# in own pockets but it is not empty before last drop.
	# last drop was empty
	li $v1, 1
	move $s7, $s1						# s7 = destination byte
	j finish_execute_move
	
	execute_move_player_T_end_last_drop_is_not_empty:
	li $v1, 0
	j finish_execute_move
	
	##Seperate Line
	
	
	
	execute_move_detect_player_B:
	li $s5, 0						# s5 = # of stones to be add to mancala
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = byte player / current player's turn
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	move $s4, $v0						# s4 = number of stones now
	
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	li $a3, 0						# a3 = size
	jal set_pocket						# took all the stones in the pockets
	
	
	execute_move_player_B_stone_move_B_row:
	li $t0, 0
	beq $t0, $s4, execute_move_player_B_end			# no more stones
	# continue if there is stone left.
	addi $s1, $s1, -1					# next pocket     /     -1 counter-clock wise
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player / current row's player
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	
	blt $v0, $zero, execute_move_player_B_before_swap_row_to_T		# if distance is invalid
	# same row distance   /   and add stone is available
	addi $s6, $v0, 1					#s6 = # current pocket's stones + 1
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	move $a3, $s6						# a3 = stones to be added
	jal set_pocket						# add stones
	addi $s4, $s4, -1					# # of stones remain - 1
	j execute_move_player_B_stone_move_B_row
	
	
	execute_move_player_B_before_swap_row_to_T:
	addi $s4, $s4, -1					# # of stones remain - 1
	addi $s5, $s5, 1					# mancala's stone + 1
	li $s3, 'T'						# set row to player 'T'
	lbu $t0, 2($s0)						# t0 = # of rows
	move $s1, $t0						# s1 = byte distance now.
	j execute_move_player_B_stone_move_T_row
	
	
	execute_move_player_B_stone_move_T_row:
	li $t0, 0
	beq $t0, $s4, execute_move_player_B_end			# no more stones
	# continue if there is stone left.
	addi $s1, $s1, -1					# next pocket     /     -1 counter-clock wise
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player / current row's player
	move $a2, $s1						# a2 = byte distance
	jal get_pocket
	
	blt $v0, $zero, execute_move_player_B_before_swap_row_to_B	# if distance is invalid
	# same row distance   /   and add stone is available
	addi $s6, $v0, 1					# s6 = # current pocket's stones + 1
	
	move $a0, $s0						# a0 = state
	move $a1, $s3						# a1 = byte player
	move $a2, $s1						# a2 = byte distance
	move $a3, $s6						# a3 = stones to be added
	jal set_pocket						# add stones
	addi $s4, $s4, -1					# # of stones remain - 1
	j execute_move_player_B_stone_move_T_row
	
	
	execute_move_player_B_before_swap_row_to_B:
	li $s3, 'B'						# set row to player 'B'
	lbu $t0, 2($s0)						# t0 = # of rows
	move $s1, $t0						# s1 = byte distance now.
	j execute_move_player_B_stone_move_B_row
	
	
	execute_move_player_B_end:				# no more stones
	# check if last drop is in mancala
	li $t0, 'T'
	bne $t0, $s3, execute_move_player_B_end_last_drop_is_not_mancala
	#continue checking
	lbu $t0, 2($s0)						# # of row
	bne $t0, $s1, execute_move_player_B_end_last_drop_is_not_mancala
	# last drop is in mancala
	li $v1, 2
	j finish_execute_move
	
	
	execute_move_player_B_end_last_drop_is_not_mancala:
	li $t0, 'T'
	sb $t0, 5($s0)						# change player's turn
	bne $s2, $s3, execute_move_player_B_end_last_drop_is_not_empty	#it is in another player's pockets
	#continue checking
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = player
	move $a2, $s1						# a2 = distance
	jal get_pocket
	li $t0, 1
	bne, $t0, $v0, execute_move_player_B_end_last_drop_is_not_empty		# in own pockets but it is not empty
	#last drop was empty
	li $v1, 1
	move $s7, $s1						# s7 = destination byte
	j finish_execute_move
	
	execute_move_player_B_end_last_drop_is_not_empty:
	li $v1, 0
	j finish_execute_move
	
	
	finish_execute_move:
	# add stones to mancala
	move $a0, $s0						# a0 = state
	move $a1, $s2						# a1 = current player
	move $a2, $s5						# a2 = stones add to manacala
	jal collect_stones
	# v0 = # stones add to mancala
	li $t0, -2
	beq $t0, $v0, finish_execute_move_zero
	j finish_execute_move_non_zero
	
	finish_execute_move_zero:
	li $v0, 0
	
	finish_execute_move_non_zero:
	
	return_finish_execute_move:
	lw $ra, 0($sp)						# return address
	addi $sp, $sp, 4					# reallocated the stack
	jr $ra
	

# a0 = state, a1 = byte destination_pocket ( ** $s7 from)
# v0 = number of stone added to mancala ;
# s0 = state
# s1 = byte destination_pocket
# s2 = stone added to mancala

#Part 7 Checked, all good.
steal:
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, 0($sp)						# store the return address
	
	move $s0, $a0						# s0 = state
	move $s1, $a1						# s1 = byte destination_pocket
	li $s2, 0						# s2 = stone added to mancala
	lbu $t0, 5($a0)
	li $t1, 'B'
	beq $t0, $t1, steal_player_B
	j steal_player_T
	
	steal_player_B:						# player B lost stones
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	lbu $t0, 2($s0)						# t0 = number of row
	sub $a2, $t0, $s1					# a2 = distance + 1
	addi $a2, $a2, -1					# a2 = distance
	jal get_pocket
	add $s2, $v0, $zero					# obtain B's stones
	
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	lbu $t0, 2($s0)						# t0 = number of row
	sub $a2, $t0, $s1					# a2 = distance + 1
	addi $a2, $a2, -1					# a2 = distance
	li $a3, 0						# a3 = 0
	jal set_pocket						# Took all rock from B's target pocket
	
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s1						# a2 = distance
	jal get_pocket
	add $s2, $s2, $v0					# obtain T's stones
	
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s1						# a2 = distance
	li $a3, 0						# a3 = 0
	jal set_pocket						# Took all rock from T's target pocket   (only 1...)
	
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s2						# a2 = number of stone add to mancala
	jal collect_stones
	j finish_steal
	
	
	steal_player_T:						# player T lost stones
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	lbu $t0, 2($s0)						# t0 = number of row
	sub $a2, $t0, $s1					# a2 = distance + 1
	addi $a2, $a2, -1					# a2 = distance
	jal get_pocket
	add $s2, $v0, $zero					# obtain T's stones
	
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	lbu $t0, 2($s0)						# t0 = number of row
	sub $a2, $t0, $s1					# a2 = distance + 1
	addi $a2, $a2, -1					# a2 = distance
	li $a3, 0						# a3 = 0
	jal set_pocket						# Took all rock from T's target pocket
	
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s1						# a2 = distance
	jal get_pocket
	add $s2, $s2, $v0					# obtain B's stones
	
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s1						# a2 = distance
	li $a3, 0						# a3 = 0
	jal set_pocket						# Took all rock from B's target pocket   (only 1...)
	
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s2						# a2 = number of stone add to mancala
	jal collect_stones
	
	finish_steal:
	lw $ra, 0($sp)						# load the return address
	addi $sp, $sp, 4
	jr $ra


# a0 = state
# v0 = 1 a row was found empty,       = 0 both row are not empty;          v1 = 0 tie,     = 1 if bot mancala have higher # stones,      = 2 if top mancala have higher # stones

# s0 = state
# s1 = # of rows
# s2 = 0 = counter
# s3 = # of stones in top pockets
# s4 = # of stones in bot pockets

# Part 8 Checked, all good
check_row:
	move $fp, $sp
	addi $sp, $sp, -4
	sw $ra, 0($sp)						# store the return address
	
	move $s0, $a0						# s0 = state
	lbu $s1, 2($s0)						# s1 = # of rows
	li $s2, 0						# s2 = 0 = counter
	li $s3, 0						# s3 = # of stones in top pockets
	li $s4, 0						# s4 = # of stones in bot pockets
	
	check_row_count_top_pockets:
	beq $s2, $s1, check_row_count_top_pockets_finish	# finish counting top pockets when s1 = s2
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s2						# a2 = distance
	jal get_pocket
	
	add $s3, $s3, $v0					# s3 = # of stones in top pockets increases
	addi $s2, $s2, 1					# s2 = s2 + 1   /   counter++
	j check_row_count_top_pockets
	
	check_row_count_top_pockets_finish:
	li $s2, 0						# reset counter
	
	check_row_count_bot_pockets:
	beq $s2, $s1, check_row_count_bot_pockets_finish	# finish counting top pockets when s1 = s2
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s2						# a2 = distance
	jal get_pocket
	
	add $s4, $s4, $v0					# s4 = # of stones in top pockets increases
	addi $s2, $s2, 1					# s2 = s2 + 1   /   counter++
	j check_row_count_bot_pockets
	
	check_row_count_bot_pockets_finish:
	li $s2, 0						# reset counter
	
	
	check_row_which_role_is_empty:
	beq $s3, $zero, check_row_top_role_is_empty
	beq $s4, $zero, check_row_bot_role_is_empty
	j check_row_no_role_is_empty				# When no row is empty
	
	check_row_top_role_is_empty:
	beq $s2, $s1, check_row_top_role_is_empty_finish
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s2						# a2 = distance
	li $a3, 0						# a3 = size
	jal set_pocket
	addi $s2, $s2, 1					# s2 = s2 + 1   /   counter++
	j check_row_top_role_is_empty
	
	check_row_top_role_is_empty_finish:			# After top row is empty, add s4 to the bot mancala
	move $a0, $s0						# a0 = state
	li $a1, 'B'						# a1 = player B
	move $a2, $s4						# a2 = stones
	jal collect_stones
	# add s4 to bot mancala
	li $v0, 1
	j check_row_return_v1
	
	
	check_row_bot_role_is_empty:
	beq $s2, $s1, check_row_bot_role_is_empty_finish
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s2						# a2 = distance
	li $a3, 0						# a3 = size
	jal set_pocket
	addi $s2, $s2, 1					# s2 = s2 + 1   /   counter++
	j check_row_bot_role_is_empty
	
	check_row_bot_role_is_empty_finish:			# After bot row is empty, add s3 to the top mancala
	move $a0, $s0						# a0 = state
	li $a1, 'T'						# a1 = player T
	move $a2, $s3						# a2 = stones
	jal collect_stones
	# add s4 to bot mancala
	li $v0, 1
	j check_row_return_v1
	
	
	check_row_no_role_is_empty:
	li $v0, 0						# no role is empty
	j check_row_return_v1
	
	
	check_row_return_v1:
	lbu $t1, 0($s0)						# number of stones in bot mancala
	lbu $t2, 1($s0)						# number of stones in top mancala
	bgt $t2, $t1, check_row_return_v1_top_mancala_bigger	# t2 > t1
	bgt $t1, $t2, check_row_return_v1_bot_mancala_bigger	# t1 > t2
	# equal
	li $v1, 0
	j finish_check_row
	
	check_row_return_v1_top_mancala_bigger:
	li $v1, 2
	j finish_check_row
	
	
	check_row_return_v1_bot_mancala_bigger:
	li $v1, 1
	j finish_check_row
	
	
	finish_check_row:
	lw $ra, 0($sp)						# load the return address
	addi $sp, $sp, 4
	jr $ra
	
	
# a0 = byte[] moves; a1 = string file name
# v0 = # of move in file(included invalid)

# s0 = byte[] moves
# s1 = Quantity of Column
# s2 = Quantity of Row

# Part 9 Checked, all good
load_moves:
	move $s0, $a0						# s0 = byte[] moves   /   array
	
	li $v0, 13						# open file call
	move $a0, $a1						# a0 = string address
	li $a1, 0						# a1 = 0 is reading mode
	syscall
	
	blt $v0, $zero, load_moves_file_dont_exist		# invalid file name
	move $a0, $v0		
	
	li $t6, '\r'
	li $t7, '\n'
	li $t5, '0'
	li $t4, 10
	li $s1, 0						# s1 = Quantity of Column
	
	load_moves_Check_Line_1_Loop:				#find the # of column
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, load_moves_Check_Line_1_Loop
	beq $t0, $t7, load_moves_End_Check_Line_1_Loop		#next line
	
	mul $s1, $s1, $t4					#s1 = s1 * 10
	sub $t1, $t0, $t5					#t1 = digit
	add $s1, $s1, $t1
	j load_moves_Check_Line_1_Loop				#looping
	
	load_moves_End_Check_Line_1_Loop:
	li $s2, 0						#initialize s2 = 0
	
	
	load_moves_Check_Line_2_Loop:
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	beq $t0, $t6, load_moves_Check_Line_2_Loop
	beq $t0, $t7, load_moves_End_Check_Line_2_Loop		#next line
	
	mul $s2, $s2, $t4					#s2 = s2 * 10
	sub $t1, $t0, $t5					#t1 = digit
	add $s2, $s2, $t1
	j load_moves_Check_Line_2_Loop				#looping
	
	load_moves_End_Check_Line_2_Loop:
	# s0 = array, $s1 = Quantity of Column , $s2 = Quantity of Row
	# t6 = counter of Column     # t7 = counter of Row
	# t5 = value temporary
	addi $s2, $s2, -1					# s2   decrement by 1
	li $t6, 0						# t6 = counter of Column
	li $t7, 0						# t7 = counter of Row
	li $t9, 0						# t9 = return value
	
	
	load_moves_Check_Line_3_Loop_with_99:
	
	li $t5, 0
	beq $t6, $s1, load_moves_Check_Line_3_Loop_with_99_row_quantity_increment
	beq $t7, $s2, load_moves_End_Check_Line_3_Loop_with_99
	
	addi $sp, $sp, -1					# obtain first byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t1, '0'
	li $t2, 10
	sub $t5, $t0, $t1					# t5 = value of first byte
	blt $t5, $zero, load_moves_Check_Line_3_Loop_with_99_first_byte_invalid
	bge $t5, $t2, load_moves_Check_Line_3_Loop_with_99_first_byte_invalid
	mul $t5, $t5, $t2					# t5 * 10
	
	addi $sp, $sp, -1					# obtain second byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t1, '0'
	li $t2, 10
	sub $t4, $t0, $t1					# t4 = value of second byte
	blt $t4, $zero, load_moves_Check_Line_3_Loop_with_99_second_byte_invalid
	bge $t4, $t2, load_moves_Check_Line_3_Loop_with_99_second_byte_invalid
	add $t5, $t5, $t4					# value of two character
	
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_with_99
	
	##line separator 
	load_moves_Check_Line_3_Loop_with_99_row_quantity_increment:
	li $t6, 0						# t6 = counter of Column / reset
	addi $t7, $t7, 1					# t7 = t7 + 1
	li $t5, 99
	
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_with_99			# check next row
	
	
	load_moves_Check_Line_3_Loop_with_99_first_byte_invalid:
	addi $sp, $sp, -1					# load next byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t5, 100
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_with_99			# check next column
	
	
	load_moves_Check_Line_3_Loop_with_99_second_byte_invalid:
	li $t5, 100
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_with_99			# check next column
	
	
	load_moves_End_Check_Line_3_Loop_with_99:
	li $t6, 0						# t6 = counter of Column
	
	load_moves_Check_Line_3_Loop_without_99:
	li $t5, 0
	beq $t6, $s1, load_moves_End_Check_Line_3_Loop_without_99
	
	addi $sp, $sp, -1					# obtain first byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t1, '0'
	li $t2, 10
	sub $t5, $t0, $t1					# t5 = value of first byte
	blt $t5, $zero, load_moves_Check_Line_3_Loop_without_99_first_byte_invalid
	bge $t5, $t2, load_moves_Check_Line_3_Loop_without_99_first_byte_invalid
	mul $t5, $t5, $t2					# t5 * 10
	
	addi $sp, $sp, -1					# obtain second byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t1, '0'
	li $t2, 10
	sub $t4, $t0, $t1					# t4 = value of second byte
	blt $t4, $zero, load_moves_Check_Line_3_Loop_without_99_second_byte_invalid
	bge $t4, $t2, load_moves_Check_Line_3_Loop_without_99_second_byte_invalid
	add $t5, $t5, $t4					# value of two character
	
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_without_99
	
	load_moves_Check_Line_3_Loop_without_99_first_byte_invalid:
	addi $sp, $sp, -1					# load next byte
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $sp, $sp, 1
	
	li $t5, 100
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_without_99		# check next column
	
	
	load_moves_Check_Line_3_Loop_without_99_second_byte_invalid:
	li $t5, 100
	sb $t5, 0($s0)						# store it into array
	addi $s0, $s0, 1					# address increment by 1
	addi $t6, $t6, 1					# t6 = $t6 + 1
	addi $t9, $t9, 1					# return value increment
	j load_moves_Check_Line_3_Loop_without_99		# check next column
	

	load_moves_End_Check_Line_3_Loop_without_99:
	move $v0, $t9
	j finish_load_moves
	
	
	load_moves_file_dont_exist:
	li $v0, -1
	
	finish_load_moves:
	jr $ra


# a0 = string moves_filename;   a1 = string board_filename;    a2 = GameState* state;    a3 = byte[] moves;       t0 = int num_moves_to_execute 
# v0 = winner ;  v1 = move executed
# Part 10 Checked, all good
play_game:
	addi $sp, $sp, -32
	sw $a0, 0($sp)						# a0 = string moves_filename
	sw $a1, 4($sp)						# a1 = string board_filename
	sw $a2, 8($sp)						# a2 = GameState* state
	sw $a3, 12($sp)						# a3 = byte[] moves
	sw $t0, 16($sp)						# t0 = int num_moves_to_execute
	sw $ra, 20($sp)						# ra
	li $t9, 0						
	sw $t9, 28($sp)						# t9 = counter
	
	#load game board
	lw $a0, 8($sp)						# state
	lw $a1, 4($sp)						# string board_filename
	jal load_game
	ble $v0, $zero, play_game_file_dont_exist		# file don't exist if -1 or number of stones exceed
	ble $v1, $zero, play_game_file_dont_exist		# file don't exist if -1 or number of pockets exceed
	
	#load moves
	lw $a0, 12($sp)						# byte[] moves
	lw $a1, 0($sp)						# string moves_filename
	jal load_moves
	ble $v0, $zero, play_game_file_dont_exist		# file don't exist if -1 or number of moves 0
	#if moves is valid
	sw $v0, 24($sp)						# 24sp = total number of moves in files
	
	#check rows before game
	play_game_check_rows_before:
	lw $a0, 8($sp)						# GameState* state
	jal check_row
	bne $v0, $zero, play_game_empty_row_end			# a row is empty
	
	
	#check maximum number of moves before game
	play_game_check_num_move_to_executed_before:
	lw $t0, 16($sp)						# int num_moves_to_execute
	ble $t0, $zero, play_game_num_move_to_executed_is_zero
	
	
	#if above conditions have no problem begin the game
	play_game_looping:
	
	lw $a0, 8($sp)						# GameState* state
	jal check_row
	bne $v0, $zero, play_game_empty_row_end			# a row is empty

	
	lw $t0, 8($sp)						# GameState* state
	lbu $t0, 4($t0)						# # of move executed
	lw $t1, 16($sp)						# int num_moves_to_execute
	beq $t0, $t1, play_game_looping_end			# looping end due to maximum number of moves
	
	lw $t1, 24($sp)						# total number of moves in files
	beq $t0, $t1, play_game_looping_end			# looping end due to maximum number of moves
	
	lw $t1, 28($sp)						# counter of moves run
	lw $t2, 24($sp)						# total number of moves in files
	beq $t1, $t2, play_game_looping_end			# looping end due all moves applied
	
	lw $t0, 12($sp)						# byte[] moves
	lbu $t1, 0($t0)						# t1 = one move
	addi $t0, $t0, 1					# byte[] moves + 1
	sw $t0, 12($sp)						# store it back
	lw $t0, 28($sp)						# t9 = counter
	addi $t0, $t0, 1					# counter++
	sw $t0, 28($sp)
	
	li $t0, 100
	beq $t0, $t1, play_game_looping				# invalid move, looping again
	#if move is valid
	
	move $s0, $t1
	lw $a0, 8($sp)						# GameState* state
	move $a1, $s0						# byte origin_pocket
	move $a2, $s0						# byte distance
	jal verify_move
	li $t0, 2
	beq $v0, $t0, play_game_looping				# a null move
	li $t0, -1
	beq $v0, $t0, play_game_looping				# invalid move due to invalid pocket, loop again move don't executed
	li $t0, 0
	beq $v0, $t0, play_game_looping				# invalid move due to zero stones in the pocket, loop again move don't executed
	
	#verify move is valid and number of stones != 0
	lw $a0, 8($sp)						# GameState* state
	move $a1, $s0						# byte origin_pocket
	jal execute_move
	beq $v1, $zero, play_game_looping			# Executed_Move Successful change player's turn
	li $t0, 2
	beq $v1, $t0, play_game_looping				# Executed_Move Successful this player have another turn
	
	#execute move performing stealing after it.
	lw $a0, 8($sp)						# GameState* state
	move $a1, $s7						# Destination pocket
	jal steal
	j play_game_looping
	
	
	play_game_looping_end:
	#This mean no one wins but no more moves to be executed
	li $v0, 0
	lw $t0, 8($sp)						# GameState* state
	lbu $v1, 4($t0)						# v1 = # of move executed
	j finish_play_game
	
	play_game_empty_row_end:
	move $v0, $v1						# v0 = winner or tie
	lw $t0, 8($sp)						# GameState* state
	lbu $v1, 4($t0)						# v1 = # of move executed
	j finish_play_game
	
	
	play_game_num_move_to_executed_is_zero:
	li $v0, 0						# v0 = no one wins
	lw $t0, 8($sp)						# GameState* state
	lbu $v1, 4($t0)						# v1 = # of move executed
	j finish_play_game
	
	
	play_game_file_dont_exist:
	li $v0, -1
	li $v1, -1
	j finish_play_game
	
	finish_play_game:
	lw $ra, 20($sp)
	addi $sp, $sp, 32
	jr  $ra
	
	
# a0 = GameState* state

# Part 11 tested, all good.
print_board:
	move $s0, $a0						# s0 = state
	lbu $t0, 2($a0)						# t0 = # of pockets
	addi $t1, $a0, 6					# t1 = address of the asciiz
	li $t2, 0						# t2 = counter
	
	print_board_top_mancala:
	lbu $a0, 0($t1)						# first character of top mancala
	li $v0, 11
	syscall
	
	lbu $a0, 1($t1)						# second character of top mancala
	li $v0, 11
	syscall
	
	li $a0, '\n'						# new line
	li $v0, 11
	syscall
	
	print_board_skip_second_and_third_line:
	beq $t2, $t0, print_board_skip_second_and_third_line_end
	addi $t2, $t2, 1					# counter++
	addi $t1, $t1, 4					# skip 4 characters
	j print_board_skip_second_and_third_line
	
	print_board_skip_second_and_third_line_end:
	addi $t1, $t1, 2					# move to the bot mancala address
	lbu $a0, 0($t1)						# first character of top mancala
	li $v0, 11
	syscall
	
	lbu $a0, 1($t1)						# second character of top mancala
	li $v0, 11
	syscall
	
	li $a0, '\n'						# new line
	li $v0, 11
	syscall
	
	addi $t1, $s0, 6					# t1 = address of the asciiz
	li $t2, 0						# t2 = counter
	addi $t1, $t1, 2					# skip first top mancala
	
	print_board_top_pockets_row:
	beq $t2, $t0, print_board_top_pockets_row_end
	lbu $a0, 0($t1)						# first character of top pocket
	li $v0, 11
	syscall
	
	lbu $a0, 1($t1)						# second character of top pocket
	li $v0, 11
	syscall
	
	
	addi $t2, $t2, 1					# counter++
	addi $t1, $t1, 2					# jump 2 characters
	j print_board_top_pockets_row
	
	
	print_board_top_pockets_row_end:
	li $a0, '\n'						# new line
	li $v0, 11
	syscall
	
	li $t2, 0
	
	print_board_bot_pockets_row:
	beq $t2, $t0, finish_print_board
	lbu $a0, 0($t1)						# first character of top pocket
	li $v0, 11
	syscall
	
	lbu $a0, 1($t1)						# second character of top pocket
	li $v0, 11
	syscall
	
	addi $t2, $t2, 1					# counter++
	addi $t1, $t1, 2					# jump 2 characters
	j print_board_bot_pockets_row
	
	finish_print_board:
	li $a0, '\n'						# new line
	li $v0, 11
	syscall
	
	jr $ra
	
	
# a0 = GameState* state
# s0 = state
# s1 = file descriptor
write_board:
	move $s0, $a0						# s0 = state
	
	addi $sp, $sp, -10
	li $t0, 'o'
	sb $t0, 0($sp)
	li $t0, 'u'
	sb $t0, 1($sp)
	li $t0, 't'
	sb $t0, 2($sp)
	li $t0, 'p'
	sb $t0, 3($sp)
	li $t0, 'u'
	sb $t0, 4($sp)
	li $t0, 't'
	sb $t0, 5($sp)
	li $t0, '.'
	sb $t0, 6($sp)
	li $t0, 't'
	sb $t0, 7($sp)
	li $t0, 'x'
	sb $t0, 8($sp)
	li $t0, 't'
	sb $t0, 9($sp)
	
	li $v0, 13						# open file for write
	move $a0, $sp
	li $a1, 1						# a1 = writing mode
	li $a2, 0
	syscall
	addi $sp, $sp, 10
	
	move $s1, $v0						# s1 = file descriptor
	
	lbu $t0, 2($s0)						# t0 = # of pockets
	addi $t1, $s0, 6					# t1 = address of the asciiz
	li $t2, 0						# t2 = counter
	
	write_board_top_mancala:
	lbu $t4, 0($t1)						# first character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	
	lbu $t4, 1($t1)						# second character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\r'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\n'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	write_board_skip_second_and_third_line:
	beq $t2, $t0, write_board_skip_second_and_third_line_end
	addi $t2, $t2, 1					# counter++
	addi $t1, $t1, 4					# skip 4 characters
	j write_board_skip_second_and_third_line
	
	write_board_skip_second_and_third_line_end:
	addi $t1, $t1, 2					# move to the bot mancala address
	
	lbu $t4, 0($t1)						# first character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	
	lbu $t4, 1($t1)						# second character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\r'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\n'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	addi $t1, $s0, 6					# t1 = address of the asciiz
	li $t2, 0						# t2 = counter
	addi $t1, $t1, 2					# skip first top mancala
	
	write_board_top_pockets_row:
	beq $t2, $t0, write_board_top_pockets_row_end
	
	lbu $t4, 0($t1)						# first character of top pocket
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	
	lbu $t4, 1($t1)						# second character of top pocket
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	addi $t2, $t2, 1					# counter ++
	addi $t1, $t1, 2					# jump 2 characters
	j write_board_top_pockets_row
	
	write_board_top_pockets_row_end:
	li $t4, '\r'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\n'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t2, 0						# reset counter
	
	write_board_bot_pockets_row:
	beq $t2, $t0, finish_write_board
	
	lbu $t4, 0($t1)						# first character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	
	lbu $t4, 1($t1)						# second character of top mancala
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	addi $t2, $t2, 1					# counter ++
	addi $t1, $t1, 2					# jump 2 characters
	j write_board_bot_pockets_row
	
	
	finish_write_board:
	li $t4, '\r'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li $t4, '\n'						# new line
	addi $sp, $sp, -1
	sb $t4, 0($sp)
	li $v0, 15						# write to file
	move $a0, $s1						# a0 = file descriptor
	move $a1, $sp
	li $a2, 1						# a2 = 1 character
	syscall
	addi $sp, $sp, 1
	
	li   $v0, 16       					# system call for close file
  	move $a0, $s1     					# file descriptor to close
  	syscall

	
	jr $ra
	
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
