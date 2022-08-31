# Intermediate Code Generation for tinyC 

### Group 24: 19CS30018, 19CS30019
### Instructions to build the project
```
make
```

### Instructions to run the project on existing test c files
```
make run
```

### Instructions to clear the intermediary files and output screen
```
make clean
```

### Important Points associated with the output:

1) Trailing newline characters are printed in the output .txt file depending on the size of the input c file
2) If a function name is declared twice, it is implied that the function has a prototype declaration along with its definition
3) User defined structs/unions are not allowed. Typecasts are limited to int-to-float interconversions and vice-versa.