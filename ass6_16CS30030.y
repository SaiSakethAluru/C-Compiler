%{
#include <iostream>
#include <cstdlib>
#include <string>
#include <stdio.h>
#include <sstream>
#include "ass6_16CS30030_translator.h"

extern int yylex();
void yyerror(string s);
extern string Type;
vector<string> string_literals;
using namespace std;
%}

/*
 * The union contains the types,
 * 1. intval for integer values
 * 2. charval for strings
 * 3. instr for instruction addresses - integer type
 * 4. symbolp - pointer to symbol table entries
 * 5. symbolptp - pointer to symbol tables
 * 6. E - pointer to expression type non-terminal
 * 7. S - pointer to statement type non-terminal
 * 8. A - pointer to array type non-terminal
 * 9. unaryOperator - char for unaryOp
 */
 %union {
  int intval;
  char* charval;
  int instr;
  symbol* symbolp;
  symboltype* symboltp;
  expr* E;
  statement* S;
  array* A;
  char unaryOperator;
} 
// parser tokens
%token AUTO
%token ENUM
%token RESTRICT
%token UNSIGNED
%token BREAK
%token EXTERN
%token RETURN
%token VOID
%token CASE
%token FLOAT
%token SHORT
%token VOLATILE
%token CHAR
%token FOR
%token SIGNED
%token WHILE
%token CONST
%token GOTO
%token SIZEOF
%token BOOL
%token CONTINUE
%token IF
%token STATIC
%token COMPLEX
%token DEFAULT
%token INLINE
%token STRUCT
%token IMAGINARY
%token DO
%token INT
%token SWITCH
%token DOUBLE
%token LONG
%token TYPEDEF
%token ELSE
%token REGISTER
%token UNION
%token<symbolp> IDENTIFIER
%token<intval> INTEGER_CONSTANT
%token<charval> FLOATING_CONSTANT
%token<charval> CHARACTER_CONSTANT ENUMERATION_CONSTANT
%token<charval> STRING_LITERAL
%token SQBRAOPEN
%token SQBRACLOSE
%token ROBRAOPEN
%token ROBRACLOSE
%token CURBRAOPEN
%token CURBRACLOSE
%token DOT
%token ACC
%token INC
%token DEC
%token AMP
%token MUL
%token ADD
%token SUB
%token NEG
%token EXCLAIM
%token DIV
%token MODULO
%token SHL
%token SHR
%token BITSHL
%token BITSHR
%token LTE
%token GTE
%token EQ
%token NEQ
%token BITXOR
%token BITOR
%token AND
%token OR
%token QUESTION
%token COLON
%token SEMICOLON
%token DOTS
%token ASSIGN
%token STAREQ
%token DIVEQ
%token MODEQ
%token PLUSEQ
%token MINUSEQ
%token SHLEQ
%token SHREQ
%token BINANDEQ
%token BINXOREQ
%token BINOREQ
%token COMMA
%token HASH

// defining start state
%start translation_unit
//to remove dangling else problem
%right THEN ELSE

// All types of Expressions
%type <E>
	expression
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	AND_expression
	exclusive_OR_expression
	inclusive_OR_expression
	logical_AND_expression
	logical_OR_expression
	conditional_expression
	assignment_expression
	expression_statement

%type <intval> argument_expression_list

//Array to be used later
%type <A> postfix_expression
	unary_expression
	cast_expression


%type <unaryOperator> unary_operator

// declaration types - requiring entry in ST
%type <symbolp> constant initializer
%type <symbolp> direct_declarator init_declarator declarator
%type <symboltp> pointer

//Auxillary non terminals M and N for backpatching
%type <instr> M 
%type <S> N


//All types of Statements
%type <S>  statement
	labeled_statement 
	compound_statement
	selection_statement
	iteration_statement
	jump_statement
	block_item
	block_item_list

%%
// Grammar production rules and corresponding actions

primary_expression
	: IDENTIFIER {
	$$ = new expr();				// create a new instance of expression in ST
	$$->loc = $1;					// and assign loc parameter of non-terminal as the identifier produced
	$$->type = "NONBOOL";			// type of the symbol is non-boolean
	}
	| constant { 				
	$$ = new expr();			
	$$->loc = $1;
	}
	| STRING_LITERAL { 			
	$$ = new expr(); 						// for string literal, create a new instance
	symboltype* tmp = new symboltype("PTR"); 		// create a new symbol of type pointer
	$$->loc = gentemp(tmp, $1); 			// create a temporary variable in ST
	$$->loc->type->ptr = new symboltype("CHAR"); // the pointer is pointing to a char, since strings = char*
	
	string_literals.push_back($1);
	stringstream ss;
	ss << string_literals.size()-1;
	string size_str = ss.str();
	emit("EQUAL_STRING",$$->loc->name,size_str);
	}
	| ROBRAOPEN expression ROBRACLOSE { 		// for (expr), the non-terminal on LHS gets same attributes as the one in ()
	$$ = $2;
	}
	;

constant
	:INTEGER_CONSTANT { 			// if constant is an integer constant
	stringstream strs; 				// create stringstream to parse the integer into a string
    strs << $1;
    string temp_str = strs.str();
    char* intStr = (char*) temp_str.c_str();
	string str = string(intStr);
	$$ = gentemp(new symboltype("INTEGER"), str); 	// generate a new temporary in ST and store the value as the string generated
	emit("EQUAL", $$->name, $1); 		// emit a copy TAC quad, constant.name = INTEGER_CONSTANT
	}
	|FLOATING_CONSTANT { 				// if floating contant is produced in production
	$$ = gentemp(new symboltype("FLOAT"), string($1)); 	// convert it to string, and assign as value to a new temporary generated of type float
	emit("EQUAL", $$->name, string($1)); 		// emit a copy TAC quad, constant.name = FLOATING_CONSTANT
	}
	|ENUMERATION_CONSTANT  {//later
	}
	|CHARACTER_CONSTANT { 		// if a CHARACTER_CONSTANT is produced
	$$ = gentemp(new symboltype("CHAR"),$1); 	// create new temporary in ST
	emit("EQUALCHAR", $$->name, string($1)); 	// emit a copy TAC quad
	}
	;


postfix_expression
	:primary_expression { 		// for primary_expression non-terminal, create a new array instance
		$$ = new array ();  		// new pointer to symbol table entry
		$$->array = $1->loc; 		// copy base address of RHS as array address
		$$->loc = $$->array; 	// assign base address of LHS as the new array's address
		$$->type = $1->loc->type; 	// the type of LHS is type of element in array
	}
	|postfix_expression SQBRAOPEN expression SQBRACLOSE { 		// array addressing
		$$ = new array();						// new pointer to symbol table entry
		$$->array = $1->loc;					// copy the base
		$$->type = $1->type->ptr;				// type = type of element
		$$->loc = gentemp(new symboltype("INTEGER"));		// store computed address
		
		// New address =(if only) already computed + $3 * new width
		if ($1->cat=="ARR") {						// if already computed
			symbol* t = gentemp(new symboltype("INTEGER"));
			stringstream strs;
		    strs <<size_type($$->type);
		    string temp_str = strs.str();
		    char* intStr = (char*) temp_str.c_str();
			string str = string(intStr);				
 			emit ("MULT", t->name, $3->loc->name, str);
			emit ("ADD", $$->loc->name, $1->loc->name, t->name);
		}
 		else {
 			stringstream strs;
		    strs <<size_type($$->type);
		    string temp_str = strs.str();
		    char* intStr1 = (char*) temp_str.c_str();
			string str1 = string(intStr1);		
	 		emit("MULT", $$->loc->name, $3->loc->name, str1);
 		}

 		// Mark that it contains array address and first time computation is done
		$$->cat = "ARR";
	}
	|postfix_expression ROBRAOPEN ROBRACLOSE {
	//later
	}
	|postfix_expression ROBRAOPEN argument_expression_list ROBRACLOSE {  // function calling
		$$ = new array(); 					// new pointer to symbol table entry
		$$->array = gentemp($1->type);  	// generate new temporary 
		stringstream strs; 			//  stringstream to convert argument_expression_list to string
	    strs <<$3;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);		
		emit("CALL", $$->array->name, $1->array->name, str); 	// emit a function call statement with function name.
	}
	|postfix_expression DOT IDENTIFIER {//later
	}
	|postfix_expression ACC IDENTIFIER {//later
	}
	|postfix_expression INC {			// post increment statement
		$$ = new array(); 		// new pointer to symbol table entry
		// copy $1 to $$
		$$->array = gentemp($1->array->type); 		// create new temporary variable of type same as element type
		emit ("EQUAL", $$->array->name, $1->array->name); 	// emit TAC to copy the value of RHS to LHS

		// Increment $1
		emit ("ADD", $1->array->name, $1->array->name, "1"); 	// emit TAC to add 1 to RHS value
	}
	|postfix_expression DEC {	// post decrement
		$$ = new array(); 	// new pointer to symbol table

		// copy $1 to $$
		$$->array = gentemp($1->array->type); 	// create new temporary
		emit ("EQUAL", $$->array->name, $1->array->name); 	// and copy value of RHS to LHS (emit TAC)

		// Decrement $1
		emit ("SUB", $1->array->name, $1->array->name, "1"); 	// emit TAC to subtract 1 from RHS
	}
	|ROBRAOPEN type_name ROBRACLOSE CURBRAOPEN initializer_list CURBRACLOSE { 
		//later to be added more
		$$ = new array(); 	// new pointer to ST
		$$->array = gentemp(new symboltype("INTEGER")); 	// create new temporary of type integer 
		$$->loc = gentemp(new symboltype("INTEGER"));		// copy new temporary's address to LHS non-terminal
	}
	|ROBRAOPEN type_name ROBRACLOSE CURBRAOPEN initializer_list COMMA CURBRACLOSE {
		//later to be added more
		$$ = new array();
		$$->array = gentemp(new symboltype("INTEGER"));
		$$->loc = gentemp(new symboltype("INTEGER"));
	}
	;

argument_expression_list
	:assignment_expression {
	emit ("PARAM", $1->loc->name);
	$$ = 1;
	}
	|argument_expression_list COMMA assignment_expression {
	emit ("PARAM", $3->loc->name);
	$$ = $1+1;
	}
	;

unary_expression
	:postfix_expression { 
	$$ = $1;
	}
	|INC unary_expression { 	// pre increment
		// Increment $2
		emit ("ADD", $2->array->name, $2->array->name, "1");  // first increment value of RHS - emit TAC

		// Use the same value as $2
		$$ = $2; 	// assign incremented value to LHS
	}
	|DEC unary_expression { 	// pre decrement
		// Decrement $2
		emit ("SUB", $2->array->name, $2->array->name, "1");

		// Use the same value as $2
		$$ = $2;
	}
	|unary_operator cast_expression { 	// other unary operators
		$$ = new array();
		switch ($1) {
			case '&': 		// get address of variable
				$$->array = gentemp((new symboltype("PTR"))); 	// create new temporary of type pointer to store address
				$$->array->type->ptr = $2->array->type; 	// assign type of pointer as type of RHS type
				emit ("ADDRESS", $$->array->name, $2->array->name); 	// emit TAC as address of RHS name
				break;
			case '*': 		// pointer dereferecing
				$$->cat = "PTR"; 	
				$$->loc = gentemp ($2->array->type->ptr); 		// create new temporary to store value in ptr
				emit ("PTRR", $$->loc->name, $2->array->name);  // emit TAC as pointer dereferecing of RHS name
				$$->array = $2->array;
				break;
			case '+': 		// unary plus - no special action
				$$ = $2;
				break;
			case '-': 		// unary minus
				$$->array = gentemp(new symboltype($2->array->type->type)); 	// create new temporary to store negated value of type same as RHS type`
				emit ("UMINUS", $$->array->name, $2->array->name); 	//emit TAC of unary minus of RHS name 
				break;
			case '~': 	// bitwise not
				$$->array = gentemp(new symboltype($2->array->type->type)); // create new temporary to store negated value of type same as RHS
				emit ("BNOT", $$->array->name, $2->array->name); 	// emit TAC as bitwise not of RHS name
				break;
			case '!': 	// boolean logical not
				$$->array = gentemp(new symboltype($2->array->type->type)); // create new temporary to store logical not value of RHS
				emit ("LNOT", $$->array->name, $2->array->name); 	// emit logical not expression of RHS
				break;
			default:
				break;
		}
	}
	|SIZEOF unary_expression {
	//later
	}
	|SIZEOF ROBRAOPEN type_name ROBRACLOSE {
	//later
	}
	;

unary_operator
	:AMP {
		$$ = '&';
	}
	|MUL {
		$$ = '*';
	}
	|ADD {
		$$ = '+';
	}
	|SUB {
		$$ = '-';
	}
	|NEG {
		$$ = '~';
	}
	|EXCLAIM {
		$$ = '!';
	}
	;

cast_expression
	:unary_expression {
		$$=$1;
	}
	|ROBRAOPEN type_name ROBRACLOSE cast_expression { // type casting 
		//to be added later
		$$=$4;
	}
	;

multiplicative_expression
	:cast_expression {
		$$ = new expr();
		if ($1->cat=="ARR") { // Array
			$$->loc = gentemp($1->loc->type);
			emit("ARRR", $$->loc->name, $1->array->name, $1->loc->name); // emit TAC to print array 
		}
		else if ($1->cat=="PTR") { // Pointer
			$$->loc = $1->loc;
		}
		else { // otherwise
			$$->loc = $1->array; 	// copy location of RHS in ST to LHS address
		}
	}
	|multiplicative_expression MUL cast_expression {
		if (typecheck ($1->loc, $3->array) ) { 		// check if two operands are multiplication compatible
			$$ = new expr();		// if yes, create new expression
			$$->loc = gentemp(new symboltype($1->loc->type->type)); 	// create new temporary to store result
			emit ("MULT", $$->loc->name, $1->loc->name, $3->array->name); 	// emit TAC as multiplation of two operands and assign to temporary created
		}
		else cout << "Type Error"<< endl; 	// if they are not compatible types, error
	}
	|multiplicative_expression DIV cast_expression { 	// division expression, same as above
		if (typecheck ($1->loc, $3->array) ) {
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->array->name);
		}
		else cout << "Type Error"<< endl;
	}
	|multiplicative_expression MODULO cast_expression { // modulus expression, same as multiplation expression
		if (typecheck ($1->loc, $3->array) ) {
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("MODOP", $$->loc->name, $1->loc->name, $3->array->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

additive_expression			// addition/ subtract expression
	:multiplicative_expression { 	// if no operation, simply assign LHS as RHS
		$$=$1;
	} 
	|additive_expression ADD multiplicative_expression { // addition
		if (typecheck ($1->loc, $3->loc) ) { 	// check types of two operands of plus
			$$ = new expr();	// if compatible, 
			$$->loc = gentemp(new symboltype($1->loc->type->type)); // create new temporary to store result
			emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name); 	// emit addition TAC
		}
		else cout << "Type Error"<< endl; // if not compatible, error. 
	}
	|additive_expression SUB multiplicative_expression { 	// subtraction operation - similar to addition
			if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("SUB", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;

	}
	;

shift_expression
	:additive_expression { 	// no shifting operation - simply assign
		$$=$1;
	}
	|shift_expression SHL additive_expression {	//left shift
		if ($3->loc->type->type == "INTEGER") { 	// type of operand should be integer
			$$ = new expr();
			$$->loc = gentemp (new symboltype("INTEGER")); 	// create new temporary to store result
			emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name); 	// emit leftshift TAC
		}
		else cout << "Type Error"<< endl; 	// if operand is not integer, error
	}
	|shift_expression SHR additive_expression{ 	// right shift, same as left shift
		if ($3->loc->type->type == "INTEGER") {
			$$ = new expr();
			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

relational_expression
	:shift_expression {$$=$1;}	// no relational_expression, simply assign
	|relational_expression BITSHL shift_expression { 		
		if (typecheck ($1->loc, $3->loc) ) { 	// check type compatibility of operands
			$$ = new expr();
			$$->type = "BOOL"; 		// create new boolean type expression

			$$->truelist = makelist (nextinstr()); 	// assign true list as next expression 
			$$->falselist = makelist (nextinstr()+1); 	// false list is nextinstr + 1
			emit("LT", "", $1->loc->name, $3->loc->name); // emit less than TAC
			emit ("GOTOOP", ""); 	// create goto statement with blank label, to be backpatched
		}
		else cout << "Type Error"<< endl; // if not compatible, error
	}
	|relational_expression BITSHR shift_expression { 	// greater than expression, same as less than
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relational_expression LTE shift_expression { 	// less than equal to statement, same as above
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("LE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relational_expression GTE shift_expression { 	// greater than equal to - same as above
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;

equality_expression
	:relational_expression {$$=$1;}
	|equality_expression EQ relational_expression { 	// equality expression
		if (typecheck ($1->loc, $3->loc)) { 	// type check operands.
			convertBool2Int ($1); 		// convert both operands to integer if any of them are boolean.
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL"; 	// create new result expression of type boolean

			$$->truelist = makelist (nextinstr()); 	 	// truelist - next instruction
			$$->falselist = makelist (nextinstr()+1); 	// falselist - skip next instruction and assign the one after that.
			emit("EQOP", "", $1->loc->name, $3->loc->name); // emit equality TAC
			emit ("GOTOOP", ""); 	// create blank goto expression - to be backpatched later
		}
		else cout << "Type Error"<< endl; 	// print error in case of type mismatch
	}
	|equality_expression NEQ relational_expression {	// not equal expression - same as equality expression
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("NEOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;

AND_expression
	:equality_expression {$$=$1;}
	|AND_expression AMP equality_expression { 		// bitwise and expression
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symboltype("INTEGER"));		// create new temporary to store result
			emit ("BAND", $$->loc->name, $1->loc->name, $3->loc->name);	// emit bitwise and TAC
		}
		else cout << "Type Error"<< endl;
	}
	;

exclusive_OR_expression		// bitwise or expression - same as bitwise and
	:AND_expression {$$=$1;}
	|exclusive_OR_expression BITXOR AND_expression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

inclusive_OR_expression
	:exclusive_OR_expression {$$=$1;}
	|inclusive_OR_expression BITOR exclusive_OR_expression { 		// bitwise or expression
		if (typecheck ($1->loc, $3->loc) ) { 	// check for compatible operands
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symboltype("INTEGER")); 	// create new integer type temporary
			emit ("INOR", $$->loc->name, $1->loc->name, $3->loc->name); 	// emit logical or  TAC
		}
		else cout << "Type Error"<< endl;
	}
	;

logical_AND_expression
	:inclusive_OR_expression {$$=$1;}
	|logical_AND_expression N AND M inclusive_OR_expression { 	// logical and expression
		convertInt2Bool($5);		// convert inclusive_OR_expression to bool if it is int

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr()); 
		convertInt2Bool($1);

		$$ = new expr();
		$$->type = "BOOL";

		backpatch($1->truelist, $4);	// backpatch lhs.truelist = M
		$$->truelist = $5->truelist;
		$$->falselist = merge ($1->falselist, $5->falselist); // lhs.falselist = $1 is false or $1 - true and $5 false.
	}
	;

logical_OR_expression 		// logical or expression 
	:logical_AND_expression {$$=$1;}
	|logical_OR_expression N OR M logical_AND_expression {
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);

		$$ = new expr();
		$$->type = "BOOL";

		backpatch ($1->falselist, $4); 		
		$$->truelist = merge ($1->truelist, $5->truelist); 	// lhs.truelist = $1 is true, else $1- false and $5 is true
		$$->falselist = $5->falselist; 	// lhs.falselist = both are false
	}
	;

M 	:  {	// To store the address of the next instruction
		$$ = nextinstr();
	};

N 	:  { 	// gaurd against fallthrough by emitting a goto
		$$  = new statement();
		$$->nextlist = makelist(nextinstr());
		emit ("GOTOOP","");
	}

conditional_expression
	:logical_OR_expression {$$=$1;}
	|logical_OR_expression QUESTION M expression N COLON M conditional_expression { // ternary condition expression
		$$->loc = gentemp($4->loc->type); 	// create new temporary to store result
		$$->loc->update($4->loc->type); 	// update lhs.type = expression.type
		emit("EQUAL", $$->loc->name, $8->loc->name); 	// assign lhs to conditional_expression's value if logical_OR_expression is false
		list<int> l = makelist(nextinstr()); // make list for instruction after ternary instruction after assignment
		emit ("GOTOOP", "");				// goto statement after assigning value for false case of expression

		backpatch($5->nextlist, nextinstr());	// use $6 to backpatch if logical_OR_expression is true
		emit("EQUAL", $$->loc->name, $4->loc->name); 	// assign expression($5) as lhs
		list<int> m = makelist(nextinstr()); 	// create new list for storing nextinstr
		l = merge (l, m); 	// lhs.nextinstr is merged with previous nextinstr

		convertInt2Bool($1); 		// convert $1 to boolean type
		backpatch ($1->truelist, $3);	// backpatch $1's truelist with M($4) if $1 is true
		backpatch ($1->falselist, $7);	// else if $1 is false, backpatch the false list with nextinstr stored in M($8 )
		backpatch (l, nextinstr());

	}
	;

assignment_expression
	:conditional_expression {$$=$1;}
	|unary_expression assignment_operator assignment_expression { 	// assignment expression
		if($1->cat=="ARR") { 	// if it is a array assignment
			$3->loc = convert($3->loc, $1->type->type); 	// convert $3 to $1's array element type
			emit("ARRL", $1->array->name, $1->loc->name, $3->loc->name);	// emit array assignment TAC
			}
		else if($1->cat=="PTR") { 	// if it is a pointer assignment
			emit("PTRL", $1->array->name, $3->loc->name);	 // emit TAC - pointer assignment
			}
		else{
			$3->loc = convert($3->loc, $1->array->type->type); 	// else it is normal assignment
			emit("EQUAL", $1->array->name, $3->loc->name); 	// emit copy assignment
			}
		$$ = $3; // assign lhs = rhs
	}
	;

assignment_operator 
	:ASSIGN {//later
	}
	|STAREQ {//later
	}
	|DIVEQ {//later
	}
	|MODEQ {//later
	}
	|PLUSEQ {//later
	}
	|MINUSEQ {//later
	}
	|SHLEQ {//later
	}
	|SHREQ {//later
	}
	|BINANDEQ {//later
	}
	|BINXOREQ {//later
	}
	|BINOREQ {//later
	}
	;

expression
	:assignment_expression {$$=$1;}
	|expression COMMA assignment_expression {
	//later
	}
	;

constant_expression
	:conditional_expression {
	//later
	}
	;

declaration
	:declaration_specifiers init_declarator_list SEMICOLON {//later
	}
	|declaration_specifiers SEMICOLON {//later
	}
	;


declaration_specifiers
	:storage_class_specifier declaration_specifiers {//later
	}
	|storage_class_specifier {//later
	}
	|type_specifier declaration_specifiers {//later
	}
	|type_specifier {//later
	}
	|type_qualifier declaration_specifiers {//later
	}
	|type_qualifier {//later
	}
	|function_specifier declaration_specifiers {//later
	}
	|function_specifier {//later
	}
	;

init_declarator_list
	:init_declarator {//later
	}
	|init_declarator_list COMMA init_declarator {//later
	}
	;

init_declarator
	:declarator {$$=$1;}
	|declarator ASSIGN initializer { // declaration assignment statement
		if ($3->initial_value!="") $1->initial_value=$3->initial_value;  // update initial value in ST
		emit ("EQUAL", $1->name, $3->name); // emit assignment TAC
	}
	;

storage_class_specifier
	: EXTERN {//later
	}
	| STATIC {//later
	}
	| AUTO {//later
	}
	| REGISTER {//later
	}
	;

type_specifier
	: VOID {Type="VOID";} 		// assign type attribute to void
	| CHAR {Type="CHAR";} 		// assign type attribute to char
	| SHORT
	| INT {Type="INTEGER";} 	// assign type attribute to integer
	| LONG
	| FLOAT {Type = "FLOAT";} 	// assign type attribute to float 
	| DOUBLE 
	| SIGNED
	| UNSIGNED
	| BOOL
	| COMPLEX
	| IMAGINARY
	| enum_specifier
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {//later
	}
	| type_specifier {//later
	}
	| type_qualifier specifier_qualifier_list {//later
	}
	| type_qualifier {//later
	}
	;

enum_specifier
	:ENUM IDENTIFIER CURBRAOPEN enumerator_list CURBRACLOSE {//later
	}
	|ENUM CURBRAOPEN enumerator_list CURBRACLOSE {//later
	}
	|ENUM IDENTIFIER CURBRAOPEN enumerator_list COMMA CURBRACLOSE {//later
	}
	|ENUM CURBRAOPEN enumerator_list COMMA CURBRACLOSE {//later
	}
	|ENUM IDENTIFIER {//later
	}
	;

enumerator_list
	:enumerator {//later
	}
	|enumerator_list COMMA enumerator {//later
	}
	;

enumerator
	:IDENTIFIER {//later
	}
	|IDENTIFIER ASSIGN constant_expression {//later
	}
	;

type_qualifier
	:CONST {//later
	}
	|RESTRICT {//later
	}
	|VOLATILE {//later
	}
	;

function_specifier
	:INLINE {//later
	}
	;

declarator
	:pointer direct_declarator { // pointer declaration statement
		symboltype * t = $1; // new symbol entry of type same as pointer type
		while (t->ptr !=NULL) t = t->ptr;  	// find the primitive element if rhs is a pointer to a poitner and so on
		t->ptr = $2->type;		// update pointer type to pointer type of rhs
		$$ = $2->update($1); 	// assign lhs to pointer to symbol table entry after updating rhs pointer type
	}
	|direct_declarator {//later
	}
	;


direct_declarator
	:IDENTIFIER {
		$$ = $1->update(new symboltype(Type)); 	// assign lhs to pointer after updating type of rhs
		currentSymbol = $$;
	}
	| ROBRAOPEN declarator ROBRACLOSE {$$=$2;}
	| direct_declarator SQBRAOPEN type_qualifier_list assignment_expression SQBRACLOSE {//later
	}
	| direct_declarator SQBRAOPEN type_qualifier_list SQBRACLOSE {//later
	}
	| direct_declarator SQBRAOPEN assignment_expression SQBRACLOSE { // array element declaration statement
		symboltype * t = $1 -> type; 	// create new symbol table entry of type = rhs declarator type
		symboltype * prev = NULL;
		while (t->type == "ARR") { 	// find the primitive data type if rhs is a nested pointer
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			int temp = atoi($3->loc->initial_value.c_str());	// convert initial value of rhs $3 into integer to obtain size of array to be created 
			symboltype* s = new symboltype("ARR", $1->type, temp);	// assign new symbol table entry of type array of rhs elements of size temp
			$$ = $1->update(s);	// update symbol table entry for type of lhs to be type of new array created
		}
		else {
			prev->ptr =  new symboltype("ARR", t, atoi($3->loc->initial_value.c_str()));
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQBRAOPEN SQBRACLOSE { 		// declaration of type arr[]
		symboltype * t = $1 -> type; 	
		symboltype * prev = NULL;
		while (t->type == "ARR") { 	// find primitive element of rhs if it is a nested pointer
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			symboltype* s = new symboltype("ARR", $1->type, 0); 	// create new pointer to ST entry to array of type rhs type and size 0
			$$ = $1->update(s); 	// update lhs type to be type of rhs array created
		}
		else {
			prev->ptr =  new symboltype("ARR", t, 0);	// else create a new array pointer 
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQBRAOPEN STATIC type_qualifier_list assignment_expression SQBRACLOSE {//later
	}
	| direct_declarator SQBRAOPEN STATIC assignment_expression SQBRACLOSE {//later
	}
	| direct_declarator SQBRAOPEN type_qualifier_list MUL SQBRACLOSE {//later
	}
	| direct_declarator SQBRAOPEN MUL SQBRACLOSE {//later
	}
	| direct_declarator ROBRAOPEN CT parameter_type_list ROBRACLOSE { 	// function call
		table->name = $1->name;	// assing name of new table to be name of function
		//if ($1->type->type !="VOID") {	// if return type is void,
			symbol *s = table->lookup("retVal");	// update return type in symbol table entry
			s->update($1->type);		
		//}
		//$1 = $1->update(new symboltype("FUNC"));
		$1->nested=table; 	// assign the new table to be nested table for the function entry in parent ST
		$1->category = "function";
		table->parent = globalTable; 	// initialise parent to be global ST
		changeTable (globalTable);				// Come back to globalsymbol table
		currentSymbol = $$;
	}
	| direct_declarator ROBRAOPEN identifier_list ROBRACLOSE {//later
	}
	| direct_declarator ROBRAOPEN CT ROBRACLOSE { 	// no parameters in function
		table->name = $1->name;
		
		//if ($1->type->type !="VOID") { 	// if return type is VOID
			symbol *s = table->lookup("retVal");	// update return type in ST
			s->update($1->type);		
		//}
		//$1 = $1->update(new symboltype("FUNC"));
		$1->nested=table;	// assign table to be nested for function entry in parent ST
		$1->category="function";
		table->parent = globalTable;
		changeTable (globalTable);				// Come back to globalsymbol table
		currentSymbol = $$;
	}
	;

CT
	:  { 															// Used for changing to symbol table for a function
		if (currentSymbol->nested==NULL) changeTable(new symboltable(""));	// Function symbol table doesn't already exist
		else {
			changeTable (currentSymbol ->nested);						// Function symbol table already exists
			emit ("FUNC", table->name);
		}
	}
	;
CT_DEF
	:  { 															// Used for changing to symbol table for a function
		if (currentSymbol->nested==NULL) changeTable(new symboltable(""));	// Function symbol table doesn't already exist
		else {
			changeTable (currentSymbol ->nested);						// Function symbol table already exists
			emit ("FUNC", table->name);
		}
	}
	;

pointer
	:MUL type_qualifier_list {//later
	}
	|MUL {
		$$ = new symboltype("PTR");
	}
	|MUL type_qualifier_list pointer {//later
	}
	|MUL pointer {
		$$ = new symboltype("PTR", $2);
	}
	;

type_qualifier_list
	:type_qualifier {//later
	}
	|type_qualifier_list type_qualifier {//later
	}
	;

parameter_type_list
	:parameter_list {//later
	}
	|parameter_list COMMA DOTS {//later
	}
	;

parameter_list
	:parameter_declaration {//later
	}
	|parameter_list COMMA parameter_declaration {//later
	}
	;

parameter_declaration
	:declaration_specifiers declarator {
		$2->category = "param";
	}
	|declaration_specifiers {//later
	}
	;

identifier_list
	:IDENTIFIER {//later
	}
	|identifier_list COMMA IDENTIFIER {//later
	}
	;

type_name
	:specifier_qualifier_list {//later
	}
	;

initializer
	:assignment_expression {
		$$ = $1->loc;
	}
	|CURBRAOPEN initializer_list CURBRACLOSE {//later
	}
	|CURBRAOPEN initializer_list COMMA CURBRACLOSE {//later
	}
	;


initializer_list
	:designation initializer {//later
	}
	|initializer {//later
	}
	|initializer_list COMMA designation initializer {//later
	}
	|initializer_list COMMA initializer {//later
	}
	;

designation
	:designator_list ASSIGN {//later
	}
	;

designator_list
	:designator {//later
	}
	|designator_list designator {//later
	}
	;

designator
	:SQBRAOPEN constant_expression SQBRACLOSE {//later
	}
	|DOT IDENTIFIER {//later
	}
	;

statement
	:labeled_statement {//later
	}
	|compound_statement {$$=$1;}
	|expression_statement {
		$$ = new statement(); 		// create new statement and copy nextlists
		$$->nextlist = $1->nextlist;
	}
	|selection_statement {$$=$1;}
	|iteration_statement {$$=$1;}
	|jump_statement {$$=$1;}
	;

labeled_statement
	:IDENTIFIER COLON statement {$$ = new statement();}
	|CASE constant_expression COLON statement {$$ = new statement();}
	|DEFAULT COLON statement {$$ = new statement();}
	;

compound_statement
	:CURBRAOPEN block_item_list CURBRACLOSE {$$=$2;}
	|CURBRAOPEN CURBRACLOSE {$$ = new statement();}
	;

block_item_list
	:block_item {$$=$1;}
	|block_item_list M block_item {		// for each item in list, 
		$$=$3;							// copy lhs to be $3 (item) of rhs
		backpatch ($1->nextlist, $2);	// backpatch next list of block_item_list with nextinstr of M
	}
	;

block_item
	:declaration {
		$$ = new statement();
	}
	|statement {$$ = $1;}
	;

expression_statement
	:expression SEMICOLON {$$=$1;}
	|SEMICOLON {$$ = new expr();}
	;

selection_statement
	:IF ROBRAOPEN expression N ROBRACLOSE M statement N %prec THEN{ 	// if statement
		backpatch ($4->nextlist, nextinstr()); 	
		convertInt2Bool($3); 	// convert expression in if to boolean
		$$ = new statement();
		backpatch ($3->truelist, $6); // if the expression is true, backpatch truelist with M (statement)
		list<int> temp = merge ($3->falselist, $7->nextlist); // if expression is false or after statement is executed, target is same - hence merge
		$$->nextlist = merge ($8->nextlist, temp); 	// merge the above merged list with nextlist of $8(N) and assign this to lhs.nextlist
	}
	|IF ROBRAOPEN expression N ROBRACLOSE M statement N ELSE M statement { // if else statement
		backpatch ($4->nextlist, nextinstr());	
		convertInt2Bool($3);	// convert expression to boolean if it is not
		$$ = new statement();
		backpatch ($3->truelist, $6); 	// expression's truelist - backpatch to before statement using M ($6)
		backpatch ($3->falselist, $10); 	// expression's falselist - backpatch to before else statement using M ($8)
		list<int> temp = merge ($7->nextlist, $8->nextlist); // merge nextlist of true part with N following it to obtain target after true part execution
		$$->nextlist = merge ($11->nextlist,temp); //target of after executing true statement or false statement is same - merge them and assign as lhs.nextinst
	}
	|SWITCH ROBRAOPEN expression ROBRACLOSE statement {//later
	}
	;

iteration_statement
	:WHILE M ROBRAOPEN expression ROBRACLOSE M statement { 	// while loop
		$$ = new statement();
		convertInt2Bool($4); 	// convert expression to boolean
		// M1 to go back to boolean again
		// M2 to go to statement if the boolean is true
		backpatch($7->nextlist, $2);
		backpatch($4->truelist, $6);
		$$->nextlist = $4->falselist;
		// Emit to prevent fallthrough
		stringstream strs;
	    strs << $2;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);

		emit ("GOTOOP", str);
	}
	|DO M statement M WHILE ROBRAOPEN expression ROBRACLOSE SEMICOLON { // do while loop
		$$ = new statement();
		convertInt2Bool($7);
		// M1 to go back to statement if expression is true
		// M2 to go to check expression if statement is complete
		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		$$->nextlist = $7->falselist; // nextlist of statement is if expression is false.
	}
	|FOR ROBRAOPEN expression_statement M expression_statement ROBRACLOSE M statement{ // for loop
		$$ = new statement();
		convertInt2Bool($5);
		// M1 to go to statement if expression is true.
		// M2 to go come back to expression after executing statement
		backpatch ($5->truelist, $7);
		backpatch ($8->nextlist, $4);
		stringstream strs;
	    strs << $4;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);

		emit ("GOTOOP", str); 
		$$->nextlist = $5->falselist; // loop termination - lhs nextlist if expression is false
	}
	|FOR ROBRAOPEN expression_statement M expression_statement M expression N ROBRACLOSE M statement{ // for loop
		$$ = new statement();
		convertInt2Bool($5);
		// M1 to go to statement if expression is true
		backpatch ($5->truelist, $10);
		// M2 to go to expression after updating loop variable
		backpatch ($8->nextlist, $4);
		// M3 to go to updating expression after executing statement
		backpatch ($11->nextlist, $6);
		stringstream strs;
	    strs << $6;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit ("GOTOOP", str);
		// loop is terminated if expression is false
		$$->nextlist = $5->falselist; 	// loop termination - lhs's nextlist is same as expression's false list
	}
	;

jump_statement
	:GOTO IDENTIFIER SEMICOLON {$$ = new statement();}
	|CONTINUE SEMICOLON {$$ = new statement();}
	|BREAK SEMICOLON {$$ = new statement();}
	|RETURN expression SEMICOLON {
		$$ = new statement();
		emit("RETURN",$2->loc->name);
	}
	|RETURN SEMICOLON {
		$$ = new statement();
		emit("RETURN","");
	}
	;

translation_unit
	:external_declaration {}
	|translation_unit external_declaration {}
	;

external_declaration
	:function_definition {}
	|declaration {}
	;

function_definition
	:declaration_specifiers declarator declaration_list CT_DEF compound_statement {}
	|declaration_specifiers declarator CT_DEF compound_statement {
		emit("FUNCEND",table->name);
		table->parent = globalTable;
		changeTable (globalTable);
	}
	;
declaration_list
	:declaration {//later
	}
	|declaration_list declaration {//later
	}
	;



%%

void yyerror(string s) {
    cout<<s<<endl;
}