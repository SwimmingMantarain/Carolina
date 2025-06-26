#include <stdio.h>

typedef enum {
	TOKEN_IDENTIFIER,
	TOKEN_NUMBER,
	TOKEN_STRING,
	TOKEN_OPERATOR,
	TOKEN_PUNCTUATION,
	TOKEN_KEYWORD,
	TOKEN_EOF,
	TOKEN_UNKNOWN
} TTYPE;

typedef struct {
	TTYPE type;
	char* value;
} Token;

Token create_token(TTYPE type, char* value) {
	Token token = { type, value };
	return token;
};

void lexify(FILE *file) {
	char ch;
	while ((ch = fgetc(file)) != EOF) {
		putchar(ch);
	};


}
