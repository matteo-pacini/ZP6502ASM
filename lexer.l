%{
    /////////////////////////////////////////////////////////////////////////////////////
    //                                                                                 //
    //  The MIT License (MIT)                                                          //
    //                                                                                 //
    //  Copyright (c) 2014 Matteo Pacini                                               //
    //                                                                                 //
    //  Permission is hereby granted, free of charge, to any person obtaining a copy   //
    //  of this software and associated documentation files (the "Software"), to deal  //
    //  in the Software without restriction, including without limitation the rights   //
    //  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      //
    //  copies of the Software, and to permit persons to whom the Software is          //
    //  furnished to do so, subject to the following conditions:                       //
    //                                                                                 //
    //  The above copyright notice and this permission notice shall be included in     //
    //  all copies or substantial portions of the Software.                            //
    //                                                                                 //
    //  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     //
    //  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       //
    //  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    //
    //  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         //
    //  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  //
    //  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN      //
    //  THE SOFTWARE.                                                                  //
    //                                                                                 //
    /////////////////////////////////////////////////////////////////////////////////////
    
    ////////////
    // MACROS //
    ////////////

    #define TOKEN(t) (yylval.token = t)
    
    ///////////
    // BISON //
    ///////////
    
    #import "parser.h"
    
    extern void yyparse(FILE *outputFile);

%}

%option nounput noinput noyywrap
%option caseless

%x COMMENT

%%

[\n\r\t ]+                              /* Eat whitespaces */

";"                                     BEGIN(COMMENT);
<COMMENT>[\n\r]                         BEGIN(INITIAL);
<COMMENT>.*                             /* Eat the current comment */

","                                     return TOKEN(TCOMMA);
":"                                     return TOKEN(TCOLON);
"("                                     return TOKEN(TLPAR);
")"                                     return TOKEN(TRPAR);
"$"                                     return TOKEN(TDOLLAR);
"#"                                     return TOKEN(THASH);

[0-9A-F]{2}                             yylval.uint8 = (uint8_t)strtoul(yytext,NULL,16); return TUINT8;
[0-9A-F]{4}                             yylval.uint16 = (uint16_t)strtoul(yytext,NULL,16); return TUINT16;

"ADC"                                   return TOKEN(TADC);
"AND"                                   return TOKEN(TAND);
"ASL"                                   return TOKEN(TASL);
"BIT"                                   return TOKEN(TBIT);
"BRK"                                   return TOKEN(TBRK);
"CMP"                                   return TOKEN(TCMP);
"CPX"                                   return TOKEN(TCPX);
"CPY"                                   return TOKEN(TCPY);
"DEC"                                   return TOKEN(TDEC);
"EOR"                                   return TOKEN(TEOR);
"CLC"                                   return TOKEN(TCLC);
"SEC"                                   return TOKEN(TSEC);
"CLI"                                   return TOKEN(TCLI);
"SEI"                                   return TOKEN(TSEI);
"CLV"                                   return TOKEN(TCLV);
"CLD"                                   return TOKEN(TCLD);
"SED"                                   return TOKEN(TSED);
"INC"                                   return TOKEN(TINC);

"A"                                     return TOKEN(TREGA);
"X"                                     return TOKEN(TREGX);
"Y"                                     return TOKEN(TREGY);

%%

#define VERSION "0.1"

int main(int argc, char *argv[]) {
    
    printf("ZP6502ASM v" VERSION " - An humble 6502 assembler.\n");
    printf("Author: Matteo Pacini <m@matteopacini.me>.\n\n");
    
    if (argc != 3) {
        printf("Usage: ./zp6502asm [INPUT_FILE] [OUTPUT_FILE]\n");
        return 1;
    }
    
    FILE *input = fopen(argv[1], "r");
    FILE *output = fopen(argv[2], "wb");
    
    yyin = input;
    
    printf("Parsing source file...\n");
    
    do { yyparse(output); } while (!feof(yyin));
    
    fclose(input);
    
    fflush(output);
    fclose(output);
    
    printf("Done!\n");
    
    return 0;
}
