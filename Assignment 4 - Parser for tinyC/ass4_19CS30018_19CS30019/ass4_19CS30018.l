/* Compilers lab Assignment 4 - Parser for tinyC */
/* Group No: 24 */
/* Group Members: Gaurav Madkaikar, Girish Kumar */

%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

    /* Count the number of lines parsed */
    int lineCnt = 1;
%}

%x  SINGLE_LINE_COMMENT
%x  MULTI_LINE_COMMENT

/* LEXICAL ELEMENTS */

/* KEYWORDS */
KEYWORD                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"define"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"

/* IDENTIFIER */
IDENTIFIER_NONDIGIT         [_a-zA-Z]
DIGIT                       [0-9]
IDENTIFIER                  {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/* CONSTANTS */
SIGN 						"+"|"-"

NONZERO_DIGIT				[1-9]
NONZERO_INT_CONSTANT	    {NONZERO_DIGIT}({DIGIT})*
INT_CONSTANT                "0"|[-]?{NONZERO_INT_CONSTANT}

FRACTIONAL_CONSTANT			({INT_CONSTANT}?"."{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}".")
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
PUNCTUATOR  				"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

/* WHITESPACES & NEWLINE */
NEWLINE                     "\n"
WS                          " "|"\t"

%%

{KEYWORD}  {                                                   
    if(!strcmp(yytext, "auto"))			{ return AUTO; }
    if(!strcmp(yytext, "break"))		{ return BREAK; }
    if(!strcmp(yytext, "case"))			{ return CASE; }
    if(!strcmp(yytext, "char"))		  	{ return CHAR; }
    if(!strcmp(yytext, "const"))		{ return CONST; }
    if(!strcmp(yytext, "continue"))		{ return CONTINUE; }
    if(!strcmp(yytext, "default"))		{ return DEFAULT; }
    if(!strcmp(yytext, "do"))			{ return DO; }
    if(!strcmp(yytext, "double"))		{ return DOUBLE; }
    if(!strcmp(yytext, "else"))			{ return ELSE; }
    if(!strcmp(yytext, "enum"))			{ return ENUM; }
    if(!strcmp(yytext, "extern"))		{ return EXTERN; }
    if(!strcmp(yytext, "float"))		{ return FLOAT; }
    if(!strcmp(yytext, "for"))			{ return FOR; }
    if(!strcmp(yytext, "goto"))			{ return GOTO; }
    if(!strcmp(yytext, "signed"))		{ return SIGNED; }
    if(!strcmp(yytext, "struct"))	    { return STRUCT; }
    if(!strcmp(yytext, "_Imaginary"))	{ return _IMAGINARY; }
    if(!strcmp(yytext, "short"))		{ return SHORT; }
    if(!strcmp(yytext, "_Complex"))		{ return _COMPLEX; }
    if(!strcmp(yytext, "register"))		{ return REGISTER; }
    if(!strcmp(yytext, "void"))			{ return VOID; }
    if(!strcmp(yytext, "restrict"))		{ return RESTRICT; } 
    if(!strcmp(yytext, "unsigned"))		{ return UNSIGNED; }
    if(!strcmp(yytext, "return"))		{ return RETURN; }
    if(!strcmp(yytext, "volatile"))		{ return VOLATILE; }
    if(!strcmp(yytext, "while"))		{ return WHILE; }
    if(!strcmp(yytext, "sizeof"))		{ return SIZEOF; }
    if(!strcmp(yytext, "_Bool"))		{ return _BOOL; }
    if(!strcmp(yytext, "if"))			{ return IF; }
    if(!strcmp(yytext, "static"))		{ return STATIC; }
    if(!strcmp(yytext, "inline"))		{ return INLINE; }
    if(!strcmp(yytext, "int"))			{ return INT;    }
    if(!strcmp(yytext, "switch"))		{ return SWITCH; }
    if(!strcmp(yytext, "long"))			{ return LONG;   }
    if(!strcmp(yytext, "typedef"))		{ return TYPEDEF;}
    if(!strcmp(yytext, "union"))		{ return UNION;  }
}

{IDENTIFIER}                { return IDENTIFIER;                     }
{INT_CONSTANT}              { return INT_CONSTANT;                   }
{FLOAT_CONSTANT}            { return FLOAT_CONSTANT;                 }
{ENUMERATION_CONSTANT}      { return ENUMERATION_CONSTANT;           }
{CHAR_CONSTANT}             { return CHAR_CONSTANT;                  }
{STRING_LITERAL}            { return STRING_LITERAL;                 }
{NEWLINE}      { 
    lineCnt++;    
    printf("\n--------------- Line Break: %d ---------------\n", lineCnt); 
}

"/*"                        { BEGIN(MULTI_LINE_COMMENT);             }
<MULTI_LINE_COMMENT>"*/"    { BEGIN(INITIAL);                        }
<MULTI_LINE_COMMENT>.       {                                        }
<MULTI_LINE_COMMENT>"\n"    { lineCnt++;                             }

"//"                        { BEGIN(SINGLE_LINE_COMMENT);            }
<SINGLE_LINE_COMMENT>"\n"   { lineCnt++; BEGIN(INITIAL);             }
<SINGLE_LINE_COMMENT>.      {                                        }    

{WS}    {                      
    /* Skip the whitespaces */               
}

"["      { return '[';  }
"]"      { return ']';  }
"("      { return '(';  }
")"      { return ')';  }
"{"      { return '{';  }
"}"      { return '}';  }
"."      { return '.';  }
"->"     { return ARROW;}
"++"     { return INC;  }
"--"     { return DEC;  }
"&"      { return BITWISE_AND;  }
"*"      { return MUL;  }
"+"      { return ADD;  }
"-"      { return SUB;  }
"~"      { return BITWISE_AND;  }
"!"      { return NEGATE;       }
"/"      { return DIV;  }
"%"      { return MOD;  }
"<<"     { return LEFT_SHIFT;   }
">>"     { return RIGHT_SHIFT;  }
"<"      { return  LT;  }
">"      { return  GT;  }
"<="     { return LTE;  }
">="     { return GTE;  }
"=="     { return EQL;  }
"!="     { return NEQ;  }
"^"      { return BITWISE_XOR;  }
"|"      { return BITWISE_OR;   }
"&&"     { return AND;  }
"||"     { return OR;   }
"?"      { return '?';  }
":"      { return ':';  }
";"      { return ';';  }
"..."    { return ELLIPSIS;     }
"="      { return ASSIGN;       }
"*="     { return MULT_ASSIGN;  }
"/="     { return DIV_ASSIGN;   }
"%="     { return MOD_ASSIGN;   }
"+="     { return ADD_ASSIGN;   }
"-="     { return SUB_ASSIGN;   }
"<<="    { return LS_ASSIGN;    }
">>="    { return RS_ASSIGN;    }
"&="     { return BITWISE_AND_ASSIGN;   }
"^="     { return BITWISE_XOR_ASSIGN;   }
"|="     { return BITWISE_OR_ASSIGN;    }
","      { return ',';  }
"#"      { return HASH; }                                                      

%%