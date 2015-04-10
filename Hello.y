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

char* variable;
char* word;

void yyerror(const char *str){
	fprintf(stderr, "Psh, cmon.... error: %s\n", str);

}

int yywrap(){
	return 1;
}




%}

%union {
	char* str;
	int num;
}
%token ALIAS BYE CD HELLO LS NUMBER PRINTENV SETENV STATE UNALIAS UNSETENV 
%token <str> VARIABLE
%token <str> WORD
%token <str> STRING
%%

commands: /*empty*/
	| commands command;

command:
	alias_case|bye_case|cd_case|hello_case|ls_case|printenv_case|setenv_case|arguments|state_number_case|unalias_case|unsetenv_case;

	//|variable_case;


alias_case:
	ALIAS WORD WORD{
		command = 5;
		variable = $2;
		word = $3;
	};
	| ALIAS{
		command = 6;
		printf("\tAlias has been called \n");
	};

bye_case:
	BYE{
		command = 4;
		printf("\tToodles darlin \n");
	};

cd_case:
	CD{
		chdir(getenv("HOME"));
		printf("\tWelcome home darlin! \n");
	};
	| CD WORD {
		chdir($2);
		printf("\tCD has been called and you have been redirected to the specified directory\n");
	};

hello_case:
	HELLO{	
		printf("\tHowdy yall!! \n");
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

setenv_case:

	SETENV WORD WORD{
		command = 1;

		variable = $2;
		word = $3;

		// commandsArray[commandIndex][VARIABLEINDEX] = var;
		// commandsArray[commandIndex][WORDINDEX] = word;

		// ++commandIndex;
	};

arguments:	

	WORD
	{
		printf("\tword\n");
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

variable_case:
	VARIABLE{
		printf("\tVariable has been called \n");
	};

%%