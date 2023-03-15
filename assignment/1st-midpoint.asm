.ORIG x3000
    ;Preperation
    AND R0, R0, x0   ; Clears R0
    ADD R1, R0, x5   ; Adds 5 to R0 and stores the result in R1
    ST R0, A         ; Stores the contents of R0 in memory location A
    ST R1, B         ; Stores the contents of R1 in memory location B
    AND R0, R0, x0   ; Clears R0
    AND R1, R0, x0   ; Clears R1

    ;Program Starts
    LD R0, A         ; Loads the contents of memory location A into R0
    LD R1, B         ; Loads the contents of memory location B into R1

X   NOT R2, R0       ; Takes the bitwise complement of R0 and stores it in R2
    ADD R2, R2, x1   ; Adds 1 to R2
    ADD R2, R2, R1   ; Adds the contents of R1 to R2
    BRnz DONE        ; Branches to DONE if the result of the addition is negative or zero
    ADD R1, R1, x-1  ; Subtracts 1 from R1
    ADD R0, R0, x1   ; Adds 1 to R0
    BR X             ; Branches to X

DONE                 ; Program reaches this point when result has been found
	ST R1, C         ; Stores the contents of R1 in memory location C
    HALT             ; Stops the processor

A   .BLKW 1          ; Reserves memory for A
B   .BLKW 1          ; Reserves memory for B
C   .BLKW 1          ; Reserves memory for C

    .END


