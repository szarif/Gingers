#ifndef linkedList_h
#define linkedList_h

typedef struct node
{
    char* variable;
    char* word;
    struct node *next;
} node;


node* makeList();
char* getWord(char* variable);
void insertNode(char*  variable, char*  word);
void remVariable(char*  variable);

#endif