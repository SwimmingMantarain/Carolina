package main

import (
	"flag"
	"fmt"

	"github.com/SwimmingMantarain/Carolina/internal/lex"
)

func main() {
	//oFlagPtr := flag.String("o", "main", "-o [OUT FILE NAME]")
	inputFilePtr := flag.String("i", "main.caro", "-i [IN FILE NAME(S)]")
	flag.Parse()

	tokens := lex.Lex(*inputFilePtr)

	fmt.Println(tokens[:20])
}
