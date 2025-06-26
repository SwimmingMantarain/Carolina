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
	char *ifile;
	//char *ofile;


	if (argc == 1) {
		print_usage();
	} else {
		ifile = argv[argc - 2];
		//ofile = argv[argc - 1];

		FILE *file = fopen(ifile, "r");
		
		if (file == NULL) {
			perror("Error opening file!\n");
		} else {
			lexify(file);
			fclose(file);
		};
	};
	return 0;
}

