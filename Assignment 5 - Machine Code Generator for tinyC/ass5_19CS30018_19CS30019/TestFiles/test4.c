// Test4.c file
// Transpose of a 2-D matrix

int main()
{
	// 2-D matrix
	int matrix[5][5];
	int i, j, r, c;

	printf("\nEnter matrix elements :\n");
	for (i = 0; i < 5; i++)
	{
		for (j = 0; j < 5; j++)
		{
			printf("Enter element [%d,%d] : ", i + 1, j + 1);
			scanf("%d", &matrix[i][j]);
		}
	}

	/* Transpose a matrix */
	printf("\nTranspose Matrix is :");
	for (i = 0; i < c; i++)
	{
		for (j = 0; j < r; j++)
		{
			printf("%d\t", matrix[j][i]); /* print elements */
		}
		printf("\n"); /* after each row print new line */
	}
	return 0;
}