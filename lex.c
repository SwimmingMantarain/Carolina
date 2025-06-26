#include <stdio.h>

void lexify(FILE *file) {
	char ch;
	while ((ch = fgetc(file)) != EOF) {
		putchar(ch);
	};
}
