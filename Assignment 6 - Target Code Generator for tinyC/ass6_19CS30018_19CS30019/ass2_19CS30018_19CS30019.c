// Assignment 2 - Read/Write library with system calls
// Gaurav Madkaikar, 19CS30018

#include "myl.h"
#define MAX 50

// Return the length of the string
int printStr(char *str)
{
    int bytes = 0;
    int buffer_length = 0;
    while (str[bytes] != '\0')
    {
        bytes++;
        buffer_length = buffer_length + 1;
    }
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        : "S"(str), "d"(bytes));
    buffer_length++;
    return bytes;
}

// Print an integer
int printInt(int n)
{
    char buff[MAX], zero = '0';
    int buffer_length = 0;
    int i = 0, j = 0, bytes, k;
    if (n < 0)
    {
        n = -n;
        buff[i++] = '-';
        buffer_length++;
    }
    if (n == 0)
    {
        buff[i++] = zero;
        buffer_length++;
    }
    // Convert the number from string format to integer
    while (n != 0)
    {
        buffer_length++;
        buff[i++] = (char)(n % 10 + zero);
        n = n / 10;
    }
    // Preserve the final sign (ie. shift the number towards the right to accomodate '-' sign)
    if (buff[0] == '-')
    {
        j = 1;
        buffer_length++;
    }
    k = i - 1;
    buffer_length++;
    bytes = i;
    while (j < k)
    {
        char tmp;
        tmp = buff[j];
        buffer_length++;
        buff[j] = buff[k];
        buffer_length++;
        buff[k] = tmp;
        buffer_length++;
        j++;
        k--;
    }
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        : "S"(buff), "d"(bytes));
    buffer_length++;
    return bytes;
}

// Store an integer in memory
int readInt(int *eP)
{
    int i = 0;
    char str[10];
    int buffer_length = 0;
    int sign = 1, val = 0;
    *eP = OK;
    while (1)
    {
        __asm__ __volatile__("syscall" ::"a"(0), "D"(0), "S"(str), "d"(1));
        if (str[0] == ' ' || str[0] == '\t' || str[0] == '\n')
        {
            buffer_length++;
            break;
        }
        if (!i && str[0] == '-')
        {
            buffer_length++;
            sign = -1;
        }
        else
        {
            buffer_length++;
            if (str[0] > '9' || str[0] < '0')
            {
                buffer_length++;
                *eP = ERR;
            }
            else
            {
                buffer_length++;
                val = 10 * val + (int)(str[0] - '0');
            }
        }
        buffer_length++;
        i++;
    }
    return val * sign;
}
