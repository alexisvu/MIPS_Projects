
	.data

# program strings
welcome:	.asciiz	"Welcome to the Roman Numeral calculator!\n" 				
features:	.asciiz "This calculator can add and subtract Roman Numeral expressions with BINARY operators\n"	
example:	.asciiz "(Example: XIX+VIII) - Following this format is important - no spaces!\n"	
warning:	.asciiz "D and M Roman Numerals not included in this project\n" 		
prompt:		.asciiz	"Enter a mathematical expression in Roman Numerals: "			
userExpr:	.asciiz "\nUser expression: "
equals:		.asciiz	"Expression equals:  " 								
negativeNum:	.asciiz "Your number was invalid. Roman Numerals cannot represent zero or negative values. Please try again.\n"	
badFormat:	.asciiz "Please format your expression with one binary operator and standardized Roman Numeral rules and try again.\n" 
emptyStr:	.asciiz	"User did not enter an expression. Please try again.\n" 

# program characters
C:		.byte	'C'	# declare char reps of roman nums. and operators 
L:		.byte	'L'
X:		.byte	'X'
V:		.byte	'V'
I:		.byte	'I'
addition: 	.byte	'+'
subtraction: 	.byte	'-'
space:		.byte	' '

# Roman numeral values
valueC:		.word	100 	# num equiv of C
valueL:		.word	50	# num equiv of L
valueX:		.word	10	# num oquiv of X
valueV:		.word	5	# num equiv of V
valueI:		.word	1	# num equiv of I