#include <stdio.h>
#include "lex.h"

#define VERSION "V0.0.1"

void print_usage() {
	printf("Carolina compiler %s\n", VERSION);
	printf("Usage:\n");
	printf("        caro [FLAGS] main.caro main\n");
	printf("\n");
	printf("Flags:\n");
	printf("        - wip\n");
}

int main(int argc, char* argv[]) {
	if (argc == 1) {
		print_usage();
	} else {
		lexify(argv[argc - 2]);

	};
	return 0;
}

