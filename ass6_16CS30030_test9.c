/*-----------------GCD TEST FILE-------------------*/
/***************RECURSIVE APPROACH******************/
/*The following function will test the greatest common divisor of two numbers
using a RECURSIVE APPROACH */
// #include "myl.h"
int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int gcd(int a,int b)
{
	int m,n,h,p;
	if(a==b){
		p= a;
	}
	else
	{
		if(a>b)
		{
			m = a-b;
			n = b;
		}
		else
		{
			m = b-a;
			n = a;
		}
		h = gcd(m,n);
		p= h;
	}
	return p;
}
int main()
{
	int a,b,c,d;
	int*ep;
	// ep = &c;
	printStr("");
	printStr("----------Here we test GCD :---------");
	printStr("Enter 2 numbers for finding their gcd recursively");
	a = readInt(&c);
	printStr("Entered num = ");
	printInt(a);
	b = readInt(&c);
	printStr("Entered num = ");
	printInt(b);
	d = gcd(a,b);
	printStr("The gcd of the 2 numbers you entered is :");
	printInt(d);
	printStr("");
}