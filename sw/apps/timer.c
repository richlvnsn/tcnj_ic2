#define TRISTATE 0x8008;
#define PINSTATE 0x800C;
#define DATAREG 0x8014;
#define TRIGSTART 0x801C;
#define TRIGHALT 0x8020;
#define RFMODE 0x08024;
#define TERMCOUNT 0x8028;
#define STATUS 0x802C;
#define CURRENTCOUNT 0x8030;

void delay();

int main() {
	int *p = (int*) TRISTATE;
	*p = 0xFFFF; 
	p = (int*) DATAREG;

	// Setting terminal coun
	int *t = (int*) TERMCOUNT;
	*t = 50000000;

	// Setting mode to One shot (0)
	t = (int*) RFMODE;
	*t = 0;

	// Starting timer
	t = (int*) TRIGSTART;
	*t = 1;
	*t = 0;

	/*t = (int*) CURRENTCOUNT;
	//t = (int*) STATUS;
	int count = 0;

	int *halt = (int*) TRIGHALT;
	int *status = (int*) STATUS;
	int *start = (int*) TRIGSTART;*/
	while(1)
	{
		*p = 1;
		delay(10000000);
		*p = 0;
		delay(10000000);
	}

}