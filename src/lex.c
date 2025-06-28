#include <stdio.h>
#include <stdlib.h>

char* read_file(const char* filename, size_t* out_size) {
	FILE* file = fopen(filename, "rb");

	if (!file) return NULL;

	fseek(file, 0, SEEK_END);
	size_t size = ftell(file);
	rewind(file);

	char* buffer = malloc(size + 1); // +1 for NULL terminator
	if (!buffer) { fclose(file); return NULL; }

	fread(buffer, 1, size, file);

	buffer[size] = '\0'; // Add null terminator
	
	fclose(file); // copy pasta
	
	if (out_size) *out_size = size;

	return buffer;
};


void lexify(FILE *file) {
	char ch;
	while ((ch = fgetc(file)) != EOF) {
		switch (ch) {
			default:
				
		}
	};


}
