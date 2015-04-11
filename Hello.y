%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/file.h> 
#include <dirent.h>
#include "linkedList.h"

// #define VARIABLEINDEX 0
// #define WORDINDEX 1

int command = -1;
const char* commandsArray[50][2];

char* expression;

char* variable;
char* word;
char* aliasCommand;

void yyerror(const char *str){
	fprintf(stderr, "Psh, cmon.... error: %s\n", str);
	//could be an error but could also be an alias

}

int yywrap(){
	return 1;
}




%}

%union {
	char* str;
	int num;
}
%token ALIAS BYE CD HELLO LS NUMBER PRINTENV SETENV STATE UNALIAS UNSETENV QUOTE  
%token <str> WORD
%token <str> EXPRESSION

%%

commands: /*empty*/
	| commands command;

command:
	alias_case|bye_case|cd_case|hello_case|ls_case|printenv_case|setenv_case|state_number_case|unalias_case|unsetenv_case;

	//|variable_case;

setenv_case:

	SETENV WORD arguments{
		command = 1;

		variable = $2;
		word = expression;

		// commandsArray[commandIndex][VARIABLEINDEX] = var;
		// commandsArray[commandIndex][WORDINDEX] = word;

		// ++commandIndex;
	};

	| SETENV WORD QUOTE arguments QUOTE{
		command = 1;

		variable = $2;
		word = expression;
	};

arguments:	

	PRINTENV {
		expression = "printenv";
	};

	| CD {
		expression = "cd";
		printf("\t cd\n");
	};

	| LS {
		expression = "ls";
	};

	| BYE {
		expression = "bye";
	};

	| WORD {
		//maybe word maybe alias
		// if (aliasCommand == NULL) {
		// 	aliasCommand = $1;
		// 	command == 8;
		// } else {
		// 	printf("\tword\n");
		// }
			//aliasCommand = $1;
			expression = $1;

			printf("\t Word\n");
		
	};

	| arguments WORD {
		printf("\t dfdd\n");
		const char* curr = $2;
		strcat(expression, " ");
		strcat(expression, curr);
	};

alias_case:
	ALIAS WORD PRINTENV{
		command = 5;
		variable = $2;
		word = "printenv";
	};
	| ALIAS WORD LS{
		command = 5;
		variable = $2;
		word = "ls";
	};

	| ALIAS{
		command = 6;
		printf("\tAlias has been called \n");
	};

	| ALIAS WORD QUOTE arguments QUOTE{

		command = 5;
		variable = $2;
		word = expression;
	};

bye_case:
	BYE{
		command = 4;
		printf("\tToodles darlin \n");
	};

cd_case:
	CD{
		// chdir(getenv("HOME"));
		// printf("\tWelcome home darlin! \n");
	};
	| CD WORD {
		// printf("ddsds\n");
		// chdir($2);
		// printf("\tCD has been called and you have been redirected to the specified directory\n");
	};

hello_case:
	HELLO{	
		printf("\tHowdy yall!! \n");
	};

	| WORD{
		//maybe word maybe alias
		// if (aliasCommand == NULL) {
		// 	aliasCommand = $1;
		// 	command == 8;
		// } else {
		// 	printf("\tword\n");
		// }
			//aliasCommand = $1;
			
			aliasCommand = $1;
			printf("\t hi Word %s\n", aliasCommand);
			command = 8;
		
	};

ls_case:
	LS{
		printf("\tI reckon yall wanna list of yall directory \n");
		DIR *directory;
		struct dirent *dir;
		directory = opendir(".");
		if(directory) {
			while ((dir = readdir(directory)) != NULL) {
				printf("%s\n", dir->d_name);
			}
			closedir(directory);
		}

	};	
	| LS WORD {

			DIR *d;
			struct dirent *dir;
			d = opendir(".");
			int works;
			const char* strIn = $2;
			int len = strlen(strIn);

			char* strOut;
			if(d) {
				while ((dir = readdir(d)) != NULL) {
					works = 1;
					strOut = dir->d_name;
					int i;
					for (i = 0; i < len; i++) {
						if (strIn[i] != strOut[i]) {
							works = 0;
							break;
						}
					}
					if (works == 1)
						printf("%s\n", dir->d_name);
				}
				closedir(d);
			}
	};

printenv_case:
	PRINTENV{
		command = 2;
		printf("\tPrintenv has been called ");
	};






state_number_case:
	STATE NUMBER{
		printf("\tA state with number received \n");
	};

unalias_case:
	UNALIAS WORD{
		command = 7;
		variable = $2;
		printf("\tUnalias has been called \n");
	};

unsetenv_case:
	UNSETENV WORD{
		command = 3;
		variable = $2;
		// commandsArray[0][VARIABLEINDEX] = $2;
		// printf("\t Unsetenv has been called \n");
	};


// default_case:
// 	ALIASCOMMAND {
// 		if(aliasCommand == NULL) {
// 			aliasCommand = $1;
// 		} 

// 		command = 8;

// 	};

%%