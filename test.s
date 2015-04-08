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

