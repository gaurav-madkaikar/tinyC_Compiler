a.out: lex.yy.o ass5_19CS30018_19_parser.tab.o ass5_19CS30018_19_translator.o
	g++ lex.yy.o ass5_19CS30018_19_parser.tab.o ass5_19CS30018_19_translator.o -lfl

ass5_19CS30018_19_translator.o: ass5_19CS30018_19_translator.cpp ass5_19CS30018_19_translator.h
	g++ -c ass5_19CS30018_19_translator.h
	g++ -c ass5_19CS30018_19_translator.cpp

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass5_19CS30018_19_parser.tab.o: ass5_19CS30018_19_parser.tab.c
	g++ -c ass5_19CS30018_19_parser.tab.c

lex.yy.c: ass5_19CS30018_19_lexer.l ass5_19CS30018_19_parser.tab.h ass5_19CS30018_19_translator.h
	flex ass5_19CS30018_19_lexer.l

ass5_19CS30018_19_parser.tab.h: ass5_19CS30018_19_parser.y
	bison -dtv ass5_19CS30018_19_parser.y -W
	
clean:
	rm -f lex.yy.c ass5_19CS30018_19_parser.tab.c ass5_19CS30018_19_parser.tab.h lex.yy.o ass5_19CS30018_19_parser.tab.o ass5_19CS30018_19_translator.o ass5_19CS30018_19_parser.output a.out ass5_19CS30018_19_translator.h.gch && clear

run: a.out
	mkdir -p Test\ Outputs
	./a.out < TestFiles/test1.c > Test\ Outputs/quads1.txt
	./a.out < TestFiles/test2.c > Test\ Outputs/quads2.txt
	./a.out < TestFiles/test3.c > Test\ Outputs/quads3.txt
	./a.out < TestFiles/test4.c > Test\ Outputs/quads4.txt
	./a.out < TestFiles/test5.c > Test\ Outputs/quads5.txt