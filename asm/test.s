; All possible examples

; ADC (ADd with Carry) 
 
ADC #$44
ADC $44
ADC $44,X
ADC $4400
ADC $4400,X
ADC $4400,Y
ADC ($44,X)
ADC ($44),Y

;AND (bitwise AND with accumulator)

AND #$44
AND $44
AND $44,X
AND $4400
AND $4400,X
AND $4400,Y
AND ($44,X)
AND ($44),Y

;ASL (Arithmetic Shift Left)

ASL A
ASL $44
ASL $44,X
ASL $4400
ASL $4400,X

;BIT (test BITs)

BIT $44 
BIT $4400

;BREAK

BRK

;CMP (CoMPare accumulator)

CMP #$44
CMP $44
CMP $44,X
CMP $4400
CMP $4400,X
CMP $4400,Y
CMP ($44,X)
CMP ($44),Y

;CPX (ComPare X register)

CPX #$44
CPX $44
CPX $4400

;CPY (ComPare Y register)

CPY #$44
CPY $44
CPY $4400

;DEC (DECrement memory)

DEC $44
DEC $44,X
DEC $4400
DEC $4400,X

;EOR (bitwise Exclusive OR)

EOR #$44
EOR $44
EOR $44,X
EOR $4400
EOR $4400,X
EOR $4400,Y
EOR ($44,X)
EOR ($44),Y

;Flag (Processor Status) Instructions

CLC
SEC
CLI
SEI
CLV
CLD
SED

;INC (INCrement memory)

INC $44
INC $44,X
INC $4400
INC $4400,X

;JMP (JuMP)

JMP $5597
JMP ($5597)

;JSR (Jump to SubRoutine)

JSR $5597

;LDA (LoaD Accumulator)

LDA #$44
LDA $44
LDA $44,X
LDA $4400
LDA $4400,X
LDA $4400,Y
LDA ($44,X)
LDA ($44),Y

;LDX (LoaD X register)

LDX #$44
LDX $44
LDX $44,Y
LDX $4400
LDX $4400,Y

;LDY (LoaD Y register)

LDY #$44
LDY $44
LDY $44,X
LDY $4400
LDY $4400,X

;LSR (Logical Shift Right)

LSR A
LSR $44
LSR $44,X
LSR $4400
LSR $4400,X

NOP

;ORA (bitwise OR with Accumulator)

ORA #$44
ORA $44
ORA $44,X
ORA $4400
ORA $4400,X
ORA $4400,Y
ORA ($44,X)
ORA ($44),Y

;Register Instructions

TAX
TXA
DEX
INX
TAY
TYA
DEY
INY

;ROL (ROtate Left)

ROL A
ROL $44
ROL $44,X
ROL $4400
ROL $4400,X

;ROR (ROtate Right)

ROR A
ROR $44
ROR $44,X
ROR $4400
ROR $4400,X

RTI
RTS

;SBC (SuBtract with Carry)

SBC #$44
SBC $44
SBC $44,X
SBC $4400
SBC $4400,X
SBC $4400,Y
SBC ($44,X)
SBC ($44),Y

;STA (STore Accumulator)

STA $44
STA $44,X
STA $4400
STA $4400,X
STA $4400,Y
STA ($44,X)
STA ($44),Y

;Stack Instructions

TXS
TSX
PHA
PLA
PHP
PLP

;STX (STore X register)

STX $44 
STX $44,Y
STX $4400
 
;STY (STore Y register)

STY $44
STY $44,X
STY $4400
