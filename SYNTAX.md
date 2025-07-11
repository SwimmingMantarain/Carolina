# Syntax of Carolina

## Overview

`Carolina` is a compiled programming language I decided to create for fun, learning purposes, and maybe actual practical purposes (rust & zig killer?).
This README describes the syntax of the language. The syntax is inspired by some languages (obscure ones like go and rust) and my own shower thoughts.

## Comments
```caro
// This is a single-line comment

/*
      This is a multi-line comment
*/
```

## Variables
```caro
// Compile-time Constant
const VERSION := "V0.69"; // Type inferred as `str`
const SUB_VER_NUM: int = 420; // Same as below

// Variables
var nice: int; // Declare, but don't define
nice := 69; // Type inferred as `int`
nicer: int = 420; // Explicit type

nice, nicer := 69, "420"; // Type inferred as `int` & `str` 
```

## Functions
```
func add(x: int, y: int) -> int {
    return x + y;
}

func main() {
    var result: int;
    result = add(42, 27);
    io.print("This is nice: %\n", result);
}
```

## Control Flow
```caro
if !nice {
    io.print("Not nice! :(\n");
} else {
    io.print("%, Nice! :)\n", nice);
}

isnice := if nice == 69 true, false
// First value is returned if true, second if false
```

## Boolean Logic
```caro
// Boolean Operators
x && y // AND
x || y // OR
x <= y // Less than or equal to
x == y // Equal to
x != y // Not equal to
x > y  // Greater than
x < y  // Less than
x >= y // Greater than or equal to
```
