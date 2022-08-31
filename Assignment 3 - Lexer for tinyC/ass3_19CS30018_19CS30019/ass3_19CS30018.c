
/* Compilers lab Assignment 3 */
/* Group No: 24 */
/* Group Members: Gaurav Madkaikar, Girish Kumar */

#include <stdio.h>

int main()
{
    /*  INTERACTIVE FLEX SPECIFICATION */
    int token;
    while(token = yylex())
    {
        switch(token) 
        {
            case KEYWORD: 
                printf("< KEYWORD -> %d, %s >\n", token, yytext); 
                break;
            case IDENTIFIER: 
                printf("< IDENTIFIER -> %d, %s >\n", token, yytext); 
                break;
            case STRING_LITERAL: 
                printf("< STRING_LITERAL -> %d, %s >\n", token, yytext); 
                break;
            case INT_CONSTANT: 
                printf("< INTEGER_CONST -> %d, %s >\n", token, yytext); 
                break;
            case FLOAT_CONSTANT: 
                printf("< FLOAT_CONST -> %d, %s >\n", token, yytext); 
                break;
            case CHAR_CONSTANT: 
                printf("< CHARACTER_CONST -> %d, %s >\n", token, yytext); 
                break;
            
            case PUNCTUATORS: 
                printf("< PUNCTUATOR -> %d, \"%s\" >\n", token, yytext); 
                break;

            case MULTI_COMMENT_START: 
                printf("< MULTILINE_COMMENT_STARTS -> %d, %s >\n", token, yytext); 
                break;
            case MULTI_COMMENT_END: 
                printf("< MULTILINE_COMMENT_ENDS -> %d, %s >\n", token, yytext); 
                break;
            case MULTI_COMMENT: 
                printf("%s", yytext); 
                break;

            case SINGLE_COMMENT_START: 
                printf("< SINGLE_LINE_COMMENT_STARTS -> %d, %s >\n", token, yytext); 
                break;
            case SINGLE_COMMENT_END: 
                printf("< SINGLE_LINE_COMMENT_ENDS -> %d >\n", token); 
                break;
            case SINGLE_COMMENT: 
                printf("%s", yytext); 
                break;

            default: 
                break;
        }
    }

    return 0;
}