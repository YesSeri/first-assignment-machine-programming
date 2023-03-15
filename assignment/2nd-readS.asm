.ORIG x3000 ; Starting memory address
    LEA R0, MSG         ; Load the address of the message string into R0
    PUTSP               ; Output the message to the console
    JSR readS           ; Call the readS function
    HALT                ; Halts the program

readS                   ; The readS function begins
    ST R1, SAVEREG1     ; Store register R1
    ST R2, SAVEREG2     ; Store register R2
    ST R3, SAVEREG3     ; Store register R3

    AND R2, R2, x0      ; Clear R2
    ADD R3, R2, x5      ; Load the value 5 into R3

    IN                  ; Read in a character
    ADD R1, R2, R0      ; Copy the input character to R1
    IN                  ; Read in another character

    LD R2, CVT          ; Load the value -48 into R2 (used to convert ASCII digits to decimal)
    ADD R0, R0, R2      ; Subtract 48 from the first character (converts it to decimal)
	ADD R1, R1, R2      ; Subtract 48 from the second character (converts it to decimal)
	AND R2, R2, x0      ; Clear R2

                        ;Loop to make "10" digit starts.(Loops 5 times)

LOP ADD R2, R2, R1      ; Add the value in R1 to R2
    ADD R3, R3, x-1     ; Decrement R3 by 1
    BRp LOP             ; Branch back to LOP if R3 is positive

    ADD R2, R2, R2      ; Double the value in R2 (R2, is now the "10" digit. Input 1 is now 10, 2 is 20...)
    ADD R0, R2, R0      ; Add the value in R2 to R0 (R0 contains the input number)

    LD R1, SAVEREG1     ; Restore register R1
    LD R2, SAVEREG2     ; Restore register R2
    LD R3, SAVEREG3     ; Restore register R3

    RET                 ; Return from the subroutine

SAVEREG1    .BLKW 1     ; Reserve memory for SAVEREG1
SAVEREG2    .BLKW 1     ; Reserve memory for SAVEREG2
SAVEREG3    .BLKW 1     ; Reserve memory for SAVEREG3

CVT .FILL #-48          ; Fill memory with -48 (used for converting ASCII digits to decimal)

; Message to display to user: "Input a 2 digit decimal number: "
MSG .FILL b0110111001001001
    .FILL b0111010101110000
    .FILL b0010000001110100
    .FILL b0010000001100001
    .FILL b0010000000110010
    .FILL b0110100101100100
    .FILL b0110100101100111
    .FILL b0010000001110100
    .FILL b0110010101100100
    .FILL b0110100101100011
    .FILL b0110000101101101
    .FILL b0010000001101100
    .FILL b0111010101101110
    .FILL b0110001001101101
    .FILL b0111001001100101
    .FILL b0000000000111010