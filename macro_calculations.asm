
# helps track the total value of a given operand by adding a given number to the running total
# inputs: operand - the operand being tracked
#	  addValue - the integer value to add to the operand's running sum 
#	  loopFunc - the function to loop back to at the end of the macro
#			will be iterating char by char through the given operand
.macro addToOperand(%operand, %addValue, %loopFunc)
	lw	$t9, %addValue			# load equiv value into register for use 
	add	%operand, %operand, $t9 	# add equiv. decimal value 	
	addi	$t0, $t0, 1			# increment pointer to next char of string 
	li	$t9, 0				# clear $t9 for next use 
	j 	%loopFunc			# return to loop through rest of string 
.end_macro
