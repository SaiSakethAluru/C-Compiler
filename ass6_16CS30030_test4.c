// //test file to check basic statements, expression, readInt and printInt library 
// //functions created in assignment 2
int printStr(char *c);
int printInt(int i);
int readInt(int *eP);

//it checks function declarations,definition and calling,  if-else, global values, etc

int global_val = 4;



void sample_void_function(int int_var_init, int elements)
{
  printInt(int_var_init);
  printStr("\n");
}

int sample_int_function(int int_var_init, int elements,int value)
{
  int i ,passes = 0 ;
  if(int_var_init>= value)
    passes++;
  return(passes);
}

int main()
{
  int int_var_init=10;
  int int_val_declare;
  int array[6];
  global_val=5;
  sample_void_function(int_var_init,10);
  int_val_declare = sample_int_function(int_var_init,10,2);
  if(int_val_declare == 1){
    printStr("There was ");
    printInt(int_val_declare);
    printStr(" pass.\n");
  }
  else{
    printStr("There were ");
    printInt(int_val_declare);
    printStr(" passes.\n");
  }
  return 0;
}