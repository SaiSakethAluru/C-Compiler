//This test file extensively checks the expressions both boolean and algebraic
//and also the funciton calling and returning process in detail

int printStr(char *c);
int printInt(int i);
int readInt(int *eP);
int a;
int b = 1;
char c;
char d = 'a';

int add (int a, int b) {
  int ans;
  int c = 2, d, arr[10];
  int*p;
  printStr("got into function\n");
  ans = a+b;
  d = 2;
  if (a>=d) {
    a++;
  }
  else {
    c = a+b;
  }
  printStr("returning from function\n");
  return ans;
}
int main () {
  int c = 2, d, arr[10];
  int*p;
  int x, y, z;
  int eP;
  printStr("Enter two numbers :\n");
  x = readInt(&ep);
  y = readInt(&ep);
  z = add(x,y);
  printStr("Sum is equal to ");
  printInt(z);
  printStr("\n");
  return 0;
}