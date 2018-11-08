asmGenerate: comp
	./comp 1 > ass6_16CS30030_quads1.out
	./comp 2 > ass6_16CS30030_quads2.out
	./comp 3 > ass6_16CS30030_quads3.out
	./comp 4 > ass6_16CS30030_quads4.out
	./comp 5 > ass6_16CS30030_quads5.out
	./comp 6 > ass6_16CS30030_quads6.out
	./comp 7 > ass6_16CS30030_quads7.out
	./comp 8 > ass6_16CS30030_quads8.out
	./comp 9 > ass6_16CS30030_quads9.out

comp: lex.yy.o ass6_16CS30030.tab.o ass6_16CS30030_translator.o ass6_16CS30030_target_translator.o
	g++ lex.yy.o ass6_16CS30030.tab.o ass6_16CS30030_translator.o \
	ass6_16CS30030_target_translator.o -lfl -o comp

ass6_16CS30030_target_translator.o: ass6_16CS30030_target_translator.cxx
	g++ -c ass6_16CS30030_target_translator.cxx

ass6_16CS30030_translator.o: ass6_16CS30030_translator.cxx ass6_16CS30030_translator.h
	g++ -c ass6_16CS30030_translator.h
	g++ -c ass6_16CS30030_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass6_16CS30030.tab.o: ass6_16CS30030.tab.c
	g++ -c ass6_16CS30030.tab.c

lex.yy.c: ass6_16CS30030.l ass6_16CS30030.tab.h ass6_16CS30030_translator.h
	flex ass6_16CS30030.l

ass6_16CS30030.tab.c: ass6_16CS30030.y
	bison -dtv ass6_16CS30030.y

ass6_16CS30030.tab.h: ass6_16CS30030.y
	bison -dtv ass6_16CS30030.y
	
cleanall:
	rm lex.yy.c ass6_16CS30030.tab.c ass6_16CS30030.tab.h lex.yy.o \
	ass6_16CS30030.tab.o ass6_16CS30030_translator.o test1 test2 test3 \
	test4 test5 ass6_16CS30030.output comp ass6_16CS30030_target_translator.o \
	libass2_16CS30030.a ass6_16CS30030_1.o ass2_16CS30030.o ass6_16CS30030_2.o \
	ass6_16CS30030_3.o ass6_16CS30030_4.o ass6_16CS30030_5.o ass6_16CS30030_translator.h.gch \
	ass6_16CS30030_6.o test6 ass6_16CS30030_7.o test7 ass6_16CS30030_8.o test8 ass6_16CS30030_9.o test9

clean:
	rm lex.yy.c ass6_16CS30030.tab.c ass6_16CS30030.tab.h lex.yy.o \
	ass6_16CS30030.tab.o ass6_16CS30030_translator.o ass6_16CS30030_translator.h.gch \
	ass6_16CS30030.output comp ass6_16CS30030_target_translator.o 

#Test files
test1: ass6_16CS30030_1.o libass2_16CS30030.a
	gcc -g ass6_16CS30030_1.o -o test1 -L. -lass2_16CS30030
ass6_16CS30030_1.o: myl.h
	gcc -c ass6_16CS30030_1.s
clean1:
	rm ass6_16CS30030_1.o libass2_16CS30030.a test1

test2: ass6_16CS30030_2.o libass2_16CS30030.a
	gcc ass6_16CS30030_2.o -o test2 -L. -lass2_16CS30030
ass6_16CS30030_2.o: myl.h
	gcc -Wall -c ass6_16CS30030_2.s
clean2:
	rm ass6_16CS30030_2.o libass2_16CS30030.a test2

test3: ass6_16CS30030_3.o libass2_16CS30030.a
	gcc ass6_16CS30030_3.o -o test3 -L. -lass2_16CS30030
ass6_16CS30030_3.o: myl.h
	gcc -Wall -c ass6_16CS30030_3.s
clean3:
	rm ass6_16CS30030_3.o libass2_16CS30030.a test3

test4: ass6_16CS30030_4.o libass2_16CS30030.a
	gcc ass6_16CS30030_4.o -o test4 -L. -lass2_16CS30030
ass6_16CS30030_4.o: myl.h
	gcc -Wall -c ass6_16CS30030_4.s
clean4:
	rm ass6_16CS30030_4.o libass2_16CS30030.a test4

test5: ass6_16CS30030_5.o libass2_16CS30030.a 
	gcc ass6_16CS30030_5.o -o test5 -L. -lass2_16CS30030
ass6_16CS30030_5.o: myl.h
	gcc -Wall -c ass6_16CS30030_5.s
clean5:
	rm ass6_16CS30030_5.o libass2_16CS30030.a test5

test6: ass6_16CS30030_6.o libass2_16CS30030.a myl.h
	gcc -Wall ass6_16CS30030_6.o -o test6 -L. -lass2_16CS30030
ass6_16CS30030_6.o: myl.h
	gcc -Wall -c ass6_16CS30030_6.s
clean6:
	rm ass6_16CS30030_6.o libass2_16CS30030.a test6

test7: ass6_16CS30030_7.o libass2_16CS30030.a
	gcc ass6_16CS30030_7.o -o test7 -L. -lass2_16CS30030
ass6_16CS30030_7.o: myl.h
	gcc -Wall -c ass6_16CS30030_7.s
clean7:
	rm ass6_16CS30030_7.o libass2_16CS30030.a test7

test8: ass6_16CS30030_8.o libass2_16CS30030.a
	gcc ass6_16CS30030_8.o -o test8 -L. -lass2_16CS30030
ass6_16CS30030_8.o: myl.h
	gcc -Wall -c ass6_16CS30030_8.s
clean8:
	rm ass6_16CS30030_8.o libass2_16CS30030.a test8

test9: ass6_16CS30030_9.o libass2_16CS30030.a
	gcc ass6_16CS30030_9.o -o test9 -L. -lass2_16CS30030
ass6_16CS30030_9.o: myl.h
	gcc -Wall -c ass6_16CS30030_9.s
clean9:
	rm ass6_16CS30030_9.o libass2_16CS30030.a test9

libass2_16CS30030.a: ass2_16CS30030.o
	ar -rcs libass2_16CS30030.a ass2_16CS30030.o

ass2_16CS30030.o: ass2_16CS30030.c myl.h
	gcc -Wall -c ass2_16CS30030.c


