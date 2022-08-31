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

// Binary Search on an array
int main()
{
	int arr[10], n, err = 1, i, srch;
	printStr("Enter the size of the array (<10): ");
	n = readInt(&err);
	printStr("Enter a sorted array of size ");
	printInt(n);
	printStr(":\n");
	for (i = 0; i < n; i++)
	{
		arr[i] = readInt(&err);
	}
	n--;
	printStr("Enter the number to be searched: ");
	srch = readInt(&err);

	int loc = bSearch(arr, 0, n, srch);

	if(loc == -1)
		printStr("Number not present!");
	else
	{	
		loc++;
		printStr("Number found at position ");
		printInt(loc);
	}

	printStr("\n");
	return 0;
}