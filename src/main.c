#include <stdio.h>

#include "config.h"

extern FILE *yyin;
extern void yyparse(FILE *outputFile);

int main(int argc, char *argv[]) {
    
    printf("ZP6502ASM v%s (\"%s\").\n",VERSION,CODENAME);
    printf("Author: Matteo Pacini <m@matteopacini.me>.\n\n");
    
    if (argc != 3) {
        printf("Usage: ./zp6502asm [INPUT_FILE] [OUTPUT_FILE]\n");
        return 1;
    }
    
    FILE *input = fopen(argv[1], "r");
    
    if (!input) {
        fprintf(stderr, "Could not open input file: \"%s\"!", argv[1]);
        return 1;
    }
    
    FILE *output = fopen(argv[2], "wb");
    
    if (!output) {
        fprintf(stderr, "Could not write to output file: \"%s\"!", argv[1]);
        return 1;
    }
    
    yyin = input;
    
    printf("Parsing source file...\n");
    
    yyparse(output);
    
    fclose(input);
    
    fflush(output);
    fclose(output);
    
    printf("Done!\n");
    
    return 0;
}
