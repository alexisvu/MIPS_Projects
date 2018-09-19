#################################################
# PALINDROME PROGRAM - VIRTUAL HACKATHON CHALLENGE 
# BY ALEXIS K. VU 
# CS 3340 - DR. MAZIDI 
#	DUE: 22 JULY 2018
#################################################

	.data
prompt:			.asciiz "Please enter a string, return to exit: " 	# string prompt 
strLabel: 		.asciiz	"\nLength of string is: " 
notPalindrome_msg:	.asciiz	"\nString is not a palindrome\n" 
palindrome_msg:		.asciiz	"\nString is a palindrome" 

maxRead:	.space	50	# max amount of characters to read in 

const2:		.word 	2
strLength:	.word 	0 	# will hold length of string entered by user - max should be 50 
newline:	.word	10	# holds newline to detect for empty strings 
loopCount:	.word	0 	# keeps track of how many comparisons should be made across string
	
	.text 

main: 
	# prompt user for string to test 
	la	$a0, prompt	# load address of string 
	li	$v0, 4		# system call to print string 
	syscall 		# execute 
	
	# read in string from user 
	li	$v0, 8		# system call for reading in string 
	la	$a0, maxRead	# load buffer space for read-in
	li	$a1, 50		# hard code max buffer space 
	syscall 		# execute 
	move	$t0, $a0	# move string to accessible register 
	move	$t5, $a0	# second iteration pointer 
	
	# load registers for comparison 
	lw	$t1, strLength # $t1 = LENGTH OF STRING 
	lw	$t2, loopCount 	# $t2 = HALF OF STRING LENGTH
	lw	$t3, const2	
	lb	$t3, newline 
	li	$t6, 0		# will keep track of how many compare iterations - should be <= $t2
	
	# find length of string 
	j	findStrLength 

# terminate program 
exit: 
	li	$v0, 10 
	syscall 

# find length of string entered by user 
findStrLength: 
	lb	$a0, 0($t0) 		# get single character from string 
	beq	$a0, $t3, printLength	# if string is empty or at end of string, print length and exit 
	addi	$t0, $t0, 1		# move pointer forward 
	addi	$t1, $t1, 1		# increment string length count 
	j	findStrLength		# repeat loop to count next character 

# divides length of string by 2
findHalfStr: 
	div	$t1, $t3		# str.length() / 2 
	mflo	$t2			# move integer quotient into loop count 
	
	j 	testPalindrome 		# go to palindrome testing

# print length of string 
printLength: 
	addi	$t0, $t0, -1		# move pointer backwards for later use 
	
	# print string label 
	la	$a0, strLabel		# load address of string label 
	li	$v0, 4			# system call for printing string 
	syscall				# execute 
	
	# print numeric length of string 
	move	$a0, $t1 		# load address of string length 
	li	$v0, 1			# system call to print integer 
	syscall 
	
	beq	$t1, $zero, exit	# exit program is string is empty 
	j	findHalfStr		# else, find half string length to set loop iteration amount 

testPalindrome: 
	lb	$a0, 0($t0)			# load first pointer - should still be @ back of string 
	lb	$a1, 0($t5)			# load character from forward pointing iterator - @ start of string 
	bne	$a0, $a1, notPalindrome 	# exit loop if corresponding char not same 
						# else - continue to test if palindrome 
	addi	$t5, $t5, 1			# move pointer forward 
	addi	$t0, $t0, -1			# move compare pointer backwards 
	addi	$t6, $t6, 1			# increment loop counter 
	
	blt	$t2, $t6, palindrome 		# if loop counter > str length, all palindrome tests passed
	j	testPalindrome			# if need to loop through more string, repeat test 

# print msg indicating string is a palindrome 
palindrome: 
	la	$a0, palindrome_msg	# load address of palindrome message 
	li	$v0, 4			# system call to print string 
	syscall				# execute 
	
	j 	exit			# go to end of program

# print msg indicating string is NOT palindrome
notPalindrome: 	
	la	$a0, notPalindrome_msg	# load address of not palindrome message
	li	$v0, 4			# system call to print string 
	syscall				# execute 
	
	j exit				# go to end of program 

