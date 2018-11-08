#include "ass6_16CS30030_translator.h"
#include <sstream>

using namespace std;

//reference to global variables declared in header file 
symboltable* globalTable;				// Global Symbbol Table
quadArray q;							// Quad Array
string Type;							// Stores latest type
symboltable* table;						// Points to current symbol table
symbol* currentSymbol; 					// points to current symbol
int temp_count = 0;

string getNewStringInstance()
{
	return string();
}
// constructor for symbol table instance
symboltype::symboltype(string type, symboltype* ptr, int width): 
	type (type), 
	ptr (ptr), 
	width (width) {}

// constructor for quad class instance with arg1 string
quad::quad (string result, string arg1, string op, string arg2):
	result (result), arg1(arg1), arg2(arg2), op (op){}

// constructor for quad class instance with arg1 int
quad::quad (string result, int arg1, string op, string arg2):
	result (result), arg2(arg2), op (op) {
		ostringstream strs;				// use stringstream to convert int to string
	    strs << arg1;
		string str = strs.str();
		this->arg1 = str;
	}

// contructor for quad class with float type arg1
quad::quad (string result, float arg1, string op, string arg2):
	result (result), arg2(arg2), op (op) {
		stringstream buff;			// using stringstream to convert float to string
   		buff<<arg1;
   		string str = buff.str();
   		char* floatStr = (char*) str.c_str();
   		string parsed_str = string(floatStr);
		this->arg1 = parsed_str;
	}

// function to print quads
void quad::print () {
	// Binary Operations
	// cout<<"op = "<<op<<"\t";
	if (op=="ADD")					cout << result << " = " << arg1 << " + " << arg2;
	else if (op=="SUB")				cout << result << " = " << arg1 << " - " << arg2;
	else if (op=="MULT")			cout << result << " = " << arg1 << " * " << arg2;
	else if (op=="DIVIDE")			cout << result << " = " << arg1 << " / " << arg2;
	else if (op=="MODOP")			cout << result << " = " << arg1 << " % " << arg2;
	else if (op=="XOR")				cout << result << " = " << arg1 << " ^ " << arg2;
	else if (op=="INOR")			cout << result << " = " << arg1 << " | " << arg2;
	else if (op=="BAND")			cout << result << " = " << arg1 << " & " << arg2;
	// Shift Operations
	else if (op=="LEFTOP")			cout << result << " = " << arg1 << " << " << arg2;
	else if (op=="RIGHTOP")			cout << result << " = " << arg1 << " >> " << arg2;
	else if (op=="EQUAL")			cout << result << " = " << arg1 ;								
	// Relational Operations
	else if (op=="EQOP")			cout << "if " << arg1 <<  " == " << arg2 << " goto " << result;
	else if (op=="NEOP")			cout << "if " << arg1 <<  " != " << arg2 << " goto " << result;
	else if (op=="LT")				cout << "if " << arg1 <<  " < "  << arg2 << " goto " << result;
	else if (op=="GT")				cout << "if " << arg1 <<  " > "  << arg2 << " goto " << result;
	else if (op=="GE")				cout << "if " << arg1 <<  " >= " << arg2 << " goto " << result;
	else if (op=="LE")				cout << "if " << arg1 <<  " <= " << arg2 << " goto " << result;
	else if (op=="GOTOOP")			cout << "goto " << result;		
	//Unary Operators
	else if (op=="ADDRESS")			cout << result << " = &" << arg1;
	else if (op=="PTRR")			cout << result	<< " = *" << arg1 ;
	else if (op=="PTRL")			cout << "*" << result	<< " = " << arg1 ;
	else if (op=="UMINUS")			cout << result 	<< " = -" << arg1;
	else if (op=="BNOT")			cout << result 	<< " = ~" << arg1;
	else if (op=="LNOT")			cout << result 	<< " = !" << arg1;

	else if (op=="ARRR")	 		cout << result << " = " << arg1 << "[" << arg2 << "]";
	else if (op=="ARRL")	 		cout << result << "[" << arg1 << "]" <<" = " <<  arg2;
	else if (op=="RETURN") 			cout << "return " << result;
	else if (op=="PARAM") 			cout << "param " << result;
	else if (op=="CALL") 			cout << result << " = " << "call " << arg1<< ", " << arg2;
	else if (op=="FUNC") 			cout << result << ": ";
	else if (op=="FUNCEND") 		cout << "";
	else			{}				//cout << "\n";			
	cout << endl;
}

// function to print all quads stored in quadArray
void quadArray::print() {
	cout<<"==============================\n";
	cout << "Three address code translation\n";
	cout<<"------------------------------\n";
	stringstream buffer;
	// loop over all quads in quadArray
	vector<quad>::iterator it = array.begin();
	while(it!=array.end()){
		// switch(int(it->op != "LABEL")){
		// 	// if the operation is not a label, print TAC as result op arg1 arg2
		// 	case 1: 
		// 	buffer << "\t" << setw(4) << it - array.begin() << ":\t";
		// 	cout<<buffer.str();
		// 	buffer.str(getNewStringInstance());
		// 	it->print();
		// 	break;
		// 	// if the quad is a label, print just the name of the label.
		// 	default:
		// 	buffer << "\n";
		// 	cout<<buffer.str();
		// 	buffer.str(getNewStringInstance());
		// 	it->print();
		// 	buffer << "\n";
		// 	cout<<buffer.str();
		// 	buffer.str(getNewStringInstance());
		// }
		if(it->op == "FUNC"){
			cout<<"\n";
			it->print();
			cout<<"\n";
		}
		else if(it->op == "FUNCEND") {}
		else{
			cout<<"\t"<<setw(4)<< it - array.begin() <<":\t";
			it->print();
		}
		it++;
	}
	buffer << setw(30) << setfill ('-') << "-"<< "\n";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
}

// constructor for one row of symbol table entry
symbol::symbol (string name, string t, symboltype* ptr, int width): name(name)  {
	type = new symboltype (t, ptr, width);
	nested = NULL;
	initial_value = "null";
	category = "base";
	offset = 0;
	size = size_type(type);
}
// function to update type of entry in symbol table and return pointer to updated value
symbol* symbol::update(symboltype* t) {
	type = t;
	this -> size = size_type(t);
	return this;
}

// constructor for symbol table class with name of the table and initial count of entries in table = 0
symboltable::symboltable (string name): name (name), count(0) {}

// Function to print symbol table entries
void symboltable::print() {
	list<symboltable*> tablelist;
	cout<<"===================================================================================================================\n";
	// print name of the symbol table.
	stringstream buffer;
	buffer << "Symbol Table: " << setfill (' ') << left << setw(50)  << this -> name ;
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	// print name of parent symbol table if exists.
	buffer << right << setw(25) << "Parent: ";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	if (this->parent!=NULL)
		cout << this -> parent->name;
	else cout << "null" ;
	cout << "\n";
	// buffer << setw(100) << setfill ('-') << "-"<< "\n";
	buffer<< "-------------------------------------------------------------------------------------------------------------------\n";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << setfill (' ') << left << setw(20) << "Name";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << setw(15) << "Type";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << setw(20) << "Category";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << setw(20) << "Initial Value";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << setw(12) << "Size";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << setw(12) << "Offset";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << left << "Nested" << "\n";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	buffer << setw(115) << setfill ('-') << "-"<< setfill (' ') << "\n";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	// loop over list of all symbol table entries.
	list<symbol>::iterator it = table.begin();
	// for (list <symbol>::iterator it = table.begin(); it!=table.end(); it++) {
	while(it!=table.end()){
		buffer << left << setw(20) << it->name;			// name of variable
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		string stype = print_type(it->type);	 		// data type
		buffer << left << setw(20) << stype; 				
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		buffer<< left << setw(20) << it->category;
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		buffer << left << setw(15) << it->initial_value; 	// initial value of variable if any
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		buffer << left << setw(15) << it->size; 			// size of variable
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		buffer << left << setw(10) << it->offset; 		// offset
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		buffer << left;
		cout<<buffer.str();
		buffer.str(getNewStringInstance());
		if (it->nested == NULL) {
			buffer << "null" <<  "\n";	
			cout<<buffer.str();
			buffer.str(getNewStringInstance());
		}
		else {
			buffer << "ptr-to-ST("<<it->nested->name <<")"<<"\n"; 			// print if there is any associated nested symbol table
			cout<<buffer.str();
			buffer.str(getNewStringInstance());
			tablelist.push_back (it->nested);			// add the pointer of nested table to a list to print them later.
		}
		it++;
	}
	buffer << setw(115) << setfill ('-') << "-"<< setfill (' ') << "\n";
	cout<<buffer.str();
	buffer.str(getNewStringInstance());
	cout << "\n";
	list<symboltable*>::iterator iterator = tablelist.begin();
	// for (list<symboltable*>::iterator iterator = tablelist.begin();
			// iterator != tablelist.end(); 					
			// ++iterator) 
	while(iterator!=tablelist.end()){

    	(*iterator)->print(); 						// if any nested tables are there, print them also.
    	iterator++;
	}		
}

// update entry in symbol table.
void symboltable::update() {
	list<symboltable*> tablelist;
	int off; 			// offset for each entry
	list<symbol>::iterator it = table.begin();
	while(it!=table.end()){
		if (it==table.begin()) { 		// initialise offset = 0 and assign to first element
			it->offset = 0;
			off = it->size;
		}
		else { 			// assign current offset to entry, update offset
			it->offset = off;
			off = it->offset + it->size;
		}
		if (it->nested!=NULL) tablelist.push_back (it->nested); 		// if there is a nested symbol table, add pointer to nested table
		it++;
	}
	list<symboltable*>::iterator iterator = tablelist.begin();
	while(iterator!=tablelist.end()){
	    (*iterator)->update(); 				// call update for all included symbol tables
		iterator++;
	}
}

/*
 * Function for lookup in symbol table based on name of symbol.
 */ 
symbol* symboltable::lookup (string name) {
	symbol* s;
	list <symbol>::iterator it = table.begin();
	while (it!=table.end()) { 		// loop over entries in table.
		if (it->name == name ) break;
		it++;						
	}
	if (it!=table.end() ) {	 					// if entry found return pointer to that entry
		return &*it;
	}
	else { 		
		//else new symbol to be added to table
		s =  new symbol (name);
		s->category = "local";
		table.push_back (*s);
		return &table.back();
		}
}

// create new quad and store in the quadArray for lazy spitting. 
// each function corresponds to different types of arg1 parameter.
void emit(string op, string result, string arg1, string arg2) {
	quad* new_quad = new quad(result,arg1,op,arg2);
	q.array.push_back(*new_quad);
}
void emit(string op, string result, int arg1, string arg2) {
	quad* new_quad = new quad(result,arg1,op,arg2);
	q.array.push_back(*new_quad);
}
void emit(string op, string result, float arg1, string arg2) {
	quad*  new_quad = new quad(result,arg1,op,arg2);
	q.array.push_back(*new_quad);
}

/*
 * Function to convert symbol s to type t
 * This is called from typecheck function - hence it is assumed that conversion is possible
 */
symbol* convert (symbol* s, string t) {
	symbol* temp = gentemp(new symboltype(t));
	if (strcmp((s->type->type).c_str(),"INTEGER")==0) { 	// given int
		if (strcmp(t.c_str(),"FLOAT")==0) { 	// convert int to float
			emit ("EQUAL", temp->name, "int2float(" + s->name + ")");
			return temp;
		}
		else if (strcmp(t.c_str(),"CHAR")==0) {	// convert int to char
			emit ("EQUAL", temp->name, "int2char(" + s->name + ")");
			return temp;
		}
		return s;
	}
	else if (strcmp((s->type->type).c_str(),"FLOAT") == 0) { 		// given float
		if (strcmp(t.c_str(),"INTEGER")==0) { 	// convert float to integer
			emit ("EQUAL", temp->name, "float2int(" + s->name + ")");
			return temp;
		}
		else if (strcmp(t.c_str(),"CHAR")==0) { 	// convert float to char
			emit ("EQUAL", temp->name, "float2char(" + s->name + ")");
			return temp;
		}
		return s;
	}
	else if (strcmp((s->type->type).c_str(),"CHAR") == 0) { 	// given char
		if (strcmp(t.c_str(),"INT")==0) {		// covert char to integer
				emit ("EQUAL", temp->name, "char2int(" + s->name + ")");
				return temp;
			}
		if (strcmp(t.c_str(),"FLOAT")==0) { 		// convert char to float
				emit ("EQUAL", temp->name, "char2float(" + s->name + ")");
				return temp;
			}
		return s;
	}
	return s;
}

/* 
 * Function to check if two symbol types are same or interconvertable
 */
bool typecheck(symbol*& s1, symbol*& s2){
	symboltype* type1 = s1->type;
	symboltype* type2 = s2->type;
	if ( typecheck (type1, type2) ) return true;
	else if (s1 = convert (s1, type2->type) ) return true;
	else if (s2 = convert (s2, type1->type) ) return true;
	else return false;
}

/* 
 * Function to check if two pointer type symbol entries are same.
 */
bool typecheck(symboltype* t1, symboltype* t2){ 	
	if(t1==NULL && t2 == NULL){
		return true;
	}
	else if(t1 != NULL && t2 == NULL){
		return false;
	}
	else if(t1==NULL && t2 != NULL){
		return true;
	}
	else{
		return (t1->type==t2->type)? typecheck(t1->ptr,t2->ptr):false;
	}
}

/*
 * Function that takes as input a list of instruction addresses and a label address 
 * All the blank goto addresses in the parameter l are backpatched with the address addr. 
 */
void backpatch (list <int> l, int addr) {
	stringstream strs;
    strs << addr;
    string str = strs.str();
    list<int>::iterator it = l.begin();
    while(it!=l.end()){
		q.array[*it].result = str;
    	it++;
    }
}

/* 
 * Takes as input an integer i and return a list containing a single element i.
 * The function is implemented by making use of builtin data structures from STL library of C++
 */
list<int> makelist (int i) {
	list<int> l(1,i);
	return l;
}

/* 
 * Takes two lists and return a merged list of both the inputs.
 * The function is implemented by making use of builtin data structures from STL library of C++
 */
list<int> merge (list<int> &a, list <int> &b) {
	a.merge(b);
	return a;
}

expr* convertInt2Bool (expr* e) {	// Convert any integer expression to boolean expression
	switch (int(e->type!="BOOL")) {
		case 1:
			e->falselist = makelist (nextinstr());
			emit ("EQOP", "", e->loc->name, "0");
			e->truelist = makelist (nextinstr());
			emit ("GOTOOP", "");
			break;
		default:
			break;
	}
}
expr* convertBool2Int (expr* e) {	// Convert any boolean expression to integer expression
	if (e->type=="BOOL") {
		e->loc = gentemp(new symboltype("INTEGER"));
		backpatch (e->truelist, nextinstr());
		emit ("EQUAL", e->loc->name, "true");
		stringstream strs;
	    strs << nextinstr()+1;
	    string str = strs.str();
		emit ("GOTOOP", str);
		backpatch (e->falselist, nextinstr());
		emit ("EQUAL", e->loc->name, "false");
	}
}

void changeTable (symboltable* newtable) {	// Change current symbol table
	table = newtable;
} 

// get next instruction, based on number of quads encounterd till now. 
int nextinstr() {
	return q.array.size();
}

/*
 * Function to generate new temporary variable. 
 */
symbol* gentemp (symboltype* t, string init) {
	char n[10];
	table->count++;
	sprintf(n, "t%02d",temp_count++);	// Create variable with current count and update count.
	symbol* s = new symbol (n); 					// create new symbol in symbol table
	s->type = t;
	s->size=size_type(t);
	if(init == "")
		s->initial_value = "null";
	else
		s-> initial_value = init;
	s->category = "temp";
	table->table.push_back ( *s); 			// Add new temporary to symbol table
	return &table->table.back(); 			// return pointer to the new entry in ST
}

// Function to return the size of symbol based on its type. 
int size_type (symboltype* t){
	if(t->type=="VOID")	return 0;
	else if(t->type=="CHAR") return CHAR_SIZE;
	else if(t->type=="INTEGER")return INT_SIZE;
	else if(t->type=="FLOAT") return  FLOAT_SIZE;
	else if(t->type=="PTR") return POINTER_SIZE;
	else if(t->type=="ARR") return t->width * size_type (t->ptr);
	else if(t->type=="FUNC") return 0;
}

// Function to return type of symbol table entry
string print_type (symboltype* t){
	if (t==NULL) return "null";
	if(strcmp((t->type).c_str(),"VOID")==0)	return "void";
	else if(strcmp((t->type).c_str(),"CHAR")==0) return "char";
	else if(strcmp((t->type).c_str(),"INTEGER")==0) return "integer";
	else if(strcmp((t->type).c_str(),"FLOAT")==0) return "float";
	else if(strcmp((t->type).c_str(),"PTR")==0) return "ptr("+ print_type(t->ptr)+")";
	else if(strcmp((t->type).c_str(),"ARR")==0) {
		stringstream strs;
	    strs << t->width;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		return "arr(" + str + ", "+ print_type (t->ptr) + ")";
		}
	else if(strcmp((t->type).c_str(),"FUNC")==0) return "function";
	else return "_";
}


/*
int  main (int argc, char* argv[]){
	globalTable = new symboltable("Global"); 	// create new global symbol table.
	table = globalTable; 					
	yyparse();								// parse input
	globalTable->update(); 
	globalTable->print(); 					// print symbol table contents
	q.print(); 								// print Three adress codes
};*/