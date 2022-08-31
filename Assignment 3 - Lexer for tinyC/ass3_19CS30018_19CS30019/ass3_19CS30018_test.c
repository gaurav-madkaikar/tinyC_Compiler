/*
*** Compilers lab Assignment 3
Group No: 24
Group Members: Gaurav Madkaikar, Girish Kumar 
*/

#include <stdio.h>

typedef struct emp{
    char *name;
    char *position;
    int age;
    int yearsWorked;
}Employee;

#define MAXPRIME 1000000007
  
int bSearch(int arr[], int l, int r, int key)
{
    if (r >= l) 
    {
        int mid = l + (r - l) / 2;
  
        if (arr[mid] == key)
            return mid;
  
        if (arr[mid] > key)
            return bSearch(arr, l, mid - 1, key);

        return bSearch(arr, mid + 1, r, key);
    }
  
    // Return if element is not present in array
    return -1;
}

int main()
{
    // Check for data types and constants
    int a = -15;
    float PI = 3141.5E3;
    double accuracy = .921e-03;

    char ch = 'S';
    char str[15] = "Hello World!\t\n";
    int arr[5] = {-2, 4, 5, 7, 10};

    Employee emp1;

    /* Multi line comment. 
    Search in a sorted array using:
    Binary Search */

    // Search for -2 in arr
    int loc = bSearch(arr, 0, 4, -2);

    printf("Element %d found at position %d\n", arr[0], loc + 1);

    // Loops
    printf("Demo **** pattern\n");
    for(int i=1; i<=4; i++)
    {
        for(int j=1; j<=i; j++)
        {
            printf("*");
        }
        printf("\n");
    }

    // Punctuators
    /* Guess the value */
    int tmpVal = 100;
    tmpVal <<= 2;
    tmpVal += 321;
    tmpVal -= 21;
    tmpVal &= 5;
    printf("tmpVal = %d\n", tmpVal);

    return 0;
}