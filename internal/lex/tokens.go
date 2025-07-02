package lex

const (
	EOF  = "EOF"
	KEYW = "KEYW"

	INT             = "INT"
	IDENT           = "IDENT"
	COM             = "//"
	COM_BLOCK_START = "/*"
	COM_BLOCK_END   = "*/"

	// KEYWORDS
	IF     = "if"
	ELSE   = "else"
	FOR    = "for"
	RETURN = "return"
	FUNC   = "func"
	VAR    = "var"
	TRUE   = "true"
	FALSE  = "false"

	// Operators
	ADD    = "+"
	ADD_E  = "+="
	INC    = "++"
	MIN    = "-"
	MIN_E  = "-="
	DEC    = "--"
	MUL    = "*"
	MUL_E  = "*="
	DIV    = "/"
	DIV_E  = "/="
	ASS    = "="
	DEF    = ":="
	COL    = ":"
	EQ     = "=="
	NOT_EQ = "!="
	BANG   = "!"
	LT     = "<"
	GT     = ">"
	LTE    = "<="
	GTE    = ">="
	ARR    = "->"

	// Delimiters
	COMMA    = ","
	LPAREN   = "("
	RPAREN   = ")"
	LBRACE   = "{"
	RBRACE   = "}"
	LBRACKET = "["
	RBRACKET = "]"
	SEMIC    = ";"
)

var Keywords = map[string]string{
	"func":   FUNC,
	"var":    VAR,
	"true":   TRUE,
	"false":  FALSE,
	"if":     IF,
	"else":   ELSE,
	"return": RETURN,
}

type Token struct {
	Type  string
	Value string
	Line  int
	Col   int
}
