%{
	#include <stdio.h>

	extern int yylex();
	void yyerror(char *str);
%}

%union {
    int iVal;
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 
%token IDENTIFIER INT_CONSTANT FLOAT_CONSTANT CHAR_CONSTANT STRING_LITERAL ENUMERATION_CONSTANT
%token ARROW INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT NEGATE DIV MOD LEFT_SHIFT RIGHT_SHIFT
%token LT GT LTE GTE EQL NEQ BITWISE_XOR BITWISE_OR AND OR
%token ELLIPSIS 
%token ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LS_ASSIGN RS_ASSIGN BITWISE_AND_ASSIGN BITWISE_XOR_ASSIGN BITWISE_OR_ASSIGN 
%token HASH 

%start translation_unit

%%

/* Empty production rules indicate epsilon production rules */
constant
	: INT_CONSTANT 
	| FLOAT_CONSTANT 
	| CHAR_CONSTANT
	;

primary_expression
	: IDENTIFIER
    { printf("| Production Rule: primary_expression -to- IDENTIFIER |\n"); }
	| constant
    { printf("| Production Rule: primary_expression -to- constant |\n"); }
	| STRING_LITERAL
    { printf("| Production Rule: primary_expression -to- string_literal |\n"); }
	| '(' expression ')'
	{ printf("| Production Rule: primary_expression -to- (expression) |\n"); }
	;

postfix_expression
	: primary_expression
    { printf("| Production Rule: postfix_expression -to- primary_expression |\n"); }
	| postfix_expression '[' expression ']'
    { printf("| Production Rule: postfix_expression -to- postfix_expression [expression] |\n"); }
	| postfix_expression '(' argument_expression_list_opt ')'
    { printf("| Production Rule: postfix_expression -to- postfix_expression (argument_expression_list_opt) |\n"); }
	| postfix_expression '.' IDENTIFIER
    { printf("| Production Rule: postfix_expression -to- postfix_expression . IDENTIFIER |\n"); }
	| postfix_expression ARROW IDENTIFIER
    { printf("| Production Rule: postfix_expression -to- postfix_expression -> IDENTIFIER |\n"); }
	| postfix_expression INC
    { printf("| Production Rule: postfix_expression -to- postfix_expression++ |\n"); }
	| postfix_expression DEC
    { printf("| Production Rule: postfix_expression -to- postfix_expression-- |\n"); }
	| '(' type_name ')' '{' initializer_list '}'
    { printf("| Production Rule: postfix_expression -to- (type_name) {initializer_list} |\n"); }
	| '(' type_name ')' '{' initializer_list ',' '}'
	{ printf("| Production Rule: postfix_expression -to- (type_name) {initializer_list, } |\n"); }
	;

argument_expression_list
	: assignment_expression
    {printf("| Production Rule: argument_expression_list -to- argument_expression_list |\n");}
	| argument_expression_list ',' assignment_expression
	{printf("| Production Rule: argument_expression_list -to- argument_expression_list, assignment_expression |\n");}
	;

argument_expression_list_opt
	: argument_expression_list
	| 
    ;

unary_expression
	: postfix_expression
    {printf("| Production Rule: unary_expression -to- postfix_expression |\n");}
	| INC unary_expression
    {printf("| Production Rule: unary_expression -to- ++unary_expression |\n");}
	| DEC unary_expression
    {printf("| Production Rule: unary_expression -to- --unary_expression |\n");}
	| unary_operator cast_expression
    {printf("| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n");}
	| SIZEOF unary_expression
    {printf("| Production Rule: unary_expression -to- sizeof unary_expression |\n");}
	| SIZEOF '(' type_name ')'
	{printf("| Production Rule: unary_expression -to- sizeof(type_name) |\n");}
	;

unary_operator
	: BITWISE_AND
    {printf("| Production Rule: unary_operator -to- & |\n");}
	| MUL
    {printf("| Production Rule: unary_operator -to- * |\n");}
	| ADD
    {printf("| Production Rule: unary_operator -to- + |\n");}
	| SUB
    {printf("| Production Rule: unary_operator -to- - |\n");}
	| BITWISE_NOT
    {printf("| Production Rule: unary_operator -to- ~ |\n");}
	| NEGATE
	{printf("| Production Rule: unary_operator -to- ! |\n");}
	;

cast_expression
	: unary_expression
    {printf("| Production Rule: cast_expression -to- unary_expression |\n");}
	| '(' type_name ')' cast_expression
	{printf("| Production Rule: cast_expression -to- (type_name) cast_expression |\n");}
	;

multiplicative_expression
	: cast_expression
    {printf("| Production Rule: multiplicative_expression -to- cast_expression |\n");}
	| multiplicative_expression MUL cast_expression
    {printf("| Production Rule: multiplicative_expression -to- multiplicative_expression mod cast_expression |\n");}
	| multiplicative_expression DIV cast_expression
    {printf("| Production Rule: multiplicative_expression -to- multiplicative_expression mod cast_expression |\n");}
	| multiplicative_expression MOD cast_expression
	{printf("| Production Rule: multiplicative_expression -to- multiplicative_expression mod cast_expression |\n");}
	;

additive_expression
	: multiplicative_expression
    {printf("| Production Rule: additive_expression -to- multiplicative_expression |\n");}
	| additive_expression ADD multiplicative_expression
    {printf("| Production Rule: additive_expression -to- additive_expression + multiplicative_expression |\n");}
	| additive_expression SUB multiplicative_expression
	{printf("| Production Rule: additive_expression -to- additive_expression - multiplicative_expression |\n");}
	;

shift_expression
	: additive_expression
    {printf("| Production Rule: shift_expression -to- additive_expression |\n");}
	| shift_expression LEFT_SHIFT additive_expression
    {printf("| Production Rule: shift_expression -to- shift_expression << additive_expression |\n");}
	| shift_expression RIGHT_SHIFT additive_expression
	{printf("| Production Rule: shift_expression -to- shift_expression >> additive_expression |\n");}
	;

relational_expression
	: shift_expression
    {printf("| Production Rule: relational_expression -to- shift_expression |\n");}
	| relational_expression LT shift_expression
    {printf("| Production Rule: relational_expression -to- relational_expression < shift_expression |\n");}
	| relational_expression GT shift_expression
    {printf("| Production Rule: relational_expression -to- relational_expression > shift_expression |\n");}
	| relational_expression LTE shift_expression
    {printf("| Production Rule: relational_expression -to- relational_expression <= shift_expression |\n");}
	| relational_expression GTE shift_expression
	{printf("| Production Rule: relational_expression -to- relational_expression >= shift_expression |\n");}
	;

equality_expression
	: relational_expression
    {printf("| Production Rule: equality_expression -to- relational_expression |\n");}
	| equality_expression EQL relational_expression
    {printf("| Production Rule: equality_expression -to- equality_expression == relational_expression |\n");}
	| equality_expression NEQ relational_expression
	{printf("| Production Rule: equality_expression -to- equality_expression != relational_expression |\n");}
	;

and_expression
	: equality_expression
    {printf("| Production Rule: and_expression -to- equality_expression |\n");}
	| and_expression BITWISE_AND equality_expression
	{printf("| Production Rule: and_expression -to- and_expression & equality_expression |\n");}
	;

exclusive_or_expression
	: and_expression
    {printf("| Production Rule: exclusive_or_expression -to- and_expression |\n");}
	| exclusive_or_expression BITWISE_XOR and_expression
	{printf("| Production Rule: exclusive_or_expression -to- exclusive_or_expression ^ and_expression |\n");}
	;

inclusive_or_expression
	: exclusive_or_expression
    {printf("| Production Rule: inclusive_or_expression -to- exclusive_or_expression |\n");}
	| inclusive_or_expression BITWISE_OR exclusive_or_expression
	{printf("| Production Rule: inclusive_or_expression -to- inclusive_or_expression | exclusive_or_expression |\n");}
	;

logical_and_expression
	: inclusive_or_expression
    {printf("| Production Rule: logical_and_expression -to- inclusive_or_expression |\n");}
	| logical_and_expression AND inclusive_or_expression
	{printf("| Production Rule: logical_and_expression -to- logical_and_expression && inclusive_or_expression |\n");}
	;

logical_or_expression
	: logical_and_expression
    {printf("| Production Rule: logical_or_expression -to- logical_and_expression |\n");}
	| logical_or_expression OR logical_and_expression
	{printf("| Production Rule: logical_or_expression -to- logical_or_expression || logical_and_expression |\n");}
	;

conditional_expression
	: logical_or_expression
    {printf("| Production Rule: conditional_expression -to- logical_or_expression |\n");}
	| logical_or_expression '?' expression ':' conditional_expression
	{printf("| Production Rule: conditional_expression -to- logical_or_expression ? expression : conditional_expression |\n");}
	;

assignment_expression
	: conditional_expression
    {printf("| Production Rule: assignment_expression -to- conditional_expression |\n");}
	| unary_expression assignment_operator assignment_expression
	{printf("| Production Rule: assignment_expression -to- unary_expression assignment_operator assignment_expression |\n");}
	;

assignment_operator
	: ASSIGN
    {printf("| Production Rule: assignment_operator -to- = |\n");}
	| MULT_ASSIGN
    {printf("| Production Rule: assignment_operator -to- *= |\n");}
	| DIV_ASSIGN
    {printf("| Production Rule: assignment_operator -to- /= |\n");}
	| MOD_ASSIGN
    {printf("| Production Rule: assignment_operator -to- mod= |\n");}
	| ADD_ASSIGN
    {printf("| Production Rule: assignment_operator -to- += |\n");}
	| SUB_ASSIGN
    {printf("| Production Rule: assignment_operator -to- -= |\n");}
	| LS_ASSIGN
    {printf("| Production Rule: assignment_operator -to- <<= |\n");}
	| RS_ASSIGN
    {printf("| Production Rule: assignment_operator -to- >>= |\n");}
	| BITWISE_AND_ASSIGN
    {printf("| Production Rule: assignment_operator -to- &= |\n");}
	| BITWISE_XOR_ASSIGN
    {printf("| Production Rule: assignment_operator -to- ^= |\n");}
	| BITWISE_OR_ASSIGN
	{printf("| Production Rule: assignment_operator -to- |= |\n");}
	;

expression
	: assignment_expression
    {printf("| Production Rule: expression -to- assignment_expression |\n");}
	| expression ',' assignment_expression
	{printf("| Production Rule: expression -to- expression, assignment_expression |\n");}
	;

constant_expression
	: conditional_expression
	{printf("| Production Rule: constant_expression -to- conditional_expression |\n");}
	;

declaration
	: declaration_specifiers init_declarator_list_opt ';'
	{printf("| Production Rule: declaration -to- declaration_specifiers init_declarator_list_opt |\n");}
	;

init_declarator_list_opt
	: init_declarator_list
	| 
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers_opt
    {printf("| Production Rule: declaration_specifiers -to- storage_class_specifier declaration_specifiers_opt |\n");}
	| type_specifier declaration_specifiers_opt
    {printf("| Production Rule: declaration_specifiers -to- type_specifier declaration_specifiers_opt |\n");}
	| type_qualifier declaration_specifiers_opt
    {printf("| Production Rule: declaration_specifiers -to- type_qualifier declaration_specifiers_opt |\n");}
	| function_specifier declaration_specifiers_opt
	{printf("| Production Rule: declaration_specifiers -to- function_specifier declaration_specifiers_opt |\n");}
	;

declaration_specifiers_opt
	: declaration_specifiers
	| 
	;

init_declarator_list
	: init_declarator
    {printf("| Production Rule: init_declarator_list -to- init_declarator |\n");}
	| init_declarator_list ',' init_declarator
	{printf("| Production Rule: init_declarator_list -to- init_declarator_list, init_declarator |\n");}
	;

init_declarator
	: declarator
    {printf("| Production Rule: init_declarator -to- declarator |\n");}
	| declarator ASSIGN initializer
	{printf("| Production Rule: init_declarator -to- declarator = initializer |\n");}
	;

storage_class_specifier
	: EXTERN
    {printf("| Production Rule: storage_class_specifier -to- extern |\n");}
	| STATIC
    {printf("| Production Rule: storage_class_specifier -to- static |\n");}
	| AUTO
    {printf("| Production Rule: storage_class_specifier -to- auto |\n");}
	| REGISTER
	{printf("| Production Rule: storage_class_specifier -to- register |\n");}
	;

type_specifier
	: VOID
    {printf("| Production Rule: type_specifier -to- void |\n");}
	| CHAR
    {printf("| Production Rule: type_specifier -to- char |\n");}
	| SHORT
    {printf("| Production Rule: type_specifier -to- short |\n");}
	| INT
    {printf("| Production Rule: type_specifier -to- int |\n");}
	| LONG
    {printf("| Production Rule: type_specifier -to- long |\n");}
	| FLOAT
    {printf("| Production Rule: type_specifier -to- float |\n");}
	| DOUBLE
    {printf("| Production Rule: type_specifier -to- double |\n");}
	| SIGNED
    {printf("| Production Rule: type_specifier -to- signed |\n");}
	| UNSIGNED
    {printf("| Production Rule: type_specifier -to- unsigned |\n");}
	| _BOOL
    {printf("| Production Rule: type_specifier -to- _BOOL |\n");}
	| _COMPLEX
    {printf("| Production Rule: type_specifier -to- _COMPLEX |\n");}
	| _IMAGINARY
    {printf("| Production Rule: type_specifier -to- _IMAGINARY |\n");}
	| enum_specifier
	{printf("| Production Rule: type_specifier -to- enum_specifier |\n");}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt
    {printf("| Production Rule: specifier_qualifier_list -to- type_specifier specifier_qualifier_list_opt|\n");}
	| type_qualifier specifier_qualifier_list_opt
	{printf("| Production Rule: specifier_qualifier_list -to- type_qualifier specifier_qualifier_list_opt|\n");}
	;

specifier_qualifier_list_opt
	: specifier_qualifier_list
	| 
	;

type_qualifier
	: CONST
    {printf("| Production Rule: type_qualifier -to- const |\n");}
	| VOLATILE
    {printf("| Production Rule: type_qualifier -to- volatile |\n");}
	| RESTRICT
	{printf("| Production Rule: type_qualifier -to- restrict |\n");}
	;

function_specifier
	: INLINE
	{printf("| Production Rule: function_specifier -to- inline |\n");}
	;

declarator
	: pointer_opt direct_declarator
	{printf("| Production Rule: declarator -to- pointer_opt direct_declarator |\n");}
	;

pointer_opt
	: pointer
	| 
	;

direct_declarator
	: IDENTIFIER
    {printf("| Production Rule: direct_declarator -to- IDENTIFIER |\n");}
	| '(' declarator ')'
    {printf("| Production Rule: direct_declarator -to- (declarator) |\n");}
	| direct_declarator '['  type_qualifier_list_opt assignment_expression_opt ']'
    {printf("| Production Rule: direct_declarator -to- direct_declarator [type_qualifier_list_opt assignment_expression_opt] |\n");}
	| direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'
    {printf("| Production Rule: direct_declarator -to- direct_declarator [static type_qualifier_list_opt assignment_expression] |\n");}
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
    {printf("| Production Rule: direct_declarator -to- direct_declarator [type_qualifier_list static assignment_expression] |\n");}
	| direct_declarator '[' type_qualifier_list_opt MUL ']'
    {printf("| Production Rule: direct_declarator -to- direct_declarator [type_qualifier_list_opt *] |\n");}
	| direct_declarator '(' parameter_type_list ')'
    {printf("| Production Rule: direct_declarator -to- direct_declarator (parameter_type_list) |\n");}
	| direct_declarator '(' identifier_list_opt ')'
	{printf("| Production Rule: direct_declarator -to- direct_declarator (identifier_list_opt) |\n");}
	;

type_qualifier_list_opt
	: type_qualifier_list
	| 
	;

type_qualifier_list
	: type_qualifier
    {printf("| Production Rule: type_qualifier_list -to- type_qualifier |\n");}
	| type_qualifier_list type_qualifier
	{printf("| Production Rule: type_qualifier_list -to- type_qualifier_list type_qualifier |\n");}
	;

assignment_expression_opt
	: assignment_expression
	| 
	;

identifier_list_opt
	: identifier_list
	| 
	;

identifier_opt
	: IDENTIFIER
	| 
	;

enumerator_list
	: enumerator
    {printf("| Production Rule: enumerator_list -to- enumerator |\n");}
	| enumerator_list ',' enumerator
	{printf("| Production Rule: enumerator_list -to- enumerator_list, enumerator |\n");}
	;

enumerator
	: ENUMERATION_CONSTANT
    {printf("| Production Rule: enumerator -to- ENUMERATION_CONSTANT |\n");}
	| ENUMERATION_CONSTANT ASSIGN constant_expression
	{printf("| Production Rule: enumerator -to- ENUMERATION_CONSTANT = constant_expression |\n");}
	;

enum_specifier
	: ENUM identifier_opt '{' enumerator_list '}'
    {printf("| Production Rule: enum_specifier -to- enum identifier_opt {enumerator_list} |\n");}
	| ENUM identifier_opt '{' enumerator_list ',' '}'
    {printf("| Production Rule: enum_specifier -to- enum identifier_opt {enumerator_list, } |\n");}
	| ENUM IDENTIFIER
	{printf("| Production Rule: enum_specifier -to- enum IDENTIFIER |\n");}
	;

pointer
	: MUL type_qualifier_list_opt
    {printf("| Production Rule: pointer -to- * type_qualifier_list_opt |\n");}
	| MUL type_qualifier_list_opt pointer
	{printf("| Production Rule: pointer -to- * type_qualifier_list_opt pointer |\n");}
	;

parameter_type_list
	: parameter_list
    {printf("| Production Rule: parameter_type_list -to- parameter_list |\n");}
	| parameter_list ',' ELLIPSIS
	{printf("| Production Rule: parameter_type_list -to- parameter_list, ... |\n");}
	;

parameter_list
	: parameter_declaration
    {printf("| Production Rule: parameter_list -to- parameter_declaration|\n");}
	| parameter_list ',' parameter_declaration
	{printf("| Production Rule: parameter_list -to- parameter_list, parameter_declaration|\n");}
	;

parameter_declaration
	: declaration_specifiers declarator
    {printf("| Production Rule: parameter_declaration -to- declaration_specifiers declarator|\n");}
	| declaration_specifiers
	{printf("| Production Rule: parameter_declaration -to- declaration_specifiers |\n");}
	;

identifier_list
	: IDENTIFIER
    {printf("| Production Rule: identifier_list -to- IDENTIFIER |\n");}
	| identifier_list ',' IDENTIFIER
	{printf("| Production Rule: identifier_list -to- identifier_list, IDENTIFIER |\n");}
	;

type_name
	: specifier_qualifier_list
	{printf("| Production Rule: type_name  -to- specifier_qualifier_list |\n");}
	;

initializer
	: assignment_expression
    {printf("| Production Rule: initializer -to- assignment_expression |\n");}
	| '{' initializer_list '}'
    {printf("| Production Rule: initializer -to- {initializer_list} |\n");}
	| '{' initializer_list ',' '}'
	{printf("| Production Rule: initializer -to- {initializer_list, } |\n");}
	;

initializer_list
	: designation_opt initializer
    {printf("| Production Rule: initializer_list -to- designation_opt initializer |\n");}
	| initializer_list ',' designation_opt initializer
	{printf("| Production Rule: initializer_list -to- initializer_list, designation_opt initializer |\n");}
	;

designation_opt
	: designation
	| 
	;

designation
	: designator_list ASSIGN
	{printf("| Production Rule: designation -to- designator_list = |\n");}
	;

designator_list
	: designator
    {printf("| Production Rule: designator_list -to- designator |\n");}
	| designator_list designator
	{printf("| Production Rule: designator_list -to- designator_list designator |\n");}
	;

designator
	: '[' constant_expression ']'
    {printf("| Production Rule: designator -to- [constant_expression] |\n");}
	| '.' IDENTIFIER
	{printf("| Production Rule: designator -to- .IDENTIFIER |\n");}
	;

statement
	: labeled_statement
    {printf("| Production Rule: statement -to- labeled_statement |\n");}
	| compound_statement
    {printf("| Production Rule: statement -to- compound_statement |\n");}
	| expression_statement
    {printf("| Production Rule: statement -to- expression_statement |\n");}
	| selection_statement
    {printf("| Production Rule: statement -to- jump_statement |\n");}
	| iteration_statement
    {printf("| Production Rule: statement -to- iteration_statement |\n");}
	| jump_statement
	{printf("| Production Rule: statement -to- jump_statement |\n");}
	;

labeled_statement
	: IDENTIFIER ':' statement
    {printf("| Production Rule: labeled_statement -to- IDENTIFIER: statement |\n");}
	| CASE constant_expression ':' statement
    {printf("| Production Rule: labeled_statement -to- case(constant_expression): statement |\n");}
	| DEFAULT ':' statement
	{printf("| Production Rule: labeled_statement -to- default: statement |\n");}
	;

compound_statement
	: '{' block_item_list_opt '}'
	{printf("| Production Rule: compound_statement -to- {block_item_list_opt}|\n");}
	;

block_item_list_opt
	: block_item_list
	| 
	;

block_item_list
	: block_item
    {printf("| Production Rule: block_item_list  -to- block_item|\n");}
	| block_item_list block_item
	{printf("| Production Rule: block_item_list  -to- block_item_list block_item|\n");}
	;

block_item
	: declaration
    {printf("| Production Rule: block_item -to- declaration |\n");}
	| statement
	{printf("| Production Rule: block_item -to- statement |\n");}
	;

expression_statement
	: expression_opt ';'
	{printf("| Production Rule: expression_statement -to- expression_opt; |\n");}
	;

selection_statement
	: IF '(' expression ')' statement
    {printf("| Production Rule: selection_statement -to- if(expression) statement |\n");}
	| IF '(' expression ')' statement ELSE statement
    {printf("| Production Rule: selection_statement -to- if(expression) statement else statement |\n");}
	| SWITCH '(' expression ')' statement
	{printf("| Production Rule: selection_statement -to- switch(expression) statement |\n");}
	;

iteration_statement
	: WHILE '(' expression ')' statement
    {printf("| Production Rule: iteration_statement -to- while (expression) statement |\n");}
	| DO statement WHILE '(' expression ')' ';'
    {printf("| Production Rule: iteration_statement -to- do statement while (expression); |\n");}
	| FOR '(' expression_opt ';' expression_opt ';' expression_opt ')' statement
    {printf("| Production Rule: iteration_statement -to- for (declaration expression_opt; expression_opt; expression_opt) statement |\n");}
	| FOR '(' declaration expression_opt ';' expression_opt ')' statement
	{printf("| Production Rule: iteration_statement -to- for (declaration expression_opt; expression_opt) statement |\n");}
	;

expression_opt
	: expression
	| 
	;

jump_statement
	: GOTO IDENTIFIER ';'
    {printf("| Production Rule: jump_statement -to- goto IDENTIFIER ; |\n");}
	| CONTINUE ';'
    {printf("| Production Rule: jump_statement -to- continue ; |\n");}
	| BREAK ';'
    {printf("| Production Rule: jump_statement -to- break ; |\n");}
	| RETURN expression_opt ';'
	{printf("| Production Rule: jump_statement -to- return expression_opt ; |\n");}
	;

translation_unit
	: external_declaration
    {printf("| Production Rule: translation_unit -to- external_declaration |\n");}
	| translation_unit external_declaration
	{printf("| Production Rule: translation_unit -to- translation_unit external_declaration |\n");}
	;

external_declaration
	: function_definition
    {printf("| Production Rule: external_declaration -to- function_definition |\n");}
	| declaration
	{printf("| Production Rule: external_declaration -to- declaration |\n");}
	;

function_definition
	: declaration_specifiers declarator declaration_list_opt compound_statement
	{printf("| Production Rule: function_definition -to- declaration_specifiers declarator declaration_list_opt compound_statement |\n");}
	;

declaration_list_opt
	: declaration_list
	| 
	;

declaration_list
	: declaration
    {printf("| Production Rule: declaration_list -to- declaration |\n");}
	| declaration_list declaration
	{printf("| Production Rule: declaration_list -to- declaration_list declaration |\n");}
	;

%%

void yyerror(char *str) {
	printf("The obtained error is %s", str);
}
