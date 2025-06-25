#include <stdio.h>

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
	// Declare input and output files
	char *ifile;
	char *ofile;


	if (argc == 1) {
		// Print usage if no arguments passed
		print_usage();
	} else {
		// For now get the input and output file names, will be changed later
		ifile = argv[argc - 2];
		ofile = argv[argc - 1];
		printf("Input: %s, Output: %s\n", ifile, ofile);

		// Open input file
		FILE *file = fopen(ifile, "r");
		
		if (file == NULL) {
			perror("Error opening file!\n");
		};
	};

	return 0;
}

