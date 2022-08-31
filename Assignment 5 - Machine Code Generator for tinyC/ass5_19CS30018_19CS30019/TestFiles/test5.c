// Test 5.c file
// Recursive euclidean geometry 
int euclidGCD(int a, int b) 
{ 
    if (a == 0) 
        return b; 
    return euclidGCD(b % a, a); 
} 

int main()  
{  
    int a = 193, b = 142;
    int g_c_d = euclidGCD(b, a);

    int *ptr1, *ptr2, a, b;
    a = 5;
    b = 19;
    ptr1 = &a;
    ptr2 = &b;

    
    return 0;  
}