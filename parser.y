%{

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
%token <token> TREGX TREGY
    
%token <token> TADC TAND
    
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
