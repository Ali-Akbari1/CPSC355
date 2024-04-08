myprog: a5a.asm a5aMain.c
	m4 a5a.asm > a5a.s
	as a5a.s -o a5a.o
	gcc -c a5aMain.c
	gcc a5a.o a5aMain.o -o myprog

