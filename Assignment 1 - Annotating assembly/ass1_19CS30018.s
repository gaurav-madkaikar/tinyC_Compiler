#  Name: Gaurav Madkaikar
#  Roll No: 19CS30018
#  Compilers Laboratory Assignment 1
	
#	Naming conventions used:
	# *rax: refers to the value contained within the register rax
	# (rax): refers to the address of the value contained within register rax

# ----------------- START OF ASSEMBLY CODE -----------------
	
	.file	"ass1_19CS30018.c"	# name of the source file
	.text						# indicates the start of the text-section of the program
	.section	.rodata			# read-only data section
	.align 8					# align with the 8-byte boundary (Since aligned memory access is faster)
# READ-ONLY DATA SECTION
# .string - Indicates the string constant present in the data section
.LC0:							# Label for the 1st f-string printf	
	.string	"Enter how many elements you want:"	
.LC1:							# Label for the 1st f-string scanf	
	.string	"%d"
.LC2:							# Label for the 2nd f-string printf	
	.string	"Enter the %d elements:\n"
.LC3:							# Label for the 3rd f-string printf	
	.string	"\nEnter the item to search"
.LC4:							# Label for the 4th f-string printf	
	.string	"\n%d found in position: %d\n"
	.align 8					# align with the 8-byte boundary
.LC5:							# Label for the 5th f-string printf	
	.string	"\nItem is not present in the list."

# MAIN FUNCTION
	.text						# text-section (Code starts here)
	.globl	main				# main is a global name that can be accessed throughout the program
	.type	main, @function		# main is a function
main:							# execution of main function
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp				# push the base pointer onto the stack (helpful in restoring the original state)
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			# *rsp = *rbp; set the new stack pointer "rsp"
	.cfi_def_cfa_register 6
	subq	$432, %rsp			# Allocate memory of 432 bytes for storing the local variables; rsp -= 432

	# Stack-smashing protection 
	movq	%fs:40, %rax		# Segment Addressing
	movq	%rax, -8(%rbp)		# *(rbp - 8) <-- rax; Allot value at the top of the stack
	xorl	%eax, %eax			# clear eax (Register "eax" is always cleared before any function call)

	leaq	.LC0(%rip), %rdi	# *rdi = .string from .LC0; using rip relative addressing, rdi is the first argument for any function
	call	puts@PLT			# call printf() taking rdi as an argument
								# puts@PLT is a compiler optimization since printf() here does not use any formatting strings

	leaq	-432(%rbp), %rax	# *rax <-- (rbp - 432) = &n; Allocate memory for variable n
	movq	%rax, %rsi			# *rsi <-- *rax = &n; Register "rsi" wil point to n
	leaq	.LC1(%rip), %rdi	# *rdi = .string from .LC1
	movl	$0, %eax			# Set *eax <-- 0 (Done before function call)
	call	__isoc99_scanf@PLT	# call scanf() taking rdi, rsi (&n) as arguments

	movl	-432(%rbp), %eax	# *eax <-- *(rbp - 432) = n; Store the value of n in register "eax"
	movl	%eax, %esi			# *esi <-- *eax = n; Assign value of n to register "esi"
	leaq	.LC2(%rip), %rdi	# *rdi = .string from .LC2
	movl	$0, %eax			# Set *eax <-- 0 (Done before function call)
	call	printf@PLT			# call printf() taking rdi, esi (n) as arguments
	movl	$0, -424(%rbp)		# i <-- 0; Variable i is initialized in the for-loop counter (&i = rbp - 24)
	jmp	.L2						# jump to Label L2

.L3:
	leaq	-416(%rbp), %rax	# *rax <-- (rbp - 416) = &a[0]; Allocate memory for integer array a[]
	movl	-424(%rbp), %edx	# *edx <-- *(rbp - 424) = i; Store the value of i in register "edx"
	movslq	%edx, %rdx			# sign-extend edx to rdx (32-bit to 64-bit), thus *rax <-- *edx = i
	salq	$2, %rdx			# *rdx <-- (i << 2) = (4 * i); Right shift value of i by 2 bits
	addq	%rdx, %rax			# *rax <-- a + (4 * i) = &a[i]; Store the address of a[i] in register "rax"
	movq	%rax, %rsi			# *rsi <-- &a[i]; Store the address of a[i] in register "rsi"
	leaq	.LC1(%rip), %rdi	# rdi = .string from .LC1
	movl	$0, %eax			# Set *eax <-- 0 (Done before function call)
	call	__isoc99_scanf@PLT	# call scanf() taking rdi, rsi (&a[i]) as arguments	
	addl	$1, -424(%rbp)		# Increment the counter (i = i + 1)

.L2:
	movl	-432(%rbp), %eax	# *eax <-- *(rbp - 432) = n; Register "eax" stores the value corresponding to n
	cmpl	%eax, -424(%rbp)	# Compare *eax and *(rbp - 424); Compare values of i and n
	jl	.L3						# jl: Jump if less; jumps to Label L3 if (i < n)

	movl	-432(%rbp), %edx	# *edx <-- *(rbp - 432) = n; Store the value of n in register "edx"
	leaq	-416(%rbp), %rax	# *rax <-- (rbp - 416) = &a[0]; Store the address of array a[] in register "rax"
	movl	%edx, %esi			# *esi <-- *edx = n; Register "esi" has the value of n
	movq	%rax, %rdi			# *rdi <-- *rax = &a[0]; Register "rdi" stores the address of the integer array a[]

	call	inst_sort			# call inst_sort() 

	leaq	.LC3(%rip), %rdi	# rdi = .string from .LC3
	call	puts@PLT			# call printf() taking rdi as an argument

	leaq	-428(%rbp), %rax	# *rax <-- (rbp - 428); Allocate memory for the variable "item"
	movq	%rax, %rsi			# *rsi <-- *rax = &item; Register "rsi" stores the address of item
	leaq	.LC1(%rip), %rdi	# rdi = .string from .LC1
	movl	$0, %eax			# Set *eax <-- 0 (Done before function call)
	call	__isoc99_scanf@PLT	# call scanf() taking rdi, rsi (&item) as arguments

	movl	-428(%rbp), %edx	# *edx <-- *(rbp - 428); Store the obtained value of item
	movl	-432(%rbp), %ecx	# *ecx <-- n; Assign the value of n to register "ecx"
	leaq	-416(%rbp), %rax	# *rax <-- (rbp - 416) = &a[0]; Register rax stores the address of array a[]
	movl	%ecx, %esi			# *esi <-- *ecx; Assign the value of n to register eax
	movq	%rax, %rdi			# *rdi <-- &a[0]; Register rdi stores the reference to array a[]

	call	bsearch				# call bsearch()

	movl	%eax, -420(%rbp)	# *(rbp - 420) <-- *eax; Store the obtained value for the variable "loc"
	movl	-420(%rbp), %eax	# *eax <-- *(rbp - 420) = loc; Store the value of loc in register eax
	cltq						# sign-extend eax to rax (32-bit to 64-bit)
	movl	-416(%rbp,%rax,4), %edx		# *edx <-- *(rbp + (4 * rax) - 416) = *(a + (4 * loc)) = a[loc]; Assign the value at a[loc] to register "edx"
	movl	-428(%rbp), %eax	# *eax <-- item; Assign the value of item to register "eax"

	cmpl	%eax, %edx			# Compare values of variables- item and a[loc]
	jne	.L4						# jump to Label L4 if (item != a[loc])

	movl	-420(%rbp), %eax	# *eax <-- loc; Store the value of loc in register "eax"
	leal	1(%rax), %edx		# *edx <-- (loc + 1); Value at rax + 1 is stored in register edx
	movl	-428(%rbp), %eax	# *eax <-- item
	movl	%eax, %esi			# *esi <-- *eax = item
	leaq	.LC4(%rip), %rdi	# rdi = .string from .LC4
	movl	$0, %eax			# Set *eax <-- 0 (Done before function call)
	call	printf@PLT			# call printf() taking rdi, esi (item) and edx (loc + 1) as arguments
	jmp	.L5						# Jump to Label L5

.L4:
	leaq	.LC5(%rip), %rdi	# rdi = .string from .LC5
	call	puts@PLT			# call printf() taking rdi as an argument

# Stack-mashing protection 
.L5:
	movl	$0, %eax			# Assign *eax <-- 0; Return value from main
	movq	-8(%rbp), %rcx		# *rcx <-- *(rbp - 8); Allot value at the top of the stack
	xorq	%fs:40, %rcx		# Segment Addressing
	je	.L7						# Jump to Label L7
	call	__stack_chk_fail@PLT	# call __stack_chk_fail() - reports a stack overflow

.L7:
	leave						# clear the stack
	.cfi_def_cfa 7, 8
	ret							# return from main
	.cfi_endproc

.LFE0:
	.size	main, .-main		# Indicates the distance from the start of main

# INSERTION SORT (inst_sort) 	
	.globl	inst_sort				# inst_sort is a global name 
	.type	inst_sort, @function	# inst_sort is a function
inst_sort:							# execution of inst_sort starts here
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp					# Push the base pointer onto the stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# set the new stack pointer "rsp"
	.cfi_def_cfa_register 6

	movq	%rdi, -24(%rbp)			# *(rbp - 24) <-- *rdi; Store local array num[]
	movl	%esi, -28(%rbp)			# *(rbp - 28) <-- *esi; Store local variable n
	movl	$1, -8(%rbp)			# j <-- 1; Set the loop counter (&j = (rbp - 8))
	jmp	.L9							# Jump to Label L9 (test of the outer loop)

.L13:	
	movl	-8(%rbp), %eax			# *eax <-- *(rbp - 8) = j; Assign register "eax" with the value of j 
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (rax * 4); rdx is assigned to 4 * j
	movq	-24(%rbp), %rax			# *rax <-- *(rbp - 24) = num; Assign *rax <-- num
	addq	%rdx, %rax				# *rax <-- num + (4 * j) = &num[j] 
	movl	(%rax), %eax			# *eax <-- num[j]
	movl	%eax, -4(%rbp)			# *(rbp - 4) <-- *eax; Assign k = num[j]
	movl	-8(%rbp), %eax			# *eax <-- j; Assign register "eax" with value of j
	subl	$1, %eax				# *eax <-- j - 1; Decrement value in eax 
	movl	%eax, -12(%rbp)			#  Assign i <-- (j - 1)
	jmp	.L10						# Jump to Label L10 (test of inner loop)

.L12:
	movl	-12(%rbp), %eax			# Assign *eax <-- i (&i = rbp - 12)
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (4 * i)
	movq	-24(%rbp), %rax			# *rax <-- num
	addq	%rdx, %rax				# Implies *rax <-- num + (4 * i) = &num[i]
	movl	-12(%rbp), %edx			# Assign *edx <-- i (&i = rbp - 12)
	movslq	%edx, %rdx				# sign-extend edx to rdx (32-bit to 64-bit)
	addq	$1, %rdx				# *rdx <-- i + 1
	leaq	0(,%rdx,4), %rcx		# *rcx <-- 4 * (i + 1)
	movq	-24(%rbp), %rdx			# *rdx <-- num
	addq	%rcx, %rdx				# *rdx <-- num + 4 * (i + 1) = &num[i+1]
	movl	(%rax), %eax			# *eax <-- num[i+1]; Assign the address of &num[i+1] to register "eax"
	movl	%eax, (%rdx)			# Assign num[i+1] = num[i]
	subl	$1, -12(%rbp)			# Decrement i by 1 (i--)

.L10:
	cmpl	$0, -12(%rbp)			# Compare value of i with 0 (&i = rbp - 12)
	js	.L11						# jump to Label L11 if i >= 0
	movl	-12(%rbp), %eax			# *eax <-- i
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (4 * i)
	movq	-24(%rbp), %rax			# *rax <-- num; Address of array num[] is assigned to register "rax" 
	addq	%rdx, %rax				# Assign *rax <-- num + (4 * i)
	movl	(%rax), %eax			# *eax <-- *rax; Assign eax <-- num[i] (rax holds the address of num[i])
	cmpl	%eax, -4(%rbp)			# Compare k and num[i+1] (&k = *(rbp - 4))
	jl	.L12						# Jump to Label L12 if (k < num[i])
									# Inside the inner for-loop
.L11:
	movl	-12(%rbp), %eax			# Assign eax <-- i
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	addq	$1, %rax				# Assign rax <-- i + 1
	leaq	0(,%rax,4), %rdx		# rdx <-- 4 * (i + 1)
	movq	-24(%rbp), %rax			# *rax <-- *(rbp - 24) = num;
	addq	%rax, %rdx				# *rdx <-- num + (4 * (i + 1)) = &num[i + 1] 
	movl	-4(%rbp), %eax			# Assign eax <-- k (&k = rbp - 4)
	movl	%eax, (%rdx)			# *rdx <-- *eax; Assign num[i+1] = k 
	addl	$1, -8(%rbp)			# Increment j by 1 (j++)

.L9:
	movl	-8(%rbp), %eax			# *eax <-- *(rbp - 8) = j; Assign j to register "eax"
	cmpl	-28(%rbp), %eax			# Compare values of n and j
	jl	.L13						# Jump to Label L13 if (j < n) i.e. run the outer loop until the condition (j < n) is false

	nop								# Do nothing instruction, go to the next instruction
	nop

	popq	%rbp					# Pop the base pointer
	.cfi_def_cfa 7, 8
	ret								# return
	.cfi_endproc
.LFE1:
	.size	inst_sort, .-inst_sort	# Indicates the distance from the start of inst_sort

# BINARY SEARCH (bsearch)
	.globl	bsearch					# bsearch is a global name
	.type	bsearch, @function		# bsearch is a function
bsearch:							# execution of bsearch function starts here
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp					# Push the base pointer onto the stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp				# set the new stack pointer "rsp"
	.cfi_def_cfa_register 6

	movq	%rdi, -24(%rbp)			# *(rbp - 24) <-- *rdi; Store the parameter a[]
	movl	%esi, -28(%rbp)			# *(rbp - 28) <-- *esi; Store the parameter n
	movl	%edx, -32(%rbp)			# *(rbp - 32) <-- *edx; Store the parameter item
	movl	$0, -8(%rbp)			# *(rbp - 8) <-- 1; Assign bottom = 0
	movl	-28(%rbp), %eax			# *eax <-- *(rbp - 28); Register eax contains vaue of n
	subl	$1, %eax				# *eax <-- n - 1; Decrement value of n by 1
	movl	%eax, -12(%rbp)			# *(rbp - 12) <-- *eax; Assign top = n - 1

.L18:
	movl	-8(%rbp), %edx			# *edx <-- *(rbp - 8); Store bottom in register edx
	movl	-12(%rbp), %eax			# *eax <-- *(rbp - 12); Store top in register eax
	addl	%edx, %eax				# *eax <-- (bottom + top)
	movl	%eax, %edx				# *edx <-- *eax; Store (bottom + top) in register "edx"

	shrl	$31, %edx				# *edx <-- ((*edx) >> 31); Value of register edx is right-shfited by 31 bits (Since edx is 32-bit, the sign-bit is read)
	addl	%edx, %eax				# *eax <-- *eax + *edx; Add 1 to eax if edx is negative, else add 0

	sarl	%eax					# *eax <-- (*eax) >> 1; Perform (bottom + top) / 2 and store it in eax
	movl	%eax, -4(%rbp)			# *(rbp - 4) <-- *eax; Assign mid = (bottom + top) / 2
	movl	-4(%rbp), %eax			# Store value of mid in register eax
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (4 * mid)
	movq	-24(%rbp), %rax			# *rax <-- &a[0]; Store the address of the array a[]
	addq	%rdx, %rax				# *rax <-- a + (4 * mid) = &a[mid]
	movl	(%rax), %eax			# *eax <-- a[mid]; Store the value at a[mid] in register "eax"
	cmpl	%eax, -32(%rbp)			# Compare the values- item and a[mid]
	jge	.L15						# Jump to label L15 only if item >= a[mid]

	movl	-4(%rbp), %eax			# *eax <-- mid; Store value of mid in register "eax"
	subl	$1, %eax				# *eax <-- mid - 1; Decrement value in the register "eax" by 1 
	movl	%eax, -12(%rbp)			# *(rbp - 12) <-- mid - 1; Reassign top to (mid - 1)
	jmp	.L16						# Jump to Label L16 (continue the while loop)

.L15:
	movl	-4(%rbp), %eax			# *eax <-- *(rbp - 4); Store value of mid in the register "eax"
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (4 * mid)
	movq	-24(%rbp), %rax			# *rax <-- &a[0]; Store the address of the array a[]
	addq	%rdx, %rax				# *rax <-- a + (4 * mid) = &a[mid]; 
	movl	(%rax), %eax			# *eax <-- a[mid]; Store the value at a[mid] in eax
	cmpl	%eax, -32(%rbp)			# Compare the values- a[mid] and item
	jle	.L16						# Jump to Label L16 only if item <= a[mid]

	movl	-4(%rbp), %eax			# *eax <-- mid
	addl	$1, %eax				# *eax <-- mid + 1; Increment value in register eax by 1
	movl	%eax, -8(%rbp)			# *(rbp - 8) <-- mid + 1; Reassign bottom to (mid + 1)

.L16:
	movl	-4(%rbp), %eax			# *eax <-- mid
	cltq							# sign-extend eax to rax (32-bit to 64-bit)
	leaq	0(,%rax,4), %rdx		# *rdx <-- (4 * mid)
	movq	-24(%rbp), %rax			# *rax <-- &a[0]
	addq	%rdx, %rax				# *rax <-- a + (4 * mid) = &a[mid]
	movl	(%rax), %eax			# *eax <-- a[mid]; Store a[mid] in register "eax"
	cmpl	%eax, -32(%rbp)			# Compare the values- a[mid] and item
	je	.L17						# Jump to Label L17 if item = a[mid]

	movl	-8(%rbp), %eax			# *eax <-- bottom
	cmpl	-12(%rbp), %eax			# Compare the values- bottom and top
	jle	.L18						# Jump to Label L18 only if bottom <= top

.L17:	
	movl	-4(%rbp), %eax			# *eax <-- mid
	popq	%rbp					# Pop the base pointer 
	.cfi_def_cfa 7, 8
	ret								# return the value in register eax
	.cfi_endproc

.LFE2:	
	.size	bsearch, .-bsearch		# Indicates the distance from the start of bsearch
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
