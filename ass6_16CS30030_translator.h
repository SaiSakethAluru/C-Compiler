#ifndef TRANSLATE_H
#define TRANSLATE_H
#include <vector>
#include <algorithm>
#include <bits/stdc++.h>
#include <iostream>

#define CHAR_SIZE 		    1
#define INT_SIZE  		    4
#define FLOAT_SIZE		    8
#define POINTER_SIZE		4

extern  char* yytext;
extern  int yyparse();

using namespace std;


////////////////////////////////////Forward class declarations to avoid conflicts
class symboltype;					// Type of a symbol in symbol table
class quad;						// Entry in quad array
class quadArray;				// QuadArray
class symbol;						// Entry in a symbol table
class symboltable;					// Symbol Table


//////////////////////////////////////global variables used in the translator.cxx file are declared here
extern symboltable* table;						// Current Symbbol Table
extern symboltable* globalTable;				// Global Symbbol Table
extern quadArray q;							// Array of Quads
extern symbol* currentSymbol;					// Pointer to just encountered symbol
extern int temp_count;

///////////////////////////////////////Class definitions, non terminal type strucure and attributes and global functions
class symboltype { // Type of symbols in symbol table
public:
	symboltype(string type, symboltype* ptr = NULL, int width = 1);
	string type;
	int width;					// Size of array (in case of arrays)
	symboltype* ptr;				// for 2d arrays and pointers
};

class quad { // Quad Class
public:
	string op;					// Operator
	string result;				// Result
	string arg1;				// Argument 1
	string arg2;				// Argument 2

	void print ();								// Print Quad
	quad (string result, string arg1, string op = "EQUAL", string arg2 = "");			//constructor with string arg1
	quad (string result, int arg1, string op = "EQUAL", string arg2 = "");				//constructors with int arg1
	quad (string result, float arg1, string op = "EQUAL", string arg2 = "");			//constructors with float arg1
};

class quadArray { // Array of quads
public:
	vector <quad> array;		                // Vector of quads
	void print ();								// Print the quadArray
};

class symbol { // Symbols class
public:
	string name;				// Name of the symbol
	symboltype *type;				// Type of the Symbol
	string initial_value;		// Symbol initial valus (if any)
	string category;
	int size;					// Size of the symbol
	int offset;					// Offset of symbol
	symboltable* nested;				// Pointer to nested symbol table

	symbol (string name, string t="INTEGER", symboltype* ptr = NULL, int width = 0); //constructor declaration
	symbol* update(symboltype * t); 	// A method to update different fields of an existing entry.
	symbol* link_to_symbolTable(symboltable* t);
};

class symboltable { // Symbol Table class
public:
	string name;				// Name of Table
	int count;					// Count of temporary variables
	list<symbol> table; 			// The table of symbols
	symboltable* parent;				// Immediate parent of the symbol table
	map<string, int> activation_record;
	symboltable (string name="NULL");
	symbol* lookup (string name);								// Lookup for a symbol in symbol table
	void print();					            			// Print the symbol table
	void update();						        			// Update offset of the complete symbol table
};


/////////////////////////////////////////Attributes and their explanation for different non terminal type
//Attributes for statements
struct statement {
	list<int> nextlist;				// Nextlist for statement
};

//Attributes for array
struct array {
	string cat;
	symbol* loc;					// Temporary used for computing array address
	symbol* array;					// Pointer to symbol table
	symboltype* type;				// type of the subarray generated
};


//Attributes for expressions
struct expr {
	string type; 							//to store whether the expression is of type int or bool

	// Valid for non-bool type
	symbol* loc;								// Pointer to the symbol table entry

	// Valid for bool type
	list<int> truelist;						// Truelist valid for boolean
	list<int> falselist;					// Falselist valid for boolean expressions

	// Valid for statement expression
	list<int> nextlist;
};

//////////////////////////////////////////Global functions required for the translator
void emit(string op, string result, string arg1="", string arg2 = "");    //emits for adding quads to quadArray
void emit(string op, string result, int arg1, string arg2 = "");		  //emits for adding quads to quadArray (arg1 is int)
void emit(string op, string result, float arg1, string arg2 = "");        //emits for adding quads to quadArray (arg1 is float)


symbol* convert (symbol*, string);							// TAC for Type conversion in program
bool typecheck(symbol* &s1, symbol* &s2);					// Checks if two symbols have same type
bool typecheck(symboltype* t1, symboltype* t2);			//checks if two symtype objects have same type


void backpatch (list <int> lst, int i);			// A global function to insert i as the target label for each of the quad's on the list pointed by lst.
list<int> makelist (int i);							        // Make a new list contaninig an integer
list<int> merge (list<int> &lst1, list <int> &lst2);		// Merge two lists into a single list

expr* convertInt2Bool (expr*);				// convert any expression (int) to bool
expr* convertBool2Int (expr*);				// convert bool to expression (int)

void changeTable (symboltable* newtable);               //for changing the current sybol table
int nextinstr();									// Returns the next instruction number

symbol* gentemp (symboltype* t, string init = "");		// Generate a temporary variable and insert it in current symbol table

int size_type (symboltype*);							// Calculate size of any symbol type 
string print_type(symboltype*);						// For printing type of symbol recursive printing of type

#endif