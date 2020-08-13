#####################################################################################################################
# Final Project 
# By: Alexis K. Vu 
# CS 3340 - Dr. Karen Mazidi 
# This program will parse a mathematical expression given in Roman numerals and convert/calculate the decimal result
# 	Due: 7/22/2018
#####################################################################################################################

	.include "constants.asm"
	.include "macro_strings.asm"
	.include "macro_calculations.asm"

	.data

maxRead:	.space	50	# max num. of characters to be read in  
maxWrite:	.space	100	# max num. of characters to be written out 

operand1:	.word	0	# will hold value of first operand 
operand2:	.word	0	# will hold value of second operand 
resultNum:	.word	0	# will hold the solution to math expression 
addMode:	.word	1 	# indicates that user indicated add operation 
subMode:	.word	0	# indicates that user indicated sub operation 

	.text
main: 
	#####################  PROMPTING MESSAGES  ######################################################

	print(welcome)	# print welcome message
	print(features)	# print description of program functionality
	print(example)	# print example input for user to follow
	print(warning)	# print warning for input restrictions
	print(prompt)	# print Roman numeral expression prompt
	
	##################### READ & INTERPRET USER INPUT ######################################################
	
	# read in user's mathematical expression 
	li	$v0, 8			# system call to read in null-terminated string 
	la	$a0, maxRead		# load address w/ 50 bytes space 
	li	$a1, 50			# hard code necessary buffer space 
	move	$t0, $a0		# move string to accessible register 
					# $t0 = whole math expression 
	syscall				# execute 
	
	
	##################### COMPUTATIONS & CONVERSIONS ######################################################
	
	# load Roman Numerals into registers to use for comparisons 
	# use $s registers b/c preserved across procedure calls 
	lb	$s0, C
	lb	$s1, L
	lb	$s2, X
	lb	$s3, V
	lb 	$s4, I
	
	# load operations into registers to use for comparisons 
	lb	$s5, addition
	lb	$s6, subtraction
	li	$t3, 10			# ASCII code for newline (when user hits enter)
	lb	$t5, space 
	
	# load operand variables into registers for use 
	lw	$t1, operand1 		# $t1 = OPERAND 1 
	lw	$t2, operand2		# $t2 = OPERAND 2

# loop through string to gather first operand 
loopFirstOp: 
	lb	$a0, 0($t0)			# access set character in string 
	beq	$a0, $t3, printEmptyMessage	# if blank space or end of string --> catch error 
						# also catches error if no valid operator is present 
	beq	$a0, $t5, printEmptyMessage	# display empty message
	beq	$a0, $s5, markAdd		# add operand reached 
	beq	$a0, $s6, markSub		# sub operand reached 
	# continue reading string if not @ empty or operator 
	beq	$a0, $s0, first_add100 	# if char = C --> branch to add100
	beq	$a0, $s1, L_NextDigit1		# if char = L --> check out next char to determine value 	
	beq	$a0, $s2, X_NextDigit1		# if char = X --> check out next char
	beq	$a0, $s3, V_NextDigit1		# if char = V --> check out next char
	beq	$a0, $s4, I_NextDigit1		# if char = I --> check out next char

# loop through rest of string to gather second operand 
loopSecondOp:
	lb	$a0, 0($t0)			# access set character in string 
	beqz	$a0, checkMode			# if end of string - take note of operation
	beq	$a0, $t3, checkMode		# if reach newline - take note of operation
	beq	$a0, $t5, printEmptyMessage	# ask user to correct formatting 
	# continue reading string if not @ end 
	beq	$a0, $s0, second_add100 	# if char = C --> branch to add 100 
	beq	$a0, $s1, L_NextDigit2		# if char = L --> check out next char to determine value 
	beq	$a0, $s2, X_NextDigit2		# if char = X --> check out next char
	beq	$a0, $s3, V_NextDigit2		# if char = V --> check out next char
	beq	$a0, $s4, I_NextDigit2		# if char = I --> check out next char 

# terminate program 
exit: 
	li	$v0, 10		# system call for terminating program 
	syscall 		# execute 


########################## FIRST OPERAND FUNCTIONS  #############################################################

# add 100 to first operand 	
first_add100: 
	lw	$t9, valueC	# load equiv value into register for use 
	add	$t1, $t1, $t9 	# add equiv. decimal value 	
	addi	$t0, $t0, 1	# increment pointer to next char of string 
	li	$t9, 0		# clear $t9 for next use 
	j 	loopFirstOp	# return to loop through rest of string 

# add 50 to first operand 	
first_add50: 
	lw	$t9, valueL	# calculate equivalent rom. num. value 
	add	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# increment pointer to next char of string
	li	$t9, 0		# clear t9 for next use 
	j 	loopFirstOp	# return to loop through rest of string 

# sub 50 from first operand 
first_sub50: 
	lw	$t9, valueL	# calculate equivalent rom. num. value 
	sub	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer for next char 
	li	$t9, 0		# clear register 
	j 	loopFirstOp	# return to loop through rest of string 

# add 10 to first operand 
first_add10:
	lw	$t9, valueX	# retrieve equivalent rom. num. value 
	add	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer 
	li	$t9, 0		# clear register for next use 
	j 	loopFirstOp	# return to loop through rest of char 

# sub 10 from first operand 
first_sub10: 
	lw	$t9, valueX	# get RN equivalent 
	sub	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer 
	addi 	$t5, $t5, 1 	# incr. str. length
	li	$t9, 0		# clear register 
	j 	loopFirstOp	# loop to next char 

# add 5 to first operand 	
first_add5: 
	lw	$t9, valueV	# get RN equiv
	add	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer
	addi 	$t5, $t5, 1 	# incr. str. length
	li	$t9, 0		# clear register
	j 	loopFirstOp	# loop to next char 

# sub 5 from first operand 
first_sub5: 
	lw	$t9, valueV	# get RN equiv
	sub	$t1, $t1, $t9 	
	addi	$t0, $t0, 1	# move pointer 
	addi 	$t5, $t5, 1 	# inc. str. length
	li	$t9, 0		# clear register
	j 	loopFirstOp	# loop to next char 

# add 1 to first operand 	
first_add1: 
	lw	$t9, valueI
	add	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopFirstOp	# loop to next char 
	
# sub 1 from first operand 
first_sub1: 
	lw	$t9, valueI	# get RN equiv
	sub	$t1, $t1, $t9 
	addi	$t0, $t0, 1	# move pointer
	addi 	$t5, $t5, 1 	# inc. str. length
	li	$t9, 0		# clear register
	j 	loopFirstOp	# loop to next char 
	
	
########################## SECOND OPERAND FUNCTIONS  #############################################################

# add 100 to second operand 	
second_add100: 
	lw	$t9, valueC	# load equiv value into register for use 
	add	$t2, $t2, $t9 	
	addi	$t0, $t0, 1	# increment pointer to next char of string 
	addi	$t5, $t5, 1	# increment counter for length of string 
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# add 50 to second operand 	
second_add50: 
	lw	$t9, valueL	# get RN equiv
	add	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# sub 50 from second operand 
second_sub50:
	lw	$t9, valueL	# get RN equiv
	sub	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# add 10 to second operand 
second_add10:
	lw	$t9, valueX	# get RN equiv
	add	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# sub 10 from second operand 
second_sub10: 
	lw	$t9, valueX	# get RN equiv
	sub	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# add 5 to second operand 
second_add5: 
	lw	$t9, valueV	# get RN equiv
	add	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 
	
# sub 5 from second operand 
second_sub5: 
	lw	$t9, valueV	# get RN equiv
	sub	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# add 1 to second operand 
second_add1: 
	lw	$t9, valueI	# get RN equiv
	add	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

# sub 1 from second operand 
second_sub1: 
	lw	$t9, valueI	# get RN equiv
	sub	$t2, $t2, $t9 
	addi	$t0, $t0, 1	# move pointer
	li	$t9, 0		# clear register
	j 	loopSecondOp	# loop to next char 

########################## ROMAN NUMERAL FUNCTIONS #############################################################


# decrement pointer and subtract 50 from first operand 
Ldecr_w_Sub1: 
	addi	$t0, $t0, -1
	j 	first_sub50 

# decrement pointer and add 50 to first operand 
Ldecr_w_Add1: 
	addi	$t0, $t0, -1 
	j	first_add50 

# inspect next digit after L - determine whether to add or subtract L in first operand 
L_NextDigit1: 
	addi	$t0, $t0, 1			# increment pointer 
	lb	$a0, 0($t0)			# get byte from string 
	beq	$a0, $s1, printFormatError	# illegal to repeat L's
	beq	$a0, $s0, Ldecr_w_Sub1		# if larger digit is next 
	
	beq	$a0, $s5, Ldecr_w_Add1		# add if last digit in operand
	beq	$a0, $s6, Ldecr_w_Add1 	# add if last digit in operand 
	
	# if none of the above criteria are met - need to add 
	j	Ldecr_w_Add1

# decrement pointer and subtract 10 from first operand 
Xdecr_w_Sub1: 
	addi	$t0, $t0, -1
	j 	first_sub10 

# decrement pointer and add 10 to first operand 
Xdecr_w_Add1: 
	addi	$t0, $t0, -1 
	j	first_add10 

# inspect next digit after X and determine whether to add or subtract X quiv from first operand 			
X_NextDigit1: 
	addi	$t0, $t0, 1			# increment pointer 
	lb	$a0, 0($t0)			# get byte from string 
	beq	$a0, $s0, Xdecr_w_Sub1 	# subtract X if higher value digits follows it 
	beq	$a0, $s1, Xdecr_w_Sub1 
	
	beq	$a0, $s5, Xdecr_w_Add1		# add X if last digit in operand 
	beq	$a0, $s6, Xdecr_w_Add1
	
	j	Xdecr_w_Add1 			# else - add X 

# decrement pointer and add 5 from first operand 
Vdecr_w_Add1: 
	addi	$t0, $t0, -1 
	j	first_add5 

# decrement pointer and subtract 5 from first operand 
Vdecr_w_Sub1: 
	addi	$t0, $t0, -1
	j 	first_sub5 

# inspect next digit after V and determine whether to add or subtract V from first operand 
V_NextDigit1: 
	addi	$t0, $t0, 1			# move pointer 
	lb	$a0, 0($t0) 			# get byte from string 
	beq	$a0, $s3, printFormatError	# illegal to print V's twice 
	beq	$a0, $s5, Vdecr_w_Add1		# if last digit in operand - add 
	beq	$a0, $s6, Vdecr_w_Add1 
	
	beq	$a0, $s4, Vdecr_w_Add1 	# add if duplicate 1 after 
	
	j 	Vdecr_w_Sub1 			# else - subtract V 

# decrement pointer and add 1 to first operand 
Idecr_w_Add1: 
	addi	$t0, $t0, -1 
	j	first_add1 

# decrement pointer and subtract 1 from first operand 
Idecr_w_Sub1: 
	addi	$t0, $t0, -1 
	j	first_sub1

# inspect next digit after I to determine whether to add or subtract I from first operand 
I_NextDigit1: 
	addi	$t0, $t0, 1			# move pointer 
	lb	$a0, 0($t0) 			# get byte from string
	beq	$a0, $s5, Idecr_w_Add1		# if last digit in operand - add
	beq	$a0, $s6, Idecr_w_Add1
	beq	$a0, $s4, Idecr_w_Add1		# if equivalent 1 - add
	
	j 	Idecr_w_Sub1			# else - subtract 
	
################################################################################################################

# decrement pointer and subtract 50 from second operand 
Ldecr_w_Sub2: 
	addi	$t0, $t0, -1
	j 	second_sub50 

# decrement pointer and add 50 to second operand 
Ldecr_w_Add2: 
	addi	$t0, $t0, -1 
	j	second_add50 

# investigate next digit after L to determine whether to add or subtract L from second operand 
L_NextDigit2: 
	addi	$t0, $t0, 1			# increment pointer 
	lb	$a0, 0($t0)			# get byte from string 
	beq	$a0, $s1, printFormatError	# illegal to repeat L's 
	beq	$a0, $s0, Ldecr_w_Sub2		# if larger digit is next 
	
	beq	$a0, $t3, Ldecr_w_Add2		# add if reach newline (end)
	
	# if none of the above criteria are met - need to add 
	j	Ldecr_w_Add2

# decrement pointer and subtract 10 from second operand 
Xdecr_w_Sub2: 
	addi	$t0, $t0, -1
	j 	second_sub10 

# decrement pointer and add 10 to second operand 
Xdecr_w_Add2: 
	addi	$t0, $t0, -1 
	j	second_add10 

# investigate next digit after X to determine whether to add or subtract X from second operand 		
X_NextDigit2: 
	addi	$t0, $t0, 1			# increment pointer 
	lb	$a0, 0($t0)			# get byte from string 
	beq	$a0, $s0, Xdecr_w_Sub2 	# if greater value follows - subtract 
	beq	$a0, $s1, Xdecr_w_Sub2
	
	beq	$a0, $t3, Xdecr_w_Add2		# if reach end/newline - add
	
	j	Xdecr_w_Add2 			# else - add 

# decrement pointer and add 5 to second operand 
Vdecr_w_Add2: 
	addi	$t0, $t0, -1 
	j	second_add5 

# decrement pointer and subtract 5 from second operand 	
Vdecr_w_Sub2: 
	addi	$t0, $t0, -1
	j 	second_sub5 

# investigate next digit after V to determine whether to add or subtract V from second operand 
V_NextDigit2: 
	addi	$t0, $t0, 1			# move pointer
	lb	$a0, 0($t0) 			# get byte from string
	beq	$a0, $3, printFormatError	# illegal to print V's twice 
	beq	$a0, $t3, Vdecr_w_Add2		# if last digit (reach newline) - add
	
	beq	$a0, $s4, Vdecr_w_Add2 	# if smaller digit follows - add
	
	j 	Vdecr_w_Sub2 			# else - subtract 

# decrement pointer and add 1 to second operand 
Idecr_w_Add2: 
	addi	$t0, $t0, -1 
	j	second_add1 

# decrement pointer and subtract 1 from second operand 
Idecr_w_Sub2: 
	addi	$t0, $t0, -1 
	j	second_sub1

# investigate next digit after I to determine whether to add or subtract I from second operand 
I_NextDigit2: 
	addi	$t0, $t0, 1			# move pointer 
	lb	$a0, 0($t0) 			# get byte from string 
	beq	$a0, $t3, Idecr_w_Add2		# if last digit in operand (reach newline) - add 
	beq	$a0, $s4, Idecr_w_Add2		# add duplicate one 
	
	j 	Idecr_w_Sub2			# else - subtract 
	
	
################################################################################################################

printAnswer: 	
	print(userExpr)	# echo user's mathematical expression
	print(maxRead)	# print contents of buffer that hold user's expression input
	print(equals)	# print "equals"
	
	move 	$a0, $t8		# load address of solution
	li	$v0, 1			# system call for printing integer 
	syscall 			# execute 
	
	j exit 				# successful program termination 
	

########################## MODE FUNCTIONS #############################################################


# $t4 = HOLDS OPERATION MODE 
# keep track of operation - ADD
markAdd: 
	lw	$t4, addMode	# set mode for add 
	addi	$t0, $t0, 1	# increment pointer to second operand
	j	loopSecondOp	# read through second operand after operator 

# keep track of operation - SUBTRACT 
markSub: 
	lw	$t4, subMode	# set mode for subtract 
	addi	$t0, $t0, 1	# increment pointer to second operand 
	j	loopSecondOp	# read through second operand after operator 
	
	
########################## NUM CALCULATION FUNCTIONS #########################################################


# determines next course of calculation action based on which operator is in input 
checkMode: 
	lw	$t8, resultNum			# $t8 = NUMERICAL RESULT 
	beq	$t4, $zero, subtract 		# go to subtract method if mode = 0 
	
# else, will only reach add method if did not branch to subtract method after 
add: 
	addu	$t8, $t1, $t2			# $t8 = operand1 + operand2
	sw	$t8, resultNum 			# store result in RAM variable 
	j	printAnswer 			# convert decimal num to rom. rep
	
subtract: 
	jal	checkNegative			# make sure result will be valid before subtracting 
	subu	$t8, $t1, $t2			# $t8 = operand1 - operand2 
	sw	$t8, resultNum
	j	printAnswer			# convert decimal num. to rom. rep
	

########################## VALIDATION FUNCTIONS  #############################################################


# checks whether firstOperand <= secondOperand 	
checkNegative:
	beq	$t1, $t2, printErrorMessage	# if operands equal, print error message 
	slt	$t9, $t1, $t2			# if $t1 < $t2 true (invalid), $t9 = 1 --> else = 0
	bne	$t9, $zero, printErrorMessage	# if first op smaller, print error message 
	
	# if this point is reached, solution is positive and valid - jump back to subtract method 
	jr	$ra 

# print error string from negative/0 number result 
printErrorMessage: 
	print(negativeNum) 
	j	exit 			# terminate program

# reached if user does not enter an expression 
printEmptyMessage: 
	print(emptyStr)
	j	exit			# terminate program

# indicates user has entered unproperly formatted rom. numerals 
printFormatError: 
	print(badFormat)
	j	exit 			# terminate program
