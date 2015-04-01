%{ #include <stdio.h>
#include <string.h>
#include <methods.h>

void yyerror(const char *str){fprintf(stderr, "error: %s\n",str);}

int yywrap(){return 1;}

main(){



		shell_init();
		While(1){
			printPrompt();
			Switch(CMD = getCommand()){
				Case: BYE 		exit();
				Case: ERRORS 	recover_from_errors();
				Case: OK		processCommand();

			}
				yyparse();
		}
	
}

%}
%token NUMBER HELLO BYE SETENV STATE
%%

commands: /* empty */
	| commands command;

command:
	hello_case|bye_case|state_number_case|setenv_case;
hello_case:
	HELLO 	{printf("\t Yo nigga !! \n");};
bye_case:
	BYE 	{printf("\t Adios muchahos !! \n");};
setenv_case:
	SETENV 	{printf("\t this is the code to set a variable \n");};
state_number_case:
	STATE NUMBER {printf("\t state with number received \n");};
