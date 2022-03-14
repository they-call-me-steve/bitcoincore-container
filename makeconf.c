#include <stdio.h>

int main() {
	FILE *fptr1, *fptr2;
	char c;
	fptr1 = fopen("/bitcoin/bitcoin.conf", "r");
	if (fptr1 == NULL) {
		return 1;
	}
	fptr2 = fopen("/bitcoin/data/bitcoin.conf", "w+");
	if (fptr2 == NULL) {
		return 1;
	}
	c = fgetc(fptr1);
	while (c != EOF) {
		fputc(c, fptr2);
		c = fgetc(fptr1);
	}
	fclose(fptr1);
	fclose(fptr2);
	return 0;
}
