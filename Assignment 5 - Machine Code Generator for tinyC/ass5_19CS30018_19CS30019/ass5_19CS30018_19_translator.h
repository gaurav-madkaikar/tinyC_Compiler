#ifndef TRANSLATE_H
#define TRANSLATE_H

#include <bits/stdc++.h>
using namespace std;

#define CHAR_SIZE 1
#define INT_SIZE 4
#define FLOAT_SIZE 4
#define POINTER_SIZE 4

extern char *yytext;
extern int yyparse();

// Forward Declaration - Data Structures
class symtype;     // Type of a symbol in symbol table
class quad;        // Individual quads
class quadArray;   // List of quads
class sym;         // Entry in a symbol table
class symboltable; // Symbol Table

// Global variables used in the translator file
extern symboltable *table;       // Current Symbol Table
extern symboltable *globalTable; // Global Symbbol Table
extern quadArray q;              // Array of Quads
extern sym *currentSymbol;       // Pointer to just encountered symbol

///////////////////////////////////////Class definitions, non terminal type strucure and attributes and global functions
// Type of symbols in symbol table
class symtype
{
public:
    symtype(string type, symtype *ptr = NULL, int width = 1);
    string type;
    int width;    // Width of array
    symtype *ptr; // Pointers and Multi-dimensional Arrays
};

// Quad Class
class quad
{
public:
    string op;     // Operator
    string result; // Result
    string arg1;   // Argument 1
    string arg2;   // Argument 2

    void print(); // Print Quad

    // Overloaded Constructors
    quad(string result, string arg1, string op = "EQUAL", string arg2 = ""); 
    quad(string result, int arg1, string op = "EQUAL", string arg2 = "");    
    quad(string result, float arg1, string op = "EQUAL", string arg2 = "");  
};

// Array of quads
class quadArray
{ 
public:
    vector<quad> quadVect; // Vector of quads
    void print();       // Print the quads in the list
};

// Symbols class
class sym
{ 
public:
    string name;          // Name of the symbol
    symtype *type;        // Type of the Symbol
    string initial_value; // Initial Values (if any)
    int size;             // Size of the symbol
    int offset;           // Offset of symbol
    symboltable *nested;  // Pointer to nested symbol table

    sym(string name, string t = "INTEGER", symtype *ptr = NULL, int width = 0); //constructor declaration
    sym *update(symtype *t);                                                    // A method to update different fields of an existing entry.
    sym *link_to_symbolTable(symboltable *t);
};

class symboltable
{ // Symbol Table class
public:
    string name;         // Name of Table
    int count;           // Count of temporary variables
    list<sym> table;     // The table of symbols
    symboltable *parent; // Immediate parent of the symbol table

    symboltable(string name = "NULL");
    sym *lookup(string name); // Lookup for a symbol in symbol table
    void print();             // Print the symbol table
    void update();            // Update offset of the complete symbol table
};

//Attributes for statements
struct statement
{
    list<int> nextlist; // Nextlist for statement
};

//Attributes for array
struct Array
{
    string cat;
    sym *loc;      // Temporary used for computing array address
    sym *STptr;    // Pointer to symbol table
    symtype *type; // type of the subarray generated
};

//Attributes for expressions
struct expr
{
    string type; //to store whether the expression is of type int or bool

    // Valid for non-bool type
    sym *loc; // Pointer to the symbol table entry

    // Valid for bool type
    list<int> truelist;  // Truelist valid for boolean
    list<int> falselist; // Falselist valid for boolean expressions

    // Valid for statement expression
    list<int> nextlist;
};

//Global functions required for translation process

// Emits for adding quads to the quadArray
void emit(string op, string result, string arg1 = "", string arg2 = "");
void emit(string op, string result, int arg1, string arg2 = "");   // (arg1 is int)
void emit(string op, string result, float arg1, string arg2 = ""); // (arg1 is float)

sym *conv(sym *, string);                 // TAC for Type conversion in program
bool typecheck(sym* &s1, sym* &s2);       // Checks if two symbols have same type
bool typecheck(symtype* t1, symtype* t2); //checks if two symtype objects have same type

void backpatch(list<int> lst, int i);
list<int> makelist(int i);                         // Make a new list containing an integer
list<int> merge(list<int> &lst1, list<int> &lst2); // Merge two lists into a single list

expr *convertInt2Bool(expr *); // convert any expression (int) to bool
expr *convertBool2Int(expr *); // convert bool to expression (int)

void changeTable(symboltable *newtable); //for changing the current sybol table
int nextinstr();                         // Returns the next instruction number

sym *gentemp(symtype *t, string init = ""); // Generate a temporary variable and insert it in current symbol table

int size_type(symtype *);     // Calculate size of any symbol type
string print_type(symtype *); // For printing type of symbol recursive printing of type

#endif