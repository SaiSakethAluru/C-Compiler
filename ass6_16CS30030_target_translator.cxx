#include "ass6_16CS30030_translator.h"
#include <iostream>
#include <cstring>
#include <string>

extern FILE *yyin;
extern vector<string> string_literals;

using namespace std;

int labelCount=0;							// Label count in asm file
std::map<int, int> labelMap;				// map from quad number to label number
ofstream out;								// asm file stream
vector <quad> array;						// quad array
string asmfilename="ass6_16CS30030_";		// asm file name
string inputfile="ass6_16CS30030_test";		// input file name

void computeActivationRecord(symboltable* st) {
	int param = -20; 	// parameters from -4 to -20 in activation record
	int local = -24;	// locals and temporaries from -24 onwards.
	for (list <symbol>::iterator it = st->table.begin(); it!=st->table.end(); it++) {
		if (it->category =="param") {		// if it is a parameter, set activation record offset and update offset
			st->activation_record [it->name] = param;
			param +=it->size;			
		}
		else if (it->name=="retVal") continue; 		// return value - at offset 0
		else {		// either temp or local
			st->activation_record [it->name] = local; 	// set offset
			local -=it->size;	// update offset
		}
	}
}


// generate assembly from TAC
void genasm() {
	array = q.array;

	//To update the goto labels
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++) {
	int i;
		if (it->op=="GOTOOP" || it->op=="LT" || it->op=="GT" || it->op=="LE" || it->op=="GE" || it->op=="EQOP" || it->op=="NEOP") {
			i = atoi(it->result.c_str());
			labelMap [i] = 1;
		}
	}
	int count = 0;
	for (std::map<int,int>::iterator it=labelMap.begin(); it!=labelMap.end(); ++it)
		it->second = count++;
	list<symboltable*> tablelist;
	for (list <symbol>::iterator it = globalTable->table.begin(); it!=globalTable->table.end(); it++) {
		if (it->nested!=NULL) tablelist.push_back (it->nested);
	}
	for (list<symboltable*>::iterator iterator = tablelist.begin(); 
		iterator != tablelist.end(); ++iterator) {
		computeActivationRecord(*iterator);
	}

	//asmfile
	ofstream asmfile;
	asmfile.open(asmfilename.c_str());

	asmfile << "\t.file	\"test.c\"\n";
	for (list <symbol>::iterator it = table->table.begin(); it!=table->table.end(); it++) {
		if (it->category!="function") {
			if (it->type->type=="CHAR") { // Global char
				if (it->initial_value!="null") {
					asmfile << "\t.globl\t" << it->name << "\n";
					asmfile << "\t.type\t" << it->name << ", @object\n";
					asmfile << "\t.size\t" << it->name << ", 1\n";
					asmfile << it->name <<":\n";
					asmfile << "\t.byte\t" << atoi( it->initial_value.c_str()) << "\n";
				}
				else {
					asmfile << "\t.comm\t" << it->name << ",1,1\n";
				}
			}
			if (it->type->type=="INTEGER") { // Global int
				if (it->initial_value!="null") {
					asmfile << "\t.globl\t" << it->name << "\n";
					asmfile << "\t.data\n";
					asmfile << "\t.align 4\n";
					asmfile << "\t.type\t" << it->name << ", @object\n";
					asmfile << "\t.size\t" << it->name << ", 4\n";
					asmfile << it->name <<":\n";
					asmfile << "\t.long\t" << it->initial_value << "\n";
				}
				else {
					asmfile << "\t.comm\t" << it->name << ",4,4\n";
				}
			}
		}
	}
	if (string_literals.size()) {
		asmfile << "\t.section\t.rodata\n";
		for (vector<string>::iterator it = string_literals.begin(); it!=string_literals.end(); it++) {
			asmfile << ".LC" << it - string_literals.begin() << ":\n";
			asmfile << "\t.string\t" << *it << "\n";	
		}	
	}
	asmfile << "\t.text	\n";

	vector<string> params;
	std::map<string, int> theMap;
	for (vector<quad>::iterator it = array.begin(); it!=array.end(); it++) {
		if (labelMap.count(it - array.begin())) {
			asmfile << ".L" << (2*labelCount+labelMap.at(it - array.begin()) + 2 )<< ": " << endl;
		}

		string op = it->op;
		string result = it->result;
		string arg1 = it->arg1;
		string arg2 = it->arg2;
		string s=arg2;

		if(op=="PARAM"){ 	// param statement
			params.push_back(result);
		}
		else {
			asmfile << "\t";
			// Binary Operations
			if (op=="ADD") {
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
					asmfile << "addl \t$" << atoi(arg2.c_str()) << ", " << table->activation_record[arg1] << "(%rbp)";
				}
				else {
					asmfile << "movl \t" << table->activation_record[arg1] << "(%rbp), " << "%eax" << endl;
					asmfile << "\tmovl \t" << table->activation_record[arg2] << "(%rbp), " << "%edx" << endl;
					asmfile << "\taddl \t%edx, %eax\n";
					asmfile << "\tmovl \t%eax, " << table->activation_record[result] << "(%rbp)";
				}
			}
			else if (op=="SUB") {
				asmfile << "movl \t" << table->activation_record[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t" << table->activation_record[arg2] << "(%rbp), " << "%edx" << endl;
				asmfile << "\tsubl \t%edx, %eax\n";
				asmfile << "\tmovl \t%eax, " << table->activation_record[result] << "(%rbp)";
			}
			else if (op=="MULT") {
				asmfile << "movl \t" << table->activation_record[arg1] << "(%rbp), " << "%eax" << endl;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) {
					asmfile << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl;
					symboltable* t = table;
					string val;
					for (list <symbol>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
						if(it->name==arg1) val=it->initial_value; 
					}
					theMap[result]=atoi(arg2.c_str())*atoi(val.c_str());
				}
				else asmfile << "\timull \t" << table->activation_record[arg2] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t%eax, " << table->activation_record[result] << "(%rbp)";			
			}
			else if(op=="DIVIDE") {
				asmfile << "movl \t" << table->activation_record[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tcltd" << endl;
				asmfile << "\tidivl \t" << table->activation_record[arg2] << "(%rbp)" << endl;
				asmfile << "\tmovl \t%eax, " << table->activation_record[result] << "(%rbp)";		
			}

			// Bit Operators /* Ignored */
			else if (op=="MODOP")		asmfile << result << " = " << arg1 << " % " << arg2;
			else if (op=="XOR")			asmfile << result << " = " << arg1 << " ^ " << arg2;
			else if (op=="INOR")		asmfile << result << " = " << arg1 << " | " << arg2;
			else if (op=="BAND")		asmfile << result << " = " << arg1 << " & " << arg2;
			// Shift Operations /* Ignored */
			else if (op=="LEFTOP")		asmfile << result << " = " << arg1 << " << " << arg2;
			else if (op=="RIGHTOP")		asmfile << result << " = " << arg1 << " >> " << arg2;

			else if (op=="EQUAL")	{
				s=arg1;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) 
					asmfile << "movl\t$" << atoi(arg1.c_str()) << ", " << "%eax" << endl;
				else
					asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), " << "%eax" << endl;
				asmfile << "\tmovl \t%eax, " << table->activation_record[result] << "(%rbp)";
			}			
			else if (op=="EQUAL_STRING")	{
				asmfile << "movq \t$.LC" << arg1 << ", " << table->activation_record[result] << "(%rbp)";
			}
			else if (op=="EQUALCHAR")	{
				asmfile << "movb\t$" << atoi(arg1.c_str()) << ", " << table->activation_record[result] << "(%rbp)";
			}					
			// Relational Operations
			else if (op=="EQOP") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tje .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="NEOP") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjne .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="LT") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjl .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="GT") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjg .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="GE") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjge .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="LE") {
				asmfile << "movl\t" << table->activation_record[arg1] << "(%rbp), %eax\n";
				asmfile << "\tcmpl\t" << table->activation_record[arg2] << "(%rbp), %eax\n";
				asmfile << "\tjle .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="GOTOOP") {
				asmfile << "jmp .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) + 2 );
			}
			// Unary Operators
			else if (op=="ADDRESS") {
				asmfile << "leaq\t" << table->activation_record[arg1] << "(%rbp), %rax\n";
				asmfile << "\tmovq \t%rax, " <<  table->activation_record[result] << "(%rbp)";
			}
			else if (op=="PTRR") {
				asmfile << "movq\t" << table->activation_record[arg1] << "(%rbp), %rax\n";
				asmfile << "\tmovl\t(%rax),%eax\n";
				asmfile << "\tmovl \t%eax, " <<  table->activation_record[result] << "(%rbp)\n";	
				// asmfile <<	"\tnop";
			}
			else if (op=="PTRL") {
				asmfile << "movl\t" << table->activation_record[result] << "(%rbp), %eax\n";
				asmfile << "\tmovl\t" << table->activation_record[arg1] << "(%rbp), %edx\n";
				asmfile << "\tmovl\t%edx, (%eax)";
			} 			
			else if (op=="UMINUS") {
				asmfile << "negl\t" << table->activation_record[arg1] << "(%rbp)";
			}
			else if (op=="BNOT")		asmfile << result 	<< " = ~" << arg1;
			else if (op=="LNOT")			asmfile << result 	<< " = !" << arg1;
			else if (op=="ARRR") {
				int off=0;
				off=theMap[arg2]*(-1)+table->activation_record[arg1];
				asmfile << "movq\t" << table->activation_record[arg2] << "(%rbp), "<<"%rax" << endl;
				// asmfile << "movq\t" << off << "(%rbp), "<<"%rax" << endl;
				asmfile << "\tmovq \t%rax, " <<  table->activation_record[result] << "(%rbp)";
			}	 			
			else if (op=="ARRL") {
				int off=0;
				off=theMap[arg1]*(-1)+table->activation_record[result];
				asmfile << "movq\t" << table->activation_record[arg1] << "(%rbp), "<<"%rax" << endl;
				// asmfile << "movq\t" << table->activation_record[arg2] << "(%rbp), "<<"%rdx" << endl;
				asmfile << "\tmovq\t" << "%rdx, " << off << "(%rbp)";
			}	 
			else if (op=="RETURN") {
				if(result!="") asmfile << "movl\t" << table->activation_record[result] << "(%rbp), "<<"%eax";
				else asmfile << "nop";
			}
			else if (op=="PARAM") {
				params.push_back(result);
			}
			else if (op=="CALL") {
				// Function Table
				symboltable* t = globalTable->lookup(arg1)->nested;
				int i,j=0;	// index
				for (list <symbol>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
					i = distance ( t->table.begin(), it);
					if (it->category== "param") {
						if(j==0) {
							asmfile << "movl \t" << table->activation_record[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->activation_record[params[i]] << "(%rbp), " << "%rdi" << endl;
							//asmfile << "\tmovl \t%eax, " << (t->activation_record[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==1) {
							asmfile << "movl \t" << table->activation_record[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->activation_record[params[i]] << "(%rbp), " << "%rsi" << endl;
							//asmfile << "\tmovl \t%eax, " << (t->activation_record[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==2) {
							asmfile << "movl \t" << table->activation_record[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->activation_record[params[i]] << "(%rbp), " << "%rdx" << endl;
							//asmfile << "\tmovl \t%eax, " << (t->activation_record[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else if(j==3) {
							asmfile << "movl \t" << table->activation_record[params[i]] << "(%rbp), " << "%eax" << endl;
							asmfile << "\tmovq \t" << table->activation_record[params[i]] << "(%rbp), " << "%rcx" << endl;
							//asmfile << "\tmovl \t%eax, " << (t->activation_record[it->name]-8 )<< "(%rsp)\n\t";
							j++;
						}
						else {
							asmfile << "\tmovq \t" << table->activation_record[params[i]] << "(%rbp), " << "%rdi" << endl;							
						}
					}
					else break;
				}
				params.clear();
				asmfile << "\tcall\t"<< arg1 << endl;
				asmfile << "\tmovl\t%eax, " << table->activation_record[result] << "(%rbp)";
			}
			else if (op=="FUNC") {	// function prologue
				asmfile <<".globl\t" << result << "\n";
				asmfile << "\t.type\t"	<< result << ", @function\n";
				asmfile << result << ": \n";
				asmfile << ".LFB" << labelCount <<":" << endl;
				asmfile << "\t.cfi_startproc" << endl;
				asmfile << "\tpushq \t%rbp" << endl;
				asmfile << "\t.cfi_def_cfa_offset 8" << endl;
				asmfile << "\t.cfi_offset 5, -8" << endl;
				asmfile << "\tmovq \t%rsp, %rbp" << endl;
				asmfile << "\t.cfi_def_cfa_register 5" << endl;
				table = globalTable->lookup(result)->nested;
				asmfile << "\tsubq\t$" << table->table.back().offset << ", %rsp"<<endl;
				
				// Function Table
				symboltable* t = table;
				int i=0;
				for (list <symbol>::iterator it = t->table.begin(); it!=t->table.end(); it++) {
					if (it->category== "param") {
						if (i==0) {
							asmfile << "\tmovq\t%rdi, " << table->activation_record[it->name] << "(%rbp)";
							i++;
						}
						else if(i==1) {
							asmfile << "\n\tmovq\t%rsi, " << table->activation_record[it->name] << "(%rbp)";
							i++;
						}
						else if (i==2) {
							asmfile << "\n\tmovq\t%rdx, " << table->activation_record[it->name] << "(%rbp)";
							i++;
						}
						else if(i==3) {
							asmfile << "\n\tmovq\t%rcx, " << table->activation_record[it->name] << "(%rbp)";
							i++;
						}
					}
					else break;
				}
			}		
			else if (op=="FUNCEND") {		// function epilogue
				asmfile << "leave\n";
				asmfile << "\t.cfi_restore 5\n";
				asmfile << "\t.cfi_def_cfa 4, 4\n";
				asmfile << "\tret\n";
				asmfile << "\t.cfi_endproc" << endl;
				asmfile << ".LFE" << labelCount++ <<":" << endl;
				asmfile << "\t.size\t"<< result << ", .-" << result;
			}
			// else asmfile << "op";
			asmfile << endl;
		}
	}
	asmfile << 	"\t.ident\t	\"Compiled by 16CS30030\"\n";
	asmfile << 	"\t.section\t.note.GNU-stack,\"\",@progbits\n";
	asmfile.close();
}

// auxillary function for operator overloading
template<class T>
ostream& operator<<(ostream& os, const vector<T>& v)
{
	copy(v.begin(), v.end(), ostream_iterator<T>(os, " ")); 
	return os;
}

int main(int argc, char* argv[]) {
	inputfile=inputfile+string(argv[argc-1])+string(".c");
	asmfilename=asmfilename+string(argv[argc-1])+string(".s");
	globalTable = new symboltable("Global");
	table = globalTable;
	yyin = fopen(inputfile.c_str(),"r"); 
	yyparse();
	globalTable->update();
	globalTable->print();
	q.print();
	genasm();
}