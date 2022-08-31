// Compilers Laboratory, Assignment 2
// Gaurav Madkaikar, 19CS30018
// File: ass2_19CS30018.c

#include "myl.h"

#define MAX_INT 2147483647
#define MIN_INT -2147483647

const int strBuff = 100, numBuff = 12;

int printStr(char *str)
{
    char inputString[strBuff];
    int length = 0;

    // find the length of the input string
    while (str[length] != '\0')
    {
        inputString[length] = str[length];
        length++;
    }

    // append a newline character at the end
    inputString[length] = '\n';
    inputString[length + 1] = '\0';

    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t" // stdout
        "syscall \n\t"
        :
        : "S"(inputString), "d"(length + 1) // Number of characters printed = (length + 1)
    );
    // return the numer of characters
    return (length + 1);
}

int printInt(int num)
{
    char numString[100];
    int length = 0, digit;

    // store the number in numString[]
    if (num == 0)
        numString[length++] = '0';

    else
    {
        if (num > 0)
        {
            while (num > 0)
            {
                digit = (num % 10);
                numString[length++] = (char)(digit + 48);
                num /= 10;
            }
        }
        else
        {
            numString[length++] = '-';
            num = -num;

            while (num > 0)
            {
                digit = (num % 10);
                numString[length++] = (char)(digit + 48);
                num /= 10;
            }
        }
    }

    // check for negative sign
    int left, right;
    if (numString[0] == '-')
        left = 1;
    else
        left = 0;

    right = length - 1;

    // reverse the number stored in the string
    char temp;
    while (left < right)
    {
        temp = numString[left];
        numString[left++] = numString[right];
        numString[right--] = temp;
    }

    // append a newline character at the end
    numString[length] = '\n';
    numString[length + 1] = '\0';

    __asm__ __volatile__(
        "movl $1, %%eax \n\t" // SYS_write
        "movq $1, %%rdi \n\t" // stdout
        "syscall \n\t"
        :
        : "S"(numString), "d"(length + 1)); // Number of characters in numString = (length + 1) {Number + '\n'}

    return (length + 1);
}

int readInt(int *num)
{
    long int checkNum = 0;
    int resNum;         // final result

    int noOfChars, left, right;
    char numString[20]; // input stored here

    __asm__ __volatile__(
        "movl $0, %%eax \n\t" // SYS_read
        "movq $0, %%rdi \n\t" // stdin
        "syscall \n\t"
        : "=a"(noOfChars)         // number of characters in the input string
        : "S"(numString), "d"(20) // output operands
    );
    
    // no characters read
    if ((noOfChars <= 0))
        return ERR;

    // ignore the trailing newline character
    noOfChars--;

    left = 0;
    right = noOfChars - 1;

    // remove leading and trailing spaces
    while (numString[left] == ' ')
        left++;

    while ((right > 0) && (numString[right] == ' '))
        right--;

    int flg = 0;
    // check for negative sign
    if (numString[left] == '-')
    {
        flg = 1;
        left++;
    }

    // check for existence of invalid characters
    for (int i = left; i <= right; i++)
    {
        if ((numString[i] >= 48) && (numString[i] <= 57))
            continue;
        else
            return ERR;
    }

    // calculate the resultant number
    for (int i = left; i <= right; i++)
        checkNum = (checkNum * 10) + (numString[i] - '0');

    // checks for overflow and underflow
    if ((checkNum > MAX_INT) || (checkNum < MIN_INT))
        return ERR;
    else
        resNum = checkNum;

    if (flg)
        *num = -resNum;
    else
        *num = resNum;

    return OK;
}

int readFlt(float *num)
{
    float resNum = 0;
    int noOfChars, left, right;
    char numString[30];

    __asm__ __volatile__(
        "movl $0, %%eax \n\t" // SYS_read
        "movq $0, %%rdi \n\t" // stdin
        "syscall \n\t"
        : "=a"(noOfChars)         // number of characters in the input string
        : "S"(numString), "d"(30) // output operands
    );

    // number of characters read
    if ((noOfChars <= 0) || (noOfChars > 27))
        return ERR;

    // ignore the trailing newline character
    noOfChars--;

    left = 0;
    right = noOfChars - 1;

    // remove leading and trailing spaces
    while (numString[left] == ' ')
        left++;
    while ((right > 0) && (numString[right] == ' '))
        right--;

    int flg = 0;
    // check for negative sign
    if (numString[left] == '-')
    {
        flg = 1;
        left++;
    }

    int occD = -1, occE = -1; // check occurrences
    int posD = 0, posE = 0;   // store positions
    int negExp = -1;          // check for exponent
    int exponent = 0;         // store the exponent if, it exists

    for (int i = left; i <= right; i++)
    {
        if (numString[i] == '.')
        {
            occD++;
            if (occD > 0)
                return ERR;

            posD = i;
        }

        else if ((numString[i] >= 48) && (numString[i] <= 57))
            continue;

        else if ((numString[i] == 'E') || (numString[i] == 'e'))
        {
            if (i == right)
                return ERR;

            occE++;
            if (occE > 0)
                return ERR;

            posE = i;
        }
        else if ((i > 0) && (numString[i] == '-') && ((numString[i - 1] == 'E') || (numString[i - 1] == 'e')))
        {
            negExp++;
            if (negExp > 0)
                return ERR;
        }
        else
            return ERR;
    }
    // return ERR if decimal point is placed after E/e
    if ((!occD) && (!occE) && (posD > posE))
        return ERR;

    if ((occD == -1) && (occE == -1)) // plain integer
    {
        for (int i = left; i <= right; i++)
            resNum = (resNum * (float)10.0) + (float)(numString[i] - '0');
    }
    else if ((!occD) && (occE == -1)) // only occurence of decimal point
    {
        float fracNum = (float)1.0;
        for (int i = left; i < posD; i++)
        {
            resNum = (resNum * (float)10.0) + (float)(numString[i] - '0');
        }
        for (int i = posD + 1; i <= right; i++)
        {
            fracNum /= (float)10.0;
            resNum += fracNum * (float)(numString[i] - '0');
        }
    }
    else if ((!occD) && (!occE)) // occurrence of both decimal point and E/e
    {
        float fracNum = (float)1.0;

        for (int i = left; i < posD; i++)
        {
            resNum = (resNum * (float)10.0) + (float)(numString[i] - '0');
        }
        for (int i = posD + 1; i < posE; i++)
        {
            fracNum /= (float)10.0;
            resNum += fracNum * (float)(numString[i] - '0');
        }

        if (negExp == 0) // if exponent is negative, divide by 10
        {
            for (int i = posE + 2; i <= right; i++)
                exponent = (exponent * 10) + (numString[i] - '0');
            for (int i = 1; i <= exponent; i++)
                resNum /= (float)10.0;
        }
        else // if exponent is positive, multiply by 10
        {
            for (int i = posE + 1; i <= right; i++)
                exponent = (exponent * 10) + (numString[i] - '0');
            for (int i = 1; i <= exponent; i++)
                resNum *= (float)10.0;
        }
    }
    else // only occurrence of E/e
    {
        for (int i = left; i < posE; i++)
            resNum = (resNum * (float)10.0) + (float)(numString[i] - '0');

        if (negExp == 0) // if exponent is negative, divide by 10
        {
            for (int i = posE + 2; i <= right; i++)
                exponent = (exponent * 10) + (numString[i] - '0');
            for (int i = 1; i <= exponent; i++)
                resNum /= (float)10.0;
        }
        else // if exponent is positive, multiply by 10
        {
            for (int i = posE + 1; i <= right; i++)
                exponent = (exponent * 10) + (numString[i] - '0');
            for (int i = 1; i <= exponent; i++)
                resNum *= (float)10.0;
        }
    }

    // check if number is negative
    if (flg)
        resNum = -resNum;

    // store the result
    *num = resNum;

    return OK;
}

int printFlt(float num)
{
    char numString[100];
    int length = 0, left = 0, right = 0, mid;

    int cntFrac = 0, cntInt = 0;

    int digit;
    char temp;

    // extract the Integral and Fractional parts
    long int intPart = (long int)num;
    long int fracPart = (long int)((num - intPart) * (float)1000000.0);

    // store the floating-point number
    if (intPart == 0)
        numString[length++] = '0';
    else
    {
        if (intPart < 0)
        {
            intPart = -intPart;
            fracPart = -fracPart;

            numString[length++] = '-';
            left = 1;
        }

        while (intPart > 0)
        {
            cntInt++;
            digit = (intPart % 10);
            intPart /= 10;
            numString[length++] = (char)(digit + 48);
        }

        mid = length - 1;

        // place the values in the reverse order
        while (left < mid)
        {
            temp = numString[left];
            numString[left++] = numString[mid];
            numString[mid--] = temp;
        }
    }
    // place the decimal point
    numString[length++] = '.';

    int zeroCnt = 0, i = 1;

    // place the fractional values
    if (fracPart == 0) // fill all zeroes
    {
        while ((i++) < 7)
            numString[length++] = '0';
    }
    else
    {
        int tmpVar = fracPart;
        while (tmpVar < 1000000) // fill required zeroes (left-padding)
        {
            tmpVar *= 10;
            zeroCnt++;
        }
        while ((i++) < zeroCnt)
        {
            numString[length++] = '0';
        }

        mid = length;

        // extract the fractional part
        while (fracPart > 0)
        {
            cntFrac++;
            digit = (fracPart % 10);
            fracPart /= 10;
            numString[length++] = (char)(digit + 48);
        }

        right = length - 1;

        // place the fractional values in the reverse order
        while (mid < right)
        {
            temp = numString[mid];
            numString[mid++] = numString[right];
            numString[right--] = temp;
        }
    }

    numString[length] = '\n';
    numString[length + 1] = '\0';

    // print in exponential form if integer count is >5
    if (cntInt > 5)
    {
        char fltPt[length + 1];

        int prec = 0, start, expVal = cntInt - 1;
        if (numString[0] == '-')
        {
            start = 3;
            prec = 7;

            fltPt[0] = '-';
            fltPt[1] = numString[1];
            fltPt[2] = '.';
        }
        else
        {
            start = 2;
            prec = 6;
            fltPt[0] = numString[0];
            fltPt[1] = '.';
        }

        for (int i = start; i < prec; i++)
        {
            fltPt[i] = numString[i - 1];
        }

        // place the exponent E
        fltPt[prec++] = 'E';

        int pos1 = prec, pos2;
        // place the exponent
        while (expVal > 0)
        {
            fltPt[prec++] = (char)((expVal % 10) + 48);
            expVal /= 10;
        }
        pos2 = prec - 1;

        // reverse the order of the exponent
        while (pos1 < pos2)
        {
            temp = fltPt[pos1];
            fltPt[pos1++] = fltPt[pos2];
            fltPt[pos2--] = temp;
        }
        fltPt[prec] = '\n';
        fltPt[prec + 1] = '\0';

        __asm__ __volatile__(
            "movl $1, %%eax \n\t" // SYS_write
            "movq $1, %%rdi \n\t" // stdout
            "syscall \n\t"
            :
            : "S"(fltPt), "d"(prec + 1)
        );

        // return the number of characters printed
        return (prec + 1);
    }

    __asm__ __volatile__(
        "movl $1, %%eax \n\t" // SYS_write
        "movq $1, %%rdi \n\t" // stdout
        "syscall \n\t"
        :
        : "S"(numString), "d"(length + 1));

    // return the number of characters printed
    return (length + 1);
}
