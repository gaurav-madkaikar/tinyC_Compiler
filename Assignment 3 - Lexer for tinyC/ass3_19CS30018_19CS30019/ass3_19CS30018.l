
/* Compilers lab Assignment 3 */
/* Group No: 24 */
/* Group Members: Gaurav Madkaikar, Girish Kumar */


%{
    #include <stdio.h>

    #define KEYWORD                 1
	#define IDENTIFIER 			    2
	#define INT_CONSTANT 	        3
	#define FLOAT_CONSTANT 	        4
	#define CHAR_CONSTANT 	        5
	#define STRING_LITERAL 		    6
    #define PUNCTUATORS 		    7
    #define MULTI_COMMENT_START     8
    #define MULTI_COMMENT           9
    #define MULTI_COMMENT_END       10
    #define SINGLE_COMMENT_START    11
    #define SINGLE_COMMENT          12
    #define SINGLE_COMMENT_END      13 
%}

%x  COMMENT
%x  SINGLE_LINE_COMMENT

/* LEXICAL ELEMENTS */

/* KEYWORDS */
KEYWORD                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

/* IDENTIFIER */
IDENTIFIER_NONDIGIT         [_a-zA-Z]
DIGIT                       [0-9]
IDENTIFIER                  {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/* CONSTANTS */
SIGN 						"+"|"-"

NONZERO_DIGIT				[1-9]
NONZERO_INT_CONSTANT	    {NONZERO_DIGIT}({DIGIT})*
INT_CONSTANT                "0"|[-]?{NONZERO_INT_CONSTANT}

FRACTIONAL_CONSTANT			({INT_CONSTANT}?"."{DIGIT_SEQUENCE})
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
DIGIT_SEQUENCE				({DIGIT})+
FLOAT_CONSTANT              ({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({INT_CONSTANT}{EXPONENT_PART})

ENUMERATION_CONSTANT		{IDENTIFIER}

ESCAPE_SEQUENCE             "\\\'"|"\\\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR                      [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE             ({C_CHAR})+
CHAR_CONSTANT               \'({C_CHAR_SEQUENCE})\'  

/* STRING LITERALS */
S_CHAR                      [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE             {S_CHAR}+
STRING_LITERAL              \"({S_CHAR_SEQUENCE})?\"

/* PUNCTUATORS */
PUNCTUATORS 				"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

/* WHITESPACES */
WS                          "\n"|" "|"\t"

%%

{KEYWORD}                   { return KEYWORD;                                                   }
{IDENTIFIER}                { return IDENTIFIER;                                                }
{INT_CONSTANT}              { return INT_CONSTANT;                                              }
{FLOAT_CONSTANT}            { return FLOAT_CONSTANT;                                            }
{CHAR_CONSTANT}             { return CHAR_CONSTANT;                                             }
{STRING_LITERAL}            { return STRING_LITERAL;                                            }
{PUNCTUATORS}               { return PUNCTUATORS;                                               }
{WS}	                    {                      /* Skip the whitespaces */                   }                                                       

"/*"                        { BEGIN(COMMENT); return MULTI_COMMENT_START;                       }
<COMMENT>"*/"               { BEGIN(INITIAL); return MULTI_COMMENT_END;                         }
<COMMENT>.                  { return MULTI_COMMENT;                                             }
<COMMENT>"\n"               { return MULTI_COMMENT;                                             }

"//"                        { BEGIN(SINGLE_LINE_COMMENT); return SINGLE_COMMENT_START;          }
<SINGLE_LINE_COMMENT>"\n"   { BEGIN(INITIAL); return SINGLE_COMMENT_END;                        }
<SINGLE_LINE_COMMENT>.      { return SINGLE_COMMENT;                                            }    

%%