ass4_19CS30018.txt: a.out ass4_19CS30018_test.c
	./a.out < ass4_19CS30018_test.c > ass4_19CS30018_op.txt

a.out: lex.yy.o ass4_19CS30018.o y.tab.o
	gcc lex.yy.o ass4_19CS30018.o y.tab.o -lfl 

lex.yy.c: ass4_19CS30018.l y.tab.h
	flex ass4_19CS30018.l

y.tab.c: ass4_19CS30018.y 
	bison -dty ass4_19CS30018.y --report=solved

ass4_19CS30018.o: ass4_19CS30018.c 
	gcc -c ass4_19CS30018.c 

y.tab.h: ass4_19CS30018.y
	bison -dty ass4_19CS30018.y --report=solved

lex.yy.o: lex.yy.c 
	gcc -c lex.yy.c 

y.tab.o: y.tab.c 
	gcc -c y.tab.c

clean:
	rm ./a.out lex.yy.o lex.yy.c y.output ass4_19CS30018.o y.tab.h y.tab.c y.tab.o