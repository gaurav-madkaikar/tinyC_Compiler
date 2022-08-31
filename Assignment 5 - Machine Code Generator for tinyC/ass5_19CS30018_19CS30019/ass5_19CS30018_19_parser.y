/* Compilers lab Assignment 5 - Intermediate Code Generation */
/* Group No: 24 */
/* Group Members: Gaurav Madkaikar, Girish Kumar */

%{
	// Header Files
	#include <iostream>
	#include <cstdlib>
	#include <sstream>
	#include <string>
	#include <cstring>

	// Translator File
	#include "ass5_19CS30018_19_translator.h"

	// Lexer
	extern int yylex();
	// Report Errors
	void yyerror(string str);
	// Last encounter data type
	extern string Type;
	int debug = 0;
	using namespace std;
%}

// yylval is a union of all declared data types
%union {
	char unaryOp;
	char* charStr;
	int instr;
    int intVal;

	symtype* sym_type;
	expr* E;
	sym* symb;
	statement* stmt;
	Array* arr;
}

// Tokens - Terminal 
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY 

%token <symb> IDENTIFIER
%token <intVal> INT_CONSTANT
%token <charStr> FLOAT_CONSTANT
%token <charStr> CHAR_CONSTANT ENUMERATION_CONSTANT
%token <charStr> STRING_LITERAL

%token ARROW INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT NEGATE DIV MOD LEFT_SHIFT RIGHT_SHIFT
%token LT GT LTE GTE EQL NEQ BITWISE_XOR BITWISE_OR AND OR
%token ELLIPSIS 
%token ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LS_ASSIGN RS_ASSIGN BITWISE_AND_ASSIGN BITWISE_XOR_ASSIGN BITWISE_OR_ASSIGN 
%token HASH 

// Types - Non-Terminals

// Unary Operator 
%type <unaryOp> unary_operator

// Number of parameters
%type <intVal> argument_expression_list

// Resolve the dangling 'else' issue
%right THEN ELSE

// Expressions
%type <E>
	expression
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	and_expression
	exclusive_or_expression
	inclusive_or_expression
	logical_and_expression
	logical_or_expression
	conditional_expression
	assignment_expression
	expression_statement

// Statements
%type <stmt>  
	statement
	compound_statement
	selection_statement
	iteration_statement
	labeled_statement 
	jump_statement
	block_item
	block_item_list

// Symbol type
%type <sym_type> pointer

// Symbol
%type <symb> constant initializer
%type <symb> direct_declarator init_declarator declarator

// Array Type
%type <arr> 
	postfix_expression
	unary_expression
	cast_expression

//Auxillary non-terminals M and N
%type <instr> M
%type <stmt> N

%start translation_unit

%%
// Grammar Rules and Actions

M : %empty 
	{
		// backpatching,stores the index of the next quad to be generated
		// Used in various control statements
		$$ = nextinstr();
	}   
	;

N : %empty
	{
		// backpatching,inserts a goto and stores the index of the next goto statement to guard against fallthrough
		$$ = new statement();            //N->nextlist=makelist(nextinstr) we have defined nextlist for Statements
		$$->nextlist = makelist(nextinstr());
		emit("GOTOOP","");
	}
	;

CT : %empty 
    { 															
		if (currentSymbol->nested == NULL) 
            changeTable(new symboltable(""));	
		else 
        {
			changeTable (currentSymbol ->nested);						
			emit ("LABEL", table->name);
		}
	}
	;

constant 
	:INT_CONSTANT {
		stringstream stObj;
		stObj << $1;
		string intStr = stObj.str();
		$$ = gentemp(new symtype("INTEGER"), intStr);
		emit("EQUAL", $$->name, $1);
	}
	|FLOAT_CONSTANT {
		$$ = gentemp(new symtype("FLOAT"), string($1));
		emit("EQUAL", $$->name, string($1));
	}
	|CHAR_CONSTANT {
		$$ = gentemp(new symtype("CHAR"), $1);
		emit("EQUAL", $$->name, string($1));
	}
	|ENUMERATION_CONSTANT {

	}
	;

primary_expression
	: constant {
		$$ = new expr();
		if (debug)
			cout << "| Production Rule: primary_expression -to- constant |\n";
		
		$$->loc = $1;
	}
	|IDENTIFIER { 
		$$ = new expr();                      //create new expression and store pointer to ST entry in the location					 
		$$->loc = $1;
		$$->type = "NONBOOL";

		if (debug)
			cout << "| Production Rule: primary_expression -to- IDENTIFIER |\n"; 
	}
	|STRING_LITERAL {
		$$ = new expr();
		if (debug) 
			cout << "| Production Rule: primary_expression -to- STRING_LITERAL |\n";
	
		symtype* tmp = new symtype("PTR");
		$$->loc = gentemp(tmp, $1);
		$$->loc->type->ptr = new symtype("CHAR");
	}
	|'(' expression ')'
	{ 
		$$ = $2;
		if (debug)
			cout << "| Production Rule: primary_expression -to- (expression) |\n"; 
	}
	;


postfix_expression
	:postfix_expression '[' expression ']' 
    {
		$$ = new Array();
		
		$$->STptr = $1->loc;					
        if (debug) 
            cout << "| Production Rule: postfix_expression -to- primary_expression |\n";
    
		$$->type = $1->type->ptr;				
		$$->loc = gentemp(new symtype("INTEGER"));		
		
		if ($1->cat == "ARR") 
        {						
			sym* t = gentemp(new symtype("INTEGER"));
			stringstream strs;
            if (debug) 
                cout << "| Production Rule: postfix_expression -to- primary_expression |\n";
        
		    strs << size_type($$->type);
		    string intStr = strs.str();				
 			emit ("MULT", t->name, $3->loc->name, intStr);
			emit ("ADD", $$->loc->name, $1->loc->name, t->name);
		}
 		else 
        {
 			stringstream strs;
		    strs << size_type($$->type);
		    string intStr = strs.str();
            if (debug) 
                cout << "| Production Rule: postfix_expression -to- primary_expression |\n";
	 	    emit("MULT", $$->loc->name, $3->loc->name, intStr);
 		}

		$$->cat = "ARR";
	}
    |primary_expression 
    {
		$$ = new Array();
		$$->STptr = $1->loc;
		if(debug)
			printf("| Production Rule: postfix_expression -to- primary_expression |\n"); 
		
		$$->loc = $$->STptr;
    	// Setting type value here
		$$->type = $1->loc->type;
	}	
    |postfix_expression '(' argument_expression_list ')' 
    {
		$$ = new Array();
        if(debug)
            cout << "| Production Rule: postfix_expression -to- postfix_expression (argument_expression_list) |\n";
		$$->STptr = gentemp($1->type);
		stringstream strs;
	    strs << $3;
	    string intStr = strs.str();		
		emit("CALL", $$->STptr->name, $1->STptr->name, intStr);
	}
	|postfix_expression '(' ')' {
	
	}	
    |'(' type_name ')' '{' initializer_list ',' '}' {
		$$ = new Array();
		$$->STptr = gentemp(new symtype("INTEGER"));
		$$->loc = gentemp(new symtype("INTEGER"));
	}
	|postfix_expression '.' IDENTIFIER {
        if(debug)
			cout << "| Production Rule: postfix_expression -to- postfix_expression . IDENTIFIER |\n"; 
	}
	|postfix_expression INC 
    {
		$$ = new Array();
        if(debug)
			cout << "| Production Rule: postfix_expression -to- postfix_expression ++ |\n"; 
		$$->STptr = gentemp($1->STptr->type);
		emit ("EQUAL", $$->STptr->name, $1->STptr->name);
		emit ("ADD", $1->STptr->name, $1->STptr->name, "1");
	}
    |'(' type_name ')' '{' initializer_list '}' 
    {
		$$ = new Array();
		$$->STptr = gentemp(new symtype("INTEGER"));
        if (debug) 
            cout << "| Production Rule: postfix_expression -to- (type_name) {initializer_list} |\n";
		$$->loc = gentemp(new symtype("INTEGER"));
	}
    |postfix_expression ARROW IDENTIFIER {

	}
	|postfix_expression DEC 
    {
		$$ = new Array();
        if(debug)
			cout << "| Production Rule: postfix_expression -to- postfix_expression -- |\n";
		$$->STptr = gentemp($1->STptr->type);
		emit ("EQUAL", $$->STptr->name, $1->STptr->name);
		emit ("SUB", $1->STptr->name, $1->STptr->name, "1");
	}
	;

unary_expression
  :postfix_expression 
    {
        $$ = $1;
        if (debug)
            cout << "| Production Rule: unary_expression -to- postfix_expression |\n";
	}
	|SIZEOF '(' type_name ')' 
    {
        if (debug) 
            cout << "| Production Rule: unary_expression -to- sizeof(type_name) |\n";
    
	}
	|DEC unary_expression 
    {
		emit ("SUB", $2->STptr->name, $2->STptr->name, "1");
        if (debug) 
            cout << "| Production Rule: unary_expression -to- --unary_expression |\n";

		$$ = $2;
	}
	|unary_operator cast_expression 
    {
		$$ = new Array();
		switch ($1) 
        {
			case '!':
				$$->STptr = gentemp(new symtype($2->STptr->type->type));
                if (debug) 
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
				emit ("LNOT", $$->STptr->name, $2->STptr->name);
				break;

			case '+':
                if (debug) 
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
        
				$$ = $2;
				break;

            case '*':
				$$->loc = gentemp ($2->STptr->type->ptr);
				$$->cat = "PTR";
                if (debug) 
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
				emit ("PTRR", $$->loc->name, $2->STptr->name);
				$$->STptr = $2->STptr;
				break;

			case '-':
				$$->STptr = gentemp(new symtype($2->STptr->type->type));
                if (debug) 
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
                emit ("UMINUS", $$->STptr->name, $2->STptr->name);
				break;

			case '&':
				$$->STptr = gentemp((new symtype("PTR")));
                if (debug)
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
        
				$$->STptr->type->ptr = $2->STptr->type; 
				emit ("ADDRESS", $$->STptr->name, $2->STptr->name);
				break;

			case '~':
				$$->STptr = gentemp(new symtype($2->STptr->type->type));
                if (debug) 
                    cout << "| Production Rule: unary_expression -to- unary_operator (cast_expression) |\n";
        
				emit ("BNOT", $$->STptr->name, $2->STptr->name);
				break;

 			default:
				break;
		}
	}
	|INC unary_expression {
		emit ("ADD", $2->STptr->name, $2->STptr->name, "1");
		$$ = $2;
	}
	|SIZEOF unary_expression {
	
	}
	;

argument_expression_list
	:argument_expression_list ',' assignment_expression 
    {
        emit ("PARAM", $3->loc->name);
        $$ = $1 + 1;
	}
    |assignment_expression 
    {
        emit ("PARAM", $1->loc->name);
        $$ = 1;
	}
	;

cast_expression
	:'(' type_name ')' cast_expression 
    {
		$$ = $4;
	}
	|unary_expression 
    {
		$$ = $1;
	}
	;

multiplicative_expression
	:multiplicative_expression MUL cast_expression 
    {
		if (typecheck ($1->loc, $3->STptr)) 
        {
			$$ = new expr();
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression * cast_expression |\n";
      
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MULT", $$->loc->name, $1->loc->name, $3->STptr->name);
		}
        else 
        {
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression * cast_expression |\n";
            cout << "ERROR: Type Error!!"<< endl;
        } 
	}
	|cast_expression 
    {
		$$ = new expr();
		if ($1->cat=="ARR") 
        { 
			$$->loc = gentemp($1->loc->type);
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- cast_expression |\n";
      
			emit("ARRR", $$->loc->name, $1->STptr->name, $1->loc->name);
		}
		else if ($1->cat == "PTR") 
        { 
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- cast_expression |\n";
			$$->loc = $1->loc;
		}
		else 
        { 
			$$->loc = $1->STptr;
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- cast_expression |\n";
		}
	}
	|multiplicative_expression MOD cast_expression {
		if (typecheck ($1->loc, $3->STptr)) 
        {
			$$ = new expr();
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression mod cast_expression |\n";

			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MODOP", $$->loc->name, $1->loc->name, $3->STptr->name);
		}
        else 
        {
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression mod cast_expression |\n";
            
            cout << "ERROR: Type Error!!"<< endl;
        } 
	}
	|multiplicative_expression DIV cast_expression 
    {
		if (typecheck ($1->loc, $3->STptr) ) 
        {
			$$ = new expr();
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression / cast_expression |\n";
      
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->STptr->name);
		}
        else 
        {
            if (debug) 
                cout << "| Production Rule: multiplicative_expression -to- multiplicative_expression / cast_expression |\n";
            
            cout << "ERROR: Type Error!!"<< endl;
        } 
	}
	;

additive_expression
	:additive_expression SUB multiplicative_expression 
    {
		if (typecheck ($1->loc, $3->loc)) 
        {
			$$ = new expr();
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("SUB", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;

	}
    |additive_expression ADD multiplicative_expression 
    {
		if (typecheck ($1->loc, $3->loc)) 
        {
			$$ = new expr();
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|multiplicative_expression 
    {
		$$ = $1;
	}
	;

unary_operator
	:NEGATE 
    {
		$$ = '!';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- ! |\n";  
	}
	|BITWISE_AND 
    {
        $$ = '&';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- & |\n";  
	}
	|SUB 
    {
		$$ = '-';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- - |\n";
	}
	|ADD 
    {
		$$ = '+';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- + |\n";
	}
	|BITWISE_NOT 
    {
        $$ = '~';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- ~ |\n"; 
	}
	|MUL 
    {
		$$ = '*';
        if (debug) 
            cout << "| Production Rule: unary_operator -to- * |\n";
	}
	;

relational_expression
	:relational_expression LT shift_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			$$ = new expr();
			$$->type = "BOOL";

            if (debug) 
                cout << "| Production Rule: relational_expression -to- relational_expression < shift_expression |\n";

			$$->falselist = makelist (nextinstr() + 1);
			$$->truelist = makelist (nextinstr());
			emit("LT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|shift_expression 
    {
        $$ = $1;
    }
	|relational_expression LTE shift_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			$$ = new expr();
			$$->type = "BOOL";

            if (debug) 
                cout << "| Production Rule: relational_expression -to- relational_expression <= shift_expression |\n";
            
			$$->falselist = makelist (nextinstr()+1);
			$$->truelist = makelist (nextinstr());
			emit("LE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|relational_expression GTE shift_expression {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			$$ = new expr();
			$$->type = "BOOL";

            if (debug) 
                cout << "| Production Rule: relational_expression -to- relational_expression >= shift_expression |\n";
            
			$$->falselist = makelist (nextinstr() + 1);
			$$->truelist = makelist (nextinstr());
			emit("GE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else 
            cout << "ERROR: Type Error!!" << endl;
	}
	|relational_expression GT shift_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			$$ = new expr();
			$$->type = "BOOL";

			$$->falselist = makelist (nextinstr() + 1);
            if (debug) 
                cout << "| Production Rule: relational_expression -to- relational_expression > shift_expression |\n";
            
			$$->truelist = makelist (nextinstr());
			emit ("GOTOOP", "");
			emit("GT", "", $1->loc->name, $3->loc->name);
		}
		else 
        {
            if (debug) 
                cout << "| Production Rule: relational_expression -to- relational_expression > shift_expression |\n";
            cout << "ERROR: Type Error"<< endl;
        }
	}
	;


exclusive_or_expression
	:exclusive_or_expression BITWISE_XOR and_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			convertBool2Int ($3);
			convertBool2Int ($1);
			
            if (debug) 
                cout << "| Production Rule: exclusive_or_expression -to- exclusive_or_expression ^ and_expression |\n";
            
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
        else 
        {
            if (debug) 
                cout << "| Production Rule: exclusive_or_expression -to- exclusive_or_expression ^ and_expression |\n";
            
            cout << "ERROR: Type Error!!"<< endl;
        } 
    }
	|and_expression 
    {
        $$ = $1;
    }
	;

equality_expression
	:equality_expression EQL relational_expression 
    {
		if (typecheck ($1->loc, $3->loc)) 
        {
			convertBool2Int ($3);
			convertBool2Int ($1);

            if (debug) 
                cout << "| Production Rule: equality_expression -to- equality_expression == relational_expression |\n";
            
            $$ = new expr();
            $$->type = "BOOL";
			$$->falselist = makelist (nextinstr() + 1);
			$$->truelist = makelist (nextinstr());
			emit("EQOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
        else 
        {
            if (debug) 
                cout << "| Production Rule: equality_expression -to- equality_expression == relational_expression |\n";
            
            cout << "ERROR: Type Error!!"<< endl;
        } 
	}
	|equality_expression NEQ relational_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			convertBool2Int ($3);
			convertBool2Int ($1);

			$$ = new expr();
			$$->type = "BOOL";

            if (debug) 
                cout << "| Production Rule: equality_expression -to- equality_expression != relational_expression |\n";
            
			$$->falselist = makelist(nextinstr() + 1);
			$$->truelist = makelist(nextinstr());
			emit("NEOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else 
            cout << "ERROR: Type Error!!" << endl;
	}
	|relational_expression 
    {
        $$ = $1;
    }
	;

shift_expression
	:shift_expression RIGHT_SHIFT additive_expression
    {
		if ($3->loc->type->type == "INTEGER") 
        {
			$$ = new expr();
            if (debug) 
                cout << "| Production Rule: shift_expression -to- shift_expression >> additive_expression |\n";
            
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|additive_expression 
    {
		$$ = $1;
	}
	|shift_expression LEFT_SHIFT additive_expression 
    {
		if ($3->loc->type->type == "INTEGER") 
        {
			$$ = new expr();

            if (debug) 
                cout << "| Production Rule: shift_expression -to- shift_expression << additive_expression |\n";
            
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	;


inclusive_or_expression
	:inclusive_or_expression BITWISE_OR exclusive_or_expression 
    {
		if (typecheck ($1->loc, $3->loc) ) 
        {
			convertBool2Int ($3);
			convertBool2Int ($1);
			
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("INOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|exclusive_or_expression 
    {
        $$ = $1;
    }
	;

logical_and_expression
	:logical_and_expression N AND M inclusive_or_expression 
    {
		convertInt2Bool($5);
        if (debug) 
            cout << "| Production Rule: logical_and_expression -to- logical_and_expression && inclusive_or_expression |\n";
		
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);

        // giving an implicit type of BOOL
		$$ = new expr();
		$$->type = "BOOL";

        // backpatching the required statements
		backpatch($1->truelist, $4);
		$$->falselist = merge ($1->falselist, $5->falselist);
		$$->truelist = $5->truelist;
	}
	|inclusive_or_expression 
    {
        $$ = $1;
    }
	;

logical_or_expression
	:logical_or_expression N OR M logical_and_expression 
    {
		convertInt2Bool($5);
		convertInt2Bool($1);
		backpatch($2->nextlist, nextinstr());

		$$ = new expr();
		$$->type = "BOOL";
        if (debug) 
            cout << "| Production Rule: logical_or_expression -to- logical_or_expression || logical_and_expression |\n";
	
		backpatch ($$->falselist, $4);
		$$->falselist = $5->falselist;
		$$->truelist = merge ($1->truelist, $5->truelist);
	}
	|logical_and_expression 
    {
        $$ = $1;
    }
	;

and_expression
	:and_expression BITWISE_AND equality_expression 
    {
		if (typecheck ($1->loc, $3->loc)) 
        {
			convertBool2Int ($3);
			convertBool2Int ($1);
			
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("BAND", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else 
            cout << "ERROR: Type Error!!"<< endl;
	}
	|equality_expression 
    {
        $$ = $1;
    }
	;

assignment_expression
	:unary_expression assignment_operator assignment_expression 
    {
		if($1->cat == "ARR") 
        {
			$3->loc = conv($3->loc, $1->type->type);
			emit("ARRL", $1->STptr->name, $1->STptr->name, $3->loc->name);	
		}
		else if($1->cat == "PTR") 
        {
			emit("PTRL", $1->STptr->name, $3->loc->name);	
		}
		else
        {
			$3->loc = conv($3->loc, $1->STptr->type->type);
			emit("EQUAL", $1->STptr->name, $3->loc->name);
		}
		$$ = $3;
	}
	|conditional_expression 
    {
        $$ = $1;
    }
	;

expression
	:expression ',' assignment_expression 
    {
	
	}
	|assignment_expression 
    {
        $$ = $1;
    }
	;

constant_expression
	:conditional_expression 
    {
	
	}
	;

declaration
	:declaration_specifiers ';' 
    {

	}
	|declaration_specifiers init_declarator_list ';' 
    {

	}
	;

declaration_specifiers
	:type_specifier 
    {

	}
	|type_qualifier declaration_specifiers 
    {

	}
	|type_specifier declaration_specifiers 
    {

	}
	|storage_class_specifier declaration_specifiers 
    {

	}
	|type_qualifier 
    {

	}
	|storage_class_specifier 
    {

	}
	|function_specifier 
    {

	}
	|function_specifier declaration_specifiers 
    {

	}
	;

conditional_expression
	:logical_or_expression N '?' M expression N ':' M conditional_expression 
    {
		$$->loc = gentemp($5->loc->type);
		$$->loc->update($5->loc->type);
		emit("EQUAL", $$->loc->name, $9->loc->name);
		list<int> l = makelist(nextinstr());
		emit ("GOTOOP", "");

		backpatch($6->nextlist, nextinstr());
		emit("EQUAL", $$->loc->name, $5->loc->name);
		list<int> m = makelist(nextinstr());
		l = merge (l, m);
		emit ("GOTOOP", "");

		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		backpatch ($1->falselist, $8);
		backpatch (l, nextinstr());
		backpatch ($1->truelist, $4);
	}
	|logical_or_expression 
    {
        $$ = $1;
    }
	;


init_declarator
	:declarator ASSIGN initializer 
    {
		if ($3->initial_value!="") 
        {
            $1->initial_value=$3->initial_value;
        }
		emit ("EQUAL", $1->name, $3->name);
	}
	|declarator 
    {
        $$ = $1;
    }
	;

storage_class_specifier
	:AUTO {

	}
	|REGISTER {

	}
	|STATIC {

	}
	|EXTERN {

	}
	;
init_declarator_list
	:init_declarator_list ',' init_declarator {

	}
	|init_declarator {

	}
	;

assignment_operator 
	:ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- = |\n";
	}
	|BITWISE_AND_ASSIGN {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- &= |\n";
	}
	|BITWISE_XOR_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- ^= |\n";
	}
	|LS_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- <<= |\n";
	}
	|RS_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- >>= |\n";
	}
	|BITWISE_OR_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- |= |\n";
	}
	|DIV_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- /= |\n";
	}
	|ADD_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- += |\n";
	}
	|SUB_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- -= |\n";
	}
	|MOD_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- %= |\n";
	}
	|MULT_ASSIGN 
    {
        if (debug) 
            cout << "| Production Rule: assignment_operator -to- *= |\n";
	}
	;

specifier_qualifier_list
	: type_qualifier specifier_qualifier_list 
    {

	}
	|type_qualifier 
    {

	}
	|type_specifier specifier_qualifier_list 
    {

	}
	|type_specifier 
    {

	}
	;

enumerator
	:IDENTIFIER ASSIGN constant_expression 
    {

	}
	|IDENTIFIER 
    {

	}
	;

enumerator_list
	:enumerator_list ',' enumerator 
    {

	}
	|enumerator 
    {

	}
	;
function_specifier
	:INLINE 
    {

	}
	;

type_qualifier
	:RESTRICT {

	}
	|VOLATILE {

	}
	|CONST {

	}
	;

pointer
	:MUL pointer 
    {
		$$ = new symtype("PTR", $2);
	}
	|MUL type_qualifier_list pointer 
    {

	}
	|MUL type_qualifier_list 
    {

	}
	|MUL 
    {
		$$ = new symtype("PTR");
	}
	;
parameter_list
	:parameter_list ',' parameter_declaration 
    {

	}
	|parameter_declaration 
    {

	}
	;

enum_specifier
	:ENUM IDENTIFIER {

	}
	|ENUM IDENTIFIER '{' enumerator_list ',' '}' {

	}
	|ENUM '{' enumerator_list '}' {

	}
	|ENUM IDENTIFIER '{' enumerator_list '}' {

	}
	|ENUM '{' enumerator_list ',' '}' {

	}
	;


declarator
	:pointer direct_declarator 
    {
		symtype* tmp = $1;
        if (debug) 
            cout << "| Production Rule: declarator -to- pointer direct_declarator |\n";

		while (tmp->ptr !=NULL) 
            tmp = tmp->ptr;

		tmp->ptr = $2->type;   
		$$ = $2->update($1);
	}
	|direct_declarator {

	}
	;

initializer_list
	:initializer_list ',' designation initializer {

	}
	|designation initializer {

	}
	|initializer_list ',' initializer {

	}
	|initializer {

	}
	;


direct_declarator
	: direct_declarator '[' assignment_expression ']' 
    {
        // Rules for Arrays
		symtype* tmp = $1->type;
		symtype* prev = NULL;

        // Setting type of Array
		while (tmp->type == "ARR") 
        {
			prev = tmp;
			tmp = tmp->ptr;
		}
        // Setting type of Array 
		if (prev == NULL) 
        {
			int temp = atoi($3->loc->initial_value.c_str());
			symtype* s = new symtype("ARR", $1->type, temp);
			$$ = $1->update(s);
		}
        // Setting type of Array
		else 
        {
			prev->ptr =  new symtype("ARR", tmp, atoi($3->loc->initial_value.c_str()));
			$$ = $1->update ($1->type);
		}
	}
	|direct_declarator '[' type_qualifier_list ']' {

	}
	|direct_declarator '(' CT parameter_type_list ')' 
    {
		table->name = $1->name;

		if ($1->type->type !="VOID") 
        {
			sym* s = table->lookup("return");
			s->update($1->type);		
		}
		$1->nested = table;

		table->parent = globalTable;
		changeTable (globalTable);				
		currentSymbol = $$;
	}
	|direct_declarator '[' type_qualifier_list assignment_expression ']' {

	}
	|'(' declarator ')' {
        $$ = $2;
    }
	|IDENTIFIER {
		$$ = $1->update(new symtype(Type));
		currentSymbol = $$;
	}
	|direct_declarator '[' type_qualifier_list MUL ']' {

	}
	|direct_declarator '[' MUL ']' {

    }
	|direct_declarator '[' ']' 
    {
		symtype* tmp = $1 -> type;
		symtype* prev = NULL;
		while (tmp->type == "ARR") 
        {
			prev = tmp;
			tmp = tmp->ptr;
		}
		if (prev == NULL) 
        {
			symtype* s = new symtype("ARR", $1->type, 0);
			$$ = $1->update(s);
		}
		else 
        {
			prev->ptr =  new symtype("ARR", tmp, 0);
			$$ = $1->update($1->type);
		}
	}
	|direct_declarator '[' STATIC type_qualifier_list assignment_expression ']' {

	}
	|direct_declarator '[' STATIC assignment_expression ']' {

	}
	|direct_declarator '(' identifier_list ')' {

	}
	|direct_declarator '(' CT ')' 
    {
		table->name = $1->name;

		if ($1->type->type !="VOID") 
        {
			sym* s = table->lookup("return");
			s->update($1->type);		
		}
		$1->nested=table;
		table->parent = globalTable;
		changeTable(globalTable);				
		currentSymbol = $$;
	}
	;

type_specifier
	:COMPLEX {

    }
	|IMAGINARY{

    }
	|VOID 
    {
        Type = "VOID";
    }
	|FLOAT 
    {
        Type = "FLOAT";
    }
	|SIGNED {

    }
	|UNSIGNED {

    }
	|CHAR 
    {
        Type = "CHAR";
    }
	|INT 
    {
        Type = "INTEGER";
    }
	|LONG {

    }
	|BOOL {

    }
	|DOUBLE {

    } 
	|SHORT {

    }
	|enum_specifier {

    }
	;

type_qualifier_list
	:type_qualifier_list type_qualifier 
    {

	}
	|type_qualifier 
    {

	}
	;
identifier_list
	:identifier_list ',' IDENTIFIER {

	}
	|IDENTIFIER {

	}
	;

type_name
	:specifier_qualifier_list {

	}
	;

initializer
	:'{' initializer_list ',' '}' {

	}
	|'{' initializer_list '}' {

	}
	|assignment_expression {
		$$ = $1->loc;
	}
	;

designation
	:designator_list ASSIGN {

	}
	;

designator_list
	:designator_list designator {

	}
	|designator {

	}
	;

designator
	:'.' IDENTIFIER {

	}
	|'[' constant_expression ']' {
	}
	;

labeled_statement
	:DEFAULT ':' statement 
    {
        $$ = new statement();
    }
	|CASE constant_expression ':' statement 
    {
        $$ = new statement();
    }
	|IDENTIFIER ':' statement 
    {
        $$ = new statement();
    }
	;

compound_statement
	:'{' block_item_list '}' 
    {
        $$ = $2;
    }
	|'{' '}' 
    {
        $$ = new statement();
    }
	;

declaration_list
	:declaration_list declaration {

	}
	|declaration {

	}
	;

block_item_list
	:block_item_list M block_item 
    {
		$$ = $3;
		backpatch($1->nextlist, $2);
	}
	|block_item 
    {
        $$ = $1;
    }
	;

function_definition
	:declaration_specifiers declarator CT compound_statement 
    {
		table->parent = globalTable;
		changeTable(globalTable);
	}
	|declaration_specifiers declarator declaration_list CT compound_statement {

    }
	;
expression_statement
	:';' 
    {
        $$ = new expr();
    }
	|expression ';' 
    {
        $$ = $1;
    }
	;

parameter_type_list
	:parameter_list ',' ELLIPSIS {

	}
	|parameter_list {

	}
	;

parameter_declaration
	:declaration_specifiers {

	}
	|declaration_specifiers declarator {

	}
	;


selection_statement
	:IF '(' expression N ')' M statement N ELSE M statement 
    {
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
		list<int> temp = merge ($7->nextlist, $8->nextlist);
		$$->nextlist = merge ($11->nextlist, temp);
	}
	|SWITCH '(' expression ')' statement {

	}
	|IF '(' expression N ')' M statement N %prec THEN{
		backpatch($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		list<int> temp = merge($3->falselist, $7->nextlist);
		$$->nextlist = merge($8->nextlist, temp);
	}
	;

statement
	:iteration_statement {
        $$ = $1;
    }
	|jump_statement {
        $$ = $1;
    }
	|compound_statement {
        $$ = $1;
    }
	|expression_statement {
		$$ = new statement();
		$$->nextlist = $1->nextlist;
	}
	|selection_statement {
        $$ = $1;
    }
	|labeled_statement {

	}
	;
jump_statement
	:CONTINUE ';' 
    {
        $$ = new statement();     
        if (debug) 
            cout << "| Production Rule: jump_statement -to- continue ; |\n"; 
    }
	|RETURN ';' 
    {
        if (debug) 
            cout << "| Production Rule: jump_statement -to- return ; |\n";
		$$ = new statement();
		emit("RETURN","");
	}
	|GOTO IDENTIFIER ';' 
    {
        $$ = new statement();
    }
	|RETURN expression ';' 
    {
		$$ = new statement();
        if (debug) {
        cout << "| Production Rule: jump_statement -to- return expression ; |\n";
        }
		emit("RETURN",$2->loc->name);
	}
	|BREAK ';' 
    {
        if (debug) 
            cout << "| Production Rule: jump_statement -to- break ; |\n";
        $$ = new statement();
    }
	;

translation_unit
	:translation_unit external_declaration {

    }
	|external_declaration {

    }
	;

external_declaration
	:declaration {

    }
	|function_definition {

    }
	;

iteration_statement
	:DO M statement M WHILE '(' expression ')' ';' 
    {
		convertInt2Bool($7);
		$$ = new statement();
		
		backpatch ($3->nextlist, $4);
		backpatch ($7->truelist, $2);
		$$->nextlist = $7->falselist;
	}
	|WHILE M '(' expression ')' M statement 
    {
		convertInt2Bool($4);
		$$ = new statement();
		
		backpatch($4->truelist, $6);
		backpatch($7->nextlist, $2);
		$$->nextlist = $4->falselist;
		
		stringstream strs;
	    strs << $2;
	    string intStr = strs.str();

		emit ("GOTOOP", intStr);
	}
	|FOR '(' expression_statement M expression_statement M expression N ')' M statement
    {
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($11->nextlist, $6);
		backpatch ($5->truelist, $10);
		backpatch ($8->nextlist, $4);
		stringstream strs;
	    strs << $6;
	    string intStr = strs.str();
		emit ("GOTOOP", intStr);
		$$->nextlist = $5->falselist;
	}
	|FOR '(' expression_statement M expression_statement ')' M statement
    {
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($8->nextlist, $4);
		backpatch ($5->truelist, $7);

		stringstream strs;
	    strs << $4;
	    string intStr = strs.str();

		emit ("GOTOOP", intStr);
		$$->nextlist = $5->falselist;
	}
	;

block_item
	:statement 
    {
        $$ = $1;
    }
	|declaration 
    {
		$$ = new statement();
	}
	;
%%

void yyerror(string str) 
{
    cout << str;
}