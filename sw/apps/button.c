#define TRISTATE 0x8008;
#define PINSTATE 0x800C;
#define DATAREG 0x8014;

void delay();

int main() {
	int *p = (int*) TRISTATE;
	int *pinState = (int*) PINSTATE;

	*p = 0x7FFF; 
	p = (int*) DATAREG;
	*p = 2;
	int input = 0;
	while(1)
	{
		input = *pinState & 0x8000;
		if (input == 0x8000)
		{
			*p = 3;
			delay(50000);
			*p = 2;
		}
	}
	return 0; 
}
