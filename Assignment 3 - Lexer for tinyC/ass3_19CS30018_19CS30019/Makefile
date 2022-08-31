ass3_19CS30018_test.txt: a.out ass3_19CS30018_test.c
						./a.out < ass3_19CS30018_test.c > ass3_19CS30018_test.txt

a.out: 					lex.yy.c
	   					cc lex.yy.c -lfl

lex.yy.c: 				ass3_19CS30018.l
	      				flex ass3_19CS30018.l ass3_19CS30018.c

clean:
						rm a.out lex.yy.c