tinyC_compiler: y.tab.o lex.yy.o ass6_19CS30018_19CS30019_translator.o ass6_19CS30018_19CS30019_target_translator.o 
	@g++ -g -no-pie ass6_19CS30018_19CS30019_translator.o ass6_19CS30018_19CS30019_target_translator.o lex.yy.o y.tab.o -lfl -o tinyC_compiler
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test1.c > ass6_19CS30018_19CS30019_quad1.out
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test2.c > ass6_19CS30018_19CS30019_quad2.out
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test3.c > ass6_19CS30018_19CS30019_quad3.out
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test4.c > ass6_19CS30018_19CS30019_quad4.out
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test5.c > ass6_19CS30018_19CS30019_quad5.out
	@echo "\nUSE THE COMMAND (make run) TO RUN THE TEST C FILES\n"

lex.yy.c: ass6_19CS30018_19CS30019.l
	@flex ass6_19CS30018_19CS30019.l

y.tab.c: ass6_19CS30018_19CS30019.y
	@yacc -dtv ass6_19CS30018_19CS30019.y

ass6_19CS30018_19CS30019_target_translator.o: ass6_19CS30018_19CS30019_target_translator.cxx
	@g++ -g -c -no-pie ass6_19CS30018_19CS30019_target_translator.cxx

ass6_19CS30018_19CS30019_translator.o: ass6_19CS30018_19CS30019_translator.cxx
	@g++ -g -c -no-pie ass6_19CS30018_19CS30019_translator.cxx

lex.yy.o: lex.yy.c
	@g++ -g -c -no-pie lex.yy.c

y.tab.o:  y.tab.c
	@g++ -g -DYYDEBUG -c -no-pie y.tab.c

libass2_19CS30018_19CS30019.a: ass2_19CS30018_19CS30019.o
	@ar -rcs libass2_19CS30018_19CS30019.a ass2_19CS30018_19CS30019.o

ass2_19CS30018_19CS30019.o: ass2_19CS30018_19CS30019.c myl.h
	@gcc -c -no-pie ass2_19CS30018_19CS30019.c

clean:
	@rm ass6_19CS30018_19CS30019.tab.* ass6_19CS30018_19CS30019.output output.s ass6_19CS30018_19CS30019_test1.s ass6_19CS30018_19CS30019_test2.s ass6_19CS30018_19CS30019_test3.s ass6_19CS30018_19CS30019_test4.s ass6_19CS30018_19CS30019_test5.s runtest1 runtest2 runtest3 runtest4 runtest5 lex.yy.c y.tab.h y.output y.tab.c lex.yy.o y.tab.o ass6_19CS30018_19CS30019_translator.o ass6_19CS30018_19CS30019_target_translator.o ass6_19CS30018_19CS30019_test1.o ass6_19CS30018_19CS30019_test2.o ass6_19CS30018_19CS30019_test3.o ass6_19CS30018_19CS30019_test4.o ass6_19CS30018_19CS30019_test5.o libass2_19CS30018_19CS30019.a ass2_19CS30018_19CS30019.o ass6_19CS30018_19CS30019_quad1.out ass6_19CS30018_19CS30019_quad2.out ass6_19CS30018_19CS30019_quad3.out ass6_19CS30018_19CS30019_quad4.out ass6_19CS30018_19CS30019_quad5.out tinyC_compiler

runtest1: ass6_19CS30018_19CS30019_test1.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie ass6_19CS30018_19CS30019_test1.o -o runtest1 -L. -lass2_19CS30018_19CS30019

ass6_19CS30018_19CS30019_test1.o: ass6_19CS30018_19CS30019_test1.s myl.h
	@gcc -g -c -no-pie ass6_19CS30018_19CS30019_test1.s -o ass6_19CS30018_19CS30019_test1.o

runtest2: ass6_19CS30018_19CS30019_test2.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie ass6_19CS30018_19CS30019_test2.o -o runtest2 -L. -lass2_19CS30018_19CS30019

ass6_19CS30018_19CS30019_test2.o: ass6_19CS30018_19CS30019_test2.s myl.h
	@gcc -g -c -no-pie ass6_19CS30018_19CS30019_test2.s

runtest3: ass6_19CS30018_19CS30019_test3.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie ass6_19CS30018_19CS30019_test3.o -o runtest3 -L. -lass2_19CS30018_19CS30019

ass6_19CS30018_19CS30019_test3.o: ass6_19CS30018_19CS30019_test3.s myl.h
	@gcc -g -no-pie -c ass6_19CS30018_19CS30019_test3.s

runtest4: ass6_19CS30018_19CS30019_test4.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie ass6_19CS30018_19CS30019_test4.o -o runtest4 -L. -lass2_19CS30018_19CS30019

ass6_19CS30018_19CS30019_test4.o: ass6_19CS30018_19CS30019_test4.s myl.h
	@gcc -g -no-pie -c ass6_19CS30018_19CS30019_test4.s

runtest5: ass6_19CS30018_19CS30019_test5.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie ass6_19CS30018_19CS30019_test5.o -o runtest5 -L. -lass2_19CS30018_19CS30019

ass6_19CS30018_19CS30019_test5.o: ass6_19CS30018_19CS30019_test5.s myl.h
	@gcc -g -no-pie -c ass6_19CS30018_19CS30019_test5.s

output: output.o libass2_19CS30018_19CS30019.a
	@gcc -g -no-pie output.o -o output -L. -lass2_19CS30018_19CS30019

output.o: output.s myl.h
	@gcc -g -no-pie -c output.s

run: 
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test1.c > ass6_19CS30018_19CS30019_quad1.out

	@mv output.s ass6_19CS30018_19CS30019_test1.s
	
	@make runtest1

	@./tinyC_compiler < ass6_19CS30018_19CS30019_test2.c > ass6_19CS30018_19CS30019_quad2.out
	
	@mv output.s ass6_19CS30018_19CS30019_test2.s
	
	@make runtest2

	@./tinyC_compiler < ass6_19CS30018_19CS30019_test3.c > ass6_19CS30018_19CS30019_quad3.out

	@mv output.s ass6_19CS30018_19CS30019_test3.s

	@make runtest3
	
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test4.c > ass6_19CS30018_19CS30019_quad4.out

	@mv output.s ass6_19CS30018_19CS30019_test4.s

	@make runtest4
	
	@./tinyC_compiler < ass6_19CS30018_19CS30019_test5.c > ass6_19CS30018_19CS30019_quad5.out

	@mv output.s ass6_19CS30018_19CS30019_test5.s

	@make runtest5

	@echo "\nCOMMANDS TO RUN THE EXECUTABLE FILES:\n"
	@echo "./runtest<i> | where, i is the corresponding test file index"
	@echo "E.g., ./runtest1 runs the executable file corresponding to test1.c"
