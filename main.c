#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#include <stdlib.h>
#include <unistd.h>
#include <stddef.h>
#include <limits.h>
#include <dirent.h>
#include "linkedList.h"

// #define VARIABLEINDEX 0
// #define WORDINDEX 1

extern int command;
//extern const char* commandsArray[50][2];
extern char** environ;
extern char* variable;
extern char* word;




void shellInit(){
	printf( "\n\tShell initalized...get FREAKAAAAYYY\n" );
	makeList();
}


void printenv() {
	int i = 0;
	while (environ[i]) {
		printf("%s\n", environ[i++]);
	}
}

void do_it() {
	switch ( command ){
		case 1:
			setenv(variable,word, 1);
			printf( "\t SETENV v =  %s w = %s \n", variable, word);
			break;
		case 2:
			printenv();
			break;
		case 3: 
			unsetenv(variable);
			break;
		case 4:
			printf( "\t Time to graduate, I'm OUT OF HERE! \n" );
			exit(0);
	};
}

int getCommand() {

	if( yyparse() ){
		printf("\t\t yes returned 0 \n");
		return(0);
	} else {
		printf("\t\t okay \n");
		return(1);
	}
	printf("\t\tafter if statements\n");
}

void processCommand() {
	printf("\tprocessCommand()\n");
	if( command ){
		do_it();
	} else {
		// execute_it();
	}
}
 
int main( int argc, char* argv[], char **envp ){

	shellInit();
	while( 1 ){
		printf("\tmain while loop entered\n");
		switch( getCommand() ){
			case 1:
				processCommand();
		};
	}
}