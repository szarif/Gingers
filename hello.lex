%{
	#include <stdio.h>
  #include <string.h>
	#include "y.tab.h"
%}

%%
alias					return ALIAS;
bye 					return BYE;
cd 						return CD;
hello 					return HELLO;
ls 						return LS;
[0-9]+					return NUMBER;
printenv 				return PRINTENV;
setenv 					return SETENV;
on|off					return STATE;
unalias 				return UNALIAS;
unsetenv 				return UNSETENV;
\*              return STAR;
\?              return QUESTION;
\$              return DOLLAR;
\{              return OCURL;
\}              return ECURL;
\"                return QUOTE;  
[0-9:~a-zA-Z/\.]+  {yylval.str = strdup(yytext); 
                      return WORD; }                
\n 			return -1;
%%

void parseString(char* str) {
  printf("cool");
  yy_scan_string(str);
  yyparse();
  yylex_destroy();
}


// [0-9a-zA-Z/:.~\-?*]+	{ yylval.str = strdup(yytext); return VARIABLE; }