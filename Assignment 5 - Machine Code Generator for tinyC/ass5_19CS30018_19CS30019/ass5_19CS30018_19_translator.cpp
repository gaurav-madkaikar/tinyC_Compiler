#include "ass5_19CS30018_19_translator.h"
using namespace std;

symboltable *globalTable;
quadArray q;
string Type;
symboltable *table;
sym *currentSymbol;

// Functions for class quad
// Overloaded constructors for quad
quad::quad(string s, string s1, string s3, string s2)
{
    this->result = s;
    this->arg1 = s1;
    this->arg2 = s2;
    this->op = s3;
}

quad::quad(string s, int arg1, string s3, string s2)
{
    this->result = s;
    this->arg2 = s2;
    this->op = s3;
    stringstream strs;
    strs << arg1;
    string intStr = strs.str();
    this->arg1 = intStr;
}

quad::quad(string s, float arg1, string s3, string s2)
{
    this->result = s;
    this->arg2 = s2;
    this->op = s3;
    std::ostringstream buff;
    buff << arg1;
    this->arg1 = buff.str();
}
// Print the quads
void quad::print()
{
    if (op == "ADD")
        cout << result << " = " << arg1 << " + " << arg2;
    else if (op == "SUB")
        cout << result << " = " << arg1 << " - " << arg2;
    else if (op == "MULT")
        cout << result << " = " << arg1 << " * " << arg2;
    else if (op == "DIVIDE")
        cout << result << " = " << arg1 << " / " << arg2;
    else if (op == "LEFTOP")
        cout << result << " = " << arg1 << " << " << arg2;
    else if (op == "RIGHTOP")
        cout << result << " = " << arg1 << " >> " << arg2;
    else if (op == "EQUAL")
        cout << result << " = " << arg1;
    else if (op == "XORLQ")
        cout << result << " = " << arg1 << "^=" << arg2;
    else if (op == "EQOP")
        cout << "if " << arg1 << " == " << arg2 << " goto " << result;
    else if (op == "NEOP")
        cout << "if " << arg1 << " != " << arg2 << " goto " << result;
    else if (op == "LT")
        cout << "if " << arg1 << " < " << arg2 << " goto " << result;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "MODOP")
        cout << result << " = " << arg1 << " % " << arg2;
    else if (op == "XOR")
        cout << result << " = " << arg1 << " ^ " << arg2;
    else if (op == "INOR")
        cout << result << " = " << arg1 << " | " << arg2;
    else if (op == "BAND")
        cout << result << " = " << arg1 << " & " << arg2;
    else if (op == "EQOP")
        cout << "if " << arg1 << " == " << arg2 << " goto " << result;
    else if (op == "NEOP")
        cout << "if " << arg1 << " != " << arg2 << " goto " << result;
    else if (op == "LT")
        cout << "if " << arg1 << " < " << arg2 << " goto " << result;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "JUMPTO")
        cout << result << " = " << arg1 << "-->" << arg2;
    else if (op == "ADDRESS")
        cout << result << " = &" << arg1;
    else if (op == "PTRR")
        cout << result << " = *" << arg1;
    else if (op == "PTRL")
        cout << "*" << result << " = " << arg1;
    else if (op == "UMINUS")
        cout << result << " = -" << arg1;
    else if (op == "BNOT")
        cout << result << " = ~" << arg1;
    else if (op == "LNOT")
        cout << result << " = !" << arg1;
    else if (op == "SWITCH")
        cout << result << " = " << arg1 << "rand" << arg2;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "CASE")
        cout << result << " = " << arg1 << "rand" << arg2;
    else if (op == "ADDRESS")
        cout << result << " = &" << arg1;
    else if (op == "PTRR")
        cout << result << " = *" << arg1;
    else if (op == "PTRL")
        cout << "*" << result << " = " << arg1;
    else if (op == "UMINUS")
        cout << result << " = -" << arg1;
    else if (op == "BNOT")
        cout << result << " = ~" << arg1;
    else if (op == "LNOT")
        cout << result << " = !" << arg1;
    else if (op == "SHUFF")
        cout << result << " = " << arg1 << "\\" << arg2;
    else if (op == "MODOP")
        cout << result << " = " << arg1 << " % " << arg2;
    else if (op == "XOR")
        cout << result << " = " << arg1 << " ^ " << arg2;
    else if (op == "INOR")
        cout << result << " = " << arg1 << " | " << arg2;
    else if (op == "BAND")
        cout << result << " = " << arg1 << " & " << arg2;
    else if (op == "EQOP")
        cout << "if " << arg1 << " == " << arg2 << " goto " << result;
    else if (op == "NEOP")
        cout << "if " << arg1 << " != " << arg2 << " goto " << result;
    else if (op == "LT")
        cout << "if " << arg1 << " < " << arg2 << " goto " << result;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "RANDOM")
        cout << result << " = " << arg1 << "rand" << arg2;
    else if (op == "LEFTOP")
        cout << result << " = " << arg1 << " << " << arg2;
    else if (op == "RIGHTOP")
        cout << result << " = " << arg1 << " >> " << arg2;
    else if (op == "EQUAL")
        cout << result << " = " << arg1;
    else if (op == "EQOP")
        cout << "if " << arg1 << " == " << arg2 << " goto " << result;
    else if (op == "NEOP")
        cout << "if " << arg1 << " != " << arg2 << " goto " << result;
    else if (op == "LT")
        cout << "if " << arg1 << " < " << arg2 << " goto " << result;
    else if (op == "GT")
        cout << "if " << arg1 << " > " << arg2 << " goto " << result;
    else if (op == "GE")
        cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
    else if (op == "LE")
        cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
    else if (op == "GOTOOP")
        cout << "goto " << result;
    else if (op == "PLLRL")
        cout << result << " = " << arg1 << "//" << arg2;
    else if (op == "ADDRESS")
        cout << result << " = &" << arg1;
    else if (op == "PTRR")
        cout << result << " = *" << arg1;
    else if (op == "PTRL")
        cout << "*" << result << " = " << arg1;
    else if (op == "UMINUS")
        cout << result << " = -" << arg1;
    else if (op == "BNOT")
        cout << result << " = ~" << arg1;
    else if (op == "LNOT")
        cout << result << " = !" << arg1;
    else if (op == "ANDL")
        cout << result << " = " << arg1 << "and" << arg2;
    else if (op == "ARRR")
        cout << result << " = " << arg1 << "[" << arg2 << "]";
    else if (op == "ARRL")
        cout << result << "[" << arg1 << "]"
             << " = " << arg2;
    else if (op == "RETURN")
        cout << "ret " << result;
    else if (op == "PARAM")
        cout << "param " << result;
    else if (op == "CALL")
        cout << result << " = "
             << "call " << arg1 << ", " << arg2;
    else if (op == "LABEL")
        cout << result << ": ";
    else
        cout << "op";
    cout << endl;
}
// Print list of quads for each symbol table
void quadArray::print()
{
    cout << setw(130) << setfill('=') << "=" << endl;
    cout << "Important Points: " << endl;
    cout << "1. A function name may be declared twice\n indicating the function involves a prototype declaration along with its definition" << endl;
    cout << "2. 'param' indicates that the next variable is passed as a parameter to function" << endl;
    cout << "3. The entry in the symbol table named as 'return' corresponds to the return type\n of that function." << endl;
    cout << setw(130) << setfill('=') << "=" << endl
         << endl;
    
    cout << setw(130) << setfill('-') << "-" << endl;
    cout << "Three Adress Codes (TAC)" << endl;
    cout << setw(130) << setfill('-') << "-" << setfill(' ') << endl;
    for (vector<quad>::iterator it = quadVect.begin(); it != quadVect.end(); it++)
    {
        if (it->op != "LABEL")
        {
            cout << "\t" << setw(4) << it - quadVect.begin() << ":\t";
            it->print();
        }
        else
        {
            cout << endl;
            it->print();
        }
    }
    cout << setw(130) << setfill('-') << "-" << endl;
}
// Store the details of the variable
symtype::symtype(string type, symtype *ptr, int width)
{
    this->type = type;
    this->ptr = ptr;
    this->width = width;
}

sym::sym(string n, string t, symtype *p, int w) : name(n)
{
    type = new symtype(t, p, w);
    nested = NULL;
    initial_value = "-";
    offset = 0;
    size = size_type(type);
}

sym *sym::update(symtype *t)
{
    type = t;
    this->size = size_type(t);
    return this;
}

// Functions for the symbol table
symboltable::symboltable(string n)
{
    this->name = n;
    this->count = 0;
}

void symboltable::print()
{
    list<symboltable *> tablelist;
    cout << setw(130) << setfill('_') << "_" << endl;
    cout << "Symbol Table: " << setfill(' ') << left << setw(50) << this->name;
    cout << right << setw(25) << "Parent: ";
    
    if (this->parent != NULL)
        cout << this->parent->name;
    else
        cout << "NULL";
    cout << endl;
    cout << setw(130) << setfill('_') << "_" << endl;
    cout << setfill(' ') << left << setw(20) << "Name";
    cout << left << setw(25) << "Type";
    cout << left << setw(20) << "Initial Value";
    cout << left << setw(12) << "Size";
    cout << left << setw(12) << "Offset";
    cout << left << "Nested" << endl;
    cout << setw(130) << setfill('-') << "-" << setfill(' ') << endl;
    
    for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
    {
        cout << left << setw(20) << it->name;
        string stype = print_type(it->type);
        cout << left << setw(25) << stype;
        cout << left << setw(20) << it->initial_value;
        cout << left << setw(12) << it->size;
        cout << left << setw(12) << it->offset;
        cout << left;
        
        if (it->nested == NULL)
            cout << "NULL" << endl;
        
        else
        {
            cout << it->nested->name << endl;
            tablelist.push_back(it->nested);
        }
    }
    cout << setw(130) << setfill('_') << "_" << setfill(' ') << endl;
    cout << endl;
    for (list<symboltable *>::iterator iterator = tablelist.begin(); iterator != tablelist.end(); ++iterator)
    {
        (*iterator)->print();
    }
}
// Update information of the symbol
void symboltable::update()
{
    list<symboltable *> tablelist;
    int off;
    for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
    {
        if (it == table.begin())
        {
            it->offset = 0;
            off = it->size;
        }
        else
        {
            it->offset = off;
            off = it->offset + it->size;
        }
        if (it->nested != NULL)
            tablelist.push_back(it->nested);
    }
    for (list<symboltable *>::iterator iterator = tablelist.begin(); iterator != tablelist.end(); ++iterator)
    {
        (*iterator)->update();
    }
}
// Lookup for a varible in the symbol table
sym *symboltable::lookup(string name)
{
    sym *s;
    list<sym>::iterator it;
    for (it = table.begin(); it != table.end(); it++)
    {
        if (it->name == name)
            break;
    }
    if (it != table.end())
    {
        return &(*it);
    }
    else
    {
        s = new sym(name);
        table.push_back(*s);
        return &table.back();
    }
}
// Overloaded functions for emitting the quads
void emit(string op, string result, string arg1, string arg2)
{
    q.quadVect.push_back(*(new quad(result, arg1, op, arg2)));
}
void emit(string op, string result, int arg1, string arg2)
{
    q.quadVect.push_back(*(new quad(result, arg1, op, arg2)));
}
void emit(string op, string result, float arg1, string arg2)
{
    q.quadVect.push_back(*(new quad(result, arg1, op, arg2)));
}
// Intermediary type conversions
sym *conv(sym *s, string t)
{
    sym *temp = gentemp(new symtype(t));
    if (s->type->type == "INTEGER")
    {
        if (t == "FLOAT")
        {
            emit("EQUAL", temp->name, "int2float(" + s->name + ")");
            return temp;
        }
        else if (t == "CHAR")
        {
            emit("EQUAL", temp->name, "int2char(" + s->name + ")");
            return temp;
        }
        return s;
    }
    else if (s->type->type == "FLOAT")
    {
        if (t == "INTEGER")
        {
            emit("EQUAL", temp->name, "float2int(" + s->name + ")");
            return temp;
        }
        else if (t == "CHAR")
        {
            emit("EQUAL", temp->name, "float2char(" + s->name + ")");
            return temp;
        }
        return s;
    }
    else if (s->type->type == "CHAR")
    {
        if (t == "INTEGER")
        {
            emit("EQUAL", temp->name, "char2int(" + s->name + ")");
            return temp;
        }
        if (t == "FLOAT")
        {
            emit("EQUAL", temp->name, "char2float(" + s->name + ")");
            return temp;
        }
        return s;
    }
    return s;
}
// Type check
bool typecheck(sym *&s1, sym *&s2)
{
    symtype *type1 = s1->type;
    symtype *type2 = s2->type;
    
    if (typecheck(type1, type2))
        return true;
    else if (s1 = conv(s1, type2->type))
        return true;
    else if (s2 = conv(s2, type1->type))
        return true;
    else
        return false;
}

bool typecheck(symtype *t1, symtype *t2)
{
    if (t1 != NULL || t2 != NULL)
    {
        if (t1 == NULL)
            return false;
        if (t2 == NULL)
            return false;
        if (t1->type == t2->type)
            return typecheck(t1->ptr, t2->ptr);
        else
            return false;
    }
    return true;
}

void backpatch(list<int> l, int addr)
{
    stringstream strs;
    strs << addr;
    string temp_str = strs.str();
    char *intStr = (char *)temp_str.c_str();
    string str = string(intStr);
    for (list<int>::iterator it = l.begin(); it != l.end(); it++)
    {
        q.quadVect[*it].result = str;
    }
}

list<int> makelist(int i)
{
    list<int> ls(1, i);
    return ls;
}
list<int> merge(list<int> &a, list<int> &b)
{
    a.merge(b);
    return a;
}
// Expression Interconversions
expr *convertInt2Bool(expr *Expr)
{
    if (Expr->type != "BOOL")
    {
        Expr->falselist = makelist(nextinstr());
        emit("EQOP", "", Expr->loc->name, "0");
        Expr->truelist = makelist(nextinstr());
        emit("GOTOOP", "");
    }
    return Expr;
}
expr *convertBool2Int(expr *Expr)
{
    if (Expr->type == "BOOL")
    {
        Expr->loc = gentemp(new symtype("INTEGER"));
        backpatch(Expr->truelist, nextinstr());
        emit("EQUAL", Expr->loc->name, "true");
        stringstream strs;
        strs << nextinstr() + 1;
        string intStr = strs.str();
        
        emit("GOTOOP", intStr);
        backpatch(Expr->falselist, nextinstr());
        emit("EQUAL", Expr->loc->name, "false");
    }
    return Expr;
}

void changeTable(symboltable *newtable)
{
    table = newtable;
}

int nextinstr()
{
    return q.quadVect.size();
}
// Generate temporary
sym *gentemp(symtype *t, string init)
{
    char str[10];
    sprintf(str, "t%02d", table->count++);
    sym *s = new sym(str);
    s->type = t;
    s->size = size_type(t);
    
    s->initial_value = init;
    table->table.push_back(*s);
    return &table->table.back();
}

int size_type(symtype *t)
{
    if (t->type == "VOID")
        return 0;
    else if (t->type == "CHAR")
        return CHAR_SIZE;
    else if (t->type == "INTEGER")
        return INT_SIZE;
    else if (t->type == "FLOAT")
        return FLOAT_SIZE;
    else if (t->type == "PTR")
        return POINTER_SIZE;

    else if (t->type == "ARR")
        return t->width * size_type(t->ptr);

    // Return 0 if it is a function
    return 0;
}
// Print the associated variable-type
string print_type(symtype *t)
{
    if (t == NULL)
        return "NULL";
    if (t->type == "VOID")
        return "void";
    else if (t->type == "CHAR")
        return "char";
    else if (t->type == "INTEGER")
        return "integer";
    else if (t->type == "FLOAT")
        return "float";
    else if (t->type == "PTR")
        return "ptr(" + print_type(t->ptr) + ")";
    else if (t->type == "ARR")
    {
        stringstream strs;
        strs << t->width;
        string temp_str = strs.str();
        char *intStr = (char *)temp_str.c_str();
        string str = string(intStr);
        return "arr(" + str + ", " + print_type(t->ptr) + ")";
    }
    else if (t->type == "FUNC")
        return "function";
    else
        return "_";
}

// Main function
int main(int argc, char *argv[])
{
    // Call the global symbol table
    globalTable = new symboltable("Global");
    table = globalTable;
    
    yyparse();
    
    globalTable->update();
    q.print();
    globalTable->print();
};