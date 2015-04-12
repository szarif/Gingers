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
// const char* commandsArray[50][2];
char expression[100] = "kninininininininininininin";

const char* variable;
const char* word;
const char* aliasCommand;

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
%token ALIAS BYE HELLO NUMBER QUESTION STAR PRINTENV SETENV STATE UNALIAS UNSETENV QUOTE DOLLAR OCURL ECURL 
%token <str> WORD
%token <str> CD
%token <str> LS

%%

commands: /*empty*/
	| commands command;

command:
	alias_case|envExpressionCase|bye_case|cd_case|hello_case|ls_case|printenv_case|setenv_case|state_number_case|unalias_case|unsetenv_case;

	//|variable_case;

envExpressionCase:
	DOLLAR OCURL WORD ECURL {

		printf( " %s \n", getenv($3));
	};

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
		strcpy(expression,"printenv");
	};

	| CD {
		strcpy(expression,"cd");
		printf("\t yo %s\n", expression);
	};

	| LS {
		strcpy(expression,"ls");
	};

	| BYE {
		strcpy(expression,"bye");
	};

	| DOLLAR OCURL WORD ECURL {

		strcpy(expression,getenv($3));
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
			strcpy(expression,$1);

			printf("\t Word\n");
		
	};

	| arguments DOLLAR OCURL WORD ECURL {

		printf("yes\n");
		strcat(expression, " ");
		strcat(expression, getenv($4));
	};

	| arguments WORD {
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

		struct dirent *direct;
		
		directory = opendir(".");
		
		if(directory) {

			while ((direct = readdir(directory)) != NULL) {
				printf("%s\n", direct->d_name);
			}
			
			closedir(directory);
	
		}

	};	
	| LS WORD {

			DIR *direct;

			struct dirent *dir;
			
			direct = opendir(".");
			
			int isCorrect;
			
			const char* input = $2;
			
			int len = strlen(input);

			char* output;
			
			if(direct) {
			
				while ((dir = readdir(direct)) != NULL) {

					isCorrect = 1;
					output = dir->d_name;
					int i;
					for (i = 0; i < len; i++) {
						if (input[i] != output[i]) {
							isCorrect = 0;
							break;
						}
					}
			
					if (isCorrect == 1)
						printf("%s\n", dir->d_name);
				}
			
				closedir(direct);
			}

	};

	| LS STAR WORD {
		DIR *d;
			struct dirent *dir;
			d = opendir(".");
			int works;
			char strIn[50];
			strcpy(strIn,$3);
			int len = strlen(strIn);

			char strOut[50];

			if(d) {
				while ((dir = readdir(d)) != NULL) {
					works = 1;
					strcpy(strOut,dir->d_name);
					int outLen = strlen(strOut);
					int i;
					for (i = len; i > 0; i--) {
						char c1 = tolower( strIn[i] );
						char c2 = tolower( strOut[outLen--] );

						if (c1 != c2) {
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
	| LS WORD STAR {
		DIR *d;
			struct dirent *dir;
			d = opendir(".");
			int works;
			char strIn[50];
			strcpy(strIn,$2);
			int len = strlen(strIn);

			char strOut[50];

			if(d) {
				while ((dir = readdir(d)) != NULL) {
					works = 1;
					strcpy(strOut,dir->d_name);
					int outLen = strlen(strOut);
					int i;

					for (i = 0; i < len; i++) {
						char c1 = tolower(strIn[i]);
						char c2 = tolower(strOut[i]);

						if (c1 != c2) {
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
	| LS QUESTION WORD {
	DIR *d;
			struct dirent *dir;
			d = opendir(".");
			int works;
			char strIn[50];
			strcpy(strIn,$3);
			int len = strlen(strIn);

			char strOut[50];

			if(d) {
				while ((dir = readdir(d)) != NULL) {
					works = 1;
					strcpy(strOut,dir->d_name);
					int outLen = strlen(strOut);
					int i;
					for (i = len; i > 0; i--) {
						char c1 = tolower( strIn[i] );
						char c2 = tolower( strOut[outLen--] );

						if (c1 != c2) {
							works = 0;
							break;
						}
					}
					if (works == 1 && outLen == 1)
						printf("%s\n", dir->d_name);
				}
				closedir(d);
			}		
	};
	| LS WORD QUESTION {
		DIR *d;
			struct dirent *dir;
			d = opendir(".");
			int works;
			char strIn[50];
			strcpy(strIn,$2);
			int len = strlen(strIn);

			char strOut[50];

			if(d) {
				while ((dir = readdir(d)) != NULL) {
					works = 1;
					strcpy(strOut,dir->d_name);
					int outLen = strlen(strOut);
					int i;
					if (outLen - len != 1) {
						works = 0;
					}
					for (i = 0; i < len; i++) {
						char c1 = tolower(strIn[i]);
						char c2 = tolower(strOut[i]);

						if (c1 != c2) {
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