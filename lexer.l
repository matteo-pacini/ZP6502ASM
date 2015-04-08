%{
    ////////////
    // MACROS //
    ////////////

    #define TOKEN(t) (yylval.token = t)
	#define SAVE_MNEMONIC() yylval.mnemonic = strdup(yytext)
	
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

[\n\r\t ]+								/* Eat whitespaces */

";"                                     BEGIN(COMMENT);
<COMMENT>[\n\r]                         BEGIN(INITIAL);
<COMMENT>.*                             /* Eat the current comment */

","										return TOKEN(TCOMMA);
":"										return TOKEN(TCOLON);
"("										return TOKEN(TLPAR);
")"										return TOKEN(TRPAR);
"$"										return TOKEN(TDOLLAR);
"#"										return TOKEN(THASH);

[0-9A-F]{2}								yylval.uint8 = (uint8_t)strtoul(yytext,NULL,16); return TUINT8;
[0-9A-F]{4}								yylval.uint16 = (uint16_t)strtoul(yytext,NULL,16); return TUINT16;

"ADC"									return TOKEN(TADC);
"AND"									return TOKEN(TAND);

"X"										return TOKEN(TREGX);
"Y"										return TOKEN(TREGY);

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
