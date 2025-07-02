package lex

import (
	"bufio"
	"fmt"
	"os"
)

func checkNextChar(runes []rune, index int, expectedChar rune) bool {
	if index+1 < len(runes) && expectedChar == runes[index+1] {
		return true
	} else {
		return false
	}
}

func isLetter(char byte) bool {
	return 'a' <= char && char <= 'z' || 'A' <= char && char <= 'Z' || char == '_'
}

func isDigit(char byte) bool {
	return '0' <= char && char <= '9'
}

func isAmericanSpace(char rune) bool {
	return char == ' ' || char == '\n' || char == '\t' || char == '\r'
}

func isKeyword(ident string) bool {
	_, ok := Keywords[ident]
	return ok
}

func readChars(runes []rune, index int) string {
	var str string
	for index < len(runes) && (isLetter(byte(runes[index])) || isDigit(byte(runes[index]))) {
		str += string(runes[index])
		index++
	}
	return str
}

func Lex(filename string) []Token {
	file, err := os.Open(filename)
	if err != nil {
		fmt.Printf("Failed to open `%s`\n", filename)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	tokens := []Token{}

	lineNum := 0
	for scanner.Scan() {
		lineNum++ // starts @ 1
		line := scanner.Text()
		runes := []rune(line)

		colNum := 0
		for colNum < len(runes) {
			ch := runes[colNum]
			switch ch {
			case '-':
				if checkNextChar(runes, colNum, '>') {
					tokens = append(tokens, Token{Type: ARR, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '-') {
					tokens = append(tokens, Token{Type: DEC, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: MIN_E, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: MIN, Line: lineNum, Col: colNum + 1})
				}
			case '+':
				if checkNextChar(runes, colNum, '+') {
					tokens = append(tokens, Token{Type: INC, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: ADD_E, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: ADD, Line: lineNum, Col: colNum + 1})
				}
			case '*':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: MUL_E, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '/') {
					tokens = append(tokens, Token{Type: COM_BLOCK_END, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: MUL, Line: lineNum, Col: colNum + 1})
				}
			case '/':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: DIV_E, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '*') {
					tokens = append(tokens, Token{Type: COM_BLOCK_START, Line: lineNum, Col: colNum + 1})
					colNum++
				} else if checkNextChar(runes, colNum, '/') {
					tokens = append(tokens, Token{Type: COM, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: DIV, Line: lineNum, Col: colNum + 1})
				}
			case '=':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: EQ, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: ASS, Line: lineNum, Col: colNum + 1})
				}
			case '!':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: NOT_EQ, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: BANG, Line: lineNum, Col: colNum + 1})
				}
			case '<':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: LTE, Line: lineNum, Col: colNum + 1})
				} else {
					tokens = append(tokens, Token{Type: LT, Line: lineNum, Col: colNum + 1})
				}
			case '>':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: GTE, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: GT, Line: lineNum, Col: colNum + 1})
				}
			case ':':
				if checkNextChar(runes, colNum, '=') {
					tokens = append(tokens, Token{Type: DEF, Line: lineNum, Col: colNum + 1})
					colNum++
				} else {
					tokens = append(tokens, Token{Type: COL, Line: lineNum, Col: colNum + 1})
				}
			case ',':
				tokens = append(tokens, Token{Type: COMMA, Line: lineNum, Col: colNum + 1})
			case '(':
				tokens = append(tokens, Token{Type: LPAREN, Line: lineNum, Col: colNum + 1})
			case ')':
				tokens = append(tokens, Token{Type: RPAREN, Line: lineNum, Col: colNum + 1})
			case '[':
				tokens = append(tokens, Token{Type: LBRACKET, Line: lineNum, Col: colNum + 1})
			case ']':
				tokens = append(tokens, Token{Type: RBRACKET, Line: lineNum, Col: colNum + 1})
			case '{':
				tokens = append(tokens, Token{Type: LBRACE, Line: lineNum, Col: colNum + 1})
			case '}':
				tokens = append(tokens, Token{Type: RBRACE, Line: lineNum, Col: colNum + 1})
			case ';':
				tokens = append(tokens, Token{Type: SEMIC, Line: lineNum, Col: colNum + 1})
			case 0:
				tokens = append(tokens, Token{Type: EOF, Line: lineNum, Col: colNum + 1})
			default:
				if isLetter(byte(runes[colNum])) {
					ident := readChars(runes, colNum)
					if isKeyword(ident) {
						tokens = append(tokens, Token{Type: KEYW, Line: lineNum, Col: colNum + 1, Value: ident})
					} else {
						tokens = append(tokens, Token{Type: IDENT, Line: lineNum, Col: colNum + 1, Value: ident})
					}
					colNum += len(ident)
				} else if isDigit(byte(runes[colNum])) {
					num := readChars(runes, colNum)
					tokens = append(tokens, Token{Type: INT, Line: lineNum, Col: colNum + 1, Value: num})
					colNum += len(num)
				} else if isAmericanSpace(runes[colNum]) {
					// dunno
				} else {
					fmt.Printf("!%c!", runes[colNum])
				}

			}

			colNum++
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Printf("Error scanning lines of `%s`\n", filename)
	}

	return tokens
}
