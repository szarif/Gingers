------------------------------------------------------
Shell term project by Shai Zarif and Damien Gilliams
------------------------------------------------------

------------------------------------------------------
Working features
------------------------------------------------------
We were successful in implementing the following:
- Shell loop
- Lex and Yacc parsing
- setenv variable word
- printenv
- unsetenv variable
- cd (to home)
- cd~ (to home)
- cd word_directory_name
- alias
- alias name word
- unalias name
- bye

------------------------------------------------------
Instructions
------------------------------------------------------
In order to run the shell.exe executable file:
- put the files listed below in an easy accessable directory
	- hello.lex
	- hello.y
	- lex.yy.c
	- linkedList.h
	- linkedList.c
	- main.c
	- makefile
	- y.tab.c
	- y.tab.h
- open terminal
- navigate to the directory with the above files using cd <directory>. 
- use the command "make" 
- the shell will automatically compile and run
- use any of the working features listed above
- use command "bye" to gracefully exit the shell
