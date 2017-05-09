#define TRISTATE 0x8008;
#define PINSTATE 0x800C;
#define DATAREG 0x8014;

void delay();

int main() {
	int *p = (int*) TRISTATE;
	int *pinState = (int*) PINSTATE;

	*p = 0x7FFF; 
	p = (int*) DATAREG;
	/*int regVal = *p; //read 0x8004
	regVal = regVal & 0xFFFF00FF; //mask bits we want to change
	regVal = regVal | 0x00000200; //write bits using or
	*p = regVal; //write final values*/
	*p = 2;
	int input = 0;
	while(1)
	{
		//delay(1000);
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


/*int main() {
	int *p = (int*) 0x8002;
	int *pinState = (int*) 0x8003;
	*p = 0x7FFF;
	p = (int*) 0x8005;
	*p = 2;
	int input = 0;
	while(1)
	{
		//delay(1000);
		input = *pinState & 0x8000;
		if (input == 0x8000)
		{
			*p = 3;
			delay(50000);
			*p = 2;
		}
	}
	return 0; 
}*/
