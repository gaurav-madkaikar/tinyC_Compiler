a.out: main.o libass2_19CS30018.a
	gcc main.o -L. -lass2_19CS30018

main.o: main.c myl.h
	gcc -c main.c

libass2_19CS30018.a: ass2_19CS30018.o
	ar -rcs libass2_19CS30018.a ass2_19CS30018.o

ass2_19CS30018.o: ass2_19CS30018.c myl.h
	gcc -c ass2_19CS30018.c

clean:
	rm a.out main.o libass2_19CS30018.a ass2_19CS30018.o