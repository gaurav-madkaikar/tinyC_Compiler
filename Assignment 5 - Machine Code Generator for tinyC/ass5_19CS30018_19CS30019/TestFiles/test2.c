// Test2.c file

// This function swaps values pointed by xp and yp
void swap(int *xp, int *yp)
{
	int temp = *xp;
	*xp = *yp;
	*yp = temp;
}

int max(int x, int y)
{
	int ans;
	if (x > y)
		ans = x;
	else
		ans = y;
	return ans;
}

int min(int x, int y)
{
	int ans;
	ans = x > y ? y : x; 
	return ans;
}

int difference(int x, int y)
{
	int i, j, diff;
	i = max(x, y); 
	j = min(x, y);
	diff = i - j;
	return diff;
}

int main()
{
	int a, b;
	a = 29;
	b = 10;
	int ansdiff = difference(b, a);
	int ansmax = max(a, b);

	int x = 13, y = 15;
	int ansmin = min(x, y);

	printf("Values before swapping: %d %d \n", x, y);
	swap(&x, &y);
	printf("Values after swapping: %d %d \n", x, y);

	return 0;
}