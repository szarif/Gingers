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
[0-9a-zA-Z/:.~\-?*]+  {yylval.str = strdup(yytext); 
                      return WORD; }
\".*\"                {yylval.str = strdup(yytext); 
                      return EXPRESSION; }
\n 			return -1;
%%


// [0-9a-zA-Z/:.~\-?*]+	{ yylval.str = strdup(yytext); return VARIABLE; }