#define TRISTATE 0x8008;
#define PINSTATE 0x800C;
#define DATAREG 0x8014;

void delay();
void checkButton1();

int main() {
	int *p = (int*) TRISTATE;
	int *pinState = (int*) PINSTATE;
	int dotPos = 0x80;
	int right = 1;
	int iter = 50;
	int score = 0;

	*p = 0x7FFF; 
	p = (int*) DATAREG;
	while(1)
	{
		*p = score + dotPos;
		//checkButton1(p, pinState, dotPos);
		for (int i = 0; i < iter; i++)
		{
			checkButton1(p, pinState, dotPos, score);
			delay(50000);
		}
		if (right)
		{
			dotPos = dotPos >> 1;
		}
		else
		{
			dotPos = dotPos << 1;
		}
		if ((*p & 1) == 1 && dotPos == 1)
		{
			right = 0;
			if (iter > 10)
				iter -= 5;
			dotPos = dotPos << 2;
			score += 1 << 8;
		}
		else if (dotPos == 0)
		{
			dotPos = 0x80;
			iter = 50;
			score = 0;
		}
		else if (dotPos == 0x80)
		{
			right = 1;
		}
		//delay(25000000);
	}
}

void checkButton1(int *p, int *pinState, int dotPos, int score)
{
	if (((*pinState & 0x8000)==0x8000) && dotPos != 1)
	{
		*p = (score + dotPos | 1);
	}
	else if (dotPos != 1)
	{
		*p = ((score + dotPos) & 0xFFFE);
	}
}