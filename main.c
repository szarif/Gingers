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
extern const char* variable;
extern const char* word;
extern char* aliasCommand;
extern char* expression;

//Alias stuff
#define MAX_NO_ALIASES 10
#define NOT_ENOUGH_SPACE_ERROR -10
#define NO_ALIAS_FOUND_ERROR -11
#define OK -1
int number_of_aliases;

typedef struct alias alias;

struct alias {
	char a_name[50];
	char a_data[50];
};

alias array_of_aliases[MAX_NO_ALIASES];



void shellInit(){
	//iniitalize shell duhhh
	printf( "\n\t********** Shell Project Initalized **********\n\n\t********* Country Accent Initialized *********\n" );
	//make a linked list to store
	//aliasCommand = NULL;
	aliasCommand = " ";
	number_of_aliases = 0;
}


void printenv() {
	int i = 0;
	//while there are environments to print, print them
	while (environ[i]) {
		printf("\n\t%s\n", environ[i++]);
	}
}

int setalias(char* n, char* v) {
	//initialize a temporary alias to later set
	alias temp_alias;
	//set the values of said alias
	strcpy(temp_alias.a_name, n);
	strcpy(temp_alias.a_data, v);


	//we need an index so we can travese through the alias array
	int index = -1;

	//initalize this i here so we can access it outside of the loop below
	int i = 0;

		//compare the strings in the aliases array to the one passed in

	for(i = 0; i < number_of_aliases; i++) {
		printf("name %s word %s\n",array_of_aliases[i].a_name,array_of_aliases[i].a_data);
		if(strcmp(n, array_of_aliases[i].a_name) == 0) {
			//Hey! this variable exists!
			printf("shouldnt\n");
			index = i;
		}
	}


	if(index != -1) {
		//if the variable already exists, change the value
		array_of_aliases[index] = temp_alias;
		return 1;
	} else {
		//If you havent reached your max alloted aliases, you can create a new one. 
		printf("should\n");
		if(number_of_aliases < MAX_NO_ALIASES) {
		printf("should1 %d\n",i);

			array_of_aliases[i] = temp_alias;
			number_of_aliases++;
			return OK;
		} else return -10;
	}

	
}

int isAlias(char* word) {
	//Returns the index of the alias if the entered string is an alias. Otherwise returns -1

	int indexOf = -1;

	int i = 0;
	//Find index of variable, if it exists
	for(i = 0; i < number_of_aliases; i++) {

		if(strcmp(word, array_of_aliases[i].a_name) == 0) {
			//Variable already exists, set value
			indexOf = i;
			break;
		}
	}

	return indexOf;
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

void run() {

	//if (aliasCommand == NULL) {

				switch ( command ){
				case 1:
					//setenv
					setenv(variable,word, 1);
					printf( "\tSETENV variable = %s, word = %s \n", variable, word);
					break;
				case 2:
					//print env
					printenv();
					break;
				case 3: 
					//unset env
					unsetenv(variable);
					break;
				case 4:
					//bye
					printf( "\tTime to graduate, I'm OUT OF HERE! \n\nPRETTY PLEASE TAKE IT EASY ON US!\n\n" );
					exit(0);
					break;
				case 5:
					//set alias
					setalias(variable, word);
					printf("\tRootin tootin! You set an alias: ");
					printf(variable);
					printf(" = ");
					printf(word);
					printf("!!!\n");
					break;
				case 6:
					//print alias
					printf("\tWell shucks, 'eres a lista all them aliases fer ya!\n");
					print_all_aliases();
					break;
				case 7:
					//remove alias
					printf("\tYall wanna get rid of that there alias? I gotcher!\n");
					removealias(variable);
					break;
				case 8:
					//command not found could be an alias or an error
					command = 0;
					printf("potential alias\n");
					if (aliasCommand != " ") {
						printf("alias\n");
						int index = isAlias(aliasCommand);
						if (index != -1) {

							parseString(array_of_aliases[index].a_data);
							run();
						} else {
							printf("Not an alias - maybe an error? \n");
						}
					}
				
					
					break;
			};
			printf("\n\n");
			command = 0;

	//} else {

	//}
	
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
		run();
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