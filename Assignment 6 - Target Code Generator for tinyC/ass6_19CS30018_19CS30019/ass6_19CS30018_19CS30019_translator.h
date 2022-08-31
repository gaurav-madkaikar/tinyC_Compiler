
/* Compilers lab Assignment 6 - Target Code Generator */
/* Group No: 24 */
/* Group Members: Gaurav Madkaikar, Girish Kumar */

#ifndef ASS6_19CS30018_19CS30019_TRANSLATOR_H
#define ASS6_19CS30018_19CS30019_TRANSLATOR_H

#include <stdio.h>
#include <vector>
#include <cstdlib>
#include <string>
#include <set>
#include <map>
#include <stack>
#define vi vector<integer>
#define vxs vector<expresn *>
#define vquad vector<quad>
#define vstring vector<Str>
#define vts vector<types>
#define vsymd vector<symdata *>
using namespace std;
#define integer int
#define ext extern
#define Str string
#define vd void
ext map<integer, integer> mp_set;
ext integer size_bool, size_int, size_double, size_pointer, size_char;
ext stack<Str> params_stack, strin;
ext stack<integer> types_stack, offset_stack, ptrarr_stack;
ext vstring strings_label;
ext long long integer instr_count; // denotes count of instr
ext bool debug_on;				   // flag for debugging output

// Objects
class type_n;
class expresn;
class quad;
class symdata;
class symtab;
class quad_arr;
class funct;
class Array;
struct decStr;
struct idStr;
struct expresn;
struct arglistStr;

ext type_n *glob_type;
ext integer glob_width, next_instr, temp_count;
ext symtab *glob_st, *curr_st; //Global symbol table pointer
ext quad_arr glob_quad;		   //to store all the quads that will be generated by the grammar

enum types
{
	tp_void = 0,
	tp_bool,
	tp_arr,
	tp_func,
	tp_char,
	tp_int,
	tp_double,
	tp_ptr,
};

typedef struct list
{
	integer index;
	struct list *next;
} list;

enum opcode
{
	//Binary Assignment Operator
	Q_PLUS = 1,
	Q_MINUS,
	Q_MULT,
	Q_DIVIDE,
	Q_MODULO,
	Q_LEFT_OP,
	Q_RIGHT_OP,
	Q_XOR,
	Q_AND,
	Q_OR,
	Q_LOG_AND,
	Q_LOG_OR,
	Q_LESS,
	Q_LESS_OR_EQUAL,
	Q_GREATER_OR_EQUAL,
	Q_GREATER,
	Q_EQUAL,
	Q_NOT_EQUAL,

	//Unary Assignment Operator
	Q_UNARY_MINUS,
	Q_UNARY_PLUS,
	Q_COMPLEMENT,
	Q_NOT,

	//Copy Assignment
	Q_ASSIGN,
	Q_GOTO,

	//Conditional Jump
	Q_IF_EQUAL,
	Q_IF_NOT_EQUAL,
	Q_IF_EXPRESSION,
	Q_IF_NOT_EXPRESSION,
	Q_IF_LESS,
	Q_IF_GREATER,
	Q_IF_LESS_OR_EQUAL,
	Q_IF_GREATER_OR_EQUAL,

	//Type Conversions
	Q_CHAR2INT,
	Q_CHAR2DOUBLE,
	Q_INT2CHAR,
	Q_DOUBLE2CHAR,
	Q_INT2DOUBLE,
	Q_DOUBLE2INT,

	//Procedure Call
	Q_PARAM,
	Q_CALL,
	Q_RETURN,

	//Pointer Assignment Operator
	Q_LDEREF,
	Q_RDEREF,
	Q_ADDR,

	//Array Indexing
	Q_RINDEX,
	Q_LINDEX,

};

//it is the basic type that an element can have
union basic_val
{
	integer int_val;
	double double_val;
	char char_val;
};

vd update_nextinstr();

class type_n
{
public:
	integer size;									   // to save the size of the type
	types basetp;									   // to save the basic type of the elemnt
	type_n *next;									   // to save next type_n type for arrays
	type_n(types t, integer sz = 1, type_n *n = NULL); //constuctor
	integer getSize();								   //returns the size
	types getBasetp();								   //return Base type
	vd printSize();									   //to print the size
	vd print();
};

type_n *CopyType(type_n *);

vd debug();

class Array
{
public:
	/* Stores the array base and the variable containing the array offset */
	Str base_arr;
	Array(Str, integer, types);
	types tp;
	/* Stores array dimensions */
	vi dims;
	integer bsize, dimension_size;
	vd addindex(integer);
};

/* To store details of functions, its parameters and return type */
class funct
{
public:
	/* Parameter type list */
	vts typelist;

	/* Return type */
	type_n *rettype;

	funct(vts);
	/* Prints details in suitable format */
	vd print();
};

// Data associated with the Symbol table
class symdata
{
public:
	Str name, var_type;
	integer offset, size;
	basic_val i_val;  //to store the initialized value for an element stored at symbol table
	type_n *tp_n;	  //for storing the type of element
	symtab *nest_tab; //to store the pointer to the symbol table to which the current element belongs to
	Array *arr;		  //to store the pointer to an array if its an array type
	funct *fun;		  //to store the pointer to a function if its an function
	vd createarray();
	symdata(Str n = ""); //name is initialized to null that will be used for naming temporary variables
	bool isGlobal, isdone, ispresent, isptrarr, isArray, isFunction, isInitialized;
};

// Initialise the symbol table
class symtab
{
public:
	Str name;							  // name of the symbol
	integer offset, start_quad, end_quad; // final offset of this symbol table that will be used in the update function
	vsymd symbol_tab;					  //maintaining a list of symbol tables
	symtab();							  //constructor
	~symtab();							  //destructor
	symdata *lookup(Str);				  // Lookup function searches the variable with name. If the variable is present then returns its pointer location else creates a new entry with its name and returns that pointer
	symdata *lookup_2(Str);				  //To handle global variables
	symdata *search(Str);				  //it searches for the variable and returns the oiter to it if present
	symdata *gentemp(type_n *);			  //gentemp creates a new element in the symbol table with the type provided at the time of constructing
	integer no_params;
	vd print();
	vd update(symdata *, type_n *, basic_val, symtab *next = NULL); //
	vd mark_labels();
	vd function_prologue(FILE *, integer);
	vd global_variables(FILE *);
	vd gen_internal_code(FILE *, integer);
	integer function_call(FILE *);
	vd function_epilogue(FILE *, integer, integer);
	Str assign_reg(integer, integer);
	vd assign_offset();
	vd function_restore(FILE *);
	integer findg(Str);
};

// Expression class
struct expresn
{
	symdata *loc;
	type_n *type;
	list *falselist, *truelist;
	bool isArray, isPointer, isString;
	integer ind_str;
	symdata *poss_array, *arr;
};

// Additional functions associated with  expression and their interconversions
list *makelist(integer);
list *merge(list *, list *);
vd backpatch(list *, integer); //to fill the dangling list of goto's l1 to i
vd conv2Bool(expresn *);	   //to convert the given exprssion type to bool mostly used in relational operator
vd typecheck(expresn *, expresn *, bool isAss = false);
vd print_list(list *);

// Declaration grammar
struct decStr
{
	type_n *type;  // type of the current declaration
	integer width; // width of the variable
};

// Quads 
class quad
{
public:
	Str arg1, result, arg2; //consist of three elements
	opcode op;
	vd print_arg();
	quad(opcode, Str, Str, Str); //constructorparameters
};

struct arglistStr
{
	vxs *arguments; // A simple vector is used to store the locations of all seen arguments
};

// Identifier
struct idStr
{
	symdata *loc; // pointer to the symboltable
	Str *name;	  // name of the identifier
};

struct strstr
{
	type_n lop;
	Str name;
};

// Data and functions associated with quads
class quad_arr
{
public:
	vquad arr; // list of quads
	quad_arr();
	vd emit(opcode, Str def1 = "", Str def2 = "", Str res = ""); //emit used for operations with 3 inputs
	vd emit(opcode, integer, Str operand = "");					 // emit for assignment of integer
	vd emit(opcode, double, Str operand = "");					 //emit for assignment of double
	vd emit(opcode, char, Str operand = "");					 //emit for assignment of char
	vd emit2(opcode, Str arg1 = "", Str arg2 = "", Str result = "");
	vd print(); //print the quads
};

#endif
