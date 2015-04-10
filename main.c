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

//Alias stuff
#define MAX_NO_ALIASES 10
#define NOT_ENOUGH_SPACE_ERROR -10
#define NO_ALIAS_FOUND_ERROR -11
#define OK -1
int number_of_aliases;

typedef struct alias alias;

struct alias {
	char *a_name;
	char *a_data;
};

alias array_of_aliases[MAX_NO_ALIASES];



void shellInit(){
	//iniitalize shell duhhh
	printf( "\n\t********** Shell Project Initalized **********\n\n\t********* Country Accent Initialized *********\n" );
	//make a linked list to store
	makeList();
}


void printenv() {
	int i = 0;
	//while there are environments to print, print them
	while (environ[i]) {
		printf("\n\t%s\n", environ[i++]);
	}
}

int setalias(char *name, char *value) {
	//initialize a temporary alias to later set
	alias temp_alias;
	//set the values of said alias
	temp_alias.a_name = name;
	temp_alias.a_data = value;

	//we need an index so we can travese through the alias array
	int index = -1;

	//initalize this i here so we can access it outside of the loop below
	int i = 0;

		//compare the strings in the aliases array to the one passed in
		if(strcmp(name, array_of_aliases[i].a_name) == 0) {
			//Hey! this variable exists!
			index = i;
			break;
		}
	}

	
	if(index != -1) {
		//if the variable already exists, change the value
		array_of_aliases[i] = temp_alias;
		return OK;
	} else {
		//If you havent reached your max alloted aliases, you can create a new one. 
		if(number_of_aliases < MAX_NO_ALIASES) {
			array_of_aliases[i] = temp_alias;
			number_of_aliases++;
			return OK;
		} else return -10;
	}

}

void print_all_aliases(void) {
	int i = 0;
	for(i = 0; i < number_of_aliases; i++) {
		printf("\t\t%s : %s\n", array_of_aliases[i].a_name, array_of_aliases[i].a_data);
	}
}

int removealias(char *name) {
	int index = -1;
	int i = 0;
	
	for(i = 0; i < number_of_aliases; i++) {
		if(strcmp(array_of_aliases[i].a_name, name) == 0) {
			//*If there is a match, move all entries down
			for(index = i; index < number_of_aliases; index++) {
				array_of_aliases[index] = array_of_aliases[index + 1];
			}
			number_of_aliases--;
			return OK;
		}
	}
	return NO_ALIAS_FOUND_ERROR;
	//*Find the alias

}

void do_it() {
	switch ( command ){
		case 1:
			setenv(variable,word, 1);
			printf( "\tSETENV variable = %s, word = %s \n", variable, word);
			break;
		case 2:
			printenv();
			break;
		case 3: 
			unsetenv(variable);
			break;
		case 4:
			printf( "\tTime to graduate, I'm OUT OF HERE! \n\nPRETTY PLEASE TAKE IT EASY ON US!\n\n" );
			exit(0);
			break;
		case 5:
			setalias(variable, word);
			printf("\tRootin tootin! You set an alias: ");
			printf(variable);
			printf(" = ");
			printf(word);
			printf("!!!\n");
			break;
		case 6:
			printf("\tWell shucks, 'eres a lista all them aliases fer ya!\n");
			print_all_aliases();
			break;
		case 7:
			printf("\tYall wanna get rid of that there alias? I gotcher!\n");
			removealias(variable);
			break;
	};
	printf("\n\n");
	command = 0;
}

int getCommand() {

	if( yyparse() ){
		printf("\t\t yes returned 0 \n");
		return(0);
	} else {
		// printf("\t\t okay \n");
		return(1);
	}
	printf("\t\tafter if statements\n");
}

void processCommand() {
	// printf("\tprocessCommand()\n");
	if( command ){
		do_it();
	} else {
		// execute_it();
	}
}
 
int main( int argc, char* argv[], char **envp ){

	shellInit();
	while( 1 ){
		// printf("\tmain while loop entered\n");
		switch( getCommand() ){
			case 1:
				processCommand();
		};
	}
}