.ORIG x3000
    AND R3, R3, b0
    ADD R0, R3, xE
    ADD R1, R3, x2
    ;; LEA R0, MSG
    ;; PUTSP
    ;; JSR readS
    ;; JSR isPrime
    JSR divide
    HALT
isPrime

    ADD R1, R0, x-2 ;; We remove 2 to check if number is two. If it is two we return that it is prime.
    BRnp SKP
    ;; Set r0 to 1 to indicate true.
    ADD R0, R1, b1
    RET
SKP AND R1, R0, b1
  ;; If positive we know it is not a prime unless it is 2.
    BRp ODD
    AND R0, R0, b0
    ADD R0, R0, b0
    RET

;; We have an odd number larger than 2. We now need to check if it is prime.
ODD
    AND R1, R0, x0
    ADD R1, R1, x3

    JSR isPrime


    RET

;; Puts result in R4 and quotient in R5
;; Input is R0, number to divide and R1, divisor
;; MIN ADD R4, R4, R3
divide
    AND R4, R4, x0
    AND R5 , R4, x0
    NOT R1, R1
    ADD R1, R1, x1
SUB ADD R4, R4, x1
    ADD R5, R5, R3
    BRp SUB
    ADD R0, R0, R1
    ADD R2, R2, x-1
    STR R2, R6, x2
    STR R0, R6, x3
    HALT
.END
;; read in two digit number
.ORIG x4000
readS
    ST R1, SAVEREG1 ;; save all the registers we use.
    ST R2, SAVEREG2
    ST R3, SAVEREG3
    AND R2, R2, x0

    ADD R3, R2, x5 ;; we use r3, to loop 5 times in LOP
    IN
    ADD R1, R2, R0
    IN
    LD R2, CVT
    ADD R0, R0, R2
	ADD R1, R1, R2
	AND R2, R2, x0

LOP ADD R2, R2, R1 ;; Multiply 10 value by 5, then double to turn 2 -> 20, 3 -> 30 usw
    ADD R3, R3, x-1
    BRp LOP
    ADD R2, R2, R2
    ADD R0, R2, R0
    LD R1, SAVEREG1 ;; restore registers we used.
    LD R2, SAVEREG2
    LD R3, SAVEREG3
    RET
    
SAVEREG1    .BLKW 1
SAVEREG2    .BLKW 1
SAVEREG3    .BLKW 1

CVT .FILL #-48
MSG .STRINGZ "Input a 2 digit decimal number:"
    .END
