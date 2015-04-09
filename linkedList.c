#include "linkedList.h"
#include <stdio.h>



struct node *head;

node* makeList() {
  head = NULL;
  return head;
}

char* getWord(char* variable){
  if (head) {
    struct node *temp,*prevNode;
    temp = head;

    while (temp) {
      if (temp->variable == variable) {

        if (temp == head) {
          return temp->word;
        } else {
          prevNode->next = temp->next;
          free(temp);
          break;
        }

      } else {
        prevNode = temp;
        temp = temp->next;
      }
    }
    
  }

  return "not found";
}

void insertNode(char*  variable, char*  word) {
  struct node *temp;
  temp = (struct node *)malloc(sizeof(struct node));

  temp->word = word;
  temp->variable = variable;

  if (head) {
      head = temp;
      head->next =  NULL;
  } else {
      temp->next = head;
      head = temp;
  }
}

void remVariable(char*  variable) {
  
  if (head) {
    struct node *temp,*prevNode;
    temp = head;

    while (temp) {
      if (temp->variable == variable) {

        if (temp == head) {
          head = temp->next;
          free(temp);
          break;
        } else {
          prevNode->next = temp->next;
          free(temp);
          break;
        }

      } else {
        prevNode = temp;
        temp = temp->next;
      }
    }
    
  }
}
