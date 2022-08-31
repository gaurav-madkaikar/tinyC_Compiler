// GCD Calculation
int euclidGCD(int a, int b)
{
    if (a == 0)
        return b;
    else
        return euclidGCD(b % a, a);
}

int main()
{
    int a, b, gcd;
    printStr("--GCD Calculator-- \n");
    printStr("Enter the value of a\n");
    int err = 1;
    a = readInt(&err);
    printStr("Enter the value of b\n");
    b = readInt(&err);
    gcd = euclidGCD(a, b); // recursive function call
    printStr("Greatest Common Divisor: ");
    printInt(gcd);
    printStr("\n");

    return 0;
}
