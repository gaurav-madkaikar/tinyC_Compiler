// Recursive Factorial (Test3.c file)
// Definition
int fibonacci(int n)
{
	if (n >= 1)
		return n * fibonacci(n - 1);
	else
		return 1;
}

int main()
{
	int n;
	n = 8;
	int ans = fibonacci(n);
	printf("Factorial of %d is: %d\n", n, ans);

	// Nested for-Loops
    printf("Demo **** pattern\n");
    for(int i=1; i<=4; i++)
    {
        for(int j=1; j<=i; j++)
        {
            printf("*");
        }
        printf("\n");
    }

	return 0;
}
