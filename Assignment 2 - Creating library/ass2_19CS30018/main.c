// Compilers Laboratory, Assignment 2
// Gaurav Madkaikar, 19CS30018
// File: main.c

// Header file "myl.h"
#include "myl.h"

#include <stdio.h>   // used only for accepting the input string

const int maxSz = 100;

int main()
{
    // Test the library functions

    printStr("++++++++++++++++++++++++++++++ Compilers Laboratory Assignment 2 ++++++++++++++++++++++++++++++\n");

    printStr("------------ 1) Test for printStr() ---------------");
    printStr("Enter the test string:");
    // Input string
    char str[maxSz];
    scanf("%[^\n]s", str); // used for obtaining the string input

    printStr("Your entered string is displayed as:");
    int chars = printStr(str);
    printStr("Number of characters");
    printInt(chars);

    printStr("\n------------ 2) Test for printInt() and readInt() ---------------");

    printStr("Printing sample values");
    int n1 = -476732, n2 = 2147483647, n3 = -2147483647, n4 = 992382, n5 = -66313922;
    printStr("+++++++++++++++++");
    int flg1 = printInt(n1);
    int flg2 = printInt(n2);
    int flg3 = printInt(n3);
    int flg4 = printInt(n4);
    int flg5 = printInt(n5);
    printStr("+++++++++++++++++\n");

    printStr("Enter your test integer:");
    // Integer input
    int numInt;
    int flg6 = readInt(&numInt);
    if (flg6)
    {
        printStr("Successfully stored!");
        printInt(numInt);
    }
    else
        printStr("ERROR: Invalid input format!");

    printStr("\n------------ 3) Test for printFlt() and readFlt() ---------------");

    printStr("Printing sample values");
    float fl1 = -7416265882365.6278E-11, fl2 = 0.08241050, fl3 = 102.00431, fl4 = 0.8274623421E15, fl5 = -8300E-1;
    printStr("+++++++++++++++++");
    printFlt(fl1);
    printFlt(fl2);
    printFlt(fl3);
    printFlt(fl4);
    printFlt(fl5);
    printStr("+++++++++++++++++\n");

    printStr("Enter your floating-point value:");
    // Floating-point input
    float numFlt;
    int flg7 = readFlt(&numFlt);
    if (flg7)
    {
        printStr("Successfully stored!");
        printFlt(numFlt); // 6 decimal places
    }
    else
        printStr("ERROR: Invalid input!");

    printStr("\n------------------------- END OF THE PROGRAM ------------------------");

    return 0;
}
