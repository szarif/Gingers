run: hello
	./shell.exe

hello: lex.yy.c y.tab.c main.c
	gcc lex.yy.c y.tab.c main.c linkedList.c -o shell.exe

y.tab.c: hello.y
	bison -dy hello.y

lex.yy.c: hello.lex
	flex hello.lex

linkedList.c: linkedList.c
	gcc	linkedList.c

main.c: main.c
	gcc main.c

clean:
	rm shell.exe 