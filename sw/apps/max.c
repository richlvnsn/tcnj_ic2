int max(int num1, int num2);

int main() {
	int x;
	int y;
	int z;
	x = 42;
	y = 1995;
	z = max(x, y);
	return 0;

}

int max(int num1, int num2) {
	int result;
	if (num1 > num2)
		result = num1;
	else
		result = num2;

	return result;
}
