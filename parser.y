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

    #include <stdio.h>
    #include <stdint.h>
    
    ///////////
    // YYLEX //
    ///////////
 
    extern int yylex();
 
    /////////////
    // YYERROR //
    /////////////
     
    void yyerror(FILE *outputFile, const char *msg) {
        fprintf(stderr,"An error occurred: \"%s\".", msg);
    }
    
                
    #define EMIT(OC,...)                                                                \
        uint8_t bytes[] = {OC,__VA_ARGS__};                                             \
        fwrite(bytes, sizeof(uint8_t), sizeof(bytes)/sizeof(uint8_t), outputFile);      \
    
%}

%parse-param {FILE *outputFile}
%error-verbose

%union {

    int token;
    uint8_t uint8;
    uint16_t uint16;
}

%token <token> TCOMMA TCOLON TLPAR TRPAR 
%token <token> TDOLLAR THASH
%token <token> TREGA TREGX TREGY
    
%token <token> TADC TAND TASL TBIT TBRK TCMP TCPX TCPY
%token <token> TDEC TEOR TCLC TSEC TCLI TSEI TCLV TCLD TSED
%token <token> TINC
    
%token <uint8> TUINT8
%token <uint16> TUINT16
    
%type <token> register_operand
%type <uint8> immediate_operand zero_page_operand indirect_x_operand indirect_y_operand
%type <uint16> absolute_operand
        
%start source

%%

source : statements
       ;

statements : statement statements
           | statement
           ;

statement : instruction_statement
          ;

instruction_statement : TADC immediate_operand { EMIT(0x69, $2); }
                      | TADC zero_page_operand { EMIT(0x65, $2); }
                      | TADC zero_page_operand TCOMMA TREGX { EMIT(0x75, $2); } 
                      | TADC absolute_operand { EMIT(0x6D, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TADC absolute_operand TCOMMA register_operand { 
                            EMIT($4==TREGX?0x7D:0x79, (uint8_t)($2), (uint8_t)($2 >> 8));
                      } 
                      | TADC indirect_x_operand { EMIT(0x61, $2); }
                      | TADC indirect_y_operand { EMIT(0x71, $2); }
                      | TAND immediate_operand { EMIT(0x29, $2); }
                      | TAND zero_page_operand { EMIT(0x25, $2); }
                      | TAND zero_page_operand TCOMMA TREGX { EMIT(0x35, $2); } 
                      | TAND absolute_operand { EMIT(0x2D, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TAND absolute_operand TCOMMA register_operand { 
                            EMIT($4==TREGX?0x3D:0x39, (uint8_t)($2), (uint8_t)($2 >> 8));
                      } 
                      | TAND indirect_x_operand { EMIT(0x21, $2); }
                      | TAND indirect_y_operand { EMIT(0x31, $2); }
                      | TASL TREGA { EMIT(0x0A); }
                      | TASL zero_page_operand { EMIT(0x06, $2); }
                      | TASL zero_page_operand TCOMMA TREGX { EMIT(0x16, $2); }
                      | TASL absolute_operand { EMIT(0x0E, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TASL absolute_operand TCOMMA TREGX { 
                            EMIT(0x1E, (uint8_t)($2), (uint8_t)($2 >> 8));
                      } 
                      | TBIT zero_page_operand { EMIT(0x24, $2); }
                      | TBIT absolute_operand { EMIT(0x2C, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TBRK { EMIT(0x00); }
                      | TCMP immediate_operand { EMIT(0xC9, $2); }
                      | TCMP zero_page_operand { EMIT(0xC5, $2); }
                      | TCMP zero_page_operand TCOMMA TREGX { EMIT(0xD5, $2); } 
                      | TCMP absolute_operand { EMIT(0xCD, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TCMP absolute_operand TCOMMA register_operand { 
                            EMIT($4==TREGX?0xDD:0xD9, (uint8_t)($2), (uint8_t)($2 >> 8));
                      } 
                      | TCMP indirect_x_operand { EMIT(0xC1, $2); }
                      | TCMP indirect_y_operand { EMIT(0xD1, $2); }
                      | TCPX immediate_operand { EMIT(0xE0, $2); }
                      | TCPX zero_page_operand { EMIT(0xE4, $2); }
                      | TCPX absolute_operand { EMIT(0xEC, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TCPY immediate_operand { EMIT(0xC0, $2); }
                      | TCPY zero_page_operand { EMIT(0xC4, $2); }
                      | TCPY absolute_operand { EMIT(0xCC, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TDEC zero_page_operand { EMIT(0xC6, $2); }
                      | TDEC zero_page_operand TCOMMA TREGX { EMIT(0xD6, $2); } 
                      | TDEC absolute_operand { EMIT(0xCE, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TDEC absolute_operand TCOMMA TREGX { 
                            EMIT(0xDE, (uint8_t)($2), (uint8_t)($2 >> 8));
                      }
                      | TEOR immediate_operand { EMIT(0x49, $2); }
                      | TEOR zero_page_operand { EMIT(0x45, $2); }
                      | TEOR zero_page_operand TCOMMA TREGX { EMIT(0x55, $2); } 
                      | TEOR absolute_operand { EMIT(0x4D, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TEOR absolute_operand TCOMMA register_operand { 
                            EMIT($4==TREGX?0x5D:0x59, (uint8_t)($2), (uint8_t)($2 >> 8));
                      } 
                      | TEOR indirect_x_operand { EMIT(0x41, $2); }
                      | TEOR indirect_y_operand { EMIT(0x51, $2); }
                      | TCLC { EMIT(0x18); }
                      | TSEC { EMIT(0x38); }
                      | TCLI { EMIT(0x58); }
                      | TSEI { EMIT(0x78); }
                      | TCLV { EMIT(0xB8); }
                      | TCLD { EMIT(0xD8); }
                      | TSED { EMIT(0xF8); }
                      | TINC zero_page_operand { EMIT(0xE6, $2); }
                      | TINC zero_page_operand TCOMMA TREGX { EMIT(0xF6, $2); } 
                      | TINC absolute_operand { EMIT(0xEE, (uint8_t)($2), (uint8_t)($2 >> 8)); } 
                      | TINC absolute_operand TCOMMA TREGX { 
                            EMIT(0xFE, (uint8_t)($2), (uint8_t)($2 >> 8));
                      }
                      ;
                
                    
immediate_operand : THASH TDOLLAR TUINT8 {
    
    $$ =  $3;
    
};

zero_page_operand : TDOLLAR TUINT8 {

    $$ = $2;

};

absolute_operand : TDOLLAR TUINT16 {

    $$ = $2;

};

indirect_x_operand : TLPAR TDOLLAR TUINT8 TCOMMA TREGX TRPAR {

    $$ = $3;

};

indirect_y_operand : TLPAR TDOLLAR TUINT8 TRPAR TCOMMA TREGY {

    $$ = $3;

};
                    
register_operand: TREGX { $$ = $1; }
                | TREGY { $$ = $1; }
                ; 
