.ORIG x3000
    AND R0, R0, x0
    ADD R1, R0, x5
    ST R0, A
    ST R1, B
    AND R0, R0, x0
    AND R1, R0, x0

;; Here it starts, the part before is just preparation
    LD R0, A
    LD R1, B
X   NOT R2, R0
    ADD R2, R2, x1
    ADD R2, R2, R1
    BRnz DONE
    ADD R1, R1, x-1
    ADD R0, R0, x1
    BR X
DONE 
	ST R1, C
    HALT
A   .BLKW 1
B   .BLKW 1
C   .BLKW 1
    .END
