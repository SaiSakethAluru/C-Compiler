#include "myl.h"
#define INT_BUFF 20 	// buffer length in case of integers or float read and write
#define STR_BUFF 100 	// buffer length for strings read or write

// function to print an integer without standard library functions
int printInt(int n)
{
	char buff[INT_BUFF], zero = '0'; 	// create a character array and define zero character
	int i=0,j,k,bytes;
	if(n==0) { 						// if given number is zero, add zero char to array
		buff[i++] = zero; 
		bytes = i; 					// number of bytes in 
	}
	else{
		if(n<0){ 					// for negative numbers, 
			buff[i++] = '-';		// add - char as first character in buffer
			n*=-1; 					// make the input positive for rest of the function
		}
		while(n){ 							// loop to extract each digit of number
			int digit = n%10;				// digit contains last digit
			n/=10; 							// remove last digit from rest of the number
			buff[i++] = (char)(zero+digit); // convert digit as char and append to buffer
		}
		j = (buff[0]=='-')?1:0;  			// assign j to first digit in buffer
		k = i-1;							// assign k to last digit in buffer
		while(j<k){ 						// loop to reverse digits present in buffer
			char temp = buff[j]; 			// swap buff[j] and buff[k]
			buff[j++] = buff[k]; 
			buff[k--] = temp;
		}
		bytes = i; 							// number of bytes in buffer
	}

	// inline assembly code to print the buffer on standard output
	__asm__ __volatile__ (
		"movl $1, %%eax	\n\t" 			// syscall code for write function
		"movq $1, %%rdi \n\t"			// syscall code for stdout
		"syscall \n\t" 					// call syscall
		:
		:"S"(buff),"d"(bytes)    		// specify base address and number of bytes to print
		);
	if(bytes>0) 		// if positive number of bytes are printed, return number of bytes printed
		return bytes;
	else return ERR; 	// else return error code;
}

// function to print string without standard library functions
int printStr(char* s)
{
	char buff[STR_BUFF]; 		// create buffer to store characters
	int i,j=0,characters=0; 	
	for(i=0;s[i]!='\0';i++){ 	// append characters from input one by one to buffer
		buff[j++] = s[i];
		characters++; 			// update no. of characters being printed
	}

	// inline assembly code to print string buffer on stdout
	__asm__ __volatile__ (
		"movl $1, %%eax \n\t" 		// syscall code for write function 	
		"movq $1, %%rdi \n\t"		// syscall code for stdout
		"syscall \n\t" 				// call syscall
		:
		: "S"(buff),"d"(j) 			// specify base address and number of bytes to be printed
		);
	return characters; 				// return number of characters printed

}

// function to read integer without using standard library
int readInt(int* ep)
{
	int n=0;
	char temp; 					// temporary character to read char by char input from user
	char num[INT_BUFF]; 		// buffer to store input entered
	int i=0,j,val=0; 	
	while(1){ 					// loop to continuosly read char by char input from user
		// inline assembly function to read one character from stdin
		__asm__ __volatile__(
			"syscall"::"a"(0),"D"(0),"S"(&temp),"d"(1) // read 1 byte from stdin and store in address of temp
			);
		// if character entered is space or newline, input ends so break
		if(temp == '\t' || temp == ' '|| temp == '\n'){
			break;
		}
		// if entered character is not digit or - sign, return error code
		else if((int)(temp-'0') > 9 || ((int)(temp-'0') < 0 && temp != '-')){
			*ep = ERR;
			return 0;
		}
		// else if valid character is entered, append in buffer
		else{
			num[i++] = temp;
		}
	}
	// if first char is -, number is negative
	if(num[0]=='-'){
		// only - sign without further digits is not allowed
		if(i==1){
			*ep = ERR;
			return 0;
		}
		else{
			for(j=1;j<i;j++){
				if(num[j]=='-'){   	// - sign in anywhere apart from first character is not allowed
					*ep = ERR;
					return 0;
				}
				else{									// for valid input
					val*=10;
					val += (int)num[j] -(int)('0'); 	// add new digit to current value of input till now
				}
			}
			val*=-1; 		// since first char is -, number should be negative
			n = val; 		// store val calculated in ptr for number
		}
	}		
	// if first char is not -, number is positive
	else{
		for(j=0;j<i;j++){
				if(num[j]=='-'){ 		// - sign in middle is not allowed, return error code
					*ep = ERR;
					return 0;
				} 
				else{ 			// in case of valid input
					val*=10;
					val += (int)num[j] -(int)('0'); 	// add new digit to current value of input till now
				}
		}
		n = val; // store val calculated in ptr for number
	}
	*ep = OK;
	return n; 	// no error encountered
}

// function to read floating point number from user without standard library functions
int readFlt(float* f)
{
	char temp; 				// temporary character to store char by char input from user
	char num[INT_BUFF];		// buffer to store input entered
	int i=0,j;
	float val = 0;
	int intval = 0; 	// integral value
	int pow = 10; 		// variable to store powers of ten
	while(1){			// loop to continuosly read char by char input from user
		// inline assembly function to read one character from stdin
		__asm__ __volatile__ (
			"syscall":: "a"(0),"D"(0),"S"(&temp),"d"(1) // read 1 byte from stdin and store in address of temp
			);
		// if character entered is space or newline, input ends so break
		if(temp == '\t' || temp == '\n' || temp == ' ')
			break;
		// if entered character is not digit or - sign or ., return error code
		else if((int)(temp-'0')>9 || ((int)(temp-'0')<0 && (temp != '-' && temp != '.'))){
			*f = 0;
			return ERR;
		}
		// else if valid character is entered, append in buffer
		else{
			num[i++] = temp;
		}
	}
	// if first char is -, number is negative
	if(num[0]=='-'){
		// only - sign without digits is not allowed
		if(i==1){
			*f =0;
			return ERR;
		}
		// only -. without digits is not allowed
		else if(i==2 && num[1]=='.'){
			*f = 0;
			return ERR;
		}
		else{
			for(j=1;j<i;j++){
				if(num[j]=='-'){ 	// - sign in anywhere apart from first character is not allowed
					*f = 0;
					return ERR;
				}
				if(num[j]=='.'){ 	// when first . is encountered, break from integral value calcuation
					j++;
					break;
				}
				else{ 							// for valid input
					intval*=10;
					intval+= (int)(num[j]-'0'); 	// add new digit to current value of input till now
				}
			}
			// loop for calculating fractional value after.
			for(;j<i;j++){
				if(num[j]=='-'|| num[j]=='.'){ 	// - or . is not allowed after first . sign
					*f=0;
					return ERR;
				}
				val += (float)(num[j]-'0')/pow; // calculate digit value raised 
												// to corresponding power of ten 
												// and add to value till now
				pow*=10; // update power of ten for next digit
			}
			val+=intval; 	// add integral value to fractional value
			val*=-1; 		// since first char is -, make the number negative
			*f = val; 		// store input value in float pointer parameter
		}
	}
	// if first char is not -, number is positive
	else{
		if(num[0]=='.' && i==1){ 	// only . without digits is not allowed
			*f=0;
			return ERR;
		}
		else{
			for(j=0;j<i;j++){
				if(num[j]=='-'){ 		// negative sign in between is not allowed
					*f=0;
					return ERR;
				}
				else if(num[j]=='.'){ 	// break integral value calculation on first encounter of . sign
					j++;
					break;
				}
				else{
					intval*=10;  	// in case of valid input digit, append to value calcuated till now
					intval+= (int)(num[j]-'0');
				}
			}
			// loop for calculating fractional value after.
			for(;j<i;j++){
				if(num[j]=='-' || num[j] == '.'){	// - or . is not allowed after first . sign
					*f=0;
					return ERR;
				}
				else{
					val += (float)(num[j]-'0')/pow; // calculate digit value raised 
													// to corresponding power of ten 
													// and add to value till now
					pow*=10; 	// update power of ten for next digit
				}
			}
			val+=intval; 	// add integral value to fractional value
			*f = val; 		// store input value in float pointer parameter
		}
	}
	return OK; 	// no error encountered so return ok value
}

// function to print float function without using standard library functions
int printFlt(float f)
{
	int n = (int)f; 	// get integral part of float input given
	int characters=0; 	// initialise number of characters printed
	if(f<0 && n==0)
		characters+=printStr("-");
	characters+=printInt(n); 	// print integral part first and
								// add to the number of characters
	characters+=printStr("."); 	// print . as it is float number
								// add to the number of characters printed
	if(f==n){ 	// if float and integral part are same, no fractional part exits
		characters+=printInt(0); 	// print zero and update number of characters
	}	
	else{ 		
		f-=n; // else, remove integral part from float to get fractional part
		if(f<0){
			f*=-1; 	// if negative number, make it positive as - already printed
		}
		int decimal=f*1000000; 	// default precision printed is 6 digits
								// so multiply fractional part by 10^6
								// to get first 6 digits after .
		characters+=printInt(decimal); 	// print the number obtained and
										// update number of character printed
	}
	if(characters>0)
		return characters; 	// return number of characters printed
	else return ERR; // if number of characters printed are non-positive, error occured. 
}


