#define TRISTATE 0x8008;
#define DATAREG 0x8014;

void delay();

/*
addi - add immediate
slli - shift logical left immediate
li/lui - load immediate/upper immediate
lw - load word
sw - store word
bne - branch not equal
bnez - branch not equal zero
j
*/

int main() {
	// Writing all 1s to tristate register
	int *p = (int*) TRISTATE;
	*p = 0xFFFF;

	// Switching pointer to data register
	p = (int*) DATAREG;
	int x = 1;
	int count = 0;
	while(1)
	{
		*p = x; // writing x to data register
		x = x << 1; // shifting 1 over
		count++;
		if (count == 16)
		{
			x = 1;
			count = 0;
		}
		delay(25000000); // delay for 1 second
	}
	return 0; 
}
