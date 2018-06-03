@Now what are we going to do is that.
@when pressed the button the control should change
.equ SWI_Black_button,0x202@ check if black button is pressed
.equ SWI_Leds, 0x201   @ led pattern in r0
.equ SWI_Exit,0x11 	   @ exit from program
.equ SWI_Blue_Button,0x203 @ returns the pattern in r0
.equ SWI_LCD_Int,0x205
.equ SWI_LCD_String,0x204
.equ BLUE_KEY_00, 0x01 @button(0) 
.equ BLUE_KEY_01, 0x02 @button(1) 
.equ BLUE_KEY_02, 0x04 @button(2) 
.equ BLUE_KEY_03, 0x08 @button(3) 
.equ BLUE_KEY_04, 0x10 @button(4) 
.equ BLUE_KEY_05, 0x20 @button(5) 
.equ BLUE_KEY_06, 0x40 @button(6) 
.equ BLUE_KEY_07, 0x80 @button(7) 
.equ BLUE_KEY_10, 1<<8 @button(8) - different way to set 
.equ BLUE_KEY_11, 1<<9 @button(9) 
.equ BLUE_KEY_12, 1<<10 @button(10) 
.equ BLUE_KEY_13, 1<<11 @button(11) 
.equ BLUE_KEY_14, 1<<12 @button(12) 
.equ BLUE_KEY_15, 1<<13 @button(13) 
.equ BLUE_KEY_16, 1<<14 @button(14)
.equ BLUE_KEY_17, 1<<15 @button(15) 
.text
b main_fn
Failed_b:
	ldmia sp!,{r3,r4}
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@================================================
check_vertical_bottom:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	add r3,r3,#1
label1:	cmp r3,#8
	beq Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label2:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label3:	cmp r2,#0
	beq Failed_b
loop4:add r3,r3,#1
	cmp r3,#8
	beq Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes
	b loop4
h_r_changes:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	add r3,r3,#1 @ r3 has the value of i
	cmp r3,r0  @ i  < = h
	bls qwer
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@ for printing on console
	ldr r0,=hr_right
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr

@================================================
check_horizontal_right:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	add r4,r4,#1
label11:	cmp r4,#8
	beq Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label25:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label33:	cmp r2,#0
	beq Failed_b
loop5:	add r4,r4,#1
	cmp r4,#8
	beq Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes1
	b loop5
h_r_changes1:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer1:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	add r4,r4,#1 @ r4 has the value of i
	cmp r4,r1  @ i  < = v
	bls qwer1
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	ldr r0,=vr_bottom
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@================================================
check_horizontal_left:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	sub r4,r4,#1
label12:	cmp r4,#0
	blt Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label22:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label32:	cmp r2,#0
	beq Failed_b
loop6:	sub r4,r4,#1
	cmp r4,#0
	blt Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes2
	b loop6
h_r_changes2:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer22:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	sub r4,r4,#1 @ r4 has the value of i
	cmp r4,r1  @ i  > = v
	bge qwer22
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@ printing on console
	ldr r0,=vr_top  
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr

@================================================
check_vertical_top:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	sub r3,r3,#1
label14:cmp r3,#0
	blt Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label24:cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label34:	cmp r2,#0
	beq Failed_b
loop7:sub r3,r3,#1
	cmp r3,#0
	blt Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes4
	b loop7
h_r_changes4:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer4:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	sub r3,r3,#1 @ r3 has the value of i
	cmp r3,r0  @ i  > = h
	bge qwer4
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@printing on console
	ldr r0,=hr_left
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@===============================================
check_principle_diagonal_up:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	sub r3,r3,#1
	sub r4,r4,#1
label41:cmp r3,#0
	blt Failed_b
	cmp r4,#0
	blt Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label42:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label43:	cmp r2,#0
	beq Failed_b
loop8:sub r3,r3,#1
	sub r4,r4,#1
	cmp r4,#0
	blt Failed_b
	cmp r3,#0
	blt Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes44
	b loop8
h_r_changes44:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer45:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	sub r3,r3,#1 @ r3 has the value of i
	sub r4,r4,#1
	cmp r3,r0  @ i  > = h
	bge qwer45
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@printing on console
	ldr r0,=pd_top
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@===============================================
check_principle_diagonal_down:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	add r3,r3,#1
	add r4,r4,#1
label46:cmp r3,#8
	beq Failed_b
	cmp r4,#8
	beq Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label47:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label48:	cmp r2,#0
	beq Failed_b
loop9:add r3,r3,#1
	add r4,r4,#1
	cmp r4,#8
	beq Failed_b
	cmp r3,#8
	beq Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes49
	b loop9
h_r_changes49:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer50:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	add r3,r3,#1 @ r3 has the value of i
	add r4,r4,#1
	cmp r3,r0  @ i  < = h
	bls qwer50
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@printing on console
	ldr r0,=pd_bottom
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@================================================
check_diagonal_down:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	add r3,r3,#1
	sub r4,r4,#1
label51:cmp r3,#8
	beq Failed_b
	cmp r4,#0
	blt Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label52:	cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label53:	cmp r2,#0
	beq Failed_b
loop10:add r3,r3,#1
	sub r4,r4,#1
	cmp r4,#0
	blt Failed_b
	cmp r3,#8
	beq Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes54
	b loop10
h_r_changes54:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer55:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	add r3,r3,#1 @ r3 has the value of i
	sub r4,r4,#1
	cmp r3,r0  @ i  < = h
	bls qwer55
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@printing on console
	ldr r0,=d_bottom
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@================================================
check_diagonal_up:
	@ it is used to check the flippings in the right of position
	@ r3 - > column traversal , r4 -> row traversal
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	ldr  r9,=Present_config @ r9  = stor
	stmdb sp!,{r3,r4}
	sub r3,r3,#1
	add r4,r4,#1
label56:cmp r3,#0
	blt Failed_b
	cmp r4,#8
	beq Failed_b
	ldr r8,=turn
	ldr r8,[r8]  @ r8 has the value of player_turn
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]
label57:cmp r2,r8  @  stor[h][v] == c
	beq Failed_b
label58:	cmp r2,#0
	beq Failed_b
loop11:sub r3,r3,#1
	add r4,r4,#1
	cmp r4,#8
	beq Failed_b
	cmp r3,#0
	blt Failed_b
	mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	ldr r2,[r2]  @ r2  = stor[h][v]
	cmp r2,#0
	beq Failed_b
	cmp r2,r8
	beq h_r_changes59
	b loop11
h_r_changes59:
	ldr r0,=check_or_update
	ldr r0,[r0]
	cmp r0,#4
	beq return_success
	mov r0,r3
	mov r1,r4
	ldmia sp!,{r3,r4}
qwer60:mov r5,#32
	mul r7,r3,r5
	add r2,r7,r4,LSL #2
	add r2,r2,r9  @  r2 has stor + 32*h + 4*v
	str r8,[r2]
	sub r3,r3,#1 @ r3 has the value of i
	add r4,r4,#1
	cmp r4,r1  @ i  < = v
	bls qwer60
	@ update the success
	ldr r4,=Failed
	mov r5,#6
	str r5,[r4]
	@printing on console
	ldr r0,=d_top
	swi 2
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@=========================
return_success:
	@putting the success in the turn present
	ldr r4,=turn_present
	mov r5,#6
	str r5,[r4]
	ldmia sp!,{r3,r4}
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r14}
	mov pc,lr
@==============================================================
checking:
	@ loop all the entries
	@ 
	stmdb sp!,{r3,r4,r5,r6,r14}
	mov r3,#0
	mov r4,#0
loop_under_check:
	ldr r5,=check_or_update
	mov r6,#4
	str r6,[r5]
	bl check_horizontal
	bl check_vertical
	bl check_principle_diagonal
	bl check_diagonal
	ldr r6,=turn_present
	ldr r5,[r6]
	@ checking for success
	cmp r5,#6
	beq continue_progress
	add r3,r3,#1
	cmp r3,#8
	beq loop_under_double_check
	b loop_under_check
loop_under_double_check:
	mov r3,#0
	add r4,r4,#1
	cmp r4,#8
	beq under_progress
	b loop_under_check
under_progress:
	ldmia sp!,{r3,r4,r5,r6,r14}
	bl change_turn
	mov r3,#9
	b button_detect	
continue_progress:
	ldr r4,=turn_present
	mov r5,#6
	str r5,[r4]
	ldmia sp!,{r3,r4,r5,r6,r14}
	mov pc,lr
@================================================
update:
	@ r6 contains the player_turn
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r7,r8,r14}
	ldr r7,=Present_config
	@ 32 * r3 + 4 * r4
	mov r0,r3	@ storing the row value
	mov r8,#32
	mul r3,r8,r3  @  a = 32*a
	add r3,r3,r4,LSL #2 @ r3  =  32 * r3 + 4 * r4
	ldr r2,[r7,r3]  @ r2 = stor[r3][r4]
	cmp r2,#0
	bhi handle_repeat_input
	mov r3,r0  @  r3 has column traversal or row number
	
	@ we have value of turn in = turn location
	@ loading the value for update
	ldr r5,=check_or_update
	mov r6,#6  @ this is used for update
	str r6,[r5]
	@ now calling the update functions
	bl check_horizontal
	bl check_vertical
	bl check_diagonal
	bl check_principle_diagonal
	ldr r4,=Failed
	ldr r4,[r4]
	cmp r4,#6 @ 6 is for success
	beq handle1
	b handle2
handle1:
	bl counting_numbers
	bl display
	ldr r1,=ones_count1
	ldr r1,[r1]
	ldr r0,=twos_count1
	ldr r0,[r0]
	add r2,r1,r0
	cmp r2,#64
	beq declare_winner
	ldr r4,=Failed
	mov r5,#4
	str r5,[r4]
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r7,r8,r14}

	mov pc,lr
handle2:
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r7,r8,r14}
	mov r3,#9
	mov r0,#0
	b button_detect
handle_repeat_input:
	ldmia sp!,{r0,r1,r2,r4,r5,r7,r8,r14}
	mov r3,#9
	b button_detect
@================================================
check_horizontal:
	@r3  <---- rows traversal , r4 < ----- column traversal
	stmdb sp!,{r3,r4,r14}
	bl check_horizontal_right
	bl check_horizontal_left
	
	ldmia sp!,{r3,r4,r14}
	mov pc,lr
@========================================
check_vertical:
	@r3  <---- rows traversal , r4 < ----- column traversal
	stmdb sp!,{r3,r4,r14}
	bl check_vertical_top
	bl check_vertical_bottom
	ldmia sp!,{r3,r4,r14}
	mov pc,lr
@======================================
check_diagonal:
	@r3  <---- rows traversal , r4 < ----- column traversal
	stmdb sp!,{r3,r4,r14}
	bl check_diagonal_up
	bl check_diagonal_down
	ldmia sp!,{r3,r4,r14}
	mov pc,lr
@=======================================

check_principle_diagonal:
	@r3  <---- rows traversal , r4 < ----- column traversal
	stmdb sp!,{r3,r4,r14}
	bl check_principle_diagonal_up
	bl check_principle_diagonal_down
	ldmia sp!,{r3,r4,r14}
	mov pc,lr
@================================================
button_detect:
	@r6< - 1 or 2	
	swi SWI_Blue_Button
	cmp r0,#0
	beq button_detect
	;mov r1,#1		
	cmp r0,#BLUE_KEY_00 			@ button(1)
	beq button_pressed_1
	
	cmp r0,#BLUE_KEY_01			@ button(2)
	beq button_pressed_2
	
	cmp r0,#BLUE_KEY_02			@ button(3)
	beq button_pressed_3
	
	cmp r0,#BLUE_KEY_03			@ button(4)
	beq button_pressed_4
	
	cmp r0,#BLUE_KEY_04 			@ button(5)
	beq button_pressed_5
				
	cmp r0,#BLUE_KEY_05 			@ button(6)
	beq button_pressed_6
	
	cmp r0,#BLUE_KEY_06			@ button(7)
	beq button_pressed_7
	
	cmp r0,#BLUE_KEY_07	@ button(8)
	beq button_pressed_8
	
	cmp r0,#BLUE_KEY_10 			@ button(9)
	beq button_pressed_9
	
	cmp r0,#BLUE_KEY_11			@ button(10)
	beq button_pressed_10
	
	cmp r0,#BLUE_KEY_12			@ button(11)
	beq button_pressed_11
	
	cmp r0,#BLUE_KEY_13			@ button(12)
	beq button_pressed_12
	
	cmp r0,#BLUE_KEY_14 			@ button(13)
	beq button_pressed_13
				
	cmp r0,#BLUE_KEY_15 			@ button(14)
	beq button_pressed_14
	
	cmp r0,#BLUE_KEY_16 			@ button(15)
	beq button_pressed_15
	
	cmp r0,#BLUE_KEY_17			@ button(16)
	beq button_pressed_16
@==============================================
change_turn:
	stmdb sp!,{r6,r9}
	ldr r9,=turn @ load turn
	ldr r6,[r9]
	cmp r6,#1   
	beq change_two
	b change_one
change_two:
	mov r0,#0x01
	swi SWI_Leds
	mov r6,#2   @ if two then change to two
	str r6,[r9]
	ldmia sp!,{r6,r9}
	mov pc,lr
change_one:
	mov r0,#0x02
	swi SWI_Leds
	mov r6,#1	@ if one then change to two
	str r6,[r9]
	ldmia sp!,{r6,r9}
	mov pc,lr
@===========================================

button_pressed_1:
	@ r3 -> row no
	mov r3,#0
	b button_detect

button_pressed_9:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#0
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect

@=========================
button_pressed_2:
	@ r3 -> row no
	mov r3,#1
	b button_detect
button_pressed_10:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#1
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@==============================
button_pressed_3:
	@ r3 -> row no
	mov r3,#2
	b button_detect
button_pressed_11:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#2
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@============================
button_pressed_4:
	@ r3 -> row no
	mov r3,#3
	b button_detect
button_pressed_12:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#3
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@==========================
button_pressed_5:
	@ r3 -> row no
	mov r3,#4
	b button_detect
button_pressed_13:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#4
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@========================
button_pressed_6:
	@ r3 -> row no
	mov r3,#5
	b button_detect
button_pressed_14:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#5
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@==========================
button_pressed_7:
	@ r3 -> row no
	mov r3,#6
	b button_detect
button_pressed_15:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#6
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@==========================
button_pressed_8:
	@ r3 -> row no
	mov r3,#7
	b button_detect
button_pressed_16:
	@ r4 -> column no
	cmp r3,#9
	beq button_detect
	mov r4,#7
	bl update
	bl change_turn
	bl checking
	mov r3,#9
	b button_detect
@========================
counting_numbers:
	@ used for counting the number of ones and twos
	stmdb sp!,{r0,r1,r2,r3,r4,r5,r14}
	mov r5,#0
	ldr r4,=Present_config
	mov r0,#0
	mov r1,#0
loop_under_count:
	ldr r2,[r4,r5,LSL #2]
	cmp r2, #0
	beq next
	cmp r2, #1
	beq ones_count
	cmp r2, #2
	beq twos_count
	next:
	add r5, r5, #1
	cmp r5, #64
	blt loop_under_count
	@ returning back after storing values inthe memory
	
	ldr r5,=ones_count1
	str r0,[r5]
	ldr r5,=twos_count1
	str r1,[r5]
	add r2,r0,r1
	
	ldmia sp!,{r0,r1,r2,r3,r4,r5,r14}
	mov pc, lr
	
	ones_count:
	add r0, r0, #1
	b next
	twos_count:
	add r1, r1, #1
	b next
@================================
declare_winner:
	cmp r0, r1
	bgt winner1
	bls winner2
	b draw
	
	winner1:
	;swi 0x206 @ screen clear
	mov r0, #2
	mov r1, #13
	ldr r2,=winner_is_1
	swi SWI_LCD_String
	swi SWI_Exit
	
	winner2:
	;swi 0x206 @ screen clear
	mov r0, #2
	mov r1, #13
	ldr r2,=winner_is_2
	swi SWI_LCD_String
	swi SWI_Exit
	
	draw:
	;swi 0x206 @ screen clear
	mov r0, #2
	mov r1, #13
	ldr r2,=match_drawn
	swi SWI_LCD_String
	
	swi SWI_Exit
	
	
		  
@============================================================================	
display:
	@ r0,r1,r2,r3,r4,
	@ r4 has the address of Present_config
	ldr r4,=Present_config
	stmdb sp!,{r0,r1,r2,r3,r5,r6,r14}
	mov r0,#0					@ for columns display number
	mov r1,#0					@ for row display number
	ldr r2,=Intro_display		@ introduction string labell
	swi SWI_LCD_String			@ print the string on lcd
	mov r1,#0					@ now increasing the row number
loop1:
	add r1,r1,#1				@ this step prints 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7  i.e ., column numbers
	sub r2,r1,#1
	swi SWI_LCD_Int
	cmp r1,#8
	blo loop1					@ the loop ends here
	@ r1 < - 1,2 , 3, 4, 5, 6, 7, 8			@ the rows in which the othello is displayed
	@ r0 < - 2,4, 6, 8, 10, 12,14,16		@ the cols in which the othello is displayed
	@ r2 load from addr + 4*i
	mov r5,#0					@ initialise the value of r5 which is used to traverse the address
	mov r1,#1					@
	mov r6,#1					
loop2:
	mov r0,r6,LSL #1			@ traversing in columns ------->---->---->
	ldr r2,[r4,r5,LSL #2]
	swi SWI_LCD_Int
	add r6,r6,#1
	add r5,r5,#1
	cmp r6,#9
	blo loop2
loop3:							@ traversing in the row num  				 |
	add r1,r1,#1				@							 	 |
	mov r6,#1					@							 |
	cmp r1,#9					@							\  /
	blo loop2					@							 \/
	
	
	@displaying the ones and twos count
	mov r0,#10
	swi 0x208
	mov r0,#11
	swi 0x208
	mov r1, #10
	mov r0, #0
	ldr r2,=ones_count_is
	swi SWI_LCD_String
	mov r1, #11
	ldr r2,=twos_count_is
	swi SWI_LCD_String
	mov r0, #20
	ldr r3,=twos_count1
	ldr r2, [r3]
	swi SWI_LCD_Int
	mov r1, #10
	ldr r2,[r3,#-4]
	swi SWI_LCD_Int
	
	ldmia sp!,{r0,r1,r2,r3,r5,r6,r14}
	mov pc,lr
@==================================================================================================================
game_reset:
	ldr r4,=Present_config
	@ r4,contains the Present_config
	stmdb sp!,{r0,r1,r2,r3,r5,r6,r7,r8,r14}
	mov r2,#0
	mov r5,#0					@ initialise the value of r5 which is used to traverse the address
	mov r1,#1					@
	mov r6,#1					
loop22:
	mov r0,r6,LSL #1			@ traversing in rows ------->--(r4)-->---->
	str r2,[r4,r5,LSL #2]
	add r6,r6,#1
	add r5,r5,#1
	cmp r6,#9
	blo loop22
loop33:							@ traversing in the columns  				 |
	add r1,r1,#1				@								 |(r3)
	mov r6,#1					@							 |
	cmp r1,#9					@							\  /
	blo loop22					@							 \/
	mov r7,r4
	@ setting the ones and twos
	mov r2,#1
	mov r3,#3
	mov r4,#3			@ (3,3)
	mov r8,#32
	mul r3,r8,r3
	add r3,r3,r4,LSL #2
	str r2,[r7,r3]
	mov r3,#4
	mov r4,#4			@ (4,4)
	mov r8,#32
	mul r3,r8,r3
	add r3,r3,r4,LSL #2
	str r2,[r7,r3]
	mov r2,#2
	mov r3,#3
	mov r4,#4			@ (3,4)
	mov r8,#32
	mul r3,r8,r3
	add r3,r3,r4,LSL #2
	str r2,[r7,r3]
	mov r3,#4
	mov r4,#3			@ (4,3)
	mov r8,#32
	mul r3,r8,r3
	add r3,r3,r4,LSL #2
	str r2,[r7,r3]
	ldmia sp!,{r0,r1,r2,r3,r5,r6,r7,r8,r14}
	mov pc,lr
@==================================================
exit:
	swi SWI_Exit
@==================================================
Intro_displayd:
	@ this is used to display the welcome screen
	@ r0 for column number
	@r1 for row number
	mov r0,#2
	mov r1,#10
	ldr r2,=Welcome
	swi SWI_LCD_String
	mov r0,#5
	mov r1,#11
	ldr r2,=Press_Start
	swi SWI_LCD_String
	mov pc,lr
@===================================================
Black_detect:
	@ this is used to take the input from the black buttons
	swi SWI_Black_button
	cmp r0,#0
	beq Black_detect
	cmp r0,#1
	beq Act_on_right
	cmp r0,#2
	beq Act_on_left
	Act_on_right:
		mov pc,lr
	Act_on_left:
		@ clear screen
		swi 0x206
		b exit	
@return
@====================================================
main_fn:
	@ display welcome on the screen
	bl Intro_displayd	@ display the introduction
	bl Black_detect
	swi 0x206 @ screen clear
	@ take input from the button
	@ go to matrix
	mov r0,#0x02
	swi SWI_Leds
	ldr r4,=Present_config
	bl game_reset
	ldr r4,=Present_config
	bl display
	ldr r6,=turn
	ldr r6,[r6]
	b button_detect

.data

Intro_display: .asciz "  0 1 2 3 4 5 6 7"

.align
turn:.word 1
Present_config:
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
.word 0,0,0,0,0,0,0,0
ones_count1:
	.word 2
twos_count1:
	.word 2
Failed:
.word 4
turn_present:
.word 4 @ FOR TURN NOT PRESENT
check_or_update:
.word 4 @ 4 FOR CHECKING AND 6 FOR UPDATE
Invalid:
.asciz "wrong move"
hr_right:
.asciz "horizontal success right\n"
hr_left:
.asciz "horizontal success left\n"
vr_top:
.asciz "vertical success top\n"
vr_bottom:
.asciz "vertical success bottom\n"
pd_top:
.asciz "principle diagonal top success\n"
pd_bottom:
.asciz "principle diagonal bottom success\n"
d_top:
.asciz "diagonal top success\n"
d_bottom:
.asciz "diagonal bottom success\n"
Welcome:
.asciz "Welcome to the Othello GAME"
Press_Start:
.asciz "|| [1]Exit || [2]Start ||"
ones_count_is:
.asciz "Ones count :-"
twos_count_is:
.asciz "Twos count :-"
winner_is_1:
.asciz "The winner is player 1"
winner_is_2:
.asciz "The winner is player 2"
match_drawn:
.asciz "Match Drawn"
.end
