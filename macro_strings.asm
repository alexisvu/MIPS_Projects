
# prints given string parameter to the console
.macro print(%str)
	la	$a0, %str	# load address of string
	li	$v0, 4		# load system call for printing string
	syscall 		# execute string print
.end_macro	