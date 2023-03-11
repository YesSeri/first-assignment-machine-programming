.ORIG x3d00
LOOP 
	LEA R0, MSG-INPUT
    PUTS
    JSR readS
    JSR isPrime
    JSR resultS
    JSR LOOP
	HALT

    ;; Checks if number is prime
    ;; If number is prime R0 is set to 1, else 0
isPrime
    ;; r1,r2,r3,r4(divide),r5
    ST R1, SAVE2REG1 ;; save registers we will use.
    ST R2, SAVE2REG2
    ST R3, SAVE2REG3
    ST R4, SAVE2REG4 ;; register 4 gets overwritten in divide subroutine
    ST R5, SAVE2REG5
    ST R7, RETURNADDRESS ;; We need to save return address because we overwrite it in our call to JSR divide

    ;; We remove 2 to check if number is two. If it is two we return that it is prime.
    ADD R1, R0, x-2
    BRz PRIME

    ;; If positive we know it is not a prime unless it is 2, which we have already tested for.
    AND R1, R0, x1
    BRz NOTPRIME

    ;; We have an odd number larger than 2. We now need to check if it is prime.
    ;; We know R1 is x1 from AND statment few lines before.
    ;; We will loop for all odd numbers from 3 upto our prime number to test in R0, and see if they ever are evenly divisible.
    ;; If they are not evenly divisible we have a prime number.
    ;; We start at x3, so we add x2 to R1
    AND R2, R2, x0
    ADD R2, R2, x-1
    ;; R2 is the negative inverse of the counter that goes 3, 5, 7... R2 goes -3, -5, -7... We use that to check when  we reach R0, the number we are testing for
    ;; This saves us one operation per loop lap. Else we would need to calculate the inverse by first using NOT on R1, and then ADD R1, R1, x1.
ODD ADD R2, R2, x-2
    ADD R3, R0, R2
    BRz PRIME
    ADD R1, R1, x2

    ;; We divide R0, with R1
    JSR divide

    ;; We use NOT twice to check if number is positive or zero. If zero we don't have a prime number
    NOT R5, R5
    NOT R5, R5
    BRnp ODD

NOTPRIME
    AND R0, R0, x0
    BRnzp RESTOREREG
PRIME
    AND R0, R0, x0
    ADD R0, R0, x1
RESTOREREG
    LD R1, SAVE2REG1 ;; restore registers we used.
    LD R2, SAVE2REG2
    LD R3, SAVE2REG3
    LD R4, SAVE2REG4
    LD R5, SAVE2REG5
    LD R7, RETURNADDRESS
    RET

    ;; Write a function called “resultS” that takes as argument a value stored in R0. If the value in
    ;; R0 is not zero then the function should display on the console the message: “The number is
    ;; prime” else it should display the message “The number is not prime”.
resultS
    NOT R0, R0
    NOT R0, R0
    BRz SKIP
    LEA R0, MSG-IS-PRIME
    PUTS
    RET
SKIP
    LEA R0, MSG-IS-NOT-PRIME
    PUTS
    RET

;;; MESSAGES
MSG-INPUT           .STRINGZ "Input a 2 digit decimal number:"
MSG-IS-PRIME        .STRINGZ "The number is prime.\n"
MSG-IS-NOT-PRIME    .STRINGZ "The number is not prime.\n"

RETURNADDRESS   .BLKW 1
SAVE2REG1       .BLKW 1
SAVE2REG2       .BLKW 1
SAVE2REG3       .BLKW 1
SAVE2REG4       .BLKW 1
SAVE2REG5       .BLKW 1
.END
;; read in two digit number
.ORIG x4000

;; Puts result in R4 and quotient in R5
;; Input is R0, number to divide and R1, divisor
divide
        ST R0, SAVEREG1 ;; save registers we will use.
        ST R1, SAVEREG2
        ST R2, SAVEREG3

        AND R4, R4, x0
        NOT R2, R1
        ADD R2, R2, x1
SUB     ADD R4, R4, x1
        ADD R0, R0, R2
        BRzp SUB
        ADD R4, R4, x-1
        AND R5, R5, x0
        ADD R5, R0, R1

        LD R0, SAVEREG1 ;; restore registers we used.
        LD R1, SAVEREG2
        LD R2, SAVEREG3
        RET
;; Recieves two digit number and saves it to R0
readS
    ST R1, SAVEREG1 ;; save all the registers we use.
    ST R2, SAVEREG2
    ST R3, SAVEREG3
    ST R4, SAVEREG4
    
    AND R2, R2, x0
	ADD R1, R2, x5
    LD R2, CVT
    LEA R4, DIGITS
    
GETNUM	
    GETC
    OUT
    ADD R3, R0, x-A ;; If newline, we stop saving numbers
    BRz LEAVE
    ADD R0, R0, R2
    STR R0, R4, x0
    ADD R4, R4, x1 
    ADD R1, R1, x-1 ;; After 5 digits we leave
    BRz LEAVE
	BRnzp GETNUM
LEAVE
    ;Save R0 in R4 to output new line char
    AND R0, R0, x0 
    ADD R0, R0, xA ;; Newline character
    PUTC ;; Print newline
    
    ADD R3, R3, x0
    ADD R3, R3, x5 ;; we use r3, to loop 5 times in LOP
    ADD R1, R3, x1 ;; R1 is times we have number times 10, When loop finishes 0 for digit 0, 1 for digit 1... 
    ADD R2, R3, x0 ;; R2 is number of times we should multiply current number by 10
    
AGAIN
    AND R5, R5, x0
    LDR R0, R4, x0
    ADD R4, R4, x-1
    ADD R1, R1, x-1
    BRz 

    ADD R5, R5, R1 ;; Multiply 10 value by 5, then double to turn 2 -> 20, 3 -> 30 usw
    ADD R5, R5, R1
    ADD R3, R3, x-1
    BRp TIMES-5
    ADD R2, R2, R2
    ADD R0, R2, R0
    LD R1, SAVEREG1 ;; restore registers we used.
    LD R2, SAVEREG2
    LD R3, SAVEREG3
    LD R3, SAVEREG4
    RET

DIGIT-DONE 

DONE

SAVEREG1    .BLKW 1
SAVEREG2    .BLKW 1
SAVEREG3    .BLKW 1
SAVEREG4    .BLKW 1

DIGITS .BLKW 5

CVT .FILL #-48
    .END
